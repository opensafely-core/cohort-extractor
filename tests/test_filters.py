import csv
import tempfile

from tests.tpp_backend_setup import make_database, make_session
from tests.tpp_backend_setup import (
    CodedEvent,
    CovidStatus,
    MedicationIssue,
    MedicationDictionary,
    Patient,
    RegistrationHistory,
)

from datalab_cohorts import StudyDefinition
from datalab_cohorts import patients
from datalab_cohorts import codelist


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
    session.query(RegistrationHistory).delete()
    session.query(Patient).delete()
    session.commit()


def test_patient_characteristics_for_covid_status():
    session = make_session()
    old_patient_with_covid = Patient(
        DateOfBirth="1900-01-01",
        CovidStatus=CovidStatus(Result="COVID19", AdmittedToITU=True),
        Sex="M",
    )
    young_patient_1_with_covid = Patient(
        DateOfBirth="2000-01-01",
        CovidStatus=CovidStatus(Result="COVID19", Died=True),
        Sex="F",
    )
    young_patient_2_without_covid = Patient(DateOfBirth="2001-01-01", Sex="F")
    session.add(old_patient_with_covid)
    session.add(young_patient_1_with_covid)
    session.add(young_patient_2_without_covid)
    session.commit()

    study = StudyDefinition(
        population=patients.with_positive_covid_test(),
        age=patients.age_as_of("2020-01-01"),
        sex=patients.sex(),
        died=patients.have_died(),
        admitted_itu=patients.admitted_to_itu(),
    )
    with tempfile.NamedTemporaryFile(mode="w+") as f:
        study.to_csv(f.name)
        results = list(csv.DictReader(f))
        assert [x["sex"] for x in results] == ["M", "F"]
        assert [x["died"] for x in results] == ["0.0", "1.0"]
        assert [x["admitted_itu"] for x in results] == ["1.0", "0.0"]
        # XXX the current implementation fails because the first age
        # is computed as 120
        assert [x["age"] for x in results] == ["120", "20"]


def test_meds():
    session = make_session()

    asthma_medication = MedicationDictionary(
        FullName="Asthma Drug", DMD_ID="0", MultilexDrug_ID="0"
    )
    patient_with_med = Patient()
    patient_with_med.MedicationIssues = [
        MedicationIssue(MedicationDictionary=asthma_medication, StartDate="2010-01-01")
    ]
    patient_without_med = Patient()
    session.add(patient_with_med)
    session.add(patient_without_med)
    session.commit()

    study = StudyDefinition(
        population=patients.all(),
        asthma_meds=patients.with_these_medications(
            codelist(asthma_medication.DMD_ID, "snomed")
        ),
    )
    with tempfile.NamedTemporaryFile(mode="w+") as f:
        study.to_csv(f.name)
        results = list(csv.DictReader(f))
        assert [x["asthma_meds"] for x in results] == ["1.0", "0.0"]


def test_clinical_events():
    session = make_session()

    condition_code = "ASTHMA"

    patient_with_condition_in_2001 = Patient()
    patient_with_condition_in_2002 = Patient()
    patient_with_condition_in_2001.CodedEvents.append(
        CodedEvent(CTV3Code=condition_code, ConsultationDate="2001-06-01")
    )
    patient_with_condition_in_2002.CodedEvents.append(
        CodedEvent(CTV3Code=condition_code, ConsultationDate="2002-06-01")
    )
    patient_without_condition = Patient()
    session.add(patient_with_condition_in_2001)
    session.add(patient_with_condition_in_2002)
    session.add(patient_without_condition)
    session.commit()

    # No date criteria
    study = StudyDefinition(
        population=patients.all(),
        asthma_condition=patients.with_these_clinical_events(
            codelist([condition_code], "ctv3")
        ),
    )
    with tempfile.NamedTemporaryFile(mode="w+") as f:
        study.to_csv(f.name)
        results = list(csv.DictReader(f))
        assert [x["asthma_condition"] for x in results] == ["1.0", "1.0", "0.0"]

    # A max date
    study = StudyDefinition(
        population=patients.all(),
        asthma_condition=patients.with_these_clinical_events(
            codelist([condition_code], "ctv3"), max_date="2001-12-01"
        ),
    )
    with tempfile.NamedTemporaryFile(mode="w+") as f:
        study.to_csv(f.name)
        results = list(csv.DictReader(f))
        assert [x["asthma_condition"] for x in results] == ["1.0", "0.0", "0.0"]

    # A min date
    study = StudyDefinition(
        population=patients.all(),
        asthma_condition=patients.with_these_clinical_events(
            codelist([condition_code], "ctv3"), min_date="2005-12-01"
        ),
    )
    with tempfile.NamedTemporaryFile(mode="w+") as f:
        study.to_csv(f.name)
        results = list(csv.DictReader(f))
        assert [x["asthma_condition"] for x in results] == ["0.0", "0.0", "0.0"]

    # A min and max date
    study = StudyDefinition(
        population=patients.all(),
        asthma_condition=patients.with_these_clinical_events(
            codelist([condition_code], "ctv3"),
            min_date="2001-12-01",
            max_date="2002-06-01",
        ),
    )
    with tempfile.NamedTemporaryFile(mode="w+") as f:
        study.to_csv(f.name)
        results = list(csv.DictReader(f))
        assert [x["asthma_condition"] for x in results] == ["0.0", "1.0", "0.0"]


