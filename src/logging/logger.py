import logging
import sys
from azure.monitor.opentelemetry import configure_azure_monitor
from src.app_settings import app_settings


if app_settings.AZURE_LOGGING:
    configure_azure_monitor(
        logger_name=app_settings.LOGGER_NAME,
        connection_string=app_settings.AZURE_INSIGHTS_CONNECTION_STRING.get_secret_value()
    )
    
logger = logging.getLogger(app_settings.LOGGER_NAME)
logger.setLevel(logging.INFO)

console_handler = logging.StreamHandler(sys.stdout)
console_handler.setLevel(logging.INFO)
console_formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
console_handler.setFormatter(console_formatter)

logger.addHandler(console_handler)