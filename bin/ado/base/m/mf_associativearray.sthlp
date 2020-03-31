{smcl}
{* *! version 1.0.6  15may2018}{...}
{vieweralsosee "[M-5] AssociativeArray()" "mansection M-5 AssociativeArray()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] asarray()" "help mf_asarray"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Manipulation" "help m4_manipulation"}{...}
{vieweralsosee "[M-4] Programming" "help m4_programming"}{...}
{viewerjumpto "Syntax" "mf_associativearray##syntax"}{...}
{viewerjumpto "Description" "mf_associativearray##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_associativearray##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_associativearray##remarks"}{...}
{viewerjumpto "Conformability" "mf_associativearray##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_associativearray##diagnostics"}{...}
{viewerjumpto "Source code" "mf_associativearray##source"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[M-5] AssociativeArray()} {hline 2}}Associative arrays (class)
{p_end}
{p2col:}({mansection M-5 AssociativeArray():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{col 9}{...}
{cmd:class AssociativeArray scalar} {it:A}{...}
{right:{it:create array with {cmd:string scalar} keys}      }
{col 9}{it:or}
{col 9}{...}
{it:A}{cmd: = AssociativeArray()}{...}
{right:{it:create array with {cmd:string scalar} keys}      }

{col 9}{...}
{it:A}{cmd:.reinit(}[  {it:keytype}{...}
{right:{cmd:"string",} {cmd:"real",} {cmd:"complex",} ...          }
{col 18}[{cmd:,} {it:keydim} {...}
{right:{cmd:1} {it:to} {cmd:50}                                   }
{col 18}[{cmd:,} {it:minsize}{...}
{right:{it:tuning parameter}                          }
{col 18}[{cmd:,} {it:minratio}{...}
{right:{it:tuning parameter}                          }
{col 18}[{cmd:,} {it:maxratio} ]]]]]{cmd:)}{...}
{right:{it:tuning parameter}                          }

{col 9}{...}
{it:A}{cmd:.put(}{it:key}{cmd:,} {...}
{it:val}{cmd:)}{...}
{right:{it:A[key] = val                              }}

{col 9}{...}
{it:val} {cmd:=} {...}
{it:A}{cmd:.get(}{it:key}{cmd:)}{...}
{right:{it:val = A[key] or val = notfound            }}

{col 9}{...}
{it:A}{cmd:.notfound(}{it:notfound}{cmd:)}{...}
{right:{it:change notfound value                     }}

{col 9}{...}
{it:notfound} {cmd:=} {...}
{it:A}{cmd:.notfound()}{...}
{right:{it:query notfound value                      }}

{col 9}{...}
{it:A}{cmd:.remove(}{it:key}{cmd:)}{...}
{right:{it:delete A[key] if it exists                }}

{col 9}{...}
{it:bool} {cmd:=} {...}
{it:A}{cmd:.exists(}{it:key}{cmd:)} {...}
{right:{it:A[key] exists?                            }}


{col 9}{...}
{it:val}{cmd: = }{it:A}{cmd:.firstval()}{...}
{right:{it:first val or notfound                     }}
{col 9}{...}
{it:val}{cmd: = }{it:A}{cmd:.nextval()}{...}
{right:{it:next val or notfound                      }}
{col 9}{...}
{it:key}{cmd: = }{it:A}{cmd:.key()}{...}
{right:{it:key corresponding to val                  }}
{col 9}{...}
{it:val}{cmd: = }{it:A}{cmd:.val()}{...}
{right:{it:val yet again                             }}

{col 9}{...}
{it:loc}{cmd: = }{it:A}{cmd:.firstloc()}{...}
{right:{it:first location or} {cmd:NULL}             }
{col 9}{...}
{it:loc}{cmd: = }{it:A}{cmd:.nextloc()}{...}
{right:{it:next location or} {cmd:NULL}              }
{col 9}{...}
{it:key}{cmd: = }{it:A}{cmd:.key(}{it:loc}{cmd:)}{...}
{right:{it:key at location                           }}
{col 9}{...}
{it:val}{cmd: = }{it:A}{cmd:.val(}{it:loc}{cmd:)}{...}
{right:{it:val at location                           }}

{col 9}{...}
{it:keys}{cmd: = }{it:A}{cmd:.keys()}{...}
{right:{it:N x keydim matrix of defined keys         }}

{col 9}{...}
{it:N}{cmd: = }{it:A}{cmd:.N()}{...}
{right:{it:N, number of defined keys                 }}

{col 9}{...}
{it:A}{cmd:.clear()}{...}
{right:{it:clear array; set N equal to 0             }}


{marker description}{...}
{title:Description}

{pstd}
{cmd:AssociativeArray} provides a class-based interface into the associative
arrays provided by {cmd:asarray()}; see {helpb mf_asarray:[M-5] asarray()}.
The class-based
interface provides more tersely named functions, making code written
with it easier to read.

{pstd}
Associative arrays are also known as containers, maps, dictionaries,
indices, and hash tables.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 AssociativeArray()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd} 
Array is computer jargon.  A one-dimensional array is a vector with
elements {it:A[i]}.  A two-dimensional array is a matrix with elements
{it:A[i,j]}.  A three-dimensional array generalizes a matrix to three
dimensions with elements {it:A[i,j,k]}, and so on.

{pstd}
An associative array is an array where the indices are not necessarily 
integers.  Most commonly, the indices are strings, so you might have 
{it:A["bill"]}, {it:A["bill", "bob"]}, {it:A["bill", "bob", "mary"]},
etc.

{pstd}
Associative arrays created by {cmd:AssociativeArray} are one-dimensional, and
the keys are string by default.  At the same time, the elements may be
of any type and even vary element by element.  Such an array is
created when you code

       {cmd:function foo(}...{cmd:)}
       {cmd:{c -(}}
                {cmd:class AssociativeArray scalar  }{it:A}
                .
                .
       {cmd:{c )-}}

{pstd} 
or, if you are working interactively, you type

        {cmd:: }{it:A}{cmd: = AssociativeArray()}

{pstd}
Either way, {it:A} is now a one-dimensional array with string keys.
This is the style of associative array most users will want, but if you
want a different style, say, a two-dimensional array with real-number
keys, you next use {it:A}{cmd:.reinit()} to change the style.
You code

       {cmd:function foo(}...{cmd:)}
       {cmd:{c -(}}
                {cmd:class AssociativeArray scalar  }{it:A}

                {it:A}{cmd:.reinit("real", 2)}
                .
                .
       {cmd:{c )-}}

{pstd}
or you interactively type

        {cmd:: }{it:A}{cmd: = AssociativeArray()}

        {cmd:: }{it:A}{cmd:.reinit("real", 2)}

{pstd}
This associative array will be like a matrix in that you can store
elements such as {it:A[1,2]}, {it:A[2,1]}:

        {cmd:: }{it:A}{cmd:.put((1,2),  5)}
        {cmd:: }{it:A}{cmd:.put((2,1), -2)}

{pstd}
{it:A}{cmd:.put()} is how we define elements or change the contents of
elements that are already defined.  If we typed

        {cmd:: }{it:A}{cmd:.put((2,1), -5)}

{pstd} 
{it:A[2,1]} would change from -2 to -5.
The first argument of {it:A}{cmd:.put()} is the key (think indices),
and the second argument the value to be assigned.  The first argument
is enclosed in parentheses because {it:A} is a two-dimensional array, and 
thus keys are 1{it:x}2.

{pstd}
If we now coded

        {cmd:x = }{it:A}{cmd:.get((1,2))}
        {cmd:y = }{it:A}{cmd:.get((2,1))}

{pstd}
then {cmd:x} would equal 5 and {cmd:y} would equal -5.  {it:A} may seem
as if it were a regular matrix, but it is not.  One difference is that
only {it:A[1,2]} and {it:A[2,1])} are defined and {it:A[1,1]} and
{it:A[2,2]} are not defined.  If we fetched the value of {it:A[1,1]} by
typing

        {cmd:z = }{it:A}{cmd:.get((1,1))}

