{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-2] Semicolons" "mansection M-2 Semicolons"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Intro" "help m2_intro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] #delimit" "help delimit"}{...}
{viewerjumpto "Syntax" "m2_semicolons##syntax"}{...}
{viewerjumpto "Description" "m2_semicolons##description"}{...}
{viewerjumpto "Links to PDF documentation" "m2_semicolons##linkspdf"}{...}
{viewerjumpto "Remarks" "m2_semicolons##remarks"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[M-2] Semicolons} {hline 2}}Use of semicolons
{p_end}
{p2col:}({mansection M-2 Semicolons:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{it:stmt}

	{it:stmt} {cmd:;}


{marker description}{...}
{title:Description}

{p 4 4 2}
Mata allows, but does not require, semicolons.  

{p 4 4 2}
Use of semicolons is discussed
below, along with advice on the possible interactions of 
Stata's {cmd:#delimit} instruction; see 
{bf:{help delimit:[P] #delimit}}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-2 SemicolonsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help m2_semicolons##remarks1:Optional use of semicolons}
	{help m2_semicolons##remarks2:You cannot break a statement anywhere even if you use semicolons}
	{help m2_semicolons##remarks3:Use of semicolons to create multistatement lines}
	{help m2_semicolons##remarks4:Significant semicolons}
	{help m2_semicolons##remarks5:Do not use #delimit ;}


{marker remarks1}{...}
{title:Optional use of semicolons}

{p 4 4 2}
You can code your program to look like this

	{cmd}real scalar foo(real matrix A)
	{c -(}
		real scalar	i, sum

		sum = 0 
		for (i=1; i<=rows(A); i++) {c -(}
			sum = sum + A[i,i]
		{c )-}
		return(sum)
	{c )-}{txt}

{p 4 4 2}
or you can code your program to look like this: 

	{cmd}real scalar foo(real matrix A)
	{c -(}
		real scalar	i, sum ;

		sum = 0 ;
		for (i=1; i<=rows(A); i++) {c -(}
			sum = sum + A[i,i] ;
		{c )-}
		return(sum) ;
	{c )-}{txt}

{p 4 4 2}
That is, you may omit or include semicolons at the end of statements.
It makes no difference.  You can even mix the two styles:

	{cmd}real scalar foo(real matrix A)
	{c -(}
		real scalar	i, sum ;

		sum = 0 ;
		for (i=1; i<=rows(A); i++) {c -(}
			sum = sum + A[i,i]
		{c )-}
		return(sum)
	{c )-}{txt}


{marker remarks2}{...}
{title:You cannot break a statement anywhere even if you use semicolons}

{p 4 4 2}
Most languages that use semicolons follow the rule that a statement 
continues up to the semicolon. 

{p 4 4 2}
Mata follows a different rule:  a statement continues across lines until it
looks to be complete, and semicolons force the end of statements.

{p 4 4 2}
For instance, consider the statement {cmd:x=b-c} appearing in some program.
In the code, might appear 

			{cmd:x = b -}
			{cmd:c}

{p 4 4 2}
or

			{cmd:x = b -}
			{cmd:c ;}

{p 4 4 2}
and, either way, Mata will understand the statement to be {cmd:x=b-c}, because
the statement could not possibly end at the minus:  {cmd:x=b-} makes no sense.

{p 4 4 2}
On the other hand, 

			{cmd:x = b}
			{cmd:- c}

{p 4 4 2}
would be interpreted by Mata as two statements:  {cmd:x=b} and {cmd:-c}
because {bind:{cmd:x = b}} looks like a completed statement to Mata.
The first statement will assign {cmd:b} to {it:x}, and the second statement
will display the negative value of {cmd:c}.

{p 4 4 2}
Adding a semicolon will not help:

			{cmd:x = b}
			{cmd:- c ;}

{p 4 4 2}
{bind:{cmd:x = b}} is still, by itself, a complete
statement.  All that has changed is that the second statement ends in a
semicolon, and that does not matter.

{p 4 4 2}
Thus remember always to break multiline statements at places where the
statement could not possibly be interpreted as being complete, such as

			{cmd:x = b -}
				{cmd:c + (d}
					{cmd:+ e)}

			{cmd:myfunction(A,}
					{cmd:B, C,}
						{cmd:)}

{p 4 4 2}
Do this whether or not you use semicolons.


{marker remarks3}{...}
{title:Use of semicolons to create multistatement lines}

{p 4 4 2}
Semicolons allow you to put more than one statement on a line.  Rather
than coding 

		{cmd:a = 2}
		{cmd:b = 3}

{p 4 4 2}
you can code
		{cmd:a = 2 ;  b = 3 ;}

{p 4 4 2}
and you can even omit the trailing semicolon:

		{cmd:a = 2 ;  b = 3}

{p 4 4 2}
Whether you code separate statements on separate lines or the same line 
is just a matter of style; it does not change the meaning. Coding

		{cmd:for (i=1; i<n; i++) a[i] = -a[i] ; sum = sum + a[i] ;}

{p 4 4 2}
still means

		{cmd:for (i=1; i<n; i++) a[i] = -a[i] ;}
		{cmd:sum = sum + a[i] ;}

{p 4 4 2}
and without doubt, the programmer intended to code

		{cmd:for (i=1; i<n; i++) {c -(}}
			{cmd:a[i] = -a[i] ;}
			{cmd:sum = sum + a[i] ;}
		{cmd:{c )-}}

{p 4 4 2}
which has a different meaning.


{marker remarks4}{...}
{title:Significant semicolons}

{p 4 4 2}
Semicolons are not all style.  The syntax for the {cmd:for} statement 
is (see {bf:{help m2_for:[M-2] for}})

		{cmd:for (}{it:exp1}{cmd:;} {it:exp2}{cmd:;} {it:exp3}{cmd:)} {it:stmt}

{p 4 4 2}
Say that the complete {cmd:for} loop that we want to code is 

		{cmd:for (x=init(); !converged(x); iterate(x))}

{p 4 4 2}
and that there is no {it:stmt} following it.  Then we must code

		{cmd:for (x=init(); !converged(x); iterate(x)) ;}

{p 4 4 2}
Here we use the semicolon to force the end of the statement.  
Say we omitted it, and the code read

		...
		{cmd:for (x=init(); !converged(x); iterate(x))}
		{cmd:x = -x}
		...

{p 4 4 2}
The {cmd:for} statement would look incomplete to Mata, so it would 
interpret our code as if we had coded

		{cmd:for (x=init(); !converged(x); iterate(x)) {c -(}}
			{cmd:x = -x}
		{cmd:{c )-}}

{p 4 4 2}
Here the semicolon is significant.  

{p 4 4 2}
Significant semicolons only happen following {cmd:for} and {cmd:while}.


{marker remarks5}{...}
{title:Do not use #delimit ;}

{p 4 4 2}
What follows has to do with Stata's {cmd:#delimit ;} mode.  If you do not 
know what it is or if you never use it, you can skip what follows.

{p 4 4 2}
Stata has an optional ability to allow its lines to continue up to 
semicolons.  In Stata, you code 

	. {cmd:#delimit ;}

{p 4 4 2}
and the delimiter is changed to semicolon until your do-file or ado-file 
ends, or until you code

	. {cmd:#delimit cr}

{p 4 4 2}
We recommend that you do not use Mata when Stata is in {cmd:#delimit ;} mode.
Mata will not mind, but you will confuse yourself.

{p 4 4 2}
When Mata gets control, if {cmd:#delimit ;} is on, Mata turns it off
temporarily, and then Mata applies its own rules, which we have
summarized above.
{p_end}
