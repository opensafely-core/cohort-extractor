{smcl}
{* *! version 1.1.15  10dec2018}{...}
{viewerdialog ranksum "dialog ranksum"}{...}
{viewerdialog median "dialog median"}{...}
{vieweralsosee "[R] ranksum" "mansection R ranksum"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] signrank" "help signrank"}{...}
{vieweralsosee "[R] ttest" "help ttest"}{...}
{viewerjumpto "Syntax" "ranksum##syntax"}{...}
{viewerjumpto "Menu" "ranksum##menu"}{...}
{viewerjumpto "Description" "ranksum##description"}{...}
{viewerjumpto "Links to PDF documentation" "ranksum##linkspdf"}{...}
{viewerjumpto "Options for ranksum" "ranksum##options_ranksum"}{...}
{viewerjumpto "Options for median" "ranksum##options_median"}{...}
{viewerjumpto "Examples" "ranksum##examples"}{...}
{viewerjumpto "Stored results" "ranksum##results"}{...}
{viewerjumpto "References" "ranksum##references"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[R] ranksum} {hline 2}}Equality tests on unmatched data{p_end}
{p2col:}({mansection R ranksum:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Wilcoxon rank-sum test

{p 8 19 2}
{cmd:ranksum} {varname} {ifin}{cmd:,}
    {cmd:by(}{it:{help varlist:groupvar}}{cmd:)} [{cmd:exact} {cmd:porder}]


{phang}
Nonparametric equality-of-medians test

{p 8 18 2}
{cmd:median} {varname} {ifin} 
[{it:{help ranksum##weight:weight}}]
{cmd:,}
     {cmd:by(}{it:{help varlist:groupvar}}{cmd:)}
[{it:{help ranksum##median_options:median_options}}]


{synoptset 21 tabbed}{...}
{synopthdr:ranksum_options}
{synoptline}
{syntab:Main}
{p2coldent:* {opth by:(varlist:groupvar)}}grouping variable{p_end}
{synopt :{opt exact}}report exact p-value for rank-sum test; by default, exact
p-value is computed when total sample size {ul:<} 200{p_end}
{synopt :{opt porder}}probability that variable for first group is larger than
variable for second group{p_end}
{synoptline}

{marker median_options}{...}
{synopthdr:median_options}
{synoptline}
{syntab:Main}
{p2coldent:* {opth by:(varlist:groupvar)}}grouping variable{p_end}
{synopt :{opt exact}}report p-value from Fisher's exact test{p_end}
{synopt :{cmdab:med:ianties(below)}}assign values equal to the median to below
group{p_end}
{synopt :{cmdab:med:ianties(above)}}assign values equal to the median to above
group{p_end}
{synopt :{cmdab:med:ianties(drop)}}drop values equal to the median from the
analysis{p_end}
{synopt :{cmdab:med:ianties(split)}}split values equal to the median equally
between the two groups{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}* {opt by(groupvar)} is required.{p_end}
{p 4 6 2}{opt by} is allowed with {cmd:ranksum} and {cmd:median};
see {manhelp by D}.{p_end}
{marker weight}{...}
{p 4 6 2}{opt fweight}s are allowed with {cmd:median}; see 
{help weight}.{p_end}


{marker menu}{...}
{title:Menu}

    {title:ranksum}

{phang2}
{bf:Statistics > Nonparametric analysis > Tests of hypotheses >}
        {bf:Wilcoxon rank-sum test}

    {title:median}

{phang2}
{bf:Statistics > Nonparametric analysis > Tests of hypotheses >}
        {bf:K-sample equality-of-medians test}


{marker description}{...}
{title:Description}

{pstd}
{cmd:ranksum} tests the hypothesis that two independent samples (that is,
unmatched data) are from populations with the same distribution by using the
Wilcoxon rank-sum test, which is also known as the Mann-Whitney two-sample
statistic
({help ranksum##W1945:Wilcoxon 1945};
 {help ranksum##MW1947:Mann and Whitney 1947}).

{pstd}
{cmd:median} performs a nonparametric K-sample test on the equality of
medians.  It tests the null hypothesis that the K samples were drawn from
populations with the same median.  For two samples, the
chi-squared test statistic is computed both with and without a continuity
correction.

{pstd}
{cmd:ranksum} and {cmd:median} are for use with unmatched data.  For
equality tests on matched data, see {manhelp signrank R}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R ranksumQuickstart:Quick start}

        {mansection R ranksumRemarksandexamples:Remarks and examples}

        {mansection R ranksumMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_ranksum}{...}
{title:Options for ranksum}

{dlgtab:Main}

{phang}
{cmd:by(}{it:{help varlist:groupvar}}{cmd:)} is required.  It specifies the
name of the grouping variable.

{phang}
{opt exact} specifies that the exact p-value be computed in addition to the
approximate p-value.  The exact p-value is based on the actual randomization
distribution of the test statistic.  The approximate p-value is based on a
normal approximation to the randomization distribution.  By default, the exact
p-value is computed for sample sizes n = n_1 + n_2 {ul:<} 200 because the
normal approximation may not be precise in small samples.  The exact
computation can be suppressed by specifying {cmd:noexact}.  For sample sizes
larger than 200, you must specify {cmd:exact} to compute the exact p-value.
The exact computation is available for sample sizes n {ul:<} 1000.  As the
sample size approaches 1,000, the computation takes significantly longer.

{phang}
{opt porder} displays an estimate of the probability that a random draw from
the first population is larger than a random draw from the second 
population.


{marker options_median}{...}
{title:Options for median}

{dlgtab:Main}

{phang}
{cmd:by(}{it:{help varlist:groupvar}}{cmd:)} is required.  It specifies the
name of the grouping variable.

{phang}
{opt exact} displays the p-value calculated by Fisher's exact test.  For
two samples, both one- and two-sided p-values are shown.

{phang}
{cmd:medianties(below}|{opt above}|{opt drop}|{opt split)} specifies how
values equal to the overall median are to be handled.  The median test
computes the median for {varname} by using all observations and then divides
the observations into those falling above the median and those falling below
the median.  When values for an observation are equal to the sample median,
they can be dropped from the analysis by specifying {cmd:medianties(drop)};
added to the group above or below the median by specifying
{cmd:medianties(above)} or {cmd:medianties(below)}, respectively; or if there
is more than 1 observation with values equal to the median, they can be
equally divided into the two groups by specifying {cmd:medianties(split)}.  If
this option is not specified, {cmd:medianties(below)} is assumed.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse fuel2}{p_end}

{pstd}Perform rank-sum test on {cmd:mpg} by using the two groups defined by
{cmd:treat}{p_end}
{phang2}{cmd:. ranksum mpg, by(treat)}{p_end}

{pstd}Same as above, but include estimate of probability that the value of
{cmd:mpg} for an observation with {cmd:treat} = 0 is greater than the value of
{cmd:mpg} for an observation with {cmd:treat} = 1{p_end}
{phang2}{cmd:. ranksum mpg, by(treat) porder}{p_end}

{pstd}Perform Pearson chi-squared test of the equality of the medians of
{cmd:mpg} between the two groups defined by {cmd:treat}{p_end}
{phang2}{cmd:. median mpg, by(treat)}{p_end}

{pstd}Report p-value from Fisher's exact test of the equality of the medians
of {cmd:mpg} between the two groups defined by {cmd:treat}{p_end}
{phang2}{cmd:. median mpg, by(treat) exact}{p_end}

    {hline}
    Setup
{phang2}{cmd:. webuse medianxmpl}{p_end}

{pstd}Perform Pearson chi-squared test of the equality of the medians of
{cmd:age} between the two groups defined by {cmd:gender}{p_end}
{phang2}{cmd:. median age, by(gender)}{p_end}

{pstd}Same as above command{p_end}
{phang2}{cmd:. median age, by(gender) medianties(below)}{p_end}

{pstd}Same as above command, but for observations with values of {cmd:age}
equal to the median, put them in the group above the median{p_end}
{phang2}{cmd:. median age, by(gender) medianties(above)}{p_end}

{pstd}Same as above command, but drop observations with values of {cmd:age}
equal to the median{p_end}
{phang2}{cmd:. median age, by(gender) medianties(drop)}{p_end}

{pstd}Same as above command, but for observations with values of {cmd:age}
equal to the median, divide them equally between the two groups{p_end}
{phang2}{cmd:. median age, by(gender) medianties(split)}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:ranksum} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}sample size{p_end}
{synopt:{cmd:r(N_1)}}sample size of first group{p_end}
{synopt:{cmd:r(N_2)}}sample size of second group{p_end}
{synopt:{cmd:r(z)}}z statistic{p_end}
{synopt:{cmd:r(Var_a)}}adjusted variance{p_end}
{synopt:{cmd:r(group1)}}value of variable for first group{p_end}
{synopt:{cmd:r(sum_obs)}}observed sum of ranks for first group{p_end}
{synopt:{cmd:r(sum_exp)}}expected sum of ranks for first group{p_end}
{synopt:{cmd:r(p)}}two-sided p-value from normal approximation{p_end}
{synopt:{cmd:r(p_l)}}lower one-sided p-value from normal approximation{p_end}
{synopt:{cmd:r(p_u)}}upper one-sided p-value from normal approximation{p_end}
{synopt:{cmd:r(p_exact)}}two-sided exact p-value{p_end}
{synopt:{cmd:r(p_l_exact)}}lower one-sided exact p-value{p_end}
{synopt:{cmd:r(p_u_exact)}}upper one-sided exact p-value{p_end}
{synopt:{cmd:r(porder)}}probability that draw from first population is larger
              than draw from second population{p_end}

{pstd}
{cmd:median} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}sample size{p_end}
{synopt:{cmd:r(chi2)}}Pearson's chi-squared{p_end}
{synopt:{cmd:r(chi2_cc)}}continuity-corrected Pearson's chi-squared{p_end}
{synopt:{cmd:r(groups)}}number of groups compared{p_end}
{synopt:{cmd:r(p)}}p-value for Pearson's chi-squared test{p_end}
{synopt:{cmd:r(p_cc)}}continuity-corrected p-value{p_end}
{synopt:{cmd:r(p_exact)}}Fisher's exact p-value{p_end}
{synopt:{cmd:r(p1_exact)}}one-sided Fisher's exact p-value{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker MW1947}{...}
{phang}
Mann, H. B., and D. R. Whitney. 1947. On a test whether one of two random
variables is stochastically larger than the other.
{it:Annals of Mathematical Statistics} 18: 50-60.

{marker W1945}{...}
{phang}
Wilcoxon, F. 1945. Individual comparisons by ranking methods.
{it:Biometrics} 1: 80-83.
{p_end}
