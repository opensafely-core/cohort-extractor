import copy
import datetime
import re

from .ons_cis_utils import ONS_CIS_CATEGORY_COLUMNS, ONS_CIS_COLUMN_MAPPINGS

# ISARIC data has a lot of columns that are all varchar in the db.
ISARIC_COLUMN_MAPPINGS = {
    "abdopain_ceoccur_v2": "str",
    "admission2onset": "int",
    "admission_diabp_vsorres": "int",
    "admission_month": "str",
    "admission_week": "int",
    "age_estimateyears": "float",
    "age_estimateyearsu": "str",
    "age_factor_19_no_neonates": "str",
    "age_factor_19_with_neonates": "str",
    "agedatyn": "str",
    "ageusia_ceoccur_v2": "str",
    "aidshiv_mhyn": "str",
    "all_antiviral": "str",
    "all_cardiac_comp": "str",
    "all_ecmo": "str",
    "all_imm_mod": "str",
    "all_inotropes": "str",
    "all_invasive": "str",
    "all_ivig": "str",
    "all_noninvasive": "str",
    "alt_reason_admit": "str",
    "aneamia_ceterm": "str",
    "anosmia_ceoccur_v2": "str",
    "antibiotic": "str",
    "antiviral": "str",
    "any_comorb": "str",
    "any_max_steroid": "str",
    "any_trach": "str",
    "apdm_age": "str",
    "aplb_lborres": "str",
    "aplb_lbperf": "str",
    "apsc_brdisdat": "str",
    "apsc_brfedind": "str",
    "apsc_brfedindy": "str",
    "apsc_dvageind": "str",
    "apsc_gestout": "str",
    "apsc_vcageind": "str",
    "apvs_weight": "float",
    "apvs_weightnk": "str",
    "apvs_weightu": "str",
    "ards_ceoccur": "str",
    "ari": "str",
    "arm_participant": "int",
    "arrhythmia_ceterm": "str",
    "assess_age": "float",
    "assess_age_minus_age": "float",
    "assess_or_admit_date": "date",
    "asthma_comorb": "str",
    "asthma_mhyn": "str",
    "asymp": "str",
    "asymp_or_incident": "str",
    "bacteraemia_ceterm": "str",
    "bactpneu_ceoccur": "str",
    "bleed_ceoccur_v2": "str",
    "bleed_ceterm_v2": "str",
    "bmj_pt": "str",
    "bronchio_ceterm": "str",
    "calc_age": "int",
    "cardiac_comorb": "str",
    "cardiac_comp": "str",
    "cardiacarrest_ceterm": "str",
    "cardiomyopathy_ceterm": "str",
    "cestdat": "date",
    "chestpain_ceoccur_v2": "str",
    "chrincard": "str",
    "chronic_nsaid_cmoccur": "str",
    "chronichaemo_mhyn": "str",
    "chronicneu_mhyn": "str",
    "chronicpul_mhyn": "str",
    "coagulo_ceterm": "str",
    "comorb_count": "int",
    "confusion_ceoccur_v2": "str",
    "conjunct_ceoccur_v2": "str",
    "coriona_ieorres2": "str",
    "coriona_ieorres3": "str",
    "corona_ieorres": "str",
    "cough": "str",
    "cough_ceoccur_v2": "str",
    "coughhb_ceoccur_v2": "str",
    "coughsput_ceoccur_v2": "str",
    "country": "str",
    "country_pcds": "str",
    "covid19_vaccine": "str",
    "cryptogenic_ceterm": "str",
    "cxr_count": "int",
    "cxr_done": "str",
    "daily_alt_lborres": "float",
    "daily_alt_lbyn": "str",
    "daily_altop_lbyn": "str",
    "daily_aptt_lborres": "float",
    "daily_aptt_lbyn": "str",
    "daily_apttop_lborres": "str",
    "daily_ast_lborres": "float",
    "daily_ast_lbyn": "str",
    "daily_bil_lborres": "float",
    "daily_bil_lborresu": "str",
    "daily_bil_lbyn": "str",
    "daily_bilop_lborres": "str",
    "daily_bun_lborres": "float",
    "daily_bun_lborresu": "str",
    "daily_bun_lbyn": "str",
    "daily_bunop_lborres": "str",
    "daily_cpk_lby": "str",
    "daily_cpk_lbyn_2": "int",
    "daily_cpkop_lbyn_2": "str",
    "daily_creat_lborres": "float",
    "daily_creat_lborresu": "str",
    "daily_creat_lbyn": "str",
    "daily_creatop_lborres": "str",
    "daily_crp_lborres": "float",
    "daily_crp_lborresu": "str",
    "daily_crp_lbyn": "str",
    "daily_crpop_lborres": "str",
    "daily_dsstdat": "date",
    "daily_esr_lborres": "float",
    "daily_esr_lbyn": "str",
    "daily_ferr_lborres": "float",
    "daily_ferr_lborresu": "str",
    "daily_ferr_lbyn": "str",
    "daily_ferrop_lbyn": "str",
    "daily_glucose_lborres": "float",
    "daily_glucose_lborresu": "str",
    "daily_glucose_lbyn": "str",
    "daily_glucoseop_lborres": "str",
    "daily_haematocrit_lborres": "float",
    "daily_haematocrit_lborresu": "str",
    "daily_haematocrit_lbyn": "str",
    "daily_hb_lborres": "float",
    "daily_hb_lborresu": "str",
    "daily_hb_lbyn": "str",
    "daily_hbop_lborres": "str",
    "daily_inr_lborres": "float",
    "daily_lactate_lborres": "float",
    "daily_lactate_lborresu": "str",
    "daily_lactate_lbyn": "str",
    "daily_lactateop_lbyn": "str",
    "daily_lbdat": "date",
    "daily_ldh_lborres": "float",
    "daily_ldh_lbyn": "str",
    "daily_lymp_lborres": "float",
    "daily_lymp_lborresu": "str",
    "daily_lymp_lbyn": "str",
    "daily_lympop_lbyn": "str",
    "daily_neutro_lborres": "float",
    "daily_neutro_lborresu": "str",
    "daily_neutro_lbyn": "str",
    "daily_neutroop_lbyn": "str",
    "daily_plt_lborres": "float",
    "daily_plt_lborresu": "str",
    "daily_plt_lbyn": "str",
    "daily_pltop_lborres": "str",
    "daily_potassium_lborres": "float",
    "daily_potassium_lborresu": "str",
    "daily_potassium_lbyn": "str",
    "daily_potassiumop_lborres": "str",
    "daily_procal_lborres": "float",
    "daily_procal_lbyn": "str",
    "daily_procalop_lborres": "str",
    "daily_pt_inr_lbyn": "str",
    "daily_pt_lborres": "float",
    "daily_ptop_lborres": "str",
    "daily_sodium_lborres": "float",
    "daily_sodium_lborresu": "str",
    "daily_sodium_lbyn": "str",
    "daily_sodiumop_lborres": "str",
    "daily_wbc_lborres": "float",
    "daily_wbc_lborresu": "str",
    "daily_wbc_lbyn": "str",
    "daily_wbcop_lborres": "str",
    "death": "str",
    "dehydration_vsorres": "str",
    "dementia_mhyn": "str",
    "diabetes_comorb": "str",
    "diabetes_mhyn": "str",
    "diabetes_type_mhyn": "str",
    "diabetescom_mhyn": "str",
    "dialysis": "str",
    "diarrhoea_ceoccur_v2": "str",
    "dlvrdtc_rptestcd": "date",
    "dsstdat": "date",
    "dsstdtc": "date",
    "dsterm": "str",
    "dvt_ceterm": "str",
    "dyspnoe": "str",
    "earpain_ceoccur_v2": "str",
    "ecmo": "str",
    "egestage_rptestcd": "float",
    "endocarditis_aeterm": "str",
    "estgest": "float",
    "ethnic___1": "str",
    "ethnic___10": "str",
    "ethnic___2": "str",
    "ethnic___3": "str",
    "ethnic___4": "str",
    "ethnic___5": "str",
    "ethnic___6": "str",
    "ethnic___7": "str",
    "ethnic___8": "str",
    "ethnic___9": "str",
    "ethnicity": "str",
    "fatigue_ceoccur_v2": "str",
    "fever": "str",
    "fever_all": "str",
    "fever_ceoccur_v2": "str",
    "first_wave": "int",
    "gastro_ceterm": "str",
    "genetic_comorb": "str",
    "haem_onc_comorb": "str",
    "has_picu": "str",
    "headache_ceoccur_v2": "str",
    "heartfailure_ceterm": "str",
    "high_flow_o2": "str",
    "hooccur": "str",
    "hostdat": "date",
    "hostdat_transfer": "date",
    "hostdat_transfernk": "str",
    "hosttim": "date",
    "hr_vsorres": "int",
    "hyperglycemia_aeterm": "str",
    "hyperinflam_WHO": "str",
    "hypertension_mhyn": "str",
    "hypoglycemia_ceterm": "str",
    "imm_sup_all": "str",
    "immno_cmtrt": "str",
    "incidental_covid": "str",
    "infant": "str",
    "infect_cmtrt": "str",
    "infiltrates_faorres": "str",
    "infiltrates_yn": "str",
    "inflammatory_mss": "str",
    "influenza_2021_vaccine": "str",
    "influenza_2021_vaccined": "date",
    "inotrope": "str",
    "ischaemia_ceterm": "str",
    "ivig_freetext": "str",
    "jointpain_ceoccur_v2": "str",
    "ld_asd_ad_comorb": "str",
    "liver_gi_comorb": "str",
    "liverdysfunction_ceterm": "str",
    "los": "int",
    "los2": "int",
    "los_covid": "int",
    "los_covid2": "int",
    "lowerchest_ceoccur_v2": "str",
    "lymp_ceoccur_v2": "str",
    "malignantneo_mhyn": "str",
    "malnutrition_comorb": "str",
    "malnutrition_mhyn": "str",
    "max_crp": "float",
    "max_ferritin": "int",
    "max_inr": "float",
    "max_pt": "float",
    "max_resp_support": "str",
    "meningitis_ceterm": "str",
    "metabolic_comorb": "str",
    "mildliver": "str",
    "min_systolic": "int",
    "misc_cardiac": "str",
    "misc_considered_pims": "str",
    "misc_final_status": "str",
    "misc_immunomod": "str",
    "misc_iv_steroids": "str",
    "misc_ivig": "str",
    "misc_oral_steroids": "str",
    "misc_pcr": "str",
    "misc_serology": "str",
    "modliv": "str",
    "myalgia_ceoccur_v2": "str",
    "myocarditis_ceterm": "str",
    "neonate": "str",
    "neuro_comorb": "str",
    "neuro_comp": "str",
    "neurodisab_comorb": "str",
    "nhs_region": "str",
    "nitric": "str",
    "no_symptoms": "str",
    "nosocomial14": "str",
    "nosocomial2": "str",
    "nosocomial5": "str",
    "nosocomial7": "str",
    "obesity_comorb": "str",
    "obesity_mhyn": "str",
    "onset2admission": "int",
    "other_ceoccur": "str",
    "other_comorb": "str",
    "other_endo_comorb": "str",
    "other_ethnic": "str",
    "other_mhyn": "str",
    "oxy_vsorres": "int",
    "pancreat_ceterm": "str",
    "pews_crt": "int",
    "pews_gcs": "int",
    "pews_hr": "int",
    "pews_o2_rx": "int",
    "pews_over_2": "str",
    "pews_rr": "int",
    "pews_sbp": "int",
    "pews_spo2": "int",
    "pews_temp": "int",
    "pews_total": "int",
    "pims_freetext": "str",
    "pleuraleff_ceterm": "str",
    "pneumothorax_ceterm": "str",
    "postpart_rptestcd": "str",
    "pregout_rptestcd": "str",
    "pregyn_rptestcd": "str",
    "preterm_comorb": "str",
    "prone": "str",
    "pulmthromb_ceterm": "str",
    "rash_ceoccur_v2": "str",
    "readm_cov19": "str",
    "readminreas": "str",
    "renal_comorb": "str",
    "renal_mhyn": "str",
    "renalinjury_ceterm": "str",
    "resp_comorb": "str",
    "rhabdomyolsis_ceterm": "str",
    "rheum_comorb": "str",
    "rheumatologic_mhyn": "str",
    "rr_vsorres": "int",
    "runnynose_ceoccur_v2": "str",
    "second_wave": "int",
    "seizure_ceterm": "str",
    "seizures_cecoccur_v2": "str",
    "sex": "str",
    "shortbreath_ceoccur_v2": "str",
    "skinulcers_ceoccur_v2": "str",
    "smoking_mhyn": "str",
    "sorethroat_ceoccur_v2": "str",
    "stercap_vsorres": "str",
    "stroke_ceterm": "str",
    "supp_o2": "str",
    "surgefacil": "str",
    "susp_reinf": "str",
    "symp_or_assess_date": "date",
    "symptom_count": "int",
    "symptom_missing_count": "int",
    "sysbp_vsorres": "int",
    "temp_vsorres": "float",
    "vaccine_covid_trial": "str",
    "vomit_ceoccur_v2": "str",
    "vrialpneu_ceoccur": "str",
    "vulnerable_cancers": "str",
    "vulnerable_copd": "str",
    "vulnerable_immuno": "str",
    "vulnerable_preg": "str",
    "vulnerable_scid": "str",
    "vulnerable_transplant": "str",
    "wave": "str",
    "wheeze_ceoccur_v2": "str",
    "who_cardiac": "int",
    "who_coag": "int",
    "who_conjunct_rash": "int",
    "who_criteria": "int",
    "who_crp": "int",
    "who_fever": "int",
    "who_five_criteria": "int",
    "who_gi": "int",
    "who_hypotension": "int",
    "xray_prperf": "str",
}


