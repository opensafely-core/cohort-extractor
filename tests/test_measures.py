import numpy
import pandas

import cohortextractor.measure as measure
from cohortextractor.measure import Measure
from tests.helpers import RecordingReporter, null_reporter


def test_calculates_quotients():
    m = Measure("ignored-id", numerator="fish", denominator="litres")
    data = pandas.DataFrame(
        {"fish": [10, 20, 50], "litres": [1, 2, 100]},
        index=["small bowl", "large bowl", "pond"],
    )
    result = calculate(m, data)

    assert result.loc["small bowl"]["value"] == 10.0
    assert result.loc["large bowl"]["value"] == 10.0
    assert result.loc["pond"]["value"] == 0.5


def test_groups_data_together():
    m = Measure("ignored-id", numerator="fish", denominator="litres", group_by="colour")
    data = pandas.DataFrame(
        {"fish": [10, 20], "litres": [1, 2], "colour": ["gold", "gold"]},
        index=["small bowl", "large bowl"],
    )
    result = calculate(m, data)
    result.set_index("colour", inplace=True)

    assert result.loc["gold"]["fish"] == 30
    assert result.loc["gold"]["litres"] == 3
    assert result.loc["gold"]["value"] == 10.0


def test_groups_into_multiple_buckets():
    m = Measure("ignored-id", numerator="fish", denominator="litres", group_by="colour")
    data = pandas.DataFrame(
        {"fish": [10, 10], "litres": [1, 2], "colour": ["gold", "pink"]}
    )
    result = calculate(m, data)
    result.set_index("colour", inplace=True)

    assert result.loc["gold"]["value"] == 10.0
    assert result.loc["pink"]["value"] == 5.0


def test_groups_by_multiple_columns():
    m = Measure(
        "ignored-id",
        numerator="fish",
        denominator="litres",
        group_by=["colour", "nationality"],
    )
    data = pandas.DataFrame(
        {
            "fish": [10, 20, 40, 80],
            "litres": [1, 1, 1, 1],
            "colour": ["gold", "gold", "gold", "pink"],
            "nationality": ["russian", "japanese", "russian", "french"],
        }
    )
    result = calculate(m, data)

    assert result.iloc[0]["colour"] == "gold"
    assert result.iloc[0]["nationality"] == "japanese"
    assert result.iloc[0]["fish"] == 20
    assert result.iloc[1]["colour"] == "gold"
    assert result.iloc[1]["nationality"] == "russian"
    assert result.iloc[1]["fish"] == 50
    assert result.iloc[2]["colour"] == "pink"
    assert result.iloc[2]["nationality"] == "french"
    assert result.iloc[2]["fish"] == 80


def test_throws_away_unused_columns():
    m = Measure("ignored-id", numerator="fish", denominator="litres")
    data = pandas.DataFrame(
        {"fish": [10], "litres": [1], "colour": ["green"], "clothing": ["trousers"]}
    )
    result = calculate(m, data)
    assert "clothing" not in result.iloc[0]

    m = Measure("ignored-id", numerator="fish", denominator="litres", group_by="colour")
    data = pandas.DataFrame(
        {"fish": [10], "litres": [1], "colour": ["green"], "age": [12]}
    )
    result = calculate(m, data)
    assert "age" not in result.iloc[0]


def test_suppresses_small_numbers_in_the_numerator():
    m = Measure(
        "ignored-id",
        numerator="fish",
        denominator="litres",
        small_number_suppression=True,
    )
    data = pandas.DataFrame({"fish": [1], "litres": [100]}, index=["bowl"])
    result = calculate(m, data)

    assert numpy.isnan(result.loc["bowl"]["fish"])
    assert numpy.isnan(result.loc["bowl"]["value"])


def test_suppresses_small_numbers_at_threshold_in_the_numerator():
    m = Measure(
        "ignored-id",
        numerator="fish",
        denominator="litres",
        small_number_suppression=True,
    )
    data = pandas.DataFrame(
        {
            "fish": [
                measure.SMALL_NUMBER_THRESHOLD,
                measure.SMALL_NUMBER_THRESHOLD,
                measure.SMALL_NUMBER_THRESHOLD + 1,
            ],
            "litres": [100, 100, measure.SMALL_NUMBER_THRESHOLD + 1],
        },
        index=["bowl", "box", "bag"],
    )
    result = calculate(m, data)

    assert numpy.isnan(result.loc["bowl"]["fish"])
    assert numpy.isnan(result.loc["box"]["fish"])
    assert result.loc["bag"]["value"] == 1.0


def test_suppresses_small_numbers_after_grouping():
    m = Measure(
        "ignored-id",
        numerator="fish",
        denominator="litres",
        group_by="colour",
        small_number_suppression=True,
    )
    data = pandas.DataFrame(
        {
            "fish": [2, 2, 2, 2, 3, 3],
            "litres": [2, 2, 2, 2, 3, 3],
            "colour": ["gold", "gold", "bronze", "bronze", "pink", "pink"],
        }
    )
    result = calculate(m, data)
    result.set_index("colour", inplace=True)

    assert numpy.isnan(result.loc["gold"]["value"])
    assert numpy.isnan(result.loc["bronze"]["value"])
    assert result.loc["pink"]["value"] == 1.0


