{smcl}
{* *! version 1.1.8  19oct2017}{...}
{vieweralsosee "[P] tabdisp" "mansection P tabdisp"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] collapse" "help collapse"}{...}
{vieweralsosee "[R] table" "help table"}{...}
{vieweralsosee "[R] tabstat" "help tabstat"}{...}
{vieweralsosee "[R] tabulate oneway" "help tabulate_oneway"}{...}
{vieweralsosee "[R] tabulate, summarize()" "help tabulate_summarize"}{...}
{vieweralsosee "[R] tabulate twoway" "help tabulate_twoway"}{...}
{viewerjumpto "Syntax" "tabdisp##syntax"}{...}
{viewerjumpto "Description" "tabdisp##description"}{...}
{viewerjumpto "Links to PDF documentation" "tabdisp##linkspdf"}{...}
{viewerjumpto "Options" "tabdisp##options"}{...}
{viewerjumpto "Examples" "tabdisp##examples"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[P] tabdisp} {hline 2}}Display tables{p_end}
{p2col:}({mansection P tabdisp:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:tabdisp} {it:rowvar} [{it:colvar} [{it:supercolvar}]]
{ifin}{cmd:,}
{cmdab:c:ellvar:(}{it:{help varname:varnames}}{cmd:)} [{cmd:by(}{it:superrowvars}{cmd:)}
{opth f:ormat(%fmt)} {cmdab:cen:ter} {cmdab:l:eft}
{cmdab:con:cise} {cmdab:m:issing} {cmdab:t:otals} {cmd:dotz}
{cmdab:cellw:idth:(}{it:#}{cmd:)} {cmdab:csep:width:(}{it:#}{cmd:)}
{cmdab:scsep:width:(}{it:#}{cmd:)} {cmdab:stubw:idth:(}{it:#}{cmd:)}]

{phang}
{cmd:by} is allowed; see {manhelp by D}.

{pstd}
{it:rowvar}, {it:colvar}, and {it:supercolvar} may be numeric or string
variables.


{marker description}{...}
{title:Description}

{pstd}
{cmd:tabdisp} displays data in a table.  {cmd:tabdisp}
calculates no statistics and is intended for use by programmers.

{pstd}
For the corresponding command that calculates statistics and displays them
in a table, see {manhelp table R}.

{pstd}
Although {cmd:tabdisp} is intended for programming applications, it can be
used interactively for listing data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P tabdispRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}{cmd:cellvar(}{it:{help varname:varnames}}{cmd:)} is required; it
specifies the numeric or string variables containing the values to be displayed
in the table's cells.  Up to five variable names may be specified.

{phang}{cmd:by(}{it:superrowvars}{cmd:)} specifies numeric or string
variables to be treated as {it:superrows}.  Up to four variables may be
specified.

{phang}{opth format(%fmt)} specifies the display format for
presenting numbers in the table's cells.  {cmd:format(%9.0g)} is the default;
{cmd:format(%9.2f)} is a popular alternative.  The width of the format you
specify does not matter, except that {cmd:%}{it:fmt} must be valid.  The width
of the cells is chosen by {cmd:tabdisp} to be what it thinks looks best.  The 
{cmd:cellwidth()} option allows you to override {cmd:tabdisp}'s choice.

{phang}{cmd:center} specifies that results be centered in the table's cells.
The default is to right-align results.  For centering to work well, you 
typically need to specify a display format as well. {cmd:center format(%9.2f)}
is popular.

{phang}{cmd:left} specifies that column labels be left-aligned.  The
default is to right-align column labels to distinguish them from supercolumn
labels, which are left-aligned.  If you specify {cmd:left}, both column
and supercolumn labels are left-aligned.

{phang}{cmd:concise} specifies that rows with all missing entries not 
be displayed.

{phang}{cmd:missing} specifies that, in cells containing missing values, the
missing value ({cmd:.}, {cmd:.a}, {cmd:.b}, ..., or {cmd:.z}) be
displayed.  The default is that cells with missing values are left blank.

{phang}{cmd:totals} specifies that observations where {it:rowvar},
{it:colvar}, {it:supercolvar}, or {it:superrowvars} contain the system
missing value ({cmd:.}) be interpreted as containing the corresponding
totals of {cmd:cellvar()}, and that the table be labeled accordingly.
If {cmd:dotz} option is also specified, observations where the stub
variables contain {cmd:.z} will be thus interpreted.

{phang}{cmd:dotz} specifies that the roles of missing values {cmd:.} and
{cmd:.z} be interchanged in labeling the stubs of the table.  By
default, if any of {it:rowvar}, {it:colvar}, {it:supercolvar}, and
{it:superrowvars} contains missing ({cmd:.}, {cmd:.a}, {cmd:.b}, ..., or
{cmd:.z}), then "{cmd:.}" is placed last in the ordering.  {cmd:dotz}
specifies that {cmd:.z} be placed last.  Also, if option
{cmd:totals} is specified, {cmd:.z} values rather than "{cmd:.}" values
will be labeled "Total".

{phang}{cmd:cellwidth(}{it:#}{cmd:)} specifies the width of the cell in units
of digit widths; 10 means the space occupied by 10 digits, which is
0123456789.  The default {cmd:cellwidth()} is not a fixed number but rather a
number chosen by {cmd:tabdisp} to spread the table out while presenting a
reasonable number of columns across the page.

{phang}{cmd:csepwidth(}{it:#}{cmd:)} specifies the separation between columns
in units of digit widths.  The default is not a fixed number but rather a
number chosen by {cmd:tabdisp} according to what it thinks looks best.

{phang}{cmd:scsepwidth(}{it:#}{cmd:)} specifies the separation between
supercolumns in units of digit widths.  The default is not a fixed number but
rather a number chosen by {cmd:tabdisp} according to what it thinks looks best.

{phang}{cmd:stubwidth(}{it:#}{cmd:)} specifies the width, in units of digit
widths, to be allocated to the left stub of the table.  The default is not a
fixed number but rather a number chosen by {cmd:tabdisp} according to what it
thinks looks best.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse tabdxmpl1}

{pstd}List the data{p_end}
{phang2}{cmd:. list}

{pstd}List the data using {cmd:tabdisp}{p_end}
{phang2}{cmd:. tabdisp a b, cell(c)}

{pstd}Drop observation 6{p_end}
{phang2}{cmd:. drop in 6}

{pstd}List the data using {cmd:tabdisp}{p_end}
{phang2}{cmd:. tabdisp a b, cell(c)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto2, clear}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list make mpg weight displ rep78 in 1/10}

{pstd}List some of the data using {cmd:tabdisp}{p_end}
{phang2}{cmd:. tabdisp make, cell(mpg weight displ rep78)}

{pstd}Make dataset of means of {cmd:mpg} by categories of {cmd:foreign} and
{cmd:rep78}{p_end}
{phang2}{cmd:. collapse (mean) mpg, by(foreign rep78)}

{pstd}List the data{p_end}
{phang2}{cmd:. list}

{pstd}List the data using {cmd:tabdisp}{p_end}
{phang2}{cmd:. tabdisp foreign rep78, cell(mpg)}

{pstd}Drop observations having a missing value for {cmd:rep78}{p_end}
{phang2}{cmd:. drop if rep78 >= .}

{pstd}List the data using {cmd:tabdisp} with a format of {cmd:%9.2f} and
centering results in the cells{p_end}
{phang2}{cmd:. tabdisp foreign rep78, cell(mpg) format(%9.2f) center}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse tabdxmpl3, clear}

{pstd}List the data, which consists of all string variables, using
{cmd:tabdisp}{p_end}
{phang2}{cmd:. tabdisp agecat sex party, c(reaction) center}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse tabdxmpl4}

{pstd}List the data{p_end}
{phang2}{cmd:. list}

{pstd}List the data using {cmd:tabdisp}{p_end}
{phang2}{cmd:. tabdisp sex response, cell(pop)}

{pstd}List the data using {cmd:tabdisp}, requesting that missing values be
displayed{p_end}
{phang2}{cmd:. tabdisp sex response, cell(pop) missing}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse tabdxmpl5}

{pstd}List the data{p_end}
{phang2}{cmd:. list}

{pstd}List the data using {cmd:tabdisp}{p_end}
{phang2}{cmd:. tabdisp sex response, cell(pop)}

{pstd}List the data using {cmd:tabdisp}, labeling the system missing values as
totals{p_end}
{phang2}{cmd:. tabdisp sex response, cell(pop) total}{p_end}
    {hline}
