import os

import pandas as pd
import structlog

from .codelistlib import codelist_from_csv
from .mssql_utils import mssql_dbapi_connection_from_url
from .tpp_backend import make_batches_of_insert_statements, quote

logger = structlog.get_logger()


def generate_codelist_report(output_dir, codelist_path, start_date, end_date):
    os.makedirs(output_dir, exist_ok=True)
    connection = mssql_dbapi_connection_from_url(os.environ["DATABASE_URL"])
    cursor = connection.cursor()

    start_date = quote(start_date)
    end_date = quote(end_date)

    generate_counts(cursor, output_dir, codelist_path, start_date, end_date)
    generate_list_sizes(cursor, output_dir, end_date)


def generate_counts(cursor, output_dir, codelist_path, start_date, end_date):
    """Generate a pair of CSV files reporting usage of codes in given codelist.

        * counts_per_code counts how many times each code appears in the given timeframe
        * counts_per_week_per_practice counts how many times all the codes appear in
            each week in the given timeframe, for each practice

    Weeks begin on a Monday, and a code appearing on (say) a Wednesday is counted as
    belonging to the following Monday.
    """

    codelist = codelist_from_csv(codelist_path, "snomedct")

    queries = codelist_queries(codelist) + [
        events_query(start_date, end_date),
        most_recent_practice_query(end_date),
        population_query(start_date, end_date),
        results_query(),
    ]

    for query in queries:
        logger.debug(query)
        cursor.execute(query)

    counts = pd.DataFrame(list(cursor), columns=["code", "date", "practice", "num"])
    counts["date"] = pd.to_datetime(counts["date"])

    counts_per_code = counts.groupby("code")["num"].sum()

    # Computing counts per practice per week  is slightly more involved than computing
    # counts per code, because we need to account for weeks when a matching code is not
    # recorded at a practice.
    week_grouper = pd.Grouper(key="date", freq="W-MON")
    counts_per_week_per_practice = counts.groupby(["practice", week_grouper])[
        "num"
    ].sum()
    new_index = pd.MultiIndex.from_product(counts_per_week_per_practice.index.levels)
    counts_per_week_per_practice = (
        counts_per_week_per_practice.reindex(new_index).fillna(0).astype(int)
    )

    counts_per_code.to_csv(os.path.join(output_dir, "counts_per_code.csv"))
    counts_per_week_per_practice.to_csv(
        os.path.join(output_dir, "counts_per_week_per_practice.csv")
    )


def generate_list_sizes(cursor, output_dir, end_date):
    """Generate a CSV file reporting the number of patients registered at each practice
    on the end_date.

    This is to be used as the denominator for deciles charts.  It will lead to some odd
    rates for practices where the population has changed a lot, but is acceptable while
    we do not identify individual practices.

    See https://github.com/opensafely-core/interactive.opensafely.org/issues/76 for
    further discussion.
    """

    query = f"""
    SELECT Organisation_ID, COUNT(*)
    FROM RegistrationHistory
    WHERE StartDate <= {end_date} AND EndDate > {end_date}
    GROUP BY Organisation_ID
    """
    logger.debug(query)
    cursor.execute(query)
    list_sizes = pd.DataFrame(list(cursor), columns=["practice", "list_size"])
    list_sizes.to_csv(os.path.join(output_dir, "list_sizes.csv"), index=False)


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


def most_recent_practice_query(end_date):
    # Note that this does not quite match patients.registered_practice_as_of(end_date),
    # since a deceased patient might have been deregistered by the end date.
    #
    # In patients.registered_practice_as_of(end_date), the innermost SELECT query's
    # WHERE clause would contain an extra `AND EndDate > {end_date}`.
    return f"""
    SELECT * INTO #practice FROM (
        SELECT Patient_ID, Organisation_ID
        FROM (
            SELECT RegistrationHistory.Patient_ID, Organisation_ID,
            ROW_NUMBER() OVER (
                PARTITION BY RegistrationHistory.Patient_ID
                ORDER BY StartDate DESC, EndDate DESC, Registration_ID
            ) AS rownum
            FROM RegistrationHistory
            WHERE StartDate <= {end_date}
        ) t
        WHERE rownum = 1
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
