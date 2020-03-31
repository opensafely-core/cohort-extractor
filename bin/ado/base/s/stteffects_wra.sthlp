{smcl}
{* *! version 1.0.18  12dec2018}{...}
{viewerdialog stteffects "dialog stteffects, __message(-wra_survival-)"}{...}
{vieweralsosee "[TE] stteffects wra" "mansection TE stteffectswra"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] stteffects postestimation" "help stteffects postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] stteffects intro" "help stteffects intro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] streg" "help streg"}{...}
{vieweralsosee "[ST] stset" "help stset"}{...}
{viewerjumpto "Syntax" "stteffects wra##syntax"}{...}
{viewerjumpto "Menu" "stteffects wra##menu"}{...}
{viewerjumpto "Description" "stteffects wra##description"}{...}
{viewerjumpto "Links to PDF documentation" "stteffects_wra##linkspdf"}{...}
{viewerjumpto "Options" "stteffects wra##options"}{...}
{viewerjumpto "Examples" "stteffects wra##examples"}{...}
{viewerjumpto "Stored results" "stteffects wra##results"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[TE] stteffects wra} {hline 2}}Survival-time weighted
regression adjustment{p_end}
{p2col:}({mansection TE stteffectswra:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:stteffects} {cmd:wra}
   {cmd:(}{it:omvarlist}
      [{cmd:,} {it:{help stteffects wra##omoptions:omoptions}}]{cmd:)}
      {cmd:(}{it:tvar}{cmd:)}
	{cmd:(}{it:cmvarlist}
	[{cmd:,} {it:{help stteffects wra##cmoptions:cmoptions}}]{cmd:)}
	{ifin} 
     [{cmd:,}
          {it:{help stteffects wra##stat:stat}}
          {it:{help stteffects wra##options_table:options}}]


{phang}
{it:omvarlist} specifies the variables that predict the survival-time
variable in the outcome model.

{phang}
{it:tvar} must contain integer values representing the treatment levels.

{phang}
{it:cmvarlist} specifies the variables that predict censoring in the
censoring
model.

{synoptset 34 tabbed}{...}
{marker omoptions}{...}
{synopthdr:omoptions}
{synoptline}
{syntab:Model}
{synopt :{opt weib:ull}}Weibull; the default{p_end}
{synopt :{opt exp:onential}}exponential{p_end}
{synopt :{opt gam:ma}}two-parameter gamma{p_end}
{synopt :{opt ln:ormal}}lognormal{p_end}
{synopt :{cmd:ancillary(}{it:avarlist}[{cmd:,} {opt nocons:tant}]{cmd:)}}specify
variables used to model ancillary parameter{p_end}
{synopt :{opt nocons:tant}}suppress constant from outcome model{p_end}
{synoptline}

{marker cmoptions}{...}
{synopthdr:cmoptions}
{synoptline}
{syntab:Model}
{synopt :{opt weib:ull}}Weibull; the default{p_end}
{synopt :{opt exp:onential}}exponential{p_end}
{synopt :{opt gam:ma}}two-parameter gamma{p_end}
{synopt :{opt ln:ormal}}lognormal{p_end}
{synopt :{cmd:ancillary(}{it:avarlist}[{cmd:,} {opt nocons:tant}]{cmd:)}}specify variables used to model ancillary parameter{p_end}
{synopt :{opt nocons:tant}}suppress constant from censoring model{p_end}
{synoptline}

{marker stat}{...}
{synopthdr:stat}
{synoptline}
{syntab:Stat}
{synopt :{opt ate}}estimate average treatment effect in population; the
default{p_end}
{synopt :{opt atet}}estimate average treatment effect on the treated{p_end}
{synopt :{opt pom:eans}}estimate potential-outcome means{p_end}
{synoptline}

{marker options_table}{...}
{synopthdr}
{synoptline}
{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt r:obust}, 
	{opt cl:uster} {it:clustvar},
	{opt boot:strap}, or {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt aeq:uations}}display auxiliary-equation results{p_end}
{synopt :{opt nosh:ow}}do not show st setting information{p_end}
{synopt :{it:{help stteffects wra##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt :{it:{help stteffects wra##maximize_options:maximize_options}}}control
the maximization process; seldom used{p_end}
{synopt :{opt iterinit(#)}}specify starting-value iterations; seldom used{p_end}

{syntab:Advanced}
{synopt :{opt pstol:erance(#)}}set tolerance for overlap assumption{p_end}
{synopt :{opth os:ample(newvar)}}identify observations that
violate the overlap assumption{p_end}
{synopt :{opt con:trol(#|label)}}specify the level of {it:tvar} that is the
control{p_end}
{synopt :{opt tle:vel(#|label)}}specify the level of {it:tvar} that is the
treatment{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{p 4 6 2}
You must {cmd:stset} your data before using {cmd:stteffects}; see
{manhelp stset ST}.{p_end}
{p 4 6 2}
{it:omvarlist},
{it:cmvarlist}, and
{it:avarlist}
may contain factor variables; see {help fvvarlists}.{p_end}
{p 4 6 2}
{opt bootstrap}, {opt by}, {opt jackknife}, and {opt statsby} are allowed;
see {help prefix}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s, {opt iweight}s, and {opt pweight}s may be specified using
{cmd:stset}; see {it:{mansection ST stsetRemarksandexamplesWeights:Weights}}
under {it:Remarks and examples} in {bf:[ST] stset}.  However, weights may not
be specified if you are using the {cmd:bootstrap} prefix.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp stteffects_postestimation TE:stteffects postestimation} for
features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Treatment effects > Survival outcomes >}
             {bf:Weighted regression adjustment}


{marker description}{...}
{title:Description}

{pstd}
{cmd:stteffects wra} estimates the average treatment effect, the average
treatment effect on the treated, and the potential-outcome means from
observational survival-time data with random time to censoring.  Estimation is
by weighted regression adjustment (WRA).  WRA estimators use
inverse-probability-of-censoring adjusted regression coefficients to compute
averages of treatment-level predicted outcomes.  Contrasts of these averages
estimate the treatment effects.  WRA uses estimated weights from a
time-to-censoring model to account for censored survival times instead of
including a term in the likelihood function.  {cmd:stteffects wra} offers
several choices for the functional forms of the outcome model and the
time-to-censoring model.  Binary and multivalued treatments are accommodated.

{pstd}
See {manhelp stteffects_intro TE:stteffects intro} for an overview of
estimating treatment effects from observational survival-time data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TE stteffectswraQuickstart:Quick start}

        {mansection TE stteffectswraRemarksandexamples:Remarks and examples}

        {mansection TE stteffectswraMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{cmd:ancillary(}{it:avarlist}[{cmd:, noconstant}]{cmd:)} specifies the
variables used to model the ancillary parameter.  By default, the ancillary
parameter does not depend on covariates.  Specifying
{cmd:ancillary(}{it:avarlist}{cmd:,} {cmd:noconstant)} causes the constant to
be suppressed in the model for the ancillary parameter.

{pmore}
{cmd:ancillary()} may be specified for the model for survival-time outcome,
for the model for the censoring variable, or for both.  If {cmd:ancillary()}
is specified for both, the varlist used for each model may be different.

{phang}
{opt noconstant}; see
{helpb estimation options:[R] Estimation options}.

{dlgtab:Stat}

{phang}
{it:stat} is one of three statistics: {cmd:ate}, {cmd:atet}, or {cmd:pomeans}.
{cmd:ate} is the default.

{pmore}
{cmd:ate} specifies that the average treatment effect be estimated.

{pmore}
{cmd:atet} specifies that the average treatment effect on the treated be
estimated.

{pmore}
{cmd:pomeans} specifies that the potential-outcome means for each treatment
level be estimated.

{dlgtab:SE/Robust}

INCLUDE help vce_rcbj

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
    {helpb estimation options:[R] Estimation options}.

{phang}
{cmd:aequations} specifies that the results for the outcome-model or the
treatment-model parameters be displayed.  By default, the results for these
auxiliary parameters are not displayed.

{phang}
{cmd:noshow} prevents {cmd:stteffects wra} from showing the key st variables.
This option is rarely used because most people type {cmd:stset, show} or
{cmd:stset, noshow} to permanently set whether they want to see these
variables mentioned at the top of the output of every st command; see 
{manhelp stset ST}.

INCLUDE help displayopts_list

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}:
{opt  iter:ate(#)},
[{cmd:no}]{opt log},
and
{opt from(init_specs)}; see {helpb maximize:[R] Maximize}.
These options are seldom used.

{pmore}
{it:init_specs} is one of

{pmore2}
{it:matname} [{cmd:,} {cmd:skip} {cmd:copy}]

{pmore2}
{it:#} [{cmd:,} {it:#} ...]{cmd:,} {cmd:copy}

{phang}
{opt iterinit(#)} specifies the maximum number of iterations used to calculate
the starting values.  This option is seldom used.

{dlgtab:Advanced}

{phang}
{opt pstolerance(#)} specifies the tolerance used to check the overlap
assumption.  The default value is {cmd:pstolerance(1e-5)}.  {cmd:stteffects}
will exit with an error if an observation has an estimated propensity score
smaller than that specified by {cmd:pstolerance()}.

{marker osample}{...}
{phang}
{opth osample(newvar)} specifies that indicator variable {it:newvar} be
created to identify observations that violate the overlap assumption.

{phang}
{opt control(#|label)} specifies the level of {it:tvar} that is the control.
The default is the first treatment level.  You may specify the numeric level
{it:#} (a nonnegative integer) or the label associated with the numeric level.
{cmd:control()} may not be specified with statistic {cmd:pomeans}.
{cmd:control()} and {cmd:tlevel()} may not specify the same treatment level.

{phang}
{opt tlevel(#|label)} specifies the level of {it:tvar} that is the treatment
for the statistic {cmd:atet}.  The default is the second treatment level.  You
may specify the numeric level {it:#} (a nonnegative integer) or the label
associated with the numeric level.  {cmd:tlevel()} may only be specified with
statistic {cmd:atet}.  {cmd:tlevel()} and {cmd:control()} may not specify the
same treatment level.

{phang}
The following option is available with {cmd:stteffects} but is not shown in
the dialog box:

{phang}
{cmd:coeflegend};
{helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sheart}

{pstd}Estimate the ATE, modeling the mean survival time using the default
Weibull outcome model{p_end}
{phang2}{cmd:. stteffects wra (age exercise diet education) (smoke)}
          {cmd:(age c.age#c.age exercise diet education)}

{pstd}Estimate the ATET, modeling the mean survival time using the default
Weibull outcome model{p_end}
{phang2}{cmd:. stteffects wra (age exercise diet education) (smoke)}
          {cmd:(age c.age#c.age exercise diet education), atet}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:stteffects} {cmd:wra} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2:Scalars}{p_end}
{synopt :{cmd:e(N)}}number of observations{p_end}
{synopt :{cmd:e(n}{it:j}{cmd:)}}number of observations for treatment level {it:j}{p_end}
{synopt :{cmd:e(N_clust)}}number of clusters{p_end}
{synopt :{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt :{cmd:e(k_levels)}}number of levels in treatment variable{p_end}
{synopt :{cmd:e(treated)}}level of treatment variable defined as
treated{p_end}
{synopt :{cmd:e(control)}}level of treatment variable defined as
control{p_end}
{synopt :{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{p2col 5 20 24 2:Macros}{p_end}
{synopt :{cmd:e(cmd)}}{cmd:stteffects}{p_end}
{synopt :{cmd:e(cmdline)}}command as typed{p_end}
{synopt :{cmd:e(dead)}}{cmd:_d}{p_end}
{synopt :{cmd:e(depvar)}}{cmd:_t}{p_end}
{synopt :{cmd:e(tvar)}}name of treatment variable{p_end}
{synopt :{cmd:e(subcmd)}}{cmd:wra}{p_end}
{synopt :{cmd:e(omodel)}}outcome model: {cmd:weibull}, {cmd:exponential}, {cmd:gamma}, or
 {cmd:lognormal}{p_end}
{synopt :{cmd:e(cmodel)}}censoring model: {cmd:weibull}, {cmd:exponential}, {cmd:gamma}, or
 {cmd:lognormal}{p_end}
{synopt :{cmd:e(stat)}}statistic estimated: {cmd:ate}, {cmd:atet}, or
{cmd:pomeans}{p_end}
{synopt :{cmd:e(wtype)}}weight type{p_end}
{synopt :{cmd:e(wexp)}}weight expression{p_end}
{synopt :{cmd:e(title)}}title in estimation output{p_end}
{synopt :{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt :{cmd:e(tlevels)}}levels of treatment variable{p_end}
{synopt :{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt :{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt :{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt :{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt :{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt :{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 20 24 2:Matrices}{p_end}
{synopt :{cmd:e(b)}}coefficient vector{p_end}
{synopt :{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{p2col 5 20 24 2:Functions}{p_end}
{synopt :{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
