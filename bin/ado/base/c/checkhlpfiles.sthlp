{smcl}
{* *! version 1.2.1  29nov2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] checkdlgfiles" "help checkdlgfiles"}{...}
{vieweralsosee "[P] smcl" "help smcl"}{...}
{vieweralsosee "[P] sysdir" "help sysdir"}{...}
{vieweralsosee "contents" "help contents"}{...}
{viewerjumpto "Syntax" "checkhlpfiles##syntax"}{...}
{viewerjumpto "Description" "checkhlpfiles##description"}{...}
{viewerjumpto "Options" "checkhlpfiles##options"}{...}
{title:Title}

{p 4 27 2}
{hi:[P] checkhlpfiles} {hline 2} Help-file error checking


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:check_help}

{p 8 16 2}
{cmd:checkhlpfiles}
{cmd:stata}
[{cmd:,}
{cmd:path(}{it:path}{cmd:)}
{cmdab:s:ystem}
]

{p 8 16 2}
{cmd:checkhlpfiles}
{cmd:doublebang}
[{cmd:,}
{cmd:path(}{it:path}{cmd:)}
{cmdab:s:ystem}
]

{pstd}
The following subcommand is partially deprecated; see {cmd:check_help} above.

{p 8 16 2}
{cmd:checkhlpfiles}
{cmd:help}
[{cmd:,}
{cmd:path(}{it:path}{cmd:)}
{cmdab:s:ystem}
]

{pstd}
The following subcommand is mostly deprecated; see {cmd:check_help} above.

{p 8 16 2}
{cmd:checkhlpfiles}
{cmd:dialog}
[{cmd:,}
{cmd:path(}{it:path}{cmd:)}
{cmdab:s:ystem}
]


{phang}
Also used by {cmd:check_help} and {cmd:checkhlpfiles} are the files

		{cmd:*.sthlp}
		{cmd:*.ihlp}
		{cmd:*.hlp}		(if any)
		{cmd:*.dlg}
		{cmd:hlpnotused.maint}
		{cmd:validpdflinks.maint}

		{cmd:ahelp_alias.maint}
		{cmd:bhelp_alias.maint}
		...
		{cmd:zhelp_alias.maint}

		{cmd:fsmcl_alias.maint}
		{cmd:gsmcl_alias.maint} (etc)

{phang}
You must be using {help statamp:Stata/MP} or {help SpecialEdition:Stata/SE}
to use {cmd:checkhlpfiles}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:check_help} and {cmd:checkhlpfiles} are tools used
by StataCorp to verify that the {cmd:*.sthlp} files contain no linkage errors.


{title:Description of check_help}

{pstd}
{cmd:check_help} checks all files ending in {cmd:.sthlp} and {cmd:.ihlp} that
are found in the BASE system directory (see {helpb sysdir}) for
broken help file links from {helpb smcl} directives {cmd:help}, {cmd:helpb},
{cmd:manhelp}, {cmd:manhelpi}, {cmd:opth}, {cmd:vieweralsosee}, and
{cmd:viewerjumpto}.  It also checks for broken manual links from {helpb smcl}
directives {cmd:mansection}, {cmd:manlink}, {cmd:manlinki}, {cmd:findalias},
and {cmd:vieweralsosee}.


{title:Description of checkhlpfiles dialog}

{pstd}
{cmd:checkhlpfiles} {cmd:dialog} examines all the
{cmd:{c -(}dialog }...{cmd:{c )-}} links in the help files
({cmd:.sthlp}, {cmd:.hlp}, and {cmd:.ihlp} files).  Any broken links
are reported; along with the lists of dialogs referred to that do not
exist and dialogs not referred to that do exist.


{title:Description of checkhlpfiles stata}

{pstd}
{cmd:checkhlpfiles} {cmd:stata} examines all the
{cmd:{c -(}stata} ...{cmd:{c )-}} links in the help files
({cmd:.sthlp}, {cmd:.hlp}, and {cmd:.ihlp} files). 
Any files containing invalid Stata commands (as determined by {helpb which})
are listed and two lists are produced:  commands used but that do not
exist and commands used that exist.


