import pandas

from cohortextractor.measure import Measure


def test_calculates_quotients():
    m = Measure("ignored-id", numerator="fish", denominator="litres")
    data = pandas.DataFrame(
        {"fish": [10, 20, 50], "litres": [1, 2, 100]},
        index=["small bowl", "large bowl", "pond"],
    )
    result = m.calculate(data)

    assert result.loc["small bowl"]["value"] == 10.0
    assert result.loc["large bowl"]["value"] == 10.0
    assert result.loc["pond"]["value"] == 0.5


def test_groups_data_together():
    m = Measure("ignored-id", numerator="fish", denominator="litres", group_by="colour")
    data = pandas.DataFrame(
        {"fish": [10, 20], "litres": [1, 2], "colour": ["gold", "gold"]},
        index=["small bowl", "large bowl"],
    )
    result = m.calculate(data)
    result.set_index("colour", inplace=True)

    assert result.loc["gold"]["fish"] == 30
    assert result.loc["gold"]["litres"] == 3
    assert result.loc["gold"]["value"] == 10.0


def test_groups_into_multiple_buckets():
    m = Measure("ignored-id", numerator="fish", denominator="litres", group_by="colour")
    data = pandas.DataFrame(
        {"fish": [10, 10], "litres": [1, 2], "colour": ["gold", "pink"]}
    )
    result = m.calculate(data)
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
            "fish": [1, 2, 4, 8],
            "litres": [1, 1, 1, 1],
            "colour": ["gold", "gold", "gold", "pink"],
            "nationality": ["russian", "japanese", "russian", "french"],
        }
    )
    result = m.calculate(data)

    assert result.iloc[0]["colour"] == "gold"
    assert result.iloc[0]["nationality"] == "japanese"
    assert result.iloc[0]["fish"] == 2
    assert result.iloc[1]["colour"] == "gold"
    assert result.iloc[1]["nationality"] == "russian"
    assert result.iloc[1]["fish"] == 5
    assert result.iloc[2]["colour"] == "pink"
    assert result.iloc[2]["nationality"] == "french"
    assert result.iloc[2]["fish"] == 8


def test_throws_away_unused_columns():
    m = Measure("ignored-id", numerator="fish", denominator="litres")
    data = pandas.DataFrame(
        {"fish": [10], "litres": [1], "colour": ["green"], "clothing": ["trousers"]}
    )
    result = m.calculate(data)
    assert "clothing" not in result.iloc[0]

    m = Measure("ignored-id", numerator="fish", denominator="litres", group_by="colour")
    data = pandas.DataFrame(
        {"fish": [10], "litres": [1], "colour": ["green"], "age": [12]}
    )
    result = m.calculate(data)
    assert "age" not in result.iloc[0]
