import os

import pytest

from tests.emis_backend_setup import make_database, make_session
from tests.emis_backend_setup import Patient

from datalab_cohorts import (
    StudyDefinition,
    patients,
)


@pytest.fixture(autouse=True)
def set_database_url(monkeypatch):
    # The StudyDefinition code expects a single DATABASE_URL to tell it where
    # to connect to, but the test environment needs to supply multiple
    # connections (one for each backend type) so we copy the value in here
    if "EMIS_DATABASE_URL" in os.environ:
        monkeypatch.setenv("DATABASE_URL", os.environ["EMIS_DATABASE_URL"])


def setup_module(module):
    make_database()


def setup_function(function):
    """
    Ensure test database is empty
    """
    session = make_session()
    session.query(Patient).delete()
    session.commit()


def test_basic_end_to_end_fixture_creation_and_retrieval():
    session = make_session()
    session.add_all(
        [
            Patient(DateOfBirth="1980-01-01", Sex="M"),
            Patient(DateOfBirth="1990-01-01", Sex="F"),
        ]
    )
    session.commit()
    study = StudyDefinition(population=patients.all(), sex=patients.sex())
    connection = study.backend.get_db_connection()
    cursor = connection.cursor()
    cursor.execute("SELECT Sex FROM Patient ORDER BY DateOfBirth")
    results = list(cursor.fetchall())
    assert results == [["M"], ["F"]]
