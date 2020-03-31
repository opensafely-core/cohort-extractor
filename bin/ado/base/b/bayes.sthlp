{smcl}
{* *! version 1.0.14  14may2019}{...}
{viewerdialog bayes "dialog bayes"}{...}
{vieweralsosee "[BAYES] bayes" "mansection BAYES bayes"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian estimation" "help bayesian_estimation"}{...}
{vieweralsosee "[BAYES] Bayesian postestimation" "help bayesian_postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] Bayesian commands" "help bayesian_commands"}{...}
{vieweralsosee "[BAYES] bayesmh" "help bayesmh"}{...}
{vieweralsosee "[BAYES] Glossary" "help bayes_glossary"}{...}
{viewerjumpto "Syntax" "bayes##syntax"}{...}
{viewerjumpto "Menu" "bayes##menu"}{...}
{viewerjumpto "Description" "bayes##description"}{...}
{viewerjumpto "Links to PDF documentation" "bayes##linkspdf"}{...}
{viewerjumpto "Options" "bayes##options"}{...}
{viewerjumpto "Examples" "bayes##examples"}{...}
{viewerjumpto "Video examples" "bayes##video"}{...}
{viewerjumpto "Stored results" "bayes##results"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[BAYES] bayes} {hline 2}}Bayesian regression models using the bayes prefix{p_end}
{p2col:}({mansection BAYES bayes:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:bayes} [{cmd:,} {help bayes##bayesopts:{it:bayesopts}}] {cmd::}
{it:estimation_command} [{cmd:,} {it:estopts}]

{phang}
{marker estimation_command}{...}
{it:estimation_command} is a likelihood-based estimation command, and
{it:estopts} are command-specific estimation options; see
{manhelp bayesian_estimation BAYES:Bayesian estimation}
for a list of supported commands, and see the command-specific entries for the
supported estimation options, {it:estopts}.

{marker bayesopts}{...}
{synoptset 30 tabbed}{...}
{synopthdr:bayesopts}
{synoptline}
{marker options_priors}{...}
{syntab:{help bayes##priors_options:Priors}}
{p2coldent:* {opt gibbs}}specify Gibbs sampling; available only with {cmd:regress} or {cmd:mvreg} for certain prior combinations{p_end}
{p2coldent:* {opt normalpr:ior(#)}}specify standard deviation of default normal
priors for regression coefficients and other real scalar parameters; default is {cmd:normalprior(100)}{p_end}
{p2coldent:* {opt igammapr:ior(# #)}}specify shape and scale of default inverse-gamma prior for variances; default is {cmd:igammaprior(0.01 0.01)}{p_end}
{p2coldent:* {cmdab:iwishartpr:ior(}{help bayes##iwishartpriorspec:{it:#} [...]}{cmd:)}}specify degrees of freedom and, optionally, scale matrix of default inverse-Wishart prior for unstructured random-effects covariance{p_end}
INCLUDE help bayesmh_prioropts

{marker options_simulation}{...}
  {syntab:{help bayes##simulation_options:Simulation}}
INCLUDE help bayesmh_simopts
{synopt :{opt restubs(restub1 restub2 ...)}}specify stubs for random-effects parameters for all levels; allowed only with multilevel models{p_end}

{marker options_blocking}{...}
{syntab:{help bayes##blocking_options:Blocking}}
{p2coldent:* {opt blocksize(#)}}maximum block size; default is {cmd:blocksize(50)}{p_end}
{synopt: {cmd:block(}{help bayesmh##paramref:{it:paramref}}[{cmd:,} {help bayes##blockopts:{it:blockopts}}]{cmd:)}}specify a block of model parameters; this option may be repeated{p_end}
{synopt: {opt blocksumm:ary}}display block summary{p_end}
{p2coldent:* {opt noblock:ing}}do not block parameters by default{p_end}

{marker options_initialization}{...}
{syntab:{help bayes##initialization_options:Initialization}}
INCLUDE help bayesmh_initopts
{p2coldent:* {opt noi:sily}}display output from the estimation command during initialization{p_end}

{marker options_adaptation}{...}
{syntab:{help bayes##adaptation_options:Adaptation}}
INCLUDE help bayesmh_adaptopts

{marker options_reporting}{...}
{syntab:{help bayes##reporting_options:Reporting}}
INCLUDE help bayes_clevel_hpd_short
INCLUDE help bayes_eform
{synopt :{opt remargl}}compute log marginal-likelihood{p_end}
{synopt :{opt batch(#)}}specify length of block for batch-means calculations;
default is {cmd:batch(0)}{p_end}
{synopt :{cmdab:sav:ing(}{help filename:{it:filename}}[{cmd:, replace}]{cmd:)}}save simulation results to {it:filename}{cmd:.dta}{p_end}
{synopt :{opt nomodelsumm:ary}}suppress model summary{p_end}
{synopt :{opt nomesumm:ary}}suppress multilevel-structure summary; allowed
only with multilevel models{p_end}
{synopt :{opt chainsdetail}}display detailed simulation summary for each
chain{p_end}
{synopt :[{cmd:no}]{opt dots}}suppress dots or display dots every 100
iterations and iteration numbers every 1,000 iterations; default is
command-specific{p_end}
{synopt :{cmd:dots(}{it:#}[{cmd:,} {opt every(#)}]{cmd:)}}display dots as
simulation is performed {p_end}
{synopt :[{cmd:no}]{opth show:(bayesmh##paramref:paramref)}}specify model
parameters to be excluded from or included in the output{p_end}
{synopt :{opt showre:ffects}[{cmd:(}{it:{help bayesian postestimation##bayesian_post_reref:reref}}{cmd:)}]}specify that all or a subset of random-effects parameters be included in the output; allowed only with multilevel commands{p_end}
{synopt :{opt melabel}}display estimation table using the same row labels as
{it:estimation_command}; allowed only with multilevel commands{p_end}
{synopt :{opt nogr:oup}}suppress table summarizing groups; allowed only with
multilevel models{p_end}
{synopt :{opt notab:le}}suppress estimation table{p_end}
{synopt :{opt nohead:er}}suppress output header{p_end}
{synopt :{opt title(string)}}display {it:string} as title above the table of
parameter estimates{p_end}
{synopt :{help bayesmh##display_options:{it:display_options}}}control spacing,
line width, and base and empty cells{p_end}

{marker options_advanced}{...}
{syntab:{help bayes##advanced_options:Advanced}}
INCLUDE help bayesmh_advancedopts
{synoptline}
{p 4 6 2}* Starred options are specific to the {cmd:bayes} prefix; other
options are common between {cmd:bayes} and {helpb bayesmh}.{p_end}
{p 4 6 2}The full specification of {opt iwishartprior()} is{break}
{cmdab:iwishartpr:ior(}{help bayes##iwishartpriorspec:{it:#} [{it:matname}] [{bf:,} {bf:{ul:relev}el(}{it:levelvar}{bf:)}]}{cmd:)}.{p_end}
{p 4 6 2}Options {cmd:prior()} and {cmd:block()} may be repeated.{p_end}
{p 4 6 2}{helpb bayesmh##priorspec:{it:priorspec}} and
{helpb bayesmh##paramref:{it:paramref}} are defined in {manhelp bayesmh BAYES}.
{p_end}
{p 4 6 2}{it:paramref} may contain factor variables; see {help fvvarlist}.
{p_end}
{p 4 6 2}See {manhelp bayesian_postestimation BAYES:Bayesian postestimation} for
features available after estimation.{p_end}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Bayesian analysis > Regression models >}
{it:estimation_command}


{marker description}{...}
{title:Description}

{pstd}
The {opt bayes} prefix fits
{help bayesian estimation:Bayesian regression models}.  It provides Bayesian
support for many likelihood-based estimation commands.  The {opt bayes} prefix
uses default or user-supplied priors for model parameters and estimates
parameters using MCMC by drawing simulation samples from the corresponding
posterior model.  Also see {manhelp bayesmh BAYES} and
{manhelp bayesmh_evaluators BAYES:bayesmh evaluators} for fitting more general
Bayesian models.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection BAYES bayesQuickstart:Quick start}

        {mansection BAYES bayesRemarksandexamples:Remarks and examples}

        {mansection BAYES bayesMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{marker priors_options}{...}
{dlgtab:Priors}

{phang}
{opt gibbs} specifies that Gibbs sampling be used to simulate model parameters
instead of the default adaptive Metropolis-Hastings sampling.  This option is
allowed only with the {cmd:regress} and {cmd:mvreg} estimation commands.  It
is available only with certain prior combinations such as normal prior for
regression coefficients and an inverse-gamma prior for the variance.
Specifying the {cmd:gibbs} option is equivalent to specifying {cmd:block()}'s
{cmd:gibbs} suboption for all default blocks of parameters.  If you use the
{cmd:block()} option to define your own blocks of parameters, the {cmd:gibbs}
option will have no effect on those blocks, and an MH algorithm will be used
to update parameters in those blocks unless you also specify {cmd:block()}'s
{cmd:gibbs} suboption.

{phang}
{opt normalprior(#)} specifies the standard deviation of the default
normal priors.  The default is {cmd:normalprior(100)}.  The normal priors are
used for scalar parameters defined on the whole real line; see
{mansection BAYES bayesRemarksandexamplesDefaultpriors:{it:Default priors}}
for details.

{phang}
{opt igammaprior(# #)} specifies the shape and scale parameters of
the default inverse-gamma priors.  The default is {cmd:igammaprior(0.01 0.01)}.
The inverse-gamma priors are used for positive scalar parameters such as a
variance; see {mansection BAYES bayesRemarksandexamplesDefaultpriors:{it:Default priors}} for details.
Instead of a number {it:#}, you can specify a missing value ({cmd:.}) to refer
to the default value of 0.01.

{marker iwishartpriorspec}{...}
{phang}
{cmd:iwishartprior(}{it:#} [{it:matname}] [{cmd:,} {opt relev:el(levelvar)}])
specifies the degrees of freedom and, optionally, the scale matrix
{it:matname} of the default inverse-Wishart priors used for unstructured
covariances of random effects with multilevel models.  The degrees of freedom
{it:#} is a positive real scalar with the default value of d+1, where d
is the number of random-effects terms at the level of hierarchy {it:levelvar}.
Instead of a number {it:#}, you can specify a missing value ({cmd:.}) to refer
to the default value.  Matrix name {it:matname} is the name of a
positive-definite Stata matrix with the default of I(d), the identity matrix
of dimension d.  If {opt relevel(levelvar)} is omitted, the specified
parameters are used for inverse-Wishart priors for all levels with
unstructured random-effects covariances.  Otherwise, they are used only for
the prior for the specified level {it:levelvar}.  See
{mansection BAYES bayesRemarksandexamplesDefaultpriors:{it:Default priors}}
for details.

{phang}
{opth prior:(bayesmh##priorspec:priorspec)} specifies a prior distribution for
model parameters.  This option may be repeated.  A prior may be specified for
any of the model parameters, except the random-effects parameters in
multilevel models.  Model parameters with the same prior specifications are
placed in a separate block.  Model parameters that are not included in prior
specifications are assigned default priors; see
{mansection BAYES bayesRemarksandexamplesDefaultpriors:{it:Default priors}}
for details.  Model parameters may be scalars or matrices, but both types may
not be combined in one prior statement.  If multiple scalar parameters are
assigned a single univariate prior, they are considered independent, and the
specified prior is used for each parameter.  You may assign a multivariate
prior of dimension d to d scalar parameters.  Also see
{mansection BAYES bayesmhRemarksandexamplesReferringtomodelparameters:{it:Referring to model parameters}} in {bf:[BAYES] bayesmh}.

{pmore}
All {opt prior()} distributions are allowed, but they are not guaranteed to
correspond to proper posterior distributions for all likelihood models.  You
need to think carefully about the model you are building and evaluate its
convergence thoroughly; see
{mansection BAYES bayesmhRemarksandexamplesConvergenceofMCMC:{it:Convergence of MCMC}} in {bf:[BAYES] bayesmh}.

{phang}
{opt dryrun} specifies to show the summary of the model that would be fit
without actually fitting the model.  This option is recommended for checking
specifications of the model before fitting the model.  The model summary
reports the information about the likelihood model and about priors for all
model parameters.

{marker simulation_options}{...}
{dlgtab:Simulation}

INCLUDE help bayesmh_nchainsoptdes

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
depend on the efficiency of the Markov chain.  With multiple chains,
{cmd:mcmcsize()} applies to each chain.  Also see
{mansection BAYES bayesmhRemarksandexamplesBurn-inperiodandMCMCsamplesize:{it:Burn-in period and MCMC sample size}}
in {bf:[BAYES] bayesmh}.

{phang}
{opt burnin(#)} specifies the number of iterations for the burn-in
period of MCMC.  The values of parameters simulated during burn-in are used
for adaptation purposes only and are not used for estimation.  The default is
{cmd:burnin(2500)}.  Typically, burn-in is chosen to be as long as or longer
than the adaptation period.  The burn-in period may need to be larger for
multilevel models because these models introduce high-dimensional
random-effects parameters and thus require longer adaptation periods.
With multiple chains, {cmd:burnin()} applies to each chain.
Also see {mansection BAYES bayesmhRemarksandexamplesBurn-inperiodandMCMCsamplesize:{it:Burn-in period and MCMC sample size}}
in {bf:[BAYES] bayesmh} and
{mansection BAYES bayesmhRemarksandexamplesConvergenceofMCMC:{it:Convergence of MCMC}}
in {bf:[BAYES] bayesmh}.

{phang}
{opt thinning(#)} specifies the thinning interval.  Only simulated
values from every (1+k x {it:#})th iteration for
k = 0, 1, 2, ... are saved in the final MCMC sample; all other
simulated values are discarded.  The default is {cmd:thinning(1)}; that is,
all simulation values are saved.  Thinning greater than one is typically used
for decreasing the autocorrelation of the simulated MCMC sample.  With
multiple chains, {cmd:thinning()} applies to each chain.

{phang}
{opt rseed(#)} sets the random-number seed.  This option can be used
to reproduce results.  With one chain, {opt rseed(#)} is equivalent to typing
{cmd:set} {cmd:seed} {it:#} prior to calling the {cmd:bayes} prefix; see
{manhelp set_seed R:set seed}.  With multiple chains, you should use
{cmd:rseed()} for reproducibility; see
{mansection BAYES bayesmhRemarksandexamplesReproducingresults:{it:Reproducing results}} in
{bf:[BAYES] bayesmh}.

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
{it:paramref} can include individual random-effects parameters.

{phang}
{opt restubs(restub1 restub2 ...)} specifies the stubs for the names of
random-effects parameters.  You must specify stubs for all levels -- one
stub per level.  This option overrides the default random-effects stubs.  See
{mansection BAYES bayesRemarksandexamplesbayes_prefix_renames:{it:Likelihood model}}
for details about the default names of random-effects parameters.

{marker blocking_options}{...}
{dlgtab:Blocking}

{phang}
{opt blocksize(#)} specifies the maximum block size for the model
parameters; default is {cmd:blocksize(50)}.  This option does not apply to
random-effects parameters.  Each group of random-effects parameters is placed
in one block, regardless of the number of random-effects parameters in that
group.

{marker blockopts}{...}
{phang}
{cmd:block(}{help bayesmh##paramref:{it:paramref}}[{cmd:,} {it:blockopts}]{cmd:)}
specifies a group of model parameters for the blocked MH algorithm.  By
default, model parameters, except the random-effects parameters, are sampled
as independent blocks of 50 parameters or of the size specified in option
{opt blocksize()}.  Regression coefficients from different equations are placed
in separate blocks.  Auxiliary parameters such as variances and correlations are
sampled as individual separate blocks, whereas the cutpoint parameters of the
ordinal-outcome regressions are sampled as one separate block.  With
multilevel models, each group of random-effects parameters is placed in a
separate block, and the {cmd:block()} option is not allowed with
random-effects parameters.  The {opt block()} option may be repeated to define
multiple blocks.  Different types of model parameters, such as scalars and
matrices, may not be specified in one {opt block()}.  Parameters within one
block are updated simultaneously, and each block of parameters is updated in
the order it is specified; the first specified block is updated first, the
second is updated second, and so on.  See
{mansection BAYES bayesmhRemarksandexamplesImprovingefficiencyoftheMHalgorithm---blockingofparameters:{it:Improving efficiency of the MH algorithm---blocking of parameters}}
in {bf:[BAYES] bayesmh}.

{phang2}
{it:blockopts} include {cmd:gibbs}, {cmd:split}, 
{cmd:scale()}, {cmd:covariance()}, and {cmd:adaptation()}.

{phang2}
{opt gibbs} specifies to use Gibbs sampling to update parameters in the
block.  This option is allowed only for hyperparameters and only for specific
combinations of prior and hyperprior distributions; see
{mansection BAYES bayesmhMethodsandformulasGibbssamplingforsomelikelihood-priorandprior-hyperpriorconfigurations:{it:Gibbs sampling for some likelihood-prior and prior-hyperprior configurations}}
in {bf:[BAYES] bayesmh}.  For more information, see
{mansection BAYES bayesmhRemarksandexamplesGibbsandhybridMHsampling:{it:Gibbs and hybrid MH sampling}}
in {bf:[BAYES] bayesmh}.  {cmd:gibbs} may not be combined with 
{cmd:scale()}, {cmd:covariance()}, or {cmd:adaptation()}.

{phang2}
{opt split} specifies that all parameters in a block are treated as separate
blocks.  This may be useful for levels of factor variables.

{phang2}
{opt scale(#)} specifies an initial multiplier for the scale factor
corresponding to the specified block.  The initial scale factor is computed as
{it:#}/sqrt{n_p} for continuous parameters and as 
{it:#}/n_p for discrete parameters, where n_p is the number of
parameters in the block.  The default is {cmd:scale(2.38)}.  If specified, this option overrides the
respective setting from the {cmd:scale()} option specified with the command.
{cmd:scale()} may not be combined with {cmd:gibbs}.

{phang2}
{opt covariance(matname)} specifies a scale matrix {it:matname} to be
used to compute an initial proposal covariance matrix corresponding to the
specified block.  The initial proposal covariance is computed as {it:rho} x
{it:Sigma}, where {it:rho} is a scale factor and {it:Sigma} = {it:matname}.
By default, {it:Sigma} is the identity matrix.  If specified, this option
overrides the respective setting from the {opt covariance()} option specified
with the command.  {opt covariance()} may not be combined with {opt gibbs}.

{phang2}
{cmd:adaptation(tarate())} and {cmd:adaptation(tolerance())} specify
block-specific TAR and acceptance tolerance.  If specified,
they override the respective settings from the {opt adaptation()} option
specified with the command.
{opt adaptation()} may not be combined with {opt gibbs}.

{phang}
{opt blocksummary} displays the summary of the specified blocks.  This option
is useful when {opt block()} is specified.

{phang}
{opt noblocking} requests that no default blocking is applied to model
parameters.  By default, model parameters are sampled as independent blocks of
50 parameters or of the size specified in option {opt blocksize()}.
For multilevel models, this option has no effect on random-effects parameters;
blocking is always applied to them.

{marker initialization_options}{...}
{marker initspec}{...}
{dlgtab:Initialization}

{phang}
{opt initial(initspec)} specifies initial values for the model
parameters to be used in the simulation.  With multiple chains, this option
is equivalent to specifying option {cmd:init1()}.  You can specify a parameter
name, its initial value, another parameter name, its initial value, and so on.
For example, to initialize a scalar parameter {cmd:alpha} to 0.5 and a 2x2
matrix {cmd:Sigma} to the identity matrix {cmd:I(2)}, you can type

{phang3}
  {cmd:bayes}{cmd:,} {cmd:initial({c -(}alpha{c )-}} {cmd:0.5} {cmd:{c -(}Sigma,m{c )-}} {cmd:I(2))}{cmd::} ...
 
{pmore}
You can also specify a list of parameters using any of the specifications
described in {mansection BAYES bayesmhRemarksandexamplesReferringtomodelparameters:{it:Referring to model parameters}}
in {bf:[BAYES] bayesmh}.  For example, to initialize all regression
coefficients from equations {cmd:y1} and {cmd:y2} to zero, you can type

{phang3}
  {cmd:bayes,} {cmd:initial({c -(}y1:{c )-} {c -(}y2:{c )-} 0)}{cmd::} ...

{pmore}
The general specification of {it:initspec} is

{pmore2}
{help bayesmh##paramref:{it:paramref}} {it:initval} [{it:paramref} {it:initval} [{...}]]

{pmore}
where {it:initval} is either a number, a Stata expression that evaluates to
a number, or a Stata matrix for initialization of matrix parameters.

{pmore}
Curly braces may be omitted for scalar parameters but must be specified for
matrix parameters.  Initial values declared using this option override the
default initial values or any initial values declared during parameter
specification in the {cmd:likelihood()} option.  See
{mansection BAYES bayesRemarksandexamplesinitvals:{it:Initial values}}
in {bf:[BAYES] bayes} for details.

{phang}
{cmd:init}{it:#}{cmd:(}{it:{help bayes##initspec:initspec}}{cmd:)} specifies
initial values for the model parameters for the {it:#}th chain.  This option
requires option {cmd:nchains()}.  {cmd:init1()} overrides the default initial
values for the first chain, {cmd:init2()} for the second chain, and so on.
You specify initial values in {cmd:init}{it:#}{cmd:()} just like you do in
option {cmd:initial()}.  See
{mansection BAYES bayesRemarksandexamplesinitvals:{it:Initial values}}
in {bf:[BAYES] bayes} for details.

{phang}
{opth initall:(bayes##initspec:initspec)} specifies initial values for the
model parameters for all chains.  This option requires option {cmd:nchains()}.
You specify initial values in {cmd:initall()} just like you do in option
{cmd:initial()}.  You should avoid specifying fixed initial values in
{cmd:initall()} because then all chains will use the same initial values.
{cmd:initall()} is useful to specify random initial values when you define
your own priors within {cmd:prior()}'s {cmd:density()} and {cmd:logdensity()}
suboptions.  See
{mansection BAYES bayesRemarksandexamplesinitvals:{it:Initial values}}
in {bf:[BAYES] bayes} for details.

{phang}
{opt nomleinitial} suppresses using maximum likelihood estimates (MLEs) as
starting values for model parameters.  With multiple chains, this option
and discussion below apply only to the first chain.  By default, when no
initial values are specified, MLE values from {it:estimation_command} are used
as initial values.  For multilevel commands, MLE estimates are used only for
regression coefficients.  Random effects are assigned zero values, and
random-effects variances and covariances are initialized with ones and zeros,
respectively.  If {opt nomleinitial} is specified and no initial values are
provided, the command uses ones for positive scalar parameters, zeros for
other scalar parameters, and identity matrices for matrix parameters.
{cmd:nomleinitial} may be useful for providing an alternative starting state
when checking convergence of MCMC.  This option cannot be combined with
{cmd:initrandom}.

{phang}
{opt initrandom} requests that the model parameters be initialized randomly.
Random initial values are generated from the prior distributions of the model
parameters.  If you want to use fixed initial values for some of the
parameters, you can specify them in the {opt initial()} option or during
parameter declarations in the {opt likelihood()} option.  Random initial
values are not available for parameters with {opt flat}, {opt jeffreys},
{opt density()}, {opt logdensity()}, and {opt jeffreys()} priors; you must
provide your own initial values for such parameters.  This option cannot be
combined with {opt nomleinitial}.  See
{mansection BAYES bayesmhRemarksandexamplesSpecifyinginitialvalues:{it:Specifying initial values}}
in {bf:[BAYES] bayesmh} for details.

{phang}
{opt initsummary} specifies that the initial values used for simulation be
displayed.

{phang}
{opt noisily} specifies that the output from the estimation command be shown
during initialization.  The estimation command is executed once to set up the
model and calculate initial values for model parameters.

{marker adaptation_options}{...}
{marker adaptopts}{...}
{dlgtab:Adaptation}

{phang}
{opt adaptation(adaptopts)} controls adaptation of the MCMC procedure.
Adaptation takes place every prespecified number of MCMC iterations and
consists of tuning the proposal scale factor and proposal covariance for each
block of model parameters.  Adaptation is used to improve sampling efficiency.
Provided defaults are based on theoretical results and may not be sufficient
for all applications.  See {mansection BAYES bayesmhRemarksandexamplesAdaptationoftheMHalgorithm:{it:Adaptation of the MH algorithm}}
in {bf:[BAYES] bayesmh} for details about adaptation and its parameters.

{pmore}
{it:adaptopts} are any of the following options:  

{phang2}
{opt every(#)} specifies that adaptation be attempted every {it:#}th
iteration.  The default is {cmd:every(100)}.  To determine the adaptation
interval, you need to consider the maximum block size specified in your model.
The update of a block with k model parameters requires the estimation of
a k x k covariance matrix.  If the adaptation interval is not sufficient
for estimating the k(k+1)/2 elements of this matrix, the adaptation
may be insufficient.

{phang2}
{opt maxiter(#)} specifies the maximum number of adaptive
iterations.  Adaptation includes tuning of the proposal covariance and of the
scale factor for each block of model parameters.  Once the TAR is achieved
within the specified tolerance, the adaptation stops.  However, no more than
{it:#} adaptation steps will be performed.  The default is variable and is
computed as max{25,{cmd:floor(burnin()/adaptation(every()))}}.

{pmore2}
{cmd:maxiter()} is usually chosen to be no greater than
({cmd:mcmcsize()}+{cmd:burnin()})/{cmd:adaptation(every())}.

{phang2}
{opt miniter(#)} specifies the minimum number of adaptive iterations to be
performed regardless of whether the TAR has been achieved.  The default is
{cmd:miniter(5)}.  If the specified {opt miniter()} is greater than
{opt maxiter()}, then {opt miniter()} is reset to {opt maxiter()}.  Thus, if
you specify {cmd:maxiter(0)}, then no adaptation will be performed.

{phang2}
{opt alpha(#)} specifies a parameter controlling the adaptation of the
AR.  {opt alpha()} should be in [0,1].  The default is {cmd:alpha(0.75)}.

{phang2}
{opt beta(#)} specifies a parameter controlling the adaptation of the
proposal covariance matrix.  {opt beta()} must be in [0,1].  The closer
{opt beta()} is to zero, the less adaptive the proposal covariance.  When
{opt beta()} is zero, the same proposal covariance will be used in all MCMC
iterations.  The default is {cmd:beta(0.8)}.

{phang2}
{opt gamma(#)} specifies a parameter controlling the adaptation rate
of the proposal covariance matrix.  {opt gamma()} must be in [0,1].  The
larger the value of {opt gamma()}, the less adaptive the proposal covariance.
The default is {cmd:gamma(0)}.

{phang2}
{opt tarate(#)} specifies the TAR for all blocks of model parameters; this is
rarely used.  {opt tarate()} must be in (0,1).  The default AR is 0.234 for
blocks containing continuous multiple parameters, 0.44 for blocks with one
continuous parameter, and 1/{it:n_maxlev} for blocks with discrete
parameters, where {it:n_maxlev} is the maximum number of levels for a
discrete parameter in the block.

{phang2}
{opt tolerance(#)} specifies the tolerance criterion for adaptation
based on the TAR.  {opt tolerance()} should be in (0,1).
Adaptation stops whenever the absolute difference between the current AR and
TAR is less than {opt tolerance()}.  The default is {cmd:tolerance(0.01)}.

{phang}
{opt scale(#)} specifies an initial multiplier for the scale factor for
all blocks.  The initial scale factor is computed as {it:#}/sqrt{n_p}
for continuous parameters and {it:#}/n_p for discrete parameters,
where n_p is the number of parameters in the block.  The default is
{cmd:scale(2.38)}.

{phang}
{opt covariance(cov)} specifies a scale matrix {it:cov} to be used to
compute an initial proposal covariance matrix.  The initial proposal
covariance is computed as rho x Sigma, where rho is a scale factor
and Sigma = {it:matname}.  By default, Sigma is the identity matrix.
Partial specification of Sigma is also allowed.  The rows and columns of
{it:cov} should be named after some or all model parameters.  According to
some theoretical results, the optimal proposal covariance is the posterior
covariance matrix of model parameters, which is usually unknown.  This option
does not apply to the blocks containing random-effects parameters.

{marker reporting_options}{...}
{dlgtab:Reporting}

INCLUDE help bayesmh_credintoptsdes

{phang}
  {it:eform_option} causes the coefficient table to be displayed in
  exponentiated form; see {manhelpi eform_option R}.  The estimation command
  determines which {it:eform_option} is allowed ({opt eform(string)}
  and {cmd:eform} are always allowed).

{phang}
{cmd:remargl} specifies to compute the log marginal-likelihood for multilevel
models.  It is not reported by default for multilevel models.  Bayesian
multilevel models contain many parameters because, in addition to regression
coefficients and variance components, they also estimate individual random
effects.  The computation of the log marginal-likelihood involves the inverse
of the determinant of the sample covariance matrix of all parameters and loses
its accuracy as the number of parameters grows.  For high-dimensional models
such as multilevel models, the computation of the log marginal-likelihood can
be time consuming, and its accuracy may become unacceptably low.  Because it
is difficult to access the levels of accuracy of the computation for all
multilevel models, the log marginal-likelihood is not reported by default.
For multilevel models containing a small number of random effects, you can use
the {cmd:remargl} option to compute and display the log marginal-likelihood.

INCLUDE help bayesmh_batchoptdes

{phang}
{cmd:saving(}{it:{help filename}}[{cmd:, replace}]{cmd:)} saves simulation
results in {it:filename}{cmd:.dta}.  The {cmd:replace} option specifies to
overwrite {it:filename}{cmd:.dta} if it exists.  If the {opt saving()} option
is not specified, the {cmd:bayes} prefix saves simulation results in a
temporary file for later access by postestimation commands.  This temporary
file will be overridden every time the {cmd:bayes} prefix is run and will also
be erased if the current estimation results are cleared.  {cmd:saving()} may
be specified during estimation or on replay.

{pmore}
The saved dataset has the following structure.  Variable {cmd:_chain}
records chain identifiers.  Variable {cmd:_index} records
iteration numbers.  The {cmd:bayes} prefix saves only states (sets of
parameter values) that are different from one iteration to another and the
frequency of each state in variable {cmd:_frequency}.  (Some states may be
repeated for discrete parameters.) As such, {cmd:_index} may not necessarily
contain consecutive integers.  Remember to use {cmd:_frequency} as a frequency
weight if you need to obtain any summaries of this dataset.  Values for each
parameter are saved in a separate variable in the dataset.  Variables
containing values of parameters without equation names are named as
{cmd:eq0_p}{it:#}, following the order in which parameters are declared in
the {cmd:bayes} prefix.  Variables containing values of parameters with
equation names are named as {cmd:eq}{it:#}{cmd:_p}{it:#}, again following the
order in which parameters are defined.  Parameters with the same equation
names will have the same variable prefix {cmd:eq}{it:#}.  For example,

{phang3}
  {cmd:. bayes, saving(mcmc):} ...

{pmore}
will create a dataset, {cmd:mcmc.dta}, with variable names {cmd:eq1_p1} for
{cmd:{c -(}y:x1{c )-}}, {cmd:eq1_p2} for {cmd:{c -(}y:_cons{c )-}}, and
{cmd:eq0_p1} for {cmd:{c -(}var{c )-}}.
Also see macros {cmd:e(parnames)} and {cmd:e(varnames)} for the correspondence
between parameter names and variable names.

{pmore}
In addition, the {cmd:bayes} prefix saves variable {cmd:_loglikelihood} to
contain values of the log likelihood from each iteration and variable
{cmd:_logposterior} to contain values of the log posterior from each
iteration.

{phang}
{opt nomodelsummary} suppresses the detailed summary of the specified model.
The model summary is reported by default.

{phang}
{opt nomesummary} suppresses the summary about the multilevel structure
of the model.  This summary is reported by default for multilevel commands.

INCLUDE help bayesmh_chainsdetailoptsdes

{phang}
{opt nodots}, {opt dots}, and {opt dots(#)} specify to suppress or display
dots during simulation.  With multiple chains, these options affect all
chains.  {opt dots(#)} displays a dot every {it:#} iterations.  During the
adaptation period, a symbol {cmd:a} is displayed instead of a dot.  If
{cmd:dots(}...{cmd:,} {opt every(#)}{cmd:)} is specified, then an
iteration number is displayed every {it:#}th iteration instead of a dot or
{cmd:a}.  {cmd:dots(, every(}{it:#}{cmd:))} is equivalent to
{cmd:dots(1, every(}{it:#}{cmd:))}.  {cmd:dots} displays dots every 100
iterations and iteration numbers every 1,000 iterations; it is a synonym for
{cmd:dots(100), every(1000)}.  {cmd:dots} is the default with multilevel
commands, and {cmd:nodots} is the default with other commands.

{marker noshow()}{...}
{phang}
{opth show:(bayesmh##paramref:paramref)} or
{opth noshow:(bayesmh##paramref:paramref)}
specifies a list of model parameters to be included in the output or excluded
from the output, respectively.  By default, all model parameters (except
random-effects parameters with multilevel models) are displayed.  Do not
confuse {cmd:noshow()} with {cmd:exclude()}, which excludes the specified
parameters from the MCMC sample.  When the {cmd:noshow()} option is specified,
for computational efficiency, MCMC summaries of the specified parameters are
not computed or stored in {cmd:e()}.  {it:paramref} can include individual
random-effects parameters.

{phang}
{opt showreffects} and
{opth showreffects:(bayesian_postestimation##bayesian_post_reref:reref)}
are used with multilevel commands and specify that all or a list {it:reref}
of random-effects parameters be included in the output in addition to other
model parameters.  By default, all random-effects parameters are excluded from
the output as if you have specified the {opt noshow()} option.
This option computes, displays, and stores in {opt e()} MCMC summaries for
the random-effects parameters.

{phang}
{opt melabel} specifies that the {opt bayes} prefix use the same row labels as
{it:estimation_command} in the estimation table.  This option is allowed only
with multilevel commands.  It is useful to match the estimation table output
of {cmd:bayes:} {it:mecmd} with that of {it:mecmd}.  This option implies
{cmd:nomesummary} and {cmd:nomodelsummary}.

{phang}
{opt nogroup} suppresses the display of group summary information (number of
groups, average group size, minimum, and maximum) from the output header.
This option is for use with multilevel commands.

{phang}
{opt notable} suppresses the estimation table from the output.  By default, a
summary table is displayed containing all model parameters except those listed
in the {opt exclude()} and {opt noshow()} options.  Regression model
parameters are grouped by equation names.  The table includes six columns and
reports the following statistics using the MCMC simulation results:
posterior mean, posterior standard deviation, MCMC standard error or
MCSE, posterior median, and credible intervals.

{phang}
{opt noheader} suppresses the output header either at estimation or upon
replay.

{phang}
{opt title(string)} specifies an optional title for the command that is
displayed above the table of the parameter estimates.  The default title is
specific to the specified likelihood model.

INCLUDE help bayesmh_displayoptsdes

{marker advanced_options}{...}
{marker searchopts}{...}
{dlgtab:Advanced}

INCLUDE help bayesmh_advancedoptsdes


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Logistic regression example{p_end}

{pstd}Setup{p_end}
{phang2}
{cmd:. webuse lbw}
{p_end}

{pstd}Bayesian logistic model for the outcome variable {cmd:low}{p_end}
{phang2}
{cmd:. bayes: logit low age i.race ptl ui}
{p_end}

{pstd}Specifying a {cmd:block()} option{p_end}
{phang2}
{cmd:. bayes, block({c -(}low:i.race{c )-}): logit low age i.race ptl ui}
{p_end}

{pstd}Specifying a {cmd:prior()} option{p_end}
{phang2}
{cmd:. bayes, prior({c -(}low:i.race{c )-}, normal(0, 1)) block({c -(}low:i.race{c )-}): logit low age i.race ptl ui}
{p_end}

    {hline}
{pstd}Truncated Poisson regression example{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse runshoes}{p_end}

{pstd}Bayesian truncated Poisson regression with default truncation point of 0{p_end}
{phang2}{cmd:. bayes: tpoisson shoes distance i.male age}{p_end}

{pstd}Bayesian Poisson regression with truncation point of 3 and exposure 
variable {cmd:age}{p_end}
{phang2}{cmd:. replace shoes = . if shoes < 4}{p_end}
{phang2}{cmd:. bayes: tpoisson shoes distance male, exposure(age) ll(3)}{p_end}

    {hline}


{marker video}{...}
{title:Video examples}

{phang}
{browse "https://youtu.be/0F0QoMCSKJ4":Introduction to Bayesian statistics, part 1: The basic concepts}

{phang}
{browse "https://youtu.be/OTO1DygELpY":Introduction to Bayesian statistics, part 2: MCMC and the Metropolis-Hastings algorithm}

{phang}
{browse "https://www.youtube.com/watch?v=BhFYZWYpn5U":A prefix for Bayesian regression in Stata}

{phang}
{browse "https://www.youtube.com/watch?v=L7GfMLl7EqM":Bayesian linear regression using the bayes prefix}

{phang}
{browse "https://www.youtube.com/watch?v=76K1Cznzz0Q":Bayesian linear regression using the bayes prefix: How to specify custom priors}

{phang}
{browse "https://www.youtube.com/watch?v=W9EUr1rtH-k":Bayesian linear regression using the bayes prefix: Checking convergence of the MCMC chain}

{phang}
{browse "https://www.youtube.com/watch?v=KStrHq2Nw6w":Bayesian linear regression using the bayes prefix: How to customize the MCMC chain}


{marker results}{...}
{title:Stored results}

{pstd}
In addition to the results stored by {cmd:bayesmh}, the {cmd:bayes} prefix
stores the following in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:e(priorsigma)}}standard deviation of default normal priors{p_end}
{synopt:{cmd:e(priorshape)}}shape of default inverse-gamma priors{p_end}
{synopt:{cmd:e(priorscale)}}scale of default inverse-gamma priors{p_end}
{synopt:{cmd:e(blocksize)}}maximum size for blocks of model parameters{p_end}

{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:e(prefix)}}{cmd:bayes}{p_end}
{synopt:{cmd:e(cmdname)}}command name from {it:estimation_command}{p_end}
{synopt:{cmd:e(cmd)}}same as {cmd:e(cmdname)}{p_end}
{synopt:{cmd:e(command)}}estimation command line{p_end}
{p2colreset}{...}
