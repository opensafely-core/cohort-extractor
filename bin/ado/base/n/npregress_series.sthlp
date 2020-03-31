{smcl}
{* *! version 1.0.1  09oct2019}{...}
{viewerdialog "npregress series" "dialog npregress_series"}{...}
{vieweralsosee "[R] npregress series" "mansection R npregressseries"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] npregress series postestimation" "help npregress series postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] npregress intro" "mansection R npregressintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] kdensity" "help kdensity"}{...}
{vieweralsosee "[R] lpoly" "help lpoly"}{...}
{viewerjumpto "Syntax" "npregress_series##syntax"}{...}
{viewerjumpto "Menu" "npregress_series##menu"}{...}
{viewerjumpto "Description" "npregress_series##description"}{...}
{viewerjumpto "Links to PDF documentation" "npregress_series##linkspdf"}{...}
{viewerjumpto "Options" "npregress_series##options"}{...}
{viewerjumpto "Examples" "npregress_series##examples"}{...}
{viewerjumpto "Stored results" "npregress_series##results"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[R] npregress series} {hline 2}}Nonparametric series regression{p_end}
{p2col:}({mansection R npregressseries:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:npregress} {cmd:series}
{depvar}
{indepvars}_series
{ifin}
[{help npregress series##weight:{it:weight}}]
[{cmd:,} {it:options}]

{phang}
{it:indepvars}_series is the list of independent variables for which
a basis function will be formed.

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{cmd:bspline}}use a third-order B-spline basis; the default{p_end}
{synopt :{opt bspline(#)}}use a B-spline basis of order {it:#}{p_end}
{synopt :{opt spline}}use a third-order natural spline basis{p_end}
{synopt :{opt spline(#)}}use a natural spline basis of order {it:#}{p_end}
{synopt :{opt polynomial}}use a polynomial basis{p_end}
{synopt :{opt polynomial(#)}}use a polynomial basis of order {it:#}{p_end}
{synopt :{opth asis(varlist)}}include {it:varlist} in model as specified; do
not use in basis{p_end}
{synopt :{opth nointer:act(npregress series##seriesvarlist:seriesvarlist)}}use
{it:seriesvarlist} in basis without interactions{p_end}
{synopt :{opth criterion:(npregress series##crittype:crittype)}}criterion to
use; {it:crittype} may be {cmd:cv}, {cmd:gcv}, {cmd:aic}, {cmd:bic}, or
{cmd:mallows}{p_end}
{synopt :{opt knots(#)}}use a spline or B-spline basis function with {it:#} knots{p_end}
{synopt :{opt knotsmat(matname)}}use knots in matrix {it:matname} for spline
or B-spline estimation{p_end}
{synopt :{opt distinct(#)}}minimum number of distinct values allowed in
continuous covariates; default is {cmd:distinct(10)}{p_end}
{synopt :{cmd:basis(}{it:stub} [{cmd:, replace}]{cmd:)}}store elements of
spline or B-spline basis function using {it:stub}{p_end}
{synopt :{cmd:rescale(}{it:stub} [{cmd:, replace}]{cmd:)}}store rescaled
values of covariates using {it:stub}{p_end}

{syntab:SE}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {cmd:robust}, {cmd:ols}, or  
{opt boot:strap}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt aequations}}display auxiliary regression coefficients{p_end}
{synopt :{it:{help npregress series##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt:{it:{help npregress series##maximize_options:maximize_options}}}control the maximization process{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
INCLUDE help fvvarlist2
{p 4 6 2}
{cmd:bootstrap}, {cmd:by}, and {cmd:jackknife} are allowed; see {help prefix}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s and {cmd:iweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp npregress_series_postestimation R:npregress series postestimation}
for features available after estimation.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Nonparametric analysis > Nonparametric series regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:npregress series} performs nonparametric series estimation using
a B-spline, spline, or polynomial basis.  Like linear
regression, nonparametric regression models the mean of the outcome conditional
on the covariates, but unlike linear regression, it makes no assumptions about
the functional form of the relationship between the outcome and the covariates.
{cmd:npregress series} may be used to model the mean of a continuous, count, or
binary outcome.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R npregressseriesQuickstart:Quick start}

        {mansection R npregressseriesRemarksandexamples:Remarks and examples}

        {mansection R npregressseriesMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{cmd:bspline} specifies that a third-order B-spline be selected. It is the
default basis.  

{phang}
{opt bspline(#)} specifies that a B-spline of order 
{it:#} be used as the basis. The order may be 1, 2, or 3.

{phang}
{opt spline}
specifies that a third-order natural spline be selected as the basis.

{phang}
{opt spline(#)} specifies that a natural spline of order 
{it:#} be used as the basis. The order may be 1, 2, or 3.

{phang}
{opt polynomial}
specifies that a polynomial be selected as the basis.

{phang}
{opt polynomial(#)} specifies that a polynomial of order  
{it:#} be used as the basis. The order may be an integer between
1 and 16. 

{phang}
{opth asis(varlist)} specifies that variables in {it:varlist} be included
as independent variables in the model without any transformation. No 
B-spline, spline, or polynomial basis function will be formed from 
these variables. Variables in {it:varlist} may not be specified
in {indepvars}_series. 

{marker seriesvarlist}{...}
{phang}
{opt nointeract(seriesvarlist)} specifies that the terms in the
basis function formed from variables in 
{it:seriesvarlist} not be interacted with the terms of the basis function
formed from other variables in {indepvars}_series. Covariates specified in
{it:seriesvarlist} must be in {it:indepvars}_series. 

{marker crittype}{...}
{phang} 
{opt criterion(crittype)} specifies that {it:crittype} be used to select the
optimal number of terms in the basis function. {it:crittype} may be one of the
following:
{opt cv} (cross-validation), {opt gcv} (generalized cross-validation),
{opt aic} (Akaike's information criterion), 
{opt bic} (Schwarz's Bayesian information criterion), or {opt mallows}
(Mallows's C_p). The default is {cmd:criterion(cv)}.   

{phang} 
{opt knots(#)} specifies that a spline or B-spline basis function with
{it:#} knots be used.  The minimum number of knots must be an integer greater
than or equal to 1.  The maximum number of knots is either 4,096 or
two-thirds of the sample size, whichever is smaller. 

{phang} 
{opt knotsmat(matname)} specifies that the knots for each 
continuous covariate be the values in each row of {it:matname}. 
The number of knots should be the same for each covariate, and 
there must be as many rows as there are continuous covariates. If 
rows of {it:matname} are not labeled with {it:varname}s, then rows
are assumed to be in the order of {indepvars}_series.  

{phang}
{opt distinct(#)} specifies the minimum number of distinct values allowed in
continuous variables.  By default, continuous variables that enter the basis
through either {indepvars}_series or
{help npregress series##seriesvarlist:s{it:seriesvarlist}} are required to
have at least 10 distinct values.  Continuous variables with few distinct
values provide little information for determining an appropriate basis
function and may produce unreliable estimates.

{phang}
{cmd:basis(}{it:stub} [{cmd:, replace}]{cmd:)} specifies that the elements
of the basis function generated by {cmd:npregress series} be stored with the
specified names.

{pmore}
The option argument {it:stub} is the prefix used to generate enumerated
variables for each element of the basis.

{pmore}
When {cmd:replace} is used, existing variables named with {it:stub}
are replaced by those from the new computation.

{phang}
{cmd:rescale(}{it:stub} [{cmd:, replace}]{cmd:)}
specifies that the rescaled covariates used to generate the basis function be
stored with the specified names.

{pmore}
The option argument {it:stub} is the prefix used to generate enumerated
variable names for the covariates.

{pmore}
When {cmd:replace} is used, existing covariates named with {it:stub}
are replaced by those from the new computation.

{dlgtab:SE}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are robust to some kinds of misspecification
({cmd:robust}), that assume homoskedasticity ({cmd:ols}), and that use
bootstrap methods ({cmd:bootstrap}); see {manhelpi vce_option R}. 

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

{marker citype_ds}{...}
{phang}
{opt aequations} specifies that the auxiliary regression coefficients be
reported. By default, only the average marginal effects of the covariates on
the outcome are reported.  

INCLUDE help displayopts_list

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}:
{opt iter:ate(#)},
[{cmd:no}]{opt log},
{opt tol:erance(#)};
see {helpb maximize:[R] Maximize}.  These options are seldom used.

{pstd}
The following option is available with {cmd:npregress series} but is not shown
in the dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse dui}

{pstd}Nonparametric series regression of {cmd:citations} as a function of
{cmd:fines}{p_end}
{phang2}{cmd:. npregress series citations fines}

{pstd}Same as above, but use Mallow's C_p to select the optimal number of
terms in the B-spline basis{p_end}
{phang2}{cmd:. npregress series citations fines, criterion(mallows)}{p_end}

{pstd}Use a polynomial of order 5 as the basis{p_end}
{phang2}{cmd:. npregress series citations fines, polynomial(5)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:npregress series} stores the following in {cmd:e()}:

{synoptset 23 tabbed}{...}
{p2col 5 23 25 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(r2)}}R-squared{p_end}
{synopt:{cmd:e(r2_a)}}adjusted R-squared{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}
{synopt:{cmd:e(order)}}order of basis function{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{p2col 5 23 25 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:npregress}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(basis)}}{cmd:bsplines}, {cmd:splines}, or {cmd:polynomials}{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(knots)}}number of knots selected{p_end}
{synopt:{cmd:e(datasignaturevars)}}variables used in calculation of checksum
{p_end}
{synopt:{cmd:e(datasignature)}}the checksum{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsprop)}}signals to the {cmd:margins} command{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}

{p2col 5 23 25 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of estimators{p_end}
{synopt:{cmd:e(V_modelbased)}} model-based variance{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}

{p2col 5 23 25 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
