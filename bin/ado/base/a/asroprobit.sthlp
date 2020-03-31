{smcl}
{* *! version 1.4.10  01apr2019}{...}
{viewerdialog asroprobit "dialog asroprobit"}{...}
{vieweralsosee "previously documented" "help prdocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] asroprobit postestimation" "help asroprobit postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] asmixlogit" "help asmixlogit"}{...}
{vieweralsosee "[R] asmprobit" "help asmprobit"}{...}
{vieweralsosee "[R] mlogit" "help mlogit"}{...}
{vieweralsosee "[R] mprobit" "help mprobit"}{...}
{vieweralsosee "[R] oprobit" "help oprobit"}{...}
{viewerjumpto "Syntax" "asroprobit##syntax"}{...}
{viewerjumpto "Menu" "asroprobit##menu"}{...}
{viewerjumpto "Description" "asroprobit##description"}{...}
{viewerjumpto "Options" "asroprobit##options"}{...}
{viewerjumpto "Examples" "asroprobit##examples"}{...}
{viewerjumpto "Stored results" "asroprobit##results"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[R] asroprobit} {hline 2}}Alternative-specific rank-ordered
     probit regression{p_end}
{p2col:}({browse "http://www.stata.com/manuals15/rasroprobit.pdf":View complete PDF manual entry}){p_end}
{p2colreset}{...}

{pstd}
{cmd:asroprobit} continues to work but, as of Stata 16, is no longer an
official part of Stata.  This is the original help file, which we will no
longer update, so some links may no longer work.

{pstd}
See {helpb cmroprobit} for a recommended alternative to {cmd:asroprobit}.


{marker syntax}{...}
{title:Syntax}

