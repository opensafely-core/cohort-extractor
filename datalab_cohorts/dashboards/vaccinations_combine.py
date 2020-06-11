from collections import defaultdict
import datetime
import itertools


def add_patient_vaccination_dates(patients, vaccination_events, washout_period=0):
    patients_vaccinations = get_patient_vaccination_dates(
        vaccination_events, washout_period
    )
    joined = LeftJoinSortedRows(patients, patients_vaccinations, on="patient_id")
    for patient, vaccinations in joined:
        if vaccinations:
            patient.update(vaccinations)
        yield patient


def get_patient_vaccination_dates(vaccination_events, washout_period):
    """
    Takes a flat list of vaccination events and groups by patient, yielding a
    dict for each patient of the form:

        {
            "patient_id": 1234,
            "dtap_hex_1": "2014-06-01",
            "menb_1": "2014-07-01",
            "rotavirus_1": "2014-08-01",
            "dtap_hex_2": "2015-01-01",
            ...
        }

    Note in particular:

        * as a vaccine may be given in multiple doses, each vaccine name is
          suffixed with an index;
        * events occuring sufficiently close together are assumed to be
          duplicates and only the first is recorded;
        * all dates are rounded to the first of the month.
    """
    # Because we're sourcing vaccination data from multiple tables it's
    # possible that a single event will get recorded in multiple places,
    # possibly even at slightly different times. To workaround these we only
    # consider events as unique once a washout period has expired, starting
    # from the first time we see an event for a particular vaccine type.
    washout_period = datetime.timedelta(days=washout_period)
    events_by_patient = group_vaccination_events_by_patient(vaccination_events)
    for patient_id, vaccine_dates in events_by_patient:
        output_row = {"patient_id": patient_id}
        for vaccine_name, dates in vaccine_dates:
            previous_date = None
            count = 0
            for date in sorted(dates):
                if previous_date is None or date - previous_date >= washout_period:
                    count += 1
                    first_of_month = date.strftime("%Y-%m-01")
                    output_row[f"{vaccine_name}_{count}"] = first_of_month
                    previous_date = date
        yield output_row


def group_vaccination_events_by_patient(vaccination_events):
    """
    Takes a flat list of vaccination events and groups by patient and vaccine
    name, yielding results like:

        patient_id, [
            vaccine1: [
              date_1,
              date_2,
              ...
            ],
            vaccine2: [
              date_1,
              date_2,
              ...
            ],
        ]
    """
    get_patient_id = lambda row: row["patient_id"]
    for patient_id, group in itertools.groupby(vaccination_events, key=get_patient_id):
        vaccine_dates = defaultdict(list)
        for row in group:
            vaccine_name = row["vaccine_name"]
            date_given = datetime.date.fromisoformat(row["date_given"])
            vaccine_dates[vaccine_name].append(date_given)
        yield patient_id, vaccine_dates.items()


class LeftJoinSortedRows:
    """
    Left join two iterators of dictionaries on the supplied key field

    Assumes that both iterators are already sorted by key
    """

    def __init__(self, left_rows, right_rows, on="id"):
        self.left_iter = iter(left_rows)
        self.right_iter = iter(right_rows)
        self.get_key = lambda item: int(item[on])
        self.right_item = next(self.right_iter, None)

    def __iter__(self):
        return self

    def __next__(self):
        left_item = next(self.left_iter)
        left_key = self.get_key(left_item)
        right_item = self.next_right_item(left_key)
        return left_item, right_item

    def next_right_item(self, left_key):
        while True:
            # No more right items remaining: return None
            if self.right_item is None:
                return
            right_key = self.get_key(self.right_item)
            # Keys match: this is the item we want
            if right_key == left_key:
                return self.right_item
            # Right key is greater: return None until left catches up
            elif right_key > left_key:
                return
            # Right key is lesser: grab the next right item and try again
            else:
                self.right_item = next(self.right_iter, None)
