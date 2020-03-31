{smcl}
{* *! version 1.2.3  20aug2018}{...}
{viewerdialog "prtest" "dialog prtest"}{...}
{viewerdialog "prtesti" "dialog prtesti"}{...}
{vieweralsosee "[R] prtest" "mansection R prtest"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] bitest" "help bitest"}{...}
{vieweralsosee "[MV] hotelling" "help hotelling"}{...}
{vieweralsosee "[PSS-2] power oneproportion" "help power_oneproportion"}{...}
{vieweralsosee "[PSS-2] power oneproportion, cluster" "help power_oneproportion_cluster"}{...}
{vieweralsosee "[PSS-2] power twoproportions" "help power_twoproportions"}{...}
{vieweralsosee "[PSS-2] power twoproportions, cluster" "help power_twoproportions_cluster"}{...}
{vieweralsosee "[R] proportion" "help proportion"}{...}
{vieweralsosee "[R] ttest" "help ttest"}{...}
{viewerjumpto "Syntax" "prtest##syntax"}{...}
{viewerjumpto "Menu" "prtest##menu"}{...}
{viewerjumpto "Description" "prtest##description"}{...}
{viewerjumpto "Links to PDF documentation" "prtest##linkspdf"}{...}
{viewerjumpto "Options for prtest" "prtest##prtest_options"}{...}
{viewerjumpto "Options for prtesti" "prtest##prtesti_options"}{...}
{viewerjumpto "Remarks" "prtest##remarks"}{...}
{viewerjumpto "Examples" "prtest##examples"}{...}
{viewerjumpto "Stored results" "prtest##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[R] prtest} {hline 2}}Tests of proportions{p_end}
{p2col:}({mansection R prtest:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
One-sample test of proportion

{p 8 15 2}
{cmd:prtest} {varname} {cmd:==} {it:#p} {ifin} [{cmd:,} {it:onesampleopts}]


{phang}
Two-sample test of proportions using groups

{p 8 15 2}
{cmd:prtest} {varname} {ifin} {cmd:,} {opth "by(varlist:groupvar)"}
    [{it:twosamplegropts}]


{phang}
Two-sample test of proportions using variables

{p 8 15 2}
{cmd:prtest} {it:{help varname:varname1}} {cmd:==} {it:{help varname:varname2}}
    {ifin} [{cmd:,} {opt l:evel(#)}]


{phang}
Immediate form of one-sample test of proportion

{p 8 16 2}
{cmd:prtesti} {it:#obs1} {it:#p1} {it:#p2} 
[{cmd:,} {opt l:evel(#)} {opt c:ount}]


{phang}
Immediate form of two-sample test of proportions

{p 8 16 2}{cmd:prtesti} {it:#obs1} {it:#p1} {it:#obs2} {it:#p2} 
[{cmd:,} {opt l:evel(#)} {opt c:ount}]


{marker onesampopts}{...}
{synoptset 20 tabbed}{...}
{synopthdr:onesampleopts}
{synoptline}
{syntab:Main}
{synopt :{opt l:evel(#)}}confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opth cluster(varname)}}variable defining the clusters{p_end}
{synopt :{opt rho(#)}}intraclass correlation{p_end}
{synoptline}

{marker groupopts}{...}
{synopthdr:twosamplegropts}
{synoptline}
{syntab:Main}
{p2coldent :* {opth by(groupvar)}}variable defining the groups{p_end}
{synopt :{opt l:evel(#)}}confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opth cluster(varname)}}variable defining the clusters{p_end}
{synopt :{opt rho(#)}}common intraclass correlation{p_end}
{synopt :{opt rho1(#)}}intraclass correlation for group 1{p_end}
{synopt :{opt rho2(#)}}intraclass correlation for group 2{p_end}
{synoptline}
{p 4 6 2}* {opt by(groupvar)} is required.{p_end}

{phang}
{cmd:by} is allowed with {cmd:prtest}; see {manhelp by D}.


{marker menu}{...}
{title:Menu}

    {title:prtest}

{phang2}
{bf:Statistics > Summaries, tables, and tests >}
    {bf:Classical tests of hypotheses > Proportion test}

    {title:prtesti}

{phang2}
{bf:Statistics > Summaries, tables, and tests >}
     {bf:Classical tests of hypotheses > Proportion test calculator}


{marker description}{...}
{title:Description}

{pstd}
{cmd:prtest} performs tests on the equality of proportions using
large-sample statistics.  The test can be performed for one sample against a
hypothesized population value or for no difference in population proportions
estimated from two samples.  Clustered data are supported.

{pstd}
{cmd:prtesti} is the immediate form of {cmd:prtest}; see {help immed}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R prtestQuickstart:Quick start}

        {mansection R prtestRemarksandexamples:Remarks and examples}

        {mansection R prtestMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker prtest_options}{...}
{title:Options for prtest}

{dlgtab:Main}

{phang}
{opth "by(varlist:groupvar)"} specifies a numeric variable that contains the
group information for a given observation.  This variable must have only two
values.  Do not confuse the {opt by()} option with the {cmd:by} prefix; both
may be specified.

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for
confidence intervals.  The default is {cmd:level(95)} or as set by 
{helpb set level}.

{phang}
{opth cluster(varname)} specifies the variable that identifies clusters.  The
{opt cluster()} option is required to adjust the computation for clustering.

{phang}
{opt rho(#)} specifies the intraclass correlation for a one-sample test or the
common intraclass correlation for a two-sample test.  The {opt rho()} option
is required to adjust the computation for clustering for a one-sample test.

{phang}
{opt rho1(#)} specifies the intraclass correlation of the first group for a
two-sample test using groups.  The {opt rho()} option or both {cmd:rho1()} and
{cmd:rho2()} options are required to adjust the computation for clustering.

{phang}
{opt rho2(#)} specifies the intraclass correlation of the second group for a
two-sample test using groups.  The {opt rho()} option or both {cmd:rho1()} and
{cmd:rho2()} options are required to adjust the computation for clustering.


{marker prtesti_options}{...}
{title:Options for prtesti}

{dlgtab:Main}

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for
confidence intervals.  The default is {cmd:level(95)} or as set by 
{helpb set level}.

{phang}
{opt count} specifies that integer counts instead of proportions be used in
the immediate forms of {cmd:prtest}.  In the first syntax, {cmd:prtesti}
expects that {it:#obs1} and {it:#p1} are counts -- {it:#p1} {ul:<}
{it:#obs1} -- and {it:#p2} is a proportion.  In the second syntax,
{cmd:prtesti} expects that all four numbers are integer counts, that
{it:#obs1} {ul:>} {it:#p1}, and that {it:#obs2} {ul:>} {it:#p2}.


{marker remarks}{...}
{title:Remarks}

{pstd}
For one-sample tests of proportions with small sample sizes and to obtain
exact p-values, researchers should use {helpb bitest}.


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. sysuse auto}{p_end}

{phang}One-sample test of proportion{p_end}
{phang2}{cmd:. prtest foreign==.4}

{phang}One-sample test of proportion adjusted for clustering with clusters 
defined by {cmd:rep78} and with an intraclass correlation of 0.4{p_end}
{phang2}{cmd:. prtest foreign==.4, cluster(rep78) rho(0.4)}{p_end}

    {hline}
    Setup
{phang2}{cmd:. webuse cure}{p_end}

{phang}Two-sample test of proportions using variables{p_end}
{phang2}{cmd:. prtest cure1==cure2}

    {hline}
    Setup
{phang2}{cmd:. webuse cure2}{p_end}

{phang}Two-sample test that {cmd:cure} has same proportion for males and females{p_end}
{phang2}{cmd:. prtest cure, by(sex)}

   {hline}
    Setup
{phang2}{cmd:. webuse pneumoniacrt}{p_end}

{phang}Two-sample test that {cmd:pneumonia} has same proportion for two vaccine groups, 
adjusted for clustering with clusters defined by {cmd:cluster} and with a 
common intraclass correlation of 0.02{p_end}
{phang2}{cmd:. prtest pneumonia, by(vaccine) cluster(cluster) rho(0.02)}

    {hline}
{phang}Immediate form of one-sample test of proportion{p_end}
{phang2}{cmd:. prtesti 50 .52 .70}{p_end}

{phang}First two numbers are counts{p_end}
{phang2}{cmd:. prtesti 30 4  .7, count}{p_end}

{phang}Immediate form of two-sample test of proportions{p_end}
{phang2}{cmd:. prtesti 30 .4  45 .67}{p_end}

{phang}All numbers are counts{p_end}
{phang2}{cmd:. prtesti 30 4  45 17, count}{p_end}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
One-sample {opt prtest} and {opt prtesti} store the following in {opt r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}sample size{p_end}
{synopt:{cmd:r(P)}}sample proportion{p_end}
{synopt:{cmd:r(se)}}standard error of sample proportion{p_end}
{synopt:{cmd:r(lb)}}lower confidence bound of sample proportion{p_end}
{synopt:{cmd:r(ub)}}upper confidence bound of sample proportion{p_end}
{synopt:{cmd:r(z)}}z statistic{p_end}
{synopt:{cmd:r(p_l)}}lower one-sided p-value{p_end}
{synopt:{cmd:r(p)}}two-sided p-value{p_end}
{synopt:{cmd:r(p_u)}}upper one-sided p-value{p_end}
{synopt:{cmd:r(level)}}confidence level{p_end}

{pstd}
Cluster-adjusted one-sample {cmd:prtest} also stores the following in {cmd:r()}:

{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(K)}}number of clusters K{p_end}
{synopt:{cmd:r(M)}}cluster size M{p_end}
{synopt:{cmd:r(rho)}}intraclass correlation{p_end}
{synopt:{cmd:r(CV_cluster)}}coefficient of variation for cluster sizes{p_end}

{pstd}
Two-sample {cmd:prtest} and two-sample {cmd:prtesti} store the following
in {cmd:r()}:

{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N1)}}sample size of population one{p_end}
{synopt:{cmd:r(N2)}}sample size of population two{p_end}
{synopt:{cmd:r(P1)}}sample proportion for population one{p_end}
{synopt:{cmd:r(P2)}}sample proportion for population two{p_end}
{synopt:{cmd:r(P_diff)}}difference of proportions{p_end}
{synopt:{cmd:r(se1)}}standard error of population-one sample proportion{p_end}
{synopt:{cmd:r(se2)}}standard error of population-two sample
proportion{p_end}
{synopt:{cmd:r(se_diff)}}standard error of the difference of
proportions{p_end}
{synopt:{cmd:r(se_diff0)}}standard error of the difference of proportions
under H_0{p_end}
{synopt:{cmd:r(lb1)}}lower confidence bound of population-one sample
proportion{p_end}
{synopt:{cmd:r(ub1)}}upper confidence bound of population-one sample
proportion{p_end}
{synopt:{cmd:r(lb2)}}lower confidence bound of population-two sample
proportion{p_end}
{synopt:{cmd:r(ub2)}}upper confidence bound of population-two sample
proportion{p_end}
{synopt:{cmd:r(lb_diff)}}lower confidence bound of the difference of
proportions{p_end}
{synopt:{cmd:r(ub_diff)}}upper confidence bound of the difference of
proportions{p_end}
{synopt:{cmd:r(z)}}z statistic{p_end}
{synopt:{cmd:r(p_l)}}lower one-sided p-value{p_end}
{synopt:{cmd:r(p)}}two-sided p-value{p_end}
{synopt:{cmd:r(p_u)}}upper one-sided p-value{p_end}
{synopt:{cmd:r(level)}}confidence level{p_end}

{pstd}
Cluster-adjusted two-sample {cmd:prtest} using the {cmd:by()} option
also stores the following in {cmd:r()}:

{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(K1)}}population-one number of clusters K_1{p_end}
{synopt:{cmd:r(K2)}}population-two number of clusters K_2{p_end}
{synopt:{cmd:r(M1)}}population-one cluster size M_1{p_end}
{synopt:{cmd:r(M2)}}population-two cluster size M_2{p_end}
{synopt:{cmd:r(rho)}}common intraclass correlation{p_end}
{synopt:{cmd:r(rho1)}}population-one intraclass correlation{p_end}
{synopt:{cmd:r(rho2)}}population-two intraclass correlation{p_end}
{synopt:{cmd:r(CV_cluster1)}}population-one coefficient of variation for
cluster sizes{p_end}
{synopt:{cmd:r(CV_cluster2)}}population-two coefficient of variation for
cluster sizes{p_end}
{p2colreset}{...}
