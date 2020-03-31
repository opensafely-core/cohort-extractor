{smcl}
{* *! version 1.0.0  14may2019}{...}
{viewerdialog bayespredict "dialog bayespredict"}{...}
{vieweralsosee "[BAYES] bayespredict" "mansection BAYES bayespredict"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayesmh" "help bayesmh"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayesgraph" "help bayesgraph"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian postestimation"}{...}
{vieweralsosee "[BAYES] bayesstats ess" "help bayesstats ess"}{...}
{vieweralsosee "[BAYES] bayesstats ppvalues" "help bayesstats ppvalues"}{...}
{vieweralsosee "[BAYES] bayesstats summary" "help bayesstats summary"}{...}
{vieweralsosee "[BAYES] bayestest interval" "help bayestest interval"}{...}
{viewerjumpto "Syntax" "bayespredict##syntax"}{...}
{viewerjumpto "Menu" "bayespredict##menu"}{...}
{viewerjumpto "Description" "bayespredict##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayespredict##linkspdf"}{...}
{viewerjumpto "Options" "bayespredict##options"}{...}
{viewerjumpto "Examples" "bayespredict##examples"}{...}
{viewerjumpto "Stored results" "bayespredict##results"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[BAYES] bayespredict} {hline 2}}Bayesian predictions{p_end}
{p2col:}({mansection BAYES bayespredict:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Syntax is presented under the following headings:

        {help bayespredict##bayespred:Compute predictions}
        {help bayespredict##postsumm:Compute posterior summaries of simulated outcomes}
        {help bayespredict##replicates:Generate a subset of MCMC replicates of simulated outcomes}


{marker bayespred}{...}
{title:Compute predictions}

{phang}
Prediction of selected outcome variables and observations

{p 8 11 2}
{cmd:bayespredict}
{it:{help bayespredict##ysimspec:ysimspec}} [{it:ysimspec} ...]
{ifin}{cmd:,}
{opth sav:ing(bayespredict##savingopt:filespec)}
[{it:{help bayespredict##simopts:simopts}}]


{phang}
Functions of simulated outcomes, expected values, and residuals

{p 8 11 2}
{cmd:bayespredict}
{cmd:(}{it:{help bayespredict##funcspec:funcspec}}{cmd:)}
[{cmd:(}{it:funcspec}{cmd:)} ...] 
{ifin}{cmd:,}
{opth sav:ing(bayespredict##savingopt:filespec)}
[{it:{help bayespredict##simopts:simopts}}]

{marker ysimspec}{...}
{p 4 6 2}
{it:ysimspec} is {cmd:{c -(}_ysim}{it:#}{cmd:{c )-}} or
{cmd:{c -(}_ysim}{it:#}{cmd:[}{it:{help numlist}}{cmd:]}{cmd:{c )-}}, where
{cmd:{c -(}_ysim}{it:#}{cmd:{c )-}} refers to all observations of the
{it:#}th simulated outcome
and {cmd:{c -(}_ysim}{it:#}{cmd:[}{it:numlist}{cmd:]}{cmd:{c )-}} refers to
the selected observations,  {it:numlist}, of the {it:#}th simulated outcome.
{cmd:{c -(}_ysim{c )-}} is a synonym for {cmd:{c -(}_ysim1{c )-}}.
With large datasets, specification {cmd:{c -(}_ysim}{it:#}{cmd:{c )-}}
may use a lot of time and memory and should be avoided. See
{mansection BAYES bayespredictRemarksandexamplesGeneratingandsavingsimulatedoutcomes:{it:Generating and saving simulated outcomes}}
in {bf:[BAYES] bayespredict}.

{marker funcspec}{...}
{p 4 6 2}
{it:funcspec} is one of the following,

{phang3}
        [{it:label}{cmd::}]{cmd:@}{it:func}{cmd:(}{it:arg1}
	         [{cmd:,} {it:arg2}]{cmd:)}

{phang3}
        [{it:label}{cmd::}]{cmd:@}{it:userprog} {it:arg1}
	         [{it:arg2}]
        [{cmd:,} {opth extravars(varlist)} {opt passthru:opts(string)}]

{marker args}{...}
{p 6 6 2}
where {it:label} is a valid Stata name; {it:func} is an official or
user-defined Mata function that operates on column vectors and returns a real
scalar; {it:userprog} is a user-defined Stata program; and {it:arg1} and
{it:arg2} are one of {cmd:{c -(}_ysim}[{it:#}]{cmd:{c )-}},
{cmd:{c -(}_resid}[{it:#}]{cmd:{c )-}}, or {cmd:{c -(}_mu}[{it:#}]{cmd:{c )-}}.
{cmd:{c -(}_mu}{it:#}{cmd:{c )-}} refers to expected values, and
{cmd:{c -(}_resid}{it:#}{cmd:{c )-}} refers to
residuals for the {it:#}th outcome, where the latter is defined as the
difference between {cmd:{c -(}_ysim}{it:#}{cmd:{c )-}} and
{cmd:{c -(}_mu}{it:#}{cmd:{c )-}}. 
{it:arg2} is primarily for use with user-defined Mata functions; see
{mansection BAYES bayespredictRemarksandexamplesDefiningteststatisticsusingMatafunctions:{it:Defining test statistics using Mata functions}}
in {bf:[BAYES] bayespredict}.


{marker postsumm}{...}
{title:Compute posterior summaries of simulated outcomes}

{pstd}
Posterior mean of simulated outcomes

{p 8 11 2}
{cmd:bayespredict}
{dtype}
{it:{help bayespredict##newvarspec:newvarspec}}
{ifin}{cmd:,} {cmd:mean}
[{opth outcome:(bayespredict##outsim:depvar)}
{it:{help bayespredict##meanopts:meanopts}}
{it:{help bayespredict##simopts:simopts}}]


{pstd}
Posterior median or posterior standard deviation of simulated outcomes

{p 8 11 2}
{cmd:bayespredict}
{dtype} 
{it:{help bayespredict##newvarspec:newvarspec}}
{ifin}{cmd:,}
{cmd:median}{c |}{cmd:std}
[{opth outcome:(bayespredict##outsim:depvar)}
{it:{help bayespredict##simopts:simopts}}]


{pstd}
Credible intervals for simulated outcomes

{p 8 11 2}
{cmd:bayespredict}
{dtype}
{newvar}_l {it:newvar}_u
{ifin}{cmd:,} {cmd:cri}
[{opth outcome:(bayespredict##outsim:depvar)}
{it:{help bayespredict##criopts:criopts}}
{it:{help bayespredict##simopts:simopts}}]


{phang}
{marker newvarspec}{...}
{it:newvarspec} is {newvar} for single-outcome models and 
{it:{help newvarlist}} or {it:{help newvarlist##stub*:stub}}{cmd:*} for
multiple-outcome models.


{marker replicates}{...}
{title:Generate a subset of MCMC replicates of simulated outcomes}

{p 8 11 2}
{cmd:bayesreps}
{dtype}
{it:{help bayespredict##newrepspec:newrepspec}}
{ifin}{cmd:,} {opt nreps(#)}
[{opth outcome:(bayespredict##outreps:depvar)}
{it:{help bayespredict##simopts:simopts}}]


{phang}
{marker newrepspec}{...}
{it:newrepspec} is {newvar} with {cmd:nreps(1)} for a single replicate and
{it:{help newvarlist##stub*:stub}}{cmd:*}
with {opt nreps(#)}, where {it:#} is greater than 1, for multiple replicates.


{marker meanopts}{...}
{synoptset 24 tabbed}{...}
{marker meanopts}{...}
{synopthdr:meanopts}
{synoptline}
{syntab:Main}
{synopt :{opth mcse(newvar)}}create {it:newvar} containing MCSEs{p_end}

{syntab:Advanced}
{synopt :{opt batch(#)}}specify length of block for batch-means calculations; default is {cmd:batch(0)}{p_end}
{synopt :{opt corrlag(#)}}specify maximum autocorrelation lag; default varies{p_end}
{synopt :{opt corrtol(#)}}specify autocorrelation tolerance; default is {cmd:corrtol(0.01)}{p_end}
{synoptline}

{marker simopts}{...}
{synopthdr:simopts}
{synoptline}
{syntab:Simulation}
{synopt :{opt rseed(#)}}random-number seed{p_end}
{p2coldent :* {cmd:chains(_all} | {it:{help numlist}}{cmd:)}}specify which
chains to use for computation; default is {cmd:chains(_all)}{p_end}
{synopt :{opt dots}}display dots every 100 iterations and iteration numbers every 1,000 iterations{p_end}
{synopt :{cmd:dots(}{it:#}[{cmd:,} {opt every(#)}]{cmd:)}}display dots as simulation is performed{p_end}
{synoptline}
{p 4 6 2}
* Option {cmd:chains()}
is relevant only when option {opt nchains()} is used with {helpb bayesmh}.
{p_end}

{marker criopts}{...}
{synopthdr:criopts}
{synoptline}
{syntab:Main}
{synopt :{opt clev:el(#)}}set credible interval level; default is {cmd:clevel(95)}{p_end}
{synopt :{opt hpd}}calculate HPD credible intervals instead of the default equal-tailed credible intervals{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Bayesian analysis > Predictions}


{marker description}{...}
{title:Description}

{pstd}
{cmd:bayespredict} computes Bayesian predictions using current estimation
results produced by the {cmd:bayesmh} command and saves them in a separate
Stata dataset. Bayesian predictions include simulated outcomes, which are
samples from the
{help bayes_glossary##posterior_predictive_distribution:posterior predictive distribution}
of the fitted Bayesian model, and their functions.  You can also compute
posterior summaries of simulated outcomes and store them as new variables in the
current dataset.

{pstd}
{cmd:bayesreps} generates a random subset of
{help bayes_glossary##MCMC_replicates:MCMC replicates} of
simulated outcomes from the entire MCMC sample and stores them as new
variables in the current dataset.  This command is useful for checking model
fit.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayespredictQuickstart:Quick start}

        {mansection BAYES bayespredictRemarksandexamples:Remarks and examples}

        {mansection BAYES bayespredictMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{pstd}
Options are presented under the following headings:

        {help bayespredict##optspredict:Options for predictions}
        {help bayespredict##optspostsumm:Options for posterior summaries}
        {help bayespredict##optsbayesreps:Options for bayesreps}


{marker optspredict}{...}
{title:Options for predictions}

{dlgtab:Main}

{marker savingopt}{...}
{phang}
{cmd:saving(}{it:{help filename}}[{cmd:, replace}]{cmd:)} saves the requested
predictions such as simulated outcomes and residuals in
{it:filename}{cmd:.dta}.  It also saves auxiliary estimation results in
{it:filename}{cmd:.ster}, which is accessible by specifying
{helpb estimates use} {it:filename}.  The {cmd:replace} option specifies to
overwrite {it:filename}{cmd:.dta} and {it:filename}{cmd:.ster} if they exist.
{cmd:saving()} is required when computing predictions. The results are saved
only for the outcome variables, observations, and functions that are specified
with {cmd:bayespredict}. See
{mansection BAYES bayespredictRemarksandexamplesPredictiondataset:{it:Prediction dataset}} in
{bf:[BAYES] bayespredict} for details.

{marker option_extravars}{...}
{phang}
{opth extravars(varlist)} is for use with user-defined Stata programs. It
specifies any variables in addition to dependent and independent variables
that you may need to calculate predictions. For example, such variables are
offset variables and exposure variables for count-data models.

{phang}
{opt passthruopts(string)} is for use with user-defined Stata programs.
It specifies a list of options you may want to pass to your program when
calculating predictions. For example, these options may contain fixed
values of model parameters and hyperparameters.

{dlgtab:Simulation}

{phang}
{opt rseed(#)} sets the random-number seed.  This option can be used
to reproduce results.  With one chain, {opt rseed(#)} is equivalent to typing
{cmd:set} {cmd:seed} {it:#} prior to calling {cmd:bayespredict}; see
{manhelp set_seed R:set seed}.  With multiple chains, you should use
{cmd:rseed()} for reproducibility; see
{mansection BAYES bayesmhRemarksandexamplesReproducingresults:{it:Reproducing results}} in
{bf:[BAYES] bayesmh}.

{marker chainsspec}{...}
{phang}
{cmd:chains(_all} | {it:{help numlist}}{cmd:)} specifies which chains from the
MCMC sample to use for computation.  The default is {cmd:chains(_all)} or
to use all simulated chains. Using multiple chains, provided the chains have
converged, generally improves MCMC summary statistics. Option {cmd:chains()}
is relevant only when option {cmd:nchains()} is specified with
{helpb bayesmh}.

{phang}
{opt dots} and {opt dots(#)} specify to display dots during simulation.
With multiple chains, these options affect all chains.
{opt dots(#)} displays a dot every {it:#} iterations. 
If {cmd:dots(}...{cmd:,} {opt every(#)}{cmd:)} is specified, then an
iteration number is displayed every {it:#}th iteration instead of a dot.
{cmd:dots(,} {opt every(#)}{cmd:)} is equivalent to
{cmd:dots(1,} {opt every(#)}{cmd:)}.  {opt dots} displays dots every 100
iterations and iteration numbers every 1,000 iterations; it is a synonym for
{cmd:dots(100, every(1000))}.  


{marker optspostsumm}{...}
{title:Options for posterior summaries}

{dlgtab:Main}

{phang}
{cmd:mean} calculates posterior means of a simulated outcome variable and
stores them as a new variable in the current dataset.

{phang}
{cmd:median} calculates posterior medians of a simulated outcome variable and
stores them as a new variable in the current dataset.

{phang}
{cmd:std} calculates posterior standard deviations of a simulated outcome
variable and stores them as a new variable in the current dataset.

{pstd}
{cmd:mean}, {cmd:median}, and {cmd:std} can compute results for all simulated
outcome variables or for a specific one. To compute results for all
simulated outcome variables, you specify p new variables, where p is the
number of dependent variables. Alternatively, you can specify
{it:stub}{cmd:*}, in which case these options will store the results in
variables {it:stub}{cmd:1}, {it:stub}{cmd:2}, ..., {it:stub}p. To compute the
results for a specific simulated outcome variable, you specify one new
variable and, optionally, the outcome variable name in option {cmd:outcome()};
if you omit {cmd:outcome()}, the first outcome variable is assumed.

{phang}
{cmd:cri} calculates credible intervals for a simulated outcome variable and
stores the corresponding lower and upper bounds in two new variables in the
current dataset. For multiple-outcome models, it computes the results for the
outcome variable as specified in option {cmd:outcome()} or, by default, for
the first outcome variable.

{marker outsim}{...}
{phang}
{opt outcome(depvar)} is for use with multiple-outcome models when
computing posterior summaries of simulated outcomes. It specifies for which
simulated outcome posterior summaries are to be calculated. {cmd:outcome()}
should contain a name of the outcome (dependent) variable. The default is the
first outcome variable.  {cmd:outcome()} may not be combined with the
{it:{help newvarlist}} or {it:{help newvarlist##stub*:stub}}{cmd:*}
specification.

{phang}
{opth mcse(newvar)} is for use in a combination with option {cmd:mean}. It
adds {it:newvar} of storage type {it:type} containing MCSEs for the
posterior means of a simulated outcome variable. If multiple variables are
specified with {cmd:bayespredict}, {it:newvar} is used as a stub
{it:newvar}{cmd:*}.

{* INCLUDE help bayes_clevel_hpd *}{...}
{phang}
{opt clevel(#)} specifies the credible level, as a percentage, for
equal-tailed and HPD credible intervals.  The default is {cmd:clevel(95)} or
as set by {manhelp clevel BAYES:set clevel}.
This option requires that {cmd:cri} also be specified.

{phang}
{opt hpd} calculates the HPD credible intervals instead of the
default equal-tailed credible intervals.
This option requires that {cmd:cri} also be specified.

{dlgtab:Simulation}

{phang}
{opt rseed(#)} sets the random-number seed.  This option can be used
to reproduce results. With one chain, {opt rseed(#)} is equivalent to typing
{cmd:set seed} {it:#} prior to calling {cmd:bayespredict}; see
{helpb set_seed:[R] set seed}.
With multiple chains, you should use {cmd:rseed()} for reproducibility; see
{mansection BAYES bayesmhRemarksandexamplesReproducingresults:{it:Reproducing results}}
in {bf:[BAYES] bayesmh}.

{marker chainsspec}{...}
{phang}
{cmd:chains(_all} | {it:{help numlist}}{cmd:)} specifies which chains from the
MCMC sample to use for computation.  The default is {cmd:chains(_all)} or
to use all simulated chains. Using multiple chains, provided the chains have
converged, generally improves MCMC summary statistics. Option {cmd:chains()}
is relevant only when option {cmd:nchains()} is specified with
{helpb bayesmh}.

{phang}
{opt dots} and {opt dots(#)} specify to display dots during simulation.
With multiple chains, these options affect all chains.
{opt dots(#)} displays a dot every {it:#} iterations. 
If {cmd:dots(}...{cmd:,} {opt every(#)}{cmd:)} is specified, then an
iteration number is displayed every {it:#}th iteration instead of a dot.
{cmd:dots(,} {opt every(#)}{cmd:)} is equivalent to
{cmd:dots(1,} {opt every(#)}{cmd:)}.  {opt dots} displays dots every 100
iterations and iteration numbers every 1,000 iterations; it is a synonym for
{cmd:dots(100, every(1000))}.  

{dlgtab:Advanced}

{pstd}
The advanced options are available only in a combination with option
{cmd:mean}.

INCLUDE help bayesmh_batchoptdes

INCLUDE help bayes_corr


{marker optsbayesreps}{...}
{title:Options for bayesreps}

{dlgtab:Main}

{phang}
{opt nreps(#)} specifies the number of MCMC replicates of simulated outcomes
to be drawn at random from the entire sample of MCMC replicates. {it:#} must
be an integer between 1 and the MCMC sample size, inclusively. The generated
replicates are stored as new variables in the current dataset. For a single
replicate, {cmd:nreps(1)}, you specify one new variable name. For multiple
replicates, you specify a {it:{help newvarlist##stub*:stub}}{cmd:*}, in which
case the replicates will be stored in variables {it:stub}{cmd:1},
{it:stub}{cmd:2}, ..., {it:stub}R, where R is the number of replicates
specified in {cmd:nreps()}.

{marker outreps}{...}
{phang}
{opt outcome(depvar)} is for use with multiple-outcomes models when
generating MCMC replicates of simulated outcomes using {cmd:bayesreps}. It
specifies for which simulated outcome MCMC replicates are to be generated. The
default is to use the first outcome variable. You can specify other outcome
(dependent) variable names in {cmd:outcome()}.

{dlgtab:Simulation}

{phang}
{opt rseed(#)} sets the random-number seed.  This option can be used
to reproduce results. With one chain, {opt rseed(#)} is equivalent to typing
{cmd:set seed} {it:#} prior to calling {cmd:bayespredict}; see
{helpb set_seed:[R] set seed}.
With multiple chains, you should use {cmd:rseed()} for reproducibility; see
{mansection BAYES bayesmhRemarksandexamplesReproducingresults:{it:Reproducing results}}
in {bf:[BAYES] bayesmh}.

{marker chainsspec}{...}
{phang}
{cmd:chains(_all} | {it:{help numlist}}{cmd:)} specifies which chains from the
MCMC sample to use for computation.  The default is {cmd:chains(_all)} or
to use all simulated chains. Using multiple chains, provided the chains have
converged, generally improves MCMC summary statistics. Option {cmd:chains()}
is relevant only when option {cmd:nchains()} is specified with
{helpb bayesmh}.

{phang}
{opt dots} and {opt dots(#)} specify to display dots during simulation.
With multiple chains, these options affect all chains.
{opt dots(#)} displays a dot every {it:#} iterations. 
If {cmd:dots(}...{cmd:,} {opt every(#)}{cmd:)} is specified, then an
iteration number is displayed every {it:#}th iteration instead of a dot.
{cmd:dots(,} {opt every(#)}{cmd:)} is equivalent to
{cmd:dots(1,} {opt every(#)}{cmd:)}.  {opt dots} displays dots every 100
iterations and iteration numbers every 1,000 iterations; it is a synonym for
{cmd:dots(100, every(1000))}.  


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse auto}{p_end}
{phang2}{cmd:. bayesmh mpg weight length, likelihood(normal({c -(}var{c )-}))}
   {cmd:prior({mpg:}, normal(0, 1e4)) block({mpg:}, gibbs)}
   {cmd:prior({c -(}var{c )-}, igamma(.01,.01)) block({c -(}var{c )-}, gibbs)}
   {cmd:mcmcsize(1000) saving(simdata, replace) rseed(16)}

{pstd}Simulate outcomes for {cmd:mpg} and save them in {cmd:prdata.dta}{p_end}
{phang2}{cmd:. bayespredict {_ysim}, saving(prdata) rseed(16)}
{p_end}

{pstd}Compute posterior summaries for the first simulated observation
using {cmd:prdata.dta}{p_end}
{phang2}{cmd:. bayesstats summary {_ysim[1]} using prdata}

{pstd}Compute posterior summaries for the mean of simulated residuals
  using {cmd:prdata.dta}{p_end}
{phang2}{cmd:. bayesstats summary (@mean({_resid})) using prdata}

{pstd}Compute posterior summaries for the mean expected outcome
  using {cmd:prdata.dta}{p_end}
{phang2}{cmd:. bayesstats summary (@mean({_mu})) using prdata}

{pstd}Compute the minimum of the simulated outcomes for the {cmd:mpg}
and save them in {cmd:prdata.dta}{p_end}
{phang2}{cmd:. bayespredict (prmin:@min({_ysim})), saving(prdata, replace)}

{pstd}Compute posterior summaries for {cmd:prmin} using {cmd:prdata.dta}{p_end}
{phang2}{cmd:. bayesstats summary {prmin} using prdata}

{pstd}Compute posterior means of simulated outcomes and store them in new 
variable {cmd:pmean}{p_end}
{phang2}{cmd:. bayespredict pmean, mean}

{pstd}Compute posterior medians of simulated outcomes and store them in 
new variable {cmd:pmedian}{p_end}
{phang2}{cmd:. bayespredict pmedian, median}

{pstd}Generate 3 MCMC replicates of simulated outcomes and store them in
variables {cmd:mpgrep1}, {cmd:mpgrep2}, and {cmd:mpgrep3}{p_end}
{phang2}{cmd:. bayesreps mpgrep*, nreps(3)}

{pstd}Clear prediction data{p_end}
{phang2}{cmd:. rm prdata.dta}{p_end}
{phang2}{cmd:. rm prdata.ster}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse auto, clear}{p_end}
{phang2}{cmd:. bayesmh mpg length = weight, likelihood(mvnormal({Sigma,matrix}))}
   {cmd:prior({mpg:}, normal(0, 1e4)) block({mpg:}, gibbs)}
   {cmd:prior({length:}, normal(0, 1e4)) block({length:}, gibbs)}
   {cmd:prior({Sigma,m}, iwishart(2,10,I(2))) block({Sigma,m}, gibbs)}
   {cmd:mcmcsize(1000) saving(simdata, replace)}

{pstd}Simulate outcomes for {cmd:mpg} and {cmd:length} for observations 1 to 10 
and save the predictions in {cmd:prdata.dta}{p_end}
{phang2}{cmd:. bayespredict {_ysim1} {_ysim2} in 1/10, saving(prdata)}

{pstd}Compute posterior predictive p-values of the simulated residuals for 
{cmd:mpg}{p_end}
{phang2}{cmd:. bayesstats ppvalues {_resid1} using prdata}

{pstd}Compute posterior summaries for {cmd:length}{p_end}
{phang2}{cmd:. bayesstats summary {_ysim2} using prdata}

{pstd}Clear prediction data{p_end}
{phang2}{cmd:. rm prdata.dta}{p_end}
{phang2}{cmd:. rm prdata.ster}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:bayespredict} stores the following in an estimation file,
{it:filename}{cmd:.ster}, where {it:filename} is specified in 
the {opth saving(filename)} option. 

{synoptset 19 tabbed}{...}
{p2col 5 19 21 2: Scalars}{p_end}
{synopt :{cmd:e(N)}}number of observations{p_end}
{synopt :{cmd:e(nchains)}}number of MCMC chains{p_end}
{synopt :{cmd:e(mcmcsize)}}MCMC sample size{p_end}

{p2col 5 19 21 2: Macros}{p_end}
{synopt :{cmd:e(cmd)}}{cmd:bayespredict}{p_end}
{synopt :{cmd:e(est_cmd)}}{cmd:bayesmh}{p_end}
{synopt :{cmd:e(cmdline)}}command as typed{p_end}
{synopt :{cmd:e(est_cmdline)}}estimation command as typed{p_end}
{synopt :{cmd:e(predfile)}}file containing prediction results{p_end}
{synopt :{cmd:e(mcmcfile)}}file containing simulation results{p_end}
{synopt :{cmd:e(predynames)}}names of simulated outcome observations,
{cmd:_ysim}{it:#}{cmd:_}{it:#}{p_end}
{synopt :{cmd:e(predfnames)}}names of specified functions and programs{p_end}
{synopt :{cmd:e(predrngstate}{it:#}{cmd:)}}random-number state for {it:#}th chain
for prediction{p_end}
{synopt :{cmd:e(rngstate)}}random-number state for simulation (only with
single chain){p_end}
{synopt :{cmd:e(rngstate}{it:#}{cmd:)}}random-number state for {it:#}th chain for simulation (only with {cmd:nchains()}){p_end}
{p2colreset}{...}
