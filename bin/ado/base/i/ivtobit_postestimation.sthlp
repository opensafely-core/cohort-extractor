{smcl}
{* *! version 1.2.11  05sep2018}{...}
{viewerdialog predict "dialog ivtobit_p"}{...}
{viewerdialog estat "dialog ivtobit_estat"}{...}
{vieweralsosee "[R] ivtobit postestimation" "mansection R ivtobitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ivtobit" "help ivtobit"}{...}
{viewerjumpto "Postestimation commands" "ivtobit postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "ivtobit_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "ivtobit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "ivtobit postestimation##syntax_margins"}{...}
{viewerjumpto "estat" "ivtobit postestimation##estat"}{...}
{viewerjumpto "Examples" "ivtobit postestimation##examples"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[R] ivtobit postestimation} {hline 2}}Postestimation tools for ivtobit{p_end}
{p2col:}({mansection R ivtobitpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after
{cmd:ivtobit}:

{synoptset 22}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb ivtobit_postestimation##estat:estat correlation}}report the
correlation matrix of the errors of the dependent variable and the endogenous variables{p_end}
{synopt :{helpb ivtobit_postestimation##estat:estat covariance}}report the
covariance matrix of the errors of the dependent variable and the endogenous variables{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
These commands are not appropriate after the two-step estimator or the {cmd:svy}
prefix.{p_end}

{pstd}
The following standard postestimation commands are also available:

{synoptset 22 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
{p2coldent:* {bf:{help estat ic}}}Akaike's and Schwarz's Bayesian information criteria (AIC and BIC){p_end}
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_svy_estat
INCLUDE help post_estimates
{p2col 4 29 31 2:*+ {bf:{help forecast}}}dynamic forecasts and simulations{p_end}
INCLUDE help post_hausman_star2
INCLUDE help post_lincom
{p2coldent :+ {helpb lrtest}}likelihood-ratio test; not available with two-step estimator{p_end}
{synopt:{helpb ivtobit_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb ivtobit postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
{p2coldent:* {helpb suest}}seemingly unrelated estimation{p_end}
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:estat ic}, {cmd:forecast}, and {cmd:suest} are not appropriate after
        {cmd:ivtobit, twostep}.{p_end}
{p 4 6 2}
+ {cmd:forecast}, {cmd:hausman}, and {cmd:lrtest} are not appropriate with
{cmd:svy} estimation results.{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R ivtobitpostestimationRemarksandexamples:Remarks and examples}

        {mansection R ivtobitpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{phang}
After ML or twostep

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} {it:statistic}]

{phang}
After ML

{p 8 16 2}
{cmd:predict} {dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvarlist}}{c )-}
{ifin} {cmd:,} {opt sc:ores}

{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synopt :{opt stdf}}standard error of the forecast; not available with two-step
estimator{p_end}
{synopt :{opt pr(a,b)}}Pr({it:a} < y < {it:b}) accounting for endogeneity;
    not available with two-step estimator{p_end}
{synopt :{opt e(a,b)}}{it:E}(y {c |} {it:a} < y < {it:b}) accounting for
endogeneity; not available with two-step estimator{p_end}
{synopt :{opt ys:tar(a,b)}}{it:E}(y*), y* = max{c -(}{it:a},min(y,{it:b}){c )-} accounting for endogeneity; not available with two-step estimator{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample
{p 4 6 2}
{opt stdf} is not allowed with {cmd:svy} estimation results.
{p_end}

INCLUDE help whereab


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
linear predictions, standard errors, probabilities, and expected values.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}{opt xb}, the default, calculates the linear prediction.

{phang}{opt stdp} calculates the standard error of the linear prediction.  It
can be thought of as the standard error of the predicted expected value or
mean for the observation's covariate pattern.  The standard error of the
prediction is also referred to as the standard error of the fitted value.

{phang}{opt stdf} calculates the standard error of the forecast, which is the
standard error of the point prediction for 1 observation.  It is
commonly referred to as the standard error of the future or forecast value.
By construction, the standard errors produced by {opt stdf} are always larger
than those produced by {opt stdp}; see
{it:{mansection R regresspostestimationMethodsandformulas:Methods and formulas}} in
{bf:[R] regress postestimation}.  {opt stdf} is not available with the two-step estimator.

{phang}
{opt pr(a,b)} calculates {bind:Pr({it:a} < y < {it:b} | z)}, the
probability that y|z would be observed in the interval ({it:a},{it:b})
accounting for endogeneity.

{pmore}
{it:a} and {it:b} may be specified as numbers or variable names; {it:lb} and 
{it:ub} are variable names;{break}
{cmd:pr(20,30)} calculates {bind:Pr(20 < y < 30 | z)};{break}
{cmd:pr(}{it:lb}{cmd:,}{it:ub}{cmd:)} calculates
{bind:Pr({it:lb} < y < {it:ub} | z)}; and{break}
{cmd:pr(20,}{it:ub}{cmd:)} calculates {bind:Pr(20 < y < {it:ub} | z)}.

{pmore}
{it:a} missing {bind:({it:a} {ul:>} .)} means minus infinity;
{cmd:pr(.,30)} calculates {bind:Pr(-infinity < y < 30 | z)};{break}
{cmd:pr(}{it:lb}{cmd:,30)} calculates
{bind:Pr(-infinity < y < 30 |z)} in
observations for which {bind:{it:lb} {ul:>} .}{break} 
and calculates {bind:Pr({it:lb} < y < 30 | z)} elsewhere.

{pmore}
{it:b} missing {bind:({it:b} {ul:>} .)} means plus infinity; {cmd:pr(20,.)} 
calculates {bind:Pr(+infinity > y > 20 | z)}; {break}
{cmd:pr(20,}{it:ub}{cmd:)} calculates {bind:Pr(+infinity > y > 20 | z)} in
observations for which {bind:{it:ub} {ul:>} .}{break}
and calculates {bind:Pr(20 < y < {it:ub} | z)} elsewhere.
{p_end}

{pmore}
{opt pr(a,b)} is not available with the two-step estimator.

{phang}
{cmd:e(}{it:a}{cmd:,}{it:b}{cmd:)} calculates
{bind:{it:E}(y | {it:a} < y < {it:b})}, the expected value of
{it:y}|z conditional on y|z being in the interval ({it:a},{it:b}), meaning
that {it:y}|z is truncated.  {it:a} and {it:b} are specified as they are for
{cmd:pr()}.  
Endogeneity is accounted for when calculating {opt e(a,b)}.
{opt e(a,b)} is not available with the two-step estimator.

{phang}
{cmd:ystar(}{it:a}{cmd:,}{it:b}{cmd:)} calculates {it:E}(y*), where
{bind:y* = {it:a}} if {bind:z + d {ul:<} {it:a}}, {bind:y* = {it:b}}
if {bind:z + d {ul:>} {it:b}}, and {bind:y* = z + d + u} otherwise,
meaning that y* is censored.  {it:a} and {it:b} are specified as they
are for {cmd:pr()}.
Endogeneity is accounted for when calculating {opt ystar(a,b)}.
{opt ystar(a,b)} is not available with the two-step estimator.

{phang}
{opt scores}, not available with {opt twostep}, calculates
equation-level score variables.

{pmore}
For models with one endogenous regressor, five new variables are created.

{pmore2}
The first new variable will contain the first derivative of the log
likelihood with respect to the probit equation.

{pmore2}
The second new variable will contain the first derivative of the log
likelihood with respect to the reduced-form equation for the endogenous
regressor.

{pmore2}
The third new variable will contain the first derivative of the log
likelihood with respect to alpha.

{pmore2}
The fourth new variable will contain the first derivative of the log
likelihood with respect to ln(s).

{pmore2}
The fifth new variable will contain the first derivative of the log 
likelihood with respect to ln(v).

{pmore}
For models with p endogenous regressors, 
p + {c -(}(p + 1)(p + 2){c )-}/2 + 1 new variables are
created.

{pmore2}
The first new variable will contain the first derivative of the log
likelihood with respect to the tobit equation.

{pmore2}
The second through (p + 1)th new variables will contain the first
derivatives of the log likelihood with respect to the reduced-form
equations for the endogenous variables in the order they were specified
when {cmd:ivtobit} was called.

{pmore2}
The remaining score variables will contain the partial derivatives of the
log likelihood with respect to the (p+1)(p+2)/2 ancillary parameters.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt pr(a,b)}}Pr({it:a} < y < {it:b}) accounting for endogeneity; not available with two-step estimator{p_end}
{synopt :{opt e(a,b)}}{it:E}(y {c |} {it:a} < y < {it:b}) accounting for endogeneity; not available with two-step estimator{p_end}
{synopt :{opt ys:tar(a,b)}}{it:E}(y*), y* = max{c -(}{it:a},min(y,{it:b}){c )-} accounting for endogeneity; not available with two-step estimator{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt stdf}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for linear predictions,
probabilities, and expected values.


{marker estat}{...}
{title:Syntax for estat}

{pstd}
Correlation matrix

{p 8 19 2}
{cmd:estat} {opt cor:relation} [{cmd:,}
	{opth bor:der(matlist##bspec:bspec)} {opt left(#)}
        {opth for:mat(%fmt)}]


{pstd}
Covariance matrix

{p 8 19 2}
{cmd:estat} {opt cov:ariance} [{cmd:,}
	{opth bor:der(matlist##bspec:bspec)} {opt left(#)}
        {opth for:mat(%fmt)}]


INCLUDE help menu_estat


{marker des_estat}{...}
{title:Description for estat}

{pstd}
{cmd:estat correlation} displays the correlation matrix of the errors of the
dependent variable and the endogenous variables.

{pstd}
{cmd:estat covariance} displays the covariance matrix of the errors of the
dependent variable and the endogenous variables.

{pstd}
{cmd:estat correlation} and {cmd:estat covariance} are not allowed after the
{cmd:ivtobit} two-step estimator.


{marker options_estat}{...}
{title:Options for estat}

{dlgtab:Main}

{phang}
{opth border:(matlist##bspec:bspec)} sets border style of the matrix display.
The default is {cmd:border(all)}.

{phang}
{opt left(#)} sets the left indent of the matrix display.  The default is
{cmd:left(2)}.

{phang}
{opth format(%fmt)} specifies the format for displaying the individual
elements of the matrix.  The default is {cmd:format(%9.0g)}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse laborsup}{p_end}
{phang2}{cmd:. ivtobit fem_inc fem_educ kids (other_inc = male_educ), ll}{p_end}

{pstd}Compute average marginal effects on expected income, conditional on it
being greater than 10 (thousand dollars){p_end}
{phang2}{cmd:. margins, predict(e(10,.)) dydx(other_inc fem_educ kids)}
{p_end}

{pstd}Estimate separately for women with 8, 12, and 16 years of education
{p_end}
{phang2}{cmd:. margins, predict(e(10,.)) dydx(kids) at(fem_educ=(8(4)16))}

{pstd}Plot most recent estimates and confidence intervals{p_end}
{phang2}{cmd:. marginsplot}{p_end}
