{smcl}
{* *! version 1.0.0  14may2019}{...}
{viewerdialog irt "dialog irt"}{...}
{viewerdialog "svy: irt" "dialog irt, message(-svy-) name(svy_irt)"}{...}
{vieweralsosee "[IRT] irt, group()" "mansection IRT irt,group()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[IRT] irt, group() postestimation" "help irt group postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[IRT] DIF" "help dif"}{...}
{vieweralsosee "[IRT] irt" "help irt"}{...}
{vieweralsosee "[IRT] irt constraints" "help irt constraints"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] gsem" "help gsem_command"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{viewerjumpto "Syntax" "irt group##syntax"}{...}
{viewerjumpto "Menu" "irt group##menu_irt"}{...}
{viewerjumpto "Description" "irt group##description"}{...}
{viewerjumpto "Links to PDF documentation" "irt_group##linkspdf"}{...}
{viewerjumpto "Options" "irt group##options"}{...}
{viewerjumpto "Examples" "irt group##examples"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[IRT] irt, group()} {hline 2}}IRT models for multiple groups{p_end}
{p2col:}({mansection IRT irt,group():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Single-equation syntax

{p 8 15 2}
{cmd:irt} {it:model} {varlist} ...{cmd:,} {opth group(varname)}
	[{help irt_group##options_tbl:{it:options}}]


{pstd}
Multiple-equation syntax

{p 8 15 2}
{cmd:irt} {cmd:(}[{it:#}{cmd::}] {it:model}
      {help varlist:{it:varlist_1}}
     [{cmd:,} {help irt_group##mopts_list:{it:mopts}}]{cmd:)}
         {cmd:(}[{it:#}{cmd::}] {it:model}
      {help varlist:{it:varlist_2}}
     [{cmd:,} {help irt_group##mopts_list:{it:mopts}}]{cmd:)} ...{cmd:,}
         {opth group(varname)}
	[{help irt_group##options_tbl:{it:options}}]


{phang}
{it:#}{cmd::} specifies the group for which {it:model} is to be fit.

{synoptset 16}{...}
{synopthdr:model}
{synoptline}
{synopt :{helpb irt 1pl:1pl}}One-parameter logistic model{p_end}
{synopt :{helpb irt 2pl:2pl}}Two-parameter logistic model{p_end}
{synopt :{helpb irt 3pl:3pl}}Three-parameter logistic model{p_end}
{synopt :{helpb irt grm:grm}}Graded response model{p_end}
{synopt :{helpb irt pcm:pcm}}Partial credit model{p_end}
{synopt :{helpb irt pcm:gpcm}}Generalized partial credit model{p_end}
{synopt :{helpb irt rsm:rsm}}Rating scale model{p_end}
{synopt :{helpb irt nrm:nrm}}Nominal response model{p_end}
{synoptline}
{p2colreset}{...}

{marker options_tbl}{...}
{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opth group(varname)}}fit model for different groups{p_end}

{syntab:Model}
{p2coldent :* {opth cns:(irt_constraints##syntax:spec)}}apply specified parameter constraints{p_end}
{synopt:{opt list:wise}}drop observations with any missing items{p_end}
{p2coldent :* {opt sepg:uessing}}estimate a separate pseudoguessing parameter for each item{p_end}
{p2coldent :* {opt gsepg:uessing}}estimate separate pseudoguessing parameters for each group{p_end}

{syntab:SE/Robust}
INCLUDE help opt_irt_vce

{syntab:Reporting}
INCLUDE help opt_irt_report
{synopt :{help irt_group##display_options:{it:display_options}}}control
INCLUDE help opt_irt_display

{syntab:Integration}
{synopt :{cmdab:intm:ethod(}{help irt_group##intmethod:{it:intmethod}}{cmd:)}}integration method{p_end}
INCLUDE help opt_irt_int

{syntab:Maximization}
{synopt :{it:{help irt_group##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt :{cmdab:startv:alues(}{it:{help irt_group##startvalues:svmethod}}{cmd:)}}method for obtaining starting values{p_end}
INCLUDE help opt_irt_nodb
{synoptline}
{p2colreset}{...}
{marker mopts_list}{...}
{p 4 6 2}
* {it:mopts} are {cmd:cns()}, {cmd:sepguessing}, and {cmd:gsepguessing}.{p_end}

INCLUDE help irt_intmethod_table

{p 4 6 2}
See {manhelp irt_group_postestimation IRT:irt, group() postestimation} for
features available after estimation.


INCLUDE help menu_irt


{marker description}{...}
{title:Description}

{pstd}
Multiple-group IRT models are combined models across groups of the data.  They
allow some parameters to vary across groups and constrain others to be equal.
The groups could be males and females, age categories, and the like.

{pstd}
The {cmd:irt} commands fit multiple-group IRT models when the 
{opth group(varname)} option is specified.  


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection IRT irthybridQuickstart:Quick start}

        {mansection IRT irthybridRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{marker group_option}{...}
{phang}
{opth group(varname)} specifies that the model parameters be allowed to vary
across values of {it:varname}. {it:varname} might be sex, and then parameters
may vary for males and females, or {it:varname} might be something else and
perhaps take on more than two values.  Whatever {it:varname} is,
{opt group(varname)} defaults to constraining all item coefficients to be
equal across groups in each model specified without a group identifier.  The
mean and the variance of the latent trait are constrained to 0 and 1,
respectively, for the group corresponding to the smallest value of
{it:varname} (reference group) and estimated for the remaining groups (focal
groups).

{dlgtab:Model}

{marker cns_option}{...}
{phang}
{opt cns(spec)}
	constrains item parameters to a fixed value or
	constrains two or more parameters to be equal;
	see {manhelp irt_constraints IRT:irt constraints} for details.

{phang}
{cmd:listwise} handles missing values through listwise deletion, which means
that the entire observation is omitted from the estimation sample if any
of the items are missing for that observation.
By default, all nonmissing items in an observation are included in the
likelihood calculation; only missing items are excluded.

{phang}
{cmd:sepguessing} specifies that a separate pseudoguessing parameter be
estimated for each item.  This option is allowed only with a {cmd:3pl} model;
see {manhelp irt_3pl IRT:irt 3pl} for details.

{phang}
{cmd:gsepguessing} specifies that separate pseudoguessing parameters be
estimated for each group.  This option is allowed only with a {cmd:3pl} model.

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
{phang2}{cmd:. webuse masc2}

{pstd}Fit a two-group 2PL model{p_end}
{phang2}{cmd:. irt 2pl q1-q5, group(female)}

{pstd}Fit a two-group 2PL model with separate discrimination and difficulty parameters for item {cmd:q4} for each group{p_end}
{phang2}{cmd:. irt (0: 2pl q4) (1: 2pl q4) (2pl q1 q2 q3 q5), group(female)}
{p_end}
