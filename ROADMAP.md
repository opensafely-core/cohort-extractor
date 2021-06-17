# Roadmap

The OpenSAFELY framework has been developed on shoestring funding.

While feature-complete for our own purposes, it lacks several features
we'd like to write to make it useful for the entire research
community, and requires manual intervention at several points to
complete analysis workflow.

Our vision is to bring the framework to a point where development,
review and publication workflows are highly automated, the
documentation is complete, and any third party can use the framework
for any analysis.

Some of the areas we would like to address include (in rough order of
priority):

## Better dummy data and validation of assumptions

At the moment, we test our models against an arbitrary set of test
data. This contains many interesting edge cases but doesn't exhibit
the expected statistical properties of real populations. This adequate
for basic model development, but (for example) multivariate
regressions may fail to converge against a small dummy dataset where
they would be expected to success against the real dataset.

This makes model development difficult; at the moment, our
epidemiologists manually override the dummy data with faked data in
cases where dummy data causes our tests to fail. This approach is
error-prone and awkward.

Rather than improving the fake data, we plan instead to incorporate
_expectations_ into the _study definition_. For example, a covariate
`hba1c` may have an _expectation_ that its results are integers normally
distributed around the value `12.6`.

The full set of outcomes, covariates and expectations will be used to
generate dummy data with the expected properties.  It will also be
used to test the expectations against the real dataset, and report
back to the analyst with differences.

More detail in #69.

## Better sensitive data review processes

At the moment, when a model has been run in the secure environment,
its outputs are manually reviewed by two people who have access to
that environment, to check for accidental privacy leaks; for example,
low numbers are manually redacted.

When they are happy with this, the changes are committed to the git
repository and pushed to github.

We would like to:

* Create tools to help reviewers, such as flagging possible low
  numbers, providing standard redaction templates
* Add tooling so reviewers don't need to understand git commands
* Add tooling to automatically publish updates where only the
  underlying data (not the model) has changed

## Support for more languages

Currently, we only support Stata.  We have started work on supporting
analysis using R and Python via Jupyter Notebooks, and would also like
to include support for Julia

## Remote deployment workflows

Currently, when a model needs to be run, privileged users must log
into the secure environment to run then, and also log in to monitor
progress.

We would like to improve this both via Github integrataion (for
example, tagged releases should trigger model runs when merged to the
main branch), and Slack integration (model runs can be triggered -
and reported back - via Slack).

## Scheduling

As well as epidemiological analysis, it will be possible to use the
framework to publish regularly-updating dashboards of summary
statistics.  This will require triggers and/or schedules to run *and
publish* code.

## More backends

We have currently implemented a backend for TPP data and hope to add
other backends in the near future.

We would also like to consider backends for other jurisdictions
outside the UK, including an OHDSI CDM backend.

## Pooling backend data

When we have several backends, we will need to support automated
approaches to pooling results through federated analysis.

## Better documentation

It should be possible, using only documentation, for any third party
to:

* Develop new backends
* Deploy a backend within a secure environment
* Support analysts who request their models be run, including
  reviewing and returning vetted outputs
