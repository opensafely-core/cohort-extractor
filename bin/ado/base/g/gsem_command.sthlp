{smcl}
{* *! version 1.2.8  14may2018}{...}
{viewerdialog "SEM Builder" "stata sembuilder"}{...}
{viewerdialog "LCA (latent class analysis)" "dialog lca"}{...}
{vieweralsosee "[SEM] gsem" "mansection SEM gsem"}{...}
{vieweralsosee "[SEM] Intro 1" "mansection SEM Intro1"}{...}
{vieweralsosee "[SEM] Methods and formulas for gsem" "mansection SEM Methodsandformulasforgsem"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem and gsem path notation" "help sem_and_gsem_path_notation"}{...}
{vieweralsosee "[SEM] gsem path notation extensions" "help gsem_path_notation_extensions"}{...}
{vieweralsosee "[SEM] gsem model description options" "help gsem_model_options"}{...}
{vieweralsosee "[SEM] gsem group options" "help gsem_group_options"}{...}
{vieweralsosee "[SEM] gsem lclass options" "help gsem_lclass_options"}{...}
{vieweralsosee "[SEM] gsem estimation options" "help gsem_estimation_options"}{...}
{vieweralsosee "[SEM] gsem reporting options" "help gsem_reporting_options"}{...}
{vieweralsosee "[SEM] sem and gsem syntax options" "help sem_and_gsem_syntax_options"}{...}
{vieweralsosee "[SEM] gsem postestimation" "help gsem_postestimation"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{viewerjumpto "Syntax" "gsem_command##syntax"}{...}
{viewerjumpto "Menu" "gsem_command##menu"}{...}
{viewerjumpto "Description" "gsem_command##description"}{...}
{viewerjumpto "Links to PDF documentation" "gsem_command##linkspdf"}{...}
{viewerjumpto "Options" "gsem_command##options"}{...}
{viewerjumpto "Remarks" "gsem_command##remarks"}{...}
{viewerjumpto "Examples" "gsem_command##examples"}{...}
{viewerjumpto "Stored results" "gsem_command##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[SEM] gsem} {hline 2}}Generalized structural equation model
estimation command{p_end}
{p2col:}({mansection SEM gsem:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:gsem} {help sem and gsem path notation:{it:paths}} {ifin}
[{it:{help gsem_command##weight:weight}}]
[{cmd:,} {it:options}]

{pstd}
where
{it:paths} are the paths of the model in command-language path notation; see
{helpb sem_and gsem path_notation:[SEM] sem and gsem path notation}.{p_end}

{synoptset 30}{...}
{synopthdr:options}
{synoptline}
{synopt :{help gsem_model_options:{it:model_description_options}}}fully
define, along with {it:paths}, the model to be fit{p_end}

{synopt :{help gsem_group_options:{it:group_options}}}fit model for different groups{p_end}

{synopt :{help gsem_lclass_options:{it:lclass_options}}}fit model with latent
classes{p_end}

{synopt :{help gsem_estimation_options:{it:estimation_options}}}method
used to obtain estimation results{p_end}

{synopt :{help gsem_reporting_options:{it:reporting_options}}}reporting
of estimation results{p_end}

{synopt :{help sem and gsem_syntax_options:{it:syntax_options}}}controlling
interpretation of syntax{p_end}
{synoptline}
{p 4 6 2}
Factor variables and time-series operators are allowed.{p_end}
{p 4 6 2}
{cmd:bootstrap}, {cmd:by}, {cmd:jackknife}, {opt permute}, {cmd:statsby},
and {cmd:svy} are allowed; see {help prefix}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}
{opt vce()} and weights are not allowed with the {helpb svy} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s are allowed; 
see {help weight}.{p_end}
{p 4 6 2}
Also see {helpb gsem_postestimation:[SEM] gsem postestimation} for features
available after estimation.
{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > SEM (structural equation modeling) > Model building and estimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:gsem} fits generalized SEMs.  When you use the Builder in {cmd:gsem}
mode, you are using the {cmd:gsem} command. 


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM gsemRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{it:model_description_options}
describe the model to be fit.  The model to be fit is fully specified by
{it:paths} -- which appear immediately after {cmd:gsem} -- and the options 
{opt covariance()}, {opt variance()}, and {opt means()}.  See
{helpb gsem_model_options:[SEM] gsem model description options} and 
{helpb sem and gsem_path_notation:[SEM] sem and gsem path notation}.

{phang}
{it:group_options}
allow the specified model to be fit for different subgroups of the data,
with some parameters free to vary across groups and other parameters
constrained to be equal across groups.  See 
{helpb gsem_group_options:[SEM] gsem group options}.

{phang}
{it:lclass_options}
allow the specified model to be fit across a specified number of latent
classes, with some parameters free to vary across classes and other parameters
constrained to be equal across classes.  See 
{helpb gsem_lclass_options:[SEM] gsem lclass options}.

{phang}
{it:estimation_options}
control how the estimation results are obtained.  These options control how
the standard errors (VCE) are obtained and control technical issues
such as choice of estimation method.  See 
{helpb gsem_estimation_options:[SEM] gsem estimation options}.

{phang}
{it:reporting_options}
control how the results of estimation are displayed.  See 
{helpb gsem_reporting_options:[SEM] gsem reporting options}.

{phang}
{it:syntax_options}
control how the syntax that you type is interpreted.  See 
{helpb sem and gsem_syntax_options:[SEM] sem and gsem syntax options}.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:gsem} provides important features not provided by {cmd:sem} and
correspondingly omits useful features provided by {cmd:sem}.  The differences
in capabilities are the following:

{phang}
1. {cmd:gsem} allows generalized linear response functions as well
          as the linear response functions allowed by {cmd:sem}.

{phang}
2. {cmd:gsem} allows for multilevel models, something {cmd:sem}
          does not.

{phang}
3. {cmd:gsem} allows for categorical latent variables, which are
          not allowed by {cmd:sem}.

{phang}
4. {cmd:gsem} allows Stata's factor-variable notation to be used
          in specifying models, something {cmd:sem} does not.

{phang}
5. {cmd:gsem}'s method ML
          is sometimes able to use more observations in the
          presence of missing values than can {cmd:sem}'s method ML.
          Meanwhile, {cmd:gsem} does not provide the MLMV method
          provided by {cmd:sem} for explicitly handling missing values.

{phang}
6. {cmd:gsem} cannot produce standardized coefficients.

{phang}
7. {cmd:gsem} cannot use summary statistic datasets (SSDs);
          {cmd:sem} can.

{pstd}
{cmd:gsem} has nearly identical syntax to {cmd:sem}.
Differences in syntax arise because of differences in capabilities.
The resulting differences in syntax are the following:

{phang}
1. {cmd:gsem} adds new syntax to paths to handle latent variables
          associated with multilevel modeling.

{phang}
2. {cmd:gsem} adds new options to handle the family and link of
          generalized linear responses.

{phang}
3. {cmd:gsem} adds new syntax to handle categorical latent variables.

{phang}
4. {cmd:gsem} deletes options related to features it does not have,
          such as SSDs.

{phang}
5. {cmd:gsem} adds technical options for controlling
          features not provided by {cmd:sem}, such as numerical integration
          (quadrature choices), number of integration points,
          and a number of options dealing with starting values,
          which are a more difficult proposition in the generalized SEM
          framework.

{pstd}
For a readable explanation of what {cmd:gsem} can do and how to use it, see
the intro sections.  You might start with {manlink SEM Intro 1}.

{pstd}
For examples of {cmd:gsem} in action, see the example sections.  You
might start with {findalias semsfmm}.

{pstd}
See the following advanced topics in {bf:[SEM] gsem}:

{phang2}
{mansection SEM gsemRemarksandexamplesDefaultnormalizationconstraints:Default normalization constraints}{p_end}
{phang2}
{mansection SEM gsemRemarksandexamplesDefaultcovarianceassumptions:Default covariance assumptions}{p_end}
{phang2}
{mansection SEM gsemRemarksandexamplesHowtosolveconvergenceproblems:How to solve convergence problems}{p_end}


{marker examples}{...}
{title:Examples}

{pstd}
These examples are intended for quick reference.  For detailed examples, see
{help sem examples:{bf:sem} examples}.


{title:Examples: Linear regression}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Use {cmd:regress} command{p_end}
{phang2}{cmd:. regress mpg weight c.weight#c.weight foreign}{p_end}

{pstd}Replicate model with {cmd:gsem}{p_end}
{phang2}{cmd:. gsem (mpg <- weight c.weight#c.weight foreign)}{p_end}


{title:Examples: Logistic regression}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_lbw}{p_end}

{pstd}Use {cmd:logit} command{p_end}
{phang2}{cmd:. logit low age lwt i.race smoke ptl ht ui}{p_end}

{pstd}Replicate model with {cmd:gsem}{p_end}
{phang2}{cmd:. gsem (low <- age lwt i.race smoke ptl ht ui), logit}{p_end}


{title:Examples: Poisson regression}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse dollhill3}{p_end}

{pstd}Use {cmd:poisson} command{p_end}
{phang2}{cmd:. poisson deaths smokes i.agecat, exposure(pyears)}{p_end}

{pstd}Replicate model with {cmd:gsem}{p_end}
{phang2}{cmd:. gsem (deaths <- smokes i.agecat), poisson exposure(pyears)}{p_end}


{title:Examples: Single-factor measurement model with binary outcomes}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_1fmm}{p_end}

{pstd}Binary responses modeled using Bernoulli family and probit link{p_end}
{phang2}{cmd:. gsem (x1 x2 x3 x4 <- X), probit}{p_end}


{title:Examples: Full structural equation model with binary and ordinal measurements}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_cfa}{p_end}

{pstd}SEM with latent variable {cmd:MathAb} predicted by latent variable 
{cmd:MathAtt}{p_end}
{phang2}{cmd:. gsem (MathAb -> q1-q8, logit)}{break}
	{cmd:(MathAtt -> att1-att5, ologit)}{break}
	{cmd:(MathAtt -> MathAb)}{p_end}


{title:Examples: Item Response Theory (IRT) models}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_cfa}{p_end}

{pstd}One-parameter logistic IRT model{p_end}
{phang2}{cmd:. gsem (MathAb -> (q1-q8)@b), logit var(MathAb@1)}{p_end}

{pstd}Two-parameter logistic IRT model{p_end}
{phang2}{cmd:. gsem (MathAb -> q1-q8), logit var(MathAb@1)}{p_end}


{title:Examples: Two-level measurement model with binary outcomes}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_cfa}{p_end}

{pstd}Model with latent variable {cmd:Sch[school]} at the school level and 
latent variable{cmd: MathAb} and the student nested in school level{p_end}
{phang2}{cmd:. gsem (MathAb M1[school] -> q1-q8), logit}{p_end}


{title:Examples: Three-level negative binomial model}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_melanoma}{p_end}

{pstd}Model with random intercepts at the nation and the region 
nested in nation levels{p_end}
{phang2}{cmd:. gsem (deaths <- uv M1[nation] M2[nation>region]),}{break}
	{cmd:nbreg exposure(expected)}{p_end}


{title:Examples: Heckman selection model}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_womenwk}{p_end}
{phang2}{cmd:. generate selected = wage < .}{p_end}

