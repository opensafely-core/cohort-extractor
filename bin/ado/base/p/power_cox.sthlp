{smcl}
{* *! version 1.0.11  27feb2019}{...}
{viewerdialog power "dialog power_cox"}{...}
{vieweralsosee "[PSS-2] power cox" "mansection PSS-2 powercox"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power" "help power"}{...}
{vieweralsosee "[PSS-2] power exponential" "help power exponential"}{...}
{vieweralsosee "[PSS-2] power logrank" "help power logrank"}{...}
{vieweralsosee "[PSS-2] power, graph" "help power_optgraph"}{...}
{vieweralsosee "[PSS-2] power, table" "help power_opttable"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stcox" "help stcox"}{...}
{vieweralsosee "[ST] sts test" "help sts test"}{...}
{vieweralsosee "[R] test" "help test"}{...}
{viewerjumpto "Syntax" "power_cox##syntax"}{...}
{viewerjumpto "Menu" "power_cox##menu"}{...}
{viewerjumpto "Description" "power_cox##description"}{...}
{viewerjumpto "Links to PDF documentation" "power_cox##linkspdf"}{...}
{viewerjumpto "Options" "power_cox##options"}{...}
{viewerjumpto "Remarks: Using power cox" "power_cox##remarks"}{...}
{viewerjumpto "Examples" "power_cox##examples"}{...}
{viewerjumpto "Stored results""power_cox##results"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[PSS-2] power cox} {hline 2}}Power analysis for the 
Cox proportional hazards model{p_end}
{p2col:}({mansection PSS-2 powercox:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Compute sample size

{p 8 20 2}
{opt power} {opt cox} [{it:b1}]
[{cmd:,} {opth p:ower(numlist)} 
{it:{help power_cox##synoptions:options}}] 


{phang}
Compute power 

{p 8 20 2}
{opt power} {opt cox} [{it:b1}]{cmd:,}  
{opth n(numlist)}
[{it:{help power_cox##synoptions:options}}]


{phang}
Compute effect size (target regression coefficient)

{p 8 20 2}
{opt power} {opt cox}{cmd:,}  
{opth n(numlist)} {opth p:ower(numlist)}
[{it:{help power_cox##synoptions:options}}]


{marker b1}{...}
{phang}
where {it:b1} is the hypothesized regression coefficient (effect size) of a
covariate of interest in a Cox proportional hazards model desired to be
detected by a test with a prespecified power.  {it:b1} may be specified either
as one number or as a list of values in parentheses (see {help numlist}).


{synoptset 30 tabbed}{...}
{marker synoptions}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{p2coldent:* {opth a:lpha(numlist)}}significance level; default is
   {cmd:alpha(0.05)}{p_end}
{p2coldent:* {opth p:ower(numlist)}}power; default is {cmd:power(0.8)}{p_end}
{p2coldent:* {opth b:eta(numlist)}}probability of type II error; default is
   {cmd:beta(0.2)}{p_end}
{p2coldent:* {opth n(numlist)}}sample size; required to compute power or
effect size{p_end}
{synopt:{opt nfrac:tional}}allow fractional sample sizes{p_end}
{p2coldent:* {opth hr:atio(numlist)}}hazard ratio (exponentiated {it:b1})
associated with a one-unit increase in covariate of interest; specify instead
of the regression coefficient {it:b1}; default is {cmd:hratio(0.5)}{p_end}
{p2coldent:* {opth sd(numlist)}}standard deviation of covariate of interest;
default is {cmd:sd(0.5)}{p_end}
{p2coldent:* {opth r2(numlist)}}squared coefficient of multiple correlation
with other covariates; default is {cmd:r2(0)}{p_end}
{p2coldent:* {opth eventpr:ob(numlist)}}overall probability of an event
(failure) of interest; default is {cmd:eventprob(1)}, meaning no
censoring{p_end}
{p2coldent:* {opth failpr:ob(numlist)}}synonym for {cmd:eventprob()}{p_end}
{p2coldent:* {opth wdp:rob(numlist)}}proportion of subjects anticipated to
withdraw from the study; default is {cmd:wdprob(0)}{p_end}
{synopt:{cmdab:effect(}{it:{help power_cox##effect:effect}}{cmd:)}}specify the
type of effect to display; default is {cmd:effect(coefficient)}{p_end}
INCLUDE help pss_testmainopts2.ihlp

{syntab:Table}
{synopt :[{cmdab:no:}]{cmdab:tab:le}[{cmd:(}{it:{help power_cox##tablespec:tablespec}}{cmd:)}]}suppress table or display results as a table; see
{manhelp power_opttable PSS-2:power, table}{p_end}
{synopt :{cmdab:sav:ing(}{it:{help filename}}[{cmd:, replace}]{cmd:)}}save the
table data to {it:filename}; use {cmd:replace} to overwrite existing
{it:filename}{p_end}

INCLUDE help pss_graphopts.ihlp

INCLUDE help pss_reportopts.ihlp
{synoptline}
{p2colreset}{...}
INCLUDE help pss_numlist.ihlp
{p 4 6 2}{cmd:notitle} does not appear in the dialog box.{p_end}


{synoptset 17}{...}
{marker effect}{...}
{synopthdr :effect}
{synoptline}
{synopt:{opt coef:ficient}}regression coefficient, {it:b1}; the default{p_end}
{synopt:{opt hr:atio}}hazard ratio, exp({it:b1}){p_end}
{synopt:{opt lnhr:atio}}log hazard-ratio; synonym for {cmd:coefficient}{p_end}
{synoptline}


{marker tablespec}{...}
{pstd}
where {it:tablespec} is

{p 16 16 2}
{it:{help power_cox##column:column}}[{cmd::}{it:label}]
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
{synopt :{opt E}}total number of events (failures){p_end}
{synopt :{opt b1}}regression coefficient{p_end}
{synopt :{opt hratio}}hazard ratio{p_end}
{synopt :{opt lnhratio}}log hazard-ratio{p_end}
{synopt :{opt sd}}standard deviation{p_end}
{synopt :{opt R2}}squared multiple-correlation coefficient{p_end}
{synopt :{opt Pr_E}}overall probability of an event (failure){p_end}
{synopt :{opt Pr_w}}probability of withdrawals{p_end}
{synopt :{opt target}}target parameter; synonym for {cmd:b1}{p_end}
{synopt :{opt _all}}display all supported columns{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}Column {cmd:beta} is shown in the default table in place of column
{cmd:power} if option {cmd:beta()} is specified.{p_end}
{p 4 6 2}Column {cmd:b1} is shown in the default table in place of column
{cmd:hratio} when a regression coefficient is specified.{p_end}
{p 4 6 2}Columns {cmd:R2} and {cmd:Pr_w} are shown in the default table
only if specified.{p_end}


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
{cmd:power cox} computes sample size, power, or effect size for survival
analyses that use Cox proportional hazards (PH) models.  The results are
obtained for the test of the effect of one covariate (binary or continuous) on
time to failure adjusted for other predictors in a PH model.  Effect size
can be expressed as a regression coefficient (or log hazard-ratio) or as a
hazard ratio.  The command can account for the dependence between the
covariate of interest and other model covariates, and it can adjust
computations for censoring and for withdrawal of subjects for the study.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-2 powercoxQuickstart:Quick start}

        {mansection PSS-2 powercoxRemarksandexamples:Remarks and examples}

        {mansection PSS-2 powercoxMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:alpha()}, {cmd:power()}, {cmd:beta()}, {cmd:n()}, {cmd:nfractional}; 
see {manhelp power##mainopts PSS-2: power}.  The {cmd:nfractional} option is
allowed only for sample-size determination.

{phang}
{opth hratio(numlist)} specifies the hazard ratio (or exponentiated regression
coefficient) associated with a one-unit increase in the covariate of interest
when other covariates are held constant.  This value defines an effect size or
the minimal clinically significant effect of a covariate on the response to be
detected by a test with a certain power in a Cox PH model.

{pmore}
You can specify an effect size either as the regression coefficient {it:b1},
which is the command argument, or as the hazard ratio in {cmd:hratio()}.  The
default is {cmd:hratio(0.5)}.  If you specify {opt hratio(#)}, the
regression coefficient is computed as {it:b1} = ln({it:#}).  If you
specify a regression coefficient {it:b1}, the hazard ratio is computed as
exp({it:b1}).

{pmore}
This option is not allowed with the effect-size determination.

{phang}
{opth sd(numlist)} specifies the standard deviation of the covariate of
interest.  The default is {cmd:sd(0.5)}.

{phang}
{opth r2(numlist)} specifies the squared multiple-correlation coefficient
between the covariate of interest and other predictors in a Cox PH model.
The default is {cmd:r2(0)}, meaning that the covariate of interest is
independent of other covariates.  This option defines the proportion of
variance explained by the regression of the covariate of interest on other
covariates used in the Cox model (see {manhelp regress R}).

{phang}
{opth eventprob(numlist)} specifies the overall probability of a subject
experiencing an event of interest (or failing, or not being censored) in the
study.  The default is {cmd:eventprob(1)}, meaning that all subjects
experience an event (or fail) in the study; that is, no censoring of subjects
occurs.

{phang}
{opth failprob(numlist)} is a synonym for {opt eventprob()}.

{phang}
{opth wdprob(numlist)} specifies the proportion of subjects anticipated to
withdraw from a study.  The default is {cmd:wdprob(0)}.  {cmd:wdprob()} is
allowed only with sample-size computation.

{phang}
{opt effect(effect)} specifies the type of the effect size to be
reported in the output as {cmd:delta}.  {it:effect} is one of
{cmd:coefficient}, {cmd:hratio}, or {cmd:lnhratio}.  By default, the effect
size {cmd:delta} is the regression coefficient, {cmd:effect(coefficient)}.  

{phang}
{cmd:direction()}, {cmd:onesided}, {cmd:parallel}; see 
{manhelp power##mainopts PSS-2: power}.
{cmd:direction(lower)} is the default.

INCLUDE help pss_taboptsdes.ihlp

INCLUDE help pss_graphoptsdes.ihlp
Also see the {it:{mansection PSS-2 powercoxSyntaxcolumn:column}} table in
{bf:[PSS-2] power cox} for a list of symbols used by the graphs.

{pstd}
The following option is available with {cmd:power cox} but is not
shown in the dialog box:

INCLUDE help pss_reportoptsdes.ihlp


{marker remarks}{...}
{title:Remarks: Using power cox}

{pstd}
{cmd:power cox} computes sample size, power, or effect size for a test of one
regression coefficient in a Cox PH model, holding coefficients of the other
covariates constant.  All computations are performed for a two-sided
hypothesis test where, by default, the significance level is set to 0.05. You
may change the significance level by specifying the {cmd:alpha()} option. You
can specify the {cmd:onesided} option to request a one-sided test.

{pstd}
To compute sample size, you specify an effect size and, optionally, power of
the test in the {cmd:power()} option. The default power is set to 0.8.
By default, the computed sample size is rounded up.  You can specify the
{cmd:nfractional} option to see the corresponding fractional sample size; see
{mansection PSS-4 UnbalanceddesignsRemarksandexamplesFractionalsamplesizes:{it:Fractional sample sizes}}
in {bf:[PSS-4] Unbalanced designs} for an example.  The {cmd:nfractional}
option is allowed only for sample-size determination.  

{pstd}
To compute power, you must specify the sample size in the {cmd:n()} option and
an effect size.

{pstd}
An effect size may be specified either as a regression coefficient supplied as
the command argument {it:b1} or as a hazard ratio supplied in the
{cmd:hratio()} option.  If neither is specified, a hazard ratio of 0.5 is
assumed.

{pstd}
To compute effect size, which may be expressed either as a regression
coefficient (log hazard-ratio) or hazard ratio, you must specify the sample
size in the {cmd:n()} option; the power in the {cmd:power()} option; and,
optionally, the direction of the effect. The direction is lower by default,
{cmd:direction(lower)}, which means, for example, that the target regression
coefficient is assumed to be negative.  This is equivalent to the hazard ratio
being less than one.  You can change the direction to upper, which means
that the target regression coefficient is assumed to be positive, by
specifying the {cmd:direction(upper)} option. This is equivalent to the hazard
ratio being greater than one.

{pstd}
As we mentioned above, the effect size for {cmd:power cox} may be expressed
as a regression coefficient or, equivalently, a log hazard-ratio, or as a
hazard ratio.  By default, the effect size, which is labeled as {cmd:delta} in
the output, corresponds to the regression coefficient.  You can change this by
specifying the {cmd:effect()} option: {cmd:effect(coefficient)} (the default)
reports the regression coefficient, {cmd:effect(hratio)} reports the hazard
ratio, and {cmd:effect(lnhratio)} reports the log hazard-ratio.  

{pstd}
The standard deviation of the covariate of interest is set to 0.5 by default
and may be changed by specifying the {cmd:sd()} option.  In the presence of
additional covariates in a Cox model, you can use the {cmd:r2()} option to
specify the correlation between the covariate of interest and other covariates
in the model.

{pstd}
All computations assume no censoring.  In the presence of censoring, you can
use the {cmd:eventprob()} option to specify an overall probability of an event
or failure.  When computing sample size, you can also adjust for withdrawal of
subjects from the study by specifying the anticipated proportion of
withdrawals in the {cmd:wdprob()} option.


{marker examples}{...}
{title:Examples}

    {title:Examples: Computing sample size}

{pstd}
Compute number of failures required to detect a 0.5 reduction in the hazard
for a binary covariate of interest.  By default, the hazard ratio is 0.5, 
corresponding to the regression coefficient of ln(0.5) = -0.6931;
the standard deviation of the covariate is 0.5; the significance level is 5%; 
and power is 80%.  A two-sided test will be used.

{phang2}{cmd:. power cox}

{pstd}
Same as above, but we use the regression coefficient instead of hazard ratio.

{phang2}{cmd:. power cox -0.6931}

{pstd}
We compute the required sample size to detect a regression coefficient -1 for
a covariate of interest with standard deviation 0.3, using a one-sided test.

{phang2}{cmd:. power cox -1, sd(0.3) onesided }

{pstd}
Same as above, but we assume the overall probability of an event is 0.85 in
the presence of censoring.

{phang2}{cmd:. power cox -1, sd(0.3) eventprob(0.85) onesided }

{pstd}
Same as above, but we assume the covariate of interest is correlated with
other covariates with R2 = 0.3.

{phang2}{cmd:. power cox -1, sd(0.3) eventprob(0.85) r2(0.3) onesided }

    {title:Examples: Computing power}

{pstd}
Continuing with the same example, we believe we can recruit only 150 subjects.
We investigate what power the test will have in this case.

{phang2}{cmd:. power cox -1, n(150) sd(0.3) eventprob(0.85) r2(0.3) onesided }

    {title:Examples: Minimum detectable coefficient}

{pstd}
Continuing with the same example, determine minimal detectable value of the 
coefficient for the variable in the previous example with 90% power for a 
sample size of 150; by default, the target regression coefficient is assumed to 
be negative

{phang2}{cmd:. power cox, n(150) power(0.9) sd(0.3) eventprob(0.85) r2(0.3) onesided }


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:power cox} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(alpha)}}significance level{p_end}
{synopt:{cmd:r(power)}}power{p_end}
{synopt:{cmd:r(beta)}}probability of a type II error{p_end}
{synopt:{cmd:r(delta)}}effect size{p_end}
{synopt:{cmd:r(N)}}sample size{p_end}
{synopt:{cmd:r(nfractional)}}{cmd:1} if {cmd:nfractional} is specified, {cmd:0} otherwise{p_end}
{synopt:{cmd:r(onesided)}}{cmd:1} for a one-sided test, {cmd:0} otherwise{p_end}
{synopt:{cmd:r(E)}}total number of events (failures){p_end}
{synopt:{cmd:r(hratio)}}hazard ratio under the alternative hypothesis{p_end}
{synopt:{cmd:r(b1)}}regression coefficient under the alternative hypothesis{p_end}
{synopt:{cmd:r(sd)}}standard deviation{p_end}
{synopt:{cmd:r(R2)}}squared multiple correlation (if specified){p_end}
{synopt:{cmd:r(Pr_E)}}probability of an event (failure) (if specified){p_end}
{synopt:{cmd:r(Pr_w)}}proportion of withdrawals (if specified){p_end}
INCLUDE help pss_rrestab_sc.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(type)}}{cmd:test}{p_end}
{synopt:{cmd:r(method)}}{cmd:cox}{p_end}
{synopt:{cmd:r(effect)}}{cmd:coefficient}, {cmd:hratio}, or
    {cmd:lnhratio}{p_end}
{synopt:{cmd:r(direction)}}{cmd:lower} or {cmd:upper}{p_end}
INCLUDE help pss_rrestab_mac.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
INCLUDE help pss_rrestab_mat.ihlp
{p2colreset}{...}
