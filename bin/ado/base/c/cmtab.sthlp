{smcl}
{* *! version 1.0.0  29apr2019}{...}
{viewerdialog cmtab "dialog cmtab"}{...}
{vieweralsosee "[CM] cmtab" "mansection CM cmtab"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[CM] cmchoiceset" "help cmchoiceset"}{...}
{vieweralsosee "[CM] cmsample" "help cmsample"}{...}
{vieweralsosee "[CM] cmset" "help cmset"}{...}
{vieweralsosee "[CM] cmsummarize" "help cmsummarize"}{...}
{viewerjumpto "Syntax" "cmtab##syntax"}{...}
{viewerjumpto "Menu" "cmtab##menu"}{...}
{viewerjumpto "Description" "cmtab##description"}{...}
{viewerjumpto "Links to PDF documentation" "cmtab##linkspdf"}{...}
{viewerjumpto "Options" "cmtab##options"}{...}
{viewerjumpto "Examples" "cmtab##examples"}{...}
{viewerjumpto "Stored results" "cmtab##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[CM] cmtab} {hline 2}}Tabulate chosen alternatives{p_end}
{p2col:}({mansection CM cmtab:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:cmtab}
[{varname}] {ifin}
[{help cmtab##weight:{it:weight}}]{cmd:,}
{opt choice(choicevar)}
[{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{p2coldent:* {opt choice(choicevar)}}specify 0/1 variable indicating the
chosen alternative{p_end}
{synopt :{opt miss:ing}}include missing values of {it:varname} in
tabulation{p_end}
{synopt :{opt trans:pose}}transpose rows and columns in tables{p_end}
{synopt :{opt time}}tabulate by time variable (only for panel CM data){p_end}
{synopt :{opt timelast}}put time variable last in three-way tabulation;
tabulate alternatives by time for each level of {it:varname} (only for panel
CM data){p_end}
{synopt :{opt comp:act}}display three-way tabulation compactly (only for panel
CM data){p_end}
{synopt :{opt altwise}}use alternativewise deletion instead of casewise
deletion{p_end}

{syntab:Options}
{synopt :{it:tab1_options}}options for one-way tables{p_end}
{synopt :{it:tab2_options}}options for two-way tables{p_end}
{synoptline}
{p 4 6 2}
* {cmd:choice()} is required.{p_end}

{synoptset 20}{...}
{synopthdr:tab1_options}
{synoptline}
{synopt :{opt sort}}display table in descending order of frequency{p_end}
{synoptline}

{synopthdr:tab2_options}
{synoptline}
{synopt :{opt ch:i2}}report Pearson's chi-squared{p_end}
{synopt :{opt lr:chi2}}report likelihood-ratio chi-squared{p_end}
{synopt :{opt co:lumn}}report column percentages{p_end}
{synopt :{opt r:ow}}report row percentages{p_end}
{synopt :{opt ce:ll}}report cell percentages{p_end}
{synopt :{opt rowsort}}list rows in order of observed frequency{p_end}
{synopt :{opt colsort}}list columns in order of observed frequency{p_end}
{synopt :[{cmd:no}]{cmd:key}}report or suppress cell contents key{p_end}
{synoptline}
{p2colreset}{...}

{p 4 6 2}
You must {cmd:cmset} your data before using {cmd:cmtab}; see
{manhelp cmset CM}.{p_end}
{p 4 6 2}
{cmd:by} is allowed; see {manhelp by D}.{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s and {cmd:iweight}s are allowed; see {help weight}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Choice models > Setup and utilities > Tabulate chosen alternatives}


{marker description}{...}
{title:Description}

{pstd}
{cmd:cmtab} tabulates chosen alternatives, either alone in a one-way 
tabulation or versus another variable in a two-way tabulation.

{pstd}
For panel choice data, {cmd:cmtab} can display a two-way tabulation
of chosen alternatives by time or a three-way tabulation of
time by chosen alternative by another variable.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection CM cmtabQuickstart:Quick start}

        {mansection CM cmtabRemarksandexamples:Remarks and examples}

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
{opt missing} specifies that the missing values of {it:varname} are to be
treated like any other value of {it:varname}.

{phang}
{cmd:transpose} transposes rows and columns in the tabular displays.

{phang}
{cmd:time} tabulates the chosen alternative versus the time variable when 
data are panel choice data.  See {manhelp cmset CM}.

{phang}
{cmd:timelast} puts time last in a three-way tabulation when data are panel
choice data.  Three-way tabulations are created when {it:varname} is specified
as well as the option {cmd:time}.  By default, the three-way tabulation is
{it:timevar} x chosen alternative x {it:varname}; that is, for each value of
{it:timevar}, a two-way table of chosen alternative versus {it:varname} is
displayed.  When {cmd:timelast} is specified, the three-way tabulation is
{it:varname} x chosen alternative x {it:timevar}; that is, for each value of
{it:varname}, a two-way table of chosen alternative versus {it:timevar} is
displayed.  To reverse the order of the two-way tabulations, you can use the
option {cmd:transpose}.
 
{phang} {cmd:compact} creates a compact three-way tabulation when data are
panel choice data.

{phang}
{cmd:altwise} specifies that alternativewise deletion be used when omitting
observations because of missing values in your variables.  The default is to
use casewise deletion; that is, the entire group of observations making up a
case is omitted if any missing values are encountered.  This option does not
apply to observations that are excluded by the {cmd:if} or {cmd:in} qualifier
or the {cmd:by} prefix; these observations are always handled alternativewise
regardless of whether {cmd:altwise} is specified.

{dlgtab:Options}

{phang}
{cmd:sort} puts the table in descending order of frequency in a one-way table.

{phang}
{cmd:chi2} calculates and displays Pearson's chi-squared for the hypothesis that
the rows and columns in a two-way table are independent.
{cmd:chi2} may not be specified if {cmd:iweight}s are used.
{cmd:chi2} is not available when {cmd:compact} is specified.

{phang}
{cmd:lrchi2} displays the likelihood-ratio chi-squared statistic for a two-way
table.  {cmd:lrchi2} may not be specified if {cmd:iweight}s are used.
{cmd:lrchi2} is not available when {cmd:compact} is specified.

{phang}
{cmd:column} displays the relative frequency, as a percentage, of each cell
within its column in a two-way table.  {cmd:column} is not available when
{cmd:compact} is specified.

{phang}
{cmd:row} displays the relative frequency, as a percentage, of each cell
within its row in a two-way table.  {cmd:row} is not available when
{cmd:compact} is specified.

{phang}
{cmd:cell} displays the relative frequency, as a percentage, of each cell in a
two-way table.  {cmd:cell} is not available when {cmd:compact} is specified.

{phang}
{cmd:rowsort} and {cmd:colsort} specify that the rows and columns,
respectively, be presented in order of observed frequency in a two-way table.
{cmd:rowsort} and {cmd:colsort} are not available when {cmd:compact} is
specified.

{phang}
[{cmd:no}]{cmd:key} displays or suppresses a key above two-way tables.  The
default is to display the key if more than one cell statistic is requested.
{cmd:key} displays the key.  {cmd:nokey} suppresses its display.
[{cmd:no}]{cmd:key} is not available when {cmd:compact} is specified.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse carchoice}{p_end}
{phang2}{cmd:. cmset consumerid car}{p_end}

{pstd}Show a one-way tabulation of the chosen alternatives{p_end}
{phang2}{cmd:. cmtab, choice(purchase)}{p_end}

{pstd}Show a two-way tabulation of {cmd:gender} by chosen alternative{p_end}
{phang2}{cmd:. cmtab gender, choice(purchase)}{p_end}

{pstd}Same as above, and report row percentages and a p-value for the
association of {cmd:gender} with choice of car{p_end}
{phang2}{cmd:. cmtab gender, choice(purchase) row chi2}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:cmtab} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt :{cmd:r(N)}}number of observations{p_end}
{synopt :{cmd:r(r)}}number of rows{p_end}
{synopt :{cmd:r(c)}}number of columns{p_end}
{synopt :{cmd:r(chi2)}}Pearson's chi-squared{p_end}
{synopt :{cmd:r(p)}}p-value for Pearson's chi-squared test{p_end}
{synopt :{cmd:r(chi2_lr)}}likelihood-ratio chi-squared{p_end}
{synopt :{cmd:r(p_lr)}}p-value for likelihood-ratio test{p_end}
{p2colreset}{...}
