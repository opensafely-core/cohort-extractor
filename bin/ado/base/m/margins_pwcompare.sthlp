{smcl}
{* *! version 1.0.15  30may2019}{...}
{viewerdialog margins "dialog margins"}{...}
{vieweralsosee "[R] margins, pwcompare" "mansection R margins,pwcompare"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] contrast" "help contrast"}{...}
{vieweralsosee "[R] margins" "help margins"}{...}
{vieweralsosee "[R] margins, contrast" "help margins_contrast"}{...}
{vieweralsosee "[R] margins postestimation" "help margins_postestimation"}{...}
{vieweralsosee "[R] pwcompare" "help pwcompare"}{...}
{viewerjumpto "Syntax" "margins pwcompare##syntax"}{...}
{viewerjumpto "Menu" "margins pwcompare##menu"}{...}
{viewerjumpto "Description" "margins pwcompare##description"}{...}
{viewerjumpto "Suboptions" "margins pwcompare##suboptions"}{...}
{viewerjumpto "Examples" "margins pwcompare##examples"}{...}
{viewerjumpto "Stored results" "margins pwcompare##results"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[R] margins, pwcompare} {hline 2}}Pairwise comparisons of margins
{p_end}
{p2col:}({mansection R margins,pwcompare:View complete PDF manual entry}){p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:margins} [{it:{help fvvarlist:marginlist}}] 
{ifin}
[{it:{help margins pwcompare##weight:weight}}]
[{cmd:,} 
{opt pwcomp:are}
{it:{help margins##response_options:margins_options}}] 

{p 8 16 2}
{cmd:margins} [{it:{help fvvarlist:marginlist}}] 
{ifin}
[{it:{help margins pwcompare##weight:weight}}]
[{cmd:,} 
{opt pwcomp:are}{cmd:(}{it:{help margins_pwcompare##pwcompare_options:suboptions}}{cmd:)}
{it:{help margins##response_options:margins_options}}] 

{pstd}
where {it:marginlist} is a list of factor variables or interactions that
appear in the current estimation results.  The variables may be typed 
with or without the {cmd:i.} prefix, and you may use any factor-variable
syntax:

		. {cmd:margins i.sex i.group i.sex#i.group, pwcompare}

		. {cmd:margins sex group sex#i.group, pwcompare}

		. {cmd:margins sex##group, pwcompare}

{marker pwcompare_options}{...}
{synoptset 20 tabbed}{...}
{synopthdr:suboptions}
{synoptline}
{syntab :Pairwise comparisons}
{synopt:{opt ci:effects}}show effects table with confidence intervals;
     the default{p_end}
{synopt:{opt pv:effects}}show effects table with p-values{p_end}
{synopt:{opt eff:ects}}show effects table with confidence intervals and p-values
    {p_end}
{synopt:{opt cim:argins}}show table of margins and confidence intervals{p_end}
{synopt:{opt group:s}}show table of margins and group codes{p_end}
{synopt:{opt sort}}sort the margins or contrasts in each term{p_end}
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
{cmd:margins} with the {opt pwcompare} option performs pairwise comparisons of
margins.  {cmd:margins, pwcompare} extends the capabilities of {cmd:pwcompare}
to any of the nonlinear responses, predictive margins, or other margins that
can be estimated by {cmd:margins}.


{marker suboptions}{...}
{title:Suboptions}

{dlgtab:Pairwise comparisons}

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
specifies that the reported tables be sorted on the margins or contrasts in
each term.


{marker examples}{...}
{title:Examples}

{pstd}
These examples are intended for quick reference.  For a conceptual overview of
{cmd:margins,} {cmd:pwcompare} and examples with discussion, see
{it:{mansection R margins,pwcompareRemarksandexamples:Remarks and examples}} in
{bf:[R] margins, pwcompare}.

{pstd}Setup{p_end}
{phang2}{cmd:. webuse nhanes2}{p_end}
{phang2}{cmd:. logistic highbp sex##agegrp##c.bmi}{p_end}

{pstd}Pairwise comparisons of the average predicted probability of high blood
pressure conditional on being in each of the six age groups{p_end}
{phang2}{cmd:. margins agegrp, pwcompare}{p_end}

{pstd}Predictive margins with group codes denoting margins that are not
significantly different{p_end}
{phang2}{cmd:. margins agegrp, pwcompare(group)}{p_end}

{pstd}Pairwise comparisons of margins using Bonferroni's adjustment for
multiple comparisons{p_end}
{phang2}{cmd:. margins agegrp, pwcompare(group) mcompare(bonferroni)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:margins,} {cmd:pwcompare} stores the following additional results in
{cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(k_terms)}}number of terms participating in pairwise comparisons{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(cmd)}}{cmd:pwcompare}{p_end}
{synopt:{cmd:r(cmd2)}}{cmd:margins}{p_end}
{synopt:{cmd:r(group{it:#})}}group code for the {it:#}th margin in {cmd:r(b)}{p_end}
{synopt:{cmd:r(mcmethod_vs)}}{it:method} from {opt mcompare()}{p_end}
{synopt:{cmd:r(mctitle_vs)}}title for {it:method} from {opt mcompare()}{p_end}
{synopt:{cmd:r(mcadjustall_vs)}}{cmd:adjustall} or empty{p_end}

{p2col 5 20 24 2:Matrices}{p_end}
{synopt:{cmd:r(b)}}margin estimates{p_end}
{synopt:{cmd:r(V)}}variance-covariance matrix of the margin estimates{p_end}
{synopt:{cmd:r(b_vs)}}margin difference estimates{p_end}
{synopt:{cmd:r(V_vs)}}variance-covariance
	matrix of the margin difference estimates{p_end}
{synopt:{cmd:r(error_vs)}}margin difference estimability codes;{break}
	{cmd:0} means estimable,{break}
	{cmd:8} means not estimable{p_end}
{synopt:{cmd:r(table_vs)}}matrix
	containing the margin differences with their standard errors, test
	statistics, p-values, and confidence intervals{p_end}
{synopt:{cmd:r(L)}}matrix that produces the margin differences{p_end}
{p2colreset}{...}

{pstd}
{cmd:margins,} {cmd:pwcompare} with the {opt post} option also stores the
following additional results in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(k_terms)}}number of terms participating in pairwise comparisons{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:pwcompare}{p_end}
{synopt:{cmd:e(cmd2)}}{cmd:margins}{p_end}

{p2col 5 20 24 2:Matrices}{p_end}
{synopt:{cmd:e(b)}}margin estimates{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the margin estimates{p_end}
{synopt:{cmd:e(b_vs)}}margin difference estimates{p_end}
{synopt:{cmd:e(V_vs)}}variance-covariance
	matrix of the margin difference estimates{p_end}
{synopt:{cmd:e(error_vs)}}margin difference estimability codes;{break}
	{cmd:0} means estimable,{break}
	{cmd:8} means not estimable{p_end}
{synopt:{cmd:e(L)}}matrix that produces the margin differences{p_end}
