# FastAPI dependencies, all business logic is in services
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError
from sqlalchemy.ext.asyncio import AsyncSession
from src.db import get_db
from src.models import AccountType, User
from src.security import decode_token
from src.services.users import select_user_account, select_user_by_id

credentials_exception = HTTPException(
    status_code=status.HTTP_401_UNAUTHORIZED,
    detail="Could not validate credentials",
    headers={"WWW-Authenticate": "Bearer"},
)

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/user/login")


# Get user by info from JWT token
async def current_logged_in_user(token: str = Depends(oauth2_scheme), db: AsyncSession = Depends(get_db)):
    try:
        payload = decode_token(token)
        user_id: int = payload.get("uid")
        if user_id is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception

    user = await select_user_by_id(user_id, db)
    if user is None or not user.is_active:
        raise credentials_exception

    return user


async def check_if_admin(current_user: User = Depends(current_logged_in_user), db: AsyncSession = Depends(get_db)):
    account = await select_user_account(current_user, db)
    if not account or not account.account_type == AccountType.ADMIN:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="User does not have enough privileges")

    return current_user
