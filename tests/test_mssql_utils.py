import os
from cohortextractor.mssql_utils import mssql_query_to_csv_file


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
