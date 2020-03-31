{smcl}
{* *! version 1.3.6  12dec2018}{...}
{viewerdialog cnsreg "dialog cnsreg"}{...}
{viewerdialog "svy: cnsreg" "dialog cnsreg, message(-svy-) name(svy_cnsreg)"}{...}
{vieweralsosee "[R] cnsreg" "mansection R cnsreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] cnsreg postestimation" "help cnsreg postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Estimation" "help mi estimation"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy_estimation"}{...}
{viewerjumpto "Syntax" "cnsreg##syntax"}{...}
{viewerjumpto "Menu" "cnsreg##menu"}{...}
{viewerjumpto "Description" "cnsreg##description"}{...}
{viewerjumpto "Links to PDF documentation" "cnsreg##linkspdf"}{...}
{viewerjumpto "Options" "cnsreg##options"}{...}
{viewerjumpto "Examples" "cnsreg##examples"}{...}
{viewerjumpto "Stored results" "cnsreg##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[R] cnsreg} {hline 2}}Constrained linear regression{p_end}
{p2col:}({mansection R cnsreg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:cnsreg}
{depvar}
{indepvars}
{ifin}
[{it:{help cnsreg##weight:weight}}]
{cmd:,}
{opth c:onstraints(estimation options##constraints():constraints)}
[{it:options}]

{synoptset 28 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Model}
{p2coldent :* {cmdab:c:onstraints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}
{synopt :{opt nocons:tant}}suppress constant term{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt ols}, 
{opt r:obust}, {opt cl:uster} {it:clustvar}, {opt boot:strap}, or
{opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help cnsreg##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{synopt :{opt ms:e1}}force MSE to be 1{p_end}
{synopt :{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt constraints(constraints)} is required.{p_end}
INCLUDE help fvvarlist
{p 4 6 2}
{it:depvar} and {it:indepvars} may contain time-series operators; see
{help tsvarlist}.{p_end}
{p 4 6 2}
{opt bootstrap}, {opt by}, {opt fp}, {opt jackknife}, {opt mi estimate},
{opt rolling}, {opt statsby}, and {opt svy} are allowed; see {help prefix}.
{p_end}
INCLUDE help vce_mi
{p 4 6 2}With the {helpb fp} prefix, constraints cannot be specified for the
variable containing fractional polynomial terms.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}{cmd:aweight}s are not allowed with the {helpb jackknife} prefix.
{p_end}
{p 4 6 2}
{opt vce()}, {opt mse1}, and weights are not allowed with the {helpb svy} prefix.{p_end}
{marker weight}{...}
{p 4 6 2}
{opt aweight}s, {opt fweight}s, {opt iweight}s, and {opt pweight}s are allowed;
see {help weight}.{p_end}
{p 4 6 2}
{opt mse1}, {opt collinear}, and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp cnsreg_postestimation R:cnsreg postestimation} for features
available after estimation.  {p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Linear models and related > Constrained linear regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:cnsreg} fits constrained linear regression models.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R cnsregQuickstart:Quick start}

        {mansection R cnsregRemarksandexamples:Remarks and examples}

        {mansection R cnsregMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt constraints(constraints)}, {opt noconstant}; see
{helpb estimation options:[R] Estimation options}.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are derived from asymptotic theory ({cmd:ols}),
that are robust to some kinds of misspecification ({cmd:robust}), that allow
for intragroup correlation ({cmd:cluster} {it:clustvar}), and that use
bootstrap or jackknife methods ({cmd:bootstrap}, {cmd:jackknife}); see
{helpb vce_option:[R] {it:vce_option}}.

{pmore}
{cmd:vce(ols)}, the default, uses the standard variance estimator for ordinary
least-squares regression.

{dlgtab:Reporting}

{phang}
{opt level(#)}, {opt nocnsreport}; see
     {helpb estimation options:[R] Estimation options}.

INCLUDE help displayopts_list

{pstd}
The following options are available with {cmd:cnsreg} but are not shown in the
dialog box:

{phang}
{opt mse1} is used only in programs and ado-files that use {cmd:cnsreg} to
fit models other than constrained linear regression.  {opt mse1} sets the mean
squared error to 1, thus forcing the variance-covariance matrix of the
estimators to be (X'DX)^-1 (see
{it:{mansection R regressMethodsandformulas:Methods and formulas}} in 
{hi:[R] regress}) and affecting calculated standard errors.
Degrees of freedom for t statistics are calculated as n rather than
n-p+c, where p is the total number of parameters (prior to restrictions and
including the constant) and c is the number of constraints.

{pmore}
{opt mse1} is not allowed with the {helpb svy} prefix.

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Constrain coefficients of {cmd:price} and {cmd:weight} to be equal{p_end}
{phang2}{cmd:. constraint 1 price = weight}{p_end}

{pstd}Fit constrained linear regression{p_end}
{phang2}{cmd:. cnsreg mpg price weight, constraints(1)}{p_end}

{pstd}Define more constraints{p_end}
{phang2}{cmd:. constraint 2 displ = weight}{p_end}
{phang2}{cmd:. constraint 3 gear_ratio = -foreign}{p_end}

{pstd}Fit constrained linear regression, applying all three constraints{p_end}
{phang2}{cmd:. cnsreg mpg price weight displ gear_ratio foreign length, c(1-3)}
{p_end}

{pstd}Constrain constant to be zero{p_end}
{phang2}{cmd:. constraint 99 _cons = 0}{p_end}

{pstd}Fit constrained linear regression, applying all four constraints{p_end}
{phang2}{cmd:. cnsreg mpg price weight displ gear_ratio foreign length, c(1-3,99)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:cnsreg} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(F)}}F statistic{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(rmse)}}root mean squared error{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:cnsreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