def process_covariate_definitions(covariate_definitions):
    """
    Takes a dict of covariate definitions as supplied by the user (where the
    API is optimised for expressiveness and ease of use) and applies various
    transformations that make the structure easier to work with on the backend.
    """
    if "patient_id" in covariate_definitions:
        raise ValueError("patient_id is a reserved column name")
    covariate_definitions = flatten_nested_covariates(covariate_definitions)
    covariate_definitions = add_implied_fixed_value_columns(covariate_definitions)
    covariate_definitions = process_all_query_arguments(covariate_definitions)
    covariate_definitions = apply_compatibility_fixes_for_include_date(
        covariate_definitions
    )
    covariate_definitions = ensure_source_columns_generate_required_values(
        covariate_definitions
    )
    covariate_definitions = add_column_types(covariate_definitions)
    covariate_definitions = set_format_for_date_categories(covariate_definitions)
    check_for_consistent_aggregate_date_formats(covariate_definitions)
    return covariate_definitions


def flatten_nested_covariates(covariate_definitions):
    """
    Some covariates (e.g `categorised_as`) can define their own internal
    covariates which are used for calculating the column value but don't appear
    in the final output. Here we pull all these internal covariates out (which
    may be recursively nested) and assemble a flat list of covariates, adding a
    `hidden` flag to their arguments to indicate whether or not they belong in
    the final output

    We also check for any name clashes among covariates. (In future we could
    rewrite the names of internal covariates to avoid this but for now we just
    throw an error.)
    """
    flattened = {}
    hidden = set()
    items = list(covariate_definitions.items())
    while items:
        name, (query_type, query_args) = items.pop(0)
        if "extra_columns" in query_args:
            query_args = query_args.copy()
            # Pull out the extra columns
            extra_columns = query_args.pop("extra_columns")
            # Stick the query back on the stack
            items.insert(0, (name, (query_type, query_args)))
            # Mark the extra columns as hidden
            hidden.update(extra_columns.keys())
            # Add them to the start of the list of items to be processed
            items[:0] = extra_columns.items()
        else:
            if name in flattened:
                raise ValueError(f"Duplicate columns named '{name}'")
            flattened[name] = (query_type, query_args)
    for name, (query_type, query_args) in flattened.items():
        query_args["hidden"] = name in hidden
    return flattened


