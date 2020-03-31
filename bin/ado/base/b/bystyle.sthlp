{smcl}
{* *! version 1.1.6  19oct2017}{...}
{vieweralsosee "[G-4] bystyle" "mansection G-4 bystyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] by_option" "help by_option"}{...}
{viewerjumpto "Syntax" "bystyle##syntax"}{...}
{viewerjumpto "Description" "bystyle##description"}{...}
{viewerjumpto "Links to PDF documentation" "bystyle##linkspdf"}{...}
{viewerjumpto "Remarks" "bystyle##remarks"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[G-4]} {it:bystyle} {hline 2}}Choices for look of by-graphs{p_end}
{p2col:}({mansection G-4 bystyle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 15}{...}
{p2col:{it:bystyle}}Description{p_end}
{p2line}
{p2col:{cmd:default}}determined by scheme{p_end}
{p2col:{cmd:compact}}a more compact version of {cmd:default}{p_end}
{p2col:{cmd:stata7}}like that provided by Stata 7{p_end}
{p2line}
{p2colreset}{...}

{p 4 4 2}
Other {it:bystyles} may be available; type

	{cmd:.} {bf:{stata graph query bystyle}}

{p 4 4 2}
to obtain the complete list of {it:bystyles} installed on your computer.


{marker description}{...}
{title:Description}

{pstd}
{it:bystyles} specify the overall look of by-graphs.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 bystyleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help bystyle##remarks1:What is a by-graph?}
	{help bystyle##remarks2:What is a bystyle?}


{marker remarks1}{...}
{title:What is a by-graph?}

{pstd}
A by-graph is one graph (image, really) containing an array of separate
graphs, each of the same type, and each reflecting a different subset of the
data.  For instance, a by-graph might contain graphs of miles per gallon
versus weight, one for domestic cars and the other for foreign.

{pstd}
By-graphs are produced when you specify the {cmd:by()} option;
see {manhelpi by_option G-3}.


{marker remarks2}{...}
{title:What is a bystyle?}

{pstd}
A {it:bystyle} determines the overall look of the combined graphs, including

{phang2}
    1.  whether the individual graphs have their own axes and labels or
	if instead the axes and labels are shared across graphs arrayed in the
	same row and/or in the same column;

{phang2}
    2.  whether the scales of axes are in common or allowed to be different
	for each graph; and

{phang2}
    3.  how close the graphs are placed to each other.

{pstd}
There are options that let you control each of the above 
attributes -- see {manhelpi by_option G-3} -- but the {it:bystyle}
specifies the starting point.

{pstd}
You need not specify a {it:bystyle} just because there is something you want
to change.  You specify a {it:bystyle} when another style exists that is
exactly what you desire or when another style would allow you to specify
fewer changes to obtain what you want.
{p_end}
