{smcl}
{* *! version 1.2.8  16apr2019}{...}
{vieweralsosee "[G-3] axis_scale_options" "mansection G-3 axis_scale_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] axis_options" "help axis_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] axis_label_options" "help axis_label_options"}{...}
{vieweralsosee "[G-3] axis_title_options" "help axis_title_options"}{...}
{vieweralsosee "[G-3] region_options" "help region_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway tsline" "help tsline"}{...}
{viewerjumpto "Syntax" "axis_scale_options##syntax"}{...}
{viewerjumpto "Description" "axis_scale_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "axis_scale_options##linkspdf"}{...}
{viewerjumpto "Options" "axis_scale_options##options"}{...}
{viewerjumpto "Suboptions" "axis_scale_options##suboptions"}{...}
{viewerjumpto "Remarks" "axis_scale_options##remarks"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[G-3]} {it:axis_scale_options} {hline 2}}Options for specifying axis scale, range, and look{p_end}
{p2col:}({mansection G-3 axis_scale_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
{it:axis_scale_options} are a subset of {it:axis_options};
see {manhelpi axis_options G-3}.

{synoptset 27}{...}
{p2col:{it:axis_scale_options}}Description{p_end}
{p2line}
{p2col:{cmdab:ysc:ale:(}{it:axis_suboptions}{cmd:)}}how {it:y} axis looks{p_end}
{p2col:{cmdab:xsc:ale:(}{it:axis_suboptions}{cmd:)}}how {it:x} axis looks{p_end}
{p2col:{cmdab:tsc:ale:(}{it:axis_suboptions}{cmd:)}}how {it:t} (time)
axis looks{p_end}
{p2col:{cmdab:zsc:ale:(}{it:axis_suboptions}{cmd:)}}how contour legend axis
looks {p_end}
{p2line}
{p 4 6 2}
The above options are
{it:merged-implicit}; see {help repeated options}.

{p2col:{it:axis_suboptions}}Description{p_end}
{p2line}
{p2col:{cmdab:ax:is:(}{it:#}{cmd:)}}which axis to modify; {cmd:1} {ul:<}
      {it:#} {ul:<} {cmd:9}{p_end}
{p2col:[{cmd:no}]{cmd:log}}use logarithmic scale{p_end}
{p2col:[{cmdab:no:}]{cmdab:rev:erse}}reverse scale to run from max to min{p_end}
{p2col:{cmdab:r:ange:(}{it:{help numlist}}{cmd:)}}expand range of axis{p_end}
{p2col:{cmdab:r:ange:(}{it:{help datelist}}{cmd:)}}expand range of {it:t} axis
       ({cmd:tscale()} only){p_end}

{p2col:{cmd:off} and {cmd:on}}suppress/force display of axis{p_end}
{p2col:{cmd:fill}}allocate space for axis even if {cmd:off}{p_end}
{p2col:{cmd:alt}}move axis from left to right or from top to bottom{p_end}

{p2col:{cmdab:fex:tend}}extend axis line through plot region and plot region's
       margin{p_end}
{p2col:{cmdab:ex:tend}}extend axis line through plot region{p_end}
{p2col:{cmdab:noex:tend}}do not extend axis line at all{p_end}
{p2col:{cmdab:noli:ne}}do not draw axis line{p_end}
{p2col:{cmdab:li:ne}}force drawing of axis line{p_end}

{p2col:{cmdab:titleg:ap:(}{it:{help size}}{cmd:)}}margin between axis
       title and tick labels{p_end}
{p2col:{cmdab:outerg:ap:(}{it:{help size}}{cmd:)}}margin outside axis
       title{p_end}

{p2col:{cmdab:lsty:le:(}{it:{help linestyle}}{cmd:)}}overall style of axis
       line{p_end}
{p2col:{cmdab:lc:olor:(}{it:{help colorstyle}}{cmd:)}}color and opacity of axis line{p_end}
{p2col:{cmdab:lw:idth:(}{it:{help linewidthstyle}}{cmd:)}}thickness of axis
       line{p_end}
{p2col:{cmdab:lp:attern:(}{it:{help linepatternstyle}}{cmd:)}}axis pattern
       (solid, dashed, etc.){p_end}
{p2line}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The {it:axis_scale_options} determine how axes are scaled (arithmetic, log,
reversed), the range of the axes, and the look of the lines that are the axes.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 axis_scale_optionsQuickstart:Quick start}

        {mansection G-3 axis_scale_optionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt yscale(axis_suboptions)}, {opt xscale(axis_suboptions)}, and
{opt tscale(axis_suboptions)}
    specify the look of the {it:y}, {it:x}, and {it:t} axes.  The {it:t} axis
    is an extension of the {it:x} axis.  Inside the parentheses, you specify
    {it:axis_suboptions}.

{phang}
{cmd:zscale(}{it:axis_suboptions{cmd:)}}; see
    {it:{help axis_scale_options##remarks6:Contour axes -- zscale()}}
    below.


{marker suboptions}{...}
{title:Suboptions}

{phang}
{cmd:axis(}{it:#}{cmd:)}
     specifies to which scale this axis belongs and is specified when
     dealing with multiple {it:y} or {it:x} axes; see 
     {manhelpi axis_choice_options G-3}.

{phang}
{cmd:log} and {cmd:nolog}
    specify whether the scale should be logarithmic or arithmetic.
    {cmd:nolog} is the usual default, so {cmd:log} is the option.
    See {it:{help axis_scale_options##remarks3:Obtaining log scales}} under
    {it:Remarks} below.

{phang}
{cmd:reverse} and {cmd:noreverse}
     specify whether the scale should run from the maximum to the minimum
     or from the minimum to the maximum.
     {cmd:noreverse} is the usual default, so {cmd:reverse} is the
     option.
     See {it:{help axis_scale_options##remarks4:Obtaining reversed scales}}
     under {it:Remarks} below.

{phang}
{cmdab:range(}{it:numlist}{cmd:)}
    specifies that the axis be expanded to include
    the numbers specified.  Missing values, if specified, are ignored.  See 
    {it:{help axis_scale_options##remarks2:Specifying the range of a scale}}
    under {it:Remarks} below.  

{phang}
{cmdab:range(}{it:datelist}{cmd:)} ({cmd:tscale()} only)
    specifies that the axis be expanded to include the specified dates;
    see {it:{help datelist}}.  Missing values, if specified, are ignored.
    See {manhelp tsline TS} for examples.

{phang}
{cmd:off} and {cmd:on}
    suppress or force the display of the axis.
    {cmd:on} is the default and {cmd:off} the option.
    See {it:{help axis_scale_options##remarks5:Suppressing the axes}} under
    {it:Remarks} below.

{phang}
{cmd:fill} goes with {cmd:off} and is seldom
    specified.  If you turned an axis off but still wanted the space to be
    allocated for the axis, you could specify {cmd:fill}.

{phang}
{cmd:alt} specifies that, if the axis is by default on the left, it be on
    the right; if it is by default on the bottom, it is to be on the top.
    The following would draw a scatterplot with the {it:y} axis on the
    right:

{phang3}
{cmd:. scatter yvar xvar, yscale(alt)}

{phang}
{cmd:fextend}, {cmd:extend}, {cmd:noextend}, {cmd:line}, and {cmd:noline}
    determine how much of the line representing the axis is to be drawn.  They
    are alternatives.

{pmore}
    {cmd:noline} specifies that the line not be drawn at all.  The axis
    is there, ticks and labels will appear, but the line that is the axis
    itself will not be drawn.

{pmore}
    {cmd:line} is the opposite of {cmd:noline}, for use if the axis line
    somehow got turned off.

{pmore}
    {cmd:noextend} specifies that the axis line not extend beyond the
    range of the axis.  Say that the axis extends from -1 to +20.
    With {cmd:noextend}, the axis line begins at -1 and ends at +20.

{pmore}
    {cmd:extend} specifies that the line be longer than that and extend
    all the way across the plot region.  For instance, -1 and +20 might be the
    extent of the axis, but the scale might extend from -5 to +25, with the
    range [-5,-1) and (20,25] being unlabeled on the axis.  With {cmd:extend},
    the axis line begins at -5 and ends at 25.

{pmore}
    {cmd:fextend} specifies that the line be longer than that and
    extend across the plot region and across the plot region's margins.  For a
    definition of the plot region's margins, see 
    {manhelpi region_options G-3}.  If the plot region has no margins (which
    would be rare), {cmd:fextend} means the same as {cmd:extend}.  If the
    plot region does have margins, {cmd:extend} would result in the {it:y} and
    {it:x} axes not meeting.  With {cmd:fextend}, they touch.

{pmore}
    {cmd:fextend} is the default with most schemes.

{phang}
{cmd:titlegap(}{it:size}{cmd:)} specifies the margin to be inserted
     between the axis title and the axis tick labels; see
     {manhelpi size G-4}.

{phang}
{cmd:outergap(}{it:size}{cmd:)} specifies the margin to be inserted
     outside the axis title; see {manhelpi size G-4}.

{phang}
{cmd:lstyle(}{it:linestyle}{cmd:)},
{cmd:lcolor(}{it:colorstyle}{cmd:)},
{cmd:lwidth(}{it:linewidthstyle}{cmd:)}, and
{cmd:lpattern(}{it:linepatternstyle}{cmd:)}
determine the overall look of the line that is the axis;
see {help lines}.


{marker remarks}{...}
{title:Remarks}

{pstd}
{it:axis_scale_options} are a subset of {it:axis_options};
see {manhelpi axis_options G-3} for an overview.
The other appearance options are

	{it:axis_label_options}{right:(see {manhelpi axis_label_options G-3})  }

	{it:axis_title_options}{right:(see {manhelpi axis_title_options G-3})  }

{pstd}
Remarks are presented under the following headings:

	{help axis_scale_options##remarks1:Use of the yscale() and xscale()}
	{help axis_scale_options##remarks2:Specifying the range of a scale}
	{help axis_scale_options##remarks3:Obtaining log scales}
	{help axis_scale_options##remarks4:Obtaining reversed scales}
	{help axis_scale_options##remarks5:Suppressing the axes}
	{help axis_scale_options##remarks6:Contour axes -- zscale()}


{marker remarks1}{...}
{title:Use of the yscale() and xscale()}

{* index yscale() tt option}{* index xscale() tt option}{...}
{pstd}
{cmd:yscale()} and {cmd:xscale()} specify the look of the {it:y}
and {it:x} axes.  Inside the parentheses, you specify {it:axis_suboptions},
for example:

{pmore}
{cmd:. twoway (scatter} ...{cmd:)} ...{cmd:,}
{cmd:yscale(range(0 10) titlegap(1))}

{pstd}
{cmd:yscale()} and {cmd:xscale()} may be abbreviated {cmd:ysc()}
and {cmd:xsc()}, suboption {cmd:range()} may be abbreviated
{cmd:r()}, and {cmd:titlegap()} may be abbreviated {cmd:titleg()}:

{pmore}
{cmd:. twoway (scatter} ...{cmd:)} ...{cmd:,}
{cmd:ysc(r(0 10) titleg(1))}

{pstd}
Multiple {cmd:yscale()} and {cmd:xscale()} options may be specified on the
same command, and their results will be combined.  Thus the
above command could also be specified

{pmore}
{cmd:. twoway (scatter} ...{cmd:)} ...{cmd:,}
{cmd:ysc(r(0 10)) ysc(titleg(1))}

{pstd}
Suboptions may also be specified more than once, either within a 
{cmd:yscale()} or {cmd:xscale()} option, or across multiple options, and
the rightmost suboption will take effect.  In the following command,
{cmd:titlegap()} will be 2 and {cmd:range()}, 0 and 10:

{pmore}
{cmd:. twoway (scatter} ...{cmd:)} ...{cmd:,}
{cmd:ysc(r(0 10)) ysc(titleg(1)) ysc(titleg(2))}


{marker remarks2}{...}
{title:Specifying the range of a scale}

{* index scale, range of}{* index axis range}{...}
{pstd}
To specify the range of a scale, specify the
{c -(}{cmd:y}|{cmd:x}{c )-}{cmd:scale(range(}{it:numlist}{cmd:))}
option.  This option specifies that the axis be expanded to include the
numbers specified.

{pstd}
Consider the graph

	{cmd:. scatter} {it:yvar} {it:xvar}

{pstd}
Assume that it resulted in a graph where the {it:y} axis varied over 1--100
and assume that, given the nature of the {it:y} variable, it would be more
natural if the range of the axis were expanded to go from 0 to 100.  You could
type

{phang2}
	{cmd:. scatter} {it:yvar xvar}{cmd:, ysc(r(0))}

{pstd}
Similarly, if the range without the {cmd:yscale(range())} option went from 1 to
99 and you wanted it to go from 0 to 100, you could type

{phang2}
	{cmd:. scatter} {it:yvar xvar}{cmd:, ysc(r(0 100))}

{pstd}
If the range without {cmd:yscale(range())} went from 0 to 99 and you wanted it
to go from 0 to 100, you could type

{phang2}
	{cmd:. scatter} {it:yvar xvar}{cmd:, ysc(r(100))}

{pstd}
Specifying missing for a value leaves the current minimum or maximum
unchanged; specifying a nonmissing value changes the range, but only if the
specified value is outside the value that would otherwise have been chosen.
{cmd:range()} never narrows the scale of an axis or causes data to be omitted
from the plot.  If you wanted to graph {cmd:yvar} versus {cmd:xvar} for the
subset of {cmd:xvar} values between 10 and 50, typing

{phang2}
	{cmd:. scatter} {it:yvar xvar}{cmd:, xsc(r(10 50))}

{pstd}
would not suffice.  You need to type

{phang2}
	{cmd:. scatter} {it:yvar xvar} {cmd:if} {it:xvar}{cmd:>=10 &} {it:xvar}{cmd:<=50}


{marker remarks3}{...}
{title:Obtaining log scales}

{* index log scales}{* index axis, log}{* index scales, log}{...}
{pstd}
To obtain log scales specify the
{c -(}{cmd:y}|{cmd:x}{c )-}{cmd:scale(log)}
option.
Ordinarily when you draw a graph, you obtain arithmetic scales:

	{cmd:. sysuse lifeexp, clear}

	{cmd:. scatter lexp gnppc}
	  {it:({stata "gr_example lifeexp: scatter lexp gnppc":click to run})}
{* graph axsca1}{...}

{pstd}
To obtain the same graph with a log {it:x} scale, we type

	{cmd:. scatter lexp gnppc, xscale(log)}
	  {it:({stata "gr_example lifeexp: scatter lexp gnppc, xscale(log)":click to run})}
{* graph axsca2}{...}

{pstd}
We obtain the same graph as if we typed

	{cmd:. generate log_gnppc = log(gnppc)}

	{cmd:. scatter lexp log_gnppc}

{pstd}
The difference concerns the labeling of the axis.  When we specify
{c -(}{cmd:y}|{cmd:x}{c )-}{cmd:scale(log)}, the axis is labeled
in natural units.  Here the overprinting of the 30,000 and 40,000
is unfortunate, but we could fix that by dividing {cmd:gnppc} by 1,000.


{marker remarks4}{...}
{title:Obtaining reversed scales}

{* index reversed scales}{* index axis, reversed}{* scales, reversed}{...}
{pstd}
To obtain reversed scales -- scales that run from high to
low -- specify the {c -(}{cmd:y}|{cmd:x}{c )-}{cmd:scale(reverse)}
option:

	{cmd:. sysuse auto, clear}

	{cmd:. scatter mpg weight, yscale(rev)}
	  {it:({stata "gr_example auto: scatter mpg weight, yscale(rev)":click to run})}
{* graph axsca3}{...}


{marker remarks5}{...}
{title:Suppressing the axes}

{* index axes, suppressing}{...}
{pstd}
There are two ways to suppress the axes.  The first is to turn them off
completely, which means that the axis line is suppressed, along
with all of its ticking, labeling, and titling.
The second is to simply suppress the axis line while leaving
the ticking, labeling, and titling in place.

{pstd}
The first is done by
{c -(}{cmd:y}|{cmd:x}{c )-}{cmd:scale(off)}
and the second by
{c -(}{cmd:y}|{cmd:x}{c )-}{cmd:scale(noline)}.
Also, you will probably need to specify the
{cmd:plotregion(style(none))} option; see {manhelpi region_options G-3}.

{pstd}
The axes and the border around the plot region are right on top of each
other.  Specifying {cmd:plotregion(style(none))} will do away with the
border and reveal the axes to us:

	{cmd:. sysuse auto, clear}

	{cmd:. scatter mpg weight, plotregion(style(none))}
	  {it:({stata "gr_example auto: scatter mpg weight, plotregion(style(none))":click to run})}
{* graph axsca4}{...}

{pstd}
To eliminate the axes, type

	{cmd:. scatter mpg weight, plotregion(style(none))}
	{cmd:                      yscale(off) xscale(off)}
	  {it:({stata "gr_example auto: scatter mpg weight, plotregion(style(none)) yscale(off) xscale(off)":click to run})}
{* graph axsca5}{...}

{pstd}
To eliminate the lines that are the axes while leaving in place the
labeling, ticking, and titling, type

	{cmd:. scatter mpg weight, plotregion(style(none))}
	{cmd:                      yscale(noline) xscale(noline)}
	  {it:({stata "gr_example auto: scatter mpg weight, plotregion(style(none)) yscale(noline) xscale(noline)":click to run})}
{* graph axsca6}{...}

{pstd}
Rather than using
{c -(}{cmd:y}|{cmd:x}{c )-}{cmd:scale(noline)},
you may specify
{c -(}{cmd:y}|{cmd:x}{c )-}{cmd:scale(lstyle(noline))}
or
{c -(}{cmd:y}|{cmd:x}{c )-}{cmd:scale(lstyle(none))}.
They all mean the same thing.


{marker remarks6}{...}
{title:Contour axes -- zscale()}

{pstd}
The {cmd:zscale()} option is unusual in that it applies not to axes on the
plot region, but to the axis that shows the scale of a 
{help clegend_option:contour legend}.  It has effect only when the graph
includes a {cmd:twoway contour} plot; 
see {helpb twoway_contour:[G-2] graph twoway contour}.  In
all other respects, it acts like {cmd:xscale()}, {cmd:yscale()}, and
{cmd:tscale()}.
{p_end}
