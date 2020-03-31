{smcl}
{* *! version 1.1.6  31jul2019}{...}
{vieweralsosee "[M-2] void" "mansection M-2 void"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Intro" "help m2_intro"}{...}
{viewerjumpto "Syntax" "m2_void##syntax"}{...}
{viewerjumpto "Description" "m2_void##description"}{...}
{viewerjumpto "Links to PDF documentation" "m2_void##linkspdf"}{...}
{viewerjumpto "Remarks" "m2_void##remarks"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[M-2] void} {hline 2}}Void matrices
{p_end}
{p2col:}({mansection M-2 void:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{cmd:J(0, 0, .)}{col 30}0 {it:x} 0 real matrix
	{cmd:J(}{it:r}{cmd:, 0, .)}{col 30}{it:r x} 0 real matrix
	{cmd:J(0,} {it:c}{cmd:, .)}{col 30}0 {it:x c} real matrix

	{cmd:J(0, 0, 1i)}{col 30}0 {it:x} 0 complex matrix
	{cmd:J(}{it:r}{cmd:, 0, 1i)}{col 30}{it:r x} 0 complex matrix
	{cmd:J(0,} {it:c}{cmd:, 1i)}{col 30}0 {it:x c} complex matrix

	{cmd:J(0, 0, "")}{col 30}0 {it:x} 0 string matrix
	{cmd:J(}{it:r}{cmd:, 0, "")}{col 30}{it:r x} 0 string matrix
	{cmd:J(0,} {it:c}{cmd:, "")}{col 30}0 {it:x c} string matrix

	{cmd:J(0, 0, NULL)}{col 30}0 {it:x} 0 pointer matrix
	{cmd:J(}{it:r}{cmd:, 0, NULL)}{col 30}{it:r x} 0 pointer matrix
	{cmd:J(0,} {it:c}{cmd:, NULL)}{col 30}0 {it:x c} pointer matrix


{marker description}{...}
{title:Description}

{p 4 4 2}
Mata allows 0 {it:x} 0, {it:r x} 0, and 0 {it:x c} matrices.  These matrices 
are called {it:void matrices}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-2 voidRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help m2_void##remarks1:Void matrices, vectors, row vectors, and column vectors}
	{help m2_void##remarks2:How to read conformability charts}


{marker remarks1}{...}
{title:Void matrices, vectors, row vectors, and column vectors}

{p 4 4 2}
Void matrices contain nothing, but they have dimension information (they are
0 {it:x} 0, {it:r x} 0, or 0 {it:x c}) and have an {it:eltype} (which is 
{cmd:real}, {cmd:complex}, {cmd:string}, or {cmd:pointer}):

{p 8 12 2}
    1.  A matrix is said to be void if it is 0 {it:x} 0, {it:r x} 0, or 
        0 {it:x c}.

{p 8 12 2}
    2.  A vector is said to be void if it is 0 {it:x} 1 or 1 {it:x} 0.

{p 8 12 2}
    3.  A column vector is said to be void if it is 0 {it:x} 1.

{p 8 12 2}
    4.  A row vector is said to be void if it is 1 {it:x} 0.

{p 8 12 2}
    5.  A scalar cannot be void because it is, by definition, 1 {it:x} 1.

{p 4 4 2}
The function {cmd:J(}{it:r}{cmd:,} {it:c}{cmd:,} {it:val}{cmd:)} creates {it:r}
{it:x} {it:c} matrices containing {it:val}; see {bf:{help mf_j:[M-5] J()}}.
{cmd:J()} can be used to manufacture void matrices by specifying {it:r} and/or
{it:c} as 0.  The value of the third argument does not matter, but its
{it:eltype} does:

{p 8 12 2}
    1.  {cmd:J(0,0,.)} creates a real 0 {it:x} 0 matrix, as will
        {cmd:J(0,0,1)} and as will {cmd:J()} with any real third argument.

{p 8 12 2}
    2.  {cmd:J(0,0,1i)} creates a 0 {it:x} 0 complex matrix, as will {cmd:J()}
        with any complex third argument.

{p 8 12 2}
    3.  {cmd:J(0,0,"")} creates 0 {it:x} 0 string matrices, as will {cmd:J()}
        with any string third argument.

{p 8 12 2}
    4.  {cmd:J(0,0,NULL)} creates 0 {it:x} 0 pointer matrices, as will
        {cmd:J()} with any pointer third argument.

{p 4 4 2}
In fact, one rarely needs to manufacture such matrices because they arise
naturally in extreme cases.  Similarly, one rarely needs to include special
code to handle void matrices because such matrices handle themselves.  Loops
vanish when the number of rows or columns are zero.


{marker remarks2}{...}
{title:How to read conformability charts}
{* index conformability}{...}

{p 4 4 2}
In general, no emphasis is placed on how functions and operators
deal with void matrices; moreover, no mention is even made of the fact.
Instead, the information is buried in the {bf:Conformability} section located
near the end of the function's or operator's manual entry.

{p 4 4 2}
For instance, the conformability chart for some function might read

	{cmd:somefunction(}{it:A}{cmd:,} {it:B}{cmd:,} {it:v}{cmd:)}:
		{it:A}:  {it:r x c}
		{it:B}:  {it:c x k}
		{it:v}:  {it:1 x k}  or  {it:k} {it:x} 1
	   {it:result}:  {it:r x k}

{p 4 4 2}
Among other things, the chart above is stating how {cmd:somefunction()}
handles void matrices.  {it:A} must be {it:r x c}.  That chart does not say

		{it:A}:  {it:r x c}, {it:r}>0, {it:c}>0

{p 4 4 2}
and that is what it would have said if {cmd:somefunction()}
did not allow {it:A} to be void.   Hence, {it:A} may be 0 {it:x} 0, 
0 {it:x} {it:c}, or {it:r} {it:x} 0.

{p 4 4 2}
Similarly, {it:B} may be void as long as
{cmd:rows(}{it:B}{cmd:)}={cmd:cols(}{it:A}{cmd:)}.  {it:v} may be void if
{cmd:cols(}{it:B}{cmd:)}=0.  The returned result will be void if 
{cmd:rows(}{it:A}{cmd:)}=0 or 
{cmd:cols(}{it:B}{cmd:)}=0.

{p 4 4 2}
Interestingly, {cmd:somefunction()} can produce a nonvoid result from 
void input.  For instance, if {it:A} were 5 {it:x} 0 and {it:B}, 
0 {it:x} 3, a 5 {it:x} 3 result would be produced.  It is interesting 
to speculate what would be in that 5 {it:x} 3 result.  Probably, if we 
knew what {cmd:somefunction()} did, it would be obvious to us, but if 
it were not, the following section, {bf:Diagnostics}, would state 
what the surprising result would be.

{p 4 4 2}
As a real example, see {bf:{help mf_trace:[M-5] trace()}}.
{cmd:trace()} will take the trace of a 0 {it:x} 0 matrix.  The result is 
0.  Or see multiplication ({cmd:*}) in 
{bf:{help m2_op_arith:[M-2] op_arith}}.  One can multiply
a {it:k} {it:x} 0 matrix by a 0 {it:x} {it:m} matrix to produce a 
{it:k} {it:x} {it:m} result.  The matrix will contain zeros.
{p_end}
