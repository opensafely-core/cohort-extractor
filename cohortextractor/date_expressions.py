import calendar
import datetime
import re


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
