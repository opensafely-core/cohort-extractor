{smcl}
{* *! version 1.1.5  19oct2017}{...}
{vieweralsosee "[G-3] aspect_option" "mansection G-3 aspect_option"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph bar" "help graph_bar"}{...}
{vieweralsosee "[G-2] graph box" "help graph_box"}{...}
{vieweralsosee "[G-2] graph dot" "help graph_dot"}{...}
{vieweralsosee "[G-2] graph twoway" "help twoway"}{...}
{viewerjumpto "Syntax" "aspect_option##syntax"}{...}
{viewerjumpto "Description" "aspect_option##description"}{...}
{viewerjumpto "Links to PDF documentation" "aspect_option##linkspdf"}{...}
{viewerjumpto "Option" "aspect_option##option"}{...}
{viewerjumpto "Suboption" "aspect_option##suboption"}{...}
{viewerjumpto "Remarks" "aspect_option##remarks"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[G-3]} {it:aspect_option} {hline 2}}Option for controlling the aspect ratio of the plot region{p_end}
{p2col:}({mansection G-3 aspect_option:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 30}{...}
{p2col : {it:aspect_option}}Description{p_end}
{p2line}
{p2col : {cmdab:aspect:ratio:(}{it:#} [{cmd:,} {it:pos_option}]{cmd:)}}set
       plot region aspect ratio to {it:#}{p_end}
{p2line}

{p2col : {it:pos_option}}Description{p_end}
{p2line}
{p2col : {cmdab:place:ment:(}{it:{help compassdirstyle}}{cmd:)}}placement of
       plot region{p_end}
{p2line}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The {cmd:aspectratio()} option controls the relationship between
the height and width of a graph's plot region.  For example, when {it:#}=1,
the height and width will be equal (their ratio is 1), and the plot region
will be square.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 aspect_optionQuickstart:Quick start}

        {mansection G-3 aspect_optionRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
    {cmd:aspectratio(}{it:#} [{cmd:,} {it:pos_option}]{cmd:)} specifies the
    aspect ratio and, optionally, the placement of the plot region.


{marker suboption}{...}
{title:Suboption}

{phang}
    {cmd:placement(}{it:compassdirstyle}{cmd:)} specifies where the
    plot region is to be placed to take up the area left over by
    restricting the aspect ratio.  See {manhelpi compassdirstyle G-4}.


{marker remarks}{...}
{title:Remarks}

{pstd}
The {cmd:aspectratio(}{it:#}{cmd:)} option constrains the ratio of the
plot region to {it:#}.  So, if {it:#} is 1, the plot region is square; if it
is 2, the plot region is twice as tall as it is wide; and, if it is .25, the
plot region is one-fourth as tall as it is wide.  The most common use is
{cmd:aspectratio(1)}, which produces a square plot region.

{pstd}
The overall size of the graph is not changed by the
{cmd:aspectratio()} option.  Thus constraining the aspect ratio will
generally leave some additional space around the plot region in either the
horizontal or vertical dimension.  By default, the plot region will be
centered in this space, but you can use the {cmd:placement()} option to control
where the plot region is located.  {cmd:placement(right)} will place the plot
region all the way to the right in the extra space, leaving all the blank
space to the left; {cmd:placement(top)} will place the plot region at the top
of the extra space, leaving all the blank space at the bottom; 
{cmd:placement(left)} and {cmd:placement(right)} work similarly.

{pstd}
Specifying an aspect ratio larger than the default for a graph causes the
width of the plot region to become narrower.  Conversely, specifying a small
aspect ratio causes the plot region to become shorter.  Because titles and
legends can be wider than the plot region, and because most {help schemes} do
not allow titles and legends to span beyond the width of the plot region, this
can sometimes lead to surprising spacing of some graph elements; for
example, axes may be forced away from their plot region.  If this occurs, the
spacing can be improved by adding the {cmd:span} suboption to the
{helpb title_options:title()}, {helpb title_options:subtitle()},
{helpb legend_options:legend()}, or other options.  The
{cmd:span} option must be added to each element that is wider than the plot
region.  See {it:{help title_options##remarks5:Spanning}} in
{manhelpi title_options G-3} for a diagram.
{p_end}
