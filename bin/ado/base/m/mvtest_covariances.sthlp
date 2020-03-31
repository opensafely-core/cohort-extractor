{smcl}
{* *! version 1.1.16  19oct2017}{...}
{viewerdialog mvtest "dialog mvtest"}{...}
{vieweralsosee "[MV] mvtest covariances" "mansection MV mvtestcovariances"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] candisc" "help candisc"}{...}
{vieweralsosee "[MV] canon" "help canon"}{...}
{vieweralsosee "[R] correlate" "help correlate"}{...}
{vieweralsosee "[MV] discrim lda" "help discrim_lda"}{...}
{vieweralsosee "[MV] manova" "help manova"}{...}
{vieweralsosee "[R] sdtest" "help sdtest"}{...}
{viewerjumpto "Syntax" "mvtest_covariances##syntax"}{...}
{viewerjumpto "Menu" "mvtest_covariances##menu"}{...}
{viewerjumpto "Description" "mvtest_covariances##description"}{...}
{viewerjumpto "Links to PDF documentation" "mvtest_covariances##linkspdf"}{...}
{viewerjumpto "Options for multiple-sample tests" "mvtest_covariances##options_multi"}{...}
{viewerjumpto "Options for one-sample tests" "mvtest_covariances##options_one"}{...}
{viewerjumpto "Examples" "mvtest_covariances##examples"}{...}
{viewerjumpto "Stored results" "mvtest_covariances##results"}{...}
{p2colset 1 28 18 2}{...}
{p2col:{bf:[MV] mvtest covariances} {hline 2}}Multivariate tests of covariances{p_end}
{p2col:}({mansection MV mvtestcovariances:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Multiple-sample tests

{p 8 15 2}
{cmd:mvtest} {cmdab:cov:ariances} {varlist} {ifin}
[{it:{help mvtest covariances##weight:weight}}]{cmd:,}
{opth by:(varlist:groupvars)}
[{help mvtest covariances##multisample_options:{it:multisample_options}}]


{pstd}
One-sample tests

{p 8 15 2}
{cmd:mvtest} {cmdab:cov:ariances} {varlist} {ifin}
[{it:{help mvtest covariances##weight:weight}}]
[{cmd:,}
{help mvtest covariances##one-sample_options:{it:one-sample_options}}]


{synoptset 25 tabbed}{...}
{marker multisample_options}{...}
{synopthdr:multisample_options}
{synoptline}
{syntab:Model}
{p2coldent:* {opth by:(varlist:groupvars)}}compare subsamples with same
	values in {it:groupvars}{p_end}
{synopt:{opt miss:ing}}treat missing values in {it:groupvars} as ordinary
	values{p_end}
{synoptline}
{p 4 6 2}* {opt by(groupvars)} is required.

{synoptset 25 tabbed}{...}
{marker one-sample_options}{...}
{synopthdr:one-sample_options}
{synoptline}
{syntab:Options}
{synopt:{opt diag:onal}}test that covariance matrix is diagonal; the default{p_end}
{synopt:{opt sph:erical}}test that covariance matrix is spherical{p_end}
{synopt:{opt comp:ound}}test that covariance matrix is compound symmetric{p_end}
{synopt:{opt e:quals(C)}}test that covariance matrix equals matrix {it:C}{p_end}
{synopt:{opt bl:ock}{cmd:(}{it:{help varlist:varlist1}} [{cmd:||}}{p_end}
{synopt:{space 6}{it:varlist2} [{cmd:||}{it:...}]]{cmd:)}}test that covariance 
      matrix is block diagonal with blocks corresponding to {it:varlist#}{p_end}
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
{cmd:aweight}s and {cmd:fweight}s are allowed; see {help weight}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate analysis > MANOVA, multivariate regression,}
           {bf:and related > Multivariate test of means, covariances, and}
           {bf:normality}


{marker description}{...}
{title:Description}

{pstd}
{cmd:mvtest covariances} performs one-sample and multiple-sample multivariate
tests on covariances.  These tests assume multivariate normality.

{pstd}
See {manhelp mvtest MV} for other multivariate tests.  See {manhelp sdtest R}
for univariate tests of standard deviations.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV mvtestcovariancesQuickstart:Quick start}

        {mansection MV mvtestcovariancesRemarksandexamples:Remarks and examples}

        {mansection MV mvtestcovariancesMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_multi}{...}
{title:Options for multiple-sample tests}

{dlgtab:Model}

{phang}
{opth by:(varlist:groupvars)} is required with the multiple-sample version of
the test.  Observations with the same values in {it:groupvars} form a sample.
Observations with missing values in {it:groupvars} are ignored, unless the
{cmd:missing} option is specified.

{pmore}
A modified likelihood-ratio statistic testing the equality of covariance
matrices for the multiple independent samples defined by {cmd:by()} is
presented along with an F and chi-squared approximation due to Box.  This test
is also known as Box's M test.

{phang}
{opt missing} specifies that missing values in {it:groupvars} are treated like
ordinary values.


{marker options_one}{...}
{title:Options for one-sample tests}

{dlgtab:Options}

{phang}
{cmd:diagonal}, the default, tests the hypothesis that the covariance matrix
is diagonal, that is, that the variables in {varlist} are independent.
A likelihood-ratio test with first-order Bartlett correction is displayed.

{phang}
{cmd:spherical} tests the hypothesis that the covariance matrix is
diagonal with constant diagonal values, that is, that the variables in
{varlist} are homoskedastic and independent.  A likelihood-ratio test with
first-order Bartlett correction is displayed.

{phang}
{cmd:compound} tests the hypothesis that the covariance matrix is
compound symmetric, that is, that the variables in {varlist} are
homoskedastic and that every pair of two variables has the same covariance.  A
likelihood-ratio test with first-order Bartlett correction is displayed.

{phang}
{cmd:equals(}{it:C}{cmd:)} specifies that the hypothesized covariance
matrix for the k variables in {varlist} is {it:C}.  The matrix {it:C}
must be kxk, symmetric, and positive definite.  The row and column names of
{it:C} are ignored.  A likelihood-ratio test with first-order Bartlett
correction is displayed.

{phang}
{cmd:block(}{it:{help varlist:varlist1}} [{cmd:||} {it:varlist2}
[{cmd:||}...]]{cmd:)}
tests the hypothesis that the covariance matrix is block diagonal with
blocks {it:varlist1}, {it:varlist2}, etc.  Variables in {it:varlist} not
included in {it:varlist1}, {it:varlist2}, etc., are treated as an additional
block.  With this pattern, variables in different blocks are independent, but
no assumptions are made on the within-block covariance structure.  A
likelihood-ratio test with first-order Bartlett correction is displayed.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse milktruck}{p_end}

{pstd}Test that the covariance matrix is diagonal{p_end}
{phang2}{cmd:. mvtest covariances fuel repair capital, diagonal}{p_end}

{pstd}Test that the covariance matrix is block diagonal{p_end}
{phang2}
{cmd:. mvtest covariances fuel repair capital, block(fuel repair || capital)}
{p_end}

{pstd}Test that the covariance matrix is spherical{p_end}
{phang2}{cmd:. mvtest covariances fuel repair capital, spherical}{p_end}

{pstd}Test that the covariance matrix is compound symmetric{p_end}
{phang2}{cmd:. mvtest covariances fuel repair capital, compound}{p_end}

{pstd}Test that the covariance matrix is equal to a given matrix{p_end}
{phang2}{cmd:. mat B = (30, 15, 0 \ 15, 20, 0 \ 0, 0, 10)}{p_end}
{phang2}{cmd:. mvtest covariances fuel repair capital, equals(B)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse genderpsych}{p_end}

{pstd}Test that the covariance matrices are equal for the groups{p_end}
{phang2}{cmd:. mvtest covariances y1 y2 y3 y4, by(gender)}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mvtest covariances} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(chi2)}}chi-squared{p_end}
{synopt:{cmd:r(df)}}degrees of freedom for chi-squared test{p_end}
{synopt:{cmd:r(p_chi2)}}p-value for chi-squared test{p_end}
{synopt:{cmd:r(F_Box)}}F statistic for Box test ({cmd:by()} only){p_end}
{synopt:{cmd:r(df_m_Box)}}model degrees of freedom for Box test
            ({cmd:by()} only){p_end}
{synopt:{cmd:r(df_r_Box)}}residual degrees of freedom for Box test
            ({cmd:by()} only){p_end}
{synopt:{cmd:r(p_F_Box)}}p-value for Box's F test ({cmd:by()} only){p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(chi2type)}}type of model chi-squared test{p_end}
