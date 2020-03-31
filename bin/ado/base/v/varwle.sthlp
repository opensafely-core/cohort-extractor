{smcl}
{* *! version 1.1.8  20sep2018}{...}
{viewerdialog varwle "dialog varwle"}{...}
{vieweralsosee "[TS] varwle" "mansection TS varwle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] var" "help var"}{...}
{vieweralsosee "[TS] var intro" "help var_intro"}{...}
{vieweralsosee "[TS] var svar" "help svar"}{...}
{vieweralsosee "[TS] varbasic" "help varbasic"}{...}
{viewerjumpto "Syntax" "varwle##syntax"}{...}
{viewerjumpto "Menu" "varwle##menu"}{...}
{viewerjumpto "Description" "varwle##description"}{...}
{viewerjumpto "Links to PDF documentation" "varwle##linkspdf"}{...}
{viewerjumpto "Options" "varwle##options"}{...}
{viewerjumpto "Examples" "varwle##examples"}{...}
{viewerjumpto "Stored results" "varwle##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[TS] varwle} {hline 2}}Obtain Wald lag-exclusion statistics after
var or svar{p_end}
{p2col:}({mansection TS varwle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:varwle}
[{cmd:,}
{opt est:imates(estname)}
{opt sep:arator(#)}]

{p 4 6 2}
{opt varwle} can be used only after {cmd:var} or {cmd:svar}; see
{helpb var:[TS] var} and {helpb svar:[TS] var svar}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate time series > VAR diagnostics and tests >}
      {bf:Wald lag-exclusion statistics}


{marker description}{...}
{title:Description}

{pstd}
{opt varwle} reports Wald tests of the hypothesis that the endogenous
variables at the given lag are jointly zero for each equation and for all
equations jointly.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS varwleQuickstart:Quick start}

        {mansection TS varwleRemarksandexamples:Remarks and examples}

        {mansection TS varwleMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt estimates(estname)} requests that {opt varwle} use the previously
   obtained set of {cmd:var} or {cmd:svar} estimates stored as
   {it:estname}.  By default, {opt varwle} uses the active estimation results.
   See {manhelp estimates R} for information on manipulating estimation
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

{pstd}Fit vector autoregressive model{p_end}
{phang2}{cmd:. var dln_inv dln_inc dln_consump if qtr<=tq(1978q4), dfk small}

{pstd}Obtain Wald lag-exclusion statistics after {cmd:var}{p_end}
{phang2}{cmd:. varwle}{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:. matrix a = (.,0\.,.)}{p_end}
{phang2}{cmd:. matrix b = I(2)}{p_end}

{pstd}Fit structural vector autoregressive model{p_end}
{phang2}{cmd:. svar dln_inc dln_consump, aeq(a) beq(b)}

{pstd}Obtain Wald lag-exclusion statistics after {cmd:svar}{p_end}
{phang2}{cmd:. varwle}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:varwle} stores the following in {cmd:r()}:

{synoptset 10 tabbed}{...}
{p2col 5 10 14 2: Matrices}{p_end}
{p2col 5 10 14 2: if {cmd:e(small)==""}}{p_end}
{synopt:{cmd:r(chi2)}}chi-squared test statistics{p_end}
{synopt:{cmd:r(df)}}degrees of freedom{p_end}
{synopt:{cmd:r(p)}}p-values{p_end}

{p2col 5 10 14 2: if {cmd:e(small)!=""}}{p_end}
{synopt:{cmd:r(F)}}F test statistics{p_end}
{synopt:{cmd:r(df_r)}}numerator degree of freedom{p_end}
{synopt:{cmd:r(df)}}denominator degree of freedom{p_end}
{synopt:{cmd:r(p)}}p-values{p_end}
{p2colreset}{...}
