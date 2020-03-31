{smcl}
{* *! version 1.0.3  11feb2011}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Graph notes scheme entries}

{p2colset 4 50 53 0}{...}
{p 3 3 2}
These graphics scheme entries control the look of graph notes across all
graph families.{p_end}

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:gsize         {space 8}small_body}      {space 5}{it:{help textsizestyle}}}
	text size{p_end}
{p2col:{cmd:color         {space 8}small_body}      {space 5}{it:{help colorstyle}}}
	text color (#){p_end}
{p2col:{cmd:vertical_text {space 0}small_body}      {space 5}{it:{help alignmentstyle}}}
	text alignment (#){p_end}

{p2col:{cmd:margin        {space 7}small_body}      {space 5}{it:{help marginstyle}}}
	margin around text (#){p_end}

{p2col:{cmd:clockdir      {space 5}note_position}   {space 2}{it:{help clockpos}}}
	position with respect to plot region{p_end}
{p2col:{cmd:yesno         {space 8}note_span}       {space 6}{{cmd:yes}|{cmd:no}}}
	{help scmd_ttlspan:centering/spanning}{p_end}
{p2col:{cmd:gridringstyle {space 0}note_ring}       {space 6}{it:{help ringpos}}}
	{help scmd_ttlring:distance from plot region}{p_end}

{p2col:{cmd:textboxstyle  {space 1}note}            {space 11}{it:{help textboxstyle}}}
	overall style of notes (*){p_end}
{p2line}
{p 3 7 0}(#) Shared with legend titles for many schemes.  Also, see (*)
below for effects of composite entries.{p_end}
{p 3 7 0}(*) Composite entry.  For most official schemes, {it:textboxstyle} is
{cmd:heading}, and the entries in the table that identify {cmd:heading} as the
graph element will affect titles.  If a scheme specifies a different composite
style for {it:textboxstyle}, entries associated with that composite style
must be used to change the look of titles.{p_end}
{p2colreset}{...}
