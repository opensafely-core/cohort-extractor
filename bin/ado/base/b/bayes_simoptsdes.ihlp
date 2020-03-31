{* *! version 1.0.0  25apr2019}{...}
{phang}
{opt mcmcsize(#)} specifies the target MCMC sample size.  The
default MCMC sample size is {cmd:mcmcsize(10000)}.  The total number of
iterations for the MH algorithm equals the sum of the burn-in iterations
and the MCMC sample size in the absence of thinning.  If thinning is
present, the total number of MCMC iterations is computed as
{cmd:burnin()} + ({cmd:mcmcsize()} - 1) x {cmd:thinning()} + 1.
Computation time of the MH algorithm is proportional to the total number of
iterations.  The MCMC sample size determines the precision of posterior
summaries, which may be different for different model parameters and will
depend on the efficiency of the Markov chain. Also see
{mansection BAYES bayesmhRemarksandexamplesBurn-inperiodandMCMCsamplesize:{it:Burn-in period and MCMC sample size}}
in {bf:[BAYES] bayesmh}.

{phang}
{opt burnin(#)} specifies the number of iterations for the burn-in
period of MCMC.  The values of parameters simulated during burn-in are used
for adaptation purposes only and are not used for estimation.  The default is
{cmd:burnin(2500)}.  Typically, burn-in is chosen to be as long as or longer
than the adaptation period. Also see {mansection BAYES bayesmhRemarksandexamplesBurn-inperiodandMCMCsamplesize:{it:Burn-in period and MCMC sample size}}
in {bf:[BAYES] bayes} and
{mansection BAYES bayesmhRemarksandexamplesConvergenceofMCMC:{it:Convergence of MCMC}}
in {bf:[BAYES] bayes}.

{phang}
{opt thinning(#)} specifies the thinning interval.  Only simulated
values from every (1+k x {it:#})th iteration for
k = 0, 1, 2, ... are saved in the final MCMC sample; all other
simulated values are discarded. The default is {cmd:thinning(1)}; that is, all
simulation values are saved.  Thinning greater than one is typically used for
decreasing the autocorrelation of the simulated MCMC sample.

{phang}
{opt rseed(#)} sets the random-number seed.  This option can be used
to reproduce results.  {opt rseed(#)} is equivalent to typing {cmd:set}
{cmd:seed} {it:#} prior to calling the {cmd:bayes} prefix; see
{manhelp set_seed R:set seed} and
{mansection BAYES bayesmhRemarksandexamplesReproducingresults:{it:Reproducing results}}
in {bf:[BAYES] bayes}.

{phang}
{opth exclude:(bayesmh##paramref:paramref)} specifies which model parameters
should be excluded from the final MCMC sample.  These model parameters will
not appear in the estimation table, and postestimation features for these
parameters and log marginal-likelihood will not be available.  This option is
useful for suppressing nuisance model parameters.  For example, if you have a
factor predictor variable with many levels but you are only interested in the
variability of the coefficients associated with its levels, not their actual
values, then you may wish to exclude this factor variable from the simulation
results.  If you simply want to omit some model parameters from the output,
see the {helpb bayes##noshow():noshow()} option.
