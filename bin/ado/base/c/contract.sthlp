{smcl}
{* *! version 1.1.9  19oct2017}{...}
{viewerdialog contract "dialog contract"}{...}
{vieweralsosee "[D] contract" "mansection D contract"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] collapse" "help collapse"}{...}
{vieweralsosee "[D] duplicates" "help duplicates"}{...}
{vieweralsosee "[D] expand" "help expand"}{...}
{viewerjumpto "Syntax" "contract##syntax"}{...}
{viewerjumpto "Menu" "contract##menu"}{...}
{viewerjumpto "Description" "contract##description"}{...}
{viewerjumpto "Links to PDF documentation" "contract##linkspdf"}{...}
{viewerjumpto "Options" "contract##options"}{...}
{viewerjumpto "Examples" "contract##examples"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[D] contract} {hline 2}}Make dataset of frequencies and
percentages{p_end}
{p2col:}({mansection D contract:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:contract}
{varlist}
{ifin}
[{it:{help contract##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Options}
{synopt :{opth f:req(newvar)}}name of frequency variable; default is {opt _freq}
{p_end}
{synopt :{opth cf:req(newvar)}}create cumulative frequency variable{p_end}
{synopt :{opth p:ercent(newvar)}}create percentage variable{p_end}
{synopt :{opth cp:ercent(newvar)}}create cumulative percentage variable{p_end}
{synopt :{opt float}}generate percentage variables as type {opt float}{p_end}
{synopt :{opth form:at(format)}}display format for new percentage variables;
default is {cmd:format(%8.2f)}{p_end}
{synopt :{opt z:ero}}include combinations with frequency zero{p_end}
{synopt :{opt nomiss}}drop observations with missing values{p_end}
{synoptline}
{p2colreset}{...}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s are allowed; see {help weight}.
{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Create or change data > Other variable-transformation commands}
     {bf:> Make dataset of frequencies}


{marker description}{...}
{title:Description}

{pstd}
{opt contract} replaces the dataset in memory with a new dataset consisting
of all combinations of {varlist} that exist in the data and a new
variable that contains the frequency of each combination.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D contractQuickstart:Quick start}

        {mansection D contractRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Options}

{phang}
{opth freq(newvar)} specifies a name for the frequency
variable.  If not specified, {opt _freq} is used.

{phang}
{opth cfreq(newvar)} specifies a name for the
cumulative frequency variable.  If not specified, no cumulative frequency
variable is created.

{phang}
{opth percent(newvar)} specifies a name for the percentage variable.
If not specified, no percent variable is created.

{phang}
{opth cpercent(newvar)} specifies a name for the
cumulative percentage variable.  If not specified, no cumulative percentage
variable is created.

{phang}
{opt float} specifies that the percentage variables specified by
{opt percent()} and {opt cpercent()} will be generated as variables of type
{helpb data types:float}.  If {opt float} is not specified, these variables
will be generated as variables of type {helpb double}.  All generated variables
are compressed to the smallest storage type possible without loss of
precision; see {manhelp compress D}.

{phang}
{opth format(format)} specifies a
display format for the generated percentage variables specified
by {opt percent()} and {opt cpercent()}.  If {opt format()} is not specified,
these variables will have the display format {cmd:%8.2f}.

{phang}
{opt zero} specifies that combinations with frequency zero be included.

{phang}
{opt nomiss} specifies that observations with missing values on any
variable in {varlist} be dropped.  If {opt nomiss} is not specified, all
observations possible are used.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Replace dataset with dataset containing all combinations of
{cmd:foreign} and {cmd:rep78} along with the frequency with which each
combination occurs{p_end}
{phang2}{cmd:. contract foreign rep78}{p_end}

{pstd}List the result{p_end}
{phang2}{cmd:. list}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto, clear}{p_end}

{pstd}Same as above, but include combinations that have 0 frequency{p_end}
{phang2}{cmd:. contract foreign rep78, zero}{p_end}

{pstd}List the result{p_end}
{phang2}{cmd:. list}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto, clear}{p_end}

{pstd}Same as above, but name frequency variable {cmd:count}{p_end}
{phang2}{cmd:. contract foreign rep78, zero freq(count)}{p_end}

{pstd}List the result{p_end}
{phang2}{cmd:. list}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto, clear}{p_end}

{pstd}Same as above, but drop observations with missing values{p_end}
{phang2}{cmd:. contract foreign rep78, zero freq(count) nomiss}{p_end}

{pstd}List the result{p_end}
{phang2}{cmd:. list}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto, clear}{p_end}

{pstd}Include cumulative frequency variable in dataset{p_end}
{phang2}{cmd:. contract foreign rep78, cfreq(cumfreq)}{p_end}

{pstd}List the result{p_end}
{phang2}{cmd:. list}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto, clear}{p_end}

{pstd}Same as above, but also include a percentage variable and cumulative
percentage variable in dataset{p_end}
{phang2}{cmd:. contract foreign rep78, cfreq(cumfreq) percent(percentage) cpercent(cumpercent)}{p_end}

{pstd}List the result{p_end}
{phang2}{cmd:. list, abbrev(10)}{p_end}
    {hline}
