import gzip
import math

import dateutil.parser
import numpy
import pandas
import pytest
from pandas import NaT, Timestamp

from cohortextractor.pandas_utils import (
    dataframe_from_rows,
    dataframe_to_file,
    to_datetime,
)


def test_dataframe_from_rows():
    rows = [
        ("patient_id", "age", "sex", "bmi", "stp", "date_admitted", "date_died"),
        (1, 20, "M", 18.5, "STP1", "2018-08-01", "2020-05"),
        (2, 38, "F", None, "STP2", "2019-12-12", "2020-06"),
        (3, 65, "M", 0, "STP2", "", "2020-07"),
        (4, 42, "F", 17.8, "", "2020-04-10", "2020-08"),
        (5, 18, "M", 26.2, "STP3", "2020-06-20", ""),
        (6, 44, "M", 14.2, "STP3", "9999-12-31", "9999-12-31 00:00:00"),
    ]
    covariate_definitions = {
        "population": ("satisfying", {"column_type": "bool"}),
        "age": ("age_as_of", {"column_type": "int"}),
        "sex": ("sex", {"column_type": "str"}),
        "bmi": ("bmi", {"column_type": "float"}),
        "stp": ("practice_as_of", {"column_type": "str"}),
        "date_admitted": ("admitted_to_hospital", {"column_type": "date"}),
        "date_died": ("with_death_recorded_in_cpns", {"column_type": "date"}),
    }
    df = dataframe_from_rows(covariate_definitions, iter(rows))

    expected = [
        {
            "patient_id": 1,
            "age": 20,
            "sex": "M",
            "bmi": 18.5,
            "stp": "STP1",
            "date_admitted": Timestamp("2018-08-01 00:00:00"),
            "date_died": Timestamp("2020-05-01 00:00:00"),
        },
        {
            "patient_id": 2,
            "age": 38,
            "sex": "F",
            "bmi": None,
            "stp": "STP2",
            "date_admitted": Timestamp("2019-12-12 00:00:00"),
            "date_died": Timestamp("2020-06-01 00:00:00"),
        },
        {
            "patient_id": 3,
            "age": 65,
            "sex": "M",
            "bmi": 0.0,
            "stp": "STP2",
            "date_admitted": NaT,
            "date_died": Timestamp("2020-07-01 00:00:00"),
        },
        {
            "patient_id": 4,
            "age": 42,
            "sex": "F",
            "bmi": 17.8,
            "stp": None,
            "date_admitted": Timestamp("2020-04-10 00:00:00"),
            "date_died": Timestamp("2020-08-01 00:00:00"),
        },
        {
            "patient_id": 5,
            "age": 18,
            "sex": "M",
            "bmi": 26.2,
            "stp": "STP3",
            "date_admitted": Timestamp("2020-06-20 00:00:00"),
            "date_died": NaT,
        },
        {
            "patient_id": 6,
            "age": 44,
            "sex": "M",
            "bmi": 14.2,
            "stp": "STP3",
            # check both date strings are clamped to max
            "date_admitted": Timestamp.max,
            "date_died": Timestamp.max,
        },
    ]

    # Faff, we can't do equality checks with NaN values so we have to convert
    # them to None
    records = [
        {
            k: v if not (type(v) is float and math.isnan(v)) else None
            for (k, v) in record.items()
        }
        for record in df.to_dict("record")
    ]
    assert records == expected
    assert df.patient_id.dtype == int
    assert df.age.dtype == int
    assert type(df.sex.dtype) == pandas.CategoricalDtype
    assert df.bmi.dtype == float
    assert type(df.stp.dtype) == pandas.CategoricalDtype
    assert df.date_admitted.dtype == numpy.dtype("datetime64[ns]")
    assert df.date_died.dtype == numpy.dtype("datetime64[ns]")


@pytest.mark.parametrize(
    "datestr, expected",
    [
        # test below max
        ("2262-04-10", pandas.Timestamp(year=2262, month=4, day=10)),
        # test above max
        ("2262-04-11 23:48", pandas.Timestamp.max),
        ("9999-12-30 00:00:00", pandas.Timestamp.max),
        ("9999-12-30", pandas.Timestamp.max),
        ("9003-05-18", pandas.Timestamp.max),  # seen in the wild
        # test above min
        ("1677-09-22", pandas.Timestamp(year=1677, month=9, day=22)),
        # test below min
        ("1677-09-20", pandas.Timestamp.min),
    ],
)
def test_to_datetime(datestr, expected):
    assert to_datetime(datestr) == expected


def test_to_datetime_bad_str():
    with pytest.raises(dateutil.parser.ParserError):
        to_datetime("not a date")


@pytest.mark.parametrize(
    "filename, gzipped, read",
    [
        ("file.csv", False, pandas.read_csv),
        ("file.csv.gz", True, pandas.read_csv),
        ("file.feather", False, pandas.read_feather),
        ("file.dta", False, pandas.read_stata),
        ("file.dta.gz", True, pandas.read_stata),
    ],
)
def test_dateframe_to_file_csv(filename, gzipped, read, tmp_path):
    rows = [
        ("patient_id", "age", "sex", "bmi", "stp", "date_admitted", "date_died"),
        (1, 20, "M", 18.5, "STP1", "2018-08-01", "2020-05"),
        (2, 38, "F", None, "STP2", "2019-12-12", "2020-06"),
        (3, 65, "M", 0, "STP2", "", "2020-07"),
        (4, 42, "F", 17.8, "", "2020-04-10", "2020-08"),
        (5, 18, "M", 26.2, "STP3", "2020-06-20", ""),
    ]
    covariate_definitions = {
        "population": ("satisfying", {"column_type": "bool"}),
        "age": ("age_as_of", {"column_type": "int"}),
        "sex": ("sex", {"column_type": "str"}),
        "bmi": ("bmi", {"column_type": "float"}),
        "stp": ("practice_as_of", {"column_type": "str"}),
        "date_admitted": ("admitted_to_hospital", {"column_type": "date"}),
        "date_died": ("with_death_recorded_in_cpns", {"column_type": "date"}),
    }

    df = dataframe_from_rows(covariate_definitions, iter(rows))

    path = tmp_path / filename
    dataframe_to_file(df, path)

    if gzipped:
        # test it's valid gzip
        gzip.open(path).read()

    # note: ideally, we'd compare for equality, but this is hard to do, as the
    # types and data can change depending on the output format.  So, we check
    # that we can actually load the serialised data as a basic correctness
    # check.
    read(path)
