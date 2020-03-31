{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[M-5] edittozero()" "mansection M-5 edittozero()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] edittoint()" "help mf_edittoint"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Manipulation" "help m4_manipulation"}{...}
{viewerjumpto "Syntax" "mf_edittozero##syntax"}{...}
{viewerjumpto "Description" "mf_edittozero##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_edittozero##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_edittozero##remarks"}{...}
{viewerjumpto "Conformability" "mf_edittozero##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_edittozero##diagnostics"}{...}
{viewerjumpto "Source code" "mf_edittozero##source"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[M-5] edittozero()} {hline 2}}Edit matrix for roundoff error (zeros)
{p_end}
{p2col:}({mansection M-5 edittozero():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{it:numeric matrix}
{cmd:edittozero(}{it:numeric matrix Z}{cmd:,}
{it:real scalar amt}{cmd:)}

{p 8 8 2}
{it:void}{bind:         }
{cmd:_edittozero(}{it:numeric matrix Z}{cmd:,}
{it:real scalar amt}{cmd:)}


{p 8 8 2}
{it:numeric matrix} 
{cmd:edittozerotol(}{it:numeric matrix Z}{cmd:,}
{it:real scalar tol}{cmd:)}

{p 8 8 2}
{it:void}{bind:         }
{cmd:_edittozerotol(}{it:numeric matrix Z}{cmd:,}
{it:real scalar tol}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
These edit functions set elements of matrices to zero that are close to zero.
{cmd:edittozero(}{it:Z}{cmd:,} {it:amt}{cmd:)} and 
{cmd:_edittozero(}{it:Z}{cmd:,} {it:amt}{cmd:)} set 

		{it:Z_ij} = 0          if  |{it:Z_ij}| <= |{it:tol}|

{p 4 4 2}
for {it:Z} real and set

		Re({it:Z_ij}) = 0      if  |Re({it:Z_ij})| <= |{it:tol}|

		Im({it:Z_ij}) = 0      if  |Im({it:Z_ij})| <= |{it:tol}|

{p 4 4 2}
for {it:Z} complex, where in both cases 

		{it:tol} = {cmd:abs(}{it:amt}{cmd:)}{cmd:*epsilon(sum(abs(}{it:Z}{cmd:))/(rows(}{it:Z}{cmd:)*cols(}{it:Z}{cmd:)))}

{p 4 4 2}
{cmd:edittozero()} leaves {it:Z} unchanged and returns the editted matrix.
{cmd:_edittozero()} edits {it:Z} in place.

{p 4 4 2}
{cmd:edittozerotol(}{it:Z}{cmd:,} {it:tol}{cmd:)} and
{cmd:_edittozerotol(}{it:Z}{cmd:,} {it:tol}{cmd:)} do the same thing, except that 
{it:tol} is specified directly.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 edittozero()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_edittozero##remarks1:Background}
	{help mf_edittozero##remarks2:Treatment of complex values}
	{help mf_edittozero##remarks3:Recommendations}


{marker remarks1}{...}
{title:Background}

{p 4 4 2}
Numerical roundoff error leads, among other things, to numbers that should 
be zero being small but not zero, and so it is sometimes desirable to reset 
those small numbers to zero.

{p 4 4 2}
The problem is in identifying those small numbers.  Is 1e-14 small?  
Is 10,000?  The answer is that, given some matrix, 1e-14 might not be 
small because most of the values in the matrix are around 1e-14, and the 
small values are 1e-28, and given some other matrix, 10,000 might indeed 
be small because most of the elements are around 1e+18.  

{p 4 4 2}
{cmd:edittozero()} makes an attempt to determine what is small.  {cmd:edittozerotol()}
leaves that determination to you.  In {cmd:edittozerotol(}{it:Z}{cmd:,}
{it:tol}{cmd:)}, you specify {it:tol} and elements for which |{it:Z_ij}| <=
{it:tol} are set to zero.

{p 4 4 2}
Using {cmd:edittozero(}{it:Z}{cmd:,} {it:amt}{cmd:)}, however, you specify 
{it:amt} and then {it:tol} is calculated for you based on the size of the
elements in {it:Z} and {it:amt}, using the formula

		{it:tol} = {it:amt} {cmd:* epsilon(}average value of |{it:Z_ij}|{cmd:)}

{p 4 4 2}
{cmd:epsilon()} refers to machine precision, and 
{cmd:epsilon(}{it:x}{cmd:)} is the function that returns machine precision 
in units of {it:x}:

		{cmd:epsilon(}{it:x}{cmd:)}  = |{it:x}|{cmd:*epsilon(1)}

{p 4 4 2}
and {cmd:epsilon(1)} is approximately 2.22e-16 on most computers;
see {bf:{help mf_epsilon:[M-5] epsilon()}}.


{marker remarks2}{...}
{title:Treatment of complex values}

{p 4 4 2}
The formula 

		{it:tol} = {it:amt} {cmd:* epsilon(}average value of |{it:Z_ij}|{cmd:)}

{p 4 4 2}
is used for both real and complex values.  For complex, |{it:Z_ij}|
refers to the modulus (length) of the complex element.

{p 4 4 2}
However, rather than applying the reset rule 

		{it:Z_ij} = 0          if  |{it:Z_ij}| <= |{it:tol}|

{p 4 4 2}
as is done when {it:Z} is real, the reset rules are 

		Re({it:Z_ij}) = 0      if  |Re({it:Z_ij})| <= |{it:tol}|

		Im({it:Z_ij}) = 0      if  |Im({it:Z_ij})| <= |{it:tol}|

{p 4 4 2}
The first rule, applied even for complex, may seem more appealing,
but the use of the second has the advantage of mapping numbers close to 
being purely real or purely imaginary to purely real or purely imaginary 
results.  


{marker remarks3}{...}
{title:Recommendations}


{p 4 8 2}
1.
Minimal editing is performed by {cmd:edittozero(}{it:Z}{cmd:, 1)}.
Values less than 2.22e-16 times the average would be set to zero.

{p 4 8 2}
2.
It is often reasonable to code 
{cmd:edittozero(}{it:Z}{cmd:, 1000)}, which 
sets to zero values less than 2.22e-13 times the average.

{p 4 8 2}
3.
For a given calculation, 
the amount of roundoff error that arises with complex matrices 
(matrices with nonzero imaginary part)
is greater than the amount that arises with real matrices 
(matrices with zero imaginary part even if stored as {cmd:complex}).
That is because, in addition to all the usual sources of roundoff
error, multiplication of complex values involves the addition operator, 
which introduces additional roundoff error.  Hence, whatever is the 
appropriate value of {it:amt} or {it:tol} with real matrices, it is 
larger for complex matrices.


{marker conformability}{...}
{title:Conformability}

    {cmd:edittozero(}{it:Z}{cmd:,} {it:amt}{cmd:)}:
		{it:Z}:  {it:r x c}
	      {it:amt}:  1 {it:x} 1
	   {it:result}:  {it:r x c}

    {cmd:_edittozero(}{it:Z}{cmd:,} {it:amt}{cmd:)}:
	{it:input:}
		{it:Z}:  {it:r x c}
	      {it:amt}:  1 {it:x} 1
	{it:output:}
		{it:Z}:  {it:r x c}

    {cmd:edittozerotol(}{it:Z}{cmd:,} {it:tol}{cmd:)}:
		{it:Z}:  {it:r x c}
	      {it:tol}:  1 {it:x} 1
	   {it:result}:  {it:r x c}

    {cmd:_edittozerotol(}{it:Z}{cmd:,} {it:tol}{cmd:)}:
	{it:input:}
		{it:Z}:  {it:r x c}
	      {it:tol}:  1 {it:x} 1
	{it:output:}
		{it:Z}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:edittozero(}{it:Z}{cmd:,} {it:amt}{cmd:)} and 
{cmd:_edittozero(}{it:Z}{cmd:,} {it:amt}{cmd:)} 
leave scalars unchanged because they 
base their calculation of the likely roundoff error on the average value 
of |{it:Z_ij}|.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view edittozero.mata, adopath asis:edittozero.mata},
{view _edittozero.mata, adopath asis:_edittozero.mata},
{view edittozerotol.mata, adopath asis:edittozerotol.mata},
{view _edittozerotol.mata, adopath asis:_edittozerotol.mata}
{p_end}
