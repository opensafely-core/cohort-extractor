{smcl}
{* *! version 1.0.0  14may2019}{...}
{viewerdialog xtheckman "dialog xtheckman"}{...}
{vieweralsosee "[XT] xtheckman" "mansection XT xtheckman"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtheckman postestimation" "help xtheckman postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ERM] eregress" "help eregress"}{...}
{vieweralsosee "[R] heckman" "help heckman"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[XT] xteregress" "help xteregress"}{...}
{vieweralsosee "[XT] xtreg" "help xtreg"}{...}
{vieweralsosee "[XT] xtset" "help xtset"}{...}
{viewerjumpto "Syntax" "xtheckman##syntax"}{...}
{viewerjumpto "Menu" "xtheckman##menu"}{...}
{viewerjumpto "Description" "xtheckman##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtheckman##linkspdf"}{...}
{viewerjumpto "Options" "xtheckman##options"}{...}
{viewerjumpto "Examples" "xtheckman##examples"}{...}
{viewerjumpto "Stored results" "xtheckman##results"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[XT] xtheckman} {hline 2}}Random-effects regression with sample
selection{p_end}
{p2col:}({mansection XT xtheckman:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:xtheckman}
{depvar}
[{indepvars}]
{ifin}{cmd:,}
{cmdab:sel:ect(}{depvar}_s {cmd:=} {varlist}_s
   [{cmd:,} {help xtheckman##sel_options:{it:sel_options}}]{cmd:)}
[{help xtheckman##options_tbl:{it:options}}]

{marker options_tbl}{...}
{synoptset 22 tabbed}{...}
{synopthdr :options}
{synoptline}
{syntab:Model}
{p2coldent: * {cmdab:sel:ect()}}specify selection equation: dependent and independent
variables; whether to have constant term and offset variable
or include random effect{p_end}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opt norecorr:elation}}constrain the random effects to be independent{p_end}
{synopt :{cmdab:off:set(}{help varname:{it:varname}_o}{cmd:)}}include {it:varname}_o in model
with coefficient constrained to 1{p_end}
{synopt :{opth const:raints(numlist)}}apply specified linear constraints{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {cmd:oim}, 
        {opt r:obust}, {opt cl:uster} {it:clustvar},
        {opt opg}, 
        {opt boot:strap}, or {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help xtheckman##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Integration}
{synopt :{opt intm:ethod(intmethod)}}integration method for random effects; {it:intmethod}
may be {opt mv:aghermite} (the default) or {opt gh:ermite}{p_end}
{synopt :{opt intp:oints(#)}}set the number of integration (quadrature) points
for random-effects integration; default is {cmd:intpoints(7)}{p_end}

{syntab:Maximization}
{synopt :{it:{help xtheckman##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt :{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}

{marker sel_options}{...}
{synopthdr :sel_options}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opt nore}}do not include random effects in selection model{p_end}
{synopt :{cmdab:off:set(}{help varname:{it:varname}_o}{cmd:)}}include {it:varname}_o in model with
coefficient constrained to 1{p_end}
{synoptline}

{p 4 6 2}
* {opt select()} is required.{p_end}
{p 4 6 2}
{it:indepvars} and {it:varlist}_s may contain factor variables; see {help fvvarlists}.{p_end}
{p 4 6 2}
{it:depvar},
{it:indepvars},
{it:depvar}_s,
and
{it:varlist}_s
may contain time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}
{opt bootstrap},
{opt by},
{opt jackknife}, and
{opt statsby} are allowed.  See {help prefix}.{p_end}
{p 4 6 2}
{opt collinear} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp xtheckman_postestimation XT:xtheckman postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Longitudinal/panel data > Sample-selection models > Linear regression with sample selection (RE)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:xtheckman} fits a random-effects linear regression model with endogenous 
sample selection.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtheckmanQuickstart:Quick start}

        {mansection XT xtheckmanRemarksandexamples:Remarks and examples}

        {mansection XT xtheckmanMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{cmd:select(}{depvar}_s {cmd:=} {varlist}_s [{cmd:,} {it:sel_options}]{cmd:)}
specifies a random-effects probit model for sample selection with
{it:varlist}_s as the covariates for the selection model.  When
{it:depvar}_s = 1, the model's dependent variable is treated as observed
(selected); when {it:depvar}_s = 0, it is treated as unobserved (not
selected). {opt select()} is required.{p_end}

{pmore}
{it:sel_options} are the following:

{phang2}
{opt noconstant} suppresses the constant term (intercept) in the selection model.

{phang2}
{opt nore}
specifies that a random effect not be included in the selection equation. 

{phang2}
{cmd:offset(}{help varname:{it:varname}_o}{cmd:)}
specifies that {it:varname}_o be included in the selection 
model with the coefficient constrained to 1.

{phang}
{opt noconstant}; see
{helpb estimation options:[R] Estimation options}.

{phang}
{opt norecorrelation}
constrains the random effects in the outcome and selection equations to be independent. 

{phang}
{cmd:offset(}{help varname:{it:varname}_o}{cmd:)}, {opth constraints(numlist)};
     {helpb estimation options:[R] Estimation options}.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are derived from asymptotic theory ({cmd:oim}, {cmd:opg}),
that are robust to some kinds of misspecification ({cmd:robust}), that allow
for intragroup correlation ({cmd:cluster} {it:clustvar}), and that use
bootstrap or jackknife methods ({cmd:bootstrap}, {cmd:jackknife}); see
{helpb xt_vce_options:[XT] {it:vce_options}}.
{p_end}

{dlgtab:Reporting}

{phang}
{opt level(#)}, {opt nocnsreport}; see 
{helpb estimation options:[R] Estimation options}.

INCLUDE help displayopts_list

{dlgtab:Integration}

{phang}
{opt intmethod(intmethod)} and {opt intpoints(#)} control how the integration
of random effects is numerically calculated.

{phang2}
{opt intmethod()} specifies the integration method.  The default
        method is mean-variance adaptive Gauss-Hermite quadrature,
	{cmd:intmethod(mvaghermite)}.  We recommend this method.
	{cmd:intmethod(ghermite)} specifies that nonadaptive
	Gauss-Hermite quadrature be used.  This method is
	less computationally intensive and less accurate. It is
	sometimes useful to try {cmd:intmethod(ghermite)} to get the model to
	converge and then perhaps use the results as initial values
	specified in option {cmd:from} when fitting the model
	using the more accurate {cmd:intmethod(mvaghermite)}.
	See {mansection XT xtheckmanMethodsandformulas:{it:Methods and formulas}}
	in {bf:[XT] xtheckman} for more details.

{phang2}
{opt intpoints()} sets the number of integration (quadrature) points
        used for integration of the random effects.  The default is
	{cmd:intpoints(7)}.  Increasing the number
        increases accuracy but also increases computational time.
        Computational time is roughly proportional to the number specified. 
        See {mansection XT xtheckmanMethodsandformulas:{it:Methods and formulas}}
	in {bf:[XT] xtheckman} for more details.

{dlgtab:Maximization}

{phang}
{marker maximize_options}
{it:maximize_options}:
{opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:{it:algorithm_spec})},
{opt iter:ate(#)},
[{cmd:no}]{cmd:log},
{opt tr:ace},
{opt grad:ient},
{opt showstep},
{opt hess:ian},
{opt showtol:erance},
{opt tol:erance(#)},
{opt ltol:erance(#)},
{opt nrtol:erance(#)},
{opt nonrtol:erance}, and
{opt from(init_specs)};
see {helpb maximize:[R] Maximize}.  These options are seldom used.

{pmore}
The default technique is {cmd:technique(bhhh 10 nr 2)}.

{pmore}
Setting the optimization type to {cmd:technique(bhhh)} resets the default
{it:vcetype} to {cmd:vce(opg)}.

{pstd}
The following options are available with {cmd:xtheckman} but are not shown in
the dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
{helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse wagework}{p_end}
{phang2}{cmd:. xtset personid year}{p_end}

{pstd}Random-effects regression of {cmd:wage} on {cmd:age} and
{cmd:tenure}, accounting for endogenous sample selection{p_end}
{phang2}{cmd:. xtheckman wage age tenure, select(working = age market)}{p_end}

{pstd}Same as above, but constrain random effects in the {cmd:wage} and selection
equations to be independent{p_end}
{phang2}{cmd:. xtheckman wage age tenure, select(working = age market) norecorrelation}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:xtheckman} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt :{cmd:e(N)}}number of observations{p_end}
{synopt :{cmd:e(N_g)}}number of groups{p_end}
{synopt :{cmd:e(N_selected)}}number of selected observations{p_end}
{synopt :{cmd:e(N_nonselected)}}number of nonselected observations{p_end}
{synopt :{cmd:e(k)}}number of parameters{p_end}
{synopt :{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt :{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt :{cmd:e(k_aux)}}number of auxiliary parameters{p_end}
{synopt :{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt :{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt :{cmd:e(ll)}}log likelihood{p_end}
{synopt :{cmd:e(N_clust)}}number of clusters{p_end}
{synopt :{cmd:e(chi2)}}chi-squared{p_end}
{synopt :{cmd:e(p)}}p-value for model test{p_end}
{synopt :{cmd:e(n_requad)}}number of integration points for random
effects{p_end}
{synopt :{cmd:e(g_min)}}smallest group size{p_end}
{synopt :{cmd:e(g_avg)}}average group size{p_end}
{synopt :{cmd:e(g_max)}}largest group size{p_end}
{synopt :{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt :{cmd:e(ic)}}number of iterations{p_end}
{synopt :{cmd:e(rc)}}return code{p_end}
{synopt :{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt :{cmd:e(cmd)}}{cmd:xtheckman}{p_end}
{synopt :{cmd:e(cmdline)}}command as typed{p_end}
{synopt :{cmd:e(depvar)}}names of dependent variables{p_end}
{synopt :{cmd:e(ivar)}}variable denoting groups{p_end}
{synopt :{cmd:e(title)}}title in estimation output{p_end}
{synopt :{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt :{cmd:e(offset}{it:#}{cmd:)}}offset for the {it:#}th {it:depvar}, where
{it:#} is determined by equation order in output{p_end}
{synopt :{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt :{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt :{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt :{cmd:e(reintmethod)}}integration method for random effects{p_end}
{synopt :{cmd:e(opt)}}type of optimization{p_end}
{synopt :{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
maximization or minimization{p_end}
{synopt :{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt :{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt :{cmd:e(technique)}}maximization technique{p_end}
{synopt :{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt :{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt :{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt :{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt :{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt :{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt :{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt :{cmd:e(b)}}coefficient vector{p_end}
{synopt :{cmd:e(Cns)}}constraints matrix{p_end}
{synopt :{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt :{cmd:e(gradient)}}gradient vector{p_end}
{synopt :{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt :{cmd:e(V_modelbased)}}model-based variance{p_end}

{p2col 5 20 24 2: Functions}{p_end}
{synopt :{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
