from datalab_cohorts import StudyDefinition, patients, codelist_from_csv


cvd_meds = codelist_from_csv("mvp_data/cvd_medcodes.csv", system="snomed")
chd_codes = codelist_from_csv("mvp_data/chd_codes.csv", system="ctv3")
smoking_codes = codelist_from_csv("mvp_data/smoking_codes.csv", system="ctv3")


study = StudyDefinition(
    # This line defines the study population
    population=patients.with_positive_covid_test(),
    # The rest of the lines define the covariates
    age=patients.age_as_of("today"),
    sex=patients.sex(),
    cdv_meds=patients.with_these_medications(cvd_meds),
    chd_code=patients.with_these_clinical_events(chd_codes),
    smoking_status=patients.with_these_clinical_events(
        smoking_codes, min_date="2015-01-01", max_date="2020-03-31"
    ),
    died=patients.have_died(),
    admitted_itu=patients.admitted_to_itu(),
)
