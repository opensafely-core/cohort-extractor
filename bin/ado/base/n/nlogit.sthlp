{smcl}
{* *! version 1.8.1  07feb2020}{...}
{viewerdialog nlogit "dialog nlogit"}{...}
{viewerdialog nlogitgen "dialog nlogitgen"}{...}
{viewerdialog nlogittree "dialog nlogittree"}{...}
{vieweralsosee "[CM] nlogit" "mansection CM nlogit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[CM] nlogit postestimation" "help nlogit postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[CM] cmclogit" "help cmclogit"}{...}
{vieweralsosee "[CM] cmmixlogit" "help cmmixlogit"}{...}
{vieweralsosee "[CM] cmmprobit" "help cmmprobit"}{...}
{vieweralsosee "[R] clogit" "help clogit"}{...}
{vieweralsosee "[R] mlogit" "help mlogit"}{...}
{vieweralsosee "[R] mprobit" "help mprobit"}{...}
{vieweralsosee "[R] ologit" "help ologit"}{...}
{vieweralsosee "[R] slogit" "help slogit"}{...}
{viewerjumpto "Syntax" "nlogit##syntax"}{...}
{viewerjumpto "Menu" "nlogit##menu"}{...}
{viewerjumpto "Description" "nlogit##description"}{...}
{viewerjumpto "Links to PDF documentation" "nlogit##linkspdf"}{...}
{viewerjumpto "Options" "nlogit##options"}{...}
{viewerjumpto "Remark on degenerate branches" "nlogit##remark"}{...}
{viewerjumpto "Examples" "nlogit##examples"}{...}
{viewerjumpto "Stored results" "nlogit##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[CM] nlogit} {hline 2}}Nested logit regression{p_end}
{p2col:}({mansection CM nlogit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Nested logit regression

{p 8 15 2}
{cmd:nlogit} {depvar} [{indepvars}] {ifin}
[{it:{help nlogit##weight:weight}}]
	[{cmd:||} {it:lev1_equation} [{cmd:||} {it:lev2_equation} ...]] 
	{cmd:||} {it:{help nlogit##altvar:altvar}}{cmd::}
        [{it:{help nlogit##byaltvarlist:byaltvarlist}}]{cmd:,}
	{opth case(varname)} [{it:{help nlogit##options_table:nlogit_options}}]

{pin}
where the syntax of {it:{help nlogit##lev#_equation:lev#_equation}} is

{p 12 24 2}
	{it:{help nlogit##altvar:altvar}}{cmd::} 
	[{it:{help nlogit##byaltvarlist:byaltvarlist}}] 
		[{cmd:,} {opt base(#|lbl)} {opt estc:onst}]


{phang}
Create variable based on specification of branches{p_end}

{p 8 18 2}
{cmd:nlogitgen} {it:{help nlogit##newaltvar:newaltvar}} {cmd:=}
                {it:{help nlogit##newaltvar:altvar}}
{cmd:(}{it:branchlist}{cmd:)} [{cmd:,} [{cmd:no}]{cmd:log}]

{pin}{marker branchlist}
where {it:branchlist} is{p_end}

{p 12 12 2}{it:branch}{cmd:,} {it:branch} [{cmd:,} {it:branch ...}]

{pin}
and {it:branch} is{p_end}

{p 12 12 2}[{it:{help nlogit##label:label}}{cmd::}] 
{it:{help nlogit##alternative:alternative}} [{cmd:|} {it:alternative}
[{cmd:|} {it:alternative ...}] ]


{phang}
Display tree structure

{p 8 19 2}
{cmd:nlogittree} {it:{help nlogit##altvarlist:altvarlist}} {ifin} 
[{it:{help nlogit##weight:weight}}]
   [{cmd:,} {it:{help nlogit##nlogittree_options:nlogittree_options}}]


{marker options_table}{...}
{synoptset 26 tabbed}{...}
{synopthdr:nlogit_options}
{synoptline}
{syntab :Model}
{p2coldent :* {opth case(varname)}}use {it:varname} to identify cases{p_end}
{synopt: {opt base(#|lbl)}}use the specified level or label of
    {it:{help nlogit##altvar:altvar}} as 
the base alternative for the bottom level{p_end}
{synopt: {opt nocons:tant}}suppress the constant terms for the bottom-level
alternatives{p_end}
{synopt :{opt nonn:ormalized}}use the nonnormalized
parameterization{p_end}
{synopt :{opt altwise}}use alternativewise deletion instead of casewise
	deletion{p_end}
{synopt :{cmdab:const:raints(}{it:{help nlogit##constraints:constraints}}{cmd:)}}apply
specified linear constraints{p_end}

{syntab :SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
{opt r:obust}, {opt cl:uster} {it:clustvar}, {opt boot:strap}, or
{opt jack:knife}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt notr:ee}}suppress display of tree-structure output;
see also {helpb nlogit##treedisp:nolabel} and 
{helpb nlogit##treedisp:nobranches}{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help nlogit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab :Maximization}
{synopt :{it:{help nlogit##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt: {opt col:linear}}keep collinear variables{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}* {opt case(varname)} is required.{p_end}

{marker nlogittree_options}{...}
{synoptset 26 tabbed}{...}
{synopthdr:nlogittree_options}
{synoptline}
{syntab :Main}
{synopt:{opth cho:ice(depvar)}}use {it:depvar} as the choice indicator variable{p_end}
{synopt:{opth case(varname)}}use {it:varname} to identify cases{p_end}
{synopt: {opth gen:erate(newvar)}}create {it:newvar} to identify invalid observations{p_end}
{synopt: {opt nolab:el}}suppress the value labels in tree-structure output{p_end}
{synopt :{opt nobranch:es}}suppress drawing branches in the tree-structure output{p_end}
{synoptline}
{p2colreset}{...}

{p 4 6 2}{it:byaltvarlist} may contain factor variables; see {help fvvarlist}.
{p_end}
{p 4 6 2}{cmd:bootstrap}, {cmd:by}, {cmd:fp}, {cmd:jackknife}, and
{cmd:statsby} are allowed; see {help prefix}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{marker weight}{...}
{p 4 6 2}{cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s are allowed 
with {cmd:nlogit}, and {cmd:fweight}s are allowed with {cmd:nlogittree}; 
see {help weight}.  Weights for {cmd:nlogit} must be constant within case.
{p_end}
{p 4 6 2}
{opt collinear} does not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp nlogit_postestimation CM:nlogit postestimation} for
features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

    {title:nlogit}

{phang2}
{bf:Statistics > Choice models > Nested logit model > Nested logit model}

    {title:nlogitgen}

{phang2}
{bf:Statistics > Choice models > Nested logit model > Setup for nested logit model}

    {title:nlogittree}

{phang2}
{bf:Statistics > Choice models > Nested logit model > Display nested logit tree structure}


{marker description}{...}
{title:Description}

{pstd}
{cmd:nlogit} performs full information maximum-likelihood estimation for
nested logit models.  These models relax the assumption of independently
distributed errors and the independence of irrelevant alternatives
inherent in conditional and multinomial logit models by clustering
similar alternatives into nests.

{pstd}
By default, {cmd:nlogit} uses a parameterization that is consistent with
a random utility model (RUM).  Before version 10 of Stata, a
nonnormalized version of the nested logit model was fit, which you can
request by specifying the {opt nonnormalized} option.

{pstd}
You must use {cmd:nlogitgen} to generate a new categorical variable
to specify the branches of the nested logit tree before calling {cmd:nlogit}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection CM nlogitQuickstart:Quick start}

        {mansection CM nlogitRemarksandexamples:Remarks and examples}

        {mansection CM nlogitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{marker lev#_equation}{...}
    {title:Specification and options for lev#_equation}

{marker altvar}{...}
{phang}
{it:altvar} is a variable identifying alternatives at this level of the
hierarchy.

{marker byaltvarlist}{...}
{phang}
{it:byaltvarlist} specifies the variables to be used to compute the
by-alternative regression coefficients for that level.  For each variable
specified in the variable list, there will be one regression coefficient for
each alternative of that level of the hierarchy.  If the variable is constant
across each alternative (a case-specific variable), the regression coefficient
associated with the base alternative is not identifiable.  These regression
coefficients are labeled as (base) in the regression table.  If the variable
varies among the alternatives, a regression coefficient is estimated for each
alternative.

{phang} {marker base}{...}
{opt base(#|lbl)} can be specified in each level equation where it 
identifies the base alternative to be used at that level.
The default is the alternative that has the highest frequency.

{pmore}
If {cmd:vce(bootstrap)} or {cmd:vce(jackknife)} is specified, you must specify
the base alternative for each level that has a 
{it:byaltvarlist} or whether the
constants will be estimated.  Doing so ensures that the same model is fit
with each call to {cmd:nlogit}.

{phang} {marker estc}{...}
{opt estconst} applies to all the level equations except the
bottom-level equation.  Specifying {cmd:estconst} requests that constants for
each alternative (except the base alternative) be estimated.  By default, no
constant is estimated at these levels.  Constants can be estimated in only one
level of the tree hierarchy.  If you specify {cmd:estconst} for one of the
level equations, you must specify {cmd:noconstant} for the bottom-level
equation.


    {title:Options for nlogit}

{dlgtab:Model}

{phang}
{opth case(varname)} specifies the variable that identifies each case.
{opt case()} is required.

{phang} {marker base}{...}
{opt base(#|lbl)} can be specified in each level equation where it 
identifies the base alternative to be used at that level.
The default is the alternative that has the highest frequency.

{pmore}
If {cmd:vce(bootstrap)} or {cmd:vce(jackknife)} is specified, you must specify
the base alternative for each level that has a
{it:{help nlogit##byaltvarlist:byaltvarlist}} or whether the
constants will be estimated.  Doing so ensures that the same model is fit
with each call to {cmd:nlogit}.

{phang}
{opt noconstant} applies only to the equation defining
the bottom level of the hierarchy.  By default, constants are estimated for each
alternative of {it:{help nlogit##altvar:altvar}}, less the base alternative.
To suppress the constant terms for this level, specify {cmd:noconstant}.  If
you do not specify {cmd:noconstant}, you cannot specify {cmd:estconst} for the
higher-level equations.

{phang}
{opt nonnormalized} requests a nonnormalized parameterization
of the model that does not scale the inclusive values by the degree of
dissimilarity of the alternatives within each nest.  Use this option to
replicate results from older versions of Stata.  The default is to use
the RUM-consistent parameterization.

{phang}
{opt altwise} specifies that alternativewise deletion be used when omitting
observations because of missing values in your variables.  The default is to
use casewise deletion; that is, the entire group of observations making up a
case is omitted if any missing values are encountered.  This option does not
apply to observations that are excluded by the {cmd:if} or {cmd:in} qualifier
or the {cmd:by} prefix; these observations are always handled alternativewise
regardless of whether {cmd:altwise} is specified.

{phang} {marker constraints}{...}
{opt constraints(constraints)}; see 
{helpb estimation options##constraints():[R] Estimation options}.

{pmore}
The inclusive-valued/dissimilarity parameters are parameterized as {cmd:ml}
ancillary parameters.  They are labeled as [{it:alternative}_tau]_const, where
{it:alternative} is one of the alternatives defining a branch in the tree.  To
constrain the inclusive-valued/dissimilarity parameter for alternative 
{cmd:a1} to be, say, equal to alternative {cmd:a2}, you would use the
following syntax:

{phang3}{cmd:. constraint 1 [a1_tau]_cons = [a2_tau]_cons}

{phang3}{cmd:. nlogit ... , constraints(1)}

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are derived from asymptotic theory ({cmd:oim}),
that are robust to some kinds of misspecification ({cmd:robust}), that allow
for intragroup correlation ({cmd:cluster} {it:clustvar}), and that use
bootstrap or jackknife methods ({cmd:bootstrap}, {cmd:jackknife}); see
{helpb vce_option:[R] {it:vce_option}}.

{pmore}
If {cmd:vce(robust)} or {cmd:vce(cluster} {it:clustvar}{cmd:)} is specified,
the likelihood-ratio test for the independence of irrelevant alternatives
(IIA) is not computed.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] Estimation options}.

{phang}
{opt notree} specifies that the tree structure of the nested logit
model not be displayed. 
See also {helpb nlogit##treedisp:nolabel} and 
{helpb nlogit##treedisp:nobranches} for when {opt notree} is not
specified.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] Estimation options}.

INCLUDE help displayopts_list

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}:
{opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)}, [{cmd:no}]{opt log}, {opt tr:ace}, 
{opt grad:ient}, {opt showstep},
{opt hess:ian},
{opt showtol:erance},
{opt tol:erance(#)},
{opt ltol:erance(#)}, {opt nrtol:erance(#)},
{opt nonrtol:erance}, and
{opt from(init_specs)}; see {helpb maximize:[R] Maximize}.
These options are seldom used.

{pmore}
The {cmd:technique(bhhh)} option is not allowed.
The default optimization technique is {cmd:technique(bfgs)}.

{pstd}
The following option is available with {opt nlogit} but is not shown in the
dialog box:

{phang} 
{opt collinear} prevents collinear variables from being dropped.  Use this
option when you know that you have collinear variables and you are applying
{cmd:constraints()} to handle the rank reduction.  See
{helpb estimation options##collinear:[R] Estimation options} for details on
using {cmd:collinear} with {cmd:constraints()}.

{pmore}
{cmd:nlogit} will not allow you to specify an independent variable in more than
one level equation.  Specifying the {opt collinear} option will allow execution
to proceed in this case, but it is your responsibility to ensure that the
parameters are identified.


    {title:Specification and options for nlogitgen}

{marker newaltvar}{...}
{phang}
{it:newaltvar} and {it:altvar} are variables identifying alternatives at each
level of the hierarchy.

{phang} {marker label}{...}
{it:label} defines a label to associate with the branch.  If no label
is given, a numeric value is used.

{phang} {marker alternative}{...}
{it:alternative} specifies an alternative, of {it:altvar} specified in the
syntax, to be included in the branch.  It is either a numeric value or the
label associated with that value.  An example of {cmd:nlogitgen} is

{phang2}{cmd}. nlogitgen type = restaurant({bind:fast: 1 | 2,}
{bind:family: CafeEccell | LosNortenos | WingsNmore,} {bind:fancy: 6 | 7)}{txt}

{phang}
INCLUDE help lognolog


{marker treedisp}{...}
    {title:Specification and options for nlogittree}

{dlgtab:Main}

{marker altvarlist}{...}
{phang}
{it:altvarlist} is a list of alternative variables that define the tree
hierarchy.  The first variable must define bottom-level alternatives, and the
order continues to the variable defining the top-level alternatives.

{phang}
{opth choice(depvar)} defines the choice indicator variable and forces
{cmd:nlogittree} to compute and display choice frequencies for each 
bottom-level alternative.

{phang}
{opth case(varname)} specifies the variable that identifies each case.  When
both {cmd:case()} and {cmd:choice()} are specified, {cmd:nlogittree} executes
diagnostics on the tree structure and identifies observations that will cause
{cmd:nlogit} to terminate execution or drop observations.

{phang}
{opth generate(newvar)} generates a new indicator variable, {it:newvar}, that
is equal to 1 for invalid observations.  This option requires that both
{cmd:choice()} and {cmd:case()} are also specified.

{phang}
{opt nolabel} forces {cmd:nlogittree} to suppress value labels in 
tree-structure output.

{phang}
{opt nobranches} forces {cmd:nlogittree} to suppress drawing branches in 
the tree-structure output.


{marker remark}{...}
{marker degen_tau}{...}
{title:Remark on degenerate branches}

{pstd}
Degenerate nests occur when there is only one alternative in a branch of the
tree hierarchy.  The associated dissimilarity parameter of the RUM is not
defined.  The inclusive-valued parameter of the nonnormalized model will be
identifiable if there are alternative-specific variables specified in equation
1 of the model specification (the {it:indepvars} in the model syntax).
Numerically you can skirt the issue of nonidentifiable/undefined parameters by
setting constraints on them.  For the RUM constraint, set the
dissimilarity parameter to 1.  See {help nlogit##constraints:constraints} for
details on setting constraints on the dissimilarity parameters.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse restaurant}
 
{pstd}
Generate a new categorical variable named {hi:type} that identifies the
first-level set of alternatives based on the variable named {hi:restaurant}
{p_end}
{phang2}{cmd:. nlogitgen type = restaurant(fast: Freebirds | MamasPizza, family:  CafeEccell | LosNortenos | WingsNmore, fancy: Christophers | MadCows)}

{pstd}
Examine the tree structure{p_end}
{phang2}{cmd:. nlogittree restaurant type, choice(chosen) case(family_id)}

{pstd}Perform nested logit regression{p_end}
{phang2}{cmd:. nlogit chosen cost distance rating || type: income kids, base(family) || restaurant:, noconst case(family_id)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:nlogit} stores the following in {cmd:e()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_case)}}number of cases{p_end}
{synopt:{cmd:e(N_ic)}}N for Bayesian information criterion (BIC){p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_alt)}}number of alternatives for bottom level{p_end}
{synopt:{cmd:e(k_alt}{it:j}{cmd:)}}number of alternatives for {it:j}th
                     level{p_end}
{synopt:{cmd:e(k_indvars)}}number of independent variables{p_end}
{synopt:{cmd:e(k_ind2vars)}}number of by-alternative variables for
                     bottom level{p_end}
{synopt:{cmd:e(k_ind2vars}{it:j}{cmd:)}}number of by-alternative
                     variables for {it:j}th level{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(df_c)}}{cmd:clogit} model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(ll_c)}}{cmd:clogit} model log likelihood{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(chi2_c)}}likelihood-ratio test for IIA{p_end}
{synopt:{cmd:e(p)}}p-value for model Wald test{p_end}
{synopt:{cmd:e(p_c)}}p-value for IIA test{p_end}
{synopt:{cmd:e(i_base)}}base index for bottom level{p_end}
{synopt:{cmd:e(i_base}{it:j}{cmd:)}}base index for {it:j}th level{p_end}
{synopt:{cmd:e(levels)}}number of levels{p_end}
{synopt:{cmd:e(alt_min)}}minimum number of alternatives{p_end}
{synopt:{cmd:e(alt_avg)}}average number of alternatives{p_end}
{synopt:{cmd:e(alt_max)}}maximum number of alternatives{p_end}
{synopt:{cmd:e(const)}}constant indicator for bottom level{p_end}
{synopt:{cmd:e(const}{it:j}{cmd:)}}constant indicator for {it:j}th level{p_end}
{synopt:{cmd:e(rum)}}{cmd:1} if RUM, {cmd:0} otherwise{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{p2col 5 25 29 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:nlogit}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(indvars)}}name of independent variables{p_end}
{synopt:{cmd:e(ind2vars)}}by-alternative variables for bottom level{p_end}
{synopt:{cmd:e(ind2vars}{it:j}{cmd:)}}by-alternative variables for {it:j}th level{p_end}
{synopt:{cmd:e(case)}}variable defining cases{p_end}
{synopt:{cmd:e(altvar)}}alternative variable for bottom level{p_end}
{synopt:{cmd:e(altvar}{it:j}{cmd:)}}alternative variable for {it:j}th level{p_end}
{synopt:{cmd:e(alteqs)}}equation names for bottom level{p_end}
{synopt:{cmd:e(alteqs}{it:j}{cmd:)}}equation names for {it:j}th level{p_end}
{synopt:{cmd:e(alt}{it:i}{cmd:)}}{it:i}th alternative for bottom level{p_end}
{synopt:{cmd:e(alt}{it:j}{cmd:_}{it:i}{cmd:)}}{it:i}th alternative for {it:j}th level{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt :{cmd:e(marktype)}}{cmd:casewise} or {cmd:altwise}, type of
markout{p_end}
{synopt :{cmd:e(key_N_ic)}}{cmd:cases}, key for N for Bayesian information
criterion (BIC){p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}, type of model chi-squared test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
                         maximization or minimization{p_end}
{synopt:{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt:{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(datasignature)}}the checksum{p_end}
{synopt:{cmd:e(datasignaturevars)}}variables used in calculation of checksum{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 25 29 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(k_altern)}}number of alternatives at each level{p_end}
{synopt:{cmd:e(k_branch}{it:j}{cmd:)}}number of branches at each alternative of
             {it:j}th level{p_end}
{synopt:{cmd:e(stats)}}alternative statistics for bottom level{p_end}
{synopt:{cmd:e(stats}{it:j}{cmd:)}}alternative statistics for {it:j}th level{p_end}
{synopt:{cmd:e(altidx}{it:j}{cmd:)}}alternative indices for {it:j}th level{p_end}
{synopt:{cmd:e(alt_ind2vars)}}indicators for bottom level estimated by-alternative variable -- {cmd:e(k_alt)} x {cmd:e(k_ind2vars)}{p_end}
{synopt:{cmd:e(alt_ind2vars}{it:j}{cmd:)}}indicators for {it:j}th level estimated by-alternative variable -- {cmd:e(k_alt}{it:j}{cmd:)} x {cmd:e(k_ind2vars}{it:j}{cmd:)}{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{p2col 5 25 29 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
