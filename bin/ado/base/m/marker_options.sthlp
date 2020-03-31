{smcl}
{* *! version 1.1.8  19oct2017}{...}
{vieweralsosee "[G-3] marker_options" "mansection G-3 marker_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] anglestyle" "help anglestyle"}{...}
{vieweralsosee "[G-4] colorstyle" "help colorstyle"}{...}
{vieweralsosee "[G-4] linealignmentstyle" "help linealignmentstyle"}{...}
{vieweralsosee "[G-4] linestyle" "help linestyle"}{...}
{vieweralsosee "[G-4] linewidthstyle" "help linewidthstyle"}{...}
{vieweralsosee "[G-4] markersizestyle" "help markersizestyle"}{...}
{vieweralsosee "[G-4] symbolstyle" "help symbolstyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] markerstyle" "help markerstyle"}{...}
{viewerjumpto "Syntax" "marker_options##syntax"}{...}
{viewerjumpto "Description" "marker_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "marker_options##linkspdf"}{...}
{viewerjumpto "Options" "marker_options##options"}{...}
{viewerjumpto "Remarks" "marker_options##remarks"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[G-3]} {it:marker_options} {hline 2}}Options for specifying markers{p_end}
{p2col:}({mansection G-3 marker_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 30}{...}
{p2col:{it:marker_options}}Description{p_end}
{p2line}
{p2col:{cmdab:m:symbol:(}{it:{help symbolstyle}}{cmd:)}}shape of marker{p_end}
{p2col:{cmdab:mc:olor:(}{it:{help colorstyle}}{cmd:)}}color and opacity of marker, inside
       and out{p_end}
{p2col:{cmdab:msiz:e:(}{it:{help markersizestyle}}{cmd:)}}size of marker{p_end}

{p2col:{cmdab:msa:ngle:(}{it:{help anglestyle}}{cmd:)}}angle of marker symbol{p_end}

{p2col:{cmdab:mfc:olor:(}{it:{help colorstyle}}{cmd:)}}inside or "fill" color
	and opacity{p_end}

{p2col:{cmdab:mlc:olor:(}{it:{help colorstyle}}{cmd:)}}outline color and
	opacity{p_end}
{p2col:{cmdab:mlw:idth:(}{it:{help linewidthstyle}}{cmd:)}}outline thickness
      {p_end}
{p2col : {cmdab:mla:lign:(}{it:{help linealignmentstyle}}{cmd:)}}outline
	alignment (inside, outside, center){p_end}
{p2col:{cmdab:mlsty:le:(}{it:{help linestyle}}{cmd:)}}thickness and color,
       overall style of outline{p_end}

{p2col:{cmdab:msty:le:(}{it:{help markerstyle}}{cmd:)}}overall style of
       marker; all settings above{p_end}
{p2col:{cmdab:psty:le:(}{it:{help pstyle}}{cmd:)}}overall plot style,
       including markerstyle{p_end}

{p2col:{help advanced_options:{bf:recast(}{it:newplottype}{bf:)}}}advanced;
        treat plot as {it:newplottype}{p_end}
{p2line}
{p2colreset}{...}
{p 4 6 2}
All options are {it:rightmost}; see {help repeated options}.

{pstd}
One example of each of the above is{cmd}

	    msymbol(O)       mfcolor(red)    mlcolor(olive)       mstyle(p1)
	    mcolor(green)                    mlwidth(thick)       mlstyle(p1)
	    msize(medium)                    mlalign(inside)
	    msangle(0){txt}

{pstd}
Sometimes you may specify a list of elements, with the first element
applying to the first variable, the second to the second, and
so on.  See, for instance, {manhelp scatter G-2:graph twoway scatter}.  One
example would be

	    {cmd:msymbol(O o p)}
	    {cmd:mcolor(green blue black)}
	    {cmd:msize(medium medium small)}
	    {cmd:msangle(0 15 30)}

	    {cmd:mfcolor(red red none)}

	    {cmd:mlcolor(olive olive green)}
	    {cmd:mlwidth(thick thin thick)}
	    {cmd:mlalign(inside outside center)}

	    {cmd:mstyle(p1 p2 p3)}
	    {cmd:mlstyle(p1 p2 p3)}

{pstd}
For information about specifying lists, see {manhelpi stylelists G-4}.


{marker description}{...}
{title:Description}

{pstd}
Markers are the ink used to mark where points are on a plot.
The important options are

	{cmd:msymbol(}{it:{help symbolstyle}}{cmd:)}                (choice of symbol)
	{cmd:mcolor(}{it:{help colorstyle}}{cmd:)}                  (choice of color and opacity)
	{cmd:msize(}{it:{help markersizestyle}}{cmd:)}              (choice of size)


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 marker_optionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:msymbol(}{it:symbolstyle}{cmd:)} specifies the shape of the marker
    and is one of the more commonly specified options.
    See {manhelpi symbolstyle G-4} for more information on this important
    option.

