{smcl}
{* *! version 1.0.3  19oct2017}{...}
{title:High autocorrelation after 500 lags}

{pstd}
You fit a Bayesian model using {helpb bayesmh} or {helpb bayes} and 
receive a note at the bottom of the output table that there is a high 
autocorrelation after 500 lags.  What does this mean and is it a problem?

{pstd}
High autocorrelation after 500 lags means that the correlation between the
MCMC estimates that are 500 iterations apart is still above 0.01, the value
determined by option {cmd:corrtol()}.  The presence of autocorrelation in the
MCMC sample is a known property of any MCMC sampling algorithm, but for
well-behaved models and efficient sampling algorithms the autocorrelation
should decrease as the lag increases.  In other words, the MCMC estimates
should become less correlated the further apart they are.  When the
autocorrelation remains high and does not become negligible as the lag
increases, for example, after 500 lags, you should investigate your model
carefully.

{pstd}
High autocorrelation of the MCMC estimates is an indication of low efficiency
or slow mixing in the MCMC sample.  It may be due to nonconvergence or due to
the presence of highly correlated parameters in the model.  The lack of
convergence is a problem that you will need to address.  You can visually
check for convergence, for example, by using
{helpb bayesgraph:bayesgraph diagnostics}; 
also see {mansection BAYES bayesmhRemarksandexamplesConvergenceofMCMC:{it:Convergence of MCMC}} in 
{manlink BAYES bayesmh} for details.

{pstd}
Once convergence is established, the presence of high autocorrelation 
will typically mean low precision for some parameter estimates in the model.
Depending on the magnitudes of the parameters and your research objective, you
may be satisfied with the obtained precision, in which case you can ignore the
reported note.  If the level of precision is unacceptable, you may try to
reduce autocorrelation in your model.  We recommend you try to do it even
if the level of precision is acceptable to you.

{pstd}
To reduce autocorrelation, you must first identify the parameters with high
autocorrelation.  These parameters will also have low efficiencies and
thus low effective sample sizes (ESS).  You can use 
{helpb bayesstats ess} to obtain efficiencies and ESS for all model 
parameters.  For parameters with the lowest values, you can use 
{helpb bayesgraph:bayesgraph matrix} to check for correlation between them.

{pstd}
Once you identify the parameters with high autocorrelation, consider how they
are specified in the model.  Are all of your model parameters identifiable
given the used prior distributions? For instance, if you are using
noninformative priors, can all of your parameters be estimated reliably using
only the data? If not, you should either simplify the model or consider
specifying more informative priors.  Can you reparameterize your model to
improve the mixing of the MCMC sampler? For example, in a two-level model,
a constant term can be viewed as its own parameter with random-effects prior
distribution centered around zero or as a hyperparameter with random-effects
prior distribution centered around the constant term; see 
{mansection BAYES bayesmhRemarksandexamplesTwo-levelrandom-interceptmodelorpanel-datamodel:{it:Two-level random-intercept model or panel-data model}}
in {manlink BAYES bayesmh}.  Blocking of parameters 
({mansection BAYES bayesmhRemarksandexamplesImprovingefficiencyoftheMHalgorithm---blockingofparameters:{it:Improving efficiency of the MH algorithm -- blocking of parameters}}
in {manlink BAYES bayesmh})
and using other more efficient samplers
({mansection BAYES bayesmhRemarksandexamplesGibbsandhybridMHsampling:{it:Gibbs and hybrid MH sampling}}
in {manlink BAYES bayesmh})
can help lower autocorrelation.  Finally, you may consider subsampling or
thinning the chain by using option {cmd:thinning()} to reduce autocorrelation,
but this will often substantially increase simulation time.

{pstd}
If you are fitting a multilevel model using noninformative priors, you are
likely to encounter high autocorrelation for some parameter estimates.  Unlike
frequentist models, Bayesian models do not integrate out the individual random
effects, but estimate them together with other model parameters.  This
substantially increases the dimensionality of the model and often makes it
difficult to estimate all parameters with high precision.  For instance, the
estimates of variance components often have low precision.  Also, 
{help bayes_glossary##fixed_effects_parameters:fixed-effects parameters} are
often correlated with the corresponding 
{help bayes_glossary##random_effects_parameters:random-effects parameters}
such as the constant term and random intercepts.  As we mentioned earlier, the
presence of high autocorrelation does not necessarily mean that all of your
results are unreliable.  If high autocorrelation pertains to some of the
estimates of individual random effects, but you are mainly interested in
regression coefficients and they have low autocorrelation and thus high
precision, the existence of high autocorrelation among the random-effects
estimates may not be that relevant to you.

{pstd}
To summarize, the presence of high autocorrelation in your MCMC sample may or
may not be a concern.  Provided the model converged, the impact of high
autocorrelation on the precision of parameter estimates will depend on the
data, the model, and your research objective.  We do recommend that you try to
follow the steps described above to reduce the autocorrelation.
See {mansection BAYES bayesmhRemarksandexamplesSpecifyingMCMCsamplingprocedure:{it:Specifying MCMC sampling procedure}} in {manlink BAYES bayesmh} for more information.
{p_end}