def add_implied_fixed_value_columns(covariate_definitions):
    """
    It's possible to use the minimum/maximum functions with fixed dates using the
    `fixed_value` function like so:

        max_date = patients.maximum_of(
            "some_date_column",
            "some_fixed_date",
            some_fixed_date=patients.fixed_value("2022-01-01"),
        )

    However this is slightly awkward: it requires making up an arbitrary (but unique)
    column name and then writing it twice. So instead we allow the same query to be
    specified using:

        max_date = patients.maximum_of("some_date_column", "2022-01-01")

    We do this by spotting that "2022-01-01" can't be a column name (it contains dashes)
    but does look like a date, so we can automatically construct the appropriate
    `fixed_value` column and rewrite the query to use that.
    """
    outputs = {}
    unique_names = make_unique_names("fixed_value", covariate_definitions)

    for name, (query_type, query_args) in covariate_definitions.items():

        if query_type == "aggregate_of":
            new_column_names = []
            for column_name in query_args["column_names"]:
                # If the column name is a date ...
                if is_iso_date(column_name):
                    # create a new `fixed_value` column using that date
                    fixed_value_column = (
                        "fixed_value",
                        {"value": column_name, "hidden": True},
                    )
                    # with an arbitrary unique name
                    fixed_value_name = next(unique_names)
                    # add it the column definitions
                    outputs[fixed_value_name] = fixed_value_column
                    # and use the newly defined column name as the input column
                    new_column_names.append(fixed_value_name)
                else:
                    new_column_names.append(column_name)
            # Create a copy of `query_args` which uses the new column names
            query_args = dict(query_args, column_names=new_column_names)

        outputs[name] = (query_type, query_args)

    return outputs


