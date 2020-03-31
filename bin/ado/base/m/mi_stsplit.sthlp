{smcl}
{* *! version 1.0.15  12apr2019}{...}
{viewerdialog mi "dialog mi"}{...}
{vieweralsosee "[MI] mi stsplit" "mansection MI mistsplit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] Intro" "help mi"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stsplit" "help stsplit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MI] mi xxxset" "help mi_xxxset"}{...}
{viewerjumpto "Syntax" "mi_stsplit##syntax"}{...}
{viewerjumpto "Menu" "mi_stsplit##menu"}{...}
{viewerjumpto "Description" "mi_stsplit##description"}{...}
{viewerjumpto "Links to PDF documentation" "mi_stsplit##linkspdf"}{...}
{viewerjumpto "Options" "mi_stsplit##options"}{...}
{viewerjumpto "Remarks" "mi_stsplit##remarks"}{...}
{viewerjumpto "Examples" "mi_stsplit##examples"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[MI] mi stsplit} {hline 2}}Stsplit and stjoin mi data{p_end}
{p2col:}({mansection MI mistsplit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
To split at designated times

{p 8 16 2}
{cmd:mi} {cmd:stsplit} {newvar} [{it:{help if}}]{cmd:,}
{c -(}{cmd:at(}{it:{help numlist}}{cmd:)} | {opt ev:ery(#)}{c )-}
[{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{p2coldent :* {cmd:at(}{it:{help numlist}}{cmd:)}}split at specified analysis
            times{p_end}
{p2coldent :* {cmdab:ev:ery(}{it:#}{cmd:)}}split when analysis time is a
            multiple of {it:#}{p_end}
{synopt :{cmdab:af:ter(}{it:spec}{cmd:)}}use time since {it:spec} instead of
analysis time for {cmd:at()} or {cmd:every()}{p_end}
{synopt :{cmd:trim}}exclude observations outside of range{p_end}
{synopt :{cmdab:noup:date}}see {bf:{help mi_noupdate_option:[MI] noupdate option}}{p_end}

{synopt : {cmdab:nopre:serve}}programmer's option{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:at()} or {cmd:every()} is required.{p_end}
{p 4 6 2}
{cmd:nopreserve} is not included in the dialog box.



{phang}
To split at failure times

{p 8 16 2}
{cmd:mi} {cmd:stsplit} [{it:{help if}}]{cmd:,} {cmd:at(}{opt f:ailures)}
[{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{p2coldent :* {cmd:at(failures)}}split at times of observed failures{p_end}
{synopt :{cmdab:st:rata(}{varlist}{cmd:)}}perform splitting by failures within
         stratum, strata defined by {it:varlist}{p_end}
{synopt :{cmdab:r:iskset(}{newvar}{cmd:)}}create risk-set ID variable{p_end}
{synopt :{cmdab:noup:date}}see {bf:{help mi_noupdate_option:[MI] noupdate option}}{p_end}

{synopt :{cmdab:nopre:serve}}programmer's option{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}* {cmd:at()} is required.{p_end}
{p 4 6 2}{cmd:nopreserve} is not included in the dialog box.


{phang}
To join episodes

{p 8 15 2}
{cmd:mi} {cmd:stjoin} [{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{cmdab:c:ensored(}{it:{help numlist}}{cmd:)}}values of failure that
         indicate no event{p_end}
{synopt :{cmdab:noup:date}}see {bf:{help mi_noupdate_option:[MI] noupdate option}}{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multiple imputation}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mi} {cmd:stsplit} and {cmd:mi} {cmd:stjoin} are 
{cmd:stsplit} and {cmd:stjoin} for {cmd:mi} data;
see {bf:{help stsplit:[ST] stsplit}}.
Except for the addition of the {cmd:noupdate} option, 
the syntax is identical.  Except for generalization across {it:m}, the 
results are identical.

{p 4 4 2}
Your {cmd:mi} data must be {cmd:stset} to use these commands.  If your 
data are not already {cmd:stset}, use 
{cmd:mi} {cmd:stset}
rather than the standard {cmd:stset};
see {bf:{help mi_xxxset:[MI] mi XXXset}}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MI mistsplitRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{p 4 8 2}
{cmd:noupdate}
    in some cases suppresses the automatic {cmd:mi} {cmd:update} this 
    command might perform; 
    see {bf:{help mi_noupdate_option:[MI] noupdate option}}.

{p 4 4 2}
See {bf:{help stsplit:[ST] stsplit}} for documentation on the remaining options.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
You should never use {cmd:stsplit}, {cmd:stjoin}, or any other heavyweight
data management command with {cmd:mi} data.  Instead, you should use their
{cmd:mi} counterparts, such as {cmd:mi stsplit}.  Heavyweight commands are
commands that make sweeping changes to the data rather than simply deleting
some observations, adding or dropping some variables, or changing some values
of existing variables.  {cmd:stsplit} and {cmd:stjoin} are examples of
heavyweight commands (see {manhelp stsplit ST}.
{p_end}


{marker examples}{...}
{title:Examples}

    {title:Examples of splitting data at designated times}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse midiet}{p_end}
{phang2}{cmd:. mi describe}

{pstd}Declare mi data to be survival-time data{p_end}
{phang2}{cmd:. mi stset dox, failure(fail) origin(time dob) enter(time doe) scale(365.25) id(id)}

{pstd}List some of the mi data for m = 1{p_end}
{phang2}{cmd:. mi xeq 1: list id dob doe dox fail _t0 _t if id == 1 | id == 34}

{pstd}Split data by age at designated times{p_end}
{phang2}{cmd:. mi stsplit ageband, at(40(10)70)}

{pstd}Split data by time-in-study{p_end}
{phang2}{cmd:. mi stsplit timeband, at(0(5)25) after(time=doe)}

{pstd}List some of the mi data for m = 1{p_end}
{phang2}{cmd:. mi xeq 1: list id _t0 _t ageband fail if id==1 | id==34}


    {title:Examples of splitting data at failure times}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse mdrugtrs25, clear}{p_end}
{phang2}{cmd:. mi describe}

{pstd}Generate an ID variable{p_end}
{phang2}{cmd:. mi xeq: generate id = _n}

{pstd} Declare data to be survival-time data{p_end}
{phang2}{cmd:. mi stset studytime, failure(died) id(id)}

{pstd}Split data at failure times, adding a risk-set identifier to each observation{p_end}
{phang2}{cmd:. mi stsplit, at(failures) riskset(RS)}


    {title:Example of joining episodes}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse midiet, clear}

{pstd}Declare data to be survival-time data{p_end}
{phang2}{cmd:. mi stset dox, failure(fail) origin(time dob) enter(time doe) scale(365.25) id(id)}

{pstd}Split data by age at designated times{p_end}
{phang2}{cmd:. mi stsplit ageband, at(40(10)70)}

{pstd}Drop the variable that stsplit created{p_end}
{phang2}{cmd:. drop ageband}{p_end}
{phang2}{cmd:. mi update}

{pstd}Join data that has been split{p_end}
{phang2}{cmd:. mi stjoin}{p_end}
