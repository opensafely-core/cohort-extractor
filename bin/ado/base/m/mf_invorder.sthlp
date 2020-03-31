{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] invorder()" "mansection M-5 invorder()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-1] Permutation" "help m1_permutation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Manipulation" "help m4_manipulation"}{...}
{viewerjumpto "Syntax" "mf_invorder##syntax"}{...}
{viewerjumpto "Description" "mf_invorder##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_invorder##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_invorder##remarks"}{...}
{viewerjumpto "Conformability" "mf_invorder##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_invorder##diagnostics"}{...}
{viewerjumpto "Source code" "mf_invorder##source"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[M-5] invorder()} {hline 2}}Permutation vector manipulation
{p_end}
{p2col:}({mansection M-5 invorder():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{it:real vector}
{cmd:invorder(}{it:real vector p}{cmd:)}

{p 8 16 2}
{it:real vector}
{cmd:revorder(}{it:real vector p}{cmd:)}


{p 4 8 2}
where {it:p} is assumed to be a
{help m6_glossary##permutation_vector:permutation vector}.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:invorder(}{it:p}{cmd:)} returns the permutation vector that undoes 
the permutation performed by {it:p}.  

{p 4 4 2}
{cmd:revorder(}{it:p}{cmd:)} returns the permutation vector 
that is the reverse of the permutation performed by {it:p}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 invorder()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
See {bf:{help m1_permutation:[M-1] Permutation}} for a description of
permutation vectors.  To summarize,

{p 8 12 2}
1.  Permutation vectors {it:p} are used to permute the rows or columns of a
    matrix {it:X}: {it:r} {it:x} {it:c}.

{p 12 12 2}
    If {it:p} is intended to permute the rows of {it:X}, then the 
    permuted {it:X} is obtained via {it:Y} = {it:X}{cmd:[}{it:p}{cmd:,}
    {cmd:.]}.

{p 12 12 2}
    If {it:p} is intended to permute the columns of {it:X}, then the 
    permuted {it:X} is obtained via {it:Y} = {it:X}{cmd:[.,} {it:p}{cmd:]}.

{p 8 12 2}
2.  If {it:p} is intended to permute the rows of {it:X}, it is called a
    row-permutation vector.  Row-permutation vectors are {it:r} {it:x} 1 column
    vectors.

{p 8 12 2}
3.  If {it:p} is intended to permute the columns of {it:X}, it is called a
    column-permutation vector.  Column-permutation vectors are 1 {it:x} {it:c} 
    row vectors.

{p 8 12 2}
4.  Row-permutation vectors contain a permutation of the integers 1 to {it:r}.

{p 8 12 2}
5.  Column-permutation vectors contain a permutation of the integers 1 to
    {it:c}.

{p 4 4 2}
Let us assume that {it:p} is a row-permutation vector, so that 

		{it:Y} = {it:X}{cmd:[}{it:p}{cmd:,} {cmd:.]}

{p 4 4 2}
{cmd:invorder(}{it:p}{cmd:)} returns the row-permutation vector that
undoes {it:p}:

		{it:X} = {it:Y}{cmd:[invorder(}{it:p}{cmd:),} {cmd:.]}

{p 4 4 2}
That is, using the matrix notation of 
{bf:{help m1_permutation:[M-1] Permutation}}, 

		{it:Y} = {it:P}{it:X}     implies    {it:X} = {it:P}^(-1){it:Y}

{p 4 4 2}
If {it:p} is the permutation vector corresponding to permutation matrix {it:P}, 
{cmd:invorder(}{it:p}{cmd:)} is the permutation vector corresponding 
to permutation matrix {it:P}^(-1).

{p 4 4 2}
{cmd:revorder(}{it:p}{cmd:)} returns the permutation vector that reverses 
the order of {it:p}.  For instance, say that row-permutation vector {it:p}
permutes the rows of {it:X} so that the diagonal elements are in ascending 
order.  Then 
{cmd:revorder(}{it:p}{cmd:)} would permute the rows of {it:X} so that the 
diagonal elements would be in descending order.


{marker conformability}{...}
{title:Conformability}


{p 4 4 2}
{cmd:invorder(}{it:p}{cmd:)},
{cmd:revorder(}{it:p}{cmd:)}:
{p_end}
		{it:p}:  {it:r} {it:x} 1  or  1 {it:x c}
	   {it:result}:  {it:r} {it:x} 1  or  1 {it:x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:invorder(}{it:p}{cmd:)} and 
{cmd:revorder(}{it:p}{cmd:)} 
can abort with error or can 
produce meaningless results when {it:p} is not a permutation vector.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view invorder.mata, adopath asis:invorder.mata},
{view revorder.mata, adopath asis:revorder.mata}
{p_end}
