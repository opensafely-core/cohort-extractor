from cohortextractor.dashboards.vaccinations_combine import (
    add_patient_vaccination_dates,
)


def test_add_patient_vaccination_dates():
    patients = [
        {"patient_id": "91", "some_field": "some_value"},
        {"patient_id": "456", "some_field": "some_other_value"},
        {"patient_id": "789", "some_field": "different_value"},
    ]
    vaccination_events = [
        {"patient_id": "91", "vaccine_name": "menb", "date_given": "2018-01-15"},
        # This second event should be ignored as a duplicate
        {"patient_id": "91", "vaccine_name": "menb", "date_given": "2018-01-20"},
        # But this one should be included
        {"patient_id": "91", "vaccine_name": "menb", "date_given": "2018-03-05"},
        {"patient_id": "789", "vaccine_name": "pcv", "date_given": "2018-08-08"},
        {"patient_id": "789", "vaccine_name": "pcv", "date_given": "2019-06-10"},
    ]
    results = add_patient_vaccination_dates(
        patients, vaccination_events, washout_period=14
    )
    results = list(results)
    assert results == [
        {
            "patient_id": "91",
            "some_field": "some_value",
            "menb_1": "2018-01-01",
            "menb_2": "2018-03-01",
        },
        # This patient had no vaccine events at all but should still be
        # included in the output
        {"patient_id": "456", "some_field": "some_other_value"},
        {
            "patient_id": "789",
            "some_field": "different_value",
            "pcv_1": "2018-08-01",
            "pcv_2": "2019-06-01",
        },
    ]
