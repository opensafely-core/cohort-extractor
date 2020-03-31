{smcl}
{* *! version 1.2.10  19oct2017}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway area" "mansection G-2 graphtwowayarea"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway scatter" "help scatter"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway dot" "help twoway_dot"}{...}
{vieweralsosee "[G-2] graph twoway dropline" "help twoway_dropline"}{...}
{vieweralsosee "[G-2] graph twoway histogram" "help twoway_histogram"}{...}
{vieweralsosee "[G-2] graph twoway spike" "help twoway_spike"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph bar" "help graph_bar"}{...}
{viewerjumpto "Syntax" "twoway_area##syntax"}{...}
{viewerjumpto "Menu" "twoway_area##menu"}{...}
{viewerjumpto "Description" "twoway_area##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_area##linkspdf"}{...}
{viewerjumpto "Options" "twoway_area##options"}{...}
{viewerjumpto "Remarks" "twoway_area##remarks"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[G-2] graph twoway area} {hline 2}}Twoway line plot with area shading{p_end}
{p2col:}({mansection G-2 graphtwowayarea:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 53 2}
{cmdab:tw:oway}
{cmd:area}
{it:yvar} {it:xvar}
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
{p2col:{cmd:base(}{it:#}{cmd:)}}value to drop to; default is 0{p_end}
{p2col:{cmdab:nodropb:ase}}programmer's option{p_end}
{p2col:{cmd:sort}}sort by {it:xvar}; recommended{p_end}

INCLUDE help gr_areaopt

INCLUDE help gr_axlnk

INCLUDE help gr_twopt
{p2line}
{p2colreset}{...}
{p 4 6 2}
Option {cmd:base()} is {it:rightmost}; {cmd:vertical}, {cmd:horizontal},
{cmd:nodropbase}, and {cmd:sort} are {it:unique}; see {help repeated options}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Twoway graph (scatter, line, etc.)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:twoway} {cmd:area} displays ({it:y},{it:x}) connected by
straight lines and shaded underneath.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowayareaQuickstart:Quick start}

        {mansection G-2 graphtwowayareaRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:vertical} and {cmd:horizontal}
    specify either a vertical or a horizontal area plot.
    {cmd:vertical} is the default.  If {cmd:horizontal} is specified, the
    values recorded in {it:yvar} are treated as {it:x} values, and the values
    recorded in {it:xvar} are treated as {it:y} values.
    That is, to make horizontal plots, do not switch the order of the
    two variables specified.

{pmore}
    In the {cmd:vertical} case, shading at each {it:xvar}
    value extends up or down from 0 according to the corresponding
    {it:yvar} values.  If 0 is not in the range of the {it:y} axis,
    shading extends up or down to the {it:x} axis.

{pmore}
    In the {cmd:horizontal} case, shading at each {it:xvar}
    value extends left or right from 0 according to the corresponding
    {it:yvar} values.  If 0 is not in the range of the {it:x} axis,
    shading extends left or right to the {it:y} axis.

{phang}
{cmd:cmissing(}{cmd:y}|{cmd:n}{cmd:)}
    specifies whether missing values are to be ignored when drawing the area
    or if they are to create breaks in the area.  The default is
    {cmd:cmissing(y)}, meaning that they are ignored.  Consider the following
    data:

	    {txt}
		 {c TLC}{hline 9}{c -}{hline 3}{c TRC}
		 {c |} {res}  y1  y2  x {txt}{c |}
		 {c LT}{hline 9}{c -}{hline 3}{c RT}
	      1. {c |} {res}  1   2   1 {txt}{c |}
	      2. {c |} {res}  3   5   2 {txt}{c |}
	      3. {c |} {res}  5   4   3 {txt}{c |}
	      4. {c |} {res}  .   .   . {txt}{c |}
	      5. {c |} {res}  6   7   5 {txt}{c |}
		 {c LT}{hline 9}{c -}{hline 3}{c RT}
	      6. {c |} {res} 11  12   8 {txt}{c |}
		 {c BLC}{hline 9}{c -}{hline 3}{c BRC}{txt}

{pmore}
Say that you graph these data by using {cmd:twoway} {cmd:area} {cmd:y1} 
{cmd:y2} {cmd:x}.
Do you want a break in the area between 3 and 5?  If so, you type

	    {cmd:. twoway area y1 y2 x, cmissing(n)}

{pmore}
and two areas will be drawn, one for the observations before the missing
values at observation 4 and one for the observations after the missing values.

{pmore}
If you omit the option (or type {cmd:cmissing(y)}), the data are treated
as if they contained

	    {txt}
		 {c TLC}{hline 9}{c -}{hline 3}{c TRC}
		 {c |} {res}  y1  y2  x {txt}{c |}
		 {c LT}{hline 9}{c -}{hline 3}{c RT}
	      1. {c |} {res}  1   2   1 {txt}{c |}
	      2. {c |} {res}  3   5   2 {txt}{c |}
	      3. {c |} {res}  5   4   3 {txt}{c |}
	      4. {c |} {res}  6   7   5 {txt}{c |}
	      5. {c |} {res} 11  12   8 {txt}{c |}
		 {c BLC}{hline 9}{c -}{hline 3}{c BRC}{txt}

{pmore}
meaning that one contiguous area will be drawn over the range (1,8).

{phang}
{cmd:base(}{it:#}{cmd:)}
    specifies the value from which the shading should extend.
    The default is {cmd:base(0)}, and in the above description of options
    {cmd:vertical} and {cmd:horizontal}, this default was assumed.

{phang}
{cmd:nodropbase} is a programmer's option and is an alternative to
    {cmd:base()}.  It specifies that rather than the enclosed area dropping to
    {cmd:base(}{it:#}{cmd:)} -- or {cmd:base(0)} -- it drops to the
    line formed by ({it:y_1},{it:x_1}) and ({it:y_N},{it:x_N}), where
    ({it:y_1},{it:x_1}) are the {it:y} and {it:x} values in the first
    observation being plotted and ({it:y_N},{it:x_N}) are the values in the
    last observation being plotted.

{phang}
{cmd:sort}
    specifies that the data be sorted by {it:xvar} before plotting.

{phang}
{it:area_options}
    set the look of the shaded areas.  The most important of these options is
    {cmd:color(}{it:colorstyle}{cmd:)}, which specifies the color and opacity
    of both the area and its outline; see {manhelpi colorstyle G-4} for a list
    of color choices.  See {manhelpi area_options G-3} for information on the
    other {it:area_options}.

INCLUDE help gr_axlnkf

INCLUDE help gr_twoptf


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help twoway_area##remarks1:Typical use}
	{help twoway_area##remarks2:Advanced use}
	{help twoway_area##remarks3:Cautions}


{marker remarks1}{...}
{title:Typical use}

{pstd}
We have quarterly data recording the U.S. GNP in constant 1996 dollars:

	{cmd:. sysuse gnp96}

	{cmd:. list in 1/5}
	{txt}
	     {c TLC}{hline 8}{c -}{hline 8}{c TRC}
	     {c |} {res}  date    gnp96 {txt}{c |}
	     {c LT}{hline 8}{c -}{hline 8}{c RT}
	  1. {c |} {res}1967q1   3631.6 {txt}{c |}
	  2. {c |} {res}1967q2   3644.5 {txt}{c |}
	  3. {c |} {res}1967q3     3672 {txt}{c |}
	  4. {c |} {res}1967q4   3703.1 {txt}{c |}
	  5. {c |} {res}1968q1   3757.5 {txt}{c |}
	     {c BLC}{hline 8}{c -}{hline 8}{c BRC}{txt}

{pstd}
In our opinion, the area under a curve should be shaded only if the
area is meaningful:

	{cmd:. sysuse gnp96, clear}

	{cmd:. twoway area d.gnp96 date}
	  {it:({stata "gr_example gnp96: twoway area d.gnp96 date":click to run})}
{* graph gtarea1}{...}


{marker remarks2}{...}
{title:Advanced use}

{pstd}
Here is the same graph, but greatly improved with some advanced options:

	{cmd}. twoway area d.gnp96 date, xlabel(36(8)164, angle(90))
		ylabel(-100(50)200, angle(0))
		ytitle("Billions of 1996 Dollars")
		xtitle("")
		subtitle("Change in U.S. GNP", position(11))
		note("Source: U.S. Department of Commerce,
		      Bureau of Economic Analysis"){txt}
	  {it:({stata "gr_example2 twoarea":click to run})}
{* graph twoarea}{...}


{marker remarks3}{...}
{title:Cautions}

{pstd}
Be sure that the data are in the order of {it:xvar}, or specify {cmd:area}'s
{cmd:sort} option.  If you do neither, you will get something that looks
like modern art:

	{cmd:. sysuse gnp96, clear}

	{cmd:. generate d = d.gnp96}

	{cmd:. generate u = runiform()}

	{cmd:. sort u}                     (put in random order)

	{cmd:. twoway area d date}
	  {it:({stata "gr_example2 twoarea2":click to run})}
{* graph twoarea2}{...}
