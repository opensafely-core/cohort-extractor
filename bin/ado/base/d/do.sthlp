{smcl}
{* *! version 1.1.8  19jun2019}{...}
{viewerdialog do "dialog do_dlg"}{...}
{vieweralsosee "[R] do" "mansection R do"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] doedit" "help doedit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] include" "help include"}{...}
{findalias asfrlogs}{...}
{findalias asfrdofiles}{...}
{viewerjumpto "Syntax" "do##syntax"}{...}
{viewerjumpto "Menu" "do##menu"}{...}
{viewerjumpto "Description" "do##description"}{...}
{viewerjumpto "Links to PDF documentation" "do##linkspdf"}{...}
{viewerjumpto "Option" "do##option"}{...}
{p2colset 1 11 13 2}{...}
{p2col:{bf:[R] do} {hline 2}}Execute commands from a file{p_end}
{p2col:}({mansection R do:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang2}
{{cmd:do}|{cmdab:ru:n}}
{it:{help filename}}
[{it:arguments}] 
[{cmd:,} {opt nostop}]

{phang}
{it:filename} (called a do-file) can be created using Stata's Do-file Editor;
see {manhelp doedit R}.  This file will be a standard text file.
{it:filename} can also be created by using a non-Stata text editor; see
{manhelp shell D} for a way to invoke your favorite editor from inside Stata.
Ensure that you save the file in ASCII or UTF-8 format.

{phang}
If {it:filename} is specified without an extension, {cmd:.do} is assumed.

{phang}
If the path or {it:filename} contains spaces, it should be
enclosed in double quotes.

{phang}
A complete discussion of do-files, including information on {it:arguments},
can be found in {findalias frdofiles}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:File > Do...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:do} and {cmd:run} cause Stata to execute the commands stored in
{it:{help filename}} just as if they were entered from the keyboard.  {cmd:do}
echoes the commands as it executes them, whereas {cmd:run} is silent.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R doQuickstart:Quick start}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{opt nostop} allows the do-file to continue executing even if an error occurs.
Normally, Stata stops executing the do-file when it detects an error (nonzero
return code).
{p_end}
