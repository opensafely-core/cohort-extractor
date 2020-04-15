import sqlparse
from sqlparse import tokens as ttypes


IGNORE = object()

# String literals are not allowed in the subset of SQL we support, except for
# the limited subset below which should be supplied unquoted as if they were
# column names e.g. "sex = M" rather than "sex = 'M'"
BARE_STRING_LITERALS = ["M", "F"]


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
    string_literal_map = {k: k for k in BARE_STRING_LITERALS}
    tokens = remap_names(tokens, name_map, string_literal_map)
    return " ".join(token.value for token in tokens)


def remap_names(tokens, name_map, string_literal_map):
    """
    Takes an iterable of tokens and remaps any names found within using the
    `name_map` dictionary. Names found in `string_literal_map` are replaced
    with the corresponding `string_literal_map`. A name not in either map is an
    error.
    """
    for token in tokens:
        if token.ttype is ttypes.Name:
            literal = string_literal_map.get(token.value)
            if literal:
                yield sqlparse.sql.Token(ttypes.String.Single, f"'{token.value}'")
                continue
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
        status = is_allowed(token)
        if status is True:
            yield token
        elif status is False:
            raise ValueError(f"Disallowed token: {repr(token)}")
        elif status is not IGNORE:
            raise RuntimeError(f"Invalid status return value: {status}")


def is_allowed(token):
    """
    Does the supplied token match the limited range of allowed tokens or should
    it raise an error or be ignored
    """
    ttype = token.ttype
    value = token.value
    # Deliberately `in` rather than `is` as there are multiple comment types
    # and the TokenType class overrides `__contains__`
    if ttype in ttypes.Comment:
        return IGNORE
    if ttype is ttypes.Whitespace:
        return IGNORE
    if ttype is ttypes.Name:
        return True
    if ttype is ttypes.Punctuation:
        return value in ["(", ")"]
    if ttype is ttypes.Keyword:
        return value in ["AND", "OR", "NOT"]
    if ttype is ttypes.Comparison:
        return value in [">", "<", ">=", "<=", "=", "!="]
    if ttype is ttypes.Number.Float or ttype is ttypes.Number.Integer:
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
