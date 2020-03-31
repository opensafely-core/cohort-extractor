{smcl}
{* *! version 1.0.17  19oct2017}{...}
{viewerdialog rocregplot "dialog rocregplot"}{...}
{vieweralsosee "[R] rocregplot" "mansection R rocregplot"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] rocreg" "help rocreg"}{...}
{vieweralsosee "[R] rocreg postestimation" "help rocreg_postestimation"}{...}
{viewerjumpto "Syntax" "rocregplot##syntax"}{...}
{viewerjumpto "Menu" "rocregplot##menu"}{...}
{viewerjumpto "Description" "rocregplot##description"}{...}
{viewerjumpto "Links to PDF documentation" "rocregplot##linkspdf"}{...}
{viewerjumpto "probit_options" "rocregplot##options_probit"}{...}
{viewerjumpto "common_options" "rocregplot##options_common"}{...}
{viewerjumpto "boot_options" "rocregplot##options_boot"}{...}
{viewerjumpto "Examples" "rocregplot##examples"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[R] rocregplot} {hline 2}}Plot marginal and covariate-specific
	ROC curves after rocreg{p_end}
{p2col:}({mansection R rocregplot:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Plot ROC curve after nonparametric analysis

{p 8 16 2}
{cmd:rocregplot} [{cmd:,}
{it:{help rocregplot##common_options:common_options}}
{it:{help rocregplot##boot_options:boot_options}}]


{pstd}
Plot ROC curve after parametric analysis using bootstrap

{p 8 16 2}
{cmd:rocregplot} [{cmd:,}
{it:{help rocregplot##probit_options:probit_options}}
{it:{help rocregplot##common_options:common_options}}
{it:{help rocregplot##boot_options:boot_options}}]


{pstd}
Plot ROC curve after parametric analysis using maximum likelihood

{p 8 16 2}
{cmd:rocregplot} [{cmd:,}
{it:{help rocregplot##probit_options:probit_options}}
{it:{help rocregplot##common_options:common_options}}]


{marker probit_options}{...}
{synoptset 35 tabbed}{...}
{synopthdr:probit_options}
{synoptline}
{syntab:Main}
{synopt :{cmd:at(}{varname}{cmd:=}{it:#} [{varname}{cmd:=}{it:# ...}]{cmd:)}}value
	of specified covariates{p_end}
{p2col 9 44 44 2:[{cmd:at1(}{varname}{cmd:=}{it:#} [{varname}{cmd:=}{it:# ...}]{cmd:)}}and mean of unspecified covariates{p_end}
{p2col 9 42 42 2:[{cmd:at2(}{varname}{cmd:=}{it:#} [{varname}{cmd:=}{it:# ...}]{cmd:)}}{p_end}
{p2col 9 42 42 2:[...]]]}{p_end}
{p2coldent:* {cmd:roc(}{it:{help numlist}}{cmd:)}}show estimated ROC values for
        given false-positive rates{p_end}
{p2coldent:* {cmd:invroc(}{it:{help numlist}}{cmd:)}}show estimated
    false-positive rates for given ROC values{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}

{syntab:Curve}
{synopt:{cmd:line}{it:#}{cmd:opts(}{it:{help cline_options}}{cmd:)}}affect
	rendition of ROC curve {it:#}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* Only one of {opt roc()} or {opt invroc()} may be specified. {p_end}


{marker common_options}{...}
{synoptset 35 tabbed}{...}
{synopthdr:common_options}
{synoptline}
{syntab:Main}
{synopt:{opth classvars(varlist)}}restrict plotting of ROC curves to specified
    classifiers {p_end}
{synopt:{opt norefline}}suppress plotting the reference line {p_end}

{syntab:Scatter}
{synopt:{cmd:plot}{it:#}{cmd:opts(}{it:{help scatter:scatter_options}}{cmd:)}}affect
	rendition of the classifier {it:#}s false-positive rate and ROC
	scatter points; not allowed with {opt at()}{p_end}

{syntab:Reference line}
{synopt:{opth rlop:ts(cline_options)}}affect rendition of the reference
	line{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt:{it:twoway_options}}any options other than {opt by()}
	documented in {manhelpi twoway_options G-3}{p_end}
{synoptline}


{marker boot_options}{...}
{synoptset 35 tabbed}{...}
{synopthdr:boot_options}
{synoptline}
{syntab:Bootstrap}
{p2coldent:* {opth bfile(filename)}}load dataset
      containing bootstrap replicates from {cmd:rocreg} {p_end}
{synopt:{cmd:btype(n} | {cmd:p} | {cmd:bc)}}plot normal-based ({cmd:n}),
   percentile ({cmd:p}), or bias-corrected ({cmd:bc}) confidence intervals;
   default is {cmd:btype(n)}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt bfile()} is only allowed with parametric analysis using bootstrap
  inference; in which case this option is required with
  {opt roc()} or {opt invroc()}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Epidemiology and related > ROC analysis >}
         {bf:ROC curves after rocreg}


{marker description}{...}
{title:Description}

{pstd}
Under parametric estimation, {cmd:rocregplot} plots the fitted ROC curves for
specified covariate values and classifiers.  If {cmd:rocreg, probit} or
{cmd:rocreg, probit ml} were previously used, the false-positive rates
(for specified ROC values) and ROC values (for specified false-positive rates)
for each curve may also be plotted, along with confidence intervals. 

{pstd}
Under nonparametric estimation, {cmd:rocregplot} will plot the fitted ROC
curves using the {cmd:_fpr_}* and {cmd:_roc_}* variables produced by
{cmd:rocreg}.  Point estimates and confidence intervals for false-positive
rates and ROC values that were computed in {cmd:rocreg} may be plotted as well.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R rocregplotQuickstart:Quick start}

        {mansection R rocregplotRemarksandexamples:Remarks and examples}

        {mansection R rocregplotMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_probit}{...}
{title:probit_options}

{dlgtab:Main}

{phang}
{cmd:at(}{it:{help varname}}{cmd:=}{it:# ...}{cmd:)} requests that the
covariates specified by {it:varname} be set to {it:#}.  By default,
{cmd:rocregplot} evaluates the function by setting each covariate to its mean
value.  This option causes the ROC curve to be evaluated at the value of the
covariates listed in {opt at()} and at the mean of all unlisted covariates.

{pmore}
{cmd:at1(}{it:varname}{cmd:=}{it:# ...}{cmd:)},
{cmd:at2(}{it:varname}{cmd:=}{it:# ...}{cmd:)}, ...,
{cmd:at10(}{it:varname}{cmd:=}{it:# ...}{cmd:)} specify that ROC curves
(up to 10) be plotted on the same graph.  {opt at1()}, {opt at2()}, ...,
{opt at10()} work like the {opt at()} option.  They request that the function
be evaluated at the value of the covariates specified and at the mean of
all unlisted covariates.  {opt at1()} specifies the values of the covariates
for the first curve, {opt at2()} specifies the values of the covariates for
the second curve, and so on.

{phang}
{opth roc(numlist)} specifies that estimated ROC values for given
false-positive rates be graphed.

{phang}
{opth invroc(numlist)} specifies that estimated false-positive rates for given
ROC values be graphed.

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for confidence
intervals.  The default is {cmd:level(95)} or as set by {helpb set level}.
{cmd:level()} may be specified with either {cmd:roc()} or {cmd:invroc()}.

{dlgtab:Curve}

{phang}
{cmd:line}{it:#}{cmd:opts(}{it:cline_options}{cmd:)} affects the rendition of
ROC curve {it:#}.  See {manhelpi cline_options G-3}.


{marker options_common}{...}
{title:common_options}

{dlgtab:Main}

{phang}
{opth classvars(varlist)} restricts plotting ROC curves to specified
classification variables.

{phang}
{opt norefline} suppresses plotting the reference line.

{dlgtab:Scatter}

{phang}
{cmd:plot}{it:#}{cmd:opts(}{it:scatter_options}{cmd:)} affects the rendition
of classifier {it:#}'s false-positive rate and ROC scatter points.  This option
applies only to non-ROC covariate estimation graphing.
See {helpb scatter:[G-2] graph twoway scatter}.

{dlgtab:Reference line}

{phang}
{opt rlopts(cline_options)} affects the rendition of the reference line.  See
{manhelpi cline_options G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in
{manhelpi twoway_options G-3}, excluding {opt by()}.
These include options for titling the graph
(see {manhelpi title_options G-3}) and options for saving the graph to disk
(see {manhelpi saving_option G-3}).


{marker options_boot}{...}
{title:boot_options}

{dlgtab:Bootstrap}

{phang}
{opth bfile(filename)} uses bootstrap replicates of parameters from
{cmd:rocreg} stored in {it:filename} to estimate standard errors and confidence
intervals of predictions.  {cmd:bfile()} must be specified with either
{cmd:roc()} or {cmd:invroc()} if parametric estimation with bootstrapping was
used.

{phang}
{cmd:btype(n} | {cmd:p} | {cmd:bc)} 
indicates the desired type of confidence interval rendering. {cmd:n} draws
normal-based, {cmd:p} draws percentile, and {cmd:bc} draws bias-corrected
confidence intervals for specified false-positive rates and ROC values in
{cmd:roc()} and {cmd:invroc()}.  The default is {cmd:btype(n)}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse hanley}{p_end}

{pstd}Fit a smooth ROC curve assuming a binormal model{p_end}
{phang2}{cmd:. rocreg disease rating, probit ml}{p_end}
{phang2}{cmd:. rocregplot}{p_end}

{pstd}Fit a nonparametric ROC curve{p_end}
{phang2}{cmd:. rocreg disease rating, bseed(32)}{p_end}
{phang2}{cmd:. rocregplot}{p_end}

    {hline}
{pstd}Setup of dataset with multiple covariates{p_end}
{phang2}{cmd:. webuse nnhs, clear}{p_end}

{pstd}Fit a binormal ROC curve to data, with control/ROC covariates and
bootstrap inference{p_end}
{phang2}{cmd:. rocreg d y1, ctrlcov(currage male) ctrlmodel(linear)}
    {cmd:roccov(currage) cluster(id) bseed(56930) breps(50) bsave(nnhs2y1)}
    {cmd:probit}{p_end}
{phang2}{cmd:. rocregplot, at1(currage=50) at2(currage=40) at3(currage=30)}
    {cmd:roc(.5) bfile(nnhs2y1)}{p_end}

{pstd}Fit a binormal ROC curve to data, with control/ROC covariates and
maximum likelihood inference{p_end}
{phang2}{cmd:. rocreg d y1, ctrlcov(currage male) ctrlmodel(linear)}
   {cmd:roccov(currage) cluster(id) probit ml}{p_end}
{phang2}{cmd:. rocregplot, at1(currage=50) at2(currage=40) at3(currage=30)}
   {cmd:roc(.5)}{p_end}

    {hline}
