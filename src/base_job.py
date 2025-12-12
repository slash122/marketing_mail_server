from abc import ABC, abstractmethod
import sys
import os
import traceback
from src.app_settings import app_settings

class EmailJob(ABC):
    def __init__(self, email_data):
        self.raw_email = email_data['raw_email']
        self.raw_body = email_data['raw_body']
        self.etree = email_data['etree']
        self.text = email_data['text']

    async def execute(self):
        try:
            result = await (self.mock_run() if app_settings.MOCK_RESPONSES else self.run())
            await self.validate(result)
            return {'job_name': self.job_name, 'result': result}
        except Exception as e:
            return {'job_name': self.job_name, 'exception': self.prepare_exception(e)}

    def prepare_exception(self, exception):
        return {
            'type': type(exception).__name__,
            'message': str(exception),
            'stack_trace': ''.join(traceback.format_tb(exception.__traceback__)),
        }

    @abstractmethod
    async def run(self):
        pass

    async def validate(self, result):
        pass

    async def mock_run(self):
        # Run the standard run method if mock is not implemented for child
        return await self.run()
    
    @property
    def job_name(self):
        return os.path.basename(sys.modules[self.__module__].__file__).replace('.py', '')

    