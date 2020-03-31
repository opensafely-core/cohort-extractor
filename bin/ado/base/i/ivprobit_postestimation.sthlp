{smcl}
{* *! version 2.0.6  21may2018}{...}
{viewerdialog predict "dialog ivprobit_p"}{...}
{viewerdialog estat "dialog ivprobit_estat"}{...}
{viewerdialog lroc "dialog lroc"}{...}
{viewerdialog lsens "dialog lsens"}{...}
{vieweralsosee "[R] ivprobit postestimation" "mansection R ivprobitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ivprobit" "help ivprobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] estat classification" "help estat classification"}{...}
{vieweralsosee "[R] lroc" "help lroc"}{...}
{vieweralsosee "[R] lsens" "help lsens"}{...}
{viewerjumpto "Postestimation commands" "ivprobit postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "ivprobit_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "ivprobit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "ivprobit postestimation##syntax_margins"}{...}
{viewerjumpto "estat" "ivprobit postestimation##estat"}{...}
{viewerjumpto "Examples" "ivprobit postestimation##examples"}{...}
{p2colset 1 32 34 2}{...}
{p2col:{bf:[R] ivprobit postestimation} {hline 2}}Postestimation tools for ivprobit{p_end}
{p2col:}({mansection R ivprobitpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after
{cmd:ivprobit}:

{synoptset 22}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb estat classification}}report various summary statistics, including the classification table{p_end}
{synopt :{helpb ivprobit_postestimation##estat:estat correlation}}report the
correlation matrix of the errors of the dependent variable and the endogenous variables{p_end}
{synopt :{helpb ivprobit_postestimation##estat:estat covariance}}report the
covariance matrix of the errors of the dependent variable and the endogenous variables{p_end}
{synopt :{helpb lroc}}compute area under ROC curve and graph the curve{p_end}
{synopt :{helpb lsens}}graph sensitivity and specificity versus probability cutoff{p_end}
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
{p2coldent :* {bf:{help estat ic}}}Akaike's and Schwarz's Bayesian information criteria (AIC and BIC){p_end}
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_svy_estat
INCLUDE help post_estimates
{p2col 4 29 31 2:*+ {bf:{help forecast}}}dynamic forecasts and simulations{p_end}
INCLUDE help post_hausman_star2
INCLUDE help post_lincom
{p2coldent :+ {helpb lrtest}}likelihood-ratio test; not available with two-step estimator{p_end}
{synopt:{helpb ivprobit_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb ivprobit postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
{p2coldent :* {helpb suest}}seemingly unrelated estimation{p_end}
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:estat ic}, {cmd:forecast}, and {cmd:suest} are not appropriate after
     {cmd:ivprobit, twostep}.{p_end}
{p 4 6 2}
+ {cmd:forecast}, {cmd:hausman}, and {cmd:lrtest} are not appropriate with
      {cmd:svy} estimation results.{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R ivprobitpostestimationRemarksandexamples:Remarks and examples}

        {mansection R ivprobitpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{phang}
After ML or twostep

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} {it:statistic} 
     {opt rule:s} {opt asif}]


{phang}
After ML

{p 8 16 2}
{cmd:predict} {dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvarlist}}{c )-}
{ifin} {cmd:,} {opt sc:ores}


{synoptset 20 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synopt :{opt pr}}probability of a positive outcome accounting for
endogeneity; not available with two-step estimator{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
linear predictions, standard errors, and probabilities.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}{opt xb}, the default, calculates the linear prediction.

{phang}{opt stdp} calculates the standard error of the linear prediction. 

{phang}{opt pr} calculates the probability of a positive outcome accounting
for endogeneity. {opt pr} is not available with the two-step estimator.

{phang}{opt rules} requests that Stata use any rules that were used to
identify the model when making the prediction.  By default, Stata calculates
missing for excluded observations. {opt rules} is not available with the
two-step estimator.

{phang}{opt asif} requests that Stata ignore the rules and the exclusion
criteria and calculate predictions for all observations possible using the
estimated parameters from the model.  {opt asif} is not available with the
two-step estimator.

{phang}{opt scores}, not available with {opt twostep}, calculates
equation-level score variables.

{pmore}
For models with one endogenous regressor, four new variables are 
created.

{pmore2}
The first new variable will contain the first derivative of the log 
likelihood with respect to the probit equation.

{pmore2}
The second new variable will contain the first derivative of the log 
likelihood with respect to the reduced-form equation for the endogenous 
regressor.

{pmore2}
The third new variable will contain the first derivative of the log 
likelihood with respect to atanh(rho).

{pmore2}
The fourth new variable will contain the first derivative of the log 
likelihood with respect to ln(sigma).

{pmore}
For models with p endogenous regressors, 
p + {c -(}(p + 1)(p + 2){c )-}/2
new variables are created.

{pmore2}
The first new variable will contain the first derivative of the log 
likelihood with respect to the probit equation.

{pmore2}
The second through (p + 1)th new variables will contain the first 
derivatives of the log likelihood with respect to the reduced-form 
equations for the endogenous variables in the order they were specified 
when {cmd:ivprobit} was called.

{pmore2}
The remaining score variables will contain the partial derivatives of the
log likelihood with respect to s[2,1], s[3,1], ..., s[p+1,1], s[2,2], 
..., s[p+1,2], ..., s[p+1,p+1], where s[m,n] denotes the (m,n) element 
of the Cholesky decomposition of the error covariance matrix.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt pr}}probability of a positive outcome accounting for
endogeneity; not available with two-step estimator{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for linear predictions and
probabilities.


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
{cmd:ivprobit} two-step estimator.


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
{phang2}{cmd:. ivprobit fem_work fem_educ kids (other_inc = male_educ)}{p_end}

{pstd}Compute average marginal effect of {cmd:fem_educ} on probability
that a woman works{p_end}
{phang2}{cmd:. margins, dydx(fem_educ) predict(pr)}{p_end}

{pstd}Same as above, but specify no children{p_end}
{phang2}{cmd:. margins, dydx(fem_educ) predict(pr) at(kids=0)}{p_end}
