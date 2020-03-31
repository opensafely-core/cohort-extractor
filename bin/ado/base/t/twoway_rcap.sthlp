{smcl}
{* *! version 1.1.10  19oct2017}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway rcap" "mansection G-2 graphtwowayrcap"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway rarea" "help twoway_rarea"}{...}
{vieweralsosee "[G-2] graph twoway rbar" "help twoway_rbar"}{...}
{vieweralsosee "[G-2] graph twoway rcapsym" "help twoway_rcapsym"}{...}
{vieweralsosee "[G-2] graph twoway rconnected" "help twoway_rconnected"}{...}
{vieweralsosee "[G-2] graph twoway rline" "help twoway_rline"}{...}
{vieweralsosee "[G-2] graph twoway rscatter" "help twoway_rscatter"}{...}
{vieweralsosee "[G-2] graph twoway rspike" "help twoway_rspike"}{...}
{viewerjumpto "Syntax" "twoway_rcap##syntax"}{...}
{viewerjumpto "Menu" "twoway_rcap##menu"}{...}
{viewerjumpto "Description" "twoway_rcap##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_rcap##linkspdf"}{...}
{viewerjumpto "Options" "twoway_rcap##options"}{...}
{viewerjumpto "Remarks" "twoway_rcap##remarks"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[G-2] graph twoway rcap} {hline 2}}Range plot with capped spikes{p_end}
{p2col:}({mansection G-2 graphtwowayrcap:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 60 2}
{cmdab:tw:oway}
{cmd:rcap}
{it:y1var} {it:y2var} {it:xvar}
{ifin}
[{cmd:,}
{it:options}]

{synoptset 22}{...}
{p2col: {it:options}}Description{p_end}
{p2line}
{p2col:{cmdab:vert:ical}}vertical spikes; the default{p_end}
{p2col:{cmdab:hor:izontal}}horizontal spikes{p_end}

{p2col:{it:{help line_options}}}change look of spike and cap lines{p_end}
{p2col:{cmdab:msiz:e:(}{it:{help markersizestyle}}{cmd:)}}width of cap{p_end}

INCLUDE help gr_axlnk

INCLUDE help gr_twopt
{p2line}
{p2colreset}{...}
{p 4 6 2}
All explicit options are {it:rightmost}, except {cmd:vertical}
and {cmd:horizontal}, which are {it:unique}; see {help repeated options}.


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
{cmd:twoway} {cmd:rcap} plots a range, using capped spikes (I-beams) to connect
the high and low values.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowayrcapQuickstart:Quick start}

        {mansection G-2 graphtwowayrcapRemarksandexamples:Remarks and examples}

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
    In the default {cmd:vertical} case, {it:y1var} and {it:y2var} record
    the minimum and maximum (or maximum and minimum) {it:y} values to be
    graphed against each {it:xvar} value.

{pmore}
    If {cmd:horizontal} is specified, the values recorded in {it:y1var} and
    {it:y2var} are plotted in the {it:x} direction, and {it:xvar} is treated
    as the {it:y} value.

{phang}
{it:line_options} 
    specify the look of the lines used to draw the spikes and their caps,
    including pattern, width, and color; see {manhelpi line_options G-3}.{p_end}

{phang}
{cmd:msize(}{it:markersizestyle}{cmd:)}
    specifies the width of the cap.  Option {cmd:msize()} is in fact
    {cmd:twoway} {cmd:scatter}'s {it:marker_option} that sets the size of the
    marker symbol, but here {cmd:msymbol()} is borrowed to set the cap
    width.  See {manhelpi markersizestyle G-4} for a list of size choices.

INCLUDE help gr_axlnkf

INCLUDE help gr_twoptf


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

        {help twoway_rcap##remarks1:Typical use}
        {help twoway_rcap##remarks2:Advanced use}
        {help twoway_rcap##remarks3:Advanced use 2}


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
We will use the first 37 observations from these data:

	{cmd:. twoway rcap high low date in 1/37}
	  {it:({stata "gr_example sp500: twoway rcap high low date in 1/37":click to run})}
{* graph gtrcap1}{...}


{marker remarks2}{...}
{title:Advanced use}

{pstd}
{cmd:twoway} {cmd:rcap}
works well when combined with a horizontal line representing a base value:

	{cmd}. sysuse sp500, clear

	. generate month = month(date)

	. sort month

	. by month: egen lo = min(volume)

	. by month: egen hi = max(volume)

	. format lo hi %10.0gc

	. summarize volume

	{txt}    Variable {c |}       Obs        Mean    Std. Dev.       Min        Max
	{hline 13}{c +}{hline 56}
	      volume {c |}{res}       248    12320.68    2585.929       4103    23308.3{cmd}

	. by month: keep if _n==_N

	. twoway rcap lo hi month,
	    xlabel(1 "J"  2 "F"  3 "M"  4 "A"  5 "M"  6 "J"
		   7 "J"  8 "A"  9 "S" 10 "O" 11 "N" 12 "D")
	    xtitle("Month of 2001")
	    ytitle("High and Low Volume")
	    yaxis(1 2) ylabel(12321 "12,321 (mean)", axis(2) angle(0))
	    ytitle("", axis(2))
	    yline(12321, lstyle(foreground))
	    msize(*2)
	    title("Volume of the S&P 500", margin(b+2.5))
	    note("Source:  Yahoo!Finance and Commodity Systems Inc."){txt}
	  {it:({stata "gr_example2 tworcap":click to run})}
{* graph tworcap}{...}


{marker remarks3}{...}
{title:Advanced use 2}

{pstd}
{cmd:twoway} {cmd:rcap}
also works well when combined with a scatterplot to produce hi-lo-middle
graphs.  Returning to the first 37 observations of the S&P 500 used in the
first example, we add a scatterplot of the closing value:

	{cmd:. sysuse sp500, clear}

	{cmd:. twoway rcap high low date || scatter close date}
	  {it:({stata "gr_example sp500: twoway rcap high low date || scatter close date || in 1/37":click to run})}
{* graph gtrcap1b}{...}
