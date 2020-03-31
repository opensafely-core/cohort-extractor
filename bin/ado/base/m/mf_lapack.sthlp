{smcl}
{* *! version 1.0.11  18sep2018}{...}
{vieweralsosee "[M-5] lapack()" "mansection M-5 lapack()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-1] LAPACK" "help m1_lapack"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] Copyright LAPACK" "help copyright lapack"}{...}
{viewerjumpto "Syntax" "mf_lapack##syntax"}{...}
{viewerjumpto "Description" "mf_lapack##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_lapack##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_lapack##remarks"}{...}
{viewerjumpto "Source code" "mf_lapack##source"}{...}
{viewerjumpto "Reference" "mf_lapack##reference"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[M-5] lapack()} {hline 2}}LAPACK linear-algebra functions
{p_end}
{p2col:}({mansection M-5 lapack():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:void}{bind:    }
{cmd:_flopin(}{it:numeric matrix A}{cmd:)}

{p 8 12 2}
{it:void}{bind:     }
{it:lapack_function}{cmd:(}...{cmd:)}

{p 8 12 2}
{it:void}{bind:    }
{cmd:_flopout(}{it:numeric matrix A}{cmd:)}


{p 4 4 2}
where {it:lapack_function} may be 

		{cmd:LA_DGBMV()}
		{cmd:LA_DGEBAK()}	{cmd:LA_ZGEBAK()} 
		{cmd:LA_DGEBAL()}	{cmd:LA_ZGEBAL()} 
		{cmd:LA_DGEES()}	{cmd:LA_ZGEES()}  
		{cmd:LA_DGEEV()}	{cmd:LA_ZGEEV()}
		{cmd:LA_DGEHRD()}	{cmd:LA_ZGEHRD()}
		{cmd:LA_DGGBAK()}	{cmd:LA_ZGGBAK()}
		{cmd:LA_DGGBAL()}	{cmd:LA_ZGGBAL()} 
		{cmd:LA_DGGHRD()}	{cmd:LA_ZGGHRD()} 
		{cmd:LA_DHGEQZ()}	{cmd:LA_ZHGEQZ()}
		{cmd:LA_DHSEIN()}	{cmd:LA_ZHSEIN()}  
		{cmd:LA_DHSEQR()}	{cmd:LA_ZHSEQR()}

		{cmd:LA_DLAMCH()}
		{cmd:LA_DORGHR()}  
		{cmd:LA_DSYEVX()}

		{cmd:LA_DTGSEN()}	{cmd:LA_ZTGSEN()}
		{cmd:LA_DTGEVC()}	{cmd:LA_ZTGEVC()} 
		{cmd:LA_DTREVC()}	{cmd:LA_ZTREVC()}
		{cmd:LA_DTRSEN()}	{cmd:LA_ZTRSEN()}

				  {cmd:LA_ZUNGHR()}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:LA_DGBMV()}, {cmd:LA_DGEBAK()}, {cmd:LA_ZGEBAK()}, {cmd:LA_DGEBAL()},
{cmd:LA_ZGEBAL()}, ... are LAPACK functions in original, as-is form; see
{bf:{help m1_lapack:[M-1] LAPACK}}.  These functions form the basis for many of
Mata's linear-algebra capabilities.  Mata functions such as
{bf:{help mf_cholesky:cholesky()}}, {bf:{help mf_svd:svd()}}, and
{bf:{help mf_eigensystem:eigensystem()}} are implemented using these functions;
see {bf:{help m4_matrix:[M-4] Matrix}}.  Those functions are easier to use.
The {cmd:LA_}{it:*}{cmd:()} functions provide more capability.

{p 4 4 2}
{cmd:_flopin()} and {cmd:_flopout()} convert matrices to and from the 
form required by the {cmd:LA_}{it:*}{cmd:()} functions.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 lapack()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
LAPACK stands for Linear Algebra PACKage and is a freely available set of 
Fortran 77 routines for solving systems of simultaneous equations, 
eigenvalue problems, and singular-value problems.  
The original Fortran routines have six-letter names like DGEHRD, DORGHR, and
so on.  The Mata functions {cmd:LA_DGEHRD()}, {cmd:LA_DORGHR()}, etc., 
are a subset of the LAPACK double-precision real and complex routine.
All LAPACK double-precision functions will eventually be made available.

