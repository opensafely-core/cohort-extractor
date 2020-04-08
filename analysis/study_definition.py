from datalab_cohorts import StudyDefinition, patients, codelist

angina_code = codelist(["G33.."], system="ctv3")

study = StudyDefinition(
    # This line defines the study population
    population=patients.with_these_clinical_events(angina_code),
    # The rest of the lines define the covariates
    sex=patients.sex(),
)
