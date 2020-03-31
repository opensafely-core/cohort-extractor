{smcl}
{* *! version 1.2.2  20aug2018}{...}
{viewerdialog "stpower cox" "dialog stpower_cox"}{...}
{viewerdialog "stpower logrank" "dialog stpower_logrank"}{...}
{viewerdialog "stpower exponential" "dialog stpower_exponential"}{...}
{vieweralsosee "previously documented" "help prdocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stpower cox" "help stpower_cox"}{...}
{vieweralsosee "[ST] stpower exponential" "help stpower_exponential"}{...}
{vieweralsosee "[ST] stpower logrank" "help stpower_logrank"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] Glossary" "help st_glossary"}{...}
{viewerjumpto "Syntax" "stpower##syntax"}{...}
{viewerjumpto "Description" "stpower##description"}{...}
{viewerjumpto "Introduction to stpower subcommands" "stpower##remarks1"}{...}
{viewerjumpto "Remarks on the methods used in stpower subcommands" "stpower##remarks2"}{...}
{viewerjumpto "Examples" "stpower##examples"}{...}
{viewerjumpto "References" "stpower##references"}{...}
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

{p2colset 5 21 23 2}{...}
{p2col :{hi:[ST] stpower} {hline 2}}Sample size, power, and effect size
for survival analysis{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Sample-size determination

{p 8 16 2}
{opt stpow:er} {opt cox} [...] [{cmd:,} ...]

{p 8 16 2}
{opt stpow:er} {opt log:rank} [...] [{cmd:,} ...]

{p 8 16 2}
{opt stpow:er} {opt exp:onential} [...] [{cmd:,} ...]

{phang}
Power determination

{p 8 16 2}
{opt stpow:er} {opt cox } [...]{cmd:,} 
{opth n(numlist)} [...] 

{p 8 16 2}
{opt stpow:er} {opt log:rank} [...]{cmd:,} 
{opth n(numlist)} [...] 

{p 8 16 2}
{opt stpow:er} {opt exp:onential} [...]{cmd:,} 
{opth n(numlist)} [...] 

{phang}
Effect-size determination

{p 8 16 2}
{opt stpow:er} {opt cox}{cmd:,} 
{opth n(numlist)} {c -(}{opth p:ower(numlist)} | {opth b:eta(numlist)}{c )-} [...] 

{p 8 16 2}
{opt stpow:er} {opt log:rank} [...]{cmd:,} 
{opth n(numlist)} {c -(}{opth p:ower(numlist)} | {opth b:eta(numlist)}{c )-} [...] 


{pstd}
See {manhelp stpower_cox ST: stpower cox}, 
{manhelp stpower_logrank ST: stpower logrank}, and 
{manhelp stpower_exponential ST: stpower exponential}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:stpower} computes sample size and power for survival analysis comparing
two survivor functions using the log-rank test or the exponential test (to be
defined later), as well as for more general survival analysis investigating the
effect of a single covariate in a Cox proportional hazards regression model,
possibly in the presence of other covariates.  It provides the estimate of the
number of events required to be observed (or the expected number of events) in
a study.  The minimal effect size (minimal detectable difference,
expressed as the hazard ratio or the log hazard-ratio) may also be obtained
for the log-rank test and for the Wald test on a single coefficient from the
Cox model.

{pstd}
This entry provides a brief overview of the relevant terminology, theory, and
a few examples.  For more details, see the entries specific to each
{cmd:stpower} subcommand.

{pstd}
Also see {manhelp power PSS-2} for power and sample-size analysis for other
statistical methods.


{marker remarks1}{...}
{title:Introduction to stpower subcommands}

{pstd}
{cmd:stpower} offers three subcommands: {cmd:stpower} {cmd:cox},
{cmd:stpower} {cmd:logrank}, and {cmd:stpower} {cmd:exponential}.

{pmore}
{cmd:stpower} {cmd:cox} provides estimates of sample size, power, or the
minimal detectable value of the coefficient when an effect of a single
covariate on subject survival is to be explored using the Cox proportional
hazards regression.  It is assumed that the effect is to be tested using the
partial likelihood from the Cox model (for example, score or Wald test), on
the coefficient of the covariate of interest.

