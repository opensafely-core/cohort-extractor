import os

from .codelistlib import (
    codelist,
    codelist_from_csv,
    combine_codelists,
    filter_codes_by_category,
)
from .exceptions import MissingParameterError
from .log_utils import init_logging
from .measure import Measure
from .study_definition import StudyDefinition

init_logging()

with open(os.path.join(os.path.dirname(__file__), "VERSION")) as version_file:
    __version__ = version_file.read().strip()

__all__ = [
    "StudyDefinition",
    "Measure",
    "codelist",
    "codelist_from_csv",
    "filter_codes_by_category",
    "combine_codelists",
    "params",
]


# Custom dict subclass so we can raise more helpful errors for missing params
class ParamDict(dict):
    def __getitem__(self, key):
        try:
            return super().__getitem__(key)
        except KeyError:
            raise MissingParameterError(key)


# Global for passing `--param` arguments from command line to study definitions
params = ParamDict()
