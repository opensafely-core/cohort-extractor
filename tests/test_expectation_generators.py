from math import isclose, isnan

import numpy as np
import pandas as pd
import pytest

from cohortextractor import StudyDefinition, codelist, patients
from cohortextractor.expectation_generators import generate


@pytest.fixture(autouse=True)
def set_randomstate():
    """Several tests include randomness in their output. Seed the PRNG to
    make tests deterministic.

    """
    np.random.seed(1)


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
        "dtype": {"age": "Int64"},
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
            test_codelist,
            return_first_date_in_period=True,
            date_format="YYYY-MM",
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
        ),
        ethnicity_date=patients.date_of("ethnicity"),
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
        ),
        bmi_date_measured=patients.date_of("bmi", date_format="YYYY-MM"),
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
        ),
        creatinine_date=patients.date_of("creatinine", date_format="YYYY-MM"),
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
        ),
        bp_sys_date_measured=patients.date_of("bp_sys", date_format="YYYY-MM"),
    )
    result = _converters_to_names(study.pandas_csv_args)
    assert result == {
        "converters": {"bp_sys_date_measured": "add_day_to_date"},
        "dtype": {"bp_sys": "float"},
        "date_col_for": {"bp_sys": "bp_sys_date_measured"},
        "parse_dates": ["bp_sys_date_measured"],
    }


def test_data_generator_date_exponential_increase():
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


def test_data_generator_date_uniform():
    population_size = 100000
    incidence = 0.5
    return_expectations = {
        "rate": "uniform",
        "incidence": incidence,
        "date": {"earliest": "2020-01-01", "latest": "2020-01-11"},
    }
    result = generate(population_size, **return_expectations)

    # Check incidence numbers are correct
    null_rows = result[~pd.isnull(result["date"])]
    assert len(null_rows) == (population_size * incidence)

    # Check dates are distributed approximately evenly
    date_counts = result["date"].reset_index().groupby("date").count()["index"]

    expected = (population_size * incidence) / 10
    for count in date_counts:
        assert isclose(count, expected, rel_tol=0.1)


def test_data_generator_category_and_date():
    population_size = 10000
    incidence = 0.2
    return_expectations = {
        "rate": "exponential_increase",
        "incidence": incidence,
        "category": {"ratios": {"A": 0.1, "B": 0.7, "C": 0.2}},
        "date": {"earliest": "1900-01-01", "latest": "2020-01-01"},
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
        "date": {"earliest": "1900-01-01", "latest": "2020-01-01"},
        "float": {"distribution": "normal", "mean": 35, "stddev": 10},
    }
    result = generate(population_size, **return_expectations)
    nonzero_results = result[result["float"] != 0.0]
    assert abs(35 - int(nonzero_results["float"].mean())) < 5


def test_data_generator_int_normal():
    population_size = 10000
    incidence = 0.9
    return_expectations = {
        "rate": "exponential_increase",
        "incidence": incidence,
        "date": {"earliest": "1900-01-01", "latest": "2020-01-01"},
        "int": {"distribution": "normal", "mean": 10, "stddev": 1},
    }
    result = generate(population_size, **return_expectations)
    assert abs(10 - int(result["int"].mean())) < 3


def test_data_generator_int_poisson():
    population_size = 10000
    incidence = 0.9
    return_expectations = {
        "rate": "exponential_increase",
        "incidence": incidence,
        "date": {"earliest": "1900-01-01", "latest": "2020-01-01"},
        "int": {"distribution": "poisson", "mean": 5},
    }
    result = generate(population_size, **return_expectations)
    assert abs(5 - int(result["int"].mean())) < 3


def test_data_generator_bool():
    population_size = 10000
    incidence = 0.5
    return_expectations = {
        "rate": "exponential_increase",
        "incidence": incidence,
        "date": {"earliest": "1900-01-01", "latest": "2020-01-01"},
        "bool": True,
    }
    result = generate(population_size, **return_expectations)
    assert result["bool"].fillna(0).mean() == 0.5


