{smcl}
{* *! version 1.1.10  15may2018}{...}
{vieweralsosee "[G-3] cline_options" "mansection G-3 cline_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] Concept: lines" "help lines"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] colorstyle" "help colorstyle"}{...}
{vieweralsosee "[G-4] connectstyle" "help connectstyle"}{...}
{vieweralsosee "[G-4] linealignmentstyle" "help linealignmentstyle"}{...}
{vieweralsosee "[G-4] linepatternstyle" "help linepatternstyle"}{...}
{vieweralsosee "[G-4] linestyle" "help linestyle"}{...}
{vieweralsosee "[G-4] linewidthstyle" "help linewidthstyle"}{...}
{viewerjumpto "Syntax" "cline_options##syntax"}{...}
{viewerjumpto "Description" "cline_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "cline_options##linkspdf"}{...}
{viewerjumpto "Options" "cline_options##options"}{...}
{viewerjumpto "Remarks" "cline_options##remarks"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[G-3]} {it:cline_options} {hline 2}}Options for connecting points with lines (subset of connect options){p_end}
{p2col:}({mansection G-3 cline_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 27}{...}
{p2col:{it:cline_options}}Description{p_end}
{p2line}
{p2col:{cmdab:c:onnect:(}{it:{help connectstyle}}{cmd:)}}how to connect points
     {p_end}

{p2col:{cmdab:lp:attern:(}{it:{help linepatternstyle}}{cmd:)}}line pattern
     (solid, dashed, etc.){p_end}
{p2col:{cmdab:lw:idth:(}{it:{help linewidthstyle}}{cmd:)}}thickness of line
     {p_end}
{p2col:{cmdab:lc:olor:(}{it:{help colorstyle}}{cmd:)}}color and opacity of line{p_end}
{p2col : {cmdab:la:lign:(}{it:{help linealignmentstyle}}{cmd:)}}line alignment (inside, outside, center){p_end}
{p2col:{cmdab:lsty:le:(}{it:{help linestyle}}{cmd:)}}overall style of line
     {p_end}

{p2col:{cmdab:psty:le:(}{it:{help pstyle}}{cmd:)}}overall plot style,
      including linestyle{p_end}

{p2col:{help advanced_options:{bf:recast(}{it:newplottype}{bf:)}}}advanced;
      treat plot as {it:newplottype}{p_end}
{p2line}
{p2colreset}{...}
{p 4 6 2}All options are {it:rightmost}; see {help repeated options}.{p_end}
{p 4 6 2}Some plots do not allow {cmd:recast()}.{p_end}


{marker description}{...}
{title:Description}

{pstd}
The {it:cline_options} specify how points on a graph are
to be connected.

{pstd}
In certain contexts (for example, {manhelp scatter G-2:graph twoway scatter}),
the {cmd:lpattern()}, {cmd:lwidth()}, {cmd:lcolor()}, {cmd:lalign()}, and
{cmd:lstyle()} options may be specified with a list of elements, with the
first element applying to the first variable, the second element to the second
variable, and so on.  For information on specifying lists, see
{manhelpi stylelists G-4}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 cline_optionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt connect(connectstyle)} specifies whether points are to be connected and,
if so, how the line connecting them is to be shaped; see
{manhelpi connectstyle G-4}.  The line between each
pair of points can connect them directly or in stairstep fashion.

{phang}
{cmd:lpattern(}{it:linepatternstyle}{cmd:)},
{cmd:lwidth(}{it:linewidthstyle}{cmd:)},
{cmd:lcolor(}{it:colorstyle}{cmd:)},
{cmd:lalign(}{it:linealignmentstyle}{cmd:)},
and
{cmd:lstyle(}{it:linestyle}{cmd:)}
    determine the look of the line used to connect the points; see 
    {help lines}.  Note the {cmd:lpattern()} option, which
    allows you to specify whether the line is solid, dashed, etc.;
    see {manhelpi linepatternstyle G-4} for a list of line-pattern choices.

{phang}
{cmd:pstyle(}{it:pstyle}{cmd:)}
    specifies the overall style of the plot, including not only the
    {it:{help linestyle}}, but also all other settings for the look of the plot.
    Only the {it:linestyle} affects the look of line plots.  See
    {manhelpi pstyle G-4} for a list of available plot styles.

{phang}
{cmd:recast(}{it:newplottype}{cmd:)}
        is an advanced option allowing the plot to be recast from one type to
        another, for example, from a {help twoway line:line plot} to a
        {help twoway scatter:scatterplot}; see
        {manhelpi advanced_options G-3}.  Most, but not all, plots allow
        {cmd:recast()}.


{marker remarks}{...}
{title:Remarks}

{pstd}
An important option among all the above is {cmd:connect()}, which  determines
whether and how the points are connected.  The points need not be connected at
all ({cmd:connect(i)}), which is {cmd:scatter}'s default.  Or the points might
be connected by straight lines ({cmd:connect(l)}), which is {cmd:line}'s
default (and is available in {cmd:scatter}).  {cmd:connect(i)} and
{cmd:connect(l)} are commonly specified, but there are other possibilities
such as {cmd:connect(J)}, which connects in stairstep fashion and is
appropriate for empirical distributions.  See {manhelpi connectstyle G-4}
for a full list of your choices.

{pstd}
The remaining connect options specify how the line is to look:  Is it solid or
dashed?  Is it red or green?  How thick is it?  Option
{cmd:lpattern()} can be of great importance, especially when printing to a
monochrome printer.  For a general discussion of lines (which occur in
many contexts other than connecting points), see {help lines}.
{p_end}
