"""
This module provides the methods for making a study definition

These methods don't *do* anything; they just return their name and arguments.
This provides a friendlier API than having to build some big nested data
structure by hand and means we can make use of autocomplete, docstrings etc to
make it a bit more discoverable.
"""

# Yes this clashes with the builtin, but we don't need the builtin in this
# context


def all():
    return "all", locals()


def random_sample(percent=None, return_expectations=None):
    """
    Flags a random sample of approximately `percent` patients.

    Args:
        percent: an integer between 1 and 100 for the percent of patients to include within the random sample
        return_expectations: a dict containing an expectations definition defining at least an `incidence`

    Returns:
        list: of integers of `1` or `0`

    Example:
        This creates a variable `example`, flagging approximately 10% of the population with the value `1`:

            example=patients.random_sample(percent=10, expectations={'incidence': 0.1})

    """
    return "random_sample", locals()


def sex(return_expectations=None):
    """
    Returns the sex of the patient.

    Args:
         return_expectations: a dict containing an expectation definition defining a rate and a ratio for sexes

    Returns:
        list: `"M"` male, `"F"` female, `"I"` intersex, or `"U"` unknown.

    Example:
        This creates a variable 'sex' with all patients returning a sex of either "M", "F" or ""

            sex=patients.sex(
                return_expectations={
                    "rate": "universal",
                    "category": {"ratios": {"M": 0.49, "F": 0.51}},
                }
            )

    """
    return "sex", locals()


def age_as_of(
    reference_date,
    # Required keyword
    return_expectations=None,
):
    """
    Returns the patient's age, in whole years, as at `reference_date`.
    Note that the patient's date of birth is rounded down to the first of the month,
    and age is derived from this rounded date.

    Age can be negative if a patient's date of birth is after the `reference_date`.

    Args:
        reference_date: date of interest as a string with the format `YYYY-MM-DD`
        return_expectations: a dict defining an expectation definition that includes at least a rate
            and a distribution. If `distribution` is defined as "population_ages" it returns likely distribution
            based on known UK age bands in 2018 (see file: "uk_population_bands_2018.csv")

    Returns:
        list: ages as integers

    Example:
        This creates a variable "age" with all patient returning an age as an integer:

            age=patients.age_as_of(
                "2020-02-01",
                return_expectations={
                    "rate" : "universal",
                    "int" : {"distribution" : "population_ages"}
                }
            )

    """
    return "age_as_of", locals()


def date_of_birth(
    date_format=None,
    # Required keyword
    return_expectations=None,
):
    """
    Returns date of birth as a string with format "YYYY-MM".

    Args:
        date_format: a string detailing the format of the dates for date of birth to be returned.
            It can be "YYYY-MM" or "YYYY" and wherever possible the least disclosive data should be
            returned. i.e returning only year is less disclosive than a date with month and year.
        return_expectations: a dictionary containing an expectation definition defining a rate and a distribution

    Returns:
        list: dates as strings with "YYYY-MM" format

    Raises:
        ValueError: if Date of Birth is attempted to be returned with a `YYYY-MM-DD` format.

    Example:

        This creates a variable `dob` with all patient returning a year and month as a string:

            dob=patients.date_of_birth(
                "YYYY-MM",
                return_expectations={
                    "date": {"earliest": "1950-01-01", "latest": "today"},
                    "rate": "uniform",
                }
            )
    """

    # The actual enforcement of this information governance rule is done in the
    # database; this is just to give early warning to the user
    if date_format == "YYYY-MM-DD":
        raise ValueError("Date of birth can only be retrieved to month granularity")

    return "date_of_birth", locals()


def registered_as_of(
    reference_date,
    # Required keyword
    return_expectations=None,
):
    """
    All patients registered on the given date. Note this function passes arguments
    to registered_with_one_practice_between()

    Args:
        reference_date: date of interest as a string with the format `YYYY-MM-DD`. Filters results to
            patients registered at a practice on the given date.
        return_expectations: a dictionary containing an expectation definition defining an `incidence`
            between `0` and `1`.

    Returns:
        list: of integers of `1` or `0`.

    Example:

        This creates a variable "registered" with patient returning an integer of `1` if patient registered
        at date. Patients who are not registered return an integer of `0`:

            registered=patients.registered_as_of(
                "2020-03-01",
                return_expectations={"incidence": 0.98}
            )

    """
    return "registered_as_of", locals()


def registered_with_one_practice_between(
    start_date,
    end_date,
    # Required keyword
    return_expectations=None,
):
    """
    All patients registered with the same practice through the given period.

    Note, this function does not return all patients registered with the same practice through
    the given time period when this practice changes its EHR provider. ß
    To capture this information, please use `with_complete_gp_consultation_history_between()`

    Args:
        start_date: start date of interest of period as a string with the format `YYYY-MM-DD`.
            Together with end date, this filters results to patients registered at a practice between two dates
        end_date: end date of interest of period as a string with the format `YYYY-MM-DD`.
            Together with start date, this filters results to patients registered at a practice between two dates
        return_expectations: a dictionary containing an expectation definition defining an `incidence`
            between `0` and `1`.

    Returns:
        list: of integers of `1` or `0`.

    Example:

        This creates a variable `registered_one` with patient returning an integer of `1` if patient registered
        at one practice between two dates. Patients who are not registered return an integer of `0`.

            registered_one=patients.registered_with_one_practice_between(
                start_date="2020-03-01",
                end_date="2020-06-01",
                return_expectations={"incidence": 0.90}
            )
    """
    return "registered_with_one_practice_between", locals()


def with_complete_history_between(
    start_date,
    end_date,
    # Required keyword
    return_expectations=None,
):
    """
    All patients for which we have a full set of records between the given
    dates

    Args:
        start_date: start date of interest of period as a string with the format `YYYY-MM-DD`.
            Together with end date, this filters results to patients registered at a practice between two dates
            who have a complete history.
        end_date: end date of interest of period as a string with the format `YYYY-MM-DD`.
            Together with start date, this filters results to patients registered at a practice between two dates
            who have a complete history.
        return_expectations: a dictionary containing an expectation definition defining an `incidence`
            between `0` and `1`.

    Returns:
        list: of integers of `1` or `0`

    Example:

        This creates a variable `has_consultation_history` with patient returning an integer of `1` if
        patient registered at one practice between two dates and has a completed record. Patients who are
        not registered with a complete record return an integer of `0`.

            has_consultation_history=patients.with_complete_gp_consultation_history_between(
                start_date="2019-02-01",
                end_date="2020-01-31",
                return_expectations={"incidence": 0.9},
            )
    """
    return "with_complete_history_between", locals()


def most_recent_bmi(
    # Set date limits
    on_or_before=None,
    on_or_after=None,
    between=None,
    minimum_age_at_measurement=16,
    # Required keyword
    return_expectations=None,
    # Add an additional column indicating when measurement was taken
    include_measurement_date=False,
    date_format=None,
    # If we're returning a date, how granular should it be?
    include_month=False,
    include_day=False,
):
    """
    Return patients' most recent BMI (in the defined period) either
    computed from weight and height measurements or, where they are not
    availble, from recorded BMI values. Measurements taken when a patient
    was below the minimum age are ignored. The height measurement can be
    taken before (but not after) the defined period as long as the patient
    was over the minimum age at the time.

    The date of the measurement can be obtained using `date_of("<bmi-column-name>")`.
    If the BMI is computed from weight and height then we use the date of the
    weight measurement for this.

    Args:
        on_or_before: date of interest as a string with the format `YYYY-MM-DD`. Filters results to measurements
            on or before the given date.
        on_or_after: date of interest as a string with the format `YYYY-MM-DD`. Filters results to measurements
            on or after the given date.
        between: two dates of interest as a list with each date as a string with the format `YYYY-MM-DD`.
            Filters results to measurements between the two dates provided (inclusive).
            The two dates must be in chronological order.
        minimum_age_at_measurement: Measurements taken before this age will not count towards BMI
            calculations. It is an integer.
        return_expectations: a dictionary defining the incidence and distribution of expected BMI
            within the population in question. This is a 3-item key-value dictionary of "date" and "float".
            "date" is dictionary itself and should contain the `earliest` and `latest` dates needed in the
            dummy data. `float` is a dictionary of `distribution`, `mean`, and `stddev`. These values determine
            the shape of the dummy data returned, and the float means a float will be returned rather than an
            integer. `incidence` must have a value and this is what percentage of dummy patients have
            a BMI. It needs to be a number between 0 and 1.
        include_measurement_date: a boolean indicating if an extra column, named `date_of_bmi`,
            should be included in the output.
        date_format: a string detailing the format of the dates to be returned. It can be `YYYY-MM-DD`,
            `YYYY-MM` or `YYYY` and wherever possible the least disclosive data should be returned. i.e returning
            only year is less disclosive than a date with day, month and year. Only used if
            include_measurement_date is `True`
        include_month: a boolean indicating if month should be included in addition to year (deprecated: use
            `date_format` instead).
        include_day: a boolean indicating if day should be included in addition to year and
            month (deprecated: use `date_format` instead).

    Returns:
        float: most recent BMI


    Example:

        This creates a variable "bmi" returning a float of the most recent bmi calculated from recorded
        height and weight, or from a recorded bmi record. Patient who do not have this information
        available do not return a value:

            bmi=patients.most_recent_bmi(
                between=["2010-02-01", "2020-01-31"],
                minimum_age_at_measurement=18,
                include_measurement_date=True,
                date_format="YYYY-MM",
                return_expectations={
                    "date": {"earliest": "2010-02-01", "latest": "2020-01-31"},
                    "float": {"distribution": "normal", "mean": 28, "stddev": 8},
                    "incidence": 0.80,
                }
            )
    """
    return "most_recent_bmi", locals()


def mean_recorded_value(
    codelist,
    on_most_recent_day_of_measurement=None,
    # Required keyword
    return_expectations=None,
    # Set date limits
    on_or_before=None,
    on_or_after=None,
    between=None,
    # Add additional columns indicating when measurement was taken
    include_measurement_date=False,
    date_format=None,
    # Deprecated options kept for now for backwards compatibility
    include_month=False,
    include_day=False,
):
    """
    Return patients' mean recorded value of a numerical value as defined by
    a codelist within the specified period. Optionally, limit to recordings taken on the
    most recent day of measurement only.  This is important as it allows
    us to account for multiple measurements taken on one day.

    The date of the most recent measurement can be included by flagging with date format options.

    Args:
        codelist: a codelist for requested value
        on_most_recent_day_of_measurement: boolean flag for requesting measurements be on most recent date
        return_expectations: a dictionary defining the incidence and distribution of expected value
            within the population in question. This is a 3-item key-value dictionary of "date" and "float".
            "date" is dictionary itself and should contain the `earliest` and `latest` dates needed in the
            dummy data. `float` is a dictionary of `distribution`, `mean`, and `stddev`. These values determine
            the shape of the dummy data returned, and the float means a float will be returned rather than an
            integer. `incidence` must have a value and this is what percentage of dummy patients have
            a value. It needs to be a number between 0 and 1.
        on_or_before: date of interest as a string with the format `YYYY-MM-DD`. Filters results to measurements
            on or before the given date.
        on_or_after: date of interest as a string with the format `YYYY-MM-DD`. Filters results to measurements
            on or after the given date.
        between: two dates of interest as a list with each date as a string with the format `YYYY-MM-DD`.
            Filters results to measurements between the two dates provided (inclusive).
            The two dates must be in chronological order.
        include_measurement_date: a boolean indicating if an extra column, named `<variable_name>_date_measured`,
            should be included in the output.  This option can only be True when `on_most_recent_day_of_measurement`
            is `True` (i.e. the value returned is the mean of measurements on a single day).
        date_format: a string detailing the format of the dates to be returned. It can be `YYYY-MM-DD`,
            `YYYY-MM` or `YYYY` and wherever possible the least disclosive data should be returned. i.e returning
            only year is less disclosive than a date with day, month and year. Only used if
            include_measurement_date is `True`.
        include_month: a boolean indicating if day should be included in addition to year (deprecated: use
            `date_format` instead).
        include_day: a boolean indicating if day should be included in addition to year and
            month (deprecated: use `date_format` instead).

    Returns:
        float: mean of value

    Example:

        This creates a variable `bp_sys` returning a float of the most recent systolic blood pressure from
        the record within the time period. In the event of repeated measurements on the same day, these
        are averaged. Patient who do not have this information
        available do not return a value.  The date of measurement is returned as `bp_sys_date_measured`, in YYYY-MM format:

            bp_sys=patients.mean_recorded_value(
                systolic_blood_pressure_codes,
                on_most_recent_day_of_measurement=True,
                between=["2017-02-01", "2020-01-31"],
                include_measurement_date=True,
                date_format="YYYY-MM",
                return_expectations={
                    "float": {"distribution": "normal", "mean": 80, "stddev": 10},
                    "date": {"earliest": "2019-02-01", "latest": "2020-01-31"},
                    "incidence": 0.95,
                },
            )

        Alternatively, the date of measurement can be defined as a separate variable, using `date_of`:

            date_of_bp_sys=patients.date_of("bp_sys", date_format="YYYY-MM")

        This creates a variable returning a float of the mean recorded creatinine level
        over a 6 month period:

            creatinine=patients.mean_recorded_value(
                creatinine_codes,
                on_most_recent_day_of_measurement=False,
                between=["2019-09-16", "2020-03-15"],
                return_expectations={
                    "float": {"distribution": "normal", "mean": 150, "stddev": 200},
                    "date": {"earliest": "2019-09-16", "latest": "2020-03-15"},
                    "incidence": 0.75,
                },
            )
    """

    return "mean_recorded_value", locals()


