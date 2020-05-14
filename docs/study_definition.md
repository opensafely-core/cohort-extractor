## with_tpp_vaccination_record

This is TPP-specfic, so the method name reflects that; it will not
work against other backends.

An example query might be:

```py
recent_flu_vaccine = patients.with_tpp_vaccination_record(
    target_disease_matches="INFLUENZA",
    on_or_after="2018-01-01",
    find_last_match_in_period=True,
    returning="date",
)
```

or

```py
recent_flu_vaccine = patients.with_tpp_vaccination_record(
    product_name_matches=["Optaflu", "Madeva"],
    on_or_after="2018-01-01",
    find_last_match_in_period=True,
    returning="date",
)
```

Apart from the standard arguments this function takes two optional query
parameters: `target_disease_matches` and `product_name_matches`.

`target_disease_matches` returns all vaccinations that target a
particular disease/pathogen, bearing in mind that a single product
(e.g.  MMR) can target multiple diseases. The values this takes are
all-caps strings drawn from TPP's internal list and should be checked
against the contents of the *live* (not dummy) `VaccinationReference`
table during development.

`product_name_matches` matches against the product name TPP use which,
again, should be checked against the `VaccinationReference` table.

Both arguments can either take either a single string or a list of
strings, in which case it returns results matching _any_ of the items in
the list.
