import csv

from tests.test_tpp_backend import set_database_url, setup_module, setup_function
from tests.tpp_backend_setup import (
    make_session,
    Patient,
    RegistrationHistory,
    Organisation,
    Vaccination,
    MedicationIssue,
    MedicationDictionary,
    CodedEvent,
)

from cohortextractor import codelist
from cohortextractor.dashboards.vaccinations import VaccinationsStudyDefinition


# Reference these imported functions to keep pyflakes happy and to make it
# clear these are functional pytest fixtures, not stray imports
set_database_url
setup_module
setup_function


def test_study_definition(tmp_path):
    session = make_session()
    session.add_all(
        [
            # This patient is too old and should be ignored
            Patient(Patient_ID=1, DateOfBirth="2002-05-04"),
            Patient(
                Patient_ID=2,
                DateOfBirth="2019-01-01",
                RegistrationHistory=[
                    RegistrationHistory(
                        StartDate="2019-01-10",
                        EndDate="9999-12-31",
                        Organisation=Organisation(Organisation_ID=678),
                    ),
                ],
            ),
            Patient(
                Patient_ID=3,
                DateOfBirth="2018-10-28",
                RegistrationHistory=[
                    RegistrationHistory(
                        StartDate="2010-01-01",
                        EndDate="2015-10-01",
                        Organisation=Organisation(Organisation_ID=123),
                    ),
                    # Deliberately overlapping registration histories
                    RegistrationHistory(
                        StartDate="2015-04-01",
                        EndDate="9999-12-31",
                        Organisation=Organisation(Organisation_ID=345),
                    ),
                ],
                Vaccinations=[
                    Vaccination(
                        VaccinationName="Infanrix Hexa", VaccinationDate="2018-11-01",
                    )
                ],
                MedicationIssues=[
                    MedicationIssue(
                        MedicationDictionary=MedicationDictionary(
                            DMD_ID="123", MultilexDrug_ID="123"
                        ),
                        ConsultationDate="2019-01-01",
                    ),
                ],
                CodedEvents=[CodedEvent(CTV3Code="abc", ConsultationDate="2019-06-01")],
            ),
        ]
    )
    session.commit()
    study = VaccinationsStudyDefinition(
        start_date="2017-06-01",
        get_registered_practice_at_months=[12, 24, 60],
        tpp_vaccine_codelist=codelist(
            [
                ("Infanrix Hexa", "dtap_hex"),
                ("Bexsero", "menb"),
                ("Rotarix", "rotavirus"),
                ("Prevenar", "pcv"),
                ("Prevenar - 13", "pcv"),
                ("Menitorix", "hib_menc"),
                ("Repevax", "dtap_ipv"),
                ("Boostrix-IPV", "dtap_ipv"),
                ("MMRvaxPRO", "mmr"),
                ("Priorix", "mmr"),
            ],
            system="tpp_vaccines",
        ),
        ctv3_vaccine_codelist=codelist([("abc", "menb")], system="ctv3"),
        snomed_vaccine_codelist=codelist([("123", "rotavirus")], system="snomed"),
        event_washout_period=14,
        vaccination_schedule=[
            "dtap_hex_1",
            "menb_1",
            "rotavirus_1",
            "dtap_hex_2",
            "pcv_1",
            "rotavirus_2",
            "dtap_hex_3",
            "menb_2",
            "hib_menc_1",
            "pcv_2",
            "mmr_1",
            "menb_3",
            "dtap_ipv_1",
            "mmr_2",
        ],
    )
    study.to_csv(tmp_path / "test.csv")
    with open(tmp_path / "test.csv", newline="") as f:
        reader = csv.DictReader(f)
        results = list(reader)
    assert results == [
        {
            "patient_id": "2",
            "date_of_birth": "2019-01-01",
            "practice_id_at_month_12": "678",
            "practice_id_at_month_24": "678",
            "practice_id_at_month_60": "678",
            "dtap_hex_1": "",
            "menb_1": "",
            "rotavirus_1": "",
            "dtap_hex_2": "",
            "pcv_1": "",
            "rotavirus_2": "",
            "dtap_hex_3": "",
            "menb_2": "",
            "hib_menc_1": "",
            "pcv_2": "",
            "mmr_1": "",
            "menb_3": "",
            "dtap_ipv_1": "",
            "mmr_2": "",
        },
        {
            "patient_id": "3",
            "date_of_birth": "2018-10-01",
            "practice_id_at_month_12": "345",
            "practice_id_at_month_24": "345",
            "practice_id_at_month_60": "345",
            "dtap_hex_1": "2018-11-01",
            "menb_1": "2019-06-01",
            "rotavirus_1": "2019-01-01",
            "dtap_hex_2": "",
            "pcv_1": "",
            "rotavirus_2": "",
            "dtap_hex_3": "",
            "menb_2": "",
            "hib_menc_1": "",
            "pcv_2": "",
            "mmr_1": "",
            "menb_3": "",
            "dtap_ipv_1": "",
            "mmr_2": "",
        },
    ]


def test_study_definition_dummy_data(tmp_path):
    study = VaccinationsStudyDefinition(
        start_date="2017-06-01",
        get_registered_practice_at_months=[12, 24, 60],
        tpp_vaccine_codelist=codelist(
            [
                ("Infanrix Hexa", "dtap_hex"),
                ("Bexsero", "menb"),
                ("Rotarix", "rotavirus"),
                ("Prevenar", "pcv"),
                ("Prevenar - 13", "pcv"),
                ("Menitorix", "hib_menc"),
                ("Repevax", "dtap_ipv"),
                ("Boostrix-IPV", "dtap_ipv"),
                ("MMRvaxPRO", "mmr"),
                ("Priorix", "mmr"),
            ],
            system="tpp_vaccines",
        ),
        ctv3_vaccine_codelist=codelist([("abc", "menb")], system="ctv3"),
        snomed_vaccine_codelist=codelist([("123", "rotavirus")], system="snomed"),
        event_washout_period=14,
        vaccination_schedule=[
            "dtap_hex_1",
            "menb_1",
            "rotavirus_1",
            "dtap_hex_2",
            "pcv_1",
            "rotavirus_2",
            "dtap_hex_3",
            "menb_2",
            "hib_menc_1",
            "pcv_2",
            "mmr_1",
            "menb_3",
            "dtap_ipv_1",
            "mmr_2",
        ],
    )
    study.to_csv(tmp_path / "dummy.csv", expectations_population=1000)
    with open(tmp_path / "dummy.csv", newline="") as f:
        reader = csv.DictReader(f)
        results = list(reader)
    assert len(results) == 1000
    headers = list(results[0].keys())
    assert headers == [
        "patient_id",
        "date_of_birth",
        "practice_id_at_month_12",
        "practice_id_at_month_24",
        "practice_id_at_month_60",
        "dtap_hex_1",
        "menb_1",
        "rotavirus_1",
        "dtap_hex_2",
        "pcv_1",
        "rotavirus_2",
        "dtap_hex_3",
        "menb_2",
        "hib_menc_1",
        "pcv_2",
        "mmr_1",
        "menb_3",
        "dtap_ipv_1",
        "mmr_2",
    ]
