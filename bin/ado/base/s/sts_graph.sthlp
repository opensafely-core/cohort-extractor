{smcl}
{* *! version 2.2.20  16apr2019}{...}
{viewerdialog "sts graph" "dialog sts_graph"}{...}
{vieweralsosee "[ST] sts graph" "mansection ST stsgraph"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] sts" "help sts"}{...}
{vieweralsosee "[ST] sts generate" "help sts_generate"}{...}
{vieweralsosee "[ST] sts list" "help sts_list"}{...}
{vieweralsosee "[ST] sts test" "help sts_test"}{...}
{vieweralsosee "[ST] stset" "help stset"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] kdensity" "help kdensity"}{...}
{viewerjumpto "Syntax" "sts_graph##syntax"}{...}
{viewerjumpto "Menu" "sts_graph##menu"}{...}
{viewerjumpto "Description" "sts_graph##description"}{...}
{viewerjumpto "Links to PDF documentation" "sts_graph##linkspdf"}{...}
{viewerjumpto "Options" "sts_graph##options"}{...}
{viewerjumpto "Examples" "sts_graph##examples"}{...}
{viewerjumpto "Video example" "sts_graph##video"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[ST] sts graph} {hline 2}}Graph the survivor, hazard, or cumulative hazard function{p_end}
{p2col:}({mansection ST stsgraph:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 21 2}{cmd:sts} {opt g:raph} {ifin} [{cmd:,} {it:options}]

{synoptset 35 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{opt sur:vival}}graph Kaplan-Meier survivor function; the default{p_end}
{synopt :{opt fail:ure}}graph Kaplan-Meier failure function{p_end}
{synopt :{opt cumh:az}}graph Nelson-Aalen cumulative hazard function{p_end}
{synopt :{opt haz:ard}}graph smoothed hazard estimate{p_end}
{synopt :{opth by(varlist)}}estimate and graph separate functions for each group formed by {it:varlist}{p_end}
{synopt :{opth ad:justfor(varlist)}}adjust the estimates to zero values of {it:varlist}{p_end}
{synopt :{opth st:rata(varlist)}}stratify on different groups of {it:varlist}{p_end}
{synopt :{opt sep:arate}}show curves on separate graphs; default is to show
curves one on top of another{p_end}
{synopt :{opt ci}}show pointwise confidence bands{p_end}

{syntab:At-risk table}
{synopt :{cmdab:riskt:able}}show table of number at risk beneath graph{p_end}
{synopt :{opth riskt:able(sts_graph##risk_spec:risk_spec)}}show customized table
of number at risk beneath graph{p_end}

{syntab:Options}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt per(#)}}units to be used in reported rates{p_end}
{synopt :{opt nosh:ow}}do not show st setting information{p_end}
{synopt :{opt tma:x(#)}}show graph for t <= {it:#}{p_end}
{synopt :{opt tmi:n(#)}}show graph for t >= {it:#}{p_end}
{synopt :{opt noori:gin}}begin survival (failure) curve at first exit time;
default is to begin at t = 0{p_end}
{synopt :{cmd:width(}{it:#}[{it:#}...]{cmd:)}}override default bandwidth(s){p_end}
{synopt :{opth k:ernel(kdensity##kernel:kernel)}}kernel function; use with
             {opt hazard}{p_end}
{synopt :{opt nob:oundary}}no boundary correction; use with {opt hazard}{p_end}
{synopt :{opt lost}}show number lost{p_end}
{synopt :{opt e:nter}}show number entered and number lost{p_end}
{synopt :{opt atr:isk}}show numbers at risk at beginning of each interval{p_end}
{synopt :{cmdab:cen:sored(}{opt s:ingle)}}show one hash mark at each censoring
       time, no matter what number is censored{p_end}
{synopt :{cmdab:cen:sored(}{opt n:umber)}}show one hash mark at each censoring
        time and number censored above hash mark{p_end}
{synopt :{cmdab:cen:sored(}{opt m:ultiple)}}show multiple hash marks for
	multiple censoring at the same time{p_end}
{synopt :{opth censo:pts(sts_graph##hash_options:hash_options)}}affect
        rendition of hash marks{p_end}
{synopt :{opth lostop:ts(marker_label_options)}}affect rendition of numbers
	lost{p_end}
{synopt :{opth atriskop:ts(marker_label_options)}}affect rendition of numbers
	at risk{p_end}

{syntab:Plot}
{synopt :{opth ploto:pts(cline_options)}}affect rendition of plotted lines{p_end}
{synopt :{cmdab:plot:}{ul:{it:#}}{cmd:opts(}{it:{help cline_options}}{cmd:)}}affect rendition of {it:#}th plotted line; may not be combined with {opt separate}{p_end}

{syntab:CI plot}
{synopt :{opth ciop:ts(area_options)}}affect rendition of confidence bands{p_end}
{synopt :{cmdab:ci:}{ul:{it:#}}{cmd:opts(}{it:{help area_options}}{cmd:)}}affect rendition of {it:#}th confidence band; may not be combined with {opt separate}{p_end}

{syntab:Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options documented in
      {manhelpi twoway_options G-3}{p_end}
{synopt :{opth byop:ts(by_option:byopts)}}how subgraphs are combined, labeled,
etc.{p_end}
{synoptline}

{marker risk_spec}{...}
{phang}
where {it:risk_spec} is 

{pmore2}
[{it:{help numlist}}][{cmd:,} {it:table_options}
       {opth group:(sts_graph##group:group)}]

{pmore}
{it:numlist} specifies the points at which the number at risk is to
be evaluated, {it:table_options} customizes the table of number at risk,
and {opt group(group)} specifies a specific group/row for {it:table_options}
to be applied.

{marker table_options}{...}
{synoptset 35 tabbed}{...}
{synopthdr:table_options}
{synoptline}
{syntab:Main}
{synopt:{it:{help axis_label_options}}}control table by using axis labeling
	options; seldom used{p_end}
{synopt:{opt order}{hi:(}{it:{help sts_graph##order_spec:order_spec}}{hi:)}}select which rows appear and their order{p_end}
{synopt:{opt rightt:itles}}place titles on right side of the table{p_end}
{synopt:{opt fail:events}}show number failed in the at-risk table{p_end}
{synopt:{it:{help sts_graph##text_options:text_options}}}affect rendition of
	table elements and titles{p_end}

{syntab:Row titles}
{synopt:{opt rowt:itle}{cmd:(}[{it:text}][{cmd:,} {it:{help sts_graph##rtext_options:rtext_options}}]{cmd:)}}change title for a row{p_end}

{syntab:Title}
{synopt:{opt title}{cmd:(}[{it:text}][{cmd:,} {it:{help sts_graph##ttext_options:ttext_options}}]{cmd:)}}change
	overall table title{p_end}
{synoptline}

{marker order_spec}{...}
{phang}
where {it:order_spec} is{p_end}

{pmore}
{it:#} [{hi:"}{it:text}{hi:"} [{hi:"}{it:text}{hi:"} ...]] [...]

{marker text_options}{...}
{synoptset 35}{...}
{synopthdr:text_options}
{synoptline}
{synopt:{opth size(textsizestyle)}}size of text{p_end}
{synopt:{opth color(colorstyle)}}color of text{p_end}
{synopt:{opth justification(justificationstyle)}}text left-justified,
	centered, right-justified{p_end}
{synopt:{opth format(%fmt)}}format values per {bf:%}{it:fmt}{p_end}
{synopt:{opth topg:ap(size)}}margin above rows{p_end}
{synopt:{opth bottomg:ap(size)}}margin beneath rows{p_end}

{synopt:{opth style(textstyle)}}overall style of text{p_end}
{synoptline}
{p 4 6 2}{cmd:style()} does not appear in the dialog box.{p_end}

{marker rtext_options}{...}
{synoptset 35}{...}
{synopthdr:rtext_options}
{synoptline}
{synopt:{opth size(textsizestyle)}}size of text{p_end}
{synopt:{opth color(colorstyle)}}color of text{p_end}
{synopt:{opth justification(justificationstyle)}}text left-justified,
	centered, right-justified{p_end}
{synopt:{opt at(#)}}override x position of titles{p_end}
{synopt:{opth topg:ap(size)}}margin above rows{p_end}

{synopt:{opth style(textstyle)}}overall style of text{p_end}
{synoptline}
{p 4 6 2}{cmd:style()} does not appear in the dialog box.{p_end}

{marker ttext_options}{...}
{synoptset 35}{...}
{synopthdr:ttext_options}
{synoptline}
{synopt:{opth size(textsizestyle)}}size of text{p_end}
{synopt:{opth color(colorstyle)}}color of text{p_end}
{synopt:{opth justification(justificationstyle)}}text left-justified,
	centered, right-justified{p_end}
{synopt:{opt at(#)}}override x position of titles{p_end}
{synopt:{opth topg:ap(size)}}margin above rows{p_end}
{synopt:{opth bottomg:ap(size)}}margin beneath rows{p_end}

{synopt:{opth style(textstyle)}}overall style of text{p_end}
{synoptline}
{p 4 6 2}{cmd:style()} does not appear in the dialog box.{p_end}

{marker group}{...}
{synoptset 35}{...}
{synopthdr:group}
{synoptline}
{synopt:{it:#rownum}}specify group by row number in table{p_end}
{synopt:{it:value}}specify group by value of group{p_end}
{synopt:{it:label}}specify group by text of value label associated with
	group{p_end}
{synoptline}

{marker hash_options}{...}
{synoptset 35}{...}
{synopthdr:hash_options}
{synoptline}
{synopt:{it:{help line_options}}}change look of dropped lines{p_end}
{synopt:{it:{help marker_label_options}}}add marker labels; any options
documented in {manhelpi marker_label_options G-3}, except {cmd:mlabel()}{p_end}
{synoptline}

{p2colreset}{...}
{p 4 6 2}
{opt risktable()} may be repeated and is {it:merged-explicit}; 
see {help repeated options}.{p_end}
{p 4 6 2}
You must {cmd:stset} your data before using {cmd:sts graph}; see
{manhelp stset ST}.{p_end}
{p 4 6 2}
{opt fweight}s, {opt iweight}s, and {opt pweight}s may be specified using
{cmd:stset}; see {manhelp stset ST}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survival analysis > Graphs >}
      {bf:Survivor and cumulative hazard functions}


{marker description}{...}
{title:Description}

{pstd}
{cmd:sts graph} graphs the estimated survivor (failure) function, the
Nelson-Aalen estimated cumulative (integrated) hazard function, or the
estimated hazard function.

{pstd}
{cmd:sts graph} can be used with single- or multiple-record or single- or
multiple-failure st data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ST stsgraphQuickstart:Quick start}

        {mansection ST stsgraphRemarksandexamples:Remarks and examples}

        {mansection ST stsgraphMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt survival}, {opt failure}, {opt cumhaz}, and {opt hazard} specify the
function to graph.

{phang2}
{opt survival} specifies that the Kaplan-Meier survivor function be plotted.
This option is the default if a function is not specified.

{phang2}
{opt failure} specifies that the Kaplan-Meier failure function, 1 - S(t+0), be
plotted.

{phang2}
{opt cumhaz} specifies that the Nelson-Aalen estimate of the cumulative
hazard function be plotted.

{phang2}
{opt hazard} specifies that an estimate of the hazard function be plotted.
This estimate is calculated as a weighted kernel-density estimate using
the estimated hazard contributions.  These hazard contributions are the same
as those obtained by {cmd:sts generate} {newvar} {cmd:= h}.

{phang}
{opth by(varlist)}
estimates a separate function for each by-group and plots all the functions 
on one graph.  By-groups are identified by equal values of the variables in
{it:varlist}.  {opt by()} may not be combined with {opt strata()}.

{phang}
{opth adjustfor(varlist)} adjusts the estimate of the survivor or hazard
functions to that for 0 values of {it:varlist}.  If you want to
adjust the function to values different from 0, you need to center the
variables around those values before issuing the command.  Say that you want
to plot the survivor function adjusted to age of patients and the ages in your
sample are 40 to 60 years. Then

{phang3}{cmd:. sts graph, adjustfor(age)}

{pmore}
will graph the survivor function adjusted to age 0.  If you want to adjust the
function to age 40, type

{phang3}{cmd:. gen age40 = age - 40}{p_end}
{phang3}{cmd:. sts graph, adjustfor(age40)}

{pmore}
{opt adjustfor()} is not available with {opt cumhaz} or {opt ci}.

{pmore}
If you specify {cmd:adjustfor()} with {cmd:by()}, {cmd:sts} fits separate Cox
regression models for each group, using the {cmd:adjustfor()} variables as
covariates. The separately calculated baseline survivor functions are then
retrieved.

{pmore}
If you specify {cmd:adjustfor()} with {cmd:strata()}, {cmd:sts} fits a
stratified-on-group Cox regression model using the {cmd:adjustfor()} variables
as covariates. The stratified, baseline survivor function is then retrieved.

{phang}
{opth strata(varlist)} produces estimates of the survivor (failure) or hazard
functions stratified on variables in {it:varlist} and plots all the groups on
one graph.  It requires specifying {cmd:adjustfor()} and may not be combined
with {cmd:by()}.

{pmore}
If you have more than one {cmd:strata()} variable but need only one, use
{cmd:egen} to create it; see {manhelp egen D}.

{phang}
{opt separate} is meaningful only with {opt by()} or {opt strata()}; it
requests that each group be placed on its own graph rather than one on top of
the other.  Sometimes curves have to be placed on separate graphs -- such as
when you specify {opt ci} -- because otherwise it would be too confusing.

{phang}
{opt ci} includes pointwise confidence bands.  The default is not to produce
these bands.  {opt ci} is not allowed with {opt adjustfor()} or
{helpb pweight}s.

{dlgtab:At-risk table}

{phang}
{cmd:risktable}[{cmd:(}[{it:{help numlist}}][{cmd:,}
	{it:{help sts_graph##table_opts_long:table_options}}]{cmd:)}]
	displays a table showing the number at risk beneath the plot.
        {opt risktable} may not be used with {opt separate} or 
	{opt adjustfor()}.

{phang2}
{opt risktable} displays the table in the default format with number at risk
	shown for each time reported on the {it:x} axis.

{phang2}
{opt risktable}{cmd:(}[{it:{help numlist}}][{cmd:,} 
	{it:{help sts_graph##table_opts_long:table_options}}]{cmd:)} specifies
	that the number at risk be evaluated at the points specified in 
	{it:numlist} or that the rendition of the table be changed by
	{it:table_options}.

{pmore}
There are two ways to change the points at which the numbers at risk are
	evaluated.

{phang3}
	1. The {it:x} axis of the graph may be altered.  For example:

{p 15 19 2}
	{cmd:. sts graph, xlabel(0(5)40) risktable}

{p 12 15 2}
	2. A {it:numlist} can be specified directly in the 
        {cmd:risktable()} option, which affects only the at-risk table.  For
        example:

{p 15 19 2}
	{cmd:. sts graph, risktable(0(5)40)}

{pmore}
The two examples produce the same at-risk table, but the first also
	changes the time labels on the graph's {it:x} axis.

{marker table_opts_long}{...}
{phang2}
{it:table_options} affect the rendition of the at-risk table and may be
any of the following:

{phang3}
{cmd:group(}{bf:#}{it:rownum}|{it:value}|{it:label}{cmd:)} specifies that
        all the suboptions specified in the {cmd:risktable()} apply only to
        the specified group.  Because the {cmd:risktable()} option may be
	repeated, this option allows different rows of the at-risk table to be
	displayed with different colors, font sizes, etc.

{pmore3}
	When both a value and a value label are matched, the value label
        takes precedence.

{pmore3}
{opt risktable()} may be specified with or without the {opt group()} 
	suboption.  When specified without {opt group()}, each suboption is
	applied to all available groups or rows.  {opt risktable()} specified
	without {opt group()} is considered to be global and is itself 
	merged-explicit.
	See {help repeated options} for more information on how repeated 
	options are merged.
	
{pmore3}
Consider the following example:

{p 20 24 2}
{cmd:. sts graph, by(drug) risktable(, color(red) size(small)) risktable(, color(navy))}

{pmore3}
The example above would produce a table where all rows are colored navy with
small text.

{pmore3}
Combining global {opt risktable()} options with group-specific
	{opt risktable()} options can be useful.  When global options are
	combined with group-specific options, group-specific options always
	take precedence.

{pmore3}
Consider the following example:

{p 20 24 2}
{cmd:. sts graph, by(drug) risktable(, color(navy)) risktable(, color(red) group(#1))}

{pmore3}
The example above would produce a table with the first row colored red
and all remaining rows colored navy.

        {dlgtab:Main}
{phang3}
{it:axis_label_options} control the table by using axis labeling
	options. These options are seldom used. See
	{manhelpi axis_label_options G-3}.

{phang3}
{opt order()} specifies which and in what order rows are to appear in the
	at-risk table.  Optionally, {opt order()}
	can be used to override the default text.

{pmore3}
{opt order(# # # ...)} is the syntax used for identifying which
	rows to display and their order.  {cmd:order(1 2 3)}  would specify
	that row 1 is to appear first in the table, followed by row 2, followed
	by row 3.  {cmd:order(1 2 3)} is the default if there are three groups.
	If there were four groups, {cmd:order(1 2 3 4)} would be the default,
	and so on.  If there were four groups and you specified
	{cmd:order(1 2 3)}, the fourth row would not appear in the at-risk
	table.  If you specified {cmd:order(2 1 3)}, row 2 would appear first,
	followed by row 1, followed by row 3.

{pmore3}
{cmd:order(}{it:#} {hi:"}{it:text}{hi:"} {it:#} {hi:"}{it:text}{hi:"} ...{hi:)}
	is the syntax used for specifying the row order and alternate row 
	titles.

{pmore3}
Consider the following at-risk table:

                     {c TLC}{hline 36}{c TRC}
                     {c |}  drug = 1   20    8     2          {c |}
                     {c |}  drug = 2   14    10    4     1    {c |}
                     {c |}  drug = 3   14    13    10    5    {c |}
                     {c BLC}{hline 36}{c BRC}
		
{pmore3}
Specifying {cmd:order(1 "Placebo" 3 2)} would produce

                     {c TLC}{hline 36}{c TRC}
                     {c |}  Placebo    20    8     2          {c |}
                     {c |}  drug = 3   14    13    10    5    {c |}
                     {c |}  drug = 2   14    10    4     1    {c |}
                     {c BLC}{hline 36}{c BRC}
		
{pmore3}	
and specifying {cmd:order(1 "Placebo" 3 "Drug 2" 2 "Drug 1")} would produce

                     {c TLC}{hline 36}{c TRC}
                     {c |}  Placebo    20    8     2          {c |}
                     {c |}  Drug 2     14    13    10    5    {c |}
                     {c |}  Drug 1     14    10    4     1    {c |}
                     {c BLC}{hline 36}{c BRC}

{phang3}
{opt righttitles} specifies that row titles be placed to the right of the
        at-risk values.  The default is to place row titles to the left of the
        at-risk values.

{phang3}
{opt failevents} specifies that the number of failure events be shown
	in parentheses, after the time in which the risk values were calculated.

{phang3}
{marker text_opts_long}{...}
{it:text_options} affect the rendition of both row titles and number at risk
        and may be any of the following:

{p 16 20 2}
{opth size(textsizestyle)} specifies the size of text.

{p 16 20 2}
{opth color(colorstyle)} specifies the color of text.

{p 16 20 2}
{opth justification(justificationstyle)} specifies how text elements
are to be justified.

{p 16 20 2}
{opth format(%fmt)} specifies how numeric values are to be formatted.

{p 16 20 2}
{opth topgap(size)} specifies how much space is to be placed above 
each row.

{p 16 20 2}
{opth bottomgap(size)} specifies how much space is to be placed beneath 
each row.

{p 16 20 2}
{opth style(textstyle)} specifies the style of text.  This option does not
appear on the dialog box.

        {dlgtab:Row titles}

{phang3}
{cmd:rowtitle(}[{it:text}] [{cmd:,} {it:rtext_options}]{cmd:)} changes the
	default text or rendition of row titles.  Specifying 
	{cmd:rowtitle(, color(navy))} would change the color of all row
	titles to navy.

{pmore3}
	{cmd:rowtitle()} is often combined with {cmd:group()} to change the
	text or rendition of a title.
	Specifying {bind:{cmd:rowtitle(Placebo)} {cmd:group(#2)}} would 
	change the title of the second row to {cmd:Placebo}.
	Specifying {bind:{cmd:rowtitle(, color(red))} {cmd:group(#3)}} 
	would change the color of the row title for the third row to red.
	
{pmore3}
	Row titles may include more than one line.  Lines are specified 
	one after the other, each enclosed in double quotes.
	Specifying {cmd:rowtitle("Experimental drug") group(#1)} would
	produce a one-line row title, and specifying
	{cmd:rowtitle("Experimental" "Drug") group(#1)} would produce 
	a multiple-line row title.
	
{pmore3}
       {it:rtext_options} affect the rendition of both row titles and number
       at risk and may be any of the following:

{p 20 24 2}
{opth size(textsizestyle)} specifies the size of text.

{p 20 24 2}
{opth color(colorstyle)} specifies the color of text.

{p 20 24 2}
{opth justification(justificationstyle)} specifies how text elements
are to be justified.

{p 20 24 2}
{opt at(#)} allows you to reposition row titles or the overall table title 
to align with a specific location on the {it:x} axis.

{p 20 24 2}
{opth topgap(size)} specifies how much space is to be placed above 
each row.

{p 20 24 2}
{opth style(textstyle)} specifies the style of text.  This option does not
appear in the dialog box.

        {dlgtab:Title}

{phang3}
{cmd:title(}[{it:title}] [{cmd:,} {it:ttext_options}]{cmd:)} 
	may be used to override the default title for the at-risk table 
	and affect the rendition of its text.

{pmore3}
	Titles may include one line of text or multiple lines.
	{cmd:title("At-risk table")} will produce a one-line title,
	and {cmd:title("At-risk" "table")} will produce a multiple-line title.

{pmore3}
       {it:ttext_options} affect the rendition of both row titles and number
       at risk and may be any of the following:

{p 20 24 2}
{opth size(textsizestyle)} specifies the size of text.

{p 20 24 2}
{opth color(colorstyle)} specifies the color of text.

{p 20 24 2}
{opth justification(justificationstyle)} specifies how text elements
are to be justified.

{p 20 24 2}
{opt at(#)} allows you to reposition row titles or the overall table title 
to align with a specific location on the {it:x} axis.

{p 24 24 2}
{cmd:at(rowtitles)} places the overall table title at the default position calculated for the row titles.  This option is sometimes useful for alignment when the default justification has not been used. 

{p 20 24 2}
{opth topgap(size)} specifies how much space is to be placed above 
each row.

{p 20 24 2}
{opth bottomgap(size)} specifies how much space is to be placed
beneath each row.

{p 20 24 2}
{opth style(textstyle)} specifies the style of text.  This option does not
appear on the dialog box.

{dlgtab:Options}

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for the
pointwise confidence interval around the survivor, failure, or cumulative
hazard function; see {manhelp level R}.

{phang}
{opt per(#)} specifies the units used to report the survival or failure rates.
For example, if the analysis time is in years, specifying {cmd:per(100)}
results in rates per 100 person-years.

{phang}
{opt noshow} prevents {cmd:sts graph} from showing the key st variables.  This
option is seldom used because most people type {cmd:stset, show} or 
{cmd:stset, noshow} to set whether they want to see these variables mentioned
at the top of the output of every st command; see {manhelp stset ST}.

{phang}
{opt tmax(#)} specifies that the plotted curve be graphed only for t <=
{it:#}.  This option does not affect the calculation of the function, rather
the portion that is displayed.

{phang}
{opt tmin(#)} specifies that the plotted curve be graphed only for t >=
{it:#}.  This option does not affect the calculation of the function, rather
the portion that is displayed.

{phang}
{opt noorigin} requests that the plot of the survival (failure) curve begin at
the first exit time instead of beginning at t=0 (the default).  This option is
ignored when {opt cumhaz} or {opt hazard} is specified.

{phang}
{cmd:width(}{it:#} [{it:#} ...]{cmd:)} is for use with {opt hazard} and
specifies the bandwidth to be used in the kernel smooth used to plot the
estimated hazard function.  If {opt width()} is not specified, a default
bandwidth is used as described in {manhelp kdensity R}.  If it is used with
{opt by()}, multiple bandwidths may be specified, one for each
group.  If there are more groups than the {it:k} bandwidths specified, the
default bandwidth is used for the {it:k}+1, ... remaining groups.  If any
bandwidth is specified as {cmd:.} (dot), the default bandwidth is used for
that group.

{phang}
{opt kernel(kernel)} is for use with {opt hazard} and
specifies the kernel function to be used in calculating the weighted
kernel-density estimate required to produce a smoothed hazard-function
estimator.  The default kernel is Epanechnikov, yet {it:kernel} may be any of
the kernels supported by {cmd:kdensity}; see {manhelp kdensity R}.

{phang}
{opt noboundary} is for use with {opt hazard}.  It specifies that no
boundary-bias adjustments are to be made when calculating the smoothed
hazard-function estimator.  By default, the smoothed hazards are adjusted near
the boundaries.  If the {opt epan2}, {opt biweight}, or {opt rectangular}
kernel is used, the bias correction near the boundary is performed using
boundary kernels.  For other kernels, the plotted range of the smoothed hazard
function is restricted to be within one bandwidth of each endpoint.  For these
other kernels, specifying {opt noboundary} merely removes this range
restriction.

{phang}
{opt lost} specifies that the number lost be shown on the plot.
This number is shown in a small size above each flat part of the
plotted function.

{pmore}
If {opt enter} is not specified, then the number displayed is the number
censored minus the number who enter.  If {opt enter} is specified, then the
number displayed is the pure number censored.  The underlying logic is
described in {bf:[ST] sts}.

{pmore}
{opt lost} may not be used with {opt hazard}.

{phang}
{opt enter} specifies that the number who enter be shown on the plot,
as well as the number lost.  The number who enter is shown in a small
size beneath each flat part of the plotted function.

{pmore}
{opt enter} may not be used with {opt hazard}.

{phang}
{opt atrisk} specifies that the number at risk at the beginning of each
interval be shown on the plot.  This number is shown in a small
size beneath each flat part of the plotted function.

{pmore}
{opt atrisk} may not be used with {opt hazard}.

{phang}
{cmd:censored(single} | {cmd:number} | {cmd:multiple)} specifies that
hash marks be placed on the graph to indicate censored observations.

{phang2}
{cmd:censored(single)} places one hash mark at each censoring time, regardless
of the number of censorings at that time.

{phang2}
{cmd:censored(number)} places one hash mark at each censoring time and
displays the number of censorings about the hash mark.

{phang2}
{cmd:censored(multiple)} places multiple hash marks for multiple censorings
at the same time.  For instance, if 3 observations are censored at time 5,
three hash marks are placed at time 5.  {cmd:censored(multiple)} is intended for
use when there are few censored observations; if there are too many censored
observations, the graph can look bad.  In such cases, we recommend that
{cmd:censored(number)} be used.

{pmore}
{opt censored()} may not be used with {opt hazard}.

{phang}
{opt censopts(hash_options)} specifies options that affect how the hash marks
for censored observations are rendered; see {manhelpi line_options G-3}.
When combined with {cmd:censored(number)}, {cmd:censopts()} also specifies how
the count of censoring is rendered; see {manhelpi marker_label_options G-3},
except {cmd:mlabel()} is not allowed.

{phang}
{opt lostopts(marker_label_options)} specifies options that affect how the
numbers lost are rendered; see {manhelpi marker_label_options G-3}.  This option
implies the {opt lost} option.

{phang}
{opt atriskopts(marker_label_options)} specifies options that affect how the
numbers at risk are rendered; see {manhelpi marker_label_options G-3}.  This 
option implies the {opt atrisk} option.

{dlgtab:Plot}

{phang}
{opt plotopts(cline_options)} affects the rendition of the plotted
lines; see {manhelpi cline_options G-3}.  This option may not be combined with
{opth by(varlist)} or {opt strata(varlist)}, unless {opt separate} is also
specified.

{phang}
{cmd:plot}{it:#}{cmd:opts(}{it:cline_options}{cmd:)} affects the
rendition of the {it:#}th plotted line; see {manhelpi cline_options G-3}.  This
option may not be combined with {opt separate}.

{dlgtab:CI plot}

{phang}
{opt ciopts(area_options)} affects the rendition of the confidence
bands; see {manhelpi area_options G-3}.  This option may not be combined with
{opth by(varlist)} or {opt strata(varlist)}, unless {opt separate} is also
specified.

{phang}
{cmd:ci}{it:#}{cmd:opts(}{it:area_options}{cmd:)} affects the rendition
of the {it:#}th confidence band; see {manhelpi area_options G-3}.  This option
may not be combined with {opt separate}.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the generated
graph; see {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}.  These include options for titling the graph 
(see {manhelpi title_options G-3}) and for saving the graph to disk (see
{manhelpi saving_option G-3}).

{phang}
{opt byopts(byopts)} affects the appearance of the combined graph when
{cmd:by()} or {cmd:adjustfor()} is specified, including the overall graph
title and the organization of subgraphs.
{cmd:byopts()} may not be specified with {opt separate}.
See {manhelpi by_option G-3}.


{marker examples}{...}
{title:Example: Including the number lost on the graph}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse drug2b}

{pstd}Graph the survivor functions for the two categories of {cmd:drug} and
include the number lost due to censoring as small numbers on the plots{p_end}
{phang2}{cmd:. sts graph, by(drug) lost}

{pstd}Same as above, but show the number entered and the number lost{p_end}
{phang2}{cmd:. sts graph, by(drug) enter}


{title:Example: Graphing the Nelson-Aalen cumulative hazard function}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse drug2}

{pstd}Graph the cumulative hazard functions for the two categories of
{cmd:drug}{p_end}
{phang2}{cmd:. sts graph, cumhaz by(drug)}

{pstd}Same as above, but include the number lost due to censoring as small
numbers on the plots{p_end}
{phang2}{cmd:. sts graph, cumhaz by(drug) lost}


{title:Example: Graphing the hazard function}

{pstd}Graph the hazard functions for the two categories of {cmd:drug}{p_end}
{phang2}{cmd:. sts graph, hazard by(drug)}

{pstd}Same as above, but use a Gaussian kernel with a bandwidth of 5 for
{cmd:drug} = 0 and 7 for {cmd:drug} = 1{p_end}
{phang2}{cmd:. sts graph, hazard by(drug) kernel(gauss) width(5 7)}


{title:Example: Adding an at-risk table}

{pstd}Graph the survivor functions for the two categories of {cmd:drug} in one
plot, including an at-risk table below the graph{p_end}
{phang2}{cmd:. sts graph, by(drug) risktable}

{pstd}Same as above, but put the legend inside the plot rather than below
it{p_end}
{phang2}{cmd:. sts graph, by(drug) risktable}
                   {cmd:legend(ring(0) position(2) rows(2))}

{pstd}Graph the survivor functions for the two categories of {cmd:drug} in one
plot, including an at-risk table below the graph and using the specified row
titles and order of rows for the at-risk table{p_end}
{phang2}{cmd:. sts graph, by(drug)}
                    {cmd:risktable(, order(1 "Placebo" 2 "Test drug"))}

{pstd}Same as above, but left-justify the row titles in the at-risk
table{p_end}
{phang2}{cmd:. sts graph, by(drug)}
                     {cmd:risktable(, order(1 "Placebo" 2 "Test drug")}
                     {cmd:rowtitle(, justification(left)))}

{pstd}Same as above, but align the table title with the rwo titles{p_end}
{phang2}{cmd:. sts graph, by(drug)}
                     {cmd:risktable(, order(1 "Placebo" 2 "Test drug")}
                     {cmd:rowtitle(, justification(left))}
		     {cmd:title(, at(rowtitle)))}{p_end}


{marker video}{...}
{title:Video example}

{phang}
{browse "https://www.youtube.com/watch?v=3MoWoZQCrUI&list=UUVk4G4nEtBS4tLOyHqustDA":How to graph survival curves}
{p_end}
