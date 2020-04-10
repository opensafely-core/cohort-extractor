import csv
import tempfile

import pytest

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
        died=patients.have_died_of_covid(),
        admitted_itu=patients.admitted_to_itu(),
    )
    results = study.to_dicts()

    assert [x["sex"] for x in results] == ["M", "F"]
    assert [x["died"] for x in results] == ["0", "1"]
    assert [x["admitted_itu"] for x in results] == ["1", "0"]
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
    results = study.to_dicts()
    assert [x["asthma_meds"] for x in results] == ["1", "0"]


def _make_clinical_events_selection(condition_code, patient_dates=None):
    # The default configuration of patients and dates which some tests assume
    if patient_dates is None:
        patient_dates = ["2001-06-01", "2002-06-01", None]
    session = make_session()
    for dates in patient_dates:
        patient = Patient()
        if dates is None:
            dates = []
        elif isinstance(dates, str):
            dates = [dates]
        for date in dates:
            patient.CodedEvents.append(
                CodedEvent(CTV3Code=condition_code, ConsultationDate=date)
            )
        session.add(patient)
    session.commit()


def test_clinical_event_without_filters():
    condition_code = "ASTHMA"
    _make_clinical_events_selection(condition_code)
    # No date criteria
    study = StudyDefinition(
        population=patients.all(),
        asthma_condition=patients.with_these_clinical_events(
            codelist([condition_code], "ctv3")
        ),
    )
    results = study.to_dicts()
    assert [x["asthma_condition"] for x in results] == ["1", "1", "0"]


def test_clinical_event_with_max_date():
    condition_code = "ASTHMA"
    _make_clinical_events_selection(condition_code)
    study = StudyDefinition(
        population=patients.all(),
        asthma_condition=patients.with_these_clinical_events(
            codelist([condition_code], "ctv3"), on_or_before="2001-12-01"
        ),
    )
    results = study.to_dicts()
    assert [x["asthma_condition"] for x in results] == ["1", "0", "0"]


def test_clinical_event_with_min_date():
    condition_code = "ASTHMA"
    _make_clinical_events_selection(condition_code)
    study = StudyDefinition(
        population=patients.all(),
        asthma_condition=patients.with_these_clinical_events(
            codelist([condition_code], "ctv3"), on_or_after="2005-12-01"
        ),
    )
    results = study.to_dicts()
    assert [x["asthma_condition"] for x in results] == ["0", "0", "0"]


def test_clinical_event_with_min_and_max_date():
    condition_code = "ASTHMA"
    _make_clinical_events_selection(condition_code)
    study = StudyDefinition(
        population=patients.all(),
        asthma_condition=patients.with_these_clinical_events(
            codelist([condition_code], "ctv3"), between=["2001-12-01", "2002-06-01"]
        ),
    )
    results = study.to_dicts()
    assert [x["asthma_condition"] for x in results] == ["0", "1", "0"]


def test_clinical_event_returning_first_date():
    condition_code = "ASTHMA"
    _make_clinical_events_selection(
        condition_code,
        patient_dates=[
            None,
            # Include date before period starts, which should be ignored
            ["2001-01-01", "2002-06-01"],
            ["2001-06-01"],
        ],
    )
    study = StudyDefinition(
        population=patients.all(),
        asthma_condition=patients.with_these_clinical_events(
            codelist([condition_code], "ctv3"),
            between=["2001-12-01", "2002-06-01"],
            return_first_date_in_period=True,
            include_month=True,
            include_day=True,
        ),
    )
    results = study.to_dicts()
    assert [x["asthma_condition"] for x in results] == ["", "2002-06-01", ""]


def test_clinical_event_returning_last_date():
    condition_code = "ASTHMA"
    _make_clinical_events_selection(
        condition_code,
        patient_dates=[
            None,
            # Include date after period ends, which should be ignored
            ["2002-06-01", "2003-01-01"],
            ["2001-06-01"],
        ],
    )
    study = StudyDefinition(
        population=patients.all(),
        asthma_condition=patients.with_these_clinical_events(
            codelist([condition_code], "ctv3"),
            between=["2001-12-01", "2002-06-01"],
            return_last_date_in_period=True,
            include_month=True,
            include_day=True,
        ),
    )
    results = study.to_dicts()
    assert [x["asthma_condition"] for x in results] == ["", "2002-06-01", ""]


