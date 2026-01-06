import functools

from opentelemetry import trace
from pydantic_settings import BaseSettings


class TracingWrapper:
    def __init__(self, app_settings: BaseSettings):
        self.app_settings: BaseSettings = app_settings
        self.tracer: trace.Tracer = trace.get_tracer(app_settings.TRACER_NAME)

    # tracer: trace.Tracer = trace.get_tracer(app_settings.TRACER_NAME)

    # Tracing decorator
    def trace_async(self, func):
        """
        Decorator that automatically creates a Span for the function execution.
        """

        @functools.wraps(func)
        async def async_wrapper(*args, **kwargs):
            if not self.app_settings.AZURE_LOGGING or self.tracer is None:
                return await func(*args, **kwargs)

            with self.tracer.start_as_current_span(func.__name__) as span:
                try:
                    return await func(*args, **kwargs)
                except Exception as e:
                    span.record_exception(e)
                    span.set_status(trace.Status(trace.StatusCode.ERROR))
                    raise

        return async_wrapper
