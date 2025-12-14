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
        raw_body = MailContext._collect_raw_body(msg)
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
    
    # TODO: Improve codestyle of vibecoded method
    @staticmethod
    def _collect_raw_body(msg):
        raw_body = ""
        if msg.is_multipart():
            # Iterate over parts to find the best body candidate
            for part in msg.walk():
                content_type = part.get_content_type()
                content_disposition = str(part.get("Content-Disposition"))

                # Skip attachments
                if "attachment" in content_disposition:
                    continue

                # Prefer HTML, but you can change logic to prefer Plain Text
                if content_type == "text/html":
                    payload = part.get_payload(decode=True)
                    if payload:
                        raw_body = payload.decode('utf-8', errors='replace')
                        break # Found HTML, stop looking
                
                # Fallback: If we haven't found a body yet, take plain text
                elif content_type == "text/plain" and not raw_body:
                    payload = part.get_payload(decode=True)
                    if payload:
                        raw_body = payload.decode('utf-8', errors='replace')
        else:
            # Not multipart, just get the payload directly
            payload = msg.get_payload(decode=True)
            raw_body = payload.decode('utf-8', errors='replace') if payload else ""
        return raw_body