import smtplib
from email.message import EmailMessage

msg = EmailMessage()
with open("test_email.txt", "r") as f:
    msg.set_content(f.read())
msg["Subject"] = "Test Email"
msg["From"] = "sender@example.com"
msg["To"] = "receiver@example.com"

try:
    with smtplib.SMTP("0.0.0.0", 1025) as server:
        server.send_message(msg)
except Exception:
    with smtplib.SMTP("localhost", 25) as server:
        server.send_message(msg)
