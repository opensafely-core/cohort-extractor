{smcl}
{* *! version 1.0.0  29mar2013}{...}
{findalias asfrabbrev}{...}
{title:Title}

{title:{findalias frabbrev}}

{pstd}
Stata allows abbreviations.  In this manual, we usually avoid abbreviating
commands, variable names, and options to ensure readability:

{phang2}
{cmd:. summarize myvar, detail}

{pstd}
Experienced Stata users, on the other hand, tend to abbreviate the
same command as

{phang2}
{cmd:. sum myv, d}

{pstd}
As a general rule, command, option, and variable names may be abbreviated to
the shortest string of characters that uniquely identifies them.

{pstd}
This rule is violated if the command or option does something that cannot
easily be undone;  the command must then be spelled out in its
entirety.

{pstd}
Also, a few common commands and options are allowed to have even shorter
abbreviations than the general rule would allow.

{pstd}
The general rule is applied, without exception, to variable names.


{title:{findalias frcmdabbrev}}

{pstd}
The shortest allowed abbreviation for a command or option can be determined by
looking at the command's syntax diagram.  This minimal abbreviation is shown
by underlining:

            {cmdab:reg:ress}
            {cmdab:ren:ame}
            {cmd:replace}
            {cmdab:rot:ate}
            {cmdab:ru:n}

{pstd}
If there is no underlining, no abbreviation is allowed.  For example,
{cmd:replace} may not be abbreviated, the underlying reason being that
{cmd:replace} changes the data.

{pstd}
{cmd:regress} can be abbreviated {cmd:reg}, {cmd:regr}, {cmd:regre}, or
{cmd:regres}, or it can be spelled out in its entirety.

{pstd}
Sometimes short abbreviations are also allowed.
Commands that begin with the letter "d" include {cmd:decode}, {cmd:describe},
{cmd:destring}, {cmd:dir}, {cmd:discard}, {cmd:display}, {cmd:do}, and
{cmd:drop}, which suggests that the shortest allowable abbreviation for
{cmd:describe} is {cmd:desc}.  However, because {cmd:describe} is such a
commonly used command, you may abbreviate it with the single letter {cmd:d}.
You may also abbreviate the {cmd:list} command with the single letter {cmd:l}.

{pstd}
The other exception to the general abbreviation rule is that commands that
alter or destroy data must be spelled out completely.  Two commands that begin
with the letter "d", {cmd:discard} and {cmd:drop}, are destructive in the
sense that, once you give one of these commands, there is no way to
undo the result. Therefore, both must be spelled out.

{pstd}
The final exceptions to the general rule are commands implemented as
ado-files.  Such commands may not be abbreviated.  Ado-file commands are
external, and their names correspond to the names of disk files.


{title:{findalias froptabbrev}}

{pstd}
Option abbreviation follows the same logic as command abbreviation:  you 
determine the minimum acceptable abbreviation by examining the command's 
syntax diagram.  The syntax diagram for {cmd:summarize} reads, in part,

{phang2}
{cmdab:su:mmarize} ..., {cmdab:d:etail} {cmdab:f:ormat}

{pstd}
The {cmd:detail} option may be abbreviated {cmd:d}, {cmd:de}, {cmd:det}, 
..., {cmd:detail}.  Similarly, option {cmd:format} may be abbreviated 
{cmd:f}, {cmd:fo}, ..., {cmd:format}.

{pstd}
The {cmd:clear} and {cmd:replace} options occur with many commands.  The
{cmd:clear} option indicates that even though completing this command will
result in the loss of all data in memory, and even though the data in memory
have changed since the data were last saved on disk, you want to continue.
{cmd:clear} must be spelled out, as in {cmd:use} {cmd:newdata,} {cmd:clear}.

{pstd}
The {cmd:replace} option indicates that it is okay to save over an existing
dataset.  If you type {cmd:save mydata} and the file {cmd:mydata.dta} already
exists, you will receive the message "{file mydata.dta already exists}", and
Stata will refuse to overwrite it.  To allow Stata to overwrite the
dataset, you would type {cmd:save} {cmd:mydata,} {cmd:replace}.  {cmd:replace}
may not be abbreviated.

    {bf:Technical note}

{pstd}
{cmd:replace} is a stronger modifier than {cmd:clear} and is one you should
think about before using.  With a mistaken {cmd:clear}, you can lose hours of
work, but with a mistaken {cmd:replace}, you can lose days of work.  


{title:{findalias frvarabbrev}}

{p 8 10 2}o Variable names may be abbreviated to the shortest string of
characters that uniquely identifies them given the data currently loaded in
memory.

{p 10 10 2}If your dataset contained four variables, {cmd:state},
{cmd:mrgrate}, {cmd:dvcrate}, and {cmd:dthrate}, you could refer to the variable {cmd:dvcrate} as
{cmd:dvcrat}, {cmd:dvcra}, {cmd:dvcr}, {cmd:dvc}, or {cmd:dv}.  You might type
{cmd:list} {cmd:dv} to list the data on {cmd:dvcrate}.  You could not refer
to the variable {cmd:dvcrate} as {cmd:d}, however, because that abbreviation
does not distinguish {cmd:dvcrate} from {cmd:dthrate}.  If you were to type
{cmd:list} {cmd:d}, Stata would respond with the message "ambiguous
abbreviation".  (If you wanted to refer to all variables that
started with the letter "d", you could type {cmd:list} {cmd:d*}; see
{findalias frvarlists}.)

{p 8 10 2}o The character {cmd:~} may be used to mean that "zero or more
characters go here".  For instance, {cmd:r~8} might refer to the variable
{cmd:rep78}, or {cmd:rep1978}, or {cmd:repair1978}, or just {cmd:r8}.  (The
{cmd:~} character is similar to the {cmd:*} character in
{findalias frvarlists}, except that it adds the restriction "and only one
variable matches this specification".)

{p 10 10 2}Above, we said that you could abbreviate variables.  You could type
{cmd:dvcr} to refer to {cmd:dvcrate}, but, if there were more than one
variable that started with the letters {cmd:dvcr}, you would receive an error.
Typing {cmd:dvcr} is the same as typing {cmd:dvcr~}.


{title:{findalias frabbrevprog}}

{pstd}
Stata has several useful commands and functions to assist programmers
with abbreviating and unabbreviating command names and variable
names. 

{synoptset 20}{...}
{synopthdr:Command/function}
{synoptline}
{synopt :{helpb unab}}expand and unabbreviate standard variable lists{p_end}
{synopt :{helpb tsunab}}expand and unabbreviate variable lists
       that may contain time-series operators{p_end}
{synopt :{helpb fvunab}}expand and unabbreviate variable lists that
       may contain time-series operators or factor variables{p_end}

{synopt :{helpb unabcmd}}unabbreviate command name{p_end}

{synopt :{helpb novarabbrev}}xturn off variable abbreviation{p_end}
{synopt :{helpb varabbrev}}turn on variable abbreviation{p_end}
{synopt :{helpb set varabbrev}}set whether variable abbreviations are
supported{p_end}

{synopt :{helpb abbrev():abbrev({it:s},{it:n})}}string function that
      abbreviates {it:s} to {it:n} characters{p_end}
{synopt :{helpb mf_abbrev:abbrev({it:s},{it:n})}}Mata variant of above that
	allows {it:s} and {it:n} to be matrices{p_end}
{synoptline}
{p2colreset}{...}
