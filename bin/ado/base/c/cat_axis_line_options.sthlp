{smcl}
{* *! version 1.1.9  16apr2019}{...}
{vieweralsosee "[G-3] cat_axis_line_options" "mansection G-3 cat_axis_line_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph bar" "help graph_bar"}{...}
{vieweralsosee "[G-2] graph box" "help graph_box"}{...}
{vieweralsosee "[G-2] graph dot" "help graph_dot"}{...}
{viewerjumpto "Syntax" "cat_axis_line_options##syntax"}{...}
{viewerjumpto "Description" "cat_axis_line_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "cat_axis_line_options##linkspdf"}{...}
{viewerjumpto "Options" "cat_axis_line_options##options"}{...}
{viewerjumpto "Remarks" "cat_axis_line_options##remarks"}{...}
{p2colset 1 32 34 2}{...}
{p2col:{bf:[G-3]} {it:cat_axis_line_options} {hline 2}}Options for specifying look of categorical axis line{p_end}
{p2col:}({mansection G-3 cat_axis_line_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 30}{...}
{p2col:{it:cat_axis_line_options}}Description{p_end}
{p2line}
{p2col:{cmd:off} and {cmd:on}}suppress/force display of axis{p_end}
{p2col:{cmd:fill}}allocate space for axis even if {cmd:off}{p_end}
{p2col:{cmdab:fex:tend}}extend axis line through plot region and plot region's
      margin{p_end}
{p2col:{cmdab:ex:tend}}extend axis line through plot region{p_end}
{p2col:{cmdab:noex:tend}}do not extend axis line at all{p_end}
{p2col:{cmdab:noli:ne}}do not even draw axis line{p_end}
{p2col:{cmdab:li:ne}}force drawing of axis line{p_end}

{p2col:{cmdab:titleg:ap:(}{it:{help size}}{cmd:)}}margin between axis
      title and tick labels{p_end}
{p2col:{cmdab:outerg:ap:(}{it:{help size}}{cmd:)}}margin outside of
      axis title{p_end}

{p2col:{cmdab:lsty:le:(}{it:{help linestyle}}{cmd:)}}overall style of axis
      line{p_end}
{p2col:{cmdab:lc:olor:(}{it:{help colorstyle}}{cmd:)}}color and opacity of axis line{p_end}
{p2col:{cmdab:lw:idth:(}{it:{help linewidthstyle}}{cmd:)}}thickness of axis
      line{p_end}
{p2col:{cmdab:lp:attern:(}{it:{help linepatternstyle}}{cmd:)}}whether axis
      solid, dashed, etc.{p_end}
{p2line}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The {it:cat_axis_line_options} determine the look of the categorical {it:x}
axis in {cmd:graph} {cmd:bar}, {cmd:graph} {cmd:hbar}, {cmd:graph} {cmd:dot},
and {cmd:graph} {cmd:box}.  These options are rarely specified but when
specified, they are specified inside {cmd:axis()} of {cmd:over()}:

{phang2}
	{cmd:. graph} ...{cmd:, over(}{it:varname}{cmd:,} ... {cmd:axis(}{it:cat_axis_line_options}{cmd:)} ...{cmd:)}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 cat_axis_line_optionsQuickstart:Quick start}

        {mansection G-3 cat_axis_line_optionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:off} and {cmd:on}
    suppress or force the display of the axis.

{phang}
{cmd:fill} goes with {cmd:off} and is seldom
    specified.  If you turned an axis off but still wanted the space to be
    allocated for the axis, you could specify {cmd:fill}.

{phang}
{cmd:fextend}, {cmd:extend}, {cmd:noextend}, {cmd:line}, and {cmd:noline}
    determine how much of the line representing the axis is to be drawn.  They
    are alternatives.

{pmore}
    {cmd:noline} specifies that the line not be drawn at all.  The axis
    is there, ticks and labels will appear, but the axis line itself will not
    be drawn.

{pmore}
    {cmd:line} is the opposite of {cmd:noline}, for use if the axis line
    somehow got turned off.

{pmore}
    {cmd:noextend} specifies that the axis line not extend beyond the
    range of the axis, defined by the first and last categories.

{pmore}
    {cmd:extend} specifies that the line be longer than that and extend
    all the way across the plot region.

{pmore}
    {cmd:fextend} specifies that the line be longer than that and
    extend across the plot region and across the plot region's margins.  For a
    definition of the plot region's margins, see 
    {manhelpi region_options G-3}.  If the plot region has no margins (which
    would be rare), then {cmd:fextend} means the same as {cmd:extend}.  If the
    plot region does have margins, {cmd:extend} would result in the {it:y} and
    {it:x} axes not meeting.  With {cmd:fextend}, they touch.

{pmore}
    {cmd:fextend} is the default with most schemes.

{phang}
{cmd:titlegap(}{it:size}{cmd:)} specifies the margin to be inserted
     between the axis title and the axis's tick labels; see
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
The {it:cat_axis_line_options} are rarely specified.
{p_end}
