{smcl}
{* *! version 1.1.11  19oct2017}{...}
{vieweralsosee "[D] type" "mansection D type"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] cd" "help cd"}{...}
{vieweralsosee "[D] copy" "help copy"}{...}
{vieweralsosee "[D] dir" "help dir"}{...}
{vieweralsosee "[D] erase" "help erase"}{...}
{vieweralsosee "[D] mkdir" "help mkdir"}{...}
{vieweralsosee "[D] rmdir" "help rmdir"}{...}
{vieweralsosee "[D] shell" "help shell"}{...}
{vieweralsosee "[R] translate" "help translate"}{...}
{vieweralsosee "[R] view" "help view"}{...}
{vieweralsosee "[P] viewsource" "help viewsource"}{...}
{viewerjumpto "Syntax" "type##syntax"}{...}
{viewerjumpto "Description" "type##description"}{...}
{viewerjumpto "Links to PDF documentation" "type##linkspdf"}{...}
{viewerjumpto "Options" "type##options"}{...}
{viewerjumpto "Examples" "type##examples"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[D] type} {hline 2}}Display contents of a file{p_end}
{p2col:}({mansection D type:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 13 2}{cmdab:ty:pe} [{cmd:"}]{it:{help filename}}[{cmd:"}] [{cmd:,} {it:options}]

{p 4 11 2}Note:  Double quotes must be used to enclose {it:filename} if the
name contains blanks.

{synoptset 10}{...}
{synopthdr}
{synoptline}
{synopt :{opt a:sis}}show file as is; default is to display files with suffix {hi:.smcl} or {hi:.sthlp} as SMCL{p_end}
{synopt :{opt smcl}}display file as SMCL; default for files with suffix {hi:.smcl} or {hi:.sthlp}{p_end}
{synopt :{opt s:howtabs}}display tabs as {hi:<T>} rather than being expanded{p_end}
{synopt :{opt star:bang}}list lines in the file that begin with "{cmd:*!}"{p_end}
{synopt:{opt lines(#)}}list first {it:#} lines{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:type} lists the contents of a file stored on disk.  This command is
similar to the Windows {cmd:type} command and the Unix {cmd:more}(1) or
{cmd:pg}(1) commands.

{pstd}
In Stata for Mac and Stata for Unix, {cmd:cat} is a synonym for {cmd:type}.

{pstd}
On all platforms, Stata understands a leading "~" as an abbreviation
for the home directory.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D typeQuickstart:Quick start}

        {mansection D typeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:asis} specifies that the file be shown exactly as it is.  The
default is to display files with the suffix {hi:.smcl} or {hi:.sthlp} as SMCL,
meaning that the SMCL directives are interpreted and properly rendered.  Thus
{cmd:type} can be used to look at files created by the {cmd:log using}
command.

{phang}
{opt smcl} specifies that the file be displayed as SMCL, meaning that
the SMCL directives are interpreted and properly rendered.  This is the
default for files with the suffix {hi:.smcl} or {hi:.sthlp}.

{phang}
{opt showtabs} requests that any tabs be displayed as {hi:<T>} rather than
being expanded.

{phang}
{opt starbang} lists only the lines in the specified file that begin
with the characters "{cmd:*!}" .  Such comment lines are typically used to
indicate the version number of ado-files, class files, etc. {opt starbang}
may not be used with SMCL files.

{phang}
{opt lines(#)} lists the first {it:#} lines of a file.  {opt lines()} is ignored
if the file is displayed as SMCL or if {it:#} is less than or equal to 0.


{marker examples}{...}
{title:Examples}

    Windows:
	{cmd:. type myfile.dct}
	{cmd:. type ..\dcts\myfile.dct}

    Mac and Unix:
	{cmd:. type myfile.dct}
	{cmd:. type ../dcts/myfile.dct}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. log using mylog}{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. keep make price mpg rep78 foreign}{p_end}
{phang2}{cmd:. keep in 1/10}{p_end}
{phang2}{cmd:. outfile using myout}{p_end}
{phang2}{cmd:. outfile using myout, dictionary}{p_end}
{phang2}{cmd:. log close}

{pstd}Display contents of {cmd:myout.raw}{p_end}
{phang2}{cmd:. type myout.raw}

{pstd}Display contents of {cmd:myout.dct}{p_end}
{phang2}{cmd:. type myout.dct}

{pstd}Display contents of {cmd:mylog.smcl}{p_end}
{phang2}{cmd:. type mylog.smcl}

{pstd}Display contents of {cmd:mylog.smcl} but show the file exactly as it
is{p_end}
{phang2}{cmd:. type mylog.smcl, asis}{p_end}
    {hline}