def min_recorded_value(
    codelist,
    on_most_recent_day_of_measurement=None,
    # Required keyword
    return_expectations=None,
    # Set date limits
    on_or_before=None,
    on_or_after=None,
    between=None,
    # Add additional columns indicating when measurement was taken
    include_measurement_date=False,
    date_format=None,
):
    """
    Return patients' minimum recorded value of a numerical value as defined by
    a codelist within the specified period. Optionally, limit to recordings taken on the
    most recent day of measurement only.  This is important as it allows
    us to account for multiple measurements taken on one day.

    The date of the most recent measurement can be included by flagging with date format options.

    Args:
        codelist: a codelist for requested value
        on_most_recent_day_of_measurement: boolean flag for requesting measurements be on most recent date
        return_expectations: a dictionary defining the incidence and distribution of expected value
            within the population in question. This is a 3-item key-value dictionary of "date" and "float".
            "date" is dictionary itself and should contain the `earliest` and `latest` dates needed in the
            dummy data. `float` is a dictionary of `distribution`, `mean`, and `stddev`. These values determine
            the shape of the dummy data returned, and the float means a float will be returned rather than an
            integer. `incidence` must have a value and this is what percentage of dummy patients have
            a value. It needs to be a number between 0 and 1.
        on_or_before: date of interest as a string with the format `YYYY-MM-DD`. Filters results to measurements
            on or before the given date.
        on_or_after: date of interest as a string with the format `YYYY-MM-DD`. Filters results to measurements
            on or after the given date.
        between: two dates of interest as a list with each date as a string with the format `YYYY-MM-DD`.
            Filters results to measurements between the two dates provided (inclusive).
            The two dates must be in chronological order.
        include_measurement_date: a boolean indicating if an extra column, named `<variable_name>_date_measured`,
            should be included in the output.  This option can only be True when `on_most_recent_day_of_measurement`
            is `True` (i.e. the value returned is the minimum measurement taken on a single day).
        date_format: a string detailing the format of the dates to be returned. It can be `YYYY-MM-DD`,
            `YYYY-MM` or `YYYY` and wherever possible the least disclosive data should be returned. i.e returning
            only year is less disclosive than a date with day, month and year. Only used if
            include_measurement_date is `True`.

    Returns:
        float: min of value

    Example:

        This creates a variable `min_bp_sys` returning a float of the most recent systolic blood pressure from
        the record within the time period. In the event of repeated measurements on the same day, the minimum value
        is returned. Patient who do not have this information
        available do not return a value.  The date of measurement is returned as `min_bp_sys_date_measured`, in YYYY-MM format:

            min_bp_sys=patients.min_recorded_value(
                systolic_blood_pressure_codes,
                on_most_recent_day_of_measurement=True,
                between=["2017-02-01", "2020-01-31"],
                include_measurement_date=True,
                date_format="YYYY-MM",
                return_expectations={
                    "float": {"distribution": "normal", "mean": 80, "stddev": 10},
                    "date": {"earliest": "2019-02-01", "latest": "2020-01-31"},
                    "incidence": 0.95,
                },
            )

        Alternatively, the date of measurement can be defined as a separate variable, using `date_of`:

            date_of_min_bp=patients.date_of("min_bp_sys", date_format="YYYY-MM")

        This creates a variable returning a float of the minimum recorded creatinine level
        over a 6 month period:

            min_creatinine=patients.min_recorded_value(
                creatinine_codes,
                on_most_recent_day_of_measurement=False,
                between=["2019-09-16", "2020-03-15"],
                return_expectations={
                    "float": {"distribution": "normal", "mean": 150, "stddev": 200},
                    "date": {"earliest": "2019-09-16", "latest": "2020-03-15"},
                    "incidence": 0.75,
                },
            )
    """

    return "min_recorded_value", locals()


def max_recorded_value(
    codelist,
    on_most_recent_day_of_measurement=None,
    # Required keyword
    return_expectations=None,
    # Set date limits
    on_or_before=None,
    on_or_after=None,
    between=None,
    # Add additional columns indicating when measurement was taken
    include_measurement_date=False,
    date_format=None,
):
    """
    Return patients' maximum recorded value of a numerical value as defined by
    a codelist within the specified period. Optionally, limit to recordings taken on the
    most recent day of measurement only.  This is important as it allows
    us to account for multiple measurements taken on one day.

    The date of the most recent measurement can be included by flagging with date format options.

    Args:
        codelist: a codelist for requested value
        on_most_recent_day_of_measurement: boolean flag for requesting measurements be on most recent date
        return_expectations: a dictionary defining the incidence and distribution of expected value
            within the population in question. This is a 3-item key-value dictionary of "date" and "float".
            "date" is dictionary itself and should contain the `earliest` and `latest` dates needed in the
            dummy data. `float` is a dictionary of `distribution`, `mean`, and `stddev`. These values determine
            the shape of the dummy data returned, and the float means a float will be returned rather than an
            integer. `incidence` must have a value and this is what percentage of dummy patients have
            a value. It needs to be a number between 0 and 1.
        on_or_before: date of interest as a string with the format `YYYY-MM-DD`. Filters results to measurements
            on or before the given date.
        on_or_after: date of interest as a string with the format `YYYY-MM-DD`. Filters results to measurements
            on or after the given date.
        between: two dates of interest as a list with each date as a string with the format `YYYY-MM-DD`.
            Filters results to measurements between the two dates provided (inclusive).
            The two dates must be in chronological order.
        include_measurement_date: a boolean indicating if an extra column, named `<variable_name>_date_measured`,
            should be included in the output.  This option can only be True when `on_most_recent_day_of_measurement`
            is `True` (i.e. the value returned is the minimum measurement taken on a single day).
        date_format: a string detailing the format of the dates to be returned. It can be `YYYY-MM-DD`,
            `YYYY-MM` or `YYYY` and wherever possible the least disclosive data should be returned. i.e returning
            only year is less disclosive than a date with day, month and year. Only used if
            include_measurement_date is `True`.

    Returns:
        float: max of value

    Example:

        This creates a variable `max_bp_sys` returning a float of the most recent systolic blood pressure from
        the record within the time period. In the event of repeated measurements on the same day, the maximum
        value is returned. Patient who do not have this information
        available do not return a value.  The date of measurement is returned as `bp_sys_date_measured`, in YYYY-MM format:

            max_bp_sys=patients.max_recorded_value(
                systolic_blood_pressure_codes,
                on_most_recent_day_of_measurement=True,
                between=["2017-02-01", "2020-01-31"],
                include_measurement_date=True,
                date_format="YYYY-MM",
                return_expectations={
                    "float": {"distribution": "normal", "mean": 80, "stddev": 10},
                    "date": {"earliest": "2019-02-01", "latest": "2020-01-31"},
                    "incidence": 0.95,
                },
            )

        Alternatively, the date of measurement can be defined as a separate variable, using `date_of`:

            date_of_max_bp=patients.date_of("max_bp_sys", date_format="YYYY-MM")

        This creates a variable returning a float of the maximum recorded creatinine level
        over a 6 month period:

            creatinine=patients.max_recorded_value(
                creatinine_codes,
                on_most_recent_day_of_measurement=False,
                between=["2019-09-16", "2020-03-15"],
                return_expectations={
                    "float": {"distribution": "normal", "mean": 150, "stddev": 200},
                    "date": {"earliest": "2019-09-16", "latest": "2020-03-15"},
                    "incidence": 0.75,
                },
            )
    """

    return "max_recorded_value", locals()


def with_these_medications(
    codelist,
    # Required keyword
    return_expectations=None,
    # Set date limits
    on_or_before=None,
    on_or_after=None,
    between=None,
    # Matching rule
    find_first_match_in_period=None,
    find_last_match_in_period=None,
    # Set return type
    returning="binary_flag",
    include_date_of_match=False,
    date_format=None,
    # Special (and probably temporary) arguments to support queries we need
    # to do right now. This API will need to be thought through properly at
    # some stage.
    ignore_days_where_these_clinical_codes_occur=None,
    episode_defined_as=None,
    # Deprecated options kept for now for backwards compatibility
    return_binary_flag=None,
    return_number_of_matches_in_period=False,
    return_first_date_in_period=False,
    return_last_date_in_period=False,
    include_month=False,
    include_day=False,
):
    """
    Patients who have been prescribed at least one of this list of medications
    in the defined period

    Args:
        codelist: a codelist for requested medication(s)
        return_expectations: a dictionary defining the incidence and distribution of expected value
            within the population in question. If returning an integer (returning number_of_matches_in_period,
            number_of_episodes), this is a 2-item key-value dictionary of `int` and `incidence`.
            `int` is a dictionary of `distribution`, `mean`, and `stddev`. These values determine
            the shape of the dummy data returned, and the int means a int will be returned rather than a
            float. `incidence` must have a value and this is what percentage of dummy patients have
            a value. It needs to be a number between 0 and 1. If returning `binary_flag` this is a 1-item
            dictionary of `incidence` as described above. If returning either `first_date_in_period` or
            `last_date_in_period`, this is a 2-item dictionary of `date` and `incidence`. `date` is a dict
            of `earliest` and/or `latest` date possible.
        on_or_before: date of interest as a string with the format `YYYY-MM-DD`. Filters results to on or
            before the given date.
        on_or_after: date of interest as a string with the format `YYYY-MM-DD`. Filters results to
            on or after the given date.
        between: two dates of interest as a list with each date as a string with the format `YYYY-MM-DD`.
            Filters results to between the two dates provided (inclusive). The two dates must be in chronological order.
        returning: string indicating value to be returned. Options are:

            * `binary_flag`
            * `date`
            * `number_of_matches_in_period`
            * `number_of_episodes`
            * `code`
            * `category`

        find_first_match_in_period: a boolean indicating if any returned date, code, category, or numeric value
            should be based on the first match in the period.
            If several matches compare equal, then their IDs are used to break the tie.
        find_last_match_in_period: a boolean indicating if any returned date, code, category, or numeric value
            should be based on the last match in the period. This is the default behaviour.
            If several matches compare equal, then their IDs are used to break the tie.
        include_date_of_match: a boolean indicating if an extra column should be included in the output.
        date_format: a string detailing the format of the dates to be returned. It can be `YYYY-MM-DD`,
            `YYYY-MM` or `YYYY` and wherever possible the least disclosive data should be returned. i.e returning
            only year is less disclosive than a date with day, month and year. Only used if include_date_of_match
            is `True`
        ignore_days_where_these_clinical_codes_occur: a codelist that contains codes for medications to be
            ignored. if a medication is found on this day, the date is not matched even it matches a
            code in the main `codelist`
        episode_defined_as: a string expression indicating how an episode should be defined
        return_binary_flag: a bool indicatin if a binary flag should be returned (deprecated: use `date_format` instead)
        return_number_of_matches_in_period: a boolean indicating if the number of matches in a period should be
            returned (deprecated: use `date_format` instead)
        return_first_date_in_period: a boolean indicating if the first matches in a period should be
            returned (deprecated: use `date_format` instead)
        return_last_date_in_period: a boolean indicating if the last matches in a period should be
            returned (deprecated: use `date_format` instead)
        include_month: a boolean indicating if day should be included in addition to year (deprecated: use
            `date_format` instead).
        include_day: a boolean indicating if day should be included in addition to year and
            month (deprecated: use `date_format` instead).

    Returns:
        list: of integers of `1` or `0` if `returning` argument is set to `binary_flag`, `number_of_episodes`
            or `number_of_matches_in_period`; list of strings with a date format returned if `returning`
            argument is set to `first_date_in_period` or `last_date_in_period`.

    Example:

        This creates a variable `exacerbation_count` returning an int of the number of episodes of oral
        steroids being prescribed within the time period where a prescription is counted as part of the same
        episode if it falls within 28 days of a previous prescription. Days where oral steroids
        are prescribed on the same day as a COPD review are also ignored as may not represent true exacerbations.

            exacerbation_count=patients.with_these_medications(
                oral_steroid_med_codes,
                between=["2019-03-01", "2020-02-29"],
                ignore_days_where_these_clinical_codes_occur=copd_reviews,
                returning="number_of_episodes",
                episode_defined_as="series of events each <= 28 days apart",
                return_expectations={
                    "int": {"distribution": "normal", "mean": 2, "stddev": 1},
                    "incidence": 0.2,
                },
            )
    """
    return "with_these_medications", locals()


