{smcl}
{* *! version 1.0.1  05feb2020}{...}
{viewerdialog lassogof "dialog lassogof"}{...}
{vieweralsosee "[LASSO] lassogof" "mansection lasso lassogof"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[LASSO] lasso" "help lasso"}{...}
{vieweralsosee "[LASSO] lassoknots" "help lassoknots"}{...}
{vieweralsosee "[LASSO] lasso postestimation" "help lasso postestimation"}{...}
{viewerjumpto "Syntax" "lassogof##syntax"}{...}
{viewerjumpto "Menu" "lassogof##menu"}{...}
{viewerjumpto "Description" "lassogof##description"}{...}
{viewerjumpto "Links to PDF documentation" "lassogof##linkspdf"}{...}
{viewerjumpto "Options" "lassogof##options"}{...}
{viewerjumpto "Examples" "lassogof##examples"}{...}
{viewerjumpto "Stored results" "lassogof##results"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[LASSO] lassogof} {hline 2}}Goodness of fit after lasso for
prediction{p_end}
{p2col:}({mansection LASSO lassogof:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:lassogof}
[{it:namelist}]
{ifin}
[{cmd:,} {it:options}]

{phang}
{it:namelist} is a name of a stored estimation result, a list of names, 
{cmd:_all}, or {cmd:*}.  {cmd:_all} and {cmd:*} mean the same thing.
See {manhelp estimates_store R:estimates store}.

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{cmdab:pen:alized}}use penalized (shrunken) coefficient estimates; the default{p_end}
{synopt :{cmdab:post:selection}}use postselection coefficient estimates{p_end}
{synopt :{opth over(varname)}}display goodness of fit for samples defined by {it:varname}{p_end}
{synopt :{cmd:noweights}}do not use weights when calculating goodness of fit{p_end}
{synoptline}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Postestimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:lassogof} calculates goodness of fit of predictions after {helpb lasso},
{helpb sqrtlasso}, and {helpb elasticnet}.  It also calculates goodness of fit
after {helpb regress}, {helpb logit}, {helpb probit}, and {helpb poisson}
estimations for comparison purposes.  For linear models, mean squared error of
the prediction and R^2 are displayed.  For logit, probit, and Poisson models,
deviance and deviance ratio are shown.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection LASSO lassogofQuickstart:Quick start}

        {mansection LASSO lassogofRemarksandexamples:Remarks and examples}

        {mansection LASSO lassogofMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:penalized}
specifies that the penalized coefficient estimates be used to calculate
goodness of fit.  Penalized coefficients are those estimated by lasso with
shrinkage.  This is the default.

{phang}
{cmd:postselection}
specifies that the postselection coefficient estimates be used to calculate
goodness of fit.  Postselection coefficients are estimated by taking the 
covariates selected by lasso and reestimating the coefficients using an
unpenalized estimator -- namely, an ordinary linear regression, logistic 
regression, probit model, or Poisson regression as appropriate.

{phang}
{opt over(varname)} specifies that goodness of fit be calculated separately for
groups of observations defined by the distinct values of {it:varname}.
Typically, this option would be used when the lasso is fit on one sample and
one wishes to compare the fit in that sample with the fit in another sample.

{phang}
{cmd:noweights} specifies that any weights used to estimate the lasso be
ignored in the calculation of goodness of fit.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse cattaneo2}{p_end}
{phang2}{cmd:. lasso linear bweight c.mage##c.mage c.fage##c.fage}
     {cmd:c.mage#c.fage c.fedu##c.medu i.(mmarried mhisp fhisp}
     {cmd:foreign alcohol msmoke fbaby prenatal1)}

{pstd}Goodness of fit for current lasso result using penalized coefficient
estimates{p_end}
{phang2}{cmd:. lassogof}

{pstd}Goodness of fit using postselection coefficient estimates{p_end}
{phang2}{cmd:. lassogof, postselection}

{pstd}Setup{p_end}
{phang2}{cmd:. lasso linear bweight c.mage##c.mage c.fage##c.fage}
     {cmd:c.mage#c.fage c.fedu##c.medu i.(mmarried mhisp fhisp foreign}
     {cmd:alcohol msmoke fbaby prenatal1)}{p_end}
{phang2}{cmd:. estimates store cv}{p_end}
{phang2}{cmd:. lasso linear bweight c.mage##c.mage c.fage##c.fage}
     {cmd:c.mage#c.fage c.fedu##c.medu i.(mmarried mhisp fhisp foreign}
     {cmd:alcohol msmoke fbaby prenatal1), selection(adaptive)}{p_end}
{phang2}{cmd:. estimates store adapt}

{pstd}Goodness of fit for results from cross-validation and adaptive
lasso{p_end}
{phang2}{cmd:. lassogof cv adapt}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:lassogof} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(names)}}names of estimation results displayed{p_end}
{synopt:{cmd:r(over_var)}}name of the {cmd:over()} variable{p_end}
{synopt:{cmd:r(over_levels)}}levels of the {cmd:over()} variable{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(table)}}matrix containing the values displayed{p_end}
{p2colreset}{...}
