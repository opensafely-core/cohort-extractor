{smcl}
{* *! version 1.1.6  14may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi impute pmm" "mansection MI miimputepmm"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "[MI] Intro substantive" "help mi intro substantive"}{...}
{vieweralsosee "[MI] mi impute" "help mi_impute"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi impute intreg" "help mi_impute_intreg"}{...}
{vieweralsosee "[MI] mi impute regress" "help mi_impute_regress"}{...}
{vieweralsosee "[MI] mi impute truncreg" "help mi_impute_truncreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi estimate" "help mi_estimate"}{...}
{viewerjumpto "Syntax" "mi_impute_pmm##syntax"}{...}
{viewerjumpto "Menu" "mi_impute_pmm##menu"}{...}
{viewerjumpto "Description" "mi_impute_pmm##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_impute_pmm##linkspdf"}{...}
{viewerjumpto "Options" "mi_impute_pmm##options"}{...}
{viewerjumpto "Examples" "mi_impute_pmm##examples"}{...}
{viewerjumpto "Video example" "mi_impute_pmm##video"}{...}
{viewerjumpto "Stored results" "mi_impute_pmm##results"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[MI] mi impute pmm} {hline 2}}Impute using predictive mean matching{p_end}
{p2col:}({mansection MI miimputepmm:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 19 2}
{cmd:mi} {cmdab:imp:ute} {cmd:pmm} 
{it:ivar} [{it:{help indepvars}}] [{it:{help if}}] 
[{it:{help mi impute pmm##weight:weight}}]
{cmd:,} {opt knn(#)}
[{it:{help mi_impute##impopts:impute_options}} {it:options}] 

{synoptset 22 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{synopt: {opt nocons:tant}}suppress constant term{p_end}
{p2coldent :* {opt knn(#)}}specify {it:#} of closest observations (nearest 
neighbors) to draw from{p_end}
{synopt: {opth cond:itional(if)}}perform conditional imputation{p_end}
{synopt: {opt boot:strap}}estimate model parameters using sampling with replacement{p_end}
{synoptline}
{p 4 6 2}
* {opt knn(#)} is required.{p_end}
{p 4 6 2}
You must {cmd:mi set} your data before using {cmd:mi} {cmd:impute} {cmd:pmm};
see {manhelp mi_set MI:mi set}.{p_end}
{p 4 6 2}
You must {cmd:mi register} {it:ivar} as imputed before using {cmd:mi}
{cmd:impute} {cmd:pmm}; see {manhelp mi_set MI:mi set}.{p_end}
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
{cmd:mi} {cmd:impute} {cmd:pmm} fills in missing values of a continuous
variable by using the predictive mean matching imputation method.  You can
perform separate imputations on different subsets of the data by specifying the
{cmd:by()} option.  You can also account for analytic, frequency, importance,
and sampling weights.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI miimputepmmRemarksandexamples:Remarks and examples}

        {mansection MI miimputepmmMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:noconstant}; see {manhelp estimation_options R:Estimation options}.

{phang}
{cmd:add()}, {cmd:replace}, {cmd:rseed()}, {cmd:double}, {cmd:by()}; see
{manhelp mi_impute MI:mi impute}.

{phang}
{opt knn(#)} specifies the number of closest observations (nearest neighbors)
from which to draw imputed values.  This option is required.  The closeness is
determined based on the absolute difference between the linear prediction for
the missing value and that for the complete values.  The closest observation
is the observation with the smallest difference.  This option regulates the
correlation among multiple imputations that affects the bias and the
variability of the resulting multiple-imputation point estimates; see
{mansection MI miimputepmmRemarksandexamples:{it:Remarks and examples}} in
{bf:[MI] mi impute pmm} for details.

{phang}
INCLUDE help mi_impute_uvopt_conditional.ihlp

{phang}
INCLUDE help mi_impute_uvopt_bootstrap.ihlp

{dlgtab:Reporting}

{phang}
{cmd:dots}, {cmd:noisily}, {cmd:nolegend}; see {manhelp mi_impute MI:mi impute}. 
{cmd:noisily} specifies that the output from the linear regression fit to
the observed data be displayed.
INCLUDE help mi_impute_uvopt_nolegend.ihlp

{dlgtab:Advanced}

{phang}
{cmd:force}; see {manhelp mi_impute MI:mi impute}.

{pstd}
The following option is available with {opt mi impute} but is not shown in the
dialog box:

{phang}
{cmd:noupdate}; see {manhelp noupdate_option MI:noupdate option}.


{marker examples}{...}
{title:Examples}

{pstd}
Setup
{p_end}
{phang2}
{cmd:. webuse mheart0}
{p_end}

{p 6 6 2}Declare data and register variable {cmd:bmi} as imputed{p_end}
{phang2}
{cmd:. mi set mlong}
{p_end}
{phang2}
{cmd:. mi register imputed bmi}
{p_end}

{pstd}
Impute {cmd:bmi} using predictive mean matching using 5 nearest neighbors
{p_end}
{phang2}
{cmd:. mi impute pmm bmi attack smokes age hsgrad female, add(20) knn(5)}
{p_end}

{pstd}
Impute {cmd:bmi} using 10 nearest neighbors
{p_end}
{phang2}
{cmd:. mi impute pmm bmi attack smokes age hsgrad female, replace knn(10)}
{p_end}


{marker video}{...}
{title:Video example}

{phang2}{browse "http://www.youtube.com/watch?v=c75E2LBGoBQ":Multiple imputation: Setup, imputation, estimation -- predictive mean matching}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mi impute pmm} stores the following in {cmd:r()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Scalars}{p_end}
{synopt:{cmd:r(M)}}total number of imputations{p_end}
{synopt:{cmd:r(M_add)}}number of added imputations{p_end}
{synopt:{cmd:r(M_update)}}number of updated imputations{p_end}
{synopt:{cmd:r(knn)}}number of k nearest neighbors{p_end}
{synopt:{cmd:r(k_ivars)}}number of imputed variables (always {cmd:1}){p_end}
{synopt:{cmd:r(N_g)}}number of imputed groups ({cmd:1} if {cmd:by()} is not specified){p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Macros}{p_end}
{synopt:{cmd:r(method)}}name of imputation method ({cmd:pmm}){p_end}
{synopt:{cmd:r(ivars)}}names of imputation variables{p_end}
{synopt:{cmd:r(rngstate)}}random-number state used{p_end}
{synopt:{cmd:r(by)}}names of variables specified within {cmd:by()}{p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Matrices}{p_end}
{synopt:{cmd:r(N)}}number of observations in imputation sample in each group{p_end}
{synopt:{cmd:r(N_complete)}}number of complete observations in imputation sample in each group{p_end}
{synopt:{cmd:r(N_incomplete)}}number of incomplete observations in imputation sample in each group{p_end}
{synopt:{cmd:r(N_imputed)}}number of imputed observations in imputation sample in each group{p_end}
