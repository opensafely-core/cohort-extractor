{smcl}
{* *! version 1.1.14  15may2018}{...}
{viewerdialog "graph box" "dialog graph_box"}{...}
{vieweralsosee "[G-2] graph box" "mansection G-2 graphbox"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph bar" "help graph_bar"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] lv" "help lv"}{...}
{vieweralsosee "[R] summarize" "help summarize"}{...}
{viewerjumpto "Syntax" "graph_box##syntax"}{...}
{viewerjumpto "Menu" "graph_box##menu"}{...}
{viewerjumpto "Description" "graph_box##description"}{...}
{viewerjumpto "Links to PDF documentation" "graph_box##linkspdf"}{...}
{viewerjumpto "group_options" "graph_box##group_options_desc"}{...}
{viewerjumpto "yvar_options" "graph_box##yvar_options_desc"}{...}
{viewerjumpto "boxlook_options" "graph_box##boxlook_options_desc"}{...}
{viewerjumpto "legending_options" "graph_box##legending_options_desc"}{...}
{viewerjumpto "axis_options" "graph_box##axis_options_desc"}{...}
{viewerjumpto "title_and_other_options" "graph_box##title_and_other_options_desc"}{...}
{viewerjumpto "Suboptions for use with over() and yvaroptions()" "graph_box##suboptions_desc"}{...}
{viewerjumpto "Remarks" "graph_box##remarks"}{...}
{viewerjumpto "Reference" "graph_box##reference"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[G-2] graph box} {hline 2}}Box plots{p_end}
{p2col:}({mansection G-2 graphbox:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 23 2}
{cmdab:gr:aph} {cmd:box}{space 2}{it:yvars}
{ifin}
[{it:{help graph box##weight:weight}}]
[{cmd:,}
{it:options}]

{p 8 23 2}
{cmdab:gr:aph} {cmd:hbox}
{it:yvars}
{ifin}
[{it:{help graph box##weight:weight}}]
[{cmd:,}
{it:options}]

{phang}
where {it:yvars} is a {varlist}

{synoptset 30}{...}
{p2col:{it:options}}Description{p_end}
{p2line}
{p2col:{help graph box##group_options:{it:group_options}}}groups over which
        boxes are drawn{p_end}
{p2col:{help graph box##yvar_options:{it:yvar_options}}}variables that are
         the boxes{p_end}
{p2col:{help graph box##boxlook_options:{it:boxlook_options}}}how the boxes
          look{p_end}
{p2col:{help graph box##legending_options:{it:legending_options}}}how
          variables are labeled{p_end}
{p2col:{help graph box##axis_options:{it:axis_options}}}how numerical
          {it:y} axis is labeled{p_end}
{p2col:{help graph box##title_and_other_options:{it:title_and_other_options}}}titles, added text, aspect ratio, etc.{p_end}
{p2line}


{marker group_options}{...}
{p2col:{it:group_options}}Description{p_end}
{p2line}
{p2col:{cmdab:o:ver:(}{varname}[{cmd:,} {help graph box##over_subopts:{it:over_subopts}}]{cmd:)}}categories; option may be repeated{p_end}
{p2col:{cmd:nofill}}omit empty categories{p_end}
{p2col:{cmdab:miss:ing}}keep missing value as category{p_end}
{p2col:{cmdab:allc:ategories}}include all categories in the dataset{p_end}
{p2line}


{marker yvar_options}{...}
{p2col:{it:yvar_options}}Description{p_end}
{p2line}
{p2col:{cmdab:asc:ategory}}treat {it:yvars} as first {cmd:over()} group{p_end}
{p2col:{cmdab:asy:vars}}treat first {cmd:over()} group as {it:yvars}{p_end}
{p2col:{cmdab:cw}}calculate variable statistics omitting missing values of
           any variable{p_end}
{p2line}


{marker boxlook_options}{...}
{p2col:{it:boxlook_options}}Description{p_end}
{p2line}
{p2col:{cmdab:noout:sides}}do not plot outside values{p_end}

{p2col:{cmd:box(}{it:#}{cmd:,} {it:{help barlook_options}}{cmd:)}}look of
          {it:#}th box{p_end}
{p2col:{cmdab:pcyc:le:(}{it:#}{cmd:)}}box styles before {help pstyle:pstyles}
         recycle{p_end}
{p2col:{cmdab:inten:sity:(}[{cmd:*}]{it:#}{cmd:)}}intensity of fill{p_end}
{p2col:{cmdab:linten:sity:(}[{cmd:*}]{it:#}{cmd:)}}intensity of outline{p_end}

{p2col:{cmdab:medt:ype:(line}|{cmd:cline}|{cmd:marker)}}how median is
        indicated in box{p_end}
{p2col:{cmdab:medl:ine:(}{it:{help line_options}}{cmd:)}}look of line if
          {cmd:medtype(cline)}{p_end}
{p2col:{cmdab:medm:arker:(}{it:{help marker_options}}{cmd:)}}look of marker if
          {cmd:medtype(marker)}{p_end}

{p2col:{cmdab:cwhi:skers}}use custom whiskers{p_end}
{p2col:{cmdab:line:s:(}{it:{help line_options}}{cmd:)}}look of custom
           whiskers{p_end}
{p2col:{cmdab:al:size(}{it:#}{cmd:)}}width of adjacent line; default is
           67{p_end}
{p2col:{cmdab:cap:size:(}{it:#}{cmd:)}}height of cap on adjacent line; default
           is 0{p_end}

{p2col:{cmdab:m:arker:(}{it:#}, {it:{help marker_options}}}look of {it:#}th
            marker and label for{p_end}
{p2col 13 39 39 2:{it:{help marker_label_options}}{cmd:)}}outside values{p_end}

{p2col:{cmd:outergap(}[{cmd:*}]{it:#}{cmd:)}}gap between edge and first box
        and between last box and edge{p_end}
{p2col:{cmd:boxgap(}{it:#}{cmd:)}}gap between boxes; default is 33{p_end}
{p2line}


{marker legending_options}{...}
{p2col:{it:legending_options}}Description{p_end}
{p2line}
{p2col:{it:{help legend_options}}}control of {it:yvar} legend{p_end}
{p2col:{cmdab:nolab:el}}use {it:yvar} names, not labels, in legend{p_end}
{p2col:{cmdab:yvar:options:(}{help graph box##over_subopts:{it:over_subopts}}{cmd:)}}{it:over_subopts} for {it:yvars}; seldom specified{p_end}
{p2col:{cmd:showyvars}}label {it:yvars} on {it:x} axis; seldom specified{p_end}
{p2line}


{marker axis_options}{...}
{p2col:{it:axis_options}}Description{p_end}
{p2line}
{p2col:{cmdab:yalt:ernate}}put numerical {it:y} axis on right (top){p_end}
{p2col:{cmdab:xalt:ernate}}put categorical {it:x} axis on top (right){p_end}
{p2col:{cmdab:yrev:erse}}reverse {it:y} axis{p_end}
{p2col:{it:{help axis_scale_options}}}{it:y}-axis scaling and look{p_end}
{p2col:{it:{help axis_label_options}}}{it:y}-axis labeling{p_end}
{p2col:{help axis_title_options:{bf:ytitle(...)}}}{it:y}-axis titling{p_end}
{p2line}


{marker title_and_other_options}{...}
{p2col:{it:title_and_other_options}}Description{p_end}
{p2line}
{p2col:{help added_text_option:{bf:text(...)}}}add text on graph; {it:x} range [0,100]{p_end}
{p2col:{help added_line_options:{bf:yline(...)}}}add {it:y} lines to graph{p_end}
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
{p2col:{cmdab:tot:al}}add total group{p_end}
{p2col:{cmdab:re:label:(}{it:#} {cmd:"}{it:text}{cmd:"} ...{cmd:)}}change axis
        labels{p_end}
{p2col:{cmdab:lab:el:(}{it:{help cat_axis_label_options}}{cmd:)}}rendition of
        labels{p_end}
{p2col:{cmdab:ax:is:(}{it:{help cat_axis_line_options}}{cmd:)}}rendition of
        axis line{p_end}

{p2col:{cmd:gap(}[{cmd:*}]{it:#}{cmd:)}}gap between boxes within {cmd:over()}
        category{p_end}
{p2col:{cmd:sort(}{varname}{cmd:)}}put boxes in prespecified order{p_end}
{p2col:{cmd:sort(}{it:#}{cmd:)}}put boxes in median order{p_end}
{p2col:{cmdab:des:cending}}reverse default or specified box order{p_end}
{p2line}

{marker weight}{...}
{pstd}
{cmd:aweight}s, {cmd:fweight}s, and {cmd:pweight}s are allowed;
see {help weight} and see note concerning weights in
{manhelp collapse D}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Box plot}


{marker description}{...}
{title:Description}

{pstd}
{cmd:graph} {cmd:box} draws vertical box plots.  In a vertical
box plot, the {it:y} axis is numerical, and the {it:x} axis is categorical.

	{cmd:. graph box} {it:y1 y2}{cmd:, over(}{it:cat_var}{cmd:)}

		  {it:y}
		8 {c RT}
		  {c |}          {c TT}            o
		  {c |}    o     {c |}            {c TT}         {it:y1}, {it:y2} must be numeric;
		6 {c RT}         {c TLC}{c BT}{c TRC}     {c TT}     {c |}         statistics are shown on
		  {c |}    {c TT}    {c |} {c |}    {c TLC}{c BT}{c TRC}   {c TLC}{c BT}{c TRC}        the {it:y }axis
		  {c |}   {c TLC}{c BT}{c TRC}   {c |}-{c |}    {c |}-{c |}   {c |} {c |}
		4 {c RT}   {c |}-{c |}   {c BLC}{c TT}{c BRC}    {c BLC}{c TT}{c BRC}   {c |}-{c |}        {it:cat_var} may be numeric
		  {c |}   {c BLC}{c TT}{c BRC}    {c |}      {c BT}    {c BLC}{c TT}{c BRC}        or string; it is shown
		  {c |}    {c BT}     {c BT}            {c |}         on categorical {it:x} axis
		2 {c RT}                 o     {c BT}
		  {c BLC}{hline 27} {it:x}
			first       second
			group        group

{pstd}
The encoding and the words used to describe the encoding are


				  o     <- outside values
				  o

	   {it:adjacent line}  {c -}{c -}{c TRC}     {c TT}     <- upper adjacent value
			    {c |}     {c |}
		  {it:whiskers}  {c |}     {c |}
			   {c -}{c RT}   {c TLC}{c -}{c BT}{c -}{c TRC}   <- 75th percentile (upper hinge)
			    {c |}   {c |}   {c |}
		     {it:box}    {c |}   {c LT}{hline 3}{c RT}   <- median
			    {c |}   {c |}   {c |}
			   {c -}{c RT}   {c BLC}{c -}{c TT}{c -}{c BRC}   <- 25th percentile (lower hinge)
		  {it:whiskers}  {c |}     {c |}
			    {c |}     {c |}
	   {it:adjacent line}  {c -}{c -}{c BRC}     {c BT}     <- lower adjacent value

				  o     <- outside value

{pstd}
{cmd:graph} {cmd:hbox} draws horizontal box plots.  In a horizontal box
plot, the numerical axis is still called the {it:y} axis, and the categorical
axis is still called the {it:x} axis, but {it:y} is presented horizontally,
and {it:x} vertically.

	{cmd:. graph hbox} {it:y1 y2}{cmd:, over(}{it:cat_var}{cmd:)}

		       {it:x}
		       {c |}     {c TLC}{hline 3}{c TRC}
		       {c |}  {c LT}{hline 2}{c RT} | {c LT}{hline 2}{c RT}  o
		first  {c |}     {c BLC}{hline 3}{c BRC}
		group  {c |}
		       {c |}        {c TLC}{hline 6}{c TRC}
		       {c |}  {c LT}{hline 5}{c RT} |    {c LT}{hline 5}{c RT}       same conceptual layout
		       {c |}        {c BLC}{hline 6}{c BRC}             as for {cmd:graph box}:
		       {c |}
		       {c |}                             {it:y1}, {it:y2} appear on {it:y} axis
		       {c |}       {c TLC}{hline 3}{c TRC}
		       {c |} o  {c LT}{hline 2}{c RT} | {c LT}{hline 2}{c RT}              {it:cat_var} appears on {it:x} axis
		second {c |}       {c BLC}{hline 3}{c BRC}
		group  {c |}
		       {c |}       {c TLC}{hline 6}{c TRC}
		       {c |} {c LT}{hline 5}{c RT} |    {c LT}{hline 5}{c RT}o
		       {c |}       {c BLC}{hline 6}{c BRC}
		       {c |}
		       {c BLC}{c TT}{hline 6}{c TT}{hline 6}{c TT}{hline 6}{c TT}{hline 4} {it:y}
			2      4      6      8


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphboxQuickstart:Quick start}

        {mansection G-2 graphboxRemarksandexamples:Remarks and examples}

        {mansection G-2 graphboxMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker group_options_desc}{...}
{title:group_options}

{phang}
{cmd:over(}{varname}[{cmd:,} {it:over_subopts}]{cmd:)}
    specifies a categorical variable over which the {it:yvars} are to be
    repeated.  {it:varname} may be string or numeric.  Up to two {cmd:over()}
    options may be specified when multiple {it:yvars} are specified,
    and up to three {cmd:over()}s may be specified when one {it:yvar} is
    specified; see {it:{help graph box##remarks2:Examples of syntax}} under
    {it:Remarks} below.

{phang}
{cmd:nofill}
    specifies that missing subcategories be omitted.  See the
    description of the {helpb graph bar##nofill:nofill} option in
    {manhelp graph_bar G-2:graph bar}.

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
    do not occur in the subsample still appear in the legend, and zero-height
    bars are drawn where these categories would appear.  Such behavior can be
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
    The important effect of this is to move the captioning of the variables
    from the legend to the categorical {it:x} axis.  See the description of
    {helpb graph bar##ascategory:ascategory} in
    {manhelp graph_bar G-2:graph bar}.

{phang}
{cmd:asyvars}
    specifies that the first {cmd:over()} group be treated as {it:yvars}.
    The important effect of this is to move the captioning of the first over
    group from the categorical {it:x} axis to the legend.  See the description
    of {helpb graph bar##asyvars:asyvars} in {manhelp graph_bar G-2:graph bar}.

{phang}
{cmd:cw}
    specifies casewise deletion.  If {cmd:cw} is specified, observations for
    which any of the {it:yvars} are missing are ignored.  The default is to
    calculate statistics for each box by using all the data possible.


{marker boxlook_options_desc}{...}
{title:boxlook_options}

{phang}
{cmd:nooutsides}
    specifies that the outside values not be plotted or used in setting the
    scale of the {it:y} axis.

{phang}
{cmd:box(}{it:#}{cmd:,} {it:barlook_options}{cmd:)}
    specifies the look of the {it:yvar} boxes.
    {cmd:box(1,} ...{cmd:)} refers to the box associated with the first
    {it:yvar}, {cmd:box(2,} ...{cmd:)} refers to the box associated with the
    second, and so on.

{pmore}
    You specify {it:barlook_options}.  Those options are
    borrowed from {cmd:graph} {cmd:bar} for boxes.
    The most useful {it:barlook_option} is
    {cmd:color(}{it:colorstyle}{cmd:)}, which sets the color and opacity of
    the box.  For instance, you might specify {cmd:box(1, color(green))} to
    make the box associated with the first {it:yvar} green.  See 
    {manhelpi colorstyle G-4} for a list of color choices and see 
    {manhelpi barlook_options G-3} for information on the other
    {it:barlook_options}.

{phang}
{cmd:pcycle(}{it:#}{cmd:)}
    specifies how many variables are to be plotted before the {help pstyle} of
    the boxes for the next variable begins again at the pstyle of the
    first variable -- {cmd:p1box} (with the boxes for the variable
    following that using {cmd:p2box} and so on).  Put another way: {it:#}
    specifies how quickly the look of boxes is recycled when more than {it:#}
    variables are specified.  The default for most {help schemes}
    is {cmd:pcycle(15)}.

{phang}
{cmd:intensity(}{it:#}{cmd:)}
and
{cmd:intensity(*}{it:#}{cmd:)}
    specify the intensity of the color used to fill the inside of the box.
    {cmd:intensity(}{it:#}{cmd:)} specifies the intensity, and
    {cmd:intensity(*}{it:#}{cmd:)} specifies the intensity relative to the
    default.

{pmore}
    By default, the box is filled with the color of its border, attenuated.
    Specify {cmd:intensity(*}{it:#}{cmd:)}, {it:#}<1, to attenuate it more and
    specify {cmd:intensity(*}{it:#}{cmd:)}, {it:#}>1, to amplify it.

{pmore}
    Specify {cmd:intensity(0)} if you do not want the box filled at all.
    If you are using a scheme that draws the median line in the background
    color such as {cmd:s2mono}, also specify option {cmd:medtype(line)}
    to change the median line to be in the color of the outline of the box.

{phang}
{cmd:lintensity(}{it:#}{cmd:)}
and
{cmd:lintensity(*}{it:#}{cmd:)}
    specify the intensity of the line used to outline the box.
    {cmd:lintensity(}{it:#}{cmd:)} specifies the intensity, and
    {cmd:lintensity(*}{it:#}{cmd:)} specifies the intensity relative to the
    default.

{pmore}
    By default, the box is outlined at the same intensity at which it is
    filled or at an amplification of that, which depending on your chosen
    scheme; see {manhelp schemes G-4:Schemes intro}.  If you want the box
    outlined in the darkest possible way, specify {cmd:intensity(255)}.  If you 
    wish simply to amplify the outline, specify {cmd:intensity(*}{it:#}{cmd:)},
    {it:#}>1, and if you wish to attenuate the outline, specify
    {cmd:intensity(*}{it:#}{cmd:)}, {it:#}<1.

{phang}
{cmd:medtype()},
{cmd:medline()}, and
{cmd:medmarker()}
    specify how the median is to be indicated in the box.

{pmore}
     {cmd:medtype(line)} is the default.  A line is drawn across the box at
     the median.  Here options {cmd:medline()} and {cmd:medmarker()}
     are irrelevant.

{pmore}
     {cmd:medtype(cline)} specifies a custom line be drawn across the box at
     the median.  The default custom line is usually a different color.
     You can, however, specify option {cmd:medline(}{it:line_options}{cmd:)}
     to control exactly how the line is to look;
     see {manhelpi line_options G-3}.

{pmore}
     {cmd:medtype(marker)} specifies a marker be placed in the box at the
     median.  Here you may also specify option
     {cmd:medmarker(}{it:marker_options}{cmd:)} to specify the look of the
     marker; see {manhelpi marker_options G-3}.

{phang}
{cmd:cwhiskers},
{cmd:lines(}{it:line_options}{cmd:)},
{cmd:alsize(}{it:#}{cmd:)}, and
{cmd:capsize(}{it:#}{cmd:)}
    specify the look of the whiskers.

{pmore}
    {cmd:cwhiskers} specifies that custom whiskers are desired.  The
    default custom whiskers are usually dimmer, but you may specify
    option {cmd:lines(}{it:line_options}{cmd:)} to specify how the
    custom whiskers are to look; see {manhelpi line_options G-3}.

{pmore}
    {cmd:alsize(}{it:#}{cmd:)} and {cmd:capsize(}{it:#}{cmd:)} specify the
    width of the adjacent line and the height of the cap on the adjacent line.
    You may specify these options whether or not you specify
    {cmd:cwhiskers}.  {cmd:alsize()} and {cmd:capsize()} are specified in
    percentage-of-box-width units; the defaults are {cmd:alsize(67)} and
    {cmd:capsize(0)}.  Thus the adjacent lines extend two-thirds the width of
    a box and, by default, have no caps.  Caps refer to whether the whiskers
    look like

		this                 or this

		 {c TT}                     {c TLC}{c TT}{c TRC}
		 {c |}                      {c |}
		{c TLC}{c BT}{c TRC}                    {c TLC}{c BT}{c TRC}
		{c |}-{c |}                    {c |}-{c |}
		{c BLC}{c TT}{c BRC}                    {c BLC}{c TT}{c BRC}
		 {c |}                      {c |}
		 {c BT}                     {c BLC}{c BT}{c BRC}

{pmore}
    If you want caps, try {cmd:capsize(5)}.

{phang}
{cmd:marker(}{it:#}, {it:marker_options} {it:marker_label_options}{cmd:)}
    specifies the marker and label to be used to display the outside values.
    See {manhelpi marker_options G-3} and {manhelpi marker_label_options G-3}.

{phang}
{cmd:outergap(*}{it:#}{cmd:)} and
{cmd:outergap(}{it:#}{cmd:)}
    specify the gap between the edge of the graph to the beginning of the first
    box and the end of the last box to the edge of the graph.

{pmore}
    {cmd:outergap(*}{it:#}{cmd:)} specifies that the default be modified.
    Specifying {cmd:outergap(*1.2)} increases the gap by 20%, and
    specifying {cmd:outergap(*.8)} reduces the gap by 20%.

{pmore}
    {cmd:outergap(}{it:#}{cmd:)} specifies the gap as a
    percentage-of-box-width units.  {cmd:outergap(50)} specifies that the gap
    be half the box width.

{phang}
{cmd:boxgap(}{it:#}{cmd:)}
    specifies the gap to be left between {it:yvar} boxes as a
    percentage-of-box-width units.  The default is {cmd:boxgap(33)}.

{pmore}
    {cmd:boxgap()} affects only the {it:yvar} boxes.  If you want
    to change the gap for the first, second, or third {cmd:over()}
    group, specify the {it:over_subopt} {cmd:gap()} inside the
    {cmd:over()} itself; see
    {it:{help graph box##subopts_over:Suboptions for use with over() and yvaroptions()}} below.


{marker legending_options_desc}{...}
{title:legending_options}

{phang}
{it:legend_options}
    allows you to control the legend.
    If more than one {it:yvar} is specified, a legend is produced.
    Otherwise, no legend is needed because the {cmd:over()} groups are
    labeled on the categorical {it:x} axis.
    See {manhelpi legend_options G-3}, and see
    {it:{help graph box##remarks3:Treatment of multiple yvars versus treatment of over() groups}}
    under {it:Remarks} below.

{phang}
{cmd:nolabel}
    specifies that, in automatically constructing the legend, the variable
    names of the {it:yvars} be used in preference to their labels.

{phang}
{cmd:yvaroptions(}{it:over_subopts}{cmd:)}
    allows you to specify {it:over_subopts} for the {it:yvars}.  This is
    seldom done.

{phang}
{cmd:showyvars}
    specifies that, in addition to building a legend, the identities of the
    {it:yvars} be shown on the categorical {it:x} axis.  If
    {cmd:showyvars} is specified, it is typical to also specify
    {cmd:legend(off)}.


{marker axis_options_desc}{...}
{title:axis_options}

{phang}
{cmd:yalternate} and {cmd:xalternate}
    switch the side on which the axes appear.

{pmore}
    Used with {cmd:graph} {cmd:box}, {cmd:yalternate} moves the numerical
    {it:y} axis from the left to the right; {cmd:xalternate} moves the
    categorical {it:x} axis from the bottom to the top.

{pmore}
    Used with {cmd:graph} {cmd:hbox}, {cmd:yalternate} moves the numerical
    {it:y} axis from the bottom to the top; {cmd:xalternate} moves the
    categorical {it:x} axis from the left to the right.

{pmore}
    If your scheme by default puts the axes on the opposite sides, then
    {cmd:yalternate} and {cmd:xalternate} reverse their actions.

{phang}
{cmd:yreverse}
    specifies that the numerical {it:y} axis have its scale reversed
    so that it runs from maximum to minimum.

{phang}
{it:axis_scale_options}
    specify how the numerical {it:y} axis is scaled and how it looks; see
    {manhelpi axis_scale_options G-3}.  There you will also see
    option {cmd:xscale()} in addition to {cmd:yscale()}.
    Ignore {cmd:xscale()}, which is irrelevant for box plots.

{phang}
{it:axis_label_options}
    specify how the numerical {it:y} axis is to be labeled.
    The {it:axis_label_options} also allow you to add and suppress
    grid lines;
    see {manhelpi axis_label_options G-3}.
    There you will see that, in addition to options
    {cmd:ylabel()}, {cmd:ytick()}, ..., {cmd:ymtick()},
    options {cmd:xlabel()}, ..., {cmd:xmtick()} are allowed.  Ignore the
    {cmd:x*()} options, which are irrelevant for box plots.

{phang}
{cmd:ytitle()}
    overrides the default title for the numerical {it:y} axis; see 
    {manhelpi axis_title_options G-3}.  There you will also find option
    {cmd:xtitle()} documented, which is irrelevant for box plots.


{marker title_and_other_options_desc}{...}
{title:title_and_other_options}

{phang}
{cmd:text()}
    adds text to a specified location on the graph; see 
    {manhelpi added_text_option G-3}.  The basic syntax of {cmd:text()} is

	    {cmd:text(}{it:#_y} {it:#_x} {cmd:"}{it:text}{cmd:")}

{pmore}
    {cmd:text()} is documented in terms of twoway graphs.  When used with
    box plots, the "numeric" {it:x} axis is scaled to run from 0 to 100.

{phang}
{cmd:yline()}
    adds horizontal ({cmd:box}) or vertical ({cmd:hbox}) lines at specified
    {it:y} values; see {manhelpi added_line_options G-3}.  The {cmd:xline()}
    option, also documented there, is irrelevant for box plots.
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
    draws separate plots within one graph; see {manhelpi by_option G-3}
    and see {it:{help graph box##remarks8:Use with by()}} under {it:Remarks}
    below.


{marker suboptions_desc}{...}
{marker subopts_over}{...}
{title:Suboptions for use with over() and yvaroptions()}

{phang}
{cmd:total}
    specifies that, in addition to the unique values of
    {cmd:over(}{varname}{cmd:)}, a group be added reflecting all
    the observations.   When multiple {cmd:over()}s are specified,
    {cmd:total} may be specified in only one of them.

{phang}
{cmd:relabel(}{it:#} {cmd:"}{it:text}{cmd:"} ...{cmd:)}
    specifies text to override the default category labeling.
    See the description of the {cmd:relabel()} option in
    {manhelp graph_bar G-2:graph bar} for more information about this
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
    specify the gap between the boxes in this {cmd:over()} group.
    {cmd:gap(}{it:#}{cmd:)} is specified in percentage-of-box-width units, so
    {cmd:gap(67)} means two-thirds the width of a box.
    {cmd:gap(*}{it:#}{cmd:)} allows modifying the default gap.
    {cmd:gap(*1.2)} would increase the gap by 20%, and {cmd:gap(*.8)} would
    decrease the gap by 20%.

{pmore}
    To understand the distinction between
    {cmd:over(}...{cmd:,} {cmd:gap())} and option {cmd:boxgap()}, consider

{phang3}
	    {cmd:. graph box before after, boxgap(}...{cmd:) over(sex, gap(}...{cmd:))}

{pmore}
    {cmd:boxgap()} sets the distance between the before and after boxes.
    {cmd:over(,gap())} sets the distance between the boxes for males and
    females.  Similarly, in

	    {cmd:. graph box before after, boxgap(}...{cmd:)}
				      {cmd:over(sex,    gap(}...{cmd:))}
				      {cmd:over(agegrp, gap(}...{cmd:))}

{pmore}
    {cmd:over(sex, gap())} sets the gap between males and females, and
    {cmd:over(agegrp, gap())} sets the gap between age groups.

{phang}
{cmd:sort(}{varname}{cmd:)} and
{cmd:sort(}{it:#}{cmd:)}
    control how the boxes are ordered.  See
    {it:{help graph box##remarks4:How boxes are ordered}}
    and {it:{help graph box##remarks5:Reordering the boxes}} under {it:Remarks}
    below.

{pmore}
    {cmd:sort(}{it:varname}{cmd:)} puts the boxes in the order of {it:varname};
    see {it:{help graph box##remarks6:Putting the boxes in a prespecified order}}
    under {it:Remarks} below.

{pmore}
    {cmd:sort(}{it:#}{cmd:)} puts the boxes in order of their medians.
    {it:#} refers to the {it:yvar} number on which the ordering should be
    performed;
    see {it:{help graph box##remarks7:Putting the boxes in median order}} under
    {it:Remarks} below.

{phang}
{cmd:descending}
    specifies that the order of the boxes -- default or as specified
    by {cmd:sort()} -- be reversed.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help graph box##remarks1:Introduction}
	{help graph box##remarks2:Examples of syntax}
	{help graph box##remarks3:Treatment of multiple yvars versus treatment of over() groups}
	{help graph box##remarks4:How boxes are ordered}
	{help graph box##remarks5:Reordering the boxes}
	{help graph box##remarks6:Putting the boxes in a prespecified order}
	{help graph box##remarks7:Putting the boxes in median order}
	{help graph box##remarks8:Use with by()}
	{help graph box##video:Video example}
	{help graph box##remarks9:History}

{pstd}
Also see {manhelp graph_bar G-2:graph bar}.  Most of what is said there applies
equally well to box charts.


{marker remarks1}{...}
{title:Introduction}

{pstd}
{cmd:graph} {cmd:box} draws vertical box plots:

	{cmd}. sysuse bplong

	. graph box bp, over(when) over(sex)
		ytitle("Systolic blood pressure")
		title("Response to Treatment, by Sex")
		subtitle("(120 Preoperative Patients)" " ")
		note("Source:  Fictional Drug Trial, StataCorp, 2003"){txt}
	  {it:({stata "gr_example2 grbox1":click to run})}
{* graph grbox1}{...}

{pstd}
{cmd:graph} {cmd:hbox} draws horizontal box plots:

	{cmd}. sysuse nlsw88, clear

	. graph hbox wage, over(ind, sort(1)) nooutside
		ytitle("")
		title("Hourly wage, 1988, woman aged 34-46", span)
		subtitle(" ")
		note("Source:  1988 data from NLS, U.S. Dept of Labor,
		      Bureau of Labor Statistics", span){txt}
	  {it:({stata "gr_example2 grbox2":click to run})}
{* graph grbox2}{...}


{marker remarks2}{...}
{title:Examples of syntax}

{pstd}
Below we show you some {cmd:graph} {cmd:box} commands and tell you what each
would do:

{p 4 8 8}
{cmd:graph box bp}{break}
    One big box showing statistics on blood pressure.

{p 4 8 8}
{cmd:graph box bp_before bp_after}{break}
    Two boxes, one showing average blood pressure before, and the other, after.

{p 4 8 8}
{cmd:graph box bp, over(agegrp)}{break}
    {it:#_of_agegrp} boxes showing blood pressure for each age group.

{p 4 8 8}
{cmd:graph box bp_before bp_after, over(agegrp)}{break}
    2*{it:#_of_agegrp} boxes showing blood pressure, before and after,
    for each age group.
    The grouping would look like this (assuming three age groups):

	    {c |}
	    {c |}
	    {c |}   {c TT}           {c TT}           {c TT}
	    {c |}  {c TLC}{c BT}{c TRC}   {c TT}     {c TLC}{c BT}{c TRC}   {c TT}     {c TLC}{c BT}{c TRC}   {c TT}
	    {c |}  {c |}-{c |}  {c TLC}{c BT}{c TRC}    {c |}-{c |}  {c TLC}{c BT}{c TRC}    {c |}-{c |}  {c TLC}{c BT}{c TRC}
	    {c |}  {c BLC}{c TT}{c BRC}  {c |}-{c |}    {c BLC}{c TT}{c BRC}  {c |}-{c |}    {c BLC}{c TT}{c BRC}  {c |}-{c |}
	    {c |}   {c BT}   {c BLC}{c TT}{c BRC}     {c BT}   {c BLC}{c TT}{c BRC}     {c BT}   {c BLC}{c TT}{c BRC}
	    {c |}        {c BT}           {c BT}           {c BT}
	    {c BLC}{hline 36}
	       agegrp 1    agegrp 2    agegrp 3

{p 4 8 8}
{cmd:graph box bp, over(agegrp) over(sex)}{break}
    {it:#_of_agegrps}*{it:#_of_sexes} boxes showing blood pressure
    for each age group,  repeated for each sex.  The grouping would
    look like this:

	    {c |}
	    {c |}   {c TT}             {c TT}        {c TT}             {c TT}
	    {c |}  {c TLC}{c BT}{c TRC}     {c TT}     {c TLC}{c BT}{c TRC}      {c TLC}{c BT}{c TRC}     {c TT}     {c TLC}{c BT}{c TRC}
	    {c |}  {c |}-{c |}    {c TLC}{c BT}{c TRC}    {c |}-{c |}      {c |}-{c |}    {c TLC}{c BT}{c TRC}    {c |}-{c |}
	    {c |}  {c BLC}{c TT}{c BRC}    {c |}-{c |}    {c BLC}{c TT}{c BRC}      {c BLC}{c TT}{c BRC}    {c |}_{c |}    {c BLC}{c TT}{c BRC}
	    {c |}   {c BT}     {c BLC}{c TT}{c BRC}     {c BT}        {c BT}     {c BLC}{c TT}{c BRC}     {c BT}
	    {c |}          {c BT}                      {c BT}
	    {c BLC}{hline 43}
	      age_1  age_2  age_3    age_1  age_2  age_3
		     males                 females

{p 4 8 8}
{cmd:graph box bp, over(sex) over(agegrp)}{break}
    Same as above, but ordered differently.  In the previous example we
    typed {cmd:over(agegrp)} {cmd:over(sex)}.  This time, we reverse it:

	    {c |}
	    {c |}   {c TT}    {c TT}                        {c TT}    {c TT}
	    {c |}  {c TLC}{c BT}{c TRC}  {c TLC}{c BT}{c TRC}        {c TT}    {c TT}        {c TLC}{c BT}{c TRC}  {c TLC}{c BT}{c TRC}
	    {c |}  {c |}-{c |}  {c |}-{c |}       {c TLC}{c BT}{c TRC}  {c TLC}{c BT}{c TRC}       {c |}-{c |}  {c |}-{c |}
	    {c |}  {c BLC}{c TT}{c BRC}  {c BLC}{c TT}{c BRC}       {c |}-{c |}  {c |}-{c |}       {c BLC}{c TT}{c BRC}  {c BLC}{c TT}{c BRC}
	    {c |}   {c BT}    {c BT}        {c BLC}{c TT}{c BRC}  {c BLC}{c TT}{c BRC}        {c BT}    {c BT}
	    {c |}                  {c BT}    {c BT}
	    {c BLC}{hline 46}
	      male female    male female    male female
		 age_1          age_2          age_3

{p 4 8 8}
{cmd:graph box bp_before bp_after, over(agegrp) over(sex)}{break}
    2*{it:#_of_agegrps}*{it:#_of_sexes} boxes showing blood pressure,
    before and after, for each age group, repeated for each sex.  The grouping
    would look like this:

	    {c |}
	    {c |}   {c TT}                   {c TT}          {c TT}                   {c TT}
	    {c |}  {c TLC}{c BT}{c TRC}  {c TT}     {c TT}   {c TT}    {c TLC}{c BT}{c TRC}  {c TT}     {c TLC}{c BT}{c TRC}  {c TT}     {c TT}   {c TT}    {c TLC}{c BT}{c TRC}  {c TT}
	    {c |}  {c |}-{c |} {c TLC}{c BT}{c TRC}   {c TLC}{c BT}{c TRC} {c TLC}{c BT}{c TRC}   {c |}-{c |} {c TLC}{c BT}{c TRC}    {c |}-{c |} {c TLC}{c BT}{c TRC}   {c TLC}{c BT}{c TRC} {c TLC}{c BT}{c TRC}   {c |}-{c |} {c TLC}{c BT}{c TRC}
	    {c |}  {c BLC}{c TT}{c BRC} {c |}-{c |}   {c |}-{c |} {c |}-{c |}   {c BLC}{c TT}{c BRC} {c |}-{c |}    {c BLC}{c TT}{c BRC} {c |}-{c |}   {c |}-{c |} {c |}-{c |}   {c BLC}{c TT}{c BRC} {c |}-{c |}
	    {c |}   {c BT}  {c BLC}{c TT}{c BRC}   {c BLC}{c TT}{c BRC} {c BLC}{c TT}{c BRC}    {c BT}  {c BLC}{c TT}{c BRC}     {c BT}  {c BLC}{c TT}{c BRC}   {c BLC}{c TT}{c BRC} {c BLC}{c TT}{c BRC}    {c BT}  {c BLC}{c TT}{c BRC}
	    {c |}       {c BT}     {c BT}   {c BT}         {c BT}          {c BT}     {c BT}   {c BT}         {c BT}
	    {c BLC}{hline 62}
		age_1     age_2     age_3      age_1     age_2     age_3
			  males                         females


{marker remarks3}{...}
{title:Treatment of multiple yvars versus treatment of over() groups}

{pstd}
Consider two datasets containing the same data but organized differently.
The datasets contain blood pressure before and after an intervention.
In the first dataset, the data are organized the wide way; each patient
is an observation.  A few of the data are

	{txt}{c TLC}{hline 9}{c -}{hline 6}{c -}{hline 8}{c -}{hline 11}{c -}{hline 10}{c TRC}
	{c |} {res}patient    sex   agegrp   bp_before   bp_after {txt}{c |}
	{c LT}{hline 9}{c -}{hline 6}{c -}{hline 8}{c -}{hline 11}{c -}{hline 10}{c RT}
	{c |} {res}      1   Male    30-45         143        153 {txt}{c |}
	{c |} {res}      2   Male    30-45         163        170 {txt}{c |}
	{c |} {res}      3   Male    30-45         153        168 {txt}{c |}
	{c BLC}{hline 9}{c -}{hline 6}{c -}{hline 8}{c -}{hline 11}{c -}{hline 10}{c BRC}{txt}

{pstd}
In the second dataset, the data are organized the long way; each patient is
a pair of observations.  The corresponding observations in the second dataset
are

	{txt}{c TLC}{hline 9}{c -}{hline 6}{c -}{hline 8}{c -}{hline 8}{c -}{hline 5}{c TRC}
	{c |} {res}patient    sex   agegrp     when    bp {txt}{c |}
	{c LT}{hline 9}{c -}{hline 6}{c -}{hline 8}{c -}{hline 8}{c -}{hline 5}{c RT}
	{c |} {res}      1   Male    30-45   Before   143 {txt}{c |}
	{c |} {res}      1   Male    30-45    After   153 {txt}{c |}
	{c LT}{hline 9}{c -}{hline 6}{c -}{hline 8}{c -}{hline 8}{c -}{hline 5}{c RT}
	{c |} {res}      2   Male    30-45   Before   163 {txt}{c |}
	{c |} {res}      2   Male    30-45    After   170 {txt}{c |}
	{c LT}{hline 9}{c -}{hline 6}{c -}{hline 8}{c -}{hline 8}{c -}{hline 5}{c RT}
	{c |} {res}      3   Male    30-45   Before   153 {txt}{c |}
	{c |} {res}      3   Male    30-45    After   168 {txt}{c |}
	{c BLC}{hline 9}{c -}{hline 6}{c -}{hline 8}{c -}{hline 8}{c -}{hline 5}{c BRC}{txt}

{pstd}
Using the first dataset, we might type

	{cmd:. sysuse bpwide, clear}

	{cmd:. graph box bp_before bp_after, over(sex)}
	  {it:({stata "gr_example bpwide: graph box bp_before bp_after, over(sex)":click to run})}
{* graph boxwide}{...}

{pstd}
Using the second dataset, we could type

	{cmd:. sysuse bplong, clear}

	{cmd:. graph box bp, over(when) over(sex)}
	  {it:({stata "gr_example bplong: graph box bp, over(when) over(sex)":click to run})}
{* graph boxlong}{...}

{pstd}
The two graphs are virtually identical.  They differ in that

			       multiple {it:yvars}           {cmd:over()} groups
	{hline 61}
	boxes different colors      yes                        no
	boxes identified via ...   legend                  axis label
	{hline 61}

{pstd}
Option {cmd:ascategory} will cause multiple {it:yvars} to be presented as if
they were the first {cmd:over()} group, and option {cmd:asyvars} will cause
the first {cmd:over()} group to be presented as if they were multiple
{it:yvars}.  Thus

	{cmd:. graph box bp, over(when) over(sex) asyvars}

{pstd}
would produce the first chart and

{phang2}
	{cmd:. graph box bp_before bp_after, over(sex) ascategory}

{pstd}
would produce the second.


{marker remarks4}{...}
{title:How boxes are ordered}

{pstd}
The default is to place the boxes in the order of the {it:yvars} and to order
each {cmd:over(}{it:varname}{cmd:)} group according to the values of
{it:varname}.  Let us consider some examples:

{phang}
{cmd:graph box bp_before bp_after}{break}
    Boxes appear in the order specified, {cmd:bp_before} and {cmd:bp_after}.

{phang}
{cmd:graph box bp, over(when)}{break}
    Boxes are ordered according to the values of variable {cmd:when}.

{pmore}
    If variable {cmd:when} is a numeric, the lowest {cmd:when} number comes
    first, followed by the next lowest, and so on.  This is true even if
    variable {cmd:when} has a value label.  Say that {cmd:when}=1 has been
    labeled "Before" and {cmd:when}=2, labeled "After".  The boxes will be in
    the order Before followed by After.

{pmore}
    If variable {cmd:when} is a string, the boxes will be ordered by the sort
    order of the values of the variable (that is, alphabetically, but
    with capital letters placed before lowercase letters).  If variable
    {cmd:when} contains "Before" and "After", the boxes will be in the order
    After followed by Before.

{phang}
{cmd:graph box bp_before bp_after, over(sex)}{break}
    Boxes appear in the order specified, {cmd:bp_before} and {cmd:bp_after},
    and are repeated for each {cmd:sex}, which will be ordered as explained
    above.

{phang}
{cmd:graph box bp_before bp_after, over(sex) over(agegrp)}{break}
    Boxes appear in the order specified, {cmd:bp_before} and {cmd:bp_after},
    repeated for {cmd:sex} ordered on the values of variable {cmd:sex},
    repeated for {cmd:agegrp} ordered on the values of variable {cmd:agegrp}.


{marker remarks5}{...}
{title:Reordering the boxes}

{pstd}
There are two ways you may wish to reorder the boxes:

{phang2}
1.  You want to control the order in which the elements of each {cmd:over()}
    group appear.  String variable {cmd:when} might contain "After" and
    "Before", but you want the boxes to appear in the order Before and After.

{phang2}
2.  You wish to order the boxes according to their median values.
    You wish to draw the graph

{col 16}{cmd:. graph box wage, over(industry)}

{pmore2}
    and you want the industries ordered by {cmd:wage}.

{pstd}
We will consider each of these desires separately.


{marker remarks6}{...}
{title:Putting the boxes in a prespecified order}

{pstd}
You have drawn the graph

	{cmd:. graph box bp, over(when) over(sex)}

{pstd}
Variable {cmd:when} is a string containing "Before" and "After".  You wish the
boxes to be in that order.

{pstd}
To do that, you create a new numeric variable that orders the group as you
would like:

	{cmd:. generate order = 1 if when=="Before"}
	{cmd:. replace  order = 2 if when=="After"}

{pstd}
You may name the variable and create it however you wish, but be sure that
there is a one-to-one correspondence between the new variable and the
{cmd:over()} group's values.  You then specify the {cmd:over()}'s
{cmd:sort(}{it:varname}{cmd:)} option:

{phang2}
	{cmd:. graph box bp, over(when, sort(order)) over(sex)}


{pstd}
If you want to reverse the order, you may specify the {cmd:descending}
suboption:

{phang2}
	{cmd:. graph box bp, over(when, sort(order) descending) over(sex)}


{marker remarks7}{...}
{title:Putting the boxes in median order}

{pstd}
You have drawn the graph

	{cmd:. graph hbox wage, over(industry)}

{pstd}
and now wish to put the boxes in median order, lowest first.  You type

{phang2}
	{cmd:. graph hbox wage, over( industry, sort(1) )}

{pstd}
If you wanted the largest first, you would type

{phang2}
	{cmd:. graph hbox wage, over(industry, sort(1) descending)}

{pstd}
The {cmd:1} in {cmd:sort(1)} refers to the first (and here only)
{it:yvar}.  If you had multiple {it:yvars}, you might type

{phang2}
	{cmd:. graph hbox wage benefits, over( industry, sort(1) )}

{pstd}
and you would have a chart showing {cmd:wage} and {cmd:benefits} sorted on 
{cmd:wage}.  If you typed

{phang2}
	{cmd:. graph hbox wage benefits, over( industry, sort(2) )}

{pstd}
the graph would be sorted on {cmd:benefits}.


{marker remarks8}{...}
{title:Use with by()}

{pstd}
{cmd:graph} {cmd:box} and {cmd:graph} {cmd:hbox} may be used with {cmd:by()},
but in general, you will want to use {cmd:over()} in preference to {cmd:by()}.
Box charts are explicitly categorical and do an excellent job of presenting
summary statistics for multiple groups in one chart.

{pstd}
A good use of {cmd:by()}, however, is when the graph would otherwise
be long.  Consider the graph

	{cmd:. sysuse nlsw88, clear}

	{cmd:. graph hbox wage, over(ind) over(union)}

{pstd}
In the above graph, there are 12 industry categories and two union categories,
resulting in 24 separate boxes.  The graph, presented at normal size,
would be virtually unreadable.  One way around that problem would be to
make the graph longer than usual,

{phang2}
	{cmd:. graph hbox wage, over(ind) over(union) ysize(7)}

{pstd}
See {it:{help graph bar##remarks9:Charts with many categories}} in
{manhelp graph_bar G-2:graph bar} for more information about that solution.
The other solution would be to introduce union as a {cmd:by()} category rather
than an {cmd:over()} category:

	{cmd:. graph hbox wage, over(ind) by(union)}

{pstd}
Below we do precisely that, adding some extra options to produce a good-looking
chart:

	{cmd}. graph hbox wage, over(ind, sort(1)) nooutside
		ytitle("")
		by(
			union,
			title("Hourly wage, 1988, woman aged 34-46", span)
			subtitle(" ")
			note("Source:  1988 data from NLS, U.S. Dept. of Labor,
			      Bureau of Labor Statistics", span)
		){txt}
	  {it:({stata "gr_example2 grboxby":click to run})}
{* graph grboxby}{...}

{pstd}
The title options were specified inside the {cmd:by()} so that they would
not be applied to each graph separately; see {manhelpi by_option G-3}.


{marker video}{...}
{title:Video example}

{phang}
{browse "http://www.youtube.com/watch?v=y6dngL80xuo":Box plots in Stata}


{* index histories}{...}
{* index Crowe}{...}
{marker remarks9}{...}
{title:History}

{pstd}
Box plots have been used in geography and climatology, under the name
"dispersion diagrams", since at least 1933; see
{help graph box##C1933:Crowe (1933)}.  His figure 1
shows all the data points, medians, quartiles, and octiles by month for
monthly rainfalls for Glasgow, 1868-1917.  His figure 2, a map of Europe with
several climatic stations, shows monthly medians, quartiles, and octiles.


{marker reference}{...}
{title:Reference}

{marker C1933}{...}
{phang}
Crowe, P. R. 1933. The analysis of rainfall probability. A graphical method
and its application to European data. {it:Scottish Geographical Magazine}
49: 73-91.
{p_end}
