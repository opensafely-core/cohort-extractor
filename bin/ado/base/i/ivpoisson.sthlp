{smcl}
{* *! version 1.1.7  03feb2020}{...}
{viewerdialog ivpoisson "dialog ivpoisson"}{...}
{vieweralsosee "[R] ivpoisson" "mansection R ivpoisson"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ivpoisson postestimation" "help ivpoisson postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] gmm" "help gmm"}{...}
{vieweralsosee "[R] ivprobit" "help ivprobit"}{...}
{vieweralsosee "[R] ivregress" "help ivregress"}{...}
{vieweralsosee "[R] ivtobit" "help ivtobit"}{...}
{vieweralsosee "[R] nl" "help nl"}{...}
{vieweralsosee "[R] nlsur" "help nlsur"}{...}
{vieweralsosee "[R] poisson" "help poisson"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{viewerjumpto "Syntax" "ivpoisson##syntax"}{...}
{viewerjumpto "Menu" "ivpoisson##menu"}{...}
{viewerjumpto "Description" "ivpoisson##description"}{...}
{viewerjumpto "Links to PDF documentation" "ivpoisson##linkspdf"}{...}
{viewerjumpto "Options" "ivpoisson##options"}{...}
{viewerjumpto "Examples" "ivpoisson##examples"}{...}
{viewerjumpto "Stored results" "ivpoisson##results"}{...}
{viewerjumpto "Reference" "ivpoisson##reference"}{...}
{p2colset 1 18 19 2}{...}
{p2col:{bf:[R] ivpoisson} {hline 2}}Poisson model with continuous endogenous
covariates{p_end}
{p2col:}({mansection R ivpoisson:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Generalized method of moments estimator

{p 8 17 2}
{cmd:ivpoisson} {cmd:gmm} {depvar} [{it:{help varlist:varlist1}}] 
[{cmd:(}{it:{help varlist:varlist2}} {cmd:=}
       {it:{help varlist:varlist_iv}}{cmd:)}] {ifin}
[{it:{help ivpoisson##weight:weight}}]
[{cmd:,} 
{it:{help ivpoisson##reg_err_opt:reg_err_opt}} 
{it:{help ivpoisson##optionstbl:options}}] 


{phang}
Control-function estimator

{p 8 17 2}
{cmd:ivpoisson} {opt cfunc:tion} {depvar} [{it:{help varlist:varlist1}}] 
{cmd:(}{it:{help varlist:varlist2}} {cmd:=}
       {it:{help varlist:varlist_iv}}{cmd:)} {ifin}
[{it:{help ivpoisson##weight:weight}}]
[{cmd:,} {it:{help ivpoisson##optionstbl:options}}] 


{synoptset 28 tabbed}{...}
{marker reg_err_opt}{...}
{synopthdr:reg_err_opt}
{synoptline}
{syntab :Model}
{synopt :{opt add:itive}}add regression errors to the conditional mean
term; the default{p_end}
{synopt :{opt mult:iplicative}}multiply regression errors by the conditional
mean term{p_end}
{synoptline}

{marker optionstbl}{...}
{synopthdr}
{synoptline}
{syntab :Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opth exp:osure(varname:varname_e)}}include ln({it:varname_e}) in
model with coefficient constrained to 1{p_end}
{synopt :{opth off:set(varname:varname_o)}}include {it:varname_o} in model with
coefficient constrained to 1{p_end}
{p2coldent :* {opt two:step}}use two-step GMM estimator; the default for {cmd: ivpoisson gmm}{p_end}
{p2coldent :* {opt one:step}}use one-step GMM estimator; the default for {cmd: ivpoisson cfunction}{p_end}
{p2coldent :* {opt i:gmm}}use iterative GMM estimator{p_end}

{syntab :Weight matrix}
{synopt :{opt wmat:rix}{cmd:(}{it:wmtype}{cmd:)}}specify weight matrix; {it:wmtype} may be {opt r:obust}, {opt cl:uster} {it:clustvar}, or {opt un:adjusted}{p_end}
{synopt :{opt c:enter}}center moments in weight-matrix computation{p_end}
{synopt :{opt winit:ial}{cmd:(}{it:iwtype}[{cmd:, }{opt indep:endent}]{cmd:)}}{p_end}
{synopt :}specify initial weight matrix; {it:iwtype} may be {opt un:adjusted},
{opt i:dentity}, or the name of a Stata matrix  
({opt independent} may not be specified with {opt ivpoisson gmm}){p_end}

{syntab :SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be 
{opt r:obust}, {opt cl:uster} {it:clustvar},
{opt boot:strap}, {opt jack:knife}, or {opt un:adjusted}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt ir:r}}report incidence-rate ratios{p_end}
{synopt :{it:{help ivpoisson##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab :Optimization}
{synopt :{opt from(initial_values)}}specify initial values for parameters{p_end}
{p2coldent :# {opt igmmit:erate(#)}}specify maximum number of iterations for iterated GMM estimator{p_end}
{p2coldent :# {opt igmmeps(#)}}specify # for iterated GMM parameter convergence criterion; default is {cmd:igmmeps(1e-6)}{p_end}
{p2coldent :# {opt igmmweps(#)}}specify # for iterated GMM weight-matrix convergence criterion; default is {cmd:igmmweps(1e-6)}{p_end}
{synopt :{it:{help ivpoisson##optimization_options:optimization_options}}}control the optimization process; seldom used{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}* You can specify at most one of these options.{p_end}
{p 4 6 2}# These options may be specified only when {opt igmm} is specified.{p_end}
{p 4 6 2}{it:varlist1} and {it:varlist_iv} may
contain factor variables; see {help fvvarlist}.{p_end}
{p 4 6 2}{it:depvar}, {it:varlist1}, {it:varlist2}, and {it:varlist_iv} may
contain time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}{cmd:bootstrap}, {cmd:by}, {cmd:jackknife}, {cmd:rolling}, 
and {cmd:statsby} are allowed; see {help prefix}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}{cmd:aweight}s are not allowed with the {helpb jackknife} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}{cmd:aweight}s, {cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s
are allowed; see {help weight}.{p_end}
{p 4 6 2}See {manhelp ivpoisson_postestimation R:ivpoisson postestimation} for
features available after estimation.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Endogenous covariates > Poisson model with endogenous covariates}


{marker description}{...}
{title:Description}

{pstd}
{cmd:ivpoisson} estimates the parameters of a Poisson regression model in
which some of the covariates are endogenous.  The model is also known as an
exponential conditional mean model in which some of the covariates are
endogenous.  The model may be specified using either additive or
multiplicative error terms.  The model is frequently used to model count
outcomes and is also used to model nonnegative outcome variables.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R ivpoissonQuickstart:Quick start}

        {mansection R ivpoissonRemarksandexamples:Remarks and examples}

        {mansection R ivpoissonMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant},
{opth "exposure(varname:varname_e)"},
{opt offset(varname_o)}; see
{helpb estimation options:[R] Estimation options}.

{phang}
{opt additive}, the default, specifies that the regression errors be added
to the conditional mean term and have mean 0.

{phang}
{opt multiplicative} specifies that the regression errors be multiplied
by the conditional mean term and have mean 1.  

{phang}
{opt twostep}, {opt onestep}, and {opt igmm} specify which estimator is 
to be used.

{pmore}
{opt twostep} requests the two-step GMM estimator.  {cmd:gmm} obtains 
parameter estimates based on the initial weight matrix, computes a new 
weight matrix based on those estimates, and then reestimates the parameters 
based on that weight matrix. {opt twostep} is the default for 
{cmd:ivpoisson gmm}.

{pmore}
{opt onestep} requests the one-step GMM estimator.  The parameters are 
estimated based on an initial weight matrix, and no updating of the 
weight matrix is performed except when calculating the appropriate 
variance-covariance (VCE) matrix.  {opt onestep} is the default
for {cmd:ivpoisson cfunction}.

{pmore}
{opt igmm} requests the iterative GMM estimator.  {cmd:gmm} obtains 
parameter estimates based on the initial weight matrix, computes a new 
weight matrix based on those estimates, reestimates the parameters based 
on that weight matrix, computes a new weight matrix, and so on, to convergence.
Convergence is declared when the relative change in the parameter vector is
less than {opt igmmeps()}, the relative change in the weight matrix is less
than {opt igmmweps()}, or {opt igmmiterate()} iterations have been completed.
{help ivpoisson##H2005:Hall (2005, sec. 2.4 and 3.6)} mentions that there may
be gains to finite-sample efficiency from using the iterative estimator.

{dlgtab:Weight matrix}

{marker wmatrix}{...}
{phang}
{opt wmatrix}{cmd:(}{it:wmtype}{cmd:)} 
specifies the type of weight matrix to be used in conjunction with the 
two-step and iterated GMM estimators.

{pmore}
Specifying {cmd:wmatrix(robust)} requests a weight matrix that is 
appropriate when the errors are independent but not necessarily 
identically distributed.  {cmd:wmatrix(robust)} is the default.

{pmore}
Specifying {cmd:wmatrix(cluster} {it:clustvar}{cmd:)} requests a 
weight matrix that accounts for arbitrary correlation among 
observations within clusters identified by {it:clustvar}.

{pmore}
Specifying {cmd:wmatrix(unadjusted)} requests a weight matrix that is 
suitable when the errors are homoskedastic.

{pmore}
{opt wmatrix()} cannot be specified if {cmd:onestep} is also specified.

{phang}
{opt center} requests that the sample moments be centered (demeaned) 
when computing GMM weight matrices.  By default, centering is not done.

{phang}
{opt winitial}{cmd:(}{it:wmtype}[{cmd:,} {opt independent}]{cmd:)} 
specifies the weight matrix to use to obtain the first-step parameter
estimates.

{pmore}
Specifying {cmd:winitial(unadjusted)} requests a weighting matrix that assumes
the error functions are independent and identically distributed.  This matrix
is of the form ({bf:Z}'{bf:Z})^-1, where {bf:Z} represents all the exogenous
and instrumental variables.

{pmore}
{cmd:winitial(identity)} requests that the identity matrix be used.

{pmore}
{opt winitial(matname)} requests that Stata matrix {it:matname} be used.  

{pmore}
Including the {opt independent} suboption creates a weight matrix that 
assumes error functions are independent.  Elements of the weight matrix 
corresponding to covariances between any two error functions are set equal 
to zero.  This suboption only applies to {opt ivpoisson cfunction}.

{pmore}
{cmd:winitial(unadjusted)} is the default for {cmd:ivpoisson gmm}.

{pmore}
{cmd:winitial(unadjusted, independent)} is the default for {cmd:ivpoisson cfunction}.

{dlgtab:SE/Robust}

{marker vcetype}{...}
{phang}
{cmd:vce(}{it:vcetype}{cmd:)} specifies the type of standard error reported,
which includes types that are robust to some kinds of misspecification
({cmd:robust}), that allow for intragroup correlation ({cmd:cluster}
{it:clustvar}), and that use bootstrap or jackknife methods
({cmd:bootstrap}, {cmd:jackknife}); see {helpb vce_option:[R] {it:vce_option}}.

{pmore}
{cmd:vce(unadjusted)} specifies that an unadjusted (nonrobust) VCE 
matrix be used; this, along with the {opt twostep} option, results in the 
"optimal two-step GMM" estimates often discussed in textbooks.
{cmd:vce(unadjusted)} may not be set in {cmd:ivpoisson cfunction}.

{pmore}
The default {it:vcetype} is based on the {it:wmtype} specified in the 
{opt wmatrix()} option.  If {opt wmatrix()} is specified 
but {opt vce()} is not, then {it:vcetype} is set equal to {it:wmtype}.  
To override this behavior in {cmd: ivpoisson gmm} and obtain an unadjusted
(nonrobust) VCE matrix, specify {cmd:vce(unadjusted)}.  The default
{it:vcetype} for {cmd:ivpoisson cfunction} is {cmd:robust}.

{pmore}
Specifying {cmd:vce(bootstrap)} or {cmd:vce(jackknife)} results in
standard errors based on the bootstrap or jackknife, respectively.  See
{manhelpi vce_option R}, {manhelp bootstrap R}, and {manhelp jackknife R} for
more information on these VCEs.

{pmore}
The syntax for {it:vcetype}s is identical to those for {cmd:wmatrix()}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

{phang}
{opt irr} reports estimated coefficients transformed to incidence-rate ratios,
that is, exp(b) rather than b.  Standard errors and confidence intervals are
similarly transformed.  This option affects how results are displayed, not how
they are estimated or stored.  {opt irr} may be specified at estimation or when
replaying previously estimated results.  {opt irr} is not allowed with 
{opt additive}.

{marker display_options}{...}
INCLUDE help displayopts_list

{dlgtab:Optimization}

{phang}
{opt from(initial_values)} specifies the initial values to begin the
estimation.  You can specify a 1 x k matrix, where k is the number of
parameters in the model, or you can specify a parameter name, its initial
value, another parameter name, its initial value, and so on.  For example, to
initialize the coefficient for {opt male} to 1.23 and the constant {opt _cons}
to 4.57, you would type

{pmore2}
{cmd:ivpoisson} ...{cmd:,} {cmd:from(male 1.23 _cons 4.57)} ...

{pmore}
Initial values declared using this option override any that are declared
within substitutable expressions.  If you specify a parameter that does not
appear in your model, {cmd:ivpoisson} exits with error code 480.  If you
specify a matrix, the values must be in the same order in which the parameters
are declared in your model.  {cmd:ivpoisson} ignores the row and column names
of the matrix.

{phang}
{opt igmmiterate(#)}, {opt igmmeps(#)}, and
{opt igmmweps(#)} control the iterative process for the
iterative GMM estimator for {cmd:ivpoisson}.  These options can be specified
only if you also specify {cmd:igmm}.

{phang2}
{opt igmmiterate(#)} specifies the maximum number of iterations to 
perform with the iterative GMM estimator.  The default is the number set 
using {helpb set maxiter}, which is
INCLUDE help maxiter
by default.

{phang2}
{opt igmmeps(#)} specifies the convergence criterion used for successive
parameter estimates when the iterative GMM estimator is used.
The default is {cmd:igmmeps(1e-6)}.  Convergence is declared when the 
relative difference between successive parameter estimates is less than 
{cmd:igmmeps()} and the relative difference between successive estimates of 
the weight matrix is less than {cmd:igmmweps()}.

{phang2}
{opt igmmweps(#)} specifies the convergence criterion used for successive 
estimates of the weight matrix when the iterative GMM estimator
is used.  The default is {cmd:igmmweps(1e-6)}.  Convergence is declared when
the relative difference between successive parameter estimates is less than
{cmd:igmmeps()} and the relative difference between successive estimates of the
weight matrix is less than {cmd:igmmweps()}.

{marker optimization_options}{...}
{phang}
{it:optimization_options}: {opt tech:nique()}, 
{opt conv_maxiter()}, {opt conv_ptol()}, {opt conv_vtol()}, 
{opt conv_nrtol()}, and {opt tracelevel()}.  {opt technique()} specifies 
the optimization technique to use; {cmd:gn} (the default), {cmd:nr}, {cmd:dfp}, 
and {cmd:bfgs} are allowed.  {opt conv_maxiter()} 
specifies the maximum number of iterations; {opt conv_ptol()}, 
{opt conv_vtol()}, and {opt conv_nrtol()} specify the convergence 
criteria for the parameters, gradient, and scaled Hessian, 
respectively.  {opt tracelevel()} allows you to obtain additional 
details during the iterative process.
See {helpb mf_optimize:[M-5] optimize()}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse website}{p_end}

{pstd}Generalized method of moments: additive errors{p_end}
{phang2}{cmd:. ivpoisson gmm visits ad female} 
	{cmd:(time = phone frfam)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse trip}{p_end}

{pstd}Generalized method of moments: multiplicative errors{p_end}
{phang2}{cmd:. ivpoisson gmm trips cbd ptn worker weekend}
	{cmd: (tcost=pt), multiplicative}{p_end}

{pstd}Display incidence-rate ratios{p_end}
{phang2}{cmd:. ivpoisson, irr}{p_end}

{pstd}Control-function method{p_end}
{phang2}{cmd:. ivpoisson cfunction trips cbd ptn worker weekend}
	{cmd: (tcost=pt)}{p_end}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:ivpoisson} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations{p_end}
{synopt:{cmd:e(k_aux)}}number of auxiliary parameters{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(Q)}}criterion function{p_end}
{synopt:{cmd:e(J)}}Hansen {it:J} chi-squared statistic{p_end}
{synopt:{cmd:e(J_df)}}{it:J} statistic degrees of freedom{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations used by iterative GMM estimator{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:ivpoisson}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}dependent variable of regression{p_end}
{synopt:{cmd:e(instd)}}instrumented variable{p_end}
{synopt:{cmd:e(insts)}}instruments{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset1)}}offset variable for first equation{p_end}
{synopt:{cmd:e(winit)}}initial weight matrix used{p_end}
{synopt:{cmd:e(winitname)}}name of user-supplied initial weight matrix{p_end}
{synopt:{cmd:e(estimator)}}{cmd:gmm} or {cmd:cfunction}{p_end}
{synopt:{cmd:e(additive)}}{cmd:additive} if additive errors specified{p_end}
{synopt:{cmd:e(multiplicative)}}{cmd:multiplicative} if multiplicative errors specified{p_end}
{synopt:{cmd:e(gmmestimator)}}{opt onestep}, {opt twostep}, or {opt igmm}{p_end}
{synopt:{cmd:e(wmatrix)}}{it:wmtype} specified in {opt wmatrix()}{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {opt vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(technique)}}optimization technique{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(footnote)}}program used to implement footnote display{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix{p_end}
{synopt:{cmd:e(init)}}initial values of the estimators{p_end}
{synopt:{cmd:e(Wuser)}}user-supplied initial weight matrix{p_end}
{synopt:{cmd:e(W)}}weight matrix used for final round of estimation{p_end}
{synopt:{cmd:e(S)}}moment covariance matrix used in robust VCE computations{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}


{marker reference}{...}
{title:Reference}

{marker H2005}{...}
{phang}
Hall, A. R. 2005.
{it:Generalized Method of Moments}.
Oxford: Oxford University Press.
{p_end}
