{smcl}
{* *! version 1.0.4  11feb2011}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{vieweralsosee "scheme shared plots" "help scheme shared plots"}{...}
{title:Area plot scheme entries}

{p 3 3 2}
These graphics scheme entries control the look of {helpb twoway area} plots.
See {it:{help scheme_files##remarks3:Plot entries}} in {help scheme files} for
a general discussion of entries for plots.

{p 3 3 2}
The entries are presented under the following headings:

{p 8 12 0}{help scheme_area_plots##remarks1:Primary area plot entries}{p_end}
{p 8 12 0}{help scheme_area_plots##remarks2:Composite entries for area plots}{p_end}


{marker remarks1}{...}
{title:Primary area plot entries}

{p2colset 4 45 48 0}{...}
{p 3 3 2}
These entries are most often used to change the look of area plots.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:color       {space 6}p}{it:#}{cmd:area}     {space 5}{it:{help colorstyle}}}
	fill color for #th area plot{p_end}
{p2col:{cmd:intensity   {space 2}p}{it:#}{cmd:area}     {space 5}{it:{help intensitystyle}}}
	fill intensity for #th area plot{p_end}

{p2col:{cmd:linewidth   {space 2}p}{it:#}{cmd:area}     {space 5}{it:{help linewidthstyle:linewidth}}}
	outline thickness for #th area plot{p_end}
{p2col:{cmd:linepattern {space 0}p}{it:#}{cmd:area}     {space 5}{it:{help linepatternstyle}}}
	outline pattern for #th area plot{p_end}
{p2col:{cmd:color       {space 6}p}{it:#}{cmd:arealine} {space 1}{it:{help colorstyle}}}
	outline color for #th area plot{p_end}
{p2line}

{p 3 3 2}
If a scheme does not contain some of the area-plot-specific entries above,
then the look of those elements of area plots will be determined by default
entries that are shared among all plottypes; see
{help scheme shared plots}.


{marker remarks2}{...}
{title:Composite entries for area plots}

{p2colset 4 42 45 0}{...}
{p 3 3 2}
For most schemes shipped with Stata, the styles for these composite entries
are {cmd:p}{it:#}{cmd:area} (where {it:#} is the number of the plot), and, in
that case, the individual attribute entries shown in the table above control
the characteristics of area plots.  If, however, the styles for the composite
entries are changed, then the individual attribute entries affecting
area plots may also change.  See the discussion in
{it:{help scheme_files##remarks4:Composite entries}} of {help scheme files}.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:linestyle   {space 2}p}{it:#}{cmd:area} {space 1}{it:{help linestyle}}}
	{it:linestyle} for the #th area plot{p_end}
{p2col:{cmd:shadestyle  {space 1}p}{it:#}{cmd:area} {space 1}{it:{help shadestyle}}}
	{it:shadestyle} for the #th area plot{p_end}
{p2col:{cmd:areastyle   {space 2}p}{it:#}{cmd:area}  {space 1}{it:{help areastyle}}}
	{it:areastyle} for the #th area plot{p_end}
{p2col:{cmd:seriesstyle {space 0}p}{it:#}{cmd:area}  {space 1}{it:{help pstyle}}}
	{it:pstyle} for the #th area plot{p_end}
{p2line}
{p2colreset}{...}
