import datetime
import math
import os
import re
import uuid

import structlog

from .codelistlib import codelist
from .csv_utils import is_csv_filename, write_rows_to_csv
from .date_expressions import TrinoDateFormatter
from .expressions import format_expression
from .log_utils import LoggingDatabaseConnection, log_execution_time, log_stats
from .pandas_utils import dataframe_from_rows, dataframe_to_file
from .trino_utils import trino_connection_from_url

logger = structlog.get_logger()
sql_logger = structlog.get_logger("cohortextractor.sql")

# Characters that are safe to interpolate into SQL (see
# `placeholders_and_params` below)
safe_punctation = r" _.-+/()"
SAFE_CHARS_RE = re.compile(f"^[a-zA-Z0-9{re.escape(safe_punctation)}]+$")

PATIENT_TABLE = "patient_all_orgs_v2"
MEDICATION_TABLE = "medication_all_orgs_v2"
OBSERVATION_TABLE = "observation_all_orgs_v2"
IMMUNISATIONS_TABLE = "immunisation_all_orgs_v2"
ICNARC_TABLE = "icnarc_view"
ONS_TABLE = "ons_view"
CPNS_TABLE = "cpns_view"
# Sometimes a clinician will want to record that an event has happened at some
# point in the past without knowing the specific date. In TPP such events are
# given a date of 1900-01-01 and in EMIS they are given a date of NULL.
# However, we already use NULL as a value to indicate that a patient had no
# matching event at all, so we need another value to indicate "they had a
# matching event but at an indeterminate time in the past". For consistency's
# sake we use the same date as in TPP.
EARLIEST_DATE = "1900-01-01"


