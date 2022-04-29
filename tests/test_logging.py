import re
from datetime import datetime
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
    # get the cohortextractor-stats logs
    stats_log_events = [
        log_item
        for log_item in log_output
        # sometimes the logged event is a pandas DataFrame or Index, which
        # has ambiguous boolean value, so check if it's a string before checking its value
        if isinstance(log_item["event"], str)
        and log_item["event"] == "cohortextractor-stats"
    ]
    # return just the log parameters
    return [
        {k: v for k, v in log_item.items() if k not in ["event", "log_level"]}
        for log_item in stats_log_events
    ]


def get_logs_by_key(log_output, key):
    return [log_entry for log_entry in log_output if key in log_entry]


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
    # logs in tpp_backend during query execution
    expected_timing_descriptions_and_sql = [
        ("Uploading codelist for event", "CREATE TABLE #tmp1_event_codelist"),
        (None, "INSERT INTO #tmp1_event_codelist (code, category) VALUES\n[truncated]"),
        ("Query for event", "SELECT * INTO #event"),
        ("Query for population", "SELECT * INTO #population"),
        (
            "Join all columns for final output",
            "JOIN #event ON #event.patient_id = #population.patient_id",
        ),
    ]

    assert_stats_logs(
        logger, expected_initial_study_def_logs, expected_timing_descriptions_and_sql
    )


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

    expected_timing_descriptions_and_sql = [
        # logs in tpp_backend during query execution
        ("Query for sex", "SELECT * INTO #sex"),
        ("Query for population", "SELECT * INTO #population"),
        # logs specifically from study.to_file
        ("Writing results into #final_output", "SELECT * INTO #final_output"),
        (None, "CREATE INDEX ix_patient_id ON #final_output"),
        # results are fetched in batches for writing
        (None, "SELECT TOP 32000 * FROM #final_output"),
        (f"{write_to_file_log} {tmp_path}/input.{output_format}", ""),
        ("Deleting '#final_output'", "DROP TABLE #final_output"),
        # logging the overall timing for the cohort generation
        ("generate_cohort for study_definition", ""),
        ("generate_cohort for study_definition (all index dates)", ""),
    ]

    assert_stats_logs(
        logger, expected_initial_study_def_logs, expected_timing_descriptions_and_sql
    )


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
    for i, index_date in enumerate(expected_index_dates):
        if i == 0:
            index_date_timing_logs = [
                # logs in tpp_backend during query execution
                ("Query for sex", "SELECT * INTO #sex", False),
                ("Query for population", "SELECT * INTO #population", False),
                # logs specifically from study.to_file
                (
                    "Writing results into #final_output",
                    "SELECT * INTO #final_output",
                    False,
                ),
                (None, "CREATE INDEX ix_patient_id ON #final_output", False),
                # results are fetched in batches for writing
                (None, "SELECT TOP 32000 * FROM #final_output", False),
                (
                    f"write_rows_to_csv {tmp_path}/input_test_{index_date}.csv",
                    "",
                    False,
                ),
                ("Deleting '#final_output'", "DROP TABLE #final_output", False),
                # logging the overall timing for the cohort generation
                (
                    f"generate_cohort for study_definition_test at {index_date}",
                    "",
                    False,
                ),
            ]
        else:
            index_date_timing_logs.extend(
                [
                    # logs in tpp_backend during query execution (truncated SQL for any with >1 line of query)
                    ("Query for sex", "SELECT * INTO #sex", True),
                    ("Query for population", "SELECT * INTO #population", True),
                    # logs specifically from study.to_file
                    (
                        "Writing results into #final_output",
                        "SELECT * INTO #final_output",
                        True,
                    ),
                    # This is a single line of SQL output, so no truncation required
                    (None, "CREATE INDEX ix_patient_id ON #final_output", False),
                    # results are fetched in batches for writing
                    # This is a single line of SQL output, so no truncation required
                    (None, "SELECT TOP 32000 * FROM #final_output", False),
                    (
                        f"write_rows_to_csv {tmp_path}/input_test_{index_date}.csv",
                        "",
                        False,
                    ),
                    ("Deleting '#final_output'", "DROP TABLE #final_output", True),
                    # logging the overall timing for the cohort generation
                    (
                        f"generate_cohort for study_definition_test at {index_date}",
                        "",
                        False,
                    ),
                ]
            )

    expected_timing_descriptions_and_sql = [
        *index_date_timing_logs,
        ("generate_cohort for study_definition_test (all index dates)", "", False),
    ]
    assert_stats_logs(
        logger,
        expected_initial_study_def_logs,
        expected_timing_descriptions_and_sql,
        test_for_truncated_sql=True,
    )


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
    input_filepath = tmp_path / "input_2020-01-01.csv"
    with open(input_filepath, "w") as file_to_write:
        writer = csv.writer(file_to_write)
        writer.writerow(["patient_id", "has_code"])
        writer.writerow([1, 1])
        writer.writerow([2, 1])
        writer.writerow([3, 1])
        writer.writerow([4, 0])

    generate_measures(output_dir=tmp_path)

    stats_logs = get_stats_logs(logger.entries)
    assert len(stats_logs) == 9

    timing_logs = get_logs_by_key(stats_logs, "execution_time")
    memory_logs = get_logs_by_key(stats_logs, "memory")
    other_logs = [log for log in stats_logs if log not in [*timing_logs, *memory_logs]]

    measure_date = datetime(2020, 1, 1).date()
    expected_timing_logs = [
        (
            "Load patient dataframe for measures",
            {"date": measure_date, "input_file": str(input_filepath)},
        ),
        ("Calculate measure", {"measure_id": "has_code", "date": measure_date}),
        (
            "Calculate measure",
            {"measure_id": "has_code_one_group", "date": measure_date},
        ),
        (
            "generate_measures",
            {
                "input_file": str(input_filepath),
                "study": "study_definition",
                "date": measure_date,
            },
        ),
        ("generate_measures (all input files)", {"study": "study_definition"}),
    ]
    for i, timing_log in enumerate(timing_logs):
        description, log_params = expected_timing_logs[i]
        assert timing_log["description"] == description
        for key, value in log_params.items():
            assert timing_log[key] == value

    expected_memory_logs = [
        ("patient_df", measure_date, "has_code"),
        ("measure_df", measure_date, "has_code"),
        ("measure_df", measure_date, "has_code_one_group"),
    ]
    for i, memory_log in enumerate(memory_logs):
        df, measure_date, measure_id = expected_memory_logs[i]
        assert memory_log["dataframe"] == df
        assert memory_log["date"] == measure_date
        assert memory_log["measure_id"] == measure_id

    assert other_logs == [{"measures_count": 2}]


