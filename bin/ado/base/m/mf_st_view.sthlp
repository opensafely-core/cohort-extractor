{smcl}
{* *! version 1.2.10  15may2018}{...}
{vieweralsosee "[M-5] st_view()" "mansection M-5 st_view()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] select()" "help mf_select"}{...}
{vieweralsosee "[M-5] st_data()" "help mf_st_data"}{...}
{vieweralsosee "[M-5] st_subview()" "help mf_st_subview"}{...}
{vieweralsosee "[M-5] st_viewvars()" "help mf_st_viewvars"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Stata" "help m4_stata"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] putmata" "help putmata"}{...}
{viewerjumpto "Syntax" "mf_st_view##syntax"}{...}
{viewerjumpto "Description" "mf_st_view##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_st_view##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_st_view##remarks"}{...}
{viewerjumpto "Conformability" "mf_st_view##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_view##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_view##source"}{...}
{viewerjumpto "Reference" "mf_st_view##reference"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[M-5] st_view()} {hline 2}}Make matrix that is a view onto current Stata dataset
{p_end}
{p2col:}({mansection M-5 st_view():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:void}
{cmd:st_view(}{it:V}{cmd:,}
{it:real matrix i}{cmd:,}
{it:rowvector j})

{p 8 12 2}
{it:void}
{cmd:st_view(}{it:V}{cmd:,}
{it:real matrix i}{cmd:,}
{it:rowvector j}{cmd:,}
{it:scalar selectvar}{cmd:)}


{p 8 12 2}
{it:void}
{cmd:st_sview(}{it:V}{cmd:,}
{it:real matrix i}{cmd:,}
{it:rowvector j})

{p 8 12 2}
{it:void}
{cmd:st_sview(}{it:V}{cmd:,}
{it:real matrix i}{cmd:,}
{it:rowvector j}{cmd:,}
{it:scalar selectvar}{cmd:)}


{p 4 4 2}
where

{p 7 11 2}
1.  The type of {it:V} does not matter; it is replaced.

{p 7 11 2}
2.  {it:i} may be specified in the same way as with 
    {bf:{help mf_st_data:st_data()}}.

{p 7 11 2}
3.  {it:j} may be specified in the same way as with 
    {bf:{help mf_st_data:st_data()}}.  Factor variables and
    time-series-operated variables may be specified.

{p 7 11 2}
4.  {it:selectvar} may be specified in the same way as with 
    {bf:{help mf_st_data:st_data()}}.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:st_view()} and {cmd:st_sview()} create a matrix that is a view 
