from cohortextractor import Measure, StudyDefinition, codelist_from_csv, patients

chronic_liver_disease_codes = codelist_from_csv(
    "codelists/opensafely-chronic-liver-disease.csv", system="ctv3", column="CTV3ID"
)

study = StudyDefinition(
    index_date="2020-02-01",
    default_expectations={
        "date": {"earliest": "1900-01-01", "latest": "index_date"},
        "rate": "exponential_increase",
    },
    population=patients.registered_with_one_practice_between(
        "index_date - 1 year", "index_date"
    ),
    has_chronic_liver_disease=patients.with_these_clinical_events(
        chronic_liver_disease_codes,
        returning="binary_flag",
        return_expectations={
            "incidence": 1.0,
            "date": {"earliest": "1950-01-01", "latest": "index_date"},
        },
    ),
    stp=patients.registered_practice_as_of(
        "index_date",
        returning="stp_code",
        return_expectations={
            "rate": "universal",
            "category": {"ratios": {"STP1": 1.0}},
        },
    ),
)

measures = [
    Measure(
        id="liver_disease_by_stp",
        numerator="has_chronic_liver_disease",
        denominator="population",
        group_by="stp",
        small_number_suppression=True,
    ),
]
