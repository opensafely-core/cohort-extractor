{smcl}
{* *! version 2.5.5  29apr2019}{...}
{* full list not included in manual}{...}
{vieweralsosee "[M-5] Intro" "mansection M-5 Intro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Intro" "help m4_intro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-0] Intro" "help mata"}{...}
{viewerjumpto "A" "m5_intro##A"}{...}
{viewerjumpto "B" "m5_intro##B"}{...}
{viewerjumpto "C" "m5_intro##C"}{...}
{viewerjumpto "D" "m5_intro##D"}{...}
{viewerjumpto "E" "m5_intro##E"}{...}
{viewerjumpto "F" "m5_intro##F"}{...}
{viewerjumpto "G" "m5_intro##G"}{...}
{viewerjumpto "H" "m5_intro##H"}{...}
{viewerjumpto "I" "m5_intro##I"}{...}
{viewerjumpto "J" "m5_intro##J"}{...}
{viewerjumpto "K" "m5_intro##K"}{...}
{viewerjumpto "L" "m5_intro##L"}{...}
{viewerjumpto "M" "m5_intro##M"}{...}
{viewerjumpto "N" "m5_intro##N"}{...}
{viewerjumpto "O" "m5_intro##O"}{...}
{viewerjumpto "P" "m5_intro##P"}{...}
{viewerjumpto "Q" "m5_intro##Q"}{...}
{viewerjumpto "R" "m5_intro##R"}{...}
{viewerjumpto "S" "m5_intro##S"}{...}
{viewerjumpto "T" "m5_intro##T"}{...}
{viewerjumpto "U" "m5_intro##U"}{...}
{viewerjumpto "V" "m5_intro##V"}{...}
{viewerjumpto "W" "m5_intro##W"}{...}
{viewerjumpto "X" "m5_intro##X"}{...}
{viewerjumpto "Y" "m5_intro##Y"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[M-5] Intro} {hline 2}}Alphabetical index to Mata functions
{p_end}
{p2col:}({mansection M-5 Intro:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{title:Contents}

{pstd}
A topical index of all Mata functions is available in
{bf:{help m4_intro:[M-4] Intro}}.  All Mata functions are documented
alphabetically in the {it:Mata Reference Manual}.

{pstd}
Here is the alphabetical list:

{col 5}{hline}
{p2colset 5 32 34 2}
{marker A}{...}
{p2col:{bf:{help mf_abbrev:abbrev()}}}abbreviate strings{p_end}
{p2col:{bf:{help mf_abs:abs()}}}absolute value (length if complex){p_end}
{p2col:{bf:{help mf_sin:acos()}}}arccosine{p_end}
{p2col:{bf:{help mf_sin:acosh()}}}inverse hyperbolic cosine{p_end}
{p2col 4 32 34 2:*{bf:{help mf_st_lchar:ado_fromlchar()}}}store a long characteristic in a local macro{p_end}
{p2col 4 32 34 2:*{bf:{help mf_st_lchar:ado_intolchar()}}}store contents of a local macro in a long characteristic{p_end}
{p2col:{bf:{help mf_adosubdir:adosubdir()}}}ado-subdirectory for file{p_end}
{p2col:{bf:{help mf_all:all()}}}{cmd:sum(!}{it:L}{cmd:)==0} for fast elementwise comparisons{p_end}
{p2col:{bf:{help mf_all:allof()}}}{cmd:all(}{it:P}{cmd::==}{it:s}{cmd:)} for fast elementwise comparisons{p_end}
{p2col:{bf:{help mf_all:any()}}}{cmd:sum(}{it:L}{cmd:)!=0} for fast elementwise comparisons{p_end}
{p2col:{bf:{help mf_all:anyof()}}}{cmd:any(}{it:P}{cmd::==}{it:s}{cmd:)} for fast elementwise comparisons{p_end}
{p2col 4 32 34 2:*{bf:{help mf_arfimaacf:arfimaacf()}}}autocovariance function of an ARFIMA or ARMA process{p_end}
{p2col 4 32 34 2:*{bf:{help mf_arfimapsdensity:arfimapsdensity()}}}parametric spectral density of an ARFIMA or ARMA process{p_end}
{p2col:{bf:{help mf_sin:arg()}}}{cmd:atan2(Re(), Im())}{p_end}
{p2col:{bf:{help mf_args:args()}}}number of arguments passed to a function{p_end}
{p2col:{bf:{help mf_asarray:asarray()}}}store or retrieve element in array{p_end}
{p2col:{bf:{help mf_asarray:asarray_*()}}}utility routines{p_end}
{p2col:{bf:{help mf_ascii:ascii()}}}row vector of ASCII and extended ASCII codes of characters in a string{p_end}
{p2col:{bf:{help mf_associativearray:AssociativeArray()}}}class-based
interface into the associative arrays provided by {helpb mf_asarray:asarray()}{p_end}
{p2col:{bf:{help mf_sin:asin()}}}arcsine{p_end}
{p2col:{bf:{help mf_sin:asinh()}}}inverse hyperbolic sine{p_end}
{p2col:{bf:{help mf_assert:assert()}}}abort execution if not true{p_end}
{p2col:{bf:{help mf_assert:asserteq()}}}abort execution if not equal{p_end}
{p2col:{bf:{help mf_sin:atan()}}}arctangent{p_end}
{p2col:{bf:{help mf_sin:atan2()}}}two-argument arctangent{p_end}
{p2col:{bf:{help mf_sin:atanh()}}}inverse hyperbolic tangent{p_end}

{col 5}{hline}

{marker B}{...}
{p2col:{bf:{help mf_normal:betaden()}}}beta density{p_end}
{p2col:{bf:{help mf_normal:binomial()}}}cumulative binomial (k or fewer successes){p_end}
{p2col:{bf:{help mf_normal:binomialp()}}}binomial probability mass function{p_end}
{p2col:{bf:{help mf_normal:binomialtail()}}}reverse cumulative binomial (k or more successes){p_end}
{p2col:{bf:{help mf_normal:binormal()}}}cumulative bivariate normal distribution{p_end}
{p2col:{bf:{help mf_blockdiag:blockdiag()}}}block-diagonal matrix from arguments {...}{p_end}
{p2col:{bf:{help mf_date:bofd()}}}convert {cmd:%td} datetime to {cmd:%tb} business date{p_end}
{p2col:{bf:{help mf_setbreakintr:breakkey()}}}whether break key has been pressed{p_end}
{p2col:{bf:{help mf_setbreakintr:breakkeyreset()}}}reset break key{p_end}
{p2col:{bf:{help mf_bufio:bufbfmtisnum()}}}whether binary format is numeric in buffered, binary I/0{p_end}
{p2col:{bf:{help mf_bufio:bufbfmtlen()}}}length of binary format in buffered, binary I/0{p_end}
{p2col:{bf:{help mf_bufio:bufbyteorder()}}}change byte order for buffered, binary I/O{p_end}
{p2col:{bf:{help mf_bufio:bufget()}}}copy from buffer in buffered, binary I/O{p_end}
{p2col:{bf:{help mf_bufio:bufio()}}}initialize buffer in buffered, binary I/O{p_end}
{p2col:{bf:{help mf_bufio:bufmissingvalue()}}}change missing-value encoding in buffered, binary I/O{p_end}
{p2col:{bf:{help mf_bufio:bufput()}}}copy into buffer in buffered, binary I/O{p_end}
{p2col:{bf:{help mf_byteorder:byteorder()}}}byte order used by computer{p_end}

{col 5}{hline}

{marker C}{...}
{p2col:{bf:{help mf_c:C()}}}complex value of argument{p_end}
{p2col:{bf:{help mf_c_lc:c()}}}c-class value{p_end}
{p2col:{bf:{help mf_callersversion:callersversion()}}}version set by the caller{p_end}
{p2col:{bf:{help mf_cat:cat()}}}string column vector containing the lines of an ASCII file{p_end}
{p2col:{bf:{help mf_normal:cauchy()}}}cumulative Cauchy distribution{p_end}
{p2col:{bf:{help mf_normal:cauchyden()}}}Cauchy density{p_end}
{p2col:{bf:{help mf_normal:cauchytail()}}}1 minus cumulative Cauchy distribution{p_end}
{p2col:{bf:{help mf_date:Cdhms()}}}{cmd:%tC} value from {cmd:%td} value, hour, minute, second{p_end}
{p2col:{bf:{help mf_trunc:ceil()}}}round up to integer{p_end}
{p2col:{bf:{help mf_ascii:char()}}}string from a row vector of ASCII codes{p_end}
{p2col:{bf:{help mf_chdir:chdir()}}}change current working directory{p_end}
{p2col:{bf:{help mf_normal:chi2()}}}cumulative chi-squared distribution{p_end}
{p2col:{bf:{help mf_normal:chi2den()}}}chi-squared density{p_end}
{p2col:{bf:{help mf_normal:chi2tail()}}}1 minus cumulative chi-squared distribution{p_end}
{p2col:{bf:{help mf_date:Chms()}}}{cmd:%tC} value from hour, minute, second{p_end}
{p2col:{bf:{help mf_cholesky:cholesky()}}}Cholesky square-root decomposition {it:A}={it:GG}{bf:'}{p_end}
{p2col:{bf:{help mf_cholinv:cholinv()}}}inverse of symmetric (Hermitian), positive-definite matrix {p_end}
{p2col:{bf:{help mf_cholsolve:cholsolve()}}}solution to linear system with symmetric (Hermitian) positive-definite 
	coefficient matrix{p_end}
{p2col:{bf:{help mf_eltype:classname()}}}class name of a Mata class scalar{p_end}
{p2col:{bf:{help mf_date:Clock()}}}{cmd:%tC} value from string{p_end}
{p2col:{bf:{help mf_date:clock()}}}{cmd:%tc} value from string{p_end}
{p2col:{bf:{help mf_logit:cloglog()}}}complementary log-log{p_end}
{p2col:{bf:{help mf_date:Cmdyhms()}}}{cmd:%tC} value from month, day, year, hour minute, and second{p_end}
{p2col:{bf:{help mf_date:Cofc()}}}{cmd:%tC} value from {cmd:%tc} value{p_end}
{p2col:{bf:{help mf_date:cofC()}}}{cmd:%tc} value from {cmd:%tC} value{p_end}
{p2col:{bf:{help mf_date:Cofd()}}}{cmd:%tC} value from {cmd:%td} value{p_end}
{p2col:{bf:{help mf_date:cofd()}}}{cmd:%tc} value from {cmd:%td} value{p_end}
{p2col:{bf:{help mf_sort:_collate()}}}order matrix on permutation vector{p_end}
{p2col:{bf:{help mf_minmax:colmax()}}}row vector of columns' maximums {p_end}
{p2col:{bf:{help mf_minmax:colmaxabs()}}}{cmd:colmax(abs())}{p_end}
{p2col:{bf:{help mf_minmax:colmin()}}}row vector of columns' minimums{p_end}
{p2col:{bf:{help mf_minmax:colminmax()}}}matrix of columns' minimums and maximums{p_end}
{p2col:{bf:{help mf_missing:colmissing()}}}row vector of counts of columns' missing values{p_end}
{p2col:{bf:{help mf_missing:colnonmissing()}}}row vector of counts of columns' nonmissing values{p_end}
{p2col:{bf:{help mf_rows:cols()}}}number of columns{p_end}
{p2col:{bf:{help mf__equilrc:colscalefactors()}}}row vector of column-scaling factors for equilibration{p_end}
{p2col:{bf:{help mf_rowshape:colshape()}}}reshape matrix to have specified number of columns{p_end}
{p2col:{bf:{help mf_sum:colsum()}}}row vector of columns' sums{p_end}
{p2col:{bf:{help mf_comb:comb()}}}combinatorial function {it:n} choose {it:k}{p_end}
{p2col:{bf:{help mf_cond:cond()}}}matrix condition number {...}{p_end}
{p2col:{bf:{help mf_conj:conj()}}}complex conjugate{p_end}
{p2col:{bf:{help mf_conj:_conj()}}}replace {it:A} with {cmd:conj(}{it:A}{cmd:)}{p_end}
{p2col:{bf:{help mf_fft:convolve()}}}convolution of a signal and response function{p_end}
{p2col:{bf:{help mf_fft:Corr()}}}correlations in signal-processing sense{p_end}
{p2col:{bf:{help mf_corr:corr()}}}correlation matrix from variance matrix{p_end}
{p2col:{bf:{help mf_mean:correlation()}}}correlation matrix from data matrix{p_end}
{p2col:{bf:{help mf_sin:cos()}}}cosine{p_end}
{p2col:{bf:{help mf_sin:cosh()}}}hyperbolic cosine{p_end}
{p2col:{bf:{help mf_findexternal:crexternal()}}}create external global{p_end}
{p2col:{bf:{help mf_cross:cross()}}}{it:X}'{it:X}, {it:X}'{it:Z}, etc.{p_end}
{p2col:{bf:{help mf_crossdev:crossdev()}}}({it:X}:-{it:x})'({it:X}:-{it:x}), ({it:X}:-{it:x})'({it:Z}:-{it:z}), etc.{p_end}
{p2col:{bf:{help mf_cvpermute:cvpermute()}}}permutations of a column vector{p_end}
{p2col:{bf:{help mf_cvpermute:cvpermutesetup()}}}perform setup to compute permutation of a column vector{p_end}

{col 5}{hline}

{marker D}{...}
{p2col:{bf:{help mf_date:date()}}}{cmd:%td} value from string{p_end}
{p2col:{bf:{help mf_date:day()}}}day of month from {cmd:%td} value{p_end}
{p2col:{bf:{help mf_fft:deconvolve()}}}deconvolve smeared signal{p_end}
{p2col:{bf:{help mf_deriv:deriv()}}}numerical derivatives{p_end}
{p2col:{bf:{help mf_deriv:_deriv()}}}compute derivatives{p_end}
{p2col:{bf:{help mf_deriv:deriv_init()}}}begin derivatives{p_end}
{p2col:{bf:{help mf_deriv:deriv_init_*()}}}set details{p_end}
{p2col:{bf:{help mf_deriv:deriv_query()}}}report derivatives{p_end}
{p2col:{bf:{help mf_deriv:deriv_result_*()}}}access results{p_end}
{p2col:{bf:{help mf_designmatrix:designmatrix()}}}design matrix from row and column vectors of zeros and ones{p_end}
{p2col:{bf:{help mf_det:det()}}}determinant of a matrix{p_end}
{p2col:{bf:{help mf_det:dettriangular()}}}determinant of triangular matrix{p_end}
{p2col:{bf:{help mf_normal:dgammapda()}}}derivative of cumulative gamma distribution, {cmd:gammap(}{it:a},{it:x}{cmd:)},
	with respect to {it:a}{p_end}
{p2col:{bf:{help mf_normal:dgammapdada()}}}second derivative of cumulative gamma distribution, 
	{cmd:gammap(}{it:a},{it:x}{cmd:)}, with respect to {it:a}{p_end}
{p2col:{bf:{help mf_normal:dgammapdadx()}}}second derivative of cumulative gamma distribution, 
	{cmd:gammap(}{it:a},{it:x}{cmd:)}, with respect to {it:a} and {it:x}{p_end}
{p2col:{bf:{help mf_normal:dgammapdx()}}}derivative of cumulative gamma distribution, {cmd:gammap(}{it:a},{it:x}{cmd:)},
	with respect to {it:x}{p_end}
{p2col:{bf:{help mf_normal:dgammapdxdx()}}}second derivative of cumulative gamma distribution, 
	{cmd:gammap(}{it:a},{it:x}{cmd:)}, with respect to {it:x}{p_end}
{p2col:{bf:{help mf_date:dhms()}}}{cmd:%tc} value from {cmd:%td} value, hour, minute, second{p_end}
{p2col:{bf:{help mf_diag:diag()}}}create diagonal matrix{p_end}
{p2col:{bf:{help mf__diag:_diag()}}}replace diagonal of a matrix{p_end}
{p2col:{bf:{help mf_diag0cnt:diag0cnt()}}}count of zeros on principal diagonal{p_end}
{p2col:{bf:{help mf_diagonal:diagonal()}}}column vector containing diagonal of matrix{p_end}
{p2col:{bf:{help mf_factorial:digamma()}}}derivative of {cmd:lngamma()}{p_end}
{p2col:{bf:{help mf_dir:dir()}}}string column vector containing files in a directory that match a pattern{p_end}
{p2col:{bf:{help mf_direxists:direxists()}}}whether directory exists{p_end}
{p2col:{bf:{help mf_direxternal:direxternal()}}}column vector containing names of external globals that match a pattern{p_end}
{p2col:{bf:{help mf_display:display()}}}display SMCL augmented text {p_end}
{p2col:{bf:{help mf_displayas:displayas()}}}set whether and how output is displayed{p_end}
{p2col:{bf:{help mf_displayflush:displayflush()}}}flush terminal-output buffer{p_end}
{p2col:{bf:{help mf_dmatrix:Dmatrix()}}}duplication matrix{p_end}
{p2col:{bf:{help mf__docx:_docx*()}}}generate Office Open XML files{p_end}
{p2col:{bf:{help mf_date:dofb()}}}convert {cmd:%tb} business date to {cmd:%td} datetime{p_end}
{p2col:{bf:{help mf_date:dofc()}}}{cmd:%td} value from {cmd:%tc} value{p_end}
{p2col:{bf:{help mf_date:dofC()}}}{cmd:%td} value from {cmd:%tC} value{p_end}
{p2col:{bf:{help mf_date:dofh()}}}{cmd:%td} value from {cmd:%th} value{p_end}
{p2col:{bf:{help mf_date:dofm()}}}{cmd:%td} value from {cmd:%tm} value{p_end}
{p2col:{bf:{help mf_date:dofq()}}}{cmd:%td} value from {cmd:%tq} value{p_end}
{p2col:{bf:{help mf_date:dofw()}}}{cmd:%td} value from {cmd:%tw} value{p_end}
{p2col:{bf:{help mf_date:dofy()}}}{cmd:%td} value from {cmd:%ty} value{p_end}
{p2col:{bf:{help mf_date:dow()}}}day-of-week from {cmd:%td} value{p_end}
{p2col:{bf:{help mf_date:doy()}}}day-of-year from {cmd:%td} value{p_end}
{p2col:{bf:{help mf_dsign:dsign()}}}FORTRAN-like DSIGN function{p_end}
{p2col:{bf:{help mf_normal:dunnettprob()}}}Dunnett multiple range distribution{p_end}

{col 5}{hline}

{marker E}{...}
{p2col:{bf:{help mf_e:e()}}}unit vectors {...}{p_end}
{p2col:{bf:{help mf_editmissing:editmissing()}}}replace missing values in matrix{p_end}
{p2col:{bf:{help mf_edittoint:edittoint()}}}matrix with near integers rounded to integers{p_end}
{p2col:{bf:{help mf_edittoint:edittointtol()}}}matrix with near integers rounded to integers, using 
		absolute tolerance{p_end}
{p2col:{bf:{help mf_edittozero:edittozero()}}}matrix with near zeros rounded to zeros{p_end}
{p2col:{bf:{help mf_edittozero:edittozerotol()}}}matrix with near zeros rounded to zeros, using
		absolute tolerance{p_end}
{p2col:{bf:{help mf_editvalue:editvalue()}}}matrix with {it:from} values replaced by {it:to} values{p_end}
{p2col:{bf:{help mf_eigensystem:eigensystem()}}}eigenvectors and eigenvalues{p_end}
{p2col:{bf:{help mf_eigensystemselect:_eigensystemselect_la()}}}interface to {manhelp mf_lapack M-5:lapack()}; direct use not recommended{p_end}
{p2col:{bf:{help mf_eigensystemselect:eigensystemselectf()}}}right eigenvectors and eigenvalues selected by community-contributed function{p_end}
{p2col:{bf:{help mf_eigensystemselect:_eigensystemselectf_la()}}}interface to {manhelp mf_lapack M-5:lapack()}; direct use not recommended{p_end}
{p2col:{bf:{help mf_eigensystemselect:eigensystemselecti()}}}right eigenvectors and eigenvalues selected by index{p_end}
{p2col:{bf:{help mf_eigensystemselect:_eigensystemselecti_la()}}}interface to {manhelp mf_lapack M-5:lapack()}; direct use not recommended{p_end}
{p2col:{bf:{help mf_eigensystemselect:eigensystemselectr()}}}right eigenvectors and eigenvalues selected by range{p_end}
{p2col:{bf:{help mf_eigensystemselect:_eigensystemselectr_la()}}}interface to {manhelp mf_lapack M-5:lapack()}; direct use not recommended{p_end}
{p2col:{bf:{help mf_eigensystem:eigenvalues()}}}eigenvalues{p_end}
{p2col:{bf:{help mf_eltype:eltype()}}}element type of object{p_end}
{p2col:{bf:{help mf_epsilon:epsilon()}}}unit roundoff error{p_end}
{p2col:{bf:{help mf__equilrc:_equilc()}}}perform column equilibration{p_end}
{p2col:{bf:{help mf__equilrc:_equilr()}}}perform row equilibration{p_end}
{p2col:{bf:{help mf__equilrc:_equilrc()}}}perform row and column equilibration{p_end}
{p2col:{bf:{help mf_error:error()}}}issue standard Stata error message{p_end}
{p2col:{bf:{help mf_error:_error()}}}issue error message with traceback log{p_end}
{p2col:{bf:{help mf_errprintf:errprintf()}}}display error message{p_end}
{p2col:{bf:{help mf_exit:exit()}}}terminate execution{p_end}
{p2col:{bf:{help mf_exp:exp()}}}elementwise exponentiation of input matrix{p_end}
{p2col:{bf:{help mf_expm1:expm1()}}}elementwise exponentiation minus 1{p_end}
{p2col:{bf:{help mf_normal:exponential()}}}cumulative exponential{p_end}
{p2col:{bf:{help mf_normal:exponentialden()}}}exponential density{p_end}
{p2col:{bf:{help mf_normal:exponentialtail()}}}reverse cumulative exponential{p_end}

{col 5}{hline}

{marker F}{...}
{p2col:{bf:{help mf_normal:F()}}}cumulative F distribution{p_end}
{p2col:{bf:{help mf_factorial:factorial()}}}elementwise factorial of input matrix{p_end}
{p2col 4 32 34 2:*{bf:{help mf__factorsym:_factorsym()}}}factor a symmetric nonnegative-definite matrix{p_end}
{p2col:{bf:{help mf_favorspeed:favorspeed()}}}whether speed or space is to be favored{p_end}
{p2col:{bf:{help mf_bufio:fbufget()}}}read and copy from buffer in buffered, binary I/O{p_end}
{p2col:{bf:{help mf_bufio:fbufput()}}}copy into and write buffer in buffered, binary I/O{p_end}
{p2col:{bf:{help mf_fopen:fclose()}}}close file{p_end}
{p2col:{bf:{help mf_normal:Fden()}}}F density{p_end}
{p2col:{bf:{help mf_ferrortext:ferrortext()}}}error text of file-error code{p_end}
{p2col:{bf:{help mf_fft:fft()}}}fast Fourier transform{p_end}
{p2col:{bf:{help mf_fopen:fget()}}}real scalar containing line of ASCII file{p_end}
{p2col:{bf:{help mf_fopen:fgetmatrix()}}}read matrix{p_end}
{p2col:{bf:{help mf_fopen:fgetnl()}}}same as {cmd:fget()}, but include newline character{p_end}
{p2col:{bf:{help mf_fileexists:fileexists()}}}whether file exists{p_end}
{p2col:{bf:{help mf__fillmissing:_fillmissing()}}}change matrix to contain missing values{p_end}
{p2col:{bf:{help mf_findexternal:findexternal()}}}find external global{p_end}
{p2col:{bf:{help mf_findfile:findfile()}}}string scalar containing path and file name of find sought{p_end}
{p2col:{bf:{help mf_floatround:floatround()}}}matrix rounded to float precision{p_end}
{p2col:{bf:{help mf_trunc:floor()}}}matrix rounded down to integer{p_end}
{p2col:{bf:{help mf_lapack:_flopin()}}}convert matrix order from row major to column major{p_end}
{p2col:{bf:{help mf_lapack:_flopout()}}}convert matrix order from column major to row major{p_end}
{p2col:{bf:{help mf_fmtwidth:fmtwidth()}}}width of {cmd:%}{it:fmt}{p_end}
{p2col:{bf:{help mf_fopen:fopen()}}}open file{p_end}
{p2col:{bf:{help mf_fopen:fput()}}}write line into ASCII file{p_end}
{p2col:{bf:{help mf_fopen:fputmatrix()}}}write matrix{p_end}
{p2col:{bf:{help mf_fopen:fread()}}}read {it:k} bytes of binary file{p_end}
{p2col:{bf:{help mf_ferrortext:freturncode()}}}return code of file-error code{p_end}
{p2col:{bf:{help mf_inbase:frombase()}}}real matrix from input matrix in a specified base{p_end}
{p2col:{bf:{help mf_fopen:fseek()}}}seek to location in file{p_end}
{p2col:{bf:{help mf_fopen:fstatus()}}}status of last I/O command{p_end}
{p2col:{bf:{help mf_normal:Ftail()}}}1 minus cumulative F distribution{p_end}
{p2col:{bf:{help mf_fopen:ftell()}}}report location in file{p_end}
{p2col:{bf:{help mf_fft:ftfreqs()}}}Fourier frequencies associated with elements of transform{p_end}
{p2col:{bf:{help mf_fft:ftpad()}}}vector padded to power-of-2 length for fast Fourier transform{p_end}
{p2col:{bf:{help mf_fft:ftperiodogram()}}}real vector containing one-sided periodogram of Fourier transform{p_end}
{p2col:{bf:{help mf_fft:ftretime()}}}numeric vector containing (FFT) signal retimed to match convolution{p_end}
{p2col:{bf:{help mf_fopen:ftruncate()}}}truncate file at current position{p_end}
{p2col:{bf:{help mf_fft:ftunwrap()}}}convert from frequency-wraparound order{p_end}
{p2col:{bf:{help mf_fft:ftwrap()}}}numeric vector containing frequency-wraparound order of Fourier transform{p_end}
{p2col:{bf:{help mf_fullsvd:fullsdiag()}}}diagonal matrix made from column vector of singular values{p_end}
{p2col:{bf:{help mf_fullsvd:fullsvd()}}}perform singular value decomposition {it:A} = {it:USV}{bf:'}{p_end}
{p2col:{bf:{help mf_fopen:fwrite()}}}write {it:k} bytes into a file{p_end}

{col 5}{hline}

{marker G}{...}
{p2col:{bf:{help mf_factorial:gamma()}}}gamma function{p_end}
{p2col:{bf:{help mf_normal:gammaden()}}}gamma density{p_end}
{p2col:{bf:{help mf_normal:gammap()}}}cumulative gamma distribution;     a.k.a. incomplete gamma function{p_end}
{p2col:{bf:{help mf_normal:gammaptail()}}}1 minus cumulative gamma distribution{p_end}
{p2col 4 32 34 2:*{bf:{help mf__gauss_hermite_nodes:_gauss_hermite_nodes()}}}Gauss-Hermite quadrature{p_end}
{p2col:{bf:{help mf_geigensystem:_geigen_la()}}}interface to {manhelp mf_lapack M-5:lapack()}; direct use not recommended{p_end}
{p2col:{bf:{help mf_geigensystem:_geigenselectf_la()}}}interface to {manhelp mf_lapack M-5:lapack()}; direct use not recommended{p_end}
{p2col:{bf:{help mf_geigensystem:_geigenselecti_la()}}}interface to {manhelp mf_lapack M-5:lapack()}; direct use not recommended{p_end}
{p2col:{bf:{help mf_geigensystem:_geigenselectr_la()}}}interface to {manhelp mf_lapack M-5:lapack()}; direct use not recommended{p_end}
{p2col:{bf:{help mf_geigensystem:geigensystem()}}}generalized eigenvectors and eigenvalues{p_end}
{p2col:{bf:{help mf_geigensystem:_geigensystem_la()}}}interface to {manhelp mf_lapack M-5:lapack()}; direct use not recommended{p_end}
{p2col:{bf:{help mf_geigensystem:geigensystemselectf()}}}right gen. eigenvectors and eigenvalues selected by community-contributed function{p_end}
{p2col:{bf:{help mf_geigensystem:geigensystemselecti()}}}right gen. eigenvectors and eigenvalues selected by index{p_end}
{p2col:{bf:{help mf_geigensystem:geigensystemselectr()}}}right gen. eigenvectors and eigenvalues selected by range{p_end}
{p2col:{bf:{help mf_halton:ghalton()}}}real matrix containing generalized-Halton sequence{p_end}
{p2col:{bf:{help mf_ghessenbergd:ghessenbergd()}}}generalized Hessenberg decomposition{p_end}
{p2col:{bf:{help mf_ghk:ghk()}}}multivariate normal probability from GHK simulator{p_end}
{p2col:{bf:{help mf_ghk:ghk_init()}}}initialize GHK simulator{p_end}
{p2col:{bf:{help mf_ghk:ghk_init_*()}}}set initialization details for GHK simulator{p_end}
{p2col:{bf:{help mf_ghk:ghk_query_npts()}}}return number of simulation points{p_end}
{p2col:{bf:{help mf_ghkfast:ghkfast()}}}faster, but more difficult version of {cmd:ghk()}{p_end}
{p2col:{bf:{help mf_ghkfast:ghkfast_init()}}}initialize fast GHK simulator{p_end}
{p2col:{bf:{help mf_ghkfast:ghkfast_init_*()}}}set initialization details for fast GHK simulator{p_end}
{p2col:{bf:{help mf_ghk:ghkfast_i()}}}probability and derivative for ith observation{p_end}
{p2col:{bf:{help mf_ghk:ghkfast_query_*()}}}return fast GHK simulator settings{p_end}
{p2col:{bf:{help mf_gschurd:gschurd()}}}gen. Schur decomposition and generalized eigenvalues{p_end}
{p2col:{bf:{help mf_gschurd:_gschurd()}}}gen. Schur decomposition{p_end}
{p2col:{bf:{help mf_gschurd:gschurdgroupby()}}}compute gen. Schur decomposition and generalized eigenvalues and group results according to specified condition{p_end}
{p2col:{bf:{help mf_gschurd:_gschurdgroupby()}}}compute gen. Schur decomposition and group results according to specified condition{p_end}

{col 5}{hline}

{marker H}{...}
{p2col:{bf:{help mf_date:halfyear()}}}half year from {cmd:%td} value{p_end}
{p2col:{bf:{help mf_date:halfyearly()}}}{cmd:%th} value from string{p_end}
{p2col:{bf:{help mf_halton:halton()}}}column vector containing a Halton or Hammersley set{p_end}
{p2col:{bf:{help mf_hash1:hash1()}}}Jenkins' one-at-a-time hash{p_end}
{p2col:{bf:{help mf_missing:hasmissing()}}}whether matrix has missing values{p_end}
{p2col:{bf:{help mf_hessenbergd:hessenbergd()}}}Hessenberg decomposition{p_end}
{p2col:{bf:{help mf_date:hh()}}}hour from {cmd:%tc} value{p_end}
{p2col:{bf:{help mf_date:hhC()}}}hour from {cmd:%tC} value{p_end}
{p2col:{bf:{help mf_hilbert:Hilbert()}}}Hilbert matrix{p_end}
{p2col:{bf:{help mf_date:hms()}}}{cmd:%tc} value from hour, minute, second{p_end}
{p2col:{bf:{help mf_date:hofd()}}}{cmd:%th} value from {cmd:%td} value{p_end}
{p2col:{bf:{help mf_date:hours()}}}hours from milliseconds{p_end}
{p2col:{bf:{help mf_qrd:hqrd()}}}perform QR decomposition; store {it:H}, {it:tau} and , {it:R1}{p_end}
{p2col:{bf:{help mf_qrd:hqrdmultq()}}}{it:QX} or {it:Q}{bf:'}{it:X} using {it:H} and {it:tau} from QR decomposition{p_end}
{p2col:{bf:{help mf_qrd:hqrdmultq1t()}}}{it:Q1}{bf:'}{it:X} using {it:H} and {it:tau} from QR decomposition{p_end}
{p2col:{bf:{help mf_qrd:hqrdp()}}}perform QR decomposition with pivoting; store {it:H}, {it:tau} and , {it:R1}{p_end}
{p2col:{bf:{help mf_qrd:hqrdq()}}}{it:Q} using {it:H} and {it:tau} from QR decomposition{p_end}
{p2col:{bf:{help mf_qrd:hqrdq1()}}}{it:Q1} using {it:H} and {it:tau} from QR decomposition{p_end}
{p2col:{bf:{help mf_qrd:hqrdr()}}}{it:R} using {it:H} from QR decomposition{p_end}
{p2col:{bf:{help mf_qrd:hqrdr1()}}}{it:R1} using {it:H} from QR decomposition{p_end}
{p2col:{bf:{help mf_normal:hypergeometric()}}}hypergeometric distribution function (cumulative){p_end}
{p2col:{bf:{help mf_normal:hypergeometricp()}}}hypergeometric probability mass function{p_end}

{col 5}{hline}

{marker I}{...}
{p2col:{bf:{help mf_i:I()}}}identity matrix {...}{p_end}
{p2col:{bf:{help mf_normal:ibeta()}}}cumulative beta distribution;     a.k.a. incomplete beta function{p_end}
{p2col:{bf:{help mf_normal:ibetatail()}}}1 minus cumulative beta distribution{p_end}
{p2col:{bf:{help mf_normal:igaussian()}}}cumulative of the inverse Gaussian distribution{p_end}
{p2col:{bf:{help mf_normal:igaussianden()}}}density of the inverse Gaussian distribution{p_end}
{p2col:{bf:{help mf_normal:igaussiantail()}}}1 minus the cumulative of the inverse Gaussian distribution{p_end}
{p2col:{bf:{help mf_re:Im()}}}imaginary part{p_end}
{p2col:{bf:{help mf_inbase:inbase()}}}string matrix containing conversion of real matrix to specified base{p_end}
{p2col:{bf:{help mf_indexnot:indexnot()}}}real matrix containing positions from elementwise comparisons of
first character in string1 not in string2{p_end}
{p2col:{bf:{help mf_normal:invbinomial()}}}inverse cumulative binomial distribution{p_end}
{p2col:{bf:{help mf_normal:invbinomialtail()}}}inverse reverse cumulative binomial {p_end}
{p2col:{bf:{help mf_normal:invcauchy()}}}inverse cumulative Cauchy{p_end}
{p2col:{bf:{help mf_normal:invcauchytail()}}}inverse upper-tail-cumulative Cauchy{p_end}
{p2col:{bf:{help mf_normal:invchi2()}}}inverse cumulative chi-squared{p_end}
{p2col:{bf:{help mf_normal:invchi2tail()}}}inverse upper-tail-cumulative chi-squared{p_end}
{p2col:{bf:{help mf_logit:invcloglog()}}}inverse complementary log-log{p_end}
{p2col:{bf:{help mf_normal:invdunnettprob()}}}inverse Dunnett multiple range distribution{p_end}
{p2col:{bf:{help mf_normal:invexponential()}}}inverse cumulative exponential{p_end}
{p2col:{bf:{help mf_normal:invexponentialtail()}}}inverse reverse cumulative exponential{p_end}
{p2col:{bf:{help mf_normal:invF()}}}inverse cumulative F{p_end}
{p2col:{bf:{help mf_fft:invfft()}}}inverse fast Fourier transform{p_end}
{p2col:{bf:{help mf_normal:invFtail()}}}inverse upper-tail-cumulative F{p_end}
{p2col:{bf:{help mf_normal:invgammap()}}}inverse cumulative gamma{p_end}
{p2col:{bf:{help mf_normal:invgammaptail()}}}inverse upper-tail-cumulative gamma{p_end}
{p2col:{bf:{help mf_hilbert:invHilbert()}}}inverse Hilbert matrix{p_end}
{p2col:{bf:{help mf_normal:invibeta()}}}inverse cumulative beta{p_end}
{p2col:{bf:{help mf_normal:invibetatail()}}}inverse upper-tail-cumulative beta{p_end}
{p2col:{bf:{help mf_normal:invigaussian()}}}inverse cumulative of the inverse Gaussian distribution{p_end}
{p2col:{bf:{help mf_normal:invigaussiantail()}}}inverse upper-tail-cumulative of the inverse Gaussian distribution{p_end}
{p2col:{bf:{help mf_normal:invlaplace()}}}inverse cumulative Laplace{p_end}
{p2col:{bf:{help mf_normal:invlaplacetail()}}}inverse reverse cumulative Laplace{p_end}
{p2col:{bf:{help mf_normal:invlogistic()}}}inverse cumulative logistic{p_end}
{p2col:{bf:{help mf_normal:invlogistictail()}}}inverse reverse cumulative logistic{p_end}
{p2col:{bf:{help mf_logit:invlogit()}}}inverse log of the odds ratio{p_end}
{p2col:{bf:{help mf_normal:invnbinomial()}}}inverse negative binomial distribution function{p_end}
{p2col:{bf:{help mf_normal:invnbinomialtail()}}}inverse upper-tail negative binomial distribution{p_end}
{p2col:{bf:{help mf_normal:invnchi2()}}}inverse cumulative noncentral chi-squared{p_end}
{p2col:{bf:{help mf_normal:invnchi2tail()}}}inverse upper-tail-cumulative noncentral chi-squared{p_end}
{p2col:{bf:{help mf_normal:invnF()}}}inverse cumulative noncentral F{p_end}
{p2col:{bf:{help mf_normal:invnFtail()}}}inverse upper-tail-cumulative noncentral F{p_end}
{p2col:{bf:{help mf_normal:invnibeta()}}}inverse cumulative noncentral beta{p_end}
{p2col:{bf:{help mf_normal:invnormal()}}}inverse cumulative normal{p_end}
{p2col:{bf:{help mf_normal:invnt()}}}inverse cumulative noncentral Student's t{p_end}
{p2col:{bf:{help mf_normal:invnttail()}}}inverse upper-tail-cumulative noncentral Student's t{p_end}
{p2col:{bf:{help mf_invorder:invorder()}}}inverse of permutation vector{p_end}
{p2col:{bf:{help mf_normal:invpoisson()}}}inverse Poisson distribution function{p_end}
{p2col:{bf:{help mf_normal:invpoissontail()}}}inverse upper-tail Poisson distribution{p_end}
{p2col:{bf:{help mf_invsym:invsym()}}}generalized inverse of real, positive-semidefinite, symmetric matrix{p_end}
{p2col:{bf:{help mf_normal:invt()}}}inverse cumulative Student's t{p_end}
{p2col:{bf:{help mf_invtokens:invtokens()}}}string scalar containing concatenated string-vector elements {p_end}
{p2col:{bf:{help mf_normal:invttail()}}}inverse upper-tail-cumulative Student's t{p_end}
{p2col:{bf:{help mf_normal:invtukeyprob()}}}inverse Tukey Studentized range distribution{p_end}
{p2col:{bf:{help mf_vec:invvech()}}}inverse {bf:{help mf_vec:vech()}}{p_end}
{p2col:{bf:{help mf_normal:invweibull()}}}inverse cumulative Weibull{p_end}
{p2col:{bf:{help mf_normal:invweibullph()}}}inverse cumulative Weibull PH{p_end}
{p2col:{bf:{help mf_normal:invweibullphtail()}}}inverse reverse cumulative Weibull PH{p_end}
{p2col:{bf:{help mf_normal:invweibulltail()}}}inverse reverse cumulative Weibull{p_end}
{p2col:{bf:{help mf_isascii:isascii()}}}whether string scalar contains only ASCII codes{p_end}
{p2col:{bf:{help mf_isreal:iscomplex()}}}whether object is complex matrix{p_end}
{p2col:{bf:{help mf_isdiagonal:isdiagonal()}}}whether matrix is diagonal{p_end}
{p2col:{bf:{help mf_isfleeting:isfleeting()}}}whether argument is temporary{p_end}
{p2col:{bf:{help mf_isreal:ispointer()}}}whether object is pointer matrix{p_end}
{p2col:{bf:{help mf_isreal:isreal()}}}whether object is real matrix{p_end}
{p2col:{bf:{help mf_isrealvalues:isrealvalues()}}}whether matrix contains real values only{p_end}
{p2col:{bf:{help mf_issamefile:issamefile()}}}whether two file paths point to the same file{p_end}
{p2col:{bf:{help mf_isreal:isstring()}}}whether object is string matrix{p_end}
{p2col:{bf:{help mf_issymmetric:issymmetric()}}}whether matrix is symmetric (Hermitian){p_end}
{p2col:{bf:{help mf_issymmetric:issymmetriconly()}}}whether object is mechanically symmetric{p_end}
{p2col:{bf:{help mf_isview:isview()}}}whether object is view matrix{p_end}

{col 5}{hline}

{marker J}{...}
{p2col:{bf:{help mf_j:J()}}}matrix of constants {...}{p_end}
{p2col:{bf:{help mf_sort:jumble()}}}randomize order of rows of matrix{p_end}

{col 5}{hline}

{marker K}{...}
{p2col:{bf:{help mf_kmatrix:Kmatrix()}}}commutation matrix{p_end}

{col 5}{hline}

{marker L}{...}
{p2col:{bf:{help mf_lapack:LA_*()}}}LAPACK functions{p_end}
{p2col:{bf:{help mf_normal:laplace()}}}cumulative Laplace distribution{p_end}
{p2col:{bf:{help mf_normal:laplaceden()}}}Laplace density{p_end}
{p2col:{bf:{help mf_normal:laplacetail()}}}1 minus cumulative Laplace distribution{p_end}
{p2col:{bf:{help mf_eigensystem:lefteigensystem()}}}left eigenvectors and eigenvalues {p_end}
{p2col:{bf:{help mf_eigensystemselect:lefteigensystemselectf()}}}left eigenvectors and eigenvalues selected by community-contributed function{p_end}
{p2col:{bf:{help mf_eigensystemselect:lefteigensystemselecti()}}}left eigenvectors and eigenvalues selected by index{p_end}
{p2col:{bf:{help mf_eigensystemselect:lefteigensystemselectr()}}}left eigenvectors and eigenvalues selected by range {p_end}
{p2col:{bf:{help mf_geigensystem:leftgeigensystem()}}}left gen. eigenvectors and eigenvalues{p_end}
{p2col:{bf:{help mf_geigensystem:leftgeigensystemselectf()}}}left gen. eigenvectors and eigenvalues selected by community-contributed function{p_end}
{p2col:{bf:{help mf_geigensystem:leftgeigensystemselecti()}}}left gen. eigenvectors and eigenvalues selected by index{p_end}
{p2col:{bf:{help mf_geigensystem:leftgeigensystemselectr()}}}left gen. eigenvectors and eigenvalues selected by range{p_end}
{p2col:{bf:{help mf_rows:length()}}}number of elements  in a matrix{p_end}
{p2col:{bf:{help mf_linearprogram:LinearProgram()}}}linear programming{p_end}
{p2col:{bf:{help mf_liststruct:liststruct()}}}list structure's contents{p_end}
{p2col:{bf:{help mf_lmatrix:Lmatrix()}}}elimination matrix{p_end}
{p2col:{bf:{help mf_exp:ln()}}}natural logarithm{p_end}
{p2col:{bf:{help mf_exp:ln1m()}}}natural logarithm of (1-{it:x}){p_end}
{p2col:{bf:{help mf_exp:ln1p()}}}natural logarithm of (1+{it:x}){p_end}
{p2col:{bf:{help mf_normal:lncauchyden()}}}natural logarithm of Cauchy density{p_end}
{p2col:{bf:{help mf_factorial:lnfactorial()}}}natural logarithm of factorial{p_end}
{p2col:{bf:{help mf_factorial:lngamma()}}}natural logarithm of gamma function{p_end}
{p2col:{bf:{help mf_normal:lnigammaden()}}}natural logarithm of the inverse gamma density{p_end}
{p2col:{bf:{help mf_normal:lnigaussianden()}}}natural logarithm of the inverse Gaussian density{p_end}
{p2col:{bf:{help mf_normal:lniwishartden()}}}natural logarithm of the inverse Wishart density{p_end}
{p2col:{bf:{help mf_normal:lnlaplaceden()}}}natural logarithm of Laplace density{p_end}
{p2col:{bf:{help mf___lnmvnormalden:__lnmvnormalden()}}}natural logarithm of the multivariate normal density{p_end}
{p2col:{bf:{help mf_normal:lnmvnormalden()}}}natural logarithm of the multivariate normal density{p_end}
{p2col:{bf:{help mf_normal:lnnormal()}}}natural logarithm of the cumulative normal distribution{p_end}
{p2col:{bf:{help mf_normal:lnnormalden()}}}natural logarithm of the normal density{p_end}
{p2col:{bf:{help mf_normal:lnwishartden()}}}natural logarithm of the Wishart density{p_end}
{p2col:{bf:{help mf_exp:log()}}}natural logarithm{p_end}
{p2col:{bf:{help mf_exp:log10()}}}base-10 logarithm{p_end}
{p2col:{bf:{help mf_exp:log1m()}}}natural logarithm of (1-{it:x}){p_end}
{p2col:{bf:{help mf_exp:log1p()}}}natural logarithm of (1+{it:x}){p_end}
{p2col:{bf:{help mf_normal:logistic()}}}cumulative logistic{p_end}
{p2col:{bf:{help mf_normal:logisticden()}}}logistic density{p_end}
{p2col:{bf:{help mf_normal:logistictail()}}}reverse cumulative logistic{p_end}
{p2col:{bf:{help mf_logit:logit()}}}natural log of the odds ratio{p_end}
{p2col:{bf:{help mf_lowertriangle:lowertriangle()}}}lower-triangular matrix from input matrix{p_end}
{p2col 4 32 34 2:*{bf:{help mf__lsfitqr:_lsfitqr()}}}least-squares regression using QR decomposition{p_end}
{p2col:{bf:{help mf_lud:lud()}}}LU decomposition {it:A} = {it:PLU}{p_end}
{p2col:{bf:{help mf_luinv:luinv()}}}inverse of real or complex matrix using LU decomposition{p_end}
{p2col:{bf:{help mf_lusolve:lusolve()}}}solution to linear system with real or complex coefficient matrix
	using LU decomposition{p_end}

{col 5}{hline}

{marker M}{...}
{p2col:{bf:{help mf_makesymmetric:makesymmetric()}}}symmetric (Hermitian) version of square matrix {p_end}
{p2col:{bf:{help mf_matexpsym:matexpsym()}}}matrix exponential of symmetric matrix{p_end}
{p2col:{bf:{help mf_matexpsym:matlogsym()}}}matrix logarithm of symmetric matrix{p_end}
{p2col:{bf:{help mf_matpowersym:matpowersym()}}}matrix power of symmetric matrix{p_end}
{p2col:{bf:{help mf_minmax:max()}}}overall maximum{p_end}
{p2col:{bf:{help mf_mindouble:maxdouble()}}}largest positive nonmissing value{p_end}
{p2col:{bf:{help mf_minindex:maxindex()}}}indices of k maximums{p_end}
{p2col:{bf:{help mf_date:mdy()}}}{cmd:%td} value from month, day, and year{p_end}
{p2col:{bf:{help mf_date:mdyhms()}}}{cmd:%tc} value from month, day, year, hour, minute, and second{p_end}
{p2col:{bf:{help mf_mean:mean()}}}row vector of columns' means{p_end}
{p2col:{bf:{help mf_mean:meanvariance()}}}matrix of columns' means and variances{p_end}
{p2col:{bf:{help mf_minmax:min()}}}overall minimum{p_end}
{p2col:{bf:{help mf_mindouble:mindouble()}}}largest negative, nonmissing value{p_end}
{p2col:{bf:{help mf_minindex:minindex()}}}indices of k minimums{p_end}
{p2col:{bf:{help mf_minmax:minmax()}}}overall minimum and maximum{p_end}
{p2col:{bf:{help mf_date:minutes()}}}minutes from milliseconds{p_end}
{p2col:{bf:{help mf_missing:missing()}}}count of missing values{p_end}
{p2col:{bf:{help mf_missingof:missingof()}}}appropriate missing value{p_end}
{p2col:{bf:{help mf_chdir:mkdir()}}}make new directory{p_end}
{p2col:{bf:{help mf_date:mm()}}}minute from {cmd:%tc} value{p_end}
{p2col:{bf:{help mf_date:mmC()}}}minute from {cmd:%tc} value{p_end}
{p2col:{bf:{help mf_mod:mod()}}}modulus{p_end}
{p2col:{bf:{help mf_date:mofd()}}}{cmd:%tm} value from {cmd:%td} value{p_end}
{p2col:{bf:{help mf_date:month()}}}month from {cmd:%td} value{p_end}
{p2col:{bf:{help mf_date:monthly()}}}{cmd:%tm} value from string{p_end}
{p2col:{bf:{help mf_moptimize:moptimize()}}}perform optimization{p_end}
{p2col:{bf:{help mf_moptimize:moptimize_ado_cleanup()}}}perform cleanup for Stata programs{p_end}
{p2col:{bf:{help mf_moptimize:moptimize_evaluate()}}}evaluate function at initial values{p_end}
{p2col:{bf:{help mf_moptimize:moptimize_init()}}}begin setup of optimization problem{p_end}
{p2col:{bf:{help mf_moptimize:moptimize_init_*()}}}set up optimization problem{p_end}
{p2col  4 32 34 2:*{bf:{help mf_moptimize_init_mlopts:moptimize_init_mlopts()}}}{cmd:ml} options
parser for {cmd:moptimize()}{p_end}
{p2col:{bf:{help mf_moptimize:moptimize_query()}}}display optimization settings{p_end}
{p2col:{bf:{help mf_moptimize:moptimize_result_*()}}}access {cmd:moptimize()} results{p_end}
{p2col:{bf:{help mf_moptimize:moptimize_util_*()}}}utility functions for writing evaluators and processing results{p_end}
{p2col:{bf:{help mf_more:more()}}}create --more-- condition{p_end}
{p2col:{bf:{help mf_reldif:mreldif()}}}maximum relative difference between
matrices{p_end}
{p2col:{bf:{help mf_reldif:mreldifre()}}}{cmd:mreldif(Re(}{it:X}{cmd:)},{it:X}{cmd:)}, distance from real{p_end}
{p2col:{bf:{help mf_reldif:mreldifsym()}}}{cmd:mreldif(}{it:X}',{it:X}{cmd:)}, distance from symmetric{p_end}
{p2col:{bf:{help mf_date:msofhours()}}}milliseconds from hours{p_end}
{p2col:{bf:{help mf_date:msofminutes()}}}milliseconds from minutes{p_end}
{p2col:{bf:{help mf_date:msofseconds()}}}milliseconds from seconds{p_end}
{p2col:{bf:{help mf_mvnormal:mvnormal()}}}multivariate normal probabilities
(correlation specified){p_end}
{p2col:{bf:{help mf_mvnormal:mvnormalcv()}}}multivariate normal probabilities
(covariance specified){p_end}
{p2col:{bf:{help mf_mvnormal:mvnormalqp()}}}{cmd:mvnormal()} with specified
quadrature points{p_end}
{p2col:{bf:{help mf_mvnormal:mvnormalcvqp()}}}{cmd:mvnormalcv()} with specified
quadrature points{p_end}
{p2col:{bf:{help mf_mvnormal:mvnormalderiv()}}}derivatives of
{cmd:mvnormal()}{p_end}
{p2col:{bf:{help mf_mvnormal:mvnormalcvderiv()}}}derivatives of
{cmd:mvnormalcv()}{p_end}
{p2col:{bf:{help mf_mvnormal:mvnormaldervqp()}}}{cmd:mvnormalderiv()} with
specified quadrature points{p_end}
{p2col:{bf:{help mf_mvnormal:mvnormalcvderivqp()}}}{cmd:mvnormalcvderiv()} with
specified quadrature points{p_end}
{col 5}{hline}

{marker N}{...}
{p2col:{bf:{help mf_findexternal:nameexternal()}}}name of external global{p_end}
{p2col:{bf:{help mf_normal:nbetaden()}}}noncentral beta density{p_end}
{p2col:{bf:{help mf_normal:nbinomial()}}}cumulative negative binomial distribution function{p_end}
{p2col:{bf:{help mf_normal:nbinomialp()}}}negative binomial probability mass function{p_end}
{p2col:{bf:{help mf_normal:nbinomialtail()}}}reverse cumulative negative binomial distribution{p_end}
{p2col:{bf:{help mf_normal:nchi2()}}}cumulative noncentral chi-squared distribution{p_end}
{p2col:{bf:{help mf_normal:nchi2den()}}}noncentral chi-squared density{p_end}
{p2col:{bf:{help mf_normal:nchi2tail()}}}1 minus cumulative noncentral chi-squared distribution{p_end}
{p2col:{bf:{help mf__negate:_negate()}}}negate real matrix{p_end}
{p2col:{bf:{help mf_normal:nF()}}}cumulative noncentral F distribution{p_end}
{p2col:{bf:{help mf_normal:nFden()}}}noncentral F density{p_end}
{p2col:{bf:{help mf_normal:nFtail()}}}1 minus cumulative noncentral F distribution{p_end}
{p2col:{bf:{help mf_normal:nibeta()}}}cumulative noncentral beta distribution{p_end}
{p2col:{bf:{help mf_missing:nonmissing()}}}count of nonmissing values{p_end}
{p2col:{bf:{help mf_norm:norm()}}}matrix and vector norms {...}{p_end}
{p2col:{bf:{help mf_normal:normal()}}}cumulative normal distribution{p_end}
{p2col:{bf:{help mf_normal:normalden()}}}normal density{p_end}
{p2col:{bf:{help mf_normal:npnchi2()}}}noncentrality parameter of noncentral chi-squared{p_end}
{p2col:{bf:{help mf_normal:npnF()}}}noncentrality parameter of noncentral F{p_end}
{p2col:{bf:{help mf_normal:npnt()}}}noncentrality parameter of noncentral t{p_end}
{p2col:{bf:{help mf_normal:nt()}}}cumulative noncentral Student's t distribution{p_end}
{p2col:{bf:{help mf_normal:ntden()}}}noncentral Student's t density{p_end}
{p2col:{bf:{help mf_normal:nttail()}}}reverse cumulative noncentral Student's t distribution{p_end}

{col 5}{hline}

{marker O}{...}
{p2col:{bf:{help mf_optimize:optimize()}}}perform optimization{p_end}
{p2col:{bf:{help mf_optimize:optimize_evaluate()}}}evaluate user's {cmd:optimize()} function{p_end}
{p2col:{bf:{help mf_optimize:optimize_init()}}}begin setup of optimization problem{p_end}
{p2col:{bf:{help mf_optimize:optimize_init_{it:*}()}}}set up optimization problem{p_end}
{p2col:{bf:{help mf_optimize:optimize_query()}}}display optimization settings and results{p_end}
{p2col:{bf:{help mf_optimize:optimize_result_{it:*}()}}}access {cmd:optimize()} results{p_end}
{p2col:{bf:{help mf_sort:order()}}}permutation vector for ordering rows{p_end}
{p2col:{bf:{help mf_eltype:orgtype()}}}organizational type of object{p_end}

{col 5}{hline}

{marker P}{...}
{p2col:{bf:{help mf_panelsetup:panelsetup()}}}information matrix used in panel-data processing{p_end}
{p2col:{bf:{help mf_panelsetup:panelstats()}}}summary statistics on panels{p_end}
{p2col:{bf:{help mf_panelsetup:panelsubmatrix()}}}matrix for panel {it:i}{p_end}
{p2col:{bf:{help mf_panelsetup:panelsubview()}}}view matrix for panel {it:i}{p_end}
{p2col 4 32 34 2:*{bf:{help mf_panelsum:panelsum()}}}compute within-panel sums{p_end}
{p2col:{bf:{help mf_pathjoin:pathasciisuffix()}}}whether file is ASCII{p_end}
{p2col:{bf:{help mf_pathjoin:pathbasename()}}}path basename{p_end}
{p2col:{bf:{help mf_pathjoin:pathgetparent()}}}get the parent path{p_end}
{p2col:{bf:{help mf_pathjoin:pathisabs()}}}whether path is absolute{p_end}
{p2col:{bf:{help mf_pathjoin:pathisurl()}}}whether path is URL{p_end}
{p2col:{bf:{help mf_pathjoin:pathjoin()}}}joined paths{p_end}
{p2col:{bf:{help mf_pathjoin:pathlist()}}}row vector with elements containing ado-path directories{p_end}
{p2col:{bf:{help mf_pathjoin:pathresolve()}}}resolve a relative path{p_end}
{p2col:{bf:{help mf_pathjoin:pathrmsuffix()}}}path with file suffix removed{p_end}
{p2col:{bf:{help mf_pathjoin:pathsearchlist()}}}row vector whose elements are the paths in which Stata searches for 
	files{p_end}
{p2col:{bf:{help mf_pathjoin:pathsplit()}}}split path{p_end}
{p2col:{bf:{help mf_pathjoin:pathstatasuffix()}}}whether file belongs in
official Stata directories{p_end}
{p2col:{bf:{help mf_pathjoin:pathsubsysdir()}}}row vector with actual directories substituted for named-system 
directories such as "BASE"{p_end}
{p2col:{bf:{help mf_pathjoin:pathsuffix()}}}file suffix{p_end}
{p2col:{bf:{help mf_pdf:Pdf*()}}}create a PDF file{p_end}
{p2col:{bf:{help mf__equilrc:_perhapsequilc()}}}perform column equilibration, if necessary{p_end}
{p2col:{bf:{help mf__equilrc:_perhapsequilr()}}}perform row equilibration, if necessary{p_end}
{p2col:{bf:{help mf__equilrc:_perhapsequilrc()}}}perform row and column equilibration, if necessary{p_end}
{p2col:{bf:{help mf_sin:pi()}}}value of {it:pi}{p_end}
{p2col:{bf:{help mf_pinv:pinv()}}}Moore-Penrose pseudoinverse{p_end}
{p2col:{bf:{help mf_normal:poisson()}}}cumulative Poisson distribution function{p_end}
{p2col:{bf:{help mf_normal:poissonp()}}}Poisson probability mass function{p_end}
{p2col:{bf:{help mf_normal:poissontail()}}}reverse cumulative Poisson distribution{p_end}
{p2col:{bf:{help mf_polyeval:polyadd()}}}polynomial obtained by adding two polynomials{p_end}
{p2col:{bf:{help mf_polyeval:polyderiv()}}}polynomial obtained as derivative of a polynomial{p_end}
{p2col:{bf:{help mf_polyeval:polydiv()}}}polynomial obtained by dividing two polynomials{p_end}
{p2col:{bf:{help mf_polyeval:polyeval()}}}row vector containing polynomial evaluated at vector of points{p_end}
{p2col:{bf:{help mf_polyeval:polyinteg()}}}polynomial obtained as integral of a polynomial{p_end}
{p2col:{bf:{help mf_polyeval:polymult()}}}polynomial obtained from multiplying two polynomials{p_end}
{p2col:{bf:{help mf_polyeval:polyroots()}}}roots of polynomial{p_end}
{p2col:{bf:{help mf_polyeval:polysolve()}}}minimal-degree polynomial that fits {cmd:polyeval(}{it:c},{it:x}{cmd:)}{p_end}
{p2col:{bf:{help mf_polyeval:polytrim()}}}polynomial with trailing zeros removed{p_end}
{p2col:{bf:{help mf_printf:printf()}}}display output at terminal{p_end}
{p2col:{bf:{help mf_chdir:pwd()}}}current working directory{p_end}

{col 5}{hline}

{marker Q}{...}
{p2col:{bf:{help mf_date:qofd()}}}{cmd:%tq} value from {cmd:%td} value{p_end}
{p2col:{bf:{help mf_qrd:qrd()}}}perform QR decomposition {it:A} = {it:QR}{p_end}
{p2col:{bf:{help mf_qrd:qrdp()}}}perform QR decomposition with pivoting {it:A} = {it:QRP}{bf:'}{p_end}
{p2col:{bf:{help mf_qrinv:qrinv()}}}generalized inverse from real or complex matrix using QR decomposition{p_end}
{p2col:{bf:{help mf_qrsolve:qrsolve()}}}generalized solution from linear system with real or complex 
	coefficients using QR decomposition{p_end}
{p2col:{bf:{help mf_sum:quadcolsum()}}}quad-precision {bf:{help mf_sum:colsum()}}{p_end}
{p2col:{bf:{help mf_mean:quadcorrelation()}}}quad-precision {bf:{help mf_mean:correlation()}}{p_end}
{p2col:{bf:{help mf_quadcross:quadcross()}}}quad-precision {bf:{help mf_cross:cross()}}{p_end}
{p2col:{bf:{help mf_quadcross:quadcrossdev()}}}quad-precision {bf:{help mf_crossdev:crossdev()}}{p_end}
{p2col:{bf:{help mf_mean:quadmeanvariance()}}}quad-precision {bf:{help mf_mean:meanvariance()}}{p_end}
{p2col:{bf:{help mf_sign:quadrant()}}}quadrant of value{p_end}
{p2col:{bf:{help mf_quadrature:Quadrature()}}}numerical integration{p_end}
{p2col:{bf:{help mf_sum:quadrowsum()}}}quad-precision {bf:{help mf_sum:rowsum()}}{p_end}
{p2col:{bf:{help mf_runningsum:quadrunningsum()}}}quad-precision {bf:{help mf_runningsum:runningsum()}}{p_end}
{p2col:{bf:{help mf_sum:quadsum()}}}quad-precision {bf:{help mf_sum:sum()}}{p_end}
{p2col:{bf:{help mf_mean:quadvariance()}}}quad-precision {bf:{help mf_mean:variance()}}{p_end}
{p2col:{bf:{help mf_date:quarter()}}}quarter from {cmd:%td} value{p_end}
{p2col:{bf:{help mf_date:quarterly()}}}{cmd:%tq} value from string{p_end}
{p2col:{bf:{help mf_setbreakintr:querybreakintr()}}}whether break-key interrupt is off/on{p_end}

{col 5}{hline}

{marker R}{...}
{p2col:{bf:{help mf_range:range()}}}vector of values over specified range in steps of {it:d}{p_end}
{p2col:{bf:{help mf_range:rangen()}}}vector of n values over specified range{p_end}
{p2col:{bf:{help mf_rank:rank()}}}rank of matrix{...}{p_end}
{p2col:{bf:{help mf_runiform:rbeta()}}}beta pseudorandom variates{p_end}
{p2col:{bf:{help mf_runiform:rbinomial()}}}binomial pseudorandom variates{p_end}
{p2col:{bf:{help mf_runiform:rcauchy()}}}Cauchy pseudorandom variates{p_end}
{p2col:{bf:{help mf_runiform:rchi2()}}}chi-squared pseudorandom variates{p_end}
{p2col:{bf:{help mf_rdirichlet:rdirichlet()}}}Dirichlet random variates{p_end}
{p2col:{bf:{help mf_runiform:rdiscrete()}}}discrete pseudorandom variates{p_end}
{p2col:{bf:{help mf_re:Re()}}}real part{p_end}
{p2col 4 32 34 2:*{bf:{help mf_regex:regexm()}}}regular expression matching{p_end}
{p2col 4 32 34 2:*{bf:{help mf_regex:regexr()}}}substring replacement based on regular expression matching{p_end}
{p2col 4 32 34 2:*{bf:{help mf_regex:regexs()}}}subexpressions from regular expression matching{p_end}
{p2col:{bf:{help mf_reldif:reldif()}}}relative difference{p_end}
{p2col:{bf:{help mf_invorder:revorder()}}}reverse of permutation vector{p_end}
{p2col:{bf:{help mf_runiform:rexponential()}}}exponential random variates{p_end}
{p2col:{bf:{help mf_runiform:rgamma()}}}gamma pseudorandom variates{p_end}
{p2col:{bf:{help mf_runiform:rigaussian()}}}inverse Gaussian pseudorandom variates{p_end}
{p2col:{bf:{help mf_runiform:rhypergeometric()}}}hypergeometric pseudorandom variates{p_end}
{p2col:{bf:{help mf_runiform:rlaplace()}}}Laplace pseudorandom variates{p_end}
{p2col:{bf:{help mf_runiform:rlogistic()}}}logistic random variates{p_end}
{p2col:{bf:{help mf_chdir:rmdir()}}}remove directory{p_end}
{p2col:{bf:{help mf_findexternal:rmexternal()}}}remove external global{p_end}
{p2col:{bf:{help mf_runiform:rnbinomial()}}}negative binomial pseudorandom variates{p_end}
{p2col:{bf:{help mf_runiform:rngstate()}}}state of the random-number generator{p_end}
{p2col:{bf:{help mf_runiform:rnormal()}}}normal (Gaussian) pseudorandom variates{p_end}
{p2col 4 32 34 2:*{bf:{help mf_robust:robust()}}}robust variance estimates{p_end}
{p2col:{bf:{help mf_trunc:round()}}}matrixed rounded to closest integer or multiple{p_end}
{p2col:{bf:{help mf_minmax:rowmax()}}}column vector of rows' maximums{p_end}
{p2col:{bf:{help mf_minmax:rowmaxabs()}}}{cmd:rowmax(abs())}{p_end}
{p2col:{bf:{help mf_minmax:rowmin()}}}column vector of rows' minimums{p_end}
{p2col:{bf:{help mf_minmax:rowminmax()}}}matrix of rows' minimums and maximums{p_end}
{p2col:{bf:{help mf_missing:rowmissing()}}}column vector of counts of rows' missing values{p_end}
{p2col:{bf:{help mf_missing:rownonmissing()}}}column vector of counts of rows' nonmissing values{p_end}
{p2col:{bf:{help mf_rows:rows()}}}number of rows{p_end}
{p2col:{bf:{help mf__equilrc:rowscalefactors()}}}column vector of row-scaling factors for equilibration{p_end}
{p2col:{bf:{help mf_rowshape:rowshape()}}}reshape matrix to have {it:r} rows{p_end}
{p2col:{bf:{help mf_sum:rowsum()}}}column vector of rows' sums{p_end}
{p2col:{bf:{help mf_runiform:rpoisson()}}}poisson pseudorandom variates{p_end}
{p2col:{bf:{help mf_runiform:rseed()}}}obtain or set random-variate generator seed{p_end}
{p2col:{bf:{help mf_runiform:rt()}}}Student's t pseudorandom variates{p_end}
{p2col:{bf:{help mf_runiform:runiform()}}}matrix of uniformly distributed pseudorandom numbers{p_end}
{p2col:{bf:{help mf_runiform:runiformint()}}}uniform random integer variates{p_end}
{p2col:{bf:{help mf_runningsum:runningsum()}}}running sum of vector{p_end}
{p2col:{bf:{help mf_runiform:rweibull()}}}Weibull random variates{p_end}
{p2col:{bf:{help mf_runiform:rweibullph()}}}Weibull (proportional hazards) random variates{p_end}

{col 5}{hline}

{marker S}{...}
{p2col:{bf:{help mf_schurd:schurd()}}}Schur decomposition and eigenvalues{p_end}
{p2col:{bf:{help mf_schurd:_schurd()}}}Schur decomposition{p_end}
{p2col:{bf:{help mf_schurd:schurdgroupby()}}}compute Schur decomposition and generalized eigenvalues and group results according to specified condition{p_end}
{p2col:{bf:{help mf_schurd:_schurdgroupby()}}}compute Schur decomposition and group results according to specified condition{p_end}
{p2col:{bf:{help mf_date:seconds()}}}seconds of milliseconds{p_end}
{p2col:{bf:{help mf_select:select()}}}matrix containing selected rows or columns{p_end}
{p2col:{bf:{help mf_select:selectindex()}}}vector containing selected indices{p_end}
{p2col:{bf:{help mf_setbreakintr:setbreakintr()}}}turn off/on break-key interrupt{p_end}
{p2col:{bf:{help mf_more:setmore()}}}query or set more on or off{p_end}
{p2col:{bf:{help mf_more:setmoreonexit()}}}set more on or off on exit{p_end}
{p2col:{bf:{help mf_sign:sign()}}}sign{p_end}
{p2col:{bf:{help mf_sin:sin()}}}sine{p_end}
{p2col:{bf:{help mf_sin:sinh()}}}hyperbolic sine{p_end}
{p2col:{bf:{help mf_sizeof:sizeof()}}}number of bytes consumed by object{p_end}
{p2col:{bf:{help mf_mindouble:smallestdouble()}}}smallest {it:e}>0{p_end}
{p2col:{bf:{help mf_solvelower:solvelower()}}}solution to linear system with lower-triangular coefficient matrix{p_end}
{p2col:{bf:{help mf_solvenl:solvenl*()}}}solutions to systems of nonlinear equations{p_end}
{p2col:{bf:{help mf_solvenl:_solvenl_solve()}}}invoke solver of nonlinear equations{p_end}
{p2col:{bf:{help mf_solve_tol:solve_tol()}}}tolerance used by solvers and inverters{p_end}
{p2col:{bf:{help mf_solvelower:solveupper()}}}solution to linear system with upper-triangular coefficient matrix{p_end}
{p2col:{bf:{help mf_sort:sort()}}}sort rows of matrix{p_end}
{p2col:{bf:{help mf_soundex:soundex()}}}matrix with string elements converted to the Soundex code.{p_end}
{p2col:{bf:{help mf_soundex:soundex_nara()}}}matrix with string elements converted to the U.S. Census Soundex code.{p_end}
{p2col:{bf:{help mf_spline3:spline3()}}}fit cubic spline{p_end}
{p2col:{bf:{help mf_spline3:spline3eval()}}}evaluate cubic spline{p_end}
{p2col 4 32 34 2:*{bf:{help mf_spmatbanded:SPMATbanded*()}}}banded matrix operators{p_end}
{p2col:{bf:{help mf_printf:sprintf()}}}display into string{p_end}
{p2col:{bf:{help mf_sqrt:sqrt()}}}square root{p_end}
{p2col:{bf:{help mf_date:ss()}}}second from {cmd:%tc} value{p_end}
{p2col:{bf:{help mf_date:ssC()}}}second from {cmd:%tc} value{p_end}
{p2col:{bf:{help mf_st_addobs:st_addobs()}}}add observations to Stata dataset{p_end}
{p2col:{bf:{help mf_st_addvar:st_addvar()}}}add variable to Stata dataset{p_end}
{p2col:{bf:{help mf_st_data:st_data()}}}load numeric data from Stata into matrix{p_end}
{p2col:{bf:{help mf_st_dir:st_dir()}}}obtain list of Stata objects{p_end}
{p2col:{bf:{help mf_st_dropvar:st_dropobsif()}}}drop selected observations{p_end}
{p2col:{bf:{help mf_st_dropvar:st_dropobsin()}}}drop observations in specified range{p_end}
{p2col:{bf:{help mf_st_dropvar:st_dropvar()}}}drop specified variables{p_end}
{p2col:{bf:{help mf_st_rclear:st_eclear()}}}clear {cmd:e()}{p_end}
{p2col 4 32 34 2:*{bf:{help mf_st_fopen:st_fopen()}}}open file the Stata way{p_end}
{p2col:{bf:{help mf_st_frame:st_frame{it:*}()}}}data frame manipulation{p_end}
{p2col 4 32 34 2:*{bf:{help mf_st_freadsignature:st_freadsignature()}}}read file-signature header{p_end}
{p2col 4 32 34 2:*{bf:{help mf_st_freadsignature:st_fwritesignature()}}}write file-signature header{p_end}
{p2col:{bf:{help mf_st_global:st_global()}}}obtain/set Stata global{p_end}
{p2col:{bf:{help mf_st_global:st_global_hcat()}}}query hcat associated with {cmd:e()} or {cmd:r()} macro value{p_end}
{p2col:{bf:{help mf_st_isfmt:st_isfmt()}}}whether valid {cmd:%}{it:fmt}{p_end}
{p2col:{bf:{help mf_st_isname:st_islmname()}}}whether valid local macro name{p_end}
{p2col:{bf:{help mf_st_isname:st_isname()}}}whether valid Stata name{p_end}
{p2col:{bf:{help mf_st_isfmt:st_isnumfmt()}}}whether valid numeric {cmd:%}{it:fmt}{p_end}
{p2col:{bf:{help mf_st_vartype:st_isnumvar()}}}whether variable is numeric{p_end}
{p2col:{bf:{help mf_st_isfmt:st_isstrfmt()}}}whether valid string {cmd:%}{it:fmt}{p_end}
{p2col:{bf:{help mf_st_vartype:st_isstrvar()}}}whether variable is string{p_end}
{p2col:{bf:{help mf_st_dropvar:st_keepobsif()}}}keep selected observations{p_end}
{p2col:{bf:{help mf_st_dropvar:st_keepobsin()}}}keep observations in specified range{p_end}
{p2col:{bf:{help mf_st_dropvar:st_keepvar()}}}keep specified variables{p_end}
{p2col 4 32 34 2:*{bf:{help mf_st_lchar:st_lchar()}}}obtain/set "long" characteristics{p_end}
{p2col:{bf:{help mf_st_local:st_local()}}}obtain/set local Stata macro{p_end}
{p2col:{bf:{help mf_st_macroexpand:st_macroexpand()}}}expand Stata macros{p_end}
{p2col:{bf:{help mf_st_matrix:st_matrix()}}}obtain/set Stata matrix{p_end}
{p2col 4 32 34 2:*{bf:{help mf_st_ms_display:st_ms_display()}}}obtain strings produced by {helpb _ms_display}{p_end}
{p2col 4 32 34 2:*{bf:{help mf_st_ms_utils:st_matrixcoleqnumb()}}}obtain column equation indices of a Stata matrix with the equation specifications in a column vector{p_end}
{p2col 4 32 34 2:*{bf:{help mf_st_ms_utils:st_matrixcolfreeparm()}}}obtain a vector indicating where the free parameters are among the columns of a Stata matrix{p_end}
{p2col 4 32 34 2:*{bf:{help mf_st_ms_utils:st_matrixcolnfreeparms()}}}obtain the number of free parameter columns of a Stata matrix{p_end}
{p2col 4 32 34 2:*{bf:{help mf_st_ms_utils:st_matrixcolnlfs()}}}obtain the number of linear forms among the columns of a Stata matrix{p_end}
{p2col 4 32 34 2:*{bf:{help mf_st_ms_utils:st_matrixcolnumb()}}}obtain column numbers of a Stata matrix associated with the stripe specifications in a matrix{p_end}
{p2col:{bf:{help mf_st_matrix:st_matrixcolstripe()}}}obtain/set column labels{p_end}
{p2col:{bf:{help mf_st_matrix:st_matrix_hcat()}}}query hcat associated with {cmd:e()} or {cmd:r()} matrix value{p_end}
{p2col 4 32 34 2:*{bf:{help mf_st_matrix__joinbyname:st_matrix__joinbyname()}}}join rows of Stata matrices while matching column names{p_end}
{p2col 4 32 34 2:*{bf:{help mf_st_matrix_list:st_matrix_list()}}}list a Stata matrix{p_end}
{p2col 4 32 34 2:*{bf:{help mf_st_ms_utils:st_matrixroweqnumb()}}}obtain row equation indices of a Stata matrix with the equation specifications in a row vector{p_end}
{p2col 4 32 34 2:*{bf:{help mf_st_ms_utils:st_matrixrowfreeparm()}}}obtain a vector indicating where the free parameters are among the rows of a Stata matrix{p_end}
{p2col 4 32 34 2:*{bf:{help mf_st_ms_utils:st_matrixrownfreeparms()}}}obtain the number of free parameter rows of a Stata matrix{p_end}
{p2col 4 32 34 2:*{bf:{help mf_st_ms_utils:st_matrixrownlfs()}}}obtain the number of linear forms among the rows of a Stata matrix{p_end}
{p2col 4 32 34 2:*{bf:{help mf_st_ms_utils:st_matrixrownumb()}}}obtain column numbers of a Stata matrix associated with the stripe specifications in a matrix{p_end}
{p2col 4 32 34 2:*{bf:{help mf_st_ms_utils:st_matrix*stripe_*()}}}matrix stripe utilities{p_end}
{p2col:{bf:{help mf_st_matrix:st_matrixrowstripe()}}}obtain/set row labels{p_end}
{p2col 4 32 34 2:*{bf:{help mf_st_ms_unab:st_ms_unab()}}}unabbreviate matrix stripe elements{p_end}
{p2col:{bf:{help mf_st_nvar:st_nobs()}}}number of observations in Stata dataset{p_end}
{p2col:{bf:{help mf_st_numscalar:st_numscalar()}}}obtain/set Stata numeric scalar{p_end}
{p2col:{bf:{help mf_st_numscalar:st_numscalar_hcat()}}}query hcat associated with {cmd:e()} or {cmd:r()} scalar value{p_end}
{p2col:{bf:{help mf_st_nvar:st_nvar()}}}number of variables{p_end}
{p2col:{bf:{help mf_st_rclear:st_rclear()}}}clear {cmd:r()}{p_end}
{p2col:{bf:{help mf_st_matrix:st_replacematrix()}}}replace existing Stata matrix{p_end}
{p2col:{bf:{help mf_st_rclear:st_sclear()}}}clear {cmd:s()}{p_end}
{p2col:{bf:{help mf_st_data:st_sdata()}}}load string data from Stata into matrix {...}{p_end}
{p2col:{bf:{help mf_select:st_select()}}}select rows or columns of view{p_end}
{p2col:{bf:{help mf_st_store:st_sstore()}}}modify string data in Stata dataset{p_end}
{p2col:{bf:{help mf_st_store:st_store()}}}modify numeric data in Stata dataset{p_end}
{p2col:{bf:{help mf_st_numscalar:st_strscalar()}}}obtain/set Stata string scalar{p_end}
{p2col:{bf:{help mf_st_subview:st_subview()}}}make subview from view{p_end}
{p2col:{bf:{help mf_st_view:st_sview()}}}obtain a view matrix for Stata string variables{p_end}
{p2col:{bf:{help mf_st_tempname:st_tempfilename()}}}temporary filename{p_end}
{p2col:{bf:{help mf_st_tempname:st_tempname()}}}temporary variable name{p_end}
{p2col:{bf:{help mf_st_tsrevar:st_tsrevar()}}}row vector of variable indices of temporary variables
	created by evaluating a vector of time-series-operated variable names{p_end}
{p2col:{bf:{help mf_st_updata:st_updata()}}}query/set data-have-changed flag{p_end}
{p2col:{bf:{help mf_st_varformat:st_varformat()}}}obtain/set format of Stata variable{p_end}
{p2col:{bf:{help mf_st_varindex:st_varindex()}}}obtain variable indices from variable names{p_end}
{p2col:{bf:{help mf_st_varformat:st_varlabel()}}}obtain/set variable label{p_end}
{p2col:{bf:{help mf_st_varname:st_varname()}}}obtain variable names from variable indices{p_end}
{p2col:{bf:{help mf_st_varrename:st_varrename()}}}rename Stata variable{p_end}
{p2col:{bf:{help mf_st_vartype:st_vartype()}}}storage type of Stata variable{p_end}
{p2col:{bf:{help mf_st_varformat:st_varvaluelabel()}}}obtain/set value label{p_end}
{p2col:{bf:{help mf_st_view:st_view()}}}obtain view onto numeric variables in Stata dataset{p_end}
{p2col:{bf:{help mf_st_viewvars:st_viewobs()}}}obtain indices of observations of view{p_end}
{p2col:{bf:{help mf_st_viewvars:st_viewvars()}}}obtain indices of variables of  view{p_end}
{p2col:{bf:{help mf_st_vlexists:st_vldrop()}}}drop value label{p_end}
{p2col:{bf:{help mf_st_vlexists:st_vlexists()}}}whether value label exists{p_end}
{p2col:{bf:{help mf_st_vlexists:st_vlload()}}}load value label{p_end}
{p2col:{bf:{help mf_st_vlexists:st_vlmap()}}}map values through value label{p_end}
{p2col:{bf:{help mf_st_vlexists:st_vlmodify()}}}create or modify value label{p_end}
{p2col:{bf:{help mf_st_vlexists:st_vlsearch()}}}map text through value label{p_end}
{p2col:{bf:{help mf_stata:stata()}}}execute Stata command{p_end}
{p2col:{bf:{help mf_stataversion:statasetversion()}}}obtain/set version of Stata set by user{p_end}
{p2col:{bf:{help mf_stataversion:stataversion()}}}version of Stata being run{p_end}
{p2col:{bf:{help mf_strdup:strdup()}}}{cmd:*} -- operator for string duplication{p_end}
{p2col:{bf:{help mf_strtrim:stritrim()}}}string matrix obtained by replacing multiple, consecutive internal 
	blanks with one blank in string elements{p_end}
{p2col:{bf:{help mf_strlen:strlen()}}}matrix containing lengths of string elements {p_end}
{p2col:{bf:{help mf_strupper:strlower()}}}matrix with string elements converted to lowercase{p_end}
{p2col:{bf:{help mf_strtrim:strltrim()}}}matrix with leading blanks of string elements removed{p_end}
{p2col:{bf:{help mf_strmatch:strmatch()}}}matrix containing ones and zeros obtained from elementwise pattern 
	matching{p_end}
{p2col:{bf:{help mf_strofreal:strofreal()}}}string matrix obtained by converting elements of real matrix{p_end}
{p2col:{bf:{help mf_strpos:strpos()}}}matrix of first positions of substring in string (elementwise){p_end}
{p2col:{bf:{help mf_strrpos:strrpos()}}}matrix of last positions of substring in string (elementwise){p_end}
{p2col:{bf:{help mf_strupper:strproper()}}}matrix with string elements converted to proper case{p_end}
{p2col:{bf:{help mf_strreverse:strreverse()}}}matrix with string elements reversed{p_end}
{p2col:{bf:{help mf_strtrim:strrtrim()}}}matrix with trailing blanks removed from string elements{p_end}
{p2col:{bf:{help mf_strtoname:strtoname()}}}translate strings to Stata names{p_end}
{p2col:{bf:{help mf_strtoreal:strtoreal()}}}real matrix obtained by converting elements of string matrix{p_end}
{p2col:{bf:{help mf_strtrim:strtrim()}}}matrix with leading and trailing blanks removed from string elements{p_end}
{p2col:{bf:{help mf_eltype:structname()}}}struct name of a Mata struct scalar{p_end}
{p2col:{bf:{help mf_strupper:strupper()}}}matrix with string elements converted to uppercase{p_end}
{p2col 4 32 34 2:*{bf:{help mf_subdiagget:subdiagget()}}}extract matrix subdiagonals{p_end}
{p2col:{bf:{help mf_subinstr:subinstr()}}}matrix obtained by elementwise string substitution{p_end}
{p2col:{bf:{help mf_subinstr:subinword()}}}matrix obtained by elementwise word substitution{p_end}
{p2col:{bf:{help mf_sublowertriangle:sublowertriangle()}}}return a matrix with zeros above a diagonal{p_end}
{p2col:{bf:{help mf_substr:substr()}}}substring of length {it:l} that begins at position {it:b} in a string{p_end}
{p2col:{bf:{help mf__substr:_substr()}}}string scalar obtained by substituting {it:substring} into {it:string} 
	at specified position{p_end}
{p2col:{bf:{help mf_sum:sum()}}}sum over rows and columns{p_end}
{p2col:{bf:{help mf_svd:svd()}}}perform singular value decomposition {it:A} = {it:UDV}{bf:'}{p_end}
{p2col:{bf:{help mf_svd:svdsv()}}}singular values {it:s}{p_end}
{p2col:{bf:{help mf_svsolve:svsolve()}}}generalized solution of a linear system with real or complex 
	coefficients using singular-value decomposition{p_end}
{p2col:{bf:{help mf_swap:swap()}}}interchange contents of variables{p_end}
{p2col:{bf:{help mf_eigensystem:symeigensystem()}}}eigenvectors and eigenvalues of symmetric matrix{p_end}
{p2col:{bf:{help mf_eigensystemselect:_symeigensystemselect_la()}}}interface to {manhelp mf_lapack M-5:lapack()}; direct use not recommended{p_end}
{p2col:{bf:{help mf_eigensystemselect:symeigensystemselecti()}}}eigenvectors and eigenvalues selected by index of symmetric matrix{p_end}
{p2col:{bf:{help mf_eigensystemselect:symeigensystemselectr()}}}eigenvectors and eigenvalues selected by range of symmetric matrix{p_end}
{p2col:{bf:{help mf_eigensystem:symeigenvalues()}}}eigenvalues of symmetric matrix{p_end}

{col 5}{hline}

{marker T}{...}
{p2col:{bf:{help mf_normal:t()}}}cumulative Student's t distribution{p_end}
{p2col:{bf:{help mf_sin:tan()}}}tangent{p_end}
{p2col:{bf:{help mf_sin:tanh()}}}hyperbolic tangent{p_end}
{p2col:{bf:{help mf_normal:tden()}}}Student's t density{p_end}
{p2col 4 32 34 2:*{bf:{help mf_timer:timer()}}}display time profile report{p_end}
{p2col 4 32 34 2:*{bf:{help mf_timer:timer_clear()}}}clear timers{p_end}
{p2col 4 32 34 2:*{bf:{help mf_timer:timer_off()}}}stop timer{p_end}
{p2col 4 32 34 2:*{bf:{help mf_timer:timer_on()}}}start timer{p_end}
{p2col 4 32 34 2:*{bf:{help mf_timer:timer_value()}}}row vector summarizing contents of a timer{p_end}
{p2col:{bf:{help mf_toeplitz:Toeplitz()}}}Toeplitz matrix{p_end}
{p2col 4 32 34 2:*{bf:{help mf_toeplitzsolve:toeplitzsolve()}}}solution to linear system using Toeplitz matrix{p_end}
{p2col 4 32 34 2:*{bf:{help mf_toeplitzsolve:toeplitzscale()}}}solution to linear system using Toeplitz and Cholesky matrices{p_end}
{p2col 4 32 34 2:*{bf:{help mf_toeplitzsolve:_toeplitzscale()}}}solution to linear system using Toeplitz and diagonal matrices{p_end}
{p2col 4 32 34 2:*{bf:{help mf_toeplitzsolve:toeplitzchprod()}}}product of Toeplitz and Cholesky matrices{p_end}
{p2col:{bf:{help mf_tokenget:tokenallowhex()}}}query/reset hex-number parsing{p_end}
{p2col:{bf:{help mf_tokenget:tokenallownum()}}}query/reset number parsing{p_end}
{p2col:{bf:{help mf_tokenget:tokenget()}}}next token of string{p_end}
{p2col:{bf:{help mf_tokenget:tokengetall()}}}row vectors with all tokens from string{p_end}
{p2col:{bf:{help mf_tokenget:tokeninit()}}}initialize parsing environment{p_end}
{p2col:{bf:{help mf_tokenget:tokeninitstata()}}}initialize environment as Stata would{p_end}
{p2col:{bf:{help mf_tokenget:tokenoffset()}}}query/reset offset in string{p_end}
{p2col:{bf:{help mf_tokenget:tokenpchars()}}}query/reset parsing characters ({it:pchars}){p_end}
{p2col:{bf:{help mf_tokenget:tokenpeek()}}}peek at next {cmd:tokenget()} result{p_end}
{p2col:{bf:{help mf_tokenget:tokenqchars()}}}query/reset quote characters ({it:qchars}){p_end}
{p2col:{bf:{help mf_tokenget:tokenrest()}}}return yet-to-be-parsed portion{p_end}
{p2col:{bf:{help mf_tokens:tokens()}}}obtain tokens (words) from string{p_end}
{p2col:{bf:{help mf_tokenget:tokenset()}}}set/reset string to be parsed{p_end}
{p2col:{bf:{help mf_tokenget:tokenwchars()}}}query/reset white-space characters ({it:wchars}){p_end}
{p2col:{bf:{help mf_trace:trace()}}}trace of square matrix {...}{p_end}
{p2col 4 32 34 2:*{bf:{help mf_trace_abbav:trace_ABBAV()}}}trace of special-purpose matrix{p_end}
{p2col 4 32 34 2:*{bf:{help mf_trace_avbv:trace_AVBV()}}}trace of special-purpose matrix{p_end}
{p2col:{bf:{help mf__transpose:_transpose()}}}transposition in place{p_end}
{p2col:{bf:{help mf_transposeonly:transposeonly()}}}transposition without conjugation{p_end}
{p2col:{bf:{help mf_factorial:trigamma()}}}second derivative of {cmd:lngamma()}{p_end}
{p2col:{bf:{help mf_trunc:trunc()}}}integer part of each element{p_end}
{p2col:{bf:{help mf_normal:ttail()}}}1 minus cumulative Student's t distribution{p_end}
{p2col:{bf:{help mf_normal:tukeyprob()}}}Tukey's Studentized range distribution{p_end}

{col 5}{hline}

{marker U}{...}
{p2col:{bf:{help mf_uchar:uchar()}}}convert code point to Unicode character{p_end}
{p2col 4 32 34 2:*{bf:{help mf_ucmpsdensity:ucmpsdensity()}}}parametric spectral density of a time-series stochastic cycle{p_end}
{p2col:{bf:{help mf_udstrlen:udstrlen()}}}display columns of Unicode string{p_end}
{p2col:{bf:{help mf_udsubstr:udsubstr()}}}extract Unicode substring based on display columns{p_end}
{p2col:{bf:{help mf_uniqrows:uniqrows()}}}unique rows of a matrix{p_end}
{p2col:{bf:{help mf_unitcircle:unitcircle()}}}complex column vector containing {it:n} points on the unit circle 
	in the complex plane {...}{p_end}
{p2col:{bf:{help mf_unlink:unlink()}}}erase file{p_end}
{p2col:{bf:{help mf_sort:unorder()}}}permutation vector for randomizing rows{p_end}
{p2col:{bf:{help mf_lowertriangle:uppertriangle()}}}upper-triangular matrix from input matrix{p_end}
{p2col:{bf:{help mf_urlencode:urldecode()}}}decode the string obtained from {cmd:urlencode()}{p_end}
{p2col:{bf:{help mf_urlencode:urlencode()}}}convert a string into a valid ASCII format for web transmission{p_end}
{p2col:{bf:{help mf_ustrcompare:ustrcompare()}}}compare Unicode strings{p_end}
{p2col:{bf:{help mf_ustrcompare:ustrcompareex()}}}compare Unicode strings, more options{p_end}
{p2col:{bf:{help mf_ustrpos:ustrpos()}}}find substring in Unicode string, first occurrence{p_end}
{p2col:{bf:{help mf_ustrpos:ustrrpos()}}}find substring in Unicode string, last occurrence{p_end}
{p2col:{bf:{help mf_ustrfix:ustrfix()}}}replace invalid UTF-8 sequence in Unicode string{p_end}
{p2col:{bf:{help mf_ustrto:ustrfrom()}}}convert string in one encoding to Unicode string{p_end}
{p2col:{bf:{help mf_ustrlen:ustrinvalidcnt()}}}number of invalid UTF-8 sequences in Unicode string{p_end}
{p2col:{bf:{help mf_usubstr:ustrleft()}}}return the first {it:n} Unicode characters{p_end}
{p2col:{bf:{help mf_ustrlen:ustrlen()}}}length of Unicode string in Unicode characters{p_end}
{p2col:{bf:{help mf_ustrupper:ustrlower()}}}convert Unicode string to lowercase{p_end}
{p2col:{bf:{help mf_ustrtrim:ustrltrim()}}}remove leading Unicode whitespaces and blanks{p_end}
{p2col:{bf:{help mf_ustrnormalize:ustrnormalize()}}}normalize Unicode string{p_end}
{p2col 4 32 34 2:*{bf:{help mf_ustrregex:ustrregexm()}}}Unicode regular expression match{p_end}
{p2col 4 32 34 2:*{bf:{help mf_ustrregex:ustrregexra()}}}replace all matched substrings{p_end}
{p2col 4 32 34 2:*{bf:{help mf_ustrregex:ustrregexrf()}}}replace the first matched substring{p_end}
{p2col 4 32 34 2:*{bf:{help mf_ustrregex:ustrregexs()}}}return the {it:n}th subexpression{p_end}
{p2col:{bf:{help mf_ustrreverse:ustrreverse()}}}reverse Unicode substring{p_end}
{p2col:{bf:{help mf_usubstr:ustrright()}}}return the last {it:n} Unicode characters{p_end}
{p2col:{bf:{help mf_ustrtrim:ustrrtrim()}}}remove trailing Unicode whitespaces and blanks{p_end}
{p2col:{bf:{help mf_ustrcompare:ustrsortkey()}}}obtain sort key of Unicode string{p_end}
{p2col:{bf:{help mf_ustrcompare:ustrsortkeyex()}}}obtain sort key of Unicode string, more options{p_end}
{p2col:{bf:{help mf_ustrsplit:ustrsplit()}}}split string into parts based on a Unicode regular expression{p_end}
{p2col:{bf:{help mf_ustrupper:ustrtitle()}}}convert Unicode string to titlecase{p_end}
{p2col:{bf:{help mf_ustrto:ustrto()}}}convert Unicode string to string in another encoding{p_end}
{p2col:{bf:{help mf_ustrunescape:ustrtohex()}}}convert Unicode string to hex sequences{p_end}
{p2col:{bf:{help mf_ustrtoname:ustrtoname()}}}convert a Unicode string to a Stata name{p_end}
{p2col:{bf:{help mf_ustrtrim:ustrtrim()}}}remove Unicode whitespaces and blanks{p_end}
{p2col:{bf:{help mf_ustrunescape:ustrunescape()}}}convert the escaped hex sequences to Unicode{p_end}
{p2col:{bf:{help mf_ustrupper:ustrupper()}}}convert Unicode string to uppercase{p_end}
{p2col:{bf:{help mf_ustrword:ustrword()}}}return {it:n}th Unicode word{p_end}
{p2col:{bf:{help mf_ustrword:ustrwordcount()}}}return number of Unicode words{p_end}
{p2col:{bf:{help mf_usubinstr:usubinstr()}}}replace Unicode substring{p_end}
{p2col:{bf:{help mf_usubstr:usubstr()}}}extract Unicode substring{p_end}
{p2col:{bf:{help mf__usubstr:_usubstr()}}}substitute into Unicode string{p_end}

{col 5}{hline}

{marker V}{...}
{p2col:{bf:{help mf_valofexternal:valofexternal()}}}value of external global{p_end}
{p2col:{bf:{help mf_vandermonde:Vandermonde()}}}Vandermonde matrix{p_end}
{p2col:{bf:{help mf_mean:variance()}}}variance of matrix{p_end}
{p2col:{bf:{help mf_vec:vec()}}}column vector obtained by stacking columns of matrix{p_end}
{p2col:{bf:{help mf_vec:vech()}}}column vector obtained by stacking lower-diagonal elements of columns of a 
	symmetric matrix{p_end}
{p2col 4 32 34 2:*{bf:{help mf_vech_lower:vech_lower()}}}same as {helpb mf_vec:vech()} but omits the main diagonal{p_end}

{col 5}{hline}

{marker W}{...}
{p2col:{bf:{help mf_date:week()}}}week of {cmd:%td} value{p_end}
{p2col:{bf:{help mf_date:weekly()}}}{cmd:%tw} value from string{p_end}
{p2col:{bf:{help mf_normal:weibull()}}}cumulative Weibull{p_end}
{p2col:{bf:{help mf_normal:weibullden()}}}Weibull density{p_end}
{p2col:{bf:{help mf_normal:weibullph()}}}cumulative Weibull PH{p_end}
{p2col:{bf:{help mf_normal:weibullphden()}}}Weibull PH density{p_end}
{p2col:{bf:{help mf_normal:weibullphtail()}}}reverse cumulative Weibull PH{p_end}
{p2col:{bf:{help mf_normal:weibulltail()}}}reverse cumulative Weibull{p_end}
{p2col:{bf:{help mf_date:wofd()}}}{cmd:%tw} value from {cmd:%td} value{p_end}

{col 5}{hline}

{marker X}{...}
{p2col:{bf:{help mf_xl:xl()}}}Excel file I/O class{p_end}
{col 5}{hline}

{marker Y}{...}
{p2col:{bf:{help mf_date:year()}}}year of {cmd:%td} value{p_end}
{p2col:{bf:{help mf_date:yearly()}}}{cmd:%ty} value from string{p_end}
{p2col:{bf:{help mf_date:yh()}}}{cmd:%th} value from year and half year{p_end}
{p2col:{bf:{help mf_date:ym()}}}{cmd:%tm} value from year and month{p_end}
{p2col:{bf:{help mf_date:yofd()}}}{cmd:%ty} value from {cmd:%td} value{p_end}
{p2col:{bf:{help mf_date:yq()}}}{cmd:%tq} value from year and quarter{p_end}
{p2col:{bf:{help mf_date:yw()}}}{cmd:%tw} value from year and week{p_end}
{col 5}{hline}
{p2col :* These functions are not documented in the manual.}{p_end}
{p2colreset}{...}
