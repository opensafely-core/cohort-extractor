{smcl}
{* *! version 1.0.4  01mar2017}{...}
{vieweralsosee "scheme dot plots" "help scheme dot plots"}{...}
{vieweralsosee "scheme graph shared" "help scheme graph shared"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Scheme entries that control graphs drawn by graph dot}

{p 3 3 2}
These settings control the overall look of graphs drawn with {helpb graph dot}.

{p 3 3 2}
The entries are presented under the following headings:

{p 8 12 0}{help scheme_graph_dot##remarks1:Plot regions for graph dot}{p_end}
{p 8 12 0}{help scheme_graph_dot##remarks2:Gaps between dot lines}{p_end}
{p 8 12 0}{help scheme_graph_dot##remarks3:Appearance of dot lines}{p_end}
{p 8 12 0}{help scheme_graph_dot##remarks4:Overall look of sets of dot plots}{p_end}

{p 3 3 2}
For entries that control the appearance of markers plotted by {cmd:graph dot},
see {help scheme dot plots}.  In addition,
some characteristics of the appearance of dot graphs are shared with all other
graphs; see {help scheme graph shared} to change these settings.


{marker remarks1}{...}
{space 3}{title:Plot regions for graph dot}

{p2colset 4 49 52 0}{...}
{p 3 3 2}
These entries specify the look of plot regions for {helpb graph dot}.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:areastyle       {space 0}dot_plotregion}     {space 4}{it:{help areastyle}}}
	overall plot region areastyle;
	usual default {it:areastyle} is 
	{helpb scheme plotregion def:plotregion} (*){p_end}
{p2col:{cmd:areastyle       {space 0}dot_iplotregion}    {space 3}{it:{help areastyle}}}
	inner plot region areastyle; usual default is {cmd:none} (*){p_end}
{p2col:{cmd:margin          {space 9}dotgraph}          {space 4}{it:{help marginstyle}}}
	plot region margin{p_end}
{p2col:{cmd:plotregionstyle {space 0}dotgraph}    {space 4}{it:{help plotregionstyle}}}
	plot region overall style; usual default is {cmd:plotregion} (*){p_end}
{p2line}
{p 3 7 0}(*) Composite entry.


{marker remarks2}{...}
{title:Gaps between dot lines}

{p2colset 4 32 35 0}{...}
{p 3 3 2}
These entries specify the size of gaps between dot lines.  Dot lines occupy an area
similar to the area of a bar in a bar graph.  All values for {it:#}s are percentages 
of the width of that dot area.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:relsize dot_gap}      {space 8}{it:#}}
	distance between dot lines not in an {cmd:over()} group{p_end}
{p2col:{cmd:relsize dot_groupgap} {space 3}{it:#}}
	distance between dot lines in the first {cmd:over()} group{p_end}
{p2col:{cmd:relsize dot_supgroupgap} {space 0}{it:#}}
	distance between dot lines in the second {cmd:over()} group{p_end}
{p2col:{cmd:relsize dot_outergap} {space 3}{it:#}}
	distance between the outermost dot lines and the left and right 
        boundaries of the plot region{p_end}
{p2line}


{marker remarks3}{...}
{title:Appearance of dot lines}

{p2colset 4 47 50 0}{...}
{p 3 3 2}
These entries specify the type and look of ruler lines, or dot lines, drawn
for each category on a dot graph.  

{p 3 3 2}
The type of "ruler", or dot line, drawn is determined by the 
{cmd:dottypestyle dot} entry, where its {it:dotstyle} may be {cmd:dot},
{cmd:line}, or {cmd:rectangle}.  If this setting is {cmd:dot}, the
grouping of entries specifying marker characteristics is used; if it is
{cmd:line}, the grouping specifying line characteristics is used; and, if
it is {cmd:rectangle}, the area and line entries for a rectangle are used.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:dottypestyle {space 0}dot}          {space 9}{it:dotstyle}} 
	the look of dot lines (or rulers); {it:dotstyle} may be {cmd:dot},
        {cmd:line}, or {cmd:rectangle}; other styles may be available
        type{break} {stata graph query dottypestyle} to see a list of
        available {it:dotstyles}{p_end}

{p2col:{cmd:numstyle    {space 3}dot_num_dots}  {space 1}{it:#}}
	number of dots used to fill dot lines{p_end}
{p2col:{cmd:color       {space 6}dots}          {space 9}{it:{help colorstyle}}}
	fill color of markers for dot lines{p_end}
{p2col:{cmd:color       {space 6}dotmarkline}   {space 2}{it:{help colorstyle}}}
	outline color of markers for dot lines{p_end}
{p2col:{cmd:linewidth   {space 2}dotmark}       {space 6}{it:{help linewidthstyle:linewidth}}}
	marker outline thickness for dot lines{p_end}
{p2col:{cmd:symbolsize  {space 1}dots}          {space 9}{it:{help markersizestyle}}}
	size of markers for dot lines{p_end}
{p2col:{cmd:symbol      {space 5}dots}          {space 9}{it:{help symbolstyle}}}
	symbol used for dots on dot lines{p_end}
{p2col:{cmd:linestyle   {space 2}dotmark}       {space 6}{it:{help linestyle}}}
	marker outline style for dot lines (*){p_end}
{p2col:{cmd:markerstyle {space 0}dots}          {space 9}{it:{help markerstyle}}}
	marker style for dot lines (*){p_end}

{p2col:{cmd:linewidth   {space 2}dot_line}      {space 5}{it:{help linewidthstyle:linewidth}}}
	thickness of lines for line-type dot lines{p_end}
{p2col:{cmd:color       {space 6}dot_line}      {space 5}{it:{help colorstyle}}}
	color of lines for line-type dot lines{p_end}
{p2col:{cmd:linestyle   {space 2}dotchart}      {space 5}{it:{help linestyle}}}
        {it:linestyle} for lines sometimes used to represent dot 
	lines (*){p_end}

{p2col:{cmd:gsize       {space 6}dot_rectangle} {space 0}{it:{help textsizestyle}}}
	width of rectangles rectangle-type dot lines{p_end}
{p2col:{cmd:color       {space 6}dot_arealine}  {space 1}{it:{help colorstyle}}}
	color of outlines for rectangle-type dot lines{p_end}
{p2col:{cmd:color       {space 6}dot_area} {space 6}{it:{help colorstyle}}}
	fill color of rectangle-type dot lines{p_end}
{p2col:{cmd:intensity   {space 2}dot_area}      {space 5}{it:{help intensitystyle}}}
	{it:intensitystyle} for fill of rectangles for rectangle-type
	dot lines{p_end}
{p2col:{cmd:linewidth   {space 2}dot_area}      {space 5}{it:{help linewidthstyle:linewidth}}}
	outline thickness for rectangle-type dot lines{p_end}
{p2col:{cmd:linepattern {space 0}dot_area}      {space 5}{it:{help linepatternstyle}}}
	pattern of outlines for rectangle-type dot lines{p_end}
{p2col:{cmd:shadestyle  {space 1}dotchart}      {space 5}{it:{help shadestyle}}}
	{it:shadestyle} for fill of rectangle-type dot lines (*){p_end}
{p2col:{cmd:linestyle   {space 2}dotchart_area} {space 0}{it:{help linestyle}}}
	outline style for rectangle-type  dot lines (*){p_end}
{p2col:{cmd:areastyle   {space 2}dotchart}      {space 5}{it:{help areastyle}}}
	{it:areastyle} for rectangle-type dot lines by 
	{cmd:graph dot} (*){p_end}

{p2col:{cmd:yesno       {space 6}extend_dots}      {space 4}{{cmd:yes}|{cmd:no}}}
	extend dot lines through the plot region margin to
        the bounding box of the plot region ({cmd:yes}), or only to the
        lower inner margin of the plot region ({cmd:no}){p_end}
{p2col:{cmd:numstyle    {space 3}dot_extend_high} {space 0}{{cmd:0}|{cmd:1}}}
	whether to extend dot lines through the right
	margin of the {help region_options:plotregion}{p_end}
{p2col:{cmd:numstyle    {space 3}dot_extend_low}   {space 1}{{cmd:0}|{cmd:1}}}
	whether to extend dot lines through the left
	margin of the {help region_options:plotregion}{p_end}
{p2line}
{p 3 7 0}(*) Composite entry.


{marker remarks4}{...}
{title:Overall look of sets of dot plots}

{p2colset 4 37 40 0}{...}
{p 3 3 2}
This composite entry controls the overall look of sets of dot plots.  It
should rarely be changed; instead you should change the individual elements in other
entries.{break} 
Type {bf:{stata graph query barstyle}} to see available options for {it:barstyle}.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:barstyle dot}       {space 2}{it:barstyle}}
	overall look of sets of dot lines{p_end}
{p2line}
{p2colreset}{...}
