{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[M-5] svsolve()" "mansection M-5 svsolve()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] cholsolve()" "help mf_cholsolve"}{...}
{vieweralsosee "[M-5] lusolve()" "help mf_lusolve"}{...}
{vieweralsosee "[M-5] qrsolve()" "help mf_qrsolve"}{...}
{vieweralsosee "[M-5] solvelower()" "help mf_solvelower"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{vieweralsosee "[M-4] Solvers" "help m4_solvers"}{...}
{viewerjumpto "Syntax" "mf_svsolve##syntax"}{...}
{viewerjumpto "Description" "mf_svsolve##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_svsolve##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_svsolve##remarks"}{...}
{viewerjumpto "Conformability" "mf_svsolve##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_svsolve##diagnostics"}{...}
{viewerjumpto "Source code" "mf_svsolve##source"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[M-5] svsolve()} {hline 2}}Solve AX=B for X using singular value decomposition
{p_end}
{p2col:}({mansection M-5 svsolve():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:numeric matrix}
{cmd:svsolve(}{it:A}{cmd:,}
{it:B}{cmd:)}

{p 8 12 2}
{it:numeric matrix}
{cmd:svsolve(}{it:A}{cmd:,}
{it:B}{cmd:,} {it:rank}{cmd:)}

{p 8 12 2}
{it:numeric matrix}
{cmd:svsolve(}{it:A}{cmd:,}
{it:B}{cmd:,} {it:rank}{cmd:,} {it:tol}{cmd:)}


{p 8 12 2}
{it:real scalar}{bind:  }
{cmd:_svsolve(}{it:A}{cmd:,}
{it:B}{cmd:)}

{p 8 12 2}
{it:real scalar}{bind:  }
{cmd:_svsolve(}{it:A}{cmd:,}
{it:B}{cmd:,} {it:tol}{cmd:)}


{p 4 4 2}
where

{p 24 24 2}
		{it:A}:  {it:numeric matrix}

{p 24 24 2}
		{it:B}:  {it:numeric matrix}

{p 21 24 2}
	     {it:rank}:  irrelevant; {it:real scalar} returned

{p 22 24 2}
	      {it:tol}:  {it:real scalar}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:svsolve(}{it:A}{cmd:,} {it:B}{cmd:,} ...{cmd:)},
uses singular value decomposition to solve {it:A}{it:X}={it:B} and return
{it:X}.  When {it:A} is singular, {cmd:svsolve()} computes the minimum-norm
least-squares generalized solution.  When {it:rank} is specified, in it
is placed the rank of {it:A}.

{p 4 4 2}
{cmd:_svsolve(}{it:A}{cmd:,} {it:B}{cmd:,} ...{cmd:)}
does the same thing, except that it destroys the contents of {it:A} and 
it overwrites {it:B} with the solution.  Returned is the rank of {it:A}.

