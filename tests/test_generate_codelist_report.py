import csv
import os
from datetime import date

import pandas as pd
import pytest

from cohortextractor.generate_codelist_report import generate_codelist_report
from tests import test_tpp_backend
from tests.tpp_backend_setup import (
    CodedEventSnomed,
    Organisation,
    Patient,
    RegistrationHistory,
    clear_database,
    make_database,
    make_session,
)


@pytest.fixture(autouse=True)
def set_database_url(monkeypatch):
    if "TPP_DATABASE_URL" in os.environ:
        monkeypatch.setenv("DATABASE_URL", os.environ["TPP_DATABASE_URL"])


def setup_module(module):
    make_database()


def teardown_module(module):
    clear_database()


def setup_function(function):
    test_tpp_backend.setup_function(function)


def test_generate_codelist_report(tmp_path):
    # The timeframe we're interested in.
    start_date = date.fromisoformat("2022-01-02")
    end_date = date.fromisoformat("2022-01-25")

    # The codes in our codelist.
    codelist_codes = ["11111111", "22222222"]

    with open(tmp_path / "codelist.csv", "w") as f:
        writer = csv.writer(f)
        writer.writerow(["code"])
        writer.writerows([[code] for code in codelist_codes])

    # Each patient will have an event for each of these date/code pairs.
    event_data = [
        # Not included: too early
        ("2022-01-01 12:00:01", "11111111"),
        # Included in w/b 2022-01-02
        ("2022-01-02 12:00:02", "22222222"),
        ("2022-01-03 12:00:03", "11111111"),
        ("2022-01-04 12:00:04", "11111111"),
        ("2022-01-05 12:00:05", "11111111"),
        ("2022-01-06 12:00:06", "33333333"),  # Not included: not in codelist
        ("2022-01-07 12:00:07", "11111111"),
        ("2022-01-08 12:00:08", "11111111"),
        # No events in w/b 2022-01-09
        # Included in w/b 2022-01-16
        ("2022-01-16 12:00:16", "11111111"),
        ("2022-01-17 12:00:17", "22222222"),
        ("2022-01-18 12:00:18", "22222222"),
        ("2022-01-19 12:00:19", "11111111"),
        ("2022-01-20 12:00:20", "11111111"),
        ("2022-01-21 12:00:21", "11111111"),
        ("2022-01-22 12:00:22", "33333333"),  # Not included: not in codelist
        # Included in w/e 2022-01-23
        ("2022-01-23 12:00:23", "11111111"),
        ("2022-01-24 12:00:24", "11111111"),
        ("2022-01-24 13:00:24", "11111111"),  # Not included: second event of day
        ("2022-01-25 12:00:25", "11111111"),
        # Not included: too late
        ("2022-01-26 12:00:26", "22222222"),
    ]

    expected_counts_per_code = {"11111111": 24, "22222222": 6}
    expected_counts_per_week_per_practice = {
        ("2022-01-02", 1): 6,
        ("2022-01-09", 1): 0,
        ("2022-01-16", 1): 6,
        ("2022-01-23", 1): 3,
        ("2022-01-02", 2): 6,
        ("2022-01-09", 2): 0,
        ("2022-01-16", 2): 6,
        ("2022-01-23", 2): 3,
    }

    set_up_patients(event_data)

    # Generate the codelist report.
    generate_codelist_report(tmp_path, tmp_path / "codelist.csv", start_date, end_date)

    # Check counts_per_code is as expected.
    counts_per_code = pd.read_csv(
        tmp_path / "counts_per_code.csv", dtype={"code": "object"}
    ).set_index("code")
    assert dict(counts_per_code["num"]) == expected_counts_per_code

    # Check counts_per_week_per_practice is as expected.
    counts_per_week_per_practice = pd.read_csv(
        tmp_path / "counts_per_week_per_practice.csv", dtype={"date": "object"}
    ).set_index(["date", "practice"])
    assert (
        dict(counts_per_week_per_practice["num"])
        == expected_counts_per_week_per_practice
    )

    # Check list_sizes is as expected.  Only practice 1 has any patients registered on
    # the end date, and it has 2 patients.
    #   * current_patient
    #   * current_patient_no_events
    list_sizes = pd.read_csv(tmp_path / "list_sizes.csv").set_index("practice")
    assert dict(list_sizes["list_size"]) == {1: 2}

    # Check patient_count is as expected.  There are 2 patients in the population with
    # matching events:
    #   * current_patient
    #   * dead_patient
    patient_count = pd.read_csv(tmp_path / "patient_count.csv")
    assert patient_count["num"][0] == 2


