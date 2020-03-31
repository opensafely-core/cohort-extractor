{smcl}
{* *! version 1.0.15  16apr2019}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway mband" "mansection G-2 graphtwowaymband"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway fpfit" "help twoway_fpfit"}{...}
{vieweralsosee "[G-2] graph twoway lfit" "help twoway_lfit"}{...}
{vieweralsosee "[G-2] graph twoway line" "help line"}{...}
{vieweralsosee "[G-2] graph twoway mspline" "help twoway_mspline"}{...}
{vieweralsosee "[G-2] graph twoway qfit" "help twoway_qfit"}{...}
{viewerjumpto "Syntax" "twoway_mband##syntax"}{...}
{viewerjumpto "Menu" "twoway_mband##menu"}{...}
{viewerjumpto "Description" "twoway_mband##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_mband##linkspdf"}{...}
{viewerjumpto "Options" "twoway_mband##options"}{...}
{viewerjumpto "Remarks" "twoway_mband##remarks"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[G-2] graph twoway mband} {hline 2}}Twoway median-band plots{p_end}
{p2col:}({mansection G-2 graphtwowaymband:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 54 2}
{cmdab:tw:oway}
{cmd:mband}
{it:yvar}
{it:xvar}
{ifin}
[{cmd:,}
{it:options}]

{synoptset 20}{...}
{synopt:{it:options}}Description{p_end}
{p2line}
{synopt:{cmdab:b:ands:(}{it:#}{cmd:)}}number of bands{p_end}

INCLUDE help gr_clopt

INCLUDE help gr_axlnk

INCLUDE help gr_twopt
{p2line}
{p 4 6 2}
All options are {it:rightmost}; see {help repeated options}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Twoway graph (scatter, line, etc.)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:twoway} {cmd:mband} calculates
cross medians and then graphs the cross medians as a line plot.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowaymbandQuickstart:Quick start}

        {mansection G-2 graphtwowaymbandRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:bands(}{it:#}{cmd:)}
    specifies the number of bands on which the calculation is to be based.
    The default is max(10, round(10*log10(N))), where N is the number of
    observations.

{pmore}
    In a median-band plot, the {it:x} axis is divided into {it:#}
    equal-width intervals and then the median of {it:y} and the
    median of {it:x} are calculated in each interval.
    It is these cross medians that {cmd:mband} graphs as a line plot.

{phang}
{it:cline_options}
     specify how the median-band line is rendered and its appearance;
     see {manhelpi cline_options G-3}.

INCLUDE help gr_axlnkf

INCLUDE help gr_twoptf


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help twoway mband##remarks1:Typical use}
	{help twoway mband##remarks2:Use with by()}


{marker remarks1}{...}
{title:Typical use}

{pstd}
Median bands provide a convenient but crude way to show the tendency in the
relationship between {it:y} and {it:x}:

	{cmd:. sysuse auto}

	{cmd:. scatter mpg weight, msize(*.5) || mband mpg weight}
	  {it:({stata "gr_example auto: scatter mpg weight, msize(*.5) || mband mpg weight":click to run})}
{* graph gtmband1}{...}

{pstd}
The important part of the above is "{cmd:mband} {cmd:mpg} {cmd:weight}".
On the {cmd:scatter}, we specified {cmd:msize(*.5)} to make the marker
symbols half their normal size; see {manhelpi size G-4}.


{marker remarks2}{...}
{title:Use with by()}

{pstd}
{cmd:mband} may be used with {cmd:by()} (as can all the {cmd:twoway} plot
commands):

	{cmd:. scatter mpg weight, ms(oh) ||}
	{cmd:  mband mpg weight ||, by(foreign, total row(1))}
	  {it:({stata "gr_example auto: scatter mpg weight, ms(oh) || mband mpg weight ||, by(foreign, total row(1))":click to run})}
{* graph gtmband2}{...}

{pstd}
In the above graph, we specified {cmd:ms(oh)} so as to use hollow symbols;
see {manhelpi symbolstyle G-4}.
{p_end}
