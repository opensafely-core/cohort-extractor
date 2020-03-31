{smcl}
{* *! version 1.0.21  15may2018}{...}
{vieweralsosee "[M-5] eigensystemselect()" "mansection M-5 eigensystemselect()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-1] LAPACK" "help m1_lapack"}{...}
{vieweralsosee "[M-5] eigensystem()" "help mf_eigensystem"}{...}
{vieweralsosee "[M-5] matexpsym()" "help mf_matexpsym"}{...}
{vieweralsosee "[M-5] matpowersym()" "help mf_matpowersym"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{viewerjumpto "Syntax" "mf_eigensystemselect##syntax"}{...}
{viewerjumpto "Description" "mf_eigensystemselect##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_eigensystemselect##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_eigensystemselect##remarks"}{...}
{viewerjumpto "Conformability" "mf_eigensystemselect##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_eigensystemselect##diagnostics"}{...}
{viewerjumpto "Source code" "mf_eigensystemselect##source"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[M-5] eigensystemselect()} {hline 2}}Compute selected eigenvectors and eigenvalues{p_end}
{p2col:}({mansection M-5 eigensystemselect():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 40 2}
{it:void}{bind:            }
{cmd:eigensystemselectr(}{it:A}{cmd:,} {it:range}{cmd:,} 
{it:X}{cmd:,} {it:L}{cmd:)} 

{p 8 40 2}
{it:void}{bind:        }
{cmd:lefteigensystemselectr(}{it:A}{cmd:,} {it:range}{cmd:,}
{it:X}{cmd:,} {it:L}{cmd:)} 

{p 8 40 2}
{it:void}{bind:            }
{cmd:eigensystemselecti(}{it:A}{cmd:,} {it:index}{cmd:,} 
{it:X}{cmd:,} {it:L}{cmd:)} 

{p 8 40 2}
{it:void}{bind:        }
{cmd:lefteigensystemselecti(}{it:A}{cmd:,} {it:index}{cmd:,} 
{it:X}{cmd:,} 
{it:L}{cmd:)} 

{p 8 40 2}
{it:void}{bind:            }
{cmd:eigensystemselectf(}{it:A}{cmd:,} {it:f}{cmd:,}{bind:    } 
{it:X}{cmd:,} 
{it:L}{cmd:)} 

{p 8 40 2}
{it:void}{bind:        }
{cmd:lefteigensystemselectf(}{it:A}{cmd:,} {it:f}{cmd:,}{bind:    }  
{it:X}{cmd:,} 
{it:L}{cmd:)} 

{p 8 40 2}
{it:void}{bind:         }
{cmd:symeigensystemselectr(}{it:A}{cmd:,} {it:range}{cmd:,} 
{it:X}{cmd:,} 
{it:L}{cmd:)}

{p 8 40 2}
{it:void}{bind:         }
{cmd:symeigensystemselecti(}{it:A}{cmd:,} {it:index}{cmd:,} 
{it:X}{cmd:,} 
{it:L}{cmd:)}

{p 4 4 2}
where inputs are 

{p2colset 9 33 35 2}{...}
{p2col 13 33 35 2: {it:A}:  {it:numeric matrix}}{p_end}
{p2col 9 33 35 2:{it:range}:  {it:real vector}}(range of eigenvalues to be selected){p_end}
{p2col 9 33 35 2:{it:index}:  {it:real vector}}(indices of eigenvalues to be selected){p_end}
{p2col 13 33 35 2:{it:f}:  {it:pointer scalar}}(points to a function used to select eigenvalue){p_end}

{p 4 4 2}
and outputs are

            {it:X}:  {it:numeric matrix} of eigenvectors 
            {it:L}:  {it:numeric vector} of eigenvalues
	

{p 4 4 2}
The following routines are used in implementing the above routines:

{p 8 33 2}
{it:void}
{cmd:_eigenselecti_la(}{it:numeric matrix A}{cmd:,} 
{it:XL}{cmd:,} 
{it:XR}{cmd:,} 
{it:L}{cmd:,} 
{it:string scalar side}{cmd:,}
{it:real vector index}{cmd:)}

{p 8 33 2}
{it:void}
{cmd:_eigenselectr_la(}{it:numeric matrix A}{cmd:,} 
{it:XL}{cmd:,} 
{it:XR}{cmd:,} 
{it:L}{cmd:,} 
{it:string scalar side}{cmd:,}
{it:real vector range}{cmd:)}

{p 8 33 2}
{it:void}
{cmd:_eigenselectf_la(}{it:numeric matrix A}{cmd:,} 
{it:XL}{cmd:,} 
{it:XR}{cmd:,} 
{it:L}{cmd:,} 
{it:string scalar side}{cmd:,}
{it:pointer scalar f}{cmd:)}

{p 8 33 2}
{it:real scalar}
{cmd:_eigenselect_la(}{it:numeric matrix A}{cmd:,} 
{it:XL}{cmd:,} 
{it:XR}{cmd:,} 
{it:L}{cmd:,} 
{it:select}{cmd:,} 
{it:string scalar side}{cmd:,}
{it:real scalar noflopin}{cmd:)}

{p 8 33 2}
{it:real scalar}
{cmd:_symeigenselect_la(}{it:numeric matrix A}{cmd:,} 
{it:X}{cmd:,} 
{it:L}{cmd:,}
{it:ifail}{cmd:,}
{it:real scalar type}{cmd:,}
{it:lower}{cmd:,}
{it:upper}{cmd:,}
{it:abstol}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:eigensystemselectr(}{it:A}{cmd:,} {it:range}{cmd:,} 
{it:X}{cmd:,} 
{it:L}{cmd:)}
computes selected right eigenvectors of a square, numeric matrix {it:A} along
with their corresponding eigenvalues.  Only the eigenvectors corresponding to
selected eigenvalues are computed.  Eigenvalues that lie in a 
{help mf_eigensystemselect##range:range} are selected.  The selected 
eigenvectors are returned in {it:X}, and their corresponding eigenvalues are 
returned in {it:L}.

{p 8 8 2}  
{it:range} is a vector of length 2.  All eigenvalues with 
absolute value in the half-open interval 
({it:range}{cmd:[1]}, {it:range}{cmd:[2]}] are selected.

{p 4 4 2} {cmd:lefteigensystemselectr(}{it:A}{cmd:,} {it:range}{cmd:,} 
{it:X}{cmd:,} {it:L}{cmd:)} mirrors {cmd:eigensystemselectr()}, 
the difference being that it computes selected left eigenvectors 
instead of selected right eigenvectors.

{p 4 4 2}
{cmd:eigensystemselecti(}{it:A}{cmd:,} {it:index}{cmd:,} 
{it:X}{cmd:,} {it:L}{cmd:)}
computes selected right eigenvectors of a square, numeric matrix, {it:A},
along with their corresponding eigenvalues.  Only the eigenvectors 
corresponding to selected eigenvalues are computed.  Eigenvalues are 
selected by an 
{help mf_eigensystemselect##index:index}.  The selected eigenvectors
are returned in {it:X}, and the selected eigenvalues are returned in {it: L}.

{p 8 8 2} 
{it:index} is a vector of length 2.  
The eigenvalues are sorted by their absolute values, in descending order.
The eigenvalues whose rank is {it:index}{cmd:[1]} through
{it:index}{cmd:[2]}, inclusive, are selected.

{p 4 4 2} {cmd:lefteigensystemselecti(}{it:A}{cmd:,} {it:index}{cmd:,} 
{it:X}{cmd:,} {it:L}{cmd:)} mirrors {cmd:eigensystemselecti()}, the
difference being that it computes selected left eigenvectors instead of
selected right eigenvectors.

{p 4 4 2}
{cmd:eigensystemselectf(}{it:A}{cmd:,} {it:f}{cmd:,} 
{it:X}{cmd:,} {it:L}{cmd:)}
computes selected right eigenvectors of a square, numeric matrix, {it:A},
along with their corresponding eigenvalues.  Only the eigenvectors 
corresponding to selected eigenvalues are computed.  Eigenvalues are 
selected by a user-written function described 
{help mf_eigensystemselect##criterion:below}.  
The selected eigenvectors are returned in {it:X}, and the selected
eigenvalues are returned in {it:L}.

{p 4 4 2} {cmd:lefteigensystemselectf(}{it:A}{cmd:,} {it:f}{cmd:,} 
{it:X}{cmd:,} {it:L}{cmd:)} mirrors {cmd:eigensystemselectf()}, the
difference being that it computes selected left eigenvectors instead of
selected right eigenvectors.

{p 4 4 2}
{cmd:symeigensystemselectr(}{it:A}{cmd:,} {it:range}{cmd:,} 
{it:X}{cmd:,} {it:L}{cmd:)}
computes selected eigenvectors of a symmetric (Hermitian) matrix, {it:A},
along with their corresponding eigenvalues.  Only the eigenvectors 
corresponding to selected eigenvalues are computed.  Eigenvalues that lie in a 
{help mf_eigensystemselect##range:range} are selected.  The selected
eigenvectors are returned in {it:X}, and their corresponding eigenvalues are
returned in {it:L}.

{p 4 4 2}
{cmd:symeigensystemselecti(}{it:A}{cmd:,} {it:index}{cmd:,} 
{it:X}{cmd:,} {it:L}{cmd:)}
computes selected eigenvectors of a symmetric (Hermitian) matrix, {it:A},
along with their corresponding eigenvalues.  Only the eigenvectors 
corresponding to selected eigenvalues are computed.  Eigenvalues are 
selected by an {help mf_eigensystemselect##index:index}.  
The selected eigenvectors are returned in {it:X}, and the selected 
eigenvalues are returned in {it:L}.

{p 4 4 2}
{cmd:_eigenselectr_la()}, {cmd:_eigenselecti_la()}, 
{cmd:_eigenselectf_la()}, {cmd:_eigenselect_la()}, 
and {cmd:_symeigenselect_la()}  are the interfaces into the 
{bf:{help m1_lapack:[M-1] LAPACK}}
routines used to implement the above functions.  Their direct use is not 
recommended.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 eigensystemselect()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

       {help mf_eigensystemselect##intro:Introduction}
       {help mf_eigensystemselect##range:Range selection}
       {help mf_eigensystemselect##index:Index selection}
       {help mf_eigensystemselect##criterion:Criterion selection}
       {help mf_eigensystemselect##other:Other functions}


{marker intro}{...}
{title:Introduction}

{p 4 4 2}
These routines compute subsets of the available eigenvectors.  This
computation can be much faster than computing all the eigenvectors.
(See {helpb mf_eigensystem:[M-5] eigensystem()} for routines to compute all the
eigenvectors and an introduction to the eigensystem problem.)

{p 4 4 2}
There are three methods for selecting which eigenvectors to compute; all of
them are based on the corresponding eigenvalues.  First, we can select only
those eigenvectors whose eigenvalues have absolute values that fall in a
half-open interval.  Second, we can select only those eigenvectors whose
eigenvalues have certain indices, after sorting the eigenvalues by their
absolute values in descending order.  Third, we can select only those
eigenvectors whose eigenvalues meet a criterion encoded in a function.

{p 4 4 2}
Below we illustrate each of these methods.  For comparison purposes, we
begin by computing all the eigenvectors of the matrix

	{cmd:: A}
	       {txt} 1     2     3     4
	    {c TLC}{hline 25}{c TRC}
	  1 {c |}  .31   .69   .13   .56  {c |}
	  2 {c |}  .31    .5   .72   .42  {c |}
	  3 {c |}  .68   .37   .71    .8  {c |}
	  4 {c |}  .09   .16   .83    .9  {c |}
	    {c BLC}{hline 25}{c BRC}

{p 4 4 2}
We perform the computation with {bf:{help mf_eigensystem:eigensystem()}}:

	{cmd:: eigensystem(A, X=., L=.)}

{p 4 4 2}
The absolute values of the eigenvalues are

	{cmd:: abs(L)}
	      {txt}         1             2             3             4
	    {c TLC}{hline 57}{c TRC}
	  1 {c |}  2.10742167   .4658398402   .4005757984   .4005757984   {c |}
    	    {c BLC}{hline 57}{c BRC}

{p 4 4 2}
The corresponding eigenvectors are 

	{cmd:: X}
	       {txt}        1             2                           3
	    {c TLC}{hline 55}
	  1 {c |}  .385302069   -.394945842                 .672770333  
	  2 {c |}  .477773165   -.597299386   -.292386384 - .171958335i 
	  3 {c |}  .604617181   -.192938403   -.102481414 + .519705293i 
	  4 {c |}  .50765459     .670839771    -.08043663 - .381122722i 
            {c BLC}{hline 55}

	       {txt}                       4
	    {hline 29}{c TRC}
	  1                 .672770333   {c |}
	  2   -.292386384 + .171958335i  {c |}
	  3   -.102481414 - .519705293i  {c |}
	  4   -.08043663  + .381122722i  {c |}
            {hline 29}{c BRC}


{marker range}{...}
{title:Range selection}

{p 4 4 2}
In applications, an eigenvalue whose absolute value is greater than 1
frequently corresponds to an explosive solution, whereas an eigenvalue whose
absolute value is less than 1 corresponds to a stable solution.  We
frequently want to use only the eigenvectors from the stable solutions,
which we can do using {cmd:eigensystemselectr()}.  We begin by specifying

	{cmd:: range = (-1, .999999999)}

{p 4 4 2}
which starts from -1 to include 0 and stops at .999999999 to exclude 1.
(The half-open interval in {cmd:range} is open on the left and closed on the
right.)

{p 4 4 2}
Using this {cmd:range} in {cmd:eigensystemselectr()} requests each
eigenvector for which the absolute value of the corresponding eigenvalue
falls in the interval (-1, .999999999].  For the example at hand, we have

	{cmd:: eigensystemselectr(A, range, X=., L=.)}

	{cmd:: X}
	       {txt}      1                          2                          3
         {c TLC}{hline 67}{c TRC}
       1 {c |} -.442004357   .201218963 - .875384534i   .201218963 + .875384534i {c |}
       2 {c |} -.668468693   .136296114 + .431873675i   .136296114 - .431873675i {c |}
       3 {c |} -.215927364  -.706872994 - .022093594i  -.706872994 + .022093594i {c |}
       4 {c |}  .750771548   .471845361 + .218651289i   .471845361 - .218651289i {c |}
 	 {c BLC}{hline 67}{c BRC}
	
	{cmd:: L}
	       {txt}    1                          2                          3
         {c TLC}{hline 65}{c TRC}
       1 {c |} .46583984  -.076630755 + .393177692i  -.076630755 - .393177692i {c |}
	 {c BLC}{hline 65}{c BRC}

	
	{cmd:: abs(L)}	
	     {txt}         1             2             3
         {c TLC}{hline 43}{c TRC}
       1 {c |}  .4658398402   .4005757984   .4005757984  {c |}
	 {c BLC}{hline 43}{c BRC}

{p 4 4 2}
The above output illustrates that {cmd:eigensystemselectr()} has not included
the results for the eigenvalue whose absolute value is greater than 1, as
desired.


{marker index}{...}
{title:Index selection}

{p 4 4 2}
In many statistical applications, an eigenvalue measures the importance of
an eigenvector factor.  In these applications, we want only to compute
several of the largest eigenvectors.  Here we use {cmd:eigensystemselecti()}
to compute the eigenvectors corresponding to the two largest eigenvalues:

	{cmd:: index = (1, 2)}

	{cmd:: eigensystemselecti(A, index, X=., L=.)}

	{cmd:: L}
               {txt}        1            2
            {c TLC}{hline 27}{c TRC}
          1 {c |}  2.10742167    .46583984  {c |}
            {c BLC}{hline 27}{c BRC}

	{cmd:: X}
               {txt}        1             2
            {c TLC}{hline 28}{c TRC}
          1 {c |}  .385302069   -.442004357  {c |}
          2 {c |}  .477773165   -.668468693  {c |}
          3 {c |}  .604617181   -.215927364  {c |}
          4 {c |}  .50765459     .750771548  {c |}
            {c BLC}{hline 28}{c BRC}


{marker criterion}{...}
{title:Criterion selection}

{p 4 4 2}
In some applications, we want to compute only those eigenvectors
whose corresponding eigenvalues satisfy a more complicated criterion.  
We can use {cmd:eigensystemselectf()} to solve these problems.

{p 4 4 2}
We must pass {cmd:eigensystemselectf()} a {help m2_ftof:pointer} to a
function that implements our criterion.  The function must accept a complex
scalar argument so that it can receive an eigenvalue, and it must return
the real value 0 to indicate rejection and a nonzero real value to indicate
selection.

{p 4 4 2}
In the example below, we consider the common criterion of whether the
eigenvalue is real.  We want only to compute the eigenvectors corresponding
to real eigenvalues.  After deciding that anything smaller than 1e-15 is
zero, we define our function to be

	{cmd:: real scalar onlyreal(complex scalar ev)}
	{cmd:> {c -(}}
	{cmd:>         return( (abs(Im(ev))<1e-15) )}
	{cmd:> {c )-}}


{p 4 4 2}
We compute only the eigenvectors corresponding to the real eigenvalues by
typing

	{cmd:: eigensystemselectf(A, &onlyreal(), X=., L=.)}

{p 4 4 2}
The eigenvalues that satisfy this criterion and their corresponding
eigenvectors are

	{cmd:: L}
               {txt}        1            2
            {c TLC}{hline 26}{c TRC}
          1 {c |}  2.10742167    .46583984 {c |}
            {c BLC}{hline 26}{c BRC}

	{cmd:: X}
               {txt}        1             2
            {c TLC}{hline 28}{c TRC}
          1 {c |}  .385302069   -.442004357  {c |}
          2 {c |}  .477773165   -.668468693  {c |}
          3 {c |}  .604617181   -.215927364  {c |}
          4 {c |}  .50765459     .750771548  {c |}
            {c BLC}{hline 28}{c BRC}


{marker other}{...}
{title:Other functions}

{p 4 4 2}
{cmd:lefteigensystemselectr()} and {cmd:symeigensystemselectr()} use a
{it:range} like {cmd:eigensystemselectr()}.

{p 4 4 2}
{cmd:lefteigensystemselecti()} and {cmd:symeigensystemselecti()} use an
{it:index} like {cmd:eigensystemselecti()}.

{p 4 4 2}
{cmd:lefteigensystemselectf()} uses a pointer to a function like 
{cmd:eigensystemselectf()}.

	
{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:eigensystemselectr(}{it:A}{cmd:,} 
{it:range}{cmd:,}
{it:X}{cmd:,} 
{it:L}{cmd:)}:
{p_end}
	{it:input:}
	        {it:A}:  {it:n x n}
            {it:range}:  1 {it:x} 2 or 2 {it:x} 1				
	{it:output:}
	        {it:X}:  {it:n x m}
                {it:L}:  1 {it:x m}

{p 4 4 2}
{cmd:lefteigensystemselectr(}{it:A}{cmd:,} 
{it:range}{cmd:,}
{it:X}{cmd:,} 
{it:L}{cmd:)}: 
{p_end}
	{it:input:}
	        {it:A}:  {it:n x n}
            {it:range}:  1 {it:x} 2 or 2 {it:x} 1				
	{it:output:}
	        {it:X}:  {it:m x n}
                {it:L}:  1 {it:x m}

{p 4 4 2}
{cmd:eigensystemselecti(}{it:A}{cmd:,} 
{it:index}{cmd:,}
{it:X}{cmd:,} 
{it:L}{cmd:)}:
{p_end}
	{it:input:}
	        {it:A}:  {it:n x n}
            {it:index}:  1 {it:x} 2 or 2 {it:x} 1				
	{it:output:}
	        {it:X}:  {it:n x m}
                {it:L}:  1 {it:x m}

{p 4 4 2}
{cmd:lefteigensystemselecti(}{it:A}{cmd:,} 
{it:index}{cmd:,}
{it:X}{cmd:,} 
{it:L}{cmd:)}:
{p_end}
	{it:input:}
	        {it:A}:  {it:n x n}
            {it:index}:  1 {it:x} 2 or 2 {it:x} 1				
	{it:output:}
	        {it:X}:  {it:m x n}
                {it:L}:  1 {it:x m}

{p 4 4 2}
{cmd:eigensystemselectf(}{it:A}{cmd:,} 
{it:f}{cmd:,}
{it:X}{cmd:,} 
{it:L}{cmd:)}:
{p_end}
	{it:input:}
	        {it:A}:  {it:n x n}
                {it:f}:  1 {it:x} 1				
	{it:output:}
	        {it:X}:  {it:n x m}
                {it:L}:  1 {it:x m}

{p 4 4 2}
{cmd:lefteigensystemselectf(}{it:A}{cmd:,} 
{it:f}{cmd:,}
{it:X}{cmd:,} 
{it:L}{cmd:)}:
{p_end}
	{it:input:}
	        {it:A}:  {it:n x n}
                {it:f}:  1 {it:x} 1				
	{it:output:}
	        {it:X}:  {it:m x n}
                {it:L}:  1 {it:x m}

{p 4 4 2}
{cmd:symeigensystemselectr(}{it:A}{cmd:,} 
{it:range}{cmd:,}
{it:X}{cmd:,} 
{it:L}{cmd:):
{p_end}
	{it:input:}
	        {it:A}:  {it:n x n}
            {it:range}:  1 {it:x} 2 or 2 {it:x} 1				
	{it:output:}
		{it:X}:  {it:n x m}
		{it:L}:  1 {it:x m}

{p 4 4 2}
{cmd:symeigensystemselecti(}{it:A}{cmd:,} 
{it:index}{cmd:,}
{it:X}{cmd:,} 
{it:L}{cmd:):
{p_end}
	{it:input:}
	        {it:A}:  {it:n x n}
            {it:index}:  1 {it:x} 2 or 2 {it:x} 1				
	{it:output:}
		{it:X}:  {it:n x m}
		{it:L}:  1 {it:x m}
			

{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
All functions return missing-value results if {it:A} has missing values. 

{p 4 4 2}
{cmd: symeigensystemselectr()} and
{cmd: symeigensystemselecti()}
use the lower triangle of {it:A} without checking for symmetry.  
When {it:A} is complex, only the real part of the diagonal is used.

{p 4 4 2}
If the {it:i}th eigenvector failed to converge, {cmd:symeigensystemselectr()}
and {cmd:symeigensystemselecti()} insert a vector of missing values into the
{it:i}th column of the returned eigenvector matrix.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view eigensystemselectr.mata, adopath asis:eigensystemselectr.mata},
{view eigensystemselecti.mata, adopath asis:eigensystemselecti.mata},
{view eigensystemselectf.mata, adopath asis:eigensystemselectf.mata},
{view lefteigensystemselectr.mata, adopath asis:lefteigensystemselectr.mata},
{view lefteigensystemselecti.mata, adopath asis:lefteigensystemselecti.mata},
{view lefteigensystemselectf.mata, adopath asis:lefteigensystemselectf.mata},
{view symeigensystemselectr.mata, adopath asis:symeigensystemselectr.mata},
{view symeigensystemselecti.mata, adopath asis:symeigensystemselecti.mata}
{p_end}
