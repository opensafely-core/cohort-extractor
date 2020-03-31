{smcl}
{* *! version 1.1.7  25sep2018}{...}
{viewerdialog "SEM Builder" "stata sembuilder"}{...}
{vieweralsosee "[SEM] sem" "mansection SEM sem"}{...}
{vieweralsosee "[SEM] Intro 1" "mansection SEM Intro1"}{...}
{vieweralsosee "[SEM] Methods and formulas for sem" "mansection SEM Methodsandformulasforsem"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem and gsem path notation" "help sem_and_gsem_path_notation"}{...}
{vieweralsosee "[SEM] sem path notation extensions" "help sem_path_notation_extensions"}{...}
{vieweralsosee "[SEM] sem model description options" "help sem_model_options"}{...}
{vieweralsosee "[SEM] sem group options" "help sem_group_options"}{...}
{vieweralsosee "[SEM] sem ssd options" "help sem_ssd_options"}{...}
{vieweralsosee "[SEM] sem estimation options" "help sem_estimation_options"}{...}
{vieweralsosee "[SEM] sem reporting options" "help sem_reporting_options"}{...}
{vieweralsosee "[SEM] sem and gsem syntax options" "help sem_and_gsem_syntax_options"}{...}
{vieweralsosee "[SEM] sem postestimation" "help sem_postestimation"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{viewerjumpto "Syntax" "sem_command##syntax"}{...}
{viewerjumpto "Menu" "sem_command##menu"}{...}
{viewerjumpto "Description" "sem_command##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_command##linkspdf"}{...}
{viewerjumpto "Options" "sem_command##options"}{...}
{viewerjumpto "Remarks" "sem_command##remarks"}{...}
{viewerjumpto "Examples" "sem_command##examples"}{...}
{viewerjumpto "Stored results" "sem_command##results"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[SEM] sem} {hline 2}}Structural equation model estimation
command{p_end}
{p2col:}({mansection SEM sem:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:sem} {help sem and gsem path notation:{it:paths}} {ifin}
[{it:{help sem_command##weight:weight}}]
[{cmd:,} {it:options}]

{pstd}
where
{it:paths} are the paths of the model in command-language path notation; see
{helpb sem_and gsem path_notation:[SEM] sem and gsem path notation}.{p_end}

{synoptset 30}{...}
{synopthdr:options}
{synoptline}
{synopt :{help sem_model_options:{it:model_description_options}}}fully
define, along with {it:paths}, the model to be fit{p_end}

{synopt :{help sem_group_options:{it:group_options}}}fit model for different groups{p_end}

{synopt :{help sem_ssd_options:{it:ssd_options}}}for use with summary
statistics data{p_end}

{synopt :{help sem_estimation_options:{it:estimation_options}}}method
used to obtain estimation results{p_end}

{synopt :{help sem_reporting_options:{it:reporting_options}}}reporting
of estimation results{p_end}

{synopt :{help sem_and_gsem_syntax_options:{it:syntax_options}}}controlling
interpretation of syntax{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
Time-series operators are allowed.{p_end}
{p 4 6 2}
{cmd:bootstrap}, {cmd:by}, {cmd:jackknife}, {opt permute}, {cmd:statsby}, and {cmd:svy} are allowed; see {help prefix}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}
{opt vce()} and weights are not allowed with the {helpb svy} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s are allowed; 
see {help weight}.{p_end}
{p 4 6 2}
Also see {helpb sem_postestimation:[SEM] sem postestimation} for features
available after estimation.
{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > SEM (structural equation modeling) > Model building and estimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:sem} fits structural equation models.  Even when you use the SEM Builder,
you are using the {cmd:sem} command. 


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM semRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{it:model_description_options}
describe the model to be fit.  The model to be fit is fully specified by
{it:paths} -- which appear immediately after {cmd:sem} -- and the options 
{opt covariance()}, {opt variance()}, and {opt means()}.  See
{helpb sem_model_options:[SEM] sem model description options} and 
{helpb sem_and gsem path_notation:[SEM] sem and gsem path notation}.

{phang}
{it:group_options}
allow the specified model to be fit for different subgroups of the data,
with some parameters free to vary across groups and other parameters
constrained to be equal across groups.  See 
{helpb sem_group_options:[SEM] sem group options}.

{phang}
{it:ssd_options}
allow models to be fit using summary statistics data (SSD),
meaning data on means, variances (standard deviations), and covariances
(correlations).  See {helpb sem_ssd_options:[SEM] sem ssd options}.

{phang}
{it:estimation_options}
control how the estimation results are obtained.  These options control how
the standard errors (VCE) are obtained and control technical issues
such as choice of estimation method.  See 
{helpb sem_estimation_options:[SEM] sem estimation options}.

{phang}
{it:reporting_options}
control how the results of estimation are displayed.  See 
{helpb sem_reporting_options:[SEM] sem reporting options}.

{phang}
{it:syntax_options}
control how the syntax that you type is interpreted.  See 
{helpb sem_and gsem syntax_options:[SEM] sem and gsem syntax options}.


{marker remarks}{...}
{title:Remarks}

{pstd}
For a readable explanation of what {cmd:sem} can do and how to use it, see any
of the intro sections.  You might start with {manlink SEM Intro 1}.

{pstd}
For examples of {cmd:sem} in action, see any of the example sections.
You might start with {findalias semsfmm}.

{pstd}
For detailed syntax and descriptions, see the references below.

{pstd}
See the following advanced topics in {bf:[SEM] sem}:

{phang2}
{mansection SEM semRemarksandexamplesDefaultnormalizationconstraints:Default normalization constraints}{p_end}
{phang2}
{mansection SEM semRemarksandexamplesDefaultcovarianceassumptions:Default covariance assumptions}{p_end}
{phang2}
{mansection SEM semRemarksandexamplesHowtosolveconvergenceproblems:How to solve convergence problems}{p_end}


{marker examples}{...}
{title:Examples}

{pstd}
These examples are intended for quick reference.  For detailed examples, see
{help sem examples:{bf:sem} examples}.


{title:Examples: Correlations}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse census13}{p_end}

{pstd}Use {cmd:correlate} command {p_end}
{phang2}{cmd:. correlate mrgrate dvcrate medage}{p_end}

{pstd}Replicate with {cmd:sem}{p_end}
{phang2}{cmd:. sem ( <- mrgrate dvcrate medage), standardized}{p_end}


{title:Examples: Linear regression}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. generate weight2 = weight^2}{p_end}

{pstd}Use {cmd:regress} command{p_end}
{phang2}{cmd:. regress mpg weight weight2 foreign}{p_end}

{pstd}Replicate model with {cmd:sem}{p_end}
{phang2}{cmd:. sem (mpg <- weight weight2 foreign)}{p_end}


{title:Examples: Single-factor measurement model}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sem_1fmm, clear}{p_end}

{pstd}CFA model with a single latent variable {cmd:X}{p_end}
{phang2}{cmd:. sem (x1 x2 x3 x4 <- X)}{p_end}

{pstd}Display standardized results{p_end}
{phang2}{cmd:. sem, standardized}{p_end}


{title:Examples: Two-factor measurement model}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sem_2fmm}{p_end}

{pstd}CFA model with two latent variables: {cmd:Affective} and {cmd:Cognitive}{p_end}
{phang2}{cmd:. sem (Affective -> a1 a2 a3 a4 a5)}{break}
	{cmd:(Cognitive -> c1 c2 c3 c4 c5)}{p_end}


{title:Examples: Nonrecursive structural model}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sem_sm1}{p_end}

