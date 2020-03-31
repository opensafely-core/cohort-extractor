{smcl}
{* *! version 1.1.4  19oct2017}{...}
{vieweralsosee "[D] zipfile" "mansection D zipfile"}{...}
{viewerjumpto "Syntax" "zipfile##syntax"}{...}
{viewerjumpto "Description" "zipfile##description"}{...}
{viewerjumpto "Links to PDF documentation" "zipfile##linkspdf"}{...}
{viewerjumpto "Option for zipfile" "zipfile##option_zipfile"}{...}
{viewerjumpto "Option for unzipfile" "zipfile##option_unzipfile"}{...}
{viewerjumpto "Examples" "zipfile##examples"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[D] zipfile} {hline 2}}Compress and uncompress files and directories in zip archive format{p_end}
{p2col:}({mansection D zipfile:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Add files or directories to a zip file

{p 8 16 2}
{cmd:zipfile} {it:file}{c |}{it:directory}
    [{it:file}{c |}{it:directory}] ... {cmd:,}
    {cmd:saving(}{it:zipfilename}[{cmd:, replace}]{cmd:)} 


{phang}
Extract files or directories from a zip file

{p 8 16 2}
{cmd:unzipfile} {it:zipfilename} [{cmd:,} {opt replace}]


{p 4 11 2}Note:  Double quotes must be used to enclose {it:file} and
{it:directory} if the name or path contains blanks.  {it:file} and
{it:directory} may also contain the {cmd:?} and {cmd:*} wildcard characters.


{marker description}{...}
{title:Description}

{pstd}
{cmd:zipfile} compresses files and directories into a zip file that
is compatible with Zip64, WinZip, PKZIP 2.04g, and other applications that use
the zip archive format.

{pstd}
{cmd:unzipfile} extracts files and directories from a file in zip
archive format into the current directory.  {cmd:unzipfile} can open zip files
created by Zip64, WinZip, PKZIP 2.04g, and other applications that use the zip
archive format.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D zipfileQuickstart:Quick start}

        {mansection D zipfileRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option_zipfile}{...}
{title:Option for zipfile}

{phang}	
{cmd:saving(}{it:zipfilename}[{cmd:, replace}]{cmd:)} is required.
It specifies the filename to be created or replaced.  If
{it:zipfilename} is specified without an extension, {cmd:.zip} will be assumed.


{marker option_unzipfile}{...}
{title:Option for unzipfile}

{phang}	
{opt replace} overwrites any file or directory in the current directory with
the files or directories in the zip file that have the same name.


{marker examples}{...}
{title:Examples}

{pstd}
Zip all {cmd:.dta} files in the current directory into the file
{cmd:myfiles.zip}

	{cmd:. zipfile *.dta, saving(myfiles)}

{pstd}
Zip all {cmd:.dta} files from any three-character subdirectories of the
current directory, and overwrite the file {cmd:myfiles.zip} if it exists

	{cmd:. zipfile ???/*.dta, saving(myfiles, replace)}

{pstd}
Unzip the file {cmd:myfiles.zip} into the current directory, overwriting any
files or directories that have the same name as the files or directories in the
zip file

	{cmd:. unzipfile myfiles, replace}
