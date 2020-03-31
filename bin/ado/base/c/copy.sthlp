{smcl}
{* *! version 1.1.11  15oct2018}{...}
{viewerdialog copy "dialog copy"}{...}
{vieweralsosee "[D] copy" "mansection D copy"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] cd" "help cd"}{...}
{vieweralsosee "[D] dir" "help dir"}{...}
{vieweralsosee "[D] erase" "help erase"}{...}
{vieweralsosee "[D] mkdir" "help mkdir"}{...}
{vieweralsosee "[D] rmdir" "help rmdir"}{...}
{vieweralsosee "[D] shell" "help shell"}{...}
{vieweralsosee "[D] type" "help type"}{...}
{viewerjumpto "Syntax" "copy##syntax"}{...}
{viewerjumpto "Description" "copy##description"}{...}
{viewerjumpto "Links to PDF documentation" "copy##linkspdf"}{...}
{viewerjumpto "Options" "copy##options"}{...}
{viewerjumpto "Examples" "copy##examples"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[D] copy} {hline 2}}Copy file from disk or URL{p_end}
{p2col:}({mansection D copy:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 13 2}
{cmd:copy} {it:{help filename}1} {it:{help filename}2} [{cmd:,} {it:options}]

{phang}
{it:filename1} may be a filename or a URL.  {it:filename2} may be the name
of a file or a directory.  If {it:filename2} is a directory name,
{it:filename1} will be copied to that directory.  {it:filename2} may not
be a URL.

{p 4 10 2}
Note: Double quotes may be used to enclose the filenames, and the quotes must
be used if the filename contains embedded blanks.

{synoptset 11}{...}
{synopthdr}
{synoptline}
{synopt :{opt pub:lic}}make {it:{help filename}2} readable by all{p_end}
{synopt :{opt t:ext}}interpret {it:{help filename}1} as text file and
   translate to native text format{p_end}

{synopt :{opt replace}}may overwrite {it:{help filename}2}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt replace} does not appear in the dialog box.{p_end}


{marker description}{...}
{title:Description}

{pstd}
{opt copy} copies an existing file to a file with a new name.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D copyQuickstart:Quick start}

        {mansection D copyRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt public} specifies that {it:{help filename}2} be readable by
everyone; otherwise, the file will be created according to the default
permissions of your operating system.

{phang}
{opt text} specifies that {it:{help filename}1} be interpreted as a text
file and be translated to the native form of text files on your
computer.  Computers differ on how end-of-line is recorded:  Unix systems
record one line-feed character, Windows computers record a
carriage-return/line-feed combination, and Mac computers record just a
carriage return.  {opt text} specifies that {it:filename1} be examined
to determine how it has end-of-line recorded and that the line-end characters
be switched to whatever is appropriate for your computer when the
copy is made.

{pmore}
There is no reason to specify {opt text} when copying a file already on
your computer to a different location because the file would already be in
your computer's format.

{pmore}
Do not specify {opt text} unless you know that the file is a text file; if
the file is binary and you specify {opt text}, the copy will be useless. 
Most word processors produce binary files, not text files.  The term
text, as it is used here, specifies a particular way of recording
textual information.

{pmore}
When other parts of Stata read text files, they do not care how lines
are terminated, so there is no reason to translate end-of-line characters on
that score.  You specify {opt text} because you may want to look at the file
with other software.

{pstd}
The following option is available with {cmd:copy} but is not shown in the
dialog box:

{phang}
{opt replace} specifies that {it:{help filename}2} be replaced if it already
exists.


{marker examples}{...}
{title:Examples}

{phang}Windows:{p_end}
{phang2}{cmd:. copy orig.dta newcopy.dta}{p_end}
{phang2}{cmd:. copy mydir\orig.dta .}{p_end}
{phang2}{cmd:. copy orig.dta ../../}{p_end}
{phang2}{cmd:. copy "my document" "copy of document"}{p_end}
{phang2}{cmd:. copy ..\mydir\doc.txt document\doc.tex}{p_end}
{phang2}{cmd:. copy https://www.stata.com/examples/simple.dta simple.dta}{p_end}
{phang2}{cmd:. copy https://www.stata.com/examples/simple.txt simple.txt, text}

{phang}Mac:{p_end}
{phang2}{cmd:. copy orig.dta newcopy.dta}{p_end}
{phang2}{cmd:. copy mydir/orig.dta .}{p_end}
{phang2}{cmd:. copy orig.dta ../../}{p_end}
{phang2}{cmd:. copy "my document" "copy of document"}{p_end}
{phang2}{cmd:. copy ../mydir/doc.txt document/doc.tex}{p_end}
{phang2}{cmd:. copy https://www.stata.com/examples/simple.dta simple.dta}{p_end}
{phang2}{cmd:. copy https://www.stata.com/examples/simple.txt simple.txt, text}{p_end}
