{smcl}
{* *! version 1.0.1  05may2011}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] arfimapsdensity()" "help mf_arfimapsdensity"}{...}
{vieweralsosee "" "--"}{...}
{viewerjumpto "Syntax" "mf_ucmpsdensity##syntax"}{...}
{viewerjumpto "Description" "mf_ucmpsdensity##description"}{...}
{viewerjumpto "Remarks" "mf_ucmpsdensity##remarks"}{...}
{viewerjumpto "Conformability" "mf_ucmpsdensity##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_ucmpsdensity##diagnostics"}{...}
{viewerjumpto "Source code" "mf_ucmpsdensity##source"}{...}
{title:Title}

{p 4 28 2}
{bf:[M-5] ucmpsdensity()} {hline 2} Parametric spectral density of a 
	time-series stochastic cycle{p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real matrix} 
{cmd:ucmpsdensity(}{it:real scalar n}{cmd:,} {it:real vector rho}{cmd:,}
	{it:real vector lambda}{cmd:,} {it:real vector order}{cmd:,} 
	{it:real scalar v}{cmd:,} 
	{it:real scalar pspectrum}{cmd:, |}{it:real vector range}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:ucmpsdensity(}{it:n}{cmd:,} {it:rho}{cmd:,} {it:lambda}{cmd:,} 
	{it:d}{cmd:,} {it:v}{cmd:,} {it:pspectrum}{cmd:, |}{it:range}{cmd:)}
computes the parametric spectral density of a time-series stochastic cycle
defined by its order, frequency, and damping effect.  The cycle frequencies are
stored in the vector {it:rho}, and the damping effects are stored in the vector
{it:lambda}.  {it:v} contains the process idiosyncratic error variance.  These
cycle parameters can be extracted from an unobserved-components model.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:ucmpsdensity()} returns an {it:n x k}+1 matrix
containing the spectral densities in the first {it:k} columns and the 
frequencies in the last column, where {it:k} = {cmd:length(}{it:rho}{cmd:)}.
The parametric spectrum is computed if {it:pspectrum} != 0.  By
default, {it:range} = (0,{helpb mf_pi:pi()})


{marker conformability}{...}
{title:Conformability}

    {cmd:ucmpsdensity(}{it:n}{cmd:,} {it:rho}{cmd:,} {it:lambda}{cmd:,} {it:order}{cmd:,} {it:v}{cmd:,} {it:pspectrum}{cmd:, |}{it:range}{cmd:)}:
	       {it:n}:  1 {it:x} 1
	     {it:rho}:  {it:k x} 1 or 1 {it:x k}
	  {it:lambda}:  {it:k x} 1 or 1 {it:x k}
	   {it:order}:  {it:k x} 1 or 1 {it:x k}
	       {it:v}:  1 {it:x} 1
       {it:pspectrum}:  1 {it:x} 1
	   {it:range}:  2 {it:x} 1 or 1 {it:x} 2
	  {it:result}:  {it:n x k}+1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
The frequencies, {it:rho}, must be in (0,{helpb mf_pi:pi()}).  The damping
effects, {it: lambda}, must be in (0,1).  The cycle order, {it:order}, must
contain positive integers.  The variance parameter, {it:v}, must be greater
than zero.  The range, if specified, must be in [0,{helpb mf_pi:pi()}].


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view ucmpsdensity.mata, adopath asis:ucmpsdensity.mata}
{p_end}
