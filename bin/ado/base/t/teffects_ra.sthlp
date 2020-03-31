{smcl}
{* *! version 1.0.17  12dec2018}{...}
{viewerdialog teffects "dialog teffects"}{...}
{vieweralsosee "[TE] teffects ra" "mansection TE teffectsra"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] teffects postestimation" "help teffects postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ERM] eregress" "help eregress"}{...}
{vieweralsosee "[TE] teffects" "help teffects"}{...}
{viewerjumpto "Syntax" "teffects ra##syntax"}{...}
{viewerjumpto "Menu" "teffects ra##menu"}{...}
{viewerjumpto "Description" "teffects ra##description"}{...}
{viewerjumpto "Links to PDF documentation" "teffects_ra##linkspdf"}{...}
{viewerjumpto "Options" "teffects ra##options"}{...}
{viewerjumpto "Examples" "teffects ra##examples"}{...}
{viewerjumpto "Video example" "teffects ra##video"}{...}
{viewerjumpto "Stored results" "teffects ra##results"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[TE] teffects ra} {hline 2}}Regression adjustment{p_end}
{p2col:}({mansection TE teffectsra:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 18 2}
{cmd:teffects} {cmd:ra}
   {cmd:(}{it:{help varname:ovar}} {it:{help varlist:omvarlist}}
      [{cmd:,} {it:{help teffects ra##omodel:omodel}}
      {opt nocons:tant}]{cmd:)}
   {cmd:(}{it:{help varname:tvar}}{cmd:)}
     {ifin}
     [{it:{help teffects ra##weight:weight}}]
   [{cmd:,}
      {it:{help teffects ra##stat:stat}}
      {it:{help teffects ra##options:options}}]

{phang}
{it:ovar} is a binary, count, continuous, fractional, or nonnegative outcome
of interest.

{phang}
{it:omvarlist} specifies the covariates in the outcome model.

{phang}
{it:tvar} must contain integer values representing the treatment levels.

{synoptset 22 tabbed}{...}
{marker omodel}{...}
{synopthdr:omodel}
{synoptline}
{syntab:Model}
{synopt :{opt linear}}linear outcome model; the default{p_end}
{synopt :{opt logit}}logistic outcome model{p_end}
{synopt :{opt probit}}probit outcome model{p_end}
{synopt :{opth hetprobit(varlist)}}heteroskedastic probit outcome model{p_end}
{synopt :{opt poisson}}exponential outcome model{p_end}
{synopt :{opt flogit}}fractional logistic outcome model{p_end}
{synopt :{opt fprobit}}fractional probit outcome model{p_end}
{synopt :{opth fhetprobit(varlist)}}fractional heteroskedastic probit outcome model{p_end}
{synoptline}
{p 4 6 2}
{it:omodel} specifies the model for the outcome variable.

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
{synopt :{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}
{synopt :{opt aeq:uations}}display auxiliary-equation results{p_end}
{synopt :{it:{help teffects ra##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt :{it:{help teffects ra##maximize_options:maximize_options}}}control
the maximization process; seldom used{p_end}

{syntab:Advanced}
{synopt :{opt con:trol(# | label)}}specify the level of {it:tvar} that is the
control{p_end}
{synopt :{opt tle:vel(# | label)}}specify the level of {it:tvar} that is the
treatment{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}

{p 4 6 2}
{it:omvarlist} may contain factor variables; see {help fvvarlists}.{p_end}
{p 4 6 2}
{opt bootstrap}, {opt by}, {opt jackknife}, and {opt statsby} are allowed;
see {help prefix}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s, {opt iweight}s, and {opt pweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp teffects_postestimation TE:teffects postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Treatment effects > Continuous outcomes >}
             {bf:Regression adjustment}

{phang}
{bf:Statistics > Treatment effects > Binary outcomes >}
             {bf:Regression adjustment}

{phang}
{bf:Statistics > Treatment effects > Count outcomes >}
             {bf:Regression adjustment}

{phang}
{bf:Statistics > Treatment effects > Fractional outcomes >}
             {bf:Regression adjustment}

{phang}
{bf:Statistics > Treatment effects > Nonnegative outcomes >}
             {bf:Regression adjustment}


{marker description}{...}
{title:Description}

{pstd}
{cmd:teffects} {cmd:ra} estimates the average treatment effect, the average
treatment effect on the treated, and the potential-outcome means from
observational data by regression adjustment.  Regression adjustment estimators
use contrasts of averages of treatment-specific predicted outcomes to estimate
treatment effects.  {cmd:teffects} {cmd:ra} accepts a continuous, binary,
count, fractional, or nonnegative outcome and allows a multivalued treatment.

{pstd}
See 
{mansection TE teffectsintro:{bf:[TE] teffects intro}} or
{mansection TE teffectsintroadvanced:{bf:[TE] teffects intro advanced}}
for more information about estimating treatment effects from observational
data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TE teffectsraQuickstart:Quick start}

        {mansection TE teffectsraRemarksandexamples:Remarks and examples}

        {mansection TE teffectsraMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

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
{opt aequations} specifies that the results for the outcome-model or the
treatment-model parameters be displayed.  By default, the results for these
auxiliary parameters are not displayed.

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

{pmore2}
{it:matname} [{cmd:,} {cmd:skip} {cmd:copy}]

{pmore2}
{it:#} [{cmd:,} {it:#} ...]{cmd:,} {cmd:copy}

{dlgtab:Advanced}

{phang}
{opt control(# | label)} specifies the level of {it:tvar}
that is the control. The default is the first treatment level.  You may
specify the numeric level {it:#} (a nonnegative integer) or the label
associated with the numeric level.  {opt control()} may not be specified with
statistic {opt pomeans}.  {opt control()} and {opt tlevel()} may not specify
the same treatment level.

{phang}
{opt tlevel(# | label)} specifies the level of {it:tvar} that is the
treatment for the statistic {opt atet}.  The default is the second treatment
level.  You may specify the numeric level {it:#} (a nonnegative integer)
or the label associated with the numeric level.  {opt tlevel()} may only be
specified with statistic {opt atet}.  {opt tlevel()} and {opt control()} may
not specify the same treatment level.

{pstd}
The following option is available with {cmd:teffects} {cmd:ra} but is not
shown in the dialog box:

{phang}
{cmd:coeflegend}; see
    {helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse cattaneo2}

{pstd}
Estimate the average treatment effect of smoking, controlling for
first-trimester exam status, marital status, mother's age, and first-birth
status{p_end}
{phang2}{cmd:. teffects ra (bweight prenatal1 mmarried mage fbaby) (mbsmoke)}

{pstd}
Refit the above model, but obtain the average treatment effects on the treated
rather than the average treatment effect{p_end}
{phang2}{cmd:. teffects ra (bweight prenatal1 mmarried mage fbaby) (mbsmoke),}
         {cmd:atet}

{pstd}
Refit the above model, but display the POMs and the estimated regression
coefficients for the treated and untreated subjects{p_end}
{phang2}{cmd:. teffects ra (bweight prenatal1 mmarried mage fbaby) (mbsmoke),}
          {cmd:pomeans aequations}


{marker video}{...}
{title:Video example}

{phang2}{browse "http://www.youtube.com/watch?v=TYFbOjWZ7lE":Treatment effects: Regression adjustment}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:teffects} {cmd:ra} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2:Scalars}{p_end}
{synopt :{cmd:e(N)}}number of observations{p_end}
{synopt :{cmd:e(n}{it:j}{cmd:)}}number of observations for treatment level {it:j}{p_end}
{synopt :{cmd:e(N_clust)}}number of clusters{p_end}
{synopt :{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt :{cmd:e(k_levels)}}number of levels in treatment variable{p_end}
{synopt :{cmd:e(treated)}}level of treatment variable defined as treated{p_end}
{synopt :{cmd:e(control)}}level of treatment variable defined as control{p_end}
{synopt :{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{p2col 5 20 24 2:Macros}{p_end}
{synopt :{cmd:e(cmd)}}{cmd:teffects}{p_end}
{synopt :{cmd:e(cmdline)}}command as typed{p_end}
{synopt :{cmd:e(depvar)}}name of outcome variable{p_end}
{synopt :{cmd:e(tvar)}}name of treatment variable{p_end}
{synopt :{cmd:e(subcmd)}}{cmd:ra}{p_end}
{synopt :{cmd:e(omodel)}}{cmd:linear}, {cmd:logit}, {cmd:probit},
{cmd:hetprobit}, {cmd:poisson}, {cmd:flogit}, {cmd:fprobit}, or
{cmd:fhetprobit}{p_end}
{synopt :{cmd:e(stat)}}statistic estimated, {cmd:ate}, {cmd:atet}, or {cmd:pomeans}{p_end}
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
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as
{cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as
{cmd:asobserved}{p_end}

{p2col 5 20 24 2:Matrices}{p_end}
{synopt :{cmd:e(b)}}coefficient vector{p_end}
{synopt :{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{p2col 5 20 24 2:Functions}{p_end}
{synopt :{cmd:e(sample)}}marks estimation sample{p_end}
