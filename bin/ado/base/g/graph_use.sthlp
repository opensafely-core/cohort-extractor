{smcl}
{* *! version 1.2.9  15may2018}{...}
{vieweralsosee "[G-2] graph use" "mansection G-2 graphuse"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph combine" "help graph_combine"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph replay" "help graph_replay"}{...}
{vieweralsosee "[G-2] graph save" "help graph_save"}{...}
{vieweralsosee "[G-3] saving_option" "help saving_option"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] name_option" "help name_option"}{...}
{vieweralsosee "[G-4] Concept: gph files" "help gph_files"}{...}
{viewerjumpto "Syntax" "graph_use##syntax"}{...}
{viewerjumpto "Description" "graph_use##description"}{...}
{viewerjumpto "Links to PDF documentation" "graph_use##linkspdf"}{...}
{viewerjumpto "Options" "graph_use##options"}{...}
{viewerjumpto "Remarks" "graph_use##remarks"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[G-2] graph use} {hline 2}}Display graph stored on disk{p_end}
{p2col:}({mansection G-2 graphuse:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 30 2}
{cmdab:gr:aph}
{cmd:use}
{it:{help filename}}
[{cmd:,} {it:options}]


{synoptset 23}{...}
{synopthdr :options}
{synoptline}
{synopt:{opt nodraw}}do not draw the graph{p_end}
{synopt:{cmdab:name(}{it:name} [{cmd:, replace}]{cmd:)}}specify new name 
	for graph{p_end}
{synopt:{helpb scheme_option:{ul:sch}eme({it:schemename})}}overall look{p_end}
{synopt:{cmdab:play(}{it:recordingname}{cmd:)}}play edits from 
	{it:recordingname}{p_end}
{synoptline}


{marker description}{...}
{title:Description}

{pstd}
{cmd:graph} {cmd:use} displays (draws) the graph previously saved in a
.gph file and, if the graph was stored in live format, loads it.

{pstd}
If {it:{help filename}} is specified without an extension, {cmd:.gph} is
assumed.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphuseQuickstart:Quick start}

        {mansection G-2 graphuseRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:nodraw}
    specifies that the graph not be displayed.
    If the graph was stored in live format, it is still loaded;
    otherwise, {cmd:graph} {cmd:use} does nothing.
    See {manhelpi nodraw_option G-3}.

{phang}
{cmd:name(}{it:name}[{cmd:, replace}]{cmd:)}
    specifies the name under which the graph is to be stored in memory,
    assuming that the graph was saved in live format.
    {it:{help filename}} is the default name, where any path component in
    {it:filename} is excluded.  For example, 

           {cmd:. graph use mydir\mygraph.gph}

{pmore}
    will draw a graph with the name {cmd:mygraph}.

{pmore}
    If the default name already exists {cmd:graph}{it:#} is used instead,
    where {it:#} is chosen to create a unique name.

{pmore}
    If the graph is not stored in
    live format, the graph can only be displayed, not loaded, and the
    {cmd:name()} is irrelevant.

{phang}
{cmd:scheme(}{it:schemename}{cmd:)}
    specifies the scheme controlling the overall look of the graph to be
    used; see {manhelpi scheme_option G-3}.  If {cmd:scheme()} is not
    specified, the default is the {it:schemename} recorded in the graph being
    loaded.

{phang}
INCLUDE help playopt_desc


{marker remarks}{...}
{title:Remarks}

{pstd}
Graphs can be saved at the time you draw them either by specifying the
{cmd:saving()} option or by subsequently using the {cmd:graph} {cmd:save}
command; see {manhelpi saving_option G-3} and
{manhelp graph_save G-2:graph save}.
Modern graphs are saved in live format or as-is format; see {help gph files}.
Regardless of how the graph was saved or the format in which it was saved,
{cmd:graph} {cmd:use} can redisplay the graph; simply type

	{cmd:. graph use} {it:filename}

{pstd}
In a prior session, you drew a graph by typing

	{cmd}. twoway qfitci  mpg weight, stdf ||
		 scatter mpg weight       ||
	  , by(foreign, total row(1)) saving(cigraph){txt}

{pstd}
The result of this was to create file {cmd:cigraph.gph}.  At a later date,
you can see the contents of the file by typing

	{cmd:. graph use cigraph}

{pstd}
You might now edit the graph (see {manhelp graph_editor G-1:Graph Editor}),
or print a copy of the graph.
{p_end}
