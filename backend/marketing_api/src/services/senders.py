from typing import Optional

from fastapi import HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from src.models import Mail, Sender, SenderAccountLink
from src.schemas import SenderRegisterPayload


async def select_sender_by_id(sender_id: int, db: AsyncSession) -> Optional[Sender]:
    result = await db.execute(select(Sender).where(Sender.id == sender_id))
    sender = result.scalars().first()
    await _check_sender(sender)
    return sender


async def check_sender_account_link(sender_id: int, account_id: int, db: AsyncSession) -> bool:
    link = await select_sender_account_link(sender_id, account_id, db)
    if not link:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="User does not have access to this sender or sender does not exist",
        )


# TODO: Fix to use Sender.mails
async def select_mail_headers_for_sender(sender_id: int, page: int, page_size: int, db: AsyncSession) -> list:
    skip = page * page_size
    limit = page_size
    result = await db.execute(
        select(Mail)
        .where(Mail.sender == (await select_sender_by_id(sender_id, db)).mail_address)
        .offset(skip)
        .limit(limit)
    )
    return result.scalars().all()


async def select_mail_for_sender(sender_id: int, mail_id: int, db: AsyncSession) -> Optional[Mail]:
    sender = await select_sender_by_id(sender_id, db)
    mail = await _select_mail_by_id(mail_id, db)
    if mail is None or mail.sender != sender.mail_address:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Mail not found for this sender")
    return mail


async def create_sender(payload: SenderRegisterPayload, db: AsyncSession) -> Sender:
    existing_sender = await _select_sender_by_mail_address(payload.mail_address, db)
    if existing_sender:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST, detail="Sender with this mail address already exists"
        )

    new_sender = _create_sender_object(payload)
    created_sender = await _insert_sender_to_db(new_sender, db)
    return created_sender


async def _select_sender_by_mail_address(mail_address: str, db: AsyncSession) -> Optional[Sender]:
    result = await db.execute(select(Sender).where(Sender.mail_address == mail_address))
    return result.scalars().first()


async def _select_mail_by_id(mail_id: int, db: AsyncSession):
    result = await db.execute(select(Mail).where(Mail.id == mail_id))
    return result.scalars().first()


async def select_sender_account_link(sender_id: int, account_id: int, db: AsyncSession) -> bool:
    result = await db.execute(
        select(SenderAccountLink).where(
            SenderAccountLink.sender_id == sender_id, SenderAccountLink.account_id == account_id
        )
    )
    return result.scalars().first()


async def _check_sender(sender: Sender):
    if not sender:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Sender does not exist")


def _create_sender_object(payload: SenderRegisterPayload) -> Sender:
    return Sender(name=payload.name, mail_address=payload.mail_address, info=payload.info, is_active=True)


async def _insert_sender_to_db(sender: Sender, db: AsyncSession) -> Sender:
    db.add(sender)
    await db.commit()
    await db.refresh(sender)
    return sender
