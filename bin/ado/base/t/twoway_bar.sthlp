{smcl}
{* *! version 1.1.9  19oct2017}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway bar" "mansection G-2 graphtwowaybar"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway scatter" "help scatter"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway dot" "help twoway_dot"}{...}
{vieweralsosee "[G-2] graph twoway dropline" "help twoway_dropline"}{...}
{vieweralsosee "[G-2] graph twoway histogram" "help twoway_histogram"}{...}
{vieweralsosee "[G-2] graph twoway spike" "help twoway_spike"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph bar" "help graph_bar"}{...}
{viewerjumpto "Syntax" "twoway_bar##syntax"}{...}
{viewerjumpto "Menu" "twoway_bar##menu"}{...}
{viewerjumpto "Description" "twoway_bar##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_bar##linkspdf"}{...}
{viewerjumpto "Options" "twoway_bar##options"}{...}
{viewerjumpto "Remarks" "twoway_bar##remarks"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[G-2] graph twoway bar} {hline 2}}Twoway bar plots{p_end}
{p2col:}({mansection G-2 graphtwowaybar:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 52 2}
{cmdab:tw:oway}
{cmd:bar}
{it:yvar} {it:xvar}
{ifin}
[{cmd:,}
{it:options}]

{synoptset 20}{...}
{p2col:{it:options}}Description{p_end}
{p2line}
{p2col:{cmdab:vert:ical}}vertical bar plot; the default{p_end}
{p2col:{cmdab:hor:izontal}}horizontal bar plot{p_end}
{p2col:{cmd:base(}{it:#}{cmd:)}}value to drop to; default is 0{p_end}
{p2col:{cmdab:barw:idth:(}{it:#}{cmd:)}}width of bar in {it:xvar} units{p_end}

INCLUDE help gr_baropt

INCLUDE help gr_axlnk

INCLUDE help gr_twopt
{p2line}
{p2colreset}{...}
{p 4 6 2}
Options {cmd:base()} and {cmd:barwidth()} are {it:rightmost}, and {cmd:vertical}
and {cmd:horizontal} are {it:unique}; see {help repeated options}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Twoway graph (scatter, line, etc.)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:twoway} {cmd:bar} displays numeric ({it:y},{it:x}) data as bars.
{cmd:twoway} {cmd:bar} is useful for drawing bar plots of time-series
data or other equally spaced data and is useful as a programming tool.
For finely spaced data, also see
{manhelp twoway_spike G-2:graph twoway spike}.

{pstd}
Also see {manhelp graph_bar G-2:graph bar} for traditional bar charts and 
{manhelp twoway_histogram G-2:graph twoway histogram} for histograms.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowaybarQuickstart:Quick start}

        {mansection G-2 graphtwowaybarRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:vertical} and {cmd:horizontal}
    specify either a vertical or a horizontal bar plot.
    {cmd:vertical} is the default.  If {cmd:horizontal} is specified, the
    values recorded in {it:yvar} are treated as {it:x} values, and the values
    recorded in {it:xvar} are treated as {it:y} values.
    That is, to make horizontal plots, do not switch the order of the
    two variables specified.

{pmore}
    In the {cmd:vertical} case, bars are drawn at the specified {it:xvar}
    values and extend up or down from 0 according to the corresponding
    {it:yvar} values.  If 0 is not in the range of the {it:y} axis,
    bars extend up or down to the {it:x} axis.

{pmore}
    In the {cmd:horizontal} case, bars are drawn at the specified {it:xvar}
    values and extend left or right from 0 according to the corresponding
    {it:yvar} values.  If 0 is not in the range of the {it:x} axis,
    bars extend left or right to the {it:y} axis.

{phang}
{cmd:base(}{it:#}{cmd:)}
    specifies the value from which the bar should extend.
    The default is {cmd:base(0)}, and in the above description of options
    {cmd:vertical} and {cmd:horizontal}, this default was assumed.

{phang}
{cmd:barwidth(}{it:#}{cmd:)}
    specifies the width of the bar in {it:xvar} units.  The default is
    {cmd:width(1)}.  When a bar is plotted, it is centered at {it:x}, so half
    the width extends below {it:x} and half above.

INCLUDE help gr_baroptf

INCLUDE help gr_axlnkf

INCLUDE help gr_twoptf


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help twoway bar##remarks1:Typical use}
	{help twoway bar##remarks2:Advanced use:  Overlaying}
	{help twoway bar##remarks3:Advanced use:  Population pyramid}
	{help twoway bar##remarks4:Cautions}


{marker remarks1}{...}
{title:Typical use}

{pstd}
We have daily data recording the values for the S&P 500 in 2001:

	{cmd:. sysuse sp500}

	{cmd:. list date close change in 1/5}
	     {c TLC}{hline 11}{c -}{hline 9}{c -}{hline 11}{c TRC}
	     {c |} {res}     date     close      change {txt}{c |}
	     {c LT}{hline 11}{c -}{hline 9}{c -}{hline 11}{c RT}
	  1. {c |} {res}02jan2001   1283.27           . {txt}{c |}
	  2. {c |} {res}03jan2001   1347.56    64.29004 {txt}{c |}
	  3. {c |} {res}04jan2001   1333.34   -14.22009 {txt}{c |}
	  4. {c |} {res}05jan2001   1298.35   -34.98999 {txt}{c |}
	  5. {c |} {res}08jan2001   1295.86    -2.48999 {txt}{c |}
	     {c BLC}{hline 11}{c -}{hline 9}{c -}{hline 11}{c BRC}

{pstd}
We will use the first 57 observations from these data:

	{cmd:. twoway bar change date in 1/57}
	  {it:({stata "gr_example sp500: twoway bar change date in 1/57":click to run})}
{* graph gtbar1}{...}

{pstd}
We get a different visual effect if we reduce the width of the bars
from 1 day to .6 days:

	{cmd:. twoway bar change date in 1/57, barw(.6)}
	  {it:({stata "gr_example sp500: twoway bar change date in 1/57, barw(.6)":click to run})}
{* graph gtbar2}{...}


{marker remarks2}{...}
{title:Advanced use:  Overlaying}

{pstd}
The useful thing about {cmd:twoway} {cmd:bar} is that it can be combined
with other {helpb twoway} plottypes:

{phang2}
	{cmd:. twoway line close date || bar change date || in 1/52}
{p_end}
	  {it:({stata "gr_example sp500: twoway line close date || bar change date || in 1/52":click to run})}
{* graph gtbar3}{...}

{pstd}
We can improve this graph by typing

	{cmd}. twoway
		line close date, yaxis(1)
	||
		bar change date, yaxis(2)
	||
	in 1/52,
		ysca(axis(1) r(1000 1400)) ylab(1200(50)1400, axis(1))
		ysca(axis(2) r(-50 300)) ylab(-50 0 50, axis(2))
			ytick(-50(25)50, axis(2) grid)
		legend(off)
		xtitle("Date")
		title("S&P 500")
		subtitle("January - March 2001")
		note("Source:  Yahoo!Finance and Commodity Systems, Inc.")
		yline(1150, axis(1) lstyle(foreground)){txt}
	  {it:({stata "gr_example2 twobar":click to run})}
{* graph twobar}{...}

{pstd}
Notice the use of

		{cmd:yline(1150, axis(1) lstyle(foreground))}

{pstd}
The 1150 put the horizontal line at {it:y}=1150; {cmd:axis(1)}
stated that {it:y} should be interpreted according to the left
{it:y} axis; and {cmd:lstyle(foreground)} specified that the line
be drawn in the foreground style.


{marker remarks3}{...}
{title:Advanced use:  Population pyramid}
{* index population pyramid}{...}
{* index pyramid, population}{...}

{pstd}
We have the following aggregate data from the U.S. 2000 Census recording
total population by age and sex.  From this, we produce a population pyramid:

        {cmd:. sysuse pop2000, clear}
 
	{cmd}. list agegrp maletotal femtotal
	{txt}
	     {c TLC}{hline 10}{c -}{hline 12}{c -}{hline 12}{c TRC}
	     {c |} {res}  agegrp    maletotal     femtotal {txt}{c |}
	     {c LT}{hline 10}{c -}{hline 12}{c -}{hline 12}{c RT}
	  1. {c |} {res} Under 5    9,810,733    9,365,065 {txt}{c |}
	  2. {c |} {res}  5 to 9   10,523,277   10,026,228 {txt}{c |}
	  3. {c |} {res}10 to 14   10,520,197   10,007,875 {txt}{c |}
	  4. {c |} {res}15 to 19   10,391,004    9,828,886 {txt}{c |}
	  5. {c |} {res}20 to 24    9,687,814    9,276,187 {txt}{c |}
	     {c LT}{hline 10}{c -}{hline 12}{c -}{hline 12}{c RT}
	  6. {c |} {res}25 to 29    9,798,760    9,582,576 {txt}{c |}
	  7. {c |} {res}30 to 34   10,321,769   10,188,619 {txt}{c |}
	  8. {c |} {res}35 to 39   11,318,696   11,387,968 {txt}{c |}
	  9. {c |} {res}40 to 44   11,129,102   11,312,761 {txt}{c |}
	 10. {c |} {res}45 to 49    9,889,506   10,202,898 {txt}{c |}
	     {c LT}{hline 10}{c -}{hline 12}{c -}{hline 12}{c RT}
	 11. {c |} {res}50 to 54    8,607,724    8,977,824 {txt}{c |}
	 12. {c |} {res}55 to 59    6,508,729    6,960,508 {txt}{c |}
	 13. {c |} {res}60 to 64    5,136,627    5,668,820 {txt}{c |}
	 14. {c |} {res}65 to 69    4,400,362    5,133,183 {txt}{c |}
	 15. {c |} {res}70 to 74    3,902,912    4,954,529 {txt}{c |}
	     {c LT}{hline 10}{c -}{hline 12}{c -}{hline 12}{c RT}
	 16. {c |} {res}75 to 79    3,044,456    4,371,357 {txt}{c |}
	 17. {c |} {res}80 to 84    1,834,897    3,110,470 {txt}{c |}
	     {c BLC}{hline 10}{c -}{hline 12}{c -}{hline 12}{c BRC}

	{cmd:. replace maletotal = -maletotal/1e+6}

	{cmd:. replace femtotal = femtotal/1e+6}

	{cmd}. twoway
		 bar maletotal agegrp, horizontal xvarlab(Males)
	  ||
		 bar  femtotal agegrp, horizontal xvarlab(Females)
	  ||
	  , ylabel(1(1)17, angle(horizontal) valuelabel labsize(*.8))
	    xtitle("Population in millions") ytitle("")
	    xlabel(-10 "10" -7.5 "7.5" -5 "5" -2.5 "2.5" 2.5 5 7.5 10)
	    legend(label(1 Males) label(2 Females))
	    title("US Male and Female Population by Age")
	    subtitle("Year 2000")
	    note("Source:  U.S. Census Bureau, Census 2000, Tables 1, 2 and 3",
		  span){txt}
	  {it:({stata "gr_example2 twobar2":click to run})}
{* graph twobar2}{...}

{pstd}
At its heart, the above graph is simple:  we turned the bars sideways
and changed the male total to be negative.  Our first attempt at the
above was simply

	{cmd}. sysuse pop2000, clear

	. replace maletotal = -maletotal

	. twoway bar maletotal agegrp, horizontal ||
		 bar  femtotal agegrp, horizontal{txt}
	  {it:({stata "gr_example2 twobar3":click to run})}
{* graph twobar3}{...}

{pstd}
From there, we divided the population totals by 1 million and added options.

{pstd}
{cmd:xlabel(-10 "10" -7.5 "7.5" -5 "5" -2.5 "2.5" 2.5 5 7.5 10)}
was a clever way to disguise that the bars for males extended in the
negative direction.  We said to label the values -10, -7.5, -5, -2.5, 2.5, 5,
7.5, and 10, but then we substituted text for the negative numbers to make
it appear that they were positive.
See {manhelpi axis_label_options G-3}.

{pstd}
Using the {cmd:span} suboption to {cmd:note()}
aligned the text on the left side of the graph
rather than on the plot region.
See {manhelpi textbox_options G-3}.

{pstd}
For another rendition of the pyramid, we tried

	{cmd}. sysuse pop2000, clear

	. replace maletotal = -maletotal/1e+6

	. replace femtotal = femtotal/1e+6

	. gen zero = 0

	. twoway
	      bar maletotal agegrp, horizontal xvarlab(Males)
	||
	      bar  femtotal agegrp, horizontal xvarlab(Females)
	||
	      sc  agegrp zero     , mlabel(agegrp) mlabcolor(black) msymbol(i)
	||
	, xtitle("Population in millions") ytitle("")
	  plotregion(style(none)){txt}{it:{right:(note 1)}}{cmd}
	  ysca(noline) ylabel(none){txt}{it:{right:(note 2)}}{cmd}
	  xsca(noline titlegap(-3.5)){txt}{it:{right:(note 3)}}{cmd}
	  xlabel(-12 "12" -10 "10" -8 "8" -6 "6" -4 "4" 4(2)12, tlength(0)
								grid gmin gmax)
	  legend(label(1 Males) label(2 Females)) legend(order(1 2))
	  title("US Male and Female Population by Age, 2000")
	  note("Source:  U.S. Census Bureau, Census 2000, Tables 1, 2 and 3"){txt}
	  {it:({stata "gr_example2 twobar4":click to run})}
{* graph twobar4}{...}

{pstd}
In the above rendition, we moved the labels from the {it:x} axis to
inside the bars by overlaying a {cmd:scatter} on top of the bars.
The points of the scatter we plotted at {it:y}=agegrp and {it:x}=0, and
rather than showing the markers, we displayed marker labels containing the
desired labelings.
See {manhelpi marker_label_options G-3}.

{pstd}
We also played the following tricks:

{phang2}
1.  {cmd:plotregion(style(none))} suppressed outlining the plot
    region; see {manhelpi region_options G-3}.

{phang2}
2.  {cmd:ysca(noline)} suppressed drawing the {it:y} axis -- see
    {manhelpi axis_scale_options G-3} -- and {cmd:ylabel(none)} suppressed
    labeling it -- see {manhelpi axis_label_options G-3}.

{phang2}
3.  {cmd:xsca(noline titlegap(-3.5))}
    suppressed drawing the {it:x} axis and moved
    the {it:x}-axis title up to be in between its labels;
    see {manhelpi axis_scale_options G-3}.


{marker remarks4}{...}
{title:Cautions}

{pstd}
You must extend the scale of the axis, if that is
necessary.  Consider using {cmd:twoway} {cmd:bar} to produce a histogram
(ignoring the better alternative of using {helpb twoway histogram}).
Assume that you have already aggregated data of the form

	x     frequency
	{hline 15}
	1        400
	2        800
	3      3,000
	4      1,800
	5      1,100
	{hline 15}

{pstd}
which you enter into Stata to make variables {cmd:x} and {cmd:frequency}.  You
type

	{cmd:. twoway bar frequency x}

{pstd}
to make a histogram-style bar chart.  The {it:y} axis will be scaled
to go between 400 and 3,000 (labeled at 500, 1,000, ..., 3,000),
and the shortest bar will have zero height.  You need to type

	{cmd:. twoway bar frequency x, ysca(r(0))}
