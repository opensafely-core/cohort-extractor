{smcl}
{* *! version 1.0.1  10feb2020}{...}
{viewerdialog cmclogit "dialog cmclogit"}{...}
{vieweralsosee "[CM] cmclogit" "mansection CM cmclogit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[CM] cmclogit postestimation" "help cmclogit postestimation"}{...}
{vieweralsosee "[CM] cmmixlogit" "help cmmixlogit"}{...}
{vieweralsosee "[CM] cmmprobit" "help cmmprobit"}{...}
{vieweralsosee "[CM] cmset" "help cmset"}{...}
{vieweralsosee "[CM] margins" "help cm margins"}{...}
{vieweralsosee "[CM] nlogit" "help nlogit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] clogit" "help clogit"}{...}
{vieweralsosee "[R] mlogit" "help mlogit"}{...}
{viewerjumpto "Syntax" "cmclogit##syntax"}{...}
{viewerjumpto "Menu" "cmclogit##menu"}{...}
{viewerjumpto "Description" "cmclogit##description"}{...}
{viewerjumpto "Links to PDF documentation" "cmclogit##linkspdf"}{...}
{viewerjumpto "Options" "cmclogit##options"}{...}
{viewerjumpto "Examples" "cmclogit##examples"}{...}
{viewerjumpto "Stored results" "cmclogit##results"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[CM] cmclogit} {hline 2}}Conditional logit (McFadden's) choice
model{p_end}
{p2col:}({mansection CM cmclogit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:cmclogit}
{depvar}
[{indepvars}]
{ifin}
[{help cmclogit##weight:{it:weight}}]
[{cmd:,} {it:options}]

{phang}
{it:depvar} equal to 1 identifies the chosen alternatives,
whereas a 0 indicates the alternatives that were not chosen.
There can be only one chosen alternative for each case.

{synoptset 30 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opth casev:ars(varlist)}}case-specific variables{p_end}
{synopt :{cmdab:base:alternative(}{it:#}{c |}{it:lbl}{c |}{it:str}{cmd:)}}set base
alternative{p_end}
{synopt :{opt nocons:tant}}suppress alternative-specific constant terms{p_end}
{synopt :{opt altwise}}use alternativewise deletion instead of casewise
deletion{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with
coefficient constrained to 1{p_end}
{synopt :{opth const:raints(estimation_options##constraints():constraints)}}apply specified
linear constraints{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {cmd:oim},
{opt r:obust}, {opt cl:uster} {it:clustvar}, {opt boot:strap},
or {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt or}}report odds ratios and relative-risk ratios{p_end}
{synopt :{opt nohead:er}}do not display the header on the coefficient
table{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help cmclogit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt :{it:{help cmclogit##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt :{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
You must {cmd:cmset} your data before using {cmd:cmclogit};
see {manhelp cmset CM}.{p_end}
INCLUDE help fvvarlist2
{p 4 6 2}
{cmd:bootstrap},
{cmd:by},
{cmd:fp},
{cmd:jackknife},
and
{cmd:statsby}
are allowed; see {help prefix}.{p_end}
INCLUDE help weight_boot
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s are allowed (see
{help weight}), but they are interpreted to apply to cases as a whole, not to
individual observations.  See
{mansection R clogitRemarksandexamplesUseofweights:{it:Use of weights}}
in {bf:[R] clogit}.{p_end}
{p 4 6 2}
{cmd:collinear} and {cmd:coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp cmclogit_postestimation CM:cmclogit postestimation} for
features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Choice models > Conditional logit (McFadden's choice) model}


{marker description}{...}
{title:Description}

{pstd}
{cmd:cmclogit} fits McFadden's choice model, which is a specific case of the
more general conditional logistic regression model fit by {helpb clogit}.

{pstd}
The command requires multiple observations for each case (representing one
individual or decision maker), where each observation represents an
alternative that may be chosen.  {cmd:cmclogit} allows two types of
independent variables: alternative-specific variables, which vary across both
cases and alternatives, and case-specific variables, which vary across only
cases.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection CM cmclogitQuickstart:Quick start}

        {mansection CM cmclogitRemarksandexamples:Remarks and examples}

        {mansection CM cmclogitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opth casevars(varlist)} specifies the case-specific numeric variables.  These
are variables that are constant for each case.  If there are a maximum of J
alternatives, there will be J - 1 sets of coefficients associated with each
{it:casevar}.

{phang}
{cmd:basealternative(}{it:#}{c |}{it:lbl}{c |}{it:str}{cmd:)} sets the
alternative that normalizes the level of utility.  The base alternative may be
specified as a number when the alternatives variable is numeric, as a label
when it is numeric and has a {help label:value label}, or as a string when it
is a string variable.  The default is the alternative with the highest
frequency of being chosen.  This option is ignored if neither
alternative-specific constants nor case-specific variables are specified.

{pmore}
If {cmd:vce(bootstrap)} or {cmd:vce(jackknife)} is specified, you must 
specify the base alternative.  This is to ensure that the same model is 
fit with each call to {cmd:cmclogit}.

{phang}
{opt noconstant} suppresses the J - 1 alternative-specific constant terms.

{marker altwise}{...}
{phang}
{opt altwise} specifies that alternativewise deletion be used when omitting
observations because of missing values in your variables.  The default is to
use casewise deletion; that is, the entire group of observations making up a
case is omitted if any missing values are encountered.  This option does not
apply to observations that are excluded by the {cmd:if} or {cmd:in} qualifier
or the {cmd:by} prefix; these observations are always handled alternativewise
regardless of whether {cmd:altwise} is specified.

{phang}
{opth offset(varname)}, 
{cmd:constraints(}{it:{help numlist}}{c |}{it:matname}{cmd:)};
see {helpb estimation options:[R] Estimation options}.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported,
which includes types that are derived from asymptotic theory ({cmd:oim}), that
are robust to some kinds of misspecification ({cmd:robust}), that allow for
intragroup correlation ({cmd:cluster} {it:clustvar}), and that use bootstrap
or jackknife methods ({cmd:bootstrap}, {cmd:jackknife}); see
{manhelpi vce_option R}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation_options:[R] Estimation options}.

{phang}
{opt or} reports the estimated coefficients transformed to odds ratios
for alternative-specific variables and relative-risk ratios for case-specific
variables.  That is, exp(b) rather than b is reported.  Standard errors and
confidence intervals are transformed accordingly.  This option affects how
results are displayed, not how they are estimated.  {cmd:or} may be specified
at estimation or when replaying previously estimated results.

{phang}
{opt noheader} prevents the coefficient table header from being displayed.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] Estimation options}.

INCLUDE help displayopts_list

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}:
{opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
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
{cmd:technique(bhhh)} is not allowed.

{pmore}
The initial estimates must be specified as
{cmd:from(}{it:matname} [{cmd:, copy}]{cmd:)},
where {it:matname} is the matrix containing the initial estimates and the 
{cmd:copy} option specifies that only the position of each element in 
{it:matname} is relevant.  If {cmd:copy} is not specified, the column stripe
of {it:matname} identifies the estimates.

{pstd}
The following options are available with {cmd:cmclogit} but are not shown in
the dialog box:

{phang}
{cmd:collinear}, {cmd:coeflegend};
see {helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse carchoice}{p_end}
{phang2}{cmd:. cmset consumerid car}{p_end}

{pstd}Fit conditional logit choice model{p_end}
{phang2}{cmd:. cmclogit purchase dealers, casevars(i.gender income)}{p_end}

{pstd}Replay results, reporting odds ratios and relative-risk ratios rather
than coefficients and omitting the output header{p_end}
{phang2}{cmd:. cmclogit, or noheader}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:cmclogit} stores the following in {cmd:e()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Scalars}{p_end}
{synopt :{cmd:e(N)}}number of observations{p_end}
{synopt :{cmd:e(N_case)}}number of cases{p_end}
{synopt :{cmd:e(N_ic)}}N for Bayesian information criterion (BIC){p_end}
{synopt :{cmd:e(N_clust)}}number of clusters{p_end}
{synopt :{cmd:e(k)}}number of parameters{p_end}
{synopt :{cmd:e(k_alt)}}number of alternatives{p_end}
{synopt :{cmd:e(k_indvars)}}number of alternative-specific variables{p_end}
{synopt :{cmd:e(k_casevars)}}number of case-specific variables{p_end}
{synopt :{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt :{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt :{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt :{cmd:e(ll)}}log likelihood{p_end}
{synopt :{cmd:e(const)}}constant indicator{p_end}
{synopt :{cmd:e(i_base)}}base alternative index{p_end}
{synopt :{cmd:e(chi2)}}chi-squared{p_end}
{synopt :{cmd:e(p)}}p-value for model test{p_end}
{synopt :{cmd:e(alt_min)}}minimum number of alternatives{p_end}
{synopt :{cmd:e(alt_avg)}}average number of alternatives{p_end}
{synopt :{cmd:e(alt_max)}}maximum number of alternatives{p_end}
{synopt :{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt :{cmd:e(ic)}}number of iterations{p_end}
{synopt :{cmd:e(rc)}}return code{p_end}
{synopt :{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{p2col 5 25 29 2: Macros}{p_end}
{synopt :{cmd:e(cmd)}}{cmd:cmclogit}{p_end}
{synopt :{cmd:e(cmdline)}}command as typed{p_end}
{synopt :{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt :{cmd:e(caseid)}}name of case ID variable{p_end}
{synopt :{cmd:e(altvar)}}name of alternatives variable{p_end}
{synopt :{cmd:e(alteqs)}}alternative equation names{p_end}
{synopt :{cmd:e(alt}{it:#}{cmd:)}}alternative labels{p_end}
{synopt :{cmd:e(wtype)}}weight type{p_end}
{synopt :{cmd:e(wexp)}}weight expression{p_end}
{synopt :{cmd:e(marktype)}}{cmd:casewise} or {cmd:altwise}, type of markout{p_end}
{synopt :{cmd:e(key_N_ic)}}{cmd:cases}, key for N for Bayesian information criterion (BIC){p_end}
{synopt :{cmd:e(title)}}title in estimation output{p_end}
{synopt :{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt :{cmd:e(offset)}}linear offset variable{p_end}
{synopt :{cmd:e(chi2type)}}{cmd:Wald}, type of model chi-squared test{p_end}
{synopt :{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt :{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt :{cmd:e(opt)}}type of optimization{p_end}
{synopt :{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
                         maximization or minimization{p_end}
{synopt :{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt :{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt :{cmd:e(technique)}}maximization technique{p_end}
{synopt :{cmd:e(datasignature)}}the checksum{p_end}
{synopt :{cmd:e(datasignaturevars)}}variables used in calculation of
checksum{p_end}
{synopt :{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt :{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt :{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt :{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt :{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt :{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 25 29 2: Matrices}{p_end}
{synopt :{cmd:e(b)}}coefficient vector{p_end}
{synopt :{cmd:e(stats)}}alternative statistics{p_end}
{synopt :{cmd:e(altvals)}}alternative values{p_end}
{synopt :{cmd:e(altfreq)}}alternative frequencies{p_end}
{synopt :{cmd:e(alt_casevars)}}indicators for estimated case-specific
coefficients -- {cmd:e(k_alt)} x {cmd:e(k_casevars)}{p_end}
{synopt :{cmd:e(Cns)}}constraints matrix{p_end}
{synopt :{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt :{cmd:e(gradient)}}gradient vector{p_end}
{synopt :{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt :{cmd:e(V_modelbased)}}model-based variance{p_end}

{p2col 5 25 29 2: Functions}{p_end}
{synopt :{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
