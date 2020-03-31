{smcl}
{* *! version 1.0.3  11feb2011}{...}
{vieweralsosee "scheme foreground def" "help scheme foreground def"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Background style definitions}

{p2colset 4 46 49 0}{...}
{p 3 3 2}
Most schemes shipped with Stata use the common {cmd:background} 
{help areastyle:areastyles} and {help linestyle:linestyles} to specify the
look of some graph elements.  These are the scheme entries that define the
{cmd:background} styles.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:color       {space 6}background} {space 0}{it:{help colorstyle}}}
	background color{p_end}

{p2col:{cmd:intensity   {space 2}background} {space 0}{it:{help intensitystyle}}}
	intensity for background areas{p_end}
{p2col:{cmd:shadestyle  {space 1}background} {space 0}{it:{help shadestyle}}}
	fill {it:shadestyle} for background {bind:areas (*)}{p_end}

{p2col:{cmd:linewidth   {space 2}background} {space 0}{it:{help linewidthstyle:linewidth}}}
	background line thickness; rarely used{p_end}
{p2col:{cmd:linepattern {space 0}background} {space 0}{it:{help linepatternstyle}}}
	line pattern for background lines; rarely used{p_end}
{p2col:{cmd:linestyle   {space 2}background}   {space 0}{it:{help linestyle}}}
	{it:linestyle} for background lines; rarely {bind:used (*)}{p_end}
{p2line}
{p 3 7 0}(*) Composite entry.  For most official schemes, the styles for these
composite entries are {cmd:background}, and the other entries in
the table will affect the look of backgrounds.  If a scheme specifies a
different style in one of the composite entries, entries associated with
that composite style must be used to change the look of backgrounds.{p_end}
{p2colreset}{...}
