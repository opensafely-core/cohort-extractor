{smcl}
{* *! version 1.1.18  15may2018}{...}
{vieweralsosee "[G-1] Graph intro" "mansection G-1 Graphintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph" "help graph"}{...}
{vieweralsosee "[G-2] graph other" "help graph_other"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-1] Graph Editor" "help graph_editor"}{...}
{viewerjumpto "Remarks" "graph intro##remarks"}{...}
{viewerjumpto "References" "graph intro##references"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[G-1] Graph intro} {hline 2}}Introduction to graphics{p_end}
{p2col:}({mansection G-1 Graphintro:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help graph intro##reading:Suggested reading order}
	{help graph intro##tour:A quick tour}
	{help graph intro##menus:Using the menus}


{marker reading}{...}
{title:Suggested reading order}

{pstd}
We recommend that you read the entries in this manual in the following order:

{pmore}Read {it:{help graph intro##tour:A quick tour}} below,
	then read {it:{help graph editor##quickstart:Quick start}}
	in {manhelp graph_editor G-1:Graph Editor}, and 
	then ...

{p2colset 9 38 40 2}{...}
{p2col:Entry} Description{p_end}
{p2line}
{p2col:{manhelp graph G-2}}{...}
       Overview of the {cmd:graph} command{p_end}
{p2col:{manhelp twoway G-2}}{...}
       Overview of the {cmd:graph twoway} command{p_end}
{p2col:{manhelp scatter G-2:graph twoway scatter}}{...}
       Overview of the {cmd:graph twoway scatter} command{p_end}
{p2line}

{pstd}
When reading those sections, follow references to other entries that interest
you.  They will take you to such useful topics as

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{manhelpi marker_label_options G-3}}{...}
       Options for specifying marker labels{p_end}
{p2col:{manhelpi by_option G-3}}{...}
        Option for repeating graph command{p_end}
{p2col:{manhelpi title_options G-3}}{...}
       Options for specifying titles{p_end}
{p2col:{manhelpi legend_options G-3}}{...}
       Option for specifying legend{p_end}
{p2line}

{pstd}
We could list many, many more, but you will find them on your own.
Follow the references that interest you and ignore the rest.  Afterward,
you will have a working knowledge of twoway graphs. Now glance at each of

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{manhelp line G-2:graph twoway line}}{...}
        Overview of the {cmd:graph twoway line} command{p_end}
{p2col:{manhelp twoway_connected G-2:graph twoway connected}}{...}
        Overview of the {cmd:graph twoway connected} command etc.{p_end}
{p2line}
{pin}
Turn to {manhelp twoway G-2:graph twoway}, which lists all the different
{cmd:graph} {cmd:twoway} plottypes, and browse the manual entry for each.

{pstd}
Now is the time to understand schemes, which have a great effect on
how graphs look.  You may want to specify a different scheme
before printing your graphs.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{manhelp schemes G-4:Schemes intro}}{...}
        Schemes and what they do{p_end}
{p2col:{manhelp set_printcolor G-2:set printcolor}}{...}
        Set how colors are treated when graphs are printed{p_end}
{p2col:{manhelp graph_print G-2:graph print}}{...}
        Printing graphs the easy way{p_end}
{p2col:{manhelp graph_export G-2:graph export}}{...}
        Exporting graphs to other file formats{p_end}
{p2line}

{pstd}
Now you are an expert on the {cmd:graph} {cmd:twoway} command, and
you can even print the graphs it produces.

{pstd}
To learn about the other types of graphs, see

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{manhelp graph_matrix G-2:graph matrix}}{...}
        Scatterplot matrices{p_end}
{p2col:{manhelp graph_bar G-2:graph bar}}{...}
        Bar and dot charts{p_end}
{p2col:{manhelp graph_box G-2:graph box}}{...}
        Box plots{p_end}
{p2col:{manhelp graph_dot G-2:graph dot}}{...}
        Dot charts (summary statistics){p_end}
{p2col:{manhelp graph_pie G-2:graph pie}}{...}
        Pie charts{p_end}
{p2line}

{pstd}
To learn tricks of the trade, see

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{manhelp graph_save G-2:graph save}}{...}
        Saving graphs to disk{p_end}
{p2col:{manhelp graph_use G-2:graph use}}{...}
        Redisplaying graphs from disk{p_end}
{p2col:{manhelp graph_describe G-2:graph describe}}{...}
        Finding out what is in a .gph file{p_end}
{p2col:{manhelpi name_option G-3}}{...}
        How to name a graph in memory{p_end}
{p2col:{manhelp graph_display G-2:graph display}}{...}
        Display graph stored in memory{p_end}
{p2col:{manhelp graph_dir G-2:graph dir}}{...}
        Obtaining directory of named graphs{p_end}
{p2col:{manhelp graph_rename G-2:graph rename}}{...}
        Renaming a named graph{p_end}
{p2col:{manhelp graph_copy G-2:graph copy}}{...}
        Copying a named graph{p_end}
{p2col:{manhelp graph_drop G-2:graph drop}}{...}
        Eliminating graphs in memory{p_end}
{p2col:{manhelp graph_close G-2:graph close}}{...}
        Closing Graph windows{p_end}
{p2col:{manhelp graph_replay G-2:graph replay}}{...}
        Replaying multiple graphs{p_end}
{p2col:{manhelp discard P}}{...}
       Clearing memory{p_end}
{p2line}
{p2colreset}{...}

{pstd}
For a completely different and highly visual approach to learning Stata
graphics, see {help graph intro##M2012:Mitchell (2012)}.
For a mix of scholarly review and tutorial exposition,
see {help graph intro##C2014:Cox (2014)}.
{help graph intro##H2009:Hamilton (2009)} offers a concise 50-page
overview within the larger context of statistical analysis with Stata.
Excellent suggestions for presenting information clearly in graphs can be
found in Cleveland ({help graph intro##C1993:1993} and
{help graph intro##C1994:1994}), in 
{help graph intro##WWPJH1996:Wallgren et al. (1996)},
and even in chapters of books treating larger subjects, such as
{help graph intro##GH2009:Good and Hardin (2009)}.


{marker tour}{...}
{title:A quick tour}

{pstd}
{cmd:graph} is easy to use:

	{cmd:. sysuse auto}

	{cmd:. graph twoway scatter mpg weight}
	  {it:({stata "gr_example auto: graph twoway scatter mpg weight":click to run})}
{* graph mpgweight}{...}

{pstd}
All the commands documented in this manual begin with the word {cmd:graph},
but often the {cmd:graph} is optional.  You could get the same
graph by typing

	{cmd:. twoway scatter mpg weight}

{pstd}
and, for {cmd:scatter}, you could omit the {cmd:twoway}, too:

	{cmd:. scatter mpg weight}

{pstd}
We, however, will continue to type {cmd:twoway} to emphasize when the
graphs we are demonstrating are in the twoway family.

{pstd}
Twoway graphs can be combined with {cmd:by()}:

	{cmd:. twoway scatter mpg weight, by(foreign)}
	  {it:({stata "gr_example auto: twoway scatter mpg weight, by(foreign)":click to run})}
{* graph mpgweightby}{...}

{pstd}
Graphs in the {cmd:twoway} family can also be overlaid.  The members of the
{cmd:twoway} family are called {it:plottypes}; {cmd:scatter} is a plottype, and
another plottype is {cmd:lfit}, which calculates the linear prediction and
plots it as a line chart.  When we want one plottype overlaid on
another, we combine the commands, putting {cmd:||} in between:

	{cmd:. twoway scatter mpg weight || lfit mpg weight}
	  {it:({stata "gr_example auto: twoway scatter mpg weight || lfit mpg weight":click to run})}
{* graph grintro3}{...}

{pstd}
Another notation for this is called the {cmd:()}-binding notation:

{phang2}
	{cmd:. twoway (scatter mpg weight) (lfit mpg weight)}

{pstd}
It does not matter which notation you use.

{pstd}
Overlaying can be combined with {cmd:by()}.  This time, substitute
{cmd:qfitci} for {cmd:lfit}.  {cmd:qfitci} plots the prediction from a
quadratic regression, and it adds a confidence interval.  Then add the
confidence interval on the basis of the standard error of the forecast:

{phang2}
	{cmd:. twoway (qfitci mpg weight, stdf) (scatter mpg weight), by(foreign)}
{p_end}
	  {it:({stata "gr_example auto: twoway (qfitci mpg weight, stdf) (scatter mpg weight), by(foreign)":click to run})}
{* graph grintro4}{...}

{pstd}
We used the {cmd:()}-binding notation just because it makes it easier to
see what modifies what:

		     {cmd:stdf} {it:is an option}
			  {it:of} {cmd:qfitci}
		     {c TLC}{hline 16}{c TRC}
		     {c BT}                {c BT}
	{cmd:. twoway (qfitci mpg weight, stdf) (scatter mpg weight), by(foreign)}
	    {c TT}    {c BLC}{hline 23}{c BRC} {c BLC}{hline 18}{c BRC}        {c TT}
	    {c |}          {it:overlay this             with this}              {c |}
	    {c |}                                                          {c |}
	    {c BLC}{hline 58}{c BRC}
			 {cmd:by(foreign)} {it:is an option of} {cmd:twoway}


{pstd}
We could just as well have typed this command with the {cmd:||}-separator
notation,

{phang2}
	{cmd:. twoway qfitci mpg weight, stdf || scatter mpg weight ||, by(foreign)}

{pstd}
and, as a matter of fact, we do not have to separate the {cmd:twoway} option
{cmd:by(foreign)} (or any other {cmd:twoway} option)
from the {cmd:qfitci} and {cmd:scatter} options, so we can type

{phang2}
	{cmd:. twoway qfitci mpg weight, stdf || scatter mpg weight, by(foreign)}

{pstd}
or even

{phang2}
	{cmd:. twoway qfitci mpg weight, stdf by(foreign) || scatter mpg weight}

{pstd}
All of these syntax issues are discussed in {manhelp twoway G-2:graph twoway}.
In our opinion, the {cmd:()}-binding notation is easier to read, but the
{cmd:||}-separator notation is easier to type.  You will see us using both.

{pstd}
It was not an accident that we put {cmd:qfitci} first and
{cmd:scatter} second.  {cmd:qfitci} shades an area, and had we done it the
other way around, that shading would have been put right on top of our
scattered points and erased (or at least hidden) them.

{pstd}
Plots of different types or the same type may be overlaid:

	{cmd:. sysuse uslifeexp}

	{cmd:. twoway line le_wm year || line le_bm year}
	  {it:({stata "gr_example uslifeexp: twoway line le_wm year || line le_bm year":click to run})}
{* graph grintro5}{...}

{pstd}
Here is a rather fancy version of the same graph:{cmd}

	. generate diff = le_wm - le_bm

	. label var diff "Difference"

	. twoway line le_wm year, yaxis(1 2) xaxis(1 2)
	      || line le_bm year
	      || line diff  year
	      || lfit diff  year
	      ||,
		 ytitle( "",         axis(2) )
		 xtitle( "",         axis(2) )
		 xlabel( 1918,       axis(2) )
		 ylabel( 0(5)20,     axis(2) grid gmin angle(horizontal) )
		 ylabel( 0 20(10)80,              gmax angle(horizontal) )
		 ytitle( "Life expectancy at birth (years)" )
		 title( "White and black life expectancy" )
		 subtitle( "USA, 1900-1999" )
		 note( "Source: National Vital Statistics, Vol 50, No. 6"
		       "(1918 dip caused by 1918 Influenza Pandemic)" )
		 legend( label(1 "White males") label(2 "Black males") ){txt}
	  {it:({stata gr_example2 line3a:click to run})}
{* graph line3}{...}

{pstd}
There are many options on this command. (All except the first two options
could have been accomplished in the Graph Editor; see
{manhelp graph_editor G-1:Graph Editor} for an overview of the Editor.)
Strip away the obvious options, such as {cmd:title()}, {cmd:subtitle()}, and
{cmd:note()}, and you are left with{cmd}

	. twoway line le_wm year, yaxis(1 2) xaxis(1 2)
	      || line le_bm year
	      || line diff  year
	      || lfit diff  year
	      ||,
		 ytitle( "",         axis(2) )
		 xtitle( "",         axis(2) )
		 xlabel( 1918,       axis(2) )
		 ylabel( 0(5)20,     axis(2) grid gmin angle(horizontal) )
		 ylabel( 0 20(10)80,              gmax angle(horizontal) )
		 legend( label(1 "White males") label(2 "Black males") ){txt}

{pstd}
Let's take the longest option first:

		 {cmd:ylabel( 0(5)20,     axis(2) grid gmin angle(horizontal) )}

{pstd}
The first thing to note is that options have options:

		 {cmd:ylabel( 0(5)20,     axis(2) grid gmin angle(horizontal) )}
		 {hline 2}{c TT}{hline 2}               {hline 19}{c TT}{hline 15}
		   {c |}                                    {c |}
		   {c BLC}{hline 36}{c BRC}
		     {cmd:axis(2) grid gmin angle(horizontal)}
		     {it:are options of} {cmd:ylabel()}

{pstd}
Now look back at our graph.  It has two {it:y} axes, one on the right and
a second on the left.  Typing 

		 {cmd:ylabel( 0(5)20,     axis(2) grid gmin angle(horizontal) )}

{pstd}
caused the right axis -- {cmd:axis(2)} -- to have labels at
0, 5, 10, 15, and 20 -- {cmd:0(5)20}.  {cmd:grid} requested grid lines
for each labeled tick on this right axis, and {cmd:gmin} forced the grid line
at 0 because, by default, {cmd:graph} does not like to draw grid lines too
close to the axis.  {cmd:angle(horizontal)} made the 0, 5, 10, 15, and 20 
horizontal rather than, as usual, vertical.

{pstd}
You can now guess what

		 {cmd:ylabel( 0 20(10)80,         gmax angle(horizontal) )}

{pstd}
did.  It labeled the left {it:y} axis -- {cmd:axis(1)} in the
jargon -- but we did not have to specify an {cmd:axis(1)} suboption because
that is what {cmd:ylabel()} assumes.  The purpose of

		 {cmd:xlabel( 1918,       axis(2) )}

{pstd}
is now obvious, too.  That labeled a value on the second {it:x} axis.

{pstd}
So now we are left with{cmd}

	. twoway line le_wm year, yaxis(1 2) xaxis(1 2)
	      || line le_bm year
	      || line diff  year
	      || lfit diff  year
	      ||,
		 ytitle( "",         axis(2) )
		 xtitle( "",         axis(2) )
		 legend( label(1 "White males") label(2 "Black males") ){txt}

{pstd}
Options {cmd:ytitle()} and {cmd:xtitle()} specify the axis titles.
We did not want titles on the second axes, so we got rid of them.
The {cmd:legend()} option,

		 {cmd:legend( label(1 "White males") label(2 "Black males") )}

{pstd}
merely respecified the text to be used for the first two keys.  By default,
{cmd:legend()} uses the variable label, which in this case would be the labels
of variables {cmd:le_wm} and {cmd:le_bm}.  In our dataset, those labels are
"Life expectancy, white males" and "Life expectancy, black males".  It
was not necessary -- and undesirable -- to repeat "Life expectancy",
so we specified an option to change the label.  It was either that or change
the variable label.

{pstd}
So now we are left with{cmd}

	. twoway line le_wm year, yaxis(1 2) xaxis(1 2)
	      || line le_bm year
	      || line diff  year
	      || lfit diff  year{txt}

{pstd}
and that is almost perfectly understandable.  The {cmd:yaxis()} and
{cmd:xaxis()} options caused the creation of two {it:y} and two {it:x}
axes rather than, as usual, one.

{pstd}
Understand how we arrived at{cmd}

	. twoway line le_wm year, yaxis(1 2) xaxis(1 2)
	      || line le_bm year
	      || line diff  year
	      || lfit diff  year
	      ||,
		 ytitle( "",         axis(2) )
		 xtitle( "",         axis(2) )
		 xlabel( 1918,       axis(2) )
		 ylabel( 0(5)20,     axis(2) grid gmin angle(horizontal) )
		 ylabel( 0 20(10)80,              gmax angle(horizontal) )
		 ytitle( "Life expectancy at birth (years)" )
		 title( "White and black life expectancy" )
		 subtitle( "USA, 1900-1999" )
		 note( "Source: National Vital Statistics, Vol 50, No. 6"
		       "(1918 dip caused by 1918 Influenza Pandemic)" )
		 legend( label(1 "White males") label(2 "Black males") ){txt}

{pstd}
We started with the first graph we showed you,

	{cmd:. twoway line le_wm year || line le_bm year}

{pstd}
and then, to emphasize the comparison of life expectancy
for whites and blacks, we added the difference,{cmd}

	. twoway line le_wm year,
	      || line le_bm year
	      || line diff  year{txt}

{pstd}
and then, to emphasize the linear trend in the difference, we added
"{cmd:lfit} {cmd:diff} {cmd:year}",

	{cmd}. twoway line le_wm year,
	      || line le_bm year
	      || line diff  year,
	      || lfit diff  year{txt}

{pstd}
and then we added options to make the graph look more like what we wanted.
We introduced the options one at a time.  It was rather fun, really.
As our command grew, we switched to using the Do-file Editor, where
we could add an option and hit the {bf:Do} button to see where we were.
Because the command was so long, when we opened the Do-file Editor, we typed on
the first line

	{cmd:#delimit ;}

{pstd}
and we typed on the last line

	{cmd:;}

{pstd}
and then we typed our ever-growing command between.

{pstd}
Many of the options we used above are common to most of the graph
families, including {cmd:twoway}, {cmd:bar}, {cmd:box}, {cmd:dot}, and
{cmd:pie}.  If you understand how the {cmd:title()} or {cmd:legend()} option
is used with one family, you can apply that knowledge to all graphs,
because these options work the same across families.

{pstd}
While we are on the subject of life expectancy, using another dataset, we
drew

	{it:({stata "gr_example2 markerlabel3":click to run})}
{* graph markerlabel3}{...}

{pstd}
See {manhelpi marker_label_options G-3} for an explanation of how we did this.
Staying with life expectancy, we produced

	{it:({stata "gr_example2 combine4":click to run})}
{* graph combine4}{...}

{pstd}
which we drew by separately drawing three rather easy graphs{cmd}

	. twoway scatter lexp loggnp,
		yscale(alt) xscale(alt)
		xlabel(, grid gmax)              saving(yx)

	. twoway histogram lexp, fraction
		xscale(alt reverse) horiz        saving(hy)

	. twoway histogram loggnp, fraction
		yscale(alt reverse)
		ylabel(,nogrid)
		xlabel(,grid gmax)               saving(hx){txt}

{pstd}
and then combining them:

	{cmd}. graph combine hy.gph yx.gph hx.gph,
		hole(3)
		imargin(0 0 0 0) grapharea(margin(l 22 r 22))
		title("Life expectancy at birth vs. GNP per capita")
		note("Source:  1998 data from The World Bank Group"){txt}

{pstd}
See {manhelp graph_combine G-2:graph combine} for more information.

{pstd}
Back to our tour, {cmd:twoway,} {cmd:by()} can produce graphs that look like
this

	{cmd:. sysuse auto, clear}

	{cmd:. scatter mpg weight, by(foreign, total row(1))}
	  {it:({stata "gr_example auto: scatter mpg weight, by(foreign, total row(1))":click to run})}
{* graph mpgweightbyt1r}{...}

{pstd}
or this

	{cmd:. scatter mpg weight, by(foreign, total col(1))}
	  {it:({stata "gr_example auto: scatter mpg weight, by(foreign, total col(1))":click to run})}
{* graph mpgweightbyt1c}{...}

{pstd}
or this

	{cmd:. scatter mpg weight, by(foreign, total)}
	  {it:({stata "gr_example auto: scatter mpg weight, by(foreign, total)":click to run})}
{* graph mpgweightbyt}{...}

{pstd}
See {manhelpi by_option G-3}.

{pstd}
{cmd:by()} is another of those options that is common across all graph
families.  If you know how to use it on one type of graph, then you know how
to use it on any type of graph.

{pstd}
There are many plottypes within the {cmd:twoway} family, including areas,
bars, spikes, dropped lines, and dots.  Just to illustrate a few:

	{cmd}. sysuse sp500

	. replace volume = volume/1000

	. twoway
		rspike hi low date ||
		line   close  date ||
		bar    volume date, barw(.25) yaxis(2) ||
	  in 1/57
	  , yscale(axis(1) r(900 1400))
	    yscale(axis(2) r(  9   45))
	    ylabel(, axis(2) grid)
	    ytitle("                          Price -- High, Low, Close")
	    ytitle(" Volume (millions)", axis(2) bexpand just(left))
	    legend(off)
	    subtitle("S&P 500", margin(b+2.5))
	    note("Source:  Yahoo!Finance and Commodity Systems, Inc."){txt}
	  {it:({stata "gr_example2 tworspike":click to run})}
{* graph tworspike}{...}

{pstd}
The above graph is explained in {manhelp twoway_rspike G-2:graph twoway rspike}.  See
{manhelp graph_twoway G-2:graph twoway} for a listing of all available
{cmd:twoway} plottypes.

{pstd}
Moving outside the {cmd:twoway} family, {cmd:graph} can draw scatterplot
matrices, box plots, pie charts, and bar and dot plots.  Here are examples of
each.


{pstd}
A scatterplot matrix of the variables {cmd:popgr}, {cmd:lexp}, {cmd:lgnppc},
and {cmd:safe}:

	{cmd:. sysuse lifeexp, clear}

	{cmd:. generate lgnppc = ln(gnppc)}

{phang2}
	{cmd:. graph matrix popgr lgnppc safe lexp}{p_end}
	  {it:({stata "gr_example2 matrix3a":click to run})}
{* graph matrix3a}{...}

{pstd}
Or, with grid lines and more axis labels:

	{cmd}. graph matrix popgr lgnppc safe lexp,
		maxes(ylab(#4, grid) xlab(#4, grid)){txt}
	  {it:({stata "gr_example2 matrix3":click to run})}
{* graph matrix3}{...}

{pstd}
See {manhelp graph_matrix G-2:graph matrix}.


{pstd}
A box plot of blood pressure, variable {cmd:bp}, over each group in the
variable {cmd:when} and each group in the variable {cmd:sex}:

	{cmd:. sysuse bplong, clear}

	{cmd:. graph box bp, over(when) over(sex)}
	  {it:({stata "gr_example2 grbox1a":click to run})}
{* graph grbox1a}{...}

{pstd}
Or, for a graph with complete titles:

	{cmd}. graph box bp, over(when) over(sex)
		ytitle("Systolic blood pressure")
		title("Response to Treatment, by Sex")
		subtitle("(120 Preoperative Patients)" " ")
		note("Source:  Fictional Drug Trial, StataCorp, 2003"){txt}
	  {it:({stata "gr_example2 grbox1":click to run})}
{* graph grbox1}{...}

{pstd}
See {manhelp graph_box G-2:graph box}.


{pstd}
A pie chart showing the proportions of the variables {cmd:sales},
{cmd:marketing}, {cmd:research}, and {cmd:development}.

	{cmd:. graph pie sales marketing research development}
	  {it:({stata "gr_example2 pie1a":click to run})}
{* graph grpie1a}{...}

{pstd}
Or, for a graph with nice titles and better labeling of the pie slices:

	{cmd:. graph pie sales marketing research development,}
		{cmd:plabel(_all name, size(*1.5) color(white))}
		{cmd:legend(off)}
		{cmd:plotregion(lstyle(none))}{col 66}
		{cmd:title("Expenditures, XYZ Corp.")}
		{cmd:subtitle("2002")}
		{cmd:note("Source:  2002 Financial Report (fictional data)")}
	  {it:({stata "gr_example2 pie1":click to run})}
{* graph grpie1}{...}

{pstd}
See {manhelp graph_pie G-2:graph pie}.


{pstd}
A vertical bar chart of average wages over each group in the variables
{cmd:smsa}, {cmd:married}, and {cmd:collgrad}:

	{cmd:. sysuse nlsw88}

{phang2}
	{cmd:. graph bar wage, over(smsa) over(married) over(collgrad)}{p_end}
	  {it:({stata "gr_example2 grbar5b0":click to run})}
{* graph grbar5b0}{...}

{pstd}
Or, for a prettier graph, with overlapping bars, titles, and better labels:

	{cmd}. graph bar wage,
			over( smsa, descend gap(-30) )
			over( married )
			over( collgrad, relabel(1 "Not college graduate"
						2 "College graduate"    ) )
			ytitle("")
			title("Average Hourly Wage, 1988, Women Aged 34-46")
			subtitle("by College Graduation, Marital Status,
				  and SMSA residence")
			note("Source:  1988 data from NLS, U.S. Dept of Labor,
			      Bureau of Labor Statistics"){txt}
	  {it:({stata "gr_example2 grbar5b":click to run})}
{* graph grbar5b}{...}

{pstd}
See {manhelp graph_bar G-2:graph bar}.

{pstd}
A horizontal bar chart of private versus public spending over countries:

	{cmd:. sysuse educ99gdp}

	{cmd:. generate total = private + public}

	{cmd:. graph hbar (asis) public private , over(country)}
	  {it:({stata "gr_example2 grbar7a":click to run})}
{* graph grbar7a}{...}

{pstd}
Or, the same information with stacked bars, an informative sorting of total
spending, and nice titles:

	{cmd}. graph hbar (asis) public private,
			over(country, sort(total) descending)
			stack
			title("Spending on tertiary education as % of GDP,
			       1999", span position(11) )
			subtitle(" ")
			note("Source:  OECD, Education at a Glance 2002", span){txt}
	  {it:({stata "gr_example2 grbar7":click to run})}
{* graph grbar7}{...}

{pstd}
See {manhelp graph_bar G-2:graph bar}.


{pstd}
A dot chart of average hourly wage over occupation, variable {cmd:occ}, with
separate subgraphs for college graduates and not college graduates, variable
{cmd:collgrad}:  

	{cmd:. sysuse nlsw88, clear}

	{cmd:. graph dot wage, over(occ) by(collgrad)}
	  {it:({stata gr_example2 grdotby0:click to run})}
{* graph grdotby0}{...}

{pstd}
Or, for a plot that orders the occupations by wage and has nice titles:

	{cmd}. graph dot wage,
		over(occ, sort(1))
		by(collgrad,
		     title("Average hourly wage, 1988, women aged 34-46", span)
		     subtitle(" ")
		     note("Source:  1988 data from NLS, U.S. Dept. of Labor,
			   Bureau of Labor Statistics", span)
		){txt}
	  {it:({stata gr_example2 grdotby:click to run})}
{* graph grdotby}{...}

{pstd}
See {manhelp graph_dot G-2:graph dot}.

{pstd}
Have fun.  Follow our advice in the
{it:{help graph_intro##reading:Suggested reading order}} above: turn to
{manhelp graph G-2}, {manhelp twoway G-2:graph twoway}, and
{manhelp scatter G-2:graph twoway scatter}.


{marker menus}{...}
{title:Using the menus}

{pstd}
In addition to using the command-line interface, you can access most of
{cmd:graph}'s features by Stata's pulldown menus.  To start, load a dataset,
select {bf:Graphics}, and select what interests you.

{pstd}
When you have finished filling in the dialog box (do not forget to click on
the tabs -- lots of useful features are hidden there), rather than click on
{bf:OK}, click on {bf:Submit}.  This way, once the graph appears, you can easily
modify it and click on {bf:Submit} again.

{pstd}
Feel free to experiment.  Clicking on {bf:Submit} (or {bf:OK}) never hurts; if
you have left a required field blank, you will be told.  The dialog boxes
make it easy to spot what you can change.


{marker references}{...}
{title:References}

{marker C1993}{...}
{phang}
Cleveland, W. S. 1993.
{it:Visualizing Data}.
Summit, NJ: Hobart.

{marker C1994}{...}
{phang}
------. 1994.
{it:The Elements of Graphing Data}. Rev. ed.
Summit, NJ: Hobart.

{marker C2014}{...}
{phang}
Cox, N. J. 2014.
{browse "http://www.stata-press.com/books/speaking-stata-graphics":{it:Speaking Stata Graphics}}.
College Station, TX: Stata Press.

{marker GH2009}{...}
{phang}
Good, P. I., and J. W. Hardin. 2009.
{browse "http://www.stata.com/bookstore/ceis.html":{it:Common Errors in Statistics (and How to Avoid Them)}. 3rd ed.}
New York: Wiley.

{marker H2009}{...}
{phang}
Hamilton, L. C. 2009.
{browse "http://www.stata.com/bookstore/sws.html":{it:Statistics with Stata (Updated for Version 10)}.}
Belmont, CA: Brooks/Cole.

{marker M2012}{...}
{phang}
Mitchell, M. N. 2012.
{browse "http://www.stata-press.com/books/vgsg3.html":{it:A Visual Guide to Stata Graphics}. 3rd ed.}
College Station, TX: Stata Press.

{marker WWPJH1996}{...}
{phang}
Wallgren, A., B. Wallgren, R. Persson, U. Jorner, and J.-A. Haaland. 1996.
{it:Graphing Statistics and Data: Creating Better Charts}.
Newbury Park, CA: Sage.
{p_end}
