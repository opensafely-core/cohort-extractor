{smcl}
{* *! version 1.3.22  15may2018}{...}
{viewerdialog tabulate "dialog tabulate2"}{...}
{viewerdialog tab2 "dialog tab2"}{...}
{viewerdialog tabi "dialog tabi"}{...}
{vieweralsosee "[R] tabulate twoway" "mansection R tabulatetwoway"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] collapse" "help collapse"}{...}
{vieweralsosee "[R] Epitab" "help epitab"}{...}
{vieweralsosee "[SVY] svy: tabulate oneway" "help svy_tabulate_oneway"}{...}
{vieweralsosee "[SVY] svy: tabulate twoway" "help svy_tabulate_twoway"}{...}
{vieweralsosee "[R] table" "help table"}{...}
{vieweralsosee "[R] tabstat" "help tabstat"}{...}
{vieweralsosee "[R] tabulate oneway" "help tabulate_oneway"}{...}
{vieweralsosee "[R] tabulate, summarize()" "help tabulate_summarize"}{...}
{vieweralsosee "[XT] xttab" "help xttab"}{...}
{viewerjumpto "Syntax" "tabulate twoway##syntax"}{...}
{viewerjumpto "Menu" "tabulate twoway##menu"}{...}
{viewerjumpto "Description" "tabulate twoway##description"}{...}
{viewerjumpto "Links to PDF documentation" "tabulate_twoway##linkspdf"}{...}
{viewerjumpto "Options" "tabulate twoway##options"}{...}
{viewerjumpto "Limits" "tabulate twoway##limits"}{...}
{viewerjumpto "Examples" "tabulate twoway##examples"}{...}
{viewerjumpto "Video examples" "tabulate twoway##video"}{...}
{viewerjumpto "Stored results" "tabulate twoway##results"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[R] tabulate twoway} {hline 2}}Two-way table of frequencies{p_end}
{p2col:}({mansection R tabulatetwoway:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Two-way table

{p 8 17 2}
{cmdab:ta:bulate}
{it:{help varname:varname1}} {it:{help varname:varname2}}
{ifin}
[{it:{help tabulate twoway##weight:weight}}]
[{cmd:,} {it:options}]


{pstd}
Two-way table for all possible combinations {c -} a convenience tool

{p 8 17 2}
{cmd:tab2}
{varlist}
{ifin}
[{it:{help tabulate twoway##weight:weight}}]
[{cmd:,} {it:options}]


{pstd}
Immediate form of two-way tabulations

{p 8 17 2}
{cmd:tabi} {it:#11} {it:#12} [{it:...}] {cmd:\} {it:#21} {it:#22}
[{it:...}] [{cmd:\} {it:...}] [{cmd:,} {it:options}]


{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt ch:i2}}report Pearson's chi-squared
{p_end}
{synopt:{opt e:xact}[{opt (#)}]}report Fisher's exact test
{p_end}
{synopt:{opt g:amma}}report Goodman and Kruskal's gamma
{p_end}
{synopt:{opt lr:chi2}}report likelihood-ratio chi-squared
{p_end}
{synopt:{opt t:aub}}report Kendall's tau-b
{p_end}
{synopt:{opt V}}report Cram{c e'}r's V
{p_end}
{synopt:{opt cchi:2}}report Pearson's chi-squared in each cell
{p_end}
{synopt:{opt co:lumn}}report relative frequency within its column of each cell
{p_end}
{synopt:{opt r:ow}}report relative frequency within its row of each cell
{p_end}
{synopt:{opt clr:chi2}}report likelihood-ratio chi-squared in each cell
{p_end}
{synopt:{opt ce:ll}}report the relative frequency of each cell
{p_end}
{synopt:{opt exp:ected}}report expected frequency in each cell
{p_end}
{synopt:{opt nof:req}}do not display frequencies
{p_end}
{synopt:{opt rowsort}}list rows in order of observed frequency
{p_end}
{synopt:{opt colsort}}list columns in order of observed frequency
{p_end}
{synopt:{opt m:issing}}treat missing values like other values
{p_end}
{synopt:{opt w:rap}}do not wrap wide tables
{p_end}
{synopt:[{opt no}]{opt key}}report/suppress cell contents key
{p_end}
{synopt:{opt nol:abel}}display numeric codes rather than value labels
{p_end}
{synopt:{opt nolog}}do not display enumeration log for Fisher's exact test
{p_end}
{p2coldent:* {opt first:only}}show only tables that include the first
               variable in {varlist}
{p_end}

{syntab:Advanced}
{synopt:{opt matcell(matname)}}save frequencies in {it:matname};
	programmer's option
{p_end}
{synopt:{opt matrow(matname)}}save unique values of
	{it:{help varname:varname1}} in {it:matname}; programmers option
{p_end}
{synopt:{opt matcol(matname)}}save unique values of
	{it:{help varname:varname2}} in {it:matname}; programmers option
{p_end}
{p2coldent:# {opt replace}}replace current data with given cell frequencies
{p_end}

{synopt :{opt a:ll}}equivalent to specifying {cmd:chi2 lrchi2 V gamma taub}
{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt firstonly} is available only for {cmd:tab2}.{p_end}
{p 4 6 2}
# {opt replace} is available only for {cmd:tabi}.{p_end}
{p 4 6 2}
{opt by} is allowed with {opt tabulate} and {opt tab2}; see
{manhelp by D}.
{p_end}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s, {opt aweight}s, and {opt iweight}s are allowed by
{opt tabulate}.  {opt fweight}s are allowed by {opt tab2}.  See {help weight}.{p_end}
{p 4 6 2}
{opt all} does not appear in the dialog box.{p_end}


{marker menu}{...}
{title:Menu}

    {title:tabulate}

{phang2}
{bf:Statistics > Summaries, tables, and tests > Frequency tables >}
       {bf:Two-way table with measures of association}

    {title:tab2}

{phang2}
{bf:Statistics > Summaries, tables, and tests > Frequency tables >}
       {bf:All possible two-way tables}

    {title:tabi}

{phang2}
{bf:Statistics > Summaries, tables, and tests > Frequency tables > Table calculator}


{marker description}{...}
{title:Description}

{pstd}
{cmd:tabulate} produces a two-way table of frequency counts, along
with various measures of association, including the common Pearson's
chi-squared, the likelihood-ratio chi-squared, Cram{c e'}r's V, Fisher's exact
test, Goodman and Kruskal's gamma, and Kendall's tau-b.

{pstd}
Line size is respected.  That is, if you resize the Results window
before running {opt tabulate}, the resulting
two-way tabulation will take advantage of the available horizontal space.
Stata for Unix(console) users can instead use the {helpb linesize:set linesize}
command to take advantage of this feature.

{pstd}
{opt tab2} produces all possible two-way tabulations of the variables
specified in {varlist}.

{pstd}
{opt tabi} displays the r x c table, using the values specified; rows are
separated by '{cmd:\}'.  If no options are specified, it is as if {opt exact}
were specified for a 2 x 2 table and {opt chi2} were specified otherwise.  See
{help immed} for a general description of immediate commands.
See {mansection R tabulatetwowayRemarksandexamplesTableswithimmediatedata:{it:Tables with immediate data}} in {bf:[R] tabulate twoway} for examples using {cmd:tabi}.

{pstd}
See {manhelp tabulate_oneway R:tabulate oneway} if you want a one-way table of
frequencies.  See {manhelp table R} and {manhelp tabstat R} if you want one-,
two-, or n-way table of frequencies and a wide variety of summary statistics.
See {manhelp tabulate_summarize R:tabulate, summarize()} for a description of
{opt tabulate} with the {opt summarize()} option; it produces a table
(breakdowns) of means and standard deviations.  {opt table} is better than
{cmd:tabulate, summarize()}, but {cmd:tabulate, summarize()} is faster.  See
{manhelp Epitab R} for a 2 x 2 table with statistics of interest to
epidemiologists.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R tabulatetwowayQuickstart:Quick start}

        {mansection R tabulatetwowayRemarksandexamples:Remarks and examples}

        {mansection R tabulatetwowayMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt chi2} calculates and displays Pearson's chi-squared for the
hypothesis that the rows and columns in a two-way table are independent.
{opt chi2} may not be specified if {opt aweight}s or {opt iweight}s are
specified.

{phang}
{opt exact}[{opt (#)}] displays the significance
calculated by Fisher's exact test and may be applied to r x c as well as to
2 x 2 tables.  For 2 x 2 tables, both one- and two-sided probabilities
are displayed.  For r x c tables, two-sided probabilities are displayed.
The optional positive integer {it:#} is a multiplier on the
amount of memory that the command is permitted to consume.  The default is 1.
This option should not be necessary for reasonable r x c tables.  If the
command terminates with error 910, try {cmd:exact(2)}.  The maximum row
or column dimension allowed when computing Fisher's exact test is the 
maximum row or column dimension for {cmd: tabulate} (see {help limits}).

{phang}
{opt gamma} displays Goodman and Kruskal's gamma along with its
asymptotic standard error.  {opt gamma} is appropriate only when both variables
are ordinal.  {opt gamma} may not be specified if {opt aweight}s or
{opt iweight}s are specified.

{phang}
{opt lrchi2} displays the likelihood-ratio chi-squared statistic. 
{opt lrchi2} may not be specified if {opt aweight}s or {opt iweight}s are
specified.

{phang}
{opt taub} displays Kendall's tau-b along with its asymptotic standard
error. {opt taub} is appropriate only when both variables are ordinal.
{opt taub} may not be specified if {opt aweight}s or {opt iweight}s are
specified.

{phang}
{opt V} (note capitalization) displays Cram{c e'}r's V.  {opt V} may
not be specified if {opt aweight}s or {opt iweight}s are specified.

{phang}
{opt cchi2} displays each cell's contribution to Pearson's chi-squared in
a two-way table.

{phang}
{opt column} displays the relative frequency of each cell within its column in
a two-way table.

{phang}
{opt row} displays the relative frequency of each cell within its row in
a two-way table.

{phang}
{opt clrchi2} displays each cell's contribution to the likelihood-ratio
chi-squared in a two-way table.

{phang}
{opt cell} displays the relative frequency of each cell in a two-way table.

{phang}
{opt expected} displays the expected frequency of each cell in a two-way
table.

{phang}
{opt nofreq} suppresses the printing of the frequencies.

{phang}
{opt rowsort} and {opt colsort} specify that the rows and columns,
respectively, be presented in order of observed frequency.

{pmore}
By default, rows and columns are presented in ascending order of the row and
column variable.  For instance, if you type {opt tabulate a b} and {opt a}
takes on the values 2, 3, and 5, then the first row of the table will
correspond to {opt a} = 2; the second row will correspond to
{opt a} = 3; and the third row will correspond to {opt a} = 5.

{pmore}
{opt rowsort} specifies that the rows instead be presented in descending order
of observed frequency of the values.  If you type {opt twoway a b, rowsort},
the most frequently observed value of {opt a} will be listed in the first row,
the second most frequently observed value of {opt a} in the second row, and so
on.  If there are rows with equal frequencies, they will be presented in
ascending order of the values of {opt a}.  If {opt a} = 5 occurs with
frequency 1,000 and values {opt a} = 2 and {opt a} = 3 each occur 
with frequency 500, the rows will be presented in the order 
{opt a} = 5, {opt a} = 2, and {opt a} = 3.

{pmore}
{opt colsort} does the same as {opt rowsort}, except with the columns and the
column variable.

{pmore}
{opt rowsort} and {opt colsort} may be specified together.

{phang}
{opt missing} requests that missing values be treated like other values
in calculations of counts, percentages, and other statistics.

{phang}
{opt wrap} requests that Stata take no action on wide, two-way tables
to make them readable.  Unless {opt wrap} is specified, wide tables are broken
into pieces to enhance readability.

{phang}
[{opt no}]{opt key} suppresses or forces the display of a key above two-way tables.
The default is to display the key if more than one cell statistic is
requested, and otherwise to omit it.  {opt key} forces the display of the key.
{opt nokey} suppresses its display.

{phang}
{opt nolabel} causes the numeric codes to be displayed rather than the value labels.

{phang}
{opt nolog} suppresses the display of the log for Fisher's exact test.  Using
Fisher's exact test requires counting all tables that have a probability
exceeding that of the observed table given the observed row and column totals.
The log counts down each stage of the network computations, starting from the
number of columns and counting down to 1, displaying the number of nodes in
the network at each stage.  A log is not displayed for 2 x 2 tables.

{phang}
{opt firstonly}, available only with {cmd:tab2}, restricts the output to only
those tables that include the first variable in {varlist}.  Use this option to
interact one variable with a set of others.

{dlgtab:Advanced}

{phang}
{opt matcell(matname)} saves the reported frequencies in
{it:matname}.  This option is for use by programmers.

{phang}
{opt matrow(matname)} saves the numeric values of the r x 1
row stub in {it:matname}.  This option is for use by programmers.
{opt matrow()} may not be specified if the row variable is a string.

{phang}
{opt matcol(matname)} saves the numeric values of the 1 x c
column stub in {it:matname}.  This option is for use by programmers.
{opt matcol()} may not be specified if the column variable is a string.

{phang}
{opt replace} indicates that the immediate data specified as arguments to the
{opt tabi} command be left as the current data in place of whatever data 
were there.

{pstd}
The following option is available with {opt tabulate} but is not shown in the
dialog box:

{phang}
{opt all} is equivalent to specifying {cmd:chi2 lrchi2 V gamma taub}.
Note the omission of {opt exact}.  When {opt all} is specified, {opt no} may
be placed in front of the other options.  {opt all noV} requests all
association measures except Cram{c e'}r's V (and Fisher's exact).
{opt all exact} requests all association measures, including Fisher's exact
test.  {opt all} may not be specified if {opt aweight}s or {opt iweight}s are
specified.


{marker limits}{...}
{title:Limits}

{pstd}
Two-way tables may have a maximum of 1,200 rows and 80 columns (Stata/MP and
Stata/SE) or 300 rows and 20 columns (Stata/IC).  If larger tables are needed,
see {manhelp table R}.


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. webuse citytemp2}

{pstd}Two-way table of frequencies{p_end}
{phang2}{cmd:. tabulate region agecat}

{pstd}Include row percentages{p_end}
{phang2}{cmd:. tabulate region agecat, row}

{pstd}Include column percentages{p_end}
{phang2}{cmd:. tabulate region agecat, column}

{pstd}Include cell percentages{p_end}
{phang2}{cmd:. tabulate region agecat, cell}

{pstd}Include row percentages, suppress frequency counts{p_end}
{phang2}{cmd:. tabulate region agecat, row nofreq}

{pstd}Include chi-squared test for independence of rows and columns{p_end}
{phang2}{cmd:. tabulate region agecat, chi2}

    {hline}
    Setup
{phang2}{cmd:. webuse dose}

{pstd}Include all measures of association, except Fisher's exact test{p_end}
{phang2}{cmd:. tabulate dose function, all}

{pstd}Include all measures of association, including Fisher's exact test{p_end}
{phang2}{cmd:. tabulate dose function, all exact}

    {hline}
{pstd}Immediate form{p_end}
{phang2}{cmd:. tabi 30 18 \ 18 14}

{pstd}Immediate form, 2 x 3 table{p_end}
{phang2}{cmd:. tabi 30 18 38 \ 13 7 22}

{pstd}Add Fisher's exact test{p_end}
{phang2}{cmd:. tabi 30 18 38 \ 13 7 22, chi2 exact}

{pstd}3 by 2 table, all measures of association{p_end}
{phang2}{cmd:. tabi 30 13 \ 18 7 \ 38 22, all exact}{p_end}
    {hline}


{marker video}{...}
{title:Video examples}

{phang}
{browse "http://www.youtube.com/watch?v=DBsMPZqJj-o":Pearson's chi2 and Fisher's exact test in Stata}

{phang}
{browse "http://www.youtube.com/watch?v=3WpMRtTNZsw":Tables and cross-tabulations in Stata}

{phang}
{browse "http://www.youtube.com/watch?v=GZIi9zAlzIA":Cross-tabulations and chi-squared tests calculator}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:tabulate}, {cmd:tab2}, and {cmd:tabi} store the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(r)}}number of rows{p_end}
{synopt:{cmd:r(c)}}number of columns{p_end}
{synopt:{cmd:r(chi2)}}Pearson's chi-squared test{p_end}
{synopt:{cmd:r(p)}}p-value for Pearson's chi-squared test{p_end}
{synopt:{cmd:r(gamma)}}gamma{p_end}
{synopt:{cmd:r(p1_exact)}}one-sided Fisher's exact p{p_end}
{synopt:{cmd:r(p_exact)}}Fisher's exact p{p_end}
{synopt:{cmd:r(chi2_lr)}}likelihood-ratio chi-squared{p_end}
{synopt:{cmd:r(p_lr)}}p-value for likelihood-ratio test{p_end}
{synopt:{cmd:r(CramersV)}}Cram{c e'}r's V{p_end}
{synopt:{cmd:r(ase_gam)}}ASE of gamma{p_end}
{synopt:{cmd:r(ase_taub)}}ASE of tau_b{p_end}
{synopt:{cmd:r(taub)}}tau_b{p_end}

{pstd}
{cmd:r(p1_exact)} is defined only for 2 x 2 tables. Also, the
{cmd:matrow()}, {cmd:matcol()}, and {cmd:matcell()} options allow you to
obtain the row values, column values, and frequencies, respectively.{p_end}
{p2colreset}{...}
