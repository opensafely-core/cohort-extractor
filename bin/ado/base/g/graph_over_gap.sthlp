{smcl}
{* *! version 1.1.3  11feb2011}{...}
{* this hlp file called by the graph bar, graph box, and graph dot dialogs}{...}
{vieweralsosee "[G-2] graph bar" "help graph_bar"}{...}
{title:Options related to {it:Gap} specified with {it:Over}}

{pstd}
The {it:over} option can be specified with several different types
of graphs (that is, bar, box, and dot).  For this reason, over groups of a
specific graph type are simply referred to as categories.

{col 5}{bf:Gap} accepts{col 31}Description
    {hline -2}
{p 4 32 2}
{it:#}{space 24} specify the gap between the categories of an {bf:Over} group as a percentage.

{p 4 32 2}
{it:*#}{space 23} specify the gap between the categories of an {bf:Over} group as a multiplier.
{p_end}
{col 5}{hline -2}
{p 4 4 2}

{phang}
{cmd:gap(}{it:#}{cmd:)} and
{cmd:gap(*}{it:#}{cmd:)}
    specify the gap between the categories in an {cmd:over} group.
    {cmd:gap(}{it:#}{cmd:)} is specified in percent-of-width units, so
    {cmd:gap(67)} means two-thirds the width of a bar, box, or line.
    {cmd:gap(*}{it:#}{cmd:)} allows modifying the default gap.
    {cmd:gap(*1.2)} would increase the gap by 20% and {cmd:gap(*.8)} would
    decrease the gap by 20%.

{pstd}
{bf:Note:} The {it:gap} option is rarely used with dot plots. 
{p_end}
