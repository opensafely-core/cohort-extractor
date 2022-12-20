import os
from unittest.mock import patch

from pymssql import OperationalError

from cohortextractor.mssql_utils import mssql_dbapi_connection_from_url
from cohortextractor.update_vmp_mapping import update_vmp_mapping


def test_update_vmp_mapping(monkeypatch):
    monkeypatch.setenv("DATABASE_URL", os.environ["TPP_DATABASE_URL"])
    monkeypatch.setenv("TEMP_DATABASE_NAME", os.environ["TPP_TEMP_DATABASE_NAME"])

    conn = mssql_dbapi_connection_from_url(os.environ["DATABASE_URL"])
    cursor = conn.cursor()
    temporary_database = os.environ["TEMP_DATABASE_NAME"]

    # Run the command and check that database contains expected mappings.
    with patch("cohortextractor.update_vmp_mapping.get_vmp_mapping") as get_vmp_mapping:
        get_vmp_mapping.return_value = [["111", "222"], ["333", "444"]]
        update_vmp_mapping()

    cursor.execute(f"SELECT * FROM {temporary_database}..VmpMapping ORDER BY id")
    assert list(cursor) == [("111", "222"), ("333", "444")]

    # Run a second time, to ensure that old mappings are removed.
    with patch("cohortextractor.update_vmp_mapping.get_vmp_mapping") as get_vmp_mapping:
        get_vmp_mapping.return_value = [["333", "444"], ["555", "666"]]
        update_vmp_mapping()

    cursor.execute(f"SELECT * FROM {temporary_database}..VmpMapping ORDER BY id")
    assert list(cursor) == [("333", "444"), ("555", "666")]

    # Now we make the INSERT blow up (by providing a prev_id that's too long).  This
    # lets us test that the transaction is rolled back correctly.
    with patch("cohortextractor.update_vmp_mapping.get_vmp_mapping") as get_vmp_mapping:
        get_vmp_mapping.return_value = [["111", "2" * 200]]
        try:
            update_vmp_mapping()
        except OperationalError:
            # This is expected.
            pass

    cursor.execute(f"SELECT * FROM {temporary_database}..VmpMapping ORDER BY id")
    assert list(cursor) == [("333", "444"), ("555", "666")]
