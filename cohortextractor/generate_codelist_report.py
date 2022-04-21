import os

import pandas as pd
import structlog

from .codelistlib import codelist_from_csv
from .mssql_utils import mssql_dbapi_connection_from_url
from .tpp_backend import make_batches_of_insert_statements, quote

logger = structlog.get_logger()


def generate_codelist_report(output_dir, codelist_path, start_date, end_date):
    """
    Generate a pair of CSV files reporting usage of codes in given codelist.

        * counts_per_code counts how many times each code appears in the given timeframe
        * counts_per_week counts how many times all the codes appear in each week in the
            given timeframe

    Weeks begin on a Monday, and a code appearing on (say) a Wednesday is counted as
    belonging to the following Monday.
    """

    codelist = codelist_from_csv(codelist_path, "snomedct")

    queries = codelist_queries(codelist) + [
        events_query(start_date, end_date),
        population_query(start_date, end_date),
        results_query(),
    ]

    connection = mssql_dbapi_connection_from_url(os.environ["DATABASE_URL"])
    cursor = connection.cursor()

    for query in queries:
        logger.debug(query)
        cursor.execute(query)

    counts = pd.DataFrame(list(cursor), columns=["code", "date", "num"])

    counts_per_code = counts.groupby("code")["num"].sum()
    counts_per_week = counts.groupby(pd.Grouper(key="date", freq="W-MON"))["num"].sum()

    os.makedirs(output_dir, exist_ok=True)

    counts_per_code.to_csv(os.path.join(output_dir, "counts_per_code.csv"))
    counts_per_week.to_csv(os.path.join(output_dir, "counts_per_week.csv"))


def codelist_queries(codelist):
    # These are SNOMED-specific values
    collation = "Latin1_General_BIN"
    max_code_len = 18

    queries = [
        f"""
        CREATE TABLE #codelist (
          code VARCHAR({max_code_len}) COLLATE {collation},
          category VARCHAR(MAX)
        )
        """
    ]
    rows = [[code, ""] for code in codelist]
    queries += make_batches_of_insert_statements(
        "#codelist", ("code", "category"), rows
    )
    return queries


def events_query(start_date, end_date):
    start_date = quote(start_date)
    end_date = quote(end_date)
    return f"""
    SELECT * INTO #events FROM (
        SELECT Patient_ID, ConceptID, ConsultationDate
        FROM CodedEvent_SNOMED
        INNER JOIN #codelist
            ON CodedEvent_SNOMED.ConceptID = #codelist.code
        WHERE ConsultationDate BETWEEN {start_date} AND {end_date}
    ) t
    """


def population_query(start_date, end_date):
    # We're interested in patients who are registered on end_date, or who have died
    # between start_date and end_date.
    start_date = quote(start_date)
    end_date = quote(end_date)
    return f"""
    SELECT * INTO #population FROM (
        SELECT DISTINCT Patient.Patient_ID
        FROM Patient
        INNER JOIN RegistrationHistory
            ON RegistrationHistory.Patient_ID = Patient.Patient_ID
        INNER JOIN Organisation
            ON RegistrationHistory.Organisation_ID = Organisation.Organisation_ID
        WHERE (StartDate <= {end_date} AND EndDate > {end_date})
           OR (DateOfDeath BETWEEN {start_date} AND {end_date})
    ) t
    """


def results_query():
    return """
    SELECT ConceptID AS code, ConsultationDate AS date, COUNT(*) AS num
    FROM #events
    INNER JOIN #population
        ON #events.Patient_ID = #population.Patient_ID
    GROUP BY ConceptID, ConsultationDate
    """
