import csv
import os
import subprocess
import tempfile

import pytest

from tests.acme_backend_setup import make_database, make_session
from tests.acme_backend_setup import (
    Observation,
    Medication,
    Patient,
    Organisation,
    PatientAddress,
    ICNARC,
    ONSDeaths,
    CPNS,
)

from cohortextractor import (
    StudyDefinition,
    patients,
    codelist,
)
from cohortextractor.acme_backend import quote
from cohortextractor.presto_utils import presto_connection_params_from_url


@pytest.fixture(autouse=True)
def set_database_url(monkeypatch):
    # The StudyDefinition code expects a single DATABASE_URL to tell it where
    # to connect to, but the test environment needs to supply multiple
    # connections (one for each backend type) so we copy the value in here
    if "ACME_DATABASE_URL" in os.environ:
        monkeypatch.setenv("DATABASE_URL", os.environ["ACME_DATABASE_URL"])


def setup_module(module):
    make_database()


def setup_function(function):
    """
    Ensure test database is empty
    """
    session = make_session()
    session.query(Observation).delete()
    # session.query(ICNARC).delete()
    # session.query(ONSDeaths).delete()
    # session.query(CPNS).delete()
    session.query(Medication).delete()
    # session.query(Organisation).delete()
    # session.query(PatientAddress).delete()
    session.query(Patient).delete()
    session.commit()

    delete_temporary_tables()


def delete_temporary_tables():
    """Delete all temporary tables.
    """
    session = make_session()
    with session.bind.connect() as conn:
        sql = r"SELECT NAME FROM sys.tables WHERE NAME LIKE '\_%' ESCAPE '\'"
        tables = [row[0] for row in conn.execute(sql)]
        for table in tables:
            conn.execute(f"DROP TABLE {table}")


def test_minimal_study_to_csv():
    session = make_session()
    patient_1 = Patient(date_of_birth="1900-01-01", gender=1)
    patient_2 = Patient(date_of_birth="1900-01-01", gender=2)
    session.add_all([patient_1, patient_2])
    session.commit()
    study = StudyDefinition(population=patients.all(), sex=patients.sex())
    with tempfile.NamedTemporaryFile(mode="w+") as f:
        study.to_csv(f.name)
        results = list(csv.DictReader(f))
        assert results == [
            {"patient_id": str(patient_1.id), "sex": "M"},
            {"patient_id": str(patient_2.id), "sex": "F"},
        ]


def test_meds():
    session = make_session()

    patient_with_med = Patient()
    patient_with_med.medications = [Medication(snomed_concept_id=0)]
    patient_without_med = Patient()
    session.add(patient_with_med)
    session.add(patient_without_med)
    session.commit()

    study = StudyDefinition(
        population=patients.all(),
        asthma_meds=patients.with_these_medications(codelist([0], "snomed")),
    )
    results = study.to_dicts()
    assert [x["asthma_meds"] for x in results] == ["1", "0"]


def test_meds_with_count():
    session = make_session()

    patient_with_med = Patient()
    patient_with_med.medications = [
        Medication(snomed_concept_id=0, effective_date="2010-01-01"),
        Medication(snomed_concept_id=0, effective_date="2015-01-01"),
        Medication(snomed_concept_id=0, effective_date="2018-01-01"),
        Medication(snomed_concept_id=0, effective_date="2020-01-01"),
    ]
    patient_without_med = Patient()
    session.add(patient_with_med)
    session.add(patient_without_med)
    session.commit()

    study = StudyDefinition(
        population=patients.all(),
        asthma_meds=patients.with_these_medications(
            codelist([0], "snomed"),
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
            patient.observations.append(
                Observation(
                    snomed_concept_id=condition_code,
                    effective_date=date,
                    value_pq_1=value,
                )
            )
        session.add(patient)
    session.commit()


def test_clinical_event_without_filters():
    condition_code = "195967001"
    _make_clinical_events_selection(condition_code)
    # No date criteria
    study = StudyDefinition(
        population=patients.all(),
        asthma_condition=patients.with_these_clinical_events(
            codelist([condition_code], "snomedct")
        ),
    )
    results = study.to_dicts()
    assert [x["asthma_condition"] for x in results] == ["1", "1", "0"]


def test_clinical_event_with_max_date():
    condition_code = "195967001"
    _make_clinical_events_selection(condition_code)
    study = StudyDefinition(
        population=patients.all(),
        asthma_condition=patients.with_these_clinical_events(
            codelist([condition_code], "snomedct"), on_or_before="2001-12-01"
        ),
    )
    results = study.to_dicts()
    assert [x["asthma_condition"] for x in results] == ["1", "0", "0"]


def test_clinical_event_with_min_date():
    condition_code = "195967001"
    _make_clinical_events_selection(condition_code)
    study = StudyDefinition(
        population=patients.all(),
        asthma_condition=patients.with_these_clinical_events(
            codelist([condition_code], "snomedct"), on_or_after="2005-12-01"
        ),
    )
    results = study.to_dicts()
    assert [x["asthma_condition"] for x in results] == ["0", "0", "0"]


def test_clinical_event_with_min_and_max_date():
    condition_code = "195967001"
    _make_clinical_events_selection(condition_code)
    study = StudyDefinition(
        population=patients.all(),
        asthma_condition=patients.with_these_clinical_events(
            codelist([condition_code], "snomedct"), between=["2001-12-01", "2002-06-01"]
        ),
    )
    results = study.to_dicts()
    assert [x["asthma_condition"] for x in results] == ["0", "1", "0"]


def test_clinical_event_returning_first_date():
    condition_code = "195967001"
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
            codelist([condition_code], "snomedct"),
            between=["2001-12-01", "2002-06-01"],
            returning="date",
            find_first_match_in_period=True,
            date_format="YYYY-MM-DD",
        ),
    )
    results = study.to_dicts()
    assert [x["asthma_condition"] for x in results] == ["", "2002-06-01", ""]


