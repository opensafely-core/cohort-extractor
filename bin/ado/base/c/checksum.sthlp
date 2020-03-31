{smcl}
{* *! version 1.1.10  19oct2017}{...}
{vieweralsosee "[D] checksum" "mansection D checksum"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] net" "help net"}{...}
{vieweralsosee "[D] use" "help use"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] datasignature" "help datasignature"}{...}
{viewerjumpto "Syntax" "checksum##syntax"}{...}
{viewerjumpto "Description" "checksum##description"}{...}
{viewerjumpto "Links to PDF documentation" "checksum##linkspdf"}{...}
{viewerjumpto "Technical note" "checksum##technote"}{...}
{viewerjumpto "Options" "checksum##options"}{...}
{viewerjumpto "Examples" "checksum##examples"}{...}
{viewerjumpto "Stored results" "checksum##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[D] checksum} {hline 2}}Calculate checksum of file{p_end}
{p2col:}({mansection D checksum:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 18 2}
{cmd:checksum}
{it:{help filename}}
[{cmd:,} {it:options}]

{p 8 12 2}
{opt se:t}
{cmd:checksum}
{c -(}{cmd:on}|{cmd:off}{c )-}
[{cmd:,} {opt perm:anently}]

{synoptset 28}{...}
{synopthdr}
{synoptline}
{synopt :{opt save}}save output to {it:{help filename}}{opt .sum}; default is to
display a report{p_end}
{synopt :{opt replace}}may overwrite {it:{help filename}}{opt .sum}; use with
{opt save}{p_end}
{synopt :{cmdab:sa:ving(}{it:{help filename}2}[{cmd:,} {opt replace}]{cmd:)}}save
output to {it:filename2}; alternative to {opt save}{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{opt checksum} creates {it:{help filename}}{opt .sum} files for later use by
Stata when it reads files over a network.  These optional files are used
to reduce the chances of corrupted files going undetected.  Whenever Stata
reads file {it:filename.suffix} over a network, whether by
{cmd:use}, {cmd:net}, {cmd:update}, etc., it also looks for
{it:filename}{opt .sum}.  If Stata finds that file, Stata reads it and
uses its contents to verify that the first file was received without
error.  If there are errors, Stata informs the user that the file could
not be read.

{pstd}
{opt set checksum on} tells Stata to verify that
files downloaded over a network have been received without error.

{pstd}
{opt set checksum off}, which is the default, tells Stata to bypass the
file verification.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D checksumQuickstart:Quick start}

        {mansection D checksumRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker technote}{...}
{title:Technical note}

{pstd}
{cmd:checksum} calculates a CRC checksum following the POSIX
1003.2 specification and displays the file size in bytes.  {cmd:checksum}
produces the same results as the Unix {cmd:cksum} command.  Comparing the
checksum of the original file with the received file guarantees the
integrity of the received file.

{pstd}
When comparing Stata's {cmd:checksum} results with those of Unix, do
not confuse Unix's {cmd:sum} and {cmd:cksum} commands.  Unix's {cmd:cksum}
and Stata's {cmd:checksum} use a more robust algorithm than that used by
Unix's {cmd:sum}.  In some Unix operating systems, there is no {cmd:cksum}
command, and the more robust algorithm is obtained by specifying an option
with {cmd:sum}.


{marker options}{...}
{title:Options}

{phang}
{opt save} saves the output of the {opt checksum} command to the text
file {it:{help filename}}{opt .sum}.  The default is to display a report but not
create a file.

{phang}
{opt replace} is for use with {opt save}; it permits Stata to overwrite
an existing {it:{help filename}}{opt .sum} file.

{phang}
{cmd:saving(}{it:{help filename}2} [{cmd:, replace}]{cmd:)} is an alternative
to {opt save}.  It saves the output in the specified filename.  You must
supply a file extension if you want one, because none is assumed.

{phang}
{opt permanently} specifies that, in addition to making the change right
now, the {opt checksum} setting be remembered and become the default
setting when you invoke Stata.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. save auto}

{pstd}Calculate checksum of file{p_end}
{phang2}{cmd:. checksum auto.dta}{p_end}
{phang2}Checksum for auto.dta = 2694850408, size = 6442

{pstd}Calculate checksum of file and save output to {cmd:auto.sum}{p_end}
{phang2}{cmd:. checksum auto.dta, save}

{pstd}Display contents of {cmd:auto.sum}{p_end}
{phang2}{cmd:. type auto.sum}{p_end}
{phang2}1 6442 2694850408{p_end}

{pstd}
The first value is the version number (possibly used for future
releases).  The second number is the file's size in bytes.  This can be
used with the checksum value to ensure that the file transferred without
corruption.  The third number is the checksum value itself.  It is
possible for two different files to have the same checksum value, but it
is very unlikely that two files with the same checksum value could have
the same file size.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:checksum} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(version)}}{cmd:checksum} version number{p_end}
{synopt:{cmd:r(filelen)}}length of file in bytes{p_end}
{synopt:{cmd:r(checksum)}}{cmd:checksum} value{p_end}
{p2colreset}{...}
