# -*- coding: utf-8 -*-
import csv
import gzip
import os
import subprocess
from unittest.mock import patch

import pandas
import pytest

from cohortextractor import StudyDefinition, codelist, patients
from cohortextractor.date_expressions import InvalidExpressionError
from cohortextractor.mssql_utils import mssql_connection_params_from_url
from cohortextractor.tpp_backend import (
    AppointmentStatus,
    escape_like_query_fragment,
    quote,
)
from tests.helpers import assert_results
from tests.tpp_backend_setup import (
    APCS,
    CPNS,
    EC,
    ICNARC,
    OPA,
    APCS_Der,
    Appointment,
    CodedEvent,
    CodedEventSnomed,
    DecisionSupportValue,
    EC_Diagnosis,
    HighCostDrugs,
    Household,
    HouseholdMember,
    MedicationDictionary,
    MedicationIssue,
    ONSDeaths,
    Organisation,
    Patient,
    PatientAddress,
    PotentialCareHomeAddress,
    RegistrationHistory,
    SGSS_AllTests_Negative,
    SGSS_AllTests_Positive,
    SGSS_Negative,
    SGSS_Positive,
    Vaccination,
    VaccinationReference,
    make_database,
    make_session,
)


@pytest.fixture(autouse=True)
def set_database_url(monkeypatch):
    # The StudyDefinition code expects a single DATABASE_URL to tell it where
    # to connect to, but the test environment needs to supply multiple
    # connections (one for each backend type) so we copy the value in here
    if "TPP_DATABASE_URL" in os.environ:
        monkeypatch.setenv("DATABASE_URL", os.environ["TPP_DATABASE_URL"])


def setup_module(module):
    make_database()


def setup_function(function):
    """Ensure test database is empty"""
    session = make_session()
    session.query(CodedEvent).delete()
    session.query(CodedEventSnomed).delete()
    session.query(ICNARC).delete()
    session.query(ONSDeaths).delete()
    session.query(CPNS).delete()
    session.query(Vaccination).delete()
    session.query(VaccinationReference).delete()
    session.query(Appointment).delete()
    session.query(SGSS_AllTests_Negative).delete()
    session.query(SGSS_AllTests_Positive).delete()
    session.query(SGSS_Negative).delete()
    session.query(SGSS_Positive).delete()
    session.query(MedicationIssue).delete()
    session.query(MedicationDictionary).delete()
    session.query(RegistrationHistory).delete()
    session.query(Organisation).delete()
    session.query(PotentialCareHomeAddress).delete()
    session.query(PatientAddress).delete()
    session.query(HouseholdMember).delete()
    session.query(Household).delete()
    session.query(EC_Diagnosis).delete()
    session.query(EC).delete()
    session.query(APCS_Der).delete()
    session.query(APCS).delete()
    session.query(OPA).delete()
    session.query(HighCostDrugs).delete()
    session.query(DecisionSupportValue).delete()
    session.query(Patient).delete()
    session.commit()


@pytest.mark.parametrize("format", ["csv", "csv.gz", "feather", "dta", "dta.gz"])
def test_minimal_study_to_file(tmp_path, format):
    session = make_session()
    patient_1 = Patient(DateOfBirth="1980-01-01", Sex="M")
    patient_2 = Patient(DateOfBirth="1965-01-01", Sex="F")
    session.add_all([patient_1, patient_2])
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        sex=patients.sex(),
        age=patients.age_as_of("2020-01-01"),
    )
    filename = tmp_path / f"test.{format}"
    study.to_file(filename)
    cast = lambda x: x  # noqa
    if format == "csv":
        cast = str
        with open(filename) as f:
            results = list(csv.DictReader(f))
    if format == "csv.gz":
        cast = str
        with gzip.open(filename, "rt") as f:
            results = list(csv.DictReader(f))
    elif format == "feather":
        results = pandas.read_feather(filename).to_dict("records")
    elif format in ("dta", "dta.gz"):
        results = pandas.read_stata(filename).to_dict("records")
    assert results == [
        {"patient_id": cast(patient_1.Patient_ID), "sex": "M", "age": cast(40)},
        {"patient_id": cast(patient_2.Patient_ID), "sex": "F", "age": cast(55)},
    ]


def test_sql_error_propagates(tmp_path):
    study = StudyDefinition(population=patients.all(), sex=patients.sex())
    # A bit hacky: fiddle with the list of queries to insert a deliberate error
    # at the end
    study.backend.queries[-1] = "SELECT Foo FROM Bar"
    with pytest.raises(Exception) as excinfo:
        study.to_file(tmp_path / "test.csv")
    assert "Invalid object name 'Bar'" in str(excinfo.value)


def test_correct_driver_used():
    # We support multiple drivers but we want to make sure our tests are
    # running against the same driver we use in production
    study = StudyDefinition(population=patients.all())
    module = study.backend.get_db_connection().__class__.__module__
    assert module == "ctds"


def test_meds():
    session = make_session()

    asthma_medication = MedicationDictionary(
        FullName="Asthma Drug", DMD_ID="0", MultilexDrug_ID="0"
    )
    patient_with_med = Patient()
    patient_with_med.MedicationIssues = [
        MedicationIssue(
            MedicationDictionary=asthma_medication, ConsultationDate="2010-01-01"
        )
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


def test_meds_with_count():
    session = make_session()

    asthma_medication = MedicationDictionary(
        FullName="Asthma Drug", DMD_ID="0", MultilexDrug_ID="0"
    )
    patient_with_med = Patient()
    patient_with_med.MedicationIssues = [
        MedicationIssue(
            MedicationDictionary=asthma_medication, ConsultationDate="2010-01-01"
        ),
        MedicationIssue(
            MedicationDictionary=asthma_medication, ConsultationDate="2015-01-01"
        ),
        MedicationIssue(
            MedicationDictionary=asthma_medication, ConsultationDate="2018-01-01"
        ),
        MedicationIssue(
            MedicationDictionary=asthma_medication, ConsultationDate="2020-01-01"
        ),
    ]
    patient_without_med = Patient()
    session.add(patient_with_med)
    session.add(patient_without_med)
    session.commit()

    study = StudyDefinition(
        population=patients.all(),
        asthma_meds=patients.with_these_medications(
            codelist(asthma_medication.DMD_ID, "snomed"),
            on_or_after="2012-01-01",
            return_number_of_matches_in_period=True,
        ),
    )
    results = study.to_dicts()
    assert [x["asthma_meds"] for x in results] == ["3", "0"]


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
            if isinstance(date, tuple):
                date, value = date
            else:
                value = 0.0
            patient.CodedEvents.append(
                CodedEvent(
                    CTV3Code=condition_code, ConsultationDate=date, NumericValue=value
                )
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


def test_snomed_clinical_event():
    condition_code = "123456"
    session = make_session()
    patient = Patient()
    patient.CodedEventsSnomed.append(
        CodedEventSnomed(ConceptID=condition_code, ConsultationDate="2020-01-01")
    )
    session.add(patient)
    session.add(Patient())
    session.commit()

    study = StudyDefinition(
        population=patients.all(),
        asthma_condition=patients.with_these_clinical_events(
            codelist([condition_code], "snomed")
        ),
    )
    results = study.to_dicts()
    assert [x["asthma_condition"] for x in results] == ["1", "0"]


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
            returning="date",
            find_first_match_in_period=True,
            date_format="YYYY-MM-DD",
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
            returning="date",
            find_last_match_in_period=True,
            date_format="YYYY-MM-DD",
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
            codelist([condition_code], "ctv3"),
            returning="date",
            find_first_match_in_period=True,
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
            returning="date",
            find_first_match_in_period=True,
            date_format="YYYY-MM",
        ),
    )
    results = study.to_dicts()
    assert [x["asthma_condition"] for x in results] == ["2001-06", "2002-06", ""]


def test_clinical_event_with_count():
    condition_code = "ASTHMA"
    _make_clinical_events_selection(
        condition_code,
        patient_dates=[
            None,
            # Include date before period starts, which should be ignored
            ["2001-01-01", "2002-01-01", "2002-02-01", "2002-06-01"],
            ["2001-06-01"],
        ],
    )
    study = StudyDefinition(
        population=patients.all(),
        asthma_count=patients.with_these_clinical_events(
            codelist([condition_code], "ctv3"),
            between=["2001-12-01", "2002-06-01"],
            returning="number_of_matches_in_period",
            find_first_match_in_period=True,
        ),
        asthma_count_date=patients.date_of("asthma_count", date_format="YYYY-MM"),
    )
    results = study.to_dicts()
    assert [x["asthma_count"] for x in results] == ["0", "3", "0"]
    assert [x["asthma_count_date"] for x in results] == ["", "2002-01", ""]


def test_clinical_event_with_code():
    condition_code = "ASTHMA"
    _make_clinical_events_selection(
        condition_code,
        patient_dates=[
            None,
            # Include date before period starts, which should be ignored
            ["2001-01-01", "2002-01-01", "2002-02-01", "2002-06-01"],
            ["2001-06-01"],
        ],
    )
    study = StudyDefinition(
        population=patients.all(),
        latest_asthma_code=patients.with_these_clinical_events(
            codelist([condition_code], "ctv3"),
            between=["2001-12-01", "2002-06-01"],
            returning="code",
            find_last_match_in_period=True,
        ),
        latest_asthma_code_date=patients.date_of(
            "latest_asthma_code", date_format="YYYY-MM"
        ),
    )
    results = study.to_dicts()
    assert [x["latest_asthma_code"] for x in results] == ["", condition_code, ""]
    assert [x["latest_asthma_code_date"] for x in results] == ["", "2002-06", ""]


def test_clinical_event_with_numeric_value():
    condition_code = "ASTHMA"
    _make_clinical_events_selection(
        condition_code,
        patient_dates=[
            None,
            # Include date before period starts, which should be ignored
            [
                ("2001-01-01", 1),
                ("2002-01-01", 2),
                ("2002-02-01", 3),
                ("2002-06-01", 4),
            ],
            [("2001-06-01", 7)],
        ],
    )
    study = StudyDefinition(
        population=patients.all(),
        asthma_value=patients.with_these_clinical_events(
            codelist([condition_code], "ctv3"),
            between=["2001-12-01", "2002-06-01"],
            returning="numeric_value",
            find_first_match_in_period=True,
        ),
        asthma_value_date=patients.date_of("asthma_value", date_format="YYYY-MM"),
    )
    results = study.to_dicts()
    assert [x["asthma_value"] for x in results] == ["0.0", "2.0", "0.0"]
    assert [x["asthma_value_date"] for x in results] == ["", "2002-01", ""]


def test_clinical_event_ignoring_missing_values():
    condition_code = "ASTHMA"
    _make_clinical_events_selection(
        condition_code,
        patient_dates=[
            [
                ("2001-01-01", 0),
                ("2001-01-02", 2),
                ("2001-01-03", 0),
                ("2001-01-04", 4),
                ("2001-01-05", 0),
            ],
        ],
    )
    study = StudyDefinition(
        population=patients.all(),
        first=patients.with_these_clinical_events(
            codelist([condition_code], "ctv3"),
            returning="numeric_value",
            ignore_missing_values=True,
            find_first_match_in_period=True,
        ),
        last=patients.with_these_clinical_events(
            codelist([condition_code], "ctv3"),
            returning="numeric_value",
            ignore_missing_values=True,
            find_last_match_in_period=True,
        ),
    )
    results = study.to_dicts()
    assert [x["first"] for x in results] == ["2.0"]
    assert [x["last"] for x in results] == ["4.0"]


def test_clinical_event_with_category():
    session = make_session()
    session.add_all(
        [
            Patient(),
            Patient(
                CodedEvents=[
                    CodedEvent(CTV3Code="foo1", ConsultationDate="2018-01-01"),
                    CodedEvent(CTV3Code="foo2", ConsultationDate="2020-01-01"),
                ]
            ),
            Patient(
                CodedEvents=[CodedEvent(CTV3Code="foo3", ConsultationDate="2019-01-01")]
            ),
        ]
    )
    session.commit()
    codes = codelist([("foo1", "A"), ("foo2", "B"), ("foo3", "C")], "ctv3")
    study = StudyDefinition(
        population=patients.all(),
        code_category=patients.with_these_clinical_events(
            codes, returning="category", find_last_match_in_period=True
        ),
        code_category_date=patients.date_of("code_category"),
    )
    results = study.to_dicts()
    assert [x["code_category"] for x in results] == ["", "B", "C"]
    assert [x["code_category_date"] for x in results] == ["", "2020", "2019"]


