{smcl}
{* *! version 1.1.10  18apr2019}{...}
{viewerdialog power "dialog power_logrank"}{...}
{vieweralsosee "[PSS-2] power logrank" "mansection PSS-2 powerlogrank"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power logrank, cluster" "help power_logrank_cluster"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power" "help power"}{...}
{vieweralsosee "[PSS-2] power cox" "help power cox"}{...}
{vieweralsosee "[PSS-2] power exponential" "help power exponential"}{...}
{vieweralsosee "[PSS-2] power, graph" "help power_optgraph"}{...}
{vieweralsosee "[PSS-2] power, table" "help power_opttable"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stcox" "help stcox"}{...}
{vieweralsosee "[ST] sts test" "help sts test"}{...}
{viewerjumpto "Syntax" "power_logrank##syntax"}{...}
{viewerjumpto "Menu" "power_logrank##menu"}{...}
{viewerjumpto "Description" "power_logrank##description"}{...}
{viewerjumpto "Links to PDF documentation" "power_logrank##linkspdf"}{...}
{viewerjumpto "Options" "power_logrank##options"}{...}
{viewerjumpto "Remarks: Using power logrank" "power_logrank##remarks"}{...}
{viewerjumpto "Examples" "power_logrank##examples"}{...}
{viewerjumpto "Stored results""power_logrank##results"}{...}
{viewerjumpto "References""power_logrank##references"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[PSS-2] power logrank} {hline 2}}Power analysis for the 
log-rank test{p_end}
{p2col:}({mansection PSS-2 powerlogrank:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Compute sample size

{p 8 20 2}
{opt power} {opt log:rank} [{it:surv1} [{it:surv2}]]
[{cmd:,} {opth p:ower(numlist)} 
{it:{help power_logrank##synoptions:options}}] 


{phang}
Compute power 

{p 8 20 2}
{opt power} {opt log:rank} [{it:surv1} [{it:surv2}]]{cmd:,}
{opth n(numlist)}
[{it:{help power_logrank##synoptions:options}}]


{phang}
Compute effect size

{p 8 20 2}
{opt power} {opt log:rank} [{it:surv1}]{cmd:,}
{opth n(numlist)} {opth p:ower(numlist)}
[{it:{help power_logrank##synoptions:options}}]


{phang}
where
{it:surv1} is the survival probability in the control (reference) group at
the end of the study {it:t*} and
{it:surv2} is the survival probability in the experimental (comparison)
group at the end of the study {it:t*}.
{it:surv1} and {it:surv2} may each be specified either as one 
number or as a list of values in parentheses (see {help numlist}).


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
{p2coldent:* {opth n(numlist)}}total sample size; required to compute power or
effect size{p_end}
{p2coldent:* {opth n1(numlist)}}sample size of the control group{p_end}
{p2coldent:* {opth n2(numlist)}}sample size of the experimental group{p_end}
{p2coldent:* {opth nrat:io(numlist)}}ratio of sample sizes, {cmd:N2/N1};
default is {cmd:nratio(1)}, meaning equal group sizes{p_end}
{synopt:{opt nfrac:tional}}allow fractional sample sizes{p_end}
{p2coldent:* {opth hr:atio(numlist)}}hazard ratio
   of the experimental to the control group; default is
   {cmd:hratio(0.5)}{p_end}
{p2coldent:* {opth lnhr:atio(numlist)}}log hazard-ratio
   of the experimental to the control group{p_end}
{synopt:{opt sch:oenfeld}}use the formula based on the log hazard-ratio in
calculations; default is to use the formula based on the hazard ratio{p_end}
{synopt:{cmdab:effect(}{it:{help power_cox##effect:effect}}{cmd:)}}specify the
type of effect to display; default is method-specific{p_end}
INCLUDE help pss_testmainopts2.ihlp

{syntab:Censoring}
{synopt:{cmdab:simp:son(}{it:# # #}|{it:matname}{cmd:)}}survival probabilities
in the control group at three specific time points to compute the probability
of an event (failure), using Simpson's rule under uniform accrual{p_end}
{synopt:{cmd:st1(}{it:{help varname:varname_s varname_t}}{cmd:)}}variables
{it:varname_s}, containing survival probabilities in the control group, and
{it:varname_t}, containing respective time points, to compute the probability
of an event (failure), using numerical integration under uniform accrual{p_end}
{p2coldent:* {opth wdp:rob(numlist)}}proportion of subjects anticipated to
withdraw from the study; default is {cmd:wdprob(0)}{p_end}

{syntab:Table}
{synopt :[{cmdab:no:}]{cmdab:tab:le}[{cmd:(}{it:{help power_logrank##tablespec:tablespec}}{cmd:)}]}suppress table or display results as a table; see
{manhelp power_opttable PSS-2:power, table}{p_end}
{synopt :{cmdab:sav:ing(}{it:{help filename}}[{cmd:, replace}]{cmd:)}}save the
table data to {it:filename}; use {cmd:replace} to overwrite existing
{it:filename}{p_end}

INCLUDE help pss_graphopts.ihlp

{syntab:Iteration}
{synopt: {opt init(#)}}initial value for effect size{p_end}
INCLUDE help pss_iteropts.ihlp

{synopt: {opt cluster}}perform computations for a CRD; see
    {manhelp power_logrank_cluster PSS-2:power logrank, cluster}{p_end}
INCLUDE help pss_reportopts.ihlp
{synoptline}
{p2colreset}{...}
INCLUDE help pss_numlist.ihlp
{p 4 6 2}{cmd:cluster} and {cmd:notitle} do not appear in the dialog box.{p_end}


{synoptset 17}{...}
{marker effect}{...}
{synopthdr :effect}
{synoptline}
{synopt:{opt hr:atio}}hazard ratio{p_end}
{synopt:{opt lnhr:atio}}log hazard-ratio{p_end}
{synoptline}


{marker tablespec}{...}
{pstd}
where {it:tablespec} is

{p 16 16 2}
{it:{help power_logrank##column:column}}[{cmd::}{it:label}]
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
{synopt :{opt E}}total number of events (failures){p_end}
{synopt :{opt hratio}}hazard ratio{p_end}
{synopt :{opt lnhratio}}log hazard-ratio{p_end}
{synopt :{opt s1}}survival probability in the control group{p_end}
{synopt :{opt s2}}survival probability in the experimental group{p_end}
{synopt :{opt Pr_E}}overall probability of an event (failure){p_end}
{synopt :{opt Pr_w}}probability of withdrawals{p_end}
{synopt :{opt target}}target parameter; {cmd:hratio} or {cmd:lnhratio}{p_end}
{synopt :{opt _all}}display all supported columns{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}Column {cmd:beta} is shown in the default table in place of column
{cmd:power} if specified.{p_end}
{p 4 6 2}Column {cmd:lnhratio} is shown in the default table in place of
column {cmd:hratio} if specified.{p_end}
{p 4 6 2}Columns {cmd:s1} and {cmd:s2} are available only when
specified.{p_end}
{p 4 6 2}Columns {cmd:nratio} and {cmd:Pr_w} are shown in the default table if
specified.


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
{cmd:power logrank} computes sample size, power, or effect size for survival
analysis comparing survivor functions in two groups by using the log-rank
test.  The results can be obtained using the Freedman or Schoenfeld
approaches.  Effect size can be expressed as a hazard ratio or as a log
hazard-ratio.  The command supports unbalanced designs, and provides options
to account for administrative censoring, uniform accrual, and withdrawal of
subjects from the study.  For power and sample-size analysis in a cluster
randomized design, see
{manhelp power_logrank_cluster PSS-2:power logrank, cluster}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-2 powerlogrankQuickstart:Quick start}

        {mansection PSS-2 powerlogrankRemarksandexamples:Remarks and examples}

        {mansection PSS-2 powerlogrankMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{cmd:alpha()}, {cmd:power()}, {cmd:beta()}, {cmd:n()}, {cmd:n1()}, {cmd:n2()},
{cmd:nratio()}, {cmd:nfractional}; see {manhelp power##mainopts PSS-2: power}.

{phang}
{opth hratio(numlist)} specifies the hazard ratio (effect size) of the
experimental group to the control group.  The default is {cmd:hratio(0.5)}.
This value typically defines the clinically significant improvement of the
experimental procedure over the control procedure desired to be detected by
the log-rank test with a certain power.

{pmore}
You can specify an effect size either as a hazard ratio in {cmd:hratio()} or
as a log hazard-ratio in {cmd:lnhratio()}. The default is {cmd:hratio(0.5)}.
If both arguments {it:surv1} and {it:surv2} are specified, {cmd:hratio()} is
not allowed and the hazard ratio is instead computed as
ln({it:surv2})/ln({it:surv1}).

{pmore}
This option is not allowed with the effect-size determination and may not be
combined with {cmd:lnhratio()}.

{phang}
{opth lnhratio(numlist)} specifies the log hazard-ratio (effect size) of the
experimental group to the control group.  This value typically defines the
clinically significant improvement of the experimental procedure over the
control procedure desired to be detected by the log-rank test with a certain
power.

{pmore}
You can specify an effect size either as a hazard ratio in {cmd:hratio()} or
as a log hazard-ratio in {cmd:lnhratio()}. The default is {cmd:hratio(0.5)}.
If both arguments {it:surv1} and {it:surv2} are specified, {cmd:lnhratio()} is
not allowed and the log hazard-ratio is computed as
ln{c -(}ln({it:surv2})/ln({it:surv1}){c )-}.

{pmore}
This option is not allowed with the effect-size determination and may not be
combined with {cmd:hratio()}.

{phang}
{cmd:schoenfeld} requests calculations using the formula based on the
log hazard-ratio, according to
{help power logrank##S1981:Schoenfeld (1981)}.  The default is to use the
formula based on the hazard ratio, according to
{help power logrank##F1982:Freedman (1982)}.

{phang}
{opt effect(effect)} specifies the type of the effect size to be reported in
the output as {cmd:delta}.  {it:effect} is one of {cmd:hratio} or
{cmd:lnhratio}.  By default, the effect size {cmd:delta} is a hazard ratio,
{cmd:effect(hratio)}, for a hazard-ratio test and a log hazard-ratio,
{cmd:effect(lnhratio)}, for a log hazard-ratio test (when {cmd:schoenfeld} is
specified).  

{phang}
{cmd:direction()}, {cmd:onesided}, {cmd:parallel}; see 
{manhelp power##mainopts PSS-2: power}.
{cmd:direction(lower)} is the default.

{dlgtab:Censoring}

{phang}
{cmd:simpson(}{it:# # #}|{it:matname}{cmd:)} specifies
survival probabilities in the control group at three specific time points
to compute the probability of an event (failure) using Simpson's rule
under the assumption of uniform accrual.  Either the actual values or a
1 x 3 matrix, {it:matname}, containing these values can be
specified.  By default, the probability of an event is approximated as an
average of the failure probabilities 1-s_1 and 1-s_2; see
{mansection PSS-2 powerlogrankMethodsandformulas:{it:Methods and formulas}}
in {bf:[PSS-2] power logrank}.  {cmd:simpson()} may not be combined with
{cmd:st1()} and may not be used if command argument {it:surv1} or {it:surv2}
is specified.  This option is not allowed with effect-size computation.

{phang}
{cmd:st1(}{it:{help varname:varname_s varname_t}}{cmd:)} specifies variables
{it:varname_s}, containing survival probabilities in the control group, and
{it:varname_t}, containing respective time points, to compute the probability
of an event (failure) using numerical integration under the assumption of
uniform accrual; see {manhelp dydx R}.  The minimum and the maximum values of
{it:varname_t} must be the length of the follow-up period and the duration of
the study, respectively.  By default, the probability of an event is
approximated as an average of the failure probabilities 1-s_1 and 1-s_2; see
{mansection PSS-2 powerlogrankMethodsandformulas:{it:Methods and formulas}} in
{bf:[PSS-2] power logrank}.  {cmd:st1()} may not be combined with
{cmd:simpson()} and may not be used if command argument {it:surv1} or
{it:surv2} is specified.  This option is not allowed with effect-size
computation.

{phang}
{opth wdprob(numlist)} specifies the proportion of subjects anticipated to
withdraw from the study.  The default is {cmd:wdprob(0)}.  {cmd:wdprob()} is
allowed only with sample-size computation.

INCLUDE help pss_taboptsdes.ihlp

INCLUDE help pss_graphoptsdes.ihlp
Also see the {mansection PSS-2 powerlogrankSyntaxcolumn:column} table in
{bf:[PSS-2] power logrank} for a list of symbols used by the graphs.

{dlgtab:Iteration}

{phang}
{opt init(#)} specifies an initial value for the estimated hazard ratio
or, if {cmd:schoenfeld} is specified, for the estimated log hazard-ratio
during the effect-size determination.

INCLUDE help pss_iteroptsdes.ihlp

{pstd}
The following options are available with {cmd:power logrank} but are not
shown in the dialog box:

{phang}
{opt cluster}; see {manhelp power_logrank_cluster PSS-2:power logrank, cluster}.

INCLUDE help pss_reportoptsdes.ihlp


{marker remarks}{...}
{title:Remarks: Using power logrank}

{pstd}
{cmd:power logrank} computes sample size, power, or effect size for the
log-rank test comparing the survivor functions in two groups.  All
computations are performed for a two-sided hypothesis test where, by default,
the significance level is set to 0.05. You may change the significance level
by specifying the {cmd:alpha()} option. You can specify the {cmd:onesided}
option to request a one-sided test.  By default, all computations assume a
balanced- or equal-allocation design; see {manlink PSS-4 Unbalanced designs}
for a description of how to specify an unbalanced design.

{pstd}
To compute a total sample size, you specify an effect size and optionally
power of the test in the {cmd:power()} option. The default power is set to
0.8.  By default, the computed sample size is rounded up.  You can specify the
{cmd:nfractional} option to see the corresponding fractional sample size; see
{mansection PSS-4 UnbalanceddesignsRemarksandexamplesFractionalsamplesizes:{it:Fractional sample sizes}}
in {bf:[PSS-4] Unbalanced designs} for an example.  The {cmd:nfractional}
option is allowed only for sample-size determination.

{pstd}
To compute power, you must specify the total sample size in the {cmd:n()}
option and an effect size.

{pstd}
An effect size may be specified either as a hazard ratio supplied in the
{cmd:hratio()} option or as a log hazard-ratio supplied in the
{cmd:lnhratio()} option.  If neither is specified, a hazard ratio of 0.5 is
assumed.  

{pstd}
To compute an effect size, which may be expressed either as a hazard ratio or
as a log hazard-ratio, you must specify the total sample size in the {cmd:n()}
option; the power in the {cmd:power()} option; and, optionally, the direction
of the effect.  The direction is lower by default, {cmd:direction(lower)},
which means that the target hazard ratio is assumed to be less than one or
that target log hazard-ratio is negative.  In other words, the experimental
treatment is presumed to be an improvement over the control treatment.  If you
want to change the direction to upper, corresponding to the target hazard
ratio being greater than one, use {cmd:direction(upper)}.

{pstd}
Instead of the total sample size {cmd:n()}, you can specify individual group
sizes in {cmd:n1()} and {cmd:n2()}, or specify one of the group sizes and
{cmd:nratio()} when computing power or effect size.  Also see
{mansection PSS-4 UnbalanceddesignsRemarksandexamplesTwosamples:{it:Two samples}}
in {bf:[PSS-4] Unbalanced designs} for more details.

{pstd}
As we mentioned earlier, the effect size for {cmd:power logrank} may be
expressed as a hazard ratio or as a log hazard-ratio.  By default, the effect
size, which is labeled as {cmd:delta} in the output, corresponds to the hazard
ratio for the Freedman method and to the log hazard-ratio for the Schoenfeld
method.  You can change this by specifying the {cmd:effect()} option:
{cmd:effect(hratio)} (the default) reports the hazard ratio and
{cmd:effect(lnhratio)} reports the log hazard-ratio.  

{pstd}
By default, all computations assume no censoring.  In the presence of
{help pss glossary##administrative_censoring:administrative censoring},
you must specify a survival probability at the end of the study in the control
group as the first command argument.  You can also specify a survival
probability at the end of the study in the experimental group as the second
command argument.  Otherwise, it will be computed using the specified hazard
ratio or log hazard-ratio and the control-group survival probability.  To
accommodate an 
{help pss glossary##accrual_period:accrual period} 
under the assumption of uniform accrual, 
survival information may instead be supplied in option {cmd:simpson()} or in
option {cmd:st1()}; see 
{mansection PSS-2 powerlogrankRemarksandexamplesIncludinginformationaboutsubjectaccrual:{it:Including information about subject accrual}} 
in {bf:[PSS-2] power logrank} for details.

{pstd}
When computing sample size, you can adjust for withdrawal of subjects from the
study by specifying the anticipated proportion of withdrawals in the
{cmd:wdprob()} option.

{pstd}
By default, {cmd:power logrank} performs computations for a hazard-ratio test.
Use the {cmd:schoenfeld} option to request computations for a log-hazard-ratio
test.

{pstd}
In the presence of censoring, effect-size determination requires iteration.
The default initial value of the estimated hazard ratio or, if
{cmd:schoenfeld} is specified, of log hazard-ratio is obtained based on the
formula assuming no censoring.  This value may be changed by specifying the
{cmd:init()} option. See {manhelp power PSS-2} for the descriptions of other options
that control the iteration procedure.


{marker examples}{...}
{title:Examples}

    {title:Examples: Computing sample size}

{pstd}
Compute number of failures required to detect a default hazard ratio of 0.5
using Freedman method; assume a two-sided hypothesis test with a 5%
significance level, a desired power of 80%, and an equal number of
observations in each group (the defaults)

{phang2}{cmd:. power logrank}

{pstd}
Same as above, except using Schoenfeld method

{phang2}{cmd:. power logrank, schoenfeld}

{pstd}
Compute sample size required in the presence of censoring to detect a change 
in survival from 50% to 60%, using a one-sided test

{phang2}{cmd:. power logrank 0.5 0.6, onesided}

{pstd}
Same as above, except specifying the survival probability in the control group 
and the hazard ratio

{phang2}{cmd:. power logrank 0.5, hratio(0.7370) onesided}

{pstd}
Same as above, assuming the experimental-group sample size will be twice the 
control-group size

{phang2}{cmd:. power logrank 0.5, nratio(2) hratio(0.7370) onesided}

    {title:Examples: Computing power}

{pstd}
Continuing with the same example, we believe we can recruit only 50 subjects in
the control group and 100 in the experimental group. We investigate 
what power the test will have in this case.

{phang2}{cmd:. power logrank 0.5, n(150) nratio(2) hratio(0.7370) onesided}

    {title:Examples:  Minimum detectable hazard ratio}

{pstd}
Continuing with the same example, determine minimal detectable hazard ratio in 
the previous example with 90% power for a sample size of 150; by default, 
the target hazard ratio is assumed to be less than one

{phang2}{cmd:. power logrank, power(0.9) n(150) nratio(2) onesided}

    {title:Examples:  Including information about subject accrual}

{pstd}
Continuing with the same example, suppose that the subjects are to be entered
into the study uniformly over a period of 18 months and then followed for 24
months.  From the Kaplan-Meier estimate of the survivor function available for
the control group, the survival probabilities at times f = 24, 0.5r + f = 33,
and T = 42 months are 0.70, 0.5, and 0.45, respectively.  Let's use the
Simpson's rule to compute the probability of a failure.  We will also use the
Schoenfeld method.

{phang2}{cmd:. power logrank, schoenfeld simpson(0.7 0.5 0.45)}

{pstd}
Sometimes, we may have estimates of the survival probabilities for the control
group at many time points.  In that case, we can use numerical integration to
estimate the overall probability of a failure instead of the Simpson's rule.
This can be done by using option {cmd:st1()}.  As an illustration, continuing
with the above example, suppose that our survival estimates and times are
stored in variables {cmd:surv} and {cmd:time}.

        {cmd:. clear}
        {cmd:. set obs 3}
        {cmd:. input surv time}
 
                 surv       time
          1.  {cmd:.7  24}
          2.  {cmd:.5  33}
          3.  {cmd:.45 42}

{pstd}
We specify these variable in option {cmd:st1()} and obtain the same results as
using the Simpson's rule.

{phang2}{cmd:. power logrank, schoenfeld st1(surv time)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:power logrank} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(alpha)}}significance level{p_end}
{synopt:{cmd:r(power)}}power{p_end}
{synopt:{cmd:r(beta)}}probability of a type II error{p_end}
{synopt:{cmd:r(delta)}}effect size{p_end}
{synopt:{cmd:r(N)}}total sample size{p_end}
{synopt:{cmd:r(N_a)}}actual sample size{p_end}
{synopt:{cmd:r(N1)}}sample size for the control group{p_end}
{synopt:{cmd:r(N2)}}sample size for the experimental group{p_end}
{synopt:{cmd:r(nratio)}}ratio of sample sizes, {cmd:N2/N1}{p_end}
{synopt:{cmd:r(nratio_a)}}actual ratio of sample sizes{p_end}
{synopt:{cmd:r(nfractional)}}{cmd:1} if {cmd:nfractional} is specified, {cmd:0} otherwise{p_end}
{synopt:{cmd:r(onesided)}}{cmd:1} for a one-sided test, {cmd:0} otherwise{p_end}
{synopt:{cmd:r(E)}}total number of events (failure){p_end}
{synopt:{cmd:r(hratio)}}hazard ratio{p_end}
{synopt:{cmd:r(lnhratio)}}log hazard-ratio{p_end}
{synopt:{cmd:r(s1)}}survival probability in the control group (if
specified){p_end}
{synopt:{cmd:r(s2)}}survival probability in the experimental group (if
specified){p_end}
{synopt:{cmd:r(Pr_E)}}probability of an event (failure){p_end}
{synopt:{cmd:r(Pr_w)}}probability of withdrawals{p_end}
{synopt:{cmd:r(t_min)}}minimum time (if {cmd:st1()} is specified){p_end}
{synopt:{cmd:r(t_max)}}maximum time (if {cmd:st1()} is specified){p_end}
INCLUDE help pss_rrestab_sc.ihlp
{synopt:{cmd:r(init)}}initial value for hazard ratio or log hazard-ratio{p_end}
INCLUDE help pss_rresiter_sc.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(type)}}{cmd:test}{p_end}
{synopt:{cmd:r(method)}}{cmd:logrank}{p_end}
{synopt:{cmd:r(test)}}{cmd:Freedman} or {cmd:Schoenfeld}{p_end}
{synopt:{cmd:r(effect)}}{cmd:hratio} or {cmd:lnhratio}{p_end}
{synopt:{cmd:r(survvar)}}name of the variable containing survival
probabilities (if {cmd:st1()} is specified){p_end}
{synopt:{cmd:r(timevar)}}name of the variable containing time points (if
{cmd:st1()} is specified){p_end}
{synopt:{cmd:r(direction)}}{cmd:lower} or {cmd:upper}{p_end}
INCLUDE help pss_rrestab_mac.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
INCLUDE help pss_rrestab_mat.ihlp
{synopt:{cmd:r(simpmat)}}control-group survival probabilities (if
{cmd:simpson()} is specified){p_end}


{marker references}{...}
{title:References}

{marker S1981}{...}
{phang}
Schoenfeld, D. A. 1981.  The asymptotic properties of nonparametric tests for
comparing survival distributions.  {it:Biometrika} 68: 316-319.

{marker F1982}{...}
{phang}
Freedman, L. S. 1982.  Tables of the number of patients required in clinical
trials using the logrank test.  {it:Statistics in Medicine} 1: 121-129.
{p_end}
