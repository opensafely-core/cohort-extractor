{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] sort()" "mansection M-5 sort()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] invorder()" "help mf_invorder"}{...}
{vieweralsosee "[M-5] uniqrows()" "help mf_uniqrows"}{...}
{vieweralsosee "[M-5] ustrcompare()" "help mf_ustrcompare"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Manipulation" "help m4_manipulation"}{...}
{viewerjumpto "Syntax" "mf_sort##syntax"}{...}
{viewerjumpto "Description" "mf_sort##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_sort##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_sort##remarks"}{...}
{viewerjumpto "Conformability" "mf_sort##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_sort##diagnostics"}{...}
{viewerjumpto "Source code" "mf_sort##source"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[M-5] sort()} {hline 2}}Reorder rows of matrix
{p_end}
{p2col:}({mansection M-5 sort():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{it:transmorphic matrix}{bind: }
{cmd:sort(}{it:transmorphic matrix X}{cmd:,} 
{it:real rowvector idx}{cmd:)}

{p 8 16 2}
{it:void}{bind:               }
{cmd:_sort(}{it:transmorphic matrix X}{cmd:,} 
{it:real rowvector idx}{cmd:)}


{p 8 16 2}
{it:transmorphic matrix}{bind: }
{cmd:jumble(}{it:transmorphic matrix X}{cmd:)}

{p 8 16 2}
{it:void}{bind:               }
{cmd:_jumble(}{it:transmorphic matrix X}{cmd:)}


{p 8 16 2}
{it:real colvector}{bind:      }
{cmd:order(}{it:transmorphic matrix X}{cmd:,}
{it:real rowvector idx}{cmd:)}

{p 8 16 2}
{it:real colvector}{bind:      }
{cmd:unorder(}{it:real scalar n}{cmd:)}


{p 8 16 2}
{it:void}{bind:               }
{cmd:_collate(}{it:transmorphic matrix X}{cmd:,}
{it:real colvector p}{cmd:)}

{p 4 8 2}
where

{p 8 12 2}
1.  {it:X} may not be a pointer matrix.

{p 8 12 2}
2.  {it:p} must be a permutation column vector, a 1 {it:x} {it:c} vector
     containing the integers 1, 2, ..., {it:c} in some order.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:sort(}{it:X}{cmd:,} {it:idx}{cmd:)} returns {it:X} with rows in ascending
or descending order of the columns specified by {it:idx}.  For instance,
{cmd:sort(}{it:X}{cmd:, 1)} sorts {it:X} on its first column;
{cmd:sort(}{it:X}{cmd:, (1,2))} sorts {it:X} on its first and second
columns (meaning rows with equal values in their first column are ordered
on their second column).  In general, the {it:i}th sort key is column
abs({it:idx}[{it:i}]).  Order is ascending if {it:idx}[{it:i}]>0 and
descending otherwise.  Ascending and descending are defined in terms of
{bf:{help mf_abs:[M-5] abs()}} (length of elements) for complex.

{p 4 4 2}
{cmd:_sort(}{it:X}{cmd:,} {it:idx}{cmd:)} does the same as
{cmd:sort(}{it:X}{cmd:,} {it:idx}{cmd:)}, except that {it:X} is sorted in
place.


{p 4 4 2}
{cmd:jumble(}{it:X}{cmd:)} returns {it:X} with rows in random
order.  For instance, to shuffle a deck of cards numbered 1 to 52, one 
could code {cmd:jumble(1::52)}.
See {cmd:rseed()} in {bf:{help mf_runiform:[M-5] runiform()}}
for information on setting
the random-number seed. 

{p 4 4 2}
{cmd:_jumble(}{it:X}{cmd:)} does the same as
{cmd:jumble(}{it:X}{cmd:)}, except that {it:X} is jumbled in
place.


{p 4 4 2}
{cmd:order(}{it:X}{cmd:,} {it:idx}{cmd:)} returns the permutation vector --
see {bf:{help m1_permutation:[M-1] Permutation}} -- that
would put {it:X} in ascending (descending) order of the columns specified by
{it:idx}.  
A row-permutation vector is a 1 {it:x} {it:c} column vector
containing the integers 1, 2, ..., {it:c} in some order.  Vectors (1\2\3),
(1\3\2), (2\1\3), (2\3\1), (3\1\2), and (3\2\1) are examples.
Row-permutation vectors are used to specify the order in which the 
rows of a matrix {it:X} are to appear.  If {it:p} is a row-permutation 
vector, {it:X}{cmd:[}{it:p}{cmd:, .]} returns {it:X} with its rows 
in the order of {it:p}; {it:p}=(3\2\1) would reverse 
the rows of {it:X}.
{cmd:order(}{it:X}{cmd:,} {it:idx}) returns 
the row-permutation vector that would sort {it:X} and, as a matter of 
fact, 
{cmd:sort(}{it:X}{cmd:,} {it:idx}{cmd:)}
is implemented as {it:X}{cmd:[order(}{it:X}{cmd:,} {it:idx}{cmd:), .]}.

{p 4 4 2}
{cmd:unorder(}{it:n}{cmd:)} returns a 1 {it:x} {it:n} permutation 
vector for placing the rows in random order.  Random numbers are 
calculated by {cmd:runiform()}; see {cmd:rseed()} in 
{bf:{help mf_runiform:[M-5] runiform()}} for information on setting 
the random-number seed.  {cmd:jumble()} is implemented in terms 
of {cmd:unorder()}:  {cmd:jumble(}{it:X}{cmd:)} is equivalent to 
{it:X}{cmd:[unorder(rows(}{it:X}{cmd:)), .]}.


{p 4 4 2}
{cmd:_collate(}{it:X}{cmd:,} {it:p}{cmd:)} is equivalent to 
{it:X} = {it:X}{cmd:[}{it:p}{cmd:, .]}; it changes the order of the 
rows of {it:X}.  {cmd:_collate()} is used by {cmd:_sort()} and 
{cmd:_jumble()} and has the advantage over subscripting in that no extra 
memory is required when the result is to be assigned back to itself.  Consider 

	{it:X} = {it:X}{cmd:[}{it:p}{cmd:, .]}

{p 4 4 2}
There will be an instant after {it:X}{cmd:[}{it:p}{cmd:, .]} has been
calculated but before the result has been assigned back to {it:X} when two
copies of {it:X} exist.  {cmd:_collate(}{it:X}{cmd:,} {it:p}{cmd:)} avoids
that.  {cmd:_collate()} is not a substitute for subscripting in all cases; 
{cmd:_collate()} requires {it:p} be a permutation vector.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 sort()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
If {it:X} is complex, the ordering is defined in terms of 
{bf:{help mf_abs:[M-5] abs()}} of its elements.

{p 4 4 2}
Also see {cmd:invorder()} and {cmd:revorder()} in
{bf:{help mf_invorder:[M-5] invorder()}}.
Let {it:p} be the permutation vector returned by {cmd:order()}:

		{it:p} = {cmd:order(}{it:X}{cmd:,} ...{cmd:)}

{p 4 4 2}
Then 
{it:X}{cmd:[}{it:p}{cmd:,.]}
are the sorted rows of {it:X}.  
{cmd:revorder()} can be used to reverse sort order:
{it:X}{cmd:[revorder(}{it:p}{cmd:),.]}
are the rows of {it:X} in the reverse of the order of 
{it:X}{cmd:[}{it:p}{cmd:,.]}.
{cmd:invorder()} provides the inverse transform:
If {it:Y} = 
{it:X}{cmd:[}{it:p}{cmd:,.]},
then {it:X} = 
{it:Y}{cmd:[invorder(}{it:p}{cmd:),.]}.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:sort(}{it:X}{cmd:,} {it:idx}{cmd:)}, 
{cmd:jumble(}{it:X}{cmd:)}:
{p_end}
		{it:X}:  {it:r1 x c1}
	      {it:idx}:  {it: 1 x c2}, {it:c2} <= {it:c1}
	   {it:result}:  {it:r1 x c1}

