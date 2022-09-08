import csv
import gzip
import os
import tempfile

import pandas
import pytest

from cohortextractor import StudyDefinition, codelist, patients
from cohortextractor.date_expressions import InvalidExpressionError
from cohortextractor.emis_backend import quote, truncate_patient_id
from cohortextractor.patients import (
    max_recorded_value,
    mean_recorded_value,
    min_recorded_value,
)
from tests.emis_backend_setup import (
    CPNS,
    ICNARC,
    Immunisation,
    Medication,
    Observation,
    ONSDeaths,
    Patient,
    clear_database,
    make_database,
    make_session,
)
from tests.helpers import assert_results


@pytest.fixture(autouse=True)
def set_database_url(monkeypatch):
    # The StudyDefinition code expects a single DATABASE_URL to tell it where
    # to connect to, but the test environment needs to supply multiple
    # connections (one for each backend type) so we copy the value in here
    if "EMIS_DATABASE_URL" in os.environ:
        monkeypatch.setenv("DATABASE_URL", os.environ["EMIS_DATABASE_URL"])


def setup_module(module):
    make_database()


def teardown_module(module):
    clear_database()


def setup_function(function):
    """
    Ensure test database is empty
    """
    session = make_session()
    session.query(Observation).delete()
    session.query(ICNARC).delete()
    session.query(ONSDeaths).delete()
    session.query(CPNS).delete()
    session.query(Immunisation).delete()
    session.query(Medication).delete()
    session.query(Patient).delete()
    session.commit()

    delete_temporary_tables()


def delete_temporary_tables():
    """Delete all temporary tables."""
    session = make_session()
    with session.bind.connect() as conn:
        sql = r"SELECT NAME FROM sys.tables WHERE NAME LIKE '\_%' ESCAPE '\'"
        tables = [row[0] for row in conn.execute(sql)]
        for table in tables:
            conn.execute(f"DROP TABLE {table}")


@pytest.mark.parametrize("format", ["csv", "csv.gz", "feather", "dta", "dta.gz"])
def test_minimal_study_to_file(tmp_path, format):
    session = make_session()
    patient_1 = Patient(date_of_birth="1980-01-01", gender=1, hashed_organisation="abc")
    patient_2 = Patient(date_of_birth="1965-01-01", gender=2, hashed_organisation="abc")
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
        {"patient_id": cast(patient_1.registration_id), "sex": "M", "age": cast(40)},
        {"patient_id": cast(patient_2.registration_id), "sex": "F", "age": cast(55)},
    ]


def test_minimal_study_with_reserved_keywords():
    # Test that we can use reserved SQL keywords as study variables
    session = make_session()
    patient_1 = Patient(date_of_birth="1980-01-01", gender=1, hashed_organisation="abc")
    patient_2 = Patient(date_of_birth="1965-01-01", gender=2, hashed_organisation="abc")
    session.add_all([patient_1, patient_2])
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        all=patients.sex(),
        asc=patients.age_as_of("2020-01-01"),
    )

    assert_results(study.to_dicts(), all=["M", "F"], asc=["40", "55"])


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


