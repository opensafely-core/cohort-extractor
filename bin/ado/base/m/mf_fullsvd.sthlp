{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[M-5] fullsvd()" "mansection M-5 fullsvd()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] norm()" "help mf_norm"}{...}
{vieweralsosee "[M-5] pinv()" "help mf_pinv"}{...}
{vieweralsosee "[M-5] rank()" "help mf_rank"}{...}
{vieweralsosee "[M-5] svd()" "help mf_svd"}{...}
{vieweralsosee "[M-5] svsolve()" "help mf_svsolve"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{viewerjumpto "Syntax" "mf_fullsvd##syntax"}{...}
{viewerjumpto "Description" "mf_fullsvd##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_fullsvd##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_fullsvd##remarks"}{...}
{viewerjumpto "Conformability" "mf_fullsvd##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_fullsvd##diagnostics"}{...}
{viewerjumpto "Source code" "mf_fullsvd##source"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[M-5] fullsvd()} {hline 2}}Full singular value decomposition
{p_end}
{p2col:}({mansection M-5 fullsvd():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{it:void}{bind:             }
{cmd:fullsvd(}{it:numeric matrix A}{cmd:,} {it:U}{cmd:,} {it:s}{cmd:,} {it:Vt}{cmd:)}

{p 8 8 2}
{it:numeric matrix} {bind:  }
{cmd:fullsdiag(}{it:numeric colvector s}{cmd:,} {it:real scalar k}{cmd:)}


{p 8 8 2}
{it:void}{bind:            }
{cmd:_fullsvd(}{it:numeric matrix A}{cmd:,} {it:U}{cmd:,} {it:s}{cmd:,} {it:Vt}{cmd:)}


{p 8 8 2}
{it:real scalar} {bind:    }
{cmd:_svd_la(}{it:numeric matrix A}{cmd:,} {it:U}{cmd:,} {it:s}{cmd:,} {it:Vt}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:fullsvd(}{it:A}, {it:U}, {it:s}, {it:Vt}{cmd:)}
calculates the singular value decomposition of {it:m x n} matrix
{it:A}, returning the result in {it:U}, {it:s}, and {it:Vt}.
Singular values in {it:s} are sorted from largest to smallest.

{p 4 4 2}
{cmd:fullsdiag(}{it:s, k}{cmd:)} 
converts column vector {it:s} returned by {cmd:fullsvd()}
into matrix {it:S}.  In all cases, the appropriate call for this function 
is

		{it:S} = {cmd:fullsdiag(}{it:s}{cmd:,} {cmd:rows(}{it:A}{cmd:)-cols(}{it:A}{cmd:))}

{p 4 4 2}
{cmd:_fullsvd(}{it:A}, {it:U}, {it:s}, {it:Vt}{cmd:)}
does the same as {cmd:fullsvd()}, except that, in the process, it destroys 
{it:A}.  Use of {cmd:_fullsvd()} in place of {cmd:fullsvd()} conserves memory.

{p 4 4 2}
{cmd:_svd_la()} 
is the interface into the 
{bf:{help m1_lapack:[M-1] LAPACK}} SVD routines and is used in the
implementation of the previous functions.  There is no reason you should want
to use it.
{cmd:_svd_la()}
is similar to {cmd:_fullsvd()}.  It differs in that it returns a real scalar
equal to 1 if the numerical routines fail to converge, and it returns 0
otherwise.  The previous SVD routines set {it:s} to contain missing values in
this unlikely case.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 fullsvd()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_fullsvd##remarks1:Introduction}
	{help mf_fullsvd##remarks2:Relationship between the full and thin SVDs}
	{help mf_fullsvd##remarks3:The contents of s}
	{help mf_fullsvd##remarks4:Possibility of convergence problems}

{p 4 4 2}
Documented here is the full SVD, appropriate in all cases, but of 
interest mainly when {it:A}: {it:m x n}, {it:m}<{it:n}.
There is a thin SVD that conserves memory when {it:m}>={it:n}; 
see {bf:{help mf_svd:[M-5] svd()}}.  The relationship between the 
two is discussed in 
{it:{help mf_fullsvd##remarks2:Relationship between the full and thin SVDs}}
below.


{marker remarks1}{...}
{title:Introduction}

{p 4 4 2}
The SVD is used to compute accurate solutions to linear systems and
least-squares problems, to compute the 2-norm, and to determine the numerical
rank of a matrix.

{p 4 4 2}
The singular value decomposition (SVD) of {it:A}: {it:m x n} is given by

		{it:A} = {it:U} * {it:S} * {it:V}{cmd:'}

{p 4 4 2}
   where 

		{it:U}:  {it:m x m}  and  orthogonal (unitary)
   		{it:S}:  {it:m x n}  and  diagonal
		{it:V}:  {it:n x n}  and  orthogonal (unitary)

{p 4 4 2}
When {it:A} is complex, the transpose operator {cmd:'} is understood to
mean the conjugate transpose operator.

{p 4 4 2}
Diagonal matrix {it:S} contains the singular values and those singular values
are real even when {it:A} is complex.  It is usual (but not required) that
{it:S} is arranged so that the largest singular value appears first, then the
next largest, and so on.  The SVD routines documented here do this.

{p 4 4 2}
The full SVD
routines return {it:U} and {it:Vt}={it:V}{cmd:'}.  {it:S} is
returned as a column vector {it:s}, and {it:S} can be obtained by 

		{it:S} = {cmd:fullsdiag(}{it:s}{cmd:,} {cmd:rows(}{it:A}{cmd:)-cols(}{it:A}{cmd:))}

{p 4 4 2}
so we will write the SVD as

		{it:A} = {it:U} * {cmd:fullsdiag(}{it:s}{cmd:,} {cmd:rows(}{it:A}{cmd:)-cols(}{it:A}{cmd:))} * {it:Vt}

{p 4 4 2}
Function {cmd:fullsvd(}{it:A}{cmd:,} {it:U}{cmd:,} {it:s}{cmd:,} {it:Vt}{cmd:)}
returns the {it:U}, {it:s}, and {it:Vt} corresponding to {it:A}.


{marker remarks2}{...}
{title:Relationship between the full and thin SVDs}

{p 4 4 2}
A popular variant of the SVD is known as the thin SVD and is suitable 
for use when {it:m} >= {it:n}.  Both SVDs have the same formula, 

		{it:A} = {it:U} * {it:S} * {it:V}{cmd:'}

{p 4 4 2}
but {it:U} and {it:S} have reduced dimensions in the thin version:

                Matrix   Full SVD      Thin SVD
		{hline 31}
		{it:U}:        {it:m x m}         {it:m x n}
   		{it:S}:        {it:m x n}         {it:n x n}
		{it:V}:        {it:n x n}         {it:n x n}
		{hline 31}

{p 4 4 2}
When {it:m} = {it:n}, the two variants are identical.

{p 4 4 2}
The thin SVD is of use when {it:m}>{it:n}, because then only the
first {it:n} diagonal elements of {it:S} are nonzero, and therefore only the
first {it:n} columns of {it:U} are relevant in 
{bind:{it:A} = {it:U}{it:S}{it:V}{cmd:'}}.
There are considerable memory savings to be had in calculating the 
thin SVD when {it:m} >> {it:n}.

{p 4 4 2}
As a result, many people call the thin SVD the SVD and ignore the 
full SVD altogether.  If the matrices you deal with have {it:m} >= {it:n}, 
you will want to do the same.
To obtain the thin SVD, see 
{bf:{help mf_svd:[M-5] svd()}}.

{p 4 4 2}
Regardless of the dimension of your matrix, 
you may wish to obtain only the singular values.  In this case, 
see {cmd:svdsv()} documented in 
{bf:{help mf_svd:[M-5] svd()}}.  That function is appropriate in all cases.


{marker remarks3}{...}
{title:The contents of s}

{p 4 4 2}
Given {it:A}: {it:m x n}, the singular values are returned in 
{it:s}: min({it:m},{it:n}} {it:x} 1.

{p 4 4 2}
Let's consider the {it:m} = {it:n} case first.  {it:A} is {it:m x m} and the
{it:m} singular values are returned in {it:s}, an {it:m} {it:x} 1 column
vector.  If {it:A} were 3 {it:x} 3, perhaps we would get back 

	: {cmd:s}
	{res}       {txt}    1
	    {c TLC}{hline 9}{c TRC}
	  1 {c |}  {res}13.47{txt}  {c |}
	  2 {c |}  {res}  5.8{txt}  {c |}
	  3 {c |}  {res} 2.63{txt}  {c |}
	    {c BLC}{hline 9}{c BRC}

{p 4 4 2}
If we needed it, we could obtain {it:S} from {it:s} simply by
creating a diagonal matrix from {it:s}

	: {it:S} {cmd:= diag(}{it:s}{cmd:)}
	: {it:S}
	{res}       {txt}    1       2       3
	    {c TLC}{hline 25}{c TRC}
	  1 {c |}  {res}13.47       0       0{txt}  {c |}
	  2 {c |}  {res}    0     5.8       0{txt}  {c |}
	  3 {c |}  {res}    0       0    2.63{txt}  {c |}
	    {c BLC}{hline 25}{c BRC}

{p 4 4 2}
although the official way we are supposed to do this is 

	: {it:S} {cmd:= fullsdiag(}{it:s}{cmd:, rows(}{it:A}{cmd:)-cols(}{it:A}{cmd:))}

{p 4 4 2}
and that will return the same result.

{p 4 4 2}
Now let's consider {it:m} < {it:n}.  Let's pretend that {it:A} is 3 {it:x} 4.  
The singular values will be returned in 3 {it:x} 1 vector {it:s}.
For instance, {it:s} might still contain

	: {cmd:s}
	{res}       {txt}    1
	    {c TLC}{hline 9}{c TRC}
	  1 {c |}  {res}13.47{txt}  {c |}
	  2 {c |}  {res}  5.8{txt}  {c |}
	  3 {c |}  {res} 2.63{txt}  {c |}
	    {c BLC}{hline 9}{c BRC}

{p 4 4 2}
The {it:S} matrix here needs to be 3 {it:x} 4, and 
{cmd:fullsdiag()} will form it:

	: {cmd:fullsdiag(s, rows(A)-cols(A))}
	{res}       {txt}    1       2       3       4
	    {c TLC}{hline 33}{c TRC}
	  1 {c |}  {res}13.47       0       0       0{txt}  {c |}
	  2 {c |}  {res}    0     5.8       0       0{txt}  {c |}
	  3 {c |}  {res}    0       0    2.63       0{txt}  {c |}
	    {c BLC}{hline 33}{c BRC}

{p 4 4 2}
The final case is {it:m} > {it:n}.  We will pretend that {it:A} is 4 {it:x} 3.
The {it:s} vector we get back will look the same

	: {cmd:s}
	{res}       {txt}    1
	    {c TLC}{hline 9}{c TRC}
	  1 {c |}  {res}13.47{txt}  {c |}
	  2 {c |}  {res}  5.8{txt}  {c |}
	  3 {c |}  {res} 2.63{txt}  {c |}
	    {c BLC}{hline 9}{c BRC}

{p 4 4 2}
but this time, we need a 4 {it:x} 3 rather than a 3 {it:x} 4 
matrix formed from it.  

	: {cmd:fullsdiag(s, rows(A)-cols(A))}
	{res}       {txt}    1       2       3
	    {c TLC}{hline 25}{c TRC}
	  1 {c |}  {res}13.47       0       0{txt}  {c |}
	  2 {c |}  {res}    0     5.8       0{txt}  {c |}
	  3 {c |}  {res}    0       0    2.63{txt}  {c |}
	  4 {c |}  {res}    0       0       0{txt}  {c |}
	    {c BLC}{hline 25}{c BRC}


{marker remarks4}{...}
{title:Possibility of convergence problems}

{p 4 4 2}
See 
{it:{help mf_svd##remarks2:Possibility of convergence problems}}
in 
{bf:{help mf_svd:[M-5] svd()}}; what is said there applies equally here.


{marker conformability}{...}
{title:Conformability}

    {cmd:fullsvd(}{it:A}, {it:U}, {it:s}, {it:Vt}{cmd:)}:
	{it:input:}
		{it:A}:  {it:m x n}
       {it:output:}
	        {it:U}:  {it:m x m}
	        {it:s}:  min({it:m},{it:n}) {it:x} 1
	       {it:Vt}:  {it:n x n}
	   {it:result}:  {it:void}
		 
    {cmd:fullsdiag(}{it:s, k}{cmd:)}:
	{it:input:}
		{it:s}:  {it:r x} 1
		{it:k}:  1 {it:x} 1
	   {it:result}:  {it:r}+{it:k} {it:x r}, if k>=0
		    {it:r x} {it:r}-{it:k}, otherwise

    {cmd:_fullsvd(}{it:A}, {it:U}, {it:s}, {it:Vt}{cmd:)}:
	{it:input:}
		{it:A}:  {it:m x n}
       {it:output:}
		{it:A}:  0 {it:x} 0
	        {it:U}:  {it:m x m}
	        {it:s}:  min({it:m},{it:n}) {it:x} 1
	       {it:Vt}:  {it:n x n}
	   {it:result}:  {it:void}

    {cmd:_svd_la(}{it:A}, {it:U}, {it:s}, {it:Vt}{cmd:)}:
	{it:input:}
		{it:A}:  {it:m x n}
       {it:output:}
		{it:A}:  {it:m x n}, but contents changed
	        {it:U}:  {it:m x m}
	        {it:s}:  min({it:m},{it:n}) {it:x} 1
	       {it:Vt}:  {it:n x n}
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:fullsvd(}{it:A}, {it:U}, {it:s}, {it:Vt}{cmd:)}
and 
{cmd:_fullsvd(}{it:A}, {it:s}, {it:Vt}{cmd:)}
return missing results if {it:A} contains missing.
In all other cases, the routines should work, but there is the 
unlikely possibility of convergence problems, in which case 
missing results will also be returned; see 
{it:{help mf_svd##remarks2:Possibility of convergence problems}}
in {bf:{help mf_svd:[M-5] svd()}}.

{p 4 4 2}
{cmd:_fullsvd()} aborts with error if {it:A} is a view.

{p 4 4 2}
Direct use of {cmd:_svd_la()} is not recommended.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view fullsvd.mata, adopath asis:fullsvd.mata},
{view fullsdiag.mata, adopath asis:fullsdiag.mata},
{view _fullsvd.mata, adopath asis:_fullsvd.mata},
{cmd:_svd_la()} is built in.
{p_end}
