"""This module should be replaced by the thing Dave is writing which
will generate data from a series of function calls



"""

import requests


def get_data():
    response = requests.get(
        "https://raw.githubusercontent.com/ebmdatalab/tpp-sql-notebook/master/data/analysis/final_dataset.csv?token=AABTSR3LGB2FPTIWF4CMMH26RXFPE"
    )
    response.raise_for_status()
    with open("analysis/input.csv", "w") as f:
        f.write(response.text)


if __name__ == "__main__":
    get_data()
