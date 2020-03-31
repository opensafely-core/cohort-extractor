{smcl}
{* *! version 1.3.4  21mar2013}{...}
{viewerdialog predict "dialog xtmixed_p"}{...}
{viewerdialog estat "dialog xtmixed_estat"}{...}
{vieweralsosee "[XT] xtmixed" "help xtmixed"}{...}
{viewerjumpto "Description" "xtmixed postestimation##description"}{...}
{viewerjumpto "Special-interest postestimation commands" "xtmixed postestimation##special"}{...}
{viewerjumpto "" "--"}{...}
{viewerjumpto "Syntax for predict" "xtmixed postestimation##syntax_predict"}{...}
{viewerjumpto "Options for predict" "xtmixed postestimation##options_predict"}{...}
{viewerjumpto "" "--"}{...}
{viewerjumpto "Syntax for estat group" "xtmixed postestimation##syntax_estat_group"}{...}
{viewerjumpto "Syntax for estat recovariance" "xtmixed postestimation##syntax_estat_recov"}{...}
{viewerjumpto "Options for estat recovariance" "xtmixed postestimation##options_estat_recov"}{...}
{viewerjumpto "Syntax for estat icc" "xtmixed postestimation##syntax_estat_icc"}{...}
{viewerjumpto "Option for estat icc" "xtmixed postestimation##option_estat_icc"}{...}
{viewerjumpto "" "--"}{...}
{viewerjumpto "Examples" "xtmixed postestimation##examples"}{...}
{viewerjumpto "Saved results" "xtmixed postestimation##saved_results"}{...}
{pstd}
{cmd:xtmixed} has been renamed to {helpb mixed}; see
{manhelp mixed_postestimation ME:mixed postestimation}.
{cmd:xtmixed} continues to work but, as of Stata 13, is no longer an official
part of Stata.  This is the original help file, which we will no longer update,
so some links may no longer work.

{hline}

{title:Title}

