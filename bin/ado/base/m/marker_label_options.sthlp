{smcl}
{* *! version 1.1.12  02oct2019}{...}
{vieweralsosee "[G-3] marker_label_options" "mansection G-3 marker_label_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway scatter" "help scatter"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] anglestyle" "help anglestyle"}{...}
{vieweralsosee "[G-4] clockposstyle" "help clockposstyle"}{...}
{vieweralsosee "[G-4] colorstyle" "help colorstyle"}{...}
{vieweralsosee "[G-4] markerlabelstyle" "help markerlabelstyle"}{...}
{vieweralsosee "[G-4] size" "help size"}{...}
{vieweralsosee "[G-4] textsizestyle" "help textsizestyle"}{...}
{vieweralsosee "[G-4] textstyle" "help textstyle"}{...}
{viewerjumpto "Syntax" "marker_label_options##syntax"}{...}
{viewerjumpto "Description" "marker_label_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "marker_label_options##linkspdf"}{...}
{viewerjumpto "Options" "marker_label_options##options"}{...}
{viewerjumpto "Remarks" "marker_label_options##remarks"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[G-3]} {it:marker_label_options} {hline 2}}Options for specifying marker labels{p_end}
{p2col:}({mansection G-3 marker_label_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 30}{...}
{p2col:{it:marker_label_options}}Description{p_end}
{p2line}
{p2col:{cmdab:ml:abel(}{varname}{cmd:)}}specify marker variable{p_end}

{p2col:{cmdab:mlabsty:le:(}{it:{help markerlabelstyle}}{cmd:)}}overall style
       of label{p_end}
{p2col:{cmdab:mlabp:osition:(}{it:{help clockposstyle}}{cmd:)}}where to locate
       the label{p_end}
{p2col:{cmdab:mlabv:position:(}{varname}{cmd:)}}where to locate the label
       2{p_end}
{p2col:{cmdab:mlabg:ap:(}{it:{help size}}{cmd:)}}gap between marker
      and label{p_end}
{p2col:{cmdab:mlabang:le:(}{it:{help anglestyle}}{cmd:)}}angle of label{p_end}
{p2col:{cmdab:mlabt:extstyle:(}{it:{help textstyle}}{cmd:)}}overall style of
      text{p_end}
{p2col:{cmdab:mlabs:ize:(}{it:{help textsizestyle}}{cmd:)}}size of label{p_end}
{p2col:{cmdab:mlabc:olor:(}{it:{help colorstyle}}{cmd:)}}color and opacity of label{p_end}
{p2col:{cmdab:mlabf:ormat:(}{it:{help %fmt}}{cmd:)}}format of label{p_end}
{p2line}
{p2colreset}{...}
{p 4 6 2}
All options are {it:rightmost}; see {help repeated options}.

{p 4 6 2}
Sometimes -- such as when used with {cmd:scatter} -- lists are
allowed inside the arguments.  A list is a sequence of the elements separated
by spaces.  Shorthands are allowed to make specifying the list easier; see
{manhelpi stylelists G-4}.  When lists are allowed, option {cmd:mlabel()}
allows a {varlist} in place of a {varname}.


{marker description}{...}
{title:Description}

{pstd}
Marker labels are labels that appear next to (or in place of) markers.
Markers are the ink used to mark where points are on a plot.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 marker_label_optionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:mlabel(}{varname}{cmd:)}
    specifies the (usually string) variable to be used that provides,
    observation by observation, the marker "text".
    For instance, you might have

	    {cmd:. sysuse auto}

	    {cmd}. list mpg weight make in 1/4
	    {txt}
		 {c TLC}{hline 30}{c TRC}
		 {c |} {res}mpg   weight   make          {txt}{c |}
		 {c LT}{hline 30}{c RT}
	      1. {c |} {res} 22    2,930   AMC Concord   {txt}{c |}
	      2. {c |} {res} 17    3,350   AMC Pacer     {txt}{c |}
	      3. {c |} {res} 22    2,640   AMC Spirit    {txt}{c |}
	      4. {c |} {res} 20    3,250   Buick Century {txt}{c |}
		 {c BLC}{hline 30}{c BRC}{txt}

{pmore}
    Typing

	    {cmd:. scatter mpg weight, mlabel(make)}

{pmore}
    would draw a scatter of {cmd:mpg} versus
    {cmd:weight} and label each point in
    the scatter according to its {cmd:make}.  (We recommend that you include
    "{cmd:in 1/10}" on the above command.  Marker labels work well only when
    there are few data.)

