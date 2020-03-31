{smcl}
{* *! version 1.1.10  19oct2017}{...}
{viewerdialog pergram "dialog pergram"}{...}
{vieweralsosee "[TS] pergram" "mansection TS pergram"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] corrgram" "help corrgram"}{...}
{vieweralsosee "[TS] cumsp" "help cumsp"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "[TS] wntestb" "help wntestb"}{...}
{viewerjumpto "Syntax" "pergram##syntax"}{...}
{viewerjumpto "Menu" "pergram##menu"}{...}
{viewerjumpto "Description" "pergram##description"}{...}
{viewerjumpto "Links to PDF documentation" "pergram##linkspdf"}{...}
{viewerjumpto "Options" "pergram##options"}{...}
{viewerjumpto "Examples" "pergram##examples"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[TS] pergram} {hline 2}}Periodogram {p_end}
{p2col:}({mansection TS pergram:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:pergram}
{varname}
{ifin}
[{cmd:,}
{it:options}]

{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opth gen:erate(newvar)}}generate {it:newvar} to contain the raw
periodogram values{p_end}

{syntab:Plot}
{synopt:{it:{help cline_options}}}affect rendition of the plotted points
connected by lines{p_end}
INCLUDE help gr_markopt

{syntab:Add plots}
{synopt:{opth "addplot(addplot_option:plot)"}}add other plots to the generated
graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt:{it:twoway_options}}any options other than {opt by()} documented in
    {manhelpi twoway_options G-3}{p_end}
{synopt :{opt nograph}}suppress the graph{p_end}
{synoptline}
{p 4 6 2}
You must {cmd:tsset} your data before using {opt pergram}; see
{helpb tsset:[TS] tsset}.
Also, the time series must be dense (nonmissing with no gaps in the time
variable) in the specified sample.
{p_end}
{p 4 6 2}
{it:varname} may contain time-series operators; see {help tsvarlist}.
{p_end}
{p 4 6 2}{opt nograph} does not appear in the dialog box.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Time series > Graphs > Periodogram}


{marker description}{...}
{title:Description}

{pstd}
{opt pergram} plots the log-standardized periodogram for a dense time series.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS pergramQuickstart:Quick start}

        {mansection TS pergramRemarksandexamples:Remarks and examples}

        {mansection TS pergramMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth generate(newvar)} specifies a new variable to
contain the raw periodogram values.  The generated graph
log-transforms and scales the values by the sample variance and then truncates
them to the [-6,6] interval before graphing them.

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
{opt addplot(plot)} adds specified plots to the generated
graph; see {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include options for
titling the graph (see {manhelpi title_options G-3}) and saving the graph to
disk (see {manhelpi saving_option G-3}).

{pstd}
The following option is available with {opt pergram} but is not shown in the
dialog box:

{phang}
{opt nograph} prevents {opt pergram} from constructing a graph.


{marker examples}{...}
{title:Examples}

    {hline}
{phang}{cmd:. webuse air2}{p_end}
{phang}{cmd:. pergram air}{p_end}
    {hline}
{phang}{cmd:. webuse lynx2}{p_end}
{phang}{cmd:. pergram lynx}{p_end}
    {hline}
{phang}{cmd:. webuse cos4}{p_end}
{phang}{cmd:. pergram sumfc, generate(ordinate)}{p_end}
    {hline}