def set_up_patients(event_data):
    organisations = [Organisation(Organisation_ID=ix) for ix in range(5)]

    # This patient is in the target population, because they're still registered at the
    # practice.
    current_patient = Patient()
    current_patient.RegistrationHistory = [
        RegistrationHistory(
            StartDate="2000-01-01",
            EndDate="2001-01-01",
            Organisation=organisations[0],
        ),
        RegistrationHistory(
            StartDate="2001-01-01",
            EndDate="9999-01-01",
            Organisation=organisations[1],
        ),
    ]
    current_patient.CodedEventsSnomed = [
        CodedEventSnomed(ConsultationDate=date, ConceptID=code)
        for date, code in event_data
    ]

    # This patient is in the target population, because they're still registered at the
    # practice, but they have no events.
    current_patient_no_events = Patient()
    current_patient_no_events.RegistrationHistory = [
        RegistrationHistory(
            StartDate="2001-01-01",
            EndDate="9999-01-01",
            Organisation=organisations[1],
        ),
    ]

    # This patient is in the target population, because they died during the timeframe
    # we're interested in.
    dead_patient = Patient(DateOfDeath="2022-01-15")
    dead_patient.RegistrationHistory = [
        RegistrationHistory(
            StartDate="2001-01-01",
            EndDate="2022-01-15",
            Organisation=organisations[2],
        )
    ]
    dead_patient.CodedEventsSnomed = [
        CodedEventSnomed(ConsultationDate=date, ConceptID=code)
        for date, code in event_data
    ]

    # This patient is not in the target population, because they were not registered by
    # the end of the timeframe we're interested in.
    former_patient = Patient()
    former_patient.RegistrationHistory = [
        RegistrationHistory(
            StartDate="2001-01-01",
            EndDate="2022-01-15",
            Organisation=organisations[3],
        )
    ]
    former_patient.CodedEventsSnomed = [
        CodedEventSnomed(ConsultationDate=date, ConceptID=code)
        for date, code in event_data
    ]

    # This patient is not in the target population, because they died before the
    # timeframe we're interested in.
    long_dead_patient = Patient(DateOfDeath="2011-12-31")
    long_dead_patient.RegistrationHistory = [
        RegistrationHistory(
            StartDate="2001-01-01",
            EndDate="2011-12-31",
            Organisation=organisations[4],
        )
    ]
    long_dead_patient.CodedEventsSnomed = [
        CodedEventSnomed(ConsultationDate=date, ConceptID=code)
        for date, code in event_data
    ]

    session = make_session()
    session.add(current_patient)
    session.add(current_patient_no_events)
    session.add(dead_patient)
    session.add(former_patient)
    session.add(long_dead_patient)
    session.commit()


def test_generate_codelist_report_dummy(tmp_path, monkeypatch):
    monkeypatch.setitem(os.environ, "OPENSAFELY_BACKEND", "expectations")

    start_date = date.fromisoformat("2022-01-02")
    end_date = date.fromisoformat("2022-01-25")

    # The codes in our codelist.
    codelist_codes = ["11111111", "22222222"]

    with open(tmp_path / "codelist.csv", "w") as f:
        writer = csv.writer(f)
        writer.writerow(["code"])
        writer.writerows([[code] for code in codelist_codes])

    generate_codelist_report(tmp_path, tmp_path / "codelist.csv", start_date, end_date)

    # check the files are valid csv
    pd.read_csv(tmp_path / "counts_per_code.csv", dtype={"code": "object"})
    pd.read_csv(tmp_path / "counts_per_week_per_practice.csv", dtype={"date": "object"})
    pd.read_csv(tmp_path / "list_sizes.csv")
    pd.read_csv(tmp_path / "patient_count.csv")
