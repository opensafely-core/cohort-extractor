{smcl}
{* *! version 1.2.4  15may2018}{...}
{viewerdialog "graph bar" "dialog graph_bar"}{...}
{vieweralsosee "[G-2] graph bar" "mansection G-2 graphbar"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph dot" "help graph_dot"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] collapse" "help collapse"}{...}
{vieweralsosee "[R] table" "help table"}{...}
{viewerjumpto "Syntax" "graph_bar##syntax"}{...}
{viewerjumpto "Menu" "graph_bar##menu"}{...}
{viewerjumpto "Description" "graph_bar##description"}{...}
{viewerjumpto "Links to PDF documentation" "graph_bar##linkspdf"}{...}
{viewerjumpto "group_options" "graph_bar##group_options_desc"}{...}
{viewerjumpto "yvar_options" "graph_bar##yvar_options_desc"}{...}
{viewerjumpto "lookofbar_options" "graph_bar##lookofbar_options_desc"}{...}
{viewerjumpto "legending_options" "graph_bar##legending_options_desc"}{...}
{viewerjumpto "axis_options" "graph_bar##axis_options_desc"}{...}
{viewerjumpto "title_and_other_options" "graph_bar##title_and_other_options_desc"}{...}
{viewerjumpto "Suboptions for use with over() and yvaroptions()" "graph_bar##suboptions_desc"}{...}
{viewerjumpto "Remarks" "graph_bar##remarks"}{...}
{viewerjumpto "References" "graph_bar##references"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[G-2] graph bar} {hline 2}}Bar charts{p_end}
{p2col:}({mansection G-2 graphbar:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 23 2}
{cmdab:gr:aph} {cmd:bar}{space 2}{it:yvars}
{ifin}
[{it:{help graph bar##weight:weight}}]
[{cmd:,}
{it:options}]

{p 8 23 2}
{cmdab:gr:aph} {cmd:hbar}
{it:yvars}
{ifin}
[{it:{help graph bar##weight:weight}}]
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
{p2col:{help graph_bar##group_options:{it:group_options}}}groups over which
       bars are drawn{p_end}
{p2col:{help graph_bar##yvar_options:{it:yvar_options}}}variables that are
       the bars{p_end}
{p2col:{help graph_bar##lookofbar_options:{it:lookofbar_options}}}how the
        bars look{p_end}
{p2col:{help graph_bar##legending_options:{it:legending_options}}}how
        {it:yvars} are labeled{p_end}
{p2col:{help graph_bar##axis_options:{it:axis_options}}}how the numerical
        y axis is labeled{p_end}
{p2col:{help graph_bar##title_and_other_options:{it:title_and_other_options}}}titles, added text, aspect ratio, etc.{p_end}
{p2line}


{marker group_options}{...}
{p2col:{it:group_options}}Description{p_end}
{p2line}
{p2col:{cmdab:o:ver:(}{varname}[{cmd:,} {help graph bar##over_subopts:{it:over_subopts}}]{cmd:)}}categories; option may be repeated{p_end}
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
{p2col:{cmd:stack}}stack the {it:yvar} bars{p_end}
{p2col:{cmdab:cw}}calculate {it:yvar} statistics omitting missing values of any {it:yvar}{p_end}
{p2line}


{marker lookofbar_options}{...}
{p2col:{it:lookofbar_options}}Description{p_end}
{p2line}
{p2col:{cmd:outergap(}[{cmd:*}]{it:#}{cmd:)}}gap between edge and first bar
     and between last bar and edge{p_end}
{p2col:{cmd:bargap(}{it:#}{cmd:)}}gap between {it:yvar} bars; default
      is 0{p_end}
{p2col:{cmdab:inten:sity:(}[{cmd:*}]{it:#}{cmd:)}}intensity of fill{p_end}
{p2col:{cmdab:linten:sity:(}[{cmd:*}]{it:#}{cmd:)}}intensity of outline{p_end}
{p2col:{cmdab:pcyc:le:(}{it:#}{cmd:)}}bar styles before {help pstyle:pstyles}
       recycle{p_end}
{p2col:{cmd:bar(}{it:#}{cmd:,} {it:{help barlook_options}}{cmd:)}}look of
       {it:#}th {it:yvar} bar{p_end}
{p2line}


{marker legending_options}{...}
{p2col:{it:legending_options}}Description{p_end}
{p2line}
{p2col:{it:{help legend_options}}}control of {it:yvar} legend{p_end}
{p2col:{cmdab:nolab:el}}use {it:yvar} names, not labels, in legend{p_end}
{p2col:{cmdab:yvar:options:(}{help graph bar##over_subopts:{it:over_subopts}}{cmd:)}}{it:over_subopts} for {it:yvars}; seldom specified{p_end}
{p2col:{cmd:showyvars}}label {it:yvars} on x axis; seldom specified{p_end}
{p2col:{help blabel_option:{bf:{ul:blab}el(...)}}}add labels to bars{p_end}
{p2line}


{marker axis_options}{...}
{p2col:{it:axis_options}}Description{p_end}
{p2line}
{p2col:{cmdab:yalt:ernate}}put numerical y axis on right (top){p_end}
{p2col:{cmdab:xalt:ernate}}put categorical x axis on top (right){p_end}
{p2col:{cmd:exclude0}}do not force y axis to include 0{p_end}
{p2col:{cmdab:yrev:erse}}reverse y axis{p_end}
{p2col:{it:{help axis_scale_options}}}y-axis scaling and look{p_end}
{p2col:{it:{help axis_label_options}}}y-axis labeling{p_end}
{p2col:{help axis_title_options:{bf:{ul:yti}tle(...)}}}y-axis titling{p_end}
{p2line}


{marker title_and_other_options}{...}
{p2col:{it:title_and_other_options}}Description{p_end}
{p2line}
{p2col:{help added_text_option:{bf:text(...)}}}add text on graph;
         x range [0,100]{p_end}
{p2col:{help added_line_options:{bf:yline(...)}}}add y lines to
         graph{p_end}
{p2col:{it:{help aspect_option}}}constrain aspect ratio of plot region{p_end}
{p2col:{it:{help std_options}}}titles, graph size, saving to disk{p_end}

{p2col:{help by_option:{bf:by(}{it:varlist}{bf:, ...)}}}repeat for
             subgroups{p_end}
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

{p2col:{cmd:gap(}[{cmd:*}]{it:#}{cmd:)}}gap between bars within
        {cmd:over()} category{p_end}
{p2col:{cmd:sort(}{varname}{cmd:)}}put bars in prespecified order{p_end}
{p2col:{cmd:sort(}{it:#}{cmd:)}}put bars in height order{p_end}
{p2col:{cmd:sort((}{it:stat}{cmd:)} {varname}{cmd:)}}put bars in derived
        order{p_end}
{p2col:{cmdab:des:cending}}reverse default or specified bar order{p_end}
{p2col:{cmdab:rev:erse}}reverse scale to run from max to min{p_end}
{p2line}

{marker weight}{...}
{pstd}
{cmd:aweight}s, {cmd:fweight}s, and {cmd:pweight}s are
allowed; see {help weight} and see note concerning weights in
{manhelp collapse D}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Bar chart}


{marker description}{...}
{title:Description}

{pstd}
{cmd:graph} {cmd:bar} draws vertical bar charts.  In a vertical
bar chart, the y axis is numerical, and the x axis is categorical.

	{cmd:. graph bar (mean)} {it:numeric_var}{cmd:, over(}{it:cat_var}{cmd:)}

	      {it:y}
	      {c |}{...}
{col 47}{it:numeric_var} must be numeric;
	    7 {c RT}            {c TLC}{hline 2}{c TRC}{...}
{col 47}statistics of it are shown on
	      {c |}            {c |}  {c |}{...}
{col 47}the y axis.
	    5 {c RT}  {c TLC}{hline 2}{c TRC}      {c |}  {c |}
	      {c |}  {c |}  {c |}      {c |}  {c |}{...}
{col 47}{it:cat_var} may be numeric or string;
	      {c |}  {c |}  {c |}      {c |}  {c |}{...}
{col 47}it is shown on the categorical
	      {c |}  {c |}  {c |}      {c |}  {c |}{...}
{col 47}x axis.
	      {c BLC}{hline 2}{c BT}{hline 2}{c BT}{hline 6}{c BT}{hline 2}{c BT}{hline 9} {it:x}
		 first    second    {bf:...}
		 group     group

{pstd}
{cmd:graph} {cmd:hbar} draws horizontal bar charts.  In a horizontal bar
chart, the numerical axis is still called the y axis, and the categorical
axis is still called the x axis, but {it:y} is presented horizontally, and
{it:x} vertically.


	{cmd:. graph hbar (mean)} {it:numeric_var}{cmd:, over(}{it:cat_var}{cmd:)}

			  {it:x}
			  {c |}
			  {c LT}{hline 6}{c TRC}
	    first group   {c |}      {c |}
			  {c LT}{hline 6}{c BRC}{...}
{col 48}same conceptual layout:
			  {c |}{...}
{col 48}{it:numeric_var} still appears
			  {c LT}{hline 10}{c TRC}{...}
{col 48}on {it:y}, {it:cat_var} on {it:x}
	    second group  {c |}          {c |}
			  {c LT}{hline 10}{c BRC}
		{bf:.}         {c |}
		{bf:.}         {c |}
			  {c BLC}{hline 6}{c TT}{hline 3}{c TT}{hline 6} {it:y}
				 5   7

{pstd}
The syntax for vertical and horizontal bar charts is the same; all
that is required is changing {cmd:bar} to {cmd:hbar} or {cmd:hbar} to
{cmd:bar}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphbarQuickstart:Quick start}

        {mansection G-2 graphbarRemarksandexamples:Remarks and examples}

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
    {it:{help graph bar##remarks2:Examples of syntax}} and
    {it:{help graph bar##remarks7:Multiple over()s (repeating the bars)}}
    under {it:Remarks} below.

{marker nofill}{...}
{phang}
{cmd:nofill}
    specifies that missing subcategories be omitted.  For instance,
    consider

{phang3}
	    {cmd:. graph bar (mean) y, over(division) over(region)}

{pmore}
    Say that one of the divisions has no data for one of the regions, either
    because there are no such observations or because y==. for such
    observations.  In the resulting chart, the bar will be missing:

	     {c TLC}{c -}{c TRC}    {c TLC}{c -}{c TRC}    {c TLC}{c -}{c TRC}       {c TLC}{c -}{c TRC}           {c TLC}{c -}{c TRC}
	     {c |} {c |}    {c |} {c |}    {c |} {c |}       {c |} {c |}           {c |} {c |}
	     {c |} {c |}    {c |} {c |}    {c |} {c |}       {c |} {c |}           {c |} {c |}
	    {c -}{c BT}{c -}{c BT}{hline 4}{c BT}{c -}{c BT}{hline 4}{c BT}{c -}{c BT}{hline 7}{c BT}{c -}{c BT}{hline 11}{c BT}{c -}{c BT}{c -}
	    div_1  div_2  div_3     div_1  div_2  div_3
		  region_1               region_2

{pmore}
    If you specify {cmd:nofill}, the missing category will be removed
    from the chart:

	     {c TLC}{c -}{c TRC}    {c TLC}{c -}{c TRC}    {c TLC}{c -}{c TRC}       {c TLC}{c -}{c TRC}    {c TLC}{c -}{c TRC}
	     {c |} {c |}    {c |} {c |}    {c |} {c |}       {c |} {c |}    {c |} {c |}
	     {c |} {c |}    {c |} {c |}    {c |} {c |}       {c |} {c |}    {c |} {c |}
	    {c -}{c BT}{c -}{c BT}{hline 4}{c BT}{c -}{c BT}{hline 4}{c BT}{c -}{c BT}{hline 7}{c BT}{c -}{c BT}{hline 4}{c BT}{c -}{c BT}{c -}
	    div_1  div_2  div_3     div_1  div_3
		  region_1            region_2

{phang}
{cmd:missing}
    specifies that missing values of the {cmd:over()} variables be kept as
    their own categories, one for {cmd:.}, another for {cmd:.a}, etc.  The
    default is to act as if such observations simply did not appear in the
    dataset; the observations are ignored.  An {cmd:over()} variable is
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
    missing values in the variables.
    {cmd:allcategories} may not be combined with {cmd:by()}.


{marker yvar_options_desc}{...}
{title:yvar_options}

{marker ascategory}{...}
{phang}
{cmd:ascategory}
    specifies that the {it:yvars} be treated as the first {cmd:over()} group;
    see {it:{help graph bar##remarks3:Treatment of bars}} under {it:Remarks}
    below.  {cmd:ascategory} is a useful option.

{pmore}
    When you specify {cmd:ascategory}, results are the same as if you
    specified one {it:yvar} and introduced a new first {cmd:over()}
    variable.  Anyplace you read in the documentation that something is
    done over the first {cmd:over()} category, or using the first
    {cmd:over()} category, it will be done over or using {it:yvars}.

{pmore}
    Suppose that you specified

{phang3}
	    {cmd:. graph bar y1 y2 y3, ascategory} {it:whatever_other_options}

{pmore}
    The results will be the same as if you typed

{phang3}
	    {cmd:. graph bar} {it:y}{cmd:, over(}{it:newcategoryvariable}{cmd:)} {it:whatever_other_options}

{pmore}
    with a long rather than wide dataset in memory.

{marker asyvars}{...}
{phang}
{cmd:asyvars}
    specifies that the first {cmd:over()} group be treated as {it:yvars}.
    See {it:{help graph bar##remarks3:Treatment of bars}} under {it:Remarks}
    below.

{pmore}
    When you specify {cmd:asyvars}, results are the same as if you removed
    the first {cmd:over()} group and introduced multiple {it:yvars}.
    If you previously had {it:k} {it:yvars} and, in your first
    {cmd:over()} category, {it:G} groups, results will be the same as if you
    specified {it:k}*{it:G} yvars and removed the {cmd:over()}.  Anyplace you
    read in the documentation that something is done over the {it:yvars} or
    using the {it:yvars}, it will be done over or using the first {cmd:over()}
    group.

{pmore}
    Suppose that you specified

{phang3}
	    {cmd:. graph bar y, over(group) asyvars} {it:whatever_other_options}

{pmore}
    Results will be the same as if you typed

{phang3}
	    {cmd:. graph bar} {it:y1 y2 y3} ...{cmd:,} {it:whatever_other_options}

{pmore}
    with a wide rather than long dataset in memory.
    Variables {it:y1}, {it:y2}, ..., are sometimes called the virtual
    {it:yvars}.

{phang}
{cmd:percentages}
    specifies that bar heights be based on percentages that {it:yvar_i}
    represents of all the {it:yvars}.  That is,

{phang3}
	    {cmd:. graph bar (mean) inc_male inc_female}

{pmore}
    would produce a chart with bar height reflecting average income.

{phang3}
	    {cmd:. graph bar (mean) inc_male inc_female, percentage}

{pmore}
    would produce a chart with the bar heights being
    100*inc_male/(inc_male+inc_female) and
    100*inc_female/(inc_male+inc_female).

{pmore}
    If you have one {it:yvar} and want percentages calculated over the
    first {cmd:over()} group, specify the {cmd:asyvars} option.  For instance,

{phang3}
	    {cmd:. graph bar (mean) wage, over(}{it:i}{cmd:) over(}{it:j}{cmd:)}

{pmore}
    would produce a chart where bar heights reflect mean wages.

{phang3}
	    {cmd:. graph bar (mean) wage, over(}{it:i}{cmd:) over(}{it:j}{cmd:) asyvars percentages}

{pmore}
   would produce a chart where bar heights are

	    100*( mean_ij / (Sum_i mean_ij) )

{pmore}
    Option {cmd:stack} is often combined with option {cmd:percentage}.

{phang}
{cmd:stack}
    specifies that the {it:yvar} bars be stacked.

{p 12 40 2}
	    {cmd:. graph bar (mean) inc_male inc_female,}
			{bind:{cmd:over(region) percentage stack}}

{pmore}
    would produce a chart with all bars being the same height, 100%.  Each
    bar would be two bars stacked (percentage of inc_male and percentage of
    inc_female), so the division would show the relative shares of
    inc_male and inc_female of total income.

{pmore}
    To stack bars over the first {cmd:over()} group,
    specify the {cmd:asyvars} option:

{p 12 40 2}
	    {cmd:. graph bar (mean) wage, over(sex) over(region)}
			{bind:{cmd:asyvars percentage stack}}

{phang}
{cmd:cw}
    specifies casewise deletion.  If {cmd:cw} is specified, observations for
    which any of the {it:yvars} are missing are ignored.  The default is
    to calculate the requested statistics by using all the data possible.


{marker lookofbar_options_desc}{...}
{title:lookofbar_options}

{phang}
{cmd:outergap(*}{it:#}{cmd:)} and
{cmd:outergap(}{it:#}{cmd:)}
    specify the gap between the edge of the graph to the beginning of the
    first bar and the end of the last bar to the edge of the graph.

{pmore}
    {cmd:outergap(*}{it:#}{cmd:)} specifies that the default be modified.
    Specifying {cmd:outergap(*1.2)} increases the gap by 20%, and
    specifying {cmd:outergap(*.8)} reduces the gap by 20%.

{pmore}
    {cmd:outergap(}{it:#}{cmd:)} specifies the gap as a
    percentage-of-bar-width units.  {cmd:outergap(50)} specifies that the gap
    be half the bar width.

{phang}
{cmd:bargap(}{it:#}{cmd:)}
    specifies the gap to be left between {it:yvar} bars as a
    percentage-of-bar-width units.  The default is {cmd:bargap(0)}, meaning
    that bars touch.

{pmore}
    {cmd:bargap()} may be specified as positive or negative numbers.
    {cmd:bargap(10)} puts a small gap between the bars (the precise amount
    being 10% of the width of the bars).  {cmd:bargap(-30)} overlaps the bars
    by 30%.

{pmore}
    {cmd:bargap()} affects only the {it:yvar} bars.  If you want
    to change the gap for the first, second, or third {cmd:over()}
    groups, specify the {it:over_subopt} {cmd:gap()} inside the
    {cmd:over()} itself; see
    {it:{help graph bar##subopt_over:Suboptions for use with over() and yvaroptions()}} below.

{phang}
{cmd:intensity(}{it:#}{cmd:)}
and
{cmd:intensity(*}{it:#}{cmd:)}
    specify the intensity of the color used to fill the inside of the bar.
    {cmd:intensity(}{it:#}{cmd:)} specifies the intensity, and
    {cmd:intensity(*}{it:#}{cmd:)} specifies the intensity relative to the
    default.

{pmore}
    By default, the bar is filled with the color of its border, attenuated.
    Specify {cmd:intensity(*}{it:#}{cmd:)}, {it:#}<1, to attenuate it more and
    specify {cmd:intensity(*}{it:#}{cmd:)}, {it:#}>1, to amplify it.

{pmore}
    Specify {cmd:intensity(0)} if you do not want the bar filled at all.
    Specify {cmd:intensity(100)} if you want the bar to have the same
    intensity as the bar's outline.

{phang}
{cmd:lintensity(}{it:#}{cmd:)}
and
{cmd:lintensity(*}{it:#}{cmd:)}
    specify the intensity of the line used to outline the bar.
    {cmd:lintensity(}{it:#}{cmd:)} specifies the intensity, and
    {cmd:lintensity(*}{it:#}{cmd:)} specifies the intensity relative to the
    default.

{pmore}
    By default, the bar is outlined at the same intensity at which it is
    filled or at an amplification of that, which depending on your chosen
    scheme; see {manhelp schemes G-4:Schemes intro}.  If you want the bar
    outlined in the darkest possible way, specify {cmd:intensity(255)}.  If you
    wish simply to amplify the outline, specify {cmd:intensity(*}{it:#}{cmd:)},
    {it:#}>1, and if you wish to attenuate the outline, specify
    {cmd:intensity(*}{it:#}{cmd:)}, {it:#}<1.

{phang}
{cmd:pcycle(}{it:#}{cmd:)}
    specifies how many variables are to be plotted before the {help pstyle} of
    the bars for the next variable begins again at the pstyle of the
    first variable -- {cmd:p1bar} (with the bars for the variable
    following that using {cmd:p2bar} and so).  Put another way: {it:#}
    specifies how quickly the look of bars is recycled when more than {it:#}
    variables are specified.  The default for most {help schemes} is
    {cmd:pcycle(15)}.

{phang}
{cmd:bar(}{it:#}{cmd:,} {it:barlook_options}{cmd:)}
    specifies the look of the {it:yvar} bars.
    {cmd:bar(1,} ...{cmd:)} refers to the bar associated with the first
    {it:yvar}, {cmd:bar(2,} ...{cmd:)} refers to the bar associated with the
    second, and so on.  The most useful {it:barlook_option} is
    {cmd:color(}{it:colorstyle}{cmd:)}, which sets the color and opacity of
    the bar.  For instance, you might specify {cmd:bar(1, color(green))} to
    make the bar associated with the first {it:yvar} green.  See 
    {manhelpi colorstyle G-4} for a list of color choices, and see 
    {manhelpi barlook_options G-3} for information on the other
    {it:barlook_options}.


{marker legending_options_desc}{...}
{title:legending_options}

{phang}
{it:legend_options}
    controls the legend.
    If more than one {it:yvar} is specified, a legend is produced.
    Otherwise, no legend is needed because the {cmd:over()} groups are
    labeled on the categorical x axis.
    See {manhelpi legend_options G-3}, and see
    {it:{help graph bar##remarks3:Treatment of bars}} under {it:Remarks} below.

{phang}
{cmd:nolabel}
    specifies that, in automatically constructing the legend, the variable
    names of the {it:yvars} be used in preference to "mean of {varname}" or
    "sum of {it:varname}", etc.

{phang}
{cmd:yvaroptions(}{it:over_subopts}{cmd:)}
    allows you to specify {it:over_subopts} for the {it:yvars}.  This is
    seldom done.

{phang}
{cmd:showyvars}
    specifies that, in addition to building a legend, the identities of the
    {it:yvars} be shown on the categorical x axis.  If
    {cmd:showyvars} is specified, it is typical also to specify
    {cmd:legend(off)}.

{phang}
{cmd:blabel()} allows you to add labels on top of the bars; see
    {manhelpi blabel_option G-3}.


{marker axis_options_desc}{...}
{title:axis_options}

{phang}
{cmd:yalternate} and {cmd:xalternate}
    switch the side on which the axes appear.

{pmore}
    Used with {cmd:graph} {cmd:bar}, {cmd:yalternate} moves the numerical
    y axis from the left to the right; {cmd:xalternate} moves the
    categorical x axis from the bottom to the top.

{pmore}
    Used with {cmd:graph} {cmd:hbar}, {cmd:yalternate} moves the numerical
    y axis from the bottom to the top; {cmd:xalternate} moves the
    categorical x axis from the left to the right.

{pmore}
    If your scheme by default puts the axes on the opposite sides, then
    {cmd:yalternate} and {cmd:xalternate} reverse their actions.

{phang}
{cmd:exclude0}
    specifies that the numerical y axis need not be scaled to include 0.

{phang}
{cmd:yreverse}
    specifies that the numerical y axis have its scale reversed
    so that it runs from maximum to minimum.  This option
    causes bars to extend down rather than up ({cmd:graph} {cmd:bar}) or
    from right to left rather than from left to right ({cmd:graph} {cmd:hbar}).

{phang}
{it:axis_scale_options}
    specify how the numerical y axis is scaled and how it looks; see
    {manhelpi axis_scale_options G-3}.  There you will also see
    option {cmd:xscale()} in addition to {cmd:yscale()}.
    Ignore {cmd:xscale()}, which is irrelevant for bar charts.

{phang}
{it:axis_label_options}
    specify how the numerical y axis is to be labeled.
    The {it:axis_label_options} also allow you to add and suppress
    grid lines;
    see {manhelpi axis_label_options G-3}.
    There you will see that, in addition to options
    {cmd:ylabel()}, {cmd:ytick()}, ..., {cmd:ymtick()},
    options {cmd:xlabel()}, ..., {cmd:xmtick()} are allowed.  Ignore the
    {cmd:x*()} options, which are irrelevant for bar charts.

{phang}
{cmd:ytitle()}
    overrides the default title for the numerical y axis; see 
    {manhelpi axis_title_options G-3}.  There you will also find option
    {cmd:xtitle()} documented, which is irrelevant for bar charts.


{marker title_and_other_options_desc}{...}
{title:title_and_other options}

{phang}
{cmd:text()}
    adds text to a specified location on the graph; see 
    {manhelpi added_text_option G-3}.  The basic syntax of {cmd:text()} is

	    {cmd:text(}{it:#_y} {it:#_x} {cmd:"}{it:text}{cmd:")}

{pmore}
    {cmd:text()} is documented in terms of twoway graphs.  When used with
    bar charts, the "numeric" x axis is scaled to run from 0 to 100.

{phang}
{cmd:yline()}
    adds horizontal ({cmd:bar}) or vertical ({cmd:hbar}) lines at specified
    y values; see {manhelpi added_line_options G-3}.  The {cmd:xline()}
    option, also documented there, is irrelevant for bar charts.
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
    and see {it:{help graph bar##remarks16:Use with by()}} under {it:Remarks}
    below.


{marker suboptions_desc}{...}
{marker subopt_over}{...}
{title:Suboptions for use with over() and yvaroptions()}

{marker relabel()}{...}
{phang}
{cmd:relabel(}{it:#} {cmd:"}{it:text}{cmd:"} ...{cmd:)}
    specifies text to override the default category labeling.
    Pretend that variable {cmd:sex} took on two values and you typed

{phang3}
	    {cmd:. graph bar} ...{cmd:,} ... {cmd:over(sex, relabel(1 "Male" 2 "Female"))}

{pmore}
    The result would be to relabel the first value of {cmd:sex} to be "Male" and
    the second value, "Female"; "Male" and "Female" would appear on the
    categorical x axis to label the bars.  This would be the result,
    regardless of whether variable {cmd:sex} were string or numeric and
    regardless of the codes actually stored in the variable to record sex.

{pmore}
    That is, {it:#} refers to category number, which is determined by sorting
    the unique values of the variable (here {cmd:sex}) and assigning
    1 to the first value, 2 to the second, and so on.  If you are unsure as to
    what that ordering would be, the easy way to find out is to type

	    {cmd:. tabulate sex}

{pmore}
    If you also plan on specifying {cmd:graph} {cmd:bar}'s or {cmd:graph}
    {cmd:hbar}'s {cmd:missing} option,

{phang3}
	    {cmd:. graph bar} ...{cmd:,} ... {cmd:missing over(sex, relabel(}...{cmd:))}

{pmore}
    then type

	    {cmd:. tabulate sex, missing}

{pmore}
     to determine the coding.  See {manhelp tabulate_oneway R:tabulate oneway}.

{pmore}
     Relabeling the values does not change the order in which the bars are
     displayed.

{pmore}
    You may create multiple-line labels by using quoted strings within quoted
    strings:

	    {cmd:over(}{it:varname}{cmd:, relabel(1 `" "Male"   "patients" "'}
				  {cmd:2 `" "Female" "patients" "'))}

{pmore}
    When specifying quoted strings within quoted strings, remember to
    use compound double quotes {cmd:`"} and {cmd:"'} on the outer level.

{pmore}
    {cmd:relabel()} may also be specified inside {cmd:yvaroptions()}.
    By default, the identity of the {it:yvars} is revealed in the legend, so
    specifying {cmd:yvaroptions(relabel())} changes the legend.  Because it is
    the legend that is changed, using {cmd:legend(label())} is preferred; see
    {it:{help graph bar##legending_options_desc:legending_options}} above.  In
    any case, specifying

	    {cmd:yvaroptions(relabel(1 "Males" 2 "Females"))}

{pmore}
    changes the text that appears in the legend for the first
    {it:yvar} and the second {it:yvar}.  {it:#} in
    {cmd:relabel(}{it:#} ...{cmd:)} refers to {it:yvar} number.
    Here you may not use the nested quotes to create multiline
    labels; use the {cmd:legend(label())} option because it provides multiline
    capabilities.

{phang} {cmd:label(}{it:cat_axis_label_options}{cmd:)} determines other
aspects of the look of the category labels on the x axis.  
Except for {cmd:label(labcolor())} and {cmd:label(labsize())}, these options
are seldom specified; see {manhelpi cat_axis_label_options G-3}.

{phang}
{cmd:axis(}{it:cat_axis_line_options}{cmd:)}
    specifies how the axis line is rendered.  This is a seldom specified
    option.  See {manhelpi cat_axis_line_options G-3}.

{phang}
{cmd:gap(}{it:#}{cmd:)} and
{cmd:gap(*}{it:#}{cmd:)}
    specify the gap between the bars in this {cmd:over()} group.
    {cmd:gap(}{it:#}{cmd:)} is specified in percentage-of-bar-width units, so
    {cmd:gap(67)} means two-thirds the width of a bar.
    {cmd:gap(*}{it:#}{cmd:)} allows modifying the default gap.
    {cmd:gap(*1.2)} would increase the gap by 20%, and {cmd:gap(*.8)} would
    decrease the gap by 20%.

{pmore}
    To understand the distinction between
    {cmd:over(}...{cmd:,} {cmd:gap())} and option {cmd:bargap()}, consider

{phang3}
	    {cmd:. graph bar revenue profit, bargap(}...{cmd:) over(division, gap(}...{cmd:))}

{pmore}
    {cmd:bargap()} sets the distance between the revenue and profit bars.
    {cmd:over(,gap())} sets the distance between the bars for the
    first division and the second division, the second division and the third,
    and so on.  Similarly, in

	    {cmd:. graph bar revenue profit, bargap(}...{cmd:)}
					{cmd:over(division, gap(}...{cmd:))}
					{cmd:over(year,     gap(}...{cmd:))}

{pmore}
    {cmd:over(division, gap())} sets the gap between divisions and
    {cmd:over(year, gap())} sets the gap between years.

{phang}
{cmd:sort(}{varname}{cmd:)},
{cmd:sort(}{it:#}{cmd:)}, and
{cmd:sort((}{it:stat}{cmd:)} {it:varname}{cmd:)}
    control how bars are ordered.  See
    {it:{help graph bar##remarks10:How bars are ordered}}
    and {it:{help graph bar##remarks11:Reordering the bars}} under {it:Remarks}
    below.

{pmore}
    {cmd:sort(}{it:varname}{cmd:)} puts the bars in the order of {it:varname};
    see {it:{help graph bar##remarks12:Putting the bars in a prespecified order}}
    under {it:Remarks} below.

{pmore}
    {cmd:sort(}{it:#}{cmd:)} puts the bars in height order.
    {it:#} refers to the {it:yvar} number on which the ordering should be
    performed;
    see {it:{help graph bar##remarks13:Putting the bars in height order}} under
    {it:Remarks} below.

{pmore}
    {cmd:sort((}{it:stat}{cmd:)} {it:varname}{cmd:)}
    puts the bars in an order based on a calculated statistic;
    see {it:{help graph bar##remarks14:Putting the bars in a derived order}}
    under {it:Remarks} below.

{phang}
{cmd:descending}
    specifies that the order of the bars -- default or as specified
    by {cmd:sort()} -- be reversed.

{phang}
{cmd:reverse}
     specifies that the categorical scale run from maximum to minimum rather
     than the default minimum to maximum.  Among other things, when combined
     with {cmd:bargap(}-{it:#}{cmd:)}, {cmd:reverse} causes the sequence of
     overlapping to be reversed.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help graph bar##remarks1:Introduction}
	{help graph bar##remarks2:Examples of syntax}
	{help graph bar##remarks3:Treatment of bars}
	{help graph bar##remarks4:Treatment of data}
	{help graph bar##remarks4b:Obtaining frequencies}
	{help graph bar##remarks5:Multiple bars (overlapping the bars)}
	{help graph bar##remarks6:Controlling the text of the legend}
	{help graph bar##remarks7:Multiple over()s (repeating the bars)}
	{help graph bar##remarks8:Nested over()s}
	{help graph bar##remarks9:Charts with many categories}
	{help graph bar##remarks10:How bars are ordered}
	{help graph bar##remarks11:Reordering the bars}
	{help graph bar##remarks12:Putting the bars in a prespecified order}
	{help graph bar##remarks13:Putting the bars in height order}
	{help graph bar##remarks14:Putting the bars in a derived order}
	{help graph bar##remarks15:Reordering the bars, example}
	{help graph bar##remarks16:Use with by()}
	{help graph bar##remarks17:Video example}
	{help graph bar##remarks18:History}


{marker remarks1}{...}
{title:Introduction}

{pstd}
Let us show you some bar charts:

	{cmd}. sysuse citytemp

	. graph bar (mean) tempjuly tempjan, over(region)
		bargap(-30)
		legend( label(1 "July") label(2 "January") )
		ytitle("Degrees Fahrenheit")
		title("Average July and January temperatures")
		subtitle("by regions of the United States")
		note("Source:  U.S. Census Bureau, U.S. Dept. of Commerce"){txt}
	  {it:({stata gr_example2 grbar1:click to run})}
{* graph grbar1}{...}


	{cmd}. sysuse citytemp, clear

	. graph hbar (mean) tempjan, over(division) over(region) nofill
		ytitle("Degrees Fahrenheit")
		title("Average January temperature")
		subtitle("by region and division of the United States")
		note("Source:  U.S. Census Bureau, U.S. Dept. of Commerce"){txt}
	  {it:({stata gr_example2 grbar3:click to run})}
{* graph grbar3}{...}


	{cmd}. sysuse nlsw88, clear

	. graph bar (mean) wage, over(smsa) over(married) over(collgrad)
		title("Average Hourly Wage, 1988, Women Aged 34-46")
		subtitle("by College Graduation, Marital Status,
			  and SMSA residence")
		note("Source:  1988 data from NLS, U.S. Dept. of Labor,
		      Bureau of Labor Statistics"){txt}
	  {it:({stata gr_example2 grbar5:click to run})}
{* graph grbar5}{...}


	{cmd}. sysuse educ99gdp, clear

	. generate total = private + public

	. graph hbar (asis) public private,
		over(country, sort(total) descending) stack
		title( "Spending on tertiary education as % of GDP,
		        1999", span pos(11) )
		subtitle(" ")
		note("Source:  OECD, Education at a Glance 2002", span){txt}
	  {it:({stata gr_example2 grbar7:click to run})}
{* graph grbar7}{...}

{pstd}
In the sections that follow, we explain how each of the above
graphs -- and others -- are produced.


{marker remarks2}{...}
{title:Examples of syntax}

{pstd}
Below we show you some {cmd:graph} {cmd:bar} commands and tell you what each
would do:

{p 4 8 8}
{cmd:graph bar, over(division)}{break}
    {it:#_of_divisions} bars showing the percentage of observations for each division.

{p 4 8 8}	
{cmd:graph bar (count), over(division)}{break}
    {it:#_of_divisions} bars showing the frequency of observations for each division.

{p 4 8 8}
{cmd:graph bar revenue}{break}
    One big bar showing average revenue.

{p 4 8 8}
{cmd:graph bar revenue profit}{break}
    Two bars, one showing average revenue and the other showing average profit.

{p 4 8 8}
{cmd:graph bar revenue, over(division)}{break}
    {it:#_of_divisions} bars showing average revenue for each division.

{p 4 8 8}
{cmd:graph bar revenue profit, over(division)}{break}
    2*{it:#_of_divisions} bars showing average revenue and average
    profit for each division.
    The grouping would look like this (assuming three divisions):

	    {c TLC}{c -}{c TRC}       {c TLC}{c -}{c TRC}       {c TLC}{c -}{c TRC}
	    {c |} {c |}       {c |} {c |}       {c |} {c |}
	    {c |} {c LT}{c -}{c TRC}     {c |} {c LT}{c -}{c TRC}     {c |} {c LT}{c -}{c TRC}
	    {c |} {c |} {c |}     {c |} {c |} {c |}     {c |} {c |} {c |}
	  {hline 2}{c BT}{c -}{c BT}{c -}{c BT}{hline 5}{c BT}{c -}{c BT}{c -}{c BT}{hline 5}{c BT}{c -}{c BT}{c -}{c BT}{c -}
	  division  division  division

{p 4 8 8}
{cmd:graph bar revenue, over(division) over(year)}{break}
    {it:#_of_divisions}*{it:#_of_years} bars showing average revenue
    for each division, repeated for each of the years.  The grouping would
    look like this (assuming three divisions and 2 years):

	    {c TLC}{c -}{c TRC}      {c TLC}{c -}{c TRC}      {c TLC}{c -}{c TRC}          {c TLC}{c -}{c TRC}      {c TLC}{c -}{c TRC}      {c TLC}{c -}{c TRC}
	    {c |} {c |}      {c |} {c |}      {c |} {c |}          {c |} {c |}      {c |} {c |}      {c |} {c |}
	    {c |} {c |}      {c |} {c |}      {c |} {c |}          {c |} {c |}      {c |} {c |}      {c |} {c |}
	 {hline 3}{c BT}{c -}{c BT}{hline 6}{c BT}{c -}{c BT}{hline 6}{c BT}{c -}{c BT}{hline 10}{c BT}{c -}{c BT}{hline 6}{c BT}{c -}{c BT}{hline 6}{c BT}{c -}{c BT}{hline 4}
	  division division division     division division division
		     year                           year

{p 4 8 8}
{cmd:graph bar revenue, over(year) over(division)}{break}
    same as above but ordered differently.  In the previous example we
    typed {cmd:over(division)} {cmd:over(year)}.  This time, we reverse it:

	    {c TLC}{c -}{c TRC}     {c TLC}{c -}{c TRC}       {c TLC}{c -}{c TRC}     {c TLC}{c -}{c TRC}       {c TLC}{c -}{c TRC}     {c TLC}{c -}{c TRC}
	    {c |} {c |}     {c |} {c |}       {c |} {c |}     {c |} {c |}       {c |} {c |}     {c |} {c |}
	    {c |} {c |}     {c |} {c |}       {c |} {c |}     {c |} {c |}       {c |} {c |}     {c |} {c |}
	  {hline 2}{c BT}{c -}{c BT}{hline 5}{c BT}{c -}{c BT}{hline 7}{c BT}{c -}{c BT}{hline 5}{c BT}{c -}{c BT}{hline 7}{c BT}{c -}{c BT}{hline 5}{c BT}{c -}{c BT}{c -}
	   year    year      year    year      year    year
	     division          division          division

{p 4 8 8}
{cmd:graph bar revenue profit, over(division) over(year)}{break}
    2*{it:#_of_divisions}*{it:#_of_years} bars showing average revenue and
    average profit for each division, repeated for each of the years.
    The grouping would look like this (assuming three divisions and 2 years):

	   {c TLC}{c -}{c TRC}       {c TLC}{c -}{c TRC}       {c TLC}{c -}{c TRC}        {c TLC}{c -}{c TRC}       {c TLC}{c -}{c TRC}       {c TLC}{c -}{c TRC}
	   {c |} {c |}       {c |} {c |}       {c |} {c |}        {c |} {c |}       {c |} {c |}       {c |} {c |}
	   {c |} {c LT}{c -}{c TRC}     {c |} {c LT}{c -}{c TRC}     {c |} {c LT}{c -}{c TRC}      {c |} {c LT}{c -}{c TRC}     {c |} {c LT}{c -}{c TRC}     {c |} {c LT}{c -}{c TRC}
	   {c |} {c |} {c |}     {c |} {c |} {c |}     {c |} {c |} {c |}      {c |} {c |} {c |}     {c |} {c |} {c |}     {c |} {c |} {c |}
	 {hline 2}{c BT}{c -}{c BT}{c -}{c BT}{hline 5}{c BT}{c -}{c BT}{c -}{c BT}{hline 5}{c BT}{c -}{c BT}{c -}{c BT}{hline 5}{c -}{c BT}{c -}{c BT}{c -}{c BT}{hline 5}{c BT}{c -}{c BT}{c -}{c BT}{hline 5}{c BT}{c -}{c BT}{c -}{c BT}{c -}
	 division  division  division   division  division  division
		     year                          year

{p 4 8 8}
{cmd:graph bar (sum) revenue profit, over(division) over(year)}{break}
    2*{it:#_of_divisions}*{it:#_of_years} bars showing the sum of revenue and
    sum of profit for each division, repeated for each of the years.

{p 4 8 8}
{cmd:graph bar (median) revenue profit, over(division) over(year)}{break}
    2*{it:#_of_divisions}*{it:#_of_years} bars showing the median of revenue
    and median of profit for each division, repeated for each of the years.

{p 4 8 8}
{cmd:graph bar (median) revenue (mean) profit, over(division) over(year)}{break}
    2*{it:#_of_divisions}*{it:#_of_years} bars showing the median of revenue
    and mean of profit for each division, repeated for each of the years.


{marker remarks3}{...}
{title:Treatment of bars}

{pstd}
Assume someone tells you that the average January temperature in the Northeast
of the United States is 27.9 degrees Fahrenheit, 27.1 degrees in the North
Central, 46.1 in the South, and 46.2 in the West.  You could enter these
statistics and draw a bar chart:

	{cmd}. input ne nc south west

	     {txt}       ne         nc      south       west
	  1{cmd}. 27.9 21.7 46.1 46.2
	{txt}  2{cmd}. end{txt}

	{cmd:. graph bar (asis) ne nc south west}
	  {it:({stata gr_example2 grbar0:click to run})}
{* graph grbar0}{...}

{pstd}
The above is admittedly not a great-looking chart, but specifying a few
options could fix that.  The important thing to see right now is that, when we
specify multiple {it:yvars}, 1) the bars touch, 2) the bars are different
colors (or at least different shades of gray), and 3) the meaning of the bars
is revealed in the legend.

{pstd}
We could enter this data another way:

	{cmd:. clear}

	{cmd}. input  str10 region  float tempjan

	     {txt}   region  tempjan
	  1{cmd}. N.E. 27.9
	{txt}  2{cmd}. "N. Central" 21.7
	{txt}  3{cmd}. South 46.1
	{txt}  4{cmd}. West 46.2
	{txt}  5{cmd}. end{txt}

	{cmd:. graph bar (asis) tempjan, over(region)}
	  {it:({stata gr_example2 grbar0b:click to run})}
{* graph grbar0b}{...}

{pstd}
Observe that, when we generate multiple bars via an {cmd:over()} option,
1) the bars do not touch, 2) the bars are all the same color, and 3) the
meaning of the bars is revealed by how the categorical x axis is labeled.

{pstd}
These differences in the treatment of the bars in the multiple {it:yvars} case
and the {cmd:over()} case are general properties of {cmd:graph} {cmd:bar} and
{cmd:graph} {cmd:hbar}:


			       multiple {it:yvars}           {cmd:over()} groups
	{hline 61}
	bars touch                 yes                        no
	bars different colors      yes                        no
	bars identified via ...   legend                  axis label
	{hline 61}

{pstd}
Option {cmd:ascategory} causes multiple {it:yvars} to be presented as if they
were {cmd:over()} groups, and option {cmd:asyvars} causes {cmd:over()} groups
to be presented as if they were multiple {it:yvars}.  Thus

	{cmd:. graph bar (asis) tempjan, over(region)}

{pstd}
would produce the first chart and

	{cmd:. graph bar (asis) ne nc south west, ascategory}

{pstd}
would produce the second.


{marker remarks4}{...}
{title:Treatment of data}

{pstd}
In the previous two examples, we already had the statistics we wanted to plot:
27.9 (Northeast), 21.7 (North Central), 46.1 (South), and 46.2 (West).
We entered the data, and we typed

	{cmd:. graph bar (asis) ne nc south west}
    or
	{cmd:. graph bar (asis) tempjan, over(region)}

{pstd}
We do not have to know the statistics ahead of time:  {cmd:graph} {cmd:bar}
and {cmd:graph} {cmd:hbar} can calculate statistics for us.  If we had
datasets with lots of observations (say, cities of the United States), we could
type

	{cmd:. graph bar (mean) ne nc south west}
    or
	{cmd:. graph bar (mean) tempjan, over(region)}

{pstd}
and obtain the same graphs.  All we need to do is change {cmd:(asis)} to
{cmd:(mean)}.  In the first example, the data would be organized the wide way:

	cityname           ne     nc     south     west
	{hline 47}
	{it:name of city}       42      .         .        .
	{it:another city}        .     28         .        .
	...
	{hline 47}

{pstd}
and, in the second example, the data would be organized the long way:


	cityname        region        tempjan
	{hline 37}
	{it:name of city}      ne          42
	{it:another city}      nc          28
	...
	{hline 37}

{pstd}
We have such a dataset, organized the long way.  In {bf:citytemp.dta}, we have
information on 956 U.S. cities, including the region in which each is located
and its average January temperature:

	{cmd:. sysuse citytemp, clear}

	{cmd}. list region tempjan if _n < 3 | _n > 954
	{txt}
	     {c TLC}{hline 8}{c -}{hline 9}{c TRC}
	     {c |} {res}region   tempjan {txt}{c |}
	     {c LT}{hline 8}{c -}{hline 9}{c RT}
	  1. {c |} {res}    NE      16.6 {txt}{c |}
	  2. {c |} {res}    NE      18.2 {txt}{c |}
	955. {c |} {res}  West      72.6 {txt}{c |}
	956. {c |} {res}  West      72.6 {txt}{c |}
	     {c BLC}{hline 8}{c -}{hline 9}{c BRC}

{pstd}
With this data, we can type

	{cmd:. graph bar (mean) tempjan, over(region)}
	  {it:({stata "gr_example citytemp: gr bar (mean) tempjan, over(region)":click to run})}
{* graph barct}{...}

{pstd}
We just produced the same bar chart we previously produced when we entered
the statistics 27.9 (Northeast), 21.7 (North Central), 46.1 (South), and 46.2
(West) and typed

	{cmd:. graph bar (asis) tempjan, over(region)}

{pstd}
When we do not specify {cmd:(asis)} or {cmd:(mean)} (or {cmd:(median)} or
{cmd:(sum)} or {cmd:(p1)} or any of the other {it:stats} allowed),
{cmd:(mean)} is assumed.  Thus {cmd:(...)} is often omitted when
{cmd:(mean)} is desired, and we could have drawn the previous graph by
typing

	{cmd:. graph bar tempjan, over(region)}

{pstd}
Some users even omit typing {cmd:(...)} in the {cmd:(asis)} case because
calculating the mean of one observation results in the number itself.
Thus in the previous section, rather than typing

	{cmd:. graph bar (asis) ne nc south west}
    and
	{cmd:. graph bar (asis) tempjan, over(region)}

{pstd}
We could have typed

	{cmd:. graph bar ne nc south west}
    and
	{cmd:. graph bar tempjan, over(region)}


{marker remarks4b}{...}
{title:Obtaining frequencies}

{pstd}
The {cmd:(percent)} and {cmd:(count)} statistics work just like any other
statistic with the {cmd:graph} {cmd:bar} command.  In addition to the standard
syntax, you may use the abbreviated syntax below to create bar graphs for
percentages and frequencies over categorical variables.

{pstd}
To graph the percentage of observations in each category of
{cmd:division}, type

	{cmd:. sysuse citytemp, clear}{break}
	{cmd:. graph bar, over(division)}
	  {it:({stata gr_example2 grbar9:click to run})}
	{* graph grbar9}{...}
	
{pstd}
To graph the frequency of observations in each category of
{cmd:division}, type

	{cmd:. graph bar (count), over(division)}
	  {it:({stata gr_example2 grbar10:click to run})}
	{* graph grbar10}{...}


{marker remarks5}{...}
{title:Multiple bars (overlapping the bars)}

{pstd}
In {bf:citytemp.dta}, in addition to variable {cmd:tempjan}, there is variable
{cmd:tempjuly}, which the average July temperature.  We can include both
averages in one chart, by region:

	{cmd:. sysuse citytemp, clear}

	{cmd:. graph bar (mean) tempjuly tempjan, over(region)}
	  {it:({stata "gr_example citytemp: graph bar (mean) tempjuly tempjan, over(region)":click to run})}
{* graph barct2}{...}

{pstd}
We can improve the look of the chart by

{phang2}
    1.  including the {it:legend_options} {cmd:legend(label())}
	to change the text of the legend; see {manhelpi legend_options G-3};

{phang2}
    2.  including the {it:axis_title_option} {cmd:ytitle()} to add a
	title saying "Degrees Fahrenheit"; see 
	{manhelpi axis_title_options G-3};

{phang2}
    3.  including the {it:title_options} {cmd:title()}, {cmd:subtitle()},
	and {cmd:note()} to say what the graph is about and from where the
	data came; see {manhelpi title_options G-3}.

{pstd}
Doing all that produces

	{cmd}. graph bar (mean) tempjuly tempjan, over(region)
		legend( label(1 "July") label(2 "January") )
		ytitle("Degrees Fahrenheit")
		title("Average July and January temperatures")
		subtitle("by regions of the United States")
		note("Source:  U.S. Census Bureau, U.S. Dept. of Commerce"){txt}
	  {it:({stata gr_example2 grbar1a:click to run})}
{* graph grbar1a}{...}

{pstd}
We can make one more improvement to this chart by overlapping the bars.
Below we add the option {cmd:bargap(-30)}:

	{cmd}. graph bar (mean) tempjuly tempjan, over(region)
  {txt:{it:new} ->}        bargap(-30)
		legend( label(1 "July") label(2 "January") )
		ytitle("Degrees Fahrenheit")
		title("Average July and January temperatures")
		subtitle("by regions of the United States")
		note("Source:  U.S. Census Bureau, U.S. Dept. of Commerce"){txt}
	  {it:({stata gr_example2 grbar1:click to run})}
{* graph grbar1}{...}

{pstd}
{cmd:bargap(}{it:#}{cmd:)} specifies the distance between the {it:yvar} bars
(that is, between the bars for {cmd:tempjuly} and {cmd:tempjan}); {it:#} is in
percentage-of-bar-width units, so {cmd:barwidth(-30)} means that the bars
overlap by 30%.  {cmd:bargap()} may be positive or negative; its default is 0.


{marker remarks6}{...}
{title:Controlling the text of the legend}

{pstd}
In the above example, we changed the text of the legend by specifying the
legend option:

		{cmd:legend( label(1 "July") label(2 "January") )}

{pstd}
We could just as well have changed the text of the legend by typing

		{cmd:yvaroptions( relabel(1 "July" 2 "January") )}

{pstd}
Which you use makes no difference, but we prefer {cmd:legend(label())}
to {cmd:yvaroptions(relabel())} because {cmd:legend(label())} is the way to
modify the contents of a legend in a twoway graph; so why do bar charts
differently?


{marker remarks7}{...}
{title:Multiple over()s (repeating the bars)}

{pstd}
Option {cmd:over(}{it:varname}{cmd:)} repeats the {it:yvar} bars for each unique
value of {it:varname}.  Using {bf:citytemp.dta}, if we typed

	{cmd:. graph bar (mean) tempjuly tempjan}

{pstd}
we would obtain two (fat) bars.  When we type

	{cmd:. graph bar (mean) tempjuly tempjan, over(region)}

{pstd}
we obtain two (thinner) bars for each of the four regions.  (We typed exactly
this command in {hi:Multiple bars} above.)

{pstd}
You may repeat the {cmd:over()} option.  You may specify {cmd:over()} twice
when you specify two or more {it:yvars} and up to three times when you
specify just one {it:yvar}.

{pstd}
In {cmd:nlsw88.dta}, we have information on 2,246 women:

	{cmd}. sysuse nlsw88, clear

	. graph bar (mean) wage, over(smsa) over(married) over(collgrad)
		title("Average Hourly Wage, 1988, Women Aged 34-46")
		subtitle("by College Graduation, Marital Status,
			  and SMSA residence")
		note("Source:  1988 data from NLS, U.S. Dept. of Labor,
		      Bureau of Labor Statistics"){txt}
	  {it:({stata gr_example2 grbar5:click to run})}
{* graph grbar5}{...}

{pstd}
If you strip away the {it:title_options}, the above command reads

	{cmd:. graph bar (mean) wage, over(smsa) over(married) over(collgrad)}

{pstd}
In this three-{cmd:over()} case, the first {cmd:over()} is treated
as multiple {it:yvars}:  the bars touch, the bars are assigned different
colors, and the meaning of the bars is revealed in the legend.  When you
specify three {cmd:over()} groups, the first is treated the same way as
multiple {it:yvars}.  This means that if we wanted to separate the bars, we
could specify option {cmd:bargap(}{it:#}{cmd:)}, {it:#}>0, and if we wanted
them to overlap, we could specify {cmd:bargap(}{it:#}{cmd:)}, {it:#}<0.


{marker remarks8}{...}
{title:Nested over()s}

{pstd}
Sometimes you have multiple {cmd:over()} groups with one group explicitly
nested within the other.  In {bf:citytemp.dta}, we have variables
{cmd:region} and {cmd:division}, and {cmd:division} is nested within
{cmd:region}.  The Census Bureau divides the United States into four regions
and into nine divisions, which work like this

	{hline 53}
	{it:Region}                         {it:Division}
	{hline 53}
	1.  Northeast                  1.  New England
				       2.  Mid Atlantic
	{hline 53}
	2.  North Central              3.  East North Central
				       4.  West North Central
	{hline 53}
	3.  South                      5.  South Atlantic
				       6.  East South Central
				       7.  West South Central
	{hline 53}
	4.  West                       8.  Mountain
				       9.  Pacific
	{hline 53}

{pstd}
Were we to type

{phang2} 
	{cmd:. graph bar (mean) tempjuly tempjan, over(division) over(region)}

{pstd}
we would obtain a chart with space allocated for 9*4 = 36 groups, of which
only nine would be used:

	 {c TLC}{c -}{c TRC}                     {c TLC}{c -}{c TRC}                                {c TLC}{c -}{c TRC}
	 {c |} {c |}                     {c |} {c |}                                {c |} {c |}
	 {c |} {c LT}{c -}{c TRC}                   {c |} {c LT}{c -}{c TRC}                              {c |} {c LT}{c -}{c TRC}
	 {c |} {c |} {c |}                   {c |} {c |} {c |}                              {c |} {c |} {c |}
	{c -}{c BT}{c -}{c BT}{c -}{c BT}{hline 19}{c BT}{c -}{c BT}{c -}{c BT}{hline 30}{c BT}{c -}{c BT}{c -}{c BT}{hline 2}
	  1 2 3 4 5 6 7 8 9   1 2 3 4 5 6 7 8 9   ...  1 2 3 4 5 6 7 8 9
	       region 1            region 2                 region 4


{pstd}
The {cmd:nofill} option prevents the chart from including the unused
categories:

	{cmd}. sysuse citytemp, clear

	. graph bar tempjuly tempjan, over(division) over(region) nofill
		bargap(-30)
		ytitle("Degrees Fahrenheit")
		legend( label(1 "July") label(2 "January") )
		title("Average July and January temperatures")
		subtitle("by region and division of the United States")
		note("Source:  U.S. Census Bureau, U.S. Dept. of Commerce"){txt}
	  {it:({stata gr_example2 grbar2:click to run})}
{* graph grbar2}{...}

{pstd}
The above chart, if we omit one of the temperatures, also looks good
horizontally:

	{cmd}. graph hbar (mean) tempjan, over(division) over(region) nofill
		ytitle("Degrees Fahrenheit")
		title("Average January temperature")
		subtitle("by region and division of the United States")
		note("Source:  U.S. Census Bureau, U.S. Dept. of Commerce"){txt}
	  {it:({stata gr_example2 grbar3:click to run})}
{* graph grbar3}{...}


{marker remarks9}{...}
{title:Charts with many categories}

{pstd}
Using {cmd:nlsw88.dta}, we want to draw the chart

        {cmd:. sysuse nlsw88}

	{cmd:. graph bar wage, over(industry) over(collgrad)}

{pstd}
Variable {cmd:industry} records industry of employment in 12 categories, and
variable {cmd:collgrad} records whether the woman is a college graduate.
Thus we will have 24 bars.  We draw the above and quickly discover that the
long labels associated with industry result in much 
overprinting along the horizontal x axis.

{pstd}
Horizontal bar charts work better than vertical bar charts when labels are
long.  We change our command to read

	{cmd:. graph hbar wage, over(ind) over(collgrad)}

{pstd}
That works better, but now we have overprinting problems of a different
sort:  the letters of one line are touching the letters of the next.

{pstd}
Graphs are by default 4 x 5:  4 inches tall by 5 inches wide.
Here we need to make the chart taller, and that is the job of
the {it:region_option} {cmd:ysize()}.  Below we make a chart that is
7 inches tall:

	{cmd:. sysuse nlsw88, clear}

	{cmd}. graph hbar wage, over(ind, sort(1)) over(collgrad)
		title("Average hourly wage, 1988, women aged 34-46", span)
		subtitle(" ")
		note("Source:  1988 data from NLS, U.S. Dept. of Labor,
		      Bureau of Labor Statistics", span)
		ysize(7){txt}
	  {it:({stata gr_example2 grbartall:click to run})}
{* graph grbartall}{...}

{pstd}
The important option in the above is {cmd:ysize(7)}, which made the graph
taller than usual; see {manhelpi region_options G-3}. 
Concerning the other options:

{phang2}
{cmd:over(ind, sort(1)) over(collgrad)}{break}
    {cmd:sort(1)} is specified so that the bars would be sorted on mean wage.
    The {cmd:1} says to sort on the first {it:yvar}; see
    {it:{help graph bar##remarks11:Reordering the bars}} below.

{phang2}
{cmd:title("Average hourly wage, 1988, women aged 34-46", span)}{break}
    {cmd:span} is specified so that the title, rather than being centered over
    the plot region, would be centered over the entire graph.  Here 
    the plot region (the part of the graph where the real chart appears,
    ignoring the labels) is narrow, and centering over that was not going
    to work.  See {manhelpi region_options G-3} for a description of
    the graph region and plot region, and see {manhelpi title_options G-3}
    and {manhelpi textbox_options G-3} for a description of {cmd:span}.

{phang2}
{cmd:subtitle(" ")}{break}
    We specified this because the title looked too close to the graph without
    it.  We could have done things properly and specified a {cmd:margin()}
    suboption within the {cmd:title()}, but we often find it easier to
    include a blank subtitle.  We typed {cmd:subtitle(" ")} and not
    {cmd:subtitle("")}.  We had to include the blank, or the subtitle
    would not have appeared.

{phang2}
{cmd:note("Source:  1988 data from NLS, ...", span)}{break}
    {cmd:span} is specified so that the note would be left-justified in
    the graph rather than just in the plot region.


{marker remarks10}{...}
{title:How bars are ordered}

{pstd}
The default is to place the bars in the order of the {it:yvars} and to order
each set of {cmd:over(}{it:varname}{cmd:)} groups according to the values of
{it:varname}.  Let us consider some examples:

{phang}
{cmd:graph bar (sum) revenue profit}{break}
    Bars appear in the order specified: {cmd:revenue} and {cmd:profit}.

{phang}
{cmd:graph bar (sum) revenue, over(division)}{break}
    Bars are ordered according to the values of variable {cmd:division}.

{pmore}
    If {cmd:division} is a numeric variable, the lowest division number
    comes first, followed by the next lowest, and so on.  This is true
    even if variable {cmd:division} has a value label.  Say that
    division 1 has been labeled "Sales" and division 2 is labeled "Development".
    The bars will be in the order Sales followed by Development.

{pmore}
    If {cmd:division} is a string variable, the bars will be ordered by the sort
    order of the values of division (meaning alphabetically, but with
    capital letters placed before lowercase letters).  If variable {cmd:division}
    contains the values "Sales" and "Development", the bars will be in the
    order Development followed by Sales.

{phang}
{cmd:graph bar (sum) revenue profit, over(division)}{break}
    Bars appear in the order specified, revenue and profit, and are
    repeated for each division, which will be ordered as explained above.

{phang}
{cmd:graph bar (sum) revenue, over(division) over(year)}{break}
    Bars appear ordered by the values of division, as previously explained,
    and then that is repeated for each of the years.  The years are ordered
    according to the values of the variable {cmd:year}, following the same rules
    as applied to the variable {cmd:division}.

{phang}
{cmd:graph bar (sum) revenue profit, over(division) over(year)}{break}
    Bars appear in the order specified, profit and revenue, repeated
    for division ordered on the values of variable {cmd:division}, repeated
    for year ordered on the values of variable {cmd:year}.


{marker remarks11}{...}
{title:Reordering the bars}

{pstd}
There are three ways to reorder the bars:

{phang2}
1.  You want to control the order in which the elements of each {cmd:over()}
    group appear.  Your divisions might be named Development, Marketing,
    Research, and Sales, alphabetically speaking, but you want them to
    appear in the more logical order Research, Development, Marketing,
    and Sales.

{phang2}
2.  You wish to order the bars according to their heights.  You wish to draw
    the graph

{col 16}{cmd:. graph bar (sum) empcost, over(division)}

{pmore2}
    and you want the divisions ordered by total employee cost.

{phang2}
3.  You wish to order on some other derived value.

{pstd}
We will consider each of these desires separately.


{marker remarks12}{...}
{title:Putting the bars in a prespecified order}

{pstd}
We have drawn the graph

	{cmd:. graph (sum) bar empcost, over(division)}

{pstd}
Variable {cmd:division} is a string containing "Development", "Marketing",
"Research", and "Sales".  We want to draw the chart, placing the divisions in
the order Research, Development, Marketing, and Sales.

{pstd}
To do that, we create a new numeric variable that orders division as we 
would like:

	{cmd:. generate order = 1 if division=="Research"}
	{cmd:. replace  order = 2 if division=="Development"}
	{cmd:. replace  order = 3 if division=="Marketing"}
	{cmd:. replace  order = 4 if division=="Sales"}

{pstd}
We can name the variable and create it however we wish, but we must be sure
that there is a one-to-one correspondence between the new variable and the
{cmd:over()} group's values.  We then specify the {cmd:over()}'s
{cmd:sort(}{it:varname}{cmd:)} option:

{phang2}
	{cmd:. graph bar (sum) empcost, over( division, sort(order) )}

{pstd}
If you want to reverse the order, you may specify the {cmd:descending}
suboption:

{phang2}
	{cmd:. graph bar (sum) empcost, over(division, sort(order) descending)}


{marker remarks13}{...}
{title:Putting the bars in height order}

{pstd}
We have drawn the graph

{phang2}
	{cmd:. graph bar (sum) empcost, over(division)}

{pstd}
and now wish to put the bars in height order, shortest first.  We type

{phang2}
	{cmd:. graph bar (sum) empcost, over( division, sort(1) )}

{pstd}
If we wanted the tallest first, type

{phang2}
	{cmd:. graph bar empcost, over(division, sort(1) descending)}

{pstd}
The {cmd:1} in {cmd:sort(1)} refers to the first (and here only)
{it:yvar}.  If we had multiple {it:yvars}, we might type

{phang2}
	{cmd:. graph bar (sum) empcost othcost, over( division, sort(1) )}

{pstd}
and we would have a chart showing employee cost and other cost, sorted
on employee cost.  If we typed

{phang2}
	{cmd:. graph bar (sum) empcost othcost, over( division, sort(2) )}

{pstd}
the graph would be sorted on other cost.

{pstd}
We can use {cmd:sort(}{it:#}{cmd:)} on the second {cmd:over()} group as well:

	{cmd:. graph bar (sum) empcost, over( division, sort(1) )}
				   {cmd:over( country,  sort(1) )}

{pstd}
Country will be ordered on the sum of the heights of the bars.


{marker remarks14}{...}
{title:Putting the bars in a derived order}

{pstd}
We have employee cost broken into two categories:  {cmd:empcost_direct} and
{cmd:empcost_indirect}.  Variable {cmd:emp_cost} is the sum of the two.  We
wish to make a chart showing the two costs, stacked, over {cmd:division}, and
we want the bars ordered on the total height of the stacked bars.  We type

	{cmd:. graph bar (sum) empcost_direct empcost_indirect,}
			  {cmd:stack}
			  {cmd:over(division, sort((sum) empcost) descending)}


{marker remarks15}{...}
{title:Reordering the bars, example}

{pstd}
We have a dataset showing the spending on tertiary education as a percent of
GDP from the 2002 edition of
{it:Education at a Glance:  OECD Indicators 2002}:

	{cmd}. sysuse educ99gdp, clear

	. list
	{txt}
	     {c TLC}{hline 15}{c -}{hline 8}{c -}{hline 9}{c TRC}
	     {c |} {res}      country   public   private {txt}{c |}
	     {c LT}{hline 15}{c -}{hline 8}{c -}{hline 9}{c RT}
	  1. {c |} {res}    Australia       .7        .7 {txt}{c |}
	  2. {c |} {res}      Britain       .7        .4 {txt}{c |}
	  3. {c |} {res}       Canada      1.5        .9 {txt}{c |}
	  4. {c |} {res}      Denmark      1.5        .1 {txt}{c |}
	  5. {c |} {res}       France       .9        .4 {txt}{c |}
	     {c LT}{hline 15}{c -}{hline 8}{c -}{hline 9}{c RT}
	  6. {c |} {res}      Germany       .9        .2 {txt}{c |}
	  7. {c |} {res}      Ireland      1.1        .3 {txt}{c |}
	  8. {c |} {res}  Netherlands        1        .4 {txt}{c |}
	  9. {c |} {res}       Sweden      1.5        .2 {txt}{c |}
	 10. {c |} {res}United States      1.1       1.2 {txt}{c |}
	     {c BLC}{hline 15}{c -}{hline 8}{c -}{hline 9}{c BRC}

{pstd}
We wish to graph total spending on education and simultaneously show the
distribution of that total between public and private expenditures.  We want
the bar sorted on total expenditures:

	{cmd}. generate total = private + public

	. graph hbar (asis) public private,
		over(country, sort(total) descending) stack
		title( "Spending on tertiary education as % of GDP, 1999",
			span pos(11) )
		subtitle(" ")
		note("Source:  OECD, Education at a Glance 2002", span){txt}
	  {it:({stata gr_example2 grbar7:click to run})}
{* graph grbar7}{...}

{pstd}
Or perhaps we wish to disguise the total expenditures and
focus the graph exclusively on the share of spending that is public and
private:

	{cmd}. generate frac = private/(private + public)

	. graph hbar (asis) public private,
		over(country, sort(frac) descending) stack percent
		title("Public and private spending on tertiary education,
                       1999", span pos(11))
		subtitle(" ")
		note("Source:  OECD, Education at a Glance 2002", span){txt}
	  {it:({stata gr_example2 grbar8:click to run})}
{* graph grbar8}{...}

{pstd}
The only differences between the two {cmd:graph} {cmd:hbar} commands are as
follows:

{phang2}
    1.  The {cmd:percentage} option was added to change the {it:yvars}
    {cmd:public} and {cmd:private} from spending amounts to percent each is of
    the total.

{phang2}
    2.  The order of the bars was changed.

{phang2}
    3.  The title was changed.


{marker remarks16}{...}
{title:Use with by()}

{pstd}
{cmd:graph} {cmd:bar} and {cmd:graph} {cmd:hbar} may be used with {cmd:by()},
but in general, you want to use {cmd:over()} in preference to {cmd:by()}.
Bar charts are explicitly categorical and do an excellent job of presenting
summary statistics for multiple groups in one chart.

{pstd}
A good use of {cmd:by()}, however, is when you are ordering the bars and
you wish to emphasize that the ordering is different for different groups.
For instance,

	{cmd:. sysuse nlsw88, clear}

	{cmd:. graph hbar wage, over(occ, sort(1)) by(union)}
	  {it:({stata "gr_example nlsw88: graph hbar wage, over(occ, sort(1)) by(union)":click to run})}
{* graph barby}{...}

{pstd}
The above graph orders the bars by height (hourly wage);
the orderings are different for union and nonunion workers.


{marker remarks17}{...}
{title:Video example}

{phang}
{browse "http://www.youtube.com/watch?v=jNjAdtQwW6M":Bar graphs in Stata}


{* index histories}{...}
{* index Playfair, William}{...}
{* index Tufte}{...}
{* index Beniger and Robyn}{...}
{marker remarks18}{...}
{title:History}

{pstd}
The first published bar chart appeared in William Playfair's
{it:Commercial and Political Atlas} ({help graph bar##P1786:1786}).
See {help graph bar##T2001:Tufte (2001, 32-33)} or
{help graph bar##BR1978:Beniger and Robyn (1978)} for more historical
information.


{marker references}{...}
{title:References}

{marker BR1978}{...}
{phang}
Beniger, J. R., and D. L. Robyn. 1978. Quantitative graphics in statistics:
A brief history. {it:American Statistician} 32: 1-11.

{marker P1786}{...}
{phang}
Playfair, W. 1786. {it:Commercial and Political Atlas: Representing, by means}
{it:of stained Copper-Plate Charts, the Progress of the Commerce, Revenues,}
{it:Expenditure, and Debts of England, during the Whole of the Eighteenth}
{it:Century}. London: Corry.

{marker T2001}{...}
{phang}
Tufte, E. R. 2001. {it:The Visual Display of Quantitative Information}.
2nd ed. Cheshire, CT: Graphics Press.
{p_end}