{pstd}
that would not be an error, but we are in for a surprise, because
{cmd:z} will equal {cmd:J(0,0,.)}, a real 0{it:x}0 matrix.  That is
{cmd:AssociativeArray}'s way of saying that {it:A[1,1]} has never been
defined.  We can change what {cmd:AssociativeArray} returns when an element
is not defined.  Let's change it to be zero:

        {it:A}{cmd:.notfound(0)}

{pstd} 
Now if we fetched the value of {it:A[1,1]} by typing 

        {cmd:z = }{it:A}{cmd:.get((1,1))}

{pstd}
{cmd:z} would equal zero.  We are on our way to creating sparse
matrices!  In fact, we have created a sparse matrix.  I do not know 
whether our matrix is 2{it:x}2 or 1000{it:x}1000 because {it:A[i,j]}
is 0 for all ({it:i,j}) not equal to (1,2) and (2,1).  We will 
just have to keep track of the overall dimension separately.
If I defined 

        {it:A}{cmd:.put((1000,1000), 6)}

{pstd}
then the sparse matrix would be at least 1000{it:x}1000.  And our matrix
really is sparse and stored efficiently in that {it:A} contains only
three elements.

{pstd}
Creating sparse matrices is one use of associative arrays.  The typical
use, however, involves the one-dimensional arrays with string keys, and
these associative arrays are usually the converse of sparse matrices in
that, rather than storing just a few elements, they store lots of
elements.  One can imagine an associative array

        {cmd:: Dictionary = AssociativeArray()}

