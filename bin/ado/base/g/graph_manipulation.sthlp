{smcl}
{* *! version 1.2.4  15may2018}{...}
{vieweralsosee "[G-2] graph manipulation" "mansection G-2 graphmanipulation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph save" "help graph_save"}{...}
{vieweralsosee "[G-3] name_option" "help name_option"}{...}
{vieweralsosee "[G-3] saving_option" "help saving_option"}{...}
{vieweralsosee "[G-4] Concept: gph files" "help gph_files"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] clear" "help clear"}{...}
{vieweralsosee "[P] discard" "help discard"}{...}
{vieweralsosee "[D] drop" "help drop"}{...}
{viewerjumpto "Syntax" "graph manipulation##syntax"}{...}
{viewerjumpto "Description" "graph manipulation##description"}{...}
{viewerjumpto "Links to PDF documentation" "graph_manipulation##linkspdf"}{...}
{viewerjumpto "Remarks" "graph manipulation##remarks"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[G-2] graph manipulation} {hline 2}}Graph manipulation commands{p_end}
{p2col:}({mansection G-2 graphmanipulation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 20}{...}
{p2col:Command}
	Description{p_end}
{p2line}
{p2col:{helpb graph dir}}
	list names of graphs{p_end}
{p2col:{helpb graph describe}}
	describe contents of graph{p_end}
{p2col:{helpb graph drop}}
	discard graph stored in memory{p_end}
{p2col:{helpb graph close}}
	close Graph window{p_end}
{p2col:{helpb graph rename}}
	rename graph stored in memory{p_end}
{p2col:{helpb graph copy}}
	copy graph stored in memory{p_end}
{p2col:{helpb graph export}}
	export current graph{p_end}

{p2col:{helpb graph use}}
	load graph on disk into memory and display it{p_end}
{p2col:{helpb graph display}}
	redisplay graph stored in memory{p_end}
{p2col:{helpb graph combine}}
	combine multiple graphs{p_end}
{p2col:{helpb graph replay}}
	redisplay graphs stored in memory and on disk{p_end}
{p2line}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The graph manipulation commands manipulate graphs stored in memory or
stored on disk.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphmanipulationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help graph manipulation##remarks1:Overview of graphs in memory and graphs on disk}
	{help graph manipulation##remarks2:Summary of graph manipulation commands}


{marker remarks1}{...}
{title:Overview of graphs in memory and graphs on disk}

{pstd}
Graphs are stored in memory and on disk.  When you draw a graph, such as
by typing

	{cmd:. graph twoway scatter mpg weight}

{pstd}
the resulting graph is stored in memory, and, in particular, it is stored under
the name {cmd:Graph}.  Were you next to type

	{cmd:. graph matrix mpg weight displ}

{pstd}
this new graph would replace the existing graph named {cmd:Graph}.

{pstd}
{cmd:Graph} is the default name used to record graphs in memory, and when you
draw graphs, they replace what was previously recorded in {cmd:Graph}.

{pstd}
You can specify the {cmd:name()} option -- see
 {manhelpi name_option G-3} -- to record graphs under different names:

	{cmd:. graph twoway scatter mpg weight, name(scat)}

{pstd}
Now there are two graphs in memory:  {cmd:Graph}, containing a scatterplot
matrix, and {cmd:scat}, containing a graph of mpg versus weight.

{pstd}
Graphs in memory are forgotten when you exit Stata, and they are forgotten at
other times, too, such as when you type {cmd:clear} or {cmd:discard}; see 
{manhelp drop D} and {manhelp discard P}.

{pstd}
Graphs can be stored on disk, where they will reside permanently until you
erase them.  They are saved in files known as {cmd:.gph} files -- files
whose names end in {cmd:.gph}; see {help gph files}.

{pstd}
You can save on disk the graph currently showing in the Graph window by typing

	{cmd:. graph save mygraph.gph}

{pstd}
The result is to create a new file {cmd:mygraph.gph}; see 
{manhelp graph_save G-2:graph save}.  Or -- see {manhelpi saving_option G-3} --
you can save on disk graphs when you originally draw them:

	{cmd:. graph twoway scatter mpg weight, saving(mygraph.gph)}

{pstd}
Either way, graphs saved on disk can be reloaded:

	{cmd:. graph use mygraph.gph}

{pstd}
loads {cmd:mygraph.gph} into memory under the name -- you guessed it --
{cmd:Graph}.  Of course, you could load it under a different name:

	{cmd:. graph use mygraph.gph, name(memcp)}

{pstd}
Having brought this graph back into memory, you find that things are just as
if you had drawn the graph for the first time.  Anything you could do back
then -- such as combine the graph with other graphs or change its aspect
ratio -- you can do now.  And, of course, after making any changes, you
can save the result on disk, either replacing file {cmd:mygraph.gph} or saving
it under a new name.

{pstd}
There is only one final, and minor, wrinkle:  graphs on disk can be saved
in either of two formats, known as {cmd:live} and {cmd:asis}.  {cmd:live} is
preferred and is the default, and what was said above applies only to
{cmd:live}-format files.  {cmd:asis} files are more like pictures -- all
you can do is admire them and make copies.  To save a file in {cmd:asis}
format, you type

	{cmd:. graph save} ...{cmd:, asis}
    or
	{cmd:. graph} ...{cmd:,} ... {cmd:saving(}...{cmd:, asis)}

{pstd}
{cmd:asis} format is discussed in {help gph files}.

{pstd}
There is a third format called {cmd:old}, which is like {cmd:asis}, except
that it refers to graphs made by versions of Stata older than Stata 8.
This is discussed in {help gph files}, too.


{marker remarks2}{...}
{title:Summary of graph manipulation commands}

{pstd}
The graph manipulation commands help you manage your graphs, whether stored
in memory or on disk.  The commands are

{phang2}
    {cmd:graph dir}{break}
	Lists the names under which graphs are stored, both in memory
	and on disk;
	see {manhelp graph_dir G-2:graph dir}.

{phang2}
    {cmd:graph describe}{break}
	Provides details about a graph, whether stored in memory or on disk;
	see {manhelp graph_describe G-2:graph describe}.

{phang2}
    {cmd:graph drop}{break}
	Eliminates from memory graphs stored there;
	see {manhelp graph_drop G-2:graph drop}.

{phang2}
    {cmd:graph close}{break}
	Closes Graph windows;
	see {manhelp graph_close G-2:graph close}.

{phang2}
    {cmd:graph rename}{break}
	Changes the name of a graph stored in memory;
	see {manhelp graph_rename G-2:graph rename}.

{phang2}
    {cmd:graph copy}{break}
	Makes a copy of a graph stored in memory;
	see {manhelp graph_copy G-2:graph copy}.

{phang2}
    {cmd:graph export}{break}
        Exports the graph currently displayed in the Graph window to a file;
	see {manhelp graph_export G-2:graph export}.

{phang2}
    {cmd:graph use}{break}
	Copies a graph on disk into memory and displays it;
	see {manhelp graph_use G-2:graph use}.

{phang2}
    {cmd:graph display}{break}
	Redisplays a graph stored in memory;
	see {manhelp graph_display G-2:graph display}.

{phang2}
    {cmd:graph combine}{break}
	Combines graphs stored in memory or on disk;
	see {manhelp graph_combine G-2:graph combine}.{p_end}

{phang2}
    {cmd:graph replay}{break}
	Redisplays graphs stored in memory and on disk;
	see {manhelp graph_replay G-2:graph replay}.{p_end}
