{smcl}
{* *! version 1.0.7  25feb2019}{...}
{viewerdialog dsge "dialog dsge"}{...}
{vieweralsosee "[DSGE] dsge" "mansection DSGE dsge"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[DSGE] dsge postestimation" "help dsge postestimation"}{...}
{vieweralsosee "[DSGE] Intro 2" "mansection DSGE Intro2"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] sspace" "help sspace"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "[TS] var" "help var"}{...}
{viewerjumpto "Syntax" "dsge##syntax"}{...}
{viewerjumpto "Menu" "dsge##menu"}{...}
{viewerjumpto "Description" "dsge##description"}{...}
{viewerjumpto "Links to PDF documentation" "dsge##linkspdf"}{...}
{viewerjumpto "Options" "dsge##options"}{...}
{viewerjumpto "Examples" "dsge##examples"}{...}
{viewerjumpto "Stored results" "dsge##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[DSGE] dsge} {hline 2}}Linear dynamic stochastic general
equilibrium models{p_end}
{p2col:}({mansection DSGE dsge:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:dsge}
{help dsge##eqlist:{it:eqlist}} 
{ifin}
[{cmd:,} {it:options}]

{marker options}{...}
{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}
{synopt :{opt noid:encheck}}do not check for parameter identification{p_end}
{synopt :{opt solve}}return model solution at initial values{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {cmd:oim} or {opt r:obust}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help dsge##display_options:display_options}}}control
columns and column formats and line width{p_end}

{syntab:Maximization}
{synopt :{it:{help dsge##maximize_options:maximize_options}}}control the
maximization process{p_end}

{syntab:Advanced}
{synopt :{opt nodem:ean}}do not demean data prior to estimation{p_end}
{synopt :{opt post}}force posting of estimation results in the event of errors
caused by lack of identification or stability{p_end}
{synopt :{opt idtol:erance(#)}}set tolerance used for identification check;
seldom used{p_end}
{synopt :{opt lintol:erance(#)}}set tolerance used for linearity check;
seldom used{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p 4 6 2}
You must {cmd:tsset} your data before using {cmd:dsge}; see
{manhelp tsset TS}.{p_end}
{p 4 6 2}
{cmd:coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp dsge_postestimation DSGE:dsge postestimation} for features
available after estimation.

{pstd}
Below we present the full specification of {it:eqlist}.  You may prefer
to start with the syntax discussion in {manlink DSGE Intro 2}.

{marker eqlist}{...}
{pstd}
{it:eqlist} is{p_end}
{pmore2}{it:eq}{p_end}
{pmore2}{it:eq eqlist}{p_end}

{pstd}
{it:eq} is{p_end}
{pmore2}{it:cntrl_eq}{p_end}
{pmore2}{it:state_eq}{p_end}

{pstd}
{it:cntrl_eq} contains{p_end}
{pmore2}{cmd:(}{it:ocntrl_var} {cmd:=} {it:termlist}{cmd:)}{p_end}
{pmore2}{cmd:(}{it:ucntrl_var} {cmd:=} {it:termlist}{cmd:, unobserved)}{p_end}
{pmore2}{cmd:(}{it:parm_exp} {cmd:*} {it:ocntrl_var} {cmd:=} {it:termlist}{cmd:)}{p_end}
{pmore2}{cmd:(}{it:parm_exp} {cmd:*} {it:ucntrl_var} {cmd:=} {it:termlist}{cmd:, unobserved)}{p_end}

{pstd}
{it:state_eq} contains{p_end}
{pmore2}{cmd:(F.}{it:state_var} {cmd:= , state)}{p_end}
{pmore2}{cmd:(F.}{it:state_var} {cmd:=} {it:termlist}{cmd:, state} [{cmd:noshock}]{cmd:)}{p_end}
{pmore2}{cmd:(}{it:parm_exp} {cmd:*} {cmd:F.}{it:state_var} {cmd:=}
{it:termlist}{cmd:, state} [{cmd:noshock}]{cmd:)}{p_end}

{pstd}
{it:ocntrl_var} is{p_end}
{pmore2}Stata variable to be treated as an observed control in the
system{p_end}

{pstd}
{it:ucntrl_var} is{p_end}
{pmore2}name to be treated as an unobserved control in the system{p_end}

{pstd}
{it:state_var} is{p_end}
{pmore2}name to be treated as an unobserved state in the system{p_end}

{pmore}
If there happens to be a Stata variable with the same name as
{it:ucntrl_var} or {it:state_var}, the variable is ignored and plays
no role in the estimation.

{pstd}
{it:termlist} is{p_end}
{pmore2}{it:term}{p_end}
{pmore2}{it:term} {cmd:+} {it:termlist}{p_end}
{pmore2}{it:term} {cmd:-} {it:termlist}{p_end}

{pstd}
{it:term} is{p_end}
{pmore2}{it:rhs_var}{p_end}
{pmore2}{it:parm_exp} {cmd:*} {it:rhs_var}{p_end}
{pmore2}{it:parm_exp} {cmd:*} {cmd:(}{it:termlist}{cmd:)}{p_end}

{pstd}
{it:rhs_var} is{p_end}
{pmore2}{it:ocntrl_var}{p_end}
{pmore2}{it:ucntrl_var}{p_end}
{pmore2}{it:state_var}{p_end}
{pmore2}{cmd:F.}{it:ocntrl_var}{p_end}
{pmore2}{cmd:F.}{it:ucntrl_var}{p_end}

{pstd}
{it:parm_exp} is{p_end}
{pmore2}scalar substitutable expression;{p_end}
{pmore2}{it:parm_spec} elements are allowed and expected{p_end}
{pmore2}{it:rhs_var} are not allowed{p_end}

{pstd}
{it:parm_spec} is{p_end}
{pmore2}{cmd:{c -(}}{it:parm_name}{cmd:{c )-}}{p_end}
{pmore2}{cmd:{c -(}}{it:parm_name}{cmd:=}{it:initial_val}{cmd:{c )-}}{p_end}

{pstd}
{it:parm_name} is{p_end}
{pmore2}name used to identify model parameter{p_end}

{pstd}
{it:initial_val} is{p_end}
{pmore2}numeric literal; specifies an initial value{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate time series >}
{bf:Dynamic stochastic general equilibrium (DSGE) models >}
{bf:Linear DSGE models}


{marker description}{...}
{title:Description}

{pstd}
{cmd:dsge} fits linear dynamic stochastic general equilibrium 
(DSGE) models to multiple time series.  DSGE models are systems
of equations that are motivated by economic theory.  In these
systems, expectations of future values of variables can affect
the current values. The parameters of these models are often 
directly interpretable in terms of economic theory.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection DSGE dsgeMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt constraints(constraints)}; see
{helpb estimation options:[R] Estimation options}.

{phang}
{opt noidencheck} skips the check that the parameters are identified at the
initial values.  Models that are not structurally identified can still
converge, thereby producing meaningless results that only appear to have
meaning; thus care should be taken in specifying this option.
See {manlink DSGE Intro 6} for details.

{phang}
{opt solve} puts the model into state-space form at the initial parameter
values. No standard errors are produced.

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
{opt nodemean} prevents {opt dsge} from removing the mean of the
observed control variables prior to estimation.

{phang}
{opt post} causes {opt dsge} to post the parameter vector into {opt e()}, even
in the event of errors that arise from checking stability conditions or
identification. 

{phang}
{opt idtolerance(#)} specifies the tolerance used
in the identification diagnostic. The default is {cmd:idtolerance(1e-6)}.

{phang}
{opt lintolerance(#)} specifies the tolerance used
in the linearity diagnostic. The default is {cmd:lintolerance(1e-12)}.

{pstd}
The following option is available with {cmd:dsge} but is not shown in
the dialog box:

{phang}
{opt coeflegend}; see
{helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse rates2}{p_end}
{phang2}{cmd:. generate p = 400*(ln(gdpdef) - ln(L.gdpdef))}{p_end}
{phang2}{cmd:. label variable p "Inflation rate"}

{pstd}Parameter estimation{p_end}
{phang2}{cmd:. dsge (p = {c -(}beta{c )-}*F.p + {c -(}kappa{c )-}*x)}
         {cmd:(x = F.x -(r - F.p - g), unobserved)}
         {cmd:(r = (1/{c -(}beta{c )-})*p + u)}
         {cmd:(F.u = {c -(}rhou{c )-}*u, state)}
         {cmd:(F.g = {c -(}rhoz{c )-}*g, state)}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse usmacro2, clear}{p_end}
{phang2}{cmd:. constraint 1 _b[beta]=0.96}{p_end}

{pstd}Parameter estimation{p_end}
{phang2}{cmd:. dsge (p = {c -(}beta{c )-}*F.p + {c -(}kappa{c )-}*x)}
        {cmd:(x = F.x -(r - E(f.p) - g), unobserved)}
        {cmd:(r = {c -(}psi{c )-}*p + u)}
        {cmd:(F.u = {c -(}rhou{c )-}*u, state)}
        {cmd:(F.g = {c -(}rhog{c )-}*g, state),}
        {cmd:from(psi=1.5) constraint(1)}{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse usmacro2}{p_end}

{pstd}Parameter estimation{p_end}
{phang2}{cmd:. dsge (c = F.c - (1-{c -(}beta{c )-}+{c -(}beta{c )-}*{c -(}delta{c )-})*F.r, unobserved)}
        {cmd:({c -(}eta{c )-}*h = w - c, unobserved)}
        {cmd:({c -(}phi1{c )-}*x = y - {c -(}phi2{c )-}*c - g, unobserved)}
        {cmd:(y = (1-{c -(}alpha{c )-})*(z+h) + {c -(}alpha{c )-}*k)}
        {cmd:(w = y - h, unobserved)}
        {cmd:(r = y - k, unobserved)}
        {cmd:(F.k = {c -(}delta{c )-}*x+ (1-{c -(}delta{c )-})*k, state noshock)}
        {cmd:(F.z = {c -(}rhoz{c )-}*z, state)}
        {cmd:(F.g = {c -(}rhog{c )-}*g, state),}
        {cmd:from(beta=0.96 eta=1 alpha=0.3 delta=0.025 phi1=0.2 phi2=0.6 rhoz=0.8 rhog=0.3) solve noidencheck}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:dsge} stores the following in {cmd:e()}:

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

{p2col 5 20 24 2: Macros}{p_end}
{synopt :{cmd:e(cmd)}}{cmd:dsge}{p_end}
{synopt :{cmd:e(cmdline)}}command as typed{p_end}
{synopt :{cmd:e(depvar)}}unoperated names of dependent variables{p_end}
{synopt :{cmd:e(state)}}unoperated names of state variables{p_end}
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

{p2col 5 20 24 2: Matrices}{p_end}
{synopt :{cmd:e(b)}}parameter vector{p_end}
{synopt :{cmd:e(Cns)}}constraints matrix{p_end}
{synopt :{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt :{cmd:e(eigenvalues)}}generalized eigenvalues{p_end}
{synopt :{cmd:e(gradient)}}gradient vector{p_end}
{synopt :{cmd:e(shock_coeff)}}estimated shock coefficient matrix{p_end}
{synopt :{cmd:e(transition)}}estimated state transition matrix{p_end}
{synopt :{cmd:e(policy)}}estimated policy matrix{p_end}
{synopt :{cmd:e(V)}}variance-covariance matrix of the
estimators{p_end}
{synopt :{cmd:e(V_modelbased)}}model-based variance{p_end}

{p2col 5 20 24 2: Functions}{p_end}
{synopt :{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