def test_clinical_event_returning_last_date():
    condition_code = "195967001"
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
            codelist([condition_code], "snomedct"),
            between=["2001-12-01", "2002-06-01"],
            returning="date",
            find_last_match_in_period=True,
            date_format="YYYY-MM-DD",
        ),
    )
    results = study.to_dicts()
    assert [x["asthma_condition"] for x in results] == ["", "2002-06-01", ""]


def test_clinical_event_returning_year_only():
    condition_code = "195967001"
    _make_clinical_events_selection(condition_code)
    # No date criteria
    study = StudyDefinition(
        population=patients.all(),
        asthma_condition=patients.with_these_clinical_events(
            codelist([condition_code], "snomedct"),
            returning="date",
            find_first_match_in_period=True,
        ),
    )
    results = study.to_dicts()
    assert [x["asthma_condition"] for x in results] == ["2001", "2002", ""]


def test_clinical_event_returning_year_and_month_only():
    condition_code = "195967001"
    _make_clinical_events_selection(condition_code)
    # No date criteria
    study = StudyDefinition(
        population=patients.all(),
        asthma_condition=patients.with_these_clinical_events(
            codelist([condition_code], "snomedct"),
            returning="date",
            find_first_match_in_period=True,
            date_format="YYYY-MM",
        ),
    )
    results = study.to_dicts()
    assert [x["asthma_condition"] for x in results] == ["2001-06", "2002-06", ""]


def test_clinical_event_with_count():
    condition_code = "195967001"
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
            codelist([condition_code], "snomedct"),
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
    condition_code = "195967001"
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
            codelist([condition_code], "snomedct"),
            between=["2001-12-01", "2002-06-01"],
            returning="code",
            find_last_match_in_period=True,
        ),
        latest_asthma_code_date=patients.date_of(
            "latest_asthma_code", date_format="YYYY-MM"
        ),
    )
    results = study.to_dicts()
    assert [x["latest_asthma_code"] for x in results] == ["", str(condition_code), ""]
    assert [x["latest_asthma_code_date"] for x in results] == ["", "2002-06", ""]


def test_clinical_event_with_numeric_value():
    condition_code = "195967001"
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
            codelist([condition_code], "snomedct"),
            between=["2001-12-01", "2002-06-01"],
            returning="numeric_value",
            find_first_match_in_period=True,
        ),
        asthma_value_date=patients.date_of("asthma_value", date_format="YYYY-MM"),
    )
    results = study.to_dicts()
    assert [x["asthma_value"] for x in results] == ["0.0", "2.0", "0.0"]
    assert [x["asthma_value_date"] for x in results] == ["", "2002-01", ""]


def test_clinical_event_with_category():
    session = make_session()
    session.add_all(
        [
            Patient(),
            Patient(
                observations=[
                    Observation(
                        snomed_concept_id="10000001", effective_date="2018-01-01"
                    ),
                    Observation(
                        snomed_concept_id="10000002", effective_date="2020-01-01"
                    ),
                ]
            ),
            Patient(
                observations=[
                    Observation(
                        snomed_concept_id="10000003", effective_date="2019-01-01"
                    )
                ]
            ),
        ]
    )
    session.commit()
    codes = codelist(
        [("10000001", "A"), ("10000002", "B"), ("10000003", "C")], "snomedct"
    )
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


