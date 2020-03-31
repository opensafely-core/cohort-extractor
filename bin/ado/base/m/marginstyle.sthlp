{smcl}
{* *! version 1.1.6  19oct2017}{...}
{vieweralsosee "[G-4] marginstyle" "mansection G-4 marginstyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] region_options" "help region_options"}{...}
{vieweralsosee "[G-3] textbox_options" "help textbox_options"}{...}
{viewerjumpto "Syntax" "marginstyle##syntax"}{...}
{viewerjumpto "Description" "marginstyle##description"}{...}
{viewerjumpto "Links to PDF documentation" "marginstyle##linkspdf"}{...}
{viewerjumpto "Remarks" "marginstyle##remarks"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[G-4]} {it:marginstyle} {hline 2}}Choices for size of margins{p_end}
{p2col:}({mansection G-4 marginstyle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 20}{...}
{p2col:{it:marginstyle}}Description{p_end}
{p2line}
{p2col:{cmd:zero}}no margin{p_end}
{p2col:{cmd:tiny}}tiny margin, all four sides (smallest){p_end}
{p2col:{cmd:vsmall}}{p_end}
{p2col:{cmd:small}}{p_end}
{p2col:{cmd:medsmall}}{p_end}
{p2col:{cmd:medium}}{p_end}
{p2col:{cmd:medlarge}}{p_end}
{p2col:{cmd:large}}{p_end}
{p2col:{cmd:vlarge}}very large margin, all four sides (largest){p_end}

{p2col:{cmd:bottom}}{cmd:medium} on the bottom{p_end}
{p2col:{cmd:top}}{cmd:medium} on the top{p_end}
{p2col:{cmd:top_bottom}}{cmd:medium} on bottom and top{p_end}

{p2col:{cmd:left}}{cmd:medium} on the left{p_end}
{p2col:{cmd:right}}{cmd:medium} on the right{p_end}
{p2col:{cmd:sides}}{cmd:medium} on left and right{p_end}

{p2col:{it:#} {it:#} {it:#} {it:#}}specified margins; left, right, bottom, top{p_end}
{p2col:{it:marginexp}}specified margin or margins{p_end}
{p2line}
{p2colreset}{...}

{pstd}
where {it:marginexp} is one or more elements of the form

		{c -(}{cmd:l}|{cmd:r}|{cmd:b}|{cmd:t}{c )-}[{it:<space>}][{cmd:+}|{cmd:-}|{cmd:=}]{it:#}

{phang}
such as

		{cmd:l=5}
		{cmd:l=5 r=5}
		{cmd:l+5}
		{cmd:l+5 r=7.2  b-2 t+1}

{pstd}
In both the {it:#} {it:#} {it:#} {it:#} syntax and the
{c -(}{cmd:l}|{cmd:r}|{cmd:b}|{cmd:t}{c )-}[{cmd:+}|{cmd:-}|{cmd:=}]{it:#}
syntax, {it:#} is interpreted as a percentage of the minimum of the width and
height of the graph.  Thus a distance of 5 is the same in both the vertical
and horizontal directions.

{pstd}
When you apply margins to rotated textboxes, the terms
left, right, bottom, and top refer to the box before rotation;
see {manhelpi textbox_options G-3}.

{pstd}
Other {it:marginstyles} may be available; type

	{cmd:.} {bf:{stata graph query marginstyle}}

{pstd}
to obtain the complete list of {it:marginstyles} installed on your computer.
If other {it:marginstyles} do exist, they are merely names associated
with {it:#} {it:#} {it:#} {it:#} margins.


{marker description}{...}
{title:Description}

{pstd}
{it:marginstyle} is used to specify margins (areas to be left unused).


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 marginstyleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
{it:marginstyle} is used, for instance, in the {cmd:margin()} suboption of
{cmd:title()}:

{phang2}
	{cmd:. graph} ...{cmd:, title("My title", margin(}{it:marginstyle}{cmd:))} ...

{pstd}
{it:marginstyle} specifies the margin between the text and the
borders of the textbox that will contain the text (which box will
ultimately be placed on the graph).  See {manhelpi title_options G-3} and
{manhelpi textbox_options G-3}.

{pstd}
As another example, {it:marginstyle} is allowed by the {cmd:margin()} suboption
of {cmd:graphregion()}:

{phang2}
	{cmd:. graph} ...{cmd:, graphregion(margin(}{it:marginstyle}{cmd:))} ...

{pstd}
It allows you to put margins around the plot region within the
graph.  See {it:{help region_options##remarks2:Controlling the aspect ratio}}
in {manhelpi region_options G-3} for an example.
{p_end}
