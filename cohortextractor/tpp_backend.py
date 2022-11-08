import datetime
import enum
import hashlib
import math
import os
import re
import uuid

import pandas
import structlog

from .csv_utils import is_csv_filename, write_rows_to_csv
from .date_expressions import MSSQLDateFormatter
from .expressions import format_expression
from .log_utils import LoggingDatabaseConnection, log_execution_time, log_stats
from .mssql_utils import (
    mssql_connection_params_from_url,
    mssql_dbapi_connection_from_url,
    mssql_fetch_table,
)
from .ons_cis_utils import ONS_CIS_CATEGORY_COLUMNS, ONS_CIS_COLUMN_MAPPINGS
from .pandas_utils import dataframe_from_rows, dataframe_to_file
from .process_covariate_definitions import ISARIC_COLUMN_MAPPINGS
from .therapeutics_utils import ALLOWED_RISK_GROUPS

logger = structlog.get_logger()


# The batch size was chosen through a bit of unscientific trial-and-error and some
# guesswork. It may well need changing in future.
BATCH_SIZE = 32000

# Retry six times over ~90 minutes.
RETRIES = 6
SLEEP = 4
BACKOFF_FACTOR = 4


class TPPBackend:
    _db_connection = None
    _current_column_name = None

    def __init__(self, database_url, covariate_definitions, temporary_database=None):
        self.database_url = database_url
        self.covariate_definitions = covariate_definitions
        self.temporary_database = temporary_database
        self.next_temp_table_id = 1
        self._therapeutics_table_name = None
        self._ons_cis_table_name = None
        if self.covariate_definitions:
            self.queries = self.get_queries(self.covariate_definitions)
        else:
            self.queries = []
        self.truncate_sql_logs = False

    def to_file(self, filename):
        queries = list(self.queries)
        # If we have a temporary database available we write results to a table
        # there, download them, and then delete the table. This allows us to
        # resume in the case of a failed download without rerunning the whole
        # query
        if self.temporary_database:
            output_table = self.save_results_to_temporary_db(queries)
        else:
            output_table = "#final_output"
            queries[-1] = (
                f"-- Writing results into {output_table}\n"
                f"SELECT * INTO {output_table} FROM ({queries[-1]}) t"
            )
            queries.append(f"CREATE INDEX ix_patient_id ON {output_table} (patient_id)")
            self.execute_queries(queries)

        results = mssql_fetch_table(
            get_cursor=self._get_cursor,
            table=output_table,
            key_column="patient_id",
            batch_size=BATCH_SIZE,
            retries=RETRIES,
            sleep=SLEEP,
            backoff_factor=BACKOFF_FACTOR,
        )

        # Wrap the results stream in a function which captures unique IDs and
        # logs progress
        unique_ids = set()
        total_rows = 0

        def check_ids_and_log(results):
            risk_group_variables = self.get_therapeutic_risk_groups()
            nonlocal total_rows
            headers = next(results)
            id_column_index = headers.index("patient_id")
            yield headers
            for row in results:
                if risk_group_variables:
                    row = self._clean_risk_groups(row, headers, risk_group_variables)
                unique_ids.add(row[id_column_index])
                total_rows += 1
                if total_rows % 1000000 == 0:
                    logger.info(f"Downloaded {total_rows} results")
                yield row
            logger.info(f"Downloaded {total_rows} results")

        results = check_ids_and_log(results)

        # Special handling for CSV as we can stream this directly to disk
        # without building a dataframe in memory
        if is_csv_filename(filename):
            with log_execution_time(
                logger, description=f"write_rows_to_csv {filename}"
            ):
                write_rows_to_csv(results, filename)
        else:
            with log_execution_time(
                logger, description=f"Create df and write dataframe_to_file {filename}"
            ):
                df = dataframe_from_rows(self.covariate_definitions, results)
                dataframe_to_file(df, filename)

        self.execute_queries(
            [f"-- Deleting '{output_table}'\nDROP TABLE {output_table}"]
        )

        duplicates = total_rows - len(unique_ids)
        if duplicates != 0:
            raise RuntimeError(f"Duplicate IDs found ({duplicates} rows)")

    def _get_cursor(self):
        # If we've written results to a temporary database then we make a
        # new connection each time we retry, which can fix issues with
        # dropped connections. If we haven't then we're relying on
        # session-scoped temporary tables which means we can't reconnect
        # without losing everything
        force_reconnect = bool(self.temporary_database)
        return self.get_db_connection(force_reconnect=force_reconnect).cursor()

    def _clean_risk_groups(self, row, keys, risk_group_variables):
        """
        Check that risk group variables only contain verified allowed risk
        groups, and remove duplicates
        """
        indices = [keys.index(variable_name) for variable_name in risk_group_variables]
        row = list(row)

        for index in indices:
            risk_groups = row[index]
            cleaned_groups = ",".join(
                {
                    group if group.lower() in ALLOWED_RISK_GROUPS else "other"
                    for group in risk_groups.split(",")
                }
            )
            row[index] = cleaned_groups
        return tuple(row)

    def to_dicts(self, convert_to_strings=True):
        result = self.execute_queries(self.queries)
        keys = [x[0] for x in result.description]

        # This checks any risk group variables and replaces disallowed values
        risk_group_variables = self.get_therapeutic_risk_groups()

        output = []

        for row in result:
            if risk_group_variables:
                row = self._clean_risk_groups(row, keys, risk_group_variables)
            if convert_to_strings:
                # Convert all values to str as that's what will end in a CSV
                row = map(str, row)
            output.append(dict(zip(keys, row)))

        unique_ids = set(item["patient_id"] for item in output)
        duplicates = len(output) - len(unique_ids)
        if duplicates != 0:
            raise RuntimeError(f"Duplicate IDs found ({duplicates} rows)")
        return output

    def to_sql(self):
        """
        Generate a single SQL string.

        Useful for debugging, optimising, etc.
        """
        return "\nGO\n\n".join(self.queries)

    def save_results_to_temporary_db(self, queries):
        """
        Sometimes there are glitches (network issues?) which occur when
        downloading large result sets. To avoid having to recompute these each
        time we can write the results to a table which we only delete once
        we've fully downloaded its contents. If the download is interrupted
        then subsequent runs will pick up the table and download it without
        having to re-run all the queries.
        """
        assert self.temporary_database
        # We're using the hash of all the queries and the database name as a
        # cache key. Obviously this doesn't take into account the fact that the
        # data itself may change, but for our purposes this doesn't matter:
        # this is designed to be a very short-lived cache which is deleted as
        # soon as the data is successfully downloaded. We need to include the
        # database name because a single server may contain multiple databases
        # (e.g full data and sample data) which share a single temporary
        # database.
        hash_elements = queries + [
            mssql_connection_params_from_url(self.database_url)["database"]
        ]
        query_hash = hashlib.sha1("\n".join(hash_elements).encode("utf8")).hexdigest()
        output_table = f"{self.temporary_database}..DataExtract_{query_hash}"
        logger.info(f"Checking for existing results in '{output_table}'")
        if not self.table_exists(output_table):
            logger.info(
                "No existing results found, running queries to generate new results"
            )
            # We want to raise an error now, rather than waiting until we've
            # run all the other queries
            self.assert_database_exists_and_is_writable(self.temporary_database)
            queries = list(queries)
            final_query = queries.pop()
            self.execute_queries(queries)
            # We need to run the final query in a transaction so that we don't end up
            # with an empty output table in the event that the query fails. See:
            # https://docs.microsoft.com/en-us/sql/t-sql/queries/select-into-clause-transact-sql?view=sql-server-ver15#remarks
            conn = self.get_db_connection()
            logger.info(f"Writing results into temporary table '{output_table}'")
            # pymssql's autocommit implementation is different to CTDS and MS
            # pyodbc. Firstly, it's a method rather than a property.  Secondly,
            # when autocommit is off, it implicity starts a transaction from
            # the client, so we do not need to do it. CTDS do not seem to do
            # this, which means we would have to begin it manually.
            previous_autocommit = conn.autocommit_state
            conn.autocommit(False)
            cursor = conn.cursor()
            cursor.execute(f"SELECT * INTO {output_table} FROM ({final_query}) t")
            cursor.execute(f"CREATE INDEX ix_patient_id ON {output_table} (patient_id)")
            conn.commit()
            conn.autocommit(previous_autocommit)
            logger.info(f"Downloading results from '{output_table}'")
        else:
            logger.info(f"Downloading results from previous run in '{output_table}'")
        return output_table

    def table_exists(self, table_name):
        # We don't have access to sys.tables so this seems like the simplest
        # way of testing for table existence
        cursor = self.get_db_connection().cursor()
        try:
            cursor.execute(f"SELECT 1 FROM {table_name}")
            list(cursor)
            return True
        # Because we don't want to depend on a specific database driver we
        # can't catch a specific exception class here
        except Exception as e:
            if "Invalid object name" in str(e):
                return False
            else:
                raise

    def assert_database_exists_and_is_writable(self, db_name):
        # As above, there's probably a better way of doing this
        test_table = f"{db_name}..test_{uuid.uuid4().hex}"
        cursor = self.get_db_connection().cursor()
        try:
            cursor.execute(f"SELECT * INTO {test_table} FROM (select 1 as foo) t")
            cursor.execute(f"DROP TABLE {test_table}")
        # Because we don't want to depend on a specific database driver we
        # can't catch a specific exception class here
        except Exception as e:
            if "Database does not exist" in str(e):
                raise RuntimeError(f"Temporary database '{db_name}' does not exist")
            else:
                raise

    def get_db_connection(self, force_reconnect=False):
        if self._db_connection:
            if not force_reconnect:
                return self._db_connection
            else:
                self._db_connection.close()
        self._db_connection = LoggingDatabaseConnection(
            logger,
            mssql_dbapi_connection_from_url(self.database_url),
            truncate=self.truncate_sql_logs,
            time_stats=True,
        )
        return self._db_connection

    def close(self):
        if self._db_connection:
            self._db_connection.close()
        self._db_connection = None

    def get_therapeutic_risk_groups(self):
        therapeutics_risk_group_variables = set()
        for name, (query_type, query_args) in self.covariate_definitions.items():
            if (
                query_type == "with_covid_therapeutics"
                and query_args["returning"] == "risk_group"
            ):
                therapeutics_risk_group_variables.add(name)
        return therapeutics_risk_group_variables

    def get_queries(self, covariate_definitions):
        output_columns = {}
        table_queries = {}
        for name, (query_type, query_args) in covariate_definitions.items():
            # So we can safely mutate these below
            query_args = query_args.copy()
            # These arguments are not used in generating column data and the
            # corresponding functions do not accept them
            query_args.pop("return_expectations", None)
            is_hidden = query_args.pop("hidden", False)
            # Fixed values are the simplest case
            if query_type == "fixed_value":
                output_columns[name] = self.get_fixed_value_expression(**query_args)
            # `categorised_as` columns don't generate their own table query,
            # they're just a CASE expression over columns generated by other
            # queries
            elif query_type == "categorised_as":
                output_columns[name] = self.get_case_expression(
                    output_columns, **query_args
                )
            # `value_from` columns also don't generate a table, they just take
            # a value from another table
            elif query_type == "value_from":
                assert query_args["source"] in table_queries
                output_columns[name] = self.get_column_expression(**query_args)
            # As do `aggregate_of` columns
            elif query_type == "aggregate_of":
                output_columns[name] = self.get_aggregate_expression(
                    output_columns, **query_args
                )
            else:
                column_args = pop_keys_from_dict(
                    query_args, ["column_type", "date_format"]
                )
                sql_list = self.get_queries_for_column(
                    name, query_type, query_args, output_columns
                )
                # Wrap the final SELECT query so that it writes its results
                # into the appropriate temporary table
                sql_list[-1] = (
                    f"-- Query for {name}\n"
                    f"SELECT * INTO #{name} FROM ({sql_list[-1]}) t"
                )
                # Add the index query
                sql_list.append(
                    f"CREATE CLUSTERED INDEX patient_id_ix ON #{name} (patient_id)"
                )
                table_queries[name] = sql_list
                # The first column should always be patient_id so we can join on it
                output_columns[name] = self.get_column_expression(
                    source=name,
                    returning=query_args.get("returning", "value"),
                    **column_args,
                )
            output_columns[name].is_hidden = is_hidden
        # If the population query defines its own temporary table then we use
        # that as the primary table to query against and left join everything
        # else against that. Otherwise, we use the `Patient` table.
        if "population" in table_queries:
            primary_table = "#population"
            patient_id_expr = ColumnExpression("#population.patient_id")
        else:
            primary_table = "Patient"
            patient_id_expr = ColumnExpression("Patient.Patient_ID")
        # Insert `patient_id` as the first column
        output_columns = dict(patient_id=patient_id_expr, **output_columns)
        output_columns_str = ",\n          ".join(
            f"{expr} AS [{name}]"
            for (name, expr) in output_columns.items()
            if not expr.is_hidden and name != "population"
        )
        joins = [
            f"LEFT JOIN #{name} ON #{name}.patient_id = {patient_id_expr}"
            for name in table_queries
            if name != "population"
        ]
        joins_str = "\n          ".join(joins)
        joined_output_query = f"""
        -- Join all columns for final output
        SELECT
          {output_columns_str}
        FROM
          {primary_table}
          {joins_str}
        WHERE {output_columns["population"]} = 1
        """
        all_queries = []
        for sql_list in table_queries.values():
            all_queries.extend(sql_list)
        all_queries.append(joined_output_query)

        log_stats(
            logger,
            output_column_count=len(output_columns),
            table_count=len(table_queries),
            table_joins_count=len(joins),
        )
        return all_queries

    def get_column_expression(self, column_type, source, returning, date_format=None):
        default_value = self.get_default_value_for_type(column_type)
        # Zero is a legitimate IMD return value so we can't use it to indicate NULL.
        # Instead we use -1, which matches the value used in the database when there's
        # an address record with an unknown IMD. Obviously implementing this is a
        # special case here is terrible, but there's no other way of doing it without
        # serious refactoring elsewhere.
        if returning == "index_of_multiple_deprivation":
            default_value = -1
        column_expr = f"#{source}.{escape_identifer(returning)}"
        if column_type == "date":
            column_expr = truncate_date(column_expr, date_format)
        return ColumnExpression(
            f"ISNULL({column_expr}, {quote(default_value)})",
            type=column_type,
            default_value=default_value,
            source_tables=[f"#{source}"],
            date_format=date_format,
        )

    def get_fixed_value_expression(self, value, column_type, date_format=None):
        return ColumnExpression(
            quote(value, reformat_dates=False),
            type=column_type,
            default_value=self.get_default_value_for_type(column_type),
            source_tables=[],
            date_format=date_format,
        )

    def get_default_value_for_type(self, column_type):
        if column_type == "date":
            return ""
        elif column_type == "str":
            return ""
        elif column_type == "bool":
            return 0
        elif column_type == "int":
            return 0
        elif column_type == "float":
            return 0.0
        else:
            raise ValueError(f"Unhandled column type: {column_type}")

    def get_case_expression(
        self, other_columns, column_type, category_definitions, date_format=None
    ):
        category_definitions = category_definitions.copy()
        defaults = [k for (k, v) in category_definitions.items() if v == "DEFAULT"]
        if len(defaults) > 1:
            raise ValueError("At most one default category can be defined")
        if len(defaults) == 1:
            default_value = defaults[0]
            category_definitions.pop(default_value)
        else:
            raise ValueError(
                "At least one category must be given the definition 'DEFAULT'"
            )

        # We pass the `reformat_dates=False` option to the quoting function
        # here to preserve date-like strings in the user-supplied ISO format,
        # as opposed to converting to MSSQL-friendly format which we otherwise
        # do by default. The distinction here is between dates used as inputs
        # and dates used as outputs. We always need to supply input dates in a
        # format which will be consistently parsed by MSSQL indepent of locale
        # settings (amazingly, this does not include ISO format). But we always
        # want the dates we output to be in ISO format. In almost all cases
        # user-supplied dates are functioning as inputs, which is why
        # reformatting is our default behaviour; but in this context they
        # function as outputs so we need to do something different. (Note that
        # if these outputs later go on to be supplied as inputs to other
        # functions then the `date_expressions` code will ensure they are
        # parsed correctly.)
        def quote_category(value):
            return quote(value, reformat_dates=False)

        # For each column already defined, determine its corresponding "empty"
        # value (i.e. the default value for that column's type). This allows us
        # to support implicit boolean conversion because we know what the
        # "falsey" value for each column should be.
        empty_value_map = {
            name: column.default_value for name, column in other_columns.items()
        }
        clauses = []
        tables_used = set()
        for category, expression in category_definitions.items():
            # The column references in the supplied expression need to be
            # rewritten to ensure they refer to the correct CTE. The formatting
            # function also ensures that the expression matches the very
            # limited subset of SQL we support here.
            formatted_expression, names_used = format_expression(
                expression, other_columns, empty_value_map=empty_value_map
            )
            clauses.append(
                f"WHEN ({formatted_expression}) THEN {quote_category(category)}"
            )
            # Record all the source tables used in evaluating the expression
            for name in names_used:
                tables_used.update(other_columns[name].source_tables)

        return ColumnExpression(
            f"CASE {' '.join(clauses)} ELSE {quote_category(default_value)} END",
            type=column_type,
            # Note, confusingly, this is not the same as the `default_value`
            # used above. Above it refers to the value the case-expression will
            # default to in case of no match. Below it refers to the "empty"
            # value for the column type which is almost always the empty string
            # apart from bools and ints where it's zero.
            default_value=self.get_default_value_for_type(column_type),
            source_tables=list(tables_used),
            date_format="YYYY-MM-DD" if column_type == "date" else None,
        )

    def get_aggregate_expression(
        self, other_columns, column_type, column_names, aggregate_function
    ):
        assert aggregate_function in ("MIN", "MAX")
        default_value = self.get_default_value_for_type(column_type)
        # In other databases we could use GREATEST/LEAST to aggregate over
        # columns, but for MSSQL we need to use this Table Value Constructor
        # trick: https://stackoverflow.com/a/6871572
        components = ", ".join(f"({other_columns[name]})" for name in column_names)
        aggregate_expression = (
            f"SELECT {aggregate_function}(value)"
            f" FROM (VALUES {components}) AS _table(value)"
            # This is slightly awkward: MIN and MAX ignore NULL values which is
            # the behaviour we want here. For instance, given a column like:
            #
            #   minimum_of("covid_test_date", "hosptial_admission_date")
            #
            # We want this value to be equal to "covid_test_date" for patients
            # which have not been admitted to hospital (i.e. patients for which
            # "hospital_admission_date" is NULL).
            #
            # However, the values we have here have already been passed through
            # the `ISNULL` function to replace NULLs with a default value
            # (which for dates is the empty string). This means that if we just
            # took the minimum over these values in the example above, we'd get
            # the empty string from "hosptial_admission_date" rather than the
            # value in "covid_test_date".
            #
            # To workaround this we add a WHERE clause to filter out any
            # default values (essentially treating them as if they were NULL).
            # This gives us the result we want but it does mean we can't
            # distinguish e.g. a recorded value of 0.0 from a missing value.
            # This, however, is a general problem with the way we handle NULLs
            # in our system, and so we're not introducing any new difficulty
            # here.  (It's also unlikely to be a problem in practice.)
            f" WHERE value != {quote(default_value)}"
        )
        # Keep track of all source tables used in evaluating this aggregate
        tables_used = set()
        for name in column_names:
            tables_used.update(other_columns[name].source_tables)
        return ColumnExpression(
            f"ISNULL(({aggregate_expression}), {quote(default_value)})",
            type=column_type,
            default_value=default_value,
            source_tables=list(tables_used),
            # It's already been checked that date_format is consistent across
            # the source columns, so we just grab the first one and use the
            # date_format from that
            date_format=other_columns[column_names[0]].date_format,
        )

    def execute_queries(self, queries):
        cursor = self.get_db_connection().cursor()
        for query in queries:
            comment_match = re.match(r"^\s*\-\-\s*(.+)\n", query)
            if comment_match:
                event_name = comment_match.group(1)
                logger.info(f"Running: {event_name}")
            else:
                event_name = None
            cursor.execute(query, log_desc=event_name)
        return cursor

    def get_queries_for_column(
        self, column_name, query_type, query_args, output_columns
    ):
        method_name = f"patients_{query_type}"
        method = getattr(self, method_name)
        # We need to make available the SQL expression for each column in the
        # output so far in case date expressions in the current column need to
        # refer to these
        self.output_columns = output_columns
        # Keep track of the current column name for debugging purposes
        self._current_column_name = column_name
        return_value = method(**query_args)
        self._current_column_name = None
        # We want to allow the query methods to return just a single SQL string
        # which we automatically wrap in a list
        if isinstance(return_value, str):
            return_value = [return_value]
        return return_value

    def create_codelist_table(self, codelist, case_sensitive=True):
        table_name = self.get_temp_table_name("codelist")
        if codelist.has_categories:
            values = list(codelist)
        else:
            values = [(code, "") for code in codelist]
        # Depending on the case-sensitivity of the code system the columns in question
        # use different collations and we need to use a matching one here
        collation = "Latin1_General_BIN" if case_sensitive else "Latin1_General_CI_AS"
        max_code_len = max(len(code) for (code, category) in values)
        queries = [
            f"""
            -- Uploading codelist for {self._current_column_name}
            CREATE TABLE {table_name} (
              code VARCHAR({max_code_len}) COLLATE {collation},
              category VARCHAR(MAX)
            )
            """
        ]
        queries += make_batches_of_insert_statements(
            table_name, ("code", "category"), values
        )
        return table_name, queries

    def get_temp_table_name(self, suffix):
        # The hash prefix indicates a temporary table
        table_name = f"#tmp{self.next_temp_table_id}_"
        self.next_temp_table_id += 1
        # We include the current column name if available for ease of debugging
        if self._current_column_name:
            table_name += f"{self._current_column_name}_"
        table_name += suffix
        return table_name

    def get_date_condition(self, table, date_expr, between):
        """
        Takes a table name, an SQL expression representing a date (which can
        just be a column name on the table, or something more complicated) and
        a date interval.

        Returns two fragements of SQL: a "condition" and a "join"

        The condition is SQL which evaluates true when `date_expr` is in the
        supplied period.

        The join provides the (possibly empty) JOINs which need to be appended
        to "table" in order to evaluate the condition.
        """
        if between is None:
            between = (None, None)
        min_date, max_date = between
        min_date_expr, join_tables1 = self.date_ref_to_sql_expr(min_date)
        max_date_expr, join_tables2 = self.date_ref_to_sql_expr(max_date)
        date_expr = MSSQLDateFormatter.cast_as_date(date_expr)
        min_date_expr = MSSQLDateFormatter.cast_as_date(min_date_expr)
        max_date_expr = MSSQLDateFormatter.cast_as_date(max_date_expr)
        joins = [
            f"LEFT JOIN {join_table}\n"
            f"ON {join_table}.patient_id = {table}.patient_id"
            for join_table in set(join_tables1 + join_tables2)
        ]
        join_str = "\n".join(joins)
        if min_date_expr is not None and max_date_expr is not None:
            return (
                f"{date_expr} BETWEEN {min_date_expr} AND {max_date_expr}",
                join_str,
            )
        elif min_date_expr is not None:
            return f"{date_expr} >= {min_date_expr}", join_str
        elif max_date_expr is not None:
            return f"{date_expr} <= {max_date_expr}", join_str
        else:
            return "1=1", join_str

    def get_date_sql(self, table, *date_expressions):
        """
        Given a table name and one or more date expressions return the
        corresponding SQL expressions followed by a fragment of SQL supplying
        any necessary JOINs
        """
        all_join_tables = set()
        sql_expressions = []
        for date_expression in date_expressions:
            assert date_expression is not None
            sql_expression, join_tables = self.date_ref_to_sql_expr(date_expression)
            sql_expressions.append(sql_expression)
            all_join_tables.update(join_tables)
        joins = [
            f"LEFT JOIN {join_table}\n"
            f"ON {join_table}.patient_id = {table}.patient_id"
            for join_table in all_join_tables
        ]
        join_str = "\n".join(joins)
        return (*sql_expressions, join_str)

    def date_ref_to_sql_expr(self, date):
        """
        Given a date reference return its corresponding SQL expression,
        together with a list of any tables to which this expression refers
        """
        if date is None:
            return None, []
        # Simple date literals
        if is_iso_date(date):
            return quote(date), []
        # More complicated date expressions which reference other tables
        formatter = MSSQLDateFormatter(self.output_columns)
        date_expr, column_name = formatter(date)
        tables = self.output_columns[column_name].source_tables
        return date_expr, tables

    def patients_age_as_of(self, reference_date):
        date_expr, date_joins = self.get_date_sql("Patient", reference_date)
        return f"""
        SELECT
          Patient.Patient_ID AS patient_id,
          CASE WHEN
             dateadd(year, datediff (year, DateOfBirth, {date_expr}), DateOfBirth) > {date_expr}
          THEN
             datediff(year, DateOfBirth, {date_expr}) - 1
          ELSE
             datediff(year, DateOfBirth, {date_expr})
          END AS value
        FROM Patient
        {date_joins}
        """

    def patients_date_of_birth(self):
        return """
        SELECT Patient_ID AS patient_id, DateOfBirth AS value FROM Patient
        """

    def patients_sex(self):
        return """
        SELECT
          Patient_ID AS patient_id,
          Sex AS value
        FROM Patient
        """

    def patients_all(self):
        """
        All patients
        """
        return """
        SELECT Patient_ID AS patient_id, 1 AS value
        FROM Patient
        """

    def patients_random_sample(self, percent):
        """
        A random sample of approximately `percent` patients
        """
        # See
        # https://docs.microsoft.com/en-us/previous-versions/software-testing/cc441928(v=msdn.10)?redirectedfrom=MSDN
        # A TABLESAMPLE clause is more efficient, but its
        # approximations don't work with small numbers, and we might
        # want to use this method for small numbers (and certainly do
        # in the tests!)
        assert percent, "Must specify a percentage greater than zero"
        return f"""
        SELECT Patient_ID, 1 AS value
        FROM Patient
        WHERE (ABS(CAST(
        (BINARY_CHECKSUM(*) *
        RAND()) as int)) % 100) < {quote(percent)}
        """

    def patients_most_recent_bmi(
        self,
        # Set date limits
        between=None,
        minimum_age_at_measurement=16,
        # Add an additional column indicating when measurement was taken
        include_date_of_match=False,
    ):
        """
        Return patients' most recent BMI (in the defined period) either
        computed from weight and height measurements or, where they are not
        availble, from recorded BMI values. Measurements taken when a patient
        was below the minimum age are ignored. The height measurement can be
        taken before (but not after) the defined period as long as the patient
        was over the minimum age at the time.

        Optionally returns an additional column with the date of the
        measurement. If the BMI is computed from weight and height then we use
        the date of the weight measurement for this.
        """
        # From https://github.com/ebmdatalab/tpp-sql-notebook/issues/10:
        #
        # 1) BMI calculated from last recorded height and weight
        #
        # 2) If height and weight is not available, then take latest
        # recorded BMI. Both values must be recorded when the patient
        # is >=16, weight must be within the last 10 years
        date_condition, date_joins = self.get_date_condition(
            "CodedEvent", "ConsultationDate", between
        )

        bmi_code = "22K.."
        # XXX these two sets of codes need validating. The final in
        # each list is the canonical version according to TPP
        weight_codes = [
            "X76C7",  # Concept containing "body weight" terms:
            "22A..",  # O/E weight
        ]
        height_codes = [
            "XM01E",  # Concept containing height/length/stature/growth terms:
            "229..",  # O/E height
        ]

        bmi_cte = f"""
        SELECT t.Patient_ID, t.BMI, t.ConsultationDate
        FROM (
          SELECT CodedEvent.Patient_ID, NumericValue AS BMI, ConsultationDate,
          ROW_NUMBER() OVER (
            PARTITION BY CodedEvent.Patient_ID ORDER BY ConsultationDate DESC, CodedEvent_ID
          ) AS rownum
          FROM CodedEvent
          {date_joins}
          WHERE CTV3Code = {quote(bmi_code)} AND {date_condition}
        ) t
        WHERE t.rownum = 1
        """

        patients_cte = """
           SELECT Patient_ID, DateOfBirth
           FROM Patient
        """
        weight_codes_sql = codelist_to_sql(weight_codes)
        weights_cte = f"""
          SELECT t.Patient_ID, t.weight, t.ConsultationDate
          FROM (
            SELECT CodedEvent.Patient_ID, NumericValue AS weight, ConsultationDate,
              ROW_NUMBER() OVER (
                PARTITION BY CodedEvent.Patient_ID ORDER BY ConsultationDate DESC, CodedEvent_ID
              ) AS rownum
            FROM CodedEvent
            {date_joins}
            WHERE CTV3Code IN ({weight_codes_sql}) AND {date_condition}
          ) t
          WHERE t.rownum = 1
        """

        height_codes_sql = codelist_to_sql(height_codes)
        # The height date restriction is different from the others. We don't
        # mind using old values as long as the patient was old enough when they
        # were taken.
        height_date_condition, height_date_joins = self.get_date_condition(
            "CodedEvent",
            "ConsultationDate",
            remove_lower_date_bound(between),
        )
        heights_cte = f"""
          SELECT t.Patient_ID, t.height, t.ConsultationDate
          FROM (
            SELECT CodedEvent.Patient_ID, NumericValue AS height, ConsultationDate,
            ROW_NUMBER() OVER (
              PARTITION BY CodedEvent.Patient_ID ORDER BY ConsultationDate DESC, CodedEvent_ID
            ) AS rownum
            FROM CodedEvent
            {height_date_joins}
            WHERE CTV3Code IN ({height_codes_sql}) AND {height_date_condition}
          ) t
          WHERE t.rownum = 1
        """

        min_age = int(minimum_age_at_measurement)

        return f"""
        SELECT
          patients.Patient_ID AS patient_id,
          ROUND(COALESCE(weight/SQUARE(NULLIF(height, 0)), bmis.BMI), 1) AS value,
          CASE
            WHEN weight IS NULL OR height IS NULL THEN bmis.ConsultationDate
            ELSE weights.ConsultationDate
          END AS date
        FROM ({patients_cte}) AS patients
        LEFT JOIN ({weights_cte}) AS weights
        ON weights.Patient_ID = patients.Patient_ID AND DATEDIFF(YEAR, patients.DateOfBirth, weights.ConsultationDate) >= {min_age}
        LEFT JOIN ({heights_cte}) AS heights
        ON heights.Patient_ID = patients.Patient_ID AND DATEDIFF(YEAR, patients.DateOfBirth, heights.ConsultationDate) >= {min_age}
        LEFT JOIN ({bmi_cte}) AS bmis
        ON bmis.Patient_ID = patients.Patient_ID AND DATEDIFF(YEAR, patients.DateOfBirth, bmis.ConsultationDate) >= {min_age}
        -- XXX maybe add a "WHERE NULL..." here
        """

    def _summarised_recorded_value(
        self,
        codelist,
        on_most_recent_day_of_measurement,
        between,
        include_date_of_match,
        summary_function,
    ):
        coded_event_table, coded_event_column = coded_event_table_column(codelist)
        date_condition, date_joins = self.get_date_condition(
            coded_event_table, "ConsultationDate", between
        )
        codelist_sql = codelist_to_sql(codelist)

        if on_most_recent_day_of_measurement:
            # The first query finds, for each patient, the most recent day on which
            # they've had a measurement. The final query selects, for each patient, the
            # aggregated value on that day.
            # Note, there's a CAST in the JOIN condition but apparently SQL Server can still
            # use an index for this. See: https://stackoverflow.com/a/25564539
            latest_date_table = self.get_temp_table_name("latest_date")
            return [
                f"""
                SELECT {coded_event_table}.Patient_ID, CAST(MAX(ConsultationDate) AS date) AS day
                INTO {latest_date_table}
                FROM {coded_event_table}
                {date_joins}
                WHERE {coded_event_column} IN ({codelist_sql}) AND {date_condition}
                GROUP BY {coded_event_table}.Patient_ID
                """,
                f"""
                CREATE CLUSTERED INDEX ix ON {latest_date_table} (Patient_ID, day)
                """,
                f"""
                SELECT
                  {latest_date_table}.Patient_ID AS patient_id,
                  {summary_function}({coded_event_table}.NumericValue) AS value,
                  {latest_date_table}.day AS date
                FROM {latest_date_table}
                LEFT JOIN {coded_event_table}
                ON (
                  {coded_event_table}.Patient_ID = {latest_date_table}.Patient_ID
                  AND CAST({coded_event_table}.ConsultationDate AS date) = {latest_date_table}.day
                )
                WHERE
                  {coded_event_table}.{coded_event_column} IN ({codelist_sql})
                GROUP BY {latest_date_table}.Patient_ID, {latest_date_table}.day
                """,
            ]
        else:
            assert (
                include_date_of_match is False
            ), "Can only include measurement date if on_most_recent_day_of_measurement is True"

            return f"""
            SELECT
                {coded_event_table}.Patient_ID AS patient_id,
                {summary_function}({coded_event_table}.NumericValue) AS value
            FROM {coded_event_table}
                {date_joins}
            WHERE {coded_event_column} IN ({codelist_sql}) AND {date_condition}
            GROUP BY {coded_event_table}.Patient_ID
            """

    def patients_mean_recorded_value(
        self,
        codelist,
        # What period is the mean over?
        on_most_recent_day_of_measurement=None,
        # Set date limits
        between=None,
        # Add additional columns indicating when measurement was taken
        include_date_of_match=False,
    ):
        return self._summarised_recorded_value(
            codelist,
            on_most_recent_day_of_measurement,
            between,
            include_date_of_match,
            "AVG",
        )

    def patients_min_recorded_value(
        self,
        codelist,
        # What period is the mean over?
        on_most_recent_day_of_measurement=None,
        # Set date limits
        between=None,
        # Add additional columns indicating when measurement was taken
        include_date_of_match=False,
    ):
        return self._summarised_recorded_value(
            codelist,
            on_most_recent_day_of_measurement,
            between,
            include_date_of_match,
            "MIN",
        )

    def patients_max_recorded_value(
        self,
        codelist,
        # What period is the mean over?
        on_most_recent_day_of_measurement=None,
        # Set date limits
        between=None,
        # Add additional columns indicating when measurement was taken
        include_date_of_match=False,
    ):
        return self._summarised_recorded_value(
            codelist,
            on_most_recent_day_of_measurement,
            between,
            include_date_of_match,
            "MAX",
        )

    def patients_registered_as_of(self, reference_date):
        """
        All patients registed on the given date
        """
        return self.patients_registered_with_one_practice_between(
            reference_date, reference_date
        )

    def patients_registered_with_one_practice_between(
        self, start_date, end_date, practice_used_systm_one_throughout_period=False
    ):
        """
        All patients registered with the same practice through the given period
        """
        start_date_sql, end_date_sql, date_joins = self.get_date_sql(
            "Patient", start_date, end_date
        )
        # Note that current registrations are recorded with an EndDate
        # of 9999-12-31
        extra_condition = ""
        if practice_used_systm_one_throughout_period:
            # We only need to (and only can) check the date the practice
            # *started* using SystmOne.  If they've stopped using it, then we
            # won't have their data in the TPP database at all.
            extra_condition = f"  AND Organisation.GoLiveDate <= {start_date_sql}"
        return f"""
        SELECT DISTINCT Patient.Patient_ID AS patient_id, 1 AS value
        FROM Patient
        INNER JOIN RegistrationHistory
        ON RegistrationHistory.Patient_ID = Patient.Patient_ID
        INNER JOIN Organisation
        ON RegistrationHistory.Organisation_ID = Organisation.Organisation_ID
        {date_joins}
        WHERE StartDate <= {start_date_sql} AND EndDate > {end_date_sql}
        {extra_condition}
        """

    def patients_with_complete_history_between(self, start_date, end_date):
        """
        All patients for which we have a full set of records between the given
        dates
        """
        # This should be do-able by checking for a contiguous set of
        # RegistrationHistory entries covering the period. There's a further
        # complication though which is that a practice might not have been
        # using SystmOne at the point where the patient registered so we can
        # only guarantee data from the point where the patient was registred
        # *and* the practice was on SystmOne. Apparently the Organisation table
        # now has a TPP go-live date which we can use for this purpose.
        raise NotImplementedError()

    def patients_with_these_medications(self, **kwargs):
        """
        Patients who have been prescribed at least one of this list of
        medications in the defined period
        """
        # Note that we're using "ConsultationDate" for the date condition here,
        # which is the date of prescription.  The MedicationIssue table also
        # has StartDate (the date of issue) and EndDate (not exactly sure what
        # this is).
        assert kwargs["codelist"].system == "snomed"
        if kwargs["returning"] == "numeric_value":
            raise ValueError("Unsupported `returning` value: numeric_value")
        # This uses a special case function with a "fake it til you make it" API
        if kwargs["returning"] == "number_of_episodes":
            kwargs.pop("returning")
            # Remove unhandled arguments and check they are unused
            assert not kwargs.pop("find_first_match_in_period", None)
            assert not kwargs.pop("find_last_match_in_period", None)
            assert not kwargs.pop("include_date_of_match", None)
            return self._number_of_episodes_by_medication(**kwargs)
        # This is the default code path for most queries
        else:
            # Remove unhandled arguments and check they are unused
            assert not kwargs.pop("episode_defined_as", None)
            return self._patients_with_events(
                "MedicationIssue",
                """
                INNER JOIN MedicationDictionary
                ON MedicationIssue.MultilexDrug_ID = MedicationDictionary.MultilexDrug_ID
                """,
                "DMD_ID",
                codes_are_case_sensitive=False,
                **kwargs,
            )

    def patients_with_these_clinical_events(self, **kwargs):
        """
        Patients who have had at least one of these clinical events in the
        defined period
        """
        coded_event_table, coded_event_column = coded_event_table_column(
            kwargs["codelist"]
        )

        # This uses a special case function with a "fake it til you make it" API
        if kwargs["returning"] == "number_of_episodes":
            kwargs.pop("returning")
            # Remove unhandled arguments and check they are unused
            assert not kwargs.pop("find_first_match_in_period", None)
            assert not kwargs.pop("find_last_match_in_period", None)
            assert not kwargs.pop("include_date_of_match", None)
            assert not kwargs.pop("include_reference_range_columns", None)
            return self._number_of_episodes_by_clinical_event(
                coded_event_table, coded_event_column, **kwargs
            )
        # This is the default code path for most queries
        else:
            assert not kwargs.pop("episode_defined_as", None)
            if kwargs.pop("include_reference_range_columns", False):
                additional_join = (
                    f"\nLEFT JOIN CodedEventRange\n"
                    f"ON CodedEventRange.CodedEvent_ID = {coded_event_table}.CodedEvent_ID\n"
                )
                comparator_case = """
                CASE comparator
                    WHEN 3 THEN '~'
                    WHEN 4 THEN '='
                    WHEN 5 THEN '>='
                    WHEN 6 THEN '>'
                    WHEN 7 THEN '<'
                    WHEN 8 THEN '<='
                    ELSE ''
                END
                """
                additional_columns = (
                    f"lower_bound,\n"
                    f"upper_bound,\n"
                    f"{comparator_case} AS comparator,\n"
                )
                additional_inner_columns = (
                    "CodedEventRange.LowerBound AS lower_bound,\n"
                    "CodedEventRange.UpperBound AS upper_bound,\n"
                    "CodedEventRange.Comparator AS comparator,\n"
                )
            else:
                additional_join = ""
                additional_columns = ""
                additional_inner_columns = ""
            return self._patients_with_events(
                coded_event_table,
                additional_join,
                coded_event_column,
                codes_are_case_sensitive=True,
                additional_columns=additional_columns,
                additional_inner_columns=additional_inner_columns,
                **kwargs,
            )

    def _patients_with_events(
        self,
        from_table,
        additional_join,
        code_column,
        codes_are_case_sensitive,
        codelist,
        # Allows us to say: find codes A and B, but only on days where X and Y
        # didn't happen
        ignore_days_where_these_codes_occur=None,
        # Set date limits
        between=None,
        # Matching rule
        find_first_match_in_period=None,
        find_last_match_in_period=None,
        # Set return type
        returning="binary_flag",
        include_date_of_match=False,
        ignore_missing_values=False,
        additional_columns="",
        additional_inner_columns="",
    ):
        codelist_table, codelist_queries = self.create_codelist_table(
            codelist, codes_are_case_sensitive
        )
        date_condition, date_joins = self.get_date_condition(
            from_table, "ConsultationDate", between
        )
        ignored_day_condition, extra_queries = self._these_codes_occur_on_same_day(
            from_table, ignore_days_where_these_codes_occur, between
        )
        missing_value_condition = (
            "NumericValue != 0" if ignore_missing_values else "1 = 1"
        )

        # Result ordering
        if find_first_match_in_period:
            ordering = "ASC"
            date_aggregate = "MIN"
        else:
            ordering = "DESC"
            date_aggregate = "MAX"

        column_name = returning
        outer_column_definition = None
        if returning == "binary_flag" or returning == "date":
            column_name = "binary_flag"
            column_definition = "1"
            # If we don't have any additional columns then we don't need a
            # partion query, otherwise we do
            use_partition_query = bool(additional_columns)
        elif returning == "number_of_matches_in_period":
            column_definition = "COUNT(*)"
            use_partition_query = False
        elif returning == "numeric_value":
            column_definition = "NumericValue"
            use_partition_query = True
        elif returning == "code":
            column_definition = code_column
            use_partition_query = True
        elif returning == "category":
            if not codelist.has_categories:
                raise ValueError(
                    "Cannot return categories because the supplied codelist does "
                    "not have any categories defined"
                )
            outer_column_definition = "category"
            column_definition = f"{codelist_table}.category"
            use_partition_query = True
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")

        if use_partition_query:
            if from_table == "CodedEvent_SNOMED":
                from_table_id_col = "CodedEvent_ID"
            else:
                from_table_id_col = f"{from_table}_ID"
            if outer_column_definition is None:
                outer_column_definition = column_definition

            sql = f"""
            SELECT
              Patient_ID AS patient_id,
              {outer_column_definition} AS {column_name},
              {additional_columns}
              ConsultationDate AS date
            FROM (
              SELECT {from_table}.Patient_ID, {column_definition}, ConsultationDate,
              {additional_inner_columns}
              ROW_NUMBER() OVER (
                PARTITION BY {from_table}.Patient_ID
                ORDER BY ConsultationDate {ordering}, {from_table}.{from_table_id_col}
              ) AS rownum
              FROM {from_table}{additional_join}
              INNER JOIN {codelist_table}
              ON {code_column} = {codelist_table}.code
              {date_joins}
              WHERE {date_condition}
                AND NOT {ignored_day_condition}
                AND {missing_value_condition}
            ) t
            WHERE rownum = 1
            """
        else:
            assert not additional_columns

            sql = f"""
            SELECT
              {from_table}.Patient_ID AS patient_id,
              {column_definition} AS {column_name},
              {date_aggregate}(ConsultationDate) AS date
            FROM {from_table}{additional_join}
            INNER JOIN {codelist_table}
            ON {code_column} = {codelist_table}.code
            {date_joins}
            WHERE {date_condition}
              AND NOT {ignored_day_condition}
              AND {missing_value_condition}
            GROUP BY {from_table}.Patient_ID
            """

        return codelist_queries + extra_queries + [sql]

    def patients_with_these_decision_support_values(
        self,
        algorithm,
        between,
        find_first_match_in_period,
        find_last_match_in_period,
        returning,
        ignore_missing_values,
    ):
        # First, we resolve the algorithm.
        algorithm_to_id = {  # Map the value we use to the ID TPP use
            "electronic_frailty_index": 1,
        }
        try:
            algorithm_type_id = algorithm_to_id[algorithm]
        except KeyError:
            raise ValueError(f"Unsupported `algorithm` value: {algorithm}")

        # Then, we resolve the date limits.
        date_condition, date_joins = self.get_date_condition(
            "DecisionSupportValue", "CalculationDateTime", between
        )

        # Then, we resolve the matching rule.
        # "It will never happen" happens, but not often enough to raise a `ValueError`.
        assert not (find_first_match_in_period and find_last_match_in_period)
        if find_first_match_in_period:
            ordering = "ASC"
            date_aggregate = "MIN"
        else:
            ordering = "DESC"
            date_aggregate = "MAX"

        # Then, we resolve the return type.
        value_column_alias = returning
        if returning == "binary_flag" or returning == "date":
            use_partition_query = False
            value_column_expression = 1  # The literal value `1`
            value_column_alias = "binary_flag"
        elif returning == "number_of_matches_in_period":
            use_partition_query = False
            value_column_expression = "COUNT(*)"
        elif returning == "numeric_value":
            use_partition_query = True
            value_column_expression = "NumericValue"
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")

        # Then, we resolve the missing values rule.
        missing_values_condition = (
            "NumericValue != 0" if ignore_missing_values else "1 = 1"
        )

        # Finally, we construct the query.
        if use_partition_query:
            sql = f"""
                SELECT
                    Patient_ID AS patient_id,
                    {value_column_expression} AS {value_column_alias},
                    CalculationDateTime AS date
                FROM (
                    SELECT
                        DecisionSupportValue.Patient_ID AS Patient_ID,
                        {value_column_expression},
                        CalculationDateTime,
                        ROW_NUMBER() OVER (
                            PARTITION BY DecisionSupportValue.Patient_ID
                            ORDER BY CalculationDateTime {ordering}, DecisionSupportValue.Patient_ID
                        ) AS rownum
                    FROM
                        DecisionSupportValue
                        {date_joins}
                    WHERE
                        AlgorithmType = {quote(algorithm_type_id)}
                        AND {date_condition}
                        AND {missing_values_condition}
                ) t
                WHERE
                    rownum = 1
            """
        else:
            sql = f"""
                SELECT
                    DecisionSupportValue.Patient_ID AS patient_id,
                    {value_column_expression} AS {value_column_alias},
                    {date_aggregate}(CalculationDateTime) AS date
                FROM
                    DecisionSupportValue
                    {date_joins}
                WHERE
                    AlgorithmType = {quote(algorithm_type_id)}
                    AND {date_condition}
                    AND {missing_values_condition}
                GROUP BY
                    DecisionSupportValue.Patient_ID
            """
        return [sql]

    def _number_of_episodes_by_medication(
        self,
        codelist,
        # Set date limits
        between=None,
        ignore_days_where_these_codes_occur=None,
        episode_defined_as=None,
    ):
        codelist_table, codelist_queries = self.create_codelist_table(
            codelist, case_sensitive=False
        )
        date_condition, date_joins = self.get_date_condition(
            "MedicationIssue", "ConsultationDate", between
        )
        ignored_day_condition, extra_queries = self._these_codes_occur_on_same_day(
            "MedicationIssue", ignore_days_where_these_codes_occur, between
        )
        if episode_defined_as is not None:
            pattern = r"^series of events each <= (\d+) days apart$"
            match = re.match(pattern, episode_defined_as)
            if not match:
                raise ValueError(
                    f"Argument `episode_defined_as` must match " f"pattern: {pattern}"
                )
            washout_period = int(match.group(1))
        else:
            washout_period = 0

        sql = f"""
        SELECT
          t.Patient_ID AS patient_id,
          SUM(is_new_episode) AS number_of_episodes
        FROM (
            SELECT
              MedicationIssue.Patient_ID,
              CASE
                WHEN
                  DATEDIFF(
                    day,
                    LAG(ConsultationDate) OVER (
                      PARTITION BY MedicationIssue.Patient_ID ORDER BY ConsultationDate
                    ),
                    ConsultationDate
                  ) <= {washout_period}
                THEN 0
                ELSE 1
              END AS is_new_episode
            FROM MedicationIssue
            INNER JOIN MedicationDictionary
            ON MedicationIssue.MultilexDrug_ID = MedicationDictionary.MultilexDrug_ID
            INNER JOIN {codelist_table}
            ON DMD_ID = {codelist_table}.code
            {date_joins}
            WHERE {date_condition} AND NOT {ignored_day_condition}
        ) t
        GROUP BY t.Patient_ID
        """
        return codelist_queries + extra_queries + [sql]

    def _number_of_episodes_by_clinical_event(
        self,
        from_table,
        code_column,
        codelist,
        # Set date limits
        between=None,
        ignore_days_where_these_codes_occur=None,
        episode_defined_as=None,
        ignore_missing_values=False,
    ):
        codelist_table, codelist_queries = self.create_codelist_table(
            codelist, case_sensitive=True
        )
        date_condition, date_joins = self.get_date_condition(
            from_table, "ConsultationDate", between
        )
        ignored_day_condition, extra_queries = self._these_codes_occur_on_same_day(
            from_table, ignore_days_where_these_codes_occur, between
        )
        missing_value_condition = (
            "NumericValue != 0" if ignore_missing_values else "1 = 1"
        )

        if episode_defined_as is not None:
            pattern = r"^series of events each <= (\d+) days apart$"
            match = re.match(pattern, episode_defined_as)
            if not match:
                raise ValueError(
                    f"Argument `episode_defined_as` must match " f"pattern: {pattern}"
                )
            washout_period = int(match.group(1))
        else:
            washout_period = 0

        sql = f"""
        SELECT
          t.Patient_ID AS patient_id,
          SUM(is_new_episode) AS number_of_episodes
        FROM (
            SELECT
              {from_table}.Patient_ID,
              CASE
                WHEN
                  DATEDIFF(
                    day,
                    LAG(ConsultationDate) OVER (
                      PARTITION BY {from_table}.Patient_ID ORDER BY ConsultationDate
                    ),
                    ConsultationDate
                  ) <= {washout_period}
                THEN 0
                ELSE 1
              END AS is_new_episode
            FROM {from_table}
            INNER JOIN {codelist_table}
            ON {code_column} = {codelist_table}.code
            {date_joins}
            WHERE {date_condition}
              AND NOT {ignored_day_condition}
              AND {missing_value_condition}
        ) t
        GROUP BY t.Patient_ID
        """
        return codelist_queries + extra_queries + [sql]

    def _these_codes_occur_on_same_day(self, joined_table, codelist, between):
        """
        Generates a SQL condition that filters rows in `joined_table` so that
        they only include events which happened on days where one of the codes
        in `codelist` occur in the CodedEvents table. Usually we negate this
        condition in the surrounding query so that we only includes days where
        *none* of the codes occured.

        We use this to support queries like "give me all the times a patient
        was prescribed this drug, but ignore any days on which they were having
        their annual COPD review".
        """
        if codelist is None:
            return "0 = 1", []
        codelist_table, queries = self.create_codelist_table(
            codelist, case_sensitive=True
        )
        same_day_table = self.get_temp_table_name("same_day_events")
        coded_event_table, coded_event_column = coded_event_table_column(codelist)
        date_condition, date_joins = self.get_date_condition(
            coded_event_table, "ConsultationDate", between
        )
        queries += [
            f"""
            SELECT
              {coded_event_table}.Patient_ID AS Patient_ID,
              CAST(ConsultationDate AS date) AS day
            INTO {same_day_table}
            FROM {coded_event_table}
            INNER JOIN {codelist_table}
            ON {coded_event_column} = {codelist_table}.code
            {date_joins}
            WHERE {date_condition}
            """,
            f"""
            CREATE CLUSTERED INDEX ix ON {same_day_table} (Patient_ID, day)
            """,
        ]
        condition = f"""
        EXISTS (
          SELECT 1 FROM {same_day_table}
          WHERE
            {joined_table}.Patient_ID = {same_day_table}.Patient_ID
            AND CAST({joined_table}.ConsultationDate AS date) = {same_day_table}.day
        )
        """
        return condition, queries

    def patients_registered_practice_as_of(self, date, returning=None):
        # Note that current registrations are recorded with an EndDate of
        # 9999-12-31. Where registration periods overlap we use the one with
        # the most recent start date. If there are several with the same start
        # date we use the longest one (i.e. with the latest end date).
        date_sql, date_joins = self.get_date_sql("RegistrationHistory", date)

        if "__" in returning:  # It's an RCT.
            _, app_trial_name, app_property_name = returning.split("__")

            # Here, we map from the app (i.e. cohort-extractor) to the DB, to give a
            # cleaner interface e.g. without camel case variable names. We do, however,
            # duplicate some of this information: You will find trial names and property
            # names in cohortextractor.process_covariate_definitions. It would be good
            # to refactor, moving them elsewhere.

            # Maps from trial names used by the app to those used by the DB.
            app_to_db_trial_name = {
                "germdefence": "germdefence",
            }
            # Maps from property names used by the app to those used by the DB.
            app_to_db_property_name = {
                property.lower(): property
                for property in [
                    # Our internal properties
                    "enrolled",
                    "trial_arm",
                    # Properties supplied by the RCT
                    "Av_rooms_per_house",
                    "deprivation_pctile",
                    "group_mean_behaviour_mean",
                    "group_mean_intention_mean",
                    "hand_behav_practice_mean",
                    "hand_intent_practice_mean",
                    "IMD_decile",
                    "IntCon",
                    "MeanAge",
                    "MedianAge",
                    "Minority_ethnic_total",
                    "N_completers_HW_behav",
                    "N_completers_RI_behav",
                    "N_completers_RI_intent",
                    "n_engaged_pages_viewed_mean_mean",
                    "n_engaged_visits_mean",
                    "N_goalsetting_completers_per_practice",
                    "n_pages_viewed_mean",
                    "n_times_visited_mean",
                    "N_visits_practice",
                    "prop_engaged_visits",
                    "total_visit_time_mean",
                ]
            }
            try:
                db_trial_name = app_to_db_trial_name[app_trial_name]
            except KeyError:
                raise ValueError(
                    f"Unknown RCT '{app_trial_name}', available names are: "
                    f"{', '.join(app_to_db_trial_name.keys())}"
                )
            try:
                db_property_name = app_to_db_property_name[app_property_name]
            except KeyError:
                newline = "\n"
                raise ValueError(
                    f"Unknown property '{app_property_name}', available properties"
                    f" are:\n{newline.join(app_to_db_trial_name.keys())}"
                )

            if app_property_name in ["enrolled", "trial_arm"]:
                to_select = "1" if app_property_name == "enrolled" else "TrialArm"

                return f"""
                SELECT
                    Patient_ID AS patient_id,
                    {to_select} AS {returning}
                FROM
                    ClusterRandomisedTrial AS lhs
                LEFT JOIN (
                    SELECT
                        Patient_ID,
                        Organisation_ID,
                        ROW_NUMBER() OVER (
                            PARTITION BY Patient_ID
                            ORDER BY StartDate DESC, EndDate DESC, Registration_ID
                        ) AS rownum
                    FROM
                        RegistrationHistory
                        {date_joins}
                    WHERE
                        StartDate <= {date_sql}
                        AND EndDate > {date_sql}
                ) AS rhs
                ON lhs.Organisation_ID = rhs.Organisation_ID
                WHERE
                    rownum = 1
                    AND TrialNumber IN (
                        SELECT
                            TrialNumber
                        FROM
                            ClusterRandomisedTrialReference
                        WHERE
                            TrialName = '{db_trial_name}'
                    )
                """
            else:
                return f"""
                SELECT
                    Patient_ID AS patient_id,
                    PropertyValue AS {returning}
                FROM
                    ClusterRandomisedTrialDetail as lhs
                LEFT JOIN (
                    SELECT
                        Patient_ID,
                        Organisation_ID,
                        ROW_NUMBER() OVER (
                            PARTITION BY Patient_ID
                            ORDER BY StartDate DESC, EndDate DESC, Registration_ID
                        ) AS rownum
                    FROM
                        RegistrationHistory
                        {date_joins}
                    WHERE
                        StartDate <= {date_sql}
                        AND EndDate > {date_sql}
                ) rhs
                ON lhs.Organisation_ID = rhs.Organisation_ID
                WHERE
                    Property = '{db_property_name}'
                    AND rownum = 1
                    AND TrialNumber IN (
                        SELECT
                            TrialNumber
                        FROM
                            ClusterRandomisedTrialReference
                        WHERE
                            TrialName = '{db_trial_name}'
                    )
                """

        if returning == "stp_code":
            column = "STPCode"
        # "msoa" is the correct option here, "msoa_code" is supported for
        # backwards compatibility
        elif returning in ("msoa", "msoa_code"):
            column = "MSOACode"
        elif returning == "nuts1_region_name":
            column = "Region"
        elif returning == "pseudo_id":
            column = "Organisation_ID"
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")
        return f"""
        SELECT
          t.Patient_ID AS patient_id,
          Organisation.{column} AS {returning}
        FROM (
          SELECT RegistrationHistory.Patient_ID, Organisation_ID,
          ROW_NUMBER() OVER (
            PARTITION BY RegistrationHistory.Patient_ID
            ORDER BY StartDate DESC, EndDate DESC, Registration_ID
          ) AS rownum
          FROM RegistrationHistory
          {date_joins}
          WHERE StartDate <= {date_sql} AND EndDate > {date_sql}
        ) t
        LEFT JOIN Organisation
        ON Organisation.Organisation_ID = t.Organisation_ID
        WHERE t.rownum = 1
        """

    def patients_date_deregistered_from_all_supported_practices(self, between):
        if between is None:
            between = (None, None)
        min_date, max_date = between
        # Registrations with no end date are recorded using an end date of
        # 9999-12-31, so if no max date is supplied then we need to set a max
        # date to something less than 9999-12-31 to filter out registrations
        # which have no end date.
        if max_date is None:
            max_date = "3000-01-01"
        if min_date is None:
            min_date = "1900-01-01"
        date_condition, date_joins = self.get_date_condition(
            "t", "t.end_date", (min_date, max_date)
        )
        return f"""
        SELECT
          t.Patient_id,
          end_date AS value
        FROM (
          SELECT
            Patient_ID AS patient_id,
            MAX(EndDate) AS end_date
          FROM
            RegistrationHistory
          GROUP BY
            Patient_ID
        ) t
        {date_joins}
        WHERE {date_condition}
        """

    def patients_address_as_of(self, date, returning=None, round_to_nearest=None):
        # N.B. A value of -1 indicates no postcode recorded on the
        # record, an invalid postcode, or no fixed abode.
        #
        # Related, there is a column in the address table to indicate
        # NP for no postcode or NFA for no fixed abode
        if returning == "index_of_multiple_deprivation":
            assert round_to_nearest == 100
            column = "ImdRankRounded"
        elif returning == "rural_urban_classification":
            assert round_to_nearest is None
            column = "RuralUrbanClassificationCode"
        elif returning == "msoa":
            column = "MSOACode"
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")
        date_sql, date_joins = self.get_date_sql("PatientAddress", date)
        # Note that current addresses are recorded with an EndDate of
        # 9999-12-31. Where address periods overlap we use the one with the
        # most recent start date. If there are several with the same start date
        # we use the longest one (i.e. with the latest end date). We then
        # prefer addresses which are not marked "NPC" for "No Postcode" and
        # finally we use the address ID as a tie-breaker.
        return f"""
        SELECT
          t.Patient_ID AS patient_id,
          {column} AS {returning}
        FROM (
          SELECT PatientAddress.Patient_ID, {column},
          ROW_NUMBER() OVER (
            PARTITION BY PatientAddress.Patient_ID
            ORDER BY
              StartDate DESC,
              EndDate DESC,
              IIF(MSOACode = 'NPC', 1, 0),
              PatientAddress_ID
          ) AS rownum
          FROM PatientAddress
          {date_joins}
          WHERE StartDate <= {date_sql} AND EndDate > {date_sql}
        ) t
        WHERE rownum = 1
        """

    def patients_care_home_status_as_of(self, date, categorised_as):
        # These are the columns to which the categorisation expression is
        # allowed to refer
        allowed_columns = {
            "IsPotentialCareHome": ColumnExpression(
                "ISNULL(PotentialCareHomeAddressID, 0)",
                type="int",
                default_value=0,
            ),
            "LocationRequiresNursing": ColumnExpression(
                "LocationRequiresNursing", type="str", default_value=""
            ),
            "LocationDoesNotRequireNursing": ColumnExpression(
                "LocationDoesNotRequireNursing", type="str", default_value=""
            ),
        }
        case_expression = self.get_case_expression(
            allowed_columns, column_type="str", category_definitions=categorised_as
        )
        date_sql, date_joins = self.get_date_sql("PatientAddress", date)
        # See `patients_address_as_of` above for details of the ordering used
        # here
        return f"""
        SELECT
          t.Patient_ID AS patient_id,
          {case_expression} AS value
        FROM (
          SELECT
            PatientAddress.Patient_ID AS Patient_ID,
            PotentialCareHomeAddress.PatientAddress_ID AS PotentialCareHomeAddressID,
            LocationRequiresNursing,
            LocationDoesNotRequireNursing,
            ROW_NUMBER() OVER (
              PARTITION BY PatientAddress.Patient_ID
              ORDER BY
                StartDate DESC,
                EndDate DESC,
                IIF(MSOACode = 'NPC', 1, 0),
                PatientAddress.PatientAddress_ID
              ) AS rownum
          FROM PatientAddress
          LEFT JOIN PotentialCareHomeAddress
          ON PatientAddress.PatientAddress_ID = PotentialCareHomeAddress.PatientAddress_ID
          {date_joins}
          WHERE StartDate <= {date_sql} AND EndDate > {date_sql}
        ) t
        WHERE rownum = 1
        """

    # https://github.com/ebmdatalab/tpp-sql-notebook/issues/72
    def patients_admitted_to_icu(
        self,
        between=None,
        find_first_match_in_period=None,
        find_last_match_in_period=None,
        returning="binary_flag",
    ):
        date_expression = """
        CASE
        WHEN
          COALESCE(IcuAdmissionDateTime, '9999-01-01') < COALESCE(OriginalIcuAdmissionDate, '9999-01-01')
        THEN
          IcuAdmissionDateTime
        ELSE
          OriginalIcuAdmissionDate
        END"""
        date_condition, date_joins = self.get_date_condition(
            "ICNARC", date_expression, between
        )

        greater_than_zero_expr = "CASE WHEN {} > 0 THEN 1 ELSE 0 END"

        if returning == "date_admitted":
            if find_first_match_in_period:
                column_definition = f"MIN({date_expression})"
            else:
                column_definition = f"MAX({date_expression})"
        elif returning == "binary_flag":
            column_definition = 1
        elif returning == "had_respiratory_support":
            column_definition = greater_than_zero_expr.format(
                "SUM(BasicDays_RespiratorySupport) + SUM(AdvancedDays_RespiratorySupport)"
            )
        elif returning == "had_basic_respiratory_support":
            column_definition = greater_than_zero_expr.format(
                "SUM(BasicDays_RespiratorySupport)"
            )
        elif returning == "had_advanced_respiratory_support":
            column_definition = greater_than_zero_expr.format(
                "SUM(AdvancedDays_RespiratorySupport)"
            )
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")
        return f"""
        SELECT
          ICNARC.Patient_ID AS patient_id,
          {column_definition} AS {returning}
        FROM
          ICNARC
        {date_joins}
        WHERE {date_condition}
        GROUP BY ICNARC.Patient_ID
        """

    def patients_with_these_codes_on_death_certificate(
        self,
        codelist=None,
        # Set date limits
        between=None,
        # Matching rules
        match_only_underlying_cause=False,
        # Set return type
        returning="binary_flag",
    ):
        date_condition, date_joins = self.get_date_condition(
            "ONS_Deaths", "dod", between
        )
        if codelist is not None:
            assert codelist.system == "icd10"
            codelist_sql = codelist_to_sql(codelist)
            code_columns = ["icd10u"]
            if not match_only_underlying_cause:
                code_columns.extend([f"ICD10{i:03d}" for i in range(1, 16)])
            code_conditions = " OR ".join(
                f"{column} IN ({codelist_sql})" for column in code_columns
            )
        else:
            code_conditions = "1 = 1"
        # The ONS deaths data contains some duplicate patient IDs. In most
        # cases these are exact duplicate rows, but in same cases the same
        # patient appears twice with different dates and death or a different
        # underlying cause of death. We handle this by (arbitrarily) taking the
        # earliest date of death or the lexically smallest ICD-10 code.
        if returning == "binary_flag":
            column_definition = "1"
        elif returning == "date_of_death":
            column_definition = "MIN(dod)"
        elif returning == "underlying_cause_of_death":
            column_definition = "MIN(icd10u)"
        elif returning == "place_of_death":
            column_definition = "MIN(Place_of_occurrence)"
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")
        return f"""
        SELECT
          ONS_Deaths.Patient_ID as patient_id,
          {column_definition} AS {returning}
        FROM ONS_Deaths
        {date_joins}
        WHERE ({code_conditions}) AND {date_condition}
        GROUP BY ONS_Deaths.Patient_ID
        """

    def patients_died_from_any_cause(
        self,
        # Set date limits
        between=None,
        # Set return type
        returning="binary_flag",
    ):
        return self.patients_with_these_codes_on_death_certificate(
            codelist=None,
            between=between,
            returning=returning,
        )

    def patients_with_death_recorded_in_cpns(
        self,
        # Set date limits
        between=None,
        # Set return type
        returning="binary_flag",
    ):
        date_condition, date_joins = self.get_date_condition(
            "CPNS", "DateOfDeath", between
        )
        if returning == "binary_flag":
            column_definition = "1"
        elif returning == "date_of_death":
            column_definition = "MAX(DateOfDeath)"
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")
        return f"""
        SELECT
          CPNS.Patient_ID as patient_id,
          {column_definition} AS {returning},
          -- Crude error check so we blow up in the case of inconsistent dates
          1 / CASE WHEN MAX(DateOfDeath) = MIN(DateOfDeath) THEN 1 ELSE 0 END AS _e
        FROM CPNS
        {date_joins}
        WHERE {date_condition}
        GROUP BY CPNS.Patient_ID
        """

    def patients_with_death_recorded_in_primary_care(
        self,
        # Set date limits
        between=None,
        # Set return type
        returning="binary_flag",
    ):
        if returning == "binary_flag":
            column = "1"
        elif returning == "date_of_death":
            column = "DateOfDeath"
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")
        if between is None:
            between = (None, None)
        min_date, max_date = between
        # Patients with no date of death (i.e. alive ones) are recorded using a
        # death date of 9999-12-31, so if no max date is supplied then we need
        # to set a max date to something less than 9999-12-31 to filter these
        # out
        if max_date is None:
            max_date = "3000-01-01"
        if min_date is None:
            min_date = "1900-01-01"
        between = (min_date, max_date)
        date_condition, date_joins = self.get_date_condition(
            "Patient", "DateOfDeath", between
        )
        return f"""
        SELECT
          Patient.Patient_ID AS patient_id,
          {column} AS {returning}
        FROM
          Patient
       {date_joins}
        WHERE
          {date_condition}
        """

    def patients_with_vaccination_record(self, tpp, emis, **kwargs):
        tpp.update(kwargs)
        return self.patients_with_tpp_vaccination_record(**tpp)

    def patients_with_tpp_vaccination_record(
        self,
        target_disease_matches=None,
        product_name_matches=None,
        # Set date limits
        between=None,
        # Set return type
        returning="binary_flag",
        # Matching rule
        find_first_match_in_period=None,
        find_last_match_in_period=None,
        include_date_of_match=False,
    ):
        date_condition, date_joins = self.get_date_condition(
            "Vaccination", "VaccinationDate", between
        )
        conditions = [date_condition]
        target_disease_matches = to_list(target_disease_matches)
        if target_disease_matches:
            content_codes = codelist_to_sql(target_disease_matches)
            conditions.append(f"ref.VaccinationContent IN ({content_codes})")

        product_name_matches = to_list(product_name_matches)
        if product_name_matches:
            product_name_codes = codelist_to_sql(product_name_matches)
            conditions.append(f"ref.VaccinationName IN ({product_name_codes})")

        conditions_str = " AND ".join(conditions)

        # Result ordering
        if find_first_match_in_period:
            date_aggregate = "MIN"
        else:
            date_aggregate = "MAX"

        if returning not in ("binary_flag", "date"):
            # Because each Vaccination row can potentially map to multiple
            # VaccinationReference rows (one for each disease targeted by the
            # vaccine) anything beyond a simple binary flag or a date is going to
            # require more thought.
            raise ValueError(f"Unsupported `returning` value: {returning}")

        return f"""
        SELECT
          Vaccination.Patient_ID AS patient_id,
          1 AS binary_flag,
          {date_aggregate}(VaccinationDate) AS date
        FROM Vaccination
        INNER JOIN VaccinationReference AS ref
        ON ref.VaccinationName_ID = Vaccination.VaccinationName_ID
        {date_joins}
        WHERE {conditions_str}
        GROUP BY Vaccination.Patient_ID
        """

    def patients_with_gp_consultations(
        self,
        # Set date limits
        between=None,
        # Matching rule
        find_first_match_in_period=None,
        find_last_match_in_period=None,
        # Set return type
        returning="binary_flag",
        include_date_of_match=False,
    ):
        if returning == "binary_flag" or returning == "date":
            column_name = "binary_flag"
            column_definition = "1"
        elif returning == "number_of_matches_in_period":
            column_name = returning
            column_definition = "COUNT(*)"
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")

        valid_states = [
            AppointmentStatus.ARRIVED,
            AppointmentStatus.WAITING,
            AppointmentStatus.IN_PROGRESS,
            AppointmentStatus.FINISHED,
            AppointmentStatus.PATIENT_WALKED_OUT,
            AppointmentStatus.VISIT,
        ]
        valid_states_str = codelist_to_sql(map(int, valid_states))

        date_condition, date_joins = self.get_date_condition(
            "Appointment", "SeenDate", between
        )
        # Result ordering
        date_aggregate = "MIN" if find_first_match_in_period else "MAX"
        return f"""
        SELECT
          Appointment.Patient_ID AS patient_id,
          {column_definition} AS {column_name},
          {date_aggregate}(SeenDate) AS date
        FROM Appointment
        {date_joins}
        WHERE Status IN ({valid_states_str}) AND {date_condition}
        GROUP BY Appointment.Patient_ID
        """

    def patients_with_complete_gp_consultation_history_between(
        self, start_date, end_date
    ):
        """
        In this context this should mean patients who have been continuously
        registered with TPP-using practices throughout this period. However,
        for now we restrict this to just patients who have been registered with
        a single practice throughout this period.  As this is a more
        restrictive condition this is fine for our purposes, however once we
        get an implementation for `patients_with_complete_history_between` we
        should switch to using this.
        """
        return self.patients_registered_with_one_practice_between(
            start_date, end_date, practice_used_systm_one_throughout_period=True
        )

    def patients_with_test_result_in_sgss(
        self,
        pathogen=None,
        test_result=None,
        # Set date limits
        between=None,
        # Matching rule
        find_first_match_in_period=None,
        find_last_match_in_period=None,
        restrict_to_earliest_specimen_date=True,
        # Set return type
        returning="binary_flag",
        include_date_of_match=False,
    ):
        assert pathogen == "SARS-CoV-2"

        if returning == "case_category" and (
            not restrict_to_earliest_specimen_date or test_result != "positive"
        ):
            raise ValueError(
                "Due to limitations in the SGSS data we receive you can only use:\n"
                "  returning = 'case_category'\n"
                "with the options:\n"
                "  restrict_to_earliest_specimen_date = True\n"
                "  test_result = 'positive'"
            )

        if (
            returning == "number_of_matches_in_period"
            and restrict_to_earliest_specimen_date is not False
        ):
            raise ValueError(
                "Due to limitations in the SGSS data we receive you can only use:\n"
                "  returning = 'number_of_matches_in_period'\n"
                "with the options:\n"
                "  restrict_to_earliest_specimen_date = False\n"
            )

        if (
            returning in ("variant", "variant_detection_method", "symptomatic")
            and restrict_to_earliest_specimen_date
        ):
            raise ValueError(
                f"Due to limitations in the SGSS data we receive you can only use:\n"
                f"  returning = '{returning}'\n"
                f"with the option:\n"
                f"  restrict_to_earliest_specimen_date = False\n"
            )

        use_partition_query = True

        if returning == "binary_flag":
            column = "1"
        elif returning == "date":
            # To make the SQL easier we always generate a "date" column whether
            # one is requested or not. This means when we're explicitly asked
            # for a date column there's nothing extra we need to do, but we
            # need _some_ value in the SQL so we do this
            column = "1"
            returning = "binary_flag"
        elif returning == "s_gene_target_failure":
            column = "t2.sgtf"
        elif returning == "case_category":
            column = "t2.case_cateogory"
        elif returning == "variant":
            raw_column = "t2.variant"
            transforms = {
                "(blank)": "",
                "none": "",
                "N/A": "",
                "VOC-20DEC-01 detected": "VOC-20DEC-01",
            }
            case_clauses = "\n".join(
                [
                    f"WHEN {raw_column} = {quote(key)} THEN {quote(value)}"
                    for (key, value) in transforms.items()
                ]
            )
            column = f"CASE {case_clauses} ELSE {raw_column} END"
        elif returning == "variant_detection_method":
            column = "t2.variant_detection_method"
        elif returning == "symptomatic":
            raw_column = "t2.symptomatic"
            transforms = {
                # From SGSS_AllTests_Positive table.
                "N": "N",
                "U": "",
                "Y": "Y",
                # From SGSS_AllTests_Negative table.
                "false": "N",
                "true": "Y",
            }
            case_clauses = "\n".join(
                [
                    f"WHEN {raw_column} = {quote(key)} THEN {quote(value)}"
                    for (key, value) in transforms.items()
                ]
                # As per #581, we only have nulls in the SGSS_AllTests_Negative table.
                # However, it seems reasonable to apply this condition to both the
                # SGSS_AllTests_Positive and SGSS_AllTests_Negative table.
                # If nulls did appear in the SGSS_AllTests_Negative table, presumably
                # we would want the same behaviour. Therefore, we can just add this
                # extra clause unconditionally.
                + [f"WHEN {raw_column} IS NULL THEN {quote('')}"]
            )
            column = f"CASE {case_clauses} ELSE {raw_column} END"
        elif returning == "number_of_matches_in_period":
            column = "COUNT(*)"
            use_partition_query = False
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")

        if restrict_to_earliest_specimen_date:
            positive_query = """
            SELECT
              Patient_ID AS patient_id,
              Earliest_Specimen_Date AS date,
              SGTF AS sgtf,
              CaseCategory AS case_cateogory
            FROM SGSS_Positive
            """
            negative_query = """
            SELECT
              Patient_ID AS patient_id,
              Earliest_Specimen_Date AS date,
              '' AS sgtf,
              '' AS case_category
            FROM SGSS_Negative
            """
        else:
            positive_query = """
            SELECT
              Patient_ID AS patient_id,
              Specimen_Date AS date,
              Variant AS variant,
              VariantDetectionMethod AS variant_detection_method,
              Symptomatic AS symptomatic,
              SGTF AS sgtf
            FROM SGSS_AllTests_Positive
            """
            negative_query = """
            SELECT
              Patient_ID AS patient_id,
              Specimen_Date AS date,
              '' AS variant,
              '' AS variant_detection_method,
              Symptomatic AS symptomatic,
              '' AS sgtf
            FROM SGSS_AllTests_Negative
            """

        if test_result == "any":
            table_query = f"{positive_query}\nUNION ALL\n{negative_query}"
        elif test_result == "positive":
            table_query = positive_query
        elif test_result == "negative":
            table_query = negative_query
        else:
            raise ValueError("Unsupported test_result '{test_result}'")

        date_condition, date_joins = self.get_date_condition("t1", "t1.date", between)
        date_ordering = "ASC" if find_first_match_in_period else "DESC"

        if use_partition_query:
            return f"""
            SELECT
              t2.patient_id AS patient_id,
              t2.date AS date,
              {column} AS {returning}
            FROM (
              SELECT t1.*,
                ROW_NUMBER() OVER (
                  PARTITION BY t1.patient_id
                  ORDER BY t1.date {date_ordering}
                ) AS rownum
              FROM (
                {table_query}
              ) t1
              {date_joins}
              WHERE {date_condition}
            ) t2
            WHERE t2.rownum = 1
            """
        else:
            return f"""
            SELECT
              t1.patient_id AS patient_id,
              {column} AS {returning}
            FROM ({table_query}) t1
            {date_joins}
            WHERE {date_condition}
            GROUP BY t1.patient_id
            """

    def patients_household_as_of(self, reference_date, returning):
        if reference_date != "2020-02-01":
            raise ValueError("Household data only currently available for 2020-02-01")
        if returning == "pseudo_id":
            column = "Household.Household_ID"
        elif returning == "household_size":
            column = "Household.HouseholdSize"
        elif returning == "is_prison":
            column = "CASE Household.Prison WHEN 'TRUE' THEN 1 ELSE 0 END"
        elif returning == "has_members_in_other_ehr_systems":
            column = (
                "CASE Household.MixedSoftwareHousehold WHEN 'TRUE' THEN 1 ELSE 0 END"
            )
        elif returning == "percentage_of_members_with_data_in_this_backend":
            column = "Household.TppPercentage"
        elif returning == "msoa":
            column = "Household.MSOA"
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")
        return f"""
        SELECT
          Patient_ID AS patient_id,
          {column} AS {returning}
        FROM HouseholdMember
        INNER JOIN Household
        ON HouseholdMember.Household_ID = Household.Household_ID
        WHERE Household.NFA_Unknown != 1
        """

    def patients_attended_emergency_care(
        self,
        between=None,
        returning=None,
        find_first_match_in_period=None,
        find_last_match_in_period=None,
        with_these_diagnoses=None,
        discharged_to=None,
    ):
        if find_first_match_in_period:
            ordering = "ASC"
            date_aggregate = "MIN"
        else:
            ordering = "DESC"
            date_aggregate = "MAX"

        if returning == "binary_flag":
            column = "1"
            use_partition_query = False
        elif returning == "date_arrived":
            column = f"{date_aggregate}(Arrival_Date)"
            use_partition_query = False
        elif returning == "number_of_matches_in_period":
            column = "COUNT(*)"
            use_partition_query = False
        elif returning == "discharge_destination":
            column = "Discharge_Destination_SNOMED_CT"
            use_partition_query = True
        else:
            assert False

        date_condition, date_joins = self.get_date_condition(
            "EC", "Arrival_Date", between
        )
        conditions = [date_condition]

        if with_these_diagnoses:
            assert isinstance(with_these_diagnoses, list)
            assert isinstance(with_these_diagnoses[0], str)
            codes = ", ".join(map(quote, with_these_diagnoses))
            fragments = [f"EC_Diagnosis_{ix:02} IN ({codes})" for ix in range(1, 25)]
            conditions.append("(" + " OR ".join(fragments) + ")")

        if discharged_to:
            assert isinstance(discharged_to, list)
            assert isinstance(discharged_to[0], str)
            codes = ", ".join(map(quote, discharged_to))
            conditions.append(f"Discharge_Destination_SNOMED_CT IN ({codes})")

        conditions = " AND ".join(conditions)

        if use_partition_query:
            # Note EC_Ident is not guaranteed unique by the database but I
            # suspect it is intended to be unique by the source. Out of ~20m
            # rows currently there are only two duplicate EC_Idents and these
            # are for rows identical in all respects apart from Patient_ID.
            # Thus while using EC_Ident as the final sort column below doesn't
            # absolutely *guaranteee* a deterministic sort order, I think it's
            # good enough.
            sql = f"""
            SELECT
              t.Patient_ID AS patient_id,
              {column} AS {returning}
            FROM (
              SELECT EC.Patient_ID, {column},
              ROW_NUMBER() OVER (
                PARTITION BY EC.Patient_ID
                ORDER BY Arrival_Date {ordering}, EC.EC_Ident
              ) AS rownum
              FROM EC
              INNER JOIN EC_Diagnosis
                ON EC.EC_Ident = EC_Diagnosis.EC_Ident
              {date_joins}
              WHERE {conditions}
            ) t
            WHERE rownum = 1
            """
        else:
            sql = f"""
            SELECT
              EC.Patient_ID AS patient_id,
              {column} AS {returning}
            FROM EC
            INNER JOIN EC_Diagnosis
              ON EC.EC_Ident = EC_Diagnosis.EC_Ident
            {date_joins}
            WHERE {conditions}
            GROUP BY EC.Patient_ID
            """
        return sql

    def patients_admitted_to_hospital(
        self,
        between=None,
        returning=None,
        find_first_match_in_period=None,
        find_last_match_in_period=None,
        with_these_primary_diagnoses=None,
        with_these_diagnoses=None,
        with_these_procedures=None,
        with_at_least_one_day_in_critical_care=False,
        **kwargs,
    ):
        supported_columns = {
            "admission_method": "Admission_Method",
            "source_of_admission": "Source_of_Admission",
            "discharge_destination": "Discharge_Destination",
            "patient_classification": "Patient_Classification",
            "admission_treatment_function_code": "Der_Admit_Treatment_Function_Code",
            "days_in_critical_care": "APCS_Der.Spell_PbR_CC_Day",
            "administrative_category": "Administrative_Category",
            "duration_of_elective_wait": "Duration_of_Elective_Wait",
        }

        if returning in [
            "total_bed_days_in_period",
            "total_critical_care_days_in_period",
        ]:
            # Check unhandled arguments are unused
            assert (
                not find_first_match_in_period
            ), f"Cannot use 'find_first_match_in_period' when returning '{returning}'"
            assert (
                not find_last_match_in_period
            ), f"Cannot use 'find_last_match_in_period' when returning '{returning}'"

        column_conditions = {}
        for column in supported_columns.keys():
            keyword = f"with_{column}"
            value = kwargs.pop(keyword, None)
            if value is not None:
                column_conditions[column] = value
        if kwargs:
            raise TypeError(f"Unexpected keyword argument {list(kwargs)[0]!r}")

        if find_first_match_in_period:
            ordering = "ASC"
            date_aggregate = "MIN"
        else:
            ordering = "DESC"
            date_aggregate = "MAX"

        use_sum_query = False
        if returning == "binary_flag":
            returning_column = "1"
            use_partition_query = False
        elif returning == "date_admitted":
            returning_column = f"{date_aggregate}(Admission_Date)"
            use_partition_query = False
        elif returning == "date_discharged":
            returning_column = f"{date_aggregate}(Discharge_Date)"
            use_partition_query = False
        elif returning == "number_of_matches_in_period":
            returning_column = "COUNT(*)"
            use_partition_query = False
        elif returning == "primary_diagnosis":
            returning_column = "Spell_Primary_Diagnosis"
            use_partition_query = True
        elif returning == "total_bed_days_in_period":
            # We need to return total bed DAYS from the column Der_Spell_LoS, which represents
            # length of stay in NIGHTS (0 represents one day's stay)
            # In case of duplicate spells that start on the same date, we take the
            # max value by admission date
            returning_column = "MAX(Der_Spell_LoS)"
            use_sum_query = True
            sum_adjustment = " + 1"
            use_partition_query = False
        elif returning == "total_critical_care_days_in_period":
            # In case of duplicate spells that start on the same date, we take the
            # max value by admission date
            returning_column = "MAX(CAST(APCS_Der.Spell_PbR_CC_Day AS INTEGER))"
            use_sum_query = True
            sum_adjustment = ""
            use_partition_query = False
        elif returning in supported_columns:
            returning_column = supported_columns[returning]
            use_partition_query = True
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")

        date_condition, date_joins = self.get_date_condition(
            "APCS", "Admission_Date", between
        )
        conditions = [date_condition]

        for column_name, column_value in column_conditions.items():
            value_sql = ", ".join(map(quote, to_list(column_value)))
            conditions.append(f"{supported_columns[column_name]} IN ({value_sql})")

        if with_at_least_one_day_in_critical_care:
            conditions.append("CAST(APCS_Der.Spell_PbR_CC_Day AS int) > 0")

        if with_these_primary_diagnoses:
            assert with_these_primary_diagnoses.system == "icd10"
            fragments = [
                f"APCS_Der.Spell_Primary_Diagnosis LIKE {pattern} ESCAPE '!'"
                for pattern in codelist_to_like_patterns(
                    with_these_primary_diagnoses, prefix="", suffix="%"
                )
            ]
            conditions.append("(" + " OR ".join(fragments) + ")")

        if with_these_diagnoses:
            assert with_these_diagnoses.system == "icd10"
            fragments = [
                f"Der_Diagnosis_All LIKE {pattern} ESCAPE '!'"
                for pattern in codelist_to_like_patterns(
                    with_these_diagnoses, prefix="%[^A-Za-z0-9]", suffix="%"
                )
            ]
            conditions.append("(" + " OR ".join(fragments) + ")")

        if with_these_procedures:
            assert with_these_procedures.system == "opcs4"
            fragments = [
                f"Der_Procedure_All LIKE {pattern} ESCAPE '!'"
                for pattern in codelist_to_like_patterns(
                    with_these_procedures, prefix="%[^A-Za-z0-9]", suffix="%"
                )
            ]
            conditions.append("(" + " OR ".join(fragments) + ")")

        conditions = " AND ".join(conditions)

        if use_partition_query:
            # Note APCS_Ident is not guaranteed unique by the database but I
            # suspect it is intended to be unique by the source. For one thing,
            # it seems to be used as a foreign key in the other ACDS tables.
            # And out of ~3.5m rows currently there are only four duplicate
            # APCS_Idents and these are for rows identical in all respects
            # apart from Patient_ID.  Thus while using APCS_Ident as the final
            # sort column below doesn't absolutely *guaranteee* a deterministic
            # sort order, I think it's good enough.
            sql = f"""
            SELECT
              t.Patient_ID AS patient_id,
              t.{returning} AS {returning}
            FROM (
              SELECT APCS.Patient_ID, {returning_column} AS {returning},
              ROW_NUMBER() OVER (
                PARTITION BY APCS.Patient_ID
                ORDER BY Admission_Date {ordering}, APCS.APCS_Ident
              ) AS rownum
              FROM APCS
              INNER JOIN APCS_Der
                ON APCS.APCS_Ident = APCS_Der.APCS_Ident
              {date_joins}
              WHERE {conditions}
            ) t
            WHERE rownum = 1
            """
        elif use_sum_query:
            sql = f"""
            SELECT patient_id, SUM({returning}{sum_adjustment}) AS {returning}
            FROM (
              SELECT
                APCS.Patient_ID AS patient_id,
                {returning_column} AS {returning}
                FROM APCS
                INNER JOIN APCS_Der
                  ON APCS.APCS_Ident = APCS_Der.APCS_Ident
                {date_joins}
                WHERE {conditions}
                GROUP BY APCS.Patient_ID, APCS.Admission_Date
              ) t
            GROUP BY patient_id
            """
        else:
            sql = f"""
            SELECT
              APCS.Patient_ID AS patient_id,
              {returning_column} AS {returning}
            FROM APCS
            INNER JOIN APCS_Der
              ON APCS.APCS_Ident = APCS_Der.APCS_Ident
            {date_joins}
            WHERE {conditions}
            GROUP BY APCS.Patient_ID
            """
        return sql

    def patients_with_high_cost_drugs(
        self,
        drug_name_matches=None,
        # Set date limits
        between=None,
        # Set return type
        returning="binary_flag",
        # Matching rule
        find_first_match_in_period=None,
        find_last_match_in_period=None,
        include_date_of_match=False,
    ):
        drug_name_matches = to_list(drug_name_matches)
        if drug_name_matches:
            drug_name_condition = f"DrugName IN ({codelist_to_sql(drug_name_matches)})"
        else:
            drug_name_condition = "1 = 1"

        # Result ordering
        if find_first_match_in_period:
            date_aggregate = "MIN"
        else:
            date_aggregate = "MAX"

        if returning == "binary_flag":
            column_definition = "1"
        elif returning == "date":
            column_definition = f"{date_aggregate}(t.date)"
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")

        date_condition, date_joins = self.get_date_condition("t", "t.date", between)

        return f"""
        SELECT
          t.Patient_ID as patient_id,
          {column_definition} AS {returning}
        FROM (
          SELECT
            Patient_ID,
            DrugName,
            DATEFROMPARTS(
              (CAST(FinancialYear AS INT) / 100) + IIF(CAST(FinancialMonth AS INT) > 9, 1, 0),
              ((CAST(FinancialMonth AS INT) + 2) % 12) + 1,
              1
            ) AS date
          FROM
            HighCostDrugs
          WHERE
            {drug_name_condition}
        ) t
        {date_joins}
        WHERE {date_condition}
        GROUP BY t.Patient_ID
        """

    def patients_with_ethnicity_from_sus(
        self,
        returning="code",
        use_most_frequent_code=None,
    ):
        returning_options = ["code", "group_6", "group_16"]
        if returning not in returning_options:
            options = ", ".join(returning_options)
            raise ValueError(
                f"Unknown value for 'returning' ({returning}), valid options are: {options}"
            )

        if not use_most_frequent_code:
            raise ValueError("use_most_frequent_code must be set to 'True'")

        if returning == "code":
            column_definition = "ethnicity_code"
        elif returning == "group_6":
            # built from the Grouping_16 -> Group_6 mapping in our ethnicity codelist:
            #  https://codelists.opensafely.org/codelist/opensafely/ethnicity/2020-04-27/#full-list
            group_6_lut = {
                "A": "1",
                "B": "1",
                "C": "1",
                "D": "2",
                "E": "2",
                "F": "2",
                "G": "2",
                "H": "3",
                "J": "3",
                "K": "3",
                "L": "3",
                "M": "4",
                "N": "4",
                "P": "4",
                "R": "5",
                "S": "5",
            }
            whens = "\n".join(
                [
                    f"WHEN ethnicity_code LIKE '{raw}%' THEN {mapped}"
                    for raw, mapped in group_6_lut.items()
                ]
            )
            column_definition = f"""
            CASE
                {whens}
                ELSE 0
            END
            """
        elif returning == "group_16":
            group_16_lut = {
                "A": "1",
                "B": "2",
                "C": "3",
                "D": "4",
                "E": "5",
                "F": "6",
                "G": "7",
                "H": "8",
                "J": "9",
                "K": "10",
                "L": "11",
                "M": "12",
                "N": "13",
                "P": "14",
                "R": "15",
                "S": "16",
            }
            whens = "\n".join(
                [
                    f"WHEN ethnicity_code LIKE '{raw}%' THEN {mapped}"
                    for raw, mapped in group_16_lut.items()
                ]
            )
            column_definition = f"""
            CASE
                {whens}
                ELSE 0
            END
            """
        else:
            column_definition = "1"

        sql = f"""
        SELECT
          Patient_ID,
          {column_definition} AS {returning}
        FROM (
          SELECT
            Patient_ID,
            ethnicity_code,
            ROW_NUMBER() OVER (
                PARTITION BY Patient_ID ORDER BY COUNT(ethnicity_code) DESC
            ) AS row_num
          FROM (
            SELECT
              Patient_ID,
              Ethnic_group AS ethnicity_code
            FROM
              APCS
            UNION ALL
            SELECT
              Patient_ID,
              Ethnic_Category AS ethnicity_code
            FROM
              EC
            UNION ALL
            SELECT
              Patient_ID,
              Ethnic_Category AS ethnicity_code
            FROM
              OPA
          ) t
          WHERE ethnicity_code IS NOT NULL
            AND ethnicity_code != '99'
            AND CHARINDEX('Z', ethnicity_code) != 1
          GROUP BY Patient_ID, ethnicity_code
        ) t
        WHERE row_num = 1
        """
        return sql

    def patients_with_healthcare_worker_flag_on_covid_vaccine_record(self, returning):
        assert returning == "binary_flag"
        return """
        SELECT
          Patient_ID as patient_id,
          1 as binary_flag
        FROM
          HealthCareWorker
        WHERE
          HealthCareWorker.HealthCareWorker = 'Y'
        GROUP BY
          patient_id
        """

    def patients_outpatient_appointment_date(
        self,
        attended=None,
        is_first_attendance=None,
        with_these_treatment_function_codes=None,
        with_these_procedures=None,
        between=None,
        find_first_match_in_period=None,
        returning="binary_flag",
    ):
        date_condition, date_joins = self.get_date_condition(
            "OPA", "Appointment_Date", between
        )

        conditions = [date_condition]

        if attended:
            # codes from `ATTENDED` field in HES data dictionary
            # https://github.com/opensafely-core/cohort-extractor/issues/492#issuecomment-888961963
            attended_conditions = [
                "Attendance_Status = 5",
                "Attendance_Status = 6",
            ]
            conditions.append("(" + " OR ".join(attended_conditions) + ")")

        if is_first_attendance:
            # codes from `FIRSTATT` field in HES data dictionary
            # https://github.com/opensafely-core/cohort-extractor/issues/492#issuecomment-889017544
            is_first_attendance_conditions = [
                "First_Attendance = 1",
                "First_Attendance = 3",
            ]
            conditions.append("(" + " OR ".join(is_first_attendance_conditions) + ")")

        if with_these_treatment_function_codes:
            with_these_treatment_function_codes_conditions = codelist_to_sql(
                with_these_treatment_function_codes
            )
            conditions.append(
                f"""Treatment_Function_Code IN ({with_these_treatment_function_codes_conditions})"""
            )

        procedures_joins = ""
        if with_these_procedures:
            assert with_these_procedures.system == "opcs4"
            fragments = [
                f"OPA_Proc.Primary_Procedure_Code LIKE {pattern} ESCAPE '!'"
                for pattern in codelist_to_like_patterns(
                    with_these_procedures, prefix="%", suffix="%"
                )
            ]
            conditions.append("(" + " OR ".join(fragments) + ")")
            procedures_joins = "JOIN OPA_Proc ON OPA.OPA_Ident = OPA_Proc.OPA_Ident"

        conditions = " AND ".join(conditions)

        # Result ordering
        if find_first_match_in_period:
            ordering = "ASC"
            date_aggregate = "MIN"
        else:
            ordering = "DESC"
            date_aggregate = "MAX"

        use_partition_query = False

        if returning == "binary_flag":
            column_definition = "1"
        elif returning == "date":
            column_definition = f"""{date_aggregate}(Appointment_Date)"""
        elif returning == "number_of_matches_in_period":
            column_definition = "COUNT(OPA_Ident)"
        elif returning == "consultation_medium_used":
            column_definition = "Consultation_Medium_Used"
            use_partition_query = True
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")

        if use_partition_query:
            return f"""
            SELECT
              t.Patient_ID AS patient_id,
              t.{column_definition} AS {returning}
            FROM (
              SELECT
                OPA.Patient_ID,
                {column_definition} AS {returning},
                ROW_NUMBER() OVER (
                  PARTITION BY OPA.Patient_ID
                  ORDER BY Appointment_Date {ordering}
                ) AS rownum
              FROM OPA
              {date_joins}
              {procedures_joins}
              WHERE {conditions}
            ) t
            WHERE rownum = 1
            """
        else:
            return f"""
            SELECT
              OPA.Patient_ID AS patient_id,
              {column_definition} AS {returning}
            FROM
              OPA
              {date_joins}
              {procedures_joins}
            WHERE {conditions}
            GROUP BY
              OPA.Patient_ID
            """

    @staticmethod
    def _format_risk_group(original_string):
        # First remove any "Patients with [a]" and replace " and " with "," within individual risk group fields
        replaced = f"REPLACE(REPLACE(REPLACE({original_string}, 'Patients with a ', ''),  'Patients with ', ''), ' and ', ',')"
        # coalesce with a leading ',' and replace nulls with empty strings
        coalesced = f"coalesce(',' + NULLIF({replaced}, ''), '')"
        # use stuff to remove the first ','
        return f"STUFF({coalesced}, 1, 1, '')"

    def create_therapeutics_table(self):
        """
        Create a temporarary Therapeutics table to use for `with_covid_therapeutics` queries
        All columns in the Therapeutics table are VARCHAR.  This casts the two date columns that
        we use in queries to DATE type, and adds case insensitive collation to the Interventaion
        and CurrentStatus columns.
        All columns are included, including those that we don't use, so that when we remove
        duplicates, we only remove complete duplicate rows
        """
        if self._therapeutics_table_name is None:
            self._therapeutics_table_name = self.get_temp_table_name("therapeutics")
            collation = "Latin1_General_CI_AS"
            queries = [
                f"""
            -- Creating theraputics temp table
            SELECT DISTINCT
                Patient_ID,
                CAST(TreatmentStartDate AS DATE) AS TreatmentStartDate,
                CAST(Received AS DATE) AS Received,
                Intervention COLLATE {collation} AS Intervention,
                CurrentStatus COLLATE {collation} AS CurrentStatus,
                COVID_Indication,
                Region,
                {self._format_risk_group('MOL1_high_risk_cohort')} as MOL1_high_risk_cohort,
                {self._format_risk_group('SOT02_risk_cohorts')} as SOT02_risk_cohorts,
                {self._format_risk_group('CASIM05_risk_cohort')} as CASIM05_risk_cohort,
                AgeAtReceivedDate,
                FormName,
                MOL1_onset_of_symptoms,
                SOT02_onset_of_symptoms,
                Count,
                Der_LoadDate
             INTO {self._therapeutics_table_name} FROM Therapeutics
            """
            ]
        else:
            queries = []
        return self._therapeutics_table_name, queries

    def patients_with_covid_therapeutics(
        self,
        with_these_statuses=None,
        with_these_therapeutics=None,
        with_these_indications=None,
        # Set date limits
        between=None,
        # Set return type
        returning="binary_flag",
        # Matching rule
        find_first_match_in_period=None,
        find_last_match_in_period=None,
        include_date_of_match=False,
        episode_defined_as=None,
    ):
        therapeutics_table_name, therapeutic_queries = self.create_therapeutics_table()

        filter_conditions = []
        # status may be provided as a single string or a list
        # Available options are: 'Approved','Treatment Complete','Treatment Not Started','Treatment Stopped'
        # Deal with whitespace/case before matching
        status_matches = to_list(with_these_statuses)
        if status_matches:
            statuses = [quote(status.strip()) for status in status_matches]
            filter_conditions.append(f"CurrentStatus IN ({', '.join(statuses)})")

        # Data (Jan 2022) contains the following values:
        # 'Casirivimab and imdevimab '[note trailing space], 'Molnupiravir', 'Remdesivir', 'sarilumab', 'Sotrovimab' , 'Tocilizumab'
        # Allow for case insensitive matching and whitespace
        therapeutic_matches = to_list(with_these_therapeutics)
        if therapeutic_matches:
            fragments = [
                f"Intervention LIKE {pattern} ESCAPE '!'"
                for pattern in codelist_to_like_patterns(
                    therapeutic_matches, prefix="%", suffix="%"
                )
            ]
            filter_conditions.append("(" + " OR ".join(fragments) + ")")

        indication_matches = to_list(with_these_indications)
        if indication_matches:
            valid_indications = [
                "hospital_onset",
                "hospitalised_with",
                "non_hospitalised",
            ]
            for indication in indication_matches:
                assert (
                    indication in valid_indications
                ), f"'{indication}' is not a valid indication; options are {', '.join(valid_indications)}"
            indications = [quote(indication) for indication in indication_matches]
            filter_conditions.append(f"COVID_indication IN ({', '.join(indications)})")

        date_condition, date_joins = self.get_date_condition(
            therapeutics_table_name, "TreatmentStartDate", between
        )
        filter_conditions.append(date_condition)

        where_filter_conditions = (
            f"WHERE {' AND '.join(filter_conditions)}" if filter_conditions else ""
        )

        if returning == "number_of_episodes":
            # Check unhandled arguments are unused
            assert (
                not find_first_match_in_period
            ), "Cannot use 'find_first_match_in_period' when returning 'number_of_episodes'"
            assert (
                not find_last_match_in_period
            ), "Cannot use 'find_last_match_in_period' when returning 'number_of_episodes'"
            assert (
                not include_date_of_match
            ), "Cannot use 'include_date_of_match' when returning 'number_of_episodes'"
            return self._number_of_episodes_by_covid_therapeutics(
                therapeutics_table_name,
                therapeutic_queries,
                date_joins,
                where_filter_conditions,
                episode_defined_as,
            )
        # This is the default code path for most queries
        else:
            assert (
                not episode_defined_as
            ), "Can only use 'episode_defined_as' when returning 'number_of_episodes'"

        # Result ordering
        if find_first_match_in_period:
            ordering = "ASC"
        else:
            ordering = "DESC"

        use_partition_query = True
        if returning == "binary_flag" or returning == "date":
            returning = "binary_flag"
            column_definition = "1"
        elif returning == "therapeutic":
            # remove whitespace, convert to comma-separated string
            column_definition = "REPLACE(LTRIM(RTRIM(Intervention)), ' and ', ',')"
        elif returning == "risk_group":
            # Join the 3 risk cohort fields with ","
            # Note that the last "s" in SOT02_risk_cohorts is correct
            # coalesce the parts with a leading ','
            coalesced_parts = " + ".join(
                f"coalesce(',' + NULLIF({risk_group_column}, ''), '')"
                for risk_group_column in [
                    "MOL1_high_risk_cohort",
                    "SOT02_risk_cohorts",
                    "CASIM05_risk_cohort",
                ]
            )
            # use stuff to remove the first ','
            column_definition = f"STUFF({coalesced_parts}, 1, 1, '')"
        elif returning == "region":
            column_definition = "Region"
        elif returning == "number_of_matches_in_period":
            column_definition = "COUNT(*)"
            use_partition_query = False
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")

        if use_partition_query:
            # There can be duplicates per patient in the Therapeutics dataset, which differ on one
            # or more field (We remove fully duplicate rows in the temp table only)
            # These are likely to be invalid in some way, e.g. the result of entering the form twice
            # We keep these data in - users can identify whether there are duplicates by using the
            # `number_of_matches_in_period` return value and deal with them as appropriate

            # We always return just one row per patient, either the first or last by TreatmentStartDate.
            # The query sorts per-patient rows by all the fields that have been identified to
            # contain duplicate values for a patient.  In the case of duplicate TreatmentStartDates, this
            # ensures a consistent return value each time.
            sql = f"""
            SELECT
              t.Patient_ID AS patient_id,
              {column_definition} AS {returning},
              t.TreatmentStartDate AS date
            FROM (
              SELECT
                {therapeutics_table_name}.Patient_ID,
                TreatmentStartDate,
                Received,
                Intervention,
                COVID_indication,
                CurrentStatus,
                MOL1_high_risk_cohort,
                SOT02_risk_cohorts,
                CASIM05_risk_cohort,
                Region,
                ROW_NUMBER() OVER (
                  PARTITION BY {therapeutics_table_name}.Patient_ID
                  ORDER BY TreatmentStartDate {ordering},
                    Received,
                    CurrentStatus,
                    Intervention,
                    Region,
                    MOL1_high_risk_cohort,
                    SOT02_risk_cohorts,
                    CASIM05_risk_cohort
                ) AS rownum
              FROM {therapeutics_table_name}
              {date_joins}
              {where_filter_conditions}
            ) t
            WHERE t.rownum = 1
            """
        else:
            # number_of_matches_in_period only
            sql = f"""
            SELECT
            t.Patient_ID as patient_id,
            {column_definition} AS {returning}
            FROM (
            SELECT
                {therapeutics_table_name}.Patient_ID,
                TreatmentStartDate,
                Intervention,
                COVID_indication,
                CurrentStatus
            FROM
                {therapeutics_table_name}
                {date_joins}
                {where_filter_conditions}
            ) t
            GROUP BY t.Patient_ID
            """
        return therapeutic_queries + [sql]

    def _number_of_episodes_by_covid_therapeutics(
        self,
        therapeutics_table_name,
        therapeutic_queries,
        date_joins,
        where_filter_conditions,
        episode_defined_as,
    ):
        if episode_defined_as is not None:
            pattern = r"^series of events each <= (\d+) days apart$"
            match = re.match(pattern, episode_defined_as)
            if not match:
                raise ValueError(
                    f"Argument `episode_defined_as` must match " f"pattern: {pattern}"
                )
            washout_period = int(match.group(1))
        else:
            washout_period = 0

        sql = f"""
        SELECT
          t.Patient_ID AS patient_id,
          SUM(is_new_episode) AS number_of_episodes
        FROM (
            SELECT
              {therapeutics_table_name}.Patient_ID,
              Intervention,
              COVID_indication,
              CurrentStatus,
              CASE
                WHEN
                  DATEDIFF(
                    day,
                    LAG(TreatmentStartDate) OVER (
                      PARTITION BY {therapeutics_table_name}.Patient_ID ORDER BY TreatmentStartDate
                    ),
                    TreatmentStartDate
                  ) <= {washout_period}
                THEN 0
                ELSE 1
              END AS is_new_episode
            FROM {therapeutics_table_name}
            {date_joins}
            {where_filter_conditions}
        ) t
        GROUP BY t.Patient_ID
        """
        return therapeutic_queries + [sql]

    def patients_with_value_from_file(
        self, f_path, returning=None, returning_type=None
    ):
        if not is_csv_filename(f_path):
            raise TypeError(f"Unexpected file type {f_path}")

        if returning is not None and returning_type is None:
            # StudyDefinition.get_pandas_csv_args() should have raised an error before
            # we reach here.
            raise TypeError(
                "If `returning` is passed, then `returning_type` must be passed"
            )

        if returning is None and returning_type is not None:
            raise TypeError(
                "If `returning_type` is passed, then `returning` must be passed"
            )

        # Compiled patterns passed to the module-level matching functions are
        # cached. As we don't use many patterns, we need not worry
        # about compiling them first.
        if returning is not None and not re.fullmatch(r"\w+", returning, re.ASCII):
            raise ValueError(
                "The column name given by `returning` should contain only alphanumeric characters and the underscore character"
            )

        # Fail before reading the CSV file
        if returning_type == "bool" or returning_type is None:
            column_type = "INT"
        elif returning_type == "date":
            column_type = "DATE"
        elif returning_type == "str":
            column_type = "VARCHAR(MAX)"
        elif returning_type == "int":
            column_type = "INT"
        elif returning_type == "float":
            column_type = "FLOAT"
        else:
            # StudyDefinition.get_pandas_csv_args() should have raised an error before
            # we reach here.
            raise TypeError(f"Unexpected type {returning_type}")

        # Which columns of the CSV file should we read?
        usecols = ["patient_id"]
        if returning is not None:
            usecols.append(returning)

        # Read the CSV file into a data frame
        values = pandas.read_csv(
            f_path, index_col="patient_id", usecols=usecols, dtype=str
        )

        if returning is None:
            # Adding a dummy column here makes it easier to generate the SQL
            values["value"] = 1
            returning = "value"

        # Generate the SQL
        table_name = self.get_temp_table_name("file")
        queries = [
            f"""
            -- Uploading file for {returning}
            CREATE TABLE {escape_identifer(table_name)} (
                patient_id BIGINT,
                {escape_identifer(returning)} {column_type}
            )
            """,
        ]
        queries += make_batches_of_insert_statements(
            table_name, ("patient_id", returning), list(values.itertuples())
        )
        queries.append(
            f"""
            SELECT
                patient_id,
                {escape_identifer(returning)}
            FROM
                {escape_identifer(table_name)}
            """
        )

        return queries

    def patients_which_exist_in_file(self, f_path):
        return self.patients_with_value_from_file(f_path)

    def patients_with_an_isaric_record(
        self,
        returning,
        between=None,
        date_filter_column=None,
        return_expectations=None,
    ):

        queries = []
        table = "ISARIC_Patient_Data_TopLine"

        if returning not in ISARIC_COLUMN_MAPPINGS:
            raise TypeError(f"returning={returning} is not a valid ISARIC column")

        value_type = ISARIC_COLUMN_MAPPINGS[returning]

        if value_type == "str":
            cast = returning
        elif value_type == "date":  # int, float, date
            # 103 is British date format, dd/mm/yyyy, which the ISARIC dates are in
            cast = f"CONVERT(DATE, {returning}, 103)"
        else:  # int, float, date
            cast = f"CAST({returning} AS {value_type.upper()})"

        if between not in [None, (None, None)] and date_filter_column:
            filter_type = ISARIC_COLUMN_MAPPINGS.get(date_filter_column)
            if filter_type is None:
                raise TypeError(
                    f"date_filter_column={date_filter_column} is not a valid ISARIC column"
                )
            elif filter_type != "date":
                raise TypeError(
                    f"date_filter_column={date_filter_column} is type {filter_type}, not a date"
                )

            # 103 is British date format, dd/mm/yyyy, which the ISARIC dates are in
            date_expression = f"""
                CASE WHEN {date_filter_column} IN ('', 'NA') THEN NULL
                ELSE CONVERT(DATE, {date_filter_column}, 103)
                END
            """
            date_condition, date_joins = self.get_date_condition(
                table, date_expression, between
            )
        elif date_filter_column:
            raise TypeError("you specified `date_filter_column` but not between")
        elif between not in [None, (None, None)]:
            raise TypeError("you specified `between` but not date_filter_column")
        else:
            date_condition = None
            date_joins = ""

        query = f"""
            SELECT
                Patient_ID as patient_id,
                CASE WHEN {returning} IN ('', 'NA') THEN NULL
                ELSE {cast}
                END AS {returning}
            FROM {table}
            {date_joins}
        """

        if date_condition:
            query += f" WHERE {date_condition}"

        queries.append(query)
        return queries

    def create_ons_cis_table(self):
        """
        Create a temporarary ons_cis table to use for `with_an_ons_cis_record` queries
        Remove complete duplicate rows so we don't count them when returning `number_of_matches`
        """
        if self._ons_cis_table_name is None:
            self._ons_cis_table_name = self.get_temp_table_name("ons_cis")
            queries = [
                f"""
            -- Creating ons_cis temp table
            SELECT DISTINCT Patient_ID, {', '.join(ONS_CIS_COLUMN_MAPPINGS)}
             INTO {self._ons_cis_table_name} FROM ONS_CIS
            """
            ]
        else:
            queries = []
        return self._ons_cis_table_name, queries

    def patients_with_an_ons_cis_record(
        self,
        returning="binary_flag",
        return_category_labels=True,
        date_filter_column=None,
        between=None,
        # Matching rule
        find_first_match_in_period=None,
        find_last_match_in_period=None,
        include_date_of_match=False,
    ):

        table, table_queries = self.create_ons_cis_table()

        # Result ordering
        if find_first_match_in_period:
            ordering = "ASC"
        else:
            ordering = "DESC"

        # There can be multiple rows per patient in the ONS_CIS dataset
        # Partition query is used for all return values except `number_of_matches_in_period`
        use_partition_query = True
        if returning == "binary_flag":
            column_definition = "1"
        elif returning == "number_of_matches_in_period":
            column_definition = "COUNT(*)"
            use_partition_query = False
        else:
            if returning not in ONS_CIS_COLUMN_MAPPINGS:
                raise TypeError(f"returning={returning} is not a valid ONS_CIS column")
            elif returning in ONS_CIS_CATEGORY_COLUMNS:
                # Category columns are coded values with associated labels
                # By default, we convert the coded values to their labels and return the longform strings
                if return_category_labels:
                    mapping = ONS_CIS_CATEGORY_COLUMNS[returning]
                    case_definitions = "\n".join(
                        [
                            f"WHEN {table}.{returning} = {key} THEN '{value}'"
                            for key, value in mapping.items()
                        ]
                    )
                    column_definition = f"""
                        CASE
                            {case_definitions}
                        END
                    """
                else:
                    # When returning the codes rather than the string labels, we need to
                    # cast to varchar, otherwise any int-type codes will return missing
                    # values as 0, which is usually a valid category
                    column_definition = f"CAST({table}.{returning} AS VARCHAR)"
            else:
                column_definition = f"{table}.{returning}"
        if date_filter_column:
            # If we have a date_filter column, make sure it's valid
            filter_type = ONS_CIS_COLUMN_MAPPINGS.get(date_filter_column)
            if filter_type is None:
                raise TypeError(
                    f"date_filter_column={date_filter_column} is not a valid ONS_CIS column"
                )
            elif filter_type != "date":
                raise TypeError(
                    f"date_filter_column={date_filter_column} is type {filter_type}, not a date"
                )
        elif (
            between in [None, (None, None)]
            and returning == "number_of_matches_in_period"
        ):
            # We don't need to filter by date if we're just counting matches and there's no
            # date matching required; just set a default date_filter_column (which will be ignored)
            date_filter_column = "visit_date"
        else:
            # We need a date_filter_column for all returning values except counts
            # (i.e. number_of_matches_in_period) because we need to identify first or last value
            # if there are multiple rows per patient
            # For number_of_matches_in_period, we need still a date_filter_column if a
            # date-matching arg is specified
            raise ValueError("date_filter_column is required")

        date_condition, date_joins = self.get_date_condition(
            table, f"{table}.{date_filter_column}", between
        )

        if use_partition_query:
            # additionally ordering by visit_id should be enough to ensure consistent return
            # order in the event that there are duplicate values for the date_filter_column
            # The raw dataset does have duplicate visit_ids, but these are typically complete
            # duplicate rows (which we've already filtered out) or duplicates between patients
            # which are presumably an error
            sql = f"""
                SELECT
                t.Patient_ID AS patient_id,
                t.return_value as {returning},
                t.{date_filter_column} AS date
                FROM (
                SELECT
                    {table}.Patient_ID,
                    {column_definition} as return_value,
                    {table}.{date_filter_column},
                    ROW_NUMBER() OVER (
                    PARTITION BY {table}.Patient_ID
                    ORDER BY {table}.{date_filter_column} {ordering}, visit_id
                    ) AS rownum
                FROM {table}
                {date_joins}
                WHERE {date_condition}
                ) t
                WHERE t.rownum = 1
            """
        else:
            # number_of_matches_in_period only
            sql = f"""
                SELECT
                {table}.Patient_ID AS patient_id,
                {column_definition} AS {returning}
                FROM {table}
                {date_joins}
                WHERE {date_condition}
                GROUP BY {table}.Patient_ID
            """
        return table_queries + [sql]

    def patients_with_record_in_ukrr(
        self,
        # picks dataset held by UKRR
        from_dataset,
        returning,
        # Date filtering: date limits
        between=None,
        date_format=None,
        return_expectations=None,
    ):
        dataset_mapping = {
            "2019_prevalence": "2019prev",
            "2020_prevalence": "2020prev",
            "2021_prevalence": "2021prev",
            "2020_incidence": "2020inc",
            "2020_ckd": "2020ckd",
        }
        if from_dataset not in dataset_mapping.keys():
            raise ValueError(
                f"Unsupported Dataset passed to argument `from_dataset`: {from_dataset}"
            )

        date_condition, date_joins = self.get_date_condition(
            "UKRR", "rrt_start", between
        )

        column_mapping = {
            "binary_flag": 1,
            "renal_centre": "renal_centre",
            "treatment_modality_start": "mod_start",
            "treatment_modality_prevalence": "mod_prev",
            "latest_creatinine": "creat",
            "latest_egfr": "eGFR_ckdepi",
            "rrt_start_date": "rrt_start",
        }
        column_definition = column_mapping.get(returning)
        if column_definition is None:
            raise ValueError(f"Unsupported `returning` value: {returning}")

        return f"""
            SELECT Patient_ID, {column_definition} AS {returning} FROM UKRR
            WHERE dataset = '{dataset_mapping[from_dataset]}'
            AND {date_condition}
        """

    def in_maintenance_mode(self, current_mode):
        """TPP Specific maintenance mode query.

        A BuildProgress table with the following columns:

            Event (VARCHAR) - A description of the event
            BuildStart (DATETIME) - When the overall build started
            EventStart (DATETIME) - When the event started
            EventEnd (DATETIME) - When the event ended
            Duration (INT) - The duration in minutes

        TPP will insert events for:
        - The overall build (Event = 'OpenSAFELY') - This will span the other events
        - Swapping the main tables (Event = 'Swap Tables')
        - Building the CodedEvent_SNOMED table (Event = 'CodedEvent_SNOMED')

        Events from the same overall build will have the same BuildStart value
        A row will be inserted when the event starts with EventEnd = 31 Dec 9999
        That row will be updated when the event ends to set EventEnd and Duration
        So the trigger to kill currently running jobs and prevent more from
        starting will be the presence of a 'Swap Tables' row with a Start but
        no End.

        The trigger to exit maintenance mode is when the final OpenSAFELY event
        finishes.
        """

        conn = self.get_db_connection()
        cursor = conn.cursor()
        latest_rebuild = cursor.execute(
            "SELECT TOP 1 EventStart FROM BuildProgress WHERE Event = 'OpenSAFELY' ORDER BY EventStart DESC"
        )
        latest_rebuild = cursor.fetchone()
        if not latest_rebuild:
            # no events at all, we can't be in maintenance mode
            return False

        cursor.execute(
            """
            SELECT Event FROM BuildProgress
            WHERE EventEnd = '9999-12-31' AND EventStart >= %s
            ORDER BY EventStart
            """,
            latest_rebuild[0],
            log_desc=False,
        )
        current_events = [row[0] for row in cursor.fetchall()]

        # regardless of current mode, once there are no pending events, we are done.
        if current_events == []:
            return False

        # Env var allows quick change of start event logic if needed
        start_events = os.environ.get(
            "TPP_MAINTENANCE_START_EVENT", "Swap Tables,CodedEvent_SNOMED"
        ).split(",")

        # we only start maintenance mode if we're not currently in it, and we
        # see a specific event started but not finished.
        if current_mode != "db-maintenance" and any(
            e in current_events for e in start_events
        ):
            return True

        # no change
        return current_mode == "db-maintenance"


