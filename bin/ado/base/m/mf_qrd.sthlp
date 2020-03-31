{smcl}
{* *! version 1.1.10  04mar2020}{...}
{vieweralsosee "[M-5] qrd()" "mansection M-5 qrd()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] qrinv()" "help mf_qrinv"}{...}
{vieweralsosee "[M-5] qrsolve()" "help mf_qrsolve"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{viewerjumpto "Syntax" "mf_qrd##syntax"}{...}
{viewerjumpto "Description" "mf_qrd##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_qrd##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_qrd##remarks"}{...}
{viewerjumpto "Conformability" "mf_qrd##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_qrd##diagnostics"}{...}
{viewerjumpto "Source code" "mf_qrd##source"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[M-5] qrd()} {hline 2}}QR decomposition
{p_end}
{p2col:}({mansection M-5 qrd():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:void}{bind:           }
{cmd:qrd(}{it:numeric matrix A}{cmd:,} {it:Q}{cmd:,} {it:R}{cmd:)}


{p 8 12 2}
{it:void} {bind:          }
{cmd:hqrd(}{it:numeric matrix A}{cmd:,} {it:H}{cmd:,} {it:tau}{cmd:,} {it:R1}{cmd:)}

{p 8 12 2}
{it:void}{bind:          }
{cmd:_hqrd(}{it:numeric matrix A}{cmd:,} {it:tau}{cmd:,} {it:R1}{cmd:)}



{p 8 34 2}
{it:numeric matrix}{bind: }
{cmd:hqrdmultq(}{it:numeric matrix H}{cmd:,} {it:rowvector tau}{cmd:,}
	{it:numeric matrix X}{cmd:,}  {it:real scalar transpose}{cmd:)}

{p 8 36 2}
{it:numeric matrix}{bind: }
{cmd:hqrdmultq1t(}{it:numeric matrix H}{cmd:,} {it:rowvector tau}{cmd:,}
	{it:numeric matrix X}{cmd:)}

{p 8 36 2}
{it:numeric matrix}{bind: }
{cmd:hqrdq(}{it:numeric matrix H}{cmd:,} {it:numeric matrix tau}{cmd:)}

{p 8 12 2}
{it:numeric matrix}{bind: }
{cmd:hqrdq1(}{it:numeric matrix H}{cmd:,} {it:numeric matrix tau}{cmd:)}

{p 8 12 2}
{it:numeric matrix}{bind: }
{cmd:hqrdr(}{it:numeric matrix H}{cmd:)}

{p 8 12 2}
{it:numeric matrix}{bind: }
{cmd:hqrdr1(}{it:numeric matrix H}{cmd:)}



{p 8 12 2}
{it:void}{bind:           }
{cmd:qrdp(}{it:numeric matrix A}{cmd:,} {it:Q}{cmd:,} {it:R}{cmd:,} 
	{it:real rowvector p}{cmd:)}

{p 8 12 2}
{it:void}{bind:           }
{cmd:hqrdp(}{it:numeric matrix A}{cmd:,} {it:H}{cmd:,} {it:tau}{cmd:,} {it:R1}{cmd:,}
	{it:real rowvector p}{cmd:)}

{p 8 12 2}
{it:void}{bind:          }
{cmd:_hqrdp(}{it:numeric matrix A}{cmd:,} {it:tau}{cmd:,} {it:R1}{cmd:,}
	{it:real rowvector p}{cmd:)}


{p 8 12 2}
{it:void}{bind:          }
{cmd:_hqrdp_la(}{it:numeric matrix A}{cmd:,} {it:tau}{cmd:,} {it:real rowvector p}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:qrd(}{it:A}{cmd:,} {it:Q}{cmd:,} {it:R}{cmd:)} 
calculates the QR decomposition of {it:A}: {it:m} {it:x} {it:n},
{it:m}>={it:n}, returning results in {it:Q} and {it:R}.

{p 4 4 2}
{cmd:hqrd(}{it:A}{cmd:,} {it:H}{cmd:,} {it:tau}{cmd:,} {it:R1}{cmd:)}
calculates the QR decomposition of {it:A}: {it:m} {it:x} {it:n},
{it:m}>={it:n}, but rather than returning {it:Q} and {it:R}, returns the
Householder vectors in {it:H} and the scale factors {it:tau} -- from which
{it:Q} can be formed -- and returns an upper-triangular matrix in {it:R1} that
is a submatrix of {it:R}; see
{it:{help mf_qrd##remarks:Remarks}} below for its definition.  Doing
this saves calculation and memory, and other routines allow you to manipulate
these matrices:

{p 8 12 2}
1.
    {cmd:hqrdmultq(}{it:H}{cmd:,} {it:tau}{cmd:,} {it:X}{cmd:,} {it:transpose}{cmd:)}
    returns {it:Q}{it:X} or {it:Q}{bf:'}{it:X} 
    on the basis of the {it:Q} implied by {it:H} and {it:tau}.
    {it:Q}{it:X} is returned if
    {it:transpose}=0, and {it:Q}{bf:'}{it:X} is returned otherwise.

{p 8 12 2}
2.
    {cmd:hqrdmultq1t(}{it:H}{cmd:,} {it:tau}{cmd:,} {it:X}{cmd:)}
    returns {it:Q1}{bf:'}{it:X} 
    on the basis of the {it:Q1} implied by {it:H} and {it:tau}.

{p 8 12 2}
3.
    {cmd:hqrdq(}{it:H}{cmd:,} {it:tau}{cmd:)} 
    returns the {it:Q} matrix implied by {it:H} and {it:tau}.  This function
    is rarely used.

{p 8 12 2}
4.
    {cmd:hqrdq1(}{it:H}{cmd:,} {it:tau}{cmd:)} 
    returns the {it:Q1} matrix implied by {it:H} and {it:tau}.  This function
    is rarely used.

{p 8 12 2}
5.
    {cmd:hqrdr(}{it:H}{cmd:)} 
    returns the full {it:R} matrix.  This function is rarely used.
    (It may surprise you that {cmd:hqrdr()} is a function of {it:H} and 
    not {it:R1}.  {it:R1} also happens to be stored in {it:H}, and there 
    is other useful information there, as well.)

{p 8 12 2}
6.
    {cmd:hqrdr1(}{it:H}{cmd:)} 
    returns the {it:R1} matrix.  This function is rarely used.

{p 4 4 2}
{cmd:_hqrd(}{it:A}{cmd:,} {it:tau}{cmd:,} {it:R1}{cmd:)} 
does the same thing as 
{cmd:hqrd(}{it:A}{cmd:,} {it:H}{cmd:,} {it:tau}{cmd:,} {it:R1}{cmd:)},
except that it overwrites {it:H} into {it:A} and so conserves even more
memory.

{p 4 4 2}
{cmd:qrdp(}{it:A}{cmd:,} {it:Q}{cmd:,} {it:R}{cmd:,} {it:p}{cmd:)} 
is similar to 
{cmd:qrd(}{it:A}{cmd:,} {it:Q}{cmd:,} {it:R}):  
it returns the QR
decomposition of {it:A} in {it:Q} and {it:R}.  The difference is that this
routine allows for pivoting.  New argument {it:p} specifies whether a column
is available for pivoting and, on output, {it:p} is overwritten with a
permutation vector that records the pivoting actually performed.  On input,
{it:p} can be specified as {cmd:.} (missing) -- meaning all columns are
available for pivoting -- or {it:p} can be specified as a 1 {it:x} {it:n}
row vector containing 0s and 1s, with 1 meaning the column is fixed and so
may not be pivoted.

{p 4 4 2}
{cmd:hqrdp(}{it:A}{cmd:,} {it:H}{cmd:,} {it:tau}{cmd:,} {it:R1}{cmd:,} {it:p}{cmd:)} 
is a generalization of 
{cmd:hqrd(}{it:A}{cmd:,} {it:H}{cmd:,} {it:tau}{cmd:,} {it:R1}{cmd:)} 
just as {cmd:qrdp()} is a generalization of {cmd:qrd()}.

{p 4 4 2}
{cmd:_hqrdp(}{it:A}{cmd:,} {it:tau}{cmd:,}  {it:R1}{cmd:,} {it: p}{cmd:)} 
does the same thing as 
{cmd:hqrdp(}{it:A}{cmd:,} {it:H}{cmd:,} {it:tau}{cmd:,} {it:R1},
{it:p}{cmd:)}, except that {cmd:_hqrdp()} overwrites {it:H} into {it:A}.

{p 4 4 2}
{cmd:_hqrdp_la()} is the interface into the 
{bf:{help m1_lapack:[M-1] LAPACK}} routine that performs the QR calculation;
it is used by all the above routines.  Direct use of {cmd:_hqrdp_la()} is not
recommended.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 qrd()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_qrd##remarks1:QR decomposition}
	{help mf_qrd##remarks2:Avoiding calculation of Q}
	{help mf_qrd##remarks3:Pivoting}
	{help mf_qrd##remarks4:Least-squares solutions with dropped columns}


{marker remarks1}{...}
{title:QR decomposition}

{p 4 4 2}
The decomposition of square or nonsquare matrix {it:A} can be written as

			{it:A} = {it:QR}{right:(1)   }

{p 4 4 2}
where {it:Q} is an orthogonal matrix ({it:Q}{cmd:'}{it:Q} = {it:I}), and
{it:R} is upper triangular.  
{cmd:qrd(}{it:A}{cmd:,} {it:Q}{cmd:,} {it:R}{cmd:)}
 will make this calculation:

	: {cmd:A}
	{res}       {txt}1   2
	    {c TLC}{hline 9}{c TRC}
	  1 {c |}  {res}4   4{txt}  {c |}
	  2 {c |}  {res}4   6{txt}  {c |}
	  3 {c |}  {res}1   0{txt}  {c |}
	  4 {c |}  {res}2   4{txt}  {c |}
	  5 {c |}  {res}2   1{txt}  {c |}
	    {c BLC}{hline 9}{c BRC}

	: {cmd:Q = R = .}

	: {cmd:qrd(A, Q, R)}

	: {cmd:Ahat = Q*R}

	: {cmd:mreldif(Ahat, A)}
	  4.44089e-16


{marker remarks2}{...}
{title:Avoiding calculation of Q}

{p 4 4 2}
In fact, you probably do not want to use {cmd:qrd()}.  Calculating the 
necessary ingredients for {it:Q} is not too difficult, but going from 
those necessary ingredients to form {it:Q} is devilish.  
The necessary ingredients are usually all you need, which 
are the Householder vectors and their scale factors, known as {it:H} and
{it:tau}.  For instance, one can write down a mathematical function
{it:f}({it:H}, {it:tau}, {it:X}) that will calculate {it:Q}{it:X} or
{it:Q}{cmd:'}{it:X} for some matrix {it:X}.

{p 4 4 2}
Also, QR decomposition is often carried out on violently nonsquare
matrices {it:A}: {it:m} {it:x} {it:n}, {it:m} >> {it:n}.  We can write


					       {c TLC}    {c TRC}
		           {c TLC}               {c TRC}   {c |} {it:R1} {c |}
		A       =  {c |}  {it:Q1}      {it:Q2}   {c |}   {c |}    {c |}  =  {it:Q1}*{it:R1}  + {it:Q2}*{it:R2}
	                   {c BLC}               {c BRC}   {c |} {it:R2} {c |}      
					       {c BLC}    {c BRC}
	      {it:m x n         m x n   m x m-n     n x n     m x n    m x n}
                                              {it:m-n x n}


{p 4 4 2}
{it:R2} is zero, and thus

					       {c TLC}    {c TRC}
		           {c TLC}               {c TRC}   {c |} {it:R1} {c |}
		A       =  {c |}  {it:Q1}      {it:Q2}   {c |}   {c |}    {c |}  =  {it:Q1}*{it:R1}
	                   {c BLC}               {c BRC}   {c |}  0 {c |}      
					       {c BLC}    {c BRC}
	      {it:m x n         m x n   m x m-n     n x n     m x n}
                                              {it:m-n x n}


{p 4 4 2}
Thus it is enough to know {it:Q1} and {it:R1}.  Rather than defining QR
decomposition as

			{it:A} = {it:QR},            {it:Q}: {it:m x m},          {it:R}: {it:m x n}{right:(1)   }

{p 4 4 2}
it is better to define it as 

			{it:A} = {it:Q1}*{it:R1}         {it:Q1}: {it:m x n}          {it:R1}: {it:n x n}{right:(1')  }

{p 4 4 2}
To appreciate the savings, consider the reasonable case where {it:m}=4,000 and
{it:n}=3:

			{it:A} = {it:QR},            {it:Q}: 4,000 {it:x} 4,000,    {it:R}: 4,000 {it:x} 3
    versus, 
			{it:A} = {it:Q1}*{it:R1}         {it:Q1}: 4,000 {it:x} 3        {it:R1}:    3 {it:x} 3

{p 4 4 2}
Memory consumption is reduced from 125,094 kilobytes to 94 kilobytes, a 99.92%
saving!

{p 4 4 2}
Combining the arguments,
we need not save {it:Q} because {it:Q1} is sufficient, 
we need not calculate {it:Q1} because {it:H} and {it:tau} are sufficient, and
we need not store {it:R} because {it:R1} is sufficient.

{p 4 4 2}
That is what 
{cmd:hqrd(}{it:A}{cmd:,} {it:H}{cmd:,} {it:tau}{cmd:,} {it:R1}{cmd:)}
does.  Having
used {cmd:hqrd()}, if you need to multiply the full {it:Q} by some matrix
{it:X}, you can use {cmd:hqrdmultq()}.  Having used {cmd:hqrd()}, if you need
the full {it:Q}, you can use {cmd:hqrdq()} to obtain it, but by that point you
will be making the devilish calculation you sought to avoid and so you might
as well have used {cmd:qrd()} to begin with.  If you want {it:Q1}, you can use
{cmd:hqrdq1()}.  Finally, having used {cmd:hqrd()}, if you need {it:R} or
{it:R1}, you can use {cmd:hqrdr()} and {cmd:hqrdr1()}:

	: {cmd:A}
	{res}       {txt}1   2
	    {c TLC}{hline 9}{c TRC}
	  1 {c |}  {res}4   8{txt}  {c |}
	  2 {c |}  {res}4   6{txt}  {c |}
	  3 {c |}  {res}1   0{txt}  {c |}
	  4 {c |}  {res}2   4{txt}  {c |}
	  5 {c |}  {res}2   1{txt}  {c |}
	    {c BLC}{hline 9}{c BRC}

	: {cmd:H = tau = R1 = .}

	: {cmd:hqrd(A, H, tau, R1)}

	: {cmd:Ahat = hqrdq1(H, tau) * R1}{...}
{col 55}// i.e., {it:Q1}*{it:R1}

	: {cmd:mreldif(Ahat, A)}
	  4.44089e-16


{marker remarks3}{...}
{title:Pivoting}

{p 4 4 2}
The QR decomposition with column pivoting solves 

			{it:AP} = {it:QR}{right:(2)   }

{p 4 4 2}
or, if you prefer,

			{it:AP} = {it:Q1}*{it:R1}{right:(2')  }

{p 4 4 2}
where {it:P} is a permutation matrix; see 
{bf:{help m1_permutation:[M-1] Permutation}}.
We can rewrite this as 

			{it:A} = {it:QRP}{bf:'}{right:(3)   }

{p 4 4 2}
and 

			{it:A} = {it:Q1}*{it:R1}*{it:P}{bf:'}{right:(3')  }

{p 4 4 2}
Column pivoting can improve the numerical accuracy.
The functions
{cmd:qrdp(}{it:A}{cmd:,} {it:Q}{cmd:,} {it:R}{cmd:,} {it:p}{cmd:)} 
and
{cmd:hqrdp(}{it:A}{cmd:,} {it:H}{cmd:,} {it:tau}{cmd:,} {it:R1}{cmd:,} {it:p}{cmd:)} 
perform pivoting and return the permutation matrix {it:P} in permutation
vector form:

	: {cmd:A}
	{res}       {txt}1   2
	    {c TLC}{hline 9}{c TRC}
	  1 {c |}  {res}4   8{txt}  {c |}
	  2 {c |}  {res}4   6{txt}  {c |}
	  3 {c |}  {res}1   0{txt}  {c |}
	  4 {c |}  {res}2   4{txt}  {c |}
	  5 {c |}  {res}2   1{txt}  {c |}
	    {c BLC}{hline 9}{c BRC}

	: {cmd:Q = R = p = .}

	: {cmd:qrdp(A, Q, R, p)}

	: {cmd:Ahat = (Q*R)[., invorder(p)]}{...}
{col 57}// i.e., {it:QRP}'

	: {cmd:mreldif(Ahat, A)}
	  1.97373e-16


	: {cmd:H = tau = R1 = p = .}

	: {cmd:hqrdp(A, H, tau, R1, p)}

	: {cmd:Ahat = (hqrdq1(H, tau)*R1)[., invorder(p)]}{...}
{col 57}// i.e., {it:Q1}*{it:R1}*{it:P}'

	: {cmd:mreldif(Ahat, A)}
	  1.97373e-16

{p 4 4 2}
Before calling {cmd:qrdp()} or {cmd:hqrdp()}, we set {it:p} equal to 
missing, specifying that all columns could be pivoted.
We could just as well have set {it:p} equal to (0, 0), which would have 
stated that both columns were eligible for pivoting.

{p 4 4 2}
When pivoting is disallowed, and when {it:A} is not of full column rank, the
order in which columns appear affects the kind of generalized solution
produced; later columns are, in effect, dropped.  When pivoting is allowed, 
the columns are reordered based on numerical accuracy considerations.  
In the rank-deficient case, you no longer know ahead of time which 
columns will be dropped, because you do not know in what order the 
columns will appear.
Generally, you do not care, but there are occasions when you do.

{p 4 4 2}
In such cases, you can specify which columns are eligible for pivoting and
which are not -- you specify {it:p} as a vector and if {it:p}[{it:i}]=1, the
{it:i}th column may not be pivoted.  The {it:p}[{it:i}]=1
columns 
are (conceptually) moved to appear first in the matrix, and the remaining
columns are ordered optimally after that.  The permutation vector that is
returned in {it:p} accounts for all of this.


{marker remarks4}{...}
{title:Least-squares solutions with dropped columns}

{p 4 4 2}
Least-square solutions are one popular use of QR decomposition.
We wish to solve for {it:x}

			{it:Ax} = {it:b}             ({it:A}:  {it:m x n}, {it:m} >= {it:n}){right:(4)   }

{p 4 4 2}
The problem is that there is no solution to (4) when {it:m} > {it:n} because
we have more equations than unknowns.  Then we want to find {it:x}
such that ({it:Ax}-{it:b}){bf:'}({it:Ax}-{it:b}) is minimized.

{p 4 4 2}
If {it:A} is of full column rank then it is well known that the least-squares
solution for {it:x} is given by 
{cmd:solveupper(}{it:R1}{cmd:,} {it:Q1}{bf:'}{it:b}{cmd:)} 
where {cmd:solveupper()} is an upper-triangular solver; 
see {bf:{help mf_solvelower:[M-5] solvelower()}}.

{p 4 4 2}
If {it:A} is of less than full column rank and we do not care which columns
are dropped, then we can use the same solution:  
{cmd:solveupper(}{it:R1}{cmd:,} {it:Q1}{bf:'}{it:b}{cmd:)}.

{p 4 4 2}
Adding pivoting to the above hardly complicates the issue; the solution
becomes 
{cmd:solveupper(}{it:R1}{cmd:,} {it:Q1}{bf:'}{it:b}{cmd:)[invorder(}{it:p}{cmd:)]}.

{p 4 4 2}
For both cases, the full details are

	: {cmd:A}
	{res}       {txt}1   2   3
	    {c TLC}{hline 13}{c TRC}
	  1 {c |}  {res}3   9   1{txt}  {c |}
	  2 {c |}  {res}3   8   1{txt}  {c |}
	  3 {c |}  {res}3   7   1{txt}  {c |}
	  4 {c |}  {res}3   6   1{txt}  {c |}
	    {c BLC}{hline 13}{c BRC}

	: {cmd:b}
	{res}       {txt} 1
	    {c TLC}{hline 6}{c TRC}
	  1 {c |}  {res} 7{txt}  {c |}
	  2 {c |}  {res} 3{txt}  {c |}
	  3 {c |}  {res}12{txt}  {c |}
	  4 {c |}  {res} 0{txt}  {c |}
	    {c BLC}{hline 6}{c BRC}

	: {cmd:H = tau = R1 = p = .}

	: {cmd:hqrdp(A, H, tau, R1, p)}

	: {cmd:q1b = hqrdmultq1t(H, tau, b)}{...}
{col 50}// i.e., {it:Q1}{bf:'}{it:b}

	: {cmd:xhat = solveupper(R1, q1b)[invorder(p)]}

	: {cmd:xhat}
	{res}       {txt}           1
	    {c TLC}{hline 16}{c TRC}
	  1 {c |}  {res}-1.166666667{txt}  {c |}
	  2 {c |}  {res}         1.2{txt}  {c |}
	  3 {c |}  {res}           0{txt}  {c |}
	    {c BLC}{hline 16}{c BRC}

{p 4 4 2}
The {it:A} matrix in the above example has less than full column rank; the
first column contains a variable with no variation and the third column
contains the data for the intercept.  The solution above is correct, but we
might prefer a solution that included the intercept.  To do that, we
need to specify that the third column cannot be pivoted:

	: {cmd:p = (0, 0, 1)}

	: {cmd:H = tau = R1 = .}

	: {cmd:hqrdp(A, H, tau, R1, p)}

	: {cmd:q1b = hqrdmultq1t(H, tau, b)}

	: {cmd:xhat = solveupper(R1, q1b)[invorder(p)]}

	: {cmd:xhat}
	{res}       {txt}  1
	    {c TLC}{hline 8}{c TRC}
	  1 {c |}  {res}   0{txt}  {c |}
	  2 {c |}  {res} 1.2{txt}  {c |}
	  3 {c |}  {res}-3.5{txt}  {c |}
	    {c BLC}{hline 8}{c BRC}


{marker conformability}{...}
{title:Conformability}

    {cmd:qrd(}{it:A}{cmd:,} {it:Q}{cmd:,} {it:R}{cmd:)}:
	{it:input:}
		{it:A}:  {it:m x n},  {it:m}>={it:n}
	{it:output:}
		{it:Q}:  {it:m x m}
		{it:R}:  {it:m x n}

    {cmd:hqrd(}{it:A}{cmd:,} {it:H}{cmd:,} {it:tau}{cmd:,} {it:R1}{cmd:)}:
	{it:input:}
		{it:A}:  {it:m x n},  {it:m}>={it:n}
	{it:output:}
		{it:H}:  {it:m x n}
	      {it:tau}:  1 {it:x n}
	       {it:R1}:  {it:n x n}

    {cmd:_hqrd(}{it:A}{cmd:,} {it:tau}{cmd:,} {it:R1}{cmd:)}:
	{it:input:}
		{it:A}:  {it:m x n},  {it:m}>={it:n}
	{it:output:}
		{it:A}:  {it:m x n}   (contains {it:H})
	      {it:tau}:  1 {it:x n}
	       {it:R1}:  {it:n x n}

    {cmd:hqrdmultq(}{it:H}{cmd:,} {it:tau}{cmd:,} {it:X}{cmd:,} {it:transpose}{cmd:)}:
		{it:H}:  {it:m x n}
	      {it:tau}:  1 {it:x n}
		{it:X}:  {it:m x c}
	{it:transpose}:  1 {it:x} 1
	   {it:result}:  {it:m x c}

    {cmd:hqrdmultq1t(}{it:H}{cmd:,} {it:tau}{cmd:,} {it:X}{cmd:)}:
		{it:H}:  {it:m x n}
	      {it:tau}:  1 {it:x n}
		{it:X}:  {it:m x c}
	   {it:result}:  {it:n x c}

    {cmd:hqrdq(}{it:H}{cmd:,} {it:tau}{cmd:)}:
		{it:H}:  {it:m x n}
	      {it:tau}:  1 {it:x n}
	   {it:result}:  {it:m x m}

    {cmd:hqrdq1(}{it:H}{cmd:,} {it:tau}{cmd:)}:
		{it:H}:  {it:m x n}
	      {it:tau}:  1 {it:x n}
	   {it:result}:  {it:m x n}

    {cmd:hqrdr(}{it:H}{cmd:)}:
		{it:H}:  {it:m x n}
	   {it:result}:  {it:m x n}

    {cmd:hqrdr1(}{it:H}{cmd:)}:
		{it:H}:  {it:m x n}
	   {it:result}:  {it:n x n}

   {cmd:qrdp(}{it:A}{cmd:,} {it:Q}{cmd:,} {it:R}{cmd:,} {it:p}{cmd:)}:
	{it:input:}
		{it:A}:  {it:m x n},  {it:m}>={it:n}
		{it:p}:  1 {it:x} 1  or  1 {it:x n}
	{it:output:}
		{it:Q}:  {it:m x m}
		{it:R}:  {it:m x n}
		{it:p}:  1 {it:x n}

   {cmd:hqrdp(}{it:A}{cmd:,} {it:H}{cmd:,} {it:tau}{cmd:,} {it:R1}{cmd:,} {it:p}{cmd:)} 
	{it:input:}
		{it:A}:  {it:m x n},  {it:m}>={it:n}
		{it:p}:  1 {it:x} 1  or  1 {it:x n}
	{it:output:}
		{it:H}:  {it:m x n}
	      {it:tau}:  1 {it:x n}
	       {it:R1}:  {it:n x n}
		{it:p}:  1 {it:x n}

    {cmd:_hqrdp(}{it:A}{cmd:,} {it:tau}{cmd:,}  {it:R1}{cmd:,} {it: p}{cmd:)}:
	{it:input:}
		{it:A}:  {it:m x n},  {it:m}>={it:n}
		{it:p}:  1 {it:x} 1  or  1 {it:x n}
	{it:output:}
		{it:A}:  {it:m x n}  (contains {it:H})
	      {it:tau}:  1 {it:x n}
	       {it:R1}:  {it:n x n}
		{it:p}:  1 {it:x n}

    {cmd:_hqrdp_la(}{it:A}{cmd:,} {it:tau}{cmd:,} {it:p}{cmd:)}:
	{it:input:}
		{it:A}:  {it:m x n},  {it:m}>={it:n}
		{it:p}:  1 {it:x} 1  or  1 {it:x n}
	{it:output:}
		{it:A}:  {it:m x n}   (contains {it:H})
	      {it:tau}:  1 {it:x n}
		{it:p}:  1 {it:x n}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:qrd(}{it:A}, ...{cmd:)},
{cmd:hqrd(}{it:A}, ...{cmd:)},
{cmd:_hqrd(}{it:A}, ...{cmd:)},
{cmd:qrdp(}{it:A}, ...{cmd:)},
{cmd:hqrdp(}{it:A}, ...{cmd:)},
and
{cmd:_hqrdp(}{it:A}, ...{cmd:)}
return missing results if {it:A} contains missing values.
That is, {it:Q} will contain all missing values.  {it:R} will contain 
missing values on and above the diagonal.  {it:p} will contain the 
integers 1, 2, ...

{p 4 4 2}
{cmd:_hqrd(}{it:A}, ...{cmd:)}
and
{cmd:_hqrdp(}{it:A}, ...{cmd:)}
abort with error if {it:A} is a view.

{p 4 4 2}
{cmd:hqrdmultq(}{it:H}{cmd:,} {it:tau}{cmd:,} {it:X}, {it:transpose}{cmd:)}
and 
{cmd:hqrdmultq1t(}{it:H}{cmd:,} {it:tau}{cmd:,} {it:X}{cmd:)}
return missing results if {it:X} contains missing values.
  

{marker source}{...}
{title:Source code}

{p 4 4 2}
{view qrd.mata, adopath asis:qrd.mata},
{view hqrd.mata, adopath asis:hqrd.mata},
{view _hqrd.mata, adopath asis:_hqrd.mata},
{view hqrdmultq.mata, adopath asis:hqrdmultq.mata},
{view hqrdmultq1t.mata, adopath asis:hqrdmultq1t.mata},
{view hqrdq.mata, adopath asis:hqrdq.mata},
{view hqrdq1.mata, adopath asis:hqrdq1.mata},
{view hqrdr.mata, adopath asis:hqrdr.mata},
{view hqrdr1.mata, adopath asis:hqrdr1.mata},
{view qrdp.mata, adopath asis:qrdp.mata},
{view hqrdp.mata, adopath asis:hqrdp.mata},
{view _hqrdp.mata, adopath asis:_hqrdp.mata}


{p 4 4 2}
{cmd:_hqrdp_la()} is built in.
{p_end}
