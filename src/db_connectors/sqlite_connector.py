from sqlmodel import SQLModel, select, create_engine
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
from src.app_settings import app_settings
from src.models import MailSQLite, MailState

class SQLiteConnector:
    def __init__(self):
        self.async_engine = create_async_engine(f"sqlite+aiosqlite:///{app_settings.SQLITE_DB_PATH}")
        self.async_session = sessionmaker(
            self.async_engine, class_=AsyncSession, expire_on_commit=False
        )
        self.__init_db()

    def __init_db(self):
        sync_engine = create_engine(f"sqlite:///{app_settings.SQLITE_DB_PATH}")
        SQLModel.metadata.create_all(
            sync_engine, 
            tables=[MailSQLite.__table__]
        )
        sync_engine.dispose()

    async def save_email(self, mail: MailSQLite) -> MailSQLite:
        async with self.async_session() as session:
            session.add(mail)
            await session.commit()
            await session.refresh(mail)
            return mail
        
    async def update_email(self, mail: MailSQLite) -> None:
        async with self.async_session() as session:
            await session.merge(mail)
            await session.commit()

    async def get_unprocessed_emails(self):
        """Finds emails that were received but not processed (Recovery)."""
        async with self.async_session() as session:
            statement = select(MailSQLite).where(MailSQLite.state == MailState.RECEIVED)
            results = await session.exec(statement)
            return results.all()

sqlite_db = SQLiteConnector()