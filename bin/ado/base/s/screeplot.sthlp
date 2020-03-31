{smcl}
{* *! version 1.2.9  22mar2018}{...}
{viewerdialog screeplot "dialog screeplot"}{...}
{vieweralsosee "[MV] screeplot" "mansection MV screeplot"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] factor" "help factor"}{...}
{vieweralsosee "[MV] mds" "help mds"}{...}
{vieweralsosee "[MV] pca" "help pca"}{...}
{viewerjumpto "Syntax" "screeplot##syntax"}{...}
{viewerjumpto "Menu" "screeplot##menu"}{...}
{viewerjumpto "Description" "screeplot##description"}{...}
{viewerjumpto "Links to PDF documentation" "screeplot##linkspdf"}{...}
{viewerjumpto "Options" "screeplot##options"}{...}
{viewerjumpto "Examples" "screeplot##examples"}{...}
{viewerjumpto "Stored results" "screeplot##results"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[MV] screeplot} {hline 2}}Scree plot of eigenvalues{p_end}
{p2col:}({mansection MV screeplot:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 18 2}{cmd:screeplot} [{it:eigvals}] [{cmd:,} {it:options}]

{pstd}
{cmd:scree} is a synonym for {cmd:screeplot}.

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt n:eigen(#)}}graph only largest {it:#} eigenvalues; default is
        to plot all eigenvalues{p_end}

{syntab:Mean}
{synopt:{opt me:an}}graph horizontal line at the mean of the eigenvalues{p_end}
{synopt:{opth meanl:opts(cline_options)}}affect rendition of the mean
	line{p_end}

{syntab:CI}
{synopt:{cmd:ci}[{cmd:(}{it:{help screeplot##ciopts:ci_options}}{cmd:)}]}graph confidence intervals 
	(after {helpb pca} only); {opt ci} is a synonym for {cmd:ci(asymptotic)}{p_end}

{syntab:Plot}
{synopt:{it:{help cline_options}}}affect rendition of the lines connecting points{p_end}
{synopt :{it:{help marker_options}}}change look of markers (color, size, etc.){p_end}

{syntab:Add plots}
{synopt:{opth "addplot(addplot_option:plot)"}}add other plots to the generated
	graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt:{it:twoway_options}}any options other than {cmd:by()} documented
	in {manhelpi twoway_options G-3}{p_end}
{synoptline}

{synoptset 26}{...}
{marker ciopts}{...}
{synopthdr:ci_options}
{synoptline}
{synopt:{opt as:ymptotic}}compute asymptotic confidence intervals; the default{p_end}
{synopt:{opt he:teroskedastic}}compute heteroskedastic bootstrap confidence
intervals{p_end}
{synopt:{opt ho:moskedastic}}compute homoskedastic bootstrap confidence
intervals{p_end}
{synopt:{it:{help area_options}}}affect the rendition of the
	confidence bands{p_end}
{synopt:{opt tab:le}}produce a table of confidence intervals{p_end}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt:{opt r:eps(#)}}number of bootstrap simulations; default is {cmd:reps(200)}{p_end}
{synopt:{opt seed(str)}}random-number {help seed} used for the bootstrap
	simulations{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate analysis >}
      {bf:Factor and principal component analysis > Postestimation >}
      {bf:Scree plot of eigenvalues}


{marker description}{...}
{title:Description}

{pstd}
{cmd:screeplot} produces a scree plot of the eigenvalues of a covariance or
correlation matrix.

{pstd}
{cmd:screeplot} automatically obtains the eigenvalues after 
{helpb candisc}, {helpb discrim lda},
{helpb factor}, {helpb factormat}, {helpb pca}, and {helpb pcamat}.
{cmd:screeplot} also works automatically to plot singular values after
{helpb ca} and {helpb camat}, canonical correlations after {helpb canon}, and
eigenvalues after {helpb manova}, {helpb mca}, {helpb mds}, {helpb mdsmat}, and
{helpb mdslong}.

{pstd}
{cmd:screeplot} lets you obtain a scree plot in other cases by directly
specifying {it:eigvals}, a vector containing the eigenvalues.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV screeplotQuickstart:Quick start}

        {mansection MV screeplotRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt neigen(#)}
specifies the number of eigenvalues to plot.  The default is to plot all
eigenvalues.

{dlgtab:Mean}

{phang}
{opt mean}
displays a horizontal line at the mean of the eigenvalues.

{phang}
{opt meanlopts(cline_options)}
affects the rendition of the mean reference line added using the {opt mean}
option; see {manhelpi cline_options G-3}.

{dlgtab:CI}

{phang}
{opt ci}[{cmd:(}{it:ci_options}{cmd:)}] displays confidence intervals for the
eigenvalues.  The option {opt ci} is a synonym for {cmd:ci(asymptotic)}. The
following methods for estimating confidence intervals are available:

{phang2}
{cmd:ci(asymptotic)}
specifies the asymptotic distribution of the eigenvalues of a central Wishart
distribution, the distribution of the covariance matrix of a sample from a
multivariate normal distribution.  The asymptotic theory applied to
correlation matrices is not fully correct, probably giving confidence
intervals that are somewhat too narrow.

{phang2}
{cmd:ci(heteroskedastic)}
specifies a parametric bootstrap by using the percentile method and assuming
that the eigenvalues are from a matrix that is multivariate normal with the
same eigenvalues as observed.

{phang2}
{cmd:ci(homoskedastic)}
specifies a parametric bootstrap by using the percentile method and assuming
that the eigenvalues are from a matrix that is multivariate normal with all
eigenvalues equal to the mean of the observed eigenvalues.  For a PCA of a
correlation matrix, this mean is 1.

{phang2}
{opt ci(area_options)}
affects the rendition of the confidence bands; see
{manhelpi area_options G-3}.

{phang2}
{cmd:ci(table)}
produces a table with the confidence intervals.

{phang2}
{cmd:ci(level(}{it:#}{cmd:))}
specifies the confidence level, as a percentage, for confidence intervals.
The default is {cmd:level(95)} or as set by {helpb set level}.

{phang2}
{cmd:ci(reps(}{it:#}{cmd:))}
specifies the number of simulations to be performed for estimating the 
confidence intervals.  This option is valid only when {opt heteroskedastic}
or {opt homoskedastic} is specified.  The default is {cmd:reps(200)}.

{phang2}
{cmd:ci(seed(}{it:str}{cmd:))}
sets the random-number seed used for the parametric bootstrap.  Setting the
seed makes sure that results are reproducible.  See
{cmd:set seed} in {manhelp set_seed R:set seed}.  This option is valid only when
{opt heteroskedastic} or {opt homoskedastic} is specified.

{pmore}
The confidence intervals are not adjusted for "simultaneous
inference" (see {manhelp _mtest P}).

{dlgtab:Plot}

{phang}
{it:cline_options} 
affect the rendition of the lines connecting the plotted points; see
{manhelpi cline_options G-3}.

{phang}
{it:marker_options} affect the rendition of markers drawn at the plotted
points, including their shape, size, color, and outline; see 
{manhelpi marker_options G-3}.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)}
provides a way to add other plots to the generated graph; see
{manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options}
are any of the options documented in {manhelpi twoway_options G-3}, excluding
{cmd:by()}.  These include options for titling the graph (see
{manhelpi title_options G-3}) and for saving the graph to disk (see
{manhelpi saving_option G-3}).


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse bg2}{p_end}
{phang2}{cmd:. factor bg2cost1-bg2cost6}

{pstd}Draw scree plot{p_end}
{phang2}{cmd:. screeplot}

{pstd}Setup{p_end}
{phang2}{cmd:. pca bg2cost1-bg2cost6}

{pstd}Draw scree plot with asymptotic confidence intervals{p_end}
{phang2}{cmd:. screeplot, ci(asymptotic)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:screeplot} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(level)}}confidence level for confidence intervals{p_end}

{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(Ctype)}}{cmd:correlation} or {cmd:covariance}{p_end}
{synopt:{cmd:r(ci)}}method for estimating confidence interval{p_end}
{synopt:{cmd:r(rngstate)}}random-number state used for parametric bootstrap{p_end}

{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(ci)}}confidence intervals{p_end}
{synopt:{cmd:r(eigvals)}}eigenvalues{p_end}
{p2colreset}{...}
