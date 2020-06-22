import os

from .study_definition import StudyDefinition

from .codelistlib import (
    codelist,
    codelist_from_csv,
    filter_codes_by_category,
    combine_codelists,
)

with open(os.path.join(os.path.dirname(__file__), "VERSION")) as version_file:
    __version__ = version_file.read().strip()

__all__ = [
    "StudyDefinition",
    "codelist",
    "codelist_from_csv",
    "filter_codes_by_category",
    "combine_codelists",
]
