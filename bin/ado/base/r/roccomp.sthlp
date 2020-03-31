{smcl}
{* *! version 1.0.12  23oct2017}{...}
{viewerdialog roccomp "dialog roccomp"}{...}
{viewerdialog rocgold "dialog rocgold"}{...}
{vieweralsosee "[R] roccomp" "mansection R roccomp"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] logistic postestimation" "help logistic postestimation"}{...}
{vieweralsosee "[R] roc" "help roc"}{...}
{vieweralsosee "[R] rocfit" "help rocfit"}{...}
{vieweralsosee "[R] rocreg" "help rocreg"}{...}
{vieweralsosee "[R] roctab" "help roctab"}{...}
{viewerjumpto "Syntax" "roccomp##syntax"}{...}
{viewerjumpto "Menu" "roccomp##menu"}{...}
{viewerjumpto "Description" "roccomp##description"}{...}
{viewerjumpto "Links to PDF documentation" "roccomp##linkspdf"}{...}
{viewerjumpto "Options" "roccomp##options_roccomp"}{...}
{viewerjumpto "Examples" "roccomp##examples"}{...}
{viewerjumpto "Stored results" "roccomp##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[R] roccomp} {hline 2}}Tests of equality of ROC areas
{p_end}
{p2col:}({mansection R roccomp:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Test equality of ROC areas

{p 8 16 2}
{cmd:roccomp}
{it:refvar}
{it:classvar}
[{it:classvars}]
{ifin}
[{it:{help roccomp##weight:weight}}]
[{cmd:,} {it:{help roccomp##roccomp_options:roccomp_options}}]


{pstd}
Test equality of ROC area against a standard ROC curve

{p 8 16 2}
{cmd:rocgold}
{it:refvar}
{it:goldvar}
{it:classvar}
[{it:classvars}]
{ifin}
[{it:{help roccomp##weight:weight}}]
[{cmd:,} {it:{help roccomp##rocgold_options:rocgold_options}}]


{marker roccomp_options}{...}
{synoptset 25 tabbed}{...}
{synopthdr:roccomp_options}
{synoptline}
{syntab:Main}
{synopt:{opth by(varname)}}split into groups by variable{p_end}
{synopt:{opt test(matname)}}use contrast matrix for comparing ROC
areas{p_end}
{synopt:{opt g:raph}}graph the ROC curve{p_end}
{synopt:{opt noref:line}}suppress plotting the 45-degree reference line{p_end}
{synopt:{opt sep:arate}}place each ROC curve on its own graph{p_end}
{synopt:{opt sum:mary}}report the area under the ROC curve{p_end}
{synopt:{opt bin:ormal}}estimate areas by using binormal distribution
assumption{p_end}
{synopt:{cmdab:line:}{ul:{it:#}}{cmd:opts(}{it:{help cline_options}}{cmd:)}}affect rendition of the {it:#}th binormal fit line{p_end}
{synopt:{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}

{syntab:Plot}
{synopt:{cmdab:plot:}{ul:{it:#}}{cmd:opts(}{it:{help roccomp##plot_options:plot_options}}{cmd:)}}affect 
	rendition of the {it:#}th  ROC curve{p_end}

{syntab:Reference line}
{synopt:{opth rlop:ts(cline_options)}}affect rendition of the reference
line{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt:{it:twoway_options}}any options other than {opt by()} documented
in {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}

{marker rocgold_options}{...}
{synoptset 25 tabbed}{...}
{synopthdr:rocgold_options}
{synoptline}
{syntab:Main}
{synopt:{opt sid:ak}}adjust the p-value by using Sidak's
method{p_end}
{synopt:{opt test(matname)}}use contrast matrix for comparing ROC
areas{p_end}
{synopt:{opt g:raph}}graph the ROC curve{p_end}
{synopt:{opt noref:line}}suppress plotting the 45-degree reference line{p_end}
{synopt:{opt sep:arate}}place each ROC curve on its own graph{p_end}
{synopt:{opt sum:mary}}report the area under the ROC curve{p_end}
{synopt:{opt bin:ormal}}estimate areas by using binormal distribution
assumption{p_end}
{synopt:{cmdab:line:}{ul:{it:#}}{cmd:opts(}{it:{help cline_options}}{cmd:)}}affect rendition of the {it:#}th binormal fit line{p_end}
{synopt:{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}

{syntab:Plot}
{synopt:{cmdab:plot:}{ul:{it:#}}{cmd:opts(}{it:{help roccomp##plot_options:plot_options}}{cmd:)}}affect 
        rendition of the {it:#}th ROC curve; plot 1 is the "gold standard"{p_end}

{syntab:Reference line}
{synopt:{opth rlop:ts(cline_options)}}affect rendition of the reference
line{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt:{it:twoway_options}}any options other than {opt by()} documented
in {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}


{marker plot_options}{...}
{synoptset 25}{...}
{synopthdr:plot_options}
{synoptline}
INCLUDE help gr_markopt2
INCLUDE help gr_clopt
{synoptline}


{marker weight}{...}
{p 4 6 2}{opt fweight}s are allowed; see {help weight}.


{marker menu}{...}
{title:Menu}

    {title:roccomp}

{phang2}
{bf:Statistics > Epidemiology and related > ROC analysis >}
         {bf:Test equality of two or more ROC areas}

    {title:rocgold}

{phang2}
{bf:Statistics > Epidemiology and related > ROC analysis >}
         {bf:Test equality of ROC area against gold standard}


{marker description}{...}
{title:Description}

{pstd}
{cmd:roccomp} and {cmd:rocgold} are used to perform receiver operating
characteristic (ROC) analyses with rating and discrete classification data.

{pstd}
The two variables {it:refvar} and {it:classvar} must be numeric. The
reference variable indicates the true state of the observation, such as
diseased and nondiseased or normal and abnormal, and must be coded as 0 and 1.
The rating or outcome of the diagnostic test or test modality is recorded in
{it:classvar}, which must be at least ordinal, with higher values indicating
higher risk.

{pstd}
{opt roccomp} tests the equality of two or more ROC areas obtained from
applying two or more test modalities to the same sample or to independent
samples.  {opt roccomp} expects the data to be in wide form when comparing
areas estimated from the same sample and in long form for areas estimated
from independent samples.

{pstd}
{opt rocgold} independently tests the equality of the ROC area of each of
several test modalities, specified by {it:casevar}, against a "gold standard"
ROC curve, {it:goldvar}.  For each comparison, {opt rocgold} reports
the raw and the Bonferroni-adjusted p-value.
Optionally, Sidak's adjustment for multiple comparisons can be obtained.

{pstd}
See {manhelp rocfit R} and {manhelp rocreg R} for commands that fit
maximum-likelihood ROC models.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R roccompQuickstart:Quick start}

        {mansection R roccompRemarksandexamples:Remarks and examples}

        {mansection R roccompMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_roccomp}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth by(varname)} ({opt roccomp} only) is required when comparing independent
ROC areas.  The {opt by()} variable identifies the groups to be compared.

{phang}
{opt sidak} ({opt rocgold} only) requests that the p-value be
adjusted for the effect of multiple comparisons by using Sidak's method.
Bonferroni's adjustment is reported by default.

{phang}
{opt test(matname)} specifies the contrast matrix to be used when comparing
ROC areas.  By default, the null hypothesis that all areas are equal is
tested.

{phang}
{opt graph} produces graphical output of the ROC curve.

{phang}
{opt norefline} suppresses plotting the 45-degree reference line from the
graphical output of the ROC curve.

{phang}
{opt separate} is meaningful only with {opt roccomp} and specifies that each
ROC curve be placed on its own graph rather than one curve on top of the
other.

{phang}
{opt summary} reports the area under the ROC curve, its standard error, and
its confidence interval.  This option is needed only when also specifying
{opt graph}.

{phang}
{opt binormal} specifies that the areas under the ROC curves to be
compared should be estimated using the binormal distribution assumption. By
default, areas to be compared are computed using the trapezoidal rule.

{phang}
{cmd:line}{it:#}{cmd:opts(}{it:cline_options}{cmd:)} affect the rendition
of the line representing the {it:#}th ROC curve drawn using the binormal
distribution assumption; see {manhelpi cline_options G-3}.  These lines are
drawn only if the {cmd:binormal} option is specified.{p_end}

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for the
confidence intervals.  The default is {cmd:level(95)} or as set by
{helpb set level}.

{dlgtab:Plot}

{phang}
{cmd:plot}{it:#}{cmd:opts(}{it:plot_options}{cmd:)} 
affect the rendition of the {it:#}th ROC curve -- the curve's plotted
points connected by lines.  The {it:plot_options} can affect the size and
color of markers, whether and how the markers are labeled, and whether and how
the points are connected; see {manhelpi marker_options G-3}, 
{manhelpi marker_label_options G-3}, and {manhelpi cline_options G-3}.

{pmore}
For {cmd:rocgold}, {cmd:plot1opts()} are applied to the ROC for the gold
standard.

{dlgtab:Reference line}

{phang}
{opt rlopts(cline_options)} affects the rendition of the reference line; see
{manhelpi cline_options G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}.  These include options for titling the graph
(see {manhelpi title_options G-3}), options for saving the graph to disk
(see {manhelpi saving_option G-3}), and the {opt by()} option (see 
{manhelpi by_option G-3}).


{marker examples}{...}
{title:Examples}

    Setup
{phang2}{cmd:. webuse ct2}{p_end}

{pstd}Test whether area under ROC for {cmd:mod1} equals area under ROC for
      {cmd:mod3}{p_end}
{phang2}{cmd:. roccomp status mod1 mod3}{p_end}

{pstd}Add graph of ROC curves{p_end}
{phang2}{cmd:. roccomp status mod1 mod3, graph summary}{p_end}

{pstd}Use contrast matrix C when comparing ROC areas{p_end}
{phang2}{cmd:. matrix C = (1,0,-1)}{p_end}
{phang2}{cmd:. roccomp status mod1 mod2 mod3, test(C)}{p_end}

{pstd}Compare {cmd:mod2} and {cmd:mod3} areas to the {cmd:mod1} gold standard
{p_end}
{phang2}{cmd:. rocgold status mod1 mod2 mod3}{p_end}

{pstd}Add graph of ROC curves{p_end}
{phang2}{cmd:. rocgold status mod1 mod2 mod3, graph summary}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:roccomp} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N_g)}}number of groups{p_end}
{synopt:{cmd:r(p)}}p-value for chi-squared test{p_end}
{synopt:{cmd:r(df)}}chi-squared degrees of freedom{p_end}
{synopt:{cmd:r(chi2)}}chi-squared{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(V)}}variance-covariance matrix{p_end}

{pstd}
{cmd:rocgold} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N_g)}}number of groups{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(V)}}variance-covariance matrix{p_end}
{synopt:{cmd:r(chi2)}}chi-squared vector{p_end}
{synopt:{cmd:r(df)}}chi-squared degrees-of-freedom vector{p_end}
{synopt:{cmd:r(p)}}vector of p-values for chi-squared tests{p_end}
{synopt:{cmd:r(p_adj)}}vector of adjusted p-values{p_end}
{p2colreset}{...}
