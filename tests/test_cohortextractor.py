import tempfile
from contextlib import contextmanager
from pathlib import Path
from unittest.mock import patch

import pytest

from cohortextractor.cohortextractor import list_study_definitions


@contextmanager
def dummy_repo_folder(with_definition=True):
    with tempfile.TemporaryDirectory() as tmpdir:
        folder = Path(tmpdir)
        (folder / "analysis").mkdir(exist_ok=True)
        if with_definition:
            (folder / "analysis" / "study_definition_test.py").touch()
        yield tmpdir


@patch("cohortextractor.cohortextractor.relative_dir")
def test_no_study_definition_raises(relative_dir):
    with dummy_repo_folder(with_definition=False) as dummy_repo:
        relative_dir.return_value = dummy_repo
        with pytest.raises(RuntimeError):
            list_study_definitions()


@patch("cohortextractor.cohortextractor.relative_dir")
def test_list_study_definition(relative_dir):
    with dummy_repo_folder() as dummy_repo:
        relative_dir.return_value = dummy_repo
        definitions = list_study_definitions()
        assert definitions == [("study_definition_test", "_test")]
