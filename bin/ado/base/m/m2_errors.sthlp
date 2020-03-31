{smcl}
{* *! version 1.1.13  27apr2019}{...}
{vieweralsosee "[M-2] Errors" "mansection M-2 Errors"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] error()" "help mf_error"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Intro" "help m2_intro"}{...}
{viewerjumpto "Description" "m2_errors##description"}{...}
{viewerjumpto "Links to PDF documentation" "m2_errors##linkspdf"}{...}
{viewerjumpto "Remarks" "m2_errors##remarks"}{...}
{viewerjumpto "The error codes" "m2_errors##error"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[M-2] Errors} {hline 2}}Error codes
{p_end}
{p2col:}({mansection M-2 Errors:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{p 4 4 2}
When an error occurs, Mata presents a number as well as text describing 
the problem.  The codes are presented below.

{p 4 4 2}
Also the error codes can be used as an argument with 
{cmd:_error()}, see
{bf:{help mf_error:[M-5] error()}}.

{p 4 4 2}
Mata's error codes are a special case of Stata's return codes.  In particular,
they are the return codes in the range 3000-3999.  In addition to the
3000-level codes, it is possible for Mata functions to generate any Stata
error message and return code.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-2 ErrorsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Error messages in Mata break into two classes: errors that occur 
when the function is compiled (code 3000) and errors that occur 
when the function is executed (codes 3001-3999).  

{p 4 4 2}
Compile-time error messages look like this:

	: {cmd:2,,3}
	{err:invalid expression}
	r(3000);

	: {cmd:"this" + "that}
	{err:mismatched quotes}
	r(3000);

{p 4 4 2}
The text of the message varies according to the error made, but the 
error code is always 3000.

{p 4 4 2} 
Run-time errors look like this:

	: {cmd:myfunction(2,3)}
		     {err}solve():  3200  conformability error
	             mysub():     -  function returned error
	        myfunction():     -  function returned error
	             <istmt>:     -  function returned error{txt}
	r(3200);

{p 4 4 2}
The output is called a traceback log.  Read from bottom to top, it says that
what we typed (the {cmd:<istmt>}) called {cmd:myfunction()}, which called
{cmd:mysub()}, which called {cmd:solve()} and, at that point, things went
wrong.  The error is possibly in {cmd:solve()}, but because {cmd:solve()} is a
library function, it is more likely that the error is in how {cmd:mysub()}
called {cmd:solve()}.  Moreover, the error is seldom in the program
listed at the top of the traceback log because the log lists the identity of
the program that detected the error.  Say {cmd:solve()} did have an error.
Then the traceback log would probably have read something like

	                   {err}*:  3200  conformability error
		     solve():     -  function returned error
	             mysub():     -  function returned error
	        myfunction():     -  function returned error
	             <istmt>:     -  function returned error{txt}

{p 4 4 2}
The above log says the problem was detected by {cmd:*} (the multiplication 
operator), and at that point, {cmd:solve()} would be suspect, because 
one must ask, why did {cmd:solve()} use the multiplication operator 
incorrectly?

{p 4 4 2}
In any case, let's assume that the problem is not with {cmd:solve()}.  Then
you would guess the problem lies with {cmd:mysub}.  If you have used
{cmd:mysub()} in many previous programs without problems, however, you
might now shift your suspicion to {cmd:myfunction()}.  If {cmd:myfunction()}
is always trustworthy, perhaps you should not have typed
{cmd:myfunction(2,3)}.  That is, perhaps you are using {cmd:myfunction()}
incorrectly.


{marker error}{...}
{title:The error codes}

{p 4 10 2}
3000. (message varies){break}
    There is an error in what you have typed.  Mata cannot interpret what you
    mean.

{p 4 10 2}
3001. incorrect number of arguments{break}
    The function expected, say, three arguments and received two, or five.
    Or the function allows between three and five arguments, but you supplied
    too many or too few.  Fix the calling program.

{p 4 10 2}
3002. identical arguments not allowed{break}
    You have called a function specifying the same variable more than once.
    Usually this would not be a problem, but here, it is, usually
    because the supplied arguments are matrices that the function wishes 
    to overwrite with different results.  For instance, say function 
    {it:f}{cmd:(}{it:A}{cmd:,} {it:B}{cmd:,} {it:C}{cmd:)}
    examines matrix {it:A} and returns a calculation based on {it:A} 
    in {it:B} and {it:C}.  The function might well complain that
    you specified the same matrix for {it:B} and {it:C}.

{p 4 10 2}
3010. attempt to dereference NULL pointer{break}
    The program made reference to {cmd:*}{it:s}, and {it:s} contains NULL;
    see {bf:{help m2_pointers:[M-2] pointers}}.

{p 4 10 2}
3011. invalid lval{break}
    In an assignment, what appears on the left-hand side of the equals 
    is not something to which a value can be assigned; 
    see {bf:{help m2_op_assignment:[M-2] op_assignment}}.

{p 4 10 2}
3012. undefined operation on pointer{break}
    You have, for instance, attempted to add two pointers;
    see {bf:{help m2_pointers:[M-2] pointers}}.

{p 4 10 2}
3020. class child/parent compiled at different times{break}
    One class is being used to extend another class, and the parent
    has been updated since the class was compiled.

{p 4 10 2}
3021. class compiled at different times{break}
    A function using a predefined class has not been recompiled
    since the class has last been changed.

{p 4 10 2}
3022. function not supported on this platform{break}
     You have tried to use a function that is defined for some operating
     system or flavor supported by Stata but not for the one you are currently
     using.  For example, you may have tried to use a Mac-only function in
     Stata for Windows.

{p 4 10 2}
3101. matrix found where function required{break}
    A particular argument to a function is required to be a 
    function, and a matrix was found instead.

{p 4 10 2}
3102. function found where matrix required{break}
    A particular argument to a function is required to be a 
    matrix, vector, or scalar, and a function was found instead.

{p 4 10 2}
3103. view found where array required{break}
    In general, view matrices can be used wherever a matrix is required, 
    but there are a few exceptions, both in low-level routines and 
    in routines that wish to write results back to the argument.  
    Here a view is not acceptable.  If {it:V} is the view 
    variable, simply code {it:X} {cmd:=} {it:V} and then pass {it:X}
    in its stead.  See {bf:{help mf_st_view:[M-5] st_view()}}.

{p 4 10 2}
3104. array found where view required{break}
    A function argument was specified with a matrix that was not a view, 
    and a view was required.  
    See {bf:{help mf_st_view:[M-5] st_view()}}.

{p 4 10 2}
3200. conformability error{break}
    A matrix, vector, or scalar has the wrong number of rows and/or columns
    for what is required.  Adding a 2 {it:x} 3 matrix to a 1 {it:x} 4
    would result in this error.

{p 4 10 2}
3201. vector required{break}
    An argument is required to be {it:r x} 1 or 1 {it:x c}, and a matrix
    was found instead.

{p 4 10 2}
3202. rowvector required{break}
    An argument is required to be 1 {it:x c} and it is not.

{p 4 10 2}
3203. colvector required{break}
    An argument is required to be {it:r x} 1 and it is not.

{p 4 10 2}
3204. matrix found where scalar required{break}
    An argument is required to be 1 {it:x} 1 and it is not.

{p 4 10 2}
3205. square matrix required{break}
    An argument is required to be {it:n x n} and it is not.

{p 4 10 2}
3206. invalid use of view containing op.vars{break}
    Factor variables have been used in a view, and the view is
    now being used in a context that does not support the use of
    factor variables.

{p 4 10 2}
3208. more than 2 billion rows or columns (LAPACK){break}
    A call was made to a {helpb m1_LAPACK:LAPACK()} function with a matrix
    containing more than 2^{31} - 1 rows or columns.  The LAPACK functions used
    by Mata cannot accept matrices larger than this.

{p 4 10 2}
3209. more than 281 terarows or teracolumns{break}
    A call was made to a function with a matrix containing more than
    2^{48} - 1 rows or columns.  This is not allowed.

{p 4 10 2}
3211.  view frame not found{break}
       The referenced view is linked to a frame that no longer exists.

{p 4 10 2}
3212.  view vars & obs out of range{break}
       An attempt was made to access a view using both a variable number and an
       observation number that are out of range.

{p 4 10 2}
3213.  view vars out of range{break}
       An attempt was made to access a view using a variable number out of range.

{p 4 10 2}
3214.  view obs out of range{break}
       An attempt was made to access a view using an observation number out
       of range.

{p 4 10 2}
3250. type mismatch{break}
    The {it:eltype} of an argument does not match what is required.
    For instance, perhaps a real was expected and a string was received.
    See {it:{help m6_glossary##type:eltype}} in
    {bf:{help m6_glossary:[M-6] Glossary}}.

{p 4 10 2}
3251.  nonnumeric found where numeric required{break}
    An argument was expected to be real or complex and it is not.

{p 4 10 2}
3252. noncomplex found where complex required{break}
    An argument was expected to be complex and it is not.

{p 4 10 2}
3253. nonreal found where real required{break}
    An argument was expected to be real and it is not.

{p 4 10 2}
3254. nonstring found where string required{break}
    An argument was expected to be string and it is not.

{p 4 10 2}
3255. real or string required{break}
    An argument was expected to be real or string and it is not.

{p 4 10 2}
3256. numeric or string required{break}
    An argument was expected to be real, complex, or string and it is not.

{p 4 10 2}
3257. nonpointer found where pointer required{break}
    An argument was expected to be a pointer and it is not.

{p 4 10 2}
3258. nonvoid found where void required{break}
    An argument was expected to be void and it is not.

{p 4 10 2}
3259. nonstruct found where struct required{break}
    A variable that is not a structure was passed to a function
    that expected the variable to be a structure.

{p 4 10 2}
3260. nonclass found where class required{break}
    A variable that is not a class was passed to a function
    that expected the variable to be a class.

{p 4 10 2}
3261. non class/struct found where class/struct required{break}
    A variable that is not a class or a structure was passed to a function
    that expected the variable to be a class or a structure.

{p 4 10 2}
3300. argument out of range{break}
    The {it:eltype} and {it:orgtype} of the argument are correct, but
    the argument contains an invalid value, such as if you had asked for the
    20th row of a 4 {it:x} 5 matrix.
    See {help m6_glossary##type:{it:eltype} and {it:orgtype}} in
    {bf:{help m6_glossary:[M-6] Glossary}}.

{p 4 10 2}
3301. subscript invalid{break}
    The subscript is out of range (refers to a row or column that does not
    exist) or contains the wrong number of elements.
    See {bf:{help m2_subscripts:[M-2] Subscripts}}.

{p 4 10 2}
3302. invalid %fmt{break}
    The %fmt for formatting data is invalid.  See
    {bf:{help mf_printf:[M-5] printf()}} and see
    {findalias frformats}.

{p 4 10 2}
3303. invalid permutation vector{break}
    The vector specified does not meet the requirements of a permutation 
    vector, namely, that an {it:n}-element vector contain a permutation 
    of the integers 1 through {it:n}.  
    See {bf:{help m1_permutation:[M-1] Permutation}}.

{p 4 10 2}
3304. struct nested too deeply{break}
    Structures may contain structures that contain structures, and so
    on, but only to a depth of 500.

{p 4 10 2}
3305. class nested too deeply{break}
    Classes may contain classes that contain classes, and so
    on, but only to a depth of 500.

{p 4 10 2}
3351. argument has missing values{break}
    In general, Mata is tolerant of missing values, but there are exceptions.
    This function does not allow the matrix, vector, or scalar to have 
    missing values.

{p 4 10 2}
3352. singular matrix{break}
    The matrix is singular and the requested result cannot be carried out.
    If singular matrices are a possibility, then you are probably using 
    the wrong function.

{p 4 10 2}
3353. matrix not positive definite{break}
    The matrix is non-positive definite and the requested results cannot be
    computed.  If non-positive-definite matrices are a possibility, then you
    are probably using the wrong function.

{p 4 10 2}
3360. failure to converge{break}
    The function that issued this message used an algorithm that the 
    function expected would converge but did not, probably because 
    the input matrix was extreme in some way.

{p 4 10 2}
3492. resulting string too long{break}
    A string that the function was attempting to produce became too long.
    Because the maximum length of strings in Mata is 
    2,147,483,647 characters, it is unlikely that Mata imposed the limit.
    Review the documentation on the function for the source of the limit
    that was imposed (for example, perhaps a string was being produced for use 
    by Stata).  In any case, this error does not arise because of 
    an out-of-memory situation.  It arises because some limit was 
    imposed.

{p 4 10 2}
3498. (message varies){break}
    An error specific to this function arose.  The text of the message 
    should describe the problem.

{p 4 10 2}
3499. ____ not found{break}
    The specified variable or function could not be found.  
    For a function, it was not already loaded, it is not in the
    libraries, and there is no {cmd:.mo} file with its name.

{p 4 10 2}
3500. invalid Stata variable name{break}
      A variable name -- which name is contained in a Mata string
      variable -- is not appropriate for use with Stata.


{p 4 10 2}
3598. Stata returned error{break}
    You are using a Stata interface function and have asked Stata to 
    perform a task.  Stata could not or refused.

{p 4 10 2}
3601. invalid file handle{break}
    The number specified does not correspond to an open file handle; 
    see {bf:{help mf_fopen:[M-5] fopen()}}.

{p 4 10 2}
3602. invalid filename{break}
    The filename specified is invalid.

{p 4 10 2}
3603. invalid file mode{break}
    The file mode (whether read, write, read-write, etc.) specified is
    invalid; 
    see {bf:{help mf_fopen:[M-5] fopen()}}.

{p 4 10 2}
3610. file from more recent version of Stata{break}
        An attempt was made to read a file created by a newer version of
        Stata than you are currently using.  The file is in a format
        that your version of Stata does not understand.

{p 4 10 2}
3611. too many open files{break}
    The maximum number of files that may be open simultaneously 
    is 50, although your operating system may not allow that many.

{p 4 10 2}
3621. attempt to write read-only file{break}
    The file was opened read-only and an attempt was made to write into it.

{p 4 10 2}
3622. attempt to read write-only file{break}
    The file was opened write-only and an attempt was made to read it.

{p 4 10 2}
3623. attempt to seek append-only file{break}
    The file was opened append-only and then an attempt was made to seek
    into the file; 
    see {bf:{help mf_fopen:[M-5] fopen()}}.

{p 4 10 2}
3698. file seek error{break}
    An attempt was made to seek to an invalid part of the file, or the 
    seek failed for other reasons; 
    see {bf:{help mf_fopen:[M-5] fopen()}}.

{p 4 10 2}
3900. out of memory{break}
    Mata is out of memory; the operating system refused to supply what 
    Mata requested.  There is no Mata or Stata setting that affects this, 
    and so nothing in Mata or Stata to reset in order to get more memory.
    You must take up the problem with your operating system.

{p 4 10 2}
3901. macro memory in use{break}
    This error message should not occur; please notify StataCorp if it does.

{p 4 10 2}
3930. error in LAPACK routine{break}
    The linear-algebra LAPACK routines -- see 
    {bf:{help m1_lapack:[M-1] LAPACK}} -- generated an error that Mata did 
    not expect.  Please notify StataCorp if you should receive this error.

{p 4 10 2}
3995. unallocated function{break}
    This error message should not occur; please notify StataCorp if it does.

{p 4 10 2}
3996. built-in unallocated{break}
    This error message should not occur; please notify StataCorp if it does.

{p 4 10 2}
3997. unimplemented opcode{break}
    This error message should not occur; please notify StataCorp if it does.

{p 4 10 2}
3998. stack overflow{break}
    Your program nested too deeply.  For instance, imagine calculating 
    the factorial of {it:n} by recursively calling yourself and then 
    requesting the factorial of 1e+100.  Functions that call themselves 
    in an infinite loop inevitably cause this error.

{p 4 10 2}
3999. system assertion false{break}
    Something unexpected happened in the internal Mata code.
    Please contact Technical Services and report the problem.
    You do not need to exit Stata or Mata.  Mata stopped doing
    what was leading to a problem.
{p_end}
