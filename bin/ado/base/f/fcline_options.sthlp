{smcl}
{* *! version 1.1.6  19oct2017}{...}
{vieweralsosee "[G-3] fcline_options" "mansection G-3 fcline_options"}{...}
{viewerjumpto "Syntax" "fcline_options##syntax"}{...}
{viewerjumpto "Description" "fcline_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "fcline_options##linkspdf"}{...}
{viewerjumpto "Options" "fcline_options##options"}{...}
{viewerjumpto "Remarks" "fcline_options##remarks"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[G-3]} {it:fcline_options} {hline 2}}Options for determining the look of fitted connecting lines{p_end}
{p2col:}({mansection G-3 fcline_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 30}{...}
{p2col:{it:fcline_options}}Description{p_end}
{p2line}
{p2col:{cmdab:clp:attern:(}{it:{help linepatternstyle}}{cmd:)}}whether line
      solid, dashed, etc.{p_end}
{p2col:{cmdab:clw:idth:(}{it:{help linewidthstyle}}{cmd:)}}thickness of line
     {p_end}
{p2col:{cmdab:clc:olor:(}{it:{help colorstyle}}{cmd:)}}color and opacity of line{p_end}

{p2col:{cmdab:clsty:le:(}{it:{help linestyle}}{cmd:)}}overall style of line
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
The {it:fcline_options} determine the look of a fitted connecting line in most
contexts.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 fcline_optionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:clpattern(}{it:linepatternstyle}{cmd:)}
    specifies whether the line is solid, dashed, etc.
    See {manhelpi linepatternstyle G-4} for a list of available patterns.

{phang}
{cmd:clwidth(}{it:linewidthstyle}{cmd:)}
    specifies the thickness of the line.
    See {manhelpi linewidthstyle G-4} for a list of available thicknesses.

{phang}
{cmd:clcolor(}{it:colorstyle}{cmd:)}
    specifies the color and opacity of the line.
    See {manhelpi colorstyle G-4} for a list of available colors.

{phang}
{cmd:clstyle(}{it:linestyle}{cmd:)}
    specifies the overall style of the line:  its pattern, thickness, and
    color.

{pmore}
    You need not specify {cmd:clstyle()} just because there is something
    you want to change about the look of the line.  The other
    {it:fcline_options} will allow you to make changes.  You specify
    {cmd:clstyle()} when another style exists that is exactly what you
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
Lines occur in many contexts and, in almost all of those contexts, the above
options are used to determine the look of the fitted connecting line.  For
instance, the {cmd:clcolor()} option in

{phang2}
	{cmd:. twoway lfitci y x, clcolor(red)}

{pstd}
causes the line through the ({cmd:y},{cmd:x}) points to be drawn in red.

{pstd}
The same option in

	{cmd:. twoway lfitci y x, title("My line", box clcolor(red))}

{pstd}
causes the outline drawn around the title's box to be drawn in red.  
In the second command, the option {cmd:clcolor(red)} was a suboption to the
{cmd:title()} option.
{p_end}
