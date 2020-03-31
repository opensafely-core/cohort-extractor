{smcl}
{* *! version 1.0.15  12mar2019}{...}
{viewerdialog power "dialog power_exponential"}{...}
{vieweralsosee "[PSS-2] power exponential" "mansection PSS-2 powerexponential"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power" "help power"}{...}
{vieweralsosee "[PSS-2] power cox" "help power cox"}{...}
{vieweralsosee "[PSS-2] power logrank" "help power logrank"}{...}
{vieweralsosee "[PSS-2] power, graph" "help power_optgraph"}{...}
{vieweralsosee "[PSS-2] power, table" "help power_opttable"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] streg" "help streg"}{...}
{vieweralsosee "[R] test" "help test"}{...}
{viewerjumpto "Syntax" "power_exponential##syntax"}{...}
{viewerjumpto "Menu" "power_exponential##menu"}{...}
{viewerjumpto "Description" "power_exponential##description"}{...}
{viewerjumpto "Links to PDF documentation" "power_exponential##linkspdf"}{...}
{viewerjumpto "Options" "power_exponential##options"}{...}
{viewerjumpto "Remarks: Using power exponential" "power_exponential##remarks"}{...}
{viewerjumpto "Examples" "power_exponential##examples"}{...}
{viewerjumpto "Stored results""power_exponential##results"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[PSS-2] power exponential} {hline 2}}Power analysis for a
two-sample exponential test{p_end}
{p2col:}({mansection PSS-2 powerexponential:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Compute sample size

{p 6 8 2}
Specify hazard rates

{p 8 20 2}
{opt power} {opt exp:onential} [{it:h1} [{it:h2}]]
[{cmd:,} {opth p:ower(numlist)} 
{it:{help power_exponential##synoptions:options}}] 

{p 6 8 2}
Specify survival probabilities

{p 8 20 2}
{opt power} {opt exp:onential} {it:s1} [{it:s2}]{cmd:,}
{opt t:ime(#)} [{opth p:ower(numlist)} 
{it:{help power_exponential##synoptions:options}}] 


{phang}
Compute power 

{p 6 8 2}
Specify hazard rates

{p 8 20 2}
{opt power} {opt exp:onential} [{it:h1} [{it:h2}]]{cmd:,}  
{opth n(numlist)}
[{it:{help power_exponential##synoptions:options}}]

{p 6 8 2}
Specify survival probabilities

{p 8 20 2}
{opt power} {opt exp:onential} {it:s1} [{it:s2}]{cmd:,}
{opt t:ime(#)} {opth n(numlist)}
[{it:{help power_exponential##synoptions:options}}] 


{phang}
where 

{phang2}
{it:h1} is the hazard rate in the control group;

{phang2}
{it:h2} is the hazard rate in the experimental group;

{phang2}
{it:s1} is the survival probability in the control group at reference
(base) time {it:t}; and

{phang2}
{it:s2} is the survival probability in the experimental group at reference
(base) time {it:t}.

{pstd}
{it:h1}, {it:h2} and {it:s1}, {it:s2} may each be specified
either as one number or as a list of values in parentheses
(see {help numlist}).


{synoptset 30 tabbed}{...}
{marker synoptions}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{p2coldent:* {opt t:ime(#)}}reference time {it:t} for survival
   probabilities {it:s1} and {it:s2}{p_end}
{p2coldent:* {opth a:lpha(numlist)}}significance level; default is
   {cmd:alpha(0.05)}{p_end}
{p2coldent:* {opth p:ower(numlist)}}power; default is {cmd:power(0.8)}{p_end}
{p2coldent:* {opth b:eta(numlist)}}probability of type II error; default is
   {cmd:beta(0.2)}{p_end}
{p2coldent:* {opth n(numlist)}}total sample size; required to compute power{p_end}
{p2coldent:* {opth n1(numlist)}}sample size of the control group{p_end}
{p2coldent:* {opth n2(numlist)}}sample size of the experimental group{p_end}
{p2coldent:* {opth nrat:io(numlist)}}ratio of sample sizes, {cmd:N2/N1};
    default is {cmd:nratio(1)}, meaning equal group sizes{p_end}
{synopt:{opt nfrac:tional}}allow fractional sample sizes{p_end}
{p2coldent:* {opth hr:atio(numlist)}}hazard ratio (effect size)
   of the experimental to the control group; default is {cmd:hratio(0.5)}; may
   not be combined with {cmd:lnhratio()} or {cmd:hdifference()}{p_end}
{p2coldent:* {opth lnhr:atio(numlist)}}log hazard-ratio (effect size)
   of the experimental to the control group; may not be combined with
   {cmd:hratio()} or {cmd:hdifference()}{p_end}
{p2coldent:* {opth hdiff:erence(numlist)}}difference between the
experimental-group and control-group hazard rates (effect size); may not be
combined with {cmd:hratio()} or {cmd:lnhratio()}{p_end}
{p2coldent:* {opth diff:erence(numlist)}}synonym for {cmd:hdifference()}{p_end}
{p2coldent:* {opt logh:azard}}power or sample-size computation for the test
of the difference between log hazards; default is the test of the difference
between hazards{p_end}
{p2coldent:* {opt unc:onditional}}power or sample-size computation using the
unconditional approach{p_end}
{synopt:{cmdab:effect(}{it:{help power_exponential##effect:effect}}{cmd:)}}specify the type of effect to
display; default is method specific{p_end}
{synopt :{opt onesid:ed}}one-sided test; default is two sided{p_end}
{synopt: {opt par:allel}}treat number lists in starred options or in command
arguments as parallel when multiple values per option or argument are
specified (do not enumerate all possible combinations of values){p_end}

{syntab:Accrual/Follow-up}
{p2coldent:* {opth studyt:ime(numlist)}}duration of the study;
if not specified, the study is assumed to continue until all subjects
experience an event (fail){p_end}
{p2coldent:* {opth fp:eriod(numlist)}}length of the follow-up period;
if not specified, the study is assumed to continue until all subjects
experience an event (fail){p_end}
{p2coldent:* {opth ap:eriod(numlist)}}length of the accrual period;
default is {cmd:aperiod(0)}, meaning no accrual{p_end}
{p2coldent:* {opth apr:ob(numlist)}}proportion of subjects accrued by
time {it:ta} under truncated exponential accrual; default is {cmd:aprob(0.5)}{p_end}
{p2coldent:* {opth apt:ime(numlist)}}proportion of the accrual
period, {it:ta}/{cmd:aperiod()}, by which proportion of subjects in
{cmd:aprob()} is accrued; default is {cmd:aptime(0.5)} {p_end}
{p2coldent:* {opth at:ime(numlist)}}reference accrual time {it:ta} by
which the proportion of subjects in {cmd:aprob()} is accrued; default
value is 0.5 x {cmd:aperiod()}{p_end}
{p2coldent:* {opth ash:ape(numlist)}}shape of the truncated
exponential accrual distribution; default is {cmd:ashape(0)}, meaning
uniform accrual{p_end}
{p2coldent:* {opth losspr:ob(numlist)}}proportion of subjects
lost to follow-up by time {cmd:losstime()} in the control and the
experimental groups; default is {cmd:lossprob(0)}, meaning no losses to
follow-up{p_end}
{p2coldent:* {opth lossprob1(numlist)}}proportion of subjects lost
to follow-up by time {cmd:losstime()} in the control group; default
is {cmd:lossprob1(0)}, meaning no losses to follow-up in the control
group{p_end}
{p2coldent:* {opth lossprob2(numlist)}}proportion of subjects lost
to follow-up by time {cmd:losstime()} in the experimental group; default
is {cmd:lossprob2(0)}, meaning no losses to follow-up in the experimental
group{p_end}
{p2coldent:* {opth losst:ime(numlist)}}reference time {it:tL} by which the proportion
of subjects specified in {cmd:lossprob()}, {cmd:lossprob1()}, or
{cmd:lossprob2()} is lost to follow-up; default is {cmd:losstime(1)}{p_end}
{p2coldent:* {opth lossh:az(numlist)}}loss hazard rates in the control and the
experimental groups; default is {cmd:losshaz(0)}, meaning no losses
to follow-up{p_end}
{p2coldent:* {opth losshaz1(numlist)}}loss hazard rates in the
control group; default is {cmd:losshaz1(0)},
meaning no losses to follow-up in the control group{p_end}
{p2coldent:* {opth losshaz2(numlist)}}loss hazard rates in the
experimental group; default is {cmd:losshaz2(0)},
meaning no losses to follow-up in the experimental group{p_end}

{syntab:Table}
{synopt :[{cmdab:no:}]{cmdab:tab:le}[{cmd:(}{it:{help power_exponential##tablespec:tablespec}}{cmd:)}]}suppress table or display results as a table; see
{manhelp power_opttable PSS-2:power, table}{p_end}
{synopt :{cmdab:sav:ing(}{it:{help filename}}[{cmd:, replace}]{cmd:)}}save the
table data to {it:filename}; use {cmd:replace} to overwrite existing
{it:filename}{p_end}

INCLUDE help pss_graphopts.ihlp

{syntab:Reporting}
{synopt: {opt show}}display group-specific numbers of events and, in the
presence of loss to follow-up, numbers of losses{p_end}
{synopt: {opth show:(power_exponential##showspec:showspec)}}display
group-specific numbers of events, numbers of losses, and event
probabilities{p_end}

INCLUDE help pss_reportopts.ihlp
{synoptline}
{p2colreset}{...}
INCLUDE help pss_numlist.ihlp
{p 4 6 2}{cmd:notitle} does not appear in the dialog box.{p_end}


{synoptset 17}{...}
{marker effect}{...}
{synopthdr :effect}
{synoptline}
{synopt:{opt hr:atio}}hazard ratio{p_end}
{synopt:{opt lnhr:atio}}log hazard-ratio{p_end}
{synopt:{opt hdiff:erence}}difference between hazard rates{p_end}
{synopt:{opt lnhdiff:erence}}difference between log hazard-rates (equivalent
to log hazard-ratio){p_end}
{synopt:{opt diff:erence}}synonym for {cmd:hdifference}{p_end}
{synoptline}


{synoptset 17}{...}
{marker showspec}{...}
{synopthdr :showspec}
{synoptline}
{synopt:{opt events}}numbers of events{p_end}
{synopt:{opt losses}}numbers of losses{p_end}
{synopt:{opt eventpr:obs}}event probabilities{p_end}
{synopt:{opt all}}all the above{p_end}
{synoptline}


{marker tablespec}{...}
{pstd}
where {it:tablespec} is

{p 16 16 2}
{it:{help power_exponential##column:column}}[{cmd::}{it:label}]
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
{synopt :{opt N}}total number of subjects{p_end}
{synopt :{opt N1}}number of subjects in the control group{p_end}
{synopt :{opt N2}}number of subjects in the experimental group{p_end}
{synopt :{opt nratio}}ratio of sample sizes, experimental to control{p_end}
{synopt :{opt delta}}effect size{p_end}
{synopt :{opt s1}}survival probability in the control group{p_end}
{synopt :{opt s2}}survival probability in the experimental group{p_end}
{synopt :{opt time}}reference survival time{p_end}
{synopt :{opt h1}}hazard rate in the control group{p_end}
{synopt :{opt h2}}hazard rate in the experimental group{p_end}
{synopt :{opt hdiff}}difference between hazard rates{p_end}
{synopt :{opt hratio}}hazard ratio{p_end}
{synopt :{opt lnhratio}}log hazard-ratio{p_end}
{synopt :{opt studytime}}duration of a study{p_end}
{synopt :{opt fperiod}}follow-up period{p_end}
{synopt :{opt aperiod}}accrual period{p_end}
{synopt :{opt aprob}}proportion of subjects accrued by time {cmd:atime} (or by
{cmd:aptime} x 100% of accrual period){p_end}
{synopt :{opt aptime}}proportion of an accrual period by which {cmd:aprob} x
100% of subjects are accrued{p_end}
{synopt :{opt atime}}reference accrual time{p_end}
{synopt :{opt ashape}}shape of the accrual distribution{p_end}
{synopt :{opt E0}}total number of events under H0{p_end}
{synopt :{opt E01}}number of events in the control group under H0{p_end}
{synopt :{opt E02}}number of events in the experimental group under H0{p_end}
{synopt :{opt Ea}}total number of events under Ha{p_end}
{synopt :{opt Ea1}}number of events in the control group under Ha{p_end}
{synopt :{opt Ea2}}number of events in the experimental group under Ha{p_end}
{synopt :{opt Pr_E01}}control-group probability of an event under H0{p_end}
{synopt :{opt Pr_E02}}experimental-group probability of an event under H0{p_end}
{synopt :{opt Pr_Ea1}}control-group probability of an event under Ha{p_end}
{synopt :{opt Pr_Ea2}}experimental-group probability of an event under Ha{p_end}
{synopt :{opt lossprob}}proportion of subjects lost to follow-up in the
control and experimental group{p_end}
{synopt :{opt lossprob1}}proportion of subjects lost to follow-up in the
control group{p_end}
{synopt :{opt lossprob2}}proportion of subjects lost to follow-up in the
experimental group{p_end}
{synopt :{opt losstime}}reference loss-to-follow-up time{p_end}
{synopt :{opt losshaz}}loss hazard rate in the control and experimental groups{p_end}
{synopt :{opt losshaz1}}loss hazard rate in the control group{p_end}
{synopt :{opt losshaz2}}loss hazard rate in the experimental group{p_end}
{synopt :{opt L0}}total number of losses under H0{p_end}
{synopt :{opt L01}}number of losses in the control group under H0{p_end}
{synopt :{opt L02}}number of losses in the experimental group under H0{p_end}
{synopt :{opt La}}total number of losses under Ha{p_end}
{synopt :{opt La1}}number of losses in the control group under Ha{p_end}
{synopt :{opt La2}}number of losses in the experimental group under Ha{p_end}
{synopt :{opt target}}target parameter; synonym for {cmd:h2} or {cmd:hratio}{p_end}
{synopt :{opt _all}}display all supported columns{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}Column {cmd:beta} is shown in the default table in place of column
{cmd:power} if option {cmd:beta()} is specified.{p_end}
{p 4 6 2}
Column {cmd:hratio} is shown in the default table if option {cmd:hratio()} is
specified or implied by the command.{p_end}
{p 4 6 2}
Columns {cmd:nratio} and {cmd:lnhratio} are shown in the default table if
the corresponding options are specified.{p_end}
{p 4 6 2}
Columns {cmd:h1}, {cmd:h2}, {cmd:s1}, and {cmd:s2} are available and are shown
in the default table when the corresponding command arguments are
specified.{p_end}
{p 4 6 2}
Columns {cmd:time}, {cmd:studytime}, {cmd:fperiod}, {cmd:aperiod},
{cmd:aprob}, {cmd:aptime}, {cmd:atime}, {cmd:ashape}, {cmd:losshaz},
{cmd:losshaz1}, {cmd:losshaz2}, {cmd:lossprob}, {cmd:lossprob1},
{cmd:lossprob2}, and {cmd:losstime} are available and are shown in the default
table when the corresponding options are specified.{p_end}
{p 4 6 2}
Columns containing numbers of events, numbers of losses, and probabilities of
an event are displayed if specified or if respective options
{cmd:show(events)}, {cmd:show(losses)}, or {cmd:show(eventprobs)} are
specified.  If {cmd:show} is specified, numbers of events and losses are
displayed.  If {cmd:show(all)} is specified, numbers of events, numbers of
losses, and probabilities are displayed.{p_end}


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
{cmd:power exponential} computes sample size or power for survival analysis
comparing two exponential survivor functions by using parametric tests for the
difference between hazards or, optionally, for the difference between log
hazards. It accommodates unequal allocation between the two groups, flexible
accrual of subjects into the study, and group-specific losses to follow-up.
The accrual distribution may be chosen to be uniform or truncated exponential
over a fixed accrual period.  Losses to follow-up are assumed to be
exponentially distributed.  Also the computations may be performed using the
conditional or the unconditional approach.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-2 powerexponentialQuickstart:Quick start}

        {mansection PSS-2 powerexponentialRemarksandexamples:Remarks and examples}

        {mansection PSS-2 powerexponentialMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt time(#)} specifies a fixed time {it:t} (reference survival
time) such that the proportions of subjects in the control and experimental
groups still alive past this time point are as specified in {it:s1} and
{it:s2}.  If this option is specified, the input parameters {it:s1}
and {it:s2} are the survival probabilities {it:S1(t)} and {it:S2(t)}.
Otherwise, the input parameters are assumed to be hazard rates lambda1
and lambda2 given as {it:h1} and {it:h2}, respectively.

{phang}
{cmd:alpha()}, {cmd:power()}, {cmd:beta()}, {cmd:n()}, {cmd:n1()}, {cmd:n2()},
{cmd:nratio()}, {cmd:nfractional}; see {manhelp power##mainopts PSS-2: power}.

{phang}
{opth hratio(numlist)} specifies the hazard ratio (effect size) of the
experimental group to the control group.  The default is {cmd:hratio(0.5)}.
This value typically defines the clinically significant improvement of the
experimental procedure over the control procedure desired to be detected by
a test with a certain power.  If {it:h1} and {it:h2} (or {it:s1}
and {it:s2}) are given, {cmd:hratio()} is not allowed and the hazard ratio
is computed as {it:h2}/{it:h1} [or ln({it:s2})/ln({it:s1})]. Also see
{mansection PSS-2 powerexponentialRemarksandexamplessub1:{it:Alternative ways of specifying effect}}
in {bf:[PSS-2] power exponential} for various specifications of an effect size.

{pmore}
This option is not allowed with the effect-size determination and may not be
combined with {cmd:lnhratio()} or {cmd:hdifference()}.

{phang}
{opth lnhratio(numlist)} specifies the log hazard-ratio (effect size) of the
experimental group to the control group.  This value typically defines the
clinically significant improvement of the experimental procedure over the
control procedure desired to be detected by a test with a certain power.  If
{it:h1} and {it:h2} (or {it:s1} and {it:s2}) are given, {cmd:lnhratio()} is
not allowed and the log hazard-ratio is computed as ln({it:h2}/{it:h1})
[or ln{c -(}ln({it:s2})/ln({it:s1}){c )-}]. Also see
{mansection PSS-2 powerexponentialRemarksandexamplessub1:{it:Alternative ways of specifying effect}}
in {bf:[PSS-2] power exponential} for various specifications of an effect size.

{pmore}
This option is not allowed with the effect-size determination and may not be
combined with {cmd:hratio()} or {cmd:hdifference()}.

{phang}
{opth hdifference(numlist)} specifies the difference between the
experimental-group hazard rate and the control-group hazard rate.  It requires
that the control-group hazard rate, the command argument {it:h1}, is
specified.  {cmd:hdifference()} provides a way of specifying an effect size;
see {mansection PSS-2 powerexponentialRemarksandexamplessub1:{it:Alternative ways of specifying effect}}
in {bf:[PSS-2] power exponential} for details.

{pmore}
This option is not allowed with the effect-size determination and may not be
combined with {cmd:hratio()} or {cmd:lnhratio()}.

{phang}
{cmd:loghazard} requests sample-size or power computation for the test of the
difference between log hazards (or the log hazard-ratio test).
This option implies uniform accrual.  By default, the test of the difference
between hazards is assumed.

{phang}
{cmd:unconditional} requests that the unconditional approach be used for
sample-size or power computation; see
{mansection PSS-2 powerexponentialRemarksandexamplesTheconditionalversusunconditionalapproaches:{it:The conditional versus unconditional approaches}}
and
{mansection PSS-2 powerexponentialMethodsandformulas:{it:Methods and formulas}}
in {bf:[PSS-2] power exponential} for details.

{phang}
{opt effect(effect)} specifies the type of the effect size to be
reported in the output as {cmd:delta}.  {it:effect} is one of
{cmd:hratio}, {cmd:lnhratio}, {cmd:hdifference}, or {cmd:lnhdifference}.  By
default, the effect size {cmd:delta} is a hazard ratio, {cmd:effect(hratio)},
for a hazard-ratio test and a log hazard-ratio, {cmd:effect(lnhratio)}, for a
log hazard-ratio test (when {cmd:schoenfeld} is specified).  

{phang}
{cmd:onesided}, {cmd:parallel}; see {manhelp power##mainopts PSS-2: power}.

{dlgtab:Accrual/Follow-up}

{phang}
{opth studytime(numlist)} specifies the duration of the study, {it:T}.  By
default, it is assumed that subjects are followed up until the last subject
experiences an event (fails).  The (minimal) follow-up period is defined as
the length of the period after the recruitment of the last subject to the
study until the end of the study.  If {it:r} is the length of an accrual
period and {it:f} is the length of the follow-up period, then
{it:T}={it:r}+{it:f}.  You can specify only two of the three options
{cmd:studytime()}, {cmd:fperiod()}, and {cmd:aperiod()}.

{phang}
{opth fperiod(numlist)} specifies the follow-up period of the study, {it:f}.
By default, it is assumed that subjects are followed up until the last subject
experiences an event (fails).  The (minimal) follow-up period is defined as
the length of the period after the recruitment of the last subject to the
study until the end of the study.  If {it:T} is the duration of a study and
{it:r} is the length of an accrual period, then the follow-up period is
{it:f}={it:T}-{it:r}.  You can specify only two of the three options
{cmd:studytime()}, {cmd:fperiod()}, and {cmd:aperiod()}.

{phang}
{opth aperiod(numlist)} specifies the accrual period, {it:r}, during which
subjects are to be recruited into the study.  The default is {cmd:aperiod(0)},
meaning no accrual.  You can specify only two of the three options
{cmd:studytime()}, {cmd:fperiod()}, and {cmd:aperiod()}.

{phang}
{opth aprob(numlist)} specifies the proportion of subjects expected to be
accrued by time {it:t}* according to the truncated exponential distribution.
The default is {cmd:aprob(0.5)}.  This option is useful when the shape parameter
is unknown but the proportion of accrued subjects at a certain time is known.
{cmd:aprob()} is often used in conjunction with {cmd:aptime()} or {cmd:atime()}.
This option may not be specified with {cmd:ashape()} or {cmd:loghazard} and
requires specifying a nonzero accrual period in {cmd:aperiod()}.

{phang}
{opth aptime(numlist)} specifies the proportion of the accrual period,
{it:t}*/{it:r}, by which the proportion of subjects specified in {cmd:aprob()}
is expected to be accrued according to the truncated exponential distribution.
The default is {cmd:aptime(0.5)}.  This option may not be combined with
{cmd:atime()}, {cmd:ashape()}, or {cmd:loghazard} and requires specifying a
nonzero accrual period in {cmd:aperiod()}.

{phang}
{opth atime(numlist)} specifies the time point {it:t}*, reference accrual
time, by which the proportion of subjects specified in {cmd:aprob()} is
expected to be accrued according to the truncated exponential distribution.
The default value is 0.5 x {it:r}.  This option may not be combined with
{cmd:aptime()}, {cmd:ashape()}, or {cmd:loghazard} and requires specifying a
nonzero accrual period in {cmd:aperiod()}.  The value in {cmd:atime()} may not
exceed the value in {cmd:aperiod()}.

{phang}
{opth ashape(numlist)} specifies the shape, gamma, of the
truncated exponential accrual distribution.  The default is {cmd:ashape(0)},
meaning uniform accrual.  This option is not allowed in conjunction with
{cmd:loghazard} and requires specifying a nonzero accrual period in
{cmd:aperiod()}.

{phang}
{opth lossprob(numlist)} specifies the proportion of subjects lost to
follow-up by time {cmd:losstime()} in the control and the experimental groups.
The default is {cmd:lossprob(0)}, meaning no losses to follow-up.  This option
requires specifying {cmd:aperiod()} or {cmd:fperiod()} and may not be combined
with {cmd:lossprob1()}, {cmd:lossprob2()}, {cmd:losshaz()}, {cmd:losshaz1()},
or {cmd:losshaz2()}.

{phang}
{opth lossprob1(numlist)} specifies the proportion of subjects lost to
follow-up by time {cmd:losstime()} in the control group.  The default is
{cmd:lossprob1(0)}, meaning no losses to follow-up in the control group.  This
option requires specifying {cmd:aperiod()} or {cmd:fperiod()} and may not be
combined with {cmd:lossprob()}, {cmd:losshaz()}, {cmd:losshaz1()}, or
{cmd:losshaz2()}.

{phang}
{opth lossprob2(numlist)} specifies the proportion of subjects lost to
follow-up by time {cmd:losstime()} in the experimental group.  The default is
{cmd:lossprob2(0)}, meaning no losses to follow-up in the experimental group.
This option requires specifying {cmd:aperiod()} or {cmd:fperiod()} and may not
be combined with {cmd:lossprob()}, {cmd:losshaz()}, {cmd:losshaz1()}, or
{cmd:losshaz2()}.

{phang}
{opth losstime(numlist)} specifies the time at which the proportion of
subjects specified in {cmd:lossprob()} or {cmd:lossprob1()} and
{cmd:lossprob2()} is lost to follow-up, also referred to as the reference loss
to follow-up time.  The default is {cmd:losstime(1)}.  This option requires
specifying {cmd:lossprob()}, {cmd:lossprob1()}, or {cmd:lossprob2()}.

{phang}
{opth losshaz(numlist)} specifies an exponential hazard rate of losses to
follow-up common to both the control and the experimental groups.  The default
is {cmd:losshaz(0)}, meaning no losses to follow-up.  This option requires
specifying {cmd:aperiod()} or {cmd:fperiod()} and may not be combined with
{cmd:lossprob()}, {cmd:lossprob1()}, {cmd:lossprob2()}, {cmd:losshaz1()}, or
{cmd:losshaz2()}.

{phang}
{opth losshaz1(numlist)} specifies an exponential hazard rate of losses to
follow-up, eta1, in the control group.  The default is {cmd:losshaz1(0)},
meaning no losses to follow-up in the control group.  This option requires
specifying {cmd:aperiod()} or {cmd:fperiod()} and may not be combined with
{cmd:lossprob()}, {cmd:lossprob1()}, {cmd:lossprob2()}, or {cmd:losshaz()}.

{phang}
{opth losshaz2(numlist)} specifies an exponential hazard rate of losses to
follow-up, eta2, in the experimental group.  The default is
{cmd:losshaz2(0)}, meaning no losses to follow-up in the experimental group.
This option requires specifying {cmd:aperiod()} or {cmd:fperiod()} and may not
be combined with {cmd:lossprob()}, {cmd:lossprob1()}, {cmd:lossprob2()}, or
{cmd:losshaz()}.

INCLUDE help pss_taboptsdes.ihlp

INCLUDE help pss_graphoptsdes.ihlp
Also see the {it:{mansection PSS-2 powerexponentialSyntaxcolumn:column}} table
in {bf:[PSS-2] power exponential} for a list of symbols used by the graphs.

{dlgtab:Reporting}

{phang}
{cmd:show} and {opt show(showspec)} specify to display additional output
containing the numbers of events, losses to follow-up, and event
probabilities.  If {cmd:show} is specified, group-specific numbers of events
and, in the presence of losses to follow-up, group-specific numbers of losses
to follow-up are displayed for the null and alternative hypotheses.  With the
table output, the numbers are displayed as additional columns.

{pmore}
{it:showspec} may contain any combination of {cmd:events}, {cmd:losses},
{cmd:eventprobs}, and {cmd:all}. {cmd:events} displays the
group-specific numbers of events under the null and alternative hypotheses.
{cmd:losses}, if present, displays group-specific numbers of losses under the
null and alternative hypotheses.  {cmd:eventprobs} displays group-specific
event probabilities under the null and alternative hypotheses.  {cmd:all}
displays all the above.

{pstd}
The following option is available with {cmd:power exponential} but is not
shown in the dialog box:

INCLUDE help pss_reportoptsdes.ihlp


{marker remarks}{...}
{title:Remarks: Using power exponential}

{pstd}
{cmd:power exponential} computes sample size or power for a test comparing two
exponential survivor functions.  All computations are performed for a
two-sided hypothesis test where, by default, the significance level is set to
0.05. You may change the significance level by specifying the {cmd:alpha()}
option. You can specify the {cmd:onesided} option to request a one-sided test.
By default, all computations assume a balanced- or equal-allocation design;
see {manlink PSS-4 Unbalanced designs} for a description of how to specify an
unbalanced design.

{pstd}
To compute a total sample size, you specify an effect size and, optionally,
the power of the test in the {cmd:power()} option. The default power is set to
0.8.  By default, the computed sample size is rounded up.  You can specify the
{cmd:nfractional} option to see the corresponding fractional sample size; see
{mansection PSS-4 UnbalanceddesignsRemarksandexamplesFractionalsamplesizes:{it:Fractional sample sizes}}
in {bf:[PSS-4] Unbalanced designs} for an example.  The {cmd:nfractional}
option is allowed only for sample-size determination.

{pstd}
To compute power, you must specify the total sample size in the {cmd:n()}
option and an effect size.

{pstd}
An effect size may be specified as a hazard ratio in option {cmd:hratio()},
as a log hazard-ratio in option {cmd:lnhratio()}, or as a difference
between hazard rates in option {cmd:hdifference()}.  By default, a hazard
ratio of 0.5 is assumed.  For a fixed-duration study, the control-group hazard
rate {it:h1} or the control-group survival probability {it:s1} must
also be specified.  See
{mansection PSS-2 powerexponentialRemarksandexamplessub1:{it:Alternative ways of specifying effect}}
in {bf:[PSS-2] power exponential} for details.

{pstd}
Instead of the total sample size {cmd:n()}, you can specify individual group
sizes in {cmd:n1()} and {cmd:n2()} or specify one of the group sizes and
{cmd:nratio()} when computing power or effect size.  See
{mansection PSS-4 UnbalanceddesignsRemarksandexamplesTwosamples:{it:Two samples}}
in {bf:[PSS-4] Unbalanced designs} for more details.

{pstd}
If the {cmd:time()} option is specified, the command's input parameters are the
values of survival probabilities in the control (or the less favorable) group,
{it:S1(t)}, and in the experimental group, {it:S2(t)}, at a fixed time, {it:t}
(reference survival time), specified in {cmd:time()}, given as {it:s1} and
{it:s2}, respectively.  Otherwise, the input parameters are assumed to be
the values of the hazard rates in the control group, lambda1, and in the
experimental group, lambda2, given as {it:h1} and {it:h2},
respectively.  If survival probabilities are specified, they are converted to
hazard rates by using the formula for the exponential survivor function and
the value of time {it:t} in {cmd:t()}.

{pstd}
By default, the estimates of sample sizes or power for the test of the
difference between hazards are reported.  This may be changed to the test
versus the difference between log hazards by using the {cmd:loghazard} option.
The default conditional approach may be replaced with the unconditional
approach by using {cmd:unconditional}; see 
{mansection PSS-2 powerexponentialRemarksandexamplesTheconditionalversusunconditionalapproaches:{it:The conditional versus unconditional approaches}}
in {bf:[PSS-2] power exponential}.

{pstd}
If the duration of a study ({it:T}) in option {cmd:studytime}, the length of a
follow-up period ({it:f}) in option {cmd:fperiod()}, or the length of an accrual
period ({it:r}) in option {cmd:aperiod()} is not specified, then the study is
assumed to continue until all subjects experience an event (failure),
regardless of how much time is required.  If only {cmd:studytime()} is
specified or only {cmd:fperiod()} is specified, the length of the accrual
period is assumed to be zero and the follow-up period equals the duration of
the study.  If only {cmd:aperiod()} is specified, the length of the follow-up
is assumed to be zero and the duration of the study equals the length of the
accrual period (continuous accrual until the end of the study).  If either
{cmd:aperiod()} or {cmd:fperiod()} is specified in a combination with
{cmd:studytime()}, the other one is computed using the relationship
{it:T}={it:r}+{it:f}.  If either option is supplied without {cmd:studytime()},
a fixed-duration study of length {it:T}={it:r}+{it:f} is assumed.

{pstd}
If an accrual period of length {it:r} is specified in the {cmd:aperiod()}
option, uniform accrual over the period [0, {it:r}] is assumed.  The accrual
distribution may be changed to truncated exponential when the shape parameter
is specified in {cmd:ashape()}.  The combination of the {cmd:aprob()} and
{cmd:aptime()} (or {cmd:atime()}) options may be used in place of the
{cmd:ashape()} option to request the desired shape of the truncated
exponential accrual.  For examples, see
{mansection PSS-2 powerexponentialRemarksandexamplesNonuniformaccrual:{it:Nonuniform accrual}}
in {bf:[PSS-2] power exponential}.

{pstd}
To take into account exponential losses to follow-up, the {cmd:losshaz()} or
{cmd:lossprob()} and {cmd:losstime()} options may be used.  Instead of
specifying losses common to both groups, you can use options {cmd:losshaz1()}
and {cmd:losshaz2()} or {cmd:lossprob1()} and {cmd:lossprob2()} to specify
group-specific losses to follow-up. For examples, see
{mansection PSS-2 powerexponentialRemarksandexamplesExponentiallossestofollow-up:{it:Exponential losses to follow-up}}
in {bf:[PSS-2] power exponential}.


{marker examples}{...}
{title:Examples}

    {title:Examples: Computing sample size}

{pstd}
Compute required sample size to detect an experimental-group hazard rate of 0.2 
when the control-group hazard rate is 0.1; assume a two-sided hypothesis test 
with a 5% significance level, a desired power of 80%, and an equal number of
observations in each group (the defaults)

{phang2}{cmd:. power exponential 0.1 0.2}

{pstd}
Same as above, except using a test based on the log-hazard difference

{phang2}{cmd:. power exponential 0.1 0.2, loghazard}

{pstd}
Same as above, except specifying the hazard rate in the control group and 
the hazard ratio

{phang2}{cmd:. power exponential 0.1, hratio(2) loghazard}

{pstd}
Same as above, except specifying survival probabilities in the control and 
experimental group at time 2

{phang2}{cmd:. power exponential 0.8187 0.6703, time(2) loghazard}

{pstd}
Compute required number of subjects assuming a 5-year follow-up period, using a 
one-sided 5% test

{phang2}{cmd:. power exponential 0.1 0.2, fperiod(5) onesided}

{pstd}
Compute required sample size with 2-year accrual period and 3-year follow-up 
period, assuming an exponential accrual distribution with a shape 
parameter of -1

{phang2}{cmd:. power exponential 0.1 0.2, aperiod(2) ashape(-1) fperiod(3)}

    {title:Examples: Computing power}

{pstd}
Continuing with the same example, we believe we can recruit only 100 subjects in
the control group and 50 in the experimental group. We investigate 
what power the test will have in this case.

{phang2}{cmd:. power exponential 0.1 0.2, n1(100) n2(50) aperiod(2) ashape(-1) fperiod(3)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:power exponential} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(alpha)}}significance level{p_end}
{synopt:{cmd:r(power)}}power{p_end}
{synopt:{cmd:r(beta)}}probability of a type II error{p_end}
{synopt:{cmd:r(delta)}}effect size{p_end}
{synopt:{cmd:r(N)}}total sample size{p_end}
{synopt:{cmd:r(N_a)}}actual sample size{p_end}
{synopt:{cmd:r(N1)}}sample size of the control group{p_end}
{synopt:{cmd:r(N2)}}sample size of the experimental group{p_end}
{synopt:{cmd:r(nratio)}}ratio of sample sizes, {cmd:N2/N1}{p_end}
{synopt:{cmd:r(nratio_a)}}actual ratio of sample sizes{p_end}
{synopt:{cmd:r(nfractional)}}{cmd:1} if {cmd:nfractional} is specified, {cmd:0} otherwise{p_end}
{synopt:{cmd:r(onesided)}}{cmd:1} for a one-sided test; {cmd:0}
	otherwise{p_end}
{synopt:{cmd:r(hratio)}}hazard ratio{p_end}
{synopt:{cmd:r(lnhratio)}}log hazard-ratio{p_end}
{synopt:{cmd:r(hdiff)}}difference between hazard rates{p_end}
{synopt:{cmd:r(h1)}}hazard in the control group (if specified){p_end}
{synopt:{cmd:r(h2)}}hazard in the experimental group{p_end}
{synopt:{cmd:r(s1)}}survival probability in the control group (if specified){p_end}
{synopt:{cmd:r(s2)}}survival probability in the experimental group (if specified){p_end}
{synopt:{cmd:r(time)}}reference survival time (if {cmd:time()} is specified){p_end}
{synopt:{cmd:r(aperiod)}}length of the accrual period (if specified){p_end}
{synopt:{cmd:r(fperiod)}}length of the follow-up period (if specified){p_end}
{synopt:{cmd:r(studytime)}}duration of the study (if specified){p_end}
{synopt:{cmd:r(ashape)}}shape parameter (if {cmd:aperiod()} is specified){p_end}
{synopt:{cmd:r(aprob)}}shape parameter (if {cmd:aprob()} is specified){p_end}
{synopt:{cmd:r(aptime)}}proportion of accrual period (if {cmd:aptime()} is specified){p_end}
{synopt:{cmd:r(atime)}}reference accrual time (if {cmd:atime()} is specified){p_end}
{synopt:{cmd:r(losshaz)}}loss hazard rate in both groups (if specified){p_end}
{synopt:{cmd:r(losshaz1)}}loss hazard in the control group (if specified){p_end}
{synopt:{cmd:r(losshaz2)}}loss hazard in the experimental group (if specified){p_end}
{synopt:{cmd:r(lossprob)}}proportions of subjects lost to follow-up in both
groups (if {cmd:lossprob()} is specified){p_end}
{synopt:{cmd:r(losstime)}}reference loss to follow-up time (if {cmd:losstime()} is specified){p_end}
{synopt:{cmd:r(unconditional)}}{cmd:1} if {cmd:unconditional} is specified,
        {cmd:0} otherwise{p_end}
INCLUDE help pss_rrestab_sc.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(type)}}{cmd:test}{p_end}
{synopt:{cmd:r(method)}}{cmd:exponential}{p_end}
{synopt:{cmd:r(test)}}{cmd:hazard difference} or {cmd:log-hazard difference}{p_end}
{synopt:{cmd:r(accrual)}}{cmd:uniform} or {cmd:exponential}{p_end}
{synopt:{cmd:r(effect)}}{cmd:hratio}, {cmd:lnhratio}, {cmd:hdifference}, or
{cmd:lnhdifference}{p_end}
INCLUDE help pss_rrestab_mac.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
INCLUDE help pss_rrestab_mat.ihlp
{synopt:{cmd:r(Pr_vec)}}1x4 matrix of probabilities of an event (when computed){p_end}
{synopt:{cmd:r(Ea_vec)}}1x3 matrix of expected number of events under the alternative (when computed){p_end}
{synopt:{cmd:r(E0_vec)}}1x3 matrix of expected number of events under the null (when computed){p_end}
{synopt:{cmd:r(La_vec)}}1x3 matrix of expected number of losses under the alternative (when computed){p_end}
{synopt:{cmd:r(L0_vec)}}1x3 matrix of expected number of losses under the null (when computed){p_end}
{p2colreset}{...}
