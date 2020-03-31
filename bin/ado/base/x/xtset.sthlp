{smcl}
{* *! version 1.2.25  12oct2018}{...}
{viewerdialog xtset "dialog xtset"}{...}
{vieweralsosee "[XT] xtset" "mansection XT xtset"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtdescribe" "help xtdescribe"}{...}
{vieweralsosee "[XT] xtsum" "help xtsum"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] tsfill" "help tsfill"}{...}
{viewerjumpto "Syntax" "xtset##syntax"}{...}
{viewerjumpto "Menu" "xtset##menu"}{...}
{viewerjumpto "Description" "xtset##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtset##linkspdf"}{...}
{viewerjumpto "Options" "xtset##options"}{...}
{viewerjumpto "Examples" "xtset##examples"}{...}
{viewerjumpto "Stored results" "xtset##results"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[XT] xtset} {hline 2}}Declare data to be panel data{p_end}
{p2col:}({mansection XT xtset:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}Declare data to be panel

{p 8 15 2}
{cmd:xtset} {it:panelvar}

{p 8 15 2}
{cmd:xtset} {it:panelvar} {it:timevar} [{cmd:,} {it:tsoptions}]


{pstd}Display how data are currently xtset

{p 8 15 2}
{cmd:xtset}


{pstd}Clear xt settings

{p 8 15 2}
{cmd:xtset, clear}


{pstd}
In the declare syntax, {it:panelvar} identifies the panels and the optional
{it:timevar} identifies the times within panels.  {it:tsoptions} concern
{it:timevar}. 

{synoptset}{...}
{synopthdr:tsoptions}
{synoptline}
{synopt :{it:{help xtset##unitoptions:unitoptions}}}specify units of {it:timevar}
{p_end}
{synopt :{it:{help xtset##deltaoption:deltaoption}}}specify length of period of {it:timevar}
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
and for all other {cmd:%t} {it:timevars} are

		{hline 30}
		{cmd:days          day}
		{cmd:weeks         week}
		{hline 30}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Longitudinal/panel data > Setup and utilities >}
      {bf:Declare dataset to be panel data}


{marker description}{...}
{title:Description}

{pstd}
{cmd:xtset} manages the panel settings of a dataset.  You must {cmd:xtset}
your data before you can use the other {cmd:xt} commands.  {cmd:xtset}
{it:panelvar} declares the data in memory to be a panel in which the order of
observations is irrelevant.  {cmd:xtset} {it:panelvar} {it:timevar} declares
the data to be a panel in which the order of observations is relevant.  When
you specify {it:timevar}, you can then use
{mansection U 11.4.3.6Usingfactorvariableswithtime-seriesoperators:Stata's time-series operators}
and analyze your data with the {cmd:ts} commands without having to
{helpb tsset} your data.

{pstd}
{cmd:xtset} without arguments displays how the data are currently {cmd:xtset}.
If the data are set with a {it:panelvar} and a {it:timevar}, {cmd:xtset}
also sorts the data by {it:panelvar} {it:timevar} if a {it:timevar} was
specified.  If the data are set with a {it:panelvar} only, the sort order is
not changed.

{pstd}
{cmd:xtset,} {cmd:clear} is a rarely used programmer's command to 
declare that the data are no longer to be considered a panel.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtsetQuickstart:Quick start}

        {mansection XT xtsetRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{it:unitoptions} {cmd:clocktime}, {cmd:daily}, {cmd:weekly}, {cmd:monthly},
    {cmd:quarterly}, {cmd:halfyearly}, {cmd:yearly}, {cmd:generic}, and
    {opth format(%fmt)} specify the units in which {it:timevar} is recorded.

{pmore}
    {it:timevar} will usually be a variable that counts 1, 2,
    ..., and is to be interpreted as first year of survey, second year,
    ..., or first month of treatment, second month, ....  In these cases,
    you do not need to specify a {it:unitoption}.

{pmore}
    In other cases, {it:timevar} will be a year variable or the like such 
    as 2001, 2002, ..., and is to be interpreted as year of survey or 
    the like.  In those cases, you do not need to specify a 
    {it:unitoption}.

{pmore}
    In other, more complicated cases, {it:timevar} will be a full-blown
    {cmd:%t} variable; see {manhelp Datetime D}.
    If {it:timevar} already
    has a {cmd:%t} display format assigned to it, you do not need to specify a
    {it:unitoption}; {cmd:xtset} will obtain the units from the format.  If
    you have not yet bothered to assign the appropriate {cmd:%t} format to the
    {cmd:%t} variable, however, you can use the {it:unitoptions} to tell
    {cmd:xtset} the units.  Then {cmd:xtset} will set {it:timevar}'s
    display format for you.  Thus, the {it:unitoptions} are convenience
    options; they allow you to skip formatting the time variable.  The
    following all have the same net result:

            Alternative 1        Alternative 2        Alternative 3
            {hline 62}
            {cmd:format t %td}         {it:(t not formatted)    (t not formatted)}
            {cmd:xtset pid t          xtset pid t, daily   xtset pid t, format(%td)}

{pmore}
    {it:timevar} is not required to be a {cmd:%t} variable; it can be any
    variable of your own concocting so long as it takes on only integer
    values.  When you {cmd:xtset} a time variable that is not {cmd:%t}, the
    display format does not change unless you specify the {it:unitoption}
    {cmd:generic} or use the {cmd:format()} option.

{phang}
{cmd:delta()} specifies the period between observations in {it:timevar} and is
commonly used when {it:timevar} is {cmd:%tc}.  {cmd:delta()} is only sometimes
used with the other {cmd:%t} formats or with generic time variables.

{pmore}
    If {cmd:delta()} is not specified, {cmd:delta(1)} is assumed.  This means
    that at {it:timevar} = 5, the previous time is {it:timevar} = 5-1=4 and
    the next time would be {it:timevar} = 5+1=6.  Lag and lead operators, for
    instance, would work this way.  This would be assumed regardless of the
    units of {it:timevar}.

{pmore}
    If you specified {cmd:delta(2)}, then at {it:timevar} = 5, the previous
    time would be {it:timevar} = 5-2 = 3 and the next time would be
    {it:timevar} = 5+2 = 7.  Lag and lead operators would work this way.  In
    an observations with {it:timevar} = 5, {cmd:L.income} would be the value of
    {cmd:income} in the observation for which {it:timevar} = 3 and
    {cmd:F.income} would be the value of {cmd:income} in the observation for
    which {it:timevar} = 7.  If you then add an observation with
    {it:timevar=4}, the operators will still work appropriately; that is, 
    at {it:timevar} = 5, {cmd:L.income} will still have the value of
    {cmd:income} at {it:timevar} = 3.

{pmore}
    There are two aspects of {it:timevar}:  its units and its length of period.
    The {it:unitoptions} set the units.  {cmd:delta()} sets the length of
    period.  You are not required to specify one to specify the other.  You
    might have a generic {it:timevar} but it counts in 12: 0, 12, 24, ....
    You would skip specifying {it:unitoptions} but would specify
    {cmd:delta(12)}.

{pmore}
    We mentioned that {cmd:delta()} is commonly used with {cmd:%tc}
    {it:timevars} because Stata's {cmd:%tc} variables have units of
    milliseconds.  If {cmd:delta()} is not specified and in some model you
    refer to {cmd:L.bp}, you will be referring to the value of {cmd:bp} 1 ms
    ago.  Few people have data with periodicity of a millisecond.
    Perhaps your data are hourly. You could specify {cmd:delta(3600000)}.  Or
    you could specify {cmd:delta((60*60*1000))}, because {cmd:delta()} will
    allow expressions if you include an extra pair of parentheses.  Or you
    could specify {cmd:delta(1} {cmd:hour)}.  They all mean the same thing:
    {it:timevar} has periodicity of 3,600,000 ms.  In an observation
    for which {it:timevar} = 1,489,572,000,000 (corresponding to 15mar2007
    10:00:00), {cmd:L.bp} would be the observation for which {it:timevar} =
    1,489,572,000,000 - 3,600,000 = 1,489,568,400,000 (corresponding to
    15mar2007 9:00:00).

{pmore}
    When you {cmd:xtset} the data and specify {cmd:delta()}, {cmd:xtset}
    verifies that all the observations follow the specified periodicity.  For
    instance, if you specified {cmd:delta(2)}, then {it:timevar} could contain
    any subset of {c -(}..., -4, -2, 0, 2, 4, ...{c )-} or it could contain
    any subset of {c -(}..., -3, -1, 1, 3, ...{c )-}.  If {it:timevar}
    contained a mix of values, {cmd:xtset} would issue an error message.  The
    check is made on each panel independently, so one panel might contain
    {it:timevar} values from one set and the next, another, and that would be
    fine.

{phang}
{opt clear} -- used in {cmd:xtset,} {cmd:clear} -- makes Stata forget
    that the data ever were {cmd:xtset}.  This is a rarely used programmer's
    option.

{pstd}
The following option is available with {cmd:xtset} but is not shown in the
dialog box:

{phang}
{opt noquery} prevents {cmd:xtset} from performing most of its summary
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

    {title:Example with no time variable}

{pstd}
For a panel dataset with no time variable such as a dataset with variable
    {cmd:country} and observations on cities within country, type

	    {cmd:. xtset country}

{pstd}
    Variable {cmd:country} must be numeric.  If the variable is string, type

	    {cmd:. egen cntry = group(country)}
            {cmd:. xtset cntry}
    or
	    {cmd:. encode country, gen(cntry)}
            {cmd:. xtset cntry}

{pstd}
    The first will generate numeric variable {cmd:cntry} containing 1, 2, ...,
    for the various countries.  The second will do the same but will also
    create a value label and label the new variable, so that when you 
    {cmd:list} the variable, it will look like the original.


    {title:Example with annual panel data}

{pstd}
For an annual panel dataset such as a dataset with variables {cmd:country} and
    {cmd:year}, type

	    {cmd:. xtset country year}
   or
	    {cmd:. xtset country year, yearly}

{pstd}
    It makes little difference which you use, only the output will be
    formatted differently.  In the second case, variable {cmd:year} must
    contain values such as 1990 and 2006.  In the first case, {cmd:year} may
    contain any year encoding, including 1990 and 2006.


    {title:Example with quarterly panel data}

{pstd}
For a quarterly panel on {cmd:company} and {cmd:quarter}, type 

	    {cmd:. xtset company quarter}

{pstd}
    If quarter is encoded 1=1960q1, 2=1960q2, etc., you may type

	    {cmd:. xtset company quarter, quarterly}

{pstd}
    and output will look better.


    {title:Example with daily panel data}

{pstd}
For a daily time panel, {cmd:pid} is the numeric person identification 
    number and {cmd:date} is a {cmd:%td} variable and already has been
    assigned a {cmd:%td} format, type

	    {cmd:. xtset pid date}

{pstd} 
    If {cmd:date} has not yet been given a format:

	    {cmd:. format date %td}
	    {cmd:. xtset pid date}
    or
	    {cmd:. xtset pid date, daily}


    {title:Example with hourly panel data}

{pstd}
For an hourly panel, {cmd:pid} is the patient ID and {cmd:tod} a {cmd:%tc}
    variable:

	    {cmd:. xtset pid tod, clocktime delta(1 hour)}

{pstd}
    If {cmd:tod} already had a {cmd:%tc} display format, the above could be
    reduced to

	    {cmd:. xtset pid tod, delta(1 hour)}


    {title:Examples you can try}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse pig}

{pstd}Declare panel and time variables{p_end}
{phang2}{cmd:. xtset id week}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse airacc}

{pstd}Declare panel and time variables and specify 1 as the period between
observations in units of time{p_end}
{phang2}{cmd:. xtset airline time, delta(1)}

{pstd}Same as above{p_end}
{phang2}{cmd:. xtset airline time}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse xtsetxmpl}

{pstd}Declare panel and time variables; specify clocktime units and delta of
1 hour{p_end}
{phang2}{cmd:. xtset pid tod, clocktime delta(1 hour)}

{pstd}Or, equivalent to the above{p_end}
{phang2}{cmd:. webuse xtsetxmpl}{p_end}
{phang2}{cmd:. format tod %tc}{p_end}
{phang2}{cmd:. xtset pid tod, delta(1 hour)}{p_end}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:xtset} stores the following in {cmd:r()}:

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
