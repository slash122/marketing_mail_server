import asyncio
import importlib
from pathlib import Path

class JobExecutor:
    _job_classes = None

    def __init__(self, mail_context):
        self.mail_context = mail_context

    async def execute_jobs(self):
        results = await asyncio.gather(*(job.execute() for job in self.create_jobs()))
        return results

    def create_jobs(self):
        return [job_class(self.mail_context) for job_class in self._job_classes]

    @classmethod
    def get_job_classes(cls):        
        if cls._job_classes is not None:
            return cls._job_classes

        jobs_dir = Path(__file__).parent / 'jobs'
        job_classes = []

        # Pre-filter files to avoid unnecessa87 ry globbing overhead if directory is large
        # though glob is generally fast enough for typical source trees.
        # The main bottleneck is importlib.import_module.
        
        for file in jobs_dir.glob('*.py'):
            if file.name.startswith('_'):
                continue
            
            module_name = f'src.jobs.{file.stem}'
            
            try:
                module = importlib.import_module(module_name)
            except ImportError:
                continue
            
            # inspect.getmembers can be slow because it retrieves all members.
            # Iterating over module.__dict__ is faster.
            for name, obj in module.__dict__.items():
                if (isinstance(obj, type) and 
                    name.endswith('Job') and 
                    obj.__module__ == module_name):
                    job_classes.append(obj)
        
        cls._job_classes = job_classes
        return cls._job_classes

JobExecutor.get_job_classes()
    