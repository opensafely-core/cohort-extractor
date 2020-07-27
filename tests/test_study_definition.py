import csv
import inspect
import subprocess
import sys
import textwrap

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
    study.to_csv(filename, expectations_population=10)
    with open(filename) as f:
        results = list(csv.DictReader(f))
    assert len(results) == 10
    columns = results[0].keys()
    assert "sex" in columns
    assert "age" in columns


def test_export_data_without_database_url_raises_error(tmp_path, monkeypatch):
    monkeypatch.delenv("DATABASE_URL", raising=False)
    study = StudyDefinition(
        population=patients.all(),
        sex=patients.sex(),
        age=patients.age_as_of("2020-01-01",),
    )
    with pytest.raises(RuntimeError):
        study.to_csv(tmp_path / "dummy_data.csv")


def test_unrecognised_database_url_raises_error(monkeypatch):
    monkeypatch.setenv("DATABASE_URL", "unknown-db://localhost")
    with pytest.raises(ValueError):
        StudyDefinition(
            population=patients.all(),
            sex=patients.sex(),
            age=patients.age_as_of("2020-01-01",),
        )


def test_errors_are_triggered_without_database_url(monkeypatch):
    monkeypatch.delenv("DATABASE_URL", raising=False)
    with pytest.raises(KeyError):
        StudyDefinition(
            population=patients.satisfying("no_such_column AND missing_column"),
            sex=patients.sex(),
            age=patients.age_as_of("2020-01-01",),
        )


def test_pyodbc_not_accidentally_imported(tmp_path):
    # Make a test script to be executed in a separate process so we can see
    # what gets imported
    def test_script():
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
        study.to_csv("/dev/null", expectations_population=10)
        status = "is" if "pyodbc" in sys.modules else "is not"
        print(f"pyodbc {status} imported")

    # Convert the code in `test_script` to a standalone script by removing the
    # function definition line and stripping the indentation
    source = inspect.getsource(test_script).splitlines()[1:]
    source = textwrap.dedent("\n".join(source))
    result = subprocess.check_output([sys.executable, "-c", source]).strip()
    assert result == b"pyodbc is not imported"


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
