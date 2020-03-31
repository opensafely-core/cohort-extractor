{smcl}
{* *! version 1.0.20  14may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi impute mlogit" "mansection MI miimputemlogit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "[MI] Intro substantive" "help mi intro substantive"}{...}
{vieweralsosee "[MI] mi impute" "help mi_impute"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi impute ologit" "help mi_impute_ologit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi estimate" "help mi_estimate"}{...}
{viewerjumpto "Syntax" "mi_impute_mlogit##syntax"}{...}
{viewerjumpto "Menu" "mi_impute_mlogit##menu"}{...}
{viewerjumpto "Description" "mi_impute_mlogit##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_impute_mlogit##linkspdf"}{...}
{viewerjumpto "Options" "mi_impute_mlogit##options"}{...}
{viewerjumpto "Example" "mi_impute_mlogit##example"}{...}
{viewerjumpto "Stored results" "mi_impute_mlogit##results"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[MI] mi impute mlogit} {hline 2}}Impute using multinomial logistic regression{p_end}
{p2col:}({mansection MI miimputemlogit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 19 2}{cmd:mi} {cmdab:imp:ute} {cmdab:mlog:it} 
{it:ivar} [{it:{help indepvars}}] [{it:{help if}}]
[{it:{help mi impute mlogit##weight:weight}}]
[{cmd:,} {it:{help mi_impute##impopts:impute_options}} {it:options}] 

{synoptset 22 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{synopt: {opt nocons:tant}}suppress constant term{p_end}
{synopt: {opt b:aseoutcome(#)}}specify value of {it:ivar} that will be the base
 outcome{p_end}
{synopt: {opt aug:ment}}perform augmented regression in the presence of perfect prediction{p_end}
{synopt: {opth cond:itional(if)}}perform conditional imputation{p_end}
{synopt: {opt boot:strap}}estimate model parameters using sampling with replacement{p_end}

{syntab:Maximization}
{synopt :{it:{help mi_impute_mlogit##maximize_options:maximize_options}}}control the 
maximization process; seldom used{p_end}
{synoptline}
{p 4 6 2}
You must {cmd:mi set} your data before using {cmd:mi} {cmd:impute} {cmd:mlogit};
see {manhelp mi_set MI:mi set}.{p_end}
{p 4 6 2}
You must {cmd:mi register} {it:ivar} as imputed before using {cmd:mi}
{cmd:impute} {cmd:mlogit}; see {manhelp mi_set MI:mi set}.{p_end}
INCLUDE help fvvarlist
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s are
allowed; see {help weight}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:mi} {cmd:impute} {cmd:mlogit} fills in missing values of a nominal
variable by using the multinomial (polytomous) logistic regression imputation
method.  You can perform separate imputations on different subsets of the data
by specifying the {cmd:by()} option.  You can also account for frequency,
importance, and sampling weights.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI miimputemlogitRemarksandexamples:Remarks and examples}

        {mansection MI miimputemlogitMethodsandformulas:Methods and formulas}

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
{opt baseoutcome(#)} specifies the value of {it:ivar} to be treated
as the base outcome.  The default is to choose the most frequent outcome.

{phang}
INCLUDE help mi_impute_uvopt_augment.ihlp

{phang}
INCLUDE help mi_impute_uvopt_conditional.ihlp

{phang}
INCLUDE help mi_impute_uvopt_bootstrap.ihlp

{dlgtab:Reporting}

{phang}
{cmd:dots}, {cmd:noisily}, {cmd:nolegend}; see {manhelp mi_impute MI:mi impute}. 
{cmd:noisily} specifies that the output from the multinomial logistic
regression fit to the observed data be displayed.
INCLUDE help mi_impute_uvopt_nolegend.ihlp

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:{help mlogit##maximize_options:maximize_options}}; see {manhelp mlogit R}.
These options are seldom used.
{cmd:difficult}, {cmd:technique()}, {cmd:gradient}, {cmd:showstep},
{cmd:hessian}, and {cmd:showtolerance} are not allowed when the {cmd:augment}
option is used.

{dlgtab:Advanced}

{phang}
{cmd:force}; see {manhelp mi_impute MI:mi impute}.

{pstd}
The following option is available with {opt mi impute} but is not shown in the
dialog box:

{phang}
{cmd:noupdate}; see {manhelp noupdate_option MI:noupdate option}.


{marker example}{...}
{title:Example}

{pstd}
Setup
{p_end}
{phang2}
{cmd:. webuse mheart3}
{p_end}
{phang2}
{cmd:. tabulate marstatus, missing}
{p_end}

{p 6 6 2}Declare data and register {cmd:marstatus} as imputed{p_end}
{phang2}
{cmd:. mi set mlong}
{p_end}
{phang2}
{cmd:. mi register imputed marstatus}
{p_end}

{pstd}
Impute {cmd:marstatus} (marital status) using multinomial logistic regression
{p_end}
{phang2}
{cmd:. mi impute mlogit marstatus attack smokes age bmi female hsgrad, add(10)}
{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mi impute mlogit} stores the following in {cmd:r()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Scalars}{p_end}
{synopt:{cmd:r(M)}}total number of imputations{p_end}
{synopt:{cmd:r(M_add)}}number of added imputations{p_end}
{synopt:{cmd:r(M_update)}}number of updated imputations{p_end}
{synopt:{cmd:r(k_ivars)}}number of imputed variables (always {cmd:1}){p_end}
{synopt:{cmd:r(pp)}}{cmd:1} if perfect prediction detected, {cmd:0} otherwise{p_end}
{synopt:{cmd:r(N_g)}}number of imputed groups ({cmd:1} if {cmd:by()} is not specified){p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Macros}{p_end}
{synopt:{cmd:r(method)}}name of imputation method ({cmd:mlogit}){p_end}
{synopt:{cmd:r(ivars)}}names of imputation variables{p_end}
{synopt:{cmd:r(rngstate)}}random-number state used{p_end}
{synopt:{cmd:r(by)}}names of variables specified within {cmd:by()}{p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Matrices}{p_end}
{synopt:{cmd:r(N)}}number of observations in imputation sample in each group{p_end}
{synopt:{cmd:r(N_complete)}}number of complete observations in imputation sample
in each group{p_end}
{synopt:{cmd:r(N_incomplete)}}number of incomplete observations in imputation sample
in each group{p_end}
{synopt:{cmd:r(N_imputed)}}number of imputed observations in imputation sample in each group{p_end}
