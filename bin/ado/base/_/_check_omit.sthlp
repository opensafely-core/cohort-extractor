{smcl}
{* *! version 1.0.3  11feb2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{viewerjumpto "Syntax" "_check_omit##syntax"}{...}
{viewerjumpto "Description" "_check_omit##description"}{...}
{title:Title}

{p 4 25 2}
{hi:[P] _check_omit} {hline 2}
Programmer's utility for checking collinearity behavior


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}{cmd:_check_omit} {it:matname}{cmd:,} {opt g:et}

{p 8 16 2}{cmd:_check_omit} {it:matname}{cmd:,} {opt c:heck}
{opt r:esult(name)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_check_omit, get} generates a matrix named {it:matname} containing zeros
and ones, with one for omitted predictors and zero otherwise.  This is done by
looking at the current {cmd:e(b)} and {cmd:e(V)} matrices and determining the
omit status. 

{pstd}
{cmd:_check_omit, check} {opt result(name)} compares the current omit status of
the {cmd:e(b)} and {cmd:e(V)} matrices with {it:matname} and returns a local
macro, {it:name}, containing zero if the omit status is the same and one
otherwise. 
{p_end}
