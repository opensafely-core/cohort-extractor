{smcl}
{* *! version 1.1.8  19oct2017}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway rconnected" "mansection G-2 graphtwowayrconnected"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway rarea" "help twoway_rarea"}{...}
{vieweralsosee "[G-2] graph twoway rbar" "help twoway_rbar"}{...}
{vieweralsosee "[G-2] graph twoway rcap" "help twoway_rcap"}{...}
{vieweralsosee "[G-2] graph twoway rcapsym" "help twoway_rcapsym"}{...}
{vieweralsosee "[G-2] graph twoway rline" "help twoway_rline"}{...}
{vieweralsosee "[G-2] graph twoway rscatter" "help twoway_rscatter"}{...}
{vieweralsosee "[G-2] graph twoway rspike" "help twoway_rspike"}{...}
{viewerjumpto "Syntax" "twoway_rconnected##syntax"}{...}
{viewerjumpto "Menu" "twoway_rconnected##menu"}{...}
{viewerjumpto "Description" "twoway_rconnected##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_rconnected##linkspdf"}{...}
{viewerjumpto "Options" "twoway_rconnected##options"}{...}
{viewerjumpto "Remarks" "twoway_rconnected##remarks"}{...}
{p2colset 1 34 6 2}{...}
{p2col:{bf:[G-2] graph twoway rconnected} {hline 2}}Range plot with connected lines{p_end}
{p2col:}({mansection G-2 graphtwowayrconnected:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 26 2}
{cmdab:tw:oway}
{cmdab:rcon:nected}
{it:y1var} {it:y2var} {it:xvar}
{ifin}
[{cmd:,}
{it:options}]

{synoptset 22}{...}
{p2col: {it:options}}Description{p_end}
{p2line}
{p2col: {cmdab:vert:ical}}vertical plot; the default{p_end}
{p2col: {cmdab:hor:izontal}}horizontal plot{p_end}

{p2col:{it:{help connect_options}}}change rendition of lines connecting points{p_end}
INCLUDE help gr_markopt

INCLUDE help gr_axlnk

INCLUDE help gr_twopt
{p2line}
{p2colreset}{...}
{p 4 6 2}
All explicit options are {it:rightmost}, except {cmd:vertical}
and {cmd:horizontal}, which are {it:unique}; see {help repeated options}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Twoway graph (scatter, line, etc.)}


{marker description}{...}
{title:Description}

{pstd}
A range plot has two {it:y} variables, such as high and low daily stock prices
or upper and lower 95% confidence limits.

{pstd}
{cmd:twoway} {cmd:rconnected} plots the upper and lower ranges by using
connected lines.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowayrconnectedQuickstart:Quick start}

        {mansection G-2 graphtwowayrconnectedRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:vertical}
and
{cmd:horizontal}
    specify whether the high and low {it:y} values are to be presented
    vertically (the default) or horizontally.

{p 8 8 2}
    In the default {cmd:vertical} case, {it:y1var} and {it:y2var} record the
    minimum and maximum (or maximum and minimum) {it:y} values to be
    graphed against each {it:xvar} value.

{p 8 8 2}
    If {cmd:horizontal} is specified, the values recorded in {it:y1var} and
    {it:y2var} are plotted in the {it:x} direction and {it:xvar} is treated
    as the {it:y} value.

{phang}
{it:connect_options}
    change the rendition of the lines connecting the plotted points, including
    sorting, handling missing observations, and the look of the line --  
    line thickness, pattern, and color.  For details, see 
    {manhelpi connect_options G-3}.

{phang}
{it:marker_options}
    specify how the markers look, including
    shape, size, color, and outline;
    see {manhelpi marker_options G-3}.  The same marker is used for both lines.

{phang}
{it:marker_label_options}
    specify if and how the markers are to be labeled.  Because
    the same marker label would be used to label both lines,
    these options are of limited use here.
    See {manhelpi marker_label_options G-3}.

INCLUDE help gr_axlnkf

INCLUDE help gr_twoptf


{marker remarks}{...}
{title:Remarks}

{pstd}
Visually, there is no difference between

{phang2}
	{cmd:. twoway rconnected} {it:y1var} {it:y2var} {it:xvar}

{pstd}
and

{phang2}
	{cmd:. twoway connected} {it:y1var} {it:xvar} {cmd:||}
		{cmd:connected} {it:y2var} {it:xvar}{cmd:, pstyle(p1)}

{pstd}
The two connected lines are presented in the same overall style,
meaning symbol selection and color and line
color, thickness, and pattern.
{p_end}
