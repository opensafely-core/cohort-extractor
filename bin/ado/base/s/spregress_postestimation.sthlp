{smcl}
{* *! version 1.1.3  15oct2018}{...}
{viewerdialog predict "dialog spregress_p"}{...}
{viewerdialog estat "dialog spregress_estat"}{...}
{vieweralsosee "[SP] spregress postestimation" "mansection SP spregresspostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] spregress" "help spregress"}{...}
{viewerjumpto "Postestimation commands" "spregress postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "spregress_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "spregress postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "spregress postestimation##syntax_margins"}{...}
{viewerjumpto "estat" "spregress postestimation##syntax_estat"}{...}
{viewerjumpto "Examples" "spregress postestimation##examples"}{...}
{viewerjumpto "Stored results" "spregress postestimation##results"}{...}
{p2colset 1 34 36 2}{...}
{p2col:{bf:[SP] spregress postestimation} {hline 2}}Postestimation tools
for spregress{p_end}
{p2col:}({mansection SP spregresspostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation command is of special interest after 
{cmd:spregress}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb spregress postestimation##estat_impact:estat impact}}direct,
indirect, and total impacts{p_end}
{synoptline}

{pstd}
The following postestimation commands are also available:

{synoptset 17 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
{p2coldent :* {helpb estat ic}}Akaike's and Schwarz's Bayesian information criteria (AIC and BIC){p_end}
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_lincom
{p2coldent :* {helpb lrtest}}likelihood-ratio test{p_end}
{synopt:{helpb spregress postestimation##margins:margins}}marginal
        means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb spregress postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p 4 6 2}
* {opt estat ic} and {opt lrtest} are not appropriate with {opt gs2sls}
estimation results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SP spregresspostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} {it:statistic}]

{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt rf:orm}}reduced-form mean; the default{p_end}
{synopt :{opt direct}}direct mean{p_end}
{synopt :{opt indirect}}indirect mean{p_end}
{synopt :{opt li:mited}}limited-information mean{p_end}
{synopt :{opt full}}full-information mean{p_end}
{synopt :{opt na:ive}}naive-form prediction{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt r:esiduals}}residuals{p_end}
{synopt :{opt ucr:esiduals}}uncorrelated residuals{p_end}
{synoptline}
{p 4 6 2}
These statistics are only available in a subset of the estimation sample.
{p_end}


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
the reduced-form mean, the direct mean, the indirect mean, the
limited-information mean, the full-information mean, 
the naive-form prediction, the linear prediction,
the residuals, or the uncorrelated residuals.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt rform}, the default, calculates the reduced-form mean.  It is the
predicted mean of the dependent variable conditional on the independent
variables and any spatial lags of the independent variables.  See
{mansection SP spregresspostestimationMethodsandformulas:{it:Methods and formulas}}.

{phang}
{opt direct} calculates the direct mean.
It is a unit's predicted contribution to its own reduced-form mean.  
The direct and indirect means sum to the reduced-form mean.

{phang}
{opt indirect} calculates the indirect mean.
It is the predicted sum of the other units' contributions to a unit's 
reduced-form mean.  

{phang}
{opt limited} calculates the limited-information mean. 
It is the predicted mean of the dependent
variable conditional on the independent variables, any spatial lags of
the independent variables, and any spatial lags of the dependent variable.
{opt limited} is not available when the {opt heteroskedastic} option
is used with {cmd:spregress, gs2sls}.

{phang}
{opt full} calculates the full-information mean.  It is the predicted mean of
the dependent variable conditional on the independent variables, any spatial
lags of the independent variables, and the other units' values of the
dependent variable.  {opt full} is not available when the
{opt heteroskedastic} option is used with {cmd:spregress, gs2sls}.

{phang}
{opt naive} calculates the naive-form prediction.
It is the predicted linear combination of the
independent variables, any spatial lags of the independent variables, and 
any spatial lags of the dependent variable.
It is not a consistent estimator of an expectation. See
{mansection SP spregresspostestimationMethodsandformulas:{it:Methods and formulas}}.

{phang}
{opt xb} calculates the predicted linear combination of the independent
variables.

{phang}
{opt residuals} calculates the residuals,
including any autoregressive error term.

