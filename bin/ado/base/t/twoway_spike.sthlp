{smcl}
{* *! version 1.1.8  19oct2017}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway spike" "mansection G-2 graphtwowayspike"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway scatter" "help scatter"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway bar" "help twoway_bar"}{...}
{vieweralsosee "[G-2] graph twoway dot" "help twoway_dot"}{...}
{vieweralsosee "[G-2] graph twoway dropline" "help twoway_dropline"}{...}
{viewerjumpto "Syntax" "twoway_spike##syntax"}{...}
{viewerjumpto "Menu" "twoway_spike##menu"}{...}
{viewerjumpto "Description" "twoway_spike##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_spike##linkspdf"}{...}
{viewerjumpto "Options" "twoway_spike##options"}{...}
{viewerjumpto "Remarks" "twoway_spike##remarks"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[G-2] graph twoway spike} {hline 2}}Twoway spike plots{p_end}
{p2col:}({mansection G-2 graphtwowayspike:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 54 2}
{cmdab:tw:oway}
{cmd:spike}
{it:yvar} {it:xvar}
{ifin}
[{cmd:,}
{it:options}]

{synoptset 22}{...}
{p2col:{it:options}}Description{p_end}
{p2line}
{p2col:{cmdab:vert:ical}}vertical spike plot; the default{p_end}
{p2col:{cmdab:hor:izontal}}horizontal spike plot{p_end}
{p2col:{cmd:base(}{it:#}{cmd:)}}value to drop to; default is 0{p_end}

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
{cmd:twoway} {cmd:spike} displays numerical ({it:y},{it:x}) data as spikes.
{cmd:twoway} {cmd:spike} is useful for drawing spike plots of time-series
data or other equally spaced data and is useful as a programming tool.
For sparse data, also see {manhelp graph_bar G-2:graph bar}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowayspikeQuickstart:Quick start}

        {mansection G-2 graphtwowayspikeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:vertical} and {cmd:horizontal}
    specify either a vertical or a horizontal spike plot.
    {cmd:vertical} is the default.  If {cmd:horizontal} is specified, the
    values recorded in {it:yvar} are treated as {it:x} values, and the values
    recorded in {it:xvar} are treated as {it:y} values.
    That is, to make horizontal plots, do not switch the order of the
    two variables specified.

{pmore}
    In the {cmd:vertical} case, spikes are drawn at the specified {it:xvar}
    values and extend up or down from 0 according to the corresponding
    {it:yvar} values.  If 0 is not in the range of the {it:y} axis,
    spikes extend up or down to the {it:x} axis.

{pmore}
    In the {cmd:horizontal} case, spikes are drawn at the specified {it:xvar}
    values and extend left or right from 0 according to the corresponding
    {it:yvar} values.  If 0 is not in the range of the {it:x} axis,
    spikes extend left or right to the {it:y} axis.

{phang}
{cmd:base(}{it:#}{cmd:)}
    specifies the value from which the spike should extend.
    The default is {cmd:base(0)}; in the above description of options
    {cmd:vertical} and {cmd:horizontal}, this default was assumed.

INCLUDE help gr_blspikef2

INCLUDE help gr_axlnkf

INCLUDE help gr_twoptf



{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

        {help twoway_spike##remarks1:Typical use}
        {help twoway_spike##remarks2:Advanced use}
        {help twoway_spike##remarks3:Cautions}


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
The example in {manhelp twoway_bar G-2:graph twoway bar} graphed the first 57
observations of these data by using bars.  Here is the same graph presented as
spikes:

	{cmd:. twoway spike change date in 1/57}
	  {it:({stata "gr_example sp500: twoway spike change date in 1/57":click to run})}
{* graph gtspike1}{...}

{pstd}
Spikes are especially useful when there are a lot of data.   The graph below
shows the data for the entire year:

	{cmd:. twoway spike change date}
	  {it:({stata "gr_example sp500: twoway spike change date":click to run})}
{* graph gtspike2}{...}


{marker remarks2}{...}
{title:Advanced use}

{pstd}
The useful thing about {cmd:twoway} {cmd:spike} is that it can be combined
with other {helpb twoway} plottypes:

	{cmd:. twoway line close date || spike change date}
	  {it:({stata "gr_example sp500: twoway line close date || spike change date":click to run})}
{* graph gtspike3}{...}

{pstd}
We can improve this graph by typing

	{cmd}. twoway
		line close date, yaxis(1)
	||
		spike change date, yaxis(2)
	||,
		ysca(axis(1) r(700  1400)) ylab(1000(100)1400, axis(1))
		ysca(axis(2) r(-50 300)) ylab(-50 0 50, axis(2))
			ytick(-50(25)50, axis(2) grid)
		legend(off)
		xtitle("Date")
		title("S&P 500")
		subtitle("January - December 2001")
		note("Source:  Yahoo!Finance and Commodity Systems, Inc.")
		yline(950, axis(1) lstyle(foreground)){txt}
	  {it:({stata "gr_example2 twospike":click to run})}
{* graph twospike}{...}

{pstd}
Concerning our use of

		{cmd:yline(950, axis(1) lstyle(foreground))}

{pstd}
see {it:{help twoway bar##remarks2:Advanced use: Overlaying}} in 
{manhelp twoway_bar G-2:graph twoway bar}.


{marker remarks3}{...}
{title:Cautions}

{pstd}
See {it:{help twoway bar##remarks4:Cautions}} in
{manhelp twoway_bar G-2:graph twoway bar}, which applies
equally to {cmd:twoway} {cmd:spike}.
{p_end}
