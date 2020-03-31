{smcl}
{* *! version 1.0.0  30apr2019}{...}
{viewerdialog cmchoiceset "dialog cmchoiceset"}{...}
{vieweralsosee "[CM] cmchoiceset" "mansection CM cmchoiceset"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[CM] cmsample" "help cmsample"}{...}
{vieweralsosee "[CM] cmset" "help cmset"}{...}
{vieweralsosee "[CM] cmsummarize" "help cmsummarize"}{...}
{vieweralsosee "[CM] cmtab" "help cmtab"}{...}
{viewerjumpto "Syntax" "cmchoiceset##syntax"}{...}
{viewerjumpto "Menu" "cmchoiceset##menu"}{...}
{viewerjumpto "Description" "cmchoiceset##description"}{...}
{viewerjumpto "Links to PDF documentation" "cmchoiceset##linkspdf"}{...}
{viewerjumpto "Options" "cmchoiceset##options"}{...}
{viewerjumpto "Examples" "cmchoiceset##examples"}{...}
{viewerjumpto "Stored results" "cmchoiceset##results"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[CM] cmchoiceset} {hline 2}}Tabulate choice sets{p_end}
{p2col:}({mansection CM cmchoiceset:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:cmchoiceset}
[{varname}] {ifin}
[{cmd:,} {it:options}]

{synoptset 23 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{opt size}}tabulate size of choice sets{p_end}
{synopt :{opt obs:ervations}}tabulate by observations, not cases; the
default{p_end}
{synopt :{opt altwise}}use alternativewise deletion instead of casewise
deletion{p_end}
{synopt :{opt trans:pose}}transpose rows and columns in two-way tables{p_end}
{synopt :{opt miss:ing}}include missing values of {it:varname} in
tabulation{p_end}
{synopt :{opt time}}tabulate choice sets versus time variable (only for panel
CM data){p_end}
{synopt :{opth gen:erate(cmchoiceset##opt_generate:newvar,...)}}create new
variable containing categories for the choice-set patterns{p_end}

{syntab:Options}
{synopt :{it:tab1_options}}options for one-way tables{p_end}
{synopt :{it:tab2_options}}options for two-way tables{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 23}{...}
{synopthdr:tab1_options}
{synoptline}
{synopt :{opt sort}}display table in descending order of frequency{p_end}
{synoptline}

{synopthdr:tab2_options}
{synoptline}
{synopt :{opt co:lumn}}report column percentages{p_end}
{synopt :{opt r:ow}}report row percentages{p_end}
{synopt :{opt ce:ll}}report cell percentages{p_end}
{synopt :{opt rowsort}}list rows in order of observed frequency{p_end}
{synopt :{opt colsort}}list columns in order of observed frequency{p_end}
{synopt :[{cmd:no}]{opt key}}report or suppress cell contents key{p_end}
{synoptline}
{p2colreset}{...}

{p 4 6 2}
You must {cmd:cmset} your data before using {cmd:cmchoiceset}; see
{manhelp cmset CM}.{p_end}
{p 4 6 2}
{opt by} is allowed; see {manhelp by D}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Choice models > Setup and utilities > Tabulate choice sets}


{marker description}{...}
{title:Description}

{pstd}
{cmd:cmchoiceset} tabulates choice sets for choice data.  It is useful when
choice sets are unbalanced, that is, when alternatives are not the same for
every case.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection CM cmchoicesetQuickstart:Quick start}

        {mansection CM cmchoicesetRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:size} tabulates the size of the choice sets rather than the choice-set
patterns.

{phang}
{cmd:observations} specifies that the tabulation be done by observations
instead of by cases, which is the default.  If {it:varname} is specified and
{it:varname} is a case-specific variable (values constant within case), a
tabulation of choice sets versus {it:varname} by cases is displayed by
default.  If {it:varname} is not a case-specific variable, a tabulation by
cases cannot be produced, so the option {cmd:observations} must be specified;
otherwise, an error message is given.

{phang}
{cmd:altwise} specifies that alternativewise deletion be used when omitting
observations because of missing values in the alternatives variable or
{it:varname}.  The default is to use casewise deletion; that is, the entire
group of observations making up a case is omitted if any missing values are
encountered.  This option does not apply to observations that are excluded by
the {cmd:if} or {cmd:in} qualifier or the {cmd:by} prefix; these observations
are always handled alternativewise regardless of whether {cmd:altwise} is
specified.

{phang}
{cmd:transpose} transposes rows and columns in displays of two-way tables.

{phang}
{cmd:missing} specifies that the missing values of {it:varname} be
treated like any other value of {it:varname}.

{phang}
{cmd:time} tabulates choice sets versus the time variable when data are panel
choice data.  See {manhelp cmset CM}.

{marker opt_generate}{...}
{phang}
{cmd:generate(}{newvar}[{cmd:, replace} {opt label(lblname)}]{cmd:)}
creates a new variable containing categories for the choice-set patterns.
The variable {it:newvar} is numeric and valued 1, 2, ....  Its value label
contains the choice-set patterns as strings.  If option {cmd:size} was
specified, then {it:newvar} contains the sizes of the choice sets.

{phang2}
{cmd:replace} allows any existing variable named {it:newvar} to be replaced.

{phang2}
{opt label(lblname)} specifies the name of the {help label:value label}
created when {opt generate(newvar)} is specified.  By default, the variable
name {it:newvar} is also used for the name of the value label.

{dlgtab:Options}

{phang}
{opt sort} puts the table in descending order of frequency in a one-way table.

{phang}
{opt column} displays the relative frequency, as a percentage, of each cell 
within its column in a two-way table.

{phang}
{opt row} displays the relative frequency, as a percentage, of each cell 
within its row in a two-way table.

{phang}
{opt cell} displays the relative frequency, as a percentage, of each cell 
in a two-way table.

{phang}
{opt rowsort} and {opt colsort} specify that the rows and columns,
respectively, be presented in order of observed frequency in a two-way
table.

{phang}
[{cmd:no}]{cmd:key} displays or suppresses a key above two-way tables.
The default is to display the key if more than one cell statistic is
requested.  {cmd:key} displays the key.  {cmd:nokey} suppresses its display.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse carchoice}{p_end}
{phang2}{cmd:. cmset consumerid car}{p_end}

{pstd}Tabulate the choice sets{p_end}
{phang2}{cmd:. cmchoiceset}{p_end}

{pstd}Report number of observations rather number of cases{p_end}
{phang2}{cmd:. cmchoiceset, observations}{p_end}

{pstd}Tabulate choice sets by {cmd:gender}, which is a case-specific
variable{p_end}
{phang2}{cmd:. cmchoiceset gender}{p_end}

{pstd}Same as above, but omit cases with missing values {cmd:gender}{p_end}
{phang2}{cmd:. cmchoiceset gender, altwise}{p_end}

{pstd}Same as above, but omit only observations with missing values of
{cmd:gender} rather than entire cases{p_end}
{phang2}{cmd:. cmchoiceset gender, missing observations}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:cmchoiceset} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt :{cmd:r(N)}}number of observations{p_end}
{synopt :{cmd:r(r)}}number of rows{p_end}
{synopt :{cmd:r(c)}}number of columns{p_end}
{p2colreset}{...}
