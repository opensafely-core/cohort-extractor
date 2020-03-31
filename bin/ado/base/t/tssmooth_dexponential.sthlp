{smcl}
{* *! version 1.1.9  19oct2017}{...}
{viewerdialog "tssmooth dexponential" "dialog tssmooth_dexponential"}{...}
{vieweralsosee "[TS] tssmooth dexponential" "mansection TS tssmoothdexponential"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "[TS] tssmooth" "help tssmooth"}{...}
{viewerjumpto "Syntax" "tssmooth_dexponential##syntax"}{...}
{viewerjumpto "Menu" "tssmooth_dexponential##menu"}{...}
{viewerjumpto "Description" "tssmooth_dexponential##description"}{...}
{viewerjumpto "Links to PDF documentation" "tssmooth_dexponential##linkspdf"}{...}
{viewerjumpto "Options" "tssmooth_dexponential##options"}{...}
{viewerjumpto "Examples" "tssmooth_dexponential##examples"}{...}
{viewerjumpto "Stored results" "tssmooth_dexponential##results"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[TS] tssmooth dexponential} {hline 2}}Double-exponential smoothing{p_end}
{p2col:}({mansection TS tssmoothdexponential:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 20 2}
{cmd:tssmooth} {opt d:exponential} {dtype} {newvar} {cmd:=}
   {it:{help exp}} {ifin} [{cmd:,} 
   {it:options}]

{synoptset 15 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{opt replace}}replace {newvar} if it already exists{p_end}
{synopt :{opt p:arms(#a)}}use {it:#a} as smoothing parameter{p_end}
{synopt :{opt sa:mp0(#)}}use {it:#} observations to obtain initial values for
recursion{p_end}
{synopt :{opt s0(#1 #2)}}use {it:#1} and {it:#2} as initial values for
recursions{p_end}
{synopt :{opt f:orecast(#)}}use {it:#} periods for the out-of-sample
forecast{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}You must {cmd:tsset} your data before using
{cmd:tssmooth dexponential}; see {helpb tsset:[TS] tsset}.{p_end}
{p 4 6 2}{it:exp} may contain time-series operators; see {help tsvarlist}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Time series > Smoothers/univariate forecasters >}
     {bf:Double-exponential smoothing}


{marker description}{...}
{title:Description}

{pstd}
{cmd:tssmooth dexponential} models the trend of a variable whose difference
between changes from the previous values is serially correlated.  More
precisely, it models a variable whose second difference follows a low-order,
moving-average process.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS tssmoothdexponentialQuickstart:Quick start}

        {mansection TS tssmoothdexponentialRemarksandexamples:Remarks and examples}

        {mansection TS tssmoothdexponentialMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt replace} replaces {newvar} if it already exists.

{phang}
{opt parms(#a)} specifies the parameter alpha for the
double-exponential smoothers; {bind:{cmd:0} < {it:#a} < {cmd:1}}.  If
{opt parms(#a)} is not specified, the smoothing parameter is chosen to minimize
the in-sample sum-of-squared forecast errors.

{phang}
{opt samp0(#)} and {opt s0(#1 #2)} are mutually exclusive ways of specifying
the initial values for the recursion.

{pmore}
By default, initial values are obtained by fitting a linear regression with a
time trend, using the first half of the observations in the dataset; see
{mansection TS tssmoothdexponentialRemarksandexamples:{it:Remarks and examples}}
in {bf:[TS] tssmooth dexponential}.

{pmore}
{opt samp0(#)} specifies that the first {it:#} be used in that regression.

{pmore}
{opt s0(#1 #2)} specifies that {it:#1} {it:#2} be used as initial values.

{phang}
{opt forecast(#)} specifies the number of periods for the out-of-sample
prediction;  {bind:{cmd:0} {ul:<} {it:#} {ul:<} {cmd:500}}.  The default is
{cmd:forecast(0)}, which is equivalent to not performing an out-of-sample
forecast.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sales2}

{pstd}Perform double-exponential smoothing on {cmd:sales}{p_end}
{phang2}{cmd:. tssmooth dexponential double sm2a=sales}

{pstd}Same as above, but use .7 as smoothing parameter{p_end}
{phang2}{cmd:. tssmooth dexponential double sm2b=sales, p(.7)}

{pstd}Same as above, but use 1031 and 1031 as initial values for
recursions{p_end}
{phang2}{cmd:. tssmooth dexponential double sm2c=sales, p(.7) s0(1031 1031)}

{pstd}Same as above, but perform out-of-sample forecast using 4 periods{p_end}
{phang2}{cmd:. tssmooth dexponential double sm2d=sales, p(.7) s0(1031 1031)}
             {cmd:forecast(4)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:tssmooth dexponential} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(alpha)}}alpha smoothing parameter{p_end}
{synopt:{cmd:r(rss)}}sum-of-squared errors{p_end}
{synopt:{cmd:r(rmse)}}root mean squared error{p_end}
{synopt:{cmd:r(N_pre)}}number of observations used in calculating starting
values, if starting values calculated{p_end}
{synopt:{cmd:r(s2_0)}}initial value for linear term, i.e., S_0^[2]{p_end}
{synopt:{cmd:r(s1_0)}}initial value for constant term, i.e., S_0{p_end}
{synopt:{cmd:r(linear)}}final value of linear term{p_end}
{synopt:{cmd:r(constant)}}final value of constant term{p_end}
{synopt:{cmd:r(period)}}period, if filter is seasonal{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(method)}}smoothing method{p_end}
{synopt:{cmd:r(exp)}}expression specified{p_end}
{synopt:{cmd:r(timevar)}}time variable specified in {cmd:tsset}{p_end}
{synopt:{cmd:r(panelvar)}}panel variable specified in {cmd:tsset}{p_end}
{p2colreset}{...}
