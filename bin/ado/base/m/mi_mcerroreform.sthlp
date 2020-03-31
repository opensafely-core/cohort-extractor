{smcl}
{* *! version 1.0.2  30may2011}{...}
{vieweralsosee "[MI] mi estimate" "help mi_estimate"}{...}
{vieweralsosee "[MI] mi estimate using" "help mi_estimate using"}{...}
{title:Monte Carlo error estimates are not reported for exponentiated results}

{pstd}
Monte Carlo error estimates are not reported for results in the
exponentiated metric when one of the options described in 
{manhelpi eform_option R} is specified with the command
{cmd:mi estimate, mcerror} upon replay.  To obtain these estimates for the
exponentiated results, you must use {it:eform_option} with either
{helpb mi estimate} or {helpb mi estimate using} during estimation.
For example,

{phang2}{cmd:  . mi estimate, mcerror eform:}{it: ...}{p_end}

{pstd}
You can then also redisplay Monte Carlo error estimates for the results in the
original metric:

{phang2}{cmd:  . mi estimate, mcerror}{p_end}

{pstd}
or in the exponentiated metric:

{phang2}{cmd:  . mi estimate, mcerror eform}{p_end}
