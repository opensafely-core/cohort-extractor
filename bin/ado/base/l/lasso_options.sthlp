{smcl}
{* *! version 1.0.0  21jun2019}{...}
{vieweralsosee "[LASSO] lasso options" "mansection lasso lassooptions"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[LASSO] Lasso intro" "help Lasso intro"}{...}
{vieweralsosee "[LASSO] Lasso inference intro" "mansection lasso Lassoinferenceintro"}{...}
{vieweralsosee "[LASSO] lasso" "help lasso"}{...}
{vieweralsosee "[LASSO] lasso fitting" "mansection lasso lassofitting"}{...}
{viewerjumpto "Syntax" "lasso_options##syntax"}{...}
{viewerjumpto "Description" "lasso_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "lasso_options##linkspdf"}{...}
{viewerjumpto "Options" "lasso_options##options"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[LASSO] lasso options} {hline 2}}Lasso options for inferential models{p_end}
{p2col:}({mansection LASSO lassooptions:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{it:lasso_inference_cmd}
...
[{cmd:,}
...
{it:options}]

{phang}
{it:lasso_inference_cmd} is one of {helpb dslogit}, {helpb dspoisson},
{helpb dsregress}, {helpb poivregress}, {helpb pologit}, {helpb popoisson},
{helpb poregress}, {helpb xpoivregress}, {helpb xpologit}, {helpb xpopoisson},
or {helpb xporegress}.

{marker loptions}{...}
{synoptset 35 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{cmdab:sel:ection(}{cmdab:plug:in)}}select lambda* using a plugin iterative formula for all lassos; the default{p_end}
{synopt :{cmdab:sel:ection(cv)}}select lambda* using cross-validation (CV) for all lassos{p_end}
{synopt :{cmdab:sel:ection(}{cmdab:adapt:ive)}}select lambda* using adaptive lasso for all lassos{p_end}
{synopt :{cmdab:sqrt:lasso}}fit square-root lassos instead of regular lassos{p_end}

{syntab:Advanced}
{synopt :{cmd:lasso(}{varlist}{cmd:,} {it:lasso_options}{cmd:)}}specify options for lassos for variables in {it:varlist}{p_end}
{synopt :{cmd:sqrtlasso(}{varlist}{cmd:,} {it:lasso_options}{cmd:)}}specify options for square-root lassos for variables in {it:varlist}{p_end}
{synoptline}


{marker lassooptions}{...}
{synoptset 35}{...}
{synopthdr:lasso_options}
{synoptline}
{synopt :{cmdab:sel:ection(}{help lasso_options##selmethod:{it:sel_method}}{cmd:)}}selection method to select an optimal value of the lasso penalty parameter lambda* from the set of possible lambdas{p_end}
INCLUDE help grid_short
INCLUDE help stop_short
INCLUDE help tolerance_short
{synoptline}


{marker selmethod}{...}
{synoptset 35}{...}
{synopthdr:sel_method}
{synoptline}
{synopt :{cmdab:plug:in}[{cmd:,} {help lasso_options##plug:{it:plugin_opts}}]}select lambda* using a plugin iterative formula; the default{p_end}
{synopt :{cmd:cv}[{cmd:,} {help lasso_options##cv:{it:cv_opts}}]}select lambda* using CV{p_end}
{synopt :{cmdab:adapt:ive}[{cmd:,} {help lasso_options##adaptive:{it:adapt_opts}} {help lasso_options##cv:{it:cv_opts}}]}select lambda* using an adaptive lasso; only available for {cmd:lasso()}{p_end}
{synoptline}


{marker plug}{...}
{synoptset 20}{...}
{synopthdr:plugin_opts}
{synoptline}
{synopt :{opt het:eroskedastic}}assume model errors are heteroskedastic; the default{p_end}
{synopt :{opt hom:oskedastic}}assume model errors are homoskedastic{p_end}
{synoptline}


{marker cv}{...}
{synoptset 20}{...}
{synopthdr:cv_opts}
{synoptline}
INCLUDE help folds_short
INCLUDE help alllambdas_short
INCLUDE help serule_short
INCLUDE help sel_opts_short
{synoptline}


{marker adaptive}{...}
{synoptset 20}{...}
{synopthdr:adapt_opts}
{synoptline}
{synopt :{opt steps(#)}}use {it:#} adaptive steps (counting the initial lasso as step 1){p_end}
{synopt :{cmdab:unpen:alized}}use the unpenalized estimator to construct initial weights{p_end}
{synopt :{cmd:ridge}}use the ridge estimator to construct initial weights{p_end}
{synopt :{opt power(#)}}raise weights to the {it:#}th power{p_end}
{synoptline}


{marker description}{...}
{title:Description}

{pstd}
This entry describes the options that control the lassos, either individually
or globally, in the {cmd:ds}, {cmd:po}, and {cmd:xpo} estimation commands.

{pstd}
For an introduction to lasso inferential models, see
{manlink LASSO Lasso inference intro}.

{pstd}
For examples of the {cmd:ds}, {cmd:po}, and {cmd:xpo} estimation commands and
the use of these options, see
{manlink LASSO Inference examples}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection LASSO lassooptionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{cmd:selection(plugin}|{cmd:cv}|{cmd:adaptive)} is a global option that
specifies that all lassos use the given selection method.  It is the same as
specifying {cmd:lasso(*, selection(plugin}|{cmd:cv}|{cmd:adaptive))}.  The
default is {cmd:selection(plugin)}.  That is, not specifying this option
implies a global {cmd:selection(plugin)} for all lassos.  This global form of
the option does not allow suboptions.  To specify suboptions, use the
{helpb lasso_options##lasso:lasso()} or 
{helpb lasso_options##sqrtlasso:sqrtlasso()} option described below.

{marker sqrtlasso}{...}
{phang}
{cmd:sqrtlasso} is a global option that specifies that all lassos be
square-root lassos.  It is the same as specifying {cmd:sqrtlasso(*)}, except
for logit and Poisson models.  For logit and Poisson models, it is the same as
{opt sqrtlasso(varsofinterest)}, where {it:varsofinterest} are all the
variables that have lassos excluding the dependent variable.  This global form
of the option does not allow suboptions.  To specify suboptions, use the
{helpb lasso_options##sqrtlasso:sqrtlasso()} option described below.

{dlgtab:Advanced}

{marker lasso}{...}
{phang}
{cmd:lasso(}{varlist}{cmd:,}
{help lasso_options##selection:{it:lasso_options}}{cmd:)} and
{cmd:sqrtlasso(}{varlist}{cmd:,} 
{help lasso_options##selection:{it:lasso_options}}{cmd:)} let you set different
options for different lassos and square-root lassos.  These options also let
you specify advanced options for all lassos and all square-root lassos.  The
{cmd:lasso()} and {cmd:sqrtlasso()} options override the global options
{cmd:selection(plugin}|{cmd:cv}|{cmd:adaptive)} and {cmd:sqrtlasso} for the
lassos for the specified variables.  If {cmd:lasso(}{it:varlist}{cmd:,}
{it:lasso_options}{cmd:)} or {cmd:sqrtlasso(}{it:varlist}{cmd:,}
{it:lasso_options}{cmd:)} does not contain a {cmd:selection()} specification as
part of {it:lasso_options}, then the global option for {cmd:selection()} is
assumed.

{phang2}
{cmd:lasso(}{varlist}{cmd:,} 
{help lasso_options##selection:{it:lasso_options}}{cmd:)} specifies that the
variables in {it:varlist} be fit using lasso with the selection method, set of
possible lambdas, and convergence criteria determined by {it:lasso_options}.

{phang2}
{cmd:sqrtlasso(}{varlist}{cmd:,}
{help lasso_options##selection:{it:lasso_options}}{cmd:)} specifies that the
variables in {it:varlist} be fit using square-root lasso with the selection
method, set of possible lambdas, and convergence criteria determined by
{it:lasso_options}.

{pmore2}
For {cmd:lasso()} and {cmd:sqrtlasso()}, {it:varlist} consists of one or more
variables from {depvar}, the dependent variable, or {it:varsofinterest}, the
variables of interest.  To specify options for all lassos, you may use {cmd:*}
or {cmd:_all} to specify {it:depvar} and all {it:varsofinterest}.

{pmore2}
For models with endogeneity, namely, {cmd:poivregress} and {cmd:xpoivregress}
models, lassos are done for {it:depvar}, the exogenous variables, {it:exovars},
and the endogenous variables, {it:endovars}.  Any of these variables can be
specified in the {cmd:lasso()} option.  All of them can be specified using
{cmd:*} or {cmd:_all}.

{pmore2}
The {cmd:lasso()} and {cmd:sqrtlasso()} options are repeatable as long as
different variables are given in each specification of {cmd:lasso()} and
{cmd:sqrtlasso()}.  The type of lasso for any {it:depvar} or
{it:varsofinterest} (or {it:exovars} or {it:endovars}) not specified in any
{cmd:lasso()} or {cmd:sqrtlasso()} option is determined by the global lasso
options described above.

{pmore2}
For all lasso inferential commands, linear lassos are done for each of the
{it:varsofinterest} (or {it:exovars} and {it:endovars}).  For linear models,
linear lassos are also done for {it:depvar}.  For logit models, however, logit
lassos are done for {it:depvar}.  For Poisson models, Poisson lassos are done
for {it:depvar}.  Square-root lassos are linear models, so
{cmd:sqrtlasso(}{it:depvar}{cmd:,} ...{cmd:)} cannot be specified for the
dependent variable in logit and Poisson models.  For the same reason,
{cmd:sqrtlasso(*,} ...{cmd:)} and {cmd:sqrtlasso(_all,} ...{cmd:)} cannot be
specified for logit and Poisson models.  For logit and Poisson models, you must
specify {cmd:sqrtlasso(}{it:varsofinterest}{cmd:,} ...{cmd:)} to set options
for square-root lassos and specify {cmd:lasso(}{it:depvar}{cmd:,} ...{cmd:)} to
set options for the logit or Poisson lasso for {it:depvar}.


{title:Suboptions for lasso() and sqrtlasso()}

{marker selection}{...}
{phang}
{cmd:selection(plugin} [{cmd:, heteroskedastic homoskedastic}]{cmd:)} selects
lambda* based on a "plugin" iterative formula dependent on the data.  The
plugin estimator calculates a value for lambda* that dominates the noise in the
estimating equations, which ensures that the variables selected belong to the
true model with high probability.  See 
{mansection LASSO lassoMethodsandformulas:{it:Methods and formulas}} in
{bf:[LASSO] lasso}.

{pmore}
{cmd:selection(plugin)} does not estimate coefficients for any other values of
lambda, so it does not require a lambda grid, and none of the grid options
apply.  It is much faster than the other selection methods because estimation
is done only for a single value of lambda.  It is an iterative procedure,
however, and if the plugin is computing estimates for a small lambda (which
means many nonzero coefficients), the estimation can still be time consuming.

{phang2}
{cmd:heteroskedastic} assumes model errors are heteroskedastic.  It is the
default.  Specifying {cmd:selection(plugin)} for linear lassos is equivalent to
specifying {cmd:selection(plugin, heteroskedastic)}.  This suboption can be
specified only for linear lassos.  Hence, this suboption cannot be specified
for {it:depvar} for logit and Poisson models, where {it:depvar} is the
dependent variable.  For these models, specify
{cmd:lasso(}{it:depvar}{cmd:, selection(plugin))} to have the logit or Poisson
plugin formula used for the lasso for {it:depvar}.  See
{mansection LASSO lassoMethodsandformulas:{it:Methods and formulas}} in
{bf:[LASSO] lasso}.

{phang2}
{cmd:homoskedastic} assumes model errors are homoskedastic.  This suboption can
be specified only for linear lassos.  Hence, this suboption cannot be specified
for {it:depvar} for logit and Poisson models, where {it:depvar} is the
dependent variable.

{phang}
{cmd:selection(cv} [{cmd:,} {opt folds(#)} {cmd:alllambdas serule stopok}
{cmd:strict} {cmd:gridminok}]{cmd:)} selects lambda* to be the lambda that
gives the minimum of the CV function.

INCLUDE help folds_long

INCLUDE help alllambdas_long

INCLUDE help serule_long

INCLUDE help sel_opts_long

{phang}
{cmd:selection(adaptive} [{cmd:,} {opt steps(#)} {cmd:unpenalized} {cmd:ridge}
{opt power(#)} {it:cv_options}]{cmd:)} can be specified only as a suboption for
{cmd:lasso()}.  It cannot be specified as a suboption for {cmd:sqrtlasso()}.
It selects lambda* using the adaptive lasso selection method.  It consists
of multiple lassos with each lasso step using CV.  Variables with zero
coefficients are discarded after each successive lasso, and variables with
nonzero coefficients are given penalty weights designed to drive small
coefficient estimates to zero in the next step.  Hence, the final model
typically has fewer nonzero coefficients than a single lasso. 

{phang2}
{opt steps(#)} specifies that adaptive lasso with {it:#} lassos be done.  By
default, {it:#} = 2.  That is, two lassos are run.  After the first lasso
estimation, terms with nonzero coefficients beta_i are given penalty weights
equal to 1/|beta_i|, terms with zero coefficients are omitted, and a second
lasso is estimated. Terms with small coefficients are given large weights,
making it more likely that small coefficients become zero in the second lasso.
Setting {it:#} > 2 can produce more parsimonious models.  See 
{mansection LASSO lassoMethodsandformulas:{it:Methods and formulas}} in
{bf:[LASSO] lasso}.

{phang2}
{cmd:unpenalized} specifies that the adaptive lasso use the unpenalized
estimator to construct the initial weights in the first lasso.
{cmd:unpenalized} is useful when CV cannot find a minimum.  {cmd:unpenalized}
cannot be specified with {cmd:ridge}.

{phang2}
{cmd:ridge} specifies that the adaptive lasso use the ridge estimator to
construct the initial weights in the first lasso.  {cmd:ridge} cannot be
specified with {cmd:unpenalized}.

{phang2}
{opt power(#)} specifies that the adaptive lasso raise the weights to the
{it:#}th power.  The default power is 1.  The specified power must be in the
interval [0.25, 2].

{phang2}
{it:cv_options} are all the suboptions that can be specified for
{cmd:selection(cv)}, namely, {opt folds(#)}, {cmd:alllambdas},
{cmd:serule}, {cmd:stopok}, {cmd:strict}, and {cmd:gridminok}.  The suboptions
{cmd:alllambdas}, {cmd:strict}, and {cmd:gridminok} apply only to the first
lasso estimated.  For second and subsequent lassos, {cmd:gridminok} is the
default.  When {cmd:ridge} is specified, {cmd:gridminok} is automatically used
for the first lasso.

INCLUDE help grid_long

INCLUDE help stop_long

INCLUDE help tolerance_long
{p_end}
