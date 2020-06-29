import os

from tests.test_tpp_backend import set_database_url, setup_module, setup_function
from tests.tpp_backend_setup import (
    make_session,
    Patient,
    RegistrationHistory,
    Organisation,
    Vaccination,
    MedicationIssue,
    MedicationDictionary,
    CodedEvent,
)

from cohortextractor import codelist
from cohortextractor.mssql_utils import mssql_pyodbc_connection_from_url
from cohortextractor.dashboards.vaccinations_extract import (
    patients_with_ages_and_practices_sql,
    vaccination_events_sql,
)


# Reference these imported functions to keep pyflakes happy and to make it
# clear these are functional pytest fixtures, not stray imports
set_database_url
setup_module
setup_function


def sql_to_dicts(sql):
    connection = mssql_pyodbc_connection_from_url(os.environ["DATABASE_URL"])
    cursor = connection.cursor()
    result = cursor.execute(sql)
    keys = [x[0] for x in result.description]
    # Convert all values to str as that's what will end in the CSV
    return [dict(zip(keys, map(str, row))) for row in result]


def test_patients_with_ages_and_practices_sql():
    session = make_session()
    session.add_all(
        [
            # This patient is too old and should be ignored
            Patient(DateOfBirth="2002-05-04"),
            # This patient is too young and should be ignored
            Patient(DateOfBirth="2019-10-04"),
            Patient(
                DateOfBirth="2018-10-28",
                RegistrationHistory=[
                    RegistrationHistory(
                        StartDate="2015-01-01",
                        EndDate="2021-10-01",
                        Organisation=Organisation(Organisation_ID=456),
                    ),
                ],
            ),
            Patient(
                DateOfBirth="2014-09-14",
                RegistrationHistory=[
                    RegistrationHistory(
                        StartDate="2010-01-01",
                        EndDate="2015-10-01",
                        Organisation=Organisation(Organisation_ID=123),
                    ),
                    # Deliberately overlapping registration histories
                    RegistrationHistory(
                        StartDate="2015-04-01",
                        EndDate="9999-12-31",
                        Organisation=Organisation(Organisation_ID=345),
                    ),
                ],
            ),
        ]
    )
    session.commit()
    sql = patients_with_ages_and_practices_sql(
        date_of_birth_range=("2012-01-01", "2019-06-01"), age_thresholds=[12, 24, 60],
    )
    results = sql_to_dicts(sql)
    # Note this is rounded to start of month
    assert [x["date_of_birth"] for x in results] == ["2018-10-01", "2014-09-01"]
    assert [x["practice_id_at_month_12"] for x in results] == ["456", "345"]
    assert [x["practice_id_at_month_24"] for x in results] == ["456", "345"]
    assert [x["practice_id_at_month_60"] for x in results] == ["0", "345"]


def test_vaccination_events_sql():
    session = make_session()
    session.add_all(
        [
            # This patient is too old and should be ignored
            Patient(
                DateOfBirth="2002-05-04",
                Vaccinations=[
                    Vaccination(
                        VaccinationName="Infanrix Hexa", VaccinationDate="2002-06-01",
                    )
                ],
            ),
            # This patient is too young and should be ignored
            Patient(
                DateOfBirth="2019-10-04",
                Vaccinations=[
                    Vaccination(
                        VaccinationName="Infanrix Hexa", VaccinationDate="2019-11-04",
                    )
                ],
            ),
            Patient(
                DateOfBirth="2018-10-28",
                Vaccinations=[
                    Vaccination(
                        VaccinationName="Infanrix Hexa", VaccinationDate="2018-11-01",
                    )
                ],
                MedicationIssues=[
                    MedicationIssue(
                        MedicationDictionary=MedicationDictionary(
                            DMD_ID="123", MultilexDrug_ID="123"
                        ),
                        ConsultationDate="2019-01-01",
                    ),
                ],
                CodedEvents=[CodedEvent(CTV3Code="abc", ConsultationDate="2019-06-01")],
            ),
        ]
    )
    session.commit()
    sql = vaccination_events_sql(
        date_of_birth_range=("2012-01-01", "2019-06-01"),
        tpp_vaccination_codelist=codelist(
            [("Infanrix Hexa", "dtap_hex")], system="tpp_vaccines",
        ),
        ctv3_codelist=codelist([("abc", "menb")], system="ctv3"),
        snomed_codelist=codelist([("123", "rotavirus")], system="snomed"),
    )
    results = sql_to_dicts(sql)
    result_tuples = [(x["date_given"], x["vaccine_name"]) for x in results]
    # Results are ordered by patient ID but within each patient's results the
    # order is arbitrary. To make testing easier we sort them here.
    result_tuples = sorted(result_tuples)
    assert result_tuples == [
        ("2018-11-01", "dtap_hex"),
        ("2019-01-01", "rotavirus"),
        ("2019-06-01", "menb"),
    ]
