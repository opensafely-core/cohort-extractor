{smcl}
{* *! version 1.1.8  19oct2017}{...}
{viewerdialog wntestq "dialog wntestq"}{...}
{vieweralsosee "[TS] wntestq" "mansection TS wntestq"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] corrgram" "help corrgram"}{...}
{vieweralsosee "[TS] cumsp" "help cumsp"}{...}
{vieweralsosee "[TS] pergram" "help pergram"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "[TS] wntestb" "help wntestb"}{...}
{viewerjumpto "Syntax" "wntestq##syntax"}{...}
{viewerjumpto "Menu" "wntestq##menu"}{...}
{viewerjumpto "Description" "wntestq##description"}{...}
{viewerjumpto "Links to PDF documentation" "wntestq##linkspdf"}{...}
{viewerjumpto "Option" "wntestq##option"}{...}
{viewerjumpto "Examples" "wntestq##examples"}{...}
{viewerjumpto "Stored results" "wntestq##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[TS] wntestq} {hline 2}}Portmanteau (Q) test for white noise{p_end}
{p2col:}({mansection TS wntestq:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}{cmd:wntestq} {varname} {ifin} [{cmd:,} {opt l:ags(#)}]

{p 4 6 2}You must {cmd:tsset} your data before using {cmd:wntestq}; see
{helpb tsset:[TS] tsset}.
Also the time series must be dense (nonmissing with no gaps in the time
variable) in the specified sample.{p_end}
{p 4 6 2}{it:varname} may contain time-series operators; see {help tsvarlist}.
{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Time series > Tests > Portmanteau white-noise test}


{marker description}{...}
{title:Description}

{pstd}
{cmd:wntestq} performs the portmanteau (or Q) test for white noise.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS wntestqQuickstart:Quick start}

        {mansection TS wntestqRemarksandexamples:Remarks and examples}

        {mansection TS wntestqMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{opt lags(#)} specifies the number of autocorrelations to calculate.  The
default is to use min{floor(n/2) - 2, 40}, where floor(n/2) is the greatest
integer less than or equal to n/2.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. drop _all}{p_end}
{phang2}{cmd:. set obs 100}{p_end}
{phang2}{cmd:. generate x1 = rnormal()}{p_end}
{phang2}{cmd:. generate time = _n}{p_end}
{phang2}{cmd:. tsset time}{p_end}

{pstd}Perform portmanteau (or Q) test for white noise on series
{cmd:x1}{p_end}
{phang2}{cmd:. wntestq x1}{p_end}

{pstd}Same as above, but calculate 50 autocorrelations{p_end}
{phang2}{cmd:. wntestq x1, lags(50)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:wntestq} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(stat)}}Q statistic{p_end}
{synopt:{cmd:r(df)}}degrees of freedom{p_end}
{synopt:{cmd:r(p)}}probability value{p_end}
{p2colreset}{...}
