{smcl}
{* *! version 1.1.18  19oct2017}{...}
{viewerdialog "sdtest" "dialog sdtest"}{...}
{viewerdialog "sdtesti" "dialog sdtesti"}{...}
{viewerdialog robvar "dialog robvar"}{...}
{vieweralsosee "[R] sdtest" "mansection R sdtest"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ttest" "help ttest"}{...}
{viewerjumpto "Syntax" "sdtest##syntax"}{...}
{viewerjumpto "Menu" "sdtest##menu"}{...}
{viewerjumpto "Description" "sdtest##description"}{...}
{viewerjumpto "Links to PDF documentation" "sdtest##linkspdf"}{...}
{viewerjumpto "Options" "sdtest##options"}{...}
{viewerjumpto "Examples" "sdtest##examples"}{...}
{viewerjumpto "Stored results" "sdtest##results"}{...}
{viewerjumpto "References" "sdtest##references"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[R] sdtest} {hline 2}}Variance-comparison tests{p_end}
{p2col:}({mansection R sdtest:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
One-sample variance-comparison test

{p 8 16 2}
{opt sdtest}{space 2}{varname}
{cmd:==}
{it:#}
{ifin}
[{cmd:,} {opt l:evel(#)}]


{phang}
Two-sample variance-comparison test using groups

{p 8 16 2}
{opt sdtest}{space 2}{varname}
{ifin}
{cmd:,} {opth by:(varlist:groupvar)}
[{opt l:evel(#)}]


{phang}
Two-sample variance-comparison test using variables

{p 8 16 2}
{opt sdtest}{space 2}{varname:1}
{cmd:==}
{varname:2}
{ifin}
[{cmd:,} {opt l:evel(#)}]


{phang}
Immediate form of one-sample variance-comparison test

{p 8 16 2}
{cmd:sdtesti}
{it:#obs}
{c -(}{it:#mean} | {cmd:.} {c )-}
{it:#sd}
{it:#val}
[{cmd:,} {opt l:evel(#)}]


{phang}
Immediate form of two-sample variance-comparison test

{p 8 16 2}
{cmd:sdtesti}
{it:#obs1}
{c -(}{it:#mean1} | {cmd:.} {c )-}
{it:#sd1}
{it:#obs2}
{c -(}{it:#mean2} | {cmd:.} {c )-}
{it:#sd2}
[{cmd:,} {opt l:evel(#)}]


{phang}
Robust tests for equality of variances

{p 8 16 2}
{cmd:robvar}{space 2}{varname}
{ifin}
{cmd:,} {opth by:(varlist:groupvar)}


{pmore}
{cmd:by} is allowed with {opt sdtest} and {opt robvar}; see {manhelp by D}.


{marker menu}{...}
{title:Menu}

    {title:sdtest}

{phang2}
{bf:Statistics > Summaries, tables, and tests >}
       {bf:Classical tests of hypotheses > Variance-comparison test}

    {title:sdtesti}

{phang2}
{bf:Statistics > Summaries, tables, and tests >}
        {bf:Classical tests of hypotheses >}
        {bf:Variance-comparison test calculator}

    {title:robvar}

{phang2}
{bf:Statistics > Summaries, tables, and tests >}
     {bf:Classical tests of hypotheses > Robust equal-variance test}


{marker description}{...}
{title:Description}

{pstd}
{opt sdtest} performs tests on the equality of standard deviations (variances).
In the first form, {opt sdtest} tests that the standard deviation of
{varname} is {it:#}.
In the second form, {opt sdtest} performs the same test, using the
standard deviations of the two groups defined by {it:{help varlist:groupvar}}.
In the third form, {opt sdtest} tests that {it:varname1} and {it:varname2}
have the same standard deviation.

{pstd}
{opt sdtesti} is the immediate form of {opt sdtest}; see {help immed}.

{pstd}
Both the traditional F test for the homogeneity of variances and Bartlett's
generalization of this test to K samples are sensitive to the assumption
that the data are drawn from an underlying Gaussian distribution.
See, for example, the cautionary results discussed by
{help sdtest##MM1990:Markowski and Markowski (1990)}.
{help sdtest##L1960:Levene (1960)}
proposed a test statistic for equality of variance that
was found to be robust under nonnormality.  Then 
{help sdtest##BF1974:Brown and Forsythe (1974)}
proposed alternative formulations of Levene's test statistic that use
more robust estimators of central tendency in place of the mean.  These
reformulations were demonstrated to be more robust than Levene's test when
dealing with skewed populations.

{pstd}
{opt robvar} reports Levene's robust test statistic (W_0) for the equality
of variances between the groups defined by {it:groupvar} and the two
statistics proposed by Brown and Forsythe that replace the mean in Levene's
formula with alternative location estimators.  The first alternative (W_50)
replaces the mean with the median.  The second alternative replaces the mean
with the 10% trimmed mean (W_10).


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R sdtestQuickstart:Quick start}

        {mansection R sdtestRemarksandexamples:Remarks and examples}

        {mansection R sdtestMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for
confidence intervals of the means.  The default is {cmd:level(95)} or as set
by {helpb set level}.

{phang}
{opth by:(varlist:groupvar)} specifies the {it:groupvar} that defines the
groups to be compared.  For {opt sdtest}, there should be two groups, but for
{opt robvar} there may be more than two groups.  Do not confuse the {opt by()}
option with the {opt by} prefix; both may be specified.


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. sysuse auto}

{pstd}
Test standard deviation of {cmd:mpg} against 5{p_end}
{phang2}{cmd:. sdtest mpg == 5}

    {hline}
    Setup
{phang2}{cmd:. webuse fuel}

{pstd}Test that {cmd:mpg1} and {cmd:mpg2} have same standard deviation{p_end}
{phang2}{cmd:. sdtest mpg1 == mpg2}

    {hline}
    Setup
{phang2}{cmd:. webuse fuel2}{p_end}

{pstd}
Test that the two groups of {cmd:treat} have same standard deviation{p_end}
{phang2}{cmd:. sdtest mpg, by(treat)}

{pstd}
Test sd=6 when observed sd=6.5 and n=75{p_end}
{phang2}{cmd:. sdtesti 75 . 6.5 6}

{pstd}
Test sd1=sd2 when observed n1=75, sd1=6.5, n2=65, and sd2= 7.5{p_end}
{phang2}{cmd:. sdtesti 75 . 6.5 65 . 7.5}

    {hline}
    Setup
{phang2}{cmd:. webuse stay}

{pstd}
Test whether length of stay differs by gender{p_end}
{phang2}{cmd:. robvar lengthstay, by(sex)}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:sdtest} and {cmd:sdtesti} store the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(p_l)}}lower one-sided p-value{p_end}
{synopt:{cmd:r(p_u)}}upper one-sided p-value{p_end}
{synopt:{cmd:r(p)}}two-sided p-value{p_end}
{synopt:{cmd:r(F)}}F statistic{p_end}
{synopt:{cmd:r(sd)}}standard deviation{p_end}
{synopt:{cmd:r(sd_1)}}standard deviation for first variable{p_end}
{synopt:{cmd:r(sd_2)}}standard deviation for second variable{p_end}
{synopt:{cmd:r(df)}}degrees of freedom{p_end}
{synopt:{cmd:r(df_1)}}numerator degrees of freedom{p_end}
{synopt:{cmd:r(df_2)}}denominator degrees of freedom{p_end}
{synopt:{cmd:r(chi2)}}chi-squared{p_end}

{pstd}
{cmd:robvar} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(w50)}}Brown and Forsythe's F statistic (median){p_end}
{synopt:{cmd:r(p_w50)}}Brown and Forsythe's p-value{p_end}
{synopt:{cmd:r(w0)}}Levene's F statistic{p_end}
{synopt:{cmd:r(p_w0)}}Levene's p-value{p_end}
{synopt:{cmd:r(w10)}}Brown and Forsythe's F statistic (trimmed mean){p_end}
{synopt:{cmd:r(p_w10)}}Brown and Forsythe's p-value (trimmed mean){p_end}
{synopt:{cmd:r(df_1)}}numerator degrees of freedom{p_end}
{synopt:{cmd:r(df_2)}}denominator degrees of freedom{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker BF1974}{...}
{phang}
Brown, M. B., and A. B. Forsythe. 1974. Robust test for the equality of
variances. {it:Journal of the American Statistical Association} 69: 364-367.

{marker L1960}{...}
{phang}
Levene, H. 1960. Robust tests for equality of variances. In
{it:Contributions to Probability and Statistics: Essays in Honor of Harold}
{it:Hotelling}, ed. I. Olkin, S. G. Ghurye, W. Hoeffding, W. G. Madow, and
H. B. Mann, 278-292. Menlo Park, CA: Stanford University Press.

{marker MM1990}{...}
{phang}
Markowski, C. A., and E. P. Markowski. 1990.
Conditions for the effectiveness of a preliminary test of variance.
{it:American Statistician} 44: 322-326.
{p_end}
