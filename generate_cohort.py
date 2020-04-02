"""This module should be replaced by the thing Dave is writing which
will generate data from a series of function calls



"""
from contextlib import contextmanager
import requests
import os
import pyodbc
import datetime
import pandas as pd


@contextmanager
def closing_connection():
    server = f"{os.environ['DB_HOST']},1433"
    database = os.environ["DB_NAME"]
    username = "SA"
    password = os.environ["DB_PASS"]
    dsn = (
        "DRIVER={ODBC Driver 17 for SQL Server};SERVER="
        + server
        + ";DATABASE="
        + database
        + ";UID="
        + username
        + ";PWD="
        + password
    )
    cnxn = pyodbc.connect(dsn)
    yield cnxn
    cnxn.close()


def sql_to_df(sql, params=[]):
    with closing_connection() as cnxn:
        df = pd.read_sql(sql, cnxn, params=params)
    return df


def patients_with_age_condition(direction, age):
    allowed_directions = [">", "<", ">=", "<="]
    assert (
        direction in allowed_directions
    ), f"direction must be one of {allowed_directions}"
    today = datetime.date.today().strftime("%Y-%m-%d")
    return sql_to_df(
        f"""
        SELECT
          Patient_ID, DATEDIFF(year, DateOfBirth, ?) AS age
        FROM
          Patient
        WHERE
          DATEDIFF(year, DateOfBirth, ?) {direction} ?""",
        params=[today, today, age],
    )


def main():
    df = patients_with_age_condition("<", 70)
    target_path = "analysis/input.csv"
    df.to_csv(target_path)
    print(f"Data written to {target_path}")


if __name__ == "__main__":
    main()
