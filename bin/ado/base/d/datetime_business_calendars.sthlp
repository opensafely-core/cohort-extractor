{smcl}
{* *! version 1.3.5  15oct2018}{...}
{vieweralsosee "[D] Datetime business calendars" "mansection D Datetimebusinesscalendars"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] bcal" "help bcal"}{...}
{vieweralsosee "[D] Datetime business calendars creation" "help datetime_business calendars creation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] Datetime" "help datetime"}{...}
{viewerjumpto "Syntax" "datetime_business_calendars##syntax"}{...}
{viewerjumpto "Description" "datetime_business_calendars##description"}{...}
{viewerjumpto "Links to PDF documentation" "datetime_business_calendars##linkspdf"}{...}
{viewerjumpto "Remarks" "datetime_business_calendars##remarks"}{...}
{p2colset 1 36 38 2}{...}
{p2col:{bf:[D] Datetime business calendars} {hline 2}}Business calendars{p_end}
{p2col:}({mansection D Datetimebusinesscalendars:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Apply business calendar format

{p 8 25 2}
{cmd:format} {varlist} {cmd:%tb}{it:calname}


{pstd}
Apply detailed date format with business calendar format

{p 8 25 2}
{cmd:format} {varlist} {cmd:%tb}{it:calname}[{cmd::}{it:datetime-specifiers}]


{pstd}
Convert between business dates and regular dates

{p 8 25 2}
{c -(}{cmdab:g:enerate}|{cmd:replace}{c )-}{bind:      }
{it:bdate} = {cmd:bofd("}{it:calname}{cmd:",} {it:regulardate}{cmd:)}

{p 8 25 2}
{c -(}{cmdab:g:enerate}|{cmd:replace}{c )-}
{it:regulardate} = {cmd:dofb(}{it:bdate}{cmd:, "}{it:calname}{cmd:")}


{p 8 25 2}
File {it:calname}{cmd:.stbcal} contains the business calendar definition.


{p 4 4 2}
Details of the syntax follow:

{p 8 14 2}
1.  Definition.{break}
    Business calendars are regular calendars with some dates crossed out:

                               November 2011    
                        Su  Mo  Tu  We  Th  Fr  Sa
                        ---------------------------
                                 1   2   3   4   X
                         X   7   8   9  10  11   X
                         X  14  15  16  17  18   X
                         X  21  22  23   X   X   X
                         X  28  29  30
                        ---------------------------

{p 14 14 2}
      A date that appears on the business calendar is called a business date.
      11nov2011 is a business date.  12nov2011 is not a business date with 
      respect to this calendar.

{p 14 14 2}
      Crossed-out dates are literally omitted.  That is, 

		18nov2011 + 1 = 21nov2011 

		28nov2011 - 1 = 23nov2011

{p 14 14 2}
      Stata's lead and lag operators work the same way.
     
{p 8 14 2}
2.  Business calendars are named.{break}
    Assume that the above business calendar is named {cmd:simple}.

{p 8 14 2}
3.   Business calendars are defined in files named {it:calname}{cmd:.stbcal},
     such as {cmd:simple.stbcal}.
     Calendars may be supplied by StataCorp and already installed, 
     obtained from other users directly or via the SSC, or written yourself.
     Calendars can also be created automatically from the current dataset
     with the {cmd:bcal create} command; see {helpb bcal:[D] bcal}.
     Stbcal-files are treated in the same way as ado-files.

{p 14 14 2}
     You can obtain a list of all business calendars installed on your 
     computer by typing {cmd:bcal} {cmd:dir}; see 
     {bf:{help bcal:[D] bcal}}.

{p 8 14 2}
4.  Datetime format.{break}
    The date format associated with the business calendar named {cmd:simple}
    is {cmd:%tbsimple}, which is to say 
    {bind:{cmd:%} + {cmd:t} + {cmd:b} + {it:calname}}.

		{cmd:%}        it is a format
                {cmd:t}        it is a datetime 
                {cmd:b}        it is based on a business calendar
		{it:calname}  the calendar's name

{p 8 14 2}
5.  Format variables the usual way.{break}  You format variables to have
    business calendar formats just as you format any variable, using the
    {cmd:format} command.

                . {cmd:format mydate %tbsimple}

{p 14 14 2}
    specifies that existing variable {cmd:mydate} contains values 
    according to the business calendar named {cmd:simple}.
    See {bf:{help format:[D] format}}.

{p 14 14 2}
    You may format variables {cmd:%tb}{it:calname} regardless of whether 
    the corresponding stbcal-file exists.  If it does not exist, the 
    underlying numeric values will be displayed in a {cmd:%g} format.

{p 8 14 2}
6.  Detailed date formats.{break}
    You may include detailed datetime format specifiers by placing a colon and
    the detail specifiers after the calendar's name.

                . {cmd:format mydate %tbsimple:CCYY.NN.DD}

{p 14 14 2}
    would display 21nov2011 as 2011.11.21.
    See {bf:{help datetime_display_formats:[D] Datetime display formats}}
    for detailed datetime format specifiers.

{marker item7}{...}
{p 8 14 2}
7.  Reading business dates.{break}
    To read files containing business dates, ignore the business date 
    aspect and read the files as if they contained regular dates.
    Convert and format those dates as {cmd:%td};
    see {it:{help datetime##s3:HRF-to-SIF conversion functions}} 
    in {bf:{help datetime:[D] Datetime}}.
    Then convert the regular dates to {cmd:%tb} business dates:

                . {cmd:generate mydate = bofd("simple", regulardate)}

                . {cmd:format mydate %tbsimple}

                . {cmd:assert mydate!=. if regulardate!=.}

{p 14 14 2}
    The first statement performs the conversion.  

{p 14 14 2}
    The second statement attaches the {cmd:%tbsimple} date format to
    the new variable {cmd:mydate} so that it will display correctly.
  
{p 14 14 2}
    The third statement verifies that all dates recorded in {cmd:regulardate}
    fit onto the business calendar.  For instance, 12nov2011 does not appear 
    on the {cmd:simple} calendar but, of course, it does appear on the regular 
    calendar.  If the data contained 12nov2011, that would be an error. 
    Function {cmd:bofd()} returns missing when the date does not appear on 
    the specified calendar.

{p 8 14 2}
8.  More on conversion.{break}
    There are only two functions specific to business dates, {cmd:bofd()} and 
    {cmd:dofb()}.  Their definitions are

		     {it:bdate}  =  {cmd:bofd("}{it:calname}"{cmd:,} {it:regulardate}{cmd:)}

		{it:regulardate} =  {cmd:dofb(}{it:bdate}{cmd:, "}{it:calname}{cmd:")}

{p 14 14 2}
     {cmd:bofd()} returns missing if {it:regulardate} is missing or does not 
     appear on the specified business calendar.
     {cmd:dofb()} returns missing if {it:bdate} contains missing.

{p 8 14 2}
9.  Obtaining day of week, etc.{break}
    You obtain day of week, etc., by converting business dates to
    regular dates and then using the standard functions.  To obtain the 
    day of week of {it:bdate} on business calendar {it:calname}, type 

		. {cmd:generate dow = dow(dofb(}{it:bdate}{cmd:, "}{it:calname}{cmd:"))}

{p 14 14 2}
    See {it:{help datetime##s8:Extracting date components from SIFs}}
    in {bf:{help datetime:[D] Datetime}} for the other extraction functions.

{p 7 14 2}
10.  Stbcal-files.{break}
     The stbcal-file for {cmd:simple}, the calendar shown below, 

                               November 2011    
                        Su  Mo  Tu  We  Th  Fr  Sa
                        ---------------------------
                                 1   2   3   4   X
                         X   7   8   9  10  11   X
                         X  14  15  16  17  18   X
                         X  21  22  23   X   X   X
                         X  28  29  30
                        ---------------------------

{p 14 14 2}
is

                {hline 40} simple.stbcal {hline 3}
                {cmd}*! version 1.0.0
                *  simple.stbcal

                version {ccl stata_version}
                purpose "Example for manual"
                dateformat dmy
        
                range 01nov2011 30nov2011
                centerdate 01nov2011

                omit dayofweek (Sa Su)
                omit date 24nov2011
                omit date 25nov2011{txt}
                {hline 40} simple.stbcal {hline 3}

{p 14 14 2}
     This calendar was so simple that we crossed out the Thanksgiving holidays
     by specifying the dates to be omitted.  In a real calendar, we would
     change the last two lines,

                {cmd}omit date 24nov2011
                omit date 25nov2011{txt}

{p 14 14 2}
to read 

	        {cmd}omit dowinmonth +4 Th of Nov and +1{txt}

{p 14 14 2}
    which says to omit the fourth ({cmd:+4}) Thursday of November in every year,
    and omit the day after that ({cmd:+1}), too.
    See {bf:{help datetime_business_calendars_creation:[D] Datetime business calendars creation}}.


{marker description}{...}
{title:Description}

{p 4 4 2}
Stata provides user-definable business calendars.


{* please leave remarks in the help file if you can * }{...}
{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D DatetimebusinesscalendarsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
See {helpb datetime:[D] Datetime} for an introduction to Stata's 
date and time features.  

{pstd}
Below we work through an example from start to finish.

{pstd}
Remarks are presented under the following headings:

	{help datetime_business_calendars##r1:Step 1: Read the data, date as string}
	{help datetime_business_calendars##r2:Step 2: Convert date variable to %td date}
	{help datetime_business_calendars##r3:Step 3: Convert %td date to %tb date}
	{help datetime_business_calendars##r4:Key feature: Each business calendar has its own encoding}
	{help datetime_business_calendars##r5:Key feature: Omitted dates really are omitted}
	{help datetime_business_calendars##r6:Key feature: Extracting components from %tb dates}
	{help datetime_business_calendars##r7:Key feature: Merging on dates}


{marker r1}{...}
{title:Step 1: Read the data, date as string}

{pstd}
File {cmd:bcal_simple.raw} on our website provides data, including a 
date variable, that is to be interpreted according to the business calendar 
{cmd:simple} shown under {it:{help datetime_business_calendars##syntax:Syntax}}
above.

{* junk1.smcl}{...}
        {cmd}. type https://www.stata-press.com/data/r16/bcal_simple.raw
        {res}11/4/11 51
        11/7/11 9
        11/18/11 12
        11/21/11 4
        11/23/11 17
        11/28/11 22{txt}

{pstd}
We begin by reading the data and then listing the result.  Note that we 
read the date as a string variable:

{* junk2.smcl}{...}
{* edit for http://}{...}
{phang2}
        {cmd}. infile str10 sdate float x using https://www.stata-press.com/data/r16/bcal_simple{p_end}
        {txt}(6 observations read)

        {cmd}. list
        {txt}
             {c TLC}{hline 10}{c -}{hline 4}{c TRC}
             {c |} {res}   sdate    x {txt}{c |}
             {c LT}{hline 10}{c -}{hline 4}{c RT}
          1. {c |} {res} 11/4/11   51 {txt}{c |}
          2. {c |} {res} 11/7/11    9 {txt}{c |}
          3. {c |} {res}11/18/11   12 {txt}{c |}
          4. {c |} {res}11/21/11    4 {txt}{c |}
          5. {c |} {res}11/23/11   17 {txt}{c |}
             {c LT}{hline 10}{c -}{hline 4}{c RT}
          6. {c |} {res}11/28/11   22 {txt}{c |}
             {c BLC}{hline 10}{c -}{hline 4}{c BRC}{txt}


{marker r2}{...}
{title:Step 2:Convert date variable to %td date}

{pstd}
Now we create a Stata internal form (SIF) {cmd:%td} format date from the 
string date:

{* junk3.smcl}{...}
        {cmd}. generate rdate = date(sdate, "MD20Y")
        {txt}
        {cmd}. format rdate %td{txt}

{pstd}
See {it:{help datetime##s3:HRF-to-SIF conversion functions}}
in {bf:{help datetime:[D] Datetime}}.
We verify that the conversion went well and drop the string variable of the
date:

{* junk4.smcl}{...}
        {cmd}. list
        {txt}
             {c TLC}{hline 10}{c -}{hline 4}{c -}{hline 11}{c TRC}
             {c |} {res}   sdate    x       rdate {txt}{c |}
             {c LT}{hline 10}{c -}{hline 4}{c -}{hline 11}{c RT}
          1. {c |} {res} 11/4/11   51   04nov2011 {txt}{c |}
          2. {c |} {res} 11/7/11    9   07nov2011 {txt}{c |}
          3. {c |} {res}11/18/11   12   18nov2011 {txt}{c |}
          4. {c |} {res}11/21/11    4   21nov2011 {txt}{c |}
          5. {c |} {res}11/23/11   17   23nov2011 {txt}{c |}
             {c LT}{hline 10}{c -}{hline 4}{c -}{hline 11}{c RT}
          6. {c |} {res}11/28/11   22   28nov2011 {txt}{c |}
             {c BLC}{hline 10}{c -}{hline 4}{c -}{hline 11}{c BRC}

        {cmd}. drop sdate{txt}


{marker r3}{...}
{title:Step 3:Convert %td date to %tb date}

{pstd}
We convert the {cmd:%td} date to a {cmd:%tbsimple} date following the 
instructions of 
{help datetime_business_calendars##item7:item 7} of 
{it:{help datetime_business_calendars##syntax:Syntax}} above.

{* junk5.smcl}{...}
        {cmd}. generate mydate = bofd("simple", rdate)
        {txt}
        {cmd}. format mydate %tbsimple
        {txt}
        {cmd}. assert mydate!=. if rdate!=.{txt}

{pstd}
Had there been any dates that could not be converted from regular dates to
{cmd:simple} business dates, {cmd:assert} would have responded, "assertion is 
false".  Nonetheless, we will list the data to show you that the conversion 
went well.  We would usually drop the {cmd:%td} encoding of the date, 
but we want it to demonstrate a feature below. 

{* junk6.smcl}{...}
        {cmd}. list
        {txt}
             {c TLC}{hline 4}{c -}{hline 11}{c -}{hline 11}{c TRC}
             {c |} {res} x       rdate      mydate {txt}{c |}
             {c LT}{hline 4}{c -}{hline 11}{c -}{hline 11}{c RT}
          1. {c |} {res}51   04nov2011   04nov2011 {txt}{c |}
          2. {c |} {res} 9   07nov2011   07nov2011 {txt}{c |}
          3. {c |} {res}12   18nov2011   18nov2011 {txt}{c |}
          4. {c |} {res} 4   21nov2011   21nov2011 {txt}{c |}
          5. {c |} {res}17   23nov2011   23nov2011 {txt}{c |}
             {c LT}{hline 4}{c -}{hline 11}{c -}{hline 11}{c RT}
          6. {c |} {res}22   28nov2011   28nov2011 {txt}{c |}
             {c BLC}{hline 4}{c -}{hline 11}{c -}{hline 11}{c BRC}


{marker r4}{...}
{title:Key feature: Each business calendar has its own encoding}

{pstd}
In the listing above, {cmd:rdate} and {cmd:mydate} appear to be equal. 
They are not:

{* junk7.smcl}{...}
        {cmd}. format rdate mydate %9.0g           // remove date formats
        {txt}
        {cmd}. list
        {txt}
             {c TLC}{hline 4}{c -}{hline 7}{c -}{hline 8}{c TRC}
             {c |} {res} x   rdate   mydate {txt}{c |}
             {c LT}{hline 4}{c -}{hline 7}{c -}{hline 8}{c RT}
          1. {c |} {res}51   18935        3 {txt}{c |}
          2. {c |} {res} 9   18938        4 {txt}{c |}
          3. {c |} {res}12   18949       13 {txt}{c |}
          4. {c |} {res} 4   18952       14 {txt}{c |}
          5. {c |} {res}17   18954       16 {txt}{c |}
             {c LT}{hline 4}{c -}{hline 7}{c -}{hline 8}{c RT}
          6. {c |} {res}22   18959       17 {txt}{c |}
             {c BLC}{hline 4}{c -}{hline 7}{c -}{hline 8}{c BRC}

{pstd}
{cmd:%tb} dates each have their own encoding, and those encodings differ from 
the encoding used by {cmd:%td} dates.  It does not matter.  Neither encoding is 
better than the other.  Neither do you need to concern yourself with the encoding.
If you were curious, you could learn more about the encoding used by 
{cmd:%tbsimple} by typing {cmd:bcal} {cmd:describe} {cmd:simple}; see 
{bf:{help bcal:[D] bcal}}.

{pstd}
We will drop variable {cmd:rdate} and put the {cmd:%tbsimple} format back on 
variable {cmd:mydate}:

{* junk8.smcl}{...}
        {cmd}. drop rdate
        {txt}
        {cmd}. format mydate %tbsimple{txt}


{marker r5}{...}
{title:Key feature: Omitted dates really are omitted}

{pstd}
In {it:{help datetime_business_calendars##syntax:Syntax}},
we mentioned that for the {cmd:simple} business calendar

		18nov2011 + 1 = 21nov2011 

		28nov2011 - 1 = 23nov2011

{pstd}
That is true:

{* junk9.smcl}{...}
        {cmd}. generate tomorrow  = mydate + 1
        {txt}
        {cmd}. generate yesterday = mydate - 1
        {txt}
        {cmd}. format tomorrow yesterday %tbsimple
        {txt}
        {cmd}. list
        {txt}
             {c TLC}{hline 4}{c -}{hline 11}{c -}{hline 11}{c -}{hline 11}{c TRC}
             {c |} {res} x      mydate    tomorrow   yesterday {txt}{c |}
             {c LT}{hline 4}{c -}{hline 11}{c -}{hline 11}{c -}{hline 11}{c RT}
          1. {c |} {res}51   04nov2011   07nov2011   03nov2011 {txt}{c |}
          2. {c |} {res} 9   07nov2011   08nov2011   04nov2011 {txt}{c |}
          3. {c |} {res}12   18nov2011   21nov2011   17nov2011 {txt}{c |}
          4. {c |} {res} 4   21nov2011   22nov2011   18nov2011 {txt}{c |}
          5. {c |} {res}17   23nov2011   28nov2011   22nov2011 {txt}{c |}
             {c LT}{hline 4}{c -}{hline 11}{c -}{hline 11}{c -}{hline 11}{c RT}
          6. {c |} {res}22   28nov2011   29nov2011   23nov2011 {txt}{c |}
             {c BLC}{hline 4}{c -}{hline 11}{c -}{hline 11}{c -}{hline 11}{c BRC}

        {cmd}. drop tomorrow yesterday{txt}

{pstd} 
Stata's lag and lead operators {cmd:L.}{it:varname} and {cmd:F.}{it:varname}
work similarly.


{marker r6}{...}
{title:Key feature: Extracting components from %tb dates}

{pstd}
You extract components such as day of week, month, day, and year from business
dates using the same extraction functions you use with Stata's 
regular {cmd:%td} dates, namely, {cmd:dow()}, {cmd:month()}, {cmd:day()}, and 
{cmd:year()}, and you use function {cmd:dofb()} to convert business dates 
to regular dates.  Below we add day of week to our data, list the data, and
then drop the new variable:

{* junk10.smcl}{...}
        {cmd}. generate dow = dow(dofb(mydate, "simple"))
        {txt}
        {cmd}. list
        {txt}
             {c TLC}{hline 4}{c -}{hline 11}{c -}{hline 5}{c TRC}
             {c |} {res} x      mydate   dow {txt}{c |}
             {c LT}{hline 4}{c -}{hline 11}{c -}{hline 5}{c RT}
          1. {c |} {res}51   04nov2011     5 {txt}{c |}
          2. {c |} {res} 9   07nov2011     1 {txt}{c |}
          3. {c |} {res}12   18nov2011     5 {txt}{c |}
          4. {c |} {res} 4   21nov2011     1 {txt}{c |}
          5. {c |} {res}17   23nov2011     3 {txt}{c |}
             {c LT}{hline 4}{c -}{hline 11}{c -}{hline 5}{c RT}
          6. {c |} {res}22   28nov2011     1 {txt}{c |}
             {c BLC}{hline 4}{c -}{hline 11}{c -}{hline 5}{c BRC}

        {cmd}. drop dow{txt}

{pstd}
See {it:{help datetime##s8:Extracting date components from SIFs}}
in {bf:{help datetime:[D] Datetime}}.


{marker r7}{...}
{title:Key feature: Merging on dates}

{pstd}
It may happen that you have one dataset containing business dates and 
a second dataset containing regular dates, say, on economic conditions, 
and you want to merge them.  To do that, you create a regular date 
variable in your first dataset and merge on that:

	{cmd}. generate rdate = dofb(mydate, "simple")

	. merge 1:1 rdate using econditions, keep(match)

	. drop rdate{txt}
