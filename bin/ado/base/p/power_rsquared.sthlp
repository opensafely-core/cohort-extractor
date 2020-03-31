{smcl}
{* *! version 1.0.11  21mar2019}{...}
{viewerdialog "power (test all)" "dialog power_rsquared_all"}{...}
{viewerdialog "power (test subset)" "dialog power_rsquared_subset"}{...}
{vieweralsosee "[PSS-2] power rsquared" "mansection PSS-2 powerrsquared"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power" "help power"}{...}
{vieweralsosee "[PSS-2] power oneslope" "help power oneslope"}{...}
{vieweralsosee "[PSS-2] power pcorr" "help power pcorr"}{...}
{vieweralsosee "[PSS-2] power, graph" "help power_optgraph"}{...}
{vieweralsosee "[PSS-2] power, table" "help power_opttable"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[R] test" "help test"}{...}
{viewerjumpto "Syntax" "power_rsquared##syntax"}{...}
{viewerjumpto "Menu" "power_rsquared##menu"}{...}
{viewerjumpto "Description" "power_rsquared##description"}{...}
{viewerjumpto "Links to PDF documentation" "power_rsquared##linkspdf"}{...}
{viewerjumpto "Options" "power_rsquared##options"}{...}
{viewerjumpto "Remarks: Using power rsquared" "power_rsquared##remarks"}{...}
{viewerjumpto "Examples" "power_rsquared##examples"}{...}
{viewerjumpto "Stored results" "power_rsquared##stored_results"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[PSS-2] power rsquared} {hline 2}}Power analysis for an R-squared test
in a multiple linear regression{p_end}
{p2col:}({mansection PSS-2 powerrsquared:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Compute sample size 

{p 6 8 2}
        Test all coefficients

{p 8 43 2}
{opt power} {opt rsq:uared} {it:R2T} 
[{cmd:,}
{opth p:ower(numlist)}
{it:{help power_rsquared##synoptions:options}}]

{p 6 8 2}
        Test a subset of coefficients

{p 8 43 2}
{opt power} {opt rsq:uared} {it:R2R} {it:R2F}{cmd:,}
{opth nc:ontrol(numlist)}
[{opth p:ower(numlist)}
{it:{help power_rsquared##synoptions:options}}]


{phang}
Compute power 

{p 6 8 2}
        Test all coefficients

{p 8 43 2}
{opt power} {opt rsq:uared} {it:R2T}{cmd:,}
{opth n(numlist)} [{it:{help power_rsquared##synoptions:options}}]

{p 6 8 2}
        Test a subset of coefficients

{p 8 43 2}
{opt power} {opt rsq:uared} {it:R2R} {it:R2F}{cmd:,}
{opth nc:ontrol(numlist)}
{opth n(numlist)}
[{it:{help power_rsquared##synoptions:options}}]


{phang}
Compute effect size and target R-squared

{p 6 8 2}
        Test all coefficients

{p 8 43 2}
{opt power} {opt rsq:uared}{cmd:,} {opth n(numlist)} 
{opth p:ower(numlist)} [{it:{help power_rsquared##synoptions:options}}]

{p 6 8 2}
        Test a subset of coefficients

{p 8 43 2}
{opt power} {opt rsq:uared} {it:R2R}{cmd:,}
{opth nc:ontrol(numlist)}
{opth n(numlist)}
{opth p:ower(numlist)}
[{it:{help power_rsquared##synoptions:options}}]


{phang}
where {it:R2T} is the hypothesized R-squared of the tested model under the
alternative hypothesis when testing all coefficients in the model, {it:R2R} is
the R-squared of the reduced model, and {it:R2F} is the hypothesized R-squared
of the full model when testing a subset of coefficients in the model.

{pmore}
{it:R2T}, {it:R2R}, and {it:R2F} may each be specified either as one number or
as a list of values in parentheses (see {it:{help numlist}}).{p_end}


{synoptset 28 tabbed}{...}
{marker synoptions}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
INCLUDE help pss_testmainopts1
{synopt: {opt nfrac:tional}}allow fractional sample size{p_end}
{p2coldent:* {opth ntest:ed(numlist)}}number of tested covariates{p_end}
{p2coldent:* {opth nc:ontrol(numlist)}}number of control covariates; required
for testing a subset of coefficients{p_end}
{p2coldent:* {opth diff(numlist)}}difference between the R-squared of the
full and the reduced model, {it:R2F}-{it:R2R}; specify instead of the 
R-squared of the full model, {it:R2F}, when testing a subset of coefficients{p_end}
{synopt: {opt par:allel}}treat number lists in starred options
as parallel when multiple values per option or arguments are
specified (do not enumerate all possible combinations of values)

{syntab:Table}
{synopt :[{cmdab:no:}]{cmdab:tab:le}[{cmd:(}{it:{help power_rsquared##tablespec:tablespec}}{cmd:)}]}suppress table or display
results as a table; see {manhelp power_opttable PSS-2:power, table}{p_end}
{synopt :{cmdab:sav:ing(}{it:{help filename}}[{cmd:, replace}]{cmd:)}}save the
table data to {it:filename}; use {cmd:replace} to overwrite existing
{it:filename}{p_end}

INCLUDE help pss_graphopts

{syntab:Iteration}
{synopt: {opt init(#)}}initial value for sample size or R-squared of tested 
model in the case of testing all coefficients and R-squared difference in the 
case of testing a subset of coefficients{p_end}
INCLUDE help pss_iteropts

INCLUDE help pss_reportopts
{synoptline}
{p2colreset}{...}
INCLUDE help pss_numlist
{p 4 6 2}{cmd:notitle} does not appear in the dialog box.{p_end}

{marker tablespec}{...}
{pstd}
where {it:tablespec} is

{p 16 16 2}
{it:{help power_rsquared##column:column}}[{cmd::}{it:label}]
[{it:column}[{cmd::}{it:label}] [...]] [{cmd:,} {it:{help power_opttable##tableopts:tableopts}}]

{pstd}
{it:column} is one of the columns defined below,
and {it:label} is a column label (may contain quotes and compound quotes).

{synoptset 28}{...}
{marker column}{...}
{synopthdr :column}
{synoptline}
{synopt :{opt alpha}}significance level{p_end}
{synopt :{opt power}}power{p_end}
{synopt :{opt beta}}type II error probability{p_end}
{synopt :{opt N}}number of subjects{p_end}
{synopt :{opt delta}}effect size{p_end}
{synopt :{opt R2_T}}R-squared of the tested model{p_end}
{synopt :{opt R2_R}}R-squared of the reduced model{p_end}
{synopt :{opt R2_F}}R-squared of the full model{p_end}
{synopt :{opt R2_diff}}difference of R-squared between full and reduced models{p_end}
{synopt :{opt ntested}}number of tested covariates{p_end}
{synopt :{opt ncontrol}}number of control covariates{p_end}
{synopt :{opt target}}target parameter; synonym for {cmd:R2_T} or
{cmd:R2_diff}{p_end}
{synopt :{opt _all}}display all supported columns{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}Column {cmd:beta} is shown in the default table in place of column
{cmd:power} if specified.{p_end}
{p 4 6 2}Column {cmd:R2_T} is shown in the default table for a test of all
coefficients and is not available if {cmd:ncontrol()} is specified.{p_end}
{p 4 6 2}Columns {cmd:R2_R}, {cmd:R2_F}, {cmd:R2_diff}, and {cmd:ncontrol} are
shown in the default table for a subset of coefficients and only available if
{cmd:ncontrol()} is specified.{p_end}
{p 4 6 2}For a test of all coefficients, {cmd:target} is {cmd:R2_T}. For a
test of a subset of coefficients, {cmd:target} is {cmd:R2_diff}.


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
{cmd:power} {cmd:rsquared} computes sample size, power, or target R-squared
for an R-squared test in a multiple linear regression.  An R-squared test is an
F test for the coefficient of determination, R-squared, which is used to test
the significance of all coefficients or of a subset of coefficients in a
regression model.

{pstd}
By default, {cmd:power rsquared} computes sample size for a test of all
coefficients given power and the R-squared of the tested model, {it:R2T}.
Instead of the sample size, it can compute power given sample size and
{it:R2T} or the target {it:R2T} given sample size and power.

{pstd}
If the number of control covariates is provided, {cmd:power rsquared} computes
sample size for a test of a subset of coefficients given power, the R-squared
of the full model, {it:R2F}, and the R-squared of the reduced model, {it:R2R}.
It can also compute power given sample size, {it:R2R}, and {it:R2F} or the
target {it:R2F} given sample size, power, and {it:R2R}.

{pstd}
See {manhelp power PSS-2} for a general introduction to the {cmd:power} command
using hypothesis tests.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-2 powerrsquaredQuickstart:Quick start}

        {mansection PSS-2 powerrsquaredRemarksandexamples:Remarks and examples}

        {mansection PSS-2 powerrsquaredMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:alpha()}, {cmd:power()}, {cmd:beta()}, {cmd:n()}, {cmd:nfractional}; see
{manhelp power##mainopts PSS-2:power}.
The {opt nfractional} option is allowed only for sample-size determination.

{phang}
{opth ntested(numlist)} specifies the number of tested covariates.  The
default is {cmd:ntested(1)}.

{phang}
{opth ncontrol(numlist)} specifies the number of control covariates or
the number of the covariates in the reduced model.  This option is
required for testing a subset of coefficients. If the option is not
specified, all coefficients are assumed to be tested.

{phang}
{opth diff(numlist)} specifies the difference between the R-squared of
the full and reduced models, {it:R2F} - {it:R2R}, when computing sample size
or power for a test of a subset of coefficients.  You may specify either the
R-squared of the full model, {it:R2F}, as a command argument or the difference
{it:R2F} - {it:R2R} in the {opt diff()} option.  This option is not allowed with
the effect-size computation.

{phang}
{cmd:parallel}; see {manhelp power##mainopts PSS-2:power}.

INCLUDE help pss_taboptsdes

INCLUDE help pss_graphoptsdes
Also see the {mansection PSS-2 powerrsquaredSyntaxcolumn:column} table in
{bf:[PSS-2] power rsquared} for a list of symbols used by the graphs.

{dlgtab:Iteration}

{phang}
{opt init(#)} specifies the initial value of the sample size for the
sample-size determination or the initial value of the R-squared of the tested
model in the case of testing all coefficients and the difference between the
R-squared of the full and reduced models in the case of testing a subset of
coefficients for the effect-size determination.  The default is to use a
bisection search method to compute an initial value.

INCLUDE help pss_iteroptsdes

{pstd}
The following option is available with {cmd:power rsquared} but is not shown
in the dialog box:

INCLUDE help pss_reportoptsdes


{marker remarks}{...}
{title:Remarks: Using power rsquared}

{pstd}
{cmd:power rsquared} computes sample size, power, or target slope for an
R-squared test in a multiple linear regression.  By default, all computations
are performed at the significance level of 0.05.  You may change the
significance level by specifying the {cmd:alpha()} option.

{pstd}
By default,  the number of tested covariates is set to 1. You can change the
number of tested covariates with the {cmd:ntested()} option.  All
computations assume that the model includes a constant. To test a subset
of coefficients, you must also specify the {cmd:ncontrol()} option.

{pstd}
To compute sample size for testing all coefficients in the model, you must
specify the R-squared of the tested model, {it:R2T}. For testing a subset of
coefficients, you must specify the R-squared of the reduced model, {it:R2R},
and the R-squared of the full model, {it:R2F}.  For either test, you can
specify the power of the test in the {cmd:power()} option.  The default power
is set to 0.8.

{pstd}
To compute power, you must specify the sample size in the {cmd:n()} option.
To test all coefficients in the model, you must also specify {it:R2T}. To test
a subset of coefficients, you must also specify {it:R2R} and {it:R2F}.

{pstd}
When computing sample size or power for a subset of coefficients, you can
specify the difference between the R-squared of the full and reduced
models in the {cmd:diff()} option instead of {it:R2F}.

{pstd}
To compute effect size, which is defined as the ratio of R-squared explained
by the tested covariates to the variance explained by the model error, you
must specify the sample size in the {cmd:n()} option and the power of the test
in the {cmd:power()} option.  For a test of all coefficients, {cmd:power}
{cmd:rsquared} reports the effect size and {it:R2T}. For a test of a subset of
coefficients, you must also specify {it:R2R} to obtain the effect size.  For
this test, {cmd:power rsquared} reports the effect size and the difference
between the R-squared statistics of the full and reduced models.

{pstd}
By default, the computed sample size is rounded up.  You can specify the
{cmd:nfractional} option to see the corresponding fractional sample size; see
{mansection PSS-4 UnbalanceddesignsRemarksandexamplesFractionalsamplesizes:{it:Fractional sample sizes}} in 
{bf:[PSS-4] Unbalanced designs} for an example.  The
{cmd:nfractional} option is allowed only for sample-size determination.

{pstd}
{cmd:power rsquared}'s computations of sample size and effect size
require iteration, because the denominator degrees of freedom of the
noncentral F distribution depends on the sample size, and the
noncentrality parameter depends on the sample size and effect size. The
default initial values are obtained using a bisection search method. You
can use the {cmd:init()} option to specify your own value. The initial value
of the sample size must be greater than the number of parameters in the
multiple regression model.  See {helpb power:[PSS-2] power} for the descriptions
of other options that control the iteration procedure.


{marker examples}{...}
{title:Examples}

    {title:Examples: Computing sample size}

{pstd}
Compute sample size required to detect an R-squared of 0.1; assume that
there is only one tested covariate in the model, significance level
is 5%, and power is 80% (the defaults){p_end}
{phang2}{cmd:. power rsquared 0.1}

{pstd}
Same as above, but assume that the number of tested covariates is 3{p_end}
{phang2}{cmd:. power rsquared 0.1, ntested(3)}

{pstd}
Compute sample size for an R-squared test with 2 control covariates given
R-squared of the reduced model of 0.10 and the R-squared of the full model
of 0.15; assume that there is only one tested covariate in the model,
significance level is 5%, and power is 80% (the defaults){p_end}
{phang2}{cmd:. power rsquared 0.1 0.15, ncontrol(2)}

{pstd}
Same as above, but assume that the number of tested covariates is 3{p_end}
{phang2}{cmd:. power rsquared 0.1 0.15, ncontrol(2) ntested(3)}

{pstd}
Same as above, but specify the difference of the R-squared between the full
and reduced models instead of R-squared of the full model{p_end}
{phang2}{cmd:. power rsquared 0.1, ncontrol(2) ntested(3) diff(0.05)}


    {title:Examples: Computing power}

{pstd}
Compute the power of an R-squared test for all coefficients; assume the sample 
size is 80, R-squared is 0.1, significance level is 5%, and 3 tested 
covariates{p_end}
{phang2}{cmd:. power rsquared 0.1, n(80) ntested(3)}

{pstd}
Compute the power with 2 control and 3 tested covariates{p_end}
{phang2}{cmd:. power rsquared 0.1 0.15, n(80) ncontrol(2) ntested(3)}

{pstd}
Compute power for a list of R-squared values for the full model, graphing the 
results{p_end}
{phang2}{cmd:. power rsquared 0.1 (0.15(0.05)0.4), n(80) ncontrol(2) ntested(3) graph}


    {title:Examples: Computing target R-squared}

{pstd}
Compute the minimum value of the R-squared for all covariates that can be detected 
with 80 observations, a power of 80%, and the default 5% significance level; 
assume that the number of tested covariates is 3{p_end}
{phang2}{cmd:. power rsquared, n(80) power(0.8) ntested(3)}

{pstd}
Compute the minimum value of the R-squared of the full model that can be
detected given the R-squared of the reduced model of 0.1, with 80
observations, a power of 80%, and the default 5% significance level; assume
that there are 2 control covariates and 3 tested covariates{p_end}
{phang2}{cmd:. power rsquared 0.1, n(80) power(0.8) ncontrol(2) ntested(3)}


{marker stored_results}{...}
{title:Stored results}

{pstd}
{cmd:power rsquared} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd: r(alpha)}}significance level{p_end}
{synopt:{cmd: r(power)}}power{p_end}
{synopt:{cmd: r(beta)}}probability of a type II error{p_end}
{synopt:{cmd: r(delta)}}effect size{p_end}
{synopt:{cmd: r(N)}}sample size{p_end}
{synopt:{cmd: r(nfractional)}}{cmd:1} if {cmd:nfractional} is specified, {cmd:0} otherwise{p_end}
{synopt:{cmd: r(R2_T)}}R-squared of the tested model{p_end}
{synopt:{cmd: r(R2_R)}}R-squared of the reduced model{p_end}
{synopt:{cmd: r(R2_F)}}R-squared of the full model{p_end}
{synopt:{cmd: r(R2_diff)}}difference between R-squared of the full and reduced
models{p_end}
{synopt:{cmd: r(ntested)}}number of tested covariates{p_end}
{synopt:{cmd: r(ncontrol)}}number of control covariates{p_end}
INCLUDE help pss_rrestab_sc
{synopt:{cmd: r(init)}}initial value for sample size or for R-squared{p_end}
INCLUDE help pss_rresiter_sc

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(type)}}{cmd:test}{p_end}
{synopt:{cmd:r(method)}}{cmd:rsquared}{p_end}
INCLUDE help pss_rrestab_mac

{synoptset 20 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
INCLUDE help pss_rrestab_mat
