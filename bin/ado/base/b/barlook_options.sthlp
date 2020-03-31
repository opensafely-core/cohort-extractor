{smcl}
{* *! version 1.1.9  19oct2017}{...}
{vieweralsosee "[G-3] barlook_options" "mansection G-3 barlook_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] areastyle" "help areastyle"}{...}
{vieweralsosee "[G-4] colorstyle" "help colorstyle"}{...}
{vieweralsosee "[G-4] linealignmentstyle" "help linealignmentstyle"}{...}
{vieweralsosee "[G-4] linepatternstyle" "help linepatternstyle"}{...}
{vieweralsosee "[G-4] linestyle" "help linestyle"}{...}
{vieweralsosee "[G-4] linewidthstyle" "help linewidthstyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph bar" "help graph_bar"}{...}
{vieweralsosee "[G-2] graph twoway bar" "help twoway_bar"}{...}
{vieweralsosee "[G-2] graph twoway rbar" "help twoway_rbar"}{...}
{viewerjumpto "Syntax" "barlook_options##syntax"}{...}
{viewerjumpto "Description" "barlook_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "barlook_options##linkspdf"}{...}
{viewerjumpto "Options" "barlook_options##options"}{...}
{viewerjumpto "Remarks" "barlook_options##remarks"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[G-3]} {it:barlook_options} {hline 2}}Options for setting the look of bars{p_end}
{p2col:}({mansection G-3 barlook_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 30}{...}
{p2col:{it:barlook_options}}Description{p_end}
{p2line}
{p2col:{cmdab:col:or:(}{it:{help colorstyle}}{cmd:)}}outline and fill color
and opacity{p_end}
{p2col:{cmdab:fc:olor:(}{it:{help colorstyle}}{cmd:)}}fill color and opacity{p_end}
{p2col:{cmdab:fi:ntensity:(}{it:{help intensitystyle}}{cmd:)}}fill intensity{p_end}

{p2col:{cmdab:lc:olor:(}{it:{help colorstyle}}{cmd:)}}outline color and
opacity{p_end}
{p2col:{cmdab:lw:idth:(}{it:{help linewidthstyle}}{cmd:)}}thickness of outline{p_end}
{p2col:{cmdab:lp:attern:(}{it:{help linepatternstyle}}{cmd:)}}outline pattern (solid, dashed, etc.){p_end}
{p2col:{cmdab:la:lign:(}{it:{help linealignmentstyle}}{cmd:)}}outline alignment (inside, outside, center){p_end}
{p2col:{cmdab:lsty:le:(}{it:{help linestyle}}{cmd:)}}overall look of outline{p_end}

{p2col:{cmdab:bsty:le:(}{it:{help areastyle}}{cmd:)}}overall look of bar, all settings above{p_end}
{p2col:{cmdab:psty:le:(}{it:{help pstyle}}{cmd:)}}overall plot style, including areastyle{p_end}
{p2line}
{p2colreset}{...}
{p 4 6 2}
All options are {it:merged-implicit}; see 
{help repeated options}.


{marker description}{...}
{title:Description}

{pstd}
The {it:barlook_options} determine the look of bars produced by
{helpb graph bar}, {helpb graph hbar}, {helpb graph twoway bar},
and several other commands that render
bars.  The {it:barlook_options} and the {it:{help area_options}} are
synonyms, and the options may be used interchangeably.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 barlook_optionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:color(}{it:colorstyle}{cmd:)}
    specifies one color and opacity to be used both to outline the shape of the
    bar and to fill its interior.
    See {manhelpi colorstyle G-4} for a list of color choices.

{phang}
{cmd:fcolor(}{it:colorstyle}{cmd:)}
    specifies the color and opacity to be used to fill the interior of the bar.
    See {manhelpi colorstyle G-4} for a list of color choices.

{phang}
{cmd:fintensity(}{it:intensitystyle}{cmd:)}
    specifies the intensity of the color used to fill the interior of the bar.
    See {manhelpi intensitystyle G-4} for a list of intensity choices.

