{smcl}
{* *! version 1.0.0  06feb2017}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{viewerjumpto "Syntax" "mf__factorsym##syntax"}{...}
{viewerjumpto "Description" "mf__factorsym##description"}{...}
{viewerjumpto "Remarks" "mf__factorsym##remarks"}{...}
{viewerjumpto "Conformability" "mf__factorsym##conformability"}{...}
{viewerjumpto "Diagnostics" "mf__factorsym##diagnostics"}{...}
{viewerjumpto "Source code" "mf__factorsym##source"}{...}
{title:Title}

{p 4 8 2}
{bf:[M-5] _factorsym()} {hline 2} Factor a symmetric nonnegative-definite matrix


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real scalar}
{cmd:_factorsym(}{it:real matrix A}[{cmd:,} {it:real scalar tol}]{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:_factorsym(}{it:A}{cmd:)} factors a symmetric nonnegative-definite matrix
{it:A} to a lower triangular matrix and overwrites {it:A} with the solution.
Returned is the rank of {it:A}.  For a matrix with dimension {it:n} and rank
{it:r} < {it:n}, the resulting matrix has {it:n} - {it:r} rows with zeros.
The optional argument {it:tol} is the tolerance used to determine whether the
matrix is nonnegative definite.  The default is
{it:tol}{cmd: = }{cmd:sum(abs(diagonal(}{it:A}{cmd:)))*epsilon(16)}.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
The decomposition {it:G} of a symmetric nonnegative-definite matrix
{it:A} is 

		{it:A} = {it:G}{it:G}{bf:'}

{p 4 4 2}
where {it:G} is lower triangular.

{p 4 4 2}
A generalized inverse (G-inverse) can be computed from the factored matrix
{it:G} by typing

{p 8 8 2}
{cmd:: G = A}

{p 8 8 2}
{cmd:: rank = _factorsym(G)}

{p 8 8 2}
{cmd:: Ai = I(n)}

{p 8 8 2}
{cmd:: rank = _solvelower(G,Ai)}

{p 8 8 2}
{cmd:: Ai = Ai'Ai}

{p 8 8 2}
{cmd:: mreldif(A,A*Ai*A)}

{p 4 4 2}
You can compare this G-inverse {cmd:Ai} with that computed from
{helpb mf_invsym:invsym()}.


{marker conformability}{...}
{title:Conformability}

    {cmd:_factorsym(}{it:A}{cmd:)}
	 {it:input:}
		{it:A}:  {it:n x n} 
	      {it:tol}:  {it:1 x 1}  (optional)
	{it:output:}
		{it:A}:  {it:n x n} 
	   {it:result}:  {it:1 x 1} 


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:_factorsym({it:A})} uses the elements from the lower triangle of
{it:A} without checking whether {it:A} is symmetric.  


{marker source}{...}
{title:Source code}

{p 4 4 2}
{cmd:_factorsym()} is built-in.
{p_end}
