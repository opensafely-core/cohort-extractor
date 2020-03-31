{smcl}
{* *! version 1.2.4  19oct2017}{...}
{viewerdialog estat "dialog estat_bootstrap"}{...}
{vieweralsosee "[R] bootstrap postestimation" "mansection R bootstrappostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] bootstrap" "help bootstrap"}{...}
{viewerjumpto "Postestimation commands" "bootstrap postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "bootstrap_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "bootstrap postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "bootstrap postestimation##syntax_margins"}{...}
{viewerjumpto "estat" "bootstrap postestimation##syntax_estat_bootstrap"}{...}
{viewerjumpto "Examples" "bootstrap postestimation##examples"}{...}
{p2colset 1 33 35 2}{...}
{p2col:{bf:[R] bootstrap postestimation} {hline 2}}Postestimation tools for
bootstrap{p_end}
{p2col:}({mansection R bootstrappostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation command is of special interest after {cmd:bootstrap}:

{synoptset 20}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb bootstrap postestimation##estatbootstrap:estat bootstrap}}percentile-based 
	and bias-corrected CI tables{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 20}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_hausman
INCLUDE help post_lincom
{synopt:{helpb bootstrap_postestimation##margins:margins}}marginal means, predictive margins, marginal effects, and average marginal effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt:{helpb bootstrap postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}The postestimation command is allowed if it may be used after {it:command}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R bootstrappostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:predict}

{pstd}
The syntax of {cmd:predict} (and even if {cmd:predict} is allowed) following
{cmd:bootstrap} depends upon the {it:command} used with {cmd:bootstrap}.
If {cmd:predict} is not allowed, neither is {cmd:predictnl}.


{marker syntax_margins}{...}
{marker margins}{...}
{title:margins}

{pstd}
The syntax of {cmd:margins} (and even if {cmd:margins} is allowed) following
{cmd:bootstrap} depends upon the {it:command} used with {cmd:bootstrap}.


{marker syntax_estat_bootstrap}{...}
{marker estatbootstrap}{...}
{title:Syntax for estat}

{p 8 14 2}
{cmd:estat} {cmdab:boot:strap} [{cmd:,} {it:options}]

{synoptset 20}{...}
{synopthdr}
{synoptline}
{synopt :{opt bc}}bias-corrected CIs; the default{p_end}
{synopt :{opt bca}}bias-corrected and accelerated (BC_a) CIs{p_end}
{synopt :{opt nor:mal}}normal-based CIs{p_end}
{synopt :{opt p:ercentile}}percentile CIs{p_end}
{synopt :{opt all}}all available CIs{p_end}
{synopt :{opt nohead:er}}suppress table header{p_end}
{synopt :{opt noleg:end}}suppress table legend{p_end}
{synopt :{opt v:erbose}}display the full table legend{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}{opt bc}, {opt bca}, {opt normal}, and {opt percentile} may be used
together.


INCLUDE help menu_estat


{marker des_estat}{...}
{title:Description for estat}

{pstd}
{cmd:estat bootstrap} displays a table of confidence intervals for each
statistic from a bootstrap analysis.


{marker options_estat_bootstrap}{...}
{title:Options for estat bootstrap}

{phang}
{opt bc} is the default and displays bias-corrected confidence intervals.

{phang}
{opt bca} displays bias-corrected and accelerated confidence intervals.  
This option assumes that you also specified the {cmd:bca} option on the 
{cmd:bootstrap} prefix command.

{phang}
{opt normal} displays normal approximation confidence intervals.

{phang}
{opt percentile} displays percentile confidence intervals.

{phang}
{opt all} displays all available confidence intervals.

{phang}
{opt noheader} suppresses display of the table header.  This option implies
{opt nolegend}.

{phang}
{opt nolegend} suppresses display of the table legend, which identifies the
rows of the table with the expressions they represent.

{phang}
{opt verbose} requests that the full table legend be displayed.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. bootstrap, reps(100) bca: regress mpg weight gear foreign}{p_end}

{pstd}Obtain bias-corrected CIs{p_end}
{phang2}{cmd:. estat bootstrap}

{pstd}Obtain bias-corrected and accelerated CIs{p_end}
{phang2}{cmd:. estat bootstrap, bca}

{pstd}Obtain all available CIs{p_end}
{phang2}{cmd:. estat bootstrap, all}

{pstd}Test that coefficients on {cmd:gear} and {cmd:foreign} sum to 0{p_end}
{phang2}{cmd:. test gear + foreign = 0}

{pstd}Compute estimate, SE, test statistic, significance level, and CI for the
ratio of coefficient of {cmd:gear_ratio} to the coefficient of {cmd:foreign}
{p_end}
{phang2}{cmd:. nlcom _b[gear_ratio] / _b[foreign]}{p_end}
