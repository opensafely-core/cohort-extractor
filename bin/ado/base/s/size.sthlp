{smcl}
{* *! version 1.0.1  20sep2019}{...}
{vieweralsosee "[G-4] size" "mansection G-4 size"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] linewidthstyle" "help linewidthstyle"}{...}
{vieweralsosee "[G-4] marginstyle" "help marginstyle"}{...}
{vieweralsosee "[G-4] markersizestyle" "help markersizestyle"}{...}
{vieweralsosee "[G-4] textsizestyle" "help textsizestyle"}{...}
{viewerjumpto "Syntax" "size##syntax"}{...}
{viewerjumpto "Description" "size##description"}{...}
{viewerjumpto "Links to PDF documentation" "size##linkspdf"}{...}
{p2colset 1 15 25 2}{...}
{p2col:{bf:[G-4]} {it:size} {hline 2}}Choices for sizes of objects{p_end}
{p2col:}({mansection G-4 size:View complete PDF manual entry}){p_end}


{marker syntax}{...}
{title:Syntax}

{synoptset 20}{...}
{p2col:{it:size}}Description{p_end}
{p2line}
{synopt :{it:#}{cmd:pt}}specify size in printer point{p_end}
{synopt :{it:#}{cmd:in}}specify size in inches{p_end}
{synopt :{it:#}{cmd:cm}}specify size in centimeters{p_end}
{synopt :{it:#}{cmd:rs}}specify size in relative size, where
size 100 = minimum of width and height of graph; {it:#} must be {ul:>} 0{p_end}

{synopt :{it:#}}specify the size; unit will depend on the scheme and type of
graph specified¹

{synopt :{cmd:*}{it:#}}specify size change via multiplication;
{cmd:*1} means no change, {cmd:*2} twice as large, {cmd:*.5} half;
{it:#} must be {ul:>} 0, depending on context{p_end}
{p2line}
{p 4 6 2}
Negative sizes are allowed in certain contexts, such as for gaps; in other
cases, such as the size of symbol, the size must be nonnegative, and negative
sizes, if specified, are ignored.

{p 4 6 2}
¹ As of Stata 16, all official {help schemes} use relative size as the unit
for {it:#}, except for the styles used by forest plots (see
{helpb meta_forestplot:[META] meta forestplot}), which default to printer
point.


{pstd}
Examples:

{p2col:{it:example}}Description{p_end}
{p2line}
{synopt :{cmd:msize(4pt)}}make marker diameter 4 points{p_end}
{synopt :{cmd:msize(.1in)}}make marker diameter 0.1 inch{p_end}
{synopt :{cmd:msize(.2cm)}}make marker diameter 0.2 centimeters{p_end}
{synopt :{cmd:msize(1.5)}}make marker diameter 1.5% of {it:g}{p_end}
{synopt :{cmd:msize(*1.5)}}make marker size 1.5 times as large as
default{p_end}
{synopt :{cmd:msize(*.5)}}make marker size half as large as default{p_end}

{synopt :{cmd:lwidth(1pt)}}make thickness of line 1 point{p_end}
{synopt :{cmd:size(12pt)}}make text size 12 points{p_end}
{synopt :{cmd:mlwidth(.3cm)}}make thickness of outline 0.3 centimeters{p_end}
{synopt :{cmd:labgap(.5in)}}make gap between tick and label 0.5 inch{p_end}
{synopt :{cmd:xsca(titlegap(2))}}make gap 2% of {it:g}{p_end}
{synopt :{cmd:xsca(titlegap(*-.5))}}make gap -0.5 times as large as
default{p_end}
{p2line}
{p 4 6 2}
where {it:g} = min(width of graph, height of graph){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{it:size} specifies the size of text, markers, margins, line
thickness, line spacing, gaps, etc., in printer points, inches,
centimeters, and relative size.  You can specify units on all sizes except
those that are explicitly relative to another object in the graph.

{pstd}
To specify a size in specific units, add a unit suffix to the size -- {cmd:pt}
for printer points, {cmd:in} for inches, {cmd:cm} for centimeters, and
{cmd:rs} for relative size -- for example, {cmd:12pt}.

{pstd}
The relative size specifies a size relative to the graph (or subgraph) being
drawn.  Thus as the size of the graph changes, so does the size of the object.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 sizeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.
{p_end}
