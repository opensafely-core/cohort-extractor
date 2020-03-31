{smcl}
{* *! version 1.2.5  19oct2017}{...}
{vieweralsosee "[SVY] svy postestimation" "mansection SVY svypostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SVY] svy" "help svy"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SVY] estat" "help svy_estat"}{...}
{vieweralsosee "[SVY] svy bootstrap" "help svy_bootstrap"}{...}
{vieweralsosee "[SVY] svy brr" "help svy_brr"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy_estimation"}{...}
{vieweralsosee "[SVY] svy jackknife" "help svy_jackknife"}{...}
{vieweralsosee "[SVY] svy sdr" "help svy_sdr"}{...}
{viewerjumpto "Postestimation commands" "svy postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "svy_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "svy postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "svy postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "svy postestimation##examples"}{...}
{p2colset 1 29 33 2}{...}
{p2col:{bf:[SVY] svy postestimation} {hline 2}}Postestimation
tools for svy{p_end}
{p2col:}({mansection SVY svypostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:svy}:

{synoptset 13}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_svy_estat
INCLUDE help post_estimates
INCLUDE help post_lincom
{synopt:{helpb svy_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb svy_postestimation##predict:predict}}predictions,
	residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_suest
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SVY svypostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker predict}{...}
{marker syntax_predict}{...}
{title:predict after svy}

{pstd}
The syntax of {helpb predict} (and even if {cmd:predict} is allowed) after 
{cmd:svy} depends on the command used with {cmd:svy}.
Specifically, {cmd:predict} is not allowed after {cmd:svy: mean},
{cmd:svy: proportion}, {cmd:svy: ratio}, {cmd:svy: tabulate}, or
{cmd:svy: total}.


{marker margins}{...}
{marker syntax_margins}{...}
{title:margins after svy}

{pstd}
The syntax of {helpb margins} (and even if {cmd:margins} is allowed) after 
{cmd:svy} depends on the command used with {cmd:svy}.
Specifically, {cmd:margins} is not allowed after {cmd:svy: mean},
{cmd:svy: proportion}, {cmd:svy: ratio}, {cmd:svy: tabulate}, or
{cmd:svy: total}.


{marker examples}{...}
{title:Example 1: Linear and nonlinear combinations}

{phang}
{cmd:. webuse nhanes2}
{p_end}
{phang}
{cmd:. generate male = (sex == 1)}
{p_end}
{phang}
{cmd:. svy, subpop(male): mean zinc, over(race)}
{p_end}
{phang}
{cmd:. lincom [zinc]White - [zinc]Black}
{p_end}


{title:Example 2: Quadratic terms}

{phang}
{cmd:. webuse nhanes2d, clear}
{p_end}
{phang}
{cmd:. svy: logistic highbp height weight age age2 female}
{p_end}
{phang}
{cmd:. nlcom peak: -_b[age]/(2*_b[age2])}
{p_end}
{phang}
{cmd:. testnl -_b[age]/(2*_b[age2]) = 70}
{p_end}


{title:Example 3: Predictive margins}

{phang}
{cmd:. webuse nhanes2d}
{p_end}
{phang}
{cmd:. svyset}
{p_end}
{phang}
{cmd:. svy: logistic highbp height weight age c.age#c.age i.female i.race,}
     {cmd:baselevels}
{p_end}
{phang}
{cmd:. margins race, vce(unconditional)}
{p_end}
{phang}
{cmd:. margins, vce(unconditional) dydx(race)}
{p_end}
{phang}
{cmd:. margins, vce(unconditional) dydx(race) over(region)}
{p_end}


{title:Example 4: Nonlinear predictions and their standard errors}

{phang}
{cmd:. webuse nhanes2d}
{p_end}
{phang}
{cmd:. svy: regress loglead age age2 i.female i.race i.region}
{p_end}
{phang}
{cmd:. predictnl leadhat = exp(xb()), se(leadhat_se)}
{p_end}
{phang}
{cmd:. list lead leadhat leadhat_se age age2 in 1/10, abbrev(10)}
{p_end}


{title:Example 5: Multiple-hypothesis testing}

{phang}
{cmd:. test 2.region 3.region 4.region}
{p_end}
{phang}
{cmd:. test 2.region 3.region 4.region, nosvyadjust}
{p_end}
{phang}
{cmd:. test 2.region 3.region 4.region, mtest(bonferroni)}
{p_end}


{title:Example 6: Using suest with survey data}

{phang}
{cmd:. webuse nhanes2f, clear}
{p_end}
{phang}
{cmd:. svyset psuid [pw=finalwgt], strata(stratid)}
{p_end}
{phang}
{cmd:. svy: ologit health female black age age2}
{p_end}
{phang}
{cmd:. estimates store H5}
{p_end}
{phang}
{cmd:. gen health3 = clip(health, 2, 4)}
{p_end}
{phang}
{cmd:. svy: ologit health3 female black age age2}
{p_end}
{phang}
{cmd:. estimates store H3}
{p_end}
{phang}
{cmd:. suest H5 H3}
{p_end}
{phang}
{cmd:. test [H5_health=H3_health3]}
{p_end}
{phang}
{cmd:. test (/H5:cut2=/H3:cut1) (/H5:cut3=/H3:cut2)}
{p_end}