def test_patients_registered_with_one_practice_between():
    session = make_session()

    patient_registered_in_2001 = Patient(
        registered_date="2001-01-01", registration_end_date=None
    )
    patient_registered_in_2002 = Patient(
        registered_date="2002-01-01", registration_end_date=None
    )
    patient_unregistered_in_2002 = Patient(
        registered_date="2001-01-01", registration_end_date="2002-01-01"
    )

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
    assert [x["patient_id"] for x in results] == [str(patient_registered_in_2001.id)]


@pytest.mark.parametrize("include_dates", ["none", "year", "month", "day"])
def test_simple_bmi(include_dates):
    session = make_session()

    weight_code = "27113001"
    height_code = "271603002"

    patient = Patient(date_of_birth="1950-01-01")
    patient.observations.append(
        Observation(
            snomed_concept_id=weight_code, value_pq_1=50, effective_date="2002-06-01",
        )
    )
    patient.observations.append(
        Observation(
            snomed_concept_id=height_code, value_pq_1=10, effective_date="2001-06-01",
        )
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

    weight_code = "27113001"
    height_code = "271603002"

    patient = Patient(date_of_birth="1950-01-01")
    patient.observations.append(
        Observation(
            snomed_concept_id=weight_code,
            value_pq_1=10.12345,
            effective_date="2001-06-01",
        )
    )
    patient.observations.append(
        Observation(
            snomed_concept_id=height_code, value_pq_1=10, effective_date="2000-02-01",
        )
    )
    session.add(patient)
    session.commit()

    study = StudyDefinition(
        population=patients.all(),
        BMI=patients.most_recent_bmi("2005-01-01",),
        BMI_date_measured=patients.date_of("BMI", date_format="YYYY-MM-DD"),
    )
    results = study.to_dicts()
    assert [x["BMI"] for x in results] == ["0.1"]
    assert [x["BMI_date_measured"] for x in results] == ["2001-06-01"]


def test_bmi_with_zero_values():
    session = make_session()

    weight_code = "27113001"
    height_code = "271603002"

    patient = Patient(date_of_birth="1950-01-01")
    patient.observations.append(
        Observation(
            snomed_concept_id=weight_code, value_pq_1=0, effective_date="2001-06-01"
        )
    )
    patient.observations.append(
        Observation(
            snomed_concept_id=height_code, value_pq_1=0, effective_date="2001-06-01"
        )
    )
    session.add(patient)
    session.commit()

    study = StudyDefinition(
        population=patients.all(),
        BMI=patients.most_recent_bmi(
            on_or_after="1995-01-01", on_or_before="2005-01-01",
        ),
        BMI_date_measured=patients.date_of("BMI", date_format="YYYY-MM-DD"),
    )
    results = study.to_dicts()
    assert [x["BMI"] for x in results] == ["0.0"]
    assert [x["BMI_date_measured"] for x in results] == ["2001-06-01"]


def test_explicit_bmi_fallback():
    session = make_session()

    weight_code = "27113001"
    bmi_code = "301331008"

    patient = Patient(date_of_birth="1950-01-01")
    patient.observations.append(
        Observation(
            snomed_concept_id=weight_code, value_pq_1=50, effective_date="2001-06-01",
        )
    )
    patient.observations.append(
        Observation(
            snomed_concept_id=bmi_code, value_pq_1=99, effective_date="2001-10-01"
        )
    )
    session.add(patient)
    session.commit()

    study = StudyDefinition(
        population=patients.all(),
        BMI=patients.most_recent_bmi(
            on_or_after="1995-01-01", on_or_before="2005-01-01",
        ),
        BMI_date_measured=patients.date_of("BMI", date_format="YYYY-MM-DD"),
    )
    results = study.to_dicts()
    assert [x["BMI"] for x in results] == ["99.0"]
    assert [x["BMI_date_measured"] for x in results] == ["2001-10-01"]


def test_no_bmi_when_old_date():
    session = make_session()

    bmi_code = "301331008"

    patient = Patient(date_of_birth="1950-01-01")
    patient.observations.append(
        Observation(
            snomed_concept_id=bmi_code, value_pq_1=99, effective_date="1994-12-31"
        )
    )
    session.add(patient)
    session.commit()

    study = StudyDefinition(
        population=patients.all(),
        BMI=patients.most_recent_bmi(
            on_or_after="1995-01-01", on_or_before="2005-01-01",
        ),
        BMI_date_measured=patients.date_of("BMI", date_format="YYYY-MM-DD"),
    )
    results = study.to_dicts()
    assert [x["BMI"] for x in results] == ["0.0"]
    assert [x["BMI_date_measured"] for x in results] == [""]


def test_no_bmi_when_measurements_of_child():
    session = make_session()

    bmi_code = "301331008"

    patient = Patient(date_of_birth="2000-01-01")
    patient.observations.append(
        Observation(
            snomed_concept_id=bmi_code, value_pq_1=99, effective_date="2001-01-01"
        )
    )
    session.add(patient)
    session.commit()

    study = StudyDefinition(
        population=patients.all(),
        BMI=patients.most_recent_bmi(
            on_or_after="1995-01-01", on_or_before="2005-01-01",
        ),
        BMI_date_measured=patients.date_of("BMI", date_format="YYYY-MM-DD"),
    )
    results = study.to_dicts()
    assert [x["BMI"] for x in results] == ["0.0"]
    assert [x["BMI_date_measured"] for x in results] == [""]


def test_no_bmi_when_measurement_after_reference_date():
    session = make_session()

    bmi_code = "301331008"

    patient = Patient(date_of_birth="1900-01-01")
    patient.observations.append(
        Observation(
            snomed_concept_id=bmi_code, value_pq_1=99, effective_date="2001-01-01"
        )
    )
    session.add(patient)
    session.commit()

    study = StudyDefinition(
        population=patients.all(),
        BMI=patients.most_recent_bmi(
            on_or_after="1990-01-01", on_or_before="2000-01-01",
        ),
        BMI_date_measured=patients.date_of("BMI", date_format="YYYY-MM-DD"),
    )
    results = study.to_dicts()
    assert [x["BMI"] for x in results] == ["0.0"]
    assert [x["BMI_date_measured"] for x in results] == [""]


def test_bmi_when_only_some_measurements_of_child():
    session = make_session()

    bmi_code = "301331008"
    weight_code = "27113001"
    height_code = "271603002"

    patient = Patient(date_of_birth="1990-01-01")
    patient.observations.append(
        Observation(
            snomed_concept_id=bmi_code, value_pq_1=99, effective_date="1995-01-01"
        )
    )
    patient.observations.append(
        Observation(
            snomed_concept_id=weight_code, value_pq_1=50, effective_date="2010-01-01",
        )
    )
    patient.observations.append(
        Observation(
            snomed_concept_id=height_code, value_pq_1=10, effective_date="2010-01-01",
        )
    )
    session.add(patient)
    session.commit()

    study = StudyDefinition(
        population=patients.all(),
        BMI=patients.most_recent_bmi(
            on_or_after="2005-01-01", on_or_before="2015-01-01",
        ),
        BMI_date_measured=patients.date_of("BMI", date_format="YYYY-MM-DD"),
    )
    results = study.to_dicts()
    assert [x["BMI"] for x in results] == ["0.5"]
    assert [x["BMI_date_measured"] for x in results] == ["2010-01-01"]


def test_mean_recorded_value():
    code = "10000001"
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
        patient.observations.append(
            Observation(snomed_concept_id=code, value_pq_1=value, effective_date=date)
        )
    patient_with_old_reading = Patient()
    patient_with_old_reading.observations.append(
        Observation(snomed_concept_id=code, value_pq_1=100, effective_date="2010-01-01")
    )
    patient_with_no_reading = Patient()
    session.add_all([patient, patient_with_old_reading, patient_with_no_reading])
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        bp_systolic=patients.mean_recorded_value(
            codelist([code], system="snomedct"),
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


def test_patients_satisfying():
    condition_code = "195967001"
    session = make_session()
    patient_1 = Patient(date_of_birth="1940-01-01", gender=1)
    patient_2 = Patient(date_of_birth="1940-01-01", gender=2)
    patient_3 = Patient(date_of_birth="1990-01-01", gender=1)
    patient_4 = Patient(date_of_birth="1940-01-01", gender=2)
    patient_4.observations.append(
        Observation(snomed_concept_id=condition_code, effective_date="2010-01-01")
    )
    session.add_all([patient_1, patient_2, patient_3, patient_4])
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        sex=patients.sex(),
        age=patients.age_as_of("2020-01-01"),
        has_asthma=patients.with_these_clinical_events(
            codelist([condition_code], "snomedct")
        ),
        at_risk=patients.satisfying("(age > 70 AND sex = 'M') OR has_asthma"),
    )
    results = study.to_dicts()
    assert [i["at_risk"] for i in results] == ["1", "0", "0", "1"]


def test_patients_satisfying_with_hidden_columns():
    condition_code = "195967001"
    condition_code2 = "13645005"
    session = make_session()
    patient_1 = Patient(date_of_birth="1940-01-01", gender=1)
    patient_2 = Patient(date_of_birth="1940-01-01", gender=2)
    patient_3 = Patient(date_of_birth="1990-01-01", gender=1)
    patient_4 = Patient(date_of_birth="1940-01-01", gender=2)
    patient_4.observations.append(
        Observation(snomed_concept_id=condition_code, effective_date="2010-01-01")
    )
    patient_5 = Patient(date_of_birth="1940-01-01", gender=2)
    patient_5.observations.append(
        Observation(snomed_concept_id=condition_code, effective_date="2010-01-01")
    )
    patient_5.observations.append(
        Observation(snomed_concept_id=condition_code2, effective_date="2010-01-01")
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
                codelist([condition_code], "snomedct")
            ),
            copd=patients.with_these_clinical_events(
                codelist([condition_code2], "snomedct")
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
                gender=1,
                observations=[
                    Observation(
                        snomed_concept_id="10000001", effective_date="2000-01-01"
                    )
                ],
            ),
            Patient(
                gender=2,
                observations=[
                    Observation(
                        snomed_concept_id="10000002", effective_date="2000-01-01"
                    ),
                    Observation(
                        snomed_concept_id="20000001", effective_date="2000-01-01"
                    ),
                ],
            ),
            Patient(
                gender=1,
                observations=[
                    Observation(
                        snomed_concept_id="10000002", effective_date="2000-01-01"
                    )
                ],
            ),
            Patient(
                gender=2,
                observations=[
                    Observation(
                        snomed_concept_id="10000003", effective_date="2000-01-01"
                    )
                ],
            ),
            Patient(
                gender=2,
                observations=[
                    Observation(
                        snomed_concept_id="20000001", effective_date="2000-01-01"
                    ),
                ],
            ),
        ]
    )
    session.commit()
    foo_codes = codelist(
        [("10000001", "A"), ("10000002", "B"), ("10000003", "C")], "snomedct"
    )
    bar_codes = codelist(["20000001"], "snomedct")
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


