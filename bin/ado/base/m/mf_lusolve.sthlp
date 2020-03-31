{smcl}
{* *! version 1.1.9  15may2018}{...}
{vieweralsosee "[M-5] lusolve()" "mansection M-5 lusolve()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] cholsolve()" "help mf_cholsolve"}{...}
{vieweralsosee "[M-5] lud()" "help mf_lud"}{...}
{vieweralsosee "[M-5] luinv()" "help mf_luinv"}{...}
{vieweralsosee "[M-5] qrsolve()" "help mf_qrsolve"}{...}
{vieweralsosee "[M-5] solvelower()" "help mf_solvelower"}{...}
{vieweralsosee "[M-5] svsolve()" "help mf_svsolve"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{vieweralsosee "[M-4] Solvers" "help m4_solvers"}{...}
{viewerjumpto "Syntax" "mf_lusolve##syntax"}{...}
{viewerjumpto "Description" "mf_lusolve##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_lusolve##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_lusolve##remarks"}{...}
{viewerjumpto "Conformability" "mf_lusolve##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_lusolve##diagnostics"}{...}
{viewerjumpto "Source code" "mf_lusolve##source"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[M-5] lusolve()} {hline 2}}Solve AX=B for X using LU decomposition
{p_end}
{p2col:}({mansection M-5 lusolve():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:numeric matrix}
{cmd:lusolve(}{it:numeric matrix A}{cmd:,}
{it:numeric matrix B}{cmd:)}

{p 8 27 2}
{it:numeric matrix}
{cmd:lusolve(}{it:numeric matrix A}{cmd:,}
{it:numeric matrix B}{cmd:,} {it:real scalar tol}{cmd:)}


{p 8 12 2}
{it:void}{bind:         }
{cmd:_lusolve(}{it:numeric matrix A}{cmd:,}
{it:numeric matrix B}{cmd:)}

{p 8 27 2}
{it:void}{bind:         }
{cmd:_lusolve(}{it:numeric matrix A}{cmd:,}
{it:numeric matrix B}{cmd:,} {it:real scalar tol}{cmd:)}


{p 8 12 2}
{it:real scalar}{bind:  }
{cmd:_lusolve_la(}{it:numeric matrix A}{cmd:,}
{it:numeric matrix B}{cmd:)}

{p 8 27 2}
{it:real scalar}{bind:  }
{cmd:_lusolve_la(}{it:numeric matrix A}{cmd:,}
{it:numeric matrix B}{cmd:,} {it: real scalar tol}{cmd:)}



{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:lusolve(}{it:A}{cmd:,} {it:B}{cmd:)} 
solves {it:A}{it:X}={it:B} and
returns {it:X}.  {cmd:lusolve()} returns a matrix of missing values if {it:A}
is singular.  

{p 4 4 2}
{cmd:lusolve(}{it:A}{cmd:,} {it:B}{cmd:,} {it:tol}{cmd:)}
does the same thing but allows you to specify the tolerance for declaring 
that {it:A} is singular; see
{it:{help mf_lusolve##remarks3:Tolerance}}
under {it:Remarks} below.

{p 4 4 2}
{cmd:_lusolve(}{it:A}{cmd:,} {it:B}{cmd:)} 
and 
{cmd:_lusolve(}{it:A}{cmd:,} {it:B}{cmd:,} {it:tol}{cmd:)}
do the same thing except that, rather than returning the solution {it:X}, 
they overwrite {it:B} with the solution and, in the process of making the 
calculation, they destroy the contents of {it:A}.

{p 4 4 2}
{cmd:_lusolve_la(}{it:A}{cmd:,} {it:B}{cmd:)}
and 
{cmd:_lusolve_la(}{it:A}{cmd:,} {it:B}{cmd:,} {it:tol}{cmd:)} 
are the interfaces to the {bf:{help m1_lapack:[M-1] LAPACK}} routines that do
the work.  They solve {it:A}{it:X}=B for {it:X}, returning the solution in
{it:B} and, in the process, using as workspace (overwriting) {it:A}.
The routines return 1 if {it:A} was singular and 0 otherwise.  If {it:A} was
singular, {it:B} is overwritten with a matrix of missing values.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 lusolve()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
The above functions solve {it:AX}={it:B} via LU decomposition and are
accurate.  An alternative is {cmd:qrsolve()} (see
{bf:{help mf_qrsolve:[M-5] qrsolve()}}),
which uses QR decomposition.  The difference between
the two solutions is not, practically speaking, accuracy.  When {it:A} is of
full rank, both routines return equivalent results, and the LU approach is
quicker, using approximately {it:O}(2/3{it:n}^3) operations rather than
{it:O}(4/3{it:n}^3), where {it:A} is {it:n} {it:x} {it:n}.

{p 4 4 2}
The difference arises when {it:A} is singular.  Then the LU-based
routines documented here return missing values.  The QR-based routines
documented in {bf:{help mf_qrsolve:[M-5] qrsolve()}} return a generalized
(least squares) solution.

{p 4 4 2}
For more information on LU and QR decomposition, see 
{bf:{help mf_lud:[M-5] lud()}}
and 
see {bf:{help mf_qrd:[M-5] qrd()}}.

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_lusolve##remarks1:Derivation}
	{help mf_lusolve##remarks2:Relationship to inversion}
	{help mf_lusolve##remarks3:Tolerance}


{marker remarks1}{...}
{title:Derivation}

{p 4 4 2}
We wish to solve for {it:X}

		{it:A}{it:X} = {it:B}{right:(1)    }

{p 4 4 2}
Perform LU decomposition on {it:A} so that we have {it:A} =
{it:P}{it:L}{it:U}.  Then (1) can be written as

		{it:P}{it:L}{it:U}{it:X} = {it:B}

{p 4 4 2}
or, premultiplying by {it:P}{bf:'} and remembering that
{it:P}{bf:'}{it:P}={it:I},

		{it:L}{it:U}{it:X} = P'{it:B}{right:(2)    }

{p 4 4 2}
Define 

		{it:Z} = {it:U}{it:X}{right:(3)    }

{p 4 4 2}
Then (2) can be rewritten as

		{it:L}{it:Z} = {it:P}{bf:'}{it:B}{right:(4)    }

{p 4 4 2}
It is easy to solve (4) for {it:Z} because {it:L} is a lower-triangular
matrix.  Once {it:Z} is known, it is easy to solve (3) for {it:X} because
{it:U} is upper triangular.


{marker remarks2}{...}
{title:Relationship to inversion}

{p 4 4 2}
Another way to solve

		{it:AX} = {it:B}

{p 4 4 2}
is to obtain {it:A}^(-1) and then calculate

		{it:X} = {it:A}^(-1){it:B}

{p 4 4 2}
It is, however, better to solve {it:AX}={it:B} directly because fewer
numerical operations are required, and the result is therefore more
accurate and obtained in less computer time.

{p 4 4 2}
Indeed, rather than thinking about how solving a system of equations  can be
implemented via inversion, it is more productive to think about how inversion
can be implemented via solving a system of equations .  Obtaining {it:A}^(-1)
amounts to solving

		{it:A}{it:X} = {it:I}

{p 4 4 2}
Thus {cmd:lusolve()} (or any other solve routine) can be used to 
obtain inverses.  The inverse of {it:A} can be obtained by coding 

		: {cmd:Ainv = lusolve(}{it:A}{cmd:, I(rows(}{it:A}{cmd:)))}

{p 4 4 2}
In fact, we provide {cmd:luinv()} (see {bf:{help mf_luinv:[M-5] luinv()}}) for
obtaining inverses via LU decomposition, but {cmd:luinv()} amounts to making
the above calculation, although a little memory is saved because the matrix
{it:I} is never constructed.

{p 4 4 2}
Hence, everything said about {cmd:lusolve()} applies equally to
{cmd:luinv()}.


{marker remarks3}{...}
{title:Tolerance}

{p 4 4 2}
The default tolerance used is 

		{it:eta} = (1e-13)*trace(abs({it:U}))/{it:n}

{p 4 4 2}
where {it:U} is the upper-triangular matrix of the LU decomposition of 
{it:A}: {it:n} {it:x} {it:n}.  {it:A} is declared to be singular if any
diagonal element of {it:U} is less than or equal to {it:eta}.

{p 4 4 2}
If you specify {it:tol}>0, the value you specify is used to multiply 
{it:eta}.  You may instead specify {it:tol}<=0, and then the negative of the
value you specify is used in place of {it:eta}; see 
{bf:{help m1_tolerance:[M-1] Tolerance}}.

{p 4 4 2}
So why not specify {it:tol}=0?  
You do not want to do that because, as matrices become close to being 
singular, results can become inaccurate.  Here is an example:

	: {cmd:rseed(12345)}

	: {cmd:A = lowertriangle(runiform(4,4))}

	: {cmd:A[3,3] = 1e-15}

	: {cmd:trux = runiform(4,1)}

	: {cmd:b = A*trux}

	: {cmd:/*} {it:the above created an Ax=b problem, and we have placed the true}
	:    {it:value of x in trux.  We now obtain the solution via lusolve()}
	:    {it:and compare trux with the value obtained:}
	: {cmd:*/}

	: {cmd:x = lusolve(A, b, 0)}

	: {cmd:trux, x}
	{res}       {txt}          1             2
	    {c TLC}{hline 29}{c TRC}
	  1 {c |}  {res} .260768733    .260768733{txt}  {c |}{...}
   <- {it:The discussed numerical}
	  2 {c |}  {res}.0267289389   .0267289389{txt}  {c |}{...}
      {it:instability can cause this}
	  3 {c |}  {res}.1079423963   .0989119749{txt}  {c |}{...}
      {it:output to vary a little}
	  4 {c |}  {res}.3666839808   .3863636364{txt}  {c |}{...}
      {it:across different computers}
	    {c BLC}{hline 29}{c BRC}

{p 4 4 2}
We would like to see the second column being nearly equal to the first -- 
the estimated {it:x} being nearly equal to the true {it:x} -- but there 
are substantial differences.

{p 4 4 2}
Even though the difference between {cmd:x} and {cmd:trux} is substantial, 
the difference between them is small in the prediction space:

	: {cmd:A*trux-b, A*x-b}
	{res}       {txt}1  2
	    {c TLC}{hline 9}{c TRC}
	  1 {c |}  {res}0   0{txt}  {c |}
	  2 {c |}  {res}0   0{txt}  {c |}
	  3 {c |}  {res}0   0{txt}  {c |}
	  4 {c |}  {res}0   0{txt}  {c |}
	    {c BLC}{hline 9}{c BRC}

{p 4 4 2}
What made this problem so difficult was the line {cmd:A[3,3] = 1e-15}.  Remove
that and you would find that the maximum absolute difference between {cmd:x}
and {cmd:trux} would be 5.55112e-15.

{p 4 4 2}
The degree to which the residuals {bf:A*x-b} are a reliable measure of the
accuracy of {it:x} depends on the condition number of the matrix, which can be
obtained by {bf:{help mf_cond:[M-5] cond()}}, which for {cmd:A}, is
4.81288e+15.  If the matrix is well conditioned, small residuals imply an
accurate solution for {it:x}.  If the matrix is ill conditioned, small
residuals are not a reliable indicator of accuracy.

{p 4 4 2}
Another way to check the accuracy of {cmd:x} is to set {it:tol}=0 and to see
how well {it:x} could be obtained were {cmd:b}={cmd:A*x}:

	: {cmd:x  = lusolve(A, b, 0)}

	: {cmd:x2 = lusolve(A, A*x, 0)}

{p 4 4 2}
If {cmd:x} and {cmd:x2} are virtually the same, then you can safely assume 
that {cmd:x} is the result of a numerically accurate calculation.
You might compare {cmd:x} and {cmd:x2} with {cmd:mreldif(x2,x)}; see 
{bf:{help mf_reldif:[M-5] reldif()}}.  
In our example, {cmd:mreldif(x2,x)} is .03, a large difference.

{p 4 4 2}
If {it:A} is ill conditioned, then small
changes in {it:A} or {it:B} can lead to radical differences in the solutions
for {it:X}.


{marker conformability}{...}
{title:Conformability}

    {cmd:lusolve(}{it:A}{cmd:,} {it:B}{cmd:,} {it:tol}{cmd:)}:
	{it:input:}
		{it:A}:  {it:n x n}
		{it:B}:  {it:n x k}
	      {it:tol}:  1 {it:x} 1    (optional)
	{it:output:}
	   {it:result}:  {it:n x k}

    {cmd:_lusolve(}{it:A}{cmd:,} {it:B}{cmd:,} {it:tol}{cmd:)}:
	{it:input:}
		{it:A}:  {it:n x n}
		{it:B}:  {it:n x k}
	      {it:tol}:  1 {it:x} 1    (optional)
	{it:output:}
		{it:A}:  0 {it:x} 0
		{it:B}:  {it:n x k}

    {cmd:_lusolve_la(}{it:A}{cmd:,} {it:B}{cmd:,} {it:tol}{cmd:)}:
	{it:input:}
		{it:A}:  {it:n x n}
		{it:B}:  {it:n x k}
	      {it:tol}:  1 {it:x} 1    (optional)
	{it:output:}
		{it:A}:  0 {it:x} 0
		{it:B}:  {it:n x k}
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:lusolve(}{it:A}{cmd:,} {it:B}{cmd:,} ...{cmd:)},
{cmd:_lusolve(}{it:A}{cmd:,} {it:B}{cmd:,} ...{cmd:)},
and
{cmd:_lusolve_la(}{it:A}{cmd:,} {it:B}{cmd:,} ...{cmd:)}
return a result containing missing if 
{it:A} or {it:B} contain missing values.
The functions return a result containing all missing values if {it:A} is
singular.

{p 4 4 2}
{cmd:_lusolve(}{it:A}{cmd:,} {it:B}{cmd:,} ...{cmd:)}
and 
{cmd:_lusolve_la(}{it:A}{cmd:,} {it:B}{cmd:,} ...{cmd:)}
abort with error if {it:A} or {it:B} is a view.

{p 4 4 2}
{cmd:_lusolve_la(}{it:A}{cmd:,} {it:B}{cmd:,} ...{cmd:)}
should not be used directly; use 
{cmd:_lusolve()}.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view lusolve.mata, adopath asis:lusolve.mata},
{view _lusolve.mata, adopath asis:_lusolve.mata};
{cmd:_lusolve_la()} is built in.
{p_end}
