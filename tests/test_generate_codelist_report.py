import csv
import os
import random

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
    start_date = "2020-01-01"
    end_date = "2020-01-31"

    # The codes in our codelist.
    codelist_codes = ["11111111", "22222222"]

    with open(tmpdir / "codelist.csv", "w") as f:
        writer = csv.writer(f)
        writer.writerow(["code"])
        writer.writerows([[code] for code in codelist_codes])

    # The first two codes are in the codelist but the third is not
    codes = codelist_codes + ["33333333"]

    # The first and last dates are not in the time period but the others are.
    dates = ["2019-12-31", "2020-01-01", "2020-01-15", "2020-01-31", "2020-02-01"]

    patients = create_patients()
    current_patient_events, dead_patient_events = create_patient_events(
        patients, codes, dates
    )

    session = make_session()
    for patient in patients:
        session.add(patient)
    session.commit()

    # Work out how many events we expect per code and per week.
    expected_counts_per_code = {code: 0 for code in codelist_codes}
    expected_counts_per_week = {
        week: 0
        for week in [
            "2020-01-06",
            "2020-01-13",
            "2020-01-20",
            "2020-01-27",
            "2020-02-03",
        ]
    }

    date_to_last_of_week = {
        "2020-01-01": "2020-01-06",
        "2020-01-15": "2020-01-20",
        "2020-01-31": "2020-02-03",
    }

    for code, date in current_patient_events + dead_patient_events:
        if code == "33333333":
            continue
        if not (start_date <= date <= end_date):
            continue
        expected_counts_per_code[code] += 1
        expected_counts_per_week[date_to_last_of_week[date]] += 1

    # Generate the codelist report.
    generate_codelist_report(
        str(tmpdir), os.path.join(tmpdir, "codelist.csv"), start_date, end_date
    )

    # Check counts_per_week is as expected.
    counts_per_code = pd.read_csv(
        tmpdir / "counts_per_code.csv", dtype={"code": "object"}
    ).set_index("code")
    assert dict(counts_per_code["num"]) == expected_counts_per_code

    # Check counts_per_code is as expected.
    counts_per_week = pd.read_csv(
        tmpdir / "counts_per_week.csv", dtype={"date": "object"}
    ).set_index("date")
    assert dict(counts_per_week["num"]) == expected_counts_per_week


def create_patients():
    # Theis patient is in the target population, because they're still registered at the
    # practice.
    current_patient = Patient()
    current_patient.RegistrationHistory = [
        RegistrationHistory(
            StartDate="2001-01-01", EndDate="9999-01-01", Organisation=Organisation()
        )
    ]

    # This patient is in the target population, because they died during the timeframe
    # we're interested in.
    dead_patient = Patient(DateOfDeath="2020-01-15")
    dead_patient.RegistrationHistory = [
        RegistrationHistory(
            StartDate="2001-01-01", EndDate="2020-01-15", Organisation=Organisation()
        )
    ]

    # This patient is not in the target population, because they were not registered by
    # the end of the timeframe we're interested in.
    former_patient = Patient()
    former_patient.RegistrationHistory = [
        RegistrationHistory(
            StartDate="2001-01-01", EndDate="2020-01-15", Organisation=Organisation()
        )
    ]

    # This patient is not in the target population, because they died before the
    # timeframe we're interested in.
    long_dead_patient = Patient(DateOfDeath="2011-12-31")
    long_dead_patient.RegistrationHistory = [
        RegistrationHistory(
            StartDate="2001-01-01", EndDate="2011-12-31", Organisation=Organisation()
        )
    ]

    return current_patient, dead_patient, former_patient, long_dead_patient


def create_patient_events(patients, codes, dates):
    # Pick some random code/date pairs for each patient, and record these for patients
    # in the population.

    current_patient, dead_patient, former_patient, long_dead_patient = patients

    current_patient_events = [
        (random.choice(codes), random.choice(dates)) for _ in range(20)
    ]
    current_patient.CodedEventsSnomed = [
        CodedEventSnomed(ConceptID=code, ConsultationDate=date)
        for code, date in current_patient_events
    ]

    dead_patient_events = [
        (random.choice(codes), random.choice(dates)) for _ in range(20)
    ]
    dead_patient.CodedEventsSnomed = [
        CodedEventSnomed(ConceptID=code, ConsultationDate=date)
        for code, date in dead_patient_events
    ]

    former_patient.CodedEventsSnomed = [
        CodedEventSnomed(
            ConceptID=random.choice(codes), ConsultationDate=random.choice(dates)
        )
        for _ in range(20)
    ]

    long_dead_patient.CodedEventsSnomed = [
        CodedEventSnomed(
            ConceptID=random.choice(codes), ConsultationDate=random.choice(dates)
        )
        for _ in range(20)
    ]

    return current_patient_events, dead_patient_events
