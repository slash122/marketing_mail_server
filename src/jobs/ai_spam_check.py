from src.jobs.base_job import EmailJob
from src.utils import perform_ai_request

class AiSpamCheckJob(EmailJob):
    async def run(self):
        prompt = f"Check the following email content for spam indicators and provide ONLY a True or False answer:\n\n{self.text}"
        return await perform_ai_request(prompt)