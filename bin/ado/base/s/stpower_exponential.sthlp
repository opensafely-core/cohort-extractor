{smcl}
{* *! version 1.2.2  20aug2018}{...}
{viewerdialog "stpower exponential" "dialog stpower_exponential"}{...}
{vieweralsosee "previously documented" "help prdocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stpower" "help stpower"}{...}
{vieweralsosee "[ST] stpower cox" "help stpower_cox"}{...}
{vieweralsosee "[ST] stpower logrank" "help stpower_logrank"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] Glossary" "help st_glossary"}{...}
{vieweralsosee "[ST] streg" "help streg"}{...}
{vieweralsosee "[R] test" "help test"}{...}
{viewerjumpto "Syntax" "stpower_exponential##syntax"}{...}
{viewerjumpto "Menu" "stpower_exponential##menu"}{...}
{viewerjumpto "Description" "stpower_exponential##description"}{...}
{viewerjumpto "Options" "stpower_exponential##options"}{...}
{viewerjumpto "Short introduction to stpower exponential" "stpower_exponential##remarks1"}{...}
{viewerjumpto "Remarks on methods used in stpower exponential" "stpower_exponential##remarks2"}{...}
{viewerjumpto "Examples" "stpower_exponential##examples"}{...}
{viewerjumpto "Stored results" "stpower_exponential##results"}{...}
{viewerjumpto "References" "stpower_exponential##references"}{...}
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

