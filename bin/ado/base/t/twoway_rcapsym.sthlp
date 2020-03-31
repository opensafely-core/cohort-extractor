{smcl}
{* *! version 1.1.9  19oct2017}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway rcapsym" "mansection G-2 graphtwowayrcapsym"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway rarea" "help twoway_rarea"}{...}
{vieweralsosee "[G-2] graph twoway rbar" "help twoway_rbar"}{...}
{vieweralsosee "[G-2] graph twoway rcap" "help twoway_rcap"}{...}
{vieweralsosee "[G-2] graph twoway rconnected" "help twoway_rconnected"}{...}
{vieweralsosee "[G-2] graph twoway rline" "help twoway_rline"}{...}
{vieweralsosee "[G-2] graph twoway rscatter" "help twoway_rscatter"}{...}
{vieweralsosee "[G-2] graph twoway rspike" "help twoway_rspike"}{...}
{viewerjumpto "Syntax" "twoway_rcapsym##syntax"}{...}
{viewerjumpto "Menu" "twoway_rcapsym##menu"}{...}
{viewerjumpto "Description" "twoway_rcapsym##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_rcapsym##linkspdf"}{...}
{viewerjumpto "Options" "twoway_rcapsym##options"}{...}
{viewerjumpto "Remarks" "twoway_rcapsym##remarks"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[G-2] graph twoway rcapsym} {hline 2}}Range plot with spikes capped with marker symbols{p_end}
{p2col:}({mansection G-2 graphtwowayrcapsym:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 60 2}
{cmdab:tw:oway}
{cmd:rcapsym}
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
INCLUDE help gr_markopt

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
{cmd:twoway} {cmd:rcapsym} plots a range, using spikes capped with marker
symbols.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowayrcapsymQuickstart:Quick start}

        {mansection G-2 graphtwowayrcapsymRemarksandexamples:Remarks and examples}

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

{phang}
{it:marker_options}
    specify how the markers look, including
    shape, size, color, and outline;
    see {manhelpi marker_options G-3}.  The same marker is used on both ends of
    the spikes.

{phang}
{it:marker_label_options}
    specify if and how the markers are to be labeled.  Because
    the same marker label would be used to label both ends of the spike,
    these options are of limited use here.
    See {manhelpi marker_label_options G-3}.

INCLUDE help gr_axlnkf

INCLUDE help gr_twoptf


{marker remarks}{...}
{title:Remarks}

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

	{cmd:. twoway rcapsym high low date in 1/37}
	  {it:({stata "gr_example sp500: twoway rcapsym high low date in 1/37":click to run})}
{* graph gtrcapsym1}{...}
