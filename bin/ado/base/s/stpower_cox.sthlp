{smcl}
{* *! version 1.2.2  20aug2018}{...}
{viewerdialog "stpower cox" "dialog stpower_cox"}{...}
{vieweralsosee "previously documented" "help prdocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stpower" "help stpower"}{...}
{vieweralsosee "[ST] stpower exponential" "help stpower_exponential"}{...}
{vieweralsosee "[ST] stpower logrank" "help stpower_logrank"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] Glossary" "help st_glossary"}{...}
{vieweralsosee "[ST] stcox" "help stcox"}{...}
{vieweralsosee "[ST] sts test" "help sts_test"}{...}
{vieweralsosee "[R] test" "help test"}{...}
{viewerjumpto "Syntax" "stpower_cox##syntax"}{...}
{viewerjumpto "Menu" "stpower_cox##menu"}{...}
{viewerjumpto "Description" "stpower_cox##description"}{...}
{viewerjumpto "Options" "stpower_cox##options"}{...}
{viewerjumpto "Short introduction to stpower cox" "stpower_cox##remarks1"}{...}
{viewerjumpto "Remarks on the method used in stpower cox" "stpower_cox##remarks2"}{...}
{viewerjumpto "Examples" "stpower_cox##examples"}{...}
{viewerjumpto "Stored results" "stpower_cox##results"}{...}
{viewerjumpto "References" "stpower_cox##references"}{...}
{pstd}
{cmd:stpower} continues to work but, as of Stata 14, is no longer an official
part of Stata.  This is the original help file, which we will no longer
update, so some links may no longer work.

{pstd}
See {manhelp power PSS-2} for a recommended alternative to {cmd:stpower}, and
in particular, see {manhelp power_cox PSS-2:power cox},
{manhelp power_logrank PSS-2:power logrank}, and
{manhelp power_exponential PSS-2:power exponential}.


{title:Title}

