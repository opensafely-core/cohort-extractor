{smcl}
{* *! version 2.1.13  15may2018}{...}
{vieweralsosee "[M-5] ghkfast()" "mansection M-5 ghkfast()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] ghk()" "help mf_ghk"}{...}
{vieweralsosee "[M-5] halton()" "help mf_halton"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Statistical" "help m4_statistical"}{...}
{viewerjumpto "Syntax" "mf_ghkfast##syntax"}{...}
{viewerjumpto "Description" "mf_ghkfast##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_ghkfast##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_ghkfast##remarks"}{...}
{viewerjumpto "Conformability" "mf_ghkfast##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_ghkfast##diagnostics"}{...}
{viewerjumpto "Source code" "mf_ghkfast##source"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[M-5] ghkfast()} {hline 2}}Geweke-Hajivassiliou-Keane (GHK) multivariate normal simulator using pregenerated points
{p_end}
{p2col:}({mansection M-5 ghkfast():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 19 25 2}
{it:S} {cmd:=}
{cmd:ghkfast_init(}{it:real scalar n}{cmd:, }{it:npts}{cmd:, }{it:dim}{cmd:, }
{it:string scalar} {it:{help mf_ghkfast##method:method}}{cmd:)}

{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:ghkfast_init_pivot(}{it:S} [{cmd:, }{it:real scalar pivot}]{cmd:)}

{p 8 25 2}
{it:(varies)}{bind:      }
{cmd:ghkfast_init_antithetics(}{it:S} [{cmd:, }{it:real scalar anti}]{cmd:)}

{p 8 25 2}
{it:real scalar}{bind:   }
{cmd:ghkfast_query_n(}{it:S}{cmd:)}

{p 8 25 2}
{it:real scalar}{bind:   }
{cmd:ghkfast_query_npts(}{it:S}{cmd:)}

{p 8 25 2}
{it:real scalar}{bind:   }
{cmd:ghkfast_query_dim(}{it:S}{cmd:)}

{p 8 25 2}
{it:string scalar}{bind: }
{cmd:ghkfast_query_method(}{it:S}{cmd:)}

{p 8 25 2}
{it:string scalar}{bind: }
{cmd:ghkfast_query_rseed(}{it:S}{cmd:)}

{p 8 25 2}
{it:real matrix}{bind:   }
{cmd:ghkfast_query_pointset_i(}{it:S}{cmd:, }{it:i}{cmd:)}

{p 8 25 2}
{it:real colvector}
{cmd:ghkfast(}{it:S}{cmd:, }{it:real matrix X}{cmd:, }{it:V}{cmd:)} 

{p 8 25 2}
{it:real colvector}
{cmd:ghkfast(}{it:S}{cmd:, }{it:real matrix X}{cmd:, }{it:V}{cmd:,} 
{it:dfdx}{cmd:, }{it:dfdv}{cmd:)}

{p 8 25 2}
{it:real scalar}
{cmd:ghkfast_i(}{it:S}{cmd:, }{it:real matrix X}{cmd:, }{it:V}{cmd:, }
{it:i}{cmd:)} 

{p 8 25 2}
{it:real scalar}
{cmd:ghkfast_i(}{it:S}{cmd:, }{it:real matrix X}{cmd:, }{it:V}{cmd:,} 
{it:i}{cmd:, }{it:dfdx}{cmd:, }{it:dfdv}{cmd:)}

{p 4 4 2}
where {it:S}, if it is declared, should be declared

		{cmd:transmorphic} {it:S}

{marker method}{...}
{pstd}
and where {it:method} specified in {cmd:ghkfast_init()} is

{col 16}{it:method}{col 32}Description
{col 16}{hline 60}
{col 16}{cmd:"halton"}{col 32}Halton sequences
{col 16}{cmd:"hammersley"}{col 32}Hammersley's variation of the Halton set
{col 16}{cmd:"random"}{col 32}pseudorandom uniforms
{col 16}{cmd:"ghalton"}{col 32}generalized Halton sequences
{col 16}{hline 60}
 

{marker description}{...}
{title:Description}

{pstd}
Please see {bf:{help mf_ghk:[M-5] ghk()}}.  The routines documented here do 
the same thing, but {cmd:ghkfast()} can be faster at the expense of using
more memory.  First, code {it:S} {cmd:=} {cmd:ghkfast_init(}...{cmd:)} and then
use {cmd:ghkfast(}{it:S}{cmd:,} ...{cmd:)} to obtain the simulated values.
There is a time savings because the simulation points are generated once in
{cmd:ghkfast_init()}, whereas for {cmd:ghk()} the points are generated on each
call to {cmd:ghk()}.  Also, {cmd:ghkfast()} can generate simulated
probabilities from the generalized Halton sequence; see 
{bf:{help mf_halton:[M-5] halton()}}.

{p 4 4 2}
{cmd:ghkfast_init(}{it:n}{cmd:, }{it:npts}{cmd:, }{it:dim}{cmd:, }{it:method}{cmd:)}
computes the simulation points to be used by {cmd:ghkfast()}.  Inputs {it:n},
{it:npts}, and {it:dim} are the number of observations, the number of
repetitions for the simulation, and the maximum dimension of the multivariate
normal (MVN) distribution, respectively.  Input {it:method} specifies the type
of points to generate and can be one of {cmd:"halton"}, {cmd:"hammersley"},
{cmd:"random"}, or {cmd:"ghalton"}.

{p 4 4 2}
{cmd:ghkfast(}{it:S}{cmd:,} {it:X}{cmd:,} {it:V}{cmd:)}
returns an {it:n x} 1 real vector containing the simulated values of the
MVN distribution with {it:dim x dim} variance-covariance matrix {it:V} at the
points stored in the rows of the {it:n x dim} matrix {it:X}.

{p 4 4 2}
{cmd:ghkfast(}{it:S}{cmd:, }{it:X}{cmd:, }{it:V}{cmd:, }{it:dfdx}{cmd:, }{it:dfdv}{cmd:)}
does the same thing as {cmd:ghkfast(}{it:S}{cmd:,} {it:X}{cmd:,} {it:V}{cmd:)}
but also returns the first-order derivatives of the
simulated probability with respect to the rows of {it:X} in {it:dfdx} and the
simulated probability derivatives with respect to {cmd:vech(}{it:V}{cmd:)} in
{it:dfdv}.  See {cmd:vech()} in {bf:{help mf_vec:[M-5] vec()}} for details of
the half-vectorized operator.

{p 4 4 2}
The {cmd:ghk_query_n(}{it:S}{cmd:)}, 
{cmd:ghk_query_npts(}{it:S}{cmd:)},  
{cmd:ghk_query_dim(}{it:S}{cmd:)}, and
{cmd:ghk_query_method(}{it:S}{cmd:)} functions
extract the number of observations, number of simulation points, maximum
dimension, and method of point-set generation that is specified in the
construction of the transmorphic object {it:S}.  Use
{cmd:ghk_query_rseed(}{it:S}{cmd:)} to retrieve the uniform random-variate seed
used to generate the {cmd:"random"} or {cmd:"ghalton"} point sets.  The
{cmd:ghkfast_query_pointset_i(}{it:S}{cmd:, }{it:i}{cmd:)} function will
retrieve the {it:i}th point set used to simulate the MVN probability for the
{it:i}th observation.

{p 4 4 2}
The 
{cmd:ghkfast_i(}{it:S}{cmd:, }{it:X}{cmd:, }{it:V}{cmd:, }{it:i}{cmd:, }...{cmd:)} function
computes the probability and derivatives for the {it:i}th observation, 
{it:i} = 1, ..., {it:n}. 


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 ghkfast()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
For problems where repetitive calls to the GHK algorithm are required,
{cmd:ghkfast()} might be a preferred alternative to {helpb mf_ghk:ghk()}.
Generating the points once at the outset of a program produces a speed
increase.  For problems with many observations or many simulation points per
observation, {cmd:ghkfast()} will be faster than {cmd:ghk()} at the cost of
requiring more memory.

{p 4 4 2}
If {cmd:ghkfast()} is used within a likelihood evaluator for {cmd:ml} or
{cmd:optimize()}, you will need to store the transmorphic object {it:S}
as an {help m2_declarations##remarks10:external} global and reuse the
object with each likelihood evaluation.  Alternatively, the initialization
function for {cmd:optimize()}, 
{helpb mf_optimize##i_argument:optimize_init_argument()}, can be used.

{p 4 4 2}
Prior to calling {cmd:ghkfast()}, call 
{cmd:ghkfast_init_npivot(}{it:S}{cmd:,}1{cmd:)} to turn off the integration
interval pivoting that takes place in {cmd:ghkfast()}.  By default,
{cmd:ghkfast()} pivots the wider intervals of integration (and associated
rows/columns of the covariance matrix) to the interior of the multivariate
integration to improve quadrature accuracy.  This option may be useful when
{cmd:ghkfast()} is used in a likelihood evaluator for {helpb ml:[R] ml} or
{helpb mf_optimize:[M-5] optimize()} and few simulation points are used for
each observation.  Here the pivoting may cause discontinuities when
computing numerical second-order derivatives using finite differencing (for the
Newton-Raphson technique), resulting in a non-positive-definite Hessian.

{p 4 4 2}
Also the sequences {cmd:"halton"}, {cmd:"hammersley"}, and
{cmd:"random"}, {cmd:ghkfast()} will use the generalized Halton sequence,
{cmd:"ghalton"}.  Generalized Halton sequences have the same uniform coverage
(low discrepancy) as the Halton sequences with the addition of a pseudorandom
uniform component.  Therefore, {cmd:"ghalton"} sequences are like
{cmd:"random"} sequences in that you should set the random-number seed before
using them if you wish to replicate the same point set; see 
{bf:{help mf_runiform:[M-5] runiform()}}.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
All initialization functions have 1 {it:x} 1 inputs and have 1 {it:x} 1 or
{it:void} outputs, and all query functions have the {it:transmorphic} input 
and 1 {it:x} 1 outputs except

    {cmd:ghkfast_init(}{it:n}{cmd:, }{it:npts}{cmd:, }{it:dim}{cmd:, }{it:method}{cmd:)}:
        {it:input:}
                {it:n}:  1 {it:x} 1 
             {it:npts}:  1 {it:x} 1
              {it:dim}:  1 {it:x} 1 
           {it:method}:  1 {it:x} 1 
        {it:output:}
 	   {it:result}:  {it:transmorphic}

    {cmd:ghkfast_query_pointset_i(}{it:S}{cmd:,} {it:i}{cmd:)}:
        {it:input:}
                {it:S}:  {it:transmorphic}
                {it:i}:  1 {it:x} 1 
        {it:output:}
           {it:result}:  {it:npts} {it:x} {it:dim} 

    {cmd:ghkfast(}{it:S}{cmd:,} {it:X}{cmd:, }{it:V}{cmd:)}:
        {it:input:}
                {it:S}:  {it:transmorphic}
                {it:X}:  {it:n x dim} 
                {it:V}:  {it:dim x dim} (symmetric, positive definite)
        {it:output:}
           {it:result}:  n {it:x} 1 

    {cmd:ghkfast(}{it:S}{cmd:,} {it:X}{cmd:, }{it:V}{cmd:, }{it:dfdx}{cmd:, }{it:dfdv}{cmd:)}:
        {it:input:}
                {it:S}:  {it:transmorphic}
                {it:X}:  {it:n x dim}
                {it:V}:  {it:dim x dim} (symmetric, positive definite)
        {it:output:}
           {it:result}:  {it:n x} 1
             {it:dfdx}:  {it:n x dim}
             {it:dfdv}:  {it:n x dim}({it:dim}+1)/2

    {cmd:ghkfast_i(}{it:S}{cmd:,} {it:X}{cmd:, }{it:V}{cmd:, }{it:i}{cmd:, }{it:dfdx}{cmd:, }{it:dfdv}{cmd:)}:
        {it:input:}
                {it:S}:  {it:transmorphic}
                {it:X}:  {it:n x dim} or 1 {it:x dim}
                {it:V}:  {it:dim x dim} (symmetric, positive definite)
                {it:i}:  1 {it:x} 1     (1 {ul:<} {it:i} {ul:<} {it:n})
        {it:output:}
           {it:result}:  n {it:x} 1
             {it:dfdx}:  1 {it:x dim}
             {it:dfdv}:  1 {it:x dim}({it:dim}+1)/2


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:ghkfast_init(}{it:n}{cmd:,} {it:npts}{cmd:,} {it:dim}{cmd:,} {it:method}{cmd:)}
aborts with error if the dimension, {it:dim}, is greater than 20.

{p 4 4 2}
{cmd:ghkfast(}{it:S}{cmd:,} {it:X}{cmd:, }{it:V}{cmd:,} ...{cmd:)} and
{cmd:ghkfast_i(}{it:S}{cmd:,} {it:X}{cmd:, }{it:V}{cmd:, }{it:i}{cmd:,} ...{cmd:)}
require that {it:V} be symmetric and positive definite.
If {it:V} is not positive definite, then the returned vector (scalar) is filled 
with missings.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view ghkfast.mata, adopath asis:ghkfast.mata}
{p_end}
