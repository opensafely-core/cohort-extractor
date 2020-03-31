{smcl}
{* *! version 1.0.19  27feb2019}{...}
{viewerdialog "discordant proportions" "dialog power_pairedprop_discord"}{...}
{viewerdialog "marginal proportions" "dialog power_pairedprop_marginal"}{...}
{vieweralsosee "[PSS-2] power pairedproportions" "mansection PSS-2 powerpairedproportions"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-2] power" "help power"}{...}
{vieweralsosee "[PSS-2] power, graph" "help power_optgraph"}{...}
{vieweralsosee "[PSS-2] power, table" "help power_opttable"}{...}
{vieweralsosee "[PSS-5] Glossary" "help pss_glossary"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] Epitab" "help epitab"}{...}
{viewerjumpto "Syntax" "power_pairedproportions##syntax"}{...}
{viewerjumpto "Menu" "power_pairedproportions##menu"}{...}
{viewerjumpto "Description" "power_pairedproportions##description"}{...}
{viewerjumpto "Links to PDF documentation" "power_pairedproportions##linkspdf"}{...}
{viewerjumpto "Options" "power_pairedproportions##options"}{...}
{viewerjumpto "Remarks: Using power pairedproportions" "power_pairedproportions##remarks"}{...}
{viewerjumpto "Examples" "power_pairedproportions##examples"}{...}
{viewerjumpto "Stored results" "power_pairedproportions##stored_results"}{...}
{p2colset 1 36 38 2}{...}
{p2col:{bf:[PSS-2] power pairedproportions} {hline 2}}Power analysis for a
two-sample paired proportions test{p_end}
{p2col:}({mansection PSS-2 powerpairedproportions:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Compute sample size

{p 6 43 2}
Specify discordant proportions

{p 8 43 2}
{opt power} {opt pairedpr:oportions} {it:p12} {it:p21}
[{cmd:,} {opth p:ower(numlist)}
{it:{help power_pairedproportions##discordopts:discordopts}}]


{p 6 43 2}
Specify marginal proportions

{p 8 43 2}
{opt power} {opt pairedpr:oportions} {it:p1+} {it:p+1}{cmd:,}
{opth corr(numlist)} [{opth p:ower(numlist)}
{it:{help power_pairedproportions##margopts:margopts}}]



{phang}
Compute power

{p 6 43 2}
Specify discordant proportions

{p 8 43 2}
{opt power} {opt pairedpr:oportions} {it:p12} {it:p21}{cmd:,}
{opth n(numlist)} [{it:{help power_pairedproportions##discordopts:discordopts}}]


{p 6 43 2}
Specify marginal proportions

{p 8 43 2}
{opt power} {opt pairedpr:oportions} {it:p1+} {it:p+1}{cmd:,}
{opth corr(numlist)} {opth n(numlist)}
[{it:{help power_pairedproportions##margopts:margopts}}]



{phang}
Compute effect size and target discordant proportions

{p 8 43 2}
{opt power} {opt pairedpr:oportions}{cmd:,}
{opth n(numlist)} {opth p:ower(numlist)}
{opth prdis:cordant(numlist)}
[{it:{help power_pairedproportions##discordopts:discordopts}}]


{phang}
where {it:p12} is the probability of a success at occasion 1 and a failure at
occasion 2, and {it:p21} is the probability of a failure at occasion 1 and 
a success at occasion 2. Each represents the probability of a discordant pair.
{it:p1+} is the marginal probability of a success for occasion 1, and {it:p+1}
is the marginal probability of a success for occasion 2.  Each may be
specified either as one number or as a list of values in parentheses
(see {help numlist}).


{synoptset 30 tabbed}{...}
{marker discordopts}{...}
{synopthdr:discordopts}
{synoptline}
{syntab:Main}
INCLUDE help pss_testmainopts1.ihlp
{synopt: {opt nfrac:tional}}allow fractional sample size{p_end}
{p2coldent:* {opth prdis:cordant(numlist)}}sum of the discordant proportions,
{it: p12}+{it:p21}{p_end}
{p2coldent:* {opth sum(numlist)}}synonym for {cmd:prdiscordant()}{p_end}
{p2coldent:* {opth diff(numlist)}}difference between the discordant
proportions, {it: p21}-{it:p12}{p_end}
{p2coldent:* {opth ratio(numlist)}}ratio of the discordant proportions,
{it: p12}/{it:p21}{p_end}
{synopt: {cmd:effect({it:{help power_pairedproportions##syneffect:effect}})}}specify the type of effect to display; default is {cmd:effect(diff)}{p_end}
INCLUDE help pss_testmainopts3.ihlp

{syntab:Table}
{synopt :[{cmdab:no:}]{cmdab:tab:le}[{cmd:(}{it:{help power_onevariance##tablespec:tablespec}}{cmd:)}]}suppress table or display results as a table; see
{manhelp power_opttable PSS-2:power, table}{p_end}
{synopt :{cmdab:sav:ing(}{it:{help filename}}[{cmd:, replace}]{cmd:)}}save the
table data to {it:filename}; use {cmd:replace} to overwrite existing
{it:filename}{p_end}

INCLUDE help pss_graphopts.ihlp

{syntab:Iteration}
{synopt: {opt init(#)}}initial value for sample size or difference
between discordant proportions{p_end}
INCLUDE help pss_iteropts.ihlp

INCLUDE help pss_reportopts.ihlp
{synoptline}
{p2colreset}{...}
INCLUDE help pss_numlist.ihlp
{p 4 6 2}{cmd:notitle} does not appear in the dialog box.{p_end}


{synoptset 30 tabbed}{...}
{marker margopts}{...}
{synopthdr:margopts}
{synoptline}
{syntab:Main}
INCLUDE help pss_testmainopts1.ihlp
{synopt: {opt nfrac:tional}}allow fractional sample size{p_end}
{p2coldent:* {opth corr(numlist)}}correlation between the paired observations{p_end}
{p2coldent:* {opth diff(numlist)}}difference between the marginal proportions,
{it:p+1}-{it:p1+}{p_end}
{p2coldent:* {opth ratio(numlist)}}ratio of the marginal proportions,
{it:p+1}/{it:p1+}{p_end}
{p2coldent:* {opth rr:isk(numlist)}}relative risk, {it:p+1}/{it:p1+}{p_end}
{p2coldent:* {opth or:atio(numlist)}}odds ratio,
{c -(}{it:p+1}(1 - {it:p1+}){c )-}/{c -(}{it:p1+}(1 - {it:p+1}){c )-}{p_end}
{synopt: {opth effect:(power twoproportions##effectspec:effect)}}specify the
type of effect to display; default is {cmd:effect(diff)}{p_end}
INCLUDE help pss_testmainopts3.ihlp

{syntab:Table}
{synopt :[{cmdab:no:}]{cmdab:tab:le}[{cmd:(}{it:{help power_twoproportions##tablespec:tablespec}}{cmd:)}]}suppress table or display results as a table; see
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


{marker syneffect}{...}
{synoptset 30}{...}
{syntab:{it:effect}}
{synoptline}
{synopt: {cmd:diff}}difference between the discordant proportions,
{it:p21}-{it:p12}, or marginal proportions, {it:p+1}-{it:p1+}; the default{p_end}
{synopt: {cmd:ratio}}ratio of the discordant proportions, {it:p21}/{it:p12}, or
of the marginal proportions, {it:p+1}/{it:p1+}{p_end}
{synopt: {opt rr:isk}}relative risk, {it:p+1}/{it:p1+}; may only be specified with marginal proportions{p_end}
{synopt: {opt or:atio}}odds ratio, {c -(}{it:p+1}(1-{it:p1+}){c )-}/{c -(}{it:p1+}(1-{it:p+1}){c )-}; may only be specified with marginal proportions{p_end}
{synoptline}
{p2colreset}{...}

{marker tablespec}{...}
{pstd}
where {it:tablespec} is

{p 16 16 2}
{it:{help power_pairedproportions##column:column}}[{cmd::}{it:label}]
[{it:column}[{cmd::}{it:label}] [...]] [{cmd:,} {it:{help power_opttable##tableopts:tableopts}}]

{pstd}
{it:column} is one of the columns defined below,
and {it:label} is a column label (may contain quotes and compound quotes).

{synoptset 30}{...}
{marker column}{...}
{synopthdr :column}
{synoptline}
{synopt :{opt alpha}}significance level{p_end}
{synopt :{opt power}}power{p_end}
{synopt :{opt beta}}type II error probability{p_end}
{synopt :{opt N}}number of subjects{p_end}
{synopt :{opt delta}}effect size{p_end}
{synopt :{opt p12}}success-failure proportion{p_end}
{synopt :{opt p21}}failure-success proportion{p_end}
{synopt :{opt pmarg1}}success proportion in occasion 1{p_end}
{synopt :{opt pmarg2}}success proportion in occasion 2{p_end}
{synopt :{opt corr}}correlation between paired observations{p_end}
{synopt :{opt prdiscordant}}proportion of discordant pairs{p_end}
{synopt :{opt sum}}sum of discordant proportions{p_end}
{synopt :{opt diff}}difference between paired proportions{p_end}
{synopt :}difference between marginal proportions{p_end}
{synopt :{opt ratio}}ratio of discordant proportions{p_end}
{synopt :}ratio of marginal proportions{p_end}
{synopt :{opt rrisk}}relative risk for marginal proportions{p_end}
{synopt :{opt oratio}}odds ratio for marginal proportions{p_end}
{synopt :{opt target}}target parameter; synonym for {cmd:p12}{p_end}
{synopt :{opt _all}}display all supported columns{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}Column {cmd:beta} is shown in the default table in place of column
{cmd:power} if specified.{p_end}
{p 4 6 2}Columns {cmd:p12} and {cmd:p21} are shown in the default table if
discordant proportions are specified.{p_end}
{p 4 6 2}Columns {cmd:pmarg1}, {cmd:pmarg2}, and {cmd:corr} are shown in the
default table if marginal proportions are specified.{p_end}
{p 4 6 2}Columns {cmd:pmarg1}, {cmd:pmarg2}, {cmd:corr}, {cmd:rrisk}, and
{cmd:oratio} are available only if marginal proportions are specified.{p_end}
{p 4 6 2}Columns {cmd:diff}, {cmd:ratio}, {cmd:prdiscordant}, {cmd:sum},
{cmd:rrisk}, and {cmd:oratio} are shown in the default table if specified.


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
{cmd: power pairedproportions} computes sample size, power, or target
discordant proportions for a two-sample paired-proportions test, also known as
McNemar's test.  By default, it computes sample size for given power and the
values of the discordant or marginal proportions.  Alternatively, it can
compute power for given sample size and the values of the discordant or marginal
proportions, or it can compute the target discordant proportions for given
sample size and power.  Also see {cmd: power} for a general introduction to
the {manhelp power PSS-2} command using hypothesis tests.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-2 powerpairedproportionsQuickstart:Quick start}

        {mansection PSS-2 powerpairedproportionsRemarksandexamples:Remarks and examples}

        {mansection PSS-2 powerpairedproportionsMethodsandformulas:Methods and formulas}

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
{opth prdiscordant(numlist)} specifies the proportion of discordant pairs or
the sum of the discordant proportions, {it:p12}+{it:p21}. See
{mansection PSS-2 powerpairedproportionsRemarksandexamplessub1:{it:Alternative ways of specifying effect}} for details about the specification of this option.

{phang}
{opth sum(numlist)} is a synonym for {cmd:prdiscordant()}.  See
{mansection PSS-2 powerpairedproportionsRemarksandexamplessub1:{it:Alternative ways of specifying effect}} for details about the specification of
this option.

{phang}
{opth corr(numlist)} specifies the correlation between paired observations.
This option is required if marginal proportions are specified.

{phang}
{opth diff(numlist)} specifies the difference between the discordant
proportions, {it:p21} - {it:p12}, or the marginal proportions,
{it:p+1}-{it:p1+}. See
{mansection PSS-2 powerpairedproportionsRemarksandexamplessub1:{it:Alternative ways of specifying effect}} for details about the specification of
this option.

{phang}
{opth ratio(numlist)} specifies the ratio of the discordant proportions,
{it:p21}/{it:p12}, or the marginal proportions, {it:p+1}/{it:p1+}. See
{mansection PSS-2 powerpairedproportionsRemarksandexamplessub1:{it:Alternative ways of specifying effect}} for details about the specification of
this option.

{phang}
{opth rrisk(numlist)} specifies the relative risk of the marginal proportions,
{it:p+1}/{it:p1+}. See
{mansection PSS-2 powerpairedproportionsRemarksandexamplessub1:{it:Alternative ways of specifying effect}} for details about the
specification of this option.

{phang}
{opth oratio(numlist)} specifies the odds ratio of the marginal proportions,
{c -(}{it:p+1}(1-{it:p1+}){c )-}/{c -(}{it:p1+}(1-{it:p+1}){c )-}. See
{mansection PSS-2 powerpairedproportionsRemarksandexamplessub1:{it:Alternative ways of specifying effect}} for details about the
specification of this option.

{phang}
{opt effect(effect)} specifies the type of the effect size to be
reported in the output as {cmd:delta}.  {it:effect} is one of {cmd:diff} or
{cmd:ratio} for discordant proportions and one of {cmd:diff}, {cmd:ratio},
{opt rr:isk}, or {opt or:atio} for marginal proportions.
By default, the effect size {cmd:delta} is the difference between proportions.
If {cmd:diff()}, {cmd:ratio()}, {cmd:rrisk()}, or {cmd:oratio()} is specified,
the effect size {cmd:delta} will contain the effect corresponding to the
specified option.  For example, if {cmd:ratio()} is specified, {cmd:delta}
will contain the ratio of the proportions. See
{mansection PSS-2 powerpairedproportionsRemarksandexamplessub1:{it:Alternative ways of specifying effect}} for details about the specification of this option.

{phang}
{cmd:direction()}, {cmd:onesided}, {cmd:parallel}; see
{manhelp power##mainopts PSS-2:power}.

INCLUDE help pss_taboptsdes.ihlp

INCLUDE help pss_graphoptsdes.ihlp
Also see the {mansection PSS-2 powerpairedproportionsSyntaxcolumn:column} table
in {bf:[PSS-2] power pairedproportions} for a list of symbols used by the
graphs.

{dlgtab:Iteration}

{phang}
{opt init(#)} specifies the initial value for the estimated parameter.
The estimated parameter is sample size for sample-size determination or
the difference between the discordant proportions
for the effect-size determination.

INCLUDE help pss_iteroptsdes.ihlp

{pstd}
The following option is available with {cmd:power pairedproportions} but is not
shown in the dialog box:

INCLUDE help pss_reportoptsdes.ihlp


{marker remarks}{...}
{title:Remarks: Using power pairedproportions}

{pstd}
{cmd: power pairedproportions} computes sample size, power, or target
discordant proportions for a two-sample paired-proportions test.  All
computations are performed for a two-sided hypothesis test where, by default,
the significance level is set to 0.05.  You may change the significance level
by specifying the {cmd: alpha()} option.  You can specify the {cmd: onesided}
option to request a one-sided test.

{pstd}
For sample-size and power determinations, {cmd:power pairedproportions}
provides a number of ways of specifying the magnitude of an effect desired to
be detected by the test.  Below we describe the use of the command, assuming
that the desired effect is expressed by the values of the two discordant
proportions; see
{mansection PSS-2 powerpairedproportionsRemarksandexamplessub1:{it:Alternative ways of specifying effect}} for other
specifications.

{pstd}
To compute sample size, you must specify the discordant proportions, {it:p12}
and
{it:p21}, and, optionally, the power of the test in option {cmd:power()}. The
default power is set to 0.8.

{pstd}
To compute power, you must specify the sample size in option {cmd:n()} and the
discordant proportions, {it:p12} and {it:p21}.

{pstd}
The effect-size determination is available only for discordant proportions.
To compute effect size and target discordant proportions, you must specify the
sample size in option {cmd:n()}, the power in option {cmd:power()}, the
sum of the discordant proportions in option {cmd:prdiscordant()}, and,
optionally, the direction of the effect.  The direction is upper by default,
{cmd:direction(upper)}, which means that the failure-success proportion,
{it:p21}, is assumed to be larger than the specified success-failure proportion,
{it:p12}.  You can change the direction to lower, which means that {it:p21} is
assumed to be smaller than {it:p12}, by specifying the {cmd:direction(lower)}
option.

{pstd}
There are multiple definitions of effect size for a two-sample
paired-proportions test. The {cmd:effect()} option specifies what definition
{cmd:power pairedproportions} should use when reporting the effect size, which
is labeled as {cmd:delta} in the output of the {cmd:power} command.

{pstd}
When you specify the discordant proportions, the available definitions are the
difference {it:p21} - {it:p12} between the discordant proportions,
{cmd:effect(diff)}, or the ratio {it:p21}/{it:p12} of the discordant
proportions, {cmd:effect(ratio)}.

{pstd}
When you specify the marginal proportions, the available definitions are the
difference {it:p+1} - {it:p1+} between the marginal proportions,
{cmd:effect(diff)}; the relative risk or ratio {it:p+1}/{it:p1+} of the marginal
proportions, {cmd:effect(rrisk)} or {cmd:effect(ratio)}; or the odds ratio
{c -(}{it:p+1}(1 - {it:p1+}){c )-}/{c -(}{it:p1+}(1 - {it:p+1}){c )-}
of the marginal proportions, {cmd:effect(oratio)}.

{pstd}
When {cmd:effect()} is specified, the effect size {cmd:delta} in the output of
the {cmd:power} command contains the estimate of the corresponding effect and
is labeled accordingly. By default, {cmd:delta} corresponds to the difference
between proportions.  If any one of the options {cmd:diff()}, {cmd:ratio()},
{cmd:rrisk()}, or {cmd:oratio()} is specified and {cmd:effect()} is not
specified, {cmd:delta} will contain the effect size corresponding to the
specified option.

{pstd}
Some of {cmd:power pairedproportions}'s computations require iteration.  For
example, a sample size for a two-sided test is obtained by iteratively solving
a nonlinear power equation.  The default initial value for the sample size for
the iteration procedure is obtained using a closed-form one-sided formula. If
you desire, you may change it by specifying the {cmd:init()} option. See
{manhelp power PSS-2} for the descriptions of other options that control the
iteration procedure.


{marker examples}{...}
{title:Examples}

    {title:Examples: Computing sample size}

{pstd}
    Compute the sample size required to detect discordant proportions
    of 0.2 and 0.3 with 80% power using a two-sided test and 5% 
    significance level (the defaults){p_end}
{phang2}{cmd:. power pairedproportions 0.2 0.3}

{pstd}
    Same as above, specifying the sum of the discordant proportions{p_end}
{phang2}{cmd:. power pairedproportions 0.2, prdiscord(0.5)}
        
{pstd}
    Same as above, increasing power to 0.90{p_end}
{phang2}{cmd:. power pairedproportions 0.2, prdiscord(0.5) power(0.9)}

{pstd}
    Compute the sample size required specifying a difference of 0.4 for the
    discordant proportions and a ratio of 4{p_end}
{phang2}{cmd:. power pairedproportions, diff(0.4) ratio(4)}

{pstd}
    Compute the sample size required to detect marginal proportions of 0.1
    and 0.25 with a correlation of 0.2 using a two-sided test at the 5% 
    significance level (the default){p_end}
{phang2}{cmd:. power pairedproportions 0.1 0.25, corr(0.2)}

{pstd}
    Compute sample size for a range of marginal proportions and powers,
    graphing the results{p_end}
{phang2}{cmd:. power pairedproportions 0.1 (0.2(0.1)0.7), corr(0.2)}
       {cmd:power(0.8 0.9) graph}


    {title:Examples: Computing power}

{pstd}
    Suppose we have a sample of 150 subjects, and we want to compute the power
    of a two-sided hypothesis test with a 5% significance level (the default)
    to detect the discordant proportions of 0.2 and 0.3.{p_end}
{phang2}{cmd:. power pairedproportions 0.2 0.3, n(150)}

{pstd}
    Same as above, reporting the effect size as a ratio{p_end}
{phang2}{cmd:. power pairedproportions 0.2 0.3, n(150) effect(ratio)}

{pstd}
    Compute powers for a range of discordant proportions and sample sizes,
    graphing the results{p_end}
{phang2}{cmd:. power pairedproportions 0.1 (0.2 0.5 0.7), n(5(1)15) graph}


    {title:Examples: Computing target discordant proportion}

{pstd}
    Compute the discordant proportions that can be
    detected with 80% power using a two-sided test in a sample of 100 
    subjects when the sum of discordant proportions is 0.4; assume a 
    significance level of 5% (the default){p_end}
{phang2}{cmd:. power pairedproportions, prdiscord(0.4) n(100) power(0.8)}

{pstd}
    Same as above, reporting the effect size as a ratio{p_end}
{phang2}{cmd:. power pairedproportions, prdiscord(0.4) n(100) power(0.8)}
            {cmd:effect(ratio)}


{marker stored_results}{...}
{title:Stored results}

{pstd}
{cmd:power pairedproportions} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd: r(alpha)}}significance level{p_end}
{synopt:{cmd: r(power)}}power{p_end}
{synopt:{cmd: r(beta)}}probability of a type II error{p_end}
{synopt:{cmd: r(delta)}}effect size{p_end}
{synopt:{cmd: r(N)}}sample size{p_end}
{synopt:{cmd: r(nfractional)}}{cmd:1} if {cmd:nfractional} is specified, {cmd:0} otherwise{p_end}
{synopt:{cmd: r(onesided)}}{cmd:1} for a one-sided test, {cmd:0} otherwise{p_end}
{synopt: {cmd: r(p12)}}success-failure proportion (first discordant proportion){p_end}
{synopt: {cmd: r(p21)}}failure-success proportion (second discordant proportion){p_end}
{synopt:{cmd: r(pmarg1)}}success proportion for occasion 1 (first margins proportion){p_end}
{synopt:{cmd: r(pmarg2)}}success proportion for occasion 2 (second marginal proportion){p_end}
{synopt: {cmd: r(corr)}}correlation between paired observations{p_end}
{synopt: {cmd: r(diff)}}difference between proportions{p_end}
{synopt: {cmd: r(ratio)}}ratio of proportions{p_end}
{synopt: {cmd:r(prdiscordant)}}proportion of discordant pairs{p_end}
{synopt: {cmd: r(sum)}}sum of discordant proportions{p_end}
{synopt: {cmd: r(rrisk)}}relative risk{p_end}
{synopt: {cmd: r(oratio)}}odds ratio{p_end}
INCLUDE help pss_rrestab_sc.ihlp
{synopt: {cmd: r(init)}}initial value for sample size or difference between discordant proportions{p_end}
INCLUDE help pss_rresiter_sc.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(effect)}}{cmd:diff}, {cmd:ratio}, {cmd:oratio}, or {cmd:rrisk}{p_end}
{synopt:{cmd:r(type)}}{cmd:test}{p_end}
{synopt:{cmd:r(method)}}{cmd:pairedproportions}
{p_end}
INCLUDE help pss_rrestest_mac.ihlp
INCLUDE help pss_rrestab_mac.ihlp

{synoptset 20 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
INCLUDE help pss_rrestab_mat.ihlp
