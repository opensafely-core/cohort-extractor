{smcl}
{* *! version 1.0.7  12dec2018}{...}
{viewerdialog fmm "dialog fmm"}{...}
{vieweralsosee "[FMM] fmm" "mansection FMM fmm"}{...}
{vieweralsosee "[FMM] fmm intro" "mansection FMM fmmintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[FMM] fmm estimation" "help fmm_estimation"}{...}
{vieweralsosee "[FMM] fmm postestimation" "help fmm_postestimation"}{...}
{vieweralsosee "[FMM] Glossary" "help fmm_glossary"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy_estimation"}{...}
{viewerjumpto "Syntax" "fmm##syntax"}{...}
{viewerjumpto "Menu" "fmm##menu"}{...}
{viewerjumpto "Description" "fmm##description"}{...}
{viewerjumpto "Links to PDF documentation" "fmm##linkspdf"}{...}
{viewerjumpto "Options" "fmm##options"}{...}
{viewerjumpto "Remarks" "fmm##remarks"}{...}
{viewerjumpto "Examples" "fmm##examples"}{...}
{viewerjumpto "Stored results" "fmm##results"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[FMM] fmm} {hline 2}}Finite mixture models using the fmm prefix
{p_end}
{p2col:}({mansection FMM fmm:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Standard syntax

{p 8 15 2}
{cmd:fmm} {it:#} {ifin}
[{it:{help fmm##weight:weight}}]
[{cmd:,} {it:fmmopts}] {cmd::} {it:component}


{pstd}
Hybrid syntax

{p 8 15 2}
{cmd:fmm} {ifin}
[{it:{help fmm##weight:weight}}]
[{cmd:,} {it:fmmopts}] {cmd::} {cmd:(}{it:component_1}{cmd:)}
                               {cmd:(}{it:component_2}{cmd:)} ...


{pstd}
where the standard syntax for {it:component} is

{pmore}
{it:model}
{depvar}
{indepvars}
[{cmd:,} {it:options}]

{pstd}
the hybrid syntax for {it:component} is

{pmore}
{it:model}
{depvar}
{indepvars}
[{cmd:,} {opth lcprob(varlist)} {it:options}]

{pstd}
{it:{help fmm_estimation:model}} is an estimation command, and
{it:options} are {it:model}-specific estimation options.

INCLUDE help fmm_options_table

{marker pclassname}{...}
INCLUDE help fmm_pclass_table


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > FMM (finite mixture models) > General estimation and regression}


{marker description}{...}
{title:Description}

{pstd}
The {cmd:fmm} prefix fits finite mixture models;
see {manhelp fmm_estimation FMM:fmm estimation} for the list of supported
commands.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection FMM fmmQuickstart:Quick start}

        {mansection FMM fmmRemarksandexamples:Remarks and examples}

        {mansection FMM fmmMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt lcinvariant(pclassname)} specifies which parameters of the
model are constrained to be equal across the latent classes; the default
is {cmd:lcinvariant(none)}.

{marker lcprobopt}{...}
{phang}
{opth lcprob(varlist)} specifies that the linear prediction for a given
latent class probability include the variables in {it:varlist}.
{opt lcinvariant()} has no effect on these parameters.

{pmore}
In the standard syntax, {it:varlist} is used in the linear prediction for
each latent class probability.

{pmore}
In the hybrid syntax, specify {opt lcprob(varlist_i)} in 
{it:component_i} to include {it:varlist_i} in the linear
prediction for the ith latent class probability.
{opt lcprob()} is not allowed to be specified in {it:fmmopts} if it is
being used in one or more {it:component} specifications.

{pmore}
In the hybrid syntax, if you specify {opt lcprob()} in the component
that corresponds with the base latent class, the option is ignored.

{phang}
{opt lclabel(name)} specifies a name for the categorical latent variable;
the default is {cmd:lclabel(Class)}.

{phang}
{opt lcbase(#)} specifies that {it:#} is to be treated as the base
latent class.

{pmore}
In the standard syntax, the default is {cmd:lcbase(1)}.

{pmore}
In the hybrid syntax, the default base is the latent class corresponding
to the first {it:component} that does not have {cmd:lcprob()} specified.
If all components have {cmd:lcprob()}, the first {it:component} is the base
and the {cmd:lcprob()} option specified for the first {it:component} is
ignored.

{phang}
{opt constraints()}; see
{helpb estimation options:[R] Estimation options}.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported,
which includes types that are derived from asymptotic theory ({opt oim}),
that are robust to some kinds of misspecification ({opt robust}),
and that allow for intragroup correlation ({opt cluster} {it:clustvar});
see {manhelpi vce_option R}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options:[R] Estimation options}.

{phang}
{opt nocnsreport} suppresses the display of the constraints.
Fixed-to-zero constraints that are automatically set by {opt fmm} are
not shown in the report to keep the output manageable.

{phang}
{opt noheader} suppresses the header above the parameter table, the
display that reports the final log-likelihood value, number of
observations, etc.

{phang}
{opt nodvheader} suppresses the dependent variables information from the
header above each parameter table.

{phang}
{opt notable} suppresses the parameter tables.

INCLUDE help displayopts_list

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
{opt tol:erance(#)},
{opt ltol:erance(#)},
{opt nrtol:erance(#)} and 
{opt nonrtol:erance}, and
{opt from(init_specs)};
see {helpb maximize:[R] Maximize}.
These options are seldom used.

{marker startvalues}{...}
{phang}
{opt startvalues()} specifies how starting values are to be computed.
Starting values specified in {opt from()} override the computed starting
values.

{phang2}
{cmd:startvalues(factor} [{cmd:,} {it:{help fmm##maxopts:maxopts}}]{cmd:)}
specifies that starting values are computed by assigning each
observation to an initial latent class that is determined by running a
{opt factor} analysis on all the observed variables in the specified
model.  This is the default.

{phang2}
{cmd:startvalues(classid} {varname}[{cmd:,}
{it:{help fmm##maxopts:maxopts}}]{cmd:)}
specifies that starting values are computed by assigning each
observation to an initial latent class specified in {it:varname}.
{it:varname} is required to have each class represented in the
estimation sample.

{phang2}
{cmd:startvalues(classpr} {varlist}[{cmd:,}
{it:{help fmm##maxopts:maxopts}}]{cmd:)}
specifies that starting values are computed using the initial class
probabilities specified in {it:varlist}.  {it:varlist} is required to contain
g variables for a model with g latent classes.  The values in {it:varlist} are
normalized to sum to 1 within each observation.

{phang2}
{cmd:startvalues(randomid} [{cmd:,} {opt draws(#)} {opt seed(#)}
{it:{help fmm##maxopts:maxopts}}]{cmd:)}
specifies that starting values are computed by randomly assigning
observations to initial classes.

{phang2}
{cmd:startvalues(randompr} [{cmd:,} {opt draws(#)} {opt seed(#)}
{it:{help fmm##maxopts:maxopts}}]{cmd:)}
specifies that starting values are computed by randomly assigning
initial class probabilities.

{phang2}
{cmd:startvalues(jitter} [{it:#_c} [{it:#_v}]{cmd:,} {opt draws(#)}
{opt seed(#)} {it:{help fmm##maxopts:maxopts}}]{cmd:)}
specifies that starting values are constructed by randomly perturbing
the values from a Gaussian approximation to each outcome. 

{phang3}
{it:#_c} is the magnitude for randomly perturbing coefficients,
intercepts, cutpoints, and scale parameters; the default value is 1.

{phang3}
{it:#_v} is the magnitude for randomly perturbing variances
for Gaussian outcomes; the default value is 1.

{phang2}
{cmd:startvalues(zero)} specifies that starting values are to be set to 0.
This option is only useful if you use {opt from()} to specify starting values
for some parameters and want the remaining starting values to be 0.

{pmore}
Most starting values options have suboptions that allow for tuning the
starting values calculations:

{marker maxopts}{...}
{phang2}
{it:maxopts} is a subset of the standard {it:maximize_options}:
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
{opt nrtol:erance(#)}; see {helpb maximize:[R] Maximize}.

{phang2}
{opt draws(#)} specifies the number of random draws.
For {cmd:startvalues(randomid)}, {cmd:startvalues(randompr)}, and
{cmd:startvalues(jitter)}, {cmd:fmm} will generate {it:#} random draws and
select the starting values from the draw with the best log-likelihood value
from the EM iterations.  The default is {cmd:draws(1)}.

{phang2}
{opt seed(#)} sets the random-number seed.

{marker emopts}{...}
{phang}
{opth emopts:(fmm##maxopts:maxopts)}
controls maximization of the log likelihood for the EM algorithm.
{it:{help fmm##maxopts:maxopts}}
is the same subset of {it:maximize_options} that
are allowed in the {opt startvalues()} option, but some of the
defaults are different for the EM algorithm.
The default maximum number of iterations is {cmd:iterate(20)}.
The default coefficient vector tolerance is {cmd:tolerance(1e-4)}.
The default log-likelihood tolerance is {cmd:ltolerance(1e-6)}.

{phang}
{cmd:noestimate} specifies that the model is not to be fit.  Instead, 
starting values are to be shown (as modified by the above options
if modifications were made), and they are to be shown using 
the {cmd:coeflegend} style of output.  An important use of this 
option is before you have modified starting values at all; you can 
type the following:

        {cmd:. fmm} ...{cmd:,} ... {cmd:noestimate :} ...
        {cmd:. matrix b = e(b)}
        {cmd:.} ... (modify elements of {cmd:b}) ...
        {cmd:. fmm} ...{cmd:,} ... {cmd:from(b) :} ...

{pstd}
The following options are available with {cmd:fmm} but are not shown in
the dialog box:

{phang}
{opt collinear}; 
see {helpb estimation options:[R] Estimation options}.

{phang}
{cmd:coeflegend}
displays the legend that reveals how to specify estimated coefficients 
in {cmd:_b[]} notation, which you are sometimes required to 
type when specifying postestimation commands. 


{marker remarks}{...}
{title:Remarks}

{pstd}
For a general introduction to finite mixture models, see
{manlink FMM fmm intro}.
For the list of estimation commands supported by the {cmd:fmm} prefix,
see {manhelp fmm_estimation FMM:fmm estimation}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse stamp}{p_end}

{pstd}Mixture of three normal distributions of {cmd:thickness}{p_end}
{phang2}{cmd:. fmm 3: regress thickness}{p_end}

{pstd}Estimated probabilities of membership in the three classes{p_end}
{phang2}{cmd:. estat lcprob}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse mus03sub}{p_end}

{pstd}Mixture of three linear regression models{p_end}
{phang2}{cmd:. fmm 3: regress lmedexp income c.age##c.age totchr i.sex}{p_end}

{pstd}Include {cmd:totchr} as a predictor of class membership{p_end}
{phang2}{cmd:. fmm 3, lcprob(totchr): regress lmedexp income c.age##c.age totchr i.sex}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_mixture}{p_end}

{pstd}Mixture of two Poisson regression models{p_end}
{phang2}{cmd:. fmm 2: poisson drvisits private medicaid c.age##c.age actlim chronic}{p_end}

{pstd}Marginal predicted counts for each class{p_end}
{phang2}{cmd:. estat lcmean}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse fish2}{p_end}

{pstd}Zero-inflated Poisson model as a mixture of a point mass distribution 
at zero and a Poisson regression model{p_end}
{phang2}{cmd:. fmm: (pointmass count) (poisson count persons boat)}{p_end}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:fmm} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt :{cmd:e(N)}}number of observations{p_end}
{synopt :{cmd:e(k)}}number of parameters{p_end}
{synopt :{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt :{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt :{cmd:e(k_cat}{it:#}{cmd:)}}number of categories for the {it:#}th {it:depvar}, ordinal{p_end}
{synopt :{cmd:e(k_out}{it:#}{cmd:)}}number of categories for the {it:#}th {it:depvar}, {cmd:mlogit}{p_end}
{synopt :{cmd:e(ll)}}log likelihood{p_end}
{synopt :{cmd:e(N_clust)}}number of clusters{p_end}
{synopt :{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt :{cmd:e(ic)}}number of iterations{p_end}
{synopt :{cmd:e(rc)}}return code{p_end}
{synopt :{cmd:e(converged)}}{opt 1} if target model converged, {opt 0}
        otherwise{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt :{cmd:e(cmd)}}{opt gsem}{p_end}
{synopt :{cmd:e(cmd2)}}{opt fmm}{p_end}
{synopt :{cmd:e(cmdline)}}command as typed{p_end}
{synopt :{cmd:e(prefix)}}{cmd:fmm}{p_end}
{synopt :{cmd:e(depvar)}}names of dependent variables{p_end}
{synopt:{cmd:e(eqnames)}}names of equations{p_end}
{synopt :{cmd:e(wtype)}}weight type{p_end}
{synopt :{cmd:e(wexp)}}weight expression{p_end}
{synopt :{cmd:e(title)}}title in estimation output{p_end}
{synopt :{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt :{cmd:e(model}{it:#}{cmd:)}}model for the {it:#}th component{p_end}
{synopt :{cmd:e(offset}{it:#}{cmd:)}}offset for the {it:#}th {it:depvar}{p_end}
{synopt :{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt :{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt :{cmd:e(opt)}}type of optimization{p_end}
{synopt :{cmd:e(which)}}{opt max} or {opt min}; whether optimizer is to
perform maximization or minimization{p_end}
{synopt :{cmd:e(method)}}estimation method: {opt ml}{p_end}
{synopt :{cmd:e(ml_method)}}type of {opt ml} method{p_end}
{synopt :{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt :{cmd:e(technique)}}maximization technique{p_end}
{synopt :{cmd:e(properties)}}{opt b V}{p_end}
{synopt :{cmd:e(estat_cmd)}}program used to implement {opt estat}{p_end}
{synopt :{cmd:e(predict)}}program used to implement {opt predict}{p_end}
{synopt :{cmd:e(covariates)}}list of covariates{p_end}
{synopt :{cmd:e(lclass)}}name of latent class variable{p_end}
{synopt :{cmd:e(marginsnotok)}}predictions not allowed by {opt margins}{p_end}
{synopt :{cmd:e(marginsdefault)}}default {opt predict()} specification for
{opt margins}{p_end}
{synopt :{cmd:e(footnote)}}program used to implement the footnote
display{p_end}
{synopt :{cmd:e(asbalanced)}}factor variables {opt fvset} as {opt asbalanced}{p_end}
{synopt :{cmd:e(asobserved)}}factor variables {opt fvset} as {opt asobserved}{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt :{cmd:e(b)}}parameter vector{p_end}
{synopt :{cmd:e(b_pclass)}}parameter class{p_end}
{synopt :{cmd:e(cat}{it:#}{cmd:)}}categories for the {it:#}th {it:depvar}, ordinal{p_end}
{synopt :{cmd:e(out}{it:#}{cmd:)}}outcomes for the {it:#}th {it:depvar}, {cmd:mlogit}{p_end}
{synopt :{cmd:e(Cns)}}constraints matrix{p_end}
{synopt :{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt :{cmd:e(gradient)}}gradient vector{p_end}
{synopt :{cmd:e(V)}}covariance matrix of the estimators{p_end}
{synopt :{cmd:e(V_modelbased)}}model-based variance{p_end}
{synopt :{cmd:e(lclass_k_levels)}}number of levels for latent class
variables{p_end}
{synopt :{cmd:e(lclass_bases)}}base levels for latent class variables{p_end}
{synopt :{cmd:e(_N)}}sample size for each component{p_end}

{p2col 5 20 24 2: Functions}{p_end}
{synopt :{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
