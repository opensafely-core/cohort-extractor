{smcl}
{* *! version 1.1.16  19oct2012}{...}
{viewerdialog fracplot "dialog fracplot"}{...}
{viewerdialog fracpred "dialog fracpred"}{...}
{vieweralsosee "help prdocumented" "help prdocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] fracpoly" "help fracpoly"}{...}
{viewerjumpto "Description" "fracpoly postestimation##description"}{...}
{viewerjumpto "Special-interest postestimation commands" "fracpoly postestimation##special"}{...}
{viewerjumpto "Syntax for predict" "fracpoly postestimation##syntax_predict"}{...}
{viewerjumpto "Syntax for fracplot and fracpred" "fracpoly postestimation##syntax_fracplot_fracpred"}{...}
{viewerjumpto "Menu for fracplot and fracpred" "fracpoly postestimation##menu_fracplot_fracpred"}{...}
{viewerjumpto "Options for fracplot" "fracpoly postestimation##options_fracplot"}{...}
{viewerjumpto "Options for fracpred" "fracpoly postestimation##options_fracpred"}{...}
{viewerjumpto "Examples" "fracpoly postestimation##examples"}{...}
{pstd}
{cmd:fracpoly} has been superseded by {helpb fp}.  {cmd:fracpoly}
continues to work but, as of Stata 13, is no longer an official part of Stata.
This is the original help file, which we will no longer update, so some links
may no longer work.

{hline}

{title:Title}

{p2colset 5 36 38 2}{...}
{p2col :{bf:[R] fracpoly postestimation} {hline 2}}Postestimation tools for
fracpoly{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The following postestimation commands are of special interest after {opt fracpoly}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb fracpoly postestimation##fracplot/fracpred:fracplot}}plot data and fit from most recently fit fractional polynomial model{p_end}
{synopt :{helpb fracpoly postestimation##fracplot/fracpred:fracpred}}create variable containing prediction, deviance residuals, or SEs of fitted values{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available if 
available after {it:regression_cmd}:

{synoptset 17}{...}
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
{synopt :{helpb fracpoly postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker special}{...}
{title:Special-interest postestimation commands}

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


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{pstd}
The behavior of {cmd:predict} following {opt fracpoly} is determined by
{it:regression_cmd}.  See the corresponding
{it:regression_cmd} {bf:postestimation} entry for available {opt predict}
options.

{pstd}
Also see information on {cmd:fracpred} below.


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
{it:{help fracpoly postestimation##fracplot_options:fracplot_options}}]
{p_end}


{phang}
Create variable containing the prediction, deviance residuals, or SEs of fitted values

{p 8 17 2}
{cmd:fracpred}
{newvar}
[{cmd:,}
{it:{help fracpoly postestimation##fracpred_options:fracpred_options}}]
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
{opt fracplot} is not allowed after {helpb fracpoly} or {helpb mfp} with
{opt clogit}, {opt mlogit}, or {opt stcrreg}.  {opt fracpred, dresid} is not
allowed after {opt fracpoly} or {cmd:mfp} with {opt clogit}, {opt mlogit},
or {cmd:stcrreg}.
{p_end}


{marker menu_fracplot_fracpred}{...}
{title:Menu for fracplot and fracpred}

    {title:fracplot}

{phang2}
{bf:Statistics > Linear models and related > Fractional polynomials >}
      {bf:Fractional polynomial regression plot}

    {title:fracpred}

{phang2}
{bf:Statistics > Linear models and related > Fractional polynomials >}
       {bf:Fractional polynomial prediction}


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
value specified by the {opt center()} option in {opt fracpoly}.

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
{phang2}{cmd:. fracpoly: logit foreign mpg displ weight, compare degree(1)}{p_end}

{pstd}Plot fitted values against {cmd:mpg}{p_end}
{phang2}{cmd:. fracplot}{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:. fracpoly: regress mpg weight -2 displ -1}{p_end}

{pstd}Predict fitted index for {cmd:weight}{p_end}
{phang2}{cmd:. fracpred wfit, for(weight)}{p_end}

{pstd}Predict fitted index for {cmd:displ}{p_end}
{phang2}{cmd:. fracpred dfit, for(displ)}{p_end}

{pstd}Predict deviance residuals{p_end}
{phang2}{cmd:. fracpred dr, dresid}{p_end}
