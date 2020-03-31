{smcl}
{* *! version 1.1.14  19oct2017}{...}
{viewerdialog "graph describe" "dialog graph_describe"}{...}
{vieweralsosee "[G-2] graph describe" "mansection G-2 graphdescribe"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph manipulation" "help graph_manipulation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph dir" "help graph_dir"}{...}
{viewerjumpto "Syntax" "graph_describe##syntax"}{...}
{viewerjumpto "Menu" "graph_describe##menu"}{...}
{viewerjumpto "Description" "graph_describe##description"}{...}
{viewerjumpto "Links to PDF documentation" "graph_describe##linkspdf"}{...}
{viewerjumpto "Remarks" "graph_describe##remarks"}{...}
{viewerjumpto "Stored results" "graph_describe##results"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[G-2] graph describe} {hline 2}}Describe contents of graph in memory or on disk{p_end}
{p2col:}({mansection G-2 graphdescribe:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 23 2}
{cmdab:gr:aph}
{cmdab:des:cribe}
[{it:name}]

{synoptset 20}{...}
{synopt :{it:name}}Description{p_end}
{p2line}
{synopt :{it:simplename}}name of graph in memory{p_end}
{synopt :{it:{help filename}}{cmd:.gph}}name of graph on disk{p_end}
{synopt :{cmd:"}{it:{help filename}}{cmd:"}}name of graph on disk{p_end}
{p2line}

{pstd}
If {it:name} is not specified, the graph currently displayed in the Graph
window is described.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Manage graphs > Describe graph}


{marker description}{...}
{title:Description}

{pstd}
{cmd:graph} {cmd:describe} describes the contents of a graph in memory
or a graph stored on disk.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphdescribeQuickstart:Quick start}

        {mansection G-2 graphdescribeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
See {manhelp graph_manipulation G-2:graph manipulation} for an introduction to
the graph manipulation commands.

{pstd}
{cmd:graph} {cmd:describe} describes the contents of a graph, which
may be stored in memory or on disk.  Without arguments, the graph stored
in memory named {cmd:Graph} is described:

        {cmd:. sysuse auto}

	{cmd:. scatter mpg weight}

	{cmd}. graph describe

	{txt}{title:Graph stored {txt}in memory{txt}}

{p 16 15}
name:
{res}Graph
{p_end}
{txt}{p 14 15}
format:
{res}live
{p_end}
{txt}{p 13 15}
created:
{res}9 May 2016 14:26:12
{p_end}
{txt}{p 14 15}
scheme:
{res}default
{p_end}
{txt}{p 16 15}
size:
{res}4 {txt:{it:x}} 5.5
{p_end}
{txt}{p 12 15}
dta file:
{res}auto.dta
{txt}dated
{res}13 Apr 2016 17:45
{p_end}
{txt}{p 13 15}
command:
{res}twoway scatter mpg weight{txt}
{p_end}

{pstd}
In the above, the size is reported as {it:ysize} {it:x} {it:xsize},
not the other way around.

{pstd}
When you type a name ending in {cmd:.gph}, the disk file is described:

	{cmd:. graph save myfile}

	{cmd:. graph describe myfile.gph}

	{txt}{title:myfile.gph stored {txt}on disk{txt}}

{p 16 15}
name:
{res}myfile.gph
{p_end}
{txt}{p 14 15}
format:
{res}live
{p_end}
{txt}{p 13 15}
created:
{res}9 May 2016 14:26:12
{p_end}
{txt}{p 14 15}
scheme:
{res}default
{p_end}
{txt}{p 16 15}
size:
{res}4 {txt:{it:x}} 5.5
{p_end}
{txt}{p 12 15}
dta file:
{res}auto.dta
{txt}dated
{res}13 Apr 2016 17:45
{p_end}
{txt}{p 13 15}
command:
{res}twoway scatter mpg weight
{p_end}
{txt}

{pstd}
If the file is saved in {cmd:asis} format -- see 
{help gph files} -- only the name and format are listed:

	{cmd:. graph save picture, asis}

	{cmd:. graph describe picture.gph}

	{txt}{title:picture.gph stored {txt}on disk{txt}}

{p 16 15}
name:
{res}picture.gph
{p_end}
{txt}{p 14 15}
format:
{res}asis{txt}
{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:graph describe} stores the following in {cmd:r()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Macros}{p_end}
{synopt:{cmd:r(fn)}}{it:filename} or {it:filename}{cmd:.gph}{p_end}
{synopt:{cmd:r(ft)}}"{cmd:old}", "{cmd:asis}", or "{cmd:live}"{p_end}

{pstd}
and, if {cmd:r(ft)}=="{cmd:live}",

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Macros}{p_end}
{synopt:{cmd:r(command)}}command{p_end}
{synopt:{cmd:r(family)}}subcommand; {cmd:twoway}, {cmd:matrix}, {cmd:bar},
         {cmd:dot}, {cmd:box}, or {cmd:pie}{p_end}
{synopt:{cmd:r(command_date)}}date on which command was run{p_end}
{synopt:{cmd:r(command_time)}}time at which command was run{p_end}

{synopt:{cmd:r(scheme)}}scheme name{p_end}
{synopt:{cmd:r(ysize)}}{cmd:ysize()} value{p_end}
{synopt:{cmd:r(xsize)}}{cmd:xsize()} value{p_end}

{synopt:{cmd:r(dtafile)}}{cmd:.dta} file in memory at command_time{p_end}
{synopt:{cmd:r(dtafile_date)}}{cmd:.dta} file date{p_end}

{pstd}
Any of {cmd:r(command)}, ..., {cmd:r(dtafile_date)}
may be undefined, so refer to contents by using macro quoting.{p_end}
{p2colreset}{...}
