{smcl}
{* *! version 1.2.2  19oct2017}{...}
{viewerdialog rocplot "dialog rocplot"}{...}
{vieweralsosee "[R] rocfit postestimation" "mansection R rocfitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] rocfit" "help rocfit"}{...}
{viewerjumpto "Postestimation commands" "rocfit postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "rocfit_postestimation##linkspdf"}{...}
{viewerjumpto "rocplot" "rocfit postestimation##syntax_rocplot"}{...}
{viewerjumpto "Examples" "rocfit postestimation##examples"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[R] rocfit postestimation} {hline 2}}Postestimation tools for rocfit{p_end}
{p2col:}({mansection R rocfitpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following command is of special interest after {opt rocfit}:

{synoptset 17}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
{synopt:{helpb rocfit_postestimation##rocplot:rocplot}}plot the fitted ROC curve and simultaneous confidence bands{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 17 tabbed}{...}
{p2coldent:Command}Description{p_end}
{synoptline}
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
{p2coldent:* {helpb lincom}}point estimates, standard errors, testing, and
inference for linear combinations of coefficients{p_end}
{p2coldent:* {helpb test}}Wald tests of simple and composite linear
hypotheses{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* See 
{mansection R rocfitpostestimationRemarksandexamplesUsinglincomandtest:{it:Using lincom and test}} in {bf:[R] rocfit postestimation}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R rocfitpostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker syntax_rocplot}{...}
{marker rocplot}{...}
{title:Syntax for rocplot}

{p 8 16 2}
{cmd:rocplot} [{cmd:,} {it:rocplot_options}]

{synoptset 25 tabbed}{...}
{synopthdr:rocplot_options}
{synoptline}
{syntab:Main}
{synopt:{opt conf:band}}display confidence bands{p_end}
{synopt:{opt noref:line}}suppress plotting the reference line{p_end}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}

{syntab:Plot}
{synopt:{cmdab:plotop:ts(}{it:{help rocfit_postestimation##plot_options:plot_options}}{cmd:)}}affect 
	rendition of the ROC points{p_end}

{syntab:Fit line}
{synopt:{cmdab:lineop:ts(}{it:{help cline_options}}{cmd:)}}affect rendition of 
	the fitted ROC line{p_end}

{syntab:CI plot}
{synopt:{opth ciop:ts(area_options)}}affect rendition of the 
	confidence bands{p_end}

{syntab:Reference line}
{synopt:{opth rlop:ts(cline_options)}}affect rendition of the reference line{p_end}

{syntab:Add plots}
{synopt:{opth "addplot(addplot_option:plot)"}}add other plots to the generated
graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt:{it:twoway_options}}any options other than {opt by()}
 documented in {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}

{marker plot_options}{...}
{synoptset 25}{...}
{synopthdr:plot_options}
{synoptline}
INCLUDE help gr_markopt2
INCLUDE help gr_clopt
{synoptline}


{marker menu_rocplot}{...}
{title:Menu for rocplot}

{phang}
{bf:Statistics > Epidemiology and related > ROC analysis >}
         {bf:ROC curves after rocfit}


{marker des_rocplot}{...}
{title:Description for rocplot}

{pstd}
{opt rocplot} plots the fitted ROC curve and simultaneous confidence bands.


{marker options_rocplot}{...}
{title:Options for rocplot}

{dlgtab:Main}

{phang}
{opt confband} specifies that simultaneous confidence bands be plotted
around the ROC curve.

{phang}
{opt norefline} suppresses plotting the 45-degree reference line
from the graphical output of the ROC curve.

{phang}
{opt level(#)} specifies the confidence level, as a percentage,
for the confidence bands.  The default is {cmd:level(95)} or as set by
{helpb set level}.

{dlgtab:Plot}

{phang}
{opt plotopts(plot_options)}
affects the rendition of the plotted ROC points, including the size and color
of markers, whether and how the markers are labeled, and whether and how the
points are connected. For the full list of available {it:plot_options}, see 
{manhelpi marker_options G-3}, {manhelpi marker_label_options G-3}, and 
{manhelpi cline_options G-3}.

{dlgtab:Fit line}

{phang}
{opt lineopts(cline_options)} affects the rendition of 
	the fitted ROC line; see {manhelpi cline_options G-3}.

{dlgtab:CI plot}

{phang}
{opt ciopts(area_options)} affects the rendition of the confidence
bands; see {manhelpi area_options G-3}.

{dlgtab:Reference line}

{phang}
{opt rlopts(cline_options)} affects the rendition of the reference
line; see {manhelpi cline_options G-3}.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the
generated graph; see {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in
{manhelpi twoway_options G-3}, excluding {opt by()}.
These include options for titling the graph
(see {manhelpi title_options G-3}) and for saving the graph to disk
(see {manhelpi saving_option G-3}).


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse hanley}{p_end}
{phang2}{cmd:. rocfit disease rating}{p_end}

{pstd}Test constant equals 0{p_end}
{phang2}{cmd:. test [intercept]_cons}{p_end}

{pstd}Plot fitted ROC curve and include confidence band{p_end}
{phang2}{cmd:. rocplot, confband}{p_end}
