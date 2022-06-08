# Study start date
# Note: This should match the start dates in project.yaml
# In QOF also: Payment Period Start Date (PPSD)
start_date = "2019-03-01"

# Study end date
# Note: This should match the end dates in project.yaml
# In QOF also: Payment Period End Date (PPED)
end_date = "2022-03-01"

# demographic variables by which code use is broken down
demographic_breakdowns = [
    "age_band",
    "sex",
    "region",
    "care_home",
    "learning_disability",
    "imd",
    "ethnicity",
]

bp002_exclusions = [
    "bp002_excl_denominator_r3",
    "bp002_excl_denominator_r4",
]
