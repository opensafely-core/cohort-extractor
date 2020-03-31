{smcl}
{* *! version 1.0.4  11feb2011}{...}
{vieweralsosee "scheme shared plots" "help scheme shared plots"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Dot plot scheme entries}

{p 3 3 2}
These graphics scheme entries control the look of {helpb graph dot} plots.  See
{it:{help scheme_files##remarks3:Plot entries}} in
{help scheme files} for a general discussion of entries for plots.

{p 3 3 2}
The entries are presented under the following headings:

{p 8 12 0}{help scheme_dot_plots##remarks1:Primary dot plot entries}{p_end}
{p 8 12 0}{help scheme_dot_plots##remarks2:Composite entries for dot plots}{p_end}


{marker remarks1}{...}
{title:Primary dot plot entries}

{p2colset 4 46 49 0}{...}
{p 3 3 2}
These entries are most often used to change the look of dot plots.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:symbol      {space 5}p}{it:#}{cmd:dot}         {space 8}{it:{help symbolstyle}}}
	marker symbol for #th dot plot{p_end}
{p2col:{cmd:symbolsize  {space 1}p}{it:#}{cmd:dot}         {space 8}{it:{help markersizestyle}}}
	marker symbol size for #th dot plot{p_end}
{p2col:{cmd:linewidth   {space 2}p}{it:#}{cmd:dotmark}     {space 4}{it:{help linewidthstyle:linewidth}}}
	symbol outline thickness for #th dot plot{p_end}
{p2col:{cmd:color       {space 6}p}{it:#}{cmd:dotmarkfill} {space 0}{it:{help colorstyle}}}
	fill color of markers for #th dot plot{p_end}
{p2col:{cmd:color       {space 6}p}{it:#}{cmd:dotmarkline} {space 0}{it:{help colorstyle}}}
	outline color markers for #th dot plot{p_end}
{p2line}

{p 3 3 2}
If a scheme does not contain some of the dot-plot-specific entries above, then
the look of those elements of dot plots is determined by default entries
that are shared among all plottypes; see {help scheme shared plots}.


{marker remarks2}{...}
{title:Composite entries for dot plots}

{p2colset 4 40 43 0}{...}
{p 3 3 2}
For most schemes shipped with Stata, the styles for these composite entries
are {cmd:p}{it:#}{cmd:dot} (where {it:#} is the number of the plot); in
that case, the individual attribute entries shown in the table above control
the characteristics of dot plots.  If, however, the styles for the composite
entries are changed, the individual attribute entries affecting
dot plots may also change.  See the discussion in 
{it:{help scheme_files##remarks4:Composite entries}} of {help scheme files}.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:linestyle    {space 3}p}{it:#}{cmd:dotmark}  {space 1}{it:{help linestyle}}}
	{it:linestyle} of markers for #th dot plot; default {it:linestyle} is
	{cmd:p}{it:#}{cmd:dotmark}{p_end}
{p2col:{cmd:markerstyle  {space 1}p}{it:#}{cmd:dot}      {space 5}{it:{help markerstyle}}}
	marker style for the #th dot plot{p_end}
{p2col:{cmd:seriesstyle  {space 1}p}{it:#}{cmd:dot}      {space 5}{it:{help pstyle}}}
	overall {it:pstyle} for the #th dot plot{p_end}
{p2line}
{p2colreset}{...}
