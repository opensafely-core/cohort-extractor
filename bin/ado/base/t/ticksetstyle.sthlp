{smcl}
{* *! version 1.1.6  19oct2017}{...}
{vieweralsosee "[G-4] ticksetstyle" "mansection G-4 ticksetstyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] gridstyle" "help gridstyle"}{...}
{vieweralsosee "[G-4] tickstyle" "help tickstyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{viewerjumpto "Syntax" "ticksetstyle##syntax"}{...}
{viewerjumpto "Description" "ticksetstyle##description"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[G-4]} {it:ticksetstyle} {hline 2}}Choices for overall look of axis ticks{p_end}
{p2col:}({mansection G-4 ticksetstyle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 25}{...}
{p2col:{it:ticksetstyle}}Description{p_end}
{p2line}
{p2col:{cmd:major_horiz_default}}default major tickset for horizontal axes,
        including both ticks and labels but no grid{p_end}
{p2col:{cmd:major_horiz_withgrid}}major tickset for horizontal axes,
        including a grid{p_end}
{p2col:{cmd:major_horiz_nolabel}}major tickset for horizontal axes,
        including ticks but not labels{p_end}
{p2col:{cmd:major_horiz_notick}}major tickset for horizontal axes,
        including labels but not ticks{p_end}

{p2col:{cmd:major_vert_default}}default major tickset for vertical axes,
        including both ticks and labels but no grid{p_end}
{p2col:{cmd:major_vert_withgrid}}major tickset for vertical axes,
        including a grid{p_end}
{p2col:{cmd:major_vert_nolabel}}major tickset for vertical axes,
        including ticks but not labels{p_end}
{p2col:{cmd:major_vert_notick}}major tickset for vertical axes,
        including labels but not ticks{p_end}

{p2col:{cmd:minor_horiz_default}}default minor tickset for horizontal axes,
        including both ticks and labels but no grid{p_end}
{p2col:{cmd:minor_horiz_nolabel}}minor tickset for horizontal axes,
        including ticks but not labels{p_end}
{p2col:{cmd:minor_horiz_notick}}minor tickset for horizontal axes,
        including labels but not ticks{p_end}

{p2col:{cmd:minor_vert_default}}vertical axes default,
        having both ticks and labels but no grid{p_end}
{p2col:{cmd:minor_vert_nolabel}}minor tickset for vertical axes,
        including ticks but not labels{p_end}
{p2col:{cmd:minor_vert_notick}}minor tickset for vertical axes,
        including labels but not ticks{p_end}
{p2line}
{p2colreset}{...}

{pstd}
Other {it:ticksetstyles} may be available; type

	    {cmd:.} {bf:{stata graph query ticksetstyle}}

{pstd}
to obtain the complete list of {it:ticksetstyles} installed on your computer.


{marker description}{...}
{title:Description}

{pstd}
Tickset styles are used only in scheme files (see {help scheme files}) and
are not accessible from {helpb graph} commands.

{pstd}
{it:ticksetstyle} is a composite style that holds and sets all attributes of a
set of ticks on an axis, including the look of ticks and tick labels 
(see {manhelp tickstyle G-4}), the default number of ticks, the angle of the
ticks, whether the labels for the ticks alternate their distance from the axis
and the size of that alternate distance, the {it:gridstyle} (see
{manhelpi gridstyle G-4}) if a grid is associated with the tickset, and whether
ticks are labeled.
{p_end}
