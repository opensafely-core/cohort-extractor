{smcl}
{* *! version 1.1.10  15may2018}{...}
{vieweralsosee "[M-5] asarray()" "mansection M-5 asarray()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] AssociativeArray()" "help mf_associativearray"}{...}
{vieweralsosee "[M-5] hash1()" "help mf_hash1"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Manipulation" "help m4_manipulation"}{...}
{vieweralsosee "[M-4] Programming" "help m4_programming"}{...}
{viewerjumpto "Syntax" "mf_asarray##syntax"}{...}
{viewerjumpto "Description" "mf_asarray##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_asarray##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_asarray##remarks"}{...}
{viewerjumpto "Conformability" "mf_asarray##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_asarray##diagnostics"}{...}
{viewerjumpto "Source code" "mf_asarray##source"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[M-5] asarray()} {hline 2}}Associative arrays
{p_end}
{p2col:}({mansection M-5 asarray():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{col 10}{...}
{it:A} {cmd:=} {...}
{cmd:asarray_create(}[  {it:keytype}{...}
{right:{it:declare A                 }}
{col 29}[, {it:keydim} 
{col 29}[, {it:minsize} 
{col 29}[, {it:minratio} 
{col 29}[, {it:maxratio} ]]]]]{cmd:)}

{col 15}{...}
{cmd:asarray(}{it:A}{cmd:,} {...}
{it:key}{cmd:,} {...}
{it:a}{cmd:)}{...}
{right:{it:A[key] = a                }}

{col 11}{...}
{it:a} {cmd:=} {...}
{cmd:asarray(}{it:A}{cmd:,} {...}
{it:key}{cmd:)}{...}
{right:{it:a = A[key] or a = notfound}}

{col 15}{...}
{cmd:asarray_remove(}{it:A}{cmd:,} {...}
{it:key}{cmd:)}{...}
{right:{it:delete A[key] if it exists}}



{col 8}{...}
{it:bool} {cmd:=} {...}
{cmd:asarray_contains(}{it:A}{cmd:,} {...}
{it:key}{cmd:)} {...}
{right:{it:A[key] exists?            }}

{col 11}{...}
{it:N} {cmd:=} {...}
{cmd:asarray_elements(}{it:A}{cmd:)}{...}
{right:{it:# of elements in A        }}


{col 8}{...}
{it:keys} {cmd:=} {...}
{cmd:asarray_keys(}{it:A}{cmd:)}{...}
{right:{it:all keys in A             }}


{col 9}{...}
{it:loc} {cmd:=} {...}
{cmd:asarray_first(}{it:A}{cmd:)}{...}
{right:{it:location of first element }}
{right:{it:or NULL                   }}

{col 9}{...}
{it:loc} {cmd:=} {...}
{cmd:asarray_next(}{it:A}{cmd:,} {...}
{it:loc}{cmd:)}{...}
{right:{it:location of next element  }}
{right:{it:or NULL                   }}

{col 9}{...}
{it:key} {cmd:=} {...}
{cmd:asarray_key(}{it:A}{cmd:,} {...}
{it:loc}{cmd:)}{...}
{right:{it:key at loc                }}

{col 11}{...}
{it:a} {cmd:=} {...}
{cmd:asarray_contents(}{it:A}{cmd:,} {...}
{it:loc}{cmd:)}{...}
{right:{it:contents a at loc         }}


{col 15}{...}
{cmd:asarray_notfound(}{it:A}{cmd:,} {...}
{it:notfound}{cmd:)}{...}
{right:{it:set notfound value        }}

{col 4}{...}
{it:notfound} {cmd:=} {...}
{cmd:asarray_notfound(}{it:A}{cmd:)} {...}
{right:{it:query notfound value      }}


{p 4 4 2}
where

{p 15 19 2}
{it:A:}
Associative array {it:A[key]}.  Created by {cmd:asarray_create()} and 
passed to the other functions.  If {it:A} is declared, it is declared 
{it:transmorphic}.

{p 9 19 2}
{it:keytype:} 
Element type of keys; 
{cmd:"string"}, {cmd:"real"}, {cmd:"complex"}, or {cmd:"pointer"}.  
Optional; default {cmd:"string"}.

{p 10 19 2}
{it:keydim:} 
Dimension of key; 
1 <= {it:keydim} <= 50.
Optional; default 1.

{p 9 19 2}
{it:minsize:} 
Initial size of hash table used to speed locating keys in {it:A};
{it:real scalar}; 5 <= {it:minsize} <= 1,431,655,764.
Optional; default 100.

{p 8 19 2}
{it:minratio:} 
Fraction filled at which hash table is automatically downsized; 
{it:real scalar}; 0 <= {it:minratio} <= 1.
Optional; 
default 0.5.

{p 8 19 2}
{it:maxratio:} 
Fraction filled at which hash table is automatically upsized; 
{it:real scalar};
1 < {it:maxratio} <= {cmd:.} (meaning infinity).
Optional; 
default 1.5.

{p 13 19 2}
{it:key:}
Key under which an element is stored in {it:A};
{it:string scalar} by default; 
type and dimension are declared using 
{cmd:asarray_create()}.

{p 15 19 2}
{it:a:}  Element of {it:A}; {it:transmorphic}; may be anything of 
any size; different {it:A[key]} elements may have different types of
contents.

{p 12 19 2}
{it:bool:}
Boolean logic value; {it:real scalar}; equal to 1 or 0 meaning true or false.

{p 15 19 2}
{it:N:}  Number of elements stored in {it:A}; {it:real scalar}; 
0 <= {it:N} <= 2,147,483,647.

{p 12 19 2}
{it:keys:}
List of all keys that exist in {it:A}.  Each row is a key.
Thus {it:keys} is a {it:string colvector} if keys are {it:string scalars}, 
a {it:string matrix} if keys are {it:string vectors}, 
a {it:real colvector} if keys are {it:real scalars}, etc.
Note that {cmd:rows(}{it:keys}{cmd:)} = {it:N}.

{p 13 19 2}
{it:loc:}
A location in {it:A}; {it:transmorphic}.  The first location is 
returned by {cmd:asarray_first()}, subsequent locations by 
{cmd:asarray_next()}.  {it:loc}{cmd:==NULL} when there are no 
more elements.

{p 8 19 2}
{it:notfound:}
Value returned by {cmd:asarray(}{it:A}{cmd:,} {it:key}{cmd:)} when 
{it:key} does not exist in {it:A}.  {it:notfound} {cmd:=} 
{cmd:J(0,0,.)} by default.



{marker description}{...}
{title:Description}

{pstd}
{cmd:asarray()} provides one- and multi-dimensional associative arrays, also
known as containers, maps, dictionaries, indices, and hash tables.

{pstd}
Also see {helpb mf_associativearray:[M-5] AssociativeArray()} for a 
class-based interface into the functions documented here. 


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 asarray()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Before writing a program using {cmd:asarray()}, you should try it
interactively.  Remarks are presented under the following headings:

	{help mf_asarray##detailed_desc:Detailed description}
	{help mf_asarray##example1:Example 1:  Scalar keys and scalar contents}
	{help mf_asarray##example2:Example 2:  Scalar keys and matrix contents}
	{help mf_asarray##example3:Example 3:  Vector keys and scalar contents; sparse matrix}
	{help mf_asarray##efficiency:Setting the efficiency parameters}


{marker detailed_desc}{...}
{title:Detailed description}

{p 4 4 2}
In associative arrays, rather than being dense integers, the indices can be
anything, even strings. So you might have {it:A["Frank Smith"]} equal to
something and {it:A["Mary Jones"]} equal to something else.  In Mata, you
write that as 
{cmd:asarray(}{it:A}{cmd:,} {cmd:"Frank Smith",} {it:  something}{cmd:)} and
{cmd:asarray(}{it:A}{cmd:,} {cmd:"Mary Jones",} {it:  somethingelse}{cmd:)} to
define the elements and {cmd:asarray(}{it:A}{cmd:,} {cmd:"Frank Smith")} and
{cmd:asarray(}{it:A}{cmd:,} {cmd:"Mary Jones")} to obtain their values.

{p 4 4 2}
{it:A} = {cmd:asarray_create()} declares (creates) an associative array.
The function allows arguments, but they are optional.  Without arguments,
{cmd:asarray_create()} declares an associative array with string 
scalar keys, corresponding to the 
{it:A["Frank Smith"]} and {it:A["Mary Jones"]} example above.

{p 4 4 2}
{it:A} = {cmd:asarray_create(}{it:keytype}{cmd:,}
{it:keydim}{cmd:)} declares an associative array with {it:keytype} 
keys each of dimension 1 {it:x} {it:keydim}.   
{cmd:asarray_create("string",} {cmd:1)} is equivalent to 
{cmd:asarray_create()} without arguments.
{cmd:asarray_create("string",} {cmd:2)} declares the keys to be string, as
before, but now they are 1 {it:x} 2 rather than 1 {it:x} 1, so array elements
would be of the form {it:A["Frank Smith", "Mary Jones"]}.  
{it:A["Mary Jones", "Frank Smith"]} would be a different element.
{cmd:asarray_create("real",} {cmd:2)} declares the keys to be real 1 {it:x} 2,
which would somewhat correspond to our ordinary idea of a matrix, namely
{it:A[i,j]}.  The difference would be that to store, say,
{it:A[100,980]}, it would not be necessary to store the interior elements,
and in addition to storing {it:A[100,980]}, we could store
{it:A[3.14159,2.71828}].

{p 4 4 2}
{cmd:asarray_create()} has three more optional arguments: 
{it:minsize}, {it:minratio}, and {it:maxratio}.  We recommend that you 
do not specify them.  They are discussed in
{it:{help mf_asarray##efficiency:Setting the efficiency parameters}}
under {bf:{help mf_asarray##remarks:Remarks}} below.

{p 4 4 2}
{cmd:asarray(}{it:A}{cmd:,} {it:key}{cmd:,} {it:a}{cmd:)} sets 
or resets element {it:A[key]} = {it:a}.
Note that if you declare {it:key} to be 1 {it:x} 2, you must use 
the parentheses vector notation to specify key literals, such as 
{cmd:asarray(}{it:A}{cmd:,} {cmd:(100,980),} {cmd:2.15)}.
Alternatively, if {cmd:k} = {cmd:(100,980)}, then 
you can omit the parentheses in
{cmd:asarray(}{it:A}{cmd:,} {cmd:k,} {cmd:2.15)}.

{p 4 4 2}
{cmd:asarray(}{it:A}{cmd:,} {it:key}{cmd:)} returns 
element {it:A[key]} or it 
returns {it:notfound} if the element does not exist.
By default, {it:notfound} is {cmd:J(0,0,.)}, but you can change 
that using 
{cmd:asarray_notfound()}.  If you redefined 
{it:notfound} to be {cmd:0} and defined keys to be real 1 {it:x} 2, 
you would be on your way to recording sparse matrices efficiently.

{p 4 4 2}
{cmd:asarray_remove(}{it:A}{cmd:,} {it:key}{cmd:)} removes 
{it:A[key]}, or it does nothing if {it:A[key]} is already undefined.

{p 4 4 2}
{cmd:asarray_contains(}{it:A}{cmd:,} {it:key}{cmd:)} 
returns 1 if {it:A[key]} is defined, and it returns 0 otherwise.

{p 4 4 2}
{cmd:asarray_elements(}{it:A}{cmd:)} returns the number of elements stored
in {it:A}.

{p 4 4 2}
{cmd:asarray_keys(}{it:A}{cmd:)} returns a vector or matrix
containing all the keys, one to a row.
The keys are not in alphabetical or numerical order.
If you want them that way, code 
{cmd:sort(asarray_keys(}{it:A}{cmd:),} {cmd:1)} 
if your keys are scalar, or in general, 
code {cmd:sort(asarray_keys(}{it:A}{cmd:),} {it:idx}{cmd:)}; see
{manhelp mf_sort M-5:sort()}.

{p 4 4 2}
{cmd:asarray_first(}{it:A}{cmd:)} and 
{cmd:asarray_next(}{it:A}{cmd:,} {it:loc}{cmd:)}
provide a way of obtaining the names one at a time.
Code 

{col 9}{cmd:for (loc=asarray_first(}{it:A}{cmd:);} {...}
{cmd:loc!=NULL;} {...}
{cmd:loc=asarray_next(}{it:A}{cmd:, loc)) {c -(}}
		...
{col 9}{cmd:{c )-}}

{p 4 4 2}
{cmd:asarray_key(}{it:A}{cmd:,} {it:loc}{cmd:)}
and
{cmd:asarray_contents(}{it:A}{cmd:,} {it:loc}{cmd:)}
return the key and contents at {it:loc}, so the loop becomes 

{col 9}{cmd:for (loc=asarray_first(}{it:A}{cmd:);} {...}
{cmd:loc!=NULL;} {...}
{cmd:loc=asarray_next(}{it:A}{cmd:, loc)) {c -(}}
		...
		...  {cmd:asarray_key(}{it:A}{cmd:, loc)} ...
		...
		...  {cmd:asarray_contents(}{it:A}{cmd:, loc)} ...
		...
{col 9}{cmd:{c )-}}

{p 4 4 2}
{cmd:asarray_notfound(}{it:A}{cmd:,} {it:notfound}{cmd:)} defines what
{cmd:asarray(}{it:A}{cmd:,} {it:key}{cmd:)} returns when the element does not
exist.  By default, {it:notfound} is {cmd:J(0,0,.)}, which is to say, a 0
{it:x} 0 real matrix.  You can reset {it:notfound} at any time.
{cmd:asarray_notfound(}{it:A}{cmd:)} returns the current value of 
{it:notfound}.


{* asarrayex.do, junk1.smcl}{...}
{marker example1}{...}
{title:Example 1:  Scalar keys and scalar contents}

	{com}: A = asarray_create()
	{res}
	{com}: asarray(A, "bill", 1.25)
	{res}
	{com}: asarray(A, "mary", 2.75)
	{res}
	{com}: asarray(A, "dan",  1.50)
	{res}
	{com}: asarray(A, "bill")
	{res}  1.25

	{com}: asarray(A, "mary")
	{res}  2.75

	{com}: asarray(A, "mary", 3.25)
	{res}
	{com}: asarray(A, "mary")
	{res}  3.25

	{com}: sum = 0
	{res}
	{com}: for (loc=asarray_first(A); loc!=NULL; loc=asarray_next(A, loc)) {c -(}
	          sum = sum + asarray_contents(A, loc)
	  {c )-}
	{res}
	{com}: sum
	{res}  6

	{com}: sum/asarray_elements(A)
	{res}  2{txt}
{com}{sf}{ul off}


{* asarrayex.do, junk2.smcl}{...}
{marker example2}{...}
{title:Example 2:  Scalar keys and matrix contents}

	{com}: A = asarray_create() 
	{res}
	{com}: asarray(A, "Count", (1,2\3,4))
	{res}
	{com}: asarray(A, "Hilbert", Hilbert(3))
	{res}
	{com}: asarray(A, "Count")
	{res}       {txt}1   2
            {c TLC}{hline 9}{c TRC}
          1 {c |}  {res}1   2{txt}  {c |}
          2 {c |}  {res}3   4{txt}  {c |}
            {c BLC}{hline 9}{c BRC}

	{com}: asarray(A, "Hilbert")
	{res}{txt}[symmetric]
                         1             2             3
            {c TLC}{hline 43}{c TRC}
          1 {c |}  {res}          1                            {txt}  {c |}
          2 {c |}  {res}         .5   .3333333333              {txt}  {c |}
          3 {c |}  {res}.3333333333           .25            .2{txt}  {c |}
            {c BLC}{hline 43}{c BRC}{txt}


{* asarrayex.do, junk3.smcl}{...}
{marker example3}{...}
{title:Example 3:  Vector keys and scalar contents; sparse matrix}

	{com}: A = asarray_create("real", 2)
	{res}
	{com}: asarray_notfound(A, 0)
	{res}
	{com}: asarray(A, (   1,    1), 1)
	{res}
	{com}: asarray(A, (1000,  999), .5)
	{res}
	{com}: asarray(A, (1000, 1000), 1)
	{res}
	{com}: asarray(A, (1000, 1001), .5)
	{res}
	{com}: asarray(A, (1,1))
	{res}  1

	{com}: asarray(A, (2,2))
	{res}  0

	{com}: // one way to get the trace:
	: trace = 0 
	{res}
	{com}: for (i=1; i<=1000; i++) trace = trace + asarray(A, (i,i))
	{res}
	{com}: trace
	{res}  2

	{com}: // another way to get the trace 
	: trace = 0
	{res}
	{com}: for (loc=asarray_first(A); loc!=NULL; loc=asarray_next(A, loc)) {c -(}
	          index = asarray_key(A, loc) 
	          if (index[1]==index[2]) {c -(}
	                  trace = trace + asarray_contents(A, loc)
	          {c )-}
	  {c )-}
	{res}
	{com}: trace
	{res}  2{txt}


{marker efficiency}{...}
{title:Setting the efficiency parameters}

{p 4 4 2}
The syntax {cmd:asarray_create()} is

{p 8 12 2}
{it:A} {cmd:=} {...}
{cmd:asarray_create(}{it:keytype}{cmd:,}
{it:keydim}{cmd:,}
{it:minsize}{cmd:,} 
{it:minratio}{cmd:,} 
{it:maxratio}{cmd:)}

{p 4 4 2}
All arguments are optional.  The first two specify the characteristics of the
key and their use has already been illustrated.  The last three are efficiency
parameters.  In most circumstances, we recommend you do not specify them.
The default values have been chosen to produce reasonable execution times with
reasonable memory consumption.

{p 4 4 2}
{cmd:asarray()} works via hash tables.  Say we wish to record {it:n} entries.
The idea is to allocate a hash table of {it:N} rows, where {it:N} can be less
than, equal to, or greater than {it:n}.  When one needs to find the element
corresponding to a key, one calculates a function of the key, called a hash
function, that returns an integer {it:h} from 1 to {it:N}.  One first looks in
row {it:h}.  If row {it:h} is already in use and the keys are different, we
have a collision.  In that case, we have to allocate a duplicates list for the
{it:h}th row and put the duplicate keys and contents into that list.  Collisions
are bad because, when they occur, {cmd:asarray()} has to allocate a duplicates
list, requiring both time and memory, though it does not require
much.  When fetching results, if row {it:h} has a duplicates list,
{cmd:asarray()} has to search the list, which it does sequentially, and that
takes extra time, too.  Hash tables work best when collisions happen rarely.

{p 4 4 2}
Obviously, collisions are certain to occur if {it:N} < {it:n}.  
Note, however, that although performance suffers, the method does not 
break.  A hash table of {it:N} can hold any number of entries, even 
if {it:N} < {it:n}.

{p 4 4 2}
Performance depends on details of implementation.  We have examined 
the behavior of {cmd:asarray()} and discovered that collisions rarely 
occur when {it:n}/{it:N} <= 0.75.  When {it:n}/{it:N} = 1.5, 
performance suffers, but not by as much as you might expect.
Around {it:n}/{it:N} = 2, performance degrades considerably.  

{p 4 4 2}
When you add or remove an element, {cmd:asarray()} examines
{it:n}/{it:N} and considers rebuilding the table with a larger or smaller
{it:N}; it rebuilds the table when {it:n}/{it:N} is large to preserve
efficiency.  It rebuilds the table when {it:n}/{it:N} is small to conserve
memory.  Rebuilding the table is a computer-intensive operation, and so should
not be performed too often.

{p 4 4 2}
In making these decisions, {cmd:asarray()} uses three parameters:

{p 8 19 2}
{it:maxratio:}
When {it:n}/{it:N} >= {it:maxratio}, the table is upsized to {it:N} = 
1.5*{it:n}.

{p 8 19 2}
{it:minratio:}
When {it:n}/{it:N} <= {it:minratio}/1.5, the table is downsized to {it:N} =
1.5*{it:n}. (For an exception, see {it:minsize}.)

{p 9 19 2}
{it:minsize:} 
If the new {it:N} < 1.5*{it:minsize}, the table is downsized to 
{it:N} = 1.5*{it:minsize} if it is not already that size.

{p 4 4 2}
The default values of the three parameters are 1.5, 0.5, and 100.
You can reset them, though you are unlikely to improve on the default values of
{it:minratio} and {it:maxratio}.  

{p 4 4 2}
You can improve on {it:minsize} when you know the number
of elements that will be in the table and that number is 
greater than 100.  For instance, if you know the table will contain 
at least 1,000 elements, starting {it:minsize} at 1,000, which implies 
{it:N} = 1,500, will 
prevent two rescalings, namely, from 150 to 451, and from 451 to 1,354.
This saves a little time.

{p 4 4 2}
You can also turn off the resizing features.  Setting {it:minratio} to 0 turns
off downsizing.  Setting {it:maxratio} to {cmd:.} (missing) turns off upsizing.
You might want to turn off both downsizing and upsizing if you set 
{it:minsize} sufficiently large for your problem.

{p 4 4 2}
We would never recommend turning off upsizing alone, and we seldom would
recommend turning off downsizing alone.  In a program where it is known that
the array will exist for only a short time, however, turning off downsizing can
be efficient.  In a program where the array might exist for a considerable
time, turning off downsizing is dangerous because then the array could
only grow (and probably will).


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:asarray_create(}{it:keytype}{cmd:,}
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
	   {it:result}:  {it:transmorphic}

{p 4 4 2}
{cmd:asarray(}{it:A}{cmd:,}
{it:key}{cmd:,}
{it:a}{cmd:)}:
{p_end}
		{it:A}:  {it:transmorphic}
	      {it:key}:  1 {it:x} {it:keydim}
		{it:a}:  {it:r_key x c_key}
	   {it:result}:  {it:void}

{p 4 4 2}
{cmd:asarray(}{it:A}{cmd:,}
{it:key}{cmd:)}:
{p_end}
		{it:A}:  {it:transmorphic}
	      {it:key}:  1 {it:x} {it:keydim}
	   {it:result}:  {it:r_key x c_key}

{p 4 4 2}
{cmd:asarray_remove(}{it:A}{cmd:,}
{it:key}{cmd:)}:
{p_end}
		{it:A}:  {it:transmorphic}
	      {it:key}:  1 {it:x} {it:keydim}
	   {it:result}:  {it:void}

{p 4 4 2}
{cmd:asarray_contains(}{it:A}{cmd:,}
{it:key}{cmd:)}, 
{cmd:asarray_elements(}{it:A}{cmd:,}
{it:key}{cmd:)}:
{p_end}
		{it:A}:  {it:transmorphic}
	      {it:key}:  1 {it:x} {it:keydim}
	   {it:result}:  1 {it:x} 1


{p 4 4 2}
{cmd:asarray_keys(}{it:A}{cmd:,}
{it:key}{cmd:)}:
{p_end}
		{it:A}:  {it:transmorphic}
	      {it:key}:  1 {it:x} {it:keydim}
	   {it:result}:  {it:n} {it:x} {it:keydim}

{p 4 4 2}
{cmd:asarray_first(}{it:A}{cmd:)}:
{p_end}
		{it:A}:  {it:transmorphic}
	   {it:result}:  {it:transmorphic}

	
{p 4 4 2}
{cmd:asarray_first(}{it:A}{cmd:,}
{it:loc}{cmd:)}:
{p_end}
		{it:A}:  {it:transmorphic}
	      {it:loc}:  {it:transmorphic}
	   {it:result}:  {it:transmorphic}

{p 4 4 2}
{cmd:asarray_key(}{it:A}{cmd:,}
{it:loc}{cmd:)}:
{p_end}
		{it:A}:  {it:transmorphic}
	      {it:loc}:  {it:transmorphic}
	   {it:result}:  1 {it:x} {it:keydim}

{p 4 4 2}
{cmd:asarray_contents(}{it:A}{cmd:,}
{it:loc}{cmd:)}:
{p_end}
		{it:A}:  {it:transmorphic}
	      {it:loc}:  {it:transmorphic}
	   {it:result}:  {it:r_key} {it:x} {it:c_key}

{p 4 4 2}
{cmd:asarray_notfound(}{it:A}{cmd:,}
{it:notfound}{cmd:)}:
{p_end}
		{it:A}:  {it:transmorphic}
	 {it:notfound}:  {it:r} {it:x} {it:c}
	   {it:result}:  {it:void}

{p 4 4 2}
{cmd:asarray_notfound(}{it:A}{cmd:)}:
{p_end}
		{it:A}:  {it:transmorphic}
	   {it:result}:  {it:r} {it:x} {it:c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view asarray.mata, adopath asis:asarray.mata}
{p_end}