{phang}
{cmd:mlabstyle(}{it:markerlabelstyle}{cmd:)}
    specifies the overall look of marker labels, including their position,
    their size, their text style, etc.  The other options documented below
    allow you to change each attribute of the marker label, but
    {cmd:mlabstyle()} is the starting point.
    See {manhelpi markerlabelstyle G-3}.

{pmore}
    You need not specify {cmd:mlabstyle()} just because there is something you
    want to change about the look of a marker and, in fact, most people seldom
    specify the {cmd:mlabstyle()} option.  You specify {cmd:mlabstyle()} when
    another style exists that is exactly what you desire or when another style
    would allow you to specify fewer changes to obtain what you want.

{phang}
{cmd:mlabposition(}{it:clockposstyle}{cmd:)}
and
{cmd:mlabvposition(}{varname}{cmd:)}
    specify where the label is to be located relative to the point.
    {cmd:mlabposition()} and {cmd:mlabvposition()} are alternatives; the first
    specifies a constant position for all points and the second specifies
    a variable that contains {it:clockposstyle} (a number 0--12) for each
    point.  If both options are specified, {cmd:mlabvposition()} takes
    precedence.

{pmore}
    If neither option is specified, the default is {cmd:mlabposition(3)}
    (3 o'clock) -- meaning to the right of the point.

{pmore}
    {cmd:mlabposition(12)} means above the point, {cmd:mlabposition(1)} means
    above and to the right of the point, and so on.  {cmd:mlabposition(0)}
    means that the label is to be put directly on top of
    the point (in which case remember to also specify the {cmd:msymbol(i)}
    option so that the marker does not also display; see
    {manhelpi marker_options G-3}).

{pmore}
    {cmd:mlabvposition(}{it:varname}{cmd:)} specifies a numeric variable
    containing values 0--12, which are used, observation by observation,
    to locate the labels relative to the points.

{pmore}
    See {manhelpi clockposstyle G-4} for more information on specifying
    {it:clockposstyle}.

{phang}
{cmd:mlabgap(}{it:size}{cmd:)}
    specifies how much space should be put between the marker and the label.
    See {manhelpi size G-4}.

{phang}
{cmd:mlabangle(}{it:anglestyle}{cmd:)}
    specifies the angle of text.
    The default is usually {cmd:mlabangle(horizontal)}.
    See {manhelpi anglestyle G-4}.

{phang}
{cmd:mlabtextstyle(}{it:textstyle}{cmd:)}
    specifies the overall look of text of the marker labels, which 
    here means their size and color.  When you see {manhelpi textstyle G-4},
    you will find that a {it:textstyle} defines much more, but all of those
    other things are ignored for marker labels.  In any case, the
    {cmd:mlabsize()} and {cmd:mlabcolor()} options documented below allow you
    to change the size and color, but {cmd:mlabtextstyle()} is the starting
    point.

{pmore}
    As with {cmd:mlabstyle()}, you need not specify {cmd:mlabtextstyle()} just
    because there is something you want to change.  You specify
    {cmd:mlabtextstyle()} when another style exists that is exactly what you
    desire or when another style would allow you to specify fewer changes to
    obtain what you want.

{phang}
{cmd:mlabsize(}{it:textsizestyle}{cmd:)}
    specifies the size of the text.
    See {manhelpi textsizestyle G-4}.

{phang}
{cmd:mlabcolor(}{it:colorstyle}{cmd:)}
    specifies the color and opacity of the text.
    See {manhelpi colorstyle G-4}.

{phang}
{cmd:mlabformat(}{it:%fmt}{cmd:)}
    specifies the format of the text.
    This option is most useful when the marker labels are numeric.
    See {manhelp format D}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help marker_label_options##remarks1:Typical use}
	{help marker_label_options##remarks2:Eliminating overprinting and overruns}
	{help marker_label_options##remarks3:Advanced use}
	{help marker_label_options##remarks4:Using marker labels in place of markers}


{marker remarks1}{...}
{title:Typical use}

{pstd}
Markers are the ink used to mark where points are on a plot, and marker labels
optionally appear beside the markers to identify the points.  For instance, if
you were plotting country data, marker labels would allow you to have
"Argentina", "Bolivia", ..., appear next to each point.  Marker
labels visually work well when there are few data.

{pstd}
To obtain marker labels, you specify the {cmd:mlabel(}{it:varname}{cmd:)}
option, such as {cmd:mlabel(country)}.  {it:varname} is the name of a variable
that, observation by observation, specifies the text with which the point is
to be labeled.  {it:varname} may be a string or numeric variable, but usually
it is a string.  For instance, consider a subset of the
life-expectancy-by-country data:

	{cmd:. sysuse lifeexp}

	{cmd}. list country lexp gnppc if region==2
	{txt}
	     {c TLC}{hline 21}{c -}{hline 6}{c -}{hline 7}{c TRC}
	     {c |} {res}            country   lexp   gnppc {txt}{c |}
	     {c LT}{hline 21}{c -}{hline 6}{c -}{hline 7}{c RT}
	 45. {c |} {res}             Canada     79   19170 {txt}{c |}
	 46. {c |} {res}               Cuba     76       . {txt}{c |}
	 47. {c |} {res} Dominican Republic     71    1770 {txt}{c |}
	 48. {c |} {res}        El Salvador     69    1850 {txt}{c |}
	 49. {c |} {res}          Guatemala     64    1640 {txt}{c |}
	     {c LT}{hline 21}{c -}{hline 6}{c -}{hline 7}{c RT}
	 50. {c |} {res}              Haiti     54     410 {txt}{c |}
	 51. {c |} {res}           Honduras     69     740 {txt}{c |}
	 52. {c |} {res}            Jamaica     75    1740 {txt}{c |}
	 53. {c |} {res}             Mexico     72    3840 {txt}{c |}
	 54. {c |} {res}          Nicaragua     68    1896 {txt}{c |}
	     {c LT}{hline 21}{c -}{hline 6}{c -}{hline 7}{c RT}
	 55. {c |} {res}             Panama     74    2990 {txt}{c |}
	 56. {c |} {res}        Puerto Rico     76       . {txt}{c |}
	 57. {c |} {res}Trinidad and Tobago     73    4520 {txt}{c |}
	 58. {c |} {res}      United States     77   29240 {txt}{c |}
	     {c BLC}{hline 21}{c -}{hline 6}{c -}{hline 7}{c BRC}{txt}

{pstd}
We might graph these data and use labels to indicate the country by typing

{phang2}
	{cmd:. scatter lexp gnppc if region==2, mlabel(country)}
{p_end}
	  {it:({stata "gr_example lifeexp: scatter lexp gnppc if region==2, mlabel(country)":click to run})}
{* graph mlab1}{...}


{marker remarks2}{...}
{title:Eliminating overprinting and overruns}

{pstd}
In the graph, the label "United States" runs off the right edge and
the labels for Honduras and El Salvador are overprinted.  Problems like
that invariably occur when using marker labels.  The {cmd:mlabposition()}
allows specifying where the labels appear, and we might try

{phang2}
	{cmd:. scatter lexp gnppc if region==2, mlabel(country) mlabpos(9)}

{pstd}
to move the labels to the 9 o'clock position, meaning to the
left of the point.  Here, however, that will introduce more problems
than it will solve.  You could try other clock positions around the point,
but we could not find one that was satisfactory.

{pstd}
If our only problem were with "United States" running off the right, an
adequate solution might be to widen the {it:x} axis so that there would be
room for the label "United States" to fit:

	{cmd:. scatter lexp gnppc if region==2, mlabel(country)}
				{cmd:xscale(range(35000))}
	  {it:({stata "gr_example lifeexp: scatter lexp gnppc if region==2, mlabel(country) xscale(range(35000))":click to run})}
{* graph mlab2}{...}

{pstd}
That would solve one problem but will leave us with the overprinting problem.
The way to solve that problem is to move the Honduras label to being to the
left of its point, and the way to do that is to specify the option
{cmd:mlabvposition(}{it:varname}{cmd:)} rather than
{cmd:mlabposition(}{it:clockposstyle}{cmd:)}.  We will create new variable {cmd:pos}
stating where we want each label:

	{cmd}. generate pos = 3

	. replace pos = 9 if country=="Honduras"

	. scatter lexp gnppc if region==2, mlabel(country) mlabv(pos)
				xscale(range(35000)){txt}
	  {it:({stata "gr_example2 markerlabel1":click to run})}
{* graph markerlabel1}{...}

{pstd}
We are near a solution:  Honduras is running off the left edge of
the graph, but we know how to fix that.  You may be tempted to solve this
problem just as we solved the problem with the United States label:  expand
the range, say, to {cmd:range(-500 35000)}.  That would be a fine solution.

{pstd}
Here, however, we will increase the margin between the left edge of
the plot area and the {it:y} axis by adding the option
{cmd:plotregion(margin(l+9))}; see {manhelpi region_options G-3}.
{cmd:plotregion(margin(l+9))} says to increase the margin on the left by 9%,
and this is really the "right" way to handle margin problems:{cmd}

	. scatter lexp gnppc if region==2, mlabel(country) mlabv(pos)
				xscale(range(35000))
				plotregion(margin(l+9)){txt}
	  {it:({stata "gr_example2 markerlabel2":click to run})}{txt}
{* graph markerlabel2}{...}

{pstd}
The overall result is adequate.  Were we producing this graph for publication,
we would move the label for United States to the left of its point, just as
we did with Honduras, rather than widening the {it:x} axis.


{marker remarks3}{...}
{title:Advanced use}

{pstd}
Let us now consider properly graphing the life-expectancy data and graphing
more of it.  This time, we will include South America, as well as North and
Central America and we will graph the data on a log(GNP) scale.


	{cmd}. sysuse lifeexp, clear
	. keep if region==2 | region==3{...}
{col 70}{txt}{it:(note 1)}{cmd}

	. replace gnppc = gnppc / 1000
	. label var gnppc "GNP per capita (thousands of dollars)"{...}
{col 70}{txt}{it:(note 2)}{cmd}

	. generate lgnp = log(gnp)
	. qui reg lexp lgnp
	. predict hat
	. label var hat "Linear prediction"{...}
{col 70}{txt}{it:(note 3)}{cmd}

	. replace country = "Trinidad" if country=="Trinidad and Tobago"
	. replace country = "Para" if country == "Paraguay"{...}
{col 70}{txt}{it:(note 4)}{cmd}

	. generate pos = 3
	. replace pos = 9 if lexp > hat{...}
{col 70}{txt}{it:(note 5)}{cmd}

	. replace pos = 3 if country == "Colombia"
	. replace pos = 3 if country == "Para"
	. replace pos = 3 if country == "Trinidad"
	. replace pos = 9 if country == "United States"{...}
{col 70}{txt}{it:(note 6)}{cmd}

	. twoway (scatter lexp gnppc, mlabel(country) mlabv(pos))
		 (line hat gnppc, sort)
		 , xscale(log) xlabel(.5 5 10 15 20 25 30, grid)
		   legend(off)
		   title("Life expectancy vs. GNP per capita")
		   subtitle("North, Central, and South America")
		   note("Data source:  World Bank, 1998")
		   ytitle("Life expectancy at birth (years)"){txt}
	  {it:({stata "gr_example2 markerlabel3":click to run})}{txt}
{* graph markerlabel3}{...}

{pstd}
Notes:

{phang2}
1.  In these data, region 2 is North and Central America, and region 3 is
    South America.

{phang2}
2.  We divide {cmd:gnppc} by 1,000 to keep the {it:x} axis labels from running
    into each other.

{phang2}
3.  We add a linear regression prediction.  We cannot use {cmd:graph}
    {cmd:twoway} {cmd:lfit} because we want the predictions
    to be based on a regression of log(GNP), not GNP.

{phang2}
4.  The first time we graphed the results, we discovered that there was
    no way we could make the names of these two countries fit on our
    graph, so we shortened them.

{phang2}
5.  We are going to place the marker labels to the left of the marker
    when life expectancy is above the regression line and to the right
    of the marker otherwise.

{phang2}
6.  To keep labels from overprinting, we need to override rule (5) for a few
countries.

{pstd}
Also see {manhelpi scale_option G-3} for another rendition of this graph.
In that rendition, we specify one more
option -- {cmd:scale(1.1)} -- 
to increase the size of the text and markers by 10%.


{marker remarks4}{...}
{title:Using marker labels in place of markers}

{pstd}
In addition to specifying where the marker label goes relative to the marker,
you can specify that the marker label be used instead of the marker.
{cmd:mlabposition(0)} means that the label is to be centered
where the marker would appear.  To suppress the display of the marker as
well, specify option {cmd:msymbol(i)}; see {manhelpi marker_options G-3}.

{pstd}
Using the labels in place of the points tends to work well in analysis graphs
where our interest is often in identifying the outliers.  Below we graph the
entire {cmd:lifeexp.dta} data:

{phang2}
	{cmd:. scatter lexp gnppc, xscale(log) mlab(country) m(i)}
{p_end}
	  {it:({stata "gr_example lifeexp: scatter lexp gnppc, xscale(log) mlab(country) m(i)":click to run})}
{* graph mlab3}{...}

{pstd}
In the above graph, we also specified {cmd:xscale(log)} to convert the {it:x}
axis to a log scale.  A log {it:x} scale is more appropriate for these
data, but had we used it earlier, the overprinting problem with
Honduras and El Salvador would have disappeared, and we wanted to show
how to handle the problem.
{p_end}
