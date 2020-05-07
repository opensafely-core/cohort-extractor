import pytest

import pandas as pd

from datalab_cohorts import StudyDefinition
from datalab_cohorts import patients
from datalab_cohorts import codelist
from datalab_cohorts.expectation_generators import generate


def _converters_to_names(kwargs_dict):
    converters = kwargs_dict.pop("converters")
    converters_with_names = {}
    if converters:
        for k, v in converters.items():
            converters_with_names[k] = v.__name__
    kwargs_dict["converters"] = converters_with_names
    kwargs_dict.pop("args", None)
    return kwargs_dict


def test_age_dtype_generation():
    study = StudyDefinition(
        # This line defines the study population
        population=patients.all(),
        age=patients.age_as_of("2020-02-01"),
    )
    result = _converters_to_names(study.pandas_csv_args)
    assert result == {
        "dtype": {"age": "int"},
        "parse_dates": [],
        "date_col_for": {},
        "converters": {},
    }


def test_address_dtype_generation():
    study = StudyDefinition(
        # This line defines the study population
        population=patients.all(),
        rural_urban=patients.address_as_of(
            "2020-02-01", returning="rural_urban_classification"
        ),
    )
    result = _converters_to_names(study.pandas_csv_args)
    assert result == {
        "dtype": {"rural_urban": "category"},
        "parse_dates": [],
        "date_col_for": {},
        "converters": {},
    }


def test_sex_dtype_generation():
    study = StudyDefinition(population=patients.all(), sex=patients.sex())
    result = _converters_to_names(study.pandas_csv_args)
    assert result == {
        "dtype": {"sex": "category"},
        "converters": {},
        "date_col_for": {},
        "parse_dates": [],
    }


def test_clinical_events_with_date_dtype_generation():
    test_codelist = codelist(["X"], system="ctv3")
    study = StudyDefinition(
        population=patients.all(),
        diabetes=patients.with_these_clinical_events(
            test_codelist, return_first_date_in_period=True, include_month=True
        ),
    )

    result = _converters_to_names(study.pandas_csv_args)
    assert result == {
        "converters": {"diabetes": "add_day_to_date"},
        "date_col_for": {},
        "dtype": {},
        "parse_dates": ["diabetes"],
    }


def test_clinical_events_with_year_date_dtype_generation():
    test_codelist = codelist(["X"], system="ctv3")
    study = StudyDefinition(
        population=patients.all(),
        diabetes=patients.with_these_clinical_events(test_codelist, returning="date"),
    )
    result = _converters_to_names(study.pandas_csv_args)
    assert result == {
        "converters": {"diabetes": "add_month_and_day_to_date"},
        "date_col_for": {},
        "dtype": {},
        "parse_dates": ["diabetes"],
    }


def test_categorical_clinical_events_with_date_dtype_generation():
    categorised_codelist = codelist([("X", "Y")], system="ctv3")
    categorised_codelist.has_categories = True
    study = StudyDefinition(
        population=patients.all(),
        ethnicity=patients.with_these_clinical_events(
            categorised_codelist,
            returning="category",
            find_last_match_in_period=True,
            include_date_of_match=True,
        ),
    )

    result = _converters_to_names(study.pandas_csv_args)
    assert result == {
        "converters": {"ethnicity_date": "add_month_and_day_to_date"},
        "date_col_for": {"ethnicity": "ethnicity_date"},
        "dtype": {"ethnicity": "category"},
        "parse_dates": ["ethnicity_date"],
    }


def test_categorical_clinical_events_without_date_dtype_generation():
    categorised_codelist = codelist([("X", "Y")], system="ctv3")
    categorised_codelist.has_categories = True
    study = StudyDefinition(
        population=patients.all(),
        ethnicity=patients.with_these_clinical_events(
            categorised_codelist,
            returning="category",
            find_last_match_in_period=True,
            include_date_of_match=False,
        ),
    )

    result = _converters_to_names(study.pandas_csv_args)
    assert result == {
        "converters": {},
        "date_col_for": {},
        "dtype": {"ethnicity": "category"},
        "parse_dates": [],
    }


