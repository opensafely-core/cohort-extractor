import os
from setuptools import setup, find_packages


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
        "pandas",
        "pyodbc",
        "pyyaml",
        "requests",
        "seaborn",
        "sqlalchemy",
        "sqlparse",
        "tinynetrc",
    ],
    entry_points={
        "console_scripts": ["cohortextractor=cohortextractor.cohortextractor:main"]
    },
    include_package_data=True,
    classifiers=["License :: OSI Approved :: GNU General Public License v3 (GPLv3)"],
)
