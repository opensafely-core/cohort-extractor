import csv
import datetime
import os
import re
from urllib.parse import urlparse, unquote

import pyodbc

from .expressions import format_expression


# Characters that are safe to interpolate into SQL (see
# `placeholders_and_params` below)
SAFE_CHARS_RE = re.compile(r"[a-zA-Z0-9_\.\-]+")


class StudyDefinition:
    _db_connection = None

    def __init__(self, population, **kwargs):
        self.population_definition = population
        self.covariate_definitions = kwargs
        if self.population_definition[0] == "satisfying":
            raise ValueError(
                "`satisfying` queries can't yet be used in the population definition"
            )

    def to_csv(self, filename):
        sql, params = self.to_sql()
        conn = self.get_db_connection()
        cursor = conn.cursor()
        cursor.execute(sql, params)
        with open(filename, "w", newline="") as csvfile:
            writer = csv.writer(csvfile)
            writer.writerow([x[0] for x in cursor.description])
            for row in cursor:
                writer.writerow(row)

    def to_dicts(self):
        sql, params = self.to_sql()
        conn = self.get_db_connection()
        cursor = conn.cursor()
        cursor.execute(sql, params)
        keys = [x[0] for x in cursor.description]
        # Convert all values to str as that's what will end in the CSV
        return [dict(zip(keys, map(str, row))) for row in cursor]

    def to_sql(self):
        self.covariates = {}
        population_cols, population_sql, population_params = self.get_query(
            *self.population_definition
        )
        hidden_columns = set()
        for name, (query_type, query_args) in self.covariate_definitions.items():
            if query_type != "satisfying":
                self.covariates[name] = self.get_query(query_type, query_args)
            # Special case for boolean expressions which can define extra
            # hidden columns which they use for their logic but which don't
            # appear in the output
            else:
                extra_columns = query_args["extra_columns"].items()
                for hidden_name, (hidden_query_type, hidden_args) in extra_columns:
                    hidden_columns.add(hidden_name)
                    self.covariates[hidden_name] = self.get_query(
                        hidden_query_type, hidden_args
                    )
        cte_cols = ["population.patient_id"]  # XXX might more come from left side?
        ctes = [f"WITH population AS ({population_sql})"]
        cte_params = population_params
        cte_joins = []
        for column_name, (cols, sql, params) in self.covariates.items():
            ctes.append(f"{column_name} AS ({sql})")
            cte_params.extend(params)
            cte_joins.append(
                f"LEFT JOIN {column_name} ON {column_name}.Patient_ID = population.Patient_ID"
            )
            if column_name in hidden_columns:
                continue
            # The first column should always be patient_id so we can join on it
            assert len(cols) > 1
            assert cols[0] == "patient_id"
            for n, col in enumerate(cols[1:]):
                # The first result column is given the name of the desired
                # output column. The rest are added as suffixes to the name of
                # the output column
                output_column = column_name if n == 0 else f"{column_name}_{col}"
                is_date_col = (
                    col == "date" or col.startswith("date_") or col.endswith("_date")
                )
                is_code_col = col.endswith("_code")
                if is_date_col or is_code_col:
                    default_value = "''"
                else:
                    default_value = 0
                cte_cols.append(
                    f"ISNULL({column_name}.{col}, {default_value}) AS {output_column}"
                )
        # Add column defintions for covariates which are boolean expressions
        # over other covariates
        for name, (query_type, query_args) in self.covariate_definitions.items():
            if query_type == "satisfying":
                expression = self.get_boolean_expression(self.covariates, **query_args)
                cte_cols.append(f"CASE WHEN ({expression}) THEN 1 ELSE 0 END AS {name}")
        cte_sql = ", ".join(ctes)
        sql = f"""
        {cte_sql}
        SELECT
          {', '.join(cte_cols)}
        FROM population
        {' '.join(cte_joins)}
        """
        return sql, cte_params

    def get_query(self, query_type, query_args):
        method_name = f"patients_{query_type}"
        method = getattr(self, method_name)
        return method(**query_args)

    def patients_age_as_of(self, reference_date):
        return (
            ["patient_id", "age"],
            """
        SELECT
          Patient_ID AS patient_id,
          CASE WHEN
             dateadd(year, datediff (year, DateOfBirth, ?), DateOfBirth) > ?
          THEN
             datediff(year, DateOfBirth, ?) - 1
          ELSE
             datediff(year, DateOfBirth, ?)
          END AS age
        FROM Patient
        """,
            [reference_date] * 4,
        )

    def patients_sex(self):
        return (
            ["patient_id", "sex"],
            """
          SELECT
            Patient_ID AS patient_id,
            Sex as sex
          FROM Patient""",
            [],
        )

    def patients_all(self):
        """
        All patients
        """
        return (
            ["patient_id", "date_of_birth", "sex"],
            """
            SELECT Patient_ID AS patient_id, DateOfBirth AS date_of_birth, Sex AS sex
            FROM Patient
            """,
            [],
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
            RAND()) as int)) % 100) < ?
            """,
            [percent],
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
        date_condition, date_params = make_date_filter(
            "ConsultationDate", on_or_after, on_or_before, between
        )

        bmi_code = "22K.."
        # XXX these two sets of codes need validating. The final in
        # each list is the canonical version according to TPP
        weight_codes = [
            "X76C7",  # Concept containing "body weight" terms:
            "22A.. ",  # O/E weight
        ]
        height_codes = [
            "XM01E",  # Concept containing height/length/stature/growth terms:
            "229..",  # O/E height
        ]
        params = []

        bmi_cte = f"""
        SELECT t.Patient_ID, t.BMI, t.ConsultationDate
        FROM (
          SELECT Patient_ID, NumericValue AS BMI, ConsultationDate,
          ROW_NUMBER() OVER (PARTITION BY Patient_ID ORDER BY ConsultationDate DESC) AS rownum
          FROM CodedEvent
          WHERE CTV3Code = ? AND {date_condition}
        ) t
        WHERE t.rownum = 1
        """
        bmi_cte_params = [bmi_code] + date_params

        patients_cte = f"""
           SELECT Patient_ID, DateOfBirth
           FROM Patient
        """
        patients_cte_params = []
        weight_placeholders, weight_params = placeholders_and_params(weight_codes)
        weights_cte = f"""
          SELECT t.Patient_ID, t.weight, t.ConsultationDate
          FROM (
            SELECT Patient_ID, NumericValue AS weight, ConsultationDate,
            ROW_NUMBER() OVER (PARTITION BY Patient_ID ORDER BY ConsultationDate DESC) AS rownum
            FROM CodedEvent
            WHERE CTV3Code IN ({weight_placeholders}) AND {date_condition}
          ) t
          WHERE t.rownum = 1
        """
        weights_cte_params = weight_params + date_params

        height_placeholders, height_params = placeholders_and_params(height_codes)
        # The height date restriction is different from the others. We don't
        # mind using old values as long as the patient was old enough when they
        # were taken.
        height_date_condition, height_date_params = make_date_filter(
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
            WHERE CTV3Code IN ({height_placeholders}) AND {height_date_condition}
          ) t
          WHERE t.rownum = 1
        """
        heights_cte_params = height_params + height_date_params

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
        params = (
            patients_cte_params
            + weights_cte_params
            + heights_cte_params
            + bmi_cte_params
        )
        columns = ["patient_id", "BMI"]
        if include_measurement_date:
            columns.append("date_measured")
        return columns, sql, params

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
        date_condition, date_params = make_date_filter(
            "ConsultationDate", on_or_after, on_or_before, between
        )
        placeholders, code_params = placeholders_and_params(codelist)
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
            WHERE CTV3Code IN ({placeholders}) AND {date_condition}
            GROUP BY Patient_ID
        ) AS days
        LEFT JOIN CodedEvent
        ON (
          CodedEvent.Patient_ID = days.Patient_ID
          AND CodedEvent.CTV3Code IN ({placeholders})
          AND CAST(CodedEvent.ConsultationDate AS date) = days.date_measured
        )
        GROUP BY days.Patient_ID, days.date_measured
        """
        params = code_params + date_params + code_params
        columns = ["patient_id", "mean_value"]
        if include_measurement_date:
            columns.append("date_measured")
        return columns, sql, params

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
            WHERE StartDate <= ? AND EndDate > ?
            """,
            [start_date, end_date],
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
            **kwargs,
        )

    def patients_with_these_clinical_events(self, **kwargs):
        """
        Patients who have had at least one of these clinical events in the
        defined period
        """
        return self._patients_with_events("CodedEvent", "CTV3Code", **kwargs)

    def _patients_with_events(
        self,
        from_table,
        code_column,
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
        placeholders, params = placeholders_and_params(codelist)
        date_condition, date_params = make_date_filter(
            "ConsultationDate", on_or_after, on_or_before, between
        )
        params.extend(date_params)

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
              WHERE {code_column} IN ({placeholders}) AND {date_condition}
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
            WHERE {code_column} IN ({placeholders}) AND {date_condition}
            GROUP BY Patient_ID
            """

        if returning == "date":
            columns = ["patient_id", date_column_name]
        else:
            columns = ["patient_id", column_name]
            if include_date_of_match:
                columns.append(date_column_name)
        return columns, sql, params

    def patients_registered_practice_as_of(self, date, returning=None):
        if returning == "stp_code":
            column = "STPCode"
        elif returning == "msoa_code":
            column = "MSOACode"
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")
        # Note that current registrations are recorded with an EndDate of
        # 9999-12-31. Note also that the below query assumes address
        # registration periods never overlap.
        return (
            ["patient_id", returning],
            f"""
            SELECT Patient_ID AS patient_id, Organisation.{column} AS {returning}
            FROM RegistrationHistory
            LEFT JOIN Organisation
            ON Organisation.Organisation_ID = RegistrationHistory.Organisation_ID
            WHERE StartDate <= ? AND EndDate > ?
            """,
            [date, date],
        )

    def patients_address_as_of(self, date, returning=None, round_to_nearest=None):
        if returning == "index_of_multiple_deprivation":
            assert round_to_nearest == 100
            column = "ImdRankRounded"
        elif returning == "rural_urban_classification":
            column = "RuralUrbanClassificationCode"
        else:
            raise ValueError(f"Unsupported `returning` value: {returning}")
        # Note that current addresses are recorded with an EndDate of
        # 9999-12-31. Note also that the below query assumes address
        # registration periods never overlap
        return (
            ["patient_id", returning],
            f"""
            SELECT Patient_ID AS patient_id, {column} AS {returning}
            FROM PatientAddress
            WHERE StartDate <= ? AND EndDate > ?
            """,
            [date, date],
        )

    def patients_with_positive_covid_test(self):
        return (
            ["patient_id", "has_covid"],
            """
            SELECT DISTINCT Patient_ID as patient_id, 1 AS has_covid
            FROM CovidStatus
            WHERE Result = 'COVID19'
            """,
            [],
        )

    def patients_have_died_of_covid(self):
        return (
            ["patient_id", "died"],
            """
            SELECT DISTINCT Patient_ID as patient_id, 1 AS died
            FROM CovidStatus
            WHERE Died = 'true'
            """,
            [],
        )

    def patients_admitted_to_itu(self):
        return (
            ["patient_id", "admitted_to_itu"],
            """
            SELECT DISTINCT Patient_ID as patient_id, 1 AS admitted_to_itu
            FROM CovidStatus
            WHERE AdmittedToITU = 'true'
            """,
            [],
        )

    def get_boolean_expression(self, covariates, expression, extra_columns=None):
        # The column references in the supplied expression need to be rewritten
        # to ensure they refer to the correct CTE. The formatting function also
        # ensures that the expression matches the very limited subset of SQL we
        # support here.
        name_map = {}
        for name, (columns, _, _) in covariates.items():
            name_map[name] = f"{name}.{columns[1]}"
        return format_expression(expression, name_map)

    def get_db_connection(self):
        if self._db_connection:
            return self._db_connection
        parsed = urlparse(os.environ["DATABASE_URL"])
        hostname = parsed.hostname
        port = parsed.port or 1433
        database = parsed.path.lstrip("/")
        username = unquote(parsed.username)
        password = unquote(parsed.password)
        connection_str = (
            f"DRIVER={{ODBC Driver 17 for SQL Server}};"
            f"SERVER={hostname},{port};"
            f"DATABASE={database};"
            f"UID={username};"
            f"PWD={password}"
        )
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
    def satisfying(expression, **extra_columns):
        return "satisfying", locals()

    @staticmethod
    def registered_practice_as_of(date, returning=None):
        return "registered_practice_as_of", locals()

    @staticmethod
    def address_as_of(date, returning=None, round_to_nearest=None):
        return "address_as_of", locals()

    # The below are placeholder methods we don't expect to make it into the final API.
    # They use a handler which returns dummy CHESS data.

    @staticmethod
    def with_positive_covid_test():
        return "with_positive_covid_test", locals()

    @staticmethod
    def have_died_of_covid():
        return "have_died_of_covid", locals()

    @staticmethod
    def admitted_to_itu():
        return "admitted_to_itu", locals()

    @staticmethod
    def random_sample(percent=None):
        assert percent, "Must specify a percentage greater than zero"
        return "random_sample", locals()


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


def placeholders_and_params(values, as_ints=False):
    """
    Returns parameter placeholders for use in an SQL `IN` condition, together
    with a list of parameters to be used.

    Ideally the function would just be this:

      placeholders = ','.join("?" * len(values))
      params = values

    However, the pyodbc driver uses "prepared statements" under the hood and
    these have a maximum limit of 2100 parameters, which we exceed when using
    large codelists. (See: https://github.com/mkleehammer/pyodbc/issues/576).
    One way of working around this would be to use temporary tables, but for
    now we just manually interpolate the values into the SQL. Rather than
    attempt any escaping we simply apply a whitelist of known safe characters.
    As the codes we use come from quite a restricted character set this
    shouldn't be a problem. And if it is we'll just blow up with an error
    rather than do anything dangerous.
    """
    if as_ints:
        raise NotImplementedError("TODO")
    values = list(map(str, values))
    for value in values:
        if not SAFE_CHARS_RE.match(value):
            raise ValueError(f"Value contains disallowed characters: {value}")
    quoted_values = [f"'{value}'" for value in values]
    placeholders = ",".join(quoted_values)
    params = []
    return placeholders, params


def make_date_filter(column, min_date, max_date, between=None, upper_bound_only=False):
    if between is not None:
        assert min_date is None and max_date is None
        min_date, max_date = between
    if upper_bound_only:
        min_date = None
    if min_date is not None and max_date is not None:
        return f"{column} BETWEEN ? AND ?", [min_date, max_date]
    elif min_date is not None:
        return f"{column} >= ?", [min_date]
    elif max_date is not None:
        return f"{column} <= ?", [max_date]
    else:
        return "1=1", []


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


def codelist_from_csv(filename, system, column="code"):
    codes = []
    with open(filename, "r") as f:
        for row in csv.DictReader(f):
            codes.append(row[column])

    codes = Codelist(codes)
    codes.system = system
    return codes


def codelist(codes, system):
    codes = Codelist(codes)
    codes.system = system
    return codes
