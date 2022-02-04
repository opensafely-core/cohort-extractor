import re
from pathlib import Path


def extract_risk_groups_from_file(input_file):
    """
    Helper function to extract distinct risk groups from a file with one line
    per distinct risk group value extracted from the database

    (Note that this input file is expected to be generated manually, checked to ensure
    no disclosive free text data may be included, and used to ensure the following
    `ALLOWED_RISK_GROUPS` list is complete)
    """
    lines = Path(input_file).read_text().strip().split("\n")
    risk_groups = set()
    for line in lines:
        for group in line.split("and"):
            group = re.sub("Patients with a?", "", group)
            risk_groups.add(group.strip().lower())
    return sorted(risk_groups)


ALLOWED_RISK_GROUPS = [
    "downs syndrome",
    "haematologic malignancy",
    "haematological diseases",
    "hiv or aids",
    "imid",
    "immune-mediated inflammatory disorders (imid)",
    "liver disease",
    "primary immune deficiencies",
    "rare neurological conditions",
    "renal disease",
    "sickle cell disease",
    "solid cancer",
    "solid organ recipients",
    "solid organ transplant recipients",
    "stem cell transplant recipients",
]
