{smcl}
{* *! version 1.1.8  20sep2018}{...}
{viewerdialog varnorm "dialog varnorm"}{...}
{vieweralsosee "[TS] varnorm" "mansection TS varnorm"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] var" "help var"}{...}
{vieweralsosee "[TS] var intro" "help var_intro"}{...}
{vieweralsosee "[TS] var svar" "help svar"}{...}
{vieweralsosee "[TS] varbasic" "help varbasic"}{...}
{viewerjumpto "Syntax" "varnorm##syntax"}{...}
{viewerjumpto "Menu" "varnorm##menu"}{...}
{viewerjumpto "Description" "varnorm##description"}{...}
{viewerjumpto "Links to PDF documentation" "varnorm##linkspdf"}{...}
{viewerjumpto "Options" "varnorm##options"}{...}
{viewerjumpto "Examples" "varnorm##examples"}{...}
{viewerjumpto "Stored results" "varnorm##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[TS] varnorm} {hline 2}}Test for normally distributed
disturbances after var or svar{p_end}
{p2col:}({mansection TS varnorm:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:varnorm} [{cmd:,} {it:options}]

{synoptset 20}{...}
{synopthdr}
{synoptline}
{synopt:{opt j:bera}}report Jarque-Bera statistic; default is to report all
three statistics{p_end}
{synopt:{opt s:kewness}}report skewness statistic; default is to report all
three statistics{p_end}
{synopt:{opt k:urtosis}}report kurtosis statistic; default is to report all
three statistics{p_end}
{synopt:{opt est:imates(estname)}}use previously stored results {it:estname};
default is to use active results{p_end}
{synopt:{opt c:holesky}}use Cholesky decomposition{p_end}
{synopt:{opt sep:arator(#)}}draw separator line after every {it:#} rows{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt varnorm} can be used only after {cmd:var} or {cmd:svar}; see
{helpb var:[TS] var} or {helpb svar:[TS]var svar}.
{p_end}
{p 4 6 2}
You must {cmd:tsset} your data before using {opt varnorm}; see
{helpb tsset:[TS] tsset}.
{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate time series > VAR diagnostics and tests >}
    {bf:Test for normally distributed disturbances}


{marker description}{...}
{title:Description}

{pstd}
{opt varnorm} computes and reports a series of statistics against the null
hypothesis that the disturbances in a VAR are normally distributed.  For each
equation, and for all equations jointly, up to three statistics may be
computed:  a skewness statistic, a kurtosis statistic, and the Jarque-Bera
statistic.  By default, all three statistics are reported.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS varnormQuickstart:Quick start}

        {mansection TS varnormRemarksandexamples:Remarks and examples}

        {mansection TS varnormMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt jbera} requests that the Jarque-Bera statistic and any other explicitly
   requested statistic be reported.  By default, the Jarque-Bera, skewness,
   and kurtosis statistics are reported.

{phang}
{opt skewness} requests that the skewness statistic and any other explicitly
   requested statistic be reported.  By default, the Jarque-Bera, skewness,
   and kurtosis statistics are reported.

{phang}
{opt kurtosis} specifies that the kurtosis statistic and any other explicitly
   requested statistic be reported.  By default, the Jarque-Bera, skewness,
   and kurtosis statistics are reported.

{phang}
{opt estimates(estname)} specifies that {opt varnorm} use the previously
   obtained set of {cmd:var} or {cmd:svar} estimates stored as
   {it:estname}.  By default, {opt varnorm} uses the active results.  See
   {manhelp estimates R} for information on manipulating estimation results.

{phang}
{opt cholesky} specifies that {opt varnorm} should use the Cholesky
   decomposition of the estimated variance-covariance matrix of the
   disturbances to orthogonalize the residuals when {opt varnorm} is applied
   to {cmd:svar} results.  By default, when {opt varnorm} is applied to
   {opt svar} results, it uses the estimated structural decomposition to
   orthogonalize the residuals.  When applied to {opt var e()} results,
   {opt varnorm} always uses the Cholesky decomposition of the estimated
   variance-covariance matrix of the disturbances.  For this reason, the
   {opt cholesky} option may not be specified when using {cmd:var} results.

{phang}
{opt separator(#)} specifies how often separator lines should be drawn between
   rows.  By default, separator lines do not appear.  For example,
   {cmd:separator(1)} would draw a line between each row, {cmd:separator(2)}
   between every other row, and so on.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse lutkepohl2}{p_end}

{pstd}Fit vector autoregressive model{p_end}
{phang2}{cmd:. var dln_inv dln_inc dln_consump if qtr<=tq(1978q4)}{p_end}

{pstd}Test for normally distributed disturbances after {cmd:var}{p_end}
{phang2}{cmd:. varnorm}

{pstd}Same as above, but report only skewness statistic{p_end}
{phang2}{cmd:. varnorm, skewness}

{pstd}Setup{p_end}
{phang2}{cmd:. matrix A = (.,0,0\.,.,0\.,.,.)}{p_end}
{phang2}{cmd:. matrix B = I(3)}{p_end}

{pstd}Fit structural vector autoregressive model{p_end}
{phang2}{cmd:. svar dln_inv dln_inc dln_consump if qtr<=tq(1978q4), dfk}
            {cmd:aeq(A) beq(B)}

{pstd}Test for normally distributed disturbances after {cmd:svar}{p_end}
{phang2}{cmd:. varnorm}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:varnorm} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(dfk)}}{cmd:dfk}, if specified{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(kurtosis)}}kurtosis test, df, and p-values{p_end}
{synopt:{cmd:r(skewness)}}skewness test, df, and p-values{p_end}
{synopt:{cmd:r(jb)}}Jarque-Bera test, df, and p-values{p_end}
{p2colreset}{...}
