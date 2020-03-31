{smcl}
{* *! version 1.1.7  12dec2018}{...}
{viewerdialog Sp "dialog sp"}{...}
{vieweralsosee "[SP] spregress" "mansection SP spregress"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] spregress postestimation" "help spregress postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] estat moran" "help estat moran"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[SP] spivregress" "help spivregress"}{...}
{vieweralsosee "[SP] spmatrix" "help spmatrix"}{...}
{vieweralsosee "[SP] spxtregress" "help spxtregress"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] Intro" "mansection SP Intro"}{...}
{viewerjumpto "Syntax" "spregress##syntax"}{...}
{viewerjumpto "Menu" "spregress##menu"}{...}
{viewerjumpto "Description" "spregress##description"}{...}
{viewerjumpto "Links to PDF documentation" "spregress##linkspdf"}{...}
{viewerjumpto "Options for spregress, gs2sls" "spregress##options_spregress_gs2sls"}{...}
{viewerjumpto "Options for spregress, ml" "spregress##options_spregress_ml"}{...}
{viewerjumpto "Examples" "spregress##examples"}{...}
{viewerjumpto "Stored results" "spregress##results"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[SP] spregress} {hline 2}}Spatial autoregressive models{p_end}
{p2col:}({mansection SP spregress:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Generalized spatial two-stage least squares

{p 8 14 2}
{cmd:spregress}
{depvar}
[{indepvars}]
{ifin}{cmd:,}
{cmd:gs2sls}
[{help spregress##gs2sls_options:{it:gs2sls_options}}]


{phang}
Maximum likelihood

{p 8 14 2}
{cmd:spregress}
{depvar}
[{indepvars}]
{ifin}{cmd:,}
{cmd:ml}
[{help spregress##ml_options:{it:ml_options}}]


{marker gs2sls_options}{...}
{synoptset 30 tabbed}{...}
{synopthdr:gs2sls_options}
{synoptline}
{syntab:Model}
{p2coldent :* {opt gs2sls}}use generalized spatial two-stage least-squares
estimator{p_end}
{synopt :{opt dvarl:ag(spmatname)}}spatially lagged dependent variable;
repeatable{p_end}
{synopt :{opt err:orlag(spmatname)}}spatially lagged errors; repeatable{p_end}
{synopt :{cmdab:ivarl:ag(}{it:spmatname} {cmd::} {varlist}{cmd:)}}spatially
lagged independent variables; repeatable{p_end}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opt het:eroskedastic}}treat errors as heteroskedastic{p_end}
{synopt :{opt force}}allow estimation when estimation sample is a subset of
the sample used to create the spatial weighting matrix{p_end}
{synopt :{opt impower(#)}}order of instrumental-variable approximation{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}
{synopt :{help spregress##gs2sls_display_options:{it:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Optimization}
{synopt :{help spregress##optimopts:{it:optimization_options}}}control the
optimization process; seldom used{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}


{marker ml_options}{...}
{synopthdr:ml_options}
{synoptline}
{syntab:Model}
{p2coldent:* {opt ml}}use maximum likelihood estimator{p_end}
{synopt :{opt dvarl:ag(spmatname)}}spatially lagged dependent variable; not
repeatable{p_end}
{synopt :{opt err:orlag(spmatname)}}spatially lagged errors; not
repeatable{p_end}
{synopt :{cmdab:ivarl:ag(}{it:spmatname} {cmd::} {varlist}{cmd:)}}spatially lagged
independent variables; repeatable{p_end}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opth const:raints(estimation_options##constraints():constraints)}}apply specified linear constraints{p_end}
{synopt :{opt force}}allow estimation when estimation sample is a subset of the
sample used to create the spatial weighting matrix{p_end}
{synopt :{opt grid:search(#)}}resolution of the initial-value search grid;
seldom used{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim} or {opt r:obust}
{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{help spregress##ml_display_options:{it:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt :{help spregress##maxopts:{it:maximize_options}}}control
     the maximization process; seldom used

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}


{p 4 6 2}
* You must specify either {cmd:gs2sls} or {cmd:ml}.{p_end}
{p 4 6 2}
{it:indepvars}  and {it:varlist} specified in {cmd:ivarlag()} may contain factor
variables; see {help fvvarlist}.{p_end}
{p 4 6 2}
{cmd:coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp spregress_postestimation SP:spregress postestimation} for
features available after estimation.{p_end}


INCLUDE help menu_spatial


{marker description}{...}
{title:Description}

{pstd}
{cmd:spregress} is the equivalent of
{helpb regress} for spatial data.
{cmd:spregress} fits spatial autoregressive (SAR) models, 
also known as simultaneous autoregressive models.
If you have not read {manlink SP Intro 1} - {manlink SP Intro 8},
you should do so before using {cmd:spregress}.

{pstd}
To use {cmd:spregress}, your data must be Sp data. See {manlink SP Intro 3}
for instructions on how to prepare your data.

{pstd}
To specify spatial lags, you will need to have one or more 
spatial weighting matrices. 
See {manlink SP Intro 2} and {manhelp spmatrix SP} for an explanation of the
types of weighting matrices and how to create them.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SP spregressQuickstart:Quick start}

        {mansection SP spregressRemarksandexamples:Remarks and examples}

        {mansection SP spregressMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_spregress_gs2sls}{...}
{title:Options for spregress, gs2sls}

{dlgtab:Model}

{phang}
{opt gs2sls} requests that the generalized spatial two-stage least-squares
estimator be used.

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
weighting matrix and a list of independent variables that define spatial lags
of the variables.  This option is repeatable to allow spatial lags created
from different matrices.  By default, no spatial lags of the independent
variables are included.

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

{marker gs2sls_display_options}{...}
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
The following option is available with {cmd:spregress, gs2sls} 
but is not shown in the dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker options_spregress_ml}{...}
{title:Options for spregress, ml}

{dlgtab:Model}

{phang}
{opt ml} requests that the maximum likelihood estimator be used.

{phang}
{opt dvarlag(spmatname)} specifies a spatial weighting
matrix that defines a spatial lag of the dependent variable.
Only one {cmd:dvarlag()} option may be specified.  
By default, no spatial lags of the dependent variable are included.  

{phang}
{opt errorlag(spmatname)} specifies a spatial weighting
matrix that defines a spatially lagged error. 
Only one {cmd:errorlag()} option may be specified.  
By default, no spatially lagged errors are included.

{phang}
{cmd:ivarlag(}{it:spmatname} {cmd::} {varlist}{cmd:)} specifies a 
spatial weighting matrix and a list of independent variables that define
spatial lags of the variables.  This option is repeatable to
allow spatial lags created from different matrices.  By
default, no spatial lags of the independent variables are included.

{phang}
{opt noconstant}, {opt constraints(constraints)}; see
     {helpb estimation options:[R] Estimation options}.

{phang}
{opt force} requests that estimation be done when the estimation sample is a 
proper subset of the sample used to create the spatial weighting matrices.
The default is to refuse to fit the model.
This is the same {cmd:force} option described for use with 
{cmd:spregress, gs2sls}.

{phang}
{opt gridsearch(#)} specifies the resolution of the initial-value search grid.
The default is {cmd:gridsearch(0.1)}.  You may specify any number between
0.001 and 0.1 inclusive. 

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported,
which includes types that are derived from asymptotic theory ({cmd:oim})
and that are robust to nonnormal independent and identically distributed
(i.i.d.) disturbance ({cmd:robust}).
See {manhelpi vce_option R}.

{dlgtab:Reporting}

{phang}
{opt level(#)}, {opt nocnsreport}; see
     {helpb estimation options:[R] Estimation options}.

{marker ml_display_options}{...}
INCLUDE help displayopts_list

{dlgtab:Maximization}

{marker maxopts}{...}
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
The following option is available with {cmd:spregress, ml} 
but is not shown in the dialog box:

{phang}
{cmd:coeflegend}; see 
     {helpb estimation options##coeflegend:[R] Estimation options}.


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

{pstd}Same as above but add a spatial autoregressive error term{p_end}
{phang2}{cmd:. spregress hrate ln_population ln_pdensity gini,}
                     {cmd:gs2sls dvarlag(W) errorlag(W)}

{pstd}Same as above but add terms representing spatial lags of the
independent variables{p_end}
{phang2}{cmd:. spregress hrate ln_population ln_pdensity gini,}
                     {cmd:gs2sls dvarlag(W) errorlag(W)}
		     {cmd:ivarlag(W: ln_population ln_pdensity gini)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:spregress, gs2sls} stores the following in {cmd:e()}: 

{synoptset 20 tabbed}{...}
{p2col 5 20 22 2: Scalars}{p_end}
{synopt :{cmd:e(N)}}number of observations{p_end}
{synopt :{cmd:e(k)}}number of parameters{p_end}
{synopt :{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt :{cmd:e(df_c)}}degrees of freedom for test of spatial terms{p_end}
{synopt :{cmd:e(iterations)}}number of generalized method of moments
iterations{p_end}
{synopt :{cmd:e(iterations_2sls)}}number of two-stage least-squares
iterations{p_end}
{synopt :{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt :{cmd:e(r2_p)}}pseudo-R-squared{p_end}
{synopt :{cmd:e(chi2)}}chi-squared{p_end}
{synopt :{cmd:e(chi2_c)}}chi-squared for test of spatial
terms{p_end}
{synopt :{cmd:e(p)}}p-value for model test{p_end}
{synopt :{cmd:e(p_c)}}p-value for test of spatial terms{p_end}
{synopt :{cmd:e(converged)}}{cmd:1} if generalized method of moments converged,
{cmd:0} otherwise{p_end}
{synopt :{cmd:e(converged_2sls)}}{cmd:1} if two-stage least-squares converged,
{cmd:0} otherwise{p_end}

{p2col 5 20 22 2: Macros}{p_end}
{synopt :{cmd:e(cmd)}}{cmd:spregress}{p_end}
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

{pstd}
{cmd:spregress, ml} stores the following in {cmd:e()}:

{p2col 5 20 22 2: Scalars}{p_end}
{synopt :{cmd:e(N)}}number of observations{p_end}
{synopt :{cmd:e(k)}}number of parameters{p_end}
{synopt :{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt :{cmd:e(df_c)}}degrees of freedom for test of spatial terms{p_end}
{synopt :{cmd:e(ll)}}log likelihood{p_end}
{synopt :{cmd:e(iterations)}}number of maximum log-likelihood estimation
iterations{p_end}
{synopt :{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt :{cmd:e(r2_p)}}pseudo-R-squared{p_end}
{synopt :{cmd:e(chi2)}}chi-squared{p_end}
{synopt :{cmd:e(chi2_c)}}chi-squared for test of spatial
terms{p_end}
{synopt :{cmd:e(p)}}p-value for model test{p_end}
{synopt :{cmd:e(p_c)}}p-value for test of spatial terms{p_end}
{synopt :{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{p2col 5 20 22 2: Macros}{p_end}
{synopt :{cmd:e(cmd)}}{cmd:spregress}{p_end}
{synopt :{cmd:e(cmdline)}}command as typed{p_end}
{synopt :{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt :{cmd:e(indeps)}}names of independent variables{p_end}
{synopt :{cmd:e(idvar)}}name of ID variable{p_end}
{synopt :{cmd:e(estimator)}}{cmd:ml}{p_end}
{synopt :{cmd:e(title)}}title in estimation output{p_end}
{synopt :{cmd:e(constant)}}{cmd:hasconstant} or {cmd:noconstant}{p_end}
{synopt :{cmd:e(dlmat)}}name of spatial weighting matrix applied to {depvar}{p_end}
{synopt :{cmd:e(elmat)}}name of spatial weighting matrix applied to errors{p_end}
{synopt :{cmd:e(chi2type)}}{cmd Wald}; type of model chi-squared test{p_end}
{synopt :{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt :{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt :{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt :{cmd:e(technique)}}maximization technique{p_end}
{synopt :{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt :{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt :{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt :{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt :{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt :{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt :{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 20 22 2: Matrices}{p_end}
{synopt :{cmd:e(b)}}coefficient vector{p_end}
{synopt :{cmd:e(Cns)}}constraints matrix{p_end}
{synopt :{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt :{cmd:e(gradient)}}gradient vector{p_end}
{synopt :{cmd:e(Hessian)}}Hessian matrix{p_end}
{synopt :{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{p2col 5 20 22 2: Functions}{p_end}
{synopt :{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
