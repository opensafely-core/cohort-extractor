{smcl}
{* *! version 1.0.1  14feb2020}{...}
{viewerdialog elasticnet "dialog elasticnet"}{...}
{vieweralsosee "[LASSO] elasticnet" "mansection lasso elasticnet"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[LASSO] lasso postestimation" "help lasso postestimation"}{...}
{vieweralsosee "[LASSO] lasso" "help lasso"}{...}
{vieweralsosee "[LASSO] sqrtlasso" "help sqrtlasso"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] logit" "help logit"}{...}
{vieweralsosee "[R] poisson" "help poisson"}{...}
{vieweralsosee "[R] probit" "help probit"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{viewerjumpto "Syntax" "elasticnet##syntax"}{...}
{viewerjumpto "Menu" "elasticnet##menu"}{...}
{viewerjumpto "Description" "elasticnet##description"}{...}
{viewerjumpto "Links to PDF documentation" "elasticnet##linkspdf"}{...}
{viewerjumpto "Options" "elasticnet##options"}{...}
{viewerjumpto "Examples" "elasticnet##examples"}{...}
{viewerjumpto "Stored results" "elasticnet##results"}{...}
{viewerjumpto "Reference" "elasticnet##reference"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[LASSO] elasticnet} {hline 2}}Elastic net for prediction and model
selection{p_end}
{p2col:}({mansection LASSO elasticnet:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{opt elasticnet}
{it:model}
{depvar}
[{cmd:(}{it:alwaysvars}{cmd:)}]
{it:othervars}
{ifin}
[{it:{help elasticnet##weight:weight}}]
[{cmd:,} {it:options}]

{phang}
{it:model} is one of {cmd:linear}, {cmd:logit}, {cmd:probit}, or {cmd:poisson}.

{phang}
{it:alwaysvars} are variables that are always included in the model.

{phang}
{it:othervars} are variables that {cmd:elasticnet} will choose to
include in or exclude from the model.

{synoptset 35 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{cmdab:sel:ection(cv}[{cmd:,} {help elasticnet##cv:{it:cv_opts}}]{cmd:)}}select mixing parameter alpha* and lasso penalty parameter lambda* using CV{p_end}
{synopt :{cmdab:sel:ection(none)}}do not select alpha* or lambda*{p_end}
{synopt :{opth off:set(varname:varname_o)}}include {it:varname_o} in model with coefficient constrained to 1{p_end}
{synopt :{opth exp:osure(varname:varname_e)}}include ln({it:varname_e}) in model with coefficient constrained to 1 ({cmd:poisson} models only){p_end}

{syntab:Optimization}
{synopt :[{opt no}]{cmd:log}}display or suppress an iteration log{p_end}
{synopt :{opt rseed(#)}}set random-number seed{p_end}
{synopt :{cmdab:alpha:s(}{it:{help numlist}}|{it:matname}{cmd:)}}specify the alpha grid with {it:numlist} or a matrix{p_end}
{synopt :{cmd:grid(}{it:#_g}[{cmd:,} {opt ratio(#)} {opt min(#)}]{cmd:)}}specify the set of possible lambdas using a logarithmic grid with {it:#_g} grid points{p_end}
{synopt :{cmdab:cross:grid(}{cmdab:aug:mented)}}augment the lambda grids for each alpha as necessary to produce a single lambda grid; the default{p_end}
{synopt :{cmdab:cross:grid(union)}}use the union of the lambda grids for each alpha to produce a single lambda grid{p_end}
{synopt :{cmdab:cross:grid(}{cmdab:diff:erent)}}use different lambda grids for each alpha{p_end}
INCLUDE help stop_short
INCLUDE help tolerance_short

INCLUDE help penaltywt_short
{synoptline}

{marker cv}{...}
{synoptset 35}{...}
{synopthdr:cv_opts}
{synoptline}
INCLUDE help folds_short
INCLUDE help alllambdas_short
INCLUDE help serule_short
{synopt :{cmd:stopok}}when, for a value of alpha, the CV function does not have an identified minimum and the {opt stop(#)} stopping criterion for lambda was 
reached at lambda_{stop}, allow lambda_{stop} to be included in an (alpha, lambda) pair that 
can potentially be selected as (alpha*, lambda*); the default{p_end}
{synopt :{cmd:strict}}requires the CV function to have an identified minimum for every value
of alpha; this is a stricter alternative to the default {cmd:stopok}{p_end}
{synopt :{cmd:gridminok}}when, for a value of alpha, the CV function does not have an identified minimum and the {opt stop(#)} stopping criterion for lambda was not 
reached, allow the minimum of the lambda grid, lambda_{gmin}, to be included in
an (alpha, lambda) pair that can potentially be selected as (alpha*, lambda*);
this option is rarely used{p_end}
{synoptline}
{p 4 6 2}
{it:alwaysvars} and {it:othervars} may contain factor variables; 
see {help fvvarlist}.{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s, the default, are allowed with {cmd:selection(none)}.
{cmd:iweight}s are allowed with both {cmd:selection(cv)} and
{cmd:selection(none)}.  See {help weight}.{p_end}
{p 4 6 2}
{opt penaltywt(matname)} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp lasso_postestimation LASSO:lasso postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Lasso > Elastic net}


{marker description}{...}
{title:Description}

{pstd}
{cmd:elasticnet} selects covariates and fits linear, logistic, probit, and
Poisson models using elastic net.
Results from {cmd:elasticnet} can be used for prediction and model selection.

{pstd}
{cmd:elasticnet} saves but does not display estimated coefficients.
The postestimation commands listed in {manhelp lasso_postestimation LASSO:lasso postestimation}
can be used to generate predictions, report coefficients, and
display measures of fit.

{pstd}
For an introduction to lasso, see {manhelp Lasso_intro LASSO:Lasso intro}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection LASSO elasticnetQuickstart:Quick start}

        {mansection LASSO elasticnetRemarksandexamples:Remarks and examples}

        {mansection LASSO elasticnetMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{pstd}
See {manlink LASSO lasso fitting} for an overview of the lasso estimation
procedure and a detailed description of how to set options to control it.

{dlgtab:Model}

{phang}
{cmd:noconstant} omits the constant term.  Note, however, when there are factor
variables among the {it:othervars}, {cmd:elasticnet} can potentially create
the equivalent of the constant term by including all levels of a factor
variable.  This option is likely best used only when all the {it:othervars} are
continuous variables and there is a conceptual reason why there should be no
constant term.

{phang}
{cmd:selection(cv)} and {cmd:selection(none)} specify the selection method used 
to select lambda*.

{phang2}
{cmd:selection(cv} [{cmd:,} {it:cv_opts}]{cmd:)} is the default.  It selects
the (alpha*, lambda*) that give the minimum of the CV function.

INCLUDE help folds_long_p

{phang3}
{cmd:alllambdas} specifies that, for each alpha, models be fit for all lambdas
in the grid or until the {opt stop(#)} tolerance is reached.  By default,
models are calculated sequentially from largest to smallest lambda, and the CV
function is calculated after each model is fit.  If a minimum of the CV
function is found, the computation ends at that point without evaluating
additional smaller lambdas.

{pmore3}
{cmd:alllambdas} computes models for these additional smaller lambdas.  Because
computation time is greater for smaller lambda, specifying {cmd:alllambdas} may
increase computation time manyfold.  Specifying {cmd:alllambdas} is typically
done only when a full plot of the CV function is wanted for assurance that a
true minimum has been found.  Regardless of whether {cmd:alllambdas} is
specified, the selected (alpha*, lambda*) will be the same.

{phang3}
{cmd:serule} selects lambda* based on the "one-standard-error rule" recommended
by {help elasticnet##HTW2015:Hastie, Tibshirani, and Wainwright (2015, 13-14)}
instead of the lambda that minimizes the CV function.  The one-standard-error
rule selects, for each alpha, the largest lambda for which the CV function is
within a standard error of the minimum of the CV function.  Then, from among
these (alpha, lambda) pairs, the one with the smallest value of the CV
function is selected.

{phang3}
{cmd:stopok}, {cmd:strict}, and {cmd:gridminok} specify what to do when, for a
value of alpha, the CV function does not have an identified minimum at any
value of lambda in the grid.  A minimum is identified at lambda_{cvmin} when
the CV function at both larger and smaller adjacent lambda's is greater than it
is at lambda_{cvmin}.  When the CV function for a value of alpha has an
identified minimum, these options all do the same thing: (alpha,
lambda_{cvmin}) becomes one of the (alpha, lambda) pairs that potentially can
be selected as the smallest value of the CV function.  In some cases, however,
the CV function declines monotonically as lambda gets smaller and never rises
to identify a minimum.  When the CV function does not have an identified
minimum, {cmd:stopok} and {cmd:gridminok} make alternative picks for lambda in
the  (alpha, lambda) pairs that will be assessed for the smallest value of the
CV function.  The option {cmd:strict} makes no alternative pick for lambda.
When {cmd:stopok}, {cmd:strict}, or {cmd:gridminok} is not specified, the
default is {cmd:stopok}.  With each of these options, estimation results are
always left in place, and alternative (alpha, lambda) pairs can be selected and
evaluated.

{p 16 20 2}
{cmd:stopok} specifies that, for a value of alpha, when the CV function does
not have an identified minimum and the {opt stop(#)} stopping tolerance for
lambda was reached at lambda_{stop}, the pair (alpha, lambda_{stop}) is picked
as one of the pairs that potentially can be selected as the smallest value of
the CV function.  lambda_{stop} is the smallest lambda for which coefficients
are estimated, and it is assumed that lambda_{stop} has a CV function value
close to the true minimum for that value of alpha.  When no minimum is
identified for a value of alpha and the {opt stop(#)} criterion is not met, an
error is issued.

{p 16 20 2}
{cmd:strict} requires the CV function to have an identified minimum for each
value of alpha, and if not, an error is issued.

{p 16 20 2}
{cmd:gridminok} is a rarely used option that specifies that, for a value of
alpha, when the CV function has no identified minimum and the {opt stop(#)}
stopping criterion was not met, lambda_{gmin}, the minimum of the lambda grid,
is picked as part of a pair (alpha, lambda_{gmin}) that potentially can be
selected as the smallest value of the CV function.

{p 16 16 2}
The {cmd:gridminok} criterion is looser than the default {cmd:stopok}, which is
looser than {cmd:strict}.  With {cmd:strict}, the selected (alpha*, lambda*)
pair is the minimum of the CV function chosen from the (alpha, lambda_{cvmin})
pairs, where all lambdas under consideration are identified minimums.  With
{cmd:stopok}, the set of (alpha, lambda) pairs under consideration for the
minimum of the CV function include identified minimums, lambda_{cvmin}, or
values, lambda_{stop}, that met the stopping criterion.  With {cmd:gridminok},
the set of (alpha, lambda) pairs under consideration for the minimum of the CV
function potentially include lambda_{cvmin}, lambda_{stop}, or lambda_{gmin}.

{phang2}
{cmd:selection(none)} specifies that no (alpha*, lambda*) pair be selected.
In this case, the elastic net is estimated for a grid of values for lambda for
each alpha, but no attempt is made to determine which (alpha, lambda) pair is
best.  The postestimation command {helpb lassoknots} can be run to view a
table of lambdas that define the knots (that is, the distinct sets of nonzero
coefficients) for each alpha.  The {helpb lassoselect} command can then be
used to select an (alpha*, lambda*) pair, and {helpb lassogof} can be run to
evaluate the prediction performance of the selected pair.

{pmore2}
When {cmd:selection(none)} is specified, the CV function is not computed.  If
you want to view the knot table with values of the CV function shown and then
select (alpha*, lambda*), you must specify {cmd:selection(cv)}.  There are no
suboptions for {cmd:selection(none)}.

{phang}
{opth "offset(varname:varname_o)"} specifies that {it:varname_o} be included
in the model with its coefficient constrained to be 1.

{phang}
{opth "exposure(varname:varname_e)"} can be specified only for {cmd:poisson}
models.  It specifies that ln({it:varname_e}) be included in the model with
its coefficient constrained to be 1.

{dlgtab:Optimization}

{phang}
[{cmd:no}]{cmd:log} displays or suppresses a log showing the progress of the
estimation.

{phang}
{opt rseed(#)} sets the random-number seed.  This option can be used to
reproduce results for {cmd:selection(cv)}.  ({cmd:selection(none)} does not use
random numbers.) {opt rseed(#)} is equivalent to typing {cmd:set} {cmd:seed}
{it:#} prior to running {cmd:elasticnet}. See {manhelp set_seed R:set seed}.

{phang}
{cmd:alphas(}{it:{help numlist}}|{it:matname}{cmd:)} 
specifies either a numlist or a matrix containing the grid of values for 
alpha.  The default is {cmd:alphas(0.5 0.75 1)}.
Specifying a small, nonzero value of alpha for one of the values
of {cmd:alphas()} will result in lengthy computation time because
the optimization algorithm for a penalty that is mostly ridge regression
with a little lasso mixed in is inherently inefficient.
Pure ridge regression (alpha=0), however, is computationally efficient.

INCLUDE help grid_long

{phang}
{cmd:crossgrid(augmented)}, {cmd:crossgrid(union)}, and 
{cmd:crossgrid(different)}
specify the type of two-dimensional grid used for (alpha, lambda).
{cmd:crossgrid(augmented)} and {cmd:crossgrid(union)}
produce a grid that is the product of two one-dimensional grids.
That is, the lambda grid is the same for every value of alpha.
{cmd:crossgrid(different)} uses different lambda grids for different values 
of alpha.

{phang2}
{cmd:crossgrid(augmented)}, the default grid, is formed by an augmentation
algorithm.  First, a suitable lambda grid for each alpha is computed.  Then,
nonoverlapping segments of these grids are formed and combined into a single
lambda grid.

{phang2}
{cmd:crossgrid(union)} specifies that the union of lambda grids across each
value of alpha be used.  That is, a lambda grid for each alpha is computed, and
then they are combined by simply putting all the lambda values into one grid
that is used for each alpha.  This produces a fine grid that can cause the
computation to take a long time without significant gain in most cases.

{phang2}
{cmd:crossgrid(different)} specifies that different lambda grids be used for
each value of alpha.  This option is rarely used.  Using different lambda grids
for different values of alpha complicates the interpretation of the CV
selection method.  When the lambda grid is not the same for every value of
alpha, comparisons are based on parameter intervals that are not on the same
scale.

{phang}
{opt stop(#)} specifies a tolerance that is the stopping criterion for the
lambda iterations.  The default is 1e-5.  Estimation starts with the maximum
grid value, lambda_{gmax}, and iterates toward the minimum grid value,
lambda_{gmin}.  When the relative difference in the deviance produced by two
adjacent lambda grid values is less than {opt stop(#)}, the iteration stops
and no smaller lambdas are evaluated.  The value of lambda that meets this
tolerance is denoted by lambda_{stop}.  Typically, this stopping criterion is
met before the iteration reaches lambda_{gmin}.

{pmore}
Setting {opt stop(#)} to a larger value means that iterations are stopped
earlier at a larger lambda_{stop}.  To produce coefficient estimates for all
values of the lambda grid, you can specify {cmd:stop(0)}.  Note, however, that
computations for small lambdas can be extremely time consuming.  In terms of
time, when you use {cmd:selection(cv)}, the optimal value of {opt stop(#)} is
the largest value that allows estimates for just enough lambdas to be
computed to identify the minimum of the CV function.  When setting 
{opt stop(#)} to larger values, be aware of the consequences of the default
lambda* selection procedure given by the default {cmd:stopok}.  You may want to
override the {cmd:stopok} behavior by using {cmd:strict}.

INCLUDE help tolerance_long

{pstd}
The following option is available with {cmd:elasticnet} but is not shown in the
dialog box:

INCLUDE help penaltywt_long


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse cattaneo2}{p_end}
{phang2}{cmd:. keep  if foreign==1}

{pstd}Elastic-net linear regression{p_end}
{phang2}{cmd:. elasticnet linear bweight c.mage##c.mage c.fage##c.fage}
    {cmd:c.mage#c.fage c.fedu##c.medu} 
    {cmd:i.(mmarried mhisp fhisp foreign alcohol msmoke fbaby prenatal1),}
    {cmd:rseed(123)}

{pstd}Elastic-net linear regression specifying a grid for alpha{p_end}
{phang2}{cmd:. elasticnet linear bweight c.mage##c.mage c.fage##c.fage}
    {cmd:c.mage#c.fage c.fedu##c.medu}
    {cmd:i.(mmarried mhisp fhisp foreign alcohol msmoke fbaby prenatal1),}
    {cmd:alphas(.8(.05)1)}

{pstd}Elastic-net logistic regression on a subsample of first time
mothers{p_end}
{phang2}{cmd:. elasticnet logit lbweight c.mage##c.mage c.fage##c.fage}
    {cmd:c.mage#c.fage c.fedu##c.medu}
    {cmd:i.(mmarried mhisp fhisp alcohol msmoke fbaby prenatal1)}

{pstd}Elastic-net logistic regression on a subsample of first time mothers 
modifying lambda grid{p_end}
{phang2}{cmd:. elasticnet logit lbweight c.mage##c.mage c.fage##c.fage}
    {cmd:c.mage#c.fage c.fedu##c.medu}
    {cmd:i.(mmarried mhisp fhisp foreign alcohol msmoke fbaby prenatal1),}
    {cmd:alphas(.9(.05)1)}
  
{pstd}Elastic-net Poisson regression on a subsample of foreign mothers{p_end}
{phang2}{cmd:. elasticnet poisson nprenatal c.mage##c.mage c.fage##c.fage}
    {cmd:c.mage#c.fage c.fedu##c.medu}
    {cmd:i.(mmarried mhisp fhisp foreign alcohol msmoke fbaby prenatal1)}

{pstd}Elastic-net Poisson regression on a subsample of foreign mothers 
extending the lambda grid to include smaller values{p_end}
{phang2}{cmd:. elasticnet poisson nprenatal c.mage##c.mage c.fage##c.fage}
    {cmd:c.mage#c.fage c.fedu##c.medu}
    {cmd:i.(mmarried mhisp fhisp foreign alcohol msmoke fbaby prenatal1),}
    {cmd:grid(100, ratio(1e-5))}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:elasticnet} stores the following in {cmd:e()}:

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
{synopt:{cmd:e(alpha_sel)}}value of selected alpha*{p_end}
{synopt:{cmd:e(alpha_cv)}}value of alpha at CV mean function minimum{p_end}
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
{synopt:{cmd:e(cmd)}}{cmd:elasticnet}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(allvars)}}names of all potential variables{p_end}
{synopt:{cmd:e(allvars_sel)}}names of all selected variables{p_end}
{synopt:{cmd:e(alwaysvars)}}names of always-included variables{p_end}
{synopt:{cmd:e(othervars_sel)}}names of other selected variables{p_end}
{synopt:{cmd:e(post_sel_vars)}}all variables needed for post-elastic net{p_end}
{synopt:{cmd:e(lasso_selection)}}selection method{p_end}
{synopt:{cmd:e(sel_criterion)}}criterion used to select lambda*{p_end}
{synopt:{cmd:e(crossgrid)}}type of two-dimensional grid{p_end}
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
Hastie, T., R. Tibshirani, and M. Wainwright. 2015. {it:Statistical Learning with Sparsity: The Lasso and Generalizations}.
Boca Raton, FL: CRC Press.{p_end}
