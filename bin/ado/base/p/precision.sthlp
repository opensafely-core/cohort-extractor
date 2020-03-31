{smcl}
{* *! version 1.0.2  11may2018}{...}
{findalias asfrprecision}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] generate" "help generate"}{...}
{vieweralsosee "[D] Data types" "help data_type"}{...}
{viewerjumpto "Syntax" "precision##syntax"}{...}
{viewerjumpto "Description" "precision##description"}{...}
{viewerjumpto "Remarks" "precision##remarks"}{...}
{title:Title}

{pstd}
{findalias frprecision}


{marker syntax}{...}
{title:Syntax}

    {hline}
{phang}
Problem:

{p 8 10 2}
. {cmd:generate x = 1.1}

{p 8 10 2}
. {cmd:list}{break}
({it:Stata displays output showing that x is 1.1 in all observations.})
  
{p 8 13 2}
. {cmd:count if x==1.1}{break}
0

    {hline}
{phang}
Solution 1:

{p 8 11 2}
. {cmd:count if x==float(1.1)}{break}
100

    {hline}
{phang}
Solution 2:

{p 8 10 2}
. {cmd:generate double x = 1.1}

{p 8 11 2}
. {cmd:count if x==1.1}{break}
100

    {hline}
{phang}
Solution 3:

{p 8 10 2}
. {cmd:set type double}

{p 8 10 2}
. {cmd:generate x = 1.1}

{p 8 11 2}
. {cmd:count if x==1.1}{break}
100
{p_end}
    {hline}


{marker description}{...}
{title:Description}