def assert_stats_logs(
    log_output,
    expected_initial_study_def_logs,
    expected_timing_descriptions,
    test_for_truncated_sql=False,
):
    all_stats_logs = get_stats_logs(log_output.entries)
    for log_params in expected_initial_study_def_logs:
        assert log_params in all_stats_logs

    timing_logs = get_logs_by_key(log_output.entries, "execution_time")
    assert len(timing_logs) == len(expected_timing_descriptions), timing_logs

    for i, timing_log in enumerate(timing_logs):
        actual_logged_sql = timing_log.get("sql", "")

        if test_for_truncated_sql:
            (
                description,
                expected_logged_sql,
                is_truncated,
            ) = expected_timing_descriptions[i]
            assert expected_logged_sql in actual_logged_sql
            assert actual_logged_sql.endswith("\n[truncated]") == is_truncated
        else:
            description, expected_logged_sql = expected_timing_descriptions[i]
            assert expected_logged_sql in actual_logged_sql

        assert timing_log["description"] == description

        assert re.match(r"\d:\d{2}:\d{2}.\d{6}", timing_log["execution_time"]).group(
            0
        ), timing_log["execution_time"]

    # Make sure we've checked all the stats logs
    assert len(all_stats_logs) == len(expected_initial_study_def_logs) + len(
        timing_logs
    )
