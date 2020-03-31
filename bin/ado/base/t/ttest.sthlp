{smcl}
{* *! version 1.1.27  21aug2019}{...}
{viewerdialog "ttest" "dialog ttest"}{...}
{viewerdialog "ttesti" "dialog ttesti"}{...}
{vieweralsosee "[R] ttest" "mansection R ttest"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] bitest" "help bitest"}{...}
{vieweralsosee "[R] ci" "help ci"}{...}
{vieweralsosee "[R] esize" "help esize"}{...}
{vieweralsosee "[MV] hotelling" "help hotelling"}{...}
{vieweralsosee "[R] mean" "help mean"}{...}
{vieweralsosee "[R] oneway" "help oneway"}{...}
{vieweralsosee "[R] prtest" "help prtest"}{...}
{vieweralsosee "[R] sdtest" "help sdtest"}{...}
{vieweralsosee "[R] ztest" "help ztest"}{...}
{viewerjumpto "Syntax" "ttest##syntax"}{...}
{viewerjumpto "Menu" "ttest##menu"}{...}
{viewerjumpto "Description" "ttest##description"}{...}
{viewerjumpto "Links to PDF documentation" "ttest##linkspdf"}{...}
{viewerjumpto "Options" "ttest##options"}{...}
{viewerjumpto "Examples" "ttest##examples"}{...}
{viewerjumpto "Video examples" "ttest##video"}{...}
{viewerjumpto "Stored results" "ttest##results"}{...}
{viewerjumpto "References" "ttest##references"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[R] ttest} {hline 2}}t tests (mean-comparison tests){p_end}
{p2col:}({mansection R ttest:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
One-sample t test

{p 8 14 2}
{cmd:ttest}
{varname}
{cmd:==}
{it:#}
{ifin}
[{cmd:,} {opt l:evel(#)}]


{pstd}
Two-sample t test using groups

{p 8 14 2}
{cmd:ttest}
{varname}
{ifin}
{cmd:,}
{opth by:(varlist:groupvar)}
[{it:{help ttest##options1:options1}}]


{pstd}
Two-sample t test using variables

{p 8 14 2}
{cmd:ttest}
{varname:1}
{cmd:==}
{varname:2}
{ifin}{cmd:,}
{opt unp:aired}
[{opt une:qual}
{opt w:elch}
{opt l:evel(#)}]


{pstd}
Paired t test

{p 8 14 2}
{cmd:ttest}
{varname:1}
{cmd:==}
{varname:2}
{ifin}
[{cmd:,} {opt l:evel(#)}]


{pstd}
Immediate form of one-sample t test

{p 8 14 2}
{cmd:ttesti}
{it:#obs}
{it:#mean}
{it:#sd}
{it:#val}
[{cmd:,}
{opt l:evel(#)}]


{pstd}
Immediate form of two-sample t test

{p 8 14 2}
{cmd:ttesti}
{it:#obs1}
{it:#mean1}
{it:#sd1}
{it:#obs2}
{it:#mean2}
{it:#sd2}
[{cmd:,}
{it:{help ttest##options2:options2}}]


{synoptset 16 tabbed}{...}
{marker options1}{...}
{synopthdr:options1}
{synoptline}
{syntab:Main}
{p2coldent:* {opth by:(varlist:groupvar)}}variable defining the groups{p_end}
{synopt:{opt rev:erse}}reverse group order for mean difference
computation{p_end}
{synopt:{opt une:qual}}unpaired data have unequal variances{p_end}
{synopt:{opt w:elch}}use Welch's approximation{p_end}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synoptline}
{p 4 6 2}* {opt by(groupvar)} is required.{p_end}

{marker options2}{...}
{synopthdr:options2}
{synoptline}
{syntab:Main}
{synopt:{opt une:qual}}unpaired data have unequal variances{p_end}
{synopt:{opt w:elch}}use Welch's approximation{p_end}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synoptline}
{p2colreset}{...}

{phang}
{opt by} is allowed with {cmd:ttest}; see {manhelp by D}.


{marker menu}{...}
{title:Menu}

    {title:ttest}

{phang2}
{bf:Statistics > Summaries, tables, and tests > Classical tests of hypotheses}
       {bf:> t test (mean-comparison test)}

    {title:ttesti}

{phang2}
{bf:Statistics > Summaries, tables, and tests > Classical tests of hypotheses}
       {bf:> t test calculator}


{marker description}{...}
{title:Description}

{pstd}
{opt ttest} performs t tests on the equality of means.
The test can be performed for one sample against a hypothesized population
mean.  Two-sample tests can be conducted for paired and unpaired data.  The
assumption of equal variances can be optionally relaxed in the unpaired
two-sample case.

{pstd}
{opt ttesti} is the immediate form of {opt ttest}; see {help immed}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R ttestQuickstart:Quick start}

        {mansection R ttestRemarksandexamples:Remarks and examples}

        {mansection R ttestMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth by:(varlist:groupvar)} specifies the {it:groupvar} that defines the two
groups that {opt ttest} will use to test the hypothesis that their means are
equal.  Specifying {opt by(groupvar)} implies an unpaired (two sample) t test.
Do not confuse the {opt by()} option with the {cmd:by} prefix; you can specify
both.

{phang}
{opt reverse} reverses the order of the mean difference between groups defined
in {opt by()}.  By default, the mean of the group corresponding to the largest
value in the variable in {opt by()} is subtracted from the mean of the group
with the smallest value in {opt by()}.  {opt reverse} reverses this behavior
and the order in which variables appear on the table.

{phang}
{opt unpaired} specifies that the data be treated as unpaired.  The
   {opt unpaired} option is used when the two sets of values to be compared are
   in different variables.

{phang}
{opt unequal} specifies that the unpaired data not be assumed to have equal
   variances.

{phang}
{opt welch} specifies that the approximate degrees of freedom for the test
   be obtained from Welch's formula
   ({help ttest##W1947:1947}) rather than from Satterthwaite's approximation
   formula ({help ttest##S1946:1946}), which is the default when {opt unequal}
   is specified.  Specifying {opt welch} implies {opt unequal}.

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for confidence
   intervals.  The default is {cmd:level(95)} or as set by {helpb set level}.


{marker examples}{...}
{title:Examples}

    {cmd:. sysuse auto}             (setup)
    {cmd:. ttest mpg==20}           (one-sample t test)

    {cmd:. webuse fuel3}            (setup)
    {cmd:. ttest mpg, by(treated)}  (two-sample t test using groups)

    {cmd:. webuse fuel}             (setup)
    {cmd:. ttest mpg1==mpg2}        (two-sample t test using variables)

                              (no setup required)
    {cmd:. ttesti 24 62.6 15.8 75}  (immediate form; n=24, m=62.6, sd=15.8;
                                    test m=75)

{marker video}{...}
{title:Video examples}

{phang}
{browse "http://www.youtube.com/watch?v=HwzCyqW-0dc":One-sample t test in Stata}

{phang}
{browse "http://www.youtube.com/watch?v=by4c3h3WXQc":t test for two independent samples in Stata}

{phang}
{browse "http://www.youtube.com/watch?v=GiDSnufmZgI":t test for two paired samples in Stata}

{phang}
{browse "http://www.youtube.com/watch?v=BfLw-AhXH-8":One-sample t-test calculator}

{phang}
{browse "http://www.youtube.com/watch?v=6cQwbvvkFO8":Two-sample t-test calculator}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:ttest} and {cmd:ttesti} store the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N_1)}}sample size n_1{p_end}
{synopt:{cmd:r(N_2)}}sample size n_2{p_end}
{synopt:{cmd:r(p_l)}}lower one-sided p-value{p_end}
{synopt:{cmd:r(p_u)}}upper one-sided p-value{p_end}
{synopt:{cmd:r(p)}}two-sided p-value{p_end}
{synopt:{cmd:r(se)}}estimate of standard error{p_end}
{synopt:{cmd:r(t)}}t statistic{p_end}
{synopt:{cmd:r(sd_1)}}standard deviation for first variable{p_end}
{synopt:{cmd:r(sd_2)}}standard deviation for second variable{p_end}
{synopt:{cmd:r(sd)}}combined standard deviation{p_end}
{synopt:{cmd:r(mu_1)}}x_1 bar, mean for population 1{p_end}
{synopt:{cmd:r(mu_2)}}x_2 bar, mean for population 2{p_end}
{synopt:{cmd:r(df_t)}}degrees of freedom{p_end}
{synopt:{cmd:r(level)}}confidence level{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker S1946}{...}
{phang}
Satterthwaite, F. E. 1946.
An approximate distribution of estimates of variance components.
{it:Biometrics Bulletin} 2: 110-114.

{marker W1947}{...}
{phang}
Welch, B. L. 1947.
The generalization of `student's' problem when several different population
variances are involved. {it:Biometrika} 34: 28-35.
{p_end}
