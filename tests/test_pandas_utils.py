import math

import numpy
import pandas
from pandas import NaT, Timestamp

from cohortextractor.pandas_utils import dataframe_from_rows


def test_dataframe_from_rows():
    rows = [
        ("patient_id", "age", "sex", "bmi", "stp", "date_admitted", "date_died"),
        (1, 20, "M", 18.5, "STP1", "2018-08-01", "2020-05"),
        (2, 38, "F", None, "STP2", "2019-12-12", "2020-06"),
        (3, 65, "M", 0, "STP2", "", "2020-07"),
        (4, 42, "F", 17.8, "", "2020-04-10", "2020-08"),
        (5, 18, "M", 26.2, "STP3", "2020-06-20", ""),
        (6, 44, "M", 14.2, "STP3", "2020-06-20", "9999-12-30 00:00:00"),
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
            "date_admitted": Timestamp("2020-06-20 00:00:00"),
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
