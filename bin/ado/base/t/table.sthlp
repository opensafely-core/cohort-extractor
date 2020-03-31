{smcl}
{* *! version 1.2.14  19oct2017}{...}
{viewerdialog table "dialog table"}{...}
{vieweralsosee "[R] table" "mansection R table"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] collapse" "help collapse"}{...}
{vieweralsosee "[R] summarize" "help summarize"}{...}
{vieweralsosee "[P] tabdisp" "help tabdisp"}{...}
{vieweralsosee "[R] tabstat" "help tabstat"}{...}
{vieweralsosee "[R] tabulate oneway" "help tabulate_oneway"}{...}
{vieweralsosee "[R] tabulate twoway" "help tabulate_twoway"}{...}
{viewerjumpto "Syntax" "table##syntax"}{...}
{viewerjumpto "Menu" "table##menu"}{...}
{viewerjumpto "Description" "table##description"}{...}
{viewerjumpto "Links to PDF documentation" "table##linkspdf"}{...}
{viewerjumpto "Options" "table##options"}{...}
{viewerjumpto "Limits" "table##limits"}{...}
{viewerjumpto "Examples" "table##examples"}{...}
{viewerjumpto "Video example" "table##video"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[R] table} {hline 2}}Flexible table of summary statistics{p_end}
{p2col:}({mansection R table:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:table}
{it:rowvar}
[{it:colvar}
[{it:supercolvar}]]
{ifin}
[{it:{help table##weight:weight}}]
[{cmd:,} {it:options}]


{synoptset 21 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opth c:ontents(table##clist:clist)}}contents of table cells; select
      up to five statistics; default is {cmd:contents(freq)}{p_end}
{synopt:{opth "by(varlist:superrowvarlist)"}}superrow variables
{p_end}

{syntab:Options}
{synopt:{opt cell:width(#)}}cell width{p_end}
{synopt:{opt csep:width(#)}}column-separation width{p_end}
{synopt:{opt stubw:idth(#)}}stub width{p_end}
{synopt:{opt scsep:width(#)}}supercolumn-separation width{p_end}
{synopt:{opt cen:ter}}center-align table cells; default is right-align{p_end}
{synopt:{opt l:eft}}left-align table cells; default is right-align{p_end}
{synopt:{opt cw}}perform casewise deletion{p_end}
{synopt:{opt row}}add row totals{p_end}
{synopt:{opt col:umn}}add column totals{p_end}
{synopt:{opt sc:olumn}}add supercolumn totals{p_end}
{synopt:{opt con:cise}}suppress rows with all missing entries{p_end}
{synopt:{opt m:issing}}show missing statistics with period{p_end}
{synopt:{opt replace}}replace current data with table statistics{p_end}
{synopt:{opth n:ame(strings:string)}}name new variables with prefix {it:string}{p_end}
{synopt:{cmdab:f:ormat(%}{it:{help fmt}}{cmd:)}}display format for numbers in
                      cells; default is {cmd:format(%9.0g)}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt by} is allowed; see {manhelp by D}.{p_end}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s, {opt iweight}s, and {opt pweight}s are
allowed; see {help weight}.{p_end}
{p 4 6 2}
{opt pweight}s may not be used with {opt sd}, {opt semean},
{opt sebinomial}, or {opt sepoisson}.  {opt iweight}s may not be used with
{opt semean}, {opt sebinomial}, or {opt sepoisson}.

{synoptset 21 tabbed}{...}
{marker clist}{...}
{syntab:where elements of {it:clist} may be}

{synopt:{opt freq}}frequency{p_end}
{synopt:{opt m:ean} {varname}}mean of {it:varname}{p_end}
{synopt:{opt sd} {it:varname}}standard deviation{p_end}
{synopt:{opt sem:ean} {it:varname}}standard error of the mean ({cmd:sd/sqrt(n)}){p_end}
{synopt:{opt seb:inomial} {it:varname}}standard error of the mean, binomial
distribution ({cmd:sqrt(p(1-p)/n)}){p_end}
{synopt:{opt sep:oisson} {it:varname}}standard error of the mean, Poisson
distribution ({cmd:sqrt(mean)}){p_end}
{synopt:{opt sum} {it:varname}}sum{p_end}
{synopt:{opt rawsum} {it:varname}}sums ignoring optionally specified weight{p_end}
{synopt:{opt count} {it:varname}}count of nonmissing observations{p_end}
{synopt:{opt n} {it:varname}}same as {opt count}{p_end}
{synopt:{opt max} {it:varname}}maximum{p_end}
{synopt:{opt min} {it:varname}}minimum{p_end}
{synopt:{opt med:ian} {it:varname}}median{p_end}
{synopt:{opt p1} {it:varname}}1st percentile{p_end}
{synopt:{opt p2} {it:varname}}2nd percentile{p_end}
{synopt:{opt ...}}3rd-49th percentile{p_end}
{synopt:{opt p50} {it:varname}}50th percentile ({opt median}){p_end}
{synopt:{opt ...}}51st-97th percentile{p_end}
{synopt:{opt p98} {it:varname}}98th percentile{p_end}
{synopt:{opt p99} {it:varname}}99th percentile{p_end}
{synopt:{opt iqr} {it:varname}}interquartile range{p_end}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Summaries, tables, and tests > Other tables >}
     {bf:Flexible table of summary statistics}


{marker description}{...}
{title:Description}

{pstd}
{opt table} calculates and displays tables of statistics.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R tableQuickstart:Quick start}

        {mansection R tableRemarksandexamples:Remarks and examples}

        {mansection R tableMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth "contents(table##clist:clist)"} specifies the contents of the table's
cells; if not specified, {cmd:contents(freq)} is used by default.
{cmd:contents(freq)} produces a table of frequencies.
{cmd:contents(mean mpg)} produces a table of the means of the variable
{opt mpg}.  {cmd:contents(freq mean mpg sd mpg)} produces a table of
frequencies together with the mean and standard deviation of variable
{opt mpg}.  Up to five statistics may be specified.

{phang}
{opth "by(varlist:superrowvarlist)"} specifies that numeric or string
variables be treated as superrows.  Up to four variables may be specified in
{it:superrowvarlist}.  The {opt by()} option may be specified with
the {opt by} prefix.

{dlgtab:Options}

{phang}
{opt cellwidth(#)} specifies the width of the cell in units of digit widths;
   10 means the space occupied by 10 digits, which is {cmd:0123456789}.  The
   default {opt cellwidth()} is not a fixed number, but a number chosen by
   {opt table} to spread the table out while presenting a reasonable number of
   columns across the page.

{phang}
{opt csepwidth(#)} specifies the separation between columns
   in units of digit widths.  The default is not a fixed number, but a number
   chosen by {opt table} according to what it thinks looks best.

{phang}
{opt stubwidth(#)} specifies the width, in units of digit
   widths, to be allocated to the left stub of the table.  The default is not a
   fixed number, but a number chosen by {opt table} according to what it thinks
   looks best.

{phang}
{opt scsepwidth(#)} specifies the separation between
   supercolumns in units of digit widths.  The default is not a fixed number,
   but a number chosen by {opt table} to present the results best.

{phang}
{opt center} specifies that results be centered in the table's cells.  The
   default is to right-align results.  For centering to work well, you typically
   need to specify a display format as well.  {cmd:center format(%9.2f)} is
   popular.

{phang}
{opt left} specifies that column labels be left-aligned.  The default is to
   right-align column labels to distinguish them from supercolumn labels, which
   are left-aligned.

{phang}
{opt cw} specifies casewise deletion.  If {opt cw} is not specified, all
   observations possible are used to calculate each of the specified statistics.
   {opt cw} is relevant only when you request a table containing statistics on
   multiple variables.  For instance, {cmd:contents(mean mpg mean weight)} would
   produce a table reporting the means of variables {opt mpg} and
   {opt weight}.  Consider an observation in which {opt mpg} is known but
   {opt weight} is missing.  By default, that observation will be used in the
   calculation of the mean of {opt mpg}.  If you specify {opt cw}, the
   observation will be excluded in the calculation of the means of both
   {opt mpg} and {opt weight}.

{phang}
{opt row} specifies that a row be added to the table reflecting the total
   across the rows.

{phang}
{opt column} specifies that a column be added to the table reflecting the total
   across columns.

{phang}
{opt scolumn} specifies that a supercolumn be added to the table reflecting the
   total across supercolumns.

{phang}
{opt concise} specifies that rows with all missing entries not be displayed.

{phang}
{opt missing} specifies that missing statistics be shown in the table as
   periods (Stata's missing-value indicator).  The default is that missing
   entries be left blank.

{phang}
{opt replace} specifies that the data in memory be replaced with data
   containing 1 observation per cell (row, column, supercolumn, and superrow)
   and with variables containing the statistics designated in {opt contents()}.

{pmore}
   This option is rarely specified.  If you do not specify this option,
   the data in memory remain unchanged.

{pmore}
   If you do specify this option, the first statistic will be named
   {opt table1}, the second {opt table2}, and so on.  For instance, if
   {cmd:contents(mean mpg sd mpg)} was specified, the means of {cmd:mpg} would
   be in variable {opt table1} and the standard deviations in {opt table2}.

{phang}
{opth name:(strings:string)} is relevant only if you specify {opt replace}.
   {opt name()} allows changing the default stub name that {opt replace} uses
   to name the new variables associated with the statistics.  If you specify
   {cmd:name(stat)}, the first statistic will be placed in variable
   {opt stat1}, the second in {opt stat2}, and so on.

{phang}
{cmd:format(%}{it:{help fmt}}{cmd:)} specifies the display format for
   presenting numbers in the table's cells.  {cmd:format(%9.0g)} is the default;
   {cmd:format(%9.2f)} and {cmd:format(%9.2fc)} are popular alternatives.  The
   width of the format you specify does not matter, except that {cmd:%}{it:fmt}
   must be valid.  The width of the cells is chosen by {opt table} to present
   the results best.  The {opt cellwidth()} option allows you to override
  {opt table}'s choice.


{marker limits}{...}
{title:Limits}

{pstd}
Up to four variables may be specified in the {cmd:by()}, so with the three row,
column, and supercolumn variables, seven-way tables may be displayed.

{pstd}
Up to five statistics may be displayed in each cell of the table.

{pstd}
The sum of the number of rows, columns, supercolumns, and superrows is called
the number of margins.  A table may contain up to 3,000 margins.


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}One-way table; frequencies shown by default{p_end}
{phang2}{cmd:. table rep78}{p_end}

{pstd}One-way table; show count of nonmissing observations for {cmd:mpg}{p_end}
{phang2}{cmd:. table rep78, contents(n mpg)}{p_end}

{pstd}One-way table; multiple statistics on {cmd:mpg} requested{p_end}
{phang2}{cmd:. table rep78, c(n mpg mean mpg sd mpg median mpg)}{p_end}

{pstd}Add formatting{p_end}
{phang2}{cmd:. table rep78, c(n mpg  mean mpg  sd mpg  median mpg) format(%9.2f)}

{pstd}Two-way table; frequencies shown by default{p_end}
{phang2}{cmd:. table rep78 foreign}{p_end}

{pstd}Two-way table; show means of {cmd:mpg} for each cell{p_end}
{phang2}{cmd:. table rep78 foreign, c(mean mpg)}{p_end}

{pstd}Add formatting{p_end}
{phang2}{cmd:. table rep78 foreign, c(mean mpg) format(%9.2f) center}{p_end}
{phang2}{cmd:. table foreign rep78, c(mean mpg) format(%9.2f) center}

{pstd}Add row and column totals{p_end}
{phang2}{cmd:. table foreign rep78, c(mean mpg) format(%9.2f) center}
                {cmd:row col}

    {hline}
    Setup
{phang2}{cmd:. webuse byssin}{p_end}

{pstd}Three-way table{p_end}
{phang2}{cmd:. table workplace smokes race [fw=pop], c(mean prob)}{p_end}

{pstd}Add formatting{p_end}
{phang2}{cmd:. table workplace smokes race [fw=pop], c(mean prob) format(%9.3f)}
{p_end}

{pstd}Request supercolumn totals{p_end}
{phang2}{cmd:. table workplace smokes race [fw=pop], c(mean prob)}
               {cmd:format(%9.3f) sc} 

    {hline}
    Setup
{phang2}{cmd:. webuse byssin1}{p_end}

{pstd}Four-way table{p_end}
{phang2}{cmd:. table workplace smokes race [fw=pop], by(sex) c(mean prob)}
                {cmd:format(%9.3f)}{p_end}

{pstd}Four-way table with supercolumn, row, and column totals{p_end}
{phang2}{cmd:. table workplace smokes race [fw=pop], by(sex) c(mean prob)}
                {cmd:format(%9.3f) sc col row}{p_end}
    {hline}


{marker video}{...}
{title:Video example}

{phang}
{browse "http://www.youtube.com/watch?v=Dzg6AMSt10w":Combining cross-tabulations and descriptives in Stata}
{p_end}
