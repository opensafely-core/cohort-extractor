import datetime
import os
import re
from urllib.parse import urlparse, unquote

import pandas
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
        self.population = self.run_query(*self.population_definition)
        for name, (query_type, query_args) in self.covariate_definitions.items():
            self.covariates[name] = self.run_query(query_type, query_args)
        study_df = self.population
        for column_name, df in self.covariates.items():
            # Boolean covariates are just lists of patient IDs, we treat them
            # as having an implicit 1 column
            if len(df.columns) == 0:
                df.insert(0, column_name, 1)
            # Otherwise we rename the value column to match our output name
            else:
                df.rename({df.columns[0]: column_name}, axis=1, inplace=True)
            study_df = study_df.merge(
                df, how="left", left_index=True, right_index=True, copy=False
            )
        study_df.fillna(0, inplace=True)
        study_df.to_csv(filename, index_label="patient_id")

    def run_query(self, query_type, query_args):
        method_name = f"patients_{query_type}"
        method = getattr(self, method_name)
        return method(**query_args)

    def patients_age_as_of(self, reference_date):
        demographic_df = self.get_demographic_df()
        demographic_df["age"] = (reference_date - demographic_df["birth_date"]).astype(
            "<m8[Y]"
        )
        return demographic_df[["age"]]

    def patients_sex(self):
        demographic_df = self.get_demographic_df()
        return demographic_df[["sex"]]

    def get_demographic_df(self):
        if self._demographic_df is not None:
            return self._demographic_df
        if self.population is None:
            where_condition = ""
            params = []
        else:
            placeholders, params = placeholders_and_params(self.population.index)
            where_condition = f"WHERE patient_id IN ({placeholders})"
        self._demographic_df = self.sql_to_df(
            f"""
            SELECT
              Patient_ID AS patient_id,
              DateOfBirth AS birth_date,
              Sex as sex
            FROM Patient
            {where_condition}
            """,
            params,
        )
        return self._demographic_df

    def patients_all(self):
        """
        All patients
        """
        return self.sql_to_df(
            f"""
            SELECT DISTINCT Patient_ID AS patient_id
            FROM Patient
            ORDER BY patient_id
            """
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
        return self.sql_to_df(
            f"""
            SELECT DISTINCT med.Patient_ID AS patient_id
            FROM MedicationDictionary AS dict
            INNER JOIN MedicationIssue AS med
            ON dict.MultilexDrug_ID = med.MultilexDrug_ID
            WHERE dict.DMD_ID IN ({placeholders}) AND {date_condition}
            ORDER BY patient_id
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
        return self.sql_to_df(
            f"""
            SELECT DISTINCT Patient_ID AS patient_id
            FROM CodedEvent
            WHERE CTV3Code IN ({placeholders}) AND {date_condition}
            ORDER BY patient_id
            """,
            params,
        )

    def patients_with_positive_covid_test(self):
        return self.sql_to_df(
            """
            SELECT DISTINCT Patient_ID as patient_id
            FROM CovidStatus
            WHERE Result = 'COVID19'
            ORDER BY patient_id
            """
        )

    def patients_have_died(self):
        return self.sql_to_df(
            """
            SELECT DISTINCT Patient_ID as patient_id
            FROM CovidStatus
            WHERE Died = 'true'
            ORDER BY patient_id
            """
        )

    def patients_admitted_to_itu(self):
        return self.sql_to_df(
            """
            SELECT DISTINCT Patient_ID as patient_id
            FROM CovidStatus
            WHERE AdmittedToITU = 'true'
            ORDER BY patient_id
            """
        )

    def sql_to_df(self, sql, params=[]):
        return pandas.read_sql_query(
            sql, self.get_db_connection(), params=params, index_col="patient_id"
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
        # convert to datetime, as this is how it's stored in MS Sql Server
        reference_date = datetime.datetime.combine(
            reference_date, datetime.datetime.min.time()
        )
        return "age_as_of", locals()

    @staticmethod
    def all():
        return "all", locals()

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
    def have_died():
        return "have_died", locals()

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
    codes = pandas.read_csv(filename)["code"]
    codes = Codelist(codes)
    codes.system = system
    return codes


def codelist(codes, system):
    codes = Codelist(codes)
    codes.system = system
    return codes
