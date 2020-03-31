{smcl}
{* *! version 1.1.10  19oct2017}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway lpolyci" "mansection G-2 graphtwowaylpolyci"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] lpoly" "help lpoly"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway lpoly" "help twoway_lpoly"}{...}
{viewerjumpto "Syntax" "twoway_lpolyci##syntax"}{...}
{viewerjumpto "Menu" "twoway_lpolyci##menu"}{...}
{viewerjumpto "Description" "twoway_lpolyci##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_lpolyci##linkspdf"}{...}
{viewerjumpto "Options" "twoway_lpolyci##options"}{...}
{viewerjumpto "Remarks" "twoway_lpolyci##remarks"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[G-2] graph twoway lpolyci} {hline 2}}Local polynomial smooth plots with CIs{p_end}
{p2col:}({mansection G-2 graphtwowaylpolyci:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmdab: tw:oway}{cmd: lpolyci} 
	{it:yvar} 
	{it:xvar} {ifin}
        [{it:{help twoway lpolyci##weight:weight}}]
	[{cmd:,} 
 	{it:options}]

{synoptset 20}{...}
{synopt: {it:options}}Description{p_end}
{p2line}
{synopt: {opth k:ernel(twoway_lpolyci##kernel:kernel)}}kernel function;
                default is {cmd:kernel(epanechnikov)}{p_end}
{synopt :{opt bw:idth(#)}}kernel bandwidth{p_end}
{synopt :{opt deg:ree(#)}}degree of the polynomial smooth; default is
              {cmd:degree(0)}{p_end}
{synopt :{opt n(#)}}obtain the smooth at {it:#} points; default is
              {bind:min(N, 50)}{p_end}

{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt pw:idth(#)}}pilot bandwidth for standard error calculation{p_end}
{synopt :{opt v:ar(#)}}estimate of the constant conditional variance{p_end}

{synopt :{opt nofit}}do not plot the smooth{p_end}
{synopt :{opth fitp:lot(graph_twoway:plottype)}}how to plot the smooth; default
                              is {cmd:fitplot(line)}{p_end}
{synopt :{opth cip:lot(graph_twoway:plottype)}}how to plot CIs; default is
                              {cmd:ciplot(rarea)}{p_end}

{synopt :{it:{help fcline_options}}}change look of the smoothed line{p_end}
{synopt :{it:{help fitarea_options}}}change look of CI{p_end}


INCLUDE help gr_axlnk

INCLUDE help gr_twopt
{p2line}

{synoptset 20}{...}
{synopt :{it:kernel}}Description{p_end}
{p2line}
{marker kernel}{...}
{synopt :{opt epa:nechnikov}}Epanechnikov kernel function; the default{p_end}
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
{p 4 6 2}
{cmd:fweight}s and {cmd:aweight}s are allowed; see {help weight}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Twoway graph (scatter, line, etc.)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:graph} {cmd:twoway} {cmd:lpolyci} plots a local polynomial smooth of
{it:yvar} on {it:xvar} by using {helpb graph twoway line}, along
with a confidence interval by using {helpb graph twoway rarea}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowaylpolyciQuickstart:Quick start}

        {mansection G-2 graphtwowaylpolyciRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opth "kernel(twoway_lpolyci##kernel:kernel)"} specifies the kernel function
for use in calculating the weighted local polynomial estimate.  The default
is {cmd:kernel(epanechnikov)}.  See {manhelp kdensity R} for more information
on this option.

{phang}
{opt bwidth(#)} specifies the half-width of the
kernel, the width of the smoothing window around each point.  If
{opt bwidth()} is not specified, a rule-of-thumb bandwidth estimator is
calculated and used; see {manlink R lpoly}.

{phang}
{opt degree(#)} specifies the degree of the polynomial to be used in
the smoothing.  The default is {cmd:degree(0)}, meaning local mean smoothing.

{phang}
{opt n(#)} specifies the number of points at which the smooth is to be
evaluated.  The default is min(N,50), where N is the number of observations.

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for confidence
intervals.  The default is {cmd:level(95)} or as set by {helpb set level}.

{phang}
{opt pwidth(#)} specifies the pilot bandwidth to be used for standard error
computations.  The default is chosen to be 1.5 times the value of the
rule-of-thumb bandwidth selector.

{phang}
{opt var(#)} specifies an estimate of a constant conditional
variance required for standard error computation.  By
default, the conditional variance at each smoothing point is estimated by the
normalized weighted residual sum of squares obtained from locally fitting a
polynomial of order p+2, where p is the degree specified in {opt degree()}.

{phang}
{opt nofit} prevents the smooth from being plotted.

{phang}
{opt fitplot(plottype)} specifies how the
prediction is to be plotted.  The default is {cmd:fitplot(line)}, meaning
that the smooth will be plotted by {opt graph} {opt twoway} {opt line}.
See {manhelp twoway G-2:graph twoway} for a list of {it:plottype} choices.  You
may choose any that expects one {it:y} and one {it:x} variable.
{cmd:fitplot()} is seldom used.

{phang}
{opt ciplot(plottype)} specifies how the confidence interval is to be
plotted.  The default is {cmd:ciplot(rarea)}, meaning that the confidence
bounds will be plotted by {opt graph} {opt twoway} {opt rarea}.

{pmore}
A reasonable alternative is {cmd:ciplot(rline)}, which will substitute
lines around the smooth for shading.  See {manhelp twoway G-2:graph twoway} for
a list of {it:plottype} choices.  You may choose any that expects two {it:y}
variables and one {it:x} variable.

{phang}
{it:fcline_options} specify how the {cmd:lpoly} line is rendered and its
appearance; see {manhelpi fcline_options G-3}.

{phang}
{it:fitarea_options} specify how the confidence interval is rendered; see
{manhelpi fitarea_options G-3}.  If you specify {opt ciplot()}, 
you should specify whatever is appropriate instead of using
{it:fitarea_options}.

INCLUDE help gr_axlnkf

INCLUDE help gr_twoptf


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:graph} {cmd:twoway} {cmd:lpolyci} {it:yvar xvar} uses the {cmd:lpoly}
command -- see {manhelp lpoly R} -- to obtain a local polynomial
smooth of {it:yvar} on {it:xvar} and confidence intervals and uses {cmd:graph}
{cmd:twoway} {cmd:line} and {cmd:graph} {cmd:twoway} {cmd:rarea} to plot
results.

{pstd}
Remarks are presented under the following headings:

        {help twoway lpolyci##remarks1:Typical use}
        {help twoway lpolyci##remarks2:Use with by()}


{marker remarks1}{...}
{title:Typical use}

{pstd}
{cmd: graph} {cmd: twoway} {cmd: lpolyci} can be used to overlay the
confidence bands obtained from different local polynomial smooths.  For
example, for local mean and local cubic polynomial smooths:

        {cmd:. sysuse auto}

        {cmd:. twoway lpolyci weight length, nofit                    ||}
        {cmd:         lpolyci weight length, degree(3) nofit}
	{cmd:                               ciplot(rline) pstyle(ci2) ||}
	{cmd:         scatter weight length, msymbol(o)}
          {it:({stata "gr_example auto: twoway lpolyci weight length, nofit || lpolyci weight length, degree(3) ciplot(rline) pstyle(ci2) nofit || scatter weight length, msymbol(o)":click to run})} 
{phang}
{* graph gtlpolyci1}{...}

{pstd}
The plotted area corresponds to the confidence bands for the local
mean smooth and lines correspond to confidence intervals for the local cubic
smooth.

{pstd}
When you overlay graphs, you nearly always need to respecify the axis titles
by using the {it:axis_title_options} {cmd:ytitle()} and {cmd:xtitle()}; see
{manhelpi axis_title_options G-3}.


{marker remarks2}{...}
{title:Use with by()}

{pstd}
{cmd:graph} {cmd:twoway} {cmd:lpolyci} may be used with {cmd:by()}:

        {cmd:. sysuse auto, clear}
        {cmd:. twoway lpolyci weight length             ||}
	{cmd:	      scatter weight length, msymbol(o) ||}
        {cmd:    , by(foreign)}
          {it:({stata "gr_example auto: tw lpolyci weight length || scatter weight length, msymbol(o) ||, by(foreign)":click to run})}
{* graph gtlpolyci2}{...}
