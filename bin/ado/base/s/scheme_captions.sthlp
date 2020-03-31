{smcl}
{* *! version 1.0.3  11feb2011}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Caption scheme entries}

{p2colset 4 50 53 0}{...}
{p 3 3 2}
These graphics scheme entries control the look of graph captions.  The look of
captions is shared across all graph families.{p_end}

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:gsize         {space 8}body}             {space 12}{it:{help textsizestyle}}}
	text size (#){p_end}
{p2col:{cmd:color         {space 8}body}             {space 12}{it:{help colorstyle}}}
	text color (#){p_end}
{p2col:{cmd:vertical_text {space 0}body}             {space 12}{it:{help alignmentstyle}}}
	text alignment (#){p_end}

{p2col:{cmd:margin        {space 7}body}             {space 12}{it:{help marginstyle}}}
	margin around text (#){p_end}

{p2col:{cmd:clockdir      {space 5}caption_position} {space 0}{it:{help clockpos}}}
	position with respect to plot region{p_end}
{p2col:{cmd:yesno         {space 8}caption_span}     {space 4}{{cmd:yes}|{cmd:no}}}
	{help scmd_ttlspan:centering/spanning}{p_end}
{p2col:{cmd:gridringstyle {space 0}caption_ring}     {space 4}{it:{help ringpos}}}
	{help scmd_ttlring:distance from plot region}{p_end}

{p2col:{cmd:textboxstyle  {space 1}caption}          {space 9}{it:{help textboxstyle}}}
	overall style of captions (*){p_end}
{p2line}
{p 3 7 0}(#) Shared with legend titles for many schemes.  Also, see (*)
below for effects of composite entries.{p_end}
{p 3 7 0}(*) Composite entry.  For most official schemes, {it:textboxstyle} is
{cmd:heading}, and the entries in the table that identify {cmd:heading} as the
graph element will affect titles.  If a scheme specifies a different composite
style for {it:textboxstyle}, entries associated with that composite style
must be used to change the look of titles.{p_end}
{p2colreset}{...}
