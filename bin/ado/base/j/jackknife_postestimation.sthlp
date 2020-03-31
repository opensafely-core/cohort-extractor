{smcl}
{* *! version 1.2.4  19oct2017}{...}
{vieweralsosee "[R] jackknife postestimation" "mansection R jackknifepostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] jackknife" "help jackknife"}{...}
{viewerjumpto "Postestimation commands" "jackknife postestimation##description"}{...}
{viewerjumpto "predict" "jackknife postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "jackknife postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "jackknife postestimation##examples"}{...}
{p2colset 1 33 35 2}{...}
{p2col:{bf:[R] jackknife postestimation} {hline 2}}Postestimation tools for
jackknife{p_end}
{p2col:}({mansection R jackknifepostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {opt jackknife}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_hausman
INCLUDE help post_lincom
{synopt:{helpb jackknife postestimation##margins:margins}}marginal means, predictive margins, marginal
                effects, and average marginal effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt:{helpb jackknife postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
{synopt:{helpb predictnl}}point estimates, standard errors, testing, and inference for nonlinear combinations of coefficients{p_end}
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}The postestimation command is allowed only if it may be used after {it:command}.{p_end}


{marker syntax_predict}{...}
{marker predict}{...}
{title:predict}

{pstd}
The syntax of {opt predict} (and whether {opt predict} is even allowed)
following {opt jackknife} depends on the {it:command} used with
{opt jackknife}.{p_end}


{marker syntax_margins}{...}
{marker margins}{...}
{title:margins}

{pstd}
The syntax of {opt margins} (and whether {opt margins} is even allowed)
following {opt jackknife} depends on the {it:command} used with
{opt jackknife}.{p_end}


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse regress}{p_end}
{phang2}{cmd:. jackknife: regress y x1 x2 x3}

{pstd}Estimate linear combination of coefficients{p_end}
{phang2}{cmd:. lincom x2-x1}

{pstd}Test that coefficients of {cmd:x1} and {cmd:x3} are both zero{p_end}
{phang2}{cmd:. test x1 x3}{p_end}
