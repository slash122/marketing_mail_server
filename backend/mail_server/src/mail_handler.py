import asyncio

from common.tracing import TracingWrapper

from src.app_settings import app_settings
from src.db_connectors.blob_storage_connector import blob_storage
from src.db_connectors.postgres_connector import postgres_db
from src.db_connectors.sqlite_connector import sqlite_db
from src.job_executor import JobExecutor
from src.logging import logger
from src.mail_context import MailContext
from src.models import MailPostgres, MailSQLite, MailState


class MailHandler:
    async def handle_DATA(self, server, session, envelope):
        try:
            logger.info(f"New message, from: {envelope.mail_from}, to: {envelope.rcpt_tos}")
            asyncio.create_task(process_email(envelope))
        except Exception as e:
            logger.critical(f"Critical pipeline error: {e}")
        return "250 OK"


tracer = TracingWrapper(app_settings=app_settings)  # Pass app_settings if needed


@tracer.trace_async
async def process_email(envelope):
    mail_context = MailContext.from_envelope(envelope)

    mail_data = await save_to_retention_db(mail_context)
    logger.info(f"Saved email to retention DB, retention db id: {mail_data.id}")

    mail_data = await core_processing(mail_data, mail_context)
    logger.info(f"Completed jobs for mail, from: {mail_context.sender}, retention db id: {mail_data.id}")

    await save_to_main_db(mail_data)
    if mail_data.state == MailState.PROCESSED:
        logger.info(f"Finished pipeline for mail, from: {mail_context.sender}, main db id: {mail_data.external_id}")
    else:
        logger.error(
            f"Some jobs failed for mail, from: {mail_context.sender}, retention db id: {mail_data.id}, errors: {mail_data.errors}"
        )


@tracer.trace_async
async def save_to_retention_db(mail_context) -> MailSQLite:
    mail_data = MailSQLite.from_context(mail_context)
    mail_data = await sqlite_db.save_email(mail_data)
    return mail_data


@tracer.trace_async
async def core_processing(mail_data: MailSQLite, mail_context: MailContext):
    results = await JobExecutor(mail_context).execute_jobs()
    mail_data.append_job_results(results)
    await sqlite_db.update_email(mail_data)
    return mail_data


@tracer.trace_async
async def save_to_main_db(mail_data: MailSQLite):
    raw_email_url, body_url = await blob_storage.save_email_blobs(mail_data.raw_email, mail_data.body)
    mail_data_main = MailPostgres.from_sqlite_model(mail_data, raw_email_url, body_url)
    mail_id = await postgres_db.save_email(mail_data_main)
    mail_data.external_id = mail_id
    await sqlite_db.update_email(mail_data)
