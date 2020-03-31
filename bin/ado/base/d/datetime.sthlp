{smcl}
{* *! version 2.1.20  07oct2019}{...}
{vieweralsosee "[D] Datetime" "mansection D Datetime"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] Datetime business calendars" "help datetime_business_calendars"}{...}
{vieweralsosee "[D] Datetime display formats" "help datetime_display_formats"}{...}
{vieweralsosee "[D] Datetime translation" "help datetime_translation"}{...}
{viewerjumpto "Syntax" "datetime##syntax"}{...}
{viewerjumpto "Description" "datetime##description"}{...}
{viewerjumpto "Links to PDF documentation" "datetime##linkspdf"}{...}
{viewerjumpto "Remarks" "datetime##remarks"}{...}
{p2colset 1 17 26 2}{...}
{p2col:{bf:[D] Datetime} {hline 2}}Date and time values and
variables{p_end}
{p2col:}({mansection D Datetime:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 4 4 2}
Syntax is presented under the following headings:
    
	{help datetime##s1:Types of dates and their human readable forms (HRFs)}
	{help datetime##s2:Stata internal form (SIF)}
	{help datetime##s3:HRF-to-SIF conversion functions}
	{help datetime##s4:Displaying SIFs in HRF}
	{help datetime##s5:Building SIFs from components}
	{help datetime##s6:SIF-to-SIF conversion}
	{help datetime##s7:Extracting time-of-day components from SIFs}
	{help datetime##s8:Extracting date components from SIFs}
	{help datetime##s9:Conveniently typing SIF values}
        {help datetime##s10:Obtaining and working with durations}
        {help datetime##s11:Using dates and times from other software}

{p 4 4 2}
Also see

{p2colset 9 39 41 2}{...}
{synopt: {bf:{help datetime_translation:[D] Datetime translation}}}String to
     numeric date translation functions
{p_end}
{synopt:{bf:{help datetime_display_formats:[D] Datetime display formats}}}Display
       formats for dates and times
{p_end}
{p2colreset}{...}


{marker s1}{...}
    {title:Types of dates and their human readable forms (HRFs)}

         Date type         Examples of HRFs
	 {hline 44}
         datetime          20jan2010 09:15:22.120  

         date              20jan2010, 20/01/2010, ...
 
         weekly date       2010w3
         monthly date      2010m1
         quarterly date    2010q1
         half-yearly date  2010h1
         yearly date       2010
	 {hline 44}

{pstd}
     The styles of the HRFs in the table above are merely examples.
     Perhaps you prefer 2010.01.20; Jan. 20, 2010; 2010-1; etc.

{pstd}
     With the exception of yearly dates, HRFs are usually stored in string
     variables. If you are reading raw data, read the HRFs into strings.

{pstd}
     HRFs are not especially useful except for reading by humans, and 
     thus Stata provides another way of recording dates called 
     Stata internal form (SIF).  You can convert HRF dates to SIF.


{marker s2}{...}
    {title:Stata internal form (SIF)}

{pstd}The numeric values in the table below are equivalent to the 
string values in the table in the
{help datetime##s1:previous section}.

         SIF type        Examples in SIF       Units
	 {hline 65}
         datetime/c      1,579,598,122,120     milliseconds since 
                                               01jan1960 00:00:00.000, 
					       assuming 86,400 s/day

	 datetime/C      1,579,598,146,120     milliseconds since 
                                               01jan1960 00:00:00.000, 
                                               adjusted for leap seconds*
    
         date                       18,282     days since 01jan1960
                                               (01jan1960 = 0)
     
         weekly date                 2,601     weeks since 1960w1
         monthly date                  600     months since 1960m1
         quarterly date                200     quarters since 1960q1
         half-yearly date              100     half-years since 1960h1
         yearly date                  2010     years since 0000
	 {hline 65}
{p 9 13 2}
* SIF datetime/C is equivalent to coordinated universal time (UTC).
             In UTC, leap seconds are periodically inserted 
             because the length of the mean solar day is slowly increasing.
             See {it:{help datetime_translation##whytwo:Why there are two SIF datetime encodings}}
             in {bf:{help datetime_translation:[D] Datetime translation}}.
             
{pstd}
    SIF values are stored as regular Stata numeric variables.

{pstd}
    You can convert HRFs into SIFs by using HRF-to-SIF conversion functions; see 
    the next section, called {it:{help datetime##s3:HRF-to-SIF conversion functions}}.

{pstd}
    You can make the numeric SIF readable by placing 
    the appropriate {cmd:%}{it:fmt} on the numeric variable; see
    {it:{help datetime##s4:Displaying SIFs in HRF}}, below.

{pstd}
    You can convert from one SIF type to another by using 
    SIF-to-SIF conversion functions; see
    {it:{help datetime##s6:SIF-to-SIF conversion}},
    below.

{pstd}
    SIF dates are convenient because you can subtract them to obtain time
    between dates, for example,

     datetime2 - datetime1 = milliseconds between datetime1 and datetime2
                             (divide by 1,000 to obtain seconds)

         date2 - date1     = days between date1 and date2

         week2 - week1     = weeks between week1 and week2

        month2 - month1    = months between month1 and month2

         half2 - half1     = half-years between half1 and half2

         year2 - year1     = years between year1 and year2

{pstd}
    In the remaining text, we will use the following notation:

	{it:tc}: a Stata double variable containing SIF datetime/c values
	{it:tC}: a Stata double variable containing SIF datetime/C values

	{it:td}: a Stata variable containing SIF date values

        {it:tw}: a Stata variable containing SIF weekly date values
        {it:tm}: a Stata variable containing SIF monthly date values
        {it:tq}: a Stata variable containing SIF quarterly date values
        {it:th}: a Stata variable containing SIF half-yearly date values
        {it:ty}: a Stata variable containing SIF yearly date values
 

{marker s3}{...}
    {title:HRF-to-SIF conversion functions}

{* In this table, "half-year" cannot be changed to "half-yearly" because it will not fit.}{...}
{* The table cannot be increased.}{...}
                        Function to convert
        SIF type        HRF to SIF                     Note
	{hline 69}
        datetime/c      {it:tc} =      {cmd:clock(}{it:HRFstr}{cmd:,} {it:mask}{cmd:)}  {it:tc} must be {cmd:double}
        datetime/C      {it:tC} =      {cmd:Clock(}{it:HRFstr}{cmd:,} {it:mask}{cmd:)}  {it:tC} must be {cmd:double}

        date            {it:td} =       {cmd:date(}{it:HRFstr}{cmd:,} {it:mask}{cmd:)}  {it:td} may be {cmd:float} or
                                                                  {cmd:long}

        weekly date     {it:tw} =     {cmd:weekly(}{it:HRFstr}{cmd:,} {it:mask}{cmd:)}  {it:tw} may be {cmd:float} or {cmd:int}
        monthly date    {it:tm} =    {cmd:monthly(}{it:HRFstr}{cmd:,} {it:mask}{cmd:)}  {it:tm} may be {cmd:float} or {cmd:int}
        quarterly date  {it:tq} =  {cmd:quarterly(}{it:HRFstr}{cmd:,} {it:mask}{cmd:)}  {it:tq} may be {cmd:float} or {cmd:int}
        half-year date  {it:th} = {cmd:halfyearly(}{it:HRFstr}{cmd:,} {it:mask}{cmd:)}  {it:th} may be {cmd:float} or {cmd:int}
        yearly date     {it:ty} =     {cmd:yearly(}{it:HRFstr}{cmd:,} {it:mask}{cmd:)}  {it:ty} may be {cmd:float} or {cmd:int}
	{hline 69}
{p 8 8 2}
        Warning: To prevent loss of precision, datetime SIFs 
        must be stored as {cmd:double}s.

{pstd}
Examples:

{p 8 11 2}
1. You have datetimes stored in the string variable {cmd:mystr}, an example
   being "{bf:2010.07.12 14:32}".  To convert to SIF datetime/c, you type

{col 16}{cmd:. gen double eventtime = clock(mystr, "YMDhm")}

{p 11 11 2}
The mask {cmd:"YMDhm"} specifies the order of the datetime components. In this 
case, they are year, month, day, hour, and minute.

{p 8 12 2}
2. You have datetimes stored in {cmd:mystr}, an example being 
   "{bf:2010.07.12 14:32:12}".  You type 

{col 16}{cmd:. gen double eventtime = clock(mystr, "YMDhms")}

{p 11 11 2}
   Mask element {cmd:s} specifies seconds.  In example 1, there were no
   seconds; in this example, there are.

{p 8 11 2}
3. You have datetimes stored in {cmd:mystr}, an example being 
   "{bf:2010 Jul 12 14:32}".  You type 

{col 16}{cmd:. gen double eventtime = clock(mystr, "YMDhm")}

{p 11 11 2}
    This is the same command that you typed in example 1.  In the mask,
    you specify the order of the components; Stata figures out the style for
    itself.  In example 1, months were numeric.  In this example, they are
    spelled out (and happen to be abbreviated).

{p 8 11 2}
4. You have datetimes stored in {cmd:mystr}, an example being 
    "{bf:July 12, 2010 2:32 PM}".  You type 

{col 16}{cmd:. gen double eventtime = clock(mystr, "MDYhm")}

{p 12 12 2}
    Stata automatically looks for AM and PM, 
    in uppercase and lowercase, with and without periods.

{p 8 11 2}
5. You have datetimes stored in {cmd:mystr}, an example being 
   "{bf:7-12-10 14.32}".  The 2-digit year is to be interpreted as 
   being prefixed with 20.  You type 

{col 16}{cmd:. gen double eventtime = clock(mystr, "MD20Yhm")}

{p 8 11 2}
6. You have datetimes stored in {cmd:mystr}, an example being 
   "{bf:14:32 on 7/12/2010}".  You type
    
{col 16}{cmd:. gen double eventtime = clock(mystr, "hm#MDY")}

{p 11 11 2}
    The {cmd:#} sign between {cmd:m} and {cmd:M} means, "ignore one thing
    between minute and month", which in this case is the word "on".
    Had you omitted the {cmd:#} from the mask, the new variable {cmd:eventtime} 
    would have contained missing values.

{p 8 11 2}
7. You have a date stored in {cmd:mystr}, an example being "{bf:22/7/2010}". 
   In this case, you want to create an SIF date instead of a datetime.
   You type

{col 16}{cmd:. gen eventdate = date(mystr, "DMY")}

{p 12 12 2}
    Typing 
  
{col 16}{cmd:. gen double eventtime = clock(mystr, "DMY")}

{p 12 12 2}
    would have worked, too.  Variable {cmd:eventtime} would contain 
    a different coding from that contained by {cmd:eventdate}; namely,
    it would contain 
    milliseconds from 1jan1960 rather than days (1,595,376,000,000 rather than
    18,465).  Datetime value 1,595,376,000,000 corresponds to
    22jul2010 00:00:00.000.

{pstd}
See {bf:{help datetime_translation:[D] Datetime translation}} 
for more information about the HRF-to-SIF conversion functions.


{marker s4}{...}
    {title:Displaying SIFs in HRF}

                          Display format to 
         SIF type         present SIF in HRF
	 {hline 35}
         datetime/c            {cmd:%tc}
         datetime/C            {cmd:%tC}

         date                  {cmd:%td}

         weekly date           {cmd:%tw}
         monthly date          {cmd:%tm}
         quarterly date        {cmd:%tq}
         half-yearly date      {cmd:%th}
         yearly date           {cmd:%ty}
	 {hline 35}

{pstd}
The display formats above are the simplest forms of each of the SIFs.
You can control how each type of SIF date is displayed;
see {bf:{help datetime_display_formats:[D] Datetime display formats}}.

{pstd}
Examples:

{p 8 11 2}
1. You have datetimes stored in string variable {cmd:mystr}, an example being
   "{bf:2010.07.12 14:32}".  To convert to SIF datetime/c and 
   make the new variable readable when displayed, you type 

{col 16}{cmd:. gen double eventtime = clock(mystr, "YMDhm")}
{col 16}{cmd:. format eventtime %tc}

{p 8 11 2}
2. You have a date stored in {cmd:mystr}, an example being "{bf:22/7/2010}". 
   To convert to SIF date and make the new variable readable when 
   displayed, you type 

{col 16}{cmd:. gen eventdate = date(mystr, "DMY")}
{col 16}{cmd:. format eventdate %td}


{marker s5}{...}
    {title:Building SIFs from components}

                           Function to build
        SIF type           from components
	{hline 48}
        datetime/c         {it:tc} = {cmd:mdyhms(}{it:M}{cmd:,} {it:D}{cmd:,} {it:Y}{cmd:,} {it:h}{cmd:,} {it:m}{cmd:,} {it:s}{cmd:)}
                           {it:tc} = {cmd:dhms(}{it:td}{cmd:,} {it:h}{cmd:,} {it:m}{cmd:,} {it:s}{cmd:)}
                           {it:tc} = {cmd:hms(}{it:h}{cmd:,} {it:m}{cmd:,} {it:s}{cmd:)}

        datetime/C         {it:tC} = {cmd:Cmdyhms(}{it:M}{cmd:,} {it:D}{cmd:,} {it:Y}{cmd:,} {it:h}{cmd:,} {it:m}{cmd:,} {it:s}{cmd:)}
                           {it:tC} = {cmd:Cdhms(}{it:td}{cmd:,} {it:h}{cmd:,} {it:m}{cmd:,} {it:s}{cmd:)}
                           {it:tC} = {cmd:Chms(}{it:h}{cmd:,} {it:m}{cmd:,} {it:s}{cmd:)}

        date               {it:td} = {cmd:mdy(}{it:M}{cmd:,} {it:D}{cmd:,} {it:Y}{cmd:)}

        weekly date        {it:tw} = {cmd:yw(}{it:Y}{cmd:,} {it:W}{cmd:)}
        monthly date       {it:tm} = {cmd:ym(}{it:Y}{cmd:,} {it:M}{cmd:)}
        quarterly date     {it:tq} = {cmd:yq(}{it:Y}{cmd:,} {it:Q}{cmd:)}
        half-yearly date   {it:th} = {cmd:yh(}{it:Y}{cmd:,} {it:H}{cmd:)}
        yearly date        {it:ty} = {cmd:y(}{it:Y}{cmd:)}
	{hline 48}
        Warning: SIFs for datetimes must be stored as {cmd:double}s.

{pstd}
Examples:

{p 8 11 2}
1. Your dataset has three variables, {cmd:mo}, {cmd:da}, and {cmd:yr},
   with each variable containing a date component in numeric form.  To convert
   to SIF date, you type 

{col 16}{cmd:. gen eventdate = mdy(mo, da, yr)}
{col 16}{cmd:. format eventdate %td}

{p 8 11 2}
2. Your dataset has two numeric variables, {cmd:mo} and {cmd:yr}.
   To convert to SIF date corresponding to the first day of the month, you type 

{col 16}{cmd:. gen eventdate = mdy(mo, 1, yr)}
{col 16}{cmd:. format eventdate %td}

{p 8 11 2}
3. Your dataset has two numeric variables, {cmd:da} and {cmd:yr}, and one
   string variable, {cmd:month}, containing the spelled-out month.  In this
   case, do not use the building-from-component functions.  Instead, construct
   a new string variable containing the HRF and then convert the string using
   the HRF-to-SIF conversion functions:

{col 16}{cmd:. gen str work  = month + " " + string(da) + " " + string(yr)}
{col 16}{cmd:. gen eventdate = date(work, "MDY")}
{col 16}{cmd:. format eventdate %td}


{marker s6}{...}
    {title:SIF-to-SIF conversion}

                   {c |} To:
       From:       {c |}     datetime/c   datetime/C   date
       {hline 12}{c +}{hline 42}
       datetime/c  {c |}                  {it:tC}={cmd:Cofc(}{it:tc}{cmd:)}  {it:td}={cmd:dofc(}{it:tc}{cmd:)}
       datetime/C  {c |}     {it:tc}={cmd:cofC(}{it:tC}{cmd:)}               {it:td}={cmd:dofC(}{it:tC}{cmd:)}
       date        {c |}     {it:tc}={cmd:cofd(}{it:td}{cmd:)}  {it:tC}={cmd:Cofd(}{it:td}{cmd:)}  
       weekly      {c |}                               {it:td}={cmd:dofw(}{it:tw}{cmd:)}
       monthly     {c |}                               {it:td}={cmd:dofm(}{it:tm}{cmd:)}
       quarterly   {c |}                               {it:td}={cmd:dofq(}{it:tq}{cmd:)}
       half-yearly {c |}                               {it:td}={cmd:dofh(}{it:th}{cmd:)}
       yearly      {c |}                               {it:td}={cmd:dofy(}{it:ty}{cmd:)}
       {hline 12}{c BT}{hline 42}


                   {c |} To:
       From:       {c |}     weekly       monthly      quarterly 
       {hline 12}{c +}{hline 42}
       date        {c |}     {it:tw}={cmd:wofd(}{it:td}{cmd:)}  {it:tm}={cmd:mofd(}{it:td}{cmd:)}  {it:tq}={cmd:qofd(}{it:td}{cmd:)}
       {hline 12}{c BT}{hline 42}


                   {c |} To:
       From:       {c |}     half-yearly  yearly
       {hline 12}{c +}{hline 42}
       date        {c |}     {it:th}={cmd:hofd(}{it:td}{cmd:)}  {it:ty}={cmd:yofd(}{it:td}{cmd:)}
       {hline 12}{c BT}{hline 42}

{pstd}
       To convert between missing entries, use two functions, 
       going through date or datetime as appropriate.  For example, 
       quarterly of monthly is {cmd:tq}={cmd:qofd(dofm(}{it:tm}{cmd:))}.

{pstd} 
Examples:

{p 8 11 2}
1. You have the SIF datetime/c variable {cmd:eventtime} and wish to create 
   the new variable {cmd:eventdate} containing just the date from the 
   datetime variable.  You type

{col 16}{cmd:. gen eventdate = dofc(eventtime)}
{col 16}{cmd:. format eventdate %td}

{p 8 11 2}
2. You have the SIF date variable {cmd:eventdate} and wish to create 
   the new SIF datetime/c variable {cmd:eventtime} from it.  You type

{col 16}{cmd:. gen double eventtime = cofd(eventdate)}
{col 16}{cmd:. format eventtime %tc}

{p 11 11 2}
The time components of the new variable will be set to the default 
00:00:00.000.

{p 8 11 2}
3. You have the SIF quarterly variable {cmd:eventqtr} and wish to create 
   the new SIF date variable {cmd:eventdate} from it.  You type

{col 16}{cmd:. gen eventdate = dofq(eventqtr)}
{col 16}{cmd:. format eventdate %tq}

{p 11 11 2}
The new variable, {cmd:eventdate}, will contain 01jan dates for quarter 1, 
01apr dates for quarter 2, 01jul dates for quarter 3, and 01oct dates 
for quarter 4.

{p 8 11 2}
4. You have the SIF datetime/c variable {cmd:admittime} and wish to 
   create the new SIF quarterly variable {cmd:admitqtr} from it.  You type

{col 16}{cmd:. gen admitqtr = qofd(dofc(admittime))}
{col 16}{cmd:. format admitqtr %tq}

{p 11 11 2}
Because there is no {cmd:qofc()} function, you use {cmd:qofd(dofc())}.


{marker s7}{...}
    {title:Extracting time-of-day components from SIFs}

       Desired component      Function                   Example
       {hline 57}
       hour of day            {cmd:hh(}{it:tc}{cmd:)} or {cmd:hhC(}{it:tC}{cmd:)}          14
       minutes of day         {cmd:mm(}{it:tc}{cmd:)} or {cmd:mmC(}{it:tC}{cmd:)}          42
       seconds of day         {cmd:ss(}{it:tc}{cmd:)} or {cmd:ssC(}{it:tC}{cmd:)}          57.123
       {hline 57}
       Notes:
              0 <= {cmd:hh(}{it:tc}{cmd:)} <= 23, 0 <= {cmd:hhC(}{it:tC}{cmd:)} <= 23
              0 <= {cmd:mm(}{it:tc}{cmd:)} <= 59, 0 <= {cmd:mmC(}{it:tC}{cmd:)} <= 59
              0 <= {cmd:ss(}{it:tc}{cmd:)} <  60, 0 <= {cmd:ssC(}{it:tC}{cmd:)} <  61  (sic)

{pstd}
Example:

{p 8 11 2}
1. You have the SIF datetime/c variable {cmd:admittime}. 
   You wish to create the new variable {cmd:admithour} equal to the hour and 
   fraction of hour within the day of admission.  You type 

{p 16 20 2}{cmd:. gen admithour = hh(admittime) + mm(admittime)/60 + ss(admittime)/3600}


{marker s8}{...}
    {title:Extracting date components from SIFs}

       Desired component      Function                Example*
       {hline 54}
       calendar year          {cmd:year(}{it:td}{cmd:)}                   2013
       calendar month         {cmd:month(}{it:td}{cmd:)}                     7
       calendar day           {cmd:day(}{it:td}{cmd:)}                       5

       day of week            {cmd:dow(}{it:td}{cmd:)}                       2
       (0=Sunday)

       Julian day of year     {cmd:doy(}{it:td}{cmd:)}                     186
       (1=first day)

       week within year       {cmd:week(}{it:td}{cmd:)}                     27
       (1=first week)

       quarter within year    {cmd:quarter(}{it:td}{cmd:)}                   3
       (1=first quarter)

       half within year       {cmd:halfyear(}{it:td}{cmd:)}                  2
       (1=first half)
       {hline 54}
{p 7 7 2}
* All examples are with {cmd:td=mdy(7,5,2013)}.{p_end}
{p 7 7 2}
All functions require an SIF date as an argument. To extract components 
from other SIFs, use the appropriate
{help datetime##s6:SIF-to-SIF conversion function}
to convert to an SIF date, for example, {cmd:quarter(dofq(tq))}.

{pstd}
Examples:

{p 8 11 2}
1. You wish to obtain the day of week Sunday, Monday, ..., corresponding 
   to the SIF date variable {cmd:eventdate}.  You type 

{col 16}{cmd:. gen day_of_week = dow(eventdate)}

{p 11 11 2}
The new variable, {cmd:day_of_week}, contains 0 for Sunday, 1 for Monday, ..., 
6 for Saturday.

{p 8 11 2}
2. You wish to obtain the day of week Sunday, Monday, ..., corresponding 
   to the SIF datetime/c variable {cmd:eventtime}.  You type

{col 16}{cmd:. gen day_of_week = dow(dofc(eventtime))}

{p 8 11 2}
3. You have the SIF date variable {cmd:evdate} and wish to create the new 
   SIF date variable {cmd:evdate_r} from it.  {cmd:evdate_r}
   will contain the same date as {cmd:evdate} but rounded back to the 
   first of the month.  You type

{col 16}{cmd:. gen evdate_r = mdy(month(evdate), 1, year(evdate))}

{p 11 11 2}
In the above solution, we used the date-component extraction functions 
{cmd:month()} and {cmd:year()} and used the build-from-components 
function {cmd:mdy()}.
   

{marker s9}{...}
    {title:Conveniently typing SIF values}

{pstd}
You can type SIF values by just typing the number, such as 16,237 or
1,402,920,000,000, as in

{p 11 16 2}{cmd:. gen before = cond(hiredon < 16237, 1, 0) if !missing(hiredon)}

{col 12}{cmd:. drop if admittedon < 1402920000000}

{pstd}
Easier to type is

{p 11 16 2}{cmd:. gen before = cond(hiredon < td(15jun2004), 1, 0) if !missing(hiredon)}

{col 12}{cmd:. drop if admittedon < tc(15jun2004 12:00:00)}

{pstd} 
You can type SIF date values by typing the date inside 
{cmd:td()}, as in {cmd:td(15jun2004)}.

{pstd}
You can type SIF datetime/c values by typing the datetime inside 
{cmd:tc()}, as in {cmd:tc(15jun2004 12:00:00)}.

{pstd}
{cmd:td()} and {cmd:tc()} are called pseudofunctions because they 
translate what you type into their numerical equivalents.
Pseudofunctions require only that you specify the datetime components 
in the expected order, so rather than 15jun2004 above, we could have 
specified 15 June 2004, 15-6-2004, or 15/6/2004.

{pstd}
The SIF pseudofunctions and their expected component order are 

	    Desired SIF type  {c |}  Pseudofunction
	    {hline 18}{c +}{hline 39}
	    datetime/c        {c |}  {cmd:tc(}[{it:day-month-year}] {it:hh}{cmd::}{it:mm}[{cmd::}{it:ss}[{cmd:.}{it:sss}]]{cmd:)}
	    datetime/C        {c |}  {cmd:tC(}[{it:day-month-year}] {it:hh}{cmd::}{it:mm}[{cmd::}{it:ss}[{cmd:.}{it:sss}]]{cmd:)}
                              {c |}
	    date              {c |}  {cmd:td(}{it:day-month-year}{cmd:)}
                              {c |}
	    weekly date       {c |}  {cmd:tw(}{it:year-week}{cmd:)}
	    monthly date      {c |}  {cmd:tm(}{it:year-month}{cmd:)}
	    quarterly date    {c |}  {cmd:tq(}{it:year-quarter}{cmd:)}
	    half-yearly date  {c |}  {cmd:th(}{it:year-half}{cmd:)}
	    yearly date       {c |}  none necessary; years are numeric and can
     	                      {c |}       be typed directly
	    {hline 18}{c BT}{hline 39}

{p 8 8 2}
The {it:day-month-year} in {cmd:tc()} and {cmd:tC()} are optional.
If you omit them, 01jan1960 is assumed.  Doing so produces time as an offset, 
which can be useful in, for example, 

{p 12 12 2}
{cmd:. gen six_hrs_later = eventtime + tc(6:00)}


{marker s10}{...}
    {title:Obtaining and working with durations}

{pstd}
    SIF values are simply durations from 1960.  SIF datetime/c
    values record the number of milliseconds from 1jan1960 00:00:00; 
    SIF date values record the number of days from 1jan1960, and so
    on.

{pstd}
    To obtain the time between two SIF variables -- the duration -- subtract
    them:

{col 12}{cmd:. gen days_employed = curdate - hiredate}

{col 12}{cmd:. gen double ms_inside = discharge_time - admit_time}

{pstd}
    To obtain a new SIF that is equal to an old SIF before or after some amount
    of time, just add or subtract the desired durations:

{col 12}{cmd:. gen lastdate = hiredate + days_employed}
{col 12}{cmd:. format lastdate %td}

{col 12}{cmd:. gen double admit_time = discharge_time - ms_inside}
{col 12}{cmd:. format admit_time %tc}

{pstd}
Remember to use the units of the SIF variables.  SIF dates are in terms of
days, SIF weekly dates are in terms of weeks, etc., and SIF datetimes are in
terms of milliseconds.  Concerning milliseconds, it is often easier to use 
different units and conversion functions to convert to milliseconds:

{col 12}{cmd:. gen hours_inside = hours(discharge_time - admit_time)}

{col 12}{cmd:. gen admit_time = discharge_time - msofhours(hours_inside)}
{col 12}{cmd:. format admit_time %tc}

{pstd}
Function {cmd:hours()} converts milliseconds to hours.  Function
{cmd:msofhours()} converts hours to milliseconds.
The millisecond conversion functions are

	    Function       {c |}  Purpose
	    {hline 15}{c +}{hline 34}
	    {cmd:hours(}{it:ms}{cmd:)}      {c |}  convert milliseconds to hours;
                           {c |}  returns {it:ms}/(60*60*1000)
                           {c |}
            {cmd:minutes(}{it:ms}{cmd:)}    {c |}  convert milliseconds to minutes;
                           {c |}  returns {it:ms}/(60*1000)
                           {c |}
	    {cmd:seconds(}{it:ms}{cmd:)}    {c |}  convert milliseconds to seconds;
                           {c |}  returns {it:ms}/1000 
                           {c |}
	    {cmd:msofhours(}{it:h}{cmd:)}   {c |}  convert hours to milliseconds;
                           {c |}  returns {it:h}*60*60*1000
                           {c |}
	    {cmd:msofminutes(}{it:m}{cmd:)} {c |}  convert minutes to milliseconds;
                           {c |}  returns {it:m}*60*1000
                           {c |}
	    {cmd:msofseconds(}{it:s}{cmd:)} {c |}  convert seconds to milliseconds;
                           {c |}  returns {it:s}*1000
	    {hline 15}{c BT}{hline 34}

{pstd}
If you plan on using returned values to add to or subtract from a datetime 
SIF, be sure they are stored as {cmd:double}s.


{marker s11}{...}
    {title:Using dates and times from other software}

{pstd}
Most software stores dates and times numerically as durations from some
sentinel date in specified units, but they differ on the sentinel date and the
units.  If you have imported data, it is usually possible to adjust the
numeric date and datetime values to SIF.

{pstd}
Converting SAS dates:
{p_end}
{p 8 8 2}
If you have data in a SAS-format file, you may want to use the
{helpb import sas} command.  If the SAS file contains numerically
encoded dates, {cmd:import sas} will read those dates and properly code them
in SIF.  You do not need to perform any conversion after importing
your data with {cmd:import sas}.

{p 8 8 2}
On the other hand, if you import data originally from SAS that has
been saved into another format, such as a text file, dates and datetimes may
exist as the underlying numeric values that SAS used.  The discussion
below concerns converting those numeric values to SIF numeric values.
 
{p 8 8 2}
    SAS provides dates measured as the number of days since 01jan1960.  This
    is the same coding as used by Stata:

{col 12}{cmd:. gen statadate = sasdate}
{col 12}{cmd:. format statadate %td}

{p 8 8 2}
    SAS provides datetimes measured as the number of seconds since 01jan1960
    00:00:00, assuming 86,400 seconds/day.  To convert to SIF datetime/c, type

{col 12}{cmd:. gen double statatime = (sastime*1000)}
{col 12}{cmd:. format statatime %tc}

{p 8 8 2}
    It is important that variables containing SAS datetimes, such as
    {cmd:sastime} above, be imported into Stata as {cmd:double}s.


{pstd}
Converting SPSS dates:
{p_end}
{p 8 8 2}
If you have data in an SPSS-format file, you may want to use the
{helpb import spss} command.  If the SPSS file contains numerically
encoded dates, {cmd:import spss} will read those dates and properly code them
in SIF. You do not need to perform any conversion after importing your
data with {cmd:import spss}.

{p 8 8 2}
On the other hand, if you import data originally from SPSS that has
been saved into another format, such as a text file, dates and datetimes may
exist as the underlying numeric values that SPSS used.  The discussion
below concerns converting those numeric values to SIF numeric values.

{p 8 8 2}
    SPSS provides dates and datetimes measured as the number of seconds
    since 14oct1582 00:00:00, assuming 86,400 seconds/day.  To convert 
    to SIF datetime/c, type

{col 12}{cmd:. gen double statatime = (spsstime*1000) + tc(14oct1582 00:00)}
{col 12}{cmd:. format statatime %tc}

{p 8 8 2}
To convert to SIF date, type

{col 12}{cmd:. gen statadate = dofc((spsstime*1000) + tc(14oct1582 00:00))}
{col 12}{cmd:. format statadate %td}


{pstd}
Converting R dates:
{p_end}
{p 8 8 2}
    R stores dates as days since 01jan1970.  To convert to SIF date, type

{col 12}{cmd:. gen statadate = rdate - td(01jan1970)}
{col 12}{cmd:. format statadate %td}

{p 8 8 2}
    R stores datetimes as the number of UTC-adjusted seconds since 01jan1970
    00:00:00.  To convert to SIF datetime/C, type

{col 12}{cmd:. gen double statatime = rtime - tC(01jan1970 00:00)}
{col 12}{cmd:. format statatime %tC}

{p 8 8 2}
    To convert to SIF datetime/c, type

{col 12}{cmd:. gen double statatime = cofC(rtime - tC(01jan1970 00:00))}
{col 12}{cmd:. format statatime %tc}

{p 8 8 2}
There are issues of which you need to be aware when working with 
datetime/C values; see 
{it:{help datetime_translation##whytwo:Why there are two SIF datetime encodings}}
and 
{it:{help datetime_translation##advice:Advice on using datetime/c and datetime/C}}, both
in {bf:{help datetime_translation:[D] Datetime translation}}.


{pstd}
Converting Excel dates:
{p_end}
{p 8 8 2}
    If you have data in an Excel format file, you may want to use the
    {cmd:import} {cmd:excel} command.  If the Excel file contains numerically
    encoded dates, {cmd:import} {cmd:excel} will read those dates and properly
    code them in SIF.  You do not need to perform any conversion after
    importing your data with {cmd:import} {cmd:excel}.

{p 8 8 2}
    On the other hand, if you copy and paste a spreadsheet into Stata's
    editor, dates and datetimes are pasted as strings in HRF.  The
    discussion below concerns converting such HRF datetime strings to
    SIF numeric values.

{p 8 8 2}
    Excel has used different date systems across operating systems. Excel 
    for Windows used the "1900 Date System".  Excel for Mac used the 
    "1904 Date System".  More recently, Excel has been standardizing on 
    the 1900 Date System on all operating systems.

{p 8 8 2}
    Regardless of operating system, Excel can use either encoding. 
    See {browse "https://support.microsoft.com/kb/214330"}
    for instructions on converting workbooks between date systems.

{p 8 8 2}
    Converted dates will be off by four years if you choose the wrong date
    system.


{pstd}
Converting Excel 1900-Date-System dates:
{p_end}
{p 8 8 2}
    For dates on or after 01mar1900, Excel stores dates as days since
    30dec1899.  To convert to a Stata date,

{col 12}{cmd:. gen statadate = exceldate + td(30dec1899)}
{col 12}{cmd:. format statadate %td}

{p 8 8 2}
    Excel can store dates between 01jan1900 and 28feb1900, but the formula 
    above will not handle those two months.  See
    {browse "http://www.cpearson.com/excel/datetime.htm":http://www.cpearson.com/excel/datetime.htm} for more information.

{p 8 8 2}
    For datetimes on or after 01mar1900 00:00:00, Excel stores datetimes 
    as days plus fraction of day since 30dec1899 00:00:00.  To convert 
    with a one-second resolution to a Stata datetime, 

{col 12}{cmd:. gen statatime = round((exceltime+td(30dec1899))*86400)*1000}
{col 12}{cmd:. format statatime %tc}


{pstd}
Converting Excel 1904-Date-System dates:
{p_end}
{p 8 8 2}
    For dates on or after 01jan1904, Excel stores dates as days since 
    01jan1904.  To convert to a Stata date, 

{col 12}{cmd:. gen statadate = exceldate + td(01jan1904)}
{col 12}{cmd:. format statadate %td}

{p 8 8 2}
    For datetimes on or after 01jan1904 00:00:00, Excel stores datetimes 
    as days plus fraction of day since 01jan1904 00:00:00.  To convert 
    with a one-second resolution to a Stata datetime, 

{col 12}{cmd:. gen statatime = round((exceltime+td(01jan1904))*86400)*1000}
{col 12}{cmd:. format statatime %tc}


{pstd}
Converting OpenOffice dates:
{p_end}
{p 8 8 2}
    OpenOffice uses the Excel 1900 Date System described above.


{pstd}
Converting Unix time:
{p_end}
{p 8 8 2}
    Unix time is stored as the number of seconds since midnight,
    01jan1970.  To convert to a Stata datetime,

{col 12}{cmd:. generate double statatime = unixtime * 1000 + mdyhms(1,1,1970,0,0,0)}

{p 8 8 2}
    To convert to a Stata date,

{col 12}{cmd:. generate statadate = dofc(unixtime * 1000 + mdyhms(1,1,1970,0,0,0))}


{marker description}{...}
{title:Description}

{p 4 4 2}
{it:Syntax} above provides a complete overview of Stata's date and 
time values. 
Also see 
{bf:{help datetime_translation:[D] Datetime translation}}
and 
{bf:{help datetime_display_formats:[D] Datetime display formats}}
for additional information.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D DatetimeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
The best way to learn about Stata's date and time functions 
is to experiment with them using the {helpb display} command.

	. {cmd:display date("5-12-1998", "MDY")}
        14011

	. {cmd:display %td date("5-12-1998", "MDY")}
	12may1998

        . {cmd:display clock("5-12-1998 11:15", "MDY hm")}
        1.211e+12

        . {cmd:display %20.0gc clock("5-12-1998 11:15", "MDY hm")}
	1,210,590,900,000

        . {cmd:display %tc clock("5-12-1998 11:15", "MDY hm")}
	12may1998 11:15:00

{p 4 4 2}
With {cmd:display}, you can specify a format in front
of the expression to specify how the result is to be formatted.
{p_end}
