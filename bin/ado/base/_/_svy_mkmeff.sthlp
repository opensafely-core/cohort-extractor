{smcl}
{* *! version 1.0.7  23oct2017}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SVY] svy" "help svy"}{...}
{viewerjumpto "Syntax" "_svy_mkmeff##syntax"}{...}
{viewerjumpto "Description" "_svy_mkmeff##description"}{...}
{title:Title}

{p 4 27 2}
{hi:[SVY] _svy_mkmeff} {hline 2} Calculation of misspecification effects for
survey data analysis


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:_svy_mkmeff} {it:matname}

{pstd}
where {it:matname} identifies the (co)variance matrix from a misspecified fit
of survey data.


{marker description}{...}
{title:Description}

{pstd}
{cmd:_svy_mkmeff} is a programming tool that computes misspecification effects
from {cmd:e(V)} and {it:matname} and places them in {cmd:e(meft)}.  The
misspecification (co)variance {it:matname} is stored in {cmd:e(V_msp)}.

{pstd}
For examples, formulas, and a discussion of misspecification effects, see
{manlink SVY estat}.
{p_end}
