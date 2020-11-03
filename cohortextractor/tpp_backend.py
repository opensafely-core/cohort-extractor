import datetime
import enum
import hashlib
import os
import re
import uuid

from .expressions import format_expression
from .mssql_utils import (
    mssql_dbapi_connection_from_url,
    mssql_connection_params_from_url,
    mssql_table_to_csv,
)


# Characters that are safe to interpolate into SQL (see
# `placeholders_and_params` below)
safe_punctation = r" _.-+/()"
SAFE_CHARS_RE = re.compile(f"^[a-zA-Z0-9{re.escape(safe_punctation)}]+$")


class TPPBackend:
    _db_connection = None
    _current_column_name = None

    def __init__(self, database_url, covariate_definitions, temporary_database=None):
        self.database_url = database_url
        self.covariate_definitions = covariate_definitions
        self.temporary_database = temporary_database
        self.next_temp_table_id = 1
        self.queries = self.get_queries(self.covariate_definitions)

    def to_csv(self, filename):
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
        temp_filename = self._get_temp_filename(filename)
        unique_check = UniqueCheck()

        def record_patient_id_and_log(row):
            unique_check.add(row[0])
            if unique_check.count % 1000000 == 0:
                self.log(f"Downloaded {unique_check.count} results")

        # `batch_size` here was chosen through a bit of unscientific
        # trial-and-error and some guesswork. It may well need changing in
        # future.
        mssql_table_to_csv(
            temp_filename,
            cursor=self.get_db_connection().cursor(),
            table=output_table,
            key_column="patient_id",
            batch_size=32000,
            row_callback=record_patient_id_and_log,
            retries=2,
            sleep=0.5,
        )
        self.log(f"Downloaded {unique_check.count} results")

        self.execute_queries(
            [f"-- Deleting '{output_table}'\nDROP TABLE {output_table}"]
        )
        unique_check.assert_unique_ids()
        # If the extraction doesn't complete successfully we still want to keep
        # the output file for debugging purposes, just under a name which makes
        # it clear that it's not complete
        os.rename(temp_filename, filename)

    def _get_temp_filename(self, filename):
        root, extension = os.path.splitext(filename)
        timestamp = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
        return f"{root}.partial.{timestamp}{extension}"

    def to_dicts(self):
        result = self.execute_queries(self.queries)
        keys = [x[0] for x in result.description]
        # Convert all values to str as that's what will end in the CSV
        output = [dict(zip(keys, map(str, row))) for row in result]
        unique_check = UniqueCheck()
        for item in output:
            unique_check.add(item["patient_id"])
        unique_check.assert_unique_ids()
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
        self.log(f"Checking for existing results in '{output_table}'")
        if not self.table_exists(output_table):
            self.log(
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
            self.log(f"Writing results into temporary table '{output_table}'")
            previous_autocommit = conn.autocommit
            conn.autocommit = False
            cursor = conn.cursor()
            cursor.execute("BEGIN TRANSACTION")
            cursor.execute(f"SELECT * INTO {output_table} FROM ({final_query}) t")
            cursor.execute(f"CREATE INDEX ix_patient_id ON {output_table} (patient_id)")
            cursor.execute("COMMIT")
            conn.autocommit = previous_autocommit
            self.log(f"Downloading results from '{output_table}'")
        else:
            self.log(f"Downloading results from previous run in '{output_table}'")
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
            cursor.execute(f"SELECT 1 AS foo INTO {test_table}")
            cursor.execute(f"DROP TABLE {test_table}")
        # Because we don't want to depend on a specific database driver we
        # can't catch a specific exception class here
        except Exception as e:
            if "Database does not exist" in str(e):
                raise RuntimeError(f"Temporary database '{db_name}' does not exist")
            else:
                raise

    def get_db_connection(self):
        if self._db_connection:
            return self._db_connection
        self._db_connection = mssql_dbapi_connection_from_url(self.database_url)
        return self._db_connection

    def close(self):
        if self._db_connection:
            self._db_connection.close()
        self._db_connection = None

    def get_queries(self, covariate_definitions):
        output_columns = {}
        column_types = {}
        is_hidden = {}
        table_queries = {}
        for name, (query_type, query_args) in covariate_definitions.items():
            # So we can safely mutate these below
            query_args = query_args.copy()
            # These arguments are not used in generating column data and the
            # corresponding functions do not accept them
            query_args.pop("return_expectations", None)
            is_hidden[name] = query_args.pop("hidden", False)
            column_type = query_args.pop("column_type")
            # Record the types of columns we've seen so far so that
            # `categorised_as` expressions can use them if necessary
            column_types[name] = column_type
            # `categorised_as` columns don't generate their own table query,
            # they're just a CASE expression over columns generated by other
            # queries
            if query_type == "categorised_as":
                output_columns[name] = self.get_case_expression(
                    column_types, output_columns, **query_args
                )
            # `value_from` columns also don't generate a table, they just take
            # a value from another table
            elif query_type == "value_from":
                assert query_args["source"] in table_queries
                output_columns[name] = self.get_column_expression(
                    column_type, **query_args
                )
            # As do `aggregate_of` columns
            elif query_type == "aggregate_of":
                output_columns[name] = self.get_aggregate_expression(
                    column_type, output_columns, **query_args
                )
            else:
                date_format_args = pop_keys_from_dict(query_args, ["date_format"])
                sql_list = self.get_queries_for_column(name, query_type, query_args)
                # Wrap the final SELECT query so that it writes its results
                # into the appropriate temporary table
                sql_list[-1] = (
                    f"-- Query for {name}\n"
                    f"SELECT * INTO #{name} FROM ({sql_list[-1]}) t"
                )
                table_queries[name] = sql_list
                # The first column should always be patient_id so we can join on it
                output_columns[name] = self.get_column_expression(
                    column_type,
                    name,
                    returning=query_args.get("returning", "value"),
                    **date_format_args,
                )
        # If the population query defines its own temporary table then we use
        # that as the primary table to query against and left join everything
        # else against that. Otherwise, we use the `Patient` table.
        if "population" in table_queries:
            primary_table = "#population"
            patient_id_expr = "#population.patient_id"
        else:
            primary_table = "Patient"
            patient_id_expr = "Patient.Patient_ID"
        # Insert `patient_id` as the first column
        output_columns = dict(patient_id=patient_id_expr, **output_columns)
        output_columns_str = ",\n          ".join(
            f"{expr} AS {name}"
            for (name, expr) in output_columns.items()
            if not is_hidden.get(name) and name != "population"
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
        return all_queries

    def get_column_expression(self, column_type, source, returning, date_format=None):
        default_value = self.get_default_value_for_type(column_type)
        column_expr = f"#{source}.{returning}"
        if column_type == "date":
            column_expr = truncate_date(column_expr, date_format)
        return f"ISNULL({column_expr}, {quote(default_value)})"

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

    def execute_queries(self, queries):
        cursor = self.get_db_connection().cursor()
        for query in queries:
            comment_match = re.match(r"^\s*\-\-\s*(.+)\n", query)
            if comment_match:
                self.log(f"Running: {comment_match.group(1)}")
            cursor.execute(query)
        return cursor

    def log(self, message):
        timestamp = datetime.datetime.now(datetime.timezone.utc).strftime(
            "%Y-%m-%d %H:%M:%S UTC"
        )
        print(f"[{timestamp}] {message}", flush=True)

    def get_queries_for_column(self, column_name, query_type, query_args):
        method_name = f"patients_{query_type}"
        method = getattr(self, method_name)
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
        insert_sql = f"INSERT INTO {table_name} (code, category) VALUES"
        # There's a limit on how many rows we can insert in one go using this method
        # See: https://docs.microsoft.com/en-us/sql/t-sql/queries/table-value-constructor-transact-sql?view=sql-server-ver15#limitations-and-restrictions
        batch_size = 999
        for i in range(0, len(values), batch_size):
            values_batch = values[i : i + batch_size]
            values_sql_lines = [
                "({}, {})".format(*map(quote, row)) for row in values_batch
            ]
            values_sql = ",\n".join(values_sql_lines)
            queries.append(f"{insert_sql}\n{values_sql}")
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

    def patients_age_as_of(self, reference_date):
        quoted_date = quote(reference_date)
        return f"""
        SELECT
          Patient_ID AS patient_id,
          CASE WHEN
             dateadd(year, datediff (year, DateOfBirth, {quoted_date}), DateOfBirth) > {quoted_date}
          THEN
             datediff(year, DateOfBirth, {quoted_date}) - 1
          ELSE
             datediff(year, DateOfBirth, {quoted_date})
          END AS value
        FROM Patient
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
        date_condition = make_date_filter("ConsultationDate", between)

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
          SELECT Patient_ID, NumericValue AS BMI, ConsultationDate,
          ROW_NUMBER() OVER (
            PARTITION BY Patient_ID ORDER BY ConsultationDate DESC, CodedEvent_ID
          ) AS rownum
          FROM CodedEvent
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
            SELECT Patient_ID, NumericValue AS weight, ConsultationDate,
              ROW_NUMBER() OVER (
                PARTITION BY Patient_ID ORDER BY ConsultationDate DESC, CodedEvent_ID
              ) AS rownum
            FROM CodedEvent
            WHERE CTV3Code IN ({weight_codes_sql}) AND {date_condition}
          ) t
          WHERE t.rownum = 1
        """

        height_codes_sql = codelist_to_sql(height_codes)
        # The height date restriction is different from the others. We don't
        # mind using old values as long as the patient was old enough when they
        # were taken.
        height_date_condition = make_date_filter(
            "ConsultationDate",
            between,
            upper_bound_only=True,
        )
        heights_cte = f"""
          SELECT t.Patient_ID, t.height, t.ConsultationDate
          FROM (
            SELECT Patient_ID, NumericValue AS height, ConsultationDate,
            ROW_NUMBER() OVER (
              PARTITION BY Patient_ID ORDER BY ConsultationDate DESC, CodedEvent_ID
            ) AS rownum
            FROM CodedEvent
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

    def patients_mean_recorded_value(
        self,
        codelist,
        # What period is the mean over? (Only one supported option for now)
        on_most_recent_day_of_measurement=None,
        # Set date limits
        between=None,
        # Add additional columns indicating when measurement was taken
        include_date_of_match=False,
    ):
        # We only support this option for now
        assert on_most_recent_day_of_measurement
        date_condition = make_date_filter("ConsultationDate", between)
        codelist_sql = codelist_to_sql(codelist)
        # The subquery finds, for each patient, the most recent day on which
        # they've had a measurement. The outer query selects, for each patient,
        # the mean value on that day.
        # Note, there's a CAST in the JOIN condition but apparently SQL Server can still
        # use an index for this. See: https://stackoverflow.com/a/25564539
        return f"""
        SELECT
          days.Patient_ID AS patient_id,
          AVG(CodedEvent.NumericValue) AS value,
          days.date_measured AS date
        FROM (
            SELECT Patient_ID, CAST(MAX(ConsultationDate) AS date) AS date_measured
            FROM CodedEvent
            WHERE CTV3Code IN ({codelist_sql}) AND {date_condition}
            GROUP BY Patient_ID
        ) AS days
        LEFT JOIN CodedEvent
        ON (
          CodedEvent.Patient_ID = days.Patient_ID
          AND CodedEvent.CTV3Code IN ({codelist_sql})
          AND CAST(CodedEvent.ConsultationDate AS date) = days.date_measured
        )
        GROUP BY days.Patient_ID, days.date_measured
        """

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
        # Note that current registrations are recorded with an EndDate
        # of 9999-12-31
        extra_condition = ""
        if practice_used_systm_one_throughout_period:
            # We only need to (and only can) check the date the practice
            # *started* using SystmOne.  If they've stopped using it, then we
            # won't have their data in the TPP database at all.
            extra_condition = f"  AND Organisation.GoLiveDate <= {quote(start_date)}"
        return f"""
        SELECT DISTINCT Patient.Patient_ID AS patient_id, 1 AS value
        FROM Patient
        INNER JOIN RegistrationHistory
        ON RegistrationHistory.Patient_ID = Patient.Patient_ID
        INNER JOIN Organisation
        ON RegistrationHistory.Organisation_ID = Organisation.Organisation_ID
        WHERE StartDate <= {quote(start_date)} AND EndDate > {quote(end_date)}
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
        assert kwargs["codelist"].system == "ctv3"
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
                "CodedEvent", "", "CTV3Code", codes_are_case_sensitive=True, **kwargs
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
    ):
        codelist_table, codelist_queries = self.create_codelist_table(
            codelist, codes_are_case_sensitive
        )
        date_condition = make_date_filter("ConsultationDate", between)
        ignored_day_condition, extra_queries = self._these_codes_occur_on_same_day(
            from_table, ignore_days_where_these_codes_occur, date_condition
        )

        # Result ordering
        if find_first_match_in_period:
            ordering = "ASC"
            date_aggregate = "MIN"
        else:
            ordering = "DESC"
            date_aggregate = "MAX"

        column_name = returning
        if returning == "binary_flag" or returning == "date":
            column_name = "binary_flag"
            column_definition = "1"
            use_partition_query = False
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
            column_definition = "category"
            use_partition_query = True
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")

        if use_partition_query:
            sql = f"""
            SELECT
              Patient_ID AS patient_id,
              {column_definition} AS {column_name},
              ConsultationDate AS date
            FROM (
              SELECT Patient_ID, {column_definition}, ConsultationDate,
              ROW_NUMBER() OVER (
                PARTITION BY Patient_ID
                ORDER BY ConsultationDate {ordering}, {from_table}_ID
              ) AS rownum
              FROM {from_table}{additional_join}
              INNER JOIN {codelist_table}
              ON {code_column} = {codelist_table}.code
              WHERE {date_condition} AND NOT {ignored_day_condition}
            ) t
            WHERE rownum = 1
            """
        else:
            sql = f"""
            SELECT
              Patient_ID AS patient_id,
              {column_definition} AS {column_name},
              {date_aggregate}(ConsultationDate) AS date
            FROM {from_table}{additional_join}
            INNER JOIN {codelist_table}
            ON {code_column} = {codelist_table}.code
            WHERE {date_condition} AND NOT {ignored_day_condition}
            GROUP BY Patient_ID
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
        codelist_table, codelist_queries = self.create_codelist_table(
            codelist, case_sensitive=False
        )
        date_condition = make_date_filter("ConsultationDate", between)
        ignored_day_condition, extra_queries = self._these_codes_occur_on_same_day(
            "MedicationIssue", ignore_days_where_these_codes_occur, date_condition
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
          Patient_ID AS patient_id,
          SUM(is_new_episode) AS number_of_episodes
        FROM (
            SELECT
              Patient_ID,
              CASE
                WHEN
                  DATEDIFF(
                    day,
                    LAG(ConsultationDate) OVER (PARTITION BY Patient_ID ORDER BY ConsultationDate),
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
            WHERE {date_condition} AND NOT {ignored_day_condition}
        ) t
        GROUP BY Patient_ID
        """
        return codelist_queries + extra_queries + [sql]

    def _number_of_episodes_by_clinical_event(
        self,
        codelist,
        # Set date limits
        between=None,
        ignore_days_where_these_codes_occur=None,
        episode_defined_as=None,
    ):
        codelist_table, codelist_queries = self.create_codelist_table(
            codelist, case_sensitive=True
        )
        date_condition = make_date_filter("ConsultationDate", between)
        ignored_day_condition, extra_queries = self._these_codes_occur_on_same_day(
            "CodedEvent", ignore_days_where_these_codes_occur, date_condition
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
          Patient_ID AS patient_id,
          SUM(is_new_episode) AS number_of_episodes
        FROM (
            SELECT
              Patient_ID,
              CASE
                WHEN
                  DATEDIFF(
                    day,
                    LAG(ConsultationDate) OVER (PARTITION BY Patient_ID ORDER BY ConsultationDate),
                    ConsultationDate
                  ) <= {washout_period}
                THEN 0
                ELSE 1
              END AS is_new_episode
            FROM CodedEvent
            INNER JOIN {codelist_table}
            ON CTV3Code = {codelist_table}.code
            WHERE {date_condition} AND NOT {ignored_day_condition}
        ) t
        GROUP BY Patient_ID
        """
        return codelist_queries + extra_queries + [sql]

    def _these_codes_occur_on_same_day(self, joined_table, codelist, date_condition):
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
        assert codelist.system == "ctv3"
        codelist_table, queries = self.create_codelist_table(
            codelist, case_sensitive=True
        )
        same_day_table = self.get_temp_table_name("same_day_events")
        queries += [
            f"""
            SELECT Patient_ID, CAST(ConsultationDate AS date) AS day
            INTO {same_day_table}
            FROM CodedEvent
            INNER JOIN {codelist_table}
            ON CTV3Code = {codelist_table}.code
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
        if returning == "stp_code":
            column = "STPCode"
        elif returning == "msoa_code":
            column = "MSOACode"
        elif returning == "nuts1_region_name":
            column = "Region"
        elif returning == "pseudo_id":
            column = "Organisation_ID"
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")
        # Note that current registrations are recorded with an EndDate of
        # 9999-12-31. Where registration periods overlap we use the one with
        # the most recent start date. If there are several with the same start
        # date we use the longest one (i.e. with the latest end date).
        return f"""
        SELECT
          Patient_ID AS patient_id,
          Organisation.{column} AS {returning}
        FROM (
          SELECT Patient_ID, Organisation_ID,
          ROW_NUMBER() OVER (
            PARTITION BY Patient_ID
            ORDER BY StartDate DESC, EndDate DESC, Registration_ID
          ) AS rownum
          FROM RegistrationHistory
          WHERE StartDate <= {quote(date)} AND EndDate > {quote(date)}
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
        return f"""
        SELECT
          Patient_ID AS patient_id,
          CASE
            WHEN
              MAX(EndDate) BETWEEN {quote(min_date)} AND {quote(max_date)}
            THEN
              MAX(EndDate)
          END AS value
        FROM
          RegistrationHistory
        GROUP BY
          Patient_ID
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
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")
        # Note that current addresses are recorded with an EndDate of
        # 9999-12-31. Where address periods overlap we use the one with the
        # most recent start date. If there are several with the same start date
        # we use the longest one (i.e. with the latest end date). We then
        # prefer addresses which are not marked "NPC" for "No Postcode" and
        # finally we use the address ID as a tie-breaker.
        return f"""
        SELECT
          Patient_ID AS patient_id,
          {column} AS {returning}
        FROM (
          SELECT Patient_ID, {column},
          ROW_NUMBER() OVER (
            PARTITION BY Patient_ID
            ORDER BY
              StartDate DESC,
              EndDate DESC,
              IIF(MSOACode = 'NPC', 1, 0),
              PatientAddress_ID
          ) AS rownum
          FROM PatientAddress
          WHERE StartDate <= {quote(date)} AND EndDate > {quote(date)}
        ) t
        WHERE rownum = 1
        """

    def patients_care_home_status_as_of(self, date, categorised_as):
        # These are the columns to which the categorisation expression is
        # allowed to refer
        allowed_columns = {
            "IsPotentialCareHome": "ISNULL(PotentialCareHomeAddressID, 0)",
            "LocationRequiresNursing": "LocationRequiresNursing",
            "LocationDoesNotRequireNursing": "LocationDoesNotRequireNursing",
        }
        allowed_column_types = {
            "IsPotentialCareHome": "int",
            "LocationRequiresNursing": "str",
            "LocationDoesNotRequireNursing": "str",
        }
        case_expression = self.get_case_expression(
            allowed_column_types, allowed_columns, categorised_as
        )
        # See `patients_address_as_of` above for details of the ordering used
        # here
        return f"""
        SELECT
          Patient_ID AS patient_id,
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
          WHERE StartDate <= {quote(date)} AND EndDate > {quote(date)}
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
        if find_first_match_in_period:
            date_aggregate = "MIN"
        else:
            date_aggregate = "MAX"
        date_expression = f"""
        {date_aggregate}(
        CASE
        WHEN
          COALESCE(IcuAdmissionDateTime, '9999-01-01') < COALESCE(OriginalIcuAdmissionDate, '9999-01-01')
        THEN
          IcuAdmissionDateTime
        ELSE
          OriginalIcuAdmissionDate
        END)"""
        date_condition = make_date_filter(date_expression, between)

        greater_than_zero_expr = "CASE WHEN {} > 0 THEN 1 ELSE 0 END"

        if returning == "date_admitted":
            column_definition = date_expression
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
          Patient_ID AS patient_id,
          {column_definition} AS {returning}
        FROM
          ICNARC
        GROUP BY Patient_ID
        HAVING {date_condition}
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
        date_condition = make_date_filter("dod", between)
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
        if returning == "binary_flag":
            column_definition = "1"
        elif returning == "date_of_death":
            column_definition = "dod"
            # Quick fix: a patient appears twice in the ONS data with different
            # dates of death (offset by one day). This results in an error when
            # running the extract.  As we need to extract this cohort urgently
            # we're going to use the minimum date for now, pending a full
            # discussion of how best to handle this kind of inconsistency.
            return f"""
            SELECT Patient_ID as patient_id, MIN(dod) AS {returning}
            FROM ONS_Deaths
            WHERE ({code_conditions}) AND {date_condition}
            GROUP BY patient_id
            """
        elif returning == "underlying_cause_of_death":
            column_definition = "icd10u"
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")
        # The SELECT DISTINCT is because completely duplicate rows have previously appeared
        # in the underlying dataset.
        return f"""
        SELECT DISTINCT Patient_ID as patient_id, {column_definition} AS {returning}
        FROM ONS_Deaths
        WHERE ({code_conditions}) AND {date_condition}
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
        date_condition = make_date_filter("DateOfDeath", between)
        if returning == "binary_flag":
            column_definition = "1"
        elif returning == "date_of_death":
            column_definition = "MAX(DateOfDeath)"
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")
        return f"""
        SELECT
          Patient_ID as patient_id,
          {column_definition} AS {returning},
          -- Crude error check so we blow up in the case of inconsistent dates
          1 / CASE WHEN MAX(DateOfDeath) = MIN(DateOfDeath) THEN 1 ELSE 0 END AS _e
        FROM CPNS
        WHERE {date_condition}
        GROUP BY Patient_ID
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
        return f"""
        SELECT
          Patient_ID AS patient_id,
          {column} AS {returning}
        FROM
          Patient
        WHERE
          DateOfDeath BETWEEN {quote(min_date)} AND {quote(max_date)}
        """

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
        conditions = [make_date_filter("VaccinationDate", between)]
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
          Patient_ID AS patient_id,
          1 AS binary_flag,
          {date_aggregate}(VaccinationDate) AS date
        FROM Vaccination
        INNER JOIN VaccinationReference AS ref
        ON ref.VaccinationName_ID = Vaccination.VaccinationName_ID
        WHERE {conditions_str}
        GROUP BY Patient_ID
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

        date_condition = make_date_filter("SeenDate", between)
        # Result ordering
        date_aggregate = "MIN" if find_first_match_in_period else "MAX"
        return f"""
        SELECT
          Patient_ID AS patient_id,
          {column_definition} AS {column_name},
          {date_aggregate}(SeenDate) AS date
        FROM Appointment
        WHERE Status IN ({valid_states_str}) AND {date_condition}
        GROUP BY Patient_ID
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
        # Set return type
        returning="binary_flag",
        include_date_of_match=False,
    ):
        assert pathogen == "SARS-CoV-2"
        assert test_result in ("positive", "negative", "any")
        if returning not in ("binary_flag", "date"):
            raise ValueError(f"Unsupported `returning` value: {returning}")

        date_condition = make_date_filter("date", between)
        date_aggregate = "MIN" if find_first_match_in_period else "MAX"
        if test_result == "any":
            result_condition = "1 = 1"
        else:
            flag = 1 if test_result == "positive" else 0
            result_condition = f"test_result = {quote(flag)}"

        # These are the values we're expecting in our SGSS tables. If we ever
        # get anything other than these we should throw an error rather than
        # blindly continuing.
        positive_descr = "SARS-CoV-2 CORONAVIRUS (Covid-19)"
        negative_descr = "NEGATIVE SARS-CoV-2 (COVID-19)"

        return f"""
        SELECT
          patient_id,
          1 AS binary_flag,
          {date_aggregate}(date) AS date,
          -- We have to calculate something over the error check field
          -- otherwise it never gets computed
          MAX(_e) AS _e
        FROM (
          SELECT
            1 AS test_result,
            Patient_ID AS patient_id,
            Earliest_Specimen_Date AS date,
            -- Crude error check so we blow up in the case of unexpected data
            1 / CASE WHEN Organism_Species_Name = '{positive_descr}' THEN 1 ELSE 0 END AS _e
          FROM SGSS_Positive
          UNION ALL
          SELECT
            0 AS test_result,
            Patient_ID AS patient_id,
            Earliest_Specimen_Date AS date,
            -- Crude error check so we blow up in the case of unexpected data
            1 / CASE WHEN Organism_Species_Name = '{negative_descr}' THEN 1 ELSE 0 END AS _e
          FROM SGSS_Negative
        ) t
        WHERE {date_condition} AND {result_condition}
        GROUP BY patient_id
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

        conditions = [make_date_filter("Arrival_Date", between)]

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
              Patient_ID AS patient_id,
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
        elif returning == "date_admitted":
            column = f"{date_aggregate}(Admission_Date)"
            use_partition_query = False
        elif returning == "date_discharged":
            column = f"{date_aggregate}(Discharge_Date)"
            use_partition_query = False
        elif returning == "number_of_matches_in_period":
            column = "COUNT(*)"
            use_partition_query = False
        elif returning == "primary_diagnosis":
            column = "Spell_Primary_Diagnosis"
            use_partition_query = True
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")

        conditions = [make_date_filter("Admission_Date", between)]

        if with_these_primary_diagnoses:
            assert with_these_primary_diagnoses.system == "icd10"
            codes_sql = codelist_to_sql(with_these_primary_diagnoses)
            conditions.append(f"APCS_Der.Spell_Primary_Diagnosis IN ({codes_sql})")

        if with_these_diagnoses:
            assert with_these_diagnoses.system == "icd10"
            fragments = [
                f"Der_Diagnosis_All LIKE {pattern}"
                for pattern in codelist_to_like_patterns(
                    with_these_diagnoses, prefix="%[^A-Za-z0-9]", suffix="%"
                )
            ]
            conditions.append("(" + " OR ".join(fragments) + ")")

        if with_these_procedures:
            assert with_these_procedures.system == "icd10"
            fragments = [
                f"Der_Procedure_All LIKE {pattern}"
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
              Patient_ID AS patient_id,
              {column} AS {returning}
            FROM (
              SELECT APCS.Patient_ID, {column},
              ROW_NUMBER() OVER (
                PARTITION BY APCS.Patient_ID
                ORDER BY Admission_Date {ordering}, APCS.APCS_Ident
              ) AS rownum
              FROM APCS
              INNER JOIN APCS_Der
                ON APCS.APCS_Ident = APCS_Der.APCS_Ident
              WHERE {conditions}
            ) t
            WHERE rownum = 1
            """
        else:
            sql = f"""
            SELECT
              APCS.Patient_ID AS patient_id,
              {column} AS {returning}
            FROM APCS
            INNER JOIN APCS_Der
              ON APCS.APCS_Ident = APCS_Der.APCS_Ident
            WHERE {conditions}
            GROUP BY APCS.Patient_ID
            """
        return sql

    def get_case_expression(
        self, column_types, column_definitions, category_definitions
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
            name: self.get_default_value_for_type(column_type)
            for name, column_type in column_types.items()
        }
        clauses = []
        for category, expression in category_definitions.items():
            # The column references in the supplied expression need to be
            # rewritten to ensure they refer to the correct CTE. The formatting
            # function also ensures that the expression matches the very
            # limited subset of SQL we support here.
            formatted_expression = format_expression(
                expression, column_definitions, empty_value_map=empty_value_map
            )
            clauses.append(f"WHEN ({formatted_expression}) THEN {quote(category)}")
        return f"CASE {' '.join(clauses)} ELSE {quote(default_value)} END"

    def get_aggregate_expression(
        self, column_type, column_definitions, column_names, aggregate_function
    ):
        assert aggregate_function in ("MIN", "MAX")
        default_value = quote(self.get_default_value_for_type(column_type))
        # In other databases we could use GREATEST/LEAST to aggregate over
        # columns, but for MSSQL we need to use this Table Value Constructor
        # trick: https://stackoverflow.com/a/6871572
        components = ", ".join(f"({column_definitions[name]})" for name in column_names)
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
            f" WHERE value != {default_value}"
        )
        return f"ISNULL(({aggregate_expression}), {default_value})"