{pstd}
Stata works in binary.  Stata stores data in float precision by default.
Stata performs all calculations in double precision.  Sometimes the
combination results in surprises until you think more carefully about what
happened.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

       {help precision##summary:Summary}
       {help precision##whycount:Why count x==1.1 produces 0}
       {help precision##howfloat:How count x==float(1.1) solves the problem}
       {help precision##coverup:How storing data as double appears to solve the problem (and does)}
       {help precision##floataccuracy:Float is plenty accurate to store most data}
       {help precision##excel:Why do I not have these problems using Excel?}


{marker summary}{...}
{title:Summary}

{p 4 4 2}
Justifications for all statements made appear in the sections below. 
In summary, 

{p 8 12 2}
1.  It sometimes appears that Stata is inaccurate.  That is not true and, 
    in fact, the appearance of inaccuracy happens in part because Stata is 
    so accurate. 

{p 8 12 2}
2.  You can cover up this appearance of inaccuracy by storing all your 
    data in double precision.  This will double (or more) the size of your 
    dataset, and so we do not recommend the double-precision solution
    unless your dataset is small relative to the amount of memory on your
    computer.  In that case, there is nothing wrong with storing all your 
    data in double precision.

{p 12 12 2}
    The easiest way to implement the double-precision solution is by typing
    {cmd:set} {cmd:type} {cmd:double}.  After that, Stata will default
    to creating all new variables as doubles, at least for the remainder of 
    the session.  If all your datasets are small
    relative to the amount of memory on your computer, you can {cmd:set}
    {cmd:type} {cmd:double,} {cmd:permanently}; see
    {bf:{help generate:[D] generate}}.

{p 8 12 2}
3.  The double-precision solution is needlessly wasteful of memory.  It is
     difficult to imagine data that are accurate to more than float precision.
     Regardless of how your data are stored, Stata does all calculations in 
     double precision, and sometimes in quad precision. 

{p 12 12 2}
    The issue of 1.1 not being equal to 1.1 arises only with "nice"
    decimal numbers.  You just have to remember to use Stata's 
    {cmd:float()} function when dealing with such numbers.
 

{marker whycount}{...}
{title:Why count x==1.1 produces 0}

{p 4 4 2}
Let's trace through what happens when you type the commands

	. {cmd:generate x = 1.1}

	. {cmd:count if x==1.1}
	     0

{p 4 4 2}
Here is how it works:

{phang2}
1.
    Some numbers have no exact finite-digit binary representation, just as some
    numbers have no exact finite-digit decimal representation.  One-third, or
    0.3333... (base 10), is an example of a number with no exact finite-digit
    decimal representation.  In base 12, one-third does have an exact
    finite-digit representation, namely, 0.4 (base 12).  In base 2 (binary),
    base 10 numbers such as 0.1, 0.2, 0.3, 0.4, 0.6, ..., have no exact 
    finite-digit representation.

{phang2}
2. 
    Computers store numbers with a finite number of binary digits.  In float
    precision, numbers have 24 binary digits.  In double precision, they have
    53 binary digits.

{pmore2}
    The decimal number 1.1 in binary is 1.000110011001... (base 2). 
    The 1001 on the end repeats forever.  Thus 1.1 (base 10) is stored by a
    computer as

                 1.00011001100110011001101

{pmore2}
    in float, or as 

                 1.0001100110011001100110011001100110011001100110011010

{pmore2}
    in double.  There are 24 and 53 digits in the numbers above.

{phang2}
    4.  Typing {cmd:generate} {cmd:x} {cmd:=} {cmd:1.1} results in {cmd:1.1}
        being interpreted as the longer binary number.  Stata performs all 
        calculations in double precision. 
        New variable {cmd:x} is created as a float by default. 
        When the more precise number is stored in {cmd:x}, it is rounded to
        the shorter number.

{phang2}
    5.  Thus when you {cmd:count} {cmd:if} {cmd:x==1.1}, the result is {cmd:0}
        because {cmd:1.1} is again interpreted as the longer binary number.
	The longer number is compared with the shorter number stored in
        {cmd:x}, and they are not equal. 


{marker howfloat}{...}
{title:How count x==float(1.1) solves the problem}

{p 4 4 2}
One way to fix the problem is to change {cmd:count if x==1.1}
to read {cmd:count if x==float(1.1)}:

	. {cmd:generate x = 1.1}

	. {cmd:count if x==float(1.1)}
	   100

{p 4 4 2}
Function {cmd:float()} rounds results to float precision.  When you type
{cmd:float(1.1)}, the {cmd:1.1} is converted to binary, double precision,
namely,

         1.0001100110011001100110011001100110011001100110011010 (base 2)

{p 4 4 2}
{cmd:float()} then rounds that long binary number to

         1.00011001100110011001101 (base 2)

{p 4 4 2}
Or more correctly, it rounds to 

         1.0001100110011001100110000000000000000000000000000000 (base 2)

{p 4 4 2}
because the number is still stored in double precision.  Regardless, this new
value is equal to the value stored in {cmd:x}, and so {cmd:count} reports that
100 observations contain {cmd:float(1.1)}.  

{p 4 4 2}
As an aside, when you typed {cmd:generate x = 1.1},
Stata acted as if you typed {cmd:generate x = float(1.1)}.
Whenever you type {cmd:generate x = } ... and {cmd:x} is a float, 
Stata acts as if you had typed {cmd:generate x = float(}...{cmd:)}.


{marker coverup}{...}
{title:How storing data as double appears to solve the problem (and does)}

{pstd}
When you type 

	. {cmd:generate double x = 1.1}

	. {cmd:count if x==1.1}
	   100

{pstd}
it should be pretty obvious how the problem is solved.  Stata stores 

        1.0001100110011001100110011001100110011001100110011010 (base 2)

{pstd}
in {cmd:x}, and then compares the stored result to 

        1.0001100110011001100110011001100110011001100110011010 (base 2)

{pstd} 
and of course they are equal. 

{pstd}
In {it:{help precision##summary:Summary}}, we referred to this strategy as 
a cover-up.  It is a cover-up because 1.1 (base 10) is not what is stored 
in {cmd:x}.  What is stored in {cmd:x} is the binary number just shown.
To be equal to 1.1 (base 10), the binary number needs to be suffixed with 
1001, and then another 1001, and then another, and so on without end. 

{pstd}
Stata tells you that {cmd:x} is equal to {cmd:1.1} because Stata
converted the {cmd:1.1} in {cmd:count} to the same inexact binary
representation that Stata previously stored in {cmd:x}.  Those two values
are equal, but neither is equal to 1.1 (base 10).  This inequality leads to an
important property of digital computers:

{p 12 12 12}
        If storage and calculation are done to the same precision, it will
        appear to the user as if all numbers that the user types are stored
        without error.

{pstd}
That is, it {it:appears} to you as if there is no inaccuracy in storing
1.1 in {cmd:x} when {cmd:x} is a double because Stata performs calculations
in double.  And it is equally true that it {it:would} {it:appear} to you as
if there were no accuracy issues storing 1.1 when {cmd:x} is stored in float
precision if Stata, observing that {cmd:x} is float, performed calculations
involving {cmd:x} in float.  The fact is that there are accuracy issues in
both cases.

{pstd}
"Wait," you are probably thinking.  "I understand your argument, but I have
always heard that float is inaccurate and double is accurate.  I understand
from your argument that it is only a matter of degree but, in this case, those
two degrees are on opposite sides of an important line."

{pstd}
"No," I respond. 

{pstd}
What you have heard is right with respect to calculation.  What you have heard
might apply to data storage, too, but that is unlikely.  It turns out that
float provides plenty of precision to store most real measurements.


{marker floataccuracy}{...}
{title:Float is plenty accurate to store most data}

{pstd} 
The misconception that float precision is inaccurate comes from the true
statement that float precision is not accurate enough when it comes to making
calculations with stored values.  Whether float precision is accurate enough
for storing values depends solely on the accuracy with which the values are
measured.

{pstd} 
Float precision provides 24 base-2 (binary) digits, and thus values stored 
in float precision have a maximum relative error 
of +/-2^(-24) = 5.96e-08, or less than +/-1 part
in 15 million.

{p 8 12 2}
1.  The U.S. deficit in 2011 is projected to be $1.5 trillion.  
    Stored as a float, the number has a (maximum) error of 2^(-24) * 1.5e+12 = 
    $89,407.  That is, if the true number is 1.5 trillion, the
    number recorded in float precision is guaranteed to be somewhere in the 
    range [(1.5e+12)-89,407, (1.5e+12)+89,407].  The projected U.S. deficit is 
    not known to an accuracy of +/-$89,407. 

{p 8 12 2}
2.  People in the United States work about 40 hours per week, or roughly 0.238
    of the hours in the week.  2^(-24) * 0.238 = 1.419e-09 of a week, or 0.1
    milliseconds.   Time worked in a week is not known to an accuracy of +/-0.1
    milliseconds.

{p 8 12 2}
3.  A cancer survivor might live 350 days.  2^(-24) * 350 = .00002086, 
    or 1.8 seconds.  Time of death is rarely recorded to an accuracy of +/-1.8
    seconds.  Time of diagnosis is never recorded to such accuracy, nor 
    could it be.

{p 8 12 2}
4.  The moon is said to be 384,401 kilometers from Earth. 
    2^(-24) * 384,401 = 0.023 kilometers, or 23 meters. 
    At its closest and farthest, the moon is 356,400 and 406,700 
    kilometers from Earth.

{p 8 12 2}
5.  Most fundamental constants of the universe are known to a few parts 
    in a million, which is to say, less than 1 part in 15 million, the
    accuracy float precision can provide.  An exception is the speed of light,
    measured to be 299,793.458 kilometers per second.  Record that as a float
    and you will be off by 0.01 km/s.

{pstd}
In all the examples except the last one, quoted are worst-case scenarios. 
The actual errors depend on the exact numbers and are more tedious to
calculate (not shown):

{p 8 12 2}
    1.  For the U.S. deficit, the exact error for $1.5 trillion is -$26,624,
        which is within the +/-$89,407 quoted.

{p 8 12 2}
    2.  For fraction of the week, at 0.238 the error is -0.04 milliseconds,
        which is within the +/-0.1 milliseconds quoted.

{p 8 12 2}
    3.  For cancer survival time, at 350 days the actual error is 0, 
        which is within the +/-1.8 seconds quoted.

{p 8 12 2}
    4.  For the distance between the Earth and moon, the actual error is 0, 
        which is within the +/-23 meters quoted.

{pstd}
The actual errors may be interesting, but the maximum errors are more useful.
Remember the multiplier 2^(-24).  All you have to do is multiply a measurement
by 2^(-24) and compare the result with the inherent error in the measurement.
If 2^(-24) multiplied by the measurement is less than the inherent error, you
can use float precision to store your data.  Otherwise, you need to use
double precision.

{pstd}
By the way, the formula 

	{it:maximum_error} = 2^(-24) * {it:x} 

{pstd}
is an approximation.  For those who want to be precise, the true formula is

	{it:maximum_error} = 2^(-24) * 2^(floor(log2({it:x})))

{pstd}
It can be readily proven that 
{it:x} >= 2^(floor(log2({it:x}))), and thus the approximation formula
overstates the maximum error.  The approximation formula can overstate the
maximum error by as much as a factor of 2.

{pstd}
Float precision is adequate for most data.  There is 
one kind of data, however, where float precision may not be adequate, 
and that is financial data such as sales data, general ledgers, and the 
like.  People working with dollar-and-cent data, euro-and-euro cent data, 
pound sterling-and-penny data, or any other currency data usually find it
best to use doubles.  To avoid rounding issues, it is preferable to store the
data as pennies, too.  Float-precision binary cannot store 0.01, 0.02, and the
like, exactly.  Integer values, however, can be stored exactly, at least up to
16,777,215 in the case of float precision.

{pstd}
Floats can store up to 16,777,215 exactly.  If you stored your data in pennies, 
that would correspond to $167,772.15.  

{pstd}
Doubles can store up to 9,007,199,254,740,991 exactly.  If you stored your 
data in pennies, they would correspond to $90,071,992,547,409.91, or just 
over $90 trillion.  


{marker excel}{...}
{title:Why do I not have these problems using Excel?}

{pstd}
You do not have these problems when you use Excel because Excel stores
numeric values in double precision.  As we explained in
{it:{help precision##howfloat:How count x==float(1.1) solves the problem}}, 

{p 12 12 12}
        If storage and calculation are done to the same precision, it will
        appear to the user as if all numbers that the user types are
        stored without error.

{pstd}
You can adopt the Excel solution in Stata by typing 

	. {cmd:set type double, permanently}

{pstd}
You will double (or more) the amount of memory Stata uses to store your 
data.  But if that is not of concern to you, there are no other disadvantages 
to adopting this solution.   If you adopt this solution and later wish 
to change your mind, type 

	. {cmd:set type float, permanently}

{pstd}
See {bf:{help generate:[D] generate}}.
