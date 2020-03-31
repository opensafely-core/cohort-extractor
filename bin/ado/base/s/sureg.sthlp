{smcl}
{* *! version 1.2.12  04feb2020}{...}
{viewerdialog sureg "dialog sureg"}{...}
{vieweralsosee "[R] sureg" "mansection R sureg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] sureg postestimation" "help sureg postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] dfactor" "help dfactor"}{...}
{findalias assemsureg}{...}
{vieweralsosee "[SEM] Intro 5" "mansection SEM Intro5"}{...}
{vieweralsosee "[MV] mvreg" "help mvreg"}{...}
{vieweralsosee "[R] nlsur" "help nlsur"}{...}
{vieweralsosee "[R] reg3" "help reg3"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{viewerjumpto "Syntax" "sureg##syntax"}{...}
{viewerjumpto "Menu" "sureg##menu"}{...}
{viewerjumpto "Description" "sureg##description"}{...}
{viewerjumpto "Links to PDF documentation" "sureg##linkspdf"}{...}
{viewerjumpto "Options" "sureg##options"}{...}
{viewerjumpto "Examples" "sureg##examples"}{...}
{viewerjumpto "Stored results" "sureg##results"}{...}
{viewerjumpto "References" "sureg##references"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[R] sureg} {hline 2}}Zellner's seemingly unrelated regression{p_end}
{p2col:}({mansection R sureg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Basic syntax

{p 8 14 2}
{cmd:sureg}
{cmd:(}{depvar:1} {varlist:1}{cmd:)}
{cmd:(}{depvar:2} {varlist:2}{cmd:)}
{it:...}
{cmd:(}{depvar:N} {varlist:N}{cmd:)}
{ifin}
[{it:{help sureg##weight:weight}}]


{pstd}
Full syntax

{p 8 14 2}
{cmd:sureg}
{cmd:(}[{it:eqname1}{cmd::}]
{depvar:1a} [{depvar:1b} ... {cmd:=}]
{varlist:1} [{cmd:,} {opt nocons:tant}]{cmd:)}{p_end}
{p 14 14 2}
{cmd:(}[{it:eqname2}{cmd::}] {depvar:2a} [{depvar:2b} ... {cmd:=}]
{varlist:2} [{cmd:,} {opt nocons:tant}]{cmd:)}{p_end}
{p 14}{it:...}{p_end}
{p 14 14 2}
{cmd:(}[{it:eqnameN}{cmd::}] {depvar:Na} [{depvar:Nb} ... {cmd:=}]
{varlist:N} [{cmd:,} {opt nocons:tant}]{cmd:)}
     {ifin} 
     [{it:{help sureg##weight:weight}}]
     [{cmd:,} {it:options}]


{pstd}
Explicit equation naming ({it:eqname}{cmd::}) cannot be combined with multiple
dependent variables in an equation specification.

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt:{opt i:sure}}iterate until estimates converge{p_end}
{synopt:{cmdab:c:onstraints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}

{syntab:df adj.}
{synopt:{opt sm:all}}report small-sample statistics{p_end}
{synopt:{opt dfk}}use small-sample adjustment{p_end}
{synopt:{opt dfk2}}use alternate adjustment{p_end}

{syntab:Reporting}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt:{opt cor:r}}perform Breusch-Pagan test{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help sureg##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Optimization}
{synopt :{it:{help sureg##optimization_options:optimization_options}}}control the optimization process; seldom used{p_end}

{synopt :{opt noh:eader}}suppress header table from above coefficient table{p_end}
{synopt :{opt not:able}}suppress coefficient table{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}{it:varlist1}, ..., {it:varlistN} may contain factor variables;
see {help fvvarlist}.  You must have the same levels
of factor variables in all equations that have factor variables.{p_end}
{p 4 6 2}
{it:depvar} and the {it:varlists} may contain time-series operators;
see {help tsvarlist}. {p_end}
{p 4 6 2}
{opt bootstrap}, {opt by}, {opt fp}, {opt jackknife}, {opt rolling}, and
{opt statsby} are allowed; see {help prefix}. {p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}{cmd:aweight}s are not allowed with the {helpb jackknife} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}
{opt aweight}s and {opt fweight}s are allowed, see {help weight}.
{p_end}
{p 4 6 2}
{opt noheader}, {opt notable}, and {opt coeflegend} do not appear in the
dialog box.{p_end}
{p 4 6 2}
See {manhelp sureg_postestimation R:sureg postestimation} for features
available after estimation.  {p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Linear models and related > Multiple-equation models >}
       {bf:Seemingly unrelated regression}


{marker description}{...}
{title:Description}

{pstd}
{opt sureg} fits seemingly unrelated regression models
({help sureg##Z1962:Zellner 1962};
{help sureg##ZH1962:Zellner and Huang 1962};
{help sureg##Z1963: Zellner 1963}).  The acronyms SURE and SUR are often
used for the estimator.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R suregQuickstart:Quick start}

        {mansection R suregRemarksandexamples:Remarks and examples}

        {mansection R suregMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt isure} specifies that {opt sureg} iterate over the estimated
disturbance covariance matrix and parameter estimates until the parameter
estimates converge.  Under seemingly unrelated regression, this iteration
converges to the maximum likelihood results.  If this option is not specified,
{opt sureg} produces two-step estimates.

{phang}
{opt constraints(constraints)}; see
{helpb estimation options##constraints():[R] Estimation options}.

{dlgtab:df adj.}

{phang}
{opt small} specifies that small-sample statistics be computed.
It shifts the test statistics from chi-squared and z statistics to F
statistics and t statistics.  Although the standard errors from each equation
are computed using the degrees of freedom for the equation, the degrees of
freedom for the t statistics are all taken to be those for the first equation.

{phang}
{opt dfk} specifies the use of an alternative divisor in computing the
covariance matrix for the equation residuals.  As an asymptotically justified
estimator, {opt sureg} by default uses the number of sample observations (n)
as a divisor.  When the {opt dfk} option is set, a small-sample adjustment is
made and the divisor is taken to be sqrt((n - k_i) * (n - k_j)), where k_i and
k_j are the number of parameters in equations i and j, respectively.

{phang}
{opt dfk2} specifies the use of an alternative divisor in computing the
covariance matrix for the equation residuals.  When the {opt dfk2} option is set,
the divisor is taken to be the mean of the residual degrees of freedom from
the individual equations.  

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] Estimation options}.

{phang}
{opt corr} displays the correlation matrix of the residuals between
equations and performs a Breusch-Pagan test for independent equations; that is,
the disturbance covariance matrix is diagonal.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] Estimation options}.

INCLUDE help displayopts_list

{marker optimization_options}{...}
{dlgtab:Optimization}

{phang}
{it:optimization_options} control the iterative process that minimizes the 
    sum of squared errors when {opt isure} is specified.  These options are
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

{pstd}
The following options are available with {opt sureg} but are not shown in the
dialog box:

{phang}
{opt noheader} suppresses display of the header reporting F statistics,
R-squared, and root mean squared error above the coefficient table.

{phang}
{opt notable} suppresses display of the coefficient table.

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Fit seemingly unrelated regression model{p_end}
{phang2}{cmd:. sureg (price foreign weight length) (mpg foreign weight) (displ foreign weight)}

{pstd}Using a shorthand syntax{p_end}
{phang2}{cmd:. sureg (price foreign weight length) (mpg displ = foreign weight)}

{pstd}Using global macros{p_end}
{p 8 12 2}{cmd:. global price (price foreign weight length)}{p_end}
{p 8 12 2}{cmd:. global mpg   (mpg foreign weight)}{p_end}
{p 8 12 2}{cmd:. global displ (displ foreign weight)}{p_end}
{p 8 12 2}{cmd:. sureg $price $mpg $displ}

{pstd}With constraints{p_end}
{phang2}{cmd:. constraint 1 [price]foreign = [mpg]foreign}{p_end}
{phang2}{cmd:. constraint 2 [price]foreign = [displacement]foreign}{p_end}
{phang2}{cmd:. sureg (price foreign length) (mpg displacement = foreign weight), const(1 2)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:sureg} stores the following in {cmd:e()}:

{synoptset 18 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(mss_}{it:#}{cmd:)}}model sum of squares for equation {it:#}{p_end}
{synopt:{cmd:e(df_m}{it:#}{cmd:)}}model degrees of freedom for equation {it:#}{p_end}
{synopt:{cmd:e(rss_}{it:#}{cmd:)}}residual sum of squares for equation {it:#}{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(r2_}{it:#}{cmd:)}}R-squared for equation {it:#}{p_end}
{synopt:{cmd:e(F_}{it:#}{cmd:)}}F statistic for equation {it:#} ({cmd:small} only){p_end}
{synopt:{cmd:e(rmse_}{it:#}{cmd:)}}root mean squared error for equation {it:#}{p_end}
{synopt:{cmd:e(dfk2_adj)}}divisor used with VCE when {cmd:dfk2} specified{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(chi2_}{it:#}{cmd:)}}chi-squared for equation {it:#}{p_end}
{synopt:{cmd:e(p_}{it:#}{cmd:)}}p-value for equation {it:#}{p_end}
{synopt:{cmd:e(cons_}{it:#}{cmd:)}}{cmd:1} if equation {it:#} has a constant,
        {cmd:0} otherwise{p_end}
{synopt:{cmd:e(chi2_bp)}}Breusch-Pagan chi-squared{p_end}
{synopt:{cmd:e(df_bp)}}degrees of freedom for Breusch-Pagan chi-squared
	test{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}

{synoptset 18 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:sureg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(method)}}{cmd:sure} or {cmd:isure}{p_end}
{synopt:{cmd:e(depvar)}}names of dependent variables{p_end}
{synopt:{cmd:e(exog)}}names of exogenous variables{p_end}
{synopt:{cmd:e(eqnames)}}names of equations{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(corr)}}correlation structure{p_end}
{synopt:{cmd:e(small)}}{cmd:small}, if specified{p_end}
{synopt:{cmd:e(dfk)}}{cmd:dfk} or {cmd:dfk2}, if specified{p_end}
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
{synopt:{cmd:e(Sigma)}}Sigma hat, covariance matrix of residuals{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{synoptset 18 tabbed}{...}
{p2col 5 15 19 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker Z1962}{...}
{phang}
Zellner, A. 1962. An efficient method of estimating seemingly unrelated
regressions and tests for aggregation bias.
{it:Journal of the American Statistical Association} 57: 348-368.

{marker Z1963}{...}
{phang}
------. 1963. Estimators for seemingly unrelated regression equations:  Some
exact finite sample results.
{it:Journal of the American Statistical Association} 58: 977-992.

{marker ZH1962}{...}
{phang}
Zellner, A., and D. S. Huang. 1962.
Further properties of efficient estimators for seemingly unrelated regression
equations.
{it:International Economic Review} 3: 300-313.
{p_end}
