{smcl}
{* *! version 1.1.12  19oct2017}{...}
{viewerdialog "tabulate, summarize()" "dialog tabsum"}{...}
{vieweralsosee "[R] tabulate, summarize()" "mansection R tabulate,summarize()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] collapse" "help collapse"}{...}
{vieweralsosee "[SVY] svy: tabulate oneway" "help svy_tabulate_oneway"}{...}
{vieweralsosee "[SVY] svy: tabulate twoway" "help svy_tabulate_twoway"}{...}
{vieweralsosee "[R] table" "help table"}{...}
{vieweralsosee "[R] tabstat" "help tabstat"}{...}
{vieweralsosee "[R] tabulate oneway" "help tabulate_oneway"}{...}
{vieweralsosee "[R] tabulate twoway" "help tabulate_twoway"}{...}
{viewerjumpto "Syntax" "tabulate_summarize##syntax"}{...}
{viewerjumpto "Menu" "tabulate_summarize##menu"}{...}
{viewerjumpto "Description" "tabulate_summarize##description"}{...}
{viewerjumpto "Links to PDF documentation" "tabulate_summarize##linkspdf"}{...}
{viewerjumpto "Options" "tabulate_summarize##options"}{...}
{viewerjumpto "Examples" "tabulate_summarize##examples"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[R] tabulate, summarize()} {hline 2}}One- and two-way tables of summary
statistics{p_end}
{p2col:}({mansection R tabulate,summarize():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:ta:bulate}
{it:{help varname:varname1}}
[{it:{help varname:varname2}}]
{ifin}
[{it:{help tabulate summarize##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 23 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opth su:mmarize(varname:varname3)}}report summary statistics
for {it:varname3}
{p_end}
{synopt:[{cmdab:no:}]{opt me:ans}}include or suppress means
{p_end}
{synopt:[{cmdab:no:}]{opt st:andard}}include or suppress standard deviations
{p_end}
{synopt:[{cmdab:no:}]{opt f:req}}include or suppress frequencies
{p_end}
{synopt:[{cmdab:no:}]{opt o:bs}}include or suppress number of observations
{p_end}
{synopt:{opt nol:abel}}show numeric codes, not labels
{p_end}
{synopt:{opt w:rap}}do not break wide tables
{p_end}
{synopt:{opt mi:ssing}}treat missing values of {it:{help varname:varname1}} and
{it:{help varname:varname2}} as categories
{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt by} is allowed; see {manhelp by D}.
{p_end}
{marker weight}{...}
{p 4 6 2}
{opt aweight}s and {opt fweight}s are allowed; see {help weight}.
{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Summaries, tables, and tests > Other tables >}
     {bf:Table of means, std. dev., and frequencies}


{marker description}{...}
{title:Description}

{pstd}
{cmd:tabulate, summarize()} produces one- and two-way tables (breakdowns)
of means and standard deviations.  See
{manhelp tabulate_oneway R:tabulate oneway}  and
{manhelp tabulate_twoway R:tabulate twoway} for one- and two-way frequency
tables.  See {manhelp table R} for a more flexible command that produces one-,
two-, and n-way tables of frequencies and a wide variety of summary
statistics.  {opt table} is better, but {cmd:tabulate, summarize()} is faster.
Also see {manhelp tabstat R} for yet another alternative.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R tabulate,summarize()Quickstart:Quick start}

        {mansection R tabulate,summarize()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth "summarize(varname:varname3)"} identifies the name of the
   variable for which summary statistics are to be reported.  If you do not
   specify this option, a table of frequencies is produced; see
   {manhelp tabulate_oneway R:tabulate oneway} and
   {manhelp tabulate_twoway R:tabulate twoway}.  The description
   here concerns {opt tabulate} when this option is specified.

{phang}
[{opt no}]{opt means} includes or suppresses only the means from
   the table.

{pmore}
   The {opt summarize()} table normally includes the mean, standard
   deviation, frequency, and, if the data are weighted, number of
   observations.  Individual elements of the table may be included or
   suppressed by the [{opt no}]{opt means}, [{opt no}]{opt standard},
   [{opt no}]{opt freq}, and [{opt no}]{opt obs} options.  For example, typing

{pin3}{cmd:. tabulate category, summarize(myvar) means standard}

{pmore}
   produces a summary table by {cmd:category} containing only the means and
   standard deviations of {opt myvar}.  You could also achieve the same result by
   typing

{pin3}{cmd:. tabulate category, summarize(myvar) nofreq}

{phang}
[{opt no}]{opt standard} includes or suppresses only the standard
   deviations from the table; see [{opt no}]{opt means} option above.

{phang}
[{opt no}]{opt freq} includes or suppresses only the frequencies
   from the table; see [{opt no}]{opt means} option above.

{phang}
[{opt no}]{opt obs} includes or suppresses only the reported
   number of observations from the table.  If the data are not weighted, the
   number of observations is identical to the frequency, and by default only the
   frequency is reported.  If the data are weighted, the frequency refers to
   the sum of the weights.  See [{opt no}]{opt means} option above.

{phang}
{opt nolabel} causes the numeric codes to be displayed rather than the
   label values.

{phang}
{opt wrap} requests that no action be taken on wide tables to make them
   readable.  Unless {opt wrap} is specified, wide tables are broken into pieces
   to enhance readability.

{phang}
{opt missing} requests that missing values of {it:{help varname:varname1}} and
   {it:{help varname:varname2}} be treated as categories rather than as
   observations to be omitted from analysis.


{marker examples}{...}
{title:Examples:  one-way tables}

    {hline}
{phang}{cmd:. sysuse auto}{p_end}
{phang}{cmd:. tabulate foreign, summarize(mpg)}{p_end}
    {hline}
{phang}{cmd:. sysuse census}{p_end}
{phang}{cmd:. tabulate region [aweight=pop], summarize(medage)}{p_end}
    {hline}


{title:Examples:  two-way tables}

{phang}{cmd:. sysuse auto}{p_end}
{phang}{cmd:. tabulate foreign rep78, summarize(mpg)}{p_end}
{phang}{cmd:. generate wgtcat = autocode(weight, 4, 1760, 4840)}{p_end}
{phang}{cmd:. tabulate wgtcat foreign, summarize(mpg)}{p_end}
{phang}{cmd:. tabulate wgtcat foreign, summarize(mpg) means}{p_end}
{phang}{cmd:. tabulate wgtcat foreign, summarize(mpg) nofreq}{p_end}
