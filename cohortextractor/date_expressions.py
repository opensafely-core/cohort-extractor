import calendar
import copy
import datetime
import re


def evaluate_date_expressions_in_covariate_definitions(
    covariate_definitions, index_date
):
    """
    Take a dict of covariate definitions and parse every date reference within
    it (which might be expressions such as "index_date + 1 month") replacing
    them all with ISO date strings and returning the modified definition
    """
    output = {}
    for name, (query_type, query_args) in covariate_definitions.items():
        query_args = query_args.copy()
        for key in ("date", "reference_date", "start_date", "end_date"):
            if key in query_args:
                query_args[key] = evaluate_date_expression(query_args[key], index_date)
        if "between" in query_args:
            start, end = query_args["between"]
            query_args["between"] = (
                evaluate_date_expression(start, index_date),
                evaluate_date_expression(end, index_date),
            )
        if "return_expectations" in query_args:
            return_expectations = evaluate_date_expressions_in_expectations_definition(
                query_args["return_expectations"], index_date
            )
            query_args["return_expectations"] = return_expectations
        output[name] = (query_type, query_args)
    return output


def evaluate_date_expressions_in_expectations_definition(
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
        expectations_definition["date"][key] = evaluate_date_expression(
            value, index_date
        )
    return expectations_definition


def evaluate_date_expression(date_str, index_date):
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


class InvalidExpressionError(ValueError):
    pass


class UnparseableExpressionError(InvalidExpressionError):
    pass


class InvalidDateError(ValueError):
    pass


def create_regex():
    token = r"[A-Za-z_\-\.]+"
    name = f"(?P<name>{token})"
    function = f"(?P<function>{token})"
    operator = r"(?P<operator> \+ | \-)"
    quantity = r"(?P<quantity>\d+)"
    units = f"(?P<units>{token})"
    return re.compile(
        rf"^( {function} \( )? {name} \)? ( {operator} {quantity} {units} )?$",
        re.VERBOSE,
    )


class DateExpressionEvaluator:

    regex = create_regex()

    def __init__(self, index_date):
        self.index_date = index_date

    def __call__(self, expression_str):
        match = self.regex.match(expression_str.replace(" ", ""))
        if not match:
            raise UnparseableExpressionError(expression_str)
        try:
            return self.evaluate(**match.groupdict())
        except (InvalidExpressionError, InvalidDateError) as e:
            # Add the expression to the error message for easier debugging
            message = f"{e} in: {expression_str}"
            e.args = (message, *e.args[1:])
            raise e

    def evaluate(self, name, function, operator, quantity, units):
        date = self.get_method("name", name)()
        if function:
            date_function = self.get_method("function", function)
            date = date_function(date)
        if operator:
            value = int(quantity)
            if operator == "-":
                value = -value
            add_units = self.get_method("unit", units)
            date = add_units(date, value)
        return date.isoformat()

    def get_method(self, method_type, name):
        prefix = f"date_{method_type}_"
        try:
            return getattr(self, f"{prefix}{name}")
        except AttributeError:
            methods = [n[len(prefix) :] for n in dir(self) if n.startswith(prefix)]
            raise InvalidExpressionError(
                f"Unknown date {method_type} '{name}' "
                f"(allowed are {', '.join(methods)})"
            )

    def date_name_today(self):
        # There's a question mark over whether we should support this at all,
        # see: https://github.com/opensafely/cohort-extractor/issues/237
        return datetime.date.today()

    def date_name_index_date(self):
        if not self.index_date:
            raise InvalidExpressionError("index_date not defined")
        return datetime.date.fromisoformat(self.index_date)

    def date_function_first_day_of_month(self, date):
        return date.replace(day=1)

    def date_function_last_day_of_month(self, date):
        days_in_month = calendar.monthrange(date.year, date.month)[1]
        return date.replace(day=days_in_month)

    def date_function_first_day_of_year(self, date):
        return date.replace(month=1, day=1)

    def date_function_last_day_of_year(self, date):
        return date.replace(month=12, day=31)

    def date_unit_years(self, date, value):
        # This can potentially throw an error if used on 29 Feb
        return date_replace(date, year=date.year + value)

    def date_unit_months(self, date, value):
        # Can potentially thrown an error if day is greater than 28 and there's
        # no corresponding day in the resulting month
        zero_based_month = (date.month - 1) + value
        new_month = (zero_based_month % 12) + 1
        new_year = date.year + (zero_based_month // 12)
        return date_replace(date, year=new_year, month=new_month)

    def date_unit_days(self, date, value):
        return date + datetime.timedelta(days=value)

    # Define the singular units as aliases to the plural
    date_unit_year = date_unit_years
    date_unit_month = date_unit_months
    date_unit_day = date_unit_days


def date_replace(date, **kwargs):
    try:
        return date.replace(**kwargs)
    except ValueError as e:
        if "out of range" not in str(e):
            raise
    # Reformat "out of range" errors to show the invalid date (including the
    # full month name) which should make the problem more obvious
    first_of_month = date.replace(**dict(kwargs, day=1))
    target_day = kwargs.get("day", date.day)
    target_date = f"{target_day} {first_of_month.strftime('%B %Y')}"
    raise InvalidDateError(f"No such date {target_date}")
