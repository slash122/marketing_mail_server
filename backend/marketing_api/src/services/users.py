from typing import Optional

from fastapi import HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from src.models import Account, User
from src.schemas import UserRegisterPayload
from src.security import get_password_hash, verify_password

# TODO: Change HTTPExceptions to custom exceptions


async def create_user(payload: UserRegisterPayload, db: AsyncSession) -> User:
    existing_user = await _select_user_by_username(payload.username, db)
    if existing_user:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="User already registered")

    new_user = _create_user_object(payload)
    created_user = await _insert_user_into_db(new_user, db)
    return created_user


async def get_user_by_credentials(username: str, password: str, db: AsyncSession) -> User:
    user = await _select_user_by_username(username, db)
    if not user or not verify_password(password, user.hashed_password):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Incorrect username or password")

    if not user.is_active:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="User account is inactive")

    user_account = await select_user_account(user, db)
    if not user_account or not user_account.is_active:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Associated account is inactive")

    return user


async def select_user_by_id(user_id: int, db: AsyncSession) -> Optional[User]:
    result = await db.execute(select(User).where(User.id == user_id))
    return result.scalars().first()


async def _select_user_by_username(username: str, db: AsyncSession) -> Optional[User]:
    result = await db.execute(select(User).where(User.username == username))
    return result.scalars().first()


async def select_user_account(user: User, db: AsyncSession) -> Account:
    result = await db.execute(select(Account).where(Account.id == user.account_id))
    return result.scalars().first()


def _create_user_object(payload: UserRegisterPayload) -> User:
    return User(
        username=payload.username,
        hashed_password=get_password_hash(payload.password),
        info=payload.info,
        is_active=True,
        account_id=payload.account_id,
    )


async def _insert_user_into_db(user: User, db: AsyncSession) -> User:
    db.add(user)
    await db.commit()
    await db.refresh(user)
    return user
