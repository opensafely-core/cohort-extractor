{smcl}
{* *! version 1.0.9  21mar2019}{...}
{viewerdialog power "dialog power_logrank_cluster"}{...}
{vieweralsosee "[PSS-2] power logrank, cluster" "mansection PSS-2 powerlogrank,cluster"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power logrank" "help power_logrank"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power" "help power"}{...}
{vieweralsosee "[PSS-2] power, graph" "help power_optgraph"}{...}
{vieweralsosee "[PSS-2] power, table" "help power_opttable"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stcox" "help stcox"}{...}
{vieweralsosee "[ST] sts test" "help sts_test"}{...}
{viewerjumpto "Syntax" "power_logrank_cluster##syntax"}{...}
{viewerjumpto "Menu" "power_logrank_cluster##menu"}{...}
{viewerjumpto "Description" "power_logrank_cluster##description"}{...}
{viewerjumpto "Links to PDF documentation" "power_logrank_cluster##linkspdf"}{...}
{viewerjumpto "Options" "power_logrank_cluster##options"}{...}
{viewerjumpto "Remarks: Using power logrank, cluster" "power_logrank_cluster##remarks"}{...}
{viewerjumpto "Examples" "power_logrank_cluster##examples"}{...}
{viewerjumpto "Stored results""power_logrank_cluster##results"}{...}
{p2colset 1 35 37 2}{...}
{p2col:{bf:[PSS-2] power logrank, cluster} {hline 2}}Power analysis for the 
log-rank test, CRD{p_end}
{p2col:}({mansection PSS-2 powerlogrank,cluster:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Compute numbers of clusters

{p 8 20 2}
{opt power} {opt log:rank} [{it:surv1} [{it:surv2}]]{cmd:,}
{c -(}{it:{help power_logrank_cluster##mspec:mspec}} {c |}
      {it:{help power_logrank_cluster##nspec:nspec}} {cmd:cluster}{c )-}
[{it:{help power_logrank_cluster##synoptions:options}}] 


{phang}
Compute cluster sizes

{p 8 20 2}
{opt power} {opt log:rank} [{it:surv1} [{it:surv2}]]{cmd:,}
{it:{help power_logrank_cluster##kspec:kspec}}
[{it:{help power_logrank_cluster##synoptions:options}}] 


{phang}
Compute power 

{p 8 20 2}
{opt power} {opt log:rank} [{it:surv1} [{it:surv2}]]{cmd:,}
{it:{help power_logrank_cluster##kspec:kspec}}
{c -(}{it:{help power_logrank_cluster##mspec:mspec}} {c |}
      {it:{help power_logrank_cluster##nspec:nspec}}{c )-}
[{it:{help power_logrank_cluster##synoptions:options}}]


{phang}
Compute effect size

{p 8 20 2}
{opt power} {opt log:rank} [{it:surv1}]{cmd:,}
{it:{help power_logrank_cluster##kspec:kspec}}
{c -(}{it:{help power_logrank_cluster##mspec:mspec}} {c |}
      {it:{help power_logrank_cluster##nspec:nspec}}{c )-}
{opth p:ower(numlist)}
[{it:{help power_logrank_cluster##synoptions:options}}]


{phang}
where
{it:surv1} is the survival probability in the control (reference) group at
the end of the study {it:t*} and
{it:surv2} is the survival probability in the experimental (comparison)
group at the end of the study {it:t*}.
{it:surv1} and {it:surv2} may each be specified either as one 
number or as a list of values in parentheses (see {help numlist}).

{marker mspec}{...}
{marker nspec}{...}
{marker kspec}{...}
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

{phang2}
{it:kspec} is one of

            {cmd:k1()} {cmd:k2()}
	    {cmd:k1()} [{opt krat:io()}]
	    {cmd:k2()} [{opt krat:io()}]

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
{synopt:{opt nfrac:tional}}allow fractional numbers of clusters, cluster
sizes, and samples sizes{p_end}
{p2coldent:* {opth hr:atio(numlist)}}hazard ratio 
   of the experimental to the control group; default is
   {cmd:hratio(0.5)}{p_end}
{p2coldent:* {opth lnhr:atio(numlist)}}log hazard-ratio
   of the experimental to the control group{p_end}
{p2coldent:* {opth rho(numlist)}}intraclass correlation; default is {cmd:rho(0.5)}{p_end}
{p2coldent:* {opth cvcl:uster(numlist)}}coefficient of variation for cluster
sizes{p_end}
INCLUDE help pss_testmainopts2.ihlp

{syntab:Table}
{synopt :[{cmdab:no:}]{cmdab:tab:le}[{cmd:(}{it:{help power_logrank_cluster##tablespec:tablespec}}{cmd:)}]}suppress table or display results as a table; see
{manhelp power_opttable PSS-2:power, table}{p_end}
{synopt :{cmdab:sav:ing(}{it:{help filename}}[{cmd:, replace}]{cmd:)}}save the
table data to {it:filename}; use {cmd:replace} to overwrite existing
{it:filename}{p_end}

INCLUDE help pss_graphopts.ihlp

{syntab:Iteration}
{synopt: {opt init(#)}}initial value for hazard ratio{p_end}
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
{it:{help power_logrank_cluster##column:column}}[{cmd::}{it:label}]
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
{synopt :{opt E}}total number of events (failures){p_end}
{synopt :{opt hratio}}hazard ratio{p_end}
{synopt :{opt lnhratio}}log hazard-ratio{p_end}
{synopt :{opt s1}}survival probability in the control group{p_end}
{synopt :{opt s2}}survival probability in the experimental group{p_end}
{synopt :{opt Pr_E}}overall probability of an event (failure){p_end}
{synopt :{opt rho}}intraclass correlation{p_end}
{synopt :{opt CV_cluster}}coefficient of variation for cluster sizes{p_end}
{synopt :{opt target}}target parameter; {cmd:hratio}{p_end}
{synopt :{opt _all}}display all supported columns{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}Column {cmd:beta} is shown in the default table in place of column
{cmd:power} if specified.{p_end}
{p 4 6 2}Column {cmd:N} is shown in the table if specified.{p_end}
{p 4 6 2}Columns {cmd:N1} and {cmd:N2} are shown in the default table if
{cmd:n1()} or {cmd:n2()} is specified.{p_end}
{p 4 6 2}Column {cmd:lnhratio} is shown in the default table in place of
column {cmd:hratio} if specified.{p_end}
{p 4 6 2}Columns {cmd:s1} and {cmd:s2} are available only when
specified.{p_end}
{p 4 6 2}Columns {cmd:nratio} and {cmd:CV_cluster} are shown in the default table if specified.


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
{cmd:power} {cmd:logrank,} {cmd:cluster} computes group-specific numbers of
clusters, group-specific cluster sizes, power, or the hazard ratio for the
log-rank test comparing survivor functions in two groups in a cluster
randomized design (CRD). Without censoring, the survival input parameter is
the hazard ratio; otherwise, the survival input parameters are the
control-group and experimental-group survival probabilities.

{pstd}
{cmd:power} {cmd:logrank,} {cmd:cluster} computes group-specific numbers of
clusters given cluster sizes, power, and survival parameters. It also computes
group-specific cluster sizes given numbers of clusters, power, and survival
parameters. Alternatively, it computes power given numbers of clusters,
cluster sizes, and survival parameters, or it computes the hazard ratio given
numbers of clusters, cluster sizes, power, and, in the presence of censoring,
the control-group survival probability. See
{manhelp power_logrank PSS-2:power logrank} for a general discussion of power
and sample-size analysis for the log-rank test. Also see
{manhelp power PSS-2} for a general introduction to the {cmd:power} command
using hypothesis tests.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-2 powerlogrank,clusterQuickstart:Quick start}

        {mansection PSS-2 powerlogrank,clusterRemarksandexamples:Remarks and examples}

        {mansection PSS-2 powerlogrank,clusterMethodsandformulas:Methods and formulas}

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
{cmd:nfractional}; see {manhelp power##mainopts PSS-2: power}.
The {cmd:nfractional} option displays fractional (without rounding)
values of the numbers of clusters, cluster sizes, and sample sizes.

{phang}
{opt hratio()}, {opt lnhratio()}; see
{manhelp power_logrank PSS-2:power logrank}.

{phang}
{opth rho(numlist)} specifies the intraclass correlation. The default is
{cmd:rho(0.5)}.

{phang}
{opth cvcluster(numlist)} specifies the coefficient of variation for cluster
sizes.  This option is used with varying cluster sizes.

{phang}
{cmd:direction()}, {cmd:onesided}, {cmd:parallel}; see 
{manhelp power##mainopts PSS-2: power}.
{cmd:direction(lower)} is the default.

INCLUDE help pss_taboptsdes.ihlp

INCLUDE help pss_graphoptsdes.ihlp
Also see the {mansection PSS-2 powerlogrank,clusterSyntaxcolumn:column} table in
{bf:[PSS-2] power logrank, cluster} for a list of symbols used by the graphs.

{dlgtab:Iteration}

{phang}
{opt init(#)} specifies the initial value for the hazard ratio.

INCLUDE help pss_iteroptsdes.ihlp

{pstd}
The following option is available with {cmd:power logrank, cluster} but is not
shown in the dialog box:

INCLUDE help pss_reportoptsdes.ihlp


{marker remarks}{...}
{title:Remarks: Using power logrank, cluster}

{pstd}
{cmd:power} {cmd:logrank,} {cmd:cluster} requests that computations for the
{cmd:power} {cmd:logrank} command be done for a CRD.  In a CRD, groups of
subjects or clusters are randomized instead of individual subjects, so the
sample size is determined by the numbers of clusters and the cluster sizes.
The sample-size determination thus consists of the determination of the
numbers of clusters given cluster sizes or the determination of cluster sizes
given the numbers of clusters.  For a general discussion of using {cmd:power}
{cmd:logrank}, see {manhelp power_logrank PSS-2:power logrank}.  The discussion
below is specific to the CRD.

{pstd}
If you specify the {cmd:cluster} option, include {cmd:k1()} or {cmd:k2()} to
specify the number of clusters or include {cmd:m1()} or {cmd:m2()} to specify
the cluster size, the {helpb power logrank} command will perform
computations for the log-rank test in a CRD.  The computations for a CRD are
based on the Freedman method; see
{mansection PSS-2 powerlogrankRemarksandexamplesIntroduction:{it:Introduction}}
in {bf:[PSS-2] power logrank} for details.

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
{cmd:m2()} option.  See {help power_logrank_cluster##mspec:{it:mspec}} and
{help power_logrank_cluster##nspec:{it:nspec}} under
{help power_logrank_cluster##syntax:{it:Syntax}} for other specifications.
When {it:nspec} is specified, the {cmd:cluster} option is also required to
request that {cmd:power} {cmd:logrank} perform computations for a CRD.  The 
number of clusters is assumed to be equal in the two groups, but you can
change this by specifying the ratio of the numbers of clusters in the
experimental to the control group in the {cmd:kratio()} option.  Other
parameters are specified as described in
{mansection PSS-2 powerlogrankRemarksandexamplesUsingpowerlogrank:{it:Using power logrank}}
in {bf:[PSS-2] power logrank}.

{pstd}
To compute the cluster sizes in both groups, you must provide the numbers of
clusters in both groups.  There are several ways to supply
the numbers of clusters; see {help power_logrank_cluster##kspec:{it:kspec}}
under {help power_logrank_cluster##syntax:{it:Syntax}}.  The most common
is to specify the numbers of clusters in the control group and the
experimental group in the {cmd:k1()} and {cmd:k2()} options, respectively.
Equal cluster sizes are assumed in the two groups, but you can change this by
specifying the ratio of the cluster sizes in the experimental to that of the
control group in the {cmd:mratio()} option.  Other parameters are specified as
described in
{mansection PSS-2 powerlogrankRemarksandexamplesUsingpowerlogrank:{it:Using power logrank}}
in {bf:[PSS-2] power logrank}.

{pstd}
The power and effect-size determination is the same as described in
{mansection PSS-2 powerlogrankRemarksandexamplesUsingpowerlogrank:{it:Using power logrank}}
in {bf:[PSS-2] power logrank}, but the sample-size information is supplied as
the numbers of clusters {help power_logrank_cluster##kspec:{it:kspec}} and
either cluster sizes using {help power_logrank_cluster##mspec:{it:mspec}} or,
less commonly, sample sizes using
{help power_logrank_cluster##nspec:{it:nspec}}.

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
specified using {help power_logrank_cluster##nspec:{it:nspec}}, fractional
cluster sizes may be reported to accommodate the specified numbers of clusters
and sample sizes.

{pstd}
Some of {cmd:power} {cmd:logrank,} {cmd:cluster}'s computations require
iteration; see
{mansection PSS-2 powerlogrank,clusterMethodsandformulas:{it:Methods and formulas}}
for details and {manhelp power PSS-2} for the descriptions of options that
control the iteration.


{marker examples}{...}
{title:Examples}

    {title:Examples: Computing numbers of clusters}

{pstd}
Compute numbers of clusters required to detect a hazard ratio of 0.7 for
uncensored design, given that the cluster sizes of the two groups are both 5;
assume a two-sided test with a 5% significance level, a power of 80%, and an
intraclass correlation of 0.5, and assume that both groups will have the same
number of clusters (the defaults){p_end}

{phang2}{cmd:. power logrank, m1(5) m2(5) hratio(0.7)}

{pstd}
Same as above, except using an intraclass correlation of 0.2{p_end}

{phang2}{cmd:. power logrank, m1(5) m2(5) hratio(0.7) rho(0.2)}

{pstd}
Same as above, except that the cluster size varies with a coefficient of
variation of 0.6{p_end}

{phang2}{cmd:. power logrank, m1(5) m2(5) hratio(0.7) rho(0.2) cvcluster(0.6)}

{pstd}
Same as first example, except that the ratio of numbers of clusters is 2 
{p_end}

{phang2}{cmd:. power logrank, m1(5) m2(5) hratio(0.7) kratio(2)}

{pstd}
Specify a list of intraclass correlations, graphing the results{p_end}

{phang2}{cmd:. power logrank, m1(5) m2(5) hratio(0.7) rho(0.1(0.1)0.5) graph}


    {title:Examples: Computing cluster sizes}

{pstd}
Compute cluster sizes required to test whether the hazard ratio equals 1 with
control- and experimental-group survival probabilities of 0.3 and 0.5 for
censored design, given that both groups have 60 clusters; assume a two-sided
test with a 5% significance level, a power of 80%, and an intraclass
correlation of 0.5, and assume that both groups will have the same cluster
size (the defaults){p_end}

{phang2}{cmd:. power logrank 0.3 0.5, k1(60) k2(60)}

{pstd}
Same as first example, using a one-sided test with a 1% significance level
{p_end}

{phang2}{cmd:. power logrank 0.3 0.5, k1(60) k2(60) alpha(0.01) onesided}


    {title:Examples: Computing power}
    
{pstd}
Compute the power of a two-sided test for 30 clusters with cluster sizes of 5
in the two groups and the default 5% significance level, where the
experimental-group survival probability is 0.5 and the control-group survival
probability is 0.3; use the default value of 0.5 as the intraclass
correlation{p_end}

{phang2}{cmd:. power logrank 0.3 0.5, k1(30) k2(30) m1(5) m2(5)}

{pstd}
Compute powers for a list of numbers of clusters in the experimental group,
graphing the results{p_end}

{phang2}{cmd:. power logrank 0.3 0.5, k1(30) k2(10(10)60) m1(5) m2(5) graph}


    {title:Examples: Computing minimum detectable hazard ratio}

{pstd}
Compute the maximum value of the hazard ratio less than 1 that can be detected
using a two-sided test in which both groups have 60 clusters of size 5; assume
a power of 80%, a 5% significance level, and an intraclass correlation of 0.5
(the defaults)

{phang2}{cmd:. power logrank, k1(60) k2(60) m1(5) m2(5) power(0.8)}

{pstd}
Compute the minimum value of the hazard ratio greater than 1 that can be
detected{p_end}

{phang2}{cmd:. power logrank, k1(60) k2(60) m1(5) m2(5) power(0.8) direction(upper)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:power} {cmd:logrank,} {cmd:cluster} stores the following in {cmd:r()}:

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
{synopt:{cmd:r(onesided)}}{cmd:1} for a one-sided test, {cmd:0} otherwise{p_end}
{synopt:{cmd:r(E)}}total number of events (failure){p_end}
{synopt:{cmd:r(hratio)}}hazard ratio{p_end}
{synopt:{cmd:r(lnhratio)}}log hazard-ratio{p_end}
{synopt:{cmd:r(s1)}}survival probability in the control group (if
specified){p_end}
{synopt:{cmd:r(s2)}}survival probability in the experimental group (if
specified){p_end}
{synopt:{cmd:r(Pr_E)}}probability of an event (failure){p_end}
{synopt:{cmd:r(rho)}}intraclass correlation{p_end}
{synopt:{cmd:r(CV_cluster)}}coefficient of variation for cluster sizes{p_end}
INCLUDE help pss_rrestab_sc.ihlp
{synopt:{cmd:r(init)}}initial value for estimated parameter{p_end}
INCLUDE help pss_rresiter_sc.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(type)}}{cmd:test}{p_end}
{synopt:{cmd:r(method)}}{cmd:logrank}{p_end}
{synopt:{cmd:r(design)}}{cmd:CRD}{p_end}
{synopt:{cmd:r(test)}}{cmd:Freedman}{p_end}
{synopt:{cmd:r(direction)}}{cmd:lower} or {cmd:upper}{p_end}
INCLUDE help pss_rrestab_mac.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(pss_table)}}table of results{p_end}
{p2colreset}{...}
