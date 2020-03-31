{smcl}
{* *! version 1.2.3  15oct2018}{...}
{viewerdialog stsplit "dialog stsplit"}{...}
{viewerdialog stjoin "dialog stjoin"}{...}
{vieweralsosee "[ST] stsplit" "mansection ST stsplit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stset" "help stset"}{...}
{viewerjumpto "Syntax" "stsplit##syntax"}{...}
{viewerjumpto "Menu" "stsplit##menu"}{...}
{viewerjumpto "Description" "stsplit##description"}{...}
{viewerjumpto "Links to PDF documentation" "stsplit##linkspdf"}{...}
{viewerjumpto "Options for stsplit" "stsplit##options_stsplit"}{...}
{viewerjumpto "Options for stjoin" "stsplit##options_stjoin"}{...}
{viewerjumpto "Examples" "stsplit##examples"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[ST] stsplit} {hline 2}}Split and join time-span records{p_end}
{p2col:}({mansection ST stsplit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Split at designated times

{p 8 16 2}{cmd:stsplit} {newvar} [{it:{help if}}]{cmd:,} 
{c -(}{cmd:at(}{it:{help numlist}}{cmd:)} | {opt ev:ery(#)}{c )-}
[{it:{help stsplit##stsplitDT_options:stsplitDT_options}}]


{phang}
Split at failure times

{p 8 16 2}{cmd:stsplit} [{it:{help if}}]{cmd:,} {cmd:at(}{opt f:ailures)} 
[{it:{help stsplit##stsplitFT_options:stsplitFT_options}}]


{phang}
Join episodes

{p 8 15 2}{cmd:stjoin} [{cmd:,} {opth c:ensored(numlist)}]


{synoptset 18 tabbed}{...}
{marker stsplitDT_options}{...}
{synopthdr :stsplitDT_options}
{synoptline}
{syntab :Main}
{p2coldent :* {opth at(numlist)}}split records at specified analysis times{p_end}
{p2coldent :* {opt ev:ery(#)}}split records when analysis time is a multiple of {it:#}{p_end}
{synopt :{opt af:ter(spec)}}use time since {it:spec} for {opt at()} or {opt every()} rather than time since onset of risk{p_end}
{synopt :{opt trim}}exclude observations outside of range{p_end}

{synopt :{opt nopre:serve}}do not save original data; programmer's option{p_end}
{synoptline}
{p2colreset}{...}
{pstd}
* Either {opt at(numlist)} or {opt every(#)} is required with {cmd:stsplit} at designated times.


{synoptset 18 tabbed}{...}
{marker stsplitFT_options}{...}
{synopthdr :stsplitFT_options}
{synoptline}
{syntab :Main}
{p2coldent :* {cmd:at(}{cmdab:f:ailures)}}split at observed failure times{p_end}
{synopt :{opth st:rata(varlist)}}restrict splitting to failures within stratum defined by {it:varlist}{p_end}
{synopt :{opth r:iskset(newvar)}}create a risk-set ID variable named {it:newvar}{p_end}

{synopt :{opt nopre:serve}}do not save original data; programmer's option{p_end}
{synoptline}
{p2colreset}{...}
{pstd}
* {cmd:at(failures)} is required with {cmd:stsplit} at failure times.

{p 4 6 2}
You must {cmd:stset} your dataset by using the {opt id()} option before using
{cmd:stsplit} or {cmd:stjoin}; see {manhelp stset ST}.{p_end}
{p 4 6 2}
{opt nopreserve} does not appear in the dialog box.{p_end}


{marker menu}{...}
{title:Menu}

    {title:stsplit}

{phang2}
{bf:Statistics > Survival analysis > Setup and utilities >}
    {bf:Split time-span records}

    {title:stjoin}

{phang2}
{bf:Statistics > Survival analysis > Setup and utilities >}
     {bf:Join time-span records}


{marker description}{...}
{title:Description}

{pstd}
{cmd:stsplit} with the {opth at(numlist)} or {opt every(#)} option splits
episodes into two or more episodes at the implied time points since being at
risk or after a time point specified by {opt after()}.  Each resulting record
contains the follow-up on one subject through one time band.  Expansion on
multiple time scales may be obtained by repeatedly using {cmd:stsplit}.
{newvar} specifies the name of the variable to be created containing the
observation's category.  The new variable records the interval to which each
new observation belongs and is bottom coded.

{pstd}
{cmd:stsplit, at(failures)} performs episode splitting at the failure times
(per stratum).

{pstd}
{cmd:stjoin} performs the reverse operation, namely, joining episodes back
together when such can be done without losing information.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ST stsplitQuickstart:Quick start}

        {mansection ST stsplitRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options_stsplit}{...}
{title:Options for stsplit}

{dlgtab:Main}

{phang}
{opth at(numlist)} or {opt every(#)} is required in syntax one;
{cmd:at(failures)} is required for syntax two.  These options specify the
analysis times at which the records are to be split.

{pmore}
{cmd:at(5(5)20)} splits records at t=5, t=10, t=15, and t=20.

{pmore}
If {cmd:at(}[{it:...}]{cmd:max)} is specified, {opt max} is replaced by a
suitably large value.  For instance, to split records every five analysis-time
units from time zero to the largest follow-up time in our data, we could find
out what the largest time value is by typing {cmd:summarize _t} and then
explicitly typing it into the {cmd:at()} option, or we could just specify
{cmd:at(0(5)max)}.

{pmore}
{opt every(#)} is a shorthand for {cmd:at(}{it:#}{cmd:(}{it:#}{cmd:)max)};
that is, episodes are split at each positive multiple of {it:#}.

{phang}
{opt after(spec)} specifies the reference time for {opt at()} or 
{opt every()}.  Syntax one can be thought of as corresponding to 
{cmd:after(}{it:time of onset of risk}{cmd:)}, although you cannot really type
this.  You could type, however, {cmd:after(time=birthdate)} or
{cmd:after(time=marrydate)} or {cmd:after(marrydate)}.

{pmore}
{it:spec} has syntax

{p 12 20 2}[{c -(}{cmd:time} | {cmd:t} | {cmd:_t}{c )-} {cmd:=}]
{c -(}{it:exp} | {opt min(exp)} | {opt asis(exp)}{c )-}

	where

{pmore}
{opt time} specifies that the expression be evaluated in the same
time units as {it:timevar} in {cmd:stset} {it:timevar}{cmd:,} {it:...}.  This
is the default.

{pmore}
{opt t} and {opt _t} specify that the expression be evaluated in
units of analysis time.  {opt t} and {opt _t} are synonyms; it makes no
difference whether you specify one or the other.

{pmore}
{it:exp} specifies the reference time.  For multiepisode data,
{it:exp} should be constant within subject ID.

{pmore}
{opt min(exp)} specifies that for multiepisode data, the minimum
of {it:exp} be taken within ID.

{pmore}
{opt asis(exp)} specifies that for multiepisode data, {it:exp} be
allowed to vary within id.

{phang}
{cmd:trim} specifies that observations with values less than the minimum or
greater than the maximum value listed in {opt at()} be excluded from
subsequent analysis.  Such observations are not dropped from the data; 
{opt trim} merely sets their value of variable {hi:_st} to 0 so they will not
be used, yet they can still be retrieved the next time the dataset is
{cmd:stset}.

{phang}
{opth strata(varlist)} specifies up to five strata variables.  Observations
with equal values of the variables are assumed to be in the same stratum.
{opt strata()} restricts episode splitting to failures that occur within the
stratum, and memory requirements are reduced when strata are specified.

{phang}
{opth riskset(newvar)} specifies the name for a new variable recording the
unique risk set in which an episode occurs, and missing otherwise.

{pstd}
The following option is available with {cmd:stsplit} but is not shown in the
dialog box:

{phang}
{opt nopreserve} is intended for use by programmers.  It speeds the
transformation by not saving the original data, which can be restored should
things go wrong or if you press {hi:Break}.  Programmers often specify this
option when they have already preserved the original data.  {opt nopreserve}
does not affect the transformation.


{marker options_stjoin}{...}
{title:Option for stjoin}

{phang}
{opth censored(numlist)} specifies values of the failure variable,
{it:failvar}, from {cmd:stset} {it:...}{cmd:, failure(}{it:failvar}
{it:...}{cmd:)} that indicate "no event" (censoring).

{pmore}
If you are using {cmd:stjoin} to rejoin records after {cmd:stsplit},
you do not need to specify {opt censored()}.  Just do not forget to drop the
variable created by {cmd:stsplit} before typing {cmd:stjoin}.  See
{mansection ST stsplitRemarksandexamplesex4:example 4} in
{bind:{bf:[ST] stsplit}}.

{pmore}
Neither do you need to specify {opt censored()} if, when you {cmd:stset} your
dataset, you specified {opt failure(failvar)} and not
{cmd:failure(}{it:failvar=}{it:...}{cmd:)}.  Then {cmd:stjoin} knows
that {it:failvar} = 0 and {it:failvar} = . (missing) correspond to no event.
Two records can be joined if they are contiguous and record the same data and
the first record has {it:failvar} = 0 or {it:failvar} = ., meaning no event at
that time.

{pmore}
You may need to specify {opt censored()}, and you probably do if, when
you {cmd:stset} the dataset, you specified
{cmd:failure(}{it:failvar=}{it:...}{cmd:)}.  If {cmd:stjoin} is to join
records, it needs to know what events do not count and can be discarded.  If
the only such event is {it:failvar} = ., then you do not need to specify
{opt censored()}.


{marker examples}{...}
{title:Examples of splitting data at designated times}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse diet}

{pstd}Describe the dataset{p_end}
{phang2}{cmd:. describe}

{pstd}Declare data to be survival-time data{p_end}
{phang2}{cmd:. stset dox, failure(fail) origin(time dob) enter(time doe)}
           {cmd:scale(365.25) id(id)}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list id dob doe dox fail _t0 _t if id == 1 | id == 34}

{pstd}Split data by age at designated times{p_end}
{phang2}{cmd:. stsplit ageband, at(40(10)70)}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list id _t0 _t ageband fail height if id == 1 | id == 34}

{pstd}Split data by time-in-study, too{p_end}
{phang2}{cmd:. stsplit timeband, at(0(5)25) after(time=doe)}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list id _t0 _t ageband timeband if id == 1 | id == 34}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse stanford, clear}

{pstd}Create variables that preserve follow-up time such that time of
transplant is the same for all patients{p_end}
{phang2}{cmd:. generate enter = 320 - wait}{p_end}
{phang2}{cmd:. generate exit = 320 + stime}

{pstd}Declare data to be survival-time data{p_end}
{phang2}{cmd:. stset exit, enter(time enter) failure(died) id(id)}

{pstd}Split data at time of transplant{p_end}
{phang2}{cmd:. stsplit posttran, at(0,320)}{p_end}
    {hline}


{title:Examples of splitting data at failure times}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse ocancer, clear}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list in 1/6, sep(0)}

{pstd}Declare data to be survival-time data{p_end}
{phang2}{cmd:. stset time, failure(cens) id(patient)}

{pstd}Split data at failure times{p_end}
{phang2}{cmd:. stsplit, at(failures)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse cancer, clear}

{pstd}Generate an ID variable{p_end}
{phang2}{cmd:. generate id = _n}

{pstd}Declare data to be survival-time data{p_end}
{phang2}{cmd:. stset studytime, failure(died) id(id)}

{pstd}Split data at failure times, adding a risk set identifier to each
observation{p_end}
{phang2}{cmd:. stsplit, at(failures) riskset(RS)}{p_end}
    {hline}


{title:Example of joining episodes}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse diet, clear}

{pstd}Declare data to the survival-time data{p_end}
{phang2}{cmd:. stset dox, failure(fail) origin(time dob) enter(time doe)}
                {cmd:scale(365.25) id(id)}

{pstd}Split data by age at designated times{p_end}
{phang2}{cmd:. stsplit ageband, at(40(10)70)}

{pstd}Drop the variable that {cmd:stsplit} created{p_end}
{phang2}{cmd:. drop ageband}

{pstd}Join data that has been split{p_end}
{phang2}{cmd:. stjoin}

{pstd}Confirm that data matches {cmd:diet.dta}, except for variables created
by {cmd:stset}ting the data{p_end}
{phang2}{cmd:. cf _all using https://www.stata-press.com/data/r16/diet, all}
{p_end}
