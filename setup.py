import runner

from setuptools import setup, find_packages

runner.__version__

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
    scripts=["cohort-extractor"],
    include_package_data=True,
)
