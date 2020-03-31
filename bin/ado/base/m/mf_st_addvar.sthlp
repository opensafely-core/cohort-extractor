{smcl}
{* *! version 1.1.9  15may2018}{...}
{vieweralsosee "[M-5] st_addvar()" "mansection M-5 st_addvar()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] st_store()" "help mf_st_store"}{...}
{vieweralsosee "[M-5] st_tempname()" "help mf_st_tempname"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Stata" "help m4_stata"}{...}
{viewerjumpto "Syntax" "mf_st_addvar##syntax"}{...}
{viewerjumpto "Description" "mf_st_addvar##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_st_addvar##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_st_addvar##remarks"}{...}
{viewerjumpto "Conformability" "mf_st_addvar##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_addvar##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_addvar##source"}{...}
{viewerjumpto "Reference" "mf_st_addvar##reference"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-5] st_addvar()} {hline 2}}Add variable to current Stata dataset
{p_end}
{p2col:}({mansection M-5 st_addvar():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real rowvector}{bind: }
{cmd:st_addvar(}{it:type}{cmd:,} {it:name}{cmd:)}

{p 8 12 2}
{it:real rowvector}{bind: }
{cmd:st_addvar(}{it:type}{cmd:,} {it:name}{cmd:,} {it:nofill}{cmd:)}


{p 8 12 2}
{it:real rowvector}
{cmd:_st_addvar(}{it:type}{cmd:,} {it:name}{cmd:)}

{p 8 12 2}
{it:real rowvector}
{cmd:_st_addvar(}{it:type}{cmd:,} {it:name}{cmd:,} {it:nofill}{cmd:)}

{p 4 4 2}
where

{p 12 19 2}
{it:type}:  {it:string scalar} or {it:rowvector} containing 
{cmd:"byte"}, 
{cmd:"int"},
{cmd:"long"},
{cmd:"float"},
{cmd:"double"},
{cmd:"str}{it:#}{cmd:"}, or
{cmd:"strL"}

{p 19 19 2}
or

{p 19 19 2}
{it:real scalar} or {it:rowvector} containing {it:#} (interpreted as 
{cmd:str}{it:#})

{p 12 19 2}
{it:name}:  {it:string rowvector} containing new variable names

{p 10 19 2}
{it:nofill}:  {it:real scalar} containing 0 or non-0


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:st_addvar(}{it:type}{cmd:,} {it:name}{cmd:)}
adds new variable {it:name}(s) of type {it:type} to the Stata dataset.
Returned are the variable indices of the new variables.  {cmd:st_addvar()}
aborts with error (and adds no variables) if any of the variables already
exist or cannot be added for other reasons.

{p 4 4 2}
{cmd:st_addvar(}{it:type}{cmd:,} {it:name}{cmd:,} {it:nofill}{cmd:)}
does the same thing.  {it:nofill}!=0 specifies that the variables' values are 
not to be filled in with missing values.  
{cmd:st_addvar(}{it:type}{cmd:,} {it:name}{cmd:, 0)} is the same as 
{cmd:st_addvar(}{it:type}{cmd:,} {it:name}{cmd:)}.
Use of {it:nofill}!=0 is not, in general, recommended.  
See {it:{help mf_st_addvar##remarks7:Using nofill}} in
{it:Remarks} below.

{p 4 4 2}
{cmd:_st_addvar()} does the same thing as {cmd:st_addvar()} except that, 
rather than aborting with error if the new variable cannot be added, 
returned is a 1 {it:x} 1 scalar containing the negative of the appropriate Stata
return code.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 st_addvar()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_st_addvar##remarks1:Creating a new variable}
	{help mf_st_addvar##remarks2:Creating new variables}
	{help mf_st_addvar##remarks3:Creating new string variables}
	{help mf_st_addvar##remarks4:Creating a new temporary variable}
	{help mf_st_addvar##remarks5:Creating temporary variables}
	{help mf_st_addvar##remarks6:Handling errors}
	{help mf_st_addvar##remarks7:Using nofill}


{marker remarks1}{...}
{title:Creating a new variable}

{p 4 4 2}
To create new variable {cmd:myvar} as a {cmd:double}, code 

	{cmd:idx = st_addvar("double", "myvar")}

{p 4 4 2}
or

	{cmd:(void) st_addvar("double", "myvar")}

{p 4 4 2}
You use the first form if you will subsequently need the variable's index 
number, or you use the second form otherwise.


{marker remarks2}{...}
{title:Creating new variables}

{p 4 4 2}
You can add more than one variable.  For instance,

	{cmd:idx = st_addvar("double", ("myvar1","myvar2"))}

{p 4 4 2}
adds two new variables, both of type {cmd:double}.  

	{cmd:idx = st_addvar(("double","float"), ("myvar1","myvar2"))}

{p 4 4 2}
also adds two new variables, but this time, {cmd:myvar1} is {cmd:double}
and {cmd:myvar2} is {cmd:float}.


{marker remarks3}{...}
{title:Creating new string variables}

{p 4 4 2}
Creating string variables is no different from any other type:

	{cmd:idx = st_addvar(("str10","str5"), ("myvar1","myvar2"))}

{p 4 4 2}
creates {cmd:myvar1} as a {cmd:str10} and {cmd:myvar2} as a {cmd:str5}.

{p 4 4 2}
There is, however, another way to specify the types.

	{cmd:idx = st_addvar((10,5), ("myvar1","myvar2"))}

{p 4 4 2}
also creates {cmd:myvar1} as a {cmd:str10} and {cmd:myvar2} as a {cmd:str5}.

	{cmd:idx = st_addvar(10, ("myvar1","myvar2"))}

{p 4 4 2}
creates both variables as {cmd:str10}s.


{marker remarks4}{...}
{title:Creating a new temporary variable}

{p 4 4 2}
Function {cmd:st_tempname()} (see
{bf:{help mf_st_tempname:[M-5] st_tempname()}}) returns temporary 
variable names.  To create a temporary variable as a {cmd:double}, code 

	{cmd:idx = st_addvar("double", st_tempname())}

{p 4 4 2}
or code 

	{cmd:(void) st_addvar("double", name=st_tempname())}

{p 4 4 2}
You use the first form if you will subsequently need the variable's index,
or you use the second form if you will subsequently need the variable's name.
You will certainly need one or the other.  If you will need both, code 

	{cmd:idx = st_addvar("double", name=st_tempname())}


{marker remarks5}{...}
{title:Creating temporary variables}

{p 4 4 2}
{cmd:st_tempname()} can return a vector of 
temporary variable names.

	{cmd:idx = st_addvar("double", st_tempname(5))}

{p 4 4 2}
creates five temporary variables, each of type {cmd:double}.


{marker remarks6}{...}
{title:Handling errors}

{p 4 4 2}
There are three common reasons why {cmd:st_addvar()} might fail:  the
variable name is invalid or a variable under that name already exists or there
is insufficient memory to add another variable.
If there is a problem adding a variable, {cmd:st_addvar()} will abort with 
error.  If you wish to avoid the traceback log and just have Stata issue 
an error, use {cmd:_st_addvar()} and code

	{cmd:if ((idx = _st_addvar("double", "myvar"))<0) exit(error(-idx))}

{p 4 4 2}
If you are adding multiple variables, look at the first element of 
what {cmd:_st_addvar()} returns:

	{cmd:if ((idx = _st_addvar(types, names))[1]<0) exit(error(-idx))}


{marker remarks7}{...}
{title:Using nofill}

{p 4 4 2}
The three-argument versions of {cmd:st_addvar()} and {cmd:_st_addvar()} allow
you to avoid filling in the values of the newly created variable.
Filling in those values with missing really is a waste of time if the 
next thing you are going to do is fill in the values with something else.
On the other hand, it is important that all the observations be
filled in on the new variable before control is returned to Stata, and 
this includes returning to Stata because of subsequent error or the user
pressing {hi:Break}.  Thus use of {it:nofill}!=0 is not, in general,
recommended.  Filling in values really does not take that long.

{p 4 4 2}
If you are determined to save the computer time, however, 
see {bf:{help mf_setbreakintr:[M-5] setbreakintr()}}.  To do things right, you 
need to set the break key off, create your variable, fill it in, and turn 
break-key processing back on.

{p 4 4 2}
There is, however, a case in which use of {it:nofill}!=0 is acceptable and 
such effort is not required:  when you are creating a temporary variable.
Temporary variables vanish in any case, and it does not matter whether they are 
filled in before they vanish.  

{p 4 4 2}
Temporary variables in fact vanish not when Mata ends but when the ado-file 
calling Mata ends, if there is an ado-file.  We will assume there is an 
ado-file because that is the only case in which you would be creating a 
temporary variable anyway.  Because they do not disappear until 
later, there is the possibility of there being an issue if the variable is
not filled in.  If we assume, however, that your Mata program is correctly 
written and does fill in the variable ultimately, then the chances of a 
problem are minimal.  If the user presses {hi:Break} or there is some other 
problem in your program that causes Mata to abort, the ado-file will be 
aborted, too, and the variable will vanish.

{p 4 4 2}
Let us add that Stata will not crash if a variable is not filled in, even 
if it regains control.  The danger is that the user will look at the variable
or, worse, use it and be baffled by what he or she sees, which might 
concern not only odd values but also NaNs and worse.


{marker conformability}{...}
{title:Conformability}

    {cmd:st_addvar(}{it:type}{cmd:,} {it:name}{cmd:,} {it:nofill}{cmd:)}: 
	     {it:type}:  1 {it:x} 1  or  1 {it:x k}
	     {it:name}:  1 {it:x k}
	   {it:nofill}:  1 {it:x} 1    (optional)
	   {it:result}:  1 {it:x k}

    {cmd:_st_addvar(}{it:type}{cmd:,} {it:name}{cmd:,} {it:nofill}{cmd:)}:
	     {it:type}:  1 {it:x} 1  or  1 {it:x k}
	     {it:name}:  1 {it:x k}
	   {it:nofill}:  1 {it:x} 1    (optional)
	   {it:result}:  1 {it:x k}  or, if error, 1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:st_addvar(}{it:type}{cmd:,} {it:name}{cmd:,} {it:nofill}{cmd:)}
aborts with error if 

{p 8 12 2}
1.  {it:type} is not equal to a valid Stata variable type and it is not 
    a number that would form a valid {cmd:str}{it:#} variable type;

{p 8 12 2}
2.  {it:name} is not a valid variable name;

{p 8 12 2}
3.  a variable named {it:name} already exists;

{p 8 12 2}
4.  there is insufficient memory to add another variable.

{p 4 4 2}
{cmd:_st_addvar(}{it:type}{cmd:,} {it:name}{cmd:,} {it:nofill}{cmd:)}
aborts with error for reason 1 above, but otherwise, it returns the 
negative value of the appropriate Stata return code.

{p 4 4 2}
Both functions, when creating multiple variables, create either all the 
variables or none of them.
Whether creating one variable or many, 
if variables are created, {cmd:st_updata()} (see
{bf:{help mf_st_updata:[M-5] st_updata()}}) is set unless all variables
are temporary; see {bf:{help mf_st_tempname:[M-5] st_tempname()}}.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}


{marker reference}{...}
{title:Reference}

{phang}
Gould, W. W. 2006.
{browse "http://www.stata-journal.com/sjpdf.html?articlenum=pr0021":Mata Matters: Creating new variables -- sounds boring, isn't}.
{it:Stata Journal} 6: 112-123.
{p_end}
