# OpenSAFELY cohort extractor tool

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

It is designed to be run within an OpenSAFELY-compliant research
repository, via Docker.  You can find a [template repository here](https://github.com/opensafely/research-template)
and a [Getting Started guide](https://docs.opensafely.org/getting-started/) in the
OpenSAFELY documentation to help you get your study repository set up.

Normally it will be invoked via the [OpenSAFELY command line tool](https://github.com/opensafely-core/opensafely-cli),
as described in the [documentation](https://docs.opensafely.org/getting-started/).

If running it directly, it should be run from within the research repository.
To run the latest version via Docker and access its full help:

    docker run --rm ghcr.io/opensafely-core/cohortextractor --help

# For developers

Please see [the additional information](DEVELOPERS.md).

# About the OpenSAFELY framework

The OpenSAFELY framework is a Trusted Research Environment (TRE) for electronic
health records research in the NHS, with a focus on public accountability and
research quality.

Read more at [OpenSAFELY.org](https://opensafely.org).
