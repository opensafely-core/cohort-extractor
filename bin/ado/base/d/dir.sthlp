{smcl}
{* *! version 1.1.7  19oct2017}{...}
{vieweralsosee "[D] dir" "mansection D dir"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] cd" "help cd"}{...}
{vieweralsosee "[D] copy" "help copy"}{...}
{vieweralsosee "[D] erase" "help erase"}{...}
{vieweralsosee "[D] mkdir" "help mkdir"}{...}
{vieweralsosee "[D] rmdir" "help rmdir"}{...}
{vieweralsosee "[D] shell" "help shell"}{...}
{vieweralsosee "[D] type" "help type"}{...}
{viewerjumpto "Syntax" "dir##syntax"}{...}
{viewerjumpto "Description" "dir##description"}{...}
{viewerjumpto "Links to PDF documentation" "dir##linkspdf"}{...}
{viewerjumpto "Option" "dir##option"}{...}
{viewerjumpto "Examples" "dir##examples"}{...}
{p2colset 1 12 14 2}{...}
{p2col:{bf:[D] dir} {hline 2}}Display filenames{p_end}
{p2col:}({mansection D dir:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 13 2}
{{cmd:dir}{c |}{cmd:ls}} [{cmd:"}][{it:filespec}][{cmd:"}]
[{cmd:,} {opt w:ide}]

{phang}
{it:filespec} is any valid Mac, Unix, or Windows file path or file
specification (see {findalias frfilenames}) and may include "{cmd:*}" to
indicate any string of characters.

{phang}
Note:  Double quotes must be used to enclose {it:filespec} if the name
contains spaces.


{marker description}{...}
{title:Description}

{pstd}
{cmd:dir} and {cmd:ls} -- they work the same way -- list the names of
files in the specified directory; the names of the commands come from names
popular on Unix and Windows computers.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D dirQuickstart:Quick start}

        {mansection D dirRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{opt wide} under Mac and Windows produces an effect similar to
specifying {cmd:/W} with the DOS {cmd:dir} command -- it compresses the
resulting listing by placing more than one filename on a line.  Under Unix, it
produces the same effect as typing {cmd:ls -F -C}.  Without the {opt wide}
option, {cmd:ls} is equivalent to {cmd:ls -F -l}.


{marker examples}{...}
{title:Examples}

    Windows:
	{cmd:. dir}
	{cmd:. dir, w}
	{cmd:. dir *.dta}
	{cmd:. dir \mydata\*.dta}

    Mac and Unix:
	{cmd:. ls}
	{cmd:. ls, w}
	{cmd:. ls *.dta}
	{cmd:. ls ~/mydata/*.dta}
