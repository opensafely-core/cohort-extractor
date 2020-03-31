{smcl}
{* *! version 1.2.10  18feb2020}{...}
{viewerdialog reg3 "dialog reg3"}{...}
{vieweralsosee "[R] reg3" "mansection R reg3"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] reg3 postestimation" "help reg3 postestimation"}{...}
{vieweralsosee "" "--"}{...}
{findalias assemnrsm}{...}
{vieweralsosee "[TS] forecast" "help forecast"}{...}
{vieweralsosee "[SEM] Intro 5" "mansection SEM Intro5"}{...}
{vieweralsosee "[R] ivregress" "help ivregress"}{...}
{vieweralsosee "[MV] mvreg" "help mvreg"}{...}
{vieweralsosee "[R] nlsur" "help nlsur"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[R] sureg" "help sureg"}{...}
{viewerjumpto "Syntax" "reg3##syntax"}{...}
{viewerjumpto "Menu" "reg3##menu"}{...}
{viewerjumpto "Description" "reg3##description"}{...}
{viewerjumpto "Links to PDF documentation" "reg3##linkspdf"}{...}
{viewerjumpto "Nomenclature" "reg3##nomenclature"}{...}
{viewerjumpto "Options" "reg3##options"}{...}
{viewerjumpto "Examples" "reg3##examples"}{...}
{viewerjumpto "Stored results" "reg3##results"}{...}
{viewerjumpto "Reference" "reg3##reference"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[R] reg3} {hline 2}}Three-stage estimation for systems of
simultaneous equations{p_end}
{p2col:}({mansection R reg3:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Basic syntax

{p 8 14 2}
{cmd:reg3} {cmd:(}{depvar:1} {varlist:1}{cmd:)}
{cmd:(}{depvar:2} {varlist:2}{cmd:)} {it:...}{cmd:(}{depvar:N}
{varlist:N}{cmd:)} {ifin}
[{it:{help reg3##weight:weight}}]


{phang}
Full syntax

{p 8 14 2}
{cmd:reg3} {cmd:(}[{it:eqname1}{cmd::}]{depvar:1a}
	[{depvar:1b} {it:...}{cmd:=}]{varlist:1} 
        [{cmd:,} {opt nocons:tant}]{cmd:)}{break}
        {cmd:(}[{it:eqname2}{cmd::}]{depvar:2a}
	[{depvar:2b} {it:...}{cmd:=}]{varlist:2} 
        [{cmd:,} {opt nocons:tant}]{cmd:)}{break}
        {it:...}{break}
        {cmd:(}[{it:eqnameN}{cmd::}]{depvar:Na}
	[{depvar:Nb} {it:...}{cmd:=}]{varlist:N} 
        [{cmd:,} {opt nocons:tant}]{cmd:)}{break}
        {ifin} 
        [{it:{help reg3##weight:weight}}]
	[{cmd:,} {it:{help reg3##options_table:options}}]{p_end}


{marker options_table}{...}
{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt ir:eg3}}iterate until estimates converge{p_end}
{synopt :{cmdab:c:onstraints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}

{syntab:Model 2}
{synopt :{opth ex:og(varlist)}}exogenous variables not specified in system
equations{p_end}
{synopt :{opth en:dog(varlist)}}additional right-hand-side endogenous variables{p_end}
{synopt :{opth in:st(varlist)}}full list of exogenous variables{p_end}
{synopt :{opt a:llexog}}all right-hand-side variables are exogenous{p_end}
{synopt :{opt nocons:tant}}suppress constant from instrument list{p_end}

{syntab:Est. method}
{synopt :{opt 3sls}}three-stage least squares; the default{p_end}
{synopt :{opt 2sls}}two-stage least squares{p_end}
{synopt :{opt o:ls}}ordinary least squares (OLS){p_end}
{synopt :{opt su:re}}seemingly unrelated regression estimation (SURE){p_end}
{synopt :{opt m:vreg}}{cmd:sure} with OLS degrees-of-freedom adjustment{p_end}
{synopt :{opt cor:r(correlation)}}{opt u:nstructured} or {opt i:ndependent}
correlation structure; default is {opt unstructured}{p_end}

{syntab:df adj.}
{synopt :{opt sm:all}}report small-sample statistics{p_end}
{synopt :{opt dfk}}use small-sample adjustment{p_end}
{synopt :{opt dfk2}}use alternate adjustment{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}
{synopt :{opt f:irst}}report first-stage regression{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help reg3##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Optimization}
{synopt :{it:{help reg3##optimization_options:optimization_options}}}control
the optimization process; seldom used{p_end}

{synopt :{opt noh:eader}}suppress display of header{p_end}
{synopt :{opt not:able}}suppress display of coefficient table{p_end}
{synopt :{opt nofo:oter}}suppress display of footer{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}{it:varlist1}, ..., {it:varlistN} and the {cmd:exog()} and the
{cmd:inst()} varlist may
contain factor variables; see {help fvvarlist}.  You must have the same levels
of factor variables in all equations that have factor variables.{p_end}
{p 4 6 2}{it:depvar} and {it:varlist} may contain time-series operators; see
{help tsvarlist}.{p_end}
{p 4 6 2}{cmd:bootstrap}, {cmd:by}, {cmd:fp}, {cmd:jackknife}, {cmd:rolling},
and {cmd:statsby} are allowed; see {help prefix}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}{cmd:aweight}s are not allowed with the {helpb jackknife} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}{cmd:aweight}s and {cmd:fweight}s are allowed, see 
{help weight}.{p_end}
{p 4 6 2}{opt noheader}, {opt notable}, {opt nofooter}, and {opt coeflegend}
do not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp reg3_postestimation R:reg3 postestimation} for features
available after estimation.{p_end}

{pstd}
Explicit equation naming ({it:eqname}{cmd::}) cannot be combined with
multiple dependent variables in an equation specification.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Endogenous covariates > Three-stage least squares}


{marker description}{...}
{title:Description}

{pstd}
{cmd:reg3} estimates a system of structural equations, where some equations
contain endogenous variables among the explanatory variables.  Estimation is
via three-stage least squares (3SLS); see
{help reg3##ZT1962:Zellner and Theil (1962)}.  Typically, the endogenous
explanatory variables are dependent variables from other equations in the
system.  {cmd:reg3} supports iterated GLS estimation and linear constraints.

{pstd}
{cmd:reg3} can also estimate systems of equations by seemingly unrelated
regression estimation (SURE), multivariate regression (MVREG), and
equation-by-equation ordinary least squares (OLS) or two-stage least squares
(2SLS).


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R reg3Quickstart:Quick start}

        {mansection R reg3Remarksandexamples:Remarks and examples}

        {mansection R reg3Methodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker nomenclature}{...}
{title:Nomenclature}

{pstd}
Under 3SLS or 2SLS estimation, a structural equation is defined as
one of the equations specified in the system.  A dependent variable will
have its usual interpretation as the left-hand-side variable in an equation
with an associated disturbance term.  All dependent variables are explicitly
taken to be endogenous to the system and are treated as correlated with the
disturbances in the system's equations.  Unless specified in an {cmd:endog()}
option, all other variables in the system are treated as exogenous to the
system and uncorrelated with the disturbances.  The exogenous variables are
taken to be instruments for the endogenous variables.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{cmd:ireg3} causes {cmd:reg3} to iterate over the estimated disturbance
covariance matrix and parameter estimates until the parameter estimates
converge.  Although the iteration is usually successful, there is no guarantee
that it will converge to a stable point.  Under SURE, this iteration converges
to the maximum likelihood estimates.

{phang}
{opt constraints(constraints)}; see
    {helpb estimation options##constraints():[R] Estimation options}.

{dlgtab:Model 2}

{phang}
{opth exog(varlist)} specifies additional exogenous variables that are
included in none of the system equations.  This can occur when the system
contains identities that are not estimated.  If implicitly exogenous variables
from the equations are listed here, {cmd:reg3} will just ignore the additional
information.  Specified variables will be added to the exogenous variables in
the system and used in the first stage as instruments for the endogenous
variables.  By specifying dependent variables from the structural equations,
you can use {opt exog()} to override their endogeneity.

{phang}
{opth endog(varlist)} identifies variables in the system that are not
dependent variables but are endogenous to the system.  These variables must
appear in the variable list of at least one equation in the system.  Again,
the need for this identification often occurs when the system contains
identities.  For example, a variable that is the sum of an exogenous variable
and a dependent variable may appear as an explanatory variable in some
equations.

{phang}
{opth inst(varlist)} specifies a full list of all exogenous variables and may
not be used with the {opt endog()} or {opt exog()} options.  It must contain a
full list of variables to be used as instruments for the endogenous
regressors.  Like {opt exog()}, the list may contain variables not specified
in the system of equations.  This option can be used to achieve the same
results as the {opt endog()} and {opt exog()} options, and the choice is a
matter of convenience.  Any variable not specified in the {it:varlist} of the
{opt inst()} option is assumed to be endogenous to the system.  As with 
{opt exog()}, including the dependent variables from the structural equations
will override their endogeneity.

{phang}
{opt allexog} indicates that all right-hand-side variables are to be
treated as exogenous -- even if they appear as the dependent variable
of another equation in the system.  This option can be used to enforce a
SURE or MVREG estimation even when
some dependent variables appear as regressors.

{phang}
{cmd:noconstant}; see
{helpb estimation options##noconstant:[R] Estimation options}.

{dlgtab:Est. method}

{phang}
{opt 3sls} specifies the full 3SLS estimation of
the system and is the default for {cmd:reg3}.

{phang}
{opt 2sls} causes {cmd:reg3} to perform equation-by-equation 2SLS 
on the full system of equations.  This option implies {opt dfk}, 
{opt small}, and {cmd:corr(independent)}.

{pmore}
Cross-equation testing should not be performed after
estimation with this option.  With {opt 2sls}, no covariance is estimated
between the parameters of the equations.  For cross-equation testing, use
{opt 3sls}.

{phang}
{opt ols} causes {cmd:reg3} to perform equation-by-equation OLS on the
system -- even if dependent variables appear as regressors or the
regressors differ for each equation; see {manhelp mvreg MV}.  {opt ols} implies
{opt allexog}, {opt dfk}, {opt small}, and {cmd:corr(independent)}; 
{opt nodfk} and {opt nosmall} may be specified to override {opt dfk} and 
{opt small}.

{pmore}
The covariance of the coefficients between equations is not
estimated under this option, and cross-equation tests should not be
performed after estimation with {opt ols}.  For cross-equation testing, use
{opt sure} or {opt 3sls} (the default).

{phang}
{opt sure} causes {cmd:reg3} to perform a SURE 
of the system -- even if dependent variables from some
equations appear as regressors in other equations; see {manhelp sureg R}.
{opt sure} is a synonym for {opt allexog}.

{phang}
{opt mvreg} is identical to {opt sure}, except that the disturbance
covariance matrix is estimated with an OLS degrees-of-freedom 
adjustment -- the {opt dfk} option.  If the regressors are identical for
all equations, the parameter point estimates will be the standard MVREG 
results.  If any of the regressors differ, the point estimates are
those for SURE with an OLS degrees-of-freedom
adjustment in computing the covariance matrix.  {opt nodfx} and {opt nosmall}
may be specified to override {opt dfk} and {opt small}.

{phang}
{opt corr(correlation)} specifies the assumed form of the correlation
structure of the equation disturbances and is rarely requested explicitly.
For the family of models fit by {cmd:reg3}, the only two allowable
correlation structures are {opt u:nstructured} and {opt i:ndependent}.
The default is {opt unstructured}.

{pmore}
This option is used almost exclusively to estimate a system of
equations by 2SLS or to perform OLS regression
with {cmd:reg3} on multiple equations.  In these cases, the correlation is set
to {opt independent}, forcing {cmd:reg3} to treat the covariance matrix of
equation disturbances as diagonal in estimating model parameters.  Thus, a set
of two-stage coefficient estimates can be obtained if the system contains
endogenous right-hand-side variables, or OLS regression can be imposed, even
if the regressors differ across equations.  Without imposing independent
disturbances, {cmd:reg3} would estimate the former by 3SLS 
and the latter by SURE.  

{pmore}
Any tests performed after estimation with the {opt independent}
option will treat coefficients in different equations as having no covariance;
cross-equation tests should not be used after specifying 
{cmd:corr(independent)}.

{dlgtab:df adj.}

{phang}
{opt small} specifies that small-sample statistics be computed.
It shifts the test statistics from chi-squared and z statistics to F
statistics and t statistics.  This option is intended primarily to support
MVREG.  Although the standard errors from each equation are
computed using the degrees of freedom for the equation, the degrees of freedom
for the t statistics are all taken to be those for the first equation.  This
approach poses no problem under MVREG because the regressors
are the same across equations.

{phang}
{opt dfk} specifies the use of an alternative divisor in computing the
covariance matrix for the equation residuals.  As an asymptotically justified
estimator, {cmd:reg3} by default uses the number of sample observations n as
a divisor.  When the {opt dfk} option is set, a small-sample adjustment is
made, and the divisor is taken to be sqrt((n - k_i) * (n - k_j)), where k_i and
k_j are the number of parameters in equations i and j, respectively.

{phang}
{opt dfk2} specifies the use of an alternative divisor in computing the
covariance matrix for the equation errors.  When the {opt dfk2} option is set,
the divisor is taken to be the mean of the residual degrees of freedom from
the individual equations.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] Estimation options}. 

{phang}
{opt first} requests that the first-stage regression results be
displayed during estimation.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] Estimation options}.

INCLUDE help displayopts_list

{marker optimization_options}{...}
{dlgtab:Optimization}

{phang}
{it:optimization_options} control the iterative process that minimizes the 
    sum of squared errors when {opt ireg3} is specified.  These options are
    seldom used.

{phang2}
{opt iter:ate(#)} specifies the maximum number of iterations.  When the number
of iterations equals {it:#}, the optimizer stops and presents the current
results, even if the convergence tolerance has not been reached.  The default
is the number set using {helpb set maxiter}, which is
INCLUDE help maxiter
by default.

{phang2}
{opt tr:ace} adds to the iteration log a display of the current parameter
    vector.

{phang2}
INCLUDE help lognolog

{phang2}
{opt tol:erance(#)} specifies the tolerance for the coefficient vector.  When
the relative change in the coefficient vector from one iteration to the next
is less than or equal to {it:#}, the optimization process is stopped.
{cmd:tolerance(1e-6)} is the default.

{phang}
The following options are available with {cmd:reg3} but are not shown in the
dialog box:

{phang}
{opt noheader} suppresses display of the header reporting the
estimation method and the table of equation summary statistics.

{phang}
{opt notable} suppresses display of the coefficient table.

{phang}
{opt nofooter} suppresses display of the footer reporting the list of
endogenous and exogenous variables in the model.

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse klein}{p_end}

{pstd}Estimate system by three-stage least squares{p_end}
{phang2}{cmd:. reg3 (consump wagepriv wagegovt) (wagepriv consump govt capital1)}
{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse supDem}{p_end}

{pstd}Store equations in global macros{p_end}
{phang2}{cmd:. global demand  "(qDemand: quantity price pcompete income)"}{p_end}
{phang2}{cmd:. global supply  "(qSupply: quantity price praw)"}{p_end}

{pstd}Estimate system, specifying {cmd:price} as endogenous{p_end}
{phang2}{cmd:. reg3 $demand $supply, endog(price)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse klein}{p_end}

{pstd}Store equations and variable lists in global macros{p_end}
{phang2}{cmd:. global conseqn "(consump profits profits1 wagetot)"}{p_end}
{phang2}{cmd:. global inveqn "(invest profits profits1 capital1)"}{p_end}
{phang2}{cmd:. global wageqn "(wagepriv totinc totinc1 year)"}{p_end}
{phang2}{cmd:. global enlist "wagetot profits totinc"}{p_end}
{phang2}{cmd:. global exlist "taxnetx wagegovt govt"}{p_end}

{pstd}Estimate system, specifying lists of endogenous and exogenous variables;
iterate until estimates converge{p_end}
{phang2}{cmd:. reg3 $conseqn $inveqn $wageqn, endog($enlist) exog($exlist) ireg3}{p_end}

{pstd}Modify consumption equation{p_end}
{phang2}{cmd:. global conseqn "(consump profits profits1 wagepriv wagegovt)"}
{p_end}

{pstd}Constrain coefficients of {cmd:wagepriv} and {cmd:wagegovt} in
consumption equation to be equal{p_end}
{phang2}{cmd:. constraint 1 [consump]wagepriv = [consump]wagegovt}
{p_end}

{pstd}Estimate system under constraint{p_end}
{phang2}{cmd:. reg3 $conseqn $inveqn $wageqn, endog($enlist) exog($exlist)}
              {cmd:constr(1) ireg3}{p_end}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:reg3} stores the following in {cmd:e()}:

{synoptset 18 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(mss_}{it:#}{cmd:)}}model sum of squares for equation {it:#}{p_end}
{synopt:{cmd:e(df_m}{it:#}{cmd:)}}model degrees of freedom for equation {it:#}{p_end}
{synopt:{cmd:e(rss_}{it:#}{cmd:)}}residual sum of squares for equation {it:#}{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom ({cmd:small}){p_end}
{synopt:{cmd:e(r2_}{it:#}{cmd:)}}R-squared for equation {it:#}{p_end}
{synopt:{cmd:e(F_}{it:#}{cmd:)}}F statistic for equation {it:#} ({cmd:small}){p_end}
{synopt:{cmd:e(rmse_}{it:#}{cmd:)}}root mean squared error for equation {it:#}{p_end}
{synopt:{cmd:e(dfk2_adj)}}divisor used with VCE when {cmd:dfk2} specified{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(chi2_}{it:#}{cmd:)}}chi-squared for equation {it:#}{p_end}
{synopt:{cmd:e(p_}{it:#}{cmd:)}}p-value for model test for equation {it:#}{p_end}
{synopt:{cmd:e(cons_}{it:#}{cmd:)}}{cmd:1} when equation {it:#} has a
              constant, {cmd:0} otherwise{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}

{synoptset 18 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:reg3}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}names of dependent variables{p_end}
{synopt:{cmd:e(exog)}}names of exogenous variables{p_end}
{synopt:{cmd:e(endog)}}names of endogenous variables{p_end}
{synopt:{cmd:e(eqnames)}}names of equations{p_end}
{synopt:{cmd:e(corr)}}correlation structure{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(method)}}{cmd:3sls}, {cmd:2sls}, {cmd:ols}, {cmd:sure}, or
	{cmd:mvreg}{p_end}
{synopt:{cmd:e(small)}}{cmd:small}, if specified{p_end}
{synopt:{cmd:e(dfk)}}{cmd:dfk}, if specified{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsdefault)}}default {opt predict()} specification for {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 18 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(Sigma)}}Sigma hat matrix{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{synoptset 18 tabbed}{...}
{p2col 5 15 19 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker reference}{...}
{title:Reference}

{marker ZT1962}{...}
{phang}
Zellner, A., and H. Theil. 1962. Three stage least squares: Simultaneous
estimate of simultaneous equations. {it:Econometrica} 29: 54-78.
{p_end}
