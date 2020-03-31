{smcl}
{* *! version 1.0.7  12feb2015}{...}
{cmd:help dprobit} {right:dialog:  {dialog dprobit}{space 15}}
{right:also see:  {help dprobit postestimation}}
{right:{help prdocumented:previously documented}{space 1}}
{hline}
{pstd}
{cmd:dprobit} continues to work but, as of Stata 11, is no longer an official
part of Stata.  This is the original help file, which we will no longer
update, so some links may no longer work.

{pstd}
See {helpb margins} for a recommended alternative to {cmd:dprobit}.


{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :{hi:[R] dprobit} {hline 2}}Probit regression, reporting marginal effects{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 16 2}
{opt dprobit} [{depvar} {indepvars} {ifin} {weight}] 
[{cmd:,} {it:options}] 

{synoptset 23 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Model}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient
constrained to 1{p_end}
{synopt :{opt at(matname)}}point at which marginal effects are evaluated{p_end}
{synopt :{opt asis}}retain perfect predictor variables{p_end}
{synopt :{opt cl:assic}}calculate mean effects for dummies like those for
continuous variables{p_end}

{syntab :SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim}, {opt r:obust}, or
        {opt cl:uster} {it:clustvar}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}

{syntab :Maximization}
{synopt :{it:{help dprobit##dprobit_maximize:maximize_options}}}control the maximization process; seldom
used{p_end}

{p2coldent :+ {opt nocoe:f}}do not display the coefficient table; seldom
used{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}+ {opt nocoef} does not appear in the dialog box.{p_end}
INCLUDE help fvvarlist
{p 4 6 2}{cmd:by}, {cmd:rolling}, and {cmd:statsby} are allowed; see
{help prefix}.{p_end}
{p 4 6 2}{opt fweight}s and {opt pweight}s
are allowed; see {help weight}.{p_end}
{p 4 6 2}
See {helpb dprobit_postestimation:dprobit postestimation} for features
available after estimation.  {p_end}


{title:Menu}

{phang2}
{bf:Statistics > Binary outcomes > Probit regression (reporting change in prob.)}


{title:Description}

{pstd}
{cmd:dprobit} fits maximum-likelihood probit models and is an alternative to
{cmd:probit}.  Rather than reporting the coefficients, {cmd:dprobit} reports
the marginal effect, that is, the change in the probability for an
infinitesimal change in each independent, continuous variable and, by default,
reports the discrete change in the probability for dummy variables.
{cmd:probit} may be typed without arguments after {cmd:dprobit} estimation to
see the model in coefficient form.

{pstd}
If estimating on grouped data, see {helpb bprobit}.

{pstd}
Several auxiliary command may be run after {cmd:probit}, {cmd:logit}, or
{cmd:logistic}; see
{manhelp logistic_postestimation R:logistic postestimation} for a description
of these commands.

{pstd}
See {help logistic estimation commands} for a list of related estimation
commands.


{title:Options}

{dlgtab:Model}

{phang}
{opth offset(varname)}; see
{helpb estimation options##offset():[R] estimation options}.

{phang}
{opt at(matname)} specifies the point at which marginal effects are evaluated.
The default is to evaluate at the mean of the independent variables.  If there
are k independent variables, {it:matname} may be 1 x k or {bind:1 x (k + 1)};
that is, it may optionally include final element 1 reflecting the constant. 
{opt at()} may be specified when the model is fit or when results are
redisplayed.

{phang}
{opt asis}; see {help probit##asis:Options for probit} above.

{phang}
{opt classic} requests that the mean effects always be calculated using the
formula f(xb)*b_i.  If {opt classic} is not specified, f(xb)*b_i
is used for continuous variables, but the mean effects for dummy variables are
calculated as F(x_1*b) - F(x_0*b).  Here x_1=x but with element i set to 1, and
x_0=x  but with element i set to 0, and x is the mean of the independent
variables or the vector specified by {opt at()}.  {opt classic} may be
specified at estimation time or when results are redisplayed.  Results
calculated without {opt classic} may be redisplayed with {opt classic} and
vice versa.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are derived from asymptotic theory, that are robust to
some kinds of misspecification, and that allow for intragroup correlation; see
{helpb vce_option:[R] {it:vce_option}}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] estimation options}.

{marker dprobit_maximize}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}: {opt iter:ate(#)}, [{cmdab:no:}]{opt lo:g}, 
{opt tr:ace}, {opt tol:erance(#)}, {opt ltol:erance(#)}; see
{manhelp maximize R}.  These options are seldom used.

{phang}
The following option is available with {cmd:dprobit} but is not shown in the
dialog box:

{phang}
{opt nocoef} specifies that the coefficient table not be displayed.  This
option is sometimes used by programmers but is of no use interactively.


{title:Example}

    Setup
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. generate goodplus = rep78 >= 4 if rep78 < .}{p_end}

{pstd}Probit regression, reporting marginal effects{p_end}
{phang2}{cmd:. dprobit foreign mpg goodplus}{p_end}


{title:Saved results}

{pstd}
{cmd:dprobit} saves the following in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_cds)}}number of completely determined successes{p_end}
{synopt:{cmd:e(N_cdf)}}number of completely determined failures{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(r2_p)}}pseudo-R-squared{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(ll_0)}}log likelihood, constant-only model{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(pbar)}}fraction of successes observed in data{p_end}
{synopt:{cmd:e(xbar)}}average probit score{p_end}
{synopt:{cmd:e(offbar)}}average offset{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:dprobit}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(at)}}predicted probability (at x){p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared
	test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(dummy)}}string of blank-separated 0s and 1s; 0 means that the
corresponding independent variable is not a dummy; 1 means that it is{p_end}
{synopt:{cmd:e(crittype)}}optimization criterion{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(dfdx)}}marginal effects{p_end}
{synopt:{cmd:e(se_dfdx)}}standard errors of the marginal effects{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}


{title:Also see}

{psee}
Manual:  {help prdocumented:previously documented}

{psee}
{space 2}Help:  {manhelp dprobit_postestimation R:dprobit postestimation};{break}
{manhelp asmprobit R},
{manhelp biprobit R},
{manhelp brier R},
{manhelp glm R},
{manhelp hetprob R},
{manhelp ivprobit R},
{manhelp logistic R},
{manhelp logit R},
{manhelp mprobit R},
{manhelp roc R},
{manhelp scobit R},
{manhelp svy_estimation SVY:svy estimation},
{manhelp xtprobit XT}
{p_end}
