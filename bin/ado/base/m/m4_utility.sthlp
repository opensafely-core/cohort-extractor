{smcl}
{* *! version 1.1.8  15may2018}{...}
{vieweralsosee "[M-4] Utility" "mansection M-4 Utility"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Intro" "help m4_intro"}{...}
{viewerjumpto "Contents" "m4_utility##contents"}{...}
{viewerjumpto "Description" "m4_utility##description"}{...}
{viewerjumpto "Links to PDF documentation" "m4_utility##linkspdf"}{...}
{viewerjumpto "Remarks" "m4_utility##remarks"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[M-4] Utility} {hline 2}}Matrix utility functions
{p_end}
{p2col:}({mansection M-4 Utility:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker contents}{...}
{title:Contents}

{col 5}   [M-5]
{col 5}Manual entry{col 21}Function{col 39}Purpose
{col 5}{hline}

{col 5}   {c TLC}{hline 9}{c TRC}
{col 5}{hline 3}{c RT}{it: Complex }{c LT}{hline}
{col 5}   {c BLC}{hline 9}{c BRC}

{col 5}{bf:{help mf_re:Re()}}{...}
{col 21}{cmd:Re()}{...}
{col 39}real part
{col 21}{cmd:Im()}{...}
{col 39}imaginary part

{col 5}{bf:{help mf_c:C()}}{...}
{col 21}{cmd:C()}{...}
{col 39}make complex

{col 5}   {c TLC}{hline 14}{c TRC}
{col 5}{hline 3}{c RT}{it: Shape & type }{c LT}{hline}
{col 5}   {c BLC}{hline 14}{c BRC}

{col 5}{bf:{help mf_rows:rows()}}{...}
{col 21}{cmd:rows()}{...}
{col 39}number of rows
{col 21}{cmd:cols()}{...}
{col 39}number of columns
{col 21}{cmd:length()}{...}
{col 39}number of elements of vector

{col 5}{bf:{help mf_eltype:eltype()}}{...}
{col 21}{cmd:eltype()}{...}
{col 39}element type of object
{col 21}{cmd:orgtype()}{...}
{col 39}organizational type of object
{col 21}{cmd:classname()}{...}
{col 39}class name of a Mata class scalar
{col 21}{cmd:structname()}{...}
{col 39}struct name of a Mata struct scalar

{col 5}{bf:{help mf_isreal:isreal()}}{...}
{col 21}{cmd:isreal()}{...}
{col 39}object is real matrix
{col 21}{cmd:iscomplex()}{...}
{col 39}object is complex matrix
{col 21}{cmd:isstring()}{...}
{col 39}object is string matrix
{col 21}{cmd:ispointer()}{...}
{col 39}object is pointer matrix

{col 5}{bf:{help mf_isrealvalues:isrealvalues()}}{...}
{col 21}{cmd:isrealvalues()}{...}
{col 39}whether matrix contains only real values

{col 5}{bf:{help mf_isview:isview()}}{...}
{col 21}{cmd:isview()}{...}
{col 39}whether matrix is view

{col 5}   {c TLC}{hline 12}{c TRC}
{col 5}{hline 3}{c RT}{it: Properties }{c LT}{hline}
{col 5}   {c BLC}{hline 12}{c BRC}

{col 5}{bf:{help mf_issymmetric:issymmetric()}}{...}
{col 21}{cmd:issymmetric()}{...}
{col 39}whether matrix is symmetric (Hermitian)
{col 21}{cmd:issymmetriconly()}{...}
{col 39}whether matrix is mechanically symmetric

{col 5}{bf:{help mf_isdiagonal:isdiagonal()}}{...}
{col 21}{cmd:isdiagonal()}{...}
{col 39}whether matrix is diagonal

{col 5}{bf:{help mf_diag0cnt:diag0cnt()}}{...}
{col 21}{cmd:diag0cnt()}{...}
{col 39}count 0s on diagonal

{col 5}   {c TLC}{hline 11}{c TRC}
{col 5}{hline 3}{c RT}{it: Selection }{c LT}{hline}
{col 5}   {c BLC}{hline 11}{c BRC}

{col 5}{bf:{help mf_select:select()}}{...}
{col 21}{cmd:select()}{...}
{col 39}select rows or columns
{col 21}{cmd:st_select()}{...}
{col 39}select rows or columns of view
{col 21}{cmd:selectindex()}{...}
{col 39}select indices

{col 5}   {c TLC}{hline 16}{c TRC}
{col 5}{hline 3}{c RT}{it: Missing values }{c LT}{hline}
{col 5}   {c BLC}{hline 16}{c BRC}

{col 5}{bf:{help mf_missing:missing()}}{...}
{col 21}{cmd:missing()}{...}
{col 39}count of missing values
{col 21}{cmd:rowmissing()}{...}
{col 39}count of missing values, by row
{col 21}{cmd:colmissing()}{...}
{col 39}count of missing values, by column
{col 21}{cmd:nonmissing()}{...}
{col 39}count of nonmissing values
{col 21}{cmd:rownonmissing()}{...}
{col 39}count of nonmissing values, by row
{col 21}{cmd:colnonmissing()}{...}
{col 39}count of nonmissing values, by column
{col 21}{cmd:hasmissing()}{...}
{col 39}whether matrix has missing values

{col 5}{bf:{help mf_missingof:missingof()}}{...}
{col 21}{cmd:missingof()}{...}
{col 39}appropriate missing value

{col 5}   {c TLC}{hline 31}{c TRC}
{col 5}{hline 3}{c RT}{it: Range, sums, & cross products }{c LT}{hline}
{col 5}   {c BLC}{hline 31}{c BRC}


{col 5}{bf:{help mf_minmax:minmax()}}{...}
{col 21}{cmd:rowmin()}{...}
{col 39}minimum, by row
{col 21}{cmd:colmin()}{...}
{col 39}minimum, by column
{col 21}{cmd:min()}{...}
{col 39}minimum, overall
{col 21}{cmd:rowmax()}{...}
{col 39}maximum, by row
{col 21}{cmd:colmax()}{...}
{col 39}maximum, by column
{col 21}{cmd:max()}{...}
{col 39}maximum, overall
{col 21}{cmd:rowminmax()}{...}
{col 39}minimum and maximum, by row
{col 21}{cmd:colminmax()}{...}
{col 39}minimum and maximum, by column
{col 21}{cmd:minmax()}{...}
{col 39}minimum and maximum, overall
{col 21}{cmd:rowmaxabs()}{...}
{col 39}{cmd:rowmax(abs())}
{col 21}{cmd:colmaxabs()}{...}
{col 39}{cmd:colmax(abs())}

{col 5}{bf:{help mf_minindex:minindex()}}{...}
{col 21}{cmd:minindex()}{...}
{col 39}indices of minimums
{col 21}{cmd:maxindex()}{...}
{col 39}indices of maximums

{col 5}{bf:{help mf_sum:sum()}}{...}
{col 21}{cmd:rowsum()}{...}
{col 39}sum of each row
{col 21}{cmd:colsum()}{...}
{col 39}sum of each column
{col 21}{cmd:sum()}{...}
{col 39}overall sum
{col 21}{cmd:quadrowsum()}{...}
{col 39}quad-precision sum of each row
{col 21}{cmd:quadcolsum()}{...}
{col 39}quad-precision sum of each column
{col 21}{cmd:quadsum()}{...}
{col 39}quad-precision overall sum

{col 5}{bf:{help mf_runningsum:runningsum()}}{...}
{col 21}{cmd:runningsum()}{...}
{col 39}running sum of vector
{col 21}{cmd:quadrunningsum()}{...}
{col 39}quad-precision {cmd:runningsum()}

{col 5}{bf:{help mf_cross:cross()}}{...}
{col 21}{cmd:cross()}{...}
{col 39}{it:X}'{it:X}, {it:X}'{it:Z}, etc.

{col 5}{bf:{help mf_crossdev:crossdev()}}{...}
{col 21}{cmd:crossdev()}{...}
{col 39}({it:X}:-{it:x})'({it:X}:-{it:x}), ({it:X}:-{it:x})'({it:Z}:-{it:z}), etc.

{col 5}{bf:{help mf_quadcross:quadcross()}}{...}
{col 21}{cmd:quadcross()}{...}
{col 39}quad-precision {cmd:cross()}
{col 21}{cmd:quadcrossdev()}{...}
{col 39}quad-precision {cmd:crossdev()}

{col 5}   {c TLC}{hline 13}{c TRC}
{col 5}{hline 3}{c RT}{it: Programming }{c LT}{hline}
{col 5}   {c BLC}{hline 13}{c BRC}

{col 5}{bf:{help mf_reldif:reldif()}}{...}
{col 21}{cmd:reldif()}{...}
{col 39}relative difference
{col 21}{cmd:mreldif()}{...}
{col 39}max. relative difference between matrices
{col 21}{cmd:mreldifsym()}{...}
{col 39}max. relative difference from symmetry
{col 21}{cmd:mreldifre()}{...}
{col 39}max. relative difference from real

{col 5}{bf:{help mf_all:all()}}{...}
{col 21}{cmd:all()}{...}
{col 39}{cmd:sum(!}{it:L}{cmd:)==0}
{col 21}{cmd:any()}{...}
{col 39}{cmd:sum(}{it:L}{cmd:)!=0}
{col 21}{cmd:allof()}{...}
{col 39}{cmd:all(}{it:P}{cmd::==}{it:s}{cmd:)}
{col 21}{cmd:anyof()}{...}
{col 39}{cmd:any(}{it:P}{cmd::==}{it:s}{cmd:)}

{col 5}{bf:{help mf_panelsetup:panelsetup()}}{...}
{col 21}{cmd:panelsetup()}{...}
{col 39}initialize panel-data processing
{col 21}{cmd:panelstats()}{...}
{col 39}summary statistics on panels
{col 21}{cmd:panelsubmatrix()}{...}
{col 39}obtain matrix for panel {it:i}
{col 21}{cmd:panelsubview()}{...}
{col 39}obtain view matrix for panel {it:i}

{col 5}{bf:{help mf__negate:_negate()}}{...}
{col 21}{cmd:_negate()}{...}
{col 39}fast negation of matrix

{col 5}   {c TLC}{hline 24}{c TRC}
{col 5}{hline 3}{c RT}{it: Constants & tolerances }{c LT}{hline}
{col 5}   {c BLC}{hline 24}{c BRC}

{col 5}{bf:{help mf_mindouble:mindouble()}}{...}
{col 21}{cmd:mindouble()}{...}
{col 39}minimum nonmissing value
{col 21}{cmd:maxdouble()}{...}
{col 39}maximum nonmissing value
{col 21}{cmd:smallestdouble()}{...}
{col 39}smallest {it:e}>0

{col 5}{bf:{help mf_epsilon:epsilon()}}{...}
{col 21}{cmd:epsilon()}{...}
{col 39}unit roundoff error

{col 5}{bf:{help mf_floatround:floatround()}}{...}
{col 21}{cmd:floatround()}{...}
{col 39}round to float precision

{col 5}{bf:{help mf_solve_tol:solve_tol()}}{...}
{col 21}{cmd:solve_tol()}{...}
{col 39}tolerance used by solvers and inverters

{col 5}{hline}


{marker description}{...}
{title:Description}

{p 4 4 2}
Matrix utility functions tell you something about the matrix, such as 
the number of rows or whether it is diagonal.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-4 UtilityRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
There is a thin line between utility and manipulation; also see

	{bf:{help m4_manipulation:[M-4] Manipulation}}             Matrix manipulation functions