def with_these_clinical_events(
    codelist,
    # Required keyword
    return_expectations=None,
    # Set date limits
    on_or_before=None,
    on_or_after=None,
    between=None,
    # Matching rule
    find_first_match_in_period=None,
    find_last_match_in_period=None,
    # Set return type
    returning="binary_flag",
    include_date_of_match=False,
    date_format=None,
    ignore_missing_values=False,
    # Special (and probably temporary) arguments to support queries we need
    # to do right now. This API will need to be thought through properly at
    # some stage.
    ignore_days_where_these_codes_occur=None,
    episode_defined_as=None,
    # Deprecated options kept for now for backwards compatibility
    return_binary_flag=None,
    return_number_of_matches_in_period=False,
    return_first_date_in_period=False,
    return_last_date_in_period=False,
    include_month=False,
    include_day=False,
):
    """
    Patients who have had at least one of these clinical events in the defined
    period. This is used for many types of events in primary care, such as
    symptoms, test results, diagnoses, investigations, and some demographic
    and social characteristics. NB: for prescriptions and vaccinations, use
    the more specific queries available in cohort-extractor. For onward referrals,
    data is incomplete and should not be relied upon.

    Args:
        codelist: a codelist for requested event(s)
        return_expectations: a dictionary defining the incidence and distribution of expected value
            within the population in question. If returning an integer (`returning=number_of_matches_in_period`
            or `returning=number_of_episodes`), this is a 2-item key-value dictionary of `int` and `incidence`.
            `int` is a dictionary of `distribution`, `mean`, and `stddev`. These values determine
            the shape of the dummy data returned, and the int means a int will be returned rather than a
            float. `incidence` must have a value and this is what percentage of dummy patients have
            a value. It needs to be a number between 0 and 1. If returning `binary_flag` this is a 1-item
            dictionary of `incidence` as described above. If returning either `first_date_in_period` or
            `last_date_in_period`, this is a 2-item dictionary of `date` and `incidence`. `date` is a dict
            of `earliest` and/or `latest` date possible.
        on_or_before: date of interest as a string with the format `YYYY-MM-DD`. Filters results to on or
            before the given date.
        on_or_after: date of interest as a string with the format `YYYY-MM-DD`. Filters results to
            on or after the given date.
        between: two dates of interest as a list with each date as a string with the format `YYYY-MM-DD`.
            Filters results to between the two dates provided (inclusive).
            The two dates must be in chronological order.
        returning: string indicating value to be returned. Options are:

            * `binary_flag`
            * `date`
            * `number_of_matches_in_period`
            * `number_of_episodes`
            * `code`
            * `category`
            * `numeric_value` (see also [comparators](./#cohortextractor.patients.comparator_from)
               and [reference ranges](./#cohortextractor.patients.reference_range_lower_bound_from))

        find_first_match_in_period: a boolean indicating if any returned date, code, category, or numeric value
            should be based on the first match in the period.
            If several matches compare equal, then their IDs are used to break the tie.
        find_last_match_in_period: a boolean indicating if any returned date, code, category, or numeric value
            should be based on the last match in the period. This is the default behaviour.
            If several matches compare equal, then their IDs are used to break the tie.
        include_date_of_match: a boolean indicating if an extra column should be included in the output.
        date_format: a string detailing the format of the dates to be returned. It can be `YYYY-MM-DD`,
            `YYYY-MM` or `YYYY` and wherever possible the least disclosive data should be returned. i.e returning
            only year is less disclosive than a date with day, month and year. Only used if include_date_of_match
            is `True`
        ignore_days_where_these_codes_occur: a codelist that contains codes for events to be
            ignored. if a events is found on this day, the date is not matched even it matches a
            code in the main `codelist`
        episode_defined_as: a string expression indicating how an episode should be defined
        ignore_missing_values: ignore events where the value is missing or zero.  We are
            unable to distinguish between zeros and null values due to limitations in
            how the data is recorded in TPP.
        return_binary_flag: a boolean indicating if the number of matches in a period should be
            returned (deprecated: use `date_format` instead),
        return_number_of_matches_in_period: a boolean indicating if the number of matches in a period should be
            returned (deprecated: use `date_format` instead)
        return_first_date_in_period: a boolean indicating if the first matches in a period should be
            returned (deprecated: use `date_format` instead)
        return_last_date_in_period: a boolean indicating if the last matches in a period should be
            returned (deprecated: use `date_format` instead)
        include_month: a boolean indicating if day should be included in addition to year (deprecated: use
            `date_format` instead).
        include_day: a boolean indicating if day should be included in addition to year and
            month (deprecated: use `date_format` instead).

    Returns:
        list: of integers of `1` or `0` if `returning` argument is set to `binary_flag`, `number_of_episodes`
            or `number_of_matches_in_period`; list of strings with a date format returned if `returning`
            argument is set to `first_date_in_period` or `last_date_in_period`. a list of strings with a category
            represented in an extra column in the codelist object `category` is returned.

    Example:

        This creates a variable `haem_cancer` returning the first date of a diagnosis of haematology
        malignancy within the time period.

            haem_cancer=patients.with_these_clinical_events(
                haem_cancer_codes,
                between=["2015-03-01", "2020-02-29"],
                returning="date",
                find_first_match_in_period=True,
                return_expectations={"date": {earliest; "2015-03-01", "latest": "2020-02-29"}},
            )
    """
    return "with_these_clinical_events", locals()


def comparator_from(
    source,
    return_expectations=None,
):
    """
    Fetch the comparator (`<`, `>=`, `=` etc) associated with a numeric value.

    Where a lab result is returned as e.g. `<9.5` the numeric_value component
    will contain only the value 9.5 and you will need to use this function to
    fetch the comparator into a separate column.

    Args:
        source: name of a numeric value column i.e. a column that uses
            `with_these_clinical_events(returning="numeric_value")`

    Returns:
        list: of strings from the set: `~`, `=`, `>=`, `>`, `<`, `<=`

    Example:

        Fetch each patient's latest HbA1c and the associated comparator:

            latest_hba1c=patients.with_these_clinical_events(
                hba1c_codes,
                returning="numeric_value", find_last_match_in_period=True
            ),
            hba1c_comparator=patients.comparator_from("latest_hba1c"),
    """
    returning = "comparator"
    return "value_from", locals()


def reference_range_lower_bound_from(
    source,
    return_expectations=None,
):
    """
    Fetch the lower bound of the reference range associated with the numeric
    value from a lab result.

    Args:
        source: name of a numeric value column i.e. a column that uses
            `with_these_clinical_events(returning="numeric_value")`

    Returns:
        list: of floats (note a value of `-1` indicates "no lower bound")

    Example:

        Fetch each patient's latest HbA1c and the lower bound of the associated
        reference range:

            latest_hba1c=patients.with_these_clinical_events(
                hba1c_codes,
                returning="numeric_value", find_last_match_in_period=True
            ),
            hba1c_ref_range_lower=patients.reference_range_lower_bound_from(
                "latest_hba1c"
            ),
    """
    returning = "lower_bound"
    return "value_from", locals()


def reference_range_upper_bound_from(
    source,
    return_expectations=None,
):
    """
    Fetch the upper bound of the reference range associated with the numeric
    value from a lab result.

    Args:
        source: name of a numeric value column i.e. a column that uses
            `with_these_clinical_events(returning="numeric_value")`

    Returns:
        list: of floats (note a value of `-1` indicates "no upper bound")

    Example:

        Fetch each patient's latest HbA1c and the upper bound of the associated
        reference range:

            latest_hba1c=patients.with_these_clinical_events(
                hba1c_codes,
                returning="numeric_value", find_last_match_in_period=True
            ),
            hba1c_ref_range_upper=patients.reference_range_upper_bound_from(
                "latest_hba1c"
            ),
    """
    returning = "upper_bound"
    return "value_from", locals()


def categorised_as(category_definitions, return_expectations=None, **extra_columns):
    """
    Categorises patients using a set of conditions. Patient's are assigned to the first
    condition that they satisfy. Similar to the `CASE WHEN` function in SQL.

    Args:
        category_definitions: a dict that defines the condition for each category.
            The keys of the dict are strings representing categories. The values are expressions of logic
            defining the categories. The variables used in the expressions can be variables defined elsewhere
            in the study definition, or internal variables that are defined as separate arguments within the
            `categorised_as` call and then discarded. `"DEFAULT"` is a special condition that catches patients
            who do not match any condition, and must be specified.
        return_expectations: A dict that defined the ratios of each category. The keys are the category values
            as strings and the values are ratios as floats. The ratios should add up to 1.

    Returns:
        list: of strings which each letter representing a category as defined by the algorithm. If the categories
            are formatted as `"yyyy-mm-dd"`, they will be interpreted as dates and can be used as dates elsewhere
            in the study definition.

    Example:

        This creates a variable of asthma status based on codes for asthma and categorising for recent steroid use.

            current_asthma=patients.categorised_as(
                {
                    "1": "recent_asthma_code AND
                          prednisolone_last_year = 0"
                    "2": "recent_asthma_code AND prednisolone_last_year > 0"
                    "0": "DEFAULT"
                },
                recent_asthma_code=patients.with_these_clinical_events(
                    asthma_codes, between=["2017-02-01", "2020-01-31"],
                ),
                prednisolone_last_year=patients.with_these_medications(
                    pred_codes,
                    between=["2019-02-01", "2020-01-31"],
                    returning="number_of_matches_in_period",
                ),
                return_expectations={
                    "category":{"ratios": {"0": 0.8, "2": 0.1, "3": 0.1}}
                },
            )
    """

    return "categorised_as", locals()


def satisfying(expression, return_expectations=None, **extra_columns):
    """
    Patients who meet the criteria for one or more expressions. Used as a way of combining groups
    or making subgroups based on certain characteristics.

    Args:
        expression: a string in that links together 2 or more expressions into one statement. key variables
            for this expression can be defined under this statement or anywhere in study definition.
        return_expectations: a dictionary defining the rate of expected value
            within the population in question

    Returns:
        list: of integers, either `1` or `0`

    Example:

        This creates a study population where patients included have asthma and not copd:

            population=patients.satisfying(
                \"\"\"
                has_asthma AND NOT
                has_copd
                \"\"\",
                has_asthma=patients.with_these_clinical_events(
                    asthma_codes, between=["2017-02-28", "2020-02-29"],
                ),
                has_copd=patients.with_these_clinical_events(
                    copd_codes, between=["2017-02-28", "2020-02-29"],
                ),
            )
    """

    category_definitions = {1: expression, 0: "DEFAULT"}
    if return_expectations is None:
        return_expectations = {}
    return_expectations["category"] = {"ratios": {1: 1, 0: 0}}
    # Remove from local namespace
    del expression
    return "categorised_as", locals()


def registered_practice_as_of(
    date, returning=None, return_expectations=None  # Required keyword
):
    """
    Return patients' practice address characteristics such as STP or MSOA

    Args:
        date: date of interest as a string with the format `YYYY-MM-DD`. Filters results to the given date.
        returning: string indicating value to be returned. Options are:

            * `msoa`: Middle Layer Super Output Area codes
            * `nuts1_region_name`: 9 English regions
            * `stp_code`: Sustainability Transformation Partnerships codes
            * `pseudo_id`: Pseudonymised GP practice identifier
            * `rct__{trial_name}__{property_name}`: Properties from a Cluster
               Randomised Controlled Trial ([see below](#cluster-rcts))

        return_expectations: a dict defining the `rate` and the `categories` returned with ratios

    Returns:
        list: of strings

    Raises:
        ValueError: if unsupported `returning` argument is provided

    Example:

        This creates a variable called `region` based on practice address of the patient:

            region=patients.registered_practice_as_of(
                "2020-02-01",
                returning="nuts1_region_name",
                return_expectations={
                    "rate": "universal",
                    "category": {
                        "ratios": {
                            "North East": 0.1,
                            "North West": 0.1,
                            "Yorkshire and the Humber": 0.1,
                            "East Midlands": 0.1,
                            "West Midlands": 0.1,
                            "East of England": 0.1,
                            "London": 0.2,
                            "South East": 0.2,
                        },
                    },
                },
            )


        ##### Cluster RCTs

        Support is currently available for randomised controlled trials clustered at
        practice level (though we are also happy to add support for RCTs randomised
        at person-level).

        A series of data files supplied by the trialists will be imported into
        OpenSAFELY; this will indicate which practices are enrolled, their assignment
        to an intervention group, and any other relevant practice properties or data
        gathered as part of the RCT outside of OpenSAFELY (e.g. number of GPs/nurses,
        number of practice visits made).

        These RCT variables are only available for use by the researchers officially
        nominated by the responsible research group.

        There is special syntax for accessing this data using the `returning` argument:

            rct__{trial_name}__{property_name}

        (Note the double underscores separating `rct`, trial name and property name.)

        For example, for a trial called `germdefence` which has a property called
        `deprivation_pctile`, a variable can be created with:

            practice_deprivation_pctile=patients.registered_practice_as_of(
                "2020-01-01",
                returning="rct__germdefence__deprivation_pctile",
                return_expectations={
                    "rate": "universal",
                    "category": {
                        "ratios": {
                            "1": 0.5,
                            "2": 0.5
                        },
                    },
                },
            )

        The special property `enrolled` is a boolean indicating whether the practice
        was enrolled in the trial. It will be 1 for all intervention AND control practices
        and 0 for any practices which are not part of the trial.

        All other properties are returned as strings, exactly as supplied by the
        trialists.  For the `germdefence` trial the available properties are:

            trial_arm
            av_rooms_per_house
            deprivation_pctile
            group_mean_behaviour_mean
            group_mean_intention_mean
            hand_behav_practice_mean
            hand_intent_practice_mean
            imd_decile
            intcon
            meanage
            medianage
            minority_ethnic_total
            n_completers_hw_behav
            n_completers_ri_behav
            n_completers_ri_intent
            n_engaged_pages_viewed_mean_mean
            n_engaged_visits_mean
            n_goalsetting_completers_per_practice
            n_pages_viewed_mean
            n_times_visited_mean
            n_visits_practice
            prop_engaged_visits
            total_visit_time_mean

    The data resulting from the study definition will be at patient level as usual
    and therefore practice variables will be repeated many times for each practice,
    and should be aggregated in a later analysis step.
    """

    return "registered_practice_as_of", locals()


