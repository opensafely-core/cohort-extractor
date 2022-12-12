import csv
from collections import Counter


# Quick and dirty hack until we have a proper library for codelists
class Codelist(list):
    system = None
    has_categories = False


def codelist_from_csv(filename, system, column="code", category_column=None):
    codes = []
    with open(filename, "r") as f:
        for row in csv.DictReader(f):
            # We strip whitespace below. Longer term we expect this to be done
            # automatically by OpenCodelists but for now we want to avoid the
            # problems it creates
            if category_column:
                codes.append((row[column].strip(), row[category_column].strip()))
            else:
                codes.append(row[column].strip())
    return codelist(codes, system)


def codelist(codes, system, check_categories=True):
    codes = Codelist(codes)
    codes.system = system
    first_code = codes[0]
    if isinstance(first_code, tuple):
        codes.has_categories = True
        if check_categories:
            check_categories_consistent(codes)
    return codes


def check_categories_consistent(codes):
    code_counts = Counter([code[0] for code in set(codes)])
    dupes = {code for code, count in code_counts.items() if count > 1}
    if dupes:
        raise ValueError(
            f"Inconsistent categorisation: codelist has codes assigned to more than one category: {', '.join(dupes)}"
        )


def filter_codes_by_category(codes, include):
    assert codes.has_categories
    new_codes = Codelist()
    new_codes.system = codes.system
    new_codes.has_categories = True
    for code, category in codes:
        if category in include:
            new_codes.append((code, category))
    if not len(new_codes):
        raise ValueError(f"codelist has no codes matching categories: {include}")
    return new_codes


def combine_codelists(first_codelist, *other_codelists):
    for other in other_codelists:
        if first_codelist.system != other.system:
            raise ValueError(
                f"Cannot combine codelists from different systems: "
                f"'{first_codelist.system}' and '{other.system}'"
            )
        if first_codelist.has_categories != other.has_categories:
            raise ValueError("Cannot combine categorised and uncategorised codelists")
    combined_dict = {}
    for lst in (first_codelist,) + other_codelists:
        for item in lst:
            code = item[0] if lst.has_categories else item
            if code in combined_dict and item != combined_dict[code]:
                raise ValueError(
                    f"Inconsistent categorisation: {item} and {combined_dict[code]}"
                )
            else:
                combined_dict[code] = item
    return codelist(
        combined_dict.values(), first_codelist.system, check_categories=False
    )


def expand_dmd_codelist(cl, vmp_mapping):
    """Expand codelist to include all current and previous dm+d codes for VMPs.

    VMP dm+d codes can change, and a codelist might contain a previous version of a VMP
    code.  We attempt to handle this transparently by expanding the codelist to include
    all current and previous dm+d codes for VMPs.  However, this means that a query
    using `patients.with_these_medications(codelist, returning="code", ...)` might
    return a code that is not in the provided codelist.
    """

    if cl.has_categories:
        code_to_category = dict(cl)
        for id, prev_id in vmp_mapping:
            if id in code_to_category:
                code_to_category[prev_id] = code_to_category[id]
            if prev_id in code_to_category:
                code_to_category[id] = code_to_category[prev_id]
        return codelist(sorted(code_to_category.items()), cl.system)
    else:
        codes = set(cl)
        for id, prev_id in vmp_mapping:
            if id in codes:
                codes.add(prev_id)
            if prev_id in codes:
                codes.add(id)
        return codelist(sorted(codes), cl.system)
