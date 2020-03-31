{smcl}
{* *! version 1.1.9  21mar2019}{...}
{viewerdialog "chi-squared test" "dialog power_twoprop_chi2"}{...}
{viewerdialog "LR test" "dialog power_twoprop_lrchi2"}{...}
{viewerdialog "Fisher's exact test" "dialog power_twoprop_fisher"}{...}
{vieweralsosee "[PSS-2] power twoproportions" "mansection PSS-2 powertwoproportions"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power twoproportions, cluster" "help power_twoproportions_cluster"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power" "help power"}{...}
{vieweralsosee "[PSS-2] power, graph" "help power_optgraph"}{...}
{vieweralsosee "[PSS-2] power, table" "help power_opttable"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] bitest" "help bitest"}{...}
{vieweralsosee "[R] prtest" "help prtest"}{...}
{viewerjumpto "Syntax" "power_twoproportions##syntax"}{...}
{viewerjumpto "Menu" "power_twoproportions##menu"}{...}
{viewerjumpto "Description" "power_twoproportions##description"}{...}
{viewerjumpto "Links to PDF documentation" "power_twoproportions##linkspdf"}{...}
{viewerjumpto "Options" "power_twoproportions##options"}{...}
{viewerjumpto "Remarks: Using power twoproportions" "power_twoproportions##remarks"}{...}
{viewerjumpto "Examples" "power_twoproportions##examples"}{...}
{viewerjumpto "Video examples" "power_twoproportions##videos"}{...}
{viewerjumpto "Stored results" "power_twoproportions##stored_results"}{...}
{p2colset 1 33 35 2}{...}
{p2col:{bf:[PSS-2] power twoproportions} {hline 2}}Power analysis for a
two-sample proportions test{p_end}
{p2col:}({mansection PSS-2 powertwoproportions:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Compute sample size

{p 8 43 2}
{opt power} {opt twoprop:ortions} {it:p1} {it:p2}
[{cmd:,} {opth p:ower(numlist)} 
{it:{help power_twoproportions##synoptions:options}}] 


{phang}
Compute power 

{p 8 43 2}
{opt power} {opt twoprop:ortions} {it:p1} {it:p2}{cmd:,} {opth n(numlist)}
[{it:{help power_twoproportions##synoptions:options}}]


{phang}
Compute effect size and experimental-group proportion

{p 8 43 2}
{opt power} {opt twoprop:ortions} {it:p1}{cmd:,} {opth n(numlist)} 
{opth p:ower(numlist)} [{it:{help power_twoproportions##synoptions:options}}]


{phang}
where
{it:p1} is the proportion in the control (reference) group and
{it:p2} is the proportion in the experimental (comparison) group.
{it:p1} and {it:p2} may each be specified either as one number or as a list of
values in parentheses (see {help numlist}).{p_end}


{synoptset 30 tabbed}{...}
{marker synoptions}{...}
{synopthdr:options}
{synoptline}
{synopt:{opth test:(power_twoproportions##testspec:test)}}specify the type of test; default is
{cmd:test(chi2)}{p_end}

{syntab:Main}
INCLUDE help pss_twotestmainopts1.ihlp
{synopt: {opt nfrac:tional}}allow fractional sample sizes{p_end}
{p2coldent:* {opth diff(numlist)}}difference between the experimental-group
and control-group proportion, {it:p2}-{it:p1}; specify instead of the
experimental-group proportion {it:p2}{p_end}
{p2coldent:* {opth ratio(numlist)}}ratio of the experimental-group
proportion to the control-group proportion, {it:p2}/{it:p1}; specify instead of the
experimental-group proportion {it:p2}{p_end}
{p2coldent:* {opth rd:iff(numlist)}}risk difference, {it:p2}-{it:p1}; synonym
for {cmd:diff()}{p_end}
{p2coldent:* {opth rr:isk(numlist)}}relative risk, {it:p2}/{it:p1}; synonym for
{cmd:ratio()}{p_end}
{p2coldent:* {opth or:atio(numlist)}}odds ratio, {c -(}{it:p2}(1-{it:p1}){c )-}/{c -(}{it:p1}(1-{it:p2}){c )-}{p_end}
{synopt: {opth effect:(power twoproportions##effectspec:effect)}}specify the
type of effect to display; default is {cmd:effect(diff)}{p_end}
{synopt: {opt contin:uity}}apply continuity correction to the normal approximation of the discrete distribution{p_end}
INCLUDE help pss_testmainopts3.ihlp

{syntab:Table}
{synopt :[{cmdab:no:}]{cmdab:tab:le}[{cmd:(}{it:{help power_twoproportions##tablespec:tablespec}}{cmd:)}]}suppress table or display results as a table; see
{manhelp power_opttable PSS-2:power, table}{p_end}
{synopt :{cmdab:sav:ing(}{it:{help filename}}[{cmd:, replace}]{cmd:)}}save the
table data to {it:filename}; use {cmd:replace} to overwrite existing
{it:filename}{p_end}

INCLUDE help pss_graphopts.ihlp

{syntab:Iteration}
{synopt: {opt init(#)}}initial value for sample sizes or experimental-group
proportion{p_end}
INCLUDE help pss_iteropts.ihlp

{synopt: {opt cluster}}perform computations for a CRD; see
    {manhelp power_twoproportions_cluster PSS-2:power twoproportions, cluster}{p_end}
INCLUDE help pss_reportopts.ihlp
{synoptline}
{p2colreset}{...}
INCLUDE help pss_numlist.ihlp
{p 4 6 2}{cmd:cluster} and {cmd:notitle} do not appear in the dialog box.{p_end}

{synoptset 30}{...}
{marker testspec}{...}
{synopthdr :test}
{synoptline}
{synopt :{opt chi2}}Pearson's chi-squared test; the default{p_end}
{synopt :{opt lrchi2}}likelihood-ratio test{p_end}
{synopt :{opt fisher}}Fisher-Irwin's exact conditional test{p_end}
{synoptline}
{p 4 6 2}{cmd:test()} does not appear in the dialog box.
The dialog box selected is determined by the {cmd:test()} specification.

{marker effectspec}{...}
{synopthdr :effect}
{synoptline}
{synopt :{opt diff}}difference between proportions, {it:p2}-{it:p1}; the default{p_end}
{synopt :{opt ratio}}ratio of proportions, {it:p2}/{it:p1}{p_end}
{synopt :{opt rd:iff}}risk difference, {it:p2}-{it:p1}{p_end}
{synopt :{opt rr:isk}}relative risk, {it:p2/p1}{p_end}
{synopt :{opt or:atio}}odds ratio, {c -(}{it:p2}(1-{it:p1}){c )-}/{c -(}{it:p1}(1-{it:p2}){c )-}{p_end}
{synoptline}

{marker tablespec}{...}
{pstd}
where {it:tablespec} is

{p 16 16 2}
{it:{help power_twoproportions##column:column}}[{cmd::}{it:label}]
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
{synopt :{opt N}}total number of subjects{p_end}
{synopt :{opt N1}}number of subjects in the control group{p_end}
{synopt :{opt N2}}number of subjects in the experimental group{p_end}
{synopt :{opt nratio}}ratio of sample sizes, experimental to control{p_end}
{synopt :{opt delta}}effect size{p_end}
{synopt :{opt p1}}control-group proportion{p_end}
{synopt :{opt p2}}experimental-group proportion{p_end}
{synopt :{opt diff}}difference between the experimental-group proportion and the
control-group proportion{p_end}
{synopt :{opt ratio}}ratio of the experimental-group proportion to the
control-group proportion{p_end}
{synopt :{opt rdiff}}risk difference{p_end}
{synopt :{opt rrisk}}relative risk{p_end}
{synopt :{opt oratio}}odds ratio{p_end}
{synopt :{opt target}}target parameter; synonym for {cmd:p2}{p_end}
{synopt :{opt _all}}display all supported columns{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}Column {cmd:beta} is shown in the default table in place of column
{cmd:power} if specified.{p_end}
{p 4 6 2}Column {cmd:alpha_a} is available when the {cmd:test(fisher)} option
is specified.{p_end}
{p 4 6 2}Columns {cmd:nratio}, {cmd:diff}, {cmd:ratio}, {cmd:rdiff},
{cmd:rrisk}, and {cmd:oratio} are shown in the default table if specified.


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
{cmd:power twoproportions} computes sample size, power, or the
experimental-group proportion for a two-sample proportions test.  By default,
it computes sample size for given power and the values of the control-group and
experimental-group proportions.  Alternatively, it can compute power for given
sample size and values of the control-group and experimental-group proportions
or the experimental-group proportion for given sample size, power, and the
control-group proportion.  For power and sample-size analysis in a cluster
randomized design, see
{manhelp power_twoproportions_cluster PSS-2:power twoproportions, cluster}.
Also see {manhelp power PSS-2} for a general introduction to the {cmd:power}
command using hypothesis tests.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-2 powertwoproportionsQuickstart:Quick start}

        {mansection PSS-2 powertwoproportionsRemarksandexamples:Remarks and examples}

        {mansection PSS-2 powertwoproportionsMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt test(test)} specifies the type of the test for power and sample-size
computations.  {it:test} is one of {cmd:chi2}, {cmd:lrchi2}, or {cmd:fisher}.

{pmore}
{cmd:chi2} requests computations for the Pearson's chi-squared test. This is
the default test.

{pmore}
{cmd:lrchi2} requests computations for the likelihood-ratio test.

{pmore}
{cmd:fisher} requests computations for Fisher-Irwin's exact
conditional test.  Iteration options are not allowed with this test.

{dlgtab:Main}

{phang}
{cmd:alpha()}, {cmd:power()}, {cmd:beta()}, {cmd:n()}, {cmd:n1()},
{cmd:n2()}, {cmd:nratio()}, {cmd:compute()}, {cmd:nfractional}; 
see {manhelp power##mainopts PSS-2:power}.

{phang}
{opth diff(numlist)} specifies the difference between the experimental-group
proportion and the control-group proportion, {it:p2} - {it:p1}.  You can
specify either the experimental-group proportion {it:p2} as a command argument
or the difference between the two proportions in {cmd:diff()}.  If you specify
{opt diff(#)}, the experimental-group proportion is computed as {it:p2} =
{it:p1} + {it:#}.  This option is not allowed with the effect-size
determination and may not be combined with {cmd:ratio()}, {cmd:rdiff()},
{cmd:rrisk()}, or {cmd:oratio()}.

{phang}
{opth ratio(numlist)} specifies the ratio of the experimental-group proportion
to the control-group proportion, {it:p2}/{it:p1}. You can specify either the
experimental-group proportion {it:p2} as a command argument or the ratio of
the two proportions in {cmd:ratio()}. If you specify {opt ratio(#)}, the
experimental-group proportion is computed as {it:p2} = {it:p1} x {it:#}. This
option is not allowed with the effect-size determination and may not be
combined with {cmd:diff()}, {cmd:rdiff()}, {cmd:rrisk()}, or {cmd:oratio()}.

{phang}
{opth rdiff(numlist)} specifies the risk difference {it:p2} - {it:p1}.  This is
a synonym for the {cmd:diff()} option, except the results are labeled as risk
differences.  This option is not allowed with the effect-size determination and
may not be combined with {cmd:diff()}, {cmd:ratio()}, {cmd:rrisk()}, or 
{cmd:oratio()}.

{phang}
{opth rrisk(numlist)} specifies the relative risk or risk ratio
{it:p2}/{it:p1}.  This is a synonym for the {cmd:ratio()} option, except the
results are labeled as relative risks.  This option is not allowed with the
effect-size determination and may not be combined with {cmd:diff()},
{cmd:ratio()}, {cmd:rdiff()}, or {cmd:oratio()}.

{phang}
{opth oratio(numlist)} specifies the odds ratio
{c -(}{it:p2}(1 - {it:p1}){c )-}/{c -(}{it:p1}(1 - {it:p2}){c )-}.  You can
specify either the experimental-group proportion {it:p2} as a command argument
or the odds ratio in {cmd:oratio()}.  If you specify {opt oratio(#)}, the
experimental-group proportion is computed as
{it:p2} = 1/{c -(}1+(1-{it:p1})/({it:p1} x {it:#}){c )-}.  This option is not
allowed with the effect-size determination and may not be combined with
{cmd:diff()}, {cmd:ratio()}, {cmd:rdiff()}, or {cmd:rrisk()}.

{phang}
{opt effect(effect)} specifies the type of the effect size to be
reported in the output as {cmd:delta}.  {it:effect} is one of {cmd:diff},
{cmd:ratio}, {opt rd:iff}, {opt rr:isk}, or {opt or:atio}.  By default, the
effect size {cmd:delta} is the difference between proportions.  If
{cmd:diff()}, {cmd:ratio()}, {cmd:rdiff()}, {cmd:rrisk()}, or {cmd:oratio()} is
specified, the effect size {cmd:delta} will contain the effect corresponding to
the specified option.  For example, if {cmd:oratio()} is specified, {cmd:delta}
will contain the odds ratio.

{phang}
{opt continuity} requests that continuity correction be applied to the 
normal approximation of the discrete distribution.  {opt continuity}
cannot be specified with {cmd:test(fisher)} or {cmd:test(lrchi2)}.

{phang}
{cmd:direction()}, {cmd:onesided}, {cmd:parallel}; see 
{manhelp power##mainopts PSS-2:power}.

INCLUDE help pss_taboptsdes.ihlp

INCLUDE help pss_graphoptsdes.ihlp
Also see the {mansection PSS-2 powertwoproportionsSyntaxcolumn:column} table
in {bf:[PSS-2] power twoproportions} for a list of symbols used by the graphs.

{dlgtab:Iteration}

{phang}
{opt init(#)} specifies the initial value for the estimated parameter.  For
sample-size determination, the estimated parameter is either the control-group
size n1 or, if {cmd:compute(N2)} is specified, the experimental-group size n2.
For the effect-size determination, the estimated parameter is the
experimental-group proportion p2.  The default initial values for sample sizes
for a two-sided test are based on the corresponding one-sided large-sample
z test with the significance level alpha/2.  The default initial value
for the experimental-group proportion is computed using the bisection method.

INCLUDE help pss_iteroptsdes.ihlp

{pstd}
The following options are available with {cmd:power twoproportions} but are
not shown in the dialog box:

{phang}
{opt cluster}; see
{manhelp power_twoproportions_cluster PSS-2:power twoproportions, cluster}.

INCLUDE help pss_reportoptsdes.ihlp


{marker remarks}{...}
{title:Remarks: Using power twoproportions}

{pstd}
{cmd:power twoproportions} computes sample size, power, or experimental-group
proportion for a two-sample proportions test.  All computations are performed
for a two-sided hypothesis test where, by default, the significance level is
set to 0.05.  You may change the significance level by specifying the
{cmd:alpha()} option.  You can specify the {cmd:onesided} option to request a
one-sided test.  By default, all computations assume a balanced or
equal-allocation design; see
{manlink PSS-4 Unbalanced designs} for a description of how
to specify an unbalanced design.

{pstd}
{cmd:power twoproportions} performs power analysis for three different tests,
which can be specified within the {cmd:test()} option. The default is
Pearson's chi-squared test ({cmd:test(chi2)}), which approximates the sampling
distribution of the test statistic by the standard normal distribution.  You
may instead request computations based on the likelihood-ratio test by
specifying the {cmd:test(lrchi2)} option.  To request Fisher's exact
conditional test based on the hypergeometric distribution, you can specify
{cmd:test(fisher)}. The {cmd:fisher} method is not available for computing
sample size or effect size; see
{mansection PSS-2 powertwoproportionsRemarksandexamplesex8:example 8} for
details.

{pstd}
To compute the total sample size, you must specify the control-group
proportion {it:p1}, the experimental-group proportion {it:p2}, and, optionally,
the power of the test in the {cmd:power()} option. The default power is set to
0.8.

{pstd}
Instead of the total sample size, you can compute one of the group sizes given
the other one. To compute the control-group sample size, you must specify the
{cmd:compute(N1)} option and the sample size of the experimental group in
the {cmd:n2()} option. Likewise, to compute the experimental-group sample
size, you must specify the {cmd:compute(N2)} option and the sample size of the
control group in the {cmd:n1()} option.

{pstd}
To compute power, you must specify the total sample size in the {cmd:n()}
option, the control-group proportion {it:p1}, and the experimental-group
proportion {it:p2}.

{pstd}
Instead of the experimental-group proportion {it:p2}, you can specify
other alternative measures of effect when computing sample size or power; see
{mansection PSS-2 powertwoproportionsRemarksandexamplessub1:{it:Alternative ways of specifying effect}}
in {bf:[PSS-2] power twoproportions}.

{pstd}
To compute effect size and the experimental-group proportion, you must specify
the total sample size in the {cmd:n()} option, the power in the {cmd:power()}
option, the control-group proportion {it:p1}, and optionally, the direction of
the
effect. The direction is upper by default, {cmd:direction(upper)}, which means
that the experimental-group proportion is assumed to be larger than the
specified control-group value. You can change the direction to be lower, which
means that the experimental-group proportion is assumed to be smaller than the
specified control-group value, by specifying the {cmd:direction(lower)}
option.

{pstd}
There are multiple definitions of the effect size for a two-sample proportions
test.  The {cmd:effect()} option specifies what definition {cmd:power}
{cmd:twoproportions} should use when reporting the effect size, which is
labeled as {cmd:delta} in the output of the {cmd:power} command.  The available
definitions are the difference between the experimental-group proportion and
the control-group proportion ({cmd:diff}), the ratio of the experimental-group
proportion to the control-group proportion ({cmd:ratio}), the risk difference
{it:p2} - {it:p1} ({cmd:rdiff}), the relative risk {it:p2}/{it:p1}
({cmd:rrisk}), and the odds ratio
{c -(}{it:p2}(1 - {it:p1}){c )-}/{c -(}{it:p1}(1 - {it:p2}){c )-}
({cmd:oratio}).  When {cmd:effect()} is specified, the effect size {cmd:delta}
contains the estimate of the corresponding effect and is labeled accordingly.
By default, {cmd:delta} corresponds to the difference between proportions.  If
any of the options {cmd:diff()}, {cmd:ratio()}, {cmd:rdiff()}, {cmd:rrisk()},
or {cmd:oratio()} are specified and {cmd:effect()} is not specified,
{cmd:delta} will contain the effect size corresponding to the specified
option.

{pstd}
Instead of the total sample size {cmd:n()}, you can specify individual group
sizes in {cmd:n1()} and {cmd:n2()}, or specify one of the group sizes and
{cmd:nratio()} when computing power or effect size.  Also see
{mansection PSS-4 UnbalanceddesignsRemarksandexamplesTwosamples:{it:Two samples}}
in {bf:[PSS-4] Unbalanced designs} for more details.


{marker examples}{...}
{title:Examples}

    {title:Examples: Computing sample size}

{pstd}
    Compute the total sample size required to detect an experimental-group 
    proportion of 0.5 when the control-group proportion is 0.1; assume
    a two-sided hypothesis test with a 5% significance level, a desired 
    power of 80%, and that both groups will have the same number of
    observations (the defaults){p_end}
{phang2}{cmd:. power twoproportions 0.1 0.5}

{pstd}
    Same as above, assuming the experimental-group sample size will be
    twice the control-group size{p_end}
{phang2}{cmd:. power twoproportions 0.1 0.5, nratio(2)}

{pstd}
    Same as first example, assuming the sample size of the control 
    group is known to be 60{p_end}
{phang2}{cmd:. power twoproportions 0.1 0.5, n1(60) compute(N2)}

{pstd}
    Same as first example, using a one-sided test and 10% significance
    level{p_end}
{phang2}{cmd:. power twoproportions 0.1 0.5, alpha(0.1) onesided}

{pstd}
    Same as first example, using the {cmd:diff()} option to specify the 
    difference in proportions{p_end}
{phang2}{cmd:. power twoproportions 0.1, diff(0.4)}

{pstd}
    Compute total sample size by specifying an odds ratio and a control-group
    proportion; assume a two-sided hypothesis test with a 5% significance
    level, a desired power of 80%, and that both groups will have the same
    number of observations (the defaults){p_end}
{phang2}{cmd:. power twoproportions 0.1, or(3)}

{pstd}
    Similar to above, specifying a risk ratio of 3{p_end}
{phang2}{cmd:. power twoproportions 0.1, rr(3)}

{pstd}
    Compute total sample sizes for a range of experimental-group proportions
    and powers, graphing the results{p_end}
{phang2}{cmd:. power twoproportions 0.1 (0.2(0.1)0.9), power(0.8 0.9) graph}


    {title:Examples: Computing power}

{pstd}
    Suppose we have a sample of 50 subjects.  Compute the power of a two-sided
    test to detect an experimental-group proportion of 0.5 assuming the
    control-group proportion is 0.1; assume both groups have the same number
    of observations and a 5% significance level (the default){p_end}
{phang2}{cmd:. power twoproportions 0.1 0.5, n(50)}

{pstd}
    Same as above, except we have 20 subjects in the control group and
    30 in the experimental group{p_end}
{phang2}{cmd:. power twoproportions 0.1 0.5, n1(20) n2(30)}

{pstd}
    Same as above{p_end}
{phang2}{cmd:. power twoproportions 0.1 0.5, n1(20) nratio(1.5)}

{pstd}
    Same as above{p_end}
{phang2}{cmd:. power twoproportions 0.1 0.5, n2(30) nratio(1.5)}

{pstd}
    Compute power for a range of sample sizes, graphing the results{p_end}
{phang2}{cmd:. power twoproportions 0.1 0.5, n(50(10)100) graph}


    {title:Examples: Computing the experimental-group proportion}

{pstd}
    Compute the minimum value of the experimental-group proportion that
    can be detected that exceeds the control-group proportion of 0.3 
    using a two-sided test with a total sample of 100 subjects allocated 
    equally between the two groups; assume a 5% significance level and 
    80% power (the defaults){p_end}
{phang2}{cmd:. power twoproportions 0.3, n(100) power(0.8)}

{pstd}
    Same as above{p_end}
{phang2}{cmd:. power twoproportions 0.3, n(100) power(0.8) direction(upper)}

{pstd}
    Compute the maximum proportion below 0.3 that can be detected{p_end}
{phang2}{cmd:. power twoproportions 0.3, n(100) power(0.8) direction(lower)}


{marker videos}{...}
{title:Video examples}

{phang}
{browse "https://www.youtube.com/watch?v=QyZf8H3uQ2c":How to calculate sample size for two independent proportions}

{phang}
{browse "https://www.youtube.com/watch?v=4fNjMqbK19o":How to calculate power for two independent proportions}
            
{phang}
{browse "https://www.youtube.com/watch?v=E6F5PAOKoK4":How to calculate minimum detectable effect size for two independent proportions}


{marker stored_results}{...}
{title:Stored results}

{pstd}
{cmd:power twoproportions} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
INCLUDE help pss_rrestwoprop_sc.ihlp
{synopt:{cmd: r(p1)}}control-group proportion{p_end}
{synopt:{cmd: r(p2)}}experimental-group proportion{p_end}
{synopt:{cmd: r(diff)}}difference between the experimental- and control-group
proportions{p_end}
{synopt:{cmd: r(ratio)}}ratio of the experimental-group proportion to the control-group proportion{p_end}
{synopt:{cmd: r(rdiff)}}risk difference{p_end}
{synopt:{cmd: r(rrisk)}}relative risk{p_end}
{synopt:{cmd: r(oratio)}}odds ratio{p_end}
{synopt:{cmd: r(continuity)}}{bf:1} if continuity correction is used;
{bf:0} otherwise{p_end}
INCLUDE help pss_rrestab_sc.ihlp
{synopt:{cmd: r(init)}}initial value for sample size or experimental-group proportion{p_end}
INCLUDE help pss_rresiter_sc.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(type)}}{cmd:test}{p_end}
{synopt:{cmd:r(method)}}{cmd:twoproportions}{p_end}
{synopt:{cmd:r(test)}}{cmd:chi2}, {cmd:lrchi2}, or {cmd:fisher}{p_end}
{synopt:{cmd:r(effect)}}specified effect: {cmd:diff}, {cmd:ratio}, etc.{p_end}
INCLUDE help pss_rrestest_mac.ihlp
INCLUDE help pss_rrestab_mac.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
INCLUDE help pss_rrestab_mat.ihlp
