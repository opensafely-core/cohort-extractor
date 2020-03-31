{smcl}
{* *! version 1.1.15  12feb2019}{...}
{viewerdialog vecrank "dialog vecrank"}{...}
{vieweralsosee "[TS] vecrank" "mansection TS vecrank"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "[TS] vec" "help vec"}{...}
{vieweralsosee "[TS] vec intro" "help vec_intro"}{...}
{viewerjumpto "Syntax" "vecrank##syntax"}{...}
{viewerjumpto "Menu" "vecrank##menu"}{...}
{viewerjumpto "Description" "vecrank##description"}{...}
{viewerjumpto "Links to PDF documentation" "vecrank##linkspdf"}{...}
{viewerjumpto "Options" "vecrank##options"}{...}
{viewerjumpto "Examples" "vecrank##examples"}{...}
{viewerjumpto "Stored results" "vecrank##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[TS] vecrank} {hline 2}}Estimate the cointegrating rank of a VECM{p_end}
{p2col:}({mansection TS vecrank:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 19 2}
{cmd:vecrank} {depvarlist} {ifin} [{cmd:,} {it:options}]

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt la:gs(#)}}use {it:#} for the maximum lag in underlying VAR model{p_end}
{synopt :{opt t:rend}{cmd:(}{opt c:onstant}{cmd:)}}include an unrestricted constant in model; the default{p_end}
{synopt :{opt t:rend}{cmd:(}{opt rc:onstant}{cmd:)}}include a restricted constant in model{p_end}
{synopt :{opt t:rend}{cmd:(}{opt t:rend}{cmd:)}}include a linear trend in the
  cointegrating equations and a quadratic trend in the undifferenced data{p_end}
{synopt :{opt t:rend}{cmd:(}{opt rt:rend}{cmd:)}}include a restricted trend in model{p_end}
{synopt :{opt t:rend}{cmd:(}{opt n:one}{cmd:)}}do not include a trend or a constant{p_end}

{syntab:Adv. model}
{synopt :{opth si:ndicators(varlist:varlist_si)}}include normalized seasonal
   indicator variables {it:varlist_si}{p_end}
{synopt :{opt noreduce}}do not perform checks and corrections for collinearity
  among lags of dependent variables{p_end}

{syntab:Reporting}
{synopt :{opt notr:ace}}do not report of the trace statistic{p_end}
{synopt :{opt m:ax}}report maximum-eigenvalue statistic{p_end}
{synopt :{opt i:c}}report information criteria{p_end}
{synopt :{opt level99}}report 1% critical values instead of 5% critical 
  values{p_end}
{synopt :{opt levela}}report both 1% and 5% critical values{p_end}
{synoptline}
{p2colreset}{...}
{pstd}You must {cmd:tsset} your data before using {cmd:vecrank}; see
{helpb tsset:[TS] tsset}.{p_end}
{pstd}{depvar} may contain time-series operators; see {help tsvarlist}.
{p_end}
{pstd}{cmd:by}, {cmd:rolling}, and {cmd:statsby} are allowed; see {help prefix}.
{p_end}
{pstd}{cmd:vecrank} does not allow gaps in the data.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate time series > Cointegrating rank of a VECM}


{marker description}{...}
{title:Description}

{pstd}
{cmd:vecrank} produces statistics used to determine the number of
cointegrating equations in a vector error-correction model (VECM).


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS vecrankQuickstart:Quick start}

        {mansection TS vecrankRemarksandexamples:Remarks and examples}

        {mansection TS vecrankMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt lags(#)} specifies the number of lags in the VAR representation of the
model.  The VECM will include one fewer lag of the first differences.  The
number of lags must be greater than zero but small enough so that the degrees
of freedom used by the model are less than the number of observations.

{phang}
{opt trend(trend_spec)} specifies one of five trend specifications to include
in the model.  See {manlink TS vec intro} and
{manlink TS vec} for descriptions.  The default is {cmd:trend(constant)}.

{dlgtab:Adv. model}

{phang}
{opth sindicators:(varlist:varlist_si)} specifies normalized seasonal indicator
variables to be included in the model.  The indicator variables specified in
this option must be normalized as discussed in Johansen (1995, 84).  If the
indicators are not properly normalized, the likelihood-ratio-based tests for
the number of cointegrating equations do not converge to the asymptotic
distributions derived by Johansen.  For details, see
{it:{mansection TS vecMethodsandformulas:Methods and formulas}}
in {bf:[TS] vec}.  {opt sindicators()} cannot be specified with
{cmd:trend(none)} or {cmd:trend(rconstant)}.

{phang} 
{opt noreduce} causes {cmd:vecrank} to skip the checks and corrections for
collinearity among the lags of the dependent variables.  By default, 
{cmd:vecrank} checks whether the current lag specification causes some of the
regressions performed by {cmd:vecrank} to contain perfectly collinear
variables and reduces the maximum lag until the perfect collinearity is
removed.  See {it:{mansection TS vecRemarksandexamplesCollinearity:Collinearity}} in
{bf:[TS] vec} for more information.

{dlgtab:Reporting}

{phang}
{opt notrace} requests that the output for the trace statistic not be
displayed.  The default is to display the trace statistic.

{phang}
{opt max} requests that the output for the maximum-eigenvalue statistic be
displayed.  The default is to not display this output.

{phang}
{opt ic} causes the output for the information criteria to be displayed.  The 
default is to not display this output.

{phang}
{opt level99} causes the 1% critical values to be displayed instead of
the default 5% critical values.

{phang}
{opt levela} causes both the 1% and the 5% critical values to be displayed.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse balance2}{p_end}

{pstd}Estimate the cointegrating rank in a VECM{p_end}
{phang2}{cmd:. vecrank y i c}{p_end}

{pstd}Same as above, but use 5 lags in the underlying VAR
model{p_end}
{phang2}{cmd:. vecrank y i c, lags(5)}{p_end}

{pstd}Same as above, but report 1% critical values instead of 5%{p_end}
{phang2}{cmd:. vecrank y i c, lags(5) level99}{p_end}

{pstd}Same as above, but suppress table of trace statistics and report
maximum-eigenvalue statistic{p_end}
{phang2}{cmd:. vecrank y i c, lags(5) level99 notrace max}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:vecrank} stores the following in {cmd:e()}:

{synoptset 17 tabbed}{...}
{p2col 5 17 21 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(tmin)}}minimum time{p_end}
{synopt:{cmd:e(tmax)}}maximum time{p_end}
{synopt:{cmd:e(n_lags)}}number of lags{p_end}
{synopt:{cmd:e(k_ce95)}}number of cointegrating equations chosen by multiple trace tests with {cmd:level(95)}{p_end}
{synopt:{cmd:e(k_ce99)}}number of cointegrating equations chosen by multiple trace tests with {cmd:level(99)}{p_end}
{synopt:{cmd:e(k_cesbic)}}number of cointegrating equations chosen by minimizing SBIC{p_end}
{synopt:{cmd:e(k_cehqic)}}number of cointegrating equations chosen by minimizing HQIC{p_end}

{synoptset 17 tabbed}{...}
{p2col 5 17 21 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:vecrank}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(trend)}}trend specified{p_end}
{synopt:{cmd:e(reduced_lags)}}list of maximum lags to which the model has been reduced{p_end}
{synopt:{cmd:e(reduce_opt)}}{cmd:noreduce}, if {cmd:noreduce} is specified{p_end}
{synopt:{cmd:e(tsfmt)}}format for current time variable{p_end}

{synoptset 17 tabbed}{...}
{p2col 5 17 21 2: Matrices}{p_end}
{synopt:{cmd:e(max)}}vector of maximum-eigenvalue statistics{p_end}
{synopt:{cmd:e(trace)}}vector of trace statistics{p_end}
{synopt:{cmd:e(ll)}}vector of model log likelihoods{p_end}
{synopt:{cmd:e(lambda)}}vector of eigenvalues{p_end}
{synopt:{cmd:e(k_rank)}}vector of numbers of unconstrained parameters{p_end}
{synopt:{cmd:e(hqic)}}vector of HQIC values{p_end}
{synopt:{cmd:e(sbic)}}vector of SBIC values{p_end}
{synopt:{cmd:e(aic)}}vector of AIC values{p_end}
{p2colreset}{...}
