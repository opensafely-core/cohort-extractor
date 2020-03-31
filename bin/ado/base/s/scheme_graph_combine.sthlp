{smcl}
{* *! version 1.0.3  11feb2011}{...}
{vieweralsosee "scheme graph shared" "help scheme graph shared"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Scheme entries for graph combine}

{p 3 3 2}
These settings control the overall look of graphs created by 
{helpb graph combine}.

{p 3 3 2}
The entries are presented under the following headings:

{p 8 12 0}{help scheme_graph_combine##remarks1:Graph region}{p_end}
{p 8 12 0}{help scheme_graph_combine##remarks2:Plot region}{p_end}
{p 8 12 0}{help scheme_graph_combine##remarks3:Construction of graphs}

{p 3 3 2}
In addition, some characteristics of the appearance of combined graphs are
shared with all other graphs; see {help scheme graph shared} to change
these settings.


{marker remarks1}{...}
{title:Graph region}

{p2colset 4 44 47 0}{...}
{p 3 3 2}
These composite entries specify the look of the area into which the whole 
combine graph is drawn.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:areastyle combinegraph}       {space 6}{it:{help areastyle}}}
	overall graph region; usual default is {cmd:background}{p_end}
{p2col:{cmd:areastyle combinegraph_inner} {space 0}{it:{help areastyle}}}
	inner graph region; usual default is {cmd:none}{p_end}
{p2line}


{marker remarks2}{...}
{title:Plot region}

{p2colset 4 52 55 0}{...}
{p 3 3 2}
These entries specify the look of plot regions for combined graphs.  For
{helpb graph combine}, the plot region is the area into which the individual
graphs are drawn.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:areastyle       {space 0}combinegraph_plotregion}  {space 1}{it:{help areastyle}}}
	overall plot region areastyle; usual default {it:areastyle} is 
	{cmd:none} (*){p_end}
{p2col:{cmd:areastyle       {space 0}combinegraph_iplotregion} {space 0}{it:{help areastyle}}}
	inner plot region areastyle; usual default is {cmd:none} (*){p_end}
{p2col:{cmd:margin          {space 11}combinegraph}    {space 1}{it:{help marginstyle}}}
	plot region margin{p_end}
{p2col:{cmd:plotregionstyle {space 2}combinegraph}  {space 1}{it:{help plotregionstyle}}}
	overall style (*){p_end}
{p2col:{cmd:plotregionstyle {space 2}combineregion} {space 0}{it:{help plotregionstyle}}}
	interior region (*){p_end}
{p2line}
{p 3 7 0}(*) Composite entry.


{marker remarks3}{...}
{title:Construction of graphs}

{p2colset 4 37 40 0}{...}
{p 3 3 2}
This composite entry controls the overall look and construction of combined
graphs and is rarely changed.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:bygraphstyle combine}    {space 3}{it:{help bystyle}}}
	Overall style{p_end}
{p2line}
{p2colreset}{...}
