{smcl}
{* *! version 1.1.6  06sep2019}{...}
{vieweralsosee "[P] #delimit" "mansection P delimit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] comments" "help comments"}{...}
{vieweralsosee "[U] 10 Keyboard use" "help keyboard"}{...}
{viewerjumpto "Syntax" "delimit##syntax"}{...}
{viewerjumpto "Description" "delimit##description"}{...}
{viewerjumpto "Remarks" "delimit##remarks"}{...}
{viewerjumpto "Examples" "delimit##examples"}{...}
{viewerjumpto "Technical note" "delimit##technote"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[P] #delimit} {hline 2}}Change delimiter{p_end}
{p2col:}({mansection P delimit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}{cmdab:#d:elimit} {c -(} {cmd:cr} | {cmd:;} {c )-}


{marker description}{...}
{title:Description}

{pstd}
The {cmd:#delimit} command resets the character that marks the end of a
command.  It can be used only in do-files and ado-files.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:#delimit} (pronounced pound-delimit) is a Stata preprocessor command.
{cmd:#}{it:commands} do not generate a return code, nor do they generate
ordinary Stata errors.  The only error message associated with
{cmd:#}{it:commands} is "unrecognized #command".

{pstd}
Commands given from the console are always executed when you press the Enter,
or Return, key.  {cmd:#delimit} cannot be used interactively, so you cannot
change Stata's interactive behavior.

{pstd}
Commands in a do-file, however, may be delimited with a carriage return or a
semicolon.  When a do-file begins, the delimiter is a carriage return.  The
command "{cmd:#delimit ;}" changes the delimiter to a semicolon.  To restore
the carriage return delimiter inside a file, use {cmd:#delimit cr}.

{pstd}
When a do-file begins execution, the delimiter is automatically set to
carriage return, even if it was called from another do-file that set the
delimiter to semicolon.  Also, the current do-file need not worry about
restoring the delimiter to what it was because Stata will do that
automatically.


{marker examples}{...}
{title:Examples}

	{hline 3} begin myfile1.do {hline 27}
	{cmd:use mydata, clear}
	{cmd:#delimit ;}
	{cmd:regress lnwage educ complete age c.age#c.age}
		{cmd:exp c.exp#c.exp tenure c.tenure#c.tenure}
		{cmd:i.region female ;}
	{cmd:predict e, resid ;}
	{cmd:#delimit cr}
	{cmd:summarize e, detail}
	{hline 3} end myfile1.do {hline 29}


{pstd}
Another way to do this without {cmd:#delimit} would be

	{hline 3} begin myfile2.do {hline 33}
	{cmd:use mydata, clear}
	{cmd:regress lnwage educ complete age c.age#c.age /*}
		{cmd:*/ exp c.exp#c.exp tenure c.tenure#c.tenure /*}
		{cmd:*/ i.region female}
	{cmd:predict e, resid}
	{cmd:summarize e, detail}
	{hline 3} end myfile2.do {hline 35}

{pstd}
See {findalias frdolonglines} for more information.


{marker technote}{...}
{title:Technical note}

{pstd}
Just because you have long lines does not mean that you must change the
delimiter to semicolon.  Stata does not care that the line is long.
There are also other ways to indicate that more than one physical line is one
logical line.  One popular choice is {cmd:///}:

	{cmd:regress lnwage educ complete age c.age#c.age     /// }
		{cmd:exp c.exp#c.exp tenure c.tenure#c.tenure /// }
		{cmd:i.region female}

{pstd}
See {manhelp comments P}.
{p_end}
