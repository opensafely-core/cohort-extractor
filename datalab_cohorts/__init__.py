import copy
import csv
import datetime
import os
import re
import subprocess
import tempfile
from urllib.parse import urlparse, unquote

import pyodbc

import pandas as pd

from .expressions import format_expression


# Characters that are safe to interpolate into SQL (see
# `placeholders_and_params` below)
SAFE_CHARS_RE = re.compile(r"^[a-zA-Z0-9_\.\-]+$")


class StudyDefinition:
    _db_connection = None
    _current_column_name = None

    def __init__(self, population, **covariates):
        covariates["population"] = population
        assert "patient_id" not in covariates, "patient_id is a reserved column name"
        self.codelist_tables = []
        self.queries = self.build_queries(covariates)
        self.pandas_csv_args = self.get_pandas_csv_args(covariates)

    def _to_csv_with_sqlcmd(self, filename):
        unique_check = UniqueCheck()
        sql = "SET NOCOUNT ON; "  # don't output count after table output
        sql += self.to_sql()
        sqlfile = tempfile.mktemp(suffix=".sql")
        with open(sqlfile, "w") as f:
            f.write(sql)
        temp_csv = tempfile.mktemp(suffix=".csv")
        db_dict = self.get_db_dict()
        cmd = [
            "sqlcmd",
            "-S",
            db_dict["hostname"] + "," + str(db_dict["port"]),
            "-d",
            db_dict["database"],
            "-U",
            db_dict["username"],
            "-P",
            db_dict["password"],
            "-i",
            sqlfile,
            "-W",  # strip whitespace
            "-s",
            ",",  # comma delimited
            "-r",
            "1",  # error messages to stderr
            # "-w",
            # "99",
            "-o",
            temp_csv,
        ]
        try:
            subprocess.run(cmd, capture_output=True, encoding="utf8", check=True)
        except subprocess.CalledProcessError as e:
            print(e.output)
            raise

        with open(filename, "w", newline="\r\n") as final_file:
            # We use windows line endings because that's what
            # the CSV module's default dialect does
            for line_num, line in enumerate(open(temp_csv, "r")):
                if line_num == 0 and line.startswith("Warning"):
                    continue
                if line_num <= 2 and line.startswith("-"):
                    continue
                final_file.write(line)
                patient_id = line.split(",")[0]
                unique_check.add(patient_id)
        unique_check.assert_unique_ids()

    def to_csv(self, filename, with_sqlcmd=False):
        if with_sqlcmd:
            self._to_csv_with_sqlcmd(filename)
        else:
            result = self.execute_query()
            unique_check = UniqueCheck()
            with open(filename, "w", newline="") as csvfile:
                writer = csv.writer(csvfile)
                writer.writerow([x[0] for x in result.description])
                for row in result:
                    unique_check.add(row[0])
                    writer.writerow(row)
            unique_check.assert_unique_ids()

    def csv_to_df(self, csv_name):
        return pd.read_csv(csv_name, **self.pandas_csv_args)

    def get_pandas_csv_args(self, covariate_definitions):
        def tobool(val):
            if val == "":
                return False
            if val == "0":
                return False
            return True

        def add_month_and_day_to_date(val):
            if val:
                return val + "-01-01"
            return val

        def add_day_to_date(val):
            if val:
                return val + "-01"
            return val

        dtypes = {}
        parse_dates = []
        converters = {}
        implicit_dates = []
        definitions = list(covariate_definitions.items())

        for name, (funcname, kwargs) in copy.deepcopy(definitions):
            if kwargs.get("include_date_of_match"):
                kwargs["returning"] = "date"
                implicit_dates.append((name + "_date", (funcname, kwargs)))
            elif kwargs.get("include_measurement_date"):
                kwargs["returning"] = "date"
                implicit_dates.append((name + "_date_measured", (funcname, kwargs)))

        for name, (funcname, kwargs) in implicit_dates + definitions:
            returning = kwargs.get("returning", None)
            if name == "population":
                continue
            if returning and (
                returning == "date"
                or returning.startswith("date_")
                or returning.endswith("_date")
                or "_date_" in returning
            ):
                parse_dates.append(name)
                # if granularity doesn't include a day, add one
                if not kwargs.get("include_day") and not kwargs.get("include_month"):
                    converters[name] = add_month_and_day_to_date
                elif kwargs.get("include_month"):
                    converters[name] = add_day_to_date

            elif returning == "numeric_value":
                dtypes[name] = "float"
            elif returning == "number_of_matches_in_period":
                dtypes[name] = "int"
            elif returning == "binary_flag":
                converters[name] = tobool
            elif returning == "category" or "category_definitions" in kwargs:
                dtypes[name] = "category"
            elif "include_measurement_date" in kwargs:
                # currently a special case for BMI
                dtypes[name] = "float"
                if name + "_date_measured" not in parse_dates:
                    if kwargs["include_measurement_date"]:
                        parse_dates.append(name + "_date_measured")
            elif returning:
                dtypes[name] = "category"
            elif funcname == "age_as_of":
                dtypes[name] = "int"
            elif funcname == "sex":
                dtypes[name] = "category"
            elif funcname == "have_died_of_covid":
                dtypes[name] = "category"
            else:
                raise ValueError(
                    f"Unable to impute Pandas type for {name} ({funcname})"
                )
        return {"dtype": dtypes, "converters": converters, "parse_dates": parse_dates}

    def to_dicts(self):
        result = self.execute_query()
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
        prepared_sql = ["-- Create codelist tables"]
        for create_sql, insert_sql, values in self.codelist_tables:
            prepared_sql.append(create_sql)
            prepared_sql.append("GO")
            for row in values:
                prepared_sql.append(
                    insert_sql.replace("?", "{}").format(*map(quote, row)) + ";"
                )
            prepared_sql.append("GO\n\n")
        for name, query in self.queries:
            prepared_sql.append(f"-- Query for {name}")
            prepared_sql.append(query)
            prepared_sql.append("\n\n")
        return "\n".join(prepared_sql)

    def build_queries(self, covariate_definitions):
        covariate_definitions, hidden_columns = self.flatten_nested_covariates(
            covariate_definitions
        )
        # Ensure that patient_id is the first output column by reserving its
        # place here even though we won't define it until later
        output_columns = {"patient_id": None}
        table_queries = {}
        for name, (query_type, query_args) in covariate_definitions.items():
            # `categorised_as` columns don't generate their own table query,
            # they're just a CASE expression over columns generated by other
            # queries
            if query_type == "categorised_as":
                output_columns[name] = self.get_case_expression(
                    output_columns, **query_args
                )
                continue
            cols, sql = self.get_query(name, query_type, query_args)
            table_queries[name] = f"SELECT * INTO #{name} FROM ({sql}) t"
            # The first column should always be patient_id so we can join on it
            assert len(cols) > 1
            assert cols[0] == "patient_id"
            for n, col in enumerate(cols[1:]):
                # The first result column is given the name of the desired
                # output column. The rest are added as suffixes to the name of
                # the output column
                output_col = name if n == 0 else f"{name}_{col}"
                default_value = quote(self.default_for_column(col))
                output_columns[output_col] = f"ISNULL(#{name}.{col}, {default_value})"
        # If the population query defines its own temporary table then we use
        # that as the primary table to query against and left join everything
        # else against that. Otherwise, we use the `Patient` table.
        if "population" in table_queries:
            primary_table = "#population"
            output_columns["patient_id"] = "#population.patient_id"
        else:
            primary_table = "Patient"
            output_columns["patient_id"] = "Patient.Patient_ID"
        output_columns_str = ",\n          ".join(
            f"{expr} AS {name}"
            for (name, expr) in output_columns.items()
            if name not in hidden_columns and name != "population"
        )
        joins = [
            f"LEFT JOIN #{name} ON #{name}.patient_id = {output_columns['patient_id']}"
            for name in table_queries
            if name != "population"
        ]
        joins_str = "\n          ".join(joins)
        joined_output_query = f"""
        SELECT
          {output_columns_str}
        FROM
          {primary_table}
          {joins_str}
        WHERE {output_columns["population"]} = 1
        """
        return list(table_queries.items()) + [("final_output", joined_output_query)]

    def flatten_nested_covariates(self, covariate_definitions):
        """
        Some covariates (e.g `categorised_as`) can define their own internal
        covariates which are used for calculating the column value but don't
        appear in the final output. Here we pull all these internal covariates
        out (which may be recursively nested) and assemble a flat list of
        covariates along with a set of ones which should be hidden from the
        final output.

        We also check for any name clashes among covariates. (In future we
        could rewrite the names of internal covariates to avoid this but for
        now we just throw an error.)
        """
        flattened = {}
        hidden = set()
        items = list(covariate_definitions.items())
        while items:
            name, (query_type, query_args) = items.pop(0)
            if query_type == "categorised_as" and "extra_columns" in query_args:
                # Pull out the extra columns
                extra_columns = query_args.pop("extra_columns")
                # Stick the query back on the stack
                items.insert(0, (name, (query_type, query_args)))
                # Mark the extra columns as hidden
                hidden.update(extra_columns.keys())
                # Add them to the start of the list of items to be processed
                items[:0] = extra_columns.items()
            else:
                if name in flattened:
                    raise ValueError(f"Duplicate columns named '{name}'")
                flattened[name] = (query_type, query_args)
        return flattened, hidden

    def default_for_column(self, column_name):
        is_str_col = (
            column_name == "date"
            or column_name.startswith("date_")
            or column_name.endswith("_date")
            or column_name.endswith("_code")
            or column_name == "category"
            or column_name.endswith("_name")
        )
        return "" if is_str_col else 0

    def execute_query(self):
        cursor = self.get_db_connection().cursor()
        self.log("Uploading codelists into temporary tables")
        for create_sql, insert_sql, values in self.codelist_tables:
            cursor.execute(create_sql)
            cursor.executemany(insert_sql, values)
        queries = list(self.queries)
        final_query = queries.pop()[1]
        for name, sql in queries:
            self.log(f"Running query: {name}")
            cursor.execute(sql)
        output_table = self.get_output_table_name(os.environ.get("TEMP_DATABASE_NAME"))
        if output_table:
            self.log(f"Running final query and writing output to '{output_table}'")
            sql = f"SELECT * INTO {output_table} FROM ({final_query}) t"
            cursor.execute(sql)
            self.log(f"Downloading data from '{output_table}'")
            cursor.execute(f"SELECT * FROM {output_table}")
        else:
            self.log(
                f"No TEMP_DATABASE_NAME defined in environment, downloading results "
                "directly without writing to output table"
            )
            cursor.execute(final_query)
        return cursor

    def get_output_table_name(self, temporary_database):
        if not temporary_database:
            return
        timestamp = datetime.datetime.now(datetime.timezone.utc).strftime(
            "%Y%m%d_%H%M%S"
        )
        return f"{temporary_database}..Output_{timestamp}"

    def log(self, message):
        timestamp = datetime.datetime.now(datetime.timezone.utc).strftime(
            "%Y-%m-%d %H:%M:%S UTC"
        )
        print(f"[{timestamp}] {message}")

    def get_query(self, column_name, query_type, query_args):
        method_name = f"patients_{query_type}"
        method = getattr(self, method_name)
        # Keep track of the current column name for debugging purposes
        self._current_column_name = column_name
        return_value = method(**query_args)
        self._current_column_name = None
        return return_value

    def create_codelist_table(self, codelist, case_sensitive=True):
        table_number = len(self.codelist_tables) + 1
        # We include the current column name for ease of debugging
        column_name = self._current_column_name or "unknown"
        # The hash prefix indicates a temporary table
        table_name = f"#codelist_{table_number}_{column_name}"
        if codelist.has_categories:
            values = list(codelist)
        else:
            values = [(code, "") for code in codelist]
        collation = "Latin1_General_BIN" if case_sensitive else "Latin1_General_CI_AS"
        max_code_len = max(len(code) for (code, category) in values)
        self.codelist_tables.append(
            (
                f"""
                CREATE TABLE {table_name} (
                  -- Because some code systems are case-sensitive we need to
                  -- use a case-sensitive collation here
                  code VARCHAR({max_code_len}) COLLATE {collation},
                  category VARCHAR(MAX)
                )
                """,
                f"INSERT INTO {table_name} (code, category) VALUES(?, ?)",
                values,
            )
        )
        return table_name

    def patients_age_as_of(self, reference_date):
        quoted_date = quote(reference_date)
        return (
            ["patient_id", "age"],
            f"""
            SELECT
              Patient_ID AS patient_id,
              CASE WHEN
                 dateadd(year, datediff (year, DateOfBirth, {quoted_date}), DateOfBirth) > {quoted_date}
              THEN
                 datediff(year, DateOfBirth, {quoted_date}) - 1
              ELSE
                 datediff(year, DateOfBirth, {quoted_date})
              END AS age
            FROM Patient
            """,
        )

    def patients_sex(self):
        return (
            ["patient_id", "sex"],
            """
          SELECT
            Patient_ID AS patient_id,
            Sex as sex
          FROM Patient""",
        )

    def patients_all(self):
        """
        All patients
        """
        return (
            ["patient_id", "is_included"],
            """
            SELECT Patient_ID AS patient_id, 1 AS is_included
            FROM Patient
            """,
        )

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
        return (
            ["patient_id", "is_included"],
            f"""
            SELECT Patient_ID, 1 AS is_included
            FROM Patient
            WHERE (ABS(CAST(
            (BINARY_CHECKSUM(*) *
            RAND()) as int)) % 100) < {quote(percent)}
            """,
        )

    def patients_most_recent_bmi(
        self,
        # Set date limits
        on_or_before=None,
        on_or_after=None,
        between=None,
        minimum_age_at_measurement=16,
        # Add an additional column indicating when measurement was taken
        include_measurement_date=False,
        # If we're returning a date, how granular should it be?
        include_month=False,
        include_day=False,
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
        date_condition = make_date_filter(
            "ConsultationDate", on_or_after, on_or_before, between
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
          SELECT Patient_ID, NumericValue AS BMI, ConsultationDate,
          ROW_NUMBER() OVER (PARTITION BY Patient_ID ORDER BY ConsultationDate DESC) AS rownum
          FROM CodedEvent
          WHERE CTV3Code = {quote(bmi_code)} AND {date_condition}
        ) t
        WHERE t.rownum = 1
        """

        patients_cte = f"""
           SELECT Patient_ID, DateOfBirth
           FROM Patient
        """
        weight_codes_sql = codelist_to_sql(weight_codes)
        weights_cte = f"""
          SELECT t.Patient_ID, t.weight, t.ConsultationDate
          FROM (
            SELECT Patient_ID, NumericValue AS weight, ConsultationDate,
            ROW_NUMBER() OVER (PARTITION BY Patient_ID ORDER BY ConsultationDate DESC) AS rownum
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
            on_or_after,
            on_or_before,
            between,
            upper_bound_only=True,
        )
        heights_cte = f"""
          SELECT t.Patient_ID, t.height, t.ConsultationDate
          FROM (
            SELECT Patient_ID, NumericValue AS height, ConsultationDate,
            ROW_NUMBER() OVER (PARTITION BY Patient_ID ORDER BY ConsultationDate DESC) AS rownum
            FROM CodedEvent
            WHERE CTV3Code IN ({height_codes_sql}) AND {height_date_condition}
          ) t
          WHERE t.rownum = 1
        """

        date_column_defintion = truncate_date(
            """
            CASE
              WHEN weight IS NULL OR height IS NULL THEN bmis.ConsultationDate
              ELSE weights.ConsultationDate
            END
            """,
            include_month,
            include_day,
        )
        min_age = int(minimum_age_at_measurement)

        sql = f"""
        SELECT
          patients.Patient_ID AS patient_id,
          ROUND(COALESCE(weight/SQUARE(NULLIF(height, 0)), bmis.BMI), 1) AS BMI,
          {date_column_defintion} AS date_measured
        FROM ({patients_cte}) AS patients
        LEFT JOIN ({weights_cte}) AS weights
        ON weights.Patient_ID = patients.Patient_ID AND DATEDIFF(YEAR, patients.DateOfBirth, weights.ConsultationDate) >= {min_age}
        LEFT JOIN ({heights_cte}) AS heights
        ON heights.Patient_ID = patients.Patient_ID AND DATEDIFF(YEAR, patients.DateOfBirth, heights.ConsultationDate) >= {min_age}
        LEFT JOIN ({bmi_cte}) AS bmis
        ON bmis.Patient_ID = patients.Patient_ID AND DATEDIFF(YEAR, patients.DateOfBirth, bmis.ConsultationDate) >= {min_age}
        -- XXX maybe add a "WHERE NULL..." here
        """
        columns = ["patient_id", "BMI"]
        if include_measurement_date:
            columns.append("date_measured")
        return columns, sql

    def patients_mean_recorded_value(
        self,
        codelist,
        # What period is the mean over? (Only one supported option for now)
        on_most_recent_day_of_measurement=None,
        # Set date limits
        on_or_before=None,
        on_or_after=None,
        between=None,
        # Add additional columns indicating when measurement was taken
        include_measurement_date=False,
        # If we're returning a date, how granular should it be?
        include_month=False,
        include_day=False,
    ):
        # We only support this option for now
        assert on_most_recent_day_of_measurement
        date_condition = make_date_filter(
            "ConsultationDate", on_or_after, on_or_before, between
        )
        codelist_sql = codelist_to_sql(codelist)
        date_definition = truncate_date(
            "days.date_measured", include_month, include_day
        )
        # The subquery finds, for each patient, the most recent day on which
        # they've had a measurement. The outer query selects, for each patient,
        # the mean value on that day.
        # Note, there's a CAST in the JOIN condition but apparently SQL Server can still
        # use an index for this. See: https://stackoverflow.com/a/25564539
        sql = f"""
        SELECT
          days.Patient_ID AS patient_id,
          AVG(CodedEvent.NumericValue) AS mean_value,
          {date_definition} AS date_measured
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
        columns = ["patient_id", "mean_value"]
        if include_measurement_date:
            columns.append("date_measured")
        return columns, sql

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
        # Note that current registrations are recorded with an EndDate
        # of 9999-12-31
        return (
            ["patient_id", "registered"],
            f"""
            SELECT DISTINCT Patient.Patient_ID AS patient_id, 1 AS registered
            FROM Patient
            INNER JOIN RegistrationHistory
            ON RegistrationHistory.Patient_ID = Patient.Patient_ID
            WHERE StartDate <= {quote(start_date)} AND EndDate > {quote(end_date)}
            """,
        )

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
        if kwargs["returning"] == "numeric_value":
            raise ValueError(f"Unsupported `returning` value: numeric_value")
        return self._patients_with_events(
            """
            MedicationIssue
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
        return self._patients_with_events(
            "CodedEvent", "CTV3Code", codes_are_case_sensitive=True, **kwargs
        )

    def _patients_with_events(
        self,
        from_table,
        code_column,
        codes_are_case_sensitive,
        codelist,
        # Set date limits
        on_or_before=None,
        on_or_after=None,
        between=None,
        # Matching rule
        find_first_match_in_period=None,
        find_last_match_in_period=None,
        # Set return type
        returning="binary_flag",
        include_date_of_match=False,
        # If we're returning a date, how granular should it be?
        include_month=False,
        include_day=False,
    ):
        codelist_table = self.create_codelist_table(codelist, codes_are_case_sensitive)
        date_condition = make_date_filter(
            "ConsultationDate", on_or_after, on_or_before, between
        )

        # Result ordering
        if find_first_match_in_period:
            ordering = "ASC"
            date_aggregate = "MIN"
            date_column_name = "first_date"
        else:
            ordering = "DESC"
            date_aggregate = "MAX"
            date_column_name = "last_date"

        if returning == "binary_flag" or returning == "date":
            column_name = "has_event"
            column_definition = "1"
            use_partition_query = False
        elif returning == "number_of_matches_in_period":
            column_name = "count"
            column_definition = "COUNT(*)"
            use_partition_query = False
        elif returning == "numeric_value":
            column_name = "value"
            column_definition = "NumericValue"
            use_partition_query = True
        elif returning == "code":
            column_name = "value"
            column_definition = code_column
            use_partition_query = True
        elif returning == "category":
            if not codelist.has_categories:
                raise ValueError(
                    "Cannot return categories because the supplied codelist does "
                    "not have any categories defined"
                )
            column_name = "category"
            column_definition = "category"
            use_partition_query = True
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")

        if use_partition_query:
            # Partition queries are used to pull out values for specific
            # events, the corresponding date column therefore should not be
            # "first_date" or "last_date" but just "date"
            date_column_name = "date"
            date_column_definition = truncate_date(
                "ConsultationDate", include_month, include_day
            )
            sql = f"""
            SELECT
              Patient_ID AS patient_id,
              {column_definition} AS {column_name},
              {date_column_definition} AS {date_column_name}
            FROM (
              SELECT Patient_ID, {column_definition}, ConsultationDate,
              ROW_NUMBER() OVER (
                PARTITION BY Patient_ID ORDER BY ConsultationDate {ordering}
              ) AS rownum
              FROM {from_table}
              INNER JOIN {codelist_table}
              ON {code_column} = {codelist_table}.code
              WHERE {date_condition}
            ) t
            WHERE rownum = 1
            """
        else:
            date_column_definition = truncate_date(
                f"{date_aggregate}(ConsultationDate)", include_month, include_day
            )
            sql = f"""
            SELECT
              Patient_ID AS patient_id,
              {column_definition} AS {column_name},
              {date_column_definition} AS {date_column_name}
            FROM {from_table}
            INNER JOIN {codelist_table}
            ON {code_column} = {codelist_table}.code
            WHERE {date_condition}
            GROUP BY Patient_ID
            """

        if returning == "date":
            columns = ["patient_id", date_column_name]
        else:
            columns = ["patient_id", column_name]
            if include_date_of_match:
                columns.append(date_column_name)
        return columns, sql

    def patients_registered_practice_as_of(self, date, returning=None):
        if returning == "stp_code":
            column = "STPCode"
        elif returning == "msoa_code":
            column = "MSOACode"
        elif returning == "nhse_region_name":
            column = "Region"
        elif returning == "pseudo_id":
            column = "Organisation_ID"
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")
        # Note that current registrations are recorded with an EndDate of
        # 9999-12-31. Where registration periods overlap we use the one with
        # the most recent start date. If there are several with the same start
        # date we use the longest one (i.e. with the latest end date).
        return (
            ["patient_id", returning],
            f"""
            SELECT
              Patient_ID AS patient_id,
              Organisation.{column} AS {returning}
            FROM (
              SELECT Patient_ID, Organisation_ID,
              ROW_NUMBER() OVER (
                PARTITION BY Patient_ID ORDER BY StartDate DESC, EndDate DESC
              ) AS rownum
              FROM RegistrationHistory
              WHERE StartDate <= {quote(date)} AND EndDate > {quote(date)}
            ) t
            LEFT JOIN Organisation
            ON Organisation.Organisation_ID = t.Organisation_ID
            WHERE t.rownum = 1
            """,
        )

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
            column = "RuralUrbanClassificationCode"
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")
        # Note that current addresses are recorded with an EndDate of
        # 9999-12-31. Where address periods overlap we use the one with the
        # most recent start date. If there are several with the same start date
        # we use the longest one (i.e. with the latest end date).
        return (
            ["patient_id", returning],
            f"""
            SELECT
              Patient_ID AS patient_id,
              {column} AS {returning}
            FROM (
              SELECT Patient_ID, {column},
              ROW_NUMBER() OVER (
                PARTITION BY Patient_ID ORDER BY StartDate DESC, EndDate DESC
              ) AS rownum
              FROM PatientAddress
              WHERE StartDate <= {quote(date)} AND EndDate > {quote(date)}
            ) t
            WHERE rownum = 1
            """,
        )

    # https://github.com/ebmdatalab/tpp-sql-notebook/issues/72
    def patients_admitted_to_icu(
        self,
        on_or_after=None,
        on_or_before=None,
        between=None,
        find_first_match_in_period=None,
        find_last_match_in_period=None,
        returning="binary_flag",
        include_month=True,
        include_day=False,
    ):
        assert returning in [
            "binary_flag",
            "date_admitted",
        ], "`returning` must be one of `binary_flag` or `date_admitted`"
        if find_first_match_in_period:
            date_aggregate = "MIN"
            date_column_name = "first_admitted_date"
        else:
            date_aggregate = "MAX"
            date_column_name = "last_admitted_date"
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
        date_condition = make_date_filter(
            date_expression, on_or_after, on_or_before, between
        )
        columns = ["patient_id"]
        if returning == "date_admitted":
            column_definition = truncate_date(
                date_expression, include_month, include_day
            )
            columns.append(date_column_name)
        elif returning == "binary_flag":
            column_definition = 1
            columns.append(date_column_name)
        return (
            columns,
            f"""
            SELECT
              Patient_ID AS patient_id,
              {column_definition} AS {date_column_name},
              MAX(Ventilator) AS ventilated -- apparently can be 0, 1 or NULL
            FROM
              ICNARC
            GROUP BY Patient_ID
            HAVING
              {date_condition} AND SUM(BasicDays_RespiratorySupport) + SUM(AdvancedDays_RespiratorySupport) >= 1
            """,
        )

    def patients_with_positive_covid_test(self):
        return (
            ["patient_id", "has_covid"],
            """
            SELECT DISTINCT Patient_ID as patient_id, 1 AS has_covid
            FROM CovidStatus
            WHERE Result = 'COVID19'
            """,
        )

    def patients_have_died_of_covid(self):
        return (
            ["patient_id", "died"],
            """
            SELECT DISTINCT Patient_ID as patient_id, 1 AS died
            FROM CovidStatus
            WHERE Died = 'true'
            """,
        )

    def patients_with_these_codes_on_death_certificate(
        self,
        codelist=None,
        # Set date limits
        on_or_before=None,
        on_or_after=None,
        between=None,
        # Matching rules
        match_only_underlying_cause=False,
        # Set return type
        returning="binary_flag",
        # If we're returning a date, how granular should it be?
        include_month=False,
        include_day=False,
    ):
        date_condition = make_date_filter("dod", on_or_after, on_or_before, between)
        if codelist is not None:
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
            column_name = "died"
        elif returning == "date_of_death":
            column_definition = truncate_date("dod", include_month, include_day)
            column_name = "date_of_death"
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")
        return (
            ["patient_id", column_name],
            f"""
            SELECT Patient_ID as patient_id, {column_definition} AS {column_name}
            FROM ONS_Deaths
            WHERE ({code_conditions}) AND {date_condition}
            """,
        )

    def patients_died_from_any_cause(
        self,
        # Set date limits
        on_or_before=None,
        on_or_after=None,
        between=None,
        # Set return type
        returning="binary_flag",
        # If we're returning a date, how granular should it be?
        include_month=False,
        include_day=False,
    ):
        return self.patients_with_these_codes_on_death_certificate(
            codelist=None,
            on_or_before=on_or_before,
            on_or_after=on_or_after,
            between=between,
            returning=returning,
            include_month=include_month,
            include_day=include_day,
        )

    def patients_with_death_recorded_in_cpns(
        self,
        # Set date limits
        on_or_before=None,
        on_or_after=None,
        between=None,
        # Set return type
        returning="binary_flag",
        # If we're returning a date, how granular should it be?
        include_month=False,
        include_day=False,
    ):
        date_condition = make_date_filter(
            "DateOfDeath", on_or_after, on_or_before, between
        )
        if returning == "binary_flag":
            column_definition = "1"
            column_name = "died"
        elif returning == "date_of_death":
            column_definition = truncate_date(
                "MAX(DateOfDeath)", include_month, include_day
            )
            column_name = "date_of_death"
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")
        return (
            ["patient_id", column_name],
            f"""
            SELECT
              Patient_ID as patient_id,
              {column_definition} AS {column_name},
              -- Crude error check so we blow up in the case of inconsistent dates
              1 / CASE WHEN MAX(DateOfDeath) = MIN(DateOfDeath) THEN 1 ELSE 0 END AS _e
            FROM CPNS
            WHERE {date_condition}
            GROUP BY Patient_ID
            """,
        )

    def get_case_expression(self, column_definitions, category_definitions):
        defaults = [k for (k, v) in category_definitions.items() if v == "DEFAULT"]
        if len(defaults) > 1:
            raise ValueError("At most one default category can be defined")
        if len(defaults) == 1:
            default_value = defaults[0]
            category_definitions.pop(default_value)
        else:
            default_value = ""
        clauses = []
        for category, expression in category_definitions.items():
            # The column references in the supplied expression need to be
            # rewritten to ensure they refer to the correct CTE. The formatting
            # function also ensures that the expression matches the very
            # limited subset of SQL we support here.
            formatted_expression = format_expression(expression, column_definitions)
            clauses.append(f"WHEN ({formatted_expression}) THEN {quote(category)}")
        return f"CASE {' '.join(clauses)} ELSE {quote(default_value)} END"

    def get_db_dict(self):
        parsed = urlparse(os.environ["DATABASE_URL"])
        return {
            "hostname": parsed.hostname,
            "port": parsed.port or 1433,
            "database": parsed.path.lstrip("/"),
            "username": unquote(parsed.username),
            "password": unquote(parsed.password),
        }

    def get_db_connection(self):
        if self._db_connection:
            return self._db_connection
        db_dict = self.get_db_dict()
        connection_str = (
            "DRIVER={{ODBC Driver 17 for SQL Server}};"
            "SERVER={hostname},{port};"
            "DATABASE={database};"
            "UID={username};"
            "PWD={password}"
        ).format(**db_dict)
        self._db_connection = pyodbc.connect(connection_str)
        return self._db_connection


class patients:
    """
    This will be a module eventually but a class with a bunch of static methods
    is an easy way of making a namespace for now.

    These methods don't *do* anything apart from some basic error checking;
    they just return their name and arguments. This provides a friendlier API
    then having to build some big nested data structure by hand and means we
    can make use of autocomplete, docstrings etc to make it a bit more
    discoverable.
    """

    @staticmethod
    def age_as_of(reference_date):
        if reference_date == "today":
            reference_date = datetime.date.today()
        else:
            reference_date = datetime.date.fromisoformat(str(reference_date))
        return "age_as_of", locals()

    @staticmethod
    def registered_as_of(reference_date):
        if reference_date == "today":
            reference_date = datetime.date.today()
        else:
            reference_date = datetime.date.fromisoformat(str(reference_date))
        return "registered_as_of", locals()

    @staticmethod
    def registered_with_one_practice_between(start_date, end_date):
        start_date = datetime.date.fromisoformat(str(start_date))
        end_date = datetime.date.fromisoformat(str(end_date))
        return "registered_with_one_practice_between", locals()

    @staticmethod
    def with_complete_history_between(start_date, end_date):
        start_date = datetime.date.fromisoformat(str(start_date))
        end_date = datetime.date.fromisoformat(str(end_date))
        return "with_complete_history_between", locals()

    @staticmethod
    def most_recent_bmi(
        # Set date limits
        on_or_before=None,
        on_or_after=None,
        between=None,
        minimum_age_at_measurement=16,
        # Add an additional column indicating when measurement was taken
        include_measurement_date=False,
        # If we're returning a date, how granular should it be?
        include_month=False,
        include_day=False,
    ):
        validate_time_period_options(**locals())
        return "most_recent_bmi", locals()

    @staticmethod
    def mean_recorded_value(
        codelist,
        on_most_recent_day_of_measurement=None,
        # Set date limits
        on_or_before=None,
        on_or_after=None,
        between=None,
        # Add additional columns indicating when measurement was taken
        include_measurement_date=False,
        # If we're returning a date, how granular should it be?
        include_month=False,
        include_day=False,
    ):
        assert codelist.system == "ctv3"
        validate_time_period_options(**locals())
        return "mean_recorded_value", locals()

    @staticmethod
    def all():
        return "all", locals()

    @staticmethod
    def sex():
        return "sex", locals()

    @staticmethod
    def with_these_medications(
        codelist,
        # Set date limits
        on_or_before=None,
        on_or_after=None,
        between=None,
        # Matching rule
        find_first_match_in_period=None,
        find_last_match_in_period=None,
        # Set return type
        returning="binary_flag",
        include_date_of_match=False,
        # If we're returning a date, how granular should it be?
        include_month=False,
        include_day=False,
        # Deprecated return type options kept for now for backwards
        # compatibility
        return_binary_flag=None,
        return_number_of_matches_in_period=False,
        return_first_date_in_period=False,
        return_last_date_in_period=False,
    ):
        assert codelist.system == "snomed"
        validate_time_period_options(**locals())
        # Handle deprecated API
        if return_binary_flag:
            returning = "binary_flag"
        elif return_number_of_matches_in_period:
            returning = "number_of_matches_in_period"
        elif return_first_date_in_period:
            find_first_match_in_period = True
            returning = "date"
        elif return_last_date_in_period:
            find_last_match_in_period = True
            returning = "date"
        # Remove from namespace so we don't capture them below
        del (
            return_binary_flag,
            return_number_of_matches_in_period,
            return_first_date_in_period,
            return_last_date_in_period,
        )
        return "with_these_medications", locals()

    @staticmethod
    def with_these_clinical_events(
        codelist,
        # Set date limits
        on_or_before=None,
        on_or_after=None,
        between=None,
        # Matching rule
        find_first_match_in_period=None,
        find_last_match_in_period=None,
        # Set return type
        returning="binary_flag",
        include_date_of_match=False,
        # If we're returning a date, how granular should it be?
        include_month=False,
        include_day=False,
        # Deprecated return type options kept for now for backwards
        # compatibility
        return_binary_flag=None,
        return_number_of_matches_in_period=False,
        return_first_date_in_period=False,
        return_last_date_in_period=False,
    ):
        assert codelist.system == "ctv3"
        validate_time_period_options(**locals())
        # Handle deprecated API
        if return_binary_flag:
            returning = "binary_flag"
        elif return_number_of_matches_in_period:
            returning = "number_of_matches_in_period"
        elif return_first_date_in_period:
            find_first_match_in_period = True
            returning = "date"
        elif return_last_date_in_period:
            find_last_match_in_period = True
            returning = "date"
        # Remove from namespace so we don't capture them below
        del (
            return_binary_flag,
            return_number_of_matches_in_period,
            return_first_date_in_period,
            return_last_date_in_period,
        )
        return "with_these_clinical_events", locals()

    @staticmethod
    def categorised_as(category_definitions, **extra_columns):
        return "categorised_as", locals()

    @staticmethod
    def satisfying(expression, **extra_columns):
        category_definitions = {1: expression, 0: "DEFAULT"}
        # Remove from local namespace
        del expression
        return "categorised_as", locals()

    @staticmethod
    def registered_practice_as_of(date, returning=None):
        return "registered_practice_as_of", locals()

    @staticmethod
    def address_as_of(date, returning=None, round_to_nearest=None):
        return "address_as_of", locals()

    @staticmethod
    def admitted_to_icu(
        on_or_after=None,
        on_or_before=None,
        between=None,
        find_first_match_in_period=None,
        find_last_match_in_period=None,
        returning="binary_flag",
        include_month=True,
        include_day=False,
    ):
        return "admitted_to_icu", locals()

    # The below are placeholder methods we don't expect to make it into the final API.
    # They use a handler which returns dummy CHESS data.

    @staticmethod
    def with_positive_covid_test():
        return "with_positive_covid_test", locals()

    @staticmethod
    def have_died_of_covid():
        return "have_died_of_covid", locals()

    @staticmethod
    def random_sample(percent=None):
        assert percent, "Must specify a percentage greater than zero"
        return "random_sample", locals()

    @staticmethod
    def with_these_codes_on_death_certificate(
        codelist,
        # Set date limits
        on_or_before=None,
        on_or_after=None,
        between=None,
        # Matching rules
        match_only_underlying_cause=False,
        # Set return type
        returning="binary_flag",
        # If we're returning a date, how granular should it be?
        include_month=False,
        include_day=False,
    ):
        assert codelist.system == "icd10"
        validate_time_period_options(**locals())
        return "with_these_codes_on_death_certificate", locals()

    @staticmethod
    def died_from_any_cause(
        # Set date limits
        on_or_before=None,
        on_or_after=None,
        between=None,
        # Set return type
        returning="binary_flag",
        # If we're returning a date, how granular should it be?
        include_month=False,
        include_day=False,
    ):
        validate_time_period_options(**locals())
        return "died_from_any_cause", locals()

    @staticmethod
    def with_death_recorded_in_cpns(
        # Set date limits
        on_or_before=None,
        on_or_after=None,
        between=None,
        # Set return type
        returning="binary_flag",
        # If we're returning a date, how granular should it be?
        include_month=False,
        include_day=False,
    ):
        validate_time_period_options(**locals())
        return "with_death_recorded_in_cpns", locals()


def validate_time_period_options(
    # Set date limits
    on_or_before=None,
    on_or_after=None,
    between=None,
    **kwargs,
):
    if between:
        if not isinstance(between, (tuple, list)) or len(between) != 2:
            raise ValueError("`between` should be a pair of dates")
        if on_or_before or on_or_after:
            raise ValueError(
                "You cannot set `between` at the same time as "
                "`on_or_before` or `on_or_after`"
            )
    # TODO: enforce just one return type and only allow month/day to be included
    # if return type is a date


def codelist_to_sql(codelist):
    if getattr(codelist, "has_categories", False):
        values = [quote(code) for (code, category) in codelist]
    else:
        values = map(quote, codelist)
    return ",".join(values)


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


def make_date_filter(column, min_date, max_date, between=None, upper_bound_only=False):
    if between is not None:
        assert min_date is None and max_date is None
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


def truncate_date(column, include_month, include_day):
    date_length = 4
    if include_month:
        date_length = 7
    if include_day:
        date_length = 10
    # Style 23 below means YYYY-MM-DD format, see:
    # https://docs.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-ver15#date-and-time-styles
    return f"CONVERT(VARCHAR({date_length}), {column}, 23)"


# Quick and dirty hack until we have a proper library for codelists
class Codelist(list):
    system = None
    has_categories = False


def codelist_from_csv(filename, system, column="code", category_column=None):
    codes = []
    with open(filename, "r") as f:
        for row in csv.DictReader(f):
            if category_column:
                codes.append((row[column], row[category_column]))
            else:
                codes.append(row[column])
    codes = Codelist(codes)
    codes.system = system
    codes.has_categories = bool(category_column)
    return codes


def codelist(codes, system):
    codes = Codelist(codes)
    codes.system = system
    first_code = codes[0]
    if isinstance(first_code, tuple):
        codes.has_categories = True
    return codes


def filter_codes_by_category(codes, include):
    assert codes.has_categories
    new_codes = Codelist()
    new_codes.system = codes.system
    new_codes.has_categories = True
    for code, category in codes:
        if category in include:
            new_codes.append((code, category))
    return new_codes


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
