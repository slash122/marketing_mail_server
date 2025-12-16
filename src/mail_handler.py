from rich import print
from src.job_executor import JobExecutor
from src.mail_context import MailContext
from src.db_connectors.sqlite_connector import sqlite_db
from src.db_connectors.postgres_connector import postgres_db
from src.db_connectors.blob_storage_connector import blob_storage
from src.models import MailSQLite, MailPostgres, MailState
import threading
import asyncio

class MailHandler:
    async def handle_DATA(self, server, session, envelope):
        print(f"[blue]Received on thread: {threading.get_ident()}[/blue]")
        print("Message from:", envelope.mail_from)
        print("Message to:", envelope.rcpt_tos)
        asyncio.create_task(process_email(envelope))
        return '250 OK'
    
    
async def process_email(envelope):
    mail_data, mail_context = await save_to_retention_db(envelope)
    mail_data = await core_processing(mail_data, mail_context)
    if mail_data.state == MailState.PROCESSED:
        await save_to_main_db(mail_data)
    print("Finished pipeline for mail, from: ", envelope.mail_from)

async def save_to_retention_db(envelope):
    mail_context = MailContext.from_envelope(envelope)
    mail_data = MailSQLite.from_context(mail_context)
    mail_data = await sqlite_db.save_email(mail_data)
    return mail_data, mail_context

async def core_processing(mail_data: MailSQLite, mail_context: MailContext):
    results = await JobExecutor(mail_context).execute_jobs()
    mail_data.append_job_results(results)
    await sqlite_db.update_email(mail_data)
    return mail_data

async def save_to_main_db(mail_data: MailSQLite):
    raw_email_url, body_url = await blob_storage.save_email_blobs(mail_data.raw_email, mail_data.body)
    mail_data_main = MailPostgres.from_sqlite_model(mail_data, raw_email_url, body_url)
    mail_id = await postgres_db.save_email(mail_data_main)
    mail_data.external_id = mail_id
    await sqlite_db.update_email(mail_data)
