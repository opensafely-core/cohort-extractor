{smcl}
{* *! version 1.1.15  27feb2019}{...}
{viewerdialog lpoly "dialog lpoly"}{...}
{vieweralsosee "[R] lpoly" "mansection R lpoly"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway lpoly" "help twoway lpoly"}{...}
{vieweralsosee "[G-2] graph twoway lpolyci" "help twoway lpolyci"}{...}
{vieweralsosee "[R] kdensity" "help kdensity"}{...}
{vieweralsosee "[R] lowess" "help lowess"}{...}
{vieweralsosee "[R] npregress kernel" "help npregress kernel"}{...}
{vieweralsosee "[R] npregress series" "help npregress series"}{...}
{vieweralsosee "[R] smooth" "help smooth"}{...}
{viewerjumpto "Syntax" "lpoly##syntax"}{...}
{viewerjumpto "Menu" "lpoly##menu"}{...}
{viewerjumpto "Description" "lpoly##description"}{...}
{viewerjumpto "Links to PDF documentation" "lpoly##linkspdf"}{...}
{viewerjumpto "Options" "lpoly##options"}{...}
{viewerjumpto "Examples" "lpoly##examples"}{...}
{viewerjumpto "Stored results" "lpoly##results"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[R] lpoly} {hline 2}}Kernel-weighted local polynomial smoothing{p_end}
{p2col:}({mansection R lpoly:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:lpoly} {it:yvar} {it:xvar} {ifin}
[{it:{help lpoly##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 31 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{synopt: {opth k:ernel(lpoly##kernel:kernel)}}specify kernel function;
default is {cmd:kernel(epanechnikov)}{p_end}
{synopt :{opt bw:idth}({it:#}|{it:{help varname:varname}})}specify kernel
              bandwidth{p_end}
{synopt :{opt deg:ree(#)}}specify degree of the polynomial smooth; default is {cmd:degree(0)}{p_end}
{synopt :{cmdab:gen:erate(}[{it:{help newvar:newvar_x}}] {it:{help newvar:newvar_s}})}store smoothing grid 
	in {it:newvar_x} and smoothed points in {it:newvar_s}{p_end}
{synopt :{opt n(#)}}obtain the smooth at {it:#} points; default is
	min(N,50){p_end}
{synopt :{opt at}({it:{help varname:varname}})}obtain the smooth at the values specified by {it:varname}{p_end}
{synopt :{opt nogr:aph}}suppress graph{p_end}
{synopt :{opt nosc:atter}}suppress scatterplot only{p_end}

{syntab :SE/CI}
{synopt :{opt ci}}plot confidence bands{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt: {opt se}({it:{help newvar:newvar}})}store standard errors in {it:newvar}{p_end}
{synopt :{opt pw:idth(#)}}specify pilot bandwidth for standard error calculation{p_end}
{synopt :{opt v:ar}({it:#}|{it:{help varname:varname}})}specify estimates of residual variance{p_end}

{syntab :Scatterplot}
INCLUDE help gr_markopt2

{syntab :Smoothed line}
{synopt :{opth lineop:ts(cline_options)}}affect rendition of the smoothed line{p_end}

{syntab :CI plot}
{synopt :{opth ciop:ts(cline_options)}}affect rendition of the confidence bands{p_end}

{syntab :Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated graph{p_end}

{syntab :Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {cmd:by()} documented in
      {manhelpi twoway_options G-3}{p_end}
{synoptline}

{synoptset 29}{...}
{marker kernel}{...}
{synopthdr :kernel}
{synoptline}
{synopt :{opt ep:anechnikov}}Epanechnikov kernel function; the default{p_end}
{synopt :{opt epan2}}alternative Epanechnikov kernel function{p_end}
{synopt :{opt bi:weight}}biweight kernel function{p_end}
{synopt :{opt cos:ine}}cosine trace kernel function{p_end}
{synopt :{opt gau:ssian}}Gaussian kernel function{p_end}
{synopt :{opt par:zen}}Parzen kernel function{p_end}
{synopt :{opt rec:tangle}}rectangle kernel function{p_end}
{synopt :{opt tri:angle}}triangle kernel function{p_end}
{synoptline}
{p2colreset}{...}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s and {cmd:aweight}s are allowed; see {help weight}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Nonparametric analysis > Local polynomial smoothing}


{marker description}{...}
{title:Description}

{pstd}
{cmd:lpoly} performs a kernel-weighted local polynomial regression of
{it:yvar} on {it:xvar} and displays a graph of the smoothed
values with (optional) confidence bands.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R lpolyQuickstart:Quick start}

        {mansection R lpolyRemarksandexamples:Remarks and examples}

        {mansection R lpolyMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth "kernel(lpoly##kernel:kernel)"} specifies the kernel function for use
in calculating the weighted local polynomial estimate.  The default is
{cmd:kernel(epanechnikov)}.

{phang}
{opt bwidth}({it:#}|{it:{help varname:varname}}) specifies the half-width of the
kernel -- the width of the smoothing window around each point.  If
{opt bwidth()} is not specified, a rule-of-thumb (ROT) bandwidth estimator is
calculated and used.  A local variable bandwidth may be specified in
{it:varname}, in conjunction with an explicit smoothing grid using the
{opt at()} option.

{phang}
{opt degree(#)} specifies the degree of the polynomial to be used in
the smoothing.  The default is {cmd:degree(0)}, meaning local-mean smoothing.

{phang}
{cmd:generate(}[{it:{help newvar:newvar_x}}] {it:newvar_s}{cmd:)} stores
the smoothing grid in {it: newvar_x} and the smoothed values in
{it: newvar_s}.  If {opt at()} is not specified, then both {it: newvar_x} and
{it: newvar_s} must be specified.  Otherwise, only {it: newvar_s} is to be
specified.

{phang}
{opt n(#)} specifies the number of points at which the smooth is to be
calculated.  The default is min(N,50), where N is the number of observations.

{phang}
{opt at}({it:{help varname:varname}}) specifies a variable that contains the
values at which the smooth should be calculated.  By default, the smoothing is
done on an equally spaced grid, but you can use {opt at()} to instead perform
the smoothing at the observed {it: x}'s, for example.  This option also allows
you to more easily obtain smooths for different variables or different
subsamples of a variable and then overlay the estimates for comparison. 

{phang}
{opt nograph} suppresses drawing the graph of the estimated smooth.  This
option is often used with the {opt generate()} option.

{phang}
{opt noscatter} suppresses superimposing a scatterplot of the observed data
over the smooth.  This option is useful when the number of resulting points
would be so large as to clutter the graph.

{dlgtab:SE/CI}

{phang}
{opt ci} plots confidence bands, using the confidence level specified in
{opt level()}.

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for confidence
intervals.  The default is {cmd:level(95)} or as set by {helpb set level}.

{phang}
{opt se}({it:{help newvar:newvar}}) stores the estimates of the standard errors
in {it: newvar}.  This option requires specifying {opt generate()}
or {opt at()}.

{phang}
{opt pwidth(#)} specifies the pilot bandwidth to be used for standard-error
computations.  The default is chosen to be 1.5 times the value of the
ROT bandwidth selector. If you specify {cmd:pwidth()} without
specifying {cmd:se()} or {cmd:ci}, then the {cmd:ci} option is assumed. 

{phang}
{opt var}({it:#}|{it:{help varname:varname}}) specifies an estimate of a
constant residual variance or a variable containing estimates of the
residual variances at each grid point required for standard-error
computation.  By default, the residual variance at each smoothing point is
estimated by the normalized weighted residual sum of squares obtained from
locally fitting a polynomial of order p+2, where p is the degree specified in
{opt degree()}.  {opt var(varname)} is allowed only if {cmd:at()} is
specified.  If you specify {cmd:var()} without specifying {cmd:se()} or
{cmd:ci}, then the {cmd:ci} option is assumed.

{dlgtab:Scatterplot}

INCLUDE help gr_markoptf

{dlgtab:Smoothed line}

{phang}
{opt lineopts(cline_options)} affects the rendition of the smoothed
line; see {manhelpi cline_options G-3}.

{dlgtab:CI plot}

{phang}
{opt ciopts(cline_options)} affects the rendition of the confidence bands;
see {manhelpi cline_options G-3}.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the generated graph;
see {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in
{manhelpi twoway_options G-3}, excluding {opt by()}.
These include options for titling the
graph (see {manhelpi title_options G-3}) and for saving the graph to disk
(see {manhelpi saving_option G-3}).


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse motorcycle}{p_end}

{pstd}Local mean smoothing{p_end}
{phang2}{cmd:. lpoly accel time}{p_end}

{pstd}Local cubic polynomial smoothing{p_end}
{phang2}{cmd:. lpoly accel time, degree(3) kernel(epan2)}{p_end}

{pstd}Same as above, but save smoothed values and standard errors as variables
instead of graphing{p_end}
{phang2}{cmd:. lpoly accel time, degree(3) kernel(epan2) generate(x s) se(se) nograph}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:lpoly} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(degree)}}smoothing polynomial degree{p_end}
{synopt:{cmd:r(ngrid)}}number of successful regressions{p_end}
{synopt:{cmd:r(N)}}sample size{p_end}
{synopt:{cmd:r(bwidth)}}bandwidth of the smooth{p_end}
{synopt:{cmd:r(pwidth)}}pilot bandwidth{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(kernel)}}name of kernel{p_end}
{p2colreset}{...}
