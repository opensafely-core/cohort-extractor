{smcl}
{* *! version 1.0.8  15may2018}{...}
{vieweralsosee "[M-5] schurd()" "mansection M-5 schurd()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-1] LAPACK" "help m1_lapack"}{...}
{vieweralsosee "[M-5] hessenbergd()" "help mf_hessenbergd"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{viewerjumpto "Syntax" "mf_schurd##syntax"}{...}
{viewerjumpto "Description" "mf_schurd##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_schurd##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_schurd##remarks"}{...}
{viewerjumpto "Conformability" "mf_schurd##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_schurd##diagnostics"}{...}
{viewerjumpto "Source code" "mf_schurd##source"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[M-5] schurd()} {hline 2}}Schur decomposition
{p_end}
{p2col:}({mansection M-5 schurd():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{it:void}{bind:         }
{cmd:schurd(}{it:X}{cmd:,} 
{it:T}{cmd:,} 
{it:Q}{cmd:)}

{p 8 8 2}
{it:void}{bind:        }
{cmd:_schurd(}{it:X}{cmd:,} {bind:  }
{it:Q}{cmd:)} 

{p 8 8 2}
{it:void}{bind:  }
{cmd: schurdgroupby(}{it:X}{cmd:,} 
{it:f}{cmd:,} 
{it:T}{cmd:,} 
{it:Q}{cmd:,} 
{it:w}{cmd:,} 
{it:m}{cmd:)} 

{p 8 8 2}
{it:void}{bind: }
{cmd:_schurdgroupby(}{it:X}{cmd:,} 
{it:f}{cmd:,} {bind:  }
{it:Q}{cmd:,} 
{it:w}{cmd:,} 
{it:m}{cmd:)} 

{p 4 4 2}
where inputs are 

            {it:X}:  {it:numeric matrix}
	    {it:f}:  {it:pointer scalar} (points to a function used to group eigenvalues)

{p 4 4 2}
and outputs are

{p2colset 9 33 35 2}{...}
{p2col 13 33 35 2: {it:T}:  {it:numeric matrix}}(Schur-form matrix) {p_end}
{p2col 13 33 35 2: {it:Q}:  {it:numeric matrix}}(orthogonal or unitary){p_end}
{p2col 13 33 35 2: {it:w}:  {it:numeric vector} of eigenvalues}{p_end}
{p2col 13 33 35 2: {it:m}:  {it:real scalar}}(the number of eigenvalues satisfy the grouping condition){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}
	
{p 4 4 2}
{cmd:schurd(}{it:X}{cmd:,} {it:T}{cmd:,} {it:Q}{cmd:)} 
computes the Schur decomposition of a square, numeric matrix, {it:X},
returning the {help mf_schurd##schurd:Schur-form} matrix, {it:T},
and the matrix of Schur vectors, {it:Q}. {it:Q} is orthogonal if {it:X} 
is real and unitary if {it:X} is complex.

{p 4 4 2}
{cmd:_schurd(}{it:X}{cmd:,} {it:Q}{cmd:)} does the same
thing as {cmd:schurd()}, except that it returns {it:T} in {it:X}.

{p 4 4 2}
{cmd: schurdgroupby(}{it:X}{cmd:,} {it:f}{cmd:,} {it:T}{cmd:,} {it:Q}{cmd:,} 
{it:w}{cmd:,} {it:m}{cmd:)}
computes the Schur decomposition and the eigenvalues of a
square, numeric matrix, {it:X}, and groups the results according to whether 
a condition on each eigenvalue is satisfied.  {cmd: schurdgroupby()}
returns the Schur-form matrix in {it:T}, the matrix of Schur vectors in
{it:Q}, the eigenvalues in {it:w}, and the number of eigenvalues for which
the condition is true in {it:m}.  {it:f} is a pointer of the function that
implements the condition on each eigenvalue, as discussed 
{help mf_schurd##group:below}.

{p 4 4 2}
{cmd: _schurdgroupby(}{it:X}{cmd:,} {it:f}{cmd:,} {it:Q}{cmd:,}
{it:w}{cmd:,} {it:m}{cmd:)} does the
same thing as {cmd:schurdgroupby()} except that it returns {it:T} in {it:X}.

{p 4 4 2} 
{cmd:_schurd_la()} and {cmd:_schurdgroupby_la()} are the interfaces into the
LAPACK routines used to implement the above functions;
see {bf:{help m1_lapack:[M-1] LAPACK}}. Their direct use is not recommended.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 schurd()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_schurd##schurd:Schur decomposition}
	{help mf_schurd##group:Grouping the results}


{marker schurd}{...}
{title:Schur decomposition}

{p 4 4 2}
Many algorithms begin by obtaining the Schur decomposition of a square
matrix.

{p 4 8 2}
The Schur decomposition of matrix {cmd:X} can be written as 

		{cmd:Q}' * {cmd:X} * {cmd:Q} = {cmd:T}
	
{p 4 4 2}
where {cmd:T} is in Schur form, {cmd:Q}, the matrix of Schur vectors, is
orthogonal if {cmd:X} is real or unitary if {cmd:X} is complex.

{p 4 4 2}
A real, square matrix is in Schur form if it is block upper triangular with 1
{it:x} 1 and 2 {it:x} 2 diagonal blocks. Each 2 {it:x} 2 diagonal block has
equal diagonal elements and opposite sign off-diagonal elements.  A complex,
square matrix is in Schur form if it is upper triangular.  The eigenvalues of 
{cmd:X} are obtained from the Schur form by a few quick computations.

{p 4 4 2}
In the example below, we define {cmd:X}, obtain the Schur decomposition, and
list {cmd:T}. 

	{cmd:: X=(.31,.69,.13,.56\.31,.5,.72,.42 \.68,.37,.71,.8 \.09,.16,.83,.9)}
	
	{cmd:: schurd(X, T=., Q=.)}
	
	{cmd:: T}
	       {txt}          1              2              3              4
	    {c TLC}{hline 61}{c TRC}
	  1 {c |}    2.10742167    .1266712792    .0549744934    .3329112999  {c |}
	  2 {c |}             0   -.0766307549    .3470959084    .1042286546  {c |}
	  3 {c |}             0   -.4453774705   -.0766307549    .3000409803  {c |}
	  4 {c |}             0              0              0    .4658398402  {c |}
	    {c BLC}{hline 61}{c BRC}


{marker group}{...}
{title:Grouping the results}

{p 4 4 2}
In many applications, there is a stable solution if the modulus of an
eigenvalue is less than one and an explosive solution if the modulus is
greater than or equal to one.  One frequently handles these cases
differently and would group the Schur decomposition results into a
block corresponding to stable solutions and a block corresponding to
explosive solutions.

{p 4 4 2}
In the following example, we use {cmd:schurdgroupby()} to put the stable
solutions first.  One of the arguments to {cmd:schurdgroupby()} is a 
{help m2_ftof:pointer} to a function that accepts a complex scalar
argument, an eigenvalue, and returns 1 to select the eigenvalue and 0 
otherwise.  Here {cmd:isstable()} returns 1 if the eigenvalue is less than 1:

        {cmd:: real scalar isstable(scalar p)} 
	{cmd:> {c -(}}
	{cmd:>         return((abs(p)<1))}
	{cmd:> {c )-}}
	
{p 4 4 2}
Using this function to group the results, we see that the Schur-form
matrix has been reordered.

	{cmd:: schurdgroupby(X, &isstable(), T=., Q=., w=., m=.)}

	{cmd:: T}
	       {txt}          1              2              3              4
	    {c TLC}{hline 61}{c TRC}
	  1 {c |}  -.0766307549     .445046622    .3029641608   -.0341867415  {c |}
	  2 {c |}  -.3473539401   -.0766307549   -.1036266286    .0799058566  {c |}
	  3 {c |}             0              0    .4658398402   -.3475944606  {c |}
	  4 {c |}             0              0              0     2.10742167  {c |}
    	    {c BLC}{hline 61}{c BRC}
    
{p 4 4 2}
Listing the moduli of the eigenvalues reveals that they are 
grouped into stable and explosive groups.

	{cmd:: abs(w)}
	       {txt}         1             2             3             4
	    {c TLC}{hline 57}{c TRC}
	  1 {c |}  .4005757984   .4005757984   .4658398402    2.10742167  {c |}
    	    {c BLC}{hline 57}{c BRC}

{p 4 4 2}
{cmd:m} contains the number of stable solutions

	{cmd:: m}
 	  3


{marker conformability}{...}
{title:Conformability}

{p 4 8 2}
{cmd:schurd(}{it:X}{cmd:,} {it:T}{cmd:,} {it:Q} {cmd:)}:
{p_end}
	{it:input:}
		{it:X}:  {it:n x n}
	{it:output:}
		{it:T}:  {it:n x n}
		{it:Q}:  {it:n x n}
	
{p 4 8 2}
{cmd:_schurd(}{it:X}{cmd:,} {it:Q}{cmd:)}:
{p_end}
	{it:input:}
		{it:X}:  {it:n x n}
	{it:output:}
		{it:X}:  {it:n x n}
		{it:Q}:  {it:n x n}
			
{p 4 8 2}
{cmd: schurdgroupby(}{it:X}{cmd:,} 
{it:f}{cmd:,} 
{it:T}{cmd:,} 
{it:Q}{cmd:,} 
{it:w}{cmd:,} 
{it:m}{cmd:)}:
{p_end}
	{it:input:}
		{it:X}:  {it:n x n}
		{it:f}:  1 {it:x} 1
	{it:output:}
		{it:T}:  {it:n x n}
		{it:Q}:  {it:n x n}
		{it:w}:  1 {it:x n}
		{it:m}:  1 {it:x} 1

{p 4 8 2}
{cmd: _schurdgroupby(}{it:X}{cmd:,} 
{it:f}{cmd:,} 
{it:Q}{cmd:,} 
{it:w}{cmd:,} 
{it:m}{cmd:)}:
{p_end}
	{it:input:}
		{it:X}:  {it:n x n}
	        {it:f}:  1 {it:x} 1
	{it:output:}
		{it:X}:  {it:n x n}
		{it:Q}:  {it:n x n}
		{it:w}:  1 {it:x n}
		{it:m}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 8 2}
{cmd:_schurd()} and 
{cmd:_schurdgroupby()} abort with error if {it:X} is a view.

{p 4 8 2}
{cmd:schurd()}, {cmd:_schurd()}, {cmd:schurdgroupby()}, and 
{cmd: _schurdgroupby()} return missing results if {it:X} contains missing
values.

{p 4 8 2}
{cmd: schurdgroupby()} groups the results via a matrix transform.  If the
problem is very ill conditioned, applying this matrix transform can cause
changes in the eigenvalues.  In extreme cases, the grouped eigenvalues
may no longer satisfy the condition used to perform the grouping.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view schurd.mata, adopath asis:schurd.mata},
{view _schurd.mata, adopath asis:_schurd.mata},
{view schurdgroupby.mata, adopath asis:schurdgroupby.mata},
{view _schurdgroupby.mata, adopath asis:_schurdgroupby.mata}
{p_end}
