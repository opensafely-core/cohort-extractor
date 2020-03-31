{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[M-5] lud()" "mansection M-5 lud()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] det()" "help mf_det"}{...}
{vieweralsosee "[M-5] lusolve()" "help mf_lusolve"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{viewerjumpto "Syntax" "mf_lud##syntax"}{...}
{viewerjumpto "Description" "mf_lud##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_lud##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_lud##remarks"}{...}
{viewerjumpto "Conformability" "mf_lud##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_lud##diagnostics"}{...}
{viewerjumpto "Source code" "mf_lud##source"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[M-5] lud()} {hline 2}}LU decomposition
{p_end}
{p2col:}({mansection M-5 lud():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{it:void}{bind: }
{cmd:lud(}{it:numeric matrix A}{cmd:,} {it:L}{cmd:,} {it:U}{cmd:,}
{it:p}{cmd:)}

{p 8 8 2}
{it:void}
{cmd:_lud(}{it:numeric matrix L}{cmd:,} {it:U}{cmd:,}
{it:p}{cmd:)}

{p 8 8 2}
{it:void}
{cmd:_lud_la(}{it:numeric matrix A}, {it:q}{cmd:)}


{p 4 4 2}
where

{p 8 12 2}
1.  {it:A} may be real or complex and need not be square.

{p 8 12 2}
2.  The types of {it:L}, {it:U}, {it:p}, and {it:q} are irrelevant; 
    results are returned there.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:lud(}{it:A}{cmd:,} {it:L}{cmd:,} {it:U}{cmd:,} {it:p}{cmd:)}
returns the LU decomposition (with partial pivoting) of {it:A} in {it:L} and
{it:U} along with a permutation vector {it:p}.  The returned results are such
that {it:A} = {it:L}{cmd:[}{it:p}{cmd:,.]}*{it:U} up to roundoff error.

{p 4 4 2}
{cmd:_lud(}{it:L}{cmd:,} {it:U}{cmd:,} {it:p}{cmd:)} is similar to
{cmd:lud()}, except that it conserves memory.  The matrix to be decomposed is
passed in {it:L}, and the same storage location is overwritten with the 
calculated {it:L} matrix.

{p 4 4 2}
{cmd:_lud_la(}{it:A}, {it:q}{cmd:)} is the 
{bf:{help m1_lapack:[M-1] LAPACK}} routine that 
the above functions use to calculate the 
LU decomposition.  
See {it:{help mf_lud##remarks2:LAPACK routine}} below.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 lud()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_lud##remarks1:LU decomposition}
	{help mf_lud##remarks2:LAPACK routine}


{marker remarks1}{...}
{title:LU decomposition}

{p 4 4 2}
The LU decomposition of matrix {it:A} can be written as

		{it:P}'{it:A} = {it:L}{it:U}

{p 4 4 2}
where {it:P}' is a 
{help m6_glossary##permutation_matrix:permutation matrix} that permutes the
rows of {it:A}.  {it:L} is lower triangular and {it:U} is upper triangular.
The decomposition can also be written as

		{it:A} = {it:P}{it:L}{it:U}

{p 4 4 2}
because, given that {it:P} is a permutation matrix, {it:P}^(-1) = {it:P}'.

{p 4 4 2}
Rather than returning {it:P} directly, returned is {it:p} 
corresponding to {it:P}.  Lowercase {it:p} is a 
column vector that contains the subscripts of the rows in the desired
order.  That is,

		{it:P}{it:L} = {it:L}{cmd:[}{it:p}{cmd:,.]}

{p 4 4 2}
The advantage of this is that {it:p} requires less memory than {it:P} and 
the reorganization, should it be desired, can be performed more quickly; 
see {bf:{help m1_permutation:[M-1] Permutation}}.
In any case, the formula defining the LU decomposition can be written as

		{it:A} = {it:L}{cmd:[}{it:p}{cmd:,.]}*{it:U}

{p 4 4 2}
One can also write 

		{it:B} = {it:L}{it:U}, where {it:B}{cmd:[}{it:p}{cmd:,.]} = {it:A}


{marker remarks2}{...}
{title:LAPACK routine}

{p 4 4 2}
{cmd:_lud_la(}{it:A}, {it:q}{cmd:)} is the interface into the 
{bf:{help m1_lapack:[M-1] LAPACK}} routines
that the above functions use to calculate the LU decomposition.  You may use
it directly if you wish.

{p 4 4 2}
Matrix {it:A} is decomposed,
and the decomposition is placed back in {it:A}.  
{it:U} is stored in the upper triangle (including the diagonal) of {it:A}.
{it:L} is stored in the lower triangle of {it:A}, and it is understood that
{it:L} is supposed to have ones on its diagonal.  {it:q} is a column vector
recording the row swaps that account for the pivoting.  This is the same
information as stored in {it:p}, but in a different format.

{p 4 4 2}
{it:q} records the row swaps to be made.  For instance, {it:q} = (1\2\2)
means that (start at the end) the third row is to be swapped with the 
second row, then the second row is to stay where it is, and finally the 
first row is to stay where it is.  {it:q} can be converted into {it:p} 
by the following logic:

	{it:p}{cmd: = 1::rows(}{it:q}{cmd:)}
	{cmd:for (i=rows(}{it:q}{cmd:); i>=1; i--) {c -(}}
		{cmd:hold = }{it:p}{cmd:[i]}
		{it:p}{cmd:[i] = }{it:p}{cmd:[}{it:q}{cmd:[i]]}
		{it:p}{cmd:[}{it:q}{cmd:[i]] = hold}
	{cmd:{c )-}}


{marker conformability}{...}
{title:Conformability}

{p 4 8 2}
{cmd:lud(}{it:A}{cmd:,} {it:L}{cmd:,} {it:U}{cmd:,}
{it:p}{cmd:)}:
{p_end}
	{it:input:}
		{it:A}:  {it:r x c}
	{it:output:}
		{it:L}:  {it:r x m}, {it:m} = min({it:r}, {it:c})
		{it:U}:  {it:m x c}
		{it:p}:  {it:r x} 1


{p 4 8 2}
{cmd:_lud(}{it:L}{cmd:,} {it:U}{cmd:,}
{it:p}{cmd:)}:
{p_end}
	{it:input:}
		{it:L}:  {it:r x c}
	{it:output:}
		{it:L}:  {it:r x m}, {it:m} = min({it:r}, {it:c})
		{it:U}:  {it:m x c}
		{it:p}:  {it:r x} 1

{p 4 8 2}
{cmd:_lud_la(}{it:A}, {it:q}{cmd:)}
{p_end}
	{it:input:}
		{it:A}:  {it:r x c}
	{it:output:}
		{it:A}:  {it:r x c}
		{it:q}:  {it:r x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
    {cmd:lud(}{it:A}{cmd:,} {it:L}{cmd:,} {it:U}{cmd:,} {it:p}{cmd:)} 
    returns missing results if {it:A} contains missing values;
    {it:L} will have missing values below the diagonal, 1s on the diagonal, 
    and 0s above the diagonal; 
    {it:U} will have missing values on and above the diagonal and 0s below.
    Thus if there are missing values, {it:U}[1,1] will contain missing.

{p 4 4 2}
    {cmd:_lud(}{it:L}{cmd:,} {it:U}{cmd:,} {it:p}{cmd:)} sets {it:L} and 
    {it:U} as described above if {it:A} contains missing values.
    
{p 4 4 2}
    {cmd:_lud_la(}{it:A}, {it:q}{cmd:)}
    aborts with error if {it:A} is a view.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view lud.mata, adopath asis:lud.mata},
{view _lud.mata, adopath asis:_lud.mata};
{cmd:_lud_la()} is built in.
{p_end}
