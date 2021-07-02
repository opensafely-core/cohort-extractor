import os

import pytest

from cohortextractor import StudyDefinition, codelist, patients
from tests.databricks_backend_setup import (
    CodedEvent2018,
    CodedEvent2019,
    CodedEvent2020,
    Patient,
    clear_database,
    make_database,
    make_session,
)


@pytest.fixture(autouse=True)
def set_database_url(monkeypatch):
    monkeypatch.setenv("DATABASE_URL", os.environ["DATABRICKS_DATABASE_URL"])


def setup_module(module):
    make_database()


def teardown_module(module):
    clear_database()


def setup_function(function):
    session = make_session()
    session.query(CodedEvent2018).delete()
    session.query(CodedEvent2019).delete()
    session.query(CodedEvent2020).delete()
    session.query(Patient).delete()
    session.commit()


def test_minimal_study():
    session = make_session()
    # Has event with matching code in time window
    patient_1 = Patient(
        DateOfBirth="1980-01-01",
        Sex="M",
        CodedEvents2018=[
            CodedEvent2018(CTV3Code="aaaaa", ConsultationDate="2018-01-01"),
        ],
        CodedEvents2019=[
            CodedEvent2019(CTV3Code="aaaaa", ConsultationDate="2019-12-31"),
            CodedEvent2019(CTV3Code="bbbbb", ConsultationDate="2020-01-01"),
        ],
    )
    # Has event with time window but not with matching code
    patient_2 = Patient(
        DateOfBirth="1965-01-01",
        Sex="F",
        CodedEvents2019=[
            CodedEvent2019(CTV3Code="zzzzz", ConsultationDate="2020-01-01"),
        ],
    )
    # Has event with matching code outside time windowk
    patient_3 = Patient(
        DateOfBirth="1950-01-01",
        Sex="F",
        CodedEvents2018=[
            CodedEvent2018(CTV3Code="aaaaa", ConsultationDate="2018-01-01"),
        ],
        CodedEvents2019=[
            CodedEvent2019(CTV3Code="aaaaa", ConsultationDate="2019-01-01"),
        ],
        CodedEvents2020=[
            CodedEvent2020(CTV3Code="bbbbb", ConsultationDate="2020-12-31"),
        ],
    )
    session.add_all([patient_1, patient_2, patient_3])
    session.commit()

    codes = codelist(["aaaaa", "bbbbb", "ccccc"], "ctv3")

    study = StudyDefinition(
        population=patients.all(),
        sex=patients.sex(),
        age=patients.age_as_of("2020-01-01"),
        has_event=patients.with_these_clinical_events(
            codes, between=["2019-06-01", "2020-05-31"]
        ),
    )

    results = sorted(study.to_dicts(), key=lambda row: row["patient_id"])
    assert results == [
        {"patient_id": patient_1.Patient_ID, "sex": "M", "age": 40, "has_event": 1},
        {"patient_id": patient_2.Patient_ID, "sex": "F", "age": 55, "has_event": 0},
        {"patient_id": patient_3.Patient_ID, "sex": "F", "age": 70, "has_event": 0},
    ]
