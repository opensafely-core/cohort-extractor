{smcl}
{* *! version 1.4.6  12oct2018}{...}
{viewerdialog tsset "dialog tsset"}{...}
{vieweralsosee "[TS] tsset" "mansection TS tsset"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] tsfill" "help tsfill"}{...}
{viewerjumpto "Syntax" "tsset##syntax"}{...}
{viewerjumpto "Menu" "tsset##menu"}{...}
{viewerjumpto "Description" "tsset##description"}{...}
{viewerjumpto "Links to PDF documentation" "tsset##linkspdf"}{...}
{viewerjumpto "Options" "tsset##options"}{...}
{viewerjumpto "Examples" "tsset##examples"}{...}
{viewerjumpto "Video example" "tsset##video"}{...}
{viewerjumpto "Stored results" "tsset##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[TS] tsset} {hline 2}}Declare data to be time-series data{p_end}
{p2col:}({mansection TS tsset:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}Declare data to be time series

{p 8 15 2}
{cmd:tsset} {it:timevar} [{cmd:,} {it:options}]

{p 8 15 2}
{cmd:tsset} {it:panelvar} {it:timevar} [{cmd:,} {it:options}]


{pstd}Display how data are currently tsset

{p 8 15 2}
{cmd:tsset}


{pstd}Clear time-series settings

{p 8 15 2}
{cmd:tsset, clear}


{pstd}
In the declare syntax, {it:panelvar} identifies the panels and 
{it:timevar} identifies the times.

{synoptset tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{synopt :{help tsset##unitoptions:{it:unitoptions}}}specify units of {it:timevar}
{p_end}

{syntab:Delta}
{synopt :{help tsset##deltaoption:{it:deltaoption}}}specify length of period of {it:timevar}
{p_end}

{synopt :{opt noquery}}suppress summary calculations and output{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt noquery} is not shown in the dialog box.
{p_end}

{marker unitoptions}{...}
{synoptset}{...}
{synopthdr:unitoptions}
{synoptline}
{synopt :{it:(default)}}{it:timevar}'s units from 
{it:timevar}'s display format{p_end}

{synopt :{opt c:locktime}}{it:timevar} is {cmd:%tc}:
{bind:0 = 1jan1960 00:00:00.000}, 
{bind:1 = 1jan1960 00:00:00.001}, 
...
{p_end}
{synopt :{opt d:aily}}{it:timevar} is {cmd:%td}:
{bind:0 = 1jan1960},
{bind:1 = 2jan1960},
...
{p_end}
{synopt :{opt w:eekly}}{it:timevar} is {cmd:%tw}:
{bind:0 = 1960w1},
{bind:1 = 1960w2},
...
{p_end}
{synopt :{opt m:onthly}}{it:timevar} is {cmd:%tm}:
{bind:0 = 1960m1},
{bind:1 = 1960m2},
...
{p_end}
{synopt :{opt q:uarterly}}{it:timevar} is {cmd:%tq}:
{bind:0 = 1960q1},
{bind:1 = 1960q2},
...
{p_end}
{synopt :{opt h:alfyearly}}{it:timevar} is {cmd:%th}:
{bind:0 = 1960h1},
{bind:1 = 1960h2},
...
{p_end}
{synopt :{opt y:early}}{it:timevar} is {cmd:%ty}:
{bind:1960 = 1960},
{bind:1961 = 1961},
...
{p_end}
{synopt :{opt g:eneric}}{it:timevar} is {cmd:%tg}:
{bind:0 = ?},
{bind:1 = ?},
...
{p_end}

{synopt :{opth f:ormat(%fmt)}}specify {it:timevar}'s format and 
then apply default rule
{p_end}
{synoptline}
{p 4 6 2}
In all cases, negative {it:timevar} values are allowed.
{p_end}
{p2colreset}{...}

{marker deltaoption}{...}
{pstd}
{it:deltaoption} specifies the period between observations in 
{it:timevar} units and may be specified as

{synoptset}{...}
{p2coldent:{it:deltaoption}}Example{p_end}
{synoptline}
{synopt :{opt del:ta}{cmd:(}{it:#}{cmd:)}}{...}
{cmd:delta(1)} or {cmd:delta(2)}
{p_end}
{synopt :{opt del:ta}{cmd:((}{it:{help exp}}{cmd:))}}{...}
{cmd:delta((7*24))}
{p_end}
{synopt :{opt del:ta}{cmd:(}{it:# units}{cmd:)}}{...}
{cmd:delta(7 days)} or 
{cmd:delta(15 minutes)} or 
{bind:{cmd:delta(7 days 15 minutes)}}
{p_end}
{synopt :{opt del:ta}{cmd:((}{it:{help exp}}{cmd:)} {it:units}{cmd:)}}{...}
{cmd:delta((2+3) weeks)}
{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
Allowed units for {cmd:%tc} and {cmd:%tC} {it:timevars} are

		{hline 35}
		{cmd:seconds     second      secs    sec}
		{cmd:minutes     minute      mins    min}
		{cmd:hours       hour}
		{cmd:days        day}
		{cmd:weeks       week}
		{hline 35}

{pstd}
and for all other {cmd:%t} {it:timevars}, units specified must match the
frequency of the data; for example, for {cmd:%ty}, units must be year or years.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Time series > Setup and utilities >}
    {bf:Declare dataset to be time-series data}


{marker description}{...}
{title:Description}

{pstd}
{cmd:tsset} manages the time-series settings of a dataset.
{cmd:tsset} {it:timevar} declares the data in memory to be a time series.
This allows you to use
{mansection U 11.4.3.6Usingfactorvariableswithtime-seriesoperators:Stata's time-series operators}
and to analyze your data with the {cmd:ts} commands.
{cmd:tsset} {it:panelvar} {it:timevar} declares the data to be panel data,
also known as cross-sectional time-series data, which contain one
time series for each value of {it:panelvar}. This allows you to also
analyze your data with the {cmd:xt} commands without having to
{helpb xtset} your data.

{pstd}
{cmd:tsset} without arguments displays how the data are currently set
and sorts the data on {it:timevar} or {it:panelvar} {it:timevar}.

{pstd}
{cmd:tsset,} {cmd:clear} is a rarely used programmer's command to 
declare that the data are no longer a time series.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS tssetQuickstart:Quick start}

        {mansection TS tssetRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{it:unitoptions} {cmd:clocktime}, {cmd:daily}, {cmd:weekly}, {cmd:monthly},
    {cmd:quarterly}, {cmd:halfyearly}, {cmd:yearly}, {cmd:generic}, and
    {opth format(%fmt)} specify the units in which {it:timevar} is recorded.

{pmore}
    {it:timevar} will usually be a {cmd:%t} variable; 
    see {manhelp Datetime D}.  
    If {it:timevar} already has a {cmd:%t} display format assigned to it, you
    do not need to specify a {it:unitoption}; {cmd:tsset} will obtain the
    units from the format.  If you have not yet bothered to assign the
    appropriate {cmd:%t} format, however, you can use the {it:unitoptions} to
    tell {cmd:tsset} the units.  Then {cmd:tsset} will set
    {it:timevar}'s display format for you.  Thus, the {it:unitoptions} are
    convenience options; they allow you to skip formatting the time variable.
    The following all have the same net result:

            Alternative 1        Alternative 2        Alternative 3
            {hline 62}
            {cmd:format t %td}         {it:(t not formatted)    (t not formatted)}
            {cmd:tsset t              tsset t, daily       tsset t, format(%td)}

{pmore}
    {it:timevar} is not required to be a {cmd:%t} variable; it can be any
    variable of your own concocting so long as it takes on only integer
    values.  In such cases, it is called generic and considered to be
    {cmd:%tg}.  Specifying the {it:unitoption} {cmd:generic} or attaching a
    special format to {it:timevar}, however, is not necessary because
    {cmd:tsset} will assume that the variable is generic if it has any
    numerical format other than a {cmd:%t} format (or if it has a {cmd:%tg}
    format).

{phang}
{opt clear} -- used in {cmd:tsset,} {cmd:clear} -- makes Stata forget
    that the data ever were {cmd:tsset}.  This is a rarely used programmer's
    option.

{dlgtab:Delta}

{phang}
{cmd:delta()} specifies the period between observations in {it:timevar} and is
commonly used when {it:timevar} is {cmd:%tc}.  {cmd:delta()} is only sometimes
used with the other {cmd:%t} formats or with generic time variables.

{pmore}
    If {cmd:delta()} is not specified, {cmd:delta(1)} is assumed.  This means
    that at {it:timevar} = 5, the previous time is {it:timevar} = 5-1 = 4 and
    the next time would be {it:timevar} = 5+1 = 6.  Lag and lead operators,
    for instance, would work this way.  This would be assumed regardless of
    the units of {it:timevar}.

{pmore}
    If you specified {cmd:delta(2)}, then at {it:timevar} = 5, the previous
    time would be {it:timevar} = 5-2 = 3 and the next time would be
    {it:timevar} = 5+2 = 7.  Lag and lead operators would work this way.  In
    an observations with {it:timevar} = 5, {cmd:L.price} would be the value of
    {cmd:price} in the observation for which {it:timevar} = 3 and
    {cmd:F.price} would be the value of {cmd:price} in the observation for
    which {it:timevar} = 7.  If you then add an observation with
    {it:timevar=4}, the operators will still work appropriately; that is, 
    at {it:timevar} = 5, {cmd:L.price} will still have the value of
    {cmd:price} at {it:timevar} = 3.

{pmore}
    The are two aspects of {it:timevar}:  its units and its length of period.
    The {it:unitoptions} set the units.  {cmd:delta()} sets the length of
    period.

{pmore}
    We mentioned that {cmd:delta()} is commonly used with {cmd:%tc}
    {it:timevars} because Stata's {cmd:%tc} variables have units of
    milliseconds.  If {cmd:delta()} is not specified and in some model you
    refer to {cmd:L.price}, you will be referring to the value of {cmd:price}
    1 ms ago.  Few people have data with periodicity of a millisecond.
    Perhaps your data are hourly. You could specify {cmd:delta(3600000)}.  Or
    you could specify {cmd:delta((60*60*1000))}, because {cmd:delta()} will
    allow expressions if you include an extra pair of parentheses.  Or you
    could specify {cmd:delta(1} {cmd:hour)}.  They all mean the same thing:
    {it:timevar} has periodicity of 3,600,000 ms.  In an observation for which
    {it:timevar} = 1,489,572,000,000 (corresponding to 15mar2007 10:00:00),
    {cmd:L.price} would be the observation for which {it:timevar} =
    1,489,572,000,000 - 3,600,000 = 1,489,568,400,000 (corresponding to
    15mar2007 9:00:00).

{pmore}
    When you {cmd:tsset} the data and specify {cmd:delta()}, {cmd:tsset}
    verifies that all the observations follow the specified periodicity.  For
    instance, if you specified {cmd:delta(2)}, then {it:timevar} could contain
    any subset of {c -(}..., -4, -2, 0, 2, 4, ...{c )-} or it could contain
    any subset of {c -(}..., -3, -1, 1, 3, ...{c )-}.  If {it:timevar}
    contained a mix of values, {cmd:tsset} would issue an error message.  If
    you also specify {it:panelvar} -- you type {cmd:tsset} {it:panelvar}
    {it:timevar}{cmd:,} {cmd:delta(2)} -- the check is made on each panel
    independently.  One panel might contain {it:timevar} values from one set
    and the next, another, and that would be fine.

{pstd}
The following option is available with {cmd:tsset} but is not shown in the
dialog box:

{phang}
{opt noquery} prevents {cmd:tsset} from performing most of its summary
calculations and suppresses output.  With this option, only the following
results are posted:

	    {cmd:r(tdelta)}
	    {cmd:r(panelvar)}
	    {cmd:r(timevar)}
	    {cmd:r(tsfmt)}
	    {cmd:r(unit)}
	    {cmd:r(unit1)}


{marker examples}{...}
{title:Examples}

{pstd}
For a generic time series, variable {cmd:time} takes on values 1, 2, ...:

            {cmd:. webuse idle2}
	    {cmd:. tsset time}

{pstd}
For an annual time series, {cmd:time} takes on values such as 1990, 1991,
...:

            {cmd:. webuse sunspot}
	    {cmd:. tsset time}
{pstd}or{p_end}
	    {cmd:. tsset time, yearly}

{pstd}
For a quarterly time series, {cmd:qtr} takes on 0 meaning 1960q1, 1 meaning
1960q2, ... :

            {cmd:. webuse lutkepohl2}
	    {cmd:. tsset qtr}
        or
	    {cmd:. tsset qtr, quarterly}

{pstd}
(use the second if {cmd:qtr} has not yet been assigned a {cmd:%tq} format)

{pstd}
For a monthly time series, {cmd:month} takes on 0 meaning 1960m1, 1 meaning
1960m2, ...:

            {cmd:. webuse monthly}
	    {cmd:. tsset month}
{pstd}or{p_end}
	    {cmd:. tsset month, monthly}

{pstd} 
For a daily time series, {cmd:date} is a {cmd:%td} variable and 
already has been assigned a {cmd:%td} format:

            {cmd:. webuse dow1}
	    {cmd:. tsset date}

{pstd} 
If {cmd:date} has not yet been given a format:

	    {cmd:. tsset date, daily}
{pstd}or{p_end}
	    {cmd:. format date %td}
	    {cmd:. tsset date}

{pstd}
For a weekly time series, but with {cmd:date} a {cmd:%td} (daily) variable:

            {cmd:. webuse mondays}
	    {cmd:. tsset date, daily delta(7)}
{pstd}or{p_end}
	    {cmd:. tsset date, daily delta(7 days)}

{pstd}
For an hourly time series, {cmd:time} is a {cmd:%tc} variable:

            {cmd:. webuse hourlytemp}
	    {cmd:. tsset time, clocktime delta(1 hour)}

{pstd}
If {cmd:time} already had a {cmd:%tc} display format, the above
could be reduced to

	    {cmd:. tsset time, delta(1 hour)}

{pstd} 
For generic panel data, variable {cmd:company} being the panel identification 
variable and {cmd:time} being generic time:

            {cmd:. webuse invest2}
	    {cmd:. tsset company time}

{pstd}
For yearly panel data, variable {cmd:company} being the
panel ID variable and {cmd:year} being a four-digit calendar year:

            {cmd:. webuse grunfeld}
	    {cmd:. tsset company year, yearly}

{pstd}
For hourly panel data, variable {cmd:pid} being the patient ID
and {cmd:tod} being a {cmd:%tc} variable containing time of day:

            {cmd:. webuse patienttimes}
	    {cmd:. tsset pid tod, clocktime delta(30 minutes)}


{marker video}{...}
{title:Video example}

{phang2}{browse "http://www.youtube.com/watch?v=SOQvXICIRNY":Formatting and managing dates}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:tsset} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(imin)}}minimum panel ID{p_end}
{synopt:{cmd:r(imax)}}maximum panel ID{p_end}
{synopt:{cmd:r(tmin)}}minimum time{p_end}
{synopt:{cmd:r(tmax)}}maximum time{p_end}
{synopt:{cmd:r(tdelta)}}delta{p_end}
{synopt:{cmd:r(gaps)}}{cmd:1} if there are gaps, {cmd:0} otherwise{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(panelvar)}}name of panel variable{p_end}
{synopt:{cmd:r(timevar)}}name of time variable{p_end}
{synopt:{cmd:r(tdeltas)}}formatted delta{p_end}
{synopt:{cmd:r(tmins)}}formatted minimum time{p_end}
{synopt:{cmd:r(tmaxs)}}formatted maximum time{p_end}
{synopt:{cmd:r(tsfmt)}}{cmd:%}{it:fmt} of time variable{p_end}
{synopt:{cmd:r(unit)}}units of time variable:  
{cmd:Clock}, {cmd:clock}, {cmd:daily}, {cmd:weekly}, 
{cmd:monthly},
{cmd:quarterly}, {cmd:halfyearly}, {cmd:yearly}, or {cmd:generic}{p_end}
{synopt:{cmd:r(unit1)}}units of time variable:
{cmd:C}, {cmd:c}, 
{cmd:d}, {cmd:w}, {cmd:m}, {cmd:q}, {cmd:h}, {cmd:y}, or ""{p_end}
{synopt:{cmd:r(balanced)}}{cmd:unbalanced}, {cmd:weakly balanced}, or
	     {cmd:strongly balanced}; panels are strongly balanced if
	     they all have the same time values, weakly balanced if same
	     number of observations but different time values, otherwise
	     unbalanced{p_end}
{p2colreset}{...}
