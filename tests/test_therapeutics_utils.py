from pathlib import Path

from cohortextractor.therapeutics_utils import extract_risk_groups_from_file


def test_extract_risk_groups_from_file():
    filepath = (
        Path(__file__).parent
        / "fixtures"
        / "therapeutic_risk_groups"
        / "risk_groups.txt"
    )
    assert extract_risk_groups_from_file(filepath) == [
        "haematologic malignancy",
        "haematological diseases",
        "hiv or aids",
        "imid",
        "liver disease",
        "primary immune deficiencies",
        "rare neurological conditions",
        "renal disease",
        "solid cancer",
        "solid organ recipients",
        "stem cell transplant recipients",
    ]
