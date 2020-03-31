{smcl}
{* *! version 1.1.10  19oct2017}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway qfit" "mansection G-2 graphtwowayqfit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway fpfit" "help twoway_fpfit"}{...}
{vieweralsosee "[G-2] graph twoway lfit" "help twoway_lfit"}{...}
{vieweralsosee "[G-2] graph twoway line" "help line"}{...}
{vieweralsosee "[G-2] graph twoway mband" "help twoway_mband"}{...}
{vieweralsosee "[G-2] graph twoway mspline" "help twoway_mspline"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway qfitci" "help twoway_qfitci"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{viewerjumpto "Syntax" "twoway_qfit##syntax"}{...}
{viewerjumpto "Menu" "twoway_qfit##menu"}{...}
{viewerjumpto "Description" "twoway_qfit##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_qfit##linkspdf"}{...}
{viewerjumpto "Options" "twoway_qfit##options"}{...}
{viewerjumpto "Remarks" "twoway_qfit##remarks"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[G-2] graph twoway qfit} {hline 2}}Twoway quadratic prediction plots{p_end}
{p2col:}({mansection G-2 graphtwowayqfit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 60 2}
{cmdab:tw:oway}
{cmd:qfit}
{it:yvar} {it:xvar}
{ifin}
[{it:{help twoway qfit##weight:weight}}]
[{cmd:,}
{it:options}]

{synoptset 27}{...}
{p2col:{it:options}}Description{p_end}
{p2line}
{p2col:{cmdab:r:ange:(}{it:#} {it:#}{cmd:)}}range over which predictions
       calculated{p_end}
{p2col:{cmd:n(}{it:#}{cmd:)}}number of prediction points{p_end}
{p2col:{cmd:atobs}}calculate predictions at {it:xvar}{p_end}
{p2col:{cmdab:est:opts:(}{it:{help regress:regress_options}}{cmd:)}}options for
       {cmd:regress}{p_end}
{p2col:{cmdab:pred:opts:(}{it:{help regress postestimation##predict:predict_options}}{cmd:)}}options for
       {cmd:predict}{p_end}

{p2col:{it:{help cline_options}}}change look of predicted line{p_end}

INCLUDE help gr_axlnk

INCLUDE help gr_twopt
{p2line}
{p2colreset}{...}
{p 4 6 2}
All options are {it:rightmost}; see {help repeated options}.{p_end}
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
{cmd:twoway} {cmd:qfit} calculates the prediction for {it:yvar} from a
linear regression of {it:yvar} on {it:xvar} and {it:xvar}^2 and plots the
resulting curve.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowayqfitQuickstart:Quick start}

        {mansection G-2 graphtwowayqfitRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:range(}{it:#} {it:#}{cmd:)}
    specifies the {it:x} range over which predictions are calculated.
    The default is {cmd:range(. .)}, meaning the minimum and maximum
    values of {it:xvar}.  {cmd:range(0 10)} would make the range 0
    to 10, {cmd:range(. 10)} would make the range the minimum to 10, and
    {cmd:range(0 .)} would make the range 0 to the maximum.

{phang}
{cmd:n(}{it:#}{cmd:)}
    specifies the number of points at which predictions over
    {cmd:range()} are to be calculated.  The default is {cmd:n(100)}.

{phang}
{cmd:atobs}
    is an alternative to {cmd:n()}.  It specifies that the predictions be
    calculated at the {it:xvar} values.  {cmd:atobs} is the default
    if {cmd:predopts()} is specified and any statistic other than
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
{it:cline_options}
     specify how the prediction line is rendered;
     see {manhelpi cline_options G-3}.

INCLUDE help gr_axlnkf

INCLUDE help gr_twoptf


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help twoway qfit##remarks1:Typical use}
	{help twoway qfit##remarks2:Cautions}
	{help twoway qfit##remarks3:Use with by()}


{marker remarks1}{...}
{title:Typical use}

{pstd}
{cmd:twoway} {cmd:qfit} is nearly always used in conjunction with
other {cmd:twoway} plottypes, such as

	{cmd:. sysuse auto}

	{cmd:. scatter mpg weight || qfit mpg weight}
	  {it:({stata "gr_example auto: scatter mpg weight || qfit mpg weight":click to run})}
{* graph gtqfit1}{...}

{pstd}
Results are visually the same as typing

	{cmd:. generate} {it:tempvar} {cmd:= weight^2}
	{cmd:. regress mpg weight} {it:tempvar}
	{cmd:. predict fitted}
	{cmd:. scatter mpg weight || line fitted weight}


{marker remarks2}{...}
{title:Cautions}

{pstd}
Do not use {cmd:twoway} {cmd:qfit} when specifying the
{it:axis_scale_options} {helpb axis_scale_options:yscale(log)} or
{helpb axis_scale_options:xscale(log)}
to create log scales.  Typing

	{cmd:. scatter mpg weight, xscale(log) || qfit mpg weight}

{pstd}
produces something that is not a parabola because
the regression estimated for the prediction
was for {cmd:mpg} on {cmd:weight} and {cmd:weight^2}, not {cmd:mpg} on
{cmd:log(weight)} and {cmd:log(weight)^2}.


{marker remarks3}{...}
{title:Use with by()}

{pstd}
{cmd:qfit} may be used with {cmd:by()} (as can all the {cmd:twoway} plot
commands):

{phang2}
	{cmd:. scatter mpg weight || qfit mpg weight ||, by(foreign, total row(1))}
{p_end}
	  {it:({stata "gr_example auto: scatter mpg weight || qfit mpg weight ||, by(foreign, total row(1))":click to run})}
{* graph gtqfit2}{...}
