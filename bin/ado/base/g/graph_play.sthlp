{smcl}
{* *! version 1.1.7  15may2018}{...}
{vieweralsosee "[G-2] graph play" "mansection G-2 graphplay"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-1] Graph Editor" "help graph_editor##recorder"}{...}
{vieweralsosee "[G-3] play_option" "help play_option"}{...}
{viewerjumpto "Syntax" "graph play##syntax"}{...}
{viewerjumpto "Description" "graph play##description"}{...}
{viewerjumpto "Links to PDF documentation" "graph_play##linkspdf"}{...}
{viewerjumpto "Remarks" "graph play##remarks"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[G-2] graph play} {hline 2}}Apply edits from a recording on
current graph{p_end}
{p2col:}({mansection G-2 graphplay:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 30 2}
{cmdab:gr:aph}
{cmd:play}
{it:recordingname}


{marker description}{...}
{title:Description}

{pstd}
{cmd:graph} {cmd:play} applies edits that were previously recorded using the
Graph Recorder to the current graph.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphplayRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Edits made in the Graph Editor (see {manhelp graph_editor G-1:Graph Editor})
can be saved as a
recording and the edits subsequently played on another graph.  In addition to
being played from the Graph Editor, these recordings can be played on the
currently active graph using the command {cmd:graph} {cmd:play}
{it:recordingname}.

{pstd}
If you have previously created a recording named {cmd:xyz}, you can replay the
edits from that recording on your currently active graph by typing

	{cmd:. graph play xyz}

{pstd}
To learn about creating recordings, see 
{it:{help graph_editor##recorder:Graph Recorder}} in
{manhelp graph_editor G-1:Graph Editor}.
{p_end}
