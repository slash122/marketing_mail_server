from typing import Optional

from fastapi import HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from src.models import Account, AccountType, Sender, SenderAccountLink
from src.schemas import AccountRegisterPayload
from src.services.senders import select_sender_account_link, select_sender_by_id

# TODO: Change HTTPExceptions to custom exceptions


async def create_account(payload: AccountRegisterPayload, db: AsyncSession) -> Account:
    existing_account = await _select_account_by_name(payload.name, db)
    if existing_account:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Account with this name already exists")

    new_account = _create_account_object(payload)
    created_account = await _insert_account_to_db(new_account, db)
    return created_account


async def select_all_accounts(page: int, page_size: int, db: AsyncSession) -> list[Account]:
    skip = page * page_size
    limit = page_size
    result = await db.execute(select(Account).offset(skip).limit(limit))
    return result.scalars().all()


async def get_account_senders(account_id: int, page: int, page_size: int, db: AsyncSession) -> list:
    skip = page * page_size
    limit = page_size
    account = await select_account_by_id(account_id, db)
    if account.account_type == "ADMIN":
        return await _select_all_senders(skip, limit, db)

    return await _select_senders_for_account(account_id, skip, limit, db)


async def add_senders_to_account(account_id: int, sender_ids: list[int], db: AsyncSession):
    account = await select_account_by_id(account_id, db)
    _check_account(account)
    for sender_id in sender_ids:
        await select_sender_by_id(sender_id, db)  # raises exception if sender is invalid
        link = await select_sender_account_link(sender_id, account_id, db)
        if not link:
            await _insert_sender_account_link(account_id, sender_id, db)


async def select_account_by_id(account_id: int, db: AsyncSession) -> Optional[Account]:
    result = await db.execute(select(Account).where(Account.id == account_id))
    account = result.scalars().first()
    _check_account(account)
    return account


async def _select_account_by_name(name: str, db: AsyncSession) -> Optional[Account]:
    result = await db.execute(select(Account).where(Account.name == name))
    account = result.scalars().first()
    return account


def _create_account_object(payload: AccountRegisterPayload) -> Account:
    return Account(name=payload.name, info=payload.info, is_active=True, account_type=AccountType.DEFAULT)


async def _insert_account_to_db(account: Account, db: AsyncSession) -> Account:
    db.add(account)
    await db.commit()
    await db.refresh(account)
    return account


async def _select_all_senders(skip: int, limit: int, db: AsyncSession) -> list[Sender]:
    result = await db.execute(select(Sender).offset(skip).limit(limit))
    return result.scalars().all()


async def _select_senders_for_account(account_id: int, skip: int, limit: int, db: AsyncSession) -> list[Sender]:
    query = select(Sender).join(Sender.accounts).where(Account.id == account_id).offset(skip).limit(limit)

    result = await db.execute(query)
    return result.scalars().all()


async def _insert_sender_account_link(account_id: int, sender_id: int, db: AsyncSession):
    link = SenderAccountLink(account_id=account_id, sender_id=sender_id)
    db.add(link)
    await db.commit()


def _check_account(account: Account):
    if not account or not account.is_active:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="No such account or account is inactive")
