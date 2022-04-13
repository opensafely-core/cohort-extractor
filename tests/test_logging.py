import re
from unittest.mock import patch

import pytest
import structlog

from cohortextractor import StudyDefinition, codelist, patients
from cohortextractor.cohortextractor import generate_cohort, generate_measures
from tests.test_tpp_backend import (  # noqa: F401; We need to import these for setup for the tests that require a tpp database;
    set_database_url,
    setup_function,
    setup_module,
    teardown_module,
)


@pytest.fixture(name="logger")
def fixture_logger():
    """Modify `capture_logs` to keep reference to `processors` list intact,
    in order to also modify bound loggers which get the list assigned by reference.

    See https://github.com/hynek/structlog/issues/408
    """
    cap = structlog.testing.LogCapture()
    # Modify `_Configuration.default_processors` set via `configure` but always keep
    # the list instance intact to not break references held by bound loggers.
    processors = structlog.get_config()["processors"]
    old_processors = processors[:]  # copy original processors
    try:
        processors.clear()  # clear processors list
        processors.append(cap)  # append the LogCapture processor for testing
        structlog.configure(processors=processors)
        yield cap
    finally:
        processors.clear()  # remove LogCapture
        processors.extend(old_processors)  # restore original processors
        structlog.configure(processors=processors)


def get_stats_logs(log_output):
    return [
        {k: v for k, v in log_item.items() if k not in ["event", "log_level"]}
        for log_item in log_output
        if isinstance(log_item["event"], str)
        and log_item["event"] == "cohortextractor-stats"
    ]


def get_timing_logs(log_output):
    return [log_entry for log_entry in log_output.entries if "target" in log_entry]


def test_study_definition_initial_stats_logging(logger):
    StudyDefinition(
        default_expectations={
            "rate": "exponential_increase",
            "incidence": 0.2,
            "date": {"earliest": "1900-01-01", "latest": "today"},
        },
        population=patients.all(),
        event_date_1=patients.with_these_clinical_events(
            codelist(["A"], system="ctv3"),
            returning="date",
            date_format="YYYY-MM-DD",
        ),
        event_min_date=patients.minimum_of(
            "event_date_1",
            event_date_2=patients.with_these_clinical_events(
                codelist(["B", "C"], system="ctv3"),
                returning="date",
                date_format="YYYY-MM-DD",
            ),
        ),
    )
    assert get_stats_logs(logger.entries) == [
        # output columns include patient_id, and the 4 variables defined in the
        # study defniiton, including event_date_2, which is defined as a parameter to
        # event_min_date
        # tables - Patient, temp event table for each codelist
        {"output_column_count": 5, "table_count": 3, "table_joins_count": 2},
        # variable_count is a count of the top-level variables defined in the study def (i.e. not event_date_2)
        {"variable_count": 4},
        # 2 variables use a codelist (event_date_1, and the nested event_date_2)
        {"variables_using_codelist_count": 2},
        # for each variable using a codelist, we log the size of the codelist
        {"variable_using_codelist": "event_date_1", "codelist_size": 1},
        {"variable_using_codelist": "event_date_2", "codelist_size": 2},
    ]


def test_stats_logging_tpp_backend(logger):
    study = StudyDefinition(
        population=patients.all(),
        event=patients.with_these_clinical_events(codelist(["A"], "snomed")),
    )
    study.to_dicts()

    # initial stats
    expected_initial_study_def_logs = [
        # output columns include patient_id, and the 2 variables defined in the
        # study defniiton
        # tables - Patient, temp event table for codelist
        {"output_column_count": 3, "table_count": 2, "table_joins_count": 1},
        {"variable_count": 2},
        {"variables_using_codelist_count": 1},
        {"variable_using_codelist": "event", "codelist_size": 1},
    ]

    # timing stats
    expected_timing_targets = [
        "Uploading codelist for event",
        "INSERT INTO #tmp1_event_codelist (code, category) ...",
        "Query for event",
        "Query for population",
        "Join all columns for final output",
    ]

    assert_stats_logs(logger, expected_initial_study_def_logs, expected_timing_targets)


@patch("cohortextractor.cohortextractor.preflight_generation_check")
@patch(
    "cohortextractor.cohortextractor.list_study_definitions",
    return_value=[("study_definition", "")],
)
@patch("cohortextractor.cohortextractor.load_study_definition")
@pytest.mark.parametrize(
    "output_format,write_to_file_log",
    [
        ("csv", "write_rows_to_csv"),
        ("dta", "Create df and write dataframe_to_file"),
    ],
)
def test_stats_logging_generate_cohort(
    mock_load,
    _mock_list,
    _mock_check,
    tmp_path,
    logger,
    output_format,
    write_to_file_log,
):
    mock_load.return_value = StudyDefinition(
        default_expectations={
            "date": {"earliest": "1900-01-01", "latest": "today"},
        },
        population=patients.all(),
        sex=patients.sex(),
    )

    generate_cohort(
        output_dir=tmp_path,
        expectations_population=None,
        dummy_data_file=None,
        output_format=output_format,
    )

    # initial stats
    expected_initial_study_def_logs = [
        # these 3 are logged from StudyDefinition instantiation
        # patient_id, population, sex - all from patient table, but we make one temp # table per variable
        {"output_column_count": 3, "table_count": 2, "table_joins_count": 1},
        {"variable_count": 2},  # population, sex
        {"variables_using_codelist_count": 0},
        # index_date_count logged from generate_cohort
        {"index_date_count": 0},
    ]

    expected_timing_targets = [
        # logs in tpp_backend during query execution
        "Query for sex",
        "Query for population",
        # logs specifically from study.to_file
        "Writing results into #final_output",
        "CREATE INDEX ix_patient_id ON #final_output (patie...",
        f"{write_to_file_log} {tmp_path}/input.{output_format}",
        "Deleting '#final_output'",
        # logging the overall timing for the cohort generation
        "generate_cohort for study_definition",
        "generate_cohort for study_definition (all index dates)",
    ]

    assert_stats_logs(logger, expected_initial_study_def_logs, expected_timing_targets)


