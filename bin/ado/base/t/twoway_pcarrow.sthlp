{smcl}
{* *! version 1.1.9  19oct2017}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway pcarrow" "mansection G-2 graphtwowaypcarrow"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway" "help twoway"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway pcarrowi" "help twoway_pcarrowi"}{...}
{vieweralsosee "[G-2] graph twoway pccapsym" "help twoway_pccapsym"}{...}
{vieweralsosee "[G-2] graph twoway pci" "help twoway_pci"}{...}
{vieweralsosee "[G-2] graph twoway pcscatter" "help twoway_pcscatter"}{...}
{vieweralsosee "[G-2] graph twoway pcspike" "help twoway_pcspike"}{...}
{viewerjumpto "Syntax" "twoway_pcarrow##syntax"}{...}
{viewerjumpto "Menu" "twoway_pcarrow##menu"}{...}
{viewerjumpto "Description" "twoway_pcarrow##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_pcarrow##linkspdf"}{...}
{viewerjumpto "Options" "twoway_pcarrow##options"}{...}
{viewerjumpto "Remarks" "twoway_pcarrow##remarks"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[G-2] graph twoway pcarrow} {hline 2}}Paired-coordinate plot with
	arrows{p_end}
{p2col:}({mansection G-2 graphtwowaypcarrow:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{* index twoway pcarrow tt}{...}
{* index paired-coordinate plots, pcarrow}{...}
{* index arrows}{...}
{* index barbsize tt}{...}
{* index mangle tt}{...}

{marker syntax}{...}
{title:Syntax}

{phang}Directional arrows

{p 8 60 2}
{cmdab:tw:oway}
{cmd:pcarrow} {space 1}{it:y1var} {it:x1var} {it:y2var} {it:x2var}
{ifin}
[{cmd:,}
{it:options}]


{phang}Bidirectional arrows

{p 8 60 2}
{cmdab:tw:oway}
{cmd:pcbarrow} {it:y1var} {it:x1var} {it:y2var} {it:x2var}
{ifin}
[{cmd:,}
{it:options}]


{synoptset 28}{...}
{p2col:{it:options}}Description{p_end}
{p2line}
{p2col:{cmdab:msty:le:(}{it:{help markerstyle}}{cmd:)}}overall style 
	of arrowhead{p_end}
{p2col:{cmdab:msiz:e:(}{it:{help markersizestyle}}{cmd:)}}size of 
	arrowhead{p_end}
{p2col:{cmdab:mang:le:(}{it:{help anglestyle}}{cmd:)}}angle of arrowhead{p_end}
{p2col:{cmdab:barb:size:(}{it:{help markersizestyle}}{cmd:)}}size of filled
	portion of arrowhead{p_end}
{p2col:{cmdab:mc:olor:(}{it:{help colorstyle}}{cmd:)}}color and opacity of
	arrowhead, inside and out{p_end}
{p2col:{cmdab:mfc:olor:(}{it:{help colorstyle}}{cmd:)}}arrowhead 
	"fill" color and opacity{p_end}
{p2col:{cmdab:mlc:olor:(}{it:{help colorstyle}}{cmd:)}}arrowhead outline 
	color and opacity{p_end}
{p2col:{cmdab:mlw:idth:(}{it:{help linewidthstyle}}{cmd:)}}arrowhead outline 
	thickness{p_end}
{p2col:{cmdab:mlsty:le:(}{it:{help linestyle}}{cmd:)}}thickness and 
	color{p_end}

{p2col:{it:{help line_options}}}change look of arrow shaft lines{p_end}

{p2col:{it:{help marker_label_options}}}add marker labels; 
	change look or position{p_end}
{p2col:{cmdab:head:label}}label head of arrow, not tail{p_end}

INCLUDE help gr_hvpcopt
INCLUDE help gr_axlnk

INCLUDE help gr_twopt
{p2line}
INCLUDE help gr_repopt1


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Twoway graph (scatter, line, etc.)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:twoway pcarrow} draws an arrow for each observation in the dataset.  The
arrow starts at the coordinate ({it:y1var},{it:x1var}) and ends at the
coordinate ({it:y2var},{it:x2var}), with an arrowhead drawn at the ending
coordinate.

{pstd}
{cmd:twoway pcbarrow} draws an arrowhead at each end; that is, it draws
bidirectional arrows.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowaypcarrowQuickstart:Quick start}

        {mansection G-2 graphtwowaypcarrowRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:mstyle(}{it:markerstyle}{cmd:)}
    specifies the overall look of arrowheads, including their size, 
    their color, etc.  The other options allow you to change each attribute of
    the arrowhead, but {cmd:mstyle()} is the point from which they start.

{pmore}
    You need not specify {cmd:mstyle()} just because 
    you want to change the look of the arrowhead.  In fact,
    most people seldom specify the {cmd:mstyle()} option.  You specify
    {cmd:mstyle()} when another style exists that is exactly what you
    desire or when another style would allow you to specify
    fewer changes to obtain what you want.

{pmore}
    {cmd:pcarrow} plots borrow their options and associated "look" from
    standard markers, so all its options begin with {cmd:m}.  See
    {manhelpi markerstyle G-4} for a list of available marker/arrowhead styles.

{phang}
{cmd:msize(}{it:markersizestyle}{cmd:)} specifies the size of 
    arrowheads.
    See {manhelpi markersizestyle G-4} for a list of size choices.