def test_data_generator_universal_category():
    population_size = 10000
    return_expectations = {
        "rate": "universal",
        "date": {"earliest": "1900-01-01", "latest": "2020-01-01"},
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
        "date": {"earliest": "1900-01-01", "latest": "2020-01-01"},
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
        ),
    )
    population_size = 10000
    with pytest.raises(ValueError):
        study.make_df_from_expectations(population_size)


def test_make_df_from_expectations_with_categories_expression():
    study = StudyDefinition(
        population=patients.all(),
        category=patients.categorised_as(
            {"A": "sex = 'F'", "B": "sex = 'M'", "": "DEFAULT"},
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
            {"A": "sex = 'F'", "B": "sex = 'M'", "": "DEFAULT"},
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
                "date": {"earliest": "1900-01-01", "latest": "today"},
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
            date_format="YYYY-MM-DD",
        ),
    )
    population_size = 10000
    result = study.make_df_from_expectations(population_size)
    assert result.columns == ["asthma_condition"]
    assert result[~pd.isnull(result["asthma_condition"])].max()[0] <= "2002-06-01"


def test_apply_date_filters_from_definition():
    study = StudyDefinition(population=patients.all())
    series = np.arange(10)

    result = list(study.apply_date_filters_from_definition(series, between=[5, 6]))
    assert result == [5, 6]

    result = list(study.apply_date_filters_from_definition(series, between=[5, None]))
    assert result == [5, 6, 7, 8, 9]

    result = list(study.apply_date_filters_from_definition(series, between=[None, 2]))
    assert result == [0, 1, 2]


def test_make_df_from_expectations_returning_date_using_defaults():
    study = StudyDefinition(
        default_expectations={
            "date": {"earliest": "1900-01-01", "latest": "today"},
            "rate": "exponential_increase",
            "incidence": 0.2,
        },
        population=patients.all(),
        asthma_condition=patients.with_these_clinical_events(
            codelist(["X"], system="ctv3"),
            returning="date",
            find_first_match_in_period=True,
            date_format="YYYY-MM-DD",
        ),
    )
    population_size = 10000
    result = study.make_df_from_expectations(population_size)
    assert result[~pd.isnull(result["asthma_condition"])].min()[0] < "1960-01-01"


def test_column_refs_in_date_expressions_do_not_trigger_errors():
    # Further down the road we want to actually interpret these expressions and
    # generate appopriate dates, but for now we just need to not blow up when
    # we encounter them
    study = StudyDefinition(
        population=patients.all(),
        copd_exacerbation=patients.with_these_clinical_events(
            codelist(["X"], system="ctv3"),
            between=["2001-12-01", "2002-06-01"],
            returning="date",
            return_expectations={
                "rate": "exponential_increase",
                "incidence": 0.2,
                "date": {"earliest": "1990-01-01", "latest": "today"},
            },
            find_last_match_in_period=True,
            date_format="YYYY-MM-DD",
        ),
        drug_after_exacerbation=patients.with_these_medications(
            codelist(["Y"], system="snomed"),
            between=["copd_exacerbation", "copd_exacerbation + 3 months"],
            returning="date",
            return_expectations={
                "rate": "exponential_increase",
                "incidence": 0.2,
                "date": {"earliest": "1990-01-01", "latest": "today"},
            },
            find_first_match_in_period=True,
            date_format="YYYY-MM-DD",
        ),
    )
    population_size = 10000
    # Just ensure no exception is raised
    study.make_df_from_expectations(population_size)


