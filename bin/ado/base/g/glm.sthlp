{smcl}
{* *! version 1.3.2  09apr2019}{...}
{viewerdialog glm "dialog glm"}{...}
{viewerdialog "svy: glm" "dialog glm, message(-svy-) name(svy_glm)"}{...}
{vieweralsosee "[R] glm" "mansection R glm"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] glm postestimation" "help glm postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes: glm" "help bayes glm"}{...}
{vieweralsosee "[R] cloglog" "help cloglog"}{...}
{vieweralsosee "[MI] Estimation" "help mi estimation"}{...}
{vieweralsosee "[FMM] fmm: glm" "help fmm glm"}{...}
{vieweralsosee "[R] logistic" "help logistic"}{...}
{vieweralsosee "[ME] meglm" "help meglm"}{...}
{vieweralsosee "[R] nbreg" "help nbreg"}{...}
{vieweralsosee "[R] poisson" "help poisson"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy_estimation"}{...}
{vieweralsosee "[XT] xtgee" "help xtgee"}{...}
{viewerjumpto "Syntax" "glm##syntax"}{...}
{viewerjumpto "Menu" "glm##menu"}{...}
{viewerjumpto "Description" "glm##description"}{...}
{viewerjumpto "Links to PDF documentation" "glm##linkspdf"}{...}
{viewerjumpto "Options" "glm##options"}{...}
{viewerjumpto "Remarks" "glm##remarks"}{...}
{viewerjumpto "Examples" "glm##examples"}{...}
{viewerjumpto "Stored results" "glm##results"}{...}
{viewerjumpto "Reference" "glm##reference"}{...}
{p2colset 1 12 14 2}{...}
{p2col:{bf:[R] glm} {hline 2}}Generalized linear models{p_end}
{p2col:}({mansection R glm:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:glm}
{depvar}
[{indepvars}]
{ifin}
[{it:{help glm##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Model}
{synopt :{opth f:amily(glm##familyname:familyname)}}distribution of {depvar};
    default is {cmd:family(gaussian)}{p_end}
{synopt :{opth l:ink(glm##linkname:linkname)}}link function; default is
    canonical link for {opt family()} specified{p_end}

{syntab :Model 2}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opth exp:osure(varname)}}include ln({it:varname}) in model with
coefficient constrained to 1{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient
constrained to 1{p_end}
{synopt:{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}
{synopt :{opt asis}}retain perfect predictor variables{p_end}
{synopt :{opth mu(varname)}}use {it:varname} as the initial estimate for the
mean of {depvar}{p_end}
{synopt :{opth ini:t(varname)}}synonym for {opt mu(varname)}{p_end}

{syntab :SE/Robust}
{synopt :{cmd:vce(}{it:{help glm##vcetype:vcetype}}{cmd:)}}{it:vcetype}
may be {opt oim}, {opt r:obust}, {opt cl:uster} {it:clustvar}, {opt eim}, 
{opt opg}, {opt boot:strap}, {opt jack:knife}, {opt hac} {help glm##kernel:{it:kernel}},
{opt jackknife1}, or {opt unb:iased}{p_end}
{synopt :{opt vf:actor(#)}}multiply variance matrix by scalar {it:#}{p_end}
{synopt :{opt disp(#)}}quasilikelihood multiplier{p_end}
{synopt :{cmdab:sca:le(x2}|{cmd:dev}|{it:#}{cmd:)}}set the scale parameter{p_end}

{syntab :Reporting}
{synopt :{opt le:vel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}
{synopt :{opt ef:orm}}report exponentiated coefficients{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help glm##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab :Maximization}
{synopt :{opt ml}}use maximum likelihood optimization; the default{p_end}
{synopt :{opt irls}}use iterated, reweighted least-squares optimization of the
deviance{p_end}
{synopt :{it:{help glm##maximize_options:maximize_options}}}control the maximization process; seldom
used{p_end}
{synopt :{opt fisher(#)}}use the Fisher scoring Hessian or expected
information matrix (EIM){p_end}
{synopt :{opt search}}search for good starting values{p_end}

{synopt :{opt nohead:er}}suppress header table from above
coefficient table{p_end}
{synopt :{opt notable}}suppress coefficient table{p_end}
{synopt :{opt nodisplay}}suppress the output; iteration log is
still displayed{p_end}
{synopt:{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{marker familyname}{...}
{synoptset 23}{...}
{synopthdr :familyname}
{synoptline}
{synopt :{opt gau:ssian}}Gaussian (normal){p_end}
{synopt :{opt ig:aussian}}inverse Gaussian{p_end}
{synopt :{opt b:inomial}[{it:{help varname:varnameN}}|{it:#N}]}Bernoulli/binomial{p_end}
{synopt :{opt p:oisson}}Poisson{p_end}
{synopt :{opt nb:inomial}[{it:#k}|{cmd:ml}]}negative binomial{p_end}
{synopt :{opt gam:ma}}gamma{p_end}
{synoptline}
{p2colreset}{...}

{marker linkname}{...}
{synoptset 23}{...}
{synopthdr :linkname}
{synoptline}
{synopt :{opt i:dentity}}identity{p_end}
{synopt :{opt log}}log{p_end}
{synopt :{opt l:ogit}}logit{p_end}
{synopt :{opt p:robit}}probit{p_end}
{synopt :{opt c:loglog}}clog-log{p_end}
{synopt :{opt pow:er} {it:#}}power{p_end}
{synopt :{opt opo:wer} {it:#}}odds power{p_end}
{synopt :{opt nb:inomial}}negative binomial{p_end}
{synopt :{opt logl:og}}log-log{p_end}
{synopt :{opt logc}}log-complement{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help fvvarlist
{p 4 6 2}
{it:depvar} and {it:indepvars} may contain time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}
{opt bayes}, {opt bootstrap}, {opt by}, {opt fmm}, {opt fp}, {opt jackknife},
{opt mfp}, {opt mi estimate}, {opt nestreg}, {opt rolling}, {opt statsby}, 
{opt stepwise}, and {opt svy} are allowed; see {help prefix}.
For more details, see {manhelp bayes_glm BAYES:bayes: glm} and
{manhelp fmm_glm FMM:fmm: glm}.{p_end}
{p 4 6 2}
{cmd:vce(bootstrap)}, {cmd:vce(jackknife)}, and {cmd:vce(jackknife1)} are not
allowed with the {helpb mi estimate} prefix.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{marker weight}{...}
{p 4 6 2}{cmd:aweight}s are not allowed with the {helpb jackknife} prefix.
{p_end}
{p 4 6 2}
{opt vce()},
{opt vfactor()},
{opt disp()},
{opt scale()},
{opt irls},
{opt fisher()},
{opt noheader},
{opt notable},
{opt nodisplay},
and weights are not allowed with the {helpb svy} prefix.
{p_end}
{p 4 6 2}
{opt fweight}s, {opt aweight}s, {opt iweight}s, and {opt pweight}s are
allowed; see {help weight}.{p_end}
{p 4 6 2}
{opt noheader}, {opt notable}, {opt nodisplay}, {opt collinear},
and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp glm_postestimation R:glm postestimation} for features available
after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Generalized linear models > Generalized linear models (GLM)}


{marker description}{...}
{title:Description}

{pstd}
{opt glm} fits generalized linear models.  It can fit models by using
either IRLS (maximum quasilikelihood) or Newton-Raphson (maximum likelihood)
optimization, which is the default.

{pstd}
See {findalias frestadv} for a description of all of
Stata's estimation commands, several of which fit models that can also be fit
using {cmd:glm}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R glmQuickstart:Quick start}

        {mansection R glmRemarksandexamples:Remarks and examples}

        {mansection R glmMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opth family:(glm##familyname:familyname)} specifies the distribution of
{depvar}; {cmd:family(gaussian)} is the default.

{phang}
{opth link:(glm##linkname:linkname)} specifies the link function; the
default is the canonical link for the {cmd:family()} specified 
(except for {cmd:family(nbinomial)}).

{dlgtab:Model 2}

{phang}
{opt noconstant}, {opth exposure(varname)}, {opt offset(varname)},
{opt constraints(constraints)}; see 
{helpb estimation options:[R] Estimation options}.
{opt constraints(constraints)} is not allowed with {opt irls}.

{phang}
{opt asis} forces retention of perfect predictor variables and their
associated, perfectly predicted observations and may produce instabilities in
maximization; see {manhelp probit R}.
This option is allowed only with option {cmd:family(binomial)}
with a denominator of 1.

{phang}
{opth mu(varname)} specifies {it:varname} as the initial estimate for the mean
of {depvar}.  This option can be useful with models that experience convergence
difficulties, such as {cmd:family(binomial)} models with power or odds-power
links.  {opt init(varname)} is a synonym.

{marker vcetype}{...}
{dlgtab:SE/Robust}

INCLUDE help vce_asymptall

{pmore}
In addition to the standard {it:vcetype}s, {opt glm} allows the following
alternatives:

{phang2}
{cmd:vce(eim)} specifies that the EIM estimate of
variance be used.

{phang2}
{cmd:vce(jackknife1)} specifies that the one-step jackknife estimate of
variance be used.

{marker kernel}{...}
{phang2}
{cmd:vce(hac} {it:kernel} [{it:#}]{cmd:)} specifies that a
heteroskedasticity- and autocorrelation-consistent (HAC) variance estimate be
used.  HAC refers to the general form for combining weighted matrices
to form the variance estimate.  There are three kernels built into
{opt glm}.  {it:kernel} is a user-written program or one of

{center:{opt nw:est} | {opt ga:llant} | {opt an:derson}}

{pmore2}
{it:#} specifies the number of lags.  If {it:#} is not specified, N - 2 is
assumed.  If you wish to specify {cmd:vce(hac} ... {cmd:)}, you must 
{cmd:tsset} your data before calling {cmd:glm}.

{phang2}
{cmd:vce(unbiased)} specifies that the unbiased sandwich estimate of variance
be used.

{phang}
{opt vfactor(#)} specifies a scalar by which to
multiply the resulting variance matrix.  This option allows you to match
output with other packages, which may apply degrees of freedom or other
small-sample corrections to estimates of variance.

{phang}
{opt disp(#)} multiplies the variance of {depvar}
by {it:#} and divides the deviance by {it:#}.  The resulting distributions are
members of the quasilikelihood family.
This option is allowed only with option {cmd:irls}.

{phang}
{cmd:scale(x2}|{cmd:dev}|{it:#}{cmd:)} overrides the
default scale parameter.  This option is allowed only with Hessian
(information matrix) variance estimates.

{pmore}
By default, {cmd:scale(1)} is assumed for the 
discrete distributions (binomial, Poisson, and negative binomial),
and {cmd:scale(x2)} is assumed for the continuous distributions
(Gaussian, gamma, and inverse Gaussian).

{pmore}
{cmd:scale(x2)} specifies that the scale parameter be set to the Pearson
chi-squared (or generalized chi-squared) statistic divided by the residual
degrees of freedom, which is recommended by 
{help glm##MN1989:McCullagh and Nelder (1989)} as a
good general choice for continuous distributions.

{pmore}
{cmd:scale(dev)} sets the scale parameter to the deviance divided by the
residual degrees of freedom.  This option provides an alternative to
{cmd:scale(x2)} for continuous distributions and overdispersed or
underdispersed discrete distributions.  This option is allowed only with
option {cmd:irls}.

{pmore}
{opt scale(#)} sets the scale parameter to {it:#}.
For example, using {cmd:scale(1)} in {cmd:family(gamma)} models results in
exponential-errors regression.  Additional use of {cmd:link(log)} rather than
the default {cmd:link(power -1)} for {cmd:family(gamma)} essentially
reproduces Stata's {opt streg}, {cmd:dist(exp) nohr} command (see
{manhelp streg ST}) if all the observations are uncensored.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

{phang}
{opt eform} displays the exponentiated coefficients and corresponding
standard errors and confidence intervals.  For 
{cmd:family(binomial) link(logit)} (that is, logistic regression),
exponentiation results are odds ratios; for 
{cmd:family(nbinomial) link(log)} (that is, negative binomial regression)
and for
{cmd:family(poisson) link(log)} (that is, Poisson regression),
exponentiated coefficients are incidence-rate ratios.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] Estimation options}.

INCLUDE help displayopts_list

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{opt ml} requests that optimization be carried out using Stata's {opt ml}
commands and is the default.

{phang}
{opt irls} requests iterated, reweighted least-squares (IRLS) optimization of
the deviance instead of Newton-Raphson optimization of the
log likelihood.  If the {opt irls} option is not specified, the optimization
is carried out using Stata's {opt ml} commands, in which case all options of
{opt ml maximize} are also available.

{phang}
{it:maximize_options}:
{opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)},
[{cmd:no}]{opt log},
{opt tr:ace},
{opt grad:ient},
{opt showstep},
{opt hess:ian},
{opt showtol:erance},
{opt tol:erance(#)},
{opt ltol:erance(#)},
{opt nrtol:erance(#)},
{opt nonrtol:erance}, and
{opt from(init_specs)}; see {helpb maximize:[R] Maximize}.
These options are seldom used.

{pmore}
Setting the optimization method to {cmd:technique(bhhh)} resets the default
{it:vcetype} to {cmd:vce(opg)}.

{pmore}
If option {cmd:irls} is specified, only {it:maximize_options} {cmd:iterate()},
{cmd:nolog}, {cmd:trace}, and {cmd:ltolerance()} are allowed.  With
{cmd:irls} specified, the convergence criterion is satisfied when the absolute
change in deviance from one iteration to the next is less than or equal to
{cmd:ltolerance()}, where {cmd:ltolerance(1e-6)} is the default.

{phang}
{opt fisher(#)} specifies the number of Newton-Raphson steps that
should use the Fisher scoring Hessian or EIM
before switching to the observed information matrix (OIM).  This option is
useful only for Newton-Raphson optimization (and not when using {cmd:irls}).

{phang}
{opt search} specifies that the command search for good starting
values.  This option is useful only for Newton-Raphson optimization (and
not when using {opt irls}).

{pstd}
The following options are available with {opt glm} but are not shown in the
dialog box:

{phang}
{opt noheader} suppresses the header information from the output.  The
coefficient table is still displayed.

{phang}
{opt notable} suppresses the table of coefficients from the output.  The
header information is still displayed.

{phang}
{opt nodisplay} suppresses the output.  The iteration log is still
displayed.

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.
{opt collinear} is not allowed with {opt irls}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Although {opt glm} can be used to fit linear regression
(and, in fact, does so by default), this should be viewed as an instructional
feature; {cmd:regress} produces such estimates more quickly, 
and many postestimation commands are available to explore the adequacy of
the fit; see {manhelp regress R} and
{manhelp regress_postestimation R:regress postestimation}.

{pstd}
In any case, you should specify the link function by using the {opt link()}
option and specify the distributional family by using {opt family()}.
The available link functions are

{center:Link function            {cmd:glm} option     }
{center:{hline 40}}
{center:identity                 {cmd:link(identity)} }
{center:log                      {cmd:link(log)}      }
{center:logit                    {cmd:link(logit)}    }
{center:probit                   {cmd:link(probit)}   }
{center:complementary log-log    {cmd:link(cloglog)}  }
{center:odds power               {cmd:link(opower} {it:#}{cmd:)} }
{center:power                    {cmd:link(power} {it:#}{cmd:)}  }
{center:negative binomial        {cmd:link(nbinomial)}}
{center:log-log                  {cmd:link(loglog)}   }
{center:log-complement           {cmd:link(logc)}     }

{pstd}
The available distributional families are

{center:Family                 {cmd:glm} option       }
{center:{hline 40}}
{center:Gaussian(normal)       {cmd:family(gaussian)} }
{center:inverse Gaussian       {cmd:family(igaussian)}}
{center:Bernoulli/binomial     {cmd:family(binomial)} }
{center:Poisson                {cmd:family(poisson)}  }
{center:negative binomial      {cmd:family(nbinomial)}}
{center:gamma                  {cmd:family(gamma)}    }

{pstd}
You do not have to specify both {opt family()} and {opt link()}; the default
{opt link()} is the canonical link for the specified {opt family()}
(except for {opt nbinomial}):

{center:Family                  Default link{space 2}}
{center:{hline 38}}
{center:{cmd:family(gaussian)}        {cmd:link(identity)}}
{center:{cmd:family(igaussian)}       {cmd:link(power -2)}}
{center:{cmd:family(binomial)}        {cmd:link(logit)}   }
{center:{cmd:family(poisson)}         {cmd:link(log)}     }
{center:{cmd:family(nbinomial)}       {cmd:link(log)}     }
{center:{cmd:family(gamma)}           {cmd:link(power -1)}}

{pstd}
If you specify both {opt family()} and {opt link()}, not all
combinations make sense.  You may choose from the following combinations:

	  {c |} id  log  logit  probit  clog  pow  opower  nbinomial  loglog  logc
{hline 10}{c +}{hline 67}
Gaussian  {c |}  x   x                         x
inv. Gau. {c |}  x   x                         x
binomial  {c |}  x   x     x      x       x    x     x                  x      x
Poisson   {c |}  x   x                         x
neg. bin. {c |}  x   x                         x              x
gamma     {c |}  x   x                         x


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse lbw}{p_end}

{pstd}Generalized linear model with Bernoulli family and default logit
link{p_end}
{phang2}{cmd:. glm low age lwt i.race smoke ptl ht ui, family(binomial)}
{p_end}

{pstd}Replay results and report exponentiated coefficients{p_end}
{phang2}{cmd:. glm, eform}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse ldose}{p_end}

{pstd}Generalized linear model with binomial family and default logit
link{p_end}
{phang2}{cmd:. glm r ldose, family(binomial n)}{p_end}

{pstd}Generalized linear model with binomial family and clog-log link{p_end}
{phang2}{cmd:. glm r ldose, family(binomial n) link(cloglog)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse beetle}{p_end}

{pstd}Generalized linear model with binomial family and clog-log link{p_end}
{phang2}{cmd:. glm r i.beetle ldose, family(binomial n) link(cloglog)}
{p_end}

{pstd}Replay results with 99% confidence intervals{p_end}
{phang2}{cmd:. glm, level(99)}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:glm, ml} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(df)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(phi)}}scale parameter{p_end}
{synopt:{cmd:e(aic)}}model AIC{p_end}
{synopt:{cmd:e(bic)}}model BIC{p_end}
{synopt:{cmd:e(ll)}}log likelihood, if NR{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(deviance)}}deviance{p_end}
{synopt:{cmd:e(deviance_s)}}scaled deviance{p_end}
{synopt:{cmd:e(deviance_p)}}Pearson deviance{p_end}
{synopt:{cmd:e(deviance_ps)}}scaled Pearson deviance{p_end}
{synopt:{cmd:e(dispers)}}dispersion{p_end}
{synopt:{cmd:e(dispers_s)}}scaled dispersion{p_end}
{synopt:{cmd:e(dispers_p)}}Pearson dispersion{p_end}
{synopt:{cmd:e(dispers_ps)}}scaled Pearson dispersion{p_end}
{synopt:{cmd:e(nbml)}}{cmd:1} if negative binomial parameter estimated via ML,
	{cmd:0} otherwise{p_end}
{synopt:{cmd:e(vf)}}factor set by {cmd:vfactor()}, {cmd:1} if not set{p_end}
{synopt:{cmd:e(power)}}power set by {cmd:link(power} {it:#}{cmd:)} or {cmd:link(opower} {it:#}{cmd:)}{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:glm}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(varfunc)}}program to calculate variance function{p_end}
{synopt:{cmd:e(varfunct)}}variance title{p_end}
{synopt:{cmd:e(varfuncf)}}variance function{p_end}
{synopt:{cmd:e(link)}}program to calculate link function{p_end}
{synopt:{cmd:e(linkt)}}link title{p_end}
{synopt:{cmd:e(linkf)}}link function{p_end}
{synopt:{cmd:e(m)}}number of binomial trials{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset)}}linear offset variable{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt:{cmd:e(cons)}}{cmd:noconstant}, if specified{p_end}
{synopt:{cmd:e(hac_kernel)}}HAC kernel{p_end}
{synopt:{cmd:e(hac_lag)}}HAC lag{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(opt)}}{cmd:ml} or {cmd:irls}{p_end}
{synopt:{cmd:e(opt1)}}optimization title, line 1{p_end}
{synopt:{cmd:e(opt2)}}optimization title, line 2{p_end}
{synopt:{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
                         maximization or minimization{p_end}
{synopt:{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt:{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
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


{pstd}
{cmd:glm, irls} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(df)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(phi)}}scale parameter{p_end}
{synopt:{cmd:e(disp)}}dispersion parameter{p_end}
{synopt:{cmd:e(bic)}}model BIC{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(deviance)}}deviance{p_end}
{synopt:{cmd:e(deviance_s)}}scaled deviance{p_end}
{synopt:{cmd:e(deviance_p)}}Pearson deviance{p_end}
{synopt:{cmd:e(deviance_ps)}}scaled Pearson deviance{p_end}
{synopt:{cmd:e(dispers)}}dispersion{p_end}
{synopt:{cmd:e(dispers_s)}}scaled dispersion{p_end}
{synopt:{cmd:e(dispers_p)}}Pearson dispersion{p_end}
{synopt:{cmd:e(dispers_ps)}}scaled Pearson dispersion{p_end}
{synopt:{cmd:e(nbml)}}{cmd:1} if negative binomial parameter estimated via ML,
	{cmd:0} otherwise{p_end}
{synopt:{cmd:e(vf)}}factor set by {cmd:vfactor()}, {cmd:1} if not set{p_end}
{synopt:{cmd:e(power)}}power set by {cmd:link(power} {it:#}{cmd:)} or {cmd:link(opower} {it:#}{cmd:)}{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:glm}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(varfunc)}}program to calculate variance function{p_end}
{synopt:{cmd:e(varfunct)}}variance title{p_end}
{synopt:{cmd:e(varfuncf)}}variance function{p_end}
{synopt:{cmd:e(link)}}program to calculate link function{p_end}
{synopt:{cmd:e(linkt)}}link title{p_end}
{synopt:{cmd:e(linkf)}}link function{p_end}
{synopt:{cmd:e(m)}}number of binomial trials{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset)}}linear offset variable{p_end}
{synopt:{cmd:e(cons)}}{cmd:noconstant}, if specified{p_end}
{synopt:{cmd:e(hac_kernel)}}HAC kernel{p_end}
{synopt:{cmd:e(hac_lag)}}HAC lag{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(opt)}}{cmd:ml} or {cmd:irls}{p_end}
{synopt:{cmd:e(opt1)}}optimization title, line 1{p_end}
{synopt:{cmd:e(opt2)}}optimization title, line 2{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker reference}{...}
{title:Reference}

{marker MN1989}{...}
{phang}
McCullagh, P., and J. A. Nelder. 1989.
{browse "http://www.stata.com/bookstore/glm.html":{it:Generalized Linear Models}. 2nd ed.}
London: Chapman & Hall/CRC.
{p_end}
