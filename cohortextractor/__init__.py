import os

from .codelistlib import (
    codelist,
    codelist_from_csv,
    combine_codelists,
    filter_codes_by_category,
)
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
]
