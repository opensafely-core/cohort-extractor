{smcl}
{* *! version 1.4.0  12feb2019}{...}
{viewerdialog "ado update" "dialog adoupdate"}{...}
{vieweralsosee "[R] ado update" "mansection R adoupdate"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] net" "help net"}{...}
{vieweralsosee "[R] search" "help search"}{...}
{vieweralsosee "[R] ssc" "help ssc"}{...}
{vieweralsosee "[R] update" "help update"}{...}
{viewerjumpto "Syntax" "adoupdate##syntax"}{...}
{viewerjumpto "Description" "adoupdate##description"}{...}
{viewerjumpto "Links to PDF documentation" "adoupdate##linkspdf"}{...}
{viewerjumpto "Options" "adoupdate##options"}{...}
{viewerjumpto "Remarks and examples" "adoupdate##remarks"}{...}
{viewerjumpto "Stored results" "adoupdate##results"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[R] ado update} {hline 2}}Update community-contributed packages{p_end}
{p2col:}({mansection R adoupdate:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:ado update}
[{it:pkglist}]
[{cmd:,}
{it:options}]

{synoptset 10}{...}
{synopthdr}
{synoptline}
{synopt:{cmd:update}}perform update; default is to list packages that have
	updates, but not to update them{p_end}
{synopt:{cmd:all}}include packages that might have updates; default is to list
	or update only packages that are known to have updates{p_end}
{synopt:{cmdab:ssc:only}}check only packages obtained from SSC; default is to
	check all installed packages{p_end}
{synopt:{cmd:dir(}{it:dir}{cmd:)}}check packages installed in {it:dir};
	default is to check those installed in {help sysdir:PLUS}{p_end}
{synopt:{cmd:verbose}}provide output to assist in debugging network
	problems{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:ado update} checks for available updates to community-contributed packages.
To update packages, use {cmd:ado update, update}.  By default, only
packages in the {cmd:PLUS} directory are checked.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R adoupdateQuickstart:Quick start}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:update} specifies that packages with updates be updated.
    The default is simply to list the packages that could be updated
    without actually performing the update.

{pmore}
    The first time you {cmd:ado update}, do not specify this option.  Once you
    see {cmd:ado update} work, you will be more comfortable with it.  Then
    type

		. {cmd:ado update, update}

{pmore}
    The packages that can be updated will be listed and updated.

{phang}
{cmd:all} is rarely specified.  Sometimes, {cmd:ado update} cannot determine
    whether a package you previously installed has been updated.
    {cmd:ado update} can determine that the package is still available over the
    web but is unsure whether the package has changed.  Usually, the package has
    not changed, but if you want to be certain that you are using the latest
    version, reinstall from the source.

{pmore}
    Specifying {cmd:all} does this.  Typing 

		. {cmd:ado update, all}
    
{pmore}
    adds such packages to the displayed list as needing updating but
    does not update them.  Typing

		. {cmd:ado update, update all}

{pmore}
    lists such packages and updates them.
    
{phang}
{cmd:ssconly} 
    specifies that {cmd:ado update} check only packages obtained
    from the Statistical Software Components (SSC) archive at Boston College,
    which is provided at {browse "http://repec.org"}.  See {manhelp ssc R} for
    more information on the SSC.

{phang}
{cmd:dir(}{it:dir}{cmd:)}
     specifies which installed packages be checked.  The default 
     is {cmd:dir(PLUS)}, and that is probably correct.  If you are 
     responsible for maintaining a large system, however, you may 
     have previously installed packages in {cmd:dir(SITE)}, where they 
     are shared across users.  See {manhelp sysdir P} for an explanation of
     these directory codewords.  You may also specify an actual directory
     name, such as {cmd:C:\mydir}.

{phang}
{cmd:verbose} is specified when you suspect network problems.  It provides
    more detailed output that may help you diagnose the problem.


{marker remarks}{...}
{title:Remarks and examples}

{pstd}
Community-contributed additions to Stata are called packages and can add
remarkable abilities to Stata.  Community-contributed packages are updated by
their developers, just as official Stata software is updated by StataCorp.

{pstd}
Do not confuse {cmd:ado update} with {cmd:update}.  Use {cmd:ado update} to 
update community-contributed files.  Use {cmd:update} to update the components 
(including ado-files) of the official Stata software.
To use either command, you must be connected to the Internet.

{pstd}
Although Stata checks for updates automatically and can even be set to update
automatically in Stata for Windows and Stata for Mac, you must remember to 
type {cmd:ado update}.  Doing this on a regular basis can help prevent errors 
that occur when accidentally running older versions of community-contributed
packages.

{pstd}
Remarks are presented under the following headings:

	{help adoupdate##using:Using ado update}
	{help adoupdate##devnotes:Notes for developers}


{marker using}{...}
{title:Using ado update}

{pstd}
The first time you try {cmd:ado update}, type 

	. {cmd:ado update}

{pstd}
{cmd:ado update} without the {cmd:update} option produces a report but does
not update any files.  The first time you run {cmd:ado update}, you may see
messages such as 

	. {cmd:ado update}
	  (note:  package utx was installed more than once; older copy removed)
	  {it:(remaining output omitted)}

{pstd}
Having the same packages installed multiple times can lead to confusion;
{cmd:ado update} cleans that up.

{pstd}
To update all of your community-contributed packages that need updating, type

	. {cmd:ado update, update}

{pstd}
You can also update a subset of your packages.  You can specify one or many
packages after the {cmd:ado update} command.  You can even use wildcards such
as {cmd:st*} to mean all packages that start with st or {cmd:st*8} to mean all
packages that start with st and end with 8.  For example, if the report
indicated package {cmd:st0008} had an update available, type the following
to update that one package:

	. {cmd:ado update st0008, update}


{marker devnotes}{...}
{title:Notes for developers}

{pstd}
{cmd:ado update} reports whether an installed package is up to date by
comparing its distribution date with that of the package available over the
web.

{pstd}
If you are distributing software, include the line

	{cmd:d Distribution-Date:}  {it:date}

{pstd}
somewhere in your {cmd:.pkg} file.  The capitalization of
{cmd:Distribution-Date} does not matter, but include the hyphen and the colon
as shown.  Code the date in either of two formats:

	   all numeric:  {it:yyyymmdd},  for example, {cmd:20160701}

	Stata standard:  {it:ddMONyyyy}, for example, {cmd:01jul2016}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:ado update} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2:Macros}{p_end}
{synopt:{cmd:r(pkglist)}}a space-separated list of package names that need
updating ({cmd:update} not specified) or that were updated ({cmd:update}
specified){p_end}
{p2colreset}{...}
