from pathlib import Path

import pytest

from cohortextractor import StudyDefinition, codelist, patients
from cohortextractor.cohortextractor import SUPPORTED_FILE_FORMATS
from cohortextractor.validate_dummy_data import (
    DummyDataValidationError,
    validate_dummy_data,
)

cl = codelist(["12345"], system="snomed")

study = StudyDefinition(
    default_expectations={"date": {"earliest": "2020-01-01", "latest": "today"}},
    population=patients.all(),
    sex=patients.sex(
        return_expectations={
            "category": {"ratios": {"F": 0.5, "M": 0.5}},
            "rate": "universal",
        },
    ),
    age=patients.age_as_of(
        "2020-01-01",
        return_expectations={
            "int": {"distribution": "population_ages"},
            "rate": "universal",
        },
    ),
    has_event=patients.with_these_clinical_events(
        cl,
        returning="binary_flag",
        return_expectations={"rate": "uniform", "incidence": 0.5},
    ),
    event_date_day=patients.with_these_clinical_events(
        cl,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={"rate": "uniform", "incidence": 0.5},
    ),
    event_date_month=patients.with_these_clinical_events(
        cl,
        returning="date",
        date_format="YYYY-MM",
        return_expectations={"rate": "uniform", "incidence": 0.5},
    ),
    event_date_year=patients.with_these_clinical_events(
        cl,
        returning="date",
        date_format="YYYY",
        return_expectations={"rate": "uniform", "incidence": 0.5},
    ),
)

covariate_definitions = study.covariate_definitions

fixtures_path = Path(__file__).parent / "fixtures" / "dummy-data"


def test_validate_dummy_data_valid_data():
    validate_dummy_data(study, fixtures_path / "dummy-data.csv")


def test_validate_dummy_data_invalid_data(subtests):
    for filename, error_fragment in [
        ("missing-column", "Missing column in dummy data: event_date_year"),
        ("extra-column", "Unexpected column in dummy data: extra_col"),
        ("invalid-int", "Invalid value `XX` for age"),
        ("invalid-bool", "Invalid value `X` for has_event"),
        ("invalid-date-yyyy", "Invalid value `20210.0` for event_date_year"),
        ("invalid-date-yyyy-mm", "Invalid value `2021-010` for event_date_month"),
        ("invalid-date-yyyy-mm-dd", "Invalid value `2021-01-010` for event_date_day"),
    ]:
        with subtests.test(filename):
            with pytest.raises(DummyDataValidationError, match=error_fragment):
                validate_dummy_data(
                    covariate_definitions, fixtures_path / f"{filename}.csv"
                )


def test_validate_dummy_data_unknown_file_extension():
    with pytest.raises(DummyDataValidationError):
        validate_dummy_data(covariate_definitions, fixtures_path / "data.txt")


@pytest.mark.parametrize("file_format", SUPPORTED_FILE_FORMATS)
def test_validate_dummy_data_missing_data_file(file_format):
    with pytest.raises(DummyDataValidationError):
        validate_dummy_data(
            covariate_definitions, fixtures_path / f"missing.{file_format}"
        )