def test_patients_with_vaccination_record():
    covid_vacc = "840534001"
    first_covid_vacc = "1324681000000101"
    second_covid_vacc = "1324691000000104"
    pf_vacc = "39115611000001103"
    az_vacc = "39114911000001105"

    covid_codelist = codelist(
        [covid_vacc, first_covid_vacc, second_covid_vacc], "snomedct"
    )
    pf_codelist = codelist([pf_vacc], "dmd")
    az_codelist = codelist([az_vacc], "dmd")
    vacc_codelist = codelist([pf_vacc, az_vacc], "dmd")

    pf_date_1 = "2020-12-01"
    pf_date_2 = "2021-01-01"
    az_date_1 = "2020-12-01"
    az_date_2 = "2020-12-02"

    session = make_session()
    session.add_all(
        [
            # Has no immunisations
            Patient(),
            # Has two Pfizer vaccinations with consistent dates
            Patient(
                medications=[
                    Medication(snomed_concept_id=pf_vacc, effective_date=pf_date_1),
                    Medication(snomed_concept_id=pf_vacc, effective_date=pf_date_2),
                ],
                immunisations=[
                    Immunisation(
                        snomed_concept_id=first_covid_vacc, effective_date=pf_date_1
                    ),
                    Immunisation(
                        snomed_concept_id=second_covid_vacc, effective_date=pf_date_2
                    ),
                ],
            ),
            # Has one AZ vaccination with inconsistent dates
            Patient(
                medications=[
                    Medication(snomed_concept_id=az_vacc, effective_date=az_date_1),
                ],
                immunisations=[
                    Immunisation(
                        snomed_concept_id=first_covid_vacc, effective_date=az_date_2
                    ),
                ],
            ),
        ]
    )
    session.commit()

    study = StudyDefinition(
        population=patients.all(),
        had_pf=patients.with_vaccination_record(
            emis={
                "procedure_codes": covid_codelist,
                "product_codes": pf_codelist,
            },
            tpp={},
        ),
        had_az=patients.with_vaccination_record(
            emis={
                "procedure_codes": covid_codelist,
                "product_codes": az_codelist,
            },
            tpp={},
        ),
        first_pf=patients.with_vaccination_record(
            emis={
                "procedure_codes": covid_codelist,
                "product_codes": pf_codelist,
            },
            tpp={},
            find_first_match_in_period=True,
            returning="date",
            date_format="YYYY-MM-DD",
        ),
        second_pf=patients.with_vaccination_record(
            emis={
                "procedure_codes": covid_codelist,
                "product_codes": pf_codelist,
            },
            tpp={},
            on_or_after="first_pf + 20 days",
            find_first_match_in_period=True,
            returning="date",
            date_format="YYYY-MM-DD",
        ),
        last_pf=patients.with_vaccination_record(
            emis={
                "procedure_codes": covid_codelist,
                "product_codes": pf_codelist,
            },
            tpp={},
            find_last_match_in_period=True,
            returning="date",
            date_format="YYYY-MM-DD",
        ),
        first_az=patients.with_vaccination_record(
            emis={
                "procedure_codes": covid_codelist,
                "product_codes": az_codelist,
            },
            tpp={},
            find_first_match_in_period=True,
            returning="date",
            date_format="YYYY-MM-DD",
        ),
        second_az=patients.with_vaccination_record(
            emis={
                "procedure_codes": covid_codelist,
                "product_codes": az_codelist,
            },
            tpp={},
            on_or_after="first_az + 20 days",
            find_first_match_in_period=True,
            returning="date",
            date_format="YYYY-MM-DD",
        ),
        last_az=patients.with_vaccination_record(
            emis={
                "procedure_codes": covid_codelist,
                "product_codes": az_codelist,
            },
            tpp={},
            find_last_match_in_period=True,
            returning="date",
            date_format="YYYY-MM-DD",
        ),
        first_product=patients.with_vaccination_record(
            emis={
                "product_codes": vacc_codelist,
            },
            tpp={},
            find_first_match_in_period=True,
            returning="date",
            date_format="YYYY-MM-DD",
        ),
        second_product=patients.with_vaccination_record(
            emis={
                "product_codes": vacc_codelist,
            },
            tpp={},
            on_or_after="first_product + 20 days",
            find_first_match_in_period=True,
            returning="date",
            date_format="YYYY-MM-DD",
        ),
        last_product=patients.with_vaccination_record(
            emis={
                "product_codes": vacc_codelist,
            },
            tpp={},
            find_last_match_in_period=True,
            returning="date",
            date_format="YYYY-MM-DD",
        ),
        first_procedure=patients.with_vaccination_record(
            emis={
                "procedure_codes": covid_codelist,
            },
            tpp={},
            find_first_match_in_period=True,
            returning="date",
            date_format="YYYY-MM-DD",
        ),
        second_procedure=patients.with_vaccination_record(
            emis={
                "procedure_codes": covid_codelist,
            },
            tpp={},
            on_or_after="first_procedure + 20 days",
            find_first_match_in_period=True,
            returning="date",
            date_format="YYYY-MM-DD",
        ),
        last_procedure=patients.with_vaccination_record(
            emis={
                "procedure_codes": covid_codelist,
            },
            tpp={},
            find_last_match_in_period=True,
            returning="date",
            date_format="YYYY-MM-DD",
        ),
    )

    assert_results(
        study.to_dicts(),
        had_pf=["0", "1", "0"],
        had_az=["0", "0", "1"],
        first_pf=["", pf_date_1, ""],
        second_pf=["", pf_date_2, ""],
        last_pf=["", pf_date_2, ""],
        first_az=["", "", az_date_1],
        second_az=["", "", ""],
        last_az=["", "", az_date_2],
        first_product=["", pf_date_1, az_date_1],
        second_product=["", pf_date_2, ""],
        last_product=["", pf_date_2, az_date_1],
        first_procedure=["", pf_date_1, az_date_2],
        second_procedure=["", pf_date_2, ""],
        last_procedure=["", pf_date_2, az_date_2],
    )


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


