{smcl}
{* *! version 1.2.5  15may2018}{...}
{vieweralsosee "[M-5] halton()" "mansection M-5 halton()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Mathematical" "help m4_mathematical"}{...}
{viewerjumpto "Syntax" "mf_halton##syntax"}{...}
{viewerjumpto "Description" "mf_halton##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_halton##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_halton##remarks"}{...}
{viewerjumpto "Conformability" "mf_halton##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_halton##diagnostics"}{...}
{viewerjumpto "Source code" "mf_halton##source"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[M-5] halton()} {hline 2}}Generate a Halton or Hammersley set
{p_end}
{p2col:}({mansection M-5 halton():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 27 2}
{it:real matrix}{bind:}
{cmd:halton(}{it:real scalar n}{cmd:,} {it:real scalar d}{cmd:)}

{p 8 27 2}
{it:real matrix}{bind:}
{cmd:halton(}{it:real scalar n}{cmd:,} {it:real scalar d}{cmd:,}
             {it:real scalar start}{cmd:)}

{p 8 27 2}
{it:real matrix}{bind:}
{cmd:halton(}{it:real scalar n}{cmd:,} {it:real scalar d}{cmd:,}
             {it:real scalar start}{cmd:,}
	     {it:real scalar hammersley}{cmd:)}


{p 8 21 2}
{it:void}{bind:}
{cmd:_halton(}{it:real matrix x}{cmd:)}

{p 8 21 2}
{it:void}{bind:}
{cmd:_halton(}{it:real matrix x}{cmd:,} {it:real scalar start}{cmd:)}

{p 8 21 2}
{it:void}{bind:}
{cmd:_halton(}{it:real matrix x}{cmd:,} {it:real scalar start}{cmd:,}
              {it:real scalar hammersley}{cmd:)}


{p 8 31 2}
{it:real colvector}{bind:}
{cmd:ghalton(}{it:real scalar n}{cmd:,} {it:real scalar base}{cmd:,}
{it:real scalar u}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:halton(}{it:n}{cmd:,} {it:d}{cmd:)} returns an {it:n} x {it:d} matrix
containing a Halton set of length {it:n} and dimension {it:d}.

{p 4 4 2}
{cmd:halton(}{it:n}{cmd:,} {it:d}{cmd:,} {it:start}{cmd:)} does the same thing,
but the first row of the returned matrix contains the sequences starting at
index {it:start}.  The default is {it:start} = 1.

{p 4 4 2}
{cmd:halton(}{it:n}{cmd:,} {it:d}{cmd:,} {it:start}{cmd:,}
{it:hammersley}{cmd:)}, with {it:hammersley} != 0, returns a Hammersley set of
length {it:n} and dimension {it:d} with the first row of the returned matrix
containing the sequences starting at index {it:start}.

{p 4 4 2}
{cmd:_halton(}{it:x}{cmd:)} modifies the {it:n} x {it:d} matrix {it:x} so that
it contains a Halton set of dimension {it:d} of length {it:n}.

{p 4 4 2}
{cmd:_halton(}{it:x}{cmd:,} {it:start}{cmd:)} does the same thing,
but the first row of the returned matrix contains the sequences starting at
index {it:start}.  The default is {it:start} = 1.

{p 4 4 2}
{cmd:_halton(}{it:x}{cmd:,} {it:start}{cmd:,} {it:hammersley}{cmd:)},
with {it:hammersley} != 0, returns a Hammersley set of length {it:n} and
dimension {it:d} with the first row of the returned matrix containing the
sequences starting at index {it:start}.

{p 4 4 2}
{cmd:ghalton(}{it:n}{cmd:,} {it:base}{cmd:,} {it:u}{cmd:)} returns an
{it:n} x 1 vector containing a (generalized) Halton sequence using base
{it:base} and starting from scalar 0 < {it:u} < 1, or a nonnegative
index {it:u} = 0, 1, 2, .... 


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 halton()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
The Halton sequences are generated from the first {it:d} primes and generally
have more uniform coverage over the unit cube of dimension {it:d} than that of
sequences generated from pseudouniform random numbers.  However, Halton
sequences based on large primes ({it:d} > 10) can be highly correlated, and
their coverage can be worse than that of the pseudorandom uniform sequences.

{p 4 4 2}
The Hammersley set contains the sequence (2 * {it:i} - 1)/(2 * {it:n}), 
{it:i} = 1, ..., {it:n}, in
the first dimension and Halton sequences for dimensions 2, ..., {it:d}.

{p 4 4 2}
{cmd:_halton()} modifies {it:x} and can be used when repeated calls are made
to generate long sequences in blocks.  Here update the {it:start} index
between calls by using {it:start} = {it:start} + {cmd:rows(}{it:x}{cmd:)}.

{p 4 4 2}
{cmd:ghalton()} uses the base {it:base}, preferably a prime, and generates a
Halton sequence using 0 < {it:u} < 1 or a nonnegative index as the starting
value.  If {it:u} is uniform (0,1), the sequence is a randomized Halton
sequence.  If {it:u} is a nonnegative integer, the sequence is the standard
Halton sequence starting at index {it:u}+1.


{marker conformability}{...}
{title:Conformability}

    {cmd:halton(}{it:n}{cmd:,} {it:d}{cmd:,} {it:start}{cmd:,} {it:hammersley}{cmd:)}:
       {it:input:}
                 {it:n}:  1 {it:x} 1
                 {it:d}:  1 {it:x} 1
             {it:start}:  1 {it:x} 1    (optional)
        {it:hammersley}:  1 {it:x} 1    (optional)
       {it:output:}
            {it:result}:  {it:n x d}
		 
    {cmd:_halton(}{it:x}{cmd:,} {it:start}{cmd:,} {it:hammersley}{cmd:)}:
       {it:input:}
                 {it:x}:  {it:n x d}
             {it:start}:  1 {it:x} 1    (optional)
        {it:hammersley}:  1 {it:x} 1    (optional)
       {it:output:}
                 {it:x}:  {it:n x d}

    {cmd:ghalton(}{it:n}{cmd:,} {it:base}{cmd:,} {it:u}{cmd:)}:
       {it:input:}
                 {it:n}:  1 {it:x} 1
              {it:base}:  1 {it:x} 1
                 {it:u}:  1 {it:x} 1
       {it:output:}
            {it:result}:  {it:n x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
The maximum dimension, {it:d}, is 20.
The scalar index {it:start} must be a positive integer, and
the scalar {it:u} must be such that {bind:0 < {it:u} < 1} or a nonnegative
integer.  For {cmd:ghalton()}, {it:base} must be an integer greater than or
equal to 2.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view halton.mata, adopath asis:halton.mata} for
{cmd:halton()} and {cmd:_halton()}.

{pstd}
{cmd:ghalton()} is built in.
{p_end}
