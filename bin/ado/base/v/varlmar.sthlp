{smcl}
{* *! version 1.1.10  20sep2018}{...}
{viewerdialog varlmar "dialog varlmar"}{...}
{vieweralsosee "[TS] varlmar" "mansection TS varlmar"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] var" "help var"}{...}
{vieweralsosee "[TS] var intro" "help var_intro"}{...}
{vieweralsosee "[TS] var svar" "help svar"}{...}
{vieweralsosee "[TS] varbasic" "help varbasic"}{...}
{viewerjumpto "Syntax" "varlmar##syntax"}{...}
{viewerjumpto "Menu" "varlmar##menu"}{...}
{viewerjumpto "Description" "varlmar##description"}{...}
{viewerjumpto "Links to PDF documentation" "varlmar##linkspdf"}{...}
{viewerjumpto "Options" "varlmar##options"}{...}
{viewerjumpto "Examples" "varlmar##examples"}{...}
{viewerjumpto "Stored results" "varlmar##results"}{...}
{viewerjumpto "Reference" "varlmar##reference"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[TS] varlmar} {hline 2}}LM test for residual autocorrelation after var or svar {p_end}
{p2col:}({mansection TS varlmar:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:varlmar} [{cmd:,} {it:options}]

{synoptset 20}{...}
{synopthdr}
{synoptline}
{synopt:{opt ml:ag(#)}}use {it:#} for the maximum order of autocorrelation; default is {cmd:mlag(2)} {p_end}
{synopt:{opt est:imates(estname)}}use previously stored results {it:estname};
default is to use active results {p_end}
{synopt:{opt sep:arator(#)}}draw separator line after every {it:#} rows
{p_end}
{synoptline}
{p 4 6 2}
{opt varlmar} can be used only after {cmd:var} or {cmd:svar}; see
{helpb var:[TS] var} or {helpb svar:[TS] var svar}.
{p_end}
{p 4 6 2}
You must {cmd:tsset} your data before using {opt varlmar};
{helpb tsset:[TS] tsset}.
{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate time series > VAR diagnostics and tests >}
    {bf:LM test for residual autocorrelation}


{marker description}{...}
{title:Description}

{pstd}
{opt varlmar} implements a Lagrange multiplier (LM) test for autocorrelation
in the residuals of VAR models, which was presented in 
{help varlmar##J1995:Johansen (1995)}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS varlmarQuickstart:Quick start}

        {mansection TS varlmarRemarksandexamples:Remarks and examples}

        {mansection TS varlmarMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt mlag(#)} specifies the maximum order of autocorrelation to be tested.
   The integer specified in {opt mlag()} must be greater than 0; the default
   is 2.

{phang}
{opt estimates(estname)} requests that {opt varlmar} use the previously
   obtained set of {cmd:var} or {cmd:svar} estimates stored as
   {it:estname}.  By default, {opt varlmar} uses the active results.  See
   {manhelp estimates R} for information on manipulating estimation
   results.

{phang}
{opt separator(#)} specifies how often separator lines should be drawn between
   rows.  By default, separator lines do not appear.  For example,
   {cmd:separator(1)} would draw a line between each row, {cmd:separator(2)}
   between every other row, and so on.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse lutkepohl2}{p_end}

{pstd}Fit vector autoregressive (VAR) model{p_end}
{phang2}{cmd:. var dln_inv dln_inc dln_consump if qtr<=tq(1978q4)}{p_end}

{pstd}Store estimation results in {cmd:basic}{p_end}
{phang2}{cmd:. estimates store basic}{p_end}

{pstd}Fit a second VAR model{p_end}
{phang2}{cmd:. var dln_inv dln_inc dln_consump if qtr<=tq(1978q4),}
                {cmd:lags(1/3) dfk small}{p_end}

{pstd}Perform LM test for residual autocorrelation on the
second VAR model{p_end}
{phang2}{cmd:. varlmar}

{pstd}Perform LM test for residual autocorrelation on the
"basic" VAR model{p_end}
{phang2}{cmd:. varlmar, estimates(basic)}

{pstd}Setup{p_end}
{phang2}{cmd:. matrix A = (.,0,0\.,.,0\.,.,.)}{p_end}
{phang2}{cmd:. matrix B = I(3)}{p_end}

{pstd}Fit a structural vector autoregressive model{p_end}
{phang2}{cmd:. svar dln_inv dln_inc dln_consump if qtr<=tq(1978q4),}
            {cmd:lags(1/3) dfk small aeq(A) beq(B)}

{pstd}Perform LM test for residual autocorrelation after
{cmd:svar}{p_end}
{phang2}{cmd:. varlmar}



{marker results}{...}
{title:Stored results}

{pstd}
{cmd:varlmar} stores the following in {cmd:r()}:

{synoptset 10 tabbed}{...}
{p2col 5 10 14 2: Matrices}{p_end}
{synopt:{cmd:r(lm)}}chi-squared, df, and p-values{p_end}
{p2colreset}{...}


{marker reference}{...}
{title:Reference}

{marker J1995}{...}
{phang}
Johansen, S. 1995. 
{it:Likelihood-Based Inference in Cointegrated Vector Autoregressive Models}.
Oxford: Oxford University Press.
{p_end}
