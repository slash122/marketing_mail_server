from src.jobs.ai_personalization import AiPersonalizationJob
from src.jobs.metrics import MetricsJob
from src.jobs.ai_spam_check import AiSpamCheckJob
from src.jobs.ai_summary import AiSummaryJob
from src.jobs.error import ErrorJob
from src.utils import prepare_envelope
import asyncio
import pdb

class JobLauncher:
    def __init__(self, envelope):
        self.envelope = envelope
        self.email_data = prepare_envelope(envelope)
        self.jobs = self.get_jobs()

    def get_jobs(self):
        return [MetricsJob(self.email_data), AiSpamCheckJob(self.email_data), AiSummaryJob(self.email_data), AiPersonalizationJob(self.email_data), ErrorJob(self.email_data)]

    async def launch_jobs(self):
        results = await asyncio.gather(*(job.execute() for job in self.jobs))
        return results