def make_unique_names(prefix, existing_names):
    counter = 0
    while True:
        counter += 1
        name = f"{prefix}_{counter}"
        if name not in existing_names:
            yield name


def process_all_query_arguments(covariate_definitions):
    return {
        name: (query_type, process_arguments(query_args))
        for name, (query_type, query_args) in covariate_definitions.items()
    }


def process_arguments(args):
    """
    This receives all arguments from calls to the public API functions so it
    can validate and, if necessary, modify them. In particular, it can be used
    to translate older style API calls into newer ones so as to maintain
    backwards compatibility.
    """
    args = handle_time_period_options(args)

    # Handle deprecated API
    if args.pop("return_binary_flag", None):
        args["returning"] = "binary_flag"
    if args.pop("return_number_of_matches_in_period", None):
        args["returning"] = "number_of_matches_in_period"
    if args.pop("return_first_date_in_period", None):
        args["returning"] = "date"
        args["find_first_match_in_period"] = True
    if args.pop("return_last_date_in_period", None):
        args["returning"] = "date"
        args["find_last_match_in_period"] = True

    # In the public API of the `with_these_medications` function we use the
    # phrase "clinical codes" (as opposed to just "codes") to make it clear
    # that these are distinct from the SNOMED codes used to query the
    # medications table. However, for simplicity of implementation we use just
    # one argument name internally
    if "ignore_days_where_these_clinical_codes_occur" in args:
        args["ignore_days_where_these_codes_occur"] = args.pop(
            "ignore_days_where_these_clinical_codes_occur"
        )

    args = handle_legacy_date_args(args)

    return args


