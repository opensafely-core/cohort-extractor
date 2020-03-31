{smcl}
{* *! version 1.2.9  18feb2020}{...}
{viewerdialog exlogistic "dialog exlogistic"}{...}
{vieweralsosee "[R] exlogistic" "mansection R exlogistic"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] exlogistic postestimation" "help exlogistic_postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] binreg" "help binreg"}{...}
{vieweralsosee "[R] clogit" "help clogit"}{...}
{vieweralsosee "[R] expoisson" "help expoisson"}{...}
{vieweralsosee "[R] logistic" "help logistic"}{...}
{vieweralsosee "[R] logit" "help logit"}{...}
{viewerjumpto "Syntax" "exlogistic##syntax"}{...}
{viewerjumpto "Menu" "exlogistic##menu"}{...}
{viewerjumpto "Description" "exlogistic##description"}{...}
{viewerjumpto "Links to PDF documentation" "exlogistic##linkspdf"}{...}
{viewerjumpto "Options" "exlogistic##options"}{...}
{viewerjumpto "Technical note" "exlogistic##technote"}{...}
{viewerjumpto "Examples" "exlogistic##examples"}{...}
{viewerjumpto "Stored results" "exlogistic##results"}{...}
{viewerjumpto "Reference" "exlogistic##reference"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[R] exlogistic} {hline 2}}Exact logistic regression{p_end}
{p2col:}({mansection R exlogistic:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 18 2}
{cmd:exlogistic} {it:depvar} {indepvars} {ifin}
[{it:{help exlogistic##weight:weight}}]
[{cmd:,} {it:options}] 

{phang}
{it:depvar} can be specified as a zero or nonzero variable or the number of
positive outcomes within each trial. For a zero or nonzero variable, zero
indicates failure and nonzero indicates success.  To specify {it:depvar} as
the number of positive outcomes, you must also specify 
{opt binomial(varname|#)}.

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Model}
{synopt :{opth cond:vars(varlist)}}condition on variables in {it:varlist}{p_end}
{synopt :{opth gr:oup(varname)}}groups or strata are stratified by unique values of {it:varname}{p_end}
{synopt :{cmdab:bin:omial(}{varname}|{it:#}{cmd:)}}data are in binomial form and the number of trials is contained in {it:varname} or in {it:#}{p_end}
{synopt :{opt estc:onstant}}estimate constant term; do not condition on the number of successes{p_end}
{synopt :{opt nocons:tant}}suppress constant term{p_end}

{syntab :Terms}
{synopt :{opt term:s(termsdef)}}terms definition{p_end}

{syntab :Options}
{synopt :{cmdab:mem:ory(}{it:#}[{cmd:b}|{cmd:k}|{cmd:m}|{cmd:g}]{cmd:)}}set limit on memory usage; default is {cmd:memory(10m)}{p_end}
{synopt :{opth sav:ing(exlogistic##saving:filename)}}save the joint conditional distribution to {it:filename}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt coef}}report estimated coefficients{p_end}
{synopt :{opt t:est(testopt)}}report p-value for observed
sufficient statistic, conditional scores test, or conditional probabilities
test{p_end}
{synopt :{opth mue(varlist)}}compute the median unbiased estimates for {it:varlist}{p_end}
{synopt :{opt midp}}use the mid-p-value rule{p_end}
{synopt :[{cmd:no}]{cmd:log}}display or suppress the enumeration log; default
is to display{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{cmd:by}, {cmd:statsby}, and {cmd:xi} are allowed; see {help prefix}.{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
See {manhelp exlogistic_postestimation R:exlogistic postestimation} for
features available after estimation.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Exact statistics > Exact logistic regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:exlogistic} fits an exact logistic regression model,  which produces
more accurate inference in small samples than the standard
maximum-likelihood-based logistic regression estimator.  It can also
better deal with completely determined outcomes.  {cmd:exlogistic} with the
{opth group(varname)} option conditions on the number of positive outcomes
within stratum and is an alternative to the conditional (fixed-effects)
logistic regression estimator.

{pstd}
Unlike Stata's other estimation commands, {cmd:exlogistic} must perform
hypothesis tests during estimation rather than during postestimation with
standard postestimation commands.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R exlogisticQuickstart:Quick start}

        {mansection R exlogisticRemarksandexamples:Remarks and examples}

        {mansection R exlogisticMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{marker condvars}{...}
{phang}
{opth condvars(varlist)} specifies variables whose parameter estimates
are not of interest to you.  You can save substantial computer time and memory
moving such variables from {indepvars} to {cmd:condvars()}.  Understand
that you will get the same results for {cmd:x1} and {cmd:x3} whether you type

            {cmd:. exlogistic y x1 x2 x3 x4}

{pmore}
or 

            {cmd:. exlogistic y x1 x3, condvars(x2 x4)}

{phang}
{opth group(varname)} specifies the variable defining the strata, if
any.  A constant term is assumed for each stratum identified in {it:varname},
and the sufficient statistics for {indepvars} are conditioned on the
observed number of successes within each group. This makes the model estimated
equivalent to that estimated by {cmd:clogit}, Stata's conditional logistic
regression command (see {manhelp clogit R}).  {cmd:group()} may not be
specified with {cmd:noconstant} or {cmd:estconstant}.

{marker binomial()}{...}
{phang}
{cmd:binomial(}{varname}|{it:#}{cmd:)} indicates that the data are in
binomial form and {depvar} contains the number of successes.
{it:varname} contains the number of trials for each observation.  If all
observations have the same number of trials, you can instead specify the
number as an integer.  The number of trials must be a positive integer at
least as great as the number of successes.  If {cmd:binomial()} is not
specified, the data are assumed to be Bernoulli, meaning that {it:depvar}
equaling zero or nonzero records one failure or success.

{phang}
{cmd:estconstant} estimates the constant term.  By default, the models are
assumed to have an intercept (constant), but the value of the intercept is not
calculated.  That is, the conditional distribution of the sufficient
statistics for the {indepvars} is computed given the number of successes
in {depvar}, thus conditioning out the constant term of the model.
Use {cmd:estconstant} if you want the estimate of the intercept reported.
{cmd:estconstant} may not be specified with {cmd:group()}.

{phang}
{opt noconstant}; see
{helpb estimation options##noconstant:[R] Estimation options}.  
{cmd:noconstant} may not be specified with {cmd:group()}.

{dlgtab:Terms}

{phang}
{marker terms}{...}
{cmd:terms(}{it:termname} {cmd:=} {it:variable} ... {it:variable}[{cmd:,}
{it:termname} {cmd:=} {it:variable} ... {it:variable} ...]{cmd:)} 
defines additional terms of the model on which you want {cmd:exlogistic} to
perform joint-significance hypothesis tests. By default, {cmd:exlogistic}
reports tests individually on each variable in {indepvars}.  For instance,
if variables {cmd:x1} and {cmd:x3} are in {it:indepvars}, and you want to
jointly test their significance, specify {cmd:terms(t1=x1 x3)}.  To also test
the joint significance of {cmd:x2} and {cmd:x4}, specify
{cmd:terms(t1=x1 x3, t2=x2 x4)}.  Each variable can be assigned to only one
term.

{pmore}
Joint tests are computed only for the conditional scores tests and the
conditional probabilities tests.  See {helpb exlogistic##test:test()} below.

{dlgtab:Options}

{phang} {marker memory} 
{cmd:memory(}{it:#}[{cmd:b}|{cmd:k}|{cmd:m}|{cmd:g}]{cmd:)} sets a limit on the
amount of memory {cmd:exlogistic} can use when computing the conditional
distribution of the parameter sufficient statistics.  The default is
{cmd:memory(10m)}, where {cmd:m} stands for megabyte, or 1,048,576 bytes.  The
following are also available: {cmd:b} stands for byte; {cmd:k} stands for
kilobyte, which is equal to 1,024 bytes; and {cmd:g} stands for gigabyte, which
is equal to 1,024 megabytes.  The minimum setting allowed is {cmd:1m} and the
maximum is {cmd:2048m} or {cmd:2g}, but do not attempt to use more memory than
is available on your computer.  Also see the
{help exlogistic##enumerations:technical note} on counting the conditional
distribution.

{phang}
{marker saving}
{cmd:saving(}{it:{help filename}}[{cmd:,} {cmd:replace}]{cmd:)} saves the joint
conditional distribution to {it:filename}.  This distribution is conditioned on
those variables specified in {opt condvars()}.  Use {cmd:replace} to replace an
existing file with {it:filename}.  A Stata data file is created containing all
the feasible values of the parameter sufficient statistics.  The variable names
are the same as those in {indepvars}, in addition to a variable named {cmd:_f_}
containing the feasible value frequencies (sometimes referred to as the
condition numbers).

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] Estimation options}.
The {opt level(#)} option will not work on replay because confidence intervals
are based on estimator-specific enumerations.  To change the confidence level,
you must refit the model.

{phang}
{opt coef} reports the estimated coefficients rather than odds ratios
(exponentiated coefficients).  {opt coef} may be specified when the model is
fit or upon replay.  {opt coef} affects only how
results are displayed and not how they are estimated.

{phang}
{marker test}
{cmd:test(}{opt suff:icient}|{cmd:score}|{opt p:robability)} reports the
p-value associated with the observed sufficient statistics, the conditional
scores tests, or the conditional probabilities tests, respectively.  The
default is {cmd:test(sufficient)}.  If {cmd:terms()} is included in the 
specification, the conditional scores test and the conditional probabilities
test are applied to each term providing conditional inference for several
parameters simultaneously.  All the statistics are computed at estimation
time regardless of which is specified. Each statistic may thus also be
displayed postestimation without having to refit the model; see
{helpb exlogistic postestimation:[R] exlogistic postestimation}.

{phang}
{opth mue(varlist)} specifies that median unbiased estimates (MUEs) be reported
for the variables in {it:varlist}.  By default, the conditional maximum
likelihood estimates (CMLEs) are reported, except for those parameters for
which the CMLEs are infinite.  Specify {cmd:mue(_all)} if you want MUEs for
all the {indepvars}.

{phang}
{opt midp} instructs {cmd:exlogistic} to use the mid-p-value rule when
computing the MUEs, p-values, and confidence intervals.
This adjustment is for the discreteness of the distribution and halves
the value of the discrete probability of the observed statistic before adding
it to the p-value.  The mid-p-value rule cannot be applied to MUEs
whose corresponding parameter CMLE is infinite.

{phang}
{opt log} and {opt nolog} specify whether to display of the enumeration log,
which shows the progress of computing the conditional distribution of the
sufficient statistics.  The enumeration log is displayed by default unless you
used {cmd:set iterlog off} to suppress it; see {cmd:set iterlog} in
{manhelpi set_iter R:set iter}.


{marker technote}{...}
{marker enumerations}{...}
{title:Technical note}

{pstd}
The {opt memory(#)} option limits the amount of memory that
{cmd:exlogistic} will consume when computing the conditional distribution of
the parameter sufficient statistics.  {cmd:memory()} is independent of the data
maximum memory setting (see {cmd:set max_memory} in
{helpb memory:[D] memory}), and it is possible for {cmd:exlogistic} to
exceed the memory limit specified in {cmd:set max_memory} without terminating.
By default, a log is provided that displays the number of enumerations (the
size of the conditional distribution) after processing each observation.
Typically, you will see the number of enumerations increase, and then at some
point they will decrease as the multivariate shift algorithm
({help exlogistic##HMP1987:Hirji, Mehta, and Patel 1987}) determines that some
of the enumerations cannot achieve the observed sufficient statistics of the
conditioning variables.  When the algorithm is complete, however, it is
necessary to store the conditional distribution of the parameter sufficient
statistics as a dataset.  It is possible, therefore, to get a memory error when
the algorithm has completed if there is not enough memory to store the
conditional distribution.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse hiv1}{p_end}

{pstd}Perform exact logistic regression of {cmd:hiv} on {cmd:cd4} and {cmd:cd8}{p_end}
{phang2}{cmd:. exlogistic hiv cd4 cd8}{p_end}

{pstd}Replay results, but report estimated coefficients rather than odds
ratios{p_end}
{phang2}{cmd:. exlogistic, coef}{p_end}

{pstd}Replay results and report conditional scores test{p_end}
{phang2}{cmd:. exlogistic, test(score)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:exlogistic} stores the following in {cmd:e()}:

{synoptset 22 tabbed}{...}
{syntab:Scalars}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k_groups)}}number of groups{p_end}
{synopt:{cmd:e(n_possible)}}number of distinct possible outcomes where
      {cmd:sum(sufficient)} equals observed {cmd:e(sufficient)}{p_end}
{synopt:{cmd:e(n_trials)}}binomial number-of-trials parameter{p_end}
{synopt:{cmd:e(sum_y)}}sum of {it:depvar}{p_end}
{synopt:{cmd:e(k_indvars)}}number of independent variables{p_end}
{synopt:{cmd:e(k_terms)}}number of model terms{p_end}
{synopt:{cmd:e(k_condvars)}}number of conditioning variables{p_end}
{synopt:{cmd:e(condcons)}}conditioned on the constant(s) indicator{p_end}
{synopt:{cmd:e(midp)}}mid-p-value rule indicator{p_end}
{synopt:{cmd:e(eps)}}relative difference tolerance{p_end}

{syntab:Macros}
{synopt:{cmd:e(cmd)}}{cmd:exlogistic}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(indvars)}}independent variables{p_end}
{synopt:{cmd:e(condvars)}}conditional variables{p_end}
{synopt:{cmd:e(groupvar)}}group variable{p_end}
{synopt:{cmd:e(binomial)}}binomial number-of-trials variable{p_end}
{synopt:{cmd:e(terms)}}term names set in option {cmd:terms()}{p_end}
{synopt:{cmd:e(level)}}confidence level{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(datasignature)}}the checksum{p_end}
{synopt:{cmd:e(datasignaturevars)}}variables used in calculation of checksum{p_end}
{synopt:{cmd:e(properties)}}{cmd:b}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}

{syntab:Matrices}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(mue_indicators)}}indicator for elements of {cmd:e(b)} estimated
using MUE instead of CMLE{p_end}
{synopt:{cmd:e(se)}}{cmd:e(b)} standard errors (CMLEs only){p_end}
{synopt:{cmd:e(ci)}}matrix of {cmd:e(level)} confidence intervals for {cmd:e(b)}{p_end}
{synopt:{cmd:e(sum_y_groups)}}sum of {cmd:e(depvar)} for each group{p_end}
{synopt:{cmd:e(N_g)}}number of observations in each group{p_end}
{synopt:{cmd:e(sufficient)}}sufficient statistics for {cmd:e(b)}{p_end}
{synopt:{cmd:e(p_sufficient)}}p-value for {cmd:e(sufficient)}{p_end}
{synopt:{cmd:e(scoretest)}}conditional scores tests for {it:indepvars}{p_end}
{synopt:{cmd:e(p_scoretest)}}p-value for {cmd:e(scoretest)}{p_end}
{synopt:{cmd:e(probtest)}}conditional probabilities tests for {it:indepvars}{p_end}
{synopt:{cmd:e(p_probtest)}}p-value for {cmd:e(probtest)}{p_end}
{synopt:{cmd:e(scoretest_m)}}conditional scores tests for model terms{p_end}
{synopt:{cmd:e(p_scoretest_m)}}p-value for {cmd:e(scoretest_m)}{p_end}
{synopt:{cmd:e(probtest_m)}}conditional probabilities tests for model terms{p_end}
{synopt:{cmd:e(p_probtest_m)}}p-value for {cmd:e(probtest_m)}{p_end}

{syntab:Function}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker reference}{...}
{title:Reference}

{marker HMP1987}{...}
{phang}
Hirji, K. F., C. R. Mehta, and N. R. Patel. 1987.
Computing distributions for exact logistic regression.
{it:Journal of the American Statistical Association} 82: 1110-1117.
{p_end}
