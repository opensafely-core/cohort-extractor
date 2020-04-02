"""This module should be replaced by the thing Dave is writing which
will generate data from a series of function calls



"""

import requests


def main():
    response = requests.get(
        "https://raw.githubusercontent.com/ebmdatalab/tpp-sql-notebook/master/data/analysis/final_dataset.csv?token=AABTSR3LGB2FPTIWF4CMMH26RXFPE"
    )
    response.raise_for_status()
    target_path = "analysis/input.csv"
    with open(target_path, "w") as f:
        f.write(response.text)
    print(f"Data written to {target_path}")


if __name__ == "__main__":
    main()
