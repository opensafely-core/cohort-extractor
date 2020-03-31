{smcl}
{* *! version 1.1.6  18feb2020}{...}
{viewerdialog "fp plot" "dialog fp_plot"}{...}
{viewerdialog "fp predict" "dialog fp_predict"}{...}
{vieweralsosee "[R] fp postestimation" "mansection R fppostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] fp" "help fp"}{...}
{viewerjumpto "Postestimation commands" "fp postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "fp_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "fp postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "fp postestimation##syntax_margins"}{...}
{viewerjumpto "fp plot and fp predict" "fp postestimation##syntax_predictplot"}{...}
{viewerjumpto "Examples" "fp postestimation##examples"}{...}
{p2colset 1 26 32 2}{...}
{p2col:{bf:[R] fp postestimation} {hline 2}}Postestimation tools for
fp{p_end}
{p2col:}({mansection R fppostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after {cmd:fp}:

{synoptset 16}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb fp postestimation##syntax_predictplot:fp plot}}component-plus-residual plot from most recently fit fractional polynomial model{p_end}
{synopt :{helpb fp postestimation##syntax_predictplot:fp predict}}create variable containing prediction or SEs of fractional polynomials{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available if available
after {it: est_cmd}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_forecast
INCLUDE help post_hausman
INCLUDE help post_lincom
INCLUDE help post_linktest
INCLUDE help post_lrtest
{synopt:{helpb fp_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb fp postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_suest
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R fppostestimationRemarksandexamples:Remarks and examples}

        {mansection R fppostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:predict}

{pstd}
The behavior of {cmd:predict} following {cmd:fp} is determined by
{it:est_cmd}.  See the corresponding {it:est_cmd} postestimation entry for
available {cmd:predict} options.

{pstd}
Also see information on {cmd:fp predict} below.


{marker syntax_margins}{...}
{marker margins}{...}
{title:margins}

{pstd}
The behavior of {cmd:margins} following {cmd:fp} is determined by
{it:est_cmd}.  See the corresponding {it:est_cmd} postestimation entry for
available {cmd:margins} options.


{marker syntax_predictplot}{...}
{title:Syntax for fp plot and fp predict}

{phang}
Component-plus-residual plot for most recently fit fractional polynomial model

{p 8 16 2}
{cmd:fp} {cmd:plot} {ifin}{cmd:,} {opt r:esiduals(res_option)}
[{it:{help fp postestimation##graph_options:graph_options}}]


{phang}
Create variable containing the prediction or SEs of fractional polynomials

{p 8 16 2}
{cmd:fp} {cmd:predict} {dtype} {newvar} {ifin}
[{cmd:,} {it:{help fp postestimation##predict_options:predict_options}}]


{marker graph_options}{...}
{synoptset 27 tabbed}{...}
{synopthdr:graph_options}
{synoptline}
{syntab:Main}
{p2coldent :* {opt r:esiduals(res_option)}}{...}
    residual option name to use in {cmd:predict} after {it:est_cmd}, or
    {cmd:residuals(none)} if residuals are not to be graphed{p_end}
{synopt :{opt eq:uation(eqno)}}{...}
    specify equation{p_end}
{synopt :{opt l:evel(#)}}{...}
    set confidence level; default is {cmd:level(95)}{p_end}

{syntab :Plot}
{synopt :{opth plotop:ts(scatter:scatter_options)}}{...}
    affect rendition of the component-plus-residual scatter points{p_end}

{syntab :Fitted line}
{synopt :{opth lineop:ts(cline_options)}}{...}
    affect rendition of the fitted line{p_end}

{syntab :CI plot}
{synopt :{opth ciop:ts(area_options)}}{...}
    affect rendition of the confidence bands{p_end}

{syntab :Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}{...}
    add other plots to the generated graph{p_end}

{syntab :Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}{...}
    any options other than {opt by()} documented in
    {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p 4 6 2}* {opt residuals(res_option)} is required.{p_end}
{p2colreset}{...}


{marker predict_options}{...}
{synoptset 20 tabbed}{...}
{synopthdr:predict_options}
{synoptline}
{syntab:Main}
{synopt :{opt fp}}{...}
    calculate the fractional polynomial; the default{p_end}
{synopt :{opt stdp}}{...}
    calculate the standard error of the fractional polynomial{p_end}
{synopt :{opt eq:uation(eqno)}}{...}
    specify equation{p_end}
{synoptline}
{p2colreset}{...}


{marker menu_plot_pred}{...}
{title:Menu for fp plot and fp predict}

    {title:fp plot}

{phang2}
{bf:Statistics > Linear models and related > Fractional polynomials >}
      {bf:Component-plus-residual plot}

    {title:fp predict}

{phang2}
{bf:Statistics > Linear models and related > Fractional polynomials >}
       {bf:Fractional polynomial prediction}


{marker des_fp}{...}
{title:Description for fp plot and fp predict}

{pstd}
{cmd:fp plot} produces a component-plus-residual plot.  The fractional
polynomial comprises the component, and the residual is specified by the user
in {opt residuals()}.  The component-plus-residuals are plotted against
the fractional polynomial variable.  If you only want to plot the component fit,
without residuals, you would specify {cmd:residuals(none)}. 

{pstd}
{cmd:fp predict} generates the fractional polynomial or the standard error of
the fractional polynomial.  The fractional polynomial prediction is equivalent
to the fitted values prediction given by {cmd:predict, xb}, with the covariates
other than the fractional polynomial variable set to zero. The standard error
may be quite large if the range of the other covariates is far from zero.  In
this situation, the covariates would be centered and their range would
include, or come close to including, zero.   

{pstd}
These postestimation commands can be used only when the fractional polynomial
variables do not interact with other variables in the specification of
{it:est_cmd}.  See {help fvvarlist} for more information about interactions.


{marker options_fp_plot}{...}
{title:Options for fp plot}

{dlgtab:Main}

{phang}
{opt residuals(res_option)}
    specifies what type of residuals to plot in the component-plus-residual
    plot.  {it:res_option} is the same option that would be specified to
    {cmd:predict} after {it:est_cmd}.  Residuals can be omitted from the plot
    by specifying {cmd:residuals(none)}.  {opt residuals()} is required.

{phang}
{opt equation(eqno)}
    is relevant only when you have previously fit a multiple-equation model in
    {it:est_cmd}.  It specifies the equation to which you are referring.

{pmore}
    {cmd:equation(#1)} would mean that the calculation is to be made for
    the first equation, {cmd:equation(#2)} would mean the second, and so on. 
    You could also refer to the equations by their names: 
    {cmd:equation(income)} would refer to the equation named {cmd:income},
    and {cmd:equation(hours)} would refer to the equation named {cmd:hours}.

{pmore}
    If you do not specify {cmd:equation()}, the results are the same as if you
    specified {cmd:equation(#1)}.

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] Estimation options}.

{dlgtab:Plot}

{phang}
{opt plotopts(scatter_options)} affects the rendition of the
component-plus-residual scatter points; see
{manhelp graph_twoway_scatter G-2:graph twoway scatter}.

{dlgtab:Fitted line}

{phang}
{opt lineopts(cline_options)} affects the rendition of the fitted
line; see {manhelpi cline_options G-3}.

{dlgtab:CI plot}

{phang}
{opt ciopts(area_options)} affects the rendition of the confidence bands; see
{manhelpi area_options G-3}.  

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the
generated graph.  See {manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include options for
titling the graph (see {manhelpi title_options G-3}) and for saving the
graph to disk (see {manhelpi saving_option G-3}).


{marker options_fp_predict}{...}
{title:Options for fp predict}

{dlgtab:Main}

{phang}
{opt fp} calculates the fractional polynomial, the linear prediction with
other variables set to zero.  This is the default.

{phang}
{opt stdp} calculates the standard error of the fractional polynomial.

{phang}
{opt equation(eqno)}
    is relevant only when you have previously fit a multiple-equation model in
    {it:est_cmd}.  It specifies the equation to which you are referring.

{pmore}
    {cmd:equation(#1)} would mean that the calculation is to be made for
    the first equation, {cmd:equation(#2)} would mean the second, and so on. 
    You could also refer to the equations by their names: 
    {cmd:equation(income)} would refer to the equation named {cmd:income},
    and {cmd:equation(hours)} would refer to the equation named {cmd:hours}.

{pmore}
    If you do not specify {cmd:equation()}, the results are the same as if you
    specified {cmd:equation(#1)}.


{marker examples}{...}
{title:Examples}

{phang}Setup{p_end}
{phang2}{cmd:. webuse igg}{p_end}

{phang}Fit the optimal second-degree fractional polynomial regression model
{p_end}
{phang2}{cmd:. fp <age>: regress sqrtigg <age>}{p_end}

{phang}Produce a component-plus-residual plot to evaluate the fit of the model
{p_end}
{phang2}{cmd:. fp plot, r(residuals)}{p_end}

{phang}Predict the standard errors of the fractional polynomial{p_end}
{phang2}{cmd:. fp predict se, stdp}{p_end}
