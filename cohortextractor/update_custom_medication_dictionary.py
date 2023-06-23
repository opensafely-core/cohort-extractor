import csv
import os
import pathlib

from .mssql_utils import mssql_dbapi_connection_from_url

CUSTOM_MEDICATION_DICTIONARY_CSV = pathlib.Path(__file__).with_name(
    "custom_medication_dictionary.csv"
)


def update_custom_medication_dictionary():
    """Update CustomMedicationDictionary table"""
    temp_database_name = os.environ["TEMP_DATABASE_NAME"]
    table = f"{temp_database_name}..CustomMedicationDictionary"

    # Transaction behaviour cribbed from
    # cohortextractor.tpp_backend.save_results_to_temporary_db
    conn = mssql_dbapi_connection_from_url(os.environ["DATABASE_URL"])
    previous_autocommit = conn.autocommit_state
    conn.autocommit(False)
    cursor = conn.cursor()
    cursor.execute(
        f"""
        IF OBJECT_ID('{table}', 'U') IS NOT NULL
            DROP TABLE {table}

        CREATE TABLE {table} (
            DMD_ID VARCHAR(50) COLLATE Latin1_General_CI_AS,
            MultilexDrug_ID VARCHAR(767),
        )
        """
    )
    cursor.executemany(
        f"INSERT INTO {table} VALUES (%s, %s)",
        get_custom_medication_dictionary(),
    )
    conn.commit()
    conn.autocommit(previous_autocommit)
    conn.close()


def get_custom_medication_dictionary():
    with CUSTOM_MEDICATION_DICTIONARY_CSV.open(newline="") as f:
        reader = csv.reader(f)
        next(reader)  # skip header row
        return [tuple(x) for x in reader]
