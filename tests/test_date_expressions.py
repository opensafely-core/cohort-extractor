import datetime

from cohortextractor.date_expressions import DateExpressionEvaluator


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
