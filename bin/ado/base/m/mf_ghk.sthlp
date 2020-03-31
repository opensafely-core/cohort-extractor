{smcl}
{* *! version 2.1.12  15may2018}{...}
{vieweralsosee "[M-5] ghk()" "mansection M-5 ghk()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] ghkfast()" "help mf_ghkfast"}{...}
{vieweralsosee "[M-5] halton()" "help mf_halton"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Statistical" "help m4_statistical"}{...}
{viewerjumpto "Syntax" "mf_ghk##syntax"}{...}
{viewerjumpto "Description" "mf_ghk##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_ghk##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_ghk##remarks"}{...}
{viewerjumpto "Conformability" "mf_ghk##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_ghk##diagnostics"}{...}
{viewerjumpto "Source code" "mf_ghk##source"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[M-5] ghk()} {hline 2}}Geweke-Hajivassiliou-Keane (GHK) multivariate normal simulator
{p_end}
{p2col:}({mansection M-5 ghk():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 17 25 2}
{it:S} {cmd:=}
{cmd:ghk_init(}{it:real scalar npts}{cmd:)}

{p 8 25 2}
{it:(varies)}{bind:    }
{cmd:ghk_init_method(}{it:S} [{cmd:, }{it:string scalar method}]{cmd:)}

{p 8 25 2}
{it:(varies)}{bind:    }
{cmd:ghk_init_start(}{it:S} [{cmd:, }{it:real scalar start}]{cmd:)}

{p 8 25 2}
{it:(varies)}{bind:    }
{cmd:ghk_init_pivot(}{it:S} [{cmd:, }{it:real scalar pivot}]{cmd:)}

{p 8 25 2}
{it:(varies)}{bind:    }
{cmd:ghk_init_antithetics(}{it:S} [{cmd:, }{it:real scalar anti}]{cmd:)}

{p 8 25 2}
{it:real scalar}{bind: }
{cmd:ghk_query_npts(}{it:S}{cmd:)}

{p 8 25 2}
{it:real scalar}{bind: }
{cmd:ghk(}{it:S}{cmd:, }{it:real vector x}{cmd:, }{it:V}{cmd:)}

{p 8 25 2}
{it:real scalar}{bind: }
{cmd:ghk(}{it:S}{cmd:, }{it:real vector x}{cmd:, }{it:V}{cmd:, }
{it:real rowvector dfdx}{cmd:, }{it:dfdv}{cmd:)}

{p 4 4 2}
where {it:S}, if declared, should be declared

{p 17 17 2}
{cmd:transmorphic}{it: S}

{p 4 4 2}
and where {it:method}, optionally specified in {cmd:ghk_init_method()}, is

{col 16}{it:method}{col 32}Description
{col 16}{hline 60}
{col 16}{cmd:"halton"}{col 32}Halton sequences
{col 16}{cmd:"hammersley"}{col 32}Hammersley's variation of the Halton set
{col 16}{cmd:"random"}{col 32}pseudorandom uniforms
{col 16}{hline 60}


{marker description}{...}
{title:Description}

{pstd}
The {cmd:ghk}*{cmd:()} set of functions provide a Geweke-Hajivassiliou-Keane
(GHK) multivariate normal simulator.

{p 4 4 2}
{it:S} {cmd:= }{cmd:ghk_init(}{it:npts}{cmd:)} initializes the simulator
with the desired number of simulation points and returns a transmorphic
object {it:S}, which is a handle that should be used in subsequent calls
to the other {cmd:ghk}*{cmd:()} functions.  Calls to 
{cmd:ghk_init_method(}{it:S}{cmd:, }{it:method}{cmd:)}, 
{cmd:ghk_init_start(}{it:S}{cmd:, }{it:start}{cmd:)},
{cmd:ghk_init_pivot(}{it:S}{cmd:, }{it:pivot}{cmd:)}, and
{cmd:ghk_init_antithetics(}{it:S}{cmd:, }{it:anti}{cmd:)} prior to calling
{cmd:ghk(}{it:S}{cmd:,} ...{cmd:)} allow you to modify the simulation algorithm
through the object {it:S}.  

{p 4 4 2}
{cmd:ghk(}{it:S}{cmd:, }{it:x}{cmd:, }{it:V}{cmd:)} returns a real scalar
containing the simulated value of the multivariate normal (MVN) distribution
with variance-covariance {it:V} at the point {it:x}.  First, code {it:S} {cmd:=}
{cmd:ghk_init(}{it:npts}{cmd:)} and then use {cmd:ghk(}{it:S}{cmd:,} ...{cmd:)}
to obtain the simulated value based on {it:npts} simulation points.

{p 4 4 2}
{cmd:ghk(}{it:S}{cmd:, }{it:x}{cmd:, }{it:V}{cmd:, }{it:dfdx}{cmd:, }{it:dfdv}{cmd:)} 
does the same thing but also returns the first-order derivatives of the simulated 
probability with respect to {it:x} in {it:dfdx} and the simulated probability 
derivatives with respect to {cmd:vech(}{it:V}{cmd:)} in {it:dfdv}.  See 
{cmd:vech()} in {bf:{help mf_vec:[M-5] vec()}} for details of the
half-vectorized operator.

{p 4 4 2}
The {cmd:ghk_query_npts(}{it:S}{cmd:)} function returns the number of
simulation points, the same value given in the construction of the transmorphic
object {it:S}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 ghk()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Halton and Hammersley point sets are composed of deterministic sequences on [0,1] 
and, for sets of dimension less than 10, generally have better coverage than 
that of the uniform pseudorandom sequences.

{p 4 4 2}
Antithetic draws effectively double the number of points and reduce the 
variability of the simulated probability.  For draw {it:u}, the antithetic
draw is 1 - {it:u}.  To use antithetic draws, call
{cmd:ghk_init_antithetic(}{it:S}{cmd:, }1{cmd:)} prior to executing 
{cmd:ghk()}.

{p 4 4 2}
By default, {cmd:ghk()} will pivot the wider intervals of integration (and
associated rows/columns of the covariance matrix) to the interior of the
multivariate integration.  This improves the accuracy of the quadrature
estimate.  When {cmd:ghk()} is used in a likelihood evaluator for
{helpb ml:[R] ml} or  {helpb mf_optimize:[M-5] optimize()}, discontinuities may
result in the computation of numerical second-order derivatives using finite
differencing (for the Newton-Raphson optimization technique) when few
simulation points are used, resulting in a non-positive-definite Hessian.  To
turn off the interval pivoting, call
{cmd:ghk_init_pivot(}{it:S}{cmd:, }0{cmd:)} prior to executing {cmd:ghk()}.

{p 4 4 2}
If you are using {cmd:ghk()} in a likelihood evaluator, be sure to
use the same sequence with each call to the likelihood evaluator.  For a
uniform pseudorandom sequence, {cmd:ghk_init_method("random")}, set the seed
of the uniform random-variate generator -- see {cmd:runiform()} in 
{bf:{help mf_runiform:[M-5] runiform()}} -- to the same value with each call to
the likelihood evaluator.  

{p 4 4 2}
If you are using the Halton or Hammersley point sets, you will want to keep the
sequences going with each call to {cmd:ghk()} within one likelihood evaluation.
This can be done in one expression executed after each call to {cmd:ghk()}:
{cmd:ghk_init_start(}{it:S}{cmd:, ghk_init_start(}{it:S}{cmd:)}+{cmd:ghk_query_npts(}{it:S}{cmd:))}.  With each call to the likelihood evaluator, you will
need to reset the starting index to 1.  This last point assumes that the
transmorphic object {it:S} is not re-created on each call to the likelihood
evaluator.

{p 4 4 2}
Unlike {cmd:ghkfast_init()} (see {helpb mf_ghkfast:[M-5] ghkfast()}), the
transmorphic object {it:S} created by {cmd:ghk_init()} is inexpensive to
create, so it is possible to re-create it with each call to your likelihood
evaluator instead of storing it as {help m2_declarations##remarks10:external}
global and reusing the object with each likelihood evaluation.  Alternatively,
the initialization function for {cmd:optimize()},
{helpb mf_optimize##i_argument:optimize_init_arguments()}, can be used.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
All initialization functions have 1 {it:x} 1 inputs and have 1 {it:x} 1 or
{it:void} outputs except

    {cmd:ghk_init(}{it:npts}{cmd:)}
        {it:input:}
             {it:npts}:  1 {it:x} 1
        {it:output:}
                {it:S}:  transmorphic

    {cmd:ghk_query_npts(}{it:S}{cmd:)}
        {it:input:}
                {it:S}:  transmorphic
        {it:output:}
           {it:result}:  1 {it:x} 1

    {cmd:ghk(}{it:S}{cmd:, }{it:x}{cmd:, }{it:V}{cmd:)}:
        {it:input:}
                {it:S}:  transmorphic
                {it:x}:  1 {it:x m} or {it:m x} 1
                {it:V}:  {it:m x m} (symmetric, positive definite)
        {it:output:}
           {it:result}:  1 {it:x} 1

    {cmd:ghk(}{it:S}{cmd:, }{it:x}{cmd:, }{it:V}{cmd:, }{it:dfdx}{cmd:, }{it:dfdv}{cmd:)}:
        {it:input:}
                {it:S}:  transmorphic
                {it:x}:  1 {it:x m} or {it:m x} 1
                {it:V}:  {it:m x m} (symmetric, positive definite) 
        {it:output:}
           {it:result}:  1 {it:x} 1
             {it:dfdx}:  1 {it:x m}
             {it:dfdv}:  1 {it:x m}({it:m}+1)/2


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
The maximum dimension, {it:m}, is 20.

{p 4 4 2}
{it:V} must be symmetric and positive definite.  {cmd:ghk()} will return 
a missing value when {it:V} is not positive definite.  When
{cmd:ghk()} is used in an {helpb ml} (or {helpb mf_optimize:optimize()})
likelihood evaluator, return a missing likelihood to {cmd:ml} and let {cmd:ml}
take the appropriate action (that is, step halving).


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view ghk.mata, adopath asis:ghk.mata}
{p_end}
