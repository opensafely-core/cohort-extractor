{smcl}
{* *! version 1.1.17  19oct2017}{...}
{viewerdialog mvtest "dialog mvtest"}{...}
{vieweralsosee "[MV] mvtest normality" "mansection MV mvtestnormality"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] sktest" "help sktest"}{...}
{vieweralsosee "[R] swilk" "help swilk"}{...}
{viewerjumpto "Syntax" "mvtest_normality##syntax"}{...}
{viewerjumpto "Menu" "mvtest_normality##menu"}{...}
{viewerjumpto "Description" "mvtest_normality##description"}{...}
{viewerjumpto "Links to PDF documentation" "mvtest_normality##linkspdf"}{...}
{viewerjumpto "Options" "mvtest_normality##options"}{...}
{viewerjumpto "Notes" "mvtest_normality##notes"}{...}
{viewerjumpto "Examples" "mvtest_normality##examples"}{...}
{viewerjumpto "Stored results" "mvtest_normality##results"}{...}
{viewerjumpto "References" "mvtest_normality##references"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[MV] mvtest normality} {hline 2}}Multivariate
normality tests{p_end}
{p2col:}({mansection MV mvtestnormality:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 25 2}
{cmd:mvtest} {cmdab:norm:ality} {varlist} {ifin} 
[{it:{help mvtest normality##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 15 tabbed}{...}
{marker options_table}{...}
{synopthdr}
{synoptline}
{syntab:Options}
{synopt:{opt uni:variate}}display tests for univariate normality ({cmd:sktest})
{p_end}
{synopt:{opt bi:variate}}display tests for bivariate normality
	(Doornik-Hansen) {p_end}
{synopt:{opt st:ats(stats)}}statistics to be computed{p_end}
{synoptline}

{synoptset 15}{...}
{marker statistics}{...}
{synopthdr:stats}
{synoptline}
{synopt:{opt dh:ansen}}Doornik-Hansen omnibus test; the default{p_end}
{synopt:{opt hz:irkler}}Henze-Zirkler's consistent test{p_end}
{synopt:{opt ku:rtosis}}Mardia's multivariate kurtosis test{p_end}
{synopt:{opt sk:ewness}}Mardia's multivariate skewness test{p_end}
{synopt:{opt all}}all tests listed here{p_end}
{synoptline}

{p 4 6 2}
{cmd:bootstrap}, {cmd:by}, {cmd:jackknife}, {cmd:rolling}, and {cmd:statsby}
are allowed; see {help prefix}.{p_end}
{p 4 6 2}
Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}
{cmd:aweight}s are not allowed with the {helpb jackknife} prefix.{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s are allowed; see {help weight}.
{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate analysis > MANOVA, multivariate regression,}
           {bf:and related > Multivariate test of means, covariances, and}
           {bf:normality}


{marker description}{...}
{title:Description}

{pstd}
{cmd:mvtest normality} performs tests for univariate, bivariate, and
multivariate normality.

{pstd}
See {manhelp mvtest MV} for more multivariate tests.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV mvtestnormalityQuickstart:Quick start}

        {mansection MV mvtestnormalityRemarksandexamples:Remarks and examples}

        {mansection MV mvtestnormalityMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Options}

{phang}
{cmd:univariate}
specifies that tests for univariate normality be displayed, as obtained
from {helpb sktest}.

{phang}
{cmd:bivariate}
specifies that the {help mvtest normality##DH2008:Doornik-Hansen (2008)}
test for bivariate normality be
displayed for each pair of variables.

{phang}
{opt stats(stats)} specifies one or more test statistics for
multivariate normality.  Multiple {it:stats} are separated by white space.
The following {it:stats} are available:

{phang3}
{opt dhansen} produces the {help mvtest normality##DH2008:Doornik-Hansen (2008)}
omnibus test.

{phang3}
{opt hzirkler} produces Henze-Zirkler's
({help mvtest normality##HZ1990:1990}) consistent test.

{phang3}
{opt kurtosis} produces the test based on Mardia's
({help mvtest normality##M1970:1970}) measure of
multivariate kurtosis.

{phang3}
{opt skewness} produces the test based on Mardia's
({help mvtest normality##M1970:1970}) measure of
multivariate skewness.

{phang3}
{opt all} is a convenient shorthand for
{cmd:stats(dhansen hzirkler kurtosis skewness)}.


{marker notes}{...}
{title:Notes}

{pstd}
The Doornik-Hansen ({help mvtest normality##DH2008:2008}) test and
Mardia's ({help mvtest normality##M1970:1970}) test for
multivariate kurtosis take computing time roughly proportional to the
number of observations.  In contrast, the computing time of the test by
Henze-Zirkler ({help mvtest normality##HZ1990:1990}) and Mardia's
({help mvtest normality##M1970:1970}) test for multivariate skewness are
roughly proportional to the square of the number of observations.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse iris}{p_end}
{phang2}{cmd:. keep if iris==1}{p_end}

{pstd}Display Doornik-Hansen omnibus test{p_end}
{phang2}{cmd:. mvtest normality pet* sep*}

{pstd}Same as above, but also display test for univariate normality{p_end}
{phang2}{cmd:. mvtest normality pet* sep*, univariate}

{pstd}Display univariate, bivariate, and multivariate tests for normality{p_end}
{phang2}
{cmd:. mvtest normality pet* sep*, univariate bivariate stats(all)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mvtest normality} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(p_dh)}}p-value for Doornik-Hansen test ({cmd:stats(dhansen)}){p_end}
{synopt:{cmd:r(df_dh)}}degrees of freedom of chi2_dh
	({cmd:stats(dhansen)}){p_end}
{synopt:{cmd:r(chi2_dh)}}Doornik-Hansen statistic ({cmd:stats(dhansen)}){p_end}
{synopt:{cmd:r(rank_hz)}}rank of covariance matrix
	({cmd:stats(hzirkler)}){p_end}
{synopt:{cmd:r(p_hz)}}p-value for two-sided Hanze-Zirkler's test 
	({cmd:stats(hzirkler)}){p_end}
{synopt:{cmd:r(z_hz)}}normal variate associated with hz
	({cmd:stats(hzirkler)}){p_end}
{synopt:{cmd:r(V_hz)}}expected variance of log(hz)
	({cmd:stats(hzirkler)}){p_end}
{synopt:{cmd:r(E_hz)}}expected value of log(hz) ({cmd:stats(hzirkler)}){p_end}
{synopt:{cmd:r(hz)}}Henze-Zirkler discrepancy statistic
	({cmd:stats(hzirkler)}){p_end}
{synopt:{cmd:r(rank_mkurt)}}rank of covariance matrix
	({cmd:stats(kurtosis)}){p_end}
{synopt:{cmd:r(p_mkurt)}}p-value for Mardia's multivariate kurtosis test
	({cmd:stats(kurtosis)}){p_end}
{synopt:{cmd:r(z_mkurt)}}normal variate associated with Mardia mKurtosis
	({cmd:stats(kurtosis)}){p_end}
{synopt:{cmd:r(chi2_mkurt)}}chi-squared of Mardia mKurtosis
	({cmd:stats(kurtosis)}){p_end}
{synopt:{cmd:r(mkurt)}}Mardia mKurtosis test statistic
	({cmd:stats(kurtosis)}){p_end}
{synopt:{cmd:r(rank_mskew)}}rank for Mardia mSkewness test
	({cmd:stats(skewness)}){p_end}
{synopt:{cmd:r(p_mskew)}}p-value for Mardia's multivariate skewness test
	({cmd:stats(skewness)}){p_end}
{synopt:{cmd:r(df_mskew)}}degrees of freedom of Mardia mSkewness test
	({cmd:stats(skewness)}){p_end}
{synopt:{cmd:r(chi2_mskew)}}chi-squared of Mardia mSkewness test
	({cmd:stats(skewness)}){p_end}
{synopt:{cmd:r(mskew)}}Mardia mSkewness test statistic
	({cmd:stats(skewness)}){p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(U_dh)}}matrix with the skewness and kurtosis of orthonormalized
	variables (used in the Doornik-Hansen test): b1, b2, z(b1), and
	z(b2) ({cmd:stats(dhansen)}){p_end}
{synopt:{cmd:r(Btest)}}bivariate test statistics ({cmd:bivariate}){p_end}
{synopt:{cmd:r(Utest)}}univariate test statistics ({cmd:univariate}){p_end}


{marker references}{...}
{title:References}

{marker DH2008}{...}
{phang}
Doornik, J. A., and H. Hansen. 2008.
An omnibus test for univariate and multivariate normality.
{it:Oxford Bulletin of Economics and Statistics} 70: 927-939.

{marker HZ1990}{...}
{phang}
Henze, N., and B. Zirkler. 1990.
A class of invariant consistent tests for multivariate normality.
{it:Communications in Statistics, Theory and Methods} 19: 3595-3617.

{marker M1970}{...}
{phang}
Mardia, K. V. 1970.
Measures of multivariate skewness and kurtosis with applications.
{it:Biometrika} 57: 519-530.
{p_end}
