from src.jobs.base_job import EmailJob
from src.utils import perform_ai_request

class ErrorJob(EmailJob):
    async def run(self):
        raise Exception("Deliberate error for testing purposes")
        return 'asdasd'