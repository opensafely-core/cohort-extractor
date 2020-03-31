{smcl}
{* *! version 1.0.3  11feb2011}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Reference-line scheme entries}

{p2colset 4 43 46 0}{...}
{p 3 3 2}
These entries specify the look of reference lines for those graphs that use
them or when users explicitly specify the {cmd:refline} {help linestyle} for
a plot.  More accurately, they specify the attributes of the {cmd:refline}
{help linestyle}.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:color       {space 6}refline}  {space 2}{it:{help colorstyle}}}
	reference-line color{p_end}
{p2col:{cmd:linewidth   {space 2}refline}  {space 2}{it:{help linewidthstyle:linewidth}}}
	reference-line thickness{p_end}
{p2col:{cmd:linepattern {space 0}refline}  {space 2}{it:{help linepatternstyle}}}
	line pattern for reference lines{p_end}

{p2col:{cmd:linestyle   {space 2}refline}  {space 2}{it:{help linestyle}}}
	overall {it:linestyle} for reference lines selected through the 
	scheme (*){p_end}
{p2line}
{p 3 7 0}(*) Composite entry.{p_end}
{p2colreset}{...}
