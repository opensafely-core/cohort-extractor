{smcl}
{* *! version 1.0.13  14may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi impute truncreg" "mansection MI miimputetruncreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "[MI] Intro substantive" "help mi intro substantive"}{...}
{vieweralsosee "[MI] mi impute" "help mi_impute"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi impute intreg" "help mi_impute_intreg"}{...}
{vieweralsosee "[MI] mi impute pmm" "help mi_impute_pmm"}{...}
{vieweralsosee "[MI] mi impute regress" "help mi_impute_regress"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi estimate" "help mi_estimate"}{...}
{viewerjumpto "Syntax" "mi_impute_truncreg##syntax"}{...}
{viewerjumpto "Menu" "mi_impute_truncreg##menu"}{...}
{viewerjumpto "Description" "mi_impute_truncreg##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_impute_truncreg##linkspdf"}{...}
{viewerjumpto "Options" "mi_impute_truncreg##options"}{...}
{viewerjumpto "Example" "mi_impute_truncreg##example"}{...}
{viewerjumpto "Stored results" "mi_impute_truncreg##results"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[MI] mi impute truncreg} {hline 2}}Impute using truncated regression{p_end}
{p2col:}({mansection MI miimputetruncreg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 19 2}{cmd:mi} {cmdab:imp:ute} {cmdab:truncreg} 
{it:ivar} [{it:{help indepvars}}] [{it:{help if}}]
[{it:{help mi impute truncreg##weight:weight}}]
[{cmd:,} {it:{help mi_impute##impopts:impute_options}} {it:options}] 

{synoptset 22 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{synopt: {opt nocons:tant}}suppress constant term{p_end}
{synopt:{cmd:ll(}{varname}|{it:#}{cmd:)}}lower limit for left-truncation
{p_end}
{synopt:{cmd:ul(}{varname}|{it:#}{cmd:)}}upper limit for right-truncation
{p_end}
{synopt:{opth off:set(varname:varname_o)}}include {it:varname} in model with
coefficient constrained to 1{p_end}
{synopt: {opth cond:itional(if)}}perform conditional imputation{p_end}
{synopt: {opt boot:strap}}estimate model parameters using sampling with replacement{p_end}

{syntab:Maximization}
{synopt :{it:{help truncreg##maximize_options:maximize_options}}}control the 
maximization process; seldom used{p_end}
{synoptline}
{p 4 6 2}
You must {cmd:mi set} your data before using {cmd:mi} {cmd:impute}
{cmd:truncreg}; see {manhelp mi_set MI:mi set}.{p_end}
{p 4 6 2}
You must {cmd:mi register} {it:ivar} as imputed before using {cmd:mi}
{cmd:impute} {cmd:truncreg}; see {manhelp mi_set MI:mi set}.{p_end}
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
{cmd:mi} {cmd:impute} {cmd:truncreg} fills in missing values of a continuous
variable with a restricted range using a truncated regression
imputation method.  You can perform separate imputations on different subsets
of the data by specifying the {cmd:by()} option.  You can also account for
analytic, frequency, importance, and sampling weights.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI miimputetruncregRemarksandexamples:Remarks and examples}

        {mansection MI miimputetruncregMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt noconstant}; see {manhelp estimation_options R: Estimation options}.

{phang}
{cmd:add()}, {cmd:replace}, {cmd:rseed()}, {cmd:double}, {cmd:by()}; see
{manhelp mi_impute MI:mi impute}.

{phang}
{cmd:ll(}{varname}|{it:#}{cmd:)} and
{opt ul(varname|#)} indicate the lower and upper limits for truncation,
respectively.  You may specify one or both.
Observations with {it:ivar} {ul:<} {opt ll()} are left-truncated,
observations with {it:ivar} {ul:>} {opt ul()} are right-truncated,
and the remaining observations are not truncated.

{phang}
{opth offset:(varname:varname_o)}; see
{helpb estimation_options:[R] Estimation options}.

{phang}
INCLUDE help mi_impute_uvopt_conditional.ihlp

{phang}
INCLUDE help mi_impute_uvopt_bootstrap.ihlp

{dlgtab:Reporting}

{phang}
{cmd:dots}, {cmd:noisily}, {cmd:nolegend}; see {manhelp mi_impute MI:mi impute}.
{cmd:noisily} specifies that the output from a truncated regression fit to the
observed data be displayed.
INCLUDE help mi_impute_uvopt_nolegend.ihlp

{dlgtab:Maximization}

{phang}
{it:{help truncreg##maximize_options:maximize_options}}; see {manhelp truncreg R}.
These options are seldom used.

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

{pstd}Setup{p_end}
{phang2}
{cmd:. webuse mheart1s0}
{p_end}

{pstd}Describe {cmd:mi} data{p_end}
{phang2}
{cmd:. mi describe}
{p_end}

{pstd}
Impute {cmd:bmi} from a normal distribution truncated at [17, 39]
{p_end}
{phang2}
{cmd:. mi impute truncreg bmi attack smokes age female hsgrad, add(20) ll(17) ul(39)}
{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mi impute truncreg} stores the following in {cmd:r()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Scalars}{p_end}
{synopt:{cmd:r(M)}}total number of imputations{p_end}
{synopt:{cmd:r(M_add)}}number of added imputations{p_end}
{synopt:{cmd:r(M_update)}}number of updated imputations{p_end}
{synopt:{cmd:r(k_ivars)}}number of imputed variables (always {cmd:1}){p_end}
{synopt:{cmd:r(N_trunc)}}number of truncated observations{p_end}
{synopt:{cmd:r(N_ltrunc)}}number of left-truncated observations{p_end}
{synopt:{cmd:r(N_rtrunc)}}number of right-truncated observations{p_end}
{synopt:{cmd:r(ll)}}lower truncation limit (if {opt ll(#)} is specified){p_end}
{synopt:{cmd:r(ul)}}upper truncation limit (if {opt ll(#)} is specified){p_end}
{synopt:{cmd:r(N_g)}}number of imputed groups ({cmd:1} if {cmd:by()} is not specified){p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Macros}{p_end}
{synopt:{cmd:r(method)}}name of imputation method ({cmd:truncreg}){p_end}
{synopt:{cmd:r(ivars)}}names of imputation variables{p_end}
{synopt:{cmd:r(llopt)}}contents of {cmd:ll()}, if specified{p_end}
{synopt:{cmd:r(ulopt)}}contents of {cmd:ul()}, if specified{p_end}
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
