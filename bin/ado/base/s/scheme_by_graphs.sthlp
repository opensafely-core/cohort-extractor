{smcl}
{* *! version 1.0.4  11feb2011}{...}
{vieweralsosee "scheme graph shared" "help scheme graph shared"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Scheme entries that control by graphs}

{p 3 3 2}
These settings control the overall look of by graphs
{c -} graphs drawn using the {helpb by_option:by()} option.

{p 3 3 2}
The entries are presented under the following headings:

{p 8 12 0}{help scheme_by_graphs##remarks1:Graph region}{p_end}
{p 8 12 0}{help scheme_by_graphs##remarks2:Plot region}{p_end}
{p 8 12 0}{help scheme_by_graphs##remarks3:Construction of by graphs}

{p 3 3 2}
In addition, some characteristics of the appearance of by graphs are
shared with all other graphs; see {help scheme graph shared} to change
these settings.


{marker remarks1}{...}
{title:Graph region}

{p2colset 4 42 45 0}{...}
{p 3 3 2}
These entries specify the look of the area into which the entire by graph is
drawn.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:areastyle bygraph}       {space 7}{it:{help areastyle}}}
	overall graph region; usual default is {cmd:background} (*){p_end}
{p2col:{cmd:areastyle inner_bygraph} {space 1}{it:{help areastyle}}}
	inner graph region; usual default is {cmd:none} (*){p_end}
{p2line}
{p 3 7 0}(*) Composite entry.


{marker remarks2}{...}
{title:Plot region}

{p2colset 4 50 53 0}{...}
{p 3 3 2}
These entries specify the look of plot regions for by graphs.  For by graphs,
the plot region is the area into which the individual graphs are drawn.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:areastyle       {space 0}bygraph_plotregion}  {space 1}{it:{help areastyle}}}
	overall plot region areastyle; usual default is {cmd:none} (*){p_end}
{p2col:{cmd:areastyle       {space 0}bygraph_iplotregion} {space 0}{it:{help areastyle}}}
	inner plot region areastyle; usual default is {cmd:none} (*){p_end}
{p2col:{cmd:margin          {space 11}bygraph}    {space 4}{it:{help marginstyle}}}
	plot region margin{p_end}
{p2col:{cmd:plotregionstyle {space 2}bygraph}     {space 4}{it:{help plotregionstyle}}}
	plot region overall style; usual default is {cmd:bygraph} (*){p_end}
{p2line}
{p 3 7 0}(*) Composite entry.


{marker remarks3}{...}
{title:Construction of by graphs}

{p2colset 4 37 40 0}{...}
{p 3 3 2}
These entries control how by graphs are created, including axes, titles, and scaling 
of text and symbols.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:yesno by_indiv_yrescale}    {space 0}{{cmd:yes}|{cmd:no}}}
	rescale the {it:y} axis of each subgraph; if {cmd:yes}, you should
	generally also specify {break}
	{cmd:yesno by_indiv_yaxes yes}{p_end}
{p2col:{cmd:yesno by_indiv_xrescale}    {space 0}{{cmd:yes}|{cmd:no}}}
	rescale the {it:x} axis of each subgraph; if ({cmd:yes}), you should
	generally also specify {break}
	{cmd:yesno by_indiv_xaxes yes}{p_end}

{p2col:{cmd:yesno by_outer_yaxes}       {space 3}{{cmd:yes}|{cmd:no}}}
	create {it:y} axes along the left or right (usually left) column of
	subgraphs{p_end}
{p2col:{cmd:yesno by_outer_xaxes}       {space 3}{{cmd:yes}|{cmd:no}}}
	create {it:x} axes along the bottom or top (usually bottom) row of
	subgraphs{p_end}
{p2col:{cmd:yesno by_indiv_yaxes}       {space 3}{{cmd:yes}|{cmd:no}}}
	create {it:y} axes on each individual subgraph{p_end}
{p2col:{cmd:yesno by_indiv_xaxes}       {space 3}{{cmd:yes}|{cmd:no}}}
	create {it:x} axes on each individual subgraph{p_end}
{p2col:{cmd:yesno by_edgelabel}         {space 5}{{cmd:yes}|{cmd:no}}}
        create axes for subgraphs that are the closest to the edge of the
	row or column of subgraphs, even if graphs do not completely fill the
	row or column{p_end}

{p2col:{cmd:yesno by_outer_ytitles}     {space 1}{{cmd:yes}|{cmd:no}}}
	title the set of subgraph {it:y} axes with an overall title using one
	of the numbered titles{p_end}
{p2col:{cmd:yesno by_outer_xtitles}     {space 1}{{cmd:yes}|{cmd:no}}}
	title the set of subgraph {it:x} axes with an overall title using one
	of the numbered titles{p_end}
{p2col:{cmd:yesno by_indiv_ytitles}     {space 1}{{cmd:yes}|{cmd:no}}}
	individually title each {it:y} axis that is created{p_end}
{p2col:{cmd:yesno by_indiv_xtitles}     {space 1}{{cmd:yes}|{cmd:no}}}
	individually title each {it:x} axis that is created{p_end}

{p2col:{cmd:yesno by_indiv_ylabels}     {space 1}{{cmd:yes}|{cmd:no}}}
	show tick labels on {it:y} axes{p_end}
{p2col:{cmd:yesno by_indiv_xlabels}     {space 1}{{cmd:yes}|{cmd:no}}}
	show tick labels on {it:x} axes{p_end}
{p2col:{cmd:yesno by_indiv_yticks}      {space 2}{{cmd:yes}|{cmd:no}}}
	show ticks on {it:y} axes{p_end}
{p2col:{cmd:yesno by_indiv_xticks}      {space 2}{{cmd:yes}|{cmd:no}}}
	show ticks on {it:x} axes{p_end}

{p2col:{cmd:yesno indiv_as_whole}       {space 3}{{cmd:yes}|{cmd:no}}}
        place entire subgraphs in the by graph rather than separate components
        (plot regions, axes, etc.); generally the other individual settings
        should be set to {cmd:yes} when {cmd:indiv_as_whole} is set to
        {cmd:yes}{p_end}

{p2colset 4 40 40 0}{...}
{p2col:{cmd:yesno by_shrink_plotregion} {space 0}{{cmd:yes}|{cmd:no}}}shrink
	the graph objects (text, markers, etc.) associated with the
	subgraphs as though the subgraphs were complete graphs; rarely
	specified{p_end}

{p2colset 4 37 40 0}{...}
{p2col:{cmd:margin {space 1}by_indiv}    {space 3}{it:{help marginstyle}}}
	margin around individual graphs{p_end}

{p2col:{cmd:bygraphstyle bygraph}    {space 3}{it:{help bystyle}}}
	Overall style for by graphs (*){p_end}
{p2line}
{p 3 7 0}(*) Composite entry.  Most schemes shipped with Stata set
{it:bystyle} to {cmd:default}; if a scheme specifies a different composite
style for {it:bystyle}, some of the other settings in the table may be
ignored or overridden.{p_end}
