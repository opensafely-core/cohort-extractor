{smcl}
{* *! version 1.1.9  23jan2019}{...}
{vieweralsosee "[R] total postestimation" "mansection R totalpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] total" "help total"}{...}
{viewerjumpto "Postestimation commands" "total postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "total_postestimation##linkspdf"}{...}
{viewerjumpto "Examples" "total postestimation##examples"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[R] total postestimation} {hline 2}}Postestimation tools for total{p_end}
{p2col:}({mansection R totalpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {opt total}:

{synoptset 13}{...}
{synopt:Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatvce
INCLUDE help post_svy_estat
INCLUDE help post_estimates
INCLUDE help post_lincom
{synopt :{helpb marginsplot}}graph the results from total{p_end}
INCLUDE help post_nlcom
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R totalpostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse total}{p_end}
{phang2}{cmd:. total heartatk [pw=swgt], over(sex)}{p_end}

{pstd}Show covariance matrix of coefficients{p_end}
{phang2}{cmd:. estat vce}

{pstd}Estimate the difference in the number of heart attacks among women
versus men in the population{p_end}
{phang2}{cmd:. contrast r.sex#c.heartatk}{p_end}