{p 4 4 2}
In both cases, {it:tol} specifies the tolerance for determining whether
{it:A} is of full rank.  {it:tol} is interpreted in the standard way --
as a multiplier for the default if {it:tol}>0 is specified and as
an absolute quantity to use in place of the default if {it:tol}<=0
is specified.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 svsolve()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:svsolve(}{it:A}{cmd:,} {it:B}{cmd:,} ...{cmd:)} is suitable for use with
square or nonsquare, full-rank or rank-deficient matrix {it:A}.
When {it:A} is of full rank,
{cmd:svsolve()} returns the same solution as
{cmd:lusolve()} (see {bf:{help mf_lusolve:[M-5] lusolve()}}),
ignoring roundoff error.  When {it:A} is singular, {cmd:svsolve()} returns 
the minimum-norm least-squares generalized solution.  
{cmd:qrsolve()} (see {bf:{help mf_qrsolve:[M-5] qrsolve()}}), an alternative,
returns a generalized least-squares solution that amounts to dropping rows of
{it:A}.

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_svsolve##remarks1:Derivation}
	{help mf_svsolve##remarks2:Relationship to inversion}
	{help mf_svsolve##remarks3:Tolerance}


{marker remarks1}{...}
{title:Derivation}

{p 4 4 2}
We wish to solve for {it:X}

		{it:A}{it:X} = {it:B}{right:(1)    }

{p 4 4 2}
Perform singular value decomposition on {it:A} so that we have 
{it:A} = {it:USV}{bf:'}.  Then (1) can be rewritten as

		{it:USV}{bf:'}{it:X} = {it:B}

{p 4 4 2}
Premultiplying by {it:U}{bf:'} and remembering that {it:U}{bf:'}{it:U}={it:I},
we have 

		{it:SV}{bf:'}{it:X} = {it:U}{bf:'}{it:B}

{p 4 4 2}
Matrix {it:S} is diagonal and thus its inverse is easily calculated, and 
we have 

		{it:V}{bf:'}{it:X} = {it:S}^(-1){it:U}{bf:'}{it:B}

{p 4 4 2}
When we premultiply by {it:V}, remembering that {it:V}{it:V}{bf:'}={it:I}, 
the solution is 

		{it:X} = {it:V}{it:S}^(-1){it:U}{bf:'}{it:B}{right:(2)    }

{p 4 4 2}
See {bf:{help mf_svd:[M-5] svd()}} for more information on the SVD.


{marker remarks2}{...}
{title:Relationship to inversion}

{p 4 4 2}
For a general discussion,
see {it:{help mf_lusolve##remarks2:Relationship to inversion}} in
{bf:{help mf_lusolve:[M-5] lusolve()}}.
                                                                                
{p 4 4 2}
For an inverse based on the SVD, see
{bf:{help mf_pinv:[M-5] pinv()}}.  {cmd:pinv(}{it:A}{cmd:)} amounts to 
{cmd:svsolve(}{it:A}{cmd:,} {cmd:I(rows(}{it:A}{cmd:)))}, although 
{cmd:pinv()} has separate code that uses less memory.


{marker remarks3}{...}
{title:Tolerance}

{p 4 4 2}
In (2) above, we are required to calculate the inverse of diagonal 
matrix {it:S}.  The generalized solution is obtained by substituting zero for
the {it:i}th diagonal element of {it:S}^(-1), where the {it:i}th diagonal
element of {it:S} is less than or equal to {it:eta} in absolute value.  
The default value of {it:eta} is

		{it:eta} = epsilon(1)*rows({it:A})*max({it:S})

{p 4 4 2}
If you specify {it:tol}>0, the value you specify is used to multiply {it:eta}.
You may instead specify {it:tol}<=0 and then the negative of the value you
specify is used in place of {it:eta}; see 
{bf:{help m1_tolerance:[M-1] Tolerance}}.


{marker conformability}{...}
{title:Conformability}

    {cmd:svsolve(}{it:A}{cmd:,} {it:B}{cmd:,} {it:rank}{cmd:,} {it:tol}{cmd:)}:
	{it:input:}
		{it:A}:  {it:m x n}
		{it:B}:  {it:m x k}
	      {it:tol}:  1 {it:x} 1    (optional)
	{it:output:}
	     {it:rank}:  1 {it:x} 1    (optional)
	   {it:result}:  {it:n x k}

    {cmd:_svsolve(}{it:A}{cmd:,} {it:B}{cmd:,} {it:tol}{cmd:)}:
	{it:input:}
		{it:A}:  {it:m x n}
		{it:B}:  {it:m x k}
	      {it:tol}:  1 {it:x} 1    (optional)
	{it:output:}
		{it:A}:  0 {it:x} 0
		{it:B}:  {it:m x k}
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:svsolve(}{it:A}{cmd:,} {it:B}{cmd:,} ...{cmd:)}
and 
{cmd:_svsolve(}{it:A}{cmd:,} {it:B}{cmd:,} ...{cmd:)}
return missing results if {it:A} or {it:B} contain missing.

{p 4 4 2}
{cmd:_svsolve(}{it:A}{cmd:,} {it:B}{cmd:,} ...{cmd:)}
aborts with error if {it:A} (but not {it:B}) is a view.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view svsolve.mata, adopath asis:svsolve.mata},
{view _svsolve.mata, adopath asis:_svsolve.mata}
{p_end}