def address_as_of(
    date,
    returning=None,
    round_to_nearest=None,
    return_expectations=None,  # Required keyword
):
    """
    Return patients' address characteristics such as IMD as of a particular date

    Args:
        date: date of interest as a string with the format `YYYY-MM-DD`. Filters results to the given date.
        returning: string indicating value to be returned. Options are:

            * `index_of_multiple_deprivation`
            * `rural_urban_classification`
            * `msoa`

        round_to_nearest: an integer that represents how `index_of_multiple_deprivation` value are rounded.
            Only use when returning is `index_of_multiple_deprivation`
        return_expectations: a dict defining the `rate` and the `categories` returned with ratios

    Returns:
        list: of integers for `rural_urban_classification` and `index_of_multiple_deprivation`, strings
            for `msoa`.

        rural_urban_classification is encoded (in at least TPP) as:

        * 1 - Urban major conurbation
        * 2 - Urban minor conurbation
        * 3 - Urban city and town
        * 4 - Urban city and town in a sparse setting
        * 5 - Rural town and fringe
        * 6 - Rural town and fringe in a sparse setting
        * 7 - Rural village and dispersed
        * 8 - Rural village and dispersed in a sparse setting

        `index_of_multiple_deprivation` (IMD) is a ranking from 1 to 32800 (the number of LSOAs
        in England), where 1 represents most deprived.


    Raises:
        ValueError: if unsupported `returning` argument is provided

    Example:

        This creates a variable called `imd` based on patient address.

            imd=patients.address_as_of(
                "2020-02-29",
                returning="index_of_multiple_deprivation",
                round_to_nearest=100,
                return_expectations={
                    "rate": "universal",
                    "category": {"ratios": {"100": 0.1, "200": 0.2, "300": 0.7}},
                },
            )
    """
    return "address_as_of", locals()


def care_home_status_as_of(
    date,
    categorised_as=None,
    return_expectations=None,  # Required keyword
):
    """
    TPP have attempted to match patient addresses to care homes as stored in
    the CQC database. At its most simple this query returns a boolean
    indicating whether the patient's address (as of the supplied time) matched
    with a care home.

    It is also possible return a more complex categorisation based on
    attributes of the care homes in the CQC database, which can be freely
    downloaded here:
    https://www.cqc.org.uk/about-us/transparency/using-cqc-data

    At present the only imported fields are:
        LocationRequiresNursing
        LocationDoesNotRequireNursing

    But we can ask for more fields to be imported if needed.

    The `categorised_as` argument acts in effectively the same way as for the
    `categorised_as` function except that the only columns that can be referred
    to are those belonging to the care home table (i.e. the two nursing fields
    above) and the boolean `IsPotentialCareHome`

    Args:
        date: date of interest as a string with the format `YYYY-MM-DD`. Filters results to the given date
        categorised_as: a logic expression that applies an algorithm to specific variables to create categories
        return_expectations: a dict defining the `rate` and the `categories` returned with ratios

    Returns:
        list: of strings which each letter representing a category as defined by the algorithm

    Example:

        This creates a variable called `care_home_type` which contains a 2
        letter string which represents a type of care home environment. If the
        address is not valid, it defaults to an empty string.

            care_home_type=patients.care_home_status_as_of(
                "2020-02-01",
                categorised_as={
                    "PC":
                    \"\"\"
                      IsPotentialCareHome
                      AND LocationDoesNotRequireNursing='Y'
                      AND LocationRequiresNursing='N'
                    \"\"\",
                    "PN":
                    \"\"\"
                      IsPotentialCareHome
                      AND LocationDoesNotRequireNursing='N'
                      AND LocationRequiresNursing='Y'
                    \"\"\",
                    "PS": "IsPotentialCareHome",
                    "PR": "NOT IsPotentialCareHome",
                    "": "DEFAULT",
                },
                return_expectations={
                    "rate": "universal",
                    "category": {"ratios": {"PC": 0.05, "PN": 0.05, "PS": 0.05, "PR": 0.84, "": 0.01},},
                },
            ),
    """
    if categorised_as is None:
        categorised_as = {1: "IsPotentialCareHome", 0: "DEFAULT"}
    return "care_home_status_as_of", locals()


def admitted_to_icu(
    on_or_after=None,
    on_or_before=None,
    between=None,
    find_first_match_in_period=None,
    find_last_match_in_period=None,
    returning="binary_flag",
    date_format=None,
    # Required keyword
    return_expectations=None,
    # Deprecated options kept for now for backwards compatibility
    include_month=False,
    include_day=False,
):
    """
    Return information about being admitted to ICU.

    Args:
        on_or_before: date of interest as a string with the format `YYYY-MM-DD`. Filters results
            on or before the given date.
        on_or_after: date of interest as a string with the format `YYYY-MM-DD`. Filters results
            on or after the given date.
        between: two dates of interest as a list with each date as a string with the format `YYYY-MM-DD`.
            Filters results between the two dates provided (inclusive).
            The two dates must be in chronological order.
        find_first_match_in_period: a boolean that indicates if the data returned is first admission to icu if
            there are multiple admissions within the time period
        find_last_match_in_period: a boolean that indicates if the data returned is last admission to icu if
            there are multiple admissions within the time period
        returning: string indicating value to be returned. Options are:

            * `binary_flag`: Whether patient attended ICU
            * `date_admitted`: Date patient arrived in ICU
            * `had_respiratory_support`: Whether patient received any form of respiratory support
            * `had_basic_respiratory_support`: Whether patient received "basic" respiratory support
            * `had_advanced_respiratory_support`: Whether patient received "advanced" respiratory support

            (Note that the terms "basic" and "advanced" are derived from the underlying ICNARC data.)

        date_format: a string detailing the format of the dates to be returned. It can be `YYYY-MM-DD`,
            `YYYY-MM` or `YYYY` and wherever possible the least disclosive data should be returned. i.e returning
            only year is less disclosive than a date with day, month and year. Only used if
            `returning` is `binary_flag`
        return_expectations: a dictionary defining the incidence and distribution of expected value
            within the population in question. This is a 2-item key-value dictionary of `date` and `rate`.
        include_month: a boolean indicating if day should be included in addition to year (deprecated: use
            `date_format` instead).
        include_day: a boolean indicating if day should be included in addition to year and
            month (deprecated: use `date_format` instead).

    Returns:
        list: of integers of `1` or `0` if `returning` argument is set to `binary_flag`, `had_respiratory_support`,
        `had_basic_respiratory_support` or `had_advanced_respiratory_support`; list of strings with a date format
        returned if `returning` argument is set to `date_admitted`

    Example:

        This returns two variables &mdash; one called `icu_date_admitted` and another `had_resp_support`:

            has_resp_support=patients.admitted_to_icu(
                on_or_after="2020-02-01",
                find_first_match_in_period=True,
                returning="had_respiratory_support",
                return_expectations={
                        "date": {"earliest" : "2020-02-01"},
                        "rate" : "exponential_increase"
                },
            ),

            icu_date_admitted=patients.admitted_to_icu(
                on_or_after="2020-02-01",
                find_first_match_in_period=True,
                returning="date_admitted",
                date_format="YYYY-MM-DD",
                return_expectations={
                    "date": {"earliest" : "2020-02-01"},
                    "rate" : "exponential_increase"
               },
            ),
    """

    return "admitted_to_icu", locals()


def with_these_codes_on_death_certificate(
    codelist,
    # Set date limits
    on_or_before=None,
    on_or_after=None,
    between=None,
    # Matching rules
    match_only_underlying_cause=False,
    # Set return type
    returning="binary_flag",
    date_format=None,
    # Deprecated options kept for now for backwards compatibility
    include_month=False,
    include_day=False,
    return_expectations=None,
):
    """
    Identify patients with ONS-registered death, where cause of death
    matches the supplied icd10 codelist

    Args:
        codelist: a codelist for requested value
        on_or_before: date of interest as a string with the format `YYYY-MM-DD`. Filters results
            on or before the given date.
        on_or_after: date of interest as a string with the format `YYYY-MM-DD`. Filters results
            on or after the given date.
        between: two dates of interest as a list with each date as a string with the format `YYYY-MM-DD`.
            Filters results between the two dates provided (inclusive). The two dates must be in chronological order.
        match_only_underlying_cause: boolean for indicating if filters results to only specified cause of death.
        returning: string indicating value to be returned. Options are:

            * `date_of_death`: Date of death
            * `binary_flag`: If they died or not
            * `underlying_cause_of_death`: The icd10 code corresponding to the underlying cause of death
            * `place_of_death`: Place of death (currently only available for TPP)
              Possible values are: "Care home", "Elsewhere", "Home", "Hospice", "Hospital", "Other communal establishment"

        date_format: a string detailing the format of the dates to be returned. It can be `YYYY-MM-DD`,
            `YYYY-MM` or `YYYY` and wherever possible the least disclosive data should be returned. i.e returning
            only year is less disclosive than a date with day, month and year.
        include_month: a boolean indicating if day should be included in addition to year (deprecated: use
            `date_format` instead).
        include_day: a boolean indicating if day should be included in addition to year and
            month (deprecated: use `date_format` instead).
        return_expectations: a dictionary defining the incidence and distribution of expected value
            within the population in question.

    Returns:
        list: of integers of `1` or `0` if `returning` argument is set to `binary_flag`;
            list of strings with a date format returned if `returning` argument is set to `date_of_death`
            list of strings returned if `returning` argument is set to `underlying_cause_of_death` or `place_of_death`

    Example:

        A variable called `died_ons_covid_flag_any` is created that returns the date of death for
        any patients that have covid on their death certificate even if that is the not the underlying cause
        of death.

            died_ons_covid_flag_any=patients.with_these_codes_on_death_certificate(
                covid_codelist,
                on_or_after="2020-02-01",
                match_only_underlying_cause=False,
                return_expectations={
                    "date": {"earliest" : "2020-02-01"},
                    "rate" : "exponential_increase"
                },
            )
    """
    return "with_these_codes_on_death_certificate", locals()


def died_from_any_cause(
    # Set date limits
    on_or_before=None,
    on_or_after=None,
    between=None,
    # Set return type
    returning="binary_flag",
    date_format=None,
    # Deprecated options kept for now for backwards compatibility
    include_month=False,
    include_day=False,
    return_expectations=None,
):
    """
    Identify patients who with ONS-registered deaths

    Args:
        on_or_before: date of interest as a string with the format `YYYY-MM-DD`. Filters results
            on or before the given date.
        on_or_after: date of interest as a string with the format `YYYY-MM-DD`. Filters results
            on or after the given date.
        between: two dates of interest as a list with each date as a string with the format `YYYY-MM-DD`.
            Filters results to between the two dates provided (inclusive).
            The two dates must be in chronological order.
        returning: string indicating value to be returned. Options are:

            * `date_of_death`: Date of death
            * `binary_flag`: If they died or not
            * `underlying_cause_of_death`: The icd10 code corresponding to the underlying cause of death
            * `place_of_death`: Place of death (currently only available for TPP)
               Possible values are: "Care home", "Elsewhere", "Home", "Hospice", "Hospital", "Other communal establishment"

        date_format: a string detailing the format of the dates to be returned. It can be `YYYY-MM-DD`,
            `YYYY-MM` or `YYYY` and wherever possible the least disclosive data should be returned. i.e returning
            only year is less disclosive than a date with day, month and year.
        include_month: a boolean indicating if day should be included in addition to year (deprecated: use
            `date_format` instead).
        include_day: a boolean indicating if day should be included in addition to year and
            month (deprecated: use `date_format` instead).
        return_expectations: a dictionary defining the incidence and distribution of expected value
            within the population in question.

    Returns:
        list: of integers of `1` or `0` if `returning` argument is set to `binary_flag`;
            list of strings with a date format returned if `returning` argument is set to `date_of_death`
            list of strings returned if `returning` argument is set to `underlying_cause_of_death` or `place_of_death`

    Example:

        A variable called `died_any` is created that returns the date of death for
        any patients that have died in the time period.

            died_any=patients.died_from_any_cause(
                on_or_after="2020-02-01",
                returning="date_of_death",
                date_format="YYYY-MM-DD",
                return_expectations={
                    "date": {"earliest" : "2020-02-01"},
                    "rate" : "exponential_increase"
                },
            )

    """
    return "died_from_any_cause", locals()


