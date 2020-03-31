{smcl}
{* *! version 1.0.2  01jun2018}{...}
{vieweralsosee "[BAYES] bayes" "mansection BAYES bayes"}{...}
{title:Why are not all random effects shown?}

{pstd}
You specified the {cmd:showreffects} option with {helpb bayes} or 
{helpb bayesmh}, but not all the random effects were shown.  This happens
when the total number of parameters, including random effects, exceeds the
current maximum matrix dimension ({helpb creturn##max_matdim:c(max_dim)}).
The number of parameters displayed and stored in {cmd:e(b)} cannot exceed
{cmd:c(max_matdim)}.  You can use the {cmd:showreffects()} and {cmd:show()}
options on replay or use {helpb bayesstats summary} after estimation to
display subsets of the remaining random effects.
{p_end}