{pmore}
{cmd:stpower} {cmd:logrank} reports estimates of sample size, power, or
minimal detectable value of the hazard ratio in the case when the two survivor
functions are to be compared using the log-rank test.  The only requirement
about the distribution of the survivor functions is that the two survivor
functions must satisfy the proportional-hazards assumption.

{pmore}
{cmd:stpower} {cmd:exponential} reports estimates of sample size or power when
the disparity in the two exponential survivor functions is to be tested
using the {it:exponential} {it:test}, the parametric test which test statistic
is a function of the maximum likelihood estimators of the two exponential
hazard rates.  In particular, we refer to (exponential) {it:hazard-difference}
test as the exponential test for the difference between hazards, and the
(exponential) {it:log hazard ratio} test as the exponential test for the log
of the hazard ratio or, equivalently, for the difference between log hazards.

{pstd}
All subcommands share a common syntax.  Sample-size determination with a power
of 80% or, equivalently, a probability of a {it:type} {it:II} {it:error}, a
failure to reject the null hypothesis when the alternative hypothesis is true,
of 20% is the default.  Other values of power or type II error probability may
be supplied via options {cmd:power()} or {cmd:beta()}, respectively.  If power
determination is desired, sample size {cmd:n()} must be specified.  If the
minimal detectable difference is of interest, both sample size {cmd:n()} and
{cmd:power()} (or type II error probability {cmd:beta()}) must be specified.

{pstd}
For sample size and power computation the default effect size corresponds to a
value of the hazard ratio of 0.5 and may be changed by specifying option
{cmd:hratio()}.  The hazard ratio is defined as a ratio of hazards of the
experimental group to the control group (or the less favorable of the two
groups).  In addition, alternative ways of specifying the effect size are
available, and these are particular to each of the subcommands.

{pstd}
The default probability of a {it:type} {it:I} {it:error}, a rejection of the
null hypothesis when the null hypothesis is true, of a test is 0.05 but may
changed by using option {cmd:alpha()}.  Results for one-sided tests may be
requested by using option {cmd:onesided}.  In order to change the default
setting of equal-sized groups in {cmd:stpower} {cmd:logrank} and {cmd:stpower}
{cmd:exponential}, one of options {cmd:p1()} or {cmd:nratio()} must be
specified.

{pstd}
By default, all subcommands assume a {it:type} {it:I} {it:study}, that is,
perform computations for uncensored data.  Also see
{it:Theory and terminology} in {bf:[ST] stpower}.  The censoring information
may be taken into account by specifying the appropriate arguments or options.
Refer to {helpb stpower cox:[ST] stpower cox},
{helpb stpower logrank:[ST] stpower logrank}, and
{helpb stpower exponential:[ST] stpower exponential} for details.

{pstd}
All subcommands can report results in a table.  Results may be tabulated for
varying values of input parameters; see examples below and section
{it:Creating output tables} in {bf:[ST] stpower}.  An example of how to
produce a power curve is given below; also see 
{it:Power curves}} in {bf:[ST]} {bf:stpower} and 
{it:Power and effect-size determination} in {bf:[ST] stpower logrank}.


{marker remarks2}{...}
{title:Remarks on the methods used in stpower subcommands}

{pstd}
All sample-size formulas used by {cmd:stpower} rely on the
proportional-hazards assumption, that is, the assumption that the hazard ratio
does not depend on time.  See the documentation entry of each subcommand
for the additional assumptions imposed by the methods it uses.

