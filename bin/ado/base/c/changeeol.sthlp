{smcl}
{* *! version 1.1.5  19oct2017}{...}
{viewerdialog changeeol "dialog changeeol"}{...}
{vieweralsosee "[D] changeeol" "mansection D changeeol"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] filefilter" "help filefilter"}{...}
{vieweralsosee "[D] hexdump" "help hexdump"}{...}
{viewerjumpto "Syntax" "changeeol##syntax"}{...}
{viewerjumpto "Description" "changeeol##description"}{...}
{viewerjumpto "Links to PDF documentation" "changeeol##linkspdf"}{...}
{viewerjumpto "Options" "changeeol##options"}{...}
{viewerjumpto "Examples" "changeeol##examples"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[D] changeeol} {hline 2}}Convert end-of-line characters of text file{p_end}
{p2col:}({mansection D changeeol:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 13 2}
{cmd:changeeol} {it:{help filename}1} {it:{help filename}2}{cmd:, eol(}{it:platform}{cmd:)} [{it:options}]

{phang}
{it:filename1} and {it:filename2} must be filenames.

{p 4 10 2}
Note: Double quotes may be used to enclose the filenames, and the quotes must
be used if the filename contains embedded blanks.

{synoptset 18 tabbed}{...}
{synopthdr}
{synoptline}
{p2coldent :* {cmd:eol(windows)}}convert to Windows-style end-of-line characters ({cmd:\r\n}){p_end}
{p2coldent :* {cmd:eol(dos)}}synonym for {cmd:eol(windows)}{p_end}
{p2coldent :* {cmd:eol(unix)}}convert to Unix-style end-of-line characters ({cmd:\n}){p_end}
{p2coldent :* {cmd:eol(mac)}}convert to Mac-style end-of-line characters ({cmd:\n}){p_end}
{p2coldent :* {cmd:eol(classicmac)}}convert to classic Mac-style end-of-line characters ({cmd:\r}){p_end}
{synopt :{opt replace}}overwrite {it:{help filename}2}{p_end}
{synopt :{opt force}}force to convert {it:{help filename}1} to {it:filename2} if {it:filename1} is a binary file{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt eol()} is required.{p_end}


{marker description}{...}
{title:Description}

{pstd}
{opt changeeol} converts text file {it:{help filename}1} to text file
{it:filename2} with the specified Windows/Unix/Mac/classic
Mac-style end-of-line characters. {cmd:changeeol} changes the
end-of-line characters from one type of file to another.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D changeeolQuickstart:Quick start}

        {mansection D changeeolRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:eol(windows}|{opt dos}|{opt unix}|{opt mac}|{cmd:classicmac)}
specifies to which platform style {it:{help filename}2} is to be converted.
{cmd:eol()} is required.

{phang}
{opt replace} specifies that {it:{help filename}2} be replaced if it already exists.

{phang}
{opt force} specifies that {it:{help filename}1} be converted if it is a binary file.


{marker examples}{...}
{title:Examples}

{phang}Windows{p_end}
{phang2}{cmd:. changeeol orig.txt newcopy.txt, eol(windows)}{p_end}

{phang}Unix{p_end}
{phang2}{cmd:. changeeol orig.txt newcopy.txt, eol(unix)}{p_end}

{phang}Mac{p_end}
{phang2}{cmd:. changeeol orig.txt newcopy.txt, eol(mac)}{p_end}

{phang}Classic Mac{p_end}
{phang2}{cmd:. changeeol orig.txt newcopy.txt, eol(classicmac)}{p_end}