{p2colset 5 33 35 2}{...}
{p2col :{hi:[ST] stpower exponential} {hline 2}}Sample size and power for the exponential test{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Sample-size determination

{p 6 0 0}
Specifying hazard rates

{p 8 16 2}
{opt stpow:er} {opt exp:onential} [{it:h1} [{it:h2}]] [{cmd:,}
   {help stpower exponential##options_table:{it:options}}]


{p 6 0 0}
Specifying survival probabilities

{p 8 40 2}
{opt stpow:er} {opt exp:onential} {it:s1} [{it:s2}] {cmd:,} {opt t(#)}
    [{help stpower exponential##options_table:{it:options}}]
 


{phang}
Power determination

{p 6 0 0}
Specifying hazard rates

{p 8 16 2}
{opt stpow:er} {opt exp:onential} [{it:h1} [{it:h2}]] {cmd:,} 
{opth n(numlist)} [{help stpower exponential##options_table:{it:options}}]


{p 6 0 0}
Specifying survival probabilities

{p 8 16 2}
{opt stpow:er} {opt exp:onential} {it:s1} [{it:s2}] {cmd:,} 
{opt t(#)} {opth n(numlist)} [{help stpower exponential##options_table:{it:options}}]


{phang}
where

{phang2}
{it:h1} is the hazard rate in the control group;{p_end}
{phang2}
{it:h2} is the hazard rate in the experimental group;
{p_end}
{phang2}
{it:s1} is the survival probability in the control group at reference (base)
time t; and{p_end}
{phang2}
{it:s2} is the survival probability in the experimental group at reference
(base) time t.{p_end}
{p 8 8}
{it:h1}, {it:h2} and {it:s1}, {it:s2} may each be specified either as one 
number or as a list of values (see {it:{help numlist}}) enclosed in
parentheses.{p_end}


{synoptset 28 tabbed}{...}
{marker options_table}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{synopt: {opt t(#)}}reference time t for survival probabilities
{it:s1} and {it:s2}{p_end}
{p2coldent:* {opth a:lpha(numlist)}}significance level; default is
{cmd:alpha(0.05)}{p_end}
{p2coldent:* {opth p:ower(numlist)}}power; default is {cmd:power(0.8)}
{p_end}
{p2coldent:* {opth b:eta(numlist)}}probability of type II error; 
default is {cmd:beta(0.2)}{p_end}
{p2coldent:* {opth n(numlist)}}sample size; required to compute power{p_end}
{p2coldent:* {opth hrat:io(numlist)}}hazard ratio of the 
experimental group to the control group, {it:h2}/{it:h1} or
ln({it:s2})/ln({it:s1}); default is {cmd:hratio(0.5)}{p_end}
{synopt: {opt onesid:ed}}one-sided test; default is two sided{p_end}
{p2coldent:* {opth p1(numlist)}}the proportion of subjects in the 
control group; default is {cmd:p1(0.5)}, meaning equal group sizes{p_end}
{p2coldent:* {opth nrat:io(numlist)}}ratio of sample sizes, N2/N1;
default is {cmd:nratio(1)}, meaning equal group sizes{p_end}
{synopt: {opt logh:azard}}power or sample-size computation for the test 
of the difference between log hazards; default is the test of the difference
between hazards{p_end}
{synopt: {opt unc:onditional}}power or sample-size computation using
the unconditional approach{p_end}
{synopt: {opt par:allel}}treat number lists in starred options as parallel (do
not enumerate all possible combinations of values) when multiple values per
option are specified{p_end}

{syntab: Accrual/Follow-up}
{synopt: {opt fp:eriod(#)}}length of the follow-up period; if not
specified, the study is assumed to continue until all subjects experience an
event (fail){p_end}
{synopt: {opt ap:eriod(#)}}length of the accrual period; default is
{cmd:aperiod(0)}, meaning no accrual{p_end}
{synopt: {opt apr:ob(#)}}proportion of subjects accrued by time t*
under truncated exponential accrual; default is {cmd:aprob(0.5)}{p_end}
{synopt: {opt apt:ime(#)}}proportion of the accrual period, 
t*/{cmd:aperiod()}, by which proportion of subjects in {cmd:aprob()} is accrued;
default is {cmd:aptime(0.5)}{p_end}
{synopt: {opt at:ime(#)}}reference accrual time t* by which the
proportion of subjects in {cmd:aprob()} is accrued; default value is
0.5*{cmd:aperiod()}{p_end}
{synopt: {opt ash:ape(#)}}shape of the truncated exponential accrual
distribution; default is {cmd:ashape(0)}, meaning uniform accrual{p_end}
{synopt: {opt losspr:ob(# #)}}proportion of subjects lost to follow-up
by time {cmd:losstime()} in the control and the experimental groups; default is
{cmd:lossprob(0 0)}, meaning no losses to follow-up{p_end}
{synopt: {opt losst:ime(#)}}(reference) time by which the
proportion of subjects specified in {cmd:lossprob()} is lost to follow-up;
default is {cmd:losstime(1)}{p_end}
{synopt: {opt lossh:az(# #)}}loss hazard rates in the control and the
experimental groups; default is {cmd:losshaz(0 0)}, meaning no losses to
follow-up{p_end}

{syntab:Reporting}
{synopt: {opt detail}}more detailed output{p_end}
{synopt: {opt tab:le}}display results in a table with default columns{p_end}
{synopt: {opth col:umns(stpower_exponential##colnames:colnames)}}display
results in a table with specified {it:colnames} columns{p_end}
{synopt: {opt noti:tle}}suppress table title{p_end}
{synopt: {opt noleg:end}}suppress table legend{p_end}
{synopt: {opt colw:idth(# [# ...])}}column widths; default is 
{cmd:colwidth(9)}{p_end}
{synopt: {opt sep:arator(#)}}draw a horizontal separator line every {it:#} lines; default is {cmd:separator(0)}, meaning no separator lines{p_end}
{synopt: {cmdab:sav:ing(}{it:{help filename}}[{cmd:,} {cmd:replace}]{cmd:)}}save
  the table data to {it:filename}; use {opt replace} to overwrite existing 
  {it:filename}{p_end}

{synopt: {opt nohead:er}}suppress table header; seldom used{p_end}
{synopt: {opt cont:inue}}draw a continuation border in the table output;
seldom used{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* Starred options may be specified either as one number or as a list of values
(see {it:{help numlist}}).{p_end}
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
{synopt: {opt n1}}number of subjects in the control group{p_end}
{synopt: {opt n2}}number of subjects in the experimental group{p_end}
{synopt: {opt hr}}hazard ratio{p_end}
{synopt: {opt loghr}}log of the hazard ratio (difference between log hazards)
{p_end}
{synopt: {opt diff}}difference between hazards{p_end}
{synopt: {opt h1}}hazard rate in the control group{p_end}
{synopt: {opt h2}}hazard rate in the experimental group{p_end}
{synopt: {opt s1}}survival probability in the control group{p_end}
{synopt: {opt s2}}survival probability in the experimental group{p_end}
{synopt: {opt t}}reference survival time{p_end}
{synopt: {opt p1}}proportion of subjects in the control group{p_end}
{synopt: {opt nrat:io}}ratio of sample sizes, experimental to control{p_end}
{synopt: {opt fp:eriod}}follow-up period{p_end}
{synopt: {opt ap:eriod}}accrual period{p_end}
{synopt: {opt apr:ob}}% of subjects accrued by time {cmd:atime} (or by 
{cmd:aptime} % of accrual period){p_end}
{synopt: {opt apt:ime}}% of an accrual period by which {cmd:aprob} % of subjects
are accrued{p_end}
{synopt: {opt at:ime}}reference accrual time{p_end}
{synopt: {opt ash:ape}}shape of the accrual distribution{p_end}
{synopt: {opt lpr1}}proportion of subjects lost to follow-up in the control 
group{p_end}
{synopt: {opt lpr2}}proportion of subjects lost to follow-up in the 
experimental group{p_end}
{synopt: {opt losst:ime}}reference loss to follow-up time{p_end}
{synopt: {opt lh1}}loss hazard in the control group{p_end}
{synopt: {opt lh2}}loss hazard in the experimental group{p_end}
{synopt: {opt eo}}total expected number of events (failures) under the
null{p_end}
{synopt: {opt eo1}}number of events in the control group under the null{p_end}
{synopt: {opt eo2}}number of events in the experimental group under the
null{p_end}
{synopt: {opt ea}}total expected number of events (failures) under the
alternative{p_end}
{synopt: {opt ea1}}number of events in the control group under the
alternative{p_end}
{synopt: {opt ea2}}number of events in the experimental group under the
alternative{p_end}
{synopt: {opt lo}}total expected number of losses to follow-up under the null{p_end}
{synopt: {opt lo1}}number of losses in the control group under the null{p_end}
{synopt: {opt lo2}}number of losses in the experimental group under the
null{p_end}
{synopt: {opt la}}total expected number of losses to follow-up under the alternative{p_end}
{synopt: {opt la1}}number of losses in the control group under the
alternative{p_end}
{synopt: {opt la2}}number of losses in the experimental group under the
alternative{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
By default, the following {it:colnames} are displayed:{p_end}
{phang2}
{cmd:power}, {cmd:n}, {cmd:n1}, {cmd:n2}, and {cmd:alpha} are always
displayed;{p_end}
{phang2}
{cmd:h1} and {cmd:h2} are displayed if hazard rates are specified, or 
{cmd:s1} and {cmd:s2} if survival probabilities are specified;{p_end}
{phang2}
{cmd:diff} if hazard difference test is specified, or {cmd:loghr} if
log-hazard difference test is specified;{p_end}
{phang2}
{cmd:aperiod} if accrual period ({cmd:aperiod()}) is specified;{p_end}
{phang2}
{cmd:fperiod} if follow-up period ({cmd:fperiod()}) is specified; and{p_end}
{phang2}
{cmd:lh1} and {cmd:lh2} if {cmd:losshaz()} or {cmd:lpr1} and {cmd:lpr2} if
{cmd:lossprob()} is specified.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survival analysis > Power and sample size}


{marker description}{...}
{title:Description}

{pstd}
{cmd:stpower} {cmd:exponential} estimates required sample size and power for
survival analysis comparing two exponential survivor functions by using
parametric tests for the difference between hazards or, optionally, for the
difference between log hazards.  It accommodates unequal allocation between
the two groups, flexible accrual of subjects into the study, and group-specific
losses to follow-up.  The accrual distribution may be chosen to be uniform over
the fixed accrual period, R, or truncated exponential over the period [0,R].
Losses to follow-up are assumed to be exponentially distributed.
Also the computations may be carried out using the conditional or the
unconditional approach.

{pstd}
You can use {cmd:stpower} {cmd:exponential} to

{phang2}
o  calculate expected number of events and required sample size when you know
power and effect size (supplied as hazard rates, survival probabilities, or
hazard ratio) for studies with or without follow-up and accrual periods
allowing for different accrual patterns and in the presence of losses to
follow-up and

{phang2}
o  calculate power when you know sample size and effect size (supplied as
hazard rates, survival probabilities, or hazard ratio) for studies with or
without follow-up and accrual periods allowing for different accrual patterns
and in the presence of losses to follow-up.

{pstd}
If the {cmd:t()} option is specified, the command's input parameters are the
values of survival probabilities in the control (or the less favorable) 
group, S1(t), and in the experimental group, S2(t), at a fixed
time, t (reference survival time), specified in {cmd:t()}, given as {it:s1} and
{it:s2}, respectively.  Otherwise, the input parameters are assumed to be the
values of the hazard rates in the control group, {it:lambda1}, and in the
experimental group, {it:lambda2}, given as {it:h1} and {it:h2}, respectively.
If survival probabilities are specified, they are converted to hazard rates by
using the formula for the exponential survivor function and the value of time
t in {cmd:t()}.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt t(#)} specifies a fixed time t (reference survival time) such that the
proportions of subjects in the control and experimental groups still alive
past this time point are as specified in {it:s1} and {it:s2}.  If this option
is specified, the input parameters, {it:s1} and {it:s2} are the survival
probabilities S1(t) and S2(t).  Otherwise, the input parameters are assumed to
be hazard rates, {it:lambda1} and {it:lambda2}, given as {it:h1} and {it:h2}
respectively.

{phang}
{opth alpha(numlist)} sets the significance level of the test.  The default is
{cmd: alpha(0.05)}.

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
compute the power of the test.  By default, the sample-size calculation is
assumed.  This option may not be combined with {cmd:beta()} or {cmd:power()}.

{phang}
{opth hratio(numlist)} specifies the hazard ratio of the experimental group to
the control group.  The default is {cmd:hratio(0.5)}.  This value defines the
clinically significant improvement of the experimental procedure over the
control desired to be detected by a test, with a certain power specified in
{cmd:power()}.  If {it:h1} and {it:h2} (or {it:s1} and {it:s2}) are given,
{cmd:hratio()} is not allowed and the hazard ratio is computed as
{it:h2}/{it:h1} (or ln({it:s2})/ln({it:s1})).

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
{opt loghazard} requests sample-size or power computation for the test of the
difference between log hazards (or the test of the log of the hazard ratio).
This option implies uniform accrual.  By default, the test of the difference
between hazards is assumed.

{phang}
{opt unconditional} requests that the unconditional approach be used for
sample-size or power computation; see
{it:The conditional versus unconditional approaches} and
{it:Methods and formulas} in {bf:[ST] stpower exponential} for details.

{phang}
{cmd:parallel} reports results sequentially (in parallel) over the list of
numbers supplied to options allowing {it:{help numlist}}.  By default, results
are computed over all combinations of the number lists in the following order
of nesting: {cmd:alpha()}; {cmd:p1()} or {cmd:nratio()}; list of hazard rates
{it:h1} and {it:h2} or survival probabilities {it:s1} and {it:s2};
{cmd:hratio()}; {cmd:power()} or {cmd:beta()}; and {cmd:n()}.  This option
requires that options with multiple values each contain the same number of
elements.

{dlgtab:Accrual/Follow-up}

{phang}
{opt fperiod(#)} specifies the follow-up period of the study, f.  By default
it is assumed that subjects are followed up until the last subject experiences
an event (fails).  The (minimal) follow-up period is defined as the length of
the time period after the recruitment of the last subject to the study until
the end of the study.  If T is the duration of a study and R is the length of
an accrual period, then the follow-up period is {bind:f = T - R}.

{phang}
{opt aperiod(#)} specifies the accrual period, R, during which subjects are to
be recruited into the study.  The default is {cmd:aperiod(0)}, meaning no
accrual.

{phang}
{opt aprob(#)} specifies the proportion of subjects expected to be accrued by
time t* according to the truncated exponential distribution.  The default is
{cmd:aprob(0.5)}.  This option is useful when the shape parameter is unknown but
the proportion of accrued subjects at a certain time is known.  {cmd:aprob()}
is often used in conjunction with {cmd:aptime()} or {cmd:atime()}.  This
option may not be specified with {cmd:ashape()} or {cmd:loghazard} and
requires specifying a nonzero accrual period in {cmd:aperiod()}.

{phang}
{opt aptime(#)} specifies the proportion of the accrual period, t*/R, by which
the proportion of subjects specified in {cmd:aprob()} is expected to be
accrued according to the truncated exponential distribution.  The default is
{cmd:aptime(0.5)}.  This option may not be combined with {cmd:atime()},
{cmd:ashape()}, or {cmd:loghazard} and requires specifying a nonzero accrual
period in {cmd:aperiod()}.

{phang}
{opt atime(#)} specifies the time point t*, reference accrual time, by which
the proportion of subjects specified in {cmd:aprob()} is expected to be
accrued according to the truncated exponential distribution.  The default
value is 0.5*R.  This option may not be combined with {cmd:aptime()},
{cmd:ashape()}, or {cmd:loghazard} and requires specifying a nonzero accrual
period in {cmd:aperiod()}.  The value in {cmd:atime()} may not exceed the
value in {cmd:aperiod()}.

{phang}
{opt ashape(#)} specifies the shape, {it:gamma}, of the truncated exponential
accrual distribution.  The default is {cmd:ashape(0)}, meaning uniform
accrual.  This option is not allowed in conjunction with {cmd:loghazard} and
requires specifying a nonzero accrual period in {cmd:aperiod()}.

{phang}
{opt lossprob(# #)} specifies the proportion of subjects lost to follow-up by
time {cmd:losstime()} in the control and the experimental groups,
respectively.  The default is {cmd:lossprob(0 0)}, meaning no losses to
follow-up.  This option requires specifying {cmd:aperiod()} or {cmd:fperiod()}
and may not be combined with {cmd:losshaz()}.

{phang}
{opt losstime(#)} specifies the time at which the proportion of subjects
specified in {cmd:lossprob()} is lost to follow-up, also referred to as the
reference loss to follow-up time.  The default is {cmd:losstime(1)}.  This
option requires specifying {cmd:lossprob()}.

{phang}
{opt losshaz(# #)} specifies exponential hazard rates of losses to follow-up,
{it:eta1} and {it:eta2}, in the control and the experimental groups,
respectively.  The default is {cmd:losshaz(0 0)}, meaning no losses to
follow-up.  This option requires specifying {cmd:aperiod()} or {cmd:fperiod()}
and may not be combined with {cmd:lossprob()}.

{dlgtab:Reporting}

{phang}
{opt detail} displays more detailed output; the expected number of events
(failures) and losses to follow-up under the null and alternative hypotheses
are displayed.  This option is not appropriate with tabular output.

{phang}
{cmd:table} displays results in a tabular format and is implied if any number
list contains more than one element.  This option is useful if you are
producing results one case at a time and wish to construct your own custom
table by using a {cmd:forvalues} loop.

{phang}
{opth "columns(stpower_exponential##colnames:colnames)"} specifies results in
a table with specified {it:colnames} columns.  The order of the columns in the
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
{cmd:saving(}{it:{help filename}}[{cmd:,} {cmd:replace}]{cmd:)} creates a
Stata data file ({cmd:.dta} file) containing the table values with variable
names corresponding to the displayed
{it:{help stpower_exponential##colnames:colnames}.} {cmd:replace} specifies 
that {it:filename} be overwritten if it exists.  {cmd:saving()} is only
appropriate with tabular output.

{pstd}The following options are available with {cmd:stpower exponential} but
are not shown in the dialog box:

{phang}
{cmd:noheader} prevents the table header from displaying.  This option is
useful when the command is issued repeatedly, such as within a loop.
{cmd:noheader} implies {cmd:notitle}.

{phang}
{cmd:continue} draws a continuation border at the bottom of the table.  This
option is useful when the command is issued repeatedly within a loop.


{marker remarks1}{...}
{title:Short introduction to stpower exponential}

{pstd}
By default, {cmd:stpower} {cmd:exponential} computes the required sample size
for the test of the difference between two hazard rates using {cmd:power(0.8)}
(or, equivalently, {cmd:beta(0.2)}).  The default setting for power or,
alternatively, the probability of a type II error may be changed by using
{cmd:power()} or {cmd:beta()}, respectively.  If power determination is
desired, sample size {cmd:n()} must be specified.  If the test for the log of
the hazard ratio (for the difference between log hazards) is desired, option
{cmd:loghazard} must be specified.

{pstd}
The default probability of a type I error of a test is 0.05 but may be changed
by using option {cmd:alpha()}.  One-sided tests may be requested by using
{cmd:onesided}.  The default equal-group allocation may be changed by
specifying {cmd:p1()} or {cmd:nratio()}.

{pstd}
If neither the length of a follow-up period, f, nor the length of an accrual
period, R, is specified in options {cmd:fperiod()} or {cmd:aperiod()},
respectively, the study is assumed to continue until all subjects experience
an event (failure), regardless of how much time is required.  If either of the
two options are supplied, a fixed-duration study of a length {bind:T = R + f}
is assumed.

{pstd}
If an accrual period of length R is specified in option {cmd:aperiod()},
uniform accrual over the period [0,R] is assumed.  The accrual distribution
may be changed to truncated exponential when the shape parameter is specified
in {cmd:ashape()}. The combination of options {cmd:aprob()} and {cmd:aptime()}
(or {cmd:atime()}) may be used in place of option {cmd:ashape()} to request
the desired shape of the truncated exponential accrual.

{pstd}
To take into account exponential losses to follow-up, options
{cmd:losshaz()} or {cmd:lossprob()} and {cmd:losstime()} may be used.  See
{it:Nonuniform accrual and exponential losses to follow-up}
in {bf:[ST] stpower exponential} for details.

{pstd}
Optionally, results may be displayed in a table using {cmd:table} or
{cmd:columns()} as demonstrated in 
{it:{help stpower_exponential##examples:Examples}} below and in
{helpb stpower:[ST] stpower}.  For examples on how to plot a power curve, see
{it:{help stpower_exponential##examples:Examples}} below,
{helpb stpower:[ST] stpower}, and 
example 7 in {bf:[ST] stpower logrank}.


{marker remarks2}{...}
{title:Remarks on methods used in stpower exponential}

{pstd}
By default, {cmd: stpower exponential} computes the sample size required to
achieve a specified power to detect a difference between hazard rates using
the method of {help stpower exponential##L1981:Lachin (1981)}.
If {cmd:loghazard} is specified, the sample size
required to detect a log of the hazard ratio with
specified power is reported using the formula derived by 
{help stpower exponential##GD1974:George and Desu (1974)}.
In the presence of an accrual period, the methods of
{help stpower exponential##LF1986:Lachin and Foulkes (1986)}
or, for uniform accrual only,
{help stpower exponential##RGS1981:Rubinstein, Gail, and Santner (1981)}
(if {cmd:loghazard} and {cmd:unconditional} are specified), are
utilized.


{marker examples}{...}
{title:Examples}

{pstd}
In the following examples, we assume that both the control and experimental
groups' survivor functions are exponential.  We know from previous studies
that the yearly hazard rate for members of the control group is 0.3, and we
are interested in detecting a hazard rate of 0.2 in the experimental group (a
hazard ratio of 0.667).

{pstd}
Compute required sample sizes for a two-sided 5% test based on the log-hazard
difference with 80% power{p_end}
{phang2}
{cmd:. stpower exponential 0.3 0.2, loghazard}
{p_end}

{pstd}
Same as above command, but display results in a table
{p_end}
{phang2} 
{cmd:. stpower exponential 0.3 0.2, loghazard table} 
{p_end}

{pstd}
Compute required number of subjects assuming a 5-year follow-up period, using
a one-sided 5% test{p_end}
{phang2}
{cmd:. stpower exponential 0.3 0.2, fperiod(5) onesided}
{p_end}

{pstd}
Compute required sample size with 2-year accrual period and 3-year follow-up
period{p_end}
{phang2}
{cmd:. stpower exponential 0.3 0.2, aperiod(2) fperiod(3)}
{p_end}

{pstd}
Compute power corresponding to a sample size of 300 assuming an exponential
accrual distribution with a shape parameter of -2 (implying slower accrual at
the beginning of the period and fast accrual toward the end){p_end}
{phang2}
{cmd:. stpower exponential 0.3 0.2, n(300) aperiod(2) ashape(-2)}
{p_end}

{pstd}
Obtain power for a range of hazard ratios and two sample sizes{p_end}
{phang2}
{cmd:. stpower exponential 0.3, hratio(0.1(0.2)0.9) n(50 100)}
{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:stpower exponential} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(power)}}power of test{p_end}
{synopt:{cmd:r(alpha)}}significance level of test{p_end}
{synopt:{cmd:r(hratio)}}hazard ratio{p_end}
{synopt:{cmd:r(onesided)}}{cmd:1} if one-sided test, {cmd:0} otherwise{p_end}
{synopt:{cmd:r(h1)}}hazard in the control group{p_end}
{synopt:{cmd:r(h2)}}hazard in the experimental group{p_end}
{synopt:{cmd:r(t)}}reference survival time (if {cmd:t()} is specified){p_end}
{synopt:{cmd:r(p1)}}proportion of subjects in the control group{p_end}
{synopt:{cmd:r(fperiod)}}length of the follow-up period (if specified){p_end}
{synopt:{cmd:r(aperiod)}}length of the accrual period (if specified){p_end}
{synopt:{cmd:r(ashape)}}shape parameter (if {opt aperiod()} is specified){p_end}
{synopt:{cmd:r(lh1)}}loss hazard in the control group{p_end}
{synopt:{cmd:r(lh2)}}loss hazard in the experimental group{p_end}
{synopt:{cmd:r(lt)}}reference loss to follow-up time (if {cmd:losstime()} is 
specified){p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(method)}}type of method ({cmd:hazard difference} or 
{cmd:log-hazard difference}){p_end}
{synopt:{cmd:r(accrual)}}type of entry distribution ({cmd:uniform} or 
{cmd:exponential}) (if requested){p_end}
{synopt:{cmd:r(type)}}type of approach ({cmd:conditional} or 
{cmd:unconditional}){p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(N)}}1x3 matrix of required sample sizes{p_end}
{synopt:{cmd:r(Pr)}}1x4 matrix of probabilities of an event (when computed)
{p_end}
{synopt:{cmd:r(Ea)}}1x3 matrix of expected number of events under the 
alternative (when computed){p_end}
{synopt:{cmd:r(Eo)}}1x3 matrix of expected number of events under the null 
(when computed){p_end}
{synopt:{cmd:r(La)}}1x3 matrix of expected number of losses under the 
alternative (when computed){p_end}
{synopt:{cmd:r(Lo)}}1x3 matrix of expected number of losses under the null 
(when computed){p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker GD1974}{...}
{phang}
George, S. L., and M. M. Desu. 1974. 
Planning the size and duration of a clinical trial studying the time to some
critical event. {it: Journal of Chronic Diseases} 27: 15-24.{p_end}

{marker L1981}{...}
{phang}
Lachin, J. M. 1981.
Introduction to sample size determination and power analysis for clinical
trials. {it: Controlled Clinical Trials} 2: 93-113.{p_end}

{marker LF1986}{...}
{phang}
Lachin, J. M., and M. A. Foulkes. 1986. 
Evaluation of sample size and power for analysis of survival with allowance
for nonuniform patient entry, losses to follow-up, noncompliance, and
stratification. {it: Biometrics} 42: 507-519.{p_end}

{marker RGS1981}{...}
{phang}
Rubinstein, L. V., M. H. Gail, and T. J. Santner. 1981.
Planning the duration of a comparative clinical trial with loss to follow-up
and a period of continued observation. {it: Journal of Chronic Diseases} 34: 469-479.{p_end}
