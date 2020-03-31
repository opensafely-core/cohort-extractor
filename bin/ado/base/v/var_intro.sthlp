{smcl}
{* *! version 1.1.4  19oct2017}{...}
{vieweralsosee "[TS] var intro" "mansection TS varintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] irf" "help irf"}{...}
{vieweralsosee "[TS] var" "help var"}{...}
{vieweralsosee "[TS] var svar" "help svar"}{...}
{vieweralsosee "[TS] vec" "help vec"}{...}
{vieweralsosee "[TS] vec intro" "help vec_intro"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[TS] var intro} {hline 2}}Introduction to vector autoregressive models{p_end}
{p2col:}({mansection TS varintro:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{title:Description}

{pstd}
Stata has a suite of commands for fitting, forecasting, interpreting, and
performing inference on vector autoregressive (VAR) models and structural
vector autoregressive (SVAR) models.  The suite includes several commands for
estimating and interpreting impulse-response functions (IRFs),
dynamic-multiplier functions, and forecast-error variance decompositions
(FEVDs).  The table below describes the available commands.


    {title:Fitting a VAR or SVAR}

{p2colset 5 22 27 2}{...}
{p2col:{helpb var}}Fit vector autoregressive models{p_end}
{p2col:{helpb svar}}Fit structural vector autoregressive models{p_end}
{p2col:{helpb varbasic}}Fit a simple VAR and graph IRFs or FEVDs{p_end}


    {title:Model diagnostics and inference}

{p2col:{helpb varstable}}Check the stability condition of VAR or SVAR estimates{p_end}
{p2col:{helpb varsoc}}Obtain lag-order selection statistics for VARs and VECMs{p_end}
{p2col:{helpb varwle}}Obtain Wald lag-exclusion statistics after {cmd:var} or {cmd:svar}{p_end}
{p2col:{helpb vargranger}}Perform pairwise Granger causality tests after {cmd:var} or {cmd:svar}{p_end}
{p2col:{helpb varlmar}}Perform LM test for residual autocorrelation after {cmd:var} or {cmd:svar}{p_end}
{p2col:{helpb varnorm}}Test for normally distributed disturbances after {cmd:var} or {cmd:svar}{p_end}


    {title:Forecasting after fitting a VAR or SVAR}

{p2col:{helpb fcast compute}}Compute dynamic forecasts after {cmd:var}, {cmd:svar}, or {cmd:vec}{p_end}
{p2col:{helpb fcast graph}}Graph forecasts after {cmd:fcast compute}{p_end}


    {title:Working with IRFs, dynamic-multiplier functions, and FEVDs}

{p2col:{helpb irf}}Create and analyze IRFs, dynamic-multiplier functions, and FEVDs{p_end}
{p2colreset}{...}
