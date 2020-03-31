{smcl}
{* *! version 1.2.5  08jan2018}{...}
{viewerdialog histogram "dialog histogram"}{...}
{vieweralsosee "[R] histogram" "mansection R histogram"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway histogram" "help twoway_histogram"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] kdensity" "help kdensity"}{...}
{vieweralsosee "[R] spikeplot" "help spikeplot"}{...}
{viewerjumpto "Syntax" "histogram##syntax"}{...}
{viewerjumpto "Menu" "histogram##menu"}{...}
{viewerjumpto "Description" "histogram##description"}{...}
{viewerjumpto "Links to PDF documentation" "histogram##linkspdf"}{...}
{viewerjumpto "Options for use in the continuous case" "histogram##options_continuous"}{...}
{viewerjumpto "Options for use in the discrete case" "histogram##options_discrete"}{...}
{viewerjumpto "Options for use in the continuous and discrete cases" "histogram##options_both"}{...}
{viewerjumpto "Remarks" "histogram##remarks"}{...}
{viewerjumpto "Reference" "histogram##reference"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[R] histogram} {hline 2}}Histograms for continuous and categorical variables
{p_end}
{p2col:}({mansection R histogram:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 18 2}
{opt histogram}
{varname}
{ifin}
[{it:{help histogram##weight:weight}}]
[{cmd:,}
[{it:{help histogram##continuous_opts:continuous_opts}} {c |}
{it:{help histogram##discrete_opts:discrete_opts}}] {it:{help histogram##options:options}}]

{synoptset 34 tabbed}{...}
{marker continuous_opts}{...}
{synopthdr :continuous_opts}
{synoptline}
{syntab:Main}
{synopt :{opt bin(#)}}set number of bins to {it:#}{p_end}
{synopt :{opt w:idth(#)}}set width of bins to {it:#}{p_end}
{synopt :{opt start(#)}}set lower limit of first bin to {it:#}{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 34 tabbed}{...}
{marker discrete_opts}{...}
{synopthdr :discrete_opts}
{synoptline}
{syntab:Main}
{synopt :{opt d:iscrete}}specify that data are discrete{p_end}
{synopt :{opt w:idth(#)}}set width of bins to {it:#}{p_end}
{synopt :{opt start(#)}}set theoretical minimum value to {it:#}{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 34 tabbed}{...}
{marker options}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{synopt :{opt den:sity}}draw as density; the default{p_end}
{synopt :{opt frac:tion}}draw as fractions{p_end}
{synopt :{opt freq:uency}}draw as frequencies{p_end}
{synopt :{opt percent}}draw as percentages{p_end}
{synopt :{it:{help twoway bar:bar_options}}}rendition of bars{p_end}
{synopt :{opt binrescale}}recalculate bin sizes when {cmd:by()} is specified{p_end}
{synopt :{opt addl:abels}}add height labels to bars{p_end}
{synopt :{opth addlabop:ts(marker_label_options)}}affect rendition of labels{p_end}

{syntab :Density plots}
{synopt :{opt norm:al}}add a normal density to the graph{p_end}
{synopt :{opth normop:ts(line_options)}}affect rendition of normal
density{p_end}
{synopt :{opt kden:sity}}add a kernel density estimate to the graph{p_end}
{synopt :{opth kdenop:ts(kdensity:kdensity_options)}}affect rendition of kernel density{p_end}


{syntab :Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the histogram

{syntab :Y axis, X axis, Titles, Legend, Overall, By}
{synopt :{it:twoway_options}}any options documented in 
      {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}
{marker weight}{...}
{p 4 6 2}{cmd:fweight}s are allowed; see {help weight}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Histogram}


{marker description}{...}
{title:Description}

{pstd}
{cmd:histogram} draws histograms of {varname}, which is assumed to be the name
of a continuous variable unless the {opt discrete} option is specified.

{pstd}
{cmd:hist} is a synonym for {cmd:histogram}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R histogramQuickstart:Quick start}

        {mansection R histogramRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options_continuous}{...}
{title:Options for use in the continuous case}

{dlgtab:Main}

{phang}
{opt bin(#)} and {opt width(#)} are alternatives.  They specify how the data
are to be aggregated into bins: {opt bin()} by specifying the number of bins
(from which the width can be derived) and {opt width()} by specifying the bin
width (from which the number of bins can be derived).

{pmore}
If neither option is specified, results are the same as if {opt bin(k)}
had been specified, where

{phang3}
{it:k} = min{c -(}sqrt({it:N}), 10*ln({it:N})/ln(10){c )-}

{pmore}
    and where {it:N} is the (weighted) number of observations.

{phang}
{opt start(#)} specifies the theoretical minimum of {varname}.  The default
is {opt start(m)}, where {it:m} is the observed minimum value of {it:varname}.

{pmore}
Specify {opt start()} when you are concerned about sparse data, for instance,
if you know that {it:varname} can have a value of 0, but you are concerned
that 0 may not be observed.

{pmore}
{opt start(#)}, if specified, must be less than or equal to {it:m}, or else an
error will be issued.


{marker options_discrete}{...}
{title:Options for use in the discrete case}

{dlgtab:Main}

{phang}
{opt discrete} specifies that {varname} is discrete and that you want each
unique value of {it:varname} to have its own bin (bar of histogram).

{phang}
{opt width(#)} is rarely specified in the discrete case; it specifies the
width of the bins.  The default is {opt width(d)}, where {it:d} is the
observed minimum difference between the unique values of {it:varname}.

{pmore} 
Specify {opt width()} if you are concerned that your data are sparse.
For example, in theory {it:varname} could take on the values, say, 1, 2, 3,
..., 9, but because of the sparseness, perhaps only the values 2, 4, 7, and 8
are observed.  Here the default width calculation would produce
{cmd:width(2)}, and you would want to specify {cmd:width(1)}.

{phang}
{opt start(#)} is also rarely specified in the discrete case; it specifies the
theoretical minimum value of {varname}.  The default is {opt start(m)},
where {it:m} is the observed minimum value.

{pmore}
As with {opt width()}, specify {opt start(#)} if you are concerned that
your data are sparse.  In the previous example, you might also want to specify
{cmd:start(1)}.  {opt start()} does nothing more than add white
space to the left side of the graph.

{pmore}
The value of {it:#} in {opt start()} must be less than or equal to {it:m}, or
an error will be issued.


{marker options_both}{...}
{title:Options for use in the continuous and discrete cases}

{dlgtab:Main}

{phang}
{opt density},
{opt fraction},
{opt frequency}, and
{opt percent} specify whether you want the histogram scaled to density units,
fractional units, frequencies, or percentages.  {opt density} is the default.

{pmore}
{opt density} scales the height of the bars so that the sum of their areas
equals 1.

{pmore}
{opt fraction} scales the height of the bars so that the sum of their heights
equals 1.

{pmore}
{opt frequency} scales the height of the bars so that each bar's
height is equal to the number of observations in the category.  Thus the sum
of the heights is equal to the total number of observations.

{pmore}
{opt percent} scales the height of the bars so that the sum of their heights
equals 100.

{phang}
{it:bar_options} are any of the options allowed by {cmd:graph} {cmd:twoway}
{cmd:bar}; see {manhelp twoway_bar G-2:graph twoway bar}.

{pmore}
One of the most useful {it:bar_options} is {opt barwidth(#)}, which specifies
the width of the bars in {varname} units.  By default, {cmd:histogram} draws
the bars so that adjacent bars just touch.  If you want gaps between the bars,
do not specify {cmd:histogram}'s {opt width()} option -- which would
change how the histogram is calculated -- but specify the {it:bar_option}
{opt barwidth()} or the {cmd:histogram} option {opt gap}, both of which affect
only how the bar is rendered.

{pmore}
The {it:bar_option} {opt horizontal} cannot be used with the {cmd:addlabels}
option.

{phang}
{opt binrescale} specifies that bin size and plot range be recalculated for
each group when {cmd:by()} is specified.  If {cmd:normal} is specified, the
mean and standard deviation of each overlaid normal density plot are
recalculated in each group.  Similarly, if {cmd:kdensity} is specified, the
scaling of the overlaid kernel density plot is recalculated in each group.

{phang}
{opt addlabels} specifies that the top of each bar be labeled with the
density, fraction, or frequency, as determined by the {opt density}, 
{opt fraction}, and {opt frequency} options.

{phang}
{opt addlabopts(marker_label_options)} specifies how to render the labels atop
the bars.  See {manhelpi marker_label_options G-3}.  Do not specify the
{it:marker_label_option} {opt mlabel(varname)}, which specifies the variable
to be used; this is specified for you by {cmd:histogram}.

{pmore}
{opt addlabopts()} will accept more options than those documented in 
{manhelpi marker_label_options G-3}.  All options allowed by
{cmd:twoway scatter} are also allowed by {opt addlabopts()}; see
{manhelp scatter G-2:graph twoway scatter}.  One
particularly useful option is {opt yvarformat()}; see
{manhelpi advanced_options G-3}.

{dlgtab:Density plots}

{phang}
{opt normal} specifies that the histogram be overlaid with an appropriately
scaled normal density.  The normal will have the same mean and standard
deviation as the data.

{phang}
{opt normopts(line_options)}
    specifies details about the rendition of the normal curve, such as
    the color and style of line used.  See
    {manhelp twoway_line G-2:graph twoway line}.

{phang}
{opt kdensity} specifies that the histogram be overlaid with an
appropriately scaled kernel density estimate of the density.  By default, the
estimate will be produced using the Epanechnikov kernel with an "optimal"
half-width.  This default corresponds to the default of {opt kdensity}; see
{manhelp kdensity R}.  How the estimate is produced can be controlled using
the {opt kdenopts()} option described below.

{phang}
{opt kdenopts(kdensity_options)} specifies details about how the
kernel density estimate is to be produced along with details about the
rendition of the resulting curve, such as the color and style of line used.
The kernel density estimate is described in
{helpb twoway kdensity:[G-2] graph twoway kdensity}.  As an
example, if you wanted to produce kernel density estimates by using the Gaussian
kernel with optimal half-width, you would specify {cmd:kdenopts(gauss)} and if
you also wanted a half-width of 5, you would specify
{cmd:kdenopts(gauss width(5))}.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} allows adding more {opt graph} {opt twoway} plots to
the graph; see {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall, By}

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}.  This includes, most importantly, options for
titling the graph (see {manhelpi title_options G-3}), options for saving the
graph to disk (see {manhelpi saving_option G-3}), and the {opt by()} option,
which will allow you to simultaneously graph histograms for different subsets
of the data (see {manhelpi by_option G-3}).


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help histogram##remarks1:Histograms of continuous variables}
	{help histogram##remarks2:Overlaying normal and kernel-density estimates}
	{help histogram##remarks3:Histograms of discrete variables}
	{help histogram##remarks4:Use with by()}
	{help histogram##remarks5:Video example}

{pstd}
For an example of editing a histogram with the Graph Editor, see
{help histogram##P2011:Pollock (2011, 29-31)}.


{marker remarks1}{...}
{title:Histograms of continuous variables}

{pstd}
{cmd:histogram} assumes the variable is continuous, so you need type only
{cmd:histogram} followed by the variable name:

	{cmd:. sysuse sp500}
	{cmd:. histogram volume}
	  {it:({stata "gr_example sp500: histogram volume":click to run})}

{pstd}
Note the small values reported for density on the {it:y} axis.
They are correct; if you added up the area of the bars, you would get 1.
Nevertheless, many people are used to seeing histograms scaled so that the
bar heights sum to 1,

	{cmd:. histogram volume, fraction}
	  {it:({stata "gr_example sp500: histogram volume, fraction":click to run})}

{pstd}
and others are used to seeing histograms so that the bar height reflects the
number of observations:

	{cmd:. histogram volume, frequency}
	  {it:({stata "gr_example sp500: histogram volume, frequency":click to run})}

{pstd}
Regardless of the scale you prefer, we can specify other 
options to make the graph look more impressive:

	{cmd}. summarize volume

	{txt}    Variable {c |}       Obs        Mean    Std. Dev.       Min        Max
	{hline 13}{c +}{hline 56}
              volume {c |}{res}       248    12320.68    2585.929       4103    23308.3
{txt}
	{cmd}. histogram volume, freq
		xaxis(1 2)
		ylabel(0(10)60, grid)
		xlabel(12321 "mean"
		      9735 "-1 s.d."
		     14907 "+1 s.d."
		      7149 "-2 s.d."
		     17493 "+2 s.d."
		     20078 "+3 s.d."
		     22664 "+4 s.d."
					, axis(2) grid gmax)
		xtitle("", axis(2))
		subtitle("S&P 500, January 2001 - December 2001")
		note("Source:  Yahoo!Finance and Commodity Systems, Inc."){txt}
	  {it:({stata "gr_example2 hist1":click to run})}

{pstd}
For an explanation of the
{opt xaxis()} option -- it created the upper and lower {it:x} 
axis -- see {manhelpi axis_choice_options G-3}.  For an explanation
of the {opt ylabel()} and {opt xlabel()} options, see 
{manhelpi axis_label_options G-3}.  For an explanation of the {cmd:subtitle()}
and {cmd:note()} options, see {manhelpi title_options G-3}.


{marker remarks2}{...}
{title:Overlaying normal and kernel-density estimates}

{phang}
Specifying {opt normal} will overlay a normal density over the histogram.
It would be enough to type

	{cmd}. histogram volume, normal{txt}

{phang}
but we will add the option to our more impressive rendition:

	{cmd}. histogram volume, freq normal
		xaxis(1 2)
		ylabel(0(10)60, grid)
		xlabel(12321 "mean"
		      9735 "-1 s.d."
		     14907 "+1 s.d."
		      7149 "-2 s.d."
		     17493 "+2 s.d."
		     20078 "+3 s.d."
		     22664 "+4 s.d."
					, axis(2) grid gmax)
		xtitle("", axis(2))
		subtitle("S&P 500, January 2001 - December 2001")
		note("Source:  Yahoo!Finance and Commodity Systems, Inc."){txt}
	  {it:({stata "gr_example2 hist2":click to run})}

{pstd}
If we instead wanted to overlay a kernel-density estimate, we could
specify {cmd:kdensity} in place of {cmd:normal}.


{marker remarks3}{...}
{title:Histograms of discrete variables}

{pstd}
Specify {cmd:histogram}'s discrete option when you wish the data treated as
being discrete -- when you wish each unique value of the variable
assigned its own bin.  For instance, in the automobile data, {cmd:mpg} is a
continuous variable, but the mileage ratings have been measured to integer
precision.  Were we to type

	{cmd:. sysuse auto}
	{cmd:. histogram mpg}

{pstd}
{cmd:mpg} would be treated as continuous and categorized into eight bins by the
default number-of-bins calculation, which is based on the number of
observations, of which we have 74.

{pstd}
Adding the {opt discrete} option makes a histogram with a bin for each
of the 21 unique values:

	{cmd:. histogram mpg, discrete}
	  {it:({stata "gr_example auto: histogram mpg, discrete":click to run})}

{pstd}
Just as in the continuous case, the {it:y} axis was reported in
terms of density and we could specify the {cmd:fraction} or {cmd:frequency}
options if we wanted it reported differently.  Below we specify
{cmd:frequency}, we specify {cmd:addlabels} to add a report of
frequencies printed above the bars, we specify {cmd:ylabel(,grid)} to add
horizontal grid lines, and we specify {cmd:xlabel(12(2)42)} to label the
values 12, 14, ..., 42 on the {it:x} axis:

	{cmd:. histogram mpg, discrete freq addlabels ylabel(,grid) xlabel(12(2)42)}
	  {it:({stata "gr_example auto: histogram mpg, discrete freq addlabels ylabel(,grid) xlabel(12(2)42)":click to run})}


{marker remarks4}{...}
{title:Use with by()}

{pstd}
{cmd:histogram} may be used with {opt graph} {opt twoway}'s {opt by()};
for example,

	{cmd:. sysuse auto}
	{cmd:. histogram mpg, discrete by(foreign)}
	  {it:({stata "gr_example auto: histogram mpg, discrete by(foreign)":click to run})}

{pstd}
Here results would be easier to compare if the graphs were presented
in one column:

	{cmd:. histogram mpg, discrete by(foreign, col(1))}
	  {it:({stata "gr_example auto: histogram mpg, discrete by(foreign, col(1))":click to run})}

{pstd}
{cmd:col(1)} is a {cmd:by()} suboption -- see {manhelpi by_option G-3} -- 
and there are other useful suboptions, such as {opt total}, which will add
an overall total histogram.  {opt total} is a suboption of
{opt by()}, not an option of {cmd:histogram}, so you would type

	{cmd:. histogram mpg, discrete by(foreign, total)}

{pstd}
and not "{cmd:histogram mpg, discrete by(foreign) total}".

{pstd}
As another example, Lipset (1993) reprinted data from the {it:New York Times},
November 5, 1992, of data collected by the Voter Research and Surveys based on
questionnaires completed by 15,490 U.S. presidential voters from 300 polling
places on election day in 1992.

{phang2}{cmd:. sysuse voter}{p_end}
{phang2}{cmd:. histogram candi [freq=pop], discrete fraction by(inc, total) gap(40) xlabel(2 3 4, valuelabel)}{p_end}
{phang2}{it:({stata "gr_example voter:histogram candi [freq=pop], discrete fraction by(inc, total) barwidth(.6) xlabel(2 3 4, valuelabel)":click to run})}

{pstd}
We specified {cmd:gap(40)} to reduce the width of the bars by 40%.
Also note our use of the {opt xlabel()}'s {opt valuelabel} suboption, which
caused our bars to be labeled Clinton, Bush, and Perot rather than 2, 3, and
4; see {manhelpi axis_label_options G-3}.
{p_end}


{marker remarks5}{...}
{title:Video example}

{phang}
{browse "http://www.youtube.com/watch?v=nPqNZVToGx8":Histograms in Stata}


{marker reference}{...}
{title:Reference}

{marker P2011}{...}
{phang}
Pollock, P. H. III.  2011.
{browse "http://www.stata.com/bookstore/scpa.html":{it:A Stata Companion to Political Analysis}}. 2nd ed.
Washington, DC: CQ Press.
{p_end}
