{smcl}
{* *! version 1.1.11  19oct2017}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway fpfitci" "mansection G-2 graphtwowayfpfitci"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway lfitci" "help twoway_lfitci"}{...}
{vieweralsosee "[G-2] graph twoway qfitci" "help twoway_qfitci"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway fpfit" "help twoway_fpfit"}{...}
{viewerjumpto "Syntax" "twoway_fpfitci##syntax"}{...}
{viewerjumpto "Menu" "twoway_fpfitci##menu"}{...}
{viewerjumpto "Description" "twoway_fpfitci##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_fpfitci##linkspdf"}{...}
{viewerjumpto "Options" "twoway_fpfitci##options"}{...}
{viewerjumpto "Remarks" "twoway_fpfitci##remarks"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[G-2] graph twoway fpfitci} {hline 2}}Twoway fractional-polynomial prediction plots with CIs{p_end}
{p2col:}({mansection G-2 graphtwowayfpfitci:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 55 2}
{cmdab:tw:oway}
{cmd:fpfitci}
{it:yvar} {it:xvar}
{ifin}
[{it:{help twoway fpfitci##weight:weight}}]
[{cmd:,}
{it:options}]

{synoptset 20}{...}
{p2col:{it:options}}Description{p_end}
{p2line}
{p2col:{it:{help twoway_fpfit:fpfit_options}}}any of the option of
       {manhelp twoway_fpfit G-2:graph twoway fpfit}{p_end}
{p2col:{cmd:level(}{it:#}{cmd:)}}set confidence level; default is
       {cmd:level(95)}{p_end}
{p2col:{cmd:nofit}}prevent plotting the prediction{p_end}

{p2col:{cmdab:fitp:lot:(}{it:{help graph_twoway:plottype}}{cmd:)}}how to plot
       fit; default is {cmd:fitplot(line)}{p_end}
{p2col:{cmdab:cip:lot:(}{it:{help graph_twoway:plottype}}{cmd:)}}how to plot
       CIs; default is {cmd:ciplot(rarea)}{p_end}

{p2col:{it:{help fcline_options}}}change look of predicted line{p_end}
{p2col:{it:{help fitarea_options}}}change look of CI{p_end}

INCLUDE help gr_axlnk

INCLUDE help gr_twopt
{p2line}
{p2colreset}{...}
{p 4 6 2}
Option {cmd:level()} is {it:rightmost}; {cmd:nofit}, {cmd:fitplot()},
and {cmd:ciplot()} are {it:unique}; see {help repeated options}.{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:aweight}s,
{cmd:fweight}s, and
{cmd:pweight}s are allowed.  Weights, if specified, affect estimation but
not how the weighted results are plotted.  See {help weight}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Twoway graph (scatter, line, etc.)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:twoway} {cmd:fpfitci} calculates the prediction for {it:yvar} from 
estimation of a fractional polynomial of {it:xvar} and plots the resulting
curve along with the confidence interval of the mean.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowayfpfitciQuickstart:Quick start}

        {mansection G-2 graphtwowayfpfitciRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{it:fpfit_options}
    refers to any of the options of {cmd:graph} {cmd:twoway} {cmd:fpfit};
    see {manhelp twoway_fpfit G-2:graph twoway fpfit}.
    These options are seldom specified.

{phang}
{cmd:level(}{it:#}{cmd:)}
    specifies the confidence level, as a percentage, for the confidence
    intervals. The default is {cmd:level(95)} or as set by {helpb set level}.

{phang}
{cmd:nofit}
    prevents the prediction from being plotted.

{phang}
{cmd:fitplot(}{it:plottype}{cmd:)}
    is seldom specified.  It specifies how the prediction is to be plotted.
    The default is {cmd:fitplot(line)}, meaning that the prediction will be
    plotted by {cmd:graph} {cmd:twoway} {cmd:line}.  See
    {manhelp graph_twoway G-2:graph twoway}
    for a list of {it:plottype} choices.  You may choose any plottypes that
    expect one {it:y} variable and one {it:x} variable.

{phang}
{cmd:ciplot(}{it:plottype}{cmd:)}
    specifies how the confidence interval is to be plotted.  The
    default is {cmd:ciplot(rarea)}, meaning that the prediction will be
    plotted by {cmd:graph} {cmd:twoway} {cmd:rarea}.

{pmore}
    A reasonable alternative is {cmd:ciplot(rline)}, which will
    substitute lines around the prediction for shading.
    See {manhelp graph_twoway G-2:graph twoway} for a list of {it:plottype}
    choices.  You may choose any plottypes that expect two {it:y} variables
    and one {it:x} variable.

{phang}
{it:fcline_options}
     specify how the prediction line is rendered;
     see {manhelpi fcline_options G-3}.
     If you specify {cmd:fitplot()}, then rather than using {it:fcline_options},
     you should select options that affect the specified {it:plottype}
     from the options in {cmd:scatter};
     see {manhelp scatter G-2:graph twoway scatter}.

{phang}
{it:fitarea_options}
     specify how the confidence interval is rendered; see 
     {manhelpi fitarea_options G-3}.
     If you specify {cmd:ciplot()}, then rather than using {it:fitarea_options},
     you should specify whatever is appropriate.

INCLUDE help gr_axlnkf

INCLUDE help gr_twoptf


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help twoway fpfitci##remarks1:Typical use}
	{help twoway fpfitci##remarks2:Advanced use}
	{help twoway fpfitci##remarks3:Cautions}
	{help twoway fpfitci##remarks4:Use with by()}


{marker remarks1}{...}
{title:Typical use}

{pstd}
{cmd:twoway} {cmd:fpfitci} by default draws the confidence interval
of the predicted mean:

	{cmd:. sysuse auto}

	{cmd:. twoway fpfitci mpg weight}
	  {it:({stata "gr_example auto: twoway fpfitci mpg weight":click to run})}
{* graph gtfpfitci1}{...}

{pstd}
If you specify the {cmd:ciplot(rline)} option, the confidence interval will be
designated by lines rather than shading:

	{cmd:. twoway fpfitci mpg weight, ciplot(rline)}
	  {it:({stata "gr_example auto: twoway fpfitci mpg weight, ciplot(rline)":click to run})}
{* graph gtfpfitci2}{...}


{marker remarks2}{...}
{title:Advanced use}

{pstd}
{cmd:fpfitci} can be usefully overlaid with other plots:

	{cmd:. sysuse auto, clear}

	{cmd:. twoway fpfitci mpg weight || scatter mpg weight}
	  {it:({stata "gr_example auto: twoway fpfitci mpg weight || scatter mpg weight":click to run})}
{* graph gtfpfitci3}{...}

{pstd}
In the above graph, the shaded area corresponds to the 95%
confidence interval for the mean.

{pstd}
It is of great importance to note that we typed

	{cmd:. twoway fpfitci} ... {cmd:|| scatter} ...

{pstd}
and not

	{cmd:. twoway scatter} ... {cmd:|| fpfitci} ...

{pstd}
Had we drawn the scatter diagram first, the confidence interval would
have covered up most of the points.


{marker remarks3}{...}
{title:Cautions}

{pstd}
Do not use {cmd:twoway} {cmd:fpfitci} when specifying the
{it:axis_scale_options} {helpb axis_scale_options:yscale(log)} or
{helpb axis_scale_options:xscale(log)}
to create log scales.  Typing

{phang2}
	{cmd:. twoway fpfitci mpg weight || scatter mpg weight ||, xscale(log)}

{pstd}
will produce a curve that will be fit from a fractional polynomial
regression of mpg on weight rather than log(weight).

{pstd}
See {it:{help twoway lfitci##remarks3:Cautions}} in
{manhelp twoway_lfitci G-2:graph twoway lfitci}.


{marker remarks4}{...}
{title:Use with by()}

{pstd}
{cmd:fpfitci} may be used with {cmd:by()} (as can all the {cmd:twoway} plot
commands):

	{cmd}. twoway fpfitci  mpg weight  ||
		 scatter  mpg weight  ||
	  , by(foreign, total row(1)){txt}
	  {it:({stata "gr_example auto: twoway fpfitci mpg weight || scatter mpg weight || , by(foreign, total row(1))":click to run})}
{* graph gtfpfitci4}{...}
