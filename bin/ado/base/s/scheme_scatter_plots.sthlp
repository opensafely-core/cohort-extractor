{smcl}
{* *! version 1.0.4  11feb2011}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Scatter plot scheme entries}

{p 3 3 2}
These graphics scheme entries control the look of {helpb twoway scatter} and
the markers used by {helpb twoway connected} plots.  See
{it:{help scheme files##remarks3:Plot entries}} in {help scheme files} for a
general discussion of entries for plots.


{p 3 3 2}
The entries are presented under the following headings:

{p 8 12 0}{help scheme_scatter_plots##remarks1:Primary entries for scatter plots}{p_end}
{p 8 12 0}{help scheme_scatter_plots##remarks2:Secondary entries for scatter plots}{p_end}
{p 8 12 0}{help scheme_scatter_plots##remarks3:Composite entries for scatter plots}{p_end}
{p 8 12 0}{help scheme_scatter_plots##remarks4:Secondary composite entries for scatter plots}{p_end}


{marker remarks1}{...}
{title:Primary entries for scatter plots}

{p2colset 4 45 48 0}{...}
{p 3 3 2}
These are the entries most often used to change the look of scatter plots and markers of
connected plots.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:symbol      {space 5}p}                     {space 10}{it:{help symbolstyle}}}
	default marker symbol for all plots{p_end}
{p2col:{cmd:symbol      {space 5}p}{it:#}               {space 9}{it:{help symbolstyle}}}
	marker symbol for the #th plot{p_end}
{p2col:{cmd:symbolsize  {space 1}p}                     {space 10}{it:{help markersizestyle}}}
	default size of marker symbols for all plots{p_end}
{p2col:{cmd:symbolsize  {space 1}p}{it:#}               {space 9}{it:{help markersizestyle}}}
	size of marker symbols for #th plot{p_end}
{p2col:{cmd:color       {space 6}p}{it:#}{cmd:markline} {space 1}{it:{help colorstyle}}}
	line color of marker symbols for #th plot{p_end}
{p2col:{cmd:linewidth   {space 2}p}{it:#}{cmd:mark}     {space 5}{it:{help linewidthstyle:linewidth}}}
	line thickness of marker symbols for #th plot{p_end}
{p2col:{cmd:color       {space 6}p}{it:#}{cmd:markfill} {space 1}{it:{help colorstyle}}}
	fill color of marker symbols for #th plot{p_end}

{p2col:{cmd:gsize       {space 6}p}{cmd:label}          {space 5}{it:{help textsizestyle}}}
	default text size of marker labels for all plots{p_end}
{p2col:{cmd:gsize       {space 6}p}{it:#}{cmd:label}    {space 4}{it:{help textsizestyle}}}
	text size of marker labels for #th plot{p_end}
{p2col:{cmd:color       {space 6}p}{cmd:label}          {space 5}{it:{help colorstyle}}}
	default text color of marker labels for all plots{p_end}
{p2col:{cmd:color       {space 6}p}{it:#}{cmd:label}    {space 4}{it:{help colorstyle}}}
	text color of marker labels for #th plot{p_end}
{p2col:{cmd:clockdir    {space 3}p}                     {space 10}{it:{help clockpos}}}
	default position of labels on markers for all plots{p_end}
{p2col:{cmd:clockdir    {space 3}p}{it:#}               {space 9}{it:{help clockpos}}}
	position of labels on markers for #th plot{p_end}
{p2col:{cmd:gsize       {space 6}label_gap}             {space 2}{it:{help textsizestyle}}}
	distance between markers and their labels{p_end}

{p2col:{cmd:numstyle    {space 3}max_wted_symsize}      {space 2}{it:#}}
	affects maximum size of symbols in weighted scatter 
	plots; rarely used{p_end}
{p2line}

{p 3 3 2}
When the {cmd:connect()} option is specified on scatter plots, the look of the
connected line is shared with {helpb twoway connected} plots; see 
{bf:Primary entries for connected plots} in {help scheme connected plots}
for those entries.

{p 3 3 2}
If a scheme does not contain some of the scatter-plot-specific entries above,
the look of those elements of scatter plots will be determined by default
entries that are shared among all plottypes; see
{help scheme shared plots}.


{marker remarks2}{...}
{title:Secondary entries for scatter plots}

{p2colset 4 45 48 0}{...}
{p 3 3 2}
In addition to scatter-plottypes, the scatter-plot entries
serve as default looks for some plots that use area fills or other graphic
elements.  The following entries specify the look of such plots.  In general,
these entries are rarely used.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:color       {space 6}p}{it:#}{cmd:shade}     {space 4}{it:{help colorstyle}}}
	area fill color for #th scatter plot{p_end}
{p2col:{cmd:intensity   {space 2}p}{it:#}{cmd:shade}     {space 4}{it:{help intensitystyle}}}
        area fill {it:intensitystyle} for the #th scatter plot{p_end}
{p2col:{cmd:linewidth   {space 2}p}{it:#}{cmd:other}     {space 4}{it:{help linewidthstyle:linewidth}}}
	outline thickness of area fills for the #th scatter, or other, plot;
	rarely used{p_end}
{p2col:{cmd:linepattern {space 0}p}{it:#}{cmd:other}     {space 4}{it:{help linepatternstyle}}}
	outline pattern of area fills for the #th scatter plot; rarely 
	used{p_end}
{p2col:{cmd:color       {space 6}p}{it:#}{cmd:otherline} {space 0}{it:{help colorstyle}}}
	outline color of area fills for #th scatter plot{p_end}
{p2line}


{marker remarks3}{...}
{title:Composite entries for scatter plots}

{p2colset 4 38 41 0}{...}
{p 3 3 2}
For most schemes shipped with Stata, the styles for these composite entries
are {cmd:p}{it:#} (where {it:#} is the number of the plot); in that case,
the individual attribute entries shown in the tables above control the
characteristics of scatter plots.  If, however, the styles for the composite
entries are changed, the individual attribute override entries affecting
scatter plots may also change.  See the discussion in
{it:{help scheme files##remarks4:Composite entries}} of {help scheme files}.

{p 3 3 2}
These entries are usually shared with connected plots.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:linestyle    {space 3}p}{it:#}{cmd:mark} {space 1}{it:{help linestyle}}}
	marker outline {it:linestyle} for the #th scatter plot; default style
	is {cmd:p#mark}{p_end}
{p2col:{cmd:markerstyle  {space 1}p}{it:#}           {space 5}{it:{help markerstyle}}}
	marker style for the #th scatter plot{p_end}
{p2col:{cmd:textboxstyle {space 0}p}{it:#}      {space 5}{it:{help textstyle}}}
	{it:textstyle} of marker labels for the #th plot{p_end}
{p2col:{cmd:labelstyle   {space 2}p}{it:#}      {space 5}{it:{help labelstyle}}}
	{it:labelstyle} of marker labels for the #th plot{p_end}
{p2col:{cmd:seriesstyle  {space 1}p}{it:#}            {space 5}{it:{help pstyle}}}
	overall {it:pstyle} for the #th scatter plot{p_end}
{p2line}


{marker remarks4}{...}
{title:Secondary composite entries for scatter plots}

{p2colset 4 40 43 0}{...}
{p 3 3 2}
For most schemes shipped with Stata, the styles for these composite entries
are {cmd:p}{it:#} (where {it:#} is the number of the plot); in that case,
the individual attribute entries shown in the table above control the
characteristics of plots.  If, however, the styles for the composite
entries are changed, the individual attribute entries affecting
scatter plots may also change.  See the discussion in
{it:{help scheme files##remarks4:Composite entries}} of {help scheme files}.

{p2col:Entry} Description{p_end}
{p2line}

{p2col:{cmd:linestyle   {space 1}p}{it:#}{cmd:connect} {space 1}{it:{help linestyle}}}
	connecting {it:linestyle} for the #th plot{p_end}
{p2col:{cmd:linestyle   {space 3}p}{it:#}{cmd:other} {space 1}{it:{help linestyle}}}
	area outline style for the #th plot{p_end}
{p2col:{cmd:shadestyle  {space 2}p}{it:#}{cmd:other} {space 1}{it:{help shadestyle}}}
	area {it:shadestyle} for the #th plot{p_end}
{p2line}
{p2colreset}{...}
