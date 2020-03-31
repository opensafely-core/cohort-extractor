{smcl}
{* *! version 1.1.13  27feb2019}{...}
{viewerdialog kdensity "dialog kdensity"}{...}
{vieweralsosee "[R] kdensity" "mansection R kdensity"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] histogram" "help histogram"}{...}
{vieweralsosee "[R] npregress kernel" "help npregress kernel"}{...}
{vieweralsosee "[R] npregress series" "help npregress series"}{...}
{viewerjumpto "Syntax" "kdensity##syntax"}{...}
{viewerjumpto "Menu" "kdensity##menu"}{...}
{viewerjumpto "Description" "kdensity##description"}{...}
{viewerjumpto "Links to PDF documentation" "kdensity##linkspdf"}{...}
{viewerjumpto "Options" "kdensity##options"}{...}
{viewerjumpto "Examples" "kdensity##examples"}{...}
{viewerjumpto "Stored results" "kdensity##results"}{...}
{viewerjumpto "Reference" "kdensity##reference"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[R] kdensity} {hline 2}}Univariate kernel density estimation{p_end}
{p2col:}({mansection R kdensity:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:kdensity} {varname} {ifin}
[{it:{help kdensity##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 29 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{synopt: {opth k:ernel(kdensity##kernel:kernel)}}specify kernel function;
            default is {cmd:kernel(epanechnikov)}{p_end}
{synopt :{opt bw:idth(#)}}half-width of kernel{p_end}
{synopt :{opth g:enerate(newvar:newvar_x newvar_d)}}store the estimation points in {it:newvar_x} and the density estimate in {it:newvar_d}{p_end}
{synopt :{opt n(#)}}estimate density using {it:#} points; default is min(N, 50){p_end}
{synopt :{opt at(var_x)}}estimate density using the values specified by {it:var_x}{p_end}
{synopt :{opt nogr:aph}}suppress graph{p_end}

{syntab :Kernel plot}
{synopt :{it:{help cline_options}}}affect rendition of the plotted kernel density estimate{p_end}

{syntab :Density plots}
{synopt :{opt nor:mal}}add normal density to the graph{p_end}
{synopt :{opth normop:ts(cline_options)}}affect rendition of normal density{p_end}
{synopt :{opt stu:dent(#)}}add Student's t density with {it:#} degrees of freedom to the graph{p_end}
{synopt :{opth stop:ts(cline_options)}}affect rendition of the Student's t density{p_end}

{syntab :Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated graph{p_end}

{syntab :Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {opt by()} documented in 
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
{pstd}
{cmd:fweight}s, {cmd:aweight}s, and {cmd:iweight}s are allowed; see
{help weight}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Nonparametric analysis > Kernel density estimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:kdensity} produces kernel density estimates and graphs the result.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R kdensityQuickstart:Quick start}

        {mansection R kdensityRemarksandexamples:Remarks and examples}

        {mansection R kdensityMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth "kernel(kdensity##kernel:kernel)"} specifies the kernel function for use
in calculating the kernel density estimate.  The default kernel is
the Epanechnikov kernel ({opt epanechnikov}).

{phang}
{opt bwidth(#)} specifies the half-width of the kernel, the width of the
density window around each point.  If {opt bwidth()} is not specified, the
"optimal" width is calculated and used; see {bind:{bf:[R] kdensity}}.  The
optimal width is the width that would minimize the mean integrated squared
error if the data were Gaussian and a Gaussian kernel were used, so it is not
optimal in any global sense.  In fact, for multimodal and highly skewed
densities, this width is usually too wide and oversmooths the
density ({help kdensity##S1986:Silverman 1986}).

{phang}
{opth "generate(newvar:newvar_x newvar_d)"} stores the results of the
estimation.  {it:newvar_x} will contain the points at which the density is
estimated.  {it:newvar_d} will contain the density estimate.

{phang}
{opt n(#)} specifies the number of points at which the density estimate is to
be evaluated.  The default is min(N,50), where N is the number of
observations in memory.

{phang}
{opt at(var_x)} specifies a variable that contains the values at which the
density should be estimated.  This option allows you to more easily obtain
density estimates for different variables or different subsamples of a
variable and then overlay the estimated densities for comparison.

{phang}
{opt nograph} suppresses the graph.  This option is often used 
with the {opt generate()} option.

{dlgtab:Kernel plot}

{phang}
{it:cline_options} affect the rendition of the plotted kernel density
estimate. See {manhelpi cline_options G-3}.

{dlgtab:Density plots}

{phang}
{opt normal} requests that a normal density be overlaid on the density
estimate for comparison.

{phang}
{opt normopts(cline_options)} specifies details about the rendition
of the normal curve, such as the color and style of line used. See
{manhelpi cline_options G-3}.

{phang}
{opt student(#)} specifies that a Student's t density with {it:#} degrees
of freedom be overlaid on the density estimate for comparison.

{phang}
{opt stopts(cline_options)} affects the rendition of the Student's t density.
See {manhelpi cline_options G-3}.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the generated graph.
See {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include options for
titling the graph (see {manhelpi title_options G-3}) and for saving the
graph to disk (see {manhelpi saving_option G-3}).


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Graph kernel density estimates for {cmd:length}{p_end}
{phang2}{cmd:. kdensity length}{p_end}

{pstd}Same as above, but use 20 for the half-width of the kernel{p_end}
{phang2}{cmd:. kdensity length, bw(20)}{p_end}

{pstd}Obtain kernel density estimates for {cmd:weight} using the Parzen kernel
function, store these results in {cmd:x2}, and suppress the graph{p_end}
{phang2}{cmd:. kdensity weight, kernel(parzen) gen(x2 parzen) nograph}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:kdensity} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(bwidth)}}kernel bandwidth{p_end}
{synopt:{cmd:r(n)}}number of points at which the estimate was evaluated{p_end}
{synopt:{cmd:r(scale)}}density bin width{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(kernel)}}name of kernel{p_end}
{p2colreset}{...}


{marker reference}{...}
{title:Reference}

{marker S1986}{...}
{phang}
Silverman, B. W. 1986.
{it:Density Estimation for Statistics and Data Analysis}.
London: Chapman & Hall.
{p_end}
