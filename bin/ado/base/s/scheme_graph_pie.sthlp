{smcl}
{* *! version 1.0.3  11feb2011}{...}
{vieweralsosee "scheme graph shared" "help scheme graph shared"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Scheme entries for graph pie}

{p 3 3 2}
These settings control the overall look of graphs created by 
{helpb graph pie}.

{p 3 3 2}
The entries are presented under the following headings:

{p 8 12 0}{help scheme_graph_pie##remarks1:Graph region}{p_end}
{p 8 12 0}{help scheme_graph_pie##remarks2:Plot region}{p_end}
{p 8 12 0}{help scheme_graph_pie##remarks3:Construction of graphs}

{p 3 3 2}
For entries that control the appearance of pie slices plotted by 
{cmd:graph pie}, see {help scheme pie plots}.  In addition,
pie graphs share some appearance characteristics with all
other graphs; see {help scheme graph shared} to change these settings.


{marker remarks1}{...}
{title:Graph region}

{p2colset 4 44 47 0}{...}
{p 3 3 2}
These composite entries specify the look of the area into which the whole pie
graph is drawn.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:areastyle {space 0}piegraph}       {space 6}{it:{help areastyle}}}
	overall graph region; usual default is {cmd:background}{p_end}
{p2col:{cmd:areastyle {space 0}inner_piegraph} {space 0}{it:{help areastyle}}}
	inner graph region; usual default is {cmd:none}{p_end}
{p2col:{cmd:margin    {space 3}piegraph}       {space 6}{it:{help marginstyle}}}
	margin between overall and inner graph{p_end}
{p2line}


{marker remarks2}{...}
{title:Plot region}

{p2colset 4 52 55 0}{...}
{p 3 3 2}
These entries specify the look of plot regions for pie graphs.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:areastyle       {space 0}piegraph_region}        {space 8}{it:{help areastyle}}}
	overall plot region areastyle; usual default is {cmd:none} (*){p_end}
{p2col:{cmd:areastyle       {space 0}inner_pieregion}        {space 8}{it:{help areastyle}}}
	inner plot region areastyle; usual default is {cmd:none} (*){p_end}
{p2col:{cmd:margin          {space 11}piegraph_region} {space 0}{it:{help marginstyle}}}
	plot region margin{p_end}
{p2col:{cmd:plotregionstyle {space 2}piegraph}    {space 3}{it:{help plotregionstyle}}}
	inner region (*){p_end}
{p2line}
{p 3 7 0}(*) Composite entry.


{marker remarks3}{...}
{title:Construction of graphs}

{p2colset 4 37 40 0}{...}
{p 3 3 2}
This composite entry controls the overall look and construction of pie
graphs and is rarely changed.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:piegraphstyle piegraph}    {space 1}{it:{help bystyle}}}
	overall style{p_end}
{p2line}
{p2colreset}{...}
