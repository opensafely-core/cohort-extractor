{smcl}
{* *! version 1.4.7  15oct2018}{...}
{viewerdialog predict "dialog meglm_p"}{...}
{viewerdialog estat "dialog meglm_estat"}{...}
{vieweralsosee "[ME] meglm postestimation" "mansection ME meglmpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] meglm" "help meglm"}{...}
{viewerjumpto "Postestimation commands" "meglm postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "meglm_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "meglm postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "meglm postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "meglm postestimation##examples"}{...}
{viewerjumpto "Reference" "meglm postestimation##reference"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[ME] meglm postestimation} {hline 2}}Postestimation tools for meglm{p_end}
{p2col:}({mansection ME meglmpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation command is of special interest after
{cmd:meglm}:

{synoptset 18}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb estat group}}summarize the composition of the nested groups{p_end}
{synopt :{helpb estat icc}}estimate intraclass correlations{p_end}
{synopt :{helpb me estat sd:estat sd}}display variance components as standard deviations and correlations{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 18 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_svy_estat
INCLUDE help post_estimates
INCLUDE help post_hausman_star
INCLUDE help post_lincom
INCLUDE help post_lrtest_star
{synopt:{helpb meglm_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb meglm postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:hausman} and {cmd:lrtest} are not appropriate with {cmd:svy}
estimation results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ME meglmpostestimationRemarksandexamples:Remarks and examples}

        {mansection ME meglmpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


INCLUDE help syntax_me_predict

{marker statistic}{...}
{synoptset 27 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt mu}}mean response; the default{p_end}
{synopt :{opt pr}}synonym for {opt mu} for ordinal and binary response models{p_end}
{synopt :{opt eta}}fitted linear predictor{p_end}
{synopt :{opt xb}}linear predictor for the fixed portion of the model only{p_end}
{synopt :{opt stdp}}standard error of the fixed-portion linear prediction{p_end}
{synopt :{opt den:sity}}predicted density function{p_end}
{synopt :{opt dist:ribution}}predicted distribution function{p_end}
{synopt :{opt res:iduals}}raw residuals; available only with the Gaussian family{p_end}
{synopt :{opt pea:rson}}Pearson residuals{p_end}
{synopt :{opt dev:iance}}deviance residuals{p_end}
{synopt :{opt ans:combe}}Anscombe residuals{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample

{marker options_table}{...}
{synoptset 27 tabbed}{...}
{synopthdr :options}
{synoptline}
{syntab :Main}
{synopt :{opt cond:itional}{cmd:(}{it:{help meglm_postestimation##ctype:ctype}}{cmd:)}}compute {it:statistic} conditional on estimated random effects; default is {cmd:conditional(ebmeans)}{p_end}
{synopt :{opt marginal}}compute {it:statistic} marginally with respect to the random effects{p_end}
{synopt :{opt nooff:set}}make calculation ignoring offset or exposure{p_end}
{synopt :{opt out:come(outcome)}}outcome category for predicted probabilities for ordinal models{p_end}

{syntab :Integration}
{synopt :{it:{help meglm_postestimation##int_options:int_options}}}integration
	options{p_end}
{synoptline}
{p 4 6 2}
{cmd:pearson},
{cmd:deviance},
{cmd:anscombe}
may not be combined with {cmd:marginal}.
{p_end}
{p 4 6 2}
For ordinal outcomes, you can specify one or {it:k} new variables in {it:{help newvarlist}}
with {cmd:mu} and {cmd:pr}, where {it:k} is the number of outcomes.
If you do not specify {cmd:outcome()}, these options assume
{cmd:outcome(#1)}.
{p_end}

INCLUDE help syntax_me_predict_ctype

INCLUDE help syntax_me_predict_reopts

INCLUDE help syntax_me_predict_intopts


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
mean responses; linear predictions; density and distribution functions;
standard errors; and raw, Pearson, deviance, and Anscombe residuals.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{cmd:mu}, the default, calculates the expected value of the outcome.

{phang}
{cmd:pr} calculates predicted probabilities and is a synonym for {cmd:mu}.
This option is available only for ordinal and binary response models.

{phang}
{cmd:eta} calculates the fitted linear prediction.

{phang}
{cmd:xb} calculates the linear prediction xb using the estimated
fixed effects (coefficients) in the model.  This is equivalent to fixing
all random effects in the model to their theoretical (prior) mean value
of 0.

{phang}
{cmd:stdp} calculates the standard error of the fixed-effects linear
predictor xb.

{phang} 
{cmd:density} calculates the density function.
This prediction is computed using the current values of the observed
variables, including the dependent variable.

{phang} 
{cmd:distribution} calculates the distribution function.
This prediction is computed using the current values of the observed
variables, including the dependent variable.

{phang}
{cmd:residuals} calculates raw residuals, that is, responses minus the fitted
values.  This option is available only for the Gaussian family.

{phang}
{cmd:pearson} calculates Pearson residuals.
Pearson residuals that are large in absolute value may indicate a lack
of fit.

{phang}
{cmd:deviance} calculates deviance residuals.  Deviance residuals are
recommended by {help meglm_postestimation##MN1989:McCullagh and Nelder (1989)}
as having the best properties for examining the goodness of fit of a GLM.
They are approximately normally distributed if the model is correctly
specified.  They can be plotted against the fitted values or against a
covariate to inspect the model fit.

{phang}
{cmd:anscombe} calculates Anscombe residuals, which are designed to closely
follow a normal distribution.

{phang}
{opt conditional(ctype)} and {cmd:marginal} specify how random effects are
handled in computing {it:statistic}.

{phang2}
{cmd:conditional()} specifies that {it:statistic} will be computed conditional
on specified or estimated random effects.

{phang3}
{cmd:conditional(ebmeans)}, the default, specifies that empirical Bayes
means be used as the estimates of the random effects.
These estimates are also known as posterior mean estimates of the random
effects.

{phang3}
{cmd:conditional(ebmodes)} specifies that empirical Bayes modes be used as the
estimates of the random effects.
These estimates are also known as posterior mode estimates of the random
effects.

{phang3}
{cmd:conditional(fixedonly)} specifies that all random effects be set
to zero, equivalent to using only the fixed portion of the model.

{phang2}
{cmd:marginal} specifies that the predicted {it:statistic} be computed
marginally with respect to the random effects, which means that
{it:statistic} is calculated by integrating the prediction function with
respect to all the random effects over their entire support.

{pmore2}
Although this is not the default, marginal predictions are often very useful
in applied analysis.
They produce what are commonly called population-averaged estimates.
They are also required by {helpb margins}.

{phang}
{cmd:nooffset} is relevant only if you specified
{opth offset:(varname:varname_o)}  or {opt exposure(varname_e)} with
{cmd:meglm}.  It modifies the calculations made by {cmd:predict} so that they
ignore the offset or the exposure variable; the linear prediction is treated as
xb rather than xb + offset or xb + exposure, whichever is relevant.

{phang}
{opt outcome(outcome)} specifies the outcome for which the predicted
probabilities are to be calculated.  {cmd:outcome()} should contain either one
value of the dependent variable or one of {bf:#1}, {bf:#2}, ..., with {bf:#1}
meaning the first category of the dependent variable, {bf:#2} meaning the
second category, etc.

{phang}
{cmd:reffects} calculates estimates of the random effects using empirical
Bayes predictions.
By default, or if the {opt ebmeans} option is specified, empirical Bayes means
are computed.
With the {opt ebmodes} option, empirical Bayes modes are computed.
You must specify {it:q} new variables, where {it:q} is the number of
random-effects terms in the model.  However, it is much easier to just
specify {it:stub}{cmd:*} and let Stata name the variables
{it:stub}{cmd:1}, {it:stub}{cmd:2},...,{it:stub}{it:q} for you.

{phang}
{cmd:ebmeans} specifies that empirical Bayes means be used as the
estimates of the random effects.

{phang}
{cmd:ebmodes} specifies that empirical Bayes modes be used as the
estimates of the random effects.

{phang}
{cmd:reses(}{it:{help newvarlist##stub*:stub}}{cmd:*} | {it:{help varlist:newvarlist}}{cmd:)} calculates
standard errors of the empirical Bayes estimators and stores the result in
{it:newvarlist}.  This option requires the {cmd:reffects} option.
You must specify {it:q} new variables, where {it:q} is the number of
random-effects terms in the model.  However, it is much easier to just specify
{it:stub}{cmd:*} and let Stata name the variables {it:stub}{cmd:1},
{it:stub}{cmd:2},...,{it:stub}{it:q} for you.  The new
variables will have the same storage type as the corresponding random-effects
variables.

{pmore}
The {cmd:reffects} and {cmd:reses()} options often generate
multiple new variables at once.  When this occurs, the random effects (and
standard errors) contained in the generated variables correspond to the order
in which the variance components are listed in the output of {cmd:meglm}.
The generated variables are also labeled to identify their associated random
effect.

{phang}
{opt scores} calculates the scores for each coefficient in {cmd:e(b)}.
This option requires a new variable list of length equal to 
the number of columns in {cmd:e(b)}.  Otherwise, use the {it:stub}{cmd:*}
syntax to have {cmd:predict} generate enumerated variables with
prefix {it:stub}.

{dlgtab:Integration}

{phang}
{opt intpoints(#)} specifies the number of quadrature points used to
compute marginal predictions and the empirical Bayes means;
the default is the value from estimation.

{phang}
{opt iterate(#)} specifies the maximum number of iterations when computing
statistics involving empirical Bayes estimators; the default is the value from
estimation.

{phang}
{opt tolerance(#)} specifies convergence tolerance when computing
statistics involving empirical Bayes estimators; the default is the value
from estimation.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{cmd:mu}}mean response; the default{p_end}
{synopt :{cmd:pr}}synonym for {cmd:mu} for ordinal and binary response models{p_end}
{synopt :{opt eta}}fitted linear predictor{p_end}
{synopt :{cmd:xb}}linear predictor for the fixed portion of the model only{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt den:sity}}not allowed with {cmd:margins}{p_end}
{synopt :{opt dist:ribution}}not allowed with {cmd:margins}{p_end}
{synopt :{opt res:iduals}}not allowed with {cmd:margins}{p_end}
{synopt :{opt pea:rson}}not allowed with {cmd:margins}{p_end}
{synopt :{opt dev:iance}}not allowed with {cmd:margins}{p_end}
{synopt :{opt ans:combe}}not allowed with {cmd:margins}{p_end}
{synopt :{opt reffects}}not allowed with {cmd:margins}{p_end}
{synopt :{opt scores}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
Options {cmd:conditional(ebmeans)} and {cmd:conditional(ebmodes)} are not
allowed with {cmd:margins}.
{p_end}
{p 4 6 2}
Option {opt marginal} is assumed where applicable if
{cmd:conditional(fixedonly)} is not specified.
{p_end}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for
mean responses and linear predictions.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse towerlondon}{p_end}
{phang2}{cmd:. meglm dtlm difficulty i.group || family: || subject:, family(bernoulli)}{p_end}

{pstd}Obtain predicted probabilities based on the contribution of both fixed effects and random effects{p_end}
{phang2}{cmd:. predict pr}{p_end}

{pstd}Obtain predicted probabilities based on the contribution of fixed effects only{p_end}
{phang2}{cmd:. predict prfixed, conditional(fixedonly)}{p_end}

{pstd}Obtain predictions of the posterior means and their standard errors{p_end}
{phang2}{cmd:. predict re_means*, reses(se_means*) reffects}{p_end}

{pstd}Obtain predictions of the posterior modes and their standard errors{p_end}
{phang2}{cmd:. predict re_modes*, reses(se_modes*) reffects ebmodes}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. use https://www.stata-press.com/data/mlmus3/schiz, clear}{p_end}
{phang2}{cmd:. generate impso = imps}{p_end}
{phang2}{cmd:. recode impso -9=. 1/2.4=1 2.5/4.4=2 4.5/5.4=3 5.5/7=4}{p_end}
{phang2}{cmd:. meglm impso week treatment || id:, family(ordinal)}{p_end}

{pstd}Obtain predicted probabilities for each outcome based on the contribution of both fixed effects and random effects{p_end}
{phang2}{cmd:. predict pr*}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. use https://www.stata-press.com/data/mlmus3/drvisits, clear}
{p_end}
{phang2}{cmd:. meglm numvisit reform age married loginc || id: reform, family(poisson)}{p_end}

{pstd}Obtain the predicted counts based on the contribution of both fixed effects and random effects{p_end}
{phang2}{cmd:. predict n}{p_end}

    {hline}
    

{marker reference}{...}
{title:Reference}

{marker MN1989}{...}
{phang}
McCullagh, P., and J. A. Nelder. 1989.
{browse "https://www.stata.com/bookstore/glm.html":{it:Generalized Linear Models}. 2nd ed.}
London: Chapman & Hall/CRC.
{p_end}
