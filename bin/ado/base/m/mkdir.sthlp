{smcl}
{* *! version 1.1.4  19oct2017}{...}
{vieweralsosee "[D] mkdir" "mansection D mkdir"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] cd" "help cd"}{...}
{vieweralsosee "[D] copy" "help copy"}{...}
{vieweralsosee "[D] dir" "help dir"}{...}
{vieweralsosee "[D] erase" "help erase"}{...}
{vieweralsosee "[D] rmdir" "help rmdir"}{...}
{vieweralsosee "[D] shell" "help shell"}{...}
{vieweralsosee "[D] type" "help type"}{...}
{viewerjumpto "Syntax" "mkdir##syntax"}{...}
{viewerjumpto "Description" "mkdir##description"}{...}
{viewerjumpto "Links to PDF documentation" "mkdir##linkspdf"}{...}
{viewerjumpto "Option" "mkdir##option"}{...}
{viewerjumpto "Examples" "mkdir##examples"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[D] mkdir} {hline 2}}Create directory{p_end}
{p2col:}({mansection D mkdir:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 13 2}{cmd:mkdir} {it:directoryname} [{cmd:,} {cmdab:pub:lic}]


{phang}
Double quotes may be used to enclose {it:directoryname}, and the quotes
must be used if {it:directoryname} contains embedded spaces.


{marker description}{...}
{title:Description}

{pstd}
{cmd:mkdir} creates a new directory (folder).


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D mkdirQuickstart:Quick start}

        {mansection D mkdirRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:public} specifies that {it:directoryname} be readable by everyone;
otherwise, the directory will be created according to the default permissions
of your operating system.


{marker examples}{...}
{title:Examples}

{pstd}
Stata for Windows:

{phang2}{cmd:. mkdir myproj}{p_end}
{phang2}{cmd:. mkdir c:\projects\myproj}{p_end}
{phang2}{cmd:. mkdir "c:\My Projects\Project 1"}

{pstd}
Stata for Mac and Unix:

{phang2}{cmd:. mkdir myproj}{p_end}
{phang2}{cmd:. mkdir ~/projects/myproj}{p_end}
