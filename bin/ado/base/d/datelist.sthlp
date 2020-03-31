{smcl}
{* *! version 1.2.5  15may2018}{...}
{findalias asfrdatelist}
{vieweralsosee "" "--"}{...}
{findalias asfrnumlist}
{title:Title}

    {findalias frdatelist}


{title:Description}

{pstd}
A {it:datelist} is a list of dates or times and is often used with graph
options when the variable being graphed has a date format.  For a description
of how dates and times are stored and manipulated in Stata, see
{findalias frdatetime}.  Calendar dates, also known as {cmd:%td} dates, are
recorded in Stata as the number of days since 01jan1960, so 0 means 01jan1960,
1 means 02jan1960, and 16,541 means 15apr2005.  Similarly, -1 means 31dec1959,
-2 means 30dec1959, and -16,541 means 18sep1914.  In such as case, a datelist
is either a list of dates, as in

{pmore}
	15apr1973{break}
	17apr1973 20apr1973  23apr1973

{pstd}
or it is a first and last date with an increment between, as in

{pmore}
	17apr1973(3)23apr1973

{pstd}
or it is a combination:

{pmore}
	15apr1973 17apr1973(3)23apr1973

{pstd}
Dates specified with spaces, slashes, or commas must be bound in
parentheses, as in

{pmore}
	(15 apr 1973) (april 17, 1973)(3)(april 23, 1973)

{pstd}
Evenly spaced calendar dates are not especially useful, but with other
time units, even spacing can be useful, such as

{pmore}
	1999q1(1)2005q1

{pstd}
when {cmd:%tq} dates are being used.
{cmd:1999q1(1)2005q1} means every quarter between 1999q1 and 2005q1.
{cmd:1999q1(4)2005q1} would mean
every first quarter.

{pstd}
To interpret a datelist, Stata first looks at the format of the related
variable and then uses the corresponding date-to-numeric translation function.
For instance, if the variable has a {cmd:%td} format, the {cmd:td()} function
is used to translate the date; if the variable has a {cmd:%tq} format, the
{cmd:tq()} function is used; and so on.
See {it:{help datetime##s9:Conveniently typing SIF values}}
in {helpb datetime:[D] Datetime}.
