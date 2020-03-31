{smcl}
{* *! version 1.2.2  19oct2017}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway kdensity" "mansection G-2 graphtwowaykdensity"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] kdensity" "help kdensity"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway histogram" "help twoway_histogram"}{...}
{viewerjumpto "Syntax" "twoway_kdensity##syntax"}{...}
{viewerjumpto "Menu" "twoway_kdensity##menu"}{...}
{viewerjumpto "Description" "twoway_kdensity##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_kdensity##linkspdf"}{...}
{viewerjumpto "Options" "twoway_kdensity##options"}{...}
{viewerjumpto "Remarks" "twoway_kdensity##remarks"}{...}
{p2colset 1 32 34 2}{...}
{p2col:{bf:[G-2] graph twoway kdensity} {hline 2}}Kernel density plots{p_end}
{p2col:}({mansection G-2 graphtwowaykdensity:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 32 2}
{cmdab:tw:oway}
{cmd:kdensity}
	{varname}
	{ifin}
        [{it:{help twoway kdensity##weight:weight}}]
	[{cmd:,}
	{it:options}]

{synoptset 25}{...}
{p2col:{it:options}}Description{p_end}
{p2line}
{p2col:{cmdab:bw:idth:(}{it:#}{cmd:)}}smoothing parameter{p_end}
{synopt: {opth k:ernel(twoway_kdensity##kernel:kernel)}}specify kernel
         function; default is {cmd:kernel(epanechnikov)}{p_end}

{p2col:{cmdab:ra:nge:(}{it:#} {it:#}{cmd:)}}range for plot, minimum and
        maximum{p_end}
{p2col:{opth ra:nge(varname)}}range for plot obtained from {it:varname}{p_end}
{p2col:{cmd:n(}{it:#}{cmd:)}}number of points to evaluate{p_end}
{p2col:{cmd:area(}{it:#}{cmd:)}}rescaling parameter{p_end}
{p2col:{cmdab:hor:izontal}}graph horizontally{p_end}
{p2col:{cmd:boundary}}estimate density one {cmd:bwidth()} beyond maximum and
minimum; not allowed with {cmd:range()}{p_end}

INCLUDE help gr_clopt

INCLUDE help gr_axlnk

INCLUDE help gr_twopt
{p2line}

{marker kernel}{...}
{synopt :{it:kernel}}Description{p_end}
{p2line}
{synopt :{opt ep:anechnikov}}Epanechnikov kernel function; the default{p_end}
{synopt :{opt epan2}}alternative Epanechnikov kernel function{p_end}
{synopt :{opt bi:weight}}biweight kernel function{p_end}
{synopt :{opt cos:ine}}cosine trace kernel function{p_end}
{synopt :{opt gau:ssian}}Gaussian kernel function{p_end}
{synopt :{opt par:zen}}Parzen kernel function{p_end}
{synopt :{opt rec:tangle}}rectangle kernel function{p_end}
{synopt :{opt tri:angle}}triangle kernel function{p_end}
{p2line}
{p2colreset}{...}

{marker weight}{...}
{phang}
{cmd:fweight}s and {cmd:aweight}s are allowed; see {help weight}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Twoway graph (scatter, line, etc.)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:graph} {cmd:twoway} {cmd:kdensity} plots a kernel density estimate for
{varname} using {helpb graph twoway line}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowaykdensityQuickstart:Quick start}

        {mansection G-2 graphtwowaykdensityRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:bwidth(}{it:#}{cmd:)}
and
{cmd:kernel(}{it:kernel}{cmd:)}
    specify how the kernel density estimate is to be obtained and are in fact
    the same options as those specified with the command {cmd:kdensity}; see 
    {manhelp kdensity R}.

{pmore}
    {cmd:bwidth(}{it:#}{cmd:)}
    specifies the smoothing parameter.

{pmore}
    {cmd:kernel(}{it:kernel}{cmd:)}
    specify the kernel-weight function to be used.  The 
    default is {cmd:kernel(epanechnikov)}.

{pmore}
    See {manhelp kdensity R} for more information about these options.

{pmore}
    All the other {cmd:graph} {cmd:twoway} {cmd:kdensity} options modify how
    the result is displayed, not how it is obtained.

{phang}
{cmd:range(}{it:#} {it:#}{cmd:)}
and
{opth range(varname)}
    specify the range of values at which the kernel density estimates are
    to be plotted.  The default is {bind:{cmd:range(}{it:m} {it:M}{cmd:)}},
    where {it:m} and {it:M} are the minimum and maximum of the {it:varname}
    specified on the {cmd:graph} {cmd:twoway} {cmd:kdensity} command.

{pmore}
    {cmd:range(}{it:#} {it:#}{cmd:)}
    specifies a pair of numbers to be used as the minimum and maximum.

{pmore}
    {cmd:range(}{it:varname}{cmd:)}
    specifies another variable for which its minimum and maximum are to be
    used.

{phang}
{cmd:n(}{it:#}{cmd:)}
    specifies the number of points at which the estimate is evaluated.  The
    default is {cmd:n(300)}.

{phang}
{cmd:area(}{it:#}{cmd:)}
    specifies a multiplier by which the density estimates are adjusted before
    being plotted.  The default is {cmd:area(1)}.  {cmd:area()} is useful when
    overlaying a density estimate on top of a histogram that is itself not
    scaled as a density.  For instance, if you wished to scale the density
    estimate as a frequency, {cmd:area()} would be specified as the total
    number of nonmissing observations.

{phang}
{cmd:horizontal}
    specifies that the result be plotted horizontally (that is, reflected
    along the identity line).

{phang}
{cmd:boundary}
    specifies that the result be estimated for one {cmd:bwidth()}
    beyond the maximum and minimum value of {varname}.  
    {cmd:boundary} cannot be specified with {cmd:range()}.  

{phang}
{it:cline_options}
     specify how the density line is rendered and its appearance;
     see {manhelpi cline_options G-3}.

INCLUDE help gr_axlnkf

INCLUDE help gr_twoptf


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:graph} {cmd:twoway} {cmd:kdensity} {it:varname} uses the {cmd:kdensity}
command to obtain an estimate of the density of {it:varname} and uses
{cmd:graph} {cmd:twoway} {cmd:line} to plot the result.

{pstd}
Remarks are presented under the following headings:

	{help twoway kdensity##remarks1:Typical use}
	{help twoway kdensity##remarks2:Use with by()}


{marker remarks1}{...}
{title:Typical use}

{pstd}
The density estimate is often graphed on top of the histogram:

	{cmd:. sysuse lifeexp}

	{cmd:. twoway histogram lexp, color(*.5) || kdensity lexp}
	  {it:({stata "gr_example lifeexp: tw histogram lexp, color(*.5) || kdensity lexp":click to run})}
{* graph gtkden1}{...}

{* fill areas, dimming and brightening}{...}
{* index colors, dimming and brightening}{...}
{* index color() tt option}{...}
{* index color intensity adjustment}{...}
{* index intensity, color, adjustment}{...}
{pstd}
Notice the use of {cmd:graph} {cmd:twoway} {cmd:histogram}'s
{cmd:color(*.5)} option to dim the bars and make the line stand out;
see {manhelpi colorstyle G-4}.

{pstd}
Notice also the {it:y} and {it:x} axis titles:  "Density/kdensity lexp" and
"Life expectancy at birth/x".  The "kdensity lexp" and "x" were contributed by
the {cmd:twoway} {cmd:kdensity}.  When you overlay graphs, you nearly always
need to respecify the axis titles using the {it:axis_title_options}
{cmd:ytitle()} and {cmd:xtitle()}; see {manhelpi axis_title_options G-3}.


{marker remarks2}{...}
{title:Use with by()}

{pstd}
{cmd:graph} {cmd:twoway} {cmd:kdensity} may be used with {cmd:by()}:

	{cmd:. sysuse lifeexp, clear}

{phang2}
	{cmd:. twoway histogram lexp, color(*.5) || kdensity lexp ||, by(region)}
{p_end}
	  {it:({stata "gr_example lifeexp: tw histogram lexp, color(*.5) || kdensity lexp ||, by(region)":click to run})}
{* graph gtkden2}{...}
