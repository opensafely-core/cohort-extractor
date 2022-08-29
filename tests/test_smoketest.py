"""
Basic smoketest to check that invoking that the CLI entrypoint is working.
This relies on the contents of `tests/fixtures/smoketest` being as expected.
"""
import csv
import os
import subprocess
import sys

import pytest

import cohortextractor


@pytest.mark.parametrize("format", ["csv", "csv.gz", "feather", "dta", "dta.gz"])
def test_smoketest(tmp_path, format):
    population_size = 100
    _cohortextractor(
        study="test_smoketest",
        args=[
            "generate_cohort",
            "--expectations-population",
            str(population_size),
            "--index-date-range",
            "2020-01-01 to 2020-04-01 by month",
            "--output-dir",
            tmp_path,
            "--output-format",
            format,
        ],
    )
    _cohortextractor(
        study="test_smoketest",
        args=[
            "generate_measures",
            "--output-dir",
            tmp_path,
        ],
    )

    # liver_disease_by_stp
    with open(tmp_path / "measure_liver_disease_by_stp.csv") as f:
        contents = list(csv.reader(f))
    assert contents[0] == [
        "stp",
        "has_chronic_liver_disease",
        "population",
        "value",
        "date",
    ]
    assert len(contents) == 1 + (2 * 4)  # Header row + 2 STPs * 4 dates
    dates = set(row[4] for row in contents[1:])
    assert dates == {"2020-01-01", "2020-02-01", "2020-03-01", "2020-04-01"}

    # liver_disease_by_stp_and_sex
    with open(tmp_path / "measure_liver_disease_by_stp_and_sex.csv") as f:
        contents = list(csv.reader(f))
    assert contents[0] == [
        "stp",
        "sex",
        "has_chronic_liver_disease",
        "population",
        "value",
        "date",
    ]
    assert len(contents) == 1 + (2 * 2 * 4)  # Header row + 2 STPs * 2 sexes * 4 dates
    dates = set(row[5] for row in contents[1:])
    assert dates == {"2020-01-01", "2020-02-01", "2020-03-01", "2020-04-01"}

    # liver_disease
    with open(tmp_path / "measure_liver_disease.csv") as f:
        contents = list(csv.reader(f))
    assert contents[0] == [
        "has_chronic_liver_disease",
        "population",
        "value",
        "date",
    ]

    # liver_disease_one_group
    with open(tmp_path / "measure_liver_disease_one_group.csv") as f:
        contents = list(csv.reader(f))
    assert contents[0] == [
        "has_chronic_liver_disease",
        "population",
        "value",
        "date",
    ]
    dates = [row[3] for row in contents[1:]]
    assert dates == ["2020-01-01", "2020-02-01", "2020-03-01", "2020-04-01"]
    populations = [float(row[1]) for row in contents[1:]]
    assert populations == [population_size] * 4


def test_suppresses_small_numbers(tmp_path):
    def run_study(population):
        _cohortextractor(
            study="test_suppresses_small_numbers",
            args=[
                "generate_cohort",
                "--expectations-population",
                str(population),
                "--index-date-range",
                "2020-01-01 to 2020-01-01 by month",
                "--output-dir",
                tmp_path,
            ],
        )
        _cohortextractor(
            study="test_suppresses_small_numbers",
            args=[
                "generate_measures",
                "--output-dir",
                tmp_path,
            ],
        )

        with open(tmp_path / "measure_liver_disease_by_stp.csv") as f:
            return list(csv.DictReader(f))

    # Incidence is 1.0 and there is only one STP to make the numbers deterministic
    results = run_study(100)
    assert results[0]["has_chronic_liver_disease"] == "100.0"
    assert results[0]["population"] == "100"
    assert results[0]["value"] == "1.0"

    # Push the population down below the small number threshold to trigger suppression
    results = run_study(3)
    assert results[0]["has_chronic_liver_disease"] == ""
    assert results[0]["population"] == ""
    assert results[0]["value"] == ""


def test_patients_from_file(tmp_path):
    population_size = 100
    _cohortextractor(
        study="test_patients_from_file",
        args=[
            "generate_cohort",
            "--expectations-population",
            str(population_size),
            "--output-dir",
            tmp_path,
            "--study-definition",
            "study_definition_controls",
        ],
    )
    with open(tmp_path / "input_controls.csv") as f:
        contents = list(csv.reader(f))
    # The number of rows in the output file must equal the number of rows in the
    # user-supplied CSV file
    assert len(contents) == 2
    assert contents[0] == [
        "patient_id",
        "case_index_date",
        "exists_in_file",
        "bmi_date_measured",
        "age",
        "bmi",
    ]
    # The following values come from the user-supplied CSV file
    assert contents[1][0] == "1"  # integer
    assert contents[1][1] == "2021-01-01"
    assert contents[1][2] == "1"  # boolean


def test_passing_params_to_study_definition(tmp_path):
    population_size = 4
    _cohortextractor(
        study="test_params",
        args=[
            "generate_cohort",
            "--expectations-population",
            str(population_size),
            "--output-file",
            tmp_path / "results_with_params.csv",
            "--param",
            "age_suffix=one",
            "--param",
            "sex_suffix",
            "=",
            "two",
        ],
    )
    with open(tmp_path / "results_with_params.csv") as f:
        contents = list(csv.reader(f))
    assert len(contents) == population_size + 1
    assert set(contents[0]) == {"patient_id", "age_one", "sex_two"}


def _cohortextractor(study, args):
    study_path = os.path.join(os.path.dirname(__file__), "fixtures", "studies", study)
    cohortextractor_path = os.path.dirname(os.path.dirname(cohortextractor.__file__))
    subprocess.run(
        [sys.executable, "-m", "cohortextractor.cohortextractor", *args],
        check=True,
        cwd=study_path,
        env=dict(os.environ, PYTHONPATH=cohortextractor_path),
    )
