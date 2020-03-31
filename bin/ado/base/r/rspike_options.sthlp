{smcl}
{* *! version 1.1.7  15may2018}{...}
{vieweralsosee "[G-3] rspike_options" "mansection G-3 rspike_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] Concept: lines" "help lines"}{...}
{viewerjumpto "Syntax" "rspike_options##syntax"}{...}
{viewerjumpto "Description" "rspike_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "rspike_options##linkspdf"}{...}
{viewerjumpto "Options" "rspike_options##options"}{...}
{viewerjumpto "Remarks" "rspike_options##remarks"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[G-3]} {it:rspike_options} {hline 2}}Options for determining the look of range spikes{p_end}
{p2col:}({mansection G-3 rspike_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 30}{...}
{p2col:{it:rspike_options}}Description{p_end}
{p2line}
{p2col:{cmdab:lp:attern:(}{it:{help linepatternstyle}}{cmd:)}}whether spike
      line is solid, dashed, etc.{p_end}
{p2col:{cmdab:lw:idth:(}{it:{help linewidthstyle}}{cmd:)}}thickness of spike
      line{p_end}
{p2col:{cmdab:lc:olor:(}{it:{help colorstyle}}{cmd:)}}color and opacity of spike line{p_end}

{p2col:{cmdab:lsty:le:(}{it:{help linestyle}}{cmd:)}}overall style of spike
      line{p_end}
{p2col:{cmdab:psty:le:(}{it:{help pstyle}}{cmd:)}}overall plot style,
      including line style{p_end}

{p2col:{help advanced_options:{bf:recast(}{it:newplottype}{bf:)}}}advanced;
      treat plot as {it:newplottype}{p_end}
{p2line}
{p2colreset}{...}
{p 4 6 2}
All options are {it:rightmost}; see {help repeated options}.


{marker description}{...}
{title:Description}

{pstd}
The {it:rspike_options} determine the look of spikes (lines connecting two
points vertically or horizontally) in most contexts.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 rspike_optionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:lpattern(}{it:linepatternstyle}{cmd:)}
    specifies whether the line for the spike is solid, dashed, etc.
    See {manhelpi linepatternstyle G-4} for a list of available patterns.

{phang}
{cmd:lwidth(}{it:linewidthstyle}{cmd:)}
    specifies the thickness of the line for the spike.
    See {manhelpi linewidthstyle G-4} for a list of available thicknesses.

{phang}
{cmd:lcolor(}{it:colorstyle}{cmd:)}
    specifies the color and opacity of the line for the spike.  See
    {manhelpi colorstyle G-4}
    for a list of available colors.

{phang}
{cmd:lstyle(}{it:linestyle}{cmd:)}
    specifies the overall style of the line for the spike:  its pattern,
    thickness, and color.

{pmore}
    You need not specify {cmd:lstyle()} just because there is something
    you want to change about the look of the spike.  The other
    {it:rspike_options} will allow you to make changes.  You specify
    {cmd:lstyle()} when another style exists that is exactly what you want 
    or when another style would allow you to specify fewer changes.

{pmore}
    See {manhelpi linestyle G-4} for a list of available line styles.

{phang}
{cmd:pstyle(}{it:pstyle}{cmd:)}
    specifies the overall style of the plot, including not only the
    {it:{help linestyle}}, but also all other settings for the look of the plot.
    Only the {it:linestyle} affects the look of spikes.  See 
    {manhelpi pstyle G-4} for a list of available plot styles.

{phang}
{cmd:recast(}{it:newplottype}{cmd:)}
        is an advanced option allowing the plot to be recast from one type to
        another, for example, from a {help twoway rspike:range spike plot} to 
	a {help twoway rarea:range area plot}; see
        {manhelpi advanced_options G-3}.  Most, but not all, plots allow
        {cmd:recast()}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Range spikes are used in many contexts.  They are sometimes the default for
confidence intervals.  For instance, the {cmd:lcolor()} suboption of
{cmd:ciopts()} in

{phang2}
	{cmd:. ltable age, graph ciopts(lcolor(red))}

{pstd}
causes the color of the horizontal lines representing the confidence intervals
in the life-table graph to be drawn in red.
{p_end}
