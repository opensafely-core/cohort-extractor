{smcl}
{* *! version 1.0.21  27feb2019}{...}
{viewerdialog "specify correlation" "dialog power_pairedmeans_corr"}{...}
{viewerdialog "specify standard deviation difference" "dialog power_pairedmeans_sddiff"}{...}
{vieweralsosee "[PSS-2] power pairedmeans" "mansection PSS-2 powerpairedmeans"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power" "help power"}{...}
{vieweralsosee "[PSS-2] power repeated" "help power repeated"}{...}
{vieweralsosee "[PSS-2] power, graph" "help power_optgraph"}{...}
{vieweralsosee "[PSS-2] power, table" "help power_opttable"}{...}
{vieweralsosee "[PSS-3] ciwidth pairedmeans" "help ciwidth_pairedmeans"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ttest" "help ttest"}{...}
{viewerjumpto "Syntax" "power_pairedmeans##syntax"}{...}
{viewerjumpto "Menu" "power_pairedmeans##menu"}{...}
{viewerjumpto "Description" "power_pairedmeans##description"}{...}
{viewerjumpto "Links to PDF documentation" "power_pairedmeans##linkspdf"}{...}
{viewerjumpto "Options" "power_pairedmeans##options"}{...}
{viewerjumpto "Remarks: Using power pairedmeans" "power_pairedmeans##remarks"}{...}
{viewerjumpto "Examples" "power_pairedmeans##examples"}{...}
{viewerjumpto "Video examples" "power_pairedmeans##video"}{...}
{viewerjumpto "Stored results" "power_pairedmeans##stored_results"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[PSS-2] power pairedmeans} {hline 2}}Power analysis for a two-sample paired-means test{p_end}
{p2col:}({mansection PSS-2 powerpairedmeans:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Compute sample size

{p 8 43 2}
{opt power} {opt pairedm:eans} {it:ma1} {it:ma2}{cmd:,} 
{it:{help power pairedmeans##corrspec:corrspec}}
[{opth p:ower(numlist)} 
{it:{help power_pairedmeans##synoptions:options}}] 


{phang}
Compute power 

{p 8 43 2}
{opt power} {opt pairedm:eans} {it:ma1} {it:ma2}{cmd:,} 
{it:{help power pairedmeans##corrspec:corrspec}}
{opth n(numlist)} 
[{it:{help power_pairedmeans##synoptions:options}}]


{phang}
Compute effect size and target mean difference

{p 8 43 2}
{opt power} {opt pairedm:eans} [{it:ma1}]{cmd:,}
{it:{help power pairedmeans##corrspec:corrspec}}
{opth n(numlist)} 
{opth p:ower(numlist)} [{it:{help power_pairedmeans##synoptions:options}}]


{marker corrspec}{...}
{phang}
where {it:corrspec} is one of

        {cmd:sddiff()}
	{cmd:corr()} [{cmd:sd()}]
	{cmd:corr()} [{cmd:sd1()} {cmd:sd2()}]

{phang}
{it:ma1} is the alternative pretreatment mean or the pretreatment mean
under the alternative hypothesis, and {it:ma2} is the alternative
posttreatment mean or the value of the posttreatment mean under the
alternative hypothesis.  {it:ma1} and {it:ma2} may each be specified either as
one number or as a list of values in parentheses (see {help numlist}).


{synoptset 30 tabbed}{...}
{marker synoptions}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
INCLUDE help pss_testmainopts1.ihlp
{synopt: {opt nfrac:tional}}allow fractional sample size{p_end}
{p2coldent:* {opth nulld:iff(numlist)}}null difference, the difference between
the posttreatment mean and the pretreatment mean under the null hypothesis;
default is {cmd:nulldiff(0)}{p_end}
{p2coldent:* {opth altd:iff(numlist)}}alternative difference {it:da=ma2-ma1},
the difference between the posttreatment mean and the pretreatment mean under the
alternative hypothesis{p_end}
{p2coldent:* {opth sddiff(numlist)}}standard deviation {it:sigma_d} of the
differences; may not be combined with {cmd:corr()}{p_end}
{p2coldent:* {opth corr(numlist)}}correlation between paired
observations; required unless {cmd:sddiff()} is specified{p_end}
{p2coldent:* {opth sd(numlist)}}common standard deviation; default is
{cmd:sd(1)} and requires {cmd:corr()}{p_end}
{p2coldent:* {opth sd1(numlist)}}standard deviation of the pretreatment
group; requires {cmd:corr()}{p_end}
{p2coldent:* {opth sd2(numlist)}}standard deviation of the posttreatment
group; requires {cmd:corr()}{p_end}
{synopt:{opt knownsd}}request computation assuming a known standard deviation
{it:sigma_d}; default is to assume an unknown standard deviation{p_end}
{p2coldent:* {opth fpc(numlist)}}finite population correction (FPC) as a sampling rate or population size{p_end}
INCLUDE help pss_testmainopts3.ihlp

{syntab:Table}
{synopt :[{cmdab:no:}]{cmdab:tab:le}[{cmd:(}{it:{help power_pairedmeans##tablespec:tablespec}}{cmd:)}]}suppress table or display results as a table; see
{manhelp power_opttable PSS-2:power, table}{p_end}
{synopt :{cmdab:sav:ing(}{it:{help filename}}[{cmd:, replace}]{cmd:)}}save the
table data to {it:filename}; use {cmd:replace} to overwrite existing
{it:filename}{p_end}

INCLUDE help pss_graphopts.ihlp

{syntab:Iteration}
{synopt: {opt init(#)}}initial value for sample size or mean difference;
default is to use normal approximation{p_end}
INCLUDE help pss_iteropts.ihlp

INCLUDE help pss_reportopts.ihlp
{synoptline}
{p2colreset}{...}
INCLUDE help pss_numlist.ihlp
{p 4 6 2}{cmd:notitle} does not appear in the dialog box.{p_end}

{marker tablespec}{...}
{pstd}
where {it:tablespec} is

{p 16 16 2}
{it:{help power_pairedmeans##column:column}}[{cmd::}{it:label}]
[{it:column}[{cmd::}{it:label}] [...]] [{cmd:,} {it:{help power_opttable##tableopts:tableopts}}]

{pstd}
{it:column} is one of the columns defined below,
and {it:label} is a column label (may contain quotes and compound quotes).

{synoptset 28}{...}
{marker column}{...}
{synopthdr :column}
{synoptline}
{synopt :{opt alpha}}significance level{p_end}
{synopt :{opt power}}power{p_end}
{synopt :{opt beta}}type II error probability{p_end}
{synopt :{opt N}}number of subjects{p_end}
{synopt :{opt delta}}effect size{p_end}
{synopt :{opt d0}}null mean difference{p_end}
{synopt :{opt da}}alternative mean difference{p_end}
{synopt :{opt ma1}}alternative pretreatment mean{p_end}
{synopt :{opt ma2}}alternative posttreatment mean{p_end}
{synopt :{opt sd_d}}standard deviation of the differences{p_end}
{synopt :{opt sd}}common standard deviation{p_end}
{synopt :{opt sd1}}standard deviation of the pretreatment group{p_end}
{synopt :{opt sd2}}standard deviation of the posttreatment group{p_end}
{synopt :{opt corr}}correlation between paired observations{p_end}
{synopt :{opt fpc}}FPC{p_end}
{* without the symbol, it does not make sense to have population size and}{...}
{* sampling rate like manual}{...}
{synopt :{opt target}}target parameter; synonym for {cmd:da}{p_end}
{synopt :{opt _all}}display all supported columns{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}Column {cmd:beta} is shown in the default table in place of column
{cmd:power} if specified.{p_end}
{p 4 6 2}Columns {cmd:ma1}, {cmd:ma2}, {cmd:sd}, {cmd:sd1}, {cmd:sd2},
{cmd:corr}, and {cmd:fpc} are shown in the default table if specified.


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
{cmd:power} {cmd:pairedmeans} computes sample size, power, or target mean
difference for a two-sample paired-means test.  By default, it computes sample
size for given power and the values of the null and alternative mean
differences.  Alternatively, it can compute power for given sample size and
the values of the null and alternative mean difference or the target mean
difference for given sample size, power, and the null mean difference. 
Also see {manhelp power PSS-2} for a general introduction to the {cmd:power}
command using hypothesis tests.

{pstd}
For precision and sample-size analysis for a CI for the difference between two
means from paired samples, see
{helpb ciwidth_pairedmeans:[PSS-3] ciwidth pairedmeans}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-2 powerpairedmeansQuickstart:Quick start}

        {mansection PSS-2 powerpairedmeansRemarksandexamples:Remarks and examples}

        {mansection PSS-2 powerpairedmeansMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:alpha()}, {cmd:power()}, {cmd:beta()}, {cmd:n()}, {cmd:nfractional}; see
{manhelp power##mainopts PSS-2:power}.
The {opt nfractional} option is allowed only for sample-size determination.

{phang}
{opth nulldiff(numlist)} specifies the difference between the posttreatment
mean and the pretreatment mean under the null hypothesis.  The default is
{cmd:nulldiff(0)}, which means that the pretreatment mean equals the
posttreatment mean under the null hypothesis.

{phang}
{opth altdiff(numlist)} specifies the alternative difference
{it:da} = {it:ma2} - {it:ma1}, the difference between the posttreatment mean
and the pretreatment mean under the alternative hypothesis.  This option is
the alternative to specifying the alternative means {it:ma1} and {it:ma2}.  If
{it:ma1} is specified in combination with {opt altdiff(#)}, then {it:ma2} =
{it:#} + {it:ma1}.

{phang}
{opth sddiff(numlist)} specifies the standard deviation {it:sigma_d} of the
differences.  Either {cmd:sddiff()} or {cmd:corr()} must be specified.

{phang}
{opth corr(numlist)} specifies the correlation between paired,
pretreatment and posttreatment, observations.  This option along with
{cmd:sd1()} and {cmd:sd2()} or {cmd:sd()} is used to compute the standard
deviation of the differences unless that standard deviation is supplied
directly in the {cmd:sddiff()} option.  Either {cmd:corr()} or {cmd:sddiff()}
must be specified.

{phang}
{opth sd(numlist)} specifies the common standard deviation of the pretreatment
and posttreatment groups.  Specifying {opt sd(#)} implies that both
{cmd:sd1()} and {cmd:sd2()} are equal to {it:#}. Options {cmd:corr()} and
{cmd:sd()} are used to compute the standard deviation of the differences
unless that standard deviation is supplied directly with the {cmd:sddiff()}
option.  The default is {cmd:sd(1)}.

{phang}
{opth sd1(numlist)} specifies the standard deviation of the pretreatment group.
Options {cmd:corr()}, {cmd:sd1()}, and {cmd:sd2()} are used to compute the
standard deviation of the differences unless that standard deviation is
supplied directly with the {cmd:sddiff()} option.

{phang}
{opth sd2(numlist)} specifies the standard deviation of the posttreatment
group.  Options {cmd:corr()}, {cmd:sd1()}, and {cmd:sd2()} are used to compute
the standard deviation of the differences unless that standard deviation is
supplied directly with the {cmd:sddiff()} option.

{phang}
{cmd:knownsd} requests that the standard deviation of the differences
{it:sigma_d} be treated as known in the computations.  By default, the standard
deviation is treated as unknown, and the computations are based on a paired
t test, which uses a Student's t distribution as a sampling
distribution of the test statistic.  If {cmd:knownsd} is specified, the
computation is based on a paired z test, which uses a normal distribution
as the sampling distribution of the test statistic.

{phang}
{opth fpc(numlist)} requests that a finite population correction be used in the
computation.  If {cmd:fpc()} has values between 0 and 1, it is interpreted as a
sampling rate, n/N, where N is the total number of units in the population.
When sample size n is specified, if {cmd:fpc()} has values greater than n, it
is interpreted as a population size, but it is an error to have values between
1 and n.  For sample-size determination, {cmd:fpc()} with a value greater than
1 is interpreted as a population size.  It is an error for {cmd:fpc()} to have
a mixture of sampling rates and population sizes.

{phang}
{cmd:direction()}, {cmd:onesided}, {cmd:parallel}; see 
{manhelp power##mainopts PSS-2:power}.

INCLUDE help pss_taboptsdes.ihlp

INCLUDE help pss_graphoptsdes.ihlp
Also see the {mansection PSS-2 powerpairedmeansSyntaxcolumn:column} table in
{bf:[PSS-2] power pairedmeans} for a list of symbols used by the graphs.

{dlgtab:Iteration}

{phang}
{opt init(#)} specifies the initial value of the sample size for the
sample-size determination or the initial value of the mean difference for the
effect-size determination.  The default is to use a closed-form normal
approximation to compute an initial value of the sample size or mean
difference.

INCLUDE help pss_iteroptsdes.ihlp

{pstd}
The following option is available with {cmd:power pairedmeans} but is not
shown in the dialog box:

INCLUDE help pss_reportoptsdes.ihlp


{marker remarks}{...}
{title:Remarks: Using power pairedmeans}

{pstd}
{cmd:power pairedmeans} computes sample size, power, or target mean difference
for a two-sample paired-means test.  All computations are performed for a
two-sided hypothesis test where, by default, the significance level is set to
0.05.  You may change the significance level by specifying the {cmd:alpha()}
option.  You can specify the {cmd:onesided} option to request a one-sided
test.

{pstd}
By default, all computations are based on a paired t test, which assumes an
unknown standard deviation of the differences.  For a known standard
deviation, you can specify the {cmd:knownsd} option to request a paired z
test.  

{pstd}
For all computations, you must either specify the standard deviation of the
differences in the {cmd:sddiff()} option or the correlation between the paired
observations in the {cmd:corr()} option.  If you specify the {cmd:corr()}
option, then individual standard deviations for the pretreatment and
posttreatment groups may be specified in the respective {cmd:sd1()} and
{cmd:sd2()} options.  By default, their values are set to 1.  When the two
standard deviations are equal, you may specify the common standard deviation
in the {cmd:sd()} option instead of specifying them individually.

{pstd}
To compute sample size, you must specify the pretreatment and posttreatment
means under the alternative hypothesis, {it:ma1} and {it:ma2}, respectively,
and, optionally, the power of the test in the {cmd:power()} option.  The
default power is set to 0.8.

{pstd}
To compute power, you must specify the sample size in the {cmd:n()} option
and the pretreatment and posttreatment means under the alternative hypothesis,
{it:ma1} and {it:ma2}, respectively.

{pstd}
Instead of the alternative means {it:ma1} and {it:ma2}, you can specify the
difference {it:ma2} - {it:ma1} between the alternative posttreatment mean and
the alternative pretreatment mean in the {cmd:altdiff()} option when computing
sample size or power.

{pstd}
By default, the difference between the posttreatment mean and the
pretreatment mean under the null hypothesis is set to zero.  You may specify
other values in option {cmd:nulldiff()}. 

{pstd}
To compute effect size, the standardized difference between the alternative
and null mean differences, and target mean difference, you must specify the
sample size in the {cmd:n()} option, the power in the {cmd:power()} power,
and, optionally, the direction of the effect.  The direction is upper by
default, {cmd:direction(upper)}, which means that the target mean difference
is assumed to be larger than the specified null value.  This is also
equivalent to the assumption of a positive effect size.  You can change the
direction to be lower, which means that the target mean difference is assumed
to be smaller than the specified null value, by specifying the
{cmd:direction(lower)} option.  This is equivalent to assuming a negative
effect size. 

{pstd}
By default, the computed sample size is rounded up.  You can specify the
{cmd:nfractional} option to see the corresponding fractional sample size; see
{mansection PSS-4 UnbalanceddesignsRemarksandexamplesFractionalsamplesizes:{it:Fractional sample sizes}} in
{bf:[PSS-4] Unbalanced designs} for an example.  The {cmd:nfractional} option
is allowed only for sample-size determination.

{pstd}
Some of {cmd:power pairedmeans}'s computations require iteration.  For example,
when the standard deviation of the differences is unknown, computations use a
noncentral Student's t distribution.  Its degrees of freedom depends on the
sample size, and the noncentrality parameter depends on the sample size and
effect size.  Therefore, the sample-size and effect-size computations require
iteration.  The default initial values of the estimated parameters are
obtained by using a closed-form normal approximation.  They  may be changed by
specifying the {cmd:init()} option.  See
{helpb power:[PSS-2] power} for a
description of other options that control the iteration procedure.

{pstd}
All computations assume an infinite population.  For a finite population, use
the {cmd:fpc()} option to specify a sampling rate or a population size.  When
this option is specified, a finite population correction factor is applied to
the standard deviation of the differences.  The correction factor depends on
the sample size; therefore, computing sample size in this case requires
iteration.  The initial value for sample-size computation in this case is
chosen based on the corresponding normal approximation with a finite
population size.


{marker examples}{...}
{title:Examples}

    {title:Examples: Computing sample size}

{pstd}
    Compute sample size required to detect an alternative pretreatment mean
    of 1 and posttreatment mean of 1.5 using a two-sided test when the 
    standard deviation of the difference is 1; assume a 5% significance
    level and 80% power (the defaults){p_end}
{phang2}{cmd:. power pairedmeans 1 1.5, sddiff(1)}

{pstd}
    Same as above, assuming the standard deviation of the difference is
    known{p_end}
{phang2}{cmd:. power pairedmeans 1 1.5, sddiff(1) knownsd}

{pstd}
    Compute sample size as in the first example, except that the correlation
    between the paired observations is 0.7; assume the individual standard
    deviations are both 1 (the default){p_end}
{phang2}{cmd:. power pairedmeans 1 1.5, corr(0.7)}

{pstd}
    Same as above, using a 10% significance level and a one-sided test{p_end}
{phang2}{cmd:. power pairedmeans 1 1.5, corr(0.7) alpha(0.1) onesided}

{pstd}
    Same as above, assuming the mean difference is 0.2 under the null
    hypothesis{p_end}
{phang2}{cmd:. power pairedmeans 1 1.5, corr(0.7) nulldiff(0.2) alpha(0.1)}
    {cmd:onesided}

{pstd}
    Compute sample sizes for a range of alternative posttreatment means and
    powers, graphing the results{p_end}
{phang2}{cmd:. power pairedmeans 1 (1.5(0.1)2), corr(0.7) power(0.8 0.9)}
       {cmd:graph}


    {title:Examples: Computing power}

{pstd}
    Suppose we have a sample of 50 subjects, and we want to compute the power
    of a two-sided hypothesis test to detect an alternative pretreatment mean
    of 1 and a posttreatment mean of 1.5 when the standard deviation of the
    difference is 1; assume the mean difference is 0 under the null and a 5%
    significance level is used (the defaults){p_end}
{phang2}{cmd:. power pairedmeans 1 1.5, n(50) sddiff(1)}

{pstd}
    Same as above, specifying the mean difference{p_end}
{phang2}{cmd:. power pairedmeans, n(50) sddiff(1) altdiff(0.5)}

{pstd}
    Same as first example, assuming the correlation between the paired 
    observations is 0.7 and that the common standard deviation is 2{p_end}
{phang2}{cmd:. power pairedmeans 1 1.5, n(50) corr(0.7) sd(2)}

{pstd}
    Same as above, assuming the standard deviations of the pretreatment and
    posttreatment groups are 1 and 1.5{p_end}
{phang2}{cmd:. power pairedmeans 1 1.5, n(50) corr(0.7) sd1(1) sd2(1.5)}

{pstd}
    Same as above, assuming a finite population of 300 subjects{p_end}
{phang2}{cmd:. power pairedmeans 1 1.5, n(50) corr(0.7) sd1(1) sd2(1.5)}
       {cmd:fpc(300)}

{pstd}
    Compute power for a range of sample sizes, graphing the results{p_end}
{phang2}{cmd:. power pairedmeans 1 1.5, n(50(10)100) corr(0.7) graph}


    {title:Examples: Computing target mean difference}

{pstd}
    Suppose we have a sample of 100 subjects, and we want to compute the
    minimum value of the alternative mean difference greater than zero that
    can be detected by a two-sided hypothesis test with 80% power if the
    pretreatment mean under the alternative hypothesis is 1 and the standard
    deviation of the differences is 1; assume a 5% significance level and a
    common standard deviation of 1 (the defaults){p_end}
{phang2}{cmd:. power pairedmeans 1, n(100) power(0.8) sddiff(1)}

{pstd}
    Same as above{p_end}
{phang2}{cmd:. power pairedmeans 1, n(100) power(0.8) direction(upper)}
     {cmd:sddiff(1)}

{pstd}
    Compute the alternative mean difference less than zero
    that can be detected with 80% power{p_end}
{phang2}{cmd:. power pairedmeans 1, n(100) power(0.8) direction(lower)}
     {cmd:sddiff(1)}


{marker video}{...}
{title:Video examples}

{phang}
{browse "https://www.youtube.com/watch?v=41Hmat-5MX8":Sample-size calculation for comparing sample means from two paired samples}

{phang}
{browse "https://www.youtube.com/watch?v=RCox1fE8rQw":Power calculation for comparing sample means from two paired samples}

{phang}
{browse "https://www.youtube.com/watch?v=zmIevk4VBY8":Minimum detectable effect size for comparing sample means from two paired samples}


{marker stored_results}{...}
{title:Stored results}

{pstd}
{cmd:power pairedmeans} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd: r(alpha)}}significance level{p_end}
{synopt:{cmd: r(power)}}power{p_end}
{synopt:{cmd: r(beta)}}probability of a type II error{p_end}
{synopt:{cmd: r(delta)}}effect size{p_end}
{synopt:{cmd: r(N)}}sample size{p_end}
{synopt:{cmd: r(nfractional)}}{cmd:1} if {cmd:nfractional} is specified, {cmd:0} otherwise{p_end}
{synopt:{cmd: r(onesided)}}{cmd:1} for a one-sided test, {cmd:0} otherwise{p_end}
{synopt:{cmd: r(d0)}}difference between the posttreatment and pretreatment
means under the null hypothesis{p_end}
{synopt:{cmd: r(da)}}difference between the posttreatment and pretreatment
means under the alternative hypothesis{p_end}
{synopt:{cmd: r(ma1)}}pretreatment mean under the alternative hypothesis{p_end}
{synopt:{cmd: r(ma2)}}posttreatment mean under the alternative
hypothesis{p_end}
{synopt:{cmd: r(corr)}}correlation between paired observations{p_end}
{synopt:{cmd: r(sd_d)}}standard deviation of the differences{p_end}
{synopt:{cmd: r(sd1)}}standard deviation of the pretreatment group{p_end}
{synopt:{cmd: r(sd2)}}standard deviation of the posttreatment group{p_end}
{synopt:{cmd: r(sd)}}common standard deviation{p_end}
{synopt:{cmd: r(knownsd)}}{cmd:1} if option {cmd:knownsd} is specified, {cmd:0}
otherwise{p_end}
{synopt:{cmd: r(fpc)}}finite population correction{p_end}
INCLUDE help pss_rrestab_sc.ihlp
{synopt:{cmd: r(init)}}initial value for sample size or target mean difference{p_end}
INCLUDE help pss_rresiter_sc.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(type)}}{cmd:test}{p_end}
{synopt:{cmd:r(method)}}{cmd:pairedmeans}{p_end}
INCLUDE help pss_rrestest_mac.ihlp
INCLUDE help pss_rrestab_mac.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
INCLUDE help pss_rrestab_mat.ihlp
