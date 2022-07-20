# -*- coding: utf-8 -*-
import csv
import gzip
import os
import subprocess
from datetime import datetime
from unittest.mock import patch

import pandas
import pytest

from cohortextractor import StudyDefinition, codelist, flags, patients, tpp_backend
from cohortextractor.date_expressions import InvalidExpressionError
from cohortextractor.mssql_utils import mssql_connection_params_from_url
from cohortextractor.patients import (
    max_recorded_value,
    mean_recorded_value,
    min_recorded_value,
)
from cohortextractor.tpp_backend import (
    AppointmentStatus,
    TPPBackend,
    escape_like_query_fragment,
    quote,
)
from tests.helpers import assert_results
from tests.tpp_backend_setup import (
    APCS,
    CPNS,
    EC,
    ICNARC,
    ONS_CIS,
    OPA,
    UKRR,
    APCS_Der,
    Appointment,
    BuildProgress,
    ClusterRandomisedTrial,
    ClusterRandomisedTrialDetail,
    ClusterRandomisedTrialReference,
    CodedEvent,
    CodedEventRange,
    CodedEventSnomed,
    DecisionSupportValue,
    EC_Diagnosis,
    HealthCareWorker,
    HighCostDrugs,
    Household,
    HouseholdMember,
    ISARICData,
    MedicationDictionary,
    MedicationIssue,
    ONSDeaths,
    OPA_Proc,
    Organisation,
    Patient,
    PatientAddress,
    PotentialCareHomeAddress,
    RegistrationHistory,
    SGSS_AllTests_Negative,
    SGSS_AllTests_Positive,
    SGSS_Negative,
    SGSS_Positive,
    Therapeutics,
    Vaccination,
    VaccinationReference,
    clear_database,
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


def teardown_module(module):
    clear_database()


def setup_function(function):
    """Ensure test database is empty"""
    session = make_session()
    session.query(CodedEventRange).delete()
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
    session.query(ClusterRandomisedTrial).delete()
    session.query(ClusterRandomisedTrialDetail).delete()
    session.query(ClusterRandomisedTrialReference).delete()
    session.query(Organisation).delete()
    session.query(PotentialCareHomeAddress).delete()
    session.query(PatientAddress).delete()
    session.query(HouseholdMember).delete()
    session.query(Household).delete()
    session.query(EC_Diagnosis).delete()
    session.query(EC).delete()
    session.query(APCS_Der).delete()
    session.query(APCS).delete()
    session.query(OPA_Proc).delete()
    session.query(OPA).delete()
    session.query(HighCostDrugs).delete()
    session.query(DecisionSupportValue).delete()
    session.query(HealthCareWorker).delete()
    session.query(Therapeutics).delete()
    session.query(ISARICData).delete()
    session.query(ONS_CIS).delete()
    session.query(UKRR).delete()
    session.query(Patient).delete()
    session.query(BuildProgress).delete()

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


def test_minimal_study_with_reserved_keywords():
    # Test that we can use reserved SQL keywords as study variables
    session = make_session()
    patient_1 = Patient(DateOfBirth="1980-01-01", Sex="M")
    patient_2 = Patient(DateOfBirth="1965-01-01", Sex="F")
    session.add_all([patient_1, patient_2])
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        all=patients.sex(),
        asc=patients.age_as_of("2020-01-01"),
    )

    assert_results(study.to_dicts(), all=["M", "F"], asc=["40", "55"])


@pytest.mark.parametrize("format", ["csv", "csv.gz", "feather", "dta", "dta.gz"])
def test_study_to_file_with_therapeutic_risk_groups(tmp_path, format):
    session = make_session()
    patient_1 = Patient(
        DateOfBirth="1980-01-01",
        Sex="M",
        Therapeutics=[
            Therapeutics(MOL1_high_risk_cohort="not allowed"),
        ],
    )
    patient_2 = Patient(
        DateOfBirth="1965-01-01",
        Sex="F",
        Therapeutics=[
            Therapeutics(
                MOL1_high_risk_cohort="Patients with liver disease",
                SOT02_risk_cohorts="Patient with a disallowed group",
            ),
        ],
    )
    session.add_all([patient_1, patient_2])
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        risk_group=patients.with_covid_therapeutics(returning="risk_group"),
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

    patient_results = [result["patient_id"] for result in results]
    assert patient_results == [cast(patient_1.Patient_ID), cast(patient_2.Patient_ID)]
    risk_groups_results = [
        ",".join(sorted(result["risk_group"].split(","))) for result in results
    ]
    assert risk_groups_results == ["other", "liver disease,other"]


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
    module = study.backend.get_db_connection().db_connection.__class__.__module__
    assert module.startswith("pymssql")


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


