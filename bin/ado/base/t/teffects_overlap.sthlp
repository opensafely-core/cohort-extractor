{smcl}
{* *! version 1.1.17  19oct2017}{...}
{viewerdialog "teffects overlap" "dialog teffects_overlap"}{...}
{vieweralsosee "[TE] teffects overlap" "mansection TE teffectsoverlap"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] stteffects" "help stteffects"}{...}
{vieweralsosee "[TE] stteffects ipw" "help stteffects ipw"}{...}
{vieweralsosee "[TE] stteffects ipwra" "help stteffects ipwra"}{...}
{vieweralsosee "[TE] teffects aipw" "help teffects aipw"}{...}
{vieweralsosee "[TE] teffects ipw" "help teffects ipw"}{...}
{vieweralsosee "[TE] teffects ipwra" "help teffects ipwra"}{...}
{vieweralsosee "[TE] teffects nnmatch" "help teffects nnmatch"}{...}
{vieweralsosee "[TE] teffects psmatch" "help teffects psmatch"}{...}
{vieweralsosee "[TE] teffects ra" "help teffects ra"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] teffects" "help teffects"}{...}
{viewerjumpto "Syntax" "teffects_overlap##syntax"}{...}
{viewerjumpto "Menu" "teffects_overlap##menu"}{...}
{viewerjumpto "Description" "teffects_overlap##description"}{...}
{viewerjumpto "Links to PDF documentation" "teffects_overlap##linkspdf"}{...}
{viewerjumpto "Options" "teffects_overlap##options"}{...}
{viewerjumpto "Examples" "teffects_overlap##examples"}{...}
{viewerjumpto "Stored results" "teffects_overlap##results"}{...}
{viewerjumpto "Reference" "teffects_overlap##reference"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[TE] teffects overlap} {hline 2}}Overlap plots{p_end}
{p2col:}({mansection TE teffectsoverlap:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:teffects overlap} [{cmd:,}
         {it:{help teffects overlap##treat_options:treat_options}}
	 {it:{help teffects overlap##kden_options:kden_options}}]

{marker treat_options}{...}
{synoptset 28 tabbed}{...}
{synopthdr: treat_options}
{synoptline}
{syntab :Main}
{synopt: {opt pt:level(treat_level)}}calculate predicted probabilities for
    treatment level {it:treat_level}; by default, {opt ptlevel()} corresponds
    to the first treatment level{p_end}
{synopt: {opt tl:evels(treatments)}}specify conditioning treatment
     levels; default is all treatment levels{p_end}
{synopt: {opt nolab:el}}use treatment level values and not value labels in
     legend and axis titles{p_end}
{synoptline}

{marker kden_options}{...}
{synopthdr:kden_options}
{synoptline}
{syntab :Main}
{synopt: {opth k:ernel(teffects_overlap##kernel:kernel)}}specify kernel
            function; default is {cmd:kernel(triangle)}{p_end}
{synopt :{opt n(#)}}estimate densities using {it:#} points; default is
{cmd:e(N)}, the number of observations in the estimation sample{p_end}
{synopt :{opt bw:idth(#)}}half-width of kernel{p_end}
{synopt :{opt at(var_x)}}estimate densities using the values specified by {it:var_x}{p_end}

{syntab :Kernel plots}
{synopt :{cmd:line}{it:#}{cmd:opts(}{it:{help cline_options}}{cmd:)}}affect rendition of density for conditioning treatment {it:#}{p_end}

{syntab :Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated graph{p_end}

{syntab :Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {opt by()} documented in 
    {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 28}{...}
{marker kernel}{...}
{synopthdr :kernel}
{synoptline}
{synopt :{opt tri:angle}}triangle kernel function; the default{p_end}
{synopt :{opt ep:anechnikov}}Epanechnikov kernel function{p_end}
{synopt :{opt epan2}}alternative Epanechnikov kernel function{p_end}
{synopt :{opt bi:weight}}biweight kernel function{p_end}
{synopt :{opt cos:ine}}cosine trace kernel function{p_end}
{synopt :{opt gau:ssian}}Gaussian kernel function{p_end}
{synopt :{opt par:zen}}Parzen kernel function{p_end}
{synopt :{opt rec:tangle}}rectangle kernel function{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Treatment effects > Overlap plots}


{marker description}{...}
{title:Description}

{pstd}
One of the assumptions required to use the {cmd:teffects} and {cmd:stteffects}
estimators is the overlap assumption, which states that each individual has a
positive probability of receiving each treatment level.  {cmd:teffects}
{cmd:overlap}, a postestimation command, plots the estimated densities of the
probability of getting each treatment level.  These plots can be used to check
whether the overlap assumption is violated.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TE teffectsoverlapQuickstart:Quick start}

        {mansection TE teffectsoverlapRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt ptlevel(treat_level)} specifies that predicted probabilities be
calculated for treatment level {it:treat_level}.  The default is
{opt ptlevel(first)}, where {it:first} is the first treatment level.

{phang}
{opt tlevels(treatments)}  specifies the observations for which to obtain
predicted probabilities.  By default, all treatment levels are used.  Specify
{it:treatments} as a space-delimited list.

{pmore}
For instance,

            {cmd:. teffects overlap, ptlevel(1) tlevels(1 2)}

{pmore}
says to predict the probability of getting treatment level 1 for those
subjects who actually obtained treatment levels 1 or 2.

{phang}
{opt nolabel} specifies that treatment level values and not value labels be
used in legend and axis titles.

{phang}
{opth "kernel(teffects_overlap##kernel:kernel)"} specifies the kernel function
for use in calculating the kernel density estimates.  The default kernel is
the triangle kernel ({opt triangle}).

{phang}
{opt n(#)} specifies the number of points at which the density estimate is to
be evaluated.  The default is {cmd:e(N)}, the estimation sample size.

{phang}
{opt bwidth(#)} specifies the half-width of the kernel, the width of the
density window around each point.  If {opt bwidth()} is not specified, the
"optimal" width is calculated and used; see {manhelp kdensity R}.  The
optimal width is the width that would minimize the mean integrated squared
error if the data were Gaussian and a Gaussian kernel were used, so it is not
optimal in any global sense.  In fact, for multimodal and highly skewed
densities, this width is usually too wide and oversmooths the
density ({help teffects_overlap##S1986:Silverman 1986}).

{phang}
{opt at(var_x)} specifies a variable that contains the values at which the
density should be estimated.  This option allows you to more easily obtain
density estimates for different variables or different subsamples of a
variable and then overlay the estimated densities for comparison.

{dlgtab:Kernel plots}

{phang}
{cmd:line}{it:#}{cmd:opts(}{it:cline_options}{cmd:)} affect the
rendition of the plotted kernel density estimates.
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
{phang2}{cmd:. webuse cattaneo2}{p_end}

{pstd}Estimate treatment effects by propensity score matching{p_end}
{phang2}{cmd:. teffects psmatch (bweight) (mbsmoke mmarried c.mage##c.mage}
     {cmd:fbaby medu, probit), generate(po)}{p_end}

{pstd}Draw overlap plot for control group{p_end}
{phang2}{cmd:. teffects overlap, name(control)}{p_end}

{pstd}Draw overlap plot for treatment group{p_end}
{phang2}{cmd:. teffects overlap, ptl(1) name(treatment)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:teffects overlap} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(bwidth}{it:j}{cmd:)}}kernel bandwidth for treatment level
{it:j}{p_end}
{synopt:{cmd:r(n}{it:j}{cmd:)}}number of points at which the estimate was
evaluated for treatment level {it:j}{p_end}
{synopt:{cmd:r(scale}{it:j}{cmd:)}}density bin width for treatment level
{it:j}{p_end}

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
