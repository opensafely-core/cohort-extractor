{smcl}
{* *! version 1.1.13  14may2018}{...}
{viewerdialog mvtest "dialog mvtest"}{...}
{vieweralsosee "[MV] mvtest" "mansection MV mvtest"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] canon" "help canon"}{...}
{vieweralsosee "[R] correlate" "help correlate"}{...}
{vieweralsosee "[MV] hotelling" "help hotelling"}{...}
{vieweralsosee "[MV] manova" "help manova"}{...}
{vieweralsosee "[R] mean" "help mean"}{...}
{vieweralsosee "[R] sdtest" "help sdtest"}{...}
{vieweralsosee "[R] sktest" "help sktest"}{...}
{vieweralsosee "[R] swilk" "help swilk"}{...}
{vieweralsosee "[R] ttest" "help ttest"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] Intro 5" "mansection SEM Intro5"}{...}
{findalias assemcorr}{...}
{viewerjumpto "Syntax" "mvtest##syntax"}{...}
{viewerjumpto "Description" "mvtest##description"}{...}
{viewerjumpto "Examples" "mvtest##examples"}{...}
{viewerjumpto "Reference" "mvtest##reference"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[MV] mvtest} {hline 2}}Multivariate tests{p_end}
{p2col:}({mansection MV mvtest:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:mvtest} {it:subcommand} ... [{cmd:,} ...]

{synoptset 14}{...}
{synopthdr:subcommand}
{synoptline}
{synopt:{helpb mvtest_means:means}}test means{p_end}
{synopt:{helpb mvtest_covariances:covariances}}test covariances{p_end}
{synopt:{helpb mvtest_correlations:correlations}}test correlations{p_end}
{synopt:{helpb mvtest_normality:normality}}test multivariate normality{p_end}
{synoptline}


{marker description}{...}
{title:Description}

{pstd}
{cmd:mvtest} performs multivariate tests on means, covariances, and
correlations and tests of univariate, bivariate, and multivariate normality.
The tests of means, covariances, and correlations assume multivariate normality
({help mvtest##MKB1979:Mardia, Kent, and Bibby 1979}).
Both one-sample and multiple-sample tests are
provided.  All multiple-sample tests provided by {cmd:mvtest} assume
independent samples.

{pstd}
Structural equation modeling provides a more general framework for
estimating means, covariances, and correlations and testing for differences
across groups; see {mansection SEM Intro5:{bf:[SEM] Intro 5}} and
{findalias semcorr}.

{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse iris}{p_end}
{phang2}{cmd:. keep if iris==1}{p_end}

{pstd}Show univariate, bivariate, and multivariate tests for normality{p_end}
{phang2}
{cmd:. mvtest normality pet* sep*, bivariate univariate stats(all)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse milktruck, clear}{p_end}

{pstd}Test that the means of the variables are equal{p_end}
{phang2}{cmd:. mvtest means fuel repair capital, equal}{p_end}

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

{pstd}Test that the correlation matrix is compound symmetric (that is, that all
correlations are equal){p_end}
{phang2}{cmd:. mvtest correlations fuel repair capital, compound}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse metabolic}{p_end}

{pstd}Test that the means are equal for the groups, assuming equality of
covariance matrices{p_end}
{phang2}{cmd:. mvtest means y1 y2, by(group)}{p_end}

{pstd}Test that the means are equal for the first 3 groups, allowing for
heteroskedasticity{p_end}
{phang2}{cmd:. mvtest means y1 y2 if group<4, by(group) heterogeneous}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse genderpsych}{p_end}

{pstd}Test that the covariance matrices are equal for the groups{p_end}
{phang2}{cmd:. mvtest covariances y1 y2 y3 y4, by(gender)}{p_end}

{pstd}Test that the correlation matrices are equal for the groups{p_end}
{phang2}{cmd:. mvtest correlations y1 y2 y3 y4, by(gender)}{p_end}
    {hline}


{marker reference}{...}
{title:Reference}

{marker MKB1979}{...}
{phang}
Mardia, K. V., J. T. Kent, and J. M. Bibby. 1979.
{it:Multivariate Analysis}.  London: Academic Press.
{p_end}
