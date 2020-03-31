{smcl}
{* *! version 1.0.3  19dec2018}{...}
{viewerdialog xtcointtest "dialog xtcointtest"}{...}
{vieweralsosee "[XT] xtcointtest" "mansection XT xtcointtest"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] dfgls" "help dfgls"}{...}
{vieweralsosee "[TS] dfuller" "help dfuller"}{...}
{vieweralsosee "[TS] pperron" "help pperron"}{...}
{vieweralsosee "[XT] xtunitroot" "help xtunitroot"}{...}
{viewerjumpto "Syntax" "xtcointtest##syntax"}{...}
{viewerjumpto "Menu" "xtcointtest##menu"}{...}
{viewerjumpto "Description" "xtcointtest##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtcointtest##linkspdf"}{...}
{viewerjumpto "Options for xtcointtest kao" "xtcointtest##options_kao"}{...}
{viewerjumpto "Options for xtcointtest pedroni" "xtcointtest##options_pedroni"}{...}
{viewerjumpto "Options for xtcointtest westerlund" "xtcointtest##options_westerlund"}{...}
{viewerjumpto "Examples" "xtcointtest##examples"}{...}
{viewerjumpto "Stored results" "xtcointtest##results"}{...}
{viewerjumpto "References" "xtcointtest##references"}{...}
{p2colset 1 21 25 2}{...}
{p2col:{bf:[XT] xtcointtest} {hline 2}}Panel-data cointegration tests{p_end}
{p2col:}({mansection XT xtcointtest:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Kao test

{p 8 16 2}
{cmd:xtcointtest} {cmd:kao}
{depvar}
{varlist}
{ifin}
[{cmd:,} {it:{help xtcointtest##kao_options:kao_options}}]


{phang}
Pedroni test

{p 8 16 2}
{cmd:xtcointtest} {cmd:pedroni}
{depvar}
{varlist}
{ifin}
[{cmd:,} {it:{help xtcointtest##pedroni_options:pedroni_options}}]


{phang}
Westerlund test

{p 8 16 2}
{cmd:xtcointtest} {cmd:westerlund}
{depvar}
{varlist}
{ifin}
[{cmd:,} {it:{help xtcointtest##westerlund_options:westerlund_options}}]


{synoptset 25 tabbed}{...}
{marker kao_options}{...}
{synopthdr:kao_options}
{synoptline}
{syntab:Main}
{synopt :{opth l:ags(xtcointtest##lspec:lspec)}}specify lag structure for
augmented Dickey-Fuller regressions{p_end}
{synopt :{opth kernel:(xtcointtest##kspec:spec)}}specify method to estimate
long-run variance{p_end}
{synopt :{opt demean}}subtract cross-sectional means{p_end}
{synoptline}

{marker pedroni_options}{...}
{synopthdr:pedroni_options}
{synoptline}
{syntab:Main}
{synopt :{cmd:ar(}{cmdab:panels:pecific}|{cmd:same)}}specify autoregressive parameter as panel specific or as the same 
    for all panels; {cmd:ar(panelspecific)} is the default{p_end}
{synopt :{opt t:rend}}include panel-specific time trends{p_end}
{synopt :{opt nocons:tant}}suppress panel-specific means{p_end}
{synopt :{opth l:ags(xtcointtest##lspec:lspec)}}specify lag
structure for augmented Dickey-Fuller regressions{p_end}
{synopt :{opth kernel:(xtcointtest##kspec:kspec)}}specify method to estimate
long-run variance{p_end}
{synopt :{opt demean}}subtract cross-sectional means{p_end}
{synoptline}

{marker westerlund_options}{...}
{synopthdr:westerlund_options}
{synoptline}
{syntab:Main}
{synopt :{opt some:panels}}use alternative hypothesis of cointegration in
some panels; the default{p_end}
{synopt :{opt all:panels}}use alternative hypothesis of cointegration in all
panels{p_end}
{synopt :{opt t:rend}}include panel-specific time trends{p_end}
{synopt :{opt demean}}subtract cross-sectional means{p_end}
{synoptline}
{p2colreset}{...}

{marker lspec}{...}
{phang}
{it:lspec} is{p_end}
{synoptset 25 tabbed}{...}
{synopt :{it:#}}number of lags of series; {cmd:1} is the default{p_end}
{synopt :{opt aic} {it:#}}Akaike information criterion (AIC) with up to {it:#}
lags{p_end}
{synopt :{opt bic} {it:#}}Bayesian information criterion (BIC) with up to
{it:#} lags{p_end}
{synopt :{opt hqic} {it:#}}Hannan-Quinn information criterion (HQIC) with up
to {it:#} lags{p_end}

{marker kspec}{...}
{phang}
{it:kspec} is{p_end}
{synopt :{opt ba:rtlett} {opt nw:est}}Bartlett kernel with Newey-West lags;
the default{p_end}
{synopt :{opt ba:rtlett} {it:#}}Bartlett kernel with up to {it:#} lags{p_end}
{synopt :{opt pa:rzen} {opt nw:est}}Parzen kernel with Newey-West lags{p_end}
{synopt :{opt pa:rzen} {it:#}}Parzen kernel with up to {it:#} lags{p_end}
{synopt :{opt qu:adraticspectral} {opt nw:est}}quadratic spectral kernel with
Newey-West lags{p_end}
{synopt :{opt qu:adraticspectral} {it:#}}quadratic spectral kernel with up to
{it:#} lags{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Longitudinal/panel data > Cointegrated data > Tests for cointegration}


{marker description}{...}
{title:Description}

{pstd}
{cmd:xtcointtest} performs the {help xtcointtest##K1999:Kao (1999)},
{help xtcointtest##P1999:Pedroni (1999}, {help xtcointtest##P2004:2004}),
and {help xtcointtest##W2005:Westerlund (2005)} tests of cointegration on a
panel dataset.  Panel-specific means (fixed effects) and panel-specific time
trends may be included in the cointegrating regression model.

{pstd}
All tests have a common null hypothesis of no cointegration.  The
alternative hypothesis of the Kao tests and the Pedroni tests is that the
variables are cointegrated in all panels.  In one version of the Westerlund
test, the alternative hypothesis is that the variables are cointegrated
in some of the panels.  In another version of the Westerlund test, the
alternative hypothesis is that the variables are cointegrated in all the
panels.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtcointtestQuickstart:Quick start}

        {mansection XT xtcointtestRemarksandexamples:Remarks and examples}

        {mansection XT xtcointtestMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_kao}{...}
{title:Options for xtcointtest kao}

{dlgtab:Main}

{phang}
{opth lags:(xtcointtest##lspec:lspec)} 
specifies the lag structure to use for the augmented Dickey-Fuller
(ADF) regressions performed in computing the test statistic. 

{phang2}
{opt lags(#)} specifies that {it:#} lags of the series be used in the
ADF regressions.  {it:#} must be a nonnegative integer. The default 
is {cmd:lags(1)}.

{phang2}
{cmd:lags(aic}|{cmd:bic}|{cmd:hqic} {it:#}{cmd:)} specifies that
{cmd:xtcointtest} fit ADF regressions with 1 to {it:#} lags and choose the
number of lags for which the AIC, BIC, or HQIC is minimized.  

{phang}
{opth kernel:(xtcointtest##kspec:kspec)} 
specifies the method used to estimate the long-run variance of each panel's
series.  You may specify the kernel type and either {it:#}, the maximum number
of lags as a positive integer, or {cmd:nwest}, the maximum number of lags
selected by  the bandwidth-selection algorithm given in
{help xtcointtest##NW1994:Newey and West (1994)}.  The kernel type may be
{cmd:bartlett}, {cmd:parzen}, or {cmd:quadraticspectral}.  The default is
{cmd:kernel(bartlett nwest)}.

{phang}
{opt demean} specifies that {opt xtcointtest} first subtract the
cross-sectional averages from the series.  When specified, for each
time period {opt xtcointtest} computes the mean of the series across
panels and subtracts this mean from the series.
{help xtcointtest##LLC2002:Levin, Lin, and Chu (2002)} suggest
this procedure to mitigate the impact of cross-sectional dependence.


{marker options_pedroni}{...}
{title:Options for xtcointtest pedroni}

{dlgtab:Main}

{phang}
{cmd:ar(panelspecific}|{cmd:same)} specifies whether the AR parameter for ADF
or Phillips-Perron (PP) regressions is panel specific or the same across
panels. 

{phang2}
{cmd:ar(panelspecific)} specifies that the AR parameter be panel specific in
the ADF or PP regressions. The test statistics obtained from using this option
are also known as group-mean statistics or between-dimension statistics.  This
is the default.

{phang2}
{cmd:ar(same)} specifies that the AR parameter be the same for all panels in
the ADF or PP regressions. The test statistics obtained from using this option
are also known as panel cointegration statistics or within-dimension
statistics.

{phang}
{opt trend} includes panel-specific linear time trends in the model for the
dependent variable on the covariates.

{phang}
{opt noconstant} suppresses the panel-specific means in the model for the
dependent variable on the covariates.  Specifying {opt noconstant} imposes the
assumption that the series has a mean of zero for all panels.  This option may
not be specified with {cmd:trend}.

{phang}
{opth lags:(xtcointtest##lspec:lspec)} 
specifies the lag structure to use for the ADF regressions performed in
computing the test statistic.  See the description of {opt lags()} under 
{it:{help xtcointtest##options_kao:Options for xtcointtest kao}} for additional 
details.

{phang}
{opth kernel:(xtcointtest##kspec:kspec)} 
specifies the method used to estimate the long-run variance of each panel's
series.  See the description of {opt kernel()} under 
{it:{help xtcointtest##options_kao:Options for xtcointtest kao}} for additional 
details.

{phang}
{opt demean} specifies that {opt xtcointtest} first subtract the
cross-sectional averages from the series.  See the description of {opt demean}
under {it:{help xtcointtest##options_kao:Options for xtcointtest kao}} for
additional details.


{marker options_westerlund}{...}
{title:Options for xtcointtest westerlund}

{dlgtab:Main}

{phang}
{opt somepanels} specifies that the test statistic for panel cointegration
be computed using the alternative hypothesis that some of the panels
are cointegrated.  This statistic is also known as the group-mean
variance-ratio (VR) statistic. This option uses a regression in which
the AR parameter for Dickey-Fuller (DF) regressions is panel specific.  This
is the default.

{phang}
{opt allpanels} 
specifies that the test statistic for panel cointegration be computed using
the alternative hypothesis that all the panels are cointegrated, also known as
the panel VR statistic.  This option also implies that the AR parameter for DF
regressions is the same for all panels. 

{phang}
{opt trend} includes panel-specific linear time trends in the model for
dependent variable on the covariates.

{phang}
{opt demean} specifies that {opt xtcointtest} first subtract the
cross-sectional averages from the series. 
See the description of {opt demean} under 
{it:{help xtcointtest##options_kao:Options for xtcointtest kao}} for additional 
details.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse xtcoint}

{pstd}Perform the Kao test of no cointegration between {cmd:productivity},
{cmd:rddomestic}, and {cmd:rdforeign}{p_end}
{phang2}{cmd:. xtcointtest kao productivity rddomestic rdforeign}

{pstd}Perform the Predoni test of no cointegration between {cmd:productivity},
{cmd:rddomestic}, and {cmd:rdforeign}{p_end}
{phang2}{cmd:. xtcointtest pedroni productivity rddomestic rdforeign}

{pstd}Perform the Westerlund test of no cointegration between
{cmd:productivity}, {cmd:rddomestic}, and {cmd:rdforeign} with the
alternative hypothesis of cointegration in some panels{p_end}
{phang2}{cmd:. xtcointtest westerlund productivity rddomestic rdforeign}

{pstd}Same as above, but under the alternative hypothesis that all panels are
cointegrated{p_end}
{phang2}{cmd:. xtcointtest westerlund productivity rddomestic rdforeign,}
           {cmd:allpanels}


{marker results}{...}
{title:Stored results}

{pstd}
{opt xtcointtest kao} stores the following in {opt r()}:

{synoptset 25 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt :{cmd:r(N)}}number of observations{p_end}
{synopt :{cmd:r(N_g)}}number of groups{p_end}
{synopt :{cmd:r(N_t)}}number of time periods{p_end}
{synopt :{cmd:r(hac_lagm)}}average lags used in HAC variance
estimator{p_end}
{synopt :{cmd:r(adf_lags)}}lags used in ADF regressions{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt :{cmd:r(test)}}{opt kao}{p_end}
{synopt :{cmd:r(hac_kernel)}}kernel used in HAC variance
estimator{p_end}
{synopt :{cmd:r(hac_method)}}HAC lag-selection algorithm{p_end}
{synopt :{cmd:r(adf_method)}}ADF regression lag-selection
criterion{p_end}
{synopt :{cmd:r(demean)}}{opt demean}, if the data were demeaned{p_end}
{synopt :{cmd:r(deterministics)}}{opt constant}{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt :{cmd:r(stats)}}Kao test statistics{p_end}
{synopt :{cmd:r(p)}}p-values{p_end}

{pstd}
{opt xtcointtest pedroni} stores the following in {opt r()}:

{p2col 5 20 24 2: Scalars}{p_end}
{synopt :{cmd:r(N)}}number of observations{p_end}
{synopt :{cmd:r(N_g)}}number of groups{p_end}
{synopt :{cmd:r(N_t)}}number of time periods{p_end}
{synopt :{cmd:r(hac_lagm)}}average lags used in HAC variance
estimator{p_end}
{synopt :{cmd:r(adf_lags)}}lags used in ADF regressions{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt :{cmd:r(test)}}{opt pedroni}{p_end}
{synopt :{cmd:r(hac_kernel)}}kernel used in HAC variance
estimator{p_end}
{synopt :{cmd:r(hac_method)}}HAC lag-selection algorithm{p_end}
{synopt :{cmd:r(adf_method)}}ADF regression lag-selection
criterion{p_end}
{synopt :{cmd:r(demean)}}{opt demean}, if the data were demeaned{p_end}
{synopt :{cmd:r(deterministics)}}{opt noconstant}, {opt constant}, or
{opt trend}{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt :{cmd:r(stats)}}Pedroni test statistics{p_end}
{synopt :{cmd:r(p)}}p-values{p_end}

{pstd}
{opt xtcointtest westerlund} stores the following in {opt r()}:

{p2col 5 20 24 2: Scalars}{p_end}
{synopt :{cmd:r(N)}}number of observations{p_end}
{synopt :{cmd:r(N_g)}}number of groups{p_end}
{synopt :{cmd:r(N_t)}}number of time periods{p_end}
{synopt :{cmd:r(stat)}}Westerlund test statistic{p_end}
{synopt :{cmd:r(p)}}p-value{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt :{cmd:r(test)}}{opt westerlund}{p_end}
{synopt :{cmd:r(demean)}}{opt demean}, if the data were demeaned{p_end}
{synopt :{cmd:r(deterministics)}}{opt constant} or {opt trend}{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker K1999}{...}
{phang}
Kao, C. 1999. Spurious regression and residual-based tests for cointegration
in panel data. {it:Journal of Econometrics} 90: 1-44.

{marker LLC2002}{...}
{phang}
Levin, A., C.-F. Lin, and C.-S. J. Chu. 2002. Unit root tests in panel data:
Asymptotic and finite-sample properties.
{it:Journal of Econometrics} 108: 1-24.

{marker NW1994}{...}
{phang}
Newey, W. K., and K. D. West. 1987. A simple, positive semi-definite,
heteroskedasticity and autocorrelation consistent
covariance matrix. {it:Econometrica} 55: 703-708.

{marker P1999}{...}
{phang}
Pedroni, P. 1999. Critical values for cointegration tests in heterogeneous
panels with multiple regressors.
{it:Oxford Bulletin of Economics and Statistics} 61: 653-670.

{marker P2004}{...}
{phang}
------. 2004. Panel cointegration: Asymptotic and finite sample properties of
pooled time series tests with an application to the PPP hypothesis.
{it:Econometric Theory} 20: 597-625.

{marker W2005}{...}
{phang}
Westerlund, J. 2005. New simple tests for panel cointegration.
{it:Econometric Reviews} 24: 297-316.
{p_end}
