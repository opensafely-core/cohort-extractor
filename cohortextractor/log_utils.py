import logging.config
import os
from contextlib import contextmanager
from datetime import timedelta
from time import process_time

import structlog

pre_chain = [
    structlog.stdlib.add_log_level,
    structlog.stdlib.add_logger_name,
    structlog.processors.TimeStamper(fmt="%Y-%m-%d %H:%M:%S"),
]

structlog.configure(
    processors=[
        structlog.stdlib.filter_by_level,
        structlog.processors.TimeStamper(fmt="%Y-%m-%d %H:%M:%S"),
        structlog.stdlib.add_logger_name,
        structlog.stdlib.add_log_level,
        structlog.stdlib.PositionalArgumentsFormatter(),
        structlog.processors.StackInfoRenderer(),
        structlog.processors.format_exc_info,
        structlog.processors.UnicodeDecoder(),
        structlog.stdlib.ProcessorFormatter.wrap_for_formatter,
    ],
    context_class=structlog.threadlocal.wrap_dict(dict),
    logger_factory=structlog.stdlib.LoggerFactory(),
    wrapper_class=structlog.stdlib.BoundLogger,
    cache_logger_on_first_use=True,
)


def init_logging():
    logging.config.dictConfig(
        {
            "version": 1,
            "disable_existing_loggers": False,
            "formatters": {
                "formatter": {
                    "()": structlog.stdlib.ProcessorFormatter,
                    "processor": structlog.dev.ConsoleRenderer(),
                    "foreign_pre_chain": pre_chain,
                }
            },
            "handlers": {
                "console": {
                    "level": "DEBUG",
                    "class": "logging.StreamHandler",
                    "formatter": "formatter",
                }
            },
            "root": {
                "handlers": ["console"],
                "level": os.getenv("LOG_LEVEL", "INFO"),
            },
            "loggers": {
                "cohortextractor.sql": {
                    "handlers": ["console"],
                    "level": "DEBUG" if os.getenv("LOG_SQL") else "INFO",
                    "propagate": False,
                },
            },
        }
    )


def log_stats(logger, **kwargs):
    logger.info("cohortextractor-stats", **kwargs)


@contextmanager
def log_execution_time(logger, name):
    start = process_time()
    try:
        yield
    finally:
        elapsed_time = process_time() - start
        log_stats(
            logger,
            target=name,
            execution_time_secs=elapsed_time,
            execution_time=str(timedelta(seconds=elapsed_time)),
        )
