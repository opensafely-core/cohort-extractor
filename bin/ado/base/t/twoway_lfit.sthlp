{smcl}
{* *! version 1.1.10  19oct2017}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway lfit" "mansection G-2 graphtwowaylfit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway fpfit" "help twoway_fpfit"}{...}
{vieweralsosee "[G-2] graph twoway line" "help line"}{...}
{vieweralsosee "[G-2] graph twoway mband" "help twoway_mband"}{...}
{vieweralsosee "[G-2] graph twoway mspline" "help twoway_mspline"}{...}
{vieweralsosee "[G-2] graph twoway qfit" "help twoway_qfit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway lfitci" "help twoway_lfitci"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{viewerjumpto "Syntax" "twoway_lfit##syntax"}{...}
{viewerjumpto "Menu" "twoway_lfit##menu"}{...}
{viewerjumpto "Description" "twoway_lfit##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_lfit##linkspdf"}{...}
{viewerjumpto "Options" "twoway_lfit##options"}{...}
{viewerjumpto "Remarks" "twoway_lfit##remarks"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[G-2] graph twoway lfit} {hline 2}}Twoway linear prediction plots{p_end}
{p2col:}({mansection G-2 graphtwowaylfit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 60 2}
{cmdab:tw:oway}
{cmd:lfit}
{it:yvar} {it:xvar}
{ifin}
[{it:{help twoway lfit##weight:weight}}]
[{cmd:,}
{it:options}]

{synoptset 26}{...}
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
{cmd:twoway} {cmd:lfit} calculates the prediction for {it:yvar} from a
linear regression of {it:yvar} on {it:xvar} and plots the resulting line.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowaylfitQuickstart:Quick start}

        {mansection G-2 graphtwowaylfitRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:range(}{it:#} {it:#}{cmd:)}
    specifies the {it:x} range over which predictions are to be calculated.
    The default is {cmd:range(. .)}, meaning the minimum and maximum
    values of {it:xvar}.  {cmd:range(0 10)} would make the range 0
    to 10, {cmd:range(. 10)} would make the range the minimum to 10, and
    {cmd:range(0 .)} would make the range 0 to the maximum.

{phang}
{cmd:n(}{it:#}{cmd:)}
    specifies the number of points at which predictions over
    {cmd:range()} are to be calculated.  The default is {cmd:n(3)}.

{phang}
{cmd:atobs}
is an alternative to {cmd:n()}.  It specifies that the predictions be
    calculated at the {it:xvar} values.  {cmd:atobs} is the default
    if {cmd:predopts()} is specified and any statistic other than the
    {cmd:xb} is requested.

{phang}
{cmd:estopts(}{it:regress_options}{cmd:)}
    specifies options to be passed along to {cmd:regress} to
    estimate the linear regression from which the line will be predicted;
    see {manhelp regress R}.  If this option is specified,
    {cmd:estopts(nocons)} is also often specified.

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

	{help twoway lfit##remarks1:Typical use}
	{help twoway lfit##remarks2:Cautions}
	{help twoway lfit##remarks3:Use with by()}


{marker remarks1}{...}
{title:Typical use}

{pstd}
{cmd:twoway} {cmd:lfit} is nearly always used in conjunction with
other {cmd:twoway} plottypes, such as

	{cmd:. sysuse auto}

	{cmd:. scatter mpg weight || lfit mpg weight}
	  {it:({stata "gr_example auto: scatter mpg weight || lfit mpg weight":click to run})}
{* graph gtlfit1}{...}

{pstd}
Results are visually the same as typing

	{cmd}. regress mpg weight
	. predict fitted
	. scatter mpg weight || line fitted weight{txt}


{marker remarks2}{...}
{title:Cautions}

{pstd}
Do not use {cmd:twoway} {cmd:lfit} when specifying the
{it:axis_scale_options} {helpb axis_scale_options:yscale(log)} or
{helpb axis_scale_options:xscale(log)}
to create log scales.  Typing

	{cmd:. scatter mpg weight, xscale(log) || lfit mpg weight}
	  {it:({stata "gr_example auto: scatter mpg weight, xscale(log) || lfit mpg weight":click to run})}
{* graph gtlfit2}{...}

{pstd}
The line is not straight because the regression estimated for the prediction
was for {cmd:mpg} on {cmd:weight}, not {cmd:mpg} on {cmd:log(weight)}.  (The
default for {cmd:n()} is 3 so that, if you make this mistake, you will spot
it.)


{marker remarks3}{...}
{title:Use with by()}

{pstd}
{cmd:lfit} may be used with {cmd:by()} (as can all the {cmd:twoway} plot
commands):

{phang2}
	{cmd:. scatter mpg weight || lfit mpg weight ||, by(foreign, total row(1))}
{p_end}
	  {it:({stata "gr_example auto: scatter mpg weight || lfit mpg weight ||, by(foreign, total row(1))":click to run})}
{* graph gtlfit3}{...}
