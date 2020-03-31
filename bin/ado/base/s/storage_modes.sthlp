{smcl}
{* *! version 1.0.6  11feb2011}{...}
{vieweralsosee "[D] corr2data" "help corr2data"}{...}
{vieweralsosee "[D] drawnorm" "help drawnorm"}{...}
{vieweralsosee "[MV] factor" "help factormat"}{...}
{vieweralsosee "[P] matrix define" "help matrix_define"}{...}
{vieweralsosee "[MV] pca" "help pcamat"}{...}
{title:Title}

{p2colset 5 22 24 2}{...}
{p2col :{hi:storage modes} {hline 2}}Storage modes for correlation and covariance matrices{p_end}
{p2colreset}{...}


{title:Description}

{pstd}
The three storage modes for specifying the correlation or covariance matrix
in {helpb corr2data} and {helpb drawnorm} will be illustrated with a correlation
structure {cmd:C} of 4 variables.  In {cmd:full} storage model, this structure
can be entered as a {bind:4x4} Stata matrix:

{space 8}{cmd:. matrix C = ( 1.0000,  0.3232,  0.1112,  0.0066 \ ///}
{space 23}{cmd:0.3232,  1.0000,  0.6608, -0.1572 \ ///}
{space 23}{cmd:0.1112,  0.6608,  1.0000, -0.1480 \ ///}
{space 23}{cmd:0.0066, -0.1572, -0.1480,  1.0000 )}

{pstd}
Elements within a row are separated by commas, and rows are separated by a
backslash {cmd:\}.  We use the input continuation operator {cmd:///} for
convenient multiline input; see {manhelp comments P}.  In this storage mode,
you probably want to set the row and column names to the variables:

{p 8 23 2}{cmd:. matrix rownames C = price trunk headroom rep78}{p_end}
{p 8 23 2}{cmd:. matrix colnames C = price trunk headroom rep78}{p_end}

{pstd}
This correlation structure can be entered more conveniently in one of the two
vectorized storage modes.  In these modes, you enter the lower triangle or the
upper triangle of {cmd:C} in rowwise order; these two storage modes differ
only in the order in which the k(k+1)/2 matrix elements are recorded.
The {cmd:lower} storage mode for {cmd:C} is comprised of a vector with
4(4+1)/2=10 elements, that is, a 1x10 or 10x1 Stata matrix, with one row or
column,

{space 8}{cmd:. matrix C = ( 1.0000,  ///}
{space 23}{cmd:0.3232,  1.0000,  ///}
{space 23}{cmd:0.1112,  0.6608,  1.0000, ///}
{space 23}{cmd:0.0066, -0.1572, -0.1480,  1.0000 )}

{pstd}
or more compactly as

{p 8 23 2}
{cmd:. matrix C = ( 1, 0.3232, 1, 0.1112, 0.6608, 1, 0.0066, -0.1572, -0.1480, 1 )}

{pstd}
As an alternative vectorization, {cmd:C} may be entered in {cmd:upper}
storage mode as a vector with 4(4+1)/2=10 elements, that is, a 1x10 or
10x1 Stata matrix,

{space 8}{cmd:. matrix C = ( 1.0000,  0.3232,  0.1112,  0.0066, ///}
{space 23}{cmd:         1.0000,  0.6608, -0.1572, ///}
{space 23}{cmd:                  1.0000, -0.1480, ///}
{space 23}{cmd:                           1.0000 )}

{pstd}
or more compactly as

{p 8 23 2}
{cmd:. matrix C = ( 1, 0.3232, 0.1112, 0.0066, 1, 0.6608, -0.1572, 1, -0.1480, 1 )}
{p_end}
