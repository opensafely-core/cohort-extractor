# Roadmap

The OpenSAFELY framework has been developed without funding, and lacks
several features we'd like to write to make it useful for the entire
research community.


## Better infrastructure

* Integration with github

## Better sensitive data review processes

At the moment we do X, in future we will do Y

Including redaction helpers, rules based publication (if none of X has changed, automatically publish)

## Support for more languages

* Jupyter notebooks in R, Python and Julia

## Scheduling

Regular jobs

## Chatops support

Slack integration, allowing the secure deployment of models in the
live infrastructure, and reporting back of succes / failure.

## Better dummy data

At the moment, we test our models against an arbitrary set of test
data which has a lot of interesting edge cases but doesn't exhibit the
expected statistical properties of real populations.

One approach is to generate "synthetic data". However, we plan instead
to incorporate _expectations_ into the study definition. For example,
a covariate `hba1c` may have an expectation that its results are
integers normally distributed around the value `12.6`.

The full set of outcomes, covariates and expectations will be used to
generate dummy data with the expected properties.  It will also be
used to test the expectations against the real dataset, and report
back to the analyst with differences.

## More backends

## Federated analysis

## Better documentation
