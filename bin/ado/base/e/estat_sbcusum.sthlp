{smcl}
{* *! version 1.0.3  19oct2017}{...}
{viewerdialog estat "dialog estat"}{...}
{vieweralsosee "[TS] estat sbcusum" "mansection TS estatsbcusum"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] estat sbknown" "help estat sbknown"}{...}
{vieweralsosee "[TS] estat sbsingle" "help estat sbsingle"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{viewerjumpto "Syntax" "estat sbcusum##syntax"}{...}
{viewerjumpto "Menu for estat" "estat sbcusum##menu_estat"}{...}
{viewerjumpto "Description" "estat sbcusum##description"}{...}
{viewerjumpto "Links to PDF documentation" "estat_sbcusum##linkspdf"}{...}
{viewerjumpto "Options" "estat sbcusum##options"}{...}
{viewerjumpto "Examples" "estat sbcusum##examples"}{...}
{viewerjumpto "Stored results" "estat sbcusum##results"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[TS] estat sbcusum} {hline 2}}Cumulative sum test for parameter
stability{p_end}
{p2col:}({mansection TS estatsbcusum:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
        {cmd:estat sbcusum}
	[{cmd:,} {it:options}]

{synoptset 34 tabbed}{...}
{synopthdr}
{synoptline}
{synopt :{opt rec:ursive}}use cumulative sum of recursive residuals; the
default{p_end}
{synopt :{opt ols}}use cumulative sum of OLS residuals{p_end}
{synopt :{opth gen:erate(newvar)}}create {it:newvar} containing the cumulative
sum of the residuals{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}

{syntab:Plot}
{synopt :{opth recast:(graph twoway:plottype)}}plot cumulative sum statistic using {it:plottype}{p_end}
{synopt :{it:{help cline_options}}}affect rendition of the line plotting the
cumulative sum statistic{p_end}

{syntab:Confidence bands}
{synopt :{opth cbopts:(area_options:area_options)}}affect rendition of the
confidence bands{p_end}

{syntab :Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the graph of
the cumulative sum{p_end}

{syntab :Y axis, X axis, Titles, Legend, Overall, By}
{synopt :{it:twoway_options}}any options documented in 
      {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
You must {cmd:tsset} your data before using {cmd:estat sbcusum}; see
{helpb tsset:[TS] tsset}.


INCLUDE help menu_estat


{marker description}{...}
{title:Description}

{pstd}
{opt estat sbcusum} performs a test of whether the coefficients in a
time-series regression are stable over time.  The test statistic is constructed
from the cumulative sum of either the recursive residuals or the ordinary
least-squares (OLS) residuals.

{pstd}
{cmd:estat sbcusum} requires that the current estimation results be from
{helpb regress}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS estatsbcusumQuickstart:Quick start}

        {mansection TS estatsbcusumRemarksandexamples:Remarks and examples}

        {mansection TS estatsbcusumMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt recursive} 
    computes the cumulative sum (cusum) test statistic and draws a cusum plot
    using the recursive residuals.  This is the default.

{phang}
{opt ols} 
    computes the cusum test statistic and draws a cusum plot using the
    OLS residuals.

{phang}
{opth generate(newvar)} creates a new variable containing the cusum of
    the residuals at each time period.

{phang}
{opt level(#)} specifies the default confidence level, as a percentage,
    for confidence bands, when they are reported.  The default is
    {cmd:level(95)} or as set by {helpb set level}.

{dlgtab:Plot}

{phang}
{opt recast(plottype)}
     specifies that the cusum statistic be plotted using
     {it:plottype}.
     {it:plottype} may be {cmd:scatter}, {cmd:line}, {cmd:connected},
     {cmd:area}, {cmd:bar}, {cmd:spike}, or {cmd:dropline}; see
     {manhelp graph_twoway G-2:graph twoway}.

{phang}
{it:cline_options} 
    affect the rendition of the plotted cusum statistic.  {it:cline_options}
    are as described in {manhelpi cline_options G-3}.
    When {opt recast(plottype)} is specified, the plot options are
    whatever is appropriate for the specified {it:plottype}.

{dlgtab:Confidence bands}

{phang}
{opt cbopts(area_options)} 
    affects the rendition of the confidence bands for the cusum
    statistic.  {it:area_options} are as described in
    {manhelpi area_options G-3}.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} 
    allows adding more {opt graph twoway} plots to the graph; see
    {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} 
are any of the options documented in {manhelpi twoway_options G-3}, except
{cmd:by()}.  These include options for titling the graph (see
{manhelpi title_options G-3}) and options for saving the graph to disk (see
{manhelpi saving_option G-3}).


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse wpi1}{p_end}
{phang2}{cmd:. regress D.ln_wpi}{p_end}

{pstd}Test for the stability of the mean using the cusum of recursive
residuals{p_end}
{phang2}{cmd:. estat sbcusum}{p_end}

{pstd}Test for stability using the cusum of OLS residuals{p_end}
{phang2}{cmd:. estat sbcusum, ols}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat sbcusum} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(cusum)}}value of the test statistic{p_end}
{synopt:{cmd:r(level)}}confidence level of confidence intervals{p_end}
{synopt:{cmd:r(df)}}degrees of freedom{p_end}

{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(statistic)}}name of the statistic used; {cmd:recursive} or
{cmd:ols}{p_end}
{synopt:{cmd:r(tmins)}}formatted minimum time{p_end}
{synopt:{cmd:r(tmaxs)}}formatted maximum time{p_end}

{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(cvalues)}}vector of critical values{p_end}
{p2colreset}{...}
