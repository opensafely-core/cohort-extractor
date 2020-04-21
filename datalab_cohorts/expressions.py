import re

import sqlparse
from sqlparse import tokens as ttypes


IGNORE = object()

SAFE_CHARS_RE = re.compile(r"^[a-zA-Z0-9_]+$")


class UnknownColumnError(ValueError):
    pass


def format_expression(expression, name_map):
    """
    Take an SQL expression (in a very limited dialect) and a column name
    mapping and return a reformatted expression with column references
    rewritten using the supplied mapping
    """
    tree = sqlparse.parse(expression)
    tokens = tree[0].flatten()
    tokens = filter_and_validate_tokens(tokens)
    tokens = insert_implicit_comparisons(tokens)
    tokens = remap_names(tokens, name_map)
    return " ".join(token.value for token in tokens)


def remap_names(tokens, name_map):
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
    if len(value) > 16:
        raise ValueError(f"String literals must be 16 characters or less: {value}")
    if not SAFE_CHARS_RE.match(value):
        raise ValueError(
            f"String literals can only contain alphanumeric characters and "
            f"underscore: {value}"
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
    return False


def insert_implicit_comparisons(tokens):
    """
    We want to support treating columns containing 0 and 1 as boolean e.g
    writing "has_asthma OR has_heart_disease" rather than the more cumbersome
    "has_asthma != 0 OR has_heart_disease != 0". To do this we just find any
    column references that aren't part of a comparison and insert an implict
    "!= 0" after them.
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
        if token.ttype is ttypes.Name and not is_compared:
            yield sqlparse.sql.Token(ttypes.Punctuation, "(")
            yield token
            yield sqlparse.sql.Token(ttypes.Comparison, "!=")
            yield sqlparse.sql.Token(ttypes.Number.Integer, "0")
            yield sqlparse.sql.Token(ttypes.Punctuation, ")")
        else:
            yield token
        previous_ttype = token.ttype
