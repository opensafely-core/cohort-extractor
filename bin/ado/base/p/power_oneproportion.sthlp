{smcl}
{* *! version 1.1.7  27feb2019}{...}
{viewerdialog "score test" "dialog power_oneprop_score"}{...}
{viewerdialog "Wald test" "dialog power_oneprop_wald"}{...}
{viewerdialog "binomial test" "dialog power_oneprop_binom"}{...}
{vieweralsosee "[PSS-2] power oneproportion" "mansection PSS-2 poweroneproportion"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power oneproportion, cluster" "help power_oneproportion_cluster"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power" "help power"}{...}
{vieweralsosee "[PSS-2] power, graph" "help power_optgraph"}{...}
{vieweralsosee "[PSS-2] power, table" "help power_opttable"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] bitest" "help bitest"}{...}
{vieweralsosee "[R] prtest" "help prtest"}{...}
{viewerjumpto "Syntax" "power_oneproportion##syntax"}{...}
{viewerjumpto "Menu" "power_oneproportion##menu"}{...}
{viewerjumpto "Description" "power_oneproportion##description"}{...}
{viewerjumpto "Links to PDF documentation" "power_oneproportion##linkspdf"}{...}
{viewerjumpto "Options" "power_oneproportion##options"}{...}
{viewerjumpto "Remarks: Using power oneproportion" "power_oneproportion##remarks"}{...}
{viewerjumpto "Examples" "power_oneproportion##examples"}{...}
{viewerjumpto "Video examples" "power_oneproportion##video"}{...}
{viewerjumpto "Stored results" "power_oneproportion##stored_results"}{...}
{p2colset 1 32 34 2}{...}
{p2col:{bf:[PSS-2] power oneproportion} {hline 2}}Power analysis for a one-sample
proportion test{p_end}
{p2col:}({mansection PSS-2 poweroneproportion:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Compute sample size

{p 8 43 2}
{opt power} {opt oneprop:ortion} {it:p0} {it:pa}
[{cmd:,} {opth p:ower(numlist)} 
{it:{help power_oneproportion##synoptions:options}}]


{phang}
Compute power 

{p 8 43 2}
{opt power} {opt oneprop:ortion} {it:p0} {it:pa}{cmd:,} {opth n(numlist)} 
[{it:{help power_oneproportion##synoptions:options}}]


{phang}
Compute effect size and target proportion 

{p 8 43 2}
{opt power} {opt oneprop:ortion} {it:p0}{cmd:,} {opth n(numlist)} 
{opth p:ower(numlist)} [{it:{help power_oneproportion##synoptions:options}}]


{phang}
where {it:p0} is the null (hypothesized) proportion or the value of the
proportion under the null hypothesis, and {it:pa} is the alternative (target)
proportion or the value of the proportion under the alternative hypothesis.
{it:p0} and {it:pa} may each be specified either as one number or as a list of
values in parentheses (see {help numlist}).{p_end}


{synoptset 30 tabbed}{...}
{marker synoptions}{...}
{synopthdr:options}
{synoptline}
{synopt:{opth test:(power_oneproportion##testspec:test)}}specify the type of test; default is {cmd:test(score)}{p_end}

{syntab:Main}
INCLUDE help pss_testmainopts1.ihlp
{synopt: {opt nfrac:tional}}allow fractional sample size{p_end}
{p2coldent:* {opth diff(numlist)}}difference between the alternative proportion 
and the null proportion, {it:pa}-{it:p0}; specify instead of the alternative
proportion {it:pa}{p_end}
{synopt: {opt critval:ues}}show critical values for the binomial test{p_end}
{synopt: {opt contin:uity}}apply continuity correction to the normal approximation of the discrete distribution{p_end}
INCLUDE help pss_testmainopts3.ihlp

{syntab:Table}
{synopt :[{cmdab:no:}]{cmdab:tab:le}[{cmd:(}{it:{help power_oneproportion##tablespec:tablespec}}{cmd:)}]}suppress table or display results as a table; see
{manhelp power_opttable PSS-2:power, table}{p_end}
{synopt :{cmdab:sav:ing(}{it:{help filename}}[{cmd:, replace}]{cmd:)}}save the
table data to {it:filename}; use {cmd:replace} to overwrite existing
{it:filename}{p_end}

INCLUDE help pss_graphopts.ihlp

{syntab:Iteration}
{synopt: {opt init(#)}}initial value for sample size or proportion{p_end}
INCLUDE help pss_iteropts.ihlp

{synopt: {opt cluster}}perform computations for a CRD; see
    {manhelp power_oneproportion_cluster PSS-2:power oneproportion, cluster}{p_end}
INCLUDE help pss_reportopts.ihlp
{synoptline}
{p2colreset}{...}
INCLUDE help pss_numlist.ihlp
{p 4 6 2}{cmd:cluster} and {cmd:notitle} do not appear in the dialog box.{p_end}

{synoptset 30}{...}
{marker testspec}{...}
{synopthdr :test}
{synoptline}
{synopt :{opt score}}score test; the default{p_end}
{synopt :{opt wald}}Wald test{p_end}
{synopt :{opt binom:ial}}binomial test{p_end}
{synoptline}
{p 4 6 2}{cmd:test()} does not appear in the dialog box.
The dialog box selected is determined by the {cmd:test()} specification.

{marker tablespec}{...}
{pstd}
where {it:tablespec} is

{p 16 16 2}
{it:{help power_oneproportion##column:column}}[{cmd::}{it:label}]
[{it:column}[{cmd::}{it:label}] [...]] [{cmd:,} {it:{help power_opttable##tableopts:tableopts}}]

{pstd}
{it:column} is one of the columns defined below,
and {it:label} is a column label (may contain quotes and compound quotes).

{synoptset 30}{...}
{marker column}{...}
{synopthdr :column}
{synoptline}
{synopt :{opt alpha}}significance level{p_end}
{synopt :{opt alpha_a}}observed significance level{p_end}
{synopt :{opt power}}power{p_end}
{synopt :{opt beta}}type II error probability{p_end}
{synopt :{opt N}}number of subjects{p_end}
{synopt :{opt delta}}effect size{p_end}
{synopt :{opt p0}}null proportion{p_end}
{synopt :{opt pa}}alternative proportion{p_end}
{synopt :{opt diff}}difference between the alternative and null proportions{p_end}
{synopt :{opt C_l}}lower critical value{p_end}
{synopt :{opt C_u}}upper critical value{p_end}
{synopt :{opt target}}target parameter; synonym for {cmd:pa}{p_end}
{synopt :{opt _all}}display all supported columns{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}Column {cmd:beta} is shown in the default table in place of column
{cmd:power} if specified.{p_end}
{p 4 6 2}Column {cmd:diff} is shown in the default table if specified.{p_end}
{p 4 6 2}Columns {cmd:alpha_a}, {cmd:C_l}, and {cmd:C_u} are available when the
{cmd:test(binomial)} option is specified.{p_end}
{p 4 6 2}Columns {cmd:C_l} and {cmd:C_u} are shown in the default table, if
the {cmd:critvalues} option is specified.


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
{cmd:power} {cmd:oneproportion} computes sample size, power, or target
proportion for a one-sample proportion test.  By default, it computes sample
size for given power and the values of the proportion parameters under the null
and alternative hypotheses.  Alternatively, it can compute power for given
sample size and values of the null and alternative proportions or the target
proportion for given sample size, power, and the null proportion.  For power
and sample-size analysis in a cluster randomized design, see
{manhelp power_oneproportion_cluster PSS-2:power oneproportion, cluster}.
Also see {manhelp power PSS-2} for a general introduction to the {cmd:power}
command using hypothesis tests.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-2 poweroneproportionQuickstart:Quick start}

        {mansection PSS-2 poweroneproportionRemarksandexamples:Remarks and examples}

        {mansection PSS-2 poweroneproportionMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt test(test)} specifies the type of the test for power and sample-size
computations.  {it:test} is one of {cmd:score}, {cmd:wald}, or {cmd:binomial}.

{pmore}
{cmd:score} requests computations for the score test. This is the default
test.

{pmore}
{cmd:wald} requests computations for the Wald test.  This corresponds to
computations using the value of the alternative proportion instead of the
default null proportion in the formula for the standard error of the estimator
of the proportion.

{pmore}
{cmd:binomial} requests computations for the binomial test.  The
computation using the binomial distribution is not available for sample-size
and effect-size determinations; see
{mansection PSS-2 poweroneproportionRemarksandexamplesex7:example 7}
for details.  Iteration options are not allowed with this test.

{dlgtab:Main}

{phang}
{cmd:alpha()}, {cmd:power()}, {cmd:beta()}, {cmd:n()}, {cmd:nfractional}; see
{manhelp power##mainopts PSS-2:power}.
The {opt nfractional} option is allowed only for sample-size determination.

{phang}
{opth diff(numlist)} specifies the difference between the alternative
proportion and the null proportion, {it:pa} - {it:p0}.  You can specify either
the alternative proportion {it:pa} as a command argument or the difference
between the two proportions in {cmd:diff()}.  If you specify {opt diff(#)},
the alternative proportion is computed as {it:pa} = {it:p0} + {it:#}.  This
option is not allowed with the effect-size determination.

{phang}
{opt critvalues} requests that the critical values be reported when the
computation is based on the binomial distribution.

{phang}
{opt continuity} requests that continuity correction be applied to the 
normal approximation of the discrete distribution.  {opt continuity}
cannot be specified with {cmd:test(binomial)}.

{phang}
{cmd:direction()}, {cmd:onesided}, {cmd:parallel}; see
{manhelp power##mainopts PSS-2:power}.

INCLUDE help pss_taboptsdes.ihlp

INCLUDE help pss_graphoptsdes.ihlp
Also see the {mansection PSS-2 poweroneproportionSyntaxcolumn:column} table in
{bf:[PSS-2] power oneproportion} for a list of symbols used by the graphs.

{dlgtab:Iteration}

{phang}
{opt init(#)} specifies the initial value of the sample size for the
sample-size determination or the initial value of the proportion for the
effect-size determination. 

INCLUDE help pss_iteroptsdes.ihlp

{pstd}
The following options are available with {cmd:power oneproportion} but are not
shown in the dialog box:

{phang}
{opt cluster}; see
{manhelp power_oneproportion_cluster PSS-2:power oneproportion, cluster}.

INCLUDE help pss_reportoptsdes.ihlp


{marker remarks}{...}
{title:Remarks: Using power oneproportion}

{pstd}
{cmd:power oneproportion} computes sample size, power, or target proportion for
a one-sample proportion test.  All computations are performed for a two-sided
hypothesis test where, by default, the significance level is set to 0.05.  You
may change the significance level by specifying the {cmd:alpha()} option.  You
can specify the {cmd:onesided} option to request a one-sided test.

{pstd}
To compute sample size, you must specify the proportions under the null and
alternative hypotheses, {it:p0} and {it:pa}, respectively, and, optionally,
the power of the test in the {cmd:power()} option.  The default power is set
to 0.8.  

{pstd}
To compute power, you must specify the sample size in the {cmd:n()} option and
the proportions under the null and alternative hypotheses, {it:p0} and
{it:pa}, respectively.

{pstd}
Instead of the alternative proportion {it:pa}, you may specify the difference
{it:pa} - {it:p0} between the alternative proportion and null proportion in
the {cmd:diff()} option when computing sample size or power.

{pstd}
To compute effect size, the difference between the alternative and null
proportions, and target proportion, you must specify the sample size in the
{cmd:n()} option, the power in the {cmd:power()} option, the null proportion
{it:p0}, and, optionally, the direction of the effect.  The direction is upper
by default, {cmd:direction(upper)}, which means that the target proportion is
assumed to be larger than the specified null value.  You can change the
direction to lower, which means that the target proportion is assumed to be
smaller than the specified null value, by specifying the
{cmd:direction(lower)} option.

{pstd}
By default, all computations are based on a large-sample z test of the
proportion, which uses a normal distribution as the sampling distribution of
the test statistic. For power determination, you can request a small-sample
binomial test by specifying the {cmd:binomial} option.  The binomial test is
not available for the sample-size and effect-size determinations; see
{mansection PSS-2 poweroneproportionRemarksandexamplesex7:example 7} for
details.

{pstd}
By default, the computed sample size is rounded up.  You can specify the
{cmd:nfractional} option to see the corresponding fractional sample size; see
{mansection PSS-4 UnbalanceddesignsRemarksandexamplesFractionalsamplesizes:{it:Fractional sample sizes}} in
{bf:[PSS-4] Unbalanced designs} for an example.  The {cmd:nfractional} option
is allowed only for sample-size determination.

{pstd}
Some of {cmd:power oneproportion}'s computations require iteration.  For
example, for a large-sample z test, sample size for a two-sided test is
obtained by iteratively solving a nonlinear power equation.  The default
initial value for the sample size for the iteration procedure is obtained
using a closed-form one-sided formula. If desired, it may be changed by
specifying the {cmd:init()} option. See {manhelp power PSS-2} for the
descriptions of other options that control the iteration procedure.


{marker examples}{...}
{title:Examples}

    {title:Examples: Computing sample size}

{pstd}
    Compute the sample size required to detect a proportion of 0.2 given a
    proportion of 0.1 under the null hypothesis using a two-sided test;
    assume a 5% significance level and 80% power (the defaults){p_end}
{phang2}{cmd:. power oneproportion 0.1 0.2}

{pstd}
    Same as above, using the {cmd:diff()} option to specify the difference
    in proportions under the null and alternative hypotheses{p_end}
{phang2}{cmd:. power oneproportion 0.1, diff(0.1)}

{pstd}
    Same as first example, using a power of 90%{p_end}
{phang2}{cmd:. power oneproportion 0.1 0.2, power(0.9)}

{pstd}
    Same as first example, using a one-sided test and a 1% significance level
    {p_end}
{phang2}{cmd:. power oneproportion 0.1 0.2, alpha(0.01) onesided}

{pstd}
    Compute sample size for a range of alternative proportions and powers,
    graphing the results{p_end}
{phang2}{cmd:. power oneproportion 0.1 (0.2(0.1)0.9), power(0.8 0.9) graph}


    {title:Examples: Computing power}

{pstd}
    For a sample of 50 subjects, compute the power of a two-sided test to 
    detect a proportion of 0.2 given a null mean of 0.1; assume a 5%
    significance level (the default){p_end}
{phang2}{cmd:. power oneproportion 0.1 0.2, n(50)}

{pstd}
    Same as above, assuming a binomial test will be used{p_end}
{phang2}{cmd:. power oneproportion 0.1 0.2, n(50) test(binomial)}

{pstd}
    Compute powers for a range of alternative proportions and sample sizes,
    graphing the results{p_end}
{phang2}{cmd:. power oneproportion 0.1 (0.2 0.5 0.7 0.9), n(5(1)15) graph}


    {title:Examples: Computing target proportion}

{pstd}
    Compute the minimum value of the proportion exceeding 0.1 that can be
    detected using a two-sided test in a sample of 50 subjects with 80%
    power; assume a 5% significance level (the default){p_end}
{phang2}{cmd:. power oneproportion 0.1, n(50) power(0.8)}

{pstd}
    Same as above{p_end}
{phang2}{cmd:. power oneproportion 0.1, n(50) power(0.8) direction(upper)}

{pstd}
    Same as above, using a Wald test rather than the default score test{p_end}
{phang2}{cmd:. power oneproportion 0.1, n(50) power(0.8) test(wald)}

{pstd}
    Compute the maximum proportion less than 0.1 that can be detected{p_end}
{phang2}{cmd:. power oneproportion 0.1, n(50) power(0.8)}
      {cmd:direction(lower) test(wald)}


{marker video}{...}
{title:Video examples}

{phang}
{browse "https://www.youtube.com/watch?v=SMl0BTSpC3Q&list=UUVk4G4nEtBS4tLOyHqustDA":Sample-size calculation for comparing a sample proportion to a reference value}

{phang}
{browse "https://www.youtube.com/watch?v=178LFlzwJlI&list=UUVk4G4nEtBS4tLOyHqustDA":Power calculation for comparing a sample proportion to a reference value}

{phang}
{browse "https://www.youtube.com/watch?v=i2r-OgXP4gY&list=UUVk4G4nEtBS4tLOyHqustDA":Minimum detectable effect size for comparing a sample proportion to a reference value using Stata}


{marker stored_results}{...}
{title:Stored results}

{pstd}
{cmd:power oneproportion} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
INCLUDE help pss_rresoneprop_sc.ihlp
{synopt:{cmd: r(p0)}}proportion under the null hypothesis{p_end}
{synopt:{cmd: r(pa)}}proportion under the alternative hypothesis{p_end}
{synopt:{cmd: r(diff)}}difference between the alternative and null proportions{p_end}
{synopt:{cmd: r(C_l)}}lower critical value of the binomial distribution{p_end}
{synopt:{cmd: r(C_u)}}upper critical value of the binomial distribution{p_end}
{synopt:{cmd: r(continuity)}}{bf:1} if continuity correction is used;
{bf:0} otherwise{p_end}
INCLUDE help pss_rrestab_sc.ihlp
{synopt:{cmd: r(init)}}initial value for sample size or proportion{p_end}
INCLUDE help pss_rresiter_sc.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(type)}}{cmd:test}{p_end}
{synopt:{cmd:r(method)}}{cmd:oneproportion}{p_end}
{synopt:{cmd:r(test)}}{cmd:score}, {cmd:wald}, or {cmd:binomial}{p_end}
INCLUDE help pss_rrestest_mac.ihlp
INCLUDE help pss_rrestab_mac.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
INCLUDE help pss_rrestab_mat.ihlp
