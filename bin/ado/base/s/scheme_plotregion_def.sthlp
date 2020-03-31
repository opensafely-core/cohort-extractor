{smcl}
{* *! version 1.0.4  11feb2011}{...}
{vieweralsosee "[G-4] areastyle" "help areastyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:plotregion areastyle definition}

{p2colset 4 46 49 0}{...}
{p 3 3 2}
Most schemes shipped with Stata use the common {cmd:plotregion} 
{it:{help areastyle}} for most or all graph families.  These are the entries
that define that {it:areastyle}.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:color       {space 6}plotregion}  {space 1}{it:{help colorstyle}}}
	fill color{p_end}
{p2col:{cmd:intensity   {space 2}plotregion}  {space 1}{it:{help intensitystyle}}}
	fill intensity{p_end}
{p2col:{cmd:linewidth   {space 2}plotregion}  {space 1}{it:{help linewidthstyle:linewidth}}}
	outline thickness{p_end}
{p2col:{cmd:linepattern {space 0}plotregion}  {space 1}{it:{help linepatternstyle}}}
	outline pattern{p_end}
{p2col:{cmd:color       {space 6}plotregion_line} {space 2}{it:{help colorstyle}}}
	outline color{p_end}

{p2col:{cmd:shadestyle  {space 1}plotregion}  {space 1}{it:{help shadestyle}}}
	plot region {it:shadestyle} (*){p_end}
{p2col:{cmd:linestyle   {space 2}plotregion}  {space 1}{it:{help linestyle}}}
	outline line style (*){p_end}
{p2line}
{p 3 7 0}(*) Composite entry.  For most official schemes, the styles for these
composite entries are {cmd:plotregion}, and the entries in the first section
of the table will affect the look of plot regions.  If a scheme specifies a
different style in one of the composite entries, entries associated with
that composite style must be used to change the look of plot regions.{p_end}
{p2colreset}{...}
