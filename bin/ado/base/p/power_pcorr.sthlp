{smcl}
{* *! version 1.0.12  12mar2019}{...}
{viewerdialog power "dialog power_pcorr"}{...}
{vieweralsosee "[PSS-2] power pcorr" "mansection PSS-2 powerpcorr"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power" "help power"}{...}
{vieweralsosee "[PSS-2] power oneslope" "help power oneslope"}{...}
{vieweralsosee "[PSS-2] power rsquared" "help power rsquared"}{...}
{vieweralsosee "[PSS-2] power, graph" "help power_optgraph"}{...}
{vieweralsosee "[PSS-2] power, table" "help power_opttable"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] pcorr" "help pcorr"}{...}
{viewerjumpto "Syntax" "power_pcorr##syntax"}{...}
{viewerjumpto "Menu" "power_pcorr##menu"}{...}
{viewerjumpto "Description" "power_pcorr##description"}{...}
{viewerjumpto "Links to PDF documentation" "power_pcorr##linkspdf"}{...}
{viewerjumpto "Options" "power_pcorr##options"}{...}
{viewerjumpto "Remarks: Using power pcorr" "power_pcorr##remarks"}{...}
{viewerjumpto "Examples" "power_pcorr##examples"}{...}
{viewerjumpto "Stored results" "power_pcorr##stored_results"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[PSS-2] power pcorr} {hline 2}}Power analysis for a
partial-correlation test in a multiple linear regression{p_end}
{p2col:}({mansection PSS-2 powerpcorr:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Compute sample size 

{p 8 43 2}
{opt power} {opt pcorr} {it:rho2_p} 
[{cmd:,}
{opth p:ower(numlist)}
{it:{help power_pcorr##synoptions:options}}]


{phang}
Compute power 

{p 8 43 2}
{opt power} {opt pcorr} {it:rho2_p}{cmd:,}
{opth n(numlist)} [{it:{help power_pcorr##synoptions:options}}]


{phang}
Compute effect size and target squared partial correlation

{p 8 43 2}
{opt power} {opt pcorr}{cmd:,} {opth n(numlist)} 
{opth p:ower(numlist)} [{it:{help power_pcorr##synoptions:options}}]


{phang}
where {it:rho2_p} is the hypothesized squared partial correlation in a
multiple linear regression.  {it:rho2_p} may be specified either as one number
or as a list of values in parentheses (see {it:{help numlist}}).{p_end}


{synoptset 28 tabbed}{...}
{marker synoptions}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
INCLUDE help pss_testmainopts1
{synopt: {opt nfrac:tional}}allow fractional sample size{p_end}
{p2coldent:* {opth ntest:ed(numlist)}}number of tested covariates; default is
{cmd:ntested(1)}{p_end}
{p2coldent:* {opth nc:ontrol(numlist)}}number of control covariates; default
is {cmd:ncontrol(1)}{p_end}
{synopt: {opt par:allel}}treat number lists in starred options as parallel when multiple values per option are specified (do not enumerate all possible combinations of values)

{syntab:Table}
{synopt :[{cmdab:no:}]{cmdab:tab:le}[{cmd:(}{it:{help power_pcorr##tablespec:tablespec}}{cmd:)}]}suppress table or display
results as a table; see {manhelp power_opttable PSS-2:power, table}{p_end}
{synopt :{cmdab:sav:ing(}{it:{help filename}}[{cmd:, replace}]{cmd:)}}save the
table data to {it:filename}; use {cmd:replace} to overwrite existing
{it:filename}{p_end}

INCLUDE help pss_graphopts

{syntab:Iteration}
{synopt: {opt init(#)}}initial value for sample size or squared partial 
correlation{p_end}
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
{it:{help power_pcorr##column:column}}[{cmd::}{it:label}]
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
{synopt :{opt rho2_p}}squared partial multiple correlation{p_end}
{synopt :{opt ntested}}number of tested covariates{p_end}
{synopt :{opt ncontrol}}number of control covariates{p_end}
{synopt :{opt target}}target parameter; synonym for {cmd:rho2_p}{p_end}
{synopt :{opt _all}}display all supported columns{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}Column {cmd:beta} is shown in the default table in place of column
{cmd:power} if specified.{p_end}


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
{cmd:power} {cmd:pcorr} computes sample size, power, or target squared partial
correlation for a partial-correlation test in a multiple linear regression. A
partial-correlation test is an F test of the squared partial multiple
correlation that is used to test the significance of a subset of coefficients
in a regression model. By default, {cmd:power pcorr} computes sample size
given power and the squared partial correlation.  Alternatively, it computes
power given sample size and the squared partial correlation, or it computes
the squared partial correlation given sample size and power.  See
{manhelp power PSS-2} for a general introduction to the {cmd:power} command
using hypothesis tests.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-2 powerpcorrQuickstart:Quick start}

        {mansection PSS-2 powerpcorrRemarksandexamples:Remarks and examples}

        {mansection PSS-2 powerpcorrMethodsandformulas:Methods and formulas}

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
the number of the covariates in the reduced model.  The default is
{cmd:ncontrol(1)}.

{phang}
{cmd:parallel}; see {manhelp power##mainopts PSS-2:power}.

INCLUDE help pss_taboptsdes

INCLUDE help pss_graphoptsdes
Also see the {mansection PSS-2 powerpcorrSyntaxcolumn:column} table in
{bf:[PSS-2] power pcorr} for a list of symbols used by the graphs.

{dlgtab:Iteration}

{phang}
{opt init(#)} specifies the initial value of the sample size for the
sample-size determination or the initial value of the squared partial
correlation for the effect-size determination.  The default is to use a
bisection search method to compute an initial value.

INCLUDE help pss_iteroptsdes

{pstd}
The following option is available with {cmd:power pcorr} but is not shown
in the dialog box:

INCLUDE help pss_reportoptsdes


{marker remarks}{...}
{title:Remarks: Using power pcorr}

{pstd}
{cmd:power pcorr} computes sample size, power, or target squared partial
correlation {it:rho2_p} for a partial-correlation test in a multiple linear
regression.  By default, all computations are performed at the significance
level of 0.05.  You may change the significance level by specifying the
{cmd:alpha()} option.

{pstd}
By default, the numbers of tested covariates and of control covariates
are set to 1.  You may change the respective values with the {cmd:ntested()}
and {cmd:ncontrol()} options.

{pstd}
To compute sample size, you must specify the squared partial correlation
{it:rho2_p} and, optionally, the power of the test in the {cmd:power()}
option.  The default power is set to 0.8.

{pstd}
To compute power, you must specify the sample size in the {cmd:n()} option and
the squared partial correlation {it:rho2_p}.

{pstd}
To compute the target partial correlation and effect size, you must specify
the sample size in the {cmd:n()} option and the power in the {cmd:power()}
option.

{pstd}
By default, the computed sample size is rounded up.  You can specify the
{cmd:nfractional} option to see the corresponding fractional sample size; see
{mansection PSS-4 UnbalanceddesignsRemarksandexamplesFractionalsamplesizes:{it:Fractional sample sizes}} in 
{bf:[PSS-4] Unbalanced designs} for an example.  The
{cmd:nfractional} option is allowed only for sample-size determination.

{pstd}
{cmd:power pcorr}'s computations of sample size and effect size
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
Compute sample size required to detect a squared partial correlation of
0.1 given 2 control covariates; assume that there is only one tested
covariate in the model, significance level is 5%, and power is 80% (the
defaults){p_end}
{phang2}
{cmd:. power pcorr 0.1, ncontrol(2)}

{pstd}
Same as above, but assume that the number of tested covariates is 3{p_end}
{phang2}{cmd:. power pcorr 0.1, ncontrol(2) ntested(3)}


    {title:Examples: Computing power}

{pstd}
Compute the power of a test with a 5% significance level, a sample size of 80, 
and 2 control and 3 tested covariates{p_end}
{phang2}{cmd:. power pcorr 0.1, n(80) ncontrol(2) ntested(3)}{p_end}

{pstd}
Compute power for a list of squared partial correlation, graphing the results{p_end}
{phang2}{cmd:. power pcorr (0.1(0.05)0.3), n(80) ncontrol(2) ntested(3) graph}


    {title:Examples: Computing target squared partial correlation}

{pstd}
Compute the minimum value of the squared partial correlation that can be
detected with 80 observations, a power of 80%, and the default 5%
significance level; assume that there are 2 control covariates and 3 tested
covariates{p_end}
{phang2}{cmd:. power pcorr, n(80) power(0.8) ncontrol(2) ntested(3)}


{marker stored_results}{...}
{title:Stored results}

{pstd}
{cmd:power pcorr} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd: r(alpha)}}significance level{p_end}
{synopt:{cmd: r(power)}}power{p_end}
{synopt:{cmd: r(beta)}}probability of a type II error{p_end}
{synopt:{cmd: r(delta)}}effect size{p_end}
{synopt:{cmd: r(N)}}sample size{p_end}
{synopt:{cmd: r(nfractional)}}{cmd:1} if {cmd:nfractional} is specified, {cmd:0} otherwise{p_end}
{synopt:{cmd: r(rho2_p)}}squared partial correlation{p_end}
{synopt:{cmd: r(ntested)}}number of tested covariates{p_end}
{synopt:{cmd: r(ncontrol)}}number of control covariates{p_end}
INCLUDE help pss_rrestab_sc
{synopt:{cmd: r(init)}}initial value for sample size or for squared partial
correlation{p_end}
INCLUDE help pss_rresiter_sc

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(type)}}{cmd:test}{p_end}
{synopt:{cmd:r(method)}}{cmd:pcorr}{p_end}
INCLUDE help pss_rrestab_mac

{synoptset 20 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
INCLUDE help pss_rrestab_mat
