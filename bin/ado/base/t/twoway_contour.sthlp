{smcl}
{* *! version 1.0.17  19oct2017}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway contour" "mansection G-2 graphtwowaycontour"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway contourline" "help twoway_contourline"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway area" "help twoway_area"}{...}
{vieweralsosee "[G-2] graph twoway rarea" "help twoway_rarea"}{...}
{viewerjumpto "Syntax" "twoway_contour##syntax"}{...}
{viewerjumpto "Menu" "twoway_contour##menu"}{...}
{viewerjumpto "Description" "twoway_contour##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_contour##linkspdf"}{...}
{viewerjumpto "Options" "twoway_contour##options"}{...}
{viewerjumpto "Remarks" "twoway_contour##remarks"}{...}
{viewerjumpto "Reference" "twoway_contour##reference"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[G-2] graph twoway contour} {hline 2}}Twoway contour plot with area shading{p_end}
{p2col:}({mansection G-2 graphtwowaycontour:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 53 2}
{cmdab:tw:oway}
{cmd:contour}
{it:z} {it:y} {it:x}
{ifin}
[{cmd:,}
{it:options}]

{synoptset 22}{...}
{synopthdr}
{synoptline}
{synopt:{cmdab:ccut:s:(}{it:{help numlist}}{cmd:)}}list
	of values for contour lines or cuts{p_end}
{synopt:{opt lev:els(#)}}number of contour levels{p_end}
{synopt:{opt minmax}}include minimum and maximum of {it:z} in levels{p_end}

{synopt:{opth crule:(twoway_contour##crule:crule)}}rule
	for creating contour-level colors{p_end}
{synopt:{opth sc:olor(colorstyle)}}starting
	color for contour rule{p_end}
{synopt:{opth ec:olor(colorstyle)}}ending
	color for contour rule{p_end}
{synopt:{cmdab:cc:olors:(}{it:{help colorstyle}list}{cmd:)}}list
	of colors for contour levels{p_end}

{synopt:{opt heatmap}}draw the contour plot as a heat map{p_end}

{synopt: {opth int:erp(twoway_contour##interpolation:interpmethod)}}interpolation method
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
{cmd:twoway} {cmd:contour} displays {it:z} as filled contours in 
({it:y},{it:x}).


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowaycontourQuickstart:Quick start}

        {mansection G-2 graphtwowaycontourRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
    {cmd:ccuts()}, {cmd:levels()}, and {cmd:minmax} determine
    how many contours are created and the values of those contours.

{pmore}
    An alternative way of controlling the contour values is using the standard
    axis-label options available through the {cmd:zlabel()} option; see
    {manhelpi axis_label_options G-3:axis_label_options}.  Even when
    {cmd:ccuts()} or {cmd:levels()} are specified, you can further control the
    appearance of the contour labels using the {cmd:zlabel()} option.

{phang2}
{cmd:ccuts}{cmd:(}{it:{help numlist}}{cmd:)}
        specifies the {it:z} values for the contour lines.  Contour lines are
        drawn at each value of {it:numlist} and color- or shade-filled levels
        are created for each area between the lines and for the areas below
        the minimum and above the maximum.

{phang2}
{opt levels(#)}
        specifies the number of filled contour levels to create; {it:#}-1
        contour cuts will be created.

{phang2}
{opt minmax}
        is a modifier of {cmd:levels()} and specifies that the minimum and
        maximum values of {it:z} be included in the cuts.  
       
{pmore}
    {cmd:ccuts()} and {cmd:levels()} are different ways of specifying the
    contour cuts and may not be combined.

{phang}
    {cmd:crule()}, {cmd:scolor()}, {cmd:ecolor()}, and {cmd:ccolors()}
    determine the colors that are used for each filled contour level.

{phang2}
        {opth crule:(twoway_contour##crule:crule)} specifies the rule used to
        set the colors for the contour levels.  Valid {it:crule}s are
        {cmd:hue}, {cmd:chue}, {cmd:intensity}, and {cmd:linear}.  The default 
        is {cmd:crule(hue)}.

{phang2}
        {opt scolor:(colorstyle)} specifies the starting color for the rule.
        See {manhelpi colorstyle G-4}.

{phang2}
        {opt ecolor:(colorstyle)} specifies the ending color for the rule.
        See {manhelpi colorstyle G-4}.

{phang2}
        {opt ccolors(colorstylelist)} specifies a list
        of {it:colorstyle}s for the area of each contour
        level.  If RGB, CMYK, HSV, or intensity-adjusted (for example,
	{cmd:red*.3}) colorstyle is specified, they should be placed in
        quotes.  Examples of valid {cmd:ccolors()} options include{p_end}
{pmore3}
		{cmd:ccolors(red green magenta)} and{p_end}
{pmore3}
		{cmd:ccolors(red "55 132 22" ".3 .9 .3 hsv" blue)}.{p_end}
{pmore2}
        See {manhelpi colorstyle G-4}.

{phang}
    {cmd:heatmap} draws colored rectangles centered on each grid point. 
    The color is determined by the {it:z} value of the grid point.  

{phang}
	{opth interp:(twoway_contour##interpolation:interpmethod)} specifies
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
        and organization of the legend (see {manhelpi legend_option G-3});
        for adding lines (see {manhelpi added_line_options G-3})
        and text (see {manhelpi added_text_options G-3});
	and for controlling other aspects of the graph's appearance
        (see {manhelpi twoway_options G-3}).


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help twoway_contour##ccuts:Controlling the number of contours and their values}
	{help twoway_contour##colors:Controlling the colors of the contour areas}
	{help twoway_contour##interp:Choose the interpolation method}
	{help twoway contour##video:Video example}


{marker ccuts}{...}
{title:Controlling the number of contours and their values}

{pstd}
We could draw a contour plot with default values by typing

   	{cmd:. sysuse sandstone}
   
   	{cmd:. twoway contour depth northing easting}
   	  {it:({stata `"gr_example sandstone: twoway contour depth northing easting"':click to run})}
{* graph grcont1}{...}

{pstd}   
We could add the {cmd:levels()} option to the above command to create
#-1 equally spaced contours between {cmd:min(depth)} 
and {cmd:max(depth)}.
   
   	{cmd:. twoway contour depth northing easting, levels(10)}
   	  {it:({stata "gr_example sandstone: twoway contour depth northing easting, levels(10)":click to run})}
{* graph grcont2}{...}

{pstd}   
We could use the {cmd:ccuts()} option to draw a contour plot with 7 levels
determined by 6 cuts at 7500, 7600, 7700, 7800, 7900, and 8000.	
{cmd:ccuts()} gives you the finest control over creating contour levels.

   	{cmd:. twoway contour depth northing easting, ccuts(7500(100)8000)}
   	  {it:({stata "gr_example sandstone: twoway contour depth northing easting, ccuts(7500(100)8000)":click to run})}
{* graph grcont3}{...}

{pstd}   
{cmd:zlabel()} controls the axis on the contour legend.  When {cmd:ccuts()} and
{cmd:levels()} are not specified, {cmd:zlabel()} also controls the number and
value of contours.  To obtain 7 nicely spaced cuts, specify
{cmd:zlabel(#7)}:

   	{cmd:. twoway contour depth northing easting, zlabel(#7)}
   	  {it:({stata `"gr_example sandstone: twoway contour depth northing easting, zlabel(#7)"':click to run})}
{* graph grcont4}{...}

{pstd}   
With either {cmd:levels()} or {cmd:ccuts()}, {cmd:zlabel()} becomes an option
that only affects the labels of the contour legend.  The contour legend can
label different values than the actual contour cuts.  The legend can have more
(or fewer) ticks than the number of contour levels.  See
{manhelpi axis_label_options G-3:axis_label_options} for details.

{pstd}
We now specify the {cmd:twoway} {cmd:contour} command with the {cmd:levels()}
and {cmd:zlabel()} options and the {cmd:format()} suboption to draw a 10-level
contour plot with 7 labels on the contour legend. The labels' display format is
{cmd:%9.1f}.

   	{cmd:. twoway contour depth northing easting, }
   		{cmd: levels(10) zlabel(#7, format(%9.1f))}
   	 {it:({stata `"gr_example sandstone: twoway contour depth northing easting, levels(10) zlabel(#7, format(%9.1f))"':click to run})}
{* graph grcont5}{...}


{marker colors}{...}
{title:Controlling the colors of the contour areas}

{pstd}   
  {cmd:crule()}, {cmd:scolor()}, and {cmd:ecolor()} control the colors for each
  contour level.	

   	{cmd:. twoway contour depth northing easting,}
   			{cmd:level(10) scolor(green) ecolor(red)}
   	  {it:({stata "gr_example sandstone: twoway contour depth northing easting, level(10) scolor(green) ecolor(red)":click to run})}
{* graph grcont5}{...}

{pstd}   
draws a 10-level contour plot with starting color green and ending color red.
Because the hue of green is 120 and the hue of red is 0, the hues of levels are
moving downward under the default {cmd:crule(hue)}.  Hence you will see yellow,
but not blue and purple. 
   
{pstd}
For the above example, you can use {cmd:crule(chue)} if you want hues of the
levels to move up:

   	{cmd:. twoway contour depth northing easting,}
   			{cmd:level(10) crule(chue) scolor(green) ecolor(red)}
   	  {it:({stata "gr_example sandstone: twoway contour depth northing easting, level(10) crule(chue) scolor(green) ecolor(red)":click to run})}
{* graph grcont6}{...}

{pstd}   
Now you will see blue and purple as the hue varies from 120 to 360(0+360), but
not yellow.  

{pstd}   
   {cmd:ccolors()} specifies a list of colors to be used for each contour level.
   
   	{cmd:. twoway contour depth northing easting,}
   			{cmd:levels(5) ccolors(red green magenta blue yellow)}
   	  {it:({stata "gr_example sandstone: twoway contour depth northing easting, levels(5) ccolors(red green magenta blue yellow)":click to run})}
{* graph grcont7}{...}


{marker interp}{...}
{title:Choose the interpolation method}

{pstd}
	If {it:z}, {it:y}, and {it:x} do not fill a regular grid, the missing
        {it:z} values on grid points ({it:y},{it:x}) need to be interpolated. 

{pstd}
	Thin-plate-spline interpolation uses a weight vector (w_i)
	obtained from solving a dimension {it:n+}3 linear equation system,
	where {it:n} is the number of unique pairs ({it:y},{it:x}) with
	nonmissing {it:z} values in the dataset.  Then the {it:z} value on a
        pair ({it:y},{it:x}) can be interpolated by

{phang2}	
z=w_1*f(y-y1,x-x1)+...+w_n*f(y-yn,x-xn)+w_(n+1)+w_(n+2)*x+w_(n+3)*y
	      
{pstd} 
	where f(y,x)=sqrt(y^2 + x^2).  {cmd:interp(thinplatespline)} is
        the default.

{pstd}
	Shepard interpolation obtains the {it:z} value on a pair
        ({it:y},{it:x}) from 

{phang2}	
              z=(z_1*f(y-y1,x-x1)+...+z_n*f(y-yn,x-xn)/sum
	  
{pstd} 
	where sum is

{phang2}	
	      sum=f(y-y1,x-x1)+...+f(y-yn,x-xn)

{phang2}
	and f(y,x)=1/(x^2 + y^2). You specify {cmd:interp(shepard)} to
        use this method. 

{pstd}
        For the detailed formulas of thin-plate-spline and Shepard
        interpolation, see
        {help twoway_contour##PTVF2007:Press et al. (2007, 140-144)}.

{pstd} 
        Thin-plate-spline interpolation needs to solve a dimension
        {it:n+}3 linear system, where {it:n} is the number of unique pairs 
	({it:y},{it:x}) with nonmissing {it:z} value in the dataset.  It
	becomes expensive when {it:n} becomes large.  A rule-of-thumb number
        for choosing the thin-plate-spline method is {it:n~}1000.

{pstd} 
        Shepard interpolation is usually not as good as
        thin-plate-spline interpolation but is faster.

{pstd}
	Method {cmd:none} plots data as is without any interpolation. Any grid
	cell with edge points containing a missing {it:z} value will be
	displayed using background color.  If the dataset
	({it:z},{it:y},{it:x}) is dense (that is, there are few missing grid
        points), {cmd:interp(none)} may be adequate.


{marker video}{...}
{title:Video example}

{phang}
{browse "http://www.youtube.com/watch?v=G-t-NSkGm9Y":Contour plots in Stata}


{marker reference}{...}
{title:Reference}

{marker PTVF2007}{...}
{phang}
Press, W. H., S. A. Teukolsky, W. T. Vetterling, and B. P. Flannery. 2007.
{it:Numerical Recipes: The Art of Scientific Computing Third Edition}.
Cambridge: Cambridge University Press.
{p_end}