class ColumnExpression:
    def __init__(
        self,
        # SQL fragment
        expression,
        # The column type returned by the above expression
        type=None,
        # The default value of the expression for missing values
        default_value=None,
        # The names of all tables used in evaluating the expression
        source_tables=(),
        # Indicates whether the column is included in the output
        is_hidden=False,
        # Only relevant for columns of type "date": records the format in which
        # the date is represented
        date_format=None,
    ):
        self.expression = expression
        self.type = type
        self.default_value = default_value
        self.source_tables = source_tables
        self.is_hidden = is_hidden
        self.date_format = date_format

    def __str__(self):
        return self.expression


def codelist_to_list(codelist):
    if getattr(codelist, "has_categories", False):
        return [code for (code, category) in codelist]
    else:
        if isinstance(codelist, str):
            return [codelist]
        return list(codelist)


def codelist_to_like_patterns(codelist, prefix="", suffix=""):
    patterns = []
    for code in codelist_to_list(codelist):
        escaped_code = escape_like_query_fragment(code)
        patterns.append(quote(f"{prefix}{escaped_code}{suffix}"))
    return patterns


# Special characters from:
# https://docs.microsoft.com/en-us/sql/t-sql/language-elements/like-transact-sql?view=sql-server-ver15
LIKE_ESCAPE_TABLE = str.maketrans({char: f"!{char}" for char in "%_[]^"})


