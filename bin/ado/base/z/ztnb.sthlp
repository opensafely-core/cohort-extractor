{smcl}
{* *! version 1.1.16  20jun2011}{...}
{cmd:help ztnb} {right:dialogs:  {dialog ztnb}  {dialog ztnb, message(-svy-) name(svy_ztnb):svy: ztnb}{space 6}}
{right:also see:  {help ztnb postestimation}  }
{right:{help prdocumented:previously documented}}
{hline}
{pstd}
{cmd:ztnb} has been superseded by {helpb tnbreg}. {cmd:tnbreg} allows the 
specification of any nonnegative integer as the left truncation point; thus
it does what {cmd:ztnb} can do and more.
{cmd:ztnb} continues to work but, as of Stata 12, is no longer an official
part of Stata.  This is the original help file, which we will no longer
update, so some links may no longer work.


{title:Title}

{p2colset 5 17 19 2}{...}
{p2col :{bf:[R] ztnb} {hline 2}}Zero-truncated negative binomial regression
{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 13 2}
{cmd:ztnb} {depvar} [{indepvars}] {ifin} {weight} 
   [{cmd:,} {it:options}]

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocon:stant}}suppress constant term{p_end}
{synopt :{opt d:ispersion}{cmd:(}{opt m:ean}{cmd:)}}parameterization of 
dispersion; {cmd:dispersion(mean)} is the default{p_end}
{synopt :{opt d:ispersion}{cmd:(}{opt c:onstant}{cmd:)}}constant dispersion 
for all observations{p_end}
{synopt :{opth e:xposure(varname:varname_e)}}include ln({it:varname_e}) in model with 
coefficient constrained to 1{p_end}
{synopt :{opth off:set(varname:varname_o)}}include {it:varname_o} in model with coefficient 
constrained to 1{p_end}
{synopt :{opt const:raints}{cmd:(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}
{synopt:{opt col:linear}}keep collinear variables{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
  {opt r:obust}, {opt cl:uster} {it:clustvar}, {opt opg}, {opt boot:strap},
  or {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}
{p_end}
{synopt :{opt nolr:test}}suppress likelihood-ratio test{p_end}
{synopt :{opt ir:r}}report incidence-rate ratios{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help ztnb##display_options:display_options}}}control spacing
           and display of omitted variables and base and empty cells{p_end}

{syntab:Maximization}
{synopt :{it:{help ztnb##ztnb_maximize:maximize_options}}}control the 
maximization process; seldom used{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
INCLUDE help fvvarlist
{p 4 6 2}{it:depvar} and {it:indepvars} may contain time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2} {cmd:bootstrap}, {cmd:by}, {cmd:jackknife}, {cmd:rolling}, 
{cmd:statsby}, and {cmd:svy} are allowed; see {help prefix}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}
{opt vce()} and weights are not allowed with the {helpb svy} prefix.
{p_end}
{p 4 6 2} {cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s are allowed; see
{help weight}.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2} See {manhelp ztnb_postestimation R:ztnb postestimation} for features
available after estimation.{p_end}


{title:Menu}

{phang}
{bf:Statistics > Count outcomes > Zero-truncated negative binomial regression}


{title:Description}

{pstd}
{cmd:ztnb} fits a zero-truncated negative binomial (ZTNB) regression model of
{depvar} on {indepvars}, where {it:depvar} is a positive count variable.


{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant}; see
{helpb estimation options##noconstant:[R] estimation options}.

{phang}
{cmd:dispersion(mean}{c |}{cmd:constant)} specifies the parameterization of
the model.  {cmd:dispersion(mean)}, the default, yields a model with
dispersion equal to 1 + alpha*exp(xb + offset); that is, the dispersion
is a function of the expected mean: exp(xb + offset).
{cmd:dispersion(constant)} has dispersion equal to 1 + delta; that is, it is a
constant for all observations.

{phang}
{opt exposure(varname_e)}, {opt offset(varname_o)},
{opt constraints(constraints)}, {opt collinear}; see
{helpb estimation options:[R] estimation options}.

{dlgtab:SE/Robust}

INCLUDE help vce_asymptall

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] estimation options}.

{phang}
{opt nolrtest} suppresses fitting the Poisson model.  Without this option, a
comparison Poisson model is fit, and the likelihood is used in a
likelihood-ratio test of the null hypothesis that the dispersion parameter is
zero.

{phang}
{opt irr} reports estimated coefficients transformed to incidence-rate
ratios, that is, exp(b) rather than b.  Standard errors and confidence
intervals are similarly transformed.  This option affects how results are
displayed, not how they are estimated or stored.  {opt irr} may be specified
at estimation or when replaying previously estimated results.

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
{opt allbase:levels};
    see {helpb estimation options##display_options:[R] estimation options}.

{marker ztnb_maximize}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}: {opt dif:ficult}, {opt tech:nique(algorithm_spec)},
{opt iter:ate(#)}, [{cmd:{ul:no}}]{opt lo:g}, {opt tr:ace},
{opt grad:ient},
{opt showstep},
{opt hess:ian},
{opt showtol:erance},
{opt tol:erance(#)}, {opt ltol:erance(#)},
{opt nrtol:erance(#)}, {opt nonrtol:erance}, and
{opt from(init_specs)}; see {manhelp maximize R}.  These options are seldom
used.

{pmore}
Setting the optimization type to {cmd:technique(bhhh)} resets the default
{it:vcetype} to {cmd:vce(opg)}.

{pstd}
The following option is available with {opt ztnb} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] estimation options}.


{title:Remarks}

{pstd}
{cmd:ztnb} fits two different parameterizations of ZTNB models, namely the
mean-dispersion and constant-dispersion models.  They are equivalent to those
modeled by {cmd:nbreg}; see {manhelp nbreg R}.


{title:Examples}

    {hline}
{phang}{cmd:. webuse rod93}{p_end}
{phang}{cmd:. ztnb deaths i.cohort}{p_end}
{phang}{cmd:. ztnb deaths i.cohort, exp(exposure)}{p_end}
    {hline}
{phang}{cmd:. webuse medpar, clear}{p_end}
{phang}{cmd:. ztnb los died hmo type2-type3, vce(cluster provnum)}{p_end}
    {hline}


{title:Saved results}

{pstd}
{cmd:ztnb} saves the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in model Wald test{p_end}
{synopt:{cmd:e(k_aux)}}number of auxiliary parameters{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(k_autoCns)}}number of base, empty, and omitted constraints{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(r2_p)}}pseudo-R-squared{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(ll_0)}}log likelihood, constant-only model{p_end}
{synopt:{cmd:e(ll_c)}}log likelihood, comparison model{p_end}
{synopt:{cmd:e(alpha)}}the value of alpha{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(chi2_c)}}chi-squared for comparison test{p_end}
{synopt:{cmd:e(p)}}significance{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(rank0)}}rank of {cmd:e(V)} for constant-only model{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:ztnb}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset)}}offset{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared
	test{p_end}
{synopt:{cmd:e(dispers)}}{cmd:mean} or {cmd:constant}{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(chi2_ct)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared
	test corresponding to {cmd:e(chi2_c)}{p_end}
{synopt:{cmd:e(diparm}{it:#}{cmd:)}}display transformed parameter {it:#}{p_end}
{synopt:{cmd:e(diparm_opt2)}}options for displaying transformed parameters
                      {p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
                         maximization or minimization{p_end}
{synopt:{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt:{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(singularHmethod)}}{cmd:m-marquardt} or {cmd:hybrid}; method used
                          when Hessian is singular{p_end}
{synopt:{cmd:e(crittype)}}optimization criterion{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{title:Also see}

{psee}
Manual:  {help prdocumented:previously documented}

{psee}
{space 2}Help:  {manhelp ztnb_postestimation R:ztnb postestimation};{break}
{manhelp nbreg R},
{manhelp poisson R}, 
{manhelp svy_estimation SVY:svy estimation},
{manhelp tnbreg R},
{manhelp tpoisson R}, 
{manhelp xtnbreg XT},
{manhelp zip R},
{manhelp ztp R}{p_end}
