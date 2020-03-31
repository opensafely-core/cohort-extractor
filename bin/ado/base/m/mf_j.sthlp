{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[M-5] J()" "mansection M-5 J()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] missingof()" "help mf_missingof"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Standard" "help m4_standard"}{...}
{viewerjumpto "Syntax" "mf_j##syntax"}{...}
{viewerjumpto "Description" "mf_j##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_j##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_j##remarks"}{...}
{viewerjumpto "Conformability" "mf_j##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_j##diagnostics"}{...}
{viewerjumpto "Source code" "mf_j##source"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[M-5] J()} {hline 2}}Matrix of constants
{p_end}
{p2col:}({mansection M-5 J():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:transmorphic matrix}
{cmd:J(}{it:real scalar r}{cmd:,}
{it:real scalar c}{cmd:,}
{it:scalar val}{cmd:)}

{p 8 12 2}
{it:transmorphic matrix}
{cmd:J(}{it:real scalar r}{cmd:,}
{it:real scalar c}{cmd:,}
{it:matrix mat}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:J(}{it:r}{cmd:,} {it:c}{cmd:,} {it:val}{cmd:)}
returns an {it:r x c} matrix with each element equal to {it:val}.

{p 4 4 2}
{cmd:J(}{it:r}{cmd:,} {it:c}{cmd:,} {it:mat}{cmd:)}
returns an
({it:r}{cmd:*rows(}{it:mat}{cmd:)})
{it:x}
({it:c}{cmd:*cols(}{it:mat}{cmd:)}) matrix
with elements equal to {it:mat}.

{p 4 4 2}
The first, 
{cmd:J(}{it:r}{cmd:,} {it:c}{cmd:,} {it:val}{cmd:)}, 
is how {cmd:J()} is commonly used.  The first is nothing more than a special
case of the second,
{cmd:J(}{it:r}{cmd:,} {it:c}{cmd:,} {it:mat}{cmd:)}, when 
{it:mat} is 1 {it:x} 1.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 J()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{title:First syntax:  J(r, c, val), val a scalar}

{p 4 4 2}
{cmd:J(}{it:r}{cmd:,} {it:c}{cmd:,} {it:val}{cmd:)}
creates matrices of constants.  For example, 
{cmd:J(2, 3, 0)} creates 

                       {txt}1   2   3
                    {c TLC}{hline 13}{c TRC}
                  1 {c |}  {res}0   0   0{txt}  {c |}
                  2 {c |}  {res}0   0   0{txt}  {c |}
                    {c BLC}{hline 13}{c BRC}{txt}

{p 4 4 2}
{cmd:J()} must be typed in uppercase.

{p 4 4 2}
{cmd:J()} can create any type of matrix:

        Function         Returns
	{hline 66}
	{cmd:J(2, 3, 4)}       2 x 3 real    matrix, each element = 4
        {cmd:J(2, 3, 4+5i)}    2 x 3 complex matrix, each element = 4+5i
        {cmd:J(2, 3, "hi")}    2 x 3 string  matrix, each element = "hi"
	{cmd:J(2, 3, &x)}      2 x 3 pointer matrix, each element = address of {cmd:x}
	{hline 66}

{marker void_matrices}{...}
{p 4 4 2}
Also, {cmd:J()} can create void matrices:

	{cmd:J(0, 0, .)}       0 {it:x} 0 real 
	{cmd:J(0, 1, .)}       0 {it:x} 1 real 
	{cmd:J(1, 0, .)}       1 {it:x} 0 real 

	{cmd:J(0, 0, 1i)}      0 {it:x} 0 complex 
	{cmd:J(0, 1, 1i)}      0 {it:x} 1 complex 
	{cmd:J(1, 0, 1i)}      1 {it:x} 0 complex 

	{cmd:J(0, 0, "")}      0 {it:x} 0 string 
	{cmd:J(0, 1, "")}      0 {it:x} 1 string 
	{cmd:J(1, 0, "")}      1 {it:x} 0 string 

	{cmd:J(0, 0, NULL)}    0 {it:x} 0 pointer 
	{cmd:J(0, 1, NULL)}    0 {it:x} 1 pointer 
	{cmd:J(1, 0, NULL)}    1 {it:x} 0 pointer 

{p 4 4 2}
When 
{cmd:J(}{it:r}{cmd:,} {it:c}{cmd:,} {it:val}{cmd:)}
is used to create a void matrix, the particular value of the third argument
does not matter.  Its element type, however, determines the type of matrix
produced.  Thus,
{cmd:J(0, 0, .)}, {cmd:J(0, 0, 1)}, and {cmd:J(0, 0, 1/3)} all create the same
result:  a 0 {it:x} 0 real matrix.  Similarly, {cmd:J(0, 0, "")}, 
{cmd:J(0, 0, "name")}, and {cmd:J(0, 0, "?")} all create the same result:
a 0 {it:x} 0 string matrix.  See {bf:{help m2_void:[M-2] void}} to learn how 
void matrices are used.


{title:Second syntax:  J(r, c, mat), mat a matrix}

{p 4 4 2}
{cmd:J(}{it:r}{cmd:,} {it:c}{cmd:,} {it:mat}{cmd:)} is a generalization of
{cmd:J(}{it:r}{cmd:,} {it:c}{cmd:,} {it:val}{cmd:)}.  When the third argument 
is a matrix, that matrix is replicated in the result.  For instance, if
{cmd:X} is {cmd:(1,2\3,4)}, then {cmd:J(2, 3, X)} creates

                {res}       {txt}1   2   3   4   5   6
                    {c TLC}{hline 25}{c TRC}
                  1 {c |}  {res}1   2   1   2   1   2{txt}  {c |}
                  2 {c |}  {res}3   4   3   4   3   4{txt}  {c |}
                  3 {c |}  {res}1   2   1   2   1   2{txt}  {c |}
                  4 {c |}  {res}3   4   3   4   3   4{txt}  {c |}
                    {c BLC}{hline 25}{c BRC}{txt}

{p 4 4 2}
{cmd:J(}{it:r}{cmd:,} {it:c}{cmd:,} {it:val}{cmd:)} is a special case of 
{cmd:J(}{it:r}{cmd:,} {it:c}{cmd:,} {it:mat}{cmd:)}; it just happens that 
{it:mat} is 1 {it:x} 1.

{p 4 4 2}
The matrix created has 
{it:r}{cmd:*rows(}{it:mat}{cmd:)} rows and 
{it:c}{cmd:*cols(}{it:mat}{cmd:)} columns.

{p 4 4 2}
Note that 
{cmd:J(}{it:r}{cmd:,} {it:c}{cmd:,} {it:mat}{cmd:)} creates a void matrix 
if any of {it:r}, {it:c}, 
{cmd:rows(}{it:mat}{cmd:)}, or
{cmd:cols(}{it:mat}{cmd:)} are zero.


{marker conformability}{...}
{title:Conformability}

    {cmd:J(}{it:r}{cmd:,} {it:c}{cmd:,} {it:val}{cmd:)}:
		{it:r}:  1 {it:x} 1
		{it:c}:  1 {it:x} 1
	      {it:val}:  1 {it:x} 1
	   {it:result}:  {it:r x c}

    {cmd:J(}{it:r}{cmd:,} {it:c}{cmd:,} {it:mat}{cmd:)}:
		{it:r}:  1 {it:x} 1
		{it:c}:  1 {it:x} 1
	      {it:mat}:  {it:m x n}
	   {it:result}:  {it:r*m x c*n}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:J(}{it:r}{cmd:,} {it:c}{cmd:,} {it:val}{cmd:)} 
and 
{cmd:J(}{it:r}{cmd:,} {it:c}{cmd:,} {it:mat}{cmd:)} 
abort with error if {it:r}<0 or {it:c}<0, or 
if {it:r}>={cmd:.} or {it:c}>={cmd:.}.
Arguments {it:r} and {it:c} are interpreted as 
{cmd:trunc(}{it:r}{cmd:)} and 
{cmd:trunc(}{it:c}{cmd:)}.


{marker source}{...}
{title:Source code}

{pstd}
Function is built in.
{p_end}
