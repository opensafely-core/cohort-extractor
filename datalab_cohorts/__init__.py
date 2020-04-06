import csv
import datetime
import os
import re
from urllib.parse import urlparse, unquote

import pyodbc


# Characters that are safe to interpolate into SQL (see
# `placeholders_and_params` below)
SAFE_CHARS_RE = re.compile(r"[a-zA-Z0-9_\.\-]+")


class StudyDefinition:
    population = None
    _demographic_df = None
    _chess_df = None
    _db_connection = None

    def __init__(self, population, **kwargs):
        self.population_definition = population
        self.covariate_definitions = kwargs

    def to_csv(self, filename):
        self.covariates = {}
        population_cols, population_sql, population_params = self.run_query(
            *self.population_definition
        )
        for name, (query_type, query_args) in self.covariate_definitions.items():
            self.covariates[name] = self.run_query(query_type, query_args)
        cte_cols = ["population.patient_id"]  # XXX might more come from left side?
        ctes = [f"WITH population AS ({population_sql})"]
        cte_params = population_params
        cte_joins = []
        for column_name, (cols, sql, params) in self.covariates.items():
            ctes.append(f"{column_name} AS ({sql})")
            cte_params.extend(params)
            for col in cols:
                if col != "patient_id":
                    cte_cols.append(f"ISNULL({column_name}.{col}, 0) AS {column_name}")
            cte_joins.append(
                f"LEFT JOIN {column_name} ON {column_name}.Patient_ID = population.Patient_ID"
            )
        cte_sql = ", ".join(ctes)
        sql = f"""
        {cte_sql}
        SELECT
          {', '.join(cte_cols)}
        FROM population
        {' '.join(cte_joins)}
        """
        self.sql_to_csv(sql, cte_params, filename)

    def sql_to_csv(self, sql, params, filename):
        conn = self.get_db_connection()
        cursor = conn.cursor()
        cursor.execute(sql, params)
        with open(filename, "w") as csvfile:
            writer = csv.writer(csvfile)
            writer.writerow([x[0] for x in cursor.description])
            for row in cursor:
                writer.writerow(row)

    def run_query(self, query_type, query_args):
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

    def patients_bmi(self, reference_date):
        """Return BMI as of reference date, ignoring measurements over 10
        years prior

        """
        # From https://github.com/ebmdatalab/tpp-sql-notebook/issues/10:
        #
        # 1) BMI calculated from last recorded height and weight
        #
        # 2) If height and weight is not available, then take latest
        # recorded BMI. Both values must be recorded when the patient
        # is >=16, weight must be within the last 10 years

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
          WHERE CTV3Code = ?
          AND ConsultationDate >= DATEADD(year, -10, ?)
          AND ConsultationDate <= ?
        ) t
        WHERE t.rownum = 1
        """
        bmi_cte_params = [bmi_code, reference_date, reference_date]

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
            WHERE CTV3Code IN ({weight_placeholders})
            AND ConsultationDate >= DATEADD(year, -10, ?)
            AND ConsultationDate <= ?
          ) t
          WHERE t.rownum = 1
        """
        weights_cte_params = weight_params + [reference_date, reference_date]

        height_placeholders, height_params = placeholders_and_params(height_codes)
        heights_cte = f"""
          SELECT t.Patient_ID, t.height, t.ConsultationDate
          FROM (
            SELECT Patient_ID, NumericValue AS height, ConsultationDate,
            ROW_NUMBER() OVER (PARTITION BY Patient_ID ORDER BY ConsultationDate DESC) AS rownum
            FROM CodedEvent
            WHERE CTV3Code IN ({height_placeholders})
            AND ConsultationDate <= ?
          ) t
          WHERE t.rownum = 1
        """
        heights_cte_params = height_params + [reference_date]
        sql = f"""
        SELECT
          patients.Patient_ID AS patient_id, weight, height,
          ROUND(COALESCE(weight/SQUARE(NULLIF(height, 0)), bmis.BMI), 1) AS BMI
        FROM ({patients_cte}) AS patients
        LEFT JOIN ({weights_cte}) AS weights
        ON weights.Patient_ID = patients.Patient_ID AND DATEDIFF(YEAR, patients.DateOfBirth, weights.ConsultationDate) > 16
        LEFT JOIN ({heights_cte}) AS heights
        ON heights.Patient_ID = patients.Patient_ID AND DATEDIFF(YEAR, patients.DateOfBirth, heights.ConsultationDate) > 16
        LEFT JOIN ({bmi_cte}) AS bmis
        ON bmis.Patient_ID = patients.Patient_ID AND DATEDIFF(YEAR, patients.DateOfBirth, bmis.ConsultationDate) > 16
        -- XXX maybe add a "WHERE NULL..." here
        """
        params = (
            patients_cte_params
            + weights_cte_params
            + heights_cte_params
            + bmi_cte_params
        )
        return ["patient_id", "weight", "height", "BMI"], sql, params

    def patients_registered_as_of(self, reference_date):
        """
        All patients registed on the given date
        """
        # Note that current registrations are recorded with an EndDate
        # of 9999-12-31
        return (
            ["patient_id"],
            f"""
            SELECT DISTINCT Patient.Patient_ID AS patient_id
            FROM Patient
            INNER JOIN  RegistrationHistory
            ON RegistrationHistory.Patient_ID = Patient.Patient_ID
            WHERE StartDate < ? AND EndDate > ?
            """,
            [reference_date, reference_date],
        )

    def patients_with_these_medications(self, codelist, min_date=None, max_date=None):
        """
        Patients who have been prescribed at least one of this list of
        medications in the defined period
        """
        placeholders, params = placeholders_and_params(codelist)
        date_condition, date_params = make_date_filter(
            "ConsultationDate", min_date, max_date
        )
        params.extend(date_params)
        return (
            ["patient_id", "has_meds"],
            f"""
            SELECT DISTINCT med.Patient_ID AS patient_id, 1 AS has_meds
            FROM MedicationDictionary AS dict
            INNER JOIN MedicationIssue AS med
            ON dict.MultilexDrug_ID = med.MultilexDrug_ID
            WHERE dict.DMD_ID IN ({placeholders}) AND {date_condition}
            """,
            params,
        )

    def patients_with_these_clinical_events(
        self, codelist, min_date=None, max_date=None
    ):
        """
        Patients who have had at least one of these clinical events in the
        defined period
        """
        placeholders, params = placeholders_and_params(codelist)
        date_condition, date_params = make_date_filter(
            "ConsultationDate", min_date, max_date
        )
        params.extend(date_params)
        return (
            ["patient_id", "has_clinical_event"],
            f"""
            SELECT DISTINCT Patient_ID AS patient_id, 1 AS has_clinical_event
            FROM CodedEvent
            WHERE CTV3Code IN ({placeholders}) AND {date_condition}
            """,
            params,
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
    def bmi(reference_date):
        if reference_date == "today":
            reference_date = datetime.date.today()
        else:
            reference_date = datetime.date.fromisoformat(str(reference_date))
        return "bmi", locals()

    @staticmethod
    def all():
        return "all", locals()

    @staticmethod
    def random_sample(percent):
        return "random_sample", locals()

    @staticmethod
    def sex():
        return "sex", locals()

    @staticmethod
    def with_these_medications(codelist, min_date=None, max_date=None):
        assert codelist.system == "snomed"
        return "with_these_medications", locals()

    @staticmethod
    def with_these_clinical_events(codelist, min_date=None, max_date=None):
        assert codelist.system == "ctv3"
        return "with_these_clinical_events", locals()

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


def make_date_filter(column, min_date, max_date):
    if min_date is not None and max_date is not None:
        return f"{column} BETWEEN ? AND ?", [min_date, max_date]
    elif min_date is not None:
        return f"{column} >= ?", [min_date]
    elif max_date is not None:
        return f"{column} <= ?", [max_date]
    else:
        return "1=1", []


# Quick and dirty hack until we have a proper library for codelists
class Codelist(list):
    system = None


def codelist_from_csv(filename, system):
    codes = []
    with open(filename, "r") as f:
        for row in csv.DictReader(f):
            codes.append(row["code"])
    codes = Codelist(codes)
    codes.system = system
    return codes


def codelist(codes, system):
    codes = Codelist(codes)
    codes.system = system
    return codes
