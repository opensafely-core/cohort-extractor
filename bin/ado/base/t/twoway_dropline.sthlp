{smcl}
{* *! version 1.1.8  19oct2017}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway dropline" "mansection G-2 graphtwowaydropline"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway scatter" "help scatter"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway spike" "help twoway_spike"}{...}
{viewerjumpto "Syntax" "twoway_dropline##syntax"}{...}
{viewerjumpto "Menu" "twoway_dropline##menu"}{...}
{viewerjumpto "Description" "twoway_dropline##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_dropline##linkspdf"}{...}
{viewerjumpto "Options" "twoway_dropline##options"}{...}
{viewerjumpto "Remarks" "twoway_dropline##remarks"}{...}
{p2colset 1 32 34 2}{...}
{p2col:{bf:[G-2] graph twoway dropline} {hline 2}}Twoway dropped-line plots{p_end}
{p2col:}({mansection G-2 graphtwowaydropline:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 57 2}
{cmdab:tw:oway}
{cmd:dropline}
{it:yvar} {it:xvar}
{ifin}
[{cmd:,}
{it:options}]

{synoptset 22}{...}
{p2col:{it:options}}Description{p_end}
{p2line}
{p2col:{cmdab:vert:ical}}vertical dropped-line plot; the default{p_end}
{p2col:{cmdab:hor:izontal}}horizontal dropped-line plot{p_end}
{p2col:{cmd:base(}{it:#}{cmd:)}}value to drop to; default is 0{p_end}

INCLUDE help gr_markopt
{p2col:{it:{help line_options}}}change look of dropped lines{p_end}

INCLUDE help gr_axlnk

INCLUDE help gr_twopt
{p2line}
{p2colreset}{...}
{p 4 6 2}
All explicit options are {it:rightmost}, except {cmd:vertical} 
and {cmd:horizontal}, which are {it:unique}; see 
{help repeated options}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Twoway graph (scatter, line, etc.)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:twoway} {cmd:dropline} displays numeric ({it:y},{it:x}) data as
dropped lines capped with a marker.
{cmd:twoway} {cmd:dropline} is useful for drawing plots in which the
numbers vary around zero.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowaydroplineQuickstart:Quick start}

        {mansection G-2 graphtwowaydroplineRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:vertical} and {cmd:horizontal}
    specify either a vertical or a horizontal dropped-line plot.
    {cmd:vertical} is the default.  If {cmd:horizontal} is specified, the
    values recorded in {it:yvar} are treated as {it:x} values, and the values
    recorded in {it:xvar} are treated as {it:y} values.
    That is, to make horizontal plots, do not switch the order of the
    two variables specified.

{pmore}
    In the {cmd:vertical} case, dropped lines are drawn at the specified
    {it:xvar} values and extend up or down from 0 according to the
    corresponding {it:yvar} values.  If 0 is not in the range of the {it:y}
    axis, lines extend up or down to the {it:x} axis.

{pmore}
    In the {cmd:horizontal} case, dropped lines are drawn at the specified
    {it:xvar} values and extend left or right from 0 according to the
    corresponding {it:yvar} values.  If 0 is not in the range of the {it:x}
    axis, lines extend left or right to the {it:y} axis.

{phang}
{cmd:base(}{it:#}{cmd:)}
    specifies the value from which the lines should extend.
    The default is {cmd:base(0)}, and in the above description of options
    {cmd:vertical} and {cmd:horizontal}, this default was assumed.

{phang}
{it:marker_options}
    specify the look of markers plotted at the data points.  This look
    includes the marker symbol and its size, color, and outline; see 
    {manhelpi marker_options G-3}.

{phang}
{it:marker_label_options}
    specify if and how the markers are to be labeled; 
    see {manhelpi marker_label_options G-3}.

{phang}
{it:line_options} 
    specify the look of the dropped lines, including pattern, width, and
    color; see {manhelpi line_options G-3}.

INCLUDE help gr_axlnkf

INCLUDE help gr_twoptf


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help twoway_dropline##remarks1:Typical use}
	{help twoway_dropline##remarks2:Advanced use}
	{help twoway_dropline##remarks3:Cautions}


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
In {manhelp twoway_bar G-2:graph twoway bar} we graphed the first 57
observations of these data by using bars.  Here is the same graph presented as
dropped lines:

{phang2}
	{cmd:. twoway dropline change date in 1/57, yline(0, lstyle(foreground))}
{p_end}
	  {it:({stata "gr_example sp500: twoway dropline change date in 1/57, yline(0, lstyle(foreground))":click to run})}
{* graph gtdropline1}{...}

{pstd}
In the above, we specified {cmd:yline(0)} to add a line across the graph
at 0, and then we specified {cmd:yline(, lstyle(foreground))} so that the line
would have the same color as the foreground.
We could have instead specified {cmd:yline(, lcolor())}.  For an explanation
of why we chose {cmd:lstyle()} over {cmd:foreground()}, see
{it:{help twoway_bar##remarks2:Advanced use: Overlaying}} in
{manhelp twoway_bar G-2:graph twoway bar}.


{marker remarks2}{...}
{title:Advanced use}

{pstd}
Dropped-line plots work especially well when the points are labeled.
For instance,

	{cmd}. sysuse lifeexp, clear

	. keep if region==3

	. generate lngnp = ln(gnppc)

	. quietly regress le lngnp

	. predict r, resid

	. twoway dropline r gnp,
		yline(0, lstyle(foreground)) mlabel(country) mlabpos(9)
		ylab(-6(1)6)
		subtitle("Regression of life expectancy on ln(gnp)"
			 "Residuals:" " ", pos(11))
		note("Residuals in years; positive values indicate"
		     "longer than predicted life expectancy"){txt}
	  {it:({stata "gr_example2 twodropline":click to run})}
{* graph twodropline}{...}


{marker remarks3}{...}
{title:Cautions}

{pstd}
See {it:{help twoway bar##remarks4:Cautions}} in
{manhelp twoway_bar G-2:graph twoway bar}, which applies
equally to {cmd:twoway} {cmd:dropline}.
{p_end}
