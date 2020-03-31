{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[M-5] svd()" "mansection M-5 svd()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] fullsvd()" "help mf_fullsvd"}{...}
{vieweralsosee "[M-5] norm()" "help mf_norm"}{...}
{vieweralsosee "[M-5] pinv()" "help mf_pinv"}{...}
{vieweralsosee "[M-5] rank()" "help mf_rank"}{...}
{vieweralsosee "[M-5] svsolve()" "help mf_svsolve"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{viewerjumpto "Syntax" "mf_svd##syntax"}{...}
{viewerjumpto "Description" "mf_svd##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_svd##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_svd##remarks"}{...}
{viewerjumpto "Conformability" "mf_svd##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_svd##diagnostics"}{...}
{viewerjumpto "Source code" "mf_svd##source"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[M-5] svd()} {hline 2}}Singular value decomposition
{p_end}
{p2col:}({mansection M-5 svd():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{it:void}{bind:             }
{cmd:svd(}{it:numeric matrix A}, {it:U}, {it:s}, {it:Vt}{cmd:)}

{p 8 8 2}
{it:real colvector} {bind:  }
{cmd:svdsv(}{it:numeric matrix A}{cmd:)}


{p 8 8 2}
{it:void}{bind:            }
{cmd:_svd(}{it:numeric matrix A}, {it:s}, {it:Vt}{cmd:)}

{p 8 8 2}
{it:real colvector}{bind:  }
{cmd:_svdsv(}{it:numeric matrix A}{cmd:)}


{p 8 8 2}
{it:real scalar} {bind:    }
{cmd:_svd_la(}{it:numeric matrix A}, {it:s}, {it:Vt}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:svd(}{it:A}, {it:U}, {it:s}, {it:Vt}{cmd:)}
calculates the singular value decomposition of {it:A}: {it:m x n}, 
{it:m}>={it:n},
returning the result in {it:U}, {it:s}, and {it:Vt}.
Singular values returned in {it:s} are sorted from largest to smallest.

{p 4 4 2}
{cmd:svdsv(}{it:A}{cmd:)}
returns the singular values of {it:A}: {it:m x n}, {it:m}>={it:n} or 
{it:m}<{it:n} (that is, no restriction), 
in a column vector of length
min({it:m}{cmd:,}{it:n}).
{it:U} and {it:Vt} are not calculated.

{p 4 4 2}
{cmd:_svd(}{it:A}, {it:s}, {it:Vt}{cmd:)}
does the same as {cmd:svd()}, except that it returns {it:U} in {it:A}.
Use of {cmd:_svd()} conserves memory.

{p 4 4 2}
{cmd:_svdsv(}{it:A}{cmd:)}
does the same as {cmd:svdsv()}, except that, in the process, it destroys 
{it:A}.  Use of {cmd:_svdsv()} conserves memory.

{p 4 4 2}
{cmd:_svd_la()} 
is the interface into the 
{bf:{help m1_lapack:[M-1] LAPACK}} SVD routines and is used in the
implementation of the previous functions.  There is no reason you should want
to use it.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 svd()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_svd##remarks1:Introduction}
	{help mf_svd##remarks2:Possibility of convergence problems}

{p 4 4 2}
Documented here is the thin SVD, appropriate for use with 
{it:A}: {it:m x n}, {it:m}>={it:n}. 
See {bf:{help mf_fullsvd:[M-5] fullsvd()}}
for the full SVD, appropriate for use in all cases.  The relationship 
between the two is discussed in 
{it:{help mf_fullsvd##remarks2:Relationship between the full and thin SVDs}} in 
{bf:{help mf_fullsvd:[M-5] fullsvd()}}.

{p 4 4 2}
Use of the thin SVD -- the functions documented here -- is preferred when
{it:m}>={it:n}.


{marker remarks1}{...}
{title:Introduction}

{p 4 4 2}
The SVD is used to compute accurate solutions to linear systems and
least-squares problems, to compute the 2-norm, and to determine the numerical
rank of a matrix.

{p 4 4 2}
The singular value decomposition (SVD) of {it:A}: {it:m x n}, {it:m}>={it:n},
is given by

		{it:A} = {it:U} * diag({it:s}) * {it:V}{cmd:'}

{p 4 4 2}
   where 

		{it:U}:  {it:m x n}  and  {it:U}{bf:'}{it:U} = I({it:n})
   		{it:s}:  {it:n x} 1
		{it:V}:  {it:n x n}  and  orthogonal (unitary)

{p 4 4 2}
When {it:A} is complex, the transpose operator {cmd:'} is understood to
mean the {help m6_glossary##transpose:conjugate transpose} operator.

{p 4 4 2}
Vector {it:s} contains the singular values, and those values
are real even when {it:A} is complex.  
{it:s} is ordered 
so that the largest singular value appears first, then the
next largest, and so on.

{p 4 4 2}
Function {cmd:svd(}{it:A}{cmd:,} {it:U}{cmd:,} {it:s}{cmd:,} {it:Vt}{cmd:)}
returns {it:U}, {it:s}, and {it:Vt}={it:V}{cmd:'}.

{p 4 4 2}
Function {cmd:svdsv(}{it:A}{cmd:)} returns {it:s}, 
omitting the calculation of {it:U} and {it:Vt}.
Also, whereas {cmd:svd()} is suitable for use only in the case 
{it:m}>={it:n}, {cmd:svdsv()} may be used in all cases.


{marker remarks2}{...}
{title:Possibility of convergence problems}

{p 4 4 2}
It is possible, although exceedingly unlikely, that the SVD routines
could fail to converge.  
{cmd:svd()}, {cmd:svdsv()}, {cmd:_svd()}, and {cmd:_svdsv()} then return
singular values in {it:s} equal to missing.

{p 4 4 2}
In coding, it is perfectly acceptable to ignore this possibility because 
(1) it is so unlikely and (2) even if the unlikely event occurs, the 
missing values will properly reflect the situation.  If you do wish
to check, in addition to checking {cmd:missing(}{it:s}{cmd:)}>0 
(see {helpb mf_missing:[M-5] missing()}), 
you must also check {cmd:missing(}{it:A}{cmd:)==0}  
because that is the other reason {it:s} could contain missing values.
Convergence was not achieved if {cmd:missing(}{it:s}{cmd:)>0} {cmd:&}
{cmd:missing(}{it:A}{cmd:)==0}.
If you are calling one of the destructive-of-{it:A} versions of SVD, 
remember to check 
{cmd:missing(}{it:A}{cmd:)==0} before extracting singular values.


{marker conformability}{...}
{title:Conformability}

    {cmd:svd(}{it:A}, {it:U}, {it:s}, {it:Vt}{cmd:):}
	{it:input:}
		{it:A}:  {it:m x n}, {it:m}>={it:n}
       {it:output:}
	        {it:U}:  {it:m x n}
	        {it:s}:  {it:n x} 1
	       {it:Vt}:  {it:n x n}
		 
    {cmd:svdsv(}{it:A}{cmd:)}:
		{it:A}:  {it:m x n}, {it:m}>={it:n} or {it:m}<{it:n}
	   {it:result}:  min({it:m},{it:n}) {it:x} 1

    {cmd:_svd(}{it:A}, {it:s}, {it:Vt}{cmd:)}
	{it:input:}
		{it:A}:  {it:m x n}, {it:m}>={it:n}
       {it:output:}
	        {it:A}:  {it:m x n}, contains {it:U}
	        {it:s}:  {it:n x} 1
	       {it:Vt}:  {it:n x n}

    {cmd:_svdsv(}{it:A}{cmd:)}
	{it:input:}
		{it:A}:  {it:m x n}, {it:m}>={it:n} or {it:m}<{it:n}
	{it:output:}
		{it:A}:  0 {it:x} 0
	   {it:result}:  min({it:m},{it:n}) {it:x} 1

    {cmd:_svd_la(}{it:A}, {it:s}, {it:Vt}{cmd:)}
	{it:input:}
		{it:A}:  {it:m x n}, {it:m}>={it:n}
       {it:output:}
	        {it:A}:  {it:m x n}, contains {it:U}
	        {it:s}:  {it:n x} 1
	       {it:Vt}:  {it:n x n}
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:svd(}{it:A}, {it:U}, {it:s}, {it:Vt}{cmd:)}
and 
{cmd:_svd(}{it:A}, {it:s}, {it:Vt}{cmd:)}
return missing results if {it:A} contains missing.
In all other cases, the routines should work, but there is the 
unlikely possibility of convergence problems, in which case 
missing results will also be returned; see 
{it:{help mf_svd##remarks2:Possibility of convergence problems}} above.


{p 4 4 2}
{cmd:svdsv(}{it:A}{cmd:)} 
and 
{cmd:_svdsv(}{it:A}{cmd:)} 
return missing results 
if {it:A} contains missing values or if there are convergence problems.

{p 4 4 2}
{cmd:_svd()} and {cmd:_svdsv()} abort with error if {it:A} is a view.

{p 4 4 2}
Direct use of {cmd:_svd_la()} is not recommended.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view svd.mata, adopath asis:svd.mata},
{view svdsv.mata, adopath asis:svdsv.mata},
{view _svd.mata, adopath asis:_svd.mata},
{view _svdsv.mata, adopath asis:_svdsv.mata};
{cmd:_svd_la()} is built in.
{p_end}
