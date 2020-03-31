{smcl}
{* *! version 1.0.4  11feb2011}{...}
{vieweralsosee "scheme files" "help scheme files"}{...}
{title:Shared default plot entries {c -} defaults for all plottypes}

{p2colset 4 45 48 0}{...}
{p 3 3 2}
These entries control the look of all plots for which the scheme does not
include separate entries controlling the look of specific plottypes, such as
those in {help scheme scatter plots} or {help scheme bar plots}.  They 
provide default
settings whenever more specific settings are not provided in the scheme.  For
many schemes, changing these entries changes the look of all plots regardless
of plottype, for example, {helpb twoway scatter}, {helpb twoway area}, etc.
See section 3, {bf:Plot entries}, of {help scheme files} for a discussion of
plot entries.

{p2col:Entry} Description{p_end}
{p2line}
{p2col:{cmd:color       {space 6}p}{it:#}                {space 9}{it:{help colorstyle}}}
	color of all graph elements of the #th plot{p_end}
{p2col:{cmd:linewidth   {space 2}p}                      {space 10}{it:{help linewidthstyle:linewidth}}}
	default thickness of all lines, except bar outlines, for all graph
	families, plottypes, and plots{p_end}
{p2col:{cmd:linewidth   {space 2}p}{it:#}                {space 9}{it:{help linewidthstyle:linewidth}}}
	line thickness of all lines, except bar outlines, for the #th 
	plot{p_end}
{p2col:{cmd:linepattern {space 0}p}                      {space 10}{it:{help linewidthstyle:linewidth}}}
	default pattern of all lines for all graph
	families, plottypes, and plots{p_end}
{p2col:{cmd:linepattern {space 0}p}{it:#}                {space 9}{it:{help linepatternstyle}}}
	line pattern of all lines for the #th plot{p_end}

{p2col:{cmd:intensity   {space 2}p}                      {space 10}{it:{help linewidthstyle:linewidth}}}
	default intensity of filled areas for all graph
	families, plottypes, and plots{p_end}
{p2col:{cmd:intensity   {space 2}p}{it:#}{cmd:shade}     {space 4}{it:{help intensitystyle}}}
	intensity of some filled areas for the #th plot{p_end}

{p2col:{cmd:symbol      {space 5}p}                     {space 10}{it:{help symbolstyle}}}
	default marker symbol for all plots{p_end}
{p2col:{cmd:symbol      {space 5}p}{it:#}               {space 9}{it:{help symbolstyle}}}
	marker symbol for the #th plot{p_end}
{p2col:{cmd:symbolsize  {space 1}p}                     {space 10}{it:{help markersizestyle}}}
	default size of marker symbols for all plot{p_end}
{p2col:{cmd:symbolsize  {space 1}p}{it:#}               {space 9}{it:{help markersizestyle}}}
	size of marker symbols for #th plot{p_end}
{p2line}
{p2colreset}{...}
