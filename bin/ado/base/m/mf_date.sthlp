{smcl}
{* *! version 2.1.9  15may2018}{...}
{vieweralsosee "[M-5] date()" "mansection M-5 date()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Scalar" "help m4_scalar"}{...}
{viewerjumpto "Syntax" "mf_date##syntax"}{...}
{viewerjumpto "Description" "mf_date##description"}{...}
{viewerjumpto "Conformability" "mf_date##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_date##diagnostics"}{...}
{viewerjumpto "Source code" "mf_date##source"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[M-5] date()} {hline 2}}Date and time manipulation
{p_end}
{p2col:}({mansection M-5 date():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 16 8 2}
{it:{help mf_date##tc:tc}}
=
{cmd:clock(}{it:{help mf_date##strdatetime:strdatetime}}{cmd:,}
{it:{help mf_date##pattern:pattern}}
[{cmd:,} {it:{help mf_date##year:year}}]{cmd:)}

{p 16 8 2}
{it:{help mf_date##tc:tc}}
= 
{cmd:mdyhms(}{it:{help mf_date##month:month}}{cmd:,} 
{it:{help mf_date##day:day}}{cmd:,} 
{it:{help mf_date##year:year}}{cmd:,} 
{it:{help mf_date##hour:hour}}{cmd:,} 
{it:{help mf_date##minute:minute}}{cmd:,} 
{it:{help mf_date##second:second}}{cmd:)} 

{p 16 8 2}
{it:{help mf_date##tc:tc}} 
= 
{cmd:dhms(}{it:{help mf_date##td:td}}{cmd:,} 
{it:{help mf_date##hour:hour}}{cmd:,} 
{it:{help mf_date##minute:minute}}{cmd:,} 
{it:{help mf_date##second:second}}{cmd:)} 

{p 16 8 2}
{it:{help mf_date##tc:tc}}
= 
{cmd:hms(}{it:{help mf_date##hour:hour}}{cmd:,} 
{it:{help mf_date##minute:minute}}{cmd:,} 
{it:{help mf_date##second:second}}{cmd:)} 

{p 14 8 2}
{it:{help mf_date##hour:hour}} 
=
{cmd:hh(}{it:{help mf_date##tc:tc}}{cmd:)}

{p 12 8 2}
{it:{help mf_date##minute:minute}} 
=
{cmd:mm(}{it:{help mf_date##tc:tc}}{cmd:)}

{p 12 8 2}
{it:{help mf_date##second:second}} 
=
{cmd:ss(}{it:{help mf_date##tc:tc}}{cmd:)}

{p 16 8 2}
{it:{help mf_date##td:td}}
=
{cmd:dofc(}{it:{help mf_date##tc:tc}}{cmd:)}


{p 16 8 2}
{it:{help mf_date##tC:tC}}
=
{cmd:Cofc(}{it:{help mf_date##tc:tc}}{cmd:)}

{p 16 8 2}
{it:{help mf_date##tC:tC}}
=
{cmd:Clock(}{it:{help mf_date##strdatetime:strdatetime}}{cmd:,}
{it:{help mf_date##pattern:pattern}}
[{cmd:,} {it:{help mf_date##year:year}}]{cmd:)}

{p 16 8 2}
{it:{help mf_date##tC:tC}}
= 
{cmd:Cmdyhms(}{it:{help mf_date##month:month}}{cmd:,} 
{it:{help mf_date##day:day}}{cmd:,} 
{it:{help mf_date##year:year}}{cmd:,} 
{it:{help mf_date##hour:hour}}{cmd:,} 
{it:{help mf_date##minute:minute}}{cmd:,} 
{it:{help mf_date##second:second}}{cmd:)} 

{p 16 8 2}
{it:{help mf_date##tC:tC}}
= 
{cmd:Cdhms(}{it:{help mf_date##td:td}}{cmd:,} 
{it:{help mf_date##hour:hour}}{cmd:,} 
{it:{help mf_date##minute:minute}}{cmd:,} 
{it:{help mf_date##second:second}}{cmd:)} 

{p 16 8 2}
{it:{help mf_date##tC:tC}}
= 
{cmd:Chms(}{it:{help mf_date##hour:hour}}{cmd:,} 
{it:{help mf_date##minute:minute}}{cmd:,} 
{it:{help mf_date##second:second}}{cmd:)} 

{p 14 8 2}
{it:{help mf_date##hour:hour}} 
=
{cmd:hhC(}{it:{help mf_date##tC:tC}}{cmd:)}

{p 12 8 2}
{it:{help mf_date##minute:minute}}
=
{cmd:mmC(}{it:{help mf_date##tC:tC}}{cmd:)}

{p 12 8 2}
{it:{help mf_date##second:second}}
=
{cmd:ssC(}{it:{help mf_date##tC:tC}}{cmd:)}

{p 16 8 2}
{it:{help mf_date##td:td}}
=
{cmd:dofC(}{it:{help mf_date##tC:tC}}{cmd:)}

{p 16 8 2}
{it:{help mf_date##tc:tc}}
=
{cmd:cofC(}{it:{help mf_date##tC:tC}}{cmd:)}


{p 16 8 2}
{it:{help mf_date##td:td}}
=
{cmd:date(}{it:{help mf_date##strdate:strdate}}{cmd:,}
{it:{help mf_date##dpattern:dpattern}}
[{cmd:,} {it:{help mf_date##year:year}}]{cmd:)}

{p 16 8 2}
{it:{help mf_date##td:td}}
= 
{cmd:mdy(}{it:{help mf_date##month:month}}{cmd:,} 
{it:{help mf_date##day:day}}{cmd:,} 
{it:{help mf_date##year:year}}{cmd:)} 

{p 16 8 2}
{it:{help mf_date##tw:tw}}
= 
{cmd:yw(}{it:{help mf_date##year:year}}{cmd:,}
{it:{help mf_date##week:week}}{cmd:)}

{p 16 8 2}
{it:{help mf_date##tm:tm}}
= 
{cmd:ym(}{it:{help mf_date##year:year}}{cmd:,}
{it:{help mf_date##month:month}}{cmd:)}

{p 16 8 2}
{it:{help mf_date##tq:tq}}
= 
{cmd:yq(}{it:{help mf_date##year:year}}{cmd:,}
{it:{help mf_date##quarter:quarter}}{cmd:)}

{p 16 8 2}
{it:{help mf_date##th:th}}
= 
{cmd:yh(}{it:{help mf_date##year:year}}{cmd:,}
{it:{help mf_date##half:half}}{cmd:)}

{p 16 8 2}
{it:{help mf_date##tc:tc}}
= 
{cmd:cofd(}{it:{help mf_date##td:td}}{cmd:)}

{p 16 8 2}
{it:{help mf_date##tC:tC}}
= 
{cmd:Cofd(}{it:{help mf_date##td:td}}{cmd:)}


{p 16 8 2}
{it:{help mf_date##td:td}}
= 
{cmd:dofb(}{it:{help mf_date##tb:tb}}{cmd:,}
{cmd:"}{it:{help mf_date##calendar:calendar}}{cmd:")}

{p 16 8 2}
{it:{help mf_date##tb:tb}}
= 
{cmd:bofd("}{it:{help mf_date##calendar:calendar}}{cmd:",}
{it:{help mf_date##td:td}}{cmd:)}


{p 13 8 2}
{it:{help mf_date##month:month}}
= 
{cmd:month(}{it:{help mf_date##td:td}}{cmd:)} 

{p 15 8 2}
{it:{help mf_date##day:day}}
= 
{cmd:day(}{it:{help mf_date##td:td}}{cmd:)} 

{p 14 8 2}
{it:{help mf_date##year:year}}
= 
{cmd:year(}{it:{help mf_date##td:td}}{cmd:)} 

{p 15 8 2}
{it:{help mf_date##dow:dow}}
= 
{cmd:dow(}{it:{help mf_date##td:td}}{cmd:)} 

{p 14 8 2}
{it:{help mf_date##week:week}}
= 
{cmd:week(}{it:{help mf_date##td:td}}{cmd:)} 

{p 11 8 2}
{it:{help mf_date##quarter:quarter}}
= 
{cmd:quarter(}{it:{help mf_date##td:td}}{cmd:)} 

{p 14 8 2}
{it:{help mf_date##half:half}}
= 
{cmd:halfyear(}{it:{help mf_date##td:td}}{cmd:)} 

{p 15 8 2}
{it:{help mf_date##doy:doy}}
= 
{cmd:doy(}{it:{help mf_date##td:td}}{cmd:)} 


{p 16 8 2}
{it:{help mf_date##ty:ty}}
= 
{cmd:yearly(}{it:{help mf_date##strydate:strydate}}{cmd:,} 
{it:{help mf_date##ypattern:ypattern}}
[{cmd:,} {it:{help mf_date##year:year}}]{cmd:)}

{p 16 8 2}
{it:{help mf_date##ty:ty}}
= 
{cmd:yofd(}{it:{help mf_date##td:td}}{cmd:)} 

{p 16 8 2}
{it:{help mf_date##td:td}}
= 
{cmd:dofy(}{it:{help mf_date##ty:ty}}{cmd:)} 


{p 16 8 2}
{it:{help mf_date##th:th}}
= 
{cmd:halfyearly(}{it:{help mf_date##strhdate:strhdate}}{cmd:,} 
{it:{help mf_date##hpattern:hpattern}}
[{cmd:,} {it:{help mf_date##year:year}}]{cmd:)}

{p 16 8 2}
{it:{help mf_date##th:th}}
= 
{cmd:hofd(}{it:{help mf_date##td:td}}{cmd:)} 

{p 16 8 2}
{it:{help mf_date##td:td}}
= 
{cmd:dofh(}{it:{help mf_date##th:th}}{cmd:)} 


{p 16 8 2}
{it:{help mf_date##tq:tq}}
= 
{cmd:quarterly(}{it:{help mf_date##strqdate:strqdate}}{cmd:,} 
{it:{help mf_date##qpattern:qpattern}}
[{cmd:,} {it:{help mf_date##year:year}}]{cmd:)}

{p 16 8 2}
{it:{help mf_date##tq:tq}}
= 
{cmd:qofd(}{it:{help mf_date##td:td}}{cmd:)} 

{p 16 8 2}
{it:{help mf_date##td:td}}
= 
{cmd:dofq(}{it:{help mf_date##tq:tq}}{cmd:)} 


{p 16 8 2}
{it:{help mf_date##tm:tm}}
= 
{cmd:monthly(}{it:{help mf_date##strmdate:strmdate}}{cmd:,} 
{it:{help mf_date##mpattern:mpattern}}
[{cmd:,} {it:{help mf_date##year:year}}]{cmd:)}

{p 16 8 2}
{it:{help mf_date##tm:tm}}
= 
{cmd:mofd(}{it:{help mf_date##td:td}}{cmd:)} 

{p 16 8 2}
{it:{help mf_date##td:td}}
= 
{cmd:dofm(}{it:{help mf_date##tm:tm}}{cmd:)} 


{p 16 8 2}
{it:{help mf_date##tw:tw}}
= 
{cmd:weekly(}{it:{help mf_date##strwdate:strwdate}}{cmd:,} 
{it:{help mf_date##wpattern:wpattern}}
[{cmd:,} {it:{help mf_date##year:year}}]{cmd:)}

{p 16 8 2}
{it:{help mf_date##tw:tw}}
= 
{cmd:wofd(}{it:{help mf_date##td:td}}{cmd:)} 

{p 16 8 2}
{it:{help mf_date##td:td}}
= 
{cmd:dofw(}{it:{help mf_date##tw:tw}}{cmd:)} 


{p 13 8 2}
{it:{help mf_date##hours:hours}}
=
{cmd:hours(}{it:{help mf_date##ms:ms}}{cmd:)}

{p 11 8 2}
{it:{help mf_date##minutes:minutes}}
=
{cmd:minutes(}{it:{help mf_date##ms:ms}}{cmd:)}

{p 11 8 2}
{it:{help mf_date##seconds:seconds}}
=
{cmd:seconds(}{it:{help mf_date##ms:ms}}{cmd:)}

{p 16 8 2}
{it:{help mf_date##ms:ms}}
=
{cmd:msofhours(}{it:{help mf_date##hours:hours}}{cmd:)}

{p 16 8 2}
{it:{help mf_date##ms:ms}}
=
{cmd:msofminutes(}{it:{help mf_date##minutes:minutes}}{cmd:)}

{p 16 8 2}
{it:{help mf_date##ms:ms}}
=
{cmd:msofseconds(}{it:{help mf_date##seconds:seconds}}{cmd:)}

{p 4 4 2}
where

{marker tc}{...}
{p 15 20 2}
{it:tc} = number of milliseconds from 01jan1960 00:00:00.000, unadjusted 
          for leap seconds

{marker tC}{...}
{p 15 20 2}
{it:tC} = number of milliseconds from 01jan1960 00:00:00.000, adjusted 
          for leap seconds

{marker strdatetime}{...}
{p 6 20 2}
{it:strdatetime} = string-format date, time, or date/time, e.g., 
    "15jan1992", "1/15/1992", 
     "15-1-1992", "January 15, 1992", 
     "9:15", "13:42", "1:42 p.m.", "1:42:15.002 pm",
     "15jan1992 9:15", "1/15/1992 13:42", 
     "15-1-1992 1:42 p.m.", "January 15, 1992 1:42:15.002 pm"

{marker pattern}{...}
{p 10 20 2}
{it:pattern} 
=
    order of month, day, year, hour, minute, and seconds in {it:strdatetime},
    plus optional default century, e.g., {cmd:"DMYhms"} (meaning day, month,
    year, hour, minute, second), {cmd:"DMYhm"}, {cmd:"MDYhm"}, {cmd:"hmMDY"},
    {cmd:"hms"}, {cmd:"hm"}, {cmd:"MDY"}, {cmd:"MD19Y"}, {cmd:"MDY20Yhm"}


{marker td}{...}
{p 15 20 2}
{it:td} = number of days from 01jan1960

{marker tb}{...}
{p 15 20 2}
{it:tb} = business date (days)

{marker calendar}{...}
{p 9 20 2}
{it:calendar} = string scalar containing calendar name or {cmd:%tb} format

{marker strdate}{...}
{p 10 20 2}
{it:strdate} = string-format date, e.g., "15jan1992", "1/15/1992", 
"15-1-1992", "January 15, 1992"

{marker dpattern}{...}
{p 9 20 2}
{it:dpattern} 
=
    order of month, day, and year in {it:strdate}, plus optional default
    century, e.g., {cmd:"DMY"} (meaning day, month, year), {cmd:"MDY"},
    {cmd:"MD19Y"}


{marker hour}{...}
{p 13 20 2}
{it:hour} = hour, 0-23

{marker minute}{...}
{p 11 20 2}
{it:minute} = minute, 0-59

{marker second}{...}
{p 11 20 2}
{it:second} = second, 0.000-59.999 (maximum 60.999 in case of leap second)

{marker month}{...}
{p 12 20 2}
{it:month} = month number, 1-12

{marker day}{...}
{p 14 20 2}
{it:day} = day-of-month number, 1-31

{marker year}{...}
{p 13 20 2}
{it:year} = year, e.g., 1942, 1995, 2008

{marker week}{...}
{p 13 20 2}
{it:week} = week within year, 1-52

{marker quarter}{...}
{p 10 20 2}
{it:quarter} = quarter within year, 1-4

{marker half}{...}
{p 13 20 2}
{it:half} = half within year, 1-2

{marker dow}{...}
{p 13 20 2}
{it:dow} = day of week, 0-6, 0=Sunday

{marker doy}{...}
{p 13 20 2}
{it:doy} = day within year, 1-366


{marker ty}{...}
{p 15 20 2}
{it:ty} = calendar year

{marker strydate}{...}
{p 9 20 2}
{it:strydate} = string-format calendar year, e.g., "1980", "80"

{marker ypattern}{...}
{p 9 20 2}
{it:ypattern} 
= pattern of {it:strydate}, e.g., {cmd:"Y"}, {cmd:"19Y"}


{marker th}{...}
{p 15 20 2}
{it:th} = number of halves from 1960h1

{marker strhdate}{...}
{p 9 20 2}
{it:strhdate} = string-format {it:hdate}, e.g., "1982-1", "1982h2", "2 1982"

{marker hpattern}{...}
{p 9 20 2}
{it:hpattern} 
= pattern of {it:strhdate}, e.g., {cmd:"YH"}, {cmd:"19YH"}, {cmd:"HY"}


{marker tq}{...}
{p 15 20 2}
{it:tq} = number of quarters from 1960q1

{marker strqdate}{...}
{p 9 20 2}
{it:strqdate} = string-format {it:qdate}, e.g., "1982-3", "1982q2", "3 1982"

{marker qpattern}{...}
{p 9 20 2}
{it:qpattern} 
= pattern of {it:strqdate}, e.g., {cmd:"YQ"}, {cmd:"19YQ"}, {cmd:"QY"}


{marker tm}{...}
{p 15 20 2}
{it:tm} = number of months from 1960m1

{marker strmdate}{...}
{p 9 20 2}
{it:strmdate} = string-format {it:mdate}, e.g., "1982-3", "1982m2", "3/1982"

{marker mpattern}{...}
{p 9 20 2}
{it:mpattern} 
= pattern of {it:strmdate}, e.g., {cmd:"YM"}, {cmd:"19YM"}, {cmd:"MR"}


{marker tw}{...}
{p 15 20 2}
{it:tw} = number of weeks from 1960w1

{marker strwdate}{...}
{p 9 20 2}
{it:strwdate} = string-format {it:wdate}, e.g., "1982-3", "1982w2", "1982-15"

{marker wpattern}{...}
{p 9 20 2}
{it:wpattern} 
= pattern of {it:strwdate}, e.g., {cmd:"YW"}, {cmd:"19YW"}, {cmd:"WY"}


{marker hours}{...}
{p 12 20 2}
{it:hours} = interval of time in hours (positive or negative, real)

{marker minutes}{...}
{p 10 20 2}
{it:minutes} = interval of time in minutes (positive or negative, real)

{marker seconds}{...}
{p 10 20 2}
{it:seconds} = interval of time in seconds (positive or negative, real)

{marker ms}{...}
{p 15 20 2}
{it:ms} = interval of time in milliseconds (positive or negative, integer)


{p 4 4 2}
Functions return an element-by-element result.
Functions are usually used with scalars.

{p 4 4 2}
All variables are {it:real matrix} except
the {it:str*} and {it:*pattern} variables, which are 
{it:string matrix}.


{marker description}{...}
{title:Description}

{p 4 4 2}
These functions mirror Stata's date functions;
see {manhelp Datetime D}.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:clock(}{it:strdatetime}{cmd:,}
{it:pattern}{cmd:,}
{it:year}{cmd:)}, 
{cmd:Clock(}{it:strdatetime}{cmd:,}
{it:pattern}{cmd:,} {it:year}{cmd:)}:
{p_end}
      {it:strdatetime}:  {it:r1 x c1}
	  {it:pattern}:  {it:r2 x c2}  (c-conformable with {it:strdatetime})
	     {it:year}:  {it:r3 x c3}  (optional, c-conformable)
	   {it:result}:  max({it:r1},{it:r2},{it:r3}) {it:x} max({it:c1},{it:c2},{it:c3})

{p 4 4 2}
{cmd:mdyhms(}{it:month}{cmd:,} 
{it:day}{cmd:,} 
{it:year}{cmd:,}
{it:hour}{cmd:,}
{it:minute}{cmd:,}
{it:second}{cmd:)},{break}
{cmd:Cmdyhms(}{it:month}{cmd:,} 
{it:day}{cmd:,} 
{it:year}{cmd:,}
{it:hour}{cmd:,}
{it:minute}{cmd:,}
{it:second}{cmd:)}:
{p_end}
	    {it:month}:  {it:r1 x c1}
	      {it:day}:  {it:r2 x c2}  
	     {it:year}:  {it:r3 x c3}  
	     {it:hour}:  {it:r4 x c4}  
	   {it:minute}:  {it:r5 x c5}  
	   {it:second}:  {it:r6 x c6}  (all variables c-conformable)
	   {it:result}:  max({it:r1},{it:r2},{it:r3},{it:r4},{it:r5},{it:r6}) {it:x} max({it:c1},{it:c2},{it:c3},{it:c4},{it:c5},{it:c6})

{p 4 4 2}
{cmd:hms(}{it:hour}{cmd:,}
{it:minute}{cmd:,}
{it:second}{cmd:)},
{cmd:Chms(}{it:hour}{cmd:,}
{it:minute}{cmd:,}
{it:second}{cmd:)}:
{p_end}
	     {it:hour}:  {it:r1 x c1}  
	   {it:minute}:  {it:r2 x c2}  
	   {it:second}:  {it:r3 x c3}
	   {it:result}:  max({it:r1},{it:r2},{it:r3}) {it:x} max({it:c1},{it:c2},{it:c3})

{p 4 4 2}
{cmd:dhms(}{it:td}{cmd:,} 
{it:hour}{cmd:,}
{it:minute}{cmd:,}
{it:second}{cmd:)},
{cmd:Cdhms(}{it:td}{cmd:,} 
{it:hour}{cmd:,}
{it:minute}{cmd:,}
{it:second}{cmd:)}:
{p_end}
	       {it:td}:  {it:r1 x c1}
	     {it:hour}:  {it:r2 x c2}  
	   {it:minute}:  {it:r3 x c3}  
	   {it:second}:  {it:r4 x c4}  (all variables c-conformable)
	   {it:result}:  max({it:r1},{it:r2},{it:r3},{it:r4}) {it:x} max({it:c1},{it:c2},{it:c3},{it:r4})

{p 4 4 2}
{cmd:hh(}{it:x}{cmd:)},
{cmd:mm(}{it:x}{cmd:)},
{cmd:ss(}{it:x}{cmd:)},
{cmd:hhC(}{it:x}{cmd:)},
{cmd:mmC(}{it:x}{cmd:)},
{cmd:ssC(}{it:x}{cmd:)}:
{p_end}
	     {it:x}:  {it:r x c}
	{it:result}:  {it:r x c}


{p 4 4 2}
{cmd:date(}{it:strdate}{cmd:,}
{it:dpattern}{cmd:,} {it:year}{cmd:)}:
{p_end}
	  {it:strdate}:  {it:r1 x c1}
         {it:dpattern}:  {it:r2 x c2}  (c-conformable with {it:strdate})
	     {it:year}:  {it:r3 x c3}  (optional, c-conformable)
	   {it:result}:  max({it:r1},{it:r2},{it:r3}) {it:x} max({it:c1},{it:c2},{it:c3})

{p 4 4 2}
{cmd:mdy(}{it:month}{cmd:,} 
{it:day}{cmd:,} 
{it:year}{cmd:)}:
{p_end}
	    {it:month}:  {it:r1 x c1}
	      {it:day}:  {it:r2 x c2}  
	     {it:year}:  {it:r3 x c3}  (all variables c-conformable)
	   {it:result}:  max({it:r1},{it:r2},{it:r3}) {it:x} max({it:c1},{it:c2},{it:c3})

{p 4 4 2}
{cmd:yw(}{it:year}{cmd:,} {it:detail}{cmd:)},
{cmd:ym(}{it:year}{cmd:,} {it:detail}{cmd:)},
{cmd:yq(}{it:year}{cmd:,} {it:detail}{cmd:)},
{cmd:yh(}{it:year}{cmd:,} {it:detail}{cmd:)}:
{p_end}
	     {it:year}:  {it:r1 x c1}
	   {it:detail}:  {it:r2 x c2}  (c-conformable with {it:year})
	   {it:result}:  max({it:r1},{it:r2}) {it:x} max({it:c1},{it:c2})


{p 4 4 2}
{cmd:month(}{it:td}{cmd:)},
{cmd:day(}{it:td}{cmd:)},
{cmd:year(}{it:td}{cmd:)},
{cmd:dow(}{it:td}{cmd:)},
{cmd:week(}{it:td}{cmd:)},
{cmd:quarter(}{it:td}{cmd:)},
{cmd:halfyear(}{it:td}{cmd:)},
{cmd:doy(}{it:td}{cmd:)}:
{p_end}
	       {it:td}:  {it:r x c}
	   {it:result}:  {it:r x c}

{p 4 4 2}
{cmd:yearly(}{it:str}{cmd:,} {it:pat}{cmd:,} {it:year}{cmd:)},
{cmd:halfyearly(}{it:str}{cmd:,} {it:pat}{cmd:,} {it:year}{cmd:)},
{cmd:quarterly(}{it:str}{cmd:,} {it:pat}{cmd:,} {it:year}{cmd:)},
{cmd:monthly(}{it:str}{cmd:,} {it:pat}{cmd:,} {it:year}{cmd:)},
{cmd:weekly(}{it:str}{cmd:,} {it:pat}{cmd:,} {it:year}{cmd:)}:
{p_end}
	      {it:str}:  {it:r1 x c1}
	      {it:pat}:  {it:r2 x c2}  (c-conformable with {it:str})
	     {it:year}:  {it:r3 x c3}  (optional, c-conformable)
	   {it:result}:  max({it:r1},{it:r2},{it:r3}) {it:x} max({it:c1},{it:c2},{it:c3})


{p 4 4 2}
{cmd:Cofc(}{it:x}{cmd:)},
{cmd:cofC(}{it:x}{cmd:)},
{cmd:dofc(}{it:x}{cmd:)},
{cmd:dofC(}{it:x}{cmd:)},
{cmd:cofd(}{it:x}{cmd:)},
{cmd:Cofd(}{it:x}{cmd:)},
{cmd:yofd(}{it:x}{cmd:)},
{cmd:dofy(}{it:x}{cmd:)},
{cmd:hofd(}{it:x}{cmd:)},
{cmd:dofh(}{it:x}{cmd:)},
{cmd:qofd(}{it:x}{cmd:)},
{cmd:dofq(}{it:x}{cmd:)},
{cmd:mofd(}{it:x}{cmd:)},
{cmd:dofm(}{it:x}{cmd:)},
{cmd:wofd(}{it:x}{cmd:)},
{cmd:dofw(}{it:x}{cmd:)}:
{p_end}
	     {it:x}:  {it:r x c}
	{it:result}:  {it:r x c}


{p 4 4 2}
{cmd:dofb(}{it:tb}{cmd:,} {cmd:"}{it:calendar}{cmd:")}:
{p_end}
	    {it:tb}:  {it:r x c}
      {it:calendar}:  1 {it:x} 1
	{it:result}:  {it:r x c}

{p 4 4 2}
{cmd:bofd("}{it:calendar}{cmd:",}{it:td}{cmd:)}:
{p_end}
      {it:calendar}:  1 {it:x} 1
	    {it:td}:  {it:r x c}
	{it:result}:  {it:r x c}



{p 4 4 2}
{cmd:hours(}{it:x}{cmd:)},
{cmd:minutes(}{it:x}{cmd:)},
{cmd:seconds(}{it:x}{cmd:)},
{cmd:msofhours(}{it:x}{cmd:)},
{cmd:msofminutes(}{it:x}{cmd:)},
{cmd:msofseconds(}{it:x}{cmd:)}:
{p_end}
	     {it:x}:  {it:r x c}
	{it:result}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
