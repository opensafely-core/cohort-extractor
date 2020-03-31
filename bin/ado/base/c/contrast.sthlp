{smcl}
{* *! version 1.3.4  05sep2018}{...}
{viewerdialog contrast "dialog contrast"}{...}
{vieweralsosee "[R] contrast" "mansection R contrast"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] contrast postestimation" "help contrast postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] lincom" "help lincom"}{...}
{vieweralsosee "[R] margins" "help margins"}{...}
{vieweralsosee "[R] margins, contrast" "help margins contrast"}{...}
{vieweralsosee "[R] pwcompare" "help pwcompare"}{...}
{vieweralsosee "[R] test" "help test"}{...}
{viewerjumpto "Syntax" "contrast##syntax"}{...}
{viewerjumpto "Menu" "contrast##menu"}{...}
{viewerjumpto "Description" "contrast##description"}{...}
{viewerjumpto "Links to PDF documentation" "contrast##linkspdf"}{...}
{viewerjumpto "Options" "contrast##options"}{...}
{viewerjumpto "Examples" "contrast##examples"}{...}
{viewerjumpto "Video example" "contrast##video"}{...}
{viewerjumpto "Stored results" "contrast##results"}{...}
{p2colset 4 17 19 2}{...}
{p2col:{bf:[R] contrast}}{hline 2} Contrasts and linear hypothesis tests
after estimation
{p_end}
{p2col:}({mansection R contrast:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:contrast} {it:termlist}
[{cmd:,}
	{it:{help contrast##options_table:options}}]

{pstd}
where {it:termlist} is a list of factor variables or interactions that
appear in the current estimation results.  The variables may be typed 
with or without {help contrast##operators:contrast operators}, and you may use
any {help fvvarlist:factor-variable syntax}.

{pstd}
See the {it:{help contrast##operators:operators (op.)}} table below for the
list of contrast operators.

{marker options_table}{...}
{synoptset 23 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt over:all}}add
	a joint hypothesis test for all specified contrasts{p_end}
{synopt:{opt asobs:erved}}treat all factor variables as observed{p_end}
{synopt:{opt lincom}}treat user-defined contrasts as linear combinations{p_end}

{syntab:Equations}
{synopt:{opt eq:uation(eqspec)}}perform
	contrasts in {it:termlist} for equation {it:eqspec}{p_end}
{synopt:{opt ateq:uations}}perform
	contrasts in {it:termlist} within each equation{p_end}

{syntab:Advanced}
{synopt:{opt emptycells}{cmd:(}{it:{help contrast##empspec:empspec}{cmd:)}}}treatment of empty cells for balanced
factors{p_end}
{synopt:{opt noestimcheck}}suppress estimability
	checks{p_end}

{syntab:Reporting}
{synopt:{opt l:evel(#)}}confidence level; default is {cmd:level(95)}{p_end}
{synopt:{opth mcomp:are(contrast##method:method)}}adjust for multiple
	comparisons; default is {cmd:mcompare(noadjust)}{p_end}
{synopt:{opt noeff:ects}}suppress table of individual contrasts{p_end}
{synopt:{opt ci:effects}}show effects table with confidence intervals{p_end}
{synopt:{opt pv:effects}}show effects table with p-values{p_end}
{synopt:{opt eff:ects}}show effects table with confidence intervals and p-values
	{p_end}
{synopt:{opt nowald}}suppress table of Wald tests{p_end}
{synopt:{opt noatlev:els}}report
	only the overall Wald test for terms that use the within {cmd:@} or
	nested {cmd:|} operator{p_end}
{synopt:{opt nosvy:adjust}}compute unadjusted Wald tests for survey results
	{p_end}
{synopt:{opt sort}}sort the individual contrast values in each term{p_end}
{synopt:{opt post}}post contrasts and their VCEs as estimation results{p_end}
{synopt :{it:{help contrast##display_options:display_options}}}control
       column formats, row spacing, line width, and factor-variable labeling
       {p_end}
{synopt:{it:{help contrast##eform_option:eform_option}}}report exponentiated contrasts{p_end}

{synopt :{opt df(#)}}use t distribution with {it:#} degrees of freedom for
       computing p-values and confidence intervals{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt df(#)} does not appear in the dialog box.
{p_end}

{marker term}{...}
{synoptset 23 tabbed}{...}
{p2col 5 30 32 2:Term}Description{p_end}
{synoptline}
{syntab:Main effects}
{synopt:{cmd:A}}joint test of the main effects of {cmd:A}{p_end}
{synopt:{it:r.}{cmd:A}}individual contrasts that decompose {cmd:A}
    using {it:r.}{p_end}
	
{syntab:Interaction effects}
{synopt:{cmd:A#B}}joint test of the two-way interaction effects of 
    {cmd:A} and {cmd:B}{p_end}
{synopt:{cmd:A#B#C}}joint test of the three-way interaction effects 
    of {cmd:A}, {cmd:B}, and {cmd:C}{p_end}
{synopt:{it:r.}{cmd:A#}{it:g.}{cmd:B}}individual contrasts for each 
    interaction of {cmd:A} and {cmd:B} defined by {it:r.} and 
	{it:g.}{p_end}
	
{syntab:Partial interaction effects}
{synopt:{it:r.}{cmd:A#B}}joint tests of interactions of {cmd:A} and
    {cmd:B} within each contrast defined by {it:r.}{cmd:A}{p_end}
{synopt:{cmd:A#}{it:r.}{cmd:B}}joint tests of interactions of {cmd:A}
    and {cmd:B} within each contrast defined by {it:r.}{cmd:B}{p_end}
	
{syntab:Simple effects}
{synopt:{cmd:A@B}}joint tests of the effects of {cmd:A} within each level
    of {cmd:B}{p_end}
{synopt:{cmd:A@B#C}}joint tests of the effects of {cmd:A} within each 
    combination of the levels of {cmd:B} and {cmd:C}{p_end}
{synopt:{it:r.}{cmd:A@B}}individual contrasts of {cmd:A} that decompose
    {cmd:A@B} using {it:r.}{p_end}
{synopt:{it:r.}{cmd:A@B#C}}individual contrasts of {cmd:A} that decompose
    {cmd:A@B#C} using {it:r.}{p_end}
	
{syntab:Other conditional effects}
{synopt:{cmd:A#B@C}}joint tests of the interaction effects of {cmd:A} and
    {cmd:B} within each level of {cmd:C}{p_end}
{synopt:{cmd:A#B@C#D}}joint tests of the interaction effects of {cmd:A} and
    {cmd:B} within each combination of the levels of {cmd:C} and
	{cmd:D}{p_end}
{synopt:{it:r.}{cmd:A#}{it:g.}{cmd:B@C}}individual contrasts for each 
    interaction of {cmd:A} and {cmd:B} that decompose {cmd:A#B@C}
	using {it:r.} and {it:g.}

{syntab:Nested effects}
{synopt:{cmd:A|B}}joint tests of the effects of {cmd:A} nested in each 
    level of {cmd:B}{p_end}
{synopt:{cmd:A|B#C}}joint tests of the effects of {cmd:A} nested in each
    combination of the levels of {cmd:B} and {cmd:C}{p_end}
{synopt:{cmd:A#B|C}}joint tests of the interaction effects of {cmd:A} and
    {cmd:B} nested in each level of {cmd:C}{p_end}
{synopt:{cmd:A#B|C#D}}joint tests of the interaction effects of {cmd:A}
    and {cmd:B} nested in each combination of the levels of {cmd:C}
	and {cmd:D}{p_end}
{synopt:{it:r.}{cmd:A|B}}individual contrasts of {cmd:A} that decompose
    {cmd:A|B} using {it:r.}{p_end}
{synopt:{it:r.}{cmd:A|B#C}}individual contrasts of {cmd:A} that decompose
    {cmd:A|B#C} using {it:r.}{p_end}
{synopt:{it:r.}{cmd:A#}{it:g.}{cmd:B|C}}individual contrasts for each
    interaction of {cmd:A} and {cmd:B} defined by {it:r.} and {it:g.} nested in
    each level of {cmd:C}{p_end}
	
{syntab:Slope effects}
{synopt:{cmd:A#}{cmd:c.}{cmd:x}}joint test of the effects of {cmd:A} on the 
    slopes of {cmd:x}{p_end}
{synopt:{cmd:A#}{cmd:c.}{cmd:x#}{cmd:c.}{cmd:y}}joint test of the effects of
    {cmd:A} on the slopes of the product (interaction) of {cmd:x} and 
	{cmd:y}{p_end}
{synopt:{cmd:A#B#}{cmd:c.}{cmd:x}}joint test of the interaction effects of 
    {cmd:A} and {cmd:B} on the slopes of {cmd:x}{p_end}
{synopt:{cmd:A#B#}{cmd:c.}{cmd:x#}{cmd:c.}{cmd:y}}joint test of the interaction
    effects of {cmd:A} and {cmd:B} on the slopes of the product (interaction) 
	of {cmd:x} and {cmd:y}{p_end}
{synopt:{it:r.}{cmd:A#}{cmd:c.}{cmd:x}}individual contrasts of {cmd:A}'s 
    effects on the slopes of {cmd:x} using {it:r.}{p_end}
	
{syntab:Denominators}
{synopt:{cmd:.../}{it:term2}}use {it:term2} as the denominator in the 
    F tests of the preceding terms{p_end}
{synopt:{cmd:.../}}use the residual as the denominator in the F
    tests of the preceding terms (the default if no other {cmd:/}s are
	specified{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{cmd:A}, {cmd:B}, {cmd:C}, and {cmd:D} represent any factor variable in 
the current estimation results.{p_end}
{p 4 6 2}
{cmd:x} and {cmd:y} represent any continuous variable in the current
estimation results.{p_end}
{p 4 6 2}
{it:r}{cmd:.} and {it:g}{cmd:.} represent any contrast operator.  See the table 
{help contrast##operators:below}.{p_end}
{p 4 6 2}
{cmd:c.} specifies that a variable be treated as continuous; see
{help fvvarlist}.
{p_end}
{p 4 6 2}
Operators are allowed on any factor variable that does not appear to the
right of {cmd:@} or {cmd:|}.  Operators decompose the effects of the 
associated factor variable into one-degree-of-freedom effects (contrasts).
{p_end}
{p 4 6 2}
Higher-level interactions are allowed anywhere an interaction operator 
({cmd:#}) appears in the table.{p_end}
{p 4 6 2}
Time-series operators are allowed if they were used in the estimation.
{p_end}
{p 4 6 2}
{cmd:_eqns} designates the equations in {helpb manova}, {helpb mlogit},
{helpb mprobit}, and {helpb mvreg} and can be specified anywhere
a factor variable appears.{p_end}
{p 4 6 2}
{cmd:/} is allowed only after {helpb anova}, {helpb cnsreg}, 
{helpb manova}, {helpb mvreg}, or {helpb regress}.{p_end}

{marker operators}{...}
{synoptset 23 tabbed}{...}
{synopthdr:operators (op.)}
{synoptline}
{synopt:{cmd:r}.}differences from the reference (base) level;
	the default{p_end}
{synopt:{cmd:a}.}differences from the next level (adjacent
    contrasts){p_end}
{synopt:{cmd:ar}.}differences from the previous level (reverse
    adjacent contrasts){p_end}

{syntab:As-balanced operators}
{synopt:{cmd:g}.}differences from the balanced grand mean{p_end}
{synopt:{cmd:h}.}differences from the balanced mean of subsequent levels 
    (Helmert contrasts){p_end}
{synopt:{cmd:j}.}differences from the balanced mean of previous levels 
    (reverse Helmert contrasts){p_end}
{synopt:{cmd:p}.}orthogonal polynomial in the level values{p_end}
{synopt:{cmd:q}.}orthogonal polynomial in the level sequence{p_end}

{syntab:As-observed operators}
{synopt:{cmd:gw}.}differences from the observation-weighted grand 
    mean{p_end}
{synopt:{cmd:hw}.}differences from the observation-weighted mean of 
    subsequent levels{p_end}
{synopt:{cmd:jw}.}differences from the observation-weighted mean of 
    previous levels{p_end}
{synopt:{cmd:pw}.}observation-weighted orthogonal polynomial in the 
    level values{p_end}
{synopt:{cmd:qw}.}observation-weighted orthogonal polynomial in the 
    level sequence{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
One or more individual contrasts may be selected by using the {it:op#.} or
{it:op}{cmd:(}{it:{help numlist}}{cmd:).} syntax.  For example, {cmd:a3.A} selects the adjacent
contrast for level 3 of {cmd:A}, and {cmd:p(1/2).B} selects the linear
and quadratic effects of {cmd:B}.  Also see {it:{mansection R contrastRemarksandexamplesOrthogonalpolynomialcontrasts:Orthogonal polynomial contrasts}}
and {it:{mansection R contrastRemarksandexamplesBeyondlinearmodels:Beyond linear models}} 
in {manlink R contrast}.{p_end}


{marker custom}{...}
{synoptset 23}{...}
{p2col 5 30 32 2:Custom contrasts}Description{p_end}
{synoptline}
{synopt:{cmd:{c -(}}{cmd:A} {it:{help numlist}}{cmd:{c )-}}}user-defined
	contrast on the levels of factor {cmd:A}{p_end}
{synopt:{cmd:{c -(}}{cmd:A#B} {it:{help numlist}}{cmd:{c )-}}}user-defined
        contrast on the levels of interaction between
	{cmd:A} and {cmd:B}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
Custom contrasts may be part of a term, such as 
{cmd:{c -(}}{cmd:A} {it:numlist}{cmd:{c )-}}{cmd:#B}, 
{cmd:{c -(}}{cmd:A} {it:numlist}{cmd:{c )-}}{cmd:@B}, 
{cmd:{c -(}}{cmd:A} {it:numlist}{cmd:{c )-}}{cmd:|B},
{cmd:{c -(}}{cmd:A#B} {it:numlist}{cmd:{c )-}}, and 
{cmd:{c -(}}{cmd:A} {it:numlist}{cmd:{c )-}}{cmd:#}{cmd:{c -(}}{cmd:B} {it:numlist}{cmd:{c )-}}. 
The same is true of higher-order custom contrasts,
such as 
{cmd:{c -(}}{cmd:A#B} {it:numlist}{cmd:{c )-}}{cmd:@C}, 
{cmd:{c -(}}{cmd:A#B} {it:numlist}{cmd:{c )-}}{cmd:#}{it:r}{cmd:.C}, and 
{cmd:{c -(}}{cmd:A#B} {it:numlist}{cmd:{c )-}}{cmd:#}{cmd:c.x}.{p_end}
{p 4 6 2}
Higher-order interactions with at most eight factor variables are allowed 
with custom contrasts.{p_end}


{marker method}{...}
{synoptset 22}{...}
{synopthdr:method}
{synoptline}
{synopt:{opt noadj:ust}}do not adjust for multiple comparisons; the default{p_end}
{synopt:{opt bon:ferroni} [{opt adjustall}]}Bonferroni's method; adjust across all terms{p_end}
{synopt:{opt sid:ak} [{opt adjustall}]}Sidak's method; adjust across all terms{p_end}
{synopt:{opt sch:effe}}Scheffe's method{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Postestimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:contrast} tests linear hypotheses and forms contrasts involving factor 
variables and their interactions from the most recently fit model.  The 
tests include ANOVA-style tests of main effects, simple effects, interactions, 
and nested effects.  {cmd:contrast} can use named contrasts to decompose 
these effects into comparisons against reference categories, comparisons of 
adjacent levels, comparisons against the grand mean, orthogonal polynomials, 
and such.  Custom contrasts may also be specified.

{pstd}
{cmd:contrast} can be used with {cmd:svy} estimation results; see
{manhelp svy_postestimation SVY:svy postestimation}.

{pstd}
Contrasts can also be computed for margins of linear and nonlinear responses; 
see {manhelp margins_contrast R:margins, contrast}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R contrastQuickstart:Quick start}

        {mansection R contrastRemarksandexamples:Remarks and examples}

        {mansection R contrastMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt overall}
specifies that a joint hypothesis test over all terms be performed.

{phang}
{opt asobserved}
specifies that factor covariates be evaluated using the cell frequencies 
observed in the estimation sample.  The default is to treat all factor 
covariates as though there were an equal number of observations in each level.

{phang}
{opt lincom}
specifies that user-defined contrasts be treated as linear combinations. 
The default is to require that all user-defined contrasts sum to zero. 
(Summing to zero is part of the definition of a contrast.)

{dlgtab:Equations}

{phang}
{opt equation(eqspec)}
specifies the equation from which contrasts are to be computed.  The default 
is to compute contrasts from the first equation.

{phang}
{opt atequations}
specifies that the contrasts be computed within each equation.

{dlgtab:Advanced}

{marker empspec}{...}
{phang}
{opt emptycells(empspec)}
specifies how empty cells are handled in interactions involving factor
variables that are being treated as balanced.

{phang2}
{cmd:emptycells(strict)}
is the default; it specifies that contrasts involving empty cells be treated
as not estimable.

{phang2}
{cmd:emptycells(reweight)}
specifies that the effects of the observed cells be increased to accommodate
any missing cells.  This makes the contrast estimable but changes its
interpretation.  

{phang}
{opt noestimcheck}
specifies that {cmd:contrast} not check for estimability.  By default, the
requested contrasts are checked and those found not estimable are reported as
such.  Nonestimability is usually caused by empty cells.  If
{cmd:noestimcheck} is specified, estimates are computed in the usual way and
reported even though the resulting estimates are manipulable, which is to say
they can differ across equivalent models having different parameterizations.

{dlgtab:Reporting}

{phang}
{opt level(#)}
specifies the confidence level, as a percentage, for confidence intervals.
The default is {cmd:level(95)} or as set by {helpb set level}.

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
Bonferroni inequality

{center: alpha_e <= m * alpha_c}

{pmore2}
where {it:m} is the number of comparisons within the term.

{pmore2}
The adjusted comparisonwise error rate is

{center: alpha_c = alpha_e/m}

{phang2}
{cmd:mcompare(sidak)}
adjusts the comparisonwise error rate based on the upper limit of the 
probability inequality

{center:alpha_e <= 1 - (1 - alpha_c)^m}

{pmore2}
where {it:m} is the number of comparisons within the term.

{pmore2}
The adjusted comparisonwise error rate is

{center:alpha_c = 1 - (1 - alpha_e)^(1/m)}

{pmore2}
This adjustment is exact when the {it:m} comparisons are independent.

{phang2}
{cmd:mcompare(scheffe)}
controls the experimentwise error rate using the F or chi-squared
distribution with degrees of freedom equal to the rank of the term.

{phang2}
{cmd:mcompare(}{it:method} {cmd:adjustall)} specifies that the
multiple-comparison adjustments count all comparisons across all terms rather
than performing multiple comparisons term by term. This leads to more
conservative adjustments when multiple variables or terms are specified in
{it:marginslist}.  This option is compatible only with the {cmd:bonferroni} and
{cmd:sidak} methods.

{phang}
{opt noeffects}
suppresses the table of individual contrasts with confidence intervals.  This 
table is produced by default when the {cmd:mcompare()} option
is specified or when a term in {it:termlist} implies all individual contrasts.

{phang} 
{opt cieffects}
specifies that a table containing a confidence interval for each individual
contrast be reported.

{phang} 
{opt pveffects} 
specifies that a table containing a p-value for each individual contrast be
reported.

{phang}
{opt effects} 
specifies that a single table containing a confidence interval and p-value 
for each individual contrast be reported.

{phang} 
{opt nowald} 
suppresses the table of Wald tests.

{phang}
{opt noatlevels}
indicates that only the overall Wald test be reported for each term containing
within or nested ({cmd:@} or {cmd:|}) operators.

{phang}
{opt nosvyadjust}
is for use with {opt svy} estimation commands.  It specifies that the
Wald test be carried out without the default adjustment for the design
degrees of freedom.  That is to say the test is carried out as
{bind:W/k ~ F(k,d)} rather than as {bind:(d-k+1)W/(kd) ~ F(k,d-k+1)}, where
k is the dimension of the test and d is the total number of sampled
PSUs minus the total number of strata.

{phang}
{opt sort} 
specifies that the table of individual contrasts be sorted by the contrast
values within each term.

{phang} 
{opt post} 
causes {cmd:contrast} to behave like a Stata estimation (e-class) command.
{cmd:contrast} posts the vector of estimated contrasts along with the
estimated variance-covariance matrix to {cmd:e()}, so you can treat the
estimated contrasts just as you would results from any other estimation
command.  For example, you could use {cmd:test} to perform simultaneous tests
of hypotheses on the contrasts, or you could use {cmd:lincom} to create linear
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
{opt cformat(%fmt)} specifies how to format contrasts, standard errors, and
confidence limits in the table of estimated contrasts.

{phang2}
{opt pformat(%fmt)} specifies how to format p-values in the table of estimated contrasts.

{phang2}
{opt sformat(%fmt)} specifies how to format test statistics in the 
table of estimated contrasts.

{phang2}
{opt nolstretch} specifies that the width of the table of estimated contrasts
not be automatically widened to accommodate longer variable names. The default,
{cmd:lstretch}, is to automatically widen the table of estimated contrasts up
to the width of the Results window.  To change the default, use
{helpb lstretch:set lstretch off}.
{opt nolstretch} is not shown in the dialog box.
{p_end}

{marker eform_option}{...}
{phang}
{it:eform_option} specifies that the contrasts table be displayed in
exponentiated form.  exp(contrast) is displayed rather than
contrast.  Standard errors and confidence intervals are also
transformed.  See {manhelpi eform_option R} for the list of available
options.

{pstd}
The following option is available with {opt contrast} but is not shown in the
dialog box:

{phang}
{opt df(#)} specifies that the t distribution with {it:#} degrees of
freedom be used for computing p-values and confidence intervals.
The default is to use {cmd:e(df_r)} degrees of freedom or the standard normal
distribution if {cmd:e(df_r)} is missing.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup for one-way model{p_end}
{phang2}{cmd:. webuse cholesterol}{p_end}
{phang2}{cmd:. regress chol i.agegrp}{p_end}

{pstd}Test that the cell means are the same for all age groups, 
that is, test the main effects of age group{p_end}
{phang2}{cmd:. contrast agegrp}{p_end}

{pstd}Reference category contrasts{p_end}
{phang2}{cmd:. contrast r.agegrp}{p_end}

{pstd}Reverse adjacent contrasts{p_end}
{phang2}{cmd:. contrast ar.agegrp}{p_end}

{pstd}Orthogonal polynomial contrasts{p_end}
{phang2}{cmd:. contrast p.agegrp}{p_end}

{pstd}Setup for one-way model{p_end}
{phang2}{cmd:. anova chol i.race}{p_end}

{pstd}Grand mean contrasts, adjusting p-values for multiple comparisons using 
Bonferroni's adjustment{p_end}
{phang2}{cmd:. contrast g.race, mcompare(bonferroni)}{p_end}

{pstd}User-defined contrasts for reference category effects, testing that the
cell mean of category 1 is equal to the cell mean of category 2 and that the
cell mean of category 1 is equal to the cell mean of category 3{p_end}
{phang2}{cmd:. contrast {c -(}race -1 1 0{c )-} {c -(}race -1 0 1{c )-}}{p_end}

    {hline}
{pstd}Setup for two-way model{p_end}
{phang2}{cmd:. webuse bpchange}{p_end}
{phang2}{cmd:. anova bpchange dose##gender}{p_end}

{pstd}Simple effects of gender{p_end}
{phang2}{cmd:. contrast r.gender@dose}{p_end}

{pstd}Reverse adjacent simple effects of dose{p_end}
{phang2}{cmd:. contrast ar.dose@gender}{p_end}

{pstd}Interaction effects decomposed into individual contrasts{p_end}
{phang2}{cmd:. contrast ar.dose#r.gender}{p_end}

{pstd}Main effects decomposed into individual contrasts{p_end}
{phang2}{cmd:. contrast ar.dose r.gender}

{pstd}Partial interaction effects{p_end}
{phang2}{cmd:. contrast ar.dose#gender}{p_end}
{phang2}{cmd:. contrast dose#r.gender}{p_end}

    {hline}
{pstd}Setup for nested model{p_end}
{phang2}{cmd:. webuse sat}{p_end}
{phang2}{cmd:. anova score method / class|method /}{p_end}

{pstd}Simple effects of class nested within method{p_end}
{phang2}{cmd:. contrast class|method}

{pstd}Main effects with nested error term and reweighting of empty 
cells{p_end}
{phang2}{cmd:. contrast method / class|method, emptycells(reweight)}{p_end}

    {hline}
{pstd}Setup for unbalanced data{p_end}
{phang2}{cmd:. webuse cholesterol}{p_end}

{pstd}ANOVA model with unbalanced data{p_end}
{phang2}{cmd:. anova chol race##agegrp}{p_end}

{pstd}Reference category effects treating all factors as balanced{p_end}
{phang2}{cmd:. contrast r.race}{p_end}

{pstd}Reference category effects, using observed marginal frequencies{p_end}
{phang2}{cmd:. contrast r.race, asobserved}

{pstd}Grand mean contrasts using observed cell frequencies{p_end}
{phang2}{cmd:. contrast gw.race}{p_end}

{pstd}Weighted grand mean contrasts, using observed marginal 
frequencies{p_end}
{phang2}{cmd:. contrast gw.race, asobserved wald cieffects}{p_end}

    {hline}
{pstd}Setup for continuous covariate{p_end}
{phang2}{cmd:. webuse census3}{p_end}
{phang2}{cmd:. anova brate region##c.medage}{p_end}

{pstd}Reference category effects of region on the intercept{p_end}
{phang2}{cmd:. contrast r.region}{p_end}

{pstd}Reference category effects of region on the slope of {cmd:medage}{p_end}
{phang2}{cmd:. contrast r.region#c.medage}{p_end}

    {hline}
{pstd}Setup for nonlinear model{p_end}
{phang2}{cmd:. webuse hospital}{p_end}
{phang2}{cmd:. logistic satisfied hospital##illness}{p_end}

{pstd}ANOVA-style table of tests for main effects and 
interaction effects{p_end}
{phang2}{cmd:. contrast hospital##illness}{p_end}

    {hline}
{pstd}Setup for multivariate response{p_end}
{phang2}{cmd:. webuse jaw}{p_end}
{phang2}{cmd:. mvreg y1 y2 y3 = gender##fracture}{p_end}

{pstd}Test the effects of {cmd:gender}, {cmd:fracture}, and their interaction 
in the first equation{p_end}
{phang2}{cmd:. contrast gender##fracture}{p_end}

{pstd}Test these effects in equation {cmd:y2}{p_end}
{phang2}{cmd:. contrast gender##fracture, equation(y2)}{p_end}

{pstd}Test the same effects for each equation, suppressing blank space between
terms{p_end}
{phang2}{cmd:. contrast gender##fracture, atequations vsquish}{p_end}

{pstd}Test for a marginal effect on the means between dependent 
variables{p_end}
{phang2}{cmd:. contrast _eqns}{p_end}

{pstd}Test whether the main effects of gender differ between 
the dependent variables{p_end}
{phang2}{cmd:. contrast gender#_eqns}{p_end}

    {hline}


{marker video}{...}
{title:Video example}

{phang}
{browse "http://www.youtube.com/watch?v=XaeStjh6n-A":Introduction to contrasts in Stata: One-way ANOVA}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:contrast} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(df_r)}}variance degrees of freedom{p_end}
{synopt:{cmd:r(k_terms)}}number of terms in {it:termlist}{p_end}
{synopt:{cmd:r(level)}}confidence level of confidence intervals{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(cmd)}}{cmd:contrast}{p_end}
{synopt:{cmd:r(cmdline)}}command as typed{p_end}
{synopt:{cmd:r(est_cmd)}}{cmd:e(cmd)} from original estimation results{p_end}
{synopt:{cmd:r(est_cmdline)}}{cmd:e(cmdline)} from original estimation 
    results{p_end}
{synopt:{cmd:r(title)}}title in output{p_end}
{synopt:{cmd:r(overall)}}{cmd:overall} or empty{p_end}
{synopt:{cmd:r(emptycells)}}{it:empspec} from {cmd:emptycells()}{p_end}
{synopt:{cmd:r(mcmethod)}}{it:method} from {opt mcompare()}{p_end}
{synopt:{cmd:r(mctitle)}}title for {it:method} from {opt mcompare()}{p_end}
{synopt:{cmd:r(mcadjustall)}}{cmd:adjustall} or empty{p_end}
{synopt:{cmd:r(margin_method)}}{cmd:asbalanced} or {cmd:asobserved}{p_end}

{p2col 5 20 24 2:Matrices}{p_end}
{synopt:{cmd:r(b)}}contrast estimates{p_end}
{synopt:{cmd:r(V)}}variance-covariance matrix of the contrast estimates{p_end}
{synopt:{cmd:r(error)}}contrast estimability codes;{break}
	{cmd:0} means estimable,{break}
	{cmd:8} means not estimable{p_end}
{synopt:{cmd:r(L)}}matrix of contrasts applied to the model coefficients{p_end}
{synopt:{cmd:r(table)}}matrix containing the contrasts with their standard errors, 
    test statistics, p-values, and confidence intervals{p_end}
{synopt:{cmd:r(F)}}vector
	of F statistics; {cmd:r(df_r)} present{p_end}
{synopt:{cmd:r(chi2)}}vector
	of chi-squared statistics; {cmd:r(df_r)} not present{p_end}
{synopt:{cmd:r(p)}}vector of p-values corresponding to {cmd:r(F)}
    or {cmd:r(chi2)}{p_end}
{synopt:{cmd:r(df)}}vector
	of degrees of freedom corresponding to {cmd:r(p)}{p_end}
{synopt:{cmd:r(df2)}}vector
	of denominator degrees of freedom corresponding to {cmd:r(F)}{p_end}
{p2colreset}{...}


{pstd}
{cmd:contrast} with the {opt post} option stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(df_r)}}variance degrees of freedom{p_end}
{synopt:{cmd:e(k_terms)}}number of terms in {it:termlist}{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:contrast}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(est_cmd)}}{cmd:e(cmd)} from original estimation results{p_end}
{synopt:{cmd:e(est_cmdline)}}{cmd:e(cmdline)} from original estimation 
    results{p_end}
{synopt:{cmd:e(title)}}title in output{p_end}
{synopt:{cmd:e(overall)}}{cmd:overall} or empty{p_end}
{synopt:{cmd:e(emptycells)}}{it:empspec} from {cmd:emptycells()}{p_end}
{synopt:{cmd:e(margin_method)}}{cmd:asbalanced} or {cmd:asobserved}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 20 24 2:Matrices}{p_end}
{synopt:{cmd:e(b)}}contrast estimates{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the contrast estimates{p_end}
{synopt:{cmd:e(error)}}contrast estimability codes;{break}
	{cmd:0} means estimable,{break}
	{cmd:8} means not estimable{p_end}
{synopt:{cmd:e(L)}}matrix of contrasts applied to the model coefficients{p_end}
{synopt:{cmd:e(F)}}vector
	of unadjusted F statistics; {cmd:e(df_r)} present{p_end}
{synopt:{cmd:e(chi2)}}vector
	of chi-squared statistics; {cmd:e(df_r)} not present{p_end}
{synopt:{cmd:e(p)}}vector of unadjusted p-values corresponding to {cmd:e(F)}
    or {cmd:e(chi2)}{p_end}
{synopt:{cmd:e(df)}}vector
	of degrees of freedom corresponding to {cmd:e(p)}{p_end}
{synopt:{cmd:e(df2)}}vector
	of denominator degrees of freedom corresponding to {cmd:e(F)}{p_end}
{p2colreset}{...}
