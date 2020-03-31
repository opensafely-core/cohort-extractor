{smcl}
{* *! version 1.0.5  20mar2015}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{viewerjumpto "Syntax" "projmanager##syntax"}{...}
{viewerjumpto "Menu" "projmanager##menu"}{...}
{viewerjumpto "Description" "projmanager##description"}{...}
{viewerjumpto "Option" "projmanager##option"}{...}
{viewerjumpto "Remarks" "projmanager##remarks"}{...}
{title:Title}

{p2colset 5 24 26 2}{...}
{p2col :{hi:[P] projmanager} {hline 2}}Open Stata Project Manager{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{cmdab:projman:ager} {it:{help filename}} [{cmd:,} {cmd:replace}]


{marker menu}{...}
{title:Menu}

{phang}
{bf:File > New > Project...} (Select within Do-file Editor -- Windows and
Unix only)


{marker description}{...}
{title:Description}

{pstd}
{cmd:projmanager} opens a window that lets you organize Stata files.  If
{it:{help filename}} is specified without an extension, {cmd:.dta} is assumed.
If your {it:filename} contains embedded spaces, remember to enclose it in
double quotes.


{marker option}{...}
{title:Option}

{phang}
{opt replace} specifies that {it:{help filename}}, if it already exists, be
overwritten.  When you do not specify {opt replace}, the file is assumed to be
new.  If the specified file already exists, an error message is issued and no
new window is opened.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:projmanager} {it:filename} opens a new window with the project open in
the Project Manager and an empty document open in the Do-file Editor.  If
{it:filename} does not already exist on disk, it is created and then opened in
the Project Manager.

{pstd}
You may have more than one project open at once.  If you issue the
{cmd:projmanager} command with a project that is already open, it brings the
project's window to the front.

{pstd}
See {manhelp project_manager P:Project Manager}
to learn how to use the Project Manager to organize
and open Stata files.  Read
{findalias gsmdoedit}, 
{findalias gsudoedit}, or 
{findalias gswdoedit} 
to learn how to use the Do-file Editor to create and execute do-files.
{p_end}
