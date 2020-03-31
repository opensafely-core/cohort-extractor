{smcl}
{* *! version 1.1.7  19oct2017}{...}
{vieweralsosee "[G-2] graph dir" "mansection G-2 graphdir"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph manipulation" "help graph_manipulation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph describe" "help graph_describe"}{...}
{viewerjumpto "Syntax" "graph_dir##syntax"}{...}
{viewerjumpto "Description" "graph_dir##description"}{...}
{viewerjumpto "Links to PDF documentation" "graph_dir##linkspdf"}{...}
{viewerjumpto "Options" "graph_dir##options"}{...}
{viewerjumpto "Remarks" "graph_dir##remarks"}{...}
{viewerjumpto "Stored results" "graph_dir##results"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[G-2] graph dir} {hline 2}}List names of graphs in memory and on disk{p_end}
{p2col:}({mansection G-2 graphdir:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 23 2}
{cmdab:gr:aph}
{cmd:dir}
[{it:pattern}]
[{cmd:,}
{it:options}]

{pstd}
where {it:pattern} is allowed by Stata's {cmd:strmatch()} function:
{cmd:*} means that 0 or more characters go here, and {cmd:?}{space 1}means
that exactly one character goes here; see {helpb strmatch()}.

{synoptset 20}{...}
{synopthdr}
{synoptline}
{p2col:{cmdab:m:emory}}
	list only graphs stored in memory{p_end}
{p2col:{cmdab:g:ph}}
	list only graphs stored on disk{p_end}
{p2col:{cmdab:d:etail}}
	produce detailed listing{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:graph} {cmd:dir} lists the names of graphs stored in memory and
stored on disk in the current directory.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphdirQuickstart:Quick start}

        {mansection G-2 graphdirRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:memory} and {cmd:gph}
    restrict what is listed; {cmd:memory} lists only the names of graphs
    stored in memory and {cmd:gph} lists only the names of graphs stored on
    disk.

{phang}
{cmd:detail}
    specifies that, in addition to the names, the commands that created the
    graphs be listed.


{marker remarks}{...}
{title:Remarks}

{pstd}
See {manhelp graph_manipulation G-2:graph manipulation} for an introduction to
the graph manipulation commands.

{pstd}
{cmd:graph} {cmd:dir} without options lists in column format
the names of the graphs stored in memory and those stored on disk in
the current directory.

	{cmd}. graph dir
{res}{col 13}Graph{col 24}figure1.gph{col 41}large.gph{col 55}s7.gph
{col 13}dot.gph{col 24}figure2.gph{col 41}old.gph{col 55}yx_lines.gph{txt}

{pstd}
Graphs in memory are listed first, followed by graphs stored on disk.
In the example above, we have only one graph in memory:  {cmd:Graph}.

{pstd}
You may specify a pattern to restrict the files listed:

	{cmd}. graph dir fig*
{res}{col 13}figure1.gph{col 26}figure2.gph{txt}

{pstd}
The {cmd:detail} option lists the names and the commands that drew the
graphs:

	{cmd}. graph dir fig*, detail

	{txt}  name{col 24}command
	  {hline 60}
	{res}  figure1.gph{...}
{col 24}{...}
{txt}matrix  h-tempjul, msy(p) name(myview)
	{res}  figure2.gph{...}
{col 24}{...}
{txt}twoway scatter mpg weight, saving(figure2)
	  {hline 60}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:graph} {cmd:dir} returns in macro {cmd:r(list)} the names of the
graphs.
{p_end}