{phang}
{cmd:mangle(}{it:anglestyle}{cmd:)} specifies the angle that each side of an
    arrowhead forms with the arrow's line.  For most schemes, the default
    angle is 28.64.

{phang}
{cmd:barbsize(}{it:markersizestyle}{cmd:)} specifies the portion of the
    arrowhead that is to be filled.  {cmd:barbsize(0)} specifies that just the
    lines for the arrowhead be drawn.  When {cmd:barbsize()} is equal to
    {cmd:msize()}, the arrowhead is filled to a right angle with the arrow
    line.  The effect of {cmd:barbsize()} is easier to see than to describe;
    {stata gr_example2 barbsize:click here} to see a graph with examples.

{phang}
{cmd:mcolor(}{it:colorstyle}{cmd:)} specifies the color of the arrowhead.
    This option sets the color and opacity of both the line used to outline
    the arrowhead and the inside of the arrowhead.  Also
    see options {cmd:mfcolor()} and {cmd:mlcolor()} below.
    See {manhelpi colorstyle G-4} for a list of color choices.

{phang}
{cmd:mfcolor(}{it:colorstyle}{cmd:)}
    specifies the color and opacity of the inside of the arrowhead.
    See {manhelpi colorstyle G-4} for a list of color choices.

{phang}
{cmd:mlstyle(}{it:linestyle}{cmd:)},
{cmd:mlwidth(}{it:linewidthstyle}{cmd:)}, and
{cmd:mlcolor(}{it:colorstyle}{cmd:)}
    specify the look of the line used to outline the 
    arrowhead.  See {help lines}, but you cannot change the line
    pattern of an arrowhead.

{phang}
{it:line_options} 
    specify the look of the lines used to draw the shaft of the arrow,
    including pattern, width, and color; see {manhelpi line_options G-3}.

{phang}
{it:marker_label_options}
    specify if and how the arrows are to be labeled.  By default, the labels
    are placed at the tail of the arrow, the point defined by {it:y1var} and
    {it:x1var}.  See {manhelpi marker_label_options G-3} for options that change
    the look of the labels.

{phang}
{cmd:headlabel} specifies that labels be drawn at the arrowhead,
        the ({it:y2var},{it:x2var}) points rather than at the tail of the
        arrow, the ({it:y1var},{it:x1var}) points.  By default, when the
        {cmd:mlabel()} option is specified, labels are placed at the tail of
        the arrows; {cmd:headlabel} moves the labels from the tail to the
	head.

INCLUDE help gr_hvpcoptf

INCLUDE help gr_axlnkf

INCLUDE help gr_twoptf


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help twoway_pcarrow##basic_use:Basic use}
	{help twoway_pcarrow##advanced_use:Advanced use}


{marker basic_use}{...}
{title:Basic use}

{pstd}
We have longitudinal data from 1968 and 1988 on the earnings and total
experience of U.S. women by occupation.
We will input data for two arrows, both originating at (0,0) and extending at
right angles from each other, and plot them.

{cmd}{...}
	. input y1 x1 y2 x2
	  1.     0  0  0  1
	  2.     0  0  1  0
	  3. end

	. twoway pcarrow y1 x1 y2 x2
{text}{...}
	  {it:({stata "gr_example2 pcarrow1":click to run})}

{pstd}
We could add labels to the heads of the arrows while also adding a little room
in the plot region and constraining the plot region to be square:

{cmd}{...}
	. drop _all

	. input y1 x1 y2 x2 str10 time   pos
	  1.     0  0  0  1 "3 o'clock"    3
	  2.     0  0  1  0 "12 o'clock"  12
	  3. end

	. twoway pcarrow y1 x1 y2 x2, aspect(1) mlabel(time) headlabel
			       mlabvposition(pos) plotregion(margin(vlarge))
{text}{...}
	  {it:({stata "gr_example2 pcarrow1b":click to run})}

{pstd}
For examples of arrows in graphing multivariate results, see
{manhelp biplot MV}.


{marker advanced_use}{...}
{title:Advanced use}

{pstd}
As with many {cmd:twoway} plottypes, {cmd:pcarrow} and {cmd:pcbarrow} can be
usefully combined with other {helpb twoway} plottypes.  Here a {cmd:scatter}
plot is used to label ranges drawn by {cmd:pcbarrow} (though admittedly the
ranges might better be represented using {cmd:twoway rcap}).

{cmd}{...}
	. sysuse nlsw88, clear

	. keep if occupation <= 8

	. collapse (p05) p05=wage (p95) p95=wage (p50) p50=wage, by(occupation)
	. gen mid = (p05 + p95) / 2
	. gen dif = (p95 - p05)
	. gsort -dif
	. gen srt = _n

	. twoway pcbarrow srt p05 srt p95 ||
                 scatter  srt mid, msymbol(i) mlabel(occupation)
       			           mlabpos(12) mlabcolor(black)
		plotregion(margin(t=5)) yscale(off)
		ylabel(, nogrid) legend(off)
		ytitle(Hourly wages)
		title("90 Percentile Range of US Women's Wages by Occupation")
		note("Source: National Longitudinal Survey of Young Women")
{txt}{...}
	  {it:({stata "gr_example2 pcarrow2":click to run})}