def test_clinical_event_returning_year_only():
    condition_code = "ASTHMA"
    _make_clinical_events_selection(condition_code)
    # No date criteria
    study = StudyDefinition(
        population=patients.all(),
        asthma_condition=patients.with_these_clinical_events(
            codelist([condition_code], "ctv3"), return_first_date_in_period=True
        ),
    )
    results = study.to_dicts()
    assert [x["asthma_condition"] for x in results] == ["2001", "2002", ""]


def test_clinical_event_returning_year_and_month_only():
    condition_code = "ASTHMA"
    _make_clinical_events_selection(condition_code)
    # No date criteria
    study = StudyDefinition(
        population=patients.all(),
        asthma_condition=patients.with_these_clinical_events(
            codelist([condition_code], "ctv3"),
            return_first_date_in_period=True,
            include_month=True,
        ),
    )
    results = study.to_dicts()
    assert [x["asthma_condition"] for x in results] == ["2001-06", "2002-06", ""]


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
    results = study.to_dicts()
    assert [x["patient_id"] for x in results] == [
        str(patient_registered_in_2001.Patient_ID),
        str(patient_registered_in_2002.Patient_ID),
    ]


def test_patients_registered_with_one_practice_between():
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

    study = StudyDefinition(
        population=patients.registered_with_one_practice_between(
            "2001-12-01", "2003-01-01"
        )
    )
    results = study.to_dicts()
    assert [x["patient_id"] for x in results] == [
        str(patient_registered_in_2001.Patient_ID)
    ]


@pytest.mark.parametrize("include_dates", ["none", "year", "month", "day"])
def test_simple_bmi(include_dates):
    session = make_session()

    weight_code = "X76C7"
    height_code = "XM01E"

    patient = Patient(DateOfBirth="1950-01-01")
    patient.CodedEvents.append(
        CodedEvent(CTV3Code=weight_code, NumericValue=50, ConsultationDate="2002-06-01")
    )
    patient.CodedEvents.append(
        CodedEvent(CTV3Code=height_code, NumericValue=10, ConsultationDate="2001-06-01")
    )
    session.add(patient)
    session.commit()

    if include_dates == "none":
        bmi_date = None
        bmi_kwargs = {}
    elif include_dates == "year":
        bmi_date = "2002"
        bmi_kwargs = dict(include_measurement_date=True)
    elif include_dates == "month":
        bmi_date = "2002-06"
        bmi_kwargs = dict(include_measurement_date=True, include_month=True)
    elif include_dates == "day":
        bmi_date = "2002-06-01"
        bmi_kwargs = dict(
            include_measurement_date=True, include_month=True, include_day=True
        )
    study = StudyDefinition(
        population=patients.all(),
        BMI=patients.most_recent_bmi(
            on_or_after="1995-01-01", on_or_before="2005-01-01", **bmi_kwargs
        ),
    )
    results = study.to_dicts()
    assert [x["BMI"] for x in results] == ["0.5"]
    assert [x.get("BMI_date_measured") for x in results] == [bmi_date]


def test_bmi_rounded():
    session = make_session()

    weight_code = "X76C7"
    height_code = "XM01E"

    patient = Patient(DateOfBirth="1950-01-01")
    patient.CodedEvents.append(
        CodedEvent(
            CTV3Code=weight_code, NumericValue=10.12345, ConsultationDate="2001-06-01"
        )
    )
    patient.CodedEvents.append(
        CodedEvent(CTV3Code=height_code, NumericValue=10, ConsultationDate="2000-02-01")
    )
    session.add(patient)
    session.commit()

    study = StudyDefinition(
        population=patients.all(),
        BMI=patients.most_recent_bmi(
            "2005-01-01",
            include_measurement_date=True,
            include_month=True,
            include_day=True,
        ),
    )
    results = study.to_dicts()
    assert [x["BMI"] for x in results] == ["0.1"]
    assert [x["BMI_date_measured"] for x in results] == ["2001-06-01"]


def test_bmi_with_zero_values():
    session = make_session()

    weight_code = "X76C7"
    height_code = "XM01E"

    patient = Patient(DateOfBirth="1950-01-01")
    patient.CodedEvents.append(
        CodedEvent(CTV3Code=weight_code, NumericValue=0, ConsultationDate="2001-06-01")
    )
    patient.CodedEvents.append(
        CodedEvent(CTV3Code=height_code, NumericValue=0, ConsultationDate="2001-06-01")
    )
    session.add(patient)
    session.commit()

    study = StudyDefinition(
        population=patients.all(),
        BMI=patients.most_recent_bmi(
            on_or_after="1995-01-01",
            on_or_before="2005-01-01",
            include_measurement_date=True,
            include_month=True,
            include_day=True,
        ),
    )
    results = study.to_dicts()
    assert [x["BMI"] for x in results] == ["0.0"]
    assert [x["BMI_date_measured"] for x in results] == ["2001-06-01"]