def with_death_recorded_in_cpns(
    # Set date limits
    on_or_before=None,
    on_or_after=None,
    between=None,
    # Set return type
    returning="binary_flag",
    date_format=None,
    # Deprecated options kept for now for backwards compatibility
    include_month=False,
    include_day=False,
    return_expectations=None,
):
    """
    Identify patients who with death registered in CPNS dataset

    Args:
        on_or_before: date of interest as a string with the format `YYYY-MM-DD`. Filters results
            on or before the given date.
        on_or_after: date of interest as a string with the format `YYYY-MM-DD`. Filters results
            on or after the given date.
        between: two dates of interest as a list with each date as a string with the format `YYYY-MM-DD`.
            Filters results to between the two dates provided (inclusive).
            The two dates must be in chronological order.
        returning: string indicating value to be returned. Options are:

            * `date_of_death`: Date of death
            * `binary_flag`: If they died or not

        date_format: a string detailing the format of the dates to be returned. It can be `YYYY-MM-DD`,
            `YYYY-MM` or `YYYY` and wherever possible the least disclosive data should be returned. i.e returning
            only year is less disclosive than a date with day, month and year.
        include_month: a boolean indicating if day should be included in addition to year (deprecated: use
            `date_format` instead).
        include_day: a boolean indicating if day should be included in addition to year and
            month (deprecated: use `date_format` instead).
        return_expectations: a dictionary defining the incidence and distribution of expected value
            within the population in question.

    Returns:
        list: of integers of `1` or `0` if `returning` argument is set to `binary_flag`;
            list of strings with a date format returned if `returning` argument is set to `date_of_death`

    Example:

        A variable called `died_date_cpns` is created that returns the date of death for
        any patients have died in the CPNS dataset.

            died_date_cpns=patients.with_death_recorded_in_cpns(
                on_or_after="2020-02-01",
                returning="date_of_death",
                include_month=True,
                include_day=True,
                return_expectations={
                    "date": {"earliest" : "2020-02-01"},
                    "rate" : "exponential_increase"
                },
            ),
    """
    return "with_death_recorded_in_cpns", locals()


def with_death_recorded_in_primary_care(
    # Set date limits
    on_or_before=None,
    on_or_after=None,
    between=None,
    # Set return type
    returning="binary_flag",
    date_format=None,
    return_expectations=None,
):
    """
    Identify patients with a date-of-death in their primary care record.

    There is generally a lag between the death being recorded in ONS data and
    appearing in the primary care record, but the date itself is usually
    reliable when it appears. By contrast, cause of death is often not accurate
    in the primary care record so we don't make it available to query here.

    Args:
        on_or_before: date of interest as a string with the format `YYYY-MM-DD`. Filters results
            on or before the given date.
        on_or_after: date of interest as a string with the format `YYYY-MM-DD`. Filters results
            on or after the given date.
        between: two dates of interest as a list with each date as a string with the format `YYYY-MM-DD`.
            Filters results to  between the two dates provided (inclusive).
            The two dates must be in chronological order.
        returning: string indicating value to be returned. Options are:

            * `date_of_death`: Date of death
            * `binary_flag`: If they died or not

        date_format: a string detailing the format of the dates to be returned. It can be `YYYY-MM-DD`,
            `YYYY-MM` or `YYYY` and wherever possible the least disclosive data should be returned. i.e returning
            only year is less disclosive than a date with day, month and year.
        return_expectations: a dictionary defining the incidence and distribution of expected value
            within the population in question.

    Returns:
        list: of integers of `1` or `0` if `returning` argument is set to `binary_flag`;
            list of strings with a date format returned if `returning` argument is set to `date_of_death`

    Example:

        A variable called `died_date_gp` is created that returns the date of death for
        any patients have died in the GP dataset.

            died_date_gp=patients.with_death_recorded_in_primary_care(
                on_or_after="2020-02-01",
                returning="date_of_death",
                return_expectations={
                    "date": {"earliest" : "2020-02-01"},
                    "rate" : "exponential_increase"
                },
            ),
    """
    return "with_death_recorded_in_primary_care", locals()


def date_of(
    source,
    date_format=None,
    # Deprecated options kept for now for backwards compatibility
    include_month=False,
    include_day=False,
    return_expectations=None,
):
    """
    Return the date of the event associated with a value in another colum.

    Args:
        source: name of the column
        date_format: a string detailing the format of the dates to be returned. It can be `YYYY-MM-DD`,
            `YYYY-MM` or `YYYY` and wherever possible the least disclosive data should be returned. i.e returning
            only year is less disclosive than a date with day, month and year.
        return_expectations: a dictionary defining the incidence and distribution of expected value
            within the population in question.

    Example:

        Fetch each patient's latest HbA1c and the date the sample was taken:

            latest_hba1c=patients.with_these_clinical_events(
                hba1c_codes,
                returning="numeric_value", find_last_match_in_period=True
            ),
            hba1c_date=patients.date_of("latest_hba1c", date_format="YYYY-MM-DD"),
    """
    returning = "date"
    return "value_from", locals()


def with_vaccination_record(
    tpp,
    emis,
    # Set date limits
    on_or_before=None,
    on_or_after=None,
    between=None,
    # Set return type
    returning="binary_flag",
    date_format=None,
    # Matching rule
    find_first_match_in_period=None,
    find_last_match_in_period=None,
    return_expectations=None,
):
    """
    Identify patients with a vaccination record.

    Since vaccine records are stored differently in TPP and EMIS,
    different kinds of arguments are required for each backend.

    Args:
        tpp: a dictionary with one or both of the following keys:
            `target_disease_matches`: the target disease as a string
            `product_name_matches`: the product name as a string
        emis: a dictionary with one or both of the following keys:
            `procedure_codes`: a codelist of SNOMED codes indicating the vaccination procedure
            `product_codes`: a codelist of dm+d codes indicating the product used in the vaccination
        product_codes: dm+d codes indicating the product used.
        on_or_before: date of interest as a string with the format `YYYY-MM-DD`. Filters results to
            on or before the given date.
        on_or_after: date of interest as a string with the format `YYYY-MM-DD`. Filters results to
            on or after the given date.
        between: two dates of interest as a list with each date as a string with the format `YYYY-MM-DD`.
            Filters results to between the two dates provided (inclusive).
            The two dates must be in chronological order.
        returning: string indicating value to be returned. Options are:

            * `binary_flag`: indicates if they have had the vaccination or not
            * `date`: date of vaccination

        date_format: a string detailing the format of the dates to be returned. It can be `YYYY-MM-DD`,
            `YYYY-MM` or `YYYY` and wherever possible the least disclosive data should be returned. i.e returning
            only year is less disclosive than a date with day, month and year.
        find_first_match_in_period: a boolean that indicates if the data returned is first indication of vaccination
            if there are multiple matches within the time period
        find_last_match_in_period: a boolean that indicates if the data returned is last indication of vaccination
            if there are multiple matches within the time period
        return_expectations: a dictionary defining the incidence and distribution of expected value
            within the population in question.

    Returns:
        list: of integers of `1` or `0` if `returning` argument is set to `binary_flag`;
            list of strings with a date format returned if `returning` argument is set to `date`

    Example:

        Creates a variable called `has_covid_vacc` that returns the first date of
        vaccination for any patients with a recorded covid vaccine.

            has_covid_vacc=patients.with_tpp_vaccination_record(
                tpp={
                    "target_disease_matches": "SARS-2 CORONAVIRUS",
                },
                emis={
                    "procedure_codes": codelist([
                        840534001,         # Covid vaccine administered
                        1324681000000101,  # First covid vaccine administered
                        1324691000000104,  # Second covid vaccine administered
                    ], coding_system="snomedct")
                }
                returning="date",
                date_format="YYYY-MM",
                find_first_match_in_period=True,
                return_expectations={
                    date": {"earliest": "2020-12-08", "latest": "2021-02-16"}
                }
            ),

    If both `procedure_codes` and `product_codes` are provided, only patients who have
    records for both the procedure and the product are returned.  Note that sometimes a
    procedure is recorded without the product (or vice versa).
    """

    return "with_vaccination_record", locals()


def with_tpp_vaccination_record(
    target_disease_matches=None,
    product_name_matches=None,
    # Set date limits
    on_or_before=None,
    on_or_after=None,
    between=None,
    # Set return type
    returning="binary_flag",
    date_format=None,
    # Matching rule
    find_first_match_in_period=None,
    find_last_match_in_period=None,
    return_expectations=None,
):
    """
    Identify patients with a vaccination record for a target disease within the TPP vaccination record

    Vaccinations can be recorded via a Vaccination Record or via prescription of a vaccine i.e a product code.

    Args:
        target_disease_matches: the target disease as a string
        product_name_matches: the product name as a string
        on_or_before: date of interest as a string with the format `YYYY-MM-DD`. Filters results to
            on or before the given date.
        on_or_after: date of interest as a string with the format `YYYY-MM-DD`. Filters results to
            on or after the given date.
        between: two dates of interest as a list with each date as a string with the format `YYYY-MM-DD`.
            Filters results to between the two dates provided (inclusive).
            The two dates must be in chronological order.
        returning: string indicating value to be returned. Options are:

            * `binary_flag`: indicates if they have had the vaccination or not
            * `date`: date of vaccination

        date_format: a string detailing the format of the dates to be returned. It can be `YYYY-MM-DD`,
            `YYYY-MM` or `YYYY` and wherever possible the least disclosive data should be returned. i.e returning
            only year is less disclosive than a date with day, month and year.
        find_first_match_in_period: a boolean that indicates if the data returned is first indication of vaccination
            if there are multiple matches within the time period
        find_last_match_in_period: a boolean that indicates if the data returned is last indication of vaccination
            if there are multiple matches within the time period
        return_expectations: a dictionary defining the incidence and distribution of expected value
            within the population in question.

    Returns:
        list: of integers of `1` or `0` if `returning` argument is set to `binary_flag`;
            list of strings with a date format returned if `returning` argument is set to `date`

    Example:

        A variable called `flu_vaccine` is created that returns the date of vaccination for
        any patients in the GP dataset between 2 dates.

            flu_vaccine=patients.with_tpp_vaccination_record(
                target_disease_matches="influenza",
                between=["2019-09-01", "2020-04-01"],
                returning="date",
                date_format="YYYY-MM",
                find_first_match_in_period=True,
                return_expectations={
                    date": {"earliest": "2019-09-01", "latest": "2020-03-29"}
                }
            ),
    """

    return "with_tpp_vaccination_record", locals()


def with_gp_consultations(
    # Set date limits
    on_or_before=None,
    on_or_after=None,
    between=None,
    # Matching rule
    find_first_match_in_period=None,
    find_last_match_in_period=None,
    # Set return type
    returning="binary_flag",
    date_format=None,
    return_expectations=None,
):
    """
    !!! warning
        A "consultation" as returned by this function may not actually be a consultation between a health care professional and patient.

        For example, simple administrative tasks such as updating a patient's details may also cause creation of a "consultation" record.

        It is, therefore, extremely unlikely you can use this field to infer anything about real clinician-patient interactions,
        and it is even more difficult to compare activity between practices as recording behaviour can vary.
        Some EHRs even delete consultation data for a patient when they switch practice.

    These are GP-patient interactions, either in person or via phone/video
    call. The concept of a "consultation" in EHR systems is generally broader
    and might include things like updating a phone number with the
    receptionist.

    Args:
        on_or_before: date of interest as a string with the format `YYYY-MM-DD`. Filters results to
            on or before the given date.
        on_or_after: date of interest as a string with the format `YYYY-MM-DD`. Filters results to
            on or after the given date.
        between: two dates of interest as a list with each date as a string with the format `YYYY-MM-DD`.
            Filters results to between the two dates provided (inclusive). The two dates must be in chronological order.
        find_first_match_in_period: a boolean that indicates if the data returned is first event
            if there are multiple matches within the time period
        find_last_match_in_period: a boolean that indicates if the data returned is last event
            if there are multiple matches within the time period
        returning: string indicating value to be returned. Options are:

            * `binary_flag`: indicates if they have had the an event or not
            * `date`: indicates date of event and used with either find_first_match_in_period or find_last_match_in_period
            * `number_of_matches_in_period`: counts the events in the period

        date_format: a string detailing the format of the dates to be returned. It can be `YYYY-MM-DD`,
            `YYYY-MM` or `YYYY` and wherever possible the least disclosive data should be returned. i.e returning
            only year is less disclosive than a date with day, month and year.
        return_expectations: a dictionary defining the incidence and distribution of expected value
            within the population in question.

    Returns:
        list: of integers of `1` or `0` if `returning` argument is set to `binary_flag`;
            list of strings with a date format returned if `returning` argument is set to `date`; a list of
            integers if `returning` argument is set to number_of_matches_in_period

    Example:

        A variable called `gp_count` is created that counts number of GP consultation between two dates in
        2019.

            gp_count=patients.with_gp_consultations(
                between=["2019-01-01", "2020-12-31"],
                returning="number_of_matches_in_period",
                return_expectations={
                    "int": {"distribution": "normal", "mean": 6, "stddev": 3},
                    "incidence": 0.6,
                },
            )
    """
    return "with_gp_consultations", locals()


