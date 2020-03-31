{smcl}
{* *! version 1.1.8  15may2018}{...}
{vieweralsosee "[G-3] line_options" "mansection G-3 line_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] Concept: lines" "help lines"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph dot" "help graph_dot"}{...}
{viewerjumpto "Syntax" "line_options##syntax"}{...}
{viewerjumpto "Description" "line_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "line_options##linkspdf"}{...}
{viewerjumpto "Options" "line_options##options"}{...}
{viewerjumpto "Remarks" "line_options##remarks"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[G-3]} {it:line_options} {hline 2}}Options for determining the look
of lines{p_end}
{p2col:}({mansection G-3 line_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 30}{...}
{p2col:{it:line_options}}Description{p_end}
{p2line}
{p2col:{cmdab:lp:attern:(}{it:{help linepatternstyle}}{cmd:)}}whether line
      solid, dashed, etc.{p_end}
{p2col:{cmdab:lw:idth:(}{it:{help linewidthstyle}}{cmd:)}}thickness of
      line{p_end}
{p2col:{cmdab:lc:olor:(}{it:{help colorstyle}}{cmd:)}}color and opacity of line{p_end}
{p2col : {cmdab:la:lign:(}{it:{help linealignmentstyle}}{cmd:)}}line
	alignment (inside, outside, center){p_end}

{p2col:{cmdab:lsty:le:(}{it:{help linestyle}}{cmd:)}}overall style of line
     {p_end}
{p2col:{cmdab:psty:le:(}{it:{help pstyle}}{cmd:)}}overall plot style,
      including linestyle{p_end}
{p2line}
{p2colreset}{...}
{p 4 6 2}
All options are {it:rightmost}; see {help repeated options}.


{marker description}{...}
{title:Description}

{pstd}
The {it:line_options} determine the look of a line in most contexts.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 line_optionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:lpattern(}{it:linepatternstyle}{cmd:)}
    specifies whether the line is solid, dashed, etc.
    See {manhelpi linepatternstyle G-4} for a list of available patterns.
    {cmd:lpattern()} is not allowed with {cmd:graph} {cmd:pie};
    see {manhelp graph_pie G-2:graph pie}.

{phang}
{cmd:lwidth(}{it:linewidthstyle}{cmd:)}
    specifies the thickness of the line.
    See {manhelpi linewidthstyle G-4} for a list of available thicknesses.

{phang}
{cmd:lcolor(}{it:colorstyle}{cmd:)}
    specifies the color and opacity of the line.
    See {manhelpi colorstyle G-4} for a list of available colors.

{phang}
{cmd:lalign(}{it:linealignmentstyle}{cmd:)}
    specifies whether the line is drawn inside, is drawn outside, is
    or centered on the outline of markers, fill areas, bars, and boxes.
    See {manhelpi linealignmentstyle G-4} for a list of alignment choices.

{phang}
{cmd:lstyle(}{it:linestyle}{cmd:)}
    specifies the overall style of the line:  its pattern, thickness,
    color, and alignment.

{pmore}
    You need not specify {cmd:lstyle()} just because there is something
    you want to change about the look of the line.  The other
    {it:line_options} will allow you to make changes.  You specify
    {cmd:lstyle()} when another style exists that is exactly what you
    desire or when another style would allow you to specify fewer changes.

{pmore}
    See {manhelpi linestyle G-4} for a list of available line styles.

{phang}
{cmd:pstyle(}{it:pstyle}{cmd:)}
    specifies the overall style of the plot, including not only the
    {it:{help linestyle}}, but also all other settings for the look of the plot.
    Only the {it:linestyle} affects the look of lines.  See
    {manhelpi pstyle G-4} for a list of available plot styles.


{marker remarks}{...}
{title:Remarks}

{pstd}
Lines occur in many contexts and, in some of those contexts, the above
options are used to determine the look of the line.  For instance, the
{cmd:lcolor()} option in

{phang2}
	{cmd:. graph line y x, lcolor(red)}

{pstd}
causes the line through the ({cmd:y},{cmd:x}) points to be drawn in red.

{pstd}
The same option in the following

	{cmd:. graph line y x, title("My line", box lcolor(red))}

{pstd}
causes the outline drawn around the title's box to be drawn in red.  
In the second command, the option {cmd:lcolor(red)} was a suboption to the
{cmd:title()} option.
{p_end}
