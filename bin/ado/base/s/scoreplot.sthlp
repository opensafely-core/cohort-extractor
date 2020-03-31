{smcl}
{* *! version 1.2.11  19oct2017}{...}
{viewerdialog scoreplot "dialog scoreplot"}{...}
{viewerdialog loadingplot "dialog loadingplot"}{...}
{vieweralsosee "[MV] scoreplot" "mansection MV scoreplot"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] candisc" "help candisc"}{...}
{vieweralsosee "[MV] discrim lda" "help discrim_lda"}{...}
{vieweralsosee "[MV] discrim lda postestimation" "help discrim_lda_postestimation"}{...}
{vieweralsosee "[MV] factor" "help factor"}{...}
{vieweralsosee "[MV] factor postestimation" "help factor_postestimation"}{...}
{vieweralsosee "[MV] pca" "help pca"}{...}
{vieweralsosee "[MV] pca postestimation" "help pca_postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] screeplot" "help screeplot"}{...}
{viewerjumpto "Syntax" "scoreplot##syntax"}{...}
{viewerjumpto "Menu" "scoreplot##menu"}{...}
{viewerjumpto "Description" "scoreplot##description"}{...}
{viewerjumpto "Links to PDF documentation" "scoreplot##linkspdf"}{...}
{viewerjumpto "Options" "scoreplot##options"}{...}
{viewerjumpto "Remarks" "scoreplot##remarks"}{...}
{viewerjumpto "Examples" "scoreplot##examples"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[MV] scoreplot} {hline 2}}Score and loading plots{p_end}
{p2col:}({mansection MV scoreplot:View complete PDF manual entry}){p_end}


{marker syntax}{...}
{title:Syntax}

{pstd}
Plot score variables

