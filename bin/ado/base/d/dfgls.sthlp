{smcl}
{* *! version 1.1.12  19oct2017}{...}
{viewerdialog dfgls "dialog dfgls"}{...}
{vieweralsosee "[TS] dfgls" "mansection TS dfgls"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] dfuller" "help dfuller"}{...}
{vieweralsosee "[TS] pperron" "help pperron"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "[XT] xtunitroot" "help xtunitroot"}{...}
{viewerjumpto "Syntax" "dfgls##syntax"}{...}
{viewerjumpto "Menu" "dfgls##menu"}{...}
{viewerjumpto "Description" "dfgls##description"}{...}
{viewerjumpto "Links to PDF documentation" "dfgls##linkspdf"}{...}
{viewerjumpto "Options" "dfgls##options"}{...}
{viewerjumpto "Examples" "dfgls##examples"}{...}
{viewerjumpto "Stored results" "dfgls##results"}{...}
{viewerjumpto "References" "dfgls##references"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[TS] dfgls} {hline 2}}DF-GLS unit-root test{p_end}
{p2col:}({mansection TS dfgls:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:dfgls}
{varname}
{ifin}
[{cmd:,}
{it:options}]

{synoptset 13 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt m:axlag(#)}}use {it:#} as the highest lag order for Dickey-Fuller GLS regressions {p_end}
{synopt:{opt not:rend}}series is stationary around a mean instead of around a linear time trend {p_end}
{synopt:{opt ers}}present interpolated critical values from 
   {help dfgls##ERS1996:Elliott, Rothenberg, and Stock (1996)}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
You must {opt tsset} your data before using {opt dfgls}; see {manhelp tsset TS}.
{p_end}
{p 4 6 2}
{it:varname} may contain time-series operators; see {help tsvarlist}.
{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Time series > Tests > DF-GLS test for a unit root}



{marker description}{...}
{title:Description}

{pstd}
{opt dfgls} performs a modified Dickey-Fuller t test for a unit root in
which the series has been transformed by a generalized least-squares
regression.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS dfglsQuickstart:Quick start}

        {mansection TS dfglsRemarksandexamples:Remarks and examples}

        {mansection TS dfglsMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt maxlag(#)} sets the value of k, the highest lag order for the
   first-differenced, detrended variable in the Dickey-Fuller regression.  By
   default, {opt dfgls} sets k according to the method proposed by
   {help dfgls##S1989:Schwert (1989)};
   that is, {opt dfgls} sets k_max=floor[12{(T+1)/100}^(0.25)].

{phang}
{opt notrend} specifies that the alternative hypothesis be that the series
   is stationary around a mean instead of around a linear time trend.  By
   default, a trend is included.

{phang}
{opt ers} specifies that {opt dfgls} should present interpolated
   critical values from tables presented by
   {help dfgls##ERS1996:Elliott, Rothenberg, and Stock (1996)},
   which they obtained from simulations.  See 
   {it:{mansection TS dfglsMethodsandformulascritvalues:Critical values}}
   under {it:Methods and formulas}
   in {bind:{bf:[TS] dfgls}} for details.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse lutkepohl2}

{pstd}Test whether {cmd:ln_inv} exhibits a unit root{p_end}
{phang2}{cmd:. dfgls ln_inv}{p_end}

{pstd}Same as above, but use 8 as the highest lag order for Dickey-Fuller GLS
regressions{p_end}
{phang2}{cmd:. dfgls ln_inv, maxlag(8)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
If {cmd:maxlag(0)} is specified, {cmd:dfgls} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(rmse0)}}RMSE{p_end}
{synopt:{cmd:r(dft0)}}DF-GLS statistic{p_end}

{pstd}
Otherwise, {cmd:dfgls} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(maxlag)}}highest lag order k{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(sclag)}}lag chosen by Schwarz criterion{p_end}
{synopt:{cmd:r(maiclag)}}lag chosen by modified AIC method{p_end}
{synopt:{cmd:r(optlag)}}lag chosen by sequential-t method{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(results)}}k, MAIC, SIC, RMSE, and DF-GLS statistics{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{marker ERS1996}{...}
{phang}
Elliott, G., T. J. Rothenberg, and J. H. Stock. 1996. Efficient tests for an
autoregressive unit root. {it:Econometrica} 64: 813-836.

{marker S1989}{...}
{phang}
Schwert, G. W. 1989. Tests for unit roots: A Monte Carlo investigation.
{it:Journal of Business and Economic Statistics} 2: 147-159.
{p_end}
