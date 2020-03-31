{smcl}
{* *! version 1.2.21  12dec2018}{...}
{viewerdialog rocfit "dialog rocfit"}{...}
{vieweralsosee "[R] rocfit" "mansection R rocfit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] rocfit postestimation" "help rocfit postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] roc" "help roc"}{...}
{vieweralsosee "[R] rocreg" "help rocreg"}{...}
{viewerjumpto "Syntax" "rocfit##syntax"}{...}
{viewerjumpto "Menu" "rocfit##menu"}{...}
{viewerjumpto "Description" "rocfit##description"}{...}
{viewerjumpto "Links to PDF documentation" "rocfit##linkspdf"}{...}
{viewerjumpto "Options" "rocfit##options"}{...}
{viewerjumpto "Examples" "rocfit##examples"}{...}
{viewerjumpto "Stored results" "rocfit##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[R] rocfit} {hline 2}}Parametric ROC models{p_end}
{p2col:}({mansection R rocfit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:rocfit}
{it:refvar}
{it:classvar}
{ifin}
[{it:{help rocfit##weight:weight}}]
[{cmd:,} {it:rocfit_options}]

{synoptset 20 tabbed}
{synopthdr:rocfit_options}
{synoptline}
{syntab:Model}
{synopt:{opt cont:inuous(#)}}divide {it:classvar} into {it:#} groups of approximately equal length
{p_end}
{synopt:{opth g:enerate(newvar)}}create {it:newvar} containing classification groups
{p_end}

{syntab:SE}
{synopt:{opth vce(vcetype)}}{it:vcetype} may be {opt oim} or {opt opg}
{p_end}

{syntab:Reporting}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}
{p_end}

{syntab:Maximization}
{synopt:{it:{help rocfit##maximize_options:maximize_options}}}control the
maximization process; seldom used
{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}{cmd:fp} is allowed; see {help prefix}.{p_end}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s are allowed; see {help weight}.
{p_end}
{p 4 6 2}See {manhelp rocfit_postestimation R:rocfit postestimation} for
features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Epidemiology and related > ROC analysis >}
           {bf:Parametric ROC analysis without covariates}


{marker description}{...}
{title:Description}

{pstd}
{opt rocfit} fits maximum-likelihood ROC models assuming a binormal
distribution of the latent variable.

{pstd}
The two variables {it:refvar} and {it:classvar} must be numeric.  The
reference variable indicates the true state of the observation, such as
diseased and nondiseased or normal and abnormal, and must be coded as 0 and 1.
The rating or outcome of the diagnostic test or test modality is recorded in
{it:classvar}, which must be at least ordinal, with higher values indicating
higher risk.

{pstd}
See {manhelp roc R:roc} for other commands designed to perform receiver
operating characteristic (ROC) analyses with rating and discrete
classification data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R rocfitQuickstart:Quick start}

        {mansection R rocfitRemarksandexamples:Remarks and examples}

        {mansection R rocfitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt continuous(#)} specifies that the continuous
{it:classvar} be divided into {it:#} groups of approximately equal length.
The option is required when {it:classvar} takes on more than 20 distinct
values.

{pmore}
{cmd:continuous(.)} may be specified to indicate that {it:classvar}
be used as it is, even though it could have more than 20 distinct values.

{phang}
{opth generate(newvar)} specifies the new
variable that is to contain values indicating the groups produced by
{opt continuous(#)}.  {opt generate()} may be specified only with
{opt continuous()}.

{dlgtab:SE}

INCLUDE help vce_oo

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] Estimation options}.

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}:
{opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)},
[{cmd:no}]{opt log},
{opt tr:ace}, 
{opt grad:ient},
{opt showstep},
{opt hess:ian},
{opt showtol:erance},
{opt tol:erance(#)},
{opt ltol:erance(#)},
{opt nrtol:erance(#)},
{opt nonrtol:erance}, and
{opt from(init_specs)}; see {helpb maximize:[R] Maximize}.
These options are seldom used.

{pmore}
Setting the optimization type to {cmd:technique(bhhh)} resets the default
{it:vcetype} to {cmd:vce(opg)}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse hanley}{p_end}

{pstd}Fit a smooth ROC curve assuming a binormal model{p_end}
{phang2}{cmd:. rocfit disease rating}{p_end}

{pstd}Divide {cmd:rating} into 10 groups{p_end}
{phang2}{cmd:. rocfit disease rating, cont(10)}{p_end}

{pstd}{cmd:group} is to contain values indicating groups produced by
{cmd:cont()}{p_end}
{phang2}{cmd:. rocfit disease rating, cont(10) generate(group)}{p_end}

{pstd}Use {cmd:rating} as is{p_end}
{phang2}{cmd:. rocfit disease rating, cont(.)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:rocfit} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(chi2_gf)}}goodness-of-fit chi-squared{p_end}
{synopt:{cmd:e(df_gf)}}goodness-of-fit degrees of freedom{p_end}
{synopt:{cmd:e(p_gf)}}p-value for goodness-of-fit test{p_end}
{synopt:{cmd:e(area)}}area under the ROC curve{p_end}
{synopt:{cmd:e(se_area)}}standard error for the area under the ROC curve{p_end}
{synopt:{cmd:e(deltam)}}{cmd:delta(m)}{p_end}
{synopt:{cmd:e(se_delm)}}standard area for {cmd:delta(m)}{p_end}
{synopt:{cmd:e(de)}}{cmd:d(e)} index{p_end}
{synopt:{cmd:e(se_de)}}standard error for {cmd:d(e)} index{p_end}
{synopt:{cmd:e(da)}}{cmd:d(a)} index{p_end}
{synopt:{cmd:e(se_da)}}standard error for {cmd:d(a)} index{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:rocfit}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}{it:refvar} and {it:classvar}{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:GOF}; type of model chi-squared test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(opt)}}type of optimization {p_end}
{synopt:{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
                         maximization or minimization{p_end}
{synopt:{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt:{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
