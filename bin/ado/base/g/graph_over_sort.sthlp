{smcl}
{* *! version 1.1.3  11feb2011}{...}
{* this hlp file called by the graph bar, graph box, and graph dot dialogs}{...}
{vieweralsosee "[G-2] graph bar" "help graph_bar"}{...}
{title:Options related to {it:Sort} specified with {it:Over}}

{pstd}
The {it:over} option can be specified with several different types
of graphs (that is, bar, box, and dot).  For this reason, over groups of a
specific graph type are simply referred to as categories.

{col 5}{bf:Sort} accepts{col 31}Description
    {hline -2}
{p 4 32 2}
{it:varname} {space 17} sort categories based on a {it:varname}

{p 4 32 2}
{it:#} {space 23} sort categories based on {it:#}th variable 
in the varlist

{p 4 32 2}
{cmd:(}{it:stat}{cmd:)} {it:varname} {space 10}
sort categories based on {it:stat} for a {it:varname};
see {manhelp collapse D} for list of possible {it:stat}s
{p_end}
    {hline -2}

{p 4 4 2}
{bf:Sort descending} reverses the default or specified sort order.
{p_end}
