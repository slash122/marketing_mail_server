from pydantic_settings import BaseSettings
from pydantic import SecretStr

# Settings which pull vars from .env file, have default values which can be OVERRIDEN BY .env
class AppSettings(BaseSettings):
    AI_MODEL_NAME: str = "gemini-2.5-flash-lite"
    AI_API_KEY: SecretStr
    MOCK_RESPONSES: bool = False
    SMTP_PORT: int = 1025
    SMTP_HOST: str = "0.0.0.0"
    SQLITE_DB_PATH: str = "./db/mail_retention.db"
    POSTGRES_CONNECTION_STRING: SecretStr
    AZURE_STORAGE_CONNECTION_STRING: SecretStr
    AZURE_BLOB_CONTAINER_NAME: str = "mail-content-container"
    LOGGER_NAME: str = "marketing-mail-server-logger"
    TRACER_NAME: str = "marketing-mail-server-tracer"
    AZURE_LOGGING: bool = False
    AZURE_INSIGHTS_CONNECTION_STRING: SecretStr
    
    class Config:
        env_file = ".env"

app_settings = AppSettings()