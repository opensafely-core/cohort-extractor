{smcl}
{* *! version 1.1.7  25sep2018}{...}
{vieweralsosee "[M-1] Permutation" "mansection M-1 Permutation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] invorder()" "help mf_invorder"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-1] Intro" "help m1_intro"}{...}
{viewerjumpto "Syntax" "m1_permutation##syntax"}{...}
{viewerjumpto "Description" "m1_permutation##description"}{...}
{viewerjumpto "Links to PDF documentation" "m1_permutation##linkspdf"}{...}
{viewerjumpto "Remarks" "m1_permutation##remarks"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-1] Permutation} {hline 2}}An aside on permutation matrices and vectors
{p_end}
{p2col:}({mansection M-1 Permutation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}
                          Permutation matrix     Permutation vector
        Action                 notation               notation
	{hline 65}
	permute rows            {it:B} = {it:P}{cmd:*}{it:A}           {it:B} = {it:A}{cmd:[}{it:p}{cmd:,.]}

        permute columns         {it:B} = {it:A}{cmd:*}{it:P}           {it:B} = {it:A}{cmd:[}.,{it:p}{cmd:]}

        unpermute rows          {it:B} = {it:P}{cmd:'}{it:A}           {it:B}={it:A} ; {it:B}{cmd:[}{it:p}{cmd:,.]} = {it:A}
							 or
						  {it:B} = {it:A}{cmd:[invorder(}{it:p}{cmd:),.]}

        unpermute columns       {it:B} = {it:A}{cmd:*}{it:P}{cmd:'}          {it:B}={it:A} ; {it:B}{cmd:[},.{it:p}{cmd:]} = {it:A}
							 or
						  {it:B} = {it:A}{cmd:[., invorder(}{it:p}{cmd:)]}
	{hline 65}

{pin}
A {it:permutation matrix} is an {it:n x n} matrix that is a row (or column)
permutation of the identity matrix.

{pin}
A {it:permutation vector} is a 1 {it:x} {it:n} or {it:n} {it:x} 1 vector 
of the integers 1 through {it:n}.

{pin}
The following permutation matrix and permutation vector are equivalent:

                     {c TLC}{c -}       {c -}{c TRC}                    {c TLC}{c -} {c -}{c TRC}
                     {c |} 0  1  0 {c |}                    {c |} 2 {c |}
               {it:P}  =  {c |} 0  0  1 {c |}     <==>    {it:p} =    {c |} 3 {c |}
                     {c |} 1  0  0 {c |}                    {c |} 1 {c |}
                     {c BLC}{c -}       {c -}{c BRC}                    {c BLC}{c -} {c -}{c BRC}

        Either can be used to permute the rows of 

                     {c TLC}{c -}          {c -}{c TRC}                 {c TLC}{c -}          {c -}{c TRC}
                     {c |} {it:a  b  c  d} {c |}                 {c |} {it:e  f  g  h} {c |}
               {it:A}  =  {c |} {it:e  f  g  h} {c |}   to produce    {c |} {it:i  j  k  l} {c |}
                     {c |} {it:i  j  k  l} {c |}                 {c |} {it:a  b  c  d} {c |}
                     {c BLC}{c -}          {c -}{c BRC}                 {c BLC}{c -}          {c -}{c BRC}

        and to permute the columns of 

	             {c TLC}{c -}       {c -}{c TRC}                    {c TLC}{c -}       {c -}{c TRC}
		     {c |} {it:m  n  o} {c |}                    {c |} {it:n  o  m} {c |}
                     {c |} {it:p  q  r} {c |}                    {c |} {it:q  r  p} {c |}
               {it:A}   = {c |} {it:s  t  u} {c |}      to produce    {c |} {it:t  u  s} {c |}
                     {c |} {it:v  w  x} {c |}                    {c |} {it:w  x  v} {c |}
	             {c BLC}{c -}       {c -}{c BRC}                    {c BLC}{c -}       {c -}{c BRC}


{marker description}{...}
{title:Description}

{pstd}
Permutation matrices are a special kind of orthogonal matrix that, via
multiplication, reorder the rows or columns of another matrix.
Permutation matrices cast the reordering in terms of multiplication.

{pstd}
Permutation vectors also reorder the rows or columns of another matrix,
but they do it via subscripting.  This alternative method of achieving the same
end is, computerwise, more efficient, in that it uses less memory and less
computer time.

{pstd}
The relationship between the two is shown below.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-1 PermutationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help m1_permutation##remarks1:Permutation matrices}
	{help m1_permutation##remarks2:How permutation matrices arise}
	{help m1_permutation##remarks3:Permutation vectors}


{marker remarks1}{...}
{title:Permutation matrices}

{pstd}
A permutation matrix is a square matrix whose rows are a permutation of 
the identity matrix.  The following are the full set of all 2 {it:x} 2
permutation matrices:

		{c TLC}{c -}    {c -}{c TRC}
		{c |} 1  0 {c |}{right:(1)}
		{c |} 0  1 {c |}
		{c BLC}{c -}    {c -}{c BRC}

		{c TLC}{c -}    {c -}{c TRC}
		{c |} 0  1 {c |}{right:(2)}
		{c |} 1  0 {c |}
		{c BLC}{c -}    {c -}{c BRC}

{pstd}
Let {it:P} be an {it:n x n} permutation matrix.  If {it:n x m} matrix {it:A}
is premultiplied by {it:P}, the result is to reorder its rows.  For example,

             {it:P}       *       {it:A}        =       {it:PA}
	{c TLC}{c -}       {c -}{c TRC}     {c TLC}{c -}       {c -}{c TRC}       {c TLC}{c -}       {c -}{c TRC}
	{c |} 0  1  0 {c |}     {c |} 1  2  3 {c |}       {c |} 4  5  6 {c |}
	{c |} 0  0  1 {c |}  *  {c |} 4  5  6 {c |}   =   {c |} 7  8  9 {c |}{right:(3)}
	{c |} 1  0  0 {c |}     {c |} 7  8  9 {c |}       {c |} 1  2  3 {c |}
	{c BLC}{c -}       {c -}{c BRC}     {c BLC}{c -}       {c -}{c BRC}       {c BLC}{c -}       {c -}{c BRC}

{pstd}
Above, we illustrated the reordering using square matrix {it:A}, but {it:A} 
did not have to be square.

{p 4 4 2}
If {it:m x n} matrix {it:B} is postmultiplied by {it:P}, the result is to 
reorder its columns.  We illustrate using square matrix {it:A} again:

	     {it:A}       *       {it:P}        =       {it:AP}
	{c TLC}{c -}       {c -}{c TRC}     {c TLC}{c -}       {c -}{c TRC}       {c TLC}{c -}       {c -}{c TRC}
        {c |} 1  2  3 {c |}     {c |} 0  1  0 {c |}       {c |} 3  1  2 {c |}
        {c |} 4  5  6 {c |}  *  {c |} 0  0  1 {c |}   =   {c |} 6  4  5 {c |}{right:(4)}
        {c |} 7  8  9 {c |}     {c |} 1  0  0 {c |}       {c |} 9  7  8 {c |}
	{c BLC}{c -}       {c -}{c BRC}     {c BLC}{c -}       {c -}{c BRC}       {c BLC}{c -}       {c -}{c BRC}


{pstd}
Say that we reorder the rows of {it:A} by forming {it:PA}.  Obviously, we can
unreorder the rows by forming {it:P}^(-1){it:PA}.  Because permutation
matrices are orthogonal, their inverses are equal to their transpose.  Thus
the inverse of the permutation matrix (0,1,0\0,0,1\1,0,0) we have been using
is (0,0,1\1,0,0\0,1,0).  For instance, taking our results from (3)

             {it:P}{bf:'}      *      {it:PA}        =        {it:A}
	{c TLC}{c -}       {c -}{c TRC}     {c TLC}{c -}       {c -}{c TRC}       {c TLC}{c -}       {c -}{c TRC}
	{c |} 0  0  1 {c |}     {c |} 4  5  6 {c |}       {c |} 1  2  3 {c |}
	{c |} 1  0  0 {c |}  *  {c |} 7  8  9 {c |}   =   {c |} 4  5  6 {c |}{right:(3')}
	{c |} 0  1  0 {c |}     {c |} 1  2  3 {c |}       {c |} 7  8  9 {c |}
	{c BLC}{c -}       {c -}{c BRC}     {c BLC}{c -}       {c -}{c BRC}       {c BLC}{c -}       {c -}{c BRC}

{pstd}
Allow us to summarize:

{phang2}
    1.  A permutation matrix {it:P} is a square matrix whose rows are a
        permutation of the identity matrix.

{phang2}
    2.  {it:PA} = a row permutation of {it:A}.

{phang2}
    3.  {it:AP} = a column permutation of {it:A}

{phang2}
    4.  The inverse permutation is given by {it:P}'.

{phang2}
    5.  {it:P}'{it:PA} = {it:A}.

{phang2}
    6.  {it:APP}' = {it:A}.


{marker remarks2}{...}
{title:How permutation matrices arise}

{pstd}
Some of Mata's matrix functions implicitly permute the rows (or columns) of a
matrix.  For instance, the LU decomposition of matrix {it:A} is defined as

		{it:A} = {it:L}*{it:U}

{pstd}
where {it:L} is lower triangular and {it:U} is upper triangular.  For any
matrix {it:A}, one can solve for {it:L} and {it:U}, and Mata has a function
that will do that (see {bf:{help mf_lud:[M-5] lud()}}).  However, Mata's
function does not solve the problem as stated.  Instead, it solves

		{it:P}'{it:A} = {it:L}*{it:U}

{pstd}
where {it:P}' is a permutation matrix that Mata makes up!  Just to be clear;
Mata's function solves for {it:L} and {it:U}, but for a row permutation of
{it:A}, not {it:A} itself, although the function does tell you what
permutation it chose (the function returns {it:L}, {it:U}, and {it:P}).  The
function permutes the rows because, that way, it can produce a more accurate
answer.

{pstd}
You will sometimes read that a function engages in pivoting.  What that means
is that, rather than solving the problem for the matrix as given, it solves
the problem for a permutation of the original matrix, and the function chooses
the permutation in a way to minimize numerical roundoff error.  Functions that
do this invariably return the permutation matrix along with the other results,
because you are going to need it.

{pstd}
For instance, one use of LU decomposition is to calculate inverses.  If
{it:A} = {it:L}*{it:U} then {it:A}^(-1) = {it:U}^(-1)*{it:L}^(-1).
Calculating the inverses of triangular matrices is an easy problem, so one
recipe for calculating inverses is

{phang2}
1.  decompose {it:A} into {it:L} and {it:U},

{phang2}
2.  calculate {it:U}^(-1),

{phang2}
3.  calculate {it:L}^(-1), and

{phang2}
4.  multiply the results together.

{pstd}
That would be the solution except that the LU decomposition function does
not decompose {it:A} into {it:L} and {it:U}; it decomposes {it:P}'{it:A},
although the function does tell us {it:P}.  Thus we can write,

		    {it:P}'{it:A}  =  {it:L}*{it:U}
		      {it:A}  =  {it:P}*{it:L}*{it:U}                   (remember {it:P}'^(-1) = {it:P})
		 {it:A}^(-1)  =  {it:U}^(-1)*{it:L}^(-1)*{it:P}'

{pstd}
Thus the solution to our problem is to use the {it:U} and {it:L} just as we
planned -- calculate {it:U}^(-1)*{it:L}^(-1) -- and then make a column
permutation of that, which we can do by postmultiplying by {it:P}'.

{pstd}
There is, however, a detail that we have yet to reveal to you:  Mata's
LU decomposition function does not return {it:P}, the permutation matrix.
It instead returns {it:p}, a permutation vector equivalent to {it:P}, 
and so the last step -- forming the column permutation by postmultiplying by
{it:P}' -- is done differently.  That is the subject of the next section.

{pstd}
Permutation vectors are more efficient that permutation matrices, but 
you are going to discover that they are not as mathematically transparent.
Thus when working with a function that returns a permutation vector -- when
working with a function that permutes the rows or columns -- think in terms of
permutation matrices and then translate back into permutation vectors.


{marker remarks3}{...}
{title:Permutation vectors}

{pstd}
Permutation vectors are used with Mata's subscripting operator, so before
explaining permutation vectors, let's understand subscripting.

{pstd}
Not surprisingly, Mata allows subscripting.  Given matrix 

			 {c TLC}{c -}       {c -}{c TRC}
		         {c |} 1  2  3 {c |}
		   {it:A}  =  {c |} 4  5  6 {c |}
		         {c |} 7  8  9 {c |}
			 {c BLC}{c -}       {c -}{c BRC}

{pstd}
Mata understands that 

	      {it:A}{cmd:[2,3]}  =  6

{pstd}
Mata also understands that if one or the other subscript is specified as
{cmd:.} (missing value), the entire column or row is to be selected:

			 {c TLC}{c -} {c -}{c TRC}
		         {c |} 3 {c |}
	      {it:A}{cmd:[.,3]}  =  {c |} 6 {c |}
		         {c |} 9 {c |}
			 {c BLC}{c -} {c -}{c BRC}

			 {c TLC}{c -}       {c -}{c TRC}
	      {it:A}{cmd:[2,.]}  =  {c |} 4  5  6 {c |}
			 {c BLC}{c -}       {c -}{c BRC}

{pstd}
Mata also understands that if a vector is specified for either subscript

	   {c TLC}{c -} {c -}{c TRC}         {c TLC}{c -}       {c -}{c TRC}
           {c |} 2 {c |}         {c |} 4  5  6 {c |}
	{it:A}{cmd:[} {c |} 3 {c |} {cmd:, .]} =  {c |} 7  8  9 {c |}
           {c |} 2 {c |}         {c |} 4  5  6 {c |}
	   {c BLC}{c -} {c -}{c BRC}         {c BLC}{c -}       {c -}{c BRC}

{pstd}
In Mata, we would actually write the above as {it:A}{cmd:[(2\3\2),.]}, and Mata 
would understand that we want the matrix made up of rows 2, 3, and 2
of {it:A} and all columns.  Similarly, we can request all rows and columns 2,
3, and 2:

{pstd}
and 

			 {c TLC}{c -}       {c -}{c TRC}
                         {c |} 2  3  2 {c |}
	 {it:A}{cmd:[.,(2,3,2)]} =  {c |} 5  6  5 {c |}
                         {c |} 8  9  8 {c |}
			 {c BLC}{c -}       {c -}{c BRC}


{pstd}
In the above, we wrote (2,3,2) as a row vector because it seems 
more logical that way, but we could just as well have written 
{it:A}{cmd:[.,(2\3\2)]}.  In subscripting, Mata does not care whether the
vectors are rows or columns.

{pstd}
In any case, we can use a vector of indices inside Mata's subscripts to select
rows and columns of a matrix, and that means we can permute them.  All that is
required is that the vector we specify contain a permutation of the integers
1 through {it:n} because, otherwise, we would repeat some rows or columns and
omit others.

{pstd}
A permutation vector is an {it:n} {it:x} 1 or 1 {it:x} {it:n} vector containing
a permutation of the integers 1 through {it:n}.  For example, the permutation
vector equivalent to the permutation matrix

			 {c TLC}{c -}       {c -}{c TRC}
                         {c |} 0  1  0 {c |}
	           {it:P}  =  {c |} 0  0  1 {c |}
                         {c |} 1  0  0 {c |}
			 {c BLC}{c -}       {c -}{c BRC}

{pstd}
is

			 {c TLC}{c -} {c -}{c TRC}
                         {c |} 2 {c |}
		  {it:p}   =  {c |} 3 {c |}
			 {c |} 1 {c |}
			 {c BLC}{c -} {c -}{c BRC}

{pstd}
{it:p} can be used with subscripting to permute the rows of {it:A}

			 {c TLC}{c -}       {c -}{c TRC}
                         {c |} 4  5  6 {c |}
	      {it:A}{cmd:[}{it:p}{cmd:,.]}  =  {c |} 7  8  9 {c |}
                         {c |} 1  2  3 {c |}
			 {c BLC}{c -}       {c -}{c BRC}


{pstd}
and similarly, {it:A}{cmd:[.,}{it:p}{cmd:]} would permute the columns.  

{pstd}
Also subscripting can be used on the left-hand side of the 
equal-sign assignment operator.  So far, we have assumed that the subscripts
are on the right-hand side of the assignment operator, such as

	{it:B}{cmd: =} {it:A}{cmd:[}{it:p}{cmd:,.]}

{pstd}
We have learned that if {it:p}=(2\3\1) (or {it:p}=(2,3,1)), the result is to
copy the second row of {it:A} to the first row of {it:B}, the third row of
{it:A} to the second row of {it:B}, and the first row of {it:A} to the third
row of {it:B}.  Coding

	{it:B}{cmd:[}{it:p}{cmd:,.] =} {it:A}

{pstd}
does the inverse:  it copies the first row of {it:A} to the second row of
{it:B}, the second row of {it:A} to the third row of {it:B}, and the third row
of {it:A} to the first row of {it:B}.  {it:B}{cmd:[}{it:p}{cmd:,.] =} {it:A}
really is the inverse of {it:C} {cmd:=} {it:A}{cmd:[}{it:p}{cmd:,.]} in that, if
we code

	{it:C} {cmd:=} {it:A}{cmd:[}{it:p}{cmd:,.]}
	{it:B}{cmd:[}{it:p}{cmd:,.] =} {it:C}

{pstd}
{it:B} will be equal to {it:A}, and if we code 

	{it:C}{cmd:[}{it:p}{cmd:,.] =} {it:A}
	{it:B} {cmd:=} {it:C}{cmd:[}{it:p}{cmd:,.]}

{pstd}
{it:B} will also be equal to {it:A}.

{pstd}
There is, however, one pitfall that you must watch for when using 
subscripts on the left-hand side:  the matrix on the left-hand side
must already exist and it must be of the appropriate (here same)
dimension.  Thus when performing the inverse copy, it is common to code

	{it:B} {cmd:=} {it:C}
	{it:B}{cmd:[}{it:p}{cmd:,.] =} {it:C}

{pstd}
The first line is not unnecessary; it is what ensures that {it:B} exists and 
is of the proper dimension, although we could just as well code

	{it:B} {cmd:= J(rows(}{it:C}{cmd:), cols(}{it:C}{cmd:), .)}
	{it:B}{cmd:[}{it:p}{cmd:,.] =} {it:C}

{pstd}
The first construction is preferred because it ensures that {it:B} is of the 
same type as {it:C}.  If you really like the second form, you should code

	{it:B} {cmd:= J(rows(}{it:C}{cmd:), cols(}{it:C}{cmd:), missingof(}{it:C}{cmd:))}
	{it:B}{cmd:[}{it:p}{cmd:,.] =} {it:C}

{pstd}
Going back to the preferred code

	{it:B} {cmd:=} {it:C}
	{it:B}{cmd:[}{it:p}{cmd:,.] =} {it:C}

{pstd}
some programmers combine it into one statement:
	
	{cmd:(}{it:B}{cmd:=}{it:C}{cmd:)[}{cmd:p,.] =} {it:C}

{pstd}
Also Mata provides an {cmd:invorder(}{it:p}{cmd:)} 
(see {bf:{help mf_invorder:[M-5] invorder()}})
that will return an
inverted {it:p} appropriate for use on the right-hand side, so you can
also code

	{it:B} {cmd:=} {it:C}{cmd:[invorder(}{it:p}{cmd:),.]}
