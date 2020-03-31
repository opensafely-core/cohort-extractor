{smcl}
{* *! version 1.2.8  19jun2019}{...}
{vieweralsosee "[R] mean postestimation" "mansection R meanpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] mean" "help mean"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SVY] estat" "help svy_estat"}{...}
{viewerjumpto "Postestimation commands" "mean postestimation##description"}{...}
{viewerjumpto "estat sd" "mean postestimation##estatsd"}{...}
{viewerjumpto "Example" "mean postestimation##example"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[R] mean postestimation} {hline 2}}Postestimation tools for mean{p_end}
{p2col:}({mansection R meanpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after {cmd:mean}: 

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb mean postestimation##estatsd:estat sd}}standard deviation estimates{p_end}
{synoptline}
{p2colreset}{...}


{pstd}
The following standard postestimation commands are also available:

{synoptset 11}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatvce
INCLUDE help post_svy_estat
INCLUDE help post_estimates
INCLUDE help post_hausman
INCLUDE help post_lincom
{synopt :{helpb marginsplot}}graph the results from mean{p_end}
INCLUDE help post_nlcom
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker estatsd}{...}
{title:Syntax for estat sd}

{p 8 17 2}
{cmd:estat} {opt sd} [{cmd:,} {opt var:iance}]


INCLUDE help menu_estat


{title:Description for estat sd}

{pstd}
{cmd:estat} {cmd:sd} reports standard deviations based on the
estimation results from {cmd:mean}.
{cmd:estat} {cmd:sd} is not appropriate with estimation results that used
direct standardization.

{pstd}
{cmd:estat} {cmd:sd} can also report subpopulation standard deviations
based on estimation results from {cmd:svy: mean}; see
{manhelp estat SVY}.


{marker option_estat_sd}{...}
{title:Option for estat sd}

{phang}
{opt variance} requests that the variance be displayed instead
of the standard deviation.


{marker results}{...}
{title:Stored results for estat sd}

{pstd}
{cmd:estat sd} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(mean)}}vector of mean estimates{p_end}
{synopt:{cmd:r(sd)}}vector of standard deviation estimates{p_end}
{synopt:{cmd:r(variance)}}vector of variance estimates{p_end}


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse fuel}{p_end}
{phang2}{cmd:. mean mpg1 mpg2}{p_end}

{pstd}Test if means are equal (equivalent to a two-sample paired
t-test){p_end}
{phang2}{cmd:. test mpg1 = mpg2}{p_end}
