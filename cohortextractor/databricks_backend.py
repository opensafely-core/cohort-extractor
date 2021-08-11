import os
from datetime import datetime
from functools import reduce
from pathlib import Path

from pyspark import SparkConf, SparkContext, SQLContext
from pyspark.sql import DataFrame


class DatabricksBackend:
    def __init__(self, database_url, covariate_definitions, temporary_database=None):
        self.next_temp_table_id = 0
        self.session = self.create_spark_session()
        self.dataframes = self.build_dataframes(covariate_definitions)

    def create_spark_session(self):
        """Create a session."""

        conf = SparkConf().set(
            "spark.driver.extraClassPath",
            Path(__file__).parent.parent / "sqljdbc_9.2" / "mssql-jdbc-9.2.1.jre11.jar",
        )
        spark_context = SparkContext(conf=conf)
        return SQLContext(spark_context).sparkSession

    def build_dataframes(self, covariate_definitions):
        """Lazily build the dataframes that will be used to extract the cohort.

        We build one dataframe per covariate.
        """

        self.create_view("patient")

        dataframes = {}
        for name, (query_type, query_args) in covariate_definitions.items():
            method_name = f"patients_{query_type}"
            method = getattr(self, method_name)
            query_args.pop("hidden")
            query_args.pop("column_type")
            if name != "population":
                query_args.pop("return_expectations")
            sql = method(**query_args)
            dataframes[name] = self.session.sql(sql)

        return dataframes

    def to_dicts(self):
        """Return extracted cohort as list of dicts, with one dict per patient."""

        return [row.asDict() for row in self.execute()]

    def execute(self):
        """Execute query to extract cohort.

        Starting with the population dataframe, we build a new dataframe by successively
        left-joining each of the other dataframes, and finally collecting the results.
        No work is performed by Spark until the results are collected.
        """

        result = self.dataframes["population"].drop("value")
        for name, df in self.dataframes.items():
            if name == "population":
                continue
            df = df.withColumnRenamed("value", name)
            result = result.join(df, how="left", on="patient_id")
            # TODO choose default value based on column
            result = result.na.fill({name: 0})
        return result.collect()

    def patients_all(self):
        """Return SQL to return all patients."""

        return """
        SELECT
            patient_id,
            1 AS value
        FROM patient
        """

    def patients_sex(self):
        """Return SQL to return all patients with their sex."""

        return """
        SELECT
            patient_id,
            sex AS value
        FROM patient
        """

    def patients_age_as_of(self, reference_date):
        """Return SQL to return all patients with their age on reference_date."""

        return f"""
        SELECT
            patient_id,
            months_between('{reference_date}', dateofbirth) / 12 AS value
        FROM patient
        """

    def patients_with_these_clinical_events(self, codelist, between, **kwargs):
        """Return SQL to return all patients with a clinical event whose code is in the
        codelist between the given dates."""

        codelist_view_name = self.create_codelist_view(codelist)
        codedevent_view_name = self.create_view_for_time_period("codedevent", between)

        min_date, max_date = between

        return f"""
        SELECT
            patient_id,
            1 AS value
        FROM {codedevent_view_name} AS codedevent
        INNER JOIN {codelist_view_name} AS codelist
            ON codedevent.ctv3code = codelist.code
        WHERE codedevent.consultationdate BETWEEN '{min_date}' AND '{max_date}'
        GROUP BY patient_id
        """

    def get_dataframe_for_table(self, table_name):
        """Return a dataframe to allow us to query data in the given table.

        This currently connects to a SQL Server database.  It is expected that this will
        need to change for production!
        """
        # The default JDBC URL works for tests when they are run directly on
        # the host, with the database servers running in Docker Compose.
        #
        # If running the cohort-extractor tests *in* Docker Compose, e.g. as
        # run.sh does, for the connection to succeed, this URL needs to be:
        # jdbc:sqlserver://mssql:1433;databaseName=Test_OpenCorona
        # as this connection is from one container to another, not from host
        # to container.
        database_url = os.environ.get(
            "DATABRICKS_DATASOURCE_DATABASE_URL",
            "jdbc:sqlserver://localhost:15785;databaseName=Test_OpenCorona",
        )

        reader = (
            self.session.read.format("jdbc")
            .option("driver", "com.microsoft.sqlserver.jdbc.SQLServerDriver")
            .option("url", database_url)
            .option("user", "SA")
            .option("password", "Your_password123!")
        )
        return reader.option("dbtable", table_name).load()

    def create_view(self, table_name):
        """Create a view on a dataframe to allow us to query the dataframe with SQL."""

        df = self.get_dataframe_for_table(table_name)
        df.createTempView(table_name)

    def create_view_for_time_period(self, base_table_name, between):
        """Create a view on dataframe that combines data from several single-year
        tables.

        Returns the name of the view, to allow it to be queried with SQL.
        """

        min_date, max_date = between
        min_year = datetime.strptime(min_date, "%Y-%m-%d").year
        max_year = datetime.strptime(max_date, "%Y-%m-%d").year
        years = list(range(min_year, max_year + 1))

        dfs = [
            self.get_dataframe_for_table(f"{base_table_name}_{year}") for year in years
        ]
        df = reduce(DataFrame.union, dfs)

        name = self.get_view_name(base_table_name)
        df.createTempView(name)
        return name

    def create_codelist_view(self, codelist):
        """Create a view on a dataframe containing the codes from the given codelist."""

        data = [(code,) for code in codelist]
        df = self.session.createDataFrame(data, ["code"])
        name = self.get_view_name("codelist")
        df.createTempView(name)
        return name

    def get_view_name(self, base_name):
        """Return the name of a view with a unique suffix."""

        self.next_temp_table_id += 1
        return f"{base_name}_{self.next_temp_table_id}"
