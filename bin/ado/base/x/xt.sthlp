{smcl}
{* *! version 1.2.9  20jun2019}{...}
{vieweralsosee "[XT] xt" "mansection XT xt"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtset" "help xtset"}{...}
{viewerjumpto "Description" "xt##description"}{...}
{viewerjumpto "Links to PDF documentation" "xt##linkspdf"}{...}
{viewerjumpto "Example" "xt##example"}{...}
{p2colset 1 12 14 2}{...}
{p2col:{bf:[XT] xt} {hline 2}}Introduction to xt commands{p_end}
{p2col:}({mansection XT xt:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The xt series of commands provide tools for analyzing panel data (also known
as longitudinal data or, in some disciplines, as cross-sectional time series
when there is an explicit time component).   Panel datasets have the form
{bf:x}_[it], where {bf:x}_[it] is a vector of observations for unit i and
time t.  The particular commands (such as {cmd:xtdescribe}, {cmd:xtsum}, and
{cmd:xtreg}) are documented in alphabetical order in the entries that follow
this entry.  If you do not know the name of the command you need, try browsing
the second part of this description section, which organizes the xt commands by
topic.  {it:{mansection XT xtRemarksandexamples:Remarks and examples}} of
{bf:[XT] xt} describes concepts that are common across commands.

{pstd}
The {cmd:xtset} command sets the panel variable and the time variable; see
{helpb xtset:[XT] xtset}.  Most xt commands require that the panel variable be
specified, and some require that the time variable also be specified.  Once you
{cmd:xtset} your data, you need not do it again.  The {cmd:xtset} information
is stored with your data.

{pstd}
If you have previously {cmd:tsset} your data by using both a panel and a time
variable, these settings will be recognized by {cmd:xtset}, and you need not
{cmd:xtset} your data.

{pstd}
If your interest is in general time-series analysis, see
{findalias frestts} and the
{it:{mansection TS tsTimeSeries:Time-Series Reference Manual}}.
If your interest is in multilevel mixed-effects models, see the
{it:{mansection ME meMultilevelMixedEffects:Multilevel Mixed-Effects Reference Manual}}.
If you are interested in SAR (spatial autoregressive or simultaneously
autoregressive) models for panel data, see {manhelp spxtregress SP}.
If you are interested in extended panel-data regression
models that address endogenous covariates, nonrandom treatment assignment,
and endogenous sample selection, see the
{it:{mansection ERM ermExtendedRegression:Extended Regression Models Reference Manual}}.


    {title:Setup}

{p 8 26 2}{helpb xtset} {space 6} Declare data to be panel data{p_end}


    {title:Data management and exploration tools}

{p 8 26 2}{helpb xtdescribe} {space 1} Describe pattern of xt data{p_end}
{p 8 26 2}{helpb xtsum} {space 6} Summarize xt data{p_end}
{p 8 26 2}{helpb xttab} {space 6} Tabulate xt data{p_end}
{p 8 26 2}{helpb xtdata} {space 5} Faster specification searches with xt data{p_end}
{p 8 26 2}{helpb xtline} {space 5} Panel-data line plots{p_end}


    {title:Linear regression estimators}

{p 8 26 2}{helpb xtreg} {space 6} Fixed-, between-, and random-effects, and population-averaged linear models{p_end}
{p 8 26 2}{helpb xtregar} {space 4} Fixed- and random-effects linear models with an AR(1) disturbance{p_end}
{p 8 26 2}{helpb xtgls} {space 6} Fit panel-data models using GLS{p_end}
{p 8 26 2}{helpb xtpcse} {space 5} Linear regression with panel-corrected standard errors{p_end}
{p 8 26 2}{helpb xthtaylor} {space 2} Hausman-Taylor estimator for error-components models{p_end}
{p 8 26 2}{helpb xtfrontier} {space 1} Stochastic frontier models for panel data{p_end}
{p 8 26 2}{helpb xtrc} {space 7} Random-coefficients model{p_end}
{p 8 26 2}{helpb xtivreg} {space 4} Instrumental variables and two-stage least squares for panel-data models{p_end}
{p 8 26 2}{helpb xtheckman} {space 2} Random-effects regression with sample selection{p_end}
{p 8 26 2}{helpb xteregress} {space 1} Random-effects models with endogenous
covariates, treatment, and sample selection{p_end}


    {title:Unit-root tests}

{p 8 26 2}{helpb xtunitroot} {space 1} Panel-data unit-root tests{p_end}


    {title:Cointegration tests}

{p 8 26 2}{helpb xtcointtest} {space 1} Panel-data cointegration tests{p_end}


    {title:Dynamic panel-data estimators}

{p 8 26 2}{helpb xtabond} {space 4} Arellano-Bond linear dynamic panel-data estimation{p_end}
{p 8 26 2}{helpb xtdpd} {space 6} Linear dynamic panel-data estimation{p_end}
{p 8 26 2}{helpb xtdpdsys} {space 3} Arellano-Bover/Blundell-Bond linear dynamic panel-data estimation{p_end}


    {title:Censored-outcome estimators}

{p 8 26 2}{helpb xttobit} {space 4} Random-effects tobit models{p_end}
{p 8 26 2}{helpb xtintreg} {space 3} Random-effects interval-data regression models{p_end}
{p 8 26 2}{helpb xteintreg} {space 2} Random-effects interval-data regression models with endogenous covariates, treatment, and sample selection{p_end}


    {title:Binary-outcome estimators}

{p 8 26 2}{helpb xtlogit} {space 4} Fixed-effects, random-effects, and population-averaged logit models{p_end}
{p 8 26 2}{helpb xtprobit} {space 3} Random-effects and population-averaged probit models{p_end}
{p 8 26 2}{helpb xtcloglog}{space 4}Random-effects and population-averaged cloglog models{p_end}
{p 8 26 2}{helpb xteprobit} {space 2} Random-effects probit models with endogenous covariates, treatment, and sample selection{p_end}


    {title:Ordinal-outcome estimators}

{p 8 26 2}{helpb xtologit} {space 4} Random-effects ordered logistic models{p_end}
{p 8 26 2}{helpb xtoprobit} {space 3} Random-effects ordered probit models{p_end}
{p 8 26 2}{helpb xteoprobit} {space 2} Random-effects ordered probit models with endogenous covariates, treatment, and sample selection{p_end}


    {title:Count-data estimators}

{p 8 26 2}{helpb xtpoisson}{space 4}Fixed-effects, random-effects, and population-averaged Poisson models{p_end}
{p 8 26 2}{helpb xtnbreg} {space 4} Fixed-effects, random-effects, & population-averaged negative binomial models{p_end}


    {title:Survival-time estimators}

{p 8 26 2}{helpb xtstreg}{space 6}Random-effects parametric survival models{p_end}


    {title:Generalized estimating equations estimator}

{p 8 26 2}{helpb xtgee} {space 6} Population-averaged panel-data models using GEE{p_end}


    {title:Utilities}

{p 8 26 2}{helpb quadchk} {space 4} Check sensitivity of quadrature approximation{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker example}{...}
{title:Example}

{pstd}
An xt dataset:

	 pid  yr_visit  fev  age  sex   height  smokes
	{hline 46}
	1071    1991   1.21   25   1      69       0
	1071    1992   1.52   26   1      69       0
	1071    1993   1.32   28   1      68       0
	1072    1991   1.33   18   1      71       1
	1072    1992   1.18   20   1      71       1
	1072    1993   1.19   21   1      71       0

{pstd}
The other xt commands need to know the identities of the variables
identifying patient and time.  You could type

	{cmd:. xtset pid yr_visit}
