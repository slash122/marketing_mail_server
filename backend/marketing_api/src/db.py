from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
from src.app_settings import app_settings


def create_db_url(connection_string: str) -> str:
    return f"postgresql+asyncpg://{connection_string}"


engine = create_async_engine(
    create_db_url(app_settings.POSTGRES_CONNECTION_STRING.get_secret_value()), echo=True, future=True
)

AsyncSessionLocal = sessionmaker(
    bind=engine,
    class_=AsyncSession,
    expire_on_commit=False,
    autoflush=False,
)


async def get_db():
    async with AsyncSessionLocal() as session:
        try:
            yield session
            await session.commit()
        except Exception:
            await session.rollback()
            raise
        finally:
            await session.close()
