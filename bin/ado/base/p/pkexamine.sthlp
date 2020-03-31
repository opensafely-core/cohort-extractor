{smcl}
{* *! version 1.1.10  11may2019}{...}
{viewerdialog pkexamine "dialog pkexamine"}{...}
{vieweralsosee "[R] pkexamine" "mansection R pkexamine"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] pk" "help pk"}{...}
{viewerjumpto "Syntax" "pkexamine##syntax"}{...}
{viewerjumpto "Menu" "pkexamine##menu"}{...}
{viewerjumpto "Description" "pkexamine##description"}{...}
{viewerjumpto "Links to PDF documentation" "pkexamine##linkspdf"}{...}
{viewerjumpto "Options" "pkexamine##options"}{...}
{viewerjumpto "Examples" "pkexamine##examples"}{...}
{viewerjumpto "Stored results" "pkexamine##results"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[R] pkexamine} {hline 2}}Calculate pharmacokinetic measures{p_end}
{p2col:}({mansection R pkexamine:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 18 2}
{cmd:pkexamine} {it:time concentration} {ifin} [{cmd:,} {it:options}]

{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{synopt :{opt fit(#)}}use {it:#} points to estimate AUC_0,inf; default is
{cmd:fit(3)}{p_end}
{synopt :{opt t:rapezoid}}use trapezoidal rule; default is cubic splines{p_end}
{synopt :{opt g:raph}}graph the AUC{p_end}
{synopt :{opt line}}graph the linear extension{p_end}
{synopt :{opt log}}graph the log extension{p_end}
{synopt :{opt exp(#)}}plot the exponential fit for the AUC_0,inf{p_end}

{syntab :AUC plot}
{synopt :{it:{help cline_options}}}affect rendition of plotted points connected by lines{p_end}
INCLUDE help gr_markopt

{syntab :Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated graph{p_end}

{syntab :Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {opt by()} documented in
      {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt by} is allowed; see {manhelp by D}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Epidemiology and related > Other > Pharmacokinetic measures}


{marker description}{...}
{title:Description}

{pstd}
{cmd:pkexamine} calculates pharmacokinetic measures from
concentration-and-time subject-level data.  {cmd:pkexamine} computes and
displays the maximum measured concentration, the time at the maximum measured
concentration, the time of the last measurement, the elimination time, the
half-life, and the area under the concentration-time curve (AUC_0,tmax).
Three estimates of the AUC from 0 to infinity (AUC_0,inf) are also calculated.

{pstd}
{cmd:pkexamine} is one of the pk commands.  Please read {helpb pk} before
reading this entry.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R pkexamineQuickstart:Quick start}

        {mansection R pkexamineRemarksandexamples:Remarks and examples}

        {mansection R pkexamineMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt fit(#)} specifies the number of points, counting back from the last
measurement, to use in fitting the extension to estimate the AUC_0,inf.  The
default is {cmd:fit(3)}, or the last three points.  This should be viewed as a
minimum; the appropriate number of points will depend on your data.

{phang}
{opt trapezoid} specifies that the trapezoidal rule be used to calculate the
AUC_0,tmax.  The default is cubic splines, which give better results for most
functions.  When the curve is irregular, {opt trapezoid} may give better
results.

{phang}
{opt graph} tells {cmd:pkexamine} to graph the concentration-time curve.

{phang}
{opt line} and {opt log} specify the estimates of the AUC_0,inf to display
when graphing the AUC_0,inf.  If the {opt graph} option is not also specified,
then these options are ignored.

{phang}
{opt exp(#)} specifies that the exponential fit for the AUC_0,inf be plotted.
You must specify the maximum time value to which you want to plot the curve,
and this time value must be greater than the maximum time measurement in the
data.  If you specify 0, the curve will be plotted to the point at which the
linear extension would cross the {it:x} axis.  If the {opt graph} option is
not also specified, then this option is ignored.  This option is not valid
with the {opt line} or {opt log} option.

{dlgtab:AUC plot}

{phang}
{it:cline_options} affect the rendition of the plotted points connected
by lines; see {manhelpi cline_options G-3}.

{phang}
{it:marker_options} specify the look of markers.  This look includes the
marker symbol, size, color, and outline; see {manhelpi marker_options G-3}.

{phang}
{it:marker_label_options} specify if and how the markers are to be labeled;
see {manhelpi marker_label_options G-3}.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the generated
graph; see {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include options for
titling the graph (see {manhelpi title_options G-3}) and for saving the
graph to disk (see {manhelpi saving_option G-3}).


{marker examples}{...}
{title:Examples}

{phang}{cmd:. webuse auc}{space 32}(setup){p_end}
{p 4 50 2}{cmd:. pkexamine time concentration} {space 12} (show measures){p_end}
{p 4 50 2}{cmd:. pkexamine time concentration, fit(7)} {space 4} (use last 7 points to fit model){p_end}
{p 4 50 2}{cmd:. pkexamine time concentration, trapezoid} {space 1} (use trapezoidal rule in calculating AUC){p_end}
{p 4 50 2}{cmd:. pkexamine time concentration, graph} {space 5} (graph the AUC)


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:pkexamine} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(auc)}}AUC{p_end}
{synopt:{cmd:r(half)}}half-life of the drug{p_end}
{synopt:{cmd:r(ke)}}elimination rate{p_end}
{synopt:{cmd:r(tmax)}}time at last concentration measurement{p_end}
{synopt:{cmd:r(cmax)}}maximum concentration{p_end}
{synopt:{cmd:r(tomc)}}time of maximum concentration{p_end}
{synopt:{cmd:r(auc_line)}}AUC_0,inf estimated with a linear fit{p_end}
{synopt:{cmd:r(auc_exp)}}AUC_0,inf estimated with an exponential fit{p_end}
{synopt:{cmd:r(auc_ln)}}AUC_0,inf estimated with a linear fit of the
natural log{p_end}
{p2colreset}{...}
