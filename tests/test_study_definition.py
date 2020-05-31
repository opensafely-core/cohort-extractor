import csv

import pytest

from datalab_cohorts import StudyDefinition, patients


def test_create_dummy_data_works_without_backend(tmp_path, monkeypatch):
    monkeypatch.delenv("BACKEND", raising=False)
    study = StudyDefinition(
        population=patients.all(),
        sex=patients.sex(
            return_expectations={
                "rate": "universal",
                "date": {"earliest": "1900-01-01", "latest": "today"},
                "category": {"ratios": {"M": 0.49, "F": 0.51}},
            }
        ),
        age=patients.age_as_of(
            "2020-01-01",
            return_expectations={
                "rate": "universal",
                "date": {"earliest": "1900-01-01", "latest": "2020-01-01"},
                "int": {"distribution": "population_ages"},
            },
        ),
    )
    filename = tmp_path / "dummy_data.csv"
    study.to_csv(filename, expectations_population=10)
    with open(filename) as f:
        results = list(csv.DictReader(f))
    assert len(results) == 10
    columns = results[0].keys()
    assert "sex" in columns
    assert "age" in columns


def test_export_data_without_backend_raises_error(tmp_path, monkeypatch):
    monkeypatch.delenv("BACKEND", raising=False)
    study = StudyDefinition(
        population=patients.all(),
        sex=patients.sex(),
        age=patients.age_as_of("2020-01-01",),
    )
    with pytest.raises(RuntimeError):
        study.to_csv(tmp_path / "dummy_data.csv")


def test_unrecognised_backend_raises_error(tmp_path, monkeypatch):
    monkeypatch.setenv("BACKEND", "BANANAS")
    with pytest.raises(ValueError):
        StudyDefinition(
            population=patients.all(),
            sex=patients.sex(),
            age=patients.age_as_of("2020-01-01",),
        )
