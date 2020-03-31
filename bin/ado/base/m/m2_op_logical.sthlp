{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-2] op_logical" "mansection M-2 op_logical"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] exp" "help m2_exp"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Intro" "help m2_intro"}{...}
{viewerjumpto "Syntax" "m2_op_logical##syntax"}{...}
{viewerjumpto "Description" "m2_op_logical##description"}{...}
{viewerjumpto "Links to PDF documentation" "m2_op_logical##linkspdf"}{...}
{viewerjumpto "Remarks" "m2_op_logical##remarks"}{...}
{viewerjumpto "Conformability" "m2_op_logical##conformability"}{...}
{viewerjumpto "Diagnostics" "m2_op_logical##diagnostics"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[M-2] op_logical} {hline 2}}Logical operators
{p_end}
{p2col:}({mansection M-2 op_logical:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{it:a} {cmd:==} {it:b}          true if {it:a} equals {it:b}
	{it:a} {cmd:!=} {it:b}          true if {it:a} not equal to {it:b}


	{it:a} {cmd:>}  {it:b}          true if {it:a} greater than {it:b}
	{it:a} {cmd:>=} {it:b}          true if {it:a} greater than or equal to {it:b}
	{it:a} {cmd:<}  {it:b}          true if {it:a} less than {it:b}
	{it:a} {cmd:<=} {it:b}          true if {it:a} less than or equal to {it:b}

	{cmd:!}{it:a}              logical negation; true if {it:a}==0 and false otherwise

	{it:a} {cmd:&} {it:b}           true if {it:a}!=0 and {it:b}!=0
        {it:a} {cmd:|} {it:b}           true if {it:a}!=0 or  {it:b}!=0

	{it:a} {cmd:&&} {it:b}          synonym for {it:a} {cmd:&} {it:b}
        {it:a} {cmd:||} {it:b}          synonym for {it:a} {cmd:|} {it:b}


{marker description}{...}
{title:Description}

{p 4 4 2}
The operators above perform logical comparisons, and operator {cmd:!} 
performs logical negation.  All operators evaluate to 1 or 0, meaning true 
or false.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-2 op_logicalRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help m2_op_logical##remarks1:Introduction}
	{help m2_op_logical##remarks2:Use of logical operators with pointers}


{marker remarks1}{...}
{title:Introduction}

{p 4 4 2}
The operators above work as you would expect when used with scalars, and 
the comparison operators and the not operator have been generalized for 
use with matrices.

{p 4 4 2}
{it:a}{cmd:==}{it:b} evaluates to true if {it:a} and {it:b} are p-conformable,
of the same type, and the corresponding elements are equal.  Of the same type
means {it:a} and {it:b} are both numeric, both strings, or both pointers.
Thus it is not an error to ask if a 2 {it:x} 2 matrix is equal to a 4 {it:x}
1 vector or if a string variable is equal to a real variable;
they are not.  Also 
{it:a}{cmd:==}{it:b} is declared to be true if {it:a} or {it:b} are
p-conformable and the number of rows or columns is zero.

{p 4 4 2}
{it:a}{cmd:!=}{it:b} is equivalent to {cmd:!(}{it:a}{cmd:==}{it:b}{cmd:)}.
{it:a}{cmd:!=}{it:b} evaluates to true when {it:a}{cmd:==}{it:b} would evaluate 
to false and evaluates to true otherwise.

{p 4 4 2}
The remaining comparison operators {cmd:>}, {cmd:>=}, {cmd:<}, and 
{cmd:<=} work differently from {cmd:==} and {cmd:!=}
in that they require {it:a} and {it:b} be p-conformable; if they are 
not, they abort with error.  They return true if the corresponding elements 
have the stated relationship, and return false otherwise.
If {it:a} or {it:b} is complex, the comparison is made in terms of the 
length of the complex vector; for instance, {it:a}{cmd:>}{it:b}
is equivalent to {cmd:abs(}{it:a}{cmd:)}{cmd:>}{cmd:abs(}{it:b}{cmd:)}, and 
so -3 {cmd:>} 2+0i is true.

{p 4 4 2}
{cmd:!}{it:a}, when {it:a} is a scalar, evaluates to 0 if {it:a} is not equal
to zero and 1 otherwise.  Applied to a vector or matrix, the same operation is
carried out, element by element:  {cmd:!(}-1,0,1,2,.{cmd:)} evaluates to
{cmd:(}0,1,0,0,0{cmd:)}.

{p 4 4 2}
{cmd:&} and {cmd:|} ({it:and} and {it:or}) may be used with scalars only.
Because so many people are familiar with programming in the C language, 
Mata provides 
{cmd:&&} as a synonym for {cmd:&} and {cmd:||} as a synonym for {cmd:|}.


{marker remarks2}{...}
{title:Use of logical operators with pointers}

{p 4 4 2}
In a pointer expression, NULL is treated as false and all other pointer 
values (address values) are treated as true.  Thus the following code 
is equivalent

	{cmd}pointer x                            pointer x
	...                                  ...
	if (x) {                             if (x!=NULL) {
		...                                  ...
	}                                    }{txt}

{p 4 4 2}
The logical operators {it:a}{cmd:==}{it:b}, {it:a}{cmd:!=}{it:b},
{it:a}{cmd:&}{it:b}, and {it:a}{cmd:|}{it:b} may be used with pointers.


{marker conformability}{...}
{title:Conformability}

    {it:a}{cmd:==}{it:b}, {it:a}{cmd:!=}{it:b}:
	     {it:a}:  {it:r1 x c1}
	     {it:b}:  {it:r2 x c2}
	{it:result}:  1 {it:x} 1

{p 4 4 2}
{it:a}{cmd:>}{it:b},
{it:a}{cmd:>=}{it:b},
{it:a}{cmd:<}{it:b},
{it:a}{cmd:<=}{it:b}:
{p_end}
	     {it:a}:  {it:r x c}
	     {it:b}:  {it:r x c}
	{it:result}:  1 {it:x} 1

    {cmd:!}{it:a}:
	     {it:a}:  {it:r x c}
	{it:result}:  {it:r x c}

{p 4 4 2}
{it:a}{cmd:&}{it:b},
{it:a}{cmd:|}{it:b}:
{p_end}
	     {it:a}:  1 {it:x} 1
	     {it:b}:  1 {it:x} 1
	{it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
    {it:a}{cmd:==}{it:b} and
    {it:a}{cmd:!=}{it:b}
    cannot fail.

{p 4 4 2}
{it:a}{cmd:>}{it:b},
{it:a}{cmd:>=}{it:b},
{it:a}{cmd:<}{it:b},
{it:a}{cmd:<=}{it:b}
abort with error if {it:a} and {it:b} are not p-conformable, 
if {it:a} and {it:b} are not of the same general type
(numeric and numeric or string and string), or if {it:a} or {it:b} are 
pointers.

{p 4 4 2}
{cmd:!}{it:a} aborts with error if {it:a} is not real.

{p 4 4 2}
{it:a}{cmd:&}{it:b} and
{it:a}{cmd:|}{it:b}
abort with error if {it:a} and {it:b} are not both real or not both
pointers.  If {it:a} and {it:b} are pointers, pointer value 
NULL is treated as false and all other pointer values are treated 
as true.  In all cases, a real equal to 0 or 1 is returned.
{p_end}
