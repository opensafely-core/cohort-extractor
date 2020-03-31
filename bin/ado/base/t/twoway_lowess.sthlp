{smcl}
{* *! version 1.1.10  19oct2017}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway lowess" "mansection G-2 graphtwowaylowess"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] lowess" "help lowess"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway mspline" "help twoway_mspline"}{...}
{viewerjumpto "Syntax" "twoway_lowess##syntax"}{...}
{viewerjumpto "Menu" "twoway_lowess##menu"}{...}
{viewerjumpto "Description" "twoway_lowess##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_lowess##linkspdf"}{...}
{viewerjumpto "Options" "twoway_lowess##options"}{...}
{viewerjumpto "Remarks" "twoway_lowess##remarks"}{...}
{viewerjumpto "Reference" "twoway_lowess##reference"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[G-2] graph twoway lowess} {hline 2}}Local linear smooth plots{p_end}
{p2col:}({mansection G-2 graphtwowaylowess:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 32 2}
{cmdab:tw:oway}
{cmd:lowess}
	{it:yvar}
	{it:xvar}
	{ifin}
	[{cmd:,}
	{it:options}]

{synoptset 22}{...}
{p2col:{it:options}}Description{p_end}
{p2line}
{p2col:{cmdab:bw:idth:(}{it:#}{cmd:)}}smoothing parameter{p_end}
{p2col:{cmdab:m:ean}}use running-mean smoothing{p_end}
{p2col:{cmdab:now:eight}}use unweighted smoothing{p_end}
{p2col:{cmdab:lo:git}}transform the smooth to logits{p_end}
{p2col:{cmdab:a:djust}}adjust smooth's mean to equal {it:yvar}'s mean{p_end}

INCLUDE help gr_clopt

INCLUDE help gr_axlnk

INCLUDE help gr_twopt
{p2line}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Twoway graph (scatter, line, etc.)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:graph} {cmd:twoway} {cmd:lowess} plots a lowess smooth of {it:yvar} on
{it:xvar} using {helpb graph twoway line}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowaylowessQuickstart:Quick start}

        {mansection G-2 graphtwowaylowessRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:bwidth}{cmd:(}{it:#}{cmd:)}
    specifies the bandwidth.  {cmd:bwidth(.8)} is the default.
    Centered subsets of {it:N}*{cmd:bwidth()} observations, {it:N} = number of
    observations, are used for calculating smoothed values for each point in
    the data except for endpoints, where smaller, uncentered subsets are
    used.  The greater the {cmd:bwidth()}, the greater the smoothing.

{phang}
{cmd:mean}
    specifies running-mean smoothing; the default is running-line
    least-squares smoothing.

{phang}
{cmd:noweight}
    prevents the use of Cleveland's
    ({help twoway lowess##C1979:1979}) tricube weighting function; the
    default is to use the weighting function.

{phang}
{cmd:logit}
    transforms the smoothed {it:yvar} into logits.

{phang}
{cmd:adjust}
    adjusts by multiplication the mean of the smoothed {it:yvar} to equal the
    mean of {it:yvar}.  This is useful when smoothing binary (0/1) data.

{phang}
{it:cline_options}
     specify how the lowess line is rendered and its appearance;
     see {manhelpi cline_options G-3}.

INCLUDE help gr_axlnkf

INCLUDE help gr_twoptf


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:graph} {cmd:twoway} {cmd:lowess} {it:yvar xvar} uses the {cmd:lowess}
command -- see {manhelp lowess R} -- to obtain a local linear smooth of
{it:yvar} on {it:xvar} and uses {cmd:graph} {cmd:twoway} {cmd:line} to plot
the result.

{pstd}
Remarks are presented under the following headings:

	{help twoway lowess##remarks1:Typical use}
	{help twoway lowess##remarks2:Use with by()}


{marker remarks1}{...}
{title:Typical use}

{pstd}
The local linear smooth is often graphed on top of the data, possibly
with other regression lines:

	{cmd:. sysuse auto}

	{cmd:. twoway scatter mpg weight, mcolor(*.6) ||}
	{cmd:         lfit    mpg weight    ||}
	{cmd:         lowess  mpg weight}
	  {it:({stata "gr_example auto: twoway scatter mpg weight, mcolor(*.6) || lfit mpg weight || lowess mpg weight":click to run})}
{* graph gtlowess1}{...}

{pstd}
Notice our use of {cmd:mcolor(*.6)} to dim the points and thus make the
lines stand out; see {manhelpi colorstyle G-4}.


{marker remarks2}{...}
{title:Use with by()}

{pstd}
{cmd:graph} {cmd:twoway} {cmd:lowess} may be used with {cmd:by()}:

	{cmd:. sysuse auto, clear}

	{cmd:. twoway scatter mpg weight, mcolor(*.6) ||}
	{cmd:         lfit    mpg weight ||}
	{cmd:         lowess  mpg weight ||, by(foreign)}
	  {it:({stata "gr_example auto: tw scatter mpg weight, mcolor(*.6) || lfit mpg weight || lowess mpg weight ||, by(foreign)":click to run})}
{* graph gtlowess2}{...}


{marker reference}{...}
{title:Reference}

{marker C1979}{...}
{phang}
Cleveland, W. S. 1979. Robust locally weighted regression and smoothing
scatterplots. {it:Journal of the American Statistical Association}
74: 829-836.
{p_end}
