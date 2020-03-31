{* *! version 1.0.0  03apr2019}{...}
{marker funcspec}{...}
{marker args}{...}
{p 4 6 2}
{it:funcspec} is [{it:label}{cmd::}]{cmd:@}{it:func}{cmd:(}{it:arg1}[{cmd:,}
{it:arg2}]{cmd:)}, where
{it:label} is a valid Stata name; {it:func} is an official or user-defined
Mata function that operates on column vectors and returns a real scalar;
and {it:arg1} and {it:arg2} are one of {cmd:{c -(}_ysim}[{it:#}]{cmd:{c )-}},
{cmd:{c -(}_resid}[{it:#}]{cmd:{c )-}}, or
{cmd:{c -(}_mu}[{it:#}]{cmd:{c )-}}.  {it:arg2} is
primarily for use with user-defined Mata functions; see
{mansection BAYES bayespredictRemarksandexamplesDefiningteststatisticsusingMatafunctions:{it:Defining test statistics using Mata functions}}
in {bf:[BAYES] bayespredict}.
{p_end}
