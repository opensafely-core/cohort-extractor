{smcl}
{* *! version 1.0.4  11feb2011}{...}
{vieweralsosee "[TS] var intro" "help var_intro"}{...}
{vieweralsosee "[TS] vec intro" "help vec_intro"}{...}
{title:Dynamic forecasts after var, svar, and vec}

{pstd}
{cmd:fcast} computes and graphs dynamic forecasts of the endogenous
variables after {cmd:var}, {cmd:svar}, or {cmd:vec}.  {cmd:fcast} has two
subcommands.  {cmd:fcast compute} computes the dynamic forecasts, the
estimated confidence intervals, and the standard errors of the forecasts.
{cmd:fcast graph} graphs the predictions, the confidence intervals, and the
observed values.


    Command{space 11}See help{space 9}Description
    {hline -2}
{p 4 43 2}{cmd:fcast} {cmdab:c:ompute}{space 5}{helpb fcast compute}{space 4}Obtain dynamic forecasts

{p 4 43 2}{cmd:fcast} {cmdab:g:raph}{space 7}{helpb fcast graph}{space 6}Graph dynamic forecasts obtained from {cmd:fcast compute}
{p_end}
    {hline -2}
