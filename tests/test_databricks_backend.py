import os

import pytest

from cohortextractor import StudyDefinition, codelist, patients

# Piggy-back off the TPP setup for now
from tests.test_tpp_backend import setup_function as tpp_setup_function
from tests.test_tpp_backend import setup_module as tpp_setup_module
from tests.tpp_backend_setup import CodedEvent, Patient, make_session


@pytest.fixture(autouse=True)
def set_database_url(monkeypatch):
    monkeypatch.setenv("DATABASE_URL", os.environ["DATABRICKS_DATABASE_URL"])


def setup_module(module):
    tpp_setup_module(module)


def setup_function(function):
    tpp_setup_function(function)


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