def codelist_to_sql_list(codelist):
    if getattr(codelist, "has_categories", False):
        return [quote(code) for (code, category) in codelist]
    else:
        return [quote(code) for code in codelist]


def codelist_to_like_patterns(codelist, prefix="", suffix=""):
    patterns = []
    for quoted_code in codelist_to_sql_list(codelist):
        assert quoted_code[0] == "'"
        assert quoted_code[-1] == "'"
        patterns.append(f"'{prefix}{quoted_code[1:-1]}{suffix}'")
    return patterns


def codelist_to_sql(codelist):
    return ",".join(codelist_to_sql_list(codelist))


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


def quote(value):
    if isinstance(value, (int, float)):
        return str(value)
    else:
        value = str(value)
        value = standardise_if_date(value)
        if not SAFE_CHARS_RE.match(value) and value != "":
            raise ValueError(f"Value contains disallowed characters: {value}")
        return f"'{value}'"


def make_date_filter(column, between, upper_bound_only=False):
    if between is None:
        between = (None, None)
    min_date, max_date = between
    if upper_bound_only:
        min_date = None
    if min_date is not None and max_date is not None:
        return f"{column} BETWEEN {quote(min_date)} AND {quote(max_date)}"
    elif min_date is not None:
        return f"{column} >= {quote(min_date)}"
    elif max_date is not None:
        return f"{column} <= {quote(max_date)}"
    else:
        return "1=1"


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


class UniqueCheck:
    def __init__(self):
        self.count = 0
        self.ids = set()

    def add(self, item):
        self.count += 1
        self.ids.add(item)

    def assert_unique_ids(self):
        duplicates = self.count - len(self.ids)
        if duplicates != 0:
            raise RuntimeError(f"Duplicate IDs found ({duplicates} rows)")


def pop_keys_from_dict(dictionary, keys):
    new_dict = {}
    for key in keys:
        if key in dictionary:
            new_dict[key] = dictionary.pop(key)
    return new_dict


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
