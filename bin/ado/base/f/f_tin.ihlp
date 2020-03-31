{* *! version 1.2.0  31jan2019}{...}
    {cmd:tin(}{it:d1}{cmd:,} {it:d2}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}{it:true} if {it:d1} {ul:<} {it:t} {ul:<} {it:d2},
        where {it:t} is the time variable previously {cmd:tsset}{p_end}

{p2col:}You must have previously {helpb tsset} the data to use
                  {cmd:tin()}.  When you {cmd:tsset} the data, you specify
		  a time variable {it:t}, and the format on {it:t} states how
		  it is recorded.  You type {it:d1} and {it:d2} according to
		  that format.{p_end}

{p2col:}If {it:t} has a {cmd:%tc} format, you could type
              {cmd:tin(5jan1992 11:15, 14apr2002 12:25)}.{p_end}

{p2col:}If {it:t} has a {cmd:%td} format, you could type
              {cmd:tin(5jan1992, 14apr2002)}.{p_end}

{p2col:}If {it:t} has a {cmd:%tw} format, you could type
              {cmd:tin(1985w1, 2002w15)}.{p_end}

{p2col:}If {it:t} has a {cmd:%tm} format, you could type
              {cmd:tin(1985m1, 2002m4)}.{p_end}

{p2col:}If {it:t} has a {cmd:%tq} format, you could type
              {cmd:tin(1985q1, 2002q2)}.{p_end}

{p2col:}If {it:t} has a {cmd:%th} format, you could type
              {cmd:tin(1985h1, 2002h1)}.{p_end}

{p2col:}If {it:t} has a {cmd:%ty} format, you could type
              {cmd:tin(1985, 2002)}.{p_end}

{p2col:}If {it:t} has a {cmd:%tb} format, you could type
	      {cmd:tin(5jan1992, 14apr2002)}. This will work as
	      expected even if the arguments of {cmd:tin()} are not business
	      days.{p_end}

{p2col:}Otherwise, {it:t} is just a set of integers, and you could
              type {cmd:tin(12, 38)}.{p_end}

{p2col:}The details of the {cmd:%t} format do not matter.  If your
	{it:t} is formatted {cmd:%tdmm/dd/yy} so that 5jan1992 displays as
	1/5/92, you would still type the date in day-month-year order:
	{cmd:tin(5jan1992, 14apr2002)}.{p_end}
{p2col: Domain {it:d1}:}date or time literals or strings recorded in units of
             {it:t} previously {cmd:tsset} or blank to indicate no minimum date
	     {p_end}
{p2col: Domain {it:d2}:}date or time literals or strings recorded in units of
             {it:t} previously {cmd:tsset} or blank to indicate no maximum date
	     {p_end}
{p2col: Range:}0 and 1, 1 means {it:true}{p_end}
{p2colreset}{...}
