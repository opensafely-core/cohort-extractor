{smcl}
{* *! version 1.1.12  15may2018}{...}
{vieweralsosee "[G-3] added_line_options" "mansection G-3 added_line_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] addedlinestyle" "help addedlinestyle"}{...}
{vieweralsosee "[G-4] colorstyle" "help colorstyle"}{...}
{vieweralsosee "[G-4] linealignmentstyle" "help linealignmentstyle"}{...}
{vieweralsosee "[G-4] linepatternstyle" "help linepatternstyle"}{...}
{vieweralsosee "[G-4] linestyle" "help linestyle"}{...}
{vieweralsosee "[G-4] linewidthstyle" "help linewidthstyle"}{...}
{viewerjumpto "Syntax" "added_line_options##syntax"}{...}
{viewerjumpto "Description" "added_line_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "added_line_options##linkspdf"}{...}
{viewerjumpto "Options" "added_line_options##options"}{...}
{viewerjumpto "Suboptions" "added_line_options##suboptions"}{...}
{viewerjumpto "Remarks" "added_line_options##remarks"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[G-3]} {it:added_line_options} {hline 2}}Options for adding lines to twoway graphs{p_end}
{p2col:}({mansection G-3 added_line_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 25}{...}
{p2col : {it:added_line_options}}
	description{p_end}
{p2line}
{p2col : {cmdab:yli:ne:(}{it:linearg}{cmd:)}}
	add horizontal lines at specified {it:y} values{p_end}
{p2col : {cmdab:xli:ne:(}{it:linearg}{cmd:)}}
	add vertical lines at specified {it:x} values{p_end}
{p2col : {cmdab:tli:ne:(}{it:time_linearg}{cmd:)}}
	add vertical lines at specified {it:t} values{p_end}
{p2line}
{p 4 6 2}
{cmd:yline()}, {cmd:xline()}, and {cmd:tline()} are {it:merged-implicit}; see
{help repeated options} and see 
{help added_line_options##remarks2:Interpretation of repeated options}
below.

{pstd}
where {it:linearg} is

{p 8 16 2}
{it:numlist}
[{cmd:,}
{it:suboptions}]

{pstd}
For a description of {it:numlist}, see {help numlist}.

{pstd}
and {it:time_linearg} is

{p 8 16 2}
{it:datelist}
[{cmd:,}
{it:suboptions}]

{pstd}
For a description of {it:datelist}, see {help datelist}.

{p2col : {it:suboptions}}
	description{p_end}
{p2line}
{p2col : {cmdab:ax:is:(}{it:#}{cmd:)}}
	which axis to use, 1 {ul:<} # {ul:<} 9{p_end}
{p2col : {cmdab:sty:le:(}{it:{help addedlinestyle}}{cmd:)}}
	overall style of added line{p_end}
{p2col : [{cmdab:no:}]{cmdab:ex:tend}}
	extend line through plot region's margins{p_end}
{p2col : {cmdab:lsty:le:(}{it:{help linestyle}}{cmd:)}}
	overall style of line{p_end}
{p2col : {cmdab:lp:attern:(}{it:{help linepatternstyle}}{cmd:)}}
	line pattern (solid, dashed, etc.){p_end}
{p2col : {cmdab:lw:idth:(}{it:{help linewidthstyle}}{cmd:)}}
	thickness of line{p_end}
{p2col : {cmdab:la:lign:(}{it:{help linealignmentstyle}}{cmd:)}}
        outline alignment (inside, outside, center){p_end}
{p2col : {cmdab:lc:olor:(}{it:{help colorstyle}}{cmd:)}}
	color and opacity of line{p_end}
{p2line}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:yline()}, {cmd:xline()}, and {cmd:tline()} are used with {cmd:twoway} to
add lines to the plot region.  {cmd:tline()} is an extension to {cmd:xline()};
see {manhelp tsline TS} for examples using {cmd:tline()}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 added_line_optionsQuickstart:Quick start}

        {mansection G-3 added_line_optionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt yline(linearg)}, {opt xline(linearg)}, and {opt tline(time_linearg)}
specify the {it:y}, {it:x}, and {it:t} (time) values where lines should be
added to the plot.


{marker suboptions}{...}
{title:Suboptions}

{phang}
{cmd:axis(}{it:#}{cmd:)}
    is for use only when multiple {it:y}, {it:x}, or {it:t} axes are being
    used (see {manhelpi axis_choice_options G-3}).  {cmd:axis()}
    specifies to which axis the {cmd:yline()}, {cmd:xline()}, or {cmd:tline()}
    is to be applied.

{phang}
{cmd:style(}{it:addedlinestyle}{cmd:)}
    specifies the overall style of the added line, which includes
    [{cmd:no}]{cmd:extend} and {cmd:lstyle(}{it:linestyle}{cmd:)}
    documented below.  See {manhelpi addedlinestyle G-4}.  The
    [{cmd:no}]{cmd:extend} and {cmd:lstyle()} options allow you to change the
    added line's attributes individually, but {cmd:style()} is the starting
    point.

{pmore}
    You need not specify {cmd:style()} just because there is something that
    you want to change, and in fact, most people seldom specify the
    {cmd:style()} option.  You specify {cmd:style()} when
    another style exists that is exactly what you desire or when another
    style would allow you to specify fewer changes to obtain what you want.

{phang}
{cmd:extend} and {cmd:noextend}
    specify whether the line should extend through the plot region's margin
    and touch the axis; see {manhelpi region_options G-3}.
    Usually {cmd:noextend} is the default, and {cmd:extend} is the option,
    but that is determined by the overall {cmd:style()} and, of course,
    the scheme; see {manhelp schemes_intro G-4:Schemes intro}.

{phang}
{cmd:lstyle(}{it:{help linestyle}}{cmd:)},
{cmd:lpattern(}{it:{help linepatternstyle}}{cmd:)},
{cmd:lwidth(}{it:{help linewidthstyle}}{cmd:)},
{cmd:lalign(}{it:{help linealignmentstyle}}{cmd:)},
and
{cmd:lcolor(}{it:{help colorstyle}}{cmd:)}
    specify the look of the line; see {manhelp line G-2:graph twoway line}.
    {cmd:lstyle()} can be of particular use:

{pmore}
To create a line with the same look as the lines used to draw
axes, specify {cmd:lstyle(foreground)}.

{pmore}
To create a line with the same look as the lines used to draw
grid lines, specify {cmd:lstyle(grid)}.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:yline()} and {cmd:xline()} add lines where specified.  If, however, your
interest is in obtaining grid lines, see the {cmd:grid} option in 
{manhelpi axis_label_options G-3}.

{pstd}
Remarks are presented under the following headings:

        {help added_line_options##remarks1:Typical use}
        {help added_line_options##remarks2:Interpretation of repeated options}


{marker remarks1}{...}
{title:Typical use}

{pstd}
{cmd:yline()} or {cmd:xline()} are typically used to add reference values:

	{cmd:. scatter yvar xvar, yline(10)}

	{cmd:. scatter yvar year, xline(1944 1989)}

{pstd}
To give the line in the first example the same look as used to
draw an axis, we could specify

{phang2}
	{cmd:. scatter yvar xvar, yline(10, lstyle(foreground))}

{pstd}
If we wanted to give the lines used in the second example the same look as used
to draw grids, we could specify

{phang2}
	{cmd:. scatter yvar year, xline(1944 1989, lstyle(grid))}


{marker remarks2}{...}
{title:Interpretation of repeated options}

{pstd}
Options {cmd:yline()} and {cmd:xline()} may be repeated, and each is executed
separately.  Thus different styles can be used for different lines on
the same graph:

{phang2}
	{cmd:. scatter yvar year, xline(1944) xline(1989, lwidth(3))}
{p_end}