{p 4 4 2}
{cmd:_sort(}{it:X}{cmd:,} {it:idx}{cmd:)}, 
{cmd:_jumble(}{it:X}{cmd:)}:
{p_end}
		{it:X}:  {it:r1 x c1}
	      {it:idx}:  {it: 1 x c2}, {it:c2} <= {it:c1}
	   {it:result}:  {it:void}; {it:X} row order modified


{p 4 4 2}
{cmd:order(}{it:X}{cmd:,} {it:idx}{cmd:)}:
{p_end}
		{it:X}:  {it:r1 x c1}
	      {it:idx}:  {it: 1 x c2}, {it:c2} <= {it:c1}
	   {it:result}:  {it:r1 x 1}

{p 4 4 2}
{cmd:unorder(}{it:n}{cmd:)}:
{p_end}
		{it:n}:  1 {it:x} 1
	   {it:result}:  {it:n x}  1

{p 4 4 2}
{cmd:_collate(}{it:X}{cmd:,} {it:p}{cmd:)}:
{p_end}
		{it:X}:  {it:r x c}
		{it:p}:  {it:r x 1}
	   {it:result}:  {it:void}; {it:X} row order modified


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:sort(}{it:X}{cmd:,} {it:idx}{cmd:)}
aborts with error if any element of {cmd:abs(}{it:idx}{cmd:)} is less than 1
or greater than {cmd:rows(}{it:X}{cmd:)}.

{p 4 4 2}
{cmd:_sort(}{it:X}{cmd:,} {it:idx}{cmd:)}
aborts with error if any element of {cmd:abs(}{it:idx}{cmd:)} is less than 1
or greater than {cmd:rows(}{it:X}{cmd:)}, 
or if {it:X} is a view.

{p 4 4 2}
{cmd:_jumble(}{it:X}{cmd:)}
aborts with error if {it:X} is a view.

{p 4 4 2}
{cmd:order(}{it:X}{cmd:,} {it:idx}{cmd:)}
aborts with error if any element of {cmd:abs(}{it:idx}{cmd:)} is less than 1
or greater than {cmd:rows(}{it:X}{cmd:)}.

{p 4 4 2}
{cmd:unorder(}{it:n}{cmd:)} aborts with error if {it:n}<1.

{p 4 4 2}
{cmd:_collate(}{it:X}{cmd:,} {it:p}{cmd:)}
aborts with error if {it:p} is not a permutation vector or if 
{it:X} is a view.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view sort.mata, adopath asis:sort.mata},
{view _sort.mata, adopath asis:_sort.mata},
{view jumble.mata, adopath asis:jumble.mata},
{view _jumble.mata, adopath asis:_jumble.mata},
{view unorder.mata, adopath asis:unorder.mata}

{pstd}
{cmd:order()} and {cmd:_collate()} are built in.
{p_end}
