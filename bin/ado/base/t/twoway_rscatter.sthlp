{smcl}
{* *! version 1.1.8  19oct2017}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway rscatter" "mansection G-2 graphtwowayrscatter"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway rarea" "help twoway_rarea"}{...}
{vieweralsosee "[G-2] graph twoway rbar" "help twoway_rbar"}{...}
{vieweralsosee "[G-2] graph twoway rcap" "help twoway_rcap"}{...}
{vieweralsosee "[G-2] graph twoway rcapsym" "help twoway_rcapsym"}{...}
{vieweralsosee "[G-2] graph twoway rconnected" "help twoway_rconnected"}{...}
{vieweralsosee "[G-2] graph twoway rline" "help twoway_rline"}{...}
{vieweralsosee "[G-2] graph twoway rspike" "help twoway_rspike"}{...}
{viewerjumpto "Syntax" "twoway_rscatter##syntax"}{...}
{viewerjumpto "Menu" "twoway_rscatter##menu"}{...}
{viewerjumpto "Description" "twoway_rscatter##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_rscatter##linkspdf"}{...}
{viewerjumpto "Options" "twoway_rscatter##options"}{...}
{viewerjumpto "Remarks" "twoway_rscatter##remarks"}{...}
{p2colset 1 32 34 2}{...}
{p2col:{bf:[G-2] graph twoway rscatter} {hline 2}}Range plot with markers{p_end}
{p2col:}({mansection G-2 graphtwowayrscatter:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 24 2}
{cmdab:tw:oway}
{cmdab:rsc:atter}
{it:y1var} {it:y2var} {it:xvar}
{ifin}
[{cmd:,}
{it:options}]

{synoptset 22}{...}
{p2col: {it:options}}Description{p_end}
{p2line}
{p2col: {cmdab:vert:ical}}vertical plot; the default{p_end}
{p2col: {cmdab:hor:izontal}}horizontal plot{p_end}

INCLUDE help gr_markopt

INCLUDE help gr_axlnk

INCLUDE help gr_twopt
{p2line}
{p2colreset}{...}
{p 4 6 2}
All explicit options are {it:rightmost}; see {help repeated options}.


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
{cmd:twoway} {cmd:rscatter} plots the upper and lower ranges as scatters.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowayrscatterQuickstart:Quick start}

        {mansection G-2 graphtwowayrscatterRemarksandexamples:Remarks and examples}

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

{pmore}
    In the default {cmd:vertical} case, {it:y1var} and {it:y2var} record the
    minimum and maximum (or maximum and minimum) {it:y} values to be
    graphed against each {it:xvar} value.

{pmore}
    If {cmd:horizontal} is specified, the values recorded in {it:y1var} and
    {it:y2var} are plotted in the {it:x} direction and {it:xvar} is treated
    as the {it:y} value.

{phang}
{it:marker_options}
    specify how the markers look, including
    shape, size, color, and outline;
    see {manhelpi marker_options G-3}.  The same marker is used for both points.

{phang}
{it:marker_label_options}
    specify if and how the markers are to be labeled.  Because
    the same marker label would be used to label both points,
    these options are of limited use in this case.
    See {manhelpi marker_label_options G-3}.

INCLUDE help gr_axlnkf

INCLUDE help gr_twoptf


{marker remarks}{...}
{title:Remarks}

{pstd}
Visually, there is no difference between

	{cmd:. twoway rscatter} {it:y1var} {it:y2var} {it:xvar}

{pstd}
and

	{cmd:. twoway scatter} {it:y1var} {it:xvar} {cmd:||} {...}
{cmd:scatter} {it:y2var} {it:xvar}{cmd:, pstyle(p1)}

{pstd}
The two scatters are presented in the same overall style,
meaning that the markers (symbol shape and color)
are the same.
{p_end}
