{smcl}
{* *! version 1.1.5  19oct2017}{...}
{vieweralsosee "[G-4] addedlinestyle" "mansection G-4 addedlinestyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] added_line_options" "help added_line_options"}{...}
{viewerjumpto "Syntax" "addedlinestyle##syntax"}{...}
{viewerjumpto "Description" "addedlinestyle##description"}{...}
{viewerjumpto "Links to PDF documentation" "addedlinestyle##linkspdf"}{...}
{viewerjumpto "Remarks" "addedlinestyle##remarks"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[G-4]} {it:addedlinestyle} {hline 2}}Choices for overall look of added lines{p_end}
{p2col:}({mansection G-4 addedlinestyle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 20}{...}
{p2col : {it:addedlinestyle}}Description{p_end}
{p2line}
{p2col : {cmd:default}}determined by scheme{p_end}
{p2col : {cmd:extended}}extends through plot region margins{p_end}
{p2col : {cmd:unextended}}does not extend through margins{p_end}
{p2line}
{p2colreset}{...}

{p 4 6 2}
Other {it:addedlinestyles} may be available; type

	    {cmd:.} {bf:{stata graph query addedlinestyle}}

{p 4 6 2}
to obtain the full list installed on your computer.


{marker description}{...}
{title:Description}

{pstd}
Added lines are those added by the {it:added_line_options}.
{it:addedlinestyle} specifies the overall look of those lines.
See {manhelpi added_line_options G-3}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 addedlinestyleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help addedlinestyle##remarks1:What is an added line?}
	{help addedlinestyle##remarks2:What is an addedlinestyle?}
	{help addedlinestyle##remarks3:You do not need to specify an addedlinestyle}


{marker remarks1}{...}
{title:What is an added line?}

{pstd}
Added lines are lines added by the {it:added_line_options} that extend
across the plot region and perhaps across the plot region's margins, too.


{marker remarks2}{...}
{title:What is an addedlinestyle?}

{pstd}
Added lines are defined by

{phang2}
    1.  whether the lines extend into the plot region's margin;

{phang2}
    2.  the style of the lines, which includes the lines'
	thickness, color, and whether solid, dashed, etc.;
	see {manhelpi linestyle G-4}.

{pstd}
The {it:addedlinestyle} specifies both these attributes.


{marker remarks3}{...}
{title:You do not need to specify an addedlinestyle}

{pstd}
The {it:addedlinestyle} is specified in the options

	{cmd:yline(}...{cmd:, style(}{it:addedlinestyle}{cmd:)} ...{cmd:)}
	{cmd:xline(}...{cmd:, style(}{it:addedlinestyle}{cmd:)} ...{cmd:)}

{pstd}
Correspondingly, other {cmd:yline()} and {cmd:xline()} suboptions
allow you to specify the individual attributes; see
{manhelpi added_line_options G-3}.

{pstd}
You specify the {it:addedlinestyle} when a style exists that is exactly what
you desire or when another style would allow you to specify fewer changes to
obtain what you want.
{p_end}