@patch("cohortextractor.cohortextractor.preflight_generation_check")
@patch(
    "cohortextractor.cohortextractor.list_study_definitions",
    return_value=[("study_definition_test", "_test")],
)
@patch("cohortextractor.cohortextractor.load_study_definition")
def test_stats_logging_generate_cohort_with_index_dates(
    mock_load, _mock_list, _mock_check, logger, tmp_path
):
    mock_load.return_value = StudyDefinition(
        default_expectations={
            "date": {"earliest": "1900-01-01", "latest": "today"},
        },
        population=patients.all(),
        sex=patients.sex(),
    )

    generate_cohort(
        output_dir=tmp_path,
        expectations_population=None,
        dummy_data_file=None,
        index_date_range="2020-01-01 to 2020-03-01 by month",
    )

    expected_index_dates = ["2020-03-01", "2020-02-01", "2020-01-01"]

    # initial stats
    expected_initial_study_def_logs = [
        # these 3 are logged from StudyDefinition instantiation
        {"variable_count": 2},  # population, sex
        {"variables_using_codelist_count": 0},
        # index_date_count logged from generate_cohort
        {"index_date_count": 3},
        {"min_index_date": "2020-01-01", "max_index_date": "2020-03-01"},
        # output_column/table/joins_count is logged in tpp_backend on backend instantiation so it's repeated for each index date
        *[{"output_column_count": 3, "table_count": 2, "table_joins_count": 1}] * 4,
        *[
            {"resetting_backend_index_date": ix_date}
            for ix_date in expected_index_dates
        ],
    ]

    index_date_timing_logs = []
    for index_date in expected_index_dates:
        index_date_timing_logs.extend(
            [
                # logs in tpp_backend during query execution
                "Query for sex",
                "Query for population",
                # logs specifically from study.to_file
                "Writing results into #final_output",
                "CREATE INDEX ix_patient_id ON #final_output (patie...",
                f"write_rows_to_csv {tmp_path}/input_test_{index_date}.csv",
                "Deleting '#final_output'",
                # logging the overall timing for the cohort generation
                f"generate_cohort for study_definition_test at {index_date}",
            ]
        )

    expected_timing_targets = [
        *index_date_timing_logs,
        "generate_cohort for study_definition_test (all index dates)",
    ]
    assert_stats_logs(logger, expected_initial_study_def_logs, expected_timing_targets)


@patch("cohortextractor.cohortextractor.preflight_generation_check")
@patch(
    "cohortextractor.cohortextractor.list_study_definitions",
    return_value=[("study_definition", "")],
)
@patch("cohortextractor.cohortextractor.load_study_definition")
def test_stats_logging_generate_measures(
    mock_load, _mock_list, _mock_check, logger, tmp_path
):
    import csv

    from cohortextractor.measure import Measure

    measures = [
        Measure(
            id="has_code",
            numerator="has_code",
            denominator="population",
        ),
        Measure(
            id="has_code_one_group",
            numerator="has_code",
            denominator="population",
            group_by="population",
        ),
    ]

    mock_load.return_value = measures

    # set up an expected input file
    with open(tmp_path / "input_2020-01-01.csv", "w") as output_file:
        writer = csv.writer(output_file)
        writer.writerow(["patient_id", "has_code"])
        writer.writerow([1, 1])
        writer.writerow([2, 1])
        writer.writerow([3, 1])
        writer.writerow([4, 0])

    generate_measures(output_dir=tmp_path)

    stats_logs = get_stats_logs(logger.entries)
    assert len(stats_logs) == 2
    assert stats_logs[0] == {"measures_count": 2}
    assert "execution_time" in stats_logs[1]
    assert (
        stats_logs[1]["target"]
        == f"generate_measures for {tmp_path}/input_2020-01-01.csv"
    )


def assert_stats_logs(
    log_output, expected_initial_study_def_logs, expected_timing_targets
):
    all_stats_logs = get_stats_logs(log_output.entries)
    for log_params in expected_initial_study_def_logs:
        assert log_params in all_stats_logs

    timing_logs = get_timing_logs(log_output)
    assert len(timing_logs) == len(expected_timing_targets), timing_logs

    for i, timing_log in enumerate(timing_logs):
        assert timing_log["target"] == expected_timing_targets[i]
        assert re.match(r"\d:\d{2}:\d{2}.\d{6}", timing_log["execution_time"]).group(
            0
        ), timing_log["execution_time"]

    # Make sure we've checked all the stats logs
    assert len(all_stats_logs) == len(expected_initial_study_def_logs) + len(
        timing_logs
    )
