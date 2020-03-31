{smcl}
{* *! version 1.2.3  16jun2014}{...}
{viewerdialog predict "dialog xtmepoisson_p"}{...}
{viewerdialog estat "dialog xtmepoisson_estat"}{...}
{vieweralsosee "[XT] xtmepoisson" "help xtmepoisson"}{...}
{viewerjumpto "Description" "xtmepoisson postestimation##description"}{...}
{viewerjumpto "Special-interest postestimation commands" "xtmepoisson postestimation##special"}{...}
{viewerjumpto "" "--"}{...}
{viewerjumpto "Syntax for predict" "xtmepoisson postestimation##syntax_predict"}{...}
{viewerjumpto "Options for predict" "xtmepoisson postestimation##options_predict"}{...}
{viewerjumpto "" "--"}{...}
{viewerjumpto "Syntax for estat group" "xtmepoisson postestimation##syntax_estat_group"}{...}
{viewerjumpto "Syntax for estat recovariance" "xtmepoisson postestimation##syntax_estat_recov"}{...}
{viewerjumpto "Options for estat recovariance" "xtmepoisson postestimation##options_estat_recov"}{...}
{viewerjumpto "" "--"}{...}
{viewerjumpto "Examples" "xtmepoisson postestimation##examples"}{...}
{viewerjumpto "Saved results" "xtmepoisson postestimation##saved_results"}{...}
{viewerjumpto "Reference" "xtmepoisson postestimation##reference"}{...}
{pstd}
{cmd:xtmepoisson} has been renamed to {helpb meqrpoisson}; see
{manhelp meqrpoisson_postestimation ME:meqrpoisson postestimation}.
{cmd:xtmepoisson} continues to work but, as of Stata 13, is no longer an
official part of Stata.  This is the original help file, which we will no
longer update, so some links may no longer work.

{hline}

{title:Title}

