{smcl}
{* *! version 1.3.9  19oct2017}{...}
{viewerdialog roctab "dialog roctab"}{...}
{vieweralsosee "[R] roctab" "mansection R roctab"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] logistic postestimation" "help logistic postestimation"}{...}
{vieweralsosee "[R] roc" "help roc"}{...}
{vieweralsosee "[R] roccomp" "help roccomp"}{...}
{vieweralsosee "[R] rocfit" "help rocfit"}{...}
{vieweralsosee "[R] rocreg" "help rocreg"}{...}
{viewerjumpto "Syntax" "roctab##syntax"}{...}
{viewerjumpto "Menu" "roctab##menu"}{...}
{viewerjumpto "Description" "roctab##description"}{...}
{viewerjumpto "Links to PDF documentation" "roctab##linkspdf"}{...}
{viewerjumpto "Options" "roctab##options"}{...}
{viewerjumpto "Examples" "roctab##examples"}{...}
{viewerjumpto "Stored results" "roctab##results"}{...}
{viewerjumpto "References" "roctab##references"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[R] roctab} {hline 2}}Nonparametric ROC analysis
{p_end}
{p2col:}({mansection R roctab:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:roctab}{space 1}
{it:refvar}
{it:classvar}
{ifin}
[{it:{help roctab##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 25 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{synopt:{opt lor:enz}}report Gini and Pietra indices{p_end}
{synopt:{opt bino:mial}}calculate exact binomial confidence intervals{p_end}
{synopt:{opt nolab:el}}display numeric codes rather than value labels{p_end}
{synopt:{opt d:etail}}show details on sensitivity/specificity for each
cutpoint{p_end}
{synopt:{opt tab:le}}display the raw data in a 2 x k contingency table{p_end}
{synopt:{opt bam:ber}}calculate standard errors by using the Bamber
method{p_end}
{synopt:{opt han:ley}}calculate standard errors by using the Hanley
method{p_end}
{synopt:{opt g:raph}}graph the ROC curve{p_end}
{synopt:{opt noref:line}}suppress plotting the 45-degree reference line{p_end}
{synopt:{opt sum:mary}}report the area under the ROC curve{p_end}
{synopt:{opt spec:ificity}}graph sensitivity versus specificity{p_end}
{synopt:{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}

{syntab:Plot}
{synopt:{cmdab:plotop:ts(}{it:{help roctab##plot_options:plot_options}}{cmd:)}}affect 
	rendition of the ROC curve{p_end}

{syntab:Reference line}
{synopt:{opth rlop:ts(cline_options)}}affect rendition of the reference
line{p_end}

{syntab:Add plots}
{synopt:{opth "addplot(addplot_option:plot)"}}add other plots to generated
graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt:{it:twoway_options}}any options other than {opt by()} documented
in {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s are allowed; see {help weight}.


{marker plot_options}{...}
{synoptset 25}{...}
{synopthdr:plot_options}
{synoptline}
INCLUDE help gr_markopt2
INCLUDE help gr_clopt
{synoptline}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Epidemiology and related > ROC analysis >}
        {bf:Nonparametric ROC analysis without covariates}


{marker description}{...}
{title:Description}

{pstd}
The above command is used to perform receiver operating characteristic
(ROC) analyses with rating and discrete classification data.

{pstd}
The two variables {it:refvar} and {it:classvar} must be numeric. The
reference variable indicates the true state of the observation, such as
diseased and nondiseased or normal and abnormal, and must be coded as 0 and 1.
The rating or outcome of the diagnostic test or test modality is recorded in
{it:classvar}, which must be at least ordinal, with higher values indicating
higher risk.

{pstd}
{opt roctab} performs nonparametric ROC analyses.  By default,
{opt roctab} calculates the area under the ROC curve.  Optionally,
{opt roctab} can plot the ROC curve, display the data in tabular form, and
produce Lorenz-like plots.

{pstd}
See {manhelp rocfit R} for a command that fits maximum-likelihood ROC models.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R roctabQuickstart:Quick start}

        {mansection R roctabRemarksandexamples:Remarks and examples}

        {mansection R roctabMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt lorenz} specifies that the Gini and Pietra indices be reported.
Optionally, {opt graph} will plot the Lorenz-like curve.

{phang}
{opt binomial} specifies that exact binomial confidence intervals be
calculated.

{phang}
{opt nolabel} specifies that numeric codes be displayed rather than value
labels.

{phang}
{opt detail} outputs a table displaying the sensitivity, specificity, the
percentage of subjects correctly classified, and two likelihood ratios for
each possible cutpoint of {it:classvar}.

{phang}
{opt table} outputs a 2 x k contingency table displaying the raw data.

{phang}
{opt bamber} specifies that the standard error for the area under the
ROC curve be calculated using the method suggested by 
{help roctab##B1975:Bamber (1975)}.
Otherwise, standard errors are obtained as suggested by
{help roctab##DDC1988:DeLong, DeLong, and Clarke-Pearson (1988)}.

{phang}
{opt hanley} specifies that the standard error for the area under the
ROC curve be calculated using the method suggested by 
{help roctab##HM1982:Hanley and McNeil (1982)}.
Otherwise, standard errors are obtained as suggested by 
{help roctab##DDC1988:DeLong, DeLong, and Clarke-Pearson (1988)}.

{phang}
{opt graph} produces graphical output of the ROC curve. If {opt lorenz}
is specified, the graphical output of a Lorenz-like curve will be produced.

{phang}
{opt norefline} suppresses plotting the 45-degree reference line
from the graphical output of the ROC curve.

{phang}
{opt summary} reports the area under the ROC curve, its standard error,
and its confidence interval. If {opt lorenz} is specified, Lorenz indices are
reported.  This option is needed only when also specifying {opt graph}.

{phang}
{opt specificity} produces a graph of sensitivity versus specificity
instead of sensitivity versus (1 - specificity).  {opt specificity} implies
{opt graph}.

{phang}
{opt level(#)} specifies the confidence level, as a percentage,
for the confidence intervals. The default is {cmd:level(95)} or as set by
{helpb set level}.

{dlgtab:Plot}

{phang}
{opt plotopts(plot_options)}
affects the rendition of the plotted ROC curve -- the curve's plotted points
connected by lines.  The {it:plot_options} can affect the size and color of
markers, whether and how the markers are labeled, and whether and how the
points are connected; see {manhelpi marker_options G-3},
{manhelpi marker_label_options G-3}, and {manhelpi cline_options G-3}.

{dlgtab:Reference line}

{phang}
{opt rlopts(cline_options)} affects the rendition of the reference line; see
{manhelpi cline_options G-3}.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the
generated graph; see {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include options for
titling the graph (see {manhelpi title_options G-3}) and for saving the
graph to disk (see {manhelpi saving_option G-3}).


{marker examples}{...}
{title:Examples}

    Nonparametric ROC analysis example
{phang2}{cmd:. webuse hanley}{p_end}
{phang2}{cmd:. roctab disease rating}{p_end}
{phang2}{cmd:. roctab disease rating, graph}{p_end}
{phang2}{cmd:. roctab disease rating, graph summary}{p_end}
{phang2}{cmd:. roctab disease rating [fw=pop]}{p_end}
{phang2}{cmd:. roctab disease rating, table detail}{p_end}
{phang2}{cmd:. roctab disease rating, lorenz}{p_end}
{phang2}{cmd:. roctab disease rating, lorenz graph}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:roctab} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(se)}}standard error for the area under the ROC curve{p_end}
{synopt:{cmd:r(lb)}}lower bound of CI for the area under the ROC curve{p_end}
{synopt:{cmd:r(ub)}}upper bound of CI for the area under the ROC curve{p_end}
{synopt:{cmd:r(level)}}confidence level{p_end}
{synopt:{cmd:r(area)}}area under the ROC curve{p_end}
{synopt:{cmd:r(pietra)}}Pietra index{p_end}
{synopt:{cmd:r(gini)}}Gini index{p_end}

{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(cutpoints)}}description of cutpoints ({cmd:detail} only){p_end}

{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(detail)}}matrix with details on sensitivity and specificity for each cutpoint ({cmd:detail} only){p_end}


{marker references}{...}
{title:References}

{marker B1975}{...}
{phang}
Bamber, D. 1975. The area above the ordinal dominance graph and the area below
the receiver operating characteristic graph.
{it:Journal of Mathematical Psychology} 12: 387-415.

{marker DDC1988}{...}
{phang}
DeLong, E. R., D. M. DeLong, and D. L. Clarke-Pearson. 1988. Comparing the
areas under two or more correlated receiver operating characteristic curves:
A nonparametric approach. {it:Biometrics} 44: 837-845.

{marker HM1982}{...}
{phang}
Hanley, J. A., and B. J. McNeil. 1982.  The meaning and use of the area under
a receiver operating characteristic (ROC) curve. {it:Radiology} 143: 29-36.
{p_end}
