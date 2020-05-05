from datetime import datetime
from scipy.stats import expon
from scipy.stats import rv_discrete
from scipy.stats import norm
import pandas as pd
import numpy as np


def generate_dates(population, earliest_date, latest_date):
    """Produce a sample of events whose frequency is geometric
    (increasingly common)

    """
    low = datetime.strptime(earliest_date, "%Y-%m-%d").date()
    high = datetime.strptime(latest_date, "%Y-%m-%d").date()
    elapsed_days = (high - low).days

    # We oversample the distribution to trim the long tail of the
    # exponential function
    oversample_ratio = 1.5
    distribution = (
        expon.rvs(loc=0, scale=0.1, size=int(population * oversample_ratio))
        * elapsed_days
    ).astype("int")
    # Trim the very long tail of the exponential distribution
    distribution = distribution[distribution <= elapsed_days]

    # And then sample it back down to the requested population size
    distribution = np.random.choice(distribution, population, replace=False)

    df = pd.DataFrame(sorted(distribution), columns=["days"])
    shifts = pd.TimedeltaIndex(df["days"], unit="D")
    df["d"] = high
    df["d"] = pd.to_datetime(df["d"])
    df["date"] = df["d"] - shifts
    return df[["date"]]


def generate(population, incidence, returning=None):
    """Returns a date column and zero or more value column.



    Value can be:

      * Categories
      * Scalar
      * Binary

    Categories is a dictionary of keys to probabilities 0 < p < 1
    which add up to 1

    scalar is a dictionary {'distribution': 'normal', median: 50, stdev: 0.5}

    """

    if not returning:
        raise ValueError("You must opt to return something!")
    # First, generate a geometric date range corresponding with possible appointments
    earliest_date = "1900-01-01"
    latest_date = datetime.now().strftime("%Y-%m-%d")
    if "date" in returning:
        date = returning["date"]
        earliest_date = date.get("earliest_date", earliest_date)
        latest_date = date.get("latest_date", latest_date)
    df = generate_dates(population, earliest_date, latest_date)

    if "category" in returning:
        categories = returning["category"]["categories"]
        category_ids = np.arange(len(categories))
        custm = rv_discrete(values=(category_ids, list(categories.values())))
        df["category"] = custm.rvs(size=population)
        category_labels = dict(zip(category_ids, categories.keys()))
        df = df.replace({"category": category_labels})
        df["category"] = df["category"].astype("category")
    if "int" in returning:
        scalar = returning["int"]
        if scalar["distribution"] == "normal":
            mean = scalar["mean"]
            stddev = scalar["stddev"]
            df["int"] = norm.rvs(loc=mean, scale=stddev, size=population).astype("int")
        else:
            raise ValueError("Only normal distributions currently supported")
    if "float" in returning:
        scalar = returning["float"]
        if scalar["distribution"] == "normal":
            mean = scalar["mean"]
            stddev = scalar["stddev"]
            df["float"] = norm.rvs(loc=mean, scale=stddev, size=population)
        else:
            raise ValueError("Only normal distributions currently supported")
    if "bool" in returning:
        df["bool"] = True

    if "date" in returning:
        # Format to the correct precision
        if "include_day" in returning["date"]:
            df["date"] = df["date"].dt.strftime("%Y-%m-%d")
        elif "include_month" in returning["date"]:
            df["date"] = df["date"].dt.strftime("%Y-%m")
        else:
            df["date"] = df["date"].dt.strftime("%Y")
    else:
        df = df.drop("date", axis=1)
    # Randomly remove rows to match incidence
    df.loc[df.sample(n=int((1 - incidence) * population)).index, :] = None
    return df