onto the current Stata dataset.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 st_view()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_st_view##remarks1:Overview}
	{help mf_st_view##remarks2:Advantages and disadvantages of views}
	{help mf_st_view##remarks3:When not to use views}
	{help mf_st_view##remarks4:Cautions when using views 1:  Conserving memory}
	{help mf_st_view##remarks5:Cautions when using views 2:  Assignment}
	{help mf_st_view##remarks6:Efficiency}


{marker remarks1}{...}
{title:Overview}

{p 4 4 2}
{cmd:st_view()} 
serves the same purpose as {cmd:st_data()} -- and {cmd:st_sview()}
serves the same purpose as {cmd:st_sdata()} -- except that, 
rather than returning a matrix that is 
a copy of the underlying values, {cmd:st_view()} and {cmd:st_sview()} create a
matrix that is a view onto the Stata dataset itself.

{p 4 4 2}
To understand the distinction, consider 

	{cmd:X = st_data(., "mpg displ weight")}

{p 4 4 2}
and 

	{cmd:st_view(X, ., "mpg displ weight")}

{p 4 4 2}
Both commands fill in matrix {cmd:X} with the same data.  However, 
were you to code 

	{cmd:X[2,1] = 123}

{p 4 4 2}
after the {cmd:st_data()} setup, you would change the value in the matrix 
{cmd:X}, but the Stata dataset would remain unchanged.  After the
{cmd:st_view()} setup, changing the value in the matrix would cause the
value of {cmd:mpg} in the second observation to change to 123.


{marker remarks2}{...}
{title:Advantages and disadvantages of views}

{p 4 4 2}
Views make it easy to change the dataset, and that can be 
an advantage or a disadvantage, depending on your goals.

{p 4 4 2}
Putting that aside,
views are in general better than copies because 1) they take less time 
to set up and 2) they consume less memory.  
The memory savings can be considerable.
Consider a 100,000-observation dataset on 
30 variables.  Coding 

	{cmd:X = st_data(., .)}

{p 4 4 2}
creates a new matrix that is 24 MB in size.  Meanwhile, the total 
storage requirement for 

	{cmd:st_view(X, ., .)}

{p 4 4 2} 
is roughly 128 bytes!  

{p 4 4 2}
There is a cost; when you use the matrix {cmd:X}, it takes 
longer to access the individual elements.  You would 
have to do a lot of calculation
with {cmd:X}, however, before that sum of the longer access times
would equal the initial savings
in setup time, and even then, the longer access time is probably worth 
the savings in memory.


{marker remarks3}{...}
{title:When not to use views}

{p 4 4 2}
Do not use views as a substitute for scalars.  If you are going to loop 
through the data an observation at a time, and if every usage you will 
make of {it:X} is in scalar calculations, use {helpb mf_st_data:_st_data()}.
There is nothing faster for that problem.

{p 4 4 2}
Putting aside that extreme, views become more efficient relative to 
copies the larger they are; that is, it is more efficient to 
use {helpb mf_st_data:st_data()} for small amounts of data, especially if you
are going to make computationally intensive calculations with it.


{marker remarks4}{...}
{title:Cautions when using views 1:  Conserving memory}

{p 4 4 2}
If you are using views, it is probably because you are concerned about 
memory, and if you are, you want to be careful to avoid making copies of 
views.  Copies of views are not views; they are copies.  For instance, 

	{cmd:st_view(V, ., .)}
	{cmd:Y = V}

{p 4 4 2}
That innocuous looking {cmd:Y = V} just made a copy of the entire dataset, 
meaning that if the dataset had 100,000 observations on 30 variables, 
{cmd:Y} now consumes 24 MB.  Coding {cmd:Y = V} may be desirable in 
certain circumstances, but in general, it is better to set up another view.

{p 4 4 2}
Similarly, watch out for subscripts.  Consider the following code fragment

	{cmd:st_view(V, ., .)}
	{cmd:for (i=1; i<=cols(V); i++) {c -(}}
		{cmd:sum = colsum(V[,i])}
		...
	{cmd:{c )-}}

{p 4 4 2}
The problem in the above code is the {cmd:V[,i]}.  That creates a new 
column vector containing the values from the {cmd:i}th column of {cmd:V}.
Given 100,000 observations, that new column vector needs 800k of memory.
Better to code would be

	{cmd:for (i=1; i<=cols(V); i++) {c -(}}
		{cmd:st_view(v, ., i)}
		{cmd:sum = colsum(v)}
		...
	{cmd:{c )-}}


{p 4 4 2}
If you need {cmd:V} and {cmd:v}, that is okay.  You can have many views of the
data setup simultaneously.

{p 4 4 2}
Similarly, be careful using views with operators.  {cmd:X'X} makes a 
copy of {cmd:X} in the process of creating the transpose.
Use functions such as {cmd:cross()} (see {bf:{help mf_cross:[M-5] cross()}})
that are designed to minimize the use of memory.

{p 4 4 2}
Do not be overly concerned about this issue.  Making a copy of
a column of a view amounts to the same thing as introducing a temporary 
variable in a Stata program -- something that is done all the time.


{marker remarks5}{...}
{title:Cautions when using views 2:  Assignment}

{p 4 4 2}
The ability to assign to a view and so change the
underlying data can be either convenient or dangerous, depending on your
goals.
When making such assignments, there are two things you need be 
aware of.  

{p 4 4 2}
The first is more of a Stata issue than it is a Mata issue.  Assignment 
does not cause promotion.  Coding 

	{cmd:V[1,2] = 4059.125}

{p 4 4 2}
might store 4059.125 in the first observation of the second variable of the
view.  Or, if that second variable is an {cmd:int}, what will be stored is
4059, or if it is a {cmd:byte}, what will be stored is missing.

{p 4 4 2}
The second caution is a Mata issue.  To reassign all the values of the 
view, code

	{cmd:V[.,.] = }{it:matrix_expression}

{p 4 4 2}
Do not code

	{cmd:V = }{it:matrix_expression}

{p 4 4 2}
The second expression does not assign to the underlying dataset, it 
redefines {cmd:V} to be a regular matrix.  

{p 4 4 2}
Mata does not allow the use of views as the destination of assignment when the
view contains factor variables or time-series-operated variables such as
{cmd:i.rep78} or {cmd:l.gnp}.


{marker remarks6}{...}
{title:Efficiency}

{p 4 4 2}
Whenever possible, 
specify argument {it:i} of 
{cmd:st_view(}{it:V}{cmd:,} {it:i}{cmd:,} {it:j}{cmd:)}
and 
{cmd:st_sview(}{it:V}{cmd:,} {it:i}{cmd:,} {it:j}{cmd:)}
as {cmd:.} (missing value) or as a row vector range (for example, 
{cmd:(}{it:i1}{cmd:,}{it:i2}{cmd:)}) rather than as a 
column vector list.  

{p 4 4 2}
Specify argument {it:j} as a real row vector rather than as a string 
whenever 
{cmd:st_view()} and
{cmd:st_sview()} are used inside loops with the same variables
(and the view does not contain factor variables nor time-series-operated variables).
This prevents Mata from having to look up the same names over and over again.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:st_view(}{it:V}{cmd:,} {it:i}{cmd:,} {it:j}{cmd:)}, 
{cmd:st_sview(}{it:V}{cmd:,} {it:i}{cmd:,} {it:j}{cmd:)}:
{p_end}
	{it:input:}
		{it:i}:  {it:n x} 1  or  {it:n2 x} 2
		{it:j}:  1 {it:x k}  or   1 {it:x} 1 containing {it:k} elements when expanded
	{it:output:}
		{it:V}:  {it:n x k}

{p 4 4 2}
{cmd:st_view(}{it:V}{cmd:,} {it:i}{cmd:,} {it:j}{cmd:,} {it:selectvar}{cmd:)}, 
{cmd:st_sview(}{it:V}{cmd:,} {it:i}{cmd:,} {it:j}{cmd:,} {it:selectvar}{cmd:)}:
{p_end}
	{it:input:}
		{it:i}:  {it:n x} 1  or  {it:n2 x} 2
		{it:j}:  1 {it:x k}  or   1 {it:x} 1 containing {it:k} elements when expanded
	{it:selectvar}:  1 {it:x} 1
	{it:output:}
		{it:V}:  ({it:n}-{it:e}) {it:x k}, where {it:e} is number of
		    observations excluded by {it:selectvar}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:st_view(}{it:i}{cmd:,} {it:j}[{cmd:,} {it:selectvar}]{cmd:)}
and
{cmd:st_sview(}{it:i}{cmd:,} {it:j}[{cmd:,} {it:selectvar}]{cmd:)}
abort with error if any element of {it:i} is outside the range of observations
or if a variable name or index recorded in {it:j} is not found.
Variable-name abbreviations are allowed.  If you do not want this and no factor
variables nor time-series-operated variables are specified, use
{cmd:st_varindex()} (see {bf:{help mf_st_varindex:[M-5] st_varindex()}}) to
translate variable names into variable indices.

{p 4 4 2}
{cmd:st_view()} and {cmd:st_sview()}
abort with error if any element 
of {it:i} is out of range as described under the heading
{it:{help mf_st_data##remarks3:Details of observation subscripting using st_data() and st_sdata()}}
in {bf:{help mf_st_data:[M-5] st_data()}}.

{p 4 4 2}
Some functions do not allow views as arguments.  If
{cmd:example(}{it:X}{cmd:)} does not allow views, you can still use it by
coding

		... {cmd:example(X=V)} ...

{p 4 4 2}
because that will make a copy of view {cmd:V} in {cmd:X}.  Most functions 
that do not allow views mention that in their {hi:Diagnostics} section, 
but some do not because it was unexpected that anyone would want to use a 
view in that case.  If a function does not allow a view, you will see 
in the traceback log:
                                                                                
                : {cmd:myfunction(}...}{cmd:)}
                           {err}example():  3103  view found where array required
                             mysub():     -  function returned error
                        myfunction():     -  function returned error
                             <istmt>:     -  function returned error{txt}
                r(3103);

{p 4 4 2}
The above means that function {cmd:example()} does not allow views.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}


{marker reference}{...}
{title:Reference}

{phang}
Gould, W. W. 2005.
{browse "http://www.stata-journal.com/sjpdf.html?articlenum=pr0019":Mata Matters: Using views onto the data}.
{it:Stata Journal} 5: 567-573.
{p_end}
