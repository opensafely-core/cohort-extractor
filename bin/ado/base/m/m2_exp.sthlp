{smcl}
{* *! version 1.1.10  15may2018}{...}
{vieweralsosee "[M-2] exp" "mansection M-2 exp"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Intro" "help m2_intro"}{...}
{viewerjumpto "Syntax" "m2_exp##syntax"}{...}
{viewerjumpto "Description" "m2_exp##description"}{...}
{viewerjumpto "Links to PDF documentation" "m2_exp##linkspdf"}{...}
{viewerjumpto "Remarks" "m2_exp##remarks"}{...}
{viewerjumpto "Reference" "m2_exp##reference"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[M-2] exp} {hline 2}}Expressions
{p_end}
{p2col:}({mansection M-2 exp:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{it:exp}


{marker description}{...}
{title:Description}

{p 4 4 2}
{it:exp} is used in syntax diagrams to mean "any valid expression may 
appear here".  Expressions can range from being simple constants

		{cmd:2}
		{cmd:"this"}
		{cmd:3+2i}

{p 4 4 2}
to being names of variables

		{cmd:A}
		{cmd:beta}
		{cmd:varwithverylongname}

{p 4 4 2}
to being a full-fledged scalar, string, or matrix expression:

		{cmd:sqrt(2)/2}
		{cmd:substr(userinput, 15, strlen(otherstr))}
		{cmd:conj(X)'X}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-2 expRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help m2_exp##remarks1:What's an expression}
	{help m2_exp##remarks2:Assignment suppresses display, as does (void)}
	{help m2_exp##remarks3:The pieces of an expression}
	{help m2_exp##remarks4:Numeric literals}
	{help m2_exp##remarks5:String literals}
	{help m2_exp##remarks6:Variable names}
	{help m2_exp##remarks7:Operators}
	{help m2_exp##remarks8:Functions}


{marker remarks1}{...}
{title:What's an expression}

{p 4 4 2}
Everybody knows what an expression is:  expressions are things like {cmd:2+3}
and {cmd:invsym(X'X)*X'y}.  
Simpler things are also expressions, such as numeric constants

		{cmd:2}                is an expression

{p 4 4 2}
and string literals

		{cmd:"hi there"}       is an expression

{p 4 4 2}
and function calls:

		{cmd:sqrt(2)}          is an expression

{p 4 4 2}
Even when functions do not return anything (the function is void), 
the code that causes the function to run is an expression.  For instance, 
the function {cmd:swap()} (see {bf:{help mf_swap:[M-5] swap()}}) interchanges
the contents of its arguments and returns nothing.  Even so, 

		{cmd:swap(A, B)}      is an expression

		
{marker remarks2}{...}
{title:Assignment suppresses display, as does (void)}

{p 4 4 2}
The equal sign assigns the result of an expression to a variable.  For 
instance, 

		{cmd:a = 2 + 3}

{p 4 4 2}
assigns 5 to {cmd:a}.  When the result of an expression is not assigned 
to a variable, the result is displayed at the terminal.  This is true of 
expressions entered interactively and of expressions coded in programs.  For
instance, given the program

	{cmd}function example(a, b)
	{
		"the answer is"
		a+b
	}{txt}

{p 4 4 2}
executing {cmd:example()} produces 

	: {cmd:example(2, 3)}
	  the answer is
	  5

{p 4 4 2}
The fact that 5 appeared is easy enough to understand; we coded the 
expression {cmd:a+b} without assigning it to another variable.
The fact that "the answer is" also appeared may surprise you.
Nevertheless, we coded {cmd:"the} {cmd:answer} {cmd:is"} is our program, 
and that is an example of an expression, and because we did not assign the 
expression to a variable, it was displayed.

{p 4 4 2}
In programming situations, there will be times when you want to execute a 
function -- call it {cmd:setup()} -- but do not care what the function
returns, even though the function itself is not void (that is, it returns
something).  If you code

	{cmd:function example(}...{cmd:)}
	{cmd:{c -(}}
		...
		{cmd:setup(}...{cmd:)}
		...
	{cmd:{c )-}}

{p 4 4 2}
the result will be to display what {cmd:setup()} returns.  You have two 
alternatives.  You could assign the result of {cmd:setup} to a variable 
even though you will subsequently not use the variable

	{cmd:function example(}...{cmd:)}
	{cmd:{c -(}}
		...
		{cmd:result = setup(}...{cmd:)}
		...
	{cmd:{c )-}}

{p 4 4 2}
or you could cast the result of the function to be void:

	{cmd:function example(}...{cmd:)}
	{cmd:{c -(}}
		...
		{cmd:(void) setup(}...{cmd:)}
		...
	{cmd:{c )-}}

{p 4 4 2}
Placing {cmd:(void)} in front of an expression prevents the result from 
being displayed.


{marker remarks3}{...}
{title:The pieces of an expression}

{p 4 4 2}
Expressions comprise

	        {help m2_exp##remarks4:numeric literals}
      	        {help m2_exp##remarks5:string literals}
	        {help m2_exp##remarks6:variable names}
	        {help m2_exp##remarks7:operators}
	        {help m2_exp##remarks8:functions}


{marker remarks4}{...}
{title:Numeric literals}

{p 4 4 2}
Numeric literals are just numbers

		{cmd}2
		3.14159
		-7.2
		5i
		1.213e+32
		1.213E+32
		1.921fb54442d18X+001
		1.921fb54442d18x+001
		.
		.a
		.b{txt}

{p 4 4 2}
but you can suffix an {cmd:i} onto the end to mean 
imaginary, such as {cmd:5i} above.  To create complex numbers, you 
combine real and imaginary numbers using the {cmd:+} operator, 
as in {cmd:2+5i}.  In any case, you can put the {cmd:i} on the end of any
literal, so {cmd:1.213e+32i} is valid, as is {cmd:1.921fb54442d18X+001i}.

{p 4 4 2}
{cmd:1.921fb54442d18X+001i} is a formidable-looking beast, with or without the
{cmd:i}.  {cmd:1.921fb54442d18X+001} is a way of writing floating-point
numbers in binary; it is described in
{findalias frformats}.  Most people never use it.

{p 4 4 2}
Also, numeric literals include Stata's missing values, {cmd:.}, 
{cmd:.a}, {cmd:.b}, ..., {cmd:.z}.  

{p 4 4 2}
Complex variables may contain missing just as real variables may, but 
they get only one:  {cmd:.a+.bi} is not allowed.  A complex variable 
contains a valid complex value, or it contains {cmd:.}, {cmd:.a}, 
{cmd:.b}, ..., {cmd:.z}.


{marker remarks5}{...}
{title:String literals}

{p 4 4 2}
String literals are enclosed in double quotes or in compound double quotes:

		{cmd}"the answer is"
		"a string"
		`"also a string"'
		`"The "factor" of a matrix"'
		""
		`""'{txt}

{p 4 4 2}
Strings in Mata contain between 0 and 2,147,483,647 bytes.  {cmd:""} or
{cmd:`""'} is how one writes the 0-length string.

{p 4 4 2}
Any plain ASCII or {help m6_glossary##utf8:UTF-8} character may appear in the
string, but no provision is provided for typing unprintable characters into
the string literal.  Instead, you use the {cmd:char()} function; see
{bf:{help mf_ascii:[M-5] ascii()}}.  For instance, {cmd:char(13)} is carriage
return, so the expression

		{cmd:"my string" + char(13)}

{p 4 4 2}
produces "my string" followed by a carriage return.

{p 4 4 2}
No character is given a special interpretation.  In particular, 
backslash ({cmd:\}) is given no special meaning by Mata.
The string literal {cmd:"my string\n"} is just that: 
the characters "my string" followed by a backslash followed by an {it:n}.
Some functions, such as {cmd:printf()} (see
{bf:{help mf_printf:[M-5] printf()}}), give a 
special meaning to the two-character sequence {cmd:\n}, but that 
special interpretation is a property of the function, not Mata, and 
is noted in the function's documentation.

{p 4 4 2}
Strings are not zero (null) terminated in Mata.  Mata knows that the string
"{cmd:hello}" is of length 5, but it does not achieve that knowledge by padding
a binary 0 as the string's fifth character.  Thus strings may be used to hold
binary information.

{p 4 4 2}
Although Mata gives no special interpretation to binary 0, some Mata functions 
do.  For instance, {cmd:strmatch(}{it:s}{cmd:,} {it:pattern}{cmd:)} 
returns 1 if {it:s} matches {it:pattern} and 0 otherwise;
see {bf:{help mf_strmatch:[M-5] strmatch()}}.
For this function, 
both strings are considered to end at the point they contain a binary 0, if
they contain a binary 0.  Most strings do not, and then the function
considers the entire string.  In any case, if there is special treatment of
binary 0, that is on a function-by-function basis, and a note of that is made
in the function's documentation.

{pstd}
Some string functions in Mata have variants that are designed specifically to
deal with Unicode.  For examples, {helpb mf_usubstr:usubstr()} is the
Unicode-aware version of {helpb mf_substr:substr()}.  See
{findalias frunicode} for more details on working with Unicode strings.


{marker remarks6}{...}
{title:Variable names}

{p 4 4 2}
Variable names are just that.  Names are case sensitive and no abbreviations
are allowed:

		{cmd}X
		x
		MyVar
		VeryLongVariableNameForUseInMata
		MyVariable
{txt}

{p 4 4 2}
The maximum length of a variable name is 32 characters.


{marker remarks7}{...}
{title:Operators}


{col 13}Operators, listed by precedence, low to high

{col 9}Operator{...}
{col 23}Operator name{...}
{col 50}Documentation
{...}
{...}
{...}
{col 9}{hline 57}
{...}
{...}
{...}
{...}
{col 9}{it:a}  {cmd:=}  {it:b}{...}
{col 23}assignment{...}
{col 50}{bf:{help m2_op_assignment:[M-2] op_assignment}}

{col 9}{it:a}  {cmd:?}  {it:b}  {cmd::}  {it:c}{...}
{col 23}conditional{...}
{col 50}{bf:{help m2_op_conditional:[M-2] op_conditional}}

{col 9}{it:a}  {cmd:\}  {it:b}{...}
{col 23}column join{...}
{col 50}{bf:{help m2_op_join:[M-2] op_join}}

{col 9}{it:a}  {cmd:::} {it:b}{...}
{col 23}column to{...}
{col 50}{bf:{help m2_op_range:[M-2] op_range}}

{col 9}{it:a}  {cmd:,}  {it:b}{...}
{col 23}row join{...}
{col 50}{bf:{help m2_op_join:[M-2] op_join}}

{col 9}{it:a}  {cmd:..} {it:b}{...}
{col 23}row to{...}
{col 50}{bf:{help m2_op_range:[M-2] op_range}}

{col 9}{it:a} {cmd::|}  {it:b}{...}
{col 23}e.w. or{...}
{col 50}{bf:{help m2_op_colon:[M-2] op_colon}}

{col 9}{it:a}  {cmd:|}  {it:b}{...}
{col 23}or{...}
{col 50}{bf:{help m2_op_logical:[M-2] op_logical}}

{col 9}{it:a} {cmd::&}  {it:b}{...}
{col 23}e.w. and{...}
{col 50}{bf:{help m2_op_colon:[M-2] op_colon}}

{col 9}{it:a}  {cmd:&}  {it:b}{...}
{col 23}and{...}
{col 50}{bf:{help m2_op_logical:[M-2] op_logical}}

{col 9}{it:a} {cmd::==} {it:b}{...}
{col 23}e.w. equal{...}
{col 50}{bf:{help m2_op_colon:[M-2] op_colon}}

{col 9}{it:a} {cmd: ==} {it:b}{...}
{col 23}equal{...}
{col 50}{bf:{help m2_op_logical:[M-2] op_logical}}

{col 9}{it:a} {cmd::>=} {it:b}{...}
{col 23}e.w. greater than or equal{...}
{col 50}{bf:{help m2_op_colon:[M-2] op_colon}}

{col 9}{it:a} {cmd: >=} {it:b}{...}
{col 23}greater than or equal{...}
{col 50}{bf:{help m2_op_logical:[M-2] op_logical}}

{col 9}{it:a} {cmd::<=} {it:b}{...}
{col 23}e.w. less than or equal{...}
{col 50}{bf:{help m2_op_colon:[M-2] op_colon}}

{col 9}{it:a}  {cmd:<=} {it:b}{...}
{col 23}less than or equal{...}
{col 50}{bf:{help m2_op_logical:[M-2] op_logical}}

{col 9}{it:a} {cmd::<} {it:b}{...}
{col 23}e.w. less than{...}
{col 50}{bf:{help m2_op_colon:[M-2] op_colon}}

{col 9}{it:a}  {cmd:<}  {it:b}{...}
{col 23}less than{...}
{col 50}{bf:{help m2_op_logical:[M-2] op_logical}}

{col 9}{it:a} {cmd::>}  {it:b}{...}
{col 23}e.w. greater than{...}
{col 50}{bf:{help m2_op_colon:[M-2] op_colon}}

{col 9}{it:a}  {cmd:>}  {it:b}{...}
{col 23}greater than{...}
{col 50}{bf:{help m2_op_logical:[M-2] op_logical}}

{col 9}{it:a} {cmd::!=} {it:b}{...}
{col 23}e.w. not equal{...}
{col 50}{bf:{help m2_op_colon:[M-2] op_colon}}

{col 9}{it:a}  {cmd:!=} {it:b}{...}
{col 23}not equal{...}
{col 50}{bf:{help m2_op_logical:[M-2] op_logical}}

{col 9}{it:a} {cmd::+}  {it:b}{...}
{col 23}e.w. addition{...}
{col 50}{bf:{help m2_op_colon:[M-2] op_colon}}

{col 9}{it:a}  {cmd:+}  {it:b}{...}
{col 23}addition{...}
{col 50}{bf:{help m2_op_arith:[M-2] op_arith}}

{col 9}{it:a} {cmd::-}  {it:b}{...}
{col 23}e.w. subtraction{...}
{col 50}{bf:{help m2_op_colon:[M-2] op_colon}}

{col 9}{it:a}  {cmd:-}  {it:b}{...}
{col 23}subtraction{...}
{col 50}{bf:{help m2_op_arith:[M-2] op_arith}}

{col 9}{it:a} {cmd::*}  {it:b}{...}
{col 23}e.w. multiplication{...}
{col 50}{bf:{help m2_op_colon:[M-2] op_colon}}

{col 9}{it:a}  {cmd:*}  {it:b}{...}
{col 23}multiplication{...}
{col 50}{bf:{help m2_op_arith:[M-2] op_arith}}

{col 9}{it:a}  {cmd:#}  {it:b}{...}
{col 23}Kronecker{...}
{col 50}{bf:{help m2_op_kronecker:[M-2] op_kronecker}}

{col 9}{it:a} {cmd::/}  {it:b}{...}
{col 23}e.w. division{...}
{col 50}{bf:{help m2_op_colon:[M-2] op_colon}}

{col 9}{it:a}  {cmd:/}  {it:b}{...}
{col 23}division{...}
{col 50}{bf:{help m2_op_arith:[M-2] op_arith}}

{col 9}{cmd:-}{it:a}{...}
{col 23}negation{...}
{col 50}{bf:{help m2_op_arith:[M-2] op_arith}}

{col 9}{it:a} {cmd::^}  {it:b}{...}
{col 23}e.w. power{...}
{col 50}{bf:{help m2_op_colon:[M-2] op_colon}}

{col 9}{it:a}  {cmd:^}  {it:b}{...}
{col 23}power{...}
{col 50}{bf:{help m2_op_arith:[M-2] op_arith}}

{col 9}{it:a}{cmd:'}{...}
{col 23}transposition{...}
{col 50}{bf:{help m2_op_transpose:[M-2] op_transpose}}

{col 9}{cmd:*}{it:a}{...}
{col 23}contents of{...}
{col 50}{bf:{help m2_pointers:[M-2] pointers}}

{col 9}{cmd:&}{it:a}{...}
{col 23}address of{...}
{col 50}{bf:{help m2_pointers:[M-2] pointers}}

{col 9}{cmd:!}{it:a}{...}
{col 23}not{...}
{col 50}{bf:{help m2_op_logical:[M-2] op_logical}}

{col 9}{it:a}{cmd:[}{it:exp}{cmd:]}{...}
{col 23}subscript{...}
{col 50}{bf:{help m2_subscripts:[M-2] Subscripts}}

{col 9}{it:a}{cmd:[|}{it:exp}{cmd:|]}{...}
{col 23}range subscript{...}
{col 50}{bf:{help m2_subscripts:[M-2] Subscripts}}

{col 9}{it:a}{cmd:++}{...}
{col 23}increment{...}
{col 50}{bf:{help m2_op_increment:[M-2] op_increment}}

{col 9}{it:a}{cmd:--}{...}
{col 23}decrement{...}
{col 50}{bf:{help m2_op_increment:[M-2] op_increment}}

{col 9}{cmd:++}{it:a}{...}
{col 23}increment{...}
{col 50}{bf:{help m2_op_increment:[M-2] op_increment}}

{col 9}{cmd:--}{it:a}{...}
{col 23}decrement{...}
{col 50}{bf:{help m2_op_increment:[M-2] op_increment}}
{...}
	{hline 57}
{col 9}(e.w. = elementwise){...}


{marker remarks8}{...}
{title:Functions}

{p 4 4 2}
Functions supplied with Mata are documented in {bf:[M-5]}.
An index to the functions can be found in 
{bf:{help m4_intro:[M-4] Intro}}.
{p_end}


{marker reference}{...}
{title:Reference}

{phang}
Gould, W. W. 2006.
{browse "http://www.stata-journal.com/sjpdf.html?articlenum=pr0025":Mata Matters: Precision}.
{it:Stata Journal} 6: 550-560.
{p_end}
