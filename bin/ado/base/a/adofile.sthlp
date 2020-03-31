{smcl}
{* *! version 1.1.2  10may2011}{...}
{findalias asfrado}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] program" "help program"}{...}
{vieweralsosee "[R] net" "help usersite"}{...}
{vieweralsosee "[P] sysdir" "help sysdir"}{...}
{vieweralsosee "[R] which" "help which"}{...}
{title:Title}

{pstd}
{findalias frado}


{title:Remarks}

{pstd}
An ado-file is a text file that contains a Stata program.  When you
type a command that Stata does not know, it looks in certain places for an
ado-file of that name.  If Stata finds it, Stata loads and executes it, so it
appears to you as if the ado-command is just another command built into Stata.

{pstd}
Stata looks for ado-files along the ado-file path; see {cmd:adopath} in
{manhelp sysdir P}.
The {cmd:which} command tells you where Stata finds a particular command; see
{manhelp which R}.  You can write a Stata command and place it in a file
having the same name as the command and ending in {cmd:.ado}.  There are two
places to put your personal ado-files.  One is the current directory, and that
is a good choice when the ado-file is unique to a project.  The other place is
in what Stata calls your PERSONAL directory; see {cmd:personal} in
{manhelp sysdir P}.  This
is a good location if your ado-file is of more general usefulness.

{pstd}
See {manhelp program P} for information on defining a program within your
ado-file.  Sharing your ado-file with others over the Internet is easy; see
{cmd:usersite} in {manhelp net R}.
{p_end}
