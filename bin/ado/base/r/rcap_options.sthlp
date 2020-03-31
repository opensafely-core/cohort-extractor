{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[G-3] rcap_options" "mansection G-3 rcap_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] Concept: lines" "help lines"}{...}
{viewerjumpto "Syntax" "rcap_options##syntax"}{...}
{viewerjumpto "Description" "rcap_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "rcap_options##linkspdf"}{...}
{viewerjumpto "Options" "rcap_options##options"}{...}
{viewerjumpto "Remarks" "rcap_options##remarks"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[G-3]} {it:rcap_options} {hline 2}}Options for determining the look of range plots with capped spikes{p_end}
{p2col:}({mansection G-3 rcap_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 30}{...}
{p2col:{it:rcap_options}}Description{p_end}
{p2line}
{p2col:{it:{help line_options}}}change look of spike and cap lines{p_end}
{p2col:{cmdab:msiz:e:(}{it:{help markersizestyle}}{cmd:)}}width of cap{p_end}

{p2col:{help advanced_options:{bf:recast(}{it:newplottype}{bf:)}}}advanced;
      treat plot as {it:newplottype}{p_end}
{p2line}
{p2colreset}{...}
{p 4 6 2}
All options are {it:rightmost}; see {help repeated options}.


{marker description}{...}
{title:Description}

{pstd}
The {it:rcap_options} determine the look of spikes (lines connecting two
points vertically or horizontally) and their endcaps.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 rcap_optionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{it:line_options} 
    specify the look of the lines used to draw the spikes and their caps,
    including pattern, width, and color; see {manhelpi line_options G-3}.{p_end}

{phang}
{cmd:msize(}{it:markersizestyle}{cmd:)}
    specifies the width of the cap.  Option {cmd:msize()} is in fact
    {cmd:twoway} {cmd:scatter}'s {it:marker_option} that sets the size of the
    marker symbol, but here {cmd:msymbol()} is borrowed to set the cap width.
    See {manhelpi markersizestyle G-4} for a list of size choices.

{phang}
{cmd:recast(}{it:newplottype}{cmd:)}
        is an advanced option allowing the plot to be recast from one type to
        another, for example, from a {help twoway rcap:range-capped plot} to 
	an {help twoway area:area plot}; see 
        {manhelpi advanced_options G-3}.  Most, but not all, plots allow
        {cmd:recast()}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Range-capped plots are used in many contexts.  They are sometimes the default
for confidence intervals.  For instance, the {cmd:lcolor()} suboption of
{helpb tabodds##ciopts():ciopts()} in

{phang2}
	{cmd:. tabodds died age, ciplot ciopts(lcolor(green))}

{pstd}
causes the color of the horizontal lines representing the confidence intervals
in the graph to be drawn in green.
{p_end}
