from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession
from src.api.dependencies import check_if_admin, current_logged_in_user
from src.db import get_db
from src.models import User
from src.schemas import AccountRegisterPayload, AccountResponse, SenderResponse
from src.services.accounts import (
    add_senders_to_account,
    create_account,
    get_account_senders,
    select_account_by_id,
    select_all_accounts,
)

router = APIRouter()


@router.get("/account", response_model=AccountResponse, status_code=status.HTTP_200_OK)
async def get_account(user: User = Depends(current_logged_in_user), db: AsyncSession = Depends(get_db)):
    return await select_account_by_id(user.account_id, db)


@router.get("/account/senders", response_model=list[SenderResponse], status_code=status.HTTP_200_OK)
async def get_senders_for_current_user_account(
    page: int = 0, page_size: int = 5, db: AsyncSession = Depends(get_db), user: User = Depends(current_logged_in_user)
):
    return await get_account_senders(user.account_id, page, page_size, db)


@router.get(
    "/accounts",
    dependencies=[Depends(check_if_admin)],
    response_model=list[AccountResponse],
    status_code=status.HTTP_200_OK,
)
async def get_all_accounts(
    page: int = 0,
    page_size: int = 5,
    db: AsyncSession = Depends(get_db),
):
    return await select_all_accounts(page, page_size, db)


@router.post(
    "/accounts/register",
    dependencies=[Depends(check_if_admin)],
    response_model=AccountResponse,
    status_code=status.HTTP_201_CREATED,
)
async def register_account(
    account_payload: AccountRegisterPayload,
    db: AsyncSession = Depends(get_db),
):
    return await create_account(account_payload, db)


@router.get(
    "/accounts/{account_id}",
    dependencies=[Depends(check_if_admin)],
    response_model=AccountResponse,
    status_code=status.HTTP_200_OK,
)
async def account_by_id(
    account_id: int,
    db: AsyncSession = Depends(get_db),
):
    return await select_account_by_id(account_id, db)


@router.get(
    "/accounts/{account_id}/senders",
    dependencies=[Depends(check_if_admin)],
    response_model=list[SenderResponse],
    status_code=status.HTTP_200_OK,
)
async def get_senders_for_account_by_id(
    account_id: int,
    page: int = 0,
    page_size: int = 5,
    db: AsyncSession = Depends(get_db),
):
    return await get_account_senders(account_id, page, page_size, db)


@router.post("/accounts/{account_id}/senders", dependencies=[Depends(check_if_admin)], status_code=status.HTTP_200_OK)
async def add_senders_to_account_by_id(
    account_id: int,
    sender_ids: list[int],
    db: AsyncSession = Depends(get_db),
):
    await add_senders_to_account(account_id, sender_ids, db)
