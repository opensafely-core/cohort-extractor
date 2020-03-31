{smcl}
{* *! version 1.1.17  19oct2017}{...}
{viewerdialog stset "dialog stset"}{...}
{vieweralsosee "[ST] stset" "mansection ST stset"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] snapspan" "help snapspan"}{...}
{vieweralsosee "[ST] stdescribe" "help stdescribe"}{...}
{viewerjumpto "Syntax" "stset##syntax"}{...}
{viewerjumpto "Menu" "stset##menu"}{...}
{viewerjumpto "Description" "stset##description"}{...}
{viewerjumpto "Links to PDF documentation" "stset##linkspdf"}{...}
{viewerjumpto "Options for use with stset and streset" "stset##options_stset"}{...}
{viewerjumpto "Options unique to streset" "stset##options_streset"}{...}
{viewerjumpto "Options for use with st" "stset##options_st"}{...}
{viewerjumpto "Examples" "stset##examples"}{...}
{viewerjumpto "Video example" "stset##video"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[ST] stset} {hline 2}}Declare data to be survival-time data{p_end}
{p2col:}({mansection ST stset:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}Single-record-per-subject survival data

{p 8 16 2}
{cmd:stset} {it:timevar} [{it:{help if}}]
[{it:{help stset##weight:weight}}]
[{cmd:,} {it:{help stset##single_options:single_options}}]

{p 8 16 2}
{cmd:streset} [{it:{help if}}]
[{it:{help stset##weight:weight}}]
[{cmd:,} {it:{help stset##single_options:single_options}}]

{p 8 16 2}
{cmd:st} [{cmd:,} {opt noc:md} {opt not:able}]

{p 8 16 2}
{cmd:stset, clear}


{phang}Multiple-record-per-subject survival data

{p 8 16 2}
{cmd:stset} {it:timevar} [{it:{help if}}]
[{it:{help stset##weight:weight}}]
{cmd:,}
        {opth id:(varname:idvar)}
        {cmdab:f:ailure(}{it:failvar}[{cmd:==}{it:{help numlist}}]{cmd:)} 
        [{it:{help stset##multiple_options:multiple_options}}]

{p 8 16 2}
{cmd:streset} [{it:{help if}}]
[{it:{help stset##weight:weight}}]
[{cmd:,} 
        {it:{help stset##multiple_options:multiple_options}}]

{p 8 16 2}
{cmd:streset,} {{opt p:ast}|{opt f:uture}|{opt p:ast} {opt f:uture}} 

{p 8 16 2}
{cmd:st} [{cmd:,} {opt noc:md} {opt not:able}]

{p 8 16 2}
{cmd:stset, clear}


{synoptset 30 tabbed}{...}
{marker single_options}{...}
{synopthdr :single_options}
{synoptline}
{syntab :Main}
{synopt :{cmdab:f:ailure:(}{it:failvar}[{cmd:==}{it:{help numlist}}]{cmd:)}}failure event{p_end}
{synopt :{opt nos:how}}prevent other st commands from showing st setting information{p_end}

{syntab :Options}
{synopt :{cmdab:o:rigin(}{cmdab:t:ime} {it:{help exp}}{cmd:)}}define when a subject becomes at risk{p_end}
{synopt :{opt sc:ale(#)}}rescale time value{p_end}
{synopt :{cmdab:en:ter(}{cmdab:t:ime} {it:{help exp}}{cmd:)}}specify when subject first enters study{p_end}
{synopt :{cmdab:ex:it(}{cmdab:t:ime} {it:{help exp}}{cmd:)}}specify when subject exits study{p_end}

{syntab :Advanced}
{synopt :{opth if(exp)}}select records for which {it:exp} is true; recommended
rather than {cmd:if} {it:exp}{p_end}
{synopt :{opth time0(varname)}}mechanical aspect of interpretation about records in dataset; seldom used{p_end}
{synoptline}
{p2colreset}{...}


{synoptset 30 tabbed}{...}
{marker multiple_options}{...}
{synopthdr :multiple_options}
{synoptline}
{syntab :Main}
{p2coldent :* {opth "id(varname:idvar)"}}multiple-record ID variable{p_end}
{p2coldent :* {cmdab:f:ailure:(}{it:failvar}[{cmd:==} {it:{help numlist}}]{cmd:)}}failure event{p_end}
{synopt :{opt nos:how}}prevent other st commands from showing st setting information{p_end}

{syntab :Options}
{p2col 7 35 37 2:{cmdab:o:rigin(}[{varname} {cmd:==} {it:{help numlist}}] {opt t:ime} {it:{help exp}}|{cmd:min)}}{break}define when a subject becomes at risk{p_end}
{synopt :{opt sc:ale(#)}}rescale time value{p_end}
{p2col 7 35 37 2:{cmdab:en:ter(}[{varname} {cmd:==} {it:{help numlist}}] {cmdab:t:ime} {it:{help exp}}{cmd:)}}{break}specify when subject first enters study{p_end}
{p2col 7 35 37 2:{cmdab:ex:it(failure}|[{varname} {cmd:==} {it:{help numlist}}] {cmdab:t:ime} {it:{help exp}}{cmd:)}}{break}specify when subject exits study{p_end}

{syntab :Advanced}
{synopt :{opth if(exp)}}select records for which {it:exp} is true; recommended
rather than {cmd:if} {it:exp}{p_end}
{synopt :{opth ever(exp)}}select subjects for which {it:exp} is ever true{p_end}
{synopt :{opth never(exp)}}select subjects for which {it:exp} is never true{p_end}
{synopt :{opth after(exp)}}select records within subject on or after the first time {it:exp} is true{p_end}
{synopt :{opth befor:e(exp)}}select records within subject before the first time {it:exp} is true{p_end}
{synopt :{opth time0(varname)}}mechanical aspect of interpretation about records in dataset; seldom used{p_end}
{synoptline}
{p2colreset}{...}
{phang}
* {opt id()} and {opt failure()} are required with {cmd:stset} multiple-record-per-subject survival data.

{marker weight}{...}
{phang}
{opt fweight}s, {opt iweight}s, and {opt pweight}s are allowed; see
{help weight}.


    {bf:Examples}

        Time measured from 0, all failed
           {cmd:. stset ftime}

        Time measured from 0, censoring
           {cmd:. stset ftime, failure(died)}

        Time measured from 0, censoring & ID
           {cmd:. stset ftime, failure(died) id(id)}
	       
        Time measured from 0, failure codes
           {cmd:. stset ftime, failure(died==2,3)}
	       
        Time measured from dob, censoring
           {cmd:. stset ftime, failure(died) origin(time dob)}

{pmore}
        You cannot harm your data by using {cmd:stset}, so feel free to
	experiment.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Survival analysis > Setup and utilities >}
       {bf:Declare data to be survival-time data}


{marker description}{...}
{title:Description}

{pstd}
st refers to survival-time data, which are fully described below.

{pstd}
{cmd:stset} declares the data in memory to be st data,
informing Stata of key variables and their roles in a survival-time analysis.
When you {cmd:stset} your data, {cmd:stset} runs various data consistency
checks to ensure that what you have declared makes sense.  If the
data are weighted, you specify the weights when you {cmd:stset} the data, not
when you issue the individual st commands.

{pstd}
{cmd:streset} changes how the st dataset is declared.  In multiple-record
data, {cmd:streset} can also temporarily set the sample to include records
from before the time at risk (called the past) and records after failure
(called the future).  Then typing {cmd:streset} without arguments
resets the sample back to the analysis sample.

{pstd}
{cmd:st} displays how the dataset is currently declared.

{pstd}
Whenever you type {cmd:stset} or {cmd:streset}, Stata runs or reruns data
consistency checks to ensure that what you are now declaring (or declared in
the past) makes sense.  Thus if you have made any changes to your data or
simply wish to verify how things are, you can type {cmd:streset} with no 
options.

{pstd}
{cmd:stset, clear} is for use by programmers.  It causes Stata to forget the
st markers, making the data no longer st data to Stata.  The data remain
unchanged.  It is not necessary to {cmd:stset, clear} before doing another
{cmd:stset}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ST stsetQuickstart:Quick start}

        {mansection ST stsetRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options_stset}{...}
{title:Options for use with stset and streset}

{dlgtab:Main}

{marker id()}{...}
{phang}
{opth id:(varname:idvar)} specifies the subject-ID variable; observations with
equal, nonmissing values of {it:idvar} are assumed to be the same subject.
{it:idvar} may be string or numeric.  Observations for which {it:idvar} is
missing (.  or "") are ignored.  

{pmore}
When {opt id()} is not specified, each observation is assumed to represent a
different subject and thus constitutes a one-record-per-subject survival
dataset.

{pmore}
When you specify {opt id()}, the data are said to be multiple-record data,
even if it turns out that there is only one record per subject.  Perhaps they
would better be called potentially multiple-record data.

{pmore}
If you specify {opt id()}, {cmd:stset} requires that you specify 
{opt failure()}.

{pmore}
Specifying {opt id()} never hurts; we recommend it because a few st commands,
such as {cmd:stsplit}, require an ID variable to have been specified when the
dataset was {cmd:stset}.

{phang}
{cmd:failure(}{it:failvar}[{cmd:==} {it:{help numlist}}]{cmd:)} specifies the
failure event.  

{pmore}
If {opt failure()} is not specified, all records are assumed to end in
failure.  This is allowed with single-record data only.

{pmore}
If {opt failure(failvar)} is specified, {it:failvar} is interpreted as an
indicator variable; 0 and missing mean censored, and all other values are
interpreted as representing failure.

{pmore}
If {cmd:failure(}{it:failvar} {cmd:==} {it:numlist}{cmd:)} is specified, records
with {it:failvar} taking on any of the values in {it:numlist} are assumed to
end in failure, and all other records are assumed to be censored.

{phang}
{cmd:noshow} prevents other st commands from showing the key st variables at
the top of their output.

{dlgtab:Options}

{phang}
{cmd:origin(}[{varname} {cmd:==} {it:{help numlist}}] {opt time}
    {it:{help exp}} |
{cmd:min)} and {opt scale(#)} define analysis time; that is, 
{opt origin()} defines when a subject becomes at risk.  Subjects become at risk
when time = {opt origin()}.  All analyses are performed in terms of time since
becoming at risk, called analysis time.

{pmore}
Let us use the terms {it:time} for how time is recorded in the data and {it:t}
for analysis time.  Analysis time {it:t} is defined

                         {it:time} - {cmd:origin()}
		     {it:t} = {hline 15}
		            {cmd:scale()}

{pmore}
{it:t} is time from origin in units of scale.

{pmore}
By default, {cmd:origin(time} {cmd:0)} and {cmd:scale(1)} are assumed, meaning
that {it:t} = {it:time}.  Then you must ensure that {it:time} in your data is
measured as time since becoming at risk.  Subjects are exposed at
{it:t} = {it:time} = 0 and later fail.  Observations with
{it:t} = {it:time} <= 0 are ignored because information before becoming at risk
is irrelevant.

{pmore}
{cmd:origin()} determines when the clock starts ticking.  {cmd:scale()} plays
no substantive role, but it can be handy for making {it:t} units more readable
(such as converting days to years).

{pmore}
{cmd:origin(time} {it:exp}{cmd:)} sets the origin to {it:exp}.  For
instance, if {it:time} were recorded as dates, such as 05jun1998, in your
data and variable {cmd:expdate} recorded the date when subjects were exposed,
you could specify {cmd:origin(time} {cmd:expdate)}.  If instead all subjects
were exposed on 12nov1997, you could specify {cmd:origin(time}
{cmd:mdy(11,12,1997))}.

{pmore}
{cmd:origin(time} {it:exp}{cmd:)} may be used with single- or
multiple-record data.

{pmore}
{cmd:origin(}{it:varname} {cmd:==} {it:numlist}{cmd:)} is for use with
multiple-record data; it specifies the origin indirectly.  If {it:time} were
recorded as dates in your data, variable {cmd:obsdate} recorded the (ending)
date associated with each record, and subjects became at risk upon, say, having
a certain operation -- and that operation were indicated by {cmd:code==217} --
then you could specify {cmd:origin(code==217)}.  {cmd:origin(code==217)} would
mean, for each subject, that the origin time is the earliest time at which
{cmd:code==217} is observed.  Records before that would be ignored (because
{it:t} < 0).  Subjects who never had {cmd:code==217} would be ignored entirely.

{pmore}
{cmd:origin(}{it:varname} {cmd:==} {it:numlist} {cmd:time} {it:exp}{cmd:)}
sets the origin to the later of the two times determined by
{it:varname}{cmd:==}{it:numlist} and {it:exp}.

{pmore}
     {cmd:origin(min)} sets origin to the earliest time observed, minus 1.
     This is an odd thing to do and is described in
     {mansection ST stsetRemarksandexamplesex10:example 10} in {bf:[ST] stset}.

{pmore}
     {cmd:origin()} is an important concept; see
     {mansection ST stsetRemarksandexamplesKeyconcepts:{it:Key concepts}},
     {mansection ST stsetRemarksandexamplesTwoconceptsoftime:{it:Two concepts of time}},
     and
     {mansection ST stsetRemarksandexamplesThesubstantivemeaningofanalysistime:{it:The substantive meaning of analysis time}}
     in {bf:[ST] stset}.

{pmore}
{cmd:scale()} makes results more readable.  If you have {it:time}
     recorded in days (such as Stata dates, which are really days since
     01jan1960), specifying {cmd:scale(365.25)} will cause results to be
     reported in years.

{phang}
{cmd:enter(}[{varname} {cmd:==} {it:{help numlist}}] {cmd:time}
   {it:{help exp}}{cmd:)}
specifies when a subject first comes under observation, meaning that any
failures, were they to occur, would be recorded in the data.

{pmore}
Do not confuse {cmd:enter()} and {cmd:origin()}.  {cmd:origin()} specifies when
a subject first becomes at risk.  In many datasets, becoming at risk and coming
under observation are coincident.  Then it is sufficient to specify
{cmd:origin()}.

{pmore}
{cmd:enter(time} {it:exp}{cmd:)},
{cmd:enter(}{it:varname} {cmd:==} {it:numlist}{cmd:)}, and
{cmd:enter(}{it:varname} {cmd:==} {it:numlist} {cmd:time} {it:exp}{cmd:)}
follow the same syntax as {cmd:origin()}.  In multiple-record data, both
{it:varname} {cmd:==} {it:numlist} and {cmd:time} {it:exp} are interpreted as
the earliest time implied, and if both are specified, the later of the two
times is used.

{phang}
{cmd:exit(failure} | [{varname} {cmd:==} {it:{help numlist}}] {cmd:time}
{it:{help exp}}{cmd:)} specifies the latest time under which the subject is both
under observation and at risk.  The emphasis is on latest; obviously, subjects
also exit the risk pool when their data run out.

{pmore}
{cmd:exit(failure)} is the default.  When the first failure event occurs, the
subject is removed from the analysis risk pool, even if the subject has
subsequent records in the data and even if some of those subsequent records
document other failure events.  Specify {cmd:exit(time} {cmd:.)} if you wish to
keep all records for a subject after failure.  You want to do this if you have
multiple-failure data.

{pmore}
{cmd:exit(}{it:varname} {cmd:==} {it:numlist}{cmd:)},
{cmd:exit(time} {it:exp}{cmd:)}, and
{cmd:exit(}{it:varname} {cmd:==} {it:numlist} {cmd:time} {it:exp}{cmd:)}
follow the same syntax as {cmd:origin()} and {cmd:enter()}.  In multiple-record
data, both {it:varname} {cmd:==} {it:numlist} and {cmd:time} {it:exp} are
interpreted as the earliest time implied.  {cmd:exit} differs from
{cmd:origin()} and {cmd:enter()} in that if both are specified, the earlier of
the two times is used.

{dlgtab:Advanced}

{phang}
{opth if(exp)}, {opt ever(exp)}, {opt never(exp)}, {opt after(exp)}, and
{opt before(exp)} select relevant records.

{pmore}
{opt if(exp)} selects records for which {it:exp} is true.  We strongly
recommend specifying this {opt if()} option rather than {cmd:if} {it:exp}
following {cmd:stset} or {cmd:streset}.  They differ in that {cmd:if} {it:exp}
removes the data from consideration before calculating beginning and ending
times and other quantities.  The {opt if()} option, on the other hand, sets the
restriction after all derived variables are calculated.  See
{mansection ST stsetRemarksandexamplesif()versusifexp:{it:if() versus if exp}} in
{bf:[ST] stset}.

{pmore}
{cmd:if()} may be specified with single- or multiple-record data.  The
remaining selection options are for use with multiple-record data only.

{pmore}
{opt ever(exp)} selects only subjects for which {it:exp} is ever true.

{pmore}
{opt never(exp)} selects only subjects for which {it:exp} is never true.

{pmore}
{opt after(exp)} selects records within subject on or after the first time
{it:exp} is true.

{pmore}
{opt before(exp)} selects records within subject before the first time
{it:exp} is true.

{phang}
{opth time0(varname)} is seldom specified because most datasets do not contain
this information.  {opt time0()} should be used exclusively with
multiple-record data, and even then you should consider whether {opt origin()}
or {opt enter()} would be more appropriate.

{pmore}
{opt time0()} specifies a mechanical aspect of interpretation about the
records in the dataset, namely, the beginning of the period spanned by each
record.  See 
{mansection ST stsetRemarksandexamplesIntermediateexitandreentrytimes(gaps):{it:Intermediate exit and reentry times (gaps)}}
in {bf:[ST] stset}.


{marker options_streset}{...}
{title:Options unique to streset}

{phang}
{opt past} expands the {cmd:stset} sample to include the entire recorded past
of the relevant subjects, meaning that it includes observations before
becoming at risk and those excluded because of {opt after()}, etc.

{phang}
{opt future} expands the {cmd:stset} sample to include the records on the
relevant subjects after the last record that previously was included, if any,
which typically means to include all observations after failure or censoring.

{phang}
{opt past future} expands the {cmd:stset} sample to include all records on the
relevant subjects.

{pstd}
Typing {cmd:streset} without arguments resets the sample to the analysis
sample.  See
{mansection ST stsetRemarksandexamplesPastandfuturerecords:{it:Past and future records}}
in {bf:[ST] stset} for more information.


{marker options_st}{...}
{title:Options for use with st}

{phang}
{opt nocmd} suppresses displaying the last {cmd:stset} command.

{phang}
{opt notable} suppresses displaying the table summarizing what has been
{cmd:stset}.


{marker examples}{...}
{title:Example: Single-record-per-subject}

{pstd}The failure-time (analysis-time) variable is {cmd:failtime}{p_end}
        {cmd:. webuse kva}
        {cmd:. stset failtime}


{title:Example: Single-record-per-subject with censoring}

{pstd}The analysis-time variable is {cmd:studytime}, the failure/censoring
indicator variable is {cmd:died} with {cmd:died==1} denoting a failure event
{p_end}
        {cmd:. webuse drugtr}
        {cmd:. stset studytime, failure(died)}

{pstd}The analysis-time variable is {cmd:dox}, the failure event is any outcome
category different from 0 ({cmd:fail!=0}).  Subjects first become at risk and
come under observation at time 0 (the default){p_end}
        {cmd:. webuse diet}
        {cmd:. stset dox, failure(fail)}

{pstd}Subjects first become at risk at time 0 and come under observation at
date of entry into the study recorded in variable {cmd:doe}{p_end}
{phang2}{cmd:. stset dox, failure(fail) enter(time doe)}

{pstd}Subjects first become at risk and come under observation at date of birth
recorded in variable {cmd:dob} rather than at time 0{p_end}
{phang2}{cmd:. stset dox, failure(fail) origin(time dob)}

{pstd}Subjects first become at risk at date of birth and come under
observation at date of entry into the study{p_end}
{phang2}{cmd:. stset dox, failure(fail) origin(time dob) enter(time doe)}

{pstd}Set the scale for time-since-birth (analysis time) to be measured in
years{p_end}
{phang2}{cmd:. stset dox, failure(fail) origin(time dob) enter(time doe)}
               {cmd:scale(365.25)}

{pstd}Specify that subjects with dates of exposure {cmd:dox} after 01dec1970
be removed from the analysis risk pool{p_end}
{phang2}{cmd:. stset dox, failure(fail) origin(time dob) enter(time doe)}
               {cmd: scale(365.25) exit(time mdy(12,1,1970))}


{title:Example: Multiple-record-per-subject}

{pstd}The analysis-time variable is {cmd:dox}, the subject-identifier variable
is {cmd:id}.  Indicator variable {cmd:allfail} is equal to 1 in the last record
of each subject, indicating that all subjects fail at the end of the study
{p_end}
        {cmd:. webuse diet2}
        {cmd:. stset dox, id(id) failure(allfail)}


{title:Example: Multiple-record-per-subject with censoring}

{pstd}The analysis-time variable is {cmd:t1}, the failure/censoring
indicator variable is {cmd:died} with {cmd:died==1} denoting a failure event
{p_end}
        {cmd:. webuse stan3}
        {cmd:. stset t1, id(id) failure(died)}

{pstd}The analysis-time variable is {cmd:dox}, the failure event is any outcome
category different from 0 ({cmd:fail!=0}), and the subject-identifier variable
is {cmd:id}.  Subjects first become at risk and come under observation at time
0 (the default){p_end}
        {cmd:. webuse diet2}
        {cmd:. stset dox, id(id) failure(fail)}

{pstd}Subjects first become at risk at time 0 and come under observation at
date of entry into the study recorded in variable {cmd:doe}{p_end}
{phang2}{cmd:. stset dox, id(id) failure(fail) enter(time doe)}

{pstd}Subjects first become at risk and come under observation at date of birth
recorded in variable {cmd:dob}{p_end}
{phang2}{cmd:. stset dox, id(id) failure(fail) origin(time dob)}

{pstd}Subjects first become at risk at date of birth and come under
observation at date of entry into the study{p_end}
{phang2}{cmd:. stset dox, id(id) failure(fail) origin(time dob) enter(time doe)}

{pstd}Set the scale for time-since-birth (analysis time) to be measured in
years{p_end}
{phang2}{cmd:. stset dox, id(id) failure(fail) origin(time dob) enter(time doe)}
                 {cmd:scale(365.25)}

{pstd}Specify the outcome categories 1, 3, and 13 of {cmd:fail} to denote a
failure event and the outcome category 5 to indicate that a subject must be
removed from the analysis risk pool{p_end}
{phang2}{cmd:. stset dox, id(id) failure(fail==1 3 13) origin(time dob)}
                 {cmd: enter(time doe) scale(365.25) exit(fail==1 3 13 5)}


{marker video}{...}
{title:Video example}

{phang}
{browse "https://www.youtube.com/watch?v=I53Ji4lXoyg":Learn how to set up your data for survival analysis}
{p_end}
