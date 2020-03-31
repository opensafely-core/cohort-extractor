{smcl}
{* *! version 1.0.4  11feb2011}{...}
{vieweralsosee "scheme shared plots" "help scheme shared plots"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Bar plot scheme entries}

{p 3 3 2}
These graphics scheme entries control the look of {helpb twoway bar} and 
{helpb graph bar} plots.  See {it:{help scheme_files##remarks3:Plot entries}}
in {help scheme files} for a general discussion of entries for plots.

{p 3 3 2}
The entries are presented under the following headings:

{p 8 12 0}{help scheme_bar_plots##remarks1:Primary bar plot entries}{p_end}
{p 8 12 0}{help scheme_bar_plots##remarks2:Composite entries for bar plots}{p_end}


{marker remarks1}{...}
{title:Primary bar plot scheme entries}

{p2colset 4 45 48 0}{...}
{p 3 3 2}
These entries are most often used to change the look of bar plots.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:color       {space 6}p}{it:#}{cmd:bar}     {space 5}{it:{help colorstyle}}}
	fill color for #th bar plot{p_end}
{p2col:{cmd:intensity   {space 2}p}{it:#}{cmd:bar}     {space 5}{it:{help intensitystyle}}}
	fill intensity for the #th bar plot of {helpb twoway bar}{p_end}
{p2col:{cmd:intensity   {space 2}}{cmd:bar}            {space 7}{it:{help intensitystyle}}}
	fill intensity for all bars of {helpb graph bar}{p_end}

{p2col:{cmd:linewidth   {space 2}p}{it:#}{cmd:bar}     {space 5}{it:{help linewidthstyle:linewidth}}}
	outline thickness for #th bar plot{p_end}
{p2col:{cmd:linepattern {space 0}p}{it:#}{cmd:bar}     {space 5}{it:{help linepatternstyle}}}
	outline pattern for #th bar plot{p_end}
{p2col:{cmd:color       {space 6}p}{it:#}{cmd:barline} {space 1}{it:{help colorstyle}}}
	outline color for #th bar plot{p_end}
{p2col:{cmd:intensity   {space 2}}{cmd:bar_line}       {space 2}{it:{help intensitystyle}}}
	outline intensity for all bars of {helpb graph bar}{p_end}
{p2line}

{p 3 3 2}
If a scheme does not contain some of these bar-plot-specific entries,
the look of those elements of bar plots will be determined by default entries
that are shared among all plottypes; see {help scheme shared plots}.


{marker remarks2}{...}
{title:Composite entries for bar plots}

{p2colset 4 40 43 0}{...}
{p 3 3 2}
For most schemes shipped with Stata, the styles for these composite entries
are {cmd:p}{it:#}{cmd:bar}, (where {it:#} is the number of the plot); in
that case, the individual attribute entries shown in the table above control
the characteristics of bar plots.  If, however, the styles for the composite
entries are changed, then the individual attribute entries affecting
bar plots may also change.  See the discussion in
{it:{help scheme_files##remarks4:Composite entries}} of {help scheme files}.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:textboxstyle {space 0}{cmd:barlabel}   {space 0}{it:{help textboxstyle}}}}
	{it:textstyle} of all bar labels, {it:textstyle} is 
	{helpb scheme labels:small_label} for most schemes.{p_end}
{p2col:{cmd:linestyle   {space 3}p}{it:#}{cmd:bar}  {space 3}{it:{help linestyle}}}
	{it:linestyle} for the #th bar plot{p_end}
{p2col:{cmd:shadestyle  {space 2}p}{it:#}{cmd:bar}  {space 3}{it:{help shadestyle}}}
	{it:shadestyle} for the #th bar plot{p_end}
{p2col:{cmd:areastyle   {space 3}p}{it:#}{cmd:bar}  {space 3}{it:{help areastyle}}}
	{it:areastyle} for the #th bar plot{p_end}
{p2col:{cmd:seriesstyle {space 1}p}{it:#}{cmd:bar}  {space 3}{it:{help pstyle}}}
	{it:pstyle} for the #th bar plot{p_end}
{p2line}
{p2colreset}{...}
