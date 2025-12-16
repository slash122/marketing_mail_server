from src.mail_handler import MailHandler
from aiosmtpd.controller import Controller
from src.app_settings import app_settings
from src.logging.logger import logger

mail_smtp_server = Controller(MailHandler(), hostname=app_settings.SMTP_HOST, port=app_settings.SMTP_PORT)
if __name__ == "__main__":
    logger.info(f"SMTP Server starting on {app_settings.SMTP_HOST}:{app_settings.SMTP_PORT}")
    mail_smtp_server.start()
    logger.info(f"SMTP Server started on {app_settings.SMTP_HOST}:{app_settings.SMTP_PORT}")
    while True:
        pass

