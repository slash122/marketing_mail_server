from sqlmodel import SQLModel, create_engine
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
from src.app_settings import app_settings
from src.models import MailPostgres

class PostgresConnector:
    def __init__(self):
        self.engine = create_async_engine(f"postgresql+asyncpg://{app_settings.POSTGRES_CONNECTION_STRING}")
        self.async_session = sessionmaker(
            self.engine, class_=AsyncSession, expire_on_commit=False
        )

    async def save_email(self, mail: MailPostgres):
        async with self.async_session() as session:
            session.add(mail)
            await session.commit()
            return mail.id

postgres_db = PostgresConnector()
