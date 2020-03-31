{smcl}
{* *! version 1.0.4  14may2018}{...}
{vieweralsosee "[R] Error messages" "mansection R Errormessages"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] search" "help search"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[R] Error messages} {hline 2}}Error messages and return codes
{p_end}
{p2col:}({mansection R Errormessages:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{title:Description}

{pstd}
Whenever Stata detects that something is wrong -- that what you typed is
uninterpretable, that you are trying to do something you should not be trying
to do, or that you requested the impossible -- Stata responds by typing a
message describing the problem, together with a return code.  For
instance,

        {cmd:. lsit}
        {err:unrecognized command:  lsit}
        {search r(199):r(199);}

        {cmd:. list myvar}
        {err:variable myvar not found}
        {search r(111):r(111);}

        {cmd:. test a=b}
        {err:last estimates not found}
        {search r(301):r(301);}

{pstd}
In each case, the message is probably sufficient to guide you to a solution.
When we typed {cmd:lsit}, Stata responded with "{err:unrecognized command}".
We meant to type {cmd:list}.  When we typed {cmd:list} {cmd:myvar}, Stata
responded with "{err:variable myvar not found}".  There is no variable named
{cmd:myvar} in our data.  When we typed {cmd:test} {cmd:a=b}, Stata responded
with "{err:last estimates not found}".  {cmd:test} tests hypotheses about
previously fit models, and we have not yet fit a model.

{pstd}
The numbers in parentheses in the {cmd:r(199)}, {cmd:r(111)}, and {cmd:r(301)}
messages are called the return codes.  To find out more about these
messages, type {cmd:search} {cmd:rc} {it:#}, where {it:#} is the
number returned in the parentheses.

    {cmd}{...}
    . search rc 301

        [P] error messages . . . . . . . . . . . . . . . . . . Return code 301
            {bf:last estimates not found};{txt}
            You typed an estimation command, such as {bf:regress}, without
	    arguments or attempted to perform a {bf:test} or typed {bf:predict},
	    but there were no previous estimation results.

{pstd}
Programmers should see {manlink P error} for details on programming error
messages.
{p_end}
