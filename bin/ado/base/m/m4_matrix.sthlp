{smcl}
{* *! version 1.1.11  15may2018}{...}
{vieweralsosee "[M-4] Matrix" "mansection M-4 Matrix"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Intro" "help m4_intro"}{...}
{viewerjumpto "Contents" "m4_matrix##contents"}{...}
{viewerjumpto "Description" "m4_matrix##description"}{...}
{viewerjumpto "Links to PDF documentation" "m4_matrix##linkspdf"}{...}
{viewerjumpto "Remarks" "m4_matrix##remarks"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[M-4] Matrix} {hline 2}}Matrix functions
{p_end}
{p2col:}({mansection M-4 Matrix:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker contents}{...}
{title:Contents}

{col 5}   [M-5]
{col 5}Manual entry{col 22}Function{col 40}Purpose
{col 5}{hline}

{col 5}   {c TLC}{hline 17}{c TRC}
{col 5}{hline 3}{c RT}{it: Characteristics }{c LT}{hline}
{col 5}   {c BLC}{hline 17}{c BRC}

{col 5}{bf:{help mf_trace:trace()}}{...}
{col 22}{cmd:trace()}{...}
{col 40}trace of matrix
{...}

{col 5}{bf:{help mf_det:det()}}{...}
{col 22}{cmd:det()}{...}
{col 40}determinant
{col 22}{cmd:dettriangular()}{...}
{col 40}determinant of triangular matrix

{col 5}{bf:{help mf_norm:norm()}}{...}
{col 22}{cmd:norm()}{...}
{col 40}matrix and vector norms
{...}

{col 5}{bf:{help mf_cond:cond()}}{...}
{col 22}{cmd:cond()}{...}
{col 40}matrix condition number
{...}

{col 5}{bf:{help mf_rank:rank()}}{...}
{col 22}{cmd:rank()}{...}
{col 40}rank of matrix
{...}

{col 5}{bf:{help mf_trace_avbv:trace_AVBV()}}{...}
{col 22}{cmd:trace_AVBV()}{...}
{col 40}trace of special-purpose matrix

{col 5}{bf:{help mf_trace_abbav:trace_ABBAV()}}{...}
{col 22}{cmd:trace_ABBAV()}{...}
{col 40}trace of special-purpose matrix

{col 5}   {c TLC}{hline 46}{c TRC}
{col 5}{hline 3}{c RT}{it: Cholesky decomposition, solvers, & inverters }{c LT}{hline}
{col 5}   {c BLC}{hline 46}{c BRC}

{col 5}{bf:{help mf_cholesky:cholesky()}}{...}
{col 22}{cmd:cholesky()}{...}
{col 40}Cholesky square-root decomposition {it:A}={it:GG}{bf:'}

{col 5}{bf:{help mf_cholsolve:cholsolve()}}{...}
{col 22}{cmd:cholsolve()}{...}
{col 40}solve {it:AX} = {it:B} for {it:X}

{col 5}{bf:{help mf_cholinv:cholinv()}}{...}
{col 22}{cmd:cholinv()}{...}
{col 40}inverse of pos. def. symmetric matrix

{col 5}{bf:{help mf_invsym:invsym()}}{...}
{col 22}{cmd:invsym()}{...}
{col 40}real symmetric matrix inversion

{col 5}   {c TLC}{hline 40}{c TRC}
{col 5}{hline 3}{c RT}{it: LU decomposition, solvers, & inverters }{c LT}{hline}
{col 5}   {c BLC}{hline 40}{c BRC}

{col 5}{bf:{help mf_lud:lud()}}{...}
{col 22}{cmd:lud()}{...}
{col 40}LU decomposition {it:A} = {it:PLU}

{col 5}{bf:{help mf_lusolve:lusolve()}}{...}
{col 22}{cmd:lusolve()}{...}
{col 40}solve {it:AX} = {it:B} for {it:X}

{col 5}{bf:{help mf_luinv:luinv()}}{...}
{col 22}{cmd:luinv()}{...}
{col 40}inverse of square matrix

{col 5}   {c TLC}{hline 40}{c TRC}
{col 5}{hline 3}{c RT}{it: QR decomposition, solvers, & inverters }{c LT}{hline}
{col 5}   {c BLC}{hline 40}{c BRC}

{col 5}{bf:{help mf_qrd:qrd()}}{...}
{col 22}{cmd:qrd()}{...}
{col 40}QR decomposition {it:A} = {it:QR}
{col 22}{cmd:qrdp()}{...}
{col 40}QR decomposition {it:A} = {it:QRP}{bf:'}
{col 22}{cmd:hqrd()}{...}
{col 40}QR decomposition {it:A} = {it:f}({it:H}){it:R1}
{col 22}{cmd:hqrdp()}{...}
{col 40}QR decomposition {it:A} = {it:f}({it:H},{it:tau}){it:R1}{it:P}{bf:'}
{col 22}{cmd:hqrdmultq()}{...}
{col 40}return {it:QX} or {it:Q}{bf:'}{it:X}, {it:Q} = {it:f}({it:H},{it:tau})
{col 22}{cmd:hqrdmultq1t()}{...}
{col 40}return {it:Q1}{bf:'}{it:X},     {it:Q1} = {it:f}({it:H},{it:tau})
{col 22}{cmd:hqrdq()}{...}
{col 40}return {it:Q}  = {it:f}({it:H},{it:tau})
{col 22}{cmd:hqrdq1()}{...}
{col 40}return {it:Q1} = {it:f}({it:H},{it:tau})
{col 22}{cmd:hqrdr()}{...}
{col 40}return {it:R}
{col 22}{cmd:hqrdr1()}{...}
{col 40}return {it:R1}

{col 5}{bf:{help mf_qrsolve:qrsolve()}}{...}
{col 22}{cmd:qrsolve()}{...}
{col 40}solve {it:AX} = {it:B} for {it:X}

{col 5}{bf:{help mf_qrinv:qrinv()}}{...}
{col 22}{cmd:qrinv()}{...}
{col 40}generalized inverse of matrix

{col 5}   {c TLC}{hline 65}{c TRC}
{col 5}{hline 3}{c RT}{it: Hessenberg decomposition & generalized Hessenberg decomposition }{c LT}{hline}
{col 5}   {c BLC}{hline 65}{c BRC}

{col 5}{bf:{help mf_hessenbergd:hessenbergd()}}{...}
{col 22}{cmd:hessenbergd()}{...}
{col 40}Hessenberg decomposition T = Q'XQ

{col 5}{bf:{help mf_ghessenbergd:ghessenbergd()}}{...}
{col 22}{cmd:ghessenbergd()}{...}
{col 40}gen. Hessenberg decomp. T = Q'XQ

{col 5}   {c TLC}{hline 55}{c TRC}
{col 5}{hline 3}{c RT}{it: Schur decomposition & generalized Schur decomposition }{c LT}{hline}
{col 5}   {c BLC}{hline 55}{c BRC}

{col 5}{bf:{help mf_schurd:schurd()}}{...}
{col 22}{cmd:schurd()}{...}
{col 40}Schur decomposition T = U'AV; R=U'BA
{col 22}{cmd:schurdgroupby()}{...}
{col 40}Schur decomposition with grouping
{col 40}  of results

{col 5}{bf:{help mf_gschurd:gschurd()}}{...}
{col 22}{cmd:gschurd()}{...}
{col 40}gen. Schur decomp. T = U'AV; R=U'BA
{col 22}{cmd:gschurdgroupby()}{...}
{col 40}gen. Schur decomp. with grouping
{col 40}  of results

{col 5}   {c TLC}{hline 52}{c TRC}
{col 5}{hline 3}{c RT}{it: Singular value decomposition, solvers, & inverters }{c LT}{hline}
{col 5}   {c BLC}{hline 52}{c BRC}

{col 5}{bf:{help mf_svd:svd()}}{...}
{col 22}{cmd:svd()}{...}
{col 40}singular value decomposition {it:A} = {it:UDV}{bf:'}
{col 22}{cmd:svdsv()}{...}
{col 40}singular values {it:s}

{col 5}{bf:{help mf_fullsvd:fullsvd()}}{...}
{col 22}{cmd:fullsvd()}{...}
{col 40}singular value decomposition {it:A} = {it:USV}{bf:'}
{col 22}{cmd:fullsdiag()}{...}
{col 40}convert {it:s} to {it:S} 

{col 5}{bf:{help mf_svsolve:svsolve()}}{...}
{col 22}{cmd:svsolve()}{...}
{col 40}solve {it:AX} = {it:B} for {it:X}

{col 5}{bf:{help mf_pinv:pinv()}}{...}
{col 22}{cmd:pinv()}{...}
{col 40}Moore-Penrose pseudoinverse

{col 5}   {c TLC}{hline 20}{c TRC}
{col 5}{hline 3}{c RT}{it: Triangular solvers }{c LT}{hline}
{col 5}   {c BLC}{hline 20}{c BRC}

{col 5}{bf:{help mf_solvelower:solvelower()}}{...}
{col 22}{cmd:solvelower()}{...}
{col 40}solve {it:AX} = {it:B} for {it:X}, {it:A} lower triangular
{col 22}{cmd:solveupper()}{...}
{col 40}solve {it:AX} = {it:B} for {it:X}, {it:A} upper triangular

{col 5}   {c TLC}{hline 40}{c TRC}
{col 5}{hline 3}{c RT}{it: Eigensystems, powers, & transcendental }{c LT}{hline}
{col 5}   {c BLC}{hline 40}{c BRC}

{col 5}{bf:{help mf_eigensystem:eigensystem()}}{...}
{col 22}{cmd:eigensystem()}{...}
{col 40}right eigenvectors/eigenvalues 
{col 22}{cmd:eigenvalues()}{...}
{col 40}eigenvalues
{col 22}{cmd:lefteigensystem()}{...}
{col 40}left eigenvectors/eigenvalues 
{col 22}{cmd:symeigensystem()}{...}
{col 40}eigenvectors/eigenvalues of symm. matrix
{col 22}{cmd:symeigenvalues()}{...}
{col 40}eigenvalues of symmetric matrix

{col 5}{bf:{help mf_eigensystemselect:eigensystemselect()}}{...}
{col 22}{cmd:eigen~selectr()}{...}
{col 40}selected eigenvectors/eigenvalues
{col 22}etc.

{col 5}{bf:{help mf_geigensystem:geigensystem()}}{...}
{col 22}{cmd:geigensystem()}{...}
{col 40}generalized eigenvectors/eigenvalues 
{col 22}etc.

{col 5}{bf:{help mf_matpowersym:matpowersym()}}{...}
{col 22}{cmd:matpowersym()}{...}
{col 40}powers of symmetric matrix

{col 5}{bf:{help mf_matexpsym:matexpsym()}}{...}
{col 22}{cmd:matexpsym()}{...}
{col 40}exponentiation of symmetric matrix
{col 22}{cmd:matlogsym()}{...}
{col 40}logarithm of symmetric matrix

{col 5}   {c TLC}{hline 15}{c TRC}
{col 5}{hline 3}{c RT}{it: Equilibration }{c LT}{hline}
{col 5}   {c BLC}{hline 15}{c BRC}

{col 5}{bf:{help mf__equilrc:_equilrc()}}{...}
{col 22}{cmd:_equilrc()}{...}
{col 40}row/column equilibration
{col 22}{cmd:_equilr()}{...}
{col 40}row equilibration
{col 22}{cmd:_equilc()}{...}
{col 40}column equilibration
{col 22}{cmd:_perhapsequilrc()}{...}
{col 40}row/column equilibration if necessary
{col 22}{cmd:_perhapsequilr()}{...}
{col 40}row equilibration if necessary
{col 22}{cmd:_perhapsequilc()}{...}
{col 40}column equilibration if necessary
{col 22}{cmd:rowscalefactors()}{...}
{col 40}row-scaling factors for equilibration
{col 22}{cmd:colscalefactors()}{...}
{col 40}column-scaling factors for equilibration

{col 5}   {c TLC}{hline 17}{c TRC}
{col 5}{hline 3}{c RT}{it: Banded matrices }{c LT}{hline}
{col 5}   {c BLC}{hline 17}{c BRC}

{col 5}{bf:{help mf_spmatbanded:SPMATbanded*()}}{...}
{col 22}{cmd:SPMATbanded*()}{...}
{col 40}banded matrix operators

{col 5}   {c TLC}{hline 8}{c TRC}
{col 5}{hline 3}{c RT}{it: LAPACK }{c LT}{hline}
{col 5}   {c BLC}{hline 8}{c BRC}

{col 5}{bf:{help mf_lapack:lapack()}}{...}
{col 22}{cmd:LA_*()}{...}
{col 40}LAPACK linear-algebra functions
{col 22}{cmd:_flopin()}{...}
{col 40}convert matrix order from row major
{col 42}to column major
{col 22}{cmd:_flopout()}{...}
{col 40}convert matrix order from column major
{col 42}to row major

{col 5}{hline}


{marker description}{...}
{title:Description}

{p 4 4 2}
The above functions are what most people would call mathematical matrix
functions.  


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-4 MatrixRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
For other mathematical functions, see

	{bf:{help m4_scalar:[M-4] Scalar}}          Scalar mathematical functions

	{bf:{help m4_mathematical:[M-4] Mathematical}}    Important mathematical functions
