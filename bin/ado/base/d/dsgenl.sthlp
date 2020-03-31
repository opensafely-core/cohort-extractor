{smcl}
{* *! version 1.0.0  25feb2019}{...}
{viewerdialog dsgenl "dialog dsgenl"}{...}
{vieweralsosee "[DSGE] dsgenl" "mansection DSGE dsgenl"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[DSGE] dsgenl postestimation" "help dsgenl postestimation"}{...}
{vieweralsosee "[DSGE] Intro 2" "mansection DSGE Intro2"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] sspace" "help sspace"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "[TS] var" "help var"}{...}
{viewerjumpto "Syntax" "dsgenl##syntax"}{...}
{viewerjumpto "Menu" "dsgenl##menu"}{...}
{viewerjumpto "Description" "dsgenl##description"}{...}
{viewerjumpto "Links to PDF documentation" "dsgenl##linkspdf"}{...}
{viewerjumpto "Options" "dsgenl##options"}{...}
{viewerjumpto "Examples" "dsgenl##examples"}{...}
{viewerjumpto "Stored results" "dsgenl##results"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[DSGE] dsgenl} {hline 2}}Nonlinear dynamic stochastic general
equilibrium models{p_end}
{p2col:}({mansection DSGE dsgenl:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:dsgenl}
{cmd:(}{it:lexp_1} {cmd:=} {it:rexp_1}{cmd:)}
[{cmd:(}{it:lexp_2} {cmd:=} {it:rexp_2}{cmd:)} ...]
{ifin}{cmd:,}
{opth obser:ved(varlist)}
{opt exostate(namelist)}
[{help dsgenl##optionstbl:{it:options}}]

{phang}
{it:rexp_j} and {it:lexp_j} are substitutable expressions on the right-hand
side and left-hand side of equation {it:j}.  These are Stata expressions that
include scalars, variables, and parameters to be estimated.  The variables may
be state variables, observed control variables, and unobserved control
variables.  The lead operator, {cmd:F.}, can be applied to a variable so that
{cmd:F.}{it:varname} refers to the expected value of {it:varname} in the next
time period.  No other time-series operators are allowed; see
{manlink DSGE Intro 4} for information on including additional lags and leads.
Parameters to be estimated are enclosed in curly braces;
{cmd:{c -(}beta{c )-}} is an example of a parameter.  Initial values for
parameters are given by including an equal sign and the initial value inside
the braces; for example, {cmd:{c -(}beta=2{c )-}} sets the initial value for
{cmd:beta} to 2.  See
{mansection DSGE Intro2RemarksandexamplesSpecifyingthesystemofnonlinearequations:{it:Specifying the system of nonlinear equations}}
in {bf:[DSGE] Intro 2}.


{marker optionstbl}{...}
{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{p2coldent: * {opth obser:ved(varlist)}}list of observed control
variables{p_end}
{synopt :{opt unobser:ved(namelist)}}list of unobserved control
variables{p_end}
{p2coldent: * {opt exostate(namelist)}}list of exogenous state variables{p_end}
{synopt :{opt endostate(namelist)}}list of endogenous state variables{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation_options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}
{synopt :{opt linear:approx}}take a linear, rather than log-linear,
approximation{p_end}
{synopt :{opt noid:encheck}}do not check for parameter identification{p_end}
{synopt :{opt solve}}return model solution at initial values{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {cmd:oim} or {opt r:obust}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help dsgenl##display_options:display_options}}}control
     columns and column formats and line width{p_end}

{syntab:Maximization}
{synopt :{it:{help dsgenl##maximize_options:maximize_options}}}control the
maximization process{p_end}

{syntab:Advanced}
{synopt :{opt nodem:ean}}do not demean data prior to estimation{p_end}
{synopt :{opt post}}force posting of estimation results in the event of errors
caused by lack of identification or stability{p_end}
{synopt :{opt idtol:erance(#)}}set tolerance used for identification check;
seldom used{p_end}
{synopt :{opt steadytol:erance(#)}}set tolerance used for
convergence in steady-state calculations; seldom used{p_end}
{synopt :{opt steadyinit(matrix)}}set initial values for steady state;
seldom used{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p 4 6 2}
* {opt observed()} and {opt exostate()} are required.{p_end}
{p 4 6 2}
You must {opt tsset} your data before using {opt dsgenl}; see
{manhelp tsset TS}.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp dsgenl_postestimation DSGE:dsgenl postestimation} for features
available after estimation.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate time series >}
{bf:Dynamic stochastic general equilibrium (DSGE) models >}
{bf:Nonlinear DSGE models}


{marker description}{...}
{title:Description}

{pstd}
{opt dsgenl} fits nonlinear dynamic stochastic general equilibrium
(DSGE) models to multiple time series via perturbation methods.
DSGE models are systems of equations that are motivated by
economic theory.  In these systems, expectations of future values of
variables can affect the current values.  The parameters of these
models are often directly interpretable in terms of economic theory.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection DSGE dsgenlMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth observed(varlist)} specifies which variables that appear in the model
equations are observed control variables.  {opt observed()} is required.

{phang}
{opt unobserved(namelist)} specifies which variables that appear in the model
equations are unobserved control variables.  The names must be valid Stata
names but need not exist in your dataset.

{phang}
{opt exostate(namelist)} specifies which variables that appear in the model
equations are exogenous state variables.  Exogenous state variables are
subject to shocks.  The names must be valid Stata names but need not exist in
your dataset.  There must be the same number of exogenous state variables as
there are observed control variables in your model.  {opt exostate()} is
required.

{phang}
{opt endostate(namelist)} specifies which variables that appear in the model
equations are endogenous state variables.  Endogenous state variables are not
subject to shocks.  The names must be valid Stata names but need not exist in
your dataset.

{phang}
{opt constraints(constraints)}; see
{helpb estimation options:[R] Estimation options}.

{phang}
{opt linearapprox} specifies that a linear approximation be applied to the
DSGE model rather than a log-linear approximation.  In either case, an
approximation is applied.  In a log-linear approximation, variables are
interpreted as percentage deviations from steady state.  In a linear
approximation, variables are interpreted as unit deviations from steady state.

{phang}
{opt noidencheck} skips the check that the parameters are identified at the
initial values.  Models that are not structurally identified can still
converge, thereby producing meaningless results that only appear to have
meaning; thus, care should be taken in specifying this option.
See {manlink DSGE Intro 6} for details.

{phang}
{opt solve} puts the model into state-space form at the initial parameter
values.  No standard errors are produced.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported,
which includes types that are derived from asymptotic theory ({cmd:oim})
and that are robust to some kinds of misspecification ({cmd:robust}); see
{helpb vce_option:[R] {it:vce_option}}.

{dlgtab:Reporting}

{phang}
{opt level(#)}, {opt nocnsreport}; see
{helpb estimation options:[R] Estimation options}.

{marker display_options}{...}
{phang}
{it:display_options}:
{opt noci},
{opt nopv:alues},
{opth cformat(fmt)},
{opt pformat(%fmt)},
{opt sformat(%fmt)}, and
{opt nolstretch};
see
{helpb estimation options:[R] Estimation options}.

{dlgtab:Maximization}

{marker maximize_options}{...}
{phang}
{it:maximize_options}:
{opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)},
[{cmd:no}]{opt log},
{opt tr:ace},
{opt grad:ient}, {opt showstep},
{opt hess:ian},
{opt showtol:erance},
{opt tol:erance(#)},
{opt ltol:erance(#)},
{opt nrtol:erance(#)}, and
{opt from(init_specs)}; see {helpb maximize:[R] Maximize}.

{dlgtab:Advanced}

{phang}
{opt nodemean} prevents {opt dsgenl} from removing the mean of the
observed control variables prior to estimation.

{phang}
{opt post} causes {opt dsgenl} to post the parameter vector into {opt e()},
even in the event of errors that arise from checking stability conditions or
identification.

{phang}
{opt idtolerance(#)} specifies the tolerance used in the identification
diagnostic.  The default is {cmd:idtolerance(1e-6)}.

{phang}
{opt steadytolerance(#)} specifies the tolerance used in calculations of the
model's steady state.  The default is {cmd:steadytolerance(1e-17)}.

{phang}
{opt steadyinit(matrix)} specifies a vector of initial values
for use in finding the steady state.

{pstd}
The following option is available with {cmd:dsgenl} but is not shown in
the dialog box:

{phang}
{opt coeflegend}; see
{helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse rates2}{p_end}
{phang2}{cmd:. generate p = 400*(ln(gdpdef) - ln(L.gdpdef))}{p_end}
{phang2}{cmd:. label variable p "Inflation rate"}{p_end}

{pstd}Parameter estimation{p_end}
{phang2}{cmd:. dsgenl (1 = {beta}*(x/F.x)*(1/g)*(r/F.p))}
         {cmd:(1/{phi} + (p-1) = {phi}*x + {beta}*(F.p-1))} 
         {cmd:({beta}*r = p^(1/{beta})*u)}
         {cmd:(ln(F.u) = {rhou}*ln(u))}
         {cmd:(ln(F.g) = {rhog}*ln(g)),}
         {cmd:exostate(u g) observed(p r) unobserved(x)}{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse usmacro2, clear}{p_end}
{phang2}{cmd:. constraint 1 _b[theta]=5}{p_end}
{phang2}{cmd:. constraint 2 _b[beta]=0.96}{p_end}

{pstd}Parameter estimation{p_end}
{phang2}{cmd:. dsgenl (1 = {beta}*(x/F.x)*(1/z)*(r/F.p))}
        {cmd:({theta}-1 + {phi}*(p -1)*p = {theta}*x + {phi}*{beta}*(F.p-1)*F.p)}
        {cmd:(({beta})*r = (p)^({psi=2})*m)}
        {cmd:(ln(F.m) = {rhom}*ln(m))}
        {cmd:(ln(F.z) = {rhoz}*ln(z)),}
        {cmd:exostate(z m) unobserved(x) observed(p r)}
        {cmd:constraint(1 2)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:dsgenl} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt :{cmd:e(N)}}number of observations{p_end}
{synopt :{cmd:e(k)}}number of parameters{p_end}
{synopt :{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt :{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt :{cmd:e(k_state)}}number of state equations{p_end}
{synopt :{cmd:e(k_control)}}number of control equations{p_end}
{synopt :{cmd:e(k_shock)}}number of shocks{p_end}
{synopt :{cmd:e(k_observed)}}number of observed control equations{p_end}
{synopt :{cmd:e(k_stable)}}number of stable eigenvalues{p_end}
{synopt :{cmd:e(ll)}}log likelihood{p_end}
{synopt :{cmd:e(tmin)}}minimum time in sample{p_end}
{synopt :{cmd:e(tmax)}}maximum time in sample{p_end}
{synopt :{cmd:e(rank)}}rank of VCE{p_end}
{synopt :{cmd:e(ic)}}number of iterations{p_end}
{synopt :{cmd:e(rc)}}return code{p_end}
{synopt :{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{p2col 5 20 24 2:Macros}{p_end}
{synopt :{cmd:e(cmd)}}{cmd:dsgenl}{p_end}
{synopt :{cmd:e(cmdline)}}command as typed{p_end}
{synopt :{cmd:e(depvar)}}unoperated names of dependent variables{p_end}
{synopt :{cmd:e(state)}}unoperated names of state variables{p_end}
{synopt :{cmd:e(shock)}}unoperated names of state variables subject to
shocks{p_end}
{synopt :{cmd:e(control)}}unoperated names of control variables{p_end}
{synopt :{cmd:e(observed)}}unoperated names of observed control
variables{p_end}
{synopt :{cmd:e(title)}}title in estimation output{p_end}
{synopt :{cmd:e(tvar)}}variable denoting time within groups{p_end}
{synopt :{cmd:e(tmins)}}formatted minimum time{p_end}
{synopt :{cmd:e(tmaxs)}}formatted maximum time{p_end}
{synopt :{cmd:e(tsfmt)}}format for the current time variable{p_end}
{synopt :{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt :{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt :{cmd:e(opt)}}type of optimization{p_end}
{synopt :{cmd:e(method)}}likelihood method{p_end}
{synopt :{cmd:e(idencheck)}}{cmd:passed}, {cmd:failed}, or {cmd:skipped}{p_end}
{synopt :{cmd:e(technique)}}maximization technique{p_end}
{synopt :{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt :{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt :{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt :{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}

{p2col 5 20 24 2:Matrices}{p_end}
{synopt :{cmd:e(b)}}parameter vector{p_end}
{synopt :{cmd:e(Cns)}}constraints matrix{p_end}
{synopt :{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt :{cmd:e(eigenvalues)}}generalized eigenvalues{p_end}
{synopt :{cmd:e(gradient)}}gradient vector{p_end}
{synopt :{cmd:e(shock_coeff)}}estimated shock coefficient matrix{p_end}
{synopt :{cmd:e(transition)}}estimated state transition matrix{p_end}
{synopt :{cmd:e(policy)}}estimated policy matrix{p_end}
{synopt :{cmd:e(steady)}}estimated steady-state vector{p_end}
{synopt :{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt :{cmd:e(V_modelbased)}}model-based variance{p_end}

{p2col 5 20 24 2:Functions}{p_end}
{synopt :{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