{pstd} 
in which the elements are {cmd:string} {cmd:colvector}s, with the result: 
        
        {cmd:: Dictionary.get("aback")}
          [1, 1] = (archaic) toward or situation to the rear.
          [2, 1] = (sailing) with the sail pressed backward against the 
                   mast by the head.

{pstd} 
I stored the definition for "aback" by coding 

        {cmd::  Dictionary.put("aback",}
                           (
                               "(archaic) toward or situation to the rear."
                               \
                               "(sailing) with the sail pressed backward 
                                 against the mast by the head."
                           ))

{pstd}
The great feature of associative arrays is that I could enter
definitions for 25,591 other words and still {cmd:Dictionary.get()}
could find the definition for any of the words, including "wombat",
almost instantly.  Performance would not depend on entering words
alphabetically.  They could be defined in any order.  A user once
complained that we slowed down somewhere between 500,000 and 1,000,000
elements, but that was due to a bug, and we fixed it.

{pstd}
Here is a summary of {cmd:AssociativeArray}'s features.

{pstd}
{it:Initialization:}

{p 8 8 2}
Declare {it:A} in functions you write,

                {cmd:class AssociativeArray scalar  }{it:A}

{p 8 8 2}
or if working interactively, create {it:A} using the creator function: 

                {it:A} = {cmd:AssociativeArray()}

{p 8 8 2}
{it:A} is now an associative array indexed by {cmd:string}
{cmd:scalar} keys.  {it:string} {it:scalar} is the default.


{pstd}
{it:Reinitialization:}

{p 8 8 2}
After initialization, the associative array is ready for use 
with {cmd:string} {cmd:scalar} keys.
Use {it:A}{cmd:.reinit()} if you want to change the type of
the keys or set tuning parameters.
Keys can be {cmd:scalar} or {cmd:rowvector} and can be {cmd:real},
{cmd:complex}, {cmd:string}, or even {cmd:pointer}.

{col 14}{...}
{it:A}{cmd:.reinit(}[  {it:keytype}{...}
{right:{cmd:"string",} {cmd:"real",} {cmd:"complex",} ...    }
{col 23}[{cmd:,} {it:keydim} {...}
{right:{cmd:1} {it:to} {cmd:50}                             }
{col 23}[{cmd:,} {it:minsize}{...}
{right:{it:tuning parameter}                    }
{col 23}[{cmd:,} {it:minratio}{...}
{right:{it:tuning parameter}                    }
{col 23}[{cmd:,} {it:maxratio} ]]]]]{cmd:)}{...}
{right:{it:tuning parameter}                    }

{p 8 8 2}
Do not specify tuning parameters.  Treat {it:A}{cmd:.reinit()} as if it
allowed only two arguments.  You are unlikely to improve over the
default values unless you understand how the parameters work.  Tuning
parameters are described in {helpb mf_asarray:[M-5] asarray()}.


{pstd}
{it:Add or replace elements in the array:}

{p 8 8 2}
Add or replace elements in the array using {it:A}{cmd:.put()}:

{col 15}{...}
{it:A}{cmd:.put(}{it:key}{cmd:,} {...}
{it:val}{cmd:)}{...}
{right:{it:A[key] = val                       }}

{p 8 8 2}
Values can be of any element type, {cmd:real}, {cmd:complex},
{cmd:string}, or {cmd:pointer}.  They can even be
structure or class instances.  Values can be scalars, vectors, or
matrices.  Value types do not need to be declared.  Value types 
may even vary from one element to the next.


{pstd}
{it:Retrieve elements from the array:}

{p 8 8 2}
Retrieve values using {it:A}{cmd:.get()}:

