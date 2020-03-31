{smcl}
{* *! version 1.2.6  17apr2018}{...}
{viewerdialog tsline "dialog tsline"}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[TS] tsline" "mansection TS tsline"}{...}
{vieweralsosee "[G-2] graph twoway tsline" "mansection G-2 graphtwowaytsline"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtline" "help xtline"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway" "help graph_twoway"}{...}
{viewerjumpto "Syntax" "tsline##syntax"}{...}
{viewerjumpto "Menu" "tsline##menu"}{...}
{viewerjumpto "Description" "tsline##description"}{...}
{viewerjumpto "Links to PDF documentation" "tsline##linkspdf"}{...}
{viewerjumpto "Options" "tsline##options"}{...}
{viewerjumpto "Remarks/Examples" "tsline##remarks"}{...}
{viewerjumpto "Video example" "tsline##video"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[G-2] graph twoway tsline} {hline 2}}Twoway line plots{p_end}
{p2col:}({mansection G-2 graphtwowaytsline:View complete PDF manual entry}){p_end}
{p2colreset}{...}

{p2colset 1 16 18 2}{...}
{p2col:{bf:[TS] tsline} {hline 2}}Time-series line plots{p_end}
{p2col:}({mansection TS tsline:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Time-series line plot

{p 8 24 2}
[{cmdab:tw:oway}]
{cmd:tsline}
	{varlist}
	{ifin}
	[{cmd:,}
	{help tsline##tsline_options:{it:tsline_options}}]


{pstd}
Time-series range plot with lines

{p 8 25 2}
[{cmdab:tw:oway}]
{cmd:tsrline}
	{it:y_1} {it:y_2}
	{ifin}
	[{cmd:,}
	{help tsline##tsrline_options:{it:tsrline_options}}]


{phang}
where the time variable is assumed set by {helpb tsset}, {it:varlist} has the
interpretation

		{it:y_1} [{it:y_2} ... {it:y_k}]

{marker tsline_options}{...}
{synoptset 20 tabbed}{...}
{synopthdr:tsline_options}
{synoptline}
{syntab:Plots}
{synopt:{it:scatter_options}}any options documented in
            {manhelp scatter G-2:graph twoway scatter} with the exception of
                  {it:marker_options},
                  {it:marker_placement_options}, and
                  {it:marker_label_options},
                  which will be ignored if specified{p_end}

{syntab:Y axis, Time axis, Titles, Legend, Overall, By}
{synopt :{it:twoway_options}}any options documented in {manhelpi twoway_options G-3}{p_end}
{synoptline}

{marker tsrline_options}{...}
{synopthdr:tsrline_options}
{synoptline}
{syntab:Plots}
{synopt:{it:rline_options}}any options documented in
             {manhelp twoway_rline G-2:graph twoway rline}{p_end}

{syntab:Y axis, Time axis, Titles, Legend, Overall, By}
{synopt :{it:twoway_options}}any options documented in 
              {manhelpi twoway_options G-3}{p_end}
{synoptline}


{marker menu}{...}
{title:Menu}

    {title:tsline and tsrline}

{phang2}
{bf:Statistics > Time series > Graphs > Line plots}

    {title:twoway tsline and twoway tsrline}

{phang2}
{bf:Graphics > Twoway graph (scatter, line, etc.)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:tsline} draws line plots for time-series data.

{pstd}
{cmd:tsrline} draws a range plot with lines for time-series data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowaytslineQuickstart:Quick start}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Plots}

{phang}
{it:scatter_options}
    are any of the options allowed by the {cmd:graph} {cmd:twoway}
    {cmd:scatter} command except that {it:marker_options},
    {it:marker_placement_options}, and {it:marker_label_options} will be
    ignored if specified; see {manhelp scatter G-2:graph twoway scatter}.

{phang}
{it:rline_options}
    are any of the options allowed by the {cmd:graph} {cmd:twoway}
    {cmd:rline} command; see {manhelp twoway_rline G-2:graph twoway rline}.

{dlgtab:Y axis, Time axis, Titles, Legend, Overall, By}

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}.  These include options for titling the graph (see
{manhelpi title_options G-3}), options for saving the graph to disk (see
{manhelpi saving_option G-3}), and the {cmd:by()} option, which will allow
you to simultaneously plot different subsets of the data (see 
{manhelpi by_option G-3}).

{pmore}
Also see the {cmd:recast()} option discussed in 
{manhelpi advanced_options G-3} for information on how to plot spikes, bars,
etc., instead of lines.


{marker remarks}{...}
{title:Remarks}

    {title:Example 1}

{pstd}
We simulated two separate time series (each of 200 observations) and placed
them in a Stata dataset, {cmd:tsline1.dta}.  The first series simulates
an AR(2) process with {it:phi}_1=0.8 and {it:phi}_2=0.2; the second series
simulates an MA(2) process with {it:theta}_1=0.8 and {it:theta}_2=0.2.
We use {cmd:tsline} to graph these two series.

	{cmd:. sysuse tsline1}
	{cmd:. tsset lags}
	{cmd:. tsline ar ma}
	  {it:({stata "tsline_ex arma":click to run})}


{marker ex2}{...}
    {title:Example 2}

{pstd}
Suppose that we kept a calorie log for an entire calendar year.  At the end of
the year, we would have a dataset (for example, {cmd:tsline2.dta}) that
contains the number of calories consumed for 365 days.  We could then use
{cmd:tsset} to identify the date variable and {cmd:tsline} to plot calories
versus time.  Knowing that we tend to eat a little more food on Thanksgiving
and Christmas day, we use the {cmd:ttick()} and {cmd:ttext()} options to point
out these days on the time axis.

	{cmd:. sysuse tsline2}
	{cmd:. tsset day}
	{cmd:. tsline calories, ttick(28nov2002 25dec2002, tpos(in))}
	{cmd:      ttext(3470 28nov2002 "thanks"}
	{cmd:            3470 25dec2002 "x-mas"}
	{cmd:            , orient(vert))}
	  {it:({stata "tsline_ex calories":click to run})}

{pstd}
Options associated with the time axis allow dates (and times) to be specified
in place of numeric date (and time) values.  For instance, we used

{pmore}
{cmd:ttick(28nov2002 25dec2002, tpos(in))}

{pstd}
to place tick marks at the specified dates.  This works similarly for
{cmd:tlabel()}, {cmd:tmlabel()}, and {cmd:tmtick()}.

{pstd}
Suppose that we wanted to place vertical lines for the previously mentioned
holidays.  We could specify the dates in the {cmd:tline()} option as follows:

	{cmd:. sysuse tsline2}
	{cmd:. tsset day}
	{cmd:. tsline calories, tline(28nov2002 25dec2002)}
	  {it:({stata "tsline_ex calories2":click to run})}


    {title:Example 3}

{pstd}
We could also modify the format of the time axis so that the labeled ticks
display only the day in the year:

	{cmd:. sysuse tsline2}
	{cmd:. tsset day}
	{cmd:. tsline calories, tlabel(, format(%tdmd)) ttitle("Date (2002)")}
	  {it:({stata "tsline_ex calories3":click to run})}


    {title:Example 4}

{pstd}
{cmd:tsline} and {cmd:tsrline} are both commands and {it:plottype}s as defined
in {helpb twoway:[G-2] graph twoway}.  Thus the syntax for {cmd:tsline} is

	{cmd:. graph twoway tsline} ...

	{cmd:. twoway tsline} ...

	{cmd:. tsline} ...

{pstd}
and similarly for {cmd:tsrline}.
Being plot types, these commands may be combined with other plot types in the
{cmd:twoway} family, as in,

{phang2}
	{cmd:. twoway (tsrline} ...{cmd:) (tsline} ...{cmd:) (lfit} ...{cmd:)} ...

{pstd}
which can equivalently be written as

{phang2}
	{cmd:. tsrline} ... {cmd:|| tsline} ... {cmd:|| lfit} ... {cmd:||} ...

{pstd}
In the first plot of {help tsline##ex2:example 2}, we were uncertain of the
exact values we logged, so we also gave a range for each day.  Here is a plot
of the summer months.

	{cmd:. sysuse tsline2}
	{cmd:. tsset day}
	{cmd:. tsrline lcalories ucalories if tin(1may2002,31aug2002)}
	{cmd:      || tsline calories}
	{cmd:      || if tin(1may2002,31aug2002), ytitle(Calories)}
	  {it:({stata "tsline_ex rcalories":click to run})}


{marker video}{...}
{title:Video example}

{phang2}{browse "http://www.youtube.com/watch?v=JYrnG71zJhM":Line graphs and tin()}
{p_end}
