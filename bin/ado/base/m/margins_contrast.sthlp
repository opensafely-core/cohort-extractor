{smcl}
{* *! version 1.1.5  30may2019}{...}
{viewerdialog margins "dialog margins"}{...}
{vieweralsosee "[R] margins, contrast" "mansection R margins,contrast"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] contrast" "help contrast"}{...}
{vieweralsosee "[R] lincom" "help lincom"}{...}
{vieweralsosee "[R] margins" "help margins"}{...}
{vieweralsosee "[R] margins postestimation" "help margins_postestimation"}{...}
{vieweralsosee "[R] margins, pwcompare" "help margins_pwcompare"}{...}
{vieweralsosee "[R] pwcompare" "help pwcompare"}{...}
{viewerjumpto "Syntax" "margins contrast##syntax"}{...}
{viewerjumpto "Menu" "margins contrast##menu"}{...}
{viewerjumpto "Description" "margins contrast##description"}{...}
{viewerjumpto "Suboptions" "margins contrast##suboptions"}{...}
{viewerjumpto "Examples" "margins contrast##examples"}{...}
{viewerjumpto "Stored results" "margins contrast##results"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[R] margins, contrast} {hline 2}}Contrasts of margins
{p_end}
{p2col:}({mansection R margins,contrast:View complete PDF manual entry}){p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:margins} [{it:{help fvvarlist:marginlist}}] 
{ifin}
[{it:{help margins contrast##weight:weight}}]
[{cmd:,} 
{opt contr:ast}
{it:{help margins##response_options:margins_options}}] 

{p 8 16 2}
{cmd:margins} [{it:{help fvvarlist:marginlist}}] 
{ifin}
[{it:{help margins contrast##weight:weight}}]
[{cmd:,} 
{opt contr:ast}{cmd:(}{it:{help margins_contrast##contrast_options:suboptions}}{cmd:)}
{it:{help margins##response_options:margins_options}}] 


{pstd}
where {it:marginlist} is a list of factor variables or interactions that
appear in the current estimation results.  The variables may be typed 
with or without {help contrast##operators:contrast operators}, and you may use
any factor-variable syntax:

		. {cmd:margins sex##group, contrast}

		. {cmd:margins sex##g.group, contrast}

		. {cmd:margins sex@group, contrast}

{pstd}
See the {it:{help contrast##operators:operators (op.)}} table in
{helpb contrast:[R] contrast} for the list of contrast operators.
Contrast operators may also be specified on the variables in {cmd:margins}'s
{cmd:over()} and {cmd:within()} options to perform contrasts across the
levels of those variables.

{marker contrast_options}{...}
{synoptset 24 tabbed}{...}
{synopthdr:suboptions}
{synoptline}
{syntab :Contrast}
{synopt:{opt overall}}add
	a joint hypothesis test for all specified contrasts{p_end}
{synopt:{opt lincom}}treat user-defined contrasts as linear combinations{p_end}
{synopt:{opt pred:ict}{cmd:(}{it:op}[{cmd:._predict}]{cmd:)}}apply the
	{it:op}{cmd:.} contrast operator to the groups defined by
	multiple {opt predict()} options
	{p_end}
{synopt:{opt at:contrast}{cmd:(}{it:op}[{cmd:._at}]{cmd:)}}apply the
	{it:op}{cmd:.} contrast operator to the groups defined by {opt at()}
	 {p_end}
{synopt:{opt pred:ictjoint}}test jointly across all groups defined by
	multiple {opt predict()} options
	{p_end}
{synopt:{opt at:joint}}test jointly across all groups defined by {opt at()}
        {p_end}
{synopt:{opt over:joint}}test jointly across all levels of the unoperated
       {opt over()} variables{p_end}
{synopt:{opt within:joint}}test jointly across all levels of the unoperated
       {opt within()} variables{p_end}
{synopt:{opt marginsw:ithin}}perform contrasts within the levels of the
        unoperated terms in {it:marginlist}{p_end}

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
{synoptline}

{marker weight}{...}
{pstd}
{cmd:fweight}s, {cmd:aweight}s, {cmd:iweight}s, and {cmd:pweight}s are allowed;
see {help weight}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Postestimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:margins} with the {cmd:contrast} option or with contrast operators
performs contrasts of margins.  This extends the capabilities of
{cmd:contrast} to any of the nonlinear responses, predictive margins, or other
margins that can be estimated by {cmd:margins}.


{marker suboptions}{...}
{title:Suboptions}

{dlgtab:Contrast}

{phang}
{opt overall}
specifies that a joint hypothesis test over all terms be performed.

{phang}
{opt lincom}
specifies that user-defined contrasts be treated as linear combinations.
The default is to require that all user-defined contrasts sum to zero.
(Summing to zero is part of the definition of a contrast.)

{phang}
{opt predict}{cmd:(}{it:op}{cmd:._predict}{cmd:)}
specifies that the {it:op}{cmd:.} contrast operator be applied to the groups
defined by multiple specifications of {helpb margins}'s {opt predict()}
option.
The default behavior, by comparison, is to perform tests and contrasts within
these groups.

{phang}
{opt atcontrast}{cmd:(}{it:op}{cmd:._at}{cmd:)}
specifies that the {it:op}{cmd:.} contrast operator be applied to the groups
defined by the {opt at()} option(s).  The default behavior, by comparison, is
to perform tests and contrasts within the groups defined by the {opt at()}
option(s).

{pmore}
See {mansection R margins,contrastRemarksandexamplesex6:example 6} in
{it:Remarks and examples} of {bf:[R] margins, contrast}.

{phang}
{opt predictjoint} specifies that joint tests be performed across all groups
defined by multiple specifications of {helpb margins}'s {opt predict()}
option.
The default behavior, by comparison, is to perform contrasts and tests within
each group.

{phang}
{opt atjoint} specifies that joint tests be performed across all groups
defined by the {opt at()} option.  The default behavior, by comparison, is to
perform contrasts and tests within each group.

{pmore}
See {mansection R margins,contrastRemarksandexamplesex5:example 5} in
{it:Remarks and examples} of {bf:[R] margins, contrast}.

{phang}
{opt overjoint}
specifies how unoperated variables in the {opt over()} option
are treated.

{pmore}
Each variable in the {opt over()} option may be specified either with or
without a contrast operator.  For contrast-operated variables, the specified
contrast comparisons are always performed.

{pmore}
{opt overjoint} specifies that joint tests be performed across all levels of
the unoperated variables.  The default behavior, by comparison, is to perform
contrasts and tests within each combination of levels of the unoperated
variables.

{pmore}
See {mansection R margins,contrastRemarksandexamplesex3:example 3} in
{it:Remarks and examples}
in {bf:[R] margins, contrast}.

{phang}
{opt withinjoint} specifies how unoperated variables in the {opt within()}
option are treated.

{pmore}
Each variable in the {opt within()} option may be specified either with or
without a contrast operator.  For contrast-operated variables, the specified
contrast comparisons are always performed.

{pmore}
{opt withinjoint} specifies that joint tests be performed across all levels of
the unoperated variables.  The default behavior, by comparison, is to perform
contrasts and tests within each combination of levels of the unoperated
variables.

{phang}
{opt marginswithin} specifies how unoperated variables in {it:marginlist}
are treated.

{pmore}
Each variable in {it:marginlist} may be specified either with or without a
contrast operator.  For contrast-operated variables, the specified contrast
comparisons are always performed.

{pmore}
{opt marginswithin} specifies that contrasts and tests be performed within each
combination of levels of the unoperated variables.  The default behavior, by
comparison, is to perform joint tests across all levels of the unoperated
variables.

{pmore}
See {mansection R margins,contrastRemarksandexamplesex4:example 4} in
{it:Remarks and examples} in {bf:[R] margins, contrast}.

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


{marker examples}{...}
{title:Examples}

{pstd}
These examples are intended for quick reference.  For a conceptual overview of
{cmd:margins,} {cmd:contrast} and examples with discussion, see
{bf:{mansection R margins,contrastRemarksandexamples:Remarks and examples}} in
{bf:{mansection R margins,contrast:[R] margins, contrast}}.

{phang2}{cmd:. webuse margex}{p_end}
{phang2}{cmd:. logistic outcome treatment##group age c.age#c.age treatment#c.age}{p_end}
{phang2}{cmd:. margins, dydx(treatment)}{p_end}
{phang2}{cmd:. margins r.treatment}{p_end}
{phang2}{cmd:. margins treatment#group, contrast(wald)}{p_end}
{phang2}{cmd:. margins treatment@group, contrast(wald)}{p_end}
{phang2}{cmd:. margins treatment, over(group) contrast(wald overjoint)}{p_end}
{phang2}{cmd:. margins treatment, over(group) contrast(wald)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:margins,} {cmd:contrast} stores the following additional results in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(k_terms)}}number of terms participating in contrasts{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(cmd)}}{cmd:contrast}{p_end}
{synopt:{cmd:r(cmd2)}}{cmd:margins}{p_end}
{synopt:{cmd:r(overall)}}{opt overall} or empty{p_end}

{p2col 5 20 24 2:Matrices}{p_end}
{synopt:{cmd:r(L)}}matrix of contrasts applied to the margins{p_end}
{synopt:{cmd:r(chi2)}}vector of chi-squared statistics{p_end}
{synopt:{cmd:r(p)}}vector of p-values corresponding to {cmd:r(chi2)}{p_end}
{synopt:{cmd:r(df)}}vector
	of degrees of freedom corresponding to {cmd:r(p)}{p_end}
{p2colreset}{...}

{pstd}
{cmd:margins,} {cmd:contrast} with the {opt post} option also stores the
following additional results in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(k_terms)}}number of terms participating in contrasts{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:contrast}{p_end}
{synopt:{cmd:e(cmd2)}}{cmd:margins}{p_end}
{synopt:{cmd:e(overall)}}{opt overall} or empty{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(L)}}matrix of contrasts applied to the margins{p_end}
{synopt:{cmd:e(chi2)}}vector of chi-squared statistics{p_end}
{synopt:{cmd:e(p)}}vector of p-values corresponding to {cmd:e(chi2)}{p_end}
{synopt:{cmd:e(df)}}vector
	of degrees of freedom corresponding to {cmd:e(p)}{p_end}
{p2colreset}{...}