{phang}
{cmd:lcolor(}{it:colorstyle}{cmd:)}
    specifies the color and opacity to be used to outline the bar.
    See {manhelpi colorstyle G-4} for a list of color choices.

{phang}
{cmd:lwidth(}{it:linewidthstyle}{cmd:)}
    specifies the thickness of the line to be used to outline the bar.
    See {manhelpi linewidthstyle G-4} for a list of choices.

{phang}
{cmd:lpattern(}{it:linepatternstyle}{cmd:)}
    specifies whether the line used to outline the bar is solid, dashed,
    etc.
    See {manhelpi linepatternstyle G-4} for a list of pattern choices.

{phang}
{cmd:lalign(}{it:linealignmentstyle}{cmd:)}
    specifies whether the line used to outline the bar is inside, outside,
    or centered.
    See {manhelpi linealignmentstyle G-4} for a list of alignment choices.

{phang}
{cmd:lstyle(}{it:linestyle}{cmd:)}
    specifies the overall style of the line used to outline the bar, 
    including its pattern (solid, dashed, etc.), thickness, color, and
    alignment.
    The four options listed above allow you to change the line's attributes,
    but {cmd:lstyle()} is the starting point.
    See {manhelpi linestyle G-4} for a list of choices.

{marker bstyle()}{...}
{phang}
{cmd:bstyle(}{it:areastyle}{cmd:)}
    specifies the look of the bar.  The options listed above allow you to
    change each attribute, but {cmd:bstyle()} provides a starting point.

{pmore}
    You need not specify {cmd:bstyle()} just because there is something you
    want to change.  You specify {cmd:bstyle()} when another style exists that
    is exactly what you desire or when another style would allow you to
    specify fewer changes to obtain what you want.

{pmore}
    See {manhelpi areastyle G-4} for a list of available area styles.

{phang}
{cmd:pstyle(}{it:pstyle}{cmd:)}
    specifies the overall style of the plot, including not only the
    {it:{help areastyle}}, but also all other settings for the look of the plot.
    Only the {it:areastyle} affects the look of areas.  See
    {manhelpi pstyle G-4} for a list of available plot styles.


{marker remarks}{...}
{title:Remarks}

{pstd}
The {it:barlook_options} are allowed inside {cmd:graph} {cmd:bar}'s
and {cmd:graph} {cmd:hbar}'s option
{cmd:bar(}{it:#} {it:barlook_options}{cmd:)}, as in

{phang2}
	{cmd:. graph bar} {it:yvar1} {it:yvar2}{cmd:, bar(1,color(green)) bar(2,color(red))}

{pstd}
The command above would set the bar associated with {it:yvar1} to be green and
the bar associated with {it:yvar2} to be red; see
{manhelp graph_bar G-2:graph bar}.

{pstd}
{it:barlook_options} are also allowed as options with {cmd:graph}
{cmd:twoway} {cmd:bar} and {cmd:graph} {cmd:twoway} {cmd:rbar}, as in

{phang2}
	{cmd:. graph twoway bar} {it:yvar} {it:xvar}{cmd:, color(green)}

{pstd}
The above would set all the bars (which are located at {it:xvar} and extend
to {it:yvar}) to be green; see {manhelp twoway_bar G-2:graph twoway bar} and 
{manhelp twoway_rbar G-2:graph twoway rbar}.

{pstd}
The {cmd:lcolor()}, {cmd:lwidth()}, {cmd:lpattern()}, {cmd:lalign()}, and
{cmd:lstyle()}
options are also used to specify how plotted lines and spikes look for all of
{cmd:graph} {cmd:twoway}'s 
{help graph twoway##rangeplots:range plots}, 
{help graph twoway##pcplots:paired-coordinate plots}, and for
{help graph twoway##barplots:area plots},
{help graph twoway##barplots:bar plots},
{help graph twoway##barplots:spike plots}, and
{help graph twoway##barplots:dropline plots}.
For example,

{phang2}
	{cmd:. graph twoway rspike} {it:y1var} {it:y2var} 
				    {it:xvar}{cmd:, lcolor(red)}

{pstd}
will set the color of the horizontal spikes between values of {it:y1var} and
{it:y2var} to red.
{p_end}
