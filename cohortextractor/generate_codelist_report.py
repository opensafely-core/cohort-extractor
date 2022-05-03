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

    start_date = quote(start_date)
    end_date = quote(end_date)

    codelist = codelist_from_csv(codelist_path, "snomedct")

    queries = codelist_queries(codelist) + [
        events_query(start_date, end_date),
        practice_query(end_date),
        population_query(start_date, end_date),
        results_query(),
    ]

    connection = mssql_dbapi_connection_from_url(os.environ["DATABASE_URL"])
    cursor = connection.cursor()

    for query in queries:
        logger.debug(query)
        cursor.execute(query)

    counts = pd.DataFrame(list(cursor), columns=["code", "date", "practice", "num"])
    counts["date"] = pd.to_datetime(counts["date"])

    counts_per_code = counts.groupby("code")["num"].sum()

    # Computing counts per practice per week  is slightly more involved than computing
    # counts per code, because we need to account for weeks when a matching code is not
    # recorded at a practice.
    grouper = pd.Grouper(key="date", freq="W-MON")
    counts_per_week = counts.groupby(["practice", grouper])["num"].sum()
    new_index = pd.MultiIndex.from_product(counts_per_week.index.levels)
    counts_per_week = counts_per_week.reindex(new_index).fillna(0).astype(int)

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
    return f"""
    SELECT * INTO #events FROM (
        SELECT
            Patient_ID,
            ConceptID,
            CAST(ConsultationDate AS date) AS ConsultationDate
        FROM CodedEvent_SNOMED
        INNER JOIN #codelist
            ON CodedEvent_SNOMED.ConceptID = #codelist.code
        WHERE CAST(ConsultationDate AS date) BETWEEN {start_date} AND {end_date}
    ) t
    GROUP BY Patient_ID, ConceptID, ConsultationDate
    """


def practice_query(end_date):
    # Note that this does not quite match patients.registered_practice_as_of(end_date),
    # since a deceased patient might have been deregistered by the end date.
    #
    # In patients.registered_practice_as_of(end_date), the innermost SELECT query's
    # WHERE clause would contain an extra `AND EndDate > {end_date}`.
    return f"""
    SELECT * INTO #practice FROM (
        SELECT Patient_ID, t.Organisation_ID
        FROM (
            SELECT RegistrationHistory.Patient_ID, Organisation_ID,
            ROW_NUMBER() OVER (
                PARTITION BY RegistrationHistory.Patient_ID
                ORDER BY StartDate DESC, EndDate DESC, Registration_ID
            ) AS rownum
            FROM RegistrationHistory
            WHERE StartDate <= {end_date}
        ) t
        LEFT JOIN Organisation
        ON Organisation.Organisation_ID = t.Organisation_ID
        WHERE t.rownum = 1
    ) t
    """


def population_query(start_date, end_date):
    # We're interested in patients who are registered on end_date, or who have died
    # between start_date and end_date.
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
    SELECT
        ConceptID AS code,
        ConsultationDate AS date,
        Organisation_ID AS practice,
        COUNT(*) AS num
    FROM #events
    INNER JOIN #population
        ON #events.Patient_ID = #population.Patient_ID
    INNER JOIN #practice
        ON #population.Patient_ID = #practice.Patient_ID
    GROUP BY Organisation_ID, ConceptID, ConsultationDate
    """
