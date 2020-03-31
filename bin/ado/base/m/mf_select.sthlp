{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[M-5] select()" "mansection M-5 select()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] st_subview()" "help mf_st_subview"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] op_colon" "help m2_op_colon"}{...}
{vieweralsosee "[M-2] Subscripts" "help m2_subscripts"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Utility" "help m4_utility"}{...}
{viewerjumpto "Syntax" "mf_select##syntax"}{...}
{viewerjumpto "Description" "mf_select##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_select##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_select##remarks"}{...}
{viewerjumpto "Conformability" "mf_select##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_select##diagnostics"}{...}
{viewerjumpto "Source code" "mf_select##source"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[M-5] select()} {hline 2}}Select rows, columns, or indices
{p_end}
{p2col:}({mansection M-5 select():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{it:transmorphic matrix}
{cmd:select(}{it:transmorphic matrix X}{cmd:,}
{it:real vector v}{cmd:)}

{p 8 8 2}
{it:void}{bind:               }
{cmd:st_select(}{it:A}{cmd:,}
{it:transmorphic matrix X}{cmd:,}
{it:real vector v}{cmd:)}

{p 8 8 2}
{it:real vector}{bind:        }
{cmd:selectindex(}{it:real vector v}{cmd:)} 


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:select(}{it:X}{cmd:,} {it:v}{cmd:)}
returns {it:X} 

{p 8 12 2}
1.  omitting the rows for which 
{it:v}{cmd:[}{it:i}{cmd:]==0} ({it:v} a column vector)
or

{p 8 12 2}
2.  omitting the columns for which 
{it:v}{cmd:[}{it:j}{cmd:]==0} ({it:v} a row vector).

{p 4 4 2}
{cmd:st_select(}{it:A}{cmd:,} {it:X}{cmd:,} {it:v}{cmd:)}
does the same thing, except that
the result is placed in {it:A} and,
if {it:X} is a view, {it:A} will be a view.

{p 4 4 2}
{cmd:selectindex(}{it:v}{bf:)} returns 

{p 8 12 2}
1. a row vector of column indices {it:j} for which {it:v}{bf:[}{it:j}{bf:]!=0}
({it:v} a row vector) or

{p 8 12 2}
2. a column vector of row indices {it:i} for which {it:v}{bf:[}{it:i}{bf:]!=0}
({it:v} a column vector)


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 select()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings: 

	{help mf_select##remarks1:Examples}
	{help mf_select##remarks2:Using st_select()}


{marker remarks1}{...}
{title:Examples}

{p 4 8 2}
1.
To select rows 1, 2, and 4 of 5 {it:x c} matrix {cmd:X}, 

		{cmd:submat = select(X, (1\1\0\1\0))}

{p 8 8 2}
See {bf:{help m2_subscripts:[M-2] Subscripts}}
for another solution, 
{cmd:submat = X[(1\2\4), .]}.


{p 4 8 2}
2.
To select columns 1, 2, and 4 of {it:r x} 5 matrix {cmd:X}, 

		{cmd:submat = select(X, (1,1,0,1,0))}

{p 8 8 2}
See {bf:{help m2_subscripts:[M-2] Subscripts}}
for another solution, 
{cmd:submat = X[., (1,2,4)]}.


{p 4 8 2}
3.
To select rows of {cmd:X} for which the first element is positive, 

		{cmd:submat = select(X, X[.,1]:>0)}


{p 4 8 2}
4.
To select columns of {cmd:X} for which the first element is positive, 

		{cmd:submat = select(X, X[1,.]:>0)}


{p 4 8 2}
5.
To select rows of {cmd:X} for which there are no missing values, 

		{cmd:submat = select(X, rowmissing(X):==0)}


{p 4 8 2}
6.
To select rows and columns of square matrix {cmd:X} for which the diagonal 
elements are positive,

		{cmd:pos    = diagonal(X):>0}
		{cmd:submat = select(X, pos)}
		{cmd:submat = select(submat, pos')}

{p 8 8 2}
or, equivalently, 

		{cmd:pos    = diagonal(X):>0}
		{cmd:submat = select(select(X, pos), pos')}


{p 4 8 2}
7.
To select column indices for which {it:v}{bf:[}{it:j}{bf:]!=0},

	{cmd:: v}
               1   2   3   4   5
            {c TLC}{hline 21}{c TRC}
          1 {c |}  6   0   7   0   8  {c |}
            {c BLC}{hline 21}{c BRC}

	{cmd:: selectindex(v)}
               1   2   3
            {c TLC}{hline 13}{c TRC}
          1 {c |}  1   3   5  {c |}
            {c BLC}{hline 13}{c BRC}

{p 4 8 2}
8.
To select row indices for which {it:v}{bf:[}{it:i}{bf:]!=0},

        {cmd:: w}
               1
            {c TLC}{hline 5}{c TRC}
          1 {c |}  0  {c |}
          2 {c |}  3  {c |}
          3 {c |}  0  {c |}
          4 {c |}  2  {c |}
	  5 {c |}  1  {c |}
            {c BLC}{hline 5}{c BRC}

	{cmd:: selectindex(w)}
               1
	    {c TLC}{hline 5}{c TRC}
          1 {c |}  2  {c |}
          2 {c |}  4  {c |}
          3 {c |}  5  {c |}
            {c BLC}{hline 5}{c BRC}


{marker remarks2}{...}
{title:Using st_select()}

{p 4 4 2}
Coding 

		{cmd:st_select(submat, X, v)}{col 60}(1)

{p 4 4 2}
produces the same result as coding

		{cmd:submat = st_select(X, v)}{col 60}(2)

{p 4 4 2}
The difference is in how the result is stored.  If {it:X} is a view (it need 
not be), then (1) will produce {cmd:submat} as a view or, if you will, a
subview, whereas in (2), {cmd:submat} will always be a regular (nonview) matrix.

{p 4 4 2}
When {it:X} is a view, (1) executes more quickly than (2) and produces a result
that consumes less memory.

{p 4 4 2}
See 
{bf:{help mf_st_view:[M-5] st_view()}} for a description of views.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:select(}{it:X}{cmd:,} {it:v}{cmd:)}
{p_end}
		{it:X}:  {it:r1 x c1}
		{it:v}:  {it:r1 x 1}   or   {it:1 x c1}
	   {it:result}:  {it:r2 x c1}  or  {it:r1 x c2},   {...}
{it:r2} <= {it:r1}, {...}
{it:c2} <= {it:c1}

{p 4 4 2}
{cmd:st_select(}{it:A}{cmd:,} {it:X}{cmd:,} {it:v}{cmd:)}
{p_end}
	{it:input:}
		{it:X}:  {it:r1 x c1}
		{it:v}:  {it:r1 x 1}   or   {it:1 x c1}
	{it:output:}
		{it:A}:  {it:r2 x c1}  or  {it:r1 x c2},   {...}
{it:r2} <= {it:r1}, {...}
{it:c2} <= {it:c1}

{p 4 4 2}
{cmd:selectindex(}{it:v}{cmd:)}
{p_end}
		{it:v}:  {it:r1 x 1}   or   {it:1 x c1}
           {it:result}:  {it:r2 x 1}   or   {it:1 x c2},   {...}
{it:r2} <= {it:r1}, {...}
{it:c2} <= {it:c1}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