def test_bmi_dtype_generation():
    categorised_codelist = codelist([("X", "Y")], system="ctv3")
    categorised_codelist.has_categories = True
    study = StudyDefinition(
        population=patients.all(),
        bmi=patients.most_recent_bmi(
            on_or_after="2010-02-01",
            minimum_age_at_measurement=16,
            include_measurement_date=True,
            include_month=True,
        ),
    )

    result = _converters_to_names(study.pandas_csv_args)
    assert result == {
        "converters": {"bmi_date_measured": "add_day_to_date"},
        "dtype": {"bmi": "float"},
        "date_col_for": {"bmi": "bmi_date_measured"},
        "parse_dates": ["bmi_date_measured"],
    }


def test_clinical_events_numeric_value_dtype_generation():
    test_codelist = codelist(["X"], system="ctv3")
    study = StudyDefinition(
        population=patients.all(),
        creatinine=patients.with_these_clinical_events(
            test_codelist,
            find_last_match_in_period=True,
            on_or_before="2020-02-01",
            returning="numeric_value",
            include_date_of_match=True,
            include_month=True,
        ),
    )
    result = _converters_to_names(study.pandas_csv_args)
    assert result == {
        "converters": {"creatinine_date": "add_day_to_date"},
        "dtype": {"creatinine": "float"},
        "date_col_for": {"creatinine": "creatinine_date"},
        "parse_dates": ["creatinine_date"],
    }


def test_mean_recorded_value_dtype_generation():
    test_codelist = codelist(["X"], system="ctv3")
    study = StudyDefinition(
        population=patients.all(),
        bp_sys=patients.mean_recorded_value(
            test_codelist,
            on_most_recent_day_of_measurement=True,
            on_or_before="2020-02-01",
            include_measurement_date=True,
            include_month=True,
        ),
    )
    result = _converters_to_names(study.pandas_csv_args)
    assert result == {
        "converters": {"bp_sys_date_measured": "add_day_to_date"},
        "dtype": {"bp_sys": "float"},
        "date_col_for": {"bp_sys": "bp_sys_date_measured"},
        "parse_dates": ["bp_sys_date_measured"],
    }


def test_data_generator_date():
    population_size = 10000
    incidence = 0.2
    return_expectations = {
        "rate": "exponential_increase",
        "incidence": incidence,
        "date": {"earliest": "1970-01-01", "latest": "2019-12-31"},
    }
    result = generate(population_size, **return_expectations)

    # Check incidence numbers are correct
    null_rows = result[~pd.isnull(result["date"])]
    assert len(null_rows) == (population_size * incidence)

    # Check dates are distributed in increasing frequency
    year_counts = (
        result["date"].dt.strftime("%Y").reset_index().groupby("date").count()["index"]
    )
    max_count = population_size
    for count in list(reversed(year_counts))[:5]:
        assert count < max_count
        max_count = count


def test_data_generator_category_and_date():
    population_size = 10000
    incidence = 0.2
    return_expectations = {
        "rate": "exponential_increase",
        "incidence": incidence,
        "category": {"ratios": {"A": 0.1, "B": 0.7, "C": 0.2}},
        "date": {"earliest": "1900-01-01", "latest": "today"},
    }
    result = generate(population_size, **return_expectations)

    # Check incidence numbers are correct
    null_rows = result[~pd.isnull(result["date"])]
    assert len(null_rows) == (population_size * incidence)

    # Check categories are assigned more-or-less in correct proportion
    category_a = result[result["category"] == "A"]
    category_b = result[result["category"] == "B"]
    category_c = result[result["category"] == "C"]
    assert len(category_b) > len(category_c) > len(category_a)


