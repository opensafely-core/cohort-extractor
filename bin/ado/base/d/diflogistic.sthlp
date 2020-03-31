{smcl}
{* *! version 1.0.4  18sep2018}{...}
{viewerdialog irt "dialog irt"}{...}
{vieweralsosee "[IRT] diflogistic" "mansection IRT diflogistic"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[IRT] difmh" "help difmh"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[IRT] DIF" "help dif"}{...}
{vieweralsosee "[IRT] irt" "help irt"}{...}
{viewerjumpto "Syntax" "diflogistic##syntax"}{...}
{viewerjumpto "Menu" "diflogistic##menu_irt"}{...}
{viewerjumpto "Description" "diflogistic##description"}{...}
{viewerjumpto "Links to PDF documentation" "diflogistic##linkspdf"}{...}
{viewerjumpto "Options" "diflogistic##options"}{...}
{viewerjumpto "Examples" "diflogistic##examples"}{...}
{viewerjumpto "Stored results" "diflogistic##results"}{...}
{p2colset 1 22 30 2}{...}
{p2col:{bf:[IRT] diflogistic} {hline 2}}Logistic regression DIF{p_end}
{p2col:}({mansection IRT diflogistic:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:diflogistic} {varlist} 
{ifin}
[{help diflogistic##weight:{it:weight}}]{cmd:,}
{opth gr:oup(varname)}
[{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{p2coldent :* {opth gr:oup(varname)}}specify variable that identifies
groups{p_end}
{synopt :{opth total(varname)}}specify total score variable{p_end}
{synopt :{opth items:(varlist:varlist_i)}}calculate logistic regression test for items in {it:varlist_i} only{p_end}

{syntab:Reporting}
{synopt :{opt maxp(#)}}display only items with {bind:p-value {ul:<} {it:#}}{p_end}
{synopt :{opth sf:ormat(%fmt)}}display format for chi-squared values; default is {cmd:sformat(%9.2f)}{p_end}
{synopt :{opth pf:ormat(%fmt)}}display format for p-values; default is {cmd:pformat(%9.4f)}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}* {opt group()} is required.{p_end}
{marker weight}{...}
{p 4 6 2}{opt fweight}s are allowed; see {help weight}.


INCLUDE help menu_irt


{marker description}{...}
{title:Description}

{pstd}
{cmd:diflogistic} uses logistic regression to test whether an item exhibits
differential item functioning (DIF) between two observed groups.  Logistic
regression is used to test for both uniform and nonuniform DIF, that is,
whether an item favors one group over the other for all values of the latent
trait or for only some values of the latent trait.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection IRT diflogisticQuickstart:Quick start}

        {mansection IRT diflogisticRemarksandexamples:Remarks and examples}

        {mansection IRT diflogisticMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth group(varname)}
	specifies the numeric variable that identifies the focal group and
	the reference group.  The groups should be coded 1 and 0,
	respectively.  {cmd:group()} is required.

{phang}
{opth total(varname)}
	specifies the variable to be used as a total score.
	By default, the total score is calculated as the row sum
	of the item variables.
	
{phang}
{opth items:(varlist:varlist_i)}
	requests that logistic regression test be calculated
	only for the specified items.  {it:varlist_i} must be a subset
	of {it:varlist}. By default, the statistics are
	calculated for all the items in {it:varlist}.

{dlgtab:Reporting}

{phang}
{opt maxp(#)}
	requests that only items with p-value {ul:<} {it:#} be displayed.

{phang}
{opth sformat(%fmt)}
	specifies the display format used for the chi-squared values
        of the output table.  The default is {cmd:sformat(%9.2f)}.

{phang}
{opth pformat(%fmt)}
	specifies the display format used for the p-values
        of the output table.  The default is {cmd:pformat(%9.4f)}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse masc2}

{pstd}Perform logistic regression tests on items {cmd:q1-q9}{p_end}
{phang2}{cmd:. diflogistic q1-q9, group(female)}

{pstd}Same as above, but request the tests for items {cmd:q1},
{cmd:q5}, and {cmd:q9}{p_end}
{phang2}{cmd:. diflogistic q1-q9, group(female) items(q1 q5 q9)}

{pstd}Replay the results and show only items significant at the 0.1 level{p_end}
{phang2}{cmd:. diflogistic, maxp(.1)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:diflogistic} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(cmd)}}{cmd:diflogistic}{p_end}
{synopt:{cmd:r(cmdline)}}command as typed{p_end}
{synopt:{cmd:r(items)}}names of items{p_end}
{synopt:{cmd:r(wtype)}}weight type{p_end}
{synopt:{cmd:r(wexp)}}weight expression{p_end}
{synopt:{cmd:r(group)}}group variable{p_end}
{synopt:{cmd:r(total)}}name of alternative total score variable, if
specified{p_end}

{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(dif)}}results table{p_end}
{synopt:{cmd:r(_N)}}number of observations per item{p_end}
{p2colreset}{...}
