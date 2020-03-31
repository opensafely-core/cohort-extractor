{smcl}
{* *! version 1.2.2  20aug2018}{...}
{viewerdialog "stpower logrank" "dialog stpower_logrank"}{...}
{vieweralsosee "previously documented" "help prdocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stpower" "help stpower"}{...}
{vieweralsosee "[ST] stpower cox" "help stpower_cox"}{...}
{vieweralsosee "[ST] stpower exponential" "help stpower_exponential"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] Glossary" "help st_glossary"}{...}
{vieweralsosee "[ST] stcox" "help stcox"}{...}
{vieweralsosee "[ST] sts test" "help sts_test"}{...}
{vieweralsosee "[R] test" "help test"}{...}
{viewerjumpto "Syntax" "stpower_logrank##syntax"}{...}
{viewerjumpto "Menu" "stpower_logrank##menu"}{...}
{viewerjumpto "Description" "stpower_logrank##description"}{...}
{viewerjumpto "Options" "stpower_logrank##options"}{...}
{viewerjumpto "Short introduction to stpower logrank" "stpower_logrank##remarks1"}{...}
{viewerjumpto "Remarks on methods used in stpower logrank" "stpower_logrank##remarks2"}{...}
{viewerjumpto "Examples" "stpower_logrank##examples"}{...}
{viewerjumpto "Stored results" "stpower_logrank##results"}{...}
{viewerjumpto "References" "stpower_logrank##references"}{...}
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

