{smcl}
{* *! version 1.1.7  19oct2017}{...}
{viewerdialog inspect "dialog inspect"}{...}
{vieweralsosee "[D] inspect" "mansection D inspect"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] codebook" "help codebook"}{...}
{vieweralsosee "[D] compare" "help compare"}{...}
{vieweralsosee "[D] describe" "help describe"}{...}
{vieweralsosee "[D] ds" "help ds"}{...}
{vieweralsosee "[D] isid" "help isid"}{...}
{vieweralsosee "[R] lv" "help lv"}{...}
{vieweralsosee "[R] summarize" "help summarize"}{...}
{vieweralsosee "[R] table" "help table"}{...}
{vieweralsosee "[R] tabulate oneway" "help tabulate_oneway"}{...}
{vieweralsosee "[R] tabulate twoway" "help tabulate_twoway"}{...}
{vieweralsosee "[R] tabulate, summarize()" "help tabulate_summarize"}{...}
{viewerjumpto "Syntax" "inspect##syntax"}{...}
{viewerjumpto "Menu" "inspect##menu"}{...}
{viewerjumpto "Description" "inspect##description"}{...}
{viewerjumpto "Links to PDF documentation" "inspect##linkspdf"}{...}
{viewerjumpto "Examples" "inspect##examples"}{...}
{viewerjumpto "Stored results" "inspect##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[D] inspect} {hline 2}}Display simple summary of data's
attributes{p_end}
{p2col:}({mansection D inspect:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{opt ins:pect}
[{varlist}]
{ifin}

{p 4 6 2}
{opt by} is allowed; see {manhelp by D}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Describe data > Inspect variables}


{marker description}{...}
{title:Description}

{pstd}
The {opt inspect} command provides a quick summary of a numeric variable that
differs from the summary provided by {cmd:summarize} or {cmd:tabulate}.  It
reports the number of negative, zero, and positive values; the number of
integers and nonintegers; the number of unique values; and the number of
missing; and it produces a small histogram.  Its purpose is not analytical but
is to allow you to quickly gain familiarity with unknown data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D inspectQuickstart:Quick start}

        {mansection D inspectRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. sysuse auto}

{pstd}Display simple summary of {cmd:mpg}{p_end}
{phang2}{cmd:. inspect mpg}

    {hline}
    Setup
{phang2}{cmd:. sysuse census}

{pstd}Display simple summary of {cmd:region}, a variable with a value
label{p_end}
{phang2}{cmd:. inspect region}

    {hline}
    Setup
{phang2}{cmd:. sysuse citytemp}

{pstd}Display simple summary of {cmd:tempjan}, a variable with missing values
{p_end}
{phang2}{cmd:. inspect tempjan}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:inspect} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(N_neg)}}number of negative observations{p_end}
{synopt:{cmd:r(N_0)}}number of observations equal to 0{p_end}
{synopt:{cmd:r(N_pos)}}number of positive observations{p_end}
{synopt:{cmd:r(N_negint)}}number of negative integer observations{p_end}
{synopt:{cmd:r(N_posint)}}number of positive integer observations{p_end}
{synopt:{cmd:r(N_unique)}}number of unique values or . if more than 99{p_end}
{synopt:{cmd:r(N_undoc)}}number of undocumented values or . if not labeled{p_end}
{p2colreset}{...}
