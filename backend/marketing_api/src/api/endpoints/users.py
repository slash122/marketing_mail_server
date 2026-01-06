from fastapi import APIRouter, Depends, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.ext.asyncio import AsyncSession
from src.api.dependencies import check_if_admin
from src.db import get_db
from src.schemas import UserRegisterPayload, UserRegisterResponse
from src.security import create_access_token
from src.services.users import create_user, get_user_by_credentials

router = APIRouter()


@router.post("/user/login")
async def login_user(auth_form: OAuth2PasswordRequestForm = Depends(), db: AsyncSession = Depends(get_db)):
    user = await get_user_by_credentials(auth_form.username, auth_form.password, db)
    access_token = create_access_token(data={"sub": user.username, "uid": user.id, "aid": user.account_id})
    return {"access_token": access_token, "token_type": "bearer"}


@router.post(
    "/users/register",
    dependencies=[Depends(check_if_admin)],
    response_model=UserRegisterResponse,
    status_code=status.HTTP_201_CREATED,
)
async def register_user(
    payload: UserRegisterPayload,
    db: AsyncSession = Depends(get_db),
):
    return await create_user(payload, db)


# @router.post("/register-account", response_model=AccountRegisterResponse, status_code=status.HTTP_201_CREATED)
# async def register_account(
#     account_payload: AccountRegisterPayload,
#     db: AsyncSession = Depends(get_db)
# ):
#     return await register_account(account_payload, db)