def handle_time_period_options(args):
    """
    Convert the "on_or_before", "on_or_after" and "between" options we support
    for defining time periods into a single "between" argument. This makes the
    code simpler, although we want to continue supporting the three arguments
    for the sake of clarity in the API.
    """
    if "between" not in args:
        return args
    on_or_after = args.pop("on_or_after", None)
    on_or_before = args.pop("on_or_before", None)
    between = args["between"]
    if between and (on_or_after or on_or_before):
        raise ValueError(
            "You cannot set `between` at the same time as "
            "`on_or_after` or `on_or_before`"
        )
    if not between:
        between = (on_or_after, on_or_before)
    if not isinstance(between, (tuple, list)) or len(between) != 2:
        raise ValueError("`between` should be a pair of dates")
    args["between"] = between
    return args


def handle_legacy_date_args(args):
    """
    Change old style date format arguments to new style
    """
    include_month = args.pop("include_month", None)
    include_day = args.pop("include_day", None)
    if args.get("date_format") is not None:
        assert not include_month and not include_day
    elif include_day:
        args["date_format"] = "YYYY-MM-DD"
    elif include_month:
        args["date_format"] = "YYYY-MM"
    return args


def apply_compatibility_fixes_for_include_date(covariate_definitions):
    """
    Previously some covariate definitions could produce mutliple columns by
    passing a flag like `include_date_of_match` which would create an extra
    column of the form "<column_name>_date" in the output. This was to
    avoid having to define (and execute) the same query multiple times to
    get e.g. a blood pressure reading and also the date on which that
    reading was taken.

    However losing the one-one correspondence between the columns defined
    in the study definition and the columns produced in the output made the
    whole system more complex and harded to reason about. We now support
    the requirement by allowing colum definitions to reference other
    columns and say e.g. "column X should contain the date of the
    measurement produced by column Y"

    To maintain backwards compatibility this method finds variants of the
    "include_date" flag and automatically defines the corresponding date
    column.
    """
    updated = {}
    for name, (query_type, query_args) in covariate_definitions.items():
        query_args = query_args.copy()
        suffix = None
        if query_args.pop("include_date_of_match", False):
            suffix = "_date"
        if query_args.pop("include_measurement_date", False):
            suffix = "_date_measured"
        if suffix:
            date_kwargs = pop_keys_from_dict(query_args, ["date_format"])
            date_kwargs["source"] = name
            date_kwargs["returning"] = "date"
            date_kwargs["return_expectations"] = query_args.get("return_expectations")
            date_kwargs["hidden"] = query_args.get("hidden", False)
            updated[name] = (query_type, query_args)
            updated[name + suffix] = ("value_from", date_kwargs)
        else:
            updated[name] = (query_type, query_args)
    return updated


