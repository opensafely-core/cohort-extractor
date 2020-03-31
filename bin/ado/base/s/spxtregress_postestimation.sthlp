{smcl}
{* *! version 1.1.4  15oct2018}{...}
{viewerdialog predict "dialog spxtregress_p"}{...}
{viewerdialog estat "dialog spxtregress_estat"}{...}
{vieweralsosee "[SP] spxtregress postestimation" "mansection SP spxtregresspostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] spxtregress" "help spxtregress"}{...}
{viewerjumpto "Postestimation commands" "spxtregress postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "spxtregress_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "spxtregress postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "spxtregress postestimation##syntax_margins"}{...}
{viewerjumpto "estat" "spxtregress postestimation##syntax_estat"}{...}
{viewerjumpto "Examples" "spxtregress postestimation##examples"}{...}
{viewerjumpto "Stored results" "spxtregress postestimation##results"}{...}
{p2colset 1 36 38 2}{...}
{p2col:{bf:[SP] spxtregress postestimation} {hline 2}}Postestimation tools
for spxtregress{p_end}
{p2col:}({mansection SP spxtregresspostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation command is of special interest after 
{cmd:spxtregress}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb spxtregress postestimation##estat_impact:estat impact}}direct,
indirect, and total impacts{p_end}
{synoptline}

{pstd}
The following postestimation commands are also available:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_lincom
INCLUDE help post_lrtest
{synopt :{helpb spxtregress postestimation##margins:margins}}marginal means, predictive margins, marginal effects, and average marginal effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb spxtregress postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SP spxtregresspostestimationMethodsandformulas:Methods and formulas}

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
{synopt :{opt xb}}linear prediction{p_end}
{synoptline}
{p 4 6 2}
These statistics are only available in a subset of the estimation sample.
{p_end}


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as the
reduced-form mean, the direct mean, the indirect mean, or the linear
prediction.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt rform}, the default, calculates the reduced-form mean.  It is the
predicted mean of the dependent variable conditional on the independent
variables and any spatial lags of the independent variables.  See
{mansection SP spxtregresspostestimationMethodsandformulas:{it:Methods and formulas}}.

{phang}
{opt direct} calculates the direct mean.
It is a unit's predicted contribution to its own reduced-form mean.  
The direct and indirect means sum to the reduced-form mean.

{phang}
{opt indirect} calculates the indirect mean.
It is the predicted sum of the other units' contributions to a unit's 
reduced-form mean.  

{phang}
{opt xb} calculates the predicted linear combination of the independent
variables.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt rf:orm}}reduced-form mean; the default{p_end}
{synopt :{opt direct}}direct mean{p_end}
{synopt :{opt indirect}}indirect mean{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synoptline}

{pstd}
For the full syntax, see {manhelp margins R}.


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for reduced-form mean, direct
mean, indirect mean, and linear predictions.


{marker syntax_estat}{...}
{marker estat_impact}{...}
{title:Syntax for estat impact}

{p 8 16 2}
{cmd:estat} {cmd:impact}
[{varlist}]
{ifin}
[{cmd:,} {cmd:nolog}]

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


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. copy https://www.stata-press.com/data/r16/homicide_1960_1990.dta .}
{p_end}
{phang2}{cmd:. copy https://www.stata-press.com/data/r16/homicide_1960_1990_shp.dta .}
{p_end}
{phang2}{cmd:. use homicide_1960_1990}
{p_end}
{phang2}{cmd:. xtset _ID year}
{p_end}
{phang2}{cmd:. spset}
{p_end}

{pstd}Create a contiguity weighting matrix with the default spectral normalization{p_end}
{phang2}{cmd:. spmatrix create contiguity W if year == 1990}

{pstd}Fit a spatial autoregressive random-effects model{p_end}
{phang2}{cmd:. spxtregress hrate ln_population ln_pdensity gini i.year,}
                     {cmd:re dvarlag(W)}

{pstd}Obtain direct, indirect, and total effects of the covariates{p_end}
{phang2}{cmd:. estat impact}

{pstd}Obtain the averages of the effects of {cmd:gini}{p_end}
{phang2}{cmd:. estat impact gini}

{pstd}Create an inverse-distance weighting matrix with the default spectral normalization{p_end}
{phang2}{cmd:. spmatrix create idistance M if year == 1990}

{pstd}Refit the model above but specify the interaction of {cmd:gini} and
{cmd:year}{p_end}
{phang2}{cmd:. spxtregress hrate ln_population ln_pdensity c.gini##i.year,}
                     {cmd:re dvarlag(M) errorlag(M)}

{pstd}Test the significance of the {cmd:gini} and {cmd:year} interaction{p_end}
{phang2}{cmd:. contrasts c.gini#year} 

{pstd}Obtain the effect of {cmd:gini} by {cmd:year} based on year 1960{p_end}
{phang2}{cmd:. estat impact gini if year == 1960}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat impact} stores the following in {cmd:r()}:

{synoptset 24 tabbed}{...}
{p2col 5 24 28 2: Scalars}{p_end}
{synopt :{cmd:r(N)}}number of observations{p_end}

{p2col 5 24 28 2: Macros}{p_end}
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
