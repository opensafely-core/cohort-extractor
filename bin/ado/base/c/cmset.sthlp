{smcl}
{* *! version 1.0.0  15may2019}{...}
{viewerdialog cmset "dialog cmset"}{...}
{vieweralsosee "[CM] cmset" "mansection CM cmset"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[CM] cmchoiceset" "help cmchoiceset"}{...}
{vieweralsosee "[CM] cmsample" "help cmsample"}{...}
{vieweralsosee "[CM] cmsummarize" "help cmsummarize"}{...}
{vieweralsosee "[CM] cmtab" "help cmtab"}{...}
{vieweralsosee "[XT] xtset" "help xtset"}{...}
{viewerjumpto "Syntax" "cmset##syntax"}{...}
{viewerjumpto "Menu" "cmset##menu"}{...}
{viewerjumpto "Description" "cmset##description"}{...}
{viewerjumpto "Links to PDF documentation" "cmset##linkspdf"}{...}
{viewerjumpto "Options" "cmset##options"}{...}
{viewerjumpto "Examples" "cmset##examples"}{...}
{viewerjumpto "Stored results" "cmset##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[CM] cmset} {hline 2}}Declare data to be choice model data{p_end}
{p2col:}({mansection CM cmset:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Declare data to be cross-sectional choice model data

{p 8 16 2}
{cmd:cmset} {it:caseidvar} {it:altvar}
[{cmd:, force}]

{p 8 16 2}
{cmd:cmset} {it:caseidvar}{cmd:,} {opt noalt:ernatives}


{pstd}
Declare data to be panel choice model data

{p 8 16 2}
{cmd:cmset} {it:panelvar} {it:timevar} {it:altvar}
[{cmd:,} {it:tsoptions} {cmd:force}]

{p 8 16 2}
{cmd:cmset} {it:panelvar} {it:timevar}{cmd:,} {opt noalt:ernatives}


{pstd}
Display how data are currently cmset

{p 8 16 2}
{cmd:cmset}


{pstd}
Clear cm settings

{p 8 16 2}
{cmd:cmset, clear}


{phang}
{it:caseidvar} identifies the cases in the cross-sectional data syntax.
{p_end}
{phang}
{it:altvar} identifies the alternatives (choice sets).{p_end}
{phang}
{it:panelvar} identifies the panels, and 
{it:timevar} identifies the times within panels.{p_end}

{synoptset 18}{...}
{synopthdr:tsoptions}
{synoptline}
{synopt :{help cmset##unitoptions:{it:unitoptions}}}specify units of {it:timevar}{p_end}
{synopt :{help cmset##deltaoption:{it:deltaoption}}}specify period
between observations in {it:timevar} units{p_end}
{synoptline}

{marker unitoptions}{...}
{synopthdr:unitoptions}
{synoptline}
{synopt :({it:default})}{it:timevar}'s units to be obtained from {it:timevar}'s 
display format{p_end}
{synopt :{opt c:locktime}}{it:timevar} is {cmd:%tc}:
0=1jan1960 00:00:00.000, 1=1jan1960 00:00:00.001, ...{p_end}
{synopt :{opt d:aily}}{it:timevar} is {cmd:%td}: 
0=1jan1960, 1=2jan1960, ...{p_end}
{synopt :{opt w:eekly}}{it:timevar} is {cmd:%tw}: 
0=1960w1, 1=1960w2, ...{p_end}
{synopt :{opt m:onthly}}{it:timevar} is {cmd:%tm}: 
0=1960m1, 1=1960m2, ...{p_end}
{synopt :{opt q:uarterly}}{it:timevar} is {cmd:%tq}: 
0=1960q1, 1=1960q2, ...{p_end}
{synopt :{opt h:alfyearly}}{it:timevar} is {cmd:%th}: 
0=1960h1, 1=1960h2, ...{p_end}
{synopt :{opt y:early}}{it:timevar} is {cmd:%ty}: 
1960 = 1960, 1961 = 1961, ...{p_end}
{synopt :{opt g:eneric}}{it:timevar} is {cmd:%tg}:
0 = ?, 1 = ?, ...{p_end}

{synopt :{opth f:ormat(%fmt)}}specify {it:timevar}'s format and then
apply default rule{p_end}
{synoptline}
{p 4 6 2}
In all cases, negative {it:timevar} values are allowed.{p_end}

{marker deltaoption}{...}
{synopthdr:deltaoption}
{synoptline}
{synopt :{opt del:ta(#)}}{cmd:delta(1)} or {cmd:delta(2)}{p_end}
{synopt :{cmdab:del:ta((}{help exp:{it:exp}}{cmd:))}}{cmd:delta((7*24))}{p_end}
{synopt :{opt del:ta(# units)}}{cmd:delta(7 days)} or {cmd:delta(15 minutes)}
or {cmd:delta(7 days 15 minutes)}{p_end}
{synopt :{cmdab:del:ta((}{help exp:{it:exp}}{cmd:)} {it:units}{cmd:)}}{cmd:delta((2+3) weeks)}{p_end}
{synoptline}

{p 4 6 2}
Allowed units for {cmd:%tc} and {cmd:%tC} {it:timevars} are

        seconds    second    secs    sec
        minutes    minute    mins    min
        hours      hour
        days       day
        weeks      week

{p 4 6 2}
and for all other {cmd:%t} {it:timevars} are

        days       day
        weeks      week


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Choice models > Setup and utilities > Declare data to be choice model data}


{marker description}{...}
{title:Description}

{pstd}
{cmd:cmset} manages the choice model settings of a dataset.  You use
{cmd:cmset} to declare the data in memory to be choice model data.  With
cross-sectional data, you designate which variables identify cases and
alternatives.  With panel data, you designate which variables identify panels,
time periods, and alternatives.  You must {cmd:cmset} your data before you can
use the other {cmd:cm} commands.

{pstd}
{cmd:cmset} without arguments displays how the data are currently set.
{cmd:cmset} also sorts the data based on the variables that identify
cases, alternatives, and panels.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection CM cmsetQuickstart:Quick start}

        {mansection CM cmsetRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt noalternatives} specifies that alternatives are not explicitly
identified.  That is, there is no alternatives variable.
The default is that you must specify an alternatives variable.

{phang}
{opt force} suppresses error messages caused by the alternatives variable
{it:altvar}.  This option is rarely used.  The alternatives variable must be
free of errors before {opt cm} commands can run, so this option changes only
the point at which error messages will be issued.  One use of the {opt force}
option is to specify it with {opt cmset} and then run {helpb cmsample} to
identify the observations with bad values for the alternatives variable.
{opt force} does not suppress all error messages.  Error messages in the case
ID variable and error messages in the time variable for panel data are not
suppressed.

{phang}
{it:unitoptions} {opt clocktime}, {opt daily}, {opt weekly}, {opt monthly},
{opt quarterly}, {opt halfyearly}, {opt yearly}, {opt generic}, and
{opth format(%fmt)} specify the units in which {it:timevar} is recorded 
when {it:timevar} is specified.

{pmore} 
{it:timevar} will often simply be a variable of counts such as 1, 2, ..., or
years such as 2001, 2002, ....  In other cases, {it:timevar} will be a
formatted {cmd:%t} variable; see {manhelp Datetime D}.  In any of these
cases, you do not need to specify a {it:unitoption}.

{pmore}
Only when {it:timevar} is an unformatted time variable would you use these
options.  When you {opt cmset} panel choice model data, it becomes {opt xtset}
as well.  These options are simply passed to {opt xtset}.  See
{manhelp xtset XT} for option details.
 
{phang}
{opt delta()} specifies the period of {it:timevar} and is commonly used when
{it:timevar} is {cmd:%tc} or {cmd:%tC}.  {opt delta()} is rarely used with
other {cmd:%t} formats or with unformatted time variables.  If {opt delta()}
is not specified, {cmd:delta(1)} is assumed.  See {manhelp xtset XT} for option
details.

{phang}
{opt clear} -- used in {cmd:cmset,} {cmd:clear} -- makes Stata forget that the
data were ever {cmd:cmset}.  This option is rarely used.  Note that if you
{cmd:cmset} your data as panel choice model data with an alternatives
variable, they also become {cmd:xtset}.  Typing {cmd:cmset,} {cmd:clear} does
not clear the {cmd:xt} settings.  To do this, you must type {cmd:xtset,}
{cmd:clear} as well.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse carchoice}{p_end}

{pstd}Declare the data to be choice model data{p_end}
{phang2}{cmd:. cmset consumerid car}{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse transport, clear}{p_end}

{pstd}Declare the data to be panel choice data{p_end}
{phang2}{cmd:. cmset id t alt}{p_end}

{pstd}List the data, including the two variables created by {cmd:cmset}{p_end}
{phang2}{cmd:. sort id t alt}{p_end}
{phang2}{cmd:. list id t alt _caseid _panelaltid if inlist(id, 1, 2), sepby(t) abbr(11)}{p_end}

{pstd}Show the current settings{p_end}
{phang2}{cmd:. cmset}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:cmset} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt :{cmd:r(n_cases)}}number of cases{p_end}
{synopt :{cmd:r(n_alt_min)}}minimum number of alternatives per case{p_end}
{synopt :{cmd:r(n_alt_avg)}}average number of alternatives per case{p_end}
{synopt :{cmd:r(n_alt_max)}}maximum number of alternatives per case{p_end}
{synopt :{cmd:r(altvar_min)}}minimum of alternatives variable (if set when
numeric){p_end}
{synopt :{cmd:r(altvar_max)}}maximum of alternatives variable (if set when
numeric){p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt :{cmd:r(caseid)}}name of case ID variable{p_end}
{synopt :{cmd:r(altvar)}}name of alternatives variable (if set){p_end}

{pstd}
For panel data, {cmd:cmset} also stores the following in {cmd:r()}:

{p2col 5 20 24 2: Scalars}{p_end}
{synopt :{cmd:r(imin)}}minimum panel ID{p_end}
{synopt :{cmd:r(imax)}}maximum panel ID{p_end}
{synopt :{cmd:r(tmin)}}minimum time{p_end}
{synopt :{cmd:r(tmax)}}maximum time{p_end}
{synopt :{cmd:r(tdelta)}}delta{p_end}
{synopt :{cmd:r(gaps)}}{cmd:1} if there are gaps, {cmd:0} otherwise{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt :{cmd:r(origpanelvar)}}name of original panel variable passed to {cmd:cmset}{p_end}
{synopt :{cmd:r(panelvar)}}name of panel variable{p_end}
{synopt :{cmd:r(timevar)}}name of time variable{p_end}
{synopt :{cmd:r(tdeltas)}}formatted delta{p_end}
{synopt :{cmd:r(tmins)}}formatted minimum time{p_end}
{synopt :{cmd:r(tmaxs)}}formatted maximum time{p_end}
{synopt :{cmd:r(tsfmt)}}{cmd:%}{it:fmt} of time variable{p_end}
{synopt :{cmd:r(unit)}}units of time variable:  {cmd:Clock}, {cmd:clock},
{cmd:daily}, {cmd:weekly}, {cmd:monthly}, {cmd:quarterly}, {cmd:halfyearly},
{cmd:yearly}, or {cmd:generic}{p_end}
{synopt :{cmd:r(unit1)}}units of time variable:  {cmd:C}, {cmd:c}, {cmd:d},
{cmd:w}, {cmd:m}, {cmd:q}, {cmd:h}, {cmd:y}, or {cmd:""}{p_end}
{synopt :{cmd:r(balanced)}}{cmd:unbalanced},
{cmd:weakly balanced}, or {cmd:strongly balanced}; a set of panels are
strongly balanced if they all have the same time values, otherwise weakly
balanced if same number of time values, otherwise unbalanced{p_end}
{p2colreset}{...}
