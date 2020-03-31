{smcl}
{* *! version 1.0.9  27feb2019}{...}
{viewerdialog power "dialog power_twomeans_cluster"}{...}
{vieweralsosee "[PSS-2] power twomeans, cluster" "mansection PSS-2 powertwomeans,cluster"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power twomeans" "help power_twomeans"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power" "help power"}{...}
{vieweralsosee "[PSS-2] power, graph" "help power_optgraph"}{...}
{vieweralsosee "[PSS-2] power, table" "help power_opttable"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] mixed" "help mixed"}{...}
{vieweralsosee "[R] ztest" "help ztest"}{...}
{viewerjumpto "Syntax" "power_twomeans_cluster##syntax"}{...}
{viewerjumpto "Menu" "power_twomeans_cluster##menu"}{...}
{viewerjumpto "Description" "power_twomeans_cluster##description"}{...}
{viewerjumpto "Links to PDF documentation" "power_twomeans_cluster##linkspdf"}{...}
{viewerjumpto "Options" "power_twomeans_cluster##options"}{...}
{viewerjumpto "Remarks: Using power twomeans, cluster" "power_twomeans_cluster##remarks"}{...}
{viewerjumpto "Examples" "power_twomeans_cluster##examples"}{...}
{viewerjumpto "Stored results""power_twomeans_cluster##results"}{...}
{p2colset 1 36 38 2}{...}
{p2col:{bf:[PSS-2] power twomeans, cluster} {hline 2}}Power analysis for a
two-sample means test, CRD{p_end}
{p2col:}({mansection PSS-2 powertwomeans,cluster:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Compute numbers of clusters

{p 8 20 2}
{opt power} {opt twomeans} {it:m1} {it:m2}{cmd:,}
{c -(}{it:{help power_twomeans_cluster##mspec:mspec}} {c |}
      {it:{help power_twomeans_cluster##nspec:nspec}} {cmd:cluster}{c )-}
[{it:{help power_twomeans_cluster##synoptions:options}}] 


{phang}
Compute cluster sizes

{p 8 20 2}
{opt power} {opt twomeans} {it:m1} {it:m2}{cmd:,}
{it:{help power_twomeans_cluster##kspec:kspec}}
[{it:{help power_twomeans_cluster##synoptions:options}}] 


{phang}
Compute power 

{p 8 20 2}
{opt power} {opt twomeans} {it:m1} {it:m2}{cmd:,}
{it:{help power_twomeans_cluster##kspec:kspec}}
{c -(}{it:{help power_twomeans_cluster##mspec:mspec}} {c |}
      {it:{help power_twomeans_cluster##nspec:nspec}}{c )-}
[{it:{help power_twomeans_cluster##synoptions:options}}]


{phang}
Compute effect size and experimental-group mean

{p 8 20 2}
{opt power} {opt twomeans} {it:m1}{cmd:,}
{it:{help power_twomeans_cluster##kspec:kspec}}
{c -(}{it:{help power_twomeans_cluster##mspec:mspec}} {c |}
      {it:{help power_twomeans_cluster##nspec:nspec}}{c )-}
{opth p:ower(numlist)}
[{it:{help power_twomeans_cluster##synoptions:options}}]


{phang}
where
{it:m1} is the mean in the control (reference) group and
{it:m2} is the mean in the experimental (comparison)
group.
{it:m1} and {it:m2} may each be specified either as one 
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
clusters of cluster size in one group given the other group{p_end}
{synopt:{opt nfrac:tional}}allow fractional numbers of clusters, cluster
sizes, and samples sizes{p_end}
{p2coldent:* {opth diff(numlist)}}difference between the experimental-group
mean and the control-group mean, {it:m2} - {it:m1}; specify instead of the
experimental-group mean {it:m2}{p_end}
{p2coldent:* {opth sd(numlist)}}common standard deviation of the control and
the experimental groups assuming equal standard deviations in both groups; default is {cmd:sd(1)}{p_end}
{p2coldent:* {opth sd1(numlist)}}standard deviation of the control group;
requires {cmd:sd2()}{p_end}
{p2coldent:* {opth sd2(numlist)}}standard deviation of the experimental group;
requires {cmd:sd1()}{p_end}
{p2coldent:* {opth rho(numlist)}}intraclass correlation; default is
{cmd:rho(0.5)}{p_end}
{p2coldent:* {opth cvcl:uster(numlist)}}coefficient of variation for cluster
sizes{p_end}
INCLUDE help pss_testmainopts3.ihlp

{syntab:Table}
{synopt :[{cmdab:no:}]{cmdab:tab:le}[{cmd:(}{it:{help power_twomeans_cluster##tablespec:tablespec}}{cmd:)}]}suppress table or display results as a table; see
{manhelp power_opttable PSS-2:power, table}{p_end}
{synopt :{cmdab:sav:ing(}{it:{help filename}}[{cmd:, replace}]{cmd:)}}save the
table data to {it:filename}; use {cmd:replace} to overwrite existing
{it:filename}{p_end}

INCLUDE help pss_graphopts.ihlp

{syntab:Iteration}
{synopt: {opt init(#)}}initial value for numbers of clusters, cluster sizes,
or experimental-group mean{p_end}
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
{it:{help power_twomeans_cluster##column:column}}[{cmd::}{it:label}]
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
{synopt :{opt m1}}control-group mean{p_end}
{synopt :{opt m2}}experimental-group mean{p_end}
{synopt :{opt diff}}difference between the experimental-group mean and the
control-group mean{p_end}
{synopt :{opt sd}}common standard deviation{p_end}
{synopt :{opt sd1}}control-group standard deviation{p_end}
{synopt :{opt sd2}}experimental-group standard deviation{p_end}
{synopt :{opt rho}}intraclass correlation{p_end}
{synopt :{opt CV_cluster}}coefficient of variation for cluster sizes{p_end}
{synopt :{opt target}}target parameter; synonym for {cmd:m2}{p_end}
{synopt :{opt _all}}display all supported columns{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}Column {cmd:beta} is shown in the default table in place of column
{cmd:power} if specified.{p_end}
{p 4 6 2}Column {cmd:N} is shown in the table if specified.{p_end}
{p 4 6 2}Columns {cmd:N1} and {cmd:N2} are shown in the default table if
{cmd:n1()} or {cmd:n2()} is specified.{p_end}
{p 4 6 2}Columns {cmd:nratio}, {cmd:diff}, and {cmd:CV_cluster} are shown in the default table if specified.


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
{cmd:power} {cmd:twomeans,} {cmd:cluster} computes group-specific numbers of
clusters, group-specific cluster sizes, power, or the experimental-group mean
for a two-sample means test in a cluster randomized design (CRD).  It computes
group-specific numbers of clusters given cluster sizes, power, and the values
of the control-group and experimental-group means.  It also computes
group-specific cluster sizes given numbers of clusters, power, and the values
of the control-group and experimental-group means.  Alternatively, it computes
power given numbers of clusters, cluster sizes, and the values of the
control-group and experimental-group means, or it computes the
experimental-group mean given numbers of clusters, cluster sizes, power, and
the control-group mean.  See {manhelp power_twomeans PSS-2:power twomeans} for a
general discussion of power and sample-size analysis for a two-sample mean
test.  Also see {manhelp power PSS-2} for a general introduction to the
{cmd:power} command using hypothesis tests.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-2 powertwomeans,clusterQuickstart:Quick start}

        {mansection PSS-2 powertwomeans,clusterRemarksandexamples:Remarks and examples}

        {mansection PSS-2 powertwomeans,clusterMethodsandformulas:Methods and formulas}

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
{opt diff()}, {opt sd()}, {opt sd1()}, {opt sd2()}; see
{manhelp power_twomeans PSS-2:power twomeans}.

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
Also see the {mansection PSS-2 powertwomeans,clusterSyntaxcolumn:column} table in
{bf:[PSS-2] power twomeans, cluster} for a list of symbols used by the graphs.

{dlgtab:Iteration}

{phang}
{opt init(#)} specifies the initial value for the numbers of clusters or
cluster sizes for sample-size determination or the initial value for the
experimental-group mean for the effect-size determination. The default is to
use a closed-form normal approximation to compute an initial value for the
estimated parameter.

INCLUDE help pss_iteroptsdes.ihlp

{pstd}
The following option is available with {cmd:power twomeans, cluster} but is not
shown in the dialog box:

INCLUDE help pss_reportoptsdes.ihlp


{marker remarks}{...}
{title:Remarks: Using power twomeans, cluster}

{pstd}
{cmd:power} {cmd:twomeans,} {cmd:cluster} requests that computations for the
{cmd:power} {cmd:twomeans} command be done for a CRD.  In a CRD, groups of
subjects or clusters are randomized instead of individual subjects, so the
sample size is determined by the numbers of clusters and the cluster sizes.
The sample-size determination thus consists of the determination of the
numbers of clusters given cluster sizes or the determination of cluster sizes
given the numbers of clusters.  For a general discussion of using {cmd:power}
{cmd:twomeans}, see {manhelp power_twomeans PSS-2:power twomeans}.  The
discussion below is specific to the CRD.

{pstd}
If you specify the {cmd:cluster} option, include {cmd:k1()} or {cmd:k2()} to
specify the number of clusters or include {cmd:m1()} or {cmd:m2()} to specify
the cluster size, the {helpb power twomeans} command will perform computations
for a two-sample means test in a CRD.

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
{cmd:m2()} option.  See {help power_twomeans_cluster##mspec:{it:mspec}} and
{help power_twomeans_cluster##nspec:{it:nspec}} under
{help power_twomeans_cluster##syntax:{it:Syntax}} for other specifications.
When {it:nspec} is specified, the {cmd:cluster} option is also required to
request that {cmd:power} {cmd:twomeans} perform computations for a CRD.  The 
number of clusters is assumed to be equal in the two groups, but you can
change this by specifying the ratio of the numbers of clusters in the
experimental to the control group in the {cmd:kratio()} option.  Other
parameters are specified as described in
{mansection PSS-2 powertwomeansRemarksandexamplesUsingpowertwomeans:{it:Using power twomeans}}
in {bf:[PSS-2] power twomeans}.

{pstd}
To compute the cluster sizes in both groups, you must provide the numbers of
clusters in both groups.  There are several ways to supply
the numbers of clusters; see {help power_twomeans_cluster##kspec:{it:kspec}}
under {help power_twomeans_cluster##syntax:{it:Syntax}}.  The most common
is to specify the numbers of clusters in the control group and the
experimental group in the {cmd:k1()} and {cmd:k2()} options, respectively.
Equal cluster sizes are assumed in the two groups, but you can change this by
specifying the ratio of the cluster sizes in the experimental to that of the
control group in the {cmd:mratio()} option.  Other parameters are specified as
described in
{mansection PSS-2 powertwomeansRemarksandexamplesUsingpowertwomeans:{it:Using power twomeans}}
in {bf:[PSS-2] power twomeans}.

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
The power and effect-size determination is the same as described in
{mansection PSS-2 powertwomeansRemarksandexamplesUsingpowertwomeans:{it:Using power twomeans}}
in {bf:[PSS-2] power twomeans}, but the sample-size information is supplied as
the numbers of clusters {help power_twomeans_cluster##kspec:{it:kspec}} and
either cluster sizes using {help power_twomeans_cluster##mspec:{it:mspec}} or,
less commonly, sample sizes using
{help power_twomeans_cluster##nspec:{it:nspec}}.

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
specified using {help power_twomeans_cluster##nspec:{it:nspec}}, fractional
cluster sizes may be reported to accommodate the specified numbers of clusters
and sample sizes.

{pstd}
Some of {cmd:power} {cmd:twomeans,} {cmd:cluster}'s computations require
iteration; see
{mansection PSS-2 powertwomeans,clusterMethodsandformulas:{it:Methods and formulas}}
for details and {manhelp power PSS-2} for the descriptions of options that
control the iteration.


{marker examples}{...}
{title:Examples}

    {title:Examples: Computing numbers of clusters}

{pstd}
Compute numbers of clusters required to detect an experimental-group mean of
15 given a control-group mean of 10, a cluster size of 5 for two groups, and a
standard deviation of 12 for the two groups; assume a two-sided test with a 5%
significance level, a power of 80%, and an intraclass correlation of 0.5, and
assume that both groups will have the same number of clusters (the
defaults){p_end}

{phang2}{cmd:. power twomeans 10 15, m1(5) m2(5) sd(12)}

{pstd}
Same as above, except using an intraclass correlation of 0.2{p_end}

{phang2}{cmd:. power twomeans 10 15, m1(5) m2(5) sd(12) rho(0.2)}

{pstd}
Same as above, except that the cluster size varies with a coefficient of
variation of 0.6{p_end}

{phang2}{cmd:. power twomeans 10 15, m1(5) m2(5) sd(12) rho(0.2) cvcluster(0.6)}

{pstd}
Same as first example, except that the ratio of numbers of clusters is 2 
{p_end}

{phang2}{cmd:. power twomeans 10 15, m1(5) m2(5) sd(12) kratio(2)}

{pstd}
Specify a list of intraclass correlations, graphing the results{p_end}

{phang2}{cmd:. power twomeans 10 15, m1(5) m2(5) sd(12) rho(0.1(0.1)0.5) graph}

{pstd}
Compute the number of clusters in the experimental group given that the 
number of clusters in the control group is 50{p_end}

{phang2}{cmd:. power twomeans 10 15, compute(K2) k1(50) m1(5) m2(5) sd(12)}


    {title:Examples: Computing cluster sizes}

{pstd}
Compute cluster sizes required to detect an experimental-group mean of 15
given a control-group mean of 10, given that both groups have 60 clusters and
that the standard deviations of the two groups are both 12; assume a two-sided
test with a 5% significance level, a power of 80%, and an intraclass
correlation of 0.5, and assume that both groups will have the same cluster
size (the defaults){p_end}

{phang2}{cmd:. power twomeans 10 15, k1(60) k2(60) sd(12)}

{pstd}
Same as first example, using a one-sided test with a 1% significance level
{p_end}

{phang2}{cmd:. power twomeans 10 15, k1(60) k2(60) sd(12) alpha(0.01) onesided}


    {title:Examples: Computing power}
    
{pstd}
Compute the power of a two-sided test for 30 clusters with cluster sizes of 5
in the two groups and the default 5% significance level, where the
experimental-group mean is 15 and the control-group mean is 10; use the
default value of 0.5 as the common intraclass correlation and 12 as the common
standard deviation in the two groups{p_end}

{phang2}{cmd:. power twomeans 10 15, k1(30) k2(30) m1(5) m2(5) sd(12)}

{pstd}
Compute powers for a list of numbers of clusters in the experimental group,
graphing the results{p_end}

{phang2}
{cmd:. power twomeans 10 15, k1(30) k2(10(10)60) m1(5) m2(5) sd(12) graph}


    {title:Examples: Computing target experimental-group mean}

{pstd}
Compute the minimum value of the experimental-group mean greater than the
control-group mean that can be detected using a two-sided test in which both
groups have 60 clusters of size 5; assume a power of 80%, a 5% significance
level, and an intraclass correlation of 0.5 (the defaults), and a common
standard deviation in the two groups of 12{p_end}

{phang2}{cmd:. power twomeans 10, k1(60) k2(60) m1(5) m2(5) power(0.8) sd(12)}

{pstd}
Compute the maximum mean value smaller than 10 that can be detected{p_end}

{phang2}{cmd:. power twomeans 10, k1(60) k2(60) m1(5) m2(5) power(0.8)}
         {cmd:sd(12) direction(lower)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:power} {cmd:twomeans,} {cmd:cluster} stores the following in {cmd:r()}:

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
{synopt:{cmd:r(m1)}}control-group mean{p_end}
{synopt:{cmd:r(m2)}}experimental-group mean{p_end}
{synopt:{cmd:r(diff)}}difference between the experimental- and control-group means{p_end}
{synopt:{cmd:r(sd)}}common standard deviation of the control and experimental
groups{p_end}
{synopt:{cmd:r(sd1)}}standard deviation of the control group{p_end}
{synopt:{cmd:r(sd2)}}standard deviation of the experimental group{p_end}
{synopt:{cmd:r(rho)}}intraclass correlation{p_end}
{synopt:{cmd:r(CV_cluster)}}coefficient of variation for cluster sizes{p_end}
INCLUDE help pss_rrestab_sc.ihlp
{synopt:{cmd:r(init)}}initial value for estimated parameter{p_end}
INCLUDE help pss_rresiter_sc.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(type)}}{cmd:test}{p_end}
{synopt:{cmd:r(method)}}{cmd:twomeans}{p_end}
{synopt:{cmd:r(design)}}{cmd:CRD}{p_end}
{synopt:{cmd:r(direction)}}{cmd:upper} or {cmd:lower}{p_end}
INCLUDE help pss_rrestab_mac.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(pss_table)}}table of results{p_end}
{p2colreset}{...}
