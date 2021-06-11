from pyspark import SparkConf, SparkContext, SQLContext


class DatabricksBackend:
    def __init__(self, database_url, covariate_definitions, temporary_database=None):
        self.next_temp_table_id = 1
        self.session = self.get_spark_session(database_url)
        self.dataframes = self.build_dataframes(covariate_definitions)

    def build_dataframes(self, covariate_definitions):
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
        return [row.asDict() for row in self.execute()]

    def execute(self):
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
        return """
        SELECT
            patient_id,
            1 AS value
        FROM patient
        """

    def patients_sex(self):
        return """
        SELECT
            patient_id,
            sex AS value
        FROM patient
        """

    def patients_age_as_of(self, reference_date):
        return f"""
        SELECT
            patient_id,
            months_between('{reference_date}', dateofbirth) / 12 AS value
        FROM patient
        """

    def patients_with_these_clinical_events(self, codelist, **kwargs):
        codelist_table_name = self.create_codelist_table(codelist)
        return f"""
        SELECT
            patient_id,
            1 AS value
        FROM codedevent
        INNER JOIN {codelist_table_name} AS codelist
            ON codedevent.ctv3code = codelist.code
        GROUP BY patient_id
        """

    def create_codelist_table(self, codelist):
        name = f"codelist_{self.next_temp_table_id}"
        self.next_temp_table_id += 1
        data = [(code,) for code in codelist]
        df = self.session.createDataFrame(data, ["code"])
        df.createOrReplaceTempView(name)
        return name

    def get_spark_session(self, database_url):
        conf = SparkConf().set(
            "spark.driver.extraClassPath", "sqljdbc_9.2/mssql-jdbc-9.2.1.jre11.jar"
        )
        spark_context = SparkContext(conf=conf)
        session = SQLContext(spark_context).sparkSession

        reader = (
            session.read.format("jdbc")
            .option("driver", "com.microsoft.sqlserver.jdbc.SQLServerDriver")
            .option("url", database_url)
            .option("user", "SA")
            .option("password", "Your_password123!")
        )

        for table_name in [
            "patient",
            "codedevent",
        ]:
            df = reader.option("dbtable", table_name).load()
            df.createOrReplaceTempView(table_name)

        return session
