{smcl}
{* *! version 1.1.10  20sep2018}{...}
{viewerdialog varbasic "dialog varbasic"}{...}
{vieweralsosee "[TS] varbasic" "mansection TS varbasic"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] varbasic postestimation" "help varbasic postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "[TS] var" "help var"}{...}
{vieweralsosee "[TS] var intro" "help var_intro"}{...}
{vieweralsosee "[TS] var svar" "help svar"}{...}
{viewerjumpto "Syntax" "varbasic##syntax"}{...}
{viewerjumpto "Menu" "varbasic##menu"}{...}
{viewerjumpto "Description" "varbasic##description"}{...}
{viewerjumpto "Links to PDF documentation" "varbasic##linkspdf"}{...}
{viewerjumpto "Options" "varbasic##options"}{...}
{viewerjumpto "Examples" "varbasic##examples"}{...}
{viewerjumpto "Stored results" "varbasic##results"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[TS] varbasic} {hline 2}}Fit a simple VAR and graph
IRFs and FEVDs{p_end}
{p2col:}({mansection TS varbasic:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:varbasic}
{depvarlist}
{ifin}
[{cmd:,} {it:options}]

{synoptset 17 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opth la:gs(numlist)}}use {it:numlist} lags in the model; default is {cmd:lags(1 2)}
{p_end}
{synopt:{opt i:rf}}produce matrix graph of IRFs{p_end}
{synopt:{opt f:evd}}produce matrix graph of FEVDs{p_end}
{synopt:{opt nog:raph}}do not produce a graph{p_end}
{synopt:{opt s:tep(#)}}set forecast horizon {it:#} for estimating the OIRFs,
IRFs, and FEVDs; default is {cmd:step(8)} {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
You must {cmd:tsset} your data before using {opt varbasic}; see
{helpb tsset:[TS] tsset}.{p_end}
{p 4 6 2}
{it:depvarlist} may contain time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}
{opt rolling}, {opt statsby}, and {cmd:xi} are allowed; see
{help prefix}.{p_end}
{p 4 6 2}See {manhelp varbasic_postestimation TS:varbasic postestimation} for
features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate time series > Basic VAR}


{marker description}{...}
{title:Description}

{pstd}
{opt varbasic} fits a basic vector autoregressive (VAR) model and graphs
the impulse-response functions (IRFs), the orthogonalized impulse-response
functions (OIRFs), or the forecast-error variance decompositions (FEVDs).


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS varbasicQuickstart:Quick start}

        {mansection TS varbasicRemarksandexamples:Remarks and examples}

        {mansection TS varbasicMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt lags(numlist)} specifies the lags to be included in the model.
The default is {cmd:lags(1 2)}.  This option takes a numlist
and not simply an integer for the maximum lag.  For instance, {cmd:lags(2)}
would include only the second lag in the model, whereas {cmd:lags(1/2)} would
include both the first and second lags in the model.
See {it:{help numlist}} and {help tsvarlist}
for a more discussion of numlists and lags.

{phang}
{opt irf} causes {opt varbasic} to produce a matrix graph of the
IRFs instead of a matrix graph of the OIRFs, which is produced by
default.

{phang}
{opt fevd} causes {opt varbasic} to produce a matrix graph of the
FEVDs instead of a matrix graph of the OIRFs, which is produced by
default.

{phang}
{opt nograph} specifies that no graph be produced.  The IRFs, OIRFs,
and FEVDs are still estimated and saved in the IRF file {opt _varbasic.irf}.

{phang}
{opt step(#)} specifies the forecast horizon for estimating the
IRFs, OIRFs, and FEVDs.  The default is eight periods.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse lutkepohl2}

{pstd}Fit a VAR model and graph OIRFs{p_end}
{phang2}{cmd:. varbasic dln_inv dln_inc dln_consump}{p_end}

{pstd}Same as above, but restrict to specified time period{p_end}
{phang2}{cmd:. varbasic dln_inv dln_inc dln_consump if qtr<=tq(1978q4)}{p_end}

{pstd}Same as above, but use 10 as the forecast horizon{p_end}
{phang2}{cmd:. varbasic dln_inv dln_inc dln_consump if qtr<=tq(1978q4),}
              {cmd:step(10)}{p_end}

{pstd}Fit a VAR model and graph IRFs{p_end}
{phang2}{cmd:. varbasic dln_inv dln_inc dln_consump if qtr<=tq(1978q4),}
              {cmd:irf}{p_end}

{pstd}Same as above, but include the first, second, and third lags in the
model{p_end}
{phang2}{cmd:. varbasic dln_inv dln_inc dln_consump if qtr<=tq(1978q4),}
              {cmd:irf lags(1/3)}{p_end}

{pstd}Fit a VAR model and graph FEVDs{p_end}
{phang2}{cmd:. varbasic dln_inv dln_inc dln_consump if qtr<=tq(1978q4),}
              {cmd:fevd}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
See {it:{help var##results:Stored results}} in {manhelp var TS}.
{p_end}
