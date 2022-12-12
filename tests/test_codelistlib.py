import pytest

from cohortextractor.codelistlib import (
    codelist,
    combine_codelists,
    expand_dmd_codelist,
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


def test_check_categories():
    # duplicates are ignored and are deduped later
    codes_with_duplicate_categories = [("1", "A"), ("1", "A"), ("2", "B")]
    # duplicate codes with inconsistent categories raise an error
    codes_with_inconsistent_categories = [("1", "A"), ("1", "C"), ("2", "B")]
    codes = codelist(codes_with_duplicate_categories, "ctv3")
    assert codes == [("1", "A"), ("1", "A"), ("2", "B")]

    with pytest.raises(ValueError):
        codelist(codes_with_inconsistent_categories, "ctv3")


def test_expand_dmd_codelist_no_categories():
    # In this test (and test_expand_dmd_codelist_categories below) we take a codelist
    # containing current and previous dm+d codes for VMPs that have multiple previous
    # codes, and check that we can expand the codelist to include all current and
    # previous codes for those VMPs.
    #
    # Note that although we're talking about dm+d codelists, the coding system label for
    # dm+d codelists is "snomed" (although that's not actually relevant to this test).

    # A mapping from a VMP code to its previous code(s).
    mapping = [
        ("A2", "A1"),
        ("A2", "A0"),
        ("A1", "A0"),
        ("B2", "B1"),
        ("B2", "B0"),
        ("B1", "B0"),
        ("C2", "C1"),
        ("C2", "C0"),
        ("C1", "C0"),
    ]

    cl = codelist(["A0", "B1", "C2", "D"], "snomed")
    cl1 = expand_dmd_codelist(cl, mapping)
    assert list(cl1) == [
        "A0",
        "A1",
        "A2",
        "B0",
        "B1",
        "B2",
        "C0",
        "C1",
        "C2",
        "D",
    ]
    assert cl1.system == "snomed"


def test_expand_dmd_codelist_categories():
    # See comment in test_expand_dmd_codelist_no_categories.
    mapping = [
        ("A2", "A1"),
        ("A2", "A0"),
        ("A1", "A0"),
        ("B2", "B1"),
        ("B2", "B0"),
        ("B1", "B0"),
        ("C2", "C1"),
        ("C2", "C0"),
        ("C1", "C0"),
    ]
    cl = codelist([("A0", "A"), ("B1", "B"), ("C2", "C"), ("D", "D")], "snomed")
    cl1 = expand_dmd_codelist(cl, mapping)
    assert list(cl1) == [
        ("A0", "A"),
        ("A1", "A"),
        ("A2", "A"),
        ("B0", "B"),
        ("B1", "B"),
        ("B2", "B"),
        ("C0", "C"),
        ("C1", "C"),
        ("C2", "C"),
        ("D", "D"),
    ]
    assert cl1.system == "snomed"