def test_patient_registered_as_of():
    session = make_session()

    patient_registered_in_2001 = Patient()
    patient_registered_in_2002 = Patient()
    patient_unregistered_in_2002 = Patient()
    patient_registered_in_2001.RegistrationHistory = [
        RegistrationHistory(
            StartDate="2001-01-01", EndDate="9999-01-01", Organisation=Organisation()
        )
    ]
    patient_registered_in_2002.RegistrationHistory = [
        RegistrationHistory(
            StartDate="2002-01-01", EndDate="9999-01-01", Organisation=Organisation()
        )
    ]
    patient_unregistered_in_2002.RegistrationHistory = [
        RegistrationHistory(
            StartDate="2001-01-01", EndDate="2002-01-01", Organisation=Organisation()
        )
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
        RegistrationHistory(
            StartDate="2001-01-01", EndDate="9999-01-01", Organisation=Organisation()
        )
    ]
    patient_registered_in_2002.RegistrationHistory = [
        RegistrationHistory(
            StartDate="2002-01-01", EndDate="9999-01-01", Organisation=Organisation()
        )
    ]
    patient_unregistered_in_2002.RegistrationHistory = [
        RegistrationHistory(
            StartDate="2001-01-01", EndDate="2002-01-01", Organisation=Organisation()
        )
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
        date_query = None
    elif include_dates == "year":
        bmi_date = "2002"
        date_query = patients.date_of("BMI")
    elif include_dates == "month":
        bmi_date = "2002-06"
        date_query = patients.date_of("BMI", date_format="YYYY-MM")
    elif include_dates == "day":
        bmi_date = "2002-06-01"
        date_query = patients.date_of("BMI", date_format="YYYY-MM-DD")
    study = StudyDefinition(
        population=patients.all(),
        BMI=patients.most_recent_bmi(
            on_or_after="1995-01-01", on_or_before="2005-01-01"
        ),
        **dict(BMI_date_measured=date_query) if date_query else {},
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
        ),
        BMI_date_measured=patients.date_of("BMI", date_format="YYYY-MM-DD"),
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
        ),
        BMI_date_measured=patients.date_of("BMI", date_format="YYYY-MM-DD"),
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
        ),
        BMI_date_measured=patients.date_of("BMI", date_format="YYYY-MM-DD"),
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
        ),
        BMI_date_measured=patients.date_of("BMI", date_format="YYYY-MM-DD"),
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
        ),
        BMI_date_measured=patients.date_of("BMI", date_format="YYYY-MM-DD"),
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
        ),
        BMI_date_measured=patients.date_of("BMI", date_format="YYYY-MM-DD"),
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
        ),
        BMI_date_measured=patients.date_of("BMI", date_format="YYYY-MM-DD"),
    )
    results = study.to_dicts()
    assert [x["BMI"] for x in results] == ["0.5"]
    assert [x["BMI_date_measured"] for x in results] == ["2010-01-01"]


def test_mean_recorded_value():
    code = "2469."
    session = make_session()
    patient = Patient()
    values = [
        ("2020-02-10", 90),
        ("2020-02-10", 100),
        ("2020-02-10", 98),
        # This day is outside period and should be ignored
        ("2020-04-01", 110),
    ]
    for date, value in values:
        patient.CodedEvents.append(
            CodedEvent(CTV3Code=code, NumericValue=value, ConsultationDate=date)
        )
    patient_with_old_reading = Patient()
    patient_with_old_reading.CodedEvents.append(
        CodedEvent(CTV3Code=code, NumericValue=100, ConsultationDate="2010-01-01")
    )
    patient_with_no_reading = Patient()
    session.add_all([patient, patient_with_old_reading, patient_with_no_reading])
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        bp_systolic=patients.mean_recorded_value(
            codelist([code], system="ctv3"),
            on_most_recent_day_of_measurement=True,
            between=["2018-01-01", "2020-03-01"],
        ),
        bp_systolic_date_measured=patients.date_of(
            "bp_systolic", date_format="YYYY-MM-DD"
        ),
    )
    results = study.to_dicts()
    results = [(i["bp_systolic"], i["bp_systolic_date_measured"]) for i in results]
    assert results == [("96.0", "2020-02-10"), ("0.0", ""), ("0.0", "")]


def test_patient_random_sample():
    session = make_session()
    sample_size = 1000
    for _ in range(sample_size):
        patient = Patient()
        session.add(patient)
    session.commit()

    study = StudyDefinition(population=patients.random_sample(percent=20))
    results = study.to_dicts()
    # The method is approximate!
    assert len(results) < (sample_size / 2)


def test_patients_satisfying():
    condition_code = "ASTHMA"
    session = make_session()
    patient_1 = Patient(DateOfBirth="1940-01-01", Sex="M")
    patient_2 = Patient(DateOfBirth="1940-01-01", Sex="F")
    patient_3 = Patient(DateOfBirth="1990-01-01", Sex="M")
    patient_4 = Patient(DateOfBirth="1940-01-01", Sex="F")
    patient_4.CodedEvents.append(
        CodedEvent(CTV3Code=condition_code, ConsultationDate="2010-01-01")
    )
    session.add_all([patient_1, patient_2, patient_3, patient_4])
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        sex=patients.sex(),
        age=patients.age_as_of("2020-01-01"),
        has_asthma=patients.with_these_clinical_events(
            codelist([condition_code], "ctv3")
        ),
        at_risk=patients.satisfying("((age + 30) > 100 AND sex = 'M') OR has_asthma"),
    )
    results = study.to_dicts()
    assert [i["at_risk"] for i in results] == ["1", "0", "0", "1"]


def test_patients_satisfying_with_hidden_columns():
    condition_code = "ASTHMA"
    condition_code2 = "COPD"
    session = make_session()
    patient_1 = Patient(DateOfBirth="1940-01-01", Sex="M")
    patient_2 = Patient(DateOfBirth="1940-01-01", Sex="F")
    patient_3 = Patient(DateOfBirth="1990-01-01", Sex="M")
    patient_4 = Patient(DateOfBirth="1940-01-01", Sex="F")
    patient_4.CodedEvents.append(
        CodedEvent(CTV3Code=condition_code, ConsultationDate="2010-01-01")
    )
    patient_5 = Patient(DateOfBirth="1940-01-01", Sex="F")
    patient_5.CodedEvents.append(
        CodedEvent(CTV3Code=condition_code, ConsultationDate="2010-01-01")
    )
    patient_5.CodedEvents.append(
        CodedEvent(CTV3Code=condition_code2, ConsultationDate="2010-01-01")
    )
    session.add_all([patient_1, patient_2, patient_3, patient_4, patient_5])
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        sex=patients.sex(),
        age=patients.age_as_of("2020-01-01"),
        at_risk=patients.satisfying(
            """
            (age > 70 AND sex = "M")
            OR
            (has_asthma AND NOT copd)
            """,
            has_asthma=patients.with_these_clinical_events(
                codelist([condition_code], "ctv3")
            ),
            copd=patients.with_these_clinical_events(
                codelist([condition_code2], "ctv3")
            ),
        ),
    )
    results = study.to_dicts()
    assert [i["at_risk"] for i in results] == ["1", "0", "0", "1", "0"]
    assert "has_asthma" not in results[0].keys()


def test_patients_categorised_as():
    session = make_session()
    session.add_all(
        [
            Patient(
                Sex="M",
                CodedEvents=[
                    CodedEvent(CTV3Code="foo1", ConsultationDate="2000-01-01")
                ],
            ),
            Patient(
                Sex="F",
                CodedEvents=[
                    CodedEvent(CTV3Code="foo2", ConsultationDate="2000-01-01"),
                    CodedEvent(CTV3Code="bar1", ConsultationDate="2000-01-01"),
                ],
            ),
            Patient(
                Sex="M",
                CodedEvents=[
                    CodedEvent(CTV3Code="foo2", ConsultationDate="2000-01-01")
                ],
            ),
            Patient(
                Sex="F",
                CodedEvents=[
                    CodedEvent(CTV3Code="foo3", ConsultationDate="2000-01-01")
                ],
            ),
            Patient(
                Sex="F",
                CodedEvents=[
                    CodedEvent(CTV3Code="bar1", ConsultationDate="2000-01-01"),
                ],
            ),
        ]
    )
    session.commit()
    foo_codes = codelist([("foo1", "A"), ("foo2", "B"), ("foo3", "C")], "ctv3")
    bar_codes = codelist(["bar1"], "ctv3")
    study = StudyDefinition(
        population=patients.all(),
        category=patients.categorised_as(
            {
                "W": "(foo_category = 'B' OR NOT foo_category) AND female_with_bar",
                "X": "sex = 'F' AND (foo_category = 'B' OR foo_category = 'C')",
                "Y": "sex = 'M' AND foo_category = 'A'",
                "Z": "DEFAULT",
            },
            sex=patients.sex(),
            foo_category=patients.with_these_clinical_events(
                foo_codes, returning="category", find_last_match_in_period=True
            ),
            female_with_bar=patients.satisfying(
                "has_bar AND sex = 'F'",
                has_bar=patients.with_these_clinical_events(bar_codes),
            ),
        ),
    )
    results = study.to_dicts()
    assert [x["category"] for x in results] == ["Y", "W", "Z", "X", "W"]
    # Assert that internal columns do not appear
    assert "foo_category" not in results[0].keys()
    assert "female_with_bar" not in results[0].keys()
    assert "has_bar" not in results[0].keys()


def test_patients_registered_practice_as_of():
    session = make_session()
    org_1 = Organisation(
        STPCode="123", MSOACode="E0201", Region="East of England", Organisation_ID=1
    )
    org_2 = Organisation(
        STPCode="456", MSOACode="E0202", Region="Midlands", Organisation_ID=2
    )
    org_3 = Organisation(
        STPCode="789", MSOACode="E0203", Region="London", Organisation_ID=3
    )
    org_4 = Organisation(
        STPCode="910", MSOACode="E0204", Region="North West", Organisation_ID=4
    )
    patient = Patient()
    patient.RegistrationHistory.append(
        RegistrationHistory(
            StartDate="1990-01-01", EndDate="2018-01-01", Organisation=org_1
        )
    )
    # We deliberately create overlapping registration periods so we can check
    # that we handle these correctly
    patient.RegistrationHistory.append(
        RegistrationHistory(
            StartDate="2018-01-01", EndDate="2022-01-01", Organisation=org_2
        )
    )
    patient.RegistrationHistory.append(
        RegistrationHistory(
            StartDate="2019-09-01", EndDate="2020-05-01", Organisation=org_3
        )
    )
    patient.RegistrationHistory.append(
        RegistrationHistory(
            StartDate="2022-01-01", EndDate="9999-12-31", Organisation=org_4
        )
    )
    patient_2 = Patient()
    patient_2.RegistrationHistory.append(
        RegistrationHistory(
            StartDate="2010-01-01", EndDate="9999-12-31", Organisation=org_1
        )
    )
    patient_3 = Patient()
    patient_3.RegistrationHistory.append(
        RegistrationHistory(StartDate="2010-01-01", EndDate="9999-12-31")
    )
    session.add_all([patient, patient_2, patient_3])
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        stp=patients.registered_practice_as_of("2020-01-01", returning="stp_code"),
        msoa=patients.registered_practice_as_of("2020-01-01", returning="msoa"),
        deprecated_msoa=patients.registered_practice_as_of(
            "2020-01-01", returning="msoa_code"
        ),
        region=patients.registered_practice_as_of(
            "2020-01-01", returning="nuts1_region_name"
        ),
        pseudo_id=patients.registered_practice_as_of(
            "2020-01-01", returning="pseudo_id"
        ),
    )
    assert_results(
        study.to_dicts(),
        stp=["789", "123", ""],
        msoa=["E0203", "E0201", ""],
        deprecated_msoa=["E0203", "E0201", ""],
        region=["London", "East of England", ""],
        pseudo_id=["3", "1", "0"],
    )


def test_patients_address_as_of():
    session = make_session()
    session.add_all(
        [
            # We deliberately create overlapping address periods here to check
            # that we handle these correctly
            Patient(
                Addresses=[
                    PatientAddress(
                        StartDate="1990-01-01",
                        EndDate="2018-01-01",
                        ImdRankRounded=100,
                        RuralUrbanClassificationCode=1,
                        MSOACode="S02001286",
                    ),
                    PatientAddress(
                        StartDate="2018-01-01",
                        EndDate="2020-02-01",
                        ImdRankRounded=200,
                        RuralUrbanClassificationCode=1,
                        MSOACode="S02001286",
                    ),
                    PatientAddress(
                        StartDate="2019-01-01",
                        EndDate="2022-01-01",
                        ImdRankRounded=300,
                        RuralUrbanClassificationCode=2,
                        MSOACode="E02001286",
                    ),
                    PatientAddress(
                        StartDate="2022-01-01",
                        EndDate="9999-12-31",
                        ImdRankRounded=500,
                        RuralUrbanClassificationCode=3,
                        MSOACode="S02001286",
                    ),
                ],
                CodedEvents=[CodedEvent(CTV3Code="foo", ConsultationDate="2020-01-01")],
            ),
            Patient(
                Addresses=[
                    PatientAddress(
                        StartDate="1900-01-01",
                        EndDate="9999-12-31",
                        ImdRankRounded=-1,
                        RuralUrbanClassificationCode=-1,
                        MSOACode="NPC",
                    ),
                    PatientAddress(
                        StartDate="1900-01-01",
                        EndDate="9999-12-31",
                        ImdRankRounded=600,
                        RuralUrbanClassificationCode=4,
                        MSOACode="S02001286",
                    ),
                ]
            ),
            # Patient with no address
            Patient(),
            # Patient with only old address
            Patient(
                Addresses=[
                    PatientAddress(
                        StartDate="2010-01-01",
                        EndDate="2015-01-01",
                        ImdRankRounded=100,
                        RuralUrbanClassificationCode=1,
                    )
                ]
            ),
        ]
    )
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        imd=patients.address_as_of(
            "2020-01-01",
            returning="index_of_multiple_deprivation",
            round_to_nearest=100,
        ),
        rural_urban=patients.address_as_of(
            "2020-01-01", returning="rural_urban_classification"
        ),
        msoa=patients.address_as_of("2020-01-01", returning="msoa"),
        foo_date=patients.with_these_clinical_events(
            codelist(["foo"], "ctv3"),
            returning="date",
            date_format="YYYY-MM-DD",
        ),
        msoa_on_foo_date=patients.address_as_of("foo_date", returning="msoa"),
    )
    assert_results(
        study.to_dicts(),
        imd=["300", "600", "0", "0"],
        rural_urban=["2", "4", "0", "0"],
        msoa=["E02001286", "S02001286", "", ""],
        foo_date=["2020-01-01", "", "", ""],
        msoa_on_foo_date=["E02001286", "", "", ""],
    )