def escape_like_query_fragment(text):
    return text.translate(LIKE_ESCAPE_TABLE)


def codelist_to_sql(codelist):
    return ",".join(map(quote, codelist_to_list(codelist)))


def to_list(value):
    if value is None:
        return []
    if not isinstance(value, (tuple, list)):
        return [value]
    return list(value)


def standardise_if_date(value):
    """For strings that look like ISO dates, format in a SQL-Server
    friendly fashion

    """

    # ISO date strings with hyphens are unreliable in SQL Server:
    # https://stackoverflow.com/a/25548626/559140
    try:
        date = datetime.datetime.strptime(value, "%Y-%m-%d")
        value = date.strftime("%Y%m%d")
    except ValueError:
        pass
    return value


def is_iso_date(value):
    return bool(re.match(r"\d\d\d\d-\d\d-\d\d", value))


def quote(value, reformat_dates=True):
    if isinstance(value, (int, float)):
        if math.isnan(value):
            return "NULL"
        else:
            return str(value)
    else:
        value = str(value)
        if reformat_dates:
            value = standardise_if_date(value)
        # This looks a bit too simple but it's what SQLAlchemy does and it is,
        # as far as I can tell, all you need to do to encode string literals.
        # https://github.com/sqlalchemy/sqlalchemy/blob/ac1228a872/lib/sqlalchemy/dialects/mssql/base.py#L1117-L1127
        escaped = value.replace("'", "''")
        return f"'{escaped}'"


