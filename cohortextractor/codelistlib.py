import csv


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
    codes = Codelist(codes)
    codes.system = system
    codes.has_categories = bool(category_column)
    return codes


def codelist(codes, system):
    codes = Codelist(codes)
    codes.system = system
    first_code = codes[0]
    if isinstance(first_code, tuple):
        codes.has_categories = True
    return codes


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
    return codelist(combined_dict.values(), first_codelist.system)