{p2colset 5 29 31 2}{...}
{p2col :{hi:[ST] stpower logrank} {hline 2}}Sample size, power, and effect size for the log-rank test{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Sample-size determination

{p 8 43 2}
{opt stpow:er} {opt log:rank} [{it:surv1} [{it:surv2}]] [{cmd:,} {it:options}]


{phang}
Power determination

{p 8 16 2}
{opt stpow:er} {opt log:rank} [{it:surv1} [{it:surv2}]]{cmd:,} 
{opth n(numlist)} [{it:options}] 


{phang}
Effect-size determination

{p 8 34 2}
{opt stpow:er} {opt log:rank} [{it:surv1}]{cmd:,} 
{opth n(numlist)} {c -(}{opth p:ower(numlist)} | {opth b:eta(numlist)}{c )-}
     [{it:options}] 


{phang}
where

{phang2}
{it:surv1} is the survival probability in the control group at the end of the
study t*;{p_end}
{phang2}
{it:surv2} is the survival probability in the experimental group at the end of
the study t*.{p_end}
{phang2}
{it:surv1} and {it:surv2} may each be specified either as one number or
as a list of values (see {it:{help numlist}}) enclosed in parentheses.{p_end}


{synoptset 28 tabbed}{...}
{marker options_table}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{p2coldent:* {opth a:lpha(numlist)}}significance level; default is
{cmd:alpha(0.05)}{p_end}
{p2coldent:* {opth p:ower(numlist)}}power; default is {cmd:power(0.8)}
{p_end}
{p2coldent:* {opth b:eta(numlist)}}probability of type II error; 
default is {cmd:beta(0.2)}{p_end}
{p2coldent:* {opth n(numlist)}}sample size; required to compute power or effect size{p_end}
{p2coldent:* {opth hrat:io(numlist)}}hazard ratio (effect size) of the
experimental to the control group; default is {cmd:hratio(0.5)}{p_end}
{synopt:{opt onesid:ed}}one-sided test; default is two sided{p_end}
{p2coldent:* {opth p1(numlist)}}proportion of subjects in the 
control group; default is {cmd:p1(0.5)}, meaning equal group sizes{p_end}
{p2coldent:* {opth nrat:io(numlist)}}ratio of sample sizes, N2/N1; 
default is {cmd:nratio(1)}, meaning equal group sizes{p_end}
{synopt: {opt sch:oenfeld}}use the formula based on the log hazard-ratio in
 calculations; default is to use the formula based on the
hazard ratio{p_end}
{synopt: {opt par:allel}}treat number lists in starred options as parallel (do
not enumerate all possible combinations of values) when multiple values per
option are specified{p_end}

{syntab :Censoring}
{synopt: {opt simp:son(# # # | matname)}}survival probabilities in the
control group at three specific time points to compute the probability of an
event (failure), using Simpson's rule under uniform accrual{p_end}
{synopt: {cmd:st1(}{var:_s} {var:_t}){cmd:}} variables
{it:varname_s}, containing survival probabilities in the control group, and
{it:varname_t}, containing respective time points, to compute the probability
of an event (failure), using numerical integration under uniform accrual{p_end}
{synopt: {opt wdp:rob(#)}}proportion of subjects anticipated to withdraw
from the study; default is {cmd:wdprob(0)}{p_end}

{syntab :Reporting}
{synopt: {opt tab:le}}display results in a table with default columns{p_end}
{synopt: {opth col:umns(stpower_logrank##colnames:colnames)}}display results
in a table with specified {it:colnames} columns{p_end}
{synopt: {opt noti:tle}}suppress table title{p_end}
{synopt: {opt noleg:end}}suppress table legend{p_end}
{synopt: {opt colw:idth(# [# ...])}}column widths; default is 
{cmd:colwidth(9)}{p_end}
{synopt: {opt sep:arator(#)}}draw a horizontal separator line every {it:#}
lines; default is {cmd:separator(0)}, meaning no separator lines{p_end}
{synopt: {cmdab:sav:ing(}{it:{help filename}}[{cmd:,} {cmd:replace}]{cmd:)}}save
   the table data to {it:filename}; use {cmd:replace} to overwrite existing 
   {it:filename}{p_end}

{synopt:{opt nohead:er}}suppress table header; seldom used{p_end}
{synopt:{opt cont:inue}}draw a continuation border in the table output;
    seldom used{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* Starred options may be specified either as one number or as a list of values
(see {it:{help numlist}}).{p_end}
{p 4 6 2}
{cmd:noheader} and {cmd:continue} are not shown in the dialog box.
{p_end}

{synoptset 28}{...}
{marker colnames}{...}
{synopthdr :colnames}
{synoptline}
{synopt :{opt a:lpha}}significance level{p_end}
{synopt :{opt p:ower}}power{p_end}
{synopt :{opt b:eta}}type II error probability{p_end}
{synopt :{opt n}}total number of subjects{p_end}
{synopt :{opt n1}}number of subjects in the control group{p_end}
{synopt :{opt n2}}number of subjects in the experimental group{p_end}
{synopt :{opt e}}total number of events (failures){p_end}
{synopt :{opt hr}}hazard ratio{p_end}
{synopt :{opt loghr}}log of the hazard ratio{p_end}
{synopt :{opt s1}}survival probability in the control group{p_end}
{synopt :{opt s2}}survival probability in the experimental group{p_end}
{synopt :{opt p1}}proportion of subjects in the control group{p_end}
{synopt :{opt nrat:io}}ratio of sample sizes, experimental to control{p_end}
{synopt :{opt w}}proportion of withdrawals{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
By default, the following {it:colnames} are displayed:{p_end}
{phang2}
{cmd:power}, {cmd:n}, {cmd:n1}, {cmd:n2}, {cmd:e}, and {cmd:alpha} are always
displayed;{p_end}
{phang2}
{cmd:hr} is displayed, unless the {cmd:schoenfeld} option is specified, in
which case {cmd:loghr} is displayed;{p_end}
{phang2}
{cmd:s1} and {cmd:s2} is displayed if survival probabilities are specified; and
{p_end}
{phang2}
{cmd:w} is displayed if withdrawal proportion ({cmd:wdprob()} option) is
specified.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survival analysis > Power and sample size}


{marker description}{...}
{title:Description}

{pstd}
{cmd:stpower} {cmd:logrank} estimates required sample size, power, and effect
size for survival analysis comparing survivor functions in two groups by using
the log-rank test.  It also reports the number of events (failures) required
to be observed in a study.  This command supports two methods to obtain the
estimates, those according to 
{help stpower logrank##F1982:Freedman (1982)} and
{help stpower logrank##S1981:Schoenfeld (1981)}.  The
command provides options to take into account unequal allocation of subjects
between the two groups and possible withdrawal of subjects from the study
(loss to follow-up).  Optionally, the estimates can be adjusted for uniform
accrual of subjects into the study.  Also the minimal effect size
(minimal detectable value of the hazard ratio or the log hazard-ratio) may be
obtained for given power and sample size.

{pstd}
You can use {cmd:stpower} {cmd:logrank} to

{phang2}
o  calculate required number of events and sample size when you know power and
effect size (expressed as a hazard ratio) for uncensored and censored survival
data,

{phang2}
o  calculate power when you know sample size (number of events) and effect
size (expressed as a hazard ratio) for uncensored and censored survival data,
and

{phang2}
o  calculate effect size (hazard ratio or log hazard-ratio if the 
{cmd:schoenfeld} option is specified) when you know sample size (number of
events) and power for uncensored and censored survival data.

{pstd}
{cmd:stpower} {cmd:logrank}'s input parameters, {it:surv1}
and {it:surv2}, are the values of survival probabilities in the control group
(or the less favorable of the two groups), s1, and in the experimental group,
s2, at the end of the study t*.


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
value of the hazard ratio or log hazard-ratio) if {cmd:power()} or
{cmd:beta()} is also specified.

{phang}
{opth hratio(numlist)} specifies the hazard ratio (effect size) of the
experimental group to the control group.  The default is {cmd:hratio(0.5)}.
This value defines the clinically significant improvement of the experimental
procedure over the control desired to be detected by the log-rank test, with a
certain power specified in {cmd:power()}.  If both arguments {it:surv1} and
{it:surv2} are specified, {cmd:hratio()} is not allowed and the hazard ratio
is instead computed as ln({it:surv2})/ln({it:surv1}).

{phang}
{opt onesided} indicates a one-sided test.  The default is two sided.

{phang}
{opth p1(numlist)} specifies the proportion of subjects in the control group.
The default is {cmd:p1(0.5)}, meaning equal allocation of subjects to the
control and the experimental groups.  Only one of {cmd:p1()} or {cmd:nratio()}
may be specified.

{phang}
{opth nratio(numlist)} specifies the sample-size ratio of the experimental
group relative to the control group, N2/N1.  The default is {cmd:nratio(1)},
meaning equal allocation between the two groups.  Only one of {cmd:nratio()}
or {cmd:p1()} may be specified.

{phang}
{opt schoenfeld} requests calculations using the formula based on the
log hazard-ratio, according to
{help stpower logrank##S1981:Schoenfeld (1981)}.  The default is to use the
formula based on the hazard ratio, according to
{help stpower logrank##F1982:Freedman (1982)}.

{phang}
{cmd:parallel} reports results sequentially (in parallel) over the list of
numbers supplied to options allowing {it:{help numlist}}.  By default, the
results are computed over all combinations of the number lists in the following
order of nesting: {cmd:alpha()}; {cmd:p1()} or {cmd:nratio()}; list of
arguments {it:surv1} and {it:surv2}; {cmd:hratio()}; {cmd:power()} or
{cmd:beta()}; and {cmd:n()}.  This option requires that options with multiple
values each contain the same number of elements.

{dlgtab:Censoring}

{phang}
{opt simpson(# # # | matname)} specifies survival probabilities in the control
group at three specific time points, to compute the probability of an event
(failure) using Simpson's rule, under the assumption of uniform accrual.
Either the actual values or the 1x3 matrix, {it:matname}, containing these
values can be specified.  By default, the probability of an event is
approximated as an average of the failure probabilities 1-s1 and 1-s2;
see {it:Methods and formulas} in {bf:[ST] stpower logrank}.
{cmd:simpson()} may not be combined with {cmd:st1()} and may not be used if
{it:surv1} or {it:surv2} are specified.

{phang}
{cmd:st1(}{it:{help varname:varname_s}} {it:varname_t}{cmd:)} specifies
variables {it:varname_s}, containing survival probabilities in the control
group, and {it:varname_t}, containing respective time points, to compute the
probability of an event (failure) using numerical integration, under the
assumption of uniform accrual; see {manhelp dydx R}.  The minimum and the
maximum values of {it:varname_t} must be the length of the follow-up period and
the duration of the study, respectively.  By default, the probability of an
event is approximated as an average of the failure probabilities 1-s1 and 1-s2;
see {it:Methods and formulas} in {bf:[ST] stpower logrank}.
{cmd:st1()} may not be combined with {cmd:simpson()} and may not be used if
{it:surv1} or {it:surv2} are specified.

{phang}
{opt wdprob(#)} specifies the proportion of subjects anticipated to withdraw
from the study.  The default is {cmd:wdprob(0)}.  {cmd:wdprob()} may not be
combined with {cmd:n()}.

{dlgtab:Reporting}

{phang}
{cmd:table} displays results in a tabular format and is implied if any number
list contains more than one element.  This option is useful if you are
producing results one case at a time and wish to construct your own custom
table using a {cmd:forvalues} loop.

{phang}
{opth "columns(stpower_logrank##colnames:colnames)"} specifies results in a
table with specified {it:colnames} columns.  The order of the columns in the
output table is the same as the order of {it:colnames} specified in
{cmd:columns()}.  Column names in {cmd:columns()} must be space-separated.

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
{cmd:saving(}{it:{help filename}}[{cmd:,} {cmd:replace}]{cmd:)} creates a Stata
data file ({cmd:.dta} file) containing the table values with variable names
corresponding to the displayed {it:{help stpower_logrank##colnames:colnames}}.
{cmd:replace} specifies that {it:filename} be overwritten if it exists.
{cmd:saving()} is only appropriate with tabular output.

{pstd}
The following options are available with {cmd:stpower logrank} but are not
shown in the dialog box:

{phang}
{cmd:noheader} prevents the table header from displaying.  This option is
useful when the command is issued repeatedly, such as within a loop.
{cmd:noheader} implies {cmd:notitle}.

{phang}
{cmd:continue} draws a continuation border at the bottom of the table.  This
option is useful when the command is issued repeatedly within a loop.


{marker remarks1}{...}
{title:Short introduction to stpower logrank}

{pstd}
Consider the following two types of a survival study.  A {it:type} {it:I}
{it:study} is the study in which all subjects fail by the end of the study
(uncensored data).  A {it:type} {it:II} {it:study} is the study which
terminates after a fixed period of time and not all subjects experience an
event (failure) by the end of that period (censored data).

{pstd}
By default, to obtain the estimate of the required sample size for uncensored
data (type I study), {cmd:stpower} {cmd:logrank} uses {cmd:power(0.8)} (or,
equivalently, {cmd:beta(0.2)}) and {cmd:alpha(0.05)} for the power (or the
probability of a type II error) and the probability of a type I error
(significance level) of the test.  The default effect size, a difference
between the two treatments, corresponds to the value of 0.5 of the hazard
ratio of the experimental group to the control group.  It may be changed by
using option {cmd:hratio()}.

{pstd}
Under the administrative censoring (type II study), in addition to the above,
the estimates of survival probabilities in two groups are necessary for the
computations.  The survival probability in the control group, s1, must be
specified as argument {it:surv1}.  The survival probability in the
experimental group, s2, may be directly supplied as argument {it:surv2} or
computed using {it:surv1} and the hazard ratio specified in {cmd:hratio()}.
If both arguments {it:surv1} and {it:surv2} are specified, the hazard ratio is
computed using these values of survival probabilities and option
{cmd:hratio()} is not allowed.  In the presence of an accrual period, options
{cmd:simpson()} or {cmd:st1()} may be used to adjust estimates for uniform
accrual.  Refer to section
{it:Including information about subject accrual} in {bf:[ST] stpower logrank}
for details.

{pstd}
Two-sided tests, equal allocation of subjects between the two groups, and no
withdrawal of subjects from the study are assumed.  Use options
{cmd:onesided}, {cmd:p1()} or {cmd:nratio()}, and {cmd:wdprob()} to request
one-sided tests, unequal allocation, and to specify a proportion of
withdrawals.

{pstd}
If power determination is desired, option {cmd:n()} must be specified.  If
both {cmd:n()} and {cmd:power()} (or {cmd:beta()}) are specified, the minimal
effect size (minimal value of the hazard ratio or log hazard ratio) which can
be detected by the log-rank test with requested power and fixed sample size is
computed.

{pstd}
Optionally, the results may be displayed in a table using {cmd:table} or
{cmd:columns()} as demonstrated in
{it:{help stpower_logrank##examples:Examples}} below and in
{helpb stpower:[ST] stpower}.  For examples on how to plot a power curve, see
{it:{help stpower_logrank##examples:Examples}} below, 
{helpb stpower:[ST] stpower}, and 
example 7 in {bf:[ST] stpower logrank}.


{marker remarks2}{...}
{title:Remarks on methods used in stpower logrank}

{pstd}
{cmd:stpower} {cmd:logrank} supports two methods, those of 
{help stpower logrank##F1982:Freedman (1982)} and
{help stpower logrank##S1981:Schoenfeld (1981)},
to obtain the estimates of the number of events or power
(see also {help stpower logrank##MV1997:Marubini and Valsecchi [1997, 127, 134]}
and {help stpower logrank##C2003:Collett [2003, 301, 306]}).
The latter is used if option {cmd:schoenfeld} is specified.  The final
estimates of the sample size are based on the approximation of the probability
of an event due to {help stpower logrank##F1982:Freedman (1982)},
the default, or, for uniform accrual, due to
{help stpower logrank##S1983:Schoenfeld (1983)} (also see
{help stpower logrank##C2003:Collett 2003}) if option {cmd:simpson()} is
specified.  Thus the power is independent of the sample size for a fixed
number of events ({help stpower logrank##F1982:Freedman 1982}).  See
{it:Methods and formulas} in {bf:[ST] stpower logrank} for the formulas
underlying these methods.

{pstd}
In the presence of censoring, the probability of an event needs to be
estimated to obtain the estimate of the sample size.  By default, it is
approximated as suggested by 
{help stpower logrank##F1982:Freedman (1982)} using the estimates of the
survival probabilities in two groups at the end of the study.  See 
{it:{help stpower_logrank##examples:Examples}} below and
{it:Computing sample size in the presence of censoring}
in {bf:[ST] stpower logrank}.

{pstd}
In the presence of uniform accrual over a period [0,R], the information about
subject follow up, f, may be taken into account by specifying {cmd:simpson()}
or {cmd:st1()} if the estimates of the survivor function over the period
{bind:[f,T]}, where the duration of a study is T = R + f, are available
({help stpower logrank##S1983:Schoenfeld 1983},
 {help stpower logrank##C2003:Collett 2003}).
Only three estimates of the survivor
function at times f, f+R/2, and T are required in {cmd:simpson()}.  If more
points are available, {cmd:st1()} may be used instead.  See 
{it:Including information about subject accrual}
in {bf:[ST] stpower logrank} for details.


{marker examples}{...}
{title:Examples}

{pstd}
Compute number of failures required to detect a hazard ratio of 0.5 using a 5%
two-sided log-rank test with 80% power{p_end}
{phang2}
{cmd:. stpower logrank}
{p_end}

{pstd}
Same as above, but use Schoenfeld method{p_end}
{phang2}
{cmd:. stpower logrank, schoenfeld}
{p_end}

{pstd}
Compute sample size required in the presence of censoring to detect a change
in survival from 50% to 60% at the end of the study using a 5% one-sided
log-rank test with a power of 80%{p_end}
{phang2}
{cmd:. stpower logrank 0.5 0.6, onesided}
{p_end}

{pstd}
Same as above command, but assuming a 10% probability of withdrawal{p_end}
{phang2}
{cmd:. stpower logrank 0.5 0.6, onesided wdprob(0.1)}
{p_end}

{pstd}
Obtain power for a range of hazard ratios and two sample sizes{p_end}
{phang2} 
{cmd:. stpower logrank, hratio(0.1(0.2)0.9) n(50 100)} 
{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:stpower logrank} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(E)}}total number of events (failures){p_end}
{synopt:{cmd:r(power)}}power of test{p_end}
{synopt:{cmd:r(alpha)}}significance level of test{p_end}
{synopt:{cmd:r(hratio)}}hazard ratio{p_end}
{synopt:{cmd:r(onesided)}}type of test ({cmd:0} if two-sided test, {cmd:1} if one-sided test){p_end}
{synopt:{cmd:r(s1)}}survival probability in the control group (if specified)
{p_end}
{synopt:{cmd:r(s2)}}survival probability in the experimental group (if 
specified){p_end}
{synopt:{cmd:r(p1)}}proportion of subjects in the control group{p_end}
{synopt:{cmd:r(w)}}proportion of withdrawals (if specified){p_end}
{synopt:{cmd:r(Pr_E)}}probability of an event (failure) (when computed){p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(method)}}type of method ({cmd:Freedman} or {cmd:Schoenfeld})
{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(N)}}1x3 matrix of required sample sizes{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker C2003}{...}
{* this is spelled with 2 L's}{...}
{phang}
Collett, D. 2003.  
{it:Modelling Survival Data in Medical Research}. 2nd ed. 
London: Chapman & Hall/CRC.{p_end}

{marker F1982}{...}
{phang}
Freedman, L. S. 1982.  
Tables of the number of patients required in clinical trials using the logrank
test.  
{it:Statistics in Medicine} 1: 121-129.{p_end}

{marker MV1997}{...}
{phang}
Marubini, E., and M. G. Valsecchi. 1997. 
{it:Analysing Survival Data from Clinical Trials and Observational Studies}.
Chichester, UK: Wiley.

{marker S1981}{...}
{phang}
Schoenfeld, D. A. 1981.
The asymptotic properties of nonparametric tests for comparing survival
distributions.
{it: Biometrika} 68: 316-319.

{marker S1983}{...}
{phang}
------. 1983.
Sample-size formula for the proportional-hazards regression model.
{it:Biometrics} 39: 499-503.{p_end}