@pytest.mark.xfail
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
        msoa=patients.registered_practice_as_of("2020-01-01", returning="msoa_code"),
        region=patients.registered_practice_as_of(
            "2020-01-01", returning="nhse_region_name"
        ),
        pseudo_id=patients.registered_practice_as_of(
            "2020-01-01", returning="pseudo_id"
        ),
    )
    results = study.to_dicts()
    assert [i["stp"] for i in results] == ["789", "123", ""]
    assert [i["msoa"] for i in results] == ["E0203", "E0201", ""]
    assert [i["region"] for i in results] == ["London", "East of England", ""]
    assert [i["pseudo_id"] for i in results] == ["3", "1", "0"]


@pytest.mark.xfail
def test_patients_address_as_of():
    session = make_session()
    patient = Patient()
    patient.Addresses.append(
        PatientAddress(
            StartDate="1990-01-01",
            EndDate="2018-01-01",
            ImdRankRounded=100,
            RuralUrbanClassificationCode=1,
        )
    )
    # We deliberately create overlapping address periods here to check that we
    # handle these correctly
    patient.Addresses.append(
        PatientAddress(
            StartDate="2018-01-01",
            EndDate="2020-02-01",
            ImdRankRounded=200,
            RuralUrbanClassificationCode=1,
        )
    )
    patient.Addresses.append(
        PatientAddress(
            StartDate="2019-01-01",
            EndDate="2022-01-01",
            ImdRankRounded=300,
            RuralUrbanClassificationCode=2,
        )
    )
    patient.Addresses.append(
        PatientAddress(
            StartDate="2022-01-01",
            EndDate="9999-12-31",
            ImdRankRounded=500,
            RuralUrbanClassificationCode=3,
        )
    )
    patient_no_address = Patient()
    patient_only_old_address = Patient()
    patient_only_old_address.Addresses.append(
        PatientAddress(
            StartDate="2010-01-01",
            EndDate="2015-01-01",
            ImdRankRounded=100,
            RuralUrbanClassificationCode=1,
        )
    )
    session.add_all([patient, patient_no_address, patient_only_old_address])
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
    )
    results = study.to_dicts()
    assert [i["imd"] for i in results] == ["300", "0", "0"]
    assert [i["rural_urban"] for i in results] == ["2", "0", "0"]


