{smcl}
{* *! version 1.0.4  11feb2011}{...}
{vieweralsosee "scheme scatter plots" "help scheme scatter plots"}{...}
{vieweralsosee "scheme shared plots" "help scheme shared plots"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Connected plot scheme entries}

{p 3 3 2}
These graphics scheme entries control the look of {helpb twoway connected}
plots.  See {it:{help scheme_files##remarks3:Plot entries}} in
{help scheme files} for a general discussion of entries for plots.

{p 3 3 2}
The entries are presented under the following headings:

{p 8 12 0}{help scheme_connected_plots##remarks1:Primary connected plot entries}{p_end}
{p 8 12 0}{help scheme_connected_plots##remarks2:Composite entries for connected plots}{p_end}


{marker remarks1}{...}
{title:Primary entries for connected plots}

{p2colset 4 42 45 0}{...}
{p 3 3 2}
These entries are most often used to change the look of connected plots.  They
are usually shared with {helpb twoway scatter} plots when those plots use the
{cmd:connect()} option.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:color       {space 6}p}{it:#}{cmd:line}     {space 2}{it:{help colorstyle}}}
	color of connecting line for #th plot{p_end}
{p2col:{cmd:linewidth   {space 2}p}{it:#}{cmd:}         {space 6}{it:{help linewidthstyle:linewidth}}}
	thickness of connecting line for #th plot{p_end}
{p2col:{cmd:linepattern {space 0}p}{it:#}{cmd:line}     {space 2}{it:{help linepatternstyle}}}
	pattern of connecting line for #th plot{p_end}

{p2col:{cmd:yesno       {space 6}pcmissings}            {space 0}{{cmd:yes}|{cmd:no}}}
        default setting for whether lines are connected over observations with 
	missing values ({cmd:yes}) or gaps are left in the line 
	({cmd:no}) (#){p_end}
{p2col:{cmd:yesno       {space 6}p}{it:#}{cmd:cmissings} {space 0}{{cmd:yes}|{cmd:no}}}
        setting for  whether lines are connected over observations with 
	missing values ({cmd:yes}) or gaps are left in the line 
	({cmd:no}) for the {it:#}th plot (#){p_end}

{p2col:{cmd:connectstyle {space 0}p}                     {space 6}{it:{help connectstyle}}}
	default {it:connectstyle} for all plots{p_end}
{p2col:{cmd:connectstyle {space 0}p}{it:#}               {space 5}{it:{help connectstyle}}}
	{it:connectstyle} for the #th plot{p_end}
{p2line}
{p 3 3 2}(#) Settings shared with {help scheme line plots:line plots}

{p 3 3 2}
See {help scheme scatter plots} for the entries controlling the look of markers

{p 3 3 2}
If a scheme does not contain some of the connected-plot specific entries
above, the look of those elements of connected plots is determined
by default entries that are shared among all plottypes; see
{help scheme shared plots}.


{marker remarks2}{...}
{title:Composite entries for connected plots}

{p2colset 4 42 45 0}{...}
{p 3 3 2}
For most schemes shipped with Stata, the styles for these composite entries
are {cmd:p}{it:#} (where {it:#} is the number of the plot); in that case,
the individual attribute entries shown in the table above control the
characteristics of area plots.  If, however, the styles for the composite
entries are changed, then the individual attribute override entries affecting
area plots may also change.  See the discussion in
{it:{help scheme_files##remarks4:Composite entries}} of {help scheme files}.

{p 3 3 2}
The entries relating to markers and the overall {it:pstyle} are usually
shared with scatter plots.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:linestyle   {space 2}p}{it:#}{cmd:connect} {space 0}{it:{help linestyle}}}
	connecting {it:linestyle} for the #th connected plot{p_end}

{p2col:{cmd:linestyle   {space 2}p}{it:#}{cmd:mark}    {space 3}{it:{help linestyle}}}
	marker outline {it:linestyle} for the #th scatter plot; default style
	is {cmd:p#mark}{p_end}
{p2col:{cmd:markerstyle {space 0}p}{it:#}              {space 7}{it:{help linestyle}}}
	marker style for the #th scatter plot{p_end}
{p2col:{cmd:seriesstyle {space 0}p}{it:#}              {space 7}{it:{help pstyle}}}
	{it:pstyle} for the #th scatter plot{p_end}
{p2line}
{p2colreset}{...}
