{smcl}
{* *! version 1.0.4  14may2018}{...}
{viewerdialog "SEM Builder" "stata sembuilder"}{...}
{vieweralsosee "[SEM] gsem group options" "mansection SEM gsemgroupoptions"}{...}
{vieweralsosee "[SEM] Intro 6" "mansection SEM Intro6"}{...}
{findalias asgsemgrp}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] gsem" "help gsem_command"}{...}
{viewerjumpto "Syntax" "gsem_group_options##syntax"}{...}
{viewerjumpto "Description" "gsem_group_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "gsem_group_options##linkspdf"}{...}
{viewerjumpto "Options" "gsem_group_options##options"}{...}
{viewerjumpto "Remarks" "gsem_group_options##remarks"}{...}
{viewerjumpto "Examples" "gsem_group_options##examples"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[SEM] gsem group options} {hline 2}}Fitting models on different
groups{p_end}
{p2col:}({mansection SEM gsemgroupoptions:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:gsem} {it:paths} ...{cmd:,} ... {it:group_options}

{synoptset 24}{...}
{synopthdr:group_options}
{synoptline}
{synopt :{opth group(varname)}}fit model for different groups{p_end}
{synopt :{opt gin:variant(pclassname)}}specify parameters that are equal across groups{p_end}
{synoptline}

{marker pclassname}{...}
{synoptset 24}{...}
{p2col:{it:pclassname}}Description{p_end}
{p2line}
{p2col:{opt cons}}intercepts and cutpoints{p_end}

{p2col:{opt coef}}fixed coefficients{p_end}
{p2col:{opt load:ing}}latent variable coefficients{p_end}

{p2col:{opt errv:ar}}covariances of errors{p_end}
{p2col:{opt scale}}scaling parameters{p_end}

{p2col:{opt mean:s}}means of exogenous variables{p_end}
{p2col:{opt cov:ex}}covariances of exogenous latent variables{p_end}
{p2line}
{p2col:{opt all}}all the above{p_end}
{p2col:{opt none}}none of the above{p_end}
{p2line}
{p2colreset}{...}
{p 4 6 2}
{cmd:ginvariant(cons coef loading)} is the default if {opt ginvariant()} is not
specified.  {p_end}


{marker description}{...}
{title:Description}

{pstd}
{cmd:gsem} can fit combined models across subgroups of the data while allowing
some parameters to vary and constraining others to be equal across subgroups.
These subgroups could be males and females, age category, and the like.

{pstd}
{cmd:gsem} performs such estimation when the {opth group(varname)} option is
specified.  The {opt ginvariant(pclassname)} option specifies which parameters
are to be constrained to be equal across the groups.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM gsemgroupoptionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opth group(varname)}
specifies that the model be fit as described above.  {it:varname}
specifies the name of a numeric variable that records the group to which
the observation belongs.

{phang}
{opth ginvariant:(gsem_group_options##pclassname:pclassname)}
specifies which classes of parameters of the model are to be constrained to be
equal across groups.  The classes are defined above.  The default is 
{cmd:ginvariant(cons coef loading)} if the option is not specified.


{marker remarks}{...}
{title:Remarks}

{pstd}
See {manlink SEM Intro 6} and {findalias gsemgrp}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_cancer}{p_end}

{pstd}Stratified Weibull model{p_end}
{phang2}{cmd:. gsem (studytime <- age, family(weibull, failure(died))),}{break}
	{cmd: group(drug) ginvariant(coef)}{p_end}

{pstd}Specify coefficients and intercepts to be equal across groups{p_end}
{phang2}{cmd:. gsem (studytime <- age, family(weibull, failure(died))),}{break}
	{cmd: group(drug) ginvariant(coef cons)}{p_end}
