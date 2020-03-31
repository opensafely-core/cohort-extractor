{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[G-4] gridstyle" "mansection G-4 gridstyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] axis_label_options" "help axis_label_options"}{...}
{viewerjumpto "Syntax" "gridstyle##syntax"}{...}
{viewerjumpto "Description" "gridstyle##description"}{...}
{viewerjumpto "Links to PDF documentation" "gridstyle##linkspdf"}{...}
{viewerjumpto "Remarks" "gridstyle##remarks"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[G-4]} {it:gridstyle} {hline 2}}Choices for overall look of grid lines{p_end}
{p2col:}({mansection G-4 gridstyle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 15}{...}
{p2col:{it:gridstyle}}Description{p_end}
{p2line}
{p2col:{cmd:default}}determined by scheme{p_end}
{p2col:{cmd:major}}determined by scheme; {cmd:default} or bolder{p_end}
{p2col:{cmd:minor}}determined by scheme; {cmd:default} or fainter{p_end}
{p2col:{cmd:dot}}dotted line{p_end}
{p2line}
{p2colreset}{...}

{p 4 4 2}
Other {it:gridstyles} may be available; type

	    {cmd:.} {bf:{stata graph query gridstyle}}

{p 4 4 2}
to obtain the complete list of {it:gridstyles} installed on your computer.


{marker description}{...}
{title:Description}

{pstd}
Grids are lines that extend from an axis across the plot region.
{it:gridstyle} specifies the overall look of grids.
See {manhelpi axis_label_options G-3}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 gridstyleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help gridstyle##remarks1:What is a grid?}
	{help gridstyle##remarks2:What is a gridstyle?}
	{help gridstyle##remarks3:You do not need to specify a gridstyle}
	{help gridstyle##remarks4:Turning off and on the grid}


{* index grid, definition}{...}
{marker remarks1}{...}
{title:What is a grid?}

{pstd}
Grids are lines that extend from an axis across the plot region.


{marker remarks2}{...}
{title:What is a gridstyle?}

{pstd}
Grids are defined by

{phang2}
    1.  whether the grid lines extend into the plot region's margin;

{phang2}
    2.  whether the grid lines close to the axes are to be drawn;

{phang2}
    3.  the line style of the grid, which includes the line's
	thickness, color, and whether they are solid, dashed, etc.;
	see {manhelpi linestyle G-4}.

{pstd}
The {it:gridstyle} specifies all three of these attributes.


{marker remarks3}{...}
{title:You do not need to specify a gridstyle}

{pstd}
The {it:gridstyle} is specified in the options named

	{c -(}{...}
{cmd:y}|{cmd:x}{...}
{c )-}{...}
{c -(}{...}
{cmd:label}|{cmd:tick}|{cmd:mlabel}|{cmd:mtick}{...}
{c )-}{...}
{cmd:(} ... {cmd:gstyle(}{it:gridstyle}{cmd:)} ... {cmd:)}

{pstd}
Correspondingly, other
{c -(}{cmd:y}|{cmd:x}{c )-}{c -(}{cmd:label}|{cmd:tick}|{cmd:mlabel}|{cmd:mtick}{c )-}{cmd:()}
suboptions allow you to specify the individual attributes;
see {manhelpi axis_label_options G-3}.

{pstd}
You specify the {it:gridstyle} when a style exists that is exactly what you
desire or when another style would allow you to specify fewer changes to
obtain what you want.


{marker remarks4}{...}
{title:Turning off and on the grid}

{pstd}
Whether grid lines are included by default is a function of the
scheme; see {manhelp schemes G-4:Schemes intro}.
Regardless of the default,
whether grid lines are included is controlled not by the {it:gridstyle}
but by the
{c -(}{cmd:y}|{cmd:x}{c )-}{c -(}{cmd:label}|{cmd:tick}|{cmd:mlabel}|{cmd:mtick}{c )-}{cmd:()}
suboptions {cmd:grid} and {cmd:nogrid}.

{pstd}
Grid lines are nearly always associated with the {cmd:ylabel()} and/or
{cmd:xlabel()} options.  Specify
{c -(}{cmd:y}|{cmd:x}{c )-}{cmd:label(,grid)} or
{c -(}{cmd:y}|{cmd:x}{c )-}{cmd:label(,nogrid)}.
See {manhelpi axis_label_options G-3}.
{p_end}
