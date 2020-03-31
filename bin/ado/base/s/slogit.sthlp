{smcl}
{* *! version 1.3.9  12dec2018}{...}
{viewerdialog slogit "dialog slogit"}{...}
{viewerdialog "svy: slogit" "dialog slogit, message(-svy-) name(svy_slogit)"}{...}
{vieweralsosee "[R] slogit" "mansection R slogit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] slogit postestimation" "help slogit postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] logistic" "help logistic"}{...}
{vieweralsosee "[R] mlogit" "help mlogit"}{...}
{vieweralsosee "[R] ologit" "help ologit"}{...}
{vieweralsosee "[R] oprobit" "help oprobit"}{...}
{vieweralsosee "[R] roc" "help roc"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{viewerjumpto "Syntax" "slogit##syntax"}{...}
{viewerjumpto "Menu" "slogit##menu"}{...}
{viewerjumpto "Description" "slogit##description"}{...}
{viewerjumpto "Links to PDF documentation" "slogit##linkspdf"}{...}
{viewerjumpto "Options" "slogit##options"}{...}
{viewerjumpto "Remarks" "slogit##remarks"}{...}
{viewerjumpto "Examples" "slogit##examples"}{...}
{viewerjumpto "Stored results" "slogit##results"}{...}
{viewerjumpto "Reference" "slogit##reference"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[R] slogit} {hline 2}}Stereotype logistic regression{p_end}
{p2col:}({mansection R slogit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:slogit}
{depvar}
[{indepvars}]
{ifin}
[{it:{help slogit##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt:{opt dim:ension(#)}}dimension of the model; default is
{cmd:dimension(1)}{p_end}
{synopt:{opt b:aseoutcome(#|lbl)}}set the base outcome to {it:#} or {it:lbl};
default is the last outcome{p_end}
{synopt:{cmdab:const:raints(}{it:{help estimation options##constraints():numlist}}{cmd:)}}apply specified linear constraints{p_end}
{synopt:{opt nocorn:er}}do not generate the corner constraints{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
   {opt r:obust}, {opt cl:uster} {it:clustvar}, {opt opg}, {opt boot:strap},
   or {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt:{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help slogit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt:{it:{help slogit##maximize_options:maximize_options}}}control the
maximization process; seldom used{p_end}
{synopt:{opt init:ialize(initype)}}method of initializing scale parameters;
{it:initype} can be {opt constant}, {opt random}, or {opt svd}; see
{help slogit##initialize:{it:Options}} for details{p_end}
{synopt:{opt nonorm:alize}}do not normalize the numeric variables{p_end}

{synopt:{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
INCLUDE help fvvarlist
{p 4 6 2}
{cmd:bootstrap}, {cmd:by}, {cmd:fp}, {cmd:jackknife}, {cmd:rolling},
{cmd:statsby}, and {cmd:svy} are allowed; see {help prefix}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}
{opt vce()} and weights are not allowed with the {helpb svy} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{opt collinear} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp slogit_postestimation R:slogit postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Categorical outcomes > Stereotype logistic regression}


{marker description}{...}
{title:Description}

{pstd}
{opt slogit} fits Anderson's ({help slogit##A1984:1984}) maximum-likelihood
stereotype logistic regression model for categorical dependent variables.
Stereotype logistic models can be used when the relevance of the ordering is
unclear.  These models do not impose the proportional-odds assumption.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R slogitQuickstart:Quick start}

        {mansection R slogitRemarksandexamples:Remarks and examples}

        {mansection R slogitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt dimension(#)} specifies the dimension of the model, which is the number
of equations required to describe the relationship between the dependent
variable and the independent variables.  The maximum dimension is min(m-1,p),
where m is the number of categories of the dependent variable and p is the
number of independent variables in the model.  The stereotype model with
maximum dimension is a reparameterization of the multinomial logistic model.

{phang}
{opt baseoutcome(#|lbl)} specifies the outcome level whose scale parameters
and intercept are constrained to be zero.  
The base outcome may be specified as a number or a label.
By default, {opt slogit} assumes that the outcome levels are ordered and uses
the largest level of the dependent variable as the base outcome.

{phang}
{opth constraints(numlist)}; see
{helpb estimation options:[R] Estimation options}.

{pmore}
By default, the linear equality constraints suggested by 
{help slogit##A1984:Anderson (1984)},
termed the corner constraints, are generated for you.  You can add constraints
to these as needed, or you can turn off the corner constraints by specifying
{opt nocorner}. These constraints are in addition to the constraints placed
on the phi parameters corresponding to {opt baseoutcome(#)}.

{phang}
{opt nocorner} specifies that {opt slogit} not generate the corner constraints.
If you specify {opt nocorner}, you must specify
at least {cmd:dimension()}*{cmd:dimension()} 
constraints for the model to be identified.

{dlgtab:SE/Robust}

INCLUDE help vce_asymptall

{pmore}
If specifying {cmd:vce(bootstrap)} or {cmd:vce(jackknife)}, you must also
specify {cmd:baseoutcome()}.

{dlgtab:Reporting}

{phang}
{opt level(#)}, {opt nocnsreport}; see
     {helpb estimation options:[R] Estimation options}.

INCLUDE help displayopts_list

{marker maximize_options}{...}
{dlgtab:Maximization}

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
{opt from(init_specs)};
see {helpb maximize:[R] Maximize}.  These options are seldom used.

{pmore}
Setting the optimization type to {cmd:technique(bhhh)} resets the default
{it:vcetype} to {cmd:vce(opg)}.

{marker initialize}{...}
{phang}
{cmd:initialize(}{opt const:ant}|{opt rand:om}|{opt svd}{cmd:)}
specifies how initial estimates are computed.  The default,
{cmd:initialize(constant)}, is to set the scale parameters to the constant
min(.5,1/d), where d is the dimension specified in {cmd:dimension()}.

{phang2}
{cmd:initialize(random)} requests that 
uniformly distributed random numbers between 0 and 1 be used as initial values
for the scale parameters.  If you specify this option, you should also use
{bind:{cmd:set seed}} to ensure that you can replicate your results; see
{manhelp set_seed R:set seed}.

{phang2}
{cmd:initialize(svd)}
requests that a singular value decomposition (SVD) be performed on the matrix
of regression estimates from {opt mlogit} to reduce its rank to the dimension
specified in {opt dimension()}.  {opt slogit} uses the reduced-rank components
of the SVD as initial estimates for the scale and regression coefficients.
For details, see
{it:{mansection R slogitMethodsandformulas:Methods and formulas}} in
{bf:[R] slogit}.

{phang}
{opt nonormalize} specifies that the numeric variables not be normalized.
Normalization
of the numeric variables improves numerical stability but consumes more
memory in generating temporary double-precision variables.  Variables that are
of type {opt byte} are not normalized, and if initial estimates are specified
using the {opt from()} option, normalization of variables is not performed.
See {it:{mansection R slogitMethodsandformulas:Methods and formulas}} in
{bf:[R] slogit} for more information.

{pstd}
The following options are available with {opt slogit} but are not shown in the
dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Like multinomial logistic and ordered logistic models, stereotype logistic
models are used with categorical dependent variables.  They are often used
when subjects are requested to assess or judge something.  In a multinomial
logistic model, the categories cannot be ranked.  By contrast, in an ordered
logistic model, the categories follow a natural ranking scheme and are subject
to the proportional-odds assumption.  Stereotype logistic regression can be
viewed as a compromise between these two models and is primarily used when
you are unsure of the relevance of the ordering of the outcome.

{pstd}
A common case is when subjects are asked to assess or judge something.  For
example, consider a survey in which consumers are asked to rate the quality of
a product on a scale from 1 to 5, with 1 indicating poor quality and 5
indicating excellent quality.  If the categories are monotonically related to
one underlying latent variable, the ordered logistic model is appropriate.
However, suppose that consumers weigh two or three latent factors when
assessing quality.  The stereotype logistic model is preferred to the ordered
logistic model in this case because it allows you to specify multiple
equations to capture the effects of the latent variables.  Unlike multinomial
logit models, the number of equations you specify could be fewer than m - 1,
where m is the number of categories of the dependent variable.  Stereotype
logistic models are also used when categories may be indistinguishable.
Suppose that a consumer must choose among A, B, C, or D.  Multinomial logistic
modeling assumes that the four choices are distinct in the sense that a
consumer choosing one of the goods can distinguish its characteristics from
the others.  If goods A and B are in fact similar, consumers may be randomly
picking between the two.  One alternative is to combine the two categories and
fit a three-category multinomial logistic model.  A more flexible alternative
is to use a stereotype logistic model.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse auto2yr}{p_end}

{pstd}One-dimensional model{p_end}
{phang2}{cmd:. slogit repair foreign mpg price gratio}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse sysdsn1}{p_end}

{pstd}Saturated, two-dimensional model{p_end}
{phang2}{cmd:. slogit insure age male nonwhite i.site, dim(2) base(1)}
{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:slogit} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_indvars)}}number of independent variables{p_end}
{synopt:{cmd:e(k_out)}}number of outcomes{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(df_m)}}Wald test degrees of freedom{p_end}
{synopt:{cmd:e(df_0)}}null model degrees of freedom{p_end}
{synopt:{cmd:e(k_dim)}}model dimension{p_end}
{synopt:{cmd:e(i_base)}}base outcome index{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(ll_0)}}null model log likelihood{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:slogit}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(indvars)}}independent variables{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(out}{it:#}{cmd:)}}outcome labels, {it:#} = 1, ..., {cmd:e(k_out)}{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test {p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
                         maximization or minimization{p_end}
{synopt:{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt:{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsdefault)}}default {opt predict()} specification for {cmd:margins}{p_end}
{synopt:{cmd:e(footnote)}}program used to implement the footnote display{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(outcomes)}}outcome values{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker reference}{...}
{title:Reference}

{marker A1984}{...}
{phang}
Anderson, J. A. 1984. Regression and ordered categorical variables
(with discussion).
{it:Journal of the Royal Statistical Society, Series B} 46: 1-30.
{p_end}