def test_patients_care_home_status_as_of():
    session = make_session()
    session.add_all(
        [
            # Was in care home but no longer
            Patient(
                Addresses=[
                    PatientAddress(
                        StartDate="2010-01-01",
                        EndDate="2015-01-01",
                        PotentialCareHomeAddress=[PotentialCareHomeAddress()],
                    ),
                    PatientAddress(StartDate="2015-01-01", EndDate="9999-01-01"),
                ]
            ),
            # Currently in non-nursing care home
            Patient(
                Addresses=[
                    PatientAddress(
                        StartDate="2015-01-01",
                        EndDate="9999-01-01",
                        PotentialCareHomeAddress=[
                            PotentialCareHomeAddress(
                                LocationRequiresNursing="N",
                                LocationDoesNotRequireNursing="Y",
                            )
                        ],
                    ),
                ]
            ),
            # Currently in nursing home
            Patient(
                Addresses=[
                    PatientAddress(
                        StartDate="2015-01-01",
                        EndDate="9999-01-01",
                        PotentialCareHomeAddress=[
                            PotentialCareHomeAddress(
                                LocationRequiresNursing="Y",
                                LocationDoesNotRequireNursing="N",
                            )
                        ],
                    ),
                ]
            ),
            # Currently in a schrodin-home which both does and does not require nursing
            Patient(
                Addresses=[
                    PatientAddress(
                        StartDate="2015-01-01",
                        EndDate="9999-01-01",
                        PotentialCareHomeAddress=[
                            PotentialCareHomeAddress(
                                LocationRequiresNursing="Y",
                                LocationDoesNotRequireNursing="Y",
                            )
                        ],
                    ),
                ]
            ),
        ]
    )
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        is_in_care_home=patients.care_home_status_as_of("2020-01-01"),
        care_home_type=patients.care_home_status_as_of(
            "2020-01-01",
            categorised_as={
                "PC": """
                  IsPotentialCareHome
                  AND LocationDoesNotRequireNursing='Y'
                  AND LocationRequiresNursing='N'
                """,
                "PN": """
                  IsPotentialCareHome
                  AND LocationDoesNotRequireNursing='N'
                  AND LocationRequiresNursing='Y'
                """,
                "PS": "IsPotentialCareHome",
                "U": "DEFAULT",
            },
        ),
    )
    results = study.to_dicts()
    assert [i["is_in_care_home"] for i in results] == ["0", "1", "1", "1"]
    assert [i["care_home_type"] for i in results] == ["U", "PC", "PN", "PS"]


def test_patients_admitted_to_icu():
    session = make_session()
    session.add_all(
        [
            Patient(
                ICNARC=[
                    ICNARC(
                        IcuAdmissionDateTime="2020-03-01",
                        OriginalIcuAdmissionDate="2020-03-01",
                        BasicDays_RespiratorySupport=2,
                        AdvancedDays_RespiratorySupport=2,
                    )
                ]
            ),
            Patient(
                ICNARC=[
                    ICNARC(
                        IcuAdmissionDateTime="2020-03-01",
                        OriginalIcuAdmissionDate="2020-02-01",
                        BasicDays_RespiratorySupport=1,
                        AdvancedDays_RespiratorySupport=0,
                    )
                ]
            ),
            Patient(),
            Patient(
                ICNARC=[
                    ICNARC(
                        IcuAdmissionDateTime="2020-01-01",
                        OriginalIcuAdmissionDate="2020-01-01",
                        BasicDays_RespiratorySupport=1,
                        AdvancedDays_RespiratorySupport=0,
                    )
                ]
            ),
            Patient(
                ICNARC=[
                    ICNARC(
                        IcuAdmissionDateTime="2020-03-01",
                        OriginalIcuAdmissionDate=None,
                        BasicDays_RespiratorySupport=0,
                        AdvancedDays_RespiratorySupport=1,
                    ),
                    ICNARC(
                        IcuAdmissionDateTime="2020-04-01",
                        OriginalIcuAdmissionDate=None,
                        BasicDays_RespiratorySupport=0,
                        AdvancedDays_RespiratorySupport=0,
                    ),
                ]
            ),
        ]
    )
    session.commit()

    study = StudyDefinition(
        population=patients.all(),
        icu_first=patients.admitted_to_icu(
            on_or_after="2020-02-01",
            returning="date_admitted",
            date_format="YYYY-MM-DD",
            find_first_match_in_period=True,
        ),
        icu_last=patients.admitted_to_icu(
            on_or_after="2020-02-01",
            returning="date_admitted",
            date_format="YYYY-MM-DD",
            find_last_match_in_period=True,
        ),
        icu_flag=patients.admitted_to_icu(
            on_or_after="2020-02-01", returning="binary_flag"
        ),
        resp_support=patients.admitted_to_icu(
            on_or_after="2020-02-01",
            returning="had_respiratory_support",
        ),
        basic_support=patients.admitted_to_icu(
            on_or_after="2020-02-01",
            returning="had_basic_respiratory_support",
        ),
        advanced_support=patients.admitted_to_icu(
            on_or_after="2020-02-01",
            returning="had_advanced_respiratory_support",
        ),
        icu_second=patients.admitted_to_icu(
            on_or_after="icu_first + 1 day",
            returning="date_admitted",
            date_format="YYYY-MM-DD",
            find_first_match_in_period=True,
        ),
    )

    assert_results(
        study.to_dicts(),
        icu_first=[
            "2020-03-01",
            "2020-02-01",
            "",
            "",
            "2020-03-01",
        ],
        icu_last=[
            "2020-03-01",
            "2020-02-01",
            "",
            "",
            "2020-04-01",
        ],
        icu_flag=["1", "1", "0", "0", "1"],
        resp_support=["1", "1", "0", "0", "1"],
        basic_support=["1", "1", "0", "0", "0"],
        advanced_support=["1", "0", "0", "0", "1"],
        icu_second=[
            "",
            "",
            "",
            "",
            "2020-04-01",
        ],
    )


def test_patients_with_these_codes_on_death_certificate():
    code = "COVID"
    session = make_session()
    patient_with_dupe = Patient()
    session.add_all(
        [
            # Not dead
            Patient(),
            # Died after date cutoff
            ONSDeaths(Patient=Patient(), dod="2021-01-01", icd10u=code),
            # Died of something else
            ONSDeaths(Patient=Patient(), dod="2020-02-01", icd10u="MI"),
            # Covid underlying cause
            ONSDeaths(
                Patient=patient_with_dupe, dod="2020-02-01", icd10u=code, ICD10014="MI"
            ),
            # A duplicate (the raw data does contain exact dupes, unfortunately)
            ONSDeaths(
                Patient=patient_with_dupe, dod="2020-02-01", icd10u=code, ICD10014="MI"
            ),
            # A duplicate with a different date of death (which now we have to handle)
            ONSDeaths(
                Patient=patient_with_dupe, dod="2020-02-02", icd10u=code, ICD10014="MI"
            ),
            # A duplicate with a different date of death (which now we have to handle)
            ONSDeaths(
                Patient=patient_with_dupe, dod="2020-02-02", icd10u=code, ICD10014="MI"
            ),
            # A duplicate with a different underlying CoD (which now we have to handle)
            ONSDeaths(
                Patient=patient_with_dupe,
                dod="2020-02-02",
                icd10u="MI",
                ICD10014="COVID",
            ),
            # Covid not underlying cause
            ONSDeaths(Patient=Patient(), dod="2020-03-01", icd10u="MI", ICD10014=code),
        ]
    )
    session.commit()
    covid_codelist = codelist([code], system="icd10")
    study = StudyDefinition(
        population=patients.all(),
        died_of_covid=patients.with_these_codes_on_death_certificate(
            covid_codelist, on_or_before="2020-06-01", match_only_underlying_cause=True
        ),
        died_with_covid=patients.with_these_codes_on_death_certificate(
            covid_codelist, on_or_before="2020-06-01", match_only_underlying_cause=False
        ),
        date_died=patients.with_these_codes_on_death_certificate(
            covid_codelist,
            on_or_before="2020-06-01",
            match_only_underlying_cause=False,
            returning="date_of_death",
            date_format="YYYY-MM-DD",
        ),
        underlying_cause=patients.with_these_codes_on_death_certificate(
            covid_codelist,
            on_or_before="2020-06-01",
            match_only_underlying_cause=False,
            returning="underlying_cause_of_death",
        ),
    )
    results = study.to_dicts()
    assert [i["died_of_covid"] for i in results] == ["0", "0", "0", "1", "0"]
    assert [i["died_with_covid"] for i in results] == ["0", "0", "0", "1", "1"]
    assert [i["date_died"] for i in results] == ["", "", "", "2020-02-01", "2020-03-01"]
    assert [i["underlying_cause"] for i in results] == ["", "", "", code, "MI"]


def test_patients_died_from_any_cause():
    session = make_session()
    session.add_all(
        [
            # Not dead
            Patient(),
            # Died after date cutoff
            Patient(ONSDeath=[ONSDeaths(dod="2021-01-01")]),
            # Died
            Patient(ONSDeath=[ONSDeaths(dod="2020-02-01", icd10u="A")]),
        ]
    )
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        died=patients.died_from_any_cause(on_or_before="2020-06-01"),
        date_died=patients.died_from_any_cause(
            on_or_before="2020-06-01",
            returning="date_of_death",
            date_format="YYYY-MM-DD",
        ),
        underlying_cause=patients.died_from_any_cause(
            on_or_before="2020-06-01",
            returning="underlying_cause_of_death",
        ),
    )
    results = study.to_dicts()
    assert [i["died"] for i in results] == ["0", "0", "1"]
    assert [i["date_died"] for i in results] == ["", "", "2020-02-01"]
    assert [i["underlying_cause"] for i in results] == ["", "", "A"]


def test_patients_with_death_recorded_in_cpns():
    session = make_session()
    session.add_all(
        [
            # Not dead
            Patient(),
            # Died after date cutoff
            Patient(CPNS=[CPNS(DateOfDeath="2021-01-01")]),
            # Patient should be included
            Patient(CPNS=[CPNS(DateOfDeath="2020-02-01")]),
            # Patient has multple entries but with the same date of death so
            # should be handled correctly
            Patient(
                CPNS=[CPNS(DateOfDeath="2020-03-01"), CPNS(DateOfDeath="2020-03-01")]
            ),
        ]
    )
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        cpns_death=patients.with_death_recorded_in_cpns(on_or_before="2020-06-01"),
        cpns_death_date=patients.with_death_recorded_in_cpns(
            on_or_before="2020-06-01",
            returning="date_of_death",
            date_format="YYYY-MM-DD",
        ),
    )
    results = study.to_dicts()
    assert [i["cpns_death"] for i in results] == ["0", "0", "1", "1"]
    assert [i["cpns_death_date"] for i in results] == [
        "",
        "",
        "2020-02-01",
        "2020-03-01",
    ]


def test_patients_with_death_recorded_in_cpns_raises_error_on_bad_data():
    session = make_session()
    session.add_all(
        # Create a patient with duplicate CPNS entries recording an
        # inconsistent date of death
        [Patient(CPNS=[CPNS(DateOfDeath="2020-03-01"), CPNS(DateOfDeath="2020-02-01")])]
    )
    session.commit()
    study = StudyDefinition(
        population=patients.all(), cpns_death=patients.with_death_recorded_in_cpns()
    )
    with pytest.raises(Exception):
        study.to_dicts()


def test_to_sql_passes():
    session = make_session()
    patient = Patient(DateOfBirth="1950-01-01")
    patient.CodedEvents.append(
        CodedEvent(CTV3Code="XYZ", NumericValue=50, ConsultationDate="2002-06-01")
    )
    session.add(patient)
    session.commit()

    study = StudyDefinition(
        population=patients.with_these_clinical_events(codelist(["XYZ"], "ctv3"))
    )
    sql = "SET NOCOUNT ON; "  # don't output count after table output
    sql += study.to_sql()
    db_dict = mssql_connection_params_from_url(study.backend.database_url)
    cmd = [
        "sqlcmd",
        "-S",
        db_dict["host"] + "," + str(db_dict["port"]),
        "-d",
        db_dict["database"],
        "-U",
        db_dict["username"],
        "-P",
        db_dict["password"],
        "-Q",
        sql,
        "-W",  # strip whitespace
    ]
    result = subprocess.run(
        cmd, capture_output=True, check=True, encoding="utf8"
    ).stdout
    patient_id = result.splitlines()[-1]
    assert patient_id == str(patient.Patient_ID)


