{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] _equilrc()" "mansection M-5 _equilrc()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{viewerjumpto "Syntax" "mf__equilrc##syntax"}{...}
{viewerjumpto "Description" "mf__equilrc##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf__equilrc##linkspdf"}{...}
{viewerjumpto "Remarks" "mf__equilrc##remarks"}{...}
{viewerjumpto "Conformability" "mf__equilrc##conformability"}{...}
{viewerjumpto "Diagnostics" "mf__equilrc##diagnostics"}{...}
{viewerjumpto "Source code" "mf__equilrc##source"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[M-5] _equilrc()} {hline 2}}Row and column equilibration
{p_end}
{p2col:}({mansection M-5 _equilrc():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:void}{bind:         }
{cmd:_equilrc(}{it:numeric matrix A}{cmd:,}
{it:r}{cmd:,}
{it:c}{cmd:)}

{p 8 12 2}
{it:void}{bind:         }
{cmd:_equilr(}{it:numeric matrix A}{cmd:,}
{it:r}{cmd:)}

{p 8 12 2}
{it:void}{bind:         }
{cmd:_equilc(}{it:numeric matrix A}{cmd:,}
{it:c}{cmd:)}


{p 8 12 2}
{it:real scalar}{bind:  }
{cmd:_perhapsequilrc(}{it:numeric matrix A}{cmd:,}
{it:r}{cmd:,}
{it:c}{cmd:)}

{p 8 12 2}
{it:real scalar}{bind:  }
{cmd:_perhapsequilr(}{it:numeric matrix A}{cmd:,}
{it:r}{cmd:)}

{p 8 12 2}
{it:real scalar}{bind:  }
{cmd:_perhapsequilc(}{it:numeric matrix A}{cmd:,}
{it:c}{cmd:)}


{p 8 12 2}
{it:real colvector}
{cmd:rowscalefactors(}{it:numeric matrix A}{cmd:)}

{p 8 12 2}
{it:real rowvector}
{cmd:colscalefactors(}{it:numeric matrix A}{cmd:)}


{p 4 4 2}
The types of {it:r} and {it:c} are irrelevant because they are overwritten.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:_equilrc(}{it:A}{cmd:,} {it:r}{cmd:,} {it:c}{cmd:)}
performs row and column equilibration (balancing) on matrix {it:A}, 
returning the equilibrated matrix in {it:A}, the row-scaling factors in 
{it:r}, and the column-scaling factors in {it:c}.

{p 4 4 2}
{cmd:_equilr(}{it:A}{cmd:,} {it:r}{cmd:)}
performs row equilibration on matrix {it:A}, 
returning the row-equilibrated matrix in {it:A} and the row-scaling factors in 
{it:r}.

{p 4 4 2}
{cmd:_equilc(}{it:A}{cmd:,} {it:c}{cmd:)}
performs column equilibration on matrix {it:A}, 
returning the column-equilibrated matrix in {it:A} and the column-scaling
factors in {it:c}.

{p 4 4 2}
{cmd:_perhapsequilrc(}{it:A}{cmd:,} {it:r}{cmd:,} {it:c}{cmd:)}
performs row and/or column equilibration on matrix {it:A} -- as is 
necessary and which decision is made by {cmd:_perhapsequilrc()} -- returning
the equilibrated matrix in {it:A}, the row-scaling factors in {it:r}, 
the column-scaling factors in {it:c}, and returning 0 (no equilibration 
performed), 1 (row equilibration performed), 2 (column equilibration 
performed), or 3 (row and column equilibration performed).

{p 4 4 2}
{cmd:_perhapsequilr(}{it:A}{cmd:,} {it:r}{cmd:)}
performs row equilibration on matrix {it:A} -- if necessary and which 
decision is made by {cmd:_perhapsequilr()} -- returning 
the equilibrated matrix in {it:A}, the row-scaling factors in {it:r}, 
and returning 0 (no equilibration performed) or 1 (row equilibration performed).

