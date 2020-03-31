{smcl}
{* *! version 1.0.4  11feb2011}{...}
{vieweralsosee "scheme shared plots" "help scheme shared plots"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Line plot scheme entries}

{p 3 3 2}
These graphics scheme entries control the look of {helpb line} plots.  See
{it:{help scheme files##remarks3:Plot entries}} in {help scheme files} for a
general discussion of entries for plots.

{p 3 3 2}
The entries are presented under the following headings:

{p 8 12 0}{help scheme_line_plots##remarks1:Primary line plot entries}{p_end}
{p 8 12 0}{help scheme_line_plots##remarks2:Composite entries for line plots}{p_end}


{marker remarks1}{...}
{title:Primary line plot scheme entries}

{p2colset 4 45 48 0}{...}
{p 3 3 2}
Entries most often used to change the look of line plots.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:color       {space 6}p}{it:#}{cmd:lineplot} {space 0}{it:{help colorstyle}}}
	color for #th line plot{p_end}
{p2col:{cmd:linewidth   {space 2}p}{it:#}{cmd:lineplot} {space 0}{it:{help linewidthstyle:linewidth}}}
	line thickness for #th line plot{p_end}
{p2col:{cmd:linepattern {space 0}p}{it:#}{cmd:lineplot} {space 0}{it:{help linepatternstyle}}}
	line pattern for #th line plot{p_end}

{p2col:{cmd:yesno       {space 6}pcmissings}            {space 0}{{cmd:yes}|{cmd:no}}}
        default setting for whether lines are connected over observations with 
	missing values ({cmd:yes}) or gaps are left in the line 
	({cmd:no}) (#){p_end}
{p2col:{cmd:yesno       {space 6}p}{it:#}{cmd:cmissings} {space 0}{{cmd:yes}|{cmd:no}}}
        whether lines are connected over observations with 
	missing values ({cmd:yes}) or gaps are left in the line 
	({cmd:no}) for the {it:#}th plot (#){p_end}

{p2col:{cmd:connectstyle {space 0}p}                     {space 8}{it:{help connectstyle}}}
	default {it:connectstyle} for all plots{p_end}
{p2col:{cmd:connectstyle {space 0}p}{it:#}               {space 7}{it:{help connectstyle}}}
	{it:connectstyle} for the #th plot{p_end}
{p2line}
{p 3 3 2}(#) Settings shared with {help scheme connected plots:connected plots}

{p 3 3 2}
If a scheme does not contain some of the line-plot specific entries above,
then the look of those elements of line plots will be determined by default
entries that are shared among all plottypes; see
{help scheme shared plots}.


{marker remarks2}{...}
{title:Composite entries for line plots}

{p2colset 4 42 45 0}{...}
{p 3 3 2}
For most schemes shipped with Stata, the styles for these composite entries
are {cmd:p}{it:#}{cmd:lineplot} (where {it:#} is the number of the plot), and,
in that case, the individual attribute entries shown in the table above
control the characteristics of line plots.  If, however, the styles for the
composite entries are changed, then the individual attribute override entries
affecting line plots may also change.  See the discussion in
{it:{help scheme_files##remarks4:Composite entries}} of {help scheme files}.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:linestyle   {space 2}p}{it:#}{cmd:lineplot} {space 1}{it:{help linestyle}}}
	{it:linestyle} for the #th line plot{p_end}
{p2col:{cmd:seriesstyle {space 0}p}{it:#}{cmd:lineplot} {space 1}{it:{help pstyle}}}
	{it:pstyle} for the #th line plot{p_end}
{p2line}
{p2colreset}{...}
