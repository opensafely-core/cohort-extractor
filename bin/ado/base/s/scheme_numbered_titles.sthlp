{smcl}
{* *! version 1.0.4  11feb2011}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Numbered titles scheme entries}

{p2colset 4 50 53 0}{...}
{p 3 3 2}
These graphics scheme entries control the look of numbered graph titles, for
example, {cmd:b1title}.  The look of numbered titles is shared across all graph
families.{p_end}

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:textboxstyle  {space 1}t1title}       {space 7}{it:{help textboxstyle}}}
	overall style of {cmd:t1title} (*){p_end}
{p2col:{cmd:textboxstyle  {space 1}t2title}       {space 7}{it:{help textboxstyle}}}
	overall style of {cmd:t2title} (#){p_end}
{p2col:{cmd:textboxstyle  {space 1}b1title}       {space 7}{it:{help textboxstyle}}}
	overall style of {cmd:b1title} (*){p_end}
{p2col:{cmd:textboxstyle  {space 1}b2title}       {space 7}{it:{help textboxstyle}}}
	overall style of {cmd:b2title} (#){p_end}
{p2col:{cmd:textboxstyle  {space 1}l1title}       {space 7}{it:{help textboxstyle}}}
	overall style of {cmd:l1title} (*){p_end}
{p2col:{cmd:textboxstyle  {space 1}l2title}       {space 7}{it:{help textboxstyle}}}
	overall style of {cmd:l2title} (#){p_end}
{p2col:{cmd:textboxstyle  {space 1}r1title}       {space 7}{it:{help textboxstyle}}}
	overall style of {cmd:r1title} (*){p_end}
{p2col:{cmd:textboxstyle  {space 1}r2title}       {space 7}{it:{help textboxstyle}}}
	overall style of {cmd:r2title} (#){p_end}
{p2line}
{p 3 7 0}(*) Composite entry.  For most official schemes, {it:textboxstyle} is
{cmd:heading}, meaning that these titles share the attributes of graph
titles; see {help scheme titles:graph titles} for setting these
attributes.  If a scheme specifies a different composite style for
{it:textboxstyle} in one of these entries, entries associated with that
composite style must be used to change the look of titles.{p_end}
{p 3 7 0}(#) Composite entry.  For most official schemes {it:textboxstyle} is
{cmd:subheading}, meaning that these titles share the attributes of graph
subtitles; see {help scheme subtitles:graph subtitles} 
for setting these
attributes.  If a scheme specifies a different composite style for
{it:textboxstyle} in one of these entries, entries associated with that
composite style must be used to change the look of titles.{p_end}
{p2colreset}{...}