def test_suppression_doesnt_affect_later_calculations_on_the_same_data():
    data = pandas.DataFrame({"fish": [2], "litres": [2]})

    m1 = Measure(
        "ignored-id",
        numerator="fish",
        denominator="litres",
        small_number_suppression=True,
    )
    r1 = calculate(m1, data)
    assert numpy.isnan(r1.iloc[0]["value"])

    m2 = Measure("ignored-id", numerator="fish", denominator="litres")
    r2 = calculate(m2, data)
    assert r2.iloc[0]["value"] == 1.0


def test_doesnt_suppress_zero_values():
    m = Measure(
        "ignored-id",
        numerator="fish",
        denominator="litres",
        small_number_suppression=True,
    )
    data = pandas.DataFrame(
        {"fish": [0, 1], "litres": [100, 100]}, index=["bowl", "bag"]
    )
    result = calculate(m, data)

    assert result.loc["bowl"]["fish"] == 0
    assert result.loc["bowl"]["value"] == 0


def test_suppresses_denominator_if_its_small_enough():
    m = Measure(
        "ignored-id",
        numerator="fish",
        denominator="litres",
        small_number_suppression=True,
    )
    data = pandas.DataFrame({"fish": [0], "litres": [4]}, index=["bag"])
    result = calculate(m, data)

    assert numpy.isnan(result.loc["bag"]["litres"])
    assert numpy.isnan(result.loc["bag"]["value"])


def test_suppresses_an_extra_value_if_total_of_small_values_is_less_than_threshold():
    m = Measure(
        "ignored-id",
        numerator="fish",
        denominator="litres",
        small_number_suppression=True,
    )
    data = pandas.DataFrame(
        {"fish": [2, 2, 6], "litres": [10, 10, 10]}, index=["a", "b", "c"]
    )
    result = calculate(m, data)

    assert numpy.isnan(result.loc["a"]["fish"])
    assert numpy.isnan(result.loc["b"]["fish"])
    assert numpy.isnan(result.loc["c"]["fish"])


def test_suppresses_all_small_values_even_if_total_is_way_over_threshold():
    m = Measure(
        "ignored-id",
        numerator="fish",
        denominator="litres",
        small_number_suppression=True,
    )
    data = pandas.DataFrame(
        {"fish": [2, 2, 2, 2], "litres": [10, 10, 10, 10]}, index=["a", "b", "c", "d"]
    )
    result = calculate(m, data)

    assert numpy.isnan(result.loc["a"]["fish"])
    assert numpy.isnan(result.loc["b"]["fish"])
    assert numpy.isnan(result.loc["c"]["fish"])
    assert numpy.isnan(result.loc["d"]["fish"])


def test_suppresses_smallest_extra_value_to_reach_threshold():
    m = Measure(
        "ignored-id",
        numerator="fish",
        denominator="litres",
        small_number_suppression=True,
    )
    data = pandas.DataFrame(
        {"fish": [2, 10, 8], "litres": [10, 10, 10]}, index=["a", "b", "c"]
    )
    result = calculate(m, data)

    assert numpy.isnan(result.loc["a"]["fish"])
    assert result.loc["b"]["fish"] == 10
    assert numpy.isnan(result.loc["c"]["fish"])


def test_suppresses_all_equal_extra_values_to_reach_threshold():
    m = Measure(
        "ignored-id",
        numerator="fish",
        denominator="litres",
        small_number_suppression=True,
    )
    data = pandas.DataFrame(
        {"fish": [1, 10, 10], "litres": [10, 10, 10]}, index=["a", "b", "c"]
    )
    result = calculate(m, data)

    assert numpy.isnan(result.loc["a"]["fish"])
    assert numpy.isnan(result.loc["b"]["fish"])
    assert numpy.isnan(result.loc["c"]["fish"])


def test_reports_suppression_of_small_values():
    m = Measure(
        "ignored-id",
        numerator="fish",
        denominator="litres",
        small_number_suppression=True,
    )
    data = pandas.DataFrame({"fish": [1], "litres": [100]}, index=["bowl"])
    reporter = RecordingReporter()
    calculate(m, data, reporter)

    assert "Suppressed small numbers in column fish" in reporter.msg


def test_reports_suppression_of_extra_values():
    m = Measure(
        "ignored-id",
        numerator="fish",
        denominator="litres",
        small_number_suppression=True,
    )
    data = pandas.DataFrame(
        {"fish": [2, 10, 8], "litres": [10, 10, 10]}, index=["a", "b", "c"]
    )
    reporter = RecordingReporter()
    calculate(m, data, reporter)

    assert "Additional suppression in column fish" in reporter.msg


def calculate(measure, data, reporter=null_reporter):
    return measure.calculate(data, reporter)