class EMISBackend:
    _db_connection = None
    _current_column_name = None

    def __init__(self, database_url, covariate_definitions, temporary_database=None):
        self.database_url = database_url
        self.covariate_definitions = covariate_definitions
        self.postprocess_covariate_definitions()
        self.next_table_id = 1
        self.temp_table_prefix = self.get_temp_table_prefix()
        self.patient_no_duplicates_table = self.add_table_prefix("patient")
        self.queries = self.get_queries(self.covariate_definitions)
        self.truncate_sql_logs = False
        logger.info(
            "Initialising EMISBackend", temp_table_prefix=self.temp_table_prefix
        )

    def postprocess_covariate_definitions(self):
        """The pseudo_id field is an integer in TPP and a string in EMIS.  It is defined
        as being an integer in process_covariate_definitions, so we override that here.
        """

        for name, (query_type, query_args) in self.covariate_definitions.items():
            if query_args.get("returning") == "pseudo_id":
                query_args["column_type"] = "str"

    def to_file(self, filename):
        result = self.execute_query()

        # Wrap the results stream in a function which captures unique IDs,
        # replaces them with sequential IDs and logs progress
        unique_ids = set()
        total_rows = 0

        def replace_ids_and_log(result):
            nonlocal total_rows
            headers = [x[0] for x in result.description]
            id_column_index = headers.index("patient_id")
            # In production "patient_id" is a string (hex-encoded hash) but in
            # test it's an int so we need to handle that correctly
            if result.description[id_column_index][1] == "integer":
                _truncate_patient_id = lambda x: x  # noqa
            else:
                _truncate_patient_id = truncate_patient_id

            yield headers

            for row in result:
                # Reduce long EMIS patient IDs (see docstring)
                patient_id = _truncate_patient_id(row[id_column_index])
                row[id_column_index] = patient_id
                unique_ids.add(patient_id)
                total_rows += 1
                if total_rows % 1000000 == 0:
                    logger.info(f"Downloaded {total_rows} results")
                yield row
            logger.info(f"Downloaded {total_rows} results")

        results = replace_ids_and_log(result)

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

        duplicates = total_rows - len(unique_ids)
        if duplicates != 0:
            raise RuntimeError(f"Duplicate IDs found ({duplicates} rows)")

    def to_dicts(self, convert_to_strings=True):
        result = self.execute_query()
        keys = [x[0] for x in result.description]
        if convert_to_strings:
            # Convert all values to str as that's what will end in the CSV
            output = [dict(zip(keys, map(str, row))) for row in result]
        else:
            output = [dict(zip(keys, row)) for row in result]

        unique_ids = set(item["patient_id"] for item in output)
        duplicates = len(output) - len(unique_ids)
        if duplicates != 0:
            raise RuntimeError(f"Duplicate IDs found ({duplicates} rows)")
        for ix, row in enumerate(output):
            row["patient_id"] = ix
        return output

    def to_sql(self):
        """
        Generate a single SQL string.

        Useful for debugging, optimising, etc.
        """
        return "\n\n\n".join(f"{query};" for query in self.queries)

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
                table_name = self.add_table_prefix(name)
                sql_list[
                    -1
                ] = f"CREATE TABLE IF NOT EXISTS {table_name} AS ({sql_list[-1]})"
                table_queries[name] = sql_list

                output_columns[name] = self.get_column_expression(
                    source=name,
                    returning=query_args.get("returning", "value"),
                    **column_args,
                )
            output_columns[name].is_hidden = is_hidden
        # If the population query defines its own temporary table then we use
        # that as the primary table to query against and left join everything
        # else against that. Otherwise, we use the `patient` table.
        if "population" in table_queries:
            primary_table = self.add_table_prefix("population")
            patient_id_expr = ColumnExpression(f"{primary_table}.registration_id")
        else:
            primary_table = self.patient_no_duplicates_table
            patient_id_expr = ColumnExpression(
                f"{self.patient_no_duplicates_table}.registration_id"
            )
        # Insert `patient_id` as the first column
        output_columns = dict(patient_id=patient_id_expr, **output_columns)
        output_columns_str = ",\n          ".join(
            f"{expr} AS {name}"
            for (name, expr) in output_columns.items()
            if not expr.is_hidden and name != "population"
        )
        joins = []
        for name in table_queries:
            if name == "population":
                continue
            table_name = self.add_table_prefix(name)
            joins.append(
                f"LEFT JOIN {table_name} ON {table_name}.registration_id = {patient_id_expr}"
            )
        joins_str = "\n          ".join(joins)
        joined_output_query = f"""
        SELECT
          {output_columns_str}
        FROM
          {primary_table}
          {joins_str}
        WHERE {output_columns["population"]} = 1
        """

        # patient_all_orgs_v2 contains a handful of duplicate registration IDs.  This
        # causes problems: because of the way we build our final query with a series of
        # N LEFT JOINs, a registration ID appearing twice in the patient table can
        # appear up to 2^N times.
        #
        # EMIS have not yet fixed this, so our first query creates a temporary table
        # which removes these duplicate registration IDs.  The number of duplicates is
        # small enough that it doesn't matter that it causes us to lose a few patients,
        # and in any case there is no way to choose between patients with duplicate
        # registration IDs.
        patient_no_duplicates_query = f"""
        CREATE TABLE IF NOT EXISTS {self.patient_no_duplicates_table} AS (
            SELECT *
            FROM {PATIENT_TABLE}
            WHERE registration_id NOT IN (
                SELECT registration_id
                FROM {PATIENT_TABLE}
                GROUP BY registration_id
                HAVING COUNT(*) > 1
            )
        )
        """
        all_queries = [patient_no_duplicates_query]

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
        table_name = self.add_table_prefix(source)
        column_expr = f"{table_name}.{returning}"
        if column_type == "date":
            column_expr = truncate_date(column_expr, date_format)
        return ColumnExpression(
            f"COALESCE({column_expr}, {quote(default_value)})",
            type=column_type,
            default_value=default_value,
            source_tables=[table_name],
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
            clauses.append(f"WHEN ({formatted_expression}) THEN {quote(category)}")
            # Record all the source tables used in evaluating the expression
            for name in names_used:
                tables_used.update(other_columns[name].source_tables)
        return ColumnExpression(
            f"CASE {' '.join(clauses)} ELSE {quote(default_value)} END",
            type=column_type,
            # Note, confusingly, this is not the same as the `default_value`
            # used above. Above it refers to the value the case-expression will
            # default to in case of no match. Below it refers to the "empty"
            # value for the column type which is almost always the empty string
            # apart from bools and ints where it's zero.
            default_value=self.get_default_value_for_type(column_type),
            source_tables=list(tables_used),
        )

    def get_aggregate_expression(
        self, other_columns, column_type, column_names, aggregate_function
    ):
        """Return an expression that is used to find the maximum or minimum value across
        a number of other given columns.

        We cannot use Table Value Constructors as in the TPP backend (this gives a
        cryptic error message: "Given correlated subquery is not supported").

        Instead, we use GREATEST() or LEAST(), but we have to be careful to handle
        correctly any arguments to GREATEST/LEAST that have replaced NULLs.  To do this,
        we replace any occurences of the default value for the given column_type with
        the most extreme value possible for the column_type.  (So when finding the
        maximum, we replace the default value with a small value, and when finding the
        minimum, with a large value.)

        If all the arguments to GREATEST/LEAST have replaced NULLs, GREATEST/LEAST will
        return the extreme value, so when that happens, we have to replace this with the
        default value for the column type.

        This gives us the result we want but it does mean we can't distinguish e.g. a
        recorded value of 0.0 from a missing value.  This, however, is a general problem
        with the way we handle NULLs in our system, and so we're not introducing any new
        difficulty here.  (It's also unlikely to be a problem in practice.)
        """

        default_value = self.get_default_value_for_type(column_type)
        function = {"MAX": "GREATEST", "MIN": "LEAST"}[aggregate_function]

        if column_type in ["int", "float"]:
            extreme_value_lookup = {"MAX": -(2**63), "MIN": 2 ** (63 - 1)}
            extreme_value = [aggregate_function]
        elif column_type == "date":
            extreme_value_lookup = {"MAX": "'0001-01-01'", "MIN": "'9999-12-31'"}
        else:
            assert False, column_type
        extreme_value = extreme_value_lookup[aggregate_function]

        components = ", ".join(
            f"""
            CASE WHEN {other_columns[name]} = {quote(default_value)}
                THEN {extreme_value}
            ELSE {other_columns[name]} END"""
            for name in column_names
        )

        # Keep track of all source tables used in evaluating this aggregate
        tables_used = set()
        for name in column_names:
            tables_used.update(other_columns[name].source_tables)
        return ColumnExpression(
            f"""
        CASE WHEN {function}({components}) = {extreme_value}
            THEN {quote(default_value)}
        ELSE {function}({components}) END""",
            type=column_type,
            default_value=default_value,
            source_tables=list(tables_used),
            # It's already been checked that date_format is consistent across
            # the source columns, so we just grab the first one and use the
            # date_format from that
            date_format=other_columns[column_names[0]].date_format,
        )

    def execute_query(self):
        cursor = self.get_db_connection().cursor()
        queries = list(self.queries)
        final_query = queries.pop()
        run_analyze = bool(os.environ.get("RUN_ANALYZE"))
        for sql in queries:
            table_name = re.search(r"CREATE TABLE IF NOT EXISTS (\w+)", sql).groups()[0]
            logger.info(f"Running query for {table_name}")
            cursor.execute(sql, log_desc=f"Create table {table_name}")
            if run_analyze:
                cursor.execute(
                    f"ANALYZE {table_name}", log_desc=f"Analyze table {table_name}"
                )

        output_table = self.get_output_table_name(os.environ.get("TEMP_DATABASE_NAME"))
        if output_table:
            logger.info(f"Running final query and writing output to '{output_table}'")
            sql = f"CREATE TABLE IF NOT EXISTS {output_table} AS {final_query}"
            cursor.execute(sql, log_desc="Create final query table")
            logger.info(f"Downloading data from '{output_table}'")
            cursor.execute(
                f"SELECT * FROM {output_table}",
                log_desc=f"Downloading data from '{output_table}'",
            )
        else:
            logger.info(
                "No TEMP_DATABASE_NAME defined in environment, downloading results "
                "directly without writing to output table"
            )
            cursor.execute(
                final_query, log_desc="Download results without writing to output table"
            )
        return cursor

    def get_output_table_name(self, temporary_database):
        if not temporary_database:
            return
        timestamp = datetime.datetime.now(datetime.timezone.utc).strftime(
            "%Y%m%d_%H%M%S"
        )
        return f"{temporary_database}..Output_{timestamp}"

    def get_temp_table_prefix(self):
        if "TEMP_TABLE_PREFIX" in os.environ:
            return os.environ["TEMP_TABLE_PREFIX"]
        timestamp = datetime.datetime.now(datetime.timezone.utc).strftime(
            "%Y%m%d_%H%M%S"
        )
        return f"_{timestamp}_{uuid.uuid4().hex[:4]}"

    def add_table_prefix(self, name):
        return f"{self.temp_table_prefix}_{name}"

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
        for query in return_value:
            assert (
                "hashed_organisation" in query
            ), f"SQL for `{column_name}` must contain 'hashed_organisation'"
        return return_value

    def create_codelist_table(self, codelist):
        table_name = self.get_temp_table_name("codelist")
        cast = int if codelist.system in ("snomed", "snomedct", "dmd") else str
        organisation_hash = quote(get_organisation_hash())
        if codelist.has_categories:
            values = ", ".join(
                f"({quote(cast(code))}, {quote(category)})"
                for code, category in codelist
            )
            queries = [
                f"""
                    CREATE TABLE IF NOT EXISTS {table_name} AS
                    SELECT code, category, {organisation_hash} AS hashed_organisation FROM (
                      VALUES {values}
                    ) AS t (code, category)
                    """
            ]
        else:
            values = ", ".join(f"({quote(cast(code))})" for code in codelist)
            queries = [
                f"""
                    CREATE TABLE IF NOT EXISTS {table_name} AS
                    SELECT code, {organisation_hash} AS hashed_organisation FROM (
                      VALUES {values}
                    ) AS t (code)
                    """
            ]
        return table_name, queries

    def get_temp_table_name(self, suffix):
        table_name = f"{self.next_table_id}_"
        self.next_table_id += 1
        # We include the current column name if available for ease of debugging
        if self._current_column_name:
            table_name += f"{self._current_column_name}_"
        table_name += suffix
        return self.add_table_prefix(table_name)

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
        date_expr = TrinoDateFormatter.cast_as_date(date_expr)
        min_date_expr = TrinoDateFormatter.cast_as_date(min_date_expr)
        max_date_expr = TrinoDateFormatter.cast_as_date(max_date_expr)

        joins = [
            f"LEFT JOIN {join_table}\n"
            f"ON {join_table}.registration_id = {table}.registration_id"
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
            f"ON {join_table}.registration_id = {table}.registration_id"
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
        # We don't yet handle any of the fancy cross-column references, just
        # plain date literals
        # Simple date literals
        if is_iso_date(date):
            return quote(date), []
        # More complicated date expressions which reference other tables
        formatter = TrinoDateFormatter(self.output_columns)
        date_expr = formatter(date)
        date_expr, column_name = formatter(date)
        tables = self.output_columns[column_name].source_tables
        return date_expr, tables

    def patients_age_as_of(self, reference_date):
        date_expr, date_joins = self.get_date_sql(
            self.patient_no_duplicates_table, reference_date
        )
        return f"""
            SELECT
              registration_id,
              hashed_organisation,
              CASE WHEN
                 date_add('year', date_diff('year', date_of_birth, {date_expr}), date_of_birth) > {date_expr}
              THEN
                 date_diff('year', date_of_birth, {date_expr}) - 1
              ELSE
                 date_diff('year', date_of_birth, {date_expr})
              END AS value
            FROM {self.patient_no_duplicates_table}
            {date_joins}
            """

    def patients_sex(self):
        return f"""
          SELECT
            registration_id,
            hashed_organisation,
            CASE gender
              -- See https://www.datadictionary.nhs.uk/data_dictionary/attributes/p/person/person_gender_code_de.asp?shownav=1
              WHEN 1 THEN 'M'
              WHEN 2 THEN 'F'
              ELSE ''
            END AS value
          FROM {self.patient_no_duplicates_table}"""

    def patients_all(self):
        """
        All patients
        """
        return f"""
            SELECT registration_id, hashed_organisation, 1 AS value
            FROM {self.patient_no_duplicates_table}
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
            OBSERVATION_TABLE, "effective_date", between
        )

        # TODO these codes need validating
        bmi_code = 301331008  # Finding of body mass index (finding)
        weight_codes = codelist(
            [
                "27113001",  # Body weight (observable entity)
                "162763007",  # On examination - weight(finding)
            ],
            system="snomedct",
        )
        height_codes = codelist(
            [
                "271603002",  # Height / growth measure (observable entity)
                "162755006",  # On examination - height (finding)
            ],
            system="snomedct",
        )

        bmi_cte = f"""
        SELECT t.registration_id, t.value, t.effective_date
        FROM (
          SELECT {OBSERVATION_TABLE}.registration_id, "value_pq_1" AS value, effective_date,
          ROW_NUMBER() OVER (
            PARTITION BY {OBSERVATION_TABLE}.registration_id ORDER BY effective_date DESC
          ) AS rownum
          FROM {OBSERVATION_TABLE}
          WHERE snomed_concept_id = {quote(bmi_code)} AND {date_condition}
          {date_joins}
        ) t
        WHERE t.rownum = 1
        """

        patients_cte = f"""
           SELECT registration_id, hashed_organisation, date_of_birth
           FROM {self.patient_no_duplicates_table}
        """
        weight_codes_sql = codelist_to_sql(weight_codes)
        weights_cte = f"""
          SELECT t.registration_id, t.weight, t.effective_date
          FROM (
            SELECT registration_id, "value_pq_1" AS weight, effective_date,
            ROW_NUMBER() OVER (PARTITION BY registration_id ORDER BY effective_date DESC) AS rownum
            FROM {OBSERVATION_TABLE}
            WHERE snomed_concept_id IN ({weight_codes_sql}) AND {date_condition}
          ) t
          WHERE t.rownum = 1
        """

        height_codes_sql = codelist_to_sql(height_codes)
        # The height date restriction is different from the others. We don't
        # mind using old values as long as the patient was old enough when they
        # were taken.
        height_date_condition, height_date_joins = self.get_date_condition(
            OBSERVATION_TABLE,
            "effective_date",
            remove_lower_date_bound(between),
        )
        heights_cte = f"""
          SELECT t.registration_id, t.height, t.effective_date
          FROM (
            SELECT registration_id, "value_pq_1" AS height, effective_date,
            ROW_NUMBER() OVER (PARTITION BY registration_id ORDER BY effective_date DESC) AS rownum
            FROM {OBSERVATION_TABLE}
            {height_date_joins}
            WHERE snomed_concept_id IN ({height_codes_sql}) AND {height_date_condition}
          ) t
          WHERE t.rownum = 1
        """

        min_age = int(minimum_age_at_measurement)

        return f"""
        SELECT
          patients.registration_id,
          hashed_organisation,
          CASE
            WHEN height = 0 THEN NULL
            ELSE ROUND(COALESCE(weight/(height*height), bmis.value), 1)
          END AS value,
          CASE
            WHEN weight IS NULL OR height IS NULL THEN DATE(bmis.effective_date)
            ELSE DATE(weights.effective_date)
          END AS date
        FROM ({patients_cte}) AS patients
        LEFT JOIN ({weights_cte}) AS weights
        ON weights.registration_id = patients.registration_id AND date_diff('year', patients.date_of_birth, weights.effective_date) >= {min_age}
        LEFT JOIN ({heights_cte}) AS heights
        ON heights.registration_id = patients.registration_id AND date_diff('year', patients.date_of_birth, heights.effective_date) >= {min_age}
        LEFT JOIN ({bmi_cte}) AS bmis
        ON bmis.registration_id = patients.registration_id AND date_diff('year', patients.date_of_birth, bmis.effective_date) >= {min_age}
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
        date_condition, date_joins = self.get_date_condition(
            OBSERVATION_TABLE, "effective_date", between
        )
        codelist_sql = codelist_to_sql(codelist)

        if on_most_recent_day_of_measurement:
            # The subquery finds, for each patient, the most recent day on which
            # they've had a measurement. The outer query selects, for each patient,
            # the mean value on that day.
            # Note, there's a CAST in the JOIN condition but apparently SQL Server can still
            # use an index for this. See: https://stackoverflow.com/a/25564539
            return f"""
            SELECT
            days.registration_id,
            days.hashed_organisation,
            {summary_function}({OBSERVATION_TABLE}."value_pq_1") AS value,
            days.date_measured AS date
            FROM (
                SELECT
                    {OBSERVATION_TABLE}.registration_id,
                    {OBSERVATION_TABLE}.hashed_organisation,
                    CAST(MAX(effective_date) AS date) AS date_measured
                FROM {OBSERVATION_TABLE}
                {date_joins}
                WHERE snomed_concept_id IN ({codelist_sql}) AND {date_condition}
                GROUP BY {OBSERVATION_TABLE}.registration_id, {OBSERVATION_TABLE}.hashed_organisation
            ) AS days
            LEFT JOIN {OBSERVATION_TABLE}
            ON (
            {OBSERVATION_TABLE}.registration_id = days.registration_id
            AND {OBSERVATION_TABLE}.snomed_concept_id IN ({codelist_sql})
            AND CAST({OBSERVATION_TABLE}.effective_date AS date) = days.date_measured
            )
            GROUP BY days.registration_id, days.hashed_organisation, days.date_measured
            """
        else:
            assert (
                include_date_of_match is False
            ), "Can only include measurement date if on_most_recent_day_of_measurement is True"

            return f"""
            SELECT
                {OBSERVATION_TABLE}.registration_id,
                {OBSERVATION_TABLE}.hashed_organisation,
                {summary_function}({OBSERVATION_TABLE}."value_pq_1") AS value
            FROM {OBSERVATION_TABLE}
                {date_joins}
            WHERE snomed_concept_id IN ({codelist_sql}) AND {date_condition}
            GROUP BY {OBSERVATION_TABLE}.registration_id, {OBSERVATION_TABLE}.hashed_organisation
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

    def patients_registered_with_one_practice_between(self, start_date, end_date):
        """
        All patients registered with the same practice through the given period
        """
        start_date_sql, end_date_sql, date_joins = self.get_date_sql(
            self.patient_no_duplicates_table, start_date, end_date
        )
        return f"""
            SELECT
                {self.patient_no_duplicates_table}.registration_id,
                {self.patient_no_duplicates_table}.hashed_organisation,
                1 AS value
            FROM {self.patient_no_duplicates_table}
            {date_joins}
            WHERE registered_date <= {start_date_sql}
              AND (registration_end_date > {end_date_sql} OR registration_end_date IS NULL)
            """

    def patients_with_these_medications(self, **kwargs):
        """
        Patients who have been prescribed at least one of this list of
        medications in the defined period
        """
        assert kwargs["codelist"].system in ("snomed", "snomedct")
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
                MEDICATION_TABLE,
                "",
                "snomed_concept_id",
                **kwargs,
            )

    def patients_with_these_clinical_events(self, **kwargs):
        """
        Patients who have had at least one of these clinical events in the
        defined period
        """
        assert kwargs["codelist"].system in ("snomed", "snomedct")
        # This uses a special case function with a "fake it til you make it" API
        if kwargs["returning"] == "number_of_episodes":
            kwargs.pop("returning")
            # Remove unhandled arguments and check they are unused
            assert not kwargs.pop("find_first_match_in_period", None)
            assert not kwargs.pop("find_last_match_in_period", None)
            assert not kwargs.pop("include_date_of_match", None)
            return self._number_of_episodes_by_clinical_event(**kwargs)
        # This is the default code path for most queries
        else:
            assert not kwargs.pop("episode_defined_as", None)
            return self._patients_with_events(
                OBSERVATION_TABLE,
                "",
                "snomed_concept_id",
                **kwargs,
            )

    def _patients_with_events(
        self,
        from_table,
        additional_join,
        code_column,
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
    ):
        codelist_table, codelist_queries = self.create_codelist_table(codelist)
        # Using COALESCE like this has the potential to produce very
        # inefficient queries by scuppering use of indices. However, my
        # understanding is there are no indicies anyway in the current Trino
        # setup so this shouldn't actually make much difference
        date_condition, date_joins = self.get_date_condition(
            from_table, f"COALESCE(effective_date, {quote(EARLIEST_DATE)})", between
        )
        ignored_day_condition, extra_queries = self._these_codes_occur_on_same_day(
            from_table, ignore_days_where_these_codes_occur
        )
        missing_value_condition = (
            "(value_pq_1 IS NOT NULL AND value_pq_1 != 0)"
            if ignore_missing_values
            else "1 = 1"
        )

        # Result ordering
        if find_first_match_in_period:
            ordering = "ASC NULLS FIRST"
            date_aggregate = "MIN"
        else:
            ordering = "DESC NULLS LAST"
            date_aggregate = "MAX"

        query_column = None
        column_name = returning
        if returning == "binary_flag" or returning == "date":
            column_name = "binary_flag"
            column_definition = "1"
            use_partition_query = False
        elif returning == "number_of_matches_in_period":
            column_definition = "COUNT(*)"
            use_partition_query = False
        elif returning == "numeric_value":
            column_definition = '"value_pq_1"'
            use_partition_query = True
        elif returning == "code":
            column_definition = f"CAST({code_column} AS VARCHAR(18))"
            query_column = code_column
            use_partition_query = True
        elif returning == "category":
            if not codelist.has_categories:
                raise ValueError(
                    "Cannot return categories because the supplied codelist does "
                    "not have any categories defined"
                )
            column_definition = "category"
            use_partition_query = True
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")

        if query_column is None:
            query_column = column_definition

        if use_partition_query:
            sql = f"""
            SELECT
              registration_id,
              hashed_organisation,
              {column_definition} AS {column_name},
              COALESCE(DATE(effective_date), {quote(EARLIEST_DATE)}) AS date
            FROM (
              SELECT
                {from_table}.registration_id,
                {from_table}.hashed_organisation,
                {query_column},
                effective_date,
                ROW_NUMBER() OVER (
                  PARTITION BY {from_table}.registration_id
                  ORDER BY effective_date {ordering}
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
            sql = f"""
            SELECT
              {from_table}.registration_id,
              {from_table}.hashed_organisation,
              {column_definition} AS {column_name},
              {date_aggregate}(COALESCE(DATE(effective_date), {quote(EARLIEST_DATE)})) AS date
            FROM {from_table}{additional_join}
            INNER JOIN {codelist_table}
            ON {code_column} = {codelist_table}.code
            {date_joins}
            WHERE {date_condition}
              AND NOT {ignored_day_condition}
              AND {missing_value_condition}
            GROUP BY {from_table}.registration_id, {from_table}.hashed_organisation
            """

        return codelist_queries + extra_queries + [sql]

    def _number_of_episodes_by_medication(
        self,
        codelist,
        # Set date limits
        between=None,
        ignore_days_where_these_codes_occur=None,
        episode_defined_as=None,
    ):
        codelist_table, codelist_queries = self.create_codelist_table(codelist)
        date_condition, date_joins = self.get_date_condition(
            MEDICATION_TABLE, "effective_date", between
        )
        ignored_day_condition, extra_queries = self._these_codes_occur_on_same_day(
            MEDICATION_TABLE, ignore_days_where_these_codes_occur
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
          registration_id,
          hashed_organisation,
          SUM(is_new_episode) AS number_of_episodes
        FROM (
            SELECT
              {MEDICATION_TABLE}.registration_id,
              {MEDICATION_TABLE}.hashed_organisation,
              CASE
                WHEN
                  date_diff(
                    'day',
                    LAG(effective_date) OVER (
                      PARTITION BY {MEDICATION_TABLE}.registration_id ORDER BY effective_date
                    ),
                    effective_date
                  ) <= {washout_period}
                THEN 0
                ELSE 1
              END AS is_new_episode
            FROM {MEDICATION_TABLE}
            INNER JOIN {codelist_table}
            ON snomed_concept_id = {codelist_table}.code
            {date_joins}
            WHERE {date_condition} AND NOT {ignored_day_condition}
        ) t
        GROUP BY registration_id, hashed_organisation
        """
        return codelist_queries + extra_queries + [sql]

    def _number_of_episodes_by_clinical_event(
        self,
        codelist,
        # Set date limits
        between=None,
        ignore_days_where_these_codes_occur=None,
        episode_defined_as=None,
        ignore_missing_values=False,
    ):
        codelist_table, codelist_queries = self.create_codelist_table(codelist)
        date_condition, date_joins = self.get_date_condition(
            OBSERVATION_TABLE, "effective_date", between
        )
        ignored_day_condition, extra_queries = self._these_codes_occur_on_same_day(
            OBSERVATION_TABLE, ignore_days_where_these_codes_occur
        )
        missing_value_condition = (
            "(value_pq_1 IS NOT NULL AND value_pq_1 != 0)"
            if ignore_missing_values
            else "1 = 1"
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
          registration_id,
          hashed_organisation,
          SUM(is_new_episode) AS number_of_episodes
        FROM (
            SELECT
              {OBSERVATION_TABLE}.registration_id,
              {OBSERVATION_TABLE}.hashed_organisation,
              CASE
                WHEN
                  date_diff(
                    'day',
                    LAG(effective_date) OVER (
                      PARTITION BY {OBSERVATION_TABLE}.registration_id ORDER BY effective_date
                    ),
                    effective_date
                  ) <= {washout_period}
                THEN 0
                ELSE 1
              END AS is_new_episode
            FROM {OBSERVATION_TABLE}
            INNER JOIN {codelist_table}
            ON snomed_concept_id = {codelist_table}.code
            {date_joins}
            WHERE {date_condition}
              AND NOT {ignored_day_condition}
              AND {missing_value_condition}
        ) t
        GROUP BY registration_id, hashed_organisation
        """
        return codelist_queries + extra_queries + [sql]

    def _these_codes_occur_on_same_day(self, joined_table, codelist):
        """
        Generates a SQL condition that filters rows in `joined_table` so that
        they only include events which happened on days where none of the codes
        in `codelist` occur in the CodedEvents table.

        We use this to support queries like "give me all the times a patient
        was prescribed this drug, but ignore any days on which they were having
        their annual COPD review".
        """
        if codelist is None:
            return "0 = 1", []
        codelist_table, queries = self.create_codelist_table(codelist)
        condition = f"""
        EXISTS (
          SELECT * FROM {OBSERVATION_TABLE} AS sameday
          INNER JOIN {codelist_table}
          ON sameday.snomed_concept_id = {codelist_table}.code
          WHERE
            sameday.registration_id = {joined_table}.registration_id
            AND CAST(sameday.effective_date AS date) = CAST({joined_table}.effective_date AS date)
        )
        """
        return condition, queries

    def patients_registered_practice_as_of(self, date, returning=None):
        # At the moment we can only return current values for the fields in question.

        if returning == "stp_code":
            column = "stp_code"
        # "msoa" is the correct option here, "msoa_code" is supported for
        # backwards compatibility
        elif returning in ("msoa", "msoa_code"):
            column = "msoa"
        elif returning == "nuts1_region_name":
            column = "english_region_name"
        elif returning == "pseudo_id":
            column = "hashed_organisation"
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")

        return f"""
            SELECT
              registration_id,
              hashed_organisation,
              {column} AS {returning}
            FROM
              {self.patient_no_duplicates_table}
            """

    def patients_date_deregistered_from_all_supported_practices(self, between):
        date_condition, date_joins = self.get_date_condition(
            self.patient_no_duplicates_table, "registration_end_date", between
        )
        return f"""
        SELECT
          registration_id,
          hashed_organisation,
          registration_end_date AS value
        FROM {self.patient_no_duplicates_table}
        {date_joins}
        WHERE {date_condition}
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
            column = "date_of_death"
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")
        if between is None:
            between = (None, None)
        min_date, max_date = between
        if max_date is None:
            max_date = "9999-12-31"  # Far enough in the future to catch everyone
        if min_date is None:
            min_date = "1900-01-01"  # Far enough in the path to catch everyone
        return f"""
        SELECT
          registration_id,
          hashed_organisation,
          {column} AS {returning}
        FROM
          {self.patient_no_duplicates_table}
        WHERE
          date_of_death BETWEEN {quote(min_date)} AND {quote(max_date)}
        """

    def patients_with_vaccination_record(
        self,
        tpp,
        emis,
        # Set date limits
        between=None,
        # Set return type
        returning="binary_flag",
        # Matching rule
        find_first_match_in_period=None,
        find_last_match_in_period=None,
    ):
        product_codes = emis.get("product_codes")
        procedure_codes = emis.get("procedure_codes")

        if returning not in ("binary_flag", "date"):
            raise ValueError(f"Unsupported `returning` value: {returning}")

        if find_first_match_in_period:
            date_aggregate = "MIN"
            date_comparator = "<"
        else:
            date_aggregate = "MAX"
            date_comparator = ">"

        codelist_queries = []
        if product_codes:
            product_codes_table, codelist_query = self.create_codelist_table(
                product_codes
            )
            codelist_queries.extend(codelist_query)
        if procedure_codes:
            procedure_codes_table, codelist_query = self.create_codelist_table(
                procedure_codes
            )
            codelist_queries.extend(codelist_query)

        if procedure_codes and product_codes:
            date_condition, date_joins = self.get_date_condition("t", "t.date", between)

            subquery = f"""
            SELECT
                t.registration_id,
                t.hashed_organisation,
                t.date
            FROM (
                SELECT
                    m.registration_id,
                    m.hashed_organisation,
                    CASE
                        WHEN m.effective_date {date_comparator} i.effective_date THEN m.effective_date
                        ELSE i.effective_date
                    END AS date
                FROM {MEDICATION_TABLE} AS m
                INNER JOIN {IMMUNISATIONS_TABLE} AS i
                    ON m.registration_id = i.registration_id
                INNER JOIN {product_codes_table}
                    ON m.snomed_concept_id = {product_codes_table}.code
                INNER JOIN {procedure_codes_table}
                    ON i.snomed_concept_id = {procedure_codes_table}.code
            ) t
            {date_joins}
            WHERE {date_condition}
            """

        elif procedure_codes:
            assert not product_codes

            date_condition, date_joins = self.get_date_condition(
                "i", "effective_date", between
            )

            subquery = f"""
                SELECT
                    i.registration_id,
                    i.hashed_organisation AS hashed_organisation,
                    1 AS has_event,
                    DATE(i.effective_date) AS date
                FROM {IMMUNISATIONS_TABLE} AS i
                INNER JOIN {procedure_codes_table}
                    ON i.snomed_concept_id = {procedure_codes_table}.code
                {date_joins}
                WHERE {date_condition}
            """

        elif product_codes:
            assert not procedure_codes

            date_condition, date_joins = self.get_date_condition(
                "m", "effective_date", between
            )

            subquery = f"""
                SELECT
                    m.registration_id,
                    m.hashed_organisation AS hashed_organisation,
                    1 AS has_event,
                    DATE(m.effective_date) AS date
                FROM {MEDICATION_TABLE} AS m
                INNER JOIN {product_codes_table}
                    ON m.snomed_concept_id = {product_codes_table}.code
                {date_joins}
                WHERE {date_condition}
            """

        else:
            raise ValueError(
                "Provide at least one of `product_codes` or `procedure_codes`"
            )

        sql = f"""
        SELECT
            s.registration_id,
            s.hashed_organisation,
            1 AS binary_flag,
            {date_aggregate}(DATE(s.date)) AS date
        FROM ({subquery}) s
        GROUP BY s.registration_id, s.hashed_organisation
        """

        return codelist_queries + [sql]

    def patients_address_as_of(self, date, returning=None, round_to_nearest=None):
        # At the moment we can only return current values for the fields in question.

        if returning == "index_of_multiple_deprivation":
            assert round_to_nearest == 100
            column = "imd_rank"
        elif returning == "rural_urban_classification":
            assert round_to_nearest is None
            column = "rural_urban"
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")

        return f"""
            SELECT
              registration_id,
              hashed_organisation,
              {column} AS {returning}
            FROM
              {self.patient_no_duplicates_table}
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
          COALESCE(date_format(icuadmissiondatetime, '%Y-%m-%d'), '9999-01-01')
            < COALESCE(date_format(originalicuadmissiondate, '%Y-%m-%d'), '9999-01-01')
        THEN
          DATE(icuadmissiondatetime)
        ELSE
          DATE(originalicuadmissiondate)
        END"""
        date_condition, date_joins = self.get_date_condition(
            ICNARC_TABLE, date_expression, between
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
                "SUM(basicdays_respiratorysupport) + SUM(advanceddays_respiratorysupport)"
            )
        elif returning == "had_basic_respiratory_support":
            column_definition = greater_than_zero_expr.format(
                "SUM(basicdays_respiratorysupport)"
            )
        elif returning == "had_advanced_respiratory_support":
            column_definition = greater_than_zero_expr.format(
                "SUM(advanceddays_respiratorysupport)"
            )
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")

        return f"""
        SELECT
          {ICNARC_TABLE}.registration_id AS registration_id,
          {ICNARC_TABLE}.hashed_organisation AS hashed_organisation,
          {column_definition} AS {returning}
        FROM
          {ICNARC_TABLE}
        {date_joins}
        WHERE {date_condition}
        GROUP BY {ICNARC_TABLE}.registration_id, {ICNARC_TABLE}.hashed_organisation
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
            "p",
            "date_parse(CAST(o.reg_stat_dod AS VARCHAR), '%Y%m%d')",
            between,
        )
        if codelist is not None:
            assert codelist.system == "icd10"
            codelist_sql = codelist_to_sql(codelist)
            code_columns = ["icd10u"]
            if not match_only_underlying_cause:
                code_columns.extend([f"icd10{i:03d}" for i in range(1, 16)])
            code_conditions = " OR ".join(
                f"{column} IN ({codelist_sql})" for column in code_columns
            )
        else:
            code_conditions = "1 = 1"
        if returning == "binary_flag":
            column_definition = "1"
        elif returning == "date_of_death":
            # Yes, we're converting an integer to a string to a timestamp to a date.
            column_definition = (
                "CAST(date_parse(CAST(o.reg_stat_dod AS VARCHAR), '%Y%m%d') AS date)"
            )
        elif returning == "underlying_cause_of_death":
            column_definition = "o.icd10u"
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")
        # ONS_TABLE is updated with each release of data from ONS, so we need to
        # filter for just the records which match the most recent upload_date
        return f"""
            SELECT
                p.registration_id,
                p.hashed_organisation as hashed_organisation,
                {column_definition} AS {returning}
            FROM {ONS_TABLE} o
            JOIN {self.patient_no_duplicates_table} p ON o.pseudonhsnumber = p.nhs_no
            {date_joins}
            WHERE ({code_conditions})
                AND {date_condition}
                AND o.upload_date = (SELECT MAX(upload_date) FROM {ONS_TABLE})
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
            CPNS_TABLE, "dateofdeath", between
        )
        if returning == "binary_flag":
            column_definition = "1"
        elif returning == "date_of_death":
            column_definition = "MAX(dateofdeath)"
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")
        return f"""
            SELECT
              {CPNS_TABLE}.registration_id,
              {CPNS_TABLE}.hashed_organisation,
              {column_definition} AS {returning},
              -- Crude error check so we blow up in the case of inconsistent dates
              1 / CASE WHEN MAX(dateofdeath) = MIN(dateofdeath) THEN 1 ELSE 0 END AS _e
            FROM {CPNS_TABLE}
            {date_joins}
            WHERE {date_condition}
            GROUP BY {CPNS_TABLE}.registration_id, {CPNS_TABLE}.hashed_organisation
            """

    def get_db_connection(self):
        if self._db_connection:
            return self._db_connection
        self._db_connection = LoggingDatabaseConnection(
            logger,
            trino_connection_from_url(self.database_url),
            truncate=self.truncate_sql_logs,
        )
        return self._db_connection

    def close(self):
        if self._db_connection:
            self._db_connection.close()
        self._db_connection = None


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


def codelist_to_sql(codelist):
    cast = int if codelist.system in ("snomed", "snomedct") else str
    if getattr(codelist, "has_categories", False):
        values = [quote(cast(code)) for (code, category) in codelist]
    else:
        values = [quote(cast(code)) for code in codelist]
    return ",".join(values)


def is_iso_date(value):
    return bool(re.match(r"\d\d\d\d-\d\d-\d\d", value))


def quote(value, reformat_dates=True):
    if isinstance(value, (int, float)):
        if math.isnan(value):
            return "NULL"
        else:
            return str(value)

    value = str(value)
    if reformat_dates:
        try:
            datetime.datetime.strptime(value, "%Y-%m-%d")
            return f"DATE('{value}')"
        except ValueError:
            pass

    if not SAFE_CHARS_RE.match(value) and value != "":
        raise ValueError(f"Value contains disallowed characters: {value}")
    return f"'{value}'"


def remove_lower_date_bound(between):
    if between is not None:
        return (None, between[1])


def truncate_date(column, date_format):
    if date_format == "YYYY" or date_format is None:
        date_format = "%Y"
    elif date_format == "YYYY-MM":
        date_format = "%Y-%m"
    elif date_format == "YYYY-MM-DD":
        date_format = "%Y-%m-%d"
    else:
        raise ValueError(f"Unhandled date format: {date_format}")
    return f"date_format({column}, '{date_format}')"


def pop_keys_from_dict(dictionary, keys):
    new_dict = {}
    for key in keys:
        if key in dictionary:
            new_dict[key] = dictionary.pop(key)
    return new_dict


def get_organisation_hash():
    return os.environ["EMIS_ORGANISATION_HASH"]


def truncate_patient_id(patient_id):
    """
    EMIS patient IDs are 128 byte strings which significantly bloat our output
    files. However, because they are actually hex-encoded SHA-512 hashes we can
    get away with throwing away all but the first 63 bits and storing them as
    int64s (63 bits so we can safely store them as signed int64s without
    worrying about negative patient IDs, which might upset expectations
    elsewhere). 63 bits still gives us plenty of entropy as sqrt(2^63) is about
    2 billion so well above the threshold where we'd need to worry about
    collisions with a population of a few tens of millions.
    """
    return int(patient_id[:16], 16) >> 1
