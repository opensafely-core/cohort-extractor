{smcl}
{* *! version 1.0.10  15may2018}{...}
{vieweralsosee "[MI] noupdate option" "mansection MI noupdateoption"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi update" "help mi_update"}{...}
{viewerjumpto "Syntax" "mi_noupdate_option##syntax"}{...}
{viewerjumpto "Description" "mi_noupdate_option##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_noupdate_option##linkspdf"}{...}
{viewerjumpto "Option" "mi_noupdate_option##option"}{...}
{viewerjumpto "Remarks" "mi_noupdate_option##remarks"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[MI] noupdate option} {hline 2}}The noupdate option{p_end}
{p2col:}({mansection MI noupdateoption:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:mi} ... 
[{cmd:,}
...
{cmdab:noup:date}
...
]


{marker description}{...}
{title:Description}

{p 4 4 2}
Many {cmd:mi} commands allow the {cmd:noupdate} option.
This entry describes the purpose of that option.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI noupdateoptionRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{p 4 8 2}
{cmd:noupdate}
    specifies that the {cmd:mi} command in question need not perform an 
    {bf:{help mi_update:mi update}} because you are certain that 
    there are no inconsistencies that need fixing.
    {cmd:noupdate} is taken as a suggestion; 
    {cmd:mi} {cmd:update} will still be performed if the command 
    sees evidence that it needs to be.
    Not specifying the option does not mean that an {cmd:mi} {cmd:update} 
    will be performed.  


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Some {cmd:mi} commands perform modifications to the data, and those
modifications will go very poorly -- even to the point of corrupting your data
-- if certain assumptions about your data are not true.  Usually, those
assumptions are true, but to be safe, the commands check the assumptions.
They do this by calling {bf:{help mi_update:[MI] mi update}}.  {cmd:mi}
{cmd:update} checks the assumptions and, if they are not true, corrects
the data so that the assumptions are true.  {cmd:mi} {cmd:update} always
reports the data corrections it makes.

{p 4 4 2}
All of this reflects an abundance of caution, with the result that some
commands spend more time running {cmd:mi} {cmd:update} than they 
spend performing their intended task.

{p 4 4 2}
Commands that use {cmd:mi} {cmd:update} to verify assumptions have a
{cmd:noupdate} option.  When you specify that option, the command 
skips checking the assumptions, which is to say it skips calling {cmd:mi}
{cmd:update}.  More correctly, the command skips calling {cmd:mi} 
{cmd:update} if the command sees no obvious evidence that {cmd:mi}
{cmd:update} needs to be called.  

{p 4 4 2}
You can make commands run faster by specifying {cmd:noupdate}.  Should you?
Unless you are noticing poor performance, we would say no.  It is, however,
absolutely safe to specify {cmd:noupdate} if the only commands executed since
the last {cmd:mi} {cmd:update} are {cmd:mi} commands.  The following would be
perfectly safe:

	. {cmd:mi update}
	. {cmd:mi passive, noupdate: gen agesq = age*age}
	. {cmd:mi rename age age_at_admission, noupdate}
	. {cmd:mi ...}

{p 4 4 2}
The following would be safe, too:

	. {cmd:mi update}
	. {cmd:mi passive, noupdate: gen agesq = age*age}
        . {cmd:summarize agesq}
	. {cmd:mi rename age age_at_admission, noupdate}
	. {cmd:mi ...}

{p 4 4 2}
It would be safe because {cmd:summarize} is a reporting command that 
does not change the data; see {manhelp summarize R}.

{p 4 4 2}
The problem {cmd:mi} has is that it is not in control of 
your session and data. Between {cmd:mi} commands, {cmd:mi} does not know what
you have done to the data.  The following would not be recommended and has the
potential to go very poorly:

	. {cmd:mi update}
	. {cmd:mi passive, noupdate: gen agesq = age*age}
	. {cmd:drop if female}
	. {cmd:drop agesq}
	. {cmd:mi} ...{cmd:, noupdate}{col 45}{cmd://} {it:do not do this}

{p 4 4 2}
By the rules for using {cmd:mi}, you should perform an {cmd:mi} {cmd:update}
yourself after a {cmd:drop} command, or any other command that changes the 
data, but it usually does not matter whether you follow that rule because
{cmd:mi} will check eventually, when it matters.  That is, {cmd:mi} will check
if you do not specify the {cmd:noupdate} option.

{p 4 4 2}
The {cmd:noupdate} option is recommended for use by programmers in 
programs that code a sequence of {cmd:mi} commands.
{p_end}
