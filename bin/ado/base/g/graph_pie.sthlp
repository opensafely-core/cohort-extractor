{smcl}
{* *! version 1.1.18  16apr2019}{...}
{viewerdialog "graph pie" "dialog graph_pie"}{...}
{vieweralsosee "[G-2] graph pie" "mansection G-2 graphpie"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph" "help graph"}{...}
{vieweralsosee "[G-2] graph bar" "help graph_bar"}{...}
{viewerjumpto "Syntax" "graph_pie##syntax"}{...}
{viewerjumpto "Menu" "graph_pie##menu"}{...}
{viewerjumpto "Description" "graph_pie##description"}{...}
{viewerjumpto "Links to PDF documentation" "graph_pie##linkspdf"}{...}
{viewerjumpto "Options" "graph_pie##options"}{...}
{viewerjumpto "Remarks" "graph_pie##remarks"}{...}
{viewerjumpto "References" "graph_pie##references"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[G-2] graph pie} {hline 2}}Pie charts{p_end}
{p2col:}({mansection G-2 graphpie:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 4 6 2}
Slices as totals or percentages of each variable

{p 8 23 2}
{cmdab:gr:aph} {cmd:pie} {varlist} {ifin}
[{it:{help graph pie##weight:weight}}]
[{cmd:,} {it:options}]

{p 4 6 2}
Slices as totals or percentages within {cmd:over()} categories

{p 8 23 2}
{cmdab:gr:aph} {cmd:pie} {varname} {ifin}
[{it:{help graph pie##weight:weight}}]{cmd:,} 
{cmd:over(}{varname}{cmd:)} [{it:options}]

{p 4 6 2}
Slices as frequencies within {cmd:over()} categories

{p 8 23 2}
{cmdab:gr:aph} {cmd:pie} {ifin} 
[{it:{help graph pie##weight:weight}}]{cmd:,} 
	{cmd:over(}{varname}{cmd:)} [{it:options}]


{marker pie_options}{...}
{synoptset 22 tabbed}{...}
{p2col: {it:options}}Description{p_end}
{p2line}
{p2coldent:* {cmd:over(}{varname}{cmd:)}}slices are distinct values of
      {it:varname}{p_end}
{synopt: {cmdab:miss:ing}}do not ignore missing values of {varname}{p_end}
{synopt: {cmdab:allc:ategories}}include all categories in the dataset{p_end}

{synopt: {cmd:cw}}casewise treatment of missing values{p_end}

{synopt: {cmdab:nocl:ockwise}}counterclockwise pie chart{p_end}
{synopt: {cmdab:ang:le0(}{it:#}{cmd:)}}angle of first slice; default is
       {cmd:angle(90)}{p_end}

{synopt: {cmd:sort}}put slices in size order{p_end}
{synopt: {cmd:sort(}{it:varname}{cmd:)}}put slices in {it:varname} order{p_end}
{synopt: {cmdab:des:cending}}reverse default or specified order{p_end}

{synopt: {cmdab:p:ie:(...)}}look of slice, including explosion{p_end}
{synopt: {cmdab:pl:abel(...)}}labels to appear on the slice{p_end}
{synopt: {cmdab:pt:ext:(...)}}text to appear on the pie{p_end}
{synopt: {cmdab:i:ntensity(}[{cmd:*}]{it:#}{cmd:)}}color intensity of slices
      {p_end}
{synopt: {cmdab:li:ne(}{it:{help line_options}}{cmd:)}}outline of slices{p_end}
{p2col:{cmdab:pcyc:le:(}{it:#}{cmd:)}}slice styles before 
	{help pstyle:{it:pstyle}s} recycle{p_end}

{synopt: {bf:{help legend_options:legend(...)}}}legend explaining slices{p_end}
{synopt: {it:{help std_options}}}titles, saving to disk{p_end}

{synopt: {help by_option:{bf:by(}{it:varlist}{bf:, ...)}}}repeat for subgroups
      {p_end}
{p2line}
{p2colreset}{...}
{p 4 6 2}* {opt over(varname)} is required in syntaxes 2 and 3.{p_end}

{marker pie_subopts}{...}
{pstd}
The syntax of the {cmd:pie()} option is

{pin}
{cmdab:p:ie:(}{c -(}{it:{help numlist}}|{cmd:_all}{c )-}
[{cmd:,}
{it:pie_subopts}]{cmd:)}

{synoptset 22}{...}
{p2col : {it:pie_subopts}}Description{p_end}
{p2line}
{p2col : {cmd:explode}}explode slice by {it:size}=3.8{p_end}
{p2col : {cmd:explode(}{it:{help size}}{cmd:)}}explode slice by
           {it:size}{p_end}
{p2col : {cmdab:c:olor(}{it:{help colorstyle}}{cmd:)}}color and opacity of slice{p_end}
{p2line}

{marker plabel_subopts}{...}
{pstd}
The syntax of the {cmd:plabel()} option is

{pin}
{cmdab:pl:abel:(}{c -(}{it:#}|{cmd:_all}{c )-}
{c -(}{cmd:sum}|{cmdab:per:cent}|{cmd:name}|{cmd:"}{it:text}{cmd:"}{c )-}
[{cmd:,} {it:plabel_subopts}]{cmd:)}

{p2col : {it:plabel_subopts}}Description{p_end}
{p2line}
{p2col : {cmdab:for:mat:(}{help format:{bf:%}{it:fmt}}{cmd:)}}display format
          for {cmd:sum} or {cmd:percent}{p_end}
{p2col : {cmd:gap(}{it:{help size}}{cmd:)}}additional radial distance
            {p_end}
{p2col : {it:{help textbox_options}}}look of label{p_end}
{p2line}

{marker ptext_subopts}{...}
{pstd}
The syntax for the {cmd:ptext()} option is

{pin}
{cmdab:pt:ext:(}{it:#_a}
{it:#_r}
{cmd:"}{it:text}{cmd:"}
[{cmd:"}{it:text}{cmd:"} ...]
[{it:#_a} {it:#_r} ...]
[{cmd:,} {it:ptext_subopts}]{cmd:)}

{p2col:{it:ptext_subopts}}Description{p_end}
{p2line}
{p2col:{it:{help textbox_options}}}look of added text{p_end}
{p2line}

{marker weight}{...}
{pstd}
{cmd:aweight}s, {cmd:fweight}s, and {cmd:pweight}s are
allowed; see {help weight}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Pie chart}


{marker description}{...}
{title:Description}

{pstd}
{cmd:graph} {cmd:pie} draws pie charts.

{pstd}
{cmd:graph} {cmd:pie} has three modes of operation.  The first corresponds
to the specification of two or more variables:

{phang2}
	{cmd:. graph pie div1_revenue div2_revenue div3_revenue}

{pstd}
Three pie slices are drawn, the first corresponding to the sum of variable
{cmd:div1_revenue}, the second to the sum of {cmd:div2_revenue}, and the
third to the sum of {cmd:div3_revenue}.

{pstd}
The second mode of operation corresponds to the specification of one
variable and the {cmd:over()} option:

	{cmd:. graph pie revenue, over(division)}

{pstd}
Pie slices are drawn for each value of variable {cmd:division}; the first slice
corresponds to the sum of revenue for the first division, the second to the
sum of revenue for the second division, and so on.

{pstd}
The third mode of operation corresponds to the specification of {cmd:over()}
with no variables:

	{cmd:. graph pie, over(popgroup)}

{pstd}
Pie slices are drawn for each value of variable {cmd:popgroup}; the slices
correspond to the number of observations in each group.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphpieQuickstart:Quick start}

        {mansection G-2 graphpieRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:over(}{varname}{cmd:)}
    specifies a categorical variable to correspond to the pie slices.
    {it:varname} may be string or numeric.

{phang}
{cmd:missing}
    is for use with {cmd:over()}; it specifies that missing values of
    {varname} not be ignored.  Instead, separate slices are to
    be formed for {it:varname}=={cmd:.}, {it:varname}=={cmd:.a}, ..., or
    {it:varname}=="".

{phang}
{cmd:allcategories}
    specifies that all categories in the entire dataset be retained for the
    {cmd:over()} variables.  When {cmd:if} or {cmd:in} is specified without
    {cmd:allcategories}, the graph is drawn, completely excluding any
    categories for the {cmd:over()} variables that do not occur in the
    specified subsample.  With the {cmd:allcategories} option, categories that
    do not occur in the subsample still appear in the legend, and zero-sized
    slices are drawn where these categories would appear.  Such behavior can be
    convenient when comparing graphs of subsamples that do not include
    completely common categories for all {cmd:over()} variables.  This option
    has an effect only when {cmd:if} or {cmd:in} is specified or if there are
    missing values in the variables.  {cmd:allcategories} may not be combined
    with {cmd:by()}.

{phang}
{cmd:cw}
    specifies casewise deletion and is for use when {cmd:over()} is
    not specified.  {cmd:cw} specifies that, in calculating the sums,
    observations be ignored for which any of the variables in {it:varlist}
    contain missing values.  The default is to calculate sums
    for each variable by using all nonmissing observations.

{phang}
{cmd:noclockwise}
and
{cmd:angle0(}{it:#}{cmd:)}
    specify how the slices are oriented on the pie.  The default is
    to start at 12 o'clock (known as {cmd:angle(90)}) and to proceed clockwise.

{pmore}
    {cmd:noclockwise} causes slices to be placed counterclockwise.

{pmore}
    {cmd:angle0(}{it:#}{cmd:)} specifies the angle at which the first
    slice is to appear.  Angles are recorded in degrees and measured in the
    usual mathematical way:  counterclockwise from the horizontal.

{phang}
{cmd:sort},
{cmd:sort(}{varname}{cmd:)}, and
{cmd:descending}
    specify how the slices are to be ordered.  The default is to put the
    slices in the order specified; see
    {it:{help graph pie##remarks4:How slices are ordered}} under {it:Remarks}
    below.

{pmore}
    {cmd:sort} specifies that the smallest slice be put first, followed
    by the next largest, etc.  See
    {it:{help graph pie##remarks5:Ordering slices by size}} under {it:Remarks}
    below.

{pmore}
    {cmd:sort(}{it:varname}{cmd:)} specifies that the slices be put in
    (ascending) order of {it:varname}.  See
    {it:{help graph pie##remarks6:Reordering the slices}} under {it:Remarks}
    below.

{pmore}
    {cmd:descending}, which may be specified whether or not {cmd:sort} or
    {cmd:sort(}{it:varname}{cmd:)} is specified, reverses the order.

{phang}
{cmd:pie(}{c -(}{it:{help numlist}}|{cmd:_all}{c )-}{cmd:,} {it:pie_subopts}{cmd:)}
    specifies the look of a slice or of a set of slices.
    This option allows you to "explode" (offset) one or more slices
    of the pie and to control the color of the slices.  Examples include

{phang2}
	    {cmd:. graph pie ..., ... pie(2, explode)}

{phang2}
	    {cmd:. graph pie ..., ... pie(2, explode color(red))}

{phang2}
	    {cmd:. graph pie ..., ... pie(2, explode color(red)) pie(5, explode)}

{pmore}
    {it:numlist} specifies the slices; see {it:{help numlist}}.
    The slices (after any sorting) are referred to as slice 1, slice 2,
    etc.  {cmd:pie(1} ...{cmd:)} would change the look of the first slice.
    {cmd:pie(2} ...{cmd:)} would change the look of the second slice.
    {cmd:pie(1 2 3} ...{cmd:)} would change the look of the first through
    third slices, as would {cmd:pie(1/3} ...{cmd:)}.  The {cmd:pie()} option
    may be specified more than once to specify a different look for different
    slices.   You may also specify {cmd:pie(_all} ...{cmd:)}
    to specify a common characteristic for all slices.

{pmore}
    The {it:pie_subopts} are {cmd:explode},
    {cmd:explode(}{it:size}{cmd:)}, and
    {cmd:color(}{it:colorstyle}{cmd:)}.

{pmore}
    {cmd:explode} and {cmd:explode(}{it:size}{cmd:)} specify that
    the slice be offset.  Specifying {cmd:explode} is equivalent
    to specifying {cmd:explode(3.8)}.
    {cmd:explode(}{it:size}{cmd:)} specifies by how much
    (measured radially) the slice is to be offset; see 
    {manhelpi size G-4}.

{pmore}
    {cmd:color(}{it:colorstyle}{cmd:)} sets the color and opacity of the slice.
    See {manhelpi colorstyle G-4} for a list of color choices.

{phang}
{cmdab:pl:abel:(}{c -(}{it:#}|{cmd:_all}{c )-}
{c -(}{cmd:sum}|{cmdab:per:cent}|{cmd:name}|{cmd:"}{it:text}{cmd:"}{c )-}{cmd:,} {it:plabel_subopts}{cmd:)}
    specifies labels to appear on the slice.  Slices may be labeled with their
    sum, their percentage of the overall sum, their identity, or with text you
    specify.  The default is that no labels appear.  Think of the syntax of
    {cmd:plabel()} as

		     {it:which              what                   how}
		    {hline 7}   {hline 25}   {hline 14}
	    {cmd:plabel(} {c -(}{it:#}|{cmd:_all}{c )-}  {c -(}{cmd:sum}|{cmd:percent}|{cmd:name}|{cmd:"}{it:text}{cmd:"}{c )-} {cmd:,} {it:plabel_subopts} {cmd:)}
		    {hline 3}{c TT}{hline 3}   {hline 12}{c TT}{hline 12}   {hline 7}{c TT}{hline 6}
		       {c |}                  {c |}                      {c |}
	 {hline 14}{c BT}{hline 5}             {c |}            {hline 10}{c BT}{hline 13}
	 which slice to label             {c |}            how the label is to look
					  {c |}
			      {hline 12}{c BT}{hline 16}
			      what to label the slice with:
				{cmd:sum}       sum of variable
				{cmd:percent}   percent of sum
				{cmd:name}      identity
				{cmd:"}{it:text}{cmd:"}    text specified

{pmore}
    Thus you might type

	    {cmd:. graph pie} ...{cmd:,} ... {cmd:plabel(_all sum)}

	    {cmd:. graph pie} ...{cmd:,} ... {cmd:plabel(_all percent)}

	    {cmd:. graph pie} ...{cmd:,} ... {cmd:plabel(1 "New appropriation")}

{pmore}
    The {cmd:plabel()} option may appear more than once, so you might also
    type

	    {cmd:. graph pie} ...{cmd:,} ... {cmd:plabel(1 "New appropriation") plabel(2 "old")}

{pmore}
    If you choose to label the slices with their identities, you will probably
    also want to suppress the legend:

	    {cmd:. graph pie} ...{cmd:,} ... {cmd:plabel(_all name) legend(off)}

{pmore}
    The {it:plabel_subopts} are {cmd:format(%}{it:fmt}{cmd:)},
    {cmd:gap(}{it:size}{cmd:)}, and {it:textbox_options}.

{pmore}
    {cmd:format(%}{it:fmt}{cmd:)} specifies the display format to be used
    to format the number when {cmd:sum} or {cmd:percent} is chosen;
    see {manhelp format D}.

{pmore}
    {cmd:gap(}{it:size}{cmd:)}
    specifies a radial distance from the origin by which the usual location
    of the label is to be adjusted.
    {cmd:gap(0)} is the default.
    {cmd:gap(}{it:#}{cmd:)}, {it:#<0}, moves the text inward.
    {cmd:gap(}{it:#}{cmd:)}, {it:#>0}, moves the text outward.
    See {manhelpi size G-4}.

{pmore}
    {it:textbox_options} specify the size, color, etc., of the text; see 
    {manhelpi textbox_options G-3}.

{phang}
{cmd:ptext(}{it:#_a}
{it:#_r}
{cmd:"}{it:text}{cmd:"}
[{cmd:"}{it:text}{cmd:"} ...]
[{it:#_a} {it:#_r} ...]{cmd:,} {it:ptext_subopts}{cmd:)}
    specifies additional text to appear on the pie.  The position of the text
    is specified by the polar coordinates {it:#_a} and {it:#_r}.  {it:#_a}
    specifies the angle in degrees, and {it:#_r} specifies the distance from
    the origin; see {manhelpi size G-4}. 

{phang}
{cmd:intensity(}{it:#}{cmd:)}
and
{cmd:intensity(*}{it:#}{cmd:)}
    specify the intensity of the color used to fill the slices.
    {cmd:intensity(}{it:#}{cmd:)} specifies the intensity, and
    {cmd:intensity(*}{it:#}{cmd:)} specifies the intensity relative to the
    default.

{pmore}
    Specify {cmd:intensity(*}{it:#}{cmd:)}, {it:#}<1, to attenuate the
    interior color and specify {cmd:intensity(*}{it:#}{cmd:)}, {it:#}>1,
    to amplify it.

{pmore}
    Specify {cmd:intensity(0)} if you do not want the slice filled at all.

{phang}
{cmd:line(}{it:line_options}{cmd:)}
    specifies the look of the line used to outline the slices.
    See {manhelpi line_options G-3}, but ignore option
    {cmd:lpattern()}, which is not allowed for pie charts.

{phang}
{cmd:pcycle(}{it:#}{cmd:)}
    specifies how many slices are to be plotted before the
    {help pstyle:{it:pstyle}} of
    the slices for the next slice begins again at the {it:pstyle} of the
    first slice -- {cmd:p1pie} (with the slices following that using 
    {cmd:p2pie}, {cmd:p3pie}, and so on).  Put another way: {it:#} specifies
    how quickly the look of slices is recycled when more than {it:#} slices
    are specified.  The default for most {help schemes} is {cmd:pcycle(15)}.

{phang}
{cmd:legend()}
    allows you to control the legend.
    See {manhelpi legend_options G-3}.

{phang}
{it:std_options}
    allow you to add titles, save the graph on disk, and more; see
    {manhelpi std_options G-3}.

{phang}
{cmd:by(}{it:varlist}{cmd:,} ...{cmd:)}
    draws separate pies within one graph; see 
    {manhelpi by_option G-3} and see
    {it:{help graph pie##remarks7:Use with by()}} under {it:Remarks} below.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help graph pie##remarks1:Typical use}
	{help graph pie##remarks2:Data are summed}
	{help graph pie##remarks3:Data may be long rather than wide}
	{help graph pie##remarks4:How slices are ordered}
	{help graph pie##remarks5:Ordering slices by size}
	{help graph pie##remarks6:Reordering the slices}
	{help graph pie##remarks7:Use with by()}
	{help graph pie##video:Video example}
	{help graph pie##remarks8:History}


{marker remarks1}{...}
{title:Typical use}

{pstd}
We have been told that the expenditures for XYZ Corp. are
$12 million in sales, $14 million in marketing, $2 million in research, and $8
million in development:

	{cmd:. input sales marketing research development}

	     {txt}    sales  marketing   research  develop~t
	  1{cmd}. 12 14 2 8
	{txt}  2{cmd}. end{txt}

	{cmd}. label var sales "Sales"{txt}

	{cmd}. label var market "Marketing"{txt}

	{cmd}. label var research "Research"{txt}

	{cmd}. label var develop  "Development"{txt}

	{cmd:. graph pie sales marketing research development,}
		{cmd:plabel(_all name, size(*1.5) color(white))}{col 66}{it:(Note 1)}
		{cmd:legend(off)}{col 66}{it:(Note 2)}
		{cmd:plotregion(lstyle(none))}{col 66}{it:(Note 3)}
		{cmd:title("Expenditures, XYZ Corp.")}
		{cmd:subtitle("2002")}
		{cmd:note("Source:  2002 Financial Report (fictional data)")}
	  {it:({stata "gr_example2 pie1":click to run})}
{* graph grpie1}{...}

{pstd}
Notes:

{phang2}
1.  We specified {cmd:plabel(_all} {cmd:name)} to put the division names on the
    slices.  We specified {cmd:plabel()}'s textbox-option {cmd:size(*1.5)}
    to make the text 50% larger than usual.
    We specified {cmd:plabel()}'s textbox-option {cmd:color(white)} to
    make the text white.
    See {manhelpi textbox_options G-3}.

{phang2}
2.  We specified the legend-option {cmd:legend(off)} to keep the division names
    from being repeated in a key at the bottom of the graph;
    see {manhelpi legend_options G-3}.

{phang2}
3.  We specified the region-option {cmd:plotregion(lstyle(none))} to
    prevent a border from being drawn around the plot area;
    see {manhelpi region_options G-3}.


{marker remarks2}{...}
{title:Data are summed}

{pstd}
Rather than having the above summary data, we have

	{cmd:. list}
	     {c TLC}{hline 5}{c -}{hline 7}{c -}{hline 11}{c -}{hline 10}{c -}{hline 13}{c TRC}
	     {c |} {res}qtr   sales   marketing   research   development {txt}{c |}
	     {c LT}{hline 5}{c -}{hline 7}{c -}{hline 11}{c -}{hline 10}{c -}{hline 13}{c RT}
	  1. {c |} {res}  1       3         4.5         .3             1 {txt}{c |}
	  2. {c |} {res}  2       4           3         .5             2 {txt}{c |}
	  3. {c |} {res}  3       3           4         .6             2 {txt}{c |}
	  4. {c |} {res}  4       2         2.5         .6             3 {txt}{c |}
	     {c BLC}{hline 5}{c -}{hline 7}{c -}{hline 11}{c -}{hline 10}{c -}{hline 13}{c BRC}{txt}

{pstd}
The sums of these data are the same as the totals in the previous
section.  The same {cmd:graph} {cmd:pie} command

{phang2}
	{cmd:. graph pie sales marketing research development,} ...

{pstd}
will result in the same chart.


{marker remarks3}{...}
{title:Data may be long rather than wide}

{pstd}
Rather than having the quarterly data in wide form, we have it in the
long form:

	{cmd}. list, sepby(qtr)
	{txt}
	     {c TLC}{hline 5}{c -}{hline 13}{c -}{hline 6}{c TRC}
	     {c |} {res}qtr      division   cost {txt}{c |}
	     {c LT}{hline 5}{c -}{hline 13}{c -}{hline 6}{c RT}
	  1. {c |} {res}  1   Development      1 {txt}{c |}
	  2. {c |} {res}  1     Marketing    4.5 {txt}{c |}
	  3. {c |} {res}  1      Research     .3 {txt}{c |}
	  4. {c |} {res}  1         Sales      3 {txt}{c |}
	     {c LT}{hline 5}{c -}{hline 13}{c -}{hline 6}{c RT}
	  5. {c |} {res}  2   Development      2 {txt}{c |}
	  6. {c |} {res}  2     Marketing      3 {txt}{c |}
	  7. {c |} {res}  2      Research     .5 {txt}{c |}
	  8. {c |} {res}  2         Sales      4 {txt}{c |}
	     {c LT}{hline 5}{c -}{hline 13}{c -}{hline 6}{c RT}
	  9. {c |} {res}  3   Development      2 {txt}{c |}
	 10. {c |} {res}  3     Marketing      4 {txt}{c |}
	 11. {c |} {res}  3      Research     .6 {txt}{c |}
	 12. {c |} {res}  3         Sales      3 {txt}{c |}
	     {c LT}{hline 5}{c -}{hline 13}{c -}{hline 6}{c RT}
	 13. {c |} {res}  4   Development      3 {txt}{c |}
	 14. {c |} {res}  4     Marketing    2.5 {txt}{c |}
	 15. {c |} {res}  4      Research     .6 {txt}{c |}
	 16. {c |} {res}  4         Sales      2 {txt}{c |}
	     {c BLC}{hline 5}{c -}{hline 13}{c -}{hline 6}{c BRC}{txt}


{pstd}
Here rather than typing

{phang2}
	{cmd:. graph pie sales marketing research development,} ...

{pstd}
we type

	{cmd:. graph pie cost, over(division)} ...

{pstd}
For example,

	{cmd:. graph pie cost, over(division),}
		{cmd:plabel(_all name, size(*1.5) color(white))}
		{cmd:legend(off)}
		{cmd:plotregion(lstyle(none))}
		{cmd:title("Expenditures, XYZ Corp.")}
		{cmd:subtitle("2002")}
		{cmd:note("Source:  2002 Financial Report (fictional data)")}
	  {it:({stata "gr_example2 pie2":click to run})}
{* graph grpie2}{...}

{pstd}
This is the same pie chart as the one drawn previously, except for the order in
which the divisions are presented.


{marker remarks4}{...}
{title:How slices are ordered}

{pstd}
When we type

{phang2}
	{cmd:. graph pie sales marketing research development,} ...

{pstd}
the slices are presented in the order we specify.  When we type

	{cmd:. graph pie cost, over(division)} ...

{pstd}
the slices are presented in the order implied by variable division.
If division is numeric, slices are presented in ascending order
of division.  If division is string, slices are presented in
alphabetical order (except that all capital letters occur before lowercase
letters).


{marker remarks5}{...}
{title:Ordering slices by size}

{pstd}
Regardless of whether we type

{phang2}
	{cmd:. graph pie sales marketing research development,} ...

{pstd}
or

	{cmd:. graph pie cost, over(division)} ...

{pstd}
if we add the {cmd:sort} option, slices will be presented in the
order of the size, smallest first:

{phang2}
	{cmd:. graph pie sales marketing research development, sort} ...

	{cmd:. graph pie cost, over(division) sort} ...

{pstd}
If we also specify the {cmd:descending} option, the largest slice will
be presented first:

{phang2}
	{cmd:. graph pie sales marketing research development, sort descending} ...

{phang2}
	{cmd:. graph pie cost, over(division) sort descending} ...


{marker remarks6}{...}
{title:Reordering the slices}

{pstd}
If we wish to force a particular order, then if we type

{phang2}
	{cmd:. graph pie sales marketing research development,} ...

{pstd}
specify the variables in the desired order.  If we type

	{cmd:. graph pie cost, over(division)} ...

{pstd}
then create a numeric variable that has a one-to-one correspondence with
the order in which we wish the divisions to appear.  For instance, we might
type

	{cmd:. generate order     = 1 if division=="Sales"}
	{cmd:. replace  order = 2 if division=="Marketing"}
	{cmd:. replace  order = 3 if division=="Research"}
	{cmd:. replace  order = 4 if division=="Development"}

{pstd}
then type

{phang2}
	{cmd:. graph pie cost, over(division) sort(order)} ...


{marker remarks7}{...}
{title:Use with by()}

{pstd}
We have two years of data on XYZ Corp.:

	{cmd}. list
	{txt}
	     {c TLC}{hline 6}{c -}{hline 7}{c -}{hline 11}{c -}{hline 10}{c -}{hline 13}{c TRC}
	     {c |} {res}year   sales   marketing   research   development {txt}{c |}
	     {c LT}{hline 6}{c -}{hline 7}{c -}{hline 11}{c -}{hline 10}{c -}{hline 13}{c RT}
	  1. {c |} {res}2002      12          14          2             8 {txt}{c |}
	  2. {c |} {res}2003      15        17.5        8.5            10 {txt}{c |}
	     {c BLC}{hline 6}{c -}{hline 7}{c -}{hline 11}{c -}{hline 10}{c -}{hline 13}{c BRC}{txt}

	{cmd:. graph pie sales marketing research development,}
		{cmd:plabel(_all name, size(*1.5) color(white))}
		{cmd:by(year,}
			{cmd:legend(off)}
			{cmd:title("Expenditures, XYZ Corp.")}
			{cmd:note("Source:  2002 Financial Report (fictional data)")}
		{cmd:)}
	  {it:({stata "gr_example2 pie3":click to run})}
{* graph grpie3}{...}


{marker video}{...}
{title:Video example}

{phang}
{browse "http://www.youtube.com/watch?v=T_skwxG4sTk":Pie charts in Stata}


{* index histories}{...}
{* index Playfair, William}{...}
{* index Beniger and Robyn 1978}{...}
{* index Funkhouser 1937}{...}
{* index Tufte 1983}{...}
{marker remarks8}{...}
{title:History}

{pstd}
The first pie chart is credited to
{help graph pie##P1801:William Playfair (1801)}.  See
{help graph pie##BR1978:Beniger and Robyn (1978)},
{help graph pie##F1937:Funkhouser (1937, 283-285)}, or
{help graph pie##T2001:Tufte (2001, 44-45)}
for more historical details.


{marker references}{...}
{title:References}

{marker BR1978}{...}
{phang}
Beniger, J. R., and D. L. Robyn. 1978.
Quantitative graphics in statistics: A brief history.
{it:American Statistician} 32: 1-11.

{marker F1937}{...}
{phang}
Funkhouser, H. G. 1937. 
Historical development of the graphical representation of statistical data.
{it:Osiris} 3: 269-404.

{marker P1801}{...}
{phang}
Playfair, W. 1801.
{it:The Statistical Breviary: Shewing, on a Principle Entirely New, the}
{it:Resources of Every State and Kingdom in Europe to Which is Added,}
{it:a Similar Exhibition of the Ruling Powers of Hindoostan}.
London: Wallis.

{marker T2001}{...}
{phang}
Tufte, E. R. 2001.
{it:The Visual Display of Quantitative Information}. 2nd ed.
Cheshire, CT: Graphics Press.
{p_end}
