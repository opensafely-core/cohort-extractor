import collections
import copy
import os
import re
import shutil
from pathlib import Path

import pandas as pd
import structlog
from numpy.random import default_rng

from .csv_utils import is_csv_filename
from .date_expressions import (
    evaluate_date_expressions_in_covariate_definitions,
    evaluate_date_expressions_in_expectations_definition,
    validate_date,
)
from .exceptions import DummyDataValidationError
from .expectation_generators import generate
from .log_utils import log_stats
from .pandas_utils import dataframe_from_rows, dataframe_to_file, dataframe_to_rows
from .process_covariate_definitions import process_covariate_definitions
from .validate_dummy_data import validate_dummy_data

logger = structlog.get_logger()


class StudyDefinition:

    backend = None

    def __init__(
        self, population, default_expectations=None, index_date=None, **covariates
    ):
        covariates["population"] = population
        self._original_covariates = process_covariate_definitions(covariates)
        self._original_default_expectations = default_expectations or {}
        self.set_index_date(index_date)
        self.pandas_csv_args = self.get_pandas_csv_args(self.covariate_definitions)
        self.database_url = os.environ.get("DATABASE_URL")
        self.temporary_database = os.environ.get("TEMP_DATABASE_NAME")
        if self.database_url:
            self.backend = self.create_backend()
        else:
            # Without a backend defined we can still generate dummy data but we
            # can't rely on the backend to validate the study definition for us
            self.validate_study_definition()
            self.backend = None
        self.log_initial_stats(self._original_covariates)

    def log_initial_stats(self, covariate_definitions):
        """
        Log some initial stats about the study definition
        """
        log_stats(logger, variable_count=len(covariate_definitions))
        codelist_counts = {
            variable_name: len(def_item["codelist"])
            for variable_name, definition in covariate_definitions.items()
            for def_item in definition
            if isinstance(def_item, dict) and "codelist" in def_item
        }
        log_stats(logger, variables_using_codelist_count=len(codelist_counts))
        for variable, codelist_count in codelist_counts.items():
            log_stats(
                logger, variable_using_codelist=variable, codelist_size=codelist_count
            )

    def set_index_date(self, index_date):
        """
        Re-evaluate all date expressions in the covariate definitions and the
        default expectations using the supplied index date and re-initialise the
        backend with the new values
        """
        if index_date is not None:
            validate_date(index_date)
        self.index_date = index_date
        self.covariate_definitions = evaluate_date_expressions_in_covariate_definitions(
            self._original_covariates, self.index_date
        )
        self.default_expectations = (
            evaluate_date_expressions_in_expectations_definition(
                self._original_default_expectations, self.index_date
            )
        )
        if self.backend:
            log_stats(logger, resetting_backend_index_date=index_date)
            self.recreate_backend()

    def set_sql_logging(self, truncate=False):
        if self.backend:
            self.backend.truncate_sql_logs = truncate

    def to_file(
        self, filename, expectations_population=False, dummy_data_file=None, **kwargs
    ):
        if expectations_population:
            df = self.make_df_from_expectations(expectations_population)
            if "patient_id" not in df:
                # Add a patient ID - a randomly generated integer from an
                # array 10x larger than the cohort.
                df["patient_id"] = default_rng().choice(
                    (len(df) * 10), size=len(df), replace=False
                )
            if not is_csv_filename(filename):
                # This slightly convoluted approach means that dummy data
                # intended for a binary output format gets passed through the
                # same conversion process as real data (which happens in
                # `dataframe_from_rows`). Real data intended for CSV output
                # does not go through this process so we don't do that for
                # dummy CSV data either.
                df = dataframe_from_rows(
                    self.covariate_definitions, dataframe_to_rows(df)
                )
            dataframe_to_file(df, filename)
        elif dummy_data_file:
            if Path(filename).suffixes != dummy_data_file.suffixes:
                expected_extension = "".join(filename.suffixes)
                msg = f"Expected dummy data file with extension {expected_extension}; got {dummy_data_file}"
                raise DummyDataValidationError(msg)
            validate_dummy_data(self.covariate_definitions, dummy_data_file)
            shutil.copyfile(dummy_data_file, filename)
        else:
            self.assert_backend_is_configured()
            self.backend.to_file(filename, **kwargs)

    def csv_to_df(self, csv_name):
        return pd.read_csv(
            csv_name,
            dtype=self.pandas_csv_args["dtype"],
            converters=self.pandas_csv_args["converters"],
            parse_dates=self.pandas_csv_args["parse_dates"],
        )

    def to_sql(self):
        self.assert_backend_is_configured()
        return self.backend.to_sql()

    def to_dicts(self, convert_to_strings=True):
        self.assert_backend_is_configured()
        return self.backend.to_dicts(convert_to_strings)

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

    # ************************************************************************
    # END OF PUBLIC API
    # ************************************************************************

    @staticmethod
    def get_backend_for_database_url(database_url):
        if (
            database_url.startswith("mssql://")
            or database_url.startswith("mssql+pyodbc://")
            or database_url.startswith("mssql+pymssql")
        ):

            from .tpp_backend import TPPBackend

            return TPPBackend
        # presto:// is now legacy and replaced with trino://
        # presto:// is included for backwards compatibilty only and can be
        # removed in future.
        elif database_url.startswith("trino://") or database_url.startswith(
            "presto://"
        ):
            from .emis_backend import EMISBackend

            return EMISBackend
        else:
            raise ValueError(f"No matching backend found for {database_url}")

    def assert_backend_is_configured(self):
        if not self.backend:
            raise RuntimeError(
                "Cannot extract data as no DATABASE_URL environment variable defined"
            )

    def validate_study_definition(self):
        # As a crude way of error checking we construct a TPP backend with a
        # dummy database URL. We immediately discard the backend instance, but
        # the process of constructing it should trigger any problems with the
        # study definition.
        self.create_backend("mssql://localhost/dummy")

    def create_backend(self, database_url=None):
        # Creates an appropriate backend for the database URL. Uses
        # the provided URL or `self.database_url` if none is provided.
        Backend = self.get_backend_for_database_url(database_url or self.database_url)
        return Backend(
            self.database_url,
            self.covariate_definitions,
            temporary_database=self.temporary_database,
        )

    def recreate_backend(self):
        self.backend.close()
        self.backend = self.create_backend()

    @staticmethod
    def get_pandas_csv_args(covariate_definitions):
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
            kwargs = kwargs.copy()
            kwargs["funcname"] = funcname
            args[name] = kwargs
            column_type = kwargs["column_type"]

            if funcname == "aggregate_of":
                # We've already validated that the source columns for each
                # aggregate expression are of the same type and, for dates,
                # that they have the same date format. So we can just grab the
                # first source column and use the date format from that.
                other_column = kwargs["column_names"][0]
                other_date_format = covariate_definitions[other_column][1].get(
                    "date_format"
                )
                if other_date_format:
                    kwargs["date_format"] = other_date_format

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
                column_type = "str"

            # Another awkward corner: we allow `categorised_as` functions to
            # return dates, which can then be used as inputs to other
            # functions. For the purposes of real data extraction they behave
            # like dates and should be typed as such. However for the purposes
            # of dummy data generation they act like categoricals (dates get a
            # whole load of special treatment that we don't want here).
            if funcname == "categorised_as" and column_type == "date":
                column_type = "str"

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

    def make_df_from_expectations(self, population):
        df = pd.DataFrame()

        # Start with the user-supplied CSV file
        for colname, definition_args in self.pandas_csv_args["args"].items():
            if definition_args["funcname"] not in [
                "with_value_from_file",
                "which_exist_in_file",
            ]:
                continue
            f_path = definition_args["f_path"]
            if not is_csv_filename(f_path):
                raise ValueError("`f_path` must be a path to a CSV file")

            returning = definition_args.get("returning")
            returning_type = definition_args.get("returning_type")
            if returning is not None and returning_type is None:
                raise ValueError(f"No `returning_type` defined for {colname}")
            if returning is None and returning_type is not None:
                raise ValueError(f"No `returning` defined for {colname}")
            if returning is not None and not re.fullmatch(r"\w+", returning, re.ASCII):
                raise ValueError(
                    f"{colname} should contain only alphanumeric characters and the underscore character"
                )

            usecols = ["patient_id"]
            if returning is not None:
                usecols.append(returning)
            user_df = pd.read_csv(f_path, usecols=usecols, dtype=str)
            if returning_type == "date":
                user_df[returning] = pd.to_datetime(
                    user_df[returning], infer_datetime_format=True
                )

            df["patient_id"] = user_df["patient_id"]
            df[colname] = user_df[returning] if returning is not None else 1
            # The population should be the same size as the number of patients in the
            # user-supplied CSV file. This ensures we generate no more dummy data than
            # is necessary.
            new_population = len(df)
            if population != new_population:
                logger.info(
                    f"Setting population size to {new_population} (was {population}) to match user-supplied CSV file"
                )
                population = new_population

        # Now dates, so we can use them as inputs for incidence matching on dependent
        # columns
        for colname in self.pandas_csv_args["parse_dates"]:
            definition_args = self.pandas_csv_args["args"][colname]
            if definition_args["funcname"] in [
                "aggregate_of",
                "with_value_from_file",
                "which_exist_in_file",
                "fixed_value",
            ]:
                continue
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
            self.check_date_expectations_defined(colname, kwargs)
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
            definition_args = self.pandas_csv_args["args"][colname]
            if definition_args["funcname"] in [
                "aggregate_of",
                "with_value_from_file",
                "which_exist_in_file",
                "fixed_value",
            ]:
                continue
            return_expectations = definition_args["return_expectations"] or {}
            if not self.default_expectations and not return_expectations:
                raise ValueError(
                    f"No `return_expectations` defined for {colname} "
                    "and no `default_expectations` defined for the study"
                )
            kwargs = self.default_expectations.copy()
            kwargs = merge(kwargs, return_expectations)
            self.check_date_expectations_defined(colname, kwargs)

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

        # Populate dataframe with any fixed values
        for colname, definition_args in self.pandas_csv_args["args"].items():
            if definition_args["funcname"] != "fixed_value":
                continue
            value = definition_args["value"]
            if definition_args["column_type"] == "date":
                value = pd.to_datetime(value)
            df[colname] = pd.Series([value] * population)

        # Calculate the value of aggregated columns
        for colname, definition_args in self.pandas_csv_args["args"].items():
            if definition_args["funcname"] != "aggregate_of":
                continue
            fn = definition_args["aggregate_function"]
            if fn == "MIN":
                method_name = "min"
            elif fn == "MAX":
                method_name = "max"
            else:
                raise ValueError(f"Unsupported aggregate function '{fn}'")
            columns = self.get_columns_for_aggregation(
                population, df, list(definition_args["column_names"])
            )
            aggregate_method = getattr(columns, method_name)
            df[colname] = aggregate_method(axis=1)

        # Finally, reduce date columns to the precision requested in
        # the definition
        for colname in self.pandas_csv_args["parse_dates"]:
            definition_args = self.pandas_csv_args["args"][colname]
            df[colname] = self.apply_date_precision_from_definition(
                df[colname], **definition_args
            )
        return df

    def get_columns_for_aggregation(self, population, df, column_names):
        extra_columns = {
            k: v
            for (k, v) in self.covariate_definitions.items()
            if k in column_names and v[1]["hidden"]
        }
        if extra_columns:
            extra_study = StudyDefinition(
                # It doesn't matter what the population is here, it's not
                # relevant in generating the extra columns we need. But we
                # can't use the real population definition because that may be
                # an expression referencing columns which don't appear in our
                # "extra study" and so will trigger an error.
                population=("all", {}),
                default_expectations=self.default_expectations,
                index_date=self.index_date,
                **extra_columns,
            )
            extra_df = extra_study.make_df_from_expectations(population)
            non_extra_columns = [
                c for c in column_names if c not in extra_columns.keys()
            ]
            dt = extra_study.pandas_csv_args["args"][list(extra_columns.keys())[0]][
                "column_type"
            ]
            if dt == "date":
                extra_df = extra_df.apply(pd.to_datetime)
            if non_extra_columns:
                for c in non_extra_columns:
                    extra_df[c] = df[c]
            columns = extra_df[column_names]
        else:
            columns = df[column_names]
        return columns

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
                f"Expected categories {', '.join(defined)} are not a subset of "
                f"available categories {', '.join(available)}"
            )

    def apply_date_filters_from_definition(self, series, between=None, **kwargs):
        min_date, max_date = self.filter_date_range(between)
        if min_date and max_date:
            series = series[(series >= min_date) & (series <= max_date)]
        elif min_date:
            series = series[series >= min_date]
        elif max_date:
            series = series[series <= max_date]
        return series

    @staticmethod
    def filter_date_range(between):
        if not between:
            return None, None
        # Filter out "dynamic" date expressions (i.e. date expressions which
        # refer to the values of other columns). Date expressions which can be
        # evaluated statically will already have been converted to ISO dates at
        # this point.  Eventually we want to support evaluating dynamic date
        # expressions here, but for now we just ignore them.
        return [
            value
            if not isinstance(value, str) or re.match(r"\d\d\d\d-\d\d-\d\d", value)
            else None
            for value in between
        ]

    def apply_date_precision_from_definition(self, series, date_format=None, **kwargs):
        if date_format == "YYYY-MM-DD":
            series = series.dt.strftime("%Y-%m-%d")
        elif date_format == "YYYY-MM":
            series = series.dt.strftime("%Y-%m")
        else:
            series = series.dt.strftime("%Y")
        return series

    def check_date_expectations_defined(self, colname, kwargs):
        if "date" not in kwargs:
            raise ValueError(f"{colname} must define a date expectation")
        for k in ["earliest", "latest"]:
            if k not in kwargs["date"]:
                raise ValueError(f"{colname} must define a date[{k}] expectation")


def merge(dict1, dict2):
    """Return a new dictionary by merging two dictionaries recursively."""

    result = copy.deepcopy(dict1)

    for key, value in dict2.items():
        if isinstance(value, collections.abc.Mapping):
            result[key] = merge(result.get(key, {}), value)
        else:
            result[key] = copy.deepcopy(dict2[key])
    return result