def test_duplicate_id_checking(tmp_path):
    study = StudyDefinition(population=patients.all())
    # A bit of a hack: overwrite the queries we're going to run with a query which
    # deliberately returns duplicate values
    study.backend.queries = [
        """
        SELECT * FROM (
          VALUES
            (1,1),
            (2,2),
            (3,3),
            (1,4)
        ) t (patient_id, foo)
        """,
    ]
    with pytest.raises(RuntimeError):
        study.to_dicts()
    with pytest.raises(RuntimeError):
        study.to_file(tmp_path / "test.csv")
    # Check that we still produce an output file with the duplicates in
    with open(tmp_path / "test.csv") as f:
        output = list(csv.DictReader(f))
    expected = [
        {"patient_id": "1", "foo": "1"},
        {"patient_id": "1", "foo": "4"},
        {"patient_id": "2", "foo": "2"},
        {"patient_id": "3", "foo": "3"},
    ]
    assert output == expected


def test_using_expression_in_population_definition():
    session = make_session()
    session.add_all(
        [
            Patient(
                Sex="M",
                DateOfBirth="1970-01-01",
                CodedEvents=[
                    CodedEvent(CTV3Code="foo1", ConsultationDate="2000-01-01")
                ],
            ),
            Patient(Sex="M", DateOfBirth="1975-01-01"),
            Patient(
                Sex="F",
                DateOfBirth="1980-01-01",
                CodedEvents=[
                    CodedEvent(CTV3Code="foo1", ConsultationDate="2000-01-01")
                ],
            ),
            Patient(Sex="F", DateOfBirth="1985-01-01"),
        ]
    )
    session.commit()
    study = StudyDefinition(
        population=patients.satisfying(
            "has_foo_code AND sex = 'M'",
            has_foo_code=patients.with_these_clinical_events(
                codelist(["foo1"], "ctv3")
            ),
            sex=patients.sex(),
        ),
        age=patients.age_as_of("2020-01-01"),
    )
    results = study.to_dicts()
    assert results[0].keys() == {"patient_id", "age"}
    assert [i["age"] for i in results] == ["50"]


def test_quote():
    assert quote("2012-02-01") == "'20120201'"
    assert quote("2012") == "'2012'"
    assert quote(2012) == "2012"
    assert quote(0.1) == "0.1"
    assert quote("foo") == "'foo'"
    assert quote("what's up?") == "'what''s up?'"


def test_quote_against_db():
    session = make_session()
    values = [1, 1.5, "hello", "", "what's up?", "new\nlines", "ixekizumabß"]
    for value in values:
        result = session.execute(f"SELECT {quote(value)}")
        assert list(result)[0][0] == value


def test_escape_like_query_fragment():
    assert escape_like_query_fragment("foo") == "foo"
    assert escape_like_query_fragment("foo%bar_") == "foo\\%bar\\_"


def test_escape_like_query_fragment_against_db():
    session = make_session()
    cases = [
        ("foobar", "ob", True),
        ("foo[]\\%_^bar", "o[]\\%_^b", True),
        ("foobar", "f%r", False),
    ]
    for text, pattern, should_match in cases:
        like_pattern = f"%{escape_like_query_fragment(pattern)}%"
        result = session.execute(
            f"SELECT value FROM"
            f"  (VALUES({quote(text)})) AS t(value)"
            f"  WHERE value LIKE {quote(like_pattern)} ESCAPE '\\'"
        )
        # print(f"'{text}' should{'' if should_match else ' not'} match '{pattern}'")
        if should_match:
            assert list(result)[0][0] == text
        else:
            assert len(list(result)) == 0


def test_number_of_episodes():
    session = make_session()
    session.add_all(
        [
            Patient(
                CodedEvents=[
                    CodedEvent(CTV3Code="foo1", ConsultationDate="2010-01-01"),
                    # Throw in some irrelevant events
                    CodedEvent(CTV3Code="mto1", ConsultationDate="2010-01-02"),
                    CodedEvent(CTV3Code="mto2", ConsultationDate="2010-01-03"),
                    # These two should be merged in to the previous event
                    # because there's not more than 14 days between them
                    CodedEvent(CTV3Code="foo2", ConsultationDate="2010-01-14"),
                    CodedEvent(CTV3Code="foo3", ConsultationDate="2010-01-20"),
                    # This is just outside the limit so should count as another event
                    CodedEvent(CTV3Code="foo1", ConsultationDate="2010-02-04"),
                    # This shouldn't count because there's an "ignore" event on
                    # the same day (though at a different time)
                    CodedEvent(CTV3Code="foo1", ConsultationDate="2012-01-01T10:45:00"),
                    CodedEvent(CTV3Code="bar2", ConsultationDate="2012-01-01T16:10:00"),
                    # This should be another episode
                    CodedEvent(CTV3Code="foo1", ConsultationDate="2015-03-05"),
                    # This "ignore" event should have no effect because it occurs
                    # on a different day
                    CodedEvent(CTV3Code="bar1", ConsultationDate="2015-03-06"),
                    # This is after the time limit and so shouldn't count
                    CodedEvent(CTV3Code="foo1", ConsultationDate="2020-02-05"),
                ]
            ),
            # This patient doesn't have any relevant events
            Patient(
                CodedEvents=[
                    CodedEvent(CTV3Code="mto1", ConsultationDate="2010-01-01"),
                    CodedEvent(CTV3Code="mto2", ConsultationDate="2010-01-14"),
                    CodedEvent(CTV3Code="mto3", ConsultationDate="2010-01-20"),
                    CodedEvent(CTV3Code="mto1", ConsultationDate="2010-02-04"),
                    CodedEvent(CTV3Code="mto1", ConsultationDate="2012-01-01T10:45:00"),
                    CodedEvent(CTV3Code="mtr2", ConsultationDate="2012-01-01T16:10:00"),
                    CodedEvent(CTV3Code="mto1", ConsultationDate="2015-03-05"),
                    CodedEvent(CTV3Code="mto1", ConsultationDate="2020-02-05"),
                ]
            ),
        ]
    )
    session.commit()
    foo_codes = codelist(["foo1", "foo2", "foo3"], "ctv3")
    bar_codes = codelist(["bar1", "bar2"], "ctv3")
    study = StudyDefinition(
        population=patients.all(),
        episode_count=patients.with_these_clinical_events(
            foo_codes,
            on_or_before="2020-01-01",
            ignore_days_where_these_codes_occur=bar_codes,
            returning="number_of_episodes",
            episode_defined_as="series of events each <= 14 days apart",
        ),
        event_count=patients.with_these_clinical_events(
            foo_codes,
            on_or_before="2020-01-01",
            ignore_days_where_these_codes_occur=bar_codes,
            returning="number_of_matches_in_period",
        ),
    )
    results = study.to_dicts()
    assert [i["episode_count"] for i in results] == ["3", "0"]
    assert [i["event_count"] for i in results] == ["5", "0"]


def test_number_of_episodes_for_medications():
    oral_steriod = MedicationDictionary(
        FullName="Oral Steroid", DMD_ID="ab12", MultilexDrug_ID="1"
    )
    other_drug = MedicationDictionary(
        FullName="Other Drug", DMD_ID="cd34", MultilexDrug_ID="2"
    )
    session = make_session()
    session.add_all(
        [
            Patient(
                MedicationIssues=[
                    MedicationIssue(
                        MedicationDictionary=oral_steriod, ConsultationDate="2010-01-01"
                    ),
                    # Throw in some irrelevant prescriptions
                    MedicationIssue(
                        MedicationDictionary=other_drug, ConsultationDate="2010-01-02"
                    ),
                    MedicationIssue(
                        MedicationDictionary=other_drug, ConsultationDate="2010-01-03"
                    ),
                    # These two should be merged in to the previous event
                    # because there's not more than 14 days between them
                    MedicationIssue(
                        MedicationDictionary=oral_steriod, ConsultationDate="2010-01-14"
                    ),
                    MedicationIssue(
                        MedicationDictionary=oral_steriod, ConsultationDate="2010-01-20"
                    ),
                    # This is just outside the limit so should count as another event
                    MedicationIssue(
                        MedicationDictionary=oral_steriod, ConsultationDate="2010-02-04"
                    ),
                    # This shouldn't count because there's an "ignore" event on
                    # the same day (though at a different time)
                    MedicationIssue(
                        MedicationDictionary=oral_steriod,
                        ConsultationDate="2012-01-01T10:45:00",
                    ),
                    # This should be another episode
                    MedicationIssue(
                        MedicationDictionary=oral_steriod, ConsultationDate="2015-03-05"
                    ),
                    # This is after the time limit and so shouldn't count
                    MedicationIssue(
                        MedicationDictionary=oral_steriod, ConsultationDate="2020-02-05"
                    ),
                ],
                CodedEvents=[
                    # This "ignore" event should cause us to skip one of the
                    # meds issues above
                    CodedEvent(CTV3Code="bar2", ConsultationDate="2012-01-01T16:10:00"),
                    # This "ignore" event should have no effect because it
                    # doesn't occur on the same day as any meds issue
                    CodedEvent(CTV3Code="bar1", ConsultationDate="2015-03-06"),
                ],
            ),
            # This patient doesn't have any relevant events or prescriptions
            Patient(
                MedicationIssues=[
                    MedicationIssue(
                        MedicationDictionary=other_drug, ConsultationDate="2010-01-02"
                    ),
                    MedicationIssue(
                        MedicationDictionary=other_drug, ConsultationDate="2010-01-03"
                    ),
                ],
                CodedEvents=[
                    CodedEvent(CTV3Code="mto1", ConsultationDate="2010-02-04"),
                    CodedEvent(CTV3Code="mto1", ConsultationDate="2012-01-01T10:45:00"),
                    CodedEvent(CTV3Code="mtr2", ConsultationDate="2012-01-01T16:10:00"),
                    CodedEvent(CTV3Code="mto1", ConsultationDate="2015-03-05"),
                ],
            ),
        ]
    )
    session.commit()
    foo_codes = codelist(["ab12"], "snomed")
    bar_codes = codelist(["bar1", "bar2"], "ctv3")
    study = StudyDefinition(
        population=patients.all(),
        episode_count=patients.with_these_medications(
            foo_codes,
            on_or_before="2020-01-01",
            ignore_days_where_these_clinical_codes_occur=bar_codes,
            returning="number_of_episodes",
            episode_defined_as="series of events each <= 14 days apart",
        ),
        event_count=patients.with_these_medications(
            foo_codes,
            on_or_before="2020-01-01",
            ignore_days_where_these_clinical_codes_occur=bar_codes,
            returning="number_of_matches_in_period",
        ),
    )
    results = study.to_dicts()
    assert [i["episode_count"] for i in results] == ["3", "0"]
    assert [i["event_count"] for i in results] == ["5", "0"]


def test_medications_returning_code_with_ignored_days():
    oral_steriod = MedicationDictionary(
        FullName="Oral Steroid", DMD_ID="ab12", MultilexDrug_ID="1"
    )
    other_drug = MedicationDictionary(
        FullName="Other Drug", DMD_ID="cd34", MultilexDrug_ID="2"
    )
    session = make_session()
    session.add_all(
        [
            Patient(
                MedicationIssues=[
                    MedicationIssue(
                        MedicationDictionary=other_drug, ConsultationDate="2010-01-03"
                    ),
                    # This shouldn't count because there's an "ignore" event on
                    # the same day (though at a different time)
                    MedicationIssue(
                        MedicationDictionary=oral_steriod,
                        ConsultationDate="2012-01-01T10:45:00",
                    ),
                ],
                CodedEvents=[
                    # This "ignore" event should cause us to skip one of the
                    # meds issues above
                    CodedEvent(CTV3Code="bar1", ConsultationDate="2012-01-01T16:10:00"),
                ],
            ),
        ]
    )
    session.commit()
    drug_codes = codelist(["ab12", "cd34"], "snomed")
    annual_review_codes = codelist(["bar1"], "ctv3")
    study = StudyDefinition(
        population=patients.all(),
        most_recent_drug=patients.with_these_medications(
            drug_codes,
            ignore_days_where_these_clinical_codes_occur=annual_review_codes,
            returning="code",
        ),
        most_recent_drug_date=patients.date_of(
            "most_recent_drug", date_format="YYYY-MM-DD"
        ),
    )
    results = study.to_dicts()
    assert [i["most_recent_drug"] for i in results] == ["cd34"]
    assert [i["most_recent_drug_date"] for i in results] == ["2010-01-03"]


def test_patients_with_vaccination_record():
    session = make_session()
    vaccines = [
        (1, "Hepatyrix", ["TYPHOID", "HEPATITIS A"]),
        (2, "Madeva", ["INFLUENZA"]),
        (3, "Optaflu", ["INFLUENZA"]),
    ]
    ids = {}
    for name_id, name, contents in vaccines:
        ids[name] = name_id
        for content in contents:
            session.add(
                VaccinationReference(
                    VaccinationName=name,
                    VaccinationName_ID=name_id,
                    VaccinationContent=content,
                )
            )
    session.add_all(
        [
            Patient(
                Vaccinations=[
                    Vaccination(
                        VaccinationName_ID=ids["Hepatyrix"],
                        VaccinationDate="2010-01-01",
                    ),
                    Vaccination(
                        VaccinationName_ID=ids["Optaflu"], VaccinationDate="2014-01-01"
                    ),
                ]
            ),
            Patient(
                Vaccinations=[
                    Vaccination(
                        VaccinationName_ID=ids["Madeva"], VaccinationDate="2013-01-01"
                    ),
                    Vaccination(
                        VaccinationName_ID=ids["Hepatyrix"],
                        VaccinationDate="2015-01-01",
                    ),
                ]
            ),
        ]
    )
    session.commit()

    # This is the same as the first study definition in
    # test_patients_with_tpp_vaccination_record
    study = StudyDefinition(
        population=patients.all(),
        value=patients.with_vaccination_record(
            tpp={
                "target_disease_matches": "TYPHOID",
            },
            emis={},
            on_or_after="2012-01-01",
        ),
        date=patients.date_of("value"),
    )
    results = study.to_dicts()
    assert [i["value"] for i in results] == ["0", "1"]
    assert [i["date"] for i in results] == ["", "2015"]


