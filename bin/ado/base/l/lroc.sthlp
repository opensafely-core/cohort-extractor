{smcl}
{* *! version 1.0.4  19oct2017}{...}
{viewerdialog lroc "dialog lroc"}{...}
{vieweralsosee "[R] lroc" "mansection R lroc"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ivprobit" "help ivprobit"}{...}
{vieweralsosee "[R] logistic" "help logistic"}{...}
{vieweralsosee "[R] logit" "help logit"}{...}
{vieweralsosee "[R] probit" "help probit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] estat classification" "help estat classification"}{...}
{vieweralsosee "[R] estat gof" "help logistic estat gof"}{...}
{vieweralsosee "[R] lsens" "help lsens"}{...}
{vieweralsosee "[R] roc" "help roc"}{...}
{viewerjumpto "Syntax" "lroc##syntax"}{...}
{viewerjumpto "Menu" "lroc##menu"}{...}
{viewerjumpto "Description" "lroc##description"}{...}
{viewerjumpto "Links to PDF documentation" "lroc##linkspdf"}{...}
{viewerjumpto "Options" "lroc##options"}{...}
{viewerjumpto "Example" "lroc##example"}{...}
{viewerjumpto "Stored results" "lroc##results"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[R] lroc} {hline 2}}Compute area under ROC curve and graph the
curve{p_end}
{p2col:}({mansection R lroc:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 13 2}
{cmd:lroc} [{depvar}] {ifin}
[{it:{help lroc##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 23 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{synopt :{opt all}}compute area under ROC curve and graph curve for all
observations{p_end}
{synopt :{opt nog:raph}}suppress graph{p_end}

{syntab :Advanced}
{synopt :{opt beta(matname)}}row vector containing model coefficients{p_end}

{syntab :Plot}
INCLUDE help gr_clopt
INCLUDE help gr_markopt2

{syntab :Reference line}
{synopt :{opth rlop:ts(cline_options)}}affect rendition of the reference
line{p_end}

{syntab :Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated graph{p_end}

{syntab :Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {opt by()} documented in 
  {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}
{marker weight}{...}
{p 4 6 2}{opt fweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}{cmd:lroc} is not appropriate after the {cmd:svy} prefix.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Binary outcomes > Postestimation >}
       {bf:ROC curve after logistic/logit/probit/ivprobit}


{marker description}{...}
{title:Description}

{pstd}
{cmd:lroc} graphs the ROC curve and calculates the area under the curve.

{pstd}
{cmd:lroc} requires that the current estimation results be from
{helpb logistic}, {helpb logit}, {helpb probit}, or {helpb ivprobit}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R lrocQuickstart:Quick start}

        {mansection R lrocRemarksandexamples:Remarks and examples}

        {mansection R lrocMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt all} requests that the statistic be computed for all observations in the
data, ignoring any {opt if} or {opt in} restrictions specified by
the estimation command.

{phang}
{opt nograph} suppresses graphical output.

{dlgtab:Advanced}

{phang}
{opt beta(matname)} specifies a row vector containing model coefficients.
The columns of the row vector must be labeled with the
corresponding names of the independent variables in the data.  The dependent
variable {depvar} must be specified immediately after the command name.  See
{mansection R lrocRemarksandexamplesModelsotherthanthelastfittedmodel:{it:Models other than the last fitted model}}
in {bf:[R] lroc}.

{dlgtab:Plot}

{phang}
{it:cline_options}, {it:marker_options}, and {it:marker_label_options}
affect the rendition of the ROC curve -- the plotted points connected
by lines.  These options affect the size and color of markers,
whether and how the markers are labeled, and whether and how the points are
connected; see {manhelpi cline_options G-3},
{manhelpi marker_options G-3}, and {manhelpi marker_label_options G-3}.

{dlgtab:Reference line}

{phang}
{opt rlopts(cline_options)} affects the rendition of the reference line; see
{manhelpi cline_options G-3}.

{marker addplot()}{...}
{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the generated graph;
see {manhelpi addplot_option G-3}.

{marker twoway_options}{...}
{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include options for
titling the graph (see {manhelpi title_options G-3}) and for saving the
graph to disk (see {manhelpi saving_option G-3}).


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse lbw}

{pstd}Fit logistic regression to predict low birth weight{p_end}
{phang2}{cmd:. logistic low age lwt i.race smoke ptl ht ui}

{pstd}Graph ROC curve and calculate area under the curve{p_end}
{phang2}{cmd:. lroc}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:lroc} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(area)}}area under the ROC curve{p_end}
{p2colreset}{...}
