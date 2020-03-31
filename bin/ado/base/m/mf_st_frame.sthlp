{smcl}
{* *! version 1.0.2  14jun2019}{...}
{vieweralsosee "[M-5] st_frame*()" "mansection M-5 st_frame*()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] frames intro" "help frames intro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] st_store()" "help mf_st_store"}{...}
{vieweralsosee "[M-5] st_view()" "help mf_st_view"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Stata" "help m4_stata"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] putmata" "help putmata"}{...}
{viewerjumpto "Syntax" "mf_st_frame##syntax"}{...}
{viewerjumpto "Description" "mf_st_frame##description"}{...}
{viewerjumpto "Remarks" "mf_st_frame##remarks"}{...}
{viewerjumpto "Conformability" "mf_st_frame##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_frame##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_frame##source"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-5] st_frame*()} {hline 2}}Data frame manipulation 
{p_end}
{p2col:}({mansection M-5 st_frame*():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{col 8}{it:string scalar}{...}
{col 25}{cmd:st_framecurrent()}

{col 8}{it:string colvector}{...}
{col 25}{cmd:st_framedir()}

{col 8}{it:void}{...}
{col 25}{cmd:st_framecreate(}{...}
{it:fname}{cmd:)}
{col 8}{it:real scalar}{...}
{col 24}{cmd:_st_framecreate(}{...}
{it:fname}{cmd:,} {it:noisy}{cmd:)}

{col 8}{it:void}{...}
{col 25}{cmd:st_framecurrent(}{it:fname}{cmd:)}
{col 8}{it:real scalar}{...}
{col 24}{cmd:_st_framecurrent(}{...}
{it:fname}{cmd:,} {it:noisy}{cmd:)}

{col 8}{it:void}{...}
{col 25}{cmd:st_framerename(}{...}
{it:fname}{cmd:,} {it:newfname}{cmd:)}
{col 8}{it:real scalar}{...}
{col 24}{cmd:_st_framerename(}{...}
{it:fname}{cmd:,} {it:newfname}{cmd:,} {it:noisy}{cmd:)}

{col 8}{it:void}{...}
{col 25}{cmd:st_framedrop(}{...}
{it:fname}{cmd:)}
{col 8}{it:real scalar}{...}
{col 24}{cmd:_st_framedrop(}{...}
{it:fname}{cmd:,} {it:noisy}{cmd:)}

{col 8}{it:void}{...}
{col 25}{cmd:st_framedropabc()}

{col 8}{it:void}{...}
{col 25}{cmd:st_framereset()}

{col 8}{it:void}{...}
{col 25}{cmd:st_framecopy(}{it:fname_to}{cmd:,} {it:fname_from}{cmd:)}
{col 8}{it:real scalar}{...}
{col 24}{cmd:_st_framecopy(}{it:fname_to}{cmd:,} {it:fname_from}{...}
{cmd:,} {it:noisy}{cmd:)}

{col 8}{it:real scalar}{...}
{col 25}{cmd:st_frameexists(}{it:name}{cmd:)}

{pstd}
where

{pmore2}
{it:fname} is a {it:string scalar} containing a name of an existing frame.
{p_end}

{pmore2}
{it:newfname} is a {it:string scalar} containing a name that is not 
the name of an existing frame. 
{p_end}

{pmore2}
{it:name} is a {it:string scalar} containing a name, whether or not of 
an existing frame. 
{p_end}

{pmore2}
{it:noisy} is a {it:real scalar} containing 0 (error messages suppressed)
or any nonzero value (error messages shown).


{marker description}{...}
{title:Description}

{pstd}
{cmd:st_framecurrent()} returns the name of current (working) frame.

{pstd}
{cmd:st_framedir()} returns the names of all existing frames.

{pstd}
{cmd:st_framecreate()} makes a new frame without making it the current frame.

{pstd}
{cmd:st_framecurrent()} changes the identity of current (working) frame.

{pstd}
{cmd:st_framerename()} renames the existing frame, which can be the current
frame.

{pstd}
{cmd:st_framedrop()} drops or eliminates the frame that is not the current
frame.

{pstd}
{cmd:st_framedropabc()} drops or eliminates all frames except the current
frame.  {cmd:abc} stands for "all but current".

{pstd}
{cmd:st_framereset()} resets Stata or Mata to contain one empty frame named
{cmd:default}.

{pstd}
{cmd:st_framecopy()} copies or duplicates complete contents from one frame to
another, clearing the previous contents of the target frame if necessary.

{pstd}
{cmd:st_frameexists()} determines whether the frame named {it:name} exists.

{pstd}
{cmd:_st_framecreate()},
{cmd:_st_framecurrent()},
{cmd:_st_framerename()},
{cmd:_st_framedrop()}, and
{cmd:_st_framecopy()}
perform the same action as
{cmd:st_framecreate()},
{cmd:st_framecurrent()},
{cmd:st_framerename()},
{cmd:st_framedrop()}, and
{cmd:st_framecopy()}, respectively, except that they handle errors
differently. 
The functions without a leading underscore issue an error message,
display a traceback log, and abort execution when used incorrectly.
The functions with a leading underscore do not abort.  They return a 
nonzero value and execution continues.

{pstd}
For an overview of frames, see {helpb frames intro:[D] frames intro}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Stata allows more than one dataset to be stored in memory.  Each is
stored in a separate frame, which you name.  For an overview of
frames, see {helpb frames intro:[D] frames intro}.  The {cmd:st_frame*()}
functions let you create new frames, delete existing ones, and switch
the identity of the current or working frame from one frame to another.
Stata commands and Mata functions work on the current (working) frame.
Data from more than one frame may be accessed simultaneously by
creating {help mf_st_view:Mata views} onto those frames and using
them in expressions.

{pstd}
Notice that some of the {cmd:st_frame*()} commands are paired:

	       {it:void}  {cmd:st_framecreate(}...{cmd:)}
	{it:real scalar} {cmd:_st_framecreate(}...{cmd:,} {it:noisy}{cmd:)}

	       {it:void}  {cmd:st_framecurrent(}...{cmd:)}
	{it:real scalar} {cmd:_st_framecurrent(}...{cmd:,} {it:noisy}{cmd:)}

	       {it:void}  {cmd:st_framerename(}...{cmd:)}
	{it:real scalar} {cmd:_st_framerename(}...{cmd:,} {it:noisy}{cmd:)}

	       {it:void}  {cmd:st_framedrop(}...{cmd:)}
	{it:real scalar} {cmd:_st_framedrop(}...{cmd:,} {it:noisy}{cmd:)}

	       {it:void}  {cmd:st_framecopy(}...{cmd:)}
	{it:real scalar} {cmd:_st_framecopy(}...{cmd:,} {it:noisy}{cmd:)}

{pstd}
The paired functions do the same thing but handle errors differently.
The functions without a leading underscore issue an error message,
display a traceback log, and abort execution when used incorrectly.
For example,

        : {cmd:st_framecreate("default")}
        {err:frame name default already exists}
                {err:st_framecreate():   3598  Stata returned error}
                          {err:<istm>:      -  function returned error}
        {search r(3598):r(3598);}

{pstd}
The functions with a leading underscore do not abort.  They return a 
nonzero value and execution continues.  Consider the following function: 

        {cmd:void example()}
        {cmd:{c -(}}
		{cmd:rc = _st_framecreate("default", 1)}
                {cmd:printf("execution continues, rc = %f\n", rc)}
        {cmd:{c )-}}

{pstd}
Execution of it results in 

        : {cmd:example()}
        {err:frame name default already exists}
        {err:execution continues, rc = 110}

{pstd}
The error message appeared but execution continued, and the error
message appeared only because we coded {cmd:1} for {it:noisy} in the call to
{cmd:_st_framecreate()}:

		{cmd:rc = _st_framecreate("default", 1)}

{pstd}
Had we coded {cmd:0}, the error message would not have appeared, but
execution would still have continued, and we would still see the
execution-continues message, and {cmd:rc} would have still contained
110.

{pstd}
The 110 is an example of a Stata return code.  Stata return codes are 0
when the function runs without error.  The number 110 is the particular
code for already exists.  Something already existed, in this case, the
frame name.  If we had illustrated return codes using {cmd:_st_framedrop()}
and specified a frame name that did 
not exist, the return code would have been 111, meaning something does
not exist, that something being the frame name.

{pstd}
The underscore variants exist to allow you to write more elegant code
in which the output does not suggest to the user that your code has 
a bug when it was in fact used incorrectly by the user.
We could have written {cmd:example()} as

        {cmd:void example()}
        {cmd:{c -(}}
		{cmd:rc = _st_framecreate("default", 1)}
                {cmd:if (rc!=0) exit(rc)}
                {cmd:printf("execution continues, rc = %f\n", rc)}
        {cmd:{c )-}}

{pstd}
and then the output would have been

        : {cmd:example()}
        {err:frame name default already exists}
        {search r(110):r(110);}


{marker conformability}{...}
{title:Conformability}

{p 4 8 2}
All arguments to the {cmd:st_frame*()} and {cmd:_st_frame*()} functions
are 1 {it:x} 1.


{marker diagnostics}{...}
{title:Diagnostics}

{pstd}
{cmd:st_framecurrent()}, 
{cmd:st_framedir()}, 
{cmd:st_framedropabc()}, 
and
{cmd:st_frameexists()} always run successfully.
The other {cmd:st_frame*()} commands abort execution when errors occur.

{pstd}
The {cmd:_st_frame*()} commands never abort.  They return 0 or, when 
errors occur, the relevant nonzero Stata return code. 


{marker source}{...}
{title:Source code}

{pstd}
Functions are built in.
{p_end}