def with_complete_gp_consultation_history_between(
    start_date,
    end_date,
    # Required keyword
    return_expectations=None,
):
    """
    All patients registered with the same practice through the given period, when the practice
    used the same EHR system (for example, SystmOne) through the given period.

    Further details:
    The concept of a "consultation" in EHR systems does not map exactly
    to the GP-patient interaction we're interested in (see `with_gp_consultations()`) so there is some
    processing required on the part of the EHR vendor to produce the
    consultation record we need. This does not happen automatically as part of
    the GP2GP transfer, and therefore this query can be used to find just those
    patients for which the full history is available. This means finding patients
    who have been continuously registered with a single TPP-using practice
    throughout a time period.

    Args:
        start_date: start date of interest as a string with the format `YYYY-MM-DD`
        end_date: end date of interest as a string with the format `YYYY-MM-DD`
        return_expectations: a dictionary defining the incidence and distribution of expected value
            within the population in question.

    """
    return (
        "with_complete_gp_consultation_history_between",
        locals(),
    )


def with_test_result_in_sgss(
    pathogen=None,
    test_result="any",
    # Set date limits
    on_or_before=None,
    on_or_after=None,
    between=None,
    # Matching rule
    find_first_match_in_period=None,
    find_last_match_in_period=None,
    restrict_to_earliest_specimen_date=True,
    # Set return type
    returning="binary_flag",
    date_format=None,
    return_expectations=None,
):
    """
    Finds COVID lab test results recorded in SGSS (Second Generation
    Surveillance System).

    Please note that all dates used here are "specimen dates" (i.e. the date
    the specimen was taken), rather than the date the lab result was obtained.

    It's important to note that data is supplied in two separate datasets: an
    "Earliest Specimen" dataset and an "All Tests" dataset.

    ###  Earliest Specimen Dataset

    Where a patient has multiple positive tests, SGSS groups these into
    "episodes" (referred to as "Organism-Patient-Illness-Episodes"). Each
    pathogen has a maximum episode duration (usually 2 weeks) and unless
    positive tests are separated by longer than this period they are assumed to
    be the same episode of illness.  The specimen date recorded is the
    *earliest* positive specimen within the episode.

    For SARS-CoV-2 the episode length has been set to infinity, meaning that
    once a patient has tested positive every positive test will be part of the
    same episode and record the same specimen date.

    This means that using `find_last_match_in_period` is pointless when
    querying for positive results as only one date will ever be recorded and it
    will be the earliest.

    Our original assumption, though the documentation didn't state either way,
    is that every negative result would be treated as unique. However this does
    not appear to be the case as though some patients do have multiple negative
    tests in this dataset, the number is far too small to be realistic.

    Information about the SARS-CoV-2 episode length was via email from someone
    at the National Infection Service:

        The COVID-19 episode length in SGSS was set to indefinite, so all
        COVID-19 records from a single patient will be classified as one
        episode. This may change, but is set as it is due to limited
        information around re-infection and virus clearance.

    ### All Tests Dataset

    This dataset is not subject to the same restriction as above and we expect
    each individual test result (postive or negative) to appear in this
    regardless of whether they are considered as within the same infection
    episode. In an ideal world we could use just this dataset, but there are
    some fields we need (e.g. Case Category) which are only supplied on the
    "earliest specimen" dataset.

    ### S-Gene Target Failure

    Using the `returning="s_gene_target_failure"` option provides additional
    output from PCR tests results which can be used as a proxy for the presence
    of certain Variants of Concern.

    Possible values are "", "0", "1", "9"

    Definitions (from email from PHE)

        1: Isolate with confirmed SGTF
        Undetectable S gene; CT value (CH3) =0
        Detectable ORF1ab gene; CT value (CH2) <=30 and >0
        Detectable N gene; CT value (CH1) <=30 and >0

        0: S gene detected
        Detectable S gene (CH3>0)
        Detectable y ORF1ab CT value (CH1) <=30 and >0
        Detectable N gene CT value (CH2) <=30 and >0

        9: Cannot be classified

        Null are where the target is not S Gene. I think LFTs are currently
        also coming across as 9 so will need to review those to null as well as
        clearly this is a PCR only variable.

    ### Case Category (type of test used)

    Using the `returning="case_category"` option (only available on positive,
    earliest specimen date results) reports whether the test was a Lateral Flow
    or PCR test. Possible values are:

        "LFT_Only", "PCR_Only", "LFT_WithPCR"

    ### Variant

    The `returning="variant"` option (only available in the "All Tests" data)
    returns details on specific SARS-CoV-2 variants detected. Possible values
    include, but are not limited to:

        B.1.617.2
        VOC-21JAN-02
        VUI-21FEB-04
        P.1
        E484K
        B.1.1.7+E484K
        No VOC detected
        Sequencing Failed
        Undetermined
        Undetermined + e484k

    The `returning="variant_detection_method"` options returns possible values:

        "Reflex Assay" and "Private Lab Sequencing"

    ### Symptomatic

    The `returning="symptomatic"` option (only available in the "All Tests" data)
    returns details on whether patients are symptomatic of SARS-CoV-2 or not. This
    option is available regardless of the test result outcome.

    Possible values are "", "Y", "N".

    ### Number of Tests

    The `returning="number_of_matches_in_period"` option (only available in the "All Tests" data)
    returns a count of the number of tests a patient has had in the defined time period.

    It is used with `test_result` which must be set as "positive", "negative" or "any".
    `returning="number_of_matches_in_period"` can therefore be used to return the number of
    positive, negative or all tests.

    For more detail on SGSS in general see [PHE_Laboratory_Reporting_Guidelines.pdf][PHE_LRG]

    [PHE_LRG]: https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/739854/PHE_Laboratory_Reporting_Guidelines.pdf

    Args:
        pathogen: pathogen we are interested in. Only SARS-CoV-2 results are
            included in our data extract so this will throw an error if the
            specified pathogen is anything other than "SARS-CoV-2".
        test_result: must be one of "positive", "negative" or "any"
        on_or_before: date of interest as a string with the format
            `YYYY-MM-DD`. Filters results to on or before the given date. The
            default value is `None`.
        on_or_after: date of interest as a string with the format `YYYY-MM-DD`.
            Filters results to on or after the given date.
        between: two dates of interest as a list with each date as a string
            with the format `YYYY-MM-DD`.  Filters results to between the two
            dates provided. The two dates must be in chronological order.
        find_first_match_in_period: a boolean that indicates if the data
            returned is first event if there are multiple matches within the
            time period
        find_last_match_in_period: a boolean that indicates if the data
            returned is last event if there are multiple matches within the
            time period
        restrict_to_earliest_specimen_date: a boolean indicating whether to use
            the "earliest specimen" or "all tests" dataset (see above). True by
            default, meaning that the "earliest specimen" dataset is used.
        returning: string indicating value to be returned. Options are:

            * `binary_flag`: indicates if they have had the an event or not
            * `date`: indicates date of event and used with either find_first_match_in_period or find_last_match_in_period
            * `s_gene_target_failure`: returns the value of the SGTF field (see above)
            * `case_category` (see above)
            * `variant` (see above)
            * `variant_detection_method` (see above)
            * `symptomatic` (see above)
            * `number_of_matches_in_period` (see above)

        date_format: a string detailing the format of the dates to be returned.
            It can be `YYYY-MM-DD`, `YYYY-MM` or `YYYY` and wherever possible
            the least disclosive data should be returned. i.e returning only
            year is less disclosive than a date with day, month and year.
        return_expectations: a dictionary defining the incidence and
            distribution of expected value within the population in question.

    Returns:
        list: of integers of `1` or `0` if `returning` argument is set to
            `binary_flag`; list of strings with a date format returned if
            `returning` argument is set to `date`;

    Example:

        Two variables are created. One called `first_tested_for_covid` is the
        first date that a patient has a covid test never mind the result. The
        second called `first_positive_test_date` is the first date that a
        patient has a positive test result.

            first_tested_for_covid=patients.with_test_result_in_sgss(
                pathogen="SARS-CoV-2",
                test_result="any",
                on_or_after="2020-02-01",
                find_first_match_in_period=True,
                returning="date",
                date_format="YYYY-MM-DD",
                return_expectations={
                    "date": {"earliest" : "2020-02-01"},
                    "rate" : "exponential_increase"
                },
            ),
            first_positive_test_date=patients.with_test_result_in_sgss(
                pathogen="SARS-CoV-2",
                test_result="positive",
                on_or_after="2020-02-01",
                find_first_match_in_period=True,
                returning="date",
                date_format="YYYY-MM-DD",
                return_expectations={
                    "date": {"earliest" : "2020-02-01"},
                    "rate" : "exponential_increase"
                },
            ),
    """
    return "with_test_result_in_sgss", locals()


def maximum_of(*column_names, **extra_columns):
    """
    Return the maximum value over the supplied columns e.g

      max_value=patients.maximum_of("some_column", "another_column")

    Additional columns can be defined within the function call which will be
    used in computing the maximum but won't themselves appear in the output:

      max_value=patients.maximum_of(
          "some_column",
          another_colum=patients.with_these_medications(...)
      )

    This function doesn't accept `return_expectations` but instead derives
    dummy values from the values of its source columns.
    """
    if "return_expectations" in extra_columns:
        raise ValueError(
            "The `maximum_of` function does not accept `return_expectations` and "
            "instead derives dummy values from the values of its source columns"
        )
    aggregate_function = "MAX"
    column_names = column_names + tuple(extra_columns.keys())
    return "aggregate_of", locals()


def minimum_of(*column_names, **extra_columns):
    """
    Return the minimum value over the supplied columns e.g

      min_value=patients.minimum_of("some_column", "another_column")

    Note: this ignores "empty values" (i.e. the values used if there is no data
    for a particular column, such as 0.0 for numeric values or the empty string
    for dates). This ensures that the minimum of a column with a defined value
    and one with a missing value is equal to the defined value.

    Additional columns can be defined within the function call which will be
    used in computing the minimum but won't themselves appear in the output:

      min_value=patients.minimum_of(
          "some_column",
          another_colum=patients.with_these_medications(...)
      )

    This function doesn't accept `return_expectations` but instead derives
    dummy values from the values of its source columns.
    """
    if "return_expectations" in extra_columns:
        raise ValueError(
            "The `minimum_of` function does not accept `return_expectations` and "
            "instead derives dummy values from the values of its source columns"
        )
    aggregate_function = "MIN"
    column_names = column_names + tuple(extra_columns.keys())
    return "aggregate_of", locals()


def fixed_value(value):
    """
    Returns a column that has a single, fixed value for all patients

    We use this internally and don't currently expose this in the documentation, but we
    might find a reason to do so later.
    """
    return "fixed_value", locals()


def household_as_of(reference_date, returning=None, return_expectations=None):
    # noinspection PyPackageRequirements
    """
    Return information about the household to which the patient belonged as of
    the reference date. This is inferred from address data using an algorithm
    developed by TPP (to be documented soon) so the results are not 100%
    reliable but are apparently pretty good.

    Args:
        reference_date: date of interest as a string with the format `YYYY-MM-DD`. Filters results to a particular set date.

        returning: string indicating value to be returned. Options are:

            * `pseudo_id`: An integer identifier for the household which has no
               meaning other than to identify individual members of the same
               household (0 if no household information available)
            * `household_size`: the number of individuals in the household (0
               if no household information available)
            * `is_prison`: Boolean indicating whether household is a prison.
               See https://github.com/opensafely/cohort-extractor/issues/271#issuecomment-679069981
               for details of how this is determined
            * `has_members_in_other_ehr_systems`: Boolean indicating whether
               some household members are registered with GPs using a different
               EHR system, meaning that our coverage of the household is
               incomplete.
            * `percentage_of_members_with_data_in_this_backend`: Integer giving
               the (estimated) percentage of household members where we have
               EHR data available in this backend (i.e. not in other systems as
               above).
            * `msoa`: Returns the MSOA (Middle Super Output Area) in which the
               household is situated

        return_expectations: a dictionary defining the incidence and distribution of expected value within the population in question.

    Returns:
        list: of integers if `returning` argument is set to `pseudo_id`, `household_size` or
        `percentage_of_members_with_data_in_this_backend`. a list of `1` or `0` is `returning` is set to
        `is_prison` or `has_members_in_other_ehr_systems`

        Examples:

            household_id=patients.household_as_of(
                "2020-02-01", returning="pseudo_id"
            )

            household_size=patients.household_as_of(
                "2020-02-01", returning="household_size"
            ),
    """
    return "household_as_of", locals()


