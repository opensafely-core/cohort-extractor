{smcl}
{* *! version 1.0.19  05mar2019}{...}
{viewerdialog "variance scale" "dialog power_twovar_var"}{...}
{viewerdialog "standard-deviation scale" "dialog power_twovar_sd"}{...}
{vieweralsosee "[PSS-2] power twovariances" "mansection PSS-2 powertwovariances"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power" "help power"}{...}
{vieweralsosee "[PSS-2] power, graph" "help power_optgraph"}{...}
{vieweralsosee "[PSS-2] power, table" "help power_opttable"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] sdtest" "help sdtest"}{...}
{viewerjumpto "Syntax" "power_twovariances##syntax"}{...}
{viewerjumpto "Menu" "power_twovariances##menu"}{...}
{viewerjumpto "Description" "power_twovariances##description"}{...}
{viewerjumpto "Links to PDF documentation" "power_twovariances##linkspdf"}{...}
{viewerjumpto "Options" "power_twovariances##options"}{...}
{viewerjumpto "Remarks: Using power twovariances" "power_twovariances##remarks"}{...}
{viewerjumpto "Examples" "power_twovariances##examples"}{...}
{viewerjumpto "Stored results""power_twovariances##stored_results"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[PSS-2] power twovariances} {hline 2}}Power analysis for a
two-sample variance-ratio test{p_end}
{p2col:}({mansection PSS-2 powertwovariances:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Compute sample size

{p 6 43 2}
Variance scale

{p 8 43 2}
{opt power} {opt twovar:iances} {it:v1} {it:v2}
[{cmd:,} {opth p:ower(numlist)} 
{it:{help power_twovariances##synoptions:options}}]


{p 6 43 2}
Standard deviation scale

{p 8 43 2}
{opt power} {opt twovar:iances} {it:s1} {it:s2}
{cmd:,} {cmd:sd} [{opth p:ower(numlist)} 
{it:{help power_twovariances##synoptions:options}}] 



{phang}
Compute power 

{p 6 43 2}
Variance scale

{p 8 43 2}
{opt power} {opt twovar:iances} {it:v1} {it:v2}{cmd:,} 
{opth n(numlist)} [{it:{help power_twovariances##synoptions:options}}]


{p 6 43 2}
Standard deviation scale

{p 8 43 2}
{opt power} {opt twovar:iances} {it:s1} {it:s2}{cmd:,} {cmd:sd}
{opth n(numlist)} [{it:{help power_twovariances##synoptions:options}}]



{phang}
Compute effect size and target parameter 

{p 6 43 2}
Experimental-group variance

{p 8 43 2}
{opt power} {opt twovar:iances} {it:v1}{cmd:,} {opth n(numlist)} 
{opth p:ower(numlist)} [{it:{help power_twovariances##synoptions:options}}]


{p 6 43 2}
Experimental-group standard deviation

{p 8 43 2}
{opt power} {opt twovar:iances} {it:s1}{cmd:,} {cmd:sd} {opth n(numlist)} 
{opth p:ower(numlist)} [{it:{help power_twovariances##synoptions:options}}]


{phang}
where {it:v1} and {it:s1} are variance and standard deviation, respectively,
of the control (reference) group and {it:v2} and {it:s2} are the variance and
standard deviation of the experimental (comparison) group.  Each argument may
each be specified either as one number or as a list of values in parentheses
(see {help numlist}).{p_end}


{synoptset 30 tabbed}{...}
{marker synoptions}{...}
{synopthdr:options}
{synoptline}
{synopt: {opt sd}}request computation using the standard deviation scale;
default is the variance scale{p_end}

{syntab:Main}
INCLUDE help pss_twotestmainopts1.ihlp
{synopt: {opt nfrac:tional}}allow fractional sample size{p_end}
{p2coldent:* {opth ratio(numlist)}}ratio of variances, {it:v2}/{it:v1}
(or ratio of standard deviations, {it:s2}/{it:s1}, if option {cmd:sd} is
specified); specify instead of the experimental-group variance {it:v2} (or
standard deviation {it:s2}){p_end}
INCLUDE help pss_testmainopts3.ihlp

{syntab:Table}
{synopt :[{cmdab:no:}]{cmdab:tab:le}[{cmd:(}{it:{help power_twovariances##tablespec:tablespec}}{cmd:)}]}suppress table or display results as a table; see
{manhelp power_opttable PSS-2:power, table}{p_end}
{synopt :{cmdab:sav:ing(}{it:{help filename}}[{cmd:, replace}]{cmd:)}}save the
table data to {it:filename}; use {cmd:replace} to overwrite existing
{it:filename}{p_end}

INCLUDE help pss_graphopts.ihlp

{syntab:Iteration}
{synopt: {opt init(#)}}initial value for sample sizes or
experimental-group variance{p_end}
INCLUDE help pss_iteropts.ihlp

INCLUDE help pss_reportopts.ihlp
{synoptline}
{p2colreset}{...}
INCLUDE help pss_numlist.ihlp
{p 4 6 2}{cmd:sd} does not appear in the dialog box; specification of
{cmd:sd} is done automatically by the dialog box selected.{p_end}
{p 4 6 2}{cmd:notitle} does not appear in the dialog box.{p_end}

{marker tablespec}{...}
{pstd}
where {it:tablespec} is

{p 16 16 2}
{it:{help power_twovariances##column:column}}[{cmd::}{it:label}]
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
{synopt :{opt v1}}control-group variance{p_end}
{synopt :{opt v2}}experimental-group variance{p_end}
{synopt :{opt s1}}control-group standard deviation{p_end}
{synopt :{opt s2}}experimental-group standard deviation{p_end}
{synopt :{opt ratio}}ratio of the experimental-group variance to the
control-group variance or ratio of the experimental-group standard deviation to the control-group standard deviation (if
{cmd:sd} is specified){p_end}
{synopt :{opt target}}target parameter; synonym for {cmd:v2}{p_end}
{synopt :{opt _all}}display all supported columns{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}Column {cmd:beta} is shown in the default table in place of column
{cmd:power} if specified.{p_end}
{p 4 6 2}Columns {cmd:s1} and {cmd:s2} are displayed in the default table
in place of the {cmd:v1} and {cmd:v2} columns when the {cmd:sd} option is
specified.{p_end}
{p 4 6 2}Column {cmd:ratio} is shown in the default table if specified.  If
the {cmd:sd} option is specified, this column contains the ratio of standard
deviations.  Otherwise, this column contains the ratio of variances.


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
{cmd:power twovariances} computes sample size, power, or the experimental-group
variance (or standard deviation) for a two-sample variance test.  By
default, it computes sample size for given power and the values of the
control-group and experimental-group variances.  Alternatively, it can compute
power for given sample size and values of the control-group and
experimental-group variances or the experimental-group variance for given
sample size, power, and the control-group variance.  Also see 
{manhelp power PSS-2} for a general introduction to the {cmd:power} command
using hypothesis tests.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-2 powertwovariancesQuickstart:Quick start}

        {mansection PSS-2 powertwovariancesRemarksandexamples:Remarks and examples}

        {mansection PSS-2 powertwovariancesMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt sd} specifies that the computation be performed using the
standard deviation scale.  The default is to use the variance scale.

{dlgtab:Main}

{phang}
{cmd:alpha()}, {cmd:power()}, {cmd:beta()}, {cmd:n()}, {cmd:n1()},
{cmd:n2()}, {cmd:nratio()}, {cmd:compute()}, {cmd:nfractional};
see {manhelp power##mainopts PSS-2:power}.

{phang}
{opt ratio(numlist)} specifies the ratio of the experimental-group variance to
the control-group variance, {it:v2}/{it:v1}, or the ratio of the standard
deviations, {it:s2}/{it:s1}, if option {cmd:sd} is specified.  You can specify
either the experimental-group variance {it:v2} as a command argument or the
ratio of the variances in {cmd:ratio()}.  If you specify {opt ratio(#)}, the
experimental-group variance is computed as {it:v2} = {it:v1} x {it:#}. This
option is not allowed with the effect-size determination.

{phang}
{cmd:direction()}, {cmd:onesided}, {cmd:parallel}; see 
{manhelp power##mainopts PSS-2:power}.

INCLUDE help pss_taboptsdes.ihlp

INCLUDE help pss_graphoptsdes.ihlp
Also see the {mansection PSS-2 powertwovariancesSyntaxcolumn:column} table in
{bf:[PSS-2] power twovariances} for a list of symbols used by the graphs.

{dlgtab:Iteration}

{phang}
{opt init(#)} specifies the initial value for the estimated parameter. For
sample-size determination, the estimated parameter is either the control-group
size n1 or, if {cmd:compute(N2)} is specified, the experimental-group size n2.
For the effect-size determination, the estimated parameter is the
experimental-group variance {it:v2} or, if the {cmd:sd} option is specified,
the experimental-group standard deviation {it:s2}.  The default initial values
for the variance and standard deviation for a two-sided test are obtained as a
closed-form solution for the corresponding one-sided test with the
significance level alpha/2.  The default initial values for sample sizes for a
chi-squared test are obtained from the corresponding closed-form normal
approximation.

INCLUDE help pss_iteroptsdes.ihlp

{pstd}
The following option is available with {cmd:power twovariances} but is not
shown in the dialog box:

INCLUDE help pss_reportoptsdes.ihlp


{marker remarks}{...}
{title:Remarks: Using power twovariances}

{pstd}
{cmd:power twovariances} computes sample size, power, or experimental-group
variance for a two-sample variance-ratio test.   All computations are
performed for a two-sided hypothesis test where, by default, the significance
level is set to 0.05.  You may change the significance level by specifying the
{cmd:alpha()} option.  You can specify the {cmd:onesided} option to request a
one-sided test.  By default, all computations assume a balanced- or
equal-allocation design; see
{manlink PSS-4 Unbalanced designs} for a description of how
to specify an unbalanced design.

{pstd}
In what follows, we describe the use of {cmd:power twovariances} in a
variance metric.  The corresponding use in a standard deviation metric, when
the {cmd:sd} option is specified, is the same except variances {it:v1} and
{it:v2} should be replaced with the respective standard deviations {it:s1} and
{it:s2}.  Note that computations using the variance and standard deviation
scales yield the same results; the difference is only in the specification of
the parameters.

{pstd}
To compute the total sample size, you must specify the control- and
experimental-group variances, {it:v1} and {it:v2}, respectively, and,
optionally, the power of the test in the {cmd:power()} option. The default
power is set to 0.8.

{pstd}
Instead of the total sample size, you can compute one of the group sizes given
the other one. To compute the control-group sample size, you must specify the
{cmd:compute(N1)} option and the sample size of the experimental group in
the {cmd:n2()} option. Likewise, to compute the experimental-group sample
size, you must specify the {cmd:compute(N2)} option and the sample size of the
control group in the {cmd:n1()} option.

{pstd}
To compute power, you must specify the total sample size in the {cmd:n()}
option and the control and the experimental-group variances, {it:v1} and
{it:v2}, respectively.

{pstd}
Instead of the experimental-group variance {it:v2}, you may specify the ratio
{it:v2/v1} of the experimental-group variance to the control-group
variance in the {cmd:ratio()} option when computing sample size or power.

{pstd}
To compute effect size, the ratio of the experimental-group variance to the
control-group variance, and the experimental-group variance, you must specify
the total sample size in the {cmd:n()} option, the power in the {cmd:power()}
option, the control-group variance {it:v1}, and, optionally, the direction of
the effect.  The direction is upper by default, {cmd:direction(upper)}, which
means that the experimental-group variance is assumed to be larger than the
specified control-group value. You can change the direction to be lower, which
means that the experimental-group variance is assumed to be smaller than the
specified control-group value, by specifying the {cmd:direction(lower)}
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
    Compute the sample size required to detect an experimental-group 
    variance of 3 when the control-group variance is 1.5 using a 
    two-sided test; assume a 5% significance level, 80% power, and
    equal group allocation{p_end}
{phang2}{cmd:. power twovariances 1.5 3}

{pstd}
    Same as above, assuming the experimental group will be twice as large
    as the control group{p_end}
{phang2}{cmd:. power twovariances 1.5 3, nratio(2)}

{pstd}
    Same as first example, using the {cmd:ratio()} option to specify the
    experimental-group variance to be twice that of the control-group
    variance{p_end}
{phang2}{cmd:. power twovariances 1.5, ratio(2)}

{pstd}
    Same as first example, except specifying that the control group will
    have 60 observations{p_end}
{phang2}{cmd:. power twovariances 1.5 3, n1(60) compute(N2)}

{pstd}
    Same as first example, except using a one-sided test and 10% 
    significance level{p_end}
{phang2}{cmd:. power twovariances 1.5 3, alpha(0.1) onesided}

{pstd}
    Same as first example, specifying standard deviations rather than
    variances [sqrt(3) = 1.7320]{p_end}
{phang2}{cmd:. power twovariances 1 1.7320, sd}

{pstd}
    Compute total sample sizes for a range of experimental group variances
    and powers, graphing the results{p_end}
{phang2}{cmd:. power twovariances 1.5 (2(0.1)4), power(0.8 0.9) graph}


    {title:Examples: Computing power}

{pstd}
    Suppose we have a sample of 50 subjects, and we want to compute the power
    of a two-sided test to detect an experimental-group variance of 3
    assuming the control-group variance is 4; assume the two groups have
    equal numbers of observations and a 5% significance level (the
    defaults){p_end}
{phang2}{cmd:. power twovariances 4 3, n(50)}

{pstd}
    Same as above, except that the control group has 20 observations and the
    experimental group has 30{p_end}
{phang2}{cmd:. power twovariances 4 3, n1(20) n2(30)}

{pstd}
    Same as above{p_end}
{phang2}{cmd:. power twovariances 4 3, n1(20) nratio(1.5)}

{pstd}
    Same as above{p_end}
{phang2}{cmd:. power twovariances 4 3, n2(30) nratio(1.5)}

{pstd}
    Compute power for a range of sample sizes, graphing the results{p_end}
{phang2}{cmd:. power twovariances 4 3, n(50(10)100) graph}


    {title:Examples: Computing the experimental-group variance}

{pstd}
    Compute the minimum value of the experimental-group variance that 
    exceeds the control-group variance of 2 can be detected by a two-sided
    test with 80% power in a total sample of 100 subjects; assume
    both groups have equal numbers of observations and a 5% significance
    level (the default){p_end}
{phang2}{cmd:. power twovariances 2, n(100) power(0.8)}

{pstd}
    Same as above{p_end}
{phang2}{cmd:. power twovariances 2, n(100) power(0.8) direction(upper)}

{pstd}
    Compute the maximum experimental-group variance less than the
    control-group variance of 2 that can be detected{p_end}
{phang2}{cmd:. power twovariances 2, n(100) power(0.8) direction(lower)}


{marker stored_results}{...}
{title:Stored results}

{pstd}
{cmd:power twovariances} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
INCLUDE help pss_rrestwotest_sc.ihlp
{synopt:{cmd: r(v1)}}control-group variance{p_end}
{synopt:{cmd: r(v2)}}experimental-group variance{p_end}
{synopt:{cmd: r(ratio)}}ratio of the experimental- to the control-group
variances (or standard deviations if {cmd:sd} is specified){p_end}
INCLUDE help pss_rrestab_sc.ihlp
{synopt:{cmd: r(init)}}initial value for sample sizes, experimental-group
variance, or standard deviation{p_end}
INCLUDE help pss_rresiter_sc.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(type)}}{cmd:test}{p_end}
{synopt:{cmd:r(method)}}{cmd:twovariances}{p_end}
{synopt:{cmd:r(scale)}}{cmd:variance} or {cmd:standard deviation}{p_end}
INCLUDE help pss_rrestest_mac.ihlp
INCLUDE help pss_rrestab_mac.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
INCLUDE help pss_rrestab_mat.ihlp
