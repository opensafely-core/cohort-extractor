{smcl}
{* *! version 1.0.0  19jun2019}{...}
{viewerdialog margins "dialog margcm"}{...}
{vieweralsosee "[CM] margins" "mansection CM margins"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] contrast" "help contrast"}{...}
{vieweralsosee "[R] margins, contrast" "help margins contrast"}{...}
{vieweralsosee "[R] margins, pwcompare" "help margins pwcompare"}{...}
{vieweralsosee "[R] margins postestimation" "help margins postestimation"}{...}
{viewerjumpto "Syntax" "cm_margins##syntax"}{...}
{viewerjumpto "Menu" "cm_margins##menu"}{...}
{viewerjumpto "Description" "cm_margins##description"}{...}
{viewerjumpto "Links to PDF documentation" "cm_margins##linkspdf"}{...}
{viewerjumpto "Options" "cm_margins##options"}{...}
{viewerjumpto "Examples" "cm_margins##examples"}{...}
{viewerjumpto "Stored results" "cm_margins##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[CM] margins} {hline 2}}Adjusted predictions, predictive margins,
and marginal effects{p_end}
{p2col:}({mansection CM margins:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:margins}
[{it:marginlist}]
[{cmd:,} {it:options}]

{phang}
{it:marginlist} is a list of factor variables or interactions that
appear in the current estimation results.

{phang}
For the full syntax, see {manhelp margins R}.

{synoptset 32}{...}
{synopthdr}
{synoptline}
{synopt :{cmdab:outc:ome(}{help cm_margins##outcomes:{it:outcomes}}[{cmd:,} {cmdab:altsub:pop}]{cmd:)}}estimate margins for specified outcomes{p_end}
{synopt :{opth alt:ernative(cm_margins##alts:alts)}}estimate margins for specified alternatives for alternative-specific covariates{p_end}
{synopt :{cmdab:alt:ernative(}{cmdab:sim:ultaneous)}}estimate margins changing all alternatives simultaneously for alternative-specific
covariates{p_end}
{synopt :{opt contr:ast}}joint tests of differences across levels of
the elements of {it:marginlist}{p_end}
{synopt :{opth contr:ast(cm_margins##contrast_options:contrast_options)}}contrast the margins between the
outcomes or alternatives as specified by {it:contrast_options}{p_end}
{synopt :{opt noe:sample}}do not restrict {cmd:margins} to the estimation sample{p_end}
{synopt :{it:other_margins_options}}see {manhelp margins R} for more options{p_end}
{synoptline}

{synopthdr:contrast_options}
{synoptline}
{synopt :{opt out:comejoint}}joint test of differences across outcomes{p_end}
{synopt :{cmdab:out:comecontrast(}{it:op}[{cmd:._outcome}]{cmd:)}}apply the
{it:op}{cmd:.} contrast operator to the outcomes{p_end}
{synopt :{opt alt:ernativejoint}}joint test of differences across alternatives
for alternative-specific covariates{p_end}
{synopt :{cmdab:alt:ernativecontrast(}{it:op}[{cmd:.}{it:altvar}]{cmd:)}}apply
the {it:op}{cmd:.} contrast operator to the levels of the alternatives for
alternative-specific covariates{p_end}
{synoptline}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Postestimation}
{p_end}


{marker description}{...}
{title:Description}

{pstd}
{cmd:margins} calculates statistics based on predictions of a previously fit
model.  These statistics can be calculated averaging over all covariates, or 
at fixed values of some covariates and averaged over the remaining covariates.
After you fit a choice model, {cmd:margins} provides estimates such as 
marginal predicted choice probabilities, adjusted predictions, and marginal 
effects that allow you to easily interpret the results of a choice model.

{pstd}
Many possible margins can be calculated for choice models.
Therefore, {cmd:margins} has special choice model options to select which 
outcomes are estimated or to select which alternatives are fixed or averaged 
within.  These options are available after
{helpb cmclogit},
{helpb cmmixlogit}, 
{helpb cmxtmixlogit}, 
{helpb cmmprobit}, and 
{helpb cmroprobit}.

{pstd}
{cmd:margins} with the {cmd:contrast} option or with
{help contrast##operators:contrast operators} performs contrasts (comparisons)
of margins.  After you fit a choice model, there are also special options to
select contrasts for outcomes or for alternatives.

{pstd}
This entry focuses on the use of the special choice model options with
{cmd:margins}.  For the full capabilities of {cmd:margins},
see {manhelp margins R}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection CM marginsQuickstart:Quick start}

        {mansection CM marginsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{marker outcomes}{...}
{phang}
{cmd:outcome(}{it:outcomes}[{cmd:, altsubpop}]{cmd:)} specifies that margins
be estimated for the specified outcomes only.  The default is to estimate
margins for all outcomes.

{pmore}
{it:outcomes} is a list of one or more outcomes, which are the values of the
alternatives variable; see {manhelp cmset CM}.  {it:outcomes} can be specified
by

{pin2}
{cmd:#1}, {cmd:#2}, ..., where {cmd:#1} means the first
level of the alternatives variable, {cmd:#2} means the second level, etc.;

{pin2}
numeric values of the alternatives variable if it is a numeric
variable;

{pin2}
{help label:value label}s of the alternatives variable, enclosed in quotes if
there are spaces in the value labels;

{pin2}
string values of the alternatives variable if it is a string variable,
enclosed in quotes if there are spaces in the values; or

{pin2}
{cmd:_all} or {cmd:*} for all levels of the alternatives variable.

{pmore}
The suboption {cmd:altsubpop} applies only to samples with unbalanced choice
sets.  For balanced samples, the default is the same as specifying
{cmd:altsubpop}.  This option is used in conjunction with alternative-specific
covariates and unbalanced choice sets to specify that calculations done for
each alternative be restricted to the subpopulation of cases with that
alternative in their choice set.  The default treats the sample as if it were
balanced with alternatives not in a choice set considered as alternatives with
zero probability of being chosen.  {cmd:altsubpop} is appropriate for
unbalanced experimental designs in which decision makers were presented with
different choice sets.

{marker alts}{...}
{phang}
{opt alternative(alts)} applies only when one or more alternative-specific
covariates are specified in an element of {it:marginlist}, in the {cmd:at()}
option, or in one of the marginal effects options ({cmd:dydx()}, etc.).  This
option specifies that margins be estimated for the specified alternatives
only.  The default is to estimate margins for all alternatives.  {it:alts} are
specified in the same manner as in {opt outcome(outcomes)}.

{phang}
{cmd:alternative(simultaneous)}, as with {opt alternative(alts)}, applies only
when there are alternative-specific covariates in the specification of
{cmd:margins}.  By default, each alternative-specific covariate is changed
(for example, set to a specified value) separately for each alternative,
giving results for each alternative.  This option specifies that each
alternative-specific covariate is to be  changed across all alternatives
simultaneously to produce a single result.

{pmore}
For example, suppose {it:xvar} is an alternative-specific variable with
alternatives {it:A}, {it:B}, and {it:C}, and {cmd:margins,}
{cmd:at(}{it:xvar}{cmd:=1)} is specified.  By default, {it:xvar} is first set
to 1 for alternative {it:A}  and kept at its sample values for {it:B} and
{it:C}, then similarly for the alternative {it:B}, and then {it:C}, producing
results for each of the three alternatives.  The
{cmd:alternative(simultaneous)} option sets {it:xvar} to 1 at each of the
alternatives {it:A}, {it:B}, and {it:C} simultaneously, producing a single
result for the alternatives as a group.

{marker contrast_options}{...}
{phang}
{cmd:contrast} applies only when {it:marginlist} is specified.  If an element
of {it:marginlist} contains only case-specific covariates, this option
displays joint tests of differences among predicted probabilities across the
levels of the element for each outcome.  If the element contains
alternative-specific covariates, this option displays joint tests of
differences among predicted probabilities across the levels of the element for
each outcome and alternative combination.  It also displays a joint test of
all the differences.

{phang}
{cmd:contrast(outcomejoint)} displays a joint test of differences across all
outcomes.  It is a test of the null hypothesis: within each alternative,
differences among predicted probabilities across levels of an element of
{it:marginlist} are the same for each outcome.

{phang}
{cmd:contrast(outcomecontrast(}{it:op}[{cmd:._outcome}]{cmd:))}
applies the contrast operator {it:op}{cmd:.} to the outcomes.  See the
{help contrast##operators:{it:op}{bf:.} table} in {manhelp contrast R} for a
list of all contrast operators.  The optional {cmd:._outcome} does nothing,
but adding it will produce more readable code, showing what {it:op}{cmd:.} is
operating on.

{phang}
{cmd:contrast(alternativejoint)} applies only when there are
alternative-specific covariates in the specification of {cmd:margins}.  This
option displays a joint test of differences across all alternatives.  It is a
test of the null hypothesis: within each outcome, differences among predicted
probabilities across levels of an element of {it:marginlist} are the same for
each alternative.

{phang}
{cmd:contrast(alternativecontrast(}{it:op}[{cmd:.}{it:altvar}]{cmd:))} 
applies only when there are alternative-specific covariates in the 
specification of {cmd:margins}.  This option applies the contrast operator
{help contrast##operators:{it:op}{bf:.}} to the alternatives.  {it:altvar} is
the name of the alternatives covariates used with {helpb cmset}.  The optional
{cmd:.}{it:altvar} does nothing, but adding it will produce more readable
code, showing what {it:op}{cmd:.} is operating on.

{phang}
{cmd:noesample} specifies that {cmd:margins} not restrict its computations to 
the estimation sample used by the previous estimation command.  If the
estimation command used casewise deletion (the default), {cmd:margins} with
{cmd:noesample} also omits missing values casewise.  If the estimation command
used alternativewise deletion (option {cmd:altwise}), alternativewise deletion
is also used by {cmd:margins}.

{phang}
{it:other_margins_options}; see {manhelp margins R} for additional options.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse carchoice}{p_end}
{phang2}{cmd:. cmset consumerid car}{p_end}
{phang2}{cmd:. xtile income_cat = income, nquantiles(4)}{p_end}
{phang2}{cmd:. cmclogit purchase dealers, casevars(i.gender i.income_cat)}{p_end}

{pstd}Obtain the average predicted probabilities for the different levels of
{cmd:income_cat}{p_end}
{phang2}{cmd:. margins income_cat}{p_end}

{pstd}Display the joint tests of differences in probabilities across income levels for each
outcome{p_end}
{phang2}{cmd:. margins income_cat, contrast}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
In addition to the results shown in {manhelp margins R},
{cmd:margins} after {cmd:cm} estimators stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt :{cmd:r(k_alt)}}number of levels of alternatives variable{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt :{cmd:r(altvar)}}name of alternatives variable{p_end}
{synopt :{cmd:r(alt}{it:#}{cmd:)}}{it:#}th level of alternatives
variable{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt :{cmd:r(altvals)}}vector containing levels of alternatives
variable{p_end}

{pstd}
{cmd:margins} with the {cmd:post} option also stores the following in
{cmd:e()}:

{p2col 5 20 24 2: Scalars}{p_end}
{synopt :{cmd:e(k_alt)}}number of levels of alternatives variable{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt :{cmd:e(altvar)}}name of alternatives variable{p_end}
{synopt :{cmd:r(alt}{it:#}{cmd:)}}{it:#}th level of alternatives
variable{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt :{cmd:e(altvals)}}vector containing levels of alternatives
variable{p_end}
{p2colreset}{...}
