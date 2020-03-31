{smcl}
{* *! version 1.0.6  23oct2017}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SVY] svy" "help svy"}{...}
{viewerjumpto "Syntax" "_svy_mkdeff##syntax"}{...}
{viewerjumpto "Description" "_svy_mkdeff##description"}{...}
{title:Title}

{p 4 27 2}
{hi:[SVY] _svy_mkdeff} {hline 2}
Calculation of design effects for survey data analysis


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:_svy_mkdeff}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_svy_mkdeff} is a programming tool that computes design effects from
{cmd:e(V)} and {cmd:e(V_srs)} (and {cmd:e(V_srswr)} if present) and places
them in {cmd:e(deff)} and {cmd:e(deft)}.  Here {cmd:e(V)} is assumed to
contain the design based (co)variance matrix from a model fit, {cmd:e(V_srs)}
contains the estimate of the (co)variance matrix if the data were collected
using a simple random sample without replacement, and {cmd:e(V_srswr)}
contains the estimate of the (co)variance matrix if the data were collected
using a simple random sample with replacement.

{pstd}
For examples, formulas, and a discussion of design effects, see
{manlink SVY estat}.
{p_end}
