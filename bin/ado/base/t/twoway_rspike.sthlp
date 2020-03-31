{smcl}
{* *! version 1.1.8  19oct2017}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway rspike" "mansection G-2 graphtwowayrspike"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway spike" "help twoway_spike"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway rarea" "help twoway_rarea"}{...}
{vieweralsosee "[G-2] graph twoway rbar" "help twoway_rbar"}{...}
{vieweralsosee "[G-2] graph twoway rcap" "help twoway_rcap"}{...}
{vieweralsosee "[G-2] graph twoway rcapsym" "help twoway_rcapsym"}{...}
{vieweralsosee "[G-2] graph twoway rconnected" "help twoway_rconnected"}{...}
{vieweralsosee "[G-2] graph twoway rline" "help twoway_rline"}{...}
{vieweralsosee "[G-2] graph twoway rscatter" "help twoway_rscatter"}{...}
{viewerjumpto "Syntax" "twoway_rspike##syntax"}{...}
{viewerjumpto "Menu" "twoway_rspike##menu"}{...}
{viewerjumpto "Description" "twoway_rspike##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_rspike##linkspdf"}{...}
{viewerjumpto "Options" "twoway_rspike##options"}{...}
{viewerjumpto "Remarks" "twoway_rspike##remarks"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[G-2] graph twoway rspike} {hline 2}}Range plot with spikes{p_end}
{p2col:}({mansection G-2 graphtwowayrspike:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 60 2}
{cmdab:tw:oway}
{cmd:rspike}
{it:y1var} {it:y2var} {it:xvar}
{ifin}
[{cmd:,}
{it:options}]

{synoptset 22}{...}
{p2col: {it:options}}Description{p_end}
{p2line}
{p2col: {cmdab:vert:ical}}vertical spikes; the default{p_end}
{p2col: {cmdab:hor:izontal}}horizontal spikes{p_end}

INCLUDE help gr_blspike2

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
A range plot has two {it:y} variables, such as high and low daily stock
price or upper and lower 95% confidence limits.

{pstd}
{cmd:twoway} {cmd:rspike} plots a range, using spikes to connect the high and
low values.

{pstd}
Also see {manhelp twoway_spike G-2:graph twoway spike} for another style of
spike chart.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowayrspikeQuickstart:Quick start}

        {mansection G-2 graphtwowayrspikeRemarksandexamples:Remarks and examples}

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

INCLUDE help gr_blspikef2

INCLUDE help gr_axlnkf

INCLUDE help gr_twoptf


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

        {help twoway_rspike##remarks1:Typical use}
        {help twoway_rspike##remarks2:Advanced use}
        {help twoway_rspike##remarks3:Advanced use 2}


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

	{cmd:. twoway rspike high low date in 1/57}
	  {it:({stata "gr_example sp500: twoway rspike high low date in 1/57":click to run})}
{* graph gtrspike1}{...}


{marker remarks2}{...}
{title:Advanced use}

{pstd}
{cmd:twoway} {cmd:rspike} can be usefully combined
with other {helpb twoway} plottypes:

	{cmd}. twoway rspike high low date, lcolor(gs11) ||
		 line close date || in 1/57{txt}
	  {it:({stata "gr_example sp500: twoway rspike high low date, lcolor(gs11) || line close date || in 1/57":click to run})}
{* graph gtrspike2}{...}

{pstd}
We specified {cmd:lcolor(gs11)} to tone down the spikes and give the
line plot more prominence.


{marker remarks3}{...}
{title:Advanced use 2}

{pstd}
A popular financial graph is

	{cmd}. sysuse sp500, clear

	. replace volume = volume/1000

	. twoway
		rspike hi low date ||
		line   close  date ||
		bar    volume date, barw(.25) yaxis(2) ||
	  in 1/57
	  , ysca(axis(1) r(900 1400))
	    ysca(axis(2) r(  9   45))
	    ylab(, axis(2) grid)
	    ytitle("                          Price -- High, Low, Close")
	    ytitle(" Volume (millions)", axis(2) bexpand just(left))
	    legend(off)
	    subtitle("S&P 500", margin(b+2.5))
	    note("Source:  Yahoo!Finance and Commodity Systems, Inc."){txt}
	  {it:({stata "gr_example2 tworspike":click to run})}
{* graph tworspike}{...}
