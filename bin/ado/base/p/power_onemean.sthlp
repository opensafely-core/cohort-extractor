{smcl}
{* *! version 1.1.10  05mar2019}{...}
{viewerdialog power "dialog power_onemean"}{...}
{vieweralsosee "[PSS-2] power onemean" "mansection PSS-2 poweronemean"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power onemean, cluster" "help power_onemean_cluster"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power" "help power"}{...}
{vieweralsosee "[PSS-2] power, graph" "help power_optgraph"}{...}
{vieweralsosee "[PSS-2] power, table" "help power_opttable"}{...}
{vieweralsosee "[PSS-3] ciwidth onemean" "help ciwidth onemean"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ttest" "help ttest"}{...}
{viewerjumpto "Syntax" "power_onemean##syntax"}{...}
{viewerjumpto "Menu" "power_onemean##menu"}{...}
{viewerjumpto "Description" "power_onemean##description"}{...}
{viewerjumpto "Links to PDF documentation" "power_onemean##linkspdf"}{...}
{viewerjumpto "Options" "power_onemean##options"}{...}
{viewerjumpto "Remarks: Using power onemean" "power_onemean##remarks"}{...}
{viewerjumpto "Examples" "power_onemean##examples"}{...}
{viewerjumpto "Video examples" "power_onemean##video"}{...}
{viewerjumpto "Stored results" "power_onemean##stored_results"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[PSS-2] power onemean} {hline 2}}Power analysis for a one-sample
mean test{p_end}
{p2col:}({mansection PSS-2 poweronemean:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Compute sample size

{p 8 43 2}
{opt power} {opt onemean} {it:m0} {it:ma} [, {opth p:ower(numlist)} 
{it:{help power_onemean##synoptions:options}}] 


{phang}
Compute power 

{p 8 43 2}
{opt power} {opt onemean} {it:m0} {it:ma}{cmd:,} {opth n(numlist)} 
[{it:{help power_onemean##synoptions:options}}]


{phang}
Compute effect size and target mean 

{p 8 43 2}
{opt power} {opt onemean} {it:m0}{cmd:,} {opth n(numlist)} 
{opth p:ower(numlist)} [{it:{help power_onemean##synoptions:options}}]


{phang}
where {it:m0} is the null (hypothesized) mean or the value of the mean under
the null hypothesis and {it:ma} is the alternative (target) mean or the value
of the mean under the alternative hypothesis.  {it:m0} and {it:ma} may each be
specified either as one number or as a list of values in parentheses (see
{help numlist}).{p_end}


{synoptset 30 tabbed}{...}
{marker synoptions}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
INCLUDE help pss_testmainopts1.ihlp
{synopt: {opt nfrac:tional}}allow fractional sample size{p_end}
{p2coldent:* {opth diff(numlist)}}difference between the alternative mean 
and the null mean, {it:ma}-{it:m0}; specify instead of the alternative mean
{it:ma}{p_end}
{p2coldent:* {opth sd(numlist)}}standard deviation; default is {cmd:sd(1)}{p_end}
{synopt: {opt knownsd}}request computation assuming a known standard deviation;
default is to assume an unknown standard deviation{p_end}
{p2coldent:* {opth fpc(numlist)}}finite population correction (FPC) as a
sampling rate or as a population size{p_end}
INCLUDE help pss_testmainopts3.ihlp

{syntab:Table}
{synopt :[{cmdab:no:}]{cmdab:tab:le}[{cmd:(}{it:{help power_onemean##tablespec:tablespec}}{cmd:)}]}suppress table or display results as a table; see
{manhelp power_opttable PSS-2:power, table}{p_end}
{synopt :{cmdab:sav:ing(}{it:{help filename}}[{cmd:, replace}]{cmd:)}}save the
table data to {it:filename}; use {cmd:replace} to overwrite existing
{it:filename}{p_end}

INCLUDE help pss_graphopts.ihlp

{syntab:Iteration}
{synopt: {opt init(#)}}initial value for sample size or mean;
default is to use normal approximation{p_end}
INCLUDE help pss_iteropts.ihlp

{synopt: {opt cluster}}perform computations for a CRD; see
    {manhelp power_onemean_cluster PSS-2:power onemean, cluster}{p_end}
INCLUDE help pss_reportopts.ihlp
{synoptline}
{p2colreset}{...}
INCLUDE help pss_numlist.ihlp
{p 4 6 2}{cmd:cluster} and {cmd:notitle} do not appear in the dialog box.{p_end}

{marker tablespec}{...}
{pstd}
where {it:tablespec} is

{p 16 16 2}
{it:{help power_onemean##column:column}}[{cmd::}{it:label}]
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
{synopt :{opt m0}}null mean{p_end}
{synopt :{opt ma}}alternative mean{p_end}
{synopt :{opt diff}}difference between the alternative and null means{p_end}
{synopt :{opt sd}}standard deviation{p_end}
{synopt :{opt fpc}}FPC{p_end}
{* without the symbol, it does not make sense to have population size and}{...}
{* sampling rate like manual}{...}
{synopt :{opt target}}target parameter; synonym for {cmd:ma}{p_end}
{synopt :{opt _all}}display all supported columns{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}Column {cmd:beta} is shown in the default table in place of column
{cmd:power} if specified.{p_end}
{p 4 6 2}Columns {cmd:diff} and {cmd:fpc} are shown in the default table if
specified.


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
{cmd:power} {cmd:onemean} computes sample size, power, or target mean for a
one-sample mean test.  By default, it computes sample size for given power and
the values of the mean parameters under the null and alternative hypotheses.
Alternatively, it can compute power for given sample size and values of the
null and alternative means or the target mean for given sample size, power, and
the null mean.    For power and sample-size analysis in a cluster
randomized design, see
{manhelp power_onemean_cluster PSS-2:power onemean, cluster}.
Also see {manhelp power PSS-2} for a general introduction to the {cmd:power}
command using hypothesis tests.

{pstd}
For precision and sample-size analysis for a CI for a population mean, see
{helpb ciwidth_onemean:[PSS-3] ciwidth onemean}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-2 poweronemeanQuickstart:Quick start}

        {mansection PSS-2 poweronemeanRemarksandexamples:Remarks and examples}

        {mansection PSS-2 poweronemeanMethodsandformulas:Methods and formulas}

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
{opth diff(numlist)} specifies the difference between the alternative mean and
the null mean, {it:ma} - {it:m0}.  You can specify either the alternative mean
{it:ma} as a command argument or the difference between the two means in
{cmd:diff()}.  If you specify {opt diff(#)}, the alternative mean is computed
as {it:ma} = {it:m0} + {it:#}.  This option is not allowed with the
effect-size determination.

{phang}
{opth sd(numlist)} specifies the sample standard deviation or the population
standard deviation.  The default is {cmd:sd(1)}.  By default, {cmd:sd()}
specifies the sample standard deviation.  If {cmd:knownsd} is specified,
{cmd:sd()} specifies the population standard deviation.

{phang}
{cmd:knownsd} requests that the standard deviation be treated as known in the
computation.  By default, the standard deviation is treated as unknown, and
the computation is based on a t test, which uses a Student's t
distribution as a sampling distribution of the test statistic.  If {cmd:knownsd}
is specified, the computation is based on a z test, which uses a normal
distribution as the sampling distribution of the test statistic.

{phang}
{opth fpc(numlist)} requests that a finite population correction be used in
the computation.  If {cmd:fpc()} has values between 0 and 1, it is interpreted
as a sampling rate, n/N, where N is the total number of units in the
population.  When sample size n is specified, if {cmd:fpc()} has values
greater than n, it is interpreted as a population size, but it is an error to
have values between 1 and n.  For sample-size determination, {cmd:fpc()} with
a value greater than 1 is interpreted as a population size.  It is an error
for {cmd:fpc()} to have a mixture of sampling rates and population sizes.

{phang}
{cmd:direction()}, {cmd:onesided}, {cmd:parallel}; see
{manhelp power##mainopts PSS-2:power}.

INCLUDE help pss_taboptsdes.ihlp

INCLUDE help pss_graphoptsdes.ihlp
Also see the {mansection PSS-2 poweronemeanSyntaxcolumn:column} table in
{bf:[PSS-2] power onemean} for a list of symbols used by the graphs.

{dlgtab:Iteration}

{phang}
{opt init(#)} specifies the initial value of the sample size for the
sample-size determination or the initial value of the mean for the effect-size
determination.  The default is to use a closed-form normal approximation to
compute an initial value of the sample size or mean.

INCLUDE help pss_iteroptsdes.ihlp

{pstd}
The following options are available with {cmd:power onemean} but are not
shown in the dialog box:

{phang}
{opt cluster}; see {manhelp power_onemean_cluster PSS-2:power onemean, cluster}.

INCLUDE help pss_reportoptsdes.ihlp


{marker remarks}{...}
{title:Remarks: Using power onemean}

{pstd}
{cmd:power onemean} computes sample size, power, or target mean for a
one-sample mean test.  All computations are performed for a two-sided
hypothesis test where, by default, the significance level is set to 0.05.  You
may change the significance level by specifying the {cmd:alpha()} option.  You
can specify the {cmd:onesided} option to request a one-sided test.

{pstd}
By default, all computations are based on a t test, which assumes an
unknown standard deviation, and use the default value of 1 as the estimate of
the standard deviation.  You may specify other values for the standard
deviation in the {cmd:sd()} option.  For a known standard deviation, you can
specify the {cmd:knownsd} option to request a z test.  

{pstd}
To compute sample size, you must specify the means under the null and
alternative hypotheses, {it:m0} and {it:ma}, respectively, and, optionally,
the power of the test in the {cmd:power()} option.  The default power is set
to 0.8.  

{pstd}
To compute power, you must specify the sample size in the {cmd:n()} option and
the means under the null and alternative hypotheses, {it:m0} and {it:ma},
respectively.

{pstd}
Instead of the alternative mean, {it:ma}, you may specify the difference
{it:ma} - {it:m0} between the alternative mean and null mean in the 
{cmd:diff()} option when computing sample size or power.

{pstd}
To compute effect size, the standardized difference between the alternative
and null means, and the corresponding target mean, you must specify the sample
size in the {cmd:n()} option, the power in the {cmd:power()} option, the null
mean {it:m0}, and, optionally, the direction of the effect.  The direction is
upper by default, {cmd:direction(upper)}, which means that the target mean is
assumed to be larger than the specified null value.  This is also equivalent
to the assumption of a positive effect size.  You can change the direction to
lower, which means that the target mean is assumed to be smaller than the
specified null value, by specifying the {cmd:direction(lower)} option.  This
is equivalent to assuming a negative effect size.

{pstd}
By default, the computed sample size is rounded up.  You can specify the
{cmd:nfractional} option to see the corresponding fractional sample size; see
{mansection PSS-4 UnbalanceddesignsRemarksandexamplesFractionalsamplesizes:{it:Fractional sample sizes}} in
{bf:[PSS-4] Unbalanced designs} for an example.  The {cmd:nfractional} option
is allowed only for sample-size determination.

{pstd}
Some of {cmd:power onemean}'s computations require iteration.  For example,
when the standard deviation is unknown, computations use a noncentral
Student's t distribution. Its degrees of freedom depends on the sample size,
and the noncentrality parameter depends on the sample size and effect size.
Therefore, the sample-size and effect-size determinations require iteration.
The default initial values of the estimated parameters are obtained by using a
closed-form normal approximation.  They may be changed by specifying the
{cmd:init()} option. See {helpb power:[PSS-2] power} for the descriptions of
other options that control the iteration procedure.

{pstd}
All computations assume an infinite population.  For a finite population, use
the {cmd:fpc()} option to specify a sampling rate or a population size.  When
this option is specified, a finite population correction is applied to the
population standard deviation.  The correction depends on the sample size;
therefore, computing sample size for a finite population requires
iteration even for a known standard deviation.  The initial value for the
sample size is based on the corresponding sample size assuming an
infinite population.


{marker examples}{...}
{title:Examples}

    {title:Examples: Computing sample size}

{pstd}
    Compute the sample size required to detect a mean of 2 given a mean of 1
    under the null hypothesis; assume that the sample standard deviation
    is 1, significance level is 5%, power is 80%, and that a two-sided test 
    will be used (the defaults){p_end}
{phang2}{cmd:. power onemean 1 2}

{pstd}
    Same as above, using the {cmd:diff()} option to specify the difference in
    means under the null and alternative hypotheses{p_end}
{phang2}{cmd:. power onemean 1, diff(1)}

{pstd}
    Same as first example, using a power of 90%{p_end}
{phang2}{cmd:. power onemean 1 2, power(0.9)}

{pstd}
    Same as first example, assuming a known population standard deviation of 2
    {p_end}
{phang2}{cmd:. power onemean 1 2, sd(2) knownsd}

{pstd}
    Same as above, knowing the population size is 200{p_end}
{phang2}{cmd:. power onemean 1 2, sd(2) knownsd fpc(200)}

{pstd}
    Same as first example, using a one-sided test with a 1% significance level
    {p_end}
{phang2}{cmd:. power onemean 1 2, alpha(0.01) onesided}
    
{pstd}
    Specify a list of alternative means and two power levels, graphing the
    results{p_end}
{phang2}{cmd:. power onemean 1 (1.5(0.5)3), power(0.8 0.9) graph}


    {title:Examples: Computing power}

{pstd}
    Suppose we have a sample of 50 subjects, and we want to compute the power
    of a two-sided test to detect a mean of 2 given a null mean of 1; assume
    a sample standard deviation of 1 and a 5% significance level (the
    defaults){p_end}
{phang2}{cmd:. power onemean 1 2, n(50)}

{pstd}
    Compute powers for several alternative means and sample sizes, graphing
    the results{p_end}
{phang2}{cmd:. power onemean 0 (0.2 0.5 0.7 1), n(5(1)15) graph}


    {title:Examples: Computing target mean}

{pstd}
    Compute the minimum value of the mean exceeding 1 that can be detected
    using a two-sided hypothesis test with 50 observations and a power of
    80%; assume a 5% significance level, and a sample standard deviation of 1
    (the defaults){p_end}
{phang2}{cmd:. power onemean 1, n(50) power(0.8)}

{pstd}
    Same as above{p_end}
{phang2}{cmd:. power onemean 1, n(50) power(0.8) direction(upper)}

{pstd}
    Compute the maximum mean value below 1 that can be detected{p_end}
{phang2}{cmd:. power onemean 1, n(50) power(0.8) direction(lower)}


{marker video}{...}
{title:Video examples}

{phang}
{browse "https://www.youtube.com/watch?v=wZcUTJ_34ic&list=PLN5IskQdgXWmExGRjdy0s0VCdYnzGMZrT":Sample-size calculation for comparing a sample mean to a reference value}

{phang}
{browse "https://www.youtube.com/watch?v=Fmb8yHBl-n0&list=PLN5IskQdgXWmExGRjdy0s0VCdYnzGMZrT":Power calculation for comparing a sample mean to a reference value}

{phang}
{browse "https://www.youtube.com/watch?v=Ulx_tlVBgqM&list=PLN5IskQdgXWmExGRjdy0s0VCdYnzGMZrT":Minimum detectable effect size for comparing a sample mean to a reference value}


{marker stored_results}{...}
{title:Stored results}

{pstd}
{cmd:power onemean} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd: r(alpha)}}significance level{p_end}
{synopt:{cmd: r(power)}}power{p_end}
{synopt:{cmd: r(beta)}}probability of a type II error{p_end}
{synopt:{cmd: r(delta)}}effect size{p_end}
{synopt:{cmd: r(N)}}sample size{p_end}
{synopt:{cmd: r(nfractional)}}{cmd:1} if {cmd:nfractional} is specified, {cmd:0} otherwise{p_end}
{synopt:{cmd: r(onesided)}}{cmd:1} for a one-sided test, {cmd:0} otherwise{p_end}
{synopt:{cmd: r(m0)}}mean under the null hypothesis{p_end}
{synopt:{cmd: r(ma)}}mean under the alternative hypothesis{p_end}
{synopt:{cmd: r(diff)}}difference between the alternative and null means{p_end}
{synopt:{cmd: r(sd)}}standard deviation{p_end}
{synopt:{cmd: r(knownsd)}}{cmd:1} if option {cmd:knownsd} is specified,
{cmd:0} otherwise{p_end}
{synopt:{cmd: r(fpc)}}finite population correction (if specified){p_end}
INCLUDE help pss_rrestab_sc.ihlp
{synopt:{cmd: r(init)}}initial value for sample size or mean{p_end}
INCLUDE help pss_rresiter_sc.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(type)}}{cmd:test}{p_end}
{synopt:{cmd:r(method)}}{cmd:onemean}
{p_end}
INCLUDE help pss_rrestest_mac.ihlp
INCLUDE help pss_rrestab_mac.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
INCLUDE help pss_rrestab_mat.ihlp