def test_patients_with_tpp_vaccination_record():
    session = make_session()
    vaccines = [
        (1, "Hepatyrix", ["TYPHOID", "HEPATITIS A"]),
        (2, "Madeva", ["INFLUENZA"]),
        (3, "Optaflu", ["INFLUENZA"]),
    ]
    ids = {}
    for name_id, name, contents in vaccines:
        ids[name] = name_id
        for content in contents:
            session.add(
                VaccinationReference(
                    VaccinationName=name,
                    VaccinationName_ID=name_id,
                    VaccinationContent=content,
                )
            )
    session.add_all(
        [
            Patient(
                Vaccinations=[
                    Vaccination(
                        VaccinationName_ID=ids["Hepatyrix"],
                        VaccinationDate="2010-01-01",
                    ),
                    Vaccination(
                        VaccinationName_ID=ids["Optaflu"], VaccinationDate="2014-01-01"
                    ),
                ]
            ),
            Patient(
                Vaccinations=[
                    Vaccination(
                        VaccinationName_ID=ids["Madeva"], VaccinationDate="2013-01-01"
                    ),
                    Vaccination(
                        VaccinationName_ID=ids["Hepatyrix"],
                        VaccinationDate="2015-01-01",
                    ),
                ]
            ),
        ]
    )
    session.commit()

    study = StudyDefinition(
        population=patients.all(),
        value=patients.with_tpp_vaccination_record(
            target_disease_matches="TYPHOID",
            on_or_after="2012-01-01",
        ),
        date=patients.date_of("value"),
    )
    results = study.to_dicts()
    assert [i["value"] for i in results] == ["0", "1"]
    assert [i["date"] for i in results] == ["", "2015"]

    study = StudyDefinition(
        population=patients.all(),
        value=patients.with_tpp_vaccination_record(
            target_disease_matches="INFLUENZA",
            on_or_after="2012-01-01",
            find_last_match_in_period=True,
            returning="date",
        ),
    )
    assert [i["value"] for i in study.to_dicts()] == ["2014", "2013"]

    study = StudyDefinition(
        population=patients.all(),
        value=patients.with_tpp_vaccination_record(
            product_name_matches=["Madeva", "Hepatyrix"],
            find_first_match_in_period=True,
            returning="date",
        ),
    )
    assert [i["value"] for i in study.to_dicts()] == ["2010", "2013"]


def test_patients_with_gp_consultations():
    session = make_session()
    session.add_all(
        [
            Patient(
                RegistrationHistory=[
                    RegistrationHistory(
                        StartDate="2014-01-01",
                        EndDate="2020-05-01",
                        Organisation=Organisation(GoLiveDate="2001-01-01"),
                    )
                ],
                Appointments=[
                    # Before period starts
                    Appointment(
                        SeenDate="2009-01-01", Status=AppointmentStatus.FINISHED
                    ),
                    # After period ends
                    Appointment(
                        SeenDate="2020-02-01", Status=AppointmentStatus.FINISHED
                    ),
                ],
            ),
            Patient(
                RegistrationHistory=[
                    RegistrationHistory(
                        StartDate="2001-01-01",
                        EndDate="2016-01-01",
                        Organisation=Organisation(GoLiveDate="1999-10-01"),
                    )
                ],
                Appointments=[
                    Appointment(
                        SeenDate="2011-01-01", Status=AppointmentStatus.FINISHED
                    ),
                    # Should not be counted
                    Appointment(
                        SeenDate="2012-01-01", Status=AppointmentStatus.DID_NOT_ATTEND
                    ),
                    Appointment(
                        SeenDate="2013-01-01", Status=AppointmentStatus.FINISHED
                    ),
                ],
            ),
            # This patient was registered with one practice throughout the
            # required period, but that practice wasn't using SystmOne so we
            # don't have full consultation history
            Patient(
                RegistrationHistory=[
                    RegistrationHistory(
                        StartDate="2008-01-01",
                        EndDate="2016-01-01",
                        Organisation=Organisation(GoLiveDate="2012-01-01"),
                    )
                ],
            ),
        ]
    )
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        consultation_count=patients.with_gp_consultations(
            between=["2010-01-01", "2015-01-01"],
            find_last_match_in_period=True,
            returning="number_of_matches_in_period",
        ),
        latest_consultation_date=patients.date_of(
            "consultation_count", date_format="YYYY-MM"
        ),
        has_history=patients.with_complete_gp_consultation_history_between(
            "2010-01-01", "2015-01-01"
        ),
    )
    results = study.to_dicts()
    assert [x["latest_consultation_date"] for x in results] == ["", "2013-01", ""]
    assert [x["consultation_count"] for x in results] == ["0", "2", "0"]
    assert [x["has_history"] for x in results] == ["0", "1", "0"]


def test_patients_with_test_result_in_sgss():
    session = make_session()
    session.add_all(
        [
            Patient(
                SGSS_Positives=[
                    SGSS_Positive(
                        Earliest_Specimen_Date="2020-05-15",
                        SGTF="9",
                        CaseCategory="PCR_Only",
                    ),
                    SGSS_Positive(
                        Earliest_Specimen_Date="2020-05-20",
                        SGTF="0",
                        CaseCategory="LFT_Only",
                    ),
                ],
                SGSS_Negatives=[
                    SGSS_Negative(Earliest_Specimen_Date="2020-05-02"),
                    SGSS_Negative(Earliest_Specimen_Date="2020-07-10"),
                ],
                SGSS_AllTests_Positives=[
                    SGSS_AllTests_Positive(
                        Specimen_Date="2020-05-15",
                        Variant="B.1.351",
                        VariantDetectionMethod="Private Lab Sequencing",
                    ),
                    SGSS_AllTests_Positive(Specimen_Date="2020-05-20"),
                ],
                SGSS_AllTests_Negatives=[
                    SGSS_AllTests_Negative(Specimen_Date="2020-05-02"),
                    SGSS_AllTests_Negative(Specimen_Date="2020-07-10"),
                ],
            ),
            Patient(
                SGSS_Negatives=[SGSS_Negative(Earliest_Specimen_Date="2020-04-01")],
                SGSS_Positives=[
                    SGSS_Positive(
                        Earliest_Specimen_Date="2020-04-20",
                        SGTF="1",
                        CaseCategory="LFT_WithPCR",
                    )
                ],
                SGSS_AllTests_Negatives=[
                    SGSS_AllTests_Negative(Specimen_Date="2020-04-01")
                ],
                SGSS_AllTests_Positives=[
                    SGSS_AllTests_Positive(
                        Specimen_Date="2020-04-20",
                        Variant="VOC-20DEC-01 detected",
                        VariantDetectionMethod="Reflex Assay",
                    ),
                    SGSS_AllTests_Positive(Specimen_Date="2020-05-02"),
                ],
            ),
            Patient(
                SGSS_Negatives=[SGSS_Negative(Earliest_Specimen_Date="2020-04-01")],
                SGSS_AllTests_Negatives=[
                    SGSS_AllTests_Negative(Specimen_Date="2020-04-01")
                ],
            ),
            Patient(),
        ]
    )
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        positive_covid_test_ever=patients.with_test_result_in_sgss(
            pathogen="SARS-CoV-2",
            test_result="positive",
        ),
        negative_covid_test_ever=patients.with_test_result_in_sgss(
            pathogen="SARS-CoV-2",
            test_result="negative",
        ),
        tested_before_may=patients.with_test_result_in_sgss(
            pathogen="SARS-CoV-2", test_result="any", on_or_before="2020-05-01"
        ),
        first_positive_test_date=patients.with_test_result_in_sgss(
            pathogen="SARS-CoV-2",
            test_result="positive",
            find_first_match_in_period=True,
            returning="date",
            date_format="YYYY-MM-DD",
        ),
        case_category=patients.with_test_result_in_sgss(
            pathogen="SARS-CoV-2",
            test_result="positive",
            find_first_match_in_period=True,
            returning="case_category",
        ),
        first_negative_after_a_positive=patients.with_test_result_in_sgss(
            pathogen="SARS-CoV-2",
            test_result="negative",
            on_or_after="first_positive_test_date",
            find_first_match_in_period=True,
            returning="date",
            date_format="YYYY-MM-DD",
            restrict_to_earliest_specimen_date=False,
        ),
        last_positive_test_date=patients.with_test_result_in_sgss(
            pathogen="SARS-CoV-2",
            test_result="positive",
            find_last_match_in_period=True,
            restrict_to_earliest_specimen_date=False,
            returning="date",
            date_format="YYYY-MM-DD",
        ),
        sgtf_result=patients.with_test_result_in_sgss(
            pathogen="SARS-CoV-2",
            test_result="positive",
            find_first_match_in_period=True,
            returning="s_gene_target_failure",
        ),
        variant=patients.with_test_result_in_sgss(
            pathogen="SARS-CoV-2",
            test_result="positive",
            find_first_match_in_period=True,
            restrict_to_earliest_specimen_date=False,
            returning="variant",
        ),
        variant_detection_method=patients.with_test_result_in_sgss(
            pathogen="SARS-CoV-2",
            test_result="positive",
            find_first_match_in_period=True,
            restrict_to_earliest_specimen_date=False,
            returning="variant_detection_method",
        ),
    )
    assert_results(
        study.to_dicts(),
        positive_covid_test_ever=["1", "1", "0", "0"],
        negative_covid_test_ever=["1", "1", "1", "0"],
        tested_before_may=["0", "1", "1", "0"],
        first_positive_test_date=[
            "2020-05-15",
            "2020-04-20",
            "",
            "",
        ],
        case_category=["PCR_Only", "LFT_WithPCR", "", ""],
        first_negative_after_a_positive=["2020-07-10", "", "", ""],
        last_positive_test_date=["2020-05-20", "2020-05-02", "", ""],
        sgtf_result=["9", "1", "", ""],
        variant=["B.1.351", "VOC-20DEC-01", "", ""],
        variant_detection_method=["Private Lab Sequencing", "Reflex Assay", "", ""],
    )


def test_patients_date_of_birth():
    session = make_session()
    session.add_all(
        [
            Patient(DateOfBirth="1975-06-10"),
            Patient(DateOfBirth="1999-10-15"),
        ]
    )
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        year_of_birth=patients.date_of_birth(),
        month_of_birth=patients.date_of_birth(date_format="YYYY-MM"),
    )
    results = study.to_dicts()
    assert [x["year_of_birth"] for x in results] == ["1975", "1999"]
    assert [x["month_of_birth"] for x in results] == ["1975-06", "1999-10"]
    # Requesting the exact day is not supported for IG reasons
    with pytest.raises(Exception):
        StudyDefinition(
            population=patients.all(),
            day_of_birth=patients.date_of_birth(date_format="YYYY-MM-DD"),
        )


def test_patients_aggregate_value_of():
    session = make_session()
    session.add_all(
        [
            Patient(
                CodedEvents=[
                    CodedEvent(
                        CTV3Code="ABC", NumericValue=7, ConsultationDate="2012-01-01"
                    ),
                    CodedEvent(
                        CTV3Code="XYZ", NumericValue=23, ConsultationDate="2018-01-01"
                    ),
                ]
            ),
            Patient(
                CodedEvents=[
                    CodedEvent(
                        CTV3Code="ABC", NumericValue=18, ConsultationDate="2014-01-01"
                    ),
                    CodedEvent(
                        CTV3Code="XYZ", NumericValue=4, ConsultationDate="2017-01-01"
                    ),
                ]
            ),
            Patient(
                CodedEvents=[
                    CodedEvent(
                        CTV3Code="ABC", NumericValue=10, ConsultationDate="2015-01-01"
                    ),
                ]
            ),
            Patient(
                CodedEvents=[
                    CodedEvent(
                        CTV3Code="XYZ", NumericValue=8, ConsultationDate="2019-01-01"
                    ),
                ]
            ),
            Patient(),
        ]
    )
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        # Values
        abc_value=patients.with_these_clinical_events(
            codelist(["ABC"], system="ctv3"), returning="numeric_value"
        ),
        xyz_value=patients.with_these_clinical_events(
            codelist(["XYZ"], system="ctv3"), returning="numeric_value"
        ),
        # Dates
        abc_date=patients.date_of("abc_value"),
        xyz_date=patients.date_of("xyz_value"),
        # Aggregates
        max_value=patients.maximum_of("abc_value", "xyz_value"),
        min_value=patients.minimum_of("abc_value", "xyz_value"),
        max_date=patients.maximum_of("abc_date", "xyz_date"),
        min_date=patients.minimum_of("abc_date", "xyz_date"),
    )
    results = study.to_dicts()
    assert [x["max_value"] for x in results] == ["23.0", "18.0", "10.0", "8.0", "0.0"]
    assert [x["min_value"] for x in results] == ["7.0", "4.0", "10.0", "8.0", "0.0"]
    assert [x["max_date"] for x in results] == ["2018", "2017", "2015", "2019", ""]
    assert [x["min_date"] for x in results] == ["2012", "2014", "2015", "2019", ""]
    # Test with hidden columns
    study_with_hidden_columns = StudyDefinition(
        population=patients.all(),
        max_value=patients.maximum_of(
            abc_value=patients.with_these_clinical_events(
                codelist(["ABC"], system="ctv3"), returning="numeric_value"
            ),
            xyz_value=patients.with_these_clinical_events(
                codelist(["XYZ"], system="ctv3"), returning="numeric_value"
            ),
        ),
    )
    results = study_with_hidden_columns.to_dicts()
    assert [x["max_value"] for x in results] == ["23.0", "18.0", "10.0", "8.0", "0.0"]
    assert "abc_value" not in results[0].keys()


