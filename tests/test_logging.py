import re
from unittest.mock import patch

import pytest
import structlog

from cohortextractor import StudyDefinition, codelist, patients
from cohortextractor.cohortextractor import generate_cohort, generate_measures
from cohortextractor.log_utils import timing_log_counter
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
    # The query counter is a global at the module level, so it isn't reset between tests
    # Find its current position
    start_counter = next(timing_log_counter)

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

    expected_timing_log_params = [
        dict(
            description="Uploading codelist for event",
            timing="start",
            state="started",
            timing_id=start_counter + 1,
        ),
        dict(
            sql="CREATE TABLE #tmp1_event_codelist",
            timing_id=start_counter + 1,
        ),
        dict(
            description="Uploading codelist for event",
            timing="stop",
            state="ok",
            timing_id=start_counter + 1,
        ),
        dict(
            description=None,
            timing="start",
            state="started",
            timing_id=start_counter + 2,
        ),
        dict(
            sql="INSERT INTO #tmp1_event_codelist (code, category) VALUES\n[truncated]",
            is_truncated=True,
            timing_id=start_counter + 2,
        ),
        dict(description=None, timing="stop", state="ok", timing_id=start_counter + 2),
        dict(
            description="Query for event",
            timing="start",
            state="started",
            timing_id=start_counter + 3,
        ),
        dict(
            sql="SELECT * INTO #event",
            timing_id=start_counter + 3,
        ),
        dict(
            description="Query for event",
            timing="stop",
            state="ok",
            timing_id=start_counter + 3,
        ),
        dict(
            description="Query for population",
            timing="start",
            state="started",
            timing_id=start_counter + 4,
        ),
        dict(
            sql="SELECT * INTO #population",
            timing_id=start_counter + 4,
        ),
        dict(
            description="Query for population",
            timing="stop",
            state="ok",
            timing_id=start_counter + 4,
        ),
        dict(
            description="Join all columns for final output",
            timing="start",
            state="started",
            timing_id=start_counter + 5,
        ),
        dict(
            sql="JOIN #event ON #event.patient_id = #population.patient_id",
            timing_id=start_counter + 5,
        ),
        dict(
            description="Join all columns for final output",
            timing="stop",
            state="ok",
            timing_id=start_counter + 5,
        ),
    ]

    assert_stats_logs(
        logger, expected_initial_study_def_logs, expected_timing_log_params
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
    # The query counter is a global at the module level, so it isn't reset between tests
    # Find its current position
    start_counter = next(timing_log_counter)

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

    expected_timing_log_params = [
        # logging the start of overall timing for the cohort generation
        dict(
            description="generate_cohort",
            study_definition="study_definition",
            index_date="all",
            timing="start",
            state="started",
            timing_id=start_counter + 1,
        ),
        dict(
            description="generate_cohort",
            study_definition="study_definition",
            timing="start",
            state="started",
            timing_id=start_counter + 2,
        ),
        # logs in tpp_backend during query execution
        dict(
            description="Query for sex",
            timing="start",
            state="started",
            timing_id=start_counter + 3,
        ),
        dict(
            sql="SELECT * INTO #sex",
            is_truncated=False,
            timing_id=start_counter + 3,
        ),
        dict(
            description="Query for sex",
            timing="stop",
            state="ok",
            timing_id=start_counter + 3,
        ),
        dict(
            description="Query for population",
            timing="start",
            state="started",
            timing_id=start_counter + 4,
        ),
        dict(
            sql="SELECT * INTO #population",
            is_truncated=False,
            timing_id=start_counter + 4,
        ),
        dict(
            description="Query for population",
            timing="stop",
            state="ok",
            timing_id=start_counter + 4,
        ),
        # logs specifically from study.to_file
        dict(
            description="Writing results into #final_output",
            timing="start",
            state="started",
            timing_id=start_counter + 5,
        ),
        dict(
            sql="SELECT * INTO #final_output",
            is_truncated=False,
            timing_id=start_counter + 5,
        ),
        dict(
            description="Writing results into #final_output",
            timing="stop",
            state="ok",
            timing_id=start_counter + 5,
        ),
        dict(
            description=None,
            timing="start",
            state="started",
            timing_id=start_counter + 6,
        ),
        dict(
            sql="CREATE INDEX ix_patient_id ON #final_output",
            is_truncated=False,
            timing_id=start_counter + 6,
        ),
        dict(description=None, timing="stop", state="ok", timing_id=start_counter + 6),
        # results are fetched in batches for writing
        dict(
            description=f"{write_to_file_log} {tmp_path}/input.{output_format}",
            timing="start",
            state="started",
            timing_id=start_counter + 7,
        ),
        dict(
            description=None,
            timing="start",
            state="started",
            timing_id=start_counter + 8,
        ),
        dict(
            sql="SELECT TOP 32000 * FROM #final_output",
            is_truncated=False,
            timing_id=start_counter + 8,
        ),
        dict(description=None, timing="stop", state="ok", timing_id=start_counter + 8),
        dict(
            description="Fetch batched results ",
            timing="start",
            state="started",
            timing_id=start_counter + 9,
        ),
        dict(
            description="Fetch batched results ",
            timing="stop",
            state="ok",
            timing_id=start_counter + 9,
        ),
        dict(
            description=f"{write_to_file_log} {tmp_path}/input.{output_format}",
            timing="stop",
            state="ok",
            timing_id=start_counter + 7,
        ),
        dict(
            description="Deleting '#final_output'",
            timing="start",
            state="started",
            timing_id=start_counter + 10,
        ),
        dict(
            sql="DROP TABLE #final_output",
            is_truncated=False,
            timing_id=start_counter + 10,
        ),
        dict(
            description="Deleting '#final_output'",
            timing="stop",
            state="ok",
            timing_id=start_counter + 10,
        ),
        # logging the overall timing for the cohort generation
        dict(
            description="generate_cohort",
            study_definition="study_definition",
            timing="stop",
            state="ok",
            timing_id=start_counter + 2,
        ),
        dict(
            description="generate_cohort",
            study_definition="study_definition",
            index_date="all",
            timing="stop",
            state="ok",
            timing_id=start_counter + 1,
        ),
    ]

    assert_stats_logs(
        logger, expected_initial_study_def_logs, expected_timing_log_params
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
    # The query counter is a global at the module level, so it isn't reset between tests
    # Find its current position by incrementing it once more
    start_counter = next(timing_log_counter)

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

    # The log function will increment the counter again from its starting value
    first_counter = start_counter + 1

    expected_timing_log_params = [
        # logging the start of overall timing for the cohort generation
        dict(
            description="generate_cohort",
            study_definition="study_definition_test",
            index_date="all",
            timing="start",
            state="started",
            timing_id=first_counter,
        )
    ]

    # find the value of the next counter, the start of the timing logs for the first index date
    next_counter = first_counter + 1

    for i, index_date in enumerate(expected_index_dates, start=1):
        expected_timing_log_params.extend(
            [
                dict(
                    description="generate_cohort",
                    study_definition="study_definition_test",
                    timing="start",
                    state="started",
                    timing_id=next_counter,
                ),
                # logs in tpp_backend during query execution
                dict(
                    description="Query for sex",
                    timing="start",
                    state="started",
                    timing_id=next_counter + 1,
                ),
                dict(
                    sql="SELECT * INTO #sex",
                    is_truncated=i != 1,
                    timing_id=next_counter + 1,
                ),
                dict(
                    description="Query for sex",
                    timing="stop",
                    state="ok",
                    timing_id=next_counter + 1,
                ),
                dict(
                    description="Query for population",
                    timing="start",
                    state="started",
                    timing_id=next_counter + 2,
                ),
                dict(
                    sql="SELECT * INTO #population",
                    is_truncated=i != 1,
                    timing_id=next_counter + 2,
                ),
                dict(
                    description="Query for population",
                    timing="stop",
                    state="ok",
                    timing_id=next_counter + 2,
                ),
                # logs specifically from study.to_file
                dict(
                    description="Writing results into #final_output",
                    timing="start",
                    state="started",
                    timing_id=next_counter + 3,
                ),
                dict(
                    sql="SELECT * INTO #final_output",
                    is_truncated=i != 1,
                    timing_id=next_counter + 3,
                ),
                dict(
                    description="Writing results into #final_output",
                    timing="stop",
                    state="ok",
                    timing_id=next_counter + 3,
                ),
                dict(
                    description=None,
                    timing="start",
                    state="started",
                    timing_id=next_counter + 4,
                ),
                dict(
                    sql="CREATE INDEX ix_patient_id ON #final_output",
                    is_truncated=False,
                    timing_id=next_counter + 4,
                ),
                dict(
                    description=None,
                    timing="stop",
                    state="ok",
                    timing_id=next_counter + 4,
                ),
                # results are fetched in batches for writing
                dict(
                    description=f"write_rows_to_csv {tmp_path}/input_test_{index_date}.csv",
                    timing="start",
                    state="started",
                    timing_id=next_counter + 5,
                ),
                dict(
                    description=None,
                    timing="start",
                    state="started",
                    is_truncated=False,
                    timing_id=next_counter + 6,
                ),
                dict(
                    sql="SELECT TOP 32000 * FROM #final_output",
                    is_truncated=False,
                    timing_id=next_counter + 6,
                ),
                dict(
                    description=None,
                    timing="stop",
                    state="ok",
                    timing_id=next_counter + 6,
                ),
                dict(
                    description="Fetch batched results ",
                    timing="start",
                    state="started",
                    timing_id=next_counter + 7,
                ),
                dict(
                    description="Fetch batched results ",
                    timing="stop",
                    state="ok",
                    timing_id=next_counter + 7,
                ),
                dict(
                    description=f"write_rows_to_csv {tmp_path}/input_test_{index_date}.csv",
                    timing="stop",
                    state="ok",
                    timing_id=next_counter + 5,
                ),
                dict(
                    description="Deleting '#final_output'",
                    timing="start",
                    state="started",
                    timing_id=next_counter + 8,
                ),
                dict(
                    sql="DROP TABLE #final_output",
                    is_truncated=i != 1,
                    timing_id=next_counter + 8,
                ),
                dict(
                    description="Deleting '#final_output'",
                    timing="stop",
                    state="ok",
                    timing_id=next_counter + 8,
                ),
                # logging the overall timing for the cohort generation
                dict(
                    description="generate_cohort",
                    study_definition="study_definition_test",
                    timing="stop",
                    state="ok",
                    timing_id=next_counter,
                ),
            ]
        )
        # set next counter to one more than the max for this index date
        next_counter += 8 + 1

    # add the log for the end of overall timing for the cohort generation; this should have the same
    # id as the first timing log
    expected_timing_log_params.append(
        dict(
            description="generate_cohort",
            study_definition="study_definition_test",
            index_date="all",
            timing="stop",
            state="ok",
            timing_id=first_counter,
        )
    )
    assert_stats_logs(
        logger,
        expected_initial_study_def_logs,
        expected_timing_log_params,
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

    # initial stats
    expected_initial_logs = [{"measures_count": 2}]

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
    memory_logs = get_logs_by_key(stats_logs, "memory")

    measure_date = "2020-01-01"
    expected_timing_logs = [
        dict(
            description="generate_measures",
            input_file="all",
            study_definition="study_definition",
            timing="start",
            state="started",
        ),
        dict(
            description="generate_measures",
            date=measure_date,
            input_file=str(input_filepath),
            study_definition="study_definition",
            timing="start",
            state="started",
        ),
        dict(
            description="Load patient dataframe for measures",
            date=measure_date,
            input_file=str(input_filepath),
            timing="start",
            state="started",
        ),
        dict(
            description="Load patient dataframe for measures",
            date=measure_date,
            input_file=str(input_filepath),
            timing="stop",
            state="ok",
        ),
        dict(
            description="Calculate measure",
            measure_id="has_code",
            date=measure_date,
            timing="start",
            state="started",
        ),
        dict(
            description="Calculate measure",
            measure_id="has_code",
            date=measure_date,
            timing="stop",
            state="ok",
        ),
        dict(
            description="Calculate measure",
            measure_id="has_code_one_group",
            date=measure_date,
            timing="start",
            state="started",
        ),
        dict(
            description="Calculate measure",
            measure_id="has_code_one_group",
            date=measure_date,
            timing="stop",
            state="ok",
        ),
        dict(
            description="generate_measures",
            date=measure_date,
            input_file=str(input_filepath),
            study_definition="study_definition",
            timing="stop",
            state="ok",
        ),
        dict(
            description="generate_measures",
            input_file="all",
            study_definition="study_definition",
            timing="stop",
            state="ok",
        ),
    ]
    assert_stats_logs(logger, expected_initial_logs + memory_logs, expected_timing_logs)

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


def test_stats_logging_with_error(logger):
    study = StudyDefinition(
        population=patients.all(),
        event=patients.with_these_clinical_events(codelist(["A"], "snomed")),
    )

    # insert a deliberate error in the queries
    study.backend.queries[-1] = "SELECT Foo FROM Bar"
    with pytest.raises(Exception) as excinfo:
        study.to_dicts()

    # The error is raised as expected
    assert "Invalid object name 'Bar'" in str(excinfo.value)

    # Timing is logged, with the error state in the end log
    (sql_log,) = [
        log for log in logger.entries if log.get("sql") == "SELECT Foo FROM Bar"
    ]
    (end_log,) = [
        log
        for log in logger.entries
        if log.get("timing_id") == sql_log["timing_id"] and log.get("timing") == "stop"
    ]
    assert end_log["state"] == "error"


def assert_stats_logs(
    log_output,
    expected_initial_study_def_logs,
    expected_timing_log_params,
):
    all_stats_logs = get_stats_logs(log_output.entries)
    for log_params in expected_initial_study_def_logs:
        assert log_params in all_stats_logs

    timing_logs = get_logs_by_key(log_output.entries, "timing_id")

    assert len(timing_logs) == len(expected_timing_log_params), timing_logs
    for i, timing_log in enumerate(timing_logs):
        actual_logged_sql = timing_log.get("sql", "")

        expected = expected_timing_log_params[i]
        is_truncated = expected.pop("is_truncated", False)
        expected_logged_sql = expected.pop("sql", "")
        assert actual_logged_sql.endswith("\n[truncated]") == is_truncated
        assert expected_logged_sql in actual_logged_sql

        for key, value in expected_timing_log_params[i].items():
            assert timing_log[key] == value

        if timing_log.get("state") != "started" and not actual_logged_sql:
            assert re.match(
                r"\d:\d{2}:\d{2}.\d{6}", timing_log["execution_time"]
            ).group(0), timing_log["execution_time"]

    # Make sure we've checked all the stats logs
    assert len(all_stats_logs) == len(expected_initial_study_def_logs) + len(
        timing_logs
    )
