{smcl}
{* *! version 1.1.10  19oct2017}{...}
{viewerdialog wntestb "dialog wntestb"}{...}
{vieweralsosee "[TS] wntestb" "mansection TS wntestb"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] corrgram" "help corrgram"}{...}
{vieweralsosee "[TS] cumsp" "help cumsp"}{...}
{vieweralsosee "[TS] pergram" "help pergram"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "[TS] wntestq" "help wntestq"}{...}
{viewerjumpto "Syntax" "wntestb##syntax"}{...}
{viewerjumpto "Menu" "wntestb##menu"}{...}
{viewerjumpto "Description" "wntestb##description"}{...}
{viewerjumpto "Links to PDF documentation" "wntestb##linkspdf"}{...}
{viewerjumpto "Options" "wntestb##options"}{...}
{viewerjumpto "Examples" "wntestb##examples"}{...}
{viewerjumpto "Stored results" "wntestb##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[TS] wntestb} {hline 2}}Bartlett's periodogram-based test for white
noise{p_end}
{p2col:}({mansection TS wntestb:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}{cmd:wntestb} {varname} {ifin} 
[{cmd:,} {it:options}]

{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{opt ta:ble}}display a table instead of graphical output{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is
  {cmd:level(95)}{p_end}

{syntab:Plot}
{synopt :{it:{help marker_options}}}change look of markers (color, 
	size, etc.){p_end}
{synopt :{it:{help marker_label_options}}}add marker labels; 
	change look or position{p_end}
{synopt :{it:{help cline_options}}}add connecting lines; change look{p_end}

{syntab:Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {cmd:by()} documented in
      {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2} You must {cmd:tsset} your data before using {cmd:wntestb}; see
{helpb tsset:[TS] tsset}.  In addition, the time series must be dense
(nonmissing with no gaps in the time variable) in the specified sample.{p_end}
{p 4 6 2}{it:varname} may contain time-series operators; see {help tsvarlist}.
{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Time series > Tests > Bartlett's periodogram-based white-noise test}


{marker description}{...}
{title:Description}

{pstd}
{cmd:wntestb} performs Bartlett's periodogram-based test for white noise.
The result is presented graphically by default but optionally may be 
presented as text in a table.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS wntestbQuickstart:Quick start}

        {mansection TS wntestbRemarksandexamples:Remarks and examples}

        {mansection TS wntestbMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt table} displays the test results as a table instead of as the
default graph.

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for the
confidence bands included on the graph.  The default is {cmd:level(95)} or as
set by {helpb set level}.

{dlgtab:Plot}

{phang}
{it:marker_options}
    specify the look of markers.  This
    look includes the marker symbol, the marker size, and its color and
    outline; see {manhelpi marker_options G-3}.

{phang}
{it:marker_label_options}
    specify if and how the markers are to be labeled; 
    see {manhelpi marker_label_options G-3}.

{phang}
{it:cline_options} 
    specify if the points are to be connected with lines and the rendition of
    those lines; see {manhelpi line_options G-3}.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} adds specified plots to the generated graph; see 
{manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include options for
titling the graph (see {manhelpi title_options G-3}) and saving the graph to
disk (see {manhelpi saving_option G-3}).


{marker examples}{...}
{title:Examples}
 
{pstd}Setup{p_end}
{phang2}{cmd:. drop _all}{p_end}
{phang2}{cmd:. set obs 100}{p_end}
{phang2}{cmd:. generate x1 = rnormal()}{p_end}
{phang2}{cmd:. generate time = _n}{p_end}
{phang2}{cmd:. tsset time}{p_end}

{pstd}Perform Bartlett's periodogram-based test for white noise on series
{cmd:x1}{p_end}
{phang2}{cmd:. wntestb x1}{p_end}

{pstd}Same as above, but present results as a table instead of a graph{p_end}
{phang2}{cmd:. wntestb x1, table}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:wntestb} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(stat)}}Bartlett's statistic{p_end}
{synopt:{cmd:r(p)}}probability value{p_end}
{p2colreset}{...}
