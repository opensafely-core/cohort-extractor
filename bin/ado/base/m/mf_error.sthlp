{smcl}
{* *! version 1.3.4  15may2018}{...}
{vieweralsosee "[M-5] error()" "mansection M-5 error()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Errors" "help m2_errors"}{...}
{vieweralsosee "[M-5] exit()" "help mf_exit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Programming" "help m4_programming"}{...}
{viewerjumpto "Syntax" "mf_error##syntax"}{...}
{viewerjumpto "Description" "mf_error##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_error##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_error##remarks"}{...}
{viewerjumpto "Conformability" "mf_error##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_error##diagnostics"}{...}
{viewerjumpto "Source code" "mf_error##source"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[M-5] error()} {hline 2}}Issue error message
{p_end}
{p2col:}({mansection M-5 error():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real scalar} {cmd:error(}{it:real scalar rc}{cmd:)}


{p 8 12 2}
{it:void}{bind:      }
{cmd:_error(}{it:real scalar errnum}{cmd:)}

{p 8 12 2}
{it:void}{bind:      }
{cmd:_error(}{it:string scalar errtxt}{cmd:)}

{p 8 12 2}
{it:void}{bind:      }
{cmd:_error(}{it:real scalar errnum}{cmd:,}
{it:string scalar errtxt}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:error(}{it:rc}{cmd:)} displays the standard Stata error message
associated with return code {it:rc} and returns {it:rc}; 
see {bf:[P] error} for a listing of return codes.
{cmd:error()} does not abort execution; 
standard usage is {cmd:exit(error(}{it:rc}{cmd:))}.

{p 4 4 2}
{cmd:_error()}
aborts execution and produces a traceback log.

{p 4 4 2}
{cmd:_error(}{it:errnum}{cmd:)} 
produces a traceback log with 
standard Mata error message {it:errnum};
see {bf:{help m2_errors:[M-2] Errors}} for a listing of the standard 
Mata error codes.

{p 4 4 2}
{cmd:_error(}{it:errtxt}{cmd:)} 
produces a traceback log 
with error number 3498 and custom text {it:errtext}.

{p 4 4 2}
{cmd:_error(}{it:errnum}{cmd:,} {it:errtxt}{cmd:)}
produces a traceback log with error number {it:errnum} and custom text 
{it:errtext}.

{p 4 4 2}
If {it:errtxt} is specified, it should contain straight text;
SMCL codes are not interpreted.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 error()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_error##remarks1:Use of _error()}
	{help mf_error##remarks2:Use of error()}


{marker remarks1}{...}
{title:Use of _error()}

{p 4 4 2}
{cmd:_error()} aborts execution and produces a traceback log:

	: {cmd:myfunction(A,B)}
	             {err}mysub():  3200  conformability error
	        myfunction():     -  function returned error
	             <istmt>:     -  function returned error{txt}
	r(3200);

{p 4 4 2}
The above output was created because function {cmd:mysub()} contained the line

		{cmd:_error(3200)}

{p 4 4 2}
and 3200 is the error number associated with the standard message
"conformability error"; see {bf:{help m2_errors:[M-2] Errors}}. 
Possibly, the code read

	{cmd:if (rows(A)!=rows(B) | cols(A)!=cols(B)) {c -(}}
		{cmd:_error(3200)}
	{cmd:{c )-}}

{p 4 4 2}
Another kind of mistake might produce 

	: {cmd:myfunction(A,B)}
	             {err}mysub():  3498  zeros on diagonal not allowed
	        myfunction():     -  function returned error
	             <istmt>:     -  function returned error{txt}
	r(3498);

{p 4 4 2}
and that could be produced by the code

	{cmd:if (diag0cnt(A)>0) {c -(}}
		{cmd:_error("zeros on diagonal not allowed")}
	{cmd:{c )-}}

{p 4 4 2}
If we wanted to produce the same text but change the error number 
to 3300, we could have coded

	{cmd:if (diag0cnt(A)>0) {c -(}}
		{cmd:_error(3300, "zeros on diagonal not allowed")}
	{cmd:{c )-}}

{p 4 4 2}
Coding {cmd:_error()} is not always necessary.  In our conformability-error
example, imagine that more of the code read

	...
	{cmd:if (rows(A)!=rows(B) | cols(A)!=cols(B)) {c -(}}
		{cmd:_error(3200)}
	{cmd:{c )-}}
	{cmd:C = A + B}
	...

{p 4 4 2}
If we simplified the code to read

	...
	{cmd:C = A + B}
	...

{p 4 4 2}
the conformability error would still be detected because {cmd:+} 
requires p-conformability:

	: {cmd:myfunction(A,B)}
	                   {err}+:  3200  conformability error
	             mysub():     -  conformability error
	        myfunction():     -  function returned error
	             <istmt>:     -  function returned error{txt}
	r(3200);

{p 4 4 2}
Sometimes, however, you must detect the error yourself.  For instance,

	...
	{cmd:if (rows(A)!=rows(B) | cols(A)!=cols(B) | rows(A)!=2*cols(A)) {c -(}}
		{cmd:_error(3200)}
	{cmd:{c )-}}
	{cmd:C = A + B}
	...

{p 4 4 2}
We assume we have some good reason to require that {cmd:A} has twice as 
many rows as columns.  {cmd:+}, however, will not require that, and perhaps 
no other calculation we will make will require that, either.  Or perhaps
it will be subsequently detected, but in a way that leads to a confusing 
error message for the caller.


{marker remarks2}{...}
{title:Use of error()}

{p 4 4 2}
{cmd:error(}{it:rc}{cmd:)} does not cause the program to terminate.  Standard
usage is

	{cmd:exit(error(}{it:rc}{cmd:))}

{p 4 4 2}
such as

	{cmd:exit(error(503))}

{p 4 4 2}
In any case, {cmd:error()} does not produce a traceback log:


	: {cmd:myfunction(A,B)}
	{err:conformability error}
	r(503);

{p 4 4 2}
{cmd:error()} is intended to be used in functions that are subroutines of 
ado-files:


	{hline 43} begin example.ado {hline 4}
	{cmd}program example
		version {ccl stata_version}
		{txt}...{cmd}
		mata: myfunction("`mat1'", "`mat2'")
		{txt}...{cmd}
	end

	version {ccl stata_version}
	mata:
	void myfunction(string scalar matname1, string scalar matname2)
	{
		{txt}...{cmd}
		A = st_matrix(matname1)
		B = st_matrix(matname2)
		if (rows(A)!=rows(B) | cols(A)!=cols(B)) {c -(}
			exit(error(503))
		{c )-}
		C = A + B
		{txt}...{cmd}
	}
	end{txt}
	{hline 43} end example.ado {hline 6}

{p 4 4 2}
This way, when the {cmd:example} command is used incorrectly, the user 
will see 

	. {cmd:example} ...
	{err:conformability error}
	r(503);

{p 4 4 2}
rather than the traceback log that would have been produced had we 
omitted the test and {cmd:exit(error(503))}:

	. {cmd:example} ...
	                   {err}+:  3200  conformability error
	        myfunction():     -  function returned error
	             <istmt>:     -  function returned error{txt}
	r(3200);


{marker conformability}{...}
{title:Conformability}

    {cmd:error(}{it:rc}{cmd:)}:
	       {it:rc}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1

    {cmd:_error(}{it:errnum}{cmd:)}:
	   {it:errnum}:  1 {it:x} 1
	   {it:result}:  {it:void}

    {cmd:_error(}{it:errtxt}{cmd:)}:
	   {it:errtxt}:  1 {it:x} 1
	   {it:result}:  {it:void}

    {cmd:_error(}{it:errnum}{cmd:,} {it:errtxt}{cmd:)}:
	   {it:errnum}:  1 {it:x} 1
	   {it:errtxt}:  1 {it:x} 1
	   {it:result}:  {it:void}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
   {cmd:error(}{it:rc}{cmd:)} does not abort execution; code
   {cmd:exit(error(}{it:rc}{cmd:))} if that is your desire; 
   see {bf:{help mf_exit:[M-5] exit()}}.

{p 4 4 2}
   The code {cmd:error(}{it:rc}{cmd:)} returns can differ from {it:rc} if
   {it:rc} is not a standard code or if there is a better code associated with
   it.

{p 4 4 2}
   {cmd:error(}{it:rc}{cmd:)} with {it:rc}=0 produces no output and returns 0.

{p 4 4 2}
   {cmd:_error(}{it:errnum}{cmd:)}, 
   {cmd:_error(}{it:errtxt}{cmd:)}, and 
   {cmd:_error(}{it:errnum}{cmd:,} {it:errtxt}{cmd:)}
   always abort with error.  {cmd:_error()} will abort with error because
   you called it wrong if you specify an {it:errnum} less than 1 or
   greater than 2,147,483,647 or if you specify an {it:errtxt} longer than
   100 characters.
   If you specify an {it:errnum} that is not a standard code, the text 
   of the error messages will read "Stata returned error".


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
