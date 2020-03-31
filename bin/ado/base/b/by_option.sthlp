{smcl}
{* *! version 1.1.10  19oct2017}{...}
{vieweralsosee "[G-3] by_option" "mansection G-3 by_option"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] region_options" "help region_options"}{...}
{vieweralsosee "[G-3] title_options" "help title_options"}{...}
{viewerjumpto "Syntax" "by_option##syntax"}{...}
{viewerjumpto "Description" "by_option##description"}{...}
{viewerjumpto "Links to PDF documentation" "by_option##linkspdf"}{...}
{viewerjumpto "Option" "by_option##option"}{...}
{viewerjumpto "byopts" "by_option##byopts"}{...}
{viewerjumpto "Remarks" "by_option##remarks"}{...}
{viewerjumpto "Reference" "by_option##reference"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[G-3]} {it:by_option} {hline 2}}Option for repeating graph command{p_end}
{p2col:}({mansection G-3 by_option:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 25}{...}
{p2col:{it:by_option}}Description{p_end}
{p2line}
{p2col:{cmd:by(}{varlist}[{cmd:,} {it:byopts}]{cmd:)}}repeat for by-groups
     {p_end}
{p2line}
    {cmd:by()} is {it:merged-implicit}; see {help repeated options}.


{p2col:{it:byopts}}Description{p_end}
{p2line}
{p2col:{cmd:total}}add total group{p_end}
{p2col:{cmdab:miss:ing}}add missing groups{p_end}
{p2col:{cmdab:colf:irst}}display down columns{p_end}
{p2col:{cmdab:r:ows:(}{it:#}{cmd:)} | {cmdab:c:ols:(}{it:#}{cmd:)}}display in
     {it:#} rows or {it:#} columns{p_end}
{p2col:{cmdab:hol:es:(}{it:{help numlist}}{cmd:)}}positions to leave blank
     {p_end}
{p2col:{cmd:iscale(}[{cmd:*}]{it:#}{cmd:)}}size of text and markers{p_end}

{p2col:{cmdab:com:pact}}synonym for {cmd:style(compact)}{p_end}
{p2col:{cmd:style(}{it:{help bystyle}}{cmd:)}}overall style of presentation
     {p_end}
{p2col:[{cmdab:no:}]{cmdab:edge:label}}label {it:x} axes of edges{p_end}
{p2col:[{cmdab:no:}]{cmdab:r:escale}}separate {it:y} and {it:x} scales for each
       group{p_end}
{p2col:[{cmdab:no:}]{cmdab:yr:escale}}separate {it:y} scale for each group
       {p_end}
{p2col:[{cmdab:no:}]{cmdab:xr:escale}}separate {it:x} scale for each group
       {p_end}
{p2col:[{cmdab:no:}]{cmdab:iy:axes:}}show individual {it:y} axes{p_end}
{p2col:[{cmdab:no:}]{cmdab:ix:axes:}}show individual {it:x} axes{p_end}
{p2col:[{cmdab:no:}]{cmdab:iyt:ick:}}show individual {it:y}-axes ticks{p_end}
{p2col:[{cmdab:no:}]{cmdab:ixt:ick:}}show individual {it:x}-axes ticks{p_end}
{p2col:[{cmdab:no:}]{cmdab:iyl:abel:}}show individual {it:y}-axes labels{p_end}
{p2col:[{cmdab:no:}]{cmdab:ixl:abel:}}show individual {it:x}-axes labels{p_end}
{p2col:[{cmdab:no:}]{cmdab:iytit:le:}}show individual {it:y}-axes titles{p_end}
{p2col:[{cmdab:no:}]{cmdab:ixtit:le:}}show individual {it:x}-axes titles{p_end}
{p2col:{cmdab:im:argin:(}{it:{help marginstyle}}{cmd:)}}margin between graphs
         {p_end}

{p2col:{it:{help by_option##legend_options:legend_options}}}show legend and
       placement of legend{p_end}
{p2col:{it:{help title_options}}}overall titles{p_end}
{p2col:{it:{help region_options}}}overall outlining, shading, and aspect{p_end}
{p2line}
{p2colreset}{...}
{p 4 6 2}
The {it:title_options} and {it:region_options} on the command
on which {cmd:by()} is appended will become the titles and regions for
the individual by-groups.


{marker description}{...}
{title:Description}

{pstd}
Option {cmd:by()} repeats the {cmd:graph} command for each value of
{varlist} and arrays the resulting individual graphs into one graph.
{it:varlist} may be a numeric or a string variable.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 by_optionQuickstart:Quick start}

        {mansection G-3 by_optionRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:by(}{varlist}[{cmd:,} {it:byopts}]{cmd:)}
    specifies that the {cmd:graph} command be repeated for each
    unique set of values of {it:varlist} and that the resulting individual
    graphs be arrayed into one graph.


{marker byopts}{...}
{title:byopts}

{phang}
{cmd:total} specifies that, in addition to the graphs for each by-group, a
    graph be added for all by-groups combined.

{phang}
{cmd:missing} specifies that, in addition to the graphs for each by-group,
    graphs be added for missing values of {varlist}.
    Missing is defined as {cmd:.}, {cmd:.a}, ..., {cmd:.z} for numeric
    variables and {cmd:""} for string variables.

{phang}
{cmd:colfirst} specifies that the individual graphs be arrayed
    down the columns rather than across the rows.  That is, if there
    were four groups, the graphs would be displayed

		default                  {cmd:colfirst}
		  1  2                    1    3
		  3  4                    2    4

{phang}
{cmd:rows(}{it:#}{cmd:)} and {cmd:cols(}{it:#}{cmd:)} are alternatives.
    They specify that the resulting graphs be arrayed as
    {it:#} rows and however many columns are necessary, or as {it:#}
    columns and however many rows are necessary.  The default is

	    {cmd:cols(}{it:c}{cmd:)}, {it:c} = ceil(sqrt({it:G}))

{pmore}
    where {it:G} is the total number of graphs to be presented and
    ceil() is the function that rounds nonintegers up to the next
    integer.  For instance, if four graphs are to be displayed, the result
    will be presented in a 2{it:x}2 array.  If five graphs are to be
    displayed, the result will be presented as a 2{it:x}3 array because
    ceil(sqrt(5))==3.

{pmore}
    {cmd:cols(}{it:#}{cmd:)} may be specified as larger or smaller
    than {it:c}; {it:r} will be
    the number of rows implied by {it:c}.
    Similarly, {cmd:rows(}{it:#}{cmd:)}
    may be specified as larger or smaller than {it:r}.

{phang}
{cmd:holes(}{it:{help numlist}}{cmd:)}
    specifies which positions in the array are to be left unfilled.
    Consider drawing a graph with three groups and assume that
    the three graphs are being displayed in a 2{it:x}2 array.  By default,
    the first group will appear in the graph at (1,1), the second in
    the graph at (1,2), and the third in the graph at (2,1).  Nothing
    will be displayed in the (2,2) position.

{pmore}
    Specifying {cmd:holes(3)} would cause position (2,1) to be left blank,
    so the third group would appear in (2,2).

{pmore}
    The numbers that you specify in {cmd:holes()} correspond to the position
    number,

	     1  2      1  2  3      1  2  3  4      1  2  3  4  5
	     3  4      4  5  6      5  6  7  8      6  7  8  9 10
		       7  8  9      9 10 11 12     11 12 13 14 15
				   12 14 15 16     16 17 18 19 20
						   21 22 23 24 25    {it:etc.}

{pmore}
    The above is the numbering when {cmd:colfirst} is not specified.  If
    {cmd:colfirst} is specified, the positions are transposed:

	     1  3      1  4  7      1  5  9 13      1  6 11 16 21
	     2  4      2  5  8      2  6 10 14      2  7 12 17 22
		       3  6  9      3  7 11 15      3  8 13 18 23
				    4  8 12 16      4  9 14 19 24
						    5 10 15 20 25    {it:etc.}

{phang}
{cmd:iscale(}{it:#}{cmd:)}
and
{cmd:iscale(*}{it:#}{cmd:)}
    specify a size adjustment (multiplier) to be used to scale the text and
    markers.

{pmore}
    By default, {cmd:iscale()} gets smaller and smaller the larger is
    {it:G}, the number of by-groups and hence the number of graphs
    presented.
    The default is parameterized as a multiplier
    f({it:G}) -- 0<f({it:G})<1,
    f'({it:G})<0 -- that is used to multiply {cmd:msize()},
    {c -(}{cmd:y}|{cmd:x}{c )-}{cmd:label(,labsize())}, and the like.
    The size of everything except the overall titles, subtitles, captions, and
    notes is affected by {cmd:iscale()}.

{pmore}
    If you specify {cmd:iscale(}{it:#}{cmd:)}, the number you
    specify is substituted for f({it:G}).  {cmd:iscale(1)} means
    text and markers should appear at the same size as they would were each
    graph drawn separately.  {cmd:iscale(.5)} displays text and
    markers at half that size.  We recommend you specify a number between 0
    and 1, but you are free to specify numbers larger than 1.

{pmore}
    If you specify {cmd:iscale(*}{it:#}{cmd:)}, the number you
    specify is multiplied by f({it:G}) and that product is used to scale
    text and markers.  {cmd:iscale(*1)} is the default.
    {cmd:iscale(*1.2)} means text and markers should appear
    20% larger than {cmd:graph,} {cmd:by()} would usually choose.
    {cmd:iscale(*.8)} would make them 20% smaller.

{phang}
{cmd:compact}
    is a synonym for {cmd:style(compact)}.  It makes no difference which you
    type.  See the description of the {cmd:style()} option below, and
    see {it:{help by_option##remarks8:By-styles}} under {it:Remarks}.

{phang}
{cmd:style(}{it:bystyle}{cmd:)}
     specifies the overall look of the by-graphs.  The style determines
     whether individual graphs have their own axes and labels or if instead
     the axes and labels are shared across graphs arrayed in the same
     row or in the same column, how close the graphs are to be placed to each
     other, etc.  The other options documented below will allow you to change
     the way the results are displayed, but the {it:bystyle} specifies the
     starting point.

{pmore}
    You need not specify {cmd:style()} just because there is something
    you want to change.  You specify {cmd:style()} when another style exists
    that is exactly what you desire or when another style would allow you to
    specify fewer changes to obtain what you want.

{pmore}
    See {manhelpi bystyle G-4} for a list of by-style choices.
    The {it:byopts} listed below modify the by-style:

{phang}
{cmd:edgelabel} and {cmd:noedgelabel}
     specify whether the last graphs of a column that do not appear in the
     last row are to have their {it:x} axes labeled.
     See {it:{help by_option##remarks9:Labeling the edges}} under {it:Remarks}
     below.

{phang}
{cmd:rescale},
{cmd:yrescale}, and
{cmd:xrescale}
(and
{cmd:norescale},
{cmd:noyrescale}, and
{cmd:noxrescale})
    specify that the scales of each graph be allowed to differ (or forced to
    be the same).  Whether
    {it:X} or {cmd:no}{it:X} is the default is determined by
    {cmd:style()}.

{pmore}
    Usually,
    {cmd:no}{it:X} is the default and
    {cmd:rescale}, {cmd:yrescale}, and {cmd:xrescale} are the options.
    By default, all the graphs will share the same scaling for their
    axes.  Specifying {cmd:yrescale} will allow the
    {it:y} scales to differ across the graphs, specifying
    {cmd:xrescale} will allow the {it:x} scales to differ, and
    specifying {cmd:rescale} is equivalent to specifying {cmd:yrescale} and
    {cmd:xrescale}.

{phang}
{cmd:iyaxes} and {cmd:ixaxes} (and {cmd:noiyaxes} and {cmd:noixaxes})
    specify whether the {it:y} axes and {it:x} axes are to be displayed with
    each graph.  The default with most styles and schemes is to
    place {it:y} axes on the leftmost graph of each row and to place {it:x}
    axes on the bottommost graph of each column.  The {it:y} and {it:x}
    axes include the default ticks and labels but exclude the axes titles.

{phang}
{cmd:iytick} and {cmd:ixtick} (and {cmd:noiytick} and {cmd:noixtick})
    are seldom specified.  If you specified {cmd:iyaxis} and then wanted to
    suppress the ticks, you could also specify {cmd:noiytick}.  In the rare
    event where specifying {cmd:iyaxis} did not result in the ticks being
    displayed (because of how the style or scheme works), specifying
    {cmd:iytick} would cause the ticks to be displayed.

{phang}
{cmd:iylabel} and {cmd:ixlabel} (and {cmd:noiylabel} and {cmd:noixlabel})
    are seldom specified.  If you specified {cmd:iyaxis} and then wanted to
    suppress the axes labels, you could also specify {cmd:noiylabel}.  In the
    rare event where specifying {cmd:iyaxis} did not result in the labels being
    displayed (because of how the style or scheme works), specifying
    {cmd:iylabel} would cause the labels to be displayed.

{phang}
{cmd:iytitle} and {cmd:ixtitle} (and {cmd:noiytitle} and {cmd:noixtitle})
    are seldom specified.  If you specified {cmd:iyaxis} and then wanted
    to add the {it:y}-axes titles (which would make the graph appear 
    busy), you could also specify {cmd:iytitle}.  In the rare event where
    specifying {cmd:iyaxis} resulted in the titles being displayed (because
    of how the style or scheme works), specifying {cmd:noiytitle} would
    suppress displaying the title.

{phang}
{cmd:imargin(}{it:marginstyle}{cmd:)}
    specifies the margins between the individual graphs.

{phang}
{marker legend_options}{...}
{it:legend_options} used within {cmd:by()} sets whether the legend is
    drawn and the legend's placement; see 
    {it:{help by_option##use_of_legends:Use of legends with by()}} below.
    The {cmd:legend()} option is normally {it:merged-implicit}, but
    when used inside {cmd:by()}, it is {it:unique}; see {help repeated options}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help by_option##remarks1:Typical use}
	{help by_option##remarks2:Placement of graphs}
	{help by_option##remarks3:Treatment of titles}
	{help by_option##remarks4:by() uses subtitle() with graph}
	{help by_option##remarks5:Placement of the subtitle()}
	{help by_option##remarks6:by() uses the overall note()}
	{help by_option##remarks7:Use of legends with by()}
	{help by_option##remarks8:By-styles}
	{help by_option##remarks9:Labeling the edges}
	{help by_option##remarks10:Specifying separate scales for the separate plots}
	{help by_option##remarks11:History}


{marker remarks1}{...}
{title:Typical use}

{pstd}
One often has data that divide into different groups -- person data where
the persons are male or female or in different age categories (or both),
country data where the countries can be categorized into different regions of
the world, or, as below, automobile data where the cars are foreign or
domestic.  If you type

	{cmd:. scatter mpg weight}
	  {it:({stata "gr_example auto: scatter mpg weight":click to run})}
{* graph mpgweight}{...}

{pstd}
you obtain a scatterplot of {cmd:mpg} versus {cmd:weight}.  If you add
{cmd:by(foreign)} as an option, you obtain two graphs, one for each value of
{cmd:foreign}:

	{cmd:. scatter mpg weight, by(foreign)}
	  {it:({stata "gr_example auto: scatter mpg weight, by(foreign)":click to run})}
{* graph mpgweightby}{...}

{pstd}
If you add {cmd:total}, another graph will be added representing
the overall total:

	{cmd:. scatter mpg weight, by(foreign, total)}
	  {it:({stata "gr_example auto: scatter mpg weight, by(foreign, total)":click to run})}
{* graph mpgweightbyt}{...}

{pstd}
Here there were three graphs to be presented and {cmd:by()} chose
to display them in a 2{it:x}2 array, leaving the last position empty.


{marker remarks2}{...}
{title:Placement of graphs}

{pstd}
By default, {cmd:by()} places the graphs in a rectangular {it:RxC} array and
leaves empty the positions at the end:

	   Number of      Array        Positions
	    graphs      dimension      left empty
	   {hline 65}
	       1           1{it:x}1
	       2           1{it:x}2
	       3           2{it:x}2         {cmd:4}=(2,2)
	       4           2{it:x}2
	       5           2{it:x}3         {cmd:6}=(3,3)
	       6           2{it:x}3
	       7           3{it:x}3         {cmd:8}=(3,2)   {cmd:9}=(3,3)
	       8           3{it:x}3         {cmd:9}=(3,3)
	       9           3{it:x}3
	      10           3{it:x}4        {cmd:11}=(3,3)  {cmd:12}=(3,4)
	      11           3{it:x}4        {cmd:12}=(3,4)
	      12           3{it:x}4
	      13           4{it:x}4        {cmd:14}=(4,2)  {cmd:15}=(4,3)  {cmd:16}=(4,4)
	      14           4{it:x}4        {cmd:15}=(4,3)  {cmd:16}=(4,4)
	      15           4{it:x}4        {cmd:16}=(4,4)
	      16           4{it:x}4
	      17           4{it:x}5        {cmd:18}=(4,3)  {cmd:19}=(4,4)  {cmd:20}=(4,5)
	      18           4{it:x}5        {cmd:19}=(4,4)  {cmd:20}=(4,5)
	      19           4{it:x}5        {cmd:20}=(4,5)
	      20           4{it:x}5
	      21           5{it:x}5        {cmd:22}=(5,2)  {cmd:23}=(5,3)  {cmd:24}=(5,4)  {cmd:25}=(5,5)
	      22           5{it:x}5        {cmd:23}=(5,3)  {cmd:24}=(5,4)  {cmd:25}=(5,5)
	      23           5{it:x}5        {cmd:24}=(5,4)  {cmd:25}=(5,5)
	      24           5{it:x}5        {cmd:25}=(5,5)
	      25           5{it:x}5
	     {it:etc.}
	   {hline 65}

{pstd}
Options {cmd:rows()}, {cmd:cols()}, and {cmd:holes()} allow you to control
this behavior.

{pstd}
You may specify either {cmd:rows()} or {cmd:cols()}, but not both.  In the
previous section, we drew

	{cmd:. scatter mpg weight, by(foreign, total)}

{pstd}
and had three graphs displayed in a 2{it:x}2 array with a hole at 4.  We could
draw the graph in a 1{it:x}3 array by specifying either {cmd:rows(1)} or
{cmd:cols(3)},

	{cmd:. scatter mpg weight, by(foreign, total rows(1))}
	  {it:({stata "gr_example auto: scatter mpg weight, by(foreign, total rows(1))":click to run})}
{* graph mpgweightbyt1r}{...}

{pstd}
or we could stay with the 2{it:x}2 array and move the hole to 3,

	{cmd:. scatter mpg weight, by(foreign, total holes(3))}
	  {it:({stata "gr_example auto: scatter mpg weight, by(foreign, total holes(3))":click to run})}
{* graph mpgweightbyt3h}{...}


{marker remarks3}{...}
{title:Treatment of titles}

{pstd}
Were you to type

	{cmd:. scatter} {it:yvar} {it:xvar}{cmd:, title("My title") by(catvar)}

{pstd}
"My title" will be repeated above each graph.  {cmd:by()} repeats
the entire {cmd:graph} command and then arrays the results.

{pstd}
To specify titles for the entire graph, specify the
{it:title_options} -- see
{manhelpi title_options G-3} -- inside the {cmd:by()} option:

	{cmd:. scatter} {it:yvar} {it:xvar}{cmd:, by(catvar, title("My title"))}


{marker remarks4}{...}
{title:by() uses subtitle() with graph}

{pstd}
{cmd:by()} labels each graph by using the {cmd:subtitle()}
{it:title_option}.  For instance, in

	{cmd:. scatter mpg weight, by(foreign, total)}

{pstd}
{cmd:by()} labeled the graphs "Domestic", "Foreign", and "Total".  The
subtitle "Total" is what {cmd:by()} uses when the {cmd:total} option is
specified.  The other two subtitles {cmd:by()} obtained from the by-variable
{cmd:foreign}.

{pstd}
{cmd:by()} may be used with numeric or string variables.  Here 
{cmd:foreign} is numeric but happens to have a value label associated with it.
{cmd:by()} obtained the subtitles "Domestic" and "Foreign" from the value
label.  If {cmd:foreign} had no value label, the first two graphs would have
been subtitled "0" and "1", the numeric values of variable {cmd:foreign}.  If
{cmd:foreign} had been a string variable, the subtitles would have been the
string contents of {cmd:foreign}.

{pstd}
If you wish to suppress the subtitle, type

	{cmd:. scatter mpg weight, subtitle("") by(foreign, total)}

{pstd}
If you wish to add "{it:Extra info}" to the subtitle, type

	{cmd:. scatter mpg weight, subtitle("}{it:Extra info}{cmd:", suffix) by(foreign, total)}

{pstd}
Be aware, however, that "{it:Extra info}" will appear above each graph.


{marker remarks5}{...}
{title:Placement of the subtitle()}

{pstd}
You can use {cmd:subtitle()}'s suboptions to control the placement of the
identifying label.  For instance,

	{cmd:. scatter mpg weight,}
		{cmd:subtitle(, ring(0) pos(1) nobexpand) by(foreign, total)}
	  {it:({stata "gr_example auto: scatter mpg weight, subtitle(, ring(0) pos(1) nobexpand) by(foreign, total)":click to run})}
{* graph byopt6}{...}

{pstd}
The result will be to move the identifying label inside the individual graphs,
displaying it in the northeast corner of each.  Type

	{cmd:. scatter mpg weight,}
		{cmd:subtitle(, ring(0) pos(11) nobexpand) by(foreign, total)}

{pstd}
and the identifying label will be moved to the northwest corner.

{pstd}
{cmd:ring(0)} moves the subtitle inside the graph's plot region and
{cmd:position()} defines the location, indicated as clock positions.
{cmd:nobexpand} is rather strange, but just remember to specify it.  By
default, {cmd:by()} sets subtitles to expand to the size of the box that
contains them, which is unusual but makes the default-style subtitles look
good with shading.

{pstd}
See {manhelpi title_options G-3}.


{marker remarks6}{...}
{title:by() uses the overall note()}

{pstd}
By default, {cmd:by()} adds an overall note saying "Graphs by ...".
When you type

	{cmd:. scatter} {it:yvar} {it:xvar}{cmd:, by(catvar)}

{pstd}
results are the same as if you typed

	{cmd:. scatter} {it:yvar} {it:xvar}{cmd:, by(catvar, note("Graphs by ..."))}

{pstd}
If you want to suppress the note, type

	{cmd:. scatter} {it:yvar} {it:xvar}{cmd:, by(catvar, note(""))}

{pstd}
If you want to change the overall note to read "My note", type

	{cmd:. scatter} {it:yvar} {it:xvar}{cmd:, by(catvar, note("My note"))}

{pstd}
If you want to add your note after the default note, type

	{cmd:. scatter} {it:yvar} {it:xvar}{cmd:, by(catvar, note("My note", suffix))}


{* index legends, use with by() tt}{...}
{* index by() tt, use of legends with}{...}
{marker use_of_legends}{...}
{marker remarks7}{...}
{title:Use of legends with by()}

{pstd}
If you wish to modify or suppress the default legend, you must do that
differently when {cmd:by()} is specified.  For instance,
{cmd:legend(off)} -- see {manhelpi legend_options G-3} -- will suppress
the legend, yet typing

	{cmd:. line y1 y2 x, by(group) legend(off)}

{pstd}
will not have the intended effect.  The {cmd:legend(off)} will seemingly be
ignored.  You must instead type

	{cmd:. line y1 y2 x, by(group, legend(off))}

{pstd}
We moved {cmd:legend(off)} inside the {cmd:by()}.

{pstd}
Remember that {cmd:by()} repeats the {cmd:graph} command.  If you think
carefully, you will realize that the legend never was displayed at the
bottom of the individual plots.  It is instructive to type

	{cmd:. line y1 y2 x, legend(on) by(group)}

{pstd}
This graph will have many legends:  one underneath each of
the plots in addition to the overall legend at the bottom of the graph!
{cmd:by()} works exactly as advertised:  it repeats the entire graph command
for each value of {cmd:group}.

{pstd}
In any case, it is the overall {cmd:legend()} that we want to suppress, and
that is why we must specify {cmd:legend(off)} inside the {cmd:by()} option;
this is the same issue as the one discussed under
{it:{help by_option##remarks3:Treatment of titles}} above.

{pstd}
The issue becomes a little more complicated when, rather than suppressing
the legend, we wish to modify the legend's contents or position. Then 
the {cmd:legend()} option to modify the contents is specified outside the
{cmd:by()} and the {cmd:legend()} option to modify the location is
specified inside.  See
{it:{help legend_options##use_of_legends_with_by:Use of legends with by()}} in 
{manhelpi legend_options G-3}.


{marker remarks8}{...}
{title:By-styles}

{pstd}
Option {cmd:style(}{it:bystyle}{cmd:)} specifies the overall look of
by-graphs; see {manhelpi bystyle G-4} for a list of {it:bystyle} choices.
One {it:bystyle} worth noting is {cmd:compact}.  Specifying
{cmd:style(compact)} causes the graph to be displayed in a more compact
format.  Compare

	{cmd:. sysuse lifeexp, clear}

	{cmd:. scatter lexp gnppc, by(region, total)}
	  {it:({stata "gr_example lifeexp: scatter lexp gnppc, by(region, total)":click to run})}
{* graph byopt7}{...}

{pstd}
with

	{cmd:. scatter lexp gnppc, by(region, total style(compact))}
	  {it:({stata "gr_example lifeexp: scatter lexp gnppc, by(region, total style(compact))":click to run})}
{* graph byopt8}{...}

{pstd}
{cmd:style(compact)} pushes the graphs together horizontally and vertically,
leaving more room for the individual graphs.
The disadvantage is that, pushed together, the values on the axes labels
sometimes run into each other, as occurred above with the 40,000 of the
S.A. graph running into the 0 of the Total graph.  That problem could be
solved by dividing {cmd:gnppc} by 1,000.

{pstd}
Rather than typing out {cmd:style(compact)}, you may specify
{cmd:compact}, and you may further abbreviate that as {cmd:com}.


{marker remarks9}{...}
{title:Labeling the edges}

{pstd}
Consider the graph

	{cmd:. scatter mpg weight, by(foreign, total)}
	  {it:({stata "gr_example auto: scatter mpg weight, by(foreign, total)":click to run})}
{* graph mpgweightbyt}{...}

{pstd}
The {it:x} axis is labeled in the graph in the (1,2) position.
When the last graph of a column does not appear in the last row, its
{it:x} axis is referred to as an edge.  In {cmd:style(default)}, the
default is to label the edges, but you could type

	{cmd:. scatter mpg weight, by(foreign, total noedgelabel)}
	  {it:({stata "gr_example auto: scatter mpg weight, by(foreign, total noedgelabel)":click to run})}
{* graph byopt9}{...}

{pstd}
to suppress that.  This results in the rows of graphs being closer to each
other.

{pstd}
Were you to type

{phang2}
	{cmd:. scatter mpg weight, by(foreign, total style(compact))}

{pstd}
you would discover that the {it:x} axis of the (1,2) graph is not labeled.
With {cmd:style(compact)}, the default is {cmd:noedgelabel}, but you
could specify {cmd:edgelabel} to override that.


{marker remarks10}{...}
{title:Specifying separate scales for the separate plots}

{pstd}
If you type

{phang2}
	{cmd:. scatter} {it:yvar} {it:xvar}{cmd:, by(}{it:catvar}{cmd:, yrescale)}

{pstd}
each graph will be given a separately scaled {it:y} axis; if you type

{phang2}
	{cmd:. scatter} {it:yvar} {it:xvar}{cmd:, by(}{it:catvar}{cmd:, xrescale)}

{pstd}
each graph will be given a separately scaled {it:x} axis; and if you type

{phang2}
	{cmd:. scatter} {it:yvar} {it:xvar}{cmd:, by(}{it:catvar}{cmd:, yrescale xrescale)}

{pstd}
both scales will be separately set.


{* index histories}{...}
{* index casement displays}{...}
{* index Chambers, et al.}{...}
{marker remarks11}{...}
{title:History}

{pstd}
The twoway scatterplots produced by the {cmd:by()} option are similar to what
are known as {it:casement} {it:displays}
(see {help by_option##C1983:Chambers et al. [1983, 141-145]}).  A traditional
casement display, however, aligns all the graphs either vertically or
horizontally.


{marker reference}{...}
{title:Reference}

{marker C1983}{...}
{phang}
Chambers, J. M., W. S. Cleveland, B. Kleiner, and P. A. Tukey. 1983.
{it:Graphical Methods for Data Analysis}. Belmont, CA: Wadsworth.
{p_end}