def attended_emergency_care(
    on_or_before=None,
    on_or_after=None,
    between=None,
    returning="binary_flag",
    find_first_match_in_period=None,
    find_last_match_in_period=None,
    date_format=None,
    with_these_diagnoses=None,
    discharged_to=None,
    return_expectations=None,
):
    """
    Return information about attendance of A&E from the ECDS dataset. Please note that there is a limited
    number of diagnoses allowed within this dataset, and so will not match with the range of diagnoses allowed
    in other datasets such as the primary care record.

    Args:
        on_or_before: date of interest as a string with the format `YYYY-MM-DD`. Filters results to
            on or before the given date.
        on_or_after: date of interest as a string with the format `YYYY-MM-DD`. Filters results to
            on or after the given date.
        between: two dates of interest as a list with each date as a string with the format `YYYY-MM-DD`.
            Filters results to between the two dates provided (inclusive).
            The two dates must be in chronological order.
        returning: string indicating value to be returned. Options are:

            * `binary_flag`: Whether patient attended A&E
            * `date_arrived`: date patient arrived in A&E
            * `number_of_matches_in_period`: number of times patient attended A&E
            * `discharge_destination`: SNOMED CT code of discharge destination.
               This will be a member of refset 999003011000000105

        find_first_match_in_period: a boolean that indicates if the data returned is first event
            if there are multiple matches within the time period
        find_last_match_in_period: a boolean that indicates if the data returned is last event
            if there are multiple matches within the time period
        date_format: a string detailing the format of the dates to be returned. It can be `YYYY-MM-DD`,
            `YYYY-MM` or `YYYY` and wherever possible the least disclosive data should be returned. i.e returning
            only year is less disclosive than a date with day, month and year.
        with_these_diagnoses: a list of SNOMED CT codes
        discharged_to: a list of members of refset 999003011000000105.
        return_expectations: a dictionary defining the incidence and distribution of expected value
            within the population in question.

    Returns:
        list: of integers of `1` or `0` if `returning` argument is set to `binary_flag`; list of strings with a
            date format returned if `returning` argument is set to `date_arrived`; of integers if `returning`
            argument is set to `number_of_matches_in_period` or `discharge_destination` (with SNOMED CT code as
            a numerical value)

    Example:

        A variable called `emergency_care` is created with returns a date of first attendence in A&E if
        patient had attended emergency room during the time period.

            emergency_care=patients.attended_emergency_care(
                on_or_after="2020-01-01",
                returning="date_arrived",
                date_format="YYYY-MM-DD",
                find_first_match_in_period=True,
                return_expectations={
                    "date": {"earliest" : "2020-02-01"},
                    "rate" : "exponential_increase"
                },
            )
    """
    return "attended_emergency_care", locals()


def date_deregistered_from_all_supported_practices(
    on_or_before=None,
    on_or_after=None,
    between=None,
    date_format=None,
    return_expectations=None,
):
    """
    Returns the date (if any) on which the patient de-registered from all
    practices for which OpenSAFELY has data. Events which occur in primary care
    after this date will not be recorded in the platform (though there may be
    data from other sources e.g. SGSS, CPNS).

    Args:
        on_or_before: date of interest as a string with the format `YYYY-MM-DD`. Filters results to
            on or before the given date.
        on_or_after: date of interest as a string with the format `YYYY-MM-DD`. Filters results to
            on or after the given date.
        between: two dates of interest as a list with each date as a string with the format `YYYY-MM-DD`.
            Filters results to between the two dates provided (inclusive).
            The two dates must be in chronological order.
        date_format: a string detailing the format of the dates to be returned. It can be `YYYY-MM-DD`,
            `YYYY-MM` or `YYYY` and wherever possible the least disclosive data should be returned. i.e returning
            only year is less disclosive than a date with day, month and year.
        return_expectations: a dictionary defining the incidence and distribution of expected value
            within the population in question.

    Returns:
        list: of strings with a date format returned if patient had deregistered, otherwise empty

    Example:

        A variable called `dereg_date` is created with returns a date of de-registration if patient has
        deregistered from a practice within the dataset within the specified time period.

            dereg_date=patients.date_deregistered_from_all_supported_practices(
                on_or_after="2020-03-01",
                date_format="YYYY-MM",
                return_expectations={
                    {"date": {"earliest": "2020-03-01"},
                    "incidence": 0.05
                }
            )
    """
    return "date_deregistered_from_all_supported_practices", locals()


def admitted_to_hospital(
    on_or_before=None,
    on_or_after=None,
    between=None,
    returning="binary_flag",
    find_first_match_in_period=None,
    find_last_match_in_period=None,
    date_format=None,
    with_these_diagnoses=None,
    with_these_primary_diagnoses=None,
    with_these_procedures=None,
    with_admission_method=None,
    with_source_of_admission=None,
    with_discharge_destination=None,
    with_patient_classification=None,
    with_admission_treatment_function_code=None,
    with_administrative_category=None,
    with_at_least_one_day_in_critical_care=False,
    return_expectations=None,
):
    """
    Return information about admission to hospital.

    See https://github.com/opensafely/cohort-extractor/issues/186 for in-depth discussion and background.

    Args:
        on_or_before: date of interest as a string with the format `YYYY-MM-DD`. Filters results to
            on or before the given date.
        on_or_after: date of interest as a string with the format `YYYY-MM-DD`. Filters results to
            on or after the given date.
        between: two dates of interest as a list with each date as a string with the format `YYYY-MM-DD`.
            Filters results to between the two dates provided (inclusive). The two dates must be in chronological order.
        returning: string indicating value to be returned. Options are:

            * `binary_flag`: if they were admitted at all,
            * `date_admitted`: date patient admitted to hospital,
            * `date_discharged`: date patient discharged from hospital,
            * `number_of_matches_in_period`: number of times patient was admitted in time period specified,
            * `primary_diagnosis`: primary diagnosis code for admission,
            * `admission_method`: 2-digit code identifying method of admission: planned (booked/planned/waiting list),
                emergency (various types), transfer from another provider, or birth/maternity.
            * `source_of_admission`: 2-digit code identifying source of admission: most commonly = `19` `usual place of residence`.
                Also useful for identifying admissions from care homes ('54', '65', '85', '88').
                Somewhat useful for identifying birth spells and admissions via transfer (but `method_of_admission` usually preferable)
            * `discharge_destination`: ,
            * `patient_classification`: single-digit numeric code:
                - `1` ordinary admission;
                - `2` day case;
                - `3`/`4` regular admissions (e.g. patient admitted weekly for chemotherapy or dialysis);
                - `5` mother and baby using delivery facilities only.
            * `admission_treatment_function_code`: specialty of patient admission (use with caution for emergency admissions),
            * `days_in_critical_care`: number of days in critical care during spell,
            * `administrative_category`: private vs NHS funded treatment,
            * `duration_of_elective_wait`: days on waiting list for planned procedures (use with caution).
            * `total_bed_days_in_period`: total number of bed days for all admissisions during the time period specified.
            * `total_critical_care_days_in_period`: total number of critical care days for all admissisions during the time period specified.

        find_first_match_in_period: a boolean that indicates if the data returned is first event
            if there are multiple matches within the time period
        find_last_match_in_period: a boolean that indicates if the data returned is last event
            if there are multiple matches within the time period
        date_format: a string detailing the format of the dates to be returned. It can be `YYYY-MM-DD`,
            `YYYY-MM` or `YYYY` and wherever possible the least disclosive data should be returned. i.e returning
            only year is less disclosive than a date with day, month and year.
        with_these_diagnoses: icd10 codes to match against any diagnosis (note
            this uses **prefix** matching so a code like `J12` will match
            `J120`, `J121` etc.)
        with_these_primary_diagnoses: icd10 codes to match against the primary
            diagnosis note this uses **prefix** matching so a code like `J12`
            will match `J120`, `J121` etc.)
        with_these_procedures: opcs4 codes to match against the procedure
        with_admission_method: string or list of strings to match against
        with_source_of_admission: string or list of strings to match against
        with_discharge_destination: string or list of strings to match against
        with_patient_classification: string or list of strings to match against
        with_admission_treatment_function_code: string or list of strings to match against
        with_administrative_category: string or list of strings to match against
        with_at_least_one_day_in_critical_care: a boolean; if True, matches only admissions with at
            least one critical care day
        return_expectations: a dictionary defining the incidence and distribution of expected value
            within the population in question.

    Returns:
        list: of integers of `1` or `0` if `returning` argument is set to `binary_flag`;
            of strings with a date format returned if `returning` argument is set to `date_admitted` or `date_discharged`;
            of integers if `returning` argument is set to `number_of_matches_in_period`, `days_in_critical_care` or `duration_of_elective_wait`;
            of strings with alphanumerical code format for ICD10 code if `returning` argument is set to `primary_diagnosis`;
            of 1-2-digit numeric or alphanumeric codes if `returning` argument is `admission_method`, `source_of_admission`,
            `discharge_destination`, `patient_classification`, or `administrative_category`;
            of 3-digit numeric specialty codes  if `returning` argument is `admission_treatment_function_code`

    Example:
        The day of each patient's first hospital admission for Covid19:

            covid_admission_date=patients.admitted_to_hospital(
                returning= "date_admitted",
                with_these_diagnoses=covid_codelist,
                on_or_after="2020-02-01",
                find_first_match_in_period=True,
                date_format="YYYY-MM-DD",
                return_expectations={"date": {"earliest": "2020-03-01"}},
            )
    """

    return "admitted_to_hospital", locals()


def with_high_cost_drugs(
    drug_name_matches=None,
    # Set date limits
    on_or_before=None,
    on_or_after=None,
    between=None,
    # Set return type
    returning="binary_flag",
    date_format=None,
    # Matching rule
    find_first_match_in_period=None,
    find_last_match_in_period=None,
    return_expectations=None,
):
    """
    Returns data from the High Cost Drugs Dataset

    More details on this dataset available here:
    https://wellcomeopenresearch.org/articles/6-360

    Args:
        drug_name_matches: a drug name as a string, or a list of such names, or
            a codelist containing such names. Results will be filtered to just
            rows matching any of the supplied names exactly. Note these are not
            standardised names, they are just the names however they come to us
            in the original data.
        returning: string indicating value to be returned. Options are:

            * `binary_flag`: if the patient received any matching drugs
            * `date`: date drug received

        on_or_before: as described elsewhere
        on_or_after: as described elsewhere
        between: as described elsewhere
        find_first_match_in_period: as described elsewhere
        find_last_match_in_period: as described elsewhere
        date_format: only "YYYY" and "YYYY-MM" supported here as day level data
            not available
        return_expectations: as described elsewhere

    Example:
        The first month in which each patient received "ACME Drug" after March
        2019:

            covid_admission_date=patients.with_high_cost_drugs(
                drug_name_matches="ACME Drug",
                on_or_after="2019-03-01",
                find_first_match_in_period=True,
                returning="date",
                date_format="YYYY-MM",
                return_expectations={"date": {"earliest": "2019-03-01"}},
            )
    """
    if date_format == "YYYY-MM-DD":
        raise ValueError("Day level data not available for high cost drugs")
    return "with_high_cost_drugs", locals()


def with_ethnicity_from_sus(
    returning=None,
    use_most_frequent_code=None,
    return_expectations=None,
):
    """
    Returns ethnicity data from the SUS Datasets

    Args:
        returning: string indicating value to be returned. Options are:

            * `code`: don't group ethnicities at all, return the recorded code
            * `group_6`: group ethnicities into 6 groups
            * `group_16`: group ethnicities into 16 groups

        use_most_frequent_code: when multiple codes are present, pick the most
            frequent one
        return_expectations: a dictionary describing what dummy data should
            look like

    Returns:
        list: of integers, encoded (in at least TPP) in line with 2001 Census categories as follows.

        `group_6`:

        * 1 - White
        * 2 - Mixed
        * 3 - Asian or Asian British
        * 4 - Black or Black British
        * 5 - Other Ethnic Groups

        `group_16`:

        * 1 - White - British
        * 2 - White - Irish
        * 3 - White - Any other White background
        * 4 - Mixed - White and Black Caribbean
        * 5 - Mixed - White and Black African
        * 6 - Mixed - White and Asian
        * 7 - Mixed - Any other mixed background
        * 8 - Asian or Asian British - Indian
        * 9 - Asian or Asian British - Pakistani
        * 10 - Asian or Asian British - Bangladeshi
        * 11 - Asian or Asian British - Any other Asian background
        * 12 - Black or Black British - Caribbean
        * 13 - Black or Black British - African
        * 14 - Black or Black British - Any other Black background
        * 15 - Other Ethnic Groups - Chinese
        * 16 - Other Ethnic Groups - Any other ethnic group

    Example:
        Patients with ethnicity, grouped to our 16 categories:

            ethnicity_by_16_grouping=patients.with_ethnicity_from_sus(
                returning="group_16",
                use_most_frequent_code=True,
            )
    """
    return "with_ethnicity_from_sus", locals()


def with_these_decision_support_values(
    algorithm,
    on_or_before=None,
    on_or_after=None,
    between=None,
    find_first_match_in_period=None,
    find_last_match_in_period=None,
    returning="numeric_value",
    include_date_of_match=False,
    date_format=None,
    ignore_missing_values=False,
    return_expectations=None,
):
    """
    Returns values computed by the given decision support algorithm.

    Args:
        algorithm: a string indicating the decision support algorithm. Currently, the only option is `electronic_frailty_index` for the electronic frailty index algorithm.
        on_or_before: the date of interest as a string with the format `YYYY-MM-DD`. Filters matches to on or before the given date.
        on_or_after: the date of interest as a string with the format `YYYY-MM-DD`. Filters matches to on or after the given date.
        between: two dates of interest as a list with each date as a string with the format `YYYY-MM-DD`. Filters matches to between the two dates (inclusive).
            The two dates must be in chronological order.
        find_first_match_in_period: a boolean indicating if values should be based on the first match in the period.
        find_last_match_in_period: a boolean indicating if values should be based on the last match in the period. This is the default behaviour.
        returning: a string indicating the values to return. The options are:
            * `binary_flag`
            * `date`
            * `number_of_matches_in_period`
            * `numeric_value` The default value.
        include_date_of_match: a boolean indicating if an extra column containing the date of the match should be returned.
        date_format: a string indicating the format of any dates included in the values. It can be `YYYY-MM-DD`, `YYYY-MM`, or `YYYY`. Wherever possible the least disclosive dates should be returned i.e returning dates with year and month is less disclosive than returning dates with year, month, and day. Only used if `include_date_of_match=True`.
        ignore_missing_values: a boolean indicating if matches where the value is missing or zero should be ignored. We are unable to distinguish between null values (missing) and zeros due to limitations in how the data are recorded by TPP.
        return_expectations: as described elsewhere.
    """
    return "with_these_decision_support_values", locals()


