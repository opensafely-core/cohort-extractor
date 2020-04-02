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

Finally all these DataFrames are joined together and written out to CSV.

The "population" column is the only special column. The patient IDs in
the output will be exactly the patients IDs in this column. Where other
columns don't have an equivalent patient ID they will be filled in with
zeros. Any additional patient IDs in other columns will be dropped.
