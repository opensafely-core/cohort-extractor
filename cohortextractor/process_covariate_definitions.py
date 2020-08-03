import copy
import datetime

from .date_expressions import DateExpressionEvaluator, UnparseableExpressionError


def process_covariate_definitions(covariate_definitions, index_date=None):
    """
    Takes a dict of covariate definitions as supplied by the user (where the
    API is optimised for expressiveness and ease of use) and applies various
    transformations that make the structure easier to work with on the backend.
    """
    if "patient_id" in covariate_definitions:
        raise ValueError("patient_id is a reserved column name")
    covariate_definitions = flatten_nested_covariates(covariate_definitions)
    covariate_definitions = process_all_query_arguments(covariate_definitions)
    covariate_definitions = apply_compatibility_fixes_for_include_date(
        covariate_definitions
    )
    covariate_definitions = add_include_date_flags_to_columns(covariate_definitions)
    covariate_definitions = add_column_types(covariate_definitions)
    if index_date is not None:
        validate_date(index_date)
    covariate_definitions = process_date_expressions(covariate_definitions, index_date)
    return covariate_definitions


def flatten_nested_covariates(covariate_definitions):
    """
    Some covariates (e.g `categorised_as`) can define their own internal
    covariates which are used for calculating the column value but don't appear
    in the final output. Here we pull all these internal covariates out (which
    may be recursively nested) and assemble a flat list of covariates, adding a
    `hidden` flag to their arguments to indicate whether or not they belong in
    the final output

    We also check for any name clashes among covariates. (In future we could
    rewrite the names of internal covariates to avoid this but for now we just
    throw an error.)
    """
    flattened = {}
    hidden = set()
    items = list(covariate_definitions.items())
    while items:
        name, (query_type, query_args) = items.pop(0)
        if "extra_columns" in query_args:
            query_args = query_args.copy()
            # Pull out the extra columns
            extra_columns = query_args.pop("extra_columns")
            # Stick the query back on the stack
            items.insert(0, (name, (query_type, query_args)))
            # Mark the extra columns as hidden
            hidden.update(extra_columns.keys())
            # Add them to the start of the list of items to be processed
            items[:0] = extra_columns.items()
        else:
            if name in flattened:
                raise ValueError(f"Duplicate columns named '{name}'")
            flattened[name] = (query_type, query_args)
    for name, (query_type, query_args) in flattened.items():
        query_args["hidden"] = name in hidden
    return flattened


def process_all_query_arguments(covariate_definitions):
    return {
        name: (query_type, process_arguments(query_args))
        for name, (query_type, query_args) in covariate_definitions.items()
    }


def process_arguments(args):
    """
    This receives all arguments from calls to the public API functions so it
    can validate and, if necessary, modify them. In particular, it can be used
    to translate older style API calls into newer ones so as to maintain
    backwards compatibility.
    """
    args = handle_time_period_options(args)

    # Handle deprecated API
    if args.pop("return_binary_flag", None):
        args["returning"] = "binary_flag"
    if args.pop("return_number_of_matches_in_period", None):
        args["returning"] = "number_of_matches_in_period"
    if args.pop("return_first_date_in_period", None):
        args["returning"] = "date"
        args["find_first_match_in_period"] = True
    if args.pop("return_last_date_in_period", None):
        args["returning"] = "date"
        args["find_last_match_in_period"] = True

    # In the public API of the `with_these_medications` function we use the
    # phrase "clinical codes" (as opposed to just "codes") to make it clear
    # that these are distinct from the SNOMED codes used to query the
    # medications table. However, for simplicity of implementation we use just
    # one argument name internally
    if "ignore_days_where_these_clinical_codes_occur" in args:
        args["ignore_days_where_these_codes_occur"] = args.pop(
            "ignore_days_where_these_clinical_codes_occur"
        )

    args = handle_legacy_date_args(args)

    return args


def handle_time_period_options(args):
    """
    Convert the "on_or_before", "on_or_after" and "between" options we support
    for defining time periods into a single "between" argument. This makes the
    code simpler, although we want to continue supporting the three arguments
    for the sake of clarity in the API.
    """
    if "between" not in args:
        return args
    on_or_after = args.pop("on_or_after", None)
    on_or_before = args.pop("on_or_before", None)
    between = args["between"]
    if between and (on_or_after or on_or_before):
        raise ValueError(
            "You cannot set `between` at the same time as "
            "`on_or_after` or `on_or_before`"
        )
    if not between:
        between = (on_or_after, on_or_before)
    if not isinstance(between, (tuple, list)) or len(between) != 2:
        raise ValueError("`between` should be a pair of dates")
    args["between"] = between
    return args