{p2colset 5 36 38 2}{...}
{p2col :{hi:[XT] xtmixed postestimation} {hline 2}}Postestimation tools for
xtmixed{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The following postestimation commands are of special interest after
{cmd:xtmixed}:

{synoptset 18}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb xtmixed postestimation##estatgroup:estat group}}summarize
the composition of the nested groups{p_end}
{synopt :{helpb xtmixed postestimation##estatcov:estat recovariance}}display
 the estimated random-effects covariance matrix{p_end}
{synopt :{helpb xtmixed postestimation##estaticc:estat icc}}estimate
intraclass correlations{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 14}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
{synopt:{bf:{help estat}}}AIC, BIC, VCE, and estimation sample summary{p_end}
INCLUDE help post_estimates
INCLUDE help post_lincom
INCLUDE help post_lrtest
INCLUDE help post_margins
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb xtmixed postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker special}{...}
{title:Special-interest postestimation commands}

{pstd}
{cmd:estat group} reports number of groups and minimum, average, and maximum
group sizes for each level of the model.  Model levels are identified by 
the corresponding group variable in the data.  Because groups are treated
as nested, the information in this summary may differ from what you would
get had you {cmd:tabulate}d each group variable yourself.

{pstd}
{cmd:estat recovariance} displays the estimated variance-covariance matrix 
of the random effects for each level.  Random effects can be either
random intercepts, in which case the corresponding rows and columns 
of the matrix are labeled as _cons, or random coefficients, in which case
the label is the name of the associated variable in the data.

{pstd}
{cmd:estat icc} displays the intraclass correlation for pairs of responses at
each nested level of the model. Intraclass correlations are available for
random-intercept models or for random-coefficient models conditional on
random-effects covariates being equal to zero.  They are not available for
crossed-effects models or with residual error structures other than
independent structures.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 4 4 2}
Syntax for obtaining best linear unbiased predictions (BLUPs) of random 
effects, or the BLUPs' standard errors

{p 8 16 2}
{cmd:predict} {dtype} {{it:stub}{cmd:*}{c |}{it:{help newvarlist}}} {ifin}
{cmd:,} {{opt ref:fects} | {opt reses}} [{opt l:evel(levelvar)}]

{p 4 4 2}
Syntax for obtaining scores after ML estimation

{p 8 16 2}
{cmd:predict} {dtype} {c -(}{it:stub}{cmd:*}|{it:{help newvarlist}}{c )-}
{ifin} {cmd:,} {cmdab:sc:ores}

{p 4 4 2}
Syntax for obtaining other predictions

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} 
[{cmd:,} {it:statistic} {opt l:evel(levelvar)}]


{synoptset 13 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{cmd:xb}}xb, linear predictor for the {it:fixed} portion of the 
model{p_end}
{synopt :{cmd:stdp}}standard error of the fixed-portion linear 
prediction xb{p_end}
{synopt :{opt fit:ted}}fitted values, linear predictor of the fixed 
portion plus contributions based on predicted random
effects
{p_end}
{synopt :{opt r:esiduals}}residuals, response minus fitted values
{p_end}
{p2coldent :* {opt rsta:ndard}}standardized residuals{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help unstarred


INCLUDE help menu_predict


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt xb} calculates the linear prediction for the fixed portion of the
model. 

{phang}
{opt stdp} calculates the standard error of the fixed-portion linear prediction.

{phang}
{opt level(levelvar)} specifies the level in the model at which
predictions involving random effects are to be obtained; see below for the
specifics.  {it:levelvar} is the name of the model level, and is either the
name of the variable describing the grouping at that level or {cmd:_all}, a 
special designation for a group comprising all the estimation data.

{marker reffects}{...}
{phang}
{opt reffects} calculates best linear unbiased predictions (BLUPs) of the 
random effects.  By default, BLUPs for all random effects in the model 
are calculated.  However, if the {opt level(levelvar)} option is specified,
then BLUPs for only level {it:levelvar} in the model are calculated.  For
example, if {cmd:class}es are nested within {cmd:school}s, then 

{p 12 16 2}{cmd:. predict b*, reffects level(school)}{p_end}

{pmore}
would be used to obtain BLUPs at the {cmd:school} level.  You must specify
{it:q} new variables, where {it:q} is the number of random-effects terms
in the model (or level).   However, it is much easier to just specify 
{it:stub}{cmd:*} and let Stata name the variables {it:stub}{cmd:1}...{it:stubq}
for you.

{phang}
{opt reses} calculates the standard errors of the best linear unbiased
predictions (BLUPs) of the random effects.  By default, standard 
errors for all BLUPs in the model are calculated.  However, if the
{opt level(levelvar)} option is specified, then standard errors for 
only level {it: levelvar} in the model are calculated; see
the {helpb xtmixed postestimation##reffects:reffects} option.
You must specify {it:q} new variables, where {it:q} is the number of
random-effects terms in the model (or level).  However, it is much easier to
just specify {it:stub}{cmd:*} and let Stata name the variables
{it:stub}{cmd:1}...{it:stubq} for you.

{pmore}
Option {opt reses} is not available after estimation with robust/cluster 
variances.

{pmore}
The {cmd:reffects} and {cmd:reses} options often generate multiple new 
variables at once.  When this occurs, the random effects (or standard 
errors) contained in the
generated variables correspond to the order in which the variance components
are listed in the output of {cmd:xtmixed}.  Still, examining the variable
labels of the generated variables (using the {cmd:describe} command, for
instance) can be useful in deciphering which variables correspond to which
terms in the model.

{phang}
{cmd:scores} calculates the parameter-level scores, one for each parameter 
in the model including regression coefficients and variance
components.  The score for a parameter is the first derivative of the
log likelihood (or log pseudolikelihood) with respect to that parameter.
One score per highest-level group is calculated, and it is placed on the
last record within that group.  Scores are calculated in the estimation
metric as stored in {cmd:e(b)}.

{pmore}
{cmd:scores} is not available after restricted maximum-likelihood
(REML) estimation.

{phang}
{opt fitted} calculates fitted values, which are equal to the fixed-portion
linear predictor {it:plus} contributions based on predicted
random effects, or in mixed-model notation, xb + Zu.   By default, the fitted
values take into account random effects from all levels in the model, however,
if the {opt level(levelvar)} option is specified, then the fitted values are
fit beginning at the top-most level down to and including level
{it:levelvar}.  For example, if {cmd:class}es are nested within {cmd:school}s,
then

{p 12 16 2}{cmd:. predict yhat1, fitted level(school)}{p_end}

{pmore}
would produce school-level predictions.  That is, the predictions 
would incorporate school-specific random effects, but not those for 
each class nested within each school.

{phang}
{opt residuals} calculates residuals, equal to the responses minus fitted 
values.  By default, the fitted values take into account random effects
from all levels in the model, however, if the {opt level(levelvar)} option is
specified, then the fitted values are fit beginning at the top-most 
level down to and including level {it:levelvar}.

{phang}
{opt rstandard} calculates standardized residuals, equal to the residuals
multiplied by the inverse square root of the estimated error covariance matrix.


{marker syntax_estat_group}{...}
{marker estatgroup}{...}
{title:Syntax for estat group}

{p 8 14 2}
{cmd:estat} {opt gr:oup} 


INCLUDE help menu_estat


{marker syntax_estat_recov}{...}
{marker estatcov}{...}
{title:Syntax for estat recovariance}

{p 8 14 2}
{cmd:estat} {opt recov:ariance} [{cmd:,} {opt l:evel(levelvar)}
          {opt corr:elation} {help matlist:{it:matlist_options}}]


INCLUDE help menu_estat


{marker options_estat_recov}{...}
{title:Options for estat recovariance}

{phang}
{opt level(levelvar)} specifies the level in the model for which the
random-effects covariance matrix is to be displayed.  By default, the
covariance matrices for all levels in the model are displayed.  {it:levelvar}
is the name of the model level and is either the name of variable describing
the grouping at that level or {cmd:_all}, a special designation for a group
comprising all the estimation data.

{phang}
{opt correlation} displays the covariance matrix as a correlation matrix.

{phang}
{it:matlist_options} control how the matrix (or matrices) are displayed.  See
{helpb matlist:[P] matlist} for details.


{marker syntax_estat_icc}{...}
{marker estaticc}{...}
{title:Syntax for estat icc}

{p 8 14 2}
{cmd:estat} {opt icc} [{cmd:,} {opt l:evel(#)}] 

          
INCLUDE help menu_estat


{marker option_estat_icc}{...}
{title:Option for estat icc}

{phang}
{opt level(#)}
specifies the confidence level, as a percentage, for confidence intervals.
The default is {cmd:level(95)} or as set by {helpb set level}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse pig}{p_end}
{phang2}{cmd:. xtmixed weight week || id: week, covariance(unstructured)}
                {cmd:variance}{p_end}

{pstd}Random-effects covariance matrix for level id{p_end}
{phang2}{cmd:. estat recovariance}{p_end}

{pstd}Random-effects correlation matrix for level id{p_end}
{phang2}{cmd:. estat recovariance, correlation}{p_end}

{pstd}BLUPS of random effects{p_end}
{phang2}{cmd:. predict u1 u0, reffects}{p_end}

{pstd}Standard errors of BLUPs{p_end}
{phang2}{cmd:. predict s1 s0, reses}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse productivity, clear}{p_end}
{phang2}{cmd:. xtmixed gsp private emp hwy water other unemp || region: ||}
             {cmd:state:}{p_end}

{pstd}Summarize composition of nested groups{p_end}
{phang2}{cmd:. estat group}{p_end}

{pstd}Fitted values at region level{p_end}
{phang2}{cmd:. predict gsp_region, fitted level(region)}{p_end}

{pstd}Log likelihood scores{p_end}
{phang2}{cmd:. predict double sc*, scores}{p_end}

{pstd}Compute residual intraclass correlations{p_end}
{phang2}{cmd:. estat icc}{p_end}

    {hline}


{marker saved_results}{...}
{title:Saved results}

{pstd}
{cmd:estat recovariance} saves the last-displayed random-effects covariance
matrix in {cmd:r(cov)} or in {cmd:r(corr)} if it is displayed as a correlation
matrix.
{p_end}

{pstd}
{cmd:estat icc} saves the following in {cmd:r()}:

{synoptset 13 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(icc}{it:#}{cmd:)}}level-{it:#} intraclass correlation{p_end}
{synopt:{cmd:r(se}{it:#}{cmd:)}}standard errors of level-{it:#} intraclass
         correlation{p_end}
{synopt:{cmd:r(level)}}confidence level of confidence intervals{p_end}
{p2colreset}{...}

{synoptset 13 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(label}{it:#}{cmd:)}}label for level {it:#}{p_end}
{p2colreset}{...}

{synoptset 13 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(ci}{it:#}{cmd:)}}vector of confidence intervals (lower and upper)
        for level-{it:#} intraclass correlation{p_end}
{p2colreset}{...}

{pstd}
For a {it:G}-level nested model, {it:#} can be any integer between 2 and {it:G}.
{p_end}
