{smcl}
{* *! version 1.2.5  11dec2018}{...}
{viewerdialog expoisson "dialog expoisson"}{...}
{vieweralsosee "[R] expoisson" "mansection R expoisson"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] expoisson postestimation" "help expoisson postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] poisson" "help poisson"}{...}
{vieweralsosee "[XT] xtpoisson" "help xtpoisson"}{...}
{viewerjumpto "Syntax" "expoisson##syntax"}{...}
{viewerjumpto "Menu" "expoisson##menu"}{...}
{viewerjumpto "Description" "expoisson##description"}{...}
{viewerjumpto "Links to PDF documentation" "expoisson##linkspdf"}{...}
{viewerjumpto "Options" "expoisson##options"}{...}
{viewerjumpto "Technical note" "expoisson##technote"}{...}
{viewerjumpto "Examples" "expoisson##examples"}{...}
{viewerjumpto "Stored results" "expoisson##results"}{...}
{viewerjumpto "Reference" "expoisson##reference"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[R] expoisson} {hline 2}}Exact Poisson regression{p_end}
{p2col:}({mansection R expoisson:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 18 2}
{cmd:expoisson} {depvar} {indepvars} {ifin}
[{it:{help expoisson##weight:weight}}]
[{cmd:,} {it:options}] 

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Model}
{synopt :{opth cond:vars(varlist)}}condition on variables in {it:varlist}{p_end}
{synopt :{opth gr:oup(varname)}}groups/strata are stratified by unique values of {it:varname}{p_end}
{synopt :{opth exp:osure(varname:varname_e)}}include ln({it:varname_e}) in
model with coefficient constrained to 1{p_end}
{synopt :{opth off:set(varname:varname_o)}}include {it:varname_o} in model with
coefficient constrained to 1{p_end}

{syntab :Options}
{synopt :{cmdab:mem:ory(}{it:#}[{cmd:b}|{cmd:k}|{cmd:m}|{cmd:g}]{cmd:)}}set limit on memory usage; default is {cmd:memory(25m)}{p_end}
{synopt :{opth sav:ing(expoisson##saving:filename)}}save the joint conditional distribution to {it:filename}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt irr}}report incidence-rate ratios{p_end}
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
See {manhelp expoisson_postestimation R:expoisson postestimation} for features
available after estimation.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Exact statistics > Exact Poisson regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:expoisson} fits an exact Poisson regression model, which produces more
accurate inference in small samples than standard
maximum-likelihood-based Poisson regression.  For stratified data,
{cmd:expoisson} conditions on the number of events in each stratum and is an
alternative to fixed-effects Poisson regression.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R expoissonQuickstart:Quick start}

        {mansection R expoissonRemarksandexamples:Remarks and examples}

        {mansection R expoissonMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{marker condvars}{...}
{phang}
{opth condvars(varlist)} specifies variables whose parameter estimates
are not of interest to you.  You can save substantial computer time and memory
by moving such variables from {indepvars} to {cmd:condvars()}.  Understand
that you will get the same results for {cmd:x1} and {cmd:x3} whether you type

            {cmd:. expoisson y x1 x2 x3 x4}

{pmore}
or 

            {cmd:. expoisson y x1 x3, condvars(x2 x4)}

{phang}
{opth group(varname)} specifies the variable defining the strata, if
any.  A constant term is assumed for each stratum identified in {it:varname},
and the sufficient statistics for {indepvars} are conditioned on the
observed number of successes within each group (as well as other variables in
the model).  The group variable must be integer valued.

{phang}
{opth exposure:(varname:varname_e)}, {opt offset(varname_o)}; see
{helpb estimation options##noconstant:[R] Estimation options}.

{dlgtab:Options}

{phang} {marker memory} 
{cmd:memory(}{it:#}[{cmd:b}|{cmd:k}|{cmd:m}|{cmd:g}]{cmd:)} sets a limit on the
amount of memory {cmd:expoisson} can use when computing the conditional
distribution of the parameter sufficient statistics.  The default is
{cmd:memory(25m)}, where {cmd:m} stands for megabyte, or 1,048,576 bytes.  The
following are also available: {cmd:b} stands for byte; {cmd:k} stands for
kilobyte, which is equal to 1,024 bytes; and {cmd:g} stands for gigabyte, which
is equal to 1,024 megabytes.  The minimum setting allowed is {cmd:1m} and the
maximum is {cmd:2048m} or {cmd:2g}, but do not attempt to use more memory than
is available on your computer.  Also see the
{help expoisson##enumerations:technical note} on counting the conditional
distribution.

{phang}
{marker saving}
{cmd:saving(}{it:{help filename}}[{cmd:,} {cmd:replace}]{cmd:)} saves the joint
conditional distribution for each independent variable specified in
{indepvars}.  There is one file for each variable, and it is named using the
prefix {it:filename} with the variable name appended.  For example,
{cmd:saving(mydata)} with an independent variable named {cmd:X} would generate
a data file named {cmd:mydata_X.dta}.  Use {cmd:replace} to replace an existing
file.  Each file contains the conditional distribution for one of the
independent variables specified in {it:indepvars} conditioned on all other
{it:indepvars} and those variables specified in {opt condvars()}.  There are
two variables in each data file: the feasible sufficient statistics for the
variable's parameter and their associated weights.  The weights variable is
named {cmd:_w_}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.  The
{opt level(#)} option will not work on replay because confidence intervals are
based on estimator-specific enumerations.  To change the confidence level, you
must refit the model.

{phang}
{opt irr} reports estimated coefficients transformed to incidence-rate ratios,
that is, exp(b) rather than b.  Standard errors and confidence intervals are
similarly transformed.  This option affects how results are displayed, not how
they are estimated or stored.  {cmd:irr} may be specified at estimation or when
replaying previously estimated results.

{phang}
{marker test}
{cmd:test(}{opt suff:icient}|{cmd:score}|{opt pr:obability)} reports the
p-value associated with the observed sufficient statistic, the conditional
scores test, or the conditional probabilities test.  The default is
{cmd:test(sufficient)}.  All the statistics are computed at estimation time,
and each statistic may be displayed postestimation; see
{helpb expoisson postestimation:[R] expoisson postestimation}.

{phang}
{opth mue(varlist)} specifies that median unbiased estimates (MUEs) be reported
for the variables in {it:varlist}.  By default, the conditional maximum
likelihood estimates (CMLEs) are reported, except for those parameters for
which the CMLEs are infinite.  Specify {cmd:mue(_all)} if you want MUEs for
all the {indepvars}.

{phang}
{opt midp} instructs {cmd:expoisson} to use the mid-p-value rule when
computing the MUEs, p-values, and confidence intervals.
This adjustment is for the discreteness of the distribution by halving
the value of the discrete probability of the observed statistic before
adding it to the p-value.  The mid-p-value rule cannot be applied to MUEs
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
{cmd:expoisson} will consume when computing the conditional distribution of
the parameter sufficient statistics.  {cmd:memory()} is independent of the data
maximum memory setting (see {cmd:set max_memory} in
{helpb memory:[D] memory}), and it is possible for {cmd:expoisson} to
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
        {cmd:. webuse smokes}

{pstd}Perform exact Poisson regression of {cmd:cases} on {cmd:smokes}
using exposure {cmd:peryrs}{p_end}
{phang2}{cmd:. expoisson cases smokes, exposure(peryrs) irr}{p_end}

{pstd}Replay results and report conditional scores test{p_end}
{phang2}{cmd:. expoisson, test(score) irr}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:expoisson} stores the following in {cmd:e()}:

{synoptset 22 tabbed}{...}
{syntab:Scalars}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k_groups)}}number of groups{p_end}
{synopt:{cmd:e(relative_weight)}}relative weight for the observed {cmd:e(sufficient)} and {cmd:e(condvars)}{p_end}
{synopt:{cmd:e(sum_y)}}sum of {it:depvar}{p_end}
{synopt:{cmd:e(k_indvars)}}number of independent variables{p_end}
{synopt:{cmd:e(k_condvars)}}number of conditioning variables{p_end}
{synopt:{cmd:e(midp)}}mid-p-value rule indicator{p_end}
{synopt:{cmd:e(eps)}}relative difference tolerance{p_end}

{syntab:Macros}
{synopt:{cmd:e(cmd)}}{cmd:expoisson}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(indvars)}}independent variables{p_end}
{synopt:{cmd:e(condvars)}}conditional variables{p_end}
{synopt:{cmd:e(groupvar)}}group variable{p_end}
{synopt:{cmd:e(exposure)}}exposure variable{p_end}
{synopt:{cmd:e(offset)}}linear offset variable{p_end}
{synopt:{cmd:e(level)}}confidence level{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(datasignature)}}the checksum{p_end}
{synopt:{cmd:e(datasignaturevars)}}variables used in calculation of checksum{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
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
{synopt:{cmd:e(probtest)}}conditional probability tests for {it:indepvars}{p_end}
{synopt:{cmd:e(p_probtest)}}p-value for {cmd:e(probtest)}{p_end}

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
