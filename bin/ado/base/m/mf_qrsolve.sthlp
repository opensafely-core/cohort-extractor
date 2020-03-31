{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[M-5] qrsolve()" "mansection M-5 qrsolve()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] cholsolve()" "help mf_cholsolve"}{...}
{vieweralsosee "[M-5] lusolve()" "help mf_lusolve"}{...}
{vieweralsosee "[M-5] qrd()" "help mf_qrd"}{...}
{vieweralsosee "[M-5] qrinv()" "help mf_qrinv"}{...}
{vieweralsosee "[M-5] solvelower()" "help mf_solvelower"}{...}
{vieweralsosee "[M-5] solve_tol()" "help mf_solve_tol"}{...}
{vieweralsosee "[M-5] svsolve()" "help mf_svsolve"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{vieweralsosee "[M-4] Solvers" "help m4_solvers"}{...}
{viewerjumpto "Syntax" "mf_qrsolve##syntax"}{...}
{viewerjumpto "Description" "mf_qrsolve##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_qrsolve##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_qrsolve##remarks"}{...}
{viewerjumpto "Conformability" "mf_qrsolve##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_qrsolve##diagnostics"}{...}
{viewerjumpto "Source code" "mf_qrsolve##source"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[M-5] qrsolve()} {hline 2}}Solve AX=B for X using QR decomposition
{p_end}
{p2col:}({mansection M-5 qrsolve():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:numeric matrix}
{cmd:qrsolve(}{it:A}{cmd:,}
{it:B}{cmd:)}

{p 8 12 2}
{it:numeric matrix}
{cmd:qrsolve(}{it:A}{cmd:,}
{it:B}{cmd:,} {it:rank}{cmd:)}

{p 8 12 2}
{it:numeric matrix}
{cmd:qrsolve(}{it:A}{cmd:,}
{it:B}{cmd:,} {it:rank}{cmd:,} {it:tol}{cmd:)}


{p 8 12 2}
{it:real scalar}{bind:  }
{cmd:_qrsolve(}{it:A}{cmd:,}
{it:B}{cmd:)}

{p 8 12 2}
{it:real scalar}{bind:  }
{cmd:_qrsolve(}{it:A}{cmd:,}
{it:B}{cmd:,} {it:tol}{cmd:)}


{p 4 8 2}
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
{cmd:qrsolve(}{it:A}{cmd:,} {it:B}{cmd:,} ...{cmd:)}
uses QR decomposition to solve {it:A}{it:X}={it:B} and returns {it:X}.
When {it:A} is singular or nonsquare, {cmd:qrsolve()} computes a least-squares
generalized solution.  When {it:rank} is specified, in it is placed the rank
of {it:A}.

{p 4 4 2}
{cmd:_qrsolve(}{it:A}{cmd:,} {it:B}{cmd:,} ...{cmd:)},
does the same thing, except that it destroys the contents of {it:A} and 
it overwrites {it:B} with the solution.  Returned is the rank of {it:A}.

{p 4 4 2}
In both cases, {it:tol} specifies the tolerance for determining whether 
{it:A} is of full rank.  {it:tol} is interpreted in the standard way -- 
as a multiplier for the default if {it:tol}>0 is specified and as 
an absolute quantity to use in place of the default if {it:tol}<=0 
is specified; see {bf:{help m1_tolerance:[M-1] Tolerance}}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 qrsolve()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:qrsolve(}{it:A}{cmd:,} {it:B}{cmd:,} ...{cmd:)} is suitable for use with
square and possibly rank-deficient matrix {it:A}, or when {it:A} has more rows
than columns.  When {it:A} is square and full rank, {cmd:qrsolve()} returns
the same solution as {cmd:lusolve()}
(see {bf:{help mf_lusolve:[M-5] lusolve()}}), up to roundoff
error.  When {it:A} is singular, {cmd:qrsolve()} returns a generalized
(least-squares) solution.

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_qrsolve##remarks1:Derivation}
	{help mf_qrsolve##remarks2:Relationship to inversion}
	{help mf_qrsolve##remarks3:Tolerance}


{marker remarks1}{...}
{title:Derivation}

{p 4 4 2}
We wish to solve for {it:X}

		{it:A}{it:X} = {it:B}{right:(1)    }

{p 4 4 2}
Perform QR decomposition on {it:A} so that we have {it:A} =
{it:Q}{it:R}{it:P}{bf:'}.  Then (1) can be rewritten as

		{it:QRP}{bf:'}{it:X} = {it:B}

{p 4 4 2}
Premultiplying by {it:Q}{bf:'} and remembering that 
{it:Q}{bf:'}{it:Q} = {it:Q}{it:Q}{bf:'} = {it:I},
we have 

		{it:RP}{bf:'}{it:X} = {it:Q}{bf:'}{it:B}{right:(2)    }

{p 4 4 2}
Define 

		{it:Z} = {it:P}{bf:'}{it:X}{right:(3)    }

{p 4 4 2}
Then (2) can be rewritten as

		{it:RZ} = {it:Q}{bf:'}{it:B}{right:(4)    }

{p 4 4 2}
It is easy to solve (4) for {it:Z} because {it:R} is upper triangular.
Having {it:Z}, we can obtain {it:X} via (3), because 
{it:Z} = {it:P}{bf:'}{it:X}, premultiplied by {it:P} (and if we remember
that {it:P}{it:P}{bf:'}={it:I}), yields

		{it:X} = {it:P}{it:Z}

{p 4 4 2}
For more information on QR decomposition, see {bf:{help mf_qrd:[M-5] qrd()}}.


{marker remarks2}{...}
{title:Relationship to inversion}

{p 4 4 2}
For a general discussion, 
see {it:{help mf_lusolve##remarks2:Relationship to inversion}} in
{bf:{help mf_lusolve:[M-5] lusolve()}}.

{p 4 4 2}
For an inverse based on QR decomposition, see 
{bf:{help mf_qrinv:[M-5] qrinv()}}.
{cmd:qrinv(}{it:A}{cmd:)} amounts to 
{cmd:qrsolve(}{it:A}{cmd:,} {cmd:I(rows(}{it:A}{cmd:)))}, although it is 
not actually implemented that way.


{marker remarks3}{...}
{title:Tolerance}

{p 4 4 2}
The default tolerance used is 

		{it:eta} = 1e-13 * trace(abs({it:R}))/rows({it:R})

{p 4 4 2}
where {it:R} is the upper-triangular matrix of the QR decomposition;
see {it:Derivation} above.
When {it:A} is less than full rank, by, say, {it:d}
degrees of freedom, then {it:R} is also rank deficient by {it:d} degrees of
freedom and the bottom {it:d} rows of {it:R} are essentially zero.  If the
{it:i}th diagonal element of {it:R} is less than or equal to {it:eta}, then
the {it:i}th row of {it:Z} is set to zero.
Thus if the matrix is singular, {cmd:qrsolve()} provides a generalized
solution.

{p 4 4 2}
If you specify {it:tol}>0, the value you specify is used to multiply {it:eta}.
You may instead specify {it:tol}<=0, and then the negative of the value you
specify is used in place of {it:eta}; see 
{bf:{help m1_tolerance:[M-1] Tolerance}}.


{marker conformability}{...}
{title:Conformability}

    {cmd:qrsolve(}{it:A}{cmd:,} {it:B}{cmd:,} {it:rank}{cmd:,} {it:tol}{cmd:)}:
	{it:input:}
		{it:A}:  {it:m x n}, {it:m}>={it:n}
		{it:B}:  {it:m x k}
	      {it:tol}:  1 {it:x} 1    (optional)
	{it:output:}
             {it:rank}:  1 {it:x} 1    (optional)
	   {it:result}:  {it:n x k}

    {cmd:_qrsolve(}{it:A}{cmd:,} {it:B}{cmd:,} {it:tol}{cmd:)}:
	{it:input:}
		{it:A}:  {it:m x n}, {it:m}>={it:n}
		{it:B}:  {it:m x k}
	      {it:tol}:  1 {it:x} 1    (optional)
	{it:output:}
		{it:A}:  0 {it:x} 0
		{it:B}:  {it:n x k}
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:qrsolve(}{it:A}{cmd:,} {it:B}{cmd:,} ...{cmd:)} 
and
{cmd:_qrsolve(}{it:A}{cmd:,} {it:B}{cmd:,} ...{cmd:)} 
return a result containing missing 
if {it:A} or {it:B} contain missing values.

{p 4 4 2}
{cmd:_qrsolve(}{it:A}{cmd:,} {it:B}{cmd:,} ...{cmd:)} 
aborts with error if {it:A} or {it:B} are views.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view qrsolve.mata, adopath asis:qrsolve.mata},
{view _qrsolve.mata, adopath asis:_qrsolve.mata}
{p_end}
