{smcl}
{* *! version 1.0.1  10jan2017}{...}
{vieweralsosee "[BAYES] bayes" "mansection BAYES bayes"}{...}
{title:Default priors}

{pstd}
For convenience, the {cmd:bayes} prefix provides default priors for model
parameters.  The priors are chosen to be fairly uninformative for most models
with small-scale parameters.  For example, regression coefficients are
assigned independent normal priors with zero mean and a variance of 10,000.
For moderately scaled regression coefficients, the variance of 10,000 should
provide sufficient variation in the values of the coefficients so that the
prior information has little impact on the results. This will not be true in
general; see {mansection BAYES bayesRemarksandexamplesex_linreg:{it:Linear regression: A case of informative default priors}} in {bf:[BAYES] bayes}.

{pstd}
When fitting Bayesian models, it is important to carefully evaluate the
choice of priors and specify the priors that are appropriate for your model
and research question.  You cannot simply rely on the provided defaults.

{pstd}
See {mansection BAYES bayesRemarksandexamplesDefaultpriors:{it:Default priors}}
in {bf:[BAYES] bayes} for details.
{p_end}