def test_data_generator_float():
    population_size = 10000
    incidence = 0.6
    return_expectations = {
        "rate": "exponential_increase",
        "incidence": incidence,
        "float": {"distribution": "normal", "mean": 35, "stddev": 10},
    }
    result = generate(population_size, **return_expectations)
    assert abs(35 - int(result["float"].mean())) < 5


def test_data_generator_int():
    population_size = 10000
    incidence = 0.9
    return_expectations = {
        "rate": "exponential_increase",
        "incidence": incidence,
        "int": {"distribution": "normal", "mean": 10, "stddev": 1},
    }
    result = generate(population_size, **return_expectations)
    assert abs(10 - int(result["int"].mean())) < 3


def test_data_generator_bool():
    population_size = 10000
    incidence = 0.5
    return_expectations = {
        "rate": "exponential_increase",
        "incidence": incidence,
        "bool": True,
    }
    result = generate(population_size, **return_expectations)
    assert result["bool"].fillna(0).mean() == 0.5


def test_data_generator_universal_category():
    population_size = 10000
    return_expectations = {
        "rate": "universal",
        "category": {"ratios": {"rural": 0.1, "urban": 0.9}},
    }
    result = generate(population_size, **return_expectations)
    assert (
        result.category.value_counts()["urban"]
        > result.category.value_counts()["rural"]
    )


def test_data_generator_age():
    population_size = 10000
    return_expectations = {
        "rate": "universal",
        "int": {"distribution": "population_ages"},
    }
    result = generate(population_size, **return_expectations)
    assert result.int.min() < 5 and result.int.max() > 95


def test_make_df_from_expectations_with_categories():
    categorised_codelist = codelist([("1", "A"), ("2", "B")], system="ctv3")
    categorised_codelist.has_categories = True
    study = StudyDefinition(
        population=patients.all(),
        ethnicity=patients.with_these_clinical_events(
            categorised_codelist,
            returning="category",
            return_expectations={
                "rate": "exponential_increase",
                "incidence": 0.2,
                "category": {"ratios": {"A": 0.3, "B": 0.7}},
                "date": {"earliest": "1900-01-01", "latest": "today"},
            },
            find_last_match_in_period=True,
            include_date_of_match=False,
        ),
    )
    population_size = 10000
    result = study.make_df_from_expectations(population_size)
    assert result.columns == ["ethnicity"]

    category_counts = result.reset_index().groupby("ethnicity").count()
    assert category_counts.loc["A", :][0] < category_counts.loc["B", :][0]


def test_make_df_from_expectations_with_categories_in_codelist_validation():
    categorised_codelist = codelist([("X", "Y")], system="ctv3")
    categorised_codelist.has_categories = True
    study = StudyDefinition(
        population=patients.all(),
        ethnicity=patients.with_these_clinical_events(
            categorised_codelist,
            returning="category",
            return_expectations={
                "rate": "exponential_increase",
                "incidence": 0.2,
                "category": {"ratios": {"A": 0.3, "B": 0.7}},
                "date": {"earliest": "1900-01-01", "latest": "today"},
            },
            find_last_match_in_period=True,
            include_date_of_match=False,
        ),
    )
    population_size = 10000
    with pytest.raises(ValueError):
        study.make_df_from_expectations(population_size)


def test_make_df_from_expectations_with_categories_expression():
    study = StudyDefinition(
        population=patients.all(),
        category=patients.categorised_as(
            {"A": "sex = 'F'", "B": "sex = 'M'"},
            sex=patients.sex(),
            return_expectations={
                "rate": "exponential_increase",
                "incidence": 0.2,
                "category": {"ratios": {"A": 0.3, "B": 0.7}},
                "date": {"earliest": "1900-01-01", "latest": "today"},
            },
        ),
    )
    population_size = 10000
    result = study.make_df_from_expectations(population_size)
    value_counts = result.category.value_counts()
    assert value_counts["A"] < value_counts["B"]


