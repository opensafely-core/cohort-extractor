{smcl}
{* *! version 1.1.6  19oct2017}{...}
{vieweralsosee "[TS] vec intro" "mansection TS vecintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] irf" "help irf"}{...}
{vieweralsosee "[TS] vec" "help vec"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[TS] vec intro} {hline 2}}Introduction to vector error-correction models{p_end}
{p2col:}({mansection TS vecintro:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{title:Description}

{pstd}
Stata has a suite of commands for fitting, forecasting, interpreting, and
performing inference on vector error-correction models (VECMs) with
cointegrating variables.  After fitting a VECM, the {cmd:irf} commands
can be used to obtain impulse-response functions (IRFs) and forecast-error
variance decompositions (FEVDs).  The table below describes the available
commands.


    {title:Fitting a VECM}

{p2colset 5 22 27 2}{...}
{p2col:{helpb vec}}Fit vector error-correction models{p_end}

    {title:Model diagnostics and inference}

{p2col:{helpb vecrank}}Estimate the cointegrating rank of a VECM{p_end}
{p2col:{helpb veclmar}}Perform LM test for residual autocorrelation after {cmd:vec}{p_end}
{p2col:{helpb vecnorm}}Test for normally distributed disturbances after {cmd:vec}{p_end}
{p2col:{helpb vecstable}}Check the stability condition of VECM estimates{p_end}
{p2col:{helpb varsoc}}Obtain lag-order selection statistics for VARs and VECMs{p_end}

    {title:Forecasting from a VECM}

{p2col:{helpb fcast compute}}Compute dynamic forecasts after {cmd:var}, {cmd:svar}, or {cmd:vec}{p_end}
{p2col:{helpb fcast graph}}Graph forecasts after {cmd:fcast compute}{p_end}

    {title:Working with IRFs and FEVDs}

{p2col:{helpb irf}}Create and analyze IRFs and FEVDs{p_end}
{p2colreset}{...}
