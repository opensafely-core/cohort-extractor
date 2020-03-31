{smcl}
{* *! version 1.0.29  22mar2019}{...}
{viewerdialog dfactor "dialog dfactor"}{...}
{vieweralsosee "[TS] dfactor" "mansection TS dfactor"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] dfactor postestimation" "help dfactor postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] arima" "help arima"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[TS] sspace" "help sspace"}{...}
{vieweralsosee "[R] sureg" "help sureg"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "[TS] var" "help var"}{...}
{viewerjumpto "Syntax" "dfactor##syntax"}{...}
{viewerjumpto "Menu" "dfactor##menu"}{...}
{viewerjumpto "Description" "dfactor##description"}{...}
{viewerjumpto "Links to PDF documentation" "dfactor##linkspdf"}{...}
{viewerjumpto "Options" "dfactor##options"}{...}
{viewerjumpto "Examples" "dfactor##examples"}{...}
{viewerjumpto "Stored results" "dfactor##results"}{...}
{viewerjumpto "References" "dfactor##references"}{...}
{p2colset 1 17 21 2}{...}
{p2col:{bf:[TS] dfactor} {hline 2}}Dynamic-factor models{p_end}
{p2col:}({mansection TS dfactor:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:dfactor} {it:obs_eq} [{it:fac_eq}]
{ifin}
[{cmd:,} {help dfactor##table_options:{it:options}}]

{phang}
{it:obs_eq} specifies the equation for the observed dependent variables,
and it has the form

{phang2}
        {cmd:(}{it:depvars} {cmd:=} [{it:exog_d}] [{cmd:,}
         {it:{help dfactor##sopts:sopts}}]{cmd:)}

{phang}
{it:fac_eq} specifies the equation for the unobserved factors, and it
has the form

{phang2}
        {cmd:(}{it:facvars} {cmd:=} [{it:exog_f}] [{cmd:,}
         {it:{help dfactor##sopts:sopts}}]{cmd:)}

{phang}
{it:depvars} are the observed dependent variables. {it:exog_d} are the
exogenous variables that enter into the equations for the observed dependent
variables. (All factors are automatically entered into the equations for the
observed dependent variables.)  {it:facvars} are the names for the
unobserved factors in the model. You may specify the names of existing
variables in {it:facvars}, but {cmd:dfactor} treats them only as names
and takes no notice that they are also variables. {it:exog_f} are the
exogenous variables that enter into the equations for the factors.

{marker table_options}{...}
{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt const:raints(constraints)}}apply specified linear constraints{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim}
	or {opt r:obust}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help dfactor##display_options:display_options}}}control
INCLUDE help shortdes-displayopt

{syntab:Maximization}
{synopt :{it:{help dfactor##maximize_options:maximize_options}}}control the
           maximization process; seldom used{p_end}
{synopt :{opt from(matname)}}specify initial values for the 
    	   maximization process; seldom used{p_end}

{syntab:Advanced}
{synopt :{cmdab:meth:od(}{it:{help dfactor##method:method}}{cmd:)}}specify the
           method for calculating the log likelihood; seldom used{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{marker sopts}{...}
{synoptset 27 tabbed}{...}
{synopthdr:sopts}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term from the equation; allowed
       only in {it:obs_eq}{p_end}
{synopt :{opth ar(numlist)}}autoregressive terms{p_end}
{synopt :{cmdab:ars:tructure(}{it:{help dfactor##arstructure:arstructure}}{cmd:)}}structure of autoregressive coefficient matrices{p_end}
{synopt :{cmdab:covs:tructure(}{it:{help dfactor##covstructure:covstructure}}{cmd:)}}covariance structure{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 27}{...}
{marker arstructure}{...}
{synopthdr:arstructure}
{synoptline}
{synopt :{opt di:agonal}}diagonal matrix; the default{p_end}
{synopt :{opt lt:riangular}}lower triangular matrix{p_end}
{synopt :{opt ge:neral}}general matrix{p_end}
{synoptline}

{marker covstructure}{...}
{synopthdr:covstructure}
{synoptline}
{synopt :{opt id:entity}}identity matrix{p_end}
{synopt :{opt ds:calar}}diagonal scalar matrix{p_end}
{synopt :{opt di:agonal}}diagonal matrix{p_end}
{synopt :{opt un:structured}}symmetric, positive-definite matrix{p_end}
{synoptline}

{marker method}{...}
{synopthdr:method}
{synoptline}
{synopt:{opt hyb:rid}}use the stationary Kalman filter and the
	De Jong diffuse Kalman filter; the default{p_end}
{synopt:{opt dej:ong}}use the stationary De Jong method and the
        De Jong diffuse Kalman filter{p_end}
{synoptline}

{p 4 6 2}You must {opt tsset} your data before using {opt dfactor}; see
     {manhelp tsset TS}.{p_end}
{p 4 6 2}{it:exog_d} and {it:exog_f} may contain factor variables; see
     {help fvvarlist}.{p_end}
{p 4 6 2}{it:depvars}, {it:exog_d}, and {it:exog_f} may contain time-series
     operators; see {help tsvarlist}.{p_end}
{p 4 6 2}{opt by}, {opt fp}, {opt rolling}, and {opt statsby} are allowed; see
     {help prefix}.{p_end}
{p 4 6 2}{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp dfactor_postestimation TS:dfactor postestimation} for
      features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate time series > Dynamic-factor models}


{marker description}{...}
{title:Description}

{pstd}
{opt dfactor} estimates the parameters of dynamic-factor models by maximum
likelihood.  Dynamic-factor models are flexible models for multivariate time
series in which unobserved factors have a vector autoregressive structure,
exogenous covariates are permitted in both the equations for the latent
factors and the equations for observable dependent variables, and the
disturbances in the equations for the dependent variables may be
autocorrelated.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS dfactorQuickstart:Quick start}

        {mansection TS dfactorRemarksandexamples:Remarks and examples}

        {mansection TS dfactorMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt constraints(constraints)} apply linear constraints.  Some
specifications require linear constraints for parameter identification.

{phang}
{opt noconstant} suppresses the constant term.

{phang}
{opth ar(numlist)} specifies the vector autoregressive lag structure
in the equation.  By default, no lags are included in either the observable
or the factor equations.

{phang}
{cmd:arstructure(diagonal}{c |}{cmd:ltriangular}{c |}{cmd:general}{cmd:)}
specifies the structure of the matrices in the vector autoregressive lag
structure.

{phang2}
{cmd:arstructure(diagonal)} specifies the matrices to be
diagonal -- separate parameters for each lag, but no cross-equation
autocorrelations.  {cmd:arstructure(diagonal)} is the default for 
both the observable and the factor equations.

{phang2}
{cmd:arstructure(ltriangular)} specifies the matrices to be lower
triangular -- parameterizes a recursive, or Wold causal, structure.

{phang2}
{cmd:arstructure(general)} specifies the matrices to be general
matrices -- separate parameters for each possible autocorrelation and
cross-correlation.

{phang}
{cmd:covstructure(identity}{c |}{cmd:dscalar}{c |}{cmd:diagonal}{c |}{cmd:unstructured)}
specifies the covariance structure of the errors.

{phang2}
{cmd:covstructure(identity)} specifies a covariance matrix equal to an
identity matrix, and it is the default for the errors in the factor
equations.

{phang2}
{cmd:covstructure(dscalar)} specifies a covariance matrix equal to
sigma^2 times an identity matrix.  

{phang2}
{cmd:covstructure(diagonal)} specifies a diagonal covariance matrix, and it
is the default for the errors in the observable variables.

{phang2}
{cmd:covstructure(unstructured)} specifies a symmetric, positive-definite
covariance matrix with parameters for all variances and covariances.  

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the estimator for the
variance-covariance matrix of the estimator.  

{phang2}
{cmd:vce(oim)}, the default, causes {cmd:dfactor} to use the observed
information matrix estimator.

{phang2}
{cmd:vce(robust)} causes {cmd:dfactor} to use the Huber/White/sandwich
estimator.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see 
{helpb estimation options##level():[R] Estimation options}.

{phang}
{cmd:nocnsreport}; see
{helpb estimation options##nocnsreport:[R] Estimation options}.

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
see {helpb maximize:[R] Maximize} for all options except {cmd:from()}, and see
below for information on {cmd:from()}.  These options are seldom used.

{phang2}
{opt from(matname)} specifies initial values for the maximization
process.  {cmd:from(b0)} causes {cmd:dfactor} to begin the maximization
algorithm with the values in {cmd:b0}.  {cmd:b0} must be a row vector; the
number of columns must equal the number of parameters in the model; and the
values in {cmd:b0} must be in the same order as the parameters in {cmd:e(b)}.
This option is seldom used.

{dlgtab:Advanced}

{phang}
{opt method(method)} specifies how to compute the log likelihood. 
{opt dfactor} writes the model in state-space form and uses {helpb sspace} to
estimate the parameters.  {opt method()} offers two methods for dealing
with some of the technical aspects of the state-space likelihood.  This option
is seldom used.

{phang2}
{cmd:method(hybrid)}, the default, uses the Kalman filter with model-based
initial values when the model is stationary and uses the 
De Jong ({help dfactor##DJ1988:1988}, {help dfactor##DJ1991:1991})
diffuse Kalman filter when the model is nonstationary.  

{phang2}
{cmd:method(dejong)} uses the De Jong ({help dfactor##DJ1988:1988}) method for
estimating the initial values for the Kalman filter when the model is
stationary and uses the
De Jong ({help dfactor##DJ1988:1988}, {help dfactor##DJ1991:1991})
diffuse Kalman filter when the model is nonstationary.

{pstd}
The following option is available with {opt dfactor} but is not shown in
the dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse dfex}{p_end}

{pstd}Fit a dynamic-factor model in which first differences of {cmd:ipman},
{cmd:income}, {cmd:hours}, and {cmd:unemp} depend on an unobserved factor
that follows an AR(2) process{p_end}
{phang2}{cmd:. dfactor (D.(ipman income hours unemp) = , noconstant)}
               {cmd:(f = , ar(1/2))}

{pstd}Same as above, but allowing the errors in the four observables' 
equations to be autocorrelated{p_end}
{phang2}{cmd:. dfactor (D.(ipman income hours unemp) = , noconstant ar(1))}
               {cmd:(f = , ar(1/2))}

{pstd}Fit a dynamic-factor model with an unstructured error covariance matrix,
constraining the error covariance for the {cmd:unemp} and {cmd:income}
equations to zero{p_end}
{phang2}{cmd:. constraint 1 [cov(De.unemp,De.income)]_cons  = 0}{p_end}
{phang2}{cmd:. dfactor (D.(ipman income unemp) = LD.(ipman income), noconstant}
                {cmd:covstructure(unstructured)), constraints(1)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:dfactor} stores the following in {cmd:e()}:

{synoptset 23 tabbed}{...}
{p2col 5 23 27 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(k_obser)}}number of observation equations{p_end}
{synopt:{cmd:e(k_factor)}}number of factors specified{p_end}
{synopt:{cmd:e(o_ar_max)}}number of AR terms for the disturbances{p_end}
{synopt:{cmd:e(f_ar_max)}}number of AR terms for the factors{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(tmin)}}minimum time in sample{p_end}
{synopt:{cmd:e(tmax)}}maximum time in sample{p_end}
{synopt:{cmd:e(stationary)}}{cmd:1} if the estimated parameters indicate a stationary model, {cmd:0} otherwise{p_end}
{synopt:{cmd:e(rank)}}rank of VCE{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{opt 1} if converged, {opt 0} otherwise{p_end}

{p2col 5 23 27 2:Macros}{p_end}
{synopt:{cmd:e(cmd)}}{opt dfactor}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}unoperated names of dependent variables in observation equations{p_end}
{synopt:{cmd:e(obser_deps)}}names of dependent variables in observation equations{p_end}
{synopt:{cmd:e(covariates)}}list of covariates{p_end}
{synopt:{cmd:e(factor_deps)}}names of unobserved factors in model{p_end}
{synopt:{cmd:e(tvar)}}variable denoting time within groups{p_end}
{synopt:{cmd:e(eqnames)}}names of equations{p_end}
{synopt:{cmd:e(model)}}type of dynamic-factor model specified{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(tmins)}}formatted minimum time{p_end}
{synopt:{cmd:e(tmaxs)}}formatted maximum time{p_end}
{synopt:{cmd:e(o_ar)}}list of AR terms for disturbances{p_end}
{synopt:{cmd:e(f_ar)}}list of AR terms for factors{p_end}
{synopt:{cmd:e(observ_cov)}}structure of observation-error covariance matrix{p_end}
{synopt:{cmd:e(factor_cov)}}structure of factor-error covariance matrix{p_end}
{synopt:{cmd:e(chi2type)}}{opt Wald}; type of model chi-squared test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {opt vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(method)}}likelihood method{p_end}
{synopt:{cmd:e(initial_values)}}type of initial values{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(tech_steps)}}iterations taken in maximization technique(s){p_end}
{synopt:{cmd:e(datasignature)}}the checksum{p_end}
{synopt:{cmd:e(datasignaturevars)}}variables used in calculation of checksum{p_end}
{synopt:{cmd:e(properties)}}{opt b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {opt estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {opt predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {opt margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 23 27 2:Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{p2col 5 23 27 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker DJ1988}{...}
{phang}
De Jong, P.  1988.  The likelihood for a state space model.
{it:Biometrika} 75: 165-169.

{marker DJ1991}{...}
{phang}
------.  1991.  The diffuse Kalman filter.
{it:Annals of Statistics} 19: 1073-1083.
{p_end}