def test_patients_household_as_of():
    session = make_session()
    session.add_all(
        [
            Patient(),
            Patient(
                HouseholdMemberships=[
                    HouseholdMember(
                        Household=Household(
                            Household_ID=123,
                            HouseholdSize=2,
                            Prison=True,
                            MixedSoftwareHousehold=False,
                            TppPercentage=100,
                            MSOA="S02001286",
                        )
                    )
                ]
            ),
            Patient(
                HouseholdMemberships=[
                    HouseholdMember(
                        Household=Household(
                            Household_ID=456,
                            HouseholdSize=3,
                            Prison=False,
                            TppPercentage=66,
                            MixedSoftwareHousehold=True,
                            MSOA="S02001354",
                        )
                    )
                ]
            ),
            # This shouldn't produce any output because the entry is flagged as
            # No-Fixed-Abode/Unknown
            Patient(
                HouseholdMemberships=[
                    HouseholdMember(
                        Household=Household(
                            Household_ID=789,
                            HouseholdSize=4,
                            NFA_Unknown=True,
                            Prison=False,
                            TppPercentage=100,
                            MixedSoftwareHousehold=False,
                            MSOA="S02001781",
                        )
                    )
                ]
            ),
        ]
    )
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        household_id=patients.household_as_of("2020-02-01", returning="pseudo_id"),
        household_size=patients.household_as_of(
            "2020-02-01", returning="household_size"
        ),
        is_prison=patients.household_as_of("2020-02-01", returning="is_prison"),
        mixed_ehr=patients.household_as_of(
            "2020-02-01", returning="has_members_in_other_ehr_systems"
        ),
        percent_tpp=patients.household_as_of(
            "2020-02-01", returning="percentage_of_members_with_data_in_this_backend"
        ),
        msoa=patients.household_as_of("2020-02-01", returning="msoa"),
    )
    assert_results(
        study.to_dicts(),
        household_id=["0", "123", "456", "0"],
        household_size=["0", "2", "3", "0"],
        is_prison=["0", "1", "0", "0"],
        mixed_ehr=["0", "0", "1", "0"],
        percent_tpp=["0", "100", "66", "0"],
        msoa=["", "S02001286", "S02001354", ""],
    )
    # We currently only accept one specific date
    with pytest.raises(ValueError):
        StudyDefinition(
            population=patients.all(),
            size=patients.household_as_of("2020-05-01", returning="household_size"),
        )


def test_patients_attended_emergency_care():
    discharge_to_ward = "306706006"
    discharge_to_home = "306689006"
    covid_19 = "1240751000000100"
    not_covid_19 = "125605004"

    session = make_session()
    session.add_all(
        [
            # Patient with no episodes
            Patient(Patient_ID=1),
            # Patient with no episodes in period
            Patient(
                Patient_ID=2,
                ECEpisodes=[
                    EC(
                        EC_Ident=1,
                        Arrival_Date="2020-01-01",
                        Discharge_Destination_SNOMED_CT=discharge_to_home,
                        Diagnoses=[
                            EC_Diagnosis(Patient_ID=3, EC_Diagnosis_01=covid_19)
                        ],
                    )
                ],
            ),
            # Patient with some episodes in period
            Patient(
                Patient_ID=3,
                ECEpisodes=[
                    EC(
                        EC_Ident=2,
                        Arrival_Date="2020-01-01",
                        Discharge_Destination_SNOMED_CT=discharge_to_home,
                        Diagnoses=[
                            EC_Diagnosis(Patient_ID=3, EC_Diagnosis_01=not_covid_19)
                        ],
                    ),
                    EC(
                        EC_Ident=3,
                        Arrival_Date="2020-03-01",
                        Discharge_Destination_SNOMED_CT=discharge_to_home,
                        Diagnoses=[
                            EC_Diagnosis(Patient_ID=3, EC_Diagnosis_01=not_covid_19)
                        ],
                    ),
                ],
            ),
            # Patient with multiple episodes in period
            Patient(
                Patient_ID=4,
                ECEpisodes=[
                    EC(
                        EC_Ident=4,
                        Arrival_Date="2020-03-01",
                        Discharge_Destination_SNOMED_CT=discharge_to_home,
                        Diagnoses=[
                            EC_Diagnosis(Patient_ID=3, EC_Diagnosis_01=not_covid_19)
                        ],
                    ),
                    EC(
                        EC_Ident=5,
                        Arrival_Date="2020-05-01",
                        Discharge_Destination_SNOMED_CT=discharge_to_ward,
                        Diagnoses=[
                            EC_Diagnosis(
                                Patient_ID=3,
                                EC_Diagnosis_01=covid_19,
                                EC_Diagnosis_02=not_covid_19,
                            )
                        ],
                    ),
                    EC(
                        EC_Ident=6,
                        Arrival_Date="2020-07-01",
                        Discharge_Destination_SNOMED_CT=discharge_to_ward,
                        Diagnoses=[
                            EC_Diagnosis(
                                Patient_ID=3,
                                EC_Diagnosis_01=not_covid_19,
                                EC_Diagnosis_02=covid_19,
                            )
                        ],
                    ),
                ],
            ),
        ]
    )
    session.commit()

    study = StudyDefinition(
        population=patients.all(),
        attended=patients.attended_emergency_care(
            on_or_after="2020-02-01", returning="binary_flag"
        ),
        count=patients.attended_emergency_care(
            on_or_after="2020-02-01",
            returning="number_of_matches_in_period",
        ),
        first_date=patients.attended_emergency_care(
            on_or_after="2020-02-01",
            returning="date_arrived",
            find_first_match_in_period=True,
            date_format="YYYY-MM-DD",
        ),
        last_date=patients.attended_emergency_care(
            on_or_after="2020-02-01",
            returning="date_arrived",
            find_last_match_in_period=True,
            date_format="YYYY-MM-DD",
        ),
        first_destination=patients.attended_emergency_care(
            on_or_after="2020-02-01",
            returning="discharge_destination",
            find_first_match_in_period=True,
        ),
        last_destination=patients.attended_emergency_care(
            on_or_after="2020-02-01",
            returning="discharge_destination",
            find_last_match_in_period=True,
        ),
        with_covid=patients.attended_emergency_care(
            on_or_after="2020-02-01",
            returning="binary_flag",
            with_these_diagnoses=codelist([covid_19], "snomed"),
        ),
        first_date_with_covid=patients.attended_emergency_care(
            on_or_after="2020-02-01",
            returning="date_arrived",
            date_format="YYYY-MM-DD",
            find_first_match_in_period=True,
            with_these_diagnoses=codelist([covid_19], "snomed"),
        ),
        last_date_with_covid=patients.attended_emergency_care(
            on_or_after="2020-02-01",
            returning="date_arrived",
            date_format="YYYY-MM-DD",
            find_last_match_in_period=True,
            with_these_diagnoses=codelist([covid_19], "snomed"),
        ),
        first_date_discharged_to_ward=patients.attended_emergency_care(
            on_or_after="2020-02-01",
            returning="date_arrived",
            date_format="YYYY-MM-DD",
            find_first_match_in_period=True,
            discharged_to=[discharge_to_ward],
        ),
        last_date_discharged_to_ward=patients.attended_emergency_care(
            on_or_after="2020-02-01",
            returning="date_arrived",
            date_format="YYYY-MM-DD",
            find_last_match_in_period=True,
            discharged_to=[discharge_to_ward],
        ),
    )

    assert_results(
        study.to_dicts(),
        attended=["0", "0", "1", "1"],
        count=["0", "0", "1", "3"],
        first_date=["", "", "2020-03-01", "2020-03-01"],
        last_date=["", "", "2020-03-01", "2020-07-01"],
        first_destination=["", "", discharge_to_home, discharge_to_home],
        last_destination=["", "", discharge_to_home, discharge_to_ward],
        with_covid=["0", "0", "0", "1"],
        first_date_with_covid=["", "", "", "2020-05-01"],
        last_date_with_covid=["", "", "", "2020-07-01"],
        first_date_discharged_to_ward=["", "", "", "2020-05-01"],
        last_date_discharged_to_ward=["", "", "", "2020-07-01"],
    )


def test_patients_date_deregistered_from_all_supported_practices():
    session = make_session()
    session.add_all(
        [
            # Never de-registered
            Patient(
                RegistrationHistory=[
                    RegistrationHistory(
                        StartDate="2001-01-01",
                        EndDate="9999-01-01",
                        Organisation=Organisation(),
                    )
                ]
            ),
            # De-registered, but after cut-off date
            Patient(
                RegistrationHistory=[
                    RegistrationHistory(
                        StartDate="2001-01-01",
                        EndDate="2017-01-01",
                        Organisation=Organisation(),
                    ),
                    RegistrationHistory(
                        StartDate="2019-01-01",
                        EndDate="2020-01-01",
                        Organisation=Organisation(),
                    ),
                ]
            ),
            # De-registered (but with a gap, and overlapping registrations)
            Patient(
                RegistrationHistory=[
                    RegistrationHistory(
                        StartDate="1990-01-01",
                        EndDate="2005-01-01",
                        Organisation=Organisation(),
                    ),
                    RegistrationHistory(
                        StartDate="2010-01-01",
                        EndDate="2015-05-19",
                        Organisation=Organisation(),
                    ),
                    RegistrationHistory(
                        StartDate="2015-04-10",
                        EndDate="2017-10-04",
                        Organisation=Organisation(),
                    ),
                ]
            ),
        ]
    )
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        dereg_date=patients.date_deregistered_from_all_supported_practices(
            on_or_before="2018-02-01",
            date_format="YYYY-MM",
        ),
        dereg_date_2=patients.date_deregistered_from_all_supported_practices(
            on_or_after="2015-01-01",
            date_format="YYYY-MM",
        ),
    )
    assert_results(
        study.to_dicts(),
        dereg_date=["", "", "2017-10"],
        dereg_date_2=["", "2020-01", "2017-10"],
    )


