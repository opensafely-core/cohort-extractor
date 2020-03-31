{smcl}
{* *! version 1.0.2  01mar2017}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] ucmpsdensity()" "help mf_ucmpsdensity"}{...}
{viewerjumpto "Syntax" "mf_arfimapsdensity##syntax"}{...}
{viewerjumpto "Description" "mf_arfimapsdensity##description"}{...}
{viewerjumpto "Remarks" "mf_arfimapsdensity##remarks"}{...}
{viewerjumpto "Conformability" "mf_arfimapsdensity##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_arfimapsdensity##diagnostics"}{...}
{viewerjumpto "Source code" "mf_arfimapsdensity##source"}{...}
{title:Title}

{p 4 31 2}
{bf:[M-5] arfimapsdensity()} {hline 2} Parametric spectral density
functions{p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real matrix} 
{cmd:arfimapsdensity(}{it:real scalar n}{cmd:,} {it:real colvector phi}{cmd:,}
	{it:real colvector theta}{cmd:,} {it:real scalar d}{cmd:,} 
	{it:real scalar v}{cmd:,} 
	{it:real scalar pspectrum}{cmd:, |}{it:real vector range}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:arfimapsdensity(}{it:n}{cmd:,} {it:phi}{cmd:,} {it:theta}{cmd:,} 
	{it:d}{cmd:,} {it:v}{cmd:,} {it:pspectrum}{cmd:, |}{it:range}{cmd:)}
computes the parametric spectral density of an autoregressive
fractionally integrated moving-average (ARFIMA) process defined by the
autoregressive parameters, {it:phi}, the moving-average parameters, {it:theta},
the fractional integration parameter, {it:d}, and the idiosyncratic error
variance, {it:v}. 


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:arfimapsdensity()} returns an {it:n x} 2 matrix containing the spectral
density in the first column and the frequencies in the second column.  The
parametric spectrum is computed if {it:pspectrum} != 0.  By default, 
{it:range} = (0,{helpb mf_pi:pi()}).  The spectral density of an ARMA process
is obtained when {it:d} = 0.


{marker conformability}{...}
{title:Conformability}

    {cmd:arfimapsdensity(}{it:n}{cmd:,} {it:phi}{cmd:,} {it:theta}{cmd:,} {it:d}{cmd:,} {it:v}{cmd:,} {it:pspectrum}{cmd:, |}{it:range}{cmd:)}:
	       {it:n}:  1 {it:x} 1
	     {it:phi}:  {it:p x} 1
	   {it:theta}:  {it:q x} 1
	       {it:d}:  1 {it:x} 1
	       {it:v}:  1 {it:x} 1
       {it:pspectrum}:  1 {it:x} 1
	   {it:range}:  2 {it:x} 1 or 1 {it:x} 2
	  {it:result}:  {it:n x} 2


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
The AR({it:p}) and MA({it:q}) polynomials defined by {it:phi} and {it:theta}
must have roots outside the unit circle and the two polynomials may not have
common roots.  The fractional integration parameter must be in (-1,1/2).  The
variance parameter, {it:v}, must be greater than zero.  {it:range}, if
specified, must be in [0,{helpb mf_pi:pi()}].


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view arfimapsdensity.mata, adopath asis:arfimapsdensity.mata}
{p_end}
