from pathlib import Path

import pytest

from cohortextractor import StudyDefinition, codelist, patients
from cohortextractor.cohortextractor import SUPPORTED_FILE_FORMATS
from cohortextractor.csv_utils import is_csv_filename, write_rows_to_csv
from cohortextractor.pandas_utils import dataframe_from_rows, dataframe_to_file
from cohortextractor.validate_dummy_data import (
    DummyDataValidationError,
    validate_dummy_data,
)

cl = codelist(["12345"], system="snomed")

column_definitions = dict(
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

study = StudyDefinition(**column_definitions)
covariate_definitions = study.covariate_definitions

fixtures_path = Path(__file__).parent / "fixtures" / "dummy-data"


# Create a second test study to which we can add columns without needing to rebuild all
# the test fixtures
study_2 = StudyDefinition(
    **column_definitions,
    category_date=patients.categorised_as(
        {
            "2020-10-15": "age > 50",
            "2021-11-16": "DEFAULT",
        },
        return_expectations={
            "category": {
                "ratios": {
                    "2020-10-15": 0.5,
                    "2021-11-16": 0.5,
                }
            },
        },
    ),
)
covariate_definitions_2 = study_2.covariate_definitions


@pytest.mark.parametrize("file_format", SUPPORTED_FILE_FORMATS)
def test_validate_dummy_data_valid(file_format, tmpdir):
    rows = zip(
        ["patient_id", "11", "22"],
        ["sex", "F", "M"],
        ["age", 40, 50],
        ["has_event", True, False],
        ["event_date_day", "2021-01-01", None],
        ["event_date_month", "2021-01", None],
        ["event_date_year", "2021", None],
        ["category_date", "2020-10-15", "2021-11-16"],
    )
    path = Path(tmpdir) / f"dummy-data.{file_format}"
    if is_csv_filename(path):
        write_rows_to_csv(rows, path)
    else:
        df = dataframe_from_rows(covariate_definitions_2, rows)
        dataframe_to_file(df, path)
    validate_dummy_data(covariate_definitions_2, path)


def test_validate_dummy_data_invalid_csv(subtests):
    for filename, error_fragment in [
        ("missing-column", "Missing column in dummy data: event_date_year"),
        ("extra-column", "Unexpected column in dummy data: extra_col"),
        ("invalid-int", "Invalid value `'XX'` for age"),
        ("invalid-bool", "Invalid value `'X'` for has_event"),
        ("invalid-date-yyyy", "Invalid value `20210.0` for event_date_year"),
        ("invalid-date-yyyy-mm", "Invalid value `'2021-010'` for event_date_month"),
        ("invalid-date-yyyy-mm-dd", "Invalid value `'2021-01-010'` for event_date_day"),
    ]:
        with subtests.test(filename):
            with pytest.raises(DummyDataValidationError, match=error_fragment):
                validate_dummy_data(
                    covariate_definitions, fixtures_path / f"{filename}.csv"
                )


@pytest.mark.parametrize(
    "file_format", [ff for ff in SUPPORTED_FILE_FORMATS if "csv" not in ff]
)
def test_validate_dummy_data_invalid_binary(file_format, subtests, tmpdir):
    # Create some dummy data based on the covariate definitions at the top of the
    # module.
    rows = zip(
        ["patient_id", "11", "22"],
        ["sex", "F", "M"],
        ["age", 40, 50],
        ["has_event", True, False],
        ["event_date_day", "2021-02-03", None],
        ["event_date_month", "2021-02", None],
        ["event_date_year", "2021", None],
    )
    df = dataframe_from_rows(covariate_definitions, rows)
    path = Path(tmpdir) / f"dummy-data.{file_format}"
    dataframe_to_file(df, path)

    # This checks that the dummy data containing the rows above is valid for our study
    # definition, which ensures that the DummyDataValidationErrors caught below are
    # legit.
    validate_dummy_data(covariate_definitions, path)

    # Create some invalid dummy data by taking the valid dummy data created above and
    # changing the covariate_definitions definitions by switching each pair of
    # covariates in turn.  The data doesn't change, but the covariates do.  This works
    # because each column of the dummy data has a different validator.
    for key1 in df.columns:
        if key1 == "patient_id":
            continue

        for key2 in df.columns:
            if key2 == "patient_id":
                continue

            if key1 >= key2:
                continue

            with subtests.test(f"{key1} {key2}"):
                new_covariate_definitions = covariate_definitions.copy()
                new_covariate_definitions[key1] = covariate_definitions[key2]
                new_covariate_definitions[key2] = covariate_definitions[key1]
                with pytest.raises(DummyDataValidationError, match="Invalid value"):
                    validate_dummy_data(new_covariate_definitions, path)


def test_validate_dummy_data_unknown_file_extension():
    with pytest.raises(DummyDataValidationError):
        validate_dummy_data(covariate_definitions, fixtures_path / "data.txt")


@pytest.mark.parametrize("file_format", SUPPORTED_FILE_FORMATS)
def test_validate_dummy_data_missing_data_file(file_format):
    with pytest.raises(DummyDataValidationError):
        validate_dummy_data(
            covariate_definitions, fixtures_path / f"missing.{file_format}"
        )
