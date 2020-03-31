{smcl}
{* *! version 1.2.0  09oct2017}{...}
{cmd:help cnreg} {right:dialogs:  {dialog cnreg}  {dialog cnreg, message(-svy-) name(svy_cnreg):svy: cnreg}{space 4}}
{right:also see:  {help cnreg postestimation}{space 1}}
{right:{help prdocumented:previously documented}}
{hline}
{pstd}
{cmd:cnreg} continues to work but, as of Stata 11, is no longer an official
part of Stata.  This is the original help file, which we will no longer
update, so some links may no longer work.

{pstd}
See {helpb intreg} for a recommended alternative to {cmd:cnreg}.


{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{hi:[R] cnreg} {hline 2}}Censored-normal regression{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 14 2}
{cmdab:cnr:eg}
{depvar} 
[{indepvars}] 
{ifin}
{weight}
{cmd:,}
{opt cen:sored(varname)}
[{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{p2coldent:* {opth cen:sored(varname)}}variable indicating whether
{it:depvar} is not censored (0), left censored (-1), or right censored
(1){p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient
constrained to 1{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
{opt r:obust}, {opt cl:uster} {it:clustvar}, {opt boot:strap}, or
{opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}

{syntab:Max options}
{synopt :{it:{help cnreg##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt censored(varname)} is required.{p_end}
{p 4 6 2}
{opt bootstrap}, {opt by}, {opt jackknife}, {opt nestreg},
{opt rolling}, {opt statsby},
{opt stepwise}, {opt svy}, and {cmd:xi} are allowed; see {help prefix}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}{cmd:aweight}s are not allowed with the {helpb jackknife} prefix.
{p_end}
{p 4 6 2}
{opt vce()} and weights are not allowed with the {helpb svy}
prefix.{p_end}
{p 4 6 2}
{opt aweight}s, {opt fweight}s, {opt pweight}s, and {opt iweight}s
are allowed; see {help weight}.{p_end}
{p 4 6 2}
See {manhelp cnreg_postestimation R:cnreg postestimation} for features
available after estimation.  {p_end}


{title:Description}

{pstd}
{cmd:cnreg} fits a model of {depvar} on {indepvars}, where
{it:depvar} contains both observations and censored observations on the
process.  Censoring values may vary from observation to observation.


{title:Options}

{dlgtab:Model}

{phang}
{opth censored(varname)} is required.
{it:varname} is a variable indicating if {it:depvar} is censored and, if so,
whether the censoring is left or right.  
{hi:0} indicates that {it:depvar} is not censored.
{hi:-1} indicates left censoring; the true value is
known only to be less than or equal to the value recorded in {it:depvar}.
{hi:+1} indicates right censoring; the true value is known only
to be greater than or equal to the value recorded in {it:depvar}.

{phang}
{opth offset(varname)}; see
{helpb estimation options##offset():[R] estimation options}.

{dlgtab:SE/Robust}

INCLUDE help vce_asymptall

{dlgtab:Reporting}

{phang}
{opt level(#)}; see 
{helpb estimation options##level():[R] estimation options}.

{marker maximize_options}{...}
{dlgtab:Max options}

{phang}
{it:maximize_options}: {opt iter:ate(#)}, [{cmd:{ul:no}}]{opt lo:g}, 
{opt tr:ace}, {opt tol:erance(#)}, {opt ltol:erance(#)}, {opt nrtol:erance(#)},
{opt nonrtol:erance}; see
{manhelp maximize R}.
These options are seldom used.

{pmore}
Unlike most maximum likelihood commands, {cmd:cnreg}
defaults to {opt nolog} -- it suppresses the iteration log.
{opt log} will display the iteration log.


{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse news2}{p_end}

{pstd}Perform censored-normal regression{p_end}
{phang2}{cmd:. cnreg date lncltn famown, censored(cnsrd)}

{pstd}Replay results, using 99% CI{p_end}
{phang2}{cmd:. cnreg, level(99)}


{title:Saved results}

{pstd}
{cmd:cnreg} saves the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_unc)}}number of uncensored observations{p_end}
{synopt:{cmd:e(N_lc)}}number of left-censored observations{p_end}
{synopt:{cmd:e(N_rc)}}number of right-censored observations{p_end}
{synopt:{cmd:e(llopt)}}contents of {cmd:ll()}, if specified{p_end}
{synopt:{cmd:e(ulopt)}}contents of {cmd:ul()}, if specified{p_end}
{synopt:{cmd:e(k_aux)}}number of auxiliary parameters{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(r2_p)}}pseudo-R-squared{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(ll_0)}}log likelihood, constant-only model{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(chi2)}}chi-squared statistic{p_end}
{synopt:{cmd:e(p)}}p-value for chi-squared test{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:cnreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(censored)}}variable specified in {cmd:censored()}{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset)}}offset{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared
	test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(crittype)}}optimization criterion{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(footnote)}}program used to implement the footnote display{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{title:Also see}

{psee}
Manual:  {help prdocumented:previously documented}
{p_end}

{psee}
{space 2}Help:  
{manhelp cnreg_postestimation R:cnreg postestimation};{break}
{manhelp intreg R}, 
{manhelp regress R},
{manhelp tobit R}, 
{manhelp svy_estimation SVY:svy estimation}, 
{manhelp xtintreg XT}, 
{manhelp xttobit XT}
{p_end}
