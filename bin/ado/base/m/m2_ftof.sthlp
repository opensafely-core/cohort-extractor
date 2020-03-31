{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-2] ftof" "mansection M-2 ftof"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Intro" "help m2_intro"}{...}
{viewerjumpto "Syntax" "m2_ftof##syntax"}{...}
{viewerjumpto "Description" "m2_ftof##description"}{...}
{viewerjumpto "Links to PDF documentation" "m2_ftof##linkspdf"}{...}
{viewerjumpto "Remarks" "m2_ftof##remarks"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[M-2] ftof} {hline 2}}Passing functions to functions
{p_end}
{p2col:}({mansection M-2 ftof:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

		{it:example}{cmd:(}...{cmd:,} {cmd:&}{it:somefunction}{cmd:(),} ...{cmd:)}


	where {it:example}{cmd:()} is coded


		{cmd:function} {it:example}{cmd:(}...{cmd:,} {it:f}{cmd:,} ...{cmd:)}
		{cmd:{c -(}}
			...
			{cmd:(*}{it:f}{cmd:)}{cmd:(}...{cmd:)}
			...
		{cmd:{c )-}}


{marker description}{...}
{title:Description}

{p 4 4 2}
Functions can receive other functions as arguments.

{p 4 4 2}
Below is described (1) how to call a function that receives a function 
as an argument and (2) how to write a function that receives a function 
as an argument.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-2 ftofRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help m2_ftof##remarks1:Passing functions to functions}
	{help m2_ftof##remarks2:Writing functions that receive functions, the simplified convention}
	{help m2_ftof##remarks3:Passing built-in functions}


{marker remarks1}{...}
{title:Passing functions to functions}

{p 4 4 2}
Someone has written a program that receives a function as an argument.
We will imagine that function is

		{it:real scalar} {cmd:fderiv(}{it:function}{cmd:()}{cmd:,} {it:x}{cmd:)}

{p 4 4 2}
and that {cmd:fderiv()} numerically evaluates the derivative of
{it:function}{cmd:()} at {it:x}.  The documentation for {cmd:fderiv()} tells
you to write a function that takes one argument and returns the
evaluation of the function at that argument, such as 

	{cmd}real scalar expratio(real scalar x)
	{
		return(exp(x)/exp(-x))
	}{txt}

{p 4 4 2}
To call {cmd:fderiv()} and have it evaluate the derivative of
{cmd:expratio()} at 3, you code

	{cmd:fderiv(&expratio(), 3)}

{p 4 4 2}
To pass a function to a function, you code {cmd:&} in front of the function's
name and {cmd:()} after.  
Coding {cmd:&expratio()} passes the address of the function {cmd:expratio()} to
{cmd:fderiv()}.


{marker remarks2}{...}
{title:Writing functions that receive functions, the simplified convention}

{p 4 4 2}
To receive a function, you include a variable among the program arguments 
to receive the function -- we will use {it:f} -- and you then
code {cmd:(*}{it:f}{cmd:)(}...{cmd:)} to call the passed function.  The code
for {cmd:fderiv()} might read

	{cmd}function fderiv(f, x)
	{
		return( ((*f)(x+1e-6) - (*f)(x)) / 1e-6 )
	}{txt}

{p 4 4 2}
or, if you prefer to be explicit about your declarations,

	{cmd}real scalar fderiv(pointer scalar f, real scalar x)
	{
		return( ((*f)(x+1e-6) - (*f)(x)) / 1e-6 )
	}{txt}

{p 4 4 2}
or, if you prefer to be even more explicit:

        {cmd}
{phang2}real scalar fderiv(pointer(real scalar function) scalar f, real scalar x){p_end}
	{
		return( ((*f)(x+1e-6) - (*f)(x)) / 1e-6 )
	}{txt}

{p 4 4 2}
In any case, using pointers, you type {cmd:(*f)(}...{cmd:)} to execute the
function passed.  See {bf:{help m2_pointers:[M-2] pointers}} for more
information.

{p 4 4 2}
Aside: the function {cmd:fderiv()} would work but, because of the formula
it uses, would return very inaccurate results.


{marker remarks3}{...}
{title:Passing built-in functions}

{p 4 4 2}
You cannot pass built-in functions to other functions.  For instance,
{bf:{help mf_exp:[M-5] exp()}} is built in, which is revealed by 
{bf:{help mata_which:[M-3] mata which}}:

	: {cmd:mata which exp()}
	  exp():  built-in

{p 4 4 2}
Not all official functions are built in.  Many are implemented in Mata as
library functions, but {cmd:exp()} is built in and coding {cmd:&exp()} will
result in an error.  If you wanted to pass {cmd:exp()} to a function, create
your own version of it

	: {cmd:function myexp(x) return(exp(x))}

{p 4 4 2}
and then pass {cmd:&myexp()}.
{p_end}
