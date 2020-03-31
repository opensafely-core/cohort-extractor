{smcl}
{* *! version 1.0.4  11feb2011}{...}
{vieweralsosee "scheme shared plots" "help scheme shared plots"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Pie-slice scheme entries}

{p 3 3 2}
These graphics scheme entries control the look of {helpb graph pie}
pie-slice plots.  See {it:{help scheme_files##remarks3:Plot entries}} in
{help scheme files} for a discussion of entries for plots.

{p 3 3 2}
The entries are presented under the following headings:

{p 8 12 0}{help scheme_pie_plot##remarks1:Primary pie-slice entries}{p_end}
{p 8 12 0}{help scheme_pie_plot##remarks2:Composite entries for pie slices}{p_end}


{marker remarks1}{...}
{title:Pie-slice scheme entries}

{p2colset 4 45 48 0}{...}
{p 3 3 2}
The entries are most often used to change the look of pie slices.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:color       {space 6}p}{it:#}{cmd:pie}     {space 5}{it:{help colorstyle}}}
	fill color for #th pie slice{p_end}
{p2col:{cmd:intensity   {space 2}}{cmd:pie}            {space 7}{it:{help intensitystyle}}}
	fill intensity for all pie slices{p_end}

{p2col:{cmd:linewidth   {space 2}pie}                  {space 7}{it:{help linewidthstyle:linewidth}}}
	outline thickness for all pie slices{p_end}
{p2col:{cmd:color       {space 6}p}{it:#}{cmd:pieline} {space 1}{it:{help colorstyle}}}
	outline color for #th pie slice{p_end}

{p2col:{cmd:gsize       {space 6}pielabel_gap} {space 0}{it:{help textsizestyle}}}
	distance of pie labels from center of pie{p_end}
{p2col:{cmd:gsize       {space 6}pie_explode}  {space 1}{it:{help textsizestyle}}}
	distance to explode pie slices{p_end}

{p2col:{cmd:numstyle    {space 3}pie_angle}            {space 1}{it:#}}
	angle at which to begin drawing first pie slice{p_end}
{p2col:{cmd:yesno       {space 6}pie_clockwise}        {space 0}{{cmd:yes}|{cmd:no}}}
        pie slices are drawn sequentially clockwise ({cmd:yes}) or
	counterclockwise ({cmd:no)}{p_end}
{p2line}

{p 3 3 2}
If a scheme does not contain some of the pie-slice plot specific entries
above, the look of those elements of pie slices will be determined by
default entries that are shared among all plottypes; see
{help scheme shared plots}.


{marker remarks2}{...}
{title:Composite entries for pie slices}

{p2colset 4 40 43 0}{...}
{p 3 3 2}
For most schemes shipped with Stata, the styles for these composite entries
are {cmd:p}{it:#}{cmd:pie}, where {it:#} is the number of the plot; in
that case, the individual attribute entries shown in the table above control
the characteristics of pie slices.  If, however, the styles for the composite
entries are changed, the individual attribute entries affecting
bar plots may also change.  See the discussion in
{it:{help scheme_files##remarks4:Composite entries}} of {help scheme files}.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:textboxstyle {space 0}{cmd:pielabel}   {space 0}{it:{help textboxstyle}}}}
	{it:textstyle} of all pie slice labels; {it:textstyle} is 
	{helpb scheme labels:small_label} for most schemes.{p_end}
{p2col:{cmd:linestyle    {space 3}}{cmd:pie_line}      {space 0}{it:{help linestyle}}}
	outline style for the all pie slices{p_end}
{p2col:{cmd:shadestyle   {space 2}p}{it:#}{cmd:pie}    {space 3}{it:{help shadestyle}}}
	{it:shadestyle} for the #th pie slice{p_end}
{p2col:{cmd:areastyle    {space 3}p}{it:#}{cmd:pie}    {space 3}{it:{help areastyle}}}
	{it:areastyle} for the #th pie slice{p_end}
{p2col:{cmd:seriesstyle  {space 1}p}{it:#}{cmd:pie}    {space 3}{it:{help pstyle}}}
	{it:pstyle} for the #th pie slice{p_end}
{p2line}
{p2colreset}{...}
