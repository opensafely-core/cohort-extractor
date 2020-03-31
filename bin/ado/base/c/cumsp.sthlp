{smcl}
{* *! version 1.1.8  17apr2018}{...}
{viewerdialog cumsp "dialog cumsp"}{...}
{vieweralsosee "[TS] cumsp" "mansection TS cumsp"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] corrgram" "help corrgram"}{...}
{vieweralsosee "[TS] pergram" "help pergram"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{viewerjumpto "Syntax" "cumsp##syntax"}{...}
{viewerjumpto "Menu" "cumsp##menu"}{...}
{viewerjumpto "Description" "cumsp##description"}{...}
{viewerjumpto "Links to PDF documentation" "cumsp##linkspdf"}{...}
{viewerjumpto "Options" "cumsp##options"}{...}
{viewerjumpto "Example" "cumsp##example"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[TS] cumsp} {hline 2}}Graph cumulative spectral distribution{p_end}
{p2col:}({mansection TS cumsp:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:cumsp}
{varname}
{ifin}
[{cmd:,} {it:options}]

{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opth gen:erate(newvar)}}create {it:newvar} holding distribution
values {p_end}

{syntab:Plot}
{synopt:{it:{help cline_options}}}affect rendition of the plotted points
connected by lines {p_end}
INCLUDE help gr_markopt

{syntab:Add plots}
{synopt:{opth "addplot(addplot_option:plot)"}}add other plots to the
generated graph {p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt:{it:twoway_options}}any options other than {opt by()}
documented in {manhelpi twoway_options G-3} {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
You must {opt tsset} your data before using {opt cumsp}; see {manhelp tsset TS}.
Also, the time series must be dense (nonmissing and no gaps in the time
variable) in the sample specified.
{p_end}
{p 4 6 2}
{it:varname} may contain time-series operators; see {help tsvarlist}.
{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Time series > Graphs > Cumulative spectral distribution}


{marker description}{...}
{title:Description}

{pstd}
{opt cumsp} plots the cumulative sample spectral-distribution function
evaluated at the natural frequencies for a (dense) time series.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS cumspQuickstart:Quick start}

        {mansection TS cumspRemarksandexamples:Remarks and examples}

        {mansection TS cumspMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth generate(newvar)} specifies a new variable to
contain the estimated cumulative spectral-distribution values.

{dlgtab:Plot}

{phang}
{it:cline_options} affect the rendition of the plotted points connected
by lines; see {manhelpi cline_options G-3}.

{phang}
{it:marker_options}
    specify the look of markers.  This
    look includes the marker symbol, the marker size, and its color and outline;
    see {manhelpi marker_options G-3}.

{phang}
{it:marker_label_options}
    specify if and how the markers are to be labeled; 
    see {manhelpi marker_label_options G-3}.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the
generated graph; see {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include options for
titling the graph (see {manhelpi title_options G-3}) and saving the graph to
disk (see {manhelpi saving_option G-3}).


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse air2}

{pstd}Plot cumulative sample spectral distribution function with vertical line
at frequency 1/12{p_end}
{phang2}{cmd:. cumsp air, xline(.083333333)}{p_end}
