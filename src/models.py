from typing import Optional, Dict, List, Any
from sqlmodel import SQLModel, Field, JSON
from sqlalchemy import Column
from enum import Enum
from src.mail_context import MailContext

class MailState(str, Enum):
    RECEIVED = "received"
    PROCESSED = "processed"
    FAILED = "failed"

class MailBase(SQLModel):
    time_received: int
    sender: str
    recipient: str
    subject: str
    body: str
    raw_email: str
    job_results: Optional[Dict[str, Any]] = Field(default=None, sa_column=Column(JSON))
    errors: Optional[List[Dict[str, Any]]] = Field(default=None, sa_column=Column(JSON))
    state: MailState = Field(default=MailState.RECEIVED, index=True)
    
    def to_dict(self):
        return self.model_dump()

    @classmethod
    def from_context(cls, mail_context: MailContext):
        return cls(
            time_received = mail_context.time_received,
            sender = mail_context.sender,
            recipient = mail_context.recipient,
            subject = mail_context.subject,
            body = mail_context.raw_body, 
            raw_email = mail_context.raw_email,
            state = MailState.RECEIVED,
        )
    
    def append_job_results(self, raw_job_results: List[Dict[str, Any]]):
        prepared_results, errors = self._prepare_job_results(raw_job_results)
        self.job_results = prepared_results
        self.errors = errors
        self.state = MailState.FAILED if errors else MailState.PROCESSED

    @staticmethod
    def _prepare_job_results(raw_job_results):
        prepared_results = {}
        errors = []
        for result_pair in raw_job_results:
            if 'exception' in result_pair:
                errors.append(result_pair)
            else:
                prepared_results[result_pair['job_name']] = result_pair['result']
        errors = errors if errors else None
        return prepared_results, errors


class MailSQLite(MailBase, table=True):
    __tablename__ = "mail_data"
    
    id: Optional[int] = Field(default=None, primary_key=True)
    external_id: Optional[int] = Field(default=None, index=True)