import tempfile
from contextlib import ExitStack, contextmanager
from pathlib import Path
from unittest.mock import patch

import pytest

from cohortextractor import MissingParameterError, params
from cohortextractor.cohortextractor import list_study_definitions, main


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


class PatchStack(ExitStack):
    """
    Apply multiple `patch` context managers without nesting or using the ugly multi
    argument form
    """

    def __call__(self, *args, **kwargs):
        return self.enter_context(patch(*args, **kwargs))


@pytest.fixture
def patch_generate_cohort(monkeypatch):
    monkeypatch.setenv("DATABASE_URL", "mssql://")
    module = "cohortextractor.cohortextractor"
    with PatchStack() as patch:
        patch(
            f"{module}.list_study_definitions",
            return_value=[
                ("study_definition", ""),
                ("study_definition_test", "_test"),
            ],
        )
        patch(f"{module}.preflight_generation_check")
        yield patch(f"{module}._generate_cohort")


@pytest.mark.parametrize("option", ["--output-dir", "--output-format"])
def test_output_file_cannot_be_combined_with_conflicting_options(
    option, patch_generate_cohort, capsys
):
    with pytest.raises(SystemExit):
        main(
            [
                "generate_cohort",
                "--output-file",
                "output/input.csv",
                option,
                "feather",
            ]
        )
    assert f"{option} 'feather' does not match" in capsys.readouterr().err


def test_output_file_can_be_combined_with_matching_options(patch_generate_cohort):
    main(
        [
            "generate_cohort",
            "--study-definition",
            "study_definition",
            "--output-file",
            "mydir/input.feather",
            "--output-dir",
            "mydir",
            "--output-format",
            "feather",
        ]
    )
    patch_generate_cohort.assert_called_once()


def test_output_file_can_only_be_used_with_single_study(patch_generate_cohort, capsys):
    with pytest.raises(SystemExit):
        main(
            [
                "generate_cohort",
                "--output-file",
                "output/input.csv",
                "--study-definition",
                "all",
            ]
        )
    assert (
        "Validation error: You can only use the --output-file argument with a "
        "single study definition"
    ) in capsys.readouterr().out


def test_output_file_must_have_supported_format(patch_generate_cohort, capsys):
    with pytest.raises(SystemExit):
        main(
            [
                "generate_cohort",
                "--output-file",
                "output/input.docx",
                "--study-definition",
                "all",
            ]
        )
    assert "--output-file must have a supported extension" in capsys.readouterr().err


def test_output_file_args_passed_to_generate_cohort(patch_generate_cohort):
    main(
        [
            "generate_cohort",
            "--output-file",
            "my_dir/results.csv.gz",
            "--study-definition",
            "study_definition_test",
        ]
    )
    patch_generate_cohort.assert_called_with(
        "my_dir",
        "study_definition_test",
        "",
        0,
        None,
        index_date_range="",
        skip_existing=False,
        output_format="csv.gz",
        output_name="results",
        params={},
    )


def test_multiple_studies_handled_if_no_output_file_option(patch_generate_cohort):
    main(["generate_cohort", "--output-format", "feather"])
    patch_generate_cohort.assert_any_call(
        "output",
        "study_definition",
        "",
        0,
        None,
        index_date_range="",
        skip_existing=False,
        output_format="feather",
        output_name="input",
        params={},
    )
    patch_generate_cohort.assert_any_call(
        "output",
        "study_definition_test",
        "_test",
        0,
        None,
        index_date_range="",
        skip_existing=False,
        output_format="feather",
        output_name="input",
        params={},
    )


def test_params_dict_raises_correct_error():
    with pytest.raises(MissingParameterError, match="nothere"):
        params["nothere"]
