# OpenSAFELY extractor tool

This tool supports the authoring of OpenSAFELY-compliant research, by:

* Allowing developers to generate random data based on their study
  expectations. They can then use this as input data when developing
  analytic models.
* Supporting downloading of codelist CSVs from the [OpenSAFELY
  codelists repository](https://codelists.opensafely.org/), for
  incorporation into the study definition
* Providing tools to understand and visualise the properties of real
  data, without having direct access to it

It is also the mechanism by which cohorts are extracted from live
database backends within the OpenSAFELY framework.

To install the latest released version:

    pip install --upgrade opensafely-cohort-extractor

To discover its options:

    cohortextractor --help


# About the OpenSAFELY framework

The OpenSAFELY framework is a new secure analytics platform for
electronic health records research in the NHS.

Instead of requesting access for slices of patient data and
transporting them elsewhere for analysis, the framework supports
developing analytics against dummy data, and then running against the
real data *within the same infrastructure that the data is stored*.
Read more at [OpenSAFELY.org](https://opensafely.org).

The framework is under fast, active development to support rapid
analytics relating to COVID19; we're currently seeking funding to make
it easier for outside collaborators to work with our system.  You can
read our current roadmap [here](ROADMAP.md).