@pytest.mark.xfail
def test_patients_admitted_to_icu():
    session = make_session()
    patient_1 = Patient()
    patient_1.ICNARC.append(
        ICNARC(
            IcuAdmissionDateTime="2020-03-01",
            OriginalIcuAdmissionDate="2020-03-01",
            BasicDays_RespiratorySupport=2,
            AdvancedDays_RespiratorySupport=2,
            Ventilator=0,
        )
    )
    patient_2 = Patient()
    patient_2.ICNARC.append(
        ICNARC(
            IcuAdmissionDateTime="2020-03-01",
            OriginalIcuAdmissionDate="2020-02-01",
            BasicDays_RespiratorySupport=1,
            AdvancedDays_RespiratorySupport=0,
            Ventilator=1,
        )
    )
    patient_3 = Patient()
    patient_3.ICNARC.append(
        ICNARC(
            IcuAdmissionDateTime="2020-03-01",
            OriginalIcuAdmissionDate="2020-02-01",
            BasicDays_RespiratorySupport=0,
            AdvancedDays_RespiratorySupport=0,
            Ventilator=0,
        )
    )
    patient_4 = Patient()
    patient_4.ICNARC.append(
        ICNARC(
            IcuAdmissionDateTime="2020-01-01",
            OriginalIcuAdmissionDate="2020-01-01",
            BasicDays_RespiratorySupport=1,
            AdvancedDays_RespiratorySupport=0,
            Ventilator=1,
        )
    )
    patient_5 = Patient()
    patient_5.ICNARC.append(
        ICNARC(
            IcuAdmissionDateTime="2020-03-01",
            OriginalIcuAdmissionDate=None,
            BasicDays_RespiratorySupport=1,
            AdvancedDays_RespiratorySupport=0,
            Ventilator=1,
        )
    )
    patient_5.ICNARC.append(
        ICNARC(
            IcuAdmissionDateTime="2020-04-01",
            OriginalIcuAdmissionDate=None,
            BasicDays_RespiratorySupport=0,
            AdvancedDays_RespiratorySupport=0,
            Ventilator=1,
        )
    )
    session.add_all([patient_1, patient_2, patient_3, patient_4, patient_5])
    session.commit()

    study = StudyDefinition(
        population=patients.all(),
        icu=patients.admitted_to_icu(
            on_or_after="2020-02-01",
            include_day=True,
            returning="date_admitted",
            find_first_match_in_period=True,
        ),
    )
    results = study.to_dicts()

    assert [i["icu"] for i in results] == [
        "2020-03-01",
        "2020-02-01",
        "",
        "",
        "2020-03-01",
    ]

    delete_temporary_tables()

    study = StudyDefinition(
        population=patients.all(),
        icu=patients.admitted_to_icu(
            on_or_after="2020-02-01",
            include_day=True,
            returning="date_admitted",
            find_last_match_in_period=True,
        ),
    )
    results = study.to_dicts()

    assert [i["icu"] for i in results] == [
        "2020-03-01",
        "2020-02-01",
        "",
        "",
        "2020-04-01",
    ]

    delete_temporary_tables()

    study = StudyDefinition(
        population=patients.all(),
        icu=patients.admitted_to_icu(on_or_after="2020-02-01", returning="binary_flag"),
    )
    results = study.to_dicts()

    assert [i["icu"] for i in results] == ["1", "1", "0", "0", "1"]


