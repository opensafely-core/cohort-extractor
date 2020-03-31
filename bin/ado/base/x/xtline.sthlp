{smcl}
{* *! version 1.2.10  19oct2017}{...}
{viewerdialog xtline "dialog xtline"}{...}
{vieweralsosee "[XT] xtline" "mansection XT xtline"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtset" "help xtset"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway" "help twoway"}{...}
{vieweralsosee "[TS] tsline" "help tsline"}{...}
{viewerjumpto "Syntax" "xtline##syntax"}{...}
{viewerjumpto "Menu" "xtline##menu"}{...}
{viewerjumpto "Description" "xtline##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtline##linkspdf"}{...}
{viewerjumpto "Options for graph by panel" "xtline##options_by"}{...}
{viewerjumpto "Options for overlaid panels" "xtline##options_overlaid"}{...}
{viewerjumpto "Examples" "xtline##examples"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[XT] xtline} {hline 2}}Panel-data line plots{p_end}
{p2col:}({mansection XT xtline:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Graph by panel

{p 8 23 2}
{cmd:xtline} {varlist} {ifin} [{cmd:,} {it:{help xtline##panel:panel_options}}]


{phang}
Overlaid panels

{p 8 23 2}
{cmd:xtline} {varname} {ifin}{cmd:,} {opt ov:erlay} 
[{it:{help xtline##overlaid:overlaid_options}}]


{marker panel}{...}
{synoptset 25 tabbed}{...}
{synopthdr :panel_options}
{synoptline}
{syntab:Main}
{synopt :{opth "i(varname:varname_i)"}}use
	{it:varname_i} as the panel ID variable{p_end}
{synopt :{opth "t(varname:varname_t)"}}use
	{it:varname_t} as the time variable{p_end}

{syntab:Plot}
{synopt :{it:{help cline_options}}}affect rendition of the plotted points connected by lines{p_end}

{syntab:Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated graph{p_end}

{syntab:Y axis, Time axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {opt by()} documented in
     {manhelpi twoway_options G-3}{p_end}
{synopt :{opth by:opts(by_option:byopts)}}affect appearance of the combined graph{p_end}
{synoptline}
{p2colreset}{...}

{marker overlaid}{...}
{synoptset 26 tabbed}{...}
{synopthdr :overlaid_options}
{synoptline}
{syntab:Main}
{synopt :{opt ov:erlay}}overlay each panel on the same graph{p_end}
{synopt :{opth "i(varname:varname_i)"}}use
	{it:varname_i} as the panel ID variable{p_end}
{synopt :{opth "t(varname:varname_t)"}}use
	{it:varname_t} as the time variable{p_end}

{syntab:Plots}
{synopt :{cmdab:plot:}{ul:{it:#}}{opth "opts(cline_options:cline_options)"}}affect rendition of the {it:#} panel line{p_end}

{syntab:Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated graph{p_end}

{syntab:Y axis, Time axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {opt by()} documented in 
        {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}

{p 4 6 2}
A panel variable and a time variable must be specified.  Use {cmd:xtset}
(see {helpb xtset:[XT] xtset}) or specify the {cmd:i()} and {cmd:t()} options.
The {cmd:t()} option allows noninteger values for the time variable, whereas
{cmd:xtset} does not.
                                                                                

{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Longitudinal/panel data > Line plots}


{marker description}{...}
{title:Description}

{pstd}
{cmd:xtline} draws line plots for panel data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtlineQuickstart:Quick start}

        {mansection XT xtlineRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options_by}{...}
{title:Options for graph by panel}

{dlgtab:Main}

{phang}
{opth "i(varname:varname_i)"}
and
{opt t(varname_t)} override the panel settings from {helpb xtset}.
{it:varname_i} is allowed to be a string variable.
{it:varname_t} can take on noninteger values and have repeated values within
panel.  That is to say, it can be any numeric variable that you would like to
specify for the x-dimension of the graph.  It is an error to specify {opt i()}
without {opt t()} and vice versa.

{dlgtab:Plot}

{phang}
{it:cline_options} affect the rendition of the plotted points connected by
lines; see {manhelpi cline_options G-3}.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the generated graph;
see {manhelpi addplot_option G-3}.

{dlgtab:Y axis, Time axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in help
{manhelpi twoway_options G-3}, excluding {cmd:by()}.  These include options for
titling the graph (see {manhelpi title_options G-3}) and for saving
the graph to disk (see {manhelpi saving_option G-3}).

{phang}
{opt byopts(byopts)} allows all the options documented in
{manhelpi by_option G-3}.  These options affect the appearance of the by-graph.
{opt byopts()} may not be combined with {opt overlay}.


{marker options_overlaid}{...}
{title:Options for overlaid panels}

{dlgtab:Main}

{phang}
{opt overlay} causes the plot from each panel to be overlaid on the same
graph.  The default is to generate plots by panel.  This option may not be
combined with {opt byopts()} or be specified when there are multiple variables
in {varlist}.

{phang}
{opth "i(varname:varname_i)"}
and
{opt t(varname_t)} override the panel settings from {helpb xtset}.
{it:varname_i} is allowed to be a string variable.
{it:varname_t} can take on noninteger values and have repeated values within
panel.  That is to say, it can be any numeric variable that you would like to
specify for the x-dimension of the graph.  It is an error to specify {opt i()}
without {opt t()} and vice versa.


{dlgtab:Plots}

{phang}
{cmd:plot}{it:#}{opt opts(cline_options)} affect the rendition of the {it:#}th
panel (in sorted order).  The {it:cline_options} can affect whether and how
the points are connected; see {manhelpi cline_options G-3}.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the generated graph;
see {manhelpi addplot_option G-3}.

{dlgtab:Y axis, Time axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}, excluding {cmd:by()}.  These include options for
titling the graph (see {manhelpi title_options G-3}) and for saving
the graph to disk (see {manhelpi saving_option G-3}).


{marker examples}{...}
{title:Examples}

{pstd}
Suppose that Tess, Sam, and Arnold kept a calorie log for an entire calendar
year.  At the end of the year, if they pooled their data together, they would
have a dataset (for example, {cmd:xtline1.dta}) that contains the amount of
calories consumed for 365 days for each of them.  They could then use
{cmd:xtset} to identify the date variable and treat each person as a panel, and
then use {cmd:xtline} to plot the calories versus time for each person
separately.

	{cmd:. sysuse xtline1}
	{cmd:. xtset person day}
	{cmd:. xtline calories, tlabel(#3)}
	  {it:({stata "xtline_ex caloriesby":click to run})}

{pstd}
Specify the {cmd:overlay} option so that the values are plotted on the same
graph; this will provide a better comparison between Tess, Sam, and Arnold.

	{cmd:. xtline calories, overlay}
	  {it:({stata "xtline_ex caloriesover":click to run})}
