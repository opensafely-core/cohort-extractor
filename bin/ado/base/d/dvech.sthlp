{smcl}
{* *! version 1.1.1  20jun2011}{...}
{cmd:help dvech}{...}
{right:dialog:  {dialog dvech}{space 15}}
{right:also see:  {help dvech postestimation}}
{hline}
{pstd}
{cmd:dvech} has been superseded by {helpb mgarch dvech}.  {cmd:mgarch dvech}
is part of {helpb mgarch}, which estimates the parameters of 4 different
multivariate GARCH models -- diagonal-vech models, constant
conditional-correlation models, dynamic conditional-correlation models, and
time-varying conditional-correlation models; thus {cmd:mgarch dvech} does what
{cmd:dvech} can do and more.  {cmd:dvech} continues to work but, as of
Stata 12, is no longer an official part of Stata.  This is the original help
file, which we will no longer update, so some links may no longer work.


{title:Title}

{synoptset 12}{...}
{synopt:{bf:[TS] dvech} {hline 2}}Diagonal vech multivariate GARCH models
{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 14 2}
{cmd:dvech}
{it:eq} [{it:eq} ... {it:eq}] 
{ifin} 
[{cmd:,} {it:options}]


{pstd}
where each {it:eq} has the form

{phang2}
          {cmd:(}{it:{help varlist:depvars}} {cmd:=} [{indepvars}]{cmd:,}
          [{opt nocons:tant}]{cmd:)}

{synoptset 29 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opth ar:ch(numlist)}}ARCH terms{p_end}
{synopt :{opth ga:rch(numlist)}}GARCH terms{p_end}
{synopt :{opth const:raints(numlist)}}apply linear constraints{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim}
	or {opt r:obust}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help dvech##display_options:display_options}}}control
INCLUDE help shortdes-displayopt