{phang2}
{cmd:scoreplot} {ifin} 
   [{cmd:,} {it:{help scoreplot##scoreplot_options:scoreplot_options}}]


{pstd}
Plot the loadings (factors, components, or discriminant functions)

{phang2}
{cmd:loadingplot}
   [{cmd:,} {it:{help scoreplot##loadingplot_options:loadingplot_options}}]


{marker scoreplot_options}{...}
{synoptset 23 tabbed}{...}
{synopthdr:scoreplot_options}
{synoptline}
{syntab:Main}
{synopt:{opt fac:tors(#)}}number of factors/scores to be plotted;  
	default is {cmd:factors(2)}{p_end}
{synopt:{opt com:ponents(#)}}synonym for {cmd:factors()}{p_end}
{synopt:{opt norot:ated}}use unrotated factors or scores, even if rotated results exist{p_end}
{synopt:{opt matrix}}graph as a matrix plot, available only when
     {cmd:factors(2)} is specified; default is a scatterplot{p_end}
{synopt:{opt combine:d}}graph as a combined plot, available when 
     {bind:{cmd:factors(}{it:#} > 2{cmd:)}}; default is a matrix plot{p_end}
{synopt:{opt half}}graph lower half only; allowed only with {cmd:matrix}{p_end}
{synopt:{it:{help graph_matrix:graph_matrix_options}}}affect the rendition of
	the matrix graph{p_end}
{synopt:{it:{help graph_combine:combine_options}}}affect the rendition of
	the combined graph{p_end}
{synopt:{opt score:opt(predict_opts)}}options for {cmd:predict} generating
	score variables{p_end}
{synopt:{it:{help marker_options}}}change look of markers (color, size, etc.){p_end}
{synopt:{it:{help marker_label_options}}}change look or position of marker labels{p_end}

{syntab:Y axis, X axis, Titles, Overall}
{synopt:{it:twoway_options}}any options other than {opt by()}
	documented in {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}

{marker loadingplot_options}{...}
{synoptset 23 tabbed}{...}
{synopthdr:loadingplot_options}
{synoptline}
{syntab:Main}
{synopt:{opt fac:tors(#)}}number of factors/scores to be plotted;  
	default is {cmd:factors(2)}{p_end}
{synopt:{opt com:ponents(#)}}synonym for {cmd:factors()}{p_end}
{synopt:{opt norot:ated}}use unrotated factors or scores, even if rotated results exist{p_end}
{synopt:{opt matrix}}graph as a matrix plot, available only when
     {cmd:factors(2)} is specified; default is a scatterplot{p_end}
{synopt:{opt combine:d}}graph as a combined plot, available when 
     {bind:{cmd:factors(}{it:#} > 2{cmd:)}}; default is a matrix plot{p_end}
{synopt:{opt half}}graph lower half only; allowed only with {cmd:matrix}{p_end}
{synopt:{it:{help graph_matrix:graph_matrix_options}}}affect the rendition of
	the matrix graph{p_end}
{synopt:{it:{help graph_combine:combine_options}}}affect the rendition of
	the combined graph{p_end}
{synopt:{opt max:length(#)}}abbreviate variable names to {it:#} characters;
	default is {cmd:maxlength(12)}{p_end}
{synopt:{it:{help marker_options}}}change look of markers (color, size, etc.){p_end}
{synopt:{it:{help marker_label_options}}}change look or position of marker labels{p_end}

{syntab:Y axis, X axis, Titles, Overall}
{synopt:{it:twoway_options}}any options other than {opt by()}
	documented in {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

    {title:scoreplot}

{phang2}
{bf:Statistics > Multivariate analysis >}
      {bf:Factor and principal component analysis > Postestimation >}
      {bf:Score variables plot}

    {title:loadingplot}

{phang2}
{bf:Statistics > Multivariate analysis >}
      {bf:Factor and principal component analysis > Postestimation >}
      {bf:Loading plot}


{marker description}{...}
{title:Description}

{pstd}
{cmd:scoreplot} produces scatterplots of the score variables after
{cmd:factor}, {cmd:factormat}, {cmd:pca}, or {cmd:pcamat}, and scatterplots
of the discriminant score variables after {cmd:discrim lda} or {cmd:candisc}.

{pstd}
{cmd:loadingplot} produces scatterplots of the loadings (factors or
components) after {cmd:factor}, {cmd:factormat}, {cmd:pca}, or {cmd:pcamat},
and the standardized discriminant function loadings after {cmd:discrim lda}
or {cmd:candisc}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV scoreplotQuickstart:Quick start}

        {mansection MV scoreplotRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt factors(#)} produces plots for all combination of score variables up to
{it:#}.  {it:#} should not exceed the number of retained factors (components
or discriminant functions)
and defaults to 2.  {opt components()} is a synonym.  No plot is produced with
{cmd:factors(1)}.

{phang}
{opt norotated} uses unrotated results, even when rotated results are
available.  The default is to use rotated results if they are available.
{opt norotated} is ignored if rotated results are not available.

{phang}{opt matrix}
specifies that plots be produced using {helpb graph matrix}.  This is the 
default when three or more factors are specified.
This option may not be used with {opt combined}.

{phang}{opt combined}
specifies that plots be produced using {helpb graph combine}.
This option may not be used with {opt matrix}.

{phang}
{cmd:half} specifies that only the lower half of the matrix be graphed.
{cmd:half} can be specified only with the {cmd:matrix} option.

{phang}{it:graph_matrix_options}
affect the rendition of the matrix plot; see
{manhelp graph_matrix G-2: graph matrix}.

{phang}{it:combine_options}
affect the rendition of the combined plot; see
{manhelp graph_combine G-2:graph combine}.
{it:combine_options} may not be specified unless {cmd:factors()} is greater
than 2.

{phang}{opt scoreopt(predict_opts)},
an option  used with {cmd:scoreplot}, specifies options for {helpb predict} to
generate the score variables.  For example, after {cmd:factor},
{cmd:scoreopt(bartlett)} specifies that Bartlett scoring be applied.

{phang}{opt maxlength(#)},
an option used with {cmd:loadingplot},
causes the variable names (used as point markers) to be abbreviated to {it:#}
characters.  The {helpb abbrev()} function performs the abbreviation, and if
{it:#} is less than 5, it is treated as 5.

{phang}
{it:marker_options}
affect the rendition of markers drawn at the plotted points, including
their shape, size, color, and outline; see {manhelpi marker_options G-3}.

{phang}
{it:marker_label_options}
specify if and how the markers are to be labeled; see
{manhelpi marker_label_options G-3}.

{dlgtab:Y axis, X axis, Titles, Overall}

{phang}
{it:twoway_options} are any of the options documented in
{manhelpi twoway_options G-3}, excluding {cmd:by()}.  These include options for
titling the graph (see {manhelpi title_options G-3}) and for saving the
graph to disk (see {manhelpi saving_option G-3}).


{marker remarks}{...}
{title:Remarks}

{pstd}
As the number of {opt factors()} or {opt components()} increases, the graphing
area for each plot gets smaller.  Although the default matrix view (option
{opt matrix}) may be the most natural, the combined view (option
{opt combined}) displays half as many graphs.  However, the combined view uses
more space for the labeling of axes than the matrix view.  Regardless of the
choice, with many requested factors or components the graphs become too
small to be of any use.  In {cmd:loadingplot}, the {opt maxlength()} option
will trim the variable name marker labels that are automatically included.
This may help reduce overlap when multiple small graphs are shown.  You can go
further and remove these marker labels by using the {opt mlabel("")} graph
option.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. pca price trunk rep78 head disp gear, comp(3)}

{pstd}Draw loading plot{p_end}
{phang2}{cmd:. loadingplot}

{pstd}Draw score plot{p_end}
{phang2}{cmd:. scoreplot, mlabel(make)}{p_end}
