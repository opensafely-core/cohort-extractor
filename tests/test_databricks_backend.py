import os

import pytest

from cohortextractor import StudyDefinition, codelist, patients
from tests.databricks_backend_setup import (
    CodedEvent,
    Patient,
    make_database,
    make_session,
)


@pytest.fixture(autouse=True)
def set_database_url(monkeypatch):
    monkeypatch.setenv("DATABASE_URL", os.environ["DATABRICKS_DATABASE_URL"])


def setup_module(module):
    make_database()


def setup_function(function):
    session = make_session()
    session.query(CodedEvent).delete()
    session.query(Patient).delete()
    session.commit()


def test_minimal_study():
    session = make_session()
    patient_1 = Patient(
        DateOfBirth="1980-01-01",
        Sex="M",
        CodedEvents=[
            CodedEvent(CTV3Code="aaaaa", ConsultationDate="2018-01-01"),
            CodedEvent(CTV3Code="bbbbb", ConsultationDate="2020-01-01"),
        ],
    )
    patient_2 = Patient(
        DateOfBirth="1965-01-01",
        Sex="F",
        CodedEvents=[CodedEvent(CTV3Code="zzzzz", ConsultationDate="2018-01-01")],
    )
    session.add_all([patient_1, patient_2])
    session.commit()

    codes = codelist(["aaaaa", "bbbbb", "ccccc"], "ctv3")

    study = StudyDefinition(
        population=patients.all(),
        sex=patients.sex(),
        age=patients.age_as_of("2020-01-01"),
        has_event=patients.with_these_clinical_events(codes),
    )

    results = sorted(study.to_dicts(), key=lambda row: row["patient_id"])
    assert results == [
        {"patient_id": patient_1.Patient_ID, "sex": "M", "age": 40, "has_event": 1},
        {"patient_id": patient_2.Patient_ID, "sex": "F", "age": 55, "has_event": 0},
    ]
