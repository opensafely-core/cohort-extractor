{smcl}
{* *! version 1.1.0  20sep2014}{...}
{vieweralsosee "[FN] Statistical functions" "mansection FN Statisticalfunctions"}{...}

{pstd}
These functions are out-of-date as of Stata 7.  Their replacements are

{p2colset 9 25 27 2}{...}
{p2col:Old function}Equal to new function{p_end}
{tab}{hline 37}
{p2col:{cmd:nchi()}}{helpb nchi2()}{p_end}
{p2col:{cmd:normprob()}}{helpb normal()}{p_end}
{p2col:{cmd:invnchi()}}{helpb invnchi2()}{p_end}
{p2col:{cmd:npnchi()}}{helpb npnchi2()}{p_end}


{p2col:Old function}Related to new functions{p_end}
{tab}{hline 43}
{p2col:{cmd:chiprob()}}{helpb chi2()} and {helpb chi2tail()}{p_end}
{p2col:{cmd:fprob()}}{helpb F()} and {helpb Ftail()}{p_end}
{p2col:{cmd:invchi()}}{helpb invchi2()} and {helpb invchi2tail()}{p_end}
{p2col:{cmd:invfprob()}}{helpb invF()} and {helpb invFtail()}{p_end}
{p2col:{cmd:tprob()}}{helpb ttail()}{p_end}
{p2colreset}{...}


{pstd}
{cmd:invchi()} works only if {helpb version} is set to less than 7.
{p_end}
