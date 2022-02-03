import re
from pathlib import Path


def extract_unique_risk_groups_from_file(input_file):
    pt = Path(input_file)
    lines = pt.read_text().split("\n")
    risk_groups = set()
    for line in lines:
        groups = line.split("and")
        for group in groups:
            group = re.sub("Patients with a?", "", group)
            risk_groups.add(group.strip().lower())
    return sorted(risk_groups)
