{smcl}
{* *! version 1.2.5  19oct2017}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway" "mansection G-2 graphtwoway"}{...}
{viewerjumpto "Syntax" "graph_twoway##syntax"}{...}
{viewerjumpto "Menu" "graph_twoway##menu"}{...}
{viewerjumpto "Description" "graph_twoway##description"}{...}
{viewerjumpto "Links to PDF documentation" "graph_twoway##linkspdf"}{...}
{viewerjumpto "Remarks" "graph_twoway##remarks"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[G-2] graph twoway} {hline 2}}Twoway graphs{p_end}
{p2col:}({mansection G-2 graphtwoway:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 23 2}
[{cmdab:gr:aph}]
{cmdab:tw:oway}
{it:plot}
{ifin}
[{cmd:,}
{it:{help twoway_options}}]

{pstd}
where the syntax of {it:plot} is

{pin}
[{cmd:(}]
{it:plottype} {varlist} ...{cmd:,} {it:options}
[{cmd:)}] [{cmd:||}]

{synoptset 20}{...}
{p2col :{it:plottype}}Description{p_end}
{p2line}
{p2col :{helpb scatter}}scatterplot{p_end}
{p2col :{helpb line}}line plot{p_end}
{p2col :{helpb twoway_connected:connected}}connected-line plot{p_end}
{p2col :{helpb twoway_scatteri:scatteri}}{cmd:scatter} with immediate arguments{p_end}

{marker barplots}{...}
{p2col :{helpb twoway_area:area}}line plot with shading{p_end}
{p2col :{helpb twoway_bar:bar}}bar plot{p_end}
{p2col :{helpb twoway_spike:spike}}spike plot{p_end}
{p2col :{helpb twoway_dropline:dropline}}dropline plot{p_end}
{p2col :{helpb twoway_dot:dot}}dot plot{p_end}

{marker rangeplots}{...}
{p2col :{helpb twoway_rarea:rarea}}range plot with area shading{p_end}
{p2col :{helpb twoway_rbar:rbar}}range plot with bars{p_end}
{p2col :{helpb twoway_rspike:rspike}}range plot with spikes{p_end}
{p2col :{helpb twoway_rcap:rcap}}range plot with capped spikes{p_end}
{p2col :{helpb twoway_rcapsym:rcapsym}}range plot with spikes capped with symbols{p_end}
{p2col :{helpb twoway_rscatter:rscatter}}range plot with markers{p_end}
{p2col :{helpb twoway_rline:rline}}range plot with lines{p_end}
{p2col :{helpb twoway_rconnected:rconnected}}range plot with lines and markers{p_end}

{marker pcplots}{...}
{p2col :{helpb twoway_pcspike:pcspike}}paired-coordinate plot with spikes{p_end}
{p2col :{helpb twoway_pccapsym:pccapsym}}paired-coordinate plot 
	with spikes capped with symbols{p_end}
{p2col :{helpb twoway_pcarrow:pcarrow}}paired-coordinate plot with arrows{p_end}
{p2col :{helpb twoway_pcbarrow:pcbarrow}}paired-coordinate plot with arrows
	having two heads{p_end}
{p2col :{helpb twoway_pcscatter:pcscatter}}paired-coordinate plot 
	with markers{p_end}
{p2col :{helpb twoway_pci:pci}}{cmd:pcspike} with immediate arguments{p_end}
{p2col :{helpb twoway_pcarrowi:pcarrowi}}{cmd:pcarrow} with immediate arguments{p_end}

{p2col :{helpb tsline}}time-series plot{p_end}
{p2col :{helpb tsrline}}time-series range plot{p_end}

{p2col :{helpb twoway_contour:contour}}contour plot with filled areas{p_end}
{p2col :{helpb twoway_contourline:contourline}}contour lines plot{p_end}

{p2col :{helpb twoway_mband:mband}}median-band line plot{p_end}
{p2col :{helpb twoway_mspline:mspline}}spline line plot{p_end}
{p2col :{helpb twoway_lowess:lowess}}LOWESS line plot{p_end}
{p2col :{helpb twoway_lfit:lfit}}linear prediction plot{p_end}
{p2col :{helpb twoway_qfit:qfit}}quadratic prediction plot{p_end}
{p2col :{helpb twoway_fpfit:fpfit}}fractional polynomial plot{p_end}
{p2col :{helpb twoway_lfitci:lfitci}}linear prediction plot with CIs{p_end}
{p2col :{helpb twoway_qfitci:qfitci}}quadratic prediction plot with CIs{p_end}
{p2col :{helpb twoway_fpfitci:fpfitci}}fractional polynomial plot with CIs{p_end}

{p2col :{helpb twoway_function:function}}line plot of function{p_end}
{p2col :{helpb twoway_histogram:histogram}}histogram plot{p_end}
{p2col :{helpb twoway_kdensity:kdensity}}kernel density plot{p_end}
{p2col :{helpb twoway_lpoly:lpoly}}local polynomial smooth plot{p_end}
{p2col :{helpb twoway_lpolyci:lpolyci}}local polynomial smooth plot with CIs{p_end}
{p2line}
{p2colreset}{...}

{pstd}
The leading {cmd:graph} is optional.
If the first (or only) {it:plot} is {cmd:scatter}, you may omit
{cmd:twoway} as well, and then the syntax is

{p 8 20 2}
{cmdab:sc:atter} ... [{cmd:,} {it:scatter_options}]
[ {cmd:||}
{it:plot} [{it:plot} [...]]]

{pstd}
and the same applies to {cmd:line}.  The other
{it:plottypes} must be preceded by {cmd:twoway}.

{pstd}
Regardless of how the command is specified,
{it:twoway_options}
may be specified among the
{it:scatter_options}, {it:line_options}, etc., and they will be treated just
as if they were specified among the {it:twoway_options} of the
{cmd:graph} {cmd:twoway} command.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Twoway graph (scatter, line, etc.)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:twoway} is a family of plots, all of which fit on numeric {it:y} and
{it:x} scales.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowayRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help graph twoway##remarks1:Definition}
	{help graph twoway##remarks2:Syntax}
	{help graph twoway##remarks3:Multiple if and in restrictions}
	{help graph twoway##remarks4:twoway and plot options}


{marker remarks1}{...}
{title:Definition}

{pstd}
Twoway graphs show the relationship between numeric data.
Say that we have data on life expectancy in the United States between 1900 and
1940:

	{cmd}. sysuse uslifeexp2

	. list in 1/8
	{txt}
	     {c TLC}{hline 6}{c -}{hline 6}{c TRC}
	     {c |} {res}year     le {txt}{c |}
	     {c LT}{hline 6}{c -}{hline 6}{c RT}
	  1. {c |} {res}1900   47.3 {txt}{c |}
	  2. {c |} {res}1901   49.1 {txt}{c |}
	  3. {c |} {res}1902   51.5 {txt}{c |}
	  4. {c |} {res}1903   50.5 {txt}{c |}
	  5. {c |} {res}1904   47.6 {txt}{c |}
	     {c LT}{hline 6}{c -}{hline 6}{c RT}
	  6. {c |} {res}1905   48.7 {txt}{c |}
	  7. {c |} {res}1906   48.7 {txt}{c |}
	  8. {c |} {res}1907   47.6 {txt}{c |}
	     {c BLC}{hline 6}{c -}{hline 6}{c BRC}{txt}


{pstd}
We could graph these data as a twoway scatterplot,

{phang2}{cmd:. twoway scatter le year}{p_end}
	  {it:({stata "gr_example uslifeexp2: twoway scatter le year":click to run})}
{* graph tw1}{...}

{pstd}
or we could graph these data as a twoway line plot,

{phang2}{cmd:. twoway line le year}{p_end}
	  {it:({stata "gr_example uslifeexp2: twoway line le year":click to run})}
{* graph tw2}{...}

{pstd}
or we could graph these data as a twoway connected plot, marking both the
points and connecting them with straight lines,

{phang2}{cmd:. twoway connected le year}{p_end}
	  {it:({stata "gr_example uslifeexp2: twoway connected  le year":click to run})}
{* graph tw3}{...}

{pstd}
or we could graph these data as a scatterplot and put on top of that the
prediction from a linear regression of {cmd:le} on {cmd:year},

{phang2}{cmd:. twoway (scatter le year) (lfit le year)}{p_end}
	  {it:({stata "gr_example uslifeexp2: twoway (scatter le year) (lfit le year)":click to run})}
{* graph tw4}{...}

{pstd}
or we could graph these data in many other ways.

{pstd}
These all are examples of twoway graphs.
What distinguishes a twoway graph is that it fits onto numeric {it:y} and
{it:x} axes.

{pstd}
Each of what we produced above is called a {it:graph}.  What appeared in
the graphs are called {it:plots}.  In the first graph, the plottype was a
scatter; in the second, the plottype was a line; in the third, the plottype was
connected; and in the fourth, there were two plots:  a scatter combined with a
line plot of a linear fit.

{pstd}
{cmd:twoway} provides many different plottypes.  Some, such
as {cmd:scatter} and {cmd:line}, simply render
the data in different ways.  Others, such as {cmd:lfit}, transform the data
and render that.  And still others, such as {cmd:function},
actually make up data to be rendered.  This last class makes it easy
to overlay {it:y}={it:x} lines or {it:y=f(x)} functions on
your graphs.

{pstd}
By the way, in case you are wondering, there are no errors in the above data.
In 1918, there was an outbreak of influenza known as the 1918 Influenza
Pandemic, which in the United States, was the worst epidemic ever known and
which killed more citizens than all combat deaths of the 20th century.


{marker remarks2}{...}
{title:Syntax}

{pstd}
If we want to graph y1 versus x and y2 versus x, the formal way to type this is

{phang2}{cmd:. graph twoway (scatter y1 x) (scatter y2 x)}{p_end}

{pstd}
If we wanted y1 versus x plotted with solid circles and y2 versus x plotted
with hollow circles, formally we would type

{phang2}{cmd:. graph twoway (scatter y1 x, ms(O)) (scatter y2 x, ms(Oh))}{p_end}

{pstd}
If we wanted y1 versus x plotted with solid circles and wanted a line graph
for y2 versus x, formally we would type

{phang2}{cmd:. graph twoway (scatter y1 x, ms(O)) (line y2 x, sort)}{p_end}

{pstd}
The {cmd:sort} option is included under the assumption that the data are not
already sorted by x.

{pstd}
We have shown the formal way to type each of our requests, but few people
would type that.  First, most users omit the {cmd:graph}:

{phang2}{cmd:. twoway (scatter y1 x) (scatter y2 x)}{p_end}
{phang2}{cmd:. twoway (scatter y1 x, ms(O)) (scatter y2 x, ms(Oh))}{p_end}
{phang2}{cmd:. twoway (scatter y1 x, ms(O)) (line y2 x, sort)}{p_end}

{pstd}
Second, most people use the {cmd:||}-separator notation rather than the
{cmd:()}-binding notation:

{phang2}{cmd:. twoway scatter y1 x || scatter y2 x}{p_end}
{phang2}{cmd:. twoway scatter y1 x, ms(O) || scatter y2 x, ms(Oh)}{p_end}
{phang2}{cmd:. twoway scatter y1 x, ms(O) || line y2 x, sort}{p_end}

{pstd}
Third, most people now omit the {cmd:twoway}:

{phang2}{cmd:. scatter y1 x || scatter y2 x}{p_end}
{phang2}{cmd:. scatter y1 x, ms(O) || scatter y2 x, ms(Oh)}{p_end}
{phang2}{cmd:. scatter y1 x, ms(O) || line y2 x, sort}{p_end}

{pstd}
And finally, most people quickly realize that {cmd:scatter} allows us to plot
more than one {it:y} variable against the same {it:x} variable:

{phang2}{cmd:. scatter y1 y2 x}{p_end}
{phang2}{cmd:. scatter y1 y2 x, ms(O Oh)}{p_end}
{phang2}{cmd:. scatter y1 x, ms(O) || line y2 x, sort}{p_end}

{pstd}
The third example did not change:  in that example, we are combining
a scatterplot and a line plot.  Actually, in this particular case, there is
a way we can combine that, too:

{phang2}{cmd:. scatter y1 y2 x, ms(O i) connect(. l)}{p_end}

{pstd}
That we can combine {cmd:scatter} and {cmd:line} just happens to be an oddity
of the examples we picked.  It is important to understand that there is
nothing wrong with any of the above ways of typing our request, and sometimes
the wordier syntaxes are the only way to obtain what we want.  If we wanted to
graph y1 versus x1 and y2 versus x2, the only way to type that is

{phang2}{cmd:. scatter y1 x1 || scatter y2 x2}{p_end}

{pstd}
or to type the equivalent in one of the wordier syntaxes above it.
We have to do this because {cmd:scatter}
(see {manhelp scatter G-2:graph twoway scatter})
draws a scatterplot against one {it:x} variable.  Therefore, if we want two
different {it:x} variables, we need two different scatters.

{pstd}
In any case, we will often refer to the {cmd:graph} {cmd:twoway} command, even
though, when we give the command, we will seldom type the {cmd:graph}, and
mostly, we will not type the {cmd:twoway} either.


{marker remarks3}{...}
{title:Multiple if and in restrictions}

{pstd}
Each {it:plot} may have its own {cmd:if} {it:exp} and {cmd:in} {it:range}
restrictions:

{p 8 17 2}{cmd:. twoway (scatter mpg weight if foreign, msymbol(O))}{break}
		 {cmd:(scatter mpg weight if !foreign, msymbol(Oh))}

{pstd}
Multiple {it:plots} in one {cmd:graph} {cmd:twoway} command draw one
graph with multiple things plotted in it.  The above will produce a scatter of
{cmd:mpg} versus {cmd:weight} for foreign cars (making the points with solid
circles) and a scatter of {cmd:mpg} versus {cmd:weight} for domestic cars (using
hollow circles).

{pstd}
Also, the {cmd:graph} {cmd:twoway} command itself can have
{cmd:if} {it:exp} and {cmd:in} {it:range} restrictions:

{p 8 17 2}{cmd:. twoway (scatter mpg weight if foreign, msymbol(O))}{break}
		 {cmd:(scatter mpg weight if !foreign, msymbol(Oh)) if mpg>20}

{pstd}
The {cmd:if} {cmd:mpg>20} restriction will apply to both scatters.

{pstd}
We have chosen to show these two examples with the {cmd:()}-binding notation
because it makes the scope of each {cmd:if} {it:exp} so clear.  In
{cmd:||}-separator notation, the commands would read

{p 8 17 2}{cmd:. twoway scatter mpg weight if foreign, msymbol(O) ||}{break}
		 {cmd:scatter mpg weight if !foreign, msymbol(Oh)}{p_end}

{pstd}and{p_end}

{p 8 17 2}{cmd:. twoway scatter mpg weight if foreign, msymbol(O) ||}{break}
		 {cmd:scatter mpg weight if !foreign, msymbol(Oh) || if mpg>20}

{pstd}
or even

{p 8 18 2}{cmd:. scatter mpg weight if foreign, msymbol(O) ||}{break}
		 {cmd:scatter mpg weight if !foreign, msymbol(Oh)}{p_end}

{pstd}and{p_end}

{p 8 18 2}{cmd:. scatter mpg weight if foreign, msymbol(O) ||}{break}
		 {cmd:scatter mpg weight if !foreign, msymbol(Oh) || if mpg>20}

{pstd}
We may specify {cmd:graph} {cmd:twoway} restrictions only, of course:

{phang2}{cmd:. twoway (scatter mpg weight) (lfit mpg weight) if !foreign}

{phang2}{cmd:. scatter mpg weight || lfit mpg weight || if !foreign}


{marker remarks4}{...}
{title:twoway and plot options}

{pstd}
{cmd:graph} {cmd:twoway} allows options, and the individual {it:plots} allow
options.  For instance, {cmd:graph} {cmd:twoway} allows the {cmd:saving()}
option, and {manhelp scatter G-2:graph twoway scatter} allows the
{cmd:msymbol()} option, which specifies the marker symbol to be used.
Nevertheless, we do not have to keep track of which option belongs to which.
If we type

{phang2}{cmd:. scatter mpg weight, saving(mygraph) msymbol(Oh)}

{pstd}
the results will be the same as if we more formally typed

{phang2}{cmd:. twoway (scatter mpg weight, msymbol(Oh)), saving(mygraph)}

{pstd}
Similarly, we could type

{phang2}{cmd:. scatter mpg weight, msymbol(Oh) || lfit mpg weight, saving(mygraph)}{p_end}
{pstd}or{p_end}
{phang2}{cmd:. scatter mpg weight, msymbol(Oh) saving(mygraph) || lfit mpg weight}

{pstd}
and, either way, the results would be the same as if we typed

{p 8 17 2}{cmd:. twoway (scatter mpg weight, msymbol(Oh))}{break}
		 {cmd:(lfit mpg weight), saving(mygraph)}

{pstd}
We may specify a {cmd:graph} {cmd:twoway} option "too deeply", but we cannot
go the other way.  The following is an error:

{phang2}{cmd:. scatter mpg weight || lfit mpg weight ||, msymbol(Oh) saving(mygraph)}

{pstd}
It is an error because we specified a {cmd:scatter} option where only a
{cmd:graph} {cmd:twoway} option may be specified, and given what we typed,
there is insufficient information for {cmd:graph} {cmd:twoway} to determine
for which {it:plot} we meant the {cmd:msymbol()} option.  Even when there is
sufficient information (say that option {cmd:msymbol()} were not allowed by
{cmd:lfit}), it would still be an error.  {cmd:graph} {cmd:twoway} can reach
in and pull out its options, but it cannot take from its options and
distribute them back to the individual {it:plots}.
{p_end}
