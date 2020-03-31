{smcl}
{* *! version 1.0.0  28apr2019}{...}
{viewerdialog cmsummarize "dialog cmsummarize"}{...}
{vieweralsosee "[CM] cmsummarize" "mansection CM cmsummarize"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[CM] cmchoiceset" "help cmchoiceset"}{...}
{vieweralsosee "[CM] cmsample" "help cmsample"}{...}
{vieweralsosee "[CM] cmset" "help cmset"}{...}
{vieweralsosee "[CM] cmtab" "help cmtab"}{...}
{viewerjumpto "Syntax" "cmsummarize##syntax"}{...}
{viewerjumpto "Menu" "cmsummarize##menu"}{...}
{viewerjumpto "Description" "cmsummarize##description"}{...}
{viewerjumpto "Links to PDF documentation" "cmsummarize##linkspdf"}{...}
{viewerjumpto "Options" "cmsummarize##options"}{...}
{viewerjumpto "Examples" "cmsummarize##examples"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[CM] cmsummarize} {hline 2}}Summarize variables by chosen
alternatives{p_end}
{p2col:}({mansection CM cmsummarize:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:cmsummarize}
{varlist} {ifin}
[{help cmsummarize##weight:{it:weight}}]{cmd:,}
{opt choice(choicevar)}
[{it:options}]

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{p2coldent:* {opt choice(choicevar)}}specify 0/1 variable indicating the
chosen alternatives{p_end}
{synopt :{cmdab:s:tatistics(}{help cmsummarize##statname:{it:statname}}[...]{cmd:)}}report
specified statistics{p_end}
{synopt :{opt altwise}}use alternativewise deletion instead of casewise
deletion{p_end}

{syntab:Reporting}
{synopt :{cmdab:f:ormat}[{cmd:(}{help format:{bf:%}{it:fmt}}{cmd:)}]}display format for statistics; default
format is {cmd:%9.0g}{p_end}
{synopt :{opt lo:ngstub}}put key for statistics (or variable names) on left
table stub{p_end}
{synopt :{opt time}}group by time variable (only for panel CM
data){p_end}
{synopt :{cmdab:c:olumns(}{cmdab:v:ariables}{cmd:)}}display variables in table
columns; the default{p_end}
{synopt :{cmdab:c:olumns(}{cmdab:s:tatistics}{cmd:)}}display statistics in
table columns{p_end}
{synoptline}
{p 4 6 2}
* {cmd:choice()} is required.{p_end}
{p 4 6 2}
You must {cmd:cmset} your data before using {cmd:cmsummarize}; see
{manhelp cmset CM}.{p_end}
{p 4 6 2}
{cmd:by} is allowed; see {manhelp by D}.{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s are allowed; see {help weight}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Choice models > Setup and utilities > Summarize variables by chosen alternatives}


{marker description}{...}
{title:Description}

{pstd}
{cmd:cmsummarize} calculates summary statistics for one or more variables 
grouped by chosen alternatives.

{pstd}
For panel choice data, {cmd:cmsummarize} calculates summary
statistics grouped by chosen alternatives and by time.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection CM cmsummarizeQuickstart:Quick start}

        {mansection CM cmsummarizeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt choice(choicevar)} specifies the variable indicating the chosen
alternative.  {it:choicevar} must be coded as 0 and 1, with 0 indicating an
alternative that was not chosen and 1 indicating the chosen alternative.
{cmd:choice()} is required.

{phang}
{opt statistics(statname [...])} specifies the statistics to be displayed; the
default is equivalent to specifying {cmd:statistics(mean)}.  ({cmd:stats()} is
a synonym for {cmd:statistics()}.)  Multiple statistics may be specified and
are separated by white space, such as {cmd:statistics(mean sd)}.  Available
statistics are

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

{phang}
{cmd:altwise} specifies that alternativewise deletion be used when omitting
observations because of missing values in your variables.  The default is to
use casewise deletion; that is, the entire group of observations making up a
case is omitted if any missing values are encountered.  This option does not
apply to observations that are excluded by the {cmd:if} or {cmd:in} qualifier
or the {cmd:by} prefix; these observations are always handled alternativewise
regardless of whether {cmd:altwise} is specified.

{dlgtab:Reporting}

{phang}
{cmd:format} and {opth format(%fmt)} specify how the statistics are to
be formatted.  The default is to use a {cmd:%9.0g} format.

{phang2}
{cmd:format} specifies that each variable's statistics be formatted
with the variable's display format; see {manhelp format D}.

{phang2}
{opt format(%fmt)} specifies the format to be used for all statistics.  The
maximum width of the specified format should not exceed nine characters.

{phang}
{cmd:longstub} specifies that the left stub of the table be made wider so that
it can include names of the statistics (or variable names when
{cmd:columns(statistics)} is specified) in addition to the categories of the
alternatives.  The default is to display the names of the statistics (or
variable names) in a header.

{phang}
{cmd:time} groups the statistics by values of the time variable when data are
panel choice data.  See {manhelp cmset CM}.

{phang}
{cmd:columns(variables {c |} statistics)} specifies whether to display
variables or statistics in the columns of the table.
{cmd:columns(variables)} is the default when more than one variable is
specified.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse carchoice}{p_end}
{phang2}{cmd:. cmset consumerid car}{p_end}

{pstd}Compute the mean of {cmd:income} by the nationality of car purchased{p_end}
{phang2}{cmd:. cmsummarize income, choice(purchase)}{p_end}

{pstd}Same as above, but also display the group sample size and the minimum,
mean, and maximum of the variables {cmd:gender}, {cmd:income}, and
{cmd:dealers}{p_end}
{phang2}{cmd:. cmsummarize gender income dealers, choice(purchase) statistics(N min mean max)}{p_end}
