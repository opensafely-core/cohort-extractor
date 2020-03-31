{smcl}
{* *! version 1.0.14  27feb2019}{...}
{viewerdialog power "dialog power_onecorr"}{...}
{vieweralsosee "[PSS-2] power onecorrelation" "mansection PSS-2 poweronecorrelation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power" "help power"}{...}
{vieweralsosee "[PSS-2] power, graph" "help power_optgraph"}{...}
{vieweralsosee "[PSS-2] power, table" "help power_opttable"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] correlate" "help correlate"}{...}
{viewerjumpto "Syntax" "power_onecorrelation##syntax"}{...}
{viewerjumpto "Menu" "power_onecorrelation##menu"}{...}
{viewerjumpto "Description" "power_onecorrelation##description"}{...}
{viewerjumpto "Links to PDF documentation" "power_onecorrelation##linkspdf"}{...}
{viewerjumpto "Options" "power_onecorrelation##options"}{...}
{viewerjumpto "Remarks: Using power onecorrelation" "power_onecorrelation##remarks"}{...}
{viewerjumpto "Examples" "power_onecorrelation##examples"}{...}
{viewerjumpto "Stored results" "power_onecorrelation##stored_results"}{...}
{p2colset 1 33 35 2}{...}
{p2col:{bf:[PSS-2] power onecorrelation} {hline 2}}Power analysis for a one-sample correlation test{p_end}
{p2col:}({mansection PSS-2 poweronecorrelation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Compute sample size

{p 8 43 2}
{opt power} {opt onecorr:elation} {it:r0} {it:ra}
[{cmd:,} {opth p:ower(numlist)} 
{it:{help power_onecorrelation##synoptions:options}}]


{phang}
Compute power 

{p 8 43 2}
{opt power} {opt onecorr:elation} {it:r0} {it:ra}{cmd:,} {opth n(numlist)} 
[{it:{help power_onecorrelation##synoptions:options}}]


{phang}
Compute effect size and target correlation

{p 8 43 2}
{opt power} {opt onecorr:elation} {it:r0}{cmd:,} {opth n(numlist)} 
{opth p:ower(numlist)} [{it:{help power_onecorrelation##synoptions:options}}]


{phang}
where {it:r0} is the null (hypothesized) correlation or the value of the
correlation under the null hypothesis, and {it:ra} is the alternative (target)
correlation or the value of the correlation under the alternative hypothesis.
{it:r0} and {it:ra} may each be specified either as one number or as a list of
values in parentheses (see {help numlist}).{p_end}


{synoptset 30 tabbed}{...}
{marker synoptions}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
INCLUDE help pss_testmainopts1.ihlp
{synopt: {opt nfrac:tional}}allow fractional sample size{p_end}
{p2coldent:* {opth diff(numlist)}}difference between the alternative correlation
and the null correlation, {it:ra}-{it:r0}; specify instead of the alternative
correlation {it:ra}{p_end}
INCLUDE help pss_testmainopts3.ihlp

{syntab:Table}
{synopt :[{cmdab:no:}]{cmdab:tab:le}[{cmd:(}{it:{help power_onecorrelation##tablespec:tablespec}}{cmd:)}]}suppress table or display results as a table; see 
{manhelp power_opttable PSS-2:power, table}{p_end}
{synopt :{cmdab:sav:ing(}{it:{help filename}}[{cmd:, replace}]{cmd:)}}save the
table data to {it:filename}; use {cmd:replace} to overwrite existing
{it:filename}{p_end}

INCLUDE help pss_graphopts.ihlp

{syntab:Iteration}
{synopt: {opt init(#)}}initial value for sample size or correlation{p_end}
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
{it:{help power_onecorrelation##column:column}}[{cmd::}{it:label}]
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
{synopt :{opt r0}}null correlation{p_end}
{synopt :{opt ra}}alternative correlation{p_end}
{synopt :{opt diff}}difference between the alternative and null correlations{p_end}
{synopt :{opt target}}target parameter; synonym for {cmd:ra}{p_end}
{synopt :{opt _all}}display all supported columns{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}Column {cmd:beta} is shown in the default table in place of column
{cmd:power} if specified.{p_end}


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
{cmd:power} {cmd:onecorrelation} computes sample size, power, or target
correlation for a one-sample correlation test.  By default, it computes sample
size for given power and the values of the correlation parameters under the
null and alternative hypotheses.  Alternatively, it can compute power for
given sample size and values of the null and alternative correlations or the
target correlation for given sample size, power, and the null correlation.
Also see {manhelp power PSS-2} for a general introduction to the {cmd:power}
command using hypothesis tests.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-2 poweronecorrelationQuickstart:Quick start}

        {mansection PSS-2 poweronecorrelationRemarksandexamples:Remarks and examples}

        {mansection PSS-2 poweronecorrelationMethodsandformulas:Methods and formulas}

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
{opth diff(numlist)} specifies the difference between the alternative
correlation and the null correlation, {it:ra} - {it:r0}.  You can specify
either the alternative correlation {it:ra} as a command argument or the
difference between the two correlations in the {cmd:diff()} option.  If you
specify {opt diff(#)}, the alternative correlation is computed as {it:ra} =
{it:r0} + {it:#}.  This option is not allowed with the effect-size
determination.

{phang}
{cmd:direction()}, {cmd:onesided}, {cmd:parallel}; see
{manhelp power##mainopts PSS-2:power}.

INCLUDE help pss_taboptsdes.ihlp

INCLUDE help pss_graphoptsdes.ihlp
Also see the {mansection PSS-2 poweronecorrelationSyntaxcolumn:column} table in
{bf:[PSS-2] power onecorrelation} for a list of symbols used by the graphs.

{dlgtab:Iteration}

{phang}
{opt init(#)} specifies the initial value for the iteration procedure.
Iteration is used to compute sample size or target correlation for a two-sided
test.  The default initial value for the estimated parameter is obtained from
the corresponding closed-form one-sided computation using the significance
level alpha/2.

INCLUDE help pss_iteroptsdes.ihlp

{pstd}
The following option is available with {cmd:power onecorrelation} but is not
shown in the dialog box:

INCLUDE help pss_reportoptsdes.ihlp



{marker remarks}{...}
{title:Remarks: Using power onecorrelation}

{pstd}
{cmd:power onecorrelation} computes sample size, power, or target correlation
for a one-sample correlation test.  All computations are performed for a
two-sided hypothesis test where, by default, the significance level is set to
0.05.  You may change the significance level by specifying the {cmd:alpha()}
option.  You can specify the {cmd:onesided} option to request a one-sided
test.

{pstd}
To compute sample size, you must specify the correlations under the null and
alternative hypotheses, {it:r0} and {it:ra}, respectively, and, optionally,
the power of the test in option {cmd:power()}.  The default power is set to
0.8.

{pstd}
To compute power, you must specify the sample size in option {cmd:n()} and the
correlations under the null and alternative hypotheses, {it:r0} and {it:ra},
respectively.

{pstd}
Instead of the alternative correlation, {it:ra}, you may specify the
difference {it:ra} - {it:r0} between the alternative correlation and the null
correlation in the {cmd:diff()} option when computing sample size or power.

{pstd}
To compute effect size (and target correlation), you must specify the sample
size in option {cmd:n()}, the power in option {cmd:power()}, the null
correlation {it:r0}, and optionally, the direction of the effect.  The
direction is upper by default, {cmd:direction(upper)}, which means that the
target correlation is assumed to be larger than the specified null value.
This is also equivalent to the assumption of a positive effect size.  You can
change the direction to be lower, which means that the target correlation is
assumed to be smaller than the specified null value, by specifying the
{cmd:direction(lower)} option.  This is equivalent to assuming a negative
effect size.

{pstd}
By default, the computed sample size is rounded up.  You can specify the
{cmd:nfractional} option to see the corresponding fractional sample size; see
{mansection PSS-4 UnbalanceddesignsRemarksandexamplesFractionalsamplesizes:{it:Fractional sample sizes}} in
{bf:[PSS-4] Unbalanced designs} for an example.  The {cmd:nfractional} option is
allowed only for sample-size determination.

{pstd}
The sample-size and effect-size determinations for a two-sided test require
iteration.  The default initial value for the estimated parameter is obtained
from the corresponding closed-form one-sided computation using the
significance level alpha/2.  The default initial value may be changed by
specifying the {cmd:init()} option. See {manhelp power PSS-2} for the
descriptions of other options that control the iteration procedure.

{pstd}
In the following sections, we describe the use of {cmd:power onecorrelation}
accompanied by examples for computing sample size, power, and target
correlation.


{marker examples}{...}
{title:Examples}

    {title:Examples: Computing sample size}

{pstd}
    Compute the sample size required to detect a correlation of 0.5 with 
    80% power using a two-sided test of the null hypothesis that the 
    correlation is 0; assume a 5% significance level (the default){p_end}
{phang2}{cmd:. power onecorrelation 0 0.5}

{pstd}
    Same as above, requesting 90% power{p_end}
{phang2}{cmd:. power onecorrelation 0 0.5, power(0.9)}

{pstd}
    Same as above, using a one-sided test{p_end}
{phang2}{cmd:. power onecorrelation 0 0.5, alpha(0.1) onesided}

{pstd}
    Same as first example, except that the correlation under the null
    hypothesis is 0.2{p_end}
{phang2}{cmd:. power onecorrelation 0.2 0.5}

{pstd}
    Compute sample sizes for a range of alternative correlations and powers,
    graphing the results{p_end}
{phang2}{cmd:. power onecorrelation 0 (0.3(0.1)0.8), power(0.8 0.9) graph}


    {title:Examples: Computing power}

{pstd}
    Suppose we have a sample of 80 subjects, and we want to compute the power
    of a two-sided test to detect a correlation of 0.5 when the correlation is
    0 under the null hypothesis; assume a 5% significance level (the default)
    {p_end}
{phang2}{cmd:. power onecorrelation 0 0.5, n(80)}

{pstd}
    Compute powers for a range of alternative correlations and sample sizes,
    graphing the results{p_end}
{phang2}{cmd:. power onecorrelation 0 (0.3 0.5), n(20(10)100) graph}


    {title:Examples: Computing target correlation}

{pstd}
    Compute the minimum value of the correlation that can be detected by a
    two-sided test with 80% power in a sample of 100 subjects if the 
    correlation is 0 under the null hypothesis; assume a 5% significance
    level (the default){p_end}
{phang2}{cmd:. power onecorrelation 0, n(100) power(0.8)}

{pstd}
    Same as above{p_end}
{phang2}{cmd:. power onecorrelation 0, n(100) power(0.8) direction(upper)}

{pstd}
    Compute the maximum correlation less than the null that can
    be detected{p_end}
{phang2}{cmd:. power onecorrelation 0, n(100) power(0.8) direction(lower)}


{marker stored_results}{...}
{title:Stored results}

{pstd}
{cmd:power onecorrelation} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd: r(alpha)}}significance level{p_end}
{synopt:{cmd: r(power)}}power{p_end}
{synopt:{cmd: r(beta)}}probability of a type II error{p_end}
{synopt:{cmd: r(delta)}}effect size{p_end}
{synopt:{cmd: r(N)}}sample size{p_end}
{synopt:{cmd: r(nfractional)}}{cmd:1} if {cmd:nfractional} is specified, {cmd:0} otherwise{p_end}
{synopt:{cmd: r(onesided)}}{cmd:1} for a one-sided test, {cmd:0} otherwise{p_end}
{synopt:{cmd: r(r0)}}correlation under the null hypothesis{p_end}
{synopt:{cmd: r(ra)}}correlation under the alternative hypothesis{p_end}
{synopt:{cmd: r(diff)}}difference between the alternative and null correlations{p_end}
INCLUDE help pss_rrestab_sc.ihlp
{synopt:{cmd: r(init)}}initial value for sample size or correlation{p_end}
INCLUDE help pss_rresiter_sc.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(type)}}{cmd:test}{p_end}
{synopt:{cmd:r(method)}}{cmd:onecorrelation}{p_end}
INCLUDE help pss_rrestest_mac.ihlp
INCLUDE help pss_rrestab_mac.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
INCLUDE help pss_rrestab_mat.ihlp
