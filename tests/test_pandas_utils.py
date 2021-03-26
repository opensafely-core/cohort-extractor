import math

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
            "age": 20,
            "bmi": 18.5,
            "date_admitted": Timestamp("2018-08-01 00:00:00"),
            "date_died": Timestamp("2020-05-01 00:00:00"),
            "patient_id": 1,
            "sex": "M",
            "stp": "STP1",
        },
        {
            "age": 38,
            "bmi": None,
            "date_admitted": Timestamp("2019-12-12 00:00:00"),
            "date_died": Timestamp("2020-06-01 00:00:00"),
            "patient_id": 2,
            "sex": "F",
            "stp": "STP2",
        },
        {
            "age": 65,
            "bmi": 0.0,
            "date_admitted": NaT,
            "date_died": Timestamp("2020-07-01 00:00:00"),
            "patient_id": 3,
            "sex": "M",
            "stp": "STP2",
        },
        {
            "age": 42,
            "bmi": 17.8,
            "date_admitted": Timestamp("2020-04-10 00:00:00"),
            "date_died": Timestamp("2020-08-01 00:00:00"),
            "patient_id": 4,
            "sex": "F",
            "stp": None,
        },
        {
            "age": 18,
            "bmi": 26.2,
            "date_admitted": Timestamp("2020-06-20 00:00:00"),
            "date_died": NaT,
            "patient_id": 5,
            "sex": "M",
            "stp": "STP3",
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
