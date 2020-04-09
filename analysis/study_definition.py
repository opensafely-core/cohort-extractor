from datalab_cohorts import StudyDefinition, patients, codelist_from_csv

chronic_cardiac_disease_codes = codelist_from_csv(
    "codelists/chronic_cardiac_disease.csv", system="ctv3", column="CTV3ID"
)
chronic_liver_disease_codes = codelist_from_csv(
    "codelists/chronic_liver_disease.csv", system="ctv3", column="CTV3ID"
)

study = StudyDefinition(
    # This line defines the study population
    population=patients.registered_with_one_practice_between(
        "2019-02-01", "2020-02-01"
    ),
    # The rest of the lines define the covariates with associated GitHub issues
    # https://github.com/ebmdatalab/tpp-sql-notebook/issues/33
    age=patients.age_as_of("2020-02-01"),
    # https://github.com/ebmdatalab/tpp-sql-notebook/issues/46
    sex=patients.sex(),
    # https://github.com/ebmdatalab/tpp-sql-notebook/issues/7
    chronic_cardiac_disease=patients.with_these_clinical_events(
        chronic_cardiac_disease_codes,
        return_first_date_in_period=True,
        include_month=True,
    ),
    # https://github.com/ebmdatalab/tpp-sql-notebook/issues/12
    chronic_liver_disease=patients.with_these_clinical_events(
        chronic_liver_disease_codes,
        return_first_date_in_period=True,
        include_month=True,
    ),
    # https://github.com/ebmdatalab/tpp-sql-notebook/issues/10
    bmi=patients.most_recent_bmi(
        on_or_after="2010-02-01",
        minimum_age_at_measurement=16,
        include_measurement_date=True,
        include_month=True,
    ),
)
