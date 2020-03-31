{smcl}
{* *! version 1.0.21  03feb2020}{...}
{viewerdialog pwmean "dialog pwmean"}{...}
{vieweralsosee "[R] pwmean" "mansection R pwmean"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] pwmean postestimation" "help pwmean postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] contrast" "help contrast"}{...}
{vieweralsosee "[R] margins" "help margins"}{...}
{vieweralsosee "[R] margins, pwcompare" "help margins_pwcompare"}{...}
{vieweralsosee "[R] pwcompare" "help pwcompare"}{...}
{vieweralsosee "[R] ttest" "help ttest"}{...}
{viewerjumpto "Syntax" "pwmean##syntax"}{...}
{viewerjumpto "Menu" "pwmean##menu"}{...}
{viewerjumpto "Description" "pwmean##description"}{...}
{viewerjumpto "Links to PDF documentation" "pwmean##linkspdf"}{...}
{viewerjumpto "Options" "pwmean##options"}{...}
{viewerjumpto "Examples" "pwmean##examples"}{...}
{viewerjumpto "Stored results" "pwmean##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[R] pwmean} {hline 2}}Pairwise comparisons of means
{p_end}
{p2col:}({mansection R pwmean:View complete PDF manual entry}){p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:pwmean} {varname} {ifin}{cmd:,} {opth over(varlist)} [{it:options}]

{marker options_table}{...}
{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{p2coldent :* {cmd:over(}{it:{help varlist}}{cmd:)}}compare means across each 
combination of the levels in {it:varlist}{p_end}
{synopt:{opt mcomp:are}{cmd:(}{it:{help pwmean##method:method}}{cmd:)}}adjust 
    for multiple comparisons; default is {cmd:mcompare(noadjust)}{p_end}

{syntab:Reporting}
{synopt:{opt l:evel(#)}}confidence level; default is {cmd:level(95)}{p_end}
{synopt:{opt ci:effects}}display a table of mean differences and confidence 
    intervals; the default{p_end}
{synopt:{opt pv:effects}}display a table of mean differences and p-values{p_end}
{synopt:{opt eff:ects}}display a table of mean differences with p-values and 
    confidence intervals{p_end}
{synopt:{opt cim:eans}}display a table of means and confidence intervals{p_end}
{synopt:{opt group:s}}display a table of means with codes that group them with
other means that are not significantly different{p_end}
{synopt:{opt sort}}sort results tables by displayed mean or difference{p_end}
{synopt :{it:{help pwmean##display_options:display_options}}}control
    column formats, line width, and factor-variable labeling{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}*{opt over(varlist)} is required.{p_end}
{p 4 6 2}
See {manhelp pwmean_postestimation R:pwmean postestimation} for features
available after estimation.  {p_end}

{marker method}{...}
{synoptset 22}{...}
{synopthdr:method}
{synoptline}
{synopt:{opt noadj:ust}}do not adjust for multiple comparisons; the default{p_end}
{synopt:{opt bon:ferroni}}Bonferroni's method{p_end}
{synopt:{opt sid:ak}}Sidak's method{p_end}
{synopt:{opt sch:effe}}Scheffe's method{p_end}
{synopt:{opt tuk:ey}}Tukey's method{p_end}
{synopt:{opt snk}}Student-Newman-Keuls's method{p_end}
{synopt:{opt dunc:an}}Duncan's method{p_end}
{synopt:{opt dunn:ett}}Dunnett's method{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Summaries, tables, and tests >}
{bf:Summary and descriptive statistics > Pairwise comparisons of means}


{marker description}{...}
{title:Description}

{pstd}
{cmd:pwmean} performs pairwise comparisons of means. It computes all pairwise
differences of the means of {varname} over the combination of the levels of the 
variables in {varlist}.  The tests and confidence intervals for the 
pairwise comparisons assume equal variances across 
groups.  {cmd:pwmean} also allows for adjusting the confidence intervals and 
p-values to account for multiple comparisons using Bonferroni's method, 
Scheffe's method, Tukey's method, Dunnett's method, and others.

{pstd}
See {manhelp pwcompare R:pwcompare} for performing pairwise comparisons of 
means, estimated marginal means, and other types of marginal linear 
predictions after {helpb anova}, {helpb regress}, and most other estimation
commands.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R pwmeanQuickstart:Quick start}

        {mansection R pwmeanRemarksandexamples:Remarks and examples}

        {mansection R pwmeanMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth over(varlist)} is required and 
specifies that the means are computed for each combination of the levels of
the variables in {it:varlist}.

{phang}
{opt mcompare(method)} 
specifies the method for computing p-values and confidence intervals
that account for multiple comparisons.

{pmore}
Most methods adjust the comparisonwise error rate, alpha_c, to
achieve a prespecified experimentwise error rate, alpha_e.

{phang2}
{cmd:mcompare(noadjust)}
is the default; it specifies no adjustment.

{center: alpha_c = alpha_e}

{phang2}
{cmd:mcompare(bonferroni)}
adjusts the comparisonwise error rate based on the upper limit of the
Bonferroni inequality:

{center: alpha_e <= m * alpha_c}

{pmore2}
where m is the number of comparisons within the term.

{pmore2}
The adjusted comparisonwise error rate is

{center: alpha_c = alpha_e/m}

{phang2}
{cmd:mcompare(sidak)}
adjusts the comparisonwise error rate based on the upper limit of the
probability inequality

{center:alpha_e <= 1 - (1 - alpha_c)^m}

{pmore2}
where m is the number of comparisons within the term.

{pmore2}
The adjusted comparisonwise error rate is

{center:alpha_c = 1 - (1 - alpha_e)^(1/m)}

{pmore2}
This adjustment is exact when the m comparisons are independent.

{phang2}
{cmd:mcompare(scheffe)}
controls the experimentwise error rate using the F (or chi-squared)
distribution with degrees of freedom equal to k-1 where k is the 
number of means being compared.

{phang2}
{cmd:mcompare(tukey)} uses what is commonly referred to as Tukey's honestly
significant difference.
This method uses the Studentized range distribution instead of the t
distribution.

{phang2}
{cmd:mcompare(snk)} is a variation on {cmd:mcompare(tukey)} that counts only
the number of means participating in the range for a given comparison
instead of the full number of means.

{phang2}
{cmd:mcompare(duncan)} is a variation on {cmd:mcompare(snk)} with additional
adjustment to the significance probabilities.

{phang2}
{cmd:mcompare(dunnett)} uses Dunnett's method for making comparisons with a
reference category.

{dlgtab:Reporting}

{phang}
{opt level(#)}
specifies the confidence level, as a percentage, for confidence intervals.
The default is {cmd:level(95)} or as set by {helpb set level}.
The significance level used by the {opt groups} option is 100-{it:#},
expressed as a percentage.

{phang} 
{opt cieffects} 
specifies that a table of the pairwise comparisons of means with their standard
errors and confidence intervals be reported.  This is the default.

{phang} 
{opt pveffects} 
specifies that a table of the pairwise comparisons of means with their standard
errors, test statistics, and p-values be reported.

{phang}
{opt effects}
specifies that a table of the pairwise comparisons of means with their
standard errors, test statistics, p-values, and confidence intervals be
reported.

{phang} 
{opt cimeans} 
specifies that a table of the means with their standard errors and
confidence intervals be reported.

{phang}
{opt groups} 
specifies that a table of the means with their standard errors and
group codes be reported.
Means with the same letter in the group code are not significantly different
at the specified significance level.

{phang}
{opt sort} 
specifies that the reported tables be sorted by the mean or difference that is
displayed in the table.

{marker display_options}{...}
{phang}
{it:display_options}:
{opt nofvlab:el},
{opt fvwrap(#)},
{opt fvwrapon(style)},
{opth cformat(%fmt)},
{opt pformat(%fmt)},
{opt sformat(%fmt)}, and
{opt nolstretch}.

{phang2}
{opt nofvlabel} displays factor-variable level values rather than attached value
labels.  This option overrides the {cmd:fvlabel} setting; see 
{helpb set showbaselevels:[R] set showbaselevels}.

{phang2}
{opt fvwrap(#)} specifies how many lines to allow when long value labels must be
wrapped.  Labels requiring more than {it:#} lines are truncated.  This option
overrides the {cmd:fvwrap} setting; see
{helpb set showbaselevels:[R] set showbaselevels}.

{phang2}
{opt fvwrapon(style)} specifies whether value labels that wrap will break
at word boundaries or break based on available space.

{phang3}
{cmd:fvwrapon(word)}, the default, specifies that value labels break at
word boundaries.

{phang3}
{cmd:fvwrapon(width)} specifies that value labels break based on available
space.

{pmore2}
This option overrides the {cmd:fvwrapon} setting; see
{helpb set showbaselevels:[R] set showbaselevels}.

{phang2}
{opt cformat(%fmt)} specifies how to format means, standard errors, and
confidence limits in the table of pairwise comparison of means.

{phang2}
{opt pformat(%fmt)} specifies how to format p-values in the table of pairwise
comparison of means.

{phang2}
{opt sformat(%fmt)} specifies how to format test statistics in the 
table of pairwise comparison of means.

{phang2}
{opt nolstretch} specifies that the width of the table of pairwise comparisons
not be automatically widened to accommodate longer variable names. The default,
{cmd:lstretch}, is to automatically widen the table of pairwise comparisons
up to the width of the Results window.  To change the default, use
{helpb lstretch:set lstretch off}. {opt nolstretch} is not shown in the
dialog box.
{p_end}


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse yield}{p_end}

{pstd}Mean yield for each fertilizer{p_end}
{phang2}{cmd:. pwmean yield, over(fertilizer) cimeans}{p_end}

{pstd}Pairwise comparisons of mean yields for the fertilizers{p_end}
{phang2}{cmd:. pwmean yield, over(fertilizer) effects}{p_end}

{pstd}Pairwise comparisons of the mean yields using Tukey's adjustment for
multiple comparisons when computing p-values{p_end}
{phang2}{cmd:. pwmean yield, over(fertilizer) pveffects mcompare(tukey)}{p_end}

{pstd}Comparisons of the mean yield for each fertilizer to the control
(fertilizer 1) using Dunnett's adjustment{p_end}
{phang2}
{cmd:. pwmean yield, over(fertilizer) effects mcompare(dunnett)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:pwmean} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(df_r)}}variance degrees of freedom{p_end}
{synopt:{cmd:e(balanced)}}{cmd:1} if fully balanced data, {cmd:0} otherwise{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:pwmean}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(title)}}title in output{p_end}
{synopt:{cmd:e(depvar)}}name of variable from which the means are computed{p_end}
{synopt:{cmd:e(over)}}{it:varlist} from {opt over()}{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}

{p2col 5 20 24 2:Matrices}{p_end}
{synopt:{cmd:e(b)}}mean estimates{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the mean estimates{p_end}
{synopt:{cmd:e(error)}}mean estimability codes;{break}
	{cmd:0} means estimable,{break}
	{cmd:8} means not estimable{p_end}
{synopt:{cmd:e(b_vs)}}mean difference estimates{p_end}
{synopt:{cmd:e(V_vs)}}variance-covariance
	matrix of the mean difference estimates{p_end}
{synopt:{cmd:e(error_vs)}}mean difference estimability codes;{break}
	{cmd:0} means estimable,{break}
	{cmd:8} means not estimable{p_end}
{p2colreset}{...}