{pstd}Selection model for {cmd:wage}{p_end}
{phang2}{cmd:. gsem (wage <- educ age L)}{break} 
        {cmd:(selected <- married children educ age L@1, probit), var(L@1)}{p_end}


{title:Examples: Latent class analysis}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_lca1, clear}{p_end}

{pstd}Model with two classes using logistic regression to model {cmd:accident}, 
{cmd:play}, {cmd:insurance}, and {cmd:stock}{p_end}
{phang2}{cmd:. gsem (accident play insurance stock <- ), logit lclass(C 2)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:gsem} stores the following in {cmd:e()}:

{synoptset 25 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(N_groups)}}number of groups{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_cat}{it:#}{cmd:)}}number of categories for the {it:#}th {it:depvar}, ordinal{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_out}{it:#}{cmd:)}}number of outcomes for the {it:#}th {it:depvar}, mlogit{p_end}
{synopt:{cmd:e(k_rc)}}number of covariances{p_end}
{synopt:{cmd:e(k_rs)}}number of variances{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(n_quad)}}number of integration points{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if target model converged, {cmd:0}
	otherwise{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:gsem}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}names of dependent variables{p_end}
{synopt:{cmd:e(eqnames)}}names of equations{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(fweight}{it:k}{cmd:)}}{cmd:fweight} variable for {it:k}th level, if specified{p_end}
{synopt:{cmd:e(pweight}{it:k}{cmd:)}}{cmd:pweight} variable for {it:k}th level, if specified{p_end}
{synopt:{cmd:e(iweight}{it:k}{cmd:)}}{cmd:iweight} variable for {it:k}th level, if specified{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(family}{it:#}{cmd:)}}family for the {it:#}th {it:depvar}{p_end}
{synopt:{cmd:e(link}{it:#}{cmd:)}}link for the {it:#}th {it:depvar}{p_end}
{synopt:{cmd:e(offset}{it:#}{cmd:)}}offset for the {it:#}th {it:depvar}{p_end}
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
{synopt:{cmd:e(datasignaturevars)}}variables used in calculation of checksum{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(covariates)}}list of covariates{p_end}
{synopt:{cmd:e(footnote)}}program used to implement the footnote display{p_end}
{synopt:{cmd:e(groupvar)}}name of group variable{p_end}
{synopt:{cmd:e(lclass)}}name of latent class variables{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions not allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginswtype)}}weight type for {cmd:margins}{p_end}
{synopt:{cmd:e(marginswexp)}}weight expression for {cmd:margins}{p_end}
{synopt:{cmd:e(marginsdefault)}}default {opt predict()} specification for {cmd:margins}{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(_N)}}sample size for each {it:depvar}{p_end}
{synopt:{cmd:e(b)}}parameter vector{p_end}
{synopt:{cmd:e(b_pclass)}}parameter class{p_end}
{synopt:{cmd:e(cat}{it:#}{cmd:)}}categories for the {it:#}th {it:depvar}, ordinal{p_end}
{synopt:{cmd:e(out}{it:#}{cmd:)}}outcomes for the {it:#}th {it:depvar}, mlogit{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(V)}}covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}
{synopt:{cmd:e(nobs)}}vector with number of observations per group{p_end}
{synopt:{cmd:e(groupvalue)}}vector of group values of {cmd:e(groupvar)}{p_end}
{synopt:{cmd:e(lclass_k_levels)}}number of levels for latent class variables{p_end}
{synopt:{cmd:e(lclass_bases)}}base levels for latent class variables{p_end}

{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
