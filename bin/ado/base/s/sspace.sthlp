{smcl}
{* *! version 1.0.25  22mar2019}{...}
{viewerdialog sspace "dialog sspace"}{...}
{vieweralsosee "[TS] sspace" "mansection TS sspace"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] sspace postestimation" "help sspace postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] arima" "help arima"}{...}
{vieweralsosee "[TS] dfactor" "help dfactor"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "[TS] ucm" "help ucm"}{...}
{vieweralsosee "[TS] var" "help var"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[DSGE]" "mansection DSGE dsge"}{...}
{viewerjumpto "Syntax" "sspace##syntax"}{...}
{viewerjumpto "Menu" "sspace##menu"}{...}
{viewerjumpto "Description" "sspace##description"}{...}
{viewerjumpto "Links to PDF documentation" "sspace##linkspdf"}{...}
{viewerjumpto "Options" "sspace##options"}{...}
{viewerjumpto "Examples" "sspace##examples"}{...}
{viewerjumpto "Stored results" "sspace##results"}{...}
{viewerjumpto "References" "sspace##references"}{...}
{p2colset 1 16 20 2}{...}
{p2col:{bf:[TS] sspace} {hline 2}}State-space models{p_end}
{p2col:}({mansection TS sspace:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Covariance-form syntax

{p 8 15 2}
{cmd:sspace}
{it:state_ceq}
[{it:state_ceq} ... {it:state_ceq}]
{it:obs_ceq} [{it:obs_ceq} ... {it:obs_ceq}]
{ifin} 
[{cmd:,} {it:{help sspace##options_table:options}}]

{pstd}
where each {it:state_ceq} is of the form

{phang2}
{cmd:(}{it:statevar} 
	[{it:lagged_statevars}] [{indepvars}]{cmd:, state}
        [{opt noerr:or} {opt nocons:tant}]{cmd:)}

{pstd}
and each {it:obs_ceq} is of the form

{phang2}
{cmd:(}{depvar}
        [{it:statevars}] [{indepvars}]
	[{cmd:,} {opt noerr:or} {opt nocons:tant}]{cmd:)}


{pstd}
Error-form syntax

{p 8 15 2}
{cmd:sspace}
{it:state_efeq} [{it:state_efeq} ... {it:state_efeq}]
{it:obs_efeq} [{it:obs_efeq} ... {it:obs_efeq}]
{ifin}
[{cmd:,} {it:{help sspace##options_table:options}}]

{pstd}
where each {it:state_efeq} is of the form

{phang2}
     {cmd:(}{it:statevar} 
     [{it:lagged_statevars}] [{indepvars}]
     [{it:state_errors}]{cmd:,} {cmd:state}
	[{opt nocons:tant}]{cmd:)}

{pstd}
and each {it:obs_efeq} is of the form

{phang2}
      {cmd:(}{depvar} 
      [{it:statevars}] [{indepvars}]
      [{it:obs_errors}]
      [{cmd:,} {opt nocons:tant}]{cmd:)}

{phang}
{it:statevar} is the name of an unobserved state, not a variable.  If
there happens to be a variable of the same name, the variable is ignored and
plays no role in the estimation.

{phang}
{it:lagged_statevars} is a list of lagged {it:statevar}s. Only first
lags are allowed.

{phang}
{it:state_errors} is a list of state-equation errors that enter a state
equation.  Each state error has the form {cmd:e.}{it:statevar}, where
{it:statevar} is the name of a state in the model.

{phang}
{it:obs_errors} is a list of observation-equation errors that enter an
equation for an observed variable.  Each error has the form
{cmd:e.}{depvar}, where {it:depvar} is an observed dependent variable in
the model.

{synoptset 26 tabbed}{...}
{synopthdr :equation-level options}
{synoptline}
{syntab:Model}
{synopt :{opt state}}specifies that the equation is a state equation{p_end}
{synopt :{opt noerr:or}}specifies that there is no error term in the 
	equation{p_end}
{synopt :{opt nocons:tant}}suppresses the constant term from the equation{p_end}
{synoptline}

{marker options_table}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opth covst:ate(sspace##covform:covform)}}specifies the covariance
          structure for the errors in the state variables{p_end}
{synopt :{opth covob:served(sspace##covform:covform)}}specifies the covariance
           structure for the errors in the observed dependent variables{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim}
	or {opt r:obust}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help sspace##display_options:display_options}}}control
INCLUDE help shortdes-displayopt

{syntab:Maximization}
{synopt :{it:{help sspace##maximize_options:maximize_options}}}control the
           maximization process; seldom used{p_end}

{syntab:Advanced}
{synopt :{opth meth:od(sspace##method:method)}}specify the method for
        calculating the log likelihood; seldom used{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{marker covform}{...}
{synoptset 26 }{...}
{synopthdr:covform}
{synoptline}
{synopt: {opt id:entity}}identity matrix; the default for 
	error-form syntax{p_end}
{synopt: {opt ds:calar}}diagonal scalar matrix{p_end}
{synopt: {opt di:agonal}}diagonal matrix; the default for 
	covariance-form syntax{p_end}
{synopt: {opt un:structured}}symmetric, positive-definite matrix; 
        not allowed with error-form syntax{p_end}
{synoptline}

{marker method}{...}
{synopthdr:method}
{synoptline}
{synopt:{opt hyb:rid}}use the stationary Kalman filter and the
	De Jong diffuse Kalman filter; the default{p_end}
{synopt: {opt dej:ong}}use the stationary De Jong Kalman filter and the
        De Jong diffuse Kalman filter{p_end}
{synopt: {opt kdif:fuse}}use the stationary Kalman filter and 
	the nonstationary large-kappa diffuse Kalman filter; seldom used{p_end}
{synoptline}

{p 4 6 2}You must {opt tsset} your data before using {opt sspace}; see
{manhelp tsset TS}.{p_end}
{p 4 6 2}{it:indepvars} may contain factor variables; see {help fvvarlist}.
{p_end}
{p 4 6 2}{it:indepvars} and {it:depvar} may contain time-series operators;
      see {help tsvarlist}.{p_end}
{p 4 6 2}{cmd:by}, {cmd:rolling}, and {cmd:statsby} are allowed; see
      {help prefix}.{p_end}
{p 4 6 2}{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp sspace_postestimation TS:sspace postestimation} for
      features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate time series > State-space models}


{marker description}{...}
{title:Description}

{pstd}
{opt sspace} estimates the parameters of linear state-space models by
maximum likelihood.  Linear state-space models are very flexible and many
linear time-series models can be written as linear state-space models.

{pstd}
{opt sspace} uses two forms of the Kalman filter to recursively obtain
conditional means and variances of both the unobserved states and the
measured dependent variables that are used to compute the likelihood.

{pstd}
The covariance-form syntax and the error-form syntax of {opt sspace} reflect
the two different forms in which researchers specify state-space models.
Choose the syntax that is easier for you; the two forms are isomorphic.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS sspaceQuickstart:Quick start}

        {mansection TS sspaceRemarksandexamples:Remarks and examples}

        {mansection TS sspaceMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

    {title:Equation-level options}

{dlgtab:Model}

{phang}
{opt state} specifies that the equation is a state equation.

{phang}
{opt noerror} specifies that there is no error term in the 
	equation.  {opt noerror} may not be specified in the error-form
	syntax.

{phang}
{opt noconstant} suppresses the constant term from the equation.

    {title:Options}

{dlgtab:Model}

{phang}
{opt covstate(covform)} specifies the covariance structure for the
state errors.

{phang2}
{cmd:covstate(identity)} specifies a covariance matrix equal to an identity
matrix, and it is the default for the error-form syntax.  

{phang2}
{cmd:covstate(dscalar)} specifies a covariance matrix equal to
sigma_{state}^2 times an identity matrix.  

{phang2}
{cmd:covstate(diagonal)} specifies a diagonal covariance matrix, and it is
the default for the covariance-form syntax.  

{phang2}
{cmd:covstate(unstructured)} specifies a symmetric, positive-definite
covariance matrix with parameters for all variances and covariances.
{cmd:covstate(unstructured)} may not be specified with the error-form syntax.

{phang}
{opt covobserved(covform)} specifies the covariance structure for the
observation errors.  

{phang2}
{cmd:covobserved(identity)} specifies a covariance matrix equal to
an identity matrix, and it is the default for the error-form syntax.  

{phang2}
{cmd:covobserved(dscalar)} specifies a covariance matrix equal to
sigma_{observed}^2 times an identity matrix.  

{phang2}
{cmd:covobserved(diagonal)} specifies a diagonal covariance matrix, and it is
the default for the covariance-form syntax.  

{phang2}
{cmd:covobserved(unstructured)} specifies a symmetric, positive-definite
covariance matrix with parameters for all variances and covariances.
{cmd:covobserved(unstructured)} may not be specified with the error-form
syntax.

{phang}
{opt constraints(constraints)}; see 
{helpb estimation options##constraints():[R] Estimation options}.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the estimator for the
variance-covariance matrix of the estimator.  

{phang2}
{cmd:vce(oim)}, the default, causes {cmd:sspace} to use the observed
information matrix estimator.

{phang2}
{cmd:vce(robust)} causes {cmd:sspace} to use the Huber/White/sandwich
estimator.

{dlgtab:Reporting}

{phang}
{opt level(#)}, {opt nocnsreport}; see
{helpb estimation options##level():[R] Estimation options}.

INCLUDE help displayopts_listb

{marker maximize_options}{...}
{dlgtab:Maximization}

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
{opt from(matname)}; 
see {helpb maximize:[R] Maximize} for all options except {opt from()}, and see
below for information on {opt from()}.  These options are seldom used.

{phang2}
{opt from(matname)} specifies initial values for the maximization
process.  {cmd:from(b0)} causes {cmd:sspace} to begin the maximization
algorithm with the values in {cmd:b0}.  {cmd:b0} must be a row vector; the
number of columns must equal the number of parameters in the model; and the
values in {cmd:b0} must be in the same order as the parameters in {cmd:e(b)}.

{dlgtab:Advanced}

{phang}
{opt method(method)} specifies how to compute the log likelihood.  This
option is seldom used.

{phang2}
{cmd:method(hybrid)}, the default, uses the Kalman filter with model-based
initial values for the states when the model is stationary and uses the 
De Jong ({help sspace##D1988:1988}, {help sspace##D1991:1991})
diffuse Kalman filter when the model is nonstationary.

{phang2}
{cmd:method(dejong)} uses the Kalman filter with the 
{help sspace##D1988:De Jong (1988)} method
for estimating the initial values for the states when the model is stationary
and uses the De Jong ({help sspace##D1988:1988}, {help sspace##D1991:1991})
diffuse Kalman filter when the model is nonstationary.

{phang2}
{cmd:method(kdiffuse)} is a seldom used method that uses the Kalman filter
with model-based initial values for the states when the model is stationary
and uses the large-kappa diffuse Kalman filter when the model is
nonstationary.

{pstd}
The following option is available with {cmd:sspace} but is not shown in
the dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse manufac}{p_end}
{phang2}{cmd:. constraint 1 [D.lncaputil]u = 1}{p_end}

{pstd}Fit an AR(1) model to changes in {cmd:lncaputil}{p_end}
{phang2}{cmd:. sspace  (u L.u, state noconstant) (D.lncaputil u,  noerror), constraints(1)}{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:. constraint 2 [u1]L.u2 = 1}{p_end}
{phang2}{cmd:. constraint 3 [u1]e.u1 = 1}{p_end}
{phang2}{cmd:. constraint 4 [D.lncaputil]u1 = 1}{p_end}

{pstd}Fit an ARMA(1,1) model to changes in {cmd:lncaputil}{p_end}
{phang2}{cmd:. sspace (u1 L.u1 L.u2 e.u1, state noconstant)}
 {cmd:(u2 e.u1, state noconstant)}
 {cmd:(D.lncaputil u1, noconstant), constraints(2/4) covstate(diagonal)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:sspace} stores the following in {cmd:e()}:

{synoptset 23 tabbed}{...}
{p2col 5 23 27 2: Scalars}{p_end}
{synopt :{cmd:e(N)}}number of observations{p_end}
{synopt :{cmd:e(k)}}number of parameters{p_end}
{synopt :{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt :{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt :{cmd:e(k_obser)}}number of observation equations{p_end}
{synopt :{cmd:e(k_state)}}number of state equations{p_end}
{synopt :{cmd:e(k_obser_err)}}number of observation-error terms{p_end}
{synopt :{cmd:e(k_state_err)}}number of state-error terms{p_end}
{synopt :{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt :{cmd:e(ll)}}log likelihood{p_end}
{synopt :{cmd:e(chi2)}}chi-squared{p_end}
{synopt :{cmd:e(p)}}p-value for model test{p_end}
{synopt :{cmd:e(tmin)}}minimum time in sample{p_end}
{synopt :{cmd:e(tmax)}}maximum time in sample{p_end}
{synopt :{cmd:e(stationary)}}{cmd:1} if the estimated parameters indicate a stationary model, {cmd:0} otherwise{p_end}
{synopt :{cmd:e(rank)}}rank of VCE{p_end}
{synopt :{cmd:e(ic)}}number of iterations{p_end}
{synopt :{cmd:e(rc)}}return code{p_end}
{synopt :{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{p2col 5 23 27 2:Macros}{p_end}
{synopt :{cmd:e(cmd)}}{opt sspace}{p_end}
{synopt :{cmd:e(cmdline)}}command as typed{p_end}
{synopt :{cmd:e(depvar)}}unoperated names of dependent variables in observation equations{p_end}
{synopt :{cmd:e(obser_deps)}}names of dependent variables in observation equations{p_end}
{synopt :{cmd:e(state_deps)}}names of dependent variables in state equations{p_end}
{synopt :{cmd:e(covariates)}}list of covariates{p_end}
{synopt :{cmd:e(tvar)}}variable denoting time within groups{p_end}
{synopt :{cmd:e(eqnames)}}names of equations{p_end}
{synopt :{cmd:e(title)}}title in estimation output{p_end}
{synopt :{cmd:e(tmins)}}formatted minimum time{p_end}
{synopt :{cmd:e(tmaxs)}}formatted maximum time{p_end}
{synopt :{cmd:e(R_structure)}}structure of observed-variable-error covariance matrix{p_end}
{synopt :{cmd:e(Q_structure)}}structure of state-error covariance matrix{p_end}
{synopt :{cmd:e(chi2type)}}{opt Wald}; type of model chi-squared test{p_end}
{synopt :{cmd:e(vce)}}{it:vcetype} specified in {opt vce()}{p_end}
{synopt :{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt :{cmd:e(opt)}}type of optimization{p_end}
{synopt :{cmd:e(method)}}likelihood method{p_end}
{synopt :{cmd:e(initial_values)}}type of initial values{p_end}
{synopt :{cmd:e(technique)}}maximization technique{p_end}
{synopt :{cmd:e(tech_steps)}}iterations taken in maximization technique{p_end}
{synopt :{cmd:e(datasignature)}}the checksum{p_end}
{synopt :{cmd:e(datasignaturevars)}}variables used in calculation of checksum{p_end}
{synopt :{cmd:e(properties)}}{opt b V}{p_end}
{synopt :{cmd:e(estat_cmd)}}program used to implement {opt estat}{p_end}
{synopt :{cmd:e(predict)}}program used to implement {opt predict}{p_end}
{synopt :{cmd:e(marginsnotok)}}predictions disallowed by {opt margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 23 27 2:Matrices}{p_end}
{synopt :{cmd:e(b)}}parameter vector{p_end}
{synopt :{cmd:e(Cns)}}constraints matrix{p_end}
{synopt :{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt :{cmd:e(gradient)}}gradient vector{p_end}
{synopt :{cmd:e(gamma)}}mapping from parameter vector to state-space matrices{p_end}
{synopt :{cmd:e(A)}}estimated {cmd:A} matrix{p_end}
{synopt :{cmd:e(B)}}estimated {cmd:B} matrix{p_end}
{synopt :{cmd:e(C)}}estimated {cmd:C} matrix{p_end}
{synopt :{cmd:e(D)}}estimated {cmd:D} matrix{p_end}
{synopt :{cmd:e(F)}}estimated {cmd:F} matrix{p_end}
{synopt :{cmd:e(G)}}estimated {cmd:G} matrix{p_end}
{synopt :{cmd:e(chol_R)}}Cholesky factor of estimated {cmd:R} matrix{p_end}
{synopt :{cmd:e(chol_Q)}}Cholesky factor of estimated {cmd:Q} matrix{p_end}
{synopt :{cmd:e(chol_Sz0)}}Cholesky factor of initial state covariance matrix{p_end}
{synopt :{cmd:e(z0)}}initial state vector augmented with a matrix identifying nonstationary components{p_end}
{synopt :{cmd:e(d)}}additional term in diffuse initial state vector, 
	if nonstationary model{p_end}
{synopt :{cmd:e(T)}}inner part of quadratic form for initial state 
	covariance in a partially nonstationary model{p_end}
{synopt :{cmd:e(M)}}outer part of quadratic form for initial state 
	covariance in a partially
	nonstationary model{p_end}
{synopt :{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt :{cmd:e(V_modelbased)}}model-based variance{p_end}

{p2col 5 23 27 2:Functions}{p_end}
{synopt :{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker D1988}{...}
{phang}
De Jong, P.  1988.  The likelihood for a state space model.
{it:Biometrika} 75: 165-169.

{marker D1991}{...}
{phang}
------.  1991.  The diffuse Kalman filter.
{it:Annals of Statistics} 19: 1073-1083.
{p_end}