@pytest.mark.xfail
def test_patients_with_these_codes_on_death_certificate():
    code = "COVID"
    session = make_session()
    session.add_all(
        [
            # Not dead
            Patient(),
            # Died after date cutoff
            Patient(ONSDeath=[ONSDeaths(dod="2021-01-01", icd10u=code)]),
            # Died of something else
            Patient(ONSDeath=[ONSDeaths(dod="2020-02-01", icd10u="MI")]),
            # Covid underlying cause
            Patient(ONSDeath=[ONSDeaths(dod="2020-02-01", icd10u=code, ICD10014="MI")]),
            # Covid not underlying cause
            Patient(ONSDeath=[ONSDeaths(dod="2020-03-01", icd10u="MI", ICD10014=code)]),
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


@pytest.mark.xfail
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
            on_or_before="2020-06-01", returning="underlying_cause_of_death",
        ),
    )
    results = study.to_dicts()
    assert [i["died"] for i in results] == ["0", "0", "1"]
    assert [i["date_died"] for i in results] == ["", "", "2020-02-01"]
    assert [i["underlying_cause"] for i in results] == ["", "", "A"]


@pytest.mark.xfail
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


@pytest.mark.xfail
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


def test_duplicate_id_checking():
    study = StudyDefinition(population=patients.all())
    # A bit of a hack: overwrite the queries we're going to run with a query which
    # deliberately returns duplicate values
    study.backend.queries = [
        (
            "dummy_query",
            """
            SELECT * FROM (
              VALUES
                (1,1),
                (2,2),
                (3,3),
                (1,4)
            ) t (patient_id, foo)
            """,
        )
    ]
    with pytest.raises(RuntimeError):
        study.to_dicts()
    with pytest.raises(RuntimeError):
        with tempfile.NamedTemporaryFile(mode="w+") as f:
            study.to_csv(f.name)