def test_patients_admitted_to_hospital():
    # Test period is on_or_after 2020-02-01
    session = make_session()
    session.add_all(
        [
            # Patient with no episodes
            Patient(Patient_ID=1),
            # Patient with no episodes in period
            Patient(
                Patient_ID=2,
                APCSEpisodes=[
                    APCS(
                        APCS_Ident=1,
                        Admission_Date="2020-01-01",
                        Discharge_Date="2020-03-01",
                        Der_Diagnosis_All="||AAAA ,XXXA, XXXB",
                        Der_Procedure_All="||AAAA ,YYYA, YYYB",
                        Discharge_Destination="11",
                        Source_of_Admission="2A",
                        Admission_Method="11",
                        APCS_Der=APCS_Der(
                            Patient_ID=2,
                            Spell_Primary_Diagnosis="AAAA",
                            Spell_PbR_CC_Day="3",
                        ),
                    )
                ],
            ),
            # Patient with some episodes in period
            Patient(
                Patient_ID=3,
                APCSEpisodes=[
                    APCS(
                        APCS_Ident=2,
                        Admission_Date="2020-01-01",
                        Discharge_Date="2020-02-01",
                        Der_Diagnosis_All="||BBBB ,XXXB, XXXC",
                        Der_Procedure_All="||BBBB ,YYYB, YYYC",
                        Discharge_Destination="99",
                        Source_of_Admission="2A",
                        Admission_Method="50",
                        APCS_Der=APCS_Der(
                            Patient_ID=3,
                            Spell_Primary_Diagnosis="BBBB",
                            Spell_PbR_CC_Day="4",
                        ),
                    ),
                    APCS(
                        APCS_Ident=3,
                        Admission_Date="2020-03-01",
                        Discharge_Date="2020-04-01",
                        Der_Diagnosis_All="||CCCC ,XXXC, XXXD",
                        Der_Procedure_All="||CCCC ,YYYC, YYYD",
                        APCS_Der=APCS_Der(Patient_ID=3, Spell_Primary_Diagnosis="CCCC"),
                    ),
                ],
            ),
            # Patient with multiple episodes in period
            Patient(
                Patient_ID=4,
                APCSEpisodes=[
                    APCS(
                        APCS_Ident=4,
                        Admission_Date="2020-03-01",
                        Discharge_Date="2020-04-01",
                        Der_Diagnosis_All="||DDDD ,XXXD, XXXE",
                        Der_Procedure_All="||DDDD ,YYYD, YYYE",
                        Discharge_Destination="11",
                        Source_of_Admission="3B",
                        Admission_Method="99",
                        APCS_Der=APCS_Der(
                            Patient_ID=4,
                            Spell_Primary_Diagnosis="DDDD",
                            Spell_PbR_CC_Day="5",
                        ),
                    ),
                    APCS(
                        APCS_Ident=5,
                        Admission_Date="2020-05-01",
                        Discharge_Date="2020-06-01",
                        Der_Diagnosis_All="||EEEE ,XXXE, XXXF",
                        Der_Procedure_All="||EEEE ,YYYE, YYYF",
                        APCS_Der=APCS_Der(Patient_ID=4, Spell_Primary_Diagnosis="EEEE"),
                    ),
                    APCS(
                        APCS_Ident=6,
                        Admission_Date="2020-07-01",
                        Discharge_Date="2020-08-01",
                        Der_Diagnosis_All="||FFFF ,XXXF, XXXG",
                        Der_Procedure_All="||FFFF ,YYYF, YYYG",
                        APCS_Der=APCS_Der(Patient_ID=4, Spell_Primary_Diagnosis="FFFF"),
                    ),
                ],
            ),
        ]
    )
    session.commit()

    study = StudyDefinition(
        population=patients.all(),
        admitted=patients.admitted_to_hospital(
            on_or_after="2020-02-01", returning="binary_flag"
        ),
        count=patients.admitted_to_hospital(
            on_or_after="2020-02-01",
            returning="number_of_matches_in_period",
        ),
        first_date_admitted=patients.admitted_to_hospital(
            on_or_after="2020-02-01",
            returning="date_admitted",
            find_first_match_in_period=True,
            date_format="YYYY-MM-DD",
        ),
        last_date_admitted=patients.admitted_to_hospital(
            on_or_after="2020-02-01",
            returning="date_admitted",
            find_last_match_in_period=True,
            date_format="YYYY-MM-DD",
        ),
        first_date_discharged=patients.admitted_to_hospital(
            on_or_after="2020-02-01",
            returning="date_discharged",
            find_first_match_in_period=True,
            date_format="YYYY-MM-DD",
        ),
        last_date_discharged=patients.admitted_to_hospital(
            on_or_after="2020-02-01",
            returning="date_discharged",
            find_last_match_in_period=True,
            date_format="YYYY-MM-DD",
        ),
        with_particular_primary_diagnosis=patients.admitted_to_hospital(
            on_or_after="2020-02-01",
            returning="binary_flag",
            with_these_primary_diagnoses=codelist([("EEEE", "cat1")], "icd10"),
        ),
        with_particular_diagnoses_1=patients.admitted_to_hospital(
            on_or_after="2020-02-01",
            returning="number_of_matches_in_period",
            with_these_diagnoses=codelist([("XXXD", "cat2")], "icd10"),
        ),
        with_particular_diagnoses_2=patients.admitted_to_hospital(
            on_or_after="2020-02-01",
            returning="number_of_matches_in_period",
            with_these_diagnoses=codelist(["XXXE"], "icd10"),
        ),
        with_particular_diagnoses_3=patients.admitted_to_hospital(
            on_or_after="2020-02-01",
            returning="number_of_matches_in_period",
            with_these_diagnoses=codelist(["XXX"], "icd10"),
        ),
        with_particular_diagnoses_4=patients.admitted_to_hospital(
            on_or_after="2020-02-01",
            returning="number_of_matches_in_period",
            with_these_diagnoses=codelist(["XXXC", "XXXD", "XXXE"], "icd10"),
        ),
        with_particular_procedures=patients.admitted_to_hospital(
            on_or_after="2020-02-01",
            returning="number_of_matches_in_period",
            with_these_procedures=codelist(["YYYC", "YYYD", "YYYE"], "opcs4"),
        ),
        first_primary_diagnosis=patients.admitted_to_hospital(
            on_or_after="2020-02-01",
            returning="primary_diagnosis",
            find_first_match_in_period=True,
        ),
        last_primary_diagnosis=patients.admitted_to_hospital(
            on_or_after="2020-02-01",
            returning="primary_diagnosis",
            find_last_match_in_period=True,
        ),
        discharge_dest=patients.admitted_to_hospital(
            with_source_of_admission="2A",
            returning="discharge_destination",
        ),
        critical_care_days=patients.admitted_to_hospital(
            with_admission_method=["11", "99"],
            returning="days_in_critical_care",
        ),
        primary_diagnosis_prefix=patients.admitted_to_hospital(
            returning="binary_flag",
            with_these_primary_diagnoses=codelist(["AAA"], "icd10"),
        ),
    )

    assert_results(
        study.to_dicts(),
        admitted=["0", "0", "1", "1"],
        count=["0", "0", "1", "3"],
        first_date_admitted=["", "", "2020-03-01", "2020-03-01"],
        last_date_admitted=["", "", "2020-03-01", "2020-07-01"],
        first_date_discharged=["", "", "2020-04-01", "2020-04-01"],
        last_date_discharged=["", "", "2020-04-01", "2020-08-01"],
        with_particular_primary_diagnosis=["0", "0", "0", "1"],
        with_particular_diagnoses_1=["0", "0", "1", "1"],
        with_particular_diagnoses_2=["0", "0", "0", "2"],
        with_particular_diagnoses_3=["0", "0", "1", "3"],
        with_particular_diagnoses_4=["0", "0", "1", "2"],
        with_particular_procedures=["0", "0", "1", "2"],
        first_primary_diagnosis=["", "", "CCCC", "DDDD"],
        last_primary_diagnosis=["", "", "CCCC", "FFFF"],
        discharge_dest=["", "11", "99", ""],
        critical_care_days=["", "3", "", "5"],
        primary_diagnosis_prefix=["0", "1", "0", "0"],
    )


def test_temporary_database_happy_path(tmp_path, monkeypatch):
    temporary_database = os.environ["TPP_TEMP_DATABASE_NAME"]
    monkeypatch.setenv("TEMP_DATABASE_NAME", temporary_database)
    session = make_session()
    session.add_all(
        [
            Patient(DateOfBirth="1960-01-01", Sex="M"),
            Patient(DateOfBirth="1980-01-01", Sex="F"),
        ]
    )
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        sex=patients.sex(),
        age=patients.age_as_of("1990-01-01"),
    )
    initial_temporary_tables = _list_table_in_db(session, temporary_database)
    study.to_file(tmp_path / "test.csv")
    with open(tmp_path / "test.csv") as f:
        results = list(csv.DictReader(f))
    assert_results(results, sex=["M", "F"], age=["30", "10"])
    # Check that the temporary table has been deleted
    final_temporary_tables = _list_table_in_db(session, temporary_database)
    assert final_temporary_tables == initial_temporary_tables


def test_temporary_database_with_failure(tmp_path, monkeypatch):
    temporary_database = os.environ["TPP_TEMP_DATABASE_NAME"]
    monkeypatch.setenv("TEMP_DATABASE_NAME", temporary_database)
    session = make_session()
    session.add_all(
        [
            Patient(DateOfBirth="1960-01-01", Sex="M"),
            Patient(DateOfBirth="1980-01-01", Sex="F"),
        ]
    )
    session.commit()
    study_args = dict(
        population=patients.all(),
        sex=patients.sex(),
        age=patients.age_as_of("2000-01-01"),
    )
    study = StudyDefinition(**study_args)
    initial_temporary_tables = _list_table_in_db(session, temporary_database)
    # Trigger error during data download process
    with patch("cohortextractor.tpp_backend.mssql_fetch_table") as mssql_fetch_table:
        mssql_fetch_table.side_effect = ValueError("deliberate error")
        with pytest.raises(ValueError, match="deliberate error"):
            study.to_file(tmp_path / "fail.csv")
    # Check that we've created one extra temporary table
    temporary_tables = _list_table_in_db(session, temporary_database)
    assert len(set(temporary_tables) - set(initial_temporary_tables)) == 1
    # Delete all patient data so we can be sure the download below isn't just
    # re-running the query
    session.query(Patient).delete()
    session.commit()
    # Now try making a new study with the same definition, downloading again
    # and check we have correct results
    new_study = StudyDefinition(**study_args)
    new_study.to_file(tmp_path / "test.csv")
    with open(tmp_path / "test.csv") as f:
        results = list(csv.DictReader(f))
    assert_results(results, sex=["M", "F"], age=["40", "20"])
    # Check that the temporary table has been deleted
    final_temporary_tables = _list_table_in_db(session, temporary_database)
    assert final_temporary_tables == initial_temporary_tables


def _list_table_in_db(session, database_name):
    conn = session.connection()
    results = conn.execute(
        f"""
        SELECT table_name FROM {database_name}.information_schema.tables
        WHERE table_type = 'BASE TABLE'
        """
    )
    return sorted(row[0] for row in results)


def test_large_codelists_upload_correctly():
    # 999 is the limit we can upload in a single batch so we want to be well
    # above that
    codes = [f"foo{i}" for i in range(3000)]
    session = make_session()
    # Select codes from the beginning, middle and end of the codelist
    session.add_all(
        [
            Patient(
                CodedEvents=[
                    CodedEvent(
                        CTV3Code=codes[0],
                        NumericValue=7,
                    ),
                ]
            ),
            Patient(
                CodedEvents=[
                    CodedEvent(
                        CTV3Code=codes[1500],
                        NumericValue=11,
                    ),
                ]
            ),
            Patient(
                CodedEvents=[
                    CodedEvent(
                        CTV3Code=codes[-1],
                        NumericValue=18,
                    ),
                ]
            ),
        ]
    )
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        value=patients.with_these_clinical_events(
            codelist(codes, system="ctv3"), returning="numeric_value"
        ),
    )
    results = study.to_dicts()
    assert_results(results, value=["7.0", "11.0", "18.0"])


def test_use_of_date_expressions():
    session = make_session()
    session.add_all(
        [
            # Event too early
            Patient(
                DateOfBirth="1980-01-01",
                CodedEvents=[CodedEvent(ConsultationDate="2012-12-15", CTV3Code="foo")],
            ),
            # Events in range
            Patient(
                DateOfBirth="1980-05-01",
                CodedEvents=[CodedEvent(ConsultationDate="2013-01-01", CTV3Code="foo")],
            ),
            Patient(
                DateOfBirth="1980-07-01",
                CodedEvents=[CodedEvent(ConsultationDate="2015-12-31", CTV3Code="foo")],
            ),
            # Event too late
            Patient(
                DateOfBirth="1980-01-01",
                CodedEvents=[CodedEvent(ConsultationDate="2016-01-01", CTV3Code="foo")],
            ),
        ]
    )
    session.commit()
    study = StudyDefinition(
        index_date="2015-06-01",
        population=patients.with_these_clinical_events(
            codelist(["foo"], system="ctv3"),
            between=[
                "first_day_of_year(index_date) - 2 years",
                "last_day_of_year(index_date)",
            ],
        ),
        age=patients.age_as_of("index_date"),
    )
    results = study.to_dicts()
    assert_results(results, age=["35", "34"])


def test_patients_with_death_recorded_in_primary_care():
    session = make_session()
    session.add_all(
        [
            Patient(DateOfDeath="9999-12-31"),
            Patient(DateOfDeath="2017-05-06"),
            Patient(DateOfDeath="2019-06-07"),
            Patient(DateOfDeath="2020-07-08"),
        ]
    )
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        has_died=patients.with_death_recorded_in_primary_care(),
        date_of_death=patients.with_death_recorded_in_primary_care(
            returning="date_of_death", date_format="YYYY-MM-DD"
        ),
        died_in_2019=patients.with_death_recorded_in_primary_care(
            between=["2019-01-01", "2019-12-31"],
            returning="date_of_death",
        ),
    )
    assert_results(
        study.to_dicts(),
        has_died=["0", "1", "1", "1"],
        date_of_death=["", "2017-05-06", "2019-06-07", "2020-07-08"],
        died_in_2019=["", "", "2019", ""],
    )


def test_date_expressions_are_handled_in_practice_address_and_care_home_methods():
    study = StudyDefinition(
        index_date="2020-01-01",
        population=patients.all(),
        practice=patients.registered_practice_as_of(
            "index_date", returning="pseudo_id"
        ),
        address=patients.address_as_of(
            "index_date", returning="rural_urban_classification"
        ),
        care_home=patients.care_home_status_as_of("index_date"),
    )
    # We don't care about the results, we just want to check that this doesn't
    # blow up with an "invalid date" error
    assert_results(study.to_dicts(), practice=[], address=[], care_home=[])


def test_extracting_at_different_index_dates():
    codes = [f"foo{i}" for i in range(10)]
    session = make_session()
    session.add_all(
        [
            Patient(
                CodedEvents=[
                    CodedEvent(CTV3Code=codes[1], ConsultationDate="2020-01-14")
                ]
            ),
            Patient(
                CodedEvents=[
                    CodedEvent(CTV3Code=codes[5], ConsultationDate="2020-02-10")
                ]
            ),
        ]
    )
    session.commit()
    study = StudyDefinition(
        index_date="2020-01-01",
        population=patients.all(),
        value=patients.with_these_clinical_events(
            codelist(codes, system="ctv3"),
            returning="date",
            date_format="YYYY-MM-DD",
            between=["index_date", "index_date + 1 month"],
        ),
    )
    study.set_index_date("2020-01-01")
    results = study.to_dicts()
    assert_results(results, value=["2020-01-14", ""])
    study.set_index_date("2020-02-01")
    results = study.to_dicts()
    assert_results(results, value=["", "2020-02-10"])