{col 15}{...}
{it:val} {cmd:=} {...}
{it:A}{cmd:.get(}{it:key}{cmd:)}{...}
{right:{it:val = A[key] or val = notfound     }}

{p 8 8 2}
Retrieving a value for a key that has never been defined is not 
an error.  A special value called {it:notfound} is returned in 
that case.  The default value of {it:notfound} is {cmd:J(0,0,.)}.
You can change that:

{col 15}{...}
{it:A}{cmd:.notfound(}{it:notfound}{cmd:)}{...}
{right:{it:change notfound value               }}

{p 8 8 2}
Users of associative arrays containing numeric values often 
change {it:notfound} to zero or missing by coding {it:A}{cmd:.notfound(0)}
or {it:A}{cmd:.notfound(.)}.

{p 8 8 2}
You can use {it:A}{cmd:.notfound()} without arguments to query the current 
{it:notfound} value:

{col 15}{...}
{it:notfound} {cmd:=} {...}
{it:A}{cmd:.notfound()}{...}
{right:{it:query notfound value                }}


{p 4 4 2}
{it:Delete elements in the array:}

{p 8 8 2}
Delete elements using {it:A}{cmd:.remove()}:

{col 15}{...}
{it:A}{cmd:.remove(}{it:key}{cmd:)}{...}
{right:{it:delete A[key] if it exists          }}

{p 8 8 2}
Function {it:A}{cmd:.exists()} will tell you whether an element exists:

{col 15}{...}
{it:bool} {cmd:=} {...}
{it:A}{cmd:.exists(}{it:key}{cmd:)} {...}
{right:{it:A[key] exists?                      }}

{p 8 8 2} 
The function returns 1 or 0; 1 means the element exists.  You may
wonder about the necessity of this function because {it:A}{cmd:.get()}
returns {it:notfound} when an element does not exist.
Why are there two ways to do one task? 
{it:A}{cmd:.exists()} is useful because you could store the
{it:notfound} value in an element.  You should not do that, of course.


{pstd}
{it:Iterating through all elements of the array:}

{p 8 8 2}
There are three ways to iterate through the elements.

{p 8 8 2}
{it:Method 1} is

{col 15}{...}
{cmd:for (val=}{it:A}{cmd:.firstval();} {...}
{cmd:val!=}{it:notfound}{cmd:;} {...}
{cmd:val=}{it:A}{cmd:.nextval()) {c -(}}
{col 23}{cmd:key = }{it:A}{cmd:.key()}       // if you need it
{col 23}.
{col 23}.
{col 15}{cmd:{c )-}}

{p 8 8 2}
Inside the loop, {cmd:val} contains the element's value.  If you 
need to know the element's key, use {it:A}{cmd:.key()}.

{p 8 8 2}
{it:Method 2} is

{col 15}{cmd:transmorphic  loc}

{col 15}{...}
{cmd:for (loc=}{it:A}{cmd:.firstloc(); }{...}
{cmd:loc!=NULL; }{...}
{cmd:loc=}{it:A}{cmd:.nextloc()) {c -(}}
{col 23}{cmd:val = }{it:A}{cmd:.val(loc)}
{col 23}{cmd:key = }{it:A}{cmd:.key(loc)}    // if you need it
{col 23}.
{col 23}.
{col 15}{cmd:{c )-}}

{p 8 8 2}
Method 2 allows for recursion.  Use method 2 if you call a subroutine
inside the loop that itself might iterate through the elements of the
array.

{p 8 8 2}
{it:Method 3} is an entirely different approach.  You fetch the full
set of defined keys and loop through them.  Function
{it:A}.{cmd:keys()} returns the keys as a matrix.  Each row of the
matrix is a key.

{col 15}{cmd:K = }{it:A}{cmd:.keys()}
{col 15}{cmd:for (i=1; i<=length(K); i++) {c -(}}
{col 23}{cmd:val = }{it:A}{cmd:.get(K[i,.])}
{col 23}.
{col 23}.
{col 15}{cmd:{c )-}}

{p 8 8 2}
The keys returned by {it:A}{cmd:.keys()} are in no particular order.
For some loops, order matters.  Use Mata's {cmd:sort()}
function to order them.
If the keys were of dimension 1 and thus {cmd:K} were {it:N x} 1, you
could code 

{col 15}{cmd:K = sort(}{it:A}{cmd:.keys(), 1)}

{p 8 8 2}
If {it:A} were {it:N x k}, you could code 

