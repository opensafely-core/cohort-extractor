{smcl}
{* *! version 1.0.1  10feb2019}{...}
{viewerdialog cmmixlogit "dialog cmmixlogit"}{...}
{vieweralsosee "[CM] cmmixlogit" "mansection CM cmmixlogit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[CM] cmmixlogit postestimation" "help cmmixlogit postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[CM] cmclogit" "help cmclogit"}{...}
{vieweralsosee "[CM] cmmprobit" "help cmmprobit"}{...}
{vieweralsosee "[CM] cmset" "help cmset"}{...}
{vieweralsosee "[CM] cmxtmixlogit" "help cmxtmixlogit"}{...}
{vieweralsosee "[CM] margins" "help cm margins"}{...}
{vieweralsosee "[CM] nlogit" "help nlogit"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{viewerjumpto "Syntax" "cmmixlogit##syntax"}{...}
{viewerjumpto "Menu" "cmmixlogit##menu"}{...}
{viewerjumpto "Description" "cmmixlogit##description"}{...}
{viewerjumpto "Links to PDF documentation" "cmmixlogit##linkspdf"}{...}
{viewerjumpto "Options" "cmmixlogit##options"}{...}
{viewerjumpto "Examples" "cmmixlogit##examples"}{...}
{viewerjumpto "Stored results" "cmmixlogit##results"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[CM] cmmixlogit} {hline 2}}Mixed logit choice model{p_end}
{p2col:}({mansection CM cmmixlogit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:cmmixlogit}
{depvar}
[{indepvars}]
{ifin}
[{help cmmixlogit##weight:{it:weight}}]
[{cmd:,} {it:options}]

{phang}
{it:depvar} equal to 1 identifies the chosen alternatives,
whereas a 0 indicates the alternatives that were not chosen.
There can be only one chosen alternative for each case.{p_end}
{phang}
{it:indepvars} specifies the alternative-specific covariates that have fixed
coefficients.

{synoptset 33 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opth casev:ars(varlist)}}case-specific variables{p_end}
{synopt :{cmdab:r:andom(}{varlist}[{cmd:,} {help cmmixlogit##distribution:{it:distribution}}]{cmd:)}}specify variables that are to have random coefficients and the coefficients' distribution{p_end}
{synopt :{opth corr:metric(cmmixlogit##metric:metric)}}correlation metric for correlated random coefficients{p_end}
{synopt :{cmdab:base:alternative(}{it:#}{c |}{it:lbl}{c |}{it:str}{cmd:)}}alternative used for normalizing location{p_end}
{synopt :{opt nocons:tant}}suppress the alternative-specific constant terms{p_end}
{synopt :{opt altwise}}use alternativewise deletion instead of casewise deletion{p_end}
{synopt :{opth const:raints(estimation_options##constraints():constraints)}}apply specified
linear constraints{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {cmd:oim},
{opt r:obust}, {opt cl:uster} {it:clustvar}, {opt opg},
{opt boot:strap}, or {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt or}}report odds ratios and relative-risk ratios{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help cmmixlogit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Integration}
{synopt :{opth intm:ethod(cmmixlogit##seqspec:seqspec)}}specify point set for Monte Carlo integration{p_end}
{synopt :{opt intp:oints(#)}}specify number of points in each sequence{p_end}
{synopt :{opt intb:urn(#)}}specify starting index in the Hammersley or Halton sequence{p_end}
{synopt :{opt ints:eed(#)}}specify random-number seed for pseudo-random sequence{p_end}
{synopt :{cmd:favor(}{cmdab:spe:ed}{c |}{cmdab:spa:ce)}}favor speed or space when generating integration points{p_end}

{syntab:Maximization}
{synopt :{it:{help cmmixlogit##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt :{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{marker distribution}{...}
{synoptset 33}{...}
{synopthdr:distribution}
{synoptline}
{synopt :{opt n:ormal}}Gaussian-distributed random coefficients; the default{p_end}
{synopt :{opt corr:elated}}correlated Gaussian-distributed random
    coefficients{p_end}
{synopt :{opt ln:ormal}}lognormal distributed random coefficients{p_end}
{synopt :{opt tn:ormal}}truncated normal distributed random coefficients{p_end}
{synopt :{opt u:niform}}uniform distributed random coefficients{p_end}
{synopt :{opt tr:iangle}}triangular distributed random coefficients{p_end}
{synoptline}

{marker metric}{...}
{synopthdr:metric}
{synoptline}
{synopt :{opt correlation}}standard deviation and correlation; the default{p_end}
{synopt :{opt covariance}}variance and covariance{p_end}
{synopt :{opt cholesky}}Cholesky factor{p_end}
{synoptline}

{marker seqspec}{...}
{pstd}
{it:seqspec} is

        {it:seqtype}[{cmd:,} {cmd:antithetics}{c |}{cmd:mantithetics}]

{marker seqtype}{...}
{synopthdr:seqtype}
{synoptline}
{synopt :{opt hammersley}}Hammersley point set; the default{p_end}
{synopt :{opt halton}}Halton point set{p_end}
{synopt :{opt random}}uniform pseudo-random point set{p_end}
{synoptline}
{p2colreset}{...}

{p 4 6 2}
You must {cmd:cmset} your data before using {cmd:cmmixlogit}; see
{manhelp cmset CM}.{p_end}
INCLUDE help fvvarlist2
{p 4 6 2}
{cmd:bootstrap},
{cmd:by},
{cmd:jackknife},
{cmd:statsby},
and
{cmd:svy}
are allowed; see {help prefix}.{p_end}
INCLUDE help weight_boot
{p 4 6 2}
{cmd:vce()} and weights
INCLUDE help weight_svy
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s are allowed; see
{help weight}.{p_end}
{p 4 6 2}
{cmd:collinear} and {cmd:coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp cmmixlogit_postestimation CM:cmmixlogit postestimation} for
features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Choice models > Mixed logit model}


{marker description}{...}
{title:Description}

{pstd}
{cmd:cmmixlogit} fits a mixed logit choice model, also known as a mixed
multinomial logit model or random-parameter logit model, which uses random
coefficients to model the correlation of choices across alternatives.  The
random coefficients are on variables that vary across both cases and
alternatives known as alternative-specific variables.

{pstd}
The correlation of choices across alternatives relaxes the independence of
irrelevant alternatives (IIA) property imposed by the conventional multinomial
logit model fit by {helpb mlogit} and the conditional logit choice model fit
by {helpb cmclogit}.

{pstd}
For a mixed logit choice model for panel data, see
{manhelp cmxtmixlogit CM}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection CM cmmixlogitQuickstart:Quick start}

        {mansection CM cmmixlogitRemarksandexamples:Remarks and examples}

        {mansection CM cmmixlogitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opth casevars(varlist)} specifies the case-specific variables that are
constant for each case.  If there are a maximum of A alternatives, there will
be A - 1 sets of coefficients associated with {cmd:casevars()}.

{phang}
{cmd:random(}{varlist}[{cmd:,} {help cmmixlogit##distribution:{it:distribution}}]{cmd:)}
specifies the alternative-specific variables that are to have random
coefficients and optionally the assumed distribution of the random
coefficients.  The default distribution is {cmd:normal}, meaning
Gaussian-distributed random coefficients.  {it:distribution} may also be
{cmd:correlated}, {cmd:lnormal}, {cmd:tnormal}, {cmd:uniform}, or
{cmd:triangle}.  {cmd:random()} may be specified more than once to specify
different sets of variables that correspond to different coefficient
distributions.

{phang}
{opth corrmetric:(cmmixlogit##metric:metric)}
specifies the estimation metric for correlated random coefficients.
{cmd:corrmetric(correlation)}, the default, estimates the standard deviations
and correlations of the random coefficients.  {cmd:corrmetric(covariance)}
estimates variances and covariances, and {cmd:corrmetric(cholesky)} estimates
Cholesky factors.  {cmd:corrmetric()} is allowed only when
{cmd:random(}{varlist}{cmd:, correlated)} is specified.

{phang}
{cmd:basealternative(}{it:#}{c |}{it:lbl}{c |}{it:str}{cmd:)}
sets the alternative that normalizes the level of utility.  The base
alternative may be specified as a number when the alternatives variable is
numeric, as a label when it is numeric and has a {help label:value label}, or
as a string when it is a string variable.  The default is the alternative with
the highest frequency of being chosen.  This option is ignored if neither
alternative-specific constants nor case-specific variables are specified.

{phang}
{cmd:noconstant} suppresses the A - 1 alternative-specific constant terms.

{phang}
{cmd:altwise} specifies that alternativewise deletion be used when omitting
observations because of missing values in your variables.  The default is to
use casewise deletion; that is, the entire group of observations making up a
case is omitted if any missing values are encountered.  This option does not
apply to observations that are excluded by the {cmd:if} or {cmd:in} qualifier
or the {cmd:by} prefix; these observations are always handled alternativewise
regardless of whether {cmd:altwise} is specified.

{phang}
{opt constraints(constraints)}; see
{helpb estimation options:[R] Estimation options}.

{dlgtab:SE/Robust}

INCLUDE help vce_asymptall

{pmore}
Specifying {cmd:vce(robust)} is equivalent to specifying
 {cmd:vce(cluster} {it:caseid}{cmd:)}.

{pmore}
If specifying {cmd:vce(bootstrap)} or {cmd:vce(jackknife)}, you must
also specify {cmd:basealternative()}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options:[R] Estimation options}.

{phang}
{opt or} reports the estimated coefficients transformed to odds ratios
for alternative-specific variables and relative-risk ratios for case-specific
variables.  That is, exp(b) rather than b is reported.  Standard errors and
confidence intervals are transformed accordingly.  This option affects how
results are displayed, not how they are estimated.  {cmd:or} may be specified
at estimation or when replaying previously estimated results.

{phang}
{opt nocnsreport}; see
{helpb estimation options:[R] Estimation options}.

INCLUDE help displayopts_list

{dlgtab:Integration}

{phang}
{cmd:intmethod(}{help cmmixlogit##seqtype:{it:seqtype}}[{cmd:,} {cmd:antithetics}{c |}{cmd:mantithetics}]{cmd:)} 
specifies the method of generating the point sets used in the Monte Carlo
integration.  {cmd:intmethod(hammersley)}, the default, uses the Hammersley
sequence; {cmd:intmethod(halton)} uses the Halton sequence; and
{cmd:intmethod(random)} uses a sequence of uniform random numbers.

{phang2}
{cmd:antithetics} and {cmd:mantithetics} specify that a unidimensional
antithetic sequence or a multidimensional antithetic sequence, respectively,
be generated instead of the standard implementation of the requested
{it:seqtype}.  These methods improve the accuracy of the Monte Carlo
integration at the cost of additional computation time; see
{mansection CM cmmixlogitMethodsandformulas:{it:Methods and formulas}}.

{phang}
{opt intpoints(#)} specifies the number of points to use in the
Monte Carlo integration.  The default number of points is a function of
model complexity and integration method.
If {cmd:intmethod(hammersley)} or {cmd:intmethod(halton)} is used,
the default is {bind:500 + floor(2.5 sqrt[N_c {ln(r + 5) + v}])},
where N_c is the number of cases, 
r is the number of random coefficients in the model, 
and v is the number of variance parameters.
If {cmd:intmethod(hammersley, mantithetics)} or
{cmd:intmethod(halton, mantithetics)} is used, the number of 
integration points is 
{bind:250 + floor(0.5 sqrt[N_c{ln(r + 5) + v}])}.
If {cmd:intmethod(random)} is used, the number of points is 
twice the number of points used by
{cmd:intmethod(hammersley)} and {cmd:intmethod(halton)}.
Larger values of {cmd:intpoints()} provide better approximations of the log 
likelihood at the cost of additional computation time.

{phang}
{opt intburn(#)} specifies where in the Hammersley or Halton sequence
to start, which helps reduce the correlation between the sequences of each
dimension.  The default is to discard the first n initial elements from each
sequence, where n is the largest prime used to generate the sequences.  This
option may not be specified with {cmd:intmethod(random)}.

{phang}
{opt intseed(#)} specifies the seed to use for generating uniform
pseudo-random sequences.  This option may be specified only with
{cmd:intmethod(random)}.  {it:#} must be an integer between 0 and
2^{31} - 1.  The default is to use the current seed value from Stata's
uniform random-number generator; see {helpb set_seed:[R] set seed}.

{phang}
{cmd:favor(speed{c |}space)} instructs {cmd:cmmixlogit} to favor either
speed or space when generating the integration points.  {cmd:favor(speed)} is
the default.  When favoring speed, the integration points are generated once
and stored in memory, thus increasing the speed of evaluating the likelihood.
This speed increase can be seen when there are many cases or when the user
specifies many integration points in {opt intpoints(#)}.  When favoring space,
the integration points are generated repeatedly with each likelihood
evaluation.

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
see {helpb maximize:[R] Maximize}.

{pmore}
Setting the optimization type to {cmd:technique(bhhh)} resets the default
{it:vcetype} to {cmd:vce(opg)}.

{pstd}
The following options are available with {cmd:cmmixlogit} but are not shown in
the dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
{helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse inschoice}{p_end}
{phang2}{cmd:. cmset id insurance}{p_end}

{pstd}Fit mixed logit choice model with fixed coefficient for {cmd:premium}
and random coefficients for {cmd:deductible}{p_end}
{phang2}{cmd:. cmmixlogit choice premium, random(deductible)}{p_end}

{pstd}Fit model with correlated random coefficients for {cmd:premium}
and {cmd:deductible}{p_end}
{phang2}{cmd:. cmmixlogit choice, random(deductible premium, correlated)}{p_end}

{pstd}Replay results, reporting odds ratios rather than coefficients{p_end}
{phang2}{cmd:. cmmixlogit, or}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:cmmixlogit} stores the following in {cmd:e()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Scalars}{p_end}
{synopt :{cmd:e(N)}}number of observations{p_end}
{synopt :{cmd:e(N_case)}}number of cases{p_end}
{synopt :{cmd:e(N_ic)}}N for Bayesian information criterion (BIC){p_end}
{synopt :{cmd:e(N_clust)}}number of clusters{p_end}
{synopt :{cmd:e(k)}}number of parameters{p_end}
{synopt :{cmd:e(k_alt)}}number of alternatives{p_end}
{synopt :{cmd:e(k_casevars)}}number of case-specific variables{p_end}
{synopt :{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt :{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt :{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt :{cmd:e(df_c)}}degrees of freedom, comparison test{p_end}
{synopt :{cmd:e(ll)}}log simulated-likelihood{p_end}
{synopt :{cmd:e(ll_c)}}log likelihood, comparison model{p_end}
{synopt :{cmd:e(const)}}constant indicator{p_end}
{synopt :{cmd:e(intpoints)}}number of raw integration points{p_end}
{synopt :{cmd:e(lsequence)}}length of each integration sequence{p_end}
{synopt :{cmd:e(intburn)}}starting sequence index{p_end}
{synopt :{cmd:e(chi2)}}chi-squared{p_end}
{synopt :{cmd:e(chi2_c)}}chi-squared, comparison test{p_end}
{synopt :{cmd:e(p)}}p-value for model test{p_end}
{synopt :{cmd:e(p_c)}}p-value for comparison test{p_end}
{synopt :{cmd:e(alt_min)}}minimum number of alternatives{p_end}
{synopt :{cmd:e(alt_avg)}}average number of alternatives{p_end}
{synopt :{cmd:e(alt_max)}}maximum number of alternatives{p_end}
{synopt :{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt :{cmd:e(ic)}}number of iterations{p_end}
{synopt :{cmd:e(rc)}}return code{p_end}
{synopt :{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{p2col 5 25 29 2: Macros}{p_end}
{synopt :{cmd:e(cmd)}}{cmd:cmmixlogit}{p_end}
{synopt :{cmd:e(cmdline)}}command as typed{p_end}
{synopt :{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt :{cmd:e(caseid)}}name of case ID variable{p_end}
{synopt :{cmd:e(altvar)}}name of alternatives variable{p_end}
{synopt :{cmd:e(alteqs)}}alternative equation names{p_end}
{synopt :{cmd:e(alt}{it:#}{cmd:)}}alternative labels{p_end}
{synopt :{cmd:e(base)}}base alternative{p_end}
{synopt :{cmd:e(corrmetric)}}correlation metric for correlated random coefficients{p_end}
{synopt :{cmd:e(wtype)}}weight type{p_end}
{synopt :{cmd:e(wexp)}}weight expression{p_end}
{synopt :{cmd:e(marktype)}}{cmd:casewise} or {cmd:altwise}, type of markout{p_end}
{synopt :{cmd:e(key_N_ic)}}{cmd:cases}, key for N for Bayesian information criterion (BIC){p_end}
{synopt :{cmd:e(title)}}title in estimation output{p_end}
{synopt :{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt :{cmd:e(chi2type)}}type of chi-squared{p_end}
{synopt :{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt :{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt :{cmd:e(opt)}}type of optimization{p_end}
{synopt :{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
                           maximization or minimization{p_end}
{synopt :{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt :{cmd:e(intmethod)}}technique used to generate sequences{p_end}
{synopt :{cmd:e(sequence)}}type of sequences{p_end}
{synopt :{cmd:e(mc_rngstate)}}random-number state used{p_end}
{synopt :{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt :{cmd:e(technique)}}maximization technique{p_end}
{synopt :{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt :{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt :{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt :{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt :{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt :{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 25 29 2: Matrices}{p_end}
{synopt :{cmd:e(b)}}coefficient vector{p_end}
{synopt :{cmd:e(altvals)}}alternative values{p_end}
{synopt :{cmd:e(Cns)}}constraints matrix{p_end}
{synopt :{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt :{cmd:e(gradient)}}gradient vector{p_end}
{synopt :{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt :{cmd:e(V_modelbased)}}model-based variance{p_end}

{p2col 5 25 29 2: Functions}{p_end}
{synopt :{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