{phang}
{opt ucresiduals} calculates the uncorrelated residuals, 
which are estimates of the uncorrelated error term.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt rf:orm}}reduced-form mean; the default{p_end}
{synopt :{opt direct}}direct mean{p_end}
{synopt :{opt indirect}}indirect mean{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt li:mited}}not allowed with {cmd:margins}{p_end}
{synopt :{opt full}}not allowed with {cmd:margins}{p_end}
{synopt :{opt na:ive}}not allowed with {cmd:margins}{p_end}
{synopt :{opt r:esiduals}}not allowed with {cmd:margins}{p_end}
{synopt :{opt ucr:esiduals}}not allowed with {cmd:margins}{p_end}
{synoptline}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for reduced-form mean, direct mean,
indirect mean, and linear predictions.


{marker syntax_estat}{...}
{marker estat_impact}{...}
{title:Syntax for estat impact}

{p 8 16 2}
{cmd:estat} {cmd:impact}
[{varlist}]
{ifin}
[{cmd:,} {cmd:nolog} {opth vce(vcetype)}]

{phang}
{varlist} is a list of independent variables, including
{help fvvarlist:factor variables}, taken from the fitted model.  By default,
all independent variables from the fitted model are used.


{marker des_estat}{...}
{title:Description for estat impact}

{pstd}
{cmd:estat impact} estimates the mean of the direct, indirect, and total
impacts of independent variables on the reduced-form mean of the dependent
variable.


{marker options_estat_impact}{...}
{title:Options for estat impact}

{dlgtab:Main}

{phang}
{cmd:nolog} suppresses the calculation progress log that shows the percentage
completed.  By default, the log is displayed.

{dlgtab:VCE}

{phang}
{opt vce(vcetype)} 
specifies how the standard errors of the impacts are calculated.

{phang2}
{cmd:vce(delta)}, the default, is the delta method and treats the 
independent variables as fixed.

{phang2}
{cmd:vce(unconditional)} specifies that standard errors
account for sampling variance in the independent variables.
This option is not available when {cmd:if} or {cmd:in} is specified
with {cmd:estat impact}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. copy https://www.stata-press.com/data/r16/homicide1990.dta .}
{p_end}
{phang2}{cmd:. copy https://www.stata-press.com/data/r16/homicide1990_shp.dta .}
{p_end}
{phang2}{cmd:. use homicide1990}
{p_end}
{phang2}{cmd:. spset}
{p_end}

{pstd}Create a contiguity weighting matrix with the default spectral normalization{p_end}
{phang2}{cmd:. spmatrix create contiguity W}

{pstd}Fit a generalized spatial two-stage least-squares regression{p_end}
{phang2}{cmd:. spregress hrate ln_population ln_pdensity gini,}
                     {cmd:gs2sls dvarlag(W)}

{pstd}Obtain direct, indirect, and total effects of the covariates{p_end}
{phang2}{cmd:. estat impact}

{pstd}Same as above estimation but add a spatial autoregressive error term{p_end}
{phang2}{cmd:. spregress hrate ln_population ln_pdensity gini,}
                     {cmd:gs2sls dvarlag(W) errorlag(W)}

{pstd}Obtain direct, indirect, and total effects of the covariates{p_end}
{phang2}{cmd:. estat impact}

{pstd}Calculate a change in the Gini coefficient{p_end}
{phang2}{cmd:. margins, at(gini = generate(gini - 0.02)) at(gini = generate(gini))}
                      {cmd:at(gini = generate(gini + 0.02))}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat impact} stores the following in {cmd:r()}:

{synoptset 24 tabbed}{...}
{p2col 5 24 28 2: Scalars}{p_end}
{synopt :{cmd:r(N)}}number of observations{p_end}

{p2col 5 24 28 2: Macros}{p_end}
{synopt :{cmd:r(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt :{cmd:r(xvars)}}names of independent variables{p_end}

{p2col 5 24 28 2: Matrices}{p_end}
{synopt :{cmd:r(b_direct)}}vector of estimated direct impacts{p_end}
{synopt :{cmd:r(Jacobian_direct)}}Jacobian matrix for direct impacts{p_end}
{synopt :{cmd:r(V_direct)}}estimated variance-covariance matrix of direct impacts{p_end}
{synopt :{cmd:r(b_indirect)}}vector of estimated indirect impacts{p_end}
{synopt :{cmd:r(Jacobian_indirect)}}Jacobian matrix for indirect impacts{p_end}
{synopt :{cmd:r(V_indirect)}}estimated variance-covariance matrix of indirect impacts{p_end}
{synopt :{cmd:r(b_total)}}vector of estimated total impacts{p_end}
{synopt :{cmd:r(Jacobian_total)}}Jacobian matrix for total impacts{p_end}
{synopt :{cmd:r(V_total)}}estimated variance-covariance matrix of total impacts{p_end}
{p2colreset}{...}
