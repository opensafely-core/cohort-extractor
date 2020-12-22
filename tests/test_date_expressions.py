import datetime

import pytest

from cohortextractor.date_expressions import (
    DateExpressionEvaluator,
    InvalidDateError,
    InvalidExpressionError,
)


def test_date_expression_evaluator():
    expr = DateExpressionEvaluator(
        index_date="2017-08-19", column_names=["hospital_admission"]
    )
    assert expr("today") == datetime.date.today().isoformat()
    assert expr("index_date") == "2017-08-19"
    assert expr("index_date + 1 day") == "2017-08-20"
    assert expr("index_date - 30 days") == "2017-07-20"
    assert expr("index_date + 5 months") == "2018-01-19"
    assert expr("index_date + 2 years") == "2019-08-19"
    assert expr("first_day_of_month(index_date)") == "2017-08-01"
    assert expr("last_day_of_month(index_date)") == "2017-08-31"
    assert expr("first_day_of_year(index_date)") == "2017-01-01"
    assert expr("last_day_of_year(index_date)") == "2017-12-31"
    assert expr("first_day_of_month(index_date) - 15 days") == "2017-07-17"
    # Test date literals are passed through
    assert expr("2019-06-10") == "2019-06-10"
    # Test column references are passed through
    assert expr("hospital_admission + 6 months") == "hospital_admission + 6 months"


def test_date_expression_evaluator_errors():
    with pytest.raises(InvalidDateError, match="No such date 29 February 2021"):
        DateExpressionEvaluator("2020-02-29")("index_date + 1 year")
    with pytest.raises(InvalidDateError, match="No such date 31 February 2020"):
        DateExpressionEvaluator("2020-01-31")("index_date + 1 month")
    expr = DateExpressionEvaluator(
        index_date="2017-08-19", column_names=["hospital_admission_0"]
    )
    # Unknown columns still raise errors
    with pytest.raises(
        InvalidExpressionError, match="Unknown date name 'no_such_column'"
    ):
        expr("no_such_column + 1 month")
    # Invalid expressions with known columns still raise errors
    with pytest.raises(InvalidExpressionError, match="Unknown date unit"):
        expr("hospital_admission_0 + 1 mnth")
