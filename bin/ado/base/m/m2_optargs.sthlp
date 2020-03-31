{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-2] optargs" "mansection M-2 optargs"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Intro" "help m2_intro"}{...}
{viewerjumpto "Syntax" "m2_optargs##syntax"}{...}
{viewerjumpto "Description" "m2_optargs##description"}{...}
{viewerjumpto "Links to PDF documentation" "m2_optargs##linkspdf"}{...}
{viewerjumpto "Remarks" "m2_optargs##remarks"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[M-2] optargs} {hline 2}}Optional arguments
{p_end}
{p2col:}({mansection M-2 optargs:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:function}
{it:functionname}{cmd:(|}{it:arg}
[{cmd:,} {it:arg} [{cmd:,} ...]]{cmd:)} 
{cmd:{c -(}} ... {cmd:{c )-}}

{p 8 16 2}
{cmd:function}
{it:functionname}{cmd:(}{it:arg}{cmd:,} 
{cmd:|}{it:arg} [{cmd:,} ...]{cmd:)}
{cmd:{c -(}} ... {cmd:{c )-}}

{p 8 16 2}
{cmd:function}
{it:functionname}{cmd:(}{it:arg}{cmd:,} 
{it:arg} {cmd:,} {cmd:|}...{cmd:)}
{cmd:{c -(}} ...  {cmd:{c )-}}


{p 4 4 2}
The vertical (or) bar separates required arguments from optional arguments
in function declarations.  The bar may appear at most once.


{marker description}{...}
{title:Description}

{p 4 4 2}
Mata functions may have various numbers of arguments.  How you write 
programs that allow these optional arguments is described below.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-2 optargsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help m2_optargs##remarks1:What are optional arguments?}
	{help m2_optargs##remarks2:How to code optional arguments}
	{help m2_optargs##remarks3:Examples revisited}


{marker remarks1}{...}
{title:What are optional arguments?}

{p 4 4 2}
{it:Example 1}:  
You write a function named {cmd:ditty()}.  Function {cmd:ditty()} allows 
the caller to specify two or three arguments:

{p 8 16 2}
{it:real matrix}
{cmd:ditty(}{it:real matrix A}{cmd:,} 
{it:real matrix B}{cmd:,} 
{it:real scalar scale}{cmd:)}

{p 8 16 2}
{it:real matrix}
{cmd:ditty(}{it:real matrix A}{cmd:,} 
{it:real matrix B}{cmd:)} 

{p 4 4 2}
If the caller specifies only two arguments, results are as if the caller 
had specified the third argument equal to missing; that is,
{cmd:ditty(}{it:A}{cmd:,} {it:B}{cmd:)}
is equivalent to 
{cmd:ditty(}{it:A}{cmd:,} {it:B}{cmd:,} {cmd:.}{cmd:)}


{p 4 4 2}
{it:Example 2}:  
You write function {cmd:gash()}.  
Function {cmd:gash()} allows the caller to specify one or two 
arguments:

{p 8 16 2}
{it:real matrix}
{cmd:gash(}{it:real matrix A}{cmd:,} 
{it:real matrix B}{cmd:)} 

{p 8 16 2}
{it:real matrix}
{cmd:gash(}{it:real matrix A}{cmd:)} 

{p 4 4 2}
If the caller specifies only one argument, results are as if {cmd:J(0,0,.)}
were specified for the second.


{p 4 4 2}
{it:Example 3}:  
You write function {cmd:easygoing()}.  
Function {cmd:easygoing()} takes three argument but allows the caller to 
specify three, two, one, or even no arguments:

{p 8 16 2}
{it:real scalar}
{cmd:easygoing(}{it:real matrix A}{cmd:,} 
{it:real matrix B}{cmd:,} 
{it:real scalar scale}{cmd:)}

{p 8 16 2}
{it:real scalar}
{cmd:easygoing(}{it:real matrix A}{cmd:,} 
{it:real matrix B}{cmd:)} 

{p 8 16 2}
{it:real scalar}
{cmd:easygoing(}{it:real matrix A}{cmd:)} 

{p 8 16 2}
{it:real scalar}
{cmd:easygoing()}

{p 4 4 2}
If {it:scale} is not specified, results are as if {it:scale}=1 were specified.
If {it:B} is not specified, results are as if {it:B}={it:A} were specified.
If {it:A} is not specified, results are as if {it:A}={cmd:I(2)} were specified.


{p 4 4 2}
{it:Example 4}:  
You write function {cmd:midsection()}.  {cmd:midsection()} takes three
arguments, but users may specify only two -- the first and last -- if they
wish.

{p 8 16 2}
{cmd:real matrix}
{it:midsection(}{it:real matrix A}{cmd:,}
{it:real vector w}{cmd:,}
{it:real matrix B}{cmd:)}

{p 8 16 2}
{cmd:real matrix}
{it:midsection(}{it:real matrix A}{cmd:,}
{it:real matrix B}{cmd:)}

{p 4 4 2}
If {it:w} is not specified, results are as if {it:w} =
{cmd:J(1,cols(}{it:A}{cmd:),1)} was specified.


{marker remarks2}{...}
{title:How to code optional arguments}

{p 4 4 2}
When you code 

	{cmd:function nebulous(}{it:a}{cmd:,} {it:b}{cmd:,} {it:c}{cmd:)}
	{cmd:{c -(}}
		...
	{cmd:{c )-}}

{p 4 4 2}
you are stating that function {cmd:nebulous()} requires three arguments.
If the caller specifies fewer or more, execution will abort.

{p 4 4 2}
If you code 

	{cmd:function nebulous(}{it:a}{cmd:,} {it:b}{cmd:, |}{it:c}{cmd:)}
	{cmd:{c -(}}
		...
	{cmd:{c )-}}

{p 4 4 2}
you are stating that the last argument is optional.  Note the vertical 
or bar in front of {it:c}.  

{p 4 4 2}
If you code 

	{cmd:function nebulous(}{it:a}{cmd:, |}{it:b}{cmd:,} {it:c}{cmd:)}
	{cmd:{c -(}}
		...
	{cmd:{c )-}}

{p 4 4 2}
you are stating that the last two arguments are optional; the user may 
specify one, two, or three arguments.

{p 4 4 2}
If you code 

	{cmd:function nebulous(|}{it:a}{cmd:,} {it:b}{cmd:,} {it:c}{cmd:)}
	{cmd:{c -(}}
		...
	{cmd:{c )-}}

{p 4 4 2}
you are stating that all arguments are optional; the user may specify 
zero, one, two, or three arguments.

{p 4 4 2}
The arguments that the user does not specify will be filled in 
according to the arguments' type, 

	{it:If the argument type is            The default value will be}
	{hline 60}
	undeclared                              {cmd}J(0, 0, .)

	transmorphic matrix                     J(0, 0, .)
	real matrix                             J(0, 0, .)
	complex matrix                          J(0, 0, 1i)
	string matrix                           J(0, 0, "")
	pointer matrix                          J(0, 0, NULL)

	transmorphic rowvector                  J(1, 0, .)
	real rowvector                          J(1, 0, .)
	complex rowvector                       J(1, 0, 1i)
	string rowvector                        J(1, 0, "")
	pointer rowvector                       J(1, 0, NULL)

	transmorphic colvector                  J(0, 1, .)
	real colvector                          J(0, 1, .)
	complex colvector                       J(0, 1, 1i)
	string colvector                        J(0, 1, "")
	pointer colvector                       J(0, 1, NULL)

	transmorphic vector                     J(1, 0, .)
	real vector                             J(1, 0, .)
	complex vector                          J(1, 0, 1i)
	string vector                           J(1, 0, "")
	pointer vector                          J(1, 0, NULL)

	transmorphic scalar                     J(1, 1, .)
	real scalar                             J(1, 1, .)
	complex scalar                          J(1, 1, C(.))
	string scalar                           J(1, 1, "")
	pointer scalar                          J(1, 1, NULL){txt}
	{hline 60}

{p 4 4 2}
Also, the function {cmd:args()} (see {bf:{help mf_args:[M-5] args()}})
will return the number of arguments that the user specified.

{p 4 4 2}
The vertical bar can be specified only once.  That is sufficient, as we 
will show.


{marker remarks3}{...}
{title:Examples revisited}

{p 4 4 2}
{it:Example 1}:
In this example, real matrix function {cmd:ditty(}{it:A}{cmd:,} {it:B}{cmd:,}
{it:scale}{cmd:)} allowed real scalar {it:scale} to be optional. If
{it:scale} was not specified, results were as if {it:scale}{cmd:=.} had been
specified.  This can be coded

	{cmd}real matrix ditty(real matrix A, real matrix B, |real scalar scale)
	{
		{txt}...{cmd}
	}{txt}

{p 4 4 2}
The body of the code is written just as if {it:scale} were not optional
because, if the caller does not specify the argument, the missing argument is
automatically filled in with missing, per the table above.

{p 4 4 2}
{it:Example 2}:
Real matrix function {cmd:gash(}{it:A}{cmd:,} {it:B}{cmd:)} allowed real 
matrix {it:B} to be optional, and if not specified, {it:B} = {cmd:J(0,0,.)} 
was assumed.  Hence, this is coded just as example 1 was coded:

	{cmd}real matrix gash(real matrix A, |real matrix B)
	{
		{txt}...{cmd}
	}{txt}


{p 4 4 2}
{it:Example 3}:
Real scalar function {cmd:easygoing(}{it:A}{cmd:,} {it:B}{cmd:,}
{it:scale}{cmd:)}
allowed all arguments to be optional.
{it:scale} = 1 was assumed, {it:B} = {it:A}, and if necessary, {it:A} =
{cmd:I(2)}.

	{cmd}real scalar easygoing(|real matrix A, real matrix B, real scalar scale)
	{
		{txt}...{cmd}

		if (args()==2) scale = 1
		else if (args==1) { 
			B = A
			scale = 1 
		}
		else if (args()==0) {
			A = B = I(2)
			scale = 1 ; 
		}

		{txt}...{cmd}
	}{txt}


{p 4 4 2}
{it:Example 4}:
Real matrix function {cmd:midsection(}{it:A}{cmd:,} {it:w}{cmd:,}
{it:B}{cmd:)} allowed {it:w} -- its middle argument -- to be omitted.
If {it:w} was not specified, {cmd:J(1, cols(}{it:A}{cmd:), 1)} was assumed.
Here is one solution:

	{cmd}real matrix midsection(a1, a2, |a3)
	{
		if (args()==3) return(midsection_u(a1,       a2,        a3))
		else           return(midsection_u(a1, J(1,cols(a1),1), a2))
	}

	real matrix midsection_u(real matrix A, real vector w, real matrix B)
	{
		...
	}{txt}
		
{p 4 4 2}
We will never tell callers about the existence of {cmd:midsection_u()}
even though {cmd:midsection_u()} is our real program.

{p 4 4 2}
What we did above was write {cmd:midsection()} to take two or three arguments,
and then we called {cmd:midsection_u()} with the arguments in the correct 
position.
{p_end}
