{smcl}
{* *! version 1.2.13  01nov2018}{...}
{viewerdialog view "view_d"}{...}
{vieweralsosee "[R] view" "mansection R view"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] help" "help help"}{...}
{vieweralsosee "[R] net" "help net"}{...}
{vieweralsosee "[R] search" "help search"}{...}
{vieweralsosee "[D] type" "help type"}{...}
{vieweralsosee "[R] update" "help update"}{...}
{viewerjumpto "Syntax" "view##syntax"}{...}
{viewerjumpto "Menu" "view##menu"}{...}
{viewerjumpto "Description" "view##description"}{...}
{viewerjumpto "Links to PDF documentation" "view##linkspdf"}{...}
{viewerjumpto "Options" "view##options"}{...}
{viewerjumpto "Remarks" "view##remarks"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[R] view} {hline 2}}View files and logs{p_end}
{p2col:}({mansection R view:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Display file in Viewer

{p 8 15 2}
{cmd:view} [{cmd:file}] [{cmd:"}]{it:{help filename}}[{cmd:"}] 
   [{cmd:,} {cmd:asis adopath}]


{phang}
Bring up browser pointed to specified URL

{p 8 15 2}
{cmd:view} {cmd:browse} [{cmd:"}]{it:url}[{cmd:"}]


{phang}
Display help results in Viewer

{p 8 15 2}
[{cmd:view}] {cmd:help} [{it:topic_or_command_name}]


{phang}
Display search results in Viewer

{p 8 15 2}
[{cmd:view}] {cmd:search} {it:keywords}


{phang}
Display net results in Viewer

{p 8 15 2}
{cmd:view} {cmd:net} [{it:netcmd}]


{phang}
Display ado-results in Viewer

{p 8 15 2}
{cmd:view} {cmd:ado} [{it:adocmd}]


{phang}
Display update results in Viewer

{p 8 15 2}
{cmd:view} {cmd:update} [{it:updatecmd}]


{marker menu}{...}
{title:Menu}

{phang}
{bf:File > View...}


{marker description}{...}
{title:Description}

{phang}
{cmd:view} displays file contents in the Viewer.

{phang}
{cmd:view} {cmd:file} displays the specified file.  {cmd:file} is optional, so
if you had a SMCL session log created by typing {bind:{cmd:log using mylog}},
you could view it by typing {bind:{cmd:view mylog.smcl}}.  
{bind:{cmd:view} {cmd:file}} can properly display {hi:.smcl} files (logs and
the like), {hi:.sthlp} files, and text files.  
{bind:{cmd:view} {cmd:file}}'s {opt asis} option specifies that the file be
displayed as plain text, regardless of the {it:filename}'s extension.

{phang}
{cmd:view} {cmd:browse} opens your browser pointed to {it:url}.  Typing
{bind:{cmd:view} {cmd:browse} {cmd:https://www.stata.com}} would bring up your
browser pointed to the https://www.stata.com website.

{phang}
[{cmd:view}] {cmd:help} displays the specified topic in the Viewer.
For example, to review the help for Stata's
{cmd:print} command, you could type {bind:{cmd:help print}}.
See {helpb help:[R] help} for more details.

{phang}
[{cmd:view}] {cmd:search} displays the results of the {cmd:search} command
in the Viewer.  For instance, to search the system help for information on
robust regression, you could type {bind:{cmd:search robust regression}}.
See {helpb search:[R] search} for more details.

{phang}
{cmd:view} {cmd:net} does the same as the {helpb net} command but displays
the result in the Viewer.  For instance, typing
{bind:{cmd:view net search hausman test}} would search the Internet for
additions to Stata related to the Hausman test.  Typing
{bind:{cmd:view net from https://www.stata.com}} would go to the Stata
additions download site at https://www.stata.com.

{phang}
{cmd:view} {cmd:ado} does the same as the {helpb ado} command but displays
the result in the Viewer.  For instance, typing {bind:{cmd:view ado dir}}
would show a list of files you have installed.

{phang}
{cmd:view} {cmd:update} does the same as the {helpb update} command but
displays the result in the Viewer.  Typing {bind:{cmd:view update}} would show
the dates of what you have installed, and from there you could click to
compare those dates with the latest updates available.  Typing 
{bind:{cmd:view update query}} would skip the first step and show the
comparison.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R viewRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt asis}, allowed with {cmd:view} {cmd:file}, specifies that the file be
displayed as text, regardless of the {it:filename}'s extension.
{cmd:view} {cmd:file}'s default action is to display files ending in {hi:.smcl}
and {hi:.sthlp} as SMCL; see {manhelp smcl P}.

{phang}
{opt adopath}, allowed with {cmd:view} {cmd:file}, specifies that Stata search 
the S_ADO path for {it:filename} and display it, if found.


{marker remarks}{...}
{title:Remarks}

{pstd}
Most users access the Viewer by selecting {hi:File > View...} and proceeding
from there.  Some commands allow you to skip that step.  Some common
interactive uses of commands that display their results in the Viewer are
the following:

	{cmd:. view mysession.smcl}
	{cmd:. view mysession.log}

	{cmd:. help print}
	{cmd:. help regress}

	{cmd:. search hausman test}

	{cmd:. view net}
	{cmd:. view ado}

	{cmd:. view update query}