def test_make_df_from_expectations_with_distribution_and_date():
    study = StudyDefinition(
        population=patients.all(),
        bmi=patients.most_recent_bmi(
            on_or_after="2010-02-01",
            minimum_age_at_measurement=16,
            return_expectations={
                "rate": "exponential_increase",
                "incidence": 0.6,
                "float": {"distribution": "normal", "mean": 35, "stddev": 10},
                "date": {"earliest": "1900-01-01", "latest": "today"},
            },
        ),
        bmi_date_measured=patients.date_of(
            "bmi",
            date_format="YYYY-MM",
        ),
    )
    population_size = 10000
    result = study.make_df_from_expectations(population_size)
    assert list(sorted(result.columns)) == ["bmi", "bmi_date_measured"]

    # Check that the null-valued rows are aligned with each other
    assert ((result["bmi"] == 0.0) == pd.isnull(result["bmi_date_measured"])).all()


def test_make_df_from_expectations_with_mean_recorded_value():
    study = StudyDefinition(
        population=patients.all(),
        drug_x=patients.mean_recorded_value(
            codelist(["X"], system="ctv3"),
            on_most_recent_day_of_measurement=True,
            return_expectations={
                "rate": "exponential_increase",
                "date": {"earliest": "1900-01-01", "latest": "today"},
                "incidence": 0.6,
                "float": {"distribution": "normal", "mean": 35, "stddev": 10},
            },
        ),
    )
    population_size = 10000
    result = study.make_df_from_expectations(population_size)
    nonzero_results = result[result["drug_x"] != 0.0]
    assert abs(35 - int(nonzero_results["drug_x"].mean())) < 5


def test_make_df_from_binary_default_outcome():
    study = StudyDefinition(
        population=patients.all(),
        died=patients.died_from_any_cause(
            return_expectations={
                "date": {"earliest": "1900-01-01", "latest": "today"},
                "incidence": 0.1,
            }
        ),
    )
    population_size = 10000
    result = study.make_df_from_expectations(population_size)
    assert len(result[result.died == 1]) == 0.1 * population_size


def test_make_df_from_expectations_with_number_of_episodes():
    study = StudyDefinition(
        population=patients.all(),
        episode_count=patients.with_these_clinical_events(
            codelist(["A", "B", "C"], system="ctv3"),
            ignore_days_where_these_codes_occur=codelist(["D", "E"], system="ctv3"),
            returning="number_of_episodes",
            episode_defined_as="series of events each <= 14 days apart",
            return_expectations={
                "int": {"distribution": "normal", "mean": 4, "stddev": 2},
                "date": {"earliest": "1900-01-01", "latest": "today"},
                "incidence": 0.2,
            },
        ),
    )
    population_size = 10000
    result = study.make_df_from_expectations(population_size)
    assert result.columns == ["episode_count"]


def test_make_df_from_expectations_with_satisfying():
    study = StudyDefinition(
        population=patients.all(),
        has_condition=patients.satisfying(
            "condition_a OR condition_b",
            condition_a=patients.with_these_clinical_events(
                codelist(["A", "B", "C"], system="ctv3")
            ),
            condition_b=patients.with_these_clinical_events(
                codelist(["X", "Y", "Z"], system="ctv3")
            ),
            return_expectations={
                "date": {"earliest": "2001-01-01", "latest": "2020-03-01"},
                "incidence": 0.95,
            },
        ),
    )
    population_size = 10000
    result = study.make_df_from_expectations(population_size)
    assert result.columns == ["has_condition"]


def test_make_df_from_expectations_doesnt_alter_defaults():
    study = StudyDefinition(
        default_expectations={
            "rate": "exponential_increase",
            "incidence": 1.0,
            "date": {"earliest": "1900-01-01", "latest": "today"},
            "category": {"ratios": {"M": 0.5, "F": 0.5}},
        },
        population=patients.all(),
        sex_altered=patients.sex(
            return_expectations={
                "incidence": 0.1,
                "category": {"ratios": {"M": 0.5, "F": 0.5}},
            }
        ),
        sex_default=patients.sex(
            return_expectations={"category": {"ratios": {"M": 0.5, "F": 0.5}}}
        ),
    )
    population_size = 10000
    # Just ensuring no exception is raised
    result = study.make_df_from_expectations(population_size)
    assert len(result[pd.isnull(result.sex_default)]) == 0


