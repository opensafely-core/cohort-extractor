{smcl}
{* *! version 1.1.8  15may2018}{...}
{vieweralsosee "[M-5] eigensystem()" "mansection M-5 eigensystem()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] matexpsym()" "help mf_matexpsym"}{...}
{vieweralsosee "[M-5] matpowersym()" "help mf_matpowersym"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{viewerjumpto "Syntax" "mf_eigensystem##syntax"}{...}
{viewerjumpto "Description" "mf_eigensystem##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_eigensystem##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_eigensystem##remarks"}{...}
{viewerjumpto "Conformability" "mf_eigensystem##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_eigensystem##diagnostics"}{...}
{viewerjumpto "Source code" "mf_eigensystem##source"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[M-5] eigensystem()} {hline 2}}Eigenvectors and eigenvalues 
{p_end}
{p2col:}({mansection M-5 eigensystem():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 40 2}
{it:void}{bind:                  }
{cmd:eigensystem(}{it:A}{cmd:,} 
{it:X}{cmd:,} 
{it:L} 
[{cmd:,} {it:rcond} 
[{cmd:,} {it:nobalance}]]{cmd:)}

{p 8 40 2}
{it:void}{bind:              }
{cmd:lefteigensystem(}{it:A}{cmd:,} {it:X}{cmd:,} 
{it:L}
[{cmd:,} {it:rcond}
[{cmd:,} {it:nobalance}]]{cmd:)}

{p 8 40 2}
{it:complex rowvector}{bind:     }
{cmd:eigenvalues(}{it:A}{bind:      }
[{cmd:,} {it:rcond}
[{cmd:,} {it:nobalance}]]{cmd:)}


{p 8 40 2}
{it:void}{bind:               }
{cmd:symeigensystem(}{it:A}{cmd:,} {it:X}{cmd:,} {it:L}{cmd:)}

{p 8 40 2}
{it:real rowvector}{bind:     }
{cmd:symeigenvalues(}{it:A}{cmd:)}


{p 8 40 2}
{it:void}{bind:                 }
{cmd:_eigensystem(}{it:A}{cmd:,} 
{it:X}{cmd:,} 
{it:L} 
[{cmd:,} {it:rcond} 
[{cmd:,} {it:nobalance}]]{cmd:)}

{p 8 40 2}
{it:void}{bind:             }
{cmd:_lefteigensystem(}{it:A}{cmd:,} {it:X}{cmd:,} 
{it:L}
[{cmd:,} {it:rcond}
[{cmd:,} {it:nobalance}]]{cmd:)}

{p 8 40 2}
{it:complex rowvector}{bind:    }
{cmd:_eigenvalues(}{it:A}{bind:      }
[{cmd:,} {it:rcond} 
[{cmd:,}
{it:nobalance}]]{cmd:)}

{p 8 40 2}
{it:void}{bind:              }
{cmd:_symeigensystem(}{it:A}{cmd:,} {it:X}{cmd:,} {it:L}{cmd:)}

{p 8 40 2}
{it:real rowvector}{bind:    }
{cmd:_symeigenvalues(}{it:A}{cmd:)}



{p 4 4 2}
where inputs are 

			{it:A}:  {it:numeric matrix}
		    {it:rcond}:  {it:real scalar} (whether {it:rcond} desired)
		{it:nobalance}:  {it:real scalar} (whether to suppress balancing)

{p 4 4 2}
and outputs are

			{it:X}:  {it:numeric matrix} of eigenvectors 
			{it:L}:  {it:numeric vector} of eigenvalues
		    {it:rcond}:  {it:real vector} of reciprocal condition numbers

{p 4 4 2}
The columns of {it:X} will contain the eigenvectors except when using 
{cmd:_lefteigensystem()}, in which case the rows of {it:X} contain the 
eigenvectors.


{p 4 4 2}
The following routines are used in implementing the above routines:

{p 8 30 2}
{it:real scalar}
{cmd:_eigen_la(}{it:real scalar todo}{cmd:,}
{it:numeric matrix A}{cmd:,}
{it:X}{cmd:,}
{it:L}{cmd:,}
{it:real scalar rcond}{cmd:,}
{it:real scalar nobalance}{cmd:)}

{p 8 33 2}
{it:real scalar}
{cmd:_symeigen_la(}{it:real scalar todo}{cmd:,}
{it:numeric matrix A}{cmd:,}
{it:X}{cmd:,}
{it:L}{cmd:)}

		
{marker description}{...}
{title:Description}

{p 4 4 2}
These routines calculate eigenvectors and eigenvalues of square matrix {it:A}.

{p 4 4 2}
{cmd:eigensystem(}{it:A}{cmd:,} {it:X}{cmd:,} {it:L}{cmd:,}
{it:rcond}{cmd:,} {it:nobalance}{cmd:)} 
calculates eigenvectors and eigenvalues of a general, real or complex,
square matrix
{it:A}.  Eigenvectors are returned in {it:X} and eigenvalues in {it:L}.
The remaining arguments are optional:

{p 8 12 2}
    1.  If {it:rcond} is not specified, then reciprocal condition numbers are
        not returned in {it:rcond}.

{p 12 12 2}
        If {it:rcond} is specified and contains a value other than 0 or
        missing -- {it:rcond}=1 is suggested -- in {it:rcond} will be placed a
        vector of the reciprocals of the condition numbers for the
        eigenvalues.  Each element of the new {it:rcond} measures the accuracy
        to which the corresponding eigenvalue has been calculated; large
        numbers (numbers close to 1) are better and small numbers (numbers
        close to 0) indicate inaccuracy; 
        see {it:{help mf_eigensystem##remarks5:Eigenvalue condition}} below.

{p 8 12 2} 
    2.  If {it:nobalance} is not specified, balancing is
        performed to obtain more accurate results.

{p 12 12 2}
        If {it:nobalance} is specified and is not zero nor missing, 
        balancing is not used.  Results are calculated more quickly, but
        perhaps a little less accurately; see
        {it:{help mf_eigensystem##remarks6:Balancing}} below.

{p 4 4 2}
{cmd:lefteigensystem(}{it:A}{cmd:,} {it:X}{cmd:,} {it:L}{cmd:,}
{it:rcond}{cmd:,} {it:nobalance}{cmd:)} mirrors 
{cmd:eigensystem()}, the difference being that {cmd:lefteigensystem()}
solves for left eigenvectors solving 
{it:X}{it:A}=diag({it:L})*{it:X}
instead of right eigenvectors solving
{it:A}{it:X}={it:X}*diag({it:L}).

{p 4 4 2}
{cmd:eigenvalues(}{it:A}{cmd:,} {it:rcond}{cmd:,} {it:nobalance}{cmd:)}
returns the eigenvalues of square matrix {it:A}; the eigenvectors are not 
calculated.  Arguments {it:rcond} and {it:nobalance} are optional.

{p 4 4 2}
{cmd:symeigensystem(}{it:A}{cmd:,} {it:X}{cmd:,} {it:L}{cmd:)}
and 
{cmd:symeigenvalues(}{it:A}{cmd:)} mirror {cmd:eigensystem()} and
{cmd:eigenvalues()}, the difference being that {it:A} is assumed to be
symmetric (Hermitian).  The eigenvalues returned are real.  (Arguments
{it:rcond} and {it:nobalance} are not allowed; {it:rcond} because 
symmetric matrices are inherently well conditioned; {it:nobalance}
because it is unnecessary.)

{p 4 4 2}
The underscore routines mirror the routines of the same name without 
underscores, the difference being that {it:A} is damaged during the 
calculation and so the underscore routines use less memory.

{p 4 4 2}
{cmd:_eigen_la()} and {cmd:_symeigen_la()} are the interfaces into the
{bf:{help m1_lapack:[M-1] LAPACK}}
routines used to implement the above functions.  Their direct use is not 
recommended.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 eigensystem()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_eigensystem##remarks1:Eigenvalues and eigenvectors}
	{help mf_eigensystem##remarks2:Left eigenvectors}
	{help mf_eigensystem##remarks3:Symmetric eigensystems}
	{help mf_eigensystem##remarks4:Normalization and order}
	{help mf_eigensystem##remarks5:Eigenvalue condition}
	{help mf_eigensystem##remarks6:Balancing}
	{help mf_eigensystem##remarks7:eigensystem() and eigenvalues()}
	{help mf_eigensystem##remarks8:lefteigensystem()}
	{help mf_eigensystem##remarks9:symeigensystem() and symeigenvalues()}


{marker remarks1}{...}
{title:Eigenvalues and eigenvectors}

{p 4 4 2}
A scalar {it:l} (usually denoted by {it:lambda}) is said to be an
eigenvalue of square matrix {it:A}: {it:n x n} if there is a nonzero column
vector {it:x}: {it:n x} 1 (called the eigenvector) such that

			{it:A}{it:x} = {it:l}{it:x}{right:(1)   }

{p 4 4 2}
(1) can also be written as

			({it:A} - {it:l}{it:I}){it:x} = 0

{p 4 4 2}
where {it:I} is the {it:n x n} identity matrix.
A nontrivial solution to this system of n linear homogeneous equations 
exists if and only if 

			det({it:A} - {it:l}{it:I}) = 0{right:(2)   }

{p 4 4 2}
This {it:n}th degree polynomial in {it:l} is called the characteristic 
polynomial or characteristic equation of {it:A}, and the eigenvalues {it:l}
are its roots, also known as the characteristic roots.

{p 4 4 2}
There are, in fact, {it:n} solutions ({it:l_i}, {it:x_i}) that satisfy (1) --
although some can be repeated -- and we can compactly write the full set of
solutions as

			{it:A}{it:X} = {it:X}*diag({it:L}){right:(3)   }

{p 4 4 2}
where 

			{it:X} = ({it:x}_1, {it:x}_2, ...){...}
{col 60}({it:X}: {it:n x n})

			{it:L} = ({it:l}_1, {it:l}_2, ...){...}
{col 60}({it:L}: 1 {it:x n})

{p 4 4 2}
For instance, 


	{cmd:: A = (1, 2 \ 9, 4)}
	{cmd:: X = .}
	{cmd:: L = .}
	{cmd:: eigensystem(A, X, L)}

	{cmd:: X}
	                 1             2
	    {c TLC}{hline 29}{c TRC}
	  1 {c |}  -.316227766   -.554700196  {c |}
	  2 {c |}  -.948683298    .832050294  {c |}
	    {c BLC}{hline 29}{c BRC}

	{cmd:: L}
	        1    2
	    {c TLC}{hline 11}{c TRC}
	  1 {c |}   7   -2  {c |}
	    {c BLC}{hline 11}{c BRC}

{p 4 4 2}
The first eigenvalue is 7, and the corresponding eigenvector is 
(-.316 \ -.949).
The second eigenvalue is -2, and the corresponding eigenvector is 
(-.555 \ .832).

{p 4 4 2}
In general, eigenvalues and vectors can be complex even if {it:A} is real.


{marker remarks2}{...}
{title:Left eigenvectors}

{p 4 4 2}
What we have defined above is properly known as the right-eigensystem 
problem:

			{it:A}{it:x} = {it:l}{it:x}{right:(1)   }

{p 4 4 2}
In the above, {it:x} is a column vector.  The left-eigensystem problem 
is to find the row vector {it:x} satisfying

			{it:x}{it:A} = {it:l}{it:x}{right:(1')  }

{p 4 4 2}
The eigenvalue {it:l} is the same in (1) and (1'), but {it:x} can differ.

{p 4 4 2}
The {it:n} solutions ({it:l_i}, {it:x_i}) that satisfy (1') 
can be compactly written as

			{it:X}{it:A} = diag({it:L})*{it:X}{right:(3')  }

{p 4 4 2}
where 

                     {c TLC}     {c TRC}                 {c TLC}     {c TRC}
		     {c |} {it:x}_1 {c |}                 {c |} {it:l}_1 {c |}
		     {c |} {it:x}_2 {c |}                 {c |} {it:l}_2 {c |}
	       X  =  {c |}  .  {c |}           L  =  {c |}  .  {c |}
		     {c |}  .  {c |}                 {c |}  .  {c |}
		     {c |} {it:x}_{it:n} {c |}                 {c |} {it:l}_{it:n} {c |}
                     {c BLC}     {c BRC}                 {c BLC}     {c BRC}
                     ({it:n x n})                 ({it:n x} 1)

{p 4 4 2}
For instance, 

	{cmd:: A = (1, 2 \ 9, 4)}
	{cmd:: X = .}
	{cmd:: L = .}
	{cmd:: lefteigensystem(A, X, L)}

	{cmd:: X}
	                 1             2
	    {c TLC}{hline 29}{c TRC}
	  1 {c |}  -.832050294   -.554700196  {c |}
	  2 {c |}  -.948683298    .316227766  {c |}
	    {c BLC}{hline 29}{c BRC}

	{cmd:: L}
	        1
	    {c TLC}{hline 6}{c TRC}
	  1 {c |}   7  {c |}
	  2 {c |}  -2  {c |}
	    {c BLC}{hline 6}{c BRC}

{p 4 4 2}
The first eigenvalue is 7, and the corresponding eigenvector is 
(-.832, -.555).
The second eigenvalue is -2, and the corresponding eigenvector is 
(-.949, .316).

{p 4 4 2}
The eigenvalues are the same as in the previous example; the eigenvectors 
are different.


{marker remarks3}{...}
{title:Symmetric eigensystems}

{p 4 4 2}
Below we use the term symmetric to encompass
{help m6_glossary##hermitianmtx:Hermitian matrices}, even 
when we do not emphasize the fact.

{p 4 4 2}
Eigensystems of symmetric matrices are conceptually no different from general
eigensystems, but symmetry introduces certain simplifications:

{p 8 12 2}
    1.  The eigenvalues associated with symmetric matrices are real,
        whereas those associated with general matrices may be real
        or complex.

{p 8 12 2}
    2.  The eigenvectors associated with symmetric matrices -- which 
        may be real or complex -- are orthogonal.

{p 8 12 2}
    3.  The left and right eigenvectors of symmetric matrices 
        are transposes of each other.  

{p 8 12 2}
    4.  The eigenvectors and eigenvalues of symmetric matrices are 
        more easily, and more accurately, computed.

{p 4 4 2}
For item 3, let us begin with the right-eigensystem problem:

			{it:A}{it:X} = {it:X}*diag({it:L})

{p 4 4 2}
Taking the transpose of both sides results in

			{it:X}{bf:'}{it:A} = diag({it:L})*{it:X}{bf:'}

{p 4 4 2}
because {it:A}={it:A}{bf:'} if {it:A} is symmetric (Hermitian).  

{p 4 4 2}
{cmd:symeigensystem(}{it:A}{cmd:,} {it:X}{cmd:,} {it:L}{cmd:)}
calculates right eigenvectors.  To obtain the left eigenvectors, 
you simply transpose {it:X}.


{marker remarks4}{...}
{title:Normalization and order}

{p 4 4 2}
If {it:x} is a solution to

			{it:A}{it:x} = {it:l}{it:x}

{p 4 4 2} 
then so is {it:c}{it:x}, {it:c}: 1 {it:x} 1, {it:c}!=0.  

{p 4 4 2}
The eigenvectors returned by the above routines are scaled to have length
(norm) 1.

{p 4 4 2}
The eigenvalues are combined and returned in a vector ({it:L}) and the
eigenvectors in a matrix ({it:X}).  The eigenvalues are ordered from largest
to smallest in absolute value (or, if the eigenvalues are complex, by
modulus).  The eigenvectors are ordered to correspond to the eigenvalues.


{marker remarks5}{...}
{title:Eigenvalue condition}

{p 4 4 2}
Optional argument {it:rcond} may be specified as a value other than 0 or 
missing -- {it:rcond}=1 is suggested -- and then {it:rcond} will be filled
in with a vector containing the reciprocals of the condition numbers
for the eigenvalues.  Each element of {it:rcond} measures the accuracy 
with which the corresponding eigenvalue has been calculated; large numbers 
(numbers close to 1) are better and small numbers (numbers close to 0)
indicate inaccuracy.

{p 4 4 2}
The reciprocal condition number is calculated as abs({it:y}*{it:x}), where
{it:y}: 1 {it:x} {it:n} is the left eigenvector and {it:x}: {it:n} {it:x} 1 is
the corresponding right eigenvector.  Since {it:y} and {it:x} each have norm
1, abs({it:y}*{it:x})=abs(cos({it:theta})), where {it:theta} is the
angle made by the vectors.  Thus 0<=abs({it:y}*{it:x})<=1.  For symmetric
matrices, {it:y}*{it:x} will equal 1.  It can be proved that
abs({it:y}*{it:x}) is the reciprocal of the condition number for a simple
eigenvalue, and so it turns out that the sensitivity of the eigenvalue to a
perturbation is a function of how far the matrix is from symmetric on this
scale.

{p 4 4 2}
Requesting that {it:rcond} be calculated increases the amount of computation 
considerably.


{marker remarks6}{...}
{title:Balancing}

{p 4 4 2}
By default, balancing is performed for general matrices.  Optional argument 
{it:nobalance} allows you to suppress balancing.

{p 4 4 2}
Balancing is related to row-and-column equilibration; see 
{bf:{help mf__equilrc:[M-5] _equilrc()}}.  Here, however, a diagonal
matrix {it:D} is found such that {it:DAD}^(-1) is better balanced, the
eigenvectors and eigenvalues for {it:DAD}^(-1) are extracted, and then the
eigenvectors and eigenvalues are adjusted by {it:D} so that they reflect those
for the original {it:A} matrix.

{p 4 4 2}
There is no gain from these machinations when {it:A} is symmetric, so 
the symmetric routines do not have a {it:nobalance} argument.


{marker remarks7}{...}
{title:eigensystem() and eigenvalues()}

{p 4 8 2}
1.  Use {it:L} = {cmd:eigenvalues(}{it:A}{cmd:)} and 
    {cmd:eigensystem(}{it:A}{cmd:,} {it:X}{cmd:,} {it:L}{cmd:)}
    for general matrices {it:A}.

{p 4 8 2}
2.  Use {it:L} = {cmd:eigenvalues(}{it:A}{cmd:)} 
    when you do not need the eigenvectors; it will save both time and 
    memory.

{p 4 8 2}
3.  The eigenvalues returned by 
    {it:L} = {cmd:eigenvalues(}{it:A}{cmd:)} and by 
    {cmd:eigensystem(}{it:A}{cmd:,} {it:X}{cmd:,} {it:L}{cmd:)}
    are of storage type complex even if the eigenvalues are real 
    (that is, even if {cmd:Im(}{it:L}{cmd:)==0}).  If the eigenvalues are 
    known to be real, you can save computer memory by subsequently coding

		{cmd:L = Re(L)}

{p 8 8 2}
    If you wish to test whether the eigenvalues are real, examine 
    {cmd:mreldifre(}{it:L}{cmd:)}; 
    see {bf:{help mf_reldif:[M-5] reldif()}}.

{p 4 8 2}
4.  The eigenvectors returned by 
    {cmd:eigensystem(}{it:A}{cmd:,} {it:X}{cmd:,} {it:L}{cmd:)}
    are of storage type complex even if the eigenvectors are real
    (that is, even if {cmd:Im(}{it:X}{cmd:)==0}).  If the eigenvectors are 
    known to be real, you can save computer memory by subsequently coding

		{cmd:X = Re(X)}

{p 8 8 2}
    If you wish to test whether the eigenvectors are real, examine 
    {cmd:mreldifre(}{it:X}{cmd:)};
    see {bf:{help mf_reldif:[M-5] reldif()}}.

{p 4 8 2}
5.  If you are using 
    {cmd:eigensystem(}{it:A}{cmd:,} {it:X}{cmd:,} {it:L}{cmd:)}
    interactively (outside a program), {it:X} and {it:L}
    must be predefined.  Type

		{cmd:: eigensystem(A, X=., L=.)}


{marker remarks8}{...}
{title:lefteigensystem()}

{p 4 4 2}
What was just said about {cmd:eigensystem()} applies equally well to 
{cmd:lefteigensystem()}.  

{p 4 4 2}
If you need only the eigenvalues, use 
{it:L} = {cmd:eigenvalues(}{it:A}{cmd:)}.  The eigenvalues are the same 
for both left and right systems.


{marker remarks9}{...}
{title:symeigensystem() and symeigenvalues()}

{p 4 8 2}
1.  Use {it:L} = {cmd:symeigenvalues(}{it:A}{cmd:)} and 
    {cmd:symeigensystem(}{it:A}{cmd:,} {it:X}{cmd:,} {it:L}{cmd:)}
    for symmetric or Hermitian matrices {it:A}.

{p 4 8 2}
2.  Use {it:L} = {cmd:symeigenvalues(}{it:A}{cmd:)} 
    when you do not need the eigenvectors; it will save both time and 
    memory.

{p 4 8 2}
3.  The eigenvalues returned by 
    {it:L} = {cmd:symeigenvalues(}{it:A}{cmd:)} and by 
    {cmd:symeigensystem(}{it:A}{cmd:,} {it:X}{cmd:,} {it:L}{cmd:)}
    are of storage type real.  Eigenvalues of symmetric and Hermitian 
    matrices are always real.

{p 4 8 2}
4.  The eigenvectors returned by 
    {cmd:symeigensystem(}{it:A}{cmd:,} {it:X}{cmd:,} {it:L}{cmd:)}
    are of storage type real when {it:A} is of storage type real and of
    storage type complex when {it:A} is of storage type complex.

{p 4 8 2}
5.  If you are using 
    {cmd:symeigensystem(}{it:A}{cmd:,} {it:X}{cmd:,} {it:L}{cmd:)}
    interactively (outside a program), {it:X} and {it:L}
    must be predefined.  Type

		{cmd:: symeigensystem(A, X=., L=.)}


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:eigensystem(}{it:A}{cmd:,} 
{it:X}{cmd:,} 
{it:L}{cmd:,} 
{it:rcond}{cmd:,} 
{it:nobalance}{cmd:)}:
{p_end}
	{it:input:}
		{it:A}:  {it:n x n}
	    {it:rcond}:  1 {it:x} 1  (optional, specify as 1 to obtain {it:rcond})
	{it:nobalance}:  1 {it:x} 1  (optional, specify as 1 to prevent balancing)
	{it:output:}
		{it:X}:  {it:n x n}  (columns contain eigenvectors)
		{it:L}:  1 {it:x n}
	    {it:rcond}:  1 {it:x n}  (optional)
	   {it:result}:  {it:void}

{p 4 4 2}
{cmd:lefteigensystem(}{it:A}{cmd:,} {it:X}{cmd:,} {it:L}{cmd:,} 
{it:rcond}{cmd:,} 
{it:nobalance}{cmd:)}:
{p_end}
	{it:input:}
		{it:A}:  {it:n x n}
	    {it:rcond}:  1 {it:x} 1  (optional, specify as 1 to obtain {it:rcond})
	{it:nobalance}:  1 {it:x} 1  (optional, specify as 1 to prevent balancing)
	{it:output:}
		{it:X}:  {it:n x n}  (rows contain eigenvectors)
		{it:L}:  {it:n x} 1
	    {it:rcond}:  {it:n x} 1  (optional)
	   {it:result}:  {it:void}

{p 4 4 2}
{cmd:eigenvalues(}{it:A}{cmd:,} 
{it:rcond}{cmd:,} 
{it:nobalance}{cmd:)}:
{p_end}
	{it:input:}
		{it:A}:  {it:n x n}
	    {it:rcond}:  1 {it:x} 1  (optional, specify as 1 to obtain {it:rcond})
	{it:nobalance}:  1 {it:x} 1  (optional, specify as 1 to prevent balancing)
	{it:output:}
	    {it:rcond}:  1 {it:x n}  (optional)
	   {it:result}:  1 {it:x n}  (contains eigenvalues)


    {cmd:symeigensystem(}{it:A}{cmd:,} {it:X}{cmd:,} {it:L}{cmd:)}:
	{it:input:}
		{it:A}:  {it:n x n}
	{it:output:}
		{it:X}:  {it:n x n}  (columns contain eigenvectors)
		{it:L}:  1 {it:x n}
	   {it:result}:  {it:void}

    {cmd:symeigenvalues(}{it:A}{cmd:)}:
	{it:input:}
		{it:A}:  {it:n x n}
	{it:output:}
	   {it:result}:  1 {it:x n}  (contains eigenvalues)

{p 4 4 2}
{cmd:_eigensystem(}{it:A}{cmd:,} 
{it:X}{cmd:,} 
{it:L}{cmd:,} 
{it:rcond}{cmd:,} 
{it:nobalance}{cmd:)}:
{p_end}
	{it:input:}
		{it:A}:  {it:n x n}
	    {it:rcond}:  1 {it:x} 1  (optional, specify as 1 to obtain {it:rcond})
	{it:nobalance}:  1 {it:x} 1  (optional, specify as 1 to prevent balancing)
	{it:output:}
		{it:A}:  0 {it:x} 0
		{it:X}:  {it:n x n}  (columns contain eigenvectors)
		{it:L}:  1 {it:x n}
	    {it:rcond}:  1 {it:x n}  (optional)
	   {it:result}:  {it:void}

{p 4 4 2}
{cmd:_lefteigensystem(}{it:A}{cmd:,} {it:X}{cmd:,} 
{it:L}{cmd:,} {it:rcond}{cmd:,} {it:nobalance}{cmd:)}:
{p_end}
	{it:input:}
		{it:A}:  {it:n x n}
	    {it:rcond}:  1 {it:x} 1  (optional, specify as 1 to obtain {it:rcond})
	{it:nobalance}:  1 {it:x} 1  (optional, specify as 1 to prevent balancing)
	{it:output:}
		{it:A}:  0 {it:x} 0 
		{it:X}:  {it:n x n}  (rows contain eigenvectors)
		{it:L}:  {it:n x} 1
	    {it:rcond}:  {it:n x} 1  (optional)
	   {it:result}:  {it:void}

{p 4 4 2}
{cmd:_eigenvalues(}{it:A}{cmd:,} 
{it:rcond}{cmd:,} {it:nobalance}{cmd:)}:
{p_end}
	{it:input:}
		{it:A}:  {it:n x n}
	    {it:rcond}:  1 {it:x} 1  (optional, specify as 1 to obtain {it:rcond})
	{it:nobalance}:  1 {it:x} 1  (optional, specify as 1 to prevent balancing)
	{it:output:}
		{it:A}:  0 {it:x} 0
	    {it:rcond}:  1 {it:x n}  (optional)
	   {it:result}:  1 {it:x n}  (contains eigenvalues)

{p 4 4 2}
{cmd:_symeigensystem(}{it:A}{cmd:,} {it:X}{cmd:,} {it:L}{cmd:)}:
{p_end}
	{it:input:}
		{it:A}:  {it:n x n}
	{it:output:}
		{it:A}:  0 {it:x} 0
		{it:X}:  {it:n x n}  (columns contain eigenvectors)
		{it:L}:  1 {it:x n}
	   {it:result}:  {it:void}

    {cmd:_symeigenvalues(}{it:A}{cmd:)}:
	{it:input:}
		{it:A}:  {it:n x n}
	{it:output:}
		{it:A}:  0 {it:x} 0 
	   {it:result}:  1 {it:x n}  (contains eigenvalues)

{p 4 4 2}
{cmd:_eigen_la(}{it:todo}{cmd:,}
{it:A}{cmd:,}
{it:X}{cmd:,}
{it:L}{cmd:,}
{it:rcond}{cmd:,}
{it:nobalance}{cmd:)}:
{p_end}
	{it:input:}
	     {it:todo}:  1 {it:x} 1
		{it:A}:  {it:n x n}
	    {it:rcond}:  1 {it:x} 1
	{it:nobalance}:  1 {it:x} 1
	{it:output:}
		{it:A}:  0 {it:x} 0 
		{it:X}:  {it:n x n}
		{it:L}:  1 {it:x n}  or  {it:n x} 1
	    {it:rcond}:  1 {it:x n}  or  {it:n x} 1  (optional)
	   {it:result}:  1 {it:x} 1  (return code)

{p 4 4 2}
{cmd:_symeigen_la(}{it:todo}{cmd:,}
{it:A}{cmd:,}
{it:X}{cmd:,}
{it:L}{cmd:)}:
{p_end}
	{it:input:}
	     {it:todo}:  1 {it:x} 1
		{it:A}:  {it:n x n}
	{it:output:}
		{it:A}:  0 {it:x} 0 
		{it:X}:  {it:n x n}
		{it:L}:  1 {it:x n}
	   {it:result}:  1 {it:x} 1  (return code)


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
All functions return missing-value results if {it:A} has missing values.

{p 4 4 2}
{cmd:symeigensystem()},
{cmd:symeigenvalues()},
{cmd:_symeigensystem()}, and
{cmd:_symeigenvalues()}
use the lower triangle of {it:A} without checking for symmetry.  
When {it:A} is complex, only the real part of the diagonal is used.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view eigensystem.mata, adopath asis:eigensystem.mata},
{view lefteigensystem.mata, adopath asis:lefteigensystem.mata},
{view eigenvalues.mata, adopath asis:eigenvalues.mata},
{view symeigensystem.mata, adopath asis:symeigensystem.mata},
{view symeigenvalues.mata, adopath asis:symeigenvalues.mata},
{view _eigensystem.mata, adopath asis:_eigensystem.mata},
{view _lefteigensystem.mata, adopath asis:_lefteigensystem.mata},
{view _eigenvalues.mata, adopath asis:_eigenvalues.mata},
{view _symeigensystem.mata, adopath asis:_symeigensystem.mata},
{view _symeigenvalues.mata, adopath asis:_symeigenvalues.mata},
{view _eigen_work.mata, adopath asis:_eigen_work.mata},
{view _symeigen_work.mata, adopath asis:_symeigen_work.mata}

{p 4 4 2}
{cmd:_eigen_la()} 
and 
{cmd:_symeigen_la()} 
are built in.
{p_end}