def handle_legacy_date_args(args):
    """
    Change old style date format arguments to new style
    """
    include_month = args.pop("include_month", None)
    include_day = args.pop("include_day", None)
    if args.get("date_format") is not None:
        assert not include_month and not include_day
    elif include_day:
        args["date_format"] = "YYYY-MM-DD"
    elif include_month:
        args["date_format"] = "YYYY-MM"
    return args


def apply_compatibility_fixes_for_include_date(covariate_definitions):
    """
    Previously some covariate definitions could produce mutliple columns by
    passing a flag like `include_date_of_match` which would create an extra
    column of the form "<column_name>_date" in the output. This was to
    avoid having to define (and execute) the same query multiple times to
    get e.g. a blood pressure reading and also the date on which that
    reading was taken.

    However losing the one-one correspondence between the columns defined
    in the study definition and the columns produced in the output made the
    whole system more complex and harded to reason about. We now support
    the requirement by allowing colum definitions to reference other
    columns and say e.g. "column X should contain the date of the
    measurement produced by column Y"

    To maintain backwards compatibility this method finds variants of the
    "include_date" flag and automatically defines the corresponding date
    column.
    """
    updated = {}
    for name, (query_type, query_args) in covariate_definitions.items():
        query_args = query_args.copy()
        suffix = None
        if query_args.pop("include_date_of_match", False):
            suffix = "_date"
        if query_args.pop("include_measurement_date", False):
            suffix = "_date_measured"
        if suffix:
            date_kwargs = pop_keys_from_dict(query_args, ["date_format"])
            date_kwargs["source"] = name
            date_kwargs["returning"] = "date"
            date_kwargs["return_expectations"] = query_args.get("return_expectations")
            date_kwargs["hidden"] = query_args.get("hidden", False)
            updated[name] = (query_type, query_args)
            updated[name + suffix] = ("value_from", date_kwargs)
        else:
            updated[name] = (query_type, query_args)
    return updated


def add_include_date_flags_to_columns(covariate_definitions):
    """
    Where one column is defined as being the date generated by another column
    we need to tell that "source" column that it should calculate a date as
    well, which we do by supplying a flag.

    The sharp-eyed may notice that this is close to being the inverse of
    `apply_compatibility_fixes_for_include_date` above and wonder what is being
    achieved. But this gives us a way of incrementally refactoring things
    without having to make big sweeping changes and without breaking backwards
    compatibility.
    """
    updated = copy.deepcopy(covariate_definitions)
    for name, (query_type, query_args) in updated.items():
        if query_type == "value_from":
            assert query_args["returning"] == "date"
            source_column = query_args["source"]
            source_column_args = updated[source_column][1]
            source_column_args.update(
                include_date_of_match=True, date_format=query_args.get("date_format"),
            )
    return updated


def add_column_types(covariate_definitions):
    get_column_type = GetColumnType()
    for name, (query_type, query_args) in covariate_definitions.items():
        query_args["column_type"] = get_column_type(name, query_type, query_args)
    return covariate_definitions


