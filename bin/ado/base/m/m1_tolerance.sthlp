{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[M-1] Tolerance" "mansection M-1 Tolerance"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] epsilon()" "help mf_epsilon"}{...}
{vieweralsosee "[M-5] solve_tol()" "help mf_solve_tol"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-1] Intro" "help m1_intro"}{...}
{viewerjumpto "Syntax" "m1_tolerance##syntax"}{...}
{viewerjumpto "Description" "m1_tolerance##description"}{...}
{viewerjumpto "Links to PDF documentation" "m1_tolerance##linkspdf"}{...}
{viewerjumpto "Remarks" "m1_tolerance##remarks"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[M-1] Tolerance} {hline 2}}Use and specification of tolerances
{p_end}
{p2col:}({mansection M-1 Tolerance:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:somefunction}{cmd:(}...{cmd:,}
{it:real scalar tol}{cmd:,}
...{cmd:)}

{p 4 4 2}
where, concerning argument {it:tol},

{p 12 22 2}
optional{bind:  }Argument {it:tol} is usually optional; not specifying 
{it:tol} is equivalent to specifying {it:tol}=1.

{p 12 22 2}
{it:tol}>0{bind:     }Specifying {it:tol}>0 specifies the amount by which 
the usual tolerance is to be multiplied:  {it:tol}=2 means twice the usual 
tolerance; {it:tol}=.5 means half the usual tolerance.

{p 12 22 2}
{it:tol}<0{bind:     }Specifying {it:tol}<0 specifies the negative of the value
to be used for the tolerance:  {it:tol} = -1e-14 means 1e-14 is to be used.

{p 12 22 2}
{it:tol}=0{bind:     }Specifying {it:tol}=0 means all numbers are to be taken
at face value, no matter how close to 0 they are.  The single exception is
when {it:tol} is applied to values that, mathematically, must be greater than
or equal to zero.  Then negative values (which arise from roundoff
error) are treated as if they were zero.

{p 4 4 2}
The default tolerance is given by formula, such as 

		{it:eta} = {cmd:1e-14}

{p 4 4 2}
or

		{it:eta} = {cmd:epsilon(1)}{right:(see {bf:{help mf_epsilon:[M-5] epsilon()}})    }

{p 4 4 2}
or

		{it:eta} = {cmd:1000*epsilon(trace(abs(}{it:A}{cmd:))/rows(}{it:A}{cmd:))}

{p 4 4 2}
Specifying {it:tol}>0 specifies a value to be used to multiply {it:eta}.
Specifying {it:tol}<0 specifies that -{it:tol} be used in place of {it:eta}.
Specifying {it:tol}=0 specifies that {it:eta} be set to 0.

{p 4 4 2}
The formula for {it:eta} and how {it:eta} is used are found under
{it:Remarks}.  For instance, the {it:Remarks} might say that {it:A} is declared
to be singular if any diagonal element of {it:U} of its LU decomposition is less
than or equal to {it:eta}.


{marker description}{...}
{title:Description}

{p 4 4 2}
The results provided by many of the numerical routines in Mata depend on
tolerances.  Mata provides default tolerances, but those can be overridden.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-1 ToleranceRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help m1_tolerance##remarks1:The problem}
	{help m1_tolerance##remarks2:Absolute versus relative tolerances}
	{help m1_tolerance##remarks3:Specifying tolerances}


{marker remarks1}{...}
{title:The problem}

{p 4 4 2}
In many formulas, zero is a special number in that, when the number arises,
sometimes the result cannot be calculated or, other times, something
special needs to be done.

{p 4 4 2}
The problem is that zero -- 0.00000000000 -- seldom arises in
numerical calculation.  Because of roundoff error, what would be zero were the
calculation performed in infinite precision in fact is 1.03948e-15, or
-4.4376e-16, etc.

{p 4 4 2}
If one behaves as if these small numbers are exactly what they seem to be
(1.03948e-15 is taken to mean 1.03948e-15 and not zero), some formulas produce
wildly inaccurate results; see {bf:{help mf_lusolve:[M-5] lusolve()}} for an 
example.

{p 4 4 2}
Thus routines use {it:tolerances} -- preset numbers -- to determine when 
a number is small enough to be considered to be zero.

{p 4 4 2}
The problem with tolerances is determining what they ought to be.


{marker remarks2}{...}
{title:Absolute versus relative tolerances}

{p 4 4 2}
Tolerances come in two varieties:  absolute and relative.

{p 4 4 2}
An absolute tolerance is a fixed number that is used to make direct
comparisons.  If the tolerance for a particular routine were 1e-14, then
8.99e-15 in some calculation would be considered to be close enough to zero to
act as if it were, in fact, zero, and 1.000001e-14 would be considered a
valid, nonzero number.

{p 4 4 2}
But is 1e-14 small?  The number may look small to you, but whether 1e-14
is small depends on what is being measured and the units in which it is
measured.  If all the numbers in a certain problem were around 1e-12, you
might suspect that 1e-14 is a reasonable number.

{p 4 4 2}
That leads to relative measures of tolerance.  Rather than treating, say, a
predetermined quantity as being so small as to be zero, one specifies a
value (for example, 1e-14) multiplied by something and uses that as the
definition of small.

{p 4 4 2}
Consider the following matrix:

		+-                  -+
		| 5.5e-15    1.2e-16 |
		| 1.3e-16    6.4e-15 |
		+-                  -+

{p 4 4 2}
What is the rank of the matrix?  
One way to answer that question would be to take the LU decomposition of 
the matrix and then count the number of diagonal elements of {it:U} that 
are greater than zero.  Here, however, we will just look at the 
matrix.

{p 4 4 2}
The absolutist view is that the matrix is full of roundoff error and that the
matrix is really indistinguishable from the matrix

		+-                  -+
		|     0          0   |
		|     0          0   |
		+-                  -+

{p 4 4 2}
The matrix has rank 0.  The relativist view is that the matrix has rank 2
because, other than a scale factor of 1e-16, the matrix is indistinguishable
from

		+-                  -+
		|   55.0        1.2  |
		|    1.3       64.0  |
		+-                  -+

{p 4 4 2}
There is no way this question can be answered until someone tells you how the
matrix arose and the units in which it is measured.

{p 4 4 2}
Nevertheless, most Mata routines would (by default) adopt the relativist view:
the matrix is of full rank.  That is because most Mata routines are
implemented using relative measures of tolerance, chosen because Mata routines
are mostly used by people performing statistics, who tend to make calculations
such as {it:X}{bf:'}{it:X} and {it:X}{bf:'}{it:Z} on data matrices, and those
resulting matrices can contain very large numbers.  Such a matrix might
contain

		+-                  -+
		| 5.5e+14    1.2e+12 |
		| 1.3e+13    2.4e+13 |
		+-                  -+

{p 4 4 2}
Given a matrix with such large elements, one is tempted to change one's view
as to what is small.  Calculate the rank of the following matrix:

		+-                             -+
		| 5.5e+14    1.2e+12    1.5e-04 |
		| 1.3e+13    2.4e+13    2.8e-05 |
		| 1.3e-04    2.4e-05    8.7e-05 |
		+-                             -+

{p 4 4 2}
This time, we will do the problem correctly:  we will take the LU decomposition
and count the number of nonzero entries along the diagonal of {it:U}.  For the 
above matrix, the diagonal of {it:U} turns out to be (5.5e+14, 2.4e+13,
.000087).

{p 4 4 2}
An absolutist would tell you that the matrix is of full rank; the smallest
number along the diagonal of {it:U} is .000087 (8.7e-5), and that is still a
respectable number, at least when compared with computer precision, which is
about 2.22e-16 (see {bf:{help mf_epsilon:[M-5] epsilon()}}).

{p 4 4 2}
Most Mata routines would tell you that the matrix has rank 2.  Numbers such as
.000087 may seem respectable when compared with machine precision, but
.000087 is, relatively speaking, a very small number, being about 4.6e-19
relative to the average value of the diagonal elements.


{marker remarks3}{...}
{title:Specifying tolerances}

{p 4 4 2}
Most Mata routines use relative tolerances, but there is no 
rule.  You must read the documentation for the function you are using.

{p 4 4 2}
When the tolerance entry for a function directs you here, 
{bf:[M-1] Tolerance}, then the tolerance works as summarized under 
{it:{help m1_tolerance##syntax:Syntax}} above.  Specify a positive number, and
that number multiplies the default; specify a negative number, and the
corresponding positive number is used in place of the default.  
{p_end}
