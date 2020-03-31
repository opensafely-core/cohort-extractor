{smcl}
{* *! version 1.1.10  19oct2017}{...}
{viewerdialog xcorr "dialog xcorr"}{...}
{vieweralsosee "[TS] xcorr" "mansection TS xcorr"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] corrgram" "help corrgram"}{...}
{vieweralsosee "[TS] pergram" "help pergram"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{viewerjumpto "Syntax" "xcorr##syntax"}{...}
{viewerjumpto "Menu" "xcorr##menu"}{...}
{viewerjumpto "Description" "xcorr##description"}{...}
{viewerjumpto "Links to PDF documentation" "xcorr##linkspdf"}{...}
{viewerjumpto "Options" "xcorr##options"}{...}
{viewerjumpto "Examples" "xcorr##examples"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[TS] xcorr} {hline 2}}Cross-correlogram for bivariate time series{p_end}
{p2col:}({mansection TS xcorr:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 4 17 2}
{cmd:xcorr} {it:{help varname:varname1}} {it:{help varname:varname2}} {ifin}
[{cmd:,} {it:options}]

{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{opth gen:erate(newvar)}}create {it:newvar} containing
cross-correlation values{p_end}
{synopt :{opt tab:le}}display a table instead of graphical output{p_end}
{synopt :{opt noplot}}do not include the character-based plot in tabular
output{p_end}
{synopt :{opt lag:s(#)}}include {it:#} lags and leads in graph{p_end}

{syntab:Plot}
{p2col:{opt base(#)}}value to drop to; default is 0{p_end}
{p2col:{it:{help marker_options}}}change look of markers (color, 
	size, etc.){p_end}
{p2col:{it:{help marker_label_options}}}add marker labels; 
	change look or position{p_end}
{p2col:{it:{help line_options}}}change look of dropped lines{p_end}

{syntab:Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {opt by()} documented in
          {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}You must {cmd:tsset} your data before using {cmd:xcorr}; see
{helpb tsset:[TS] tsset}.{p_end}
{p 4 6 2}{it:varname1} and {it:varname2} may contain time-series operators;
see {help tsvarlist}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Time series > Graphs > Cross-correlogram for bivariate time series}


{marker description}{...}
{title:Description}

{pstd}
{cmd:xcorr} plots the sample cross-correlation function.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS xcorrQuickstart:Quick start}

        {mansection TS xcorrRemarksandexamples:Remarks and examples}

        {mansection TS xcorrMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth generate(newvar)} specifies a new variable to contain the
cross-correlation values.

{phang}
{opt table} requests that the results be presented as a table rather
than the default graph.

{phang}
{opt noplot} requests that the table not include the character-based
plot of the cross-correlations.

{phang}
{opt lags(#)} indicates the number of lags and leads to include in the graph.
The default is to use min{floor(n/2) - 2, 20}.

{dlgtab:Plot}

{phang}
{opt base(#)} specifies the value from which the lines should extend.
The default is {cmd:base(0)}.

{phang}
{it:marker_options}, {it:marker_label_options}, and {it:line_options} affect
the rendition of the plotted cross-correlations.

{phang2}
{it:marker_options}
    specify the look of markers.  This
    look includes the marker symbol, the marker size, and its color and outline;
    see {manhelpi marker_options G-3}.

{phang2}
{it:marker_label_options}
    specify if and how the markers are to be labeled; 
    see {manhelpi marker_label_options G-3}.

{phang2}
{it:line_options} 
    specify the look of the dropped lines, including pattern, width, and
    color; see {manhelpi line_options G-3}.

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


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse furnace}

{pstd}Plot the cross-correlation function{p_end}
{phang2}{cmd:. xcorr input output}

{pstd}Same as above, but draw vertical line at 5{p_end}
{phang2}{cmd:. xcorr input output, xline(5)}

{pstd}Same as above, but include 30 lags and leads in the graph{p_end}
{phang2}{cmd:. xcorr input output, xline(5) lags(30)}

{pstd}Obtain table of autocorrelations and character-based plot of
cross-correlations{p_end}
{phang2}{cmd:. xcorr input output, table}{p_end}
