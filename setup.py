import runner

from setuptools import setup, find_packages

setup(
    name="opensafely-cohort-extractor",
    version=runner.__version__,
    packages=find_packages(),
    url="https://github.com/opensafely/cohort-extractor",
    author="OpenSAFELY",
    author_email="tech@opensafely.org",
    install_requires=[
        "pandas",
        "pyodbc",
        "pyyaml",
        "requests",
        "seaborn",
        "sqlalchemy",
        "sqlparse",
    ],
    entry_points={
        "console_scripts": ["cohortextractor=datalab_cohorts.cohortextractor:main"]
    },
    include_package_data=True,
    classifiers=["License :: OSI Approved :: GNU General Public License v3 (GPLv3)"],
)