def test_make_df_from_expectations_doesnt_alter_date_defaults():

    study = StudyDefinition(
        default_expectations={
            "rate": "exponential_increase",
            "incidence": 1.0,
            "date": {"earliest": "1900-01-01", "latest": "today"},
            "category": {"ratios": {"M": 0.5, "F": 0.5}},
        },
        population=patients.all(),
        with_different_incidence=patients.with_these_clinical_events(
            codelist(["X"], system="ctv3"),
            returning="date",
            return_expectations={"incidence": 0.2},
            include_day=True,
        ),
        with_different_date=patients.with_these_clinical_events(
            codelist(["X"], system="ctv3"),
            returning="date",
            return_expectations={"date": {"earliest": "2015-01-01", "latest": "today"}},
            include_day=True,
        ),
        with_defaults=patients.with_these_clinical_events(
            codelist(["X"], system="ctv3"), returning="date", include_day=True
        ),
    )
    population_size = 10000
    result = study.make_df_from_expectations(population_size)

    # Regression test: make sure defaults are respected even when they've been overridden
    assert result.with_defaults.min() < "2015-01-01"
    assert len(result[pd.isnull(result.with_defaults)]) == 0


def test_validate_category_expectations():
    categorised_codelist = codelist([("X", "Y")], system="ctv3")
    categorised_codelist.has_categories = True

    category_definitions = {"A": "sex = 'F'", "B": "sex = 'M'"}
    study = StudyDefinition(population=patients.all())

    # validate against codelists
    with pytest.raises(ValueError):
        study.validate_category_expectations(
            codelist=categorised_codelist,
            return_expectations={"category": {"ratios": {"X": 1}}},
        )
    study.validate_category_expectations(
        codelist=categorised_codelist,
        return_expectations={"category": {"ratios": {"Y": 1}}},
    )

    # validate against definitions
    with pytest.raises(ValueError):
        study.validate_category_expectations(
            category_definitions=category_definitions,
            return_expectations={"category": {"ratios": {"X": 1}}},
        )
    study.validate_category_expectations(
        category_definitions=category_definitions,
        return_expectations={"category": {"ratios": {"A": 1}}},
    )

    # validate that supplied category definitions override categories
    # in codelists
    with pytest.raises(ValueError):
        study.validate_category_expectations(
            codelist=categorised_codelist,
            category_definitions=category_definitions,
            return_expectations={"category": {"ratios": {"Y": 1}}},
        )
    study.validate_category_expectations(
        codelist=categorised_codelist,
        category_definitions=category_definitions,
        return_expectations={"category": {"ratios": {"A": 1}}},
    )


def test_make_df_from_expectations_partial_default_overrides():
    study = StudyDefinition(
        default_expectations={
            "date": {"earliest": "1900-01-01", "latest": "today"},
            "rate": "exponential_increase",
            "incidence": 0.2,
        },
        population=patients.all(),
        asthma_condition=patients.with_these_clinical_events(
            codelist(["X"], system="ctv3"),
            returning="date",
            find_first_match_in_period=True,
            date_format="YYYY",
            return_expectations={"date": {"latest": "2000-01-01"}},
        ),
    )

    population_size = 10000
    result = study.make_df_from_expectations(population_size)
    assert result.asthma_condition.astype("float").max() == 2000


def test_make_df_from_expectations_with_care_home_status():
    study = StudyDefinition(
        population=patients.all(),
        is_in_care_home=patients.care_home_status_as_of(
            "2020-01-01",
            return_expectations={
                "rate": "exponential_increase",
                "incidence": 0.3,
                "date": {"earliest": "1900-01-01", "latest": "2020-01-01"},
                "bool": True,
            },
        ),
        care_home_type=patients.care_home_status_as_of(
            "2020-01-01",
            categorised_as={
                "PN": "IsPotentialCareHome AND LocationRequiresNursing='Y'",
                "PC": "IsPotentialCareHome",
                "U": "DEFAULT",
            },
            return_expectations={
                "rate": "exponential_increase",
                "incidence": 0.2,
                "category": {"ratios": {"PN": 0.1, "PC": 0.2, "U": 0.7}},
                "date": {"earliest": "1900-01-01", "latest": "today"},
            },
        ),
    )
    population_size = 10000
    result = study.make_df_from_expectations(population_size)
    value_counts = result.care_home_type.value_counts()
    assert value_counts["PN"] < value_counts["U"]


