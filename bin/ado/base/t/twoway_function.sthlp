{smcl}
{* *! version 1.1.13  16apr2019}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway function" "mansection G-2 graphtwowayfunction"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway line" "help line"}{...}
{viewerjumpto "Syntax" "twoway_function##syntax"}{...}
{viewerjumpto "Menu" "twoway_function##menu"}{...}
{viewerjumpto "Description" "twoway_function##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_function##linkspdf"}{...}
{viewerjumpto "Options" "twoway_function##options"}{...}
{viewerjumpto "Remarks" "twoway_function##remarks"}{...}
{p2colset 1 32 34 2}{...}
{p2col:{bf:[G-2] graph twoway function} {hline 2}}Twoway line plot of function{p_end}
{p2col:}({mansection G-2 graphtwowayfunction:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 35 2}
{cmdab:tw:oway}
{cmd:function}
[[{cmd:y}]=]
{it:f}({cmd:x})
{ifin}
[{cmd:,}
{it:options}]

{synoptset 20}{...}
{p2col:{it:options}}Description{p_end}
{p2line}
{p2col:{cmdab:ra:nge:(}{it:#} {it:#}{cmd:)}}plot over {cmd:x} = {it:#} to
       {it:#}{p_end}
{p2col:{opth ra:nge(varname)}}plot over {cmd:x} = min to max of
       {it:varname}{p_end}
{p2col:{cmd:n(}{it:#}{cmd:)}}evaluate at {it:#} points; default is 300{p_end}

{p2col:{cmdab:dropl:ines:(}{it:{help numlist}}{cmd:)}}draw lines to axis at
        specified {cmd:x} values{p_end}
{p2col:{cmd:base(}{it:#}{cmd:)}}base value for {cmd:dropline()}; default is
        0{p_end}

{p2col:{cmdab:hor:izontal}}draw plot horizontally{p_end}

{p2col:{cmdab:yvarf:ormat:(}{help format:{bf:%}{it:fmt}}{cmd:)}}display format
       for {cmd:y}{p_end}
{p2col:{cmdab:xvarf:ormat:(}{help format:{bf:%}{it:fmt}}{cmd:)}}display format
       for {cmd:x}{p_end}

{p2col:{it:{help cline_options}}}change look of plotted line{p_end}

INCLUDE help gr_axlnk

INCLUDE help gr_twopt
{p2line}
{p2colreset}{...}
{p 4 6 2}
All explicit options are {it:rightmost}, except {cmd:horizontal}, which is
{it:unique}; see {help repeated options}.{p_end}
{p 4 6 2}
{cmd:if} {it:exp} and {cmd:in} {it:range} play no role unless option
{cmd:range(}{it:varname}{cmd:)} is specified.{p_end}
{p 4 6 2}
In the above syntax diagram,
{it:f}({cmd:x}) stands for an {it:exp}ression in terms of {cmd:x}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Twoway graph (scatter, line, etc.)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:twoway function} plots {cmd:y} = {it:f}({cmd:x}), where {it:f}({cmd:x})
is some function of {cmd:x}.
That is, you type

	{cmd:. twoway function y=sqrt(x)}

{pstd}
It makes no difference whether {cmd:y} and {cmd:x} are variables in your data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowayfunctionQuickstart:Quick start}

        {mansection G-2 graphtwowayfunctionRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:range(}{it:#} {it:#}{cmd:)}
and
{opth range(varname)}
    specify the range of values for {cmd:x}.  In the first syntax,
    {cmd:range()} is a pair of numbers identifying the minimum and maximum.
    In the second syntax, {cmd:range()} is a variable name, and the range used
    will be obtained from the minimum and maximum values of the variable.
    If {cmd:range()} is not specified, {cmd:range(0 1)} is assumed.

{phang}
{cmd:n(}{it:#}{cmd:)}
    specifies the number of points at which {it:f}({cmd:x}) is to be
    evaluated.  The default is {cmd:n(300)}.

{phang}
{cmd:droplines(}{it:{help numlist}}{cmd:)}
    adds dropped lines from the function down to, or up to, the axis (or
    {cmd:y}={cmd:base()} if {cmd:base()} is specified) at each {cmd:x} value
    specified in {it:numlist}.

{phang}
{cmd:base(}{it:#}{cmd:)}
    specifies the base for the {cmd:droplines()}.  The default is
    {cmd:base(0)}.  This option does not affect the range of the axes, so you
    may also want to specify the {it:axis_scale_option}
    {cmd:yscale(range(}{it:#}{cmd:))} as well; see 
    {manhelpi axis_scale_options G-3}.

{phang}
{cmd:horizontal}
    specifies that the roles of {cmd:y} and {cmd:x} be interchanged and that the
    graph be plotted horizontally rather than vertically (that the plotted
    function be reflected along the identity line).

{phang}
{cmd:yvarformat(%}{it:fmt}{cmd:)} and
{cmd:xvarformat(%}{it:fmt}{cmd:)}
    specify the display format to be used for {cmd:y} and {cmd:x}.  These
    formats are used when labeling the axes; see 
    {manhelpi axis_label_options G-3}.

{phang}
{it:cline_options}
     specify how the function line is rendered;
     see {manhelpi cline_options G-3}.

INCLUDE help gr_axlnkf

INCLUDE help gr_twoptf


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help twoway function##remarks1:Typical use}
	{help twoway function##remarks2:Advanced use 1}
	{help twoway function##remarks3:Advanced use 2}


{marker remarks1}{...}
{title:Typical use}

{* index functions, graphing}{...}
{pstd}
You wish to plot the function {cmd:y}=exp(-{cmd:x}/6)sin({cmd:x}) over the
range 0 to 4pi:

	{cmd:. twoway function y=exp(-x/6)*sin(x), range(0 12.57)}
	  {it:({stata "twoway function y=exp(-x/6)*sin(x), range(0 12.57)":click to run})}
{* graph gtfunc1}{...}

{pstd}
A better rendition of the graph above is

	{cmd}. twoway function y=exp(-x/6)*sin(x), range(0 12.57)
		yline(0, lstyle(foreground))
		xlabel( 0
                        3.14 "{c -(}&pi{c )-}"
                        6.28 "2{c -(}&pi{c )-}"
                        9.42 "3{c -(}&pi{c )-}"
                       12.57 "4{c -(}&pi{c )-}")
		plotregion(style(none))
		xsca(noline){txt}
	  {it:({stata "gr_example2 twofunc":click to run})}
{* graph twofunc}{...}

{pstd}
{cmd:yline(0, lstyle(foreground))}
added a line at {cmd:y}=0; {cmd:lstyle(foreground)} gave the line the same style
as used for the axes.  See {manhelpi added_line_options G-3}.

{pstd}
{cmd:xlabel(0 3.14 "{c -(}&pi{c )-}" 6.28 "2{c -(}&pi{c )-}" 9.42 "3{c -(}&pi{c )-}" 12.57 "4{c -(}&pi{c )-}")}
labeled the {it:x} axis with the numeric values given and substituted text
for the numeric values; see 
{manhelpi axis_label_options G-3}.

{pstd}
{cmd:plotregion(style(none))}
suppressed the border around the plot region; see {manhelpi region_options G-3}.

{pstd}
{cmd:xsca(noline)}
suppressed the drawing of the {it:x}-axis line;
see {manhelpi axis_scale_options G-3}.


{marker remarks2}{...}
{title:Advanced use 1}

{pstd}
The following graph appears in many introductory textbooks:

	{cmd}. twoway
	      function y=normalden(x), range(-4 -1.96) color(gs12) recast(area)
	  ||  function y=normalden(x), range(1.96 4)   color(gs12) recast(area)
	  ||  function y=normalden(x), range(-4 4) lstyle(foreground)
	  ||,
	      plotregion(style(none))
	      ysca(off) xsca(noline)
	      legend(off)
	      xlabel(-4 "-4 sd" -3 "-3 sd" -2 "-2 sd" -1 "-1 sd" 0 "mean"
		      1  "1 sd"  2  "2 sd"  3  "3 sd"  4  "4 sd"
		      , grid gmin gmax)
	      xtitle(""){txt}
	  {it:({stata "gr_example2 twofunc2":click to run})}
{* graph twofunc2}{...}

{pstd}
We drew the graph in three parts:  the shaded area on the left, the
shaded area on the right, and then the overall function.  To obtain
the
shaded areas, we used the {it:advanced_option} {cmd:recast(area)} so that,
rather than the function being plotted by {cmd:graph} {cmd:twoway} {cmd:line},
it was plotted by {cmd:graph} {cmd:twoway} {cmd:area}; see 
{manhelpi advanced_options G-3} and
{manhelp twoway_area G-2:graph twoway area}.
Concerning the overall function, we drew it last so that its darker
foreground-colored line would not get covered up by the shaded areas.


{marker remarks3}{...}
{title:Advanced use 2}

{* index added lines, y=x}{...}
{pstd}
{cmd:function} plots may be overlaid with other {cmd:twoway} plots.
For instance, {cmd:function} is one way to add {it:y}={it:x} lines to a plot:

	{cmd:. sysuse sp500, clear}

	{cmd:. scatter open close, msize(*.25) mcolor(*.6) ||}
	{cmd:  function y=x, range(close) yvarlab("y=x") clwidth(*1.5)}
	  {it:({stata `"gr_example sp500: scatter open close, msize(*.25) mcolor(*.6) || function y=x, range(close) yvarlab("y=x")"':click to run})}
{* graph gtfunc2}{...}

{pstd}
In the above, we specified the {it:advanced_option} {cmd:yvarlab("y=x")}
so that the variable label of {it:y} would be treated as "y=x" in the
construction of the legend; see {manhelpi advanced_options G-3}.
We specified {cmd:msize(*.25)} to make the marker symbols smaller, and
we specified {cmd:mcolor(*.6)} to make them dimmer; see 
{manhelpi size G-4}
and 
{manhelpi colorstyle G-4}.
{p_end}
