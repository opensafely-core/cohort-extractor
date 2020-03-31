{smcl}
{* *! version 1.1.9  19oct2017}{...}
{viewerdialog "tssmooth exponential" "dialog tssmooth_exponential"}{...}
{vieweralsosee "[TS] tssmooth exponential" "mansection TS tssmoothexponential"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "[TS] tssmooth" "help tssmooth"}{...}
{viewerjumpto "Syntax" "tssmooth_exponential##syntax"}{...}
{viewerjumpto "Menu" "tssmooth_exponential##menu"}{...}
{viewerjumpto "Description" "tssmooth_exponential##description"}{...}
{viewerjumpto "Links to PDF documentation" "tssmooth_exponential##linkspdf"}{...}
{viewerjumpto "Options" "tssmooth_exponential##options"}{...}
{viewerjumpto "Examples" "tssmooth_exponential##examples"}{...}
{viewerjumpto "Stored results" "tssmooth_exponential##results"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[TS] tssmooth exponential} {hline 2}}Single-exponential smoothing{p_end}
{p2col:}({mansection TS tssmoothexponential:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 29 2}
{cmd:tssmooth} {opt e:xponential} {dtype} {newvar} {cmd:=} {it:{help exp}}
   {ifin} [{cmd:,} {it:options}]

{synoptset 15 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{cmd:replace}}replace {newvar} if it already exists{p_end}
{synopt :{opt p:arms(#a)}}use {it:#a} as smoothing parameter{p_end}
{synopt :{opt sa:mp0(#)}}use {it:#} observations to obtain initial value for
   recursion{p_end}
{synopt :{opt s0(#)}}use {it:#} as initial value for recursion{p_end}
{synopt :{opt f:orecast(#)}}use {it:#} periods for the out-of-sample 
   forecast{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}You must {cmd:tsset} your data before using
{cmd:tssmooth exponential}; see {helpb tsset:[TS] tsset}.{p_end}
{p 4 6 2}{it:exp} may contain time-series operators; see 
   {help tsvarlist}.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Time series > Smoothers/univariate forecasters >}
    {bf:Single-exponential smoothing}


{marker description}{...}
{title:Description}

{pstd}
{cmd:tssmooth exponential} models the trend of a variable whose change from
the previous value is serially correlated.  More precisely, it models a
variable whose first difference follows a low-order, moving-average process.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS tssmoothexponentialQuickstart:Quick start}

        {mansection TS tssmoothexponentialRemarksandexamples:Remarks and examples}

        {mansection TS tssmoothexponentialMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt replace} replaces {newvar} if it already exists.

{phang}
{opt parms(#a)} specifies the parameter alpha for the exponential smoother;
{bind:{cmd:0} < {it:#a} < {cmd:1}}.  If {opt parms(#a)} is not specified, the
smoothing parameter is chosen to minimize the in-sample sum-of-squared forecast
errors.

{phang}
{opt samp0(#)} and {opt s0(#)} are mutually exclusive ways of specifying
the initial value for the recursion.

{pmore}
{opt samp0(#)} specifies that the initial value be obtained by calculating the
mean over the first {it:#} observations of the sample.

{pmore}
{opt s0(#)} specifies the initial value to be used.

{pmore}
If neither option is specified, the default is to use the mean calculated over
the first half of the sample.

{phang}
{opt forecast(#)} gives the number of observations for the out-of-sample
prediction; {bind:{cmd:0} {ul:<} {it:#} {ul:<} {cmd:500}}.  The default
is {cmd:forecast(0)} and is equivalent to not forecasting out of sample.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sales1}

{pstd}Perform single-exponential smoothing on {cmd:sales}{p_end}
{phang2}{cmd:. tssmooth exponential double sm2a=sales}

{pstd}Same as above, but use .4 as smoothing parameter{p_end}
{phang2}{cmd:. tssmooth exponential double sm2b=sales, p(.4)}

{pstd}Same as above, but perform out-of-sample forecast using 3 periods{p_end}
{phang2}{cmd:. tssmooth exponential double sm2c=sales, p(.4) forecast(3)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:tssmooth exponential} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(alpha)}}alpha smoothing parameter{p_end}
{synopt:{cmd:r(rss)}}sum-of-squared prediction errors{p_end}
{synopt:{cmd:r(rmse)}}root mean squared error{p_end}
{synopt:{cmd:r(N_pre)}}number of observations used in calculating starting
values{p_end}
{synopt:{cmd:r(s1_0)}}initial value for S_t{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(method)}}smoothing method{p_end}
{synopt:{cmd:r(exp)}}expression specified{p_end}
{synopt:{cmd:r(timevar)}}time variable specified in {cmd:tsset}{p_end}
{synopt:{cmd:r(panelvar)}}panel variable specified in {cmd:tsset}{p_end}
{p2colreset}{...}
