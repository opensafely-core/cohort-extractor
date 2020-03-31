{smcl}
{* *! version 1.1.11  19oct2017}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway rarea" "mansection G-2 graphtwowayrarea"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway area" "help twoway_area"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway rbar" "help twoway_rbar"}{...}
{vieweralsosee "[G-2] graph twoway rcap" "help twoway_rcap"}{...}
{vieweralsosee "[G-2] graph twoway rcapsym" "help twoway_rcapsym"}{...}
{vieweralsosee "[G-2] graph twoway rconnected" "help twoway_rconnected"}{...}
{vieweralsosee "[G-2] graph twoway rline" "help twoway_rline"}{...}
{vieweralsosee "[G-2] graph twoway rscatter" "help twoway_rscatter"}{...}
{vieweralsosee "[G-2] graph twoway rspike" "help twoway_rspike"}{...}
{viewerjumpto "Syntax" "twoway_rarea##syntax"}{...}
{viewerjumpto "Menu" "twoway_rarea##menu"}{...}
{viewerjumpto "Description" "twoway_rarea##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_rarea##linkspdf"}{...}
{viewerjumpto "Options" "twoway_rarea##options"}{...}
{viewerjumpto "Remarks" "twoway_rarea##remarks"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[G-2] graph twoway rarea} {hline 2}}Range plot with area shading{p_end}
{p2col:}({mansection G-2 graphtwowayrarea:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 60 2}
{cmdab:tw:oway}
{cmd:rarea}
{it:y1var} {it:y2var} {it:xvar}
{ifin}
[{cmd:,}
{it:options}]

{synoptset 20}{...}
{p2col:{it:options}}Description{p_end}
{p2line}
{p2col:{cmdab:vert:ical}}vertical area plot; the default{p_end}
{p2col:{cmdab:hor:izontal}}horizontal area plot{p_end}
{p2col:{cmdab:cmis:sing:(}{cmd:y}|{cmd:n}{cmd:)}}missing values do not force
       gaps in area; default is {cmd:cmissing(y)}{p_end}
{p2col:{cmd:sort}}sort by {it:xvar}; recommended{p_end}

INCLUDE help gr_areaopt

INCLUDE help gr_axlnk

INCLUDE help gr_twopt
{p2line}
{p2colreset}{...}
{p 4 6 2}
All explicit options are {it:unique}; see {help repeated options}.


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
{cmd:twoway} {cmd:rarea} plots range as a shaded area.

{pstd}
Also see {manhelp twoway_area G-2:graph twoway area} for area plots filled to
the axis.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowayrareaQuickstart:Quick start}

        {mansection G-2 graphtwowayrareaRemarksandexamples:Remarks and examples}

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
    {it:y2var} are plotted in the {it:x} direction and {it:xvar} is treated
    as the {it:y} value.

{phang}
{cmd:cmissing(}{cmd:y}|{cmd:n}{cmd:)}
    specifies whether missing values are to be ignored when drawing the area
    or if they are to create breaks in the area.  The default is
    {cmd:cmissing(y)}, meaning that they are ignored.  Consider the following
    data:

	    {txt}
		 {c TLC}{hline 6}{c -}{hline 3}{c TRC}
		 {c |} {res}  y    x {txt}{c |}
		 {c LT}{hline 6}{c -}{hline 3}{c RT}
	      1. {c |} {res}  1    1 {txt}{c |}
	      2. {c |} {res}  3    2 {txt}{c |}
	      3. {c |} {res}  5    3 {txt}{c |}
	      4. {c |} {res}  .    . {txt}{c |}
	      5. {c |} {res}  6    5 {txt}{c |}
		 {c LT}{hline 6}{c -}{hline 3}{c RT}
	      6. {c |} {res} 11    8 {txt}{c |}
		 {c BLC}{hline 6}{c -}{hline 3}{c BRC}{txt}

{pmore}
Say that you graph these data by using {cmd:twoway} {cmd:rarea} {cmd:y}
{cmd:x}.  Do you want a break in the area between 3 and 5?  If so, you type

	    {cmd:. twoway rarea y x, cmissing(n)}

{pmore}
and two areas will be drawn, one for the observations before the missing
values at observation 4 and one for the observations after the missing values.

{pmore}
If you omit the option (or type {cmd:cmissing(y)}), the data are treated
as if they contained

	    {txt}
		 {c TLC}{hline 6}{c -}{hline 3}{c TRC}
		 {c |} {res}  y    x {txt}{c |}
		 {c LT}{hline 6}{c -}{hline 3}{c RT}
	      1. {c |} {res}  1    1 {txt}{c |}
	      2. {c |} {res}  3    2 {txt}{c |}
	      3. {c |} {res}  5    3 {txt}{c |}
	      4. {c |} {res}  6    5 {txt}{c |}
	      5. {c |} {res} 11    8 {txt}{c |}
		 {c BLC}{hline 6}{c -}{hline 3}{c BRC}{txt}

{pmore}
meaning that one contiguous area will be drawn over the range (1,8).


{phang}
{cmd:sort}
    specifies that the data be sorted by {it:xvar} before plotting.

{phang}
{it:area_options}
    set the look of the shaded areas.  The most important of these options is
    {cmd:color(}{it:colorstyle}{cmd:)}, which specifies the color and
    opacity of both the area and its outline; see {manhelpi colorstyle G-4}
    for a list of color choices.  See {manhelpi area_options G-3} for
    information on the other {it:area_options}.

INCLUDE help gr_axlnkf

INCLUDE help gr_twoptf


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

        {help twoway_rarea##remarks1:Typical use}
        {help twoway_rarea##remarks2:Advanced use}
        {help twoway_rarea##remarks3:Cautions}


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

	{cmd:. twoway rarea high low date in 1/57}
	  {it:({stata "gr_example sp500: twoway rarea high low date in 1/57":click to run})}
{* graph gtrarea1}{...}


{marker remarks2}{...}
{title:Advanced use}

{pstd}
{cmd:rarea}
works particularly well when the upper and lower limits are smooth functions
and when the area is merely shaded rather than given an eye-catching color:

	{cmd}. sysuse auto, clear

	. quietly regress mpg weight

	. predict hat

	. predict s, stdf

	. generate low = hat - 1.96*s

	. generate hi  = hat + 1.96*s

	. twoway rarea low hi weight, sort color(gs14) ||
		 scatter  mpg weight{txt}
	  {it:({stata "gr_example2 tworarea":click to run})}
{* graph tworarea}{...}

{pstd}
Notice the use of option {cmd:color()} to change the color
of the shaded area.  Also, we graphed the shaded area first
and then the scatter.  Typing

	{cmd:. twoway scatter} ... {cmd:|| rarea} ...

{pstd}
would not have produced the desired result because the shaded area would
have covered up the scatterplot.

{pstd}
Also see {manhelp twoway_lfitci G-2:graph twoway lfitci}.


{marker remarks3}{...}
{title:Cautions}

{pstd}
Be sure that the data are in the order of {it:xvar}, or specify {cmd:rarea}'s
{cmd:sort} option.  If you do neither, you will get something that looks like
modern art; see {it:{help twoway area##remarks3:Cautions}} in
{manhelp twoway_area G-2:graph twoway area} for an example.
{p_end}
