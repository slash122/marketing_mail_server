from pydantic import SecretStr
from pydantic_settings import BaseSettings


# Settings which pull vars from .env file, have default values which can be OVERRIDEN BY .env
class AppSettings(BaseSettings):
    POSTGRES_CONNECTION_STRING: SecretStr
    JWT_KEY: SecretStr
    # TODO: Add logging and tracing
    # LOGGER_NAME: str = "marketing-api-logger"
    # TRACER_NAME: str = "marketing-api-tracer"

    class Config:
        env_file = ".env"


app_settings = AppSettings()
