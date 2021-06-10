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

To install the latest released version:

    pip install --upgrade opensafely-cohort-extractor

To discover its options:

    cohortextractor --help

It is designed to be run within an OpenSAFELY-compliant research
repository. [You can find a template repository to get you started
here](https://github.com/opensafely/research-template).

The tool has a `remote` subcommand which triggers jobs to be scheduled
to run elsewhere, via a [job
server](https://github.com/opensafely/job-server). If you set the
environment variable `OPENSAFELY_REMOTE_WEBHOOK`, this hook will be
supplied to the job server, which will `POST` a message to that URL
when a job has finished.

# For developers and researchers

Please see [the additional information](DEVELOPERS.md).

# About the OpenSAFELY framework

The OpenSAFELY framework is a Trusted Research Environment (TRE) for electronic
health records research in the NHS, with a focus on public accountability and
research quality.

Read more at [OpenSAFELY.org](https://opensafely.org).
