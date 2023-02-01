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
    evaluate_date_expression = DateExpressionEvaluator(
        index_date, column_names=covariate_definitions.keys()
    )
    for name, (query_type, query_args) in covariate_definitions.items():
        query_args = query_args.copy()
        for key in ("date", "reference_date", "start_date", "end_date"):
            if key in query_args:
                query_args[key] = evaluate_date_expression(query_args[key])
        if "between" in query_args:
            start, end = query_args["between"]
            query_args["between"] = (
                evaluate_date_expression(start),
                evaluate_date_expression(end),
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
    evaluate_date_expression = DateExpressionEvaluator(index_date)
    for key in ("earliest", "latest"):
        try:
            value = expectations_definition["date"][key]
        except (KeyError, TypeError):
            continue
        expectations_definition["date"][key] = evaluate_date_expression(value)
    return expectations_definition


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
    token = r"[A-Za-z][A-Za-z0-9_\.]*"
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

    def __init__(self, index_date, column_names=()):
        self.index_date = index_date
        self.column_names = set(column_names)

    def __call__(self, date_str):
        """
        Return an ISO date string from a date expression (e.g "index_date + 1
        month") and index date

        `date_str` can also just be an ISO date string to start with, in which case
        it is validated but not further modified.
        """
        if date_str is None:
            return None
        try:
            return self.parse(date_str)
        except UnparseableExpressionError:
            # If we can't parse it as an expression that we just attempt to
            # validate it as an ISO date
            pass
        validate_date(date_str)
        return date_str

    def parse(self, expression_str):
        match = self.regex.match(expression_str.replace(" ", ""))
        if not match:
            raise UnparseableExpressionError(expression_str)
        args = match.groupdict()
        # Date expressions that involve other column names (e.g
        # "hospital_admission + 6 months") can't be evaluated here as they need
        # to get transformed into the appropriate SQL queries. So we pass them
        # through unmodified.
        if args["name"] in self.column_names:
            self.validate_expression_arguments(**args)
            return expression_str
        try:
            return self.evaluate(**args)
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

    def validate_expression_arguments(
        self, function, operator, quantity, units, name=None
    ):
        """
        Where a date expression contains a reference to another column we can't
        evaluate it here, but we can check that the rest of the expression is
        valid
        """
        if function:
            self.get_method("function", function)
        if operator:
            int(quantity)
            self.get_method("unit", units)

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

    def date_function_first_day_of_nhs_financial_year(self, date):
        """The NHS financial (reporting) year runs from 1st April - 31st March"""
        year = date.year - 1 if date.month < 4 else date.year
        return date.replace(year=year, month=4, day=1)

    def date_function_last_day_of_nhs_financial_year(self, date):
        """The NHS financial (reporting) year runs from 1st April - 31st March"""
        year = date.year + 1 if date.month >= 4 else date.year
        return date.replace(year=year, month=3, day=31)

    def date_function_first_day_of_school_year(self, date):
        """The school year in England runs from 1st September - 31st August"""
        year = date.year - 1 if date.month < 9 else date.year
        return date.replace(year=year, month=9, day=1)

    def date_function_last_day_of_school_year(self, date):
        """The school year in England runs from 1st September - 31st August"""
        year = date.year + 1 if date.month >= 9 else date.year
        return date.replace(year=year, month=8, day=31)

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


class DateFormatter:
    regex = create_regex()

    def __init__(self, column_definitions):
        self.column_definitions = column_definitions

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
        try:
            date_column = self.column_definitions[name]
        except KeyError:
            raise InvalidExpressionError(f"Unknown date column: {name}")
        if date_column.type != "date":
            raise InvalidExpressionError(f"Column '{name}' is not a date")
        if date_column.date_format == "YYYY":
            raise InvalidExpressionError(
                f"Column '{name}' has a year-only date format 'YYYY' and so can't be "
                f"used in date expressions"
            )
        date_expr = self.get_date_expression(date_column)
        if function:
            date_function = self.get_method("function", function)
            date_expr = date_function(date_expr)
        if operator:
            value = int(quantity)
            if operator == "-":
                value = -value
            add_units = self.get_method("unit", units)
            date_expr = add_units(date_expr, value)
        return date_expr, name

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


class MSSQLDateFormatter(DateFormatter):
    def get_date_expression(self, date_column):
        """
        In order to use a date column in a query we need to cast it to an
        actual date, not the string representation of a date which it currently
        is. In the general case we can do that using `TRY_PARSE` (which, unlike
        `PARSE`, will give us NULL on an empty string as we want). However,
        this often ends up producing some convoluted SQL in which we transform
        a date into a string and do some null handling only to immediately
        parse it back into a date and reverse the null handling. So we try to
        pattern match the most obvious cases of this and rewrite them, but fall
        back to using TRY_PARSE otherwise.
        """
        date_format = date_column.date_format
        date_sql = re.sub(r"\s", "", str(date_column))
        # e.g. ISNULL(CONVERT(VARCHAR(10),#some_table.[some_column],23),'')
        match = re.match(
            r"ISNULL\(CONVERT\(VARCHAR\(\d+\),([#\w\.\[\]]+),23\),''\)", date_sql
        )
        if match:
            column_ref = match.group(1)
            if date_format == "YYYY-MM-DD":
                return self.cast_as_date(column_ref)
            elif date_format == "YYYY-MM":
                return self.date_function_first_day_of_month(column_ref)
            else:
                raise RuntimeError("Should never get here")
        else:
            return f"TRY_PARSE({date_column} AS date USING 'en-GB')"

    def date_function_first_day_of_month(self, date):
        return f"DATEADD(DAY, 1, EOMONTH({date}, -1))"

    def date_function_last_day_of_month(self, date):
        return f"EOMONTH({date})"

    def date_function_first_day_of_year(self, date):
        return f"DATEFROMPARTS(YEAR({date}), 1, 1)"

    def date_function_last_day_of_year(self, date):
        return f"DATEFROMPARTS(YEAR({date}), 12, 31)"

    def date_function_first_day_of_nhs_financial_year(self, date):
        """The NHS financial (reporting) year runs from 1st April - 31st March"""
        return f"""
            CASE WHEN
                MONTH({date}) < 4
            THEN
                DATEFROMPARTS(YEAR({date}) - 1, 4, 1)
            ELSE
                DATEFROMPARTS(YEAR({date}), 4, 1)
            END
        """

    def date_function_last_day_of_nhs_financial_year(self, date):
        """The NHS financial (reporting) year runs from 1st April - 31st March"""
        return f"""
            CASE WHEN
                MONTH({date}) >= 4
            THEN
                DATEFROMPARTS(YEAR({date}) + 1, 3, 31)
            ELSE
                DATEFROMPARTS(YEAR({date}), 3, 31)
            END
        """

    def date_unit_years(self, date, value):
        return f"DATEADD(YEAR, {value}, {date})"

    def date_unit_months(self, date, value):
        return f"DATEADD(MONTH, {value}, {date})"

    def date_unit_days(self, date, value):
        return f"DATEADD(DAY, {value}, {date})"

    @staticmethod
    def cast_as_date(date_expr):
        return f"CAST({date_expr} AS date)" if date_expr else None

    # Define the singular units as aliases to the plural
    date_unit_year = date_unit_years
    date_unit_month = date_unit_months
    date_unit_day = date_unit_days


class TrinoDateFormatter(DateFormatter):
    def get_date_expression(self, date_column):
        """
        In order to use a date column in a query we need to cast it to an
        actual date, not the string representation of a date which it currently
        is. In the general case we can do that using `TRY_PARSE` (which, unlike
        `PARSE`, will give us NULL on an empty string as we want). However,
        this often ends up producing some convoluted SQL in which we transform
        a date into a string and do some null handling only to immediately
        parse it back into a date and reverse the null handling. So we try to
        pattern match the most obvious cases of this and rewrite them, but fall
        back to using TRY_PARSE otherwise.
        """
        date_format = date_column.date_format
        date_sql = re.sub(r"\s", "", str(date_column))
        match = re.match(
            r"COALESCE\(date_format\(([\w\.]+),'%Y-%m-%d'\),''\)", date_sql
        )
        if match:
            column_ref = match.group(1)
            if date_format == "YYYY-MM-DD":
                return self.cast_as_date(column_ref)
            elif date_format == "YYYY-MM":
                return self.date_function_first_day_of_month(column_ref)
            else:
                raise RuntimeError("Should never get here")
        else:
            return f"try(date_parse({date_column}, '%Y-%m-%d'))"
        return date_column

    def date_function_first_day_of_month(self, date):
        return f"date_trunc('month', {date})"

    def date_function_last_day_of_month(self, date):
        return f"last_day_of_month({date})"

    def date_function_first_day_of_year(self, date):
        return f"date_trunc('year', {date})"

    def date_function_last_day_of_year(self, date):
        # :(
        return f"from_iso8601_date(cast(year({date}) as varchar(4)) || '-12-31')"

    def date_function_first_day_of_nhs_financial_year(self, date):
        """The NHS financial (reporting) year runs from 1st April - 31st March"""
        return f"""
            IF(month({date}) < 4,
            from_iso8601_date(cast((year({date}) - 1) as varchar(4)) || '-04-01'),
            from_iso8601_date(cast((year({date})) as varchar(4)) || '-04-01')
        """

    def date_function_last_day_of_nhs_financial_year(self, date):
        """The NHS financial (reporting) year runs from 1st April - 31st March"""
        return f"""
            IF(month({date}) >= 4,
            from_iso8601_date(cast((year({date}) + 1) as varchar(4)) || '-03-31'),
            from_iso8601_date(cast(year({date}) as varchar(4)) || '-03-31')
        """

    def date_unit_years(self, date, value):
        return f"date_add('year', {value}, {date})"

    def date_unit_months(self, date, value):
        return f"date_add('month', {value}, {date})"

    def date_unit_days(self, date, value):
        return f"date_add('day', {value}, {date})"

    @staticmethod
    def cast_as_date(date_expr):
        return f"CAST({date_expr} AS date)" if date_expr else None

    # Define the singular units as aliases to the plural
    date_unit_year = date_unit_years
    date_unit_month = date_unit_months
    date_unit_day = date_unit_days
