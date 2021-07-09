import csv
import subprocess
import sys
import textwrap
from pathlib import Path

import pytest

from cohortextractor import StudyDefinition, patients


def test_create_dummy_data_works_without_database_url(tmp_path, monkeypatch):
    monkeypatch.delenv("DATABASE_URL", raising=False)
    study = StudyDefinition(
        population=patients.all(),
        sex=patients.sex(
            return_expectations={
                "rate": "universal",
                "date": {"earliest": "1900-01-01", "latest": "today"},
                "category": {"ratios": {"M": 0.49, "F": 0.51}},
            }
        ),
        age=patients.age_as_of(
            "2020-01-01",
            return_expectations={
                "rate": "universal",
                "date": {"earliest": "1900-01-01", "latest": "2020-01-01"},
                "int": {"distribution": "population_ages"},
            },
        ),
    )
    filename = tmp_path / "dummy_data.csv"
    study.to_file(filename, expectations_population=10)
    with open(filename) as f:
        results = list(csv.DictReader(f))
    assert len(results) == 10
    columns = results[0].keys()
    assert "sex" in columns
    assert "age" in columns


def test_to_file_with_dummy_data_file(tmp_path):
    study = StudyDefinition(
        population=patients.all(),
        sex=patients.sex(),
        age=patients.age_as_of("2020-01-01",),
    )
    output_file = tmp_path / "dummy_data.csv"
    dummy_data_file = Path(__file__).parent / "fixtures" / "dummy-data.csv"
    study.to_file(output_file, dummy_data_file=dummy_data_file)
    with open(output_file) as f:
        results = list(csv.DictReader(f))
    assert len(results) == 2
    columns = results[0].keys()
    assert "sex" in columns
    assert "age" in columns


def test_export_data_without_database_url_raises_error(tmp_path, monkeypatch):
    monkeypatch.delenv("DATABASE_URL", raising=False)
    study = StudyDefinition(
        population=patients.all(),
        sex=patients.sex(),
        age=patients.age_as_of(
            "2020-01-01",
        ),
    )
    with pytest.raises(RuntimeError):
        study.to_file(tmp_path / "dummy_data.csv")


def test_unrecognised_database_url_raises_error(monkeypatch):
    monkeypatch.setenv("DATABASE_URL", "unknown-db://localhost")
    with pytest.raises(ValueError):
        StudyDefinition(
            population=patients.all(),
            sex=patients.sex(),
            age=patients.age_as_of(
                "2020-01-01",
            ),
        )


def test_errors_are_triggered_without_database_url(monkeypatch):
    monkeypatch.delenv("DATABASE_URL", raising=False)
    with pytest.raises(KeyError):
        StudyDefinition(
            population=patients.satisfying("no_such_column AND missing_column"),
            sex=patients.sex(),
            age=patients.age_as_of(
                "2020-01-01",
            ),
        )


def test_drivers_not_accidentally_imported(tmp_path):
    """
    For now, we still have to support researchers importing their study
    definitions in their analysis code to access details of their study
    configuration (and avoid having to repeat this in two places). To enable
    this we install a version of the cohortextractor inside the `python-docker`
    image but without any of the driver packages (which are large and unused
    and would bloat the image). But this means we need to make sure we don't
    accidentally create a dependency on one of the driver packages when loading
    a study definition. So this test ensures that we can import a basic study
    definition and generate some dummy data without ever importing a driver.
    """
    # To track imports we need to execute a test script in a separate process
    test_script = """
        import sys

        from cohortextractor import StudyDefinition, patients

        study = StudyDefinition(
            population=patients.all(),
            sex=patients.sex(
                return_expectations={
                    "rate": "universal",
                    "date": {"earliest": "1900-01-01", "latest": "today"},
                    "category": {"ratios": {"M": 0.49, "F": 0.51}},
                }
            ),
        )
        study.to_file("{tmp_path}/dummy.csv", expectations_population=10)
        drivers = ["pyodbc", "ctds", "pyspark", "prestodb"]
        imported_drivers = [i for i in drivers if i in sys.modules]
        print(f"imported_drivers={imported_drivers}")
    """

    source = textwrap.dedent(test_script)
    source = source.replace("{tmp_path}", str(tmp_path))
    result = subprocess.check_output([sys.executable, "-c", source]).strip()
    assert result == b"imported_drivers=[]"


def test_column_name_clashes_produce_errors():
    with pytest.raises(ValueError):
        StudyDefinition(
            population=patients.all(),
            age=patients.age_as_of("2020-01-01"),
            status=patients.satisfying(
                "age > 70 AND sex = 'M'",
                sex=patients.sex(),
                age=patients.age_as_of("2010-01-01"),
            ),
        )


def test_recursive_definitions_produce_errors():
    with pytest.raises(ValueError):
        StudyDefinition(
            population=patients.all(),
            this=patients.satisfying("that = 1"),
            that=patients.satisfying("this = 1"),
        )


def test_syntax_errors_in_expressions_are_raised():
    with pytest.raises(ValueError):
        StudyDefinition(
            population=patients.all(),
            status=patients.satisfying(
                "age > 70 AND AND sex = 'M'",
                sex=patients.sex(),
                age=patients.age_as_of("2010-01-01"),
            ),
        )
