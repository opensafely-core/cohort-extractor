{smcl}
{* *! version 1.0.17  27feb2019}{...}
{viewerdialog "variance scale" "dialog power_onevar_var"}{...}
{viewerdialog "standard deviation scale" "dialog power_onevar_sd"}{...}
{vieweralsosee "[PSS-2] power onevariance" "mansection PSS-2 poweronevariance"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power" "help power"}{...}
{vieweralsosee "[PSS-2] power, graph" "help power_optgraph"}{...}
{vieweralsosee "[PSS-2] power, table" "help power_opttable"}{...}
{vieweralsosee "[PSS-3] ciwidth onevariance" "help ciwidth_onevariance"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] sdtest" "help sdtest"}{...}
{viewerjumpto "Syntax" "power_onevariance##syntax"}{...}
{viewerjumpto "Menu" "power_onevariance##menu"}{...}
{viewerjumpto "Description" "power_onevariance##description"}{...}
{viewerjumpto "Links to PDF documentation" "power_onevariance##linkspdf"}{...}
{viewerjumpto "Options" "power_onevariance##options"}{...}
{viewerjumpto "Remarks: Using power onevariance" "power_onevariance##remarks"}{...}
{viewerjumpto "Examples" "power_onevariance##examples"}{...}
{viewerjumpto "Stored results" "power_onevariance##stored_results"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[PSS-2] power onevariance} {hline 2}}Power analysis for a
one-sample variance test{p_end}
{p2col:}({mansection PSS-2 poweronevariance:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Compute sample size

{p 6 43 2}
Variance scale

{p 8 43 2}
{opt power} {opt onevar:iance} {it:v0} {it:va}
    [{cmd:,} {opth p:ower(numlist)}
    {it:{help power_onevariance##synoptions:options}}]


{p 6 43 2}
Standard deviation scale

{p 8 43 2}
{opt power} {opt onevar:iance} {it:s0} {it:sa} {cmd:, sd}
  [{opth p:ower(numlist)}
{it:{help power_onevariance##synoptions:options}}]



{phang}
Compute power 

{p 6 43 2}
Variance scale

{p 8 43 2}
{opt power} {opt onevar:iance} {it:v0} {it:va}{cmd:,} {opth n(numlist)}
[{it:{help power_onevariance##synoptions:options}}]


{p 6 43 2}
Standard deviation scale

{p 8 43 2}
{opt power} {opt onevar:iance} {it:s0} {it:sa}{cmd:, sd} {opth n(numlist)}
[{it:{help power_onevariance##synoptions:options}}]



{phang}
Compute effect size and target parameter

{p 6 43 2}
Target variance

{p 8 43 2}
{opt power} {opt onevar:iance} {it:v0}{cmd:,} {opth n(numlist)}
{opth p:ower(numlist)} [{it:{help power_onevariance##synoptions:options}}]


{p 6 43 2}
Target standard deviation

{p 8 43 2}
{opt power} {opt onevar:iance} {it:s0}{cmd:, sd} {opth n(numlist)}
{opth p:ower(numlist)} [{it:{help power_onevariance##synoptions:options}}]


{phang}
where {it:v0} and {it:s0} are the null (hypothesized) variance and standard
deviation or the value of the variance and standard deviation under the null
hypothesis, and {it:va} and {it:sa} are the alternative (target) variance and
standard deviation or the value of the variance and standard deviation under
the alternative hypothesis.  Each argument may be specified either as one
number or as a list of values in parentheses (see {help numlist}).{p_end}


{synoptset 30 tabbed}{...}
{marker synoptions}{...}
{synopthdr:options}
{synoptline}
{synopt:{opt sd}}request computation using the standard deviation scale;
default is the variance scale{p_end}

{syntab:Main}
INCLUDE help pss_testmainopts1.ihlp
{synopt: {opt nfrac:tional}}allow fractional sample size{p_end}
{p2coldent:* {opth ratio(numlist)}}ratio of variances, {it:va/v0} (or ratio of
standard deviations, {it:sa/s0}, if option {cmd:sd} is specified); specify instead of the
alternative variance {it:va} (or standard deviation {it:sa}){p_end}
INCLUDE help pss_testmainopts3.ihlp

{syntab:Table}
{synopt :[{cmdab:no:}]{cmdab:tab:le}[{cmd:(}{it:{help power_onevariance##tablespec:tablespec}}{cmd:)}]}suppress table or display results as a table; see
{manhelp power_opttable PSS-2:power, table}{p_end}
{synopt :{cmdab:sav:ing(}{it:{help filename}}[{cmd:, replace}]{cmd:)}}save the
table data to {it:filename}; use {cmd:replace} to overwrite existing
{it:filename}{p_end}

INCLUDE help pss_graphopts.ihlp

{syntab:Iteration}
{synopt: {opt init(#)}}initial value for sample size or variance{p_end}
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
{it:{help power_onevariance##column:column}}[{cmd::}{it:label}]
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
{synopt :{opt v0}}null variance{p_end}
{synopt :{opt va}}alternative variance{p_end}
{synopt :{opt s0}}null standard deviation{p_end}
{synopt :{opt sa}}alternative standard deviation{p_end}
{synopt :{opt ratio}}ratio of the alternative variance to the null variance or
ratio of the alternative standard deviation to the null standard deviation (if
{cmd:sd} is specified){p_end}
{synopt :{opt target}}target parameter; synonym for {cmd:va}{p_end}
{synopt :{opt _all}}display all supported columns{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}Column {cmd:beta} is shown in the default table in place of column
{cmd:power} if specified.{p_end}
{p 4 6 2}Columns {cmd:s0} and {cmd:sa} are displayed in the default table
in place of the {cmd:v0} and {cmd:va} columns when the {cmd:sd} option is
specified.{p_end}
{p 4 6 2}Column {cmd:ratio} is shown in the default table if specified.  If
the {cmd:sd} option is specified, this column contains the ratio of standard
deviations.  Otherwise, this column contains the ratio of variances.


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
{cmd:power} {cmd:onevariance} computes sample size, power, or target variance
for a one-sample variance test.  By default, it computes sample size for given
power and the values of the variance parameters under the null and alternative
hypotheses.  Alternatively, it can compute power for given sample size and
values of the null and alternative variances or the target variance for given
sample size, power, and the null variance.  The results can also be obtained
for an equivalent standard deviation test, in which case standard deviations
are used instead of variances.  Also see
{manhelp power PSS-2} for a general introduction to the {cmd:power} command
using hypothesis tests.

{pstd}
For precision and sample-size analysis for a CI for a population variance, see
{helpb ciwidth_onevariance:[PSS-3] ciwidth onevariance}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-2 poweronevarianceQuickstart:Quick start}

        {mansection PSS-2 poweronevarianceRemarksandexamples:Remarks and examples}

        {mansection PSS-2 poweronevarianceMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt sd} specifies that the computation be performed using the
standard deviation scale. The default is to use the variance scale.  

{dlgtab:Main}

{phang}
{cmd:alpha()}, {cmd:power()}, {cmd:beta()}, {cmd:n()}, {cmd:nfractional}; see
{manhelp power##mainopts PSS-2:power}.
The {opt nfractional} option is allowed only for sample-size determination.

{phang}
{opth ratio(numlist)} specifies the ratio of the alternative variance to the
null variance, {it:va}/{it:v0}, or the ratio of standard
deviations, {it:sa}/{it:s0}, if the {cmd:sd} option is specified.  You can
specify either the alternative variance {it:va} as a command argument or the
ratio of the variances in {cmd:ratio()}.  If you specify {opt ratio(#)}, the
alternative variance is computed as {it:va} = {it:v0} x {it:#}.  This option
is not allowed with the effect-size determination. 

{phang}
{cmd:direction()}, {cmd:onesided}, {cmd:parallel}; see 
{manhelp power##mainopts PSS-2:power}.

INCLUDE help pss_taboptsdes.ihlp

INCLUDE help pss_graphoptsdes.ihlp
Also see the {mansection PSS-2 poweronevarianceSyntaxcolumn:column} table in
{bf:[PSS-2] power onevariance} for a list of symbols used by the graphs.

{dlgtab:Iteration}

{phang}
{opt init(#)} specifies an initial value for the iteration procedure.
Iteration is used to compute variance for a two-sided test and to compute
sample size.  The default initial value for the sample size is obtained from a
closed-form normal approximation.  The default initial value for the variance
is obtained from a closed-form solution for a one-sided test with the
significance level of alpha/2.

INCLUDE help pss_iteroptsdes.ihlp

{pstd}
The following option is available with {cmd:power onevariance} but is not
shown in the dialog box:

INCLUDE help pss_reportoptsdes.ihlp


{marker remarks}{...}
{title:Remarks: Using power onevariance}

{pstd}
{cmd:power onevariance} computes sample size, power, or target variance for a
one-sample variance test.  If the {cmd:sd} option is specified, {cmd:power}
{cmd:onevariance} computes sample size, power, or target standard deviation
for an equivalent one-sample standard deviation test.  All computations are
performed for a two-sided hypothesis test where, by default, the significance
level is set to 0.05.  You may change the significance level by specifying the
{cmd:alpha()} option.  You can specify the {cmd:onesided} option to request a
one-sided test.

{pstd}
In what follows, we describe the use of {cmd:power onevariance} in a variance
metric.  The corresponding use in a standard deviation metric, when the
{cmd:sd} option is specified, is the same except variances {it:v0} and {it:va}
should be replaced with the respective standard deviations {it:s0} and {it:sa}.
Note that computations using the variance and standard deviation scales yield
the same results; the difference is only in the specification of the
parameters.

{pstd}
To compute sample size, you must specify the variances under the null and
alternative hypotheses, {it:v0} and {it:va}, respectively, and, optionally,
power of the test in option {cmd:power()}.  A default power of 0.8 is assumed if
{cmd:power()} is not specified.

{pstd}
To compute power, you must specify the sample size in option {cmd:n()} and the
variances under the null and alternative hypotheses as arguments {it:v0} and
{it:va}, respectively.

{pstd}
Instead of the null and alternative variances {it:v0} and {it:va}, you can
specify the null variance {it:v0} and the ratio of the alternative variance to
the null variance in the {cmd:ratio()} option.

{pstd}
To compute effect size, the ratio of the alternative to the null variances,
and target variance, you must specify the sample size in the {cmd:n()} option,
the power in the {cmd:power()} option, the null variance {it:v0}, and,
optionally, the direction of the effect.  The direction is upper by default,
{cmd:direction(upper)}, which means that the target variance is assumed to be
larger than the specified null value.  You can change the direction to lower,
which means that the target variance is assumed to be smaller than the
specified null value, by specifying the {cmd:direction(lower)} option.

{pstd}
You can also compute power and sample size for a one-sample standard deviation
test by specifying option {cmd:sd}.  In some cases standard deviations provide a
more meaningful interpretation than variances.  For example, standard deviations
of test scores or IQ have the same scale as the sample average and provides
information about the spread of the observations around the mean.  When you
specify option {cmd:sd}, the arguments following the command name are the null
and alternative standard deviations {it:s0} and {it:sa}, respectively.  Note
that computations using the variance and standard deviation scales yield the
same results; the difference is only in the specification of the parameters.

{pstd}
By default, the computed sample size is rounded up.  You can specify the
{cmd:nfractional} option to see the corresponding fractional sample size; see
{mansection PSS-4 UnbalanceddesignsRemarksandexamplesFractionalsamplesizes:{it:Fractional sample sizes}} in
{bf:[PSS-4] Unbalanced designs} for an example.  The {cmd:nfractional} option
is allowed only for sample-size determination.

{pstd}
The test statistic for a one-sample variance test follows a chi-squared
distribution. Its degrees of freedom depends on the sample size; therefore,
sample-size computations require iteration. The effect-size determination for
a two-sided test also requires iteration. The default initial value of the
sample size is obtained using a closed-form normal approximation.  The default
initial value of the variance for the effect-size determination is obtained by
using the corresponding computation for a one-sided test with the significance
level alpha/2.  The default initial values may be changed by specifying
the {cmd:init()} option. See {manhelp power PSS-2} for the descriptions of other
options that control the iteration procedure.


{marker examples}{...}
{title:Examples}

    {title:Examples: Computing sample size}

{pstd}
    Compute the sample size required to detect a variance of 1.5 given
    a variance of 1 under the null hypothesis using a two-sided test;
    assume a 5% significance level and 80% power (the defaults){p_end}
{phang2}{cmd:. power onevariance 1 1.5}

{pstd}
    Same as above, specifying the variance under the alternative as a
    ratio of the variance under the null{p_end}
{phang2}{cmd:. power onevariance 1, ratio(1.5)}

{pstd}
    Same as first example, using a power of 90%{p_end}
{phang2}{cmd:. power onevariance 1 1.5, power(0.9)}

{pstd}
    Same as first example, specifying standard deviations rather than
    variances [sqrt(1.5) = 1.2247]{p_end}
{phang2}{cmd:. power onevariance 1 1.2247, sd}


    {title:Examples: Computing power}

{pstd}
    Suppose we have a sample of 50 subjects, and we want to compute the power
    of a two-sided hypothesis test to detect a variance of 1.5 given a
    variance of 1 under the null hypothesis; assume a 5% significance level
    (the default){p_end}
{phang2}{cmd:. power onevariance 1 1.5, n(50)}

{pstd}
    Compute power for a range of sample sizes, graphing the results{p_end}
{phang2}{cmd:. power onevariance 1 1.5, n(50(10)100) graph}


    {title:Examples: Computing target variance}

{pstd}
    Compute the minimum value of the alternative variance greater than
    the variance of 1 under the null hypothesis that can be detected using
    a two-sided hypothesis test with 50 observations and a power of 80%;
    assume a significance level of 5% (the default){p_end}
{phang2}{cmd:. power onevariance 1, n(50) power(0.8)}

{pstd}
    Same as above{p_end}
{phang2}{cmd:. power onevariance 1, n(50) power(0.8) direction(upper)}

{pstd}
    Compute the maximum variance less than the null that can be detected{p_end}
{phang2}{cmd:. power onevariance 1, n(50) power(0.8) direction(lower)}


{marker stored_results}{...}
{title:Stored results}

{pstd}
{cmd:power onevariance} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd: r(alpha)}}significance level{p_end}
{synopt:{cmd: r(power)}}power{p_end}
{synopt:{cmd: r(beta)}}probability of a type II error{p_end}
{synopt:{cmd: r(delta)}}effect size{p_end}
{synopt:{cmd: r(N)}}sample size{p_end}
{synopt:{cmd: r(nfractional)}}{cmd:1} if {cmd:nfractional} is specified, {cmd:0} otherwise{p_end}
{synopt:{cmd: r(onesided)}}{cmd:1} for a one-sided test, {cmd:0} otherwise{p_end}
{synopt:{cmd: r(v0)}}variance under the null hypothesis (for variance scale,
default){p_end}
{synopt:{cmd: r(va)}}variance under the alternative hypothesis (for variance
scale, default){p_end}
{synopt:{cmd: r(s0)}}standard deviation under the null hypothesis (if option
{cmd:sd} is specified){p_end}
{synopt:{cmd: r(sa)}}standard deviation under the alternative hypothesis (if
option {cmd:sd} is specified){p_end}
{synopt:{cmd: r(ratio)}}ratio of the alternative variance to the null variance
(or the ratio of standard deviations if option {cmd:sd} is specified){p_end}
INCLUDE help pss_rrestab_sc.ihlp
{synopt:{cmd: r(init)}}initial value for sample size or variance{p_end}
INCLUDE help pss_rresiter_sc.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(type)}}{cmd:test}{p_end}
{synopt:{cmd:r(method)}}{cmd:onevariance}{p_end}
INCLUDE help pss_rrestest_mac.ihlp
INCLUDE help pss_rrestab_mac.ihlp
{synopt:{cmd:r(scale)}}{cmd:variance} or {cmd:standard deviation}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
INCLUDE help pss_rrestab_mat.ihlp
