{smcl}
{* *! version 1.5.3  16jun2014}{...}
{viewerdialog predict "dialog xtmelogit_p"}{...}
{viewerdialog estat "dialog xtmelogit_estat"}{...}
{vieweralsosee "[XT] xtmelogit" "help xtmelogit"}{...}
{viewerjumpto "Description" "xtmelogit postestimation##description"}{...}
{viewerjumpto "Special-interest postestimation commands" "xtmelogit postestimation##special"}{...}
{viewerjumpto "" "--"}{...}
{viewerjumpto "Syntax for predict" "xtmelogit postestimation##syntax_predict"}{...}
{viewerjumpto "Options for predict" "xtmelogit postestimation##options_predict"}{...}
{viewerjumpto "" "--"}{...}
{viewerjumpto "Syntax for estat group" "xtmelogit postestimation##syntax_estat_group"}{...}
{viewerjumpto "Syntax for estat recovariance" "xtmelogit postestimation##syntax_estat_recov"}{...}
{viewerjumpto "Options for estat recovariance" "xtmelogit postestimation##options_estat_recov"}{...}
{viewerjumpto "Syntax for estat icc" "xtmelogit postestimation##syntax_estat_icc"}{...}
{viewerjumpto "Option for estat icc" "xtmelogit postestimation##option_estat_icc"}{...}
{viewerjumpto "" "--"}{...}
{viewerjumpto "Examples" "xtmelogit postestimation##examples"}{...}
{viewerjumpto "Saved results" "xtmelogit postestimation##saved_results"}{...}
{viewerjumpto "Reference" "xtmelogit postestimation##reference"}{...}
{pstd}
{cmd:xtmelogit} has been renamed to {helpb meqrlogit}; see
{manhelp meqrlogit_postestimation ME:meqrlogit postestimation}.  {cmd:xtmelogit}
continues to work but, as of Stata 13, is no longer an official part of Stata.
This is the original help file, which we will no longer update, so some links
may no longer work.

{hline}

{title:Title}

{p2colset 5 38 40 2}{...}
{p2col :{hi:[XT] xtmelogit postestimation} {hline 2}}Postestimation tools for
xtmelogit{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The following postestimation commands are of special interest after
{cmd:xtmelogit}:

{synoptset 18}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb xtmelogit postestimation##estatgroup:estat group}}summarize
the composition of the nested groups{p_end}
{synopt :{helpb xtmelogit postestimation##estatcov:estat recovariance}}display
  the estimated random-effects covariance matrix{p_end}
{synopt :{helpb xtmelogit postestimation##estaticc:estat icc}}estimate
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
{synopt :{helpb xtmelogit postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
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
{cmd:estat icc} displays the intraclass correlation for pairs of latent linear
responses at each nested level of the model.  Intraclass correlations are
available for random-intercept models or for random-coefficient models
conditional on random-effects covariates being equal to zero.  They are not
available for crossed-effects models.


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
are calculated.  However, if the {opt level(levelvar)} option is specified,
then estimates for only level {it:levelvar} in the model are calculated.  For
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
are calculated.  However, if the {opt level(levelvar)} option is specified,
then standard errors for only level {it:levelvar} in the model are calculated.
For example, if {cmd:class}es are nested within {cmd:school}s, then

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
are listed in the output of {cmd:xtmelogit}.  Still, examining the variable
labels of the generated variables (using the {cmd:describe} command, for
instance) can be useful in deciphering which variables correspond to which
terms in the model.

{phang}
{opt level(levelvar)} specifies the level in the model at which
predictions for random effects and their standard errors are
to be obtained.  {it:levelvar} is the name of the model level and is either
the name of the variable describing the grouping at that level or {cmd:_all},
a special designation for a group comprising all the estimation data.

{phang} 
{opt mu}, the default, calculates the predicted mean.
By default, this is based on a linear predictor that
includes {it:both} the fixed effects and the random effects, and the predicted
mean is conditional on the values of the estimated random effects.  Use the 
{opt fixedonly} option if you want predictions that include only the fixed
portion of the model, that is, if you want random effects set to zero.

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
{help xtmelogit postestimation##MN1989:McCullagh and Nelder (1989)}
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

{phang}
{opt fixedonly} modifies predictions to include only the fixed portion 
of the model, equivalent to setting all random effects equal to 
zero;  see above.

{phang}
{opt nooffset} is relevant only if you specified {opth offset(varname)} 
for {cmd:xtmelogit}.  It modifies the calculations made by {cmd:predict} so 
that they ignore the offset variable; the linear prediction is treated
as xb (+ Zu) rather than xb (+ Zu) + offset.


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
{phang2}{cmd:. webuse bangladesh}{p_end}
{phang2}{cmd:. xtmelogit c_use urban age child* || district: urban, covariance(unstructured)}{p_end}

{pstd}Random-effects covariance matrix for level {cmd:district}{p_end}
{phang2}{cmd:. estat recovariance}{p_end}

{pstd}Random-effects correlation matrix for level {cmd:district}{p_end}
{phang2}{cmd:. estat recovariance, correlation}{p_end}

{pstd}Predictions of random effects{p_end}
{phang2}{cmd:. predict re_urban re_cons, reffects}{p_end}

{pstd}Compute conditional intraclass correlation{p_end}
{phang2}{cmd:. estat icc}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse towerlondon, clear}{p_end}
{phang2}{cmd:. xtmelogit dtlm difficulty i.group || family: || subject:}
{p_end}

{pstd}Summarize composition of nested groups{p_end}
{phang2}{cmd:. estat group}{p_end}

{pstd}Predicted probabilities, incorporating random effects{p_end}
{phang2}{cmd:. predict p}{p_end}

{pstd}Predicted probabilities, ignoring subject and family effects{p_end}
{phang2}{cmd:. predict p_fixed, fixedonly}{p_end}

{pstd}Compute residual intraclass correlations{p_end}
{phang2}{cmd:. estat icc}{p_end}

    {hline}


{marker saved_results}{...}
{title:Saved results}

{pstd}
{cmd:estat recovariance} saves the last-displayed random-effects covariance
matrix in {cmd:r(cov)} or in {cmd:r(corr)} if it is displayed as a correlation
matrix.

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


{marker reference}{...}
{title:Reference}

{marker MN1989}{...}
{phang}
McCullagh, P., and J. A. Nelder. 1989.
{browse "http://www.stata.com/bookstore/glm.html":{it:Generalized Linear Models}. 2nd ed.}
London: Chapman & Hall/CRC.
{p_end}
