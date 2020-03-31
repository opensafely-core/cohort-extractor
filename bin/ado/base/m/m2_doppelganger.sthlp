{smcl}
{* *! version 1.0.4  15may2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] Intro" "help m2_intro"}{...}
{viewerjumpto "Syntax" "m2_doppelganger##syntax"}{...}
{viewerjumpto "Description" "m2_doppelganger##description"}{...}
{viewerjumpto "Remarks" "m2_doppelganger##remarks"}{...}
{title:Title}

{phang}
{bf:[M-2] doppelganger} {hline 2} Ghostly library double of built-in function


{marker syntax}{...}
{title:Syntax}

	{{cmd:function} | {it:type}} {cmd:(doppelganger)} {...}
{it:functionname}{cmd:(}...{cmd:)}
	{cmd:{c -(}}
		....
	{cmd:{c )-}}


{marker description}{...}
{title:Description}

{p 4 4 2}
    Doppelgangers are used by StataCorp in maintaining compatibility 
    across releases.  They have no other use.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
    Assume you work for StataCorp and you have been assigned the task 
    of improving Mata function {bf:{help mf_sin:sinh()}}.  You 
    discover that {cmd:sinh()} is currently a library function, meaning the
    code for {cmd:sinh()} is itself written in Mata.  After careful
    consideration, you decide that you wish to move {cmd:sinh()} from the
    library to being a built-in function written in C.  If you do this, you
    also need to create a doppelganger of {cmd:sinh()}, for inclusion in the
    library, that reads

	{cmd}numeric matrix (doppelganger) sinh(Z) return(sinh(Z)){txt}

{p 4 4 2}
    You must do this so that once your change is released to Stata's 
    users, they do not have to recompile any existing Mata code they may 
    have written that uses the {cmd:sinh()} function.

{p 4 4 2}
    After you install the new built-in function {cmd:sinh()} into Mata, 
    the Mata compiler will code a link to your new built-in function  
    wherever the function is used in Mata code.  Previously, the compiler
    coded a {it:call} to the external function named "{cmd:sinh}".

{p 4 4 2}
    What Mata did previously is important because 
    Mata users who do not recompile their own Mata source code will still
    have a call to the external function named "{cmd:sinh}" in their old
    compiled code.  You might be tempted to leave the old {cmd:sinh()}
    code in the library to handle that contingency, but there are two problems
    with that:  1) Just because users have not recompiled, they still will
    want to get the benefit of your improvement and 2) Mata itself will not
    let you.  The next time someone at StataCorp attempts to recompile the
    library that contains the old {cmd:sinh()} code, Mata will issue an error
    saying that function {cmd:sinh()} is built in and thus a library function
    cannot be compiled with the same name.

{p 4 4 2}
    Directive {cmd:doppelganger} informs Mata that you want Mata to reverse 
    its check, that is, to verify that a built-in function of the same name 
    does indeed exist, and then go ahead and compile a function of the same 
    name.  In our example, the function reads 

	{cmd}numeric matrix (doppelganger) sinh(Z) return(sinh(Z)){txt}

{p 4 4 2}
    Thus the entire code for the doppelganger {cmd:sinh(Z)} 
    is {cmd:return(sinh(Z))}.  The {cmd:sinh()} in the code on the right 
    is interpreted as a link to the new built-in function you have written
    because a modern Mata can interpret it no other way.  
    Thus the statement means that, should a call to a library function 
    named "{cmd:sinh}" be executed, the result is to be execution of the 
    built-in {cmd:sinh()}.

{p 4 4 2}
    Because modern Matas cannot interpret an invocation of {cmd:sinh()} as 
    meaning anything other than executing the built-in {cmd:sinh()}, 
    no modern code will ever call the doppelganger {cmd:sinh()}.  
    The doppelganger will be invoked only by old code that has not 
    been recompiled.  As time passes, more and more code will be 
    recompiled by more modern Statas, and use of the doppelganger will 
    decrease and ultimately vanish.
{p_end}
