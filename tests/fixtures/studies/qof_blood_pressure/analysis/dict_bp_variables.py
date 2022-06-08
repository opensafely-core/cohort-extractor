# Define common variables needed across indicators here
# See https://docs.opensafely.org/study-def-tricks/

from cohortextractor import patients

from .codelists_bp import bp_codes, bp_dec_codes

# Define dictionary of variables needed for blood pressure indicator BP002:
bp002_variables = dict(
    # Denominator Rule Number 1
    # Description: Reject patients from the specified population who are
    # aged less than 45 years old.
    bp002_denominator_r1=patients.satisfying(
        """
        age >= 45
        """
    ),
    # Denominator Rule Number 2
    # NOTE: This is same as Numerator Rule Number 1
    # Description: Select patients passed to this rule who had their blood
    # pressure recorded in the 5 year period leading up to and including
    # the payment period end date.
    bp002_denominator_r2=patients.satisfying(
        """
        bp_rec_5y
        """,
        bp_rec_5y=patients.with_these_clinical_events(
            codelist=bp_codes,
            between=[
                "first_day_of_month(index_date) - 5 years",
                "last_day_of_month(index_date)",
            ],
            returning="binary_flag",
            return_expectations={"incidence": 0.5},
        ),
    ),
    # Denominator Rule Number 3
    # Description: Reject patients passed to this rule chose not to have
    # their blood pressure recorded in the 5 year period leading up to and
    # including the payment period end date.
    bp002_denominator_r3=patients.satisfying(
        """
        NOT bp_dec_5y
        """,
        bp_dec_5y=patients.with_these_clinical_events(
            between=[
                "first_day_of_month(index_date) - 5 years",
                "last_day_of_month(index_date)",
            ],
            codelist=bp_dec_codes,
            returning="binary_flag",
        ),
    ),
    # Define exclusion variable for denominator rule 3
    # to be used as numerator in measures
    bp002_excl_denominator_r3=patients.satisfying(
        """
        bp_dec_5y
        """
    ),
    # Denominator Rule Number 4
    # Description: Reject patients passed to this rule who registered with
    # the GP practice in the 3 month period leading up to and including
    # the payment period end date.
    bp002_denominator_r4=patients.satisfying(
        """
        reg_dat_3m
        """,
        # NOTE: This variable selects patients that were registered with one
        # practice in the last 3 months. Therefore, this variable (reg_dat_3m)
        # specifies the patients that need to be selected for in the
        # denominator.
        reg_dat_3m=patients.registered_with_one_practice_between(
            start_date="index_date - 3 months",
            end_date="index_date",
            return_expectations={"incidence": 0.1},
        ),
    ),
    # Define exclusion variable for denominator rule 4
    # to be used as numerator in measures
    bp002_excl_denominator_r4=patients.satisfying(
        """
        NOT reg_dat_3m
        """
    ),
    bp002_denominator=patients.satisfying(
        """
        bp002_denominator_r1 AND
            (bp002_denominator_r2 OR
                (bp002_denominator_r3 AND
                 bp002_denominator_r4)
            )
        """
    ),
    bp002_numerator=patients.satisfying(
        """
        # Numerator Rule Number 1
        # NOTE: This is same as Denominator Rule Number 2
        # Description: Select patients from the denominator who had their
        # blood pressure recorded in the 5 year period leading up to and
        # including the payment period end date. Reject the remaining patients.
        bp002_denominator AND
        bp002_denominator_r2
        """
    ),
)
