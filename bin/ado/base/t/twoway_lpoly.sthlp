{smcl}
{* *! version 1.1.11  19oct2017}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway lpoly" "mansection G-2 graphtwowaylpoly"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] lpoly" "help lpoly"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway lpolyci" "help twoway_lpolyci"}{...}
{viewerjumpto "Syntax" "twoway_lpoly##syntax"}{...}
{viewerjumpto "Menu" "twoway_lpoly##menu"}{...}
{viewerjumpto "Description" "twoway_lpoly##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_lpoly##linkspdf"}{...}
{viewerjumpto "Options" "twoway_lpoly##options"}{...}
{viewerjumpto "Remarks" "twoway_lpoly##remarks"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[G-2] graph twoway lpoly} {hline 2}}Local polynomial smooth plots{p_end}
{p2col:}({mansection G-2 graphtwowaylpoly:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmdab: tw:oway}{cmd: lpoly} 
	{it:yvar} 
	{it:xvar} {ifin}
        [{it:{help twoway lpoly##weight:weight}}]
	[{cmd:,} {it:options}]

{synoptset 20}{...}
{synopt:{it:options}}Description{p_end}
{p2line}
{synopt: {opth k:ernel(twoway_lpoly##kernel:kernel)}}kernel function;
             default is {cmd:kernel(epanechnikov)}{p_end}
{synopt :{opt bw:idth(#)}}kernel bandwidth{p_end}
{synopt :{opt deg:ree(#)}}degree of the polynomial smooth; default is
             {cmd:degree(0)}{p_end}
{synopt :{opt n(#)}}obtain the smooth at {it:#} points; default is
                {bind:min(N, 50)}{p_end}

INCLUDE help gr_clopt

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
{cmd:graph} {cmd:twoway} {cmd:lpoly} plots a local polynomial smooth of
{it:yvar} on {it:xvar}. 


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowaylpolyQuickstart:Quick start}

        {mansection G-2 graphtwowaylpolyRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opth "kernel(twoway_lpoly##kernel:kernel)"} specifies the kernel function
for use in calculating the weighted local polynomial estimate.  The default
is {cmd:kernel(epanechnikov)}. See {manhelp kdensity R} for more information
on this option.

{phang}
{opt bwidth(#)} specifies the half-width of the
kernel, the width of the smoothing window around each point.  If {opt bwidth()}
is not specified, a rule-of-thumb bandwidth estimator is
calculated and used; see {manhelp lpoly R}. 

{phang}
{opt degree(#)} specifies the degree of the polynomial to be used in
the smoothing. The default is {cmd:degree(0)}, meaning local mean smoothing.

{phang}
{opt n(#)} specifies the number of points at which the smooth is to be
calculated.  The default is min(N,50), where N is the number of observations.

{phang}
{it:cline_options} specify how the line is rendered and its
appearance; see {manhelpi cline_options G-3}.

INCLUDE help gr_axlnkf

INCLUDE help gr_twoptf


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:graph} {cmd:twoway} {cmd:lpoly} {it:yvar xvar} uses the {cmd:lpoly}
command -- see {manhelp lpoly R} -- to obtain a local polynomial
smooth of {it:yvar} on {it:xvar} and uses {cmd:graph} {cmd:twoway} {cmd:line}
to plot the result.

{pstd}
Remarks are presented under the following headings:

        {help twoway lpoly##remarks1:Typical use}
        {help twoway lpoly##remarks2:Use with by()}


{marker remarks1}{...}
{title:Typical use}

{pstd}
The local polynomial smooth is often graphed on top of the data, possibly
with other smoothers or regression lines:

        {cmd:. sysuse auto}

        {cmd:. twoway scatter weight length, mcolor(*.6) || }
        {cmd:         lpoly weight length	         || }
        {cmd:         lowess weight length}
          {it:({stata "gr_example auto: twoway scatter weight length, mcolor(*.6) || lpoly weight length || lowess weight length":click to run})} 
{* graph gtlpoly1}{...}

{pstd}
We used {cmd:mcolor(*.6)} to dim the points and thus make the
lines stand out; see {manhelpi colorstyle G-4}.


{marker remarks2}{...}
{title:Use with by()}

{pstd}
{cmd:graph} {cmd:twoway} {cmd:lpoly} may be used with {cmd:by()}:

        {cmd:. sysuse auto, clear}

        {cmd:. twoway scatter weight length, mcolor(*.6) ||}
        {cmd:         lpoly weight length,		 ||}
        {cmd:    , by(foreign)}
          {it:({stata "gr_example auto: tw scatter weight length, mcolor(*.6) || lpoly weight length ||, by(foreign)":click to run})}
{* graph gtlpoly2}{...}