{pstd}Model with a feedback loop{p_end}
{phang2}{cmd:. sem (r_occasp <- f_occasp r_intel r_ses f_ses)}{break}
	{cmd:(f_occasp <- r_occasp f_intel f_ses r_ses),}{break}
	{cmd:cov(e.r_occasp*e.f_occasp)}{p_end}


{title:Examples: MIMIC model}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sem_mimic1}{p_end}

{pstd}MIMIC model{p_end}
{phang2}{cmd:. sem (SubjSES -> s_income s_occpres s_socstat)}{break}
	{cmd:(SubjSES <- income occpres)}{p_end}


{title:Examples: Latent growth model}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sem_lcm}{p_end}

{pstd}Fit latent growth model{p_end}
{phang2}{cmd:. sem (lncrime0 <- Intercept@1 Slope@0) } {break}
	{cmd:(lncrime1 <- Intercept@1 Slope@1)}{break}
	{cmd:(lncrime2 <- Intercept@1 Slope@2)}{break}
	{cmd:(lncrime3 <- Intercept@1 Slope@3),}{break}
	{cmd:means(Intercept Slope) noconstant}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:sem} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(N_groups)}}number of groups{p_end}
{synopt:{cmd:e(N_missing)}}number of missing values in the sample for
{cmd:method(mlmv)}{p_end}
{synopt:{cmd:e(ll)}}log likelihood of model{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(df_b)}}baseline model degrees of freedom{p_end}
{synopt:{cmd:e(df_s)}}saturated model degrees of freedom{p_end}
{synopt:{cmd:e(chi2_ms)}}test of target model against saturated model{p_end}
{synopt:{cmd:e(df_ms)}}degrees of freedom for {cmd:e(chi2_ms)}{p_end}
{synopt:{cmd:e(p_ms)}}p-value for {cmd:e(chi2_ms)}{p_end}
{synopt:{cmd:e(chi2sb_ms)}}Satorra-Bentler scaled test of target model against saturated model{p_end}
{synopt:{cmd:e(psb_ms)}}p-value for {cmd:e(chi2sb_ms)}{p_end}
{synopt:{cmd:e(sbc_ms)}}Satorra-Bentler correction factor for {cmd:e(chi2sb_ms)}{p_end}
{synopt:{cmd:e(chi2_bs)}}test of baseline model against saturated model{p_end}
{synopt:{cmd:e(df_bs)}}degrees of freedom for {cmd:e(chi2_bs)}{p_end}
{synopt:{cmd:e(p_bs)}}p-value for {cmd:e(chi2_bs)}{p_end}
{synopt:{cmd:e(chi2sb_bs)}}Satorra-Bentler scaled test of baseline model against saturated model{p_end}
{synopt:{cmd:e(psb_bs)}}p-value for {cmd:e(chi2sb_bs)}{p_end}
{synopt:{cmd:e(sbc_bs)}}Satorra-Bentler correction factor for {cmd:e(chi2sb_bs)}{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if target model converged, {cmd:0}
	otherwise{p_end}
{synopt:{cmd:e(critvalue)}}log likelihood or discrepancy of fitted
model{p_end}
{synopt:{cmd:e(critvalue_b)}}log likelihood or discrepancy of baseline
model{p_end}
{synopt:{cmd:e(critvalue_s)}}log likelihood or discrepancy of saturated
model{p_end}
{synopt:{cmd:e(modelmeans)}}{cmd:1} if fitting means and intercepts, {cmd:0}
otherwise{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:sem}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(data)}}{cmd:raw} or {cmd:ssd} if SSD data were used{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(method)}}estimation method: {cmd:ml}, {cmd:mlmv},
	or {cmd:adf}{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(lyvars)}}names of latent   y variables{p_end}
{synopt:{cmd:e(oyvars)}}names of observed y variables{p_end}
{synopt:{cmd:e(lxvars)}}names of latent   x variables{p_end}
{synopt:{cmd:e(oxvars)}}names of observed x variables{p_end}
{synopt:{cmd:e(groupvar)}}name of group variable{p_end}
{synopt:{cmd:e(xconditional)}}empty if {cmd:noxconditional} specified,
	{cmd:xconditional} otherwise{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions not allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsdefault)}}default {opt predict()} specification for {cmd:margins}{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}parameter vector{p_end}
{synopt:{cmd:e(b_std)}}standardized parameter vector{p_end}
{synopt:{cmd:e(b_pclass)}}parameter class{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(admissible)}}admissibility of Sigma, Psi, Phi{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(V)}}covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_std)}}standardized covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}
{synopt:{cmd:e(nobs)}}vector with number of observations per group{p_end}
{synopt:{cmd:e(groupvalue)}}vector of group values of {cmd:e(groupvar)}{p_end}

{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks
	estimation sample (not with SSD){p_end}
{p2colreset}{...}
