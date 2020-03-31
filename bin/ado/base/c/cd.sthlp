{smcl}
{* *! version 1.0.12  19oct2017}{...}
{vieweralsosee "[D] cd" "mansection D cd"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] copy" "help copy"}{...}
{vieweralsosee "[D] dir" "help dir"}{...}
{vieweralsosee "[D] erase" "help erase"}{...}
{vieweralsosee "[D] mkdir" "help mkdir"}{...}
{vieweralsosee "[D] rmdir" "help rmdir"}{...}
{vieweralsosee "[D] shell" "help shell"}{...}
{vieweralsosee "[D] type" "help type"}{...}
{viewerjumpto "Syntax" "cd##syntax"}{...}
{viewerjumpto "Description" "cd##description"}{...}
{viewerjumpto "Links to PDF documentation" "cd##linkspdf"}{...}
{viewerjumpto "Examples" "cd##examples"}{...}
{p2colset 1 11 13 2}{...}
{p2col:{bf:[D] cd} {hline 2}}Change directory{p_end}
{p2col:}({mansection D cd:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Stata for Windows
	
	{cmd:cd}
{p 8 11 2}{cmd:cd}  [{cmd:"}]{it:directory_name}[{cmd:"}]{p_end}
{p 8 11 2}{cmd:cd}  [{cmd:"}]{it:drive}{cmd::}[{cmd:"}]{p_end}
{p 8 11 2}{cmd:cd}  [{cmd:"}]{it:drive}{cmd::}{it:directory_name}[{cmd:"}]{p_end}
	{cmd:pwd}


{phang}
Stata for Mac and Stata for Unix
	
	{cmd:cd}
{p 8 11 2}{cmd:cd}  [{cmd:"}]{it:directory_name}[{cmd:"}]{p_end}
	{cmd:pwd}


{phang}
If your {it:directory_name} contains embedded spaces, remember to
enclose it in double quotes.


{marker description}{...}
{title:Description}

{pstd}
Stata for Windows:
{opt cd} changes the current working directory to the specified drive and
directory.  {opt pwd} is equivalent to typing {opt cd} without arguments;
both display the name of the current working directory.
Note: You can shell out to a Windows command prompt; see {manhelp shell D}.
However, typing {cmd:!cd} {it:directory_name} does not change Stata's current
directory; use the {opt cd} command to change directories.

{pstd}
Stata for Mac and Stata for Unix:
{opt cd} (synonym {opt chdir}) changes the current working directory to
{it:directory_name} or, if {it:directory_name} is not specified, the home
directory.  {opt pwd} displays the path of the current working directory.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D cdQuickstart:Quick start}

        {mansection D cdRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{phang}Stata for Windows:{p_end}
{phang2}{cmd:. cd}{p_end}
{phang2}{cmd:. cd \data\city}{p_end}
{phang2}{cmd:. cd d:}{p_end}
{phang2}{cmd:. cd detail}{p_end}

{phang}Stata for Mac and Stata for Unix:{p_end}
{phang2}{cmd:. pwd}{p_end}
{phang2}{cmd:. cd ~/data/city}{p_end}
