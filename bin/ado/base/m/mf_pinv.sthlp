{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] pinv()" "mansection M-5 pinv()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] cholinv()" "help mf_cholinv"}{...}
{vieweralsosee "[M-5] fullsvd()" "help mf_fullsvd"}{...}
{vieweralsosee "[M-5] invsym()" "help mf_invsym"}{...}
{vieweralsosee "[M-5] luinv()" "help mf_luinv"}{...}
{vieweralsosee "[M-5] qrinv()" "help mf_qrinv"}{...}
{vieweralsosee "[M-5] svd()" "help mf_svd"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{vieweralsosee "[M-4] Solvers" "help m4_solvers"}{...}
{viewerjumpto "Syntax" "mf_pinv##syntax"}{...}
{viewerjumpto "Description" "mf_pinv##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_pinv##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_pinv##remarks"}{...}
{viewerjumpto "Conformability" "mf_pinv##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_pinv##diagnostics"}{...}
{viewerjumpto "Source code" "mf_pinv##source"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[M-5] pinv()} {hline 2}}Moore-Penrose pseudoinverse
{p_end}
{p2col:}({mansection M-5 pinv():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:numeric matrix}
{cmd:pinv(}{it:numeric matrix A}{cmd:)}

{p 8 12 2}
{it:numeric matrix}
{cmd:pinv(}{it:numeric matrix A}{cmd:,}
{it:rank}{cmd:)}

{p 8 12 2}
{it:numeric matrix}
{cmd:pinv(}{it:numeric matrix A}{cmd:,}
{it:rank}{cmd:,}
{it:real scalar tol}{cmd:)}


{p 8 12 2}
{it:real scalar}{bind:  }
{cmd:_pinv(}{it:numeric matrix A}{cmd:)}

{p 8 12 2}
{it:real scalar}{bind:  }
{cmd:_pinv(}{it:numeric matrix A}{cmd:,}
{it:real scalar tol}{cmd:)}


{p 4 4 2}
where the type of {it:rank} is irrelevant; the rank of {it:A} is returned
there.

{p 4 4 2}
To obtain a generalized inverse of a symmetric matrix with a different
normalization, see
{bf:{help mf_invsym:[M-5] invsym()}}.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:pinv(}{it:A}{cmd:)}
returns the unique Moore-Penrose pseudoinverse of real or complex, symmetric
or nonsymmetric, square or nonsquare matrix {it:A}.

{p 4 4 2}
{cmd:pinv(}{it:A}{cmd:,} {it:rank}{cmd:)}
does the same thing, and it returns in {it:rank} the rank of {it:A}.

{p 4 4 2}
{cmd:pinv(}{it:A}{cmd:,} {it:rank}{cmd:,} {it:tol}{cmd:)} 
does the same thing, and it allows you to specify the tolerance used to
determine the rank of {it:A}, which is also used in the calculation of the
pseudoinverse.
See 
{bf:{help mf_svsolve:[M-5] svsolve()}}
and 
{bf:{help m1_tolerance:[M-1] Tolerance}}
for information on the optional {it:tol} argument.

{p 4 4 2}
{cmd:_pinv(}{it:A}{cmd:)}
and 
{cmd:_pinv(}{it:A}{cmd:,} {it:tol}{cmd:)}
do the same thing as {cmd:pinv()}, except that {it:A} is replaced with 
its inverse and the rank is returned.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 pinv()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
The Moore-Penrose pseudoinverse is also known as the Moore-Penrose inverse and
as the generalized inverse.  Whatever you call it, the pseudoinverse
{it:A*} of {it:A} satisfies four conditions,

		{it:A}({it:A*}){it:A}    =  {it:A} 

		({it:A*}){it:A}({it:A*}) =  {it:A*}

		({it:A}({it:A*}))'  =  {it:A}({it:A*})

		(({it:A*}){it:A})'  =  ({it:A*}){it:A}

{p 4 4 2}
where the transpose operator {bf:'} is understood to mean the conjugate
transpose when {it:A} is complex.  Also, if {it:A} is of full rank,
then

		      {it:A*}  =   {it:A}^(-1)

{p 4 4 2}
{cmd:pinv(}{it:A}{cmd:)} is logically equivalent to 
{cmd:svsolve(}{it:A}{cmd:,} {cmd:I(rows(}{it:A}{cmd:)))};
see {bf:{help mf_svsolve:[M-5] svsolve()}} for details and for use 
of the optional {it:tol} argument.


{marker conformability}{...}
{title:Conformability}

    {cmd:pinv(}{it:A}{cmd:,} {it:rank}{cmd:,} {it:tol}{cmd:)}:
	{it:input}:
		{it:A}:  {it:r x c}
	      {it:tol}:  1 {it:x} 1    (optional)
	{it:output}:
	     {it:rank}:  1 {it:x} 1    (optional)
	   {it:result}:  {it:c x r}

    {cmd:_pinv(}{it:A}{cmd:,} {it:tol}{cmd:)}:
	{it:input}:
		{it:A}:  {it:r x c}
	      {it:tol}:  1 {it:x} 1    (optional)
	{it:output}:
		{it:A}:  {it:c x r}
	   {it:result}:  1 {it:x} 1    (containing rank)


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
The inverse returned by these functions is real if {it:A} is real
and is complex if {it:A} is complex.

{p 4 4 2}
{cmd:pinv(}{it:A}{cmd:,} {it:rank}{cmd:,} {it:tol}{cmd:)}
and 
{cmd:_pinv(}{it:A}{cmd:,} {it:tol}{cmd:)}
return missing results 
if {it:A} contains missing values.  

{p 4 4 2}
{cmd:pinv()} and {cmd:_pinv()} also return missing values if the algorithm for
computing the SVD,
{bf:{help mf_svd:[M-5] svd()}},
fails to converge.  This is a near zero-probability event.
Here {it:rank} also is returned as missing.

{p 4 4 2}
See 
{bf:{help mf_svsolve:[M-5] svsolve()}}
and 
{bf:{help m1_tolerance:[M-1] Tolerance}}
for information on the optional {it:tol} argument.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view pinv.mata, adopath asis:pinv.mata},
{view _pinv.mata, adopath asis:_pinv.mata},
{view rank_from_singular_values.mata, adopath asis:rank_from_singular_values.mata}
{p_end}
