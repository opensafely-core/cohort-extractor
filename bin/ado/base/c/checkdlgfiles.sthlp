{smcl}
{* *! version 1.0.5  29nov2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] checkhlpfiles" "help checkhlpfiles"}{...}
{viewerjumpto "Syntax" "checkdlgfiles##syntax"}{...}
{viewerjumpto "Description" "checkdlgfiles##description"}{...}
{viewerjumpto "Options" "checkdlgfiles##options"}{...}
{title:Title}

{p 4 27 2}
{hi:[P] checkdlgfiles} {hline 2} Dialog-file error checking


{marker syntax}{...}
{title:Syntax}

{p 8 22 2}
{cmd:checkdlgfiles}
{cmd:ado}
[{cmd:,}
{cmd:path(}{it:path}{cmd:)}
{cmdab:s:ystem}
]


{phang}
Also used by {cmd:checkdlgfiles} are the files

		{cmd:*.dlg}
		{cmd:*.ado}
		{cmd:cmddlg.maint}


{marker description}{...}
{title:Description}

{pstd}
{cmd:checkdlgfiles} is a tool used by StataCorp to verify that the
{cmd:*.dlg} files contain no linkage errors.


{title:Description of checkdlgfiles ado}

{pstd}
{cmd:checkdlgfiles} {cmd:ado} examines all the commands of Stata ({cmd:*.ado}
and what is added and subtracted by {cmd:cmddlg.maint}) and counts

	1.  commands that have .dlg files
	2.  commands that lack  .dlg files
	3.  unmatched .dlg files without _ in their names
	4.  unmatched .dlg files with     _ in their names

{pstd}
Detailed listings are provided for (2), (3), and (4).


{marker options}{...}
{title:Options}

{phang}
{cmd:path()} specifies the search path for locating {cmd:*.ado}, {cmd:*.dlg},
    and {cmd:*.maint} files.  The default is {cmd:path(`c(adopath)')}.

{phang}
{cmd:system} is an alternative to specifying {cmd:path()}.
Specifying {cmd:system} is equivalent to specifying
{cmd:path("BASE")}.{p_end}