def test_make_df_from_expectations_with_deregistration_date():
    study = StudyDefinition(
        population=patients.all(),
        dereg_date=patients.date_deregistered_from_all_supported_practices(
            on_or_before="2018-02-01",
            date_format="YYYY-MM",
            return_expectations={
                "incidence": 0.1,
                "date": {"earliest": "1980-01-01", "latest": "2018-02-01"},
            },
        ),
    )
    population_size = 1000
    result = study.make_df_from_expectations(population_size)
    dates = result.dereg_date.dropna()
    assert dates.max() <= "2018-02"
    assert dates.min() >= "1980-01"


def test_make_df_from_expectations_with_aggregate_of():
    # aggregate of variables defined in their own right
    study = StudyDefinition(
        default_expectations={
            "date": {"earliest": "1900-01-01", "latest": "today"},
            "rate": "exponential_increase",
            "incidence": 0.2,
        },
        population=patients.all(),
        fixed_date=patients.fixed_value("1980-10-20"),
        date_1=patients.with_these_clinical_events(
            codelist(["X"], system="ctv3"),
            returning="date",
            date_format="YYYY-MM-DD",
        ),
        date_2=patients.with_these_clinical_events(
            codelist(["X"], system="ctv3"),
            returning="date",
            date_format="YYYY-MM-DD",
        ),
        date_min=patients.minimum_of(
            "date_1",
            "date_2",
        ),
        date_max=patients.maximum_of(
            "date_1",
            "date_2",
        ),
        date_min_fixed=patients.minimum_of(
            "date_1",
            "fixed_date",
        ),
        date_min_fixed_inline=patients.minimum_of(
            "date_1",
            "1990-05-20",
        ),
        int_1=patients.with_these_clinical_events(
            codelist(["X"], system="ctv3"),
            returning="number_of_matches_in_period",
            return_expectations={
                "int": {"distribution": "normal", "mean": 25, "stddev": 5},
                "incidence": 0.5,
            },
        ),
        int_2=patients.with_these_clinical_events(
            codelist(["X"], system="ctv3"),
            returning="number_of_matches_in_period",
            return_expectations={
                "int": {"distribution": "normal", "mean": 25, "stddev": 5},
                "incidence": 0.5,
            },
        ),
        int_min=patients.minimum_of("int_1", "int_2"),
        int_max=patients.maximum_of("int_1", "int_2"),
    )
    population_size = 10000
    result = study.make_df_from_expectations(population_size)
    assert len(result) == population_size
    for _, row in result.iterrows():
        dates = [d for d in [row["date_1"], row["date_2"]] if isinstance(d, str)]
        if dates:
            date_min = min(dates)
            date_max = max(dates)
        else:
            date_min = float("nan")
            date_max = float("nan")
        assert_nan_equal(row["date_min"], date_min)
        assert_nan_equal(row["date_max"], date_max)
        ints = [i for i in [row["int_1"], row["int_2"]] if isinstance(i, int)]
        if ints:
            int_min = min(ints)
            int_max = max(ints)
        else:
            int_min = float("nan")
            int_max = float("nan")
        assert_nan_equal(row["int_min"], int_min)
        assert_nan_equal(row["int_max"], int_max)
        assert row["date_min_fixed"] <= "1980-10-20"
        assert row["date_min_fixed_inline"] <= "1990-05-20"
        assert row["fixed_date"] == "1980-10-20"

    # aggregate of variables defined only within aggregate function
    study = StudyDefinition(
        default_expectations={
            "date": {"earliest": "1900-01-01", "latest": "today"},
            "rate": "exponential_increase",
            "incidence": 1,
        },
        # We use an expression here (never mind that it's a trivial and
        # pointless one) as that triggers a bug which we want to ensure we've
        # fixed
        population=patients.satisfying(
            "foo OR bar", foo=patients.all(), bar=patients.all()
        ),
        date_min=patients.maximum_of(
            date_1=patients.with_these_clinical_events(
                codelist(["X"], system="ctv3"),
                returning="date",
                date_format="YYYY-MM-DD",
            ),
            date_2=patients.with_these_clinical_events(
                codelist(["X"], system="ctv3"),
                returning="date",
                date_format="YYYY-MM-DD",
            ),
        ),
        date_max=patients.maximum_of(
            date_3=patients.with_these_clinical_events(
                codelist(["X"], system="ctv3"),
                returning="date",
                date_format="YYYY-MM-DD",
            ),
            date_4=patients.with_these_clinical_events(
                codelist(["X"], system="ctv3"),
                returning="date",
                date_format="YYYY-MM-DD",
            ),
        ),
        int_min=patients.minimum_of(
            int_1=patients.with_these_clinical_events(
                codelist(["X"], system="ctv3"),
                returning="number_of_matches_in_period",
                return_expectations={
                    "int": {"distribution": "normal", "mean": 25, "stddev": 5},
                    "incidence": 0.5,
                },
            ),
            int_2=patients.with_these_clinical_events(
                codelist(["X"], system="ctv3"),
                returning="number_of_matches_in_period",
                return_expectations={
                    "int": {"distribution": "normal", "mean": 25, "stddev": 5},
                    "incidence": 0.5,
                },
            ),
        ),
        int_max=patients.maximum_of(
            int_3=patients.with_these_clinical_events(
                codelist(["X"], system="ctv3"),
                returning="number_of_matches_in_period",
                return_expectations={
                    "int": {"distribution": "normal", "mean": 25, "stddev": 5},
                    "incidence": 0.5,
                },
            ),
            int_4=patients.with_these_clinical_events(
                codelist(["X"], system="ctv3"),
                returning="number_of_matches_in_period",
                return_expectations={
                    "int": {"distribution": "normal", "mean": 25, "stddev": 5},
                    "incidence": 0.5,
                },
            ),
        ),
    )
    population_size = 10000
    result = study.make_df_from_expectations(population_size)
    for _, row in result.iterrows():
        print(row)
        assert pd.notna(row["date_min"])
        assert pd.notna(row["date_max"])
        assert pd.notna(row["int_min"])
        assert pd.notna(row["int_max"])

    # aggregate of variables defined both inside and outside aggregation
    study = StudyDefinition(
        default_expectations={
            "date": {"earliest": "1900-01-01", "latest": "today"},
            "rate": "exponential_increase",
            "incidence": 0.2,
        },
        population=patients.all(),
        date_1=patients.with_these_clinical_events(
            codelist(["X"], system="ctv3"),
            returning="date",
            date_format="YYYY-MM-DD",
        ),
        date_2=patients.with_these_clinical_events(
            codelist(["X"], system="ctv3"),
            returning="date",
            date_format="YYYY-MM-DD",
        ),
        date_min=patients.minimum_of(
            "date_1",
            "date_2",
            date_3=patients.with_these_clinical_events(
                codelist(["X"], system="ctv3"),
                returning="date",
                date_format="YYYY-MM-DD",
            ),
        ),
        date_max=patients.maximum_of(
            "date_1",
            "date_2",
            date_4=patients.with_these_clinical_events(
                codelist(["X"], system="ctv3"),
                returning="date",
                date_format="YYYY-MM-DD",
            ),
        ),
        int_1=patients.with_these_clinical_events(
            codelist(["X"], system="ctv3"),
            returning="number_of_matches_in_period",
            return_expectations={
                "int": {"distribution": "normal", "mean": 25, "stddev": 5},
                "incidence": 0.5,
            },
        ),
        int_2=patients.with_these_clinical_events(
            codelist(["X"], system="ctv3"),
            returning="number_of_matches_in_period",
            return_expectations={
                "int": {"distribution": "normal", "mean": 25, "stddev": 5},
                "incidence": 0.5,
            },
        ),
        int_min=patients.minimum_of(
            "int_1",
            "int_2",
            int_3=patients.with_these_clinical_events(
                codelist(["X"], system="ctv3"),
                returning="number_of_matches_in_period",
                return_expectations={
                    "int": {"distribution": "normal", "mean": 25, "stddev": 5},
                    "incidence": 0.5,
                },
            ),
        ),
        int_max=patients.maximum_of(
            "int_1",
            "int_2",
            int_4=patients.with_these_clinical_events(
                codelist(["X"], system="ctv3"),
                returning="number_of_matches_in_period",
                return_expectations={
                    "int": {"distribution": "normal", "mean": 25, "stddev": 5},
                    "incidence": 0.5,
                },
            ),
        ),
    )
    population_size = 10000
    result = study.make_df_from_expectations(population_size)
    for _, row in result.iterrows():
        print(row)
        dates = [d for d in [row["date_1"], row["date_2"]] if isinstance(d, str)]
        if dates:
            assert row["date_min"] <= min(dates)
            assert row["date_max"] >= max(dates)
        ints = [i for i in [row["int_1"], row["int_2"]] if isinstance(i, int)]
        if ints:
            assert row["int_min"] <= min(ints)
            assert row["int_max"] >= max(ints)


