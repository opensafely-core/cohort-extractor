{smcl}
{* *! version 1.0.5  01mar2017}{...}
{vieweralsosee "scheme bar plots" "help scheme bar plots"}{...}
{vieweralsosee "scheme graph shared" "help scheme graph shared"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Scheme entries that control graphs drawn by graph bar}

{p 3 3 2}
These settings control the overall look of graphs drawn with {helpb graph bar}
and {helpb graph hbar}; they do not affect graphs drawn with {helpb twoway bar}.

{p 3 3 2}
The entries are presented under the following headings:

{p 8 12 0}{help scheme_graph_bar##remarks1:Plot regions for graph bar}{p_end}
{p 8 12 0}{help scheme_graph_bar##remarks2:Plot regions for graph hbar}{p_end}
{p 8 12 0}{help scheme_graph_bar##remarks3:Added bar labels}{p_end}
{p 8 12 0}{help scheme_graph_bar##remarks4:Gaps between bars}{p_end}
{p 8 12 0}{help scheme_graph_bar##remarks5:Overall look of sets of bars}

{p 3 3 2}
For entries that control the appearance of bars plotted by {cmd:graph bar},
{cmd:graph hbar}, and {cmd:twoway bar}, see {help scheme bar plots}.  In
addition, some characteristics of the appearance of bar graphs are shared with
all other graphs; see {help scheme graph shared} to change these
settings.


{marker remarks1}{...}
{space 3}{title:Plot regions for graph bar}

{p2colset 4 49 52 0}{...}
{p 3 3 2}
These entries specify the look of plot regions for {helpb graph bar}.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:areastyle       {space 0}bar_plotregion}     {space 4}{it:{help areastyle}}}
	overall plot region areastyle;
	usual default {it:areastyle} is 
	{helpb scheme plotregion def:plotregion} (*){p_end}
{p2col:{cmd:areastyle       {space 0}bar_iplotregion}    {space 3}{it:{help areastyle}}}
	inner plot region areastyle; usual default is {cmd:none} (*){p_end}
{p2col:{cmd:margin          {space 9}bargraph}          {space 4}{it:{help marginstyle}}}
	plot region margin{p_end}
{p2col:{cmd:plotregionstyle {space 0}bargraph}    {space 4}{it:{help plotregionstyle}}}
	plot region overall style; usual default is {cmd:plotregion} (*){p_end}
{p2line}
{p 3 7 0}(*) Composite entry.


{marker remarks2}{...}
{space 3}{title:Plot regions for graph hbar}

{p2colset 4 49 52 0}{...}
{p 3 3 2}
These entries specify the look of plot regions for {helpb graph hbar}.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:areastyle       {space 0}hbar_plotregion}    {space 3}{it:{help areastyle}}}
	overall plot region areastyle (*){p_end}
{p2col:{cmd:areastyle       {space 0}hbar_iplotregion}   {space 2}{it:{help areastyle}}}
	inner plot region areastyle (*){p_end}
{p2col:{cmd:margin          {space 9}hbargraph}    {space 3}{it:{help marginstyle}}}
	plot region margin{p_end}
{p2col:{cmd:plotregionstyle {space 0}hbargraph}   {space 3}{it:{help plotregionstyle}}}
	plot region overall style (*){p_end}
{p2line}
{p 3 7 0}(*) Composite entry.


{marker remarks3}{...}
{title:Added bar labels}

{p2colset 4 37 40 0}{...}
{p 3 3 2}
These entries determine the look of bar labels added with the {cmd:blabel()} command.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:barlabelpos bar}   {space 4}{it:labelpos}} 
        location of added labels on bar charts; {it:labelpos} may be
        one of {cmd:inside}, {cmd:outside}, {cmd:center}, or {cmd:base};
	other styles may be available; type{break}
	{stata graph query barlabelpos} to see the full list{p_end}
{p2col:{cmd:barlabelstyle bar} {space 2}{it:labeltype}} 
        default labeling of bars; {it:labeltype} may be one of {cmd:none},
        {cmd:bar}, {cmd:total}, {cmd:name}, or {cmd:group}; see 
	{manhelpi blabel_option G-3} for more information; other styles may be 
	available; type{break} 
        {stata graph query barlabelstyle} to see the full list{p_end}
{p2col:{cmd:gsize {space 0}barlabel_gap}         {space 0}{it:{help textsizestyle}}}
	added distance between bars and their labels{p_end}
{p2line}


{marker remarks4}{...}
{title:Gaps between bars}

{p2colset 4 32 35 0}{...}
{p 3 3 2}
These entries specify the size of gaps between bars for bar charts.  All
values for {it:#}s are percentages of bar width.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:relsize bar_gap}      {space 8}{it:#}}
	distance between bars not in an {cmd:over()} group{p_end}
{p2col:{cmd:relsize bar_groupgap} {space 3}{it:#}}
	distance between bars in the first {cmd:over()} group{p_end}
{p2col:{cmd:relsize bar_supgroupgap} {space 0}{it:#}}
	distance between bars in the second {cmd:over()} group{p_end}
{p2col:{cmd:relsize bar_outergap} {space 3}{it:#}}
	distance between the outermost bars and the left and right boundaries
	of the plot region{p_end}
{p2line}


{marker remarks5}{...}
{title:Overall look of sets of bars}

{p2colset 4 37 40 0}{...}
{p 3 3 2}
This composite entry controls the overall look of sets of bars.  It should
rarely be changed; instead change the individual elements in other
entries.{break} 
Type {stata graph query barstyle} to see available options for {it:barstyle}.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:barstyle default}     {space 2}{it:barstyle}}
	overall look of sets of bars{p_end}
{p2line}
{p2colreset}{...}
