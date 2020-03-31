{smcl}
{* *! version 1.2.15  12feb2019}{...}
{viewerdialog update "dialog update"}{...}
{vieweralsosee "[R] update" "mansection R update"}{...}
{vieweralsosee "" "--"}{...}
{findalias asgsmusinginternet}{...}
{findalias asgsuusinginternet}{...}
{findalias asgswusinginternet}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ado update" "help ado update"}{...}
{vieweralsosee "[R] net" "help net"}{...}
{vieweralsosee "[R] ssc" "help ssc"}{...}
{vieweralsosee "[P] sysdir" "help sysdir"}{...}
{viewerjumpto "Syntax" "help update##syntax"}{...}
{viewerjumpto "Menu" "help update##menu"}{...}
{viewerjumpto "Description" "help update##description"}{...}
{viewerjumpto "Links to PDF documentation" "update##linkspdf"}{...}
{viewerjumpto "Options" "help update##options"}{...}
{viewerjumpto "Examples" "help update##examples"}{...}
{viewerjumpto "Stored results" "help update##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[R] update} {hline 2}}Check for official updates{p_end}
{p2col:}({mansection R update:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Report on update level of currently installed Stata

{p 8 26 2}{cmd:update}


{pstd}
Set update source

{p 8 26 2}{cmd:update from} {it:location}


{pstd}
Compare update level of currently installed Stata with that of source

{p 8 26 2}{cmd:update} {opt q:uery} [{cmd:,} {opt from(location)}]


{pstd}
Perform update if necessary

{p 8 26 2}{cmd:update all} [{cmd:,} {opt from(location)} {opt detail}
{opt force} {opt exit}]


{pstd}
Set automatic updates (Mac and Windows only)

{p 8 26 2}{opt se:t} {cmd:update_query}{space 3}{c -(}{cmd:on}|{cmd:off}{c )-}{p_end}
{p 8 26 2}{opt se:t} {cmd:update_interval} {it:#} {p_end}
{p 8 26 2}{opt se:t} {cmd:update_prompt}{space 2}{c -(}{cmd:on}|{cmd:off}{c )-}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Help > Check for updates}


{marker description}{...}
{title:Description}

{pstd}
The {opt update} command reports on the current update level and installs
official updates to Stata.  Official updates are updates to Stata as it was
originally shipped from StataCorp, not the additions to Stata published in,
for instance, the
{it:{browse "http://www.stata-journal.com":Stata Journal}} (SJ).
Those additions are installed using the {opt net} command and updated
using the {cmd:ado update} command; see {manhelp net R} and
{helpb ado update:[R] ado update}.

{phang}
{opt update} without arguments reports on the update level of the currently
installed Stata.

{phang}
{opt update from} sets an update source, which may be a directory
name or URL.  If you are on the Internet, type {cmd:update from http://www.stata.com}.

{phang}
{opt update query} compares the update level of the currently installed
Stata with that available from the update source and displays a report.

{phang}
{opt update all} updates all necessary files. This is what you
should type to check for and install updates.

{phang}
{opt set update_query} determines if {opt update query} is to be automatically
performed when Stata is launched.  Only Mac and Windows platforms can be
set for automatic updating.

{phang}
{opt set update_interval} {it:#} sets the number of days to elapse before
performing the next automatic {opt update query}.  The default {it:#} is 
7. The interval starts from the last time an {opt update query} was performed
(automatically or manually).  Only Mac and Windows platforms can be set
for automatic updating.

{phang}
{opt  set update_prompt} determines whether a dialog is to be displayed before
performing an automatic {opt update query}.  The dialog allows you to perform
an {opt update query} now, perform one the next time Stata is launched,
perform one after the next interval has passed, or disable automatic
{opt update query}.  Only Mac and Windows platforms can be set for
automatic updating.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R updateRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt from(location)} specifies the location of the update source.  You can
   specify the {opt from()} option on the individual {opt update} commands or
   use the {opt update from} command.  Which you do makes no difference.
   You typically do not need to use this option.

{phang}
{opt detail} specifies to display verbose output during the update process.

{phang}
{opt force} specifies to force downloading of all files even if, based on the
   date comparison, Stata does not think it is necessary.  There is seldom a
   reason to specify this option.

{phang}
{opt exit} instructs Stata to exit when the update has successfully 
   completed.  There is seldom a reason to specify this option.
 

{marker examples}{...}
{title:Examples}

    {cmd:. update query}   (compare what you have with update source)

    {cmd:. update all}     (update all necessary files)


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:update} without a subcommand, {cmd:update from}, and {cmd:update query} store the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(inst_exe)}}date of executable installed (*){p_end}
{synopt:{cmd:r(avbl_exe)}}date of executable available over web (*) (**){p_end}
{synopt:{cmd:r(inst_ado)}}date of ado-files installed (*){p_end}
{synopt:{cmd:r(avbl_ado)}}date of ado-files available over web (*) (**){p_end}
{synopt:{cmd:r(inst_utilities)}}date of utilities installed (*){p_end}
{synopt:{cmd:r(avbl_utilities)}}date of utilities available over web (*) (**)
{p_end}
{synopt:{cmd:r(inst_docs)}}date of documentation installed (*){p_end}
{synopt:{cmd:r(avbl_docs)}}date of documentation available over web (*) (**)
{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(name_exe)}}name of the Stata executable{p_end}
{synopt:{cmd:r(dir_exe)}}directory in which executable is stored{p_end}
{synopt:{cmd:r(dir_ado)}}directory in which ado-files are stored{p_end}
{synopt:{cmd:r(dir_utilities)}}directory in which utilities are stored{p_end}
{synopt:{cmd:r(dir_docs)}}directory in which PDF documentation is stored{p_end}

{pstd}
Notes:

{p 5 7 2}
  * Dates are stored as integers counting the number of days since January 1,
    1960; see {manhelp Datetime D}.

{p 4 7 2}
 ** These dates are not stored by {cmd:update} without a subcommand because
    {cmd:update} by itself reports information solely about the local computer
    and does not check what is available on the web.{p_end}
{p2colreset}{...}
