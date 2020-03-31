{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[M-5] cholsolve()" "mansection M-5 cholsolve()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] cholesky()" "help mf_cholesky"}{...}
{vieweralsosee "[M-5] cholinv()" "help mf_cholinv"}{...}
{vieweralsosee "[M-5] lusolve()" "help mf_lusolve"}{...}
{vieweralsosee "[M-5] qrsolve()" "help mf_qrsolve"}{...}
{vieweralsosee "[M-5] solvelower()" "help mf_solvelower"}{...}
{vieweralsosee "[M-5] svsolve()" "help mf_svsolve"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] solve_tol()" "help mf_solve_tol"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{vieweralsosee "[M-4] Solvers" "help m4_solvers"}{...}
{viewerjumpto "Syntax" "mf_cholsolve##syntax"}{...}
{viewerjumpto "Description" "mf_cholsolve##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_cholsolve##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_cholsolve##remarks"}{...}
{viewerjumpto "Conformability" "mf_cholsolve##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_cholsolve##diagnostics"}{...}
{viewerjumpto "Source code" "mf_cholsolve##source"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-5] cholsolve()} {hline 2}}Solve AX=B for X using Cholesky decomposition
{p_end}
{p2col:}({mansection M-5 cholsolve():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:numeric matrix}
{cmd:cholsolve(}{it:numeric matrix A}{cmd:,}
{it:numeric matrix B}{cmd:)}

{p 8 63 2}
{it:numeric matrix}
{cmd:cholsolve(}{it:numeric matrix A}{cmd:,}
{it:numeric matrix B}{cmd:,}{break}
{it:real scalar tol}{cmd:)}


{p 8 12 2}
{it:void}{bind:         }
{cmd:_cholsolve(}{it:numeric matrix A}{cmd:,}
{it:numeric matrix B}{cmd:)}

{p 8 63 2}
{it:void}{bind:         }
{cmd:_cholsolve(}{it:numeric matrix A}{cmd:,}
{it:numeric matrix B}{cmd:,}{break}
{it:real scalar tol}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:cholsolve(}{it:A}{cmd:,} {it:B}{cmd:)} 
solves {it:A}{it:X}={it:B} and returns {it:X} for symmetric
({help m6_glossary##hermitianmtx:Hermitian}),
positive-definite {it:A}.  {cmd:cholsolve()} returns a matrix of missing
values if {it:A} is not positive definite or if {it:A} is singular.

{p 4 4 2}
{cmd:cholsolve(}{it:A}{cmd:,} {it:B}{cmd:,} {it:tol}{cmd:)}
does the same thing; it allows you to specify the tolerance for declaring 
that {it:A} is singular; see {it:{help mf_cholsolve##remarks3:Tolerance}} under
{it:Remarks} below.

{p 4 4 2}
{cmd:_cholsolve(}{it:A}{cmd:,} {it:B}{cmd:)} 
and 
{cmd:_cholsolve(}{it:A}{cmd:,} {it:B}{cmd:,} {it:tol}{cmd:)}
do the same thing except that, rather than returning the solution {it:X}, 
they overwrite {it:B} with the solution, and in the process of making the 
calculation, they destroy the contents of {it:A}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 cholsolve()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
The above functions solve {it:AX}={it:B} via Cholesky decomposition and are
accurate.  When {it:A} is not symmetric and positive definite, 
{bf:{help mf_lusolve:[M-5] lusolve()}},
{bf:{help mf_qrsolve:[M-5] qrsolve()}}, and 
{bf:{help mf_svsolve:[M-5] svsolve()}}
are alternatives based on the LU decomposition, the QR decomposition, and
the singular value decomposition (SVD).
The alternatives differ in how they handle singular {it:A}. Then 
the LU-based routines return missing values, whereas the QR-based and
SVD-based routines return generalized (least-squares) solutions.

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_cholsolve##remarks1:Derivation}
	{help mf_cholsolve##remarks2:Relationship to inversion}
	{help mf_cholsolve##remarks3:Tolerance}


{marker remarks1}{...}
{title:Derivation}

{p 4 4 2}
We wish to solve for {it:X}

		{it:A}{it:X} = {it:B}{right:(1)    }

{p 4 4 2}
when {it:A} is symmetric and positive definite.		
Perform the Cholesky decomposition of {it:A} so that we have {it:A} =
{it:G}{it:G}{bf:'}.  Then (1) can be written as

		{it:G}{it:G}{bf:'}{it:X} = {it:B}{right:(2)    }

{p 4 4 2}
Define 

		{it:Z} = {it:G}{bf:'}{it:X}{right:(3)    }

{p 4 4 2}
Then (2) can be rewritten as

		{it:G}{it:Z} = {it:B}{right:(4)    }

{p 4 4 2}
It is easy to solve (4) for {it:Z} because {it:G} is a lower-triangular 
matrix.  Once {it:Z} is known, it is easy to solve (3) for {it:X} because 
{it:G}{bf:'} is upper triangular.


{marker remarks2}{...}
{title:Relationship to inversion}

{p 4 4 2}
See {it:{help mf_lusolve##remarks2:Relationship to inversion}} in
{bf:{help mf_lusolve:[M-5] lusolve()}}
for a discussion of the relationship between solving the linear system and
matrix inversion.


{marker remarks3}{...}
{title:Tolerance}

{p 4 4 2}
The default tolerance used is 

		{it:eta} = (1e-13)*trace(abs({it:G}))/{it:n}

{p 4 4 2}
where {it:G} is the lower-triangular Cholesky factor of {it:A}: {it:n}
{it:x} {it:n}.  {it:A} is declared to be singular if 
{cmd:cholesky()} (see {bf:{help mf_cholesky:[M-5] cholesky()}}) finds that
{it:A} is not positive definite, or if {it:A} is found to be positive
definite, if any diagonal element of {it:G} is less than or equal to {it:eta}.
Mathematically, positive definiteness implies that the matrix is not singular.
In the numerical method used, two checks are made:  {cmd:cholesky()} makes one
and then the {it:eta} rule is applied to ensure numerical stability in the use
of the result {cmd:cholesky()} returns.

{p 4 4 2}
If you specify {it:tol}>0, the value you specify is used to multiply 
{it:eta}.  You may instead specify {it:tol}<=0 and then the negative of the
value you specify is used in place of {it:eta}; see 
{bf:{help m1_tolerance:[M-1] Tolerance}}.

{p 4 4 2}
See {bf:{help mf_lusolve:[M-5] lusolve()}} for a detailed discussion of the
issues surrounding solving nearly singular systems.  The main point to keep
in mind is that if {it:A} is ill conditioned, then small changes in {it:A}
or {it:B} can lead to radically large differences in the solution for
{it:X}.


{marker conformability}{...}
{title:Conformability}

    {cmd:cholsolve(}{it:A}{cmd:,} {it:B}{cmd:,} {it:tol}{cmd:)}:
	{it:input:}
		{it:A}:  {it:n x n}
		{it:B}:  {it:n x k}
	      {it:tol}:  1 {it:x} 1    (optional)
	   {it:result}:  {it:n x k}

    {cmd:_cholsolve(}{it:A}{cmd:,} {it:B}{cmd:,} {it:tol}{cmd:)}:
	{it:input:}
		{it:A}:  {it:n x n}
		{it:B}:  {it:n x k}
	      {it:tol}:  1 {it:x} 1    (optional)
	{it:output:}
		{it:A}:  0 {it:x} 0
		{it:B}:  {it:n x k}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:cholsolve(}{it:A}{cmd:,} {it:B}{cmd:,} ...{cmd:)},
and
{cmd:_cholsolve(}{it:A}{cmd:,} {it:B}{cmd:,} ...{cmd:)}
return a result of all missing values if {it:A} is not positive definite 
or if {it:A} contains missing values.

{p 4 4 2}
{cmd:_cholsolve(}{it:A}{cmd:,} {it:B}{cmd:,} ...{cmd:)} also aborts with
error if {it:A} or {it:B} is a view.

{p 4 4 2}
All functions use the elements from the lower triangle of {it:A} without
checking whether {it:A} is symmetric or, in the complex case, Hermitian.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view cholsolve.mata, adopath asis:cholsolve.mata},
{view _cholsolve.mata, adopath asis:_cholsolve.mata}
{p_end}