def remove_lower_date_bound(between):
    if between is not None:
        return (None, between[1])


def truncate_date(column, date_format):
    if date_format == "YYYY" or date_format is None:
        date_length = 4
    elif date_format == "YYYY-MM":
        date_length = 7
    elif date_format == "YYYY-MM-DD":
        date_length = 10
    else:
        raise ValueError(f"Unhandled date format: {date_format}")
    # Style 23 below means YYYY-MM-DD format, see:
    # https://docs.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-ver15#date-and-time-styles
    return f"CONVERT(VARCHAR({date_length}), {column}, 23)"


def coded_event_table_column(codelist):
    if codelist.system == "ctv3":
        return "CodedEvent", "CTV3Code"
    elif codelist.system == "snomed":
        return "CodedEvent_SNOMED", "ConceptID"
    else:
        assert False, codelist.system


def pop_keys_from_dict(dictionary, keys):
    new_dict = {}
    for key in keys:
        if key in dictionary:
            new_dict[key] = dictionary.pop(key)
    return new_dict


def make_batches_of_insert_statements(table_name, column_names, values):
    column_names_sql = ", ".join(map(escape_identifer, column_names))
    insert_sql = (
        f"INSERT INTO {escape_identifer(table_name)} ({column_names_sql}) VALUES"
    )

    # There's a limit on how many rows we can insert in one go using this method.
    # See: https://docs.microsoft.com/en-us/sql/t-sql/queries/table-value-constructor-transact-sql?view=sql-server-ver15#limitations-and-restrictions
    batch_size = 999
    batches = []
    for i in range(0, len(values), batch_size):
        values_batch = values[i : i + batch_size]
        values_sql_lines = ["({}, {})".format(*map(quote, row)) for row in values_batch]
        values_sql = ",\n".join(values_sql_lines)
        batches.append(f"{insert_sql}\n{values_sql}")

    return batches


def escape_identifer(identifier):
    if "[" in identifier or "]" in identifier:
        raise ValueError(f"Invalid identifier: {identifier}")
    return f"[{identifier}]"


class AppointmentStatus(enum.IntEnum):
    BOOKED = 0
    ARRIVED = 1
    DID_NOT_ATTEND = 2
    IN_PROGRESS = 3
    FINISHED = 4
    REQUESTED = 5
    BLOCKED = 6
    VISIT = 8
    WAITING = 9
    CANCELLED_BY_PATIENT = 10
    CANCELLED_BY_UNIT = 11
    CANCELLED_BY_OTHER_SERVICE = 12
    NO_ACCESS_VISIT = 14
    CANCELLED_DUE_TO_DEATH = 15
    PATIENT_WALKED_OUT = 16