def ensure_source_columns_generate_required_values(covariate_definitions):
    """
    Where one column is defined as fetching an additional value generated by
    another column we need to tell that "source" column that it should generate
    those additional values.

    In the absence of a general mechanism for doing this we have to check the
    type of column and value in use and add arguments to the source column
    appropriately.

    For instance, if we have `a=patients.date_of("b")` then we need to make
    sure column `b` has the `include_date` flag set.
    """
    updated = copy.deepcopy(covariate_definitions)

    for name, (query_type, query_args) in updated.items():
        if query_type != "value_from":
            continue

        returning = query_args["returning"]
        source_column = query_args["source"]
        source_column_type, source_column_args = updated[source_column]

        if returning == "date":
            source_column_args.update(
                include_date_of_match=True,
                date_format=query_args.get("date_format"),
            )
        elif returning in ("lower_bound", "upper_bound", "comparator"):
            if (
                source_column_type != "with_these_clinical_events"
                or source_column_args["returning"] != "numeric_value"
            ):
                raise ValueError(
                    f"Can only fetch '{returning}' from a column of the form: "
                    f'with_these_clinical_events(returning="numeric_value")'
                )
            source_column_args.update(include_reference_range_columns=True)
        else:
            raise ValueError(f"Unhandled returning type '{returning}'")

    return updated


def add_column_types(covariate_definitions):
    get_column_type = GetColumnType()
    for name, (query_type, query_args) in covariate_definitions.items():
        query_args["column_type"] = get_column_type(name, query_type, query_args)
    return covariate_definitions


