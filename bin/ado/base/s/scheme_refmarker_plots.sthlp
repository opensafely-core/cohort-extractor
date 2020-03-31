{smcl}
{* *! version 1.0.3  11feb2011}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Reference-marker scheme entries}

{p2colset 4 43 46 0}{...}
{p 3 3 2}
These entries specify the look of reference markers for those graphs that use
them or when users explicitly specify the {cmd:refmarker} {help markerstyle}
for marker.  More accurately, they define the attributes of the
{cmd:refmarker} {help markerstyle}.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:symbol     {space 4}refmarker}   {space 2}{it:{help symbolstyle}}}
	reference-marker symbol{p_end}
{p2col:{cmd:symbolsize {space 0}refmarker}   {space 2}{it:{help markersizestyle}}}
	reference-marker size{p_end}
{p2col:{cmd:color      {space 5}refmarker}   {space 2}{it:{help colorstyle}}}
	reference-marker fill color{p_end}
{p2col:{cmd:color      {space 5}refmarkline} {space 0}{it:{help colorstyle}}}
	reference-marker outline color{p_end}
{p2col:{cmd:linewidth  {space 1}refmarker}   {space 2}{it:{help linewidthstyle:linewidth}}}
	reference-marker outline thickness{p_end}

{p2col:{cmd:linestyle  {space 1}refmarker}   {space 2}{it:{help linestyle}}}
	reference-marker outline style{p_end}
{p2line}
{p 3 7 0}(*) Composite entry.{p_end}
{p2colreset}{...}
