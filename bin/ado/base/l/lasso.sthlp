{smcl}
{* *! version 1.0.1  14feb2020}{...}
{viewerdialog lasso "dialog lasso"}{...}
{vieweralsosee "[LASSO] lasso" "mansection lasso lasso"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[LASSO] lasso postestimation" "help lasso postestimation"}{...}
{vieweralsosee "[LASSO] elasticnet" "help elasticnet"}{...}
{vieweralsosee "[LASSO] lasso examples" "mansection lasso lassoexamples"}{...}
{vieweralsosee "[LASSO] Lasso intro" "help Lasso intro"}{...}
{vieweralsosee "[LASSO] sqrtlasso" "help sqrtlasso"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] logit" "help logit"}{...}
{vieweralsosee "[R] poisson" "help poisson"}{...}
{vieweralsosee "[R] probit" "help probit"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{viewerjumpto "Syntax" "lasso##syntax"}{...}
{viewerjumpto "Menu" "lasso##menu"}{...}
{viewerjumpto "Description" "lasso##description"}{...}
{viewerjumpto "Links to PDF documentation" "lasso##linkspdf"}{...}
{viewerjumpto "Options" "lasso##options"}{...}
{viewerjumpto "Examples" "lasso##examples"}{...}
{viewerjumpto "Stored results" "lasso##results"}{...}
{viewerjumpto "Reference" "lasso##reference"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[LASSO] lasso} {hline 2}}Lasso for prediction and model selection{p_end}
{p2col:}({mansection LASSO lasso:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{opt lasso}
{it:model}
{depvar}
[{cmd:(}{it:alwaysvars}{cmd:)}]
{it:othervars}
{ifin}
[{it:{help lasso##weight:weight}}]
[{cmd:,} {it:options}]

{phang}
{it:model} is one of {cmd:linear}, {cmd:logit}, {cmd:probit}, or {cmd:poisson}.

{phang}
{it:alwaysvars} are variables that are always included in the model.

{phang}
{it:othervars} are variables that {cmd:lasso} will choose to include in or
exclude from the model.

{synoptset 35 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{cmdab:sel:ection(}{help lasso##selmethod:{it:sel_method}}{cmd:)}}selection method to select a value of the lasso penalty parameter lambda* from the set of possible lambdas{p_end}
{synopt :{opth off:set(varname:varname_o)}}include {it:varname_o} in model with coefficient constrained to 1{p_end}
{synopt :{opth exp:osure(varname:varname_e)}}include ln({it:varname_e}) in model with coefficient constrained to 1 ({cmd:poisson} models only){p_end}

{syntab:Optimization}
{synopt :[{cmd:no}]{cmd:log}}display or suppress an iteration log{p_end}
{synopt :{opt rseed(#)}}set random-number seed{p_end}
INCLUDE help grid_short
INCLUDE help stop_short
INCLUDE help tolerance_short

INCLUDE help penaltywt_short
{synoptline}

{marker selmethod}{...}
{synoptset 35}{...}
{synopthdr:sel_method}
{synoptline}
{synopt :{cmd:cv} [{cmd:,} {help lasso##cv:{it:cv_opts}}]}select lambda* using CV; the default{p_end}
{synopt :{cmdab:adapt:ive} [{cmd:,} {help lasso##adaptive:{it:adapt_opts}} {help lasso##cv:{it:cv_opts}}]}select lambda* using an adaptive lasso{p_end}
{synopt :{cmdab:plug:in} [{cmd:,} {help lasso##plug:{it:plugin_opts}}]}select lambda* using a plugin iterative formula{p_end}
{synopt :{opt none}}do not select lambda*{p_end}
{synoptline}

{marker cv}{...}
{synoptset 35}{...}
{synopthdr:cv_opts}
{synoptline}
INCLUDE help folds_short
INCLUDE help alllambdas_short
INCLUDE help serule_short
INCLUDE help sel_opts_short
{synoptline}

{marker adaptive}{...}
{synoptset 35}{...}
{synopthdr:adapt_opts}
{synoptline}
{synopt :{opt step:s(#)}}use {it:#} adaptive steps (counting the initial lasso as step 1){p_end}
{synopt :{opt unpen:alized}}use the unpenalized estimator to construct initial weights{p_end}
{synopt :{opt ridge}}use the ridge estimator to construct initial weights{p_end}
{synopt :{opt power(#)}}raise weights to the {it:#}th power{p_end}
{synoptline}

{marker plug}{...}
{synoptset 35}{...}
{synopthdr:plugin_opts}
{synoptline}
{synopt :{opt het:eroskedastic}}assume model errors are heteroskedastic; the default{p_end}
{synopt :{opt hom:oskedastic}}assume model errors are homoskedastic{p_end}
{synoptline}
{p 4 6 2}
{it:alwaysvars} and {it:othervars} may contain factor variables; 
see {help fvvarlist}.{p_end}
{marker weight}{...}
{p 4 6 2}
Default weights are not allowed.
{cmd:iweight}s are allowed with all {it:sel_method} options.
{cmd:fweight}s are allowed when {cmd:selection(plugin)} or
{cmd:selection(none)} is specified.
See {help weight}.{p_end}
{p 4 6 2}
{opt penaltywt(matname)} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp lasso_postestimation LASSO:lasso postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Lasso > Lasso}


{marker description}{...}
{title:Description}

{pstd}
{cmd:lasso} selects covariates and fits linear, logistic, probit, and Poisson
models.  Results from {cmd:lasso} can be used for prediction and model
selection.

{pstd}
{cmd:lasso} saves but does not display estimated coefficients.  The
postestimation commands listed in
{manhelp lasso_postestimation LASSO:lasso postestimation} can be used to
generate predictions, report coefficients, and display measures of fit.

{pstd}
For an introduction to lasso, see {manhelp Lasso_intro LASSO:Lasso intro}.

{pstd}
For a description of the lasso-fitting procedure, see
{manlink LASSO lasso fitting}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection LASSO lassoQuickstart:Quick start}

        {mansection LASSO lassoRemarksandexamples:Remarks and examples}

        {mansection LASSO lassoMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{pstd}
Lasso estimation consists of three steps that the software performs
automatically.  Understanding the steps is important for understanding how to
specify options.  Note that {cmd:selection(plugin)} bypasses steps 1 and 2.
It does not require a lambda grid.

{pstd}
Step 1: Set lambda grid

{pmore}
A grid for lambda is set.  Either the default grid can be used or grid options
can be specified to modify the default.  The maximum lambda in the grid is
lambda_{gmax}.  It is automatically set to the smallest lambda yielding a model
with all coefficients zero.  The minimum lambda in the grid is lambda_{gmin}.
Typically, estimation ends before lambda_{gmin} is reached when a minimum of
the CV function is found.  If lambda_{gmin} is reached without finding a
minimum, you may want to make lambda_{gmin} smaller.  You can do this by
setting lambda_{gmin} or, alternatively, by setting the ratio
lambda_{gmin}/lambda_{gmax} to a smaller value.  See the
{helpb lasso##grid():grid()} option below.

{pstd}
Step 2: Fit the model for next lambda in grid

{pmore}
For each lambda in the grid, the set of nonzero coefficients is estimated.
Estimation starts with lambda_{gmax} and iterates toward lambda_{gmin}.  The
iteration stops when a minimum of the CV function is found, the {opt stop(#)}
stopping tolerance is met, or lambda_{gmin} is reached.  When the deviance
changes by less than a relative difference of {opt stop(#)}, the iteration
over lambda ends.  To turn off this stopping rule, specify {cmd:stop(0)}.  See
the {help lasso##optimization:optimization options} below.

{pstd}
Step 3: Select lambda*

{pmore}
A lambda denoted by lambda* is selected.  {opt selection(sel_method)}
specifies the method used to select lambda*.  The allowed {it:sel_method}s are
{cmd:cv} (the default), {cmd:adaptive}, {cmd:plugin}, and {cmd:none}: 

{pmore}
{cmd:cv}, the default, uses CV to select lambda*.  After a model is fit for
each lambda, the CV function is computed.  If a minimum of the CV function is
identified, iteration over the lambda grid ends.  To compute the CV function
for additional lambdas past the minimum, specify the suboption
{cmd:alllambdas}.  When you specify this option, step 2 is first done for all
lambdas until the stopping tolerance is met or the end of the grid is
reached.  Then, the CV function is computed for all lambdas and searched for a
minimum.  See the {help lasso##sel_cv_opts:suboptions} for {cmd:selection(cv)}
below.

{pmore}
{cmd:adaptive} also uses CV to select lambda*, but multiple lassos are
performed.  In the first lasso, a lambda* is selected, and penalty weights are
constructed from the coefficient estimates.  Then, these weights are used in a
second lasso where another lambda* is selected.  By default, two lassos are
performed, but more can be specified.  See the
{help lasso##sel_adapt_opts:suboptions} for {cmd:selection(adaptive)} below.

{pmore}
{cmd:plugin} computes lambda* based on an iterative formula.  Coefficient
estimates are obtained only for this single value of lambda.

{pmore}
{cmd:none} does not select a lambda*.  The CV function is not computed.  Models
are fit for all lambdas until the stopping tolerance is met or the end of the
grid is reached.  {manhelp lasso_postestimation LASSO:lasso postestimation}
commands can be used to assess different lambdas and select lambda*.

{pstd}
A longer description of the lasso-fitting procedure is given in
{manlink LASSO lasso fitting}.

{dlgtab:Model}

{phang}
{cmd:noconstant} omits the constant term.  Note, however, when there are factor
variables among the {it:othervars}, {cmd:lasso} can potentially create the
equivalent of the constant term by including all levels of a factor variable.
This option is likely best used only when all the {it:othervars} are
continuous variables and there is a conceptual reason why there should be no
constant term.

{phang}
{cmd:selection(cv)}, {cmd:selection(adaptive)}, {cmd:selection(plugin)}, and
{cmd:selection(none)} specify the selection method used to select lambda*.
These options also allow suboptions for controlling the specified selection
method.

{phang2}
{cmd:selection(cv} [{cmd:,} {it:cv_opts}]{cmd:)} is the default.  It selects
lambda* to be the lambda that gives the minimum of the CV function.  It is
widely used when the goal is prediction.
{manhelp lasso_postestimation LASSO:lasso postestimation} commands can be used
after {cmd:selection(cv)} to assess alternative lambda* values.

{marker sel_cv_opts}{...}
{pmore2}
{it:cv_opts} are {opt folds(#)}, {cmd:alllambdas}, {cmd:serule}, {cmd:stopok},
{cmd:strict}, and {cmd:gridminok}.

INCLUDE help folds_long_p

INCLUDE help alllambdas_long_p

{phang3}
{cmd:serule} selects lambda* based on the "one-standard-error rule" recommended
by {help lasso##HTW2015:Hastie, Tibshirani, and Wainwright (2015, 13-14)}
instead of the lambda that minimizes the CV function.  The one-standard-error
rule selects the largest lambda for which the CV function is within a standard
error of the minimum of the CV function.

INCLUDE help sel_opts_long_p

{marker selection_adapt}{...}
{phang2}
{cmd:selection(adaptive} [{cmd:,} {it:adapt_opts} {it:cv_opts}]{cmd:)} selects
lambda* using the adaptive lasso selection method.  It consists of multiple
lassos with each lasso step using CV.  Variables with zero coefficients are
discarded after each successive lasso, and variables with nonzero coefficients
are given penalty weights designed to drive small coefficient estimates to
zero in the next step.  Hence, the final model typically has fewer nonzero
coefficients than a single lasso.  The adaptive method has historically been
used when the goal of lasso is model selection.  As with {cmd:selection(cv)},
{manhelp lasso_postestimation LASSO:lasso postestimation} commands can be used
after {cmd:selection(adaptive)} to assess alternative lambda*.

{marker sel_adapt_opts}{...}
{pmore2}
{it:adapt_opts} are {opt steps(#)}, {cmd:unpenalized}, {cmd:ridge}, and
{opt power(#)}.

{phang3}
{opt steps(#)} specifies that adaptive lasso with {it:#} lassos be done.  By
default, {it:#}=2. That is, two lassos are run.  After the first lasso
estimation, terms with nonzero coefficients beta_i are given penalty weights
equal to 1/|beta_i|, terms with zero coefficients are omitted, and a second
lasso is estimated.  Terms with small coefficients are given large weights,
making it more likely that small coefficients become zero in the second lasso.
Setting {it:#} > 2 can produce more parsimonious models.  See
{mansection LASSO lassoMethodsandformulas:{it:Methods and formulas}} in
{bf:[LASSO] lasso}.

{phang3}
{cmd:unpenalized} specifies that the adaptive lasso use the unpenalized
estimator to construct the initial weights in the first lasso.  This option is
useful when CV cannot find a minimum.  {cmd:unpenalized} cannot be specified
with {cmd:ridge}.

{phang3}
{cmd:ridge} specifies that the adaptive lasso use the ridge estimator to
construct the initial weights in the first lasso.  {cmd:ridge} cannot be
specified with {cmd:unpenalized}.

{phang3}
{opt power(#)} specifies that the adaptive lasso raise the weights to the
{it:#}th power.  The default is {cmd:power(1)}.  The specified power must be
in the interval [0.25, 2].

{pmore2}
{it:cv_options} are all the suboptions that can be specified for
{cmd:selection(cv)}, namely, {opt folds(#)}, {cmd:alllambdas}, {cmd:serule},
{cmd:stopok}, {cmd:strict}, and {cmd:gridminok}.  The options
{cmd:alllambdas}, {cmd:strict}, and {cmd:gridminok} apply only to the first
lasso estimated.  For second and subsequent lassos, {cmd:gridminok} is the
default.  When {cmd:ridge} is specified, {cmd:gridminok} is automatically used
for the first lasso.

{phang2}
{cmd:selection(plugin} [{cmd:,} {it:plugin_opts}]{cmd:)} selects lambda* based
on a "plugin" iterative formula dependent on the data.  The plugin method
was designed for lasso inference methods and is useful when using {cmd:lasso}
to manually implement inference methods, such as double-selection lasso.  The
plugin estimator calculates a value for lambda* that dominates the noise in
the estimating equations, which makes it less likely to include variables that
are not in the true model.  See
{mansection LASSO lassoMethodsandformulas:{it:Methods and formulas}} in
{bf:[LASSO] lasso}.

{pmore2}
{cmd:selection(plugin)} does not estimate coefficients for any other values of
lambda, so it does not require a lambda grid, and none of the grid options
apply.  It is much faster than the other selection methods because estimation
is done only for a single value of lambda.  It is an iterative procedure,
however, and if the plugin is computing estimates for a small lambda (which
means many nonzero coefficients), the estimation can still be time consuming.
Because estimation is done only for one lambda, you cannot assess alternative
lambda* as the other selection methods allow.

{pmore2}
{it:plugin_opts} are {cmd:heteroskedastic} and {cmd:homoskedastic}.

{phang3}
{cmd:heteroskedastic} ({cmd:linear} models only) assumes model errors are
heteroskedastic.  It is the default.  Specifying {cmd:selection(plugin)} for
{cmd:linear} models is equivalent to specifying 
{cmd:selection(plugin, heteroskedastic)}.

{phang3}
{cmd:homoskedastic} ({cmd:linear} models only) assumes model errors are
homoskedastic.  See
{mansection LASSO lassoMethodsandformulas:{it:Methods and formulas}} in
{bf:[LASSO] lasso}.

{phang2}
{cmd:selection(none)} does not select a lambda*.  Lasso is estimated for the
grid of values for lambda, but no attempt is made to determine which lambda
should be selected.  The postestimation command {helpb lassoknots} can be run
to view a table of lambdas that define the knots (the sequential sets of
nonzero coefficients) for the estimation.  The {helpb lassoselect} command can
be used to select a value for lambda*, and {helpb lassogof} can be run to
evaluate the prediction performance of lambda*.

{pmore2}
When {cmd:selection(none)} is specified, the CV function is not computed.  If
you want to view the knot table with values of the CV function shown and then
select lambda*, you must specify {cmd:selection(cv)}.  There are no suboptions
for {cmd:selection(none)}.

{phang}
{opth "offset(varname:varname_o)"} specifies that {it:varname_o} be included
in the model with its coefficient constrained to be 1.

{phang}
{opth "exposure(varname:varname_e)"} can be specified only for {cmd:poisson}
models.  It specifies that ln({it:varname_e}) be included in the model with
its coefficient constrained to be 1.

{marker optimization}{...}
{dlgtab:Optimization}

{phang}
[{cmd:no}]{cmd:log} displays or suppresses a log showing the progress of the
estimation.

{phang}
{opt rseed(#)} sets the random-number seed.  This option can be used to
reproduce results for {cmd:selection(cv)} and {cmd:selection(adaptive)}.  The
other selection methods, {cmd:selection(plugin)} and {cmd:selection(none)}, do
not use random numbers.  {opt rseed(#)} is equivalent to typing {cmd:set}
{cmd:seed} {it:#} prior to running {cmd:lasso}.  See
{manhelp set_seed R:set seed}.

INCLUDE help grid_long

INCLUDE help stop_long

INCLUDE help tolerance_long

{pstd}
The following option is available with {cmd:lasso} but is not shown in the
dialog box:

INCLUDE help penaltywt_long


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse cattaneo2}

{pstd}Lasso linear regression{p_end}
{phang2}{cmd:. lasso linear bweight c.mage##c.mage c.fage##c.fage}
    {cmd:c.mage#c.fage c.fedu##c.medu}
    {cmd:i.(mmarried mhisp fhisp foreign alcohol msmoke fbaby prenatal1)}

{pstd}Lasso linear regression using the plugin selection to obtain lambda
{p_end}
{phang2}{cmd:. lasso linear bweight c.mage##c.mage c.fage##c.fage}
    {cmd:c.mage#c.fage c.fedu##c.medu} 
    {cmd:i.(mmarried mhisp fhisp foreign alcohol msmoke fbaby prenatal1),} 
    {cmd:selection(plugin)}
  
{pstd}Lasso logistic regression{p_end}
{phang2}{cmd:. lasso logit lbweight c.mage##c.mage c.fage##c.fage}
    {cmd:c.mage#c.fage c.fedu##c.medu}
    {cmd:i.(mmarried mhisp fhisp foreign alcohol msmoke fbaby prenatal1)}

{pstd}Lasso logistic regression using adaptive lasso to select lambda{p_end}
{phang2}{cmd:. lasso logit lbweight c.mage##c.mage c.fage##c.fage}
    {cmd:c.mage#c.fage c.fedu##c.medu}
    {cmd:i.(mmarried mhisp fhisp foreign alcohol msmoke fbaby prenatal1),}
    {cmd:selection(adaptive)}
  
{pstd}Lasso Poisson regression{p_end}
{phang2}{cmd:. lasso poisson nprenatal c.mage##c.mage c.fage##c.fage}
    {cmd:c.mage#c.fage c.fedu##c.medu}
    {cmd:i.(mmarried mhisp fhisp foreign alcohol msmoke fbaby prenatal1)}
  
{pstd}Lasso Poisson regression extending the lambda grid to include smaller
values{p_end}
{phang2}{cmd:. lasso poisson nprenatal c.mage##c.mage c.fage##c.fage}
   {cmd:c.mage#c.fage c.fedu##c.medu}
   {cmd:i.(mmarried mhisp fhisp foreign alcohol msmoke fbaby prenatal1),}
   {cmd:grid(100, ratio(1e-5))}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:lasso} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k_allvars)}}number of potential variables{p_end}
{synopt:{cmd:e(k_nonzero_sel)}}number of nonzero coefficients for selected model{p_end}
{synopt:{cmd:e(k_nonzero_cv)}}number of nonzero coefficients at CV mean function minimum{p_end}
{synopt:{cmd:e(k_nonzero_serule)}}number of nonzero coefficients for one-standard-error rule{p_end}
{synopt:{cmd:e(k_nonzero_min)}}minimum number of nonzero coefficients among
estimated lambdas{p_end}
{synopt:{cmd:e(k_nonzero_max)}}maximum number of nonzero coefficients among
estimated lambdas{p_end}
{synopt:{cmd:e(lambda_sel)}}value of selected lambda*{p_end}
{synopt:{cmd:e(lambda_gmin)}}value of lambda at grid minimum{p_end}
{synopt:{cmd:e(lambda_gmax)}}value of lambda at grid maximum{p_end}
{synopt:{cmd:e(lambda_last)}}value of last lambda computed{p_end}
{synopt:{cmd:e(lambda_cv)}}value of lambda at CV mean function minimum{p_end}
{synopt:{cmd:e(lambda_serule)}}value of lambda for one-standard-error rule{p_end}
{synopt:{cmd:e(ID_sel)}}ID of selected lambda*{p_end}
{synopt:{cmd:e(ID_cv)}}ID of lambda at CV mean function minimum{p_end}
{synopt:{cmd:e(ID_serule)}}ID of lambda for one-standard-error rule{p_end}
{synopt:{cmd:e(cvm_min)}}minimum CV mean function value{p_end}
{synopt:{cmd:e(cvm_serule)}}CV mean function value at one-standard-error rule{p_end}
{synopt:{cmd:e(devratio_min)}}minimum deviance ratio{p_end}
{synopt:{cmd:e(devratio_max)}}maximum deviance ratio{p_end}
{synopt:{cmd:e(L1_min)}}minimum value of ell_1-norm of penalized unstandardized coefficients{p_end}
{synopt:{cmd:e(L1_max)}}maximum value of ell_1-norm of penalized unstandardized coefficients{p_end}
{synopt:{cmd:e(L2_min)}}minimum value of ell_2-norm of penalized unstandardized coefficients{p_end}
{synopt:{cmd:e(L2_max)}}maximum value of ell_2-norm of penalized unstandardized coefficients{p_end}
{synopt:{cmd:e(ll_sel)}}log-likelihood value of selected model{p_end}
{synopt:{cmd:e(n_lambda)}}number of lambdas{p_end}
{synopt:{cmd:e(n_fold)}}number of CV folds{p_end}
{synopt:{cmd:e(stop)}}stopping rule tolerance{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:lasso}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(allvars)}}names of all potential variables{p_end}
{synopt:{cmd:e(allvars_sel)}}names of all selected variables{p_end}
{synopt:{cmd:e(alwaysvars)}}names of always-included variables{p_end}
{synopt:{cmd:e(othervars_sel)}}names of other selected variables{p_end}
{synopt:{cmd:e(post_sel_vars)}}all variables needed for postlasso{p_end}
{synopt:{cmd:e(lasso_selection)}}selection method{p_end}
{synopt:{cmd:e(sel_criterion)}}criterion used to select lambda*{p_end}
{synopt:{cmd:e(plugin_type)}}type of plugin lambda{p_end}
{synopt:{cmd:e(model)}}{cmd:linear}, {cmd:logit}, {cmd:poisson}, or {cmd:probit}{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(rngstate)}}random-number state used{p_end}
{synopt:{cmd:e(properties)}}{cmd:b}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}penalized unstandardized coefficient vector{p_end}
{synopt:{cmd:e(b_standardized)}}penalized standardized coefficient vector{p_end}
{synopt:{cmd:e(b_postselection)}}postselection coefficient vector{p_end}

{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker reference}{...}
{title:Reference}

{marker HTW2015}{...}
{phang}
Hastie, T., R. Tibshirani, and M. Wainwright. 2015.
{it:Statistical Learning with Sparsity: The Lasso and Generalizations}.
Boca Raton, FL: CRC Press.{p_end}