{p 8 18 2}
{cmd:asroprobit} 
{depvar} 
[{indepvars}] 
{ifin}
[{it:{help asroprobit##weight:weight}}]
{cmd:,}
{opth case(varname)}
{opth alt:ernatives(varname)}
[{it:options}]

{synoptset 28 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{p2coldent :* {opth case(varname)}}use {it:varname} to identify cases{p_end}
{p2coldent :* {opth alt:ernatives(varname)}}use {it:varname} to identify the
	alternatives available for each case{p_end}
{synopt : {opth casev:ars(varlist)}}case-specific variables{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply
	specified linear constraints{p_end}
{synopt:{opt col:linear}}keep collinear variables{p_end}

{syntab :Model 2}
{synopt :{opth corr:elation(asroprobit##cortype:correlation)}}correlation
	structure of the latent-variable errors{p_end}
{synopt :{opth std:dev(asroprobit##stdtype:stddev)}}variance structure of the
	latent-variable errors{p_end}
{synopt :{opt struc:tural}}use the structural covariance parameterization;
	default is the differenced covariance parameterization{p_end}
{synopt :{opt fact:or(#)}}use the factor covariance structure with dimension 
	{it:#}{p_end}
{synopt :{opt nocons:tant}}suppress the alternative-specific constant terms{p_end}
{synopt :{opt base:alternative(#|lbl|str)}}alternative used for normalizing
	location{p_end}
{synopt :{opt scale:alternative(#|lbl|str)}}alternative used for normalizing
	scale{p_end}
{synopt :{opt altwise}}use alternativewise deletion instead of casewise
	deletion{p_end}
{synopt :{opt rev:erse}}interpret the lowest rank in {depvar} as the best;
	the default is the highest rank is the best{p_end}

{syntab :SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be
	{opt oim}, {opt r:obust}, {opt cl:uster} {it:clustvar},
	{opt opg}, {opt boot:strap}, or {opt jack:knife}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt notran:sform}}do not transform variance-covariance
	estimates to the standard deviation and correlation metric{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help asroprobit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab :Integration}
{synopt :{opth intm:ethod(asroprobit##seqtype:seqtype)}}type of quasi- or
	pseudouniform sequence{p_end}
{synopt :{opt intp:oints(#)}}number of points in each sequence{p_end}
{synopt :{opt intb:urn(#)}}starting index in the Hammersley or Halton
	sequence{p_end}
{synopt :{cmdab:ints:eed(}{it:{help asroprobit##code:code}}{c |}{it:#}{cmd:)}}pseudouniform random-number seed{p_end}
{synopt :{opt anti:thetics}}use antithetic draws{p_end}
{synopt :{opt nopiv:ot}}do not use integration interval pivoting{p_end}
{synopt :{opt initb:hhh(#)}}use the BHHH optimization algorithm for the first
	{it:#} iterations{p_end}
{synopt :{cmd:favor(}{opt spe:ed}|{opt spa:ce}{cmd:)}}favor speed or space
	when generating integration points{p_end}

{syntab :Maximization}
{synopt :{it:{help asroprobit##maximize_options:maximize_options}}}control the
        maximization process{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{synoptset 23}{...}
{marker cortype}
{synopthdr :correlation}
{synoptline}
{synopt :{opt uns:tructured}}one correlation parameter for each pair of 
	alternatives; correlations with the {opt basealternative()} are
	zero; the default{p_end}
{synopt :{opt exc:hangeable}}one correlation parameter common to all pairs of 
	alternatives; correlations with the {opt basealternative()} are
	zero{p_end}
{synopt :{opt ind:ependent}}constrain all correlation parameters to zero{p_end}
{synopt :{opt pat:tern} {it:matname}}user-specified matrix identifying the
	correlation pattern{p_end}
{synopt :{opt fix:ed} {it:matname}}user-specified matrix identifying
        the fixed and free correlation parameters{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 23}{...}
{marker stdtype}
{synopthdr :stddev}
{synoptline}
{synopt :{opt het:eroskedastic}}estimate standard deviation for each
	alternative; standard deviations for {opt basealternative()} and
	{opt scalealternative()} set to one{p_end}
{synopt :{opt hom:oskedastic}}all standard deviations are one{p_end}
{synopt :{opt pat:tern} {it:matname}}user-specified matrix identifying 
	the standard deviation pattern{p_end}
{synopt :{opt fix:ed} {it:matname}}user-specified matrix identifying 
	the fixed and free standard deviations{p_end}
{synoptline}
{p2colreset}{...}
 
{synoptset 23}{...}
{marker seqtype}
{synopthdr :seqtype}
{synoptline}
{synopt :{opt ham:mersley}}Hammersley point set{p_end}
{synopt :{opt hal:ton}}Halton point set{p_end}
{synopt :{opt ran:dom}}uniform pseudorandom point set{p_end}
{synoptline}
{p2colreset}{...}

{p 4 6 2}* {opt case(varname)} and {opt alternatives(varname)} are
required.{p_end}
INCLUDE help fvvarlist2
{p 4 6 2}{cmd:bootstrap}, {cmd:by}, {cmd:jackknife}, and {cmd:statsby}
are allowed; see {help prefix}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{marker weight}{...}
{p 4 6 2}{cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s are allowed; see
{help weight}.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp asroprobit_postestimation R:asroprobit postestimation}
for features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Ordinal outcomes > Rank-ordered probit regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:asroprobit} fits rank-ordered probit (ROP) models by using maximum
simulated likelihood (MSL).  The model allows you to relax the independence of
irrelevant alternatives (IIA) property that is characteristic of the
rank-ordered logistic model by estimating the variance-covariance parameters
of the latent-variable errors.  Each unique identifier in the 
{cmd:case()} variable has multiple alternatives identified in the 
{cmd:alternatives()} variable, and {depvar} contains the ranked alternatives
made by each case.  Only the order in the ranks, not the magnitude of their
differences, is assumed to be relevant.  By default, the largest rank indicates
the more desirable alternative.  Use the {cmd:reverse} option if the lowest
rank should be interpreted as the more desirable alternative.  Tied ranks are
allowed, but they increase the computation time because all permutations of the
tied ranks are used in computing the likelihood for each case.
{cmd:asroprobit} allows two types of independent variables:
alternative-specific variables, in which the values of each variable vary with
each alternative, and case-specific variables, which vary with each case.

{pstd}
The estimation technique of {cmd:asroprobit} is nearly identical to that of
{cmd:asmprobit}, and the two routines share many of the same options; see
{manhelp asmprobit R}.


{marker options}{...}
{title:Options}

INCLUDE help asmprobit_options_model

{phang}{opt reverse} directs {cmd:asroprobit} to interpret the rank in
{depvar} that is smallest in value as the preferred alternative.  By
default, the rank that is the largest in value is the favored alternative.

{dlgtab:SE/Robust}

INCLUDE help vce_asymptall

{pmore}
If specifying {cmd:vce(bootstrap)} or {cmd:vce(jackknife)}, you must
also specify {cmd:basealternative()} and {cmd:scalealternative()}.

{dlgtab:Reporting}

{phang}{opt level(#)}; see
{helpb estimation options##level():[R] estimation options}.

{phang}{opt notransform} prevents retransforming the Cholesky-factored
variance-covariance estimates to the correlation and standard deviation
metric.

{pmore}
This option has no effect if {cmd:structural} is not specified because the
default differenced variance-covariance estimates have no interesting
interpretation as correlations and standard deviations.  {cmd:notransform} also
has no effect if the {cmd:correlation()} and {cmd:stddev()} options are
specified with anything other than their default values.  Here it is
generally not possible to factor the variance-covariance matrix, so optimization
is already performed using the standard deviation and correlation
representations.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] estimation options}.

INCLUDE help displayopts_list

{dlgtab:Integration}

{phang}{cmd:intmethod(hammersley}|{cmd:halton}|{cmd:random)} specifies the
method of generating the point sets used in the quasi-Monte Carlo integration
of the multivariate normal density.  {cmd:intmethod(hammersley)}, the default,
uses the Hammersley sequence; {cmd:intmethod(halton)} uses the Halton
sequence; and {cmd:intmethod(random)} uses a sequence of uniform random
numbers.

{phang}{opt intpoints(#)} specifies the number of points to use in the
quasi-Monte Carlo integration.  If this option is not specified, the number
of points is 50 x J if {cmd:intmethod(hammersley)} or {cmd:intmethod(halton)}
is used and 100 x J if {cmd:intmethod(random)} is used.  Larger values of
{opt intpoints()} provide better approximations of the log likelihood, but at
the cost of added computation time.

{phang}{opt intburn(#)} specifies where in the Hammersley or Halton
sequence to start, which helps reduce the correlation between the sequences of
each dimension.  The default is 0.  This option may not be specified with
{cmd:intmethod(random)}.

{marker code}{...}
{phang}{opt intseed(code|#)} specifies the seed to use for generating the
uniform pseudorandom sequence.  This option may be specified only with
{cmd:intmethod(random)}.  {it:code} refers to a string that records the state
of the random-number generator {cmd:runiform()}; see 
{helpb set_seed:[R] set seed}.  An integer value {it:#} may be used also. The
default is to use the current seed value from Stata's uniform random-number
generator, which can be obtained from {cmd:c(rngstate)}.

{phang}{opt antithetics} specifies that antithetic draws be used.  The
antithetic draw for the J - 1 vector uniform-random variables, {bf:x}, is
1 - {bf:x}.

{phang}{opt nopivot} turns off integration interval pivoting.  By default,
{cmd:asroprobit} will pivot the wider intervals of integration to the interior
of the multivariate integration.  This improves the accuracy of the quadrature
estimate.  However, discontinuities may result in the computation of numerical
second-order derivatives using finite differencing (for the Newton-Raphson
optimize technique, {cmd:tech(nr)}) when few simulation points are used,
resulting in a non-positive-definite Hessian.  {cmd:asroprobit} uses the
Broyden-Fletcher-Goldfarb-Shanno optimization algorithm, by default, which does
not require computing the Hessian numerically using finite differencing. 

{phang}{opt initbhhh(#)} specifies that the
Berndt-Hall-Hall-Hausman (BHHH) algorithm be used for the initial {it:#}
optimization steps.  This option is the only way to use the BHHH algorithm
along with other optimization techniques.  The algorithm switching feature of
{cmd:ml}'s {opt technique()} option cannot include {opt bhhh}.

{phang}{cmd:favor(speed}|{cmd:space)} instructs {cmd:asroprobit} to favor either
speed or space when generating the integration points.  {cmd:favor(speed)} is
the default.  When favoring speed, the integration points are generated once and
stored in memory, thus increasing the speed of evaluating the likelihood.  This
speed increase can be seen when there are many cases or when the user
specifies a large number of integration points, {cmd:intpoints(}{it:#}{cmd:)}.
When favoring space, the integration points are generated repeatedly with each
likelihood evaluation.

{pmore} 
For unbalanced data, where the number of alternatives varies with each case,
the estimates computed using {cmd:intmethod(random)} will vary
slightly between {cmd:favor(speed)} and {cmd:favor(space)}.  This is because
the uniform sequences will not be identical, even when
initiating the sequences using the same uniform seed, 
{cmd:intseed(}{it:code}{cmd:|}{it:#}{cmd:)}.  For
{cmd:favor(speed)}, {cmd:ncase} blocks of {cmd:intpoints(}{it:#}{cmd:)} X J-2
uniform points are generated, where J is the maximum number of alternatives.
For {cmd:favor(space)}, the column dimension of the matrices of points varies
with the number of alternatives that each case has.

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}:
{opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)},
[{cmdab:no:}]{opt lo:g},
{opt tr:ace},
{opt grad:ient},
{opt showstep},
{opt hess:ian},
{opt showtol:erance},
{opt tol:erance(#)},
{opt ltol:erance(#)},
{opt nrtol:erance(#)},
{opt nonrtol:erance}, and
{opt from(init_specs)}; see {manhelp maximize R}.  

{pmore}
The following options may be particularly useful in obtaining 
convergence with {cmd:asroprobit}: {opt difficult}, 
{opt technique(algorithm_spec)}, {opt nrtolerance(#)}, 
{opt nonrtolerance}, and {opt from(init_specs)}.

{pmore}
If {opt technique()} contains more than one algorithm specification,
{opt bhhh} cannot be one of them.  To use the BHHH algorithm with another
algorithm, use the {opt initbhhh()} option and specify the other algorithm in
{opt technique()}.

{pmore}
Setting the optimization type to {cmd:technique(bhhh)} resets the default
{it:vcetype} to {cmd:vce(opg)}.

{pmore}
When specifying {cmd:from(}{it:matname} [{cmd:, copy}]{cmd:)}, the values in
{it:matname} associated with the latent-variable error variances must be for
the log-transformed standard deviations and
inverse-hyperbolic tangent-transformed
correlations.  This option makes using the coefficient vector from a
previously fitted {cmd:asroprobit} model convenient as a starting point.

{pstd}
The following option is available with {opt asroprobit} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse wlsrank}{p_end}

{pstd}Fit alternative-specific rank-ordered probit model, excluding cases
with tied ranks; specify that lowest {cmd:rank} is most preferred{p_end}
{phang2}{cmd:. asroprobit rank high low if noties,}
           {cmd:case(id) alternatives(jobchar) casevars(female score) reverse}

{pstd}Specify exchangeable correlation model for latent-variable errors{p_end}
{phang2}{cmd:. asroprobit rank high low if noties,}
            {cmd:case(id) alternatives(jobchar) casevars(female score)}
            {cmd:reverse correlation(exchangeable)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:asroprobit} stores the following in {cmd:e()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_case)}}number of cases{p_end}
{synopt:{cmd:e(N_ties)}}number of ties{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_alt)}}number of alternatives{p_end}
{synopt:{cmd:e(k_indvars)}}number of alternative-specific variables{p_end}
{synopt:{cmd:e(k_casevars)}}number of case-specific variables{p_end}
{synopt:{cmd:e(k_sigma)}}number of variance estimates{p_end}
{synopt:{cmd:e(k_rho)}}number of correlation estimates{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log simulated-likelihood{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(const)}}constant indicator{p_end}
{synopt:{cmd:e(i_base)}}base alternative index{p_end}
{synopt:{cmd:e(i_scale)}}scale alternative index{p_end}
{synopt:{cmd:e(mc_points)}}number of Monte Carlo replications{p_end}
{synopt:{cmd:e(mc_burn)}}starting sequence index{p_end}
{synopt:{cmd:e(mc_antithetics)}}antithetics indicator{p_end}
{synopt:{cmd:e(reverse)}}{cmd:1} if minimum rank is best, {cmd:0} if maximum
rank is best{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(fullcov)}}unstructured covariance indicator{p_end}
{synopt:{cmd:e(structcov)}}{cmd:1} if structured covariance, {cmd:0} otherwise{p_end}
{synopt:{cmd:e(cholesky)}}Cholesky-factored covariance indicator{p_end}
{synopt:{cmd:e(alt_min)}}minimum number of alternatives{p_end}
{synopt:{cmd:e(alt_avg)}}average number of alternatives{p_end}
{synopt:{cmd:e(alt_max)}}maximum number of alternatives{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:asroprobit}{p_end}
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
{synopt:{cmd:e(correlation)}}correlation structure{p_end}
{synopt:{cmd:e(stddev)}}variance structure{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}, type of model chi-squared test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
                         maximization or minimization{p_end}
{synopt:{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt:{cmd:e(mc_method)}}{cmd:Hammersley}, {cmd:Halton}, or {cmd:uniform random}; technique to generate sequences{p_end}
{synopt:{cmd:e(mc_rngstate)}}random-number state used{p_end}
{synopt:{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(datasignature)}}the checksum{p_end}
{synopt:{cmd:e(datasignaturevars)}}variables used in calculation of checksum{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(mfx_dlg)}}program used to implement {cmd:estat mfx} dialog{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(stats)}}alternative statistics{p_end}
{synopt:{cmd:e(stdpattern)}}variance pattern{p_end}
{synopt:{cmd:e(stdfixed)}}fixed and free standard deviations{p_end}
{synopt:{cmd:e(altvals)}}alternative values{p_end}
{synopt:{cmd:e(altfreq)}}alternative frequencies{p_end}
{synopt:{cmd:e(alt_casevars)}}indicators for estimated case-specific
coefficients -- {cmd:e(k_alt)} x {cmd:e(k_casevars)}{p_end}
{synopt:{cmd:e(corpattern)}}correlation structure{p_end}
{synopt:{cmd:e(corfixed)}}fixed and free correlations{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
