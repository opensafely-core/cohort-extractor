{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] findexternal()" "mansection M-5 findexternal()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] valofexternal()" "help mf_valofexternal"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Programming" "help m4_programming"}{...}
{viewerjumpto "Syntax" "mf_findexternal##syntax"}{...}
{viewerjumpto "Description" "mf_findexternal##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_findexternal##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_findexternal##remarks"}{...}
{viewerjumpto "Conformability" "mf_findexternal##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_findexternal##diagnostics"}{...}
{viewerjumpto "Source code" "mf_findexternal##source"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[M-5] findexternal()} {hline 2}}Find, create, and remove external globals
{p_end}
{p2col:}({mansection M-5 findexternal():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:pointer()}
{it:scalar} 
{cmd:findexternal(}{it:string scalar name}{cmd:)}

{p 8 12 2}
{it:pointer()}
{it:scalar} 
{cmd:crexternal(}{it:string scalar name}{cmd:)}

{p 8 12 2}
{it:void}{bind:             }{cmd:rmexternal(}{it:string scalar name}{cmd:)}

{p 8 12 2}
{it:string}{bind:   }
{it:scalar}
{cmd:nameexternal(}{it:pointer() scalar p}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:findexternal(}{it:name}{cmd:)}
returns a pointer (see {bf:{help m2_pointers:[M-2] pointers}}) 
to the external global 
matrix, vector, or scalar whose name is specified by {it:name}, 
or to the external global function if the contents of {it:name} end in 
{cmd:()}.
{cmd:findexternal()}
returns
NULL if the external global is not found.

{p 4 4 2}
{cmd:crexternal(}{it:name}{cmd:)}
creates a new external global 0 {it:x} 0 real matrix with the 
specified name and returns a pointer to it; it returns NULL if an 
external global of that name already exists.

{p 4 4 2} 
{cmd:rmexternal(}{it:name}{cmd:)}
removes (deletes) the specified external global or does nothing if 
no such external global exists.

{p 4 4 2}
{cmd:nameexternal(}{it:p}{cmd:)}
returns the name of {cmd:*}{it:p}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 findexternal()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_findexternal##remarks1:Definition of a global}
	{help mf_findexternal##remarks2:Use of globals}

{p 4 4 2}
Also see {it:{help m2_declarations##remarks10:Linking to external globals}} in 
{bf:{help m2_declarations:[M-2] Declarations}}.


{marker remarks1}{...}
{title:Definition of a global}

{p 4 4 2}
When you use Mata interactively, any variables you create are known,
equivalently, as externals, globals, or external globals.

	: {cmd:myvar = x}

{p 4 4 2}
Such variables can be used by subsequent functions that you run, and 
there are two ways that can happen:

	{cmd:function example1(...)}
	{cmd:{c -(}}
		{cmd:external real myvar}

		... {cmd:myvar} ...
	{cmd:{c )-}}

{p 4 4 2}
and 

	{cmd:function example2(...)}
	{cmd:{c -(}}
		{cmd:pointer(real) p}

		{cmd:p = findexternal("myvar")}
		... {cmd:*p} ...
	{cmd:{c )-}}

{p 4 4 2}
Using the first method, you must know the name of the global at the time you
write the source code, and when you run your program, if the global does not
exist, it will refuse to run (abort with {cmd:myvar} not found).  With the
second method, the name of the global can be specified at run time and what is
to happen when the global is not found is up to you.

{p 4 4 2}
In the second example, although we declared {cmd:p} as a pointer to a 
real, {cmd:myvar} will not be required to contain a real.  After 
{cmd:p} {cmd:=} {cmd:findexternal("myvar")}, if {cmd:p!=NULL}, 
{cmd:p} will point to whatever {cmd:myvar} contains, whether it 
be real, complex, string, or another pointer.  (You can diagnose 
the contents of {cmd:*p} using {cmd:eltype(*p)} and 
{cmd:orgtype(*p)}; see {helpb mf_eltype:[M-5] eltype()}.)


{marker remarks2}{...}
{title:Use of globals}

{p 4 4 2}
Globals are useful when a function must remember something from one 
call to the next:

	{cmd}function example3(real scalar x)
	{
		pointer() scalar p 

		if ( (p = findexternal("myprivatevar")) == NULL) {
			printf("you haven't called me previously")
			p = crexternal("myprivatevar")
		}
		else {
			printf("last time, you said "%g", *p)
		}
		*p = x 
	}{txt}

	: {cmd:example3(2)}
	you haven't called me previously

	: {cmd:example3(31)}
	last time, you said 2

	: {cmd:example3(9)}
	last time, you said 31

{p 4 4 2}
Note our use of the name {cmd:myprivatevar}.  It actually is not 
a private variable; it is global, and you would see the variable listed 
if you described the contents of Mata's memory.  Because global variables 
are so exposed, it is best that you give them long and unlikely names.

{p 4 4 2}
In general, programs do not need global variables.  The exception is 
when a program must remember something from one invocation to the next, 
and especially if that something must be remembered from one invocation 
of Mata to the next.

{p 4 4 2}
When you do need globals, you probably will have more than one thing you will
need to recall.  There are two ways to proceed.  One way is simply to 
create separate global variables for each thing you need to remember.  
The other way is to create one global pointer vector and store 
everything in that.  In the following example, we remember one scalar 
and one matrix:

	{cmd}function example4()
	{
		pointer(pointer() vector) scalar   p 
		scalar                             s
		real matrix                        X
		pointer() scalar                   ps, pX

		if ( (p = findexternal("mycollection")) == NULL) {
			... {txt:{it:calculate scalar}} s {txt:{it:and}} X {txt:{it:from nothing}} ...
			... {txt:{it:and save them:}}
			p = crexternal("mycollection")
			*p = (&s, &X)
		}
		else {
			ps = (*p)[1]
			pX = (*p)[2] 
			... {txt:{it:calculate using}} *ps {txt:{it:and}} *pX ...
		}
	}{txt}

{p 4 4 2}
In the above example, even though {cmd:crexternal()} created a
0 {it:x} 0 real global, we morphed it into a 1 {it:x} 2 pointer vector:

	{cmd} p = crexternal("mycollection")  *p {txt:is 0 x 0 real}
	*p = (&s, &X)                    *p {txt:is 1 x 2 vector}{txt}

{p 4 4 2}
just as we could with any nonpointer object.

{p 4 4 2}
In the else part of our program, where we use the previous values, 
we do not use variables {cmd:s} and {cmd:X}, but {cmd:ps} and {cmd:pX}.
Actually, we did not really need them, we could just as well have used
{cmd:*((*p)[1])} and {cmd:*((*p)[2])}, but 
the code is more easily understood by introducing 
{cmd:*ps} and {cmd:*pX}.

{p 4 4 2}
Actually, we could have used the variables {cmd:s} and {cmd:X} by changing 
the else part of our program to read

		{cmd}else {
			s = *(*p)[1]
			X = *(*p)[2] 
			... {txt:{it:calculate using}} s {txt:{it:and}} X ...
			*p = (&s, &X)         <- remember to put them back
		}{txt}

{p 4 4 2}
Doing that is inefficient because {cmd:s} and {cmd:X} contain copies of 
the global values.  Obviously, the amount of inefficiency depends on 
the sizes of the elements being copied.  For {cmd:s}, there 
is really no inefficiency at all because {cmd:s} is just a scalar.  
For {cmd:X}, the amount of inefficiency depends on the dimensions 
of {cmd:X}.  Making a copy of a small {cmd:X} matrix would introduce 
just a little inefficiency.

{p 4 4 2} 
The best balance between efficiency and readability is achieved by 
introducing a subroutine:

	{cmd}function example5()
	{
		pointer(pointer() vector) scalar   p 
		scalar                             s
		real matrix                        X

		if ( (p = findexternal("mycollection")) == NULL) {
			example5_sub(1, s=., X=J(0,0,.))
			p = crexternal("mycollection")
			*p = (&s, &X)
		}
		else {
			example5_sub(0, (*p)[1], (*p)[2])
		}
	}

	function example5_sub(scalar firstcall, scalar x, matrix X)
	{
		...
	}{txt}

{p 4 4 2}
The last two lines in the not-found case

			{cmd}p = crexternal("mycollection")
			*p = (&s, &X){txt}

{p 4 4 2}
could also be coded

			{cmd:*crexternal("mycollection") = (&s, &X)}


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:findexternal(}{it:name}{cmd:)}, 
{cmd:crexternal(}{it:name}{cmd:)}:
{p_end}
	     {it:name}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1

{p 4 4 2}
{cmd:rmexternal(}{it:name}{cmd:)}:
{p_end}
	     {it:name}:  1 {it:x} 1
	   {it:result}:  {it:void}

{p 4 4 2}
{cmd:nameexternal(}{it:p}{cmd:)}:
{p_end}
	        {it:p}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:findexternal(}{it:name}{cmd:)}, 
{cmd:crexternal(}{it:name}{cmd:)}, and 
{cmd:rmexternal(}{it:name}{cmd:)}
abort with error if {it:name} contains an invalid name.

{p 4 4 2}
{cmd:findexternal(}{it:name}{cmd:)} returns NULL if {it:name} does not exist.

{p 4 4 2}
{cmd:crexternal(}{it:name}{cmd:)} returns NULL if {it:name} already exists.

{p 4 4 2}
{cmd:nameexternal(}{it:p}{cmd:)} returns "" if {it:p}={cmd:NULL}.
Also, {cmd:nameexternal()} may be used not just with pointers to globals but 
pointers to locals as well.  
For example, you can code 
{cmd:nameexternal(&myx)}, where {cmd:myx} is declared in the same 
program or a calling program.  
{cmd:nameexternal()} will usually return the expected local name, such as
{cmd:"myx"}.  In such cases, however, it is also possible that "" will be
returned.  That can occur because, in the compilation/optimization process,
the identity of local variables can be lost.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
