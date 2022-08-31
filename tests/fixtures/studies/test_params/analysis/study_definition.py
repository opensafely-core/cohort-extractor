from cohortextractor import StudyDefinition, params, patients

age_suffix = params["age_suffix"]
sex_suffix = params["sex_suffix"]

study = StudyDefinition(
    default_expectations={"date": {"earliest": "1900-01-01", "latest": "2020-01-01"}},
    population=patients.all(),
    **{
        f"age_{age_suffix}": patients.age_as_of(
            "2020-01-01",
            return_expectations={
                "rate": "universal",
                "int": {"distribution": "population_ages"},
            },
        ),
        f"sex_{sex_suffix}": patients.sex(
            return_expectations={
                "rate": "universal",
                "category": {"ratios": {"M": 0.5, "F": 0.5}},
            }
        ),
    },
)
