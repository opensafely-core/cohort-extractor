{smcl}
{* *! version 1.0.26  15may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi impute monotone" "mansection MI miimputemonotone"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "[MI] Intro substantive" "help mi intro substantive"}{...}
{vieweralsosee "[MI] mi impute" "help mi_impute"}{...}
{vieweralsosee "[MI] Glossary" "help mi glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi impute chained" "help mi_impute_chained"}{...}
{vieweralsosee "[MI] mi impute mvn" "help mi_impute_mvn"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi estimate" "help mi_estimate"}{...}
{viewerjumpto "Syntax" "mi_impute_monotone##syntax"}{...}
{viewerjumpto "Menu" "mi_impute_monotone##menu"}{...}
{viewerjumpto "Description" "mi_impute_monotone##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_impute_monotone##linkspdf"}{...}
{viewerjumpto "Options" "mi_impute_monotone##options"}{...}
{viewerjumpto "Examples" "mi_impute_monotone##examples"}{...}
{viewerjumpto "Stored results" "mi_impute_monotone##results"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[MI] mi impute monotone} {hline 2}}Impute missing values in monotone data{p_end}
{p2col:}({mansection MI miimputemonotone:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 4 4 2}Default specification of prediction equations, basic syntax

{p 8 19 2}{cmd:mi} {cmdab:imp:ute} {cmdab:mon:otone}
{cmd:(}{it:{help mi_impute_monotone##uvmethod:uvmethod}}{cmd:)}
       {it:{help mi_impute_monotone##ivars:ivars}}
[{cmd:=} {it:{help indepvars}}] [{it:{help if}}]
[{it:{help mi impute monotone##weight:weight}}]
[{cmd:,} {it:{help mi_impute##impopts:impute_options}}
         {it:{help mi_impute_monotone##opts1:options}}]


{p 4 4 2}Default specification of prediction equations, full syntax

{p 8 19 2}{cmd:mi} {cmdab:imp:ute} {cmdab:mon:otone} {it:lhs}
[{cmd:=} {it:{help indepvars}}] [{it:{help if}}]
[{it:{help mi impute monotone##weight:weight}}]
[{cmd:,} {it:{help mi_impute##impopts:impute_options}}
         {it:{help mi_impute_monotone##opts1:options}}]


{p 4 4 2}Custom specification of prediction equations

{p 8 19 2}{cmd:mi} {cmdab:imp:ute} {cmdab:mon:otone} {it:cmodels}
[{it:{help if}}]
[{it:{help mi impute monotone##weight:weight}}]{cmd:,}
 {opt c:ustom} [{it:{help mi_impute##impopts:impute_options}}
 {it:{help mi_impute_monotone##opts1:options}}]


{phang}
where {it:lhs} is {it:lhs_spec} [{it:lhs_spec} [...]] and {it:lhs_spec} is

{phang2}
{cmd:(}{it:{help mi_impute_monotone##uvmethod:uvmethod}} [{it:{help if}}]
[{cmd:,} {it:{help mi_impute_monotone##uvspec_options:uvspec_options}}]{cmd:)}
         {it:{help mi_impute_monotone##ivars:ivars}}

{pstd}
{it:cmodels} is {cmd:(}{it:cond_spec}{cmd:)} [{cmd:(}{it:cond_spec}{cmd:)}
    [...]] and a conditional specification, {it:cond_spec}, is

{phang2}
{it:{help mi_impute_monoton##uvmethod:uvmethod}} 
{it:{help mi_impute_monotone##ivars:ivar}} [{it:rhs_spec}] [{it:{help if}}]
[{cmd:,} {it:{help mi_impute_monotone##uvspec_options:uvspec_options}}]

{pstd}
{it:rhs_spec} includes {it:{help varlist}} and expressions of imputation
variables bound in parentheses.

{marker ivars}{...}
{phang}
{it:ivar}({it:s}) (or {it:newivar} if {it:uvmethod} is {cmd:intreg})
is the name(s) of the imputation variable(s).

{marker uvspec_options}{...}
{phang}
{it:uvspec_options} are {opt asc:ontinuous}, {opt noi:sily}, and the
method-specific {it:options} as described in the manual entry for each
{help mi_impute_monotone##uvmethod:univariate imputation method}.


{marker uvmethod}{...}
{synoptset 15}{...}
{synopthdr:uvmethod}
{synoptline}
{synopt: {opt reg:ress}}linear regression for a continuous variable;
       {manhelp mi_impute_regress MI:mi impute regress}{p_end}
{synopt: {opt pmm}}predictive mean matching for a continuous variable;
       {manhelp mi_impute_pmm MI:mi impute pmm}{p_end}
{synopt: {opt truncreg}}truncated regression for a continuous variable with a restricted range;
       {manhelp mi_impute_truncreg MI:mi impute truncreg}{p_end}
{synopt: {opt intreg}}interval regression for a continuous partially observed (censored) variable; {manhelp mi_impute_intreg MI:mi impute intreg}{p_end}
{synopt: {opt logi:t}}logistic regression for a binary variable; 
       {manhelp mi_impute_logit MI:mi impute logit}{p_end}
{synopt: {opt olog:it}}ordered logistic regression for an ordinal variable; 
       {manhelp mi_impute_ologit MI:mi impute ologit}{p_end}
{synopt: {opt mlog:it}}multinomial logistic regression for a nominal variable;
       {manhelp mi_impute_mlogit MI:mi impute mlogit}{p_end}
{synopt: {opt poisson}}Poisson regression for a count variable;
       {manhelp mi_impute_poisson MI:mi impute poisson}{p_end}
{synopt: {opt nbreg}}negative binomial regression for an overdispersed count variable;
       {manhelp mi_impute_nbreg MI:mi impute nbreg}{p_end}
{synoptline}


{marker opts1}{...}
{synoptset 15 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{p2coldent:* {opt c:ustom}}customize prediction equations of conditional
        specifications{p_end}
{synopt:{opt aug:ment}}perform augmented regression in the presence of perfect prediction for all categorical imputation variables{p_end}
{synopt:{opt boot:strap}}estimate model parameters using sampling with replacement{p_end}

{syntab:Reporting}
{synopt: {opt dryrun}}show conditional specifications without imputing data{p_end}
{synopt: {opt verbose}}show conditional specifications and impute data;
     implied when {cmd:custom} prediction equations are not specified{p_end}
{synopt: {opt report}}show report about each conditional specification{p_end}

{syntab:Advanced}
{synopt: {opt nomonotonechk}}do not check whether variables follow a monotone-missing pattern{p_end}
{synoptline}
{p 4 6 2}
* {cmd:custom} is required when specifying customized predictions equations.
{p_end}
{p 4 6 2}
You must {cmd:mi} {cmd:set} your data before using {cmd:mi} {cmd:impute}
{cmd:monotone}; see {manhelp mi_set MI:mi set}.{p_end}
{p 4 6 2}
You must {cmd:mi} {cmd:register} {it:ivars} as imputed before using {cmd:mi}
{cmd:impute} {cmd:monotone}; see {manhelp mi_set MI:mi set}.{p_end}
{p 4 6 2}
{it:indepvars} and {it:rhs_spec} may contain factor variables; see {help fvvarlist}.
{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s, {cmd:aweight}s ({cmd:regress}, {cmd:pmm}, {cmd:truncreg}, and
{cmd:intreg} only), {cmd:iweight}s, and {cmd:pweight}s are allowed; see
{help weight}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:mi} {cmd:impute} {cmd:monotone} fills in missing values in multiple
variables by using a sequence of independent univariate conditional imputation
methods.  Variables to be imputed, {it:ivars}, must follow a
monotone-missing pattern (see {manlink MI Intro substantive}).  You can perform
separate imputations on different subsets of the data by specifying the
{cmd:by()} option.  You can also account for frequency, analytic (with
continuous variables only), importance, and sampling weights.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI miimputemonotoneRemarksandexamples:Remarks and examples}

        {mansection MI miimputemonotoneMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:custom} is required to build customized prediction equations within the
univariate conditional specifications.  Otherwise, the
default specification of prediction equations is assumed.

{phang}
{cmd:add()}, {cmd:replace}, {cmd:rseed()}, {cmd:double}, {cmd:by()}; see
{manhelp mi_impute MI:mi impute}.

{phang}
INCLUDE help mi_impute_uvopt_augment
This option is equivalent to specifying {cmd:augment} within univariate
specifications of all categorical imputation methods.

{phang}
INCLUDE help mi_impute_uvopt_bootstrap
This option is equivalent to specifying {cmd:bootstrap} within all univariate
specifications.

{pstd}
The following options appear on a Specification dialog that appears when you
click on the {bf:Create ...} button of the {bf:Main} tab.

{phang}
{it:uvspec_options} are options specified within each univariate imputation
method, {it:uvmethod}.  {it:uvspec_options} include {opt asc:ontinuous},
{opt noi:sily}, and the method-specific {it:options} as described in the manual
entry for each univariate imputation method.

{phang2}
{opt ascontinuous} specifies that categorical imputation variables
corresponding to the current {it:uvmethod} be included as continuous in all
prediction equations.  This option is only allowed when {it:uvmethod} is
{cmd:logit}, {cmd:ologit}, or {cmd:mlogit}.

{phang2}
{opt noisily} specifies that the output from the current univariate model fit
to the observed data be displayed.

{dlgtab:Reporting}

{phang}
{cmd:dots}, {cmd:noisily}, {cmd:nolegend}; see
{manhelp mi_impute MI:mi impute}.  {cmd:noisily} specifies that the output
from all univariate conditional models fit to the observed data be displayed.
{cmd:nolegend} suppresses all imputation table legends which include a legend
with the titles of the univariate imputation methods used, a legend about
conditional imputation when {cmd:conditional()} is used within univariate
specifications, and group legends when {cmd:by()} is specified.

{phang}
{cmd:dryrun} specifies to show the conditional specifications that would be
used to impute each variable without actually imputing data.  This option is
recommended for checking specifications of conditional models prior to
imputation.

{phang}
{cmd:verbose} specifies to show conditional specifications and impute data.
{cmd:verbose} is implied when custom prediction equations are not specified.

{phang}
{cmd:report} specifies to show a report about each univariate conditional
specification.  This option, in a combination with {cmd:dryrun}, is
recommended for checking specifications of conditional models prior to
imputation.

{dlgtab:Advanced}

{phang}
{cmd:force}; see {manhelp mi_update MI:mi impute}.

{phang}
{cmd:nomonotonechk} specifies not to check that imputation variables follow a
monotone-missing pattern.  This option may be used to avoid potentially
time-consuming checks.  The monotonicity check may be time consuming when a
large number of variables is being imputed.  If you use {cmd:nomonotonechk}
with a custom specification, make sure that you list the univariate
conditional specifications in the order of monotonicity or you might obtain
incorrect results.

{pstd}
The following option is available with {opt mi impute} but is not shown in the
dialog box:

{phang}
{cmd:noupdate}; see {manhelp noupdate_option MI:noupdate option}.


{marker examples}{...}
{title:Examples:  Default prediction equations}

{pstd}
    Setup
{p_end}
{phang2}
{cmd:. webuse mheart5s0}
{p_end}

{pstd}
    Describe {cmd:mi} data
{p_end}
{phang2}
{cmd:. mi describe}
{p_end}

{pstd}
    Examine missing-data patterns
{p_end}
{phang2}
{cmd:. mi misstable nested}
{p_end}

{pstd}
Impute {cmd:bmi} and {cmd:age} via linear regression
{p_end}
{phang2}
{cmd:. mi impute monotone (regress) bmi age = attack smokes hsgrad female, add(10)}
{p_end}

{pstd}
Impute {cmd:bmi} using linear regression, {cmd:age} using predictive mean
matching
{p_end}
{phang2}
{cmd:. mi impute monotone (regress) bmi (pmm, knn(5)) age = attack smokes hsgrad female, replace}
{p_end}
{phang2}


{title:Examples:  Custom prediction equations}

{pstd}
    Setup
{p_end}
{phang2}
{cmd:. webuse mheart6s0, clear}
{p_end}

{pstd}
    Describe {cmd:mi} data
{p_end}
{phang2}
{cmd:. mi describe}
{p_end}

{pstd}
    Examine missing-data patterns
{p_end}
{phang2}
{cmd:. mi misstable nested}
{p_end}

{pstd}
Specify custom equations for each of {cmd:hightar}, {cmd:bmi}, and {cmd:age};
include {cmd:bmi} squared in equation for {cmd:age}
{p_end}
{phang2}
{cmd:. mi impute monotone ///}{break}
{cmd:(logit hightar attack hsgrad female if smokes) ///}{break}
{cmd:(pmm bmi hightar attack smokes hsgrad female, knn(5)) ///}{break}
{cmd:(regress age bmi (bmi^2) hightar attack smokes hsgrad female),}
{cmd:custom add(10)}
{p_end}


{title:Examples:  Imputing on subsamples}

{pstd}
    Setup
{p_end}
{phang2}
{cmd:. webuse mheart5s0, clear}
{p_end}

{pstd}
Impute {cmd:bmi} and {cmd:age} using predictive mean matching separately for
males and females
{p_end}
{phang2}
{cmd:. mi impute monotone (pmm, knn(5)) bmi age = attack smokes hsgrad, add(10) by(female)}
{p_end}


{title:Examples:  Conditional imputation}

{pstd}
    Setup
{p_end}
{phang2}
{cmd:. webuse mheart7s0, clear}
{p_end}

{pstd}
    Describe {cmd:mi} data
{p_end}
{phang2}
{cmd:. mi describe}
{p_end}

{pstd}
    Impute {cmd:bmi} and {cmd:age} using predictive mean matching, and
    {cmd:smokes} and {cmd:hightar} using logistic regression; impute
    {cmd:hightar} using only observations for which {cmd:smokes==1}
{p_end}
{phang2}
{cmd:. mi impute monotone ///}{break}
{cmd:    (pmm, knn(5)) bmi ///}{break}
{cmd:    (pmm, knn(5)) age ///}{break}
{cmd:    (logit, cond(if smokes==1)) hightar ///}{break}
{cmd:    (logit) smokes = attack hsgrad female, add(10)}
{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mi impute monotone} stores the following in {cmd:r()}:

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Scalars}{p_end}
{synopt:{cmd:r(M)}}total number of imputations{p_end}
{synopt:{cmd:r(M_add)}}number of added imputations{p_end}
{synopt:{cmd:r(M_update)}}number of updated imputations{p_end}
{synopt:{cmd:r(k_ivars)}}number of imputed variables{p_end}
{synopt:{cmd:r(N_g)}}number of imputed groups ({cmd:1} if {cmd:by()} is not specified){p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Macros}{p_end}
{synopt:{cmd:r(method)}}name of imputation method ({cmd:monotone}){p_end}
{synopt:{cmd:r(ivars)}}names of imputation variables{p_end}
{synopt:{cmd:r(rngstate)}}random-number state used{p_end}
{synopt:{cmd:r(uvmethods)}}names of univariate conditional imputation methods{p_end}
{synopt:{cmd:r(by)}}names of variables specified within {cmd:by()}{p_end}

{synoptset 25 tabbed}{...}
{p2col 5 25 29 2: Matrices}{p_end}
{synopt:{cmd:r(N)}}number of observations in imputation sample in each group (per variable){p_end}
{synopt:{cmd:r(N_complete)}}number of complete observations in imputation sample in each group (per variable)
{p_end}
{synopt:{cmd:r(N_incomplete)}}number of incomplete observations in imputation sample in each group (per variable)
{p_end}
{synopt:{cmd:r(N_imputed)}}number of imputed observations in imputation sample in each group (per variable){p_end}
