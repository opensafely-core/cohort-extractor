import os

from pymssql import OperationalError

from cohortextractor import update_custom_medication_dictionary
from cohortextractor.mssql_utils import mssql_dbapi_connection_from_url


def test_update_custom_medication_dictionary(tmp_path, monkeypatch):
    monkeypatch.setenv("DATABASE_URL", os.environ["TPP_DATABASE_URL"])
    monkeypatch.setenv("TEMP_DATABASE_NAME", os.environ["TPP_TEMP_DATABASE_NAME"])

    mapping_csv = tmp_path / "custom_medication_dictionary.csv"
    monkeypatch.setattr(
        update_custom_medication_dictionary,
        "CUSTOM_MEDICATION_DICTIONARY_CSV",
        mapping_csv,
    )

    conn = mssql_dbapi_connection_from_url(os.environ["DATABASE_URL"])
    cursor = conn.cursor()

    def write_mapping_csv(rows):
        mapping_csv.write_text("\n".join(",".join(row) for row in rows))  # overwrites

    def select():
        temp_database_name = os.environ["TEMP_DATABASE_NAME"]
        cursor.execute(
            f"""
            SELECT *
            FROM {temp_database_name}..CustomMedicationDictionary
            ORDER BY DMD_ID, MultilexDrug_ID
            """
        )

    # First time: Does the table contain the expected mappings?
    write_mapping_csv(
        [
            ("DMD_ID", "MultilexDrug_ID", "FullName"),
            ("111111", "a", "full name for a"),
            ("222222", "b", "full name for b"),
        ]
    )
    update_custom_medication_dictionary.update_custom_medication_dictionary()
    select()
    assert list(cursor) == [("111111", "a"), ("222222", "b")]

    # Second time: Was the old table dropped and a new table created?
    write_mapping_csv(
        [
            ("DMD_ID", "MultilexDrug_ID", "FullName"),
            ("333333", "c", "full name for c"),
            ("444444", "d", "full name for d"),
        ]
    )
    update_custom_medication_dictionary.update_custom_medication_dictionary()
    select()
    assert list(cursor) == [("333333", "c"), ("444444", "d")]

    # Third time: Force the INSERT to error, by passing a DM+D ID that's too long. Did
    # the transaction roll-back?
    write_mapping_csv(
        [
            ("DMD_ID", "MultilexDrug_ID", "FullName"),
            (f"{'5' * 60}", "e", "full name for e"),
        ],
    )
    try:
        update_custom_medication_dictionary.update_custom_medication_dictionary()
    except OperationalError:
        pass
    select()
    assert list(cursor) == [("333333", "c"), ("444444", "d")]