{phang}
{cmd:mcolor(}{it:colorstyle}{cmd:)} specifies the color and opacity of the
    marker.  This option sets both the color of the line used to outline the
    markers shape and the color of the inside of the marker.  Also
    see options {cmd:mfcolor()} and {cmd:mlcolor()} below.
    See {manhelpi colorstyle G-4} for a list of color choices.

{phang}
{cmd:msize(}{it:markersizestyle}{cmd:)} specifies the size of the
    marker.
    See {manhelpi markersizestyle G-4} for a list of size choices.

{phang}
{cmd:msangle(}{it:anglestyle}{cmd:)} specifies the angle of the
    marker symbol.
    See {manhelpi anglestyle G-4} for a list of angle choices.

{phang}
{cmd:mfcolor(}{it:colorstyle}{cmd:)}
    specifies the color and opacity of the inside of the marker.
    See {manhelpi colorstyle G-4} for a list of color choices.

{phang}
{cmd:mlcolor(}{it:colorstyle}{cmd:)},
{cmd:mlwidth(}{it:linewidthstyle}{cmd:)},
{cmd:mlalign(}{it:linealignmentstyle}{cmd:)},
and
{cmd:mlstyle(}{it:linestyle}{cmd:)}
    specify the look of the line used to outline the shape of the
    marker.  See {help lines}, but you cannot change the line
    pattern of a marker.

{phang}
{cmd:mstyle(}{it:markerstyle}{cmd:)}
    specifies the overall look of markers, such as their shape and
    their color.  The other options allow you to change each attribute of
    the marker, but {cmd:mstyle()} is a starting point.

{pmore}
    You need not specify {cmd:mstyle()} just because there is something
    you want to change about the look of the marker and, in fact,
    most people seldom specify the {cmd:mstyle()} option.  You specify
    {cmd:mstyle()} when another style exists that is exactly what you
    desire or when another style would allow you to specify
    fewer changes to obtain what you want.

{pmore}
    See {manhelpi markerstyle G-4} for a list of available marker styles.

{phang}
{cmd:pstyle(}{it:pstyle}{cmd:)}
    specifies the overall style of the plot, including not only the
    {it:{help markerstyle}}, but also the {it:{help markerlabelstyle}} and all
    other settings for the look of the plot.  Only the {it:markerstyle} and
    {it:markerlabelstyle} affect the look of markers.  See
    {manhelpi pstyle G-4} for a list of available plot styles.

{phang}
{cmd:recast(}{it:newplottype}{cmd:)}
        is an advanced option allowing the plot to be recast from one type to
        another, for example, from a {help twoway scatter:scatterplot} to
        a {help twoway line:line plot}; see 
        {manhelpi advanced_options G-3}.  Most, but not all, plots allow
        {cmd:recast()}.


{marker remarks}{...}
{title:Remarks}

{pstd}
You will never need to specify all nine marker options, and seldom will you
even need to specify more than one or two of them.  Many people think
that there is just one important marker option,

	{cmd:msymbol(}{it:symbolstyle}{cmd:)}

{pstd}
{cmd:msymbol()} specifies the shape of the symbol; see
{manhelpi symbolstyle G-4} for choice of symbol.
A few people would add to the important list a second option,

	{cmd:mcolor(}{it:colorstyle}{cmd:)}

{pstd}
{cmd:mcolor()} specifies the marker's color and opacity;
see {manhelpi colorstyle G-4} for choice of color.
Finally, a few would add

	{cmd:msize(}{it:markersizestyle}{cmd:)}

{pstd}
{cmd:msize()} specifies the marker's size; see {manhelpi markersizestyle G-4}
for choice of sizes.

{pstd}
After that, we are really into the details.  One of the remaining options,
however, is of interest:

	{cmd:mstyle(}{it:markerstyle}{cmd:)}

{pstd}
A marker has a set of characteristics:

	{c -(}shape, color, size, inside details, outside details{c )-}

{pstd}
Each of the options other than {cmd:mstyle()} modifies something in that set.
{cmd:mstyle()} sets the values of the entire set.  It is from there that the
changes you specify are made.  See {manhelpi markerstyle G-4}.
{p_end}
