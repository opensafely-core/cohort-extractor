{smcl}
{* *! version 1.2.3  19oct2017}{...}
{viewerdialog help "help_d"}{...}
{vieweralsosee "[R] help" "mansection R help"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "help advice" "help help_advice"}{...}
{vieweralsosee "[R] net search" "help net_search"}{...}
{vieweralsosee "[R] search" "help search"}{...}
{viewerjumpto "Syntax" "help##syntax"}{...}
{viewerjumpto "Menu" "help##menu"}{...}
{viewerjumpto "Description" "help##description"}{...}
{viewerjumpto "Links to PDF documentation" "help##linkspdf"}{...}
{viewerjumpto "Options" "help##options"}{...}
{viewerjumpto "Remarks" "help##remarks"}{...}
{viewerjumpto "Video example" "help##video"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[R] help} {hline 2}}Display help in Stata{p_end}
{p2col:}({mansection R help:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{hline}

{title:Stata's help system}

{pstd}
There are several kinds of help available to the Stata user. For more
information, see {help help_advice:Advice on getting help}.
The information below is technical details about Stata's {cmd:help} command.

{hline}

{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmdab:h:elp} [{it:command_or_topic_name}] [{cmd:,}
{opt non:ew}
{opt name(viewername)}
{opt mark:er(markername)}]


{marker menu}{...}
{title:Menu}

{phang}
{bf:Help > Stata command...}


{marker description}{...}
{title:Description}

{pstd}
The {cmd:help} command displays help information about the specified command
or topic.  {cmd:help} launches a new Viewer to display help for the specified
command or topic or displays help on the console in Stata for Unix(console).
If {cmd:help} is not followed by a command or a topic name, Stata displays
advice for using the help system and documentation.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R helpRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt nonew} specifies that a new Viewer window not be opened for the help
topic if a Viewer window is already open.  The default is for a new Viewer
window to be opened each time {cmd:help} is typed so that multiple help files
may be viewed at once.  {cmd:nonew} causes the help file to be displayed in
the topmost open Viewer.

{phang}
{opt name(viewername)} specifies that help be displayed in a Viewer window
named {it:viewername}.  If the named window already exists, its contents
will be replaced.  If the named window does not exist, it will be created.

{phang}
{opt marker(markername)} specifies that the help file be opened to the
position of {it:markername} within the help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
To obtain help for any Stata command, type {cmd:help} {it:command} or
select {bf:Help > Stata command...} and fill in {it:command}.

{pstd}
{cmd:help} is best explained by examples.

{p2colset 11 47 49 2}{...}
{p2col 9 45 49 2: To obtain help for ...}type{p_end}
{p2col: {cmd:regress}}{cmd:help regress}{p_end}
{p2col: postestimation tools for {cmd:regress}}{cmd:help regress postestimation}{p_end}
{p2col:}or{space 2} {cmd:help regress post}{p_end}
{p2col: graph option {cmd:xlabel()}}{cmd:help graph xlabel()}{p_end}
{p2col: Stata function {cmd:strpos()}}{cmd:help strpos()}{p_end}
{p2col: Mata function {cmd:optimize()}}{cmd:help mata optimize()}{p_end}
{p2colreset}{...}

{pstd}
Tips:

{phang2}
o {cmd:help} displays advice for using the help system and documentation.

{phang2}
o {cmd:help guide} displays a table of contents for basic Stata concepts.

{phang2}
o {cmd:help estimation commands} displays an alphabetical listing of all Stata
estimation commands.

{phang2}
o {cmd:help functions} displays help on Stata functions by category.

{phang2}
o {cmd:help mata functions} displays a subject table of contents for Mata's
functions.

{phang2}
o {cmd:help ts glossary} displays the glossary for the time-series manual,
and similarly for the other Stata specialty manuals.

{pstd}
If you type {cmd:help} {it:topic} and help for {it:topic} is not found,
Stata will automatically perform a search for {it:topic}.

{pstd}
For instance, try typing {cmd:help forecasting}.  A forecasting
help file is not found, so Stata executes {cmd:search forecasting}
and displays the results in the Viewer.

{pstd}
See {findalias frhelp} for a complete
description of how to use {cmd:help}.
{p_end}


{marker video}{...}
{title:Video example}

{phang}
{browse "http://www.youtube.com/watch?v=UpXNMeTzmuI":Quick help in Stata}
{p_end}
