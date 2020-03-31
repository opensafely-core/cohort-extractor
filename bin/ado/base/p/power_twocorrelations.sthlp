{smcl}
{* *! version 1.0.14  27feb2019}{...}
{viewerdialog power "dialog power_twocorr"}{...}
{vieweralsosee "[PSS-2] power twocorrelations" "mansection PSS-2 powertwocorrelations"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power" "help power"}{...}
{vieweralsosee "[PSS-2] power, graph" "help power_optgraph"}{...}
{vieweralsosee "[PSS-2] power, table" "help power_opttable"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] mvtest" "help mvtest"}{...}
{vieweralsosee "[R] correlate" "help correlate"}{...}
{viewerjumpto "Syntax" "power_twocorrelations##syntax"}{...}
{viewerjumpto "Menu" "power_twocorrelations##menu"}{...}
{viewerjumpto "Description" "power_twocorrelations##description"}{...}
{viewerjumpto "Links to PDF documentation" "power_twocorrelations##linkspdf"}{...}
{viewerjumpto "Options" "power_twocorrelations##options"}{...}
{viewerjumpto "Remarks: Using power twocorrelations" "power_twocorrelations##remarks"}{...}
{viewerjumpto "Examples" "power_twocorrelations##examples"}{...}
{viewerjumpto "Stored results""power_twocorrelations##stored_results"}{...}
{p2colset 1 34 36 2}{...}
{p2col:{bf:[PSS-2] power twocorrelations} {hline 2}}Power analysis for a
two-sample correlations test{p_end}
{p2col:}({mansection PSS-2 powertwocorrelations:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Compute sample size

{p 8 43 2}
{opt power} {opt twocorr:elations} {it:r1} {it:r2}
[{cmd:,} {opth p:ower(numlist)} 
{it:{help power_twocorrelations##synoptions:options}}]


{phang}
Compute power 

{p 8 43 2}
{opt power} {opt twocorr:elations} {it:r1} {it:r2}{cmd:,} 
{opth n(numlist)} [{it:{help power_twocorrelations##synoptions:options}}]


{phang}
Compute effect size and experimental-group correlation

{p 8 43 2}
{opt power} {opt twocorr:elations} {it:r1}{cmd:,}  {opth n(numlist)} 
{opth p:ower(numlist)} [{it:{help power_twocorrelations##synoptions:options}}]


{phang}
where {it:r1} is the correlation in the control (reference) group and
{it:r2} is the correlation in the experimental (comparison) group.
{it:r1} and {it:r2} may each be specified either as one number or as a list of
values in parentheses (see {it:{help numlist}}).{p_end}


{synoptset 30 tabbed}{...}
{marker synoptions}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
INCLUDE help pss_twotestmainopts1.ihlp
{synopt: {opt nfrac:tional}}allow fractional sample size{p_end}
{p2coldent:* {opth diff(numlist)}}difference between the experimental-group
and control-group correlations, {it:r2}-{it:r1}; specify instead of the
experimental-group correlation {it:r2}{p_end}
INCLUDE help pss_testmainopts3.ihlp

{syntab:Table}
{synopt :[{cmdab:no:}]{cmdab:tab:le}[{cmd:(}{it:{help power_twocorrelations##tablespec:tablespec}}{cmd:)}]}suppress table or display results as a table; see
{manhelp power_opttable PSS-2:power, table}{p_end}
{synopt :{cmdab:sav:ing(}{it:{help filename}}[{cmd:, replace}]{cmd:)}}save the
table data to {it:filename}; use {cmd:replace} to overwrite existing
{it:filename}{p_end}

INCLUDE help pss_graphopts.ihlp

{syntab:Iteration}
{synopt: {opt init(#)}}initial value for sample sizes or experimental-group
correlation{p_end}
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
{it:{help power_twocorrelations##column:column}}[{cmd::}{it:label}]
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
{synopt :{opt r1}}control-group correlation{p_end}
{synopt :{opt r2}}experimental-group correlation{p_end}
{synopt :{opt diff}}difference between the experimental-group correlation and
the control-group correlation{p_end}
{synopt :{opt target}}target parameter; synonym for {cmd:r2}{p_end}
{synopt :{opt _all}}display all supported columns{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}Column {cmd:beta} is shown in the default table in place of column
{cmd:power} if specified.{p_end}
{p 4 6 2}Columns {cmd:diff} and {cmd:nratio} are shown in the default table if
specified.


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
{cmd:power twocorrelations} computes sample size, power, or the
experimental-group correlation for a two-sample correlations test.  By default,
it computes sample size for given power and the values of the control-group and
experimental-group correlations.  Alternatively, it can compute power for given
sample size and values of the control-group and experimental-group correlations
or the experimental-group correlation for given sample size, power, and the
control-group correlation.  Also see {manhelp power PSS-2} for a general
introduction to the {cmd:power} command using hypothesis tests.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-2 powertwocorrelationsQuickstart:Quick start}

        {mansection PSS-2 powertwocorrelationsRemarksandexamples:Remarks and examples}

        {mansection PSS-2 powertwocorrelationsMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:alpha()}, {cmd:power()}, {cmd:beta()}, {cmd:n()}, {cmd:n1()},
{cmd:n2()}, {cmd:nratio()}, {cmd:compute()}, {cmd:nfractional};
see {manhelp power##mainopts PSS-2:power}.

{phang}
{opt diff(numlist)} specifies the difference between the experimental-group
correlation and the control-group correlation, {it:r2} - {it:r1}.  You can
specify either the experimental-group correlation {it:r2} as a command
argument or the difference between the two correlations in {cmd:diff()}.  If
you specify {opt diff(#)}, the experimental-group correlation is computed as
{it:r2} = {it:r1} + {it:#}.  This option is not allowed with the effect-size
determination.

{phang}
{cmd:direction()}, {cmd:onesided}, {cmd:parallel}; see 
{manhelp power##mainopts PSS-2:power}.

INCLUDE help pss_taboptsdes.ihlp

INCLUDE help pss_graphoptsdes.ihlp
Also see the {mansection PSS-2 powertwocorrelationsSyntaxcolumn:column} table
in {bf:[PSS-2] power twocorrelations} for a list of symbols used by the
graphs.

{dlgtab:Iteration}

{phang}
{opt init(#)} specifies the initial value for the estimated parameter. For
sample-size determination, the estimated parameter is either the control-group
size n1 or, if {cmd:compute(N2)} is specified, the experimental-group size n2.
For the effect-size determination, the estimated parameter is the
experimental-group correlation {it:r2}. The default initial values for a 
two-sided test are obtained as a closed-form solution for the corresponding
one-sided test with the significance level alpha/2.

INCLUDE help pss_iteroptsdes.ihlp

{pstd}
The following option is available with {cmd:power twocorrelations} but is not
shown in the dialog box:

INCLUDE help pss_reportoptsdes.ihlp


{marker remarks}{...}
{title:Remarks: Using power twocorrelations}

{pstd}
{cmd:power twocorrelations} computes sample size, power, or experimental-group
correlation for a two-sample correlations test.  All computations are
performed for a two-sided hypothesis test where, by default, the significance
level is set to 0.05.  You may change the significance level by specifying the
{cmd:alpha()} option.  You can specify the {cmd:onesided} option to request a
one-sided test.  By default, all computations assume a balanced or
equal-allocation design; see
{manlink PSS-4 Unbalanced designs} for a description of
how to specify an unbalanced design.

{pstd}
To compute the total sample size, you must specify the control- and
experimental-group correlations, {it:r1} and {it:r2}, respectively, and,
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
option and the control- and experimental-group correlations, {it:r1} and
{it:r2}, respectively.

{pstd}
Instead of the experimental-group correlation {it:r2}, you may specify the
difference {it:r2} - {it:r1} between the experimental-group correlation and the
control-group correlation in the {cmd:diff()} option when computing sample
size or power.

{pstd}
To compute effect size, the difference between the experimental-group and the
control-group correlation, and the experimental-group correlation, you must
specify the total sample size in the {cmd:n()} option, the power in the
{cmd:power()} option, the control-group correlation {it:r1}, and optionally, the
direction of the effect. The direction is upper by default,
{cmd:direction(upper)}, which means that the experimental-group correlation is
assumed to be larger than the specified control-group value. You can change
the direction to be lower, which means that the experimental-group correlation
is assumed to be smaller than the specified control-group value, by specifying
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
    correlation of 0.5 when the control-group correlation is 0 with 80%
    power using a two-sided test; assume a 5% significance level and
    an equal number of observations in each group (the defaults){p_end}
{phang2}{cmd:. power twocorrelations 0 0.5}

{pstd}
    Same as above, except that the experimental group will be twice as
    large as the control group{p_end}
{phang2}{cmd:. power twocorrelations 0 0.5, nratio(2)}

{pstd}
   Same as first example, except that the control group has 60
   observations{p_end}
{phang2}{cmd:. power twocorrelations 0 0.5, n1(60) compute(N2)}

{pstd}
   Same as first example, using a one-sided test and 10% significance
   level{p_end}
{phang2}{cmd:. power twocorrelations 0 0.5, alpha(0.1) onesided}

{pstd}
   Same as first example, using the {cmd:diff()} option to specify the
   difference between the control- and experimental-group correlations{p_end}
{phang2}{cmd:. power twocorrelations 0, diff(0.5)}

{pstd}
    Compute total sample sizes for a range of experimental-group
    correlations and powers, graphing the results{p_end}
{phang2}{cmd:. power twocorrelations 0 (0.1(0.1)0.9), power(0.8 0.9) graph}


    {title:Examples: Computing power}

{pstd}
    Suppose we have a sample of 50 subjects, and we want to compute the power
    of a two-sided test to detect an experimental-group correlation of 0.5
    assuming the control-group correlation is 0.1; assume a 5%
    significance level and an equal group allocation (the defaults){p_end}
{phang2}{cmd:. power twocorrelations 0.1 0.5, n(50)}

{pstd}
    Same as above, specifying the number of subjects in each group{p_end}
{phang2}{cmd:. power twocorrelations 0.1 0.5, n1(20) n2(30)}

{pstd}
    Same as above{p_end}
{phang2}{cmd:. power twocorrelations 0.1 0.5, n1(20) nratio(1.5)}

{pstd}
    Same as above{p_end}
{phang2}{cmd:. power twocorrelations 0.1 0.5, n2(30) nratio(1.5)}

{pstd}
    Compute power for a range of sample sizes, graphing the results{p_end}
{phang2}{cmd:. power twocorrelations 0.1 0.5, n(50(10)100) graph}


    {title:Examples: Computing the experimental-group correlation}

{pstd}
    Compute the minimum experimental-group correlation that exceeds the 
    control-group correlation of 0.3 that can be detected by a two-sided 
    test with 80% power in a total sample of 100 subjects; assume both
    groups have an equal number of observations and a 5% significance
    level (the defaults){p_end}
{phang2}{cmd:. power twocorrelations 0.3, n(100) power(0.8)}

{pstd}
    Same as above{p_end}
{phang2}{cmd:. power twocorrelations 0.3, n(100) power(0.8) direction(upper)}

{pstd}
    Compute the largest experimental-group correlation less than the
    control-group correlation of 0.3 that can be detected{p_end}
{phang2}{cmd:. power twocorrelations 0.3, n(100) power(0.8) direction(lower)}


{marker stored_results}{...}
{title:Stored results}

{pstd}
{cmd:power twocorrelations} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
INCLUDE help pss_rrestwotest_sc.ihlp
{synopt:{cmd: r(r1)}}control-group correlation{p_end}
{synopt:{cmd: r(r2)}}experimental-group correlation{p_end}
{synopt:{cmd: r(diff)}}difference between the experimental- and control-group
correlations{p_end}
INCLUDE help pss_rrestab_sc.ihlp
{synopt:{cmd: r(init)}}initial value for sample sizes or experimental-group correlation{p_end}
INCLUDE help pss_rresiter_sc.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(type)}}{cmd:test}{p_end}
{synopt:{cmd:r(method)}}{cmd:twocorrelations}{p_end}
INCLUDE help pss_rrestest_mac.ihlp
INCLUDE help pss_rrestab_mac.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
INCLUDE help pss_rrestab_mat.ihlp
