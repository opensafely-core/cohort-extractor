import os

import requests

from .mssql_utils import mssql_dbapi_connection_from_url


def update_vmp_mapping():
    """Update VmpMapping table with latest data from OpenCodelists"""

    mapping = [tuple(record) for record in get_vmp_mapping()]
    temporary_database = os.environ["TEMP_DATABASE_NAME"]
    conn = mssql_dbapi_connection_from_url(os.environ["DATABASE_URL"])
    # Transaction behaviour cribbed from
    # cohortextractor.tpp_backend.save_results_to_temporary_db
    previous_autocommit = conn.autocommit_state
    conn.autocommit(False)
    cursor = conn.cursor()
    cursor.execute(
        f"""
        IF OBJECT_ID('{temporary_database}..VmpMapping', 'U') IS NOT NULL
            DROP TABLE {temporary_database}..VmpMapping

        CREATE TABLE {temporary_database}..VmpMapping (
            id VARCHAR(18) COLLATE Latin1_General_CI_AS,
            prev_id VARCHAR(18) COLLATE Latin1_General_CI_AS,
        )
        """
    )
    cursor.executemany(
        f"INSERT INTO {temporary_database}..VmpMapping VALUES (%s, %s)",
        mapping,
    )
    conn.commit()
    conn.autocommit(previous_autocommit)
    conn.close()


def get_vmp_mapping():
    rsp = requests.get("https://opencodelists-proxy.opensafely.org/api/v1/dmd-mapping/")
    rsp.raise_for_status()
    return rsp.json()
