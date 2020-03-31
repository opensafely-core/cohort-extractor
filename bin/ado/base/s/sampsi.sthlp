{smcl}
{* *! version 1.3.4  20aug2018}{...}
{viewerdialog sampsi "dialog sampsi"}{...}
{viewerdialog "sampsi (repeated measures)" "dialog sampsi_repmeas"}{...}
{vieweralsosee "help prdocumented" "help prdocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stpower" "help stpower"}{...}
{viewerjumpto "Syntax" "sampsi##syntax"}{...}
{viewerjumpto "Menu" "sampsi##menu"}{...}
{viewerjumpto "Description" "sampsi##description"}{...}
{viewerjumpto "Options" "sampsi##options"}{...}
{viewerjumpto "Examples" "sampsi##examples"}{...}
{viewerjumpto "Stored results" "sampsi##results"}{...}
{pstd}
{cmd:sampsi} continues to work but, as of Stata 13, is no longer an official
part of Stata.  This is the original help file, which we will no longer
update, so some links may no longer work.

{pstd}
See {manhelp power PSS-2} for a recommended alternative to {cmd:sampsi}.


{title:Title}

{p2colset 5 19 21 2}{...}
{p2col:{bf:[R] sampsi} {hline 2}}Sample size and power for means and
proportions{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:sampsi}
{it:#1 #2}
[{cmd:,} {it:options}]

{synoptset 18 tabbed}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt onesam:ple}}one-sample test; default is two-sample{p_end}
{synopt:{opt sd1(#)}}standard deviation of sample 1{p_end}
{synopt:{opt sd2(#)}}standard deviation of sample 2{p_end}

{syntab:Options}
{synopt:{opt a:lpha(#)}}significance level of test; default is
{cmd:alpha(0.05)}{p_end}
{synopt:{opt p:ower(#)}}power of test; default is {cmd:power(0.90)}{p_end}
{synopt:{opt n:1(#)}}size of sample 1{p_end}
{synopt:{opt n:2(#)}}size of sample 2{p_end}
{synopt:{opt r:atio(#)}}ratio of sample sizes; default is
{cmd:ratio(1)}{p_end}
{synopt:{opt pre(#)}}number of baseline measurements; default is
{cmd:pre(0)}{p_end}
{synopt:{opt post(#)}}number of follow-up measurements; default is
{cmd:post(1)}{p_end}
{synopt:{opt nocont:inuity}}do not use continuity correction for two-sample
test on proportions{p_end}
{synopt:{opt r0(#)}}correlation between baseline measurements; default is
{cmd:r0()=r1()}{p_end}
{synopt:{opt r1(#)}}correlation between follow-up measurements{p_end}
{synopt:{opt r01(#)}}correlation between baseline and follow-up measurements{p_end}
{synopt:{opt onesid:ed}}one-sided test; default is two-sided{p_end}
{synopt:{opt m:ethod(method)}}analysis method where {it:method} is
{opt post}, {opt change}, {opt ancova}, or {opt all}; default is
{cmd:method(all)}{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

    {title:sampsi}

{phang2}
{bf:Statistics > Power and sample size > Tests of means and proportions}

     {title:sampsi with repeated measures}

{phang2}
{bf:Statistics > Power and sample size > Tests of means with repeated measures}


{marker description}{...}
{title:Description}

{pstd}
{opt sampsi} estimates require sample size or power of tests for studies
comparing two groups.  {opt sampsi} can be used when comparing means or
proportions for simple studies where only one measurement of the outcome is
planned and for comparing mean summary statistics for more complex studies
where repeated measurements of the outcome on each experimental unit are
planned.

{pstd}
If {opt n1(#)} or {opt n2(#)} is specified, {opt sampsi} computes power;
otherwise, it computes sample size.  For simple studies, if {opt sd1(#)} or
{opt sd2(#)} is specified, {opt sampsi} assumes a comparison of means;
otherwise, it assumes a comparison of proportions.  For repeated measurements,
{opt sd1(#)}, or {opt sd2(#)} must be specified.  {opt sampsi} is an immediate
command; all its arguments are numbers; see {help immed}.

{pstd}
For simple studies, where only one measurement of the outcome is planned,
{cmd:sampsi} computes sample size or power for four types of tests:

{phang}1.  Two-sample comparison of means.{p_end}
{pmore}The postulated values of the means are {it:#1} and {it:#2}.{p_end}
{pmore}The postulated standard deviations are {cmd:sd1()} and {cmd:sd2()}.{p_end}

{phang}2.  One-sample comparison of mean with hypothesized value.{p_end}
{pmore}Option {cmd:onesample} must be specified.{p_end}
{pmore}The hypothesized value (null hypothesis) is {it:#1}.{p_end}
{pmore}The postulated mean (alternative hypothesis) is {it:#2}.{p_end}
{pmore}The postulated standard deviation is {cmd:sd1()}.{p_end}

{phang}3.  Two-sample comparison of proportions.{p_end}
{pmore}The postulated values of the proportions are {it:#1} and {it:#2}.{p_end}

{phang}4.  One-sample comparison of proportion with hypothesized value.{p_end}
{pmore}Option {cmd:onesample} must be specified.{p_end}
{pmore}The hypothesized proportion (null hypothesis) is {it:#1}.{p_end}
{pmore}The postulated proportion (alternative hypothesis) is {it:#2}.{p_end}


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt onesample} indicates a one-sample test.  The default is two-sample.

{phang}
{opt sd1(#)} and {opt sd2(#)} are the standard deviations of population 1 and
population 2, respectively.  One or both must be specified when doing a
comparison of means.  When the {opt onesample} option is used, {opt sd1(#)} is
the standard deviation of the single sample (it can be abbreviated
as {opt sd(#)}).  If only one of {opt sd1(#)} or {opt sd2(#)} is specified,
{opt sampsi} assumes that {opt sd1()} = {opt sd2()}.  If neither {opt sd1(#)}
nor {opt sd2(#)} is specified, {opt sampsi} assumes a test of proportions.  For
repeated measurements, {opt sd1(#)} or {opt sd2(#)} must be specified.

{dlgtab:Options}

{phang}
{opt alpha(#)} is the significance level of the test.
The default is {cmd:alpha(0.05)} unless {opt set level} has been used to reset
the default significance level for confidence intervals.  If a {opt set level}
#-level command has been issued, the default value is
{cmd:alpha(}1-level/100{cmd:)}.  See {manhelp level R}.

{phang}
{opt power(#)} = 1 - b is the power of the test.  The default is {cmd:power(0.90)}.

{phang}
{opt n1(#)} and {opt n2(#)} are the sizes of sample 1 and sample 2,
respectively.  One or both must be specified  when computing power.  If
neither {opt n1(#)} nor {opt n2(#)} is specified, {opt sampsi} computes sample
size.  When the {opt onesample} option is used, {opt n1(#)} is the size of the
single sample (it can be abbreviated as {opt n(#)}). If only one of
{opt n1(#)} or {opt n2(#)} is specified, the unspecified one is computed using
the formula {cmd:ratio} = {opt n2()}/{opt n1()}.

{phang}
{opt ratio(#)}
is the ratio of sample sizes for two-sample tests: {cmd:ratio()} =
{cmd:n2()}/{cmd:n1()}.  The default is {cmd:ratio(1)}.

{phang}
{opt pre(#)} specifies the number of baseline measurements (prerandomization)
planned in a repeated-measure study.  The default is {cmd:pre(0)}.

{phang}
{opt post(#)} specifies the number of follow-up measurements
(postrandomization) planned in a repeated-measure study.  The default is
{cmd:post(1)}.

{phang}
{opt nocontinuity} requests power and sample size calculations without
continuity correction for two-sample test on proportions. If not specified,
the continuity correction is used.

{phang}
{opt r0(#)} specifies the correlation between baseline
measurements in a repeated-measure study.  If {opt r0(#)} is
not specified, {opt sampsi} assumes that {opt r0()} = {opt r1()}.

{phang}
{opt r1(#)} specifies the correlation between follow-up measurements in
a repeated-measure study.  For a repeated-measure study, either
{opt r1(#)} or {opt r01(#)} must be specified.  If {opt r1(#)} is not
specified, {opt sampsi} assumes that {opt r1()} = {opt r01()}.

{phang}
{opt r01(#)} specifies the correlation between baseline and follow-up
measurements in a repeated-measure study.  For a repeated-measure
study, either {opt r01(#)} or {opt r1(#)} must be specified.  If
{opt r01(#)} is not specified, {cmd:sampsi} assumes that {opt r01()} = {opt r1()}.

{phang}
{opt onesided} indicates a one-sided test.  The default is two-sided.

{phang}
{cmd:method(post}|{opt change}|{opt ancova}|{opt all)} specifies the
analysis method to be used with repeated measures.  {opt change} and
{opt ancova} can be used only if baseline measurements are planned.  The
default is {cmd:method(all)}, which means to use all three methods.


{marker examples}{...}
{title:Examples}

{phang}1.  Two-sample comparison of mean1 to mean2.  Compute sample
sizes with n2/n1 = 2:

{phang2}{cmd:. sampsi 132.86 127.44, p(0.8) r(2) sd1(15.34) sd2(18.23)}

{pmore}Compute power with n1 = n2, sd1 = sd2, and alpha = 0.01 one-sided:

{phang2}{cmd:. sampsi 5.6 6.1, n1(100) sd1(1.5) a(0.01) onesided}

{phang}2.  One-sample comparison of mean to hypothesized value = 180.  Compute
sample size:

{phang2}{cmd:. sampsi 180 211, sd(46) onesam}

{pmore}One-sample comparison of mean to hypothesized value = 0.  Compute power:

{phang2}{cmd:. sampsi 0 -2.5, sd(4) n(25) onesam}

{phang}3.  Two-sample comparison of proportions.  Compute sample size with n1 =
n2 (that is, ratio = 1, the default) and power = 0.9 (the default):

{phang2}{cmd:. sampsi 0.25 0.4}

{pmore}Compute power with n1 = 500 and ratio = n2/n1 = 0.5:

{phang2}{cmd:. sampsi 0.25 0.4, n1(300) r(0.5)}

{phang}4.  One-sample comparison of proportion to hypothesized value = 0.5:

{phang2}{cmd:. sampsi 0.5 0.75, power(0.8) onesample}

{pmore}Compute power:

{phang2}{cmd:. sampsi 0.5 0.6, n(200) onesam}

{phang}5.  Repeated measures:

{phang2}{cmd:. sampsi 498 485, sd1(20.2) sd2(19.5) method(change) pre(1) post(3) r1(.7)}

{pmore}Compute power:

{phang2}{cmd:. sampsi 498 485, sd1(20.2) sd2(19.5) method(change) pre(1) post(3) r1(.7) n1(15) n2(15)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:sampsi} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N_1)}}sample size n_1{p_end}
{synopt:{cmd:r(N_2)}}sample size n_2{p_end}
{synopt:{cmd:r(power)}}power{p_end}
{synopt:{cmd:r(adj)}}adjustment to the SE{p_end}
{synopt:{cmd:r(warning)}}0 if assumptions are satisfied and 1 otherwise{p_end}
{p2colreset}{...}
