{smcl}
{* *! version 1.0.20  11oct2018}{...}
{viewerdialog teffects "dialog teffects"}{...}
{vieweralsosee "[TE] teffects psmatch" "mansection TE teffectspsmatch"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] teffects postestimation" "help teffects postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] teffects" "help teffects"}{...}
{vieweralsosee "[TE] teffects nnmatch" "help teffects nnmatch"}{...}
{viewerjumpto "Syntax" "teffects psmatch##syntax"}{...}
{viewerjumpto "Menu" "teffects psmatch##menu"}{...}
{viewerjumpto "Description" "teffects psmatch##description"}{...}
{viewerjumpto "Links to PDF documentation" "teffects_psmatch##linkspdf"}{...}
{viewerjumpto "Options" "teffects psmatch##options"}{...}
{viewerjumpto "Examples" "teffects psmatch##examples"}{...}
{viewerjumpto "Video example" "teffects psmatch##video"}{...}
{viewerjumpto "Stored results" "teffects psmatch##results"}{...}
{viewerjumpto "References" "teffects psmatch##references"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[TE] teffects psmatch} {hline 2}}Propensity-score
matching{p_end}
{p2col:}({mansection TE teffectspsmatch:View complete PDF manual entry}){p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:teffects} {cmd:psmatch}
    {cmd:(}{it:{help varname:ovar}}{cmd:)}
    {cmd:(}{it:{help varname:tvar}} {it:{help varlist:tmvarlist}}
          [{cmd:,} {it:{help teffects psmatch##tmodel:tmodel}}]{cmd:)}  
    {ifin}
    [{it:{help teffects psmatch##weight:weight}}]
    [{cmd:,}
         {it:{help teffects psmatch##stat:stat}}
         {it:{help teffects psmatch##options_table:options}}]

{phang}
{it:ovar} is a binary, count, continuous, fractional, or nonnegative outcome of interest.

{phang}
{it:tvar} must contain integer values representing the treatment levels.

{phang}
{it:tmvarlist} specifies the variables that predict treatment assignment in
the treatment model.  Only two treatment levels are allowed.

{synoptset 22 tabbed}{...}
{marker tmodel}{...}
{synopthdr:tmodel}
{synoptline}
{syntab:Model}
{synopt :{opt logit}}logistic treatment model; the default{p_end}
{synopt :{opt probit}}probit treatment model{p_end}
{synopt :{opth hetprobit(varlist)}}heteroskedastic probit treatment
model{p_end}
{synoptline}
{p 4 6 2}
{it:tmodel} specifies the model for the treatment variable.{p_end}

{marker stat}{...}
{synopthdr:stat}
{synoptline}
{syntab:Stat}
{synopt :{opt ate}}estimate average treatment effect in population; the
default{p_end}
{synopt :{opt atet}}estimate average treatment effect on the treated{p_end}
{synoptline}

{marker options_table}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nn:eighbor(#)}}specify number of matches per
observation; default is {cmd:nneighbor(1)}{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be{p_end}
{p2col 5 31 33 2:}{cmd:vce(}{cmdab:r:obust} [{cmd:,} {opt nn(#)}]{cmd:)}; use
      robust Abadie-Imbens standard errors with {it:#} matches{p_end}
{p2col 5 31 33 2:}{cmd:vce(iid)}; use independent and identically distributed
      Abadie-Imbens standard errors{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{it:{help teffects psmatch##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Advanced}
{synopt :{opt cal:iper(#)}}specify the maximum distance for which two
observations are potential neighbors{p_end}
{synopt :{opt pstol:erance(#)}}set tolerance for overlap assumption{p_end}
{synopt :{opth os:ample(newvar)}}{it:newvar} identifies observations that
violate the overlap assumption{p_end}
{synopt :{opt con:trol(# | label)}}specify the level of {it:tvar} that is the
	control{p_end}
{synopt :{opt tle:vel(# | label)}}specify the level of {it:tvar} that is the
        treatment{p_end}
{synopt :{opt gen:erate(stub)}}generate variables containing the observation
        numbers of the nearest neighbors{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}

{p 4 6 2}
{it:tmvarlist} may contain factor variables; see {help fvvarlists}.{p_end}
{p 4 6 2}
{opt by} and {opt statsby} are allowed; see {help prefix}.{p_end}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp teffects_postestimation TE:teffects postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Treatment effects > Continuous outcomes >}
        {bf:Propensity-score matching}

{phang}
{bf:Statistics > Treatment effects > Binary outcomes >}
        {bf:Propensity-score matching}

{phang}
{bf:Statistics > Treatment effects > Count outcomes >}
        {bf:Propensity-score matching}

{phang}
{bf:Statistics > Treatment effects > Fractional outcomes >}
        {bf:Propensity-score matching}

{phang}
{bf:Statistics > Treatment effects > Nonnegative outcomes >}
        {bf:Propensity-score matching}


{marker description}{...}
{title:Description}

{pstd}
{cmd:teffects} {cmd:psmatch} estimates  the average treatment effect and
average treatment effect on the treated from observational data by
propensity-score matching.  Propensity-score matching estimators impute the
missing potential outcome for each subject by using an average of the outcomes
of similar subjects that receive the other treatment level.  Similarity
between subjects is based on estimated treatment probabilities, known as
propensity scores.  The treatment effect is computed by taking the average of
the difference between the observed and potential outcomes for each subject.
{cmd:teffects psmatch} accepts a continuous, binary, count, fractional, or
nonnegative outcome.

{pstd}
See 
{mansection TE teffectsintro:{bf:[TE] teffects intro}} or
{mansection TE teffectsintroadvanced:{bf:[TE] teffects intro advanced}}
for more information about estimating treatment effects from observational
data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TE teffectspsmatchQuickstart:Quick start}

        {mansection TE teffectspsmatchRemarksandexamples:Remarks and examples}

        {mansection TE teffectspsmatchMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt nneighbor(#)} specifies the number of matches per
observation. The default is {cmd:nneighbor(1)}. Each individual is
matched with at least the specified number of individuals from the other
treatment level.  {cmd:nneighbor()} must specify an integer greater than
or equal to 1 but no larger than the number of observations in the
smallest group.

{dlgtab:Stat}

{phang}
{it:stat} is one of two statistics: {cmd:ate} or {cmd:atet}.
{cmd:ate} is the default.

{pmore}
{cmd:ate} specifies that the average treatment effect be estimated.

{pmore}
{cmd:atet} specifies that the average treatment effect on the treated be
estimated.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the standard errors that are reported.
By default, {cmd:teffects psmatch} uses two matches in estimating the robust
standard errors.

{pmore}
{cmd:vce(robust} [{cmd:,} {opt nn(#)}]{cmd:)}
specifies that robust standard errors be reported and that the requested
number of matches be used optionally.

{pmore}
{cmd:vce(iid)} specifies that standard errors for independent and
identically distributed data be reported.

{pmore}
The standard derivative-based standard-error estimators cannot be used
by {cmd:teffects} {cmd:psmatch}, because these matching estimators are not 
differentiable.  The implemented methods
were derived by
Abadie and Imbens ({help teffects nnmatch##AI2006:2006},
{help teffects nnmatch##AI2011:2011},
{help teffects nnmatch##AI2012:2012}); see
{mansection TE teffectsnnmatchMethodsandformulas:{it:Methods and formulas}}.

{pmore}
As discussed in {help teffects nnmatch##AI2008:Abadie and Imbens (2008)},
bootstrap estimators do not provide reliable standard errors for the estimator
implemented by {cmd:teffects} {cmd:psmatch}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
    {helpb estimation options:[R] Estimation options}.

INCLUDE help displayopts_list

{dlgtab:Advanced}

{phang}
{opt caliper(#)} specifies the maximum distance at which two
observations are a potential match.  By default, all observations are
potential matches regardless of how dissimilar they are.

{pmore}
In {cmd:teffects} {cmd:psmatch}, the distance is measured by the estimated
propensity score.  If an observation has no matches, {cmd:teffects}
{cmd:psmatch} exits with an error.

{phang}
{opt pstolerance(#)} specifies the tolerance used to check the overlap
assumption. The default value is {cmd:pstolerance(1e-5)}.  {cmd:teffects} will
exit with an error if an observation has an estimated propensity score smaller
than that specified by {cmd:pstolerance()}.  

{marker osample}{...}
{phang}
{opth osample(newvar)} specifies that indicator variable {it:newvar} be
created to identify observations that violate the overlap assumption.
Two checks are made to verify the assumption.  The first ensures that the
propensity scores are greater than {opt pstolerance(#)} and less than
1-{opt pstolerance(#)}.  The second ensures that each observation has at
least {opt nneighbor(#)} matches in the opposite treatment group within the
distance specified by {opt caliper(#)}.

{pmore}
The {cmd:vce(robust, nn(}{it:#}{cmd:))} option also requires at least {it:#}
matches in the same treatment group within the distance specified by
{opt caliper(#)}.

{pmore}
The average treatment effect on the treated, option {cmd:atet}, using
{cmd:vce(iid)} requires only {opt nneighbor(#)} control group matches for the
treated group.

{phang}
{opt control(# | label)} specifies the level of {it:tvar} that is the control.
The default is the first treatment level.  You may specify the numeric level
{it:#} (a nonnegative integer) or the label associated with the numeric level.
{cmd:control()} and {cmd:tlevel()} may not specify the same treatment level.

{phang}
{opt tlevel(# | label)} specifies the level of {it:tvar} that is the treatment
for the statistic {cmd:atet}. The default is the second treatment level.  You
may specify the numeric level {it:#} (a nonnegative integer) or the label
associated with the numeric level.  {cmd:tlevel()} may only be specified with
statistic {cmd:atet}.  {cmd:tlevel()} and {cmd:control()} may not specify the
same treatment level.

{phang}
{opt generate(stub)} specifies that the observation numbers of the nearest
neighbors be stored in the new variables {it:stub}{cmd:1}, {it:stub}{cmd:2},
....  This option is required if you wish to perform postestimation based on
the matching results.  The number of variables generated may be more than
{opt nneighbor(#)} because of tied distances.  These variables may not
already exist.

{pstd}
The following option is available with {cmd:teffects} {cmd:psmatch} but is not
shown in the dialog box:

{phang}
{cmd:coeflegend}; see
    {helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse cattaneo2}

{pstd}
Estimate the average treatment effect of {cmd:mbsmoke} on {cmd:bweight},
using a logistic model (the default) to predict each subject's propensity score
{p_end}
{phang2}{cmd:. teffects psmatch (bweight) (mbsmoke mmarried c.mage##c.mage}
           {cmd:fbaby medu)}

{pstd}
Refit the previous model, but only consider a pair of observations a match if
the absolute difference in the propensity score is less than 0.1{p_end}
{phang2}{cmd:. teffects psmatch (bweight) (mbsmoke mmarried c.mage##c.mage}
    {cmd:fbaby medu), caliper(0.1)}


{marker video}{...}
{title:Video example}

{phang}
{browse "https://www.youtube.com/watch?v=hnyh1cUFiOE":Treatment effects in Stata: Propensity-score matching}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:teffects} {cmd:psmatch} stores the following in {cmd:e()}:

{synoptset 24 tabbed}{...}
{p2col 5 24 28 2:Scalars}{p_end}
{synopt :{cmd:e(N)}}number of observations{p_end}
{synopt :{cmd:e(n}{it:j}{cmd:)}}number of observations for treatment level
{it:j}{p_end}
{synopt :{cmd:e(k_levels)}}number of levels in treatment variable{p_end}
{synopt :{cmd:e(caliper)}}maximum distance between matches{p_end}
{synopt :{cmd:e(treated)}}level of treatment variable defined as treated{p_end}
{synopt :{cmd:e(control)}}level of treatment variable defined as control{p_end}
{synopt :{cmd:e(k_nneighbor)}}requested number of matches{p_end}
{synopt :{cmd:e(k_nnmin)}}minimum number of matches{p_end}
{synopt :{cmd:e(k_nnmax)}}maximum number of matches{p_end}
{synopt :{cmd:e(k_robust)}}matches for robust VCE{p_end}

{p2col 5 24 28 2:Macros}{p_end}
{synopt :{cmd:e(cmd)}}{cmd:teffects}{p_end}
{synopt :{cmd:e(cmdline)}}command as typed{p_end}
{synopt :{cmd:e(depvar)}}name of outcome variable{p_end}
{synopt :{cmd:e(tvar)}}name of treatment variable{p_end}
{synopt :{cmd:e(subcmd)}}{cmd:psmatch}{p_end}
{synopt :{cmd:e(tmodel)}}{cmd:logit}, {cmd:probit}, or {cmd:hetprobit}{p_end}
{synopt :{cmd:e(stat)}}statistic estimated, {cmd:ate} or {cmd:atet}{p_end}
{synopt :{cmd:e(wtype)}}weight type{p_end}
{synopt :{cmd:e(wexp)}}weight expression{p_end}
{synopt :{cmd:e(title)}}title in estimation output{p_end}
{synopt :{cmd:e(tlevels)}}levels of treatment variable{p_end}
{synopt :{cmd:e(psvarlist)}}variables in propensity-score model{p_end}
{synopt :{cmd:e(hvarlist)}}variables for variance, only if {cmd:hetprobit}{p_end}
{synopt :{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt :{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt :{cmd:e(datasignature)}}the checksum{p_end}
{synopt :{cmd:e(datasignaturevars)}}variables used in calculation of
checksum{p_end}
{synopt :{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt :{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt :{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt :{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 24 28 2:Matrices}{p_end}
{synopt :{cmd:e(b)}}coefficient vector{p_end}
{synopt :{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt :{cmd:e(bps)}}coefficient vector from propensity-score model{p_end}
{synopt :{cmd:e(Vps)}}variance-covariance matrix of the estimators from
propensity-score model{p_end}
{p2col 5 24 28 2:Functions}{p_end}
{synopt :{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker AI2006}{...}
{phang}
Abadie, A., and G. W. Imbens.  2006.  Large sample properties of matching
estimators for average treatment effects.
{it:Econometrica} 74: 235-267.

{marker AI2008}{...}
{phang}
--------. 2008. On the failure of the bootstrap for matching estimators.
{it:Econometrica} 76: 1537-1557.

{marker AI2011}{...}
{phang}
------.  2011.  Bias-corrected matching estimators for average treatment
effects.  {it:Journal of Business and Economic Statistics} 29: 1-11.

{marker AI2012}{...}
{phang}
------. 2012. Matching on the estimated propensity score. Harvard University
and National Bureau of Economic Research.
{browse "http://www.hks.harvard.edu/fs/aabadie/pscore.pdf"}.
{p_end}
