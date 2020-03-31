{smcl}
{* *! version 1.0.12  15may2018}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi update" "mansection MI miupdate"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] noupdate option" "help mi_noupdate_option"}{...}
{viewerjumpto "Syntax" "mi_update##syntax"}{...}
{viewerjumpto "Menu" "mi_update##menu"}{...}
{viewerjumpto "Description" "mi_update##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_update##linkspdf"}{...}
{viewerjumpto "Remarks" "mi_update##remarks"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[MI] mi update} {hline 2}}Ensure that mi data are consistent
{p_end}
{p2col:}({mansection MI miupdate:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{cmd:mi update}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mi} {cmd:update} verifies that {cmd:mi} data are consistent.  If the data
are not consistent, {cmd:mi} {cmd:update} reports the inconsistencies and
makes the necessary changes to make the data consistent.

{p 4 4 2}
{cmd:mi} {cmd:update} can change the sort order of the data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI miupdateRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mi_update##purpose:Purpose of mi update}
	{help mi_update##actions:What mi update does}
	{help mi_update##auto:mi update is run automatically}


{marker purpose}{...}
{title:Purpose of mi update}

{p 4 4 2}
{cmd:mi} {cmd:update} allows you to 

{p 8 12 2}
o  change the values of existing variables, whether imputed, passive, 
    regular, or unregistered;

{p 8 12 2}
o  add or remove missing values from imputed variables (or from any 
    variables); 

{p 8 12 2}
o  drop variables;

{p 8 12 2}
o  create new variables;

{p 8 12 2}
o  drop observations; and

{p 8 12 2}
o  duplicate observations (but not add observations in other ways).

{p 4 4 2} 
You can make any of or all the above changes and then type 

	. {cmd:mi update}

{p 4 4 2}
and {cmd:mi} {cmd:update} will handle making whatever additional 
changes are required to keep the data consistent.
For instance, 

{* ------------------------------------------------- junk1.log ---}{...}
	. {cmd:drop if sex==1}
	(75 observations deleted)

	. {cmd:mi update}
	(375 {it:m}>0 obs. dropped due to dropped obs. in {it:m}=0)
{* ------------------------------------------------- junk1.log ---}{...}

{p 4 4 2}
In this example, we happen to have five imputations and are working with
flongsep data.  We dropped 75 observations in {it:m}=0, and that still left
5*75=375 observations to be dropped in {it:m}>0.

{p 4 4 2}
The messages {cmd:mi} {cmd:update} produces vary according to the style of the
data because the changes required to make the data consistent are 
determined by the style.  Had we been working with flong data, we might have
seen

{* ------------------------------------------------- junk2.log ---}{...}
	. {cmd:drop if sex==1}
	(450 observations deleted)

	. {cmd:mi update}
        (system variable _mi_id updated due to change in number of obs.)
{* ------------------------------------------------- junk2.log ---}{...}

{p 4 4 2}
With flong data in memory, when we dropped {cmd:if} {cmd:sex==1}, we dropped
all 75+5*75 = 450 observations, so no more observations needed to be dropped;
but here {cmd:mi} {cmd:update} needed to update one of its system
variables because of the change we made.

{p 4 4 2}
Had we been working with mlong data, we might have seen

{* ------------------------------------------------- junk4.log ---}{...}
	. {cmd:drop if sex==1}
	(90 observations deleted)

	. {cmd:mi update}
        (system variable _mi_id updated due to change in number of obs.)
{* ------------------------------------------------- junk4.log ---}{...}

{p 4 4 2}
The story here is very much like the story in the flong case.  In
mlong data, dropping {cmd:if} {cmd:sex==1} drops the 75 observations in
{it:m}=0 and also drops the incomplete observations among the 75 in {it:m}=1,
{it:m}=2, ..., {it:m}=5.  In this example, there are three such observations,
so a total of 75+5*3 = 90 were dropped, and because of the change, {cmd:mi}
{cmd:update} needed to update its system variable.

{p 4 4 2}
Had we been using wide data, we might have seen

{* ------------------------------------------------- junk3.log ---}{...}
	. {cmd:drop if sex==1}
	(75 observations deleted)
	
	. {cmd:mi update}
{* ------------------------------------------------- junk2.log ---}{...}

{p 4 4 2}
{cmd:mi} {cmd:update}'s silence indicates that {cmd:mi} {cmd:update} did
nothing, because after dropping observations in wide data, nothing more 
needs to be done.  We could have skipped typing {cmd:mi} {cmd:update},
but do not think that way because changing values, dropping variables,
creating new variables, dropping observations, or creating new observations
can have unanticipated consequences.  

{p 4 4 2}
For instance, in our data is variable {cmd:farmincome}, and it seems 
obvious that {cmd:farmincome} should be 0 if the person does not 
have a farm, so we type 

	. {cmd:replace farmincome = 0 if !farm}
	(15 real changes made)

{p 4 4 2}
After changing values, you should type {cmd:mi} {cmd:update} even if you 
do not suspect that it is necessary.  Here is what happens when we do that 
with these data:

	. {cmd:mi update}
        (12 {it:m}=0 obs. now marked as complete)

{p 4 4 2}
Typing {cmd:mi} {cmd:update} was indeed necessary!
We forgot that the {cmd:farmincome} variable was imputed, and it turns out that
the variable contained missing in 12 nonfarm observations; 
{cmd:mi} needed to deal with that.

{p 4 4 2}
Running {cmd:mi} {cmd:update} is so important that {cmd:mi} itself is 
constantly running it just in case you forget.
For instance, let's ``forget'' to type {cmd:mi} {cmd:update} and then 
convert our data to wide:

	. {cmd:replace farmincome = 0 if !farm}
	(15 real changes made)

	. {cmd:mi convert wide, clear}
        (12 {it:m}=0 obs. now marked as complete)

{p 4 4 2}
The parenthetical message was produced because {cmd:mi} {cmd:convert} 
ran {cmd:mi} {cmd:update} for us.  For more information on this, see 
{bf:{help mi_noupdate_option:[MI] noupdate option}}.
	

{marker actions}{...}
{title:What mi update does}

{p 5 9 2}
o  {cmd:mi} {cmd:update} checks whether you have changed {it:N}, 
    the number of observations in {it:m}=0, and resets {it:N} if 
    necessary.

{p 5 9 2}
o  {cmd:mi} {cmd:update} checks whether you have changed {it:M}, 
    the number of imputations, and adjusts the data 
    if necessary.

{p 5 9 2}
o  {cmd:mi} {cmd:update} checks whether you have added, dropped, registered,
    or unregistered any variables and takes the appropriate action.

{p 5 9 2}
o  {cmd:mi} {cmd:update} checks whether you have added or deleted 
    any observations.  If you have, it then checks whether you carried out 
    the operation consistently for {it:m}=0, {it:m}=1, ..., {it:m}={it:M}. 
    If you have not carried it out consistently, {cmd:mi update} carries it
    out consistently for you.

{p 5 9 2}
o  In the mlong, flong, and flongsep styles, {cmd:mi} {cmd:update}
    checks system variable {cmd:_mi_id}, which links observations
    across {it:m}, and reconstructs the variable if necessary.

{p 5 9 2}
o  {cmd:mi} {cmd:update} checks that the system variable {cmd:_mi_miss}, which
    marks the incomplete observations, is correct and, if not,
    updates it and makes any other changes required by the change.

{p 5 9 2}
o  {cmd:mi} {cmd:update} verifies that the values recorded in imputed variables
    in {it:m}>0 are equal to the values in {it:m}=0 when they are nonmissing
    and updates any that differ.

{p 5 9 2}
o  {cmd:mi} {cmd:update} verifies that the values recorded in passive variables
    in {it:m}>0 are equal to the values recorded in {it:m}=0's complete 
    observations and updates any that differ.

{p 5 9 2}
o  {cmd:mi} {cmd:update} verifies that the values recorded in regular variables
    in {it:m}>0 equal the values in {it:m}=0 and updates any that differ.

{p 4 9 2}
o  {cmd:mi} {cmd:update} adds any new variables in {it:m}=0 to {it:m}>0.

{p 4 9 2}
o  {cmd:mi} {cmd:update} drops any variables from {it:m}>0 that do not
     appear in {it:m}=0.


{marker auto}{...}
{title:mi update is run automatically}

{p 4 4 2}
As we mentioned before, running {cmd:mi} {cmd:update} is so important that 
many {cmd:mi} commands simply run it as a matter of course.
This is discussed in {bf:{help mi noupdate option:[MI] noupdate option}}.
In a nutshell, the {cmd:mi} commands that run {cmd:mi update} automatically
have a {cmd:noupdate} option, so you can identify them, and you can specify the
option to skip running the update and so speed execution, but only with the
adrenaline rush caused by a small amount of danger.

{p 4 4 2}
Whether you specify {cmd:noupdate} or not, we advise you to run {cmd:mi}
{cmd:update} periodically and to always run {cmd:mi} {cmd:update} after
dropping or adding variables or observations, or changing values.
{p_end}
