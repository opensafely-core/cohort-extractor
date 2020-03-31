{smcl}
{* *! version 1.1.7  15may2018}{...}
{vieweralsosee "[M-4] Manipulation" "mansection M-4 Manipulation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Intro" "help m4_intro"}{...}
{viewerjumpto "Contents" "m4_manipulation##contents"}{...}
{viewerjumpto "Description" "m4_manipulation##description"}{...}
{viewerjumpto "Links to PDF documentation" "m4_manipulation##linkspdf"}{...}
{viewerjumpto "Remarks" "m4_manipulation##remarks"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[M-4] Manipulation} {hline 2}}Matrix manipulation
{p_end}
{p2col:}({mansection M-4 Manipulation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker contents}{...}
{title:Contents}

{col 5}   [M-5]
{col 5}Manual entry{col 21}Function{col 37}Purpose
{col 5}{hline}

{col 5}   {c TLC}{hline 15}{c TRC}
{col 5}{hline 3}{c RT}{it: Transposition }{c LT}{hline}
{col 5}   {c BLC}{hline 15}{c BRC}

{col 5}{bf:{help mf_transposeonly:transposeonly()}}{...}
{col 21}{cmd:transposeonly()}{...}
{col 37}transposition without conjugation

{col 5}{bf:{help mf__transpose:_transpose()}}{...}
{col 21}{cmd:_transpose()}{...}
{col 37}transposition in place

{col 5}   {c TLC}{hline 11}{c TRC}
{col 5}{hline 3}{c RT}{it: Diagonals }{c LT}{hline}
{col 5}   {c BLC}{hline 11}{c BRC}

{col 5}{bf:{help mf_diag:diag()}}{...}
{col 21}{cmd:diag()}{...}
{col 37}create diagonal matrix from vector

{col 5}{bf:{help mf__diag:_diag()}}{...}
{col 21}{cmd:_diag()}{...}
{col 37}replace diagonal of matrix

{col 5}{bf:{help mf_diagonal:diagonal()}}{...}
{col 21}{cmd:diagonal()}{...}
{col 37}extract diagonal of matrix into vector

{col 5}   {c TLC}{hline 24}{c TRC}
{col 5}{hline 3}{c RT}{it: Triangular & symmetric }{c LT}{hline}
{col 5}   {c BLC}{hline 24}{c BRC}

{col 5}{bf:{help mf_lowertriangle:lowertriangle()}}{...}
{col 21}{cmd:lowertriangle()}{...}
{col 37}extract lower triangle
{col 21}{cmd:uppertriangle()}{...}
{col 37}extract upper triangle

{col 5}{bf:{help mf_sublowertriangle:sublowertriangle()}}{...}
{col 37}generalized {cmd:lowertriangle()}

{col 5}{bf:{help mf_makesymmetric:makesymmetric()}}{...}
{col 21}{cmd:makesymmetric()}{...}
{col 37}make matrix symmetric (Hermitian)

{col 5}   {c TLC}{hline 9}{c TRC}
{col 5}{hline 3}{c RT}{it: Sorting }{c LT}{hline}
{col 5}   {c BLC}{hline 9}{c BRC}

{col 5}{bf:{help mf_sort:sort()}}{...}
{col 21}{cmd:sort()}{...}
{col 37}sort rows of matrix
{col 21}{cmd:jumble()}{...}
{col 37}randomize order of rows of matrix
{col 21}{cmd:order()}{...}
{col 37}permutation vector for ordered rows
{col 21}{cmd:unorder()}{...}
{col 37}permutation vector for randomizing rows
{col 21}{cmd:_collate()}{...}
{col 37}order matrix on permutation vector

{col 5}{bf:{help mf_uniqrows:uniqrows()}}{...}
{col 21}{cmd:uniqrows()}{...}
{col 37}sorted, unique rows

{col 5}   {c TLC}{hline 9}{c TRC}
{col 5}{hline 3}{c RT}{it: Editing }{c LT}{hline}
{col 5}   {c BLC}{hline 9}{c BRC}

{col 5}{bf:{help mf__fillmissing:_fillmissing()}}{...}
{col 21}{cmd:_fillmissing()}{...}
{col 37}change matrix to contain missing values

{col 5}{bf:{help mf_editmissing:editmissing()}}{...}
{col 21}{cmd:editmissing()}{...}
{col 37}replace missing values in matrix

{col 5}{bf:{help mf_editvalue:editvalue()}}{...}
{col 21}{cmd:editvalue()}{...}
{col 37}replace values in matrix

{col 5}{bf:{help mf_edittozero:edittozero()}}{...}
{col 21}{cmd:edittozero()}{...}
{col 37}edit matrix for roundoff error (zeros)
{col 21}{cmd:edittozerotol()}{...}
{col 37}same, absolute tolerance

{col 5}{bf:{help mf_edittoint:edittoint()}}{...}
{col 21}{cmd:edittoint()}{...}
{col 37}edit matrix for roundoff error (integers)
{col 21}{cmd:edittointtol()}{...}
{col 37}same, absolute tolerance

{col 5}   {c TLC}{hline 21}{c TRC}
{col 5}{hline 3}{c RT}{it: Permutation vectors }{c LT}{hline}
{col 5}   {c BLC}{hline 21}{c BRC}

{col 5}{bf:{help mf_invorder:invorder()}}{...}
{col 21}{cmd:invorder()}{...}
{col 37}inverse of permutation vector
{col 21}{cmd:revorder()}{...}
{col 37}reverse of permutation vector

{col 5}   {c TLC}{hline 36}{c TRC}
{col 5}{hline 3}{c RT}{it: Matrices into vectors & vice versa }{c LT}{hline}
{col 5}   {c BLC}{hline 36}{c BRC}

{col 5}{bf:{help mf_vec:vec()}}{...}
{col 21}{cmd:vec()}{...}
{col 37}convert matrix into column vector
{col 21}{cmd:vech()}{...}
{col 37}convert symmetric matrix into column vector
{col 21}{cmd:invvech()}{...}
{col 37}convert column vector into symmetric matrix

{col 5}{bf:{help mf_rowshape:rowshape()}}{...}
{col 21}{cmd:rowshape()}{...}
{col 37}reshape matrix to have {it:r} rows
{col 21}{cmd:colshape()}{...}
{col 37}reshape matrix to have {it:c} columns

{col 5}   {c TLC}{hline 20}{c TRC}
{col 5}{hline 3}{c RT}{it: Associative arrays }{c LT}{hline}
{col 5}   {c BLC}{hline 20}{c BRC}

{col 5}{bf:{help mf_asarray:asarray()}}{...}
{col 21}{cmd:asarray()}{...}
{col 37}store or retrieve element in array
{col 21}{cmd:asarray_*()}{...}
{col 37}utility routines 

{col 5}{hline}


{marker description}{...}
{title:Description}

{p 4 4 2}
The above functions manipulate matrices, such as extracting the diagonal and
sorting.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-4 ManipulationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
There is a thin line between manipulation and utility; also see

   	{bf:{help m4_utility:[M-4] Utility}}    Matrix utility functions
