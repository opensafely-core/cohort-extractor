from cohortextractor import StudyDefinition, patients

CONTROLS = "output/matched_matches.csv"

study = StudyDefinition(
    index_date="2021-01-01",
    default_expectations={
        "date": {"earliest": "1900-01-01", "latest": "2021-01-01"},
        "rate": "uniform",
        "incidence": 1,
    },
    # This is how we expect `which_exist_in_file` to be used. However, `population` is
    # bypassed when generating expectations so we need some other way of testing the
    # function.
    population=patients.which_exist_in_file(CONTROLS),
    case_index_date=patients.with_value_from_file(
        CONTROLS,
        returning="case_index_date",
        returning_type="date",
    ),
    # We don't expect `which_exist_in_file` to be used like this, but you never know.
    # Doing so allows us to test the function.
    exists_in_file=patients.which_exist_in_file(CONTROLS),
    # Here, `age` is "some other covariate".
    age=patients.age_as_of(
        "index_date",
        return_expectations={
            "rate": "universal",
            "int": {"distribution": "population_ages"},
        },
    ),
    # By including the measurement date, we're following a different code path to `age`.
    bmi=patients.most_recent_bmi(
        between=["2020-01-01", "index_date"],
        minimum_age_at_measurement=18,
        include_measurement_date=True,
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {"earliest": "2010-02-01", "latest": "2022-01-27"},
            "float": {"distribution": "normal", "mean": 28, "stddev": 8},
            "incidence": 0.8,
        },
    ),
)
