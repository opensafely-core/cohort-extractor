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
        "prettytable",
        "pyarrow",
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
    extras_require={
        "drivers": [
            # Used by the Databricks backend
            "pyspark",
            # Used by the EMIS backend
            "presto-python-client",
            # Used by the TPP backend
            # This is a pre-built wheel of cTDS, which supports accessing MSSQL
            # databases using the TDS protocol.  We're using this because we
            # had problems downloading large amounts of data over ODBC.  If
            # you're on a platform other than Linux then you'll have to install
            # cTDS yourself:
            # https://zillow.github.io/ctds/install.html
            #
            # For more background on this see:
            # https://github.com/opensafely/cohort-extractor/pull/286
            "ctds@https://github.com/opensafely/ctds-binary/raw/9466f4bdb8eb70318256115c3bbb6b3ecc9351d0/dist/ctds-1.13.0-cp38-cp38-manylinux2014_x86_64.whl#egg=ctds;sys_platform=='linux'",
            "pyodbc",
        ]
    },
    entry_points={
        "console_scripts": ["cohortextractor=cohortextractor.cohortextractor:main"]
    },
    include_package_data=True,
    classifiers=["License :: OSI Approved :: GNU General Public License v3 (GPLv3)"],
)
