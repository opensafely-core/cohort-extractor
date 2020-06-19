import csv
import datetime
import os
import tempfile

from cohortextractor.mssql_utils import mssql_query_to_csv_file
from .vaccinations_extract import (
    patients_with_ages_and_practices_sql,
    vaccination_events_sql,
)
from .vaccinations_combine import add_patient_vaccination_dates


class VaccinationsStudyDefinition:
    def __init__(
        self,
        #
        # This is the first date for which we need data. If the maximum age
        # threshold (see below) is 5 then we will only include data on patients
        # born less than 5 years before this date.
        start_date=None,
        #
        # Each age here produces a corresponding column in the final output:
        # "practice_id_at_age_N" giving the psuedo-id of the practice where the
        # patient was registered on their Nth birthday
        get_registered_practice_at_ages=None,
        #
        # Each of these codelists should be a categorised codelist mapping
        # individual codes to the vaccine they correspond to. For instance, the
        # standard childhood immunisations in the TPP vaccinations table would
        # be written:
        #
        # tpp_vaccine_codelist=codelist(
        #     [
        #         ("Infanrix Hexa", "dtap_hex"),
        #         ("Bexsero", "menb"),
        #         ("Rotarix", "rotavirus"),
        #         ("Prevenar", "pcv"),
        #         ("Prevenar - 13", "pcv"),
        #         ("Menitorix", "hib_menc"),
        #         ("Repevax", "dtap_ipv"),
        #         ("Boostrix-IPV", "dtap_ipv"),
        #         ("MMRvaxPRO", "mmr"),
        #         ("Priorix", "mmr"),
        #     ],
        #     system="tpp_vaccines",
        # )
        #
        # Note that the internal codes we use here (dtap_hex, menb) etc don't
        # correspond to anything in particular.  They just need to match the
        # names used in defining the `vaccination_schedule` below, which in
        # turn define the columns which appear in the output.
        tpp_vaccine_codelist=None,
        ctv3_vaccine_codelist=None,
        snomed_vaccine_codelist=None,
        #
        # Because we're sourcing vaccination data from multiple tables it's
        # possible that a single event will get recorded in multiple places,
        # possibly even at slightly different times. To workaround these we
        # only consider events as unique once a "washout period" has expired,
        # starting from the first time we see an event for a particular vaccine
        # type.  The washout period is defined in days.
        event_washout_period=None,
        #
        # This is a list of vaccines in the order in which they are expected to
        # be given. They are written as "<vaccine_id>_<dose_index>". Each of
        # these will appear as columns in the final output with a date (rounded
        # to first of month) when that dose of that vaccine was administered.
        # The standard childhood immunisation schedule is written as:
        #
        # vaccination_schedule=[
        #     "dtap_hex_1",
        #     "menb_1",
        #     "rotavirus_1",
        #     "dtap_hex_2",
        #     "pcv_1",
        #     "rotavirus_2",
        #     "dtap_hex_3",
        #     "menb_2",
        #     "hib_menc_1",
        #     "pcv_2",
        #     "mmr_1",
        #     "menb_3",
        #     "dtap_ipv_1",
        #     "mmr_2",
        # ],
        vaccination_schedule=None,
    ):
        self.start_date = start_date
        self.get_registered_practice_at_ages = get_registered_practice_at_ages
        self.tpp_vaccine_codelist = tpp_vaccine_codelist
        self.ctv3_vaccine_codelist = ctv3_vaccine_codelist
        self.snomed_vaccine_codelist = snomed_vaccine_codelist
        self.event_washout_period = event_washout_period
        self.vaccination_schedule = vaccination_schedule
        self.min_date_of_birth = self.get_min_date_of_birth(
            start_date, get_registered_practice_at_ages
        )
        self.database_url = os.environ.get("DATABASE_URL")

    def to_csv(self, filename, expectations_population=False, with_sqlcmd=None):
        # Note we accept `with_sqlcmd` to match the expected signature here but
        # ignore its value and always use `sqlcmd`
        if expectations_population:
            raise NotImplementedError("")
        with tempfile.TemporaryDirectory() as tmpdir:
            patients_filename = os.path.join(tmpdir, "patients.csv")
            events_filename = os.path.join(tmpdir, "vaccination_events.csv")
            self.extract_data(patients_filename, events_filename)
            self.combine_data(patients_filename, events_filename, filename)

    def csv_to_df(self, csv_name):
        raise NotImplementedError()

    def to_sql(self):
        raise NotImplementedError()

    def to_dicts(self):
        raise NotImplementedError()

    def to_data(self):
        raise NotImplementedError()

    def get_min_date_of_birth(self, start_date, age_thresholds):
        """
        Return the minimum date of birth for patients to be included. This means
        patients who turned 5 in the first month we want to report on.

        As there's no harm in including a few extra patients (their data will just
        never get used) we round up year length to account for leap years.
        """
        years = max(age_thresholds)
        start_date = datetime.date.fromisoformat(start_date)
        cutoff_date = start_date - datetime.timedelta(days=366 * years)
        return cutoff_date.strftime("%Y-%m-%d")

    def extract_data(self, patients_filename, events_filename):
        patients_sql = patients_with_ages_and_practices_sql(
            self.min_date_of_birth, self.get_registered_practice_at_ages
        )
        events_sql = vaccination_events_sql(
            self.min_date_of_birth,
            tpp_vaccination_codelist=self.tpp_vaccine_codelist,
            ctv3_codelist=self.ctv3_vaccine_codelist,
            snomed_codelist=self.snomed_vaccine_codelist,
        )
        mssql_query_to_csv_file(self.database_url, patients_sql, patients_filename)
        mssql_query_to_csv_file(self.database_url, events_sql, events_filename)

    def combine_data(self, patients_filename, events_filename, combined_filename):
        # fmt: off
        with open(patients_filename, newline="") as patients_file, \
                open(events_filename, newline="") as events_file, \
                open(combined_filename, "w", newline="") as combined_file:
        # fmt: on
            patients = csv.DictReader(patients_file)
            vaccination_events = csv.DictReader(events_file)
            output_headers = patients.fieldnames + self.vaccination_schedule
            # We use `extrasaction="ignore"` below because if, somehow, a patient
            # is recorded as having been given more than the expected number of
            # doses of a vaccine we just want to ignore the extra columns that will
            # generate
            writer = csv.DictWriter(
                combined_file, fieldnames=output_headers, extrasaction="ignore"
            )
            writer.writeheader()
            for output_row in add_patient_vaccination_dates(
                patients, vaccination_events
            ):
                writer.writerow(output_row)