class GetColumnType:
    def __init__(self):
        self.column_types = {}

    def __call__(self, name, query_type, query_args):
        try:
            method = getattr(self, f"type_of_{query_type}")
        except AttributeError:
            raise ValueError(f"No column type method defined for {query_type}")
        column_type = method(**query_args)
        self.column_types[name] = column_type
        return column_type

    def type_of_value_from(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_age_as_of(self, **kwargs):
        return "int"

    def type_of_date_of_birth(self, **kwargs):
        return "date"

    def type_of_sex(self, **kwargs):
        return "str"

    def type_of_all(self, **kwargs):
        return "bool"

    def type_of_random_sample(self, **kwargs):
        return "bool"

    def type_of_most_recent_bmi(self, **kwargs):
        return "float"

    def type_of_mean_recorded_value(self, **kwargs):
        return "float"

    def type_of_min_recorded_value(self, **kwargs):
        return "float"

    def type_of_max_recorded_value(self, **kwargs):
        return "float"

    def type_of_registered_as_of(self, **kwargs):
        return "bool"

    def type_of_registered_with_one_practice_between(self, **kwargs):
        return "bool"

    def type_of_with_complete_history_between(self, **kwargs):
        return "bool"

    def type_of_date_deregistered_from_all_supported_practices(self, **kwargs):
        return "date"

    def type_of_with_these_medications(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_with_these_clinical_events(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_registered_practice_as_of(self, returning, **kwargs):
        if returning.startswith("rct__"):
            return self._type_of_rct_property(returning)
        else:
            return self._type_from_return_value(returning)

    def _type_of_rct_property(self, returning):
        property = returning.rpartition("__")[2]
        # `enrolled` is a special synthetic property which we use to indicate that
        # the practice was enrolled in the RCT and we have data for it
        if property == "enrolled":
            return "bool"
        # Everything else we treat as a string as it comes from a column in a
        # EAV table with type VARCHAR
        else:
            return "str"

    def type_of_address_as_of(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_admitted_to_icu(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_with_these_codes_on_death_certificate(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_died_from_any_cause(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_with_death_recorded_in_cpns(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_with_death_recorded_in_primary_care(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_with_vaccination_record(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_with_tpp_vaccination_record(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_with_gp_consultations(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_with_complete_gp_consultation_history_between(self, **kwargs):
        return "bool"

    def type_of_with_test_result_in_sgss(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_household_as_of(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_attended_emergency_care(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_admitted_to_hospital(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_with_high_cost_drugs(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_with_ethnicity_from_sus(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_with_these_decision_support_values(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_with_healthcare_worker_flag_on_covid_vaccine_record(
        self, returning, **kwargs
    ):
        return self._type_from_return_value(returning)

    def type_of_outpatient_appointment_date(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_with_value_from_file(self, returning_type, **kwargs):
        return returning_type

    def type_of_which_exist_in_file(self, **kwargs):
        return "bool"

    def type_of_with_covid_therapeutics(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def type_of_with_an_isaric_record(self, returning, **kwargs):
        return ISARIC_COLUMN_MAPPINGS[returning]

    def type_of_with_an_ons_cis_record(self, returning, **kwargs):
        if returning in ONS_CIS_CATEGORY_COLUMNS:
            return "str"
        elif returning in ONS_CIS_COLUMN_MAPPINGS:
            return ONS_CIS_COLUMN_MAPPINGS[returning]
        return self._type_from_return_value(returning)

    def type_of_with_record_in_ukrr(self, returning, **kwargs):
        return self._type_from_return_value(returning)

    def _type_from_return_value(self, returning):
        if returning == "nhse_region_name":
            raise ValueError(
                "'nhse_region_name' should be changed to the more accurate "
                "'nuts1_region_name'"
            )
        mapping = {
            "administrative_category": "str",
            "admission_method": "str",
            "admission_treatment_function_code": "str",
            "binary_flag": "bool",
            "case_category": "str",
            "category": "str",
            "code": "str",
            "comparator": "str",
            "consultation_medium_used": "str",
            "date": "date",
            "date_admitted": "date",
            "date_arrived": "date",
            "date_discharged": "date",
            "date_of_death": "date",
            "days_in_critical_care": "str",
            "discharge_destination": "str",
            "duration_of_elective_wait": "str",
            "group_16": "str",
            "group_6": "str",
            "had_advanced_respiratory_support": "bool",
            "had_basic_respiratory_support": "bool",
            "had_respiratory_support": "bool",
            "has_members_in_other_ehr_systems": "bool",
            "household_size": "int",
            "index_of_multiple_deprivation": "int",
            "is_prison": "bool",
            "latest_creatinine": "int",
            "latest_egfr": "float",
            "lower_bound": "float",
            "msoa": "str",
            "msoa_code": "str",
            "number_of_episodes": "int",
            "number_of_matches_in_period": "int",
            "numeric_value": "float",
            "nuts1_region_name": "str",
            "patient_classification": "str",
            "percentage_of_members_with_data_in_this_backend": "int",
            "place_of_death": "str",
            "primary_diagnosis": "str",
            "pseudo_id": "int",
            "region": "str",
            "renal_centre": "str",
            "risk_group": "str",
            "rrt_start_date": "date",
            "rural_urban_classification": "int",
            "s_gene_target_failure": "str",
            "source_of_admission": "str",
            "stp_code": "str",
            "symptomatic": "str",
            "therapeutic": "str",
            "total_bed_days_in_period": "int",
            "total_critical_care_days_in_period": "int",
            "treatment_modality_start": "str",
            "treatment_modality_prevalence": "str",
            "underlying_cause_of_death": "str",
            "upper_bound": "float",
            "variant": "str",
            "variant_detection_method": "str",
        }
        try:
            return mapping[returning]
        except KeyError:
            raise ValueError(f"No matching type for '{returning}'")

    def type_of_care_home_status_as_of(self, categorised_as, **kwargs):
        return self._infer_type_from_categories(categorised_as)

    def type_of_categorised_as(self, category_definitions, **kwargs):
        return self._infer_type_from_categories(category_definitions)

    def _infer_type_from_categories(self, category_definitions):
        # Convert date-like strings to dates
        categories = [
            datetime.date.fromisoformat(v) if is_iso_date(v) else v
            for v in category_definitions.keys()
        ]
        first_type = type(categories[0])
        for other in categories[1:]:
            if type(other) != first_type:
                raise ValueError(
                    f"Categories must all be the same type, found {first_type} "
                    f"and {type(other)}"
                )
        if first_type is int:
            if set(categories) == {0, 1}:
                return "bool"
            else:
                return "int"
        elif first_type is float:
            return "float"
        elif first_type is str:
            return "str"
        elif first_type is datetime.date:
            return "date"
        else:
            raise ValueError(f"Unhandled category type: {first_type}")

    def type_of_aggregate_of(self, column_names, aggregate_function, **kwargs):
        other_types = [self.column_types[name] for name in column_names]
        column_type = other_types.pop()
        for other_type in other_types:
            if other_type != column_type:
                raise ValueError(
                    f"Cannot calculate {aggregate_function} over columns of "
                    f"different types (found '{column_type}' and '{other_type}')"
                )
        return column_type

    def type_of_fixed_value(self, value, **kwargs):
        if is_iso_date(value):
            return "date"
        elif isinstance(value, bool):
            return "bool"
        elif isinstance(value, int):
            return "int"
        elif isinstance(value, float):
            return "float"
        elif isinstance(value, str):
            return "str"
        else:
            raise ValueError(f"Unhandled value: {value}")


def is_iso_date(value):
    return isinstance(value, str) and re.match(r"\d\d\d\d-\d\d-\d\d", value)


def set_format_for_date_categories(covariate_definitions):
    # It's convenient if we can assume that every column of type `date` has a
    # `date_format` argument. Dates defined using `categorised_as` expressions are
    # always in full ISO format.
    for name, (query_type, query_args) in covariate_definitions.items():
        if query_type == "categorised_as" and query_args["column_type"] == "date":
            query_args["date_format"] = "YYYY-MM-DD"
        # "fixed value" dates are also in full ISO format
        if query_type == "fixed_value" and query_args["column_type"] == "date":
            query_args["date_format"] = "YYYY-MM-DD"
    return covariate_definitions


def _get_date_formats(
    covariate_definitions, column_name, query_args, date_formats=None
):
    date_formats = date_formats or []
    if covariate_definitions[column_name][0] == "aggregate_of":
        assert query_args["column_type"] == "date"
        aggregate_query_args = covariate_definitions[column_name][1]
        for aggregate_column_name in aggregate_query_args["column_names"]:
            date_formats = _get_date_formats(
                covariate_definitions,
                aggregate_column_name,
                aggregate_query_args,
                date_formats,
            )
    else:
        date_formats.append(
            (column_name, covariate_definitions[column_name][1]["date_format"])
        )
    return date_formats


def check_for_consistent_aggregate_date_formats(covariate_definitions):
    for name, (query_type, query_args) in covariate_definitions.items():
        if query_type == "aggregate_of" and query_args["column_type"] == "date":
            # Get all the date formats for the columns that form the aggregate query
            # If one of the aggregate query's columns is itself an aggregate query,
            # retrieve the date formats recursively so we can check they all match
            date_formats = sum(
                [
                    _get_date_formats(covariate_definitions, column_name, query_args)
                    for column_name in query_args["column_names"]
                ],
                [],
            )
            column_name, target_format = date_formats.pop()
            for other_column, other_format in date_formats:
                if other_format != target_format:
                    raise ValueError(
                        f"Cannot calculate {query_args['aggregate_function']} over "
                        f"dates of different format:\n"
                        f"'{column_name}' has format '{target_format}' and "
                        f"'{other_column}' has '{other_format}'"
                    )


def pop_keys_from_dict(dictionary, keys):
    new_dict = {}
    for key in keys:
        if key in dictionary:
            new_dict[key] = dictionary.pop(key)
    return new_dict