{col 15}{cmd:K = sort(}{it:A}{cmd:.keys(), (1..}{it:k}{cmd:))}

{p 8 8 2}
Vector operator {cmd:1..}{it:k} produces the row vector 
(1, 2, ..., {it:k}).


{pstd}
{it:Miscellany:}

{p 8 8 2}
{it:A}{cmd:.N()} returns the number of defined elements in {it:A}.

{p 8 8 2}
{it:A}{cmd:.clear()} clears the array {it:A}.  The array's 
characteristics -- key type and dimension, {it:notfound} value, and 
tuning parameters -- remain unchanged.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{it:A}{cmd:.reinit(}{it:keytype}{cmd:,}
{it:keydim}{cmd:,}
{it:minsize}{cmd:,}
{it:minratio}{cmd:,}
{it:maxratio}{cmd:)}:
{p_end}
	  {it:keytype}:  1 {it:x} 1    (optional)
	   {it:keydim}:  1 {it:x} 1    (optional)
	  {it:minsize}:  1 {it:x} 1    (optional)
	 {it:minratio}:  1 {it:x} 1    (optional)
	 {it:maxratio}:  1 {it:x} 1    (optional)

{p 4 4 2}
{it:A}{cmd:.put(}{it:key}{cmd:,}
{it:a}{cmd:)}:
{p_end}
	      {it:key}:  1 {it:x} {it:keydim}
		{it:a}:  {it:r_key x c_key}; {it:r_key} and {it:c_key} your choice
	   {it:result}:  {it:void}

{p 4 4 2}
{it:A}{cmd:.get(}{it:key}{cmd:)}:
{p_end}
	      {it:key}:  1 {it:x} {it:keydim}
	   {it:result}:  {it:r_key x c_key}

{p 4 4 2}
{it:A}{cmd:.remove(}{it:key}{cmd:)}:
{p_end}
	      {it:key}:  1 {it:x} {it:keydim}
	   {it:result}:  {it:void}

{p 4 4 2}
{it:A}{cmd:.clear()}:
{p_end}
	   {it:result}:  {it:void}

{p 4 4 2}
{it:A}{cmd:.exists(}{it:key}{cmd:)}:
{p_end}
	      {it:key}:  1 {it:x} {it:keydim}
	   {it:result}:  1 {it:x} 1

{p 4 4 2}
{it:A}{cmd:.N()}:
{p_end}
	   {it:result}:  1 {it:x} 1

{p 4 4 2}
{it:A}{cmd:.keys()}:
{p_end}
	   {it:result}:  {it:N} {it:x} {it:keydim}

{p 4 4 2}
{it:A}{cmd:.firstval()}:
{p_end}
	   {it:result}:  {it:transmorphic}

{p 4 4 2}
{it:A}{cmd:.firstloc()}:
{p_end}
	   {it:result}:  {it:transmorphic}

{p 4 4 2}
{it:A}{cmd:.nextval()}:
{p_end}
	   {it:result}:  {it:transmorphic}

{p 4 4 2}
{it:A}{cmd:.nextloc()}:
{p_end}
	   {it:result}:  {it:transmorphic}

{p 4 4 2}
{it:A}{cmd:.key()}:
{p_end}
	   {it:result}:  1 {it:x} {it:keydim}

{p 4 4 2}
{it:A}{cmd:.key(}{it:loc}{cmd:)}:
{p_end}
	      {it:loc}:  {it:transmorphic}
	   {it:result}:  1 {it:x} {it:keydim}

{p 4 4 2}
{it:A}{cmd:.val()}:
{p_end}
	   {it:result}:  {it:r_key} {it:x} {it:c_key}

{p 4 4 2}
{it:A}{cmd:.val(}{it:loc}{cmd:)}:
{p_end}
	      {it:loc}:  {it:transmorphic}
	   {it:result}:  {it:r_key} {it:x} {it:c_key}

{p 4 4 2}
{it:A}{cmd:.notfound(}{it:notfound}{cmd:)}:
{p_end}
	 {it:notfound}:  {it:r} {it:x} {it:c}; your choice
	   {it:result}:  {it:void}

{p 4 4 2}
{it:A}{cmd:.notfound()}:
{p_end}
	   {it:result}:  {it:r} {it:x} {it:c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view associativearray.mata, adopath asis:associativearray.mata}
{view asarray.mata, adopath asis:asarray.mata}
{p_end}
