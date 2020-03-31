{smcl}
{* *! version 1.1.11  21mar2019}{...}
{viewerdialog power "dialog power_twomeans"}{...}
{vieweralsosee "[PSS-2] power twomeans" "mansection PSS-2 powertwomeans"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power twomeans, cluster" "help power_twomeans_cluster"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power" "help power"}{...}
{vieweralsosee "[PSS-2] power oneway" "help power oneway"}{...}
{vieweralsosee "[PSS-2] power twoway" "help power twoway"}{...}
{vieweralsosee "[PSS-2] power, graph" "help power_optgraph"}{...}
{vieweralsosee "[PSS-2] power, table" "help power_opttable"}{...}
{vieweralsosee "[PSS-3] ciwidth twomeans" "help ciwidth_twomeans"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ttest" "help ttest"}{...}
{viewerjumpto "Syntax" "power_twomeans##syntax"}{...}
{viewerjumpto "Menu" "power_twomeans##menu"}{...}
{viewerjumpto "Description" "power_twomeans##description"}{...}
{viewerjumpto "Links to PDF documentation" "power_twomeans##linkspdf"}{...}
{viewerjumpto "Options" "power_twomeans##options"}{...}
{viewerjumpto "Remarks: Using power twomeans" "power_twomeans##remarks"}{...}
{viewerjumpto "Examples" "power_twomeans##examples"}{...}
{viewerjumpto "Stored results""power_twomeans##stored_results"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[PSS-2] power twomeans} {hline 2}}Power analysis for a two-sample
means test{p_end}
{p2col:}({mansection PSS-2 powertwomeans:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Compute sample size

{p 8 43 2}
{opt power} {opt twomeans} {it:m1} {it:m2}
[{cmd:,} {opth p:ower(numlist)} 
{it:{help power_twomeans##synoptions:options}}] 


{phang}
Compute power 

{p 8 43 2}
{opt power} {opt twomeans} {it:m1} {it:m2}{cmd:,} 
{opth n(numlist)}
[{it:{help power_twomeans##synoptions:options}}]


{phang}
Compute effect size and experimental-group mean 

{p 8 43 2}
{opt power} {opt twomeans} {it:m1}{cmd:,} {opth n(numlist)} 
{opth p:ower(numlist)} [{it:{help power_twomeans##synoptions:options}}]


{phang}
where {it:m1} is the mean of the control (reference) group and {it:m2} is the
mean of the experimental (comparison) group.  {it:m1} and {it:m2} may each be
specified either as one number or as a list of values in parentheses (see
{help numlist}).{p_end}


{synoptset 30 tabbed}{...}
{marker synoptions}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
INCLUDE help pss_twotestmainopts1.ihlp
{synopt: {opt nfrac:tional}}allow fractional sample sizes{p_end}
{p2coldent:* {opth diff(numlist)}}difference between the experimental-group
mean and the control-group mean, {it:m2}-{it:m1}; specify instead of the
experimental-group mean {it:m2}{p_end}
{p2coldent:* {opth sd(numlist)}}common standard deviation of the
control and the experimental groups assuming equal standard deviations in both
groups; default is {cmd:sd(1)}{p_end}
{p2coldent:* {opth sd1(numlist)}}standard deviation of the
control group; requires {cmd:sd2()}{p_end}
{p2coldent:* {opth sd2(numlist)}}standard deviation of the
experimental group; requires {cmd:sd1()}{p_end}
{synopt: {opt knownsds}}request computation assuming known standard deviations
for both groups; default is to assume unknown standard deviations{p_end}
INCLUDE help pss_testmainopts3.ihlp

{syntab:Table}
{synopt :[{cmdab:no:}]{cmdab:tab:le}[{cmd:(}{it:{help power_twomeans##tablespec:tablespec}}{cmd:)}]}suppress table or display results as a table; see
{manhelp power_opttable PSS-2:power, table}{p_end}
{synopt :{cmdab:sav:ing(}{it:{help filename}}[{cmd:, replace}]{cmd:)}}save the
table data to {it:filename}; use {cmd:replace} to overwrite existing
{it:filename}{p_end}

INCLUDE help pss_graphopts.ihlp

{syntab:Iteration}
{synopt: {opt init(#)}}initial value for sample sizes or
experimental-group mean{p_end}
INCLUDE help pss_iteropts.ihlp

{synopt: {opt cluster}}perform computations for a CRD; see
    {manhelp power_twomeans_cluster PSS-2:power twomeans, cluster}{p_end}
INCLUDE help pss_reportopts.ihlp
{synoptline}
{p2colreset}{...}
INCLUDE help pss_numlist.ihlp
{p 4 6 2}{cmd:cluster} and {cmd:notitle} do not appear in the dialog box.{p_end}

{marker tablespec}{...}
{pstd}
where {it:tablespec} is

{p 16 16 2}
{it:{help power_twomeans##column:column}}[{cmd::}{it:label}]
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
{synopt :{opt N}}total number of subjects{p_end}
{synopt :{opt N1}}number of subjects in the control group{p_end}
{synopt :{opt N2}}number of subjects in the experimental group{p_end}
{synopt :{opt nratio}}ratio of sample sizes, experimental to control{p_end}
{synopt :{opt delta}}effect size{p_end}
{synopt :{opt m1}}control-group mean{p_end}
{synopt :{opt m2}}experimental-group mean{p_end}
{synopt :{opt diff}}difference between the control-group mean and the
experimental-group mean{p_end}
{synopt :{opt sd}}common standard deviation{p_end}
{synopt :{opt sd1}}control-group standard deviation{p_end}
{synopt :{opt sd2}}experimental-group standard deviation{p_end}
{synopt :{opt target}}target parameter; synonym for {cmd:m2}{p_end}
{synopt :{opt _all}}display all supported columns{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}Column {cmd:beta} is shown in the default table in place of column
{cmd:power} if specified.{p_end}
{p 4 6 2}Columns {cmd:nratio}, {cmd:diff}, {cmd:sd}, {cmd:sd1}, and {cmd:sd2}
are shown in the default table if specified.


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
{cmd:power twomeans} computes sample size, power, or the experimental-group
mean for a two-sample means test.  By default, it computes sample size for the
given power and the values of the control-group and experimental-group means.
Alternatively, it can compute power for given sample size and values of the
control-group and experimental-group means or the experimental-group mean for
given sample size, power, and the control-group mean.    For power and
sample-size analysis in a cluster
randomized design, see
{manhelp power_twomeans_cluster PSS-2:power twomeans, cluster}.
Also see {manhelp power PSS-2} for a general introduction to the {cmd:power}
command using hypothesis tests.

{pstd}
For precision and sample-size analysis for a CI for the difference between two
means from independent samples, see
{helpb ciwidth_twomeans:[PSS-3] ciwidth twomeans}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-2 powertwomeansQuickstart:Quick start}

        {mansection PSS-2 powertwomeansRemarksandexamples:Remarks and examples}

        {mansection PSS-2 powertwomeansMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:alpha()}, {cmd:power()}, {cmd:beta()}, {cmd:n()}, {cmd:n1()},
{cmd:n2()}, {cmd:nratio()}, {cmd:compute()}, {cmd:nfractional}; 
see {manhelp power##mainopts PSS-2: power}.

{phang}
{opth diff(numlist)} specifies the difference between the experimental-group
mean and the control-group mean, {it:m2} - {it:m1}.  You can specify either the
experimental-group mean {it:m2} as a command argument or the difference between
the two means in {cmd:diff()}.  If you specify {opt diff(#)}, the
experimental-group mean is computed as {it:m2} = {it:m1} + {it:#}.  This
option is not allowed with the effect-size computation.

{phang}
{opth sd(numlist)} specifies the common standard deviation of the control and
the experimental groups assuming equal standard deviations in both groups.
The default is {cmd:sd(1)}.

{phang}
{opth sd1(numlist)} specifies the standard deviation of the control group.
If you specify {cmd:sd1()}, you must also specify {cmd:sd2()}.

{phang}
{opth sd2(numlist)} specifies the standard deviation of the experimental group.
If you specify {cmd:sd2()}, you must also specify {cmd:sd1()}.

{phang}
{opt knownsds} requests that standard deviations of each group be treated as
known in the computations. By default, standard deviations are treated as
unknown, and the computations are based on a two-sample t test, which uses a
Student's t distribution as a sampling distribution of the test statistic.
If {cmd:knownsds} is specified, the computation is based on a two-sample
z test, which uses a normal distribution as the sampling distribution of the
test statistic.

{phang}
{cmd:direction()}, {cmd:onesided}, {cmd:parallel}; see 
{manhelp power##mainopts PSS-2: power}.

INCLUDE help pss_taboptsdes.ihlp

INCLUDE help pss_graphoptsdes.ihlp
Also see the {mansection PSS-2 powertwomeansSyntaxcolumn:column} table in
{bf:[PSS-2] power twomean} for a list of symbols used by the graphs.

{dlgtab:Iteration}

{phang}
{opt init(#)} specifies the initial value for the estimated parameter.  For
sample-size determination, the estimated parameter is either the control-group
size n1 or, if {cmd:compute(N2)} is specified, the experimental-group size n2.
For the effect-size determination, the estimated parameter is the
experimental-group mean {it:m2}.  The default initial values for a two-sided
test are obtained as a closed-form solution for the corresponding one-sided
test with the significance level alpha/2.  The default initial values for the
t test computations are based on the corresponding large-sample normal
approximation.

INCLUDE help pss_iteroptsdes.ihlp

{pstd}
The following options are available with {cmd:power twomeans} but are not
shown in the dialog box:

{phang}
{opt cluster}; see {manhelp power_twomeans_cluster PSS-2:power twomeans, cluster}.

INCLUDE help pss_reportoptsdes.ihlp


{marker remarks}{...}
{title:Remarks: Using power twomeans}

{pstd}
{cmd:power twomeans} computes sample size, power, or experimental-group mean
for a two-sample means test. All computations are performed for a two-sided
hypothesis test where, by default, the significance level is set to 0.05. You
may change the significance level by specifying the {cmd:alpha()} option. You
can specify the {cmd:onesided} option to request a one-sided test. By default,
all computations assume a balanced- or equal-allocation design; see
{manlink PSS-4 Unbalanced designs} for a description of how
to specify an unbalanced design.

{pstd}
By default, all computations are for a two-sample t test, which assumes
equal and unknown standard deviations.  By default, the common standard
deviation is set to one but may be changed by specifying the {cmd:sd()}
option.  To specify different standard deviations, use the respective
{cmd:sd1()} and {cmd:sd2()} options.  These options must be specified together
and may not be used in combination with {cmd:sd()}.  When {cmd:sd1()} and
{cmd:sd2()} are specified, the computations are based on Satterthwaite's
t test, which assumes unequal and unknown standard deviations.  If standard
deviations are known, use the {cmd:knownsds} option to request that
computations be based on a two-sample z test.

{pstd}
To compute the total sample size, you must specify the control-group mean
{it:m1}, the experimental-group mean {it:m2}, and, optionally, the power of the
test in the {cmd:power()} option. The default power is set to 0.8.

{pstd}
Instead of the total sample size, you can compute one of the group sizes given
the other one. To compute the control-group sample size, you must specify the
{cmd:compute(N1)} option and the sample size of the experimental group in
the {cmd:n2()} option. Likewise, to compute the experimental-group sample
size, you must specify the {cmd:compute(N2)} option and the sample size of the
control group in the {cmd:n1()} option.

{pstd}
To compute power, you must specify the total sample size in the {cmd:n()}
option, the control-group mean {it:m1}, and the experimental-group mean
{it:m2}.

{pstd}
Instead of the experimental-group mean {it:m2}, you may specify the difference
{it:m2}-{it:m1} between the experimental-group mean and the control-group mean
in the {cmd:diff()} option when computing sample size or power.

{pstd}
To compute effect size, the difference between the
experimental-group mean and the null mean, and the experimental-group mean,
you must specify the total sample size in the {cmd:n()} option, the power in
the {cmd:power()} option, the control-group mean {it:m1}, and, optionally, the
direction of the effect. The direction is upper by default,
{cmd:direction(upper)}, which means that the experimental-group mean is
assumed to be larger than the specified control-group value. You can change
the direction to be lower, which means that the experimental-group mean is
assumed to be smaller than the specified control-group value, by specifying
the {cmd:direction(lower)} option.

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
    mean of 1.5 given a control-group mean of 1; assume that the standard 
    deviations of the two groups are both 1, a two-sided test with a
    5% significance level will be used, a power of 80%, and that both
    groups will have the same number of observations (the defaults){p_end}
{phang2}{cmd:. power twomeans 1 1.5}

{pstd}
    Same as above, using the {cmd:diff()} option to specify the difference
    between the control-group and experimental-group means{p_end}
{phang2}{cmd:. power twomeans 1, diff(0.5)}
        
{pstd}
    Same as first example, except specifying that the experimental group 
    will have twice as many observations as the control group{p_end}
{phang2}{cmd:. power twomeans 1 1.5, nratio(2)}

{pstd}
    Using the same parameters as the first example, find the sample size
    required for the experimental group if the control group is known to
    have 60 observations{p_end}
{phang2}{cmd:. power twomeans 1 1.5, n1(60) compute(N2)}

{pstd}
    Same as first example, except that the control-group standard deviation
    is 2 and that the experimental-group standard deviation is 3{p_end}
{phang2}{cmd:. power twomeans 1 1.5, sd1(2) sd2(3)}

{pstd}
    Compute the total sample size for the above parameters assuming the
    standard deviations are known{p_end}
{phang2}{cmd:. power twomeans 1 1.5, sd1(2) sd2(3) knownsds}

{pstd}
    Compute sample size required for a one-sided test with a 10% significance
    level{p_end}
{phang2}{cmd:. power twomeans 1 1.5, alpha(0.1) onesided}

{pstd}
    Compute sample sizes for a range of experimental-group means and
    powers, graphing the results{p_end}
{phang2}{cmd:. power twomeans 1 (1.1(0.1)2), power(0.8 0.9) graph}


    {title:Examples: Computing power}

{pstd}
    Suppose we have a sample of 50 subjects, and we want to compute the power
    of a two-sided test to detect an experimental-group mean of 1.5 assuming a
    control-group mean of 1; assume both groups have the same number of
    observations, both groups have standard deviations of 1, and 5%
    significance level (the defaults){p_end}
{phang2}{cmd:. power twomeans 1 1.5, n(50)}

{pstd}
    Same as above, assuming the control group has 20 observations and the
    experimental group has 30 observations{p_end}
{phang2}{cmd:. power twomeans 1 1.5, n1(20) n2(30)}

{pstd}
    Same as above{p_end}
{phang2}{cmd:. power twomeans 1 1.5, n1(20) nratio(1.5)}

{pstd}
    Same as above{p_end}
{phang2}{cmd:. power twomeans 1 1.5, n2(30) nratio(1.5)}

{pstd}
    Compute power for a range of sample sizes, graphing the results{p_end}
{phang2}{cmd:. power twomeans 1 1.5, n(50(10)100) graph}


    {title:Examples: Computing the experimental-group mean}

{pstd}
    Compute the minimum value of the experimental-group mean greater than the
    control-group mean that can be detected using a two-sided hypothesis test
    in which both groups have 100 observations with a power of 80%; assume
    a 5% significance level and that both groups have a standard deviation
    of 1 (the defaults){p_end}
{phang2}{cmd:. power twomeans 1, n(100) power(0.8)}

{pstd}
    Same as above{p_end}
{phang2}{cmd:. power twomeans 1, n(100) power(0.8) direction(upper)}

{pstd}
    Compute the maximum mean value below 1 that can be detected{p_end}
{phang2}{cmd:. power twomeans 1, n(100) power(0.8) direction(lower)}


{marker stored_results}{...}
{title:Stored results}

{pstd}
{cmd:power twomeans} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
INCLUDE help pss_rrestwotest_sc.ihlp
{synopt:{cmd: r(m1)}}control-group mean{p_end}
{synopt:{cmd: r(m2)}}experimental-group mean{p_end}
{synopt:{cmd: r(diff)}}difference between the experimental- and control-group
means{p_end}
{synopt:{cmd: r(sd)}}common standard deviation of the control and experimental
groups{p_end}
{synopt:{cmd: r(sd1)}}standard deviation of the control group{p_end}
{synopt:{cmd: r(sd2)}}standard deviation of the experimental group{p_end}
{synopt:{cmd: r(unequal)}}{cmd:1} for unequal-variances test, {cmd:0} otherwise{p_end}
{synopt:{cmd: r(knownsds)}}{cmd:1} if option {cmd:knownsds} is specified, {cmd:0} otherwise{p_end}
INCLUDE help pss_rrestab_sc.ihlp
{synopt:{cmd: r(init)}}initial value for sample sizes or experimental-group mean{p_end}
INCLUDE help pss_rresiter_sc.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(type)}}{cmd:test}{p_end}
{synopt:{cmd:r(method)}}{cmd:twomeans}{p_end}
INCLUDE help pss_rrestest_mac.ihlp
INCLUDE help pss_rrestab_mac.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
INCLUDE help pss_rrestab_mat.ihlp
