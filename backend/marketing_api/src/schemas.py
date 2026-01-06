from datetime import datetime

from pydantic import BaseModel, EmailStr
from src.models import AccountType


class UserRegisterPayload(BaseModel):
    username: EmailStr
    password: str
    account_id: int
    info: str | None = None


class UserRegisterResponse(BaseModel):
    id: int
    username: EmailStr
    is_active: bool
    account_id: int

    class Config:
        from_attributes = True


class AccountRegisterPayload(BaseModel):
    name: str
    info: str | None = None


class AccountResponse(BaseModel):
    id: int
    name: str
    info: str | None = None
    is_active: bool
    account_type: AccountType

    class Config:
        from_attributes = True


class SenderRegisterPayload(BaseModel):
    name: str
    mail_address: EmailStr
    info: str | None = None


class SenderResponse(BaseModel):
    id: int
    name: str
    mail_address: str
    info: str | None = None

    class Config:
        from_attributes = True


class MailHeaderResponse(BaseModel):
    id: int
    time_received: datetime
    sender: str
    subject: str

    class Config:
        from_attributes = True


class MailResponse(BaseModel):
    id: int
    time_received: datetime
    sender: str
    recipient: str
    subject: str
    state: str
    body_url: str
    raw_email_url: str
    job_results: dict | None = None
    errors: list[dict] | None = None

    class Config:
        from_attributes = True
