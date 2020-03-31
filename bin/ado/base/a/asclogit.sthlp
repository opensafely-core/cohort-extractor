{smcl}
{* *! version 1.3.11  01apr2019}{...}
{viewerdialog asclogit "dialog asclogit"}{...}
{vieweralsosee "previously documented" "help prdocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] asclogit postestimation" "help asclogit postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] asmixlogit" "help asmixlogit"}{...}
{vieweralsosee "[R] asmprobit" "help asmprobit"}{...}
{vieweralsosee "[R] asroprobit" "help asroprobit"}{...}
{vieweralsosee "[R] clogit" "help clogit"}{...}
{vieweralsosee "[R] logistic" "help logistic"}{...}
{vieweralsosee "[R] logit" "help logit"}{...}
{vieweralsosee "[R] nlogit" "help nlogit"}{...}
{vieweralsosee "[R] ologit" "help ologit"}{...}
{viewerjumpto "Syntax" "asclogit##syntax"}{...}
{viewerjumpto "Menu" "asclogit##menu"}{...}
{viewerjumpto "Description" "asclogit##description"}{...}
{viewerjumpto "Options" "asclogit##options"}{...}
{viewerjumpto "Examples" "asclogit##examples"}{...}
{viewerjumpto "Stored results" "asclogit##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[R] asclogit} {hline 2}}Alternative-specific conditional logit (McFadden's choice) model{p_end}
{p2col:}({browse "http://www.stata.com/manuals15/rasclogit.pdf":View complete PDF manual entry}){p_end}
{p2colreset}{...}

{pstd}
{cmd:asclogit} continues to work but, as of Stata 16, is no longer an official
part of Stata.  This is the original help file, which we will no longer
update, so some links may no longer work.

{pstd}
See {helpb cmclogit} for a recommended alternative to {cmd:asclogit}.


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmdab:asclogit} 
{depvar} 
[{indepvars}] 
{ifin}
[{it:{help asclogit##weight:weight}}]{cmd:,} 
{bind:{cmd:case(}{varname}{cmd:)}}
{bind:{cmdab:alt:ernatives(}{varname}{cmd:)}}
[{it:options}]

{phang}
{it:depvar} equal to 1 identifies the outcome or chosen alternatives,
whereas a 0 indicates the alternatives that were not chosen. There can
be multiple alternatives chosen for each case.

{synoptset 28 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{p2coldent :* {opth case(varname)}}use {it:varname} to identify cases{p_end}
{p2coldent :* {opth alt:ernatives(varname)}}use {it:varname} to identify the
	alternatives available for each case{p_end}
{synopt :{opth casev:ars(varlist)}}case-specific variables{p_end}
{synopt :{opt base:alternative(#|lbl|str)}}alternative to normalize location{p_end}
{synopt:{opt nocons:tant}}suppress alternative-specific constant terms{p_end}
{synopt :{opt altwise}}use alternativewise deletion instead of casewise
	deletion{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient
	constrained to 1{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply 
	specified linear constraints{p_end}
{synopt:{opt col:linear}}keep collinear variables{p_end}

{syntab:SE/Robust}
{synopt:{opth vce(vcetype)}}{it:vcetype} may be {opt oim}, 
	{opt r:obust}, {opt cl:uster} {it:clustvar}, {opt boot:strap}, or
	{opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt or}}report odds ratios{p_end}
{synopt :{opt nohead:er}}do not display the header on the coefficient 
	table{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help asclogit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt :{it:{help asclogit##maximize_options:maximize_options}}}control the 
	maximization process; seldom used{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt case(varname)} and {opt alternatives(varname)} are required.{p_end}
INCLUDE help fvvarlist2
{p 4 6 2}
{opt bootstrap}, {opt by}, {opt fp}, {opt jackknife}, and {opt statsby}
are allowed; see {help prefix}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s, {opt iweight}s, and {opt pweight}s are allowed
(see {help weight}), but they are interpreted to apply to cases as a whole,
not to individual observations.  See
{mansection R clogitRemarksandexamplesUseofweights:{it:Use of weights}} in
{bf:[R] clogit}.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp asclogit_postestimation R:asclogit postestimation} for features
available after estimation.  {p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Categorical outcomes > Alternative-specific conditional logit}


{marker description}{...}
{title:Description}

{pstd}
{cmd:asclogit} fits McFadden's choice model, which is a specific case of
the more general conditional logistic regression model fit by {helpb clogit}.
The command requires multiple observations for each case (individual or
decision), where each observation represents an alternative that may be
chosen.  {opt asclogit} allows two types of independent variables:
alternative-specific variables, which vary across both cases and alternatives,
and case-specific variables, which vary across only cases.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}{opth case(varname)} specifies the numeric variable that identifies
each case.  {opt case()} is required and must be integer valued.

{phang}{opth alternatives(varname)} specifies the variable that identifies the
alternatives for each case.  The number of alternatives can vary with each
case; the maximum number of alternatives cannot exceed the limits of
{cmd:tabulate oneway}; see {helpb tabulate oneway:[R] tabulate oneway}. 
{opt alternatives()} is required and may be a numeric or a string variable.

{phang}{opth casevars(varlist)} specifies the case-specific numeric variables.
These are variables that are constant for each case. If there are a maximum of J
alternatives, there will be J-1 sets of coefficients associated with the
{opt casevars()}.  

{phang}{opt basealternative(#|lbl|str)} specifies the alternative that 
normalizes the latent-variable location (the level of utility).  The base
alternative may be specified as a number, label, or string depending on the
storage type of the variable indicating alternatives.  The default is the
alternative with the highest frequency.

{pmore}
If {cmd:vce(bootstrap)} or {cmd:vce(jackknife)} is specified, you must specify
the base alternative.  This is to ensure that the same model is fit with
each call to {cmd:asclogit}.

{phang}
{opt noconstant} suppresses the J-1 alternative-specific constant terms.

{phang}{opt altwise} specifies that alternativewise deletion be used when
marking out observations due to missing values in your variables.  The default
is to use casewise deletion; that is, the entire group of observations
making up a case is deleted if any missing values are encountered.  This
option does not apply to observations that are marked out by the {cmd:if} or
{cmd:in} qualifier or the {cmd:by} prefix.

{phang}
{opth offset(varname)},
{cmd:constraints(}{it:{help estimation_options##constraints():numlist}}|{it:matname}{cmd:)},
{opt collinear}; see
{helpb estimation options:[R] estimation options}.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are derived from asymptotic theory ({cmd:oim}),
that are robust to some kinds of misspecification ({cmd:robust}), that allow
for intragroup correlation ({cmd:cluster} {it:clustvar}), and that use
bootstrap or jackknife methods ({cmd:bootstrap}, {cmd:jackknife}); see
{helpb vce_option:[R] {it:vce_option}}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] estimation options}.

{phang}
{opt or} reports the estimated coefficients transformed to odds ratios,
that is, exp(b) rather than b.  Standard errors and confidence intervals are
similarly transformed.  This option affects how results are displayed, not how
they are estimated.  {opt or} may be specified at estimation or when
replaying previously estimated results.

{phang}
{opt noheader} prevents the coefficient table header from being displayed.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] estimation options}.

INCLUDE help displayopts_list

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}:
{opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)}, [{cmd:{ul:no}}]{opt lo:g}, {opt tr:ace}, 
{opt grad:ient},
{opt showstep},
{opt hess:ian},
{opt showtol:erance},
{opt tol:erance(#)},
{opt ltol:erance(#)},
{opt nrtol:erance(#)},
{opt nonrtol:erance}, and
{opt from(init_specs)}; see {manhelp maximize R}.  These options are seldom
used.

{pmore}
{cmd:technique(bhhh)} is not allowed.

{pmore}
The initial estimates must be specified as 
{cmd:from(}{it:matname} [, {cmd:copy} ]{cmd:)}, where {it:matname}
is the matrix containing the initial estimates and the {cmd:copy} option 
specifies that only the position of each element in {it:matname} is relevant.
If {cmd: copy} is not specified, the column stripe of {it:matname} identifies 
the estimates.

{pstd}
The following option is available with {opt asclogit} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse choice}{p_end}

{pstd}Fit alternative-specific conditional logit model{p_end}
{phang2}{cmd:. asclogit choice dealer, case(id) alternatives(car)}
       {cmd:casevars(sex income)}

{pstd}Replay results, displaying odds ratios and suppressing the header on the
coefficient table{p_end}
{phang2}{cmd:. asclogit, or noheader}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:asclogit} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_case)}}number of cases{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_alt)}}number of alternatives{p_end}
{synopt:{cmd:e(k_indvars)}}number of alternative-specific variables{p_end}
{synopt:{cmd:e(k_casevars)}}number of case-specific variables{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(const)}}constant indicator{p_end}
{synopt:{cmd:e(i_base)}}base alternative index{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(alt_min)}}minimum number of alternatives{p_end}
{synopt:{cmd:e(alt_avg)}}average number of alternatives{p_end}
{synopt:{cmd:e(alt_max)}}maximum number of alternatives{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 22 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:asclogit}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(indvars)}}alternative-specific independent variable{p_end}
{synopt:{cmd:e(casevars)}}case-specific variables{p_end}
{synopt:{cmd:e(case)}}variable defining cases{p_end}
{synopt:{cmd:e(altvar)}}variable defining alternatives{p_end}
{synopt:{cmd:e(alteqs)}}alternative equation names{p_end}
{synopt:{cmd:e(alt}{it:#}{cmd:)}}alternative labels{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset)}}linear offset variable{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}, type of model chi-squared test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
                         maximization or minimization{p_end}
{synopt:{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt:{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(datasignature)}}the checksum{p_end}
{synopt:{cmd:e(datasignaturevars)}}variables used in calculation of checksum{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(stats)}}alternative statistics{p_end}
{synopt:{cmd:e(altvals)}}alternative values{p_end}
{synopt:{cmd:e(altfreq)}}alternative frequencies{p_end}
{synopt:{cmd:e(alt_casevars)}}indicators for estimated case-specific
coefficients -- {cmd:e(k_alt)} x {cmd:e(k_casevars)}{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
