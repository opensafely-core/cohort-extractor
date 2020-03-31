{smcl}
{* *! version 1.1.9  19oct2017}{...}
{viewerdialog pcorr "dialog pcorr"}{...}
{vieweralsosee "[R] pcorr" "mansection R pcorr"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] correlate" "help correlate"}{...}
{vieweralsosee "[R] spearman" "help spearman"}{...}
{viewerjumpto "Syntax" "pcorr##syntax"}{...}
{viewerjumpto "Menu" "pcorr##menu"}{...}
{viewerjumpto "Description" "pcorr##description"}{...}
{viewerjumpto "Links to PDF documentation" "pcorr##linkspdf"}{...}
{viewerjumpto "Examples" "pcorr##examples"}{...}
{viewerjumpto "Stored results" "pcorr##results"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[R] pcorr} {hline 2}}Partial and semipartial correlation coefficients{p_end}
{p2col:}({mansection R pcorr:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:pcorr} {it:{help varname}} {varlist} {ifin}
[{it:{help pcorr##weight:weight}}]

{phang}
{it:varlist} may contain factor variables; see {help fvvarlist}.{p_end}
{phang}
{it:varname} and {it:varlist} may contain time-series operators; see {help tsvarlist}.{p_end}
{phang}
{opt by} is allowed; see {manhelp by D}.{p_end}
{marker weight}{...}
{phang}
{opt aweight}s and {opt fweight}s are allowed; see {help weight}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Summaries, tables, and tests >}
     {bf:Summary and descriptive statistics > Partial correlations}


{marker description}{...}
{title:Description}

{pstd}
{cmd:pcorr} displays the partial and semipartial correlation coefficient of 
a specified variable with each variable in a varlist after removing
the effects of all other variables in the varlist. The squared correlations
and corresponding significance are also reported.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R pcorrQuickstart:Quick start}

        {mansection R pcorrRemarksandexamples:Remarks and examples}

        {mansection R pcorrMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Example}

{phang}{cmd:. sysuse auto}{p_end}
{phang}{cmd:. pcorr price mpg weight foreign}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:pcorr} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(df)}}degrees of freedom{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(p_corr)}}partial correlation coefficient vector{p_end}
{synopt:{cmd:r(sp_corr)}}semipartial correlation coefficient vector{p_end}
