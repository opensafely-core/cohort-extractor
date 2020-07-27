import pytest

from cohortextractor.expressions import format_expression, InvalidExpressionError


def test_basic_expression_rewritting():
    output = format_expression(
        "foo AND (bar > 3 OR baz = 'hello')",
        name_map={"foo": "table1.foo", "bar": "table2.bar", "baz": "other"},
        empty_value_map={"foo": 0, "bar": 0, "baz": ""},
    )
    assert output == "( table1.foo != 0 ) AND ( table2.bar > 3 OR other = 'hello' )"


def test_validation():
    kwargs = dict(name_map={"a": "a", "b": "b"}, empty_value_map={"a": 0, "b": 0})
    with pytest.raises(InvalidExpressionError):
        format_expression("a AND AND b", **kwargs)
    with pytest.raises(InvalidExpressionError):
        format_expression("(a AND b", **kwargs)
    with pytest.raises(InvalidExpressionError):
        format_expression("a > > b", **kwargs)
