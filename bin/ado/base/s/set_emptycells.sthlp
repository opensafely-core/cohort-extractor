{smcl}
{* *! version 1.0.8  21may2018}{...}
{vieweralsosee "[R] set emptycells" "mansection R setemptycells"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] set" "help set"}{...}
{viewerjumpto "Syntax" "set_emptycells##syntax"}{...}
{viewerjumpto "Description" "set_emptycells##description"}{...}
{viewerjumpto "Links to PDF documentation" "set_emptycells##linkspdf"}{...}
{viewerjumpto "Option" "set_emptycells##option"}{...}
{viewerjumpto "Remarks" "set_emptycells##remarks"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[R] set emptycells} {hline 2}}Set what to do with empty cells in interactions{p_end}
{p2col:}({mansection R setemptycells:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:set}
{cmd:emptycells}
{c -(}{cmd:keep} | {cmd:drop}{c )-}
[{cmd:,} {cmdab:perm:anently}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:set} {cmd:emptycells} allows you to control how Stata handles interaction
terms with empty cells.  Stata can keep empty cells or drop them.
The default is to keep empty cells.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R setemptycellsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:permanently} specifies that, in addition to making the change right now,
the setting be remembered and become the default setting when you invoke Stata.


{marker remarks}{...}
{title:Remarks}

{pstd}
By default, Stata keeps empty cells so they can be reported in the
coefficient table.  For example, type

	{cmd:. webuse auto}
	{cmd:. regress mpg rep78#foreign, baselevels}

{pstd}
and you will see a regression of {cmd:mpg} on 10 indicator variables because
{cmd:rep78} takes on 5 values and {cmd:foreign} takes on 2 values in the
{cmd:auto} dataset.  Two of those cells will be reported as empty because the
data contain no observations of foreign cars with a {cmd:rep78} value of
1 or 2.

{pstd}
Many real datasets contain a large number of empty cells, and this could
cause the "unable to allocate matrix" error message, {cmd:{search r(915)}}.
In that case, type

	{cmd:. set emptycells drop}

{pstd}
to get Stata to drop empty cells from the list of coefficients.
If you commonly fit models with empty cells, you can permanently set Stata to
drop empty cells by typing the following:

	{cmd:. set emptycells drop, permanently}
