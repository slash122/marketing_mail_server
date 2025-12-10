from rich import print
from src.job_launcher import JobLauncher
import threading

class MailHandler:
    async def handle_DATA(self, server, session, envelope):
        print(f"[blue]Received on thread: {threading.get_ident()}[/blue]")
        print("Message from:", envelope.mail_from)
        print("Message to:", envelope.rcpt_tos)
        await MailHandler.process_email(envelope)
        return '250 OK'
    
    async def process_email(envelope):
        print("Processing email asynchronously...")
        job_launcher = JobLauncher(envelope)
        results = await job_launcher.launch_jobs()
        print(results)
        print("Email processed.")
        