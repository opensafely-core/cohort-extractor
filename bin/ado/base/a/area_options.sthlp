{smcl}
{* *! version 1.1.7  19oct2017}{...}
{vieweralsosee "[G-3] area_options" "mansection G-3 area_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph dot" "help graph_dot"}{...}
{viewerjumpto "Syntax" "area_options##syntax"}{...}
{viewerjumpto "Description" "area_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "area_options##linkspdf"}{...}
{viewerjumpto "Options" "area_options##options"}{...}
{viewerjumpto "Remarks" "area_options##remarks"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[G-3]} {it:area_options} {hline 2}}Options for specifying the look
of special areas{p_end}
{p2col:}({mansection G-3 area_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 27}{...}
{p2col : {it:area_options}}Description{p_end}
{p2line}
{p2col : {cmdab:col:or:(}{it:{help colorstyle}}{cmd:)}}outline and fill color
	and opacity{p_end}
{p2col : {cmdab:fc:olor:(}{it:{help colorstyle}}{cmd:)}}fill color and
	opacity{p_end}
{p2col : {cmdab:fi:ntensity:(}{it:{help intensitystyle}}{cmd:)}}fill intensity
        {p_end}

{p2col : {cmdab:lc:olor:(}{it:{help colorstyle}}{cmd:)}}outline color and
	opacity{p_end}
{p2col : {cmdab:lw:idth:(}{it:{help linewidthstyle}}{cmd:)}}thickness of
         outline{p_end}
{p2col : {cmdab:lp:attern:(}{it:{help linepatternstyle}}{cmd:)}}outline
         pattern (solid, dashed, etc.){p_end}
{p2col : {cmdab:la:lign:(}{it:{help linealignmentstyle}}{cmd:)}}
        outline alignment (inside, outside, center){p_end}
{p2col : {cmdab:lsty:le:(}{it:{help linestyle}}{cmd:)}}overall look of
         outline{p_end}

{p2col : {cmdab:asty:le:(}{it:{help areastyle}}{cmd:)}}overall look of area,
         all settings above{p_end}
{p2col : {cmdab:psty:le:(}{it:{help pstyle}}{cmd:)}}overall plot style,
         including areastyle{p_end}

{p2col : {help advanced_options:{bf:recast(}{it:newplottype}{bf:)}}}advanced;
          treat plot as {it:newplottype}{p_end}
{p2line}
{p2colreset}{...}
{p 4 6 2}
All options are {it:merged-implicit}; see
{help repeated options}.


{marker description}{...}
{title:Description}

{pstd}
The {it:area_options} determine the look of, for instance, the areas created
by {helpb twoway area} or the "rectangles" used by {helpb graph dot}.  The
{it:area_options} and the {it:{help barlook_options}} are synonymous when used
on {helpb graph twoway} and may be used interchangeably.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 area_optionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:color(}{it:colorstyle}{cmd:)}
    specifies one color and opacity to be used both to outline the shape of the
    area and to fill its interior.
    See {manhelpi colorstyle G-4} for a list of color choices.

{phang}
{cmd:fcolor(}{it:colorstyle}{cmd:)}
    specifies the color and opacity to be used to fill the interior of the area.
    See {manhelpi colorstyle G-4} for a list of color choices.

{phang}
{cmd:fintensity(}{it:intensitystyle}{cmd:)}
    specifies the intensity of the color used to fill the interior of the area.
    See {manhelpi intensitystyle G-4} for a list of intensity choices.

{phang}
{cmd:lcolor(}{it:colorstyle}{cmd:)}
    specifies the color and opacity to be used to outline the area.
    See {manhelpi colorstyle G-4} for a list of color choices.

{phang}
{cmd:lwidth(}{it:linewidthstyle}{cmd:)}
    specifies the thickness of the line to be used to outline the area.
    See {manhelpi linewidthstyle G-4} for a list of choices.

{phang}
{cmd:lpattern(}{it:linepatternstyle}{cmd:)}
    specifies whether the line used to outline the area is solid, dashed,
    etc.
    See {manhelpi linepatternstyle G-4} for a list of pattern choices.

{phang}
{cmd:lalign(}{it:linealignmentstyle}{cmd:)}
    specifies whether the line used to outline the area is inside, outside,
    or centered.
    See {manhelpi linealignmentstyle G-4} for a list of alignment choices.

{phang}
{cmd:lstyle(}{it:linestyle}{cmd:)}
    specifies the overall style of the line used to outline the area, 
    including its pattern (solid, dashed, etc.), thickness, color, and
    alignment.
    The four options listed above allow you to change the line's attributes,
    but {cmd:lstyle()} is the starting point.
    See {manhelpi linestyle G-4} for a list of choices.

{phang}
{cmd:astyle(}{it:areastyle}{cmd:)}
    specifies the overall look of the area.  The options listed above allow
    you to change each attribute, but {cmd:astyle()} provides a starting
    point.

{pmore}
    You need not specify {cmd:astyle()} just because there is something you
    want to change.  You specify {cmd:astyle()} when another style exists that
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

{phang}
{cmd:recast(}{it:newplottype}{cmd:)}
        is an advanced option allowing the plot to be recast from one type to
        another, for example, from an {help twoway area:area plot} to
        a {help twoway line:line plot}; see 
        {manhelpi advanced_options G-3}.  Most, but not all, plots allow
        {cmd:recast()}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help area_options##remarks1:Use with twoway}
	{help area_options##remarks2:Use with graph dot}


{marker remarks1}{...}
{title:Use with twoway}

{pstd}
{it:area_options} are allowed as options with any {helpb graph twoway} plottype
that creates shaded areas, for example, {cmd:graph} {cmd:twoway} {cmd:area} and
{cmd:graph} {cmd:twoway} {cmd:rarea}, as in

{phang2}
	{cmd:. graph twoway area} {it:yvar} {it:xvar}{cmd:, color(blue)}

{pstd}
The above would set the area enclosed by {it:yvar} and the {it:x} axis to be
blue; see {manhelp twoway_area G-2:graph twoway area} and
{manhelp twoway_rarea G-2:graph twoway rarea}.

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


{marker remarks2}{...}
{title:Use with graph dot}

{pstd}
If you specify {cmd:graph} {cmd:dot}'s {cmd:linetype(rectangle)} option,
the dot chart will be drawn with rectangles substituted for the dots.
Then the {it:area_options} determine the look of the
rectangle.  The {it:area_options} are specified inside {cmd:graph} {cmd:dot}'s
{cmd:rectangles()} option:

{phang2}
	{cmd:. graph dot} ...{cmd:,} ... {cmd:linetype(rectangle) rectangles(}{it:area_options}{cmd:)} ...

{pstd}
If, for instance, you wanted to make the rectangles green, you could
specify

{phang2}
	{cmd:. graph dot} ...{cmd:,} ... {cmd:linetype(rectangle) rectangles(fcolor(green))} ...

{pstd}
See {manhelp graph_dot G-2:graph dot}.
{p_end}
