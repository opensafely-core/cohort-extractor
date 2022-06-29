import re
import sqlite3

import sqlparse
from sqlparse import tokens as ttypes

IGNORE = object()

# As well as alphanumeric, underscore, and space characters, which are generally used
# for category names, we also have "comparator" categories for which we need to allow
# the corresponding characters.
SAFE_CHARS_RE = re.compile(r"^[a-zA-Z0-9_ <>=~]+$")


class InvalidExpressionError(ValueError):
    pass


class UnknownColumnError(InvalidExpressionError):
    pass


def format_expression(expression, name_map, empty_value_map):
    """
    Take an SQL expression (in a very limited dialect) and a column name
    mapping and return a reformatted expression with column references
    rewritten using the supplied mapping, along with a set of all the names
    used within the expression.

    `empty_value_map` is a dict giving the "empty" or falsey value appropriate
    to the type of each column. Any column references that are not involved in
    an explicit comparison are rewritten as `!= <empty value>`.

    For example, the expression

        (some_str OR some_int)

    would be rewritten as

        (some_str != '' OR some_int != 0)

    In other words, non-boolean columns can be treated like booleans in the
    expression under the natural (Pythonic) conception of falsity for those
    types.
    """
    tree = sqlparse.parse(expression)
    tokens = tree[0].flatten()
    tokens = filter_and_validate_tokens(tokens)
    tokens = insert_implicit_comparisons(tokens, empty_value_map)
    tokens = list(tokens)
    try:
        validate_expression(tokens, empty_value_map)
    except InvalidExpressionError as e:
        raise InvalidExpressionError(
            f"Invalid SQL expression: {expression}\nError: {e}"
        )
    names_referenced = set()
    tokens = remap_names(tokens, name_map, names_referenced)
    new_expression = " ".join(token.value for token in tokens)
    return new_expression, names_referenced


def remap_names(tokens, name_map, names_referenced):
    """
    Takes an iterable of tokens and remaps any names found within using the
    `name_map` dictionary. Names not found in the map are an error.
    """
    for token in tokens:
        if token.ttype is ttypes.Name:
            try:
                name = name_map[token.value]
            except KeyError:
                raise UnknownColumnError(f"Unknown column: {token.value}")
            names_referenced.add(token.value)
            yield sqlparse.sql.Token(ttypes.Name, name)
        else:
            yield token


def filter_and_validate_tokens(tokens):
    """
    Remove any ignored tokens and ensure the remaining tokens are allowed
    """
    for token in tokens:
        # Special handling for string literals
        if token.ttype in ttypes.Literal.String:
            token = validate_string(token)
            status = True
        else:
            status = is_allowed(token)
        if status is True:
            yield token
        elif status is False:
            raise ValueError(f"Disallowed token: {repr(token)}")
        elif status is not IGNORE:
            raise RuntimeError(f"Invalid status return value: {status}")


def validate_string(token):
    # Remove quotes
    value = token.value[1:-1]
    if len(value) > 64:
        raise ValueError(f"String literals must be 64 characters or less: {value}")
    if not SAFE_CHARS_RE.match(value) and not value == "":
        raise ValueError(
            f"String literals can only contain alphanumeric characters, "
            f"underscore and the comparators '<', '>', '=', and '~': {value}"
        )
    return sqlparse.sql.Token(ttypes.Literal.String.Single, f"'{value}'")


def is_allowed(token):
    """
    Does the supplied token match the limited range of allowed tokens or should
    it raise an error or be ignored
    """
    ttype = token.ttype
    value = token.value
    if ttype in ttypes.Comment:
        return IGNORE
    if ttype in ttypes.Whitespace:
        return IGNORE
    if ttype in ttypes.Name:
        return True
    if ttype in ttypes.Punctuation:
        return value in ["(", ")"]
    if ttype in ttypes.Keyword:
        return value in ["AND", "OR", "NOT"]
    if ttype in ttypes.Comparison:
        return value in [">", "<", ">=", "<=", "=", "!="]
    if ttype in ttypes.Number.Float or ttype in ttypes.Number.Integer:
        return True
    if ttype in ttypes.Operator:
        return value in ["+", "-", "*", "/"]
    return False


def insert_implicit_comparisons(tokens, empty_value_map):
    """
    We want to support treating string and integer columns as boolean e.g
    writing "has_asthma OR latest_heart_disease_date" rather than the more
    cumbersome "has_asthma != 0 OR latest_heart_disease_date != ''". To do this
    we just find any column references that aren't part of a comparison and
    insert an implict comparison after them.
    """
    # Convert to list so we can look forward in token stream
    tokens = list(tokens)
    last_index = len(tokens) - 1
    previous_ttype = None
    for n, token in enumerate(tokens):
        next_ttype = tokens[n + 1].ttype if n != last_index else None
        is_compared = (
            next_ttype is ttypes.Comparison or previous_ttype is ttypes.Comparison
        )
        is_combined = next_ttype is ttypes.Operator or previous_ttype is ttypes.Operator
        if token.ttype is ttypes.Name and not is_compared and not is_combined:
            column_name = str(token)
            empty_value = empty_value_map[column_name]
            yield sqlparse.sql.Token(ttypes.Punctuation, "(")
            yield token
            yield sqlparse.sql.Token(ttypes.Comparison, "!=")
            yield token_for_value(empty_value)
            yield sqlparse.sql.Token(ttypes.Punctuation, ")")
        else:
            yield token
        previous_ttype = token.ttype


def token_for_value(value):
    if value == 0:
        return sqlparse.sql.Token(ttypes.Number.Integer, "0")
    elif value == -1:
        return sqlparse.sql.Token(ttypes.Number.Integer, "-1")
    elif value == "":
        return sqlparse.sql.Token(ttypes.Literal.String.Single, "''")
    else:
        raise ValueError(f"Invalid empty value: {value}")


def validate_expression(tokens, empty_value_map):
    """
    Perform basic syntactic validation on the supplied expression

    This involves transforming it back into SQL and attempting to execute it
    against an in-memory SQLite database. Each name is replaced with a literal
    value of the correct type which we get from the `empty_value_map`.

    Note: because SQLite is so lax about types this doesn't catch any type
    related errors e.g. comparing an int with a string or performing arithmetic
    operations on non-numeric types. But it at least catches basic syntactic
    errors.
    """
    sql = " ".join(
        replace_names_with_empty_values(token, empty_value_map) for token in tokens
    )
    conn = sqlite3.connect(":memory:")
    try:
        conn.execute(f"SELECT ({sql})")
    except sqlite3.OperationalError as e:
        raise InvalidExpressionError(e)


def replace_names_with_empty_values(token, empty_value_map):
    if token.ttype is ttypes.Name:
        try:
            empty_value = empty_value_map[token.value]
        except KeyError:
            raise UnknownColumnError(f"Unknown column: {token.value}")
        token = token_for_value(empty_value)
    return token.value
