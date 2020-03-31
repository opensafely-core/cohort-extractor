{smcl}
{* *! version 1.0.24  19oct2017}{...}
{viewerdialog xtunitroot "dialog xtunitroot"}{...}
{vieweralsosee "[XT] xtunitroot" "mansection XT xtunitroot"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] dfgls" "help dfgls"}{...}
{vieweralsosee "[TS] dfuller" "help dfuller"}{...}
{vieweralsosee "[TS] pperron" "help pperron"}{...}
{vieweralsosee "[XT] xtcointtest" "help xtcointtest"}{...}
{viewerjumpto "Syntax" "xtunitroot##syntax"}{...}
{viewerjumpto "Menu" "xtunitroot##menu"}{...}
{viewerjumpto "Description" "xtunitroot##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtunitroot##linkspdf"}{...}
{viewerjumpto "Options" "xtunitroot##options"}{...}
{viewerjumpto "Remarks" "xtunitroot##remarks"}{...}
{viewerjumpto "Examples" "xtunitroot##examples"}{...}
{viewerjumpto "Stored results" "xtunitroot##results"}{...}
{viewerjumpto "References" "xtunitroot##references"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[XT] xtunitroot} {hline 2}}Panel-data unit-root tests{p_end}
{p2col:}({mansection XT xtunitroot:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Levin-Lin-Chu test

{p 8 16 2}
{cmd:xtunitroot llc} {varname} {ifin} [{cmd:,} 
{it:{help xtunitroot##llc_options:LLC_options}}]


{p 4 8 2}
Harris-Tzavalis test

{p 8 16 2}
{cmd:xtunitroot ht} {varname} {ifin} [{cmd:,} 
{it:{help xtunitroot##ht_options:HT_options}}]


{p 4 8 2}
Breitung test

{p 8 16 2}
{cmd:xtunitroot breitung} {varname} {ifin} [{cmd:,}
{it:{help xtunitroot##breitung_options:Breitung_options}}]


{p 4 8 2}
Im-Pesaran-Shin test

{p 8 16 2}
{cmd:xtunitroot ips} {varname} {ifin} [{cmd:,} 
{it:{help xtunitroot##ips_options:IPS_options}}]


{p 4 8 2}
Fisher-type tests (combining p-values)

{p 8 16 2}
{cmd:xtunitroot fisher} {varname} {ifin}{cmd:,}
{c -(}{opt df:uller} {c |} {opt pp:erron}{c )-}
{opt l:ags(#)}
[{it:{help xtunitroot##fisher_options:Fisher_options}}]


{p 4 8 2}
Hadri Lagrange multiplier stationarity test

{p 8 16 2}
{cmd:xtunitroot hadri} {varname} {ifin} [{cmd:,}
{it:{help xtunitroot##hadri_options:Hadri_options}}]


{marker llc_options}{...}
{synoptset 21}{...}
{synopthdr:LLC_options}
{synoptline}
{synopt:{opt t:rend}}include a time trend{p_end}
{synopt:{opt nocons:tant}}suppress panel-specific means{p_end}
{synopt:{opt demean}}subtract cross-sectional means{p_end}
{synopt:{opt l:ags(lag_spec)}}specify lag structure for augmented
           Dickey-Fuller (ADF) regressions{p_end}
{synopt:{opt ker:nel(kernel_spec)}}specify method to estimate long-run variance{p_end}
{synoptline}
{p 4 6 2}{it:lag_spec} is either a nonnegative integer or one of {opt aic},
{opt bic}, or {opt hqic} followed by a positive integer.{p_end}
{p 4 6 2}{it:kernel_spec} takes the form {it:kernel} {it:maxlags}, where
{it:kernel} is one of {opt ba:rtlett}, {opt pa:rzen}, or
{opt qu:adraticspectral} and {it:maxlags} is either a positive number or one of
{opt nwest} or {opt llc}.{p_end}


{marker ht_options}{...}
{synoptset 21}{...}
{synopthdr:HT_options}
{synoptline}
{synopt:{opt t:rend}}include a time trend{p_end}
{synopt:{opt nocons:tant}}suppress panel-specific means{p_end}
{synopt:{opt demean}}subtract cross-sectional means{p_end}
{synopt:{opt altt}}make small-sample adjustment to T{p_end}
{synoptline}


{marker breitung_options}{...}
{synoptset 21}{...}
{synopthdr:Breitung_options}
{synoptline}
{synopt:{opt t:rend}}include a time trend{p_end}
{synopt:{opt nocons:tant}}suppress panel-specific means{p_end}
{synopt:{opt demean}}subtract cross-sectional means{p_end}
{synopt:{opt r:obust}}allow for cross-sectional dependence{p_end}
{synopt:{opt l:ags(#)}}specify lag structure for prewhitening{p_end}
{synoptline}


{marker ips_options}{...}
{synoptset 21}{...}
{synopthdr:IPS_options}
{synoptline}
{synopt:{opt t:rend}}include a time trend{p_end}
{synopt:{opt demean}}subtract cross-sectional means{p_end}
{synopt:{opt l:ags(lag_spec)}}specify lag structure for ADF regressions{p_end}
{synoptline}
{p 4 6 2}{it:lag_spec} is either a nonnegative integer or one of {opt aic}, {opt bic}, or {opt hqic} followed by a positive integer.{p_end}


{marker fisher_options}{...}
{synoptset 21 tabbed}{...}
{synopthdr:Fisher_options}
{synoptline}
{p2coldent:* {opt df:uller}}use ADF unit-root tests{p_end}
{p2coldent:* {opt pp:erron}}use Phillips-Perron unit-root tests{p_end}
{p2coldent:* {opt l:ags(#)}}specify lag structure for prewhitening{p_end}
{synopt:{opt demean}}subtract cross-sectional means{p_end}
{synopt:{help dfuller:{it:dfuller_opts}}}any options allowed by the {cmd:dfuller} command{p_end}
{synopt:{help pperron:{it:pperron_opts}}}any options allowed by the {cmd:pperron} command{p_end}
{synoptline}
{p 4 6 2}* Either {opt dfuller} or {opt pperron} is required.{p_end}
{p 4 6 2}* {opt lags(#)} is required.{p_end}


{marker hadri_options}{...}
{synoptset 21}{...}
{synopthdr:Hadri_options}
{synoptline}
{synopt:{opt t:rend}}include a time trend{p_end}
{synopt:{opt demean}}subtract cross-sectional means{p_end}
{synopt:{opt r:obust}}allow for cross-sectional dependence{p_end}
{synopt:{opt ker:nel(kernel_spec)}}specify method to estimate long-run variance{p_end}
{synoptline}
{p 4 6 2}{it:kernel_spec} takes the form {it:kernel} [{it:#}], where {it:kernel}
is one of {opt ba:rtlett}, {opt pa:rzen}, or {opt qu:adraticspectral} and
{it:#} is a positive number.{p_end}

{p 4 6 2}
{it:varname} may contain time-series operators; see {help tsvarlist}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Longitudinal/panel data > Unit-root tests}


{marker description}{...}
{title:Description}

{pstd}
{cmd:xtunitroot} performs a variety of tests for unit roots (or 
stationarity) in panel datasets.  The
{help xtunitroot##LLC2002:Levin-Lin-Chu (2002)},
{help xtunitroot##HT1999:Harris-Tzavalis (1999)},
Breitung ({help xtunitroot##B2000:2000};
{help xtunitroot##BD2005:Breitung and Das 2005}),
{help xtunitroot##IPS2003:Im-Pesaran-Shin (2003)}, and Fisher-type
({help xtunitroot##C2001:Choi 2001}) tests have as the null hypothesis that
all the panels contain a unit root.  The
{help xtunitroot##H2000:Hadri (2000)} Lagrange multiplier (LM) test has as the
null hypothesis that all the panels are (trend) stationary.  The top of the
output for each test makes explicit the null and alternative hypotheses.
Options allow you to include panel-specific means (fixed effects) and time
trends in the model of the data-generating process.  


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtunitrootQuickstart:Quick start}

        {mansection XT xtunitrootRemarksandexamples:Remarks and examples}

        {mansection XT xtunitrootMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

    {title:LLC_options}

{phang}
{opt trend} includes a linear time trend in the model that describes the 
process by which the series is generated.

{phang}
{opt noconstant} suppresses the panel-specific mean term in the model 
that describes the process by which the series is generated.  Specifying 
{opt noconstant} imposes the assumption that the series has a mean of 
zero for all panels.

{phang}
{opt demean} requests that {cmd:xtunitroot} first subtract the 
cross-sectional averages from the series.  When specified, for each 
time period {cmd:xtunitroot} computes the mean of the series across 
panels and subtracts this mean from the series.  Levin, Lin, and Chu 
suggest this procedure to mitigate the impact of cross-sectional 
dependence.

{phang}
{opt lags(lag_spec)} specifies the lag structure to use for the 
ADF regressions performed in computing the test statistic.

{pmore}
Specifying {opt lags(#)} requests that {it:#} lags of the series be 
used in the ADF regressions.  The default is {cmd:lags(1)}.

{pmore}
Specifying {cmd:lags(aic }{it:#}{cmd:)} requests that the number of lags 
of the series be chosen such that the Akaike information criterion (AIC) 
for the regression is minimized.  {cmd:xtunitroot llc} will fit ADF 
regressions with 1 to {it:#} lags and choose the regression for which the
AIC is minimized.  This process is done for each panel so that 
different panels may use ADF regressions with different numbers of lags.

{pmore}
Specifying {cmd:lags(bic }{it:#}{cmd:)} is just like specifying 
{cmd:lags(aic }{it:#}{cmd:)}, except that the Bayesian information
criterion (BIC) is used instead of the AIC.

{pmore}
Specifying {cmd:lags(hqic }{it:#}{cmd:)} is just like specifying 
{cmd:lags(aic }{it:#}{cmd:)}, except that the Hannan-Quinn information
criterion is used instead of the AIC.

{phang} 
{opt kernel(kernel_spec)} specifies the method used to estimate 
the long-run variance of each panel's series.  {it:kernel_spec} takes 
the form {it:kernel} {it:maxlags}.  {it:kernel} is one of 
{cmdab:bartlett}, {cmdab:parzen}, or {cmdab:quadraticspectral}.  
{it:maxlags} is a number, {cmd:nwest} to request the
{help xtunitroot##NW1994:Newey and West (1994)} bandwidth selection algorithm,
or {cmd:llc} to request the lag truncation selection algorithm in
{help xtunitroot##LLC2002:Levin, Lin, and Chu (2002)}.

{pmore}
Specifying, for example, {cmd:kernel(bartlett 3)} requests the Bartlett 
kernel with 3 lags.

{pmore}
Specifying {cmd:kernel(bartlett nwest)} requests the Bartlett kernel 
with the maximum number of lags determined by the Newey and West
bandwidth selection algorithm.

{pmore}
Specifying {cmd:kernel(bartlett llc)} requests the Bartlett kernel with 
the maximum number of lags determined by the method proposed in Levin, Lin, and
Chu's ({help xtunitroot##LLC2002:2002}) article: 

{pmore2}{it:maxlags} = int(3.21*T^(1/3))

{pmore}
where T is the number of observations per panel.  This is the 
default.

    {title:HT_options}

{phang}
{opt trend} includes a linear time trend in the model that describes the 
process by which the series is generated.

{phang}
{opt noconstant} suppresses the panel-specific mean term in the model 
that describes the process by which the series is generated.  Specifying 
{opt noconstant} imposes the assumption that the series has a mean of 
zero for all panels.

{phang}
{opt demean} requests that {cmd:xtunitroot} first subtract the 
cross-sectional averages from the series.  When specified, for each 
time period {cmd:xtunitroot} computes the mean of the series across 
panels and subtracts this mean from the series.  Levin, Lin, and Chu 
suggest this procedure to mitigate the impact of cross-sectional 
dependence.

{phang}
{opt altt} requests that {cmd:xtunitroot} use T-1 instead of T in the
formulas for the mean and variance of the test statistic under the null
hypothesis.  When the number of time periods, T, is small (less than
10 or 15), the test suffers from severe size distortions when fixed effects
or time trends are included; in these cases, using {opt altt} results
in much improved size properties at the expense of significantly less
power.

    {title:Breitung_options}

{phang}
{opt trend} includes a linear time trend in the model that describes the 
process by which the series is generated.

{phang}
{opt noconstant} suppresses the panel-specific mean term in the model 
that describes the process by which the series is generated.  Specifying 
{opt noconstant} imposes the assumption that the series has a mean of 
zero for all panels.

{phang}
{opt demean} requests that {cmd:xtunitroot} first subtract the 
cross-sectional averages from the series.  When specified, for each 
time period {cmd:xtunitroot} computes the mean of the series across 
panels and subtracts this mean from the series.  Levin, Lin, and Chu 
suggest this procedure to mitigate the impact of cross-sectional 
dependence.

{phang}
{opt robust} requests a variant of the test that is robust to 
cross-sectional dependence. 

{phang}
{opt lags(#)} specifies the number of lags used to remove 
higher-order autoregressive components of the series.  The Breitung test 
assumes the data are generated by an AR(1) process; for higher-order 
processes, the first-differenced and lagged-level data are replaced by 
the residuals from regressions of those two series on the first {it:#} 
lags of the first-differenced data.  The default is to not perform this 
prewhitening step.

    {title:IPS_options}

{phang}
{opt trend} includes a linear time trend in the model that describes the 
process by which the series is generated.

{phang}
{opt demean} requests that {cmd:xtunitroot} first subtract the 
cross-sectional averages from the series.  When specified, for each 
time period {cmd:xtunitroot} computes the mean of the series across 
panels and subtracts this mean from the series.  Levin, Lin, and Chu 
suggest this procedure to mitigate the impact of cross-sectional 
dependence.

{phang}
{opt lags(lag_spec)} specifies the lag structure to use for the ADF regressions
performed in computing the test statistic.  With this option, {cmd:xtunitroot}
reports Im, Pesaran, and Shin's ({help xtunitroot##IPS2003:2003}) W_t-bar
statistic that is predicated on
T going to infinity first, followed by N going to infinity.  By default, no
lags are included, and {cmd:xtunitroot} instead reports Im, Pesaran, and Shin's
t-tilde-bar and Z_t-tilde-bar statistics that assume T is fixed while N goes to
infinity, as well as the t-bar statistic and exact critical values that assume
both N and T are fixed.

{pmore}
Specifying {opt lags(#)} requests that {it:#} lags of the series be 
used in the ADF regressions.  By default, no lags are included.

{pmore}
Specifying {cmd:lags(aic }{it:#}{cmd:)} requests that the number of lags of the
series be chosen such that the AIC for the regression is minimized.
{cmd:xtunitroot llc} will fit ADF regressions with 1 to {it:#} lags and choose
the regression for which the AIC is minimized.  This process is done for
each panel so that different panels may use ADF regressions with different
numbers of lags.

{pmore}
Specifying {cmd:lags(bic }{it:#}{cmd:)} is just like specifying 
{cmd:lags(aic }{it:#}{cmd:)}, except that the BIC is used instead of the AIC.

{pmore}
Specifying {cmd:lags(hqic }{it:#}{cmd:)} is just like specifying 
{cmd:lags(aic }{it:#}{cmd:)}, except that the Hannan-Quinn information
criterion is used instead of the AIC.

{pmore}
If you specify {cmd:lags(0)}, then {cmd:xtunitroot} reports the W_t-bar 
statistic instead of the Z_t-bar, Z_tilde-t-bar, and t-bar statistics.

    {title:Fisher_options}

{phang}
{opt dfuller} requests that {cmd:xtunitroot} conduct ADF unit-root tests on
each panel by using the {cmd:dfuller} command.  You must specify either the
{opt dfuller} or the {opt pperron} option.

{phang}
{opt pperron} requests that {cmd:xtunitroot} conduct Phillips-Perron 
unit-root tests on each panel by using the {cmd:pperron} command.  You 
must specify either the {opt pperron} or the {opt dfuller} option.
 
{phang}
{opt lags(#)} specifies the number of lags used to remove 
higher-order autoregressive components of the series.  The Fisher test 
assumes the data are generated by an AR(1) process; for higher-order 
processes, the first-differenced and lagged-level data are replaced by 
the residuals from regressions of those two series on the first {it:#} 
lags of the first-differenced data.  {opt lags(#)} is required.

{phang}
{opt demean} requests that {cmd:xtunitroot} first subtract the 
cross-sectional averages from the series.  When specified, for each 
time period {cmd:xtunitroot} computes the mean of the series across 
panels and subtracts this mean from the series.  Levin, Lin, and Chu 
suggest this procedure to mitigate the impact of cross-sectional 
dependence.

{phang}
{it:dfuller_opts} are any options accepted by the {cmd:dfuller} command, 
including {opt noconstant}, {opt trend}, {opt drift}, and
{opt lags()}.  Because {cmd:xtunitroot} calls {helpb dfuller} {cmd:quietly},
the {cmd:dfuller} option {cmd:regress} has no effect.

{phang}
{it:pperron_opts} are any options accepted by the {cmd:pperron} command, 
including {opt noconstant}, {opt trend}, and
{opt lags()}.  Because {cmd:xtunitroot} calls {helpb pperron} {cmd:quietly},
the {cmd:pperron} option {cmd:regress} has no effect.

    {title:Hadri_options}

{phang}
{opt trend} includes a linear time trend in the model that describes the 
process by which the series is generated.

{phang}
{opt demean} requests that {cmd:xtunitroot} first subtract the 
cross-sectional averages from the series.  When specified, for each 
time period {cmd:xtunitroot} computes the mean of the series across 
panels and subtracts this mean from the series.  Levin, Lin, and Chu 
suggest this procedure to mitigate the impact of cross-sectional 
dependence.

{phang}
{opt robust} requests a variant of the test statistic that is robust to 
heteroskedasticity across panels.

{phang}
{opt kernel(kernel_spec)} requests a variant of the test statistic that 
is robust to serially correlated errors.  {it:kernel_spec} specifies the 
method used to estimate the long-run variance of each panel's series.  
{it:kernel_spec} takes the form {it:kernel} [{it:#}].  Three kernels are 
supported: {cmdab:bartlett}, {cmdab:parzen}, and {cmdab:quadraticspectral}.

{pmore}
Specifying, for example, {cmd:kernel(bartlett 3)} requests the Bartlett 
kernel with 3 lags.

{pmore}
If {it:#} is not specified, then 1 lag is used.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:xtunitroot} implements a variety of tests for unit roots (or 
stationarity) in panel datasets.  Consider the autoregressive model

{pmore}
y_it = a_it + rho_i * y_i,t-1 + e_it

{pstd} 
where e_it is a mean-zero regression error term and 
a_it represents the deterministic part of the model.  
i=1, ..., N indexes panels, and t=1, ..., T indexes time. 
a_it may include panel-specific intercepts (fixed effects), a 
panel-specific time trend, or nothing, in which case y_it is 
predicated to have mean zero for all panels.  

{pstd}
All the tests except for the Hadri LM test investigate null 
hypotheses of the general form Ho: rho_i = 1 versus Ha: rho_i
< 1, though they differ in precisely how Ha is specified.  
The Hadri LM test, rather than assuming a unit root under the null 
hypothesis, assumes that the data are stationary (rho_i < 1) versus the 
alternative that the data contain a unit root.

{pstd}
Here we provide a brief overview of the salient features of each test; 
see {manlink XT xtunitroot} for additional information.

{pstd}
Remarks are presented under the following headings:

{pmore}
{help xtunitroot##LLC:Levin-Lin-Chu test}{break}
{help xtunitroot##HT:Harris-Tzavalis test}{break}
{help xtunitroot##Breitung:Breitung test}{break}
{help xtunitroot##IPS:Im-Pesaran-Shin test}{break}
{help xtunitroot##Fisher:Fisher-type tests}{break}
{help xtunitroot##Hadri:Hadri LM stationarity test}{break}


{marker LLC}{...}
{title:Levin-Lin-Chu test}

{pstd}
The Levin-Lin-Chu (LLC) ({help xtunitroot##LLC2002:2002}) test assumes that all
panels have the same autoregressive parameter, that is, that rho_i = rho for
all i.  Then the alternative hypothesis is simply that rho < 1.  

{pstd}
The LLC test requires that the panels be strongly balanced.

{pstd}
The LLC test is based on a regression t statistic, but because the 
data are nonstationary under the null hypothesis, the asymptotic mean 
and standard deviation of the t statistic depend on the 
specification of the deterministic part of the model.

{pstd}
Levin, Lin, and Chu recommend using their procedure for moderate-sized 
panels, with perhaps between 10 and 250 individuals and 25 to 250 
observations per individual.  If the time-series dimension of the panel 
is very large, then standard unit-root tests can be applied to each 
panel, because the gains from aggregation are likely to be small.

{pstd}
Formally, if there is no deterministic term in the model (a_it = 0), then the
test allows the number of time periods, T, to tend to infinity at a slower rate
than the number of cross-sectional units, N, though T must go to infinity
sufficiently fast that sqrt(N)/T tends to 0.  If fixed effects or time trends
are included in the deterministic part of the model, then T must tend to
infinity at a rate faster than N so that N/T tends to 0.


{marker HT}{...}
{title:Harris-Tzavalis test}

{pstd}
The Harris-Tzavalis (HT) ({help xtunitroot##HT1999:1999}) test is similar to
the LLC test in that it assumes that all panels have the same autoregressive
parameter so that the alternative hypothesis is simply rho < 1.  Differing from
the LLC test, the HT test assumes that the number of time periods, T, is fixed.

{pstd}
Like the LLC test, the HT test requires that the panels be strongly 
balanced.

{pstd}
{help xtunitroot##B2008:Baltagi (2008, 278)} mentions that T being fixed is the
typical case in micropanel studies.  Here you may have a panel dataset of
firms, and it may be more natural to think that if you could increase the
sample size of your dataset, you would do so by collecting data on more firms,
though the number of time periods available for each firm is fixed.


{marker Breitung}{...}
{title:Breitung test}

{pstd}
The LLC and HT tests are based on regression t statistics 
that are subsequently adjusted to reflect the fact that under the null 
hypothesis, the t statistics have a nonzero mean because of the 
inclusion of panel-specific means or trends.  The 
{help xtunitroot##B2000:Breitung (2000)} test takes a 
different approach, transforming the data before computing the 
regressions so that the standard t statistics can be used.

{pstd}
The Breitung test requires that the panels be strongly balanced.

{pstd}
When the {opt robust} option is specified, a version of the 
t statistic that is robust to cross-sectional correlation of the 
error terms is reported.  This statistic has an asymptotically normal 
distribution when first T tends to infinity followed by N 
tending to infinity.

{pstd}
The Breitung test assumes that all panels have a common autoregressive 
parameter.  The null hypothesis is that all series contain a unit root.  
The alternative hypothesis is that rho < 1 so that the series are 
stationary.  {help xtunitroot##BD2005:Breitung and Das (2005)}
remark that the test also has power 
in the heterogeneous case, where each panel is allowed to have its own 
autoregressive parameter, though the test is optimal in the case where 
all panels have the same autoregressive parameter.

{pstd}
The {help xtunitroot##B2000:Breitung (2000)}
Monte Carlo simulations suggest that his test is 
substantially more powerful than other panel unit-root tests for the 
modest-size dataset he considered (N=20, T=30).


{marker IPS}{...}
{title:Im-Pesaran-Shin test}

{pstd}
A major limitation of the LLC, HT, and Breitung tests is the 
assumption that all panels have the same value of rho.  The 
Im-Pesaran-Shin (IPS) ({help xtunitroot##IPS2003:2003})
test relaxes the assumption of a common rho 
and instead allows each panel to have its own rho_i.  The null 
hypothesis is that all panels have a unit root (Ho: rho_i = 0 for 
all i).  The alternative hypothesis is that the fraction of panels 
that are stationary is nonzero.  Specifically, if we let N_1
denote the number of stationary panels, then the fraction 
N_1/N tends to a nonzero fraction as N tends to 
infinity.  This allows some (but not all) of the panels to possess unit 
roots under the alternative hypothesis.

{pstd}
The IPS test does not require strongly balanced data, but there can be 
no gaps in each individual time series.

{pstd}
When the errors are assumed to be serially uncorrelated, imposed by 
either specifying the {cmd:lags(0)} option or not specifying the 
{opt lag()} option at all, {cmd:xtunitroot ips} reports IPS's t-bar, 
t-tilde-bar, and Z_t-tilde-bar statistics.  These statistics assume that the 
number of time periods, T, is fixed.  When there are no gaps in the 
data, {cmd:xtunitroot ips} reports exact critical values for the t-bar 
statistic that are predicated on the number of panels, N, also being 
fixed.  The other two statistics assume N tends to infinity.

{pstd} 
For the asymptotic normal distribution of Z_t-tilde-bar to hold, T 
must be at least 5 if the dataset is strongly balanced and the 
deterministic part of the model includes only panel-specific means, or at 
least 6 if time trends are also included.  If the data are not strongly 
balanced, then T must be at least 9 for the asymptotic distribution 
to hold.  If these limits on T are not met, the p-value for 
Z_t-tilde-bar is not reported.

{pstd}
When serial correlation in the error terms is accommodated by using the 
{opt lags()} option with {cmd:xtunitroot ips}, then IPS's 
W_t-bar statistic is reported.  This statistic is asymptotically 
normally distributed when first T tends to infinity followed by 
N tending to infinity.  


{marker Fisher}{...}
{title:Fisher-type tests}

{pstd}
Fisher-type tests approach testing for panel-data unit roots from a
meta-analysis perspective.  That is, these tests conduct unit-root tests for
each panel individually, and then combine the p-values from these tests to
produce an overall test.  {cmd:xtunitroot fisher} supports ADF tests with the
{opt dfuller} option and Phillips-Perron tests with the {opt pperron} option.
Any options allowed by {cmd:dfuller} or {cmd:pperron}
can be specified (except the {cmd:regress} option has no effect).

{pstd}
{cmd:xtunitroot fisher} does not require strongly balanced data, and 
the individual series can have gaps.

{pstd}
These tests assume that T tends to infinity.  If the number of 
panels, N, is fixed, then these tests are consistent against the 
alternative that at least one panel is stationary.  If we allow N 
to tend to infinity, then the number of panels that do not have a unit 
root must grow at the same rate as N for the tests to be 
consistent.

{pstd}
{cmd:xtunitroot fisher} combines p-values using the inverse chi-squared,
inverse-normal, and inverse-logit transformations.  Also a modified version of
the inverse chi-squared transformation proposed by
{help xtunitroot##C2001:Choi (2001)} is reported for
use when N is believed to tend to infinity, because here the standard inverse
chi-squared test statistic goes to infinity.


{marker Hadri}{...}
{title:Hadri LM stationarity test}

{pstd}
All the tests discussed thus far have as the null hypothesis that the 
data contain a unit root.  As 
{help xtunitroot##H2000:Hadri (2000)} notes, classical hypothesis 
testing requires strong evidence to the contrary to reject the 
null hypothesis.  Thus we may also want to conduct a test in which the 
null and alternative hypotheses are reversed, to help confirm or deny 
conclusions based on tests with the null hypothesis being 
nonstationarity.

{pstd}
The Hadri LM test requires that the panels be strongly balanced.

{pstd}
The Hadri LM test has as the null hypothesis that 
all the panels are stationary, perhaps around a linear trend if the 
{opt trend} option is specified.  The alternative hypothesis is that 
at least some of the panels contain a unit root.  The test assumes that 
the model error terms are normally distributed.  The test is justified 
asymptotically as T tends to infinity followed by N tending to 
infinity.  Hadri states that his tests are appropriate for panel 
datasets in which T is large and N is moderate, such as the 
Penn World Tables frequently used for cross-country comparisons.


{marker examples}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}{cmd:. webuse pennxrate}

{pstd}
LLC test, using the AIC to choose the number of lags for regressions and
using an HAC variance estimator based on the Bartlett kernel and the number of
lags chosen using Newey and West's method{p_end}
{phang2}{cmd:. xtunitroot llc lnrxrate if oecd, demean lags(aic 10) kernel(bartlett nwest)}{p_end}

{pstd}
HT test, removing cross-sectional means from data{p_end}
{phang2}{cmd:. xtunitroot ht lnrxrate, demean}{p_end}

{pstd}
Robust version of the Breitung test on a subset of OECD countries, using
3 lags for the prewhitening step{p_end}
{phang2}{cmd:. xtunitroot breitung lnrxrate if g7, lags(3) robust}{p_end}

{pstd}
IPS test, using the AIC to choose the number of lags for regressions{p_end}
{phang2}{cmd:. xtunitroot ips lnrxrate, lags(aic 5)}{p_end}

{pstd}
Fisher-type test based on ADF tests with 3 lags,
allowing for a drift term in each panel{p_end}
{phang2}{cmd:. xtunitroot fisher lnrxrate, dfuller lags(3) drift}{p_end}

{pstd}
Hadri LM test of stationarity, using an HAC variance estimator based on
the Parzen kernel with 5 lags{p_end}
{phang2}{cmd:. xtunitroot hadri lnrxrate, kernel(parzen 5)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:xtunitroot llc} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(N_g)}}number of groups{p_end}
{synopt:{cmd:r(N_t)}}number of time periods {p_end}
{synopt:{cmd:r(sig_adj)}}standard deviation adjustment{p_end}
{synopt:{cmd:r(mu_adj)}}mean adjustment{p_end}
{synopt:{cmd:r(delta)}}pooled estimate of delta{p_end}
{synopt:{cmd:r(se_delta)}}pooled standard error of delta hat{p_end}
{synopt:{cmd:r(Var_ep)}}variance of whitened differenced series{p_end}
{synopt:{cmd:r(sbar)}}mean of ratio of long-run to innovation standard deviations{p_end}
{synopt:{cmd:r(ttilde)}}observations per panel after lagging and differencing{p_end}
{synopt:{cmd:r(td)}}unadjusted t_delta statistic{p_end}
{synopt:{cmd:r(p_td)}}p-value for t_delta{p_end}
{synopt:{cmd:r(tds)}}adjusted t_delta_star statistic{p_end}
{synopt:{cmd:r(p_tds)}}p-value for t_delta_star{p_end}
{synopt:{cmd:r(hac_lags)}}lags used in HAC variance estimator{p_end}
{synopt:{cmd:r(hac_lagm)}}average lags used in HAC variance estimator{p_end}
{synopt:{cmd:r(adf_lags)}}lags used in ADF regressions{p_end}
{synopt:{cmd:r(adf_lagm)}}average lags used in ADF regressions{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(test)}}{cmd:llc}{p_end}
{synopt:{cmd:r(hac_kernel)}}kernel used in HAC variance estimator{p_end}
{synopt:{cmd:r(hac_method)}}HAC lag-selection algorithm{p_end}
{synopt:{cmd:r(adf_method)}}ADF regression lag-selection criterion{p_end}
{synopt:{cmd:r(demean)}}{cmd:demean}, if the data were demeaned{p_end}
{synopt:{cmd:r(deterministics)}}{cmd:noconstant}, {cmd:constant}, or {cmd:trend}{p_end}


{pstd}
{cmd:xtunitroot ht} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(N_g)}}number of groups{p_end}
{synopt:{cmd:r(N_t)}}number of time periods {p_end}
{synopt:{cmd:r(rho)}}estimated rho{p_end}
{synopt:{cmd:r(Var_rho)}}variance of rho under H_0{p_end}
{synopt:{cmd:r(mean_rho)}}mean of rho under H_0{p_end}
{synopt:{cmd:r(z)}}z statistic{p_end}
{synopt:{cmd:r(p)}}p-value{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(test)}}{cmd:ht}{p_end}
{synopt:{cmd:r(demean)}}{cmd:demean}, if the data were demeaned{p_end}
{synopt:{cmd:r(deterministics)}}{cmd:noconstant}, {cmd:constant}, or {cmd:trend}{p_end}
{synopt:{cmd:r(altt)}}{cmd:altt}, if {cmd:altt} specified{p_end}


{pstd}
{cmd:xtunitroot breitung} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(N_g)}}number of groups{p_end}
{synopt:{cmd:r(N_t)}}number of time periods {p_end}
{synopt:{cmd:r(lambda)}}test statistic lambda{p_end}
{synopt:{cmd:r(lrobust)}}robust test statistic lambda_R{p_end}
{synopt:{cmd:r(p)}}p-value for lambda{p_end}
{synopt:{cmd:r(p_lrobust)}}p-value for lambda_R{p_end}
{synopt:{cmd:r(lags)}}lags used for prewhitening{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(test)}}{cmd:breitung}{p_end}
{synopt:{cmd:r(demean)}}{cmd:demean}, if the data were demeaned{p_end}
{synopt:{cmd:r(robust)}}{cmd:robust}, if specified{p_end}
{synopt:{cmd:r(deterministics)}}{cmd:noconstant}, {cmd:constant}, or {cmd:trend}{p_end}


{pstd}
{cmd:xtunitroot ips} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(N_g)}}number of groups{p_end}
{synopt:{cmd:r(N_t)}}number of time periods {p_end}
{synopt:{cmd:r(tbar)}}test statistic t-bar{p_end}
{synopt:{cmd:r(cv_10)}}exact 10% critical value for t-bar{p_end}
{synopt:{cmd:r(cv_5)}}exact 5% critical value for t-bar{p_end}
{synopt:{cmd:r(cv_1)}}exact 1% critical value for t-bar{p_end}
{synopt:{cmd:r(zt)}}test statistic Z_t-bar{p_end}
{synopt:{cmd:r(ttildebar)}}test statistic t-tilde-bar{p_end}
{synopt:{cmd:r(zttildebar)}}test statistic Z_t-tilde-bar{p_end}
{synopt:{cmd:r(p_zttildebar)}}p-value for Z_t-tilde-bar{p_end}
{synopt:{cmd:r(wtbar)}}test statistic W_t-bar{p_end}
{synopt:{cmd:r(p_wtbar)}}p-value for W_t-bar {p_end}
{synopt:{cmd:r(lags)}}lags used in ADF regressions{p_end}
{synopt:{cmd:r(lagm)}}average lags used in ADF regressions{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(test)}}{cmd:ips}{p_end}
{synopt:{cmd:r(demean)}}{cmd:demean}, if the data were demeaned{p_end}
{synopt:{cmd:r(adf_method)}}ADF regression lag-selection criterion{p_end}
{synopt:{cmd:r(deterministics)}}{cmd:constant} or {cmd:trend}{p_end}


{pstd}
{cmd:xtunitroot fisher} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(N_g)}}number of groups{p_end}
{synopt:{cmd:r(N_t)}}number of time periods {p_end}
{synopt:{cmd:r(P)}}inverse chi-squared P statistic{p_end}
{synopt:{cmd:r(df_P)}}P statistic degrees of freedom{p_end}
{synopt:{cmd:r(p_P)}}p-value for P statistic{p_end}
{synopt:{cmd:r(L)}}inverse logit L statistic{p_end}
{synopt:{cmd:r(df_L)}}L statistic degrees of freedom{p_end}
{synopt:{cmd:r(p_L)}}p-value for L statistic{p_end}
{synopt:{cmd:r(Z)}}inverse normal Z statistic{p_end}
{synopt:{cmd:r(p_Z)}}p-value for Z statistic{p_end}
{synopt:{cmd:r(Pm)}}modified inverse chi-squared P_m statistic{p_end}
{synopt:{cmd:r(p_Pm)}}p-value for P_m statistic{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(test)}}{cmd:fisher}{p_end}
{synopt:{cmd:r(urtest)}}{cmd:dfuller} or {cmd:pperron}{p_end}
{synopt:{cmd:r(options)}}options passed to {cmd:dfuller} or {cmd:pperron}{p_end}
{synopt:{cmd:r(demean)}}{cmd:demean}, if the data were demeaned{p_end}


{pstd}
{cmd:xtunitroot hadri} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(N_g)}}number of groups{p_end}
{synopt:{cmd:r(N_t)}}number of time periods {p_end}
{synopt:{cmd:r(var)}}variance of z under Ho{p_end}
{synopt:{cmd:r(mu)}}mean of z under Ho{p_end}
{synopt:{cmd:r(z)}}test statistic z{p_end}
{synopt:{cmd:r(p)}}p-value for z{p_end}
{synopt:{cmd:r(lags)}}lags used for HAC variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(test)}}{cmd:hadri}{p_end}
{synopt:{cmd:r(demean)}}{cmd:demean}, if the data were demeaned{p_end}
{synopt:{cmd:r(robust)}}{cmd:robust}, if specified{p_end}
{synopt:{cmd:r(kernel)}}kernel used for HAC variance{p_end}
{synopt:{cmd:r(deterministics)}}{cmd:constant} or {cmd:trend}{p_end}


{marker references}{...}
{title:References}

{marker B2008}{...}
{phang}
Baltagi, B. H. 2008.
{browse "http://www.stata.com/bookstore/eapd.html":{it:Econometric Analysis of Panel Data}. 4th ed.}
New York: Wiley.

{marker B2000}{...}
{phang}
Breitung, J. 2000.
The local power of some unit root tests for panel data.
In {it:Advances in Econometrics, Volume 15:}
{it:Nonstationary Panels, Panel Cointegration, and Dynamic Panels},
ed. B. H. Baltagi, 161-178.  Amsterdam: JAI Press.

{marker BD2005}{...}
{phang}
Breitung, J., and S. Das. 2005.
Panel unit root tests under cross-sectional dependence.
{it:Statistica Neerlandica} 59: 414-433.

{marker C2001}{...}
{phang}
Choi, I. 2001.
Unit root tests for panel data.
{it:Journal of International Money and Finance} 20: 249-272.

{marker H2000}{...}
{phang}
Hadri, K. 2000.
Testing for stationarity in heterogeneous panel data.
{it:Econometrics Journal} 3: 148-161.

{marker HT1999}{...}
{phang}
Harris, R. D. F., and E. Tzavalis. 1999.
Inference for unit roots in dynamic panels where the time dimension is fixed.
{it:Journal of Econometrics} 91: 201-226.

{marker IPS2003}{...}
{phang}
Im, K. S., M. H. Pesaran, and Y. Shin. 2003.
Testing for unit roots in heterogeneous panels.
{it:Journal of Econometrics} 115: 53-74.

{marker LLC2002}{...}
{phang}
Levin, A., C.-F. Lin, and C.-S. J. Chu. 2002.
Unit root tests in panel data: Asymptotic and finite-sample properties.
{it:Journal of Econometrics} 108: 1-24.

{marker NW1994}{...}
{phang}
Newey, W. K., and K. D. West. 1994.
Automatic lag selection in covariance matrix estimation.
{it:Review of Economic Studies} 61: 631-653.
{p_end}
