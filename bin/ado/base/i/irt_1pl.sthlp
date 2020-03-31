{smcl}
{* *! version 1.0.6  24jan2019}{...}
{viewerdialog irt "dialog irt"}{...}
{viewerdialog "svy: irt" "dialog irt, message(-svy-) name(svy_irt)"}{...}
{vieweralsosee "[IRT] irt 1pl" "mansection IRT irt1pl"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[IRT] irt 1pl postestimation" "help irt 1pl postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[IRT] irt" "help irt"}{...}
{vieweralsosee "[IRT] irt 2pl" "help irt 2pl"}{...}
{vieweralsosee "[IRT] irt 3pl" "help irt 3pl"}{...}
{vieweralsosee "[IRT] irt constraints" "help irt constraints"}{...}
{vieweralsosee "" "--"}{...}
{findalias asgsemoirt}
{vieweralsosee "[SEM] gsem" "help gsem_command"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{viewerjumpto "Syntax" "irt 1pl##syntax"}{...}
{viewerjumpto "Menu" "irt 1pl##menu_irt"}{...}
{viewerjumpto "Description" "irt 1pl##description"}{...}
{viewerjumpto "Links to PDF documentation" "irt_1pl##linkspdf"}{...}
{viewerjumpto "Options" "irt 1pl##options"}{...}
{viewerjumpto "Examples" "irt 1pl##examples"}{...}
{viewerjumpto "Video example" "irt 1pl##video"}{...}
{viewerjumpto "Stored results" "irt 1pl##results"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[IRT] irt 1pl} {hline 2}}One-parameter logistic model{p_end}
{p2col:}({mansection IRT irt1pl:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:irt 1pl}
{varlist}
{ifin}
[{help irt 1pl##weight:{it:weight}}]
[{cmd:,} {it:options}]

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
INCLUDE help opt_irt_model

{syntab:SE/Robust}
INCLUDE help opt_irt_vce

{syntab:Reporting}
INCLUDE help opt_irt_report
{synopt :{help irt_1pl##display_options:{it:display_options}}}control
INCLUDE help opt_irt_display

{syntab:Integration}
{synopt :{cmdab:intm:ethod(}{help irt_1pl##intmethod:{it:intmethod}}{cmd:)}}integration method{p_end}
INCLUDE help opt_irt_int

{syntab:Maximization}
{synopt :{it:{help irt_1pl##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt :{cmdab:startv:alues(}{it:{help irt_1pl##startvalues:svmethod}}{cmd:)}}method for obtaining starting values{p_end}
INCLUDE help opt_irt_nodb
{synoptline}
{p2colreset}{...}

INCLUDE help irt_intmethod_table

INCLUDE help irt_syntax_notes
{p 4 6 2}
See {manhelp irt_1pl_postestimation IRT:irt 1pl postestimation} for features
available after estimation.


INCLUDE help menu_irt


{marker description}{...}
{title:Description}

{pstd}
{cmd:irt 1pl} fits one-parameter logistic (1PL) models to binary items.
In the 1PL model, items vary in their difficulty but share the same
discrimination parameter.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection IRT irt1plQuickstart:Quick start}

        {mansection IRT irt1plRemarksandexamples:Remarks and examples}

        {mansection IRT irt1plMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

INCLUDE help irt_model_opts

{dlgtab:SE/Robust}

INCLUDE help irt_vce_opt

{dlgtab:Reporting}

INCLUDE help irt_display_opts

{dlgtab:Integration}

INCLUDE help irt_int_opts

{dlgtab:Maximization}

INCLUDE help irt_max_opts

INCLUDE help irt_nodlg_opts


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse masc1}

{pstd}Fit a 1PL model to binary items {cmd:q1-q9}{p_end}
{phang2}{cmd:. irt 1pl q1-q9}

{pstd}Replay the table of estimated IRT parameters, sorting the output by
parameter instead of by item and in ascending order of difficulty{p_end}
{phang2}{cmd:. estat report, byparm sort(b)}

{pstd}Use the 1PL parameters to plot the item characteristic curves{p_end}
{phang2}{cmd:. irtgraph icc, blocation legend(pos(3) col(1)}
         {cmd:ring(1) size(small)) xlabel(, alt)}

{pstd}Use the 1PL parameters to plot the test characteristic curves{p_end}
{phang2}{cmd:. irtgraph tcc, thetalines(-1.96 0 1.96)}


{marker video}{...}
{title:Video example}

{phang2}{browse "https://www.youtube.com/watch?v=-qsvteo18K4":Item response theory using Stata: One-parameter logistic (1PL) models}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:irt 1pl} stores the following in {cmd:e()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(k_rc)}}number of covariances{p_end}
{synopt:{cmd:e(k_rs)}}number of variances{p_end}
{synopt:{cmd:e(irt_k_eq)}}number of IRT equations{p_end}
{synopt:{cmd:e(k_items1)}}number of items in first IRT equation{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(N_groups)}}number of groups{p_end}
{synopt:{cmd:e(n_quad)}}number of integration points{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if target model converged, {cmd:0}
        otherwise{p_end}

{p2col 5 25 29 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:gsem}{p_end}
{synopt:{cmd:e(cmd2)}}{cmd:irt}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(model1)}}{cmd:1pl}{p_end}
{synopt:{cmd:e(items1)}}names of items in first IRT equation{p_end}
{synopt:{cmd:e(depvar)}}names of all item variables{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(groupvar)}}name of group variable{p_end}
{synopt:{cmd:e(family}{it:#}{cmd:)}}family for the {it:#}th {it:item}{p_end}
{synopt:{cmd:e(link}{it:#}{cmd:)}}link for the {it:#}th {it:item}{p_end}
{synopt:{cmd:e(intmethod)}}integration method{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
maximization or minimization{p_end}
{synopt:{cmd:e(method)}}estimation method: {cmd:ml}{p_end}
{synopt:{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt:{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(datasignature)}}the checksum{p_end}
{synopt:{cmd:e(datasignaturevars)}}variables used in calculation of
checksum{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(covariates)}}list of covariates{p_end}
{synopt:{cmd:e(footnote)}}program used to implement the footnote
display{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(_N)}}sample size for each item{p_end}
{synopt:{cmd:e(b)}}coefficient vector, slope-intercept parameterization{p_end}
{synopt:{cmd:e(b_pclass)}}parameter class{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}
{synopt:{cmd:e(groupvalue)}}vector of group values in {cmd:e(groupvar)}{p_end}
{synopt:{cmd:e(nobs)}}vector with number of observations per group{p_end}

{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
