{smcl}
{* *! version 1.0.4  11feb2011}{...}
{vieweralsosee "scheme shared plots" "help scheme shared plots"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Histogram plot scheme entries}

{p 3 3 2}
These graphics scheme entries control the look of {helpb histogram} plots.  See
{it:{help scheme_files##remarks3:Plot entries}} in {help scheme files} for a
general discussion of entries for plots.

{p 3 3 2}
The entries are presented under the following headings:

{p 8 12 0}{help scheme_histogram_plots##remarks1:Primary histogram plot entries}{p_end}
{p 8 12 0}{help scheme_histogram_plots##remarks2:Composite entries for histogram plots}{p_end}


{marker remarks1}{...}
{title:Primary histogram plot entries}

{p2colset 4 49 52 0}{...}
{p 3 3 2}
These entries are most often used to change the look of histogram plots.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:color       {space 6}histogram}      {space 5}{it:{help colorstyle}}}
	bar fill color{p_end}
{p2col:{cmd:intensity   {space 2}histogram}      {space 5}{it:{help intensitystyle}}}
	bar fill intensity{p_end}

{p2col:{cmd:color       {space 6}histogram_line} {space 0}{it:{help colorstyle}}}
	bar outline color{p_end}
{p2col:{cmd:linewidth   {space 2}histogram}      {space 5}{it:{help linewidthstyle:linewidth}}}
	bar outline thickness{p_end}
{p2col:{cmd:linepattern {space 0}histogram}      {space 5}{it:{help linepatternstyle}}}
	bar outline pattern{p_end}

{p2col:{cmd:symbol      {space 5}histogram}      {space 5}{it:{help symbolstyle}}}
	marker symbol; rarely used{p_end}
{p2col:{cmd:symbolsize  {space 1}histogram}      {space 5}{it:{help markersizestyle}}}
	size of markers, rarely used{p_end}
{p2line}

{p 3 3 2}
If a scheme does not contain some of the histogram-plot specific entries
above, the look of those elements of histogram plots will be determined
by default entries that are shared among all plottypes; see
{help scheme shared plots}.


{marker remarks2}{...}
{title:Composite entries for histogram plots}

{p2colset 4 42 45 0}{...}
{p 3 3 2}
For most schemes shipped with Stata, the styles for these composite entries
are {cmd:histogram}; in that case, the individual attribute entries shown
in the table above control the characteristics of histogram plots.  If,
however, the styles for the composite entries are modified, then the individual
attribute entries affecting histogram plots may also change.  See the
discussion in {it:{help scheme files##remarks4:Composite entries}} of
{help scheme files}.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:shadestyle  {space 1}histogram}     {space 2}{it:{help shadestyle}}}
	{it:shadestyle} bars{p_end}
{p2col:{cmd:areastyle   {space 2}histogram}     {space 2}{it:{help areastyle}}}
	{it:areastyle} for bars{p_end}

{p2col:{cmd:linestyle   {space 2}histogram}     {space 2}{it:{help linestyle}}}
	{it:linestyle} for bar outlines{p_end}

{p2col:{cmd:markerstyle {space 0}histogram}     {space 2}{it:{help markerstyle}}}
	histogram marker, rarely used{p_end}
{p2line}
{p2colreset}{...}
