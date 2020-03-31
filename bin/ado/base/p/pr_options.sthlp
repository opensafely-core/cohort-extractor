{smcl}
{* *! version 1.1.5  19oct2017}{...}
{vieweralsosee "[G-3] pr_options" "mansection G-3 pr_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph print" "help graph_print"}{...}
{viewerjumpto "Syntax" "pr_options##syntax"}{...}
{viewerjumpto "Description" "pr_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "pr_options##linkspdf"}{...}
{viewerjumpto "Options" "pr_options##options"}{...}
{viewerjumpto "Remarks" "pr_options##remarks"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[G-3]} {it:pr_options} {hline 2}}Options for use with graph print{p_end}
{p2col:}({mansection G-3 pr_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 25}{...}
{p2col:{it:pr_options}}Description{p_end}
{p2line}
{p2col:{cmdab:tm:argin:(}{it:#}{cmd:)}}top margin, in inches,
       0 <= {it:#} <= 20{p_end}
{p2col:{cmdab:lm:argin:(}{it:#}{cmd:)}}left margin, in inches,
       0 <= {it:#} <= 20{p_end}
{p2col:{cmd:logo(on}|{cmd:off)}}whether to display Stata logo{p_end}
{p2line}
{p2colreset}{...}

{pstd}
Current default values may be listed by typing

	{cmd:. graph set print}

{pstd}
The defaults may be changed by typing

{p 8 16 2}
{cmd:. graph set}
{cmd:print}
{it:name}
{it:value}

{pstd}
where {it:name} is the name of a {it:pr_option}, omitting the parentheses.


{marker description}{...}
{title:Description}

{pstd}
The {it:pr_options} are used with {cmd:graph} {cmd:print}; see
{manhelp graph_print G-2:graph print}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 pr_optionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:tmargin(}{it:#}{cmd:)} and
{cmd:lmargin(}{it:#}{cmd:)}
    set the top and left page margins -- the distance from the edge of
    the page to the start of the graph.  {it:#} is specified in inches, must
    be between 0 and 20, and may be fractional.

{phang}
{cmd:logo(on)} and {cmd:logo(off)}
    specify whether the Stata logo should be included at the bottom of the
    graph.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help pr_options##remarks1:Using the pr_options}
	{help pr_options##remarks2:Setting defaults}
	{help pr_options##remarks3:Note for Unix users}


{marker remarks1}{...}
{title:Using the pr_options}

{pstd}
You have drawn a graph and wish to print it.  You wish, however,
to suppress the Stata logo (although we cannot imagine why you would want
to do that):

	{cmd:. graph} ...{col 50}(draw a graph)

	{cmd:. graph print, logo(off)}


{marker remarks2}{...}
{title:Setting defaults}

{pstd}
If you always wanted {cmd:graph} {cmd:print} to suppress the Stata logo,
you could type

	{cmd:. graph set print logo off}

{pstd}
At a future date, you could type

	{cmd:. graph set print logo on}

{pstd}
to set it back.  You can determine your default {it:pr_options} settings
by typing

	{cmd:. graph set print}


{marker remarks3}{...}
{title:Note for Unix users}

{pstd}
In addition to the options documented above, there are other options you
may specify.  Under Stata for Unix, the {it:pr_options} are in fact
{it:ps_options}; see {manhelpi ps_options G-3}.
{p_end}