def test_column_name_clashes_produce_errors():
    with pytest.raises(ValueError):
        StudyDefinition(
            population=patients.all(),
            age=patients.age_as_of("2020-01-01"),
            status=patients.satisfying(
                "age > 70 AND sex = 'M'",
                sex=patients.sex(),
                age=patients.age_as_of("2010-01-01"),
            ),
        )


def test_recursive_definitions_produce_errors():
    with pytest.raises(ValueError):
        StudyDefinition(
            population=patients.all(),
            this=patients.satisfying("that = 1"),
            that=patients.satisfying("this = 1"),
        )


def test_using_expression_in_population_definition():
    session = make_session()
    session.add_all(
        [
            Patient(
                gender=1,
                date_of_birth="1970-01-01",
                observations=[
                    Observation(
                        snomed_concept_id="10000001", effective_date="2000-01-01"
                    )
                ],
            ),
            Patient(gender=1, date_of_birth="1975-01-01"),
            Patient(
                gender=2,
                date_of_birth="1980-01-01",
                observations=[
                    Observation(
                        snomed_concept_id="10000001", effective_date="2000-01-01"
                    )
                ],
            ),
            Patient(gender=2, date_of_birth="1985-01-01"),
        ]
    )
    session.commit()
    study = StudyDefinition(
        population=patients.satisfying(
            "has_foo_code AND sex = 'M'",
            has_foo_code=patients.with_these_clinical_events(
                codelist(["10000001"], "snomedct")
            ),
            sex=patients.sex(),
        ),
        age=patients.age_as_of("2020-01-01"),
    )
    results = study.to_dicts()
    assert results[0].keys() == {"patient_id", "age"}
    assert [i["age"] for i in results] == ["50"]


def test_quote():
    with pytest.raises(ValueError):
        quote("foo!")
    assert quote("2012-02-01") == "DATE('2012-02-01')"
    assert quote("2012") == "'2012'"
    assert quote(2012) == "2012"
    assert quote(0.1) == "0.1"
    assert quote("foo") == "'foo'"


