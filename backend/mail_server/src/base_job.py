import os
import sys
import traceback
from abc import ABC, abstractmethod

from src.app_settings import app_settings
from src.mail_context import MailContext


class EmailJob(ABC):
    def __init__(self, email_context: MailContext):
        self.raw_email = email_context.raw_email
        self.raw_body = email_context.raw_body
        self.etree = email_context.etree
        self.text = email_context.text

    async def execute(self):
        try:
            result = await (self.mock_run() if app_settings.MOCK_RESPONSES else self.run())
            await self.validate(result)
            return {"job_name": self.job_name, "result": result}
        except Exception as e:
            return {"job_name": self.job_name, "exception": self.prepare_exception(e)}

    def prepare_exception(self, exception):
        return {
            "type": type(exception).__name__,
            "message": str(exception),
            "stack_trace": "".join(traceback.format_tb(exception.__traceback__)),
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
        return os.path.basename(sys.modules[self.__module__].__file__).replace(".py", "")
