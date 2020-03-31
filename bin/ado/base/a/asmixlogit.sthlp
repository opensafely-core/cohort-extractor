{smcl}
{* *! version 1.0.4  01apr2019}{...}
{viewerdialog asmixlogit "dialog asmixlogit"}{...}
{vieweralsosee "previously documented" "help prdocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] asmixlogit postestimation" "help asmixlogit postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] asclogit" "help asclogit"}{...}
{vieweralsosee "[R] asmprobit" "help asmprobit"}{...}
{vieweralsosee "[R] asroprobit" "help asroprobit"}{...}
{vieweralsosee "[R] mlogit" "help mlogit"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{viewerjumpto "Syntax" "asmixlogit##syntax"}{...}
{viewerjumpto "Menu" "asmixlogit##menu"}{...}
{viewerjumpto "Description" "asmixlogit##description"}{...}
{viewerjumpto "Options" "asmixlogit##options"}{...}
{viewerjumpto "Examples" "asmixlogit##examples"}{...}
{viewerjumpto "Stored results" "asmixlogit##results"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[R] asmixlogit} {hline 2}}Alternative-specific mixed logit
 regression{p_end}
{p2col:}({browse "http://www.stata.com/manuals15/rasmixlogit.pdf":View complete PDF manual entry}){p_end}
{p2colreset}{...}

{pstd}
{cmd:asmixlogit} continues to work but, as of Stata 16, is no longer an
official part of Stata.  This is the original help file, which we will no
longer update, so some links may no longer work.

{pstd}
See {helpb cmmixlogit} for a recommended alternative to {cmd:asmixlogit}.


{marker syntax}{...}
{title:Syntax}

