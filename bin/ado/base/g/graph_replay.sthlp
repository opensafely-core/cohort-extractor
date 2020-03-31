{smcl}
{* *! version 1.0.6  19oct2017}{...}
{viewerdialog "graph replay" "dialog graph_replay"}{...}
{vieweralsosee "[G-2] graph replay" "mansection G-2 graphreplay"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph close" "help graph_close"}{...}
{vieweralsosee "[G-2] graph display" "help graph_display"}{...}
{vieweralsosee "[G-2] graph manipulation" "help graph_manipulation"}{...}
{vieweralsosee "[G-2] graph use" "help graph_use"}{...}
{viewerjumpto "Syntax" "graph_replay##syntax"}{...}
{viewerjumpto "Menu" "graph_replay##menu"}{...}
{viewerjumpto "Description" "graph_replay##description"}{...}
{viewerjumpto "Links to PDF documentation" "graph_replay##linkspdf"}{...}
{viewerjumpto "Options" "graph_replay##options"}{...}
{viewerjumpto "Remarks" "graph_replay##remarks"}{...}
{viewerjumpto "Stored results" "graph_replay##results"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[G-2] graph replay} {hline 2}}Replay multiple graphs{p_end}
{p2col:}({mansection G-2 graphreplay:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Replay named graphs in memory

{p 8 23 2}
{cmdab:gr:aph}
{cmd:replay}
{it:name}
[{it:name} ...]
[{cmd:,}
{it:options}]


{pstd}
Replay all graphs in memory

{p 8 23 2}
{cmdab:gr:aph}
{cmd:replay}
[{cmd:_all}]
[{cmd:,}
{it:options}]


{phang}
{it:name} is the name of a graph stored in memory or on disk or the partial
name of a graph stored in memory or on disk with the {cmd:?} and {cmd:*}
wildcard characters.

{synoptset 12}{...}
{synopthdr}
{synoptline}
{p2col:{opt noclose}}do not close Graph window of the replayed graph when the
    next graph for replay is displayed{p_end}
{synopt :{opt wait}}pause until the {hline 2}{cmd:more}{hline 2} condition is cleared{p_end}
{p2col:{opt sleep(#)}}delay showing the next graph for {it:#} seconds; default
    is {cmd:sleep(3)}{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Manage graphs > Replay multiple graphs}


{marker description}{...}
{title:Description}

{pstd}
{cmd:graph} {cmd:replay} displays graphs stored in memory and stored on disk
in the current directory.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphreplayQuickstart:Quick start}

        {mansection G-2 graphreplayRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:noclose} specifies that the Graph window of a replayed graph not be
closed when the next graph for replay is displayed.

{phang}
{opt wait} causes {cmd:graph replay} to display {hline 2}{cmd:more}{hline 2}
and pause until any key is pressed before producing the next graph.
{opt wait} temporarily ignores the global setting that is specified
using {cmd:set more off}.

{phang}
{cmd:sleep()} specifies the number of seconds for {cmd:graph replay} to wait
before displaying the next graph.  The default is {cmd:sleep(3)}.


{marker remarks}{...}
{title:Remarks}

{pstd}
See {manhelp graph_manipulation G-2:graph manipulation} for an introduction to
the graph manipulation commands.

{pstd}
{cmd:graph} {cmd:replay} without {it:name} displays graphs in
memory named {cmd:Graph__1}, {cmd:Graph__2}, and so on, if they exist.
{cmd:graph} {cmd:replay} {cmd:_all} is equivalent.

{pstd}
You may specify a list of graph names (both in memory and on disk) to be
displayed:

	{cmd:. graph replay Graph1 Graph5 mygraph.gph}

{pstd}
You may specify a pattern for graph names (both in memory and on disk):

	{cmd:. graph replay Graph* fig*.gph}

{pstd}
You may combine the above two specifications:

	{cmd:. graph replay Graph1 Graph5 mygraph.gph Graph* fig*.gph}

{pstd}
By default, {cmd:graph replay} pauses for three seconds before displaying the
next graph.  You can use the {cmd:sleep()} option to change the delay
interval.  {cmd:sleep(0)} means no delay.

{pstd}
You can use the {cmd:wait} option to cause {cmd:graph replay} to display
{hline 2}{cmd:more}{hline 2} and wait until any key is pressed before
displaying the next graph.

{pstd}
By default, Graph windows of the replayed graphs are closed as the next graph
for replay is displayed.  You can specify {cmd:noclose} to prevent the Graph
windows from closing.  You can then close the windows yourself when desired.


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:graph} {cmd:replay} stores the following in {cmd:r()}:

{synoptset 14 tabbed}{...}
{p2col 5 14 18 2: Macro}{p_end}
{synopt:{cmd:r(list)}}names of the replayed graphs{p_end}
{p2colreset}{...}
