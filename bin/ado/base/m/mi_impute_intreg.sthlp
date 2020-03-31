{smcl}
{* *! version 1.0.12  14may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi impute intreg" "mansection MI miimputeintreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "[MI] Intro substantive" "help mi intro substantive"}{...}
{vieweralsosee "[MI] mi impute" "help mi_impute"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi impute pmm" "help mi_impute_pmm"}{...}
{vieweralsosee "[MI] mi impute regress" "help mi_impute_regress"}{...}
{vieweralsosee "[MI] mi impute truncreg" "help mi_impute_truncreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi estimate" "help mi_estimate"}{...}
{viewerjumpto "Syntax" "mi_impute_intreg##syntax"}{...}
{viewerjumpto "Menu" "mi_impute_intreg##menu"}{...}
{viewerjumpto "Description" "mi_impute_intreg##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_impute_intreg##linkspdf"}{...}
{viewerjumpto "Options" "mi_impute_intreg##options"}{...}
{viewerjumpto "Remarks" "mi_impute_intreg##remarks"}{...}
{viewerjumpto "Example" "mi_impute_intreg##example"}{...}
{viewerjumpto "Stored results" "mi_impute_intreg##results"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[MI] mi impute intreg} {hline 2}}Impute using interval regression{p_end}
{p2col:}({mansection MI miimputeintreg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 19 2}{cmd:mi} {cmdab:imp:ute} {cmdab:intreg} 
{it:{help newvarname:newivar}} [{it:{help indepvars}}] [{it:{help if}}]
[{it:{help mi impute intreg##weight:weight}}]
[{cmd:,} {it:{help mi_impute##impopts:impute_options}} {it:options}] 

{synoptset 22 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{synopt: {opt nocons:tant}}suppress constant term{p_end}
{p2coldent:* {opth ll(varname)}}lower limit for interval censoring{p_end}
{p2coldent:* {opth ul(varname)}}upper limit for interval censoring{p_end}
{synopt:{opth off:set(varname)}}include {it:varname} in model with
coefficient constrained to 1{p_end}
{synopt: {opth cond:itional(if)}}perform conditional imputation{p_end}
{synopt: {opt boot:strap}}estimate model parameters using sampling with replacement{p_end}

{syntab:Maximization}
{synopt :{it:{help intreg##maximize_options:maximize_options}}}control the 
maximization process; seldom used{p_end}
{synoptline}
{p 4 6 2}
* {cmd:ll()} and {cmd:ul()} are required.
{p_end}
{p 4 6 2}
You must {cmd:mi set} your data before using {cmd:mi} {cmd:impute}
{cmd:intreg}; see {manhelp mi_set MI:mi set}.{p_end}
INCLUDE help fvvarlist
{marker weight}{...}
{p 4 6 2}
{cmd:aweight}s, {cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s are
allowed; see {help weight}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:mi} {cmd:impute} {cmd:intreg} fills in missing values of a continuous
partially observed (censored) variable using an interval regression imputation
method.  You can perform separate imputations on different subsets of the data
by using the {cmd:by()} option.  You can also account for analytic,
frequency, importance, and sampling weights.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI miimputeintregRemarksandexamples:Remarks and examples}

        {mansection MI miimputeintregMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt noconstant}; see {manhelp estimation_options R: Estimation options}.

{phang}
{opth ll(varname)} and {opt ul(varname)} specify variables containing
the lower and upper limits for interval censoring.  You must specify both.  Nonmissing
observations with equal values in {opt ll()} and {opt ul()} are fully
observed observations with missing values in both {opt ll()} and {opt ul()}
are unobserved (missing), and the remaining observations are
partially observed (censored).  Partially observed cases are left-censored
when {opt ll()} contains missing, right-censored when {opt ul()} contains
missing, and interval-censored when {opt ll()} < {opt ul()}.
Fully observed cases are also known as point data; also see
{mansection R intregDescription:{it:Description}} in {manhelp intreg R}.
In addition to {it:newivar}, {cmd:mi} {cmd:impute} {cmd:intreg} fills in
unobserved (missing) values of variables supplied in {cmd:ll()} and
{cmd:ul()}; censored values remain unchanged.

{phang}
{cmd:add()}, {cmd:replace}, {cmd:rseed()}, {cmd:double}, {cmd:by()}; see
{manhelp mi_impute MI:mi impute}.

{phang}
{opth offset(varname)}; see {helpb estimation options:[R] Estimation options}.

{phang}
INCLUDE help mi_impute_uvopt_conditional.ihlp

{phang}
INCLUDE help mi_impute_uvopt_bootstrap.ihlp

{dlgtab:Reporting}

{phang}
{cmd:dots}, {cmd:noisily}, {cmd:nolegend}; see {manhelp mi_impute MI:mi impute}.
{cmd:noisily} specifies that the output from an interval regression fit to the
observed data be displayed.
INCLUDE help mi_impute_uvopt_nolegend.ihlp

{dlgtab:Maximization}

{phang}
{it:{help intreg##maximize_options:maximize_options}}; see {manhelp intreg R}.
These options are seldom used.

{dlgtab:Advanced}

{phang}
{cmd:force}; see {manhelp mi_impute MI:mi impute}.

{pstd}
The following option is available with {opt mi impute} but is not shown in the
dialog box:

{phang}
{cmd:noupdate}; see {manhelp noupdate_option MI:noupdate option}.


{marker remarks}{...}
{title:Remarks}

{pstd}
We recommend that you first read {mansection MI miimputeintregRemarksandexamplesUnivariateimputationusingintervalregression:{it:Univariate imputation using interval regression}}
under {it:Remarks and examples} of {bf:[MI] mi impute intreg} for a general 
introduction to the imputation of interval-censored data.

{pstd}
{opt mi impute intreg} requires that variables containing interval-censoring
limits be specified in the {opt ll()} and {opt ul()} options; see the
description of {opt ll()} and {opt ul()} in 
{it:{help mi_impute_intreg##options:Options}}.  {cmd:mi impute intreg} also
requires you to specify a new variable name {it:newivar} to store the
resulting imputed values.  {cmd:mi impute intreg} creates a new variable,
{it:newivar}, and registers it as imputed.

{pstd}
The values of {it:newivar} are determined by {opt ll()} and {opt ul()}.  Observations of
{it:newivar} for which {opt ll()} and {opt ul()} are different or for which
both contain soft missing are set to soft missing ({opt .}) and considered
incomplete.  Observations for which either {opt ll()} or {opt ul()} contains
hard missing are set to the extended missing value {opt .a} and, as usual, are
omitted from imputation.  The remaining observations, corresponding to the
observed point data, are complete.

{pstd}
After imputation, {opt mi impute intreg} stores imputed values in
{it:newivar}.  It also registers variables in {opt ll()} and {cmd:ul()} as
passive (see {helpb mi register}), if they are not already registered as
passive, and replaces observations for which {opt ll()} and {cmd:ul()} both
contain soft missing with the corresponding imputed values.  That is, only
missing data are replaced in these variables; censored data are not changed.

{pstd}
Later, you may decide to add more imputations or to revise your imputation
model and replace existing imputations with new ones.  In such cases, you do
not need to provide a new variable name.  You can reuse the name of the
variable created previously by {cmd:mi impute intreg}.  
{cmd:mi impute intreg} will check that the variable is registered as imputed
and that it is consistent in the observed data with the variables supplied in
{cmd:ll()} and {cmd:ul()}.  That is, the variable must have the same values as
{cmd:ll()} and {cmd:ul()} in the observations where {cmd:ll()} and {cmd:ul()}
are equal, and soft missing values in the remaining observations.  If
{cmd:ll()} or {cmd:ul()} contain hard missing values, the variable must
contain hard missing values in the corresponding observations as well.

{pstd}
See {mansection MI miimputeintregRemarksandexamplesUsingmiimputeintreg:{it:Using mi impute intreg}}
under {it:Remarks and examples} of {bf:[MI] mi impute intreg} for more details.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}
{cmd:. webuse mheartintreg}
{p_end}

{pstd}Declare data{p_end}
{phang2}
{cmd:. mi set mlong}
{p_end}

{pstd}
Impute censored BMI values, recorded in the {cmd:lbmi} and {cmd:ubmi} variables,
using an interval regression{p_end}
{phang2}
{cmd:. mi impute intreg newbmi attack smokes age female hsgrad, add(20) ll(lbmi) ul(ubmi)}
{p_end}

{pstd}Describe resulting {cmd:mi} data{p_end}
{phang2}
{cmd:. mi describe}
{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mi impute intreg} stores the following in {cmd:r()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Scalars}{p_end}
{synopt:{cmd:r(M)}}total number of imputations{p_end}
{synopt:{cmd:r(M_add)}}number of added imputations{p_end}
{synopt:{cmd:r(M_update)}}number of updated imputations{p_end}
{synopt:{cmd:r(N_miss)}}number of missing observations{p_end}
{synopt:{cmd:r(N_cens)}}number of censored observations{p_end}
{synopt:{cmd:r(N_lcens)}}number of left-censored observations{p_end}
{synopt:{cmd:r(N_rcens)}}number of right-censored observations{p_end}
{synopt:{cmd:r(N_intcens)}}number of interval-censored observations{p_end}
{synopt:{cmd:r(k_ivars)}}number of imputed variables (always {cmd:1}){p_end}
{synopt:{cmd:r(N_g)}}number of imputed groups ({cmd:1} if {cmd:by()} is not specified){p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Macros}{p_end}
{synopt:{cmd:r(method)}}name of imputation method ({cmd:intreg}){p_end}
{synopt:{cmd:r(ivars)}}names of imputation variables{p_end}
{synopt:{cmd:r(llname)}}name of variable containing lower interval-censoring limits{p_end}
{synopt:{cmd:r(ulname)}}name of variable containing upper interval-censoring limits{p_end}
{synopt:{cmd:r(rngstate)}}random-number state used{p_end}
{synopt:{cmd:r(by)}}names of variables specified within {cmd:by()}{p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Matrices}{p_end}
{synopt:{cmd:r(N)}}number of observations in imputation sample in each group{p_end}
{synopt:{cmd:r(N_complete)}}number of complete observations in imputation sample
in each group{p_end}
{synopt:{cmd:r(N_incomplete)}}number of incomplete observations in imputation sample
in each group{p_end}
{synopt:{cmd:r(N_imputed)}}number of imputed observations in imputation sample
in each group{p_end}