{p 8 18 2}
{cmd:asmixlogit}
{depvar}
[{indepvars}]
{ifin}
[{it:{help asmixlogit##weight:weight}}]{cmd:,}
{opth c:ase(varname:caseid)}
[{it:options}]

{phang}
{it:depvar} equal to 1 identifies the outcome or chosen alternative,
whereas a 0 indicates the alternatives that were not chosen.
Only one alternative may be chosen for each case.

{phang}
{it:indepvars} specifies the alternative-specific covariates that have fixed
coefficients.

{synoptset 32 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{p2coldent :* {opth c:ase(varname:caseid)}}use variable {it:caseid} to identify cases{p_end}
{p2coldent :* {opth alt:ernatives(varname:altvar)}}use {it:altvar} to identify the alternatives available for each case{p_end}
{synopt :{opth casev:ars(varlist)}}case-specific variables{p_end}
{synopt :{opt nocons:tant}}suppress the alternative-specific constant
terms{p_end}
{synopt :{cmdab:r:andom(}{varlist}[{cmd:,} {it:{help asmixlogit##distribution:distribution}}]{cmd:)}}specify variables that are to
have random coefficients and the coefficients' distribution{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}
{synopt :{opt col:linear}}keep collinear variables{p_end}

{syntab:Model 2}
{synopt :{opth corr:metric(asmixlogit##metric:metric)}}correlation metric for
correlated random coefficients{p_end}
{synopt :{opt base:alternative(#|lbl|str)}}alternative used for
normalizing location{p_end}
{synopt :{opt altwise}}use alternativewise deletion instead of casewise
deletion{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim}, {opt r:obust},
{opt cl:uster} {it:clustvar}, {opt opg}, {opt boot:strap}, or
{opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help asmixlogit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Integration}
{synopt :{opth intm:ethod(asmixlogit##seqspec:seqspec)}}specify point set for
Monte Carlo integration{p_end}
{synopt :{opt intp:oints(#)}}specify number of points in each sequence{p_end}
{synopt :{opt intb:urn(#)}}specify starting index in the Hammersley or Halton
sequence{p_end}
{synopt :{opt ints:eed(#)}}specify random-number seed for pseudorandom
sequence{p_end}
{synopt :{cmd:favor(speed}|{cmd:space)}}favor speed or space when generating
integration points{p_end}

{syntab:Maximization}
{synopt :{it:{help asmixlogit##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{marker metric}{...}
{synoptset 32}{...}
{synopthdr:metric}
{synoptline}
{synopt :{opt correlation}}standard deviation and correlation; the
default{p_end}
{synopt :{opt covariance}}variance and covariance{p_end}
{synopt :{opt cholesky}}Cholesky factor{p_end}
{synoptline}

{marker distribution}{...}
{synopthdr:distribution}
{synoptline}
{synopt :{opt n:ormal}}Gaussian-distributed random coefficients; the
default{p_end}
{synopt :{opt corr:elated}}correlated Gaussian-distributed random
coefficients{p_end}
{synopt :{opt ln:ormal}}lognormal distributed random coefficients{p_end}
{synopt :{opt tn:ormal}}truncated normal distributed random coefficients{p_end}
{synopt :{opt u:niform}}uniform distributed random coefficients{p_end}
{synopt :{opt tr:iangle}}triangular distributed random coefficients{p_end}
{synoptline}

{marker seqspec}{...}
{pstd}
{it:seqspec} is

{phang2}
{it:seqtype} [{cmd:,} {cmd:antithetics} | {cmd:mantithetics}]

{marker seqtype}{...}
{synopthdr:seqtype}
{synoptline}
{synopt :{opt hammersley}}Hammersley point set; the default{p_end}
{synopt :{opt halton}}Halton point set{p_end}
{synopt :{opt random}}uniform pseudorandom point set{p_end}
{synoptline}

{p 4 6 2}
* {opt case(casevar)} is required.
{opt alternatives(altvar)} is required to estimate alternative-specific
constants or if case-specific variables are specified.{p_end}
INCLUDE help fvvarlist2
{p 4 6 2}
{opt bootstrap},
{opt by},
{opt jackknife},
{opt statsby},
and
{opt svy}
are allowed; see {help prefix}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}
{opt vce()} and weights are not allowed with the {helpb svy} prefix.{p_end}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s, {opt iweight}s, and {opt pweight}s are allowed; see
{help weights}.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp asmixlogit_postestimation R:asmixlogit postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Categorical outcomes > Mixed logit model}


{marker description}{...}
{title:Description}

{pstd}
{cmd:asmixlogit} fits an alternative-specific mixed logit model, also known
as a mixed multinomial logit model or random-parameter logit model, that
uses random coefficients to model the correlation of choices across
alternatives.  The random coefficients are on variables that vary across
both cases and alternatives known as alternative-specific variables.  The
correlation of choices across alternatives relaxes the independence of
irrelevant alternatives (IIA) property imposed by the conventional
multinomial logit model fit by {helpb mlogit} and the alternative-specific
conditional logit model fit by {helpb asclogit}.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt case(caseid)} specifies the variable that identifies each case.
This variable identifies the individuals or entities making a choice.
{opt case()} is required.

{phang}
{opt alternatives(altvar)} specifies the variable that identifies the 
alternatives for each case.  The number of alternatives can vary
with each case.  {cmd:alternatives()} is required to estimate
alternative-specific constants or if case-specific variables are specified
in {cmd:casevars()}.

{phang}
{opth casevars(varlist)} specifies the case-specific variables that are
constant for each {opt case()}.  If there are a maximum of A alternatives,
there will be A-1 sets of coefficients associated with {opt casevars()}.

{phang}
{opt noconstant} suppresses the A-1 alternative-specific constant terms.

{phang}
{cmd:random(}{varlist}
[{cmd:,} {it:{help asmixlogit##distribution:distribution}}]{cmd:)} specifies
the alternative-specific variables that are to have random coefficients and
optionally the assumed distribution of the random coefficients.  The default
distribution is {cmd:normal}, meaning Gaussian-distributed random
coefficients.  {it:distribution} may also be {cmd:correlated}, {cmd:lnormal},
{cmd:tnormal}, {cmd:uniform}, or {cmd:triangle}.  {cmd:random()} may be
specified more than once to specify different sets of variables that
correspond to different coefficient distributions.

{phang}
{opt constraints(constraints)}, {opt collinear}; see
{helpb estimation options:[R] estimation options}.

{dlgtab:Model 2}

{phang}
{opth corrmetric:(asmixlogit##metric:metric)} specifies the estimation
metric for correlated random coefficients.  {cmd:corrmetric(correlation)}, the
default, estimates the standard deviations and correlations of the
random coefficients.  {cmd:corrmetric(covariance)} estimates variances and
covariances, and {cmd:corrmetric(cholesky)} estimates Cholesky factors.
{cmd:corrmetric()} is allowed only when
{cmd:random(}{varlist}{cmd:,} {cmd:correlated)} is specified.

{phang}
{opt basealternative(#|lbl|str)}
specifies the alternative used to normalize the latent-variable location
(also referred to as the level of utility).  The base alternative may be
specified as a number, label, or string.  The default is the most frequent
alternative.  This option is ignored if neither alternative-specific 
constants nor case-specific variables are specified.

{phang}
{opt altwise} specifies that alternativewise deletion be used when marking
out observations due to missing values in your variables.  The default is to
use casewise deletion; that is, the entire group of observations making up a
case is deleted if any missing values are encountered.  This option does not
apply to observations that are marked out by the {cmd:if} or {cmd:in}
qualifier or the {cmd:by} prefix.

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
{opt level(#)}, {opt nocnsreport}; see
{helpb estimation options##level():[R] estimation options}.

INCLUDE help displayopts_list

{dlgtab:Integration}

{phang}
{cmd:intmethod(}{it:{help asmixlogit##seqtype:seqtype}}
[{cmd:,} {cmd:antithetics} | {cmd:mantithetics}]{cmd:)} 
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
{mansection R asmixlogitMethodsandformulas:{it:Methods and formulas}}.

{phang}
{opt intpoints(#)} specifies the number of raw points to use in the Monte
Carlo integration.  The default number of points is a function of model
complexity and integration method.  If {cmd:intmethod(hammersley)} or
{cmd:intmethod(halton)} is used and  there are r uncorrelated random
coefficients in the model, the default is 50 x floor(sqrt{r}).  If there are
also correlated random coefficients in the model and c is the number of
correlation parameters, another 50 x floor(sqrt{c}) points are added.  If
{cmd:intmethod(random)} is used, the number of points is the above times 5.
Larger values of {cmd:intpoints()} provide better approximations of the log
likelihood at the cost of additional computation time.

{phang}
{opt intburn(#)} specifies where in the Hammersley or Halton sequence to
start, which helps reduce the correlation between the sequences of each
dimension.  The default is to discard the first n initial elements from each
sequence, where n is the largest prime used to generate the sequences.  This
option may not be specified with {cmd:intmethod(random)}.

{phang}
{opt intseed(#)} specifies the seed to use for generating uniform
pseudorandom sequences.  This option may be specified only with
{cmd:intmethod(random)}.  {it:#} must be an integer between 0 and
2^{31}-1.  The default is to use the current seed value from
Stata's uniform random-number generator; see {manhelp set_seed R:set seed}.

{phang}
{cmd:favor(speed}|{cmd:space)} instructs {cmd:asmixlogit} to favor either
speed or space when generating the integration points.  {cmd:favor(speed)} is
the default.  When favoring speed, the integration points are generated once
and stored in memory, thus increasing the speed of evaluating the likelihood.
This speed increase can be seen when there are many cases or when the user
specifies a large number of integration points in {opt intpoints(#)}.
When favoring space, the integration points are generated repeatedly with each
likelihood evaluation.

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}:
{opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)}, [{cmd:{ul:no}}]{opt lo:g}, {opt tr:ace}, 
{opt grad:ient}, {opt showstep},
{opt hess:ian},
{opt showtol:erance},
{opt tol:erance(#)},
{opt ltol:erance(#)}, {opt nrtol:erance(#)},
{opt nonrtol:erance}, and
{opt from(init_specs)}; see {manhelp maximize R}.  These options are seldom
used.

{pmore}
Setting the optimization type to {cmd:technique(bhhh)} resets the default
{it:vcetype} to {cmd:vce(opg)}.

{pstd}
The following option is available with {opt asmixlogit} but is not shown in
the dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse inschoice}{p_end}

{pstd}Mixed logit model with a fixed coefficient for {cmd:premium}
and random coefficients for {cmd:deductible}{p_end}
{phang2}{cmd:. asmixlogit choice premium, case(id) alternatives(insurance)}
     {cmd:random(deductible)}{p_end}

{pstd}Mixed logit model with correlated random coefficients for
{cmd:premium} and {cmd:deductible}{p_end}
{phang2}{cmd:. asmixlogit choice, case(id) alternatives(insurance)}
     {cmd:random(deductible premium, correlated)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:asmixlogit} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_case)}}number of cases{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_alt)}}number of alternatives{p_end}
{synopt:{cmd:e(k_casevars)}}number of case-specific variables{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log simulated-likelihood{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(const)}}constant indicator{p_end}
{synopt:{cmd:e(intpoints)}}number of raw integration points{p_end}
{synopt:{cmd:e(lsequence)}}length of each integration sequence{p_end}
{synopt:{cmd:e(intburn)}}starting sequence index{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}model test p-value{p_end}
{synopt:{cmd:e(ll_c)}}log likelihood, comparison model{p_end}
{synopt:{cmd:e(chi2_c)}}chi-squared, comparison test{p_end}
{synopt:{cmd:e(df_c)}}degrees of freedom, comparison test{p_end}
{synopt:{cmd:e(p_c)}}p-value for comparison test{p_end}
{synopt:{cmd:e(alt_min)}}minimum number of alternatives{p_end}
{synopt:{cmd:e(alt_avg)}}average number of alternatives{p_end}
{synopt:{cmd:e(alt_max)}}maximum number of alternatives{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{opt 1} if converged, {opt 0} otherwise{p_end}

{p2col 5 20 24 2:Macros}{p_end}
{synopt:{cmd:e(cmd)}}{opt asmixlogit}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(casevars)}}case-specific variables{p_end}
{synopt:{cmd:e(case)}}variable defining cases{p_end}
{synopt:{cmd:e(altvar)}}variable defining alternatives{p_end}
{synopt:{cmd:e(alteqs)}}alternative equation names{p_end}
{synopt:{cmd:e(alt}{it:#}{cmd:)}}alternative labels{p_end}
{synopt:{cmd:e(base)}}base alternative{p_end}
{synopt:{cmd:e(corrmetric)}}correlation metric for correlated random coefficients{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(chi2type)}}type of chi-squared{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {opt vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(which)}}{opt max} or {opt min}; whether optimizer is to perform
                           maximization or minimization{p_end}
{synopt:{cmd:e(ml_method)}}type of {opt ml} method{p_end}
{synopt:{cmd:e(intmethod)}}technique used to generate sequences{p_end}
{synopt:{cmd:e(sequence)}}type of sequences{p_end}
{synopt:{cmd:e(mc_rngstate)}}random-number state used{p_end}
{synopt:{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {opt predict}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 20 24 2:Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{p2col 5 20 24 2:Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
