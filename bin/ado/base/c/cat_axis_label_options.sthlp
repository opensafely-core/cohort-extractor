{smcl}
{* *! version 1.1.10  16apr2019}{...}
{vieweralsosee "[G-3] cat_axis_label_options" "mansection G-3 cat_axis_label_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph bar" "help graph_bar"}{...}
{vieweralsosee "[G-2] graph box" "help graph_box"}{...}
{vieweralsosee "[G-2] graph dot" "help graph_dot"}{...}
{viewerjumpto "Syntax" "cat_axis_label_options##syntax"}{...}
{viewerjumpto "Description" "cat_axis_label_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "cat_axis_label_options##linkspdf"}{...}
{viewerjumpto "Options" "cat_axis_label_options##options"}{...}
{viewerjumpto "Remarks" "cat_axis_label_options##remarks"}{...}
{p2colset 1 33 35 2}{...}
{p2col:{bf:[G-3]} {it:cat_axis_label_options} {hline 2}}Options for specifying look of categorical axis labels{p_end}
{p2col:}({mansection G-3 cat_axis_label_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 30}{...}
{p2col:{it:cat_axis_label_options}}Description{p_end}
{p2line}
{p2col:{cmdab:nolab:els}}suppress axis labels{p_end}
{p2col:{cmdab:tick:s}}display axis ticks{p_end}
{p2col:{cmd:angle(}{it:{help anglestyle}}{cmd:)}}angle of axis labels{p_end}
{p2col:{cmdab:alt:ernate}}offset adjacent labels{p_end}

{p2col:{cmdab:tsty:le:(}{it:{help tickstyle}}{cmd:)}}labels & ticks: overall
       style{p_end}

{p2col:{cmd:labgap(}{it:{help size}}{cmd:)}}labels: margin between
       tick and label{p_end}
{p2col:{cmd:labstyle(}{it:{help textstyle}}{cmd:)}}labels: overall style{p_end}
{p2col:{cmdab:labs:ize:(}{it:{help textsizestyle}}{cmd:)}}labels: size of
        text{p_end}
{p2col:{cmdab:labc:olor:(}{it:{help colorstyle}}{cmd:)}}labels: color and
	opacity of text{p_end}

{p2col:{cmdab:tl:ength:(}{it:{help size}}{cmd:)}}ticks: length{p_end}
{p2col:{cmdab:tp:osition:(}{cmdab:o:utside}|{cmdab:c:rossing}|}{p_end}
{p2col 24 37 37 2:{cmdab:i:nside:)}}ticks: position/direction{p_end}
{p2col:{cmdab:tlsty:le:(}{it:{help linestyle}}{cmd:)}}ticks: linestyle of{p_end}
{p2col:{cmdab:tlw:idth:(}{it:{help linewidthstyle}}{cmd:)}}ticks: thickness of
        line{p_end}
{p2col:{cmdab:tlc:olor:(}{it:{help colorstyle}}{cmd:)}}ticks: color and
	opacity of line{p_end}
{p2line}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The {it:cat_axis_label_options} determine the look of the labels that appear
on a categorical {it:x} axis produced by {helpb graph bar},
{helpb graph hbar}, {helpb graph dot}, and {helpb graph box}.  These options
are specified inside {cmd:label()} of {cmd:over()}:

{phang2}
	. {cmd:graph} ...{cmd:, over(}{it:varname}{cmd:,} ... {cmd:label(}{it:cat_axis_label_options}{cmd:)} ...{cmd:)}

{pstd}
The most useful
{it:cat_axis_label_options} are
{cmd:angle()}, {cmd:alternate}, {cmd:labcolor()}, and {cmd:labsize()}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 cat_axis_label_optionsQuickstart:Quick start}

        {mansection G-3 cat_axis_label_optionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:nolabels}
    suppresses display of category labels on the axis.  For 
    {cmd:graph} {cmd:bar} and {cmd:graph} {cmd:hbar}, the {cmd:nolabels}
    option is useful when combined with the {cmd:blabel()} option used to
    place the labels on the bars themselves; see {manhelpi blabel_option G-3}.

{phang}
{cmd:ticks}
    specifies that ticks appear on the categorical {it:x} axis.
    By default, ticks are not presented on categorical axes, and it is unlikely
    that you would want them to be.

{phang}
{cmd:angle(}{it:anglestyle}{cmd:)}
    specifies the angle at which the labels on the axis
    appear.  The default is {cmd:angle(0)}, meaning horizontal.  With
    vertical bar charts and other vertically oriented charts,
    it is sometimes useful to specify
    {cmd:angle(90)} (vertical text reading bottom to top),
    {cmd:angle(-90)} (vertical text reading top to bottom), or
    {cmd:angle(-45)} (angled text reading top left to bottom right);
    see {manhelpi anglestyle G-4}.

{pmore}
    Unix users:  if you specify {cmd:angle(-45)}, results will appear on your
    screen as if you specified {cmd:angle(-90)}; results will appear correctly
    when you print.

{phang}
{cmd:alternate}
    causes adjacent labels to be offset from one another and is useful when
    there are many labels or when labels are long.  For instance, rather than
    obtaining an axis labeled,

	    {hline 4}{c TT}{hline 9}{c TT}{hline 9}{c TT}{hline 9}{c TT}{hline 4}
	     ResearchDevelopmentMarketing   Sales

{pmore}
    with {cmd:alternate}, you obtain

	    {hline 4}{c TT}{hline 9}{c TT}{hline 9}{c TT}{hline 9}{c TT}{hline 4}
	     Research           Marketing
		     Development            Sales

{phang}
{cmd:tstyle(}{it:tickstyle}{cmd:)}
    specifies the overall look of labels and ticks; see
    {manhelpi tickstyle G-4}.  Here the
    emphasis is on labels because ticks are usually suppressed on a categorical
    axis.  The options documented below will allow you to change each
    attribute of the label and tick, but the {it:tickstyle} specifies the
    starting point.

{pmore}
    You need not specify {cmd:tstyle()} just because there is something
    you want to change about the look of labels and ticks.  You specify
    {cmd:tstyle()} when another style exists that is exactly what you desire
    or when another style would allow you to specify fewer changes to obtain
    what you want.

{phang}
{opt labgap(size)},
{opt labstyle(textstyle)},
{opt labsize(textsizestyle)}, and
{opt labcolor(colorstyle)}
    specify details about how the labels are presented.  Of particular
    interest are {cmd:labsize(}{it:textsizestyle}{cmd:)}, which specifies the
    size of the labels, and {cmd:labcolor(}{it:colorstyle}{cmd:)}, which
    specifies the color of the labels; see {manhelpi textsizestyle G-4} and
    {manhelpi colorstyle G-4} for a list of text sizes and color choices.
    Also see {manhelpi size G-4} and {manhelpi textstyle G-4}.

{phang}
{cmd:tlength(}{it:size}{cmd:)}
    specifies the overall length of the ticks; see {manhelpi size G-4}.

{phang}
{cmd:tposition(outside}|{cmd:crossing}|{cmd:inside)}
    specifies whether the ticks are to extend {cmd:outside} (from the axis
    out, the usual default), {cmd:crossing} (crossing the axis
    line, extending in and out), or {cmd:inside} (from the axis
    into the plot region).

{phang}
{opt tlstyle(linestyle)},
{opt tlwidth(linewidthstyle)}, and
{opt tlcolor(colorstyle)}
    specify other details about the look of the ticks.
    Ticks are just lines.
    See {help lines} for more information.


{marker remarks}{...}
{title:Remarks}

{pstd}
You draw a bar, dot, or box plot of {cmd:empcost} by {cmd:division}:

{phang2}
	{cmd:. graph} ... {cmd:empcost, over(division)}

{pstd}
Seeing the result, you wish to make the text labeling the divisions 20%
larger.  You type:

{phang2}
	. {cmd:graph} ... {cmd:empcost, over(division, label(labsize(*1.2)))}
{p_end}
