{smcl}
{* *! version 1.1.12  19oct2017}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway qfitci" "mansection G-2 graphtwowayqfitci"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway fpfitci" "help twoway_fpfitci"}{...}
{vieweralsosee "[G-2] graph twoway lfitci" "help twoway_lfitci"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway qfit" "help twoway_qfit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{viewerjumpto "Syntax" "twoway_qfitci##syntax"}{...}
{viewerjumpto "Menu" "twoway_qfitci##menu"}{...}
{viewerjumpto "Description" "twoway_qfitci##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_qfitci##linkspdf"}{...}
{viewerjumpto "Options" "twoway_qfitci##options"}{...}
{viewerjumpto "Remarks" "twoway_qfitci##remarks"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[G-2] graph twoway qfitci} {hline 2}}Twoway quadratic prediction plots with CIs{p_end}
{p2col:}({mansection G-2 graphtwowayqfitci:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 24 2}
{cmdab:tw:oway}
{cmd:qfitci}
{it:yvar} {it:xvar}
{ifin}
[{it:{help twoway qfitci##weight:weight}}]
[{cmd:,}
{it:options}]

{synoptset 27}{...}
{p2col:{it:options}}Description{p_end}
{p2line}
{p2col:{cmd:stdp}}CIs from SE of prediction; the default{p_end}
{p2col:{cmd:stdf}}CIs from SE of forecast{p_end}
{p2col:{cmd:stdr}}CIs from SE of residual; seldom specified{p_end}
{p2col:{cmd:level(}{it:#}{cmd:)}}set confidence level; default is
       {cmd:level(95)}{p_end}

{p2col:{cmdab:r:ange:(}{it:#} {it:#}{cmd:)}}range over which predictions are
       calculated{p_end}
{p2col:{cmd:n(}{it:#}{cmd:)}}number of prediction points{p_end}
{p2col:{cmd:atobs}}calculate predictions at {it:xvar}{p_end}
{p2col:{cmdab:est:opts:(}{it:{help regress:regress_options}}{cmd:)}}options for
       {cmd:regress}{p_end}
{p2col:{cmdab:pred:opts:(}{it:{help regress postestimation##predict:predict_options}}{cmd:)}}options for
       {cmd:predict}{p_end}

{p2col:{cmd:nofit}}do not plot the prediction{p_end}
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
Options
{cmd:range()}, {cmd:estopts()}, {cmd:predopts()}, {cmd:n()}, and {cmd:level()}
are {it:rightmost}; {cmd:atobs}, {cmd:nofit}, {cmd:fitplot()}, {cmd:ciplot()},
{cmd:stdp}, {cmd:stdf}, and {cmd:stdr} are {it:unique}; see
{help repeated options}.{p_end}
{p 4 6 2}{it:yvar} and {it:xvar} may contain time-series operators; see
{help tsvarlist}.{p_end}
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
{cmd:twoway} {cmd:qfitci} calculates the prediction for {it:yvar} from a
regression of {it:yvar} on {it:xvar} and {it:xvar}^2 and plots the resulting
line along with a confidence interval.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowayqfitciQuickstart:Quick start}

        {mansection G-2 graphtwowayqfitciRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:stdp},
{cmd:stdf}, and
{cmd:stdr}
    determine the basis for the confidence interval.  {cmd:stdp} is the
    default.

{pmore}
    {cmd:stdp} specifies that the confidence interval be the confidence
    interval of the mean.

{pmore}
    {cmd:stdf} specifies that the confidence interval be the confidence
    interval for an individual forecast, which includes both the uncertainty
    of the mean prediction and the residual.

{pmore}
    {cmd:stdr} specifies that the confidence interval be based only on the
    standard error of the residual.

{phang}
{cmd:level(}{it:#}{cmd:)}
specifies the confidence level, as a percentage, for the confidence
    intervals. The default is {cmd:level(95)} or as set by {helpb set level}.

{phang}
{cmd:range(}{it:#} {it:#}{cmd:)}
    specifies the {it:x} range over which predictions are calculated.
    The default is {cmd:range(. .)}, meaning the minimum and maximum
    values of {it:xvar}.  {cmd:range(0 10)} would make the range 0
    to 10, {cmd:range(. 10)} would make the range the minimum to 10, and
    {cmd:range(0 .)} would make the range 0 to the maximum.

{phang}
{cmd:n(}{it:#}{cmd:)}
    specifies the number of points at which the predictions and the CI over
    {cmd:range()} are to be calculated.  The default is {cmd:n(100)}.

{phang}
{cmd:atobs}
is an alternative to {cmd:n()} and specifies that the predictions be
    calculated at the {it:xvar} values.  {cmd:atobs} is the default
    if {cmd:predopts()} is specified and any statistic other than the
    {cmd:xb} is requested.

{phang}
{cmd:estopts(}{it:regress_options}{cmd:)}
    specifies options to be passed along to {cmd:regress} to
    estimate the linear regression from which the curve will be predicted;
    see {manhelp regress R}.  If this option is specified, commonly specified
    is {cmd:estopts(nocons)}.

{phang}
{cmd:predopts(}{it:predict_options}{cmd:)}
    specifies options to be passed along to {cmd:predict} to
    obtain the predictions after estimation by {cmd:regress};
    see {manhelp regress_postestimation R:regress postestimation}.

{phang}
{cmd:nofit}
    prevents the prediction from being plotted.

{phang}
{cmd:fitplot(}{it:plottype}{cmd:)}, which is seldom used, specifies how the
prediction is to be plotted.  The default is {cmd:fitplot(line)}, meaning that
the prediction will be plotted by {cmd:graph} {cmd:twoway} {cmd:line}.  See
{manhelp graph_twoway G-2:graph twoway} for a list of {it:plottype} choices.
You may choose any that expect one {it:y} and one {it:x} variable.

{phang}
{cmd:ciplot(}{it:plottype}{cmd:)}
    specifies how the confidence interval is to be plotted.  The
    default is {cmd:ciplot(rarea)}, meaning that the prediction will be
    plotted by {cmd:graph} {cmd:twoway} {cmd:rarea}.

{pmore}
    A reasonable alternative is {cmd:ciplot(rline)}, which will
    substitute lines around the prediction for shading.
    See {manhelp graph_twoway G-2:graph twoway} for a list of {it:plottype}
    choices.  You may choose any that expect two {it:y} variables and one
    {it:x} variable.

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
     {manhelpi fitarea_options G-3}.  If you specify {cmd:ciplot()}, then rather
     than using {it:fitarea_options}, you should specify whatever is
     appropriate.

INCLUDE help gr_axlnkf

INCLUDE help gr_twoptf


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help twoway qfitci##remarks1:Typical use}
	{help twoway qfitci##remarks2:Advanced use}
	{help twoway qfitci##remarks3:Cautions}
	{help twoway qfitci##remarks4:Use with by()}


{marker remarks1}{...}
{title:Typical use}

{pstd}
{cmd:twoway} {cmd:qfitci} by default draws the confidence interval
of the predicted mean:

	{cmd:. sysuse auto}

	{cmd:. twoway qfitci mpg weight}
	  {it:({stata "gr_example auto: twoway qfitci mpg weight":click to run})}
{* graph gtqfitci1}{...}

{pstd}
If you specify the {cmd:ciplot(rline)} option, rather than shading the
confidence interval, it will be designated by lines:

	{cmd:. twoway qfitci mpg weight, ciplot(rline)}
	  {it:({stata "gr_example auto: twoway qfitci mpg weight, ciplot(rline)":click to run})}
{* graph gtqfitci2}{...}


{marker remarks2}{...}
{title:Advanced use}

{pstd}
{cmd:qfitci} can be overlaid with other plots:

	{cmd:. sysuse auto, clear}

	{cmd:. twoway qfitci mpg weight, stdf || scatter mpg weight}
	  {it:({stata "gr_example auto: twoway qfitci mpg weight, stdf || scatter mpg weight":click to run})}
{* graph gtqfitci3}{...}

{pstd}
In the above command, we specified {cmd:stdf} to obtain a
confidence interval based on the standard error of the forecast rather than
the standard error of the mean.  This is more useful for identifying outliers.

{pstd}
We typed

	{cmd:. twoway qfitci} ... {cmd:|| scatter} ...

{pstd}
and not

	{cmd:. twoway scatter} ... {cmd:|| qfitci} ...

{pstd}
Had we drawn the scatter diagram first, the confidence interval would
have covered up most of the points.


{marker remarks3}{...}
{title:Cautions}

{pstd}
Do not use {cmd:twoway} {cmd:qfitci} when specifying the
{it:axis_scale_options} {helpb axis_scale_options:yscale(log)} or
{helpb axis_scale_options:xscale(log)}
to create log scales.  Typing

	{cmd:. twoway qfitci mpg weight, stdf || scatter mpg weight ||, xscale(log)}
	  {it:({stata "gr_example auto:twoway qfitci mpg weight, stdf || scatter mpg weight ||, xscale(log)":click to run})}
{* graph gtqfitci4}{...}

{pstd}
The result may look pretty but, if you think about it, it is not what you
want.  The prediction line is not a parabola because the regression estimated
for the prediction was for {cmd:mpg} on {cmd:weight} and {cmd:weight^2}, not
{cmd:mpg} on {cmd:log(weight)} and {cmd:log(weight)^2}.


{marker remarks4}{...}
{title:Use with by()}

{pstd}
{cmd:qfitci} may be used with {cmd:by()} (as can all the {cmd:twoway} plot
commands):

	{cmd}. twoway qfitci  mpg weight, stdf ||
		 scatter mpg weight       ||
	  , by(foreign, total row(1)){txt}
	  {it:({stata "gr_example auto: twoway qfitci mpg weight, stdf || scatter mpg weight || , by(foreign, total row(1))":click to run})}
{* graph gtqfitci5}{...}
