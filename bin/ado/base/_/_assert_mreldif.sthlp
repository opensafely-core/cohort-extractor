{smcl}
{* *! version 1.0.7  20sep2014}{...}
{vieweralsosee "undocumented" "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] assert" "help assert"}{...}
{vieweralsosee "[P] cscript" "help cscript"}{...}
{vieweralsosee "[FN] Matrix functions (mreldif())" "help mreldif()"}{...}
{viewerjumpto "Syntax" "_assert_mreldif##syntax"}{...}
{viewerjumpto "Description" "_assert_mreldif##description"}{...}
{viewerjumpto "Options" "_assert_mreldif##options"}{...}
{viewerjumpto "Example" "_assert_mreldif##example"}{...}
{title:Title}

{p2colset 5 28 30 2}{...}
{p2col: {hi:[P] _assert_mreldif} {hline 2}}Assert that two matrices are the same
{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{tab}{cmd:_assert_mreldif}  {it:matexp1} {it:matexp2} [{cmd:,} {it:options} ]

{tab}{cmd:_assert_mreldifs} {it:matexp1} {it:matexp2} [{cmd:,} {it:options} ]

{tab}{cmd:_assert_mreldifp} {it:matexp1} {it:matexp2} [{cmd:,} {it:options} ]

{p2colset 5 16 18 2}{...}
{p2col:{it:option}}Description{p_end}
{p2line}
{p2col:{opt tol(#)}}tolerance for testing; default = 1e-8{p_end}
{p2col:{opt non:ames}}suppresses test that row and column stripes match{p_end}
{p2col:{opt nol:ist}}suppresses listing matrices if not equal{p_end}
{p2line}
{p2colreset}{...}

{pstd}
These commands are intended for authors of certification
scripts -- do-files used to test that commands work properly; 
see {manhelp cscript P}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:_assert_mreldif} assert that the matrices {it:matexp1} and 
{it:matexp2} are the same within tolerance {cmd:tol()}.  

{pstd}
{cmd:_assert_mreldifs} asserts that the columns of the matrices 
{it:matexp1} and {it:matexp2} are the same within tolerance 
{cmd:tol()}, up to the columnwise signs.  Comparing matrices of 
eigenvectors or singular vectors is an example in which a test 
of equality up to the column sign is appropriate. 

{pstd}
{cmd:_assert_mreldifp} asserts that the two matrices are conformable 
and span the same linear subspaces, comparing the orthonormal 
projections on these subspaces. 

{pstd}
These commands allow matrix expressions.  Be sure to use 
quoted expressions or expressions without white space. 

{pstd}
All comparisons involve {helpb mreldif()}, and hence do not treat the first 
and second argument symmetrically.  


{marker options}{...}
{title:Options}

{phang}{opt tol(#)}
specifies the tolerance for {help mreldif():mreldif}-testing 
of differences in the matrix elements.  The default is 1e-8.

{phang}{opt nolist}
suppresses the listing of the matrices if the equality test fails.

{phang}{opt nonames}
suppresses the verification that the row and column stripes 
match.  If the test fails, the offending stripes are shown.


{marker example}{...}
{title:Example}

{cmd}{...}
    matrix D = (2+(1e-10), 1-(1e-10), 1e-10)
    matrix D = diag(D)
    matrix symeigen U V = D

    matrix input T_U = ( 1, 0, 0 \ 0, 1, 0 \ 0, 0, 1 )
    matrix input T_V = ( 2.0000000001, .9999999999, 1.00000000000e-10 )

    // V and T_V should be the same (within tolerance)
    _assert_mreldif  V T_V

    // test equality of U and T_U up to columnwise change of signs

    _assert_mreldifs U T_U
    _assert_mreldifs U T_U, tol(1e-6)
    _assert_mreldifs U T_U, tol(1e-6) nonames
{txt}{...}
