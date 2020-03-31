{smcl}
{* *! version 1.2.16  19oct2017}{...}
{viewerdialog corrgram "dialog corrgram"}{...}
{viewerdialog ac "dialog ac"}{...}
{viewerdialog pac "dialog pac"}{...}
{vieweralsosee "[TS] corrgram" "mansection TS corrgram"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] pergram" "help pergram"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "[TS] wntestq" "help wntestq"}{...}
{viewerjumpto "Syntax" "corrgram##syntax"}{...}
{viewerjumpto "Menu" "corrgram##menu"}{...}
{viewerjumpto "Description" "corrgram##description"}{...}
{viewerjumpto "Links to PDF documentation" "corrgram##linkspdf"}{...}
{viewerjumpto "Options for corrgram" "corrgram##options_corrgram"}{...}
{viewerjumpto "Options for ac and pac" "corrgram##options_ac"}{...}
{viewerjumpto "Examples" "corrgram##examples"}{...}
{viewerjumpto "Video example" "corrgram##video"}{...}
{viewerjumpto "Stored results" "corrgram##results"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[TS] corrgram} {hline 2}}Tabulate and graph autocorrelations{p_end}
{p2col:}({mansection TS corrgram:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}Autocorrelations, partial autocorrelations, and portmanteau (Q) statistics

{p 8 25 2}
{cmd:corrgram}
{varname}
{ifin}
[{cmd:,} {it:{help corrgram##corrgram_options:corrgram_options}}]


{phang}Graph autocorrelations with confidence intervals

{p 8 25 2}
{cmd:ac}
{varname}
{ifin} 
[{cmd:,} {it:{help corrgram##ac_options:ac_options}}]


{phang}Graph partial autocorrelations with confidence intervals

{p 8 25 2}
{cmd:pac}
{varname}
{ifin}
[{cmd:,} {it:{help corrgram##pac_options:pac_options}}]


{marker corrgram_options}{...}
{synoptset 25 tabbed}{...}
{synopthdr:corrgram_options}
{synoptline}
{syntab:Main}
{synopt:{opt l:ags(#)}}calculate {it:#} autocorrelations{p_end}
{synopt:{opt nopl:ot}}suppress character-based plots{p_end}
{synopt:{opt yw}}calculate partial autocorrelations by using Yule-Walker equations{p_end}
{synoptline}

{marker ac_options}{...}
{synopthdr:ac_options}
{synoptline}
{syntab:Main}
{synopt:{opt lag:s(#)}}calculate {it:#} autocorrelations{p_end}
{synopt:{opth gen:erate(newvar)}}generate a variable to hold the
autocorrelations{p_end}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt:{opt fft}}calculate autocorrelation by using Fourier transforms{p_end}

{syntab:Plot}
{p2col:{it:{help line_options}}}change look of dropped lines{p_end}
INCLUDE help gr_markopt

{syntab:CI plot}
{synopt:{opth ciop:ts(area_options)}}affect rendition of the
	confidence bands{p_end}

{syntab:Add plots}
{synopt:{opth "addplot(addplot_option:plot)"}}add other plots to the generated
graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt:{it:twoway_options}}any options other than {opt by()} documented in
    {manhelpi twoway_options G-3}
{p_end}
{synoptline}

{marker pac_options}{...}
{synopthdr:pac_options}
{synoptline}
{syntab:Main}
{synopt:{opt lag:s(#)}}calculate {it:#} partial autocorrelations{p_end}
{synopt:{opth gen:erate(newvar)}}generate a variable to hold the
partial autocorrelations{p_end}
{synopt:{opt yw}}calculate partial autocorrelations by using Yule-Walker equations{p_end}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}

{syntab:Plot}
{p2col:{it:{help line_options}}}change look of dropped lines{p_end}
INCLUDE help gr_markopt

{syntab:CI plot}
{synopt:{opth ciop:ts(area_options)}}affect rendition of the
	confidence bands{p_end}

{syntab:SRV plot}
{synopt:{opt srv}}include standardized residual variances in graph{p_end}
{synopt:{opth srvop:ts(marker_options)}}affect rendition of 
	the plotted standardized residual variances (SRVs){p_end}

{syntab:Add plots}
{synopt:{opth "addplot(addplot_option:plot)"}}add other plots to the generated
graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt:{it:twoway_options}}any options other than {opt by()} documented in
           {manhelpi twoway_options G-3}{p_end}
{synoptline}

{p 4 6 2}
You must {opt tsset} your data before using {opt corrgram}, {opt ac}, or
{opt pac}; see {manhelp tsset TS}.  Also, the time series must be dense
(nonmissing and no gaps in the time variable) in the sample if you specify the
{opt fft} option.
{p_end}
{p 4 6 2}
{it:varname} may contain time-series operators; see {help tsvarlist}.


{marker menu}{...}
{title:Menu}

    {title:corrgram}

{phang2}
{bf:Statistics > Time series > Graphs > Autocorrelations & partial autocorrelations}

    {title:ac}

{phang2}
{bf:Statistics > Time series > Graphs > Correlogram (ac)}

    {title:pac}

{phang2}
{bf:Statistics > Time series > Graphs > Partial correlogram (pac)}


{marker description}{...}
{title:Description}

{pstd}
{opt corrgram} produces a table of the autocorrelations, partial
autocorrelations, and portmanteau (Q) statistics.  It also displays a
character-based plot of the autocorrelations and partial autocorrelations. 
See {manhelp wntestq TS} for more information on the Q statistic.

{pstd}
{opt ac} produces a correlogram (a graph of autocorrelations) with pointwise
confidence intervals that is based on Bartlett's formula for MA(q) processes.

{pstd}
{opt pac} produces a partial correlogram (a graph of partial autocorrelations)
with confidence intervals calculated using a standard error of 1/sqrt(n).  The
residual variances for each lag may optionally be included on the graph.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS corrgramQuickstart:Quick start}

        {mansection TS corrgramRemarksandexamples:Remarks and examples}

        {mansection TS corrgramMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_corrgram}{...}
{title:Options for corrgram}

{dlgtab:Main}

{phang}
{opt lags(#)} specifies the number of autocorrelations to calculate.  The
default is to use min{floor(n/2) - 2, 40}, where floor(n/2) is the greatest
integer less than or equal to n/2.

{phang}
{opt noplot} prevents the character-based plots from being in the listed table
   of autocorrelations and partial autocorrelations.

{phang}
{opt yw} specifies that the partial autocorrelations be calculated using the
   Yule-Walker equations instead of using the default regression-based
   technique.  {opt yw} cannot be used if {opt srv} is used.


{marker options_ac}{...}
{title:Options for ac and pac}

{dlgtab:Main}

{phang}
{opt lags(#)} specifies the number of autocorrelations to calculate.  The
default is to use min{floor(n/2) - 2, 40}, where floor(n/2) is the greatest
integer less than or equal to n/2.

{phang}
{opth generate(newvar)} specifies a new variable to contain the
   autocorrelation ({opt ac} command) or partial autocorrelation ({opt pac}
   command) values.  This option is required if the {opt nograph} option is
   used.

{pmore}
   {opt nograph} (implied when using {opt generate()} in the dialog box)
   prevents {opt ac} and {opt pac} from constructing a graph.  This option
   requires the {opt generate()} option.

{phang}
{opt yw} ({cmd:pac} only) specifies that the partial autocorrelations be
   calculated using the Yule-Walker equations instead of using the default
   regression-based technique.  {opt yw} cannot be used if {opt srv} is used.

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for the
   confidence bands in the {opt ac} or {opt pac} graph.  The default is
   {cmd:level(95)} or as set by {helpb set level}.

{phang}
{opt fft} ({opt ac} only) specifies that the autocorrelations be calculated
   using two Fourier transforms.  This technique can be faster than simply
   iterating over the requested number of lags.

{dlgtab:Plot}

{phang}
{it:line_options}, {it:marker_options}, and {it:marker_label_options} affect
the rendition of the plotted autocorrelations (with {cmd:ac}) or partial
autocorrelations (with {cmd:pac}).

{phang2}
{it:line_options} 
    specify the look of the dropped lines, including pattern, width, and
    color; see {manhelpi line_options G-3}.

{phang2}
{it:marker_options}
    specify the look of markers.  This
    look includes the marker symbol, the marker size, and its color and outline;
    see {manhelpi marker_options G-3}.

{phang2}
{it:marker_label_options}
    specify if and how the markers are to be labeled; 
    see {manhelpi marker_label_options G-3}.

{dlgtab:CI plot}

{phang}
{opt ciopts(area_options)} affects the rendition of the confidence
bands; see {manhelpi area_options G-3}.

{dlgtab:SRV plot}

{phang}
{opt srv} ({opt pac} only) specifies that the standardized residual variances
   be plotted with the partial autocorrelations.  {opt srv} cannot be used if
   {opt yw} is used.

{phang}
{opt srvopts(marker_options)} ({cmd:pac} only) affects the rendition of the
plotted standardized residual variances; see {manhelpi marker_options G-3}.
This option implies the {opt srv} option.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} adds specified plots to the generated
   graph; see {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in
   {manhelpi twoway_options G-3}, excluding {opt by()}.  These include options
   for titling the graph (see {manhelp title_options G-3}) and saving the graph
   to disk (see {manhelpi saving_option G-3}).


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse air2}

{pstd}List autocorrelations, partial autocorrelations, and Q statistics{p_end}
{phang2}{cmd:. corrgram air, lags(20)}

{pstd}Graph the autocorrelations{p_end}
{phang2}{cmd:. ac air}

{pstd}Graph the partial autocorrelations of differenced and seasonally
differenced series{p_end}
{phang2}{cmd:. pac DS12.air, lags(20) srv}


{marker video}{...}
{title:Video example}

{phang2}{browse "http://www.youtube.com/watch?v=uHqiTjiuL7o":Correlograms and partial correlograms}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:corrgram} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(lags)}}number of lags{p_end}
{synopt:{cmd:r(ac}{it:#}{cmd:)}}AC for lag {it:#}{p_end}
{synopt:{cmd:r(pac}{it:#}{cmd:)}}PAC for lag {it:#}{p_end}
{synopt:{cmd:r(q}{it:#}{cmd:)}}Q for lag {it:#}{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(AC)}}vector of autocorrelations{p_end}
{synopt:{cmd:r(PAC)}}vector of partial autocorrelations{p_end}
{synopt:{cmd:r(Q)}}vector of Q statistics{p_end}
{p2colreset}{...}
