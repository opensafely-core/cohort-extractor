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


class BaseLoggingWrapper:
    """
    Wraps a class instance and provides a logger instance as an attribute.

    Subclasses can implement their own methods to override methods on the
    wrapped instance and make use of the logger.

    Any attribute or method called on the wrapper calls its own implementation if
    one exists, otherwise calls it on the class instance
    """

    def __init__(self, logger, wrapped_instance):
        self.logger = logger
        self.wrapped_instance = wrapped_instance

    def __getattr__(self, attr):
        if attr in dir(self):
            return attr
        return getattr(self.wrapped_instance, attr)


class LoggingCursor(BaseLoggingWrapper):
    """
    Provides a database cursor instance that willl log the execution time of any
    `execute` call
    """

    def __init__(self, logger, cursor):
        super().__init__(logger, cursor)
        self.cursor = cursor

    def __iter__(self):
        return self.cursor.__iter__()

    def __next__(self):
        return self.cursor.__next__()

    def execute(self, query, log_desc=None):
        if log_desc is None:
            # Log either the provided log_desc or the first 50 characters
            # of the query
            log_desc = f"{query[:50] if len(query) > 50 else query}..."
        with log_execution_time(self.logger, log_desc):
            self.cursor.execute(query)


class LoggingDatabaseConnection(BaseLoggingWrapper):
    """
    Provides a database connection instance with a LoggingCursor
    """

    def __init__(self, logger, database_connection):
        super().__init__(logger, database_connection)
        self.db_connection = database_connection

    def cursor(self):
        return LoggingCursor(self.logger, self.db_connection.cursor())
