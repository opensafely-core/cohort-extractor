{smcl}
{* *! version 1.0.6  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] dir" "help dir"}{...}
{vieweralsosee "[P] findfile" "help findfile"}{...}
{vieweralsosee "[P] macro" "help macro"}{...}
{vieweralsosee "[P] sysdir" "help sysdir"}{...}
{viewerjumpto "Syntax" "_getfilename##syntax"}{...}
{viewerjumpto "Description" "_getfilename##description"}{...}
{viewerjumpto "Options" "_getfilename##options"}{...}
{viewerjumpto "Examples" "_getfilename##examples"}{...}
{viewerjumpto "Acknowledgment" "_getfilename##acknowledgment"}{...}
{title:Title}

{p2colset 5 25 27 4}{...}
{p2col: {hi:[P] _getfilename} {hline 2}}Utility commands for handling
path-filename specifications{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}{cmd:_getfilename} {cmd:`"}{it:path-filename}{cmd:"'}

{p 8 8 2}{cmd:_shortenpath} {cmd:`"}{it:path-filename}{cmd:"'}{cmd:,}
{cmd:len(}{it:#}{cmd:)} [ {cmd:head(}{it:str}{cmd:)} ]


{marker description}{...}
{title:Description}

{pstd}{cmd:_getfilename} returns in {cmd:r(filename)} the name of
the file (with extension), stripping off drive and directory
information.  Also see {manhelp findfile P} for a related command.

{pstd}{cmd:_shortenpath} returns in {cmd:r(pfilename)}, a shortened
path-filename string of length at most {cmd:len}.  Shortening is
accomplished by replacing leading directories by one {cmd:*},
denoting `some string'.  {cmd:_shortenpath} never shortens the
filename itself, and leading directories are represented by a string
at least as long as  {cmd:*\}, so {cmd:_shortenpath} may actually
return a string longer than {cmd:len}.


{marker options}{...}
{title:Options}

{phang}{cmd:len(}{it:#}{cmd:)} ({cmd:_shortenpath} only)
is not optional. It specifies the length to which the {it:path-filename}
should be shortened.

{phang}{cmd:head(}{it:#}{cmd:)} ({cmd:_shortenpath} only)
specifies the string used to represent the leading directories removed
from the head of {it:path-filename}.  It defaults to {cmd:*}.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. _getfilename c:\archive\stata\data\hin95.dta}{break}
{txt:r(filename):} {res:hin95.dta}

{phang}{cmd:. _shortenpath c:\archive\stata\data\hin95.dta, len(20)}{break}
{txt:r(pfilename):} {res:*\data\hin95.dta}

{phang}{cmd:. _shortenpath c:\archive\stata\data\hin95.dta, len(5)}{break}
{txt:r(pfilename):} {res:*\hin95.dta}


{marker acknowledgment}{...}
{title:Acknowledgment}

{pstd}These utilities were written by Jeroen Weesie, Dept of Sociology,
Utrecht University, The Netherlands.
{p_end}