def test_aggregate_over_different_date_formats_raises_error():
    with pytest.raises(ValueError, match="dates of different format"):
        StudyDefinition(
            population=patients.all(),
            birth=patients.date_of_birth(date_format="YYYY-MM"),
            death=patients.with_death_recorded_in_primary_care(
                returning="date_of_death", date_format="YYYY-MM-DD"
            ),
            last_major_life_event=patients.maximum_of("birth", "death"),
        )


def test_dynamic_index_dates():
    session = make_session()
    session.add_all(
        [
            Patient(
                CodedEvents=[
                    CodedEvent(ConsultationDate="2020-01-01", CTV3Code="foo"),
                    CodedEvent(ConsultationDate="2020-02-01", CTV3Code="foo"),
                    CodedEvent(ConsultationDate="2020-03-01", CTV3Code="bar"),
                    CodedEvent(ConsultationDate="2020-04-20", CTV3Code="foo"),
                    CodedEvent(ConsultationDate="2020-05-01", CTV3Code="foo"),
                    CodedEvent(ConsultationDate="2020-06-01", CTV3Code="bar"),
                ],
                SGSS_Positives=[
                    SGSS_Positive(Earliest_Specimen_Date="2020-01-01"),
                    SGSS_Positive(Earliest_Specimen_Date="2020-05-01"),
                ],
                RegistrationHistory=[
                    RegistrationHistory(
                        StartDate="1990-01-01",
                        EndDate="2020-02-01",
                        Organisation=Organisation(Organisation_ID=1),
                    ),
                    RegistrationHistory(
                        StartDate="2020-02-01",
                        EndDate="2020-12-10",
                        Organisation=Organisation(Organisation_ID=2),
                    ),
                ],
            ),
        ]
    )
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        earliest_bar=patients.with_these_clinical_events(
            codelist(["bar"], system="ctv3"),
            returning="date",
            date_format="YYYY-MM-DD",
            find_first_match_in_period=True,
        ),
        latest_foo_before_bar=patients.with_these_clinical_events(
            codelist(["foo"], system="ctv3"),
            returning="date",
            date_format="YYYY-MM-DD",
            find_last_match_in_period=True,
            on_or_before="earliest_bar",
        ),
        latest_foo_in_month_after_bar=patients.with_these_clinical_events(
            codelist(["foo"], system="ctv3"),
            returning="date",
            date_format="YYYY-MM-DD",
            find_last_match_in_period=True,
            on_or_before="last_day_of_month(earliest_bar) + 1 month",
        ),
        positive_test_after_bar=patients.with_test_result_in_sgss(
            pathogen="SARS-CoV-2",
            test_result="positive",
            on_or_after="earliest_bar",
            find_first_match_in_period=True,
            returning="date",
            date_format="YYYY-MM-DD",
        ),
        practice_id_at_bar=patients.registered_practice_as_of(
            "earliest_bar", returning="pseudo_id"
        ),
        deregistration_date=patients.date_deregistered_from_all_supported_practices(
            on_or_after="latest_foo_before_bar",
            date_format="YYYY-MM-DD",
        ),
    )
    assert_results(
        study.to_dicts(),
        earliest_bar=["2020-03-01"],
        latest_foo_before_bar=["2020-02-01"],
        latest_foo_in_month_after_bar=["2020-04-20"],
        positive_test_after_bar=["2020-05-01"],
        practice_id_at_bar=["2"],
        deregistration_date=["2020-12-10"],
    )


def test_dynamic_index_dates_with_invalid_expression():
    with pytest.raises(InvalidExpressionError):
        StudyDefinition(
            population=patients.all(),
            earliest_bar=patients.with_these_clinical_events(
                codelist(["bar"], system="ctv3"),
                returning="date",
                date_format="YYYY-MM-DD",
            ),
            latest_foo_in_month_after_bar=patients.with_these_clinical_events(
                codelist(["foo"], system="ctv3"),
                on_or_before="last_day_of_month(earliest_bar) + 1 mnth",
            ),
        )


def test_high_cost_drugs():
    session = make_session()
    session.add_all(
        [
            Patient(
                HighCostDrugs=[
                    HighCostDrugs(
                        DrugName="foo", FinancialYear="201920", FinancialMonth="2"
                    ),
                    HighCostDrugs(
                        DrugName="bar", FinancialYear="201920", FinancialMonth="6"
                    ),
                    HighCostDrugs(
                        DrugName="bar", FinancialYear="201920", FinancialMonth="7"
                    ),
                    HighCostDrugs(
                        DrugName="foo", FinancialYear="201920", FinancialMonth="10"
                    ),
                ],
            ),
        ]
    )
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        latest_drug_date=patients.with_high_cost_drugs(
            find_last_match_in_period=True,
            returning="date",
            date_format="YYYY-MM",
        ),
        first_bar_date=patients.with_high_cost_drugs(
            drug_name_matches="bar",
            find_first_match_in_period=True,
            returning="date",
            date_format="YYYY-MM",
        ),
        latest_drug_before_bar=patients.with_high_cost_drugs(
            on_or_before="first_bar_date - 1 month",
            find_last_match_in_period=True,
            returning="date",
            date_format="YYYY-MM",
        ),
    )
    assert_results(
        study.to_dicts(),
        latest_drug_date=["2020-01"],
        first_bar_date=["2019-09"],
        latest_drug_before_bar=["2019-05"],
    )


def test_ethnicity_from_sus():
    session = make_session()
    session.add_all(
        [
            # B0 by most recent record
            # D0 by most common record
            Patient(
                APCSEpisodes=[
                    APCS(Ethnic_Group="D0"),
                    APCS(Ethnic_Group="D0"),
                    APCS(Ethnic_Group="D0"),
                    APCS(Ethnic_Group="B0"),
                ],
                ECEpisodes=[
                    EC(Ethnic_Category="D"),
                    EC(Ethnic_Category="D"),
                ],
                OPAEpisodes=[
                    OPA(Ethnic_Category="D*"),
                ],
            ),
            # G by most recent and most common
            Patient(
                APCSEpisodes=[
                    APCS(Ethnic_Group="GC"),
                ],
                ECEpisodes=[
                    EC(Ethnic_Category="G"),
                    EC(Ethnic_Category="G"),
                ],
                OPAEpisodes=[
                    OPA(Ethnic_Category="GF"),
                ],
            ),
        ]
    )
    session.commit()

    study = StudyDefinition(
        population=patients.all(),
        ethnicity_by_code=patients.with_ethnicity_from_sus(
            returning="code",
            use_most_frequent_code=True,
        ),
        ethnicity_by_group_6=patients.with_ethnicity_from_sus(
            returning="group_6",
            use_most_frequent_code=True,
        ),
        ethnicity_by_group_16=patients.with_ethnicity_from_sus(
            returning="group_16",
            use_most_frequent_code=True,
        ),
    )

    assert_results(
        study.to_dicts(),
        ethnicity_by_code=["D0", "G"],
        ethnicity_by_group_6=["2", "2"],
        ethnicity_by_group_16=["4", "7"],
    )


def _make_patient_with_decision_support_values():
    """Makes a patient with decision support values for the Electronic Frailty Index."""
    session = make_session()
    session.add_all(
        [
            Patient(
                DecisionSupportValue=[
                    DecisionSupportValue(
                        AlgorithmType=1,  # Set by TPP
                        CalculationDateTime="2020-01-01 00:00:00.000",
                        NumericValue=0.1,
                    ),
                    DecisionSupportValue(
                        AlgorithmType=1,
                        CalculationDateTime="2020-07-01 00:00:00.000",
                        NumericValue=0.2,
                    ),
                    DecisionSupportValue(
                        AlgorithmType=1,
                        CalculationDateTime="2021-01-01 00:00:00.000",
                        NumericValue=0.3,
                    ),
                ]
            ),
        ]
    )
    session.commit()


def test_decision_support_values_with_unsupported_algorithm_value():
    _make_patient_with_decision_support_values()
    with pytest.raises(ValueError) as exinfo:
        StudyDefinition(
            population=patients.all(),
            efi=patients.with_these_decision_support_values(
                "eFI",
            ),
        )

    assert str(exinfo.value) == "Unsupported `algorithm` value: eFI"


@pytest.mark.parametrize(
    "returning,expected",
    [
        ("binary_flag", ["1"]),
        ("date", ["2021"]),
        ("number_of_matches_in_period", ["3"]),
        ("numeric_value", ["0.3"]),
    ],
)
def test_decision_support_values_with_max_date(returning, expected):
    _make_patient_with_decision_support_values()
    study = StudyDefinition(
        population=patients.all(),
        efi=patients.with_these_decision_support_values(
            "electronic_frailty_index",
            on_or_before="2021-01-01",
            returning=returning,
        ),
    )
    assert_results(study.to_dicts(), efi=expected)


@pytest.mark.parametrize(
    "returning,expected",
    [
        ("binary_flag", ["1"]),
        ("date", ["2021"]),
        ("number_of_matches_in_period", ["1"]),
        ("numeric_value", ["0.3"]),
    ],
)
def test_decision_support_values_with_min_date(returning, expected):
    _make_patient_with_decision_support_values()
    study = StudyDefinition(
        population=patients.all(),
        efi=patients.with_these_decision_support_values(
            "electronic_frailty_index",
            on_or_after="2021-01-01",
            returning=returning,
        ),
    )
    assert_results(study.to_dicts(), efi=expected)


@pytest.mark.parametrize(
    "returning,expected",
    [
        ("binary_flag", ["1"]),
        ("date", ["2020"]),
        ("number_of_matches_in_period", ["2"]),
        ("numeric_value", ["0.2"]),
    ],
)
def test_decision_support_values_with_max_and_min_date(returning, expected):
    _make_patient_with_decision_support_values()
    study = StudyDefinition(
        population=patients.all(),
        efi=patients.with_these_decision_support_values(
            "electronic_frailty_index",
            between=["2020-01-01", "2020-12-31"],
            returning=returning,
        ),
    )
    assert_results(study.to_dicts(), efi=expected)


@pytest.mark.parametrize(
    "returning,expected",
    [
        ("binary_flag", ["1"]),
        ("date", ["2020"]),
        ("number_of_matches_in_period", ["3"]),
        ("numeric_value", ["0.1"]),
    ],
)
def test_decision_support_values_with_first_match(returning, expected):
    _make_patient_with_decision_support_values()
    study = StudyDefinition(
        population=patients.all(),
        efi=patients.with_these_decision_support_values(
            "electronic_frailty_index",
            find_first_match_in_period=True,
            returning=returning,
        ),
    )
    assert_results(study.to_dicts(), efi=expected)


@pytest.mark.parametrize(
    "returning,expected",
    [
        ("binary_flag", ["1"]),
        ("date", ["2021"]),
        ("number_of_matches_in_period", ["3"]),
        ("numeric_value", ["0.3"]),
    ],
)
def test_decision_support_values_with_last_match(returning, expected):
    _make_patient_with_decision_support_values()
    study = StudyDefinition(
        population=patients.all(),
        efi=patients.with_these_decision_support_values(
            "electronic_frailty_index",
            find_last_match_in_period=True,
            returning=returning,
        ),
    )
    assert_results(study.to_dicts(), efi=expected)


def test_decision_support_values_with_first_match_and_last_match():
    _make_patient_with_decision_support_values()
    with pytest.raises(AssertionError):
        StudyDefinition(
            population=patients.all(),
            efi=patients.with_these_decision_support_values(
                "electronic_frailty_index",
                find_first_match_in_period=True,
                find_last_match_in_period=True,
            ),
        )


def test_decision_support_values_with_unsupported_returning_value():
    _make_patient_with_decision_support_values()
    with pytest.raises(ValueError) as exinfo:
        StudyDefinition(
            population=patients.all(),
            efi=patients.with_these_decision_support_values(
                "electronic_frailty_index",
                returning="code",
            ),
        )

    assert str(exinfo.value) == "Unsupported `returning` value: code"


@pytest.mark.parametrize(
    "returning,expected",
    [
        ("binary_flag", ["1"]),
        ("date", ["2021"]),
        ("number_of_matches_in_period", ["1"]),
        ("numeric_value", ["0.1"]),
    ],
)
def test_decision_support_values_with_ignore_missing_values(returning, expected):
    session = make_session()
    session.add_all(
        [
            Patient(
                DecisionSupportValue=[
                    DecisionSupportValue(
                        AlgorithmType=1,
                        CalculationDateTime="2020-01-01 00:00:00.000",
                        NumericValue=0.0,  # Ignore me!
                    ),
                    DecisionSupportValue(
                        AlgorithmType=1,
                        CalculationDateTime="2021-01-01 00:00:00.000",
                        NumericValue=0.1,
                    ),
                ]
            ),
        ]
    )
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        efi=patients.with_these_decision_support_values(
            "electronic_frailty_index",
            returning=returning,
            ignore_missing_values=True,
        ),
    )
    assert_results(study.to_dicts(), efi=expected)
