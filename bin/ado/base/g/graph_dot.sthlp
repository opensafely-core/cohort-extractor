{smcl}
{* *! version 1.1.13  16apr2019}{...}
{viewerdialog "graph dot" "dialog graph_dot"}{...}
{vieweralsosee "[G-2] graph dot" "mansection G-2 graphdot"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph bar" "help graph_bar"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] collapse" "help collapse"}{...}
{viewerjumpto "Syntax" "graph_dot##syntax"}{...}
{viewerjumpto "Menu" "graph_dot##menu"}{...}
{viewerjumpto "Description" "graph_dot##description"}{...}
{viewerjumpto "Links to PDF documentation" "graph_dot##linkspdf"}{...}
{viewerjumpto "group_options" "graph_dot##group_options_desc"}{...}
{viewerjumpto "yvar_options" "graph_dot##yvar_options_desc"}{...}
{viewerjumpto "linelook_options" "graph_dot##linelook_options_desc"}{...}
{viewerjumpto "legending_options" "graph_dot##legending_options_desc"}{...}
{viewerjumpto "axis_options" "graph_dot##axis_options_desc"}{...}
{viewerjumpto "title_and_other_options" "graph_dot##title_and_other_options_desc"}{...}
{viewerjumpto "Suboptions for use with over() and yvaroptions()" "graph_dot##suboptions_desc"}{...}
{viewerjumpto "Remarks" "graph_dot##remarks"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[G-2] graph dot} {hline 2}}Dot charts (summary statistics){p_end}
{p2col:}({mansection G-2 graphdot:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 23 2}
{cmdab:gr:aph} {cmd:dot}{space 2}{it:yvars}
{ifin}
[{it:{help graph dot##weight:weight}}]
[{cmd:,}
{it:options}]

    where {it:yvars} is
	{col 20}{cmd:(asis)} {varlist}

    or is
{col 20}{cmd:(percent)} [{varlist}] | {cmd:(count)} [{varlist}]

    or is
{col 20}[{cmd:(}{it:stat}{cmd:)}] {varname}{...}
	       [[{cmd:(}{it:stat}{cmd:)}] ...]
{...}
{col 20}[{cmd:(}{it:stat}{cmd:)}] {varlist}{...}
	       [[{cmd:(}{it:stat}{cmd:)}] ...]
{...}
{col 20}[{cmd:(}{it:stat}{cmd:)}] [{it:name}{cmd:=}]{varname} [...]{...}
  [[{cmd:(}{it:stat}{cmd:)}] ...]

    where {it:stat} may be any of

{p 20 20 2}
	{cmd:mean}
	{cmd:median}
	{cmd:p1}
	{cmd:p2}
	... {cmd:p99}
	{cmd:sum}
	{cmd:count}
	{cmd:percent}
	{cmd:min}
	{cmd:max}
{p_end}

    or
{p 20 20 2}
    any of the other {it:stats} defined in {manhelp collapse D}

{pstd}
{it:yvars} is optional if the option {opt over(varname)} is specified.
{cmd:percent} is the default statistic, and percentages are calculated
over {it:varname}.

{pstd}
    {cmd:mean} is the default when {it:varname} or {it:varlist} is specified
    and {it:stat} is not specified.  {cmd:p1} means the first percentile,
    {cmd:p2} means the second percentile, and so on; {cmd:p50} means the same
    as {cmd:median}.  {cmd:count} means the number of nonmissing values of the
    specified variable.


{synoptset 30}{...}
{p2col:{it:options}}Description{p_end}
{p2line}
{p2col:{help graph dot##group_options:{it:group_options}}}groups over which
       lines of dots are drawn{p_end}
{p2col:{help graph dot##yvar_options:{it:yvar_options}}}variables that are the
       dots{p_end}
{p2col:{help graph dot##linelook_options:{it:linelook_options}}}how the lines
       of dots look{p_end}
{p2col:{help graph dot##legending_options:{it:legending_options}}}how
       {it:yvars} are labeled{p_end}
{p2col:{help graph dot##axis_options:{it:axis_options}}}how numerical
       {it:y} axis is labeled{p_end}
{p2col:{help graph dot##title_and_other_options:{it:title_and_other_options}}}titles, added text, aspect ratio, etc.{p_end}
{p2line}


{marker group_options}{...}
{p2col:{it:group_options}}Description{p_end}
{p2line}
{p2col:{cmdab:o:ver:(}{varname}[{cmd:,} {help graph dot##over_subopts:{it:over_subopts}}]{cmd:)}}categories; option may be repeated{p_end}
{p2col:{cmd:nofill}}omit empty categories{p_end}
{p2col:{cmdab:miss:ing}}keep missing value as category{p_end}
{p2col:{cmdab:allc:ategories}}include all categories in the dataset{p_end}
{p2line}


{marker yvar_options}{...}
{p2col:{it:yvar_options}}Description{p_end}
{p2line}
{p2col:{cmdab:asc:ategory}}treat {it:yvars} as first {cmd:over()} group{p_end}
{p2col:{cmdab:asy:vars}}treat first {cmd:over()} group as {it:yvars}{p_end}
{p2col:{cmdab:per:centages}}show percentages within {it:yvars}{p_end}
{p2col:{cmdab:cw}}calculate {it:yvar} statistics omitting missing values of
          any {it:yvar}{p_end}
{p2line}


{marker linelook_options}{...}
{p2col:{it:linelook_options}}Description{p_end}
{p2line}
{p2col:{cmd:outergap(}[{cmd:*}]{it:#}{cmd:)}}gap between top and first line
        and between last line and bottom{p_end}
{p2col:{cmd:linegap(}{it:#}{cmd:)}}gap between {it:yvar} lines; default
         is 0{p_end}

{p2col:{cmdab:m:arker:(}{it:#}{cmd:,} {it:{help marker_options}}{cmd:)}}marker
         used for #th {it:yvar} line{p_end}
{p2col:{cmdab:pcyc:le:(}{it:#}{cmd:)}}marker styles before
         {help pstyle:pstyles} recycle{p_end}

{p2col:{cmdab:linet:ype:(dot}|{cmd:line}|{cmd:rectangle)}}type of line{p_end}
{p2col:{cmdab:ndot:s:(}{it:#}{cmd:)}}# of dots if {cmd:linetype(dot)};
        default is 100{p_end}
{p2col:{cmdab:dot:s:(}{it:{help marker_options}}{cmd:)}}look if
        {cmd:linetype(dot)}{p_end}
{p2col:{cmdab:line:s:(}{it:{help line_options}}{cmd:)}}look if
        {cmd:linetype(line)}{p_end}
{p2col:{cmdab:rect:angles:(}{it:{help area_options}}{cmd:)}}look if
        {cmd:linetype(rectangle)}{p_end}
{p2col:{cmd:rwidth(}{it:{help size}}{cmd:)}}rectangle width if
        {cmd:linetype(rectangle)}{p_end}

{p2col:[{cmdab:no:}]{cmdab:ext:end:line}}whether line extends through plot
        region margins; {cmd:extendline} is usual default{p_end}
{p2col:{cmdab:lowex:tension(}{it:{help size}}{cmd:)}}extend line
        through axis (advanced){p_end}
{p2col:{cmdab:highex:tension(}{it:{help size}}{cmd:)}}extend line
        through axis (advanced){p_end}
{p2line}


{marker legending_options}{...}
{p2col:{it:legending_options}}Description{p_end}
{p2line}
{p2col:{it:{help legend_options}}}control of {it:yvar} legend{p_end}
{p2col:{cmdab:nolab:el}}use {it:yvar} names, not labels, in legend{p_end}
{p2col:{cmdab:yvar:options:(}{help graph dot##over_subopts:{it:over_subopts}}{cmd:)}}{it:over_subopts} for {it:yvars}; seldom specified{p_end}
{p2col:{cmd:showyvars}}label {it:yvars} on {it:x} axis; seldom specified{p_end}
{p2line}


{marker axis_options}{...}
{p2col:{it:axis_options}}Description{p_end}
{p2line}
{p2col:{cmdab:yalt:ernate}}put numerical {it:y} axis on right (top){p_end}
{p2col:{cmdab:xalt:ernate}}put categorical {it:x} axis on top (right){p_end}
{p2col:{cmd:exclude0}}do not force {it:y} axis to include 0{p_end}
{p2col:{cmdab:yrev:erse}}reverse {it:y} axis{p_end}
{p2col:{it:{help axis_scale_options}}}{it:y}-axis scaling and look{p_end}
{p2col:{it:{help axis_label_options}}}{it:y}-axis labeling{p_end}
{p2col:{help axis_title_options:{bf:ytitle(...)}}}{it:y}-axis titling{p_end}
{p2line}


{marker title_and_other_options}{...}
{p2col:{it:title_and_other_options}}Description{p_end}
{p2line}
{p2col:{help added_text_option:{bf:text(...)}}}add text on graph; {it:x} range
         [0,100]{p_end}
{p2col:{help added_line_options:{bf:yline(...)}}}add {it:y} lines to graph
       {p_end}
{p2col:{it:{help aspect_option}}}constrain aspect ratio of plot region{p_end}
{p2col:{it:{help std_options}}}titles, graph size, saving to disk{p_end}

{p2col:{help by_option:{bf:by(}{it:varlist}{bf:, ...)}}}repeat for subgroups
       {p_end}
{p2line}


{pstd}{marker over_subopts}
The {it:over_subopts} -- used in
{cmd:over(}{varname}{cmd:,} {it:over_subopts}{cmd:)}
and, on rare occasion, in
{cmd:yvaroptions(}{it:over_subopts}{cmd:)} -- are

{p2col:{it:over_subopts}}Description{p_end}
{p2line}
{p2col:{cmdab:re:label:(}{it:#} {cmd:"}{it:text}{cmd:"} ...{cmd:)}}change axis 
        labels{p_end}
{p2col:{cmdab:lab:el:(}{it:{help cat_axis_label_options}}{cmd:)}}rendition of
        labels{p_end}
{p2col:{cmdab:ax:is:(}{it:{help cat_axis_line_options}}{cmd:)}}rendition of
        axis line{p_end}

{p2col:{cmd:gap(}[{cmd:*}]{it:#}{cmd:)}}gap between lines within {cmd:over()}
        category{p_end}
{p2col:{cmd:sort(}{varname}{cmd:)}}put lines in prespecified order{p_end}
{p2col:{cmd:sort(}{it:#}{cmd:)}}put lines in height order{p_end}
{p2col:{cmd:sort((}{it:stat}{cmd:)} {varname}{cmd:)}}put lines in derived
        order{p_end}
{p2col:{cmdab:des:cending}}reverse default or specified line order{p_end}
{p2line}

{marker weight}{...}
{pstd}
{cmd:aweight}s, {cmd:fweight}s, and {cmd:pweight}s are
allowed; see {help weight} and see note concerning weights in
{manhelp collapse D}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Dot chart}


{marker description}{...}
{title:Description}

{pstd}
{cmd:graph} {cmd:dot} draws horizontal dot charts.  In a dot
chart, the categorical axis is presented vertically, and the numerical axis
is presented horizontally.  Even so, the numerical axis is called the {it:y}
axis, and the categorical axis is still called the {it:x} axis:

{phang2}
	{cmd:. graph dot (mean)} {it:numeric_var}{cmd:, over(}{it:cat_var}{cmd:)}

			  {it:x}
			  {c |}
	    first group   {c |}......o..............
			  {c |}
	    second group  {c |}..........o..........
		{bf:.}         {c |}
		{bf:.}         {c |}
			  {c BLC}{c TT}{hline 4}{c TT}{hline 4}{c TT}{hline 4}{c TT}{hline 4}{c TT}
			   0    2    4    6    8


{pstd}
The syntax for dot charts is identical to that for bar charts;
see {manhelp graph_bar G-2: graph bar}.

{pstd}
We use the following words to describe a dot chart:

			{it:x axis}
			  {c |}
		Group 1   {c |}..........o...............
		Group 2   {c |}..............o...........
		Group 3   {c |}..................o.......   <-  {it:lines}
		Group 4   {c |}......................o...
			  {c BLC}{c TT}{hline 4}{c TT}{hline 4}{c TT}{hline 4}{c TT}{hline 4}{c TT}{hline 4}{c TT}
			   0    1    2    3    4    5   <-  {it:y axis}

{pstd}
The above dot chart contains four {it:lines}.  The words used to describe a
line are
{p_end}
					  {it:marker}
					 /
			   .............o............
			   |{hline 2}{it:distance}{hline 2}|       \
						 {it:dots}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphdotQuickstart:Quick start}

        {mansection G-2 graphdotRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker group_options_desc}{...}
{title:group_options}

{phang}
{cmd:over(}{varname}[{cmd:,} {it:over_subopts}]{cmd:)}
    specifies a categorical variable over which the {it:yvars} are to be
    repeated.  {it:varname} may be string or numeric.  Up to two {cmd:over()}
    options may be specified when multiple {it:yvars} are specified, and up to
    three {cmd:over()}s may be specified when one {it:yvar} is specified;
    options may be specified; see
    {it:{help graph dot##remarks3:Appendix:  Examples of syntax}} below.

{phang}
{cmd:nofill}
    specifies that missing subcategories be omitted.  For instance,
    consider

{phang3}
	    {cmd:. graph dot (mean) y, over(division) over(region)}

{pmore}
    Say that one of the divisions has no data for one of the regions, either
    because there are no such observations or because y==. for such
    observations.  In the resulting chart, the marker will be missing:

		       division 1  {c |}...........o....
	    region 1   division 2  {c |}....o...........
		       division 3  {c |}.......o........
				   {c |}
		       division 1  {c |}..o.............
	    region 2   division 2  {c |}................
		       division 3  {c |}..........o.....
				   {c BLC}{c TT}{hline 4}{c TT}{hline 4}{c TT}{hline 4}{c TT}

{pmore}
    If you specify {cmd:nofill}, the missing category will be removed
    from the chart:

		       division 1  {c |}...........o....
	    region 1   division 2  {c |}....o...........
		       division 3  {c |}.......o........
				   {c |}
	    region 2   division 1  {c |}..o.............
		       division 3  {c |}..........o.....
				   {c BLC}{c TT}{hline 4}{c TT}{hline 4}{c TT}{hline 4}{c TT}

{phang}
{cmd:missing}
    specifies that missing values of the {cmd:over()} variables be kept as
    their own categories, one for {cmd:.}, another for {cmd:.a}, etc.  The
    default is to ignore such observations.  An {cmd:over()} variable is
    considered to be missing if it is numeric and contains a missing value or
    if it is string and contains "".


{phang}
{cmd:allcategories}
    specifies that all categories in the entire dataset be retained for the
    {cmd:over()} variables.  When {cmd:if} or {cmd:in} is specified without
    {cmd:allcategories}, the graph is drawn, completely excluding any
    categories for the {cmd:over()} variables that do not occur in the
    specified subsample.  With the {cmd:allcategories} option, categories that
    do not occur in the subsample still appear in the legend, but no markers
    are drawn where these categories would appear.  Such behavior can be
    convenient when comparing graphs of subsamples that do not include
    completely common categories for all {cmd:over()} variables.  This option
    has an effect only when {cmd:if} or {cmd:in} is specified or if there are
    missing values in the variables.  {cmd:allcategories} may not be combined
    with {cmd:by()}.


{marker yvar_options_desc}{...}
{title:yvar_options}

{phang}
{cmd:ascategory}
    specifies that the {it:yvars} be treated as the first {cmd:over()} group.

{pmore}
    When you specify {cmd:ascategory}, results are the same as if you
    specified one {it:yvar} and introduced a new first {cmd:over()}
    variable.  Anyplace you read in the documentation that something is
    done over the first {cmd:over()} category, or using the first
    {cmd:over()} category, it will be done over or using {it:yvars}.

{pmore}
    Suppose that you specified

{phang3}
	    {cmd:. graph dot y1 y2 y3, ascategory} {it:whatever_other_options}

{pmore}
    The results will be the same as if you typed

{phang3}
	    {cmd:. graph dot} {it:y}{cmd:, over(}{it:newcategoryvariable}{cmd:)} {it:whatever_other_options}

{pmore}
    with a long rather than wide dataset in memory.

{phang}
{cmd:asyvars}
    specifies that the first {cmd:over()} group be treated as {it:yvars}.

{pmore}
    When you specify {cmd:asyvars}, results are the same as if you removed
    the first {cmd:over()} group and introduced multiple {it:yvars}.  
    We said in most ways, not all ways, but let's ignore that for a
    moment.  If you previously had {it:k} {it:yvars} and, in your first
    {cmd:over()} category, {it:G} groups, results will be the same as if you
    specified {it:k}*{it:G} yvars and removed the {cmd:over()}.  Anyplace you
    read in the documentation that something is done over the {it:yvars} or
    using the {it:yvars}, it will be done over or using the first {cmd:over()}
    group.

{pmore}
    Suppose that you specified

{phang3}
	    {cmd:. graph dot y, over(group) asyvars} {it:whatever_other_options}

{pmore}
    Results will be the same as if you typed

{phang3}
	    {cmd:. graph dot} {it:y1 y2 y3} ...{cmd:,} {it:whatever_other_options}

{pmore}
    with a wide rather than long dataset in memory.
    Variables {it:y1}, {it:y2}, ..., are sometimes called the virtual
    {it:yvars}.

{phang}
{cmd:percentages}
    specifies that marker positions be based on percentages that
    {it:yvar}_{it:i} represents of all the {it:yvars}.  That is,

{phang3}
	    {cmd:. graph dot (mean) inc_male inc_female}

{pmore}
    would produce a chart with the markers reflecting average income.

{phang3}
	    {cmd:. graph dot (mean) inc_male inc_female, percentage}

{pmore}
    would produce a chart with the markers being located at
    100*inc_male/(inc_male+inc_female) and
    100*inc_female/(inc_male+inc_female).

{pmore}
    If you have one {it:yvar} and want percentages calculated over the
    first {cmd:over()} group, specify the {cmd:asyvars} option.  For instance,

{phang3}
	    {cmd:. graph dot (mean) wage, over(}{it:i}{cmd:) over(}{it:j}{cmd:)}

{pmore}
    would produce a chart where marker positions reflect mean wages.

{phang3}
	    {cmd:. graph dot (mean) wage, over(}{it:i}{cmd:) over(}{it:j}{cmd:) asyvars percentages}

{pmore}
   would produce a chart where marker positions are

	    100*( mean_ij / (Sum_i mean_ij) )

{phang}
{cmd:cw}
    specifies casewise deletion.  If {cmd:cw} is specified, observations for
    which any of the {it:yvars} are missing are ignored.  The default is
    to calculate each statistic by using all the data possible.


{marker linelook_options_desc}{...}
{title:linelook_options}

{phang}
{cmd:outergap(*}{it:#}{cmd:)} and
{cmd:outergap(}{it:#}{cmd:)}
    specify the gap between the top of the graph to the beginning of the first
    line and the last line to the bottom of the graph.

{pmore}
    {cmd:outergap(*}{it:#}{cmd:)} specifies that the default be modified.
    Specifying {cmd:outergap(*1.2)} increases the gap by 20%, and
    specifying {cmd:outergap(*.8)} reduces the gap by 20%.

{pmore}
    {cmd:outergap(}{it:#}{cmd:)} specifies the gap as a
    percentage-of-bar-width units.  {cmd:graph} {cmd:dot} is related to
    {cmd:graph} {cmd:bar}.  Just remember that {cmd:outergap(50)} specifies a
    sizable but not excessive gap.

{phang}
{cmd:linegap(}{it:#}{cmd:)}
    specifies the gap to be left between {it:yvar} lines.
    The default is {cmd:linegap(0)}, meaning that multiple {it:yvars} appear
    on the same line.  For instance, typing

	    {cmd:. graph dot y1 y2, over(group)}

{pmore}
    results in

		group 1  {c |}..x....o........
		group 2  {c |}........x..o....
		group 3  {c |}.......x.....o..
			 {c BLC}{c TT}{hline 4}{c TT}{hline 4}{c TT}{hline 4}{c TT}

{pmore}
    In the above, o represents the symbol for y1 and x the symbol for y2.
    If you want to have separate lines for the separate
    {it:yvars}, specify {cmd:linegap(20)}:

	    {cmd:. graph dot y1 y2, over(group) linegap(20)}

		group 1  {c |}.......o........
			 {c |}..x.............
			 {c |}
		group 2  {c |}...........o....
			 {c |}........x.......
			 {c |}
		group 3  {c |}.............o..
			 {c |}.......x........
			 {c BLC}{c TT}{hline 4}{c TT}{hline 4}{c TT}{hline 4}{c TT}

{pmore}
    Specify a number smaller or larger than 20 to reduce or increase the
    distance between the y1 and y2 lines.

{pmore}
    Alternatively, and generally preferred, is specifying option
    {cmd:ascategory}, which will result in

	    {cmd:. graph dot y1 y2, over(group) ascategory}

		group 1  y1  {c |}.......o........
			 y2  {c |}..o.............
			     {c |}
		group 2  y1  {c |}...........o....
			 y2  {c |}........o.......
			     {c |}
		group 3  y1  {c |}.............o..
			 y2  {c |}.......o........
			     {c BLC}{c TT}{hline 4}{c TT}{hline 4}{c TT}{hline 4}{c TT}


{pmore}
    {cmd:linegap()} affects only the {it:yvar} lines.  If you want
    to change the gap for the first, second, or third {cmd:over()}
    groups, specify the {it:over_subopt} {cmd:gap()} inside the
    {cmd:over()} itself.

{phang}
{cmd:marker(}{it:#}{cmd:,} {it:marker_options}{cmd:)}
    specifies the shape, size, color, etc., of the marker to be used to mark
    the value of the {it:#}th {it:yvar} variable.  {cmd:marker(1,} ...{cmd:)}
    refers to the marker associated with the first {it:yvar}, {cmd:marker(2,}
    ...{cmd:)} refers to the marker associated with the second, and so on.  A
    particularly useful {it:marker_option} is
    {cmd:mcolor(}{it:colorstyle}{cmd:)}, which sets the color and opacity of
    the marker.  For instance, you might specify {cmd:marker(1, mcolor(green))}
    to make the marker associated with the first {it:yvar} green.  See
    {manhelpi colorstyle G-4} for a list of color choices, and see 
    {manhelpi marker_options G-3} for information on the other
    {it:marker_options}.

{phang}
{cmd:pcycle(}{it:#}{cmd:)}
    specifies how many variables are to be plotted before the {help pstyle} of
    the markers for the next variable begins again at the pstyle of the
    first variable {c -} {cmd:p1dot} (with the markers for the variable
    following that using {cmd:p2dot} and so on).  Put another way, {it:#}
    specifies how quickly the look of markers is recycled when more than
    {it:#} variables are specified.  The default for most {help schemes}
    is {cmd:pcycle(15)}.

{phang}
{cmd:linetype(dot)},
{cmd:linetype(line)}, and
{cmd:linetype(rectangle)}
    specify the style of the line.

{pmore}
    {cmd:linetype(dot)} is the usual default.  In this style, dots are used
    to fill the line around the marker:
		       ........o........

{pmore}
    {cmd:linetype(line)} specifies that a solid line be used to fill the
    line around the marker:
		       {hline 8}o{hline 8}

{pmore}
    {cmd:linetype(rectangle)} specifies that a long "rectangle" (which looks
    more like two parallel lines) be used to fill the area around the marker:
		       ========o=======

{phang}
{cmd:ndots(}{it:#}{cmd:)} and
{cmd:dots(}{it:marker_options}{cmd:)}
    are relevant only in the {cmd:linetype(dots)} case.

{pmore}
    {cmd:ndots(}{it:#}{cmd:)} specifies the number of dots to be used to fill
    the line.  The default is {cmd:ndots(100)}.

{pmore}
    {cmd:dots(}{it:marker_options}{cmd:)} specifies the marker symbol, color,
    and size to be used as the dot symbol.  The default is to use
    {cmd:dots(msymbol(p))}.  See {manhelpi marker_options G-3}.

{phang}
{cmd:lines(}{it:line_options}{cmd:)}
    is relevant only if {cmd:linetype(line)} is specified.  It specifies the
    look of the line to be used; see {manhelpi line_options G-3}.

{phang}
{cmd:rectangles(}{it:area_options}{cmd:)} and
{cmd:rwidth(}{it:size}{cmd:)}
    are relevant only if {cmd:linetype(rectangle)} is specified.

{pmore}
    {cmd:rectangles(}{it:area_options}{cmd:)}
    specifies the look of the parallel lines (rectangle);
    see {manhelpi area_options G-3}.

{pmore}
    {cmd:rwidth(}{it:size}{cmd:)}
    specifies the width (height) of the rectangle (the distance between
    the parallel lines).  The default is usually {cmd:rwidth(.45)};
    see {manhelpi size G-4}.

{phang}
{cmd:noextendline} and {cmd:extendline}
    are relevant in all cases.  They specify whether the line (dots, a
    line, or a rectangle) is to extend through the plot region margin and 
    touch the axes.  The usual default is {cmd:extendline}, so
    {cmd:noextendline} is the option.  See {manhelpi region_options G-3} for
    a definition of the plot region.

{phang}
{cmd:lowextension(}{it:size}{cmd:)}
and
{cmd:highextension(}{it:size}{cmd:)}
    are advanced options that specify the amount by which the line (dots, line
    or a rectangle) is extended through the axes.  The usual defaults are
    {cmd:lowextension(0)} and {cmd:highextension(0)}.  See
    {manhelpi size G-4}.


{marker legending_options_desc}{...}
{title:legending_options}

{phang}
{it:legend_options}
    allows you to control the legend.  If more than one {it:yvar} is
    specified, a legend is produced.  Otherwise, no legend is needed because
    the {cmd:over()} groups are labeled on the categorical {it:x} axis.  See
    {manhelpi legend_options G-3}.

{phang}
{cmd:nolabel}
    specifies that, in automatically constructing the legend, the variable
    names of the {it:yvars} be used in preference to "mean of {varname}" or
    "sum of {it:varname}", etc.

{phang}
{cmd:yvaroptions(}{it:over_subopts}{cmd:)}
    allows you to specify {it:over_subopts} for the {it:yvars}.  This is
    seldom specified.

{phang}
{cmd:showyvars}
    specifies that, in addition to building a legend, the identities of the
    {it:yvars} be shown on the categorical {it:x} axis.  If {cmd:showyvars} is
    specified, it is typical to also specify {cmd:legend(off)}.


{marker axis_options_desc}{...}
{title:axis_options}

{phang}
{cmd:yalternate} and {cmd:xalternate}
    switch the side on which the axes appear.
    {cmd:yalternate} moves the numerical
    {it:y} axis from the bottom to the top; {cmd:xalternate} moves the
    categorical {it:x} axis from the left to the right.
    If your scheme by default puts the axes on the opposite sides,
    {cmd:yalternate} and {cmd:xalternate} reverse their actions.

{phang}
{cmd:exclude0}
    specifies that the numerical {it:y} axis need not be scaled to include 0.

{phang}
{cmd:yreverse}
    specifies that the numerical {it:y} axis have its scale reversed
    so that it runs from maximum to minimum.

{phang}
{it:axis_scale_options}
    specify how the numerical {it:y} axis is scaled and how it looks; see
    {manhelpi axis_scale_options G-3}.  There you will also see
    option {cmd:xscale()} in addition to {cmd:yscale()}.
    Ignore {cmd:xscale()}, which is irrelevant for dot plots.

{phang}
{it:axis_label_options}
    specify how the numerical {it:y} axis is to be labeled.
    The {it:axis_label_options} also allow you to add and suppress
    grid lines;
    see {manhelpi axis_label_options G-3}.
    There you will see that, in addition to options
    {cmd:ylabel()}, {cmd:ytick()}, {cmd:ymlabel()}, and {cmd:ymtick()},
    options {cmd:xlabel()}, ..., {cmd:xmtick()} are allowed.  Ignore the
    {cmd:x*()} options, which are irrelevant for dot charts.

{phang}
{cmd:ytitle()}
    overrides the default title for the numerical {it:y} axis; see 
    {manhelpi axis_title_options G-3}.  There you will also find option
    {cmd:xtitle()} documented, which is irrelevant for dot charts.


{marker title_and_other_options_desc}{...}
{title:title_and_other_options}

{phang}
{cmd:text()}
    adds text to a specified location on the graph; see 
    {manhelpi added_text_options G-3}.  The basic syntax of {cmd:text()} is

{phang3}
	    {cmd:text(}{it:#_y} {it:#_x} {cmd:"}{it:text}{cmd:")}

{pmore}
    {cmd:text()} is documented in terms of twoway graphs.  When used with
    dot charts, the "numeric" {it:x} axis is scaled to run from 0 to 100.

{phang}
{cmd:yline()}
    adds vertical lines at specified
    {it:y} values; see {manhelpi added_line_options G-3}.  The {cmd:xline()}
    option, also documented there, is irrelevant for dot charts.
    If your interest is in adding grid lines, see
    {manhelpi axis_label_options G-3}.

{phang}
{it:aspect_option}
    allows you to control the relationship between the height and width of
    a graph's plot region; see {manhelpi aspect_option G-3}.

{phang}
{it:std_options}
    allow you to add titles, control the graph size, save the graph on
    disk, and much more; see {manhelpi std_options G-3}.

{phang}
{cmd:by(}{varlist}{cmd:, ...)}
    draws separate plots within one graph; see {manhelpi by_option G-3}.


{marker suboptions_desc}{...}
{title:Suboptions for use with over() and yvaroptions()}

{phang}
{cmd:relabel(}{it:#} {cmd:"}{it:text}{cmd:"} ...{cmd:)}
    specifies text to override the default category labeling.
    See the description of the {helpb graph bar##relabel():relabel()} option
    in {manhelp graph_bar G-2:graph bar} for more information about this very
    useful option.

{phang}
{cmd:label(}{it:cat_axis_label_options}{cmd:)}
    determines other aspects of the look of the category labels on the {it:x}
    axis.  Except for {cmd:label(labcolor())} and
    {cmd:label(labsize())}, these options are seldom specified; see 
    {manhelpi cat_axis_label_options G-3}.

{phang}
{cmd:axis(}{it:cat_axis_line_options}{cmd:)}
    specifies how the axis line is rendered.  This is a seldom specified
    option.  See {manhelpi cat_axis_line_options G-3}.

{phang}
{cmd:gap(}{it:#}{cmd:)} and
{cmd:gap(*}{it:#}{cmd:)}
    specify the gap between the lines in this {cmd:over()} group.
    {cmd:gap(}{it:#}{cmd:)} is specified in percentage-of-bar-width units.
    Just remember that {cmd:gap(50)} is a considerable, but not excessive width.
    {cmd:gap(*}{it:#}{cmd:)} allows modifying the default gap.
    {cmd:gap(*1.2)} would increase the gap by 20%, and {cmd:gap(*.8)} would
    decrease the gap by 20%.

{phang}
{cmd:sort(}{varname}{cmd:)},
{cmd:sort(}{it:#}{cmd:)}, and
{cmd:sort((}{it:stat}{cmd:)} {it:varname}{cmd:)}
    control how the lines are ordered.
    See {it:{help graph bar##remarks10:How bars are ordered}} and
    {it:{help graph bar##remarks11:Reordering the bars}} in
    {manhelp graph_bar G-2:graph bar}.

{pmore}
    {cmd:sort(}{it:varname}{cmd:)} puts the lines in the order of {it:varname}.

{pmore}
    {cmd:sort(}{it:#}{cmd:)} puts the markers in distance order.
    {it:#} refers to the {it:yvar} number on which the ordering should be
    performed.

{pmore}
    {cmd:sort((}{it:stat}{cmd:)} {it:varname}{cmd:)}
    puts the lines in an order based on a calculated statistic.

{phang}
{cmd:descending}
    specifies that the order of the lines -- default or as specified
    by {cmd:sort()} -- be reversed.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help graph dot##remarks1:Relationship between dot plots and horizontal bar charts}
	{help graph dot##remarks2:Examples}
	{help graph dot##remarks3:Appendix:  Examples of syntax}


{marker remarks1}{...}
{title:Relationship between dot plots and horizontal bar charts}

{pstd}
Despite appearances, {cmd:graph} {cmd:hbar} and {cmd:graph} {cmd:dot} are in
fact the same command, meaning that concepts and options are the same:

	{cmd:. graph hbar y, over(group)}

			{c LT}{hline 3}{c TRC}
		group 1 {c |}   {c |}
			{c LT}{hline 3}{c BRC}
			{c |}
			{c LT}{hline 8}{c TRC}
		group 2 {c |}        {c |}
			{c LT}{hline 8}{c BRC}
			{c |}
			{c LT}{hline 14}{c TRC}
		group 3 {c |}              {c |}
			{c LT}{hline 14}{c BRC}
			{c |}
			{c BLC}{c TT}{hline 4}{c TT}{hline 4}{c TT}{hline 4}{c TT}

	{cmd:. graph dot y, over(group)}

		group 1 {c |}...o............
		group 2 {c |}........o.......
		group 3 {c |}..............o.
			{c BLC}{c TT}{hline 4}{c TT}{hline 4}{c TT}{hline 4}{c TT}

{pstd}
There is only one substantive difference between the two commands:  Given
multiple {it:yvars}, {cmd:graph} {cmd:hbar} draws multiple bars:

	{cmd:. graph hbar y1 y2, over(group)}

			{c LT}{c -}{c TRC}
			{c |} {c |}
		group 1 {c LT}{c -}{c BT}{c -}{c TRC}
			{c |}   {c |}
			{c LT}{hline 3}{c BRC}
			{c |}
			{c LT}{hline 3}{c TRC}
			{c |}   {c |}
		group 2 {c LT}{hline 3}{c BT}{hline 4}{c TRC}
			{c |}        {c |}
			{c LT}{hline 8}{c BRC}
			{c |}
			{c LT}{hline 5}{c TRC}
			{c |}     {c |}
		group 3 {c LT}{hline 5}{c BT}{hline 8}{c TRC}
			{c |}              {c |}
			{c LT}{hline 14}{c BRC}
			{c |}
			{c BLC}{c TT}{hline 4}{c TT}{hline 4}{c TT}{hline 4}{c TT}

{pstd}
{cmd:graph} {cmd:dot} draws multiple markers on single lines:

	{cmd:. graph dot y1 y2, over(group)}

		group 1 {c |}.x.o............
		group 2 {c |}...x....o.......
		group 3 {c |}.....x........o.
			{c BLC}{c TT}{hline 4}{c TT}{hline 4}{c TT}{hline 4}{c TT}

{pstd}
The way around this problem (if it is a problem) is to specify option
{cmd:ascategory} or to specify option {cmd:linegap(}{it:#}{cmd:)}.  Specifying
{cmd:ascategory} is usually best.

{pstd}
Read about {cmd:graph} {cmd:hbar} in {manhelp graph_bar G-2:graph bar}.


{marker remarks2}{...}
{title:Examples}

{pstd}
Because {cmd:graph} {cmd:dot} and {cmd:graph} {cmd:hbar} are so related,
the following examples should require little by way of explanation:

	{cmd}. sysuse nlsw88

	. graph dot wage, over(occ, sort(1))
		ytitle("")
		title("Average hourly wage, 1988, women aged 34-46", span)
		subtitle(" ")
		note("Source:  1988 data from NLS, U.S. Dept. of Labor,
		      Bureau of Labor Statistics", span){txt}
	  {it:({stata gr_example2 grdottall:click to run})}
{* graph grdottall}{...}

	{cmd}. graph dot (p10) wage (p90) wage,
		over(occ, sort(2))
		legend(label(1 "10th percentile") label(2 "90th percentile"))
		title("10th and 90th percentiles of hourly wage", span)
		subtitle("Women aged 34-46, 1988" " ", span)
		note("Source:  1988 data from NLS, U.S. Dept. of Labor,
		      Bureau of Labor Statistics", span){txt}
	  {it:({stata gr_example2 grdottall2:click to run})}
{* graph grdottall2}{...}

	{cmd}. graph dot (mean) wage,
		over(occ, sort(1))
		by(collgrad,
		     title("Average hourly wage, 1988, women aged 34-46", span)
		     subtitle(" ")
		     note("Source:  1988 data from NLS, U.S. Dept. of Labor,
			   Bureau of Labor Statistics", span)
		){txt}
	  {it:({stata gr_example2 grdotby:click to run})}
{* graph grdottall2}{...}


{marker remarks3}{...}
{title:Appendix:  Examples of syntax}

{pstd}
Let us consider some {cmd:graph} {cmd:dot} commands and what they do:

{p 4 8 8}
{cmd:graph dot revenue}{break}
    One line showing average revenue.

{p 4 8 8}
{cmd:graph dot revenue profit}{break}
    One line with two markers, one showing average revenue and the other
    average profit.

{p 4 8 8}
{cmd:graph dot revenue, over(division)}{break}
    {it:#_of_divisions} lines, each with one marker showing average revenue
    for each division.

{p 4 8 8}
{cmd:graph dot revenue profit, over(division)}{break}
    {it:#_of_divisions} lines, each with two markers, one
    showing average revenue and the other average
    profit for each division.

{p 4 8 8}
{cmd:graph dot revenue, over(division) over(year)}{break}
    {it:#_of_divisions}*{it:#_of_years} lines, each with one marker showing
    average revenue for each division, repeated for each of the years.  The
    grouping would look like this (assuming 3 divisions and 2 years):

		     division 1   {c |}....o...............
	    year 1   division 2   {c |}..........o.........
		     division 3   {c |}..............o.....
				  {c |}
		     division 1   {c |}.o..................
	    year 2   division 2   {c |}.......o............
		     division 3   {c |}................o...
				  {c BLC}{hline 4}{c TT}{hline 4}{c TT}{hline 4}{c TT}{hline 4}{c TT}

{p 4 8 8}
{cmd:graph dot revenue, over(year) over(division)}{break}
    Same as above, but ordered differently.  In the previous example, we
    typed {cmd:over(division)} {cmd:over(year)}.  This time, we reverse it:

	    division 1   year 1   {c |}....o...............
			 year 2   {c |}.o..................
				  {c |}
	    division 2   year 1   {c |}..........o.........
			 year 2   {c |}.......o............
				  {c |}
	    division 3   year 1   {c |}..............o.....
			 year 2   {c |}................o...
				  {c BLC}{hline 4}{c TT}{hline 4}{c TT}{hline 4}{c TT}{hline 4}{c TT}

{p 4 8 8}
{cmd:graph dot revenue profit, over(division) over(year)}{break}
    {it:#_of_divisions}*{it:#_of_years} lines each with two markers, one
    showing average revenue and the other showing average profit for each
    division, repeated for each of the years.

{p 4 8 8}
{cmd:graph dot (sum) revenue profit, over(division) over(year)}{break}
    {it:#_of_divisions}*{it:#_of_years} lines each with two markers, the first
    showing the sum of revenue and the second showing the sum of profit for
    each division, repeated for each of the years.

{p 4 8 8}
{cmd:graph dot (median) revenue profit, over(division) over(year)}{break}
    {it:#_of_divisions}*{it:#_of_years} lines each with two markers showing
    the median of revenue and median of profit for each division, repeated for
    each of the years.

{p 4 8 8}
{cmd:graph dot (median) revenue (mean) profit, over(division) over(year)}{break}
    {it:#_of_divisions}*{it:#_of_years} lines each with two markers showing
    the median of revenue and mean of profit for each division, repeated for
    each of the years.
{p_end}
