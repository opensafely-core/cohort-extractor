{smcl}
{* *! version 1.2.5  15may2018}{...}
{vieweralsosee "[P] discard" "mansection P discard"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] clear" "help clear"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] class" "help class"}{...}
{vieweralsosee "[P] classutil" "help classutil"}{...}
{vieweralsosee "[P] Dialog programming" "help dialog_programming"}{...}
{viewerjumpto "Syntax" "discard##syntax"}{...}
{viewerjumpto "Description" "discard##description"}{...}
{viewerjumpto "Links to PDF documentation" "discard##linkspdf"}{...}
{viewerjumpto "Remarks" "discard##remarks"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[P] discard} {hline 2}}Drop automatically loaded programs{p_end}
{p2col:}({mansection P discard:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{cmd:discard}


{marker description}{...}
{title:Description}

{pstd}
{cmd:discard} drops all automatically loaded programs (see
{findalias fradowhat}); clears {cmd:e()}, {cmd:r()}, and
{cmd:s()} stored results (see {manhelp return P}); eliminates information
stored by the most recent estimation command and any other saved estimation
results (see {manhelp ereturn P}); closes any open graphs and drops all sersets
(see {manhelp serset P}); clears all class definitions and instances (see
{manhelp classutil P});
clears all business calendars (see
{bf:{help datetime_business_calendars:[D] Datetime business calendars}});
and closes all dialogs and clears their remembered
contents (see {manhelp dialog_programming P:Dialog programming}).

{pstd}
In short, {cmd:discard} causes Stata to forget everything current without
forgetting anything important, such as the data in memory.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P discardRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Use {cmd:discard} to debug ado-files.  Making a change to an ado-file
will not cause Stata to update its internal copy of the changed program.
{cmd:discard} clears all automatically loaded programs from memory, forcing
Stata to refresh its internal copies with the versions residing on disk.

{pstd}
Also all of Stata's estimation commands can display 
their previous output when the command is typed without arguments.  They achieve
this by storing information on the problem in memory. {helpb predict} calculates
various statistics (predictions, residuals, influence statistics, etc.),
{helpb estat vce} shows the covariance matrix, {helpb lincom} calculates linear
combinations of estimated coefficients, and {helpb test} and {helpb testnl}
perform hypotheses tests, all using that stored information. {cmd:discard}
eliminates that information, making it appear as if you never fit the
model.
{p_end}
