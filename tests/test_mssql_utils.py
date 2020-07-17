import os
from cohortextractor.mssql_utils import mssql_query_to_csv_file

import pytest


def test_mssql_query_to_csv_file_does_not_append(tmp_path):
    with open(tmp_path / "output.csv", "w") as f:
        f.write("pre-existing text\n")
    mssql_query_to_csv_file(
        os.environ["TPP_DATABASE_URL"],
        "SELECT 'test_output' AS hello, 1 AS value",
        tmp_path / "output.csv",
    )
    with open(tmp_path / "output.csv", "r") as f:
        contents = f.read().strip()
    assert contents == "hello,value\ntest_output,1"


def test_late_errors_are_caught(tmp_path):
    query = """
    CREATE TABLE #test (n INTEGER)
    GO
    INSERT INTO #test VALUES (1), (2), (3), (4), (5)
    GO
    SELECT 1000 / (n - 5) AS value FROM #test ORDER BY n
    """
    with pytest.raises(ValueError) as excinfo:
        mssql_query_to_csv_file(
            os.environ["TPP_DATABASE_URL"], query, tmp_path / "output.csv",
        )
    assert "Divide by zero error" in str(excinfo.value)
    # Check that we've still got the output up until the error occured
    with open(tmp_path / "output.csv", "r") as f:
        contents = f.read().strip()
    assert contents == "value\n-250\n-333\n-500\n-1000"
