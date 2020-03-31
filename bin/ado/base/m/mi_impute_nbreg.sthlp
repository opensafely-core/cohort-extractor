{smcl}
{* *! version 1.0.10  14may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi impute nbreg" "mansection MI miimputenbreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "[MI] Intro substantive" "help mi intro substantive"}{...}
{vieweralsosee "[MI] mi impute" "help mi_impute"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi impute poisson" "help mi_impute_poisson"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi estimate" "help mi_estimate"}{...}
{viewerjumpto "Syntax" "mi_impute_nbreg##syntax"}{...}
{viewerjumpto "Menu" "mi_impute_nbreg##menu"}{...}
{viewerjumpto "Description" "mi_impute_nbreg##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_impute_nbreg##linkspdf"}{...}
{viewerjumpto "Options" "mi_impute_nbreg##options"}{...}
{viewerjumpto "Example" "mi_impute_nbreg##example"}{...}
{viewerjumpto "Stored results" "mi_impute_nbreg##results"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[MI] mi impute nbreg} {hline 2}}Impute using negative binomial regression{p_end}
{p2col:}({mansection MI miimputenbreg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 19 2}{cmd:mi} {cmdab:imp:ute} {cmd:nbreg} 
{it:ivar} [{it:{help indepvars}}] [{it:{help if}}]
[{it:{help mi impute nbreg##weight:weight}}]
[{cmd:,} {it:{help mi_impute##impopts:impute_options}} {it:options}] 

{synoptset 22 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{synopt: {opt nocons:tant}}suppress constant term{p_end}
{synopt :{cmdab:d:ispersion(}{opt m:ean}{cmd:)}}parameterization of dispersion; the default{p_end}
{synopt :{cmdab:d:ispersion(}{opt c:onstant}{cmd:)}}constant dispersion for all observations{p_end}
{synopt :{opth exp:osure(varname:varname_e)}}include ln({it:varname_e}) in
model with coefficient constrained to 1{p_end}
{synopt :{opth off:set(varname:varname_o)}}include {it:varname_o} in model with
coefficient constrained to 1{p_end}
{synopt: {opth cond:itional(if)}}perform conditional imputation{p_end}
{synopt: {opt boot:strap}}estimate model parameters using sampling with replacement{p_end}

{syntab:Maximization}
{synopt :{it:{help nbreg##nbreg_maximize:maximize_options}}}control the 
maximization process; seldom used{p_end}
{synoptline}
{p 4 6 2}
You must {cmd:mi set} your data before using {cmd:mi} {cmd:impute} {cmd:nbreg};
see {manhelp mi_set MI:mi set}.{p_end}
{p 4 6 2}
You must {cmd:mi register} {it:ivar} as imputed before using {cmd:mi}
{cmd:impute} {cmd:nbreg}; see {manhelp mi_set MI:mi set}.{p_end}
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
{cmd:mi} {cmd:impute} {cmd:nbreg} fills in missing values of an overdispersed
count variable using the negative binomial regression imputation method.
You can perform separate imputations on different subsets of the data by
specifying the {cmd:by()} option.  You can also account for frequency,
importance, and sampling weights.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI miimputenbregRemarksandexamples:Remarks and examples}

        {mansection MI miimputenbregMethodsandformulas:Methods and formulas}

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
{cmd:dispersion(mean}{c |}{cmd:constant)}; see {manhelp nbreg R}.

{phang}
{opth "exposure(varname:varname_e)"},
{opt offset(varname_o)}; 
see {manhelp estimation_options R:Estimation options}.

{phang}
INCLUDE help mi_impute_uvopt_conditional.ihlp

{phang}
INCLUDE help mi_impute_uvopt_bootstrap.ihlp

{dlgtab:Reporting}

{phang}
{cmd:dots}, {cmd:noisily}, {cmd:nolegend}; see {manhelp mi_impute MI:mi impute}. 
{cmd:noisily} specifies that the output from the negative binomial regression
fit to the observed data be displayed.
INCLUDE help mi_impute_uvopt_nolegend.ihlp

{dlgtab:Maximization}

{phang}
{it:{help nbreg##nbreg_maximize:maximize_options}}; see {manhelp nbreg R}.
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
{cmd:. webuse mheartpois}
{p_end}
{phang2}
{cmd:. misstable summarize}
{p_end}

{pstd}Check for overdispersion in {cmd:npreg} in the original data{p_end}
{phang2}
{cmd:. nbreg npreg attack smokes age bmi hsgrad if female==1, nolog}
{p_end}

{pstd}Declare data and register {cmd:npreg} as imputed{p_end}
{phang2}
{cmd:. mi set mlong}
{p_end}
{phang2}
{cmd:. mi register imputed npreg}
{p_end}

{pstd}
Impute count variable {cmd:npreg} conditionally on {cmd:female}
{p_end}
{phang2}
{cmd:. mi impute nbreg npreg attack smokes age bmi hsgrad, add(10) conditional(if female==1)}
{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mi impute nbreg} stores the following in {cmd:r()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Scalars}{p_end}
{synopt:{cmd:r(M)}}total number of imputations{p_end}
{synopt:{cmd:r(M_add)}}number of added imputations{p_end}
{synopt:{cmd:r(M_update)}}number of updated imputations{p_end}
{synopt:{cmd:r(k_ivars)}}number of imputed variables (always {cmd:1}){p_end}
{synopt:{cmd:r(N_g)}}number of imputed groups ({cmd:1} if {cmd:by()} is not specified){p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Macros}{p_end}
{synopt:{cmd:r(method)}}name of imputation method ({cmd:nbreg}){p_end}
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
{synopt:{cmd:r(N_imputed)}}number of imputed observations in imputation sample
in each group{p_end}
