{smcl}
{* *! version 1.0.3  11feb2011}{...}
{title:Out-of-date commands}

{pstd}
These commands continue to work but are out-of-date as of Stata 9.  Their
replacements are

{p2colset 9 24 26 2}{...}
{p2col:Old command}New command{p_end}
{tab}{hline 30}
{p2col:{cmd:hettest}}{helpb regress postestimation##estathett:estat hettest}
{p_end}
{p2col:{cmd:imtest}}{helpb regress postestimation##estatimtest:estat imtest}
{p_end}
{p2col:{cmd:ovtest}}{helpb regress postestimation##estatovt:estat ovtest}
{p_end}
{p2col:{cmd:szroeter}}{helpb regress postestimation##estatszroeter:estat szroeter}
{p_end}
{p2col:{cmd:vif}}{helpb regress postestimation##estatvif:estat vif}
{p_end}
{tab}{hline 30}
{tab}See {help regress postestimation}.

{p2col:Old command}New command{p_end}
{tab}{hline 30}
{p2col:{cmd:archlm}}{helpb regress postestimationts##archlm:estat archlm}
{p_end}
{p2col:{cmd:bgodfrey}}{helpb regress postestimationts##bgodfrey:estat bgodfrey}
{p_end}
{p2col:{cmd:durbina}}{helpb regress postestimationts##durbinalt:estat durbinalt}
{p_end}
{p2col:{cmd:dwstat}}{helpb regress postestimationts##dwatson:estat dwatson}
{p_end}
{tab}{hline 30}
{tab}See {help regress postestimation ts}.
