{smcl}
{* *! version 1.0.12  16apr2019}{...}
{vieweralsosee "[G-3] clegend_option" "mansection G-3 clegend_option"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway contour" "help twoway_contour"}{...}
{vieweralsosee "[G-2] graph twoway contourline" "help twoway_contourline"}{...}
{vieweralsosee "[G-3] title_options" "help title_options"}{...}
{viewerjumpto "Syntax" "clegend_option##syntax"}{...}
{viewerjumpto "Description" "clegend_option##description"}{...}
{viewerjumpto "Links to PDF documentation" "clegend_option##linkspdf"}{...}
{viewerjumpto "Options" "clegend_option##option"}{...}
{viewerjumpto "Remarks" "clegend_option##remarks"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[G-3]} {it:clegend_option} {hline 2}}Option for controlling the
	contour-plot legend{p_end}
{p2col:}({mansection G-3 clegend_option:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 20}{...}
{p2col:{it:clegend_option}}Description{p_end}
{p2line}
{p2col:{cmdab:cleg:end:(}[{it:{help clegend_option##suboptions:suboptions}}]{cmd:)}}contour-legend contents, appearance, and location{p_end}
{p2line}
{p 4 6 2}
{cmd:clegend()} is {it:merged-implicit}; see {help repeated options}.

{marker suboptions}{...}
{synoptset 28 tabbed}{...}
{synopthdr:suboptions}
{synoptline}
{syntab:Contour legend appearance}{...}
{synopt:{opth width(size)}}width of contour key{p_end}
{synopt:{opth height(size)}}height of contour key{p_end}

{p2col:{opt altaxis}}move the contour key's axis to the other side of the
	contour key{p_end}
{p2col:{cmdab:bm:argin:(}{it:{help marginstyle}}{cmd:)}}outer margin around
      legend{p_end}
{p2col:{it:{help title_options}}}titles, subtitles, notes, captions{p_end}
{p2col:{cmdab:r:egion:(}{it:{help clegend_option##roptions:roptions}}{cmd:)}}borders and background shading{p_end}

{syntab:Contour legend location}{...}
{p2col:{cmd:off} or {cmd:on}}suppress or force display of legend{p_end}
{p2col:{cmdab:pos:ition:(}{it:{help clockposstyle}}{cmd:)}}where legend
      appears{p_end}
{p2col:{cmd:ring(}{it:{help ringposstyle}}{cmd:)}}where legend appears
      (detail){p_end}
{p2col:{cmdab:bplace:ment:(}{it:{help compassdirstyle}}{cmd:)}}placement 
	of legend when positioned in the plotregion{p_end}
{p2col:{cmd:at(}{it:#}{cmd:)}}allowed with {cmd:by()} only{p_end}
{synoptline}
{p 4 6 2}
See
{it:{help clegend_option##where:Where contour legends appear}} under
{it:Remarks} below, and see
{it:{help title_options##remarks3:Positioning of titles}} in
{manhelpi title_options G-3} for definitions of {it:clockposstyle}
and {it:ringposstyle}.

{marker roptions}{...}
{p2col:{it:roptions}}Description{p_end}
{p2line}
{p2col:{cmdab:sty:le:(}{it:{help areastyle}}{cmd:)}}overall style of
       region{p_end}
{p2col:{cmdab:c:olor:(}{it:{help colorstyle}}{cmd:)}}line and fill color of
       region{p_end}
{p2col:{cmdab:fc:olor:(}{it:{help colorstyle}}{cmd:)}}fill color of
       region{p_end}
{p2col:{cmdab:ls:tyle:(}{it:{help linestyle}}{cmd:)}}overall style of
       border{p_end}
{p2col:{cmdab:lc:olor:(}{it:{help colorstyle}}{cmd:)}}color of border{p_end}
{p2col:{cmdab:lw:idth:(}{it:{help linewidthstyle}}{cmd:)}}thickness of
       border{p_end}
{p2col:{cmdab:lp:attern:(}{it:{help linepatternstyle}}{cmd:)}}border pattern
       (solid, dashed, etc.){p_end}
{p2col : {cmdab:la:lign:(}{it:{help linealignmentstyle}}{cmd:)}}line
	alignment (inside, outside, center){p_end}
{p2col:{cmdab:m:argin:(}{it:{help marginstyle}}{cmd:)}}margin between border
       and contents of legend{p_end}
{p2line}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The {cmd:clegend()} option allows you to control the contents, appearance, and
placement of the contour-plot legend.  

{pstd}
Contour-plot legends have a single key that displays all the colors used to
fill the contour areas.  They also have a {it:c} axis that provides a scale
for the key and associated contour plot.  That axis is controlled using the
{it:c}-axis option described in {manhelpi axis_options G-3}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 clegend_optionQuickstart:Quick start}

        {mansection G-3 clegend_optionRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:clegend(}{it:{help clegend_option##suboptions:suboptions}}{cmd:)}
    specifies the appearance of a contour-plot legend, along with how it is to
    look, and whether and where it is to be displayed.


{marker appearance_suboptions}{...}
{title:Content and appearance suboptions for use with clegend()}

{phang}
    {opt width(size)} specifies the width of the contour key.
    See {manhelpi size G-4}.

{phang}
    {opt height(size)} specifies the height of the contour key.
    See {manhelpi size G-4}.

{phang}
   {opt altaxis} specifies that the contour key's axis be placed on the
   alternate side of the contour key from the default side.  For most 
   {help schemes}, this means that the axis is moved from the right side of
   the contour key to the left side.

{phang}
{cmd:bmargin(}{it:marginstyle}{cmd:)}
     specifies the outer margin around the legend.  That is, it specifies
     how close other things appearing near the legend can get.  Also see
     suboption {cmd:margin()} under
     {it:{help clegend_option##subopts:Suboptions for use with clegend(region())}}
     below for specifying the
     inner margin between the border and contents.  See 
     {manhelpi marginstyle G-4} for a list of margin choices.

{phang}
{it:title_options}
     allow placing titles, subtitles, notes, and captions on contour-plot
     legends.  See {manhelpi title_options G-3}.

{phang}
{cmd:region(}{it:roptions}{cmd:)}
     specifies the border and shading of the legend.
     You could give the legend a gray background tint
     by specifying
     {cmd:clegend(region(fcolor(gs9)))}.
     See {it:{help clegend_option##subopts:Suboptions for use with clegend(region())}} below.


{marker subopts}{...}
{title:Suboptions for use with clegend(region())}

{phang}
{cmd:style(}{it:areastyle}{cmd:)}
     specifies the overall style of the region in which the
     legend appears.  The other suboptions allow you to change
     the region's attributes individually, but {cmd:style()} provides
     the starting point.  See 
     {manhelpi areastyle G-4} for a list of choices.

{phang}
{cmd:color(}{it:colorstyle}{cmd:)}
    specifies the color of the background of the legend and the line
    used to outline it.  See {manhelpi colorstyle G-4} for a list of color
    choices.

{phang}
{cmd:fcolor(}{it:colorstyle}{cmd:)}
    specifies the background (fill) color for the legend.
    See {manhelpi colorstyle G-4} for a list of color choices.

{phang}
{cmd:lstyle(}{it:linestyle}{cmd:)}
    specifies the overall style of the line used to outline the legend,
    which includes its pattern (solid, dashed, etc.), its thickness, and
    its color.  The other suboptions listed below allow you to
    change the line's attributes individually,
    but {cmd:lstyle()} is the starting point.
    See {manhelpi linestyle G-4} for a list of choices.

{phang}
{cmd:lcolor(}{it:colorstyle}{cmd:)}
    specifies the color of the line used to outline the legend.
    See {manhelpi colorstyle G-4} for a list of color choices.

{phang}
{cmd:lwidth(}{it:linewidthstyle}{cmd:)}
    specifies the thickness of the line used to outline the legend.
    See {manhelpi linewidthstyle G-4} for a list of choices.

{phang}
{cmd:lpattern(}{it:linepatternstyle}{cmd:)}
    specifies whether the line used to outline the legend is solid, dashed,
    etc.
    See {manhelpi linepatternstyle G-4} for a list of choices.

{phang}
{cmd:lalign(}{it:linealignmentstyle}{cmd:)}
    specifies whether the line used to outline the legend is inside, outside,
    or centered.
    See {manhelpi linealignmentstyle G-4} for a list of alignment choices.

{phang}
{cmd:margin(}{it:marginstyle}{cmd:)}
    specifies the inner margin between the border and the contents of the
    legend.  Also see
    {cmd:bmargin()} under
    {it:{help clegend_option##appearance_suboptions:Content and appearance suboptions for use with clegend()}}
    above for specifying the outer margin around the legend.
    See {manhelpi marginstyle G-4} for a list of margin choices.


{marker location_suboptions}{...}
{title:Location suboptions for use with clegend()}

{phang}
{cmd:off} and {cmd:on}
    determine whether the legend appears.
    The default is {cmd:on} when a {helpb twoway contour} plot appears in the
    graph.  In those cases, {cmd:clegend(off)} will suppress the display of
    the legend.

{phang}
{cmd:position(}{it:clockposstyle}{cmd:)},
{cmd:ring(}{it:ringposstyle}{cmd:)}, and
{cmd:bplacement(}{it:compassdirstyle}{cmd:)}
    override the default location of the legend, which is usually 
    to the right of the plot region.  {cmd:position()} specifies a direction
    [{it:sic}] according to the hours on the dial of a 12-hour clock, and
    {cmd:ring()} specifies the distance from the plot region.

{pmore}
    {cmd:ring(0)} is defined as being inside the plot region itself and allows you
    to place the legend inside the plot.  {cmd:ring(}{it:k}{cmd:)}, {it:k}>0,
    specifies positions outside the plot region; the larger the {cmd:ring()}
    value, the farther away the legend is from the plot region.  {cmd:ring()}
    values may be integers or nonintegers and are treated ordinarily.  
    
{pmore}
    When {cmd:ring(0)} is specified, {cmd:bplacement()} further specifies
    where in the plot region the legend is placed.  {cmd:bplacement(seast)}
    places the legend in the southeast (lower-right) corner of the plot
    region.

{pmore}
    {cmd:position(12)} puts the legend directly above the plot region
    (assuming {cmd:ring()}>0), {cmd:position(9)} directly to the left
    of the plot region, and so on.

{pmore}
    See
    {it:{help clegend_option##where:Where contour legends appear}} under
    {it:Remarks} below and
    {it:{help title_options##remarks3:Positioning of titles}} in
    {manhelpi title_options G-3} for more information on
    the {cmd:position()} and {cmd:ring()} suboptions.

{phang}
{cmd:at(}{it:#}{cmd:)}
    is for use only when the {it:twoway_option} {cmd:by()} is also
    specified.  It specifies that the legend appear in the
    {it:#}th position of the
    {it:RxC} array of plots, using the same coding as
    {cmd:by(}...{cmd:,} {cmd:holes())}.  See
    {it:{help clegend_option##by:Use of legends with by()}} under
    {it:Remarks} below, and see {manhelpi by_option G-3}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help clegend_option##when:When contour legends appear}
	{help clegend_option##where:Where contour legends appear}
	{help clegend_option##titles:Putting titles on contour legends}
	{help clegend_option##axis:Controlling the axis in contour legends}
	{help clegend_option##by:Use of legends with by()}


{marker when}{...}
{title:When contour legends appear}

{pstd}
Contour legends appear on the graph whenever the graph contains a 
{helpb twoway contour} plot.

	{cmd:. sysuse sandstone}
   
   	{cmd:. twoway contour depth northing easting, levels(10)}
   	  {it:({stata "gr_example sandstone: twoway contour depth northing easting, levels(10)":click to run})}
{* graph clegend1}{...}

{pstd}
You can suppress the contour legend by specifying {cmd:clegend(off)},

   	{cmd:. twoway contour depth northing easting, levels(10) clegend(off)}
   	  {it:({stata "gr_example sandstone: twoway contour depth northing easting, levels(10) clegend(off)":click to run})}
{* graph clegend2}{...}


{marker where}{...}
{title:Where contour legends appear}

{pstd}
By default, legends appear to the right of the plot region at what is
technically referred to as {cmd:position(3)} {cmd:ring(3)}.  Suboptions
{cmd:position()} and {cmd:ring()} specify the location of the legend.
{cmd:position()} specifies on which side of the plot region the legend appears
-- {cmd:position(3)} means 3 o'clock -- and {cmd:ring()} specifies the
distance from the plot region -- {cmd:ring(3)} means farther out than the
{it:title_option} {cmd:b2title()} but inside the {it:title_option}
{cmd:note()}; see {manhelpi title_options G-3}.

{pstd}
If we specify {cmd:clegend(position(9))}, the legend will be moved to the
9 o'clock position:

   	{cmd:. twoway contour depth northing easting, levels(10) clegend(pos(9))}
   	  {it:({stata "gr_example sandstone: twoway contour depth northing easting, levels(10) clegend(pos(9))":click to run})}	  
{* graph clegend3}{...}

{pstd}
{cmd:ring()} -- the suboption that specifies the distance from the plot
region -- is seldom specified, but, when it is specified, {cmd:ring(0)} is
the most useful.  {cmd:ring(0)} specifies that the legend be moved inside the
plot region:

   	{cmd:. twoway contour depth northing easting, levels(10)}
        	{cmd:  clegend(pos(5) ring(0))}
   	  {it:({stata `"gr_example sandstone: twoway contour depth northing easting, levels(10) clegend(pos(5) ring(0))"':click to run})}	  
{* graph clegend4}{...}

{pstd}
Our use of {cmd:position(5) ring(0)} put the legend inside the plot region,
at 5 o'clock, meaning in the bottom right corner.  Had we specified
{cmd:position(2) ring(0)}, the legend would have appeared in the top right
corner.

{pstd}
We might now add a background color to the legend:
	
   	{cmd:. twoway contour depth northing easting, levels(10) clegend(pos(2)}
		{cmd: ring(0) region(fcolor(gs15)))}
   	  {it:({stata `"gr_example sandstone: twoway contour depth northing easting, levels(10) clegend(pos(5) ring(0) region(fcolor(gs15)))"':click to run})}
{* graph clegend5}{...}


{marker titles}{...}
{title:Putting titles on contour legends}

{pstd}
By default, the {it:z} axis of a contour legend displays the {it:z} variable
label or variable name as a title.  You can suppress this axis title.  You can
also add an overall title for the legend.   We do that for the previous graph
by adding the {cmd:ztitle("")} and {cmd:clegend(title("Depth"))} options:
	
   	{cmd:. twoway contour depth northing easting, levels(10) ztitle("")}
		{cmd:clegend(title("Depth") region(fcolor(gs15)))}
   	  {it:({stata `"gr_example sandstone: twoway contour depth northing easting, levels(10) ztitle("") clegend(title("Depth") region(fcolor(gs15)))"':click to run})}
{* graph clegend6}{...}

{pstd}
Legends may also contain {cmd:subtitles()}, {cmd:notes()}, and
{cmd:captions()}, though these are rarely used; see 
{manhelpi title_options G-3}.


{marker axis}{...}
{title:Controlling the axis in contour legends}

{pstd}
Contour-plot legends contain a {it:z} axis.  You control this axis just as you
would the {it:x} or {it:y} axis of a graph.  Here we specify cutpoints for the
contours and custom tick labels using the {cmd:zlabel()} option,

   	{cmd:. twoway contour depth northing easting, levels(10)}
   		{cmd:zlabel(7600 "low" 7800 "medium" 8000 "high")}
		{cmd:region(fcolor(gs15)))}
   	  {it:({stata `"gr_example sandstone: twoway contour depth northing easting, levels(10) zlabel(7600 "low" 7800 "medium" 8000 "high") clegend(title("Depth") region(fcolor(gs15)))"':click to run})}	  
{* graph clegend7}{...}

{pstd}
Minor ticks, axis scale (logged, reversed, etc.), and all other aspects of the
{it:z} axis can be controlled using the {cmd:zlabel()}, {cmd:zmlabel()},
{cmd:ztick()}, {cmd:zmtick()}, {cmd:zscale()}, and {cmd:ztitle()} options; see
{manhelpi axis_options G-3}.


{* legends, use with by() tt}{...}
{* index by() tt, use of legends with}{...}
{marker use_of_legends_with_by}{...}
{marker by}{...}
{title:Use of legends with by()}

{pstd}
Legends are omitted by default when {cmd:by()} is specified.  You can turn 
legends on by specifying {cmd:clegend(on)} within {cmd:by()}.  It will show in
the default location. 

	{cmd:. sysuse surface}
   
   	{cmd:. twoway contour temperature longitude latitude,}
		{cmd:level(10) xlabel(,format(%9.0f)) by(date, clegend(on))}
   	  {it:({stata `"gr_example surface: twoway contour temperature longitude latitude, levels(10) xlabel(,format(%9.0f)) by(date, clegend(on))"':click to run})}	  
{* graph clegend8}{...}

{pstd}
If you want to move the legend, consider the different options and their
placement on the command line.
{it:{help clegend_option##location_suboptions:Location suboptions for use with clegend()}}
should be specified within the {cmd:by()} option, whereas
{it:{help clegend_options##appearance_suboptions:Content and appearance suboptions for use with clegend()}}
should be specified outside the {cmd:by()} option.  For example, the
{cmd:position()} option changes where the legend appears, so it would be
specified within the {cmd:by()} option:

   	{cmd:. twoway contour temperature longitude latitude,}
		{cmd:level(10) xlabel(,format(%9.0f)) by(date, clegend(on pos(9)))}
   	  {it:({stata `"gr_example surface: twoway contour temperature longitude latitude, levels(10) xlabel(,format(%9.0f)) by(date, clegend(on pos(9)))"':click to run})}	  
{* graph clegend9}{...}

{pstd}
If you want to also change the appearance of the legend, specify an
additional {cmd:clegend()} option outside the {cmd:by()} option:

   	{cmd:. twoway contour temperature longitude latitude,}
		{cmd:level(10) xlabel(,format(%9.0f))}
		{cmd: clegend(on width(15)) by(date, clegend(on pos(9)))}
   	  {it:({stata `"gr_example surface: twoway contour temperature longitude latitude, levels(10) xlabel(,format(%9.0f)) clegend(on width(15)) by(date, clegend(on pos(9)))"':click to run})}	  
{* graph clegend10}{...}

{pstd}
If you specify the
{help clegend_option##location_suboptions:location suboptions} 
outside the {cmd:by()} option, the location suboptions will be ignored.
{p_end}
