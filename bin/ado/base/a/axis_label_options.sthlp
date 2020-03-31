{smcl}
{* *! version 1.4.8  16apr2019}{...}
{vieweralsosee "[G-3] axis_label_options" "mansection G-3 axis_label_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] axis_options" "help axis_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] axis_scale_options" "help axis_scale_options"}{...}
{vieweralsosee "[G-3] axis_title_options" "help axis_title_options"}{...}
{viewerjumpto "Syntax" "axis_label_options##syntax"}{...}
{viewerjumpto "Description" "axis_label_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "axis_label_options##linkspdf"}{...}
{viewerjumpto "Options" "axis_label_options##options"}{...}
{viewerjumpto "Suboptions" "axis_label_options##suboptions"}{...}
{viewerjumpto "Remarks" "axis_label_options##remarks"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[G-3]} {it:axis_label_options} {hline 2}}Options for specifying axis labels{p_end}
{p2col:}({mansection G-3 axis_label_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
{it:axis_label_options} are a subset of {it:axis_options}; see 
{manhelpi axis_options G-3}.  {it:axis_label_options} control the
placement and the look of ticks and labels on an axis.  

{synoptset 31}{...}
{p2col:{it:axis_label_options}} Description{p_end}
{p2line}
{p2col:{c -(}{cmdab:y:}|{cmdab:x:}|{cmdab:t:}|{cmdab:z:}{c )-}{cmdab:lab:el:(}{it:rule_or_values}{cmd:)}}
	major ticks plus labels{p_end}
{p2col:{c -(}{cmdab:y:}|{cmdab:x:}|{cmdab:t:}|{cmdab:z:}{c )-}{cmdab:ti:ck:(}{it:rule_or_values}{cmd:)}}
	major ticks only{p_end}
{p2col:{c -(}{cmdab:y:}|{cmdab:x:}|{cmdab:t:}|{cmdab:z:}{c )-}{cmdab:mlab:el:(}{it:rule_or_values}{cmd:)}}
	minor ticks plus labels{p_end}
{p2col:{c -(}{cmdab:y:}|{cmdab:x:}|{cmdab:t:}|{cmdab:z:}{c )-}{cmdab:mti:ck:(}{it:rule_or_values}{cmd:)}}
	minor ticks only{p_end}
{p2line}
{p2colreset}{...}
{p 4 6 2}
The above options are {it:merged-explicit}; see
{manhelp repeated_options G-4:Concept: repeated options}.

{pstd}
where {it:rule_or_values} is defined as

{p 8 16 2}
[{it:rule}]
[{it:{help numlist}} [{cmd:"}{it:label}{cmd:"} [{it:numlist}
[{cmd:"}{it:label}{cmd:"} [...]]]]]
[{cmd:,} {it:suboptions}]

{p 4 6 2}
Either {it:rule} or {it:numlist} must be specified, and both may be
specified.

    {it:rule}{col 14}Example{col 26}Description
    {hline 70}
    {cmd:#}{it:#}{...}
{col 14}{cmd:#6}{...}
{col 26}approximately 6 nice values
    {cmd:##}{it:#}{...}
{col 14}{cmd:##10}{...}
{col 26}10-1=9 values between major ticks;
{col 26}  allowed with {cmd:mlabel()} and {cmd:mtick()} only
    {it:#}{cmd:(}{it:#}{cmd:)}{it:#}{...}
{col 14}{cmd:-4(.5)3}{...}
{col 26}specified range: -4 to 3 in steps of .5
    {cmd:minmax}{...}
{col 14}{cmd:minmax}{...}
{col 26}minimum and maximum values
    {cmd:none}{...}
{col 14}{cmd:none}{...}
{col 26}label no values
    {cmd:.}{...}
{col 14}{cmd:.}{...}
{col 26}skip the rule
    {hline 70}

{p 4 6 2}
where {it:numlist} is as described in {manhelp numlist U:11.1.8 numlist}.

{p 4 6 2}
{cmd:tlabel()}, 
{cmd:ttick()},
{cmd:tmlabel()}, and
{cmd:tmtick()} also accept a {it:datelist} and an extra type of {it:rule}

    {it:rule}{col 18}Example{col 36}Description
    {hline 70}
    {it:date}{cmd:(}{it:#}{cmd:)}{it:date}{...}
{col 18}{cmd:1999m1(1)1999m12}{...}
{col 36}specified date range: each month
{col 38}assuming the axis has the {cmd:%tm} format
     {hline 70}

{p 4 6 2}
where {it:date} and {it:datelist} may contain dates, provided that the {it:t}
(time) axis has a date format; see {manhelp datelist U:11.1.9 datelist}.

{synoptset 30}{...}
{p2col:{it:suboptions}}Description{p_end}
{p2line}
{p2col:{cmdab:ax:is:(}{it:#}{cmd:)}}which axis, {cmd:1} {ul:<} {it:#} {ul:<}
       {cmd:9}{p_end}
{p2col:{cmd:add}}combine options{p_end}
{p2col:[{cmdab:no:}]{cmdab:tick:s}}suppress ticks{p_end}
{p2col:[{cmdab:no:}]{cmdab:lab:els}}suppress labels{p_end}
{p2col:{cmdab:val:uelabel}}label values using first variable's value label
         {p_end}
{p2col:{cmd:format(}{help format:{bf:%}{it:fmt}}{cmd:)}}format values per
         {cmd:%}{it:fmt}{p_end}
{p2col:{cmd:angle(}{it:{help anglestyle}}{cmd:)}}angle the labels{p_end}
{p2col:{cmdab:alt:ernate}}offset adjacent labels{p_end}
{p2col:{cmd:norescale}}do not rescale the axis{p_end}

{p2col:{cmdab:tsty:le:(}{it:{help tickstyle}}{cmd:)}}labels and ticks: overall
        style{p_end}

{p2col:{cmd:labgap(}{it:{help size}}{cmd:)}}labels: margin between tick
        and label{p_end}
{p2col:{cmd:labstyle(}{it:{help textstyle}}{cmd:)}}labels: overall style{p_end}
{p2col:{cmdab:labs:ize:(}{it:{help textsizestyle}}{cmd:)}}labels: size of text
        {p_end}
{p2col:{cmdab:labc:olor:(}{it:{help colorstyle}}{cmd:)}}labels: color and
	opacity of text{p_end}

{p2col:{cmdab:tl:ength:(}{it:{help size}}{cmd:)}}ticks: length{p_end}
{p2col:{cmdab:tp:osition:(}{cmdab:o:utside}|{cmdab:c:rossing}|}{p_end}
{p2col 14 37 39 2:{cmdab:i:nside:)}}ticks: position/direction{p_end}
{p2col:{cmdab:tlsty:le:(}{it:{help linestyle}}{cmd:)}}ticks: linestyle of{p_end}
{p2col:{cmdab:tlw:idth:(}{it:{help linewidthstyle}}{cmd:)}}ticks: thickness of
        line{p_end}
{p2col:{cmdab:tlc:olor:(}{it:{help colorstyle}}{cmd:)}}ticks: color and
	opacity of line{p_end}

{p2col:{cmd:custom}}tick- and label-rendition options apply only to these
         labels{p_end}

{p2col:[{cmd:no}]{cmd:grid}}grid: include{p_end}
{p2col:[{cmd:no}]{cmd:gmin}}grid: grid line at minimum{p_end}
{p2col:[{cmd:no}]{cmd:gmax}}grid: grid line at maximum{p_end}
{p2col:{cmdab:gsty:le:(}{it:{help gridstyle}}{cmd:)}}grid: overall style{p_end}
{p2col:[{cmdab:no:}]{cmdab:gex:tend}}grid: extend into plot region margin{p_end}
{p2col:{cmdab:glsty:le:(}{it:{help linestyle}}{cmd:)}}grid: linestyle of{p_end}
{p2col:{cmdab:glw:idth:(}{it:{help linewidthstyle}}{cmd:)}}grid: thickness of
         line{p_end}
{p2col:{cmdab:glc:olor:(}{it:{help colorstyle}}{cmd:)}}grid: color and opacity
	of line{p_end}
{p2col:{cmdab:glp:attern(}{it:{help linepatternstyle}}{cmd:)}}grid: line
           pattern of line{p_end}
{p2line}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{it:axis_label_options} control the placement and the look of ticks and labels
on an axis.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 axis_label_optionsQuickstart:Quick start}

        {mansection G-3 axis_label_optionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:ylabel}({it:rule_or_values{cmd:)}},
{cmd:xlabel(}{it:rule_or_values{cmd:)}},
{cmd:tlabel(}{it:rule_or_values{cmd:)}}, and
{cmd:zlabel(}{it:rule_or_values{cmd:)}}
    specify the major values to be labeled and ticked along the axis.  For
    instance, to label the values 0, 5, 10, ..., 25 along the {it:x} axis,
    specify {cmd:xlabel(0(5)25)}.  If the {it:t} axis has the {cmd:%tm}
    format, {cmd:tlabel(1999m1(1)1999m12)} will label all the months in 1999.

{phang}
{cmd:ytick}({it:rule_or_values{cmd:)}},
{cmd:xtick(}{it:rule_or_values{cmd:)}},
{cmd:ttick(}{it:rule_or_values{cmd:)}}, and
{cmd:ztick(}{it:rule_or_values{cmd:)}}
    specify the major values to be ticked but not labeled along the axis.
    For instance, to tick  the values 0, 5, 10, ..., 25 along the {it:x} axis,
    specify {cmd:xtick(0(5)25)}.  Specify {cmd:ttick(1999m1(1)1999m12)} to
    place ticks for each month in the year 1999.

{phang}
{cmd:ymlabel(}{it:rule_or_values{cmd:)}},
{cmd:xmlabel(}{it:rule_or_values{cmd:)}},
{cmd:tmlabel(}{it:rule_or_values{cmd:)}}, and
{cmd:zmlabel(}{it:rule_or_values{cmd:)}}
    specify minor values to be labeled and ticked along the axis.

{phang}
{cmd:ymtick(}{it:rule_or_values{cmd:)}},
{cmd:xmtick(}{it:rule_or_values{cmd:)}},
{cmd:tmtick(}{it:rule_or_values{cmd:)}}, and
{cmd:zmtick(}{it:rule_or_values{cmd:)}}
    specify minor values to be ticked along the axis.

{phang}
{cmd:zlabel(}{it:rule_or_values{cmd:)}},
{cmd:ztick(}{it:rule_or_values{cmd:)}},
{cmd:zmlabel(}{it:rule_or_values{cmd:)}}, and
{cmd:zmtick(}{it:rule_or_values{cmd:)}}; see
    {it:{help axis_label_options##remarks8:Contour axes -- zlabel(), etc.}}
    below.


{marker suboptions}{...}
{title:Suboptions}

{phang}
{cmd:axis(}{it:#}{cmd:)}
    specifies to which scale this axis belongs and is specified when dealing
    with multiple {it:x} ({it:t}) or {it:y} axes; see 
    {manhelpi axis_choice_options G-3}.

{phang}
{cmd:add}
    specifies what is to be added to any {cmd:xlabel()}, {cmd:ylabel()},
    {cmd:xtick()}, ..., or {cmd:ymtick()} option previously specified.  Labels
    or ticks are added to any default labels or ticks or to any labels or
    ticks specified in previous {cmd:xlabel()}, {cmd:ylabel()}, {cmd:xtick()},
    ..., or {cmd:ymtick()} options.  Only value specifications are added;
    rule specifications always replace any existing rule.
    See {it:{help axis_label_options##appendix5:Interpretation of repeated options}} below.

{phang}
{cmd:noticks} and {cmd:ticks} suppress/force the drawing of ticks.
    {cmd:ticks} is the usual default, so {cmd:noticks}
    makes
    {c -(}{cmd:y}|{cmd:x}{c )-}{cmd:label()}
    and
    {c -(}{cmd:y}|{cmd:x}{c )-}{cmd:mlabel()}
    display the labels only.

{phang}
{cmd:nolabels} and {cmd:labels}
    suppress/force the display of the labels.
    {cmd:labels} is the usual default, so {cmd:nolabels}
    turns
    {c -(}{cmd:y}|{cmd:x}{c )-}{cmd:label()}
    into
    {c -(}{cmd:y}|{cmd:x}{c )-}{cmd:tick()}
    and
    {c -(}{cmd:y}|{cmd:x}{c )-}{cmd:mlabel()}
    into
    {c -(}{cmd:y}|{cmd:x}{c )-}{cmd:mtick()}.
    Why anyone would want to do this is difficult to imagine.

{phang}
{cmd:valuelabel} specifies
    that values should be mapped through
    the first {it:y} variable's value label ({cmd:y}{it:*}{cmd:()} options)
    or the {it:x} variable's value label
    ({cmd:x}{it:*}{cmd:()} options).
    Consider the command {cmd:scatter yvar xvar} and assume that {cmd:xvar}
    has been previously given a value label:

	    {cmd:. label define cat 1 "Low" 2 "Med" 3 "Hi"}
	    {cmd:. label values xvar cat}

{p 8 8 2}
Then

{p 12 16 2}
	    {cmd:. scatter yvar xvar, xlabel(1 2 3, valuelabel)}

{p 8 8 2}
    would, rather than putting the numbers 1, 2, and 3, put the words Low,
    Med, and Hi on the {it:x} axis.  It would have the same effect as

{p 12 16 2}
	    {cmd:scatter yvar xvar, xlabel(1 "Low" 2 "Med" 3 "Hi")}

{phang}
{cmd:format(}{help format:{bf:%}{it:fmt}}{cmd:)}
    specifies how numeric values on the axes should be formatted.  The default
    {cmd:format()} is obtained from the variables specified with the
    {cmd:graph} command, which for {cmd:ylabel()}, {cmd:ytick()},
    {cmd:ymlabel()}, and {cmd:ymtick()} usually means the first {it:y}
    variable, and for {cmd:xlabel()}, ..., {cmd:xmtick()}, means the {it:x}
    variable.  For instance, in

{p 16 20 2}
		{cmd:. scatter y1var y2var xvar}

{p 8 8 2}
    the default format for the {it:y} axis would be {cmd:y1var}'s
    format, and the default for the {it:x} axis would be {cmd:xvar}'s format.

{p 8 8 2}
    You may specify the {cmd:format()} suboption (or any suboption)
    without specifying values if you want the default labeling presented
    differently.  For instance,

{p 16 20 2}
		{cmd:. scatter y1var y2var xvar, ylabel(,format(%9.2fc))}

{p 8 8 2}
    would present default labeling of the {it:y} axis, but the numbers would
    be formatted with the {cmd:%9.2fc} format.  Note carefully the comma
    in front of {cmd:format}.  Inside the {cmd:ylabel()} option, we are
    specifying suboptions only.

{phang}
{cmd:angle(}{it:anglestyle}{cmd:)}
    causes the labels to be presented at an angle.
    See {manhelpi anglestyle G-4}.

{phang}
{cmd:alternate}
    causes adjacent labels to be offset from one another and is useful when
    many values are being labeled.  For instance, rather than obtaining

	     {hline 2}{c TT}{hline 3}{c TT}{hline 3}{c TT}{hline 3}{c TT}{hline 3}{c TT}{hline 3}{c TT}{hline 3}{c TT}{hline 2}
	      1.0 1.1 1.2 1.3 1.4 1.5 1.6

{p 8 8 2}
    with {cmd:alternate}, you would obtain

	     {hline 2}{c TT}{hline 3}{c TT}{hline 3}{c TT}{hline 3}{c TT}{hline 3}{c TT}{hline 3}{c TT}{hline 3}{c TT}{hline 2}
	      1.0     1.2     1.4     1.6
		  1.1     1.3     1.5

{phang}
{cmd:norescale}
    specifies that the ticks or labels in the option be placed directly on the
    graph without rescaling the axis or associated plot region for the new
    values.  By default, label options automatically rescale the axis and
    plot region to include the range of values in the new labels or ticks.
    {opt norescale} allows you to plot ticks or labels outside the normal
    bounds of an axis.

{phang}
{opt tstyle(tickstyle)}
    specifies the overall look of ticks and labels; see
    {manhelpi tickstyle G-3}.  The options documented
    below will allow you to change each attribute of a tick and its label, but
    the {it:tickstyle} specifies the starting point.

{p 8 8 2}
    You need not specify {cmd:tstyle()} just because there is something
    you want to change about the look of ticks or labels.  You specify
    {cmd:tstyle()} when another style exists that is exactly what you desire
    or when another style would allow you to specify fewer changes to obtain
    what you want.

{phang}
{opt labgap(size)},
{opt labstyle(textstyle)},
{opt labsize(textsizestyle)}, and
{opt labcolor(colorstyle)}
    specify details about how the labels are presented.
    See {manhelpi size G-4}, {manhelpi textstyle G-4},
        {manhelpi textsizestyle G-4}, and {manhelpi colorstyle G-4}.

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
    See {manhelpi linestyle G-4}, {manhelpi linewidthstyle G-4}, and
    {manhelpi colorstyle G-4}.  Ticks are just lines.
    See {manhelp lines G-4:Concept: lines} for more information.

{phang}
{opt custom} specifies that the label-rendition suboptions, the tick-rendition
options, and the {cmd:angle()}
option apply only to the labels added on the current
{{cmd:y}|{cmd:x}[{cmd:m}]{cmd:t}}{cmd:label()} or 
{{cmd:y}|{cmd:x}|{cmd:t}}{cmd:mlabel()}
option, rather than being applied to all major or minor labels on the
axis.  Customizable suboptions are {opt tstyle()}, {opt labgap()}, 
{opt labstyle()}, {opt labsize()}, {opt labcolor()}, {opt tlength()}, 
{opt tposition()}, {opt tlstyle()}, {opt tlwidth()}, and {opt tlcolor()}.

{pmore}
{opt custom} is usually combined with suboption {opt add} to
emphasize points on the axis by extending the length of the tick, changing the
color or size of the label, or otherwise changing the look of the custom
labels or ticks.

{phang}
{cmd:grid} and {cmd:nogrid}
    specify whether grid lines are to be drawn across the plot region in
    addition to whatever else is specified in the
    {c -(}{cmd:y}|{cmd:x}{c )-}[{cmd:m}]{cmd:label()} or
    {c -(}{cmd:y}|{cmd:x}{c )-}[{cmd:m}]{cmd:tick()}
    option in which {cmd:grid} or {cmd:nogrid} appears.
    Typically, {cmd:nogrid} is
    the default, and {cmd:grid} is the option for all except
    {cmd:ylabel()}, where things are reversed and {cmd:grid} is the default
    and {cmd:nogrid} is the option.  (Which is the default and which is the
    option is controlled by the scheme; see
    {manhelp schemes G-4:Schemes intro}.)

{p 8 8 2}
    For instance, specifying option

	    {cmd:ylabel(, nogrid)}

{p 8 8 2}
    would suppress the grid lines in the {it:y} direction and specifying

	    {cmd:xlabel(, grid)}

{p 8 8 2}
    would add them in the {it:x}.  Specifying
	
	    {cmd:xlabel(0(1)10, grid)}

{p 8 8 2}
    would place major labels, major ticks,
    and grid lines at {it:x} = 0, 1, 2, ..., 10.

{phang}
[{cmd:no}]{cmd:gmin} and
[{cmd:no}]{cmd:gmax}
    are relevant only if {cmd:grid} is in effect (because {cmd:grid} is
    the default and {cmd:nogrid} was not specified or because {cmd:grid}
    was specified).
    [{cmd:no}]{cmd:gmin} and
    [{cmd:no}]{cmd:gmax}
    specify whether grid lines are to be drawn at the minimum and maximum
    values.  Consider

{p 12 16 2}
	    {cmd:. scatter yvar xvar, xlabel(0(1)10, grid)}

{p 8 8 2}
    Clearly the values 0, 1, ..., 10 are to be ticked and labeled, and clearly,
    grid lines should be drawn at 1, 2, ..., 9; but should grid lines be drawn
    at 0 and 10?  If 0 and 10 are at the edge of the plot region, you probably
    do not want grid lines there.  They will be too close to the axis
    and border of the graph.

{p 8 8 2}
    What you want will differ from graph to graph, so the {cmd:graph} command
    tries to be smart, meaning that 
    neither {cmd:gmin} nor {cmd:nogmin} (and neither {cmd:gmax} nor
    {cmd:nogmax}) is the default:  The default is for {cmd:graph} to decide
    which looks best; the options force the decision one way or the other.

{p 8 8 2}
    If {cmd:graph} decided to suppress the grids at the extremes and
    you wanted them, you could type

{p 12 16 2}
	    {cmd:. scatter yvar xvar, xlabel(0(1)10, grid gmin gmax)}

{phang}
{cmd:gstyle(}{it:gridstyle}{cmd:)}
    specifies the overall style of the grid lines, including whether the lines
    extend beyond the plot region and into the plot region's margins,
    along with the style, color, width, and pattern of the lines themselves.
    The options that follow allow you to change each attribute, but the
    {it:gridstyle} provides the starting point. See {manhelpi gridstyle G-4}.

{p 8 8 2}
    You need not specify {cmd:gstyle()} just because there is something
    you want to change.  You specify {cmd:gstyle()} when another style
    exists that is exactly what you desire or when another style would allow
    you to specify fewer changes to obtain what you want.

{phang}
{cmd:gextend} and {cmd:nogextend}
    specify whether the grid lines should extend beyond the plot region
    and pass through the plot region's
    margins; see {manhelpi region_options G-3}.  The default is determined
    by the {cmd:gstyle()} and scheme, but usually, {cmd:nogextend}
    is the default and {cmd:gextend} is the option.

{phang}
{opt glstyle(linestyle)},
{opt glwidth(linewidthstyle)},
{opt glcolor(colorstyle)}, and
{opt glpattern(linepatternstyle)}
    specify other details about the look of the grid.
    See {manhelpi linestyle G-4}, {manhelpi linewidthstyle G-4},
    {manhelpi colorstyle G-4}, and {manhelpi linepatternstyle G-4}.
    Grids are just lines.
    See {manhelp lines G-4:Concept: lines} for more information.
    Of these options, {cmd:glpattern()} is of particular interest
    because, with it, you can make the grid lines dashed.


{marker remarks}{...}
{title:Remarks}

{pstd}
{it:axis_label_options} are a subset of {it:axis_options};
see {manhelpi axis_options G-3} for an overview.
The other appearance options are

	{it:axis_scale_options}{right:(see {manhelpi axis_scale_options G-3})  }

	{it:axis_title_options}{right:(see {manhelpi axis_title_options G-3})  }

{pstd}
Remarks are presented under the following headings:

	{help axis_label_options##remarks1:Default labeling and ticking}
	{help axis_label_options##remarks2:Controlling the labeling and ticking}
	{help axis_label_options##remarks3:Adding extra ticks}
	{help axis_label_options##remarks4:Adding minor labels and ticks}
	{help axis_label_options##remarks5:Adding grid lines}
	{help axis_label_options##remarks6:Suppressing grid lines}
	{help axis_label_options##remarks7:Substituting text for labels}
	{help axis_label_options##remarks8:Contour axes -- zlabel(), etc.}

	{help axis_label_options##appendix:Appendix:  Details of syntax}
	    {help axis_label_options##appendix1:Suboptions without rules, numlists, or labels}
	    {help axis_label_options##appendix2:Rules}
	    {help axis_label_options##appendix3:Rules and numlists}
	    {help axis_label_options##appendix4:Rules and numlists and labels}
	    {help axis_label_options##appendix5:Interpretation of repeated options}



{marker remarks1}{...}
{title:Default labeling and ticking}

{pstd}
By default, approximately five values are labeled and ticked on each axis.
For example, in

	{cmd:. sysuse auto}

	{cmd:. scatter mpg weight}
	  {it:({stata "gr_example auto: scatter mpg weight":click to run})}
{* graph mpgweight}{...}

{pstd}
four values are labeled on each axis because choosing five would have required
widening the scale too much.


{marker remarks2}{...}
{title:Controlling the labeling and ticking}

{pstd}
We would obtain the same results as we did in the above example if we typed

{phang2}
	{cmd:. scatter mpg weight, ylabel(#5) xlabel(#5)}

{pstd}
Options {cmd:ylabel()} and {cmd:xlabel()} specify the values to be labeled and
ticked, and {cmd:#5} specifies that Stata choose approximately five values for
us.  If we wanted many values labeled, we might type

{phang2}
	{cmd:. scatter mpg weight, ylabel(#10) xlabel(#10)}
{p_end}
	  {it:({stata "gr_example auto: scatter mpg weight, ylabel(#10) xlabel(#10)":click to run})}
{* graph axislab2}{...}

{pstd}
As with {cmd:#5}, {cmd:#10} was not taken too seriously; we obtained seven
labels on the {it:y} axis and eight on the {it:x} axis.

{pstd}
We can also specify precisely the values we want labeled by
specifying {it:#}{cmd:(}{it:#}{cmd:)}{it:#} or by specifying
a list of numbers:

	{cmd:. scatter mpg weight, ylabel(10(5)45)}
	{cmd:                      xlabel(1500 2000 3000 4000 4500 5000)}
	  {it:({stata "gr_example auto: scatter mpg weight, ylabel(10(5)45) xlabel(1500 2000 3000 4000 4500 5000)":click to run})}
{* graph axislab3}{...}

{pstd}
In option {cmd:ylabel()}, we specified the rule {cmd:10(5)45}, which means 
to label 10 to 45 in steps of 5.  In option {cmd:xlabel()}, we typed out the
values to be labeled.


{marker remarks3}{...}
{title:Adding extra ticks}

{pstd}
Options {cmd:ylabel()} and {cmd:xlabel()} draw ticks plus labels.
Options {cmd:ytick()} and {cmd:xtick()} draw ticks only, so you can do things
such as

	{cmd:. scatter mpg weight, ytick(#10) xtick(#15)}
	  {it:({stata "gr_example auto: scatter mpg weight, ytick(#10) xtick(#15)":click to run})}
{* graph axislab4}{...}

{pstd}
Of course, as with {cmd:ylabel()} and {cmd:xlabel()}, you can specify the
exact values you want ticked.


{marker remarks4}{...}
{title:Adding minor labels and ticks}

{pstd}
Minor ticks and minor labels are smaller than regular ticks and regular
labels.  Options {cmd:ymlabel()} and {cmd:xmlabel()} allow you to place
minor ticks with labels, and {cmd:ymtick()} and {cmd:xmtick()} allow you to 
place minor ticks without labels.  When using minor ticks and labels,
in addition to the usual syntax of {cmd:#5} to mean approximately 5 values,
{cmd:10(5)45} to mean 10 to 45 in steps of 5, and a list of numbers, there is
an additional syntax:  {cmd:##5}.  {cmd:##5} means that each major interval is
divided into 5 minor intervals.

{pstd}
The graph below is intended more for demonstration than as an example of a
good-looking graph:

{phang2}
	{cmd:. scatter mpg weight, ymlabel(##5) xmtick(##10)}
{p_end}
	  {it:({stata "gr_example2 minorticks1":click to run})}
{* graph axislab5}{...}

{pstd}
{cmd:##5} means four ticks, and {cmd:##10} means nine ticks because most
people think in reciprocals they say to themselves, "I want to tick the
fourths so I want 4 ticks between," or,  "I want to tick the tenths so I want
10 ticks between".  They think incorrectly.  They should think that if they
want fourths, they want 4-1=3 ticks between, or if they want tenths, they want
10-1=9 ticks between.  Stata subtracts one so that they can think -- and
correctly -- when they want fourths that they want {cmd:##4} ticks between and
that when they want tenths they want {cmd:##10} ticks between.

{pstd}
For {cmd:##}{it:#} rules to work, the major ticks must be evenly spaced.  This
format is guaranteed only when the major ticks or labels are specified using the
{it:#}{cmd:(}{it:#}{cmd:)}{it:#} rule.  The {cmd:##}{it:#} rule also works in
almost all cases, the exception being daily data where the date variable is
specified in the {cmd:%td} format.  Here "nice" daily labels often do
not have a consistent number of days between the ticks and thus the space
between each major tick cannot be evenly divided.  If the major ticks are not
evenly spaced, the {cmd:##}{it:#} rule does not produce any minor ticks.


{marker remarks5}{...}
{title:Adding grid lines}

{pstd}
To obtain grid lines, specify the {cmd:grid} suboption of {cmd:ylabel()},
{cmd:xlabel()}, {cmd:ymlabel()}, or {cmd:xmlabel()}.  {cmd:grid} specifies
that, in addition to whatever else the option would normally do, grid lines
be drawn at the same values.  In the example below,

	{cmd:. sysuse uslifeexp, clear}

	{cmd:. line le year, xlabel(,grid)}
	  {it:({stata "gr_example uslifeexp: line le year, xlabel(,grid)":click to run})}
{* graph axislab6}{...}

{pstd}
we specify {cmd:xlabel(,grid)}, omitting any mention of the specific values to
use.  Thus {cmd:xlabel()} did what it does ordinarily (labeled approximately
five nice values), and it drew grid lines at those same values.

{pstd}
Of course, we
could have specified the values to be labeled and gridded:

	{cmd:. line le year, xlabel(#10, grid)}

	{cmd:. line le year, xlabel(1900(10)2000, grid)}

{phang2}
	{cmd:. line le year, xlabel(1900 1918 1940(20)2000, grid)}

{pstd}
The {cmd:grid} suboption is usually specified with {cmd:xlabel()}
(and with {cmd:ylabel()} if, given the scheme, {cmd:grid} is not the
default),
but it may be specified with any of the
{it:axis_label_options}.
In the example below, we "borrow"
{cmd:ymtick()} and {cmd:xmtick()}, specify {cmd:grid} to make them draw
grids, and specify {cmd:style(none)} to make the ticks themselves
invisible:

	{cmd:. sysuse auto, clear}

	{cmd:. scatter mpg weight, ymtick(#20, grid tstyle(none))}
	{cmd:                      xmtick(#20, grid tstyle(none))}
	  {it:({stata "gr_example auto: scatter mpg weight, ymtick(#20, grid tstyle(none)) xmtick(#20, grid tstyle(none))":click to run})}
{* graph axislab7}{...}

{pstd}
If you look carefully at the graph above, you will find that no grid line was
drawn at {it:x}=5,000.  Stata suppresses grid lines when
they get too close to the axes or borders of the graph.  If you want to
force Stata to draw them anyway, you can specify the {cmd:gmin} and
{cmd:gmax} options:

	{cmd:. scatter mpg weight, ymtick(#20, grid tstyle(none))}
	{cmd:                      xmtick(#20, grid tstyle(none) gmax)}


{marker remarks6}{...}
{title:Suppressing grid lines}

{pstd}
Some commands, and option {cmd:ylabel()},
usually draw grid lines by default.
For instance, in the following, results are the same as if you specified
{cmd:ylabel(,grid)}:

	{cmd:. sysuse auto, clear}

	{cmd:. scatter mpg weight, by(foreign)}
	  {it:({stata "gr_example auto: scatter mpg weight, by(foreign)":click to run})}
{* graph mpgweightby}{...}

{pstd}
To suppress the grid lines, specify {cmd:ylabel(,nogrid)}:

{phang2}
	{cmd:. scatter mpg weight, by(foreign) ylabel(,nogrid)}


{marker remarks7}{...}
{title:Substituting text for labels}

{pstd}
In addition to specifying explicitly the values to be labeled by
specifying things such as {cmd:ylabel(10(10)50)}
or {cmd:ylabel(10 20 30 40 50)},
you can specify text to be substituted for the label.  If you type

{phang2}
	{cmd:. graph} ...{cmd:,} ...{cmd:ylabel(10 20 30 "mean" 40 50)}

{pstd}
The values 10, 20, ..., 50 will be labeled, just as you would expect,
but for the middle value, rather than the text "30" appearing, the text
"mean" (without the quotes) would appear.

{pstd}
In the advanced example, below we specify

	{cmd:xlabel(1 "J"  2 "F"  3 "M"  4 "A"  5 "M"  6 "J"}
	{cmd:       7 "J"  8 "A"  9 "S" 10 "O" 11 "N" 12 "D")}

{pstd}
so that rather than seeing the numbers 1, 2, ..., 12 (which are month numbers),
we see J, F, ..., D; and we specify

{phang2}
	{cmd:ylabel(12321 "12,321 (mean)", axis(2) angle(0))}

{pstd}
so that we label 12321 but, rather than seeing 12321, we see "12,321 (mean)".
The {cmd:axis(2)} option puts the label on the second {it:y} axis
(see {manhelpi axis_choice_options G-3}) and {cmd:angle(0)} makes the
text appear horizontally rather than vertically (see {it:Options} above):

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

{marker remarks8}{...}
{title:Contour axes -- zlabel(), etc.}

{pstd}
The {cmd:zlabel()}, {cmd:ztick()}, {cmd:zmlabel()}, and {cmd:zmtick()} options
are unusual in that they apply not to axes on the plot region, but to the axis
that shows the scale of a {help clegend_option:contour legend}.  They
have effect only when the graph includes a {cmd:twoway contour} plot;
see {helpb twoway_contour:[G-2] graph twoway contour}.  In
all other respects, they act like the {cmd:x}{it:*}, {cmd:y}{it:*}, and
{cmd:t}{it:*} options.

{pstd}
For an example using {cmd:zlabel()}, see 
{it:{help twoway_contour##ccuts:Controlling the number of contours and their values}} in
{helpb twoway_contour:[G-2] graph twoway contour}.

{pstd}
The options associated with grids have no effect when specified on contour
axes.


{marker appendix}{...}
{title:Appendix:  Details of syntax}

{marker appendix1}{...}
    {title:Suboptions without rules, numlists, or labels}

{pstd}
What may appear in each of the options
{c -(}{cmd:y}|{cmd:x}{c )-}{c -(}{cmd:label}|{cmd:tick}|{cmd:mlabel}|{cmd:mtick}{c )-}{cmd:()}
is a rule or numlist followed by suboptions:

{p 8 16 2}
[{it:rule}]
[{it:numlist} [{cmd:"}{it:label}{cmd:"} [{it:numlist}
[{cmd:"}{it:label}{cmd:"} [...]]]]]
[{cmd:,} {it:suboptions}]

{pstd}
{it:rule}, {it:numlist}, and {it:label} are optional.  If you remove those,
you are left with

{p 8 16 2}
{cmd:,} {it:suboptions}

{pstd}
That is, the options
{c -(}{cmd:y}|{cmd:x}{c )-}{c -(}{cmd:label}|{cmd:tick}|{cmd:mlabel}|{cmd:mtick}{c )-}{cmd:()}
may be specified with just suboptions and, in fact, they are often specified
that way.  If you want default labeling of the {it:y} axis and {it:x} axis,
but you want grid lines in the {it:x} direction as well as the {it:y}, specify

{phang2}
	{cmd:. scatter} {it:yvar} {it:xvar}{cmd:, xlabel(,grid)}

{pstd}
When you do not specify the first part -- the {it:rule}, {it:numlist}, and
{it:label} -- you are saying that you do not want that part to change.  You
are saying that you merely wish to change how the {it:rule},
{it:numlist}, and {it:label} are displayed.

{pstd}
Of course, you may specify more than one suboption.  You might type

{phang2}
	{cmd:. scatter} {it:yvar xvar}{cmd:, xlabel(,grid format(%9.2f))}

{pstd}
if, in addition to grid lines, you wanted the numbers presented on the
{it:x} axis to be presented in a %9.2f format.


{marker appendix2}{...}
    {title:Rules}

{pstd}
What may appear in each of the axis-label options is a rule or numlist

{p 8 16 2}
[{it:rule}]
[{it:numlist} [{cmd:"}{it:label}{cmd:"} [{it:numlist}
[{cmd:"}{it:label}{cmd:"} [...]]]]]
[{cmd:,} {it:suboptions}]

{pstd}
where either {it:rule} or {it:numlist} must be specified and both may be
specified.  Let us ignore the {cmd:"}{it:label}{cmd:"} part right now.  Then
the above simplifies to

{p 8 16 2}
[{it:rule}]
[{it:numlist}]
[{cmd:,} {it:suboptions}]

{pstd}
where {it:rule} or {it:numlist} must be specified, both may be specified,
and most often you will simply specify the {it:rule}, which may be any of the
following:

	{it:rule}{col 18}Example{col 30}Description
	{hline 70}
	{cmd:#}{it:#}{...}
{col 18}{cmd:#6}{...}
{col 30}6 nice values
	{cmd:##}{it:#}{...}
{col 18}{cmd:##10}{...}
{col 30}10-1=9 values between major ticks;
{col 30}  allowed with {cmd:mlabel()} and {cmd:mtick()} only
	{it:#}{cmd:(}{it:#}{cmd:)}{it:#}{...}
{col 18}{cmd:-4(.5)3}{...}
{col 30}specified range: -4 to 3 in steps of .5
	{cmd:minmax}{...}
{col 18}{cmd:minmax}{...}
{col 30}minimum and maximum values
	{cmd:none}{...}
{col 18}{cmd:none}{...}
{col 30}label no values
	{cmd:.}{...}
{col 18}{cmd:.}{...}
{col 30}skip the rule
	{hline 70}

{pstd}
The most commonly specified rules are {cmd:#}{it:#} and {cmd:##}{it:#}.

{pstd}
Specifying {cmd:#}{it:#} says to choose {it:#} nice values.
Specifying {cmd:#5} says to choose five nice values, {cmd:#6} means to choose
six, and so on.  If you specify {cmd:ylabel(#5)}, then five values
will be labeled (on the {it:y} axis).  If you also specify {cmd:ymtick(#10)},
then 10 minor ticks will also be placed on the axis.  Actually,
{cmd:ylabel(#5)} and {cmd:ymtick(#10)} will result in approximately five labels
and 10 minor ticks because the choose-a-nice-number routine will change your
choice a little if, in its opinion, that would yield a nicer overall
result.  You may not agree with the routine about what is nice, and
then the {it:#}{cmd:(}{it:#}{cmd:)}{it:#} rule will let you
specify exactly what you want, assuming that you want evenly spaced
labels and numbers.

{pstd}
{cmd:##}{it:#} is allowed only with the
{c -(}{cmd:y}|{cmd:x}{c )-}{cmd:mlabel()}
and
{c -(}{cmd:y}|{cmd:x}{c )-}{cmd:mtick()} options -- the options that result
in minor ticks.  {cmd:##}{it:#} says to put {it:#}-1 minor ticks between the
major ticks.  {cmd:##5} would put four, and {cmd:##10} would put nine.
Here {it:#} is taken seriously, at least after subtraction, and you
are given exactly what you request.

{pstd}
{it:#}{cmd:(}{it:#}{cmd:)}{it:#} can be used with major or minor labels and
ticks.  This rule says to label the first number specified, increment by the
second number, and keep labeling, as long as the result is less than or equal
to the last number specified.  {cmd:ylabel(1(1)10)} would label (and tick) the
values 1, 2, ..., 10.  {cmd:ymtick(1(.5)10)} would put minor ticks at 1, 1.5,
2, 2.5, ..., 10.  It would be perfectly okay to specify both of those options.
When specifying rules, minor ticks and labels will check what is specified for
major ticks and labels and remove the intersection so as not to overprint.
The results will be the same as if you specified {cmd:ymtick(1.5(1)9.5)}.

{pstd}
The rule {cmd:minmax} specifies that you want the minimum and maximum.
{cmd:ylabel(minmax)} would label only the minimum and maximum.

{pstd}
Rule {cmd:none} means precisely that:  the rule that results in no labels
and no ticks.

{pstd}
Rule {cmd:.} makes sense only when {cmd:add} is specified, although it is
allowed at other times, and then {cmd:.} means the same as {cmd:none}.


{marker appendix3}{...}
    {title:Rules and numlists}

{pstd}
After the {it:rule} -- or instead of it -- you can specify a
{it:numlist}.  A numlist is a list of numbers, for instance,
"{cmd:1 2 5 7}" (without the quotes) or "{cmd:3/9}" (without the quotes).
Other shorthands are allowed (see {manhelp numlist U:11.1.8 numlist}), and in
fact, one of {it:numlist}'s syntaxes looks just like a {it:rule}:
{it:#}{cmd:(}{it:#}{cmd:)}{it:#}.  It has the same meaning, too.

{pstd}
There is, however, a subtle distinction between, for example,

	{cmd:ylabel(1(1)10)}                          (a {it:rule})
    and
	{cmd:ylabel(none 1(1)10)}                     (a {it:numlist})

{pstd}
{it:Rules} are more efficient.
Visually, however, there is no difference.

{pstd}
Use numlists when the values you wish to label or to tick are unequally
spaced,

	{cmd:ylabel(none 1 2 5 7)}

{pstd}
or when there is one or more extra values you want to label or to tick:

	{cmd:ylabel(1(1)10 3.5 7.5)}


{marker appendix4}{...}
    {title:Rules and numlists and labels}

{pstd}
{it:Numlists} serve an additional  purpose -- you can specify text that
is to be substituted for the value to be labeled.  For instance,

	{cmd:ylabel(1(1)10 3.5 "Low" 7.5 "Hi")}

{pstd}
says to label 1, 2, ..., 10 (that is the {it:rule} part) and
to label the special values 3.5 and 7.5.  Rather than actually printing
"3.5" and "7.5" next to the ticks at 3.5 and 7.5, however, {cmd:graph}
will instead print the words "Low" and "Hi".


{marker appendix5}{...}
    {title:Interpretation of repeated options}

{pstd}
Each of the axis-label options may be specified more than once in the same
command.  If you do that and you do not specify suboption {cmd:add}, the
rightmost of each is honored.  If you specify suboption {cmd:add}, then the
option just specified and the previous options are merged.  {cmd:add}
specifies that any new ticks or labels are added to any existing ticks or
labels on the axis.  All suboptions are {it:rightmost}; see 
{manhelp repeated_options G-4:Concept: repeated options}.
{p_end}
