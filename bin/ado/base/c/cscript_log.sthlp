{smcl}
{* *! version 1.0.10  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] cscript" "help cscript"}{...}
{viewerjumpto "Syntax" "cscript_log##syntax"}{...}
{viewerjumpto "Description" "cscript_log##description"}{...}
{viewerjumpto "Example" "cscript_log##example"}{...}
{viewerjumpto "Reference" "cscript_log##reference"}{...}
{title:Title}

{p 4 25 2}
{cmd:[P] cscript_log} {hline 2} Begin certification script log


{marker syntax}{...}
{title:Syntax}

{p 8 20 2}
{cmd:cscript_log}
{c -(}{cmd:begin}|{cmd:end}{c )-}
[{it:dirname}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:cscript_log} is used by StataCorp in its testing procedure to start and
stop individual log files.

{pstd}
It is recommended that you ignore and avoid this command.  This command has to
do with organizational details of how Stata is tested by StataCorp, and the
syntax and actions of this command might change.  For details on how StataCorp
tests Stata, see {help cscript_log##G2001:Gould (2001)}.  For testing
commands that are recommended for use, see {manhelp cscript P}.

{pstd}
{cmd:cscript_log begin} begins a SMCL log.  The log will be named
[{cmd:x}]{cmd:test}[{cmd:-se}]{cmd:.smcl} or
[{cmd:x}]{cmd:test}[{cmd:-mp}]{cmd:.smcl}
according to the values of {cmd:$S_CONSOLE}, {cmd:$S_StataSE}, and
{cmd:$S_StataMP}.

{pstd}
{cmd:cscript_log end} closes the log.

{pstd}
In both cases, if {it:dirname} is specified, the current directory is
changed to {it:dirname} before the other actions of {cmd:cscript_log}.


{marker example}{...}
{title:Example}

{pstd}
A portion of the Stata test script certall.do reads:

	{hline 22}
	{cmd:cscript_log begin base}
	{cmd:do test}
	{cmd:cscript_log end ..}

	{cmd:cscript_log begin ado}
	{cmd:do test}
	{cmd:cscript_log end ..}

	...
	{hline 22}


{marker reference}{...}
{title:Reference}

{marker G2001}{...}
{phang}
Gould, W. W. 2001.
Statistical software certification.
{browse "http://www.stata-journal.com/sjpdf.html?articlenum=pr0001":{it:Stata Journal} 1: 29-50}.
{p_end}
