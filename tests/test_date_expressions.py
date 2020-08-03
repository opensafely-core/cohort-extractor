import datetime

import pytest

from cohortextractor.date_expressions import DateExpressionEvaluator, InvalidDateError


def test_date_expression_evaluator():
    expr = DateExpressionEvaluator(index_date="2017-08-19")
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


def test_date_expression_evaluator_errors():
    with pytest.raises(InvalidDateError, match="No such date 29 February 2021"):
        DateExpressionEvaluator("2020-02-29")("index_date + 1 year")
    with pytest.raises(InvalidDateError, match="No such date 31 February 2020"):
        DateExpressionEvaluator("2020-01-31")("index_date + 1 month")
