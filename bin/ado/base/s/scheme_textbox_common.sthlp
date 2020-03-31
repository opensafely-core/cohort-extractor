{smcl}
{* *! version 1.0.4  11feb2011}{...}
{vieweralsosee "[G-4] textboxstyle" "help textboxstyle"}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Common text boxing entries}

{p2colset 4 40 43 0}{...}
{p 3 3 2}
Most schemes shipped with Stata use this common set of entries to determine
whether a box is drawn around text elements and how that box looks.  Note 
that these entries are shared by a number of other
{help textboxstyle:textboxstyles} and that changing them may change the look of
many graph text elements.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:yesno       {space 5}textbox}       {space 2}{{cmd:yes}|{cmd:no}}}
	whether box is drawn around text {cmd:yes}, or not {cmd:no}{p_end}
{p2col:{cmd:color       {space 5}textbox}       {space 2}{it:{help colorstyle}}}
	fill color of box{p_end}
{p2col:{cmd:margin        {space 4}textbox}     {space 2}{it:{help marginstyle}}}
	outer margin around box{p_end}

{p2col:{cmd:linestyle   {space 1}textbox}      {space 2}{it:{help linestyle}}}
	style of line drawn around box; composite style{p_end}
{p2line}
{p2colreset}{...}
