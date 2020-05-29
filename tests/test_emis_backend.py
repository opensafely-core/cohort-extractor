import csv
import tempfile

from datalab_cohorts import StudyDefinition, patients
from tests.emis_backend_setup import Patient, make_database, make_session


def setup_module(module):
    make_database()


def setup_function(function):
    session = make_session()
    session.query(Patient).delete()


def test_minimal_study_to_csv():
    session = make_session()
    patient_1 = Patient(DateOfBirth="1900-01-01", Sex="M")
    patient_2 = Patient(DateOfBirth="1900-01-01", Sex="F")
    session.add_all([patient_1, patient_2])
    session.commit()
    study = StudyDefinition(population=patients.all(), sex=patients.sex())
    with tempfile.NamedTemporaryFile(mode="w+") as f:
        study.to_csv(f.name)
        results = list(csv.DictReader(f))
        assert results == [
            {"patient_id": str(patient_1.Patient_ID), "sex": "M"},
            {"patient_id": str(patient_2.Patient_ID), "sex": "F"},
        ]
