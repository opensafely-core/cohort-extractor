import os

from setuptools import find_packages, setup

with open(os.path.join("cohortextractor", "VERSION")) as f:
    version = f.read().strip()

setup(
    name="opensafely-cohort-extractor",
    version=version,
    packages=find_packages(),
    url="https://github.com/opensafely/cohort-extractor",
    author="OpenSAFELY",
    author_email="tech@opensafely.org",
    python_requires=">=3.7",
    install_requires=[
        "lz4",
        "opensafely-jobrunner>=2.0,<3.0",
        "pandas",
        "presto-python-client",
        "prettytable",
        "pyarrow",
        "pyspark",
        "pyyaml",
        "requests",
        "requests-pkcs12",
        "retry",
        "seaborn",
        "sqlalchemy",
        "sqlparse",
        "structlog",
        "tabulate",
        "tinynetrc",
    ],
    entry_points={
        "console_scripts": ["cohortextractor=cohortextractor.cohortextractor:main"]
    },
    include_package_data=True,
    classifiers=["License :: OSI Approved :: GNU General Public License v3 (GPLv3)"],
)
