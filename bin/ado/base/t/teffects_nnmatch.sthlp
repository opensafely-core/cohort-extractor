{smcl}
{* *! version 1.0.18  07aug2019}{...}
{viewerdialog teffects "dialog teffects"}{...}
{vieweralsosee "[TE] teffects nnmatch" "mansection TE teffectsnnmatch"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] teffects postestimation" "help teffects postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TE] teffects" "help teffects"}{...}
{vieweralsosee "[TE] teffects psmatch" "help teffects psmatch"}{...}
{viewerjumpto "Syntax" "teffects nnmatch##syntax"}{...}
{viewerjumpto "Menu" "teffects nnmatch##menu"}{...}
{viewerjumpto "Description" "teffects nnmatch##description"}{...}
{viewerjumpto "Links to PDF documentation" "teffects_nnmatch##linkspdf"}{...}
{viewerjumpto "Options" "teffects nnmatch##options"}{...}
{viewerjumpto "Examples" "teffects nnmatch##examples"}{...}
{viewerjumpto "Video example" "teffects nnmatch##video"}{...}
{viewerjumpto "Stored results" "teffects nnmatch##results"}{...}
{viewerjumpto "References" "teffects nnmatch##references"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[TE] teffects nnmatch} {hline 2}}Nearest-neighbor
matching{p_end}
{p2col:}({mansection TE teffectsnnmatch:View complete PDF manual entry}){p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:teffects} {cmd:nnmatch}
   {cmd:(}{it:{help varname:ovar}} {it:{help varlist:omvarlist}}{cmd:)}
   {cmd:(}{it:{help varname:tvar}}{cmd:)}
      {ifin}
      [{it:{help teffects nnmatch##weight:weight}}]
   [{cmd:,}
	 {it:{help teffects nnmatch##stat:stat}}
         {it:{help teffects nnmatch##options_table:options}}]

{phang}
{it:ovar} is a binary, count, continuous, fractional, or nonnegative outcome
of interest.

{phang}
{it:omvarlist} specifies the covariates in the outcome model.

{phang}
{it:tvar} must contain integer values representing the treatment levels.
Only two treatment levels are allowed.

{synoptset 22 tabbed}{...}
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
{synopt :{opt nn:eighbor(#)}}specify number of matches per observation;
default is {cmd:nneighbor(1)}{p_end}
{synopt :{opth bias:adj(varlist)}}correct for large-sample bias using
specified variables{p_end}
{synopt :{opth e:match(varlist)}}match exactly on specified variables{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be{p_end}
{p2col 5 31 33 2:}{cmd:vce(}{cmdab:r:obust} [{cmd:,} {opt nn(#)}]{cmd:)}; use
      robust Abadie-Imbens standard errors with {it:#} matches{p_end}
{p2col 5 31 33 2:}{cmd:vce(iid)}; use independently and
identically distributed Abadie-Imbens standard errors{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}
{synopt :{opt dmv:ariables}}display names of matching variables{p_end}
{synopt :{it:{help teffects nnmatch##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Advanced}
{synopt :{opt cal:iper(#)}}specify the maximum distance for which two
observations are potential neighbors{p_end}
{synopt :{opt dtol:erance(#)}}set maximum distance between individuals
considered equal{p_end}
{synopt :{opth os:ample(newvar)}}{it:newvar} identifies observations that
violate the overlap assumption{p_end}
{synopt :{opt con:trol(# | label)}}specify the level of {it:tvar} that is the
	control{p_end}
{synopt :{opt tle:vel(# | label)}}specify the level of {it:tvar} that is the
treatment{p_end}
{synopt :{opt gen:erate(stub)}}generate variables containing the observation
numbers of the nearest neighbors{p_end}
{synopt :{opth m:etric(teffects nnmatch##metric:metric)}}select distance metric for covariates{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{synoptset 22 }{...}
{marker metric}{...}
{synopthdr:metric}
{synoptline}
{synopt :{opt maha:lanobis}}inverse sample covariate covariance; the default{p_end}
{synopt :{opt ivar:iance}}inverse diagonal sample covariate covariance{p_end}
{synopt :{opt eucl:idean}}identity{p_end}
{synopt :{opt mat:rix} {it:matname}}user-supplied scaling matrix{p_end}
{synoptline}

{p 4 6 2}
{it:omvarlist} may contain factor variables; see {help fvvarlists}.{p_end}
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
    {bf:Nearest-neighbor matching}

{phang}
{bf:Statistics > Treatment effects > Binary outcomes >}
    {bf:Nearest-neighbor matching}

{phang}
{bf:Statistics > Treatment effects > Count outcomes >}
    {bf:Nearest-neighbor matching}

{phang}
{bf:Statistics > Treatment effects > Fractional outcomes >}
    {bf:Nearest-neighbor matching}

{phang}
{bf:Statistics > Treatment effects > Nonnegative outcomes >}
    {bf:Nearest-neighbor matching}


{marker description}{...}
{title:Description}

{pstd}
{cmd:teffects} {cmd:nnmatch} estimates the average treatment effect and
average treatment effect on the treated from observational data by
nearest-neighbor matching.  Nearest-neighbor matching estimators impute the
missing potential outcome for each subject by using an average of the outcomes
of similar subjects that receive the other treatment level.  Similarity
between subjects is based on a weighted function of the covariates for each
observation.  The treatment effect is computed by taking the average of the
difference between the observed and imputed potential outcomes for each
subject.  {cmd:teffects nnmatch} accepts a continuous, binary, count,
fractional, or nonnegative outcome.


{pstd}
See
{bf:{mansection TE teffectsintro:[TE] teffects intro}} or
{bf:{mansection TE teffectsintroadvanced:[TE] teffects intro advanced}}
for more information about estimating treatment effects from observational
data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TE teffectsnnmatchQuickstart:Quick start}

        {mansection TE teffectsnnmatchRemarksandexamples:Remarks and examples}

        {mansection TE teffectsnnmatchMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt nneighbor(#)} specifies the number of matches per
observation. The default is {cmd:nneighbor(1)}. Each observation is
matched with at least the specified number of observations from the other
treatment level.  {cmd:nneighbor()} must specify an integer greater than
or equal to 1 but no larger than the number of observations in the smallest
treatment group.

{phang}
{opth biasadj(varlist)} specifies that a linear function of the
specified covariates be used to correct for a large-sample bias that exists
when matching on more than one continuous covariate. By default, no correction
is performed.

{pmore}
Abadie and Imbens ({help teffects nnmatch##AI2006:2006},
{help teffects nnmatch##AI2011:2011}) show that nearest-neighbor matching
estimators are not consistent when matching on two or more continuous
covariates and propose a bias-corrected estimator that is consistent.
The correction term uses a linear function of variables specified in
{cmd:biasadj()}; see
{mansection TE teffectsnnmatchRemarksandexamplesex3:example 3}.

{phang}
{opth ematch(varlist)} specifies that the variables in {it:varlist} match
exactly.  All variables in {it:varlist} must be numeric and may be specified
as factors.  {cmd:teffects} {cmd:nnmatch} exits with an error if any
observations do not have the requested exact match.

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
By default, {cmd:teffects} {cmd:nnmatch} uses robust standard errors
estimated using two matches.

{pmore}
{cmd:vce(robust} [{cmd:,} {opt nn(#)}]{cmd:)}
specifies that robust standard errors be reported and that the requested
number of matches be used optionally.

{pmore}
{cmd:vce(iid)} specifies that standard errors for independently and
identically distributed data be reported.

{pmore}
The standard derivative-based standard-error estimators cannot be used
by {cmd:teffects} {cmd:nnmatch}, because these matching estimators are not 
differentiable.  The implemented methods were derived by
Abadie and Imbens ({help teffects nnmatch##AI2006:2006},
{help teffects nnmatch##AI2011:2011},
{help teffects nnmatch##AI2012:2012}); see
{mansection TE teffectsnnmatchMethodsandformulas:{it:Methods and formulas}}.

{pmore}
As discussed in {help teffects nnmatch##AI2008:Abadie and Imbens (2008)},
bootstrap estimators do not provide reliable standard errors for the estimator
implemented by {cmd:teffects} {cmd:nnmatch}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
    {helpb estimation options:[R] Estimation options}.

{phang}
{opt dmvariables} specifies that the matching variables be displayed.

INCLUDE help displayopts_list

{dlgtab:Advanced}

{phang}
{opt caliper(#)} specifies the maximum distance at which two
observations are a potential match.  By default, all observations are
potential matches regardless of how dissimilar they are.

{pmore}
The distance is based on {it:omvarlist}.  If an observation does not have at
least {opt nneighbor(#)} matches, {cmd:teffects} {cmd:nnmatch} exits with an
error message.  Use option {opt osample(newvar)} to identify all observations
that are deficient in matches.

{phang}
{opt dtolerance(#)} specifies the tolerance used to determine
exact matches. The default value is {cmd:dtolerance(sqrt(c(epsdouble)))}.

{pmore}
Integer-valued variables are usually used for exact matching.
The {cmd:dtolerance()} option is useful when continuous variables are used for
exact matching.

{marker osample}{...}
{phang}
{opth osample(newvar)} specifies that indicator variable {it:newvar} be
created to identify observations that violate the overlap assumption.  This
variable will identify all observations that do not have at least 
{opt nneighbor(#)} matches in the opposite treatment group within
{opt caliper(#)} (for {opt metric()} distance matching) or {opt dtolerance(#)}
(for {opt ematch(varlist)} exact matches).

{pmore}
The {cmd:vce(robust, nn(}{it:#}{cmd:))} option also requires at least {it:#}
matches in the same treatment group within the distance specified by
{opt caliper(#)} or within the exact matches specified by {opt dtolerance(#)}.

{pmore}
The average treatment effect on the treated, option {cmd:atet}, using
{cmd:vce(iid)} requires only {opt nneighbor(#)} control group matches for the
treated group.

{phang}
{opt control(# | label)} specifies the level of {it:tvar} that is the control.
The default is the first treatment level.  You may specify the numeric level
{it:#} (a nonnegative integer) or the label associated with the numeric level.
{opt control()} and {opt tlevel()} may not specify the same treatment level.

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

{phang}
{opth metric:(teffects nnmatch##metric:metric)} specifies the distance matrix
used as the weight matrix in a quadratic form that transforms the multiple
distances into a single distance measure; see
{mansection TE teffectsnnmatchMethodsandformulasNearest-neighbormatchingestimator:{it:Nearest-neighbor matching estimator}}
in {it:Methods and formulas} of {bf:[TE] teffects nnmatch}
for details.

{pstd}
The following option is available with {cmd:teffects} {cmd:nnmatch} but is not
shown in the dialog box:

{phang}
{opt coeflegend}; see
    {helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse cattaneo2}

{pstd}
Estimate the average treatment effect of {cmd:mbsmoke} on {cmd:bweight}{p_end}
{phang2}{cmd:. teffects nnmatch (bweight mage prenatal1 mmarried fbaby)}
   {cmd:(mbsmoke)}

{pstd}
Refit the above model, but require exact matches on the binary
variables{p_end}
{phang2}{cmd:. teffects nnmatch (bweight mage) (mbsmoke),}
   {cmd:ematch(prenatal1 mmarried fbaby) metric(euclidean)}

{pstd}
Match on two continuous variables, {cmd:mage} and {cmd:fage}, and
use the bias-adjusted estimator{p_end}
{phang2}{cmd:. teffects nnmatch (bweight mage fage) (mbsmoke),}
   {cmd:ematch(prenatal1 mmarried fbaby) biasadj(mage fage)}


{marker video}{...}
{title:Video example}

{phang}
{browse "https://www.youtube.com/watch?v=mEqwQ0FI2Vg":Treatment effects in Stata: Nearest-neighbor matching}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:teffects} {cmd:nnmatch} stores the following in {cmd:e()}:

{synoptset 24 tabbed}{...}
{p2col 5 24 28 2:Scalars}{p_end}
{synopt :{cmd:e(N)}}number of observations{p_end}
{synopt :{cmd:e(n}{it:j}{cmd:)}}number of observations for treatment level
{it:j}{p_end}
{synopt :{cmd:e(k_levels)}}number of levels in treatment variable{p_end}
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
{synopt :{cmd:e(emvarlist)}}exact match variables{p_end}
{synopt :{cmd:e(bavarlist)}}variables used in bias adjustment{p_end}
{synopt :{cmd:e(mvarlist)}}match variables{p_end}
{synopt :{cmd:e(subcmd)}}{cmd:nnmatch}{p_end}
{synopt :{cmd:e(metric)}}{cmd:mahalanobis}, {cmd:ivariance}, {cmd:euclidean}, or {cmd:matrix} {it:matname}{p_end}
{synopt :{cmd:e(stat)}}statistic estimated, {cmd:ate} or {cmd:atet}{p_end}
{synopt :{cmd:e(wtype)}}weight type{p_end}
{synopt :{cmd:e(wexp)}}weight expression{p_end}
{synopt :{cmd:e(title)}}title in estimation output{p_end}
{synopt :{cmd:e(tlevels)}}levels of treatment variable{p_end}
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

{p2col 5 24 28 2:Functions}{p_end}
{synopt :{cmd:e(sample)}}marks estimation sample{p_end}


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
