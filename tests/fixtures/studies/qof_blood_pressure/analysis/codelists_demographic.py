from cohortextractor import codelist_from_csv

from .utils import codelists_path

ethnicity6_codes = codelist_from_csv(
    codelists_path / "opensafely-ethnicity.csv",
    system="ctv3",
    column="Code",
    category_column="Grouping_6",
)

learning_disability_codes = codelist_from_csv(
    codelists_path / "nhsd-primary-care-domain-refsets-ld_cod.csv",
    system="snomed",
    column="code",
)

nhse_care_homes_codes = codelist_from_csv(
    codelists_path / "nhsd-primary-care-domain-refsets-carehome_cod.csv",
    system="snomed",
    column="code",
)
