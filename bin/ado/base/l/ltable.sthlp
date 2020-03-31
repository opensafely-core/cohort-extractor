{smcl}
{* *! version 1.2.17  19oct2017}{...}
{viewerdialog ltable "dialog ltable"}{...}
{vieweralsosee "[ST] ltable" "mansection ST ltable"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stcox" "help stcox"}{...}
{viewerjumpto "Syntax" "ltable##syntax"}{...}
{viewerjumpto "Menu" "ltable##menu"}{...}
{viewerjumpto "Description" "ltable##description"}{...}
{viewerjumpto "Links to PDF documentation" "ltable##linkspdf"}{...}
{viewerjumpto "Options" "ltable##options"}{...}
{viewerjumpto "Examples" "ltable##examples"}{...}
{viewerjumpto "Video example" "ltable##video"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[ST] ltable} {hline 2}}Life tables for survival data{p_end}
{p2col:}({mansection ST ltable:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:ltable} {it:timevar} [{it:deadvar}] {ifin}
[{it:{help ltable##weight:weight}}]
[{cmd:,} {it:options}]


{phang}
{it:timevar} specifies the time of failure or censoring.  If {it:deadvar} is
not specified, all values of {it:timevar} are interpreted as failure times.
Observations with {it:timevar} equal to missing are ignored.

{phang}
{it:deadvar} specifies how the time recorded in {it:timevar} is to be
interpreted.  Observations with {it:deadvar} equal to 0 are treated as
censored and all other nonmissing values indicate that {it:timevar} should be
interpreted as a failure time. Observations with {it:deadvar} equal to missing
are ignored.

{pmore}
{it:deadvar} does not specify the number of failures.  Specify frequency
weights for aggregated data recording the number of failures. 


{synoptset 29 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{opt nota:ble}}display graph only; suppress display of table{p_end}
{synopt :{opt g:raph}}present the table graphically, as well as in tabular form{p_end}
{synopt :{opth by:(varlist:groupvar)}}produce separate tables (or graphs) for each value of {it:groupvar}{p_end}
{synopt :{opt t:est}}report chi-squared measure of differences between groups (2 tests){p_end}
{synopt :{opt overlay}}overlay plots on the same graph{p_end}
{synopt :{opt su:rvival}}display survival table; the default{p_end}
{synopt :{opt f:ailure}}display cumulative failure table{p_end}
{synopt :{opt h:azard}}display hazard table{p_end}
{synopt :{opt ci}}graph confidence interval{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt noa:djust}}suppress actuarial adjustment to the number at risk{p_end}
{synopt :{opth tv:id(varname)}}subject ID variable to use with time-varying parameters{p_end}
{synopt :{cmdab:i:ntervals:(}{cmd:w}|{it:{help numlist}}{cmd:)}}time intervals in which data are to be aggregated for tables{p_end}
{synopt :{cmdab:sav:ing:(}{it:{help filename}}[{cmd:,} {cmd:replace}]{cmd:)}}save the life-table data to {it:filename}; use {opt replace} to overwrite existing {it:filename}{p_end}

{syntab:Plot}
{synopt :{opth ploto:pts(ltable##plot_options:plot_options)}}affect rendition of the plotted line and plotted points{p_end}
{synopt :{cmdab:plot:}{ul:{it:#}}{cmd:opts(}{it:{help ltable##plot_options:plot_options}}{cmd:)}}affect rendition of the {it:#}th plotted line and plotted points; available only with {opt overlay}{p_end}

{syntab:CI plot}
{synopt :{opth ciop:ts(rspike_options)}}affect rendition of the confidence intervals{p_end}
{synopt :{cmdab:ci:}{ul:{it:#}}{cmd:opts(}{it:{help rspike_options}}{cmd:)}}affect rendition of the {it:#}th confidence interval; available only with {opt overlay}{p_end}

{syntab:Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {cmd:by()} documented in
    {manhelpi twoway_options G-3}{p_end}
{synopt :{opth byop:ts(by_option:byopts)}}how subgraphs are combined, labeled,
etc.  {p_end}
{synoptline}
{p2colreset}{...}

{synoptset 29}{...}
{marker plot_options}{...}
{synopthdr:plot_options}
{synoptline}
{synopt:{it:connect_options}}change look of lines or connecting method{p_end}
{synopt:{it:marker_options}}change look of markers (color, size, etc.){p_end}
{synoptline}
{p2colreset}{...}

{marker weight}{...}
{pstd}{opt fweight}s are allowed; see {help weight}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survival analysis > Summary statistics, tests, and tables >}
       {bf:Life tables for survival data}


{marker description}{...}
{title:Description}

{pstd}
{cmd:ltable} displays and graphs life tables for individual-level or aggregate
data and optionally presents the likelihood-ratio and log-rank tests for
equivalence of groups.  {cmd:ltable} also allows you to examine the empirical
hazard function through aggregation.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ST ltableQuickstart:Quick start}

        {mansection ST ltableRemarksandexamples:Remarks and examples}

        {mansection ST ltableMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt notable} suppresses displaying the table.  This option is often used
with {opt graph}.

{phang}
{opt graph} requests that the table be presented graphically, as well as
in tabular form; when {opt notable} is also specified, only the graph is
presented.  When you specify {opt graph}, only one table can be
calculated and graphed at a time; see {opt survival}, {opt failure}, and
{opt hazard} below.

{pmore}
{opt graph} may not be specified with {opt hazard}.  Use {cmd:sts graph} to
graph estimates of the hazard function.

{phang}
{cmd:by(}{it:{help varlist:groupvar}}{cmd:)} creates separate tables (or
graphs within the same image) for each value of {it:groupvar}.  {it:groupvar}
may be string or numeric.

{phang}
{opt test} presents two chi-squared measures of the differences between
groups, the likelihood-ratio test of homogeneity and the log-rank test for
equality of survivor functions.  The two groups are identified by the 
{opt by()} option, so {opt by()} must also be specified.

{phang}
{opt overlay} causes the plot from each group identified in the {opt by()}
option to be overlaid on the same graph.  The default is to generate a
separate graph (within the same image) for each group.  This option requires
the {opt by()} option.

{phang}
{opt survival}, {opt failure}, and {opt hazard} indicate the table 
to be displayed.  If none is specified, the default is the survival 
table.  Specifying {opt failure} displays the cumulative failure table.
Specifying {opt survival failure} would display both the survival and the
cumulative failure table.  If {opt graph} is specified, multiple tables
may not be requested.

{phang}
{opt ci} graphs the confidence intervals around {opt survival},
{opt failure}, or {opt hazard}.

{phang}
{opt level(#)} specifies the confidence level, as a percentage,
for confidence intervals.  The default is {cmd:level(95)} or as set by 
{helpb set level}.

{marker noadjust}{...}
{phang}
{opt noadjust} suppresses the actuarial adjustment to the number at risk.
The default is to consider the adjusted number at risk for each
interval as the total at the start minus (the number of censored)/2.
If {opt noadjust} is specified, the number at risk is simply the
total at the start, corresponding to the standard Kaplan-Meier assumption.
{opt noadjust} should be specified when using {cmd:ltable} to list results
corresponding to those produced by {helpb sts list}.

{phang}
{opth tvid(varname)} is for use with longitudinal data with time-varying 
parameters.  Each subject appears in the data more than once, and equal values 
of {it:varname} identify observations referring to the same subject.  When 
{opt tvid()} is specified, only the last observation on each subject is used 
in making the table.  The order of the data does not matter, and {it:last} 
here means the last observation chronologically.

{phang}
{cmd:intervals(}{cmd:w}|{it:{help numlist}}{cmd:)} specifies the intervals into
which the data are to be aggregated for tabular presentation.  A numeric
argument is interpreted as the width of the interval.  For instance,
{cmd:interval(2)} aggregates data into the intervals 0<=t<2, 2<=t<4, and
so on.  Not specifying {opt interval()} is equivalent to specifying
{cmd:interval(1)}.  Because in most data, failure times are recorded as
integers, this amounts to no aggregation except that implied by the recording
of the time variable, and so it produces Kaplan-Meier product-limit estimates of
the survival curve (with an actuarial adjustment; see the {opt noadjust}
option {help ltable##noadjust:above}).  Also see
{manhelp sts_list ST:sts list}.  Although it is possible to examine survival
and failure without aggregation, some form of aggregation is almost always
required for examining the hazard.

{pmore}
When more than one argument is specified, intervals are aggregated
as specified.  For instance, {cmd:interval(0,2,8,16)} aggregates data into the
intervals [0,2), [2,8), [8,16), and (if necessary) [16, infinity).

{pmore}
{cmd:interval(w)} is equivalent to
{cmd:interval(0,7,15,30,60,90,180,360,540,720)}, corresponding to 1 week,
(roughly) 2 weeks, 1 month, 2 months, 3 months, 6 months, 1 year,
1.5 years, and 2 years when failure times are recorded in days.  The {opt w}
suggests widening intervals.

{phang}
{cmd:saving(}{it:{help filename}}[{cmd:,} {cmd:replace}]{cmd:)} creates a Stata
data file ({opt .dta} file) containing the life table.  This option will not
save the graph to disk; see {manhelp graph_save G-2:graph save} to save the
resulting graph to disk.

{pmore}
{cmd:replace} specifies that {it:filename} be overwritten if it exists.
This option is not shown in the dialog box.

{dlgtab:Plot}

{phang}
{opt plotopts(plot_options)} affects the rendition
of the plotted line and plotted points; see
{manhelpi connect_options G-3:connect_options} and
{manhelpi marker_options G-3:marker_options}.

{phang}
{cmd:plot}{it:#}{cmd:opts(}{it:plot_options}{cmd:)} affects
the rendition of the {it:#}th plotted line and plotted points; see
{manhelpi connect_options G-3:connect_options} and
{manhelpi marker_options G-3}.  This option is valid
only if {opt overlay} is specified.

{dlgtab:CI plot}

{phang}
{opt ciopts(rspike_options)} affects the rendition of the confidence 
intervals for the graphed survival, failure, or hazard; see
{manhelpi rspike_options G-3}.

{phang}
{cmd:ci}{it:#}{cmd:opts(}{it:rspike_options}{cmd:)} affects the rendition of
the {it:#}th confidence interval for the graphed survival, failure, or
hazard; see {manhelpi rspike_options G-3}.  This option is valid only if
{opt overlay} is specified.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the generated graph; 
see {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include options for 
titling the graph (see {manhelpi title_options G-3}) and for saving the 
graph to disk (see {manhelpi saving_option G-3}).

{phang}
{opt byopts(byopts)} affects the appearance of the combined graph when
{cmd:by()} is specified, including the overall graph title and the
organization of subgraphs.  See {manhelpi by_option G-3}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse rat}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list in 1/5}{p_end}
{phang2}{cmd:. list if died == 0}

{pstd}Display the life table for group 1{p_end}
{phang2}{cmd:. ltable t died if group == 1}

{pstd}Display the life table for group 1 aggregated into 30-day
intervals{p_end}
{phang2}{cmd:. ltable t died if group == 1, interval(30)}

{pstd}Display the life table for group 1 using the specified intervals{p_end}
{phang2}{cmd:. ltable t died if group == 1, interval(120,180,210,240,330)}

{pstd}Display separate life tables for each group and aggregate into 30-day
intervals{p_end}
{phang2}{cmd:. ltable t died, by(group) interval(30)}

{pstd}Display a failure table for group 1 aggregated into 30-day
intervals{p_end}
{phang2}{cmd:. ltable t died if group == 1, interval(30) failure}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse selvin}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list in 1/5}

{pstd}Obtain survival rates, and show both table and graph{p_end}
{phang2}{cmd:. ltable t died [freq=pop], graph}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse tumor}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list in 1/6, sep(0)}

{pstd}Display the hazard table{p_end}
{phang2}{cmd:. ltable t d [freq=pop], hazard interval(0(1)9)}{p_end}
    {hline}


{marker video}{...}
{title:Video example}

{phang}
{browse "https://www.youtube.com/watch?v=f5cb-Us-GyI&list=UUVk4G4nEtBS4tLOyHqustDA":How to construct life tables}
{p_end}