def test_make_df_from_expectations_with_categories_expression_validation():
    study = StudyDefinition(
        population=patients.all(),
        category=patients.categorised_as(
            {"A": "sex = 'F'", "B": "sex = 'M'"},
            sex=patients.sex(),
            return_expectations={
                "rate": "exponential_increase",
                "incidence": 0.2,
                "category": {"ratios": {"A": 0.3, "B": 0.6, "C": 0.1}},
                "date": {"earliest": "1900-01-01", "latest": "today"},
            },
        ),
    )
    population_size = 10000
    with pytest.raises(ValueError):
        study.make_df_from_expectations(population_size)


def test_make_df_no_categories_validation_when_no_categories_in_definition():
    study = StudyDefinition(
        population=patients.all(),
        sex=patients.sex(
            return_expectations={
                "rate": "universal",
                "category": {"ratios": {"M": 0.49, "F": 0.51}},
            }
        ),
    )
    population_size = 10000
    # Just ensuring no exception is raised
    study.make_df_from_expectations(population_size)


def test_make_df_from_expectations_with_date_filter():
    study = StudyDefinition(
        population=patients.all(),
        asthma_condition=patients.with_these_clinical_events(
            codelist(["X"], system="ctv3"),
            between=["2001-12-01", "2002-06-01"],
            returning="date",
            return_expectations={
                "rate": "exponential_increase",
                "incidence": 0.2,
                "date": {"earliest": "1900-01-01", "latest": "today"},
            },
            find_first_match_in_period=True,
            include_month=True,
            include_day=True,
        ),
    )
    population_size = 10000
    result = study.make_df_from_expectations(population_size)
    assert result.columns == ["asthma_condition"]
    assert result[~pd.isnull(result["asthma_condition"])].max()[0] <= "2002-06-01"


def test_make_df_from_expectations_returning_date_using_defaults():
    study = StudyDefinition(
        default_expectations={
            "date": {"earliest": "1900-01-01", "latest": "today"},
            "rate": "exponential_increase",
        },
        population=patients.all(),
        asthma_condition=patients.with_these_clinical_events(
            codelist(["X"], system="ctv3"),
            returning="date",
            return_expectations={"incidence": 0.2},
            find_first_match_in_period=True,
            include_month=True,
            include_day=True,
        ),
    )
    population_size = 10000
    result = study.make_df_from_expectations(population_size)
    assert result[~pd.isnull(result["asthma_condition"])].min()[0] < "1960-01-01"


def test_make_df_from_expectations_with_distribution_and_date():
    study = StudyDefinition(
        population=patients.all(),
        bmi=patients.most_recent_bmi(
            on_or_after="2010-02-01",
            minimum_age_at_measurement=16,
            include_measurement_date=True,
            include_month=True,
            return_expectations={
                "rate": "exponential_increase",
                "incidence": 0.6,
                "float": {"distribution": "normal", "mean": 35, "stddev": 10},
                "date": {"earliest": "1900-01-01", "latest": "today"},
            },
        ),
    )
    population_size = 10000
    result = study.make_df_from_expectations(population_size)
    assert list(sorted(result.columns)) == ["bmi", "bmi_date_measured"]

    # Check that the null-valued rows are aligned with each other
    assert (
        result["bmi"][pd.isnull(result["bmi"])].fillna(0)
        == result["bmi_date_measured"][pd.isnull(result["bmi_date_measured"])].fillna(0)
    ).all()


def test_make_df_from_expectations_with_mean_recorded_value():
    study = StudyDefinition(
        population=patients.all(),
        drug_x=patients.mean_recorded_value(
            codelist(["X"], system="ctv3"),
            on_most_recent_day_of_measurement=True,
            return_expectations={
                "rate": "exponential_increase",
                "incidence": 0.6,
                "float": {"distribution": "normal", "mean": 35, "stddev": 10},
            },
        ),
    )
    population_size = 10000
    result = study.make_df_from_expectations(population_size)
    assert abs(35 - int(result["drug_x"].mean())) < 5
