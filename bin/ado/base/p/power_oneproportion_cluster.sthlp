{smcl}
{* *! version 1.0.10  21mar2019}{...}
{viewerdialog power "dialog power_oneprop_cluster"}{...}
{vieweralsosee "[PSS-2] power oneproportion, cluster" "mansection PSS-2 poweroneproportion,cluster"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power oneproportion" "help power_oneproportion"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power" "help power"}{...}
{vieweralsosee "[PSS-2] power, graph" "help power_optgraph"}{...}
{vieweralsosee "[PSS-2] power, table" "help power_opttable"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] prtest" "help prtest"}{...}
{viewerjumpto "Syntax" "power_oneproportion_cluster##syntax"}{...}
{viewerjumpto "Menu" "power_oneproportion_cluster##menu"}{...}
{viewerjumpto "Description" "power_oneproportion_cluster##description"}{...}
{viewerjumpto "Links to PDF documentation" "power_oneproportion_cluster##linkspdf"}{...}
{viewerjumpto "Options" "power_oneproportion_cluster##options"}{...}
{viewerjumpto "Remarks: Using power oneproportion, cluster" "power_oneproportion_cluster##remarks"}{...}
{viewerjumpto "Examples" "power_oneproportion_cluster##examples"}{...}
{viewerjumpto "Stored results""power_oneproportion_cluster##results"}{...}
{p2colset 1 41 43 2}{...}
{p2col:{bf:[PSS-2] power oneproportion, cluster} {hline 2}}Power analysis
for a one-sample proportion test, CRD{p_end}
{p2col:}({mansection PSS-2 poweroneproportion,cluster:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Compute number of clusters

{p 8 20 2}
{opt power} {opt oneprop:ortion} {it:p0} {it:pa}{cmd:,}
{c -(}{opth m(numlist)} {c |} {opth n(numlist)} {cmd:cluster}{c )-}
[{it:{help power_oneproportion_cluster##synoptions:options}}] 


{phang}
Compute cluster size

{p 8 20 2}
{opt power} {opt oneprop:ortion} {it:p0} {it:pa}{cmd:,}
{opth k(numlist)}
[{it:{help power_oneproportion_cluster##synoptions:options}}] 


{phang}
Compute power 

{p 8 20 2}
{opt power} {opt oneprop:ortion} {it:p0} {it:pa}{cmd:,}
{opth k(numlist)}
{c -(}{opth m(numlist)} {c |} {opth n(numlist)}{c )-}
[{it:{help power_oneproportion_cluster##synoptions:options}}]


{phang}
Compute effect size and target proportion

{p 8 20 2}
{opt power} {opt oneprop:ortion} {it:p0}{cmd:,}
{opth k(numlist)}
{c -(}{opth m(numlist)} {c |} {opth n(numlist)}{c )-}
{opth p:ower(numlist)}
[{it:{help power_oneproportion_cluster##synoptions:options}}]


{phang}
where
{it:p0} is the null (hypothesized) proportion or the value of the proportion
under the null hypothesis and {it:pa} is the alternative (target) proportion
or the value of the proportion under the alternative hypothesis.  {it:p0} and
{it:pa} may each be specified either as one number or as a list of values in
parentheses (see {help numlist}).

{synoptset 30 tabbed}{...}
{marker synoptions}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{synopt :{opt cluster}}perform computations for a CRD; implied by 
{cmd:k()} or {cmd:m()}{p_end}
{p2coldent:* {opth a:lpha(numlist)}}significance level; default is
   {cmd:alpha(0.05)}{p_end}
{p2coldent:* {opth p:ower(numlist)}}power; default is {cmd:power(0.8)}{p_end}
{p2coldent:* {opth b:eta(numlist)}}probability of type II error; default is
   {cmd:beta(0.2)}{p_end}
{p2coldent:* {opth k(numlist)}}number of clusters{p_end}
{p2coldent:* {opth m(numlist)}}cluster size{p_end}
{p2coldent:* {opth n(numlist)}}number of observations{p_end}
{synopt:{opt nfrac:tional}}allow fractional numbers of clusters, cluster
sizes, and samples sizes{p_end}
{p2coldent:* {opth diff(numlist)}}difference between the alternative
proportion and the null proportion, {it:pa} - {it:p0}; specify instead of the
alternative proportion {it:pa}{p_end}
{p2coldent:* {opth rho(numlist)}}intraclass correlation; default is
{cmd:rho(0.5)}{p_end}
{p2coldent:* {opth cvcl:uster(numlist)}}coefficient of variation for cluster
sizes{p_end}
INCLUDE help pss_testmainopts3.ihlp

{syntab:Table}
{synopt :[{cmdab:no:}]{cmdab:tab:le}[{cmd:(}{it:{help power_oneproportion_cluster##tablespec:tablespec}}{cmd:)}]}suppress table or display results as a table; see
{manhelp power_opttable PSS-2:power, table}{p_end}
{synopt :{cmdab:sav:ing(}{it:{help filename}}[{cmd:, replace}]{cmd:)}}save the
table data to {it:filename}; use {cmd:replace} to overwrite existing
{it:filename}{p_end}

INCLUDE help pss_graphopts.ihlp

{syntab:Iteration}
{synopt: {opt init(#)}}initial value for number of clusters, cluster
size, or proportion{p_end}
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
{it:{help power_oneproportion_cluster##column:column}}[{cmd::}{it:label}]
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
{synopt :{opt K}}number of clusters{p_end}
{synopt :{opt M}}cluster size{p_end}
{synopt :{opt N}}number of observations{p_end}
{synopt :{opt delta}}effect size{p_end}
{synopt :{opt p0}}null proportion{p_end}
{synopt :{opt pa}}alternative proportion{p_end}
{synopt :{opt diff}}difference between the alternative and null proportions{p_end}
{synopt :{opt rho}}intraclass correlation{p_end}
{synopt :{opt CV_cluster}}coefficient of variation for cluster sizes{p_end}
{synopt :{opt target}}target parameter; synonym for {cmd:pa}{p_end}
{synopt :{opt _all}}display all supported columns{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}Column {cmd:beta} is shown in the default table in place of column
{cmd:power} if specified.{p_end}
{p 4 6 2}Columns {cmd:diff} and {cmd:CV_cluster} are shown in the default table if specified.{p_end}


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
{cmd:power} {cmd:oneproportion,} {cmd:cluster} computes the number of
clusters, cluster size, power, or target proportion for a one-sample
proportion test in a cluster randomized design (CRD).  It computes the number
of clusters given cluster size, power, and the values of the null and
alternative proportions.  It also computes cluster size given the number of
clusters, power, and the values of the null and alternative proportions.
Alternatively, it computes power given the number of clusters, cluster size,
and the values of the null and alternative proportions, or it computes the
target proportion given the number of clusters, cluster size, power, and the
null proportion.  See {manhelp power_oneproportion PSS-2:power oneproportion}
for a general discussion of power and sample-size analysis for a one-sample
proportion test.  Also see {manhelp power PSS-2} for a general introduction to
the {cmd:power} command using hypothesis tests.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-2 poweroneproportion,clusterQuickstart:Quick start}

        {mansection PSS-2 poweroneproportion,clusterRemarksandexamples:Remarks and examples}

        {mansection PSS-2 poweroneproportion,clusterMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:cluster} specifies that computations should be performed for a CRD.  This
option is implied when either the {cmd:k()} or {cmd:m()} option is specified.
It is required if the {cmd:n()} option is used to compute the numbers of
clusters.

{phang}
{cmd:alpha()}, {cmd:power()}, {cmd:beta()}; see
{manhelp power##mainopts PSS-2: power}.

{phang}
{opth k(numlist)} specifies the number of clusters.  This option is required
to compute the cluster size, power, or effect size.

{phang}
{opth m(numlist)} specifies the cluster size.  This option or the {cmd:n()}
option is required to compute the number of clusters, power, or effect size.
{cmd:m()} may contain noninteger values.  In this case or if the
{cmd:cvcluster()} option is specified, {cmd:m()} represents the average
cluster size.

{phang}
{opth n(numlist)} specifies the number of observations.  This option or the
{cmd:m()} option is required to compute the number of cluster, power, or
effect size.

{phang}
{cmd:nfractional}; see {manhelp power##mainopts PSS-2: power}.
The {cmd:nfractional} option is allowed when computing the number of clusters
and cluster size to display fractional (without rounding) values of the number
of clusters, cluster size, and sample size.

{phang}
{opth diff(numlist)} specifies the difference between the alternative
proportion and the null proportion, {it:pa} - {it:p0}. You can specify either
the alternative proportion {it:pa} as a command argument or the difference
between the two proportions in {opt diff()}.  If you specify {opt diff(#)},
the alternative proportion is computed as {it:pa} = {it:p0} + {it:#}.  This
option is not allowed with the effect-size determination.

{phang}
{opth rho(numlist)} specifies the intraclass correlation. The default is
{cmd:rho(0.5)}.

{phang}
{opth cvcluster(numlist)} specifies the coefficient of variation for cluster
sizes.  This option is used with varying cluster sizes.

{phang}
{cmd:direction()}, {cmd:onesided}, {cmd:parallel}; see 
{manhelp power##mainopts PSS-2: power}.

INCLUDE help pss_taboptsdes.ihlp

INCLUDE help pss_graphoptsdes.ihlp
Also see the {mansection PSS-2 poweroneproportion,clusterSyntaxcolumn:column} table in
{bf:[PSS-2] power oneproportion, cluster} for a list of symbols used by the graphs.

{dlgtab:Iteration}

{phang}
{opt init(#)} specifies the initial value for the number of clusters or
cluster size for sample-size determination or the initial value for the
proportion for the effect-size determination. The default is to use a
closed-form normal approximation to compute an initial value for the estimated
parameter.

INCLUDE help pss_iteroptsdes.ihlp

{pstd}
The following option is available with {cmd:power oneproportion, cluster} but is not
shown in the dialog box:

INCLUDE help pss_reportoptsdes.ihlp


{marker remarks}{...}
{title:Remarks: Using power oneproportion, cluster}

{pstd}
{cmd:power} {cmd:oneproportion,} {cmd:cluster} requests that computations for
the {cmd:power} {cmd:oneproportion} command be done for a CRD.  In a CRD,
groups of subjects or clusters are randomized instead of individual subjects,
so the sample size is determined by the number of clusters and the cluster
size.  The sample-size determination thus consists of the determination of the
number of clusters given cluster size or the determination of cluster size
given the number of clusters.  For a general discussion of using {cmd:power}
{cmd:oneproportion}, see
{manhelp power_oneproportion PSS-2:power oneproportion}.  The discussion below
is specific to the CRD.

{pstd}
If you specify the {cmd:cluster} option, include {cmd:k()} to specify the
number of clusters or include {cmd:m()} to specify the cluster size, the
{helpb power oneproportion} command will perform computations for a one-sample
proportion test in a CRD.  The computations for a CRD are based on the
large-sample Wald z test.

{pstd}
All computations are performed for a two-sided hypothesis test where, by
default, the significance level is set to 0.05. You may change the
significance level by specifying the {cmd:alpha()} option. You can specify the
{cmd:onesided} option to request a one-sided test.

{pstd}
To compute the number of clusters, you must specify the means under the null
and alternative hypotheses as command arguments {it:m0} and {it:ma},
respectively, and specify the cluster size in the {cmd:m()} option.
Instead of specifying the {cmd:m()} option, you may specify the sample size
in the {cmd:n()} option and specify the {cmd:cluster} option, so that
{cmd:power oneproportion} will perform its computation for a cluster
randomized design instead of the default individual-level design.  You may
also specify the power of the test in the {cmd:power()} option.

{pstd}
To compute cluster size, you must specify the null proportion {it:p0}, the
alternative proportion {it:pa}, and the number of clusters in the {cmd:k()}
option.  You may also specify the power of the test in the {cmd:power()}
option.

{pstd}
To compute power, you must specify the number of clusters in the {cmd:k()}
option, the cluster size in the {cmd:m()} option or the sample size in the
{cmd:n()} option, the null proportion {it:p0}, and the alternative proportion
{it:pa}.

{pstd}
Instead of the alternative proportion {it:pa}, you may specify the difference
{it:pa} - {it:p0} between the alternative proportion and the null proportion
in the {cmd:diff()} option when computing the number of clusters, cluster
size, or power.

{pstd}
The effect size is defined as the standardized difference between the
alternative and null proportions.  In a CRD, the effect size is also adjusted
for the cluster design; see
{mansection PSS-2 poweroneproportion,clusterMethodsandformulas:{it:Methods and formulas}}.

{pstd}
To compute effect size and the corresponding target proportion, you must
specify the number of clusters in the {cmd:k()} option, the cluster size in
the {cmd:m()} option or the sample size in the {cmd:n()} option, the power in
the {cmd:power()} option, and the null proportion {it:p0}. You may also
specify the direction of the effect in the {cmd:direction()} option. The
direction is upper by default, {cmd:direction(upper)}; see
{mansection PSS-2 poweroneproportionRemarksandexamplesUsingpoweroneproportion:{it:Using power oneproportion}}
in {bf:[PSS-2] power oneproportion} for other details.

{pstd}
All computations assume an intraclass correlation of 0.5. You can change this
by specifying the {cmd:rho()} option. Also, all clusters are assumed to be of
the same size unless the coefficient of variation for cluster sizes is
specified in the {cmd:cvcluster()} option.

{pstd}
By default, the computed number of clusters, cluster size, and sample size is
rounded up. However, you can specify the {cmd:nfractional} option to see the
corresponding fractional values; see
{mansection PSS-4 UnbalanceddesignsRemarksandexamplesFractionalsamplesizes:{it:Fractional sample sizes}}
in {bf:[PSS-4] Unbalanced designs} for an example. If the {cmd:cvcluster()}
option is specified when computing cluster size, then cluster size represents
the average cluster size and is thus not rounded. When sample size is
specified in the {cmd:n()} option, fractional cluster size may be reported to
accommodate the specified number of clusters and sample size.

{pstd}
Some of {cmd:power oneproportion,} {cmd:cluster}'s computations require
iteration, such as to compute the number of clusters for a two-sided test; see
{mansection PSS-2 poweroneproportion,clusterMethodsandformulas:{it:Methods and formulas}}
for details and {manhelp power PSS-2} for the descriptions of options that
control the iteration.


{marker examples}{...}
{title:Examples}

    {title:Examples: Computing number of clusters}

{pstd}
Given a cluster size of 5, compute number of clusters required to detect a
proportion of 0.4 when the value under the null hypothesis is 0.2; assume a
two-sided test with 80% power, a 5% significance level, and an 
intraclass correlation of 0.5 (the defaults){p_end}

{phang2}{cmd:. power oneproportion 0.2 0.4, m(5)}

{pstd}
Same as above, except using an intraclass correlation of 0.2{p_end}

{phang2}{cmd:. power oneproportion 0.2 0.4, m(5) rho(0.2)}

{pstd}
Same as above, except that the cluster size varies with a coefficient of
variation of 0.6{p_end}

{phang2}{cmd:. power oneproportion 0.2 0.4, m(5) cvcluster(0.6)}

{pstd}
Same as first example, using a one-sided test with a 1% significance level
{p_end}

{phang2}{cmd:. power oneproportion 0.2 0.4, m(5) alpha(0.01) onesided}

{pstd}
Specify a list of intraclass correlations, graphing the results{p_end}

{phang2}{cmd:. power oneproportion 0.2 0.4, m(5) rho(0.1(0.1)0.5) graph}


    {title:Examples: Computing cluster size}

{pstd}
Given 30 clusters, compute cluster size required to detect a proportion of 0.4
when the value under the null hypothesis is 0.2; assume a two-sided test with
80% power, a 5% significance level, and an intraclass correlation of 0.5 
(the defaults){p_end}

{phang2}{cmd:. power oneproportion 0.2 0.4, k(30)}

{pstd}
As above, but for 30, 35, 40, 45, 50 clusters, graphing the results{p_end}

{phang2}{cmd:. power oneproportion 0.2 0.4, k(30(5)50) graph}

{pstd}
As above, except computing the fractional cluster size{p_end}

{phang2}{cmd:.  power oneproportion 0.2 0.4, k(30(5)50) graph nfractional}


    {title:Examples: Computing power}
    
{pstd}
Compute the power of a two-sided test for 30 clusters with cluster size of 5
and the default 5% significance level, where the values of the proportion
under the null and the alternative hypotheses are known to be 0.2 and 0.4,
respectively; use the default value of 0.5 as the intraclass
correlation{p_end}

{phang2}{cmd:. power oneproportion 0.2 0.4, k(30) m(5)}

{pstd}
Compute powers for several alternative proportions, graphing the results{p_end}

{phang2}{cmd:. power oneproportion 0.2 (0.3 0.35 0.4 0.45), k(30) m(5) graph}


    {title:Examples: Computing target proportion}

{pstd}
Compute the minimum value of the proportion exceeding 0.2 that can be detected
using a two-sided test with 30 clusters with cluster size of 5; assume
a power of 80%, a 5% significance level, and an intraclass correlation
of 0.5 (the defaults){p_end}
    
{phang2}{cmd:. power oneproportion 0.2, k(30) m(5) power(0.8)}

{pstd}
Compute the maximum proportion value smaller than 0.2 that can be detected
{p_end}

{phang2}{cmd:. power oneproportion 0.2, k(30) m(5) power(0.8) direction(lower)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:power} {cmd:oneproportion,} {cmd:cluster} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(alpha)}}significance level{p_end}
{synopt:{cmd:r(power)}}power{p_end}
{synopt:{cmd:r(beta)}}probability of a type II error{p_end}
{synopt:{cmd:r(delta)}}effect size{p_end}
{synopt:{cmd:r(K)}}number of clusters{p_end}
{synopt:{cmd:r(M)}}cluster size{p_end}
{synopt:{cmd:r(N)}}number of subjects{p_end}
{synopt:{cmd:r(nfractional)}}{cmd:1} if {cmd:nfractional} is specified, {cmd:0} otherwise{p_end}
{synopt:{cmd:r(onesided)}}{cmd:1} for a one-sided test, {cmd:0} otherwise{p_end}
{synopt:{cmd:r(p0)}}proportion under the null hypothesis{p_end}
{synopt:{cmd:r(pa)}}proportion under the alternative hypothesis{p_end}
{synopt:{cmd:r(diff)}}difference between the alternative and null proportions{p_end}
{synopt:{cmd:r(rho)}}intraclass correlation{p_end}
{synopt:{cmd:r(CV_cluster)}}coefficient of variation for cluster sizes{p_end}
INCLUDE help pss_rrestab_sc.ihlp
{synopt:{cmd:r(init)}}initial value for estimated parameter{p_end}
INCLUDE help pss_rresiter_sc.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(type)}}{cmd:test}{p_end}
{synopt:{cmd:r(method)}}{cmd:oneproportion}{p_end}
{synopt:{cmd:r(design)}}{cmd:CRD}{p_end}
{synopt:{cmd:r(test)}}{cmd:wald}{p_end}
{synopt:{cmd:r(direction)}}{cmd:upper} or {cmd:lower}{p_end}
INCLUDE help pss_rrestab_mac.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(pss_table)}}table of results{p_end}
{p2colreset}{...}
