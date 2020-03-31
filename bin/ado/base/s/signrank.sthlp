{smcl}
{* *! version 1.1.11  22may2019}{...}
{viewerdialog signrank "dialog signrank"}{...}
{viewerdialog signtest "dialog signtest"}{...}
{vieweralsosee "[R] signrank" "mansection R signrank"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ranksum" "help ranksum"}{...}
{vieweralsosee "[R] ttest" "help ttest"}{...}
{viewerjumpto "Syntax" "signrank##syntax"}{...}
{viewerjumpto "Menu" "signrank##menu"}{...}
{viewerjumpto "Description" "signrank##description"}{...}
{viewerjumpto "Links to PDF documentation" "signrank##linkspdf"}{...}
{viewerjumpto "Option for signrank" "signrank##option_signrank"}{...}
{viewerjumpto "Examples" "signrank##examples"}{...}
{viewerjumpto "Stored results" "signrank##results"}{...}
{viewerjumpto "References" "signrank##references"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[R] signrank} {hline 2}}Equality tests on matched data{p_end}
{p2col:}({mansection R signrank:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Wilcoxon matched-pairs signed-rank test

{p 8 20 2} 
{cmd:signrank} {varname} {cmd:=} {it:{help exp}} {ifin} [{cmd:,} {cmd:exact}]


{phang}
Sign test of matched pairs

{p 8 20 2}
{cmd:signtest} {varname} {cmd:=} {it:{help exp}} {ifin} 


{phang}
{cmd:by} is allowed with {cmd:signrank} and {cmd:signtest}; see
{manhelp by D}. 


{marker menu}{...}
{title:Menu}

    {title:signrank}

{phang2}
{bf:Statistics > Nonparametric analysis > Tests of hypotheses >}
     {bf:Wilcoxon matched-pairs signed-rank test}

     {title:signtest}

{phang2}
{bf:Statistics > Nonparametric analysis > Tests of hypotheses >}
       {bf:Test equality of matched pairs}


{marker description}{...}
{title:Description}

{pstd}
{cmd:signrank} tests the equality of matched pairs of observations by using the
Wilcoxon matched-pairs signed-rank test
({help signrank##W1945:Wilcoxon 1945}).  The null hypothesis
is that both distributions are the same.

{pstd}
{cmd:signtest} also tests the equality of matched pairs of observations
({help signrank##A1710:Arbuthnott [1710]}, but better explained by
{help signrank##SC1989:Snedecor and Cochran [1989]}) by
calculating the differences between {varname} and the expression.  The null
hypothesis is that the median of the differences is zero; no further
assumptions are made about the distributions.  This, in turn, is equivalent to
the hypothesis that the true proportion of positive (negative) signs is
one-half.

{pstd}
For equality tests on unmatched data, see {manhelp ranksum R}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R signrankQuickstart:Quick start}

        {mansection R signrankRemarksandexamples:Remarks and examples}

        {mansection R signrankMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker option_signrank}{...}
{title:Option for signrank}

{dlgtab:Main}

{phang}
{cmd:exact} specifies that the exact p-value be computed in addition to the
approximate p-value.  The exact p-value is based on the actual randomization
distribution of the test statistic.  The approximate p-value is based on a
normal approximation to the randomization distribution.  By default, the exact
p-value is computed for sample sizes n {ul:<} 200 because the normal
approximation may not be precise in small samples.  The exact computation can
be suppressed by specifying {cmd:noexact}.  For sample sizes larger than 200,
you must specify {cmd:exact} to compute the exact p-value.  The exact
computation is available for sample sizes n {ul:<} 2000.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. webuse fuel}{p_end}
{phang}{cmd:. signrank mpg1 = mpg2}{p_end}
{phang}{cmd:. signtest mpg1 = mpg2}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:signrank} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}sample size{p_end}
{synopt:{cmd:r(N_pos)}}number of positive comparisons{p_end}
{synopt:{cmd:r(N_neg)}}number of negative comparisons{p_end}
{synopt:{cmd:r(N_tie)}}number of tied comparisons{p_end}
{synopt:{cmd:r(z)}}z statistic{p_end}
{synopt:{cmd:r(Var_a)}}adjusted variance{p_end}
{synopt:{cmd:r(sum_pos)}}sum of the positive ranks{p_end}
{synopt:{cmd:r(sum_neg)}}sum of the negative ranks{p_end}
{synopt:{cmd:r(p)}}two-sided p-value from normal approximation{p_end}
{synopt:{cmd:r(p_l)}}lower one-sided p-value from normal approximation{p_end}
{synopt:{cmd:r(p_u)}}upper one-sided p-value from normal approximation{p_end}
{synopt:{cmd:r(p_exact)}}two-sided exact p-value{p_end}
{synopt:{cmd:r(p_l_exact)}}lower one-sided exact p-value{p_end}
{synopt:{cmd:r(p_u_exact)}}upper one-sided exact p-value{p_end}

{pstd}
{cmd:signtest} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}sample size{p_end}
{synopt:{cmd:r(N_pos)}}number of positive comparisons{p_end}
{synopt:{cmd:r(N_neg)}}number of negative comparisons{p_end}
{synopt:{cmd:r(N_tie)}}number of tied comparisons{p_end}
{synopt:{cmd:r(p)}}two-sided p-value{p_end}
{synopt:{cmd:r(p_l)}}lower one-sided p-value{p_end}
{synopt:{cmd:r(p_u)}}upper one-sided p-value{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker A1710}{...}
{phang}
Arbuthnott, J. 1710. An argument for divine providence, taken from the
constant regularity observed in the births of both sexes.
{it:Philosophical Transaction of the Royal Society of London} 27: 186-190.

{marker SC1989}{...}
{phang}
Snedecor, G. W., and W. G. Cochran. 1989. {it:Statistical Methods}. 8th ed.
Ames, IA: Iowa State University Press.

{marker W1945}{...}
{phang}
Wilcoxon, F. 1945. Individual comparisons by ranking methods.
{it:Biometrics} 1: 80-83.
{p_end}
