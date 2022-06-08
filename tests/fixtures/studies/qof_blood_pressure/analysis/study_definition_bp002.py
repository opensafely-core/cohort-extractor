from cohortextractor import Measure, StudyDefinition, patients

# Import dates and codelists
from .config import bp002_exclusions, demographic_breakdowns, end_date, start_date

# Import shared variable dictionaries
from .dict_bp_variables import bp002_variables
from .dict_demographic_variables import demographic_variables

study = StudyDefinition(
    index_date=start_date,
    default_expectations={
        "date": {"earliest": start_date, "latest": end_date},
        "rate": "uniform",
        "incidence": 0.5,
    },
    population=patients.satisfying(
        """
        # Define general population parameters
        (NOT died) AND
        (sex = 'F' OR sex = 'M') AND
        (age_band != 'missing') AND

        # Define GMS registration status
        gms_reg_status AND

        # Define list size type:
        age >= 45
        """,
    ),
    # Include blood pressure and demographic variable dictionaries
    **demographic_variables,
    **bp002_variables,
)

# Create blood pressure achievement measures (2)
measures = [
    Measure(
        id="bp002_achievem_population_rate",
        numerator="bp002_numerator",
        denominator="bp002_denominator",
        group_by=["population"],
        small_number_suppression=True,
    ),
    Measure(
        id="bp002_achievem_practice_rate",
        numerator="bp002_numerator",
        denominator="bp002_denominator",
        group_by=["practice"],
        small_number_suppression=True,
    ),
]

# Create blood pressure exclusion measures (3) for total population
for exclusion in bp002_exclusions:
    m = Measure(
        id=f"""bp002_{exclusion.lstrip("bp002_")}_population_rate""",
        numerator=exclusion,
        denominator="population",
        group_by=["population"],
        small_number_suppression=True,
    )
    measures.append(m)

# Create demographic breakdowns (7) for blood pressure indicator BP002 measures
for breakdown in demographic_breakdowns:
    m = Measure(
        id=f"bp002_achievem_{breakdown}_breakdown_rate",
        numerator="bp002_numerator",
        denominator="bp002_denominator",
        group_by=[breakdown],
        small_number_suppression=True,
    )
    measures.append(m)

# Create demographic breakdowns for blood pressure exclusion measures (7 * 3)
for breakdown in demographic_breakdowns:
    for exclusion in bp002_exclusions:
        m = Measure(
            id=f"""bp002_{exclusion.lstrip("bp002_")}_{breakdown}_breakdown_rate""",
            numerator=exclusion,
            denominator="population",
            group_by=[breakdown],
            small_number_suppression=True,
        )
        measures.append(m)
