{smcl}
{* *! version 1.2.3  20aug2018}{...}
{viewerdialog "ztest" "dialog ztest"}{...}
{viewerdialog "ztesti" "dialog ztesti"}{...}
{vieweralsosee "[R] ztest" "mansection R ztest"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ci" "help ci"}{...}
{vieweralsosee "[R] esize" "help esize"}{...}
{vieweralsosee "[MV] hotelling" "help hotelling"}{...}
{vieweralsosee "[R] mean" "help mean"}{...}
{vieweralsosee "[R] oneway" "help oneway"}{...}
{vieweralsosee "[PSS-2] power onemean" "help power onemean"}{...}
{vieweralsosee "[PSS-2] power onemean, cluster" "help power onemean cluster"}{...}
{vieweralsosee "[PSS-2] power pairedmeans" "help power pairedmeans"}{...}
{vieweralsosee "[PSS-2] power twomeans" "help power twomeans"}{...}
{vieweralsosee "[PSS-2] power twomeans, cluster" "help power twomeans cluster"}{...}
{vieweralsosee "[R] ttest" "help ttest"}{...}
{viewerjumpto "Syntax" "ztest##syntax"}{...}
{viewerjumpto "Menu" "ztest##menu"}{...}
{viewerjumpto "Description" "ztest##description"}{...}
{viewerjumpto "Links to PDF documentation" "ztest##linkspdf"}{...}
{viewerjumpto "Options" "ztest##options"}{...}
{viewerjumpto "Examples" "ztest##examples"}{...}
{viewerjumpto "Stored results" "ztest##results"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[R] ztest} {hline 2}}z tests (mean-comparison tests, known variance){p_end}
{p2col:}({mansection R ztest:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
One-sample z test

{p 8 14 2}
{cmd:ztest}
{varname}
{cmd:==}
{it:#}
{ifin}
[{cmd:,} {it:{help ztest##onesampleopts:onesampleopts}}]


{pstd}
Two-sample z test using groups

{p 8 14 2}
{cmd:ztest}
{varname}
{ifin}
{cmd:,}
{opth by:(varlist:groupvar)}
[{it:{help ztest##twosamplegropts:twosamplegropts}}]


{pstd}
Two-sample z test using variables

{p 8 14 2}
{cmd:ztest}
{varname:1}
{cmd:==}
{varname:2}
{ifin}{cmd:,}
{opt unp:aired}
[{it:{help ztest##twosamplevaropts:twosamplevaropts}}]


{pstd}
Paired z test

{p 8 14 2}
{cmd:ztest}
{varname:1}
{cmd:==}
{varname:2}
{ifin}
{cmd:,} 
{opt sddiff(#)}
[{opt l:evel(#)}]

{p 8 14 2}
{cmd:ztest}
{varname:1}
{cmd:==}
{varname:2}
{ifin}
{cmd:,} 
{opt corr(#)}
[{it:{help ztest##pairedopts:pairedopts}}]


{pstd}
Immediate form of one-sample z test

{p 8 14 2}
{cmd:ztesti}
{it:#obs}
{it:#mean}
{it:#sd}
{it:#val}
[{cmd:,}
{opt l:evel(#)}]


{pstd}
Immediate form of two-sample unpaired z test

{p 8 14 2}
{cmd:ztesti}
{it:#obs1}
{it:#mean1}
{it:#sd1}
{it:#obs2}
{it:#mean2}
{it:#sd2}
[{cmd:,} 
{opt l:evel(#)}]


{synoptset 20 tabbed}{...}
{marker onesampleopts}{...}
{synopthdr:onesampleopts}
{synoptline}
{syntab:Main}
{synopt:{opt sd(#)}}one-population standard deviation; default is
	{cmd:sd(1)}{p_end}
{synopt:{opt l:evel(#)}}confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opth cluster(varname)}}variable defining the clusters{p_end}
{synopt :{opt rho(#)}}intraclass correlation{p_end}
{synoptline}

{marker twosamplegropts}{...}
{synopthdr:twosamplegropts}
{synoptline}
{syntab:Main}
{p2coldent:* {opth by:(varlist:groupvar)}}variable defining the groups{p_end}
{synopt:{opt unp:aired}}unpaired test; implied when {cmd:by()} is
	specified{p_end}
{synopt:{opt sd(#)}}two-population common standard deviation;
	default is {cmd:sd(1)}{p_end}
{synopt:{opt sd1(#)}}standard deviation of the first population; requires
	{cmd:sd2()} and may not be combined with {cmd:sd()}{p_end}
{synopt:{opt sd2(#)}}standard deviation of the second population; requires
	{cmd:sd1()} and may not be combined with {cmd:sd()} {p_end}
{synopt:{opt l:evel(#)}}confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opth cluster(varname)}}variable defining the clusters{p_end}
{synopt :{opt rho(#)}}common intraclass correlation{p_end}
{synopt :{opt rho1(#)}}intraclass correlation for group 1{p_end}
{synopt :{opt rho2(#)}}intraclass correlation for group 2{p_end}
{synoptline}
{p 4 6 2}* {opt by(groupvar)} is required.{p_end}

{marker twosamplevaropts}{...}
{synopthdr:twosamplevaropts}
{synoptline}
{syntab:Main}
{p2coldent:* {opt unp:aired}}unpaired test{p_end}
{synopt:{opt sd(#)}}two-population common standard deviation;
	default is {cmd:sd(1)}{p_end}
{synopt:{opt sd1(#)}}standard deviation of the first population; requires
	{cmd:sd2()} and may not be combined with {cmd:sd()}{p_end}
{synopt:{opt sd2(#)}}standard deviation of the second population; requires
	{cmd:sd1()} and may not be combined with {cmd:sd()} {p_end}
{synopt:{opt l:evel(#)}}confidence level; default is {cmd:level(95)}{p_end}
{synoptline}
{p 4 6 2}* {opt unpaired} is required.{p_end}

{marker pairedopts}{...}
{synopthdr:pairedopts}
{synoptline}
{syntab:Main}
{p2coldent:* {opt corr(#)}}correlation between paired observations{p_end}
{synopt:{opt sd(#)}}two-population common standard deviation;
	default is {cmd:sd(1)}; may not be combined with {cmd:sd1()},
	{cmd:sd2()}, or {cmd:sddiff()}{p_end}
{synopt:{opt sd1(#)}}standard deviation of the first population; requires
	{cmd:corr()} and {cmd:sd2()} and may not be combined with {cmd:sd()} or
	{cmd:sddiff()}{p_end}
{synopt:{opt sd2(#)}}standard deviation of the second population; requires
	{cmd:corr()} and {cmd:sd1()} and may not be combined with {cmd:sd()} or
	{cmd:sddiff()}{p_end}
{synopt:{opt l:evel(#)}}confidence level; default is {cmd:level(95)}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}* {opt corr(#)} is required.{p_end}

{phang}
{opt by} is allowed with {cmd:ztest}; see {manhelp by D}.


{marker menu}{...}
{title:Menu}

    {title:ztest}

{phang2}
{bf:Statistics > Summaries, tables, and tests > Classical tests of hypotheses}
       {bf:> z test (mean-comparison test, known variance)}

    {title:ztesti}

{phang2}
{bf:Statistics > Summaries, tables, and tests > Classical tests of hypotheses}
       {bf:> z test calculator}


{marker description}{...}
{title:Description}

{pstd}
{opt ztest} performs z tests on the equality of means, assuming known
variances.  The test can be performed for one sample against a hypothesized
population value or for no difference in population means estimated from two
samples.  Two-sample tests can be conducted for paired and unpaired data.
Clustered data are also supported.

{pstd}
{opt ztesti} is the immediate form of {opt ztest}; see {help immed}.

{pstd}
For the comparison of means when variances are unknown, use {opt ttest}; 
see {manhelp ttest R}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R ztestQuickstart:Quick start}

        {mansection R ztestRemarksandexamples:Remarks and examples}

        {mansection R ztestMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth by:(varlist:groupvar)} specifies the {it:groupvar} that defines the two
groups that {opt ztest} will use to test the hypothesis that their means are
equal.  Specifying {opt by(groupvar)} implies an unpaired (two-sample) z test.
Do not confuse the {opt by()} option with the {cmd:by} prefix; you can specify
both.

{phang}
{opt unpaired} specifies that the data be treated as unpaired.  The
{opt unpaired} option is used when the two sets of values to be compared are
in different variables.

{phang}
{opt sddiff(#)} specifies the population standard deviation of the differences 
between paired observations for a paired z test.
For this kind of test, either {cmd:sddiff()} or {cmd:corr()} must be specified.

{phang}
{opt corr(#)} specifies the correlation between paired observations for a
paired z test.  This option along with {cmd:sd1()} and {cmd:sd2()} or with
{cmd:sd()} is used to compute the standard deviation of the differences
between paired observations unless that standard deviation is supplied
directly in the {cmd:sddiff()} option.  For a paired z test, either
{cmd:sddiff()} or {cmd:corr()} must be specified.

{phang}
{opt sd(#)} specifies the population standard deviation for a one-sample z
test or the common population standard deviation for a two-sample z test.  The
default is {cmd:sd(1)}.  {cmd:sd()} may not be combined with {cmd:sd1()},
{cmd:sd2()}, or {cmd:sddiff()}.

{phang}
{opt sd1(#)} specifies the standard deviation of the first population or
group.  When {cmd:sd1()} is specified with {opt by(groupvar)}, the first group
is defined by the first category of the sorted {it:groupvar}.  {cmd:sd1()}
requires {cmd:sd2()} and may not be combined with {cmd:sd()} or
{cmd:sddiff()}.

{phang}
{opt sd2(#)} specifies the standard deviation of the second population or
group.  When {cmd:sd2()} is specified with {opt by(groupvar)}, the second group
is defined by the second category of the sorted {it:groupvar}.  {cmd:sd2()}
requires {cmd:sd1()} and may not be combined with {cmd:sd()} or
{cmd:sddiff()}.

{phang} {opt level(#)} specifies the confidence level, as a percentage, for
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

 
{pstd}
When {cmd:by()} is used, {cmd:sd1()} and {cmd:sd2()} or {cmd:sd()} is used to
specify the population standard deviations of the two groups defined by
{it:groupvar} for an unpaired two-sample z test (using groups).  By default, a
common standard deviation of one, {cmd:sd(1)}, is assumed.

{pstd}
When {cmd:unpaired} is used, {cmd:sd1()} and {cmd:sd2()} or {cmd:sd()} is used
to specify the population standard deviations of {it:varname1} and
{it:varname2} for an unpaired two-sample z test (using variables).  By
default, a common standard deviation of one, {cmd:sd(1)}, is assumed.

{pstd}
Options {cmd:corr()}, {cmd:sd1()}, and {cmd:sd2()} or {cmd:corr()} and
{cmd:sd()} are used for a paired z test to compute the standard deviation of
the differences between paired observations.  By default, a common standard
deviation of one, {cmd:sd(1)}, is assumed for both populations.  Alternatively,
the standard deviation of the differences between paired observations may be
supplied directly with the {cmd:sddiff()} option.


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. sysuse auto}

{pstd}
One-sample z test; test mean of {cmd:mpg} against 20{p_end}
{phang2}{cmd:. ztest mpg==20, sd(6)}

{pstd}
One-sample z test adjusted for clustering with clusters defined by 
{cmd:rep78} and with an intraclass correlation of 0.2{p_end}
{phang2}{cmd:. ztest mpg==20, sd(6) cluster(rep78) rho(0.2)}

    {hline}
    Setup
{phang2}{cmd:. webuse fuel3}

{pstd}Two-sample z test using groups{p_end}
{phang2}{cmd:. ztest mpg, by(treated) sd1(2.7) sd2(3.2)}

    {hline}
    Setup
{phang2}{cmd:. webuse dcfd_trial}

{pstd}Two-sample z test using groups, adjusted for clustering with clusters 
defined by {cmd:practice}, a common standard deviation of 0.35, and a common
intraclass correlation of 0.028{p_end}
{phang2}{cmd:. ztest lbmi, by(group) sd(0.35) cluster(practice) rho(0.028)}

    {hline}
    Setup
{phang2}{cmd:. webuse fuel}

{pstd}Two-sample unpaired z test using variables{p_end}
{phang2}{cmd:. ztest mpg1==mpg2, unpaired sd(3)}

   {hline}
    Setup
{phang2}{cmd:. webuse fuel}

{pstd}Paired z test{p_end}
{phang2}{cmd:. ztest mpg1==mpg2, corr(.6) sd1(2.7) sd2(3.2)}

    {hline}
{pstd}
Immediate form; n=24, m=62.6, sd=15.8; test m=75{p_end}
{phang2}{cmd:. ztesti 24 62.6 15.8 75, level(90)}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
One-sample {cmd:ztest} and {cmd:ztesti} store the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}sample size{p_end}
{synopt:{cmd:r(mu)}}sample mean{p_end}
{synopt:{cmd:r(sd)}}standard deviation{p_end}
{synopt:{cmd:r(se)}}standard error{p_end}
{synopt:{cmd:r(lb)}}lower confidence bound of one-sample mean{p_end}
{synopt:{cmd:r(ub)}}upper confidence bound of one-sample mean{p_end}
{synopt:{cmd:r(z)}}z statistic{p_end}
{synopt:{cmd:r(p_l)}}lower one-sided p-value{p_end}
{synopt:{cmd:r(p)}}two-sided p-value{p_end}
{synopt:{cmd:r(p_u)}}upper one-sided p-value{p_end}
{synopt:{cmd:r(level)}}confidence level{p_end}

{pstd}
Cluster-adjusted one-sample {cmd:ztest} also stores the following in {cmd:r()}:

{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(K)}}number of clusters K{p_end}
{synopt:{cmd:r(M)}}cluster size M{p_end}
{synopt:{cmd:r(rho)}}intraclass correlation{p_end}
{synopt:{cmd:r(CV_cluster)}}coefficient of variation for cluster sizes{p_end}

{pstd}
Two-sample {cmd:ztest} and {cmd:ztesti} store the following in {cmd:r()}:

{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N1)}}sample size of population one{p_end}
{synopt:{cmd:r(N2)}}sample size of population two{p_end}
{synopt:{cmd:r(mu1)}}sample mean for population one{p_end}
{synopt:{cmd:r(mu2)}}sample mean for population two{p_end}
{synopt:{cmd:r(mu_diff)}}difference of means{p_end}
{synopt:{cmd:r(corr)}}correlation between paired observations; if the
{cmd:corr()} option is specified{p_end}
{synopt:{cmd:r(sd)}}common standard deviation{p_end}
{synopt:{cmd:r(sd1)}}standard deviation for population one{p_end}
{synopt:{cmd:r(sd2)}}standard deviation for population two{p_end}
{synopt:{cmd:r(sd_diff)}}standard deviation of the differences between paired
observations{p_end}
{synopt:{cmd:r(se1)}}standard error of population-one sample mean{p_end}
{synopt:{cmd:r(se2)}}standard error of population-two sample mean{p_end}
{synopt:{cmd:r(se_diff)}}standard error of the difference of means{p_end}
{synopt:{cmd:r(lb1)}}lower confidence bound of population-one sample
mean{p_end}
{synopt:{cmd:r(ub1)}}upper confidence bound of population-one sample
mean{p_end}
{synopt:{cmd:r(lb2)}}lower confidence bound of population-two sample
mean{p_end}
{synopt:{cmd:r(ub2)}}upper confidence bound of population-two sample
mean{p_end}
{synopt:{cmd:r(lb_diff)}}lower confidence bound of the difference of
means{p_end}
{synopt:{cmd:r(ub_diff)}}upper confidence bound of the difference of
means{p_end}
{synopt:{cmd:r(z)}}z statistic{p_end}
{synopt:{cmd:r(p_l)}}lower one-sided p-value{p_end}
{synopt:{cmd:r(p)}}two-sided p-value{p_end}
{synopt:{cmd:r(p_u)}}upper one-sided p-value{p_end}
{synopt:{cmd:r(level)}}confidence level{p_end}

{pstd}
Cluster-adjusted two-sample {cmd:ztest} using the {cmd:by()} option
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