def test_patient_registered_as_of():
    session = make_session()

    patient_registered_in_2001 = Patient()
    patient_registered_in_2002 = Patient()
    patient_unregistered_in_2002 = Patient()
    patient_registered_in_2001.RegistrationHistory = [
        RegistrationHistory(StartDate="2001-01-01", EndDate="9999-01-01")
    ]
    patient_registered_in_2002.RegistrationHistory = [
        RegistrationHistory(StartDate="2002-01-01", EndDate="9999-01-01")
    ]
    patient_unregistered_in_2002.RegistrationHistory = [
        RegistrationHistory(StartDate="2001-01-01", EndDate="2002-01-01")
    ]

    session.add(patient_registered_in_2001)
    session.add(patient_registered_in_2002)
    session.add(patient_unregistered_in_2002)
    session.commit()

    # No date criteria
    study = StudyDefinition(population=patients.registered_as_of("2002-03-02"))
    with tempfile.NamedTemporaryFile(mode="w+") as f:
        study.to_csv(f.name)
        results = list(csv.DictReader(f))
        assert [x["patient_id"] for x in results] == [
            str(patient_registered_in_2001.Patient_ID),
            str(patient_registered_in_2002.Patient_ID),
        ]


def test_simple_bmi():
    session = make_session()

    weight_code = "X76C7"
    height_code = "XM01E"

    patient = Patient(DateOfBirth="1950-01-01")
    patient.CodedEvents.append(
        CodedEvent(CTV3Code=weight_code, NumericValue=50, ConsultationDate="2001-06-01")
    )
    patient.CodedEvents.append(
        CodedEvent(CTV3Code=height_code, NumericValue=10, ConsultationDate="2001-06-01")
    )
    session.add(patient)
    session.commit()

    study = StudyDefinition(population=patients.all(), BMI=patients.bmi("2005-01-01"))
    with tempfile.NamedTemporaryFile(mode="w+") as f:
        study.to_csv(f.name)
        results = list(csv.DictReader(f))
        assert [x["BMI"] for x in results] == ["0.5"]


def test_explicit_bmi_fallback():
    session = make_session()

    weight_code = "X76C7"
    bmi_code = "22K.."

    patient = Patient(DateOfBirth="1950-01-01")
    patient.CodedEvents.append(
        CodedEvent(CTV3Code=weight_code, NumericValue=50, ConsultationDate="2001-06-01")
    )
    patient.CodedEvents.append(
        CodedEvent(CTV3Code=bmi_code, NumericValue=99, ConsultationDate="2001-06-01")
    )
    session.add(patient)
    session.commit()

    study = StudyDefinition(population=patients.all(), BMI=patients.bmi("2005-01-01"))
    with tempfile.NamedTemporaryFile(mode="w+") as f:
        study.to_csv(f.name)
        results = list(csv.DictReader(f))
        assert [x["BMI"] for x in results] == ["99.0"]


def test_no_bmi_when_old_date():
    session = make_session()

    bmi_code = "22K.."

    patient = Patient(DateOfBirth="1950-01-01")
    patient.CodedEvents.append(
        CodedEvent(CTV3Code=bmi_code, NumericValue=99, ConsultationDate="1994-12-31")
    )
    session.add(patient)
    session.commit()

    study = StudyDefinition(population=patients.all(), BMI=patients.bmi("2005-01-01"))
    with tempfile.NamedTemporaryFile(mode="w+") as f:
        study.to_csv(f.name)
        results = list(csv.DictReader(f))
        assert [x["BMI"] for x in results] == ["0"]


def test_no_bmi_when_measurements_of_child():
    session = make_session()

    bmi_code = "22K.."

    patient = Patient(DateOfBirth="2000-01-01")
    patient.CodedEvents.append(
        CodedEvent(CTV3Code=bmi_code, NumericValue=99, ConsultationDate="2001-01-01")
    )
    session.add(patient)
    session.commit()

    study = StudyDefinition(population=patients.all(), BMI=patients.bmi("2005-01-01"))
    with tempfile.NamedTemporaryFile(mode="w+") as f:
        study.to_csv(f.name)
        results = list(csv.DictReader(f))
        assert [x["BMI"] for x in results] == ["0"]


def test_no_bmi_when_measurement_after_reference_date():
    session = make_session()

    bmi_code = "22K.."

    patient = Patient(DateOfBirth="1900-01-01")
    patient.CodedEvents.append(
        CodedEvent(CTV3Code=bmi_code, NumericValue=99, ConsultationDate="2001-01-01")
    )
    session.add(patient)
    session.commit()

    study = StudyDefinition(population=patients.all(), BMI=patients.bmi("2000-01-01"))
    with tempfile.NamedTemporaryFile(mode="w+") as f:
        study.to_csv(f.name)
        results = list(csv.DictReader(f))
        assert [x["BMI"] for x in results] == ["0"]


def test_bmi_when_only_some_measurements_of_child():
    session = make_session()

    bmi_code = "22K.."
    weight_code = "X76C7"
    height_code = "XM01E"

    patient = Patient(DateOfBirth="1990-01-01")
    patient.CodedEvents.append(
        CodedEvent(CTV3Code=bmi_code, NumericValue=99, ConsultationDate="1995-01-01")
    )
    patient.CodedEvents.append(
        CodedEvent(CTV3Code=weight_code, NumericValue=50, ConsultationDate="2010-01-01")
    )
    patient.CodedEvents.append(
        CodedEvent(CTV3Code=height_code, NumericValue=10, ConsultationDate="2010-01-01")
    )
    session.add(patient)
    session.commit()

    study = StudyDefinition(population=patients.all(), BMI=patients.bmi("2015-01-01"))
    with tempfile.NamedTemporaryFile(mode="w+") as f:
        study.to_csv(f.name)
        results = list(csv.DictReader(f))
        assert [x["BMI"] for x in results] == ["0.5"]