class GetColumnType:
    def __init__(self):
        self.column_types = {}

    def __call__(self, name, query_type, query_args):
        try:
            method = getattr(self, f"type_of_{query_type}")
        except AttributeError:
            raise ValueError(f"No column type method defined for {query_type}")
        column_type = method(**query_args)
        self.column_types[name] = column_type
        return column_type

    def type_of_value_from(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_age_as_of(self, **kwargs):
        return "int"

    def type_of_date_of_birth(self, **kwargs):
        return "date"

    def type_of_sex(self, **kwargs):
        return "str"

    def type_of_all(self, **kwargs):
        return "bool"

    def type_of_random_sample(self, **kwargs):
        return "bool"

    def type_of_most_recent_bmi(self, **kwargs):
        return "float"

    def type_of_mean_recorded_value(self, **kwargs):
        return "float"

    def type_of_registered_as_of(self, **kwargs):
        return "bool"

    def type_of_registered_with_one_practice_between(self, **kwargs):
        return "bool"

    def type_of_with_complete_history_between(self, **kwargs):
        return "bool"

    def type_of_date_deregistered_from_all_supported_practices(self, **kwargs):
        return "date"

    def type_of_with_these_medications(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_with_these_clinical_events(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_registered_practice_as_of(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_address_as_of(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_admitted_to_icu(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_with_these_codes_on_death_certificate(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_died_from_any_cause(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_with_death_recorded_in_cpns(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_with_tpp_vaccination_record(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_with_gp_consultations(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_with_complete_gp_consultation_history_between(self, **kwargs):
        return "bool"

    def type_of_with_test_result_in_sgss(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_household_as_of(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_attended_emergency_care(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_admitted_to_hospital(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def _type_from_return_value(self, returning):
        if returning == "nhse_region_name":
            raise ValueError(
                "'nhse_region_name' should be changed to the more accurate "
                "'nuts1_region_name'"
            )
        mapping = {
            "binary_flag": "bool",
            "date": "date",
            "date_admitted": "date",
            "date_discharged": "date",
            "date_of_death": "date",
            "number_of_matches_in_period": "int",
            "numeric_value": "float",
            "code": "str",
            "category": "str",
            "number_of_episodes": "int",
            "stp_code": "str",
            "msoa_code": "str",
            "nuts1_region_name": "str",
            "pseudo_id": "int",
            "index_of_multiple_deprivation": "int",
            "rural_urban_classification": "int",
            "household_size": "int",
            "date_arrived": "date",
            "discharge_destination": "str",
            "was_ventilated": "bool",
            "underlying_cause_of_death": "str",
            "primary_diagnosis": "str",
        }
        try:
            return mapping[returning]
        except KeyError:
            raise ValueError(f"No matching type for '{returning}'")

    def type_of_care_home_status_as_of(self, categorised_as, **kwargs):
        return self._infer_type_from_categories(categorised_as)

    def type_of_categorised_as(self, category_definitions, **kwargs):
        return self._infer_type_from_categories(category_definitions)

    def _infer_type_from_categories(self, category_definitions):
        categories = list(category_definitions.keys())
        first_type = type(categories[0])
        for other in categories[1:]:
            if type(other) != first_type:
                raise ValueError(
                    f"Categories must all be the same type, found {first_type} "
                    f"and {type(other)}"
                )
        if first_type is int:
            if set(categories) == {0, 1}:
                return "bool"
            else:
                return "int"
        elif first_type is float:
            return "float"
        elif first_type is str:
            return "str"
        else:
            raise ValueError(f"Unhandled category type: {first_type}")

    def type_of_aggregate_of(self, column_names, aggregate_function, **kwargs):
        other_types = [self.column_types[name] for name in column_names]
        column_type = other_types.pop()
        for other_type in other_types:
            if other_type != column_type:
                raise ValueError(
                    f"Cannot calculate {aggregate_function} over columns of "
                    f"different types (found '{column_type}' and '{other_type}')"
                )
        return column_type


def process_date_expressions(covariate_definitions, index_date):
    """
    Take a covariate definition and parse every date reference within it (which
    might be expressions such as "index_date + 1 month") replacing them all
    with ISO date strings and returning the modified definition
    """
    output = {}
    for name, (query_type, query_args) in covariate_definitions.items():
        for key in ("reference_date", "start_date", "end_date"):
            if key in query_args:
                query_args[key] = process_date_expression(query_args[key], index_date)
        if "between" in query_args:
            start, end = query_args["between"]
            query_args["between"] = (
                process_date_expression(start, index_date),
                process_date_expression(end, index_date),
            )
        if "return_expectations" in query_args:
            return_expectations = process_date_expressions_in_expectations_definition(
                query_args["return_expectations"], index_date
            )
            query_args["return_expectations"] = return_expectations
        output[name] = (query_type, query_args)
    return output


def process_date_expressions_in_expectations_definition(
    expectations_definition, index_date
):
    """
    Take an expectations definition and parse every date reference within it
    (which might be expressions such as "index_date + 1 month") replacing them
    all with ISO date strings and returning the modified definition
    """
    if not expectations_definition:
        return expectations_definition
    expectations_definition = copy.deepcopy(expectations_definition)
    for key in ("earliest", "latest"):
        try:
            value = expectations_definition["date"][key]
        except (KeyError, TypeError):
            continue
        expectations_definition["date"][key] = process_date_expression(
            value, index_date
        )
    return expectations_definition


def process_date_expression(date_str, index_date):
    """
    Return an ISO date string from a date expression (e.g "index_date + 1
    month") and index date

    `date_str` can also just be an ISO date string to start with, in which case
    it is validated but not further modified.
    """
    if date_str is None:
        return None
    parse_expression = DateExpressionEvaluator(index_date)
    try:
        return parse_expression(date_str)
    except UnparseableExpressionError:
        # If we can't parse it as an expression that we just attempt to
        # validate it as an ISO date
        pass
    validate_date(date_str)
    return date_str


def validate_date(date_str):
    try:
        datetime.date.fromisoformat(date_str)
    except ValueError:
        raise ValueError(f"Date not in YYYY-MM-DD format: {date_str}")


def pop_keys_from_dict(dictionary, keys):
    new_dict = {}
    for key in keys:
        if key in dictionary:
            new_dict[key] = dictionary.pop(key)
    return new_dict
