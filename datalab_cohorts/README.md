The [study_definition.py](../analysis/study_definition.py) file looks
something like this:

```py
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
```

The `codelist_from_csv` function is a stub for the API and library Peter
is developing. The `Codelist` object it returns is just a list of codes
with an additional `system` attribute.

The [generate_cohort.py](../generate_cohort.py) file just imports the
study definition object and calls `to_csv` on it.

Each keyword argument to `StudyDefinition` generates a column in the
resulting CSV. The exception is `population` which defines the list of
patient IDs which will be included in the study. Where other columns
don't have an equivalent patient ID they will be filled in with zeros.
Where other columns have additional patient IDs they will be dropped.

The various `patients.<foo>` calls are just syntactic sugar. So the
following are exactly equivalent:
```py
StudyDefinition(
    ...
    some_column=patients.with_these_clinical_events(codelist),
    ...
)
```

```py
StudyDefinition(
    ...
    some_column=("with_these_clinical_events", {"codelist": codelist}),
    ...
)
```

When the study definition is rendered to CSV each of these column
definitions results in a call to the corresponding method e.g.
```py
self.patients_with_these_clinical_events(codelist=codelist)
```

Each of these methods returns a DataFrame, indexed by patient_id, which
may have zero or one columns. A DataFrame with zero columns still has
an index which makes it essentially just a list of patient IDs. We use
these for booleans.

Finally all these DataFrames are joined together (on patient ID,
obviously) and written out to CSV.

This is a slightly roundabout way of, effectively, calling a bunch of a
methods on a class but it means we aren't tied to a one-one
correspondence between columns and backend queries. So the `age` and `sex`
columns end up making just a single "get demographics" query on the
backend which is used to populate both of them.

This "get demographics" query can (although it doesn't yet) look ahead
at the full set of defined columns before it runs so it can fetch just
the data it's going to need.