def test_clinical_event_ignoring_missing_values():
    condition_code = "195967001"
    _make_clinical_events_selection(
        condition_code,
        patient_dates=[
            [
                ("2001-01-01", None),
                ("2001-01-01", 0),
                ("2001-01-02", 2),
                ("2001-01-03", None),
                ("2001-01-04", 4),
                ("2001-01-05", None),
                ("2001-01-05", 0),
            ],
        ],
    )
    study = StudyDefinition(
        population=patients.all(),
        first=patients.with_these_clinical_events(
            codelist([condition_code], "snomedct"),
            returning="numeric_value",
            ignore_missing_values=True,
            find_first_match_in_period=True,
        ),
        last=patients.with_these_clinical_events(
            codelist([condition_code], "snomedct"),
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


def test_patient_registered_as_of():
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

    # No date criteria
    study = StudyDefinition(population=patients.registered_as_of("2002-03-02"))
    results = study.to_dicts()
    assert len(results) == 2


def test_patient_registered_as_of_with_date_variable():
    session = make_session()

    patient_unregistered_on_date_of_death = Patient(
        registered_date="2001-01-01",
        registration_end_date="2011-04-01",
        date_of_death="2011-05-01",
    )
    patient_registered_on_date_of_death = Patient(
        registered_date="2002-01-01",
        registration_end_date=None,
        date_of_death="2003-01-01",
    )
    patient_registered_on_ons_date_of_death = Patient(
        registered_date="2001-01-01",
        registration_end_date="2011-04-01",
        date_of_death=None,
        ONSDeath=[ONSDeaths(reg_stat_dod=20100101, upload_date="2021-02-02")],
    )
    patient_not_dead = Patient(
        registered_date="2001-01-01",
        registration_end_date="2002-01-01",
        date_of_death=None,
    )

    session.add(patient_unregistered_on_date_of_death)
    session.add(patient_registered_on_date_of_death)
    session.add(patient_registered_on_ons_date_of_death)
    session.add(patient_not_dead)
    session.commit()

    study = StudyDefinition(
        date_of_death=patients.with_death_recorded_in_primary_care(
            returning="date_of_death", date_format="YYYY-MM-DD"
        ),
        population=patients.registered_as_of("date_of_death"),
    )
    results = study.to_dicts()
    assert len(results) == 1
    assert results[0]["date_of_death"] == "2003-01-01"

    study = StudyDefinition(
        ons_death_date=patients.died_from_any_cause(
            returning="date_of_death", date_format="YYYY-MM-DD"
        ),
        population=patients.registered_as_of("ons_death_date"),
    )
    results = study.to_dicts()
    assert len(results) == 1
    assert results[0]["ons_death_date"] == "2010-01-01"


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
    assert len(results) == 1


@pytest.mark.parametrize("include_dates", ["none", "year", "month", "day"])
def test_simple_bmi(include_dates):
    session = make_session()

    weight_code = "27113001"
    height_code = "271603002"

    patient = Patient(date_of_birth="1950-01-01")
    patient.observations.append(
        Observation(
            snomed_concept_id=weight_code,
            value_pq_1=50,
            effective_date="2002-06-01",
        )
    )
    patient.observations.append(
        Observation(
            snomed_concept_id=height_code,
            value_pq_1=10,
            effective_date="2001-06-01",
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
            snomed_concept_id=height_code,
            value_pq_1=10,
            effective_date="2000-02-01",
        )
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

    weight_code = "27113001"
    bmi_code = "301331008"

    patient = Patient(date_of_birth="1950-01-01")
    patient.observations.append(
        Observation(
            snomed_concept_id=weight_code,
            value_pq_1=50,
            effective_date="2001-06-01",
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
            snomed_concept_id=weight_code,
            value_pq_1=50,
            effective_date="2010-01-01",
        )
    )
    patient.observations.append(
        Observation(
            snomed_concept_id=height_code,
            value_pq_1=10,
            effective_date="2010-01-01",
        )
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
    code = "10000001"
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
        bp_systolic=summary_function(
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
    code = "113075003"
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
        creatine=summary_function(
            codelist([code], system="snomedct"),
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
                codelist(["113075003"], system="snomedct"),
                on_most_recent_day_of_measurement=False,
                between=["2018-01-01", "2020-03-01"],
                include_measurement_date=True,
            ),
        )


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


@pytest.mark.freeze_time("2020-02-15")
def test_patients_registered_practice_as_of():
    session = make_session()
    patient = Patient(
        stp_code="789",
        msoa="E0203",
        english_region_name="London",
        hashed_organisation="abc",
    )

    session.add_all([patient])
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        stp=patients.registered_practice_as_of("2020-02-01", returning="stp_code"),
        msoa=patients.registered_practice_as_of("2020-02-01", returning="msoa"),
        deprecated_msoa=patients.registered_practice_as_of(
            "2020-01-01", returning="msoa_code"
        ),
        region=patients.registered_practice_as_of(
            "2020-02-01", returning="nuts1_region_name"
        ),
        pseudo_id=patients.registered_practice_as_of(
            "2020-02-01", returning="pseudo_id"
        ),
    )
    results = study.to_dicts()
    assert [i["stp"] for i in results] == ["789"]
    assert [i["msoa"] for i in results] == ["E0203"]
    assert [i["deprecated_msoa"] for i in results] == ["E0203"]
    assert [i["region"] for i in results] == ["London"]
    assert [i["pseudo_id"] for i in results] == ["abc"]


@pytest.mark.freeze_time("2020-02-15")
def test_patients_address_as_of():
    session = make_session()
    patient = Patient(imd_rank=300, rural_urban=2)
    patient_no_address = Patient()
    session.add_all([patient, patient_no_address])
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        imd=patients.address_as_of(
            "2020-02-01",
            returning="index_of_multiple_deprivation",
            round_to_nearest=100,
        ),
        rural_urban=patients.address_as_of(
            "2020-02-01", returning="rural_urban_classification"
        ),
    )
    results = study.to_dicts()
    assert [i["imd"] for i in results] == ["300", "0"]
    assert [i["rural_urban"] for i in results] == ["2", "0"]


def test_patients_with_death_recorded_in_primary_care():
    session = make_session()
    session.add_all(
        [
            Patient(date_of_death=None),
            Patient(date_of_death="2017-05-06"),
            Patient(date_of_death="2019-06-07"),
            Patient(date_of_death="2020-07-08"),
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


def test_patients_admitted_to_icu():
    session = make_session()
    session.add_all(
        [
            Patient(
                ICNARC=[
                    ICNARC(
                        icuadmissiondatetime="2020-03-01",
                        originalicuadmissiondate="2020-03-01",
                        basicdays_respiratorysupport=2,
                        advanceddays_respiratorysupport=2,
                    )
                ]
            ),
            Patient(
                ICNARC=[
                    ICNARC(
                        icuadmissiondatetime="2020-03-01",
                        originalicuadmissiondate="2020-02-01",
                        basicdays_respiratorysupport=1,
                        advanceddays_respiratorysupport=0,
                    )
                ]
            ),
            Patient(),
            Patient(
                ICNARC=[
                    ICNARC(
                        icuadmissiondatetime="2020-01-01",
                        originalicuadmissiondate="2020-01-01",
                        basicdays_respiratorysupport=1,
                        advanceddays_respiratorysupport=0,
                    )
                ]
            ),
            Patient(
                ICNARC=[
                    ICNARC(
                        icuadmissiondatetime="2020-03-01",
                        originalicuadmissiondate=None,
                        basicdays_respiratorysupport=0,
                        advanceddays_respiratorysupport=1,
                    ),
                    ICNARC(
                        icuadmissiondatetime="2020-04-01",
                        originalicuadmissiondate=None,
                        basicdays_respiratorysupport=0,
                        advanceddays_respiratorysupport=0,
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
    session.add_all(
        [
            # Not dead
            Patient(nhs_no="aaa"),
            # Died after date cutoff
            Patient(
                nhs_no="bbb",
                ONSDeath=[
                    ONSDeaths(
                        reg_stat_dod=20210101, icd10u=code, upload_date="2020-04-01"
                    )
                ],
            ),
            # Died of something else
            Patient(
                nhs_no="ccc",
                ONSDeath=[
                    ONSDeaths(
                        reg_stat_dod=20200201, icd10u="MI", upload_date="2020-04-01"
                    )
                ],
            ),
            # Covid underlying cause
            Patient(
                nhs_no="ddd",
                ONSDeath=[
                    ONSDeaths(
                        reg_stat_dod=20200201,
                        icd10u=code,
                        icd10014="MI",
                        upload_date="2020-04-01",
                    )
                ],
            ),
            # Covid not underlying cause
            Patient(
                nhs_no="eee",
                ONSDeath=[
                    ONSDeaths(
                        reg_stat_dod=20200301,
                        icd10u="MI",
                        icd10014=code,
                        upload_date="2020-04-01",
                    )
                ],
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
            Patient(nhs_no="aaa"),
            # Died after date cutoff
            Patient(
                nhs_no="bbb",
                ONSDeath=[ONSDeaths(reg_stat_dod=20210101, upload_date="2021-02-02")],
            ),
            # Died
            Patient(
                nhs_no="ccc",
                ONSDeath=[
                    ONSDeaths(
                        reg_stat_dod=20200201, icd10u="A", upload_date="2020-02-02"
                    ),
                    ONSDeaths(
                        reg_stat_dod=20200201, icd10u="A", upload_date="2021-02-02"
                    ),
                ],
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
            Patient(CPNS=[CPNS(dateofdeath="2021-01-01")]),
            # Patient should be included
            Patient(CPNS=[CPNS(dateofdeath="2020-02-01")]),
            # Patient has multple entries but with the same date of death so
            # should be handled correctly
            Patient(
                CPNS=[CPNS(dateofdeath="2020-03-01"), CPNS(dateofdeath="2020-03-01")]
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
        [Patient(CPNS=[CPNS(dateofdeath="2020-03-01"), CPNS(dateofdeath="2020-02-01")])]
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
        with tempfile.NamedTemporaryFile(mode="w+", suffix=".csv") as f:
            study.to_file(f.name)


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


def test_patients_aggregate_value_of():
    session = make_session()
    session.add_all(
        [
            Patient(
                observations=[
                    Observation(
                        snomed_concept_id=111, value_pq_1=7, effective_date="2012-01-01"
                    ),
                    Observation(
                        snomed_concept_id=222,
                        value_pq_1=23,
                        effective_date="2018-01-01",
                    ),
                ]
            ),
            Patient(
                observations=[
                    Observation(
                        snomed_concept_id=111,
                        value_pq_1=18,
                        effective_date="2014-01-01",
                    ),
                    Observation(
                        snomed_concept_id=222, value_pq_1=4, effective_date="2017-01-01"
                    ),
                ]
            ),
            Patient(
                observations=[
                    Observation(
                        snomed_concept_id=111,
                        value_pq_1=10,
                        effective_date="2015-01-01",
                    ),
                ]
            ),
            Patient(
                observations=[
                    Observation(
                        snomed_concept_id=222, value_pq_1=8, effective_date="2019-01-01"
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
            codelist([111], system="snomedct"), returning="numeric_value"
        ),
        xyz_value=patients.with_these_clinical_events(
            codelist([222], system="snomedct"), returning="numeric_value"
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
                codelist([111], system="snomedct"), returning="numeric_value"
            ),
            xyz_value=patients.with_these_clinical_events(
                codelist([222], system="snomedct"), returning="numeric_value"
            ),
        ),
    )
    results = study_with_hidden_columns.to_dicts()
    assert [x["max_value"] for x in results] == ["23.0", "18.0", "10.0", "8.0", "0.0"]
    assert "abc_value" not in results[0].keys()


def test_patients_date_deregistered_from_all_supported_practices():
    session = make_session()
    session.add_all(
        [
            # Never de-registered
            Patient(registered_date="2001-01-01", registration_end_date=None),
            # De-registered, but after cut-off date
            Patient(registered_date="2001-01-01", registration_end_date="2020-01-01"),
            # De-registered
            Patient(registered_date="2001-01-01", registration_end_date="2010-01-01"),
        ]
    )
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        dereg_date=patients.date_deregistered_from_all_supported_practices(
            on_or_before="2015-01-01",
            date_format="YYYY-MM",
        ),
    )
    assert_results(study.to_dicts(), dereg_date=["", "", "2010-01"])


def test_dynamic_index_dates():
    session = make_session()
    session.add_all(
        [
            Patient(
                observations=[
                    Observation(effective_date="2020-01-15", snomed_concept_id=123),
                    Observation(effective_date="2020-02-01", snomed_concept_id=123),
                    Observation(effective_date="2020-03-01", snomed_concept_id=456),
                    Observation(effective_date="2020-04-20", snomed_concept_id=123),
                    Observation(effective_date="2020-05-01", snomed_concept_id=123),
                    Observation(effective_date="2020-06-01", snomed_concept_id=456),
                ],
            ),
        ]
    )
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        earliest_123=patients.with_these_clinical_events(
            codelist(["123"], system="snomed"),
            returning="date",
            date_format="YYYY-MM-DD",
            find_first_match_in_period=True,
        ),
        earliest_456=patients.with_these_clinical_events(
            codelist(["456"], system="snomed"),
            returning="date",
            date_format="YYYY-MM-DD",
            find_first_match_in_period=True,
        ),
        earliest_123_or_456=patients.minimum_of("earliest_123", "earliest_456"),
        latest_123_before_456=patients.with_these_clinical_events(
            codelist(["123"], system="snomed"),
            returning="date",
            date_format="YYYY-MM-DD",
            find_last_match_in_period=True,
            on_or_before="earliest_456",
        ),
        latest_123_in_month_after_456=patients.with_these_clinical_events(
            codelist(["123"], system="snomed"),
            returning="date",
            date_format="YYYY-MM-DD",
            find_last_match_in_period=True,
            on_or_before="last_day_of_month(earliest_456) + 1 month",
        ),
        next_123=patients.with_these_clinical_events(
            codelist(["123"], system="snomed"),
            returning="date",
            date_format="YYYY-MM-DD",
            find_first_match_in_period=True,
            on_or_after="earliest_123_or_456 + 1 day",
        ),
    )
    assert_results(
        study.to_dicts(),
        earliest_123=["2020-01-15"],
        earliest_456=["2020-03-01"],
        earliest_123_or_456=["2020-01-15"],
        latest_123_before_456=["2020-02-01"],
        latest_123_in_month_after_456=["2020-04-20"],
        next_123=["2020-02-01"],
    )


def test_dynamic_index_dates_with_invalid_expression():
    with pytest.raises(InvalidExpressionError):
        StudyDefinition(
            population=patients.all(),
            earliest_123=patients.with_these_clinical_events(
                codelist([123], system="snomed"),
                returning="date",
                date_format="YYYY-MM-DD",
            ),
            latest_456_in_month_after_bar=patients.with_these_clinical_events(
                codelist([456], system="snomed"),
                on_or_before="last_day_of_month(earliest_bar) + 1 mnth",
            ),
        )


@pytest.mark.parametrize(
    "index_date,expected_event_dates",
    [
        (
            "2020-02-15",  # nhs financial year 2019-04-01 to 2020-03-31
            ["2019-05-01", "2020-02-15"],
        ),
        (
            "2017-05-15",  # nhs financial year 2017-04-01 to 2018-03-31
            ["2017-06-01", "2018-02-01"],
        ),
    ],
)
def test_nhs_financial_year_date_expressions(index_date, expected_event_dates):
    session = make_session()
    session.add_all(
        [
            # Event too early
            Patient(
                observations=[
                    Observation(effective_date="2012-12-15", snomed_concept_id=123)
                ],
            ),
            # Events in range 2019-04-01 to 2020-03-31
            Patient(
                observations=[
                    Observation(effective_date="2019-05-01", snomed_concept_id=123)
                ],
            ),
            Patient(
                observations=[
                    Observation(effective_date="2020-02-15", snomed_concept_id=123)
                ],
            ),
            # Events in range 2017-04-01 to 2018-03-31
            Patient(
                observations=[
                    Observation(effective_date="2018-02-01", snomed_concept_id=123)
                ],
            ),
            Patient(
                observations=[
                    Observation(effective_date="2017-06-01", snomed_concept_id=123)
                ],
            ),
            # Events out of range (at beginning/end of adjacent financial years)
            Patient(
                observations=[
                    Observation(effective_date="2017-03-31", snomed_concept_id=123)
                ],
            ),
            Patient(
                observations=[
                    Observation(effective_date="2018-04-01", snomed_concept_id=123)
                ],
            ),
            Patient(
                observations=[
                    Observation(effective_date="2019-03-31", snomed_concept_id=123)
                ],
            ),
            Patient(
                observations=[
                    Observation(effective_date="2020-04-01", snomed_concept_id=123)
                ],
            ),
        ]
    )
    session.commit()
    study = StudyDefinition(
        index_date=index_date,
        population=patients.with_these_clinical_events(
            codelist(["123"], system="snomed"),
            between=[
                "first_day_of_nhs_financial_year(index_date)",
                "last_day_of_nhs_financial_year(index_date)",
            ],
        ),
        event_date=patients.with_these_clinical_events(
            codelist(["123"], system="snomed"),
            returning="date",
            date_format="YYYY-MM-DD",
            between=[
                "first_day_of_nhs_financial_year(index_date)",
                "last_day_of_nhs_financial_year(index_date)",
            ],
        ),
    )
    results = study.to_dicts()
    event_dates = sorted([result["event_date"] for result in results])
    assert event_dates == expected_event_dates


@pytest.mark.parametrize(
    "index_date,expected_event_dates",
    [
        (
            "2020-08-15",  # school year 2019-09-01 to 2020-08-31
            ["2019-10-01", "2020-02-15"],
        ),
        (
            "2017-10-15",  # school year 2017-09-01 to 2018-08-31
            ["2017-09-02", "2018-08-01"],
        ),
    ],
)
def test_school_year_date_expressions(index_date, expected_event_dates):
    session = make_session()
    session.add_all(
        [
            # Event too early
            Patient(
                observations=[
                    Observation(effective_date="2016-12-15", snomed_concept_id=123)
                ],
            ),
            # Events in range 2019-09-01 to 2020-08-31
            Patient(
                observations=[
                    Observation(effective_date="2019-10-01", snomed_concept_id=123)
                ],
            ),
            Patient(
                observations=[
                    Observation(effective_date="2020-02-15", snomed_concept_id=123)
                ],
            ),
            # Events in range 2017-09-01 to 2018-08-31
            Patient(
                observations=[
                    Observation(effective_date="2018-08-01", snomed_concept_id=123)
                ],
            ),
            Patient(
                observations=[
                    Observation(effective_date="2017-09-02", snomed_concept_id=123)
                ],
            ),
            # Events out of range (at beginning/end of adjacent school years)
            Patient(
                observations=[
                    Observation(effective_date="2017-08-31", snomed_concept_id=123)
                ],
            ),
            Patient(
                observations=[
                    Observation(effective_date="2018-09-01", snomed_concept_id=123)
                ],
            ),
            Patient(
                observations=[
                    Observation(effective_date="2019-08-31", snomed_concept_id=123)
                ],
            ),
            Patient(
                observations=[
                    Observation(effective_date="2020-09-01", snomed_concept_id=123)
                ],
            ),
        ]
    )
    session.commit()
    study = StudyDefinition(
        index_date=index_date,
        population=patients.with_these_clinical_events(
            codelist(["123"], system="snomed"),
            between=[
                "first_day_of_school_year(index_date)",
                "last_day_of_school_year(index_date)",
            ],
        ),
        event_date=patients.with_these_clinical_events(
            codelist(["123"], system="snomed"),
            returning="date",
            date_format="YYYY-MM-DD",
            between=[
                "first_day_of_school_year(index_date)",
                "last_day_of_school_year(index_date)",
            ],
        ),
    )
    results = study.to_dicts()
    event_dates = sorted([result["event_date"] for result in results])
    assert event_dates == expected_event_dates


def test_truncate_patient_id():
    small_id = 123456789
    # Remove the '0x' prefix
    small_id_hex = hex(small_id)[2:]
    assert truncate_patient_id(small_id_hex) == small_id // 2

    large_id_hex = hex(987654321 + 2**100)[2:]
    assert truncate_patient_id(large_id_hex) == 576460752303423488


def test_null_observation_dates_handled_correctly():
    session = make_session()
    session.add_all(
        [
            Patient(
                observations=[
                    Observation(snomed_concept_id="10000001", effective_date=None),
                    Observation(
                        snomed_concept_id="10000002", effective_date="2020-02-05"
                    ),
                ]
            ),
            Patient(
                observations=[
                    Observation(
                        snomed_concept_id="10000001", effective_date="2020-06-12"
                    ),
                    Observation(
                        snomed_concept_id="10000002", effective_date="2021-07-02"
                    ),
                ]
            ),
        ]
    )
    session.commit()
    codes = codelist(["10000001", "10000002"], "snomedct")
    study = StudyDefinition(
        population=patients.all(),
        first_event_date=patients.with_these_clinical_events(
            codes,
            returning="date",
            find_first_match_in_period=True,
            date_format="YYYY-MM-DD",
        ),
        first_event_code=patients.with_these_clinical_events(
            codes,
            returning="code",
            find_first_match_in_period=True,
            date_format="YYYY-MM-DD",
        ),
        # This should be the same value as `event_date` but doing it this way
        # makes it use a parition query so we can test that branch
        date_of_first_code=patients.date_of(
            "first_event_code", date_format="YYYY-MM-DD"
        ),
        last_event_date=patients.with_these_clinical_events(
            codes,
            returning="date",
            find_last_match_in_period=True,
            date_format="YYYY-MM-DD",
        ),
        last_event_code=patients.with_these_clinical_events(
            codes,
            returning="code",
            find_last_match_in_period=True,
            date_format="YYYY-MM-DD",
        ),
        date_of_last_code=patients.date_of("last_event_code", date_format="YYYY-MM-DD"),
        pre2020_event_date=patients.with_these_clinical_events(
            codes,
            on_or_before="2020-01-01",
            returning="date",
            find_last_match_in_period=True,
            date_format="YYYY-MM-DD",
        ),
        pre2020_event_code=patients.with_these_clinical_events(
            codes,
            on_or_before="2020-01-01",
            returning="code",
            find_last_match_in_period=True,
            date_format="YYYY-MM-DD",
        ),
        date_of_pre2020_code=patients.date_of(
            "pre2020_event_code", date_format="YYYY-MM-DD"
        ),
    )
    assert_results(
        study.to_dicts(),
        first_event_date=["1900-01-01", "2020-06-12"],
        date_of_first_code=["1900-01-01", "2020-06-12"],
        last_event_date=["2020-02-05", "2021-07-02"],
        date_of_last_code=["2020-02-05", "2021-07-02"],
        pre2020_event_date=["1900-01-01", ""],
        date_of_pre2020_code=["1900-01-01", ""],
    )


def test_patients_died_from_any_cause_dynamic_dates():
    session = make_session()
    session.add_all(
        [
            # Not dead
            Patient(
                nhs_no="aaa",
                medications=[
                    Medication(snomed_concept_id="10", effective_date="2021-01-02"),
                ],
            ),
            # Died more than 2 weeks after antipsychotic date
            Patient(
                nhs_no="bbb",
                ONSDeath=[
                    ONSDeaths(
                        reg_stat_dod=20210201,
                        pseudonhsnumber="bbb",
                        upload_date="2021-02-02",
                    )
                ],
                medications=[
                    Medication(snomed_concept_id="10", effective_date="2021-01-02")
                ],
            ),
            # Died, no antipsychotic
            Patient(
                nhs_no="ccc",
                ONSDeath=[
                    ONSDeaths(
                        reg_stat_dod=20210115,
                        icd10u="A",
                        pseudonhsnumber="ccc",
                        upload_date="2021-02-02",
                    ),
                ],
            ),
            # Died within 2 weeks, antipsychotic before index date
            Patient(
                nhs_no="ddd",
                ONSDeath=[
                    ONSDeaths(
                        reg_stat_dod=20200115,
                        icd10u="A",
                        pseudonhsnumber="ddd",
                        upload_date="2021-02-02",
                    ),
                ],
                medications=[
                    Medication(snomed_concept_id="10", effective_date="2020-01-02"),
                ],
            ),
            # Died within 2 weeks of antipsychotic
            Patient(
                nhs_no="eee",
                ONSDeath=[
                    ONSDeaths(
                        reg_stat_dod=20210115,
                        icd10u="A",
                        pseudonhsnumber="eee",
                        upload_date="2021-02-02",
                    ),
                ],
                medications=[
                    Medication(snomed_concept_id="10", effective_date="2021-01-02"),
                ],
            ),
        ]
    )
    session.commit()
    study = StudyDefinition(
        population=patients.all(),
        index_date="2021-01-01",
        antipsychotics_date=patients.with_these_medications(
            codelist=codelist(["10"], "snomed"),
            returning="date",
            find_last_match_in_period=True,
            between=["index_date", "last_day_of_month(index_date)"],
            date_format="YYYY-MM-DD",
            return_expectations={"incidence": 0.1},
        ),
        died_2weeks_post_antipsychotic=patients.died_from_any_cause(
            between=["antipsychotics_date", "antipsychotics_date + 14 days"],
            returning="binary_flag",
        ),
    )
    assert_results(
        study.to_dicts(),
        antipsychotics_date=["2021-01-02", "2021-01-02", "", "", "2021-01-02"],
        died_2weeks_post_antipsychotic=["0", "0", "0", "0", "1"],
    )


def test_date_window_behaviour_literals():
    session = make_session()
    session.add_all(
        [
            Patient(
                observations=[
                    # This event is before the start date and is never captured
                    Observation(
                        snomed_concept_id="111", effective_date="2021-01-03T23:59:59"
                    ),
                    # These event is captured with and without the fix
                    Observation(
                        snomed_concept_id="111", effective_date="2021-01-04T00:00:00"
                    ),
                    # This event is after midnight on the end date, and is only captured with the fix
                    Observation(
                        snomed_concept_id="111", effective_date="2021-01-04T10:45:00"
                    ),
                    # This event is after the end date and is never captured
                    Observation(
                        snomed_concept_id="111", effective_date="2021-01-05T00:00:00"
                    ),
                ]
            ),
        ]
    )
    session.commit()

    study = StudyDefinition(
        population=patients.all(),
        event_count=patients.with_these_clinical_events(
            codelist(["111"], "snomedct"),
            between=["2021-01-04", "2021-01-04"],
            returning="number_of_matches_in_period",
        ),
    )

    results = study.to_dicts()
    assert results[0]["event_count"] == "2"


def test_date_window_behaviour_variable():
    session = make_session()
    session.add_all(
        [
            Patient(
                observations=[
                    # This is the last 222 event without the fix
                    Observation(
                        snomed_concept_id="2221", effective_date="2021-01-03T16:10:00"
                    ),
                    # This is the last 222 event with the fix
                    Observation(
                        snomed_concept_id="2222", effective_date="2021-01-04T16:10:00"
                    ),
                    # Thse two 111 event is on the date of 2221, but only one will be
                    # captured without the fix.
                    Observation(
                        snomed_concept_id="111", effective_date="2021-01-03T00:00:00"
                    ),
                    Observation(
                        snomed_concept_id="111", effective_date="2021-01-03T16:10:00"
                    ),
                    # These two 111 events are on the date of 2222, and both will be
                    # captured with the fix.
                    Observation(
                        snomed_concept_id="111", effective_date="2021-01-04T16:10:00"
                    ),
                    Observation(
                        snomed_concept_id="111", effective_date="2021-01-04T16:10:01"
                    ),
                ]
            ),
        ]
    )
    session.commit()

    study = StudyDefinition(
        population=patients.all(),
        last_222=patients.with_these_clinical_events(
            codelist(["2221", "2222"], "snomedct"),
            between=["2021-01-01", "2021-01-04"],
            returning="date",
            date_format="YYYY-MM-DD",
            find_last_match_in_period=True,
        ),
        event_count=patients.with_these_clinical_events(
            codelist(["111"], "snomedct"),
            between=["last_222", "last_222"],
            returning="number_of_matches_in_period",
        ),
    )

    results = study.to_dicts()
    assert results[0]["last_222"] == "2021-01-04"
    assert results[0]["event_count"] == "2"
