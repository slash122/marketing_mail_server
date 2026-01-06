from sqlalchemy import create_engine
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
from sqlmodel import SQLModel
from src.app_settings import app_settings
from src.models import MailPostgres


class PostgresConnector:
    def __init__(self):
        self.engine = create_async_engine(
            f"postgresql+asyncpg://{app_settings.POSTGRES_CONNECTION_STRING.get_secret_value()}"
        )
        self.async_session = sessionmaker(self.engine, class_=AsyncSession, expire_on_commit=False)
        if app_settings.INIT_DB_ON_STARTUP:
            self.init_db()

    def init_db(self):
        sync_engine = create_engine(
            f"postgresql+psycopg2://{app_settings.POSTGRES_CONNECTION_STRING.get_secret_value()}".replace(
                "ssl=require", "sslmode=require"
            )
        )
        SQLModel.metadata.create_all(sync_engine)

    async def save_email(self, mail: MailPostgres):
        async with self.async_session() as session:
            session.add(mail)
            await session.commit()
            return mail.id


postgres_db = PostgresConnector()