{syntab:Maximization}
{synopt :{it:{help dvech##maximize_options:maximize_options}}}control the maximization process; seldom used
   {p_end}
{synopt :{opt from(matname)}}initial values for the coefficients;
         seldom used{p_end}
{synopt :{opt svtech:nique(algorithm_spec)}}starting-value maximization
          algorithm{p_end}
{synopt :{opt sviter:ate(#)}}number of starting-value iterations; default is
          {cmd:sviterate(25)}{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}You must {opt tsset} your data before using {opt dvech}; see
         {manhelp tsset TS}.{p_end}
INCLUDE help fvvarlist
{p 4 6 2}{it:depvars} and {it:indepvars} may contain time-series operators;
         see {help tsvarlist}.{p_end}
{p 4 6 2}{opt by}, {opt statsby}, and {opt rolling} are allowed; see
         {help prefix}.{p_end}
{p 4 6 2}{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp dvech_postestimation TS:dvech postestimation} for
          features available after estimation.{p_end}


{title:Menu}

{phang}
{bf:Statistics > Multivariate time series > Multivariate GARCH}


{marker description}{...}
{title:Description}

{pstd}
{cmd:dvech} estimates the parameters of a class of multivariate generalized
autoregressive conditional-heteroskedasticity (GARCH) models.
Multivariate GARCH models allow the conditional covariance matrix of
the dependent variables to follow a flexible dynamic structure.  {opt dvech}
estimates the parameters of diagonal vech GARCH models in which each
element of the current conditional covariance matrix of the dependent
variables depends only on its own past and on past shocks.


{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant} suppresses the constant term(s).

{phang}
{opth arch(numlist)} specifies the ARCH terms in the model. By
default, no ARCH terms are specified.

{phang}
{opth garch(numlist)} specifies the GARCH terms in the model. By
default, no GARCH terms are specified.

{phang}
{opth constraints(numlist)} specifies linear constraints to apply to the
parameter estimates.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the estimator for the
variance-covariance matrix of the estimator.  {cmd:vce(oim)}, the
default, specifies to use the observed information matrix (OIM)
estimator.  {cmd:vce(robust)} specifies to use the Huber/White/sandwich
estimator.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] estimation options}.

{phang}
{opt nocnsreport}; see
{helpb estimation options##nocnsreport:[R] estimation options}.

{marker display_options}{...}
{phang}
{it:display_options}:
{opt noomit:ted},
{opt vsquish},
{opt noempty:cells},
{opt base:levels},
{opt allbase:levels},
{opth cformat(%fmt)},
{opt pformat(%fmt)}, and
{opt sformat(%fmt)};
see {helpb estimation options##display_options:[R] estimation options}.

{dlgtab:Maximization}

{marker maximize_options}{...}
{phang}
{it:maximize_options}: 
{opt dif:ficult}, 
{opt tech:nique(algorithm_spec)},
{opt iter:ate(#)},
[{cmd:{ul:no}}]{opt lo:g},
{opt tr:ace}, 
{opt grad:ient},
{opt showstep},
{opt hess:ian}, 
{opt showtol:erance},
{opt tol:erance(#)},
{opt ltol:erance(#)},
{opt nrtol:erance(#)},
and
{opt from(matname)};
see {manhelp maximize R} for all options except {opt from()}, and see
below for information on {opt from()}.  These options are seldom used.

{phang}
{opt from(matname)} specifies initial values for the coefficients.
{cmd:from(b0)} causes {opt dvech} to begin the optimization algorithm with
the values in {opt b0}.  {opt b0} must be a row vector, and the number of
columns must equal the number of parameters in the model.

{phang}
{opt svtechnique(algorithm_spec)} and {opt sviterate(#)}
specify options for the starting-value search process.

{phang2}
{opt svtechnique(algorithm_spec)} specifies the algorithm used
to search for initial values.  The syntax for {it:algorithm_spec} is the
same as for the {opt technique()} option; see {manhelp maximize R}.
{cmd:svtechnique(bhhh 5 nr 16000)} is the default, and this option may not be
specified with {cmd:from()}.

{phang2}
{opt sviterate(#)} specifies the maximum number of iterations
that the search algorithm may perform.  The default is {cmd:sviterate(25)}, and
this option may not be specified with {cmd:from()}.

{pstd}
The following option is available with {cmd:dvech} but is not shown in
the dialog box:

{phang}
{opt coeflegend}; see 
     {helpb estimation options##coeflegend:[R] estimation options}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse irates4}{p_end}

{pstd}Fit a VAR(1) model of changes in {cmd:bond} and {cmd:tbill},
allowing for ARCH(1) errors{p_end}
{phang2}{cmd:. dvech (D.bond D.tbill = LD.bond LD.tbill), arch(1)}{p_end}

{pstd}Same as above, but constraining the lagged effect of {cmd:D.bond} on
{cmd:D.tbill} to be zero and suppressing constraints{p_end}
         {cmd:. dvech (D.bond = LD.bond LD.tbill, noconstant) ///}
                 {cmd:(D.tbill = LD.tbill, noconstant), arch(1)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse acme}{p_end}
{phang2}{cmd:. constraint 1 [L.ARCH]1_1  = [L.ARCH]2_2}{p_end}
{phang2}{cmd:. constraint 2 [L.GARCH]1_1 = [L.GARCH]2_2}{p_end}

{pstd}Fit a bivariate GARCH model, constraining the two variables' ARCH
coefficients to be equal, as well as their GARCH coefficients to be equal{p_end}
{phang2}{cmd:. dvech (acme = L.acme) (anvil = L.anvil), arch(1) garch(1) constraints(1 2)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse aacmer}{p_end}

{pstd}Fit a bivariate GARCH model with no regressors or constant terms,
including two ARCH terms and one GARCH term{p_end}
{phang2}{cmd:. dvech (acme anvil = , noconstant), arch(1/2) garch(1)}{p_end}

    {hline}


{title:Saved results}

{pstd}
{cmd:dvech} saves the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2:Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_extra)}}number of auxiliary parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(chi2)}}chi-squared statistic{p_end}
{synopt:{cmd:e(p)}}significance{p_end}
{synopt:{cmd:e(tmin)}}minimum time in sample{p_end}
{synopt:{cmd:e(tmax)}}maximum time in sample{p_end}
{synopt:{cmd:e(rank)}}rank of VCE{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{p2col 5 20 24 2:Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:dvech}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvars)}}names of dependent variables{p_end}
{synopt:{cmd:e(covariates)}}list of covariates{p_end}
{synopt:{cmd:e(dv_eqs)}}dependent variables with mean equations{p_end}
{synopt:{cmd:e(indeps)}}independent variables in each equation{p_end}
{synopt:{cmd:e(tvar)}}variable denoting time within groups{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(tmins)}}formatted minimum time{p_end}
{synopt:{cmd:e(tmaxs)}}formatted maximum time{p_end}
{synopt:{cmd:e(arch)}}specified ARCH terms{p_end}
{synopt:{cmd:e(garch)}}specified GARCH terms{p_end}
{synopt:{cmd:e(svtechnique)}}maximization technique(s) for starting values{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(crittype)}}optimization criterion{p_end}
{synopt:{cmd:e(properties)}}{opt b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}

{p2col 5 20 24 2:Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(hessian)}}Hessian matrix{p_end}
{synopt:{cmd:e(A)}}estimates of {cmd:A} matrices{p_end}
{synopt:{cmd:e(B)}}estimates of {cmd:B} matrices{p_end}
{synopt:{cmd:e(S)}}estimates of {cmd:Sigma0} matrix{p_end}
{synopt:{cmd:e(Sigma)}}Sigma hat{p_end}
{synopt:{cmd:e(pinfo)}}parameter information, used by {cmd:predict}{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{p2col 5 20 24 2:Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}


{title:Also see}

{psee}
Manual:  {help prdocumented:previously documented}

{psee}
{space 2}Help:  {manhelp dvech_postestimation TS:dvech postestimation};
{break}
{manhelp arch TS},
{manhelp var TS}
{p_end}
