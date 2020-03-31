{smcl}
{* *! version 1.0.0  25apr2019}{...}
{vieweralsosee "[BAYES] bayesmh" "mansection BAYES bayesmh"}{...}
{vieweralsosee "[BAYES] bayes" "mansection BAYES bayes"}{...}

{title:Too many MCMC estimates to save when fitting Bayesian multilevel models}

{pstd}
You are trying to fit a Bayesian multilevel model containing many random
effects.  Unlike frequentist models, Bayesian models do not integrate out the
individual random effects but estimate them together with other model
parameters.  Thus MCMC estimates are saved for all individual random
effects in addition to other model parameters.  To accommodate this, you must
increase the limit for the maximum number of variables in your dataset (see
{helpb set maxvar}) to the total number of parameters in your model, including
random effects plus one.  The total number of parameters for which MCMC
estimates can be saved in a simulation file cannot exceed the limit for the
maximum number of variables minus one.  This limit is specific to each 
{help flavors:flavor} of Stata and is the largest in {help statamp:Stata/MP}.

{pstd}
If you are interested only in the estimates of model parameters, but not the
random effects themselves, you may consider specifying the {cmd:exclude()}
option with {helpb bayesmh} or {helpb bayes} to prevent saving MCMC
estimates of random effects.  If you specify the {cmd:exclude()} option, the
log marginal-likelihood and some postestimation features such as the
computation of Bayes factors will not be available.  However, their accuracy
with high-dimensional models can be questionable, so this may not be a big
loss.  You may decide to exclude all random effects or only a subset of them.
Keeping several random effects in the MCMC sample may be useful for checking
convergence and for other model diagnostics.
{p_end}
