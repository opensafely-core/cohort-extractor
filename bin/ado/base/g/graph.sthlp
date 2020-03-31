{smcl}
{* *! version 1.2.4  15may2018}{...}
{vieweralsosee "[G-2] graph" "mansection G-2 graph"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-1] Graph intro" "help graph_intro"}{...}
{vieweralsosee "[G-2] graph other" "help graph_other"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph export" "help graph_export"}{...}
{vieweralsosee "[G-2] graph print" "help graph_print"}{...}
{vieweralsosee "[G-2] graph7" "help graph7"}{...}
{viewerjumpto "Syntax" "graph##syntax"}{...}
{viewerjumpto "Description" "graph##description"}{...}
{viewerjumpto "Links to PDF documentation" "graph##linkspdf"}{...}
{viewerjumpto "Remarks" "graph##remarks"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[G-2] graph} {hline 2}}The graph command{p_end}
{p2col:}({mansection G-2 graph:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pin}
{cmdab:gr:aph} ...

{pstd}
The commands that draw graphs are

{p2colset 9 33 35 2}{...}
{p2col :Command}Description{p_end}
{p2line}
{p2col :{helpb twoway:graph twoway}}scatterplots, line plots, etc.{p_end}
{p2col :{helpb graph matrix}}scatterplot matrices{p_end}
{p2col :{helpb graph bar}}bar charts{p_end}
{p2col :{helpb graph dot}}dot charts{p_end}
{p2col :{helpb graph box}}box-and-whisker plots{p_end}
{p2col :{helpb graph pie}}pie charts{p_end}
{p2col :{it:{help graph_other:other}}}more commands to draw statistical graphs{p_end}
{p2line}
{p2colreset}{...}

{pstd}
The commands that save a previously drawn graph, redisplay previously saved
graphs, and combine graphs are

{p2colset 9 33 35 2}{...}
{p2col :Command}Description{p_end}
{p2line}
{p2col :{helpb graph save}}save graph to disk{p_end}
{p2col :{helpb graph use}}redisplay graph stored on disk{p_end}
{p2col :{helpb graph display}}redisplay graph stored in memory{p_end}
{p2col :{helpb graph combine}}combine multiple graphs{p_end}
{p2col :{helpb graph replay}}redisplay graphs stored in memory and on disk{p_end}
{p2line}
{p2colreset}{...}

{pstd}
The commands for printing a graph are

{p2colset 9 33 35 2}{...}
{p2col :Command}Description{p_end}
{p2line}
{p2col :{helpb graph print}}print currently displayed graph{p_end}
{p2col :{helpb set printcolor}}set how colors are printed{p_end}
{p2col :{helpb graph export}}export .gph file to PostScript, etc.{p_end}
{p2line}
{p2colreset}{...}

{pstd}
The commands that deal with the graphs currently stored in memory are

{p2colset 9 33 35 2}{...}
{p2col :Command}Description{p_end}
{p2line}
{p2col :{helpb graph display}}display graph{p_end}
{p2col :{helpb graph dir}}list names{p_end}
{p2col :{helpb graph describe}}describe contents{p_end}
{p2col :{helpb graph rename}}rename memory graph{p_end}
{p2col :{helpb graph copy}}copy memory graph to new name{p_end}
{p2col :{helpb graph drop}}discard graphs in memory{p_end}
{p2col :{helpb graph close}}close Graph windows{p_end}
{p2line}
{p2colreset}{...}
{pin}
Also see {manhelp graph_manipulation G-2:graph manipulation}.

{pstd}
The commands that describe available schemes and allow you to identify and set 
the default scheme are

{p2colset 9 33 35 2}{...}
{p2col :Command}Description{p_end}
{p2line}
{p2col :{helpb graph query:graph query, schemes}}list available schemes{p_end}
{p2col :{helpb set scheme:query graphics}}identify default scheme{p_end}
{p2col :{helpb set scheme:set scheme}}set default scheme{p_end}
{p2line}
{p2colreset}{...}
{pin}
Also see
{manhelp schemes G-4:Schemes intro}.

{pstd}
The command that lists available styles is

{p2colset 9 33 35 2}{...}
{p2col :Command}Description{p_end}
{p2line}
{p2col :{helpb graph query}}list available styles{p_end}
{p2line}
{p2colreset}{...}

{pstd}
The command for setting options for printing and exporting graphs is

{p2colset 9 33 35 2}{...}
{p2col :Command}Description{p_end}
{p2line}
{p2col :{helpb graph set}}set graphics options{p_end}
{p2line}
{p2colreset}{...}

{pstd}
The command that allows you to draw graphs without displaying them is

{p2colset 9 33 35 2}{...}
{p2col :Command}Description{p_end}
{p2line}
{p2col :{helpb set graphics}}set whether graphs are displayed{p_end}
{p2line}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:graph} draws graphs.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
See {manhelp graph_intro G-1:Graph intro}.
{p_end}
