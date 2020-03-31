{smcl}
{* *! version 1.2.4  19oct2017}{...}
{viewerdialog fracplot "dialog fracplot"}{...}
{viewerdialog fracpred "dialog fracpred"}{...}
{vieweralsosee "[R] mfp postestimation" "mansection R mfppostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] mfp" "help mfp"}{...}
{viewerjumpto "Postestimation commands" "mfp postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "mfp_postestimation##linkspdf"}{...}
{viewerjumpto "fracplot and fracpred" "mfp postestimation##syntax_fracplot_fracpred"}{...}
{viewerjumpto "Examples" "mfp postestimation##examples"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[R] mfp postestimation} {hline 2}}Postestimation tools for mfp{p_end}
{p2col:}({mansection R mfppostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after {cmd:mfp}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb mfp postestimation##fracplot/fracpred:fracplot}}plot data and fit from most recently fit fractional polynomial model{p_end}
{synopt :{helpb mfp postestimation##fracplot/fracpred:fracpred}}create variable containing prediction, deviance residuals, or SEs of fitted values{p_end}
{synoptline}

{pstd}
The following standard postestimation commands are also available if
available after {it:regression_cmd}:

{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_lincom
INCLUDE help post_linktest
INCLUDE help post_lrtest
INCLUDE help post_nlcom
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R mfppostestimationRemarksandexamples:Remarks and examples}

        {mansection R mfppostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_fracplot_fracpred}{...}
{marker fracplot/fracpred}{...}
{title:Syntax for fracplot and fracpred}

{phang}
Plot data and fit from most recently fit fractional polynomial model

{p 8 17 2}
{cmd:fracplot}
[{varname}]
{ifin}
[{cmd:,}
{it:{help mfp postestimation##fracplot_options:fracplot_options}}]
{p_end}


{phang}
Create variable containing the prediction, deviance residuals, or SEs of fitted values

{p 8 17 2}
{cmd:fracpred}
{newvar}
[{cmd:,}
{it:{help mfp postestimation##fracpred_options:fracpred_options}}]
{p_end}


{synoptset 25 tabbed}{...}
{marker fracplot_options}{...}
{synopthdr :fracplot_options}
{synoptline}
{syntab :Plot}
INCLUDE help gr_markopt2

{syntab :Fitted line}
{synopt :{opth lineop:ts(cline_options)}}affect rendition of the fitted
line{p_end}

{syntab :CI plot}
{synopt :{opth ciop:ts(area_options)}}affect rendition of the confidence
bands{p_end}

{syntab :Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated graph{p_end}

{syntab :Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {opt by()} documented in
    {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 25}{...}
{marker fracpred_options}{...}
{synopthdr :fracpred_options}
{synoptline}
{synopt :{opth f:or(varname)}}compute prediction for {it:varname}{p_end}
{synopt :{opt d:resid}}compute deviance residuals{p_end}
{synopt :{opt s:tdp}}compute standard errors of the fitted values
{varname}{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
{opt fracplot} is not allowed after {helpb mfp} with
{opt clogit}, {opt mlogit}, or {opt stcrreg}.  {opt fracpred, dresid} is not
allowed after {cmd:mfp} with {opt clogit}, {opt mlogit}, or {cmd:stcrreg}.
{p_end}


{marker menu_fracplot_fracpred}{...}
{title:Menu for fracplot and fracpred}

    {title:fracplot}

{phang2}
{bf:Statistics > Linear models and related > Fractional polynomials >}
      {bf:Multivariable fractional polynomial plot}

    {title:fracpred}

{phang2}
{bf:Statistics > Linear models and related > Fractional polynomials >}
       {bf:Multivariable fractional polynomial prediction}


{marker des_frac}{...}
{title:Description for fracplot and fracpred}

{pstd}
{opt fracplot} plots the data and fit, with 95% confidence limits, from
the most recently fit fractional polynomial model.  The data and fit are
plotted against {varname}, which may be {it:xvar1} or another of the
covariates ({it:xvar2}, ..., or a variable from {it:xvarlist}).  If
{it:varname} is not specified, {it:xvar1} is assumed.

{pstd}
{opt fracpred} creates {it:newvar} containing the fitted index or
deviance residuals for the whole model, or the fitted index or its standard
error for {it:varname}, which may be {it:xvar1} or another covariate.


{marker options_fracplot}{...}
{title:Options for fracplot}

{dlgtab:Plot}

INCLUDE help gr_markoptf

{dlgtab:Fitted line}

{phang}
{opt lineopts(cline_options)} affect the rendition of the fitted
line; see {manhelpi cline_options G-3}.

{dlgtab:CI plot}

{phang}
{opt ciopts(area_options)} affect the rendition of the confidence bands; see
{manhelpi area_options G-3}.  

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the
generated graph. See {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include options for
titling the graph (see {manhelpi title_options G-3}) and for saving the
graph to disk (see {manhelpi saving_option G-3}).


{marker options_fracpred}{...}
{title:Options for fracpred}

{phang}
{opth for(varname)} specifies (partial)
prediction for variable {it:varname}.  The fitted values are adjusted to the
value specified by the {opt center()} option in {opt mfp}.

{phang}
{opt dresid} specifies that deviance residuals be calculated.

{phang}
{opt stdp} specifies calculation of the standard errors of the fitted
values {varname}, adjusted for all the other predictors at the values
specified by {opt center()}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. mfp: regress mpg weight displacement foreign}{p_end}

{pstd}Plot data and fit against {cmd:displacement}{p_end}
{phang2}{cmd:. fracplot displacement}{p_end}

{pstd}Create new variable {cmd:dfit} containing partial prediction for
{cmd:displacement}{p_end}
{phang2}{cmd:. fracpred dfit, for(displacement)}{p_end}
