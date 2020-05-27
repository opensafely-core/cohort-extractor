from datetime import datetime
from scipy.stats import expon
from scipy.stats import rv_discrete
from scipy.stats import norm
from scipy.stats import uniform
import pandas as pd
import numpy as np
import os


def generate_ages(population, max_age=110):
    """Generate a population whose ages approximate UK population shape
    """

    df = pd.read_csv(
        os.path.join(os.path.dirname(__file__), "uk_population_bands_2018.csv")
    )
    # Reshape the dataframe (from
    # https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationprojections/datasets/tablea21principalprojectionukpopulationinagegroups)
    bands = df["band"].str.split("-").apply(pd.Series)
    df = df.join(bands)[[0, 1, "range"]]
    df.columns = ["start", "end", "count"]
    df["count"] = df["count"].str.replace(",", "").astype("int")
    ages = pd.DataFrame(np.arange(max_age), columns=["age"])
    total = df["count"].sum()

    def lookup_age(age):
        for index, row in df.iterrows():
            if age <= int(row["end"]):
                return row["count"]

    # compute a probability for each age
    ages["p"] = ages.age.apply(lookup_age) / total / 5
    # Ensure p adds up to 1 by trimming a large value
    excess = ages.p.sum() - 1
    biggest = ages[ages.p == ages.p.max()]
    ages.loc[biggest.index[0], "p"] -= excess
    # Generate ages
    distribution = rv_discrete(name="uk_population", values=(ages.age, ages.p))
    return distribution.rvs(size=population)


def generate_dates(population, earliest_date, latest_date, rate):
    """Produce a sample of events whose frequency is geometric
    (increasingly common)

    """
    low = datetime.strptime(earliest_date, "%Y-%m-%d").date()
    high = datetime.strptime(latest_date, "%Y-%m-%d").date()
    elapsed_days = (high - low).days

    if rate == "exponential_increase":
        # We oversample the distribution to trim the long tail of the
        # exponential function
        oversample_ratio = 1.5
        distribution = (
            expon.rvs(loc=0, scale=0.1, size=int(population * oversample_ratio))
            * elapsed_days
        ).astype("int")
        distribution = distribution[distribution <= elapsed_days]
    elif rate == "uniform":
        distribution = uniform.rvs(size=int(population)) * elapsed_days
        distribution = distribution.astype("int")
    else:
        raise ValueError(
            "Only exponential_increase and uniform distributions currently supported"
        )

    # And then sample it back down to the requested population size
    distribution = np.random.choice(distribution, population, replace=False)

    df = pd.DataFrame(distribution, columns=["days"])
    shifts = pd.TimedeltaIndex(df["days"], unit="D")
    df["d"] = high
    df["d"] = pd.to_datetime(df["d"])
    df["date"] = df["d"] - shifts
    return df[["date"]]


def generate(population, **kwargs):
    """Returns a date column and zero or more value column.
    """
    rate = kwargs.pop("rate", "exponential_increase")
    incidence = kwargs.pop("incidence", None)
    assert (
        incidence or rate == "universal"
    ), f"You must specify an incidence, or a `universal` rate: got {incidence} and {rate}"
    match_incidence = kwargs.pop("match_incidence", None)
    date = kwargs.pop("date", None)
    universal = rate == "universal"
    if match_incidence is not None:
        # We're using a column that's already had dates and incidence
        # defined
        df = match_incidence.to_frame()
        df.columns = ["date"]
    elif universal:
        df = pd.DataFrame(data=np.arange(population), columns=["date"])
    else:
        df = generate_dates(population, date["earliest"], date["latest"], rate)

    category = kwargs.pop("category", None)
    if category:
        ratios = category["ratios"]
        category_ids = np.arange(len(ratios))
        custm = rv_discrete(values=(category_ids, list(ratios.values())))
        df["category"] = custm.rvs(size=population)
        category_labels = dict(zip(category_ids, ratios.keys()))
        df = df.replace({"category": category_labels})
        df["category"] = df["category"].astype("category")

    int_ = kwargs.pop("int", None)
    if int_:
        if int_["distribution"] == "normal":
            mean = int_["mean"]
            stddev = int_["stddev"]
            df["int"] = norm.rvs(loc=mean, scale=stddev, size=population).astype("int")
        elif int_["distribution"] == "population_ages":
            # A distribution that is something like a real UK population
            df["int"] = generate_ages(population)
        else:
            raise ValueError(
                "Only `normal` and `population_ages` distributions currently supported"
            )
    float_ = kwargs.pop("float", None)
    if float_:
        if float_["distribution"] == "normal":
            mean = float_["mean"]
            stddev = float_["stddev"]
            df["float"] = norm.rvs(loc=mean, scale=stddev, size=population)
        else:
            raise ValueError(
                "Only `normal` and `population_ages` distributions currently supported"
            )

    bool_ = kwargs.pop("bool", None)
    if bool_:
        df["bool"] = True

    assert not kwargs, f"Encountered unexpected arguments: {kwargs}"

    if match_incidence is not None:
        # Remove rows to match the incidence of the passed-in series
        df.loc[pd.isnull(match_incidence), :] = None
    elif not universal:
        # Randomly remove rows to match incidence
        df.loc[df.sample(n=int((1 - incidence) * population)).index, :] = None
    if date is None:
        df = df.drop("date", axis=1)
    return df
