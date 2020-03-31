{smcl}
{* *! version 1.0.10  15may2018}{...}
{vieweralsosee "[MI] mi XXXset" "mansection MI miXXXset"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{viewerjumpto "Syntax" "mi_xxxset##syntax"}{...}
{viewerjumpto "Description" "mi_xxxset##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_xxxset##linkspdf"}{...}
{viewerjumpto "Remarks" "mi_xxxset##remarks"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[MI] mi XXXset} {hline 2}}Declare mi data to be svy, st, ts, xt,
 etc.{p_end}
{p2col:}({mansection MI miXXXset:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{col 9}{...}
{cmd:mi} {cmd:fvset} ...{...}
{right:{it:see} {bf:{help fvset:[R] fvset}}        }

{col 9}{...}
{cmd:mi} {cmd:svyset} ...{...}
{right:{it:see} {bf:{help svyset:[SVY] svyset}}     }

{col 9}{...}
{cmd:mi} {cmd:stset} ...{...}
{right:{it:see} {bf:{help stset:[ST] stset}}       }
{col 9}{...}
{cmd:mi} {cmd:streset} ...
{col 9}{...}
{cmd:mi} {cmd:st} ...

{col 9}{...}
{cmd:mi} {cmd:tsset} ...{...}
{right:{it:see} {bf:{help tsset:[TS] tsset}}       }
{col 9}{...}
{cmd:mi} {cmd:xtset} ...{...}
{right:{it:see} {bf:{help xtset:[XT] xtset}}       }


{marker description}{...}
{title:Description}

{p 4 4 2}
Using some features of Stata requires setting your data.  The commands listed
above allow you to do that with {cmd:mi} data.  The {cmd:mi} variants have the
same syntax and work the same way as the original commands.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI miXXXsetRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
If you have set your data with any of the above commands before you {cmd:mi}
{cmd:set} them, there is no problem; the settings were automatically 
imported.  Once you {cmd:mi} {cmd:set} your data,
however, you will discover that Stata's other set commands no longer work.
For instance, here is the result of typing {cmd:stset} on an {cmd:mi}
{cmd:set} dataset:

	. {cmd:stset} ...
{p 8 12 2}
{err}no; data are {bf:mi set}{break}
Use {bf:mi stset} to set or query these data; 
{bf:mi stset} has the same syntax as
{bf:stset}.{txt}

{pmore2}
{err}Perhaps you did not type {bf:stset}.  Some commands call {bf:stset} to obtain
information about the settings.  In that case, that command is not appropriate
for running directly on {bf:mi} data.  Use {bf:mi extract} to select the data on which
you want to run the command, which is probably {it:m}=0.{txt}
{p_end}
	r(119);

{p 4 4 2}
Also, you might sometimes see an error like the
one above when you give a command that depends on the data being set
by one of Stata's other set commands.
In general, it is odd that you would be running such a command 
directly on {cmd:mi} data because what you will get will depend 
on the {cmd:mi} style of data.  Perhaps, however, you are using 
{cmd:mi} wide data, where the structure of the data more or less
corresponds to the structure of non-{cmd:mi}  data, or perhaps you 
have smartly specified the appropriate {cmd:if} statement to 
account for the {cmd:mi} style of data you are using.
In any case, the result might be

	. {it:some_other_command}
{p 8 12 2}
{err}no; data are {bf:mi set}{break}
Use {bf:mi XXXset} to set or query these data; 
{bf:mi XXXset} has the same syntax as
{bf:XXXset}.{txt}
{p_end}

{pmore2}
{err}
Perhaps you did not type {bf:stset}.  Some commands call {bf:stset} to obtain
information about the settings.  In that case, that command is not appropriate
for running directly on {bf:mi} data.  Use {bf:mi extract} to select the data on which
you want to run the command, which is probably {it:m}=0.{txt}
{p_end}
	r(119);

{p 4 4 2}
Substitute one of the set commands listed above for XXXset, and 
then understand what just happened.  You correctly used 
{cmd:mi} {cmd:XXXset} to set your data, you thought your data were 
set, yet when you tried to use a command that depended on the 
data being XXXset, you received this error.

{p 4 4 2}
If this happens to you, the solution is to use 
{bf:{help mi_extract:mi extract}} 
to obtain the data on which you want to run the command --
which is probably {it:m}=0, so you would type {cmd:mi} {cmd:extract} 
{cmd:0} -- and then run the command.
{p_end}