@pytest.mark.parametrize(
    "summary_function,expected",
    [
        (mean_recorded_value, [("96.0", "2020-02-10"), ("0.0", ""), ("0.0", "")]),
        (min_recorded_value, [("90.0", "2020-02-10"), ("0.0", ""), ("0.0", "")]),
        (max_recorded_value, [("100.0", "2020-02-10"), ("0.0", ""), ("0.0", "")]),
    ],
)
def test_summary_recorded_values_on_most_recent_day(summary_function, expected):
    code = "2469."
    session = make_session()
    patient = Patient()
    values = [
        # These days are within the period but not the most recent, and should be ignored
        ("2020-01-01", 110),
        ("2020-01-02", 80),
        # This is the most recent day; mean taken from these 3 measurements
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
        bp_systolic=summary_function(
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
    assert results == expected


@pytest.mark.parametrize(
    "summary_function,expected",
    [
        (mean_recorded_value, ["95.6", "0.0", "0.0"]),
        (min_recorded_value, ["80.0", "0.0", "0.0"]),
        (max_recorded_value, ["110.0", "0.0", "0.0"]),
    ],
)
def test_summary_recorded_values_across_date_range(summary_function, expected):
    code = "44J3."
    session = make_session()
    patient = Patient()
    values = [
        # these 5 are within the period
        ("2020-01-01", 110),
        ("2020-01-02", 80),
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
        creatine=summary_function(
            codelist([code], system="ctv3"),
            on_most_recent_day_of_measurement=False,
            between=["2018-01-01", "2020-03-01"],
        ),
    )
    assert_results(study.to_dicts(), creatine=expected)


def test_mean_recorded_value_across_date_range_include_measurement_date_error():
    with pytest.raises(
        AssertionError,
        match="Can only include measurement date if on_most_recent_day_of_measurement is True",
    ):
        StudyDefinition(
            population=patients.all(),
            creatine=patients.mean_recorded_value(
                codelist(["44J3."], system="ctv3"),
                on_most_recent_day_of_measurement=False,
                between=["2018-01-01", "2020-03-01"],
                include_measurement_date=True,
            ),
        )


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


def test_patients_registered_practice_as_of_returning_rct():
    session = make_session()

    # Add a patient at an organisation. The organisation is participating in two RCTs.
    org_1 = Organisation()
    patient_1 = Patient()
    patient_1.RegistrationHistory.append(
        RegistrationHistory(
            StartDate="2019-01-01",
            EndDate="2021-01-01",
            Organisation=org_1,
        )
    )
    crt_reference_1 = ClusterRandomisedTrialReference(
        TrialName="germdefence",
    )
    crt_reference_1.ClusterRandomisedTrial.append(
        ClusterRandomisedTrial(
            Organisation=org_1,
            TrialArm="1",
        )
    )

    crt_reference_1.ClusterRandomisedTrialDetail.append(
        ClusterRandomisedTrialDetail(
            Organisation=org_1,
            Property="deprivation_pctile",
            PropertyValue="4",
        )
    )

    crt_reference_1.ClusterRandomisedTrialDetail.append(
        ClusterRandomisedTrialDetail(
            Organisation=org_1,
            Property="IntCon",
            PropertyValue="1",
        )
    )

    crt_reference_1.ClusterRandomisedTrialDetail.append(
        ClusterRandomisedTrialDetail(
            Organisation=org_1,
            Property="IMD_decile",
            PropertyValue="4",
        )
    )
    crt_reference_1.ClusterRandomisedTrialDetail.append(
        ClusterRandomisedTrialDetail(
            Organisation=org_1,
            Property="MeanAge",
            PropertyValue="43.8",
        )
    )
    crt_reference_1.ClusterRandomisedTrialDetail.append(
        ClusterRandomisedTrialDetail(
            Organisation=org_1,
            Property="MedianAge",
            PropertyValue="33.5",
        )
    )

    crt_reference_1.ClusterRandomisedTrialDetail.append(
        ClusterRandomisedTrialDetail(
            Organisation=org_1,
            Property="Av_rooms_per_house",
            PropertyValue="6.1",
        )
    )
    crt_reference_1.ClusterRandomisedTrialDetail.append(
        ClusterRandomisedTrialDetail(
            Organisation=org_1,
            Property="Minority_ethnic_total",
            PropertyValue="9.5",
        )
    )
    crt_reference_1.ClusterRandomisedTrialDetail.append(
        ClusterRandomisedTrialDetail(
            Organisation=org_1,
            Property="n_times_visited_mean",
            PropertyValue="1.34",
        )
    )
    crt_reference_1.ClusterRandomisedTrialDetail.append(
        ClusterRandomisedTrialDetail(
            Organisation=org_1,
            Property="n_pages_viewed_mean",
            PropertyValue="42.2",
        )
    )
    crt_reference_1.ClusterRandomisedTrialDetail.append(
        ClusterRandomisedTrialDetail(
            Organisation=org_1,
            Property="total_visit_time_mean",
            PropertyValue="320.33",
        )
    )
    crt_reference_1.ClusterRandomisedTrialDetail.append(
        ClusterRandomisedTrialDetail(
            Organisation=org_1,
            Property="prop_engaged_visits",
            PropertyValue="6.5",
        )
    )

    crt_reference_1.ClusterRandomisedTrialDetail.append(
        ClusterRandomisedTrialDetail(
            Organisation=org_1,
            Property="n_engaged_visits_mean",
            PropertyValue="316",
        )
    )

    crt_reference_1.ClusterRandomisedTrialDetail.append(
        ClusterRandomisedTrialDetail(
            Organisation=org_1,
            Property="n_engaged_pages_viewed_mean_mean",
            PropertyValue="11.11",
        )
    )
    crt_reference_1.ClusterRandomisedTrialDetail.append(
        ClusterRandomisedTrialDetail(
            Organisation=org_1,
            Property="N_visits_practice",
            PropertyValue="7",
        )
    )

    crt_reference_1.ClusterRandomisedTrialDetail.append(
        ClusterRandomisedTrialDetail(
            Organisation=org_1,
            Property="group_mean_behaviour_mean",
            PropertyValue="2.64",
        )
    )

    crt_reference_1.ClusterRandomisedTrialDetail.append(
        ClusterRandomisedTrialDetail(
            Organisation=org_1,
            Property="group_mean_intention_mean",
            PropertyValue="3.34",
        )
    )

    crt_reference_1.ClusterRandomisedTrialDetail.append(
        ClusterRandomisedTrialDetail(
            Organisation=org_1,
            Property="N_completers_RI_behav",
            PropertyValue="1",
        )
    )
    crt_reference_1.ClusterRandomisedTrialDetail.append(
        ClusterRandomisedTrialDetail(
            Organisation=org_1,
            Property="N_completers_RI_intent",
            PropertyValue="9",
        )
    )
    crt_reference_1.ClusterRandomisedTrialDetail.append(
        ClusterRandomisedTrialDetail(
            Organisation=org_1,
            Property="hand_behav_practice_mean",
            PropertyValue="1.5",
        )
    )
    crt_reference_1.ClusterRandomisedTrialDetail.append(
        ClusterRandomisedTrialDetail(
            Organisation=org_1,
            Property="hand_intent_practice_mean",
            PropertyValue="4.33",
        )
    )
    crt_reference_1.ClusterRandomisedTrialDetail.append(
        ClusterRandomisedTrialDetail(
            Organisation=org_1,
            Property="N_completers_HW_behav",
            PropertyValue="11",
        )
    )

    crt_reference_1.ClusterRandomisedTrialDetail.append(
        ClusterRandomisedTrialDetail(
            Organisation=org_1,
            Property="N_goalsetting_completers_per_practice",
            PropertyValue="3",
        )
    )

    crt_reference_2 = ClusterRandomisedTrialReference(
        TrialName="coffeeintervention",
    )
    crt_reference_2.ClusterRandomisedTrial.append(
        ClusterRandomisedTrial(
            Organisation=org_1,
            TrialArm="intervention",
        )
    )
    crt_reference_2.ClusterRandomisedTrialDetail.append(
        ClusterRandomisedTrialDetail(
            Organisation=org_1,
            Property="blend",
            PropertyValue="arabica",
        )
    )

    # Add another patient at another organisation. The organisation isn't participating
    # in any RCTs.
    patient_2 = Patient()
    patient_2.RegistrationHistory.append(
        RegistrationHistory(
            StartDate="2019-01-01",
            EndDate="2021-01-01",
            Organisation=Organisation(),
        )
    )

    session.add_all([org_1, patient_1, crt_reference_1, crt_reference_2, patient_2])
    session.commit()

    study = StudyDefinition(
        population=patients.all(),
        is_germdefence=patients.registered_practice_as_of(
            "2020-01-01", returning="rct__germdefence__enrolled"
        ),
        germdefence_trial_arm=patients.registered_practice_as_of(
            "2020-01-01", returning="rct__germdefence__trial_arm"
        ),
        germdefence_deprivation_pctile=patients.registered_practice_as_of(
            "2020-01-01", returning="rct__germdefence__deprivation_pctile"
        ),
        germdefence_intcon=patients.registered_practice_as_of(
            "2020-01-01", returning="rct__germdefence__intcon"
        ),
        germdefence_imd_decile=patients.registered_practice_as_of(
            "2020-01-01", returning="rct__germdefence__imd_decile"
        ),
        germdefence_meanage=patients.registered_practice_as_of(
            "2020-01-01", returning="rct__germdefence__meanage"
        ),
        germdefence_medianage=patients.registered_practice_as_of(
            "2020-01-01", returning="rct__germdefence__medianage"
        ),
        germdefence_rooms=patients.registered_practice_as_of(
            "2020-01-01", returning="rct__germdefence__av_rooms_per_house"
        ),
        germdefence_eth=patients.registered_practice_as_of(
            "2020-01-01", returning="rct__germdefence__minority_ethnic_total"
        ),
        germdefence_n_visits=patients.registered_practice_as_of(
            "2020-01-01", returning="rct__germdefence__n_times_visited_mean"
        ),
        germdefence_n_pages=patients.registered_practice_as_of(
            "2020-01-01", returning="rct__germdefence__n_pages_viewed_mean"
        ),
        germdefence_visit_time_mean=patients.registered_practice_as_of(
            "2020-01-01", returning="rct__germdefence__total_visit_time_mean"
        ),
        germdefence_prop_engaged_visits=patients.registered_practice_as_of(
            "2020-01-01", returning="rct__germdefence__prop_engaged_visits"
        ),
        germdefence_n_engaged_visits=patients.registered_practice_as_of(
            "2020-01-01", returning="rct__germdefence__n_engaged_visits_mean"
        ),
        germdefence_n_engaged_pages=patients.registered_practice_as_of(
            "2020-01-01", returning="rct__germdefence__n_engaged_pages_viewed_mean_mean"
        ),
        germdefence_n_visits_practice=patients.registered_practice_as_of(
            "2020-01-01", returning="rct__germdefence__n_visits_practice"
        ),
        germdefence_group_beh_mean=patients.registered_practice_as_of(
            "2020-01-01", returning="rct__germdefence__group_mean_behaviour_mean"
        ),
        germdefence_int_mean=patients.registered_practice_as_of(
            "2020-01-01", returning="rct__germdefence__group_mean_intention_mean"
        ),
        germdefence_completer_beh=patients.registered_practice_as_of(
            "2020-01-01", returning="rct__germdefence__n_completers_ri_behav"
        ),
        germdefence_completer_intent=patients.registered_practice_as_of(
            "2020-01-01", returning="rct__germdefence__n_completers_ri_intent"
        ),
        germdefence_prop_handwashing_mean=patients.registered_practice_as_of(
            "2020-01-01", returning="rct__germdefence__hand_behav_practice_mean"
        ),
        germdefence_handwashing_intent=patients.registered_practice_as_of(
            "2020-01-01", returning="rct__germdefence__hand_intent_practice_mean"
        ),
        germdefence_hw_beh=patients.registered_practice_as_of(
            "2020-01-01", returning="rct__germdefence__n_completers_hw_behav"
        ),
        germdefence_goal_setters=patients.registered_practice_as_of(
            "2020-01-01",
            returning="rct__germdefence__n_goalsetting_completers_per_practice",
        ),
    )

    assert_results(
        study.to_dicts(),
        is_germdefence=["1", "0"],
        germdefence_trial_arm=["1", ""],
        germdefence_deprivation_pctile=["4", ""],
        germdefence_intcon=["1", ""],
        germdefence_imd_decile=["4", ""],
        germdefence_meanage=["43.8", ""],
        germdefence_medianage=["33.5", ""],
        germdefence_rooms=["6.1", ""],
        germdefence_eth=["9.5", ""],
        germdefence_n_visits=["1.34", ""],
        germdefence_n_pages=["42.2", ""],
        germdefence_visit_time_mean=["320.33", ""],
        germdefence_prop_engaged_visits=["6.5", ""],
        germdefence_n_engaged_visits=["316", ""],
        germdefence_n_engaged_pages=["11.11", ""],
        germdefence_n_visits_practice=["7", ""],
        germdefence_group_beh_mean=["2.64", ""],
        germdefence_int_mean=["3.34", ""],
        germdefence_completer_beh=["1", ""],
        germdefence_completer_intent=["9", ""],
        germdefence_prop_handwashing_mean=["1.5", ""],
        germdefence_handwashing_intent=["4.33", ""],
        germdefence_hw_beh=["11", ""],
        germdefence_goal_setters=["3", ""],
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
        imd=["300", "600", "-1", "-1"],
        rural_urban=["2", "4", "0", "0"],
        msoa=["E02001286", "S02001286", "", ""],
        foo_date=["2020-01-01", "", "", ""],
        msoa_on_foo_date=["E02001286", "", "", ""],
    )


def test_date_window_behaviour_literals():
    session = make_session()
    session.add_all(
        [
            # This patient has event past midnight on end of date window
            Patient(
                CodedEvents=[
                    CodedEvent(CTV3Code="foo1", ConsultationDate="2021-01-01"),
                    CodedEvent(CTV3Code="foo2", ConsultationDate="2021-01-04"),
                    CodedEvent(CTV3Code="foo3", ConsultationDate="2021-01-04T10:45:00"),
                    CodedEvent(CTV3Code="foo2", ConsultationDate="2021-01-01T16:10:00"),
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
    study = StudyDefinition(
        population=patients.all(),
        event_count=patients.with_these_clinical_events(
            foo_codes,
            between=["2021-01-01", "2021-01-04"],
            returning="number_of_matches_in_period",
        ),
    )
    results = study.to_dicts()
    event_count = 4 if flags.WITH_END_DATE_FIX else 2
    assert [i["event_count"] for i in results] == [f"{event_count}", "0"]


def test_date_window_behaviour_variable():
    session = make_session()
    session.add_all(
        [
            # This patient has event past midnight on end of date window
            Patient(
                CodedEvents=[
                    CodedEvent(CTV3Code="foo1", ConsultationDate="2021-01-01"),
                    CodedEvent(CTV3Code="foo2", ConsultationDate="2021-01-01T16:10:00"),
                    CodedEvent(CTV3Code="bar1", ConsultationDate="2021-01-01"),
                    CodedEvent(CTV3Code="bar2", ConsultationDate="2021-01-01T16:10:00"),
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
    bar_codes = codelist(["bar1", "bar2", "bar3"], "ctv3")
    study = StudyDefinition(
        population=patients.all(),
        first_bar=patients.with_these_clinical_events(
            bar_codes,
            on_or_after="2021-01-01",
            returning="date",
            date_format="YYYY-MM-DD",
            find_first_match_in_period=True,
        ),
        event_count=patients.with_these_clinical_events(
            foo_codes,
            between=["first_bar", "first_bar"],
            returning="number_of_matches_in_period",
        ),
    )
    results = study.to_dicts()
    event_count = 2 if flags.WITH_END_DATE_FIX else 1
    assert [i["event_count"] for i in results] == [f"{event_count}", "0"]


def test_index_of_multiple_deprivation():
    session = make_session()
    session.add_all(
        [
            Patient(
                Addresses=[
                    PatientAddress(
                        StartDate="1990-01-01",
                        EndDate="9999-12-31",
                        ImdRankRounded=0,
                    ),
                ],
            ),
            Patient(
                Addresses=[
                    PatientAddress(
                        StartDate="1990-01-01",
                        EndDate="9999-12-31",
                        ImdRankRounded=1500,
                    ),
                ],
            ),
            Patient(
                Addresses=[
                    PatientAddress(
                        StartDate="1990-01-01",
                        EndDate="9999-12-31",
                        ImdRankRounded=2500,
                    ),
                ],
            ),
            # IMD explictly recorded as missing
            Patient(
                Addresses=[
                    PatientAddress(
                        StartDate="1990-01-01",
                        EndDate="9999-12-31",
                        ImdRankRounded=-1,
                    ),
                ],
            ),
            # No address record
            Patient(),
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
        imd_bucket=patients.categorised_as(
            {
                "low": "imd >= 0 AND imd < 1000",
                "medium": "imd >= 1000 AND imd < 2000",
                "high": "imd >= 2000",
                "unknown": "DEFAULT",
            }
        ),
    )
    assert_results(
        study.to_dicts(),
        imd=["0", "1500", "2500", "-1", "-1"],
        imd_bucket=["low", "medium", "high", "unknown", "unknown"],
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
            ONSDeaths(
                Patient=Patient(),
                dod="2021-01-01",
                icd10u=code,
                Place_of_occurrence="Home",
            ),
            # Died of something else
            ONSDeaths(
                Patient=Patient(),
                dod="2020-02-01",
                icd10u="MI",
                Place_of_occurrence="Hospital",
            ),
            # Covid underlying cause
            ONSDeaths(
                Patient=patient_with_dupe,
                dod="2020-02-01",
                icd10u=code,
                ICD10014="MI",
                Place_of_occurrence="Hospice",
            ),
            # A duplicate (the raw data does contain exact dupes, unfortunately)
            ONSDeaths(
                Patient=patient_with_dupe,
                dod="2020-02-01",
                icd10u=code,
                ICD10014="MI",
                Place_of_occurrence="Hospice",
            ),
            # A duplicate with a different date of death (which now we have to handle)
            ONSDeaths(
                Patient=patient_with_dupe,
                dod="2020-02-02",
                icd10u=code,
                ICD10014="MI",
                Place_of_occurrence="Hospice",
            ),
            # A duplicate with a different date of death (which now we have to handle)
            ONSDeaths(
                Patient=patient_with_dupe,
                dod="2020-02-02",
                icd10u=code,
                ICD10014="MI",
                Place_of_occurrence="Hospice",
            ),
            # A duplicate with a different place of death (which now we have to handle)
            ONSDeaths(
                Patient=patient_with_dupe,
                dod="2020-02-02",
                icd10u=code,
                ICD10014="MI",
                Place_of_occurrence="Elsewhere",
            ),
            # A duplicate with a different underlying CoD (which now we have to handle)
            ONSDeaths(
                Patient=patient_with_dupe,
                dod="2020-02-02",
                icd10u="MI",
                ICD10014="COVID",
                Place_of_occurrence="Hospice",
            ),
            # Covid not underlying cause
            ONSDeaths(
                Patient=Patient(),
                dod="2020-03-01",
                icd10u="MI",
                ICD10014=code,
                Place_of_occurrence="Care home",
            ),
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
        place_of_death=patients.with_these_codes_on_death_certificate(
            covid_codelist,
            on_or_before="2020-06-01",
            match_only_underlying_cause=False,
            returning="place_of_death",
        ),
    )
    results = study.to_dicts()
    assert [i["died_of_covid"] for i in results] == ["0", "0", "0", "1", "0"]
    assert [i["died_with_covid"] for i in results] == ["0", "0", "0", "1", "1"]
    assert [i["date_died"] for i in results] == ["", "", "", "2020-02-01", "2020-03-01"]
    assert [i["underlying_cause"] for i in results] == ["", "", "", code, "MI"]
    assert [i["place_of_death"] for i in results] == [
        "",
        "",
        "",
        "Elsewhere",
        "Care home",
    ]


def test_patients_died_from_any_cause():
    session = make_session()
    session.add_all(
        [
            # Not dead
            Patient(),
            # Died after date cutoff
            Patient(ONSDeath=[ONSDeaths(dod="2021-01-01", Place_of_occurrence="Home")]),
            # Died
            Patient(
                ONSDeath=[
                    ONSDeaths(
                        dod="2020-02-01", icd10u="A", Place_of_occurrence="Hospice"
                    )
                ]
            ),
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
        place_of_death=patients.died_from_any_cause(
            on_or_before="2020-06-01",
            returning="place_of_death",
        ),
    )
    results = study.to_dicts()
    assert [i["died"] for i in results] == ["0", "0", "1"]
    assert [i["date_died"] for i in results] == ["", "", "2020-02-01"]
    assert [i["underlying_cause"] for i in results] == ["", "", "A"]
    assert [i["place_of_death"] for i in results] == ["", "", "Hospice"]


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
    assert escape_like_query_fragment("foo%bar_") == "foo!%bar!_"


def test_escape_like_query_fragment_against_db():
    session = make_session()
    cases = [
        ("foobar", "ob", True),
        ("foo[]!%_^bar", "o[]!%_^b", True),
        ("foobar", "f%r", False),
    ]
    for text, pattern, should_match in cases:
        like_pattern = f"%{escape_like_query_fragment(pattern)}%"
        result = session.execute(
            f"SELECT value FROM"
            f"  (VALUES({quote(text)})) AS t(value)"
            f"  WHERE value LIKE {quote(like_pattern)} ESCAPE '!'"
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
                        Symptomatic="Y",
                    ),
                    SGSS_AllTests_Positive(Specimen_Date="2020-05-20", SGTF="1"),
                ],
                SGSS_AllTests_Negatives=[
                    SGSS_AllTests_Negative(
                        Specimen_Date="2020-05-02", Symptomatic="false"
                    ),
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
                    SGSS_AllTests_Negative(
                        Specimen_Date="2020-04-01",
                        Symptomatic="false",
                    ),
                ],
                SGSS_AllTests_Positives=[
                    SGSS_AllTests_Positive(
                        Specimen_Date="2020-04-20",
                        Variant="VOC-20DEC-01 detected",
                        VariantDetectionMethod="Reflex Assay",
                        Symptomatic="N",
                    ),
                    SGSS_AllTests_Positive(Specimen_Date="2020-05-02", SGTF="9"),
                ],
            ),
            Patient(
                SGSS_Negatives=[SGSS_Negative(Earliest_Specimen_Date="2020-04-01")],
                SGSS_AllTests_Negatives=[
                    SGSS_AllTests_Negative(Specimen_Date="2020-04-01")
                ],
            ),
            Patient(
                SGSS_Negatives=[SGSS_Negative(Earliest_Specimen_Date="2020-04-01")],
                SGSS_Positives=[SGSS_Positive(Earliest_Specimen_Date="2020-04-20")],
                SGSS_AllTests_Negatives=[
                    SGSS_AllTests_Negative(
                        Specimen_Date="2020-04-01",
                    ),
                ],
                SGSS_AllTests_Positives=[
                    SGSS_AllTests_Positive(
                        Specimen_Date="2020-04-20",
                        Symptomatic="U",
                        SGTF="0",
                    ),
                ],
            ),
            Patient(
                SGSS_Negatives=[SGSS_Negative(Earliest_Specimen_Date="2020-04-01")],
                SGSS_AllTests_Negatives=[
                    SGSS_AllTests_Negative(
                        Specimen_Date="2020-04-01",
                        Symptomatic="true",
                    )
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
        sgtf_result_last=patients.with_test_result_in_sgss(
            pathogen="SARS-CoV-2",
            test_result="positive",
            find_last_match_in_period=True,
            restrict_to_earliest_specimen_date=False,
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
        symptomatic_positive=patients.with_test_result_in_sgss(
            pathogen="SARS-CoV-2",
            test_result="positive",
            find_first_match_in_period=True,
            restrict_to_earliest_specimen_date=False,
            returning="symptomatic",
        ),
        symptomatic_negative=patients.with_test_result_in_sgss(
            pathogen="SARS-CoV-2",
            test_result="negative",
            find_first_match_in_period=True,
            restrict_to_earliest_specimen_date=False,
            returning="symptomatic",
        ),
        symptomatic_any=patients.with_test_result_in_sgss(
            pathogen="SARS-CoV-2",
            test_result="any",
            find_first_match_in_period=True,
            restrict_to_earliest_specimen_date=False,
            returning="symptomatic",
        ),
        number_of_neg_sgss_tests=patients.with_test_result_in_sgss(
            pathogen="SARS-CoV-2",
            test_result="negative",
            restrict_to_earliest_specimen_date=False,
            returning="number_of_matches_in_period",
        ),
        number_of_pos_sgss_tests=patients.with_test_result_in_sgss(
            pathogen="SARS-CoV-2",
            test_result="positive",
            restrict_to_earliest_specimen_date=False,
            returning="number_of_matches_in_period",
        ),
        number_of_all_sgss_tests=patients.with_test_result_in_sgss(
            pathogen="SARS-CoV-2",
            test_result="any",
            restrict_to_earliest_specimen_date=False,
            returning="number_of_matches_in_period",
        ),
        number_of_all_sgss_tests_before_may=patients.with_test_result_in_sgss(
            pathogen="SARS-CoV-2",
            test_result="any",
            on_or_before="2020-05-01",
            restrict_to_earliest_specimen_date=False,
            returning="number_of_matches_in_period",
        ),
    )
    assert_results(
        study.to_dicts(),
        positive_covid_test_ever=["1", "1", "0", "1", "0", "0"],
        negative_covid_test_ever=["1", "1", "1", "1", "1", "0"],
        tested_before_may=["0", "1", "1", "1", "1", "0"],
        first_positive_test_date=[
            "2020-05-15",
            "2020-04-20",
            "",
            "2020-04-20",
            "",
            "",
        ],
        case_category=["PCR_Only", "LFT_WithPCR", "", "", "", ""],
        first_negative_after_a_positive=["2020-07-10", "", "", "", "", ""],
        last_positive_test_date=["2020-05-20", "2020-05-02", "", "2020-04-20", "", ""],
        sgtf_result=["9", "1", "", "", "", ""],
        sgtf_result_last=["1", "9", "", "0", "", ""],
        variant=["B.1.351", "VOC-20DEC-01", "", "", "", ""],
        variant_detection_method=[
            "Private Lab Sequencing",
            "Reflex Assay",
            "",
            "",
            "",
            "",
        ],
        symptomatic_positive=["Y", "N", "", "", "", ""],
        symptomatic_negative=["N", "N", "", "", "Y", ""],
        symptomatic_any=["N", "N", "", "", "Y", ""],
        number_of_neg_sgss_tests=["2", "1", "1", "1", "1", "0"],
        number_of_pos_sgss_tests=["2", "2", "0", "1", "0", "0"],
        number_of_all_sgss_tests=["4", "3", "1", "2", "1", "0"],
        number_of_all_sgss_tests_before_may=["0", "2", "1", "2", "1", "0"],
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
        abc_date=patients.date_of("abc_value", date_format="YYYY-MM-DD"),
        xyz_date=patients.date_of("xyz_value", date_format="YYYY-MM-DD"),
        # Aggregates
        max_value=patients.maximum_of("abc_value", "xyz_value"),
        min_value=patients.minimum_of("abc_value", "xyz_value"),
        max_date=patients.maximum_of("abc_date", "xyz_date"),
        min_date=patients.minimum_of("abc_date", "xyz_date"),
        # Aggregates with fixed dates
        max_date_fixed=patients.maximum_of("abc_date", "2014-05-16"),
        min_date_fixed=patients.minimum_of("xyz_date", "2017-11-10"),
    )
    results = study.to_dicts()
    assert [x["max_value"] for x in results] == ["23.0", "18.0", "10.0", "8.0", "0.0"]
    assert [x["min_value"] for x in results] == ["7.0", "4.0", "10.0", "8.0", "0.0"]
    assert [x["max_date"] for x in results] == [
        "2018-01-01",
        "2017-01-01",
        "2015-01-01",
        "2019-01-01",
        "",
    ]
    assert [x["min_date"] for x in results] == [
        "2012-01-01",
        "2014-01-01",
        "2015-01-01",
        "2019-01-01",
        "",
    ]
    assert [x["max_date_fixed"] for x in results] == [
        "2014-05-16",
        "2014-05-16",
        "2015-01-01",
        "2014-05-16",
        "2014-05-16",
    ]
    assert [x["min_date_fixed"] for x in results] == [
        "2017-11-10",
        "2017-01-01",
        "2017-11-10",
        "2017-11-10",
        "2017-11-10",
    ]
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
                        Der_Spell_LoS="2",
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
                        Der_Spell_LoS="2",
                        APCS_Der=APCS_Der(
                            Patient_ID=3,
                            Spell_Primary_Diagnosis="BBBB",
                            Spell_PbR_CC_Day="4",
                        ),
                        Der_Admit_Treatment_Function_Code="123",
                    ),
                    APCS(
                        APCS_Ident=3,
                        Admission_Date="2020-03-01",
                        Discharge_Date="2020-04-01",
                        Der_Diagnosis_All="||CCCC ,XXXC, XXXD",
                        Der_Procedure_All="||CCCC ,YYYC, YYYD",
                        Der_Spell_LoS="2",
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
                        Der_Spell_LoS="2",
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
                        Der_Spell_LoS="2",
                        APCS_Der=APCS_Der(
                            Patient_ID=4,
                            Spell_Primary_Diagnosis="EEEE",
                            Spell_PbR_CC_Day="3",
                        ),
                    ),
                    # duplicate admission date; count only the longest stay
                    APCS(
                        APCS_Ident=6,
                        Admission_Date="2020-07-01",
                        Discharge_Date="2020-08-01",
                        Der_Diagnosis_All="||FFFF ,XXXF, XXXG",
                        Der_Procedure_All="||FFFF ,YYYF, YYYG",
                        Der_Spell_LoS="2",
                        APCS_Der=APCS_Der(
                            Patient_ID=4,
                            Spell_Primary_Diagnosis="FFFF",
                            Spell_PbR_CC_Day="1",
                        ),
                    ),
                    APCS(
                        APCS_Ident=7,
                        Admission_Date="2020-07-01",
                        Discharge_Date="2020-07-02",
                        Der_Diagnosis_All="||FFFF ,XXXF, XXXG",
                        Der_Procedure_All="||FFFF ,YYYF, YYYG",
                        Der_Spell_LoS="1",
                        APCS_Der=APCS_Der(
                            Patient_ID=4,
                            Spell_Primary_Diagnosis="FFFF",
                        ),
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
        total_bed_days=patients.admitted_to_hospital(
            on_or_after="2020-02-01",
            returning="total_bed_days_in_period",
        ),
        total_bed_days_with_primary_diagnoses=patients.admitted_to_hospital(
            on_or_after="2020-01-01",
            with_these_primary_diagnoses=codelist(["AAA"], "icd10"),
            returning="total_bed_days_in_period",
        ),
        total_critical_care_days=patients.admitted_to_hospital(
            on_or_after="2020-02-01",
            returning="total_critical_care_days_in_period",
        ),
        total_critical_care_days_with_primary_diagnoses=patients.admitted_to_hospital(
            on_or_after="2020-01-01",
            with_these_primary_diagnoses=codelist(["AAA"], "icd10"),
            returning="total_critical_care_days_in_period",
        ),
        with_treatment_admission_function_code=patients.admitted_to_hospital(
            with_admission_treatment_function_code="123",
            returning="binary_flag",
        ),
    )

    assert_results(
        study.to_dicts(),
        admitted=["0", "0", "1", "1"],
        count=["0", "0", "1", "4"],
        first_date_admitted=["", "", "2020-03-01", "2020-03-01"],
        last_date_admitted=["", "", "2020-03-01", "2020-07-01"],
        first_date_discharged=["", "", "2020-04-01", "2020-04-01"],
        last_date_discharged=["", "", "2020-04-01", "2020-08-01"],
        with_particular_primary_diagnosis=["0", "0", "0", "1"],
        with_particular_diagnoses_1=["0", "0", "1", "1"],
        with_particular_diagnoses_2=["0", "0", "0", "2"],
        with_particular_diagnoses_3=["0", "0", "1", "4"],
        with_particular_diagnoses_4=["0", "0", "1", "2"],
        with_particular_procedures=["0", "0", "1", "2"],
        first_primary_diagnosis=["", "", "CCCC", "DDDD"],
        last_primary_diagnosis=["", "", "CCCC", "FFFF"],
        discharge_dest=["", "11", "99", ""],
        critical_care_days=["", "3", "", "5"],
        primary_diagnosis_prefix=["0", "1", "0", "0"],
        total_bed_days=["0", "0", "3", "9"],
        total_bed_days_with_primary_diagnoses=["0", "3", "0", "0"],
        total_critical_care_days=["0", "0", "0", "9"],
        total_critical_care_days_with_primary_diagnoses=["0", "3", "0", "0"],
        with_treatment_admission_function_code=["0", "0", "1", "0"],
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
                    CodedEvent(ConsultationDate="2020-01-15", CTV3Code="foo"),
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
        earliest_foo=patients.with_these_clinical_events(
            codelist(["foo"], system="ctv3"),
            returning="date",
            date_format="YYYY-MM-DD",
            find_first_match_in_period=True,
        ),
        earliest_bar=patients.with_these_clinical_events(
            codelist(["bar"], system="ctv3"),
            returning="date",
            date_format="YYYY-MM-DD",
            find_first_match_in_period=True,
        ),
        earliest_foo_or_bar=patients.minimum_of("earliest_foo", "earliest_bar"),
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
        positive_test_after_foo_or_bar=patients.with_test_result_in_sgss(
            pathogen="SARS-CoV-2",
            test_result="positive",
            on_or_after="earliest_foo_or_bar + 1 day",
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
        earliest_foo=["2020-01-15"],
        earliest_bar=["2020-03-01"],
        earliest_foo_or_bar=["2020-01-15"],
        latest_foo_before_bar=["2020-02-01"],
        latest_foo_in_month_after_bar=["2020-04-20"],
        positive_test_after_foo_or_bar=["2020-05-01"],
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


@pytest.mark.parametrize(
    "index_date,expected_patient_ids",
    [
        ("2020-02-15", ["2", "3"]),  # nhs financial year 2019-04-01 to 2020-03-31
        ("2017-05-15", ["4", "5"]),  # nhs financial year 2017-04-01 to 2018-03-31
    ],
)
def test_nhs_financial_year_date_expressions(index_date, expected_patient_ids):
    session = make_session()
    session.add_all(
        [
            # Event too early
            Patient(
                Patient_ID=1,
                DateOfBirth="1980-01-01",
                CodedEvents=[CodedEvent(ConsultationDate="2012-12-15", CTV3Code="foo")],
            ),
            # Events in range 2019-04-01 to 2020-03-31
            Patient(
                Patient_ID=2,
                DateOfBirth="1980-05-01",
                CodedEvents=[CodedEvent(ConsultationDate="2019-05-01", CTV3Code="foo")],
            ),
            Patient(
                Patient_ID=3,
                DateOfBirth="1980-05-01",
                CodedEvents=[CodedEvent(ConsultationDate="2020-02-15", CTV3Code="foo")],
            ),
            # Events in range 2017-04-01 to 2018-03-31
            Patient(
                Patient_ID=4,
                DateOfBirth="1980-07-01",
                CodedEvents=[CodedEvent(ConsultationDate="2018-02-01", CTV3Code="foo")],
            ),
            Patient(
                Patient_ID=5,
                DateOfBirth="1980-07-01",
                CodedEvents=[CodedEvent(ConsultationDate="2017-06-01", CTV3Code="foo")],
            ),
            # Events out of range (at beginning/end of adjacent financial years)
            Patient(
                Patient_ID=6,
                DateOfBirth="1980-01-01",
                CodedEvents=[CodedEvent(ConsultationDate="2017-03-31", CTV3Code="foo")],
            ),
            Patient(
                Patient_ID=7,
                DateOfBirth="1980-01-01",
                CodedEvents=[CodedEvent(ConsultationDate="2018-04-01", CTV3Code="foo")],
            ),
            Patient(
                Patient_ID=8,
                DateOfBirth="1980-01-01",
                CodedEvents=[CodedEvent(ConsultationDate="2019-03-31", CTV3Code="foo")],
            ),
            Patient(
                Patient_ID=9,
                DateOfBirth="1980-01-01",
                CodedEvents=[CodedEvent(ConsultationDate="2020-04-01", CTV3Code="foo")],
            ),
        ]
    )
    session.commit()
    study = StudyDefinition(
        index_date=index_date,
        population=patients.with_these_clinical_events(
            codelist(["foo"], system="ctv3"),
            between=[
                "first_day_of_nhs_financial_year(index_date)",
                "last_day_of_nhs_financial_year(index_date)",
            ],
        ),
    )
    results = study.to_dicts()
    assert_results(results, patient_id=expected_patient_ids)


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


def test_with_healthcare_worker_flag_on_covid_vaccine_record():
    session = make_session()
    session.add_all(
        [
            Patient(HealthCareWorker=[HealthCareWorker(HealthCareWorker="Y")]),
            Patient(
                HealthCareWorker=[
                    HealthCareWorker(HealthCareWorker="Y"),
                    HealthCareWorker(HealthCareWorker="Y"),
                ]
            ),
            Patient(HealthCareWorker=[HealthCareWorker(HealthCareWorker="N")]),
            Patient(),
        ]
    )
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        hcw=patients.with_healthcare_worker_flag_on_covid_vaccine_record(),
    )
    assert_results(study.to_dicts(), hcw=["1", "1", "0", "0"])


def _make_patient_with_outpatient_appointment():
    """Makes patients with Outpatient Appointments"""
    session = make_session()
    session.add_all(
        [
            Patient(
                OPAEpisodes=[
                    OPA(
                        Appointment_Date="2021-01-01 12:00:00.000",
                        Attendance_Status="6",
                        First_Attendance="1",
                        Treatment_Function_Code="130",
                        Consultation_Medium_Used="10",
                    ),
                ]
            ),
            Patient(
                OPAEpisodes=[
                    OPA(
                        Appointment_Date="2021-01-01 12:00:00.000",
                        Attendance_Status="7",
                        First_Attendance="4",
                        Treatment_Function_Code="180",
                        Consultation_Medium_Used="20",
                    ),
                    OPA(
                        Appointment_Date="2021-01-02 12:00:00.000",
                        Attendance_Status="5",
                        First_Attendance="2",
                        Treatment_Function_Code="812",
                        OPA_Proc=[OPA_Proc(Primary_Procedure_Code="S603")],
                        Consultation_Medium_Used="30",
                    ),
                ]
            ),
            Patient(
                OPAEpisodes=[
                    OPA(
                        Appointment_Date="2021-01-02 12:00:00.000",
                        Ethnic_Category="GF",
                        Attendance_Status="3",
                        First_Attendance="3",
                        Treatment_Function_Code="180",
                        OPA_Proc=[OPA_Proc(Primary_Procedure_Code="D071")],
                        Consultation_Medium_Used="40",
                    ),
                    OPA(
                        Appointment_Date="2021-01-03 12:00:00.000",
                        Ethnic_Category="GF",
                        First_Attendance="4",
                        Treatment_Function_Code="320",
                        Consultation_Medium_Used="50",
                    ),
                ],
            ),
            Patient(),
        ]
    )
    session.commit()


def test_outpatient_appointment_date_returning_binary_flag():
    _make_patient_with_outpatient_appointment()

    study = StudyDefinition(
        population=patients.all(),
        opa=patients.outpatient_appointment_date(returning="binary_flag"),
    )
    assert_results(study.to_dicts(), opa=["1", "1", "1", "0"])


def test_outpatient_appointment_date_returning_binary_flag_on_or_after():
    _make_patient_with_outpatient_appointment()

    study = StudyDefinition(
        population=patients.all(),
        opa=patients.outpatient_appointment_date(
            returning="binary_flag", on_or_after="2021-01-02"
        ),
    )
    assert_results(study.to_dicts(), opa=["0", "1", "1", "0"])


def test_outpatient_appointment_date_returning_binary_flag_attended():
    _make_patient_with_outpatient_appointment()

    study = StudyDefinition(
        population=patients.all(),
        opa=patients.outpatient_appointment_date(
            returning="binary_flag", attended=True
        ),
    )
    assert_results(study.to_dicts(), opa=["1", "1", "0", "0"])


def test_outpatient_appointment_date_returning_binary_flag_first_attendance():
    _make_patient_with_outpatient_appointment()

    study = StudyDefinition(
        population=patients.all(),
        opa=patients.outpatient_appointment_date(
            returning="binary_flag", is_first_attendance=True
        ),
    )
    assert_results(study.to_dicts(), opa=["1", "0", "1", "0"])


def test_outpatient_appointment_date_returning_binary_flag_with_these_treatment_function_codes():
    _make_patient_with_outpatient_appointment()

    study = StudyDefinition(
        population=patients.all(),
        opa=patients.outpatient_appointment_date(
            returning="binary_flag", with_these_treatment_function_codes=["812", "813"]
        ),
        # we can match a single code, provided as a string
        opa1=patients.outpatient_appointment_date(
            returning="binary_flag", with_these_treatment_function_codes="812"
        ),
    )
    assert_results(
        study.to_dicts(), opa=["0", "1", "0", "0"], opa1=["0", "1", "0", "0"]
    )


def test_outpatient_appointment_date_returning_binary_flag_with_these_procedure_codes_exact():
    _make_patient_with_outpatient_appointment()

    procedures_codelist = codelist(["D071", "F172"], system="opcs4")
    study = StudyDefinition(
        population=patients.all(),
        opa=patients.outpatient_appointment_date(
            returning="binary_flag", with_these_procedures=procedures_codelist
        ),
    )
    assert_results(study.to_dicts(), opa=["0", "0", "1", "0"])


def test_outpatient_appointment_date_returning_binary_flag_with_these_procedure_codes_like():
    _make_patient_with_outpatient_appointment()

    procedures_codelist = codelist(["D07", "F17"], system="opcs4")
    study = StudyDefinition(
        population=patients.all(),
        opa=patients.outpatient_appointment_date(
            returning="binary_flag", with_these_procedures=procedures_codelist
        ),
    )
    assert_results(study.to_dicts(), opa=["0", "0", "1", "0"])


def test_outpatient_appointment_date_returning_dates():
    _make_patient_with_outpatient_appointment()

    study = StudyDefinition(
        population=patients.all(),
        opa=patients.outpatient_appointment_date(returning="date"),
    )
    assert_results(study.to_dicts(), opa=["2021-01-01", "2021-01-02", "2021-01-03", ""])


def test_outpatient_appointment_date_returning_dates_first_match():
    _make_patient_with_outpatient_appointment()

    study = StudyDefinition(
        population=patients.all(),
        opa=patients.outpatient_appointment_date(
            returning="date", find_first_match_in_period=True
        ),
    )
    assert_results(study.to_dicts(), opa=["2021-01-01", "2021-01-01", "2021-01-02", ""])


def test_outpatient_appointment_date_returning_dates_formatted():
    _make_patient_with_outpatient_appointment()

    study = StudyDefinition(
        population=patients.all(),
        opa=patients.outpatient_appointment_date(
            returning="date", date_format="YYYY-MM"
        ),
    )
    assert_results(study.to_dicts(), opa=["2021-01", "2021-01", "2021-01", ""])


def test_outpatient_appointment_date_returning_number_of_matches_in_period():
    _make_patient_with_outpatient_appointment()

    study = StudyDefinition(
        population=patients.all(),
        opa=patients.outpatient_appointment_date(
            returning="number_of_matches_in_period"
        ),
    )
    assert_results(study.to_dicts(), opa=["1", "2", "2", "0"])


def test_outpatient_appointment_date_returning_consultation_medium_used():
    _make_patient_with_outpatient_appointment()

    study = StudyDefinition(
        population=patients.all(),
        opa=patients.outpatient_appointment_date(
            returning="consultation_medium_used", find_first_match_in_period=True
        ),
    )
    assert_results(study.to_dicts(), opa=["10", "20", "40", ""])


def test_outpatient_appointment_date_returning_consultation_medium_used_last_match():
    _make_patient_with_outpatient_appointment()

    study = StudyDefinition(
        population=patients.all(),
        opa=patients.outpatient_appointment_date(returning="consultation_medium_used"),
    )
    assert_results(study.to_dicts(), opa=["10", "30", "50", ""])


@pytest.fixture
def patient_ids():
    session = make_session()
    patient_instances = [Patient(), Patient()]
    session.add_all(patient_instances)
    session.commit()
    return [x.Patient_ID for x in patient_instances]


def _to_csv(records, tmp_path):
    f_path = str(tmp_path / "records.csv")
    pandas.DataFrame(records).to_csv(f_path, index=False)
    return f_path


def test_with_bool_value_from_file(patient_ids, tmp_path):
    f_path = _to_csv(
        [{"patient_id": patient_ids[0], "has_asthma": 1}],
        tmp_path,
    )
    study = StudyDefinition(
        population=patients.all(),
        case_has_asthma=patients.with_value_from_file(
            f_path, returning="has_asthma", returning_type="bool"
        ),
    )
    assert_results(study.to_dicts(), case_has_asthma=["1", "0"])  # zero-as-null


def test_with_date_value_from_file(patient_ids, tmp_path):
    f_path = _to_csv(
        [{"patient_id": patient_ids[0], "index_date": "2021-01-01"}],
        tmp_path,
    )
    study = StudyDefinition(
        population=patients.all(),
        case_index_date=patients.with_value_from_file(
            f_path, returning="index_date", returning_type="date"
        ),
    )
    assert_results(study.to_dicts(), case_index_date=["2021-01-01", ""])


def test_with_str_value_from_file(patient_ids, tmp_path):
    f_path = _to_csv(
        [{"patient_id": patient_ids[0], "nuts1_region_name": "North East"}],
        tmp_path,
    )
    study = StudyDefinition(
        population=patients.all(),
        case_nuts1_region_name=patients.with_value_from_file(
            f_path, returning="nuts1_region_name", returning_type="str"
        ),
    )
    assert_results(study.to_dicts(), case_nuts1_region_name=["North East", ""])


def test_with_int_value_from_file(patient_ids, tmp_path):
    f_path = _to_csv([{"patient_id": patient_ids[0], "age": 21}], tmp_path)
    study = StudyDefinition(
        population=patients.all(),
        case_age=patients.with_value_from_file(
            f_path, returning="age", returning_type="int"
        ),
    )
    assert_results(study.to_dicts(), case_age=["21", "0"])


def test_with_float_value_from_file(patient_ids, tmp_path):
    f_path = _to_csv([{"patient_id": patient_ids[0], "bmi": 18.5}], tmp_path)
    study = StudyDefinition(
        population=patients.all(),
        case_bmi=patients.with_value_from_file(
            f_path, returning="bmi", returning_type="float"
        ),
    )
    assert_results(study.to_dicts(), case_bmi=["18.5", "0.0"])


def test_with_value_from_file_with_unexpected_file_type():
    with pytest.raises(TypeError):
        StudyDefinition(
            population=patients.all(),
            case_bmi=patients.with_value_from_file(
                "records.feather", returning="bmi", returning_type="float"
            ),
        )


def test_with_value_from_file_with_missing_returning_arg():
    with pytest.raises(TypeError):
        StudyDefinition(
            population=patients.all(),
            case_bmi=patients.with_value_from_file(
                "records.csv", returning=None, returning_type="float"
            ),
        )


def test_with_value_from_file_with_invalid_returning_arg():
    with pytest.raises(ValueError):
        StudyDefinition(
            population=patients.all(),
            case_bmi=patients.with_value_from_file(
                "records.csv", returning="bmi-value", returning_type="float"
            ),
        )


def test_with_value_from_file_with_value_as_returning_arg(patient_ids, tmp_path):
    # Test that when the returning argument is "value", cells from the this
    # column are inserted into the database.
    f_path = _to_csv(
        [{"patient_id": patient_ids[0], "value": "North East"}],
        tmp_path,
    )
    study = StudyDefinition(
        population=patients.all(),
        case_nuts1_region_name=patients.with_value_from_file(
            f_path, returning="value", returning_type="str"
        ),
    )
    assert_results(study.to_dicts(), case_nuts1_region_name=["North East", ""])


def test_patients_which_exist_in_file(patient_ids, tmp_path):
    f_path = _to_csv([{"patient_id": patient_ids[0]}], tmp_path)
    study = StudyDefinition(population=patients.which_exist_in_file(f_path))
    assert_results(study.to_dicts(), patient_id=[str(patient_ids[0])])


def test_using_dates_as_categories():
    def make_events():
        return [
            CodedEvent(CTV3Code="foo", ConsultationDate="2020-05-15"),
            CodedEvent(CTV3Code="foo", ConsultationDate="2020-07-17"),
            CodedEvent(CTV3Code="foo", ConsultationDate="2020-09-19"),
        ]

    session = make_session()
    session.add_all(
        [
            Patient(DateOfBirth="1930-01-01", CodedEvents=make_events()),
            Patient(DateOfBirth="1945-01-01", CodedEvents=make_events()),
            Patient(DateOfBirth="1980-01-01", CodedEvents=make_events()),
        ]
    )
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        eligible_date=patients.categorised_as(
            {
                "2020-04-14": "age >= 80",
                "2020-06-16": "age >= 70 AND age < 80",
                "2020-08-18": "DEFAULT",
            },
            age=patients.age_as_of("2020-01-01"),
        ),
        first_event_after_eligible=patients.with_these_clinical_events(
            codelist(["foo"], system="ctv3"),
            on_or_after="eligible_date",
            find_first_match_in_period=True,
            returning="date",
            date_format="YYYY-MM-DD",
        ),
    )
    assert_results(
        study.to_dicts(),
        eligible_date=["2020-04-14", "2020-06-16", "2020-08-18"],
        first_event_after_eligible=["2020-05-15", "2020-07-17", "2020-09-19"],
    )


def test_coded_events_reference_ranges():
    code = "foo1"
    session = make_session()
    session.add_all(
        [
            Patient(
                CodedEvents=[
                    CodedEvent(
                        CTV3Code=code,
                        NumericValue=5.0,
                        CodedEventRange=[
                            CodedEventRange(
                                LowerBound=3.0,
                                UpperBound=8.0,
                                Comparator=5,
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
        test_result=patients.with_these_clinical_events(
            codelist([code], system="ctv3"),
            returning="numeric_value",
            find_first_match_in_period=True,
        ),
        comparator=patients.comparator_from("test_result"),
        ref_range_lower=patients.reference_range_lower_bound_from("test_result"),
        ref_range_upper=patients.reference_range_upper_bound_from("test_result"),
    )

    assert_results(
        study.to_dicts(),
        test_result=["5.0"],
        comparator=[">="],
        ref_range_lower=["3.0"],
        ref_range_upper=["8.0"],
    )


def test_with_covid_therapeutics():
    session = make_session()
    session.add_all(
        [
            Patient(
                Therapeutics=[
                    Therapeutics(
                        Intervention="Casirivimab and imdevimab ",
                        COVID_indication="non_hospitalised",
                        CurrentStatus="Approved",
                        TreatmentStartDate="2021-12-10 00:00:00.000",
                        Received="2021-12-10 00:00:00.000",
                        MOL1_high_risk_cohort="",
                        SOT02_risk_cohorts=None,
                        CASIM05_risk_cohort="solid cancer",
                        Region="South West",
                    ),
                    Therapeutics(
                        Intervention="Molnupiravir",
                        COVID_indication="hospitalised_with",
                        CurrentStatus="Approved",
                        TreatmentStartDate="2021-12-14 00:00:00.000",
                        Received="2021-12-14 00:00:00.000",
                        MOL1_high_risk_cohort="IMID",
                        Region="North",
                    ),
                    # not started
                    Therapeutics(
                        Intervention="Remdesivir",
                        COVID_indication="non_hospitalised",
                        CurrentStatus="Treatment Not Started",
                        TreatmentStartDate="2021-12-13 00:00:00.000",
                        Received="2021-12-13 00:00:00.000",
                        MOL1_high_risk_cohort="cancer",
                        Region="London",
                    ),
                ],
            ),
            Patient(
                Therapeutics=[
                    Therapeutics(
                        Intervention="Remdesivir",
                        COVID_indication="non_hospitalised",
                        CurrentStatus="Approved",
                        TreatmentStartDate="2021-12-09 00:00:00.000",
                        Received="2021-12-09 00:00:00.000",
                        MOL1_high_risk_cohort="Patients with Liver disease",
                        SOT02_risk_cohorts="solid cancer and an unknown group that will be replaced",
                        CASIM05_risk_cohort="IMID and Patients with a renal disease and solid cancer",
                        Region="South West",
                    ),
                    # fully duplicate row is removed and doesn't count when returning number of matches
                    Therapeutics(
                        Intervention="Remdesivir",
                        COVID_indication="non_hospitalised",
                        CurrentStatus="Approved",
                        TreatmentStartDate="2021-12-09 00:00:00.000",
                        Received="2021-12-09 00:00:00.000",
                        MOL1_high_risk_cohort="Patients with Liver disease",
                        SOT02_risk_cohorts="solid cancer and an unknown group that will be replaced",
                        CASIM05_risk_cohort="IMID and Patients with a renal disease and solid cancer",
                        Region="South West",
                    ),
                ]
            ),
        ],
    )
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        # returning values: date, therapeutic, risk group, region
        first_theraputic_date=patients.with_covid_therapeutics(
            find_first_match_in_period=True,
            returning="date",
            date_format="YYYY-MM-DD",
        ),
        # drug names are returned comma separated, whitespace and "and" removed
        first_theraputic=patients.with_covid_therapeutics(
            find_first_match_in_period=True,
            returning="therapeutic",
            date_format="YYYY-MM",
        ),
        # risk groups are concatenated from the 3 risk columns, returned comma separated,
        # whitespace, "and", "patient with [a]" removed
        first_risk_group=patients.with_covid_therapeutics(
            find_first_match_in_period=True,
            returning="risk_group",
            date_format="YYYY-MM",
            include_date_of_match=True,  # includes a first_risk_group_date column with YYYY-MM format only
        ),
        latest_region=patients.with_covid_therapeutics(
            find_last_match_in_period=True,
            returning="region",
            date_format="YYYY-MM",
        ),
        count=patients.with_covid_therapeutics(
            returning="number_of_matches_in_period",
        ),
        # status filter; whitespace and case insensitve
        not_started_region=patients.with_covid_therapeutics(
            with_these_statuses="treatment not Started ",
            find_last_match_in_period=True,
            returning="region",
            date_format="YYYY-MM",
        ),
        # status filter can be a list
        all_status_region=patients.with_covid_therapeutics(
            with_these_statuses=["treatment not Started", "Approved"],
            find_last_match_in_period=True,
            returning="region",
            date_format="YYYY-MM",
        ),
        # therapeutic filter
        # Match partial string, case insensitive
        therapeutic_match=patients.with_covid_therapeutics(
            with_these_therapeutics="Imdevimab",
            find_last_match_in_period=True,
            returning="date",
            date_format="YYYY-MM-DD",
        ),
        # Match list
        therapeutic_list_match=patients.with_covid_therapeutics(
            with_these_therapeutics=["Casirivimab", "Molnupiravir"],
            find_last_match_in_period=True,
            returning="therapeutic",
            date_format="YYYY-MM-DD",
        ),
        # Match codelist
        therapeutic_codelist_match=patients.with_covid_therapeutics(
            with_these_therapeutics=codelist(
                ["Casirivimab", "Molnupiravir"], "therapeutics"
            ),
            find_last_match_in_period=True,
            returning="therapeutic",
            date_format="YYYY-MM-DD",
        ),
        # Indication filter
        # match single indication on first match
        indication_match=patients.with_covid_therapeutics(
            with_these_indications="hospitalised_with",
            find_first_match_in_period=True,
            returning="date",
            date_format="YYYY-MM-DD",
        ),
        # Indication filter
        # match list of indications; for more than one, returns the first match
        indication_list_match=patients.with_covid_therapeutics(
            with_these_indications=["hospitalised_with", "non_hospitalised"],
            find_first_match_in_period=True,
            returning="date",
            date_format="YYYY-MM-DD",
        ),
        indication_list_match_therapeutic=patients.with_covid_therapeutics(
            with_these_indications=["hospitalised_with", "non_hospitalised"],
            find_first_match_in_period=True,
            returning="therapeutic",
            date_format="YYYY-MM-DD",
        ),
        # Multiple filters
        non_hospitalised_approved_cas_or_mol=patients.with_covid_therapeutics(
            with_these_statuses="approved",
            with_these_indications="non_hospitalised",
            with_these_therapeutics=["Casirivimab", "Molnupiravir"],
            find_last_match_in_period=True,
            returning="date",
            date_format="YYYY-MM-DD",
        ),
    )
    results = study.to_dicts()
    assert_results(
        results,
        # dates are timestamps with 0 times in db, returned as date strings
        first_theraputic_date=["2021-12-10", "2021-12-09"],
        # drugs joined with "and" are replaced with ","
        first_theraputic=["Casirivimab,imdevimab", "Remdesivir"],
        latest_region=["North", "South West"],
        count=["3", "1"],
        not_started_region=["London", ""],
        all_status_region=["North", "South West"],
        therapeutic_match=["2021-12-10", ""],
        therapeutic_list_match=["Molnupiravir", ""],
        therapeutic_codelist_match=["Molnupiravir", ""],
        indication_match=["2021-12-14", ""],
        indication_list_match=["2021-12-10", "2021-12-09"],
        indication_list_match_therapeutic=["Casirivimab,imdevimab", "Remdesivir"],
        non_hospitalised_approved_cas_or_mol=["2021-12-10", ""],
        first_risk_group_date=["2021-12", "2021-12"],
    )
    # risk groups are joined across the 3 columns with ",". Nulls and empty strings are ignored.
    # groups that are not in the ALLOWED_RISK_GROUPS are replaced with "other"
    # Duplicates are removed
    # Order is not deterministic, so we sort and rejoin here to test
    first_risk_group = [
        ",".join(sorted(result["first_risk_group"].split(","))) for result in results
    ]
    assert first_risk_group == [
        "solid cancer",
        "IMID,Liver disease,other,renal disease,solid cancer",
    ]


def test_with_covid_therapeutics_date_filters():
    session = make_session()
    session.add_all(
        [
            Patient(
                Therapeutics=[
                    Therapeutics(
                        Intervention="A",
                        TreatmentStartDate="2021-12-10 00:00:00.000",
                    ),
                    Therapeutics(
                        Intervention="B",
                        TreatmentStartDate="2022-01-10 00:00:00.000",
                    ),
                ]
            ),
            Patient(
                Therapeutics=[
                    Therapeutics(
                        Intervention="C",
                        TreatmentStartDate="2022-01-15 00:00:00.000",
                    )
                ]
            ),
            Patient(
                Therapeutics=[
                    Therapeutics(
                        Intervention="D",
                        TreatmentStartDate="2021-12-19 00:00:00.000",
                    )
                ]
            ),
        ]
    )
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        # returning values: date, therapeutic, risk group, region
        therapeutic=patients.with_covid_therapeutics(
            find_first_match_in_period=True,
            returning="therapeutic",
            on_or_after="2022-01-01",
        ),
        therapeutic_counts=patients.with_covid_therapeutics(
            find_first_match_in_period=True,
            returning="number_of_matches_in_period",
            on_or_after="2021-12-15",
        ),
    )
    assert_results(
        study.to_dicts(), therapeutic=["B", "C", ""], therapeutic_counts=["1", "1", "1"]
    )


def test_with_covid_therapeutics_duplicates_sort_order():
    session = make_session()

    def _make_therapeutics(**kwargs):
        defaults = dict(
            TreatmentStartDate="2021-12-10 00:00:00.000",
            Received="2021-12-12 00:00:00.000",
            Intervention="Z",
            Region="London",
            MOL1_high_risk_cohort="IMID",
            SOT02_risk_cohorts="solid cancer",
            CASIM05_risk_cohort="renal disease",
            CurrentStatus="Treatment Complete",
        )
        defaults.update(kwargs)
        return defaults

    session.add_all(
        [
            # differs on start date only
            Patient(
                Therapeutics=[
                    Therapeutics(**_make_therapeutics()),
                    Therapeutics(
                        **_make_therapeutics(
                            TreatmentStartDate="2022-01-10 00:00:00.000"
                        )
                    ),
                ]
            ),
            # differs on Intervention only
            Patient(
                Therapeutics=[
                    Therapeutics(**_make_therapeutics(Intervention="B")),
                    Therapeutics(**_make_therapeutics()),
                ]
            ),
            # differs on Region only
            Patient(
                Therapeutics=[
                    Therapeutics(**_make_therapeutics()),
                    Therapeutics(**_make_therapeutics(Region="East")),
                ]
            ),
            # differs on MOL1_high_risk_cohort only
            Patient(
                Therapeutics=[
                    Therapeutics(**_make_therapeutics()),
                    Therapeutics(
                        **_make_therapeutics(MOL1_high_risk_cohort="Downs Syndrome")
                    ),
                ]
            ),
            # differs on SOT02_risk_cohorts only
            Patient(
                Therapeutics=[
                    Therapeutics(**_make_therapeutics()),
                    Therapeutics(
                        **_make_therapeutics(SOT02_risk_cohorts="Downs Syndrome")
                    ),
                ]
            ),
            # differs on CASIM05_risk_cohort only
            Patient(
                Therapeutics=[
                    Therapeutics(**_make_therapeutics()),
                    Therapeutics(
                        **_make_therapeutics(CASIM05_risk_cohort="Downs Syndrome")
                    ),
                ]
            ),
            # differs on CurrentStatus only
            Patient(
                Therapeutics=[
                    Therapeutics(**_make_therapeutics()),
                    Therapeutics(**_make_therapeutics(CurrentStatus="Approved")),
                ]
            ),
            # differs on Received only
            Patient(
                Therapeutics=[
                    Therapeutics(**_make_therapeutics()),
                    Therapeutics(
                        **_make_therapeutics(Received="2021-12-22 00:00:00.000")
                    ),
                ]
            ),
        ]
    )
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        first_start_date=patients.with_covid_therapeutics(
            find_first_match_in_period=True, returning="date", date_format="YYYY-MM-DD"
        ),
        last_start_date=patients.with_covid_therapeutics(
            find_last_match_in_period=True, returning="date", date_format="YYYY-MM-DD"
        ),
        drug=patients.with_covid_therapeutics(returning="therapeutic"),
        region=patients.with_covid_therapeutics(returning="region"),
        risk_group=patients.with_covid_therapeutics(returning="risk_group"),
    )
    results = study.to_dicts()
    assert_results(
        results,
        first_start_date=[
            "2021-12-10",
            "2021-12-10",
            "2021-12-10",
            "2021-12-10",
            "2021-12-10",
            "2021-12-10",
            "2021-12-10",
            "2021-12-10",
        ],
        last_start_date=[
            "2022-01-10",
            "2021-12-10",
            "2021-12-10",
            "2021-12-10",
            "2021-12-10",
            "2021-12-10",
            "2021-12-10",
            "2021-12-10",
        ],
        drug=["Z", "B", "Z", "Z", "Z", "Z", "Z", "Z"],
        region=[
            "London",
            "London",
            "East",
            "London",
            "London",
            "London",
            "London",
            "London",
        ],
    )

    risk_group = [
        ",".join(sorted(result["risk_group"].split(","))) for result in results
    ]
    assert risk_group == [
        "IMID,renal disease,solid cancer",
        "IMID,renal disease,solid cancer",
        "IMID,renal disease,solid cancer",
        "Downs Syndrome,renal disease,solid cancer",
        "Downs Syndrome,IMID,renal disease",
        "Downs Syndrome,IMID,solid cancer",
        "IMID,renal disease,solid cancer",
        "IMID,renal disease,solid cancer",
    ]


@pytest.mark.parametrize(
    "error_match,query_kwargs",
    [
        (
            "'foo' is not a valid indication; options are hospital_onset, hospitalised_with, non_hospitalised",
            dict(
                find_first_match_in_period=True,
                returning="date",
                with_these_indications=["foo"],
            ),
        ),
        (
            "Cannot use 'find_first_match_in_period' when returning 'number_of_episodes'",
            dict(returning="number_of_episodes", find_first_match_in_period=True),
        ),
        (
            "Cannot use 'find_last_match_in_period' when returning 'number_of_episodes'",
            dict(returning="number_of_episodes", find_last_match_in_period=True),
        ),
        (
            "Cannot use 'include_date_of_match' when returning 'number_of_episodes'",
            dict(returning="number_of_episodes", include_date_of_match=True),
        ),
        (
            "Can only use 'episode_defined_as' when returning 'number_of_episodes'",
            dict(returning="date", episode_defined_as=True),
        ),
    ],
)
def test_with_covid_therapeutics_errors(error_match, query_kwargs):
    with pytest.raises(AssertionError, match=error_match):
        StudyDefinition(
            population=patients.all(),
            therapeutic=patients.with_covid_therapeutics(**query_kwargs),
        )


def test_with_covid_therapeutics_variable_dates():
    session = make_session()
    session.add_all(
        [
            Patient(
                Therapeutics=[
                    Therapeutics(
                        Intervention="Casirivimab and imdevimab ",
                        COVID_indication="non_hospitalised",
                        CurrentStatus="Approved",
                        TreatmentStartDate="2021-12-17 00:00:00.000",
                        Received="2021-12-10 00:00:00.000",
                        MOL1_high_risk_cohort="",
                        SOT02_risk_cohorts=None,
                        CASIM05_risk_cohort="solid cancer",
                        Region="South West",
                    ),
                    Therapeutics(
                        Intervention="Molnupiravir",
                        COVID_indication="non_hospitalised",
                        CurrentStatus="Approved",
                        TreatmentStartDate="2021-12-18 00:00:00.000",
                        Received="2021-12-14 00:00:00.000",
                        MOL1_high_risk_cohort="IMID",
                        Region="North",
                    ),
                    Therapeutics(
                        Intervention="Sotrovimab",
                        COVID_indication="non_hospitalised",
                        CurrentStatus="Approved",
                        TreatmentStartDate="2021-12-19 00:00:00.000",
                        Received="2021-12-13 00:00:00.000",
                        MOL1_high_risk_cohort="cancer",
                        Region="London",
                    ),
                ],
            ),
        ],
    )

    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        index_date="2021-12-16",
        molnupiravir_covid_therapeutics=patients.with_covid_therapeutics(
            with_these_therapeutics="Molnupiravir",
            with_these_indications="non_hospitalised",
            on_or_after="index_date",
            find_first_match_in_period=True,
            returning="date",
            date_format="YYYY-MM-DD",
        ),
        sotrovimab_covid_therapeutics=patients.with_covid_therapeutics(
            with_these_therapeutics="Sotrovimab",
            with_these_indications="non_hospitalised",
            on_or_after="index_date",
            find_first_match_in_period=True,
            returning="date",
            date_format="YYYY-MM-DD",
        ),
        casirivimab_covid_therapeutics=patients.with_covid_therapeutics(
            # with_these_statuses = ["Approved", "Treatment Complete"],
            with_these_therapeutics="Casirivimab and imdevimab",
            with_these_indications="non_hospitalised",
            on_or_after="index_date",
            find_first_match_in_period=True,
            returning="date",
            date_format="YYYY-MM-DD",
        ),
        start_date=patients.minimum_of(
            "sotrovimab_covid_therapeutics",
            "molnupiravir_covid_therapeutics",
            "casirivimab_covid_therapeutics",
        ),
        region_covid_therapeutics=patients.with_covid_therapeutics(
            with_these_therapeutics=[
                "Sotrovimab",
                "Molnupiravir",
                "Casirivimab and imdevimab",
            ],
            with_these_indications="non_hospitalised",
            on_or_after="start_date",
            find_first_match_in_period=True,
            returning="region",
        ),
        count=patients.with_covid_therapeutics(
            with_these_therapeutics=[
                "Sotrovimab",
                "Molnupiravir",
                "Casirivimab and imdevimab",
            ],
            with_these_indications="non_hospitalised",
            on_or_after="molnupiravir_covid_therapeutics",
            find_first_match_in_period=True,
            returning="number_of_matches_in_period",
        ),
    )

    assert_results(
        study.to_dicts(),
        molnupiravir_covid_therapeutics=["2021-12-18"],
        sotrovimab_covid_therapeutics=["2021-12-19"],
        casirivimab_covid_therapeutics=["2021-12-17"],
        start_date=["2021-12-17"],
        region_covid_therapeutics=["South West"],
        count=["2"],
    )


def test_covid_therapeutics_number_of_episodes():
    session = make_session()
    session.add_all(
        [
            Patient(
                Therapeutics=[
                    Therapeutics(
                        Intervention="Sotrovimab",
                        COVID_indication="non_hospitalised",
                        TreatmentStartDate="2010-01-01 00:00:00.000",
                    ),
                    # Throw in some irrelevant interventions and indications
                    Therapeutics(
                        Intervention="Casirivimab and imdevimab ",
                        COVID_indication="non_hospitalised",
                        TreatmentStartDate="2010-01-01 00:00:00.000",
                    ),
                    Therapeutics(
                        Intervention="Sotrovimab",
                        COVID_indication="hospitalised_with",
                        TreatmentStartDate="2010-01-01 00:00:00.000",
                    ),
                    # These two should be merged in to the previous event
                    # because there's not more than 14 days between them
                    Therapeutics(
                        Intervention="Sotrovimab",
                        COVID_indication="non_hospitalised",
                        TreatmentStartDate="2010-01-14 00:00:00.000",
                    ),
                    Therapeutics(
                        Intervention="Sotrovimab",
                        COVID_indication="non_hospitalised",
                        TreatmentStartDate="2010-01-20 00:00:00.000",
                    ),
                    # This is just outside the limit so should count as another event
                    Therapeutics(
                        Intervention="Sotrovimab",
                        COVID_indication="non_hospitalised",
                        TreatmentStartDate="2010-02-04 00:00:00.000",
                    ),
                    # This excludes the next Sotrovimab from the counts based on Molnupiravir dates
                    Therapeutics(
                        Intervention="Molnupiravir",
                        COVID_indication="non_hospitalised",
                        TreatmentStartDate="2015-06-01 00:00:00.000",
                    ),
                    # This should be another episode in the counts based on or before 2020-01-01
                    Therapeutics(
                        Intervention="Sotrovimab",
                        COVID_indication="non_hospitalised",
                        TreatmentStartDate="2015-06-05 00:00:00.000",
                    ),
                    # This is after the time limit and so shouldn't count
                    Therapeutics(
                        Intervention="Sotrovimab",
                        COVID_indication="non_hospitalised",
                        TreatmentStartDate="2020-06-05 00:00:00.000",
                    ),
                ]
            ),
            # This patient doesn't have any relevant events
            Patient(
                Therapeutics=[
                    Therapeutics(
                        Intervention="Molnupiravir",
                        COVID_indication="non_hospitalised",
                        TreatmentStartDate="2010-01-01 00:00:00.000",
                    ),
                    Therapeutics(
                        Intervention="Molnupiravir",
                        COVID_indication="non_hospitalised",
                        TreatmentStartDate="2010-01-14 00:00:00.000",
                    ),
                    Therapeutics(
                        Intervention="Casirivimab and imdevimab ",
                        COVID_indication="non_hospitalised",
                        TreatmentStartDate="2010-01-20 00:00:00.000",
                    ),
                    Therapeutics(
                        Intervention="Casirivimab and imdevimab ",
                        COVID_indication="non_hospitalised",
                        TreatmentStartDate="2010-02-04 00:00:00.000",
                    ),
                    Therapeutics(
                        Intervention="Sotrovimab",
                        COVID_indication="hospitalised_with",
                        TreatmentStartDate="2012-01-01 00:00:00.000",
                    ),
                    Therapeutics(
                        Intervention="Sotrovimab",
                        COVID_indication="hospitalised_with",
                        TreatmentStartDate="2015-03-05 00:00:00.000",
                    ),
                    Therapeutics(
                        Intervention="Sotrovimab",
                        COVID_indication="non_hospitalised",
                        TreatmentStartDate="2020-02-05 00:00:00.000",
                    ),
                ]
            ),
        ]
    )
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        first_molnupiravir_date=patients.with_covid_therapeutics(
            with_these_therapeutics="Molnupiravir",
            returning="date",
            date_format="YYYY-MM-DD",
            find_first_match_in_period=True,
        ),
        episode_count=patients.with_covid_therapeutics(
            with_these_therapeutics="Sotrovimab",
            with_these_indications="non_hospitalised",
            on_or_before="2020-01-01",
            returning="number_of_episodes",
            episode_defined_as="series of events each <= 14 days apart",
        ),
        event_count=patients.with_covid_therapeutics(
            with_these_therapeutics="Sotrovimab",
            with_these_indications="non_hospitalised",
            on_or_before="2020-01-01",
            returning="number_of_matches_in_period",
        ),
        episode_count_by_molnupiravir_date=patients.with_covid_therapeutics(
            with_these_therapeutics="Sotrovimab",
            with_these_indications="non_hospitalised",
            on_or_before="first_molnupiravir_date",
            returning="number_of_episodes",
            episode_defined_as="series of events each <= 14 days apart",
        ),
        event_count_by_molnupiravir_date=patients.with_covid_therapeutics(
            with_these_therapeutics="Sotrovimab",
            with_these_indications="non_hospitalised",
            on_or_before="first_molnupiravir_date",
            returning="number_of_matches_in_period",
        ),
    )
    assert_results(
        study.to_dicts(),
        first_molnupiravir_date=["2015-06-01", "2010-01-01"],
        episode_count=["3", "0"],
        event_count=["5", "0"],
        episode_count_by_molnupiravir_date=["2", "0"],
        event_count_by_molnupiravir_date=["4", "0"],
    )


def test_isaric_column_selection():
    session = make_session()
    session.add_all(
        [
            Patient(
                ISARIC=[
                    ISARICData(
                        assess_or_admit_date="01/01/2010",
                        arm_participant="1",
                        asthma_comorb="N",
                        assess_age="1.2",
                    ),
                ],
            ),
            Patient(
                ISARIC=[
                    ISARICData(
                        assess_or_admit_date="01/01/2012",
                        arm_participant="2",
                        asthma_comorb="Y",
                        assess_age="3.4",
                    ),
                ],
            ),
            Patient(
                ISARIC=[
                    ISARICData(
                        assess_or_admit_date="NA",
                        arm_participant="NA",
                        asthma_comorb="",  # empty string rather than NA
                        assess_age="NA",
                    ),
                ],
            ),
        ]
    )
    session.commit()
    # test types and NA handling
    study = StudyDefinition(
        population=patients.all(),
        test_date=patients.with_an_isaric_record(returning="assess_or_admit_date"),
        test_int=patients.with_an_isaric_record(returning="arm_participant"),
        test_str=patients.with_an_isaric_record(returning="asthma_comorb"),
        test_float=patients.with_an_isaric_record(returning="assess_age"),
    )

    assert_results(
        study.to_dicts(convert_to_strings=False),
        test_date=["2010-01-01", "2012-01-01", ""],
        test_int=[1, 2, 0],
        test_str=["N", "Y", ""],
        test_float=[1.2, 3.4, 0.0],
    )


def test_isaric_date_filtering():
    session = make_session()
    session.add_all(
        [
            Patient(
                ISARIC=[
                    ISARICData(
                        assess_or_admit_date="01/01/2010",
                        asthma_comorb="N",
                    ),
                ],
            ),
            Patient(
                ISARIC=[
                    ISARICData(
                        assess_or_admit_date="01/01/2012",
                        asthma_comorb="Y",
                    ),
                ],
            ),
            Patient(
                ISARIC=[
                    ISARICData(
                        assess_or_admit_date="01/01/2014",
                        asthma_comorb="N",
                    ),
                ],
            ),
            # check NULL dates are excluded
            Patient(
                ISARIC=[
                    ISARICData(
                        assess_or_admit_date="NA",
                        asthma_comorb="NA",
                    ),
                ],
            ),
        ]
    )
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        asthma_comorb=patients.with_an_isaric_record(
            returning="asthma_comorb",
            between=("2011-01-01", "2015-01-01"),
            date_filter_column="assess_or_admit_date",
        ),
    )

    assert_results(
        study.to_dicts(convert_to_strings=False), asthma_comorb=["", "Y", "N", ""]
    )


def test_nested_minimum_of_dates():
    # test that we can use a `minimum_of` date variable in another minimum_of

    session = make_session()

    def _make_therapeutics():
        return [
            Therapeutics(
                Intervention="Casirivimab and imdevimab ",
                COVID_indication="non_hospitalised",
                CurrentStatus="Approved",
                TreatmentStartDate="2019-01-01 00:00:00.000",
                MOL1_high_risk_cohort="",
                SOT02_risk_cohorts=None,
                CASIM05_risk_cohort="solid cancer",
                Region="South West",
            ),
            Therapeutics(
                Intervention="Molnupiravir",
                COVID_indication="non_hospitalised",
                CurrentStatus="Approved",
                TreatmentStartDate="2020-01-01 00:00:00.000",
                MOL1_high_risk_cohort="IMID",
                Region="North",
            ),
            Therapeutics(
                Intervention="Sotrovimab",
                COVID_indication="non_hospitalised",
                CurrentStatus="Approved",
                TreatmentStartDate="2021-01-01 00:00:00.000",
                MOL1_high_risk_cohort="cancer",
                Region="London",
            ),
        ]

    session.add_all(
        [
            # +ve test before 1st treated
            Patient(
                Patient_ID=1,
                Therapeutics=_make_therapeutics(),
                SGSS_AllTests_Positives=[
                    SGSS_AllTests_Positive(
                        Specimen_Date="2018-12-15",
                    ),
                ],
            ),
            # +ve test after 1st treated
            Patient(
                Patient_ID=2,
                Therapeutics=_make_therapeutics(),
                SGSS_AllTests_Positives=[
                    SGSS_AllTests_Positive(
                        Specimen_Date="2019-02-01",
                    ),
                ],
            ),
            # no +ve test
            Patient(
                Patient_ID=3,
                Therapeutics=_make_therapeutics(),
            ),
        ],
    )

    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        index_date="2017-12-16",
        molnupiravir_covid_therapeutics=patients.with_covid_therapeutics(
            with_these_therapeutics="Molnupiravir",
            with_these_indications="non_hospitalised",
            on_or_after="index_date",
            find_first_match_in_period=True,
            returning="date",
            date_format="YYYY-MM-DD",
        ),
        sotrovimab_covid_therapeutics=patients.with_covid_therapeutics(
            with_these_therapeutics="Sotrovimab",
            with_these_indications="non_hospitalised",
            on_or_after="index_date",
            find_first_match_in_period=True,
            returning="date",
            date_format="YYYY-MM-DD",
        ),
        casirivimab_covid_therapeutics=patients.with_covid_therapeutics(
            with_these_therapeutics="Casirivimab and imdevimab",
            with_these_indications="non_hospitalised",
            on_or_after="index_date",
            find_first_match_in_period=True,
            returning="date",
            date_format="YYYY-MM-DD",
        ),
        covid_test_positive_date=patients.with_test_result_in_sgss(
            pathogen="SARS-CoV-2",
            test_result="positive",
            find_first_match_in_period=True,
            restrict_to_earliest_specimen_date=False,
            returning="date",
            date_format="YYYY-MM-DD",
            on_or_after="index_date - 5 days",
            return_expectations={
                "date": {"earliest": "2021-12-20", "latest": "index_date"},
                "incidence": 0.9,
            },
        ),
        date_treated=patients.minimum_of(
            "sotrovimab_covid_therapeutics",
            "molnupiravir_covid_therapeutics",
            "casirivimab_covid_therapeutics",
        ),
        start_date=patients.minimum_of("covid_test_positive_date", "date_treated"),
    )

    assert_results(
        study.to_dicts(),
        patient_id=["1", "2", "3"],
        molnupiravir_covid_therapeutics=["2020-01-01", "2020-01-01", "2020-01-01"],
        sotrovimab_covid_therapeutics=["2021-01-01", "2021-01-01", "2021-01-01"],
        casirivimab_covid_therapeutics=["2019-01-01", "2019-01-01", "2019-01-01"],
        covid_test_positive_date=["2018-12-15", "2019-02-01", ""],
        date_treated=["2019-01-01", "2019-01-01", "2019-01-01"],
        start_date=["2018-12-15", "2019-01-01", "2019-01-01"],
    )


def test_retries(monkeypatch, tmp_path):
    attempts = 0

    def get_cursor(self):
        nonlocal attempts
        attempts += 1
        raise RuntimeError

    monkeypatch.setattr(TPPBackend, "_get_cursor", get_cursor)
    monkeypatch.setattr(tpp_backend, "RETRIES", 2)
    monkeypatch.setattr(tpp_backend, "SLEEP", 0.1)
    monkeypatch.setattr(tpp_backend, "BACKOFF_FACTOR", 2)

    study = StudyDefinition(population=patients.all())

    try:
        study.to_file(tmp_path / "test.csv")
    except RuntimeError:
        pass

    assert attempts == 2


def test_ons_cis():
    session = make_session()
    session.add_all(
        [
            Patient(
                ONS_CIS=[
                    ONS_CIS(
                        age_at_visit=20,
                        visit_date="2021-10-01",
                        covid_test_blood_pos_first_date="2021-08-01",
                        result_tdi="0",
                        country=0,
                        self_isolating=0,
                    ),
                ],
            ),
            Patient(
                ONS_CIS=[
                    ONS_CIS(
                        age_at_visit=30,
                        visit_date="2021-10-01",
                        covid_test_blood_pos_first_date="2021-07-01",
                        result_tdi="1",
                        country=1,
                        self_isolating=1,
                    ),
                ],
            ),
            Patient(
                ONS_CIS=[
                    ONS_CIS(
                        age_at_visit=40,
                        visit_date="2020-10-01",
                        covid_test_blood_pos_first_date="2021-06-01",
                        result_tdi="10",
                        country=2,
                        self_isolating=0,
                    ),
                    ONS_CIS(
                        age_at_visit=41,
                        visit_date="2021-10-01",
                        covid_test_blood_pos_first_date="2021-06-01",
                        result_tdi="1",
                        country=2,
                        self_isolating=0,
                    ),
                    # duplicate record ignored in number_of_matches_in_period counts
                    ONS_CIS(
                        age_at_visit=41,
                        visit_date="2021-10-01",
                        covid_test_blood_pos_first_date="2021-06-01",
                        result_tdi="1",
                        country=2,
                        self_isolating=0,
                    ),
                ],
            ),
        ]
    )
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        # by default returns last match in period, using visit date
        age_at_visit=patients.with_an_ons_cis_record(
            returning="age_at_visit",
            date_filter_column="visit_date",
            include_date_of_match=True,
            date_format="YYYY-MM-DD",
        ),
        # specifiy first match in period
        age_at_first_visit=patients.with_an_ons_cis_record(
            returning="age_at_visit",
            date_filter_column="visit_date",
            find_first_match_in_period=True,
        ),
        # filter by a different date column; filters out patient 3
        age_filtered_by_covid_test_pos=patients.with_an_ons_cis_record(
            returning="age_at_visit",
            date_filter_column="covid_test_blood_pos_first_date",
            on_or_after="2021-06-15",
            include_date_of_match=True,
            date_format="YYYY-MM-DD",
        ),
        # filter by the returning value
        covid_test_pos_date=patients.with_an_ons_cis_record(
            returning="covid_test_blood_pos_first_date",
            date_filter_column="covid_test_blood_pos_first_date",
            on_or_after="2021-06-15",
            date_format="YYYY-MM-DD",
        ),
        # binary flag return value
        has_visit_with_pos_test_before_2021_08=patients.with_an_ons_cis_record(
            returning="binary_flag",
            date_filter_column="covid_test_blood_pos_first_date",
            on_or_before="2021-07-31",
        ),
        # number_of_matches_in_period return value
        # date_filter_column required
        num_visits_with_pos_test_before_2021_08=patients.with_an_ons_cis_record(
            returning="number_of_matches_in_period",
            date_filter_column="covid_test_blood_pos_first_date",
            on_or_before="2021-07-31",
        ),
        # date_filter_column not required for number of matches with no date-matching
        num_visits=patients.with_an_ons_cis_record(
            returning="number_of_matches_in_period",
        ),
        # boolean value
        self_isolating_at_last_visit=patients.with_an_ons_cis_record(
            returning="self_isolating",
            date_filter_column="visit_date",
        ),
        # Coded categories are converted to long-form string labels
        # result_tdi is a coded category value; varchar type in the db
        # raw values are stringified ints, return the long form category label
        result_tdi=patients.with_an_ons_cis_record(
            returning="result_tdi",
            date_filter_column="visit_date",
            find_first_match_in_period=True,
            include_date_of_match=True,
            date_format="YYYY-MM-DD",
        ),
        # country is a coded category value, int type in the db
        # raw values are ints, return the long form category label
        country=patients.with_an_ons_cis_record(
            returning="country",
            date_filter_column="visit_date",
            find_first_match_in_period=True,
            include_date_of_match=True,
            date_format="YYYY-MM-DD",
        ),
        # return country as codes, with a date filter that filters out patient 3;
        # Missing values returned as empty string
        country_as_codes=patients.with_an_ons_cis_record(
            returning="country",
            return_category_labels=False,
            find_first_match_in_period=True,
            date_filter_column="covid_test_blood_pos_first_date",
            on_or_after="2021-06-15",
        ),
    )

    assert_results(
        study.to_dicts(convert_to_strings=False),
        age_at_visit=[20, 30, 41],
        age_at_visit_date=["2021-10-01", "2021-10-01", "2021-10-01"],
        age_at_first_visit=[20, 30, 40],
        age_filtered_by_covid_test_pos=[20, 30, 0],
        age_filtered_by_covid_test_pos_date=["2021-08-01", "2021-07-01", ""],
        covid_test_pos_date=["2021-08-01", "2021-07-01", ""],
        has_visit_with_pos_test_before_2021_08=[0, 1, 1],
        num_visits_with_pos_test_before_2021_08=[0, 1, 2],
        num_visits=[1, 1, 2],
        self_isolating_at_last_visit=[0, 1, 0],
        result_tdi=["Negative", "Positive", "Insufficient sample"],
        result_tdi_date=["2021-10-01", "2021-10-01", "2020-10-01"],
        country=["England", "Wales", "NI"],
        country_date=["2021-10-01", "2021-10-01", "2020-10-01"],
        country_as_codes=["0", "1", ""],
    )


def test_nested_ons_cis_variables():
    session = make_session()
    session.add_all(
        [
            Patient(
                ONS_CIS=[
                    ONS_CIS(
                        age_at_visit=20,
                        visit_date="2021-10-01",
                        covid_test_blood_pos_first_date="2021-08-01",
                        result_tdi="0",
                        country=0,
                        self_isolating=0,
                    ),
                ],
            ),
            Patient(
                ONS_CIS=[
                    ONS_CIS(
                        age_at_visit=30,
                        visit_date="2021-11-01",
                        covid_test_blood_pos_first_date="2021-07-01",
                        result_tdi="1",
                        country=1,
                        self_isolating=1,
                    ),
                ],
            ),
            Patient(
                ONS_CIS=[
                    ONS_CIS(
                        age_at_visit=40,
                        visit_date="2021-10-01",
                        covid_test_blood_pos_first_date="2021-06-01",
                        result_tdi="10",
                        country=2,
                        self_isolating=0,
                    ),
                    ONS_CIS(
                        age_at_visit=41,
                        visit_date="2021-11-01",
                        covid_test_blood_pos_first_date="2021-06-01",
                        result_tdi="1",
                        country=2,
                        self_isolating=0,
                    ),
                ],
            ),
        ]
    )
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        # by default returns last match in period, using visit date
        visit_date_1=patients.with_an_ons_cis_record(
            returning="visit_date",
            date_filter_column="visit_date",
            include_date_of_match=True,
            date_format="YYYY-MM-DD",
            find_first_match_in_period=True,
        ),
        # specifiy first match in period
        visit_date_2=patients.with_an_ons_cis_record(
            returning="visit_date",
            date_filter_column="visit_date",
            on_or_after="visit_date_1 + 7 days",
            date_format="YYYY-MM-DD",
            find_first_match_in_period=True,
        ),
        num_visits_on_or_before_visit_date_1=patients.with_an_ons_cis_record(
            returning="number_of_matches_in_period",
            date_filter_column="visit_date",
            on_or_before="visit_date_1",
        ),
    )
    res = study.to_dicts()
    assert_results(
        res,
        visit_date_1=["2021-10-01", "2021-11-01", "2021-10-01"],
        visit_date_2=["", "", "2021-11-01"],
        num_visits_on_or_before_visit_date_1=["1", "1", "1"],
    )


def test_ukrr():
    "Test UK Renal Registry"
    session = make_session()
    session.add_all(
        [
            Patient(
                UKRR=[
                    UKRR(
                        dataset="2019prev",
                        renal_centre="AD100",
                        rrt_start="2019-01-01",  # in 2019prev and rrt started 2019
                        mod_start="RT",
                        mod_prev=None,
                        creat=340,
                        eGFR_ckdepi=4.5,
                    ),
                ],
            ),
            Patient(
                UKRR=[
                    UKRR(
                        dataset="2019prev",
                        renal_centre="AD200",
                        rrt_start="2018-01-01",  # in 2019prev and rrt started 2018
                        mod_start="RT",
                        mod_prev=None,
                        creat=200,
                        eGFR_ckdepi=1.588,
                    ),
                ],
            ),
            Patient(
                UKRR=[
                    UKRR(
                        dataset="2019prev",
                        renal_centre="AD100",
                        rrt_start="2019-10-01",  # in 2019prev and rrt started 2019
                        mod_start="PD",
                        mod_prev="IHCD",
                        creat=1340,
                        eGFR_ckdepi=2.5,
                    ),
                ],
            ),
            Patient(
                UKRR=[
                    UKRR(
                        dataset="2020prev",
                        renal_centre="AD100",
                        rrt_start="2017-10-01",
                        mod_start="PD",
                        mod_prev="IHCD",
                        creat=780,
                        eGFR_ckdepi=11.5,
                    ),
                ],
            ),
            Patient(
                UKRR=[
                    UKRR(
                        dataset="2021prev",
                        renal_centre="AD100",
                        rrt_start="2021-01-01",
                        mod_start="PD",
                        mod_prev=None,
                        creat=780,
                        eGFR_ckdepi=11.5,
                    ),
                ],
            ),
            Patient(
                UKRR=[
                    UKRR(
                        dataset="2020inc",
                        renal_centre="AD100",
                        rrt_start="2020-10-01",
                        mod_start="PD",
                        mod_prev=None,
                        creat=540,
                        eGFR_ckdepi=8.7,
                    ),
                ],
            ),
            Patient(
                UKRR=[
                    UKRR(
                        dataset="2020ckd",
                        renal_centre="AD100",
                        rrt_start="2018-10-01",
                        mod_start="Tx",
                        mod_prev=None,
                        creat=140,
                        eGFR_ckdepi=9.72,
                    ),
                ],
            ),
            Patient(
                UKRR=[
                    UKRR(
                        dataset="2021prev",
                        renal_centre="AD100",
                        rrt_start=None,  # Some people who went straight to transplant didn't start RRT
                        mod_start="Tx",
                        mod_prev=None,
                        creat=140,
                        eGFR_ckdepi=9.72,
                    ),
                ],
            ),
            Patient(),  # Patient not in UKRR
        ]
    )
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        renal_registry_2019_prev=patients.with_record_in_ukrr(
            from_dataset="2019_prevalence", returning="binary_flag"
        ),
        renal_registry_2020_prev=patients.with_record_in_ukrr(
            from_dataset="2020_prevalence", returning="binary_flag"
        ),
        renal_registry_2021_prev=patients.with_record_in_ukrr(
            from_dataset="2021_prevalence", returning="binary_flag"
        ),
        renal_registry_2020_incidence=patients.with_record_in_ukrr(
            from_dataset="2020_incidence", returning="binary_flag"
        ),
        renal_registry_ckd=patients.with_record_in_ukrr(
            from_dataset="2020_ckd", returning="binary_flag"
        ),
        renal_2019_centre=patients.with_record_in_ukrr(
            from_dataset="2019_prevalence", returning="renal_centre"
        ),
        renal_2019_tx=patients.with_record_in_ukrr(
            from_dataset="2019_prevalence", returning="treatment_modality_start"
        ),
        renal_2019_modal_prev=patients.with_record_in_ukrr(
            from_dataset="2019_prevalence", returning="treatment_modality_prevalence"
        ),
        creatinine=patients.with_record_in_ukrr(
            from_dataset="2019_prevalence", returning="latest_creatinine"
        ),
        egfr=patients.with_record_in_ukrr(
            from_dataset="2019_prevalence", returning="latest_egfr"
        ),
        # Gets patients 1 - 3 who are in 2019prev dataset with a data of RRT
        rrt_start_date=patients.with_record_in_ukrr(
            from_dataset="2019_prevalence",
            returning="rrt_start_date",
            date_format="YYYY-MM-DD",
        ),
        rrt_start_month=patients.with_record_in_ukrr(
            from_dataset="2019_prevalence",
            returning="rrt_start_date",
            date_format="YYYY-MM",
        ),
        rrt_start_yr=patients.with_record_in_ukrr(
            from_dataset="2019_prevalence",
            returning="rrt_start_date",
            date_format="YYYY",
        ),
        # Gets patients 1 & 3 who are in 2019prev dataset
        # with a date of RRT in 2019 when filtered
        rrt_startdate_2019=patients.with_record_in_ukrr(
            from_dataset="2019_prevalence",
            returning="rrt_start_date",
            on_or_after="2019-01-01",
            date_format="YYYY-MM-DD",
        ),
        # Gets patients 2 who is in 2019prev dataset
        # with a date of RRT in before 2019 when filtered
        rrt_before_2019=patients.with_record_in_ukrr(
            from_dataset="2019_prevalence",
            returning="rrt_start_date",
            on_or_before="2018-12-31",
            date_format="YYYY-MM-DD",
        ),
        # Gets patients 1 who is in 2019prev dataset
        # with a date of RRT in first 6 months 2019 when filtered
        rrt_between=patients.with_record_in_ukrr(
            from_dataset="2019_prevalence",
            returning="rrt_start_date",
            between=("2018-12-31", "2019-06-01"),
            date_format="YYYY-MM-DD",
        ),
        egfr_rrt_between=patients.with_record_in_ukrr(
            from_dataset="2019_prevalence",
            returning="latest_egfr",
            between=("2018-12-31", "2019-06-01"),
            date_format="YYYY-MM-DD",
        ),
    )

    assert_results(
        study.to_dicts(convert_to_strings=False),
        renal_registry_2019_prev=[1, 1, 1, 0, 0, 0, 0, 0, 0],
        renal_registry_2020_prev=[0, 0, 0, 1, 0, 0, 0, 0, 0],
        renal_registry_2021_prev=[0, 0, 0, 0, 1, 0, 0, 1, 0],
        renal_registry_2020_incidence=[0, 0, 0, 0, 0, 1, 0, 0, 0],
        renal_registry_ckd=[0, 0, 0, 0, 0, 0, 1, 0, 0],
        renal_2019_centre=["AD100", "AD200", "AD100", "", "", "", "", "", ""],
        renal_2019_tx=["RT", "RT", "PD", "", "", "", "", "", ""],
        renal_2019_modal_prev=["", "", "IHCD", "", "", "", "", "", ""],
        creatinine=[340, 200, 1340, 0, 0, 0, 0, 0, 0],
        egfr=[4.5, 1.588, 2.5, 0, 0, 0, 0, 0, 0],
        rrt_start_date=[
            "2019-01-01",
            "2018-01-01",
            "2019-10-01",
            "",
            "",
            "",
            "",
            "",
            "",
        ],
        rrt_start_month=["2019-01", "2018-01", "2019-10", "", "", "", "", "", ""],
        rrt_start_yr=["2019", "2018", "2019", "", "", "", "", "", ""],
        rrt_startdate_2019=["2019-01-01", "", "2019-10-01", "", "", "", "", "", ""],
        rrt_before_2019=["", "2018-01-01", "", "", "", "", "", "", ""],
        rrt_between=["2019-01-01", "", "", "", "", "", "", "", ""],
        egfr_rrt_between=[4.5, 0, 0, 0, 0, 0, 0, 0, 0],
    )


def test_maintenance_mode():
    session = make_session()
    backend = TPPBackend(os.environ["TPP_DATABASE_URL"], {})

    assert backend.in_maintenance_mode("") is False

    # old unfinsihed event
    # we insert this here as a regression test to ensure that it doesn't
    # prevent exiting maintenance mode when we're done.
    old_OpenSAFELY_event = BuildProgress(Event="OpenSAFELY")
    session.add(old_OpenSAFELY_event)
    session.commit()

    assert backend.in_maintenance_mode("") is False
    assert backend.in_maintenance_mode("db-maintenance") is True

    # initial event
    OpenSAFELY_event = BuildProgress(Event="OpenSAFELY")
    session.add(OpenSAFELY_event)
    session.commit()

    assert backend.in_maintenance_mode("") is False
    assert backend.in_maintenance_mode("db-maintenance") is True

    # Swap Tables starts
    Swap_Tables_event = BuildProgress(Event="Swap Tables")
    session.add(Swap_Tables_event)
    session.commit()

    assert backend.in_maintenance_mode("") is True
    assert backend.in_maintenance_mode("db-maintenance") is True

    # Swap Tables done
    Swap_Tables_event.EventEnd = datetime.utcnow()
    session.commit()

    # This case is why we need the current mode, as without it,  we'll flap
    # inbetween Swap Tables ending and CodedEvent_SNOMED starting
    assert backend.in_maintenance_mode("") is False
    # we're in maintenance, and there still open events, so stay in it
    assert backend.in_maintenance_mode("db-maintenance") is True

    # CodedEvent_SNOMED starts
    CodedTable_SNOMED_event = BuildProgress(Event="CodedEvent_SNOMED")
    session.add(CodedTable_SNOMED_event)
    session.commit()

    # robustness, if for some reason, we're not in maintenance mode, but we
    # should be
    assert backend.in_maintenance_mode("") is True
    # yep still in maintenance
    assert backend.in_maintenance_mode("db-maintenance") is True

    # CodedEvent_SNOMED finishes
    CodedTable_SNOMED_event.EventEnd = datetime.utcnow()
    session.commit()

    # technically correct, and would be ok if it ever happens
    assert backend.in_maintenance_mode("") is False
    # normally we're not done until the final event is done.
    assert backend.in_maintenance_mode("db-maintenance") is True

    # OpenSAFELY event finished
    OpenSAFELY_event.EventEnd = datetime.utcnow()
    session.commit()

    # finally flip to off regardless of current state
    assert backend.in_maintenance_mode("") is False
    assert backend.in_maintenance_mode("db-maintenance") is False
