{smcl}
{* *! version 1.0.12  12dec2018}{...}
{viewerdialog eteffects "dialog eteffects"}{...}
{vieweralsosee "[TE] eteffects" "mansection TE eteffects"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] eteffects postestimation" "help eteffects postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] etregress" "help etregress"}{...}
{vieweralsosee "[R] gmm" "help gmm"}{...}
{vieweralsosee "[R] probit" "help probit"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[TE] teffects" "help teffects"}{...}
{viewerjumpto "Syntax" "eteffects##syntax"}{...}
{viewerjumpto "Menu" "eteffects##menu"}{...}
{viewerjumpto "Description" "eteffects##description"}{...}
{viewerjumpto "Links to PDF documentation" "eteffects##linkspdf"}{...}
{viewerjumpto "Options" "eteffects##options"}{...}
{viewerjumpto "Examples" "eteffects##examples"}{...}
{viewerjumpto "Stored results" "eteffects##results"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[TE] eteffects} {hline 2}}Endogenous treatment-effects
estimation{p_end}
{p2col:}({mansection TE eteffects:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:eteffects} {cmd:(}{help varlist:{it:ovar}}
{help varlist:{it:omvarlist}}
[{cmd:,} {help eteffects##omodel:{it:omodel}}
        {opt nocons:tant}]{cmd:)}
        {cmd:(}{help varlist:{it:tvar}} {help varlist:{it:tmvarlist}}
        [{cmd:,} {opt nocons:tant}]{cmd:)}
        {ifin} 
        [{help eteffects##weight:{it:weight}}]
        [{cmd:,}
        {help eteffects##stat:{it:stat}}
        {help eteffects##opttable:{it:options}}]

{phang}
{it:ovar} is the {depvar} of the outcome model. 

{phang}
{it:omvarlist} is the list of exogenous {indepvars} in the outcome model. 

{phang}
{it:tvar} is the binary treatment variable.  

{phang}
{it:tmvarlist} is the list of covariates that predict treatment assignment.

{marker omodel}{...}
{synoptset 20 tabbed}{...}
{synopthdr:omodel}
{synoptline}
{syntab :Model}
{synopt :{opt linear}}linear outcome model; the default{p_end}
{synopt :{opt fractional}}fractional probit outcome model{p_end}
{synopt :{opt probit}}probit outcome model{p_end}
{synopt :{opt exponential}}exponential-mean outcome model{p_end}
{synoptline}

{marker stat}{...}
{synopthdr:stat}
{synoptline}
{syntab :Model}
{synopt :{opt ate}}estimate average treatment effect in population; the
default{p_end}
{synopt :{opt atet}}estimate average treatment effect on the treated{p_end}
{synopt :{opt pom:eans}}estimate potential-outcome means{p_end}
{synoptline}

{marker opttable}{...}
{synopthdr}
{synoptline}
{syntab :Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}

{syntab :SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be
   {opt r:obust}, {opt cl:uster} {it:clustvar},
   {opt boot:strap}, or {opt jack:knife}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}
{synopt :{opt aeq:uations}}display auxiliary-equation
results{p_end}
{synopt :{it:{help eteffects##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab :Maximization}
{synopt :{it:{help eteffects##maximize_options:maximize_options}}}control
the maximization process; seldom used{p_end}

{syntab :Advanced}
{synopt :{opt pstol:erance(#)}}set tolerance for overlap assumption{p_end}
{synopt :{opth os:ample(newvar)}}generate {it:newvar} to mark observations
that violate the overlap assumption{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p 4 6 2}{it:omvarlist} and {it:tmvarlist} may contain
factor variables; see {help fvvarlists}.{p_end}
{p 4 6 2}{cmd:bootstrap}, {cmd:by}, {cmd:jackknife}, and {cmd:statsby} are
allowed; see {help prefix}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{marker weight}{...}
{p 4 6 2}{cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s are allowed; see
{help weight}.{p_end}
{p 4 6 2}{cmd:coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp eteffects_postestimation TE: eteffects postestimation}
for features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Treatment effects > Endogenous treatment >}
    {bf:Control function estimator > Continuous outcomes}

{phang}
{bf:Statistics > Treatment effects > Endogenous treatment >}
    {bf:Control function estimator > Binary outcomes}

{phang}
{bf:Statistics > Treatment effects > Endogenous treatment >}
    {bf:Control function estimator > Count outcomes}

{phang}
{bf:Statistics > Treatment effects > Endogenous treatment >}
    {bf:Control function estimator > Fractional outcomes}

{phang}
{bf:Statistics > Treatment effects > Endogenous treatment >}
    {bf:Control function estimator > Nonnegative outcomes}


{marker description}{...}
{title:Description}

{pstd}
{cmd:eteffects} estimates the average treatment effect (ATE), the
average treatment effect on the treated (ATET), and the
potential-outcome means (POMs) from observational data when treatment
assignment is correlated with the potential outcomes.  It allows for
continuous, binary, count, fractional, and nonnegative outcomes and requires a
binary treatment.  To control for the endogeneity of the treatment assignment,
the estimator includes residuals from the treatment model in the models for
the potential outcomes, known as a control-function approach.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TE eteffectsQuickstart:Quick start}

        {mansection TE eteffectsRemarksandexamples:Remarks and examples}

        {mansection TE eteffectsMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{cmd:noconstant}; see
{helpb estimation options:[R] Estimation options}.

{phang}
{it:stat} is one of three statistics: {cmd:ate}, {cmd:atet}, or {cmd:pomeans}.
{cmd:ate} is the default.

{phang2}
{cmd:ate} specifies that the average treatment effect be estimated.

{phang2}
{cmd:atet} specifies that the average treatment effect on the treated be
estimated.

{phang2}
{cmd:pomeans} specifies that the potential-outcome means for each treatment
level be estimated.

{dlgtab:SE/Robust}

INCLUDE help vce_rcbj

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

{phang}
{cmd:aequations} specifies that the results for the outcome-model or the
treatment-model parameters be displayed.  By default, the results for these
auxiliary parameters are not displayed.

{marker display_options}{...}
INCLUDE help displayopts_list

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}: 
{opt iter:ate(#)},
[{cmd:no}]{opt log}, 
and
{opt from(init_specs)}; see {helpb maximize:[R] Maximize}.
These options are seldom used.

{pmore}
{it:init_specs} is one of

{phang3}
{it:matname} [{cmd:, skip copy}]

{phang3}
{it:#} [{cmd:,} {it:#} ...]{cmd:, copy}

{dlgtab:Advanced}

{phang}
{opt pstolerance(#)} specifies the tolerance used to check the overlap
assumption. The default value is {cmd:pstolerance(1e-5)}.  {cmd:eteffects} will
exit with an error if an observation has an estimated propensity score smaller
than that specified by {cmd:pstolerance()}.

{phang}
{opth osample(newvar)} specifies that indicator variable {it:newvar} be
created to identify observations that violate the overlap assumption.

{pstd}
The following option is available with {opt eteffects} but is not shown
in the dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse cattaneo2}

{pstd}Estimate the ATE of smoking status on baby's birthweight{p_end}
{phang2}{cmd:. eteffects (bweight i.prenatal1 i.mmarried mage i.fbaby)}
          {cmd:(mbsmoke i.mmarried mage i.fbaby medu fedu)}

{pstd}Same as above, but estimate the ATET{p_end}
{phang2}{cmd:. eteffects (bweight i.prenatal1 i.mmarried mage i.fbaby)}
          {cmd:(mbsmoke i.mmarried mage i.fbaby medu fedu), atet}

{pstd}Display auxiliary parameters used to compute ATET{p_end}
{phang2}{cmd:. eteffects, aeq}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse nlsy80}

{pstd}Estimate the ATE of living in an urban area on monthly earnings,
assuming that earnings, conditional on covariates, follow an exponential
mean{p_end}
{phang2}{cmd:. eteffects (wage exper iq i.college, exponential nocons)}
          {cmd:(urban i.college fcollege)}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{opt eteffects} stores the following in {opt e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(n}{it:j}{cmd:)}}number of observations for treatment level {it:j}{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_levels)}}number of levels in treatment variable{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:eteffects}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of outcome variable{p_end}
{synopt:{cmd:e(tvar)}}name of treatment variable{p_end}
{synopt:{cmd:e(omodel)}}{cmd:fractional}, {cmd:linear}, {cmd:probit}, or {cmd:exponential}{p_end}
{synopt:{cmd:e(stat)}}statistic estimated, {cmd:ate}, {cmd:atet}, or {cmd:pomeans}{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(tlevels)}}levels of treatment variable{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as
{cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as
{cmd:asobserved}{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{p2col 5 20 24 2:Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
