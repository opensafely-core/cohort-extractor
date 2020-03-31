{smcl}
{* *! version 1.0.16  15may2018}{...}
{vieweralsosee "[M-5] geigensystem()" "mansection M-5 geigensystem()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-1] LAPACK" "help m1_lapack"}{...}
{vieweralsosee "[M-5] ghessenbergd()" "help mf_ghessenbergd"}{...}
{vieweralsosee "[M-5] gschurd()" "help mf_gschurd"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{viewerjumpto "Syntax" "mf_geigensystem##syntax"}{...}
{viewerjumpto "Description" "mf_geigensystem##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_geigensystem##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_geigensystem##remarks"}{...}
{viewerjumpto "Conformability" "mf_geigensystem##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_geigensystem##diagnostics"}{...}
{viewerjumpto "Source code" "mf_geigensystem##source"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[M-5] geigensystem()} {hline 2}}Generalized eigenvectors and eigenvalues
{p_end}
{p2col:}({mansection M-5 geigensystem():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 40 2}
{it:void}{bind:               }
{cmd:geigensystem(}{it:A}{cmd:,} 
{it:B}{cmd:,}    
{it:X}{cmd:,} 
{it:w}{cmd:,} 
{it:b}{cmd:)}

{p 8 40 2}
{it:void}{bind:           }
{cmd:leftgeigensystem(}{it:A}{cmd:,} 
{it:B}{cmd:,}   
{it:X}{cmd:,} 
{it:w}{cmd:,} 
{it:b}{cmd:)}


{p 8 40 2}
{it:void}{bind:        }
{cmd:geigensystemselectr(}{it:A}{cmd:,} 
{it:B}{cmd:,} 
{it:range}{cmd:,}  
{it:X}{cmd:,} 
{it:w}{cmd:,} 
{it:b}{cmd:)} 

{p 8 40 2}
{it:void}{bind:    }
{cmd:leftgeigensystemselectr(}{it:A}{cmd:,} 
{it:B}{cmd:,} 
{it:range}{cmd:,}  
{it:X}{cmd:,} 
{it:w}{cmd:,} 
{it:b}{cmd:)} 


{p 8 40 2}
{it:void}{bind:        }
{cmd:geigensystemselecti(}{it:A}{cmd:,} 
{it:B}{cmd:,} 
{it:index}{cmd:,} 
{it:X}{cmd:,} 
{it:w}{cmd:,} 
{it:b}{cmd:)} 

{p 8 40 2}
{it:void}{bind:    }
{cmd:leftgeigensystemselecti(}{it:A}{cmd:,} 
{it:B}{cmd:,} 
{it:index}{cmd:,} 
{it:X}{cmd:,} 
{it:w}{cmd:,} 
{it:b}{cmd:)} 


{p 8 40 2}
{it:void}{bind:        }
{cmd:geigensystemselectf(}{it:A}{cmd:,} 
{it:B}{cmd:,} 
{it:f}{cmd:,} 
{it:X}{cmd:,} 
{it:w}{cmd:,} 
{it:b}{cmd:)} 

{p 8 40 2}
{it:void}{bind:    }
{cmd:leftgeigensystemselectf(}{it:A}{cmd:,} 
{it:B}{cmd:,} 
{it:f}{cmd:,} 
{it:X}{cmd:,} 
{it:w}{cmd:,} 
{it:b}{cmd:)} 


{p 4 4 2}
where inputs are 

{p2colset 9 33 35 2}{...}
{p2col 13 33 35 2: {it:A}:  {it:numeric matrix}}{p_end}
{p2col 13 33 35 2: {it:B}:  {it:numeric matrix}}{p_end}
{p2col 9 33 35 2: {it:range}:  {it:real vector}}(range of generalized eigenvalues to be selected){p_end}
{p2col 9 33 35 2: {it:index}:  {it:real vector}}(indices of generalized eigenvalues to be selected){p_end}
{p2col 13 33 35 2: {it:f}:  {it:pointer scalar}}(points to a function used to select generalized eigenvalues){p_end}

{p 4 4 2}
and outputs are

            {it:X}:  {it:numeric matrix} of generalized eigenvectors 
            {it:w}:  {it:numeric vector} (numerators of generalized eigenvalues)
            {it:b}:  {it:numeric vector} (denominators of generalized eigenvalues)
{p2colreset}{...}
			
{p 4 4 2}
The following routines are used in implementing the above routines:

{p 8 33 2}
{it:void}
{cmd:_geigensystem_la(}{it:numeric matrix H}{cmd:,} 
{it:R}{cmd:,}
{it:XL}{cmd:,}
{it:XR}{cmd:,}
{it:w}{cmd:,}
{it:b}{cmd:,}
{it:string scalar side}{cmd:)}

{p 8 33 2}
{it:void}
{cmd:_geigenselectr_la(}{it:numeric matrix H}{cmd:,} 
{it:R}{cmd:,}
{it:XL}{cmd:,}
{it:XR}{cmd:,}
{it:w}{cmd:,}
{it:b}{cmd:,}
{it:range}{cmd:,}
{it:string scalar side}{cmd:)}

{p 8 33 2}
{it:void}
{cmd:_geigenselecti_la(}{it:numeric matrix H}{cmd:,} 
{it:R}{cmd:,}
{it:XL}{cmd:,}
{it:XR}{cmd:,}
{it:w}{cmd:,}
{it:b}{cmd:,}
{it:index}{cmd:,}
{it:string scalar side}{cmd:)}

{p 8 33 2}
{it:void}
{cmd:_geigenselectf_la(}{it:numeric matrix H}{cmd:,} 
{it:R}{cmd:,}
{it:XL}{cmd:,}
{it:XR}{cmd:,}
{it:w}{cmd:,}
{it:b}{cmd:,}
{it:pointer scalar f}{cmd:,}
{it:string scalar side}{cmd:)}
	
{p 8 33 2}
{it:real scalar}
{cmd:_geigen_la(}{it:numeric matrix H}{cmd:,}
{it:R}{cmd:,}
{it:XL}{cmd:,}
{it:XR}{cmd:,}
{it:w}{cmd:,}
{it:select}{cmd:,}
{it:string scalar side}{cmd:,}
{it:string scalar howmany}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:geigensystem(}{it:A}{cmd:,} {it:B}{cmd:,} {it:X}{cmd:,} {it:w}{cmd:,} 
{it:b}{cmd:)} computes 
{help mf_geigensystem##geigenvector:generalized eigenvectors} of two 
general, real or complex, square matrices, {it:A} and 
{it:B}, along with their corresponding 
{help mf_geigensystem##geigenvalue:generalized eigenvalues}.

{p 8 12 2} o  {it:A} and {it:B} are two general, real or complex, square 
	matrices with the same dimensions.

{p 8 12 2} o  {it:X} contains generalized eigenvectors. 

{p 8 12 2} o  {it:w} contains numerators of generalized eigenvalues. 

{p 8 12 2} o  {it:b} contains denominators of generalized eigenvalues. 

{p 4 4 2}
{cmd:leftgeigensystem(}{it:A}{cmd:,} {it:B}{cmd:,} {it:X}{cmd:,} {it:w}{cmd:,} 
{it:b}{cmd:)} mirrors {cmd:geigensystem()}, the difference being that 
{cmd:leftgeigensystem()} computes 
left, generalized eigenvectors.

{p 4 4 2}
{cmd:geigensystemselectr(}{it:A}{cmd:,} {it:B}{cmd:,} {it:range}{cmd:,} 
{it:X}{cmd:,} {it:w}{cmd:,} {it:b}{cmd:)} computes selected generalized 
eigenvectors of two general, real or complex, square matrices, {it:A} and 
{it:B}, along with their corresponding generalized eigenvalues.  Only the 
generalized eigenvectors corresponding to selected generalized eigenvalues 
are computed.  Generalized eigenvalues that lie in a 
{help mf_geigensystem##range:range} are selected.  The selected
generalized eigenvectors are returned in {it:X}, and their corresponding 
generalized eigenvalues are returned in ({it:w}, {it:b}).

{p 8 8 2}  
{it:range} is a vector of length 2.  All finite, generalized eigenvalues with
absolute value in the half-open interval ({it:range}{cmd:[1]},
{it:range}{cmd:[2]}] are selected.

{p 4 4 2}
{cmd:leftgeigensystemselectr(}{it:A}{cmd:,} {it:B}{cmd:,} 
{it:range}{cmd:,} {it:X}{cmd:,} {it:w}{cmd:,} {it:b}{cmd:)}  
mirrors {cmd:geigensystemselectr()},  the difference being that 
{cmd:leftgeigensystemr()} computes left, generalized eigenvectors.

{p 4 4 2}
{cmd:geigensystemselecti(}{it:A}{cmd:,} {it:B}{cmd:,} 
{it:index}{cmd:,} {it:X}{cmd:,} {it:w}{cmd:,} {it:b}{cmd:)} 
computes selected right, generalized eigenvectors of two general, real or
complex, square matrices, {it:A} and {it:B}, along with their corresponding
generalized eigenvalues.  Only the generalized eigenvectors corresponding to
selected generalized eigenvalues are computed. Generalized eigenvalues are
selected by an {help mf_geigensystem##index:index}.  The selected
generalized eigenvectors are returned in {it:X}, and the selected generalized
eigenvalues are returned in ({it:w}, {it:b}).

{p 8 8 2} 
The finite, generalized eigenvalues are sorted by their absolute values, 
in descending order, followed by the infinite, generalized eigenvalues.
There is no particular order among infinite, generalized eigenvalues.

{p 8 8 2} 
{it:index} is a vector of length 2.  The generalized eigenvalues in elements 
{it:index}{cmd:[1]} through {it:index}{cmd:[2]}, inclusive, 
are selected.

{p 4 4 2}
{cmd:leftgeigensystemselecti(}{it:A}{cmd:,} {it:B}{cmd:,} 
{it:index}{cmd:,} {it:X}{cmd:,} {it:w}{cmd:,} {it:b}{cmd:)} 
mirrors {cmd:geigensystemselecti()},  the difference being that 
{cmd:leftgeigensystemi()} computes left, generalized eigenvectors.

{p 4 4 2}
{cmd:geigensystemselectf(}{it:A}{cmd:,} {it:B}{cmd:,} 
{it:f}{cmd:,} {it:X}{cmd:,} {it:w}{cmd:,} {it:b}{cmd:)}  
computes selected generalized eigenvectors of two general, real or complex,
square matrices {it:A} and {it:B} along with their corresponding generalized
eigenvalues.  Only the generalized eigenvectors corresponding to selected
generalized eigenvalues are computed.  Generalized eigenvalues are selected by
a user-written function described
{help mf_geigensystem##criterion:below}.
The selected generalized eigenvectors are returned in {it:X}, and the selected
generalized eigenvalues are returned in ({it:w}, {it:b}).

{p 4 4 2}
{cmd:leftgeigensystemselectf(}{it:A}{cmd:,} {it:B}{cmd:,} 
{it:f}{cmd:,} {it:X}{cmd:,} {it:w}{cmd:,} {it:b}{cmd:)}  
mirrors {cmd:geigensystemselectf()}, the difference being that
{cmd:leftgeigensystemselectf()} computes selected left, generalized
eigenvectors.

{p 4 4 2}	
{cmd:_geigen_la()}, {cmd:_geigensystem_la()}, {cmd:_geigenselectr_la()}, 
{cmd:_geigenselecti_la()}, and {cmd:_geigenselectf_la()} are the interfaces
into the LAPACK routines used to implement the above functions; see
{bf:{help m1_lapack:[M-1] LAPACK}}.  Their direct use is not recommended.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 geigensystem()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_geigensystem##geigenvalue:Generalized eigenvalues}
	{help mf_geigensystem##geigenvector:Generalized eigenvectors}
	{help mf_geigensystem##criterion:Criterion selection}
	{help mf_geigensystem##range:Range selection}
	{help mf_geigensystem##index:Index selection}


{marker geigenvalue}{...}
{title:Generalized eigenvalues}

{p 4 4 2}
A scalar, {it:l} (usually denoted by {it:lambda}), is said to be a
generalized eigenvalue of a pair of {it:n x n} square, numeric matrices
({cmd:A}, {cmd:B}) if there is a nonzero column vector {cmd:x}: {it:n x} 1
(called the generalized eigenvector) such that

		{cmd:A}{cmd:x} = {it:l}{cmd:B}{cmd:x}{right:(1)}

{p 4 4 2}
(1) can also be written as

		({cmd:A} - {it:l}{cmd:B}){cmd:x} = 0

{p 4 4 2}
A nontrivial solution to this system of {it:n} linear homogeneous equations
exists if and only if

		det({cmd:A} - {it:l}{cmd:B}) = 0 {right:    (2)}

{p 4 4 2}
In practice, the generalized eigenvalue problem for the matrix pair ({cmd:A},
{cmd:B}) is usually formulated as finding a pair of scalars ({it:w}, {it:b})
and a nonzero column vector {cmd:x} such that

                {it:w}{cmd:A}{cmd:x} = {it:b}{cmd:B}{cmd:x}

{p 4 4 2}
The scalar {it:w}/{it:b} is a finite, generalized eigenvalue if {it:b} is 
not zero. The pair ({it:w}, {it:b}) represents an infinite, generalized 
eigenvalue if {it:b} is zero or numerically close to zero.  This situation 
may arise if {cmd:B} is singular.

{p 4 4 2}
The Mata functions that compute generalized eigenvalues return them in two 
complex vectors, {cmd:w} and {cmd:b}, of length {it:n}.  If
{cmd:b[}{it:i}{cmd:]=0}, the {it:i}th generalized eigenvalue is infinite;
otherwise, the {it:i}th generalized eigenvalue is   
{cmd:w[}{it:i}{cmd:]/b[}{it:i}{cmd:]}.


{marker geigenvector}{...}
{title:Generalized eigenvectors}

{p 4 4 2}
A column vector, {cmd:x}, is a right, generalized eigenvector or simply 
a generalized eigenvector of a generalized eigenvalue ({it:w}, {it:b}) 
for a pair of matrices, {cmd:A} and {cmd:B}, if 

		{it:w}{cmd:A}{cmd:x}={it:b}{cmd:B}{cmd:x}

{p 4 4 2}
A row vector, {cmd:v}, is a left, generalized eigenvector of a generalized 
eigenvalue ({it:w}, {it:b}) for a pair of matrices, {cmd:A} and {cmd:B}, if

		{it:w}{cmd:v}{cmd:A}={it:b}{cmd:v}{cmd:B}

{p 4 4 2}
For instance, let's consider the linear system 

	dx/dt = {cmd:A1}*x + {cmd:A2}*u
	dy/dt = {cmd:A3}*x + {cmd:A4}*u
	
{p 4 4 2}
where

	{cmd:: A1 = (-4, -3 \ 2, 1)} 
	{cmd:: A2 = (3 \ 1)}
	{cmd:: A3 = (1, 2)}

{p 4 4 2}
and

	{cmd:: A4 = 0}

{p 4 4 2}
The finite solutions of zeros for the transfer function 

{marker eq3}{...}
	g(s) = {cmd:A3}*(sI-{cmd:A1})^(-1)*{cmd:A2}+{cmd:A4} {right:    (3)}

{p 4 4 2}	
of this linear time-invariant state-space model is given 
by the finite, generalized eigenvalues of {cmd:A} and {cmd:B}
where

	{cmd:: A = (A1, A2 \ A3, A4)}

{p 4 4 2}
and 

	{cmd:: B = (1, 0, 0 \ 0, 1, 0 \ 0, 0, 0)}

{p 4 4 2}
We obtain generalized eigenvectors in {cmd:X} and generalized 
eigenvalues in {cmd:w} and {cmd:b} by using 

	{cmd:: geigensystem(A, B, X=., w=., b=.)}
 
	{cmd:: X}
	      {txt} 1    2            3
	    {c TLC}{hline 24}{c TRC}
	  1 {c |}  -1   0   2.9790e-16   {c |}
	  2 {c |}  .5   0   9.9301e-17   {c |}
	  3 {c |}  .1   1            1   {c |}
	    {c BLC}{hline 24}{c BRC}

	{cmd:: w}
	       {txt}        1             2             3
	   {c TLC}{hline 42}{c TRC}
	 1 {c |}  -1.97989899   3.16227766    2.23606798  {c |}
	   {c BLC}{hline 42}{c BRC}

	{cmd:: b}
	       {txt}        1             2             3
	   {c TLC}{hline 42}{c TRC}
	 1 {c |} .7071067812             0             0  {c |}
	   {c BLC}{hline 42}{c BRC}

{p 4 4 2}
The only finite, generalized eigenvalue of {cmd:A} and {cmd:B} is   

	{cmd:: w[1,1]/b[1,1]}
  	  -2.8

{p 4 4 2}
In this simple example, {help mf_geigensystem##eq3:(3)} can be explicitly
written out as 

	g(s) = (5s+14)/(s^2+3s+2)
	
{p 4 4 2}
which clearly has the solution of zero at -2.8.
	

{marker criterion}{...}
{title:Criterion selection}

{p 4 4 2}
We sometimes want to compute only those generalized eigenvectors
whose corresponding generalized eigenvalues satisfy certain criterion.  
We can use {cmd:geigensystemselectf()} to solve these problems.

{p 4 4 2}
We must pass {cmd:geigensystemselectf()} a {help m2_ftof:pointer} to a
function that implements our conditions.  The function must accept two numeric
scalar arguments so that it can receive the numerator {cmd:w} and the 
denominator {cmd:b} of a generalized eigenvalue, and it must return the real 
value 0 to indicate rejection and a nonzero real value to indicate selection.

{p 4 4 2}
In this example, we want to compute only finite, generalized
eigenvalues for each of which {cmd:b} is not zero.  After deciding that
anything smaller than 1e-15 is zero, we define our function to be

	{cmd:: real scalar finiteonly(numeric scalar w, numeric scalar b)}
	{cmd:> {c -(}}
	{cmd:>         return((abs(b)>=1e-15))}
	{cmd:> {c )-}}

{p 4 4 2}
By using

	{cmd:: geigensystemselectf(A, B, &finiteonly(), X=., w=., b=.)}
	
{p 4 4 2}
we get the only finite, generalized eigenvalue of {cmd:A} and {cmd:B} in 
({cmd:w}, {cmd:b}) and its corresponding eigenvector in {cmd:X}:

	{cmd:: X}
	       {txt}          1
	    {c TLC}{hline 15}{c TRC}
	  1 {c |}  -.894427191  {c |}
	  2 {c |}   .447213595  {c |}
	  3 {c |}   .089442719  {c |}
	    {c BLC}{hline 15}{c BRC}

	{cmd:: w}
	  -1.97989899

	{cmd:: b}
	  .7071067812

	{cmd:: w:/b}
	  -2.8


{marker range}{...}
{title:Range selection}

{p 4 4 2}
We can use {cmd:geigensystemselectr()} to compute only those generalized 
eigenvectors whose generalized eigenvalues have absolute values that fall in 
a half-open interval. 
  	
{p 4 4 2}
For instance, 

{phang2}
{cmd:: A = (-132, -88, 84, 104 \ -158.4, -79.2, 76.8, 129.6 \ 129.6, 81.6, -79.2, -100.8 \ 160, 84, -80, -132)}
	
{phang2}
{cmd:: B = (-60, -50, 40, 50\-69, -46.4, 38, 58.2 \ 58.8, 46, -37.6, -48 \70, 50, -40, -60)}
	
	{cmd:: range = (0.99, 2.1)}

{p 4 4 2}
We obtain generalized eigenvectors in {cmd:X} and generalized 
eigenvalues in {cmd:w} and {cmd:b} by using 

	{cmd:: geigensystemselectr(A, B, range, X=., w=., b=.)} 

	{cmd:: X}
	       {txt}         1            2
	    {c TLC}{hline 27}{c TRC}
	  1 {c |}  .089442719    .02236068  {c |}
	  2 {c |}   .04472136   .067082039  {c |}
	  3 {c |}   .04472136   .067082039  {c |}
	  4 {c |}  .089442719    .02236068  {c |}
	    {c BLC}{hline 27}{c BRC}

	{cmd:: w}
	       {txt}        1            2
	    {c TLC}{hline 27}{c TRC}
	  1 {c |}  .02820603   .170176379   {c |}
	    {c BLC}{hline 27}{c BRC}

	{cmd:: b}
	       {txt}          1             2
	    {c TLC}{hline 29}{c TRC}
	  1 {c |}  .0141030148   .1701763791  {c |}
	    {c BLC}{hline 29}{c BRC}

{p 4 4 2}
The generalized eigenvalues have absolute values in the half-open interval 
(0.99, 2.1].

	{cmd:: abs(w:/b)}
	       {txt} 1   2
	    {c TLC}{hline 9}{c TRC}
	  1 {c |}   2   1 {c |}
	    {c BLC}{hline 9}{c BRC}


{marker index}{...}
{title:Index selection}

{p 4 4 2}
{cmd:geigensystemselect()} sorts the finite, generalized eigenvalues 
using their absolute values, in descending order, placing the 
infinite, generalized eigenvalues after the finite, generalized 
eigenvalues.  There is no particular order among infinite,
generalized eigenvalues.

{p 4 4 2}
If we want to compute only generalized eigenvalues whose ranks are 
{it:index}{cmd:[1]} through {it:index}{cmd:[2]} in the list of 
generalized eigenvalues obtained by {cmd:geigensystemselect()}, 
we can use {cmd:geigensystemselecti()}.
 	
{p 4 4 2}
To compute the first two generalized eigenvalues and generalized 
eigenvectors in this example, we can specify  

	{cmd:: index = (1, 2)}

	{cmd:: geigensystemselecti(A, B, index, X=., w=., b=.)}

{p 4 4 2}
The results are

	{cmd:: X}
	       {txt}          1              2
	    {c TLC}{hline 30}{c TRC}
	  1 {c |}    .02981424    -.059628479  {c |}
	  2 {c |}    .04472136    -.059628479  {c |}
	  3 {c |}   .089442719     -.02981424  {c |}
	  4 {c |}    .01490712    -.119256959  {c |}
	    {c BLC}{hline 30}{c BRC}

	{cmd:: w}
	       {txt}         1            2
	    {c TLC}{hline 27}{c TRC}
	  1 {c |}  .012649111   .379473319  {c |}
	    {c BLC}{hline 27}{c BRC}

	{cmd:: b}
	       {txt}          1             2
	    {c TLC}{hline 29}{c TRC}
	  1 {c |}  .0031622777   .1264911064  {c |}
	    {c BLC}{hline 29}{c BRC}

	{cmd:: w:/b}
	       {txt}1   2
	    {c TLC}{hline 9}{c TRC}
	  1 {c |}  4   3  {c |}
	    {c BLC}{hline 9}{c BRC}


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:geigensystem(}{it:A}{cmd:,} 
{it:B}{cmd:,} 
{it:X}{cmd:,} 
{it:w}{cmd:,} 
{it:b}{cmd:)}:
{p_end}
	{it:input:}
		{it:A}:  {it:n x n}
		{it:B}:  {it:n x n}
	{it:output:}
	        {it:X}:  {it:n x n}
		{it:w}:  1 {it:x n}
                {it:b}:  1 {it:x n}

{p 4 4 2}
{cmd:leftgeigensystem(}{it:A}{cmd:,} 
{it:B}{cmd:,} 
{it:X}{cmd:,} 
{it:w}{cmd:,} 
{it:b}{cmd:)}:
{p_end}
	{it:input:}
		{it:A}:  {it:n x n}
		{it:B}:  {it:n x n}
	{it:output:}
	        {it:X}:  {it:n x n}
		{it:w}:  1 {it:x n}
                {it:b}:  1 {it:x n}

{p 4 4 2}
{cmd:geigensystemselectr(}{it:A}{cmd:,} 
{it:B}{cmd:,} 
{it:range}{cmd:,}
{it:X}{cmd:,} 
{it:w}{cmd:,} 
{it:b}{cmd:)}: 
{p_end}
	{it:input:}
		{it:A}:  {it:n x n}
		{it:B}:  {it:n x n}
	    {it:range}:  1 {it:x} 2 or 2 {it:x} 1
	{it:output:}
	        {it:X}:  {it:n x m}
		{it:w}:  1 {it:x m}
                {it:b}:  1 {it:x m}

{p 4 4 2}
{cmd:leftgeigensystemselectr(}{it:A}{cmd:,}
{it:B}{cmd:,} 
{it:range}{cmd:,}
{it:X}{cmd:,} 
{it:w}{cmd:,} 
{it:b}{cmd:)}:
{p_end}
	{it:input:}
		{it:A}:  {it:n x n}
		{it:B}:  {it:n x n}
	    {it:range}:  1 {it:x} 2 or 2 {it:x} 1
	{it:output:}
	        {it:X}:  {it:m x n}
		{it:w}:  1 {it:x m}
                {it:b}:  1 {it:x m}
		
{p 4 4 2}
{cmd:geigensystemselecti(}{it:A}{cmd:,} 
{it:B}{cmd:,} 
{it:index}{cmd:,} 
{it:X}{cmd:,} 
{it:w}{cmd:,} 
{it:b}{cmd:)}:
{p_end}
	{it:input:}
		{it:A}:  {it:n x n}
		{it:B}:  {it:n x n}
	    {it:index}:  1 {it:x} 2 or 2 {it:x} 1
	{it:output:}
	        {it:X}:  {it:n x m}
		{it:w}:  1 {it:x m}
                {it:b}:  1 {it:x m}

{p 4 4 2}
{cmd:leftgeigensystemselecti(}{it:A}{cmd:,} 
{it:B}{cmd:,} 
{it:index}{cmd:,} 
{it:X}{cmd:,} 
{it:w}{cmd:,} 
{it:b}{cmd:)}:
{p_end}
	{it:input:}
		{it:A}:  {it:n x n}
		{it:B}:  {it:n x n}
	    {it:index}:  1 {it:x} 2 or 2 {it:x} 1
	{it:output:}
	        {it:X}:  {it:m x n}
		{it:w}:  1 {it:x m}
                {it:b}:  1 {it:x m}

{p 4 8 2}
{cmd:geigensystemselectf(}{it:A}{cmd:,} 
{it:B}{cmd:,} 
{it:f}{cmd:,} 
{it:X}{cmd:,} 
{it:w}{cmd:,} 
{it:b}{cmd:)}:
{p_end}
	{it:input:}
		{it:A}:  {it:n x n}
		{it:B}:  {it:n x n}
	      	{it:f}:  1 {it:x} 1
	{it:output:}
	        {it:X}:  {it:n x m}
		{it:w}:  1 {it:x m}
                {it:b}:  1 {it:x m}

{p 4 8 2}
{cmd:leftgeigensystemselectf(}{it:A}{cmd:,} 
{it:B}{cmd:,} 
{it:f}{cmd:,} 
{it:X}{cmd:,} 
{it:w}{cmd:,} 
{it:b}{cmd:)}:
{p_end}
	{it:input:}
		{it:A}:  {it:n x n}
		{it:B}:  {it:n x n}
	      	{it:f}:  1 {it:x} 1
	{it:output:}
	        {it:X}:  {it:m x n}
		{it:w}:  1 {it:x m}
                {it:b}:  1 {it:x m}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
All functions return missing-value results if {it:A} or {it:B} has
missing values. 


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view geigensystem.mata, adopath asis:geigensystem.mata},
{view leftgeigensystem.mata, adopath asis:leftgeigensystem.mata},
{view geigensystemselectr.mata, adopath asis:geigensystemselectr.mata},
{view leftgeigensystemselectr.mata, adopath asis:leftgeigensystemselectr.mata},
{view geigensystemselecti.mata, adopath asis:geigensystemselecti.mata},
{view leftgeigensystemselecti.mata, adopath asis:leftgeigensystemselecti.mata},
{view geigensystemselectf.mata, adopath asis:geigensystemselectf.mata},
{view leftgeigensystemselectf.mata, adopath asis:leftgeigensystemselectf.mata}
{p_end}
