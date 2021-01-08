import pytest

from cohortextractor.codelistlib import (
    codelist,
    combine_codelists,
    filter_codes_by_category,
)


def test_filter_codes_by_category():
    codes = codelist([("1", "A"), ("2", "B"), ("3", "A"), ("4", "C")], "ctv3")
    filtered = filter_codes_by_category(codes, include=["B", "C"])
    assert filtered.system == codes.system
    assert filtered == [("2", "B"), ("4", "C")]


def test_combine_codelists():
    list_1 = codelist(["A", "B", "C"], system="ctv3")
    list_2 = codelist(["X", "Y", "Z"], system="ctv3")
    combined = combine_codelists(list_1, list_2)
    expected = codelist(["A", "B", "C", "X", "Y", "Z"], system="ctv3")
    assert combined == expected
    assert combined.system == expected.system


def test_combine_codelists_with_categories():
    list_1 = codelist([("A", "foo"), ("B", "bar")], system="icd10")
    list_2 = codelist([("X", "foo"), ("Y", "bar")], system="icd10")
    combined = combine_codelists(list_1, list_2)
    expected = codelist(
        [("A", "foo"), ("B", "bar"), ("X", "foo"), ("Y", "bar")], system="icd10"
    )
    assert combined == expected
    assert combined.system == expected.system


def test_combine_codelists_raises_error_for_mixed_systems():
    list_1 = codelist(["A", "B", "C"], system="ctv3")
    list_2 = codelist(["X", "Y", "Z"], system="icd10")
    with pytest.raises(ValueError):
        combine_codelists(list_1, list_2)


def test_combine_codelists_raises_error_for_mixed_categorisation():
    list_1 = codelist([("A", "foo"), ("B", "bar")], system="icd10")
    list_2 = codelist(["X", "Y", "Z"], system="icd10")
    with pytest.raises(ValueError):
        combine_codelists(list_1, list_2)


def test_combine_codelists_with_duplicates():
    list_1 = codelist(["A", "B", "C"], system="ctv3")
    list_2 = codelist(["X", "B", "Z"], system="ctv3")
    combined = combine_codelists(list_1, list_2)
    expected = codelist(["A", "B", "C", "X", "Z"], system="ctv3")
    assert combined == expected


def test_combine_codelists_raises_error_on_inconsistent_categorisation():
    list_1 = codelist([("A", "foo"), ("B", "bar")], system="icd10")
    list_2 = codelist([("X", "foo"), ("B", "foo")], system="icd10")
    with pytest.raises(ValueError):
        combine_codelists(list_1, list_2)
