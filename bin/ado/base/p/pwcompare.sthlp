{smcl}
{* *! version 1.1.16  05sep2018}{...}
{viewerdialog pwcompare "dialog pwcompare"}{...}
{vieweralsosee "[R] pwcompare" "mansection R pwcompare"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] pwcompare postestimation" "help pwcompare postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] contrast" "help contrast"}{...}
{vieweralsosee "[R] lincom" "help lincom"}{...}
{vieweralsosee "[R] margins" "help margins"}{...}
{vieweralsosee "[R] margins, pwcompare" "help margins_pwcompare"}{...}
{vieweralsosee "[R] pwmean" "help pwmean"}{...}
{vieweralsosee "[R] test" "help test"}{...}
{viewerjumpto "Syntax" "pwcompare##syntax"}{...}
{viewerjumpto "Menu" "pwcompare##menu"}{...}
{viewerjumpto "Description" "pwcompare##description"}{...}
{viewerjumpto "Links to PDF documentation" "pwcompare##linkspdf"}{...}
{viewerjumpto "Options" "pwcompare##options"}{...}
{viewerjumpto "Examples" "pwcompare##examples"}{...}
{viewerjumpto "Stored results" "pwcompare##results"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[R] pwcompare} {hline 2}}Pairwise comparisons {p_end}
{p2col:}({mansection R pwcompare:View complete PDF manual entry}){p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:pwcompare} {it:marginlist}
[{cmd:,}
	{it:{help pwcompare##options_table:options}}]

{pstd}
where {it:marginlist} is a list of factor variables or interactions that
appear in the current estimation results or {cmd:_eqns} to reference equations.  
The variables may be typed with or without the {cmd:i.} prefix, and you may use 
any factor-variable syntax:

		. {cmd:pwcompare i.sex i.group i.sex#i.group}

		. {cmd:pwcompare sex group sex#group}

		. {cmd:pwcompare sex##group}

{marker options_table}{...}
{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt mcomp:are}{cmd:(}{it:{help pwcompare##method:method}}{cmd:)}}adjust
    for multiple comparisons; default is {cmd:mcompare(noadjust)}{p_end}
{synopt:{opt asobs:erved}}treat all factor variables as observed{p_end}

{syntab:Equations}
{synopt:{opt eq:uation(eqspec)}}perform comparisons within equation 
    {it:eqspec}{p_end}
{synopt:{opt ateq:uations}}perform comparisons within each equation{p_end}

{syntab:Advanced}
{synopt:{opt emptycells}{cmd:(}{it:{help contrast##empspec:empspec}}{cmd:)}}treatment
	of empty cells for balanced factors{p_end}
{synopt:{opt noestimcheck}}suppress estimability checks{p_end}

{syntab:Reporting}
{synopt:{opt l:evel(#)}}confidence level; default is {cmd:level(95)}{p_end}
{synopt:{opt ci:effects}}show effects table with confidence intervals;
         the default{p_end}
{synopt:{opt pv:effects}}show effects table with p-values{p_end}
{synopt:{opt eff:ects}}show effects table with confidence intervals and p-values
     {p_end}
{synopt:{opt cim:argins}}show table of margins and confidence intervals{p_end}
{synopt:{opt group:s}}show table of margins and group codes{p_end}
{synopt:{opt sort}}sort the margins or contrasts within each term{p_end}
{synopt:{opt post}}post margins and their VCEs as estimation results{p_end}
{synopt:{it:{help pwcompare##display_options:display_options}}}control	
    column formats, row spacing, line width, and factor-variable labeling
    {p_end}
{synopt:{it:{help pwcompare##eform_option:eform_option}}}report exponentiated contrasts{p_end}

{synopt :{opt df(#)}}use t distribution with {it:#} degrees of freedom for
       computing p-values and confidence intervals{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt df(#)} does not appear in the dialog box.
{p_end}

{marker method}{...}
{synoptset 24 tabbed}{...}
{synopthdr:method}
{synoptline}
{synopt:{opt noadj:ust}}do not adjust for multiple comparisons; the default{p_end}
{synopt:{opt bon:ferroni} [{opt adjustall}]}Bonferroni's method; adjust across all terms{p_end}
{synopt:{opt sid:ak} [{opt adjustall}]}Sidak's method; adjust across all terms{p_end}
{synopt:{opt sch:effe}}Scheffe's method{p_end}
{p2coldent:+ {opt tuk:ey}}Tukey's method{p_end}
{p2coldent:+ {opt snk}}Student-Newman-Keuls's method{p_end}
{p2coldent:+ {opt dunc:an}}Duncan's method{p_end}
{p2coldent:+ {opt dunn:ett}}Dunnett's method{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
+ 
{opt tukey},
{opt snk},
{opt duncan},
and
{opt dunnett}
are only allowed with results from
{helpb anova},
{helpb manova},
{helpb regress},
and
{helpb mvreg}.
{opt tukey},
{opt snk},
{opt duncan},
and
{opt dunnett}
are not allowed with results from
{helpb svy}.
{p_end}

{p 4 6 2}
Time-series operators are allowed if they were used in the estimation.
{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Postestimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:pwcompare} performs pairwise comparisons across the levels of factor 
variables from the most recently fit model. {cmd:pwcompare} can compare 
estimated cell means, marginal means, intercepts, marginal intercepts, 
slopes, or marginal slopes -- collectively called margins. {cmd:pwcompare}
reports the comparisons as contrasts (differences) of margins along with
significance tests or confidence intervals for the contrasts. 
The tests and confidence intervals can be adjusted for multiple comparisons.

{pstd}
{cmd:pwcompare} can be used with {cmd:svy} estimation results; see
{manhelp svy_postestimation SVY:svy postestimation}.

{pstd}
See {manhelp margins_pwcompare R:margins, pwcompare} for performing pairwise 
comparisons of margins of linear and nonlinear predictions.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R pwcompareQuickstart:Quick start}

        {mansection R pwcompareRemarksandexamples:Remarks and examples}

        {mansection R pwcompareMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt mcompare(method)}
specifies the method for computing p-values and confidence intervals
that account for multiple comparisons within a factor-variable term.

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
distribution with degrees of freedom equal to the rank of the term.

{pmore}
For results from {helpb anova}, {helpb regress}, {helpb manova},
and {helpb mvreg}, {cmd:pwcompare} allows the following additional
methods.
These methods are not allowed with results that use
{cmd:vce(robust)} or
{cmd:vce(cluster} {it:clustvar}{cmd:)}.

{phang2}
{cmd:mcompare(tukey)} uses what is commonly referred to as Tukey's honestly
significant difference.
This method uses the Studentized range distribution instead of the t
distribution.

{phang2}
{cmd:mcompare(snk)} is a variation on {cmd:mcompare(tukey)} that counts only
the number of margins in the range for a given comparison
instead of the full number of margins.

{phang2}
{cmd:mcompare(duncan)} is a variation on {cmd:mcompare(snk)} with additional
adjustment to the significance probabilities.

{phang2}
{cmd:mcompare(dunnett)} uses Dunnett's method for making comparisons with a
reference category.

{phang2}
{cmd:mcompare(}{it:method} {cmd:adjustall)} specifies that the
multiple-comparison adjustments count all comparisons across all terms rather
than performing multiple comparisons term by term. This leads to more
conservative adjustments when multiple variables or terms are specified in
{it:marginlist}.  This option is compatible only with the {cmd:bonferroni} and
{cmd:sidak} methods.

{phang}
{opt asobserved}
specifies that factor covariates be evaluated using the cell frequencies
observed when the model was fit.  The default is to treat all factor
covariates as though there were an equal number of observations at each level.

{dlgtab:Equations}

{phang}
{opt equation(eqspec)}
specifies the equation from which margins are to be computed.  The default is
to compute margins from the first equation.

{phang}
{opt atequations}
specifies that the margins be computed within each equation.

{dlgtab:Advanced}

{marker empspec}{...}
{phang}
{opt emptycells(empspec)}
specifies how empty cells are handled in interactions involving factor
variables that are being treated as balanced.

{phang2}
{cmd:emptycells(strict)}
is the default; it specifies that margins involving empty cells be treated
as not estimable.

{phang2}
{cmd:emptycells(reweight)}
specifies that the effects of the observed cells be increased to accommodate
any missing cells.  This makes the margins estimable but changes their
interpretation.  

{phang}
{opt noestimcheck}
specifies that {cmd:pwcompare} not check for estimability.  By default, the
requested margins are checked and those found not estimable are reported as
such.  Nonestimability is usually caused by empty cells.  If
{cmd:noestimcheck} is specified, estimates are computed in the usual way and
reported even though the resulting estimates are manipulable, which is to say
they can differ across equivalent models having different parameterizations.

{dlgtab:Reporting}

{phang}
{opt level(#)};
specifies the confidence level, as a percentage, for confidence intervals.
The default is {cmd:level(95)} or as set by {helpb set level}.
The significance level used by the {opt groups} option is 100-{it:#},
expressed as a percentage.

{phang} 
{opt cieffects} 
specifies that a table of the pairwise comparisons with their standard errors
and confidence intervals be reported.  This is the default.

{phang} 
{opt pveffects} 
specifies that a table of the pairwise comparisons with their standard errors,
test statistics, and p-values be reported.

{phang}
{opt effects}
specifies that a table of the pairwise comparisons with their standard 
errors, test statistics, p-values, and confidence intervals be reported.

{phang} 
{opt cimargins} 
specifies that a table of the margins with their standard errors and
confidence intervals be reported.

{phang}
{opt groups} 
specifies that a table of the margins with their standard errors and
group codes be reported.
Margins with the same letter in the group code are not significantly different
at the specified significance level.

{phang}
{opt sort} 
specifies that the reported tables be sorted on the margins or differences in
each term.

{phang} 
{opt post} 
causes {cmd:pwcompare} to behave like a Stata estimation (e-class) command.
{cmd:pwcompare} posts the vector of estimated margins along with the
estimated variance-covariance matrix to {cmd:e()}, so you can treat the
estimated margins just as you would results from any other estimation
command.  For example, you could use {cmd:test} to perform simultaneous tests 
of hypotheses on the margins, or you could use {cmd:lincom} to create linear 
combinations.

{marker display_options}{...}
{phang}
{it:display_options}:
{opt vsquish},
{opt nofvlab:el},
{opt fvwrap(#)},
{opt fvwrapon(style)},
{opth cformat(%fmt)},
{opt pformat(%fmt)},
{opt sformat(%fmt)}, and
{opt nolstretch}.

{phang2}
{opt vsquish} 
specifies that the blank space separating factor-variable terms or
time-series-operated variables from other variables in the model be suppressed.

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
{opt cformat(%fmt)} specifies how to format contrasts or margins, standard
errors, and confidence limits in the table of pairwise comparisons.

{phang2}
{opt pformat(%fmt)} specifies how to format p-values in the table of pairwise
comparisons.

{phang2}
{opt sformat(%fmt)} specifies how to format test statistics in the 
table of pairwise comparisons.

{phang2}
{opt nolstretch} specifies that the width of the table of pairwise comparisons
not be automatically widened to accommodate longer variable names. The default,
{cmd:lstretch}, is to automatically widen the table of pairwise comparisons
up to the width of the Results window.  To change the default, use
{helpb lstretch:set lstretch off}. {opt nolstretch} is not shown in the
dialog box.
{p_end}

{marker eform_option}{...}
{phang}
{it:eform_option} specifies that the contrasts table be displayed in
exponentiated form.  exp(contrast) is displayed rather than
contrast.  Standard errors and confidence intervals are also
transformed.  See {manhelpi eform_option R} for the list of available
options.

{pstd}
The following option is available with {opt pwcompare} but is not shown in the
dialog box:

{phang}
{opt df(#)} specifies that the t distribution with {it:#} degrees of
freedom be used for computing p-values and confidence intervals.
The default is to use {cmd:e(df_r)} degrees of freedom or the standard normal
distribution if {cmd:e(df_r)} is missing.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup for a one-way model{p_end}
{phang2}{cmd:. webuse yield}{p_end}
{phang2}{cmd:. regress yield i.fertilizer}{p_end}

{pstd}Mean yield for each fertilizer{p_end}
{phang2}{cmd:. pwcompare fertilizer, cimargins}{p_end}

{pstd}Pairwise comparisons of mean yields{p_end}
{phang2}{cmd:. pwcompare fertilizer}{p_end}

{pstd}Pairwise comparisons using Duncan's adjustment for the p-values and
confidence intervals{p_end}
{phang2}{cmd:. pwcompare fertilizer, effects mcompare(duncan)}{p_end}

{pstd}Setup for a two-way model{p_end}
{phang2}{cmd:. regress yield fertilizer##irrigation}{p_end}

{pstd}Pairwise comparisons of the cell means with group codes denoting means
that are not significantly different based on Tukey's honestly
significant difference{p_end}
{phang2}{cmd:. pwcompare fertilizer#irrigation, group mcompare(tukey)}{p_end}

{pstd}Setup for continuous covariate{p_end}
{phang2}{cmd:. regress yield fertilizer##c.N03_N}{p_end}

{pstd}Pairwise comparisons of slopes for each fertilizer with confidence
intervals adjusted based on Scheffe's method{p_end}
{phang2}{cmd:. pwcompare fertilizer#c.N03_N, mcompare(scheffe)}{p_end}

    {hline}
{pstd}Setup for nonlinear model{p_end}
{phang2}{cmd:. webuse hospital}{p_end}
{phang2}{cmd:. logit satisfied i.hospital}{p_end}

{pstd}Pairwise comparisons of the log odds using Bonferroni's
adjustment{p_end}
{phang2}{cmd:. pwcompare hospital, mcompare(bonferroni)}{p_end}

    {hline}
{pstd}Setup for multiple-equation model{p_end}
{phang2}{cmd:. webuse jaw}{p_end}
{phang2}{cmd:. mvreg y1 y2 y3 = i.fracture}{p_end}

{pstd}Pairwise comparisons of the margins for fracture in the first
equation{p_end}
{phang2}{cmd:. pwcompare fracture}{p_end}

{pstd}Pairwise comparisons of the margins for fracture within each
equation{p_end}
{phang2}{cmd:. pwcompare fracture, atequations}{p_end}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:pwcompare} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(df_r)}}variance degrees of freedom{p_end}
{synopt:{cmd:r(k_terms)}}number of terms in {it:marginlist}{p_end}
{synopt:{cmd:r(level)}}confidence level of confidence intervals{p_end}
{synopt:{cmd:r(balanced)}}{cmd:1} if fully balanced data, {cmd:0} otherwise{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(cmd)}}{cmd:pwcompare}{p_end}
{synopt:{cmd:r(cmdline)}}command as typed{p_end}
{synopt:{cmd:r(est_cmd)}}{cmd:e(cmd)} from original estimation results{p_end}
{synopt:{cmd:r(est_cmdline)}}{cmd:e(cmdline)} from original estimation 
    results{p_end}
{synopt:{cmd:r(title)}}title in output{p_end}
{synopt:{cmd:r(emptycells)}}{it:empspec} from {cmd:emptycells()}{p_end}
{synopt:{cmd:r(groups}{it:#}{cmd:)}}group codes for the {it:#}th margin in
	{cmd:r(b)}{p_end}
{synopt:{cmd:r(mcmethod_vs)}}{it:method} from {opt mcompare()}{p_end}
{synopt:{cmd:r(mctitle_vs)}}title for {it:method} from {opt mcompare()}{p_end}
{synopt:{cmd:r(mcadjustall_vs)}}{cmd:adjustall} or empty{p_end}
{synopt:{cmd:r(margin_method)}}{cmd:asbalanced} or {cmd:asobserved}{p_end}
{synopt:{cmd:r(vce)}}{it:vcetype} specified in {opt vce()} in original estimation 
    command{p_end}

{p2col 5 20 24 2:Matrices}{p_end}
{synopt:{cmd:r(b)}}margin estimates{p_end}
{synopt:{cmd:r(V)}}variance-covariance matrix of the margin estimates{p_end}
{synopt:{cmd:r(error)}}margin estimability codes;{break}
	{cmd:0} means estimable,{break}
	{cmd:8} means not estimable{p_end}
{synopt:{cmd:r(table)}}matrix
	containing the margins with their standard errors, test statistics,
	p-values, and confidence intervals{p_end}
{synopt:{cmd:r(M)}}matrix
	that produces margins from the model coefficients{p_end}
{synopt:{cmd:r(b_vs)}}margin difference estimates{p_end}
{synopt:{cmd:r(V_vs)}}variance-covariance
	matrix of the margin difference estimates{p_end}
{synopt:{cmd:r(error_vs)}}margin difference estimability codes;{break}
	{cmd:0} means estimable,{break}
	{cmd:8} means not estimable{p_end}
{synopt:{cmd:r(table_vs)}}matrix
	containing the margin differences with their standard errors, test
	statistics, p-values, and confidence intervals{p_end}
{synopt:{cmd:r(L)}}matrix
	that produces the margin differences from the model
	coefficients{p_end}
{synopt:{cmd:r(k_groups)}}number of significance groups for each term{p_end}
{p2colreset}{...}


{pstd}
{cmd:pwcompare} with the {opt post} option also stores the following in
{cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(df_r)}}variance degrees of freedom{p_end}
{synopt:{cmd:e(k_terms)}}number of terms in {it:marginlist}{p_end}
{synopt:{cmd:e(balanced)}}{cmd:1} if fully balanced data, {cmd:0} otherwise{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:pwcompare}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(est_cmd)}}{cmd:e(cmd)} from original estimation results{p_end}
{synopt:{cmd:e(est_cmdline)}}{cmd:e(cmdline)} from original estimation results{p_end}
{synopt:{cmd:e(title)}}title in output{p_end}
{synopt:{cmd:e(emptycells)}}{it:empspec} from {cmd:emptycells()}{p_end}
{synopt:{cmd:e(margin_method)}}{cmd:asbalanced} or {cmd:asobserved}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {opt vce()} in original estimation command{p_end}

{p2col 5 20 24 2:Matrices}{p_end}
{synopt:{cmd:e(b)}}margin estimates{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the margin estimates{p_end}
{synopt:{cmd:e(error)}}margin estimability codes;{break}
	{cmd:0} means estimable,{break}
	{cmd:8} means not estimable{p_end}
{synopt:{cmd:e(M)}}matrix
	that produces margins from the model coefficients{p_end}
{synopt:{cmd:e(b_vs)}}margin difference estimates{p_end}
{synopt:{cmd:e(V_vs)}}variance-covariance
	matrix of the margin difference estimates{p_end}
{synopt:{cmd:e(error_vs)}}margin difference estimability codes;{break}
	{cmd:0} means estimable,{break}
	{cmd:8} means not estimable{p_end}
{synopt:{cmd:e(L)}}matrix
	that produces the margin differences from the model
	coefficients{p_end}
{p2colreset}{...}
