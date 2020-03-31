{smcl}
{* *! version 2.0.10  15may2018}{...}
{vieweralsosee "[D] Datetime display formats" "mansection D Datetimedisplayformats"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] Datetime" "help datetime"}{...}
{vieweralsosee "[D] Datetime business calendars" "help datetime_business_calendars"}{...}
{vieweralsosee "[D] Datetime translation" "help datetime_translation"}{...}
{viewerjumpto "Syntax" "datetime display formats##syntax"}{...}
{viewerjumpto "Description" "datetime display formats##description"}{...}
{viewerjumpto "Links to PDF documentation" "datetime_display_formats##linkspdf"}{...}
{viewerjumpto "Remarks" "datetime display formats##remarks"}{...}
{p2colset 1 33 35 2}{...}
{p2col:{bf:[D] Datetime display formats} {hline 2}}Display formats for dates and times{p_end}
{p2col:}({mansection D Datetimedisplayformats:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
The formats for displaying Stata internal form (SIF) dates and times in 
human readable form (HRF) are

                            Display format to 
         SIF type           present SIF in HRF
	 {hline 37}
         datetime/c            {cmd:%tc}[{it:details}]
         datetime/C            {cmd:%tC}[{it:details}]

         date                  {cmd:%td}[{it:details}]

         weekly date           {cmd:%tw}[{it:details}]
         monthly date          {cmd:%tm}[{it:details}]
         quarterly date        {cmd:%tq}[{it:details}]
         half-yearly date      {cmd:%th}[{it:details}]
         yearly date           {cmd:%ty}[{it:details}]
	 {hline 37}

{pstd}
The optional {it:details} allows you to control how results appear
and is composed of a sequence of the following codes: 

	    Code      Meaning            Output
	    {hline 65}
	    {cmd:CC}        century-1          01 - 99
	    {cmd:cc}        century-1          1 - 99
	    {cmd:YY}        2-digit year       00 - 99
	    {cmd:yy}        2-digit year       0 - 99

            {cmd:JJJ}       day within year    001 - 366
	    {cmd:jjj}       day within year    1 - 366

	    {cmd:Mon}       month              Jan, Feb, ..., Dec
	    {cmd:Month}     month              January, February, ..., December
            {cmd:mon}       month              jan, feb, ..., dec
            {cmd:month}     month              january, february, ..., december
            {cmd:NN}        month              01 - 12
	    {cmd:nn}        month              1 - 12

            {cmd:DD}        day within month   01 - 31
            {cmd:dd}        day within month   1 - 31

            {cmd:DAYNAME}   day of week        Sunday, Monday, ... (aligned)
            {cmd:Dayname}   day of week        Sunday, Monday, ... (unaligned)
	    {cmd:Day}       day of week        Sun, Mon, ...
            {cmd:Da}        day of week        Su, Mo, ...
            {cmd:day}       day of week        sun, mon, ...
            {cmd:da}        day of week        su, mo, ...

            {cmd:h}         half               1 - 2
            {cmd:q}         quarter            1 - 4
            {cmd:WW}        week               01 - 52
            {cmd:ww}        week               1 - 52

	    {cmd:HH}        hour               00 - 23
	    {cmd:Hh}        hour               00 - 12
	    {cmd:hH}        hour               0 - 23
            {cmd:hh}        hour               0 - 12

            {cmd:MM}        minute             00 - 59
	    {cmd:mm}        minute             0 - 59

            {cmd:SS}        second             00 - 60 (sic, due to leap seconds)
            {cmd:ss}        second             0 - 60 (sic, due to leap seconds)
	    {cmd:.s}        tenths             .0 - .9
	    {cmd:.ss}       hundredths         .00 - .99
	    {cmd:.sss}      thousandths        .000 - .999

	    {cmd:am}        show am or pm      am   or  pm
	    {cmd:a.m.}      show a.m. or p.m.  a.m. or  p.m.
	    {cmd:AM}        show AM or PM      AM   or  PM
	    {cmd:A.M.}      show A.M. or P.M.  A.M. or  P.M.

	    {cmd:.}         display period     .
	    {cmd:,}         display comma      ,
	    {cmd::}         display colon      :
	    {cmd:-}         display hyphen     -
	    {cmd:_}         display space
            {cmd:/}         display slash      /
            {cmd:\}         display backslash  \
            {cmd:!}{it:c}        display character  {it:c}

	    {cmd:+}         separator (see note)
	    {hline 65}
            Note:  {cmd:+} displays nothing; it may be used to separate one code 
	    from the next to make the format more readable.  {cmd:+} is never
	    necessary.  For instance, {cmd:%tchh:MM+am} and {cmd:%tchh:MMam} have the
	    same meaning, as does {cmd:%tc+hh+:+MM+am}.

{pstd}
When {it:details} is not specified, it is equivalent to specifying 

	    Format {c |} Implied (fully specified) format
	    {hline 7}{c +}{hline 33}
	    {cmd:%tC}    {c |} {cmd:%tCDDmonCCYY_HH:MM:SS}
	    {cmd:%tc}    {c |} {cmd:%tcDDmonCCYY_HH:MM:SS}
                   {c |}
	    {cmd:%td}    {c |} {cmd:%tdDDmonCCYY}
                   {c |}
	    {cmd:%tw}    {c |} {cmd:%twCCYY!www}
	    {cmd:%tm}    {c |} {cmd:%tmCCYY!mnn}
	    {cmd:%tq}    {c |} {cmd:%tqCCYY!qq}
	    {cmd:%th}    {c |} {cmd:%thCCYY!hh}
            {cmd:%ty}    {c |} {cmd:%tyCCYY}
	    {hline 7}{c BT}{hline 33}

{pstd}
That is, typing 

{p 12 12 2}
. {cmd:format mytimevar %tc}

{pstd}
has the same effect as typing

{p 12 12 2}
. {cmd:format mytimevar %tcDDmonCCYY_HH:MM:SS}

{pstd}
Format {cmd:%tcDDmonCCYY_HH:MM:SS} is interpreted as

{col 11}{c TLC}{hline 63}{c TRC}
          {c |}       {cmd:%}         {cmd:t}           {cmd:c}             {cmd:DDmonCCYY_HH:MM:SS}  {c |}
          {c |}       |         |           |                      |          {c |}
          {c |} all formats   it is a    variable           formatting codes  {c |}
          {c |} start with {cmd:%}  datetime   coded in           specify how to    {c |}
          {c |}               format     milliseconds       display value     {c |}
{col 11}{c BLC}{hline 63}{c BRC}


{marker description}{...}
{title:Description}

{pstd}
Stata stores dates and times numerically in one of 
the eight SIFs.  An SIF might be 
18,282 or even 1,579,619,730,000.  Place the appropriate format on it, 
and the 18,282 is displayed as 20jan2010 ({cmd:%td}).  The 1,579,619,730,000 is 
displayed as 20jan2010 15:15:30 ({cmd:%tc}).  

{pstd}
If you specify additional format characters, you can change how the result 
is displayed.
Rather than 20jan2010, you could change it to 
2010.01.20; January 20, 2010; or 1/20/10.  
Rather than 20jan2010 15:15:30, you could change it to 
2010.01.20 15:15; January 20, 2010 3:15 pm; or 
Wed Jan 20 15:15:30 2010.

{pstd}
See {bf:{help datetime:[D] Datetime}} for an introduction to Stata's dates 
and times.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D DatetimedisplayformatsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help datetime_display_formats##formats:Specifying display formats}
	{help datetime_display_formats##rounding:Times are truncated, not rounded, when displayed}


{marker formats}{...}
    {title:Specifying display formats}

{pstd}
Rather than using the default format 20jan2010, you could display the SIF date
variable in one of these formats:

	2010.01.20
	January 20, 2010
	1/20/10

{pstd}
Likewise, rather than displaying the SIF datetime/c variable in 
the default format 20jan2010 15:15:30, you could display it in one of these
formats: 

	2010.01.20 15:15
	January 20, 2010 3:15 pm
	Wed Jan 20 15:15:30 2010

{pstd}
Here is how to do it:

{p 8 11 2}
1. 2010.01.20{break}
   {cmd:format} {it:mytdvar} {cmd:%tdCCYY.NN.DD}

{p 8 11 2}
2. January 20, 2010{break}
   {cmd:format} {it:mytdvar} {cmd:%tdMonth_dd,_CCYY}

{p 8 11 2}
3. 1/20/10{break}
   {cmd:format} {it:mytdvar} {cmd: %tdnn/dd/YY}

{p 8 11 2}
4. 2010.01.20 15:15{break}
   {cmd:format} {it:mytcvar} {cmd:%tcCCYY.NN.DD_HH:MM}

{p 8 11 2}
5. January 20, 2010 3:15 pm{break}
   {cmd:format} {it:mytcvar} {cmd:%tcMonth_dd,_CCYY_hh:MM_am}{break}
   Code {cmd:am} at the end indicates that am or pm 
   should be displayed, as appropriate.

{p 8 11 2}
6. Wed Jan 20 15:15:30 2010{break}
   {cmd:format} {it:mytcvar} {cmd:%tcDay_Mon_DD_HH:MM:SS_CCYY}

{pstd}
In examples 1 to 3, the formats each begin with {cmd:%td},
and in examples 4 to 6, the formats begin with {cmd:%tc}.  It is important
that you specify the opening correctly -- namely, as 
{cmd:%} + {cmd:t} + {it:third_character}.
The third 
character indicates the particular SIF encoding type, which is to say, 
how the numeric value is to be interpreted.
You specify 
{cmd:%tc}{it:...} for datetime/c 
variables, {cmd:%tC}{it:...} for datetime/C, {cmd:%td}{it:...} for date, and
so on.

{pstd}
The default format for datetime/c and datetime/C variables omits the fraction
of seconds; 15:15:30.000 is displayed as 15:15:30.  If you wish to see the
fractional seconds, specify the format

	    {cmd:%tcDDmonCCYY_HH:MM:SS.sss}
    or
	    {cmd:%tCDDmonCCYY_HH:MM:SS.sss}

{pstd}
as appropriate.


{marker rounding}{...}
    {title:Times are truncated, not rounded, when displayed}

{p 4 4 2}
Consider the time 11:32:59.999.  Other, less precise, ways of writing that time
are

	11:32:59.99
	11:32:59.9
	11:32:59
	11:32

{p 4 4 2}
That is, when you suppress the display of more-detailed components of the time,
the parts that are displayed are not rounded.  Stata displays time just as a
digital clock would; the time is 11:32 right up until the instant that it
becomes 11:33.
{p_end}
