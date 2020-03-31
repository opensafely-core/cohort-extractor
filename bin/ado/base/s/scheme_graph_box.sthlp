{smcl}
{* *! version 1.0.3  11feb2011}{...}
{vieweralsosee "scheme box plots" "help scheme box plots"}{...}
{vieweralsosee "scheme graph shared" "help scheme graph shared"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Scheme entries that control graphs drawn by graph box}

{p 3 3 2}
These settings control the overall look of graphs drawn with {helpb graph box}
and {helpb graph hbox}.

{p 3 3 2}
The entries are presented under the following headings:

{p 8 12 0}{help scheme_graph_box##remarks1:Plot regions for graph box}{p_end}
{p 8 12 0}{help scheme_graph_box##remarks3:Plot regions for graph hbox}{p_end}
{p 8 12 0}{help scheme_graph_box##remarks3:Gaps between boxes}{p_end}

{p 3 3 2}
For entries that control the appearance of boxes plotted by {cmd:graph box}
and {cmd:graph hbox}, see {help scheme box plots}.  In addition, some
characteristics of the appearance of bar graphs are shared with all other
graphs; see {help scheme graph shared} to change these settings.


{marker remarks1}{...}
{space 3}{title:Plot regions for graph box}

{p2colset 4 49 52 0}{...}
{p 3 3 2}
These entries specify the look of plot regions for {helpb graph box}.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:areastyle       {space 0}box_plotregion}     {space 4}{it:{help areastyle}}}
	overall plot region areastyle;
	usual default {it:areastyle} is 
	{helpb scheme plotregion def:plotregion} (*){p_end}
{p2col:{cmd:areastyle       {space 0}box_iplotregion}    {space 3}{it:{help areastyle}}}
	inner plot region areastyle; usual default is {cmd:none} (*){p_end}
{p2col:{cmd:margin          {space 9}boxgraph}          {space 4}{it:{help marginstyle}}}
	plot region margin{p_end}
{p2col:{cmd:plotregionstyle {space 0}boxgraph}    {space 4}{it:{help plotregionstyle}}}
	plot region overall style; usual default is {cmd:plotregion} (*){p_end}
{p2line}
{p 3 7 0}(*) Composite entry.


{marker remarks2}{...}
{space 3}{title:Plot regions for graph hbox}

{p2colset 4 49 52 0}{...}
{p 3 3 2}
These entries specify the look of plot regions for {helpb graph hbox}.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:areastyle       {space 0}hbox_plotregion}    {space 3}{it:{help areastyle}}}
	overall plot region areastyle (*){p_end}
{p2col:{cmd:areastyle       {space 0}hbox_iplotregion}   {space 2}{it:{help areastyle}}}
	inner plot region areastyle (*){p_end}
{p2col:{cmd:margin          {space 9}hboxgraph}    {space 3}{it:{help marginstyle}}}
	plot region margin{p_end}
{p2col:{cmd:plotregionstyle {space 0}hboxgraph}   {space 3}{it:{help plotregionstyle}}}
	plot region overall style (*){p_end}
{p2line}
{p 3 7 0}(*) Composite entry.


{marker remarks3}{...}
{title:Gaps between boxes}

{p2colset 4 32 35 0}{...}
{p 3 3 2}
These entries specify the size of gaps between boxes.  All
values for {it:#}s are percentages of box width.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:relsize box_gap}      {space 8}{it:#}}
	distance between boxes not in an {cmd:over()} group{p_end}
{p2col:{cmd:relsize box_groupgap} {space 3}{it:#}}
	distance between boxes in the first {cmd:over()} group{p_end}
{p2col:{cmd:relsize box_supgroupgap} {space 0}{it:#}}
	distance between boxes in the second {cmd:over()} group{p_end}
{p2col:{cmd:relsize box_outergap} {space 3}{it:#}}
	distance between the outermost boxes and the left and right boundaries
	of the plot region{p_end}
{p2line}
{p2colreset}{...}
