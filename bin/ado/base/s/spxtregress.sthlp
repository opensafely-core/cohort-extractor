{smcl}
{* *! version 1.1.7  12dec2018}{...}
{viewerdialog Sp "dialog sp"}{...}
{vieweralsosee "[SP] spxtregress" "mansection SP spxtregress"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] spxtregress postestimation" "help spxtregress postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] estat moran" "help estat moran"}{...}
{vieweralsosee "[SP] spbalance" "help spbalance"}{...}
{vieweralsosee "[SP] spivregress" "help spivregress"}{...}
{vieweralsosee "[SP] spmatrix" "help spmatrix"}{...}
{vieweralsosee "[SP] spregress" "help spregress"}{...}
{vieweralsosee "[XT] xtreg" "help xtreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] Intro" "mansection SP Intro"}{...}
{viewerjumpto "Syntax" "spxtregress##syntax"}{...}
{viewerjumpto "Menu" "spxtregress##menu"}{...}
{viewerjumpto "Description" "spxtregress##description"}{...}
{viewerjumpto "Links to PDF documentation" "spxtregress##linkspdf"}{...}
{viewerjumpto "Options for spxtregress, fe" "spxtregress##options_spxtregress_fe"}{...}
{viewerjumpto "Options for spxtregress, re" "spxtregress##options_spxtregress_re"}{...}
{viewerjumpto "Examples" "spxtregress##examples"}{...}
{viewerjumpto "Stored results" "spxtregress##results"}{...}
{viewerjumpto "Reference" "spxtregress##reference"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[SP] spxtregress} {hline 2}}Spatial autoregressive models for
panel data{p_end}
{p2col:}({mansection SP spxtregress:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Fixed-effects maximum likelihood

{p 8 14 2}
{cmd:spxtregress}
{depvar}
[{indepvars}]
{ifin}{cmd:,}
{cmd:fe}
[{help spxtregress##fe_options:{it:fe_options}}]


{phang}
Random-effects maximum likelihood

{p 8 14 2}
{cmd:spxtregress}
{depvar}
[{indepvars}]
{ifin}{cmd:,}
{cmd:re}
[{help spxtregress##re_options:{it:re_options}}]


{marker fe_options}{...}
{synoptset 30 tabbed}{...}
{synopthdr:fe_options}
{synoptline}
{syntab:Model}
{p2coldent :* {opt fe}}use fixed-effects estimator{p_end}
{synopt :{opt dvarl:ag(spmatname)}}spatially lagged dependent variable{p_end}
{synopt :{opt err:orlag(spmatname)}}spatially lagged errors{p_end}
{synopt :{cmdab:ivarl:ag(}{it:spmatname} {cmd::} {varlist}{cmd:)}}spatially lagged independent variables; repeatable{p_end}
{synopt :{opt force}}allow estimation when estimation sample is a subset of the sample used to create the spatial weighting matrix{p_end}
{synopt :{opt grid:search(#)}}resolution of the initial-value search grid; seldom used{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{help spxtregress##fe_display_options:{it:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt :{help spxtregress##fe_maxopts:{it:maximize_options}}}control the maximization process; seldom used{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}

{marker re_options}{...}
{synopthdr:re_options}
{synoptline}
{syntab:Model}
{p2coldent :* {opt re}}use random-effects estimator{p_end}
{synopt :{opt dvarl:ag(spmatname)}}spatially lagged dependent variable{p_end}
{synopt :{opt err:orlag(spmatname)}}spatially lagged errors{p_end}
{synopt :{cmdab:ivarl:ag(}{it:spmatname} {cmd::} {varlist}{cmd:)}}spatially lagged independent variables; repeatable{p_end}
{synopt :{opt sarpan:el}}alternative formulation of the estimator in which the panel effects follow the same spatial process as the errors{p_end}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opt force}}allow estimation when estimation sample is a subset of the sample used to create the spatial weighting matrix{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{help spxtregress##re_display_options:{it:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt :{help spxtregress##re_maxopts:{it:maximize_options}}}control the maximization process; seldom used{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}


{p 4 6 2}
* You must specify either {cmd:fe} or {cmd:re}.{p_end}
{p 4 6 2}
{it:indepvars}  and {it:varlist} specified in {cmd:ivarlag()} may contain factor
variables; see {help fvvarlist}.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp spxtregress_postestimation SP:spxtregress postestimation} for
features available after estimation.{p_end}


INCLUDE help menu_spatial


{marker description}{...}
{title:Description}

{pstd}
{cmd:spxtregress} fits spatial autoregressive (SAR) models, also known as
simultaneous autoregressive models, for panel data.  The commands
{cmd:spxtregress, fe} and {cmd:spxtregress, re} are extensions of
{cmd:xtreg, fe} and {cmd:xtreg, re} for spatial data; see
{manhelp xtreg XT}.

{pstd}
If you have not read {manlink SP Intro 1} - {manlink SP Intro 8},
you should do so before using {cmd:spxtregress}.

{pstd}
To use {cmd:spxtregress}, your data must be Sp data and {helpb xtset}.  See
{manlink SP Intro 3} for instructions on how to prepare your data.

{pstd}
To specify spatial lags, you will need to have one or more spatial weighting
matrices.  See {manlink SP Intro 2} and {manhelp spmatrix SP} for an
explanation of the types of weighting matrices and how to create them.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SP spxtregressQuickstart:Quick start}

        {mansection SP spxtregressRemarksandexamples:Remarks and examples}

        {mansection SP spxtregressMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_spxtregress_fe}{...}
{title:Options for spxtregress, fe}

{dlgtab:Model}

{phang}
{opt fe} requests the fixed-effects regression estimator.

{phang}
{opt dvarlag(spmatname)} specifies a spatial weighting
matrix that defines a spatial lag of the dependent variable.
Only one {opt dvarlag()} option may be specified.  
By default, no spatial lags of the dependent variable are included.  

{phang}
{opt errorlag(spmatname)} specifies a spatial weighting
matrix that defines a spatially lagged error. 
Only one {opt errorlag()} option may be specified.  
By default, no spatially lagged errors are included.

{phang}
{cmd:ivarlag(}{it:spmatname} {cmd::} {varlist}{cmd:)} specifies a 
spatial weighting matrix and a list of independent variables that define
spatial lags of the variables.  This option is repeatable to
allow spatial lags created from different matrices.  By
default, no spatial lags of the independent variables are included.

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
{opt gridsearch(#)} specifies the resolution of the initial-value search grid.
The default is {cmd:gridsearch(0.1)}.  You may specify any number between
0.001 and 0.1 inclusive. 

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options:[R] Estimation options}.

{marker fe_display_options}{...}
INCLUDE help displayopts_list

{dlgtab:Maximization}

{marker fe_maxopts}{...}
{phang}
{it:maximize_options}:
{opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
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
see {helpb maximize:[R] Maximize}.

{pstd}
The following option is available with {cmd:spxtregress, fe} 
but is not shown in the dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker options_spxtregress_re}{...}
{title:Options for spxtregress, re}

{dlgtab:Model}

{phang}
{opt re} requests the generalized least-squares random-effects estimator.

{phang}
{opt dvarlag(spmatname)} specifies a spatial weighting
matrix that defines a spatial lag of the dependent variable.
Only one {opt dvarlag()} option may be specified.  
By default, no spatial lags of the dependent variable are included.  

{phang}
{opt errorlag(spmatname)} specifies a spatial weighting
matrix that defines a spatially lagged error. 
Only one {opt errorlag()} option may be specified.  
By default, no spatially lagged errors are included.

{phang}
{cmd:ivarlag(}{it:spmatname} {cmd::} {varlist}{cmd:)} specifies a 
spatial weighting matrix and a list of independent variables that define
spatial lags of the variables.  This option is repeatable to
allow spatial lags created from different matrices.  By
default, no spatial lags of the independent variables are included.

{phang}
{opt sarpanel} requests an alternative formulation of the estimator in which
the panel effects follow the same spatial process as the errors.  By default,
the panel effects are included in the estimation equation as an additive term,
just as they are in the standard nonspatial random-effects model.  When
{opt sarpanel} and {opt errorlag(spmatname)} are specified, the panel effects
also have a spatial autoregressive form based on {it:spmatname}. If
{opt errorlag()} is not specified with {opt sarpanel}, the estimator is
identical to the estimator when {opt sarpanel} is not specified.  The
{opt sarpanel} estimator was originally developed by
{help spxtregress##KKP2007:Kapoor, Kelejian, and Prucha (2007)}; see
{mansection SP spxtregressMethodsandformulas:{it:Methods and formulas}}.

{phang}
{opt noconstant}; see
     {helpb estimation options:[R] Estimation options}.

{phang}
{opt force} requests that estimation be done when the estimation sample is a
proper subset of the sample used to create the spatial weighting matrices.
The default is to refuse to fit the model.  This is the same {opt force}
option described for use with {cmd:spxtregress, fe}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.

{marker re_display_options}{...}
INCLUDE help displayopts_list

{dlgtab:Maximization}

{marker re_maxopts}{...}
{phang}
{it:maximize_options}:
{opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
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
see {helpb maximize:[R] Maximize}.

{pstd}
The following option is available with {cmd:spxtregress, re} 
but is not shown in the dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


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

{pstd}Create an inverse-distance weighting matrix with the default spectral normalization{p_end}
{phang2}{cmd:. spmatrix create idistance M if year == 1990}

{pstd}Same as above but use the alternative formulation of the estimator{p_end}
{phang2}{cmd:. spxtregress hrate ln_population ln_pdensity gini i.year,}
                     {cmd:re sarpanel dvarlag(M) errorlag(M)}

{pstd}Fit a spatial autoregressive fixed-effects model{p_end}
{phang2}{cmd:. spxtregress hrate ln_population ln_pdensity gini i.year,}
                     {cmd:fe dvarlag(M) errorlag(M)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:spxtregress, fe} and
{cmd:spxtregress, re}
store the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 22 2: Scalars}{p_end}
{synopt :{cmd:e(N)}}number of observations{p_end}
{synopt :{cmd:e(N_g)}}number of groups (panels){p_end}
{synopt :{cmd:e(g)}}group size{p_end}
{synopt :{cmd:e(k)}}number of parameters{p_end}
{synopt :{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt :{cmd:e(df_c)}}degrees of freedom for test of spatial terms{p_end}
{synopt :{cmd:e(ll)}}log likelihood{p_end}
{synopt :{cmd:e(iterations)}}number of maximum log-likelihood estimation iterations{p_end}
{synopt :{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt :{cmd:e(r2_p)}}pseudo-R-squared{p_end}
{synopt :{cmd:e(chi2)}}chi-squared{p_end}
{synopt :{cmd:e(chi2_c)}}chi-squared for test of spatial terms{p_end}
{synopt :{cmd:e(p)}}p-value for model test{p_end}
{synopt :{cmd:e(p_c)}}p-value for test of spatial terms{p_end}
{synopt :{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{p2col 5 20 22 2: Macros}{p_end}
{synopt :{cmd:e(cmd)}}{cmd:spxtregress}{p_end}
{synopt :{cmd:e(cmdline)}}command as typed{p_end}
{synopt :{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt :{cmd:e(indeps)}}names of independent variables{p_end}
{synopt :{cmd:e(idvar)}}name of ID variable{p_end}
{synopt :{cmd:e(model)}}{cmd:fe}, {cmd:re}, or {cmd:re sarpanel}{p_end}
{synopt :{cmd:e(title)}}title in estimation output{p_end}
{synopt :{cmd:e(constant)}}{cmd:hasconstant} or {cmd:noconstant} ({cmd:re} only){p_end}
{synopt :{cmd:e(dlmat)}}name of spatial weighting matrix applied to {depvar}{p_end}
{synopt :{cmd:e(elmat)}}name of spatial weighting matrix applied to errors{p_end}
{synopt :{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt :{cmd:e(vce)}}{cmd:oim}{p_end}
{synopt :{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt :{cmd:e(technique)}}maximization technique{p_end}
{synopt :{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt :{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt :{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt :{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt :{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt :{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 20 22 2: Matrices}{p_end}
{synopt :{cmd:e(b)}}coefficient vector{p_end}
{synopt :{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt :{cmd:e(gradient)}}gradient vector{p_end}
{synopt :{cmd:e(Hessian)}}Hessian matrix{p_end}
{synopt :{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{p2col 5 20 22 2: Functions}{p_end}
{synopt :{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker reference}{...}
{title:Reference}

{marker KKP2007}{...}
{phang}
Kapoor, M., H. H. Kelejian, and I. R. Prucha. 2007. Panel data models with spatially
correlated error components.  {it:Journal of Econometrics} 140: 97-130.
{p_end}