{p 4 4 2}
{cmd:_perhapsequilc(}{it:A}{cmd:,} {it:c}{cmd:)}
performs column equilibration on matrix {it:A} -- if necessary and which 
decision is made by {cmd:_perhapsequilc()} -- returning 
the equilibrated matrix in {it:A}, the column-scaling factors in {it:c}, 
and returning 0 (no equilibration performed) or 1 (column equilibration
performed).

{p 4 4 2}
{cmd:rowscalefactors(}{it:A}{cmd:)} 
returns the row-scaling factors of {it:A}.

{p 4 4 2}
{cmd:colscalefactors(}{it:A}{cmd:)} 
returns the column-scaling factors of {it:A}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 _equilrc()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf__equilrc##remarks1:Introduction}
	{help mf__equilrc##remarks2:Is equilibration necessary?}
	{help mf__equilrc##remarks3:The _equil*() family of functions}
	{help mf__equilrc##remarks4:The _perhapsequil*() family of functions}
	{help mf__equilrc##remarks5:rowscalefactors() and colscalefactors()}


{marker remarks1}{...}
{title:Introduction}

{p 4 4 2}
Equilibration (also known as balancing) takes
a matrix with poorly scaled rows and columns, such as 

	                 1             2
	    {c TLC}{hline 29}{c TRC}
	  1 {c |}  1.00000e+10   5.00000e+10  {c |}
	  2 {c |}  2.00000e-10   8.00000e-10  {c |}
	    {c BLC}{hline 29}{c BRC}

{p 4 4 2} 
and produces a related matrix, such as 

	         1     2
	    {c TLC}{hline 13}{c TRC}
	  1 {c |}   .2     1  {c |}
	  2 {c |}  .25     1  {c |}
	    {c BLC}{hline 13}{c BRC}

{p 4 4 2} 
that will yield improved accuracy in, for instance, the solution to linear 
systems.  The improved matrix above has been row equilibrated.  All we 
did was find the maximum of each row of the original and then divide 
the row by its maximum.  If we were to take the result and repeat the 
process on the columns -- divide each column by the column's maximum -- 
we would obtain

	        1    2
	    {c TLC}{hline 11}{c TRC}
	  1 {c |}  .8    1  {c |}
	  2 {c |}   1    1  {c |}
	    {c BLC}{hline 11}{c BRC}

{p 4 4 2}
which is the row-and-column equilibrated form of the original matrix.

{p 4 4 2}
In terms of matrix notation, equilibration can be thought about in terms 
of multiplication by diagonal matrices.  
The row-equilibrated form of {it:A} is {it:R}{it:A}, where {it:R} contains 
the reciprocals of the row maximums on its diagonal.  The column-equilibrated 
form of {it:A} is {it:A}{it:C}, where {it:C} contains the reciprocals of the 
column maximums on its diagonal.  The row-and-column equilibrated form of 
{it:A} is {it:RAC}, where {it:R} contains the reciprocals of the 
row maximums of {it:A} on its diagonal, and {it:C} contains the reciprocals of
the column maximums of {it:RA} on its diagonal.

{p 4 4 2}
Say we wished to find the solution {it:x} to

		{it:Ax} = {it:b}

{p 4 4 2}
We could compute the solution by solving for {it:y} in the equilibrated system 

		({it:RAC}){it:y} = {it:Rb}

{p 4 4 2}
and then setting 

		{it:x} = {it:Cy}

{p 4 4 2}
Thus routines that perform equilibration need to return to you, in some
fashion, {it:R} and {it:C}.  The routines here do that by returning 
{it:r} and {it:c}, the reciprocals of the maximums in vector form.
You could obtain {it:R} and {it:C} from them by coding 

		{it:R} = {cmd:diag(}{it:r}{cmd:)}
		{it:C} = {cmd:diag(}{it:c}{cmd:)}

{p 4 4 2}
but that is not in general necessary, and it is wasteful of memory.  In code,
you will need to multiply by {it:R} and {it:C}, and you can do that 
using the {cmd::*} operator with {it:r} and {it:c}:

		{it:RA}      <->     {it:r}{cmd::*}{it:A}
		{it:AC}      <->     {it:A}{cmd::*}{it:c}
		{it:RAC}     <->     {it:r}{cmd::*}{it:A}{cmd::*}{it:c}


{marker remarks2}{...}
{title:Is equilibration necessary?}

{p 4 4 2}
Equilibration is not a panacea.  Equilibration can reduce the condition number
of some matrices and thereby improve the accuracy of the solution to linear
systems, but equilibration is not guaranteed to reduce the condition number,
and counterexamples exist in which equilibration actually decreases the
accuracy of the solution.  That said, you have to look long and hard to find
such examples.

{p 4 4 2}
Equilibration is not especially computationally expensive, but neither is it
cheap, especially when you consider the extra computational costs of using the
equilibrated matrices.  In statistical contexts, equilibration may buy you
little because matrices are already nearly equilibrated.  Data analysts know
variables should be on roughly the same scale, and observations are assumed to
be draws from an underlying distribution.  The computational cost of
equilibration is probably better spent somewhere else.  For instance, consider
obtaining regression estimates from {it:X}{bf:'}{it:X} and {it:X}{bf:'}{it:y}.
The gain from equilibrating {it:X}{bf:'}{it:X} and {it:X}{bf:'}{it:y}, or even
from equilibrating the original {it:X} matrix, is nowhere near that from the
gain to be had in removal of the means before {it:X}{bf:'}{it:X} and
{it:X}{bf:'}{it:y} are formed.

{p 4 4 2}
In the example in the previous section, we showed you a matrix that 
assuredly benefited from equilibration.  Even so, 
after row equilibration, column equilibration was unnecessary.
It is often the case that solely row or column equilibration is sufficient, and
in those cases, although the extra equilibration will do no numerical harm, 
it will burn computer cycles.  And, as we have already argued, some matrices
do not need equilibration at all.  

{p 4 4 2}
Thus programmers who want to use equilibration and obtain the best speed
possible examine the matrix and on that basis perform (1) no equilibration,
(2) row equilibration, (3) column equilibration, or (4) both.  They then write
four branches in their subsequent code to handle each case efficiently.

{p 4 4 2}
In terms of determining whether equilibration is necessary, measures of the
row and column condition can be obtained from
{cmd:min(}{it:r}{cmd:)}/{cmd:max(}{it:r}{cmd:)} and
{cmd:min(}{it:c}{cmd:)}/{cmd:max(}{it:c}{cmd:)}, where {it:r} and {it:c} are
the scaling factors (vectors of the reciprocals of the row and column
maximums).  If those measures are near 1 (LAPACK uses >= .1), then
equilibration can be skipped.

{p 4 4 2}
There is also the issue of the overall scale of the matrix.  In theory, the
overall scale should not matter, but many packages set tolerances in absolute
rather than relative terms, and so overall scale does matter.  In most of
Mata's other functions, relative scales are used, but
provisions are made so that you can specify tolerances in relative or absolute
terms.  In any case, LAPACK uses the rule that equilibration is necessary if
the matrix is too small (its maximum value is less than
{cmd:epsilon(}100{cmd:)}, approximately 2.22045e-14) or too large (greater
than 1/{cmd:epsilon(}100{cmd:)}, approximately 4.504e+13).

{p 4 4 2}
To summarize,

{p 8 12 2}
    1.  In statistical applications, we believe that equilibration 
        burns too much computer time and adds too much code complexity
        for the extra accuracy it delivers.  This is a judgment 
        call, and we would probably 
        recommend the use of equilibration were it computationally free.

{p 8 12 2}
    2.  If you are going to use equilibration, there is nothing
        numerically wrong with simply equilibrating matrices in all cases,
        including those in which equilibration is not necessary.  
        The advantages of this is that you will gain the precision to be 
        had from equilibration while still keeping your code reasonably 
        simple.

{p 8 12 2}
    3.  If you wish to minimize execution time, then you want to perform 
        the minimum amount of equilibration possible and write code to 
        deal efficiently with each case:  (1) no equilibration, (2) row
        equilibration, (3) column equilibration, and (4) row and column
        equilibration.  The defaults used by LAPACK and incorporated in Mata's
        {cmd:_perhapsequil*()} routines are

{p 12 16 2}
	    a.   Perform row equilibration if 
                 {cmd:min(}{it:r}{cmd:)}/{cmd:max(}{it:r}{cmd:)}<.1, 
		 or if 
                 {cmd:min(abs(}{it:A}{cmd:))}<{cmd:epsilon(}100{cmd:)}, 
                 or if 
                 {cmd:min(abs(}{it:A}{cmd:))}>1/{cmd:epsilon(}100{cmd:)}. 

{p 12 16 2}
            b.   After performing row equilibration, perform column 
                 equilibration if 
                 {cmd:min(}{it:c}{cmd:)}/{cmd:max(}{it:c}{cmd:)}<.1, 
                 where {it:c} is calculated on {it:r}{cmd::*}{it:A}, 
                 the row-equilibrated {it:A}, if row equilibration was
                 performed.


{marker remarks3}{...}
{title:The _equil*() family of functions}

{p 4 4 2}
The {cmd:_equil*()} family of functions performs equilibration as follows:

{p 8 27 2}
{cmd:_equilrc(}{it:A}{cmd:,} {it:r}{cmd:,} {it:c}{cmd:)}{bind:  }performs
    row equilibration followed by column equilibration; it returns in {it:r}
    and in {it:c} the row- and column-scaling factors, and it modifies {it:A}
    to be the fully equilibrated matrix {it:r}{cmd::*}{it:A}{cmd::*}{it:c}.

{p 8 27 2}
{cmd:_equilr(}{it:A}{cmd:,} {it:r}{cmd:)}{bind:      }performs
    row equilibration only; it returns in {it:r} the row-scaling factors, 
    and it modifies {it:A} to be the row-equilibrated matrix 
    {it:r}{cmd::*}{it:A}.

{p 8 27 2}
{cmd:_equilc(}{it:A}{cmd:,} {it:c}{cmd:)}{bind:      }performs
    column equilibration only; it returns in {it:c} the row-scaling factors, 
    and it modifies {it:A} to be the row-equilibrated matrix 
    {it:A}{cmd::*}{it:c}.

{p 4 4 2}
Here is code to solve {it:Ax} = {it:b} using the fully equilibrated form, 
which damages {it:A} in the process:

		{cmd:_equilrc(A, r, c)}
		{cmd:x = c:*lusolve(A, r:*b)}


{marker remarks4}{...}
{title:The _perhapsequil*() family of functions}

{p 4 4 2}
The {cmd:_perhapsequil*()} family of functions mirrors {cmd:_equil*()}, 
except that these functions apply the rules mentioned above for whether 
equilibration is necessary.

{p 4 4 2}
Here is code to solve {it:Ax} = {it:b}, which may damage {it:A} in the
process:

		{cmd}result = _perhapsequilrc(A, r, c)
		if (result==0)          x = lusolve(A, b)
		else if (result==1)     x = lusolve(A, r:*b)
		else if (result==2)     x = c:*lusolve(A, b)
		else if (result==3)     x = c:*lusolve(A, r:*b){txt}

{p 4 4 2}
As a matter of fact, the {cmd:_perhapsequil*()} family returns a vector of 
1s when equilibration is not performed, so you could code 

		{cmd}(void) _perhapsequilrc(A, r, c)
		x = c:*lusolve(A, r:*b){txt}

{p 4 4 2}
but that would be inefficient.


{marker remarks5}{...}
{title:rowscalefactors() and colscalefactors()}

{p 4 4 2}
{cmd:rowscalefactors(}{it:A}{cmd:)} and 
{cmd:colscalefactors(}{it:A}{cmd:)}
return the scale factors (reciprocals of row and column maximums)
to perform row and column equilibration.  These functions are used 
by the other functions above and are provided for those who wish to 
write their own equilibration routines.  


{marker conformability}{...}
{title:Conformability}

    {cmd:_equilrc(}{it:A}{cmd:,} {it:r}{cmd:,} {it:c}{cmd:)}:
	{it:input:}
		{it:A}:  {it:m x n}
	{it:output:}
		{it:A}:  {it:m x n}
		{it:r}:  {it:m x} 1
		{it:c}:  1 {it:x n}

    {cmd:_equilr(}{it:A}{cmd:,} {it:r}{cmd:)}:
	{it:input:}
		{it:A}:  {it:m x n}
	{it:output:}
		{it:A}:  {it:m x n}
		{it:r}:  {it:m x} 1

    {cmd:_equilc(}{it:A}{cmd:,} {it:c}{cmd:)}:
	{it:input:}
		{it:A}:  {it:m x n}
	{it:output:}
		{it:A}:  {it:m x n}
		{it:c}:  1 {it:x n}

    {cmd:_perhapsequilrc(}{it:A}{cmd:,} {it:r}{cmd:,} {it:c}{cmd:)}:
	{it:input:}
		{it:A}:  {it:m x n}
	{it:output:}
		{it:A}:  {it:m x n}  (unmodified if {it:result} = 0)
		{it:r}:  {it:m x} 1
		{it:c}:  1 {it:x n}
	   {it:result}:  1 {it:x} 1

    {cmd:_perhapsequilr(}{it:A}{cmd:,} {it:r}{cmd:)}:
	{it:input:}
		{it:A}:  {it:m x n}
	{it:output:}
		{it:A}:  {it:m x n}  (unmodified if {it:result} = 0)
		{it:r}:  {it:m x} 1
	   {it:result}:  1 {it:x} 1

    {cmd:_perhapsequilc(}{it:A}{cmd:,} {it:c}{cmd:)}:
	{it:input:}
		{it:A}:  {it:m x n}
	{it:output:}
		{it:A}:  {it:m x n}  (unmodified if {it:result} = 0)
		{it:c}:  1 {it:x n}
	   {it:result}:  1 {it:x} 1

    {cmd:rowscalefactors(}{it:A}{cmd:)}:
		{it:A}:  {it:m x n}
	   {it:result}:  {it:m x} 1

    {cmd:colscalefactors(}{it:A}{cmd:)}:
		{it:A}:  {it:m x n}
	   {it:result}:  1 {it:x n}


{marker diagnostics}{...}
{title:Diagnostics}


{p 4 4 2}
Scale factors used and returned by all functions are calculated by 
{cmd:rowscalefactors(}{it:A}{cmd:)} and
{cmd:colscalefactors(}{it:A}{cmd:)}.
The functions are defined as
{cmd:1:/rowmaxabs(}{it:A}{cmd:)}
and 
{cmd:1:/colmaxabs(}{it:A}{cmd:)}, with missing values changed to 1.
Thus rows or columns that contain missing or are entirely zero are
defined to have scale factors of 1.

{p 4 4 2}
Equilibration functions do not equilibrate rows or columns that contain 
missing or all zeros.

{p 4 4 2}
The {cmd:_equil*()} functions convert {it:A} to an array if {it:A} was 
a view.  The Stata dataset is not changed.

{p 4 4 2}
The {cmd:_perhapsequil*()} functions convert {it:A} to an array if {it:A} was 
a view and returned is nonzero.  The Stata dataset is not changed.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view _equilrc.mata, adopath asis:_equilrc.mata},
{view _equilr.mata, adopath asis:_equilr.mata},
{view _equilc.mata, adopath asis:_equilc.mata},
{view _perhapsequilrc.mata, adopath asis:_perhapsequilrc.mata},
{view _perhapsequilr.mata, adopath asis:_perhapsequilr.mata},
{view _perhapsequilc.mata, adopath asis:_perhapsequilc.mata},
{view rowscalefactors.mata, adopath asis:rowscalefactors.mata},
{view colscalefactors.mata, adopath asis:colscalefactors.mata}
{p_end}
