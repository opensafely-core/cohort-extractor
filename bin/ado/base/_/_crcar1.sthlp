{smcl}
{* *! version 1.0.5  14may2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] Time series" "help time"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{viewerjumpto "Syntax" "_crcar1##syntax"}{...}
{viewerjumpto "Description" "_crcar1##description"}{...}
{viewerjumpto "Options" "_crcar1##options"}{...}
{viewerjumpto "Examples" "_crcar1##examples"}{...}
{title:Title}

{p 4 22 2}
{hi:[P] _crcar1} {hline 2} Programmer's utility for computing AR(1) rho from
residuals


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}{cmd:_crcar1} {it:rho_scalar} {it:method_macro} {cmd::}
	{it:resids_varname} [{cmd:,} {cmd:k(}{it:#}{cmd:)} {cmdab:c:heck}
	{cmd:dw} {cmd:freg} {cmdab:nag:ar} {cmdab:reg:ress} {cmdab:th:eil}
	{cmdab:tsc:orr} ]

{pstd}
{cmd:_crcar1} is for use with time-series data.  You must {cmd:tsset} your
data before using {cmd:_crcar1}; see {manhelp tsset TS}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:_crcar1} is a programmer support command.  It computes the first-order
autocorrelation parameter for a variable (presumably containing residuals)
using any of several estimates of the autocorrelation.

{pstd}
{cmd:_crcar1} expects the first argument to be the name of a scalar into
which the value of rho is saved and the second argument to be the name of a
local macro which will be set to the fully expanded name of the method for
computing rho.


{marker options}{...}
{title:Options}

{phang}
{cmd:check} specifies that rho is not computed, but that the command is
simply checked for syntax and an error reported if the syntax is not proper.

{phang}
{cmd:k(}{it:#}{cmd:)} specifies the number of parameters estimated in the
model.  This is only required for the {cmd:theil} and {cmd:nagar} options which
use {cmd:k} to adjust the degrees of freedom.

{pstd}
The remaining options specify how rho is to be computed; {cmd:regress} is the
default.

{p 4 12 2}
{cmd:regress} rho_reg = B from the residual regression e_t = B * e_(t-1).

{p 4 12 2}
{cmd:freg}{space 4}rho_freg = B from the residual regression e_t = B * e_(t+1).

{p 4 12 2}
{cmd:tscorr}{space 2}rho_tscorr = e'e_(t-1)/e'e, where e is the vector of residuals.

{p 4 12 2}
{cmd:dw}{space 6}rho_dw = 1 - DW / 2.

{p 4 12 2}
{cmd:theil}{space 3}rho_theil = rho_tscorr * (N - k) / N.

{p 4 12 2}
{cmd:nagar}{space 3}rho_nagar = (rho_dw * N^2 + k^2) / (N^2 - k^2).


{marker examples}{...}
{title:Examples}

{phang}{cmd:. _crcar1 rho fullopt : my_res}{p_end}

{phang}{cmd:. _crcar1 rho fullopt : my_res, theil k(3)}{p_end}
