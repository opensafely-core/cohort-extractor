{smcl}
{* *! version 2.0.12  15may2018}{...}
{vieweralsosee "[D] Datetime translation" "mansection D Datetimetranslation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] Datetime" "help datetime"}{...}
{vieweralsosee "[D] Datetime business calendars" "help datetime_business_calendars"}{...}
{vieweralsosee "[D] Datetime display formats" "help datetime_display_formats"}{...}
{viewerjumpto "Syntax" "datetime translation##syntax"}{...}
{viewerjumpto "Description" "datetime translation##description"}{...}
{viewerjumpto "Links to PDF documentation" "datetime_translation##linkspdf"}{...}
{viewerjumpto "Remarks" "datetime translation##remarks"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[D] Datetime translation} {hline 2}}String to numeric date translation functions{p_end}
{p2col:}({mansection D Datetimetranslation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 4 4 2}
The string-to-numeric date and time translation functions are

	    Desired SIF type  {c |}  String-to-numeric translation function
            {hline 18}{c +}{hline 39}
            datetime/c        {c |}        {cmd:clock(}{it:HRFstr}{cmd:,} {it:mask} [{cmd:,} {it:topyear}]{cmd:)}
	    datetime/C        {c |}        {cmd:Clock(}{it:HRFstr}{cmd:,} {it:mask} [{cmd:,} {it:topyear}]{cmd:)}
                              {c |}
            date              {c |}         {cmd:date(}{it:HRFstr}{cmd:,} {it:mask} [{cmd:,} {it:topyear}]{cmd:)}
                              {c |}
            weekly date       {c |}       {cmd:weekly(}{it:HRFstr}{cmd:,} {it:mask} [{cmd:,} {it:topyear}]{cmd:)}
            monthly date      {c |}      {cmd:monthly(}{it:HRFstr}{cmd:,} {it:mask} [{cmd:,} {it:topyear}]{cmd:)}
            quarterly date    {c |}    {cmd:quarterly(}{it:HRFstr}{cmd:,} {it:mask} [{cmd:,} {it:topyear}]{cmd:)}
            half-yearly date  {c |}   {cmd:halfyearly(}{it:HRFstr}{cmd:,} {it:mask} [{cmd:,} {it:topyear}]{cmd:)}
            yearly date       {c |}       {cmd:yearly(}{it:HRFstr}{cmd:,} {it:mask} [{cmd:,} {it:topyear}]{cmd:)}
            {hline 18}{c BT}{hline 39}

{p 4 4 2}
where 

{p 8 8 2}
{it:HRFstr} is the string value (HRF) to be translated,

{p 8 8 2}
            {it:topyear} is described in {it:{help datetime_translation##twodigit:Working with two-digit years}}, below,

{p 8 8 2}
and {it:mask} specifies the order of the date and time components and is a
string composed of a sequence of these elements:

	    Code  {c |} Meaning
	    {hline 6}{c +}{hline 39}
             {cmd:M}    {c |} month
             {cmd:D}    {c |} day within month
             {cmd:Y}    {c |} 4-digit year
	     {cmd:19Y}  {c |} 2-digit year to be interpreted as 19{it:xx}
             {cmd:20Y}  {c |} 2-digit year to be interpreted as 20{it:xx}
                  {c |}
             {cmd:h}    {c |} hour of day
             {cmd:m}    {c |} minutes within hour 
             {cmd:s}    {c |} seconds within minute
                  {c |}
             {cmd:#}    {c |} ignore one element
	    {hline 6}{c BT}{hline 39}

{p 8 8 2}
Blanks are also allowed in {it:mask}, which can make the {it:mask} easier to
read, but they otherwise have no significance.

{p 8 8 2}
Examples of {it:masks} include

{p 12 23 2}
{cmd:"MDY"}{bind:      }{it:HRFstr}
contains month, day, and year, in that order.

{p 12 23 2}
{cmd:"MD19Y"}{bind:    }means the same as {cmd:"MDY"} except that 
{it:HRFstr} may contain two-digit years, and when it does, 
they are to be treated as if they are 4-digit years beginning with 19.

{p 12 23 2}
{cmd:"MDYhms"}{bind:   }{it:HRFstr}
contains month, day, year, hour, minute, and second, in that order.

{p 12 23 2}
{cmd:"MDY hms"}{bind:  }means the same as {cmd:"MDYhms"}; the blank has no
meaning.
  
{p 12 23 2} {cmd:"MDY#hms"}{bind:  }means that one element between the year and
the hour is to be ignored.  For example, {it:HRFstr} contains values like
{cmd:"1-1-2010 at 15:23:17"} or values like {cmd:"1-1-2010 at 3:23:17 PM"}.


{marker description}{...}
{title:Description}

{pstd}
These functions translate dates and times recorded as strings containing human
readable form (HRF) to the desired Stata internal form (SIF).  
See {bf:{help datetime:[D] Datetime}} for an introduction to Stata's
date and time features.

{pstd}
Also see {it:{help datetime##s11:Using dates and times from other software}}
in {bf:{help datetime:[D] Datetime}}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D DatetimetranslationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	    {help datetime_translation##intro:Introduction}
	    {help datetime_translation##mask:Specifying the mask}
	    {help datetime_translation##imask:How the HRF-to-SIF functions interpret the mask}
	    {help datetime_translation##twodigit:Working with two-digit years}
	    {help datetime_translation##incomplete:Working with incomplete dates and times}
	    {help datetime_translation##runtogether:Translating run-together dates, such as 20060125}
	    {help datetime_translation##validtimes:Valid times}
	    {help datetime_translation##fcnclock:The clock() and Clock() functions}
	    {help datetime_translation##whytwo:Why there are two SIF datetime encodings}
	    {help datetime_translation##advice:Advice on using datetime/c and datetime/C}
	    {help datetime_translation##leapsecs:Determining when leap seconds occurred}
	    {help datetime_translation##fcndate:The date() function}
	    {help datetime_translation##fcnother:The other translation functions}


{marker intro}{...}
    {title:Introduction}

{p 4 4 2}
The HRF-to-SIF translation functions are used to translate string 
HRF dates, such as "08/12/06", "12-8-2006", "12 Aug 06",
"12aug2006 14:23", and "12 aug06 2:23 pm", to SIF.  The
HRF-to-SIF translation functions are typically used after importing or reading
data.  You read the date information into string variables and then the
HRF-to-SIF functions translate the string into something Stata can use,
namely, an SIF numeric variable.

{p 4 4 2}
You use {cmd:generate} to create the SIF variables.
The translation functions are used in the expressions, such as 

{p 8 8 2}
. {cmd:generate double time_admitted = clock(time_admitted_str, "DMYhms")}{break}
. {cmd:format time_admitted %tc}

{p 8 8 2}
. {cmd:generate date_hired = date(date_hired_str, "MDY")}{break}
. {cmd:format date_hired %td}

{p 4 4 2}
Every translation function -- such as {cmd:clock()} and {cmd:date()} above --
requires these two arguments: 

{p 8 11 2}
1. the {it:HRFstr} specifying the string to be translated

{p 8 11 2}
2. the {it:mask} specifying the order in which the 
   date and time components appear in {it:HRFstr}

{pstd}
Notes:

{p 8 11 2}
1.  You choose the translation function {cmd:clock()}, {cmd:Clock()},
{cmd:date()}, ... according to the type of SIF value you want returned.

{p 8 11 2}
2.  You specify the mask according to the contents of {it:HRFstr}.

{pstd}
Usually, you will want to translate an
{it:HRFstr} containing "2006.08.13 14:23" to an SIF datetime/c or datetime/C
value and translate an {it:HRFstr} containing "2006.08.13" to an SIF date value.
If you wish, however, it can be the other way around.  In that case, the
detailed string would translate to an SIF date value corresponding to just the
date part, 13aug2006, and the less detailed string would translate to an SIF
datetime value corresponding to 13aug2006 00:00:00.000.


{marker mask}{...}
    {title:Specifying the mask}

{pstd}
An argument {it:mask} is a string specifying the order of the date and time
components in {it:HRFstr}.  Examples of HRF date strings and the mask required
to translate them include the following:

          {it:HRFstr}                       Corresponding mask
	  {hline 52}
          01dec2006 14:22                   {cmd:"DMYhm"}
          01-12-2006 14.22                  {cmd:"DMYhm"}

	  1dec2006 14:22                    {cmd:"DMYhm"}
	  1-12-2006 14:22                   {cmd:"DMYhm"}

          01dec06 14:22                     {cmd:"DM20Yhm"}
          01-12-06 14.22                    {cmd:"DM20Yhm"}

          December 1, 2006 14:22            {cmd:"MDYhm"}

          2006 Dec 01 14:22                 {cmd:"YMDhm"}
          2006-12-01 14:22                  {cmd:"YMDhm"}

          2006-12-01 14:22:43               {cmd:"YMDhms"}
          2006-12-01 14:22:43.2             {cmd:"YMDhms"}
          2006-12-01 14:22:43.21            {cmd:"YMDhms"}
          2006-12-01 14:22:43.213           {cmd:"YMDhms"}

          2006-12-01  2:22:43.213 pm        {cmd:"YMDhms"}  (see {help datetime_translation##note1:note 1})
          2006-12-01  2:22:43.213 pm.       {cmd:"YMDhms"}
          2006-12-01  2:22:43.213 p.m.      {cmd:"YMDhms"}
          2006-12-01  2:22:43.213 P.M.      {cmd:"YMDhms"}

	  20061201 1422                     {cmd:"YMDhm"}

	  14:22                             {cmd:"hm"}      (see {help datetime_translation##note2:note 2})
          2006-12-01                        {cmd:"YMD"} 

	  Fri Dec 01 14:22:43 CST 2006      {cmd:"#MDhms#Y"}
	  {hline 52}

{pstd}
Notes:

{marker note1}{...}
{p 8 11 2}
1. Nothing special needs to be included in {it:mask}
   to process a.m. and p.m. markers.  When you include 
   code {cmd:h}, the HRF-to-SIF functions automatically watch 
   for meridian markers.

{marker note2}{...}
{p 8 11 2}
2. You specify the mask according to what is contained in {it:HRFstr}.
If that is a subset of what the selected SIF type could record, 
the remaining elements are set to their defaults. 
{cmd:clock("14:22", "hm")} produces 01jan1960 14:22:00
and 
{cmd:clock("2006-12-01", "YMD")} produces 01dec2006 00:00:00.
{cmd:date("jan 2006", "MY")} produces 01jan2006.

{p 4 4 2}
{it:mask} may include spaces so that it is more readable; the spaces have no 
meaning.  Thus you can type 

{p 8 8 2}
. {cmd:generate double admit = clock(admitstr, "#MDhms#Y")}

{p 4 4 2}
or type

{p 8 8 2}
. {cmd:generate double admit = clock(admitstr, "# MD hms # Y")}

{p 4 4 2}
and which one you use makes no difference.


{marker imask}{...}
    {title:How the HRF-to-SIF functions interpret the mask}

{p 4 4 2}
The HRF-to-SIF functions apply the following rules when interpreting 
{it:HRFstr}:

{p 8 12 2}
1.  For each HRF string to be translated, remove all punctuation except 
    for the period separating seconds from tenths, hundredths, and 
    thousandths of seconds.  Replace removed punctuation with a space.

{p 8 12 2}
2.  Insert a space in the string everywhere that a letter is next to
    a number, or vice versa.

{p 8 12 2}
3.  Interpret the resulting elements according to {it:mask}.

{p 4 4 2}
For instance, consider the string 

{p 12 12 2}
01dec2006 14:22

{p 4 4 2}
Under rule 1, the string becomes 

{p 12 12 2}
01dec2006 14 22

{p 4 4 2}
Under rule 2, the string becomes 

{p 12 12 2}
01 dec 2006 14 22

{p 4 4 2}
Finally, the HRF-to-SIF functions apply rule 3.  If the mask is {cmd:"DMYhm"},
then the functions interpret "01" as the day, "dec" as the month, and so on.

{p 4 4 2}
Or consider the string

{p 12 12 2}
Wed Dec 01 14:22:43 CST 2006

{p 4 4 2}
Under rule 1, the string becomes 

{p 12 12 2}
Wed Dec 01 14 22 43 CST 2006

{p 4 4 2}
Applying rule 2 does not change the string.  Now rule 3 is applied.
If the mask is {cmd:"#MDhms#Y"}, the translation function skips "Wed",
interprets "Dec" as the month, and so on.

{p 4 4 2}
The {cmd:#} code serves a second purpose.  If it appears at the end 
of the mask, it specifies that the rest of {it:string} is to 
be ignored.  Consider translating the string

{p 12 12 2}
Wed Dec 01 14 22 43 CST 2006 patient 42

{p 4 4 2}
The mask code that previously worked when "patient 42" was not part of the
string, {cmd:"#MDhms#Y"}, will result in a missing value in this case.  The
functions are careful in the translation, and if the whole string is not used,
they return missing.  If you end the mask in {cmd:#}, however, the functions
ignore the rest of the string.  Changing the mask from {cmd:"#MDhms#Y"} to
{cmd:"#MDhms#Y#"} will produce the desired result.


{marker twodigit}{...}
    {title:Working with two-digit years}

{p 4 4 2}
Consider translating the string 01-12-06 14:22, which is to be interpreted as
01dec2006 14:22:00.  The translation functions provide two ways of
doing this.

{p 4 4 2}
The first is to specify the assumed prefix in the mask.  The string
01-12-06 14:22 can be read by specifying the mask 
{cmd:"DM20Yhm"}.  If we instead wanted to interpret the year 
as 1906, we would specify the mask {cmd:"DM19Yhm"}.  We could even 
interpret the year as 1806 by specifying {cmd:"DM18Yhm"}.

{p 4 4 2}
What if our data include 01-12-06 14:22 and include
15-06-98 11:01?  We want to interpret the first year as being in 2006 and 
the second year as being in 1998.  That is the purpose of the optional 
argument {it:topyear}:

{p 12 12 2}
{cmd:clock(}{it:string}{cmd:,} {it:mask} [{cmd:,} {it:topyear}]{cmd:)}

{p 4 4 2}
When you specify {it:topyear}, you are stating that when years in 
{it:string} are two digits, the full year is to be obtained 
by finding the largest year that does not exceed {it:topyear}.
Thus you could code 

{p 8 8 2}
. {cmd:generate double timestamp = clock(timestr, "DMYhm", 2020)}

{p 4 4 2}
The two-digit year 06 would be interpreted as 2006 because 2006 does not
exceed 2020.  The two-digit year 98 would be 
interpreted as 1998 because 2098 does exceed 2020.


{marker incomplete}{...}
    {title:Working with incomplete dates and times}

{p 4 4 2}
The translation functions do not require that every component of the date and
time be specified.

{p 4 4 2}
Translating 2006-12-01 with mask {cmd:"YMD"} results in 01dec2006 00:00:00.

{p 4 4 2}
Translating 14:22 with mask {cmd:"hm"} results in 01jan1960 14:22:00.

{p 4 4 2}
Translating 11-2006 with mask {cmd:"MY"} results in 01nov2006 00:00:00.

{p 4 4 2}
The default for a component, if not specified in the mask, is


            Code  {c |} Default (if not specified)
	    {hline 6}{c +}{hline 27}
             {cmd:M}    {c |} 01
             {cmd:D}    {c |} 01
             {cmd:Y}    {c |} 1960
                  {c |}
             {cmd:h}    {c |} 00
             {cmd:m}    {c |} 00
             {cmd:s}    {c |} 00
	    {hline 6}{c BT}{hline 27}

{p 4 4 2}
Thus if you have data recording "14:22", meaning a
duration of 14 hours and 22 minutes or the time 14:22 each day, 
you can translate it with {cmd:clock(}{it:HRFstr}{cmd:,} {cmd:"hm")}.  
See
{it:{help datetime##s10:Obtaining and working with durations}}
in
{bf:{help datetime:[D] Datetime}}.


{marker runtogether}{...}
    {title:Translating run-together dates, such as 20060125}

{p 4 4 2}
The translation functions will translate dates and times that are run
together, such as 20060125, 060125, and 20060125110215 (which is 25jan2006
11:02:15).  You do not have to do anything special to translate them:

	. {cmd:display %d date("20060125", "YMD")}
	25jan2006

	. {cmd:display %td date("060125", "20YMD")}
	25jan2006

	. {cmd:display %tc clock("20060125110215", "YMDhms")}
	25jan2006 11:02:15

{p 4 4 2}
In a data context, you could type

	. {cmd:gen startdate = date(startdatestr, "YMD")}

	. {cmd:gen double starttime = clock(starttimestr, "YMDhms")}

{p 4 4 2}
Remember to read the original date into a string.  If you mistakenly 
read the date as
numeric, the best advice is to read the date again.  Numbers such as 
20060125 and 20060125110215 will be rounded unless they are stored as 
{cmd:double}s.

{p 4 4 2}
If you mistakenly read the variables as numeric and have verified that
rounding did not occur, you can convert the variable from numeric to string
by using the {cmd:string()} function, which comes in one- and two-argument
forms.  You will need the two-argument form:

	. {cmd:gen str startdatestr = string(startdatedouble, "%10.0g")}

	. {cmd:gen str starttimestr = string(starttimedouble, "%16.0g")}

{p 4 4 2}
If you omitted the format, {cmd:string()} would produce 2.01e+07 for 20060125
and 2.01e+13 for 20060125110215.  The format we used had a width that was 2
characters larger than the length of the integer number, although using a
too-wide format does no harm.


{marker validtimes}{...}
    {title:Valid times}

{p 4 4 2}
27:62:90 is an invalid time.  If you try to convert 27:62:90 to a datetime
value, you will obtain  a missing value.

{p 4 4 2}
24:00:00 is also invalid.  A correct time would be 00:00:00 of the next day.

{p 4 4 2}
In {it:hh}:{it:mm}:{it:ss}, the requirements are 
0 <= {it:hh} < 24, 
0 <= {it:mm} < 60, 
and 
0 <= {it:ss} < 60, although sometimes 60 is allowed.
31dec2005 23:59:60 is an invalid datetime/c but a valid datetime/C.
31dec2005 23:59:60 includes an inserted leap second.

{p 4 4 2}
30dec2005 23:59:60 is invalid in both datetime encodings.
30dec2005 23:59:60 did not include an inserted leap second.  A correct 
datetime would be 31dec2005 00:00:00.


{marker fcnclock}{...}
    {title:The clock() and Clock() functions}

{p 4 4 2}
Stata provides two separate datetime encodings that we call SIF datetime/c
and SIF datetime/C and that others would call "times assuming 86,400 seconds
per day" and "times adjusted for leap seconds" or, equivalently, UTC times.

{pstd}
The syntax of the two functions is the same: 

{p 12 12 2}
{cmd:clock(}{it:HRFstr}{cmd:,} {it:mask} [{cmd:,} {it:topyear}]{cmd:)}

{p 12 12 2}
{cmd:Clock(}{it:HRFstr}{cmd:,} {it:mask} [{cmd:,} {it:topyear}]{cmd:)}

{pstd}
Function {cmd:Clock()} is nearly identical to function {cmd:clock()},
except that {cmd:Clock()} returns a datetime/C value rather than 
a datetime/c value.  For instance,

       Noon of 23nov2010 = 1,606,132,800,000  in datetime/c
                         = 1,606,132,824,000  in datetime/C

{pstd} 
They differ because 24 seconds have been inserted into datetime/C between
01jan1960 and 23nov2010.  Correspondingly, {cmd:Clock()} understands times in
which there are leap seconds, such as 30jun1997 23:59:60.  {cmd:clock()} would
consider 30jun1997 23:59:60 an invalid time and so return a missing value.


{marker whytwo}{...}
    {title:Why there are two SIF datetime encodings}

{p 4 4 2}
Stata provides two different datetime encodings, SIF datetime/c and SIF
datetime/C.

{p 4 4 2}
SIF datetime/c assumes that there are 24*60*60*1000 ms per day, just
as an atomic clock does.  Atomic clocks count oscillations between the nucleus
and the electrons of an atom and thus provide a measurement of the real passage 
of time.

{p 4 4 2}
Time of day measurements have historically been based on astronomical
observation, which is a fancy way of saying that the measurements are based on
looking at the sun.  The sun should be at its highest point at noon, right?  So
however you might have kept track of time -- by falling grains of sand or a
wound-up spring -- you would have periodically reset your clock and then gone
about your business.  In olden times, it was understood that the 60 seconds per
minute, 60 minutes per hour, and 24 hours per day were theoretical goals that
no mechanical device could reproduce accurately.  These days, we have more
formal definitions for measurements of time.  One second is 9,192,631,770
periods of the radiation corresponding to the transition between two levels of
the ground state of cesium 133.  Obviously, we have better equipment than the
ancients, so problem solved, right?  Wrong.  There are two problems: the formal
definition of a second is just a little too short to use for accurately
calculating the length of a day, and the Earth's rotation is slowing down.

{p 4 4 2}
As a result, since 1972, leap seconds have been added to atomic clocks once or
twice a year to keep time measurements in synchronization with Earth's
rotation.  Unlike leap years, however, there is no formula for predicting when
leap seconds will occur.  Earth may be on average slowing down, but there
is a large random component to that.  As a result, leap seconds are determined
by committee and announced 6 months before they are inserted.  Leap seconds are
added, if necessary, on the end of the day on June 30 and December 31 of the 
year.  The exact times are designated as 23:59:60.

{p 4 4 2}
Unadjusted atomic clocks may accurately mark the passage of real time, but you
need to understand that leap seconds are every bit as real as every other
second of the year.  Once a leap second is inserted, it ticks just like any
other second and real things can happen during that tick.

{p 4 4 2}
You may have heard of terms such as GMT and UTC.  

{p 4 4 2}
GMT is the old Greenwich Mean Time that is based on astronomical observation.
GMT has been replaced by UTC.

{p 4 4 2}
UTC stands for coordinated universal time. It is measured by atomic clocks
and is occasionally corrected for leap seconds.
UTC is derived from two other times, UT1 and TAI.
UT1 is the mean solar time, with which UTC is kept in sync by the 
occasional addition of a leap second.
TAI is the atomic time on which UTC is based.
TAI is a statistical combination of various atomic chronometers and
even it has not ticked uniformly over its history; see
{browse "http://www.ucolick.org/~sla/leapsecs/timescales.html":http://www.ucolick.org/~sla/leapsecs/timescales.html}
and especially
{browse "http://www.ucolick.org/~sla/leapsecs/dutc.html#TAI":http://www.ucolick.org/~sla/leapsecs/dutc.html#TAI}.

{p 4 4 2}
UNK is our term for the time standard most people use.  UNK stands for
unknown or unknowing.  UNK is based on a recent time observation, probably
UTC, and it just assumes that there are 86,400 seconds per day
after that.

{p 4 4 2}
The UNK standard is adequate for many purposes, and when using it you will
want to use SIF datetime/c rather than the leap second-adjusted datetime/C
encoding.  If you are using computer-timestamped data, however, you need to
find out whether the timestamping system accounted for leap-second adjustment.
Problems can arise even if you do not care about losing or gaining a second
here and there.

{p 4 4 2}
For instance, you may import from other systems timestamp values recorded in
the number of milliseconds that have passed since some agreed upon date.  You
may do this, but if you choose the wrong encoding scheme (choose datetime/c
when you should choose datetime/C, or vice versa), more recent times will be
off by 24 seconds.

{p 4 4 2}
To avoid such problems, you may decide to import and export data by using
HRF such as "Fri Aug 18 14:05:36 CDT 2010".  This
method has advantages, but for datetime/C (UTC) encoding, times such as
23:59:60 are possible.  Some systems will refuse to decode such times.

{p 4 4 2}
Stata refuses to decode 23:59:60 in the datetime/c encoding (function
{cmd:clock()}) and accepts it with datetime/C (function {cmd:Clock()}).  When
datetime/C function {cmd:Clock()} sees a time with a 60th second,
{cmd:Clock()} verifies that the time is one of the official leap seconds.
Thus when translating from printable forms, try assuming datetime/c and check
the result for missing values.  If there are none, then you can assume your
use of datetime/c was valid.  If there are missing values and they are due to
leap seconds and not some other error, however, you must use datetime/C
{cmd:Clock()} to translate the HRF.  After that, if you still want to work in
datetime/c units, use function {cmd:cofC()} to translate datetime/C values
into datetime/c.

{p 4 4 2}
If precision matters, the best way to process datetime/C data is simply to
treat them that way.  The inconvenience is that you cannot assume that there
are 86,400 seconds per day.  To obtain the duration between dates, you must
subtract the two time values involved.  The other difficulty has to do with
dealing with dates in the future.  Under the datetime/C (UTC) encoding, there
is no set value for any date more than six months in the future.
Below is a summary of advice.


{marker advice}{...}
    {title:Advice on using datetime/c and datetime/C}

{p 4 4 2}
Stata provides two datetime encodings:

{p 8 13 2}
1. datetime/C, also known as UTC, which accounts for leap seconds

{p 8 8 2}
2. datetime/c, which ignores leap seconds (it assumes 86,400 seconds/day)

{p 4 4 2}
Systems vary in how they treat time variables.  SAS ignores leap seconds.
Oracle includes them.  Stata handles either situation.
Here is our advice:

{p 8 12 2}
    o  If you obtain data from a system that accounts for 
        leap seconds, import using Stata's datetime/C encoding.

{p 12 16 2}
           a.  If you later need to export data to a system that does not
               account for leap seconds, use Stata's {cmd:cofC()} function to
               translate time values before exporting.

{p 12 16 2}
           b.  If you intend to {cmd:tsset} the time variable and 
               the analysis will be at the 
               second level or finer, just {cmd:tsset} the datetime/C
               variable, specifying the appropriate {cmd:delta()}
               if necessary -- for example, {cmd:delta(1000)} for 
               seconds.

{p 12 16 2}
           c.  If you intend to {cmd:tsset} the time variable and 
               the analysis will be coarser than the second level 
               (minute, hour, etc.), 
               create a datetime/c variable from the datetime/C variable
               ({cmd:generate} {cmd:double} {it:tctime} = 
               {cmd:cofC(}{it:tCtime}{cmd:)}) and {cmd:tsset} that, 
               specifying the appropriate {cmd:delta()} if necessary.
               You must do that because in a datetime/C variable,
               there are not necessarily 60 seconds in a minute; 
               some minutes have 61 seconds.

{p 8 12 2}
    o  If you obtain data from a system that ignores leap seconds, 
        use Stata's datetime/c encoding.

{p 12 16 2}
            a.  If you later need to export data to a system that does account
                for leap seconds, use Stata's {cmd:Cofc()} function to
                translate time values before exporting.

{p 12 16 2}
            b.  If you intend to {cmd:tsset} the time variable, just 
                {cmd:tsset} it, specifying the appropriate {cmd:delta()}.

{p 4 4 2}
Some users prefer always to use Stata's datetime/c because {cmd:%tc}
values are a little easier to work with.  You can always use datetime/c if 
    
{p 8 12 2}
o  you do not mind having up to 1 second of error and

{p 8 12 2}
o  you do not import or export numerical values (clock ticks) from other
    systems that are using leap seconds, because doing so could introduce
    nearly 30 seconds of error.

{p 4 4 2}
Remember these two things if you use datetime/C variables:

{p 8 12 2}
1.  The number of seconds between two dates is a function of when the 
    dates occurred.  Five days from one date is not simply a matter of 
    adding 5*24*60*60*1000 ms.  You might need to add another 
    1,000 ms.  Three hundred sixty-five days from now might
    require adding 1,000 or 2,000 ms.  The longer the span, the more
    you might have to add.  The best way to add durations to datetime/C 
    variables is to extract the components, add to them, and then reconstruct
    from the numerical components.

{p 8 12 2}
2.  You cannot accurately predict datetimes more than six months into the
    future.  We do not know what the datetime/C value of 25dec2026 00:00:00
    will be because every year along the way, the International Earth Rotation
    Reference Systems Service (IERS) will twice announce whether a leap second
    will be inserted.

{pstd}
You can help alleviate these inconveniences.  Face west and throw rocks.
The benefit will be transitory only if the rocks land back on Earth, so 
you need to throw them really hard.  We know what you are thinking, but 
this does not need to be a coordinated effort.


{marker leapsecs}{...}
    {title:Determining when leap seconds occurred}

{p 4 4 2}
Stata system file {cmd:leapseconds.maint} lists the dates on which leap
seconds occurred.  The file is updated periodically (see 
{manhelp update R}; the file is updated when you 
{cmd:update all}), and Stata's datetime/C functions access the 
file to know when leap seconds occurred.

{p 4 4 2}
You can access it, too.  To view the file, type 

	. {bf:{view leapseconds.maint, adopath asis:viewsource leapseconds.maint}}


{marker fcndate}{...}
    {title:The date() function}

{p 4 4 2}
The syntax of the {cmd:date()} function is 

{p 12 12 2}
{cmd:date(}{it:string}{cmd:,} {it:mask} [{cmd:,} {it:topyear}]{cmd:)}

{p 4 4 2}
The {cmd:date()} function is identical to {cmd:clock()} except that
{cmd:date()} returns an SIF date value rather than a datetime value.  The
{cmd:date()} function is the same as {cmd:dofc(clock())}.

{pstd}
{cmd:daily()} is a synonym for {cmd:date()}.


{marker fcnother}{...}
    {title:The other translation functions}

{p 4 4 2}
The other translation functions are

	    SIF type          {c |}  HRF-to-SIF translation function
            {hline 18}{c +}{hline 38}
            weekly date       {c |}      {cmd:weekly(}{it:HRFstr}{cmd:,} {it:mask} [{cmd:,} {it:topyear}]{cmd:)}
            monthly date      {c |}     {cmd:monthly(}{it:HRFstr}{cmd:,} {it:mask} [{cmd:,} {it:topyear}]{cmd:)}
            quarterly date    {c |}   {cmd:quarterly(}{it:HRFstr}{cmd:,} {it:mask} [{cmd:,} {it:topyear}]{cmd:)}
            half-yearly date  {c |}  {cmd:halfyearly(}{it:HRFstr}{cmd:,} {it:mask} [{cmd:,} {it:topyear}]{cmd:)}
            {hline 18}{c BT}{hline 38}
            {it:HRFstr} is the value to be translated. 
            {it:mask} specifies the order of the components.
            {it:topyear} is described in {it:{help datetime_translation##twodigit:Working with two-digit years}}, above.

{p 4 4 2}
These functions are rarely used because data seldom arrive in these 
formats.

{p 4 4 2}
Each of the functions translates a pair of numbers: {cmd:weekly()} translates a
year and a week number (1-52), {cmd:monthly()} translates a year and a month
number (1-12), {cmd:quarterly()} translates a year and a quarter number (1-4),
and {cmd:halfyearly()} translates a year and a half number (1-2).

{p 4 4 2}
The masks allowed are far more limited than the masks for {cmd:clock()},
{cmd:Clock()}, and {cmd:date()}:

	    Code  {c |} Meaning
	    {hline 6}{c +}{hline 39}
             {cmd:Y}    {c |} 4-digit year
	     {cmd:19Y}  {c |} 2-digit year to be interpreted as 19{it:xx}
             {cmd:20Y}  {c |} 2-digit year to be interpreted as 20{it:xx}
                  {c |}
             {cmd:W}    {c |} week number       ({cmd:weekly()} only)
             {cmd:M}    {c |} month number      ({cmd:monthly()} only)
             {cmd:Q}    {c |} quarter number    ({cmd:quarterly()} only)
             {cmd:H}    {c |} half-year number  ({cmd:halfyearly()} only)
	    {hline 6}{c BT}{hline 39}
            The pair of numbers to be translated must be
            separated by a space or punctuation.  No extra
            characters are allowed.
