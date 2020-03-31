{smcl}
{* *! version 1.1.9  17apr2019}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway rbar" "mansection G-2 graphtwowayrbar"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway bar" "help twoway_bar"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway rarea" "help twoway_rarea"}{...}
{vieweralsosee "[G-2] graph twoway rcap" "help twoway_rcap"}{...}
{vieweralsosee "[G-2] graph twoway rcapsym" "help twoway_rcapsym"}{...}
{vieweralsosee "[G-2] graph twoway rconnected" "help twoway_rconnected"}{...}
{vieweralsosee "[G-2] graph twoway rline" "help twoway_rline"}{...}
{vieweralsosee "[G-2] graph twoway rscatter" "help twoway_rscatter"}{...}
{vieweralsosee "[G-2] graph twoway rspike" "help twoway_rspike"}{...}
{viewerjumpto "Syntax" "twoway_rbar##syntax"}{...}
{viewerjumpto "Menu" "twoway_rbar##menu"}{...}
{viewerjumpto "Description" "twoway_rbar##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_rbar##linkspdf"}{...}
{viewerjumpto "Options" "twoway_rbar##options"}{...}
{viewerjumpto "Remarks" "twoway_rbar##remarks"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[G-2] graph twoway rbar} {hline 2}}Range plot with bars{p_end}
{p2col:}({mansection G-2 graphtwowayrbar:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 60 2}
{cmdab:tw:oway}
{cmd:rbar}
{it:y1var} {it:y2var} {it:xvar}
{ifin}
[{cmd:,}
{it:options}]

{synoptset 22}{...}
{p2col:{it:options}}Description{p_end}
{p2line}
{p2col:{cmdab:vert:ical}}vertical bars; the default{p_end}
{p2col:{cmdab:hor:izontal}}horizontal bars{p_end}
{p2col:{cmdab:barw:idth:(}{it:#}{cmd:)}}width of bar in {it:xvar} units{p_end}
{p2col:{cmdab:mw:idth}}use {cmd:msize()} rather than {cmd:barwidth()}{p_end}
{p2col:{cmdab:msiz:e:(}{it:{help markersizestyle}}{cmd:)}}width of bar{p_end}

INCLUDE help gr_baropt

INCLUDE help gr_axlnk

INCLUDE help gr_twopt
{p2line}
{p2colreset}{...}
{p 4 6 2}
Options {cmd:barwidth()}, {cmd:mwidth}, and {cmd:msize()} are {it:rightmost},
and {cmd:vertical} and {cmd:horizontal} are {it:unique}; see 
{help repeated options}.


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
{cmd:twoway} {cmd:rbar} plots a range, using bars to connect the high and
low values.

{pstd}
Also see {manhelp graph_bar G-2:graph bar} for more traditional bar charts.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowayrbarQuickstart:Quick start}

        {mansection G-2 graphtwowayrbarRemarksandexamples:Remarks and examples}

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
{cmd:barwidth(}{it:#}{cmd:)}
    specifies the width of the bar in {it:xvar} units.  The default is
    {cmd:barwidth(1)}.  When a bar is plotted, it is centered at {it:x}, so half
    the width extends below {it:x} and half above.

{phang}
{cmd:mwidth}
and
{cmd:msize(}{it:markersizestyle}{cmd:)}
    change how the width of the bars is specified.  Usually, the width of the
    bars is determined by the {cmd:barwidth()} option documented below.  If
    {cmd:mwidth} is specified, {cmd:barwidth()} becomes irrelevant and the bar
    width switches to being determined by {cmd:msize()}.  This all has to do
    with the units in which the width of the bar is specified.

{pmore}
    By default, bar widths are specified in the units of {it:xvar}, and if
    option {cmd:barwidth()} is not specified, the default width is 1 {it:xvar}
    unit.

{pmore}
    {cmd:mwidth} specifies that you wish bar widths to be measured in
    size units; see {manhelpi size G-4}.
    When you specify {cmd:mwidth}, the default changes from being 1
    {it:xvar} unit to the default width of a marker symbol.

{pmore}
    If you also specify {cmd:msize()}, the width of
    the bar is modified to be the size specified.

INCLUDE help gr_baroptf

INCLUDE help gr_axlnkf

INCLUDE help gr_twoptf


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help twoway rbar##remarks1:Typical use}
	{help twoway rbar##remarks2:Advanced use}


{marker remarks1}{...}
{title:Typical use}

{pstd}
We have daily data recording the values for the S&P 500 in 2001:

	{cmd:. sysuse sp500}

	{cmd:. list date high low close in 1/5}
	{txt}
	     {c TLC}{hline 11}{c -}{hline 9}{c -}{hline 9}{c -}{hline 9}{c TRC}
	     {c |} {res}     date      high       low     close {txt}{c |}
	     {c LT}{hline 11}{c -}{hline 9}{c -}{hline 9}{c -}{hline 9}{c RT}
	  1. {c |} {res}02jan2001   1320.28   1276.05   1283.27 {txt}{c |}
	  2. {c |} {res}03jan2001   1347.76   1274.62   1347.56 {txt}{c |}
	  3. {c |} {res}04jan2001   1350.24   1329.14   1333.34 {txt}{c |}
	  4. {c |} {res}05jan2001   1334.77   1294.95   1298.35 {txt}{c |}
	  5. {c |} {res}08jan2001   1298.35   1276.29   1295.86 {txt}{c |}
	     {c BLC}{hline 11}{c -}{hline 9}{c -}{hline 9}{c -}{hline 9}{c BRC}{txt}

{pstd}
We will use the first 57 observations from these data:

	{cmd:. twoway rbar high low date in 1/57, barwidth(.6)}
	  {it:({stata "gr_example sp500: twoway rbar high low date in 1/57, barwidth(.6)":click to run})}
{* graph gtrbar1}{...}

{pstd}
We specified {cmd:barwidth(.6)} to reduce the width of the bars.  By
default, bars are 1 {it:x} unit wide (meaning 1 day in our data).  That
default resulted in the bars touching.  {cmd:barwidth(.6)} reduced the width
of the bars to .6 days.


{marker remarks2}{...}
{title:Advanced use}

{pstd}
The useful thing about {cmd:twoway} {cmd:rbar} is that it can be combined
with other {helpb twoway} plottypes:

	{cmd}. twoway rbar high low date, barwidth(.6) color(gs7) ||
		 line close date || in 1/57{txt}
	  {it:({stata "gr_example sp500: twoway rbar high low date, barwidth(.6) color(gs7) || line close date || in 1/57":click to run})}
{* graph gtrbar2}{...}

{pstd}
There are two things to note in the example above:  our specification of
{cmd:color(gs7)} and that we specified that the range bars be drawn first,
followed by the line.  We specified {cmd:color(gs7)} to tone down the bars:
By default, the bars were too bright, making the line plot
of close versus date all but invisible.
Concerning the ordering, we typed

	{cmd}. twoway rbar high low date, barwidth(.6) color(gs7) ||
		 line close date || in 1/57{txt}

{pstd}
so that the bars would be drawn first and then the line drawn over them.
Had we specified

	{cmd}. twoway line close date ||
		 rbar high low date, barwidth(.6) color(gs7) || in 1/57{txt}

{pstd}
the bars would have been placed on top of the line and thus would have occulted
the line.
{p_end}
