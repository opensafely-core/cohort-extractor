import csv
import tempfile

from tests.tpp_backend_setup import make_database, make_session
from tests.tpp_backend_setup import (
    CodedEvent,
    CovidStatus,
    MedicationIssue,
    MedicationDictionary,
    Patient,
)

from datalab_cohorts import StudyDefinition
from datalab_cohorts import patients


def setup_module(module):
    make_database()


def setup_function(function):
    """Ensure test database is empty
    """
    session = make_session()
    session.query(CovidStatus).delete()
    session.query(CodedEvent).delete()
    session.query(MedicationIssue).delete()
    session.query(MedicationDictionary).delete()
    session.query(Patient).delete()
    session.commit()


def test_ages_and_covid_status():
    session = make_session()
    old_patient_with_covid = Patient(
        DateOfBirth="1900-01-01", CovidStatus=CovidStatus(Result="COVID19")
    )
    young_patient_1_with_covid = Patient(
        DateOfBirth="2000-01-01", CovidStatus=CovidStatus(Result="COVID19")
    )
    young_patient_2_without_covid = Patient(DateOfBirth="2001-01-01")
    session.add(old_patient_with_covid)
    session.add(young_patient_1_with_covid)
    session.add(young_patient_2_without_covid)
    session.commit()

    study = StudyDefinition(
        population=patients.with_positive_covid_test(),
        age=patients.age_as_of("2020-01-01"),
    )
    with tempfile.NamedTemporaryFile(mode="w+") as f:
        study.to_csv(f.name)
        results = list(csv.DictReader(f))
        # XXX the current implementation fails because the first age
        # is computed as 120
        assert [x["age"] for x in results] == ["120.0", "20.0"]
