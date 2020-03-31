{smcl}
{* *! version 1.3.4  15may2018}{...}
{vieweralsosee "[D] Datetime business calendars creation" "mansection D Datetimebusinesscalendarscreation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] bcal" "help bcal"}{...}
{vieweralsosee "[D] Datetime business calendars" "help datetime business calendars"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] Datetime" "help datetime"}{...}
{viewerjumpto "Syntax" "datetime_business_calendars_creation##syntax"}{...}
{viewerjumpto "Description" "datetime_business_calendars_creation##description"}{...}
{viewerjumpto "Links to PDF documentation" "datetime_business_calendars_creation##linkspdf"}{...}
{viewerjumpto "Remarks" "datetime_business_calendars_creation##remarks"}{...}
{p2colset 1 45 47 2}{...}
{p2col:{bf:[D] Datetime business calendars creation} {hline 2}}Business calendars creation{p_end}
{p2col:}({mansection D Datetimebusinesscalendarscreation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 4 4 2}
Business calendar {it:calname} and corresponding display format 
{cmd:%tb}{it:calname} are defined by the text file {it:calname}{cmd:.stbcal}, 
which contains the following:

{p 8 12 2}
{cmd:*} {it:comments}{p_end}

{p 8 12 2}
{cmd:version} {it:version_of_stata}{p_end}
{p 8 12 2}
{cmd:purpose "}{it:text}{cmd:"}{p_end}
{p 8 12 2}
{cmd:dateformat} 
{c -(}{cmd:ymd} |
{cmd:ydm} | 
{cmd:myd} |
{cmd:mdy} |
{cmd:dym} |
{cmd:dmy}{c )-}{p_end}

{p 8 12 2}
{cmd:range}
{it:{help datetime_business_calendars_creation##date:date}}
{it:{help datetime_business_calendars_creation##date:date}}{p_end}
{p 8 12 2}
{cmd:centerdate}
{it:{help datetime_business_calendars_creation##date:date}}

{p 8 12 2}
[{cmd:from}
{c -(}{it:{help datetime_business_calendars_creation##date:date}}|{cmd:.}{c )-}
{cmd:to}
{c -(}{it:{help datetime_business_calendars_creation##date:date}}|{cmd:.}{c )-}{cmd::}]{bind:  }{cmd:omit} ...
[{it:{help datetime_business_calendars_creation##if:if}}]{p_end}
{p 8 8 2}
...{break}
...


{p 4 4 2}
where

{p 8 8 2}
{cmd:omit} ... may be

{p 12 12 2}
{cmd:omit}
{cmd:date}
{it:{help datetime_business_calendars_creation##pdate:pdate}}
[{cmd:and} {it:{help datetime_business_calendars_creation##pmlist:pmlist}}]

{p 12 12 2}
{cmd:omit}
{cmd:dayofweek}
{it:{help datetime_business_calendars_creation##dowlist:dowlist}}

{p 12 12 2}
{cmd:omit}
{cmd:dowinmonth}
{it:{help datetime_business_calendars_creation##pm#:pm#}}
{it:{help datetime_business_calendars_creation##dow:dow}}
[{cmd:of} {it:{help datetime_business_calendars_creation##monthlist:monthlist}}]
[{cmd:and} {it:{help datetime_business_calendars_creation##pmlist:pmlist}}]

{marker if}{...}
{p 8 8 2}
[{it:if}] may be

{p 12 12 2}
{cmd:if} {it:restriction} [{cmd:&} {it:restriction} ...]

{p 8 8  2}
{it:restriction} is one of

{p 12 12 2}
{cmd:dow(}{it:{help datetime_business_calendars_creation##dowlist:dowlist}}{cmd:)}{break}
{cmd:month(}{it:{help datetime_business_calendars_creation##monthlist:monthlist}}{cmd:)}{break}
{cmd:year(}{it:{help datetime_business_calendars_creation##yearlist:yearlist}}{cmd:)}{break}

{marker date}{...}
{p 8 12 2}
{it:date} is a date written with the
{it:{help datetime_business_calendars_creation##year:year}}, 
{it:{help datetime_business_calendars_creation##month:month}}, and 
{it:day} in the order specified by {cmd:dateformat}.  
For instance, if {cmd:dateformat} is {cmd:dmy}, 
a {it:date} can be {cmd:12apr2013}, {cmd:12-4-2013}, or {cmd:12.4.2013}.

{marker pdate}{...}
{p 8 12 2}
{it:pdate} is a {it:date} or it is a {it:date} with character {cmd:*} 
substituted where the year would usually appear.
If {cmd:dateformat} is {cmd:dmy}, 
a {it:pdate} can be 
{cmd:12apr2013}, 
{cmd:12-4-2013}, or
{cmd:12.4.2013}; or it can be 
{cmd:12apr*}, {cmd:12-4-*}, or {cmd:12.4.*}.
{cmd:12apr*} means the 12th of April across all years.

{marker dow}{...}
{p 8 12 2}
{it:dow} is a day of the week, in English.
It may be abbreviated to as few as 2 characters, and
capitalization is irrelevant.
Examples:
{cmd:Sunday}, {cmd:Mo}, {cmd:tu}, {cmd:Wed}, {cmd:th}, 
{cmd:Friday}, {cmd:saturday}.

{marker dowlist}{...}
{p 8 12 2}
{it:dowlist} is a {it:dow}, or it is a space-separated list of one or more
{it:dow}s enclosed in parentheses.  
Examples:  {cmd:Sa}, {cmd:(Sa)}, {cmd:(Sa Su)}.

{marker month}{...}
{p 8 12 2}
{it:month} is a month of the year, in English, or it is a month number.
It may be abbreviated to the minimum possible, and
capitalization is irrelevant.
Examples:
{cmd:January}, 
{cmd:2}, 
{cmd:Mar}, 
{cmd:ap}, 
{cmd:may}, 
{cmd:6}, 
{cmd:Jul}, 
{cmd:aug}, 
{cmd:9}, 
{cmd:Octob}, 
{cmd:nov}, 
{cmd:12}.

{marker monthlist}{...}
{p 8 12 2}
{it:monthlist} is a {it:month}, or it is a space-separated list of one or more
{it:month}s enclosed in parentheses.  
Examples:  
{cmd:Nov},
{cmd:(Nov)},
{cmd:11},
{cmd:(11)},
{cmd:(Nov Dec)}, 
{cmd:(11 12)}.

{marker year}{...}
{p 8 12 2}
{it:year} is a 4-digit calendar year.
Examples:  
{cmd:1872}, 
{cmd:1992}, 
{cmd:2013}, 
{cmd:2050}.

{marker yearlist}{...}
{p 8 12 2}
{it:yearlist} is a {it:year}, or it is a space-separated list of one or more
{it:year}s enclosed in parentheses.  Examples:  
{cmd:2013}, 
{cmd:(2013)}, 
{cmd:(2013 2014)}.

{marker pm#}{...}
{p 8 12 2}
{it:pm#} is a nonzero integer preceded by a plus or minus sign. 
Examples:  {cmd:-2}, {cmd:-1}, {cmd:+1}.
{it:pm#} appears in {cmd:omit} {cmd:dowinmonth} {it:pm#} {it:dow} {cmd:of}
{it:monthlist},
where {it:pm#} specifies which {it:dow} in the month.  
{cmd:omit} {cmd:dowinmonth} {cmd:+1} {cmd:Th} means the first Thursday of 
the month. 
{cmd:omit} {cmd:dowinmonth} {cmd:-1} {cmd:Th} means the last Thursday of 
the month.

{marker pmlist}{...}
{p 8 12 2}
{it:pmlist} is a {it:pm#}, or it is 
a space-separated list of one or more {it:pm#}s enclosed in 
parentheses.  
Examples:
{cmd:+1}, 
{cmd:(+1)}, 
{cmd:(+1 +2)}, 
{cmd:(-1 +1 +2)}.
{it:pmlist} appears in the optional {cmd:and} {it:pmlist} allowed at the 
end of {cmd:omit} {it:date} and {cmd:omit} {cmd:dowinmonth}, and it
specifies additional dates to be omitted.
{cmd:and} {cmd:+1} means and the day after.  
{cmd:and} {cmd:-1} means and the day before.


{marker description}{...}
{title:Description}

{pstd}
Stata provides user-definable business calendars.
Business calendars are provided by StataCorp and by other users, 
and you can write your own.  You can also create a business calendar
automatically from the current dataset with the {cmd:bcal create} command;
see {helpb bcal:[D] bcal}.
This entry concerns writing your own business calendars.

{pstd}
See {bf:{help datetime_business_calendars:[D] Datetime business calendars}}
for an introduction to business calendars.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D DatetimebusinesscalendarscreationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help datetime_business_calendars_creation##r1:Introduction}
	{help datetime_business_calendars_creation##r2:Concepts}
	{help datetime_business_calendars_creation##r3:The preliminary commands}
	{help datetime_business_calendars_creation##r4:The omit commands: from/to and if}
	{help datetime_business_calendars_creation##r5:The omit commands: and}
	{help datetime_business_calendars_creation##r6:The omit commands: omit date}
	{help datetime_business_calendars_creation##r7:The omit commands: omit dayofweek}
	{help datetime_business_calendars_creation##r8:The omit commands: omit dowinmonth}
	{help datetime_business_calendars_creation##r8.5:Creating stbcal-files with bcal create}
	{help datetime_business_calendars_creation##r9:Where to place stbcal-files}
	{help datetime_business_calendars_creation##r10:How to debug stbcal-files}
	{help datetime_business_calendars_creation##r11:Ideas for calendars that may not occur to you}


{marker r1}{...}
{title:Introduction}

{pstd}
A business calendar is a regular calendar with some dates crossed out, 
such as 

                               November 2011    
                        Su  Mo  Tu  We  Th  Fr  Sa
                        ---------------------------
                                 1   2   3   4   X
                         X   7   8   9  10  11   X
                         X  14  15  16  17  18   X
                         X  21  22  23   X   X   X
                         X  28  29  30
                        ---------------------------

{pstd}
The purpose of the stbcal-file is to 

{p 8 12 2}
1.  Specify the range of dates covered by the calendar.

{p 8 12 2}
2.  Specify the particular date that will be encoded as date 0.

{p 8 12 2}
3.  Specify the dates from the regular calendar that are to be crossed out.

{pstd}
The stbcal-file for the above calendar could be as simple as 

	{hline 40} example_1.stbcal {hline 3}
	{cmd}version {ccl stata_version}
	range 01nov2011 30nov2011
	centerdate 01nov2011
	omit date  5nov2011
	omit date  6nov2011
	omit date 12nov2011
	omit date 13nov2011
	omit date 19nov2011
	omit date 20nov2011
	omit date 24nov2011
	omit date 25nov2011
	omit date 26nov2011
	omit date 27nov2011{txt}
	{hline 40} example_1.stbcal {hline 3}

{pstd}
In fact, this calendar can be written more compactly because we can specify
to omit all Saturdays and Sundays:


	{hline 40} example_2.stbcal {hline 3}
	{cmd}version {ccl stata_version}
	range 01nov2011 30nov2011
	centerdate 01nov2011
	omit dayofweek (Sa Su)
	omit date 24nov2011
	omit date 25nov2011{txt}
	{hline 40} example_2.stbcal {hline 3}

{pstd}
In this particular calendar, we are omitting 24nov2011 and 25nov2011 because
of the American Thanksgiving holiday.  Thanksgiving is celebrated on the 
fourth Thursday of November, and many businesses close on the following
Friday as well.  It is possible to specify rules like that in stbcal-files:

{marker omit}{...}
	{hline 40} example_3.stbcal {hline 3}
	{cmd}version {ccl stata_version}
	range 01nov2011 30nov2011
	centerdate 01nov2011
	omit dayofweek (Sa Su)
	omit dowinmonth +4 Th of Nov and +1{txt}
	{hline 40} example_3.stbcal {hline 3}

{pstd}
Understand that this calendar is an artificial example, and it is made all 
the more artificial because it covers so brief a period.  Real
stbcal-files cover at least decades, and some cover centuries.


{marker r2}{...}
{title:Concepts}

{pstd}
You are required to specify four things in an stbcal-file:

{p 8 12 2}
1.  the version of Stata being used,

{p 8 12 2}
2.  the range of the calendar,

{p 8 12 2}
3.  the center date of the calendar, and

{p 8 12 2}
4.  the dates to be omitted.

{phang}
Version.{break}
You specify the version of Stata to ensure forward compatibility with future
versions of Stata.  If your calendar starts with the line {cmd:version}
{cmd:{ccl stata_version}}, future versions of Stata will know how to interpret
the file even if the definition of the stbcal-file language has greatly
changed.

{phang}
Range.{break}
A calendar is defined over a specific range of dates, and you must explicitly 
state what that range is.  When you or others use your calendar, 
dates outside the range will be considered invalid, which usually means that
they will be treated as missing values.

{phang}
Center date.{break}
Stata stores dates as integers.  In a calendar, 57 might stand for a
particular date.  If it did, then 57-1=56 stands for the day before, and
57+1=58 stands for the day after.  The previous statement works just as well
if we substitute -12,739 for 57, and thus the particular values do not matter
except that we must agree upon what values we wish to standardize
because we will be storing these values in our datasets.

{pmore}
The standard is called the center date, and here center does not mean 
the date that corresponds to the middle of your calendar.  It means 
the date that corresponds to the center of integers, which is to say, 0. 
You must choose a date within the range as the standard.  The particular 
date you choose does not matter, but most authors choose easily remembered
ones.  Stata's built-in {cmd:%td} calendar uses 01jan1960, but that date will
probably not be available to you because the center date must be a date on the
business calendars, and most businesses were closed on 01jan1960.

{pmore}
It will sometimes happen that you will want to expand the range of your 
calendar in the future.  Today, you make a calendar that covers, say 
1990 to 2020, which is good enough for your purposes.  Later, you need 
to expand the range, say back to 1970 or forward to 2030, or both. 
When you update your calendar, do not change the center date.  This way, 
your new calendar will be backward compatible with your previous one.

{phang}
Omitted dates.{break}
Obviously you will need to specify the 
dates to be omitted.  
You can specify the exact dates to be omitted when need be, but whenever 
possible, specify the rules instead of the outcome of the rules.
Rules change, so learn about the {cmd:from}/{cmd:to} prefix that can 
be used in front of {cmd:omit} commands.  You can code things like 

        {cmd:from 01jan1960 to 31dec1968: omit} ...
	{cmd:from 01jan1979 to .:  omit} ...

{pmore}
When specifying {cmd:from}/{cmd:to}, {cmd:.} for the first date is synonymous 
with the opening date of the range.  {cmd:.} for the second date is synonymous 
with the closing date.


{marker r3}{...}
{title:The preliminary commands}

{pstd}
Stbcal-files should begin with these commands:

	{cmd:version} {it:version_of_stata}
	{cmd:purpose "}{it:text}{cmd:"}
	{cmd:dateformat} {...}
{c -(}{cmd:ymd} | {...}
{cmd:ydm} | {...}
{cmd:myd} | {...}
{cmd:mdy} | {...}
{cmd:dym} | {...}
{cmd:dmy}{c )-}
	{cmd:range} {it:date} {it:date}
	{cmd:centerdate} {it:date}

{p 4 8 12}
{cmd:version} {it:version_of_stata}{break}
    At the time of this writing, you would specify {cmd:version}
    {cmd:{ccl stata_version}}.  Better still, type command {cmd:version} in
    Stata to discover the version of Stata you are currently using.  Specify
    that version, and be sure to look at the documentation so that you use the
    modern syntax correctly.

{p 4 8 12}
{cmd:purpose "}{it:text}{cmd:"}{break}
    This command is optional.  The purpose of {cmd:purpose} is not to make 
    comments in your file.  If you want comments, include those with a {cmd:*} 
    in front.  The {cmd:purpose} sets the text that 
    {cmd:bcal} {cmd:describe} {it:calname} will display.

{p 4 8 12}
	{cmd:dateformat} 
{c -(}{cmd:ymd} | 
{cmd:ydm} |
{cmd:myd} |
{cmd:mdy} | 
{cmd:dym} |
{cmd:dmy}{c )-}{break}
    This command is optional.  {cmd:dateformat} {cmd:ymd} is assumed if
    not specified.  This command has nothing to do with how dates will look 
    when variables are formatted with {cmd:%tb}{it:calname}.  This command 
    specifies how you are typing dates in this stbcal-file on the subsequent 
    commands.  Specify the format that you find convenient.

{p 4 8 12}
{cmd:range} {it:date} {it:date}{break}
The date range was discussed in
{it:{help datetime_business_calendars_creation##r2:Concepts}}.
You must specify it.

{p 4 8 12}
{cmd:centerdate} {it:date}{break}
The centering date was discussed in
{it:{help datetime_business_calendars_creation##r2:Concepts}}.
You must specify it.
   

{marker r4}{...}
{title:The omit commands: from/to and if}

{pstd}
An stbcal-file usually contains multiple {cmd:omit} commands.
The {cmd:omit} commands have the syntax

{p 8 12 2}
[{cmd:from}
{c -(}{it:date}|{cmd:.}{c )-}
{cmd:to}
{c -(}{it:date}|{cmd:.}{c )-}{cmd::}]{bind:  }{cmd:omit} ...
[{it:if}]

{pstd}
That is, an {cmd:omit} command may optionally be preceded by 
{cmd:from}/{cmd:to} and may optionally contain an {cmd:if} at the end.

{pstd}
When you do not specify {cmd:from}/{cmd:to}, results are the same as if you 
specified 

	{cmd:from . to .:  omit} ...

{pstd}
That is, the {cmd:omit} command applies to all dates from the beginning 
to the end of the range.  In 
{it:{help datetime_business_calendars_creation##r1:Introduction}},
we showed the
{help datetime_business_calendars_creation##omit:command}

	{cmd:omit dowinmonth +4 Th of Nov and +1}

{pstd} 
Our sample calendar covered only the month of November, but imagine that it
covered a longer period and that the business was open on Fridays
following Thanksgiving up until 1998.  The Thanksgiving holidays could be coded

	{cmd:from . to 31dec1997: omit dowinmonth +4 Th of Nov}
	{cmd:from 01jan1998 to .: omit dowinmonth +4 Th of Nov and +1}

{pstd} 
The same holidays could also be coded

	{cmd:omit dowinmonth +4 Th of Nov}
	{cmd:from 01jan1998 to .: omit dowinmonth +4 Th of Nov and +1}

{pstd}
We like the first style better, but understand that the same dates can be 
omitted from the calendars multiple times and for multiple reasons, and 
the result is still the same as if the dates were omitted only once.

{pstd}
The optional {cmd:if} also determines when the {cmd:omit} statement is 
operational.  Let's think about the Christmas holidays.  Let's say a business 
is closed on the 24th and 25th of December.  That could be coded

	{cmd:omit date 24dec*}
	{cmd:omit date 25dec*}

{pstd}
although perhaps that would be more understandable if we coded 

	{cmd:from . to .: cmd:omit date 24dec*}
	{cmd:from . to .: cmd:omit date 25dec*}

{pstd}
Remember, {cmd:from} {cmd:.} {cmd:to} {cmd:.} is implied when not specified. 
In any case, we are omitting {cmd:24dec} and {cmd:25dec} across all years.

{pstd} 
Now consider a more complicated rule.  The business is closed on the
24th and 25th of December if the 25th is on Tuesday, Wednesday, Thursday, or
Friday.  If the 25th is on Saturday or Sunday, the holidays are the preceding
Friday and the following Monday.  If the 25th is on Monday, the holidays are
Monday and Tuesday.  The rule could be coded

	{cmd:omit date 25dec* and -1      if dow(Tu We Th Fr)}
	{cmd:omit date 25dec* and (-2 -1) if dow(Sa)}
	{cmd:omit date 25dec* and (-3 -2) if dow(Su)}
	{cmd:omit date 25dec* and +1      if dow(Mo)}

{pstd}
The {cmd:if} clause specifies that the {cmd:omit} command is only to be
executed when {cmd:25dec*} is one of the specified days of the week.  If
{cmd:25dec*} is not one of those days, the {cmd:omit} statement is ignored for
that year.  Our focus here is on the {cmd:if} clause.  We will explain about
the {cmd:and} clause in the next section. 

{pstd}
Sometimes, you have a choice between using {cmd:from}/{cmd:to} or {cmd:if}.
In such cases, use whichever is convenient.  For instance, imagine that 
the Christmas holiday rule for Monday changed in 2011 and 2012. 
You could code 

	{cmd:from . to 31dec2010: omit date 25dec* and +1 if dow(Mo)}
	{cmd:from 01jan2011 to .: omit date ... if dow(Mo)}

{pstd}
or 

	{cmd:omit date 25dec* and +1 if dow(Mo) & year(2007 2008 2009 2010)}
	{cmd:omit date ... if dow(Mo) & year(2011 2012)}

{pstd}
Generally, we find {cmd:from}/{cmd:to} more convenient to code than {cmd:if} 
{cmd:year()}.


{marker r5}{...}
{title:The omit commands: and}

{pstd}
The other common piece of syntax that shows up on {cmd:omit} commands is
{cmd:and} {it:pmlist}.  We used it above in coding the Christmas holidays,

	{cmd:omit date 25dec* and -1      if dow(Tu We Th Fr)}
	{cmd:omit date 25dec* and (-2 -1) if dow(Sa)}
	{cmd:omit date 25dec* and (-3 -2) if dow(Su)}
	{cmd:omit date 25dec* and +1      if dow(Mo)}

{pstd}
{cmd:and} {it:pmlist} specifies a list of days also to be omitted if the date
being referred to is omitted.  The extra days are specified as how many days
they are from the date being referred to.  Please excuse the inelegant "date
being referred to", but sometimes the date being referred to is implied rather
than stated explicitly.  For this problem, however, the date being referred to
is {cmd:25dec} across a number of years.
The line 

	{cmd:omit date 25dec* and -1      if dow(Tu We Th Fr)}

{pstd}
says to omit {cmd:25dec} and the day before if {cmd:25dec} is on a Tuesday,
Wednesday, etc. The line

	{cmd:omit date 25dec* and (-2 -1) if dow(Sa)}

{pstd}
says to omit {cmd:25dec} and two days before and one day before if {cmd:25dec}
is Saturday.  The line 

        {cmd:omit date 25dec* and (-3 -2) if dow(Su)}

{pstd}
says to omit {cmd:25dec} and three days before and two days before if
{cmd:25dec} is Sunday.  The line 

	{cmd:omit date 25dec* and +1      if dow(Mo)}

{pstd}
says to omit {cmd:25dec} and the day after if {cmd:25dec} is Monday.

{pstd}
Another {cmd:omit} command for solving a different problem reads

	{cmd:omit dowinmonth -1 We of (Nov Dec) and +1 if year(2009)}

{pstd}
Please focus on the {cmd:and} {cmd:+1}.  We are going to omit the date being
referred to and the date after if the year is 2009.  The date being referred
to here is {cmd:-1} {cmd:We} {cmd:of} {cmd:(Nov Dec)}, which is to say, the
last Wednesday of November and December.


{marker r6}{...}
{title:The omit commands: omit date}

{pstd}
The full syntax of {cmd:omit date} is 

{p 8 12 2}
[{cmd:from}
{c -(}{it:date}|{cmd:.}{c )-}
{cmd:to}
{c -(}{it:date}|{cmd:.}{c )-}{cmd::}]{bind:  }{cmd:omit} 
{cmd:date}
{it:pdate}
[{cmd:and} {it:pmlist}]
[{it:if}]

{pstd}
You may omit specific dates, 

	{cmd:omit date 25dec2010}

{pstd}
or you may omit the same date across years:

	{cmd:omit date 25dec*}


{marker r7}{...}
{title:The omit commands: omit dayofweek}

{pstd}
The full syntax of {cmd:omit dayofweek} is 

{p 8 12 2}
[{cmd:from}
{c -(}{it:date}|{cmd:.}{c )-}
{cmd:to}
{c -(}{it:date}|{cmd:.}{c )-}{cmd::}]{bind:  }{cmd:omit} 
{cmd:dayofweek}
{it:dowlist}
[{it:if}]

{pstd}
The specified days of week (Monday, Tuesday, ...) are omitted.


{marker r8}{...}
{title:The omit commands: omit dowinmonth}

{pstd}
The full syntax of {cmd:omit dowinmonth} is 

{p 8 12 2}
[{cmd:from}
{c -(}{it:date}|{cmd:.}{c )-}
{cmd:to}
{c -(}{it:date}|{cmd:.}{c )-}{cmd::}]{bind:  }{cmd:omit} 
{it:pm#}
{it:dow}
[{cmd:of} {it:monthlist}]
[{cmd:and} {it:pmlist}]
[{it:if}]

{pstd}
{cmd:dowinmonth} stands for day of week in month and refers to days such 
as the first Monday, second Monday, ..., next-to-last Monday, and last 
Monday of a month.  
This is written as 
{cmd:+1} {cmd:Mo}, 
{cmd:+2} {cmd:Mo}, 
...,
{cmd:-2} {cmd:Mo}, and
{cmd:-1} {cmd:Mo}.


{marker r8.5}{...}
{title:Creating stbcal-files with bcal create} 

{pstd}
Business calendars can be obtained from your Stata installation or from other
Stata users.  You can also write your own business calendar files or use the
{cmd:bcal create} command to automatically create a business calendar from
the current dataset.  With {cmd:bcal create}, business holidays are
automatically inferred from gaps in the dataset, or they can be explicitly
defined by specifying the {cmd:if} and {cmd:in} qualifiers, as well as the
{cmd:excludemissing()} option.  You can also edit business calendars created
with {cmd:bcal create} or obtained from other sources.  It is advisable to use
{cmd:bcal load} or {cmd:bcal describe} to verify that a business calendar is
well constructed and remains so after editing.

{pstd}
See {helpb bcal:[D] bcal} for more information on {cmd:bcal create}.


{marker r9}{...}
{title:Where to place stbcal-files}

{pstd}
Stata automatically searches for stbcal-files in the same way it searches for
ado-files.  Stata looks for ado-files and stbcal-files in the official Stata
directories, your site's directory ({cmd:SITE}), your current working directory
({cmd:.}), your personal directory ({cmd:PERSONAL}), and your directory for
materials written by other users ({cmd:PLUS}).  On this writer's computer, 
these directories happen to be

            {cmd}. sysdir
               {txt}STATA:  {res}C:\Program Files\Stata16\
                {txt}BASE:  {res}C:\Program Files\Stata16\ado\base\
                {txt}SITE:  {res}C:\Program Files\Stata16\ado\site\
                {txt}PLUS:  {res}C:\ado\plus\
            {txt}PERSONAL:  {res}C:\ado\personal\
            {txt}OLDPLACE:  {res}C:\ado\{txt}

{pstd}
Place calendars that you write into {cmd:.}, {cmd:PERSONAL}, or {cmd:SITE}.
Calendars you obtain from others using {cmd:net} or {cmd:ssc} will be placed 
by those commands into {cmd:PLUS}.
See 
{bf:{help sysdir:[P] sysdir}}, 
{bf:{help net:[R] net}}, and
{bf:{help ssc:[R] ssc}}.


{marker r10}{...}
{title:How to debug stbcal-files}

{pstd}
Stbcal-files are loaded automatically as they are needed, and because this can
happen anytime, even at inopportune moments, no output is produced.  If there
are errors in the file, no mention is made of the problem, and thereafter Stata
simply acts as if it had never found the file, which is to say, variables with
{cmd:%tb}{it:calname} formats are displayed in {cmd:%g} format.

{pstd}
You can tell Stata to load a calendar file right now and to show you the 
output, including error messages.  Type 

	{cmd:. bcal load} {it:calname}

{pstd}
It does not matter where {it:calname}{cmd:.stbcal} is stored, Stata will find
it.  It does not matter whether Stata has already loaded
{it:calname}{cmd:.stbcal}, either secretly or because you previously instructed
the file be loaded.  It will be reloaded, you will see what you wrote, and you
will see any error messages.


{marker r11}{...}
{title:Ideas for calendars that may not occur to you}

{pstd}
Business calendars obviously are not restricted to businesses, and neither do
they have to be restricted to days.

{pstd}
Say you have weekly data and want to create a calendar that contains 
only Mondays.  You could code 

	{hline 40} mondays.stbcal {hline 3}
	{cmd}version {ccl stata_version}

	purpose "Mondays only"
	range 04jan1960 06jan2020
	centerdate 04jan1960

	omitdow (Tu We Th Fr Sa Su){txt}
	{hline 40} mondays.stbcal {hline 3}

{pstd}
Say you have semimonthly data and want to include the 1st and 15th of every
month.  You could code

	{hline 40} smnth.stbcal {hline 3}
	{cmd}version {ccl stata_version}

	purpose "Semimonthly"
	range 01jan1960 15dec2020
	centerdate 01jan1960

	omit date 2jan*
	omit date 3jan*
	.
	.
	omit date 14jan*
	omit date 16jan*
	.
	.
	omit date 31jan*
	omit date  2feb*
	.
	.{txt}
	{hline 40} smnth.stbcal {hline 3}

{pstd}
Forgive the ellipses, but this file will be long.  Even so, you have to 
create it only once.

{pstd}
As a final example, say that you just want Stata's {cmd:%td} dates, but you
wish they were centered on 01jan1970 rather than on 01jan1960.  You could code

	{hline 40} rectr.stbcal {hline 3}
	{cmd}version {ccl stata_version}

	Purpose "%td centered on 01jan1970"
	range 01jan1800 31dec2999
	centerdate 01jan1970{txt}
	{hline 40} rectr.stbcal {hline 3}
