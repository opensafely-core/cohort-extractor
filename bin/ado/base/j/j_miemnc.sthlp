{smcl}
{* *! version 1.0.4  19oct2017}{...}
{vieweralsosee "[MI] mi impute mvn" "mansection MI miimputemvn"}{...}
{viewerjumpto "My mi impute mvn output indicates that EM did not converge" "j_miemnc##converge"}{...}
{viewerjumpto "EM is used to obtain starting values" "j_miemnc##startvalues"}{...}
{viewerjumpto "What do I do about this?" "j_miemnc##todo"}{...}
{marker converge}{...}
{title:My {cmd:mi impute mvn} output indicates that EM did not converge}

{pstd}
When the output from {cmd:mi impute mvn} indicates that 
expectation maximization (EM) did not converge, there is usually no
cause for concern.  However, if you encounter this message, we recommend some
extra vigilance in assessing the convergence properties of the estimation chain
that produced the imputations.  Below we indicate how to do this.


{marker startvalues}{...}
{title:EM is used to obtain starting values}

{pstd}
Multivariate-normal imputations are obtained from an iterative Markov chain 
Monte Carlo (MCMC) method as draws from the posterior predictive distribution
of the missing data given the observed data.  The starting point of this 
chain is determined by EM parameter estimates of 
this predictive distribution.  When EM does not converge, this indicates
that 1) the starting point for the MCMC was less than optimal and 2)
it is possible that the imputation model is not well suited to the data.
The first item is not a serious problem provided that the MCMC burn-in period
was sufficient to counteract a bad starting point.  The second item is more
serious and requires model adjustment.


{marker todo}{...}
{title:What do I do about this?}

{pstd}
First, try increasing the number of EM iterations, 
thus giving EM a better chance of converging; see the {cmd:iterate()} option
under {it:em_options} in {helpb mi_impute_mvn:mi impute mvn} for how to change
the maximum number of EM iterations.

{pstd}
If increasing the number of iterations does not result in EM convergence,
then examine the convergence properties of MCMC to ensure that there is no
bigger issue.  See example 4 (and following) of {manlink MI mi impute mvn} for
how to do this.  If the diagnostics indicate a nonstable MCMC,
increasing the burn-in and burn-between periods (the {cmd:burnin()} and
{cmd:burnbetween()} options, respectively) may help.  If the diagnostics do not
indicate a nonstable MCMC, you may need to consider an alternate imputation
model, such as one with a different set of predictors.
{p_end}
