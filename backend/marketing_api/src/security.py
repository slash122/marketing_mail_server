from datetime import datetime, timedelta, timezone

from jose import jwt
from pwdlib import PasswordHash
from src.app_settings import app_settings

password_hash = PasswordHash.recommended()


def verify_password(plain_password: str, hashed_password: str) -> bool:
    return password_hash.verify(plain_password, hashed_password)


def get_password_hash(password: str) -> str:
    return password_hash.hash(password)


def decode_token(token: str) -> dict:
    payload = jwt.decode(token, app_settings.JWT_KEY.get_secret_value(), algorithms=["HS256"])
    return payload


def create_access_token(data: dict, expires_delta: timedelta | None = None) -> str:
    to_encode = data.copy()

    if expires_delta:
        expire = datetime.now(timezone.utc) + expires_delta
    else:
        expire = datetime.now(timezone.utc) + timedelta(minutes=180)

    to_encode.update({"exp": expire, "type": "access"})

    encoded_jwt = jwt.encode(to_encode, app_settings.JWT_KEY.get_secret_value(), algorithm="HS256")
    return encoded_jwt
