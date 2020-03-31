{smcl}
{* *! version 1.0.11  22mar2019}{...}
{viewerdialog power "dialog power_twoprop_cluster"}{...}
{vieweralsosee "[PSS-2] power twoproportions, cluster" "mansection PSS-2 powertwoproportions,cluster"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power twoproportions" "help power_twoproportions"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power" "help power"}{...}
{vieweralsosee "[PSS-2] power, graph" "help power_optgraph"}{...}
{vieweralsosee "[PSS-2] power, table" "help power_opttable"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] melogit" "help melogit"}{...}
{vieweralsosee "[R] prtest" "help prtest"}{...}
{viewerjumpto "Syntax" "power_twoproportions_cluster##syntax"}{...}
{viewerjumpto "Menu" "power_twoproportions_cluster##menu"}{...}
{viewerjumpto "Description" "power_twoproportions_cluster##description"}{...}
{viewerjumpto "Links to PDF documentation" "power_twoproportions_cluster##linkspdf"}{...}
{viewerjumpto "Options" "power_twoproportions_cluster##options"}{...}
{viewerjumpto "Remarks: Using power twoproportions, cluster" "power_twoproportions_cluster##remarks"}{...}
{viewerjumpto "Examples" "power_twoproportions_cluster##examples"}{...}
{viewerjumpto "Stored results""power_twoproportions_cluster##results"}{...}
{p2colset 1 42 44 2}{...}
{p2col:{bf:[PSS-2] power twoproportions, cluster} {hline 2}}Power analysis
for a two-sample proportions test, CRD{p_end}
{p2col:}({mansection PSS-2 powertwoproportions,cluster:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Compute numbers of clusters

{p 8 20 2}
{opt power} {opt twoprop:ortions} {it:p1} {it:p2}{cmd:,}
{c -(}{it:{help power_twoproportions_cluster##mspec:mspec}} {c |}
      {it:{help power_twoproportions_cluster##nspec:nspec}} {cmd:cluster}{c )-}
[{it:{help power_twoproportions_cluster##synoptions:options}}] 


{phang}
Compute cluster sizes

{p 8 20 2}
{opt power} {opt twoprop:ortions} {it:p1} {it:p2}{cmd:,}
{it:{help power_twoproportions_cluster##kspec:kspec}}
[{it:{help power_twoproportions_cluster##synoptions:options}}] 


{phang}
Compute power 

{p 8 20 2}
{opt power} {opt twoprop:ortions} {it:p1} {it:p2}{cmd:,}
{it:{help power_twoproportions_cluster##kspec:kspec}}
{c -(}{it:{help power_twoproportions_cluster##mspec:mspec}} {c |}
      {it:{help power_twoproportions_cluster##nspec:nspec}}{c )-}
[{it:{help power_twoproportions_cluster##synoptions:options}}]


{phang}
Compute effect size and experimental-group proportion

{p 8 20 2}
{opt power} {opt twoprop:ortions} {it:p1}{cmd:,}
{it:{help power_twoproportions_cluster##kspec:kspec}}
{c -(}{it:{help power_twoproportions_cluster##mspec:mspec}} {c |}
      {it:{help power_twoproportions_cluster##nspec:nspec}}{c )-}
{opth p:ower(numlist)}
[{it:{help power_twoproportions_cluster##synoptions:options}}]


{phang}
where
{it:p1} is the proportion in the control (reference) group and
{it:p2} is the proportion in the experimental (comparison)
group.
{it:p1} and {it:p2} may each be specified either as one 
number or as a list of values in parentheses (see {help numlist}).

{marker kspec}{...}
{marker mspec}{...}
{marker nspec}{...}
{phang2}
{it:kspec} is one of

            {cmd:k1()} {cmd:k2()}
	    {cmd:k1()} [{opt krat:io()}]
	    {cmd:k2()} [{opt krat:io()}]

{phang2}
{it:mspec} is one of

            {cmd:m1()} {cmd:m2()}
	    {cmd:m1()} [{opt mrat:io()}]
	    {cmd:m2()} [{opt mrat:io()}]

{phang2}
{it:nspec} is one of

            {cmd:n1()} {cmd:n2()}
	    {cmd:n1()} [{opt nrat:io()}]
	    {cmd:n2()} [{opt nrat:io()}]

{synoptset 30 tabbed}{...}
{marker synoptions}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{synopt :{opt cluster}}perform computations for a CRD; implied by 
{cmd:k1()}, {cmd:k2()}, {cmd:m1()}, or {cmd:m2()}{p_end}
{p2coldent:* {opth a:lpha(numlist)}}significance level; default is
   {cmd:alpha(0.05)}{p_end}
{p2coldent:* {opth p:ower(numlist)}}power; default is {cmd:power(0.8)}{p_end}
{p2coldent:* {opth b:eta(numlist)}}probability of type II error; default is
   {cmd:beta(0.2)}{p_end}
{p2coldent:* {opth k1(numlist)}}number of clusters in the control group{p_end}
{p2coldent:* {opth k2(numlist)}}number of clusters in the experimental group{p_end}
{p2coldent:* {opth krat:io(numlist)}}cluster ratio, {cmd:K2/K1};
    default is {cmd:kratio(1)}{p_end}
{p2coldent:* {opth m1(numlist)}}cluster size of the control group{p_end}
{p2coldent:* {opth m2(numlist)}}cluster size of the experimental group{p_end}
{p2coldent:* {opth mrat:io(numlist)}}cluster-size ratio, {cmd:M2/M1};
default is {cmd:mratio(1)}{p_end}
{p2coldent:* {opth n1(numlist)}}sample size of the control group{p_end}
{p2coldent:* {opth n2(numlist)}}sample size of the experimental group{p_end}
{p2coldent:* {opth nrat:io(numlist)}}sample-size ratio, {cmd:N2/N1};
    default is {cmd:nratio(1)}{p_end}
{synopt:{cmd:compute(K1}|{cmd:K2}|{cmd:M1}|{cmd:M2)}}solve for the number of
clusters or cluster size in one group given the other group{p_end}
{synopt:{opt nfrac:tional}}allow fractional numbers of clusters, cluster
sizes, and samples sizes{p_end}
{p2coldent:* {opth diff(numlist)}}difference between the experimental-group
and control-group proportions, {it:p2}-{it:p1}; specify instead of the
experimental-group proportion {it:p2}{p_end}
{p2coldent:* {opth ratio(numlist)}}ratio of the experimental-group proportion
to the control-group proportion, {it:p2}/{it:p1}; specify instead of the
experimental-group proportion {it:p2}{p_end}
{p2coldent:* {opth rd:iff(numlist)}}risk difference, {it:p2}-{it:p1};
synonym for {cmd:diff()}{p_end}
{p2coldent:* {opth rr:isk(numlist)}}relative risk, {it:p2}/{it:p1}; synonym
for {cmd:ratio()}{p_end}
{p2coldent:* {opth or:atio(numlist)}}odds ratio, {c -(}{it:p2}(1-{it:p1}){c )-}/{c -(}{it:p1}(1-{it:p2}){c )-}{p_end}
{synopt: {opth effect:(power twoproportions cluster##effectspec:effect)}}specify the
type of effect to display; default is {cmd:effect(diff)}{p_end}
{p2coldent:* {opth rho(numlist)}}intraclass correlation; default is
{cmd:rho(0.5)}{p_end}
{p2coldent:* {opth cvcl:uster(numlist)}}coefficient of variation for cluster
sizes{p_end}
INCLUDE help pss_testmainopts3.ihlp

{syntab:Table}
{synopt :[{cmdab:no:}]{cmdab:tab:le}[{cmd:(}{it:{help power_twoproportions_cluster##tablespec:tablespec}}{cmd:)}]}suppress table or display results as a table; see
{manhelp power_opttable PSS-2:power, table}{p_end}
{synopt :{cmdab:sav:ing(}{it:{help filename}}[{cmd:, replace}]{cmd:)}}save the
table data to {it:filename}; use {cmd:replace} to overwrite existing
{it:filename}{p_end}

INCLUDE help pss_graphopts.ihlp

{syntab:Iteration}
{synopt: {opt init(#)}}initial value for numbers of clusters, cluster sizes,
or experimental-group proportion{p_end}
INCLUDE help pss_iteropts.ihlp

INCLUDE help pss_reportopts.ihlp
{synoptline}
{p2colreset}{...}
INCLUDE help pss_numlist.ihlp
{p 4 6 2}{cmd:notitle} does not appear in the dialog box.{p_end}

{marker effectspec}{...}
{synoptset 30}{...}
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
{it:{help power_twoproportions_cluster##column:column}}[{cmd::}{it:label}]
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
{synopt :{opt K1}}number of clusters in the control group{p_end}
{synopt :{opt K2}}number of clusters in the experimental group{p_end}
{synopt :{opt kratio}}ratio of numbers of clusters, experimental to control{p_end}
{synopt :{opt M1}}cluster size of the control group{p_end}
{synopt :{opt M2}}cluster size of the experimental group{p_end}
{synopt :{opt mratio}}ratio of cluster sizes, experimental to control{p_end}
{synopt :{opt N}}total number of observations{p_end}
{synopt :{opt N1}}number of observations in the control group{p_end}
{synopt :{opt N2}}number of observations in the experimental group{p_end}
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
{synopt :{opt rho}}intraclass correlation{p_end}
{synopt :{opt CV_cluster}}coefficient of variation for cluster sizes{p_end}
{synopt :{opt target}}target parameter; synonym for {cmd:p2}{p_end}
{synopt :{opt _all}}display all supported columns{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}Column {cmd:beta} is shown in the default table in place of column
{cmd:power} if specified.{p_end}
{p 4 6 2}Column {cmd:N} is shown in the table if specified.{p_end}
{p 4 6 2}Columns {cmd:N1} and {cmd:N2} are shown in the default table if
{cmd:n1()} or {cmd:n2()} is specified.{p_end}
{p 4 6 2}Columns {cmd:nratio}, {cmd:diff}, {cmd:ratio}, {cmd:rdiff},
{cmd:rrisk}, {cmd:oratio}, and {cmd:CV_cluster} are shown in the default table
if specified.


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
{cmd:power} {cmd:twoproportions,} {cmd:cluster} computes group-specific
numbers of clusters, group-specific cluster sizes, power, or the
experimental-group proportion for a two-sample proportions test in a cluster
randomized design (CRD).  It computes group-specific numbers of clusters given
cluster sizes, power, and the values of the control-group and
experimental-group proportions.  It also computes group-specific cluster sizes
given numbers of clusters, power, and the values of the control-group and
experimental-group proportions.  Alternatively, it computes power given
numbers of clusters, cluster sizes, and the values of the control-group and
experimental-group proportions, or it computes the experimental-group
proportion given numbers of clusters, cluster sizes, power, and the
control-group proportion.  See
{manhelp power_twoproportions PSS-2:power twoproportions} for a general
discussion of power and sample-size analysis for a two-sample proportions test.
Also see {manhelp power PSS-2} for a general introduction to the {cmd:power}
command using hypothesis tests.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-2 powertwoproportions,clusterQuickstart:Quick start}

        {mansection PSS-2 powertwoproportions,clusterRemarksandexamples:Remarks and examples}

        {mansection PSS-2 powertwoproportions,clusterMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:cluster} specifies that computations should be performed for a CRD.  This
option is implied when the {cmd:k1()}, {cmd:k2()}, {cmd:m1()}, or {cmd:m2()}
option is specified.  {cmd:cluster} is required to compute the numbers of
clusters when {it:nspec} is used to specify sample sizes instead of {it:mspec}
for cluster sizes.

{phang}
{cmd:alpha()}, {cmd:power()}, {cmd:beta()}; see
{manhelp power##mainopts PSS-2: power}.

{phang}
{opth k1(numlist)} specifies the number of clusters in the control group.

{phang}
{opth k2(numlist)} specifies the number of clusters in the experimental group.

{phang}
{opth kratio(numlist)} specifies the ratio of the numbers of clusters of the
experimental group relative to the control group, {cmd:K2/K1}. The default is
{cmd:kratio(1)}, meaning equal numbers of clusters in the two groups.

{phang}
{opth m1(numlist)} specifies the cluster size of the control group.
{cmd:m1()} may contain noninteger values.

{phang}
{opth m2(numlist)} specifies the cluster size of the experimental group.
{cmd:m2()} may contain noninteger values.

{phang}
{opth mratio(numlist)} specifies the ratio of cluster sizes of the
experimental group relative to the control group, {cmd:M2/M1}. The default is
{cmd:mratio(1)}, meaning equal cluster sizes in the two groups.

{phang}
{cmd:n1()}, {cmd:n2()}, {cmd:nratio()};
{manhelp power##mainopts PSS-2: power}.

{phang}
{cmd:compute(K1}|{cmd:K2}|{cmd:M1}|{cmd:M2)} solve for the number of
clusters or cluster size of one group given the other group.

{phang}
{cmd:nfractional}; see {manhelp power##mainopts PSS-2: power}.
The {cmd:nfractional} option displays fractional (without rounding)
values of the numbers of clusters, cluster sizes, and sample sizes.

{phang}
{opt diff()}, {opt ratio()}, {opt rdiff()}, {opt rrisk()}, {opt oratio()},
{opt effect()}; see {manhelp power_twoproportions PSS-2:power twoproportions}.

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
Also see the {mansection PSS-2 powertwoproportions,clusterSyntaxcolumn:column} table in
{bf:[PSS-2] power twoproportions, cluster} for a list of symbols used by the
graphs.

{dlgtab:Iteration}

{phang}
{opt init(#)} specifies the initial value for the numbers of clusters or
cluster sizes for sample-size determination or the initial value for the
experimental-group proportion for the effect-size determination. The default
is to use a closed-form normal approximation to compute an initial value for
the estimated parameter.

INCLUDE help pss_iteroptsdes.ihlp

{pstd}
The following option is available with {cmd:power twoproportions, cluster} but
is not shown in the dialog box:

INCLUDE help pss_reportoptsdes.ihlp


{marker remarks}{...}
{title:Remarks: Using power twoproportions, cluster}

{pstd}
{cmd:power} {cmd:twoproportions,} {cmd:cluster} requests that computations for
the {cmd:power} {cmd:twoproportions} command be done for a CRD.  In a CRD,
groups of subjects or clusters are randomized instead of individual subjects,
so the sample size is determined by the numbers of clusters and the cluster
sizes.  The sample-size determination thus consists of the determination of
the numbers of clusters given cluster sizes or the determination of cluster
sizes given the numbers of clusters.  For a general discussion of using
{cmd:power} {cmd:twoproportions}, see
{manhelp power_twoproportions PSS-2:power twoproportions}.  The discussion
below is specific to the CRD.

{pstd}
If you specify the {cmd:cluster} option, include {cmd:k1()} or {cmd:k2()} to
specify the number of clusters or include {cmd:m1()} or {cmd:m2()} to specify
the cluster size, the {helpb power twoproportions} command will perform
computations for a two-sample proportions test in a CRD.  The computations for
a CRD are based on the large-sample Pearson's chi-squared test.

{pstd}
All computations are performed for a two-sided hypothesis test where, by
default, the significance level is set to 0.05.  You may change the
significance level by specifying the {cmd:alpha()} option.  You can specify
the {cmd:onesided} option to request a one-sided test.  By default, all
computations assume a balanced or equal-allocation design, meaning equal
numbers of clusters and cluster sizes in both groups; see
{manlink PSS-4 Unbalanced designs} for a description of how
to specify an unbalanced design.

{pstd}
To compute the number of clusters in both groups, you must provide cluster
sizes for both groups.  There are multiple ways to supply cluster
sizes, but the most common is to specify the cluster size of the control group
in the {cmd:m1()} option and the cluster size of the experimental group in the
{cmd:m2()} option.  See {help power_twoproportions_cluster##mspec:{it:mspec}}
and {help power_twoproportions_cluster##nspec:{it:nspec}} under
{help power_twoproportions_cluster##syntax:{it:Syntax}} for other
specifications.  When {it:nspec} is specified, the {cmd:cluster} option is
also required to request that {cmd:power} {cmd:twoproportions} perform
computations for a CRD.  The number of clusters is assumed to be equal in the
two groups, but you can change this by specifying the ratio of the numbers of
clusters in the experimental to the control group in the {cmd:kratio()}
option.  Other parameters are specified as described in
{mansection PSS-2 powertwoproportionsRemarksandexamplesUsingpowertwoproportions:{it:Using power twoproportions}}
in {bf:[PSS-2] power twoproportions}.

{pstd}
To compute the cluster sizes in both groups, you must provide the numbers of
clusters in both groups.  There are several ways to supply
the numbers of clusters; see
{help power_twoproportions_cluster##kspec:{it:kspec}} under
{help power_twoproportions_cluster##syntax:{it:Syntax}}.  The most common
is to specify the numbers of clusters in the control group and the
experimental group in the {cmd:k1()} and {cmd:k2()} options, respectively.
Equal cluster sizes are assumed in the two groups, but you can change this by
specifying the ratio of the cluster sizes in the experimental to that of the
control group in the {cmd:mratio()} option.  Other parameters are specified as
described in
{mansection PSS-2 powertwoproportionsRemarksandexamplesUsingpowertwoproportions:{it:Using power twoproportions}}
in {bf:[PSS-2] power twoproportions}.

{pstd}
You can also compute the number of clusters or the cluster size in one of the
groups given the number of clusters or the cluster size in the other group by
specifying the {cmd:compute()} option. For example, to compute the number of
clusters in the control group, you specify {cmd:compute(K1)} and provide the
number of clusters in the experimental group in {cmd:k2()}. Likewise, to
compute the cluster size in the control group, you specify {cmd:compute(M1)}
and provide the cluster size of the experimental group in {cmd:m2()}. You can
compute the number of clusters or cluster size for the experimental group in a
similar manner.

{pstd}
Instead of the experimental-group proportion {it:p2}, you can specify other
alternative measures of effect when computing numbers of clusters, cluster
sizes, or power; see
{mansection PSS-2 powertwoproportionsRemarksandexamplesAlternativewaysofspecifyingeffect:{it:Alternative ways of specifying effect}}
in {bf:[PSS-2] power twoproportions}.

{pstd}
The power and effect-size determination is the same as described in
{mansection PSS-2 powertwoproportionsRemarksandexamplesUsingpowertwoproportions:{it:Using power twoproportions}}
in {bf:[PSS-2] power twoproportions}, but the sample-size
information is supplied as the numbers of clusters
{help power_twoproportions_cluster##kspec:{it:kspec}} and either cluster sizes
using {help power_twoproportions_cluster##mspec:{it:mspec}} or, less commonly,
sample sizes using {help power_twoproportions_cluster##nspec:{it:nspec}}.

{pstd}
All computations assume an intraclass correlation of 0.5.  You can change this
by specifying the {cmd:rho()} option.  Also, all clusters are assumed to be of
the same size unless the coefficient of variation for cluster sizes is
specified in the {cmd:cvcluster()} option.

{pstd}
By default, the computed numbers of clusters, cluster sizes, and sample sizes
are rounded up.  However, you can specify the {cmd:nfractional} option to see
the corresponding fractional values; see
{mansection PSS-4 UnbalanceddesignsRemarksandexamplesFractionalsamplesizes:{it:Fractional sample sizes}}
in {bf:[PSS-4] Unbalanced designs} for an example.  If the {cmd:cvcluster()}
option is specified when computing cluster sizes, then cluster sizes represent
average cluster sizes and are thus not rounded.  When sample sizes are
specified using {help power_twoproportions_cluster##nspec:{it:nspec}},
fractional cluster sizes may be reported to accommodate the specified numbers
of clusters and sample sizes.

{pstd}
Some of {cmd:power} {cmd:twoproportions,} {cmd:cluster}'s computations require
iteration; see
{mansection PSS-2 powertwoproportions,clusterMethodsandformulas:{it:Methods and formulas}}
for details and {manhelp power PSS-2} for the descriptions of options that
control the iteration.


{marker examples}{...}
{title:Examples}

    {title:Examples: Computing numbers of clusters}

{pstd}
Compute numbers of clusters required to detect an experimental-group
proportion of 0.4 given a control-group proportion of 0.2 and a cluster size
of 5 for two groups; assume a two-sided test with a 5% significance level, a
power of 80%, and an intraclass correlation of 0.5, and assume that both
groups will have the same number of clusters (the defaults){p_end}

{phang2}{cmd:. power twoproportions 0.2 0.4, m1(5) m2(5)}

{pstd}
Same as above, except using an intraclass correlation of 0.2{p_end}

{phang2}{cmd:. power twoproportions 0.2 0.4, m1(5) m2(5) rho(0.2)}

{pstd}
Same as above, except that the cluster size varies with a coefficient of
variation of 0.6{p_end}

{phang2}
{cmd:. power twoproportions 0.2 0.4, m1(5) m2(5) rho(0.2) cvcluster(0.6)}

{pstd}
Same as first example, except that the ratio of numbers of clusters is 2 
{p_end}

{phang2}{cmd:. power twoproportions 0.2 0.4, m1(5) m2(5) kratio(2)}

{pstd}
Specify a list of intraclass correlations, graphing the results{p_end}

{phang2}{cmd:. power twoproportions 0.2 0.4, m1(5) m2(5) rho(0.1(0.1)0.5) graph}

{pstd}
Compute the number of clusters in the experimental group given that the 
number of clusters in the control group is 50{p_end}

{phang2}{cmd:. power twoproportions 0.2 0.4, compute(K2) k1(50) m1(5) m2(5)}


    {title:Examples: Computing cluster sizes}

{pstd}
Compute cluster sizes required to detect an experimental-group proportion of
0.4 given a control-group proportion of 0.2 and that both groups have 60
clusters; assume a two-sided test with a 5% significance level, a power of
80%, and an intraclass correlation of 0.5, and assume that both groups will
have the same cluster size (the defaults){p_end}

{phang2}{cmd:. power twoproportions 0.2 0.4, k1(60) k2(60)}

{pstd}
Same as first example, using a one-sided test with a 1% significance level
{p_end}

{phang2}{cmd:. power twoproportions 0.2 0.4, k1(60) k2(60) alpha(0.01) onesided}


    {title:Examples: Computing power}
    
{pstd}
Compute the power of a two-sided test for 30 clusters with cluster sizes of 5
in the two groups and the default 5% significance level, where the
experimental-group proportion is 0.4 and the control-group proportion is 0.2;
use the default value of 0.5 as the intraclass correlation{p_end}

{phang2}{cmd:. power twoproportions 0.2 0.4, k1(30) k2(30) m1(5) m2(5)}

{pstd}
Compute powers for a list of numbers of clusters in the experimental group,
graphing the results{p_end}

{phang2}
{cmd:. power twoproportions 0.2 0.4, k1(30) k2(10(10)60) m1(5) m2(5) graph}


    {title:Examples: Computing target experimental-group proportion}

{pstd}
Compute the minimum value of the experimental-group proportion greater than
the control-group proportion that can be detected using a two-sided test in
which both groups have 60 clusters of size 5; assume a power of 80%, a 5%
significance level, and an intraclass correlation of 0.5 (the defaults){p_end}

{phang2}{cmd:. power twoproportions 0.2, k1(60) k2(60) m1(5) m2(5) power(0.8)}

{pstd}
Compute the maximum proportion value smaller than 0.2 that can be detected
{p_end}

{phang2}
{cmd:. power twoproportions 0.2, k1(60) k2(60) m1(5) m2(5) power(0.8) direction(lower)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:power} {cmd:twoproportions,} {cmd:cluster} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(alpha)}}significance level{p_end}
{synopt:{cmd:r(power)}}power{p_end}
{synopt:{cmd:r(beta)}}probability of a type II error{p_end}
{synopt:{cmd:r(delta)}}effect size{p_end}
{synopt:{cmd:r(K1)}}number of clusters in the control group{p_end}
{synopt:{cmd:r(K2)}}number of clusters in the experimental group{p_end}
{synopt:{cmd:r(kratio)}}ratio of numbers of clusters, {cmd:K2/K1}{p_end}
{synopt:{cmd:r(M1)}}cluster size of the control group{p_end}
{synopt:{cmd:r(M2)}}cluster size of the experimental group{p_end}
{synopt:{cmd:r(mratio)}}ratio of cluster sizes, {cmd:M2/M1}{p_end}
{synopt:{cmd:r(N)}}total sample size{p_end}
{synopt:{cmd:r(N1)}}sample size for the control group{p_end}
{synopt:{cmd:r(N2)}}sample size for the experimental group{p_end}
{synopt:{cmd:r(nratio)}}ratio of sample sizes, {cmd:N2/N1}{p_end}
{synopt:{cmd:r(nfractional)}}{cmd:1} if {cmd:nfractional} is specified, {cmd:0} otherwise{p_end}
{synopt:{cmd:r(onesided)}}{cmd:1} for a one-sided test; {cmd:0}
	otherwise{p_end}
{synopt:{cmd:r(p1)}}control-group proportion{p_end}
{synopt:{cmd:r(p2)}}experimental-group proportion{p_end}
{synopt:{cmd:r(diff)}}difference between the experimental- and control-group
proportions{p_end}
{synopt:{cmd:r(ratio)}}ratio of the experimental-group proportion to the control-group proportion{p_end}
{synopt:{cmd:r(rdiff)}}risk difference{p_end}
{synopt:{cmd:r(rrisk)}}relative risk{p_end}
{synopt:{cmd:r(oratio)}}odds ratio{p_end}
{synopt:{cmd:r(rho)}}intraclass correlation{p_end}
{synopt:{cmd:r(CV_cluster)}}coefficient of variation for cluster sizes{p_end}
INCLUDE help pss_rrestab_sc.ihlp
{synopt:{cmd:r(init)}}initial value for estimated parameter{p_end}
INCLUDE help pss_rresiter_sc.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(type)}}{cmd:test}{p_end}
{synopt:{cmd:r(method)}}{cmd:twoproportions}{p_end}
{synopt:{cmd:r(design)}}{cmd:CRD}{p_end}
{synopt:{cmd:r(test)}}{cmd:chi2}{p_end}
{synopt:{cmd:r(effect)}}specified effect: {cmd:diff}, {cmd:ratio}, etc.{p_end}
{synopt:{cmd:r(direction)}}{cmd:upper} or {cmd:lower}{p_end}
INCLUDE help pss_rrestab_mac.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(pss_table)}}table of results{p_end}
{p2colreset}{...}
