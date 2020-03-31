{* *! version 1.0.0  10jan2017}{...}
{phang}
{opth prior:(bayesmh##priorspec:priorspec)} specifies a prior distribution for
model parameters.  This option may be repeated. A prior may be specified for
any of the model parameters. Model parameters that are not included in prior
specifications are assigned default priors; see {mansection BAYES
bayesRemarksandexamplesDefaultpriors:{it:Default priors}} for details.  Model
parameters may be scalars or matrices, but both types may not be combined in
one prior statement.  If multiple scalar parameters are assigned a single
univariate prior, they are considered independent, and the specified prior is
used for each parameter.  You may assign a multivariate prior of dimension
{it:d} to {it:d} scalar parameters.  Also see
{mansection BAYES bayesmhRemarksandexamplesReferringtomodelparameters:{it:Referring to model parameters}} in {manhelp bayesmh BAYES}.

{pstd}
All {opt likelihood()} and {opt prior()} combinations are allowed, but they
are not guaranteed to correspond to proper posterior distributions.  You need
to think carefully about the model you are building and evaluate its
convergence thoroughly.

{phang}
{opt dryrun} specifies to show the summary of the model that would be fit
without actually fitting the model.  This option is recommended for checking
specifications of the model before fitting the model. The model summary reports
the information about the likelihood model and about priors for all model
parameters.