{p2colset 5 25 27 2}{...}
{p2col :{hi:[ST] stpower cox} {hline 2}}Sample size, power, and effect size for the Cox proportional hazards model{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Sample-size determination

{p 8 16 2}
{opt stpow:er} {opt cox} [{it:coef}] [{cmd:,} {it:options}]


{phang}
Power determination

{p 8 16 2}
{opt stpow:er} {opt cox } [{it:coef}]{cmd:,} 
{opth n(numlist)} [{it:options}] 


{phang}
Effect-size determination

{p 8 16 2}
{opt stpow:er} {opt cox}{cmd:,} 
{opth n(numlist)} {c -(}{opth p:ower(numlist)} | {opth b:eta(numlist)}{c )-}
       [{it:options}] 


{phang}
where {it:coef} is the regression coefficient (effect size) of a covariate of
interest, in a Cox proportional hazards model, desired to be detected by a
test with a prespecified power.  {it:coef} may be specified either as one 
number or as a list of values (see {it:{help numlist}}) enclosed in
parentheses.{p_end}


{synoptset 28 tabbed}{...}
{marker options_table}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{p2coldent:* {opth a:lpha(numlist)}}significance level; default is
{cmd:alpha(0.05)}{p_end}
{p2coldent:* {opth p:ower(numlist)}}power; default is 
{cmd:power(0.8)}{p_end}
{p2coldent:* {opth b:eta(numlist)}}probability of type II error;
default is {cmd:beta(0.2)}{p_end}
{p2coldent:* {opth n(numlist)}}sample size; required to compute power or
effect size{p_end}
{p2coldent:* {opth hrat:io(numlist)}}hazard ratio (effect size) associated
with a one-unit increase in covariate of interest; default is 
{cmd:hratio(0.5)}{p_end}
{synopt: {opt onesid:ed}}one-sided test; default is two sided{p_end}
{synopt: {opt sd(#)}}standard deviation of covariate of interest;
default is {cmd:sd(0.5)}{p_end}
{synopt: {opt r2(#)}}squared coefficient of multiple correlation with other
covariates; default is {cmd:r2(0)}{p_end}
{synopt: {opt failp:rob(#)}}overall probability of an event (failure) of
interest; default is {cmd:failprob(1)}, meaning no censoring{p_end}
{synopt: {opt wdp:rob(#)}}the proportion of subjects anticipated to withdraw 
from the study; default is {cmd:wdprob(0)}{p_end}
{synopt: {opt par:allel}}treat number lists in starred options as parallel (do
not enumerate all possible combinations of values) when multiple values per
option are specified{p_end}

{syntab: Reporting}
{synopt: {opt hr}}report hazard ratio, not coefficient{p_end}
{synopt: {opt tab:le}}display results in a table with default columns{p_end}
{synopt: {opth col:umns(stpower_cox##colnames:colnames)}}display results in a
table with specified {it: colnames} columns{p_end}
{synopt: {opt noti:tle}}suppress table title{p_end}
{synopt: {opt noleg:end}}suppress table legend{p_end}
{synopt: {opt colw:idth(# [# ...])}}column widths; default is 
{cmd:colwidth(9)}{p_end}
{synopt: {opt sep:arator(#)}}draw a horizontal separator line every {it:#}
lines; default is {cmd:separator(0)} meaning no separator lines{p_end}
{synopt: {cmdab:sav:ing(}{it:{help filename}}[{cmd:,} {cmd:replace}]{cmd:)}}save the 
table data to {it:filename}; use {opt replace} to overwrite existing 
{it:filename}{p_end}

{synopt: {opt nohead:er}}suppress table header; seldom used{p_end}
{synopt: {opt cont:inue}}draw a continuation border in the table output;
seldom used{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* Starred options may be specified either as one number or as a list of 
values (see {it:{help numlist}}).
{p_end}
{p 4 6 2}
{opt noheader} and {opt continue} are not shown in the dialog box.
{p_end}

{synoptset 28}{...}
{marker colnames}{...}
{synopthdr :colnames}
{synoptline}
{synopt: {opt a:lpha}}significance level{p_end}
{synopt: {opt p:ower}}power{p_end}
{synopt: {opt b:eta}}type II error probability{p_end}
{synopt: {opt n}}total number of subjects{p_end}
{synopt: {opt e}}total number of events (failures){p_end}
{synopt: {opt hr}}hazard ratio{p_end}
{synopt: {opt c:oef}}coefficient (log hazard-ratio){p_end}
{synopt: {opt sd}}standard deviation{p_end}
{synopt: {opt r2}}squared multiple-correlation coefficient{p_end}
{synopt: {opt pr}}overall probability of an event (failure){p_end}
{synopt: {opt w}}proportion of withdrawals{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
By default, the following {it:colnames} are displayed:{p_end}
{phang2}
{cmd:power}, {cmd:n}, {cmd:e}, {cmd:sd}, and {cmd:alpha} are always
displayed;{p_end}
{phang2}
{cmd:coef} is displayed, unless the {cmd:hr} option is specified, in which
case {cmd:hr} is displayed;{p_end}
{phang2}
{cmd:pr} if overall probability of an event ({cmd:failprob()}) is specified;{p_end}
{phang2}
{cmd:r2} if squared multiple-correlation coefficient ({cmd:r2()}) is
specified; and{p_end}
{phang2}
{cmd:w} if withdrawal proportion ({cmd:wdprob()}) is specified.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survival analysis > Power and sample size}


{marker description}{...}
{title:Description}

{pstd}
{cmd:stpower} {cmd:cox} estimates required sample size, power, and effect size
for survival analyses that use Cox proportional hazards (PH) models.  It also
reports the number of events (failures) required to be observed in a study.
The estimates of sample size or power are obtained for the test of the effect
of one covariate, {it:x1} (binary or continuous), on time to failure
adjusted for other predictors, {it:x2},...,{it:xp}, in a PH model.  The command
provides options to account for possible correlation between a covariate of
interest and other predictors and for withdrawal of subjects from the study.
Optionally, the minimal effect size (minimal detectable difference in a
regression coefficient, {it:beta_1}, or hazard ratio) may be obtained for
given sample size and power.

{pstd}
You can use {cmd:stpower} {cmd:cox} to

{phang2}
o  calculate required number of events and sample size when you know power and
effect size expressed as a hazard ratio or a coefficient (log hazard-ratio),

{phang2}
o  calculate power when you know sample size (number of events) and effect
size expressed as a hazard ratio or a coefficient (log hazard-ratio), and

{phang2}
o  calculate effect size and display it as a coefficient (log hazard-ratio) or
a hazard ratio when you know sample size (number of events) and power.

{pstd}
{cmd:stpower cox}'s input parameter, {it:coef}, is the value
{it:beta_1a} of the regression coefficient, {it:beta_1}, of a covariate of
interest, {it:x1}, from a Cox PH model, which is desired to be detected by a
test with prespecified power.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth alpha(numlist)} sets the significance level of the test.  The default is 
{cmd:alpha(0.05)}.

{phang} 
{opth power(numlist)} sets the power of the test.  The default is
{cmd:power(0.8)}.  If {cmd:beta()} is specified, this value is set to be
{bind:1-{cmd:beta()}}.  Only one of {cmd:power()} or {cmd:beta()} may be
specified.

{phang} 
{opth beta(numlist)} sets the probability of a type II error of the test.  The
default is {cmd:beta(0.2)}.  If {cmd:power()} is specified, this value is set
to be {bind:1-{cmd:power()}}.  Only one of {cmd:beta()} or {cmd:power()} may
be specified.

{phang}
{opth n(numlist)} specifies the number of subjects in the study to be used to
compute the power of the test or the minimal effect size (minimal detectable
value of the regression coefficient, {it:beta_1}, or hazard ratio) if
{cmd:power()} or {cmd:beta()} is also specified.

{phang}
{opth hratio(numlist)} specifies the hazard ratio associated with a one-unit
increase in the covariate of interest, {it:x1}, when other covariates are held
constant.  The default is {cmd:hratio(0.5)}.  This value defines the minimal
clinically significant effect of a covariate on the response to be detected by
a test with a certain power, specified in {cmd:power()}, in a Cox PH model.
If {it:coef} is specified, {cmd:hratio()} is not allowed and the hazard ratio
is instead computed as exp({it:coef}).

{phang}
{opt onesided} indicates a one-sided test.  The default is two sided.

{phang}
{opt sd(#)} specifies the standard deviation of the covariate of interest,
{it:x1}.  The default is {cmd:sd(0.5)}.

{phang}
{opt r2(#)} specifies the squared multiple-correlation coefficient between
{it:x1} and other predictors {it:x2}, ..., {it:xp} in a Cox PH model.  The
default is {cmd:r2(0)}, meaning that {it:x1} is independent of other
covariates.  This option defines the proportion of variance explained by the
regression of {it:x1} on {it:x2}, ..., {it:xp} (see {manhelp regress R}).

{phang}
{opt failprob(#)} specifies the overall probability of a subject failing (or
experiencing an event of interest, or not being censored) in the study.  The
default is {cmd:failprob(1)}, meaning that all subjects experience an event
(or fail) in the study; that is, no censoring of subjects occurs.

{phang}
{opt wdprob(#)} specifies the proportion of subjects anticipated to withdraw
from a study.  The default is {cmd:wdprob(0)}.  {cmd:wdprob()} may not be
combined with {cmd:n()}.

{phang}
{cmd:parallel} reports results sequentially (in parallel) over the list of
numbers supplied to options allowing {it:{help numlist}}.  By default, results
are computed over all combinations of the number lists in the following order
of nesting: {cmd:alpha()}, {cmd:hratio()} or list of coefficients {it:coef},
{cmd:power()} or {cmd:beta()}, and {cmd:n()}.  This option requires that
options with multiple values each contain the same number of elements.

{dlgtab:Reporting}

{phang}
{opt hr} specifies that the hazard ratio be displayed rather than the
regression coefficient.  This option affects how results are displayed and not
how they are estimated.

{phang}
{cmd:table} displays results in a tabular format and is implied if any number
list contains more than one element.  This option is useful if you are
producing results one case at a time and wish to construct your own custom
table by using a {cmd:forvalues} loop.

{phang}
{opth "columns(stpower_cox##colnames:colnames)"} specifies results in a table
with specified {it:colnames} columns.  The order of columns in the output
table is the same as the order of {it:colnames} specified in {cmd:columns()}.
Column names in {cmd:columns()} must be space-separated.

{phang}
{cmd:notitle} prevents the table title from displaying.

{phang}
{cmd:nolegend} prevents the table legend from displaying and column headers
from being marked.

{phang}
{opt colwidth(# [# ...])} specifies column widths.  The default is 9 for all
columns.  The number of specified values may not exceed the number of columns
in the table.  A missing value ({cmd:.}) may be specified for any column to
indicate the default width (9).  If fewer widths are specified than the number
of columns in the table, the last width specified is used for the remaining
columns.

{phang}
{opt separator(#)} specifies how often separator lines should be drawn between
rows of the table.  The default is {cmd:separator(0)}, meaning that no
separator lines should be displayed.

{phang}
{cmd:saving(}{it:{help filename}}[{cmd:,} {cmd:replace}]{cmd:)} creates a
Stata data file ({cmd:.dta} file) containing the table values with variable
names corresponding to the displayed {help stpower_cox##colnames:{it:colnames}}.
{cmd:replace} specifies that {it:filename} be overwritten if it exists.
{cmd:saving()} is appropriate only with tabular output.

{pstd}The following options are available with {cmd:stpower cox} but are not
shown in the dialog box:

{phang}
{cmd:noheader} prevents the table header from displaying.  This option is
useful when the command is issued repeatedly, such as within a loop.
{cmd:noheader} implies {cmd:notitle}.

{phang}
{cmd:continue} draws a continuation border at the bottom of the table.  This
option is useful when the command is issued repeatedly within a loop.


{marker remarks1}{...}
{title:Short introduction to stpower cox}

{pstd}
The argument {it:coef} or option {cmd:hratio()} may be used to specify the
effect size desired to be detected by a test.  If argument {it:coef} is
omitted, then the value of the log of the hazard ratio specified in the 
{cmd:hratio()} option or the log of the default hazard-ratio value of 0.5 is
used to compute {it:beta_1a}.  If argument {it:coef} is specified, then
{cmd:hratio()} is not allowed and the hazard ratio is computed as
exp({it:coef}).

{pstd}
If power determination is desired, then sample size {cmd:n()} must be specified.
Otherwise, sample-size determination is assumed with {cmd:power(0.8)} (or,
equivalently, {cmd:beta(0.2)}).  The default setting for power or,
alternatively, the probability of a {it:type} {it:II} {it:error}, a failure to
reject the null hypothesis when the alternative hypothesis is true, may be
changed by using {cmd:power()} or {cmd:beta()}, respectively.  If both
{cmd:n()} and {cmd:power()} (or {cmd:beta()}) are specified, the value of the
regression coefficient, {it:beta_1a} (or hazard ratio if the {cmd:hr} option is
specified), which can be detected by a test with requested {cmd:power()} for
fixed sample size {cmd:n()}, is computed.

{pstd}
The default probability of a {it:type} {it:I} {it:error}, a rejection of the
null hypothesis when the hypothesis is true, of a test is 0.05 but may be
changed by using the {cmd:alpha()} option.  One-sided tests may be requested by
using {cmd:onesided}.  By default, no censoring, no correlation between
{it:x1} and other predictors, and no withdrawal of subjects from the study are
assumed.  This may be changed by specifying {cmd:failprob()}, {cmd:r2()}, and
{cmd:wdprob()}, respectively.

{pstd}
Optionally, the results may be displayed in a table using {cmd:table} or
{cmd:columns()} as demonstrated in 
{help stpower_cox##examples:Examples} below and in
{helpb stpower:[ST] stpower}.  For examples on how to plot a power curve, see
{help stpower_cox##examples:Examples} below, {helpb stpower:[ST] stpower}, and
example 7 in {bf:[ST] stpower logrank}.


{marker remarks2}{...}
{title:Remarks on the method used in stpower cox}

{pstd}
{cmd:stpower cox} implements the method of 
{help stpower cox##HL2000:Hsieh and Lavori (2000)} for the
sample-size and power computation, which reduces to the method of
{help stpower cox##S1983:Schoenfeld (1983)} for a binary covariate.
The sample size is related to the
power of a test through the number of events observed in the study; that is, for
a fixed number of events the power of a test is independent of the sample
size.  As a result, the sample size is estimated as the number of events
divided by the overall probability of a subject failing in a study.  See 
{it:Methods and formulas} in {bf:[ST] stpower cox} for the formulas used in
the computation.


{marker examples}{...}
{title:Examples}

{pstd}
Compute number of failures required to detect a 0.5 reduction in the hazard
for a binary covariate of interest with standard deviation 0.5, using a
one-sided 5% Wald test with a power of 80%{p_end}
{phang2} 
{cmd:. stpower cox, onesided} 
{p_end}

{pstd}
Compute required sample size to detect a log hazard-ratio of -1 for a
covariate of interest with standard deviation 0.3, assuming only 15% of
subjects survive until the end of the study{p_end}
{phang2}
{cmd:. stpower cox -1, sd(0.3) failprob(0.85)}
{p_end}

{pstd}
Compute power of the test just described for a sample size of 150, assuming
the covariate of interest is correlated with other covariates with R2 = 0.3
{p_end}
{phang2}
{cmd:. stpower cox -1, n(150) sd(0.3) failprob(0.85) r2(0.3)}
{p_end}

{pstd}
Determine minimal detectable value of the coefficient (log hazard-ratio) for
the variable in the previous example with 90% power for a sample size of 150
{p_end}
{phang2}
{cmd:. stpower cox, n(150) power(0.9) sd(0.3) failprob(0.85) r2(0.3)}
{p_end}

{pstd}
Obtain sample sizes for a range of hazard ratios and powers
{p_end}
{phang2} 
{cmd:. stpower cox, hratio(0.1(0.2)0.9) power(0.8 0.9) hr} 
{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:stpower cox} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}total number of subjects{p_end}
{synopt:{cmd:r(E)}}total number of events (failures){p_end}
{synopt:{cmd:r(power)}}power of test{p_end}
{synopt:{cmd:r(alpha)}}significance level of test{p_end}
{synopt:{cmd:r(hratio)}}hazard ratio{p_end}
{synopt:{cmd:r(onesided)}}{cmd:1} if one-sided test, {cmd:0} otherwise{p_end}
{synopt:{cmd:r(sd)}}standard deviation{p_end}
{synopt:{cmd:r(Pr_E)}}probability of an event (failure) (if specified){p_end}
{synopt:{cmd:r(r2)}}squared multiple correlation (if specified){p_end}
{synopt:{cmd:r(w)}}proportion of withdrawals (if specified){p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(metric)}}displayed metric ({cmd:log-hazard} or {cmd:hazard})
{p_end}

{p2colreset}{...}


{marker references}{...}
{title:References}

{marker HL2000}{...}
{phang}
Hsieh, F. Y., and P. W. Lavori. 2000.
Sample-size calculations for the Cox proportional hazards regression model
with nonbinary covariates.
{it: Controlled Clinical Trials} 21: 552-560.{p_end}

{marker S1983}{...}
{phang}
Schoenfeld, D. A. 1983.  
Sample-size formula for the proportional-hazards regression model.  
{it:Biometrics} 39: 499-503.{p_end}