def test_explicit_bmi_fallback():
    session = make_session()

    weight_code = "X76C7"
    bmi_code = "22K.."

    patient = Patient(DateOfBirth="1950-01-01")
    patient.CodedEvents.append(
        CodedEvent(CTV3Code=weight_code, NumericValue=50, ConsultationDate="2001-06-01")
    )
    patient.CodedEvents.append(
        CodedEvent(CTV3Code=bmi_code, NumericValue=99, ConsultationDate="2001-10-01")
    )
    session.add(patient)
    session.commit()

    study = StudyDefinition(
        population=patients.all(),
        BMI=patients.most_recent_bmi(
            on_or_after="1995-01-01",
            on_or_before="2005-01-01",
            include_measurement_date=True,
            include_month=True,
            include_day=True,
        ),
    )
    results = study.to_dicts()
    assert [x["BMI"] for x in results] == ["99.0"]
    assert [x["BMI_date_measured"] for x in results] == ["2001-10-01"]


def test_no_bmi_when_old_date():
    session = make_session()

    bmi_code = "22K.."

    patient = Patient(DateOfBirth="1950-01-01")
    patient.CodedEvents.append(
        CodedEvent(CTV3Code=bmi_code, NumericValue=99, ConsultationDate="1994-12-31")
    )
    session.add(patient)
    session.commit()

    study = StudyDefinition(
        population=patients.all(),
        BMI=patients.most_recent_bmi(
            on_or_after="1995-01-01",
            on_or_before="2005-01-01",
            include_measurement_date=True,
            include_month=True,
            include_day=True,
        ),
    )
    results = study.to_dicts()
    assert [x["BMI"] for x in results] == ["0.0"]
    assert [x["BMI_date_measured"] for x in results] == [""]


def test_no_bmi_when_measurements_of_child():
    session = make_session()

    bmi_code = "22K.."

    patient = Patient(DateOfBirth="2000-01-01")
    patient.CodedEvents.append(
        CodedEvent(CTV3Code=bmi_code, NumericValue=99, ConsultationDate="2001-01-01")
    )
    session.add(patient)
    session.commit()

    study = StudyDefinition(
        population=patients.all(),
        BMI=patients.most_recent_bmi(
            on_or_after="1995-01-01",
            on_or_before="2005-01-01",
            include_measurement_date=True,
            include_month=True,
            include_day=True,
        ),
    )
    results = study.to_dicts()
    assert [x["BMI"] for x in results] == ["0.0"]
    assert [x["BMI_date_measured"] for x in results] == [""]


def test_no_bmi_when_measurement_after_reference_date():
    session = make_session()

    bmi_code = "22K.."

    patient = Patient(DateOfBirth="1900-01-01")
    patient.CodedEvents.append(
        CodedEvent(CTV3Code=bmi_code, NumericValue=99, ConsultationDate="2001-01-01")
    )
    session.add(patient)
    session.commit()

    study = StudyDefinition(
        population=patients.all(),
        BMI=patients.most_recent_bmi(
            on_or_after="1990-01-01",
            on_or_before="2000-01-01",
            include_measurement_date=True,
            include_month=True,
            include_day=True,
        ),
    )
    results = study.to_dicts()
    assert [x["BMI"] for x in results] == ["0.0"]
    assert [x["BMI_date_measured"] for x in results] == [""]


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

    study = StudyDefinition(
        population=patients.all(),
        BMI=patients.most_recent_bmi(
            on_or_after="2005-01-01",
            on_or_before="2015-01-01",
            include_measurement_date=True,
            include_month=True,
            include_day=True,
        ),
    )
    results = study.to_dicts()
    assert [x["BMI"] for x in results] == ["0.5"]
    assert [x["BMI_date_measured"] for x in results] == ["2010-01-01"]


def test_patient_random_sample():
    session = make_session()
    sample_size = 1000
    for _ in range(sample_size):
        patient = Patient()
        session.add(patient)
    session.commit()

    study = StudyDefinition(population=patients.random_sample(percent=20))
    with tempfile.NamedTemporaryFile(mode="w+") as f:
        study.to_csv(f.name)
        results = study.to_dicts()
        # The method is approximate!
        expected = sample_size * 0.2
        assert abs(len(results) - expected) < (expected * 0.1)
