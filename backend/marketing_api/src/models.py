from datetime import datetime
from enum import Enum
from typing import Any, Dict, List, Optional

from sqlalchemy import Text
from sqlmodel import JSON, Column, Field, Relationship, SQLModel


class SenderAccountLink(SQLModel, table=True):
    __tablename__ = "sender_account_link"

    sender_id: int = Field(default=None, foreign_key="sender.id", primary_key=True)
    account_id: int = Field(default=None, foreign_key="account.id", primary_key=True)


class AccountType(str, Enum):
    ADMIN = "admin"
    DEFAULT = "default"


class Account(SQLModel, table=True):
    __tablename__ = "account"

    id: Optional[int] = Field(default=None, primary_key=True)
    name: str = Field(index=True, unique=True)
    info: str = Field(sa_column=Column("info", Text))
    is_active: bool = Field(default=True)
    account_type: AccountType = Field(default=AccountType.DEFAULT)

    users: List["User"] = Relationship(back_populates="account")  # type: ignore
    senders: List["Sender"] = Relationship(back_populates="accounts", link_model=SenderAccountLink)  # type: ignore


class Sender(SQLModel, table=True):
    __tablename__ = "sender"

    id: Optional[int] = Field(default=None, primary_key=True)
    name: str = Field(index=True, unique=True)
    mail_address: str = Field(index=True, unique=True)
    info: str = Field(sa_column=Column("info", Text))

    accounts: List["Account"] = Relationship(back_populates="senders", link_model=SenderAccountLink)  # type: ignore
    mails: List["Mail"] = Relationship(
        back_populates="sender_model",
        sa_relationship_kwargs={"primaryjoin": "foreign(Mail.sender) == Sender.mail_address"},
    )


class MailState(str, Enum):
    RECEIVED = "received"
    PROCESSED = "processed"
    FAILED = "failed"


# TODO: Move shared logic from mail server to separate directory/package
class Mail(SQLModel, table=True):
    __tablename__ = "mail"

    id: Optional[int] = Field(default=None, primary_key=True)
    time_received: datetime
    sender: str
    recipient: str
    subject: str
    state: MailState = Field(default=MailState.RECEIVED, index=True)
    body_url: str
    raw_email_url: str
    job_results: Optional[Dict[str, Any]] = Field(default=None, sa_column=Column(JSON))
    errors: Optional[List[Dict[str, Any]]] = Field(default=None, sa_column=Column(JSON))

    sender_model: Optional[Sender] = Relationship(
        back_populates="mails",
        sa_relationship_kwargs={
            "primaryjoin": "foreign(Mail.sender) == Sender.mail_address",
            "uselist": False,
            "viewonly": True,
        },
    )


class User(SQLModel, table=True):
    __tablename__ = "user"

    id: Optional[int] = Field(default=None, primary_key=True)
    username: str = Field(index=True, unique=True)
    info: str = Field(sa_column=Column("info", Text))
    hashed_password: str
    is_active: bool = Field(default=True)
    account_id: int = Field(foreign_key="account.id")

    account: Account = Relationship(back_populates="users")  # type: ignore
