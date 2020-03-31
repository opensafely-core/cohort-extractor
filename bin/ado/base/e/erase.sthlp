{smcl}
{* *! version 1.0.11  19oct2017}{...}
{vieweralsosee "[D] erase" "mansection D erase"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] cd" "help cd"}{...}
{vieweralsosee "[D] copy" "help copy"}{...}
{vieweralsosee "[D] dir" "help dir"}{...}
{vieweralsosee "[D] mkdir" "help mkdir"}{...}
{vieweralsosee "[D] rmdir" "help rmdir"}{...}
{vieweralsosee "[D] shell" "help shell"}{...}
{vieweralsosee "[D] type" "help type"}{...}
{viewerjumpto "Syntax" "erase##syntax"}{...}
{viewerjumpto "Description" "erase##description"}{...}
{viewerjumpto "Links to PDF documentation" "erase##linkspdf"}{...}
{viewerjumpto "Examples" "erase##examples"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[D] erase} {hline 2}}Erase a disk file{p_end}
{p2col:}({mansection D erase:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 11 2}
{c -(}{cmd:erase}|{cmd:rm}{c )-} [{cmd:"}]{it:{help filename}}[{cmd:"}]

{p 4 11 2}
Note:  Double quotes must be used to enclose {it:filename} if the  
name contains spaces.


{marker description}{...}
{title:Description}

{pstd}
The {cmd:erase} command erases files stored on disk.  {cmd:rm} is a synonym
for {cmd:erase} for the convenience of Mac and Unix users.

{pstd}
Stata for Mac users:  {cmd:erase} is permanent; the
file is not moved to the Trash but is immediately removed from the disk.

{pstd}
Stata for Windows users:  {cmd:erase} is permanent;
the file is not moved to the Recycle Bin but is immediately removed from the
disk.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D eraseQuickstart:Quick start}

        {mansection D eraseRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{phang}
Windows{p_end}
{pmore}
{cmd:. erase oldfile.dta}{p_end}
{pmore}
{cmd:. erase ..\mydata\oldfile.dta}

{phang}
Mac and Unix{p_end}
{pmore}
{cmd:. rm oldfile.dta}{p_end}
{pmore}
{cmd:. rm ../mydata/oldfile.dta}