{title:Description of checkhlpfiles doublebang}

{pstd}
{cmd:checkhlpfiles} {cmd:doublebang} examines all {cmd:*.sthlp}, {cmd:*.hlp},
{cmd:*.ihlp}, and {cmd:*.maint}
files and lists the names of those that have lines containing two exclamation
points, one next to the other, that is, ! followed by !.  StataCorp uses
"doublebangs" to flag problems.


{title:Description of checkhlpfiles help (partially deprecated)}

{pstd}
For {cmd:checkhlpfiles help}, the help files are divided into two classes called
"base help files" and "contents help files".  The "contents" help files are
those that make up the hierarchy of help files whose root is contents.sthlp.
All of these files (except contents.sthlp) have names beginning with
"contents_".  All other help files are "base".

{pstd}
{cmd:checkhlpfiles} {cmd:help} examines all the
{cmd:{c -(}help }...{cmd:{c )-}},
{cmd:{c -(}helpb }...{cmd:{c )-}},
{cmd:{c -(}manhelp }...{cmd:{c )-}},
{cmd:{c -(}manhelpi }...{cmd:{c )-}}, and
{cmd:{c -(}opth }...{cmd:{c )-}},
links in the help files ({cmd:.sthlp}, {cmd:.hlp},
and {cmd:.ihlp} files).  In the
explanations below, we mention only {cmd:{c -(}help }...{cmd:{c )-}}, but the
comments apply to the other help link smcl directives as well.  Any broken
links are reported, along with the following lists:

{phang2}
	{bf:leaves}{break}
	Help files that contain no 
	{cmd:{c -(}help }...{cmd:{c )-}} links.

{phang2}
	{bf:From base help files:  referenced but do not exist}{break}
	{cmd:{c -(}help }...{cmd:{c )-}} linkages to nonexisting help files
	among all non {cmd:contents*.sthlp} help files.

{phang2}
	{bf:From base help files:  exist but not referenced}{break}
	Help files that exist but are not referenced among all non
	{cmd:contents*.sthlp} help files, with the removal of the names listed
	in file {cmd:hlpnotused.maint}.

{phang2}
	{bf:From base help files:  referenced but should not be}{break}
	{cmd:{c -(}help }...{cmd:{c )-}} linkages
        from non {cmd:contents*.sthlp} files to help files that are listed in
        file {cmd:hlpnotused.maint}.

{phang2}
	{bf:From contents help files:  referenced but do not exist}{break}
	{cmd:{c -(}help }...{cmd:{c )-}} linkages to nonexisting help files
	among all {cmd:contents*.sthlp} help files.

{phang2}
	{bf:From contents help files:  exist but not referenced}{break}
	Help files that exist but not referenced among all
	{cmd:contents*.sthlp} help files, with the removal of the names listed
	in file {cmd:hlpnotused.maint}.

{phang2}
	{bf:From contents help files:  referenced but should not be}{break}
	{cmd:{c -(}help }...{cmd:{c )-}} linkages
        from non {cmd:contents*.sthlp} files to help files that are listed in
        file {cmd:hlpnotused.maint}.

{pstd}
The {cmd:helpnotused.maint} file has the following syntax:

	{cmd:*} comments
	{it:blank lines}

	{it:name} [{cmd:contents}|{cmd:base}|{cmd:both}]

{pstd}
If {cmd:contents}, {cmd:base}, or {cmd:both} are not specified for a
{it:name}, {cmd:both} is assumed.  {it:name} is specified without the
{cmd:.sthlp} suffix.


{marker options}{...}
{title:Options}

{phang}
{cmd:path()} specifies the search path for locating
{cmd:*.sthlp}, {cmd:*.hlp}, {cmd:*.ihlp},
{cmd:*.dlg}, and {cmd:*.maint} files.  The default is {cmd:path(`c(adopath)')}.

{phang}
{cmd:system} is an alternative to specifying {cmd:path()}.
Specifying {cmd:system} is equivalent to specifying
{cmd:path("BASE")}.
{p_end}
