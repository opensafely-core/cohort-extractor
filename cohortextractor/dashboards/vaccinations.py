import csv
import datetime
import os
import random
import tempfile
from datetime import timedelta

from cohortextractor.mssql_utils import mssql_dbapi_connection_from_url

from .vaccinations_combine import add_patient_vaccination_dates
from .vaccinations_extract import (
    patients_with_ages_and_practices_sql,
    vaccination_events_sql,
)


class VaccinationsStudyDefinition:
    def __init__(
        self,
        #
        # This is the first date for which we need data. If the maximum age
        # threshold (see below) is 5 years then we will only include data on
        # patients born less than 5 years before this date.
        start_date=None,
        #
        # Each age here produces a corresponding column in the final output:
        # "practice_id_at_month_N" giving the psuedo-id of the practice where the
        # patient was registered when they turned N-months old
        get_registered_practice_at_months=None,
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
        self.get_registered_practice_at_months = get_registered_practice_at_months
        self.tpp_vaccine_codelist = tpp_vaccine_codelist
        self.ctv3_vaccine_codelist = ctv3_vaccine_codelist
        self.snomed_vaccine_codelist = snomed_vaccine_codelist
        self.event_washout_period = event_washout_period
        self.vaccination_schedule = vaccination_schedule
        self.date_of_birth_range = self.get_date_of_birth_range(
            start_date, datetime.date.today(), get_registered_practice_at_months
        )
        self.database_url = os.environ.get("DATABASE_URL")

    def to_file(self, filename, expectations_population=False):
        assert str(filename).endswith(".csv")
        if expectations_population:
            self.write_dummy_data(filename, expectations_population)
        else:
            with tempfile.TemporaryDirectory() as tmpdir:
                patients_filename = os.path.join(tmpdir, "patients.csv")
                events_filename = os.path.join(tmpdir, "vaccination_events.csv")
                self.extract_data(patients_filename, events_filename)
                self.combine_data(patients_filename, events_filename, filename)

    def csv_to_df(self, csv_name):
        raise NotImplementedError()

    def to_sql(self):
        patients_sql = self.get_patients_sql()
        events_sql = self.get_events_sql()
        return f"""
        -- Get patient details
        {patients_sql};

        -- -------------------------------------------------------------------

        -- Get vaccination events
        {events_sql};
        """

    def to_dicts(self, convert_to_strings=True):
        raise NotImplementedError()

    def to_data(self):
        raise NotImplementedError()

    def get_date_of_birth_range(self, start_date, today, age_thresholds):
        """
        Return the range of dates of birth for patients to be included. The
        minimum will be patients who turned 5 years old in the first month we
        want to report on. The maximum will be patients who turned 1 today.
        """
        start_date = datetime.date.fromisoformat(start_date)
        # We trim all dates to the first of the month as that is what our
        # output looks like for IG reasons
        start_date = start_date.replace(day=1)
        today = today.replace(day=1)
        max_age_months = max(age_thresholds)
        min_age_months = min(age_thresholds)
        min_date = add_months(start_date, -max_age_months)
        max_date = add_months(today, -min_age_months)
        return min_date.isoformat(), max_date.isoformat()

    def extract_data(self, patients_filename, events_filename):
        patients_sql = self.get_patients_sql()
        events_sql = self.get_events_sql()
        mssql_query_to_csv_file(self.database_url, patients_sql, patients_filename)
        mssql_query_to_csv_file(self.database_url, events_sql, events_filename)

    def get_patients_sql(self):
        return patients_with_ages_and_practices_sql(
            self.date_of_birth_range, self.get_registered_practice_at_months
        )

    def get_events_sql(self):
        return vaccination_events_sql(
            self.date_of_birth_range,
            tpp_vaccination_codelist=self.tpp_vaccine_codelist,
            ctv3_codelist=self.ctv3_vaccine_codelist,
            snomed_codelist=self.snomed_vaccine_codelist,
        )

    def combine_data(self, patients_filename, events_filename, combined_filename):
        # Have to disable Black here because it can't (yet) format multliline
        # context managers correctly. See:
        # https://github.com/psf/black/issues/664#issuecomment-593905179
        # fmt: off
        with open(patients_filename, newline="") as patients_file, \
                open(events_filename, newline="") as events_file, \
                open(combined_filename, "w", newline="") as combined_file:
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
            output = add_patient_vaccination_dates(patients, vaccination_events)
            for output_row in output:
                writer.writerow(output_row)
        # fmt: on

    def write_dummy_data(self, filename, num_rows):
        with open(filename, "w", newline="") as output_file:
            patients = self.generate_dummy_data(num_rows)
            patients = iter(patients)
            first_patient = next(patients)
            writer = csv.DictWriter(output_file, fieldnames=first_patient.keys())
            writer.writeheader()
            writer.writerow(first_patient)
            for patient in patients:
                writer.writerow(patient)

    def generate_dummy_data(self, num_rows):
        rand = random.Random()
        min_date_of_birth = datetime.date.fromisoformat(self.date_of_birth_range[0])
        max_date_of_birth = datetime.date.fromisoformat(self.date_of_birth_range[1])
        today = datetime.date.today()
        max_age_in_days = (today - min_date_of_birth).days
        min_age_in_days = (today - max_date_of_birth).days
        assert max_age_in_days > 0
        practice_ids = rand.sample(range(99999999), 100)
        patient_id = rand.randrange(100000, 200000)
        for n in range(num_rows):
            # Ensures patients IDs are strictly increasing but not contiguous
            patient_id += rand.randrange(1, 9999)
            days_old = rand.randrange(min_age_in_days, max_age_in_days)
            date_of_birth = today - timedelta(days=days_old)
            data = {
                "patient_id": patient_id,
                "date_of_birth": date_of_birth.strftime("%Y-%m-01"),
            }
            for age in self.get_registered_practice_at_months:
                is_registered = rand.random() >= 0.1
                data[f"practice_id_at_month_{age}"] = (
                    rand.choice(practice_ids) if is_registered else 0
                )
            dose_date = date_of_birth
            for vaccine_dose in self.vaccination_schedule:
                dose_date += timedelta(days=rand.randrange(14, 365))
                if dose_date <= today:
                    received = rand.random() >= 0.1
                else:
                    received = False
                data[vaccine_dose] = dose_date.strftime("%Y-%m-01") if received else ""
            yield data


def add_months(date, months):
    """
    Adds a number of calendar months (positive or negative) to `date`

    If the day of the month in `date` is greater than 28 then this may produce
    an error as the corresponding day may not exist in the target month
    """
    zero_based_month = (date.month - 1) + months
    new_month = (zero_based_month % 12) + 1
    new_year = date.year + (zero_based_month // 12)
    return date.replace(year=new_year, month=new_month)


def mssql_query_to_csv_file(database_url, query, filename):
    conn = mssql_dbapi_connection_from_url(database_url)
    cursor = conn.cursor()
    cursor.execute(query)
    with open(filename, "w", newline="") as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow([x[0] for x in cursor.description])
        for row in cursor:
            writer.writerow(row)
