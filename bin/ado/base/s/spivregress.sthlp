{smcl}
{* *! version 1.1.6  15oct2018}{...}
{viewerdialog Sp "dialog sp"}{...}
{vieweralsosee "[SP] spivregress" "mansection SP spivregress"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] spivregress postestimation" "help spivregress postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] estat moran" "help estat moran"}{...}
{vieweralsosee "[R] ivregress" "help ivregress"}{...}
{vieweralsosee "[SP] spmatrix" "help spmatrix"}{...}
{vieweralsosee "[SP] spregress" "help spregress"}{...}
{vieweralsosee "[SP] spxtregress" "help spxtregress"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] Intro" "mansection SP Intro"}{...}
{viewerjumpto "Syntax" "spivregress##syntax"}{...}
{viewerjumpto "Menu" "spivregress##menu"}{...}
{viewerjumpto "Description" "spivregress##description"}{...}
{viewerjumpto "Links to PDF documentation" "spivregress##linkspdf"}{...}
{viewerjumpto "Options" "spivregress##options"}{...}
{viewerjumpto "Examples" "spivregress##examples"}{...}
{viewerjumpto "Stored results" "spivregress##results"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[SP] spivregress} {hline 2}}Spatial autoregressive models with
endogenous covariates{p_end}
{p2col:}({mansection SP spivregress:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:spivregress}
{depvar}
[{varlist}_1]
{cmd:(}{it:varlist}_2 {cmd:=} {it:varlist}_iv{cmd:)}
{ifin}
[{cmd:,} {it:options}]

{phang}
{it:varlist}_1 is the list of included exogenous regressors.

{phang}
{it:varlist}_2 is the list of endogenous regressors.

{phang}
{it:varlist}_iv is the list of excluded exogenous regressors 
used with {it:varlist}_1 as instruments for {it:varlist}_2.

{synoptset 30 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt dvarl:ag(spmatname)}}spatially lagged dependent variable;
repeatable{p_end}
{synopt :{opt err:orlag(spmatname)}}spatially lagged errors; repeatable{p_end}
{synopt :{cmdab:ivarl:ag(}{it:spmatname} {cmd::} {varlist}{cmd:)}}spatially
lagged exogenous variables from {it:varlist}_1; repeatable{p_end}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opt het:eroskedastic}}treat errors as heteroskedastic{p_end}
{synopt :{opt force}}allow estimation when estimation sample is a subset of
the sample used to create the spatial weighting matrix{p_end}
{synopt :{opt impower(#)}}order of instrumental-variable approximation{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}
{synopt :{help spivregress##display_options:{it:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Optimization}
{synopt :{help spivregress##optimopts:{it:optimization_options}}}control the
optimization process; seldom used{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}


{p 4 6 2}
{it:varlist}_1, {it:varlist}_2, {it:varlist}_iv, and
{it:varlist} specified in {cmd:ivarlag()} may contain factor variables; see
{help fvvarlist}.{p_end}
{p 4 6 2}
{cmd:coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp spivregress_postestimation SP:spivregress postestimation} for
features available after estimation.{p_end}


INCLUDE help menu_spatial


{marker description}{...}
{title:Description}

{pstd}
{cmd:spivregress} is the equivalent of {helpb ivregress} for spatial data.
{cmd:spivregress} fits spatial autoregressive (SAR) models, also known as
simultaneous autoregressive models, where the models may contain additional
endogenous variables as well as exogenous variables.  These models can be used
to account for possible dependence between the outcome variable and the
unobserved errors. 

{pstd}
For models without endogenous regressors, see {manhelp spregress SP}. 

{pstd}
If you have not read {manlink SP Intro 1} - {manlink SP Intro 8},
you should do so before using {cmd:spivregress}.  Your data must be Sp data to
use {cmd:spivregress}.  See {manlink SP Intro 3} for instructions on how to
prepare your data.

{pstd}
To specify spatial lags, you will need to have one or more 
spatial weighting matrices. 
See {manlink SP Intro 2} and {manhelp spmatrix SP} for an explanation of the 
types of weighting matrices and how to create them.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SP spivregressQuickstart:Quick start}

        {mansection SP spivregressRemarksandexamples:Remarks and examples}

        {mansection SP spivregressMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt dvarlag(spmatname)} specifies a spatial weighting
matrix that defines a spatial lag of the dependent variable.  
This option is repeatable to allow higher-order models.
By default, no spatial lags of the dependent variable are included.  

{phang}
{opt errorlag(spmatname)} specifies a spatial weighting
matrix that defines a spatially lagged error. 
This option is repeatable to allow higher-order models.
By default, no spatially lagged errors are included.

{phang}
{cmd:ivarlag(}{it:spmatname} {cmd::} {varlist}{cmd:)} specifies a spatial
weighting matrix and a list of exogenous variables that define spatial lags of
the variables.  The variables in {it:varlist} must be a subset of the
exogenous variables in {it:varlist}_1.  This option is repeatable to allow
spatial lags created from different matrices.  By default, no spatial lags of
the exogenous variables are included.

{phang}
{cmd:noconstant}; see {helpb estimation options:[R] Estimation options}.

{phang}
{opt heteroskedastic} specifies that the estimator treat the
errors as heteroskedastic instead of homoskedastic, which is the default; see
{mansection SP spregressMethodsandformulas:{it:Methods and formulas}}
in {manhelp spregress SP}.

{phang}
{opt force} requests that estimation be done when the estimation sample is a
proper subset of the sample used to create the spatial weighting matrices.
The default is to refuse to fit the model.  Weighting matrices potentially
connect all the spatial units.  When the estimation sample is a subset of this
space, the spatial connections differ and spillover effects can be altered.
In addition, the normalization of the weighting matrix differs from what it
would have been had the matrix been normalized over the estimation sample.
The better alternative to {opt force} is first to understand the spatial space
of the estimation sample and, if it is sensible, then create new weighting
matrices for it.
See {manhelp spmatrix SP} and
{mansection SP Intro2Remarksandexamplesforce:{it:Missing values, dropped observations, and the W matrix}}
in {bf:[SP] Intro 2}.

{phang}
{opt impower(#)} specifies the order of an instrumental-variable approximation
used in fitting the model.  The derivation of the estimator involves a product
of {it:#} matrices. Increasing {it:#} may improve the precision of the
estimation and will not cause harm, but will require more computer time.  The
default is {cmd:impower(2)}.  See  
{mansection SP spregressMethodsandformulasimpower:{it:Methods and formulas}}
for additional details on {opt impower(#)}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options:[R] Estimation options}.

INCLUDE help displayopts_list

{dlgtab:Optimization}

{marker optimopts}{...}
{phang}
{it:optimization_options}:
{opt iter:ate(#)},
[{cmd:no}]{opt log},
{opt tr:ace},
{opt grad:ient},
{opt showstep},
{opt hess:ian},
{opt showtol:erance},
{opt tol:erance(#)},
{opt ltol:erance(#)},
{opt nrtol:erance(#)}, and
{opt nonrtol:erance};
see {manhelp mf_optimize M-5:optimize()}.

{pstd}
The following option is available with {cmd:spivregress} 
but is not shown in the dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. copy https://www.stata-press.com/data/r16/dui_southern.dta .}
{p_end}
{phang2}{cmd:. copy https://www.stata-press.com/data/r16/dui_southern_shp.dta .}
{p_end}
{phang2}{cmd:. use dui_southern}
{p_end}
{phang2}{cmd:. spset}
{p_end}

{pstd}Create a contiguity weighting matrix with the default spectral normalization{p_end}
{phang2}{cmd:. spmatrix create contiguity W}

{pstd}Fit a generalized spatial two-stage least-squares regression{p_end}
{phang2}{cmd:. spivregress dui nondui vehicles i.dry (police = elect),}
                     {cmd:dvarlag(W) errorlag(W)}

{pstd}Same as above but add a spatial lag of the covariate {cmd:dry}{p_end}
{phang2}{cmd:. spivregress dui nondui vehicles i.dry (police = elect),}
                     {cmd:dvarlag(W) errorlag(W) ivarlag(W: i.dry)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:spivregress} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 22 2: Scalars}{p_end}
{synopt :{cmd:e(N)}}number of observations{p_end}
{synopt :{cmd:e(k)}}number of parameters{p_end}
{synopt :{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt :{cmd:e(df_c)}}degrees of freedom for comparison test{p_end}
{synopt :{cmd:e(iterations)}}number of generalized method of moments
iterations{p_end}
{synopt :{cmd:e(iterations_2sls)}}number of two-stage least-squares
iterations{p_end}
{synopt :{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt :{cmd:e(r2_p)}}pseudo-R-squared{p_end}
{synopt :{cmd:e(chi2)}}chi-squared{p_end}
{synopt :{cmd:e(chi2_c)}}chi-squared for comparison test{p_end}
{synopt :{cmd:e(p)}}p-value for model test{p_end}
{synopt :{cmd:e(p_c)}}p-value for test of spatial terms{p_end}
{synopt :{cmd:e(converged)}}{cmd:1} if generalized method of moments converged,
{cmd:0} otherwise{p_end}
{synopt :{cmd:e(converged_2sls)}}{cmd:1} if two-stage least-squares converged,
{cmd:0} otherwise{p_end}

{p2col 5 20 22 2: Macros}{p_end}
{synopt :{cmd:e(cmd)}}{cmd:spivregress}{p_end}
{synopt :{cmd:e(cmdline)}}command as typed{p_end}
{synopt :{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt :{cmd:e(indeps)}}names of independent variables{p_end}
{synopt :{cmd:e(idvar)}}name of ID variable{p_end}
{synopt :{cmd:e(estimator)}}{cmd:gs2sls}{p_end}
{synopt :{cmd:e(title)}}title in estimation output{p_end}
{synopt :{cmd:e(constant)}}{cmd:hasconstant} or {cmd:noconstant}{p_end}
{synopt :{cmd:e(exogr)}}exogenous regressors{p_end}
{synopt :{cmd:e(dlmat)}}names of spatial weighting matrices applied to {depvar}{p_end}
{synopt :{cmd:e(elmat)}}names of spatial weighting matrices applied to errors{p_end}
{synopt :{cmd:e(het)}}{cmd:heteroskedastic} or {cmd:homoskedastic}{p_end}
{synopt :{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt :{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt :{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt :{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt :{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt :{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt :{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt :{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 20 22 2: Matrices}{p_end}
{synopt :{cmd:e(b)}}coefficient vector{p_end}
{synopt :{cmd:e(delta_2sls)}}two-stage least-squares estimates of coefficients in
spatial lag equation{p_end}
{synopt :{cmd:e(rho_2sls)}}generalized method of moments estimates of
coefficients in spatial error equation{p_end}
{synopt :{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{p2col 5 20 22 2: Functions}{p_end}
{synopt :{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
