{smcl}
{* *! version 1.0.1  07feb2020}{...}
{viewerdialog cmroprobit "dialog cmroprobit"}{...}
{vieweralsosee "[CM] cmroprobit" "mansection CM cmroprobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[CM] cmroprobit postestimation" "help cmroprobit postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[CM] cmmprobit" "help cmmprobit"}{...}
{vieweralsosee "[CM] cmrologit" "help cmrologit"}{...}
{vieweralsosee "[CM] cmset" "help cmset"}{...}
{vieweralsosee "[CM] margins" "help cm margins"}{...}
{vieweralsosee "[R] ologit" "help ologit"}{...}
{vieweralsosee "[R] oprobit" "help oprobit"}{...}
{viewerjumpto "Syntax" "cmroprobit##syntax"}{...}
{viewerjumpto "Menu" "cmroprobit##menu"}{...}
{viewerjumpto "Description" "cmroprobit##description"}{...}
{viewerjumpto "Links to PDF documentation" "cmroprobit##linkspdf"}{...}
{viewerjumpto "Options" "cmroprobit##options"}{...}
{viewerjumpto "Examples" "cmroprobit##examples"}{...}
{viewerjumpto "Stored results" "cmroprobit##results"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[CM] cmroprobit} {hline 2}}Rank-ordered probit choice model{p_end}
{p2col:}({mansection CM cmroprobit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:cmroprobit}
{depvar}
[{indepvars}]
{ifin}
[{help cmroprobit##weight:{it:weight}}]
[{cmd:,} {it:options}]

{synoptset 30 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opth casev:ars(varlist)}}case-specific variables{p_end}
{synopt :{opt rev:erse}}interpret the lowest rank in {it:depvar} as the best;
the default is the highest rank is the best{p_end}
{synopt :{cmdab:base:alternative(}{it:#}{c |}{it:lbl}{c |}{it:str}{cmd:)}}alternative used for normalizing location{p_end}
{synopt :{cmdab:scale:alternative(}{it:#}{c |}{it:lbl}{c |}{it:str}{cmd:)}}alternative used for normalizing scale{p_end}
{synopt :{opt nocons:tant}}suppress the alternative-specific constant terms{p_end}
{synopt :{opt altwise}}use alternativewise deletion instead of casewise deletion{p_end}
{synopt :{opth const:raints(estimation_options##constraints():constraints)}}apply specified
linear constraints{p_end}

{syntab:Model 2}
{synopt :{opth corr:elation(cmroprobit##correlation:correlation)}}correlation structure of the utility errors{p_end}
{synopt :{opth std:dev(cmroprobit##stddev:stddev)}}variance structure of the utility errors{p_end}
{synopt :{opt fact:or(#)}}use the factor covariance structure with dimension {it:#}{p_end}
{synopt :{opt struc:tural}}use the structural covariance parameterization;
default is the differenced covariance parameterization{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {cmd:oim},
{opt r:obust}, {opt cl:uster} {it:clustvar}, {opt opg},
{opt boot:strap}, or {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt notran:sform}}do not transform variance-covariance estimates to the standard deviation and correlation metric{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help cmroprobit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Integration}
{synopt :{opth intm:ethod(cmroprobit##seqtype:seqtype)}}type of quasi-uniform or pseudo-uniform sequence{p_end}
{synopt :{opt intp:oints(#)}}number of points in each sequence{p_end}
{synopt :{opt intb:urn(#)}}starting index in the Hammersley or Halton sequence{p_end}
{synopt :{cmdab:ints:eed(}{help cmroprobit##code:{it:code}}{c |}{it:#}{cmd:)}}pseudo-uniform random-number seed{p_end}
{synopt :{opt anti:thetics}}use antithetic draws{p_end}
{synopt :{opt nopiv:ot}}do not use integration interval pivoting{p_end}
{synopt :{opt initb:hhh(#)}}use the BHHH optimization algorithm for the first {it:#} iterations{p_end}
{synopt :{cmd:favor(}{cmdab:spe:ed}{c |}{cmdab:spa:ce}{cmd:)}}favor speed or space when generating integration points{p_end}

{syntab:Maximization}
{synopt :{it:{help cmroprobit##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt :{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{synoptset 30}{...}
{marker correlation}{...}
{synopthdr:correlation}
{synoptline}
{synopt :{opt uns:tructured}}one correlation parameter for each pair of alternatives; correlations with the {cmd:basealternative()} are zero; the default{p_end}
{synopt :{opt exc:hangeable}}one correlation parameter common to all pairs of alternatives; correlations with the {cmd:basealternative()} are zero{p_end}
{synopt :{opt ind:ependent}}constrain all correlation parameters to zero{p_end}
{synopt :{opt pat:tern} {it:matname}}user-specified matrix identifying the correlation pattern{p_end}
{synopt :{opt fix:ed} {it:matname}}user-specified matrix identifying the fixed and free correlation parameters{p_end}
{synoptline}

{marker stddev}{...}
{synopthdr:stddev}
{synoptline}
{synopt :{opt het:eroskedastic}}estimate standard deviation for each alternative; standard deviations for {cmd:basealternative()} and {cmd:scalealternative()} set to one{p_end}
{synopt :{opt hom:oskedastic}}all standard deviations are one{p_end}
{synopt :{opt pat:tern} {it:matname}}user-specified matrix identifying the standard deviation pattern{p_end}
{synopt :{opt fix:ed} {it:matname}}user-specified matrix identifying the fixed and free standard deviations{p_end}
{synoptline}

{marker seqtype}{...}
{synopthdr:seqtype}
{synoptline}
{synopt :{opt ham:mersley}}Hammersley point set{p_end}
{synopt :{opt hal:ton}}Halton point set{p_end}
{synopt :{opt ran:dom}}uniform pseudo-random point set{p_end}
{synoptline}

{p 4 6 2}
You must {cmd:cmset} your data before using {cmd:cmroprobit}; see
{manhelp cmset CM}.{p_end}
INCLUDE help fvvarlist2
{p 4 6 2}
{cmd:bootstrap},
{cmd:by},
{cmd:jackknife},
and
{cmd:statsby}
are allowed; see {help prefix}.{p_end}
INCLUDE help weight_boot
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s are allowed; see
{help weight}.{p_end}
{p 4 6 2}
{opt collinear} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp cmroprobit_postestimation CM:cmroprobit postestimation} for
features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Choice models > Rank-ordered probit model}


{marker description}{...}
{title:Description}

{pstd}
{cmd:cmroprobit} fits rank-ordered probit (ROP) models by using maximum
simulated likelihood (MSL).  The model allows you to relax the
independence of irrelevant alternatives (IIA) property that is
characteristic of the rank-ordered logistic model by estimating
covariances between the error terms for the alternatives.

{pstd}
{cmd:cmroprobit} allows two types of independent variables:
alternative-specific variables, in which the values of each variable vary with
each alternative, and case-specific variables, which vary with each case.

{pstd}
The estimation technique of {cmd:cmroprobit} is nearly identical to that of 
{cmd:cmmprobit}, and the two routines share many of the same options;
see {manhelp cmmprobit CM}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection CM cmroprobitQuickstart:Quick start}

        {mansection CM cmroprobitRemarksandexamples:Remarks and examples}

        {mansection CM cmroprobitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opth casevars(varlist)} specifies the case-specific variables that are
constant for each {cmd:case()}.  If there are a maximum of J alternatives,
there will be J - 1 sets of coefficients associated with {cmd:casevars()}.

{phang}
{opt reverse} directs {opt cmroprobit} to interpret the rank in {depvar} that
is smallest in value as the most preferred alternative.  By default, the rank
that is largest in value is the most preferred alternative.

{phang}
{cmd:basealternative(}{it:#}{c |}{it:lbl}{c |}{it:str}{cmd:)}
specifies the alternative used to normalize the level of utility.  The base
alternative may be specified as a number when the alternatives variable is
numeric, as a label when it is numeric and has a {help label:value label}, or
as a string when it is a string variable.  The standard deviation for the
utility error associated with the base alternative is fixed to one, and its
correlations with all other utility errors are set to zero.  The default is the
first alternative when sorted. If a {cmd:fixed} or {cmd:pattern} matrix is
given in the {cmd:stddev()} and {cmd:correlation()} options, the
{cmd:basealternative()} will be implied by the fixed standard deviations and
correlations in the matrix specifications.  {cmd:basealternative()} cannot be
equal to {cmd:scalealternative()}.

{phang}
{cmd:scalealternative(}{it:#}{c |}{it:lbl}{c |}{it:str}{cmd:)}
specifies the alternative used to normalize the scale of the utility. The
scale alternative may be specified as a number, label, or string.  The default
is to use the second alternative when sorted.  If a {cmd:fixed} or
{cmd:pattern} matrix is given in the {cmd:stddev()} option, the
{cmd:scalealternative()} will be implied by the fixed standard deviations in
the matrix specification.  {cmd:scalealternative()} cannot be equal to
{cmd:basealternative()}.

{pmore}
If a {cmd:fixed} or {cmd:pattern} matrix is given for the {cmd:stddev()}
option, the base alternative and scale alternative are implied by
the standard deviations and correlations in the matrix specifications,
and they need not be specified in the {cmd:basealternative()} and
{cmd:scalealternative()} options.

{phang}
{opt noconstant} suppresses the J - 1 alternative-specific constant terms.

{phang}
{opt altwise} specifies that alternativewise deletion be used when
omitting observations because of missing values in your variables.  The default
is to use casewise deletion; that is, the entire group of observations
making up a case is omitted if any missing values are encountered.  This
option does not apply to observations that are excluded by the {cmd:if} or
{cmd:in} qualifier or the {cmd:by} prefix; these observations are always
handled alternativewise regardless of whether {cmd:altwise} is
specified.

{phang}
{opt constraints(constraints)}; see
{helpb estimation options:[R] Estimation options}.

{dlgtab:Model 2}

{phang}
{opt correlation(correlation)} specifies the correlation structure of
the utility (latent-variable) errors.

{phang2}
{cmd:correlation(unstructured)} is the most general and has
{bind:J(J - 3)/2 + 1} unique correlation parameters.  This is the default
unless {cmd:stddev()} or {cmd:structural} is specified.

{phang2}
{cmd:correlation(exchangeable)} provides for one correlation coefficient
common to all utilities, except the utility associated with the
{cmd:basealternative()} option.

{phang2}
{cmd:correlation(independent)} assumes that all correlations are zero.

{phang2}
{cmd:correlation(pattern} {it:matname}{cmd:)} and
{cmd:correlation(fixed} {it:matname}{cmd:)} give you more flexibility in
defining the correlation structure.  See
{mansection CM cmmprobitRemarksandexamplesvariance:{it:Covariance structures}}
in {bf:[CM] cmmprobit} for more information.

{phang}
{opt stddev(stddev)} specifies the variance structure of the
utility (latent-variable) errors.

{phang2}
{cmd:stddev(heteroskedastic)} is the most general and has J - 2 estimable
parameters.  The standard deviations of the utility errors for the
alternatives specified in {cmd:basealternative()} and {cmd:scalealternative()}
are fixed to one.

{phang2}
{cmd:stddev(homoskedastic)} constrains all the standard deviations to equal
one.

{phang2}
{cmd:stddev(pattern} {it:matname}{cmd:)} and
{cmd:stddev(fixed} {it:matname}{cmd:)} give
you added flexibility in defining the standard deviation parameters.  See
{mansection CM cmmprobitRemarksandexamplesvariance:{it:Covariance structures}}
in {bf:[CM] cmmprobit} for more information.

{phang}
{opt factor(#)} requests that the factor covariance structure of
dimension {it:#} be used.  The {cmd:factor()} option can be used with the
{cmd:structural} option but cannot be used with {cmd:stddev()} or
{cmd:correlation()}.  A {it:#} x J (or {bind:{it:#} x J - 1}) matrix, {bf:C},
is used to factor the covariance matrix as {bind:I + {bf:C}'{bf:C}}, where I is
the identity matrix of dimension J (or J - 1).  The column dimension of
{bf:C} depends on whether the covariance is structural or differenced.  The
row dimension of {bf:C}, {it:#}, must be less than or equal to
{bind:floor[{J(J - 1)/2 - 1}/(J - 2)]}, because there are only
{bind:J(J - 1)/2 - 1} identifiable covariance parameters.  This covariance
parameterization may be useful for reducing the number of covariance parameters
that need to be estimated.

{pmore}
If the covariance is structural, the column of {bf:C} corresponding to the
base alternative contains zeros.  The column corresponding to the scale
alternative has a one in the first row and zeros elsewhere.  If the covariance
is differenced, the column corresponding to the scale alternative (differenced
with the base) has a one in the first row and zeros elsewhere.

{phang}
{cmd:structural} requests the J x J structural covariance
parameterization instead of the default {bind:J - 1 x J - 1} differenced
covariance parameterization (the covariance of the utility errors differenced
with that of the base alternative).  The differenced covariance
parameterization will achieve the same MSL regardless of the choice of
{cmd:basealternative()} and {cmd:scalealternative()}.  On the other hand, the
structural covariance parameterization imposes more normalizations that may
bound the model away from its maximum likelihood and thus prevent convergence
with some datasets or choices of {cmd:basealternative()} and
{cmd:scalealternative()}.

{dlgtab:SE/Robust}

INCLUDE help vce_asymptall

{pmore}
If specifying {cmd:vce(bootstrap)} or {cmd:vce(jackknife)}, you must
also specify {cmd:basealternative()} and {cmd:scalealternative()}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options:[R] Estimation options}.

{phang}
{opt notransform} prevents retransforming the Cholesky-factored
covariance estimates to the correlation and standard
deviation metric.

{pmore}
This option has no effect if {cmd:structural} is not specified because the
default differenced covariance estimates have no interesting
interpretation as correlations and standard deviations.  {cmd:notransform}
also has no effect if the {cmd:correlation()} and {cmd:stddev()} options are
specified with anything other than their default values.  Here it is
generally not possible to factor the covariance matrix, so
optimization is already performed using the standard deviation and correlation
representations.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] Estimation options}.

INCLUDE help displayopts_list

{dlgtab:Integration}

{phang}
{cmd:intmethod(hammersley{c |}halton{c |}random)} specifies the
method of generating the point sets used in the quasi-Monte Carlo 
integration of the multivariate normal density.  {cmd:intmethod(hammersley)},
the default, uses the Hammersley sequence; {cmd:intmethod(halton)} uses the
Halton sequence; and {cmd:intmethod(random)} uses a sequence of uniform random
numbers.

{phang}
{opt intpoints(#)} specifies the number of points to use in the
Monte Carlo integration.
If option {cmd:intmethod(hammersley)} or {cmd:intmethod(halton)} is used, the default is
{bind:500 + floor(2.5 sqrt[N_c{ln(k + 5) + v}])},
where N_c is the number of cases, k is the number of coefficients in the model,
and v is the number of variance parameters.  If {cmd:intmethod(random)} is
used, the number of points is the above times 2.  Larger values of
{cmd:intpoints()} provide better approximations of the log likelihood at the
cost of additional computation time.

{phang}
{opt intburn(#)} specifies where in the Hammersley or Halton sequence
to start, which helps reduce the correlation between the sequences of each
dimension.  The default is 0.  This option may not be specified with
{cmd:intmethod(random)}.

{marker code}{...}
{phang}
{cmd:intseed(}{it:code}{c |}{it:#}{cmd:)} specifies the seed to use for
generating the uniform pseudo-random sequence.  This option may be specified
only with {cmd:intmethod(random)}.  {it:code} refers to a string that records
the state of the random-number generator {cmd:runiform()}; see
{helpb set seed:[R] set seed}.  An integer value {it:#} may be used also.  The
default is to use the current seed value from Stata's uniform random-number
generator, which can be obtained from {cmd:c(rngstate)}.

{phang}
{cmd:antithetics} specifies that antithetic draws be used.  The antithetic
draw for the J - 1 vector uniform-random variables, {bf:x}, is
1 - {bf:x}.

{phang}
{opt nopivot} turns off integration interval pivoting.  By default, 
{opt cmroprobit} will pivot the wider intervals of integration to the interior
of the multivariate integration.  This improves the accuracy of the quadrature
estimate.  However, discontinuities may result in the computation of numerical
second-order derivatives using finite differencing (for the
Newton-Raphson optimize technique, {cmd:tech(nr)}) when few simulation
points are used, resulting in a non-positive-definite Hessian.
{cmd:cmroprobit} uses the Broyden-Fletcher-Goldfarb-Shanno optimization
algorithm, by default, which does not require computing the Hessian numerically
using finite differencing.

{phang}
{opt initbhhh(#)} specifies that the Berndt-Hall-Hall-Hausman (BHHH) algorithm
be used for the initial {it:#} optimization steps.  This option is the only way
to use the BHHH algorithm along with other optimization techniques.
The algorithm switching feature of {cmd:ml}'s {cmd:technique()} option cannot
include {cmd:bhhh}.

{phang}
{cmd:favor(speed{c |}space)} instructs {cmd:cmroprobit} to favor either
speed or space when generating the integration points.  {cmd:favor(speed)} is
the default.  When favoring speed, the integration points are generated once
and stored in memory, thus increasing the speed of evaluating the likelihood.
This speed increase can be seen when there are many cases or when the user
specifies many integration points, {opt intpoints(#)}.
When favoring space, the integration points are generated repeatedly with each
likelihood evaluation.

{pmore}
For unbalanced data, where the number of alternatives varies with each case, the
estimates computed using {cmd:intmethod(random)} will vary slightly between
{cmd:favor(speed)} and {cmd:favor(space)}.  This is because the uniform
sequences will not be identical, even when initiating the sequences using the
same uniform seed, {cmd:intseed(}{it:code}{c |}{it:#}{cmd:)}.  For
{cmd:favor(speed)}, {cmd:ncase} blocks of
{opt intpoints(#)} x J - 2 uniform points are generated,
where J is the maximum number of alternatives.  For {cmd:favor(space)}, the
column dimension of the matrices of points varies with the number of
alternatives that each case has.

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
The following options may be particularly useful in obtaining 
convergence with {cmd:cmroprobit}:
{opt difficult},
{opt technique(algorithm_spec)},
{opt nrtolerance(#)},
{opt nonrtolerance}, and
{opt from(init_specs)}.

{pmore}
If {opt technique()} contains more than one algorithm specification, 
{cmd:bhhh} cannot be one of them.  To use the BHHH 
algorithm with another algorithm, use the {cmd:initbhhh()} 
option, and specify the other algorithm in {cmd:technique()}.

{pmore}
Setting the optimization type to {cmd:technique(bhhh)} resets the default
{it:vcetype} to {cmd:vce(opg)}.

{pmore}
The default optimization technique is {cmd:technique(bfgs)}.

{pmore}
When you specify {cmd:from(}{it:matname} [{cmd:, copy}]{cmd:)}, the values in
{it:matname} associated with the utility error variances must be for
the log-transformed standard deviations and inverse-hyperbolic
tangent-transformed correlations.  This option makes using the coefficient
vector from a previously fitted {cmd:cmroprobit} model convenient as a starting
point.

{pstd}
The following options are available with {cmd:cmroprobit} but are not shown in
the dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
{helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse wlsrank}{p_end}
{phang2}{cmd:. generate currentjob = 1 if low==1}{p_end}
{phang2}{cmd:. replace currentjob = 2 if low==0 & high==0}{p_end}
{phang2}{cmd:. replace currentjob = 3 if high==1}{p_end}
{phang2}{cmd:. label define current 1 "Low" 2 "Neither" 3 "High"}{p_end}
{phang2}{cmd:. label values currentjob current}{p_end}
{phang2}{cmd:. cmset id jobchar}{p_end}

{pstd}Fit rank-ordered probit choice model{p_end}
{phang2}{cmd:. cmroprobit rank i.currentjob if noties, casevars(i.female score) reverse}{p_end}

{pstd}Same as above, but with factor covariance structure of dimension 1{p_end}
{phang2}{cmd:. cmroprobit rank i.currentjob if noties, casevars(i.female score) factor(1)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:cmroprobit} stores the following in {cmd:e()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Scalars}{p_end}
{synopt :{cmd:e(N)}}number of observations{p_end}
{synopt :{cmd:e(N_case)}}number of cases{p_end}
{synopt :{cmd:e(N_ties)}}number of ties{p_end}
{synopt :{cmd:e(N_ic)}}N for Bayesian information criterion
(BIC){p_end}
{synopt :{cmd:e(N_clust)}}number of clusters{p_end}
{synopt :{cmd:e(k)}}number of parameters{p_end}
{synopt :{cmd:e(k_alt)}}number of alternatives{p_end}
{synopt :{cmd:e(k_indvars)}}number of alternative-specific variables{p_end}
{synopt :{cmd:e(k_casevars)}}number of case-specific variables{p_end}
{synopt :{cmd:e(k_sigma)}}number of variance estimates{p_end}
{synopt :{cmd:e(k_rho)}}number of correlation estimates{p_end}
{synopt :{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt :{cmd:e(k_eq_model)}}number of equations in overall model
test{p_end}
{synopt :{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt :{cmd:e(ll)}}log simulated-likelihood{p_end}
{synopt :{cmd:e(const)}}constant indicator{p_end}
{synopt :{cmd:e(i_base)}}base alternative index{p_end}
{synopt :{cmd:e(i_scale)}}scale alternative index{p_end}
{synopt :{cmd:e(mc_points)}}number of Monte Carlo replications{p_end}
{synopt :{cmd:e(mc_burn)}}starting sequence index{p_end}
{synopt :{cmd:e(mc_antithetics)}}antithetics indicator{p_end}
{synopt :{cmd:e(reverse)}}{cmd:1} if minimum rank is best, {cmd:0} if maximum
rank is best{p_end}
{synopt :{cmd:e(chi2)}}chi-squared{p_end}
{synopt :{cmd:e(p)}}p-value for model test{p_end}
{synopt :{cmd:e(fullcov)}}unstructured covariance indicator{p_end}
{synopt :{cmd:e(structcov)}}{cmd:1} if structured covariance, {cmd:0}
otherwise{p_end}
{synopt :{cmd:e(cholesky)}}Cholesky-factored covariance indicator{p_end}
{synopt :{cmd:e(alt_min)}}minimum number of alternatives{p_end}
{synopt :{cmd:e(alt_avg)}}average number of alternatives{p_end}
{synopt :{cmd:e(alt_max)}}maximum number of alternatives{p_end}
{synopt :{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt :{cmd:e(ic)}}number of iterations{p_end}
{synopt :{cmd:e(rc)}}return code{p_end}
{synopt :{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{p2col 5 25 29 2: Macros}{p_end}
{synopt :{cmd:e(cmd)}}{cmd:cmroprobit}{p_end}
{synopt :{cmd:e(cmdline)}}command as typed{p_end}
{synopt :{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt :{cmd:e(caseid)}}name of case ID variable{p_end}
{synopt :{cmd:e(altvar)}}name of alternatives variable{p_end}
{synopt :{cmd:e(alteqs)}}alternative equation names{p_end}
{synopt :{cmd:e(alt}{it:#}{cmd:)}}alternative labels{p_end}
{synopt :{cmd:e(wtype)}}weight type{p_end}
{synopt :{cmd:e(wexp)}}weight expression{p_end}
{synopt :{cmd:e(marktype)}}{cmd:casewise} or {cmd:altwise}, type of
markout{p_end}
{synopt :{cmd:e(key_N_ic)}}{cmd:cases}, key for N for
Bayesian information criterion (BIC){p_end}
{synopt :{cmd:e(title)}}title in estimation output{p_end}
{synopt :{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt :{cmd:e(correlation)}}correlation structure{p_end}
{synopt :{cmd:e(stddev)}}variance structure{p_end}
{synopt :{cmd:e(chi2type)}}{cmd:Wald}, type of model chi-squared test{p_end}
{synopt :{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt :{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt :{cmd:e(opt)}}type of optimization{p_end}
{synopt :{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to
perform maximization or minimization{p_end}
{synopt :{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt :{cmd:e(mc_method)}}technique used to generate sequences{p_end}
{synopt :{cmd:e(mc_rngstate)}}random-number state used{p_end}
{synopt :{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt :{cmd:e(technique)}}maximization technique{p_end}
{synopt :{cmd:e(datasignature)}}the checksum{p_end}
{synopt :{cmd:e(datasignaturevars)}}variables used in calculation of
checksum{p_end}
{synopt :{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt :{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt :{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt :{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt :{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt :{cmd:e(marginsdefault)}}default {cmd:predict()} specification for
{cmd:margins}{p_end}
{synopt :{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt :{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 25 29 2: Matrices}{p_end}
{synopt :{cmd:e(b)}}coefficient vector{p_end}
{synopt :{cmd:e(stats)}}alternative statistics{p_end}
{synopt :{cmd:e(stdpattern)}}variance pattern{p_end}
{synopt :{cmd:e(stdfixed)}}fixed and free standard deviations{p_end}
{synopt :{cmd:e(altvals)}}alternative values{p_end}
{synopt :{cmd:e(altfreq)}}alternative frequencies{p_end}
{synopt :{cmd:e(alt_casevars)}}indicators for estimated case-specific
coefficients -- {cmd:e(k_alt)} x {cmd:e(k_casevars)}{p_end}
{synopt :{cmd:e(corpattern)}}correlation structure{p_end}
{synopt :{cmd:e(corfixed)}}fixed and free correlations{p_end}
{synopt :{cmd:e(Cns)}}constraints matrix{p_end}
{synopt :{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt :{cmd:e(gradient)}}gradient vector{p_end}
{synopt :{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt :{cmd:e(V_modelbased)}}model-based variance{p_end}

{p2col 5 25 29 2: Functions}{p_end}
{synopt :{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
