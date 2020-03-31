{smcl}
{* *! version 1.0.15  19oct2017}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway contourline" "mansection G-2 graphtwowaycontourline"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway contour" "help twoway_contour"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway line" "help twoway_line"}{...}
{vieweralsosee "[G-2] graph twoway connected" "help twoway_connected"}{...}
{viewerjumpto "Syntax" "twoway_contourline##syntax"}{...}
{viewerjumpto "Menu" "twoway_contourline##menu"}{...}
{viewerjumpto "Description" "twoway_contourline##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_contourline##linkspdf"}{...}
{viewerjumpto "Options" "twoway_contourline##options"}{...}
{viewerjumpto "Remarks" "twoway_contourline##remarks"}{...}
{p2colset 1 35 37 2}{...}
{p2col:{bf:[G-2] graph twoway contourline} {hline 2}}Twoway contour-line plot{p_end}
{p2col:}({mansection G-2 graphtwowaycontourline:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 53 2}
{cmdab:tw:oway}
{cmd:contourline}
{it:z} {it:y} {it:x}
{ifin}
[{cmd:,}
{it:options}]

{synoptset 31}{...}
{synopthdr}
{synoptline}
{synopt:{cmdab:ccut:s:(}{it:{help numlist}}{cmd:)}}list
	of values for contour lines or cuts{p_end}
{synopt:{opt lev:els(#)}}number of contour levels{p_end}
{synopt:{opt minmax}}include
	contour lines for minimum and maximum of {it:z}{p_end}
{synopt:{cmd:format(}{help format:{bf:%}{it:fmt}}{cmd:)}}display 	
	format for {cmd:ccuts()} or {cmd:levels()}{p_end}

{synopt:{opt colorl:ines}}display contour lines in different colors{p_end}
{synopt:{opth crule:(twoway_contour##crule:crule)}}rule
	for creating contour-line colors{p_end}
{synopt:{opth sc:olor(colorstyle)}}starting
	color for contour rule{p_end}
{synopt:{opth ec:olor(colorstyle)}}ending
	color for contour rule{p_end}
{synopt:{cmdab:cc:olors:(}{it:{help colorstyle}list}{cmd:)}}list
	of colors for contour lines{p_end}
{synopt:{cmdab:clw:idths:(}{it:{help linewidthstyle}list}{cmd:)}}list
	of widths for contour lines{p_end}
{synopt:{opt rev:ersekey}}reverse the order of the keys 
	in {help legend_options:contour-line legend}{p_end}

{synopt: {opth int:erp(twoway_contour##interpolation:interpmethod)}}interpolation methods
 if ({it:z}, {it:y}, {it:x}) does not fill a regular grid{p_end}

INCLUDE help gr_twopt
{synoptline}

{synoptset 22}{...}
{marker crule}{...}
{synopthdr :crule}
{synoptline}
{synopt:{opt hue}}use equally spaced {help colorstyle:hues} between 
	{cmd:scolor()} and {cmd:ecolor()}; the default{p_end}
{synopt:{opt chue}}use equally spaced {help colorstyle:hues} between 
	{cmd:scolor()} and {cmd:ecolor()}; unlike {opt hue}, it uses 
	360+{opt hue} of the {cmd:ecolor()} if the hue of the {cmd:ecolor()}
        is less than the hue of the {cmd:scolor()}{p_end}
{synopt:{opt int:ensity}}use equally spaced {help colorstyle:intensities} 
	with {cmd:ecolor()} as the base; {cmd:scolor()} is ignored{p_end}
{synopt:{opt lin:ear}}use equally spaced interpolations of the 
	{help colorstyle:RGB} values between {cmd:scolor()} 
	and {cmd:ecolor()}{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 22}{...}
{marker interpolation}{...}
{synopthdr :interpmethod}
{synoptline}
{synopt :{opt thin:platespline}}thin-plate-spline interpolation; the default{p_end}
{synopt :{opt shepard}}Shepard interpolation{p_end}
{synopt :{opt none}}no interpolation; plot data as is{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Twoway graph (scatter, line, etc.)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:twoway} {cmd:contourline} displays {it:z} as contour lines in 
({it:y},{it:x}).


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowaycontourlineQuickstart:Quick start}

        {mansection G-2 graphtwowaycontourlineRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
    {cmd:ccuts()}, {cmd:levels()}, {cmd:minmax}, and {cmd:format()} determine
    how many contours are created and the values of those contours.

{phang2}
{cmd:ccuts}{cmd:(}{it:{help numlist}}{cmd:)}
        specifies the {it:z} values for the contour lines.  Contour lines are
        drawn at each value of {it:numlist}.

{phang2}
{opt levels(#)}
        specifies the number of contour lines to create; {it:#}-1
        contour lines will be created.

{phang2}
{opt minmax}
        is a modifier of {cmd:levels()} and specifies that contour lines be
	drawn for the minimum and maximum values of {it:z}.  By default, lines
	are drawn only for the cut values implied by levels, not the full range
        of {it:z}.

{phang2}
    {cmd:format(}{help format:{bf:%}{it:fmt}}{cmd:)} 
            specifies the display format used to create the labels in the
            {help legend_options:contour legend} for the contour lines.

{pmore}
    {cmd:ccuts()} and {cmd:levels()} are different ways of specifying the
    contour cuts and may not be combined.

{phang}
    {cmd:colorlines}, {cmd:crule()}, {cmd:scolor()}, {cmd:ecolor()},
    {cmd:ccolors()}, and {cmd:clwidths()} determine the colors and width that
    are used for each contour line.

{phang2}
	{opt colorlines} specifies that the contour lines be drawn in
	different colors.  Unless the {cmd:ccolors()} option is
	specified, the colors are determined by {cmd:crule()}.

{phang2}
        {opth crule:(twoway_contour##crule:crule)} specifies 
        the rule used to set the colors for the contour lines.  Valid
	{it:crule}s are {cmd:hue}, {cmd:chue}, {cmd:intensity}, and
        {cmd:linear}.  The default is {cmd:crule(hue)}.

{phang2}
        {opt scolor:(colorstyle)} specifies the starting color for the rule.
        See {manhelpi colorstyle G-4}.

{phang2}
        {opt ecolor:(colorstyle)} specifies the ending color for the rule.
        See {manhelpi colorstyle G-4}.

{phang2}
        {opt ccolors(colorstylelist)} specifies a list
        of {it:colorstyle}s for each contour line.
        If RGB, CMYK, HSV, or intensity-adjusted (for example,
	{cmd:red*.3}) colorstyle is specified, they should be placed in
        quotes.  Examples of valid {cmd:ccolors()} options include{p_end}
{pmore3}
		{cmd:ccolors(red green magenta)} and{p_end}
{pmore3}
		{cmd:ccolors(red "55 132 22" ".3 .9 .3 hsv" blue)}.{p_end}
{pmore2}
        See {manhelpi colorstyle G-4}.

{phang2}
    {opt clwidths(linewidthstylelist)} specifies 
        a list of {it:linewidthstyle}s, one for each
        contour line.
        See {manhelpi linewidthstyle G-4}.
        
{phang}
    {opt reversekey} specifies that the order of the keys 
        in the contour-line legend be reversed.  By
        default the keys are ordered from top to bottom, starting with the
        key for the highest values of {it:z}.
	See {it:plegend_option} in {manhelpi legend_options G-3}.

{phang}
	{opth interp:(twoway_contourline##interpolation:interpmethod)} specifies
	the interpolation method to use if {it:z}, {it:y}, and {it:x} do not
	fill a regular grid.  Variables {it:z}, {it:y}, and {it:x} fill a
	regular grid if for every combination of nonmissing ({it:y},{it:x}),
	there is at least one nonmissing {it:z} corresponding to the pair in
        the dataset.  For example, the following dataset forms a 2x2 grid.

{pmore3}	
	      {cmd:. input z y x}
	
	              z y x
	          1.  {cmd:1 1 1}
	          2.  {cmd:2 4 1}
                  3.  {cmd:3 4 1}
	          4.  {cmd:1 1 2} 
                  5.  {cmd:1 4 2}
 	          6.  {cmd:end}

{pmore}        
        If there is more than one {it:z} value corresponding to a pair of
        ({it:y},{it:x}), the smallest {it:z} value is used in plotting.  In the
        above example, there are two {it:z} values corresponding to pair
        (4,1), and the smallest value, 2, is used.

{pmore3}	
	      {cmd:. input z y x}
	
	              z y x
	          1.  {cmd:1 1 1}
	          2.  {cmd:2 2 1}
	          3.  {cmd:1 1 2}
	          4.  {cmd:end}

{pmore}	
        does not fill a regular grid because there is no {it:z} value
        corresponding to the pair (2,2).

{phang} 
{it:twoway_options} 
        are any of the options documented in {manhelpi twoway_options G-3}.
        These include options for 
        titling the graph (see {manhelpi title_options G-3}); 
        for saving the graph to disk (see {manhelpi saving_option G-3});
        for controlling the labeling and look of the axes
        (see {manhelpi axis_options G-3});
        for controlling the look, contents, position, 
        and organization of the legend (see {manhelpi legend_options G-3});
        for adding lines (see {manhelpi added_line_options G-3})
        and text (see {manhelpi added_text_options G-3});
	and for controlling other aspects of the graph's appearance
        (see {manhelpi twoway_options G-3}).


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help twoway_contourline##ccuts:Controlling the number of contour lines and their values}
	{help twoway_contourline##colors:Controlling the colors of the contour lines}
	{help twoway_contourline##interp:Choose the interpolation method}


{marker ccuts}{...}
{title:Controlling the number of contour lines and their values}

{pstd}   
We could draw a contour-line plot with default values by typing
   
   	{cmd:. sysuse sandstone}
   
   	{cmd:. twoway contourline depth northing easting}
   	  {it:({stata `"gr_example sandstone: twoway contourline depth northing easting"':click to run})}
{* graph grctline1}{...}

{pstd}   
We add the {cmd:colorlines} option to display the values of cuts in the contour
legend.  We also include the {cmd:levels()} option to create #-1 contour lines
equally spaced between {cmd:min(depth)} and {cmd:max(depth)}.

	{cmd:. twoway contourline depth northing easting, colorlines levels(10)}
          {it:({stata `"gr_example sandstone: twoway contourline depth northing easting, colorlines levels(10)"':click to run})}
{* graph grctline2}{...}

{pstd}
   {cmd:ccuts()} and {cmd:levels()} are ways of controlling the number and
   value of contour lines.

{pstd}   
The {cmd:ccuts()} option gives you the finest control over creating contour
lines.  Here we use it to draw a contour-line plot with six cuts at 7500, 7600,
7700, 7800, 7900, and 8000.

   	{cmd:. twoway contourline depth northing easting, colorlines}
                {cmd:ccuts(7500(100)8000)}
   	  {it:({stata `"gr_example sandstone: twoway contourline depth northing easting, colorlines ccuts(7500(100)8000)"':click to run})}
{* graph grctline3}{...}


{marker colors}{...}
{title:Controlling the colors of the contour lines}

{pstd}   
{cmd:crule()}, {cmd:scolor()}, and {cmd:ecolor()} control the colors for each
contour line.	

   	{cmd:. twoway contourline depth northing easting, level(10)}
   		{cmd:format(%9.1f) colorlines scolor(green) ecolor(red)}
   	  {it:({stata `"gr_example sandstone: twoway contourline depth northing easting, level(10) format(%9.1f) colorlines scolor(green) ecolor(red)"':click to run})}
{* graph grctline4}{...}

{pstd} 
   draws a contour-line plot with lines of nine equally spaced {it:z} values
   between {cmd:min(depth)} and {cmd:max(depth)}. The starting color for lines
   is green and the ending color for lines is red. Also, the legend labels'
   display format is {cmd:%9.1f}. 

{pstd}   
   {cmd:ccolors()} specifies a list of colors to be used for each contour line.
   
   	{cmd:. twoway contourline depth northing easting, ccuts(7600(100)8000)}
   		{cmd:colorlines ccolors(red green magenta blue yellow)}
   	  {it:({stata `"gr_example sandstone: twoway contourline depth northing easting, ccuts(7600(100)8000) colorlines ccolors(red green magenta blue yellow)"':click to run})}
{* graph grctline5}{...}


{marker interp}{...}
{title:Choose the interpolation method}

{pstd}
See {it:{help twoway_contour##interp:Choose the interpolation method}} in
{helpb twoway contour:[G-2] graph twoway contour}.
{p_end}
