import collections
import copy
import csv
import datetime
import enum
import os
import re
import subprocess
import tempfile
from urllib.parse import urlparse, unquote

import pyodbc

import pandas as pd

from .expressions import format_expression
from .expectation_generators import generate
from .process_covariate_definitions import process_covariate_definitions


# Characters that are safe to interpolate into SQL (see
# `placeholders_and_params` below)
SAFE_CHARS_RE = re.compile(r"^[a-zA-Z0-9_\.\-]+$")


def merge(dict1, dict2):
    """ Return a new dictionary by merging two dictionaries recursively. """

    result = copy.deepcopy(dict1)

    for key, value in dict2.items():
        if isinstance(value, collections.Mapping):
            result[key] = merge(result.get(key, {}), value)
        else:
            result[key] = copy.deepcopy(dict2[key])
    return result


class StudyDefinition:
    _db_connection = None
    _current_column_name = None

    def __init__(self, population, **covariates):
        covariates["population"] = population
        self.default_expectations = covariates.pop("default_expectations", {})
        covariates = process_covariate_definitions(covariates)
        self.codelist_tables = []
        self.covariate_definitions = covariates
        self.queries, self.column_types = self.get_queries_and_types(covariates)
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

    def apply_date_filters_from_definition(self, series, between=None, **kwargs):
        if between and between[0] and between[1]:
            series = series[(series >= between[0]) & (series <= between[1])]
        elif between and between[0]:
            series = series[series >= between[0]]
        elif between and between[1]:
            series = series[series <= between[1]]
        return series

    def apply_date_precision_from_definition(self, series, date_format=None, **kwargs):
        if date_format == "YYYY-MM-DD":
            series = series.dt.strftime("%Y-%m-%d")
        elif date_format == "YYYY-MM":
            series = series.dt.strftime("%Y-%m")
        else:
            series = series.dt.strftime("%Y")
        return series

    def validate_category_expectations(
        self,
        codelist=None,
        return_expectations=None,
        category_definitions=None,
        **kwargs,
    ):
        defined = set(return_expectations["category"]["ratios"].keys())
        if category_definitions:
            available = set(category_definitions.keys())
        elif codelist and codelist.has_categories:
            available = set([x[1] for x in codelist])
        else:
            available = defined
        if not defined.issubset(available):
            raise ValueError(
                f"Expected categories {', '.join(defined)} are not a subset of available categories {', '.join(available)}"
            )

    def convert_today_string_to_date(self, colname, kwargs):
        if "date" not in kwargs:
            raise ValueError(f"{colname} must define a date expectation")
        for k in ["earliest", "latest"]:
            if kwargs["date"][k] == "today":
                kwargs["date"][k] = datetime.datetime.now().strftime("%Y-%m-%d")

    def make_df_from_expectations(self, population):
        df = pd.DataFrame()

        # Start with dates, so we can use them as inputs for incidence
        # matching on dependent columns
        for colname in self.pandas_csv_args["parse_dates"]:
            definition_args = self.pandas_csv_args["args"][colname]
            if "source" in definition_args:
                source_args = self.pandas_csv_args["args"][definition_args["source"]]
                definition_args["return_expectations"] = source_args[
                    "return_expectations"
                ]
            return_expectations = definition_args["return_expectations"] or {}
            if not self.default_expectations and not return_expectations:
                raise ValueError(
                    f"No `return_expectations` defined for {colname} "
                    "and no `default_expectations` defined for the study"
                )
            kwargs = self.default_expectations.copy()
            kwargs = merge(kwargs, return_expectations)
            self.convert_today_string_to_date(colname, kwargs)
            df[colname] = generate(population, **kwargs)["date"]

            # Now apply any date-based filtering specified in the study
            # definition
            filtered_dates = self.apply_date_filters_from_definition(
                df[colname], **definition_args
            )
            df.loc[~df.index.isin(filtered_dates.index), colname] = None

        # Now we can optionally pass in an array which has already had
        # its incidence calculated as a mask
        for colname, dtype in self.pandas_csv_args["dtype"].items():
            if not self.pandas_csv_args["args"][colname].get("return_expectations"):
                raise ValueError(f"No `return_expectations` defined for {colname}")
            kwargs = self.default_expectations.copy()
            kwargs = merge(
                kwargs, self.pandas_csv_args["args"][colname]["return_expectations"]
            )
            self.convert_today_string_to_date(colname, kwargs)

            if dtype == "category":
                self.validate_category_expectations(
                    **self.pandas_csv_args["args"][colname]
                )

            if dtype == "bool" and "bool" not in kwargs:
                kwargs["bool"] = True

            dependent_date = self.pandas_csv_args["date_col_for"].get(colname)
            if dependent_date:
                generated_df = generate(
                    population, match_incidence=df[dependent_date], **kwargs
                )
            else:
                generated_df = generate(population, **kwargs)
            try:
                if dtype == "Int64":
                    # When defining expectations, the more
                    # user-friendly `int` is used
                    dtype = "int"
                df[colname] = generated_df[dtype]
            except KeyError:

                raise ValueError(
                    f"Column definition {colname} does not return expected type {dtype}"
                )
        # Finally, reduce date columns to the precision requested in
        # the definition
        for colname in self.pandas_csv_args["parse_dates"]:
            definition_args = self.pandas_csv_args["args"][colname]
            df[colname] = self.apply_date_precision_from_definition(
                df[colname], **definition_args
            )
        return df

    def to_csv(self, filename, expectations_population=False, with_sqlcmd=False):
        if expectations_population:
            df = self.make_df_from_expectations(expectations_population)
            # Turn the index into a dummy patient_id column; longer
            # term, we don't plan to include this in the output
            df = df.reset_index()
            df = df.rename(columns={"index": "patient_id"})
            df.to_csv(filename, index=False)
        elif with_sqlcmd:
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
        return pd.read_csv(
            csv_name,
            dtype=self.pandas_csv_args["dtype"],
            converters=self.pandas_csv_args["converters"],
            parse_dates=self.pandas_csv_args["parse_dates"],
        )

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
        args = {}
        date_col_for = {}

        for name, (funcname, kwargs) in covariate_definitions.items():
            if name == "population" or kwargs.get("hidden"):
                continue
            args[name] = kwargs.copy()
            column_type = self.column_types[name]

            # Awkward workaround: IMD is in fact an int, but it comes to us
            # rounded to nearest hundred which makes it act a bit more like a
            # categorical variable for the purposes of dummy data generation so
            # we pretend that's what it is here. Similarly, rural/urban
            # classification is as int in datatype terms but is conceptually
            # categorical, so possibly we need a categorical int type to handle
            # these.
            if kwargs.get("returning") in (
                "index_of_multiple_deprivation",
                "rural_urban_classification",
            ):
                dtypes[name] = "category"
                continue

            if column_type == "date":
                parse_dates.append(name)
                # if granularity doesn't include a day, add one
                if kwargs.get("date_format") in ("YYYY", None):
                    converters[name] = add_month_and_day_to_date
                elif kwargs.get("date_format") == "YYYY-MM":
                    converters[name] = add_day_to_date
                if funcname == "value_from":
                    date_col_for[kwargs["source"]] = name
            elif column_type == "bool":
                converters[name] = tobool
                dtypes[name] = "bool"
            elif column_type == "int":
                dtypes[name] = "Int64"
            elif column_type == "str":
                dtypes[name] = "category"
            elif column_type == "float":
                dtypes[name] = "float"
            else:
                raise ValueError(
                    f"Unable to impute Pandas type for {column_type} "
                    f"({name}: {funcname})"
                )
        return {
            "dtype": dtypes,
            "converters": converters,
            "parse_dates": parse_dates,
            "args": args,
            "date_col_for": date_col_for,
        }

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

    def to_data(self):
        hidden_columns = []
        covariate_definitions = copy.deepcopy(self.covariate_definitions)
        for name, (query_type, query_args) in covariate_definitions.items():
            if query_args.pop("hidden", False):
                hidden_columns.append(name)
        data = {"hidden_columns": hidden_columns, "covariate_definitions": {}}
        for name, (query_type, query_args) in covariate_definitions.items():
            data["covariate_definitions"][name] = {
                "type": query_type,
                "args": query_args,
            }
        return data

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

    def get_queries_and_types(self, covariate_definitions):
        output_columns = {}
        is_hidden = {}
        table_queries = {}
        for name, (query_type, query_args) in covariate_definitions.items():
            # So we can safely mutate these below
            query_args = query_args.copy()
            # These arguments are not used in generating column data and the
            # corresponding functions do not accept them
            query_args.pop("return_expectations", None)
            is_hidden[name] = query_args.pop("hidden", False)
            # `categorised_as` columns don't generate their own table query,
            # they're just a CASE expression over columns generated by other
            # queries
            if query_type == "categorised_as":
                output_columns[name] = self.get_case_expression(
                    output_columns, **query_args
                )
            # `value_from` columns also don't generate a table, they just take
            # a value from another table
            elif query_type == "value_from":
                assert query_args["source"] in table_queries
                output_columns[name] = self.get_column_expression(**query_args)
            else:
                date_format_args = pop_keys_from_dict(query_args, ["date_format"])
                cols, sql = self.get_query(name, query_type, query_args)
                table_queries[name] = f"SELECT * INTO #{name} FROM ({sql}) t"
                # The first column should always be patient_id so we can join on it
                assert cols[0] == "patient_id"
                output_columns[name] = self.get_column_expression(
                    name, cols[1], **date_format_args
                )
        # If the population query defines its own temporary table then we use
        # that as the primary table to query against and left join everything
        # else against that. Otherwise, we use the `Patient` table.
        if "population" in table_queries:
            primary_table = "#population"
            patient_id_expr = ColumnExpression(
                "#population.patient_id", column_type="int"
            )
        else:
            primary_table = "Patient"
            patient_id_expr = ColumnExpression("Patient.Patient_ID", column_type="int")
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
        SELECT
          {output_columns_str}
        FROM
          {primary_table}
          {joins_str}
        WHERE {output_columns["population"]} = 1
        """
        queries = list(table_queries.items()) + [("final_output", joined_output_query)]
        column_types = {
            name: expr.column_type for (name, expr) in output_columns.items()
        }
        return queries, column_types

    def get_column_expression(self, source, returning, date_format=None):
        column_type = self.get_type_for_column(returning)
        default_value = self.get_default_value_for_type(column_type)
        column_expr = f"#{source}.{returning}"
        if column_type == "date":
            column_expr = truncate_date(column_expr, date_format)
        return ColumnExpression(
            f"ISNULL({column_expr}, {quote(default_value)})", column_type=column_type
        )

    def get_type_for_column(self, col):
        if col == "date" or col.startswith("date_") or col.endswith("_date"):
            return "date"
        elif (
            col in ("sex", "category", "code")
            or col.endswith("_code")
            or col.endswith("_name")
        ):
            return "str"
        elif (
            col == "died"
            or col.startswith("has_")
            or col.startswith("is_")
            or col.startswith("was_")
        ):
            return "bool"
        elif col in (
            "age",
            "count",
            "episode_count",
            "pseudo_id",
            "index_of_multiple_deprivation",
            "rural_urban_classification",
        ):
            return "int"
        elif col in ("value", "mean_value", "BMI"):
            return "float"
        else:
            raise ValueError(f"Unhandled return column name: {col}")

    def invent_column_name_for_type(self, column_type):
        """
        This is pretty backwards: sometimes we want to return a column of a
        particular type so this function returns a name which we know that the
        above function will map to the desired type. This definitely all needs
        refactoring at some point.
        """
        if column_type == "date":
            return "date"
        elif column_type == "str":
            return "category"
        elif column_type == "bool":
            return "is_true"
        elif column_type == "int":
            return "count"
        elif column_type == "float":
            return "value"
        else:
            raise ValueError(f"Unhandled column type: {column_type}")

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
                "No TEMP_DATABASE_NAME defined in environment, downloading results "
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
        assert percent, "Must specify a percentage greater than zero"
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
          ROW_NUMBER() OVER (PARTITION BY Patient_ID ORDER BY ConsultationDate DESC) AS rownum
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
            "ConsultationDate", between, upper_bound_only=True,
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

        min_age = int(minimum_age_at_measurement)

        sql = f"""
        SELECT
          patients.Patient_ID AS patient_id,
          ROUND(COALESCE(weight/SQUARE(NULLIF(height, 0)), bmis.BMI), 1) AS BMI,
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
        columns = ["patient_id", "BMI"]
        if include_date_of_match:
            columns.append("date")
        return columns, sql

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
        sql = f"""
        SELECT
          days.Patient_ID AS patient_id,
          AVG(CodedEvent.NumericValue) AS mean_value,
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
        columns = ["patient_id", "mean_value"]
        if include_date_of_match:
            columns.append("date")
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
            ["patient_id", "is_registered"],
            f"""
            SELECT DISTINCT Patient.Patient_ID AS patient_id, 1 AS is_registered
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
        codelist_table = self.create_codelist_table(codelist, codes_are_case_sensitive)
        date_condition = make_date_filter("ConsultationDate", between)
        not_an_ignored_day_condition = self._none_of_these_codes_occur_on_same_day(
            from_table, ignore_days_where_these_codes_occur
        )

        # Result ordering
        if find_first_match_in_period:
            ordering = "ASC"
            date_aggregate = "MIN"
        else:
            ordering = "DESC"
            date_aggregate = "MAX"

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
            column_name = "code"
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
            sql = f"""
            SELECT
              Patient_ID AS patient_id,
              {column_definition} AS {column_name},
              ConsultationDate AS date
            FROM (
              SELECT Patient_ID, {column_definition}, ConsultationDate,
              ROW_NUMBER() OVER (
                PARTITION BY Patient_ID ORDER BY ConsultationDate {ordering}
              ) AS rownum
              FROM {from_table}{additional_join}
              INNER JOIN {codelist_table}
              ON {code_column} = {codelist_table}.code
              WHERE {date_condition} AND {not_an_ignored_day_condition}
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
            WHERE {date_condition} AND {not_an_ignored_day_condition}
            GROUP BY Patient_ID
            """

        if returning == "date":
            columns = ["patient_id", "date"]
        else:
            columns = ["patient_id", column_name]
            if include_date_of_match:
                columns.append("date")
        return columns, sql

    def _number_of_episodes_by_medication(
        self,
        codelist,
        # Set date limits
        between=None,
        ignore_days_where_these_codes_occur=None,
        episode_defined_as=None,
    ):
        codelist_table = self.create_codelist_table(codelist, case_sensitive=False)
        date_condition = make_date_filter("ConsultationDate", between)
        not_an_ignored_day_condition = self._none_of_these_codes_occur_on_same_day(
            "MedicationIssue", ignore_days_where_these_codes_occur
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
          SUM(is_new_episode) AS episode_count
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
            WHERE {date_condition} AND {not_an_ignored_day_condition}
        ) t
        GROUP BY Patient_ID
        """
        return ["patient_id", "episode_count"], sql

    def _number_of_episodes_by_clinical_event(
        self,
        codelist,
        # Set date limits
        between=None,
        ignore_days_where_these_codes_occur=None,
        episode_defined_as=None,
    ):
        codelist_table = self.create_codelist_table(codelist, case_sensitive=True)
        date_condition = make_date_filter("ConsultationDate", between)
        not_an_ignored_day_condition = self._none_of_these_codes_occur_on_same_day(
            "CodedEvent", ignore_days_where_these_codes_occur
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
          SUM(is_new_episode) AS episode_count
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
            WHERE {date_condition} AND {not_an_ignored_day_condition}
        ) t
        GROUP BY Patient_ID
        """
        return ["patient_id", "episode_count"], sql

    def _none_of_these_codes_occur_on_same_day(self, joined_table, codelist):
        """
        Generates a SQL condition that filters rows in `joined_table` so that
        they only include events which happened on days where none of the codes
        in `codelist` occur in the CodedEvents table.

        We use this to support queries like "give me all the times a patient
        was prescribed this drug, but ignore any days on which they were having
        their annual COPD review".
        """
        if codelist is None:
            return "1 = 1"
        assert codelist.system == "ctv3"
        codelist_table = self.create_codelist_table(codelist, case_sensitive=True)
        return f"""
        NOT EXISTS (
          SELECT * FROM CodedEvent AS sameday
          INNER JOIN {codelist_table}
          ON sameday.CTV3Code = {codelist_table}.code
          WHERE
            sameday.Patient_ID = {joined_table}.Patient_ID
            AND CAST(sameday.ConsultationDate AS date) = CAST({joined_table}.ConsultationDate AS date)
        )
        """

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
            assert round_to_nearest is None
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

    def patients_care_home_status_as_of(self, date, categorised_as):
        # Get a column name which matches the type of the supplied categories.
        # (Needs refactoring, see docstring.)
        column = self.invent_column_name_for_type(
            self.infer_type_from_categories(categorised_as.keys())
        )
        # These are the columns to which the categorisation expression is
        # allowed to refer
        allowed_columns = {
            "IsPotentialCareHome": ColumnExpression(
                "ISNULL(PotentialCareHomeAddressID, 0)", column_type="int",
            ),
            "LocationRequiresNursing": ColumnExpression(
                "LocationRequiresNursing", column_type="str"
            ),
            "LocationDoesNotRequireNursing": ColumnExpression(
                "LocationDoesNotRequireNursing", column_type="str"
            ),
        }
        case_expression = self.get_case_expression(allowed_columns, categorised_as)
        return (
            ["patient_id", column],
            f"""
            SELECT
              Patient_ID AS patient_id,
              {case_expression} AS {column}
            FROM (
              SELECT
                PatientAddress.Patient_ID AS Patient_ID,
                PotentialCareHomeAddress.PatientAddress_ID AS PotentialCareHomeAddressID,
                LocationRequiresNursing,
                LocationDoesNotRequireNursing,
                ROW_NUMBER() OVER (
                  PARTITION BY PatientAddress.Patient_ID ORDER BY StartDate DESC, EndDate DESC
                ) AS rownum
              FROM PatientAddress
              LEFT JOIN PotentialCareHomeAddress
              ON PatientAddress.PatientAddress_ID = PotentialCareHomeAddress.PatientAddress_ID
              WHERE StartDate <= {quote(date)} AND EndDate > {quote(date)}
            ) t
            WHERE rownum = 1
            """,
        )

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
        date_condition = make_date_filter(date_expression, between)

        if returning == "date_admitted":
            column_name = date_column_name
            column_definition = date_expression
        elif returning == "binary_flag":
            column_name = "was_admitted"
            column_definition = 1
        else:
            assert False, "`returning` must be one of `binary_flag` or `date_admitted`"
        return (
            ["patient_id", column_name],
            f"""
            SELECT
              Patient_ID AS patient_id,
              {column_definition} AS {column_name},
              MAX(Ventilator) AS ventilated -- apparently can be 0, 1 or NULL
            FROM
              ICNARC
            GROUP BY Patient_ID
            HAVING
              {date_condition} AND SUM(BasicDays_RespiratorySupport) + SUM(AdvancedDays_RespiratorySupport) >= 1
            """,
        )

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
            column_name = "died"
        elif returning == "date_of_death":
            column_definition = "dod"
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
        between=None,
        # Set return type
        returning="binary_flag",
    ):
        return self.patients_with_these_codes_on_death_certificate(
            codelist=None, between=between, returning=returning,
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
            column_name = "died"
        elif returning == "date_of_death":
            column_definition = "MAX(DateOfDeath)"
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

        if returning == "binary_flag" or returning == "date":
            column_name = "has_event"
            column_definition = "1"
        else:
            # Because each Vaccination row can potentially map to multiple
            # VaccinationReference rows (one for each disease targeted by the
            # vaccine) anything beyond a simple binary flag or a date is going to
            # require more thought.
            raise ValueError(f"Unsupported `returning` value: {returning}")

        sql = f"""
        SELECT
          Patient_ID AS patient_id,
          {column_definition} AS {column_name},
          {date_aggregate}(VaccinationDate) AS date
        FROM Vaccination
        INNER JOIN VaccinationReference AS ref
        ON ref.VaccinationName_ID = Vaccination.VaccinationName_ID
        WHERE {conditions_str}
        GROUP BY Patient_ID
        """

        if returning == "date":
            columns = ["patient_id", "date"]
        else:
            columns = ["patient_id", column_name]
            if include_date_of_match:
                columns.append("date")
        return columns, sql

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
            column_name = "has_event"
            column_definition = "1"
        elif returning == "number_of_matches_in_period":
            column_name = "count"
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
        sql = f"""
        SELECT
          Patient_ID AS patient_id,
          {column_definition} AS {column_name},
          {date_aggregate}(SeenDate) AS date
        FROM Appointment
        WHERE Status IN ({valid_states_str}) AND {date_condition}
        GROUP BY Patient_ID
        """

        if returning == "date":
            columns = ["patient_id", "date"]
        else:
            columns = ["patient_id", column_name]
            if include_date_of_match:
                columns.append("date")
        return columns, sql

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
        return self.patients_registered_with_one_practice_between(start_date, end_date)

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

        sql = f"""
        SELECT
          patient_id,
          1 AS has_result,
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

        if returning == "date":
            columns = ["patient_id", "date"]
        else:
            columns = ["patient_id", "has_result"]
            if include_date_of_match:
                columns.append("date")
        return columns, sql

    def get_case_expression(self, column_definitions, category_definitions):
        category_definitions = category_definitions.copy()
        column_type = self.infer_type_from_categories(category_definitions.keys())
        defaults = [k for (k, v) in category_definitions.items() if v == "DEFAULT"]
        if len(defaults) > 1:
            raise ValueError("At most one default category can be defined")
        if len(defaults) == 1:
            default_value = defaults[0]
            category_definitions.pop(default_value)
        else:
            default_value = self.get_default_value_for_type(column_type)
        # For each column already defined, determine its corresponding "empty"
        # value (i.e. the default value for that column's type). This allows us
        # to support implicit boolean conversion because we know what the
        # "falsey" value for each column should be.
        empty_value_map = {
            name: self.get_default_value_for_type(expr.column_type)
            for name, expr in column_definitions.items()
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
        return ColumnExpression(
            f"CASE {' '.join(clauses)} ELSE {quote(default_value)} END",
            column_type=column_type,
        )

    def infer_type_from_categories(self, categories):
        categories = list(categories)
        first_type = type(categories[0])
        for other in categories[1:]:
            if type(other) != first_type:
                raise ValueError(
                    f"Categories must all be the same type, found {first_type} "
                    f"and {type(other)}"
                )
        if first_type is int:
            if set(categories) == {0, 1}:
                return "bool"
            else:
                return "int"
        elif first_type is float:
            return "float"
        elif first_type is str:
            return "str"
        else:
            raise ValueError(f"Unhandled category type: {first_type}")

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


def codelist_to_sql(codelist):
    if getattr(codelist, "has_categories", False):
        values = [quote(code) for (code, category) in codelist]
    else:
        values = map(quote, codelist)
    return ",".join(values)


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


class ColumnExpression(str):
    """
    A column expression is just a SQL expression string tagged with an
    additional `column_type` field
    """

    column_type = None

    def __new__(cls, value, column_type=None):
        instance = str.__new__(cls, value)
        instance.column_type = column_type
        return instance