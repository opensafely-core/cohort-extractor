{smcl}
{* *! version 1.0.0  16may2018}{...}
{vieweralsosee "[BAYES] bayes" "mansection BAYES bayes"}{...}
{title:Why are not all random effects shown?}

{pstd}
You specified the {cmd:showreffects} option with {helpb bayes} or 
{helpb bayesmh}, but not all the random effects were shown.  This happens
when the total number of parameters, including random effects, exceeds the
current {helpb matsize}.  The number of parameters displayed and stored in
{cmd:e(b)} cannot exceed {cmd:matsize}.  To display and store more random
effects, you can increase {cmd:matsize}.  Otherwise, you can use the 
{cmd:showreffects()} and {cmd:show()} options on replay or use
{helpb bayesstats summary} after estimation to display subsets of the
remaining random effects.
{p_end}
