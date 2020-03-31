{smcl}
{* *! version 1.2.3  23apr2019}{...}
{vieweralsosee "[R] which" "mansection R which"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] findfile" "help findfile"}{...}
{vieweralsosee "[P] version" "help version"}{...}
{viewerjumpto "Syntax" "which##syntax"}{...}
{viewerjumpto "Description" "which##description"}{...}
{viewerjumpto "Links to PDF documentation" "which##linkspdf"}{...}
{viewerjumpto "Option" "which##option"}{...}
{viewerjumpto "Examples" "which##examples"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[R] which} {hline 2}}Display location and version of an ado-file
{p_end}
{p2col:}({mansection R which:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 20 2}
{cmd:which} {it:fname}[{cmd:.}{it:ftype}] [{cmd:,} {cmd:all}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:which} looks for file {it:fname}{cmd:.}{it:ftype} along the {hi:S_ADO}
path.  If Stata finds the file, {cmd:which} displays the full path and
filename, along with, if the file is text, all lines in the file that begin
with "{hi:*!}" in the first column.  If Stata cannot find the file, {cmd:which}
issues the message "{err:file not found along ado-path}" and sets the return
code to 111.  {it:ftype} must be a file type for which Stata usually looks
along the ado-path to find.  Allowable {it:ftypes} are

{p 8 8}
{cmd:.ado}, {cmd:.class}, {cmd:.dlg}, {cmd:idlg}, {cmd:.sthlp}, {cmd:.ihlp},
{cmd:.hlp}, {cmd:.jar}, {cmd:.key}, {cmd:.maint}, {cmd:.mata}, {cmd:.mlib},
{cmd:.mo}, {cmd:.mnu}, {cmd:.plugin}, {cmd:.png}, {cmd:.py}, {cmd:.scheme},
{cmd:.stbcal}, and {cmd:.style}

{pstd}
If {it:ftype} is omitted, {cmd:which} assumes {hi:.ado}.  When searching for
{hi:.ado} files, if Stata cannot find the file, Stata then checks to see
if {it:fname} is a built-in Stata command, allowing for valid abbreviations.
If it is, the message "{res:built-in command}" is displayed; if not, the
message "{err:command not found as either built-in or ado-file}" is displayed
and the return code is set to 111.

{pstd}
For information on internal version control, see {manhelp version P}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R whichRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:all} forces {cmd:which} to report the location of all files matching the
{it:fname}{cmd:.}{it:ftype} found along the search path.  The default is to
report just the first one found.


{marker examples}{...}
{title:Examples}

{pstd}
The {cmd:which} command displays the path for {cmd:filename.ado} and any
lines in the code that begin with "{cmd:*!}".

        {cmd:. which test}
        C:\Program Files\Stata16\ado\base\t\test.ado
        *! version 2.3.4  14apr2016

{pstd}
If we type {cmd:which} {it:command}, where {it:command} is a built-in command
rather than an ado-file, Stata responds with

        {cmd:. which summarize}
        built-in command:  summarize

{pstd}
If {it:command} was neither a built-in command nor an ado-file, Stata would
respond with

        {cmd:. which junk}
        command junk not found as either built-in or ado-file
        r(111);
