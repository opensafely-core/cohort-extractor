import pandas


def dataframe_to_file(df, filename):
    filename = str(filename)
    if filename.endswith(".csv") or filename.endswith(".csv.gz"):
        df.to_csv(filename, index=False)
    elif filename.endswith(".feather"):
        df.to_feather(filename)
    elif filename.endswith(".dta") or filename.endswith(".dta.gz"):
        # Make a shallow copy of the dataframe so we can replace certain
        # columns without duplicating the entire thing in memory
        df = df.copy(deep=False)
        # Replace categorical columns with arrays of strings as Stata's
        # categorical support isn't that great. See:
        # https://github.com/opensafely-core/cohort-extractor/issues/534
        for column, dtype in list(df.dtypes.items()):
            if dtype.name == "category":
                df[column] = df[column].__array__()
        # Encode dates as proper Stata dates (we use "td" as we only need day
        # resolution)
        convert_dates = {
            column: "td"
            for (column, dtype) in df.dtypes.items()
            if dtype.name == "datetime64[ns]"
        }
        df.to_stata(filename, write_index=False, convert_dates=convert_dates)
    else:
        raise RuntimeError(f"Unsupported file format: {filename}")


def dataframe_to_rows(df):
    yield df.columns
    yield from df.to_records(index=False)


def dataframe_from_rows(covariate_definitions, rows):
    """
    Create a DataFrame from an iterator of rows
    """
    convertors = {
        name: get_pandas_convertor(funcname, **kwargs)
        for name, (funcname, kwargs) in covariate_definitions.items()
    }
    # `patient_id` isn't included in `covariate_definitions` so we need to add
    # it manually
    convertors["patient_id"] = int

    # First row is expected to be header row
    headers = next(rows)
    convertor_funcs = [convertors[column] for column in headers]

    def convert_row(row):
        return [convertor(value) for (convertor, value) in zip(convertor_funcs, row)]

    data = map(convert_row, rows)
    df = pandas.DataFrame(data, columns=headers)
    # Change categorical columns from arrays of ints to proper Pandas
    # Categorical objects
    for column in headers:
        convertor = convertors[column]
        if isinstance(convertor, Categoriser):
            categorical = pandas.Categorical.from_codes(
                df[column], categories=convertor.get_categories(), ordered=False
            )
            df[column] = categorical
    return df


def get_pandas_convertor(funcname, column_type=None, returning=None, **kwargs):
    # Awkward workaround: IMD is in fact an int, but it comes to us
    # rounded to nearest hundred which makes it act a bit more like a
    # categorical variable for the purposes of dummy data generation so
    # we pretend that's what it is here. Similarly, rural/urban
    # classification is as int in datatype terms but is conceptually
    # categorical, so possibly we need a categorical int type to handle
    # these.
    if returning in (
        "index_of_multiple_deprivation",
        "rural_urban_classification",
    ):
        return Categoriser()

    if column_type == "date":
        return to_datetime
    elif column_type == "bool":
        return bool
    elif column_type == "str":
        return Categoriser()
    elif column_type == "int":
        return lambda val: int(val) if val else val
    elif column_type == "float":
        return lambda val: float(val) if val else val
    else:
        raise ValueError(f"Unable to impute Pandas type for {column_type} ({funcname})")


class Categoriser(dict):

    counter = 0

    __call__ = dict.__getitem__

    def __missing__(self, value):
        if value:
            index = self.counter
            self.counter += 1
        else:
            index = -1
        self[value] = index
        return index

    def get_categories(self):
        enumerated = sorted((index, key) for (key, index) in self.items())
        return [key for (index, key) in enumerated if index > -1]


def memoize(fn):
    class cache(dict):
        def __missing__(self, key):
            value = fn(key)
            self[key] = value
            return value

    return cache().__getitem__


to_datetime = memoize(pandas.to_datetime)