{pmore}
{cmd:stpower} {cmd:cox} adopts the method of 
{help stpower##HL2000:Hsieh and Lavori (2000)} to
compute sample size and power for the test of a covariate obtained after the
Cox model fit.

{pmore}
{cmd:stpower} {cmd:logrank} uses the approach of 
{help stpower##F1982:Freedman (1982)} and
{help stpower##S1981:Schoenfeld (1981)}
for sample-size and power computation.  The approach of
{help stpower##S1983:Schoenfeld (1983)}
is used to obtain the estimates in the presence of uniform accrual.

{pmore}
{cmd:stpower} {cmd:exponential} implements methods of 
{help stpower##L1981:Lachin (1981)};
{help stpower##LF1986:Lachin and Foulkes (1986)};
{help stpower##GD1974:George and Desu (1974)}; and
{help stpower##RGS1981:Rubinstein, Gail, and Santner (1981)}
for the two-sample test of exponential survivor functions.  The
explicit sample-size formula for the last method was given in
{help stpower##LL1992:Lakatos and Lan (1992)}.


{marker examples}{...}
{title:Examples}

    {title:Cox model}

{pstd}
Compute sample size required to detect a coefficient of -1 on a covariate of
interest with a standard deviation of 0.5 using a two-sided 5% Wald test with
80% power (the default){p_end}
{phang2} 
{cmd:. stpower cox -1} 
{p_end}

{pstd}
Compute power of the test just described for a sample of 50 observations
{p_end}
{phang2}
{cmd:. stpower cox -1, n(50)}
{p_end}

{pstd}
Compute minimal value of coefficient that can be detected with 95% power for a
sample size of 50, assuming the covariate of interest has a standard deviation
of 0.5 (the default){p_end}
{phang2}
{cmd:. stpower cox, power(0.95) n(50)}
{p_end}


    {title:Log-rank test}

{pstd}
Compute sample size required to test the disparity in two survivor functions
corresponding to a 50% reduction in the hazard of the experimental group (a
hazard ratio of 0.5), using the default two-sided 5% log-rank test with 80%
power{p_end}
{phang2} 
{cmd:. stpower logrank 0.6} 
{p_end}

{pstd}
Compute power of the test just described for a sample size of 300{p_end}
{phang2} 
{cmd:. stpower logrank 0.6, n(300)} 
{p_end}

{pstd}
Compute minimal value of hazard ratio that can be detected with 80% power and
a sample size of 300 when the probability of surviving to the end of the study
is 0.6 for the control group{p_end}
{phang2} 
{cmd:. stpower logrank 0.6, n(300) power(0.8)} 
{p_end}

{pstd}
Produce a power curve as a function of the hazard ratio for a sample size of
100{p_end}
{phang2} 
{cmd:. stpower logrank, hratio(0.01(0.01)0.99) n(100) saving(mypower)}{p_end}
{phang2}{cmd:. use mypower}{p_end}
{phang2}{cmd:. twoway line power hr, xtitle(hazard ratio)}
         {cmd:title("Power (n=100)")} 
{p_end}


    {title:Exponential test}

{pstd}
Compute sample size required to test the disparity in two exponential
survivor functions corresponding to a reduction in the hazard rate of the
experimental group from 0.2 to 0.4, using the default two-sided 5% exponential
test with 80% power{p_end}
{phang2} 
{cmd:. stpower exponential 0.2 0.4} 
{p_end}

{pstd}
Compute power of the test just described for a sample size of 100{p_end}
{phang2} 
{cmd:. stpower exponential 0.2 0.4, n(100)} 
{p_end}


{marker references}{...}
{title:References}

{marker F1982}{...}
{phang}
Freedman, L. S. 1982.  
Tables of the number of patients required in clinical trials using the
logrank test.  
{it:Statistics in Medicine} 1: 121-129.{p_end}

{marker GD1974}{...}
{phang}
George, S. L., and M. M. Desu. 1974. 
Planning the size and duration of a clinical trial studying the time to some
critical event. {it: Journal of Chronic Diseases} 27: 15-24.{p_end}

{marker HL2000}{...}
{phang}
Hsieh, F. Y., and P. W. Lavori. 2000.
Sample-size calculations for the Cox proportional hazards regression model
with nonbinary covariates.
{it: Controlled Clinical Trials} 21: 552-560.{p_end}

{marker L1981}{...}
{phang}
Lachin, J. M. 1981.
Introduction to sample size determination and power analysis for clinical
trials. {it: Controlled Clinical Trials} 2: 93-113.{p_end}

{marker LF1986}{...}
{phang}
Lachin, J. M., and M. A. Foulkes. 1986. 
Evaluation of sample size and power for analyses of survival with allowance
for nonuniform patient entry, losses to follow-up, noncompliance, and
stratification. {it: Biometrics} 42: 507-519.{p_end}

{marker LL1992}{...}
{phang}
Lakatos, E., and K. K. G. Lan. 1992.
A comparison of sample size methods for the logrank statistic. 
{it: Statistics in Medicine} 11: 179-191.{p_end}

{marker RGS1981}{...}
{phang}
Rubinstein, L. V., M. H. Gail, and T. J. Santner. 1981.
Planning the duration of a comparative clinical trial with loss to follow-up
and a period of continued observation. {it: Journal of Chronic Diseases} 34: 469-479.{p_end}

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
