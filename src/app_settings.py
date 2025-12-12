from pydantic_settings import BaseSettings

# Settings which pull vars from .env file, have default values which can be overridden in .env
class AppSettings(BaseSettings):
    AI_MODEL_NAME: str = "gemini-2.5-flash-lite"
    AI_API_KEY: str
    MOCK_RESPONSES: bool = False
    SMTP_PORT: int = 1025
    SMTP_HOST: str = "0.0.0.0"

    class Config:
        env_file = ".env"

app_settings = AppSettings()