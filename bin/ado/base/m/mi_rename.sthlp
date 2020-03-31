{smcl}
{* *! version 1.0.14  15may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi rename" "mansection MI mirename"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{viewerjumpto "Syntax" "mi_rename##syntax"}{...}
{viewerjumpto "Menu" "mi_rename##menu"}{...}
{viewerjumpto "Description" "mi_rename##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_rename##linkspdf"}{...}
{viewerjumpto "Option" "mi_rename##option"}{...}
{viewerjumpto "Remarks" "mi_rename##remarks"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[MI] mi rename} {hline 2}}Rename variable{p_end}
{p2col:}({mansection MI mirename:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:mi} {cmdab:ren:ame} 
{it:oldname}
{it:newname}
[{cmd:,}
{cmdab:noup:date}]


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mi} {cmd:rename} renames variables.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI mirenameRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{p 4 8 2}
{cmd:noupdate}
    in some cases suppresses the automatic {cmd:mi} {cmd:update} this 
    command might perform; 
    see {bf:{help mi_noupdate_option:[MI] noupdate option}}.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mi_rename##noupdate:Specifying the noupdate option}
	{help mi_rename##accident:What to do if you accidentally use rename}
	{help mi_rename##wide:What to do if you accidentally use rename on wide data}
	{help mi_rename##mlong:What to do if you accidentally use rename on mlong data}
	{help mi_rename##flong:What to do if you accidentally use rename on flong data}
	{help mi_rename##flongsep:What to do if you accidentally use rename on flongsep data}


{marker noupdate}{...}
{title:Specifying the noupdate option}

{p 4 4 2}
If you are renaming more than one variable, you can speed execution with 
no loss of safety by specifying the {cmd:noupdate} option after the first
{cmd:mi rename}:

	. {cmd:mi rename ageyears age}

	. {cmd:mi rename timeinstudy studytime, noupdate}

	. {cmd:mi rename personid id, noupdate}

{p 4 4 2}
The above is generally good advice.  When giving one {cmd:mi} command 
after another, you may specify {cmd:noupdate} after the first command to 
speed execution.


{marker accident}{...}
{title:What to do if you accidentally use rename}

{p 4 4 2}
Assume that you just typed

	{cmd:. rename ageyears age}

{p 4 4 2}
rather than typing 

	{cmd:. mi rename ageyears age}

{p 4 4 2}
as you should have. 
No damage has been done yet, but if you give another {cmd:mi} command
and it runs {helpb mi update}, real damage will be done.  We will
discuss that and what to do about it in the sections that follow, 
but first, if you have given no additional {cmd:mi} 
commands, use {cmd:rename} (not {cmd:mi} {cmd:rename}) to rename the 
variable back to how it was:

	{cmd:. rename age ageyears}

{p 4 4 2}
Then use {cmd:mi} {cmd:rename} as you should have in the first place:

	{cmd:. mi rename ageyears age}

{p 4 4 2}
The sections below handle the case where {cmd:mi} {cmd:update} 
has run.  You will know that {cmd:mi update} has run because since the rename,
you gave some {cmd:mi} command -- perhaps even {cmd:mi} {cmd:update} itself --
and you saw a message like one of these:

	(variable {cmd:ageyears} dropped in {it:m}>0)

	(imputed variable {cmd:ageyears} unregistered because not in {it:m}=0)

	(passive variable {cmd:ageyears} unregistered because not in {it:m}=0)

	(regular variable {cmd:ageyears} unregistered because not in {it:m}=0)


{marker wide}{...}
{title:What to do if you accidentally use rename on wide data}

{p 4 4 2}
If {cmd:ageyears} was unregistered, no damage was done, and no additional
action needs to be taken.

{p 4 4 2}
If {cmd:ageyears} was registered as regular, no damage was done.  However,
your renamed variable is no longer registered.  
Reregister the variable under its new name
by typing {cmd:mi} {cmd:register} {cmd:regular} {cmd:age}; see
{manhelp mi_set MI:mi set}.

{p 4 4 2}
If {cmd:ageyears} was registered as imputed or passive, you just lost all
values for {it:m}>0.  Passive variables are usually not too difficult to
re-create; see {bf:{help mi_passive:[MI] mi passive}}.  If the variable was
imputed, well, hope that you will have saved your data recently when you make
this error and, before that, learn good computing habits.


{marker mlong}{...}
{title:What to do if you accidentally use rename on mlong data}

{p 4 4 2}
If {cmd:ageyears} was unregistered, no damage was done, and no additional
action needs to be taken.

{p 4 4 2}
If {cmd:ageyears} was registered as regular, no damage was done.  However, 
your renamed variable is no longer registered.  Reregister the variable
under its new name by typing {cmd:mi} {cmd:register} {cmd:regular} {cmd:age};
see {manhelp mi_set MI:mi set}.

{p 4 4 2}
If {cmd:ageyears} was registered as imputed or passive, you just lost all
values for {it:m}>0.  We offer the same advice as we offered when the data
were wide:  Passive variables are usually not too difficult to re-create -- see
{bf:{help mi_passive:[MI] mi passive}} -- and otherwise hope that you will
have saved your data recently when you make this error.  It is always a 
good idea to save your data periodically.


{marker flong}{...}
{title:What to do if you accidentally use rename on flong data}

{p 4 4 2}
The news is better in this case; no matter how your variables were 
registered, you have not lost data.

{p 4 4 2}
If {cmd:ageyears} was unregistered, no further action is required.

{p 4 4 2}
If {cmd:ageyears} was registered as regular, you need to reregister the
variable under its new name by typing {cmd:mi} {cmd:register} {cmd:regular}
{cmd:age};
see {manhelp mi_set MI:mi set}.

{p 4 4 2}
If {cmd:ageyears} was registered as passive or imputed, you need to
reregister the variable under its new name by typing {cmd:mi} {cmd:register}
{cmd:passive} {cmd:age} or {cmd:mi} {cmd:register} {cmd:imputed} {cmd:age}.


{marker flongsep}{...}
{title:What to do if you accidentally use rename on flongsep data}

{p 4 4 2}
The news is not as good in this case.

{p 4 4 2}
If {cmd:ageyears} was unregistered, no damage was done.  When {cmd:mi} 
{cmd:update} ran, it noticed that old variable {cmd:ageyears} no longer 
appeared in {it:m}>0 and that new variable {cmd:age} now appeared in 
{it:m}=0, so {cmd:mi} {cmd:update} dropped the first and added the second to
{it:m}>0, thus undoing any damage.  There is nothing more that needs to be 
done.

{p 4 4 2}
If {cmd:ageyears} was registered as regular, no damage was done, but you
need to reregister the variable by typing {cmd:mi} {cmd:register}
{cmd:regular} {cmd:age};
see {manhelp mi_set MI:mi set}.

{p 4 4 2}
If {cmd:ageyears} was registered as passive or imputed, you have lost 
the values in {it:m}>0.  Now would probably be a good time for us to 
mention how you should work with a copy of your flongsep data; 
see {bf:{help mi_copy:[MI] mi copy}}.
{p_end}