{p2colset 5 40 42 2}{...}
{p2col :{hi:[XT] xtmepoisson postestimation} {hline 2}}Postestimation tools for
xtmepoisson{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The following postestimation commands are of special interest after
{cmd:xtmepoisson}:

{synoptset 18}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb xtmepoisson postestimation##estatgroup:estat group}}summarize
the composition of the nested groups{p_end}
{synopt :{helpb xtmepoisson postestimation##estatcov:estat recovariance}}display
the estimated random-effects covariance matrix{p_end}
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
{synopt :{helpb xtmepoisson postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
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


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 4 4 2}
Syntax for obtaining estimated random effects or their standard errors

{p 8 16 2}
{cmd:predict} {dtype} {{it:stub}{cmd:*}{c |}{it:{help newvarlist}}} {ifin}
{cmd:,} {{opt ref:fects} | {opt reses}} [{opt l:evel(levelvar)}]


{p 4 4 2}
Syntax for obtaining other predictions

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} 
[{cmd:,} {it:statistic} {opt fixed:only} {opt nooff:set}]


{synoptset 13 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt m:u}}the predicted mean; the default{p_end}
{synopt :{cmd:xb}}xb, linear predictor for the {it:fixed} portion of the 
model{p_end}
{synopt :{cmd:stdp}}standard error of the fixed-portion linear 
prediction xb{p_end}
{synopt :{opt p:earson}}Pearson residuals{p_end}
{synopt :{opt d:eviance}}deviance residuals{p_end}
{synopt :{opt a:nscombe}}Anscombe residuals{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample


INCLUDE help menu_predict


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt reffects} calculates posterior modal estimates of the 
random effects.  By default, estimates for all random effects in the model 
are calculated. However, if the {opt level(levelvar)} option is specified, then 
estimates for only level {it:levelvar} in the model are calculated.  For
example, if {cmd:class}es are nested within {cmd:school}s, then

{p 12 16 2}{cmd:. predict b*, reffects level(school)}{p_end}

{pmore}
would yield random-effects estimates at the {cmd:school} level.  You must
specify {it:q} new variables, where {it:q} is the number of random-effects
terms in the model (or level).  However, it is much easier to just specify
{it:stub}{cmd:*} and let Stata name the variables
{it:stub}{cmd:1}, {it:stub}{cmd:2}, ..., {it:stubq} for you.

{phang}
{opt reses} calculates standard errors for the random-effects
estimates obtained by using the {opt reffects} option.
By default, standard errors for all random effects in the model 
are calculated. However, if the {opt level(levelvar)} option is specified, then 
standard errors for only level {it:levelvar} in the model are calculated.  For
example, if {cmd:class}es are nested within {cmd:school}s, then

{p 12 16 2}{cmd:. predict se*, reses level(school)}{p_end}

{pmore}
would yield standard errors at the {cmd:school} level.  You must
specify {it:q} new variables, where {it:q} is the number of random-effects
terms in the model (or level).  However, it is much easier to just specify
{it:stub}{cmd:*} and let Stata name the variables
{it:stub}{cmd:1}, {it:stub}{cmd:2}, ..., {it:stubq} for you.

{pmore}
The {cmd:reffects} and {cmd:reses} options often generate multiple new 
variables at once.  When this occurs, the random effects (or standard 
errors) contained in the
generated variables correspond to the order in which the variance components
are listed in the output of {cmd:xtmepoisson}.  Still, examining the variable
labels of the generated variables (using the {cmd:describe} command, for
instance) can be useful in deciphering which variables correspond to which
terms in the model.

{phang}
{opt level(levelvar)} specifies the level in the model at which
predictions for random effects and their standard errors are
to be obtained.  {it:levelvar} is the name of the model level and is either
the name of the variable describing the grouping at that level or {cmd:_all},
a special designation for a group comprising all the estimation data.

{marker mu}{...}
{phang} 
{opt mu}, the default, calculates the predicted mean, that is, the 
predicted count.  By default, this is based 
on a linear predictor that includes {it:both} the fixed effects and 
the random effects, and the predicted mean is conditional on the 
values of the estimated random effects.  Use the {opt fixedonly} option
(see {help xtmepoisson postestimation##fixedonly:below}) if you
want predictions that include only the fixed portion of the model, that is, if
you want random effects set to zero.

{phang}
{opt xb} calculates the linear prediction for the fixed portion of the
model. 

{phang}
{opt stdp} calculates the standard error of the fixed-portion linear prediction.

{phang}
{opt pearson} calculates Pearson residuals.  Pearson residuals large in
absolute value may indicate a lack of fit.  By default, residuals include both
the fixed portion and the random portion of the model.  The {opt fixedonly}
option modifies the calculation to include the fixed portion only.

{phang}
{opt deviance} calculates deviance residuals.  Deviance residuals are
recommended by
{help xtmepoisson postestimation##MN1989:McCullagh and Nelder (1989)}
as having the best properties for
examining the goodness of fit of a GLM.  They are approximately normally
distributed if the model is correctly specified.  They may be plotted against
the fitted values or against a covariate to inspect the model's fit.  By
default, residuals include both the fixed portion and the random portion of the
model.  The {opt fixedonly} option modifies the calculation to include the
fixed portion only.

{phang}
{opt anscombe} calculates Anscombe residuals, residuals that are designed to
closely follow a normal distribution.  By default, residuals include both the
fixed portion and the random portion of the model.  The {opt fixedonly} option
modifies the calculation to include the fixed portion only.

{marker fixedonly}{...}
{phang}
{opt fixedonly} modifies predictions to include only the fixed portion 
of the model, equivalent to setting all random effects equal to 
zero;  see the {helpb xtmepoisson postestimation##mu:mu} option.

{phang}
{opt nooffset} is relevant only if you specified 
{cmd:offset(}{help varname:{it:varname_o}}{cmd:)} or 
{cmd:exposure(}{it:varname_e}{cmd:)} 
for {cmd:xtmepoisson}.  It modifies the calculations made by {cmd:predict} so 
that they ignore the offset/exposure variable; the linear prediction is treated
as xb (+ Zu) rather than xb (+ Zu) + offset (or + ln(exposure)).


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


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse epilepsy}{p_end}
{phang2}{cmd:. xtmepoisson seizures treat lbas lbas_trt lage visit || subject: visit, cov(unstructured) intpoints(9)}{p_end}

{pstd}Random-effects covariance matrix for level {cmd:subject}{p_end}
{phang2}{cmd:. estat recovariance}{p_end}

{pstd}Random-effects correlation matrix for level {cmd:subject}{p_end}
{phang2}{cmd:. estat recovariance, correlation}{p_end}

{pstd}Predictions of random effects{p_end}
{phang2}{cmd:. predict re_visit re_cons, reffects}{p_end}

{pstd}Predicted counts, incorporating random effects{p_end}
{phang2}{cmd:. predict n}{p_end}

{pstd}Predicted counts, setting all random effects to zero{p_end}
{phang2}{cmd:. predict n_fixed, fixedonly}{p_end}
    {hline}


{marker saved_results}{...}
{title:Saved results}

{pstd}
{cmd:estat recovariance} saves the last-displayed random-effects covariance
matrix in {cmd:r(cov)} or in {cmd:r(corr)} if it is displayed as a correlation
matrix.


{marker reference}{...}
{title:Reference}

{marker MN1989}{...}
{phang}
McCullagh, P., and J. A. Nelder. 1989.
{browse "http://www.stata.com/bookstore/glm.html":{it:Generalized Linear Models}. 2nd ed.}
London: Chapman & Hall/CRC.
{p_end}
