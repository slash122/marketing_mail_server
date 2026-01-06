from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession
from src.api.dependencies import check_if_admin, current_logged_in_user
from src.db import get_db
from src.models import AccountType, User
from src.schemas import MailHeaderResponse, MailResponse, SenderRegisterPayload, SenderResponse
from src.services.accounts import select_account_by_id
from src.services.senders import (
    check_sender_account_link,
    create_sender,
    select_mail_for_sender,
    select_mail_headers_for_sender,
    select_sender_by_id,
)

router = APIRouter()


@router.get("/sender/{sender_id}", response_model=SenderResponse, status_code=status.HTTP_200_OK)
async def get_sender_by_id(
    sender_id: int, user: User = Depends(current_logged_in_user), db: AsyncSession = Depends(get_db)
):
    account = await select_account_by_id(user.account_id, db)
    if account.account_type != AccountType.ADMIN:
        await check_sender_account_link(sender_id, user.account_id, db)
    return await select_sender_by_id(sender_id, db)


@router.get("/sender/{sender_id}/mails", response_model=list[MailHeaderResponse], status_code=status.HTTP_200_OK)
async def get_mail_headers_for_sender(
    sender_id: int,
    page: int = 0,
    page_size: int = 5,
    user: User = Depends(current_logged_in_user),
    db: AsyncSession = Depends(get_db),
):
    account = await select_account_by_id(user.account_id, db)
    if account.account_type != AccountType.ADMIN:
        await check_sender_account_link(sender_id, user.account_id, db)
    return await select_mail_headers_for_sender(sender_id, page, page_size, db)


@router.get("/sender/{sender_id}/mail/{mail_id}", response_model=MailResponse, status_code=status.HTTP_200_OK)
async def get_mail_for_sender(
    sender_id: int, mail_id: int, user: User = Depends(current_logged_in_user), db: AsyncSession = Depends(get_db)
):
    account = await select_account_by_id(user.account_id, db)
    if account.account_type != AccountType.ADMIN:
        await check_sender_account_link(sender_id, user.account_id, db)
    return await select_mail_for_sender(sender_id, mail_id, db)


@router.post(
    "/senders/register",
    dependencies=[Depends(check_if_admin)],
    response_model=SenderResponse,
    status_code=status.HTTP_201_CREATED,
)
async def register_sender(
    sender_payload: SenderRegisterPayload,
    db: AsyncSession = Depends(get_db),
):
    return await create_sender(sender_payload, db)
