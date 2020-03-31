{smcl}
{* *! version 1.1.28  15may2018}{...}
{viewerdialog tabulate "dialog tabulate1"}{...}
{viewerdialog "tabulate ..., generate()" "dialog tabulategen"}{...}
{viewerdialog tab1 "dialog tab1"}{...}
{vieweralsosee "[R] tabulate oneway" "mansection R tabulateoneway"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] collapse" "help collapse"}{...}
{vieweralsosee "[R] Epitab" "help epitab"}{...}
{vieweralsosee "[SVY] svy: tabulate oneway" "help svy_tabulate_oneway"}{...}
{vieweralsosee "[SVY] svy: tabulate twoway" "help svy_tabulate_twoway"}{...}
{vieweralsosee "[R] table" "help table"}{...}
{vieweralsosee "[R] tabstat" "help tabstat"}{...}
{vieweralsosee "[R] tabulate, summarize()" "help tabulate_summarize"}{...}
{vieweralsosee "[R] tabulate twoway" "help tabulate_twoway"}{...}
{vieweralsosee "[XT] xttab" "help xttab"}{...}
{viewerjumpto "Syntax" "tabulate_oneway##syntax"}{...}
{viewerjumpto "Menu" "tabulate_oneway##menu"}{...}
{viewerjumpto "Description" "tabulate_oneway##description"}{...}
{viewerjumpto "Links to PDF documentation" "tabulate_oneway##linkspdf"}{...}
{viewerjumpto "Options" "tabulate_oneway##options"}{...}
{viewerjumpto "Examples" "tabulate_oneway##examples"}{...}
{viewerjumpto "Video example" "tabulate_oneway##video"}{...}
{viewerjumpto "Stored results" "tabulate_oneway##results"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[R] tabulate oneway} {hline 2}}One-way table of frequencies{p_end}
{p2col:}({mansection R tabulateoneway:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
One-way table

{p 8 17 2}
{cmdab:ta:bulate}
{varname}
{ifin}
[{it:{help tabulate oneway##weight:weight}}]
[{cmd:,} {it:{help tabulate_oneway##tabulate1_options:tabulate1_options}}]


{pstd}
One-way table for each variable {c -} a convenience tool

{p 8 17 2}
{cmd:tab1}
{varlist}
{ifin}
[{it:{help tabulate oneway##weight:weight}}]
[{cmd:,} {it:{help tabulate_oneway##tab1_options:tab1_options}}]


{marker tabulate1_options}{...}
{synoptset 21 tabbed}{...}
{synopthdr:tabulate1_options}
{synoptline}
{syntab:Main}
{synopt:{opth subpop(varname)}}exclude observations for which {it:varname} = 0{p_end}
{synopt:{opt m:issing}}treat missing values like other values{p_end}
{synopt:{opt nof:req}}do not display frequencies{p_end}
{synopt:{opt nol:abel}}display numeric codes rather than value labels{p_end}
{synopt:{opt p:lot}}produce a bar chart of the relative frequencies{p_end}
{synopt:{opt sort}}display the table in descending order of frequency{p_end}

{syntab:Advanced}
{synopt:{opt g:enerate(stubname)}}create indicator variables for {it:stubname}{p_end}
{synopt:{opt matcell(matname)}}save frequencies in {it:matname}; programmer's option{p_end}
{synopt:{opt matrow(matname)}}save unique values of {varname} in {it:matname}; programmer's option{p_end}
{synoptline}

{marker tab1_options}{...}
{synopthdr:tab1_options}
{synoptline}
{syntab:Main}
{synopt:{opth subpop(varname)}}exclude observations for which {it:varname} = 0{p_end}
{synopt:{opt m:issing}}treat missing values like other values{p_end}
{synopt:{opt nof:req}}do not display frequencies{p_end}
{synopt:{opt nol:abel}}display numeric codes rather than value labels{p_end}
{synopt:{opt p:lot}}produce a bar chart of the relative frequencies{p_end}
{synopt:{opt sort}}display the table in descending order of frequency{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt by} is allowed with {opt tabulate} and {opt tab1}; see {manhelp by D}.
	{p_end}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s, {opt aweight}s, and {opt iweight}s are allowed;
see {help weight}.


{marker menu}{...}
{title:Menu}

    {title:tabulate oneway}

{phang2}
{bf:Statistics > Summaries, tables, and tests > Frequency tables > One-way table}

    {title:tabulate ..., generate()}

{phang2}
{bf:Data > Create or change data > Other variable-creation commands >}
       {bf:Create indicator variables}

    {title:tab1}

{phang2}
{bf:Statistics > Summaries, tables, and tests > Frequency tables > Multiple one-way tables}


{marker description}{...}
{title:Description}

{pstd}
{opt tabulate} produces a one-way table of frequency counts.

{pstd}
For information on a two-way table of frequency counts along with measures of
association, including the common Pearson chi-squared, the likelihood ratio
chi-squared, Cram{c e'}r's V, Fisher's exact test, Goodman and Kruskal's
gamma, and Kendall's tau-b, see
{manhelp tabulate_twoway R:tabulate twoway}.

{pstd}
{opt tab1} produces a one-way tabulation for each variable specified in {varlist}.

{pstd}
Also see {manhelp table R} and {manhelp tabstat R} if you want one-, two-, or
n-way table of frequencies and a wide variety of statistics.  See
{manhelp tabulate_summarize R:tabulate, summarize()} for a description of
{opt tabulate} with the {opt summarize()} option; it produces a table
(breakdowns) of means and standard deviations.  {opt table} is better than
{cmd:tabulate, summarize()}, but {cmd:tabulate, summarize()} is faster.  See
{manhelp Epitab R} for a 2 x 2 table with statistics of interest to
epidemiologists.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R tabulateonewayQuickstart:Quick start}

        {mansection R tabulateonewayRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth subpop(varname)} excludes observations for which {it:varname} = 0 in
tabulating frequencies.  The mathematical results of {cmd:tabulate ..., subpop(myvar)}
are the same as {cmd:tabulate ... if myvar != 0}, but the table may be
presented differently.  The identities of the rows and columns will be
determined from all the data, including the {it:myvar} = 0 group, so there may
be entries in the table with frequency 0.

{pmore}
Consider tabulating {opt answer}, a variable that takes on values 1, 2, and 3,
but consider tabulating it just for the {cmd:male==1} subpopulation.  Assume
that {opt answer} is never 2 in this group.  {cmd:tabulate answer if male==1}
produces a table with two rows: one for answer 1 and one for answer 3.  There
will be no row for answer 2 because answer 2 was never observed.
{cmd:tabulate answer, subpop(male)} produces a table with three rows.  The row
for answer 2 will be shown as having 0 frequency.

{phang}
{opt missing} requests that missing values be treated like other values
in calculations of counts, percentages, and other statistics.

{phang}
{opt nofreq} suppresses the printing of the frequencies.

{phang}
{opt nolabel} causes the numeric codes to be displayed rather than the
value labels.

{phang}
{opt plot} produces a bar chart of the relative frequencies in a
one-way table. (Also see {manhelp histogram R}.)

{phang}
{opt sort} puts the table in descending order of frequency (and
ascending order of the variable within equal values of frequency).

{dlgtab:Advanced}

{phang}
{opt generate(stubname)} creates a set of indicator variables
({it:stubname}{cmd:1}, {it:stubname}{cmd:2}, ...)
reflecting the observed values of the tabulated variable.
The {opt generate()} option may not be used with the {opt by} prefix.

{phang}
{opt matcell(matname)} saves the reported frequencies in
{it:matname}.  This option is for use by programmers.

{phang}
{opt matrow(matname)} saves the numeric values of the r x 1
row stub in {it:matname}.  This option is for use by programmers.
{opt matrow()} may not be specified if the row variable is a string.


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. sysuse census}{p_end}

{pstd}One-way table of frequencies{p_end}
{phang2}{cmd:. tabulate region}

{pstd}Show table in descending order of frequencies{p_end}
{phang2}{cmd:. tabulate region, sort}

{pstd}Create indicator variables for {cmd:region}, called {cmd:reg1},
{cmd:reg2}, ...{p_end}
{phang2}{cmd:. tabulate region, gen(reg)}

    {hline}
    Setup
{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. tabulate rep78}{p_end}
{phang2}{cmd:. tabulate foreign}{p_end}

{pstd}Shorthand for above two commands{p_end}
{phang2}{cmd:. tab1 rep78 foreign}{p_end}
    {hline}


{marker video}{...}
{title:Video example}

{phang}
{browse "http://www.youtube.com/watch?v=3WpMRtTNZsw":Tables and cross-tabulations in Stata}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:tabulate} and {cmd:tab1} store the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(r)}}number of rows{p_end}
{p2colreset}{...}
