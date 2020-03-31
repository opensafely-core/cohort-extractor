{smcl}
{* *! version 1.1.9  16apr2019}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway mspline" "mansection G-2 graphtwowaymspline"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] mkspline" "help mkspline"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway fpfit" "help twoway_fpfit"}{...}
{vieweralsosee "[G-2] graph twoway lfit" "help twoway_lfit"}{...}
{vieweralsosee "[G-2] graph twoway line" "help line"}{...}
{vieweralsosee "[G-2] graph twoway mband" "help twoway_mband"}{...}
{vieweralsosee "[G-2] graph twoway qfit" "help twoway_qfit"}{...}
{viewerjumpto "Syntax" "twoway_mspline##syntax"}{...}
{viewerjumpto "Menu" "twoway_mspline##menu"}{...}
{viewerjumpto "Description" "twoway_mspline##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_mspline##linkspdf"}{...}
{viewerjumpto "Options" "twoway_mspline##options"}{...}
{viewerjumpto "Remarks" "twoway_mspline##remarks"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[G-2] graph twoway mspline} {hline 2}}Twoway median-spline plots{p_end}
{p2col:}({mansection G-2 graphtwowaymspline:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 56 2}
{cmdab:tw:oway}
{cmd:mspline}
{it:yvar}
{it:xvar}
{ifin}
[{cmd:,}
{it:options}]

{synoptset 20}{...}
{p2col:{it:options}}Description{p_end}
{p2line}
{p2col:{cmdab:b:ands:(}{it:#}{cmd:)}}number of cross-median knots{p_end}
{p2col:{cmd:n(}{it:#}{cmd:)}}number of points between knots{p_end}

INCLUDE help gr_clopt

INCLUDE help gr_axlnk

INCLUDE help gr_twopt
{p2line}
{p2colreset}{...}
{p 4 6 2}
All options are {it:rightmost}; see {help repeated options}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Twoway graph (scatter, line, etc.)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:twoway} {cmd:mspline} calculates
cross medians and then uses the cross medians as knots to fit a cubic
spline.  The resulting spline is graphed as a line plot.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowaymsplineQuickstart:Quick start}

        {mansection G-2 graphtwowaymsplineRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:bands(}{it:#}{cmd:)}
    specifies the number of bands for which cross medians should be
    calculated.  The default is max{min(b1,b2),b3}, where
    b1 is round{10*log10(N)}, b2 is round{sqrt(N)},
    b3 is min(2,N), and N is the number of observations.

{pmore}
    The {it:x} axis is divided into {it:#} equal-width intervals and then the
    median of {it:y} and the median of {it:x} are calculated in each interval.
    It is these cross medians to which a cubic spline is then fit.

{phang}
{cmd:n(}{it:#}{cmd:)}
    specifies the number of points between the knots for which the
    cubic spline should be evaluated.  {cmd:n(10)} is the default.
    {cmd:n()} does not affect the result that is calculated, but it does
    affect how smooth the result appears.

{phang}
{it:cline_options}
     specify how the median-spline line is rendered and its appearance;
     see {manhelpi cline_options G-3}.

INCLUDE help gr_axlnkf

INCLUDE help gr_twoptf


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help twoway mspline##remarks1:Typical use}
	{help twoway mspline##remarks2:Cautions}
	{help twoway mspline##remarks3:Use with by()}


{marker remarks1}{...}
{title:Typical use}

{pstd}
Median splines provide a convenient way to show the relationship
between {it:y} and {it:x}:

	{cmd:. sysuse auto}

	{cmd:. scatter mpg weight, msize(*.5) || mspline mpg weight}
	  {it:({stata "gr_example auto: scatter mpg weight, msize(*.5) || mspline mpg weight":click to run})}
{* graph gtmspline1}{...}

{pstd}
The important part of the above command is {cmd:mspline} {cmd:mpg}
{cmd:weight}.  On the {cmd:scatter}, we specified {cmd:msize(*.5)} to make
the marker symbols half their normal size; see {manhelpi size G-4}.


{marker remarks2}{...}
{title:Cautions}

{pstd}
The graph shown above illustrates a common problem with this technique:
it tracks wiggles that may not be real and can introduce
wiggles if too many bands are chosen.  An improved version of the
graph above would be

{phang2}
	{cmd:. scatter mpg weight, msize(*.5) || mspline mpg weight, bands(8)}
{p_end}
	  {it:({stata "gr_example auto: scatter mpg weight, msize(*.5) || mspline mpg weight, bands(8)":click to run})}
{* graph gtmspline2}{...}


{marker remarks3}{...}
{title:Use with by()}

{pstd}
{cmd:mspline} may be used with {cmd:by()} (as can all the {cmd:twoway} plot
commands):

	{cmd:. scatter mpg weight, msize(*.5) ||}
	  {cmd:mspline mpg weight, bands(8)   ||, by(foreign, total row(1))}
	  {it:({stata "gr_example auto: scatter mpg weight, msize(*.5) || mspline mpg weight, bands(8) ||, by(foreign, total row(1))":click to run})}
{* graph gtmspline3}{...}
