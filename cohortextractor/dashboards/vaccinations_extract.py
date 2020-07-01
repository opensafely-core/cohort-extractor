from cohortextractor.tpp_backend import quote, codelist_to_sql


def patients_with_ages_and_practices_sql(date_of_birth_range, age_thresholds):
    """
    Retrieves patients with date of birth (rounded to start of month) plus the
    practice pseudo IDs to which they were registered in the months where they
    hit the defined age thresholds (measured in months).

    Where no corresponding registration was found 0 is returned
    """
    practice_id_columms = ",".join(map(sql_for_practice_id_at_age, age_thresholds))
    return f"""
    SELECT
      Patient.Patient_ID AS patient_id,
      {truncate_to_first_of_month("DateOfBirth")} AS date_of_birth,
      {practice_id_columms}
    FROM
      Patient
    WHERE
      DateOfBirth {in_range(date_of_birth_range)}
    ORDER BY patient_id
    """


def vaccination_events_sql(
    date_of_birth_range,
    tpp_vaccination_codelist=None,
    ctv3_codelist=None,
    snomed_codelist=None,
):
    """
    Retrieves all childhood vaccination events for patients in the defined age
    group. These are sourced from the TPP-specific vaccinations table, the
    generic clinical events table, and the prescribed medications table and
    then combined into a single list.

    Returned are the patient_id, date given, and the vaccine type, mapped to
    our own internal code name.
    """
    queries = []
    if tpp_vaccination_codelist:
        queries.append(
            vaccination_events_from_table_sql(
                "Vaccination",
                "VaccinationDate",
                "VaccinationName",
                tpp_vaccination_codelist,
                date_of_birth_range,
            ),
        )
    if ctv3_codelist:
        queries.append(
            vaccination_events_from_table_sql(
                "CodedEvent",
                "ConsultationDate",
                "CTV3Code",
                ctv3_codelist,
                date_of_birth_range,
            ),
        )
    if snomed_codelist:
        queries.append(
            vaccination_events_from_table_sql(
                "MedicationIssue",
                "ConsultationDate",
                "DMD_ID",
                snomed_codelist,
                date_of_birth_range,
                extra_join="""
                INNER JOIN MedicationDictionary
                ON MedicationIssue.MultilexDrug_ID = MedicationDictionary.MultilexDrug_ID
                """,
            ),
        )
    assert len(queries) > 0
    union_sql = "\nUNION ALL\n".join(queries)
    return f"SELECT * FROM ({union_sql}) t ORDER BY patient_id"


def vaccination_events_from_table_sql(
    table, date_column, code_column, codelist, date_of_birth_range, extra_join=""
):
    codes_sql = codelist_to_sql(codelist)
    case_expression = categorised_codelist_to_case_expression(codelist, code_column)
    return f"""
    SELECT
      Patient.Patient_ID AS patient_id,
      {case_expression} AS vaccine_name,
      CONVERT(VARCHAR(10), {date_column}, 23) AS date_given
    FROM
      Patient
    INNER JOIN
      {table}
    ON
      Patient.Patient_ID = {table}.Patient_ID
    {extra_join}
    WHERE
      DateOfBirth {in_range(date_of_birth_range)}
      AND {code_column} in ({codes_sql})
    """


def categorised_codelist_to_case_expression(codelist, column):
    assert codelist.has_categories
    by_category = {}
    for code, category in codelist:
        by_category.setdefault(category, []).append(code)
    clauses = "\n".join(
        [
            f"WHEN {column} IN ({codelist_to_sql(codes)}) THEN {quote(category)}"
            for category, codes in by_category.items()
        ]
    )
    return f"""
    CASE
    {clauses}
    END
    """


# Note that current registrations are recorded with an EndDate of 9999-12-31.
# Where registration periods overlap we use the one with the most recent start
# date. If there are several with the same start date we use the longest one
# (i.e. with the latest end date).
def sql_for_practice_id_at_age(age_in_months):
    age_in_months = int(age_in_months)
    return f"""
    ISNULL(
        (
        SELECT
          TOP 1 Organisation_ID FROM RegistrationHistory AS reg
        WHERE
          Patient.Patient_ID = reg.Patient_ID AND
          reg.StartDate <= DATEADD(month, {age_in_months}, DateOfBirth) AND
          reg.EndDate > DATEADD(month, {age_in_months}, DateOfBirth)
        ORDER BY
          reg.StartDate DESC, reg.EndDate DESC
        ),
    0) AS practice_id_at_month_{age_in_months}
    """


def in_range(date_range):
    min_date, max_date = date_range
    return f"BETWEEN {quote(min_date)} AND {quote(max_date)}"


def truncate_to_first_of_month(column):
    # Style 23 below means YYYY-MM-DD format, see:
    # https://docs.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-ver15#date-and-time-styles
    return f"CONVERT(VARCHAR(7), {column}, 23) + '-01'"