def with_healthcare_worker_flag_on_covid_vaccine_record(
    returning="binary_flag", return_expectations=None
):
    """
    Return whether patient was recorded as being a healthcare worker at the
    time they received a COVID-19 vaccination.

    This data is from the NHS England COVID-19 data store, and reflects
    information collected at the point of vaccination where recipients are
    asked by vaccination staff whether they are in the category of health and
    care worker.

    Args:
        returning: must be 'binary_flag', if supplied
        return_expectations: as described elsewhere.
    """
    return "with_healthcare_worker_flag_on_covid_vaccine_record", locals()


def outpatient_appointment_date(
    returning="binary_flag",
    attended=None,
    is_first_attendance=None,
    with_these_treatment_function_codes=None,
    with_these_procedures=None,
    on_or_after=None,
    between=None,
    date_format="YYYY-MM-DD",
    find_first_match_in_period=None,
    return_expectations=None,
):
    """
    Return when the patient had an outpatient appointment

    Please read and be aware of the [known limitations of this data](https://github.com/opensafely-core/cohort-extractor/issues/673)

    There is also some [more in-depth discussion and background](https://github.com/opensafely-core/cohort-extractor/issues/492)

    Args:
        returning: string indicating value to be returned. Options are:

            * `binary_flag`: indicates if they have had an outpatient appointment or not
            * `date`: latest date of outpatient appointment within the specified period
            * `number_of_matches_in_period`: number of outpatient appointments in period
            * `consultation_medium_used`: consultation medium code for the latest outpatient appointment within the specified period (see https://www.datadictionary.nhs.uk/attributes/consultation_medium_used.html?hl=consultation%2Cmedium )
            * `find_first_match_in_period`: return earliest values for `date` or `consultation_medium_used` (instead of latest)

        attended: if True, filters appointments to only those where the patient
            was recorded as being seen. If it is not known whether they attended
            (e.g. NULL value), it is assumed that they did not attend.
        is_first_attendance: if True, filter appointments to only those where
            it is known whether it is a first attendance. If it is not known
            (e.g. NULL value), it is assumed that it is not a first attendance.
        with_these_treatment_function_codes: Filter the appointments to those
            whose "specialty in which the consultant was working during the
            period of care" matches the supplied codelist.
        with_these_procedures: Filter the appointments to those whose
            `Primary_Procedure_Code` matches the specified OPCS-4 codes.
        on_or_after: date of interest as a string with the format `YYYY-MM-DD`.
            Filters results to on or after the given date. The default value is
            `None`.
        between: two dates of interest as a list with each date as a string
            with the format `YYYY-MM-DD`. Filters matches to between the two
            dates. The default value is `None`. The two dates must be in chronological order.
        date_format: a string detailing the format of the dates to be returned.
            It can be `YYYY-MM-DD`, `YYYY-MM` or `YYYY` and wherever possible
            the least disclosive data should be returned. i.e returning only
            year is less disclosive than a date with day, month and year.
        return_expectations: as described elsewhere.
    """
    return "outpatient_appointment_date", locals()


def with_covid_therapeutics(
    with_these_statuses=None,
    with_these_therapeutics=None,
    with_these_indications=None,
    # Set date limits
    on_or_before=None,
    on_or_after=None,
    between=None,
    # Set return type
    returning="binary_flag",
    date_format=None,
    # Matching rule
    find_first_match_in_period=None,
    find_last_match_in_period=None,
    include_date_of_match=False,
    episode_defined_as=None,
    return_expectations=None,
):
    """
    Returns data from the Therapeutics Dataset (TPP backend only)

    Args:
        with_these_statuses: a status as a string, or a list of such names. Possible values are
            "Approved", "Treatment Complete", "Treatment Not Started", "Treatment Stopped"
        with_these_therapeutics: a drug name as a string, or a list of such names, or
            a codelist containing such names. Results will be filtered to just
            rows containing any of the supplied names. Note these are not
            standardised names, they are just the names however they come to us
            in the original data.
        with_these_indications: a Covid indication name as a string, or a list
            of such names. Possible values are "hospital_onset", "hospitalised_with",
            "non_hospitalised"
        returning: string indicating value to be returned. Options are:

            * `binary_flag`: if the patient received any matching therapeutic intervention
            * `date`: date intervention started
            * `therapeutic`: string of comma-separated drug names
            * `risk_group`: string of comma-separated risk conditions
            * `region`: Region recorded for the therapeutic intervention; note this may be different
              to the patient's region
            * `number_of_matches_in_period`
            * `number_of_episodes`

        on_or_before: as described elsewhere
        on_or_after: as described elsewhere
        between: as described elsewhere
        find_first_match_in_period: as described elsewhere
        find_last_match_in_period: as described elsewhere
        include_date_of_match: a boolean indicating if an extra column containing the date of the match should be returned.
        date_format: a string detailing the format of the treatment dates to be returned.
            It can be "YYYY-MM-DD", "YYYY-MM" or "YYYY" and wherever possible the least disclosive data should be
            returned. i.e returning only year is less disclosive than a date with month and year.
        episode_defined_as: a string expression indicating how an episode should be defined (used when `returning`="number_of_episodes")
        return_expectations: as described elsewhere

    Example:
        The first date on which non-hospitalised patients had any approved theraputic
        after 01 Jan 2022:

            covid_therapeutics=patients.with_covid_therapeutics(
                therapeutic_matches=therapeutic_codelist,
                indication_matches="non-hospitalised",
                approved=True,
                on_or_after="2022-01-01",
                find_first_match_in_period=True,
                returning="date",
                date_format="YYYY-MM-DD",
                return_expectations={"date": {"earliest": "2022-01-01"}},
            )
    """
    return "with_covid_therapeutics", locals()


def with_value_from_file(f_path, returning, returning_type, date_format="YYYY-MM-DD"):
    """
    Returns values from a file.

    Args:
        f_path: a string indicating the path to the file. The file must be either a csv or a csv.gz file and must contain a `patient_id` column.
        returning: a string indicating the column to return from the file. Whilst the file may contain several columns, only this column will be returned from the file.
        returning_type: a string indicating the type of the column to return from the file. The options are:
            * `bool`
            * `date`
            * `str`
            * `int`
            * `float`
        date_format: a string indicating the format of the date, if `returning_type="date"`. The options are:
            * `YYYY-MM-DD` The default value.
            * `YYYY-MM`
            * `YYYY`

    This function does not accept a `return_expectations` argument because the file can contain dummy data.
    """
    return "with_value_from_file", locals()


def which_exist_in_file(f_path):
    """
    Returns boolean values indicating whether patients exist in a file.

    Args:
        f_path: a string indicating the path to the file. The file must be either a csv or a csv.gz file and must contain a `patient_id` column.

    This function does not accept a `return_expectations` argument because the file can contain dummy data.
    """
    return "which_exist_in_file", locals()


def with_an_isaric_record(
    returning,
    between=None,
    date_filter_column=None,
    date_format="YYYY-MM-DD",
    return_expectations=None,
):
    """
    Return whether patient has an ISARIC record

    Args:
        returning: the ISARIC table column to return
        between: two dates of interest as a list with each date as a string with the format `YYYY-MM-DD`.
            Filters results to measurements between the two dates provided (inclusive).
            The two dates must be in chronological order.
        date_filter_column: the ISARIC column to use with `between` arg.
        return_expectations: as described elsewhere.
    """
    return "with_an_isaric_record", locals()


def with_an_ons_cis_record(
    returning,
    return_category_labels=True,
    # Date filtering: column to filter
    date_filter_column=None,
    # Date filtering: date limits
    on_or_before=None,
    on_or_after=None,
    between=None,
    # Matching rule
    find_first_match_in_period=None,
    find_last_match_in_period=None,
    include_date_of_match=False,
    date_format=None,
    return_expectations=None,
):
    """
    Return whether patient has an ONS CIS record

    Args:
        returning: string value; options are:

            * "binary_flag"
            * "number_of_matches_in_period"
            *  the ONS CIS table column to return
        return_category_labels: If the value of `returning` is a coded category, return the
            the corresponding longform string labels
        date_filter_column: the ONS CIS column to use with date limit args; options are:

            * "covid_date"
            * "covid_test_blood_neg_last_date"
            * "covid_test_blood_pos_first_date"
            * "covid_test_swab_neg_last_date"
            * "covid_test_swab_pos_first_date"
            * "received_ox_date"
            * "result_mk_date"
            * "samples_taken_date"
            * "sympt_now_date"
            * "travel_abroad_date"
            * "visit_date"

            `date_filter_column` is not required when returning "number_of_matches_in_period", with no
            date limit arguments.  It is required for all other `returning` options

        on_or_before: date of interest as a string with the format `YYYY-MM-DD`. Filters results to measurements
            on or before the given date (as defined by `date_filter_column`).
        on_or_after: date of interest as a string with the format `YYYY-MM-DD`. Filters results to measurements
            on or after the given date (as defined by `date_filter_column`).
        between: two dates of interest as a list with each date as a string with the format `YYYY-MM-DD`.
            Filters results to measurements between the two dates (as defined by `date_filter_column`)
            provided (inclusive).
            The two dates must be in chronological order.
        find_first_match_in_period: as described elsewhere
        find_last_match_in_period: as described elsewhere
        include_date_of_match: a boolean indicating if an extra column containing the date (from `date_filter_column`)
            of the match should be returned.
        date_format: a string detailing the format of dates to be returned.
            It can be "YYYY-MM-DD", "YYYY-MM" or "YYYY" and wherever possible the least disclosive data should be
            returned. i.e returning only year is less disclosive than a date with month and year.
        return_expectations: as described elsewhere.

    Example:
        Return cleaned employment status (as longform category labels) for patients with a positive covid blood test
        after 01 Jan 2022, returning also the date of the positive covid blood test:

            employment_status = patients.with_an_ons_cis_record(
                returning="work_status_clean",
                return_category_labels=True,
                date_filter_column="covid_test_blood_pos_first_date",
                on_or_after="2022-01-01",
                find_first_match_in_period=True,
                include_date_of_match=True,
                date_format="YYYY-MM-DD",
                return_expectations={
                    "rate": "universal",
                    "category": {
                        "ratios": {"Not working": 0.2, "Working": 0.6, "Student": 0.2},
                    },
                },
            )
    """
    return "with_an_ons_cis_record", locals()


def with_record_in_ukrr(
    # picks dataset held by UK Renal Registry (UKRR)
    from_dataset=None,
    returning=None,
    # Date filtering: date limits
    on_or_before=None,
    on_or_after=None,
    between=None,
    date_format=None,
    return_expectations=None,
):
    """
    Return whether patient has a record in the UK Renal Registry

    Args:
        from_dataset: string value; options are:
            * '2019_prevalence' - a prevalence cohort of patients alive and on RRT in December 2019
            * '2020_prevalence' - a prevalence cohort of patients alive and on RRT in December 2020
            * '2021_prevalence' - a prevalence cohort of patients alive and on RRT in December 2021
            * '2020_incidence' - an incidence cohort of patients who started RRT in 2020
            * '2020_ckd' - a snapshot prevalence cohort of patient with Stage 4 or 5 CKD who were
                reported to the UKRR to be under renal care in December 2020.
        returning: string value; options are:
            * "binary_flag"
            * "renal_centre" - string indicating the code of the main renal centre a
                patient is registered with
            * "rrt_start_date" - the latest start date for renal replacement therapy
            * "treatment_modality_start" - the treatment modality at `rrt_start_date` such as
                ICHD, HHD, HD, PD, Tx
            * "treatment_modality_prevalence" - the treatment modality from the prevalence data
            * "latest_creatinine" - most recent creatinine held by UKRR
            * "latest_egfr" - most recent eGFR held by UKRR
        on_or_before: date of interest as a string with the format `YYYY-MM-DD`. Filters results to measurements
            on or before the given date.
        on_or_after: date of interest as a string with the format `YYYY-MM-DD`. Filters results to measurements
            on or after the given date.
        between: two dates of interest as a list with each date as a string with the format `YYYY-MM-DD`.
            Filters results to measurements between the two dates provided (inclusive).
            The two dates must be in chronological order.
        date_format: a string detailing the format of dates to be returned.
            It can be "YYYY-MM-DD", "YYYY-MM" or "YYYY" and wherever possible the least disclosive data should be
            returned. i.e returning only year is less disclosive than a date with month and year.
        return_expectations: as described elsewhere.

    Example:
        Return patients who are in the prevalence dataset of the UKRR in 2019.

            ukrr_2019 = patients.with_record_in_ukrr(
                from_dataset="2019_prevalence',
                returning="binary_flag",
                return_expectations={
                    "incidence": 0.25
                },
            )
    """
    return "with_record_in_ukrr", locals()