def assert_nan_equal(v1, v2):
    assert (
        not isinstance(v1, str) and not isinstance(v2, str) and isnan(v1) and isnan(v2)
    ) or v1 == v2


def test_make_df_from_expectations_with_using_dates_as_categories():
    study = StudyDefinition(
        default_expectations={
            "date": {"earliest": "1900-01-01", "latest": "today"},
            "rate": "exponential_increase",
            "incidence": 0.2,
        },
        population=patients.all(),
        eligible_date=patients.categorised_as(
            {
                "2020-04-14": "age >= 80",
                "2020-06-16": "age >= 70 AND age < 80",
                "2020-08-18": "DEFAULT",
            },
            age=patients.age_as_of("2020-01-01"),
            return_expectations={
                "category": {
                    "ratios": {
                        "2020-04-14": 0.25,
                        "2020-06-16": 0.25,
                        "2020-08-18": 0.5,
                    }
                },
                "incidence": 1,
            },
        ),
    )
    population_size = 100
    result = study.make_df_from_expectations(population_size)
    assert set(result.eligible_date) == set(["2020-08-18", "2020-06-16", "2020-04-14"])


def test_make_df_from_expectations_with_covid_therapeutics():
    study = StudyDefinition(
        population=patients.all(),
        therapeutic_approved=patients.with_covid_therapeutics(
            with_these_statuses=["Approved", "Treatment Complete"],
            returning="therapeutic",
            return_expectations={
                "rate": "universal",
                "date": {"earliest": "1900-01-01", "latest": "today"},
                "category": {
                    "ratios": {
                        "Approved": 0.25,
                        "Treatment Complete": 0.25,
                        "Treatment Not Started": 0.25,
                        "Treatment Stopped": 0.25,
                    }
                },
            },
        ),
        start_date=patients.with_covid_therapeutics(
            with_these_statuses=["Approved", "Treatment Complete"],
            returning="date",
            return_expectations={
                "rate": "exponential_increase",
                "incidence": 0.2,
                "date": {"earliest": "1900-01-01", "latest": "today"},
            },
        ),
    )
    population_size = 1000
    # Just ensuring no exception is raised
    result = study.make_df_from_expectations(population_size)
    assert len(result[pd.isnull(result.therapeutic_approved)]) == 0
    assert len(result[pd.isnull(result.start_date)]) == 800
