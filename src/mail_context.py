from dataclasses import dataclass, field
from typing import Any, Optional
from email import message_from_bytes
from lxml import etree
import time

@dataclass
class MailContext:
    time_received: int
    sender: str
    recipient: Optional[str]
    raw_email: str
    subject: str
    raw_body: str
    text: str
    etree: Any = field(repr=False)

    

    @classmethod
    def from_envelope(cls, envelope):
        raw_email = envelope.content.decode('unicode_escape', errors='replace')
        msg = message_from_bytes(envelope.content)
        subject = msg.get('Subject', 'No Subject')
        raw_body = msg.get_payload(decode=True).decode('utf-8', errors='replace')
        html_tree = etree.fromstring(raw_body, parser=etree.HTMLParser())
        text_content = etree.tostring(html_tree, method='text', encoding='unicode')

        return cls(
            time_received=int(time.time()),
            sender=envelope.mail_from,
            recipient=envelope.rcpt_tos[0],
            raw_email=raw_email,
            subject=subject,
            raw_body=raw_body,
            etree=html_tree,
            text=text_content
        )