{p 4 4 2}
Documentation for the LAPACK routines can be found at 
{browse "http://www.netlib.org/lapack/":http://www.netlib.org/lapack/}, 
although we recommend obtaining {it:LAPACK Users' Guide} by 
{help mf_lapack##Aetal1999:Anderson et al. (1999)}.


{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_lapack##callseq:Mapping calling sequence from Fortran to Mata}
	{help mf_lapack##flopping:Flopping:  Preparing matrices for LAPACK}
	{help mf_lapack##warning1:Warning on the use of rows() and cols() after _flopin()}
	{help mf_lapack##warning2:Warning:  It is your responsibility to check info}
	{help mf_lapack##example:Example}


{marker callseq}{...}
{title:Mapping calling sequence from Fortran to Mata}

{p 4 4 2}
LAPACK functions are named with first letter S, D, C, or Z.  S means
single-precision real, D means double-precision real, C means single-precision
complex, and Z means double-precision complex.  Mata provides the D* and Z*
functions.  The LAPACK documentation is in terms of S* and C*.
Thus, to find the documentation for LA_DGEHRD, you must look up SGEHRD in the
original documentation.

{* In what follows, we do not use tt typeface for Fortran functions}{...}
{* and variables.  tt is reserved for Mata.}{...}
{p 4 4 2}
The documentation 
({help mf_lapack##Aetal1999:Anderson et al. 1999, 227})
reads, in part, 

	SUBROUTINE SGEHRD(N, ILO, IHI, A, LDA, TAU, WORK, LWORK, INFO)
	INTEGER    IHI, ILO, INFO, LDA, LWORK, N
	REAL       A(LDA, *), TAU(*), WORK(LWORK)

{p 4 4 2}
and the documentation states that SGEHDR reduces a real, general matrix,
A, to upper Hessenberg form, H, by an orthogonal similarity transformation:
Q'*A*Q = H.

{p 4 4 2}
The corresponding Mata function, {cmd:LA_DGEHRD()}, has the same arguments.
In Mata, arguments {cmd:ihi}, {cmd:ilo}, {cmd:info}, {cmd:lda}, {cmd:lwork},
and {cmd:n} are {it:real} {it:scalars}.  Argument {cmd:A} is a 
{it:real} {it:matrix}, and arguments {cmd:tau} and {cmd:work} are {it:real}
{it:vectors}.

{p 4 4 2}
You can read the rest of the original documentation to find out what is to be
placed (or returned) in each argument.  It turns out that A is
assumed to be dimensioned LDA {it:x} {it:something} and that the routine works
on A(1,1) (using Fortran notation) through A(N,N).  The routine also needs
work space, which you are to supply in vector WORK.  In the standard LAPACK
way, LAPACK offers you a choice:  you can preallocate WORK, in which case you
have to choose a fairly large dimension for it, or you can do a query
to find out how large the dimension needs to be for this particular problem.
If you preallocate, the documentation reveals that the WORK must be of size N,
and you set LWORK equal to N.  If you wish to query, then you make WORK of size
1 and set LWORK equal to -1.  The LAPACK routine will then return in the first
element of WORK the optimal size.  Then you call the function again with WORK
allocated to be the optimal size and LWORK set to equal the optimal size.

{p 4 4 2}
Concerning Mata, the above works.  You can follow the LAPACK documentation to
the letter.  Use {bf:{help mf_j:J()}} to allocate matrices or vectors.
Alternatively, you can specify all sizes as missing value ({cmd:.}), and Mata
will fill in the appropriate value based on the assumption that you are using
the entire matrix.  Thus, in {cmd:LA_DGEHRD()}, you could specify {cmd:lda} as
missing, and the function would run as if you had specified {cmd:lda} equal to
{cmd:cols(A)}.  You could specify {cmd:n} as missing, and the function would
run as if you had specified {cmd:n} as {cmd:rows(A)}.

{p 4 4 2}
Work areas, however, are treated differently.  You can follow the standard
LAPACK convention outlined above; or you can specify the sizes of work 
areas ({cmd:lwork})
and specify the work areas themselves ({cmd:work}) 
as missing values, and Mata will allocate the work areas for you.
The allocation will be as you specified.

{p 4 4 2}
One feature provided by some LAPACK functions is not supported by the Mata
implementation.  If a function allows a function pointer, you may not avail
yourself of that option.


{marker flopping}{...}
{title:Flopping:  Preparing matrices for LAPACK}

{p 4 4 2}
The LAPACK functions provided in Mata are the original LAPACK functions.
Mata, which is C based, stores matrices rowwise.  LAPACK, which is Fortran
based, stores matrices columnwise.  Mata and Fortran also disagree 
on how complex matrices are to be organized.

{p 4 4 2}
Functions {cmd:_flopin()} and {cmd:_flopout()} handle these issues.  Coding
{cmd:_flopin(}{it:A}{cmd:)} changes matrix {it:A} from the Mata convention to
the LAPACK convention.  Coding {cmd:_flopout(}{it:A}{cmd:)} changes
{it:A} from the LAPACK convention to the Mata convention.

{p 4 4 2}
The {cmd:LA_}{it:*}{cmd:()} functions do not do this for you because LAPACK
often takes two or three LAPACK functions run in sequence to achieve the
desired result, and it would be a waste of computer time to switch conventions
between calls.


{marker warning1}{...}
{title:Warning on the use of rows() and cols() after _flopin()}

{p 4 4 2}
Be careful using the {cmd:rows()} and {cmd:cols()} functions.  
{cmd:rows()} of a flopped matrix returns the logical number of columns and 
{cmd:cols()} of a flopped matrix returns the logical number of rows!

{p 4 4 2}
The danger of confusion is especially great when using {helpb mf_j:J()} to
allocate work areas.  If a LAPACK function requires a work area of {it:r}
{it:x} {it:c}, you code,

	{cmd:_LA_}{it:function}{cmd:(}...{cmd:, J(}{it:c}{cmd:,} {it:r}{cmd:, .),} ...{cmd:)}


{marker warning2}{...}
{title:Warning:  It is your responsibility to check info}

{p 4 4 2}
The LAPACK functions do not abort with error on failure.
They instead store 0 in {cmd:info} (usually the last argument) if 
successful and store an error code if not successful.  The error 
code is usually negative and indicates the argument that is a problem.


{marker example}{...}
{title:Example}	

{p 4 4 2}    
The following example uses the LAPACK function DGEHRD to obtain the Hessenberg
form of matrix {cmd:A}.  We will begin with

	   {txt}  1    2    3    4
	  {c TLC}{hline 21}{c TRC}
	1 {c |}   1    2    3    4  {c |}
	2 {c |}   4    5    6    7  {c |}
	3 {c |}   7    8    9   10  {c |}
	4 {c |}   8    9   10   11  {c |}
	  {c BLC}{hline 21}{c BRC}
    
{p 4 4 2}    
The first step is to use {cmd:_flopin()} to put {cmd:A} in LAPACK order:
    
	{cmd:: _flopin(A)}

{p 4 4 2}    
Next we make a work-space query to get the optimal size of the work area.

	{cmd:: LA_DGEHRD(., 1, 4, A, ., tau=., work=., lwork=-1, info=0)}

	{cmd:: lwork = work[1,1]}

	{cmd:: lwork}
	  128

{p 4 4 2}    
After putting the work-space size in {cmd:lwork}, we
can call {cmd:LA_DGEHRD()} again to perform the Hessenberg decomposition:

	{cmd:: LA_DGEHRD(., 1, 4, A, ., tau=., work=., lwork, info=0)}

{p 4 4 2}    
LAPACK function DGEHRD saves the result in the upper triangle and the first 
subdiagonal of {cmd:A}.  We must use {cmd:_flopout()} to change that back 
to Mata order, and finally, we extract the result:

        {cmd:: _flopout(A)}

	{cmd:: A = A-sublowertriangle(A, 2)}

	{cmd:: A}
	 {txt}             1            2             3            4
	  {c TLC}{hline 56}{c TRC}
	1 {c |}            1  -5.370750529  .0345341258   .3922322703  {c |}
	2 {c |} -11.35781669  25.18604651   -4.40577178  -.6561483899  {c |}
	3 {c |}            0  -1.660145888  -.1860465116  .1760901813  {c |}
	4 {c |}            0   0            -8.32667e-16 -5.27356e-16  {c |}
	  {c BLC}{hline 56}{c BRC}


{marker source}{...}
{title:Source code}

{p 4 4 2}
    The {cmd:LA_}{it:*}{cmd:()} functions are simply interfaces into the
    original LAPACK Fortran code.  
    See {bf:{help copyright_lapack:[R] Copyright LAPACK}}.
{p_end}


{marker reference}{...}
{title:Reference}

{marker Aetal1999}{...}
{p 4 8 2}
Anderson, E., Z. Bai, C. Bischof, S. Blackford, J. Demmel, J. Dongarra, 
    J. Du Croz, A. Greenbaum, S. Hammarling, A. McKenney, and D. Sorensen.
    1999.  {it:LAPACK Users' Guide}. 3rd ed.  Philadelphia: Society for
    Industrial and Applied Mathematics.
{p_end}
