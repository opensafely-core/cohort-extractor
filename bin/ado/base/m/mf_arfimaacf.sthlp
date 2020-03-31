{smcl}
{* *! version 1.0.2  11may2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] toeplitzsolve()" "help mf_toeplitzsolve"}{...}
{vieweralsosee "" "--"}{...}
{viewerjumpto "Syntax" "mf_arfimaacf##syntax"}{...}
{viewerjumpto "Description" "mf_arfimaacf##description"}{...}
{viewerjumpto "Remarks" "mf_arfimaacf##remarks"}{...}
{viewerjumpto "Conformability" "mf_arfimaacf##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_arfimaacf##diagnostics"}{...}
{viewerjumpto "Source code" "mf_arfimaacf##source"}{...}
{title:Title}

{p 4 25 2}
{bf:[M-5] arfimaacf()} {hline 2} Autocovariance functions 


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real colvector} 
{cmd:arfimaacf(}{it:real scalar n}{cmd:,} {it:real colvector phi}{cmd:,}
	{it:real colvector theta}{cmd:,} {it:real scalar d}{cmd:,} 
	{it:real scalar v}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:arfimaacf(}{it:n}{cmd:,} {it:phi}{cmd:,} {it:theta}{cmd:,} 
	{it:d}{cmd:,} {it:v}{cmd:)}
computes the autocovariance function (ACF) of an autoregressive
fractionally integrated moving-average (ARFIMA) process defined by the
autoregressive parameters, {it:phi}, the moving-average parameters, {it:theta},
the fractional integration parameter, {it:d}, and the idiosyncratic error
variance, {it:v}.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:arfimaacf()} returns a vector of length {it:n}+1,
where the first element is the variance of the ARFIMA or ARMA process and
elements k = 2, ..., {it:n}+1 are the autocovariances of the time-series
process k-1 time units apart.  The ACF of an ARMA process is obtained when
{it:d} = 0.


{marker conformability}{...}
{title:Conformability}

    {cmd:arfimaacf(}{it:n}{cmd:,} {it:phi}{cmd:,} {it:theta}{cmd:,} {it:d}{cmd:,} {it:v}{cmd:)}:
	       {it:n}:  1 {it:x} 1
	     {it:phi}:  {it:p x} 1
	   {it:theta}:  {it:q x} 1
	       {it:d}:  1 {it:x} 1
	       {it:v}:  1 {it:x} 1
	  {it:result}:  {it:n}+1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
The AR({it:p}) and MA({it:q}) polynomials defined by {it:phi} and {it:theta}
must have roots outside the unit circle, and the two polynomials may not have
common roots.  The fractional integration parameter must be in (-1,1/2).  The
variance parameter, {it:v}, must be greater than zero.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view arfimaacf.mata, adopath asis:arfimaacf.mata}
{p_end}
