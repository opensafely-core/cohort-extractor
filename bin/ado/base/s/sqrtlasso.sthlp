{smcl}
{* *! version 1.0.1  14feb2020}{...}
{viewerdialog sqrtlasso "dialog sqrtlasso"}{...}
{vieweralsosee "[LASSO] sqrtlasso" "mansection lasso sqrtlasso"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[LASSO] lasso postestimation" "help lasso postestimation"}{...}
{vieweralsosee "[LASSO] elasticnet" "help elasticnet"}{...}
{vieweralsosee "[LASSO] lasso" "help lasso"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{viewerjumpto "Syntax" "sqrtlasso##syntax"}{...}
{viewerjumpto "Menu" "sqrtlasso##menu"}{...}
{viewerjumpto "Description" "sqrtlasso##description"}{...}
{viewerjumpto "Links to PDF documentation" "sqrtlasso##linkspdf"}{...}
{viewerjumpto "Options" "sqrtlasso##options"}{...}
{viewerjumpto "Examples" "sqrtlasso##examples"}{...}
{viewerjumpto "Stored results" "sqrtlasso##results"}{...}
{viewerjumpto "Reference" "sqrtlasso##reference"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[LASSO] sqrtlasso} {hline 2}}Square-root lasso for prediction and
model selection{p_end}
{p2col:}({mansection LASSO sqrtlasso:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{opt sqrtlasso}
{depvar}
[{cmd:(}{it:alwaysvars}{cmd:)}]
{it:othervars}
{ifin}
[{it:{help sqrtlasso##weight:weight}}]
[{cmd:,} {it:options}]

{phang}
{it:alwaysvars} are variables that are always included in the model.

{phang}
{it:othervars} are variables that {cmd:sqrtlasso} will choose to include in or
exclude from the model.

{synoptset 35 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{cmdab:sel:ection(}{help sqrtlasso##selmethod:{it:sel_method}}{cmd:)}}selection method to select a value of the square-root lasso penalty parameter lambda* from the set of possible lambdas{p_end}
{synopt :{opth off:set(varname:varname_o)}}include {it:varname_o} in model with coefficient constrained to 1{p_end}

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
{synopt :{cmd:cv} [{cmd:,} {help sqrtlasso##cv:{it:cv_opts}}]}select lambda* using CV; the default{p_end}
{synopt :{cmdab:plug:in} [{cmd:,} {help sqrtlasso##plug:{it:plugin_opts}}]}select lambda* using a plugin iterative formula{p_end}
{synopt :{opt none}}do not select lambda*{p_end}
{synoptline}

{marker cv}{...}
{synopthdr:cv_opts}
{synoptline}
INCLUDE help folds_short
INCLUDE help alllambdas_short
INCLUDE help serule_short
INCLUDE help sel_opts_short
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
{bf:Statistics > Lasso > Square-root lasso}


{marker description}{...}
{title:Description}

{pstd}
{cmd:sqrtlasso} selects covariates and fits linear models using square-root
lasso.  Results from {cmd:sqrtlasso} can be used for prediction and model
selection.  Results from {cmd:sqrtlasso} are typically similar to results from
{cmd:lasso}.

{pstd}
{cmd:sqrtlasso} saves but does not display estimated coefficients.  The
{manhelp lasso_postestimation LASSO:lasso postestimation} commands can be used
to generate predictions, report coefficients, and display measures of fit.

{pstd}
For an introduction to lasso, see {manhelp Lasso_intro LASSO:Lasso intro}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection LASSO sqrtlassoQuickstart:Quick start}

        {mansection LASSO sqrtlassoRemarksandexamples:Remarks and examples}

        {mansection LASSO sqrtlassoMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{pstd}
See {manlink LASSO lasso fitting} for an overview of the lasso
estimation procedure and a detailed description of how to set options to
control it.

{dlgtab:Model}

{phang}
{cmd:noconstant} omits the constant term.  Note, however, when there are factor
variables among the {it:othervars}, {cmd:sqrtlasso} can potentially create the
equivalent of the constant term by including all levels of a factor variable.
This option is likely best used only when all the {it:othervars} are continuous
variables and there is a conceptual reason why there should be no constant
term.

{phang}
{cmd:selection(cv)}, {cmd:selection(plugin)}, and {cmd:selection(none)} specify
the selection method used to select lambda*.  These options also allow
suboptions for controlling the specified selection method.

{phang2}
{cmd:selection(cv} [{cmd:,} {it:cv_opts}]{cmd:)} is the default.  It selects
lambda* to be the lambda that gives the minimum of the CV function.
{manhelp lasso_postestimation LASSO:lasso postestimation} commands can be
used after {cmd:selection(cv)} to assess alternative lambda*.

{marker sel_cv_opts}{...}
{pmore2}
{it:cv_opts} are {opt folds(#)}, {cmd:alllambdas}, {cmd:serule}, {cmd:stopok},
{cmd:strict}, and {cmd:gridminok}.

INCLUDE help folds_long_p

INCLUDE help alllambdas_long_p

{phang3}
{cmd:serule} selects lambda* based on the "one-standard-error rule" recommended
by {help sqrtlasso##HTW2015:Hastie, Tibshirani, and Wainwright (2015, 13-14)}
instead of the lambda that minimizes the CV function.  The one-standard-error
rule selects the largest lambda for which the CV function is within a standard
error of the minimum of the CV function.

INCLUDE help sel_opts_long_p

{phang2}
{cmd:selection(plugin} [{cmd:,} {it:plugin_opts}]{cmd:)} selects lambda* based
on a "plugin" iterative formula dependent on the data.  The plugin method was
designed for lasso inference methods and is useful when using {cmd:sqrtlasso}
to manually implement inference methods, such as double-selection lasso.  The
plugin estimator calculates a value for lambda* that dominates the noise in the
estimating equations, which makes it less likely to include variables that are
not in the true model.  See 
{mansection LASSO sqrtlassoMethodsandformulas:{it:Methods and formulas}} in
{bf:[LASSO] sqrtlasso}.

{pmore2}
{cmd:selection(plugin)} does not estimate coefficients for any other values of
lambda, so it does not require a lambda grid, and none of the grid options
apply.  It is much faster than {cmd:selection(cv)} because estimation is done
only for a single value of lambda.  It is an iterative procedure, however, and
if the plugin is computing estimates for a small lambda (which means many
nonzero coefficients), the estimation can still be time consuming.  Because
estimation is done only for one lambda, you cannot assess alternative lambda*
as the other selection methods allow.

{pmore2}
{it:plugin_opts} are {cmd:heteroskedastic} and {cmd:homoskedastic}.

{phang3}
{cmd:heteroskedastic} assumes model errors are heteroskedastic.  It is the
default.  Specifying {cmd:selection(plugin)} is equivalent to specifying
{cmd:selection(plugin, heteroskedastic)}.

{phang3}
{cmd:homoskedastic} assumes model errors are homoskedastic.  See
{mansection LASSO sqrtlassoMethodsandformulas:{it:Methods and formulas}} in
{bf:[LASSO] sqrtlasso}.

{phang2}
{cmd:selection(none)} does not select a lambda*.  Square-root lasso is
estimated for the grid of values for lambda, but no attempt is made to
determine which lambda should be selected.  The postestimation command
 {helpb lassoknots} can be run to view a table of lambdas that define the
knots (the sets of nonzero coefficients) for the estimation.  The
{helpb lassoselect} command can be used to select a value for lambda*, and
{helpb lassogof} can be run to evaluate the prediction performance of lambda*.

{pmore2}
When {cmd:selection(none)} is specified, the CV function is not computed.
If you want to view the knot table with values of the CV function shown and
then select lambda*, you must specify {cmd:selection(cv)}.  There are no
suboptions for {cmd:selection(none)}.

{phang}
{opth "offset(varname:varname_o)"} specifies that {it:varname_o} be included in
the model with its coefficient constrained to be 1.

{marker optimization}{...}
{dlgtab:Optimization}

{phang}
[{cmd:no}]{cmd:log} displays or suppresses a log showing the progress of the
estimation.

{phang}
{opt rseed(#)} sets the random-number seed.  This option can be used to
reproduce results for {cmd:selection(cv)}.  The other selection methods,
{cmd:selection(plugin)} and {cmd:selection(none)}, do not use random numbers.
{opt rseed(#)} is equivalent to typing {cmd:set} {cmd:seed} {it:#} prior to
running {cmd:sqrtlasso}.  See {manhelp set_seed R:set seed}.

INCLUDE help grid_long

{phang}
{opt stop(#)} specifies a tolerance that is the stopping criterion for the
lambda iterations.  The default is 1e-5.  This option does not apply when
the selection method is {cmd:selection(plugin)}.  Estimation starts with the
maximum grid value, lambda_{gmax}, and iterates toward the minimum grid
value, lambda_{gmin}.  When the relative difference in the deviance
produced by two adjacent lambda grid values is less than {opt stop(#)}, the
iteration stops and no smaller lambdas are evaluated.  The value of lambda
that meets this tolerance is denoted by lambda_{stop}.  Typically, this
stopping criterion is met before the iteration reaches lambda_{gmin}.

{pmore}
Setting {opt stop(#)} to a larger value means that iterations are stopped
earlier at a larger lambda_{stop}.  To produce coefficient estimates for all
values of the lambda grid, you can specify {cmd:stop(0)}.  Note, however, that
computations for small lambdas can be extremely time consuming.  In terms of
time, when you use {cmd:selection(cv)}, the optimal value of {opt stop(#)} is
the largest value that allows estimates for just enough lambdas to be computed
to identify the minimum of the CV function.  When setting {opt stop(#)} to
larger values, be aware of the consequences of the default lambda* selection
procedure given by the default {cmd:stopok}. You may want to override the
{cmd:stopok} behavior by using {cmd:strict}.

INCLUDE help tolerance_long

{pstd}
The following option is available with {cmd:sqrtlasso} but is not shown in the
dialog box:

{phang}
{opt penaltywt(matname)} is a programmer's option for specifying a vector of
weights for the coefficients in the penalty term.  The contribution of each
coefficient to the square-root lasso penalty term is multiplied by its
corresponding weight.  Weights must be nonnegative.  By default, each
coefficient's penalty weight is 1.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse cattaneo2}{p_end}
{phang2}{cmd:. keep  if fbaby==1}

{pstd}Lasso linear regression on a subsample of first time mothers{p_end}
{phang2}{cmd:. sqrtlasso bweight c.mage##c.mage c.fage##c.fage c.mage#c.fage}
    {cmd:c.fedu##c.medu}
    {cmd:i.(mmarried mhisp fhisp foreign alcohol msmoke fbaby prenatal1)}
 
{pstd}Square-root lasso regression using plugin to select lambda{p_end}
{phang2}{cmd:. sqrtlasso bweight c.mage##c.mage c.fage##c.fage c.mage#c.fage}
    {cmd:c.fedu##c.medu}
    {cmd:i.(mmarried mhisp fhisp foreign alcohol msmoke fbaby prenatal1),} 
    {cmd:selection(plugin)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:sqrtlasso} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k_allvars)}}number of potential variables{p_end}
{synopt:{cmd:e(k_nonzero_sel)}}number of nonzero coefficients for selected model{p_end}
{synopt:{cmd:e(k_nonzero_cv)}}number of nonzero coefficients at CV mean function minimum{p_end}
{synopt:{cmd:e(k_nonzero_serule)}}number of nonzero coefficients for one-standard-error rule{p_end}
{synopt:{cmd:e(k_nonzero_min)}}minimum number of nonzero coefficients among estimated lambdas{p_end}
{synopt:{cmd:e(k_nonzero_max)}}maximum number of nonzero coefficients among estimated lambdas{p_end}
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
{synopt:{cmd:e(cmd)}}{cmd:sqrtlasso}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(allvars)}}names of all potential variables{p_end}
{synopt:{cmd:e(allvars_sel)}}names of all selected variables{p_end}
{synopt:{cmd:e(alwaysvars)}}names of always-included variables{p_end}
{synopt:{cmd:e(othervars_sel)}}names of other selected variables{p_end}
{synopt:{cmd:e(post_sel_vars)}}all variables needed for post-square-root lasso{p_end}
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
{it:Statistical Learning with Sparsity: The Lasso and Generalizations}.  Boca
Raton, FL: CRC Press.{p_end}
