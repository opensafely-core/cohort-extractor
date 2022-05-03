import csv
import os

import pandas as pd
import pytest

from cohortextractor.generate_codelist_report import generate_codelist_report
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
    session = make_session()
    session.query(CodedEventSnomed).delete()
    session.query(Organisation).delete()
    session.query(Patient).delete()
    session.query(RegistrationHistory).delete()
    session.commit()


def test_generate_codelist_report(tmpdir):
    # The timeframe we're interested in.
    start_date = "2022-01-02"
    end_date = "2022-01-25"

    # The codes in our codelist.
    codelist_codes = ["11111111", "22222222"]

    with open(tmpdir / "codelist.csv", "w") as f:
        writer = csv.writer(f)
        writer.writerow(["code"])
        writer.writerows([[code] for code in codelist_codes])

    # Each patient will have an event for each of these date/code pairs.
    event_data = [
        # Not included: too early
        ("2022-01-01", "11111111"),
        # Included in w/e 2022-01-03
        ("2022-01-02", "22222222"),
        ("2022-01-03", "11111111"),
        # Included in w/e 2022-01-10
        ("2022-01-04", "11111111"),
        ("2022-01-05", "11111111"),
        ("2022-01-06", "33333333"),  # Not included: not in codelist
        ("2022-01-07", "11111111"),
        ("2022-01-08", "11111111"),
        ("2022-01-09", "11111111"),
        ("2022-01-10", "22222222"),
        # No events in w/e 2022-01-17
        # Included in w/e 2022-01-24
        ("2022-01-18", "22222222"),
        ("2022-01-19", "11111111"),
        ("2022-01-20", "11111111"),
        ("2022-01-21", "11111111"),
        ("2022-01-22", "33333333"),  # Not included: not in codelist
        ("2022-01-23", "11111111"),
        ("2022-01-24", "11111111"),
        # Included in w/e 2022-01-31
        ("2022-01-25", "11111111"),
        # Not included: too late
        ("2022-01-26", "22222222"),
    ]

    expected_counts_per_code = {"11111111": 24, "22222222": 6}
    expected_counts_per_week = {
        ("2022-01-03", 1): 2,
        ("2022-01-10", 1): 6,
        ("2022-01-17", 1): 0,
        ("2022-01-24", 1): 6,
        ("2022-01-31", 1): 1,
        ("2022-01-03", 2): 2,
        ("2022-01-10", 2): 6,
        ("2022-01-17", 2): 0,
        ("2022-01-24", 2): 6,
        ("2022-01-31", 2): 1,
    }

    # This patient is in the target population, because they're still registered at the
    # practice.
    current_patient = Patient()
    current_patient.RegistrationHistory = [
        RegistrationHistory(
            StartDate="2001-01-01",
            EndDate="9999-01-01",
            Organisation=Organisation(Organisation_ID=1),
        )
    ]
    current_patient.CodedEventsSnomed = [
        CodedEventSnomed(ConsultationDate=date, ConceptID=code)
        for date, code in event_data
    ]

    # This patient is in the target population, because they died during the timeframe
    # we're interested in.
    dead_patient = Patient(DateOfDeath="2022-01-15")
    dead_patient.RegistrationHistory = [
        RegistrationHistory(
            StartDate="2001-01-01",
            EndDate="2022-01-15",
            Organisation=Organisation(Organisation_ID=2),
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
            Organisation=Organisation(Organisation_ID=3),
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
            Organisation=Organisation(Organisation_ID=4),
        )
    ]
    long_dead_patient.CodedEventsSnomed = [
        CodedEventSnomed(ConsultationDate=date, ConceptID=code)
        for date, code in event_data
    ]

    session = make_session()
    session.add(current_patient)
    session.add(dead_patient)
    session.add(former_patient)
    session.add(long_dead_patient)
    session.commit()

    # Generate the codelist report.
    generate_codelist_report(
        str(tmpdir), os.path.join(tmpdir, "codelist.csv"), start_date, end_date
    )

    # Check counts_per_code is as expected.
    counts_per_code = pd.read_csv(
        tmpdir / "counts_per_code.csv", dtype={"code": "object"}
    ).set_index("code")
    assert dict(counts_per_code["num"]) == expected_counts_per_code

    # Check counts_per_week is as expected.
    counts_per_week = pd.read_csv(
        tmpdir / "counts_per_week.csv", dtype={"date": "object"}
    ).set_index(["date", "practice"])
    assert dict(counts_per_week["num"]) == expected_counts_per_week