def test_number_of_episodes():
    session = make_session()
    session.add_all(
        [
            Patient(
                observations=[
                    Observation(
                        snomed_concept_id="10000001", effective_date="2010-01-01"
                    ),
                    # Throw in some irrelevant events
                    Observation(
                        snomed_concept_id="40000001", effective_date="2010-01-02"
                    ),
                    Observation(
                        snomed_concept_id="40000002", effective_date="2010-01-03"
                    ),
                    # These two should be merged in to the previous event
                    # because there's not more than 14 days between them
                    Observation(
                        snomed_concept_id="10000002", effective_date="2010-01-14"
                    ),
                    Observation(
                        snomed_concept_id="10000003", effective_date="2010-01-20"
                    ),
                    # This is just outside the limit so should count as another event
                    Observation(
                        snomed_concept_id="10000001", effective_date="2010-02-04"
                    ),
                    # This shouldn't count because there's an "ignore" event on
                    # the same day (though at a different time)
                    Observation(
                        snomed_concept_id="10000001",
                        effective_date="2012-01-01T10:45:00",
                    ),
                    Observation(
                        snomed_concept_id="20000002",
                        effective_date="2012-01-01T16:10:00",
                    ),
                    # This should be another episode
                    Observation(
                        snomed_concept_id="10000001", effective_date="2015-03-05"
                    ),
                    # This "ignore" event should have no effect because it occurs
                    # on a different day
                    Observation(
                        snomed_concept_id="20000001", effective_date="2015-03-06"
                    ),
                    # This is after the time limit and so shouldn't count
                    Observation(
                        snomed_concept_id="10000001", effective_date="2020-02-05"
                    ),
                ]
            ),
            # This patient doesn't have any relevant events
            Patient(
                observations=[
                    Observation(
                        snomed_concept_id="40000001", effective_date="2010-01-01"
                    ),
                    Observation(
                        snomed_concept_id="40000002", effective_date="2010-01-14"
                    ),
                    Observation(
                        snomed_concept_id="40000003", effective_date="2010-01-20"
                    ),
                    Observation(
                        snomed_concept_id="40000001", effective_date="2010-02-04"
                    ),
                    Observation(
                        snomed_concept_id="40000001",
                        effective_date="2012-01-01T10:45:00",
                    ),
                    Observation(
                        snomed_concept_id="40000004",
                        effective_date="2012-01-01T16:10:00",
                    ),
                    Observation(
                        snomed_concept_id="40000001", effective_date="2015-03-05"
                    ),
                    Observation(
                        snomed_concept_id="40000001", effective_date="2020-02-05"
                    ),
                ]
            ),
        ]
    )
    session.commit()
    foo_codes = codelist(["10000001", "10000002", "10000003"], "snomedct")
    bar_codes = codelist(["20000001", "20000002"], "snomedct")
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
    session = make_session()
    session.add_all(
        [
            Patient(
                medications=[
                    Medication(
                        snomed_concept_id="12121212", effective_date="2010-01-01"
                    ),
                    # Throw in some irrelevant prescriptions
                    Medication(
                        snomed_concept_id="34343434", effective_date="2010-01-02"
                    ),
                    Medication(
                        snomed_concept_id="34343434", effective_date="2010-01-03"
                    ),
                    # These two should be merged in to the previous event
                    # because there's not more than 14 days between them
                    Medication(
                        snomed_concept_id="12121212", effective_date="2010-01-14"
                    ),
                    Medication(
                        snomed_concept_id="12121212", effective_date="2010-01-20"
                    ),
                    # This is just outside the limit so should count as another event
                    Medication(
                        snomed_concept_id="12121212", effective_date="2010-02-04"
                    ),
                    # This shouldn't count because there's an "ignore" event on
                    # the same day (though at a different time)
                    Medication(
                        snomed_concept_id="12121212",
                        effective_date="2012-01-01T10:45:00",
                    ),
                    # This should be another episode
                    Medication(
                        snomed_concept_id="12121212", effective_date="2015-03-05"
                    ),
                    # This is after the time limit and so shouldn't count
                    Medication(
                        snomed_concept_id="12121212", effective_date="2020-02-05"
                    ),
                ],
                observations=[
                    # This "ignore" event should cause us to skip one of the
                    # meds issues above
                    Observation(
                        snomed_concept_id="20000002",
                        effective_date="2012-01-01T16:10:00",
                    ),
                    # This "ignore" event should have no effect because it
                    # doesn't occur on the same day as any meds issue
                    Observation(
                        snomed_concept_id="20000001", effective_date="2015-03-06"
                    ),
                ],
            ),
            # This patient doesn't have any relevant events or prescriptions
            Patient(
                medications=[
                    Medication(
                        snomed_concept_id="34343434", effective_date="2010-01-02"
                    ),
                    Medication(
                        snomed_concept_id="34343434", effective_date="2010-01-03"
                    ),
                ],
                observations=[
                    Observation(
                        snomed_concept_id="40000001", effective_date="2010-02-04"
                    ),
                    Observation(
                        snomed_concept_id="40000001",
                        effective_date="2012-01-01T10:45:00",
                    ),
                    Observation(
                        snomed_concept_id="40000004",
                        effective_date="2012-01-01T16:10:00",
                    ),
                    Observation(
                        snomed_concept_id="40000001", effective_date="2015-03-05"
                    ),
                ],
            ),
        ]
    )
    session.commit()
    foo_codes = codelist(["12121212"], "snomed")
    bar_codes = codelist(["20000001", "20000002"], "snomedct")
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
    session = make_session()
    session.add_all(
        [
            Patient(
                medications=[
                    Medication(
                        snomed_concept_id="34343434", effective_date="2010-01-03"
                    ),
                    # This shouldn't count because there's an "ignore" event on
                    # the same day (though at a different time)
                    Medication(
                        snomed_concept_id="12121212",
                        effective_date="2012-01-01T10:45:00",
                    ),
                ],
                observations=[
                    # This "ignore" event should cause us to skip one of the
                    # meds issues above
                    Observation(
                        snomed_concept_id="20000001",
                        effective_date="2012-01-01T16:10:00",
                    ),
                ],
            ),
        ]
    )
    session.commit()
    drug_codes = codelist(["12121212", "34343434"], "snomed")
    annual_review_codes = codelist(["20000001"], "snomedct")
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
    assert [i["most_recent_drug"] for i in results] == ["34343434"]
    assert [i["most_recent_drug_date"] for i in results] == ["2010-01-03"]
