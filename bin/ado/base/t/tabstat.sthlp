{smcl}
{* *! version 1.1.15  19oct2017}{...}
{viewerdialog tabstat "dialog tabstat"}{...}
{vieweralsosee "[R] tabstat" "mansection R tabstat"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] collapse" "help collapse"}{...}
{vieweralsosee "[R] summarize" "help summarize"}{...}
{vieweralsosee "[R] table" "help table"}{...}
{vieweralsosee "[R] tabulate, summarize()" "help tabulate_summarize"}{...}
{viewerjumpto "Syntax" "tabstat##syntax"}{...}
{viewerjumpto "Menu" "tabstat##menu"}{...}
{viewerjumpto "Description" "tabstat##description"}{...}
{viewerjumpto "Links to PDF documentation" "tabstat##linkspdf"}{...}
{viewerjumpto "Options" "tabstat##options"}{...}
{viewerjumpto "Examples" "tabstat##examples"}{...}
{viewerjumpto "Video example" "tabstat##video"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[R] tabstat} {hline 2}}Compact table of summary statistics{p_end}
{p2col:}({mansection R tabstat:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:tabstat}
{varlist}
{ifin}
[{it:{help tabstat##weight:weight}}]
[{cmd:,} {it:options}]


{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opth by(varname)}}
group statistics by variable
{p_end}
{synopt:{cmdab:s:tatistics:(}{it:{help tabstat##statname:statname}} [{it:...}]{cmd:)}}
report specified statistics
{p_end}

{syntab:Options}
{synopt:{opt la:belwidth(#)}}
width for {opt by()} variable labels; default is {cmd:labelwidth(16)}
{p_end}
{synopt:{opt va:rwidth(#)}}
variable width; default is {cmd:varwidth(12)}
{p_end}
{synopt:{cmdab:c:olumns(}{opt v:ariables}{cmd:)}}
display variables in table columns; the default
{p_end}
{synopt:{cmdab:c:olumns(}{opt s:tatistics}{cmd:)}}
display statistics in table columns
{p_end}
{synopt:{opt f:ormat}[{cmd:(%}{it:{help format:fmt}}{cmd:)}]}
display format for statistics; default format is {cmd:%9.0g}
{p_end}
{synopt:{opt case:wise}}
perform casewise deletion of observations
{p_end}
{synopt:{opt not:otal}}
do not report overall statistics; use with {opt by()}
{p_end}
{synopt:{opt m:issing}}
report statistics for missing values of {opt by()} variable
{p_end}
{synopt:{opt nosep:arator}}
do not use separator line between {opt by()} categories
{p_end}
{synopt:{opt lo:ngstub}}
make left table stub wider
{p_end}
{synopt:{opt save}}
store summary statistics in {opt r()}
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
      {bf:Compact table of summary statistics}


{marker description}{...}
{title:Description}

{pstd}
{cmd:tabstat} displays summary statistics for a series of numeric variables in
one table.  It allows you to specify the list of statistics to be displayed.
Statistics can be calculated (conditioned on) another variable.  {cmd:tabstat}
allows substantial flexibility in terms of the statistics presented and
the format of the table.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R tabstatQuickstart:Quick start}

        {mansection R tabstatRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth by(varname)} specifies that the statistics be
   displayed separately for each unique value of {it:varname}; {it:varname}
   may be numeric or string.  For instance, {cmd:tabstat height} would present
   the overall mean of height.  {cmd:tabstat height, by(sex)} would present
   the mean height of males, and of females, and the overall mean height.
   Do not confuse the {opt by()} option with the {helpb by} prefix; both may
   be specified.

{phang}
{cmd:statistics(}{it:statname} [{it:...}]{cmd:)}
   specifies the statistics to be displayed; the default is equivalent to
   specifying {cmd:statistics(mean)}.  ({opt stats()} is a synonym for
   {opt statistics()}.)  Multiple statistics may be specified
   and are separated by white space, such as {cmd:statistics(mean sd)}.
   Available statistics are

{marker statname}{...}
{synoptset 17}{...}
{synopt:{space 4}{it:statname}}Definition{p_end}
{space 4}{synoptline}
{synopt:{space 4}{opt me:an}} mean{p_end}
{synopt:{space 4}{opt co:unt}} count of nonmissing observations{p_end}
{synopt:{space 4}{opt n}} same as {cmd:count}{p_end}
{synopt:{space 4}{opt su:m}} sum{p_end}
{synopt:{space 4}{opt ma:x}} maximum{p_end}
{synopt:{space 4}{opt mi:n}} minimum{p_end}
{synopt:{space 4}{opt r:ange}} range = {opt max} - {opt min}{p_end}
{synopt:{space 4}{opt sd}} standard deviation{p_end}
{synopt:{space 4}{opt v:ariance}} variance{p_end}
{synopt:{space 4}{opt cv}} coefficient of variation ({cmd:sd/mean}){p_end}
{synopt:{space 4}{opt sem:ean}} standard error of mean ({cmd:sd/sqrt(n)}){p_end}
{synopt:{space 4}{opt sk:ewness}} skewness{p_end}
{synopt:{space 4}{opt k:urtosis}} kurtosis{p_end}
{synopt:{space 4}{opt p1}} 1st percentile{p_end}
{synopt:{space 4}{opt p5}} 5th percentile{p_end}
{synopt:{space 4}{opt p10}} 10th percentile{p_end}
{synopt:{space 4}{opt p25}} 25th percentile{p_end}
{synopt:{space 4}{opt med:ian}} median (same as {opt p50}){p_end}
{synopt:{space 4}{opt p50}} 50th percentile (same as {opt median}){p_end}
{synopt:{space 4}{opt p75}} 75th percentile{p_end}
{synopt:{space 4}{opt p90}} 90th percentile{p_end}
{synopt:{space 4}{opt p95}} 95th percentile{p_end}
{synopt:{space 4}{opt p99}} 99th percentile{p_end}
{synopt:{space 4}{opt iqr}} interquartile range = {opt p75} - {opt p25}{p_end}
{synopt:{space 4}{opt q}} equivalent to specifying {cmd:p25 p50 p75}{p_end}
{space 4}{synoptline}
{p2colreset}{...}

{dlgtab:Options}

{phang}
{opt labelwidth(#)} specifies the maximum width to be used within the stub to
   display the labels of the {opt by()} variable.  The default is
   {cmd:labelwidth(16)}.  {cmd:8} {ul:<} {it:#} {ul:<} {cmd:32}.

{phang}
{opt varwidth(#)} specifies the maximum width to be used within the stub to
   display the names of the variables.  The default is
   {cmd:varwidth(12)}.  {opt varwidth()} is effective only with
   {cmd:columns(statistics)}.  Setting {opt varwidth()} implies {opt longstub}.
   {cmd:8} {ul:<} {it:#} {ul:<} {cmd:{ccl namelen}}.

{phang}
{cmd:columns(variables}|{cmd:statistics)} specifies whether to display
   variables or statistics in the columns of the table.
   {cmd:columns(variables)} is the default when more than one variable is
   specified.

{phang}
{opt format} and {cmd:format(%}{it:{help format:fmt}}{cmd:)} specify how the
   statistics are to be formatted.  The default is to use a {cmd:%9.0g}
   format.

{pmore}
   {opt format} specifies that each variable's statistics be formatted
   with the variable's display format; see {manhelp format D}.

{pmore}
   {cmd:format(%}{it:fmt}{cmd:)} specifies the format to be used for all
   statistics.  The maximum width of the specified format should not exceed
   nine characters.

{phang}
{opt casewise} specifies casewise deletion of observations.  Statistics
   are to be computed for the sample that is not missing for any of the
   variables in {varlist}.  The default is to use all the nonmissing values
   for each variable.

{phang}
{opt nototal} is for use with {opt by()}; it specifies that the overall
   statistics not be reported.

{phang}
{opt missing} specifies that missing values of the {opt by()}
   variable be treated just like any other value and that statistics should be
   displayed for them.  The default is not to report the statistics for the
   {cmd:by()==}{it:missing} group.  If the {opt by()} variable is a string
   variable, {cmd:by()==""} is considered to mean missing.

{phang}
{opt noseparator} specifies that a separator line between the {opt by()}
   categories not be displayed.

{phang}
{opt longstub} specifies that the left stub of the table be made wider
   so that it can include names of the statistics or variables in addition to
   the categories of {opth by(varname)}.  The default is to describe the
   statistics or variables in a header.  {opt longstub} is
   ignored if {opt by(varname)} is not specified.

{phang}
{opt save} specifies that the summary statistics be returned in
{opt r()}.  The overall (unconditional) statistics are returned in matrix
{cmd:r(StatTotal)} (rows are statistics, columns are variables).  The conditional
statistics are returned in the matrices {cmd:r(Stat1)}, {cmd:r(Stat2)}, ..., and
the names of the corresponding variables are returned in the macros
{cmd:r(name1)}, {cmd:r(name2)}, ....


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Show the mean (by default) of {cmd:price}, {cmd:weight}, {cmd:mpg}, and
{cmd:rep78}{p_end}
{phang2}{cmd:. tabstat price weight mpg rep78}{p_end}

{pstd}Show the mean (by default) of {cmd:price}, {cmd:weight}, {cmd:mpg}, and
{cmd:rep78} by categories of {cmd:foreign}{p_end}
{phang2}{cmd:. tabstat price weight mpg rep78, by(foreign)}{p_end}

{pstd}In addition to mean, show standard deviation, minimum, and
maximum{p_end}
{phang2}{cmd:. tabstat price weight mpg rep78, by(foreign)}
                 {cmd:stat(mean sd min max)}{p_end}

{pstd}Suppress overall statistics{p_end}
{phang2}{cmd:. tabstat price weight mpg rep78, by(foreign)}
                 {cmd:stat(mean sd min max) nototal}{p_end}

{pstd}Include names of statistics in body of table{p_end}
{phang2}{cmd:. tabstat price weight mpg rep78, by(foreign)}
                 {cmd:stat(mean sd min max) nototal long}{p_end}

{pstd}Format each variable's statistics using the variable's display
format{p_end}
{phang2}{cmd:. tabstat price weight mpg rep78, by(foreign)}
                 {cmd:stat(mean sd min max) nototal long format}{p_end}

{pstd}Show statistics horizontally and variables vertically{p_end}
{phang2}{cmd:. tabstat price weight mpg rep78, by(foreign)}
                 {cmd:stat(mean sd min max) nototal long col(stat)}{p_end}


{marker video}{...}
{title:Video example}

{phang}
{browse "http://www.youtube.com/watch?v=kKFbnEWwa2s":Descriptive statistics in Stata}
{p_end}
