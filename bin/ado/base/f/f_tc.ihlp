{* *! version 1.1.1  02mar2015}{...}
    {cmd:tC(}{it:l}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}convenience function to make typing dates and times in
               expressions easier{p_end}
	       
{p2col:}Same as {cmd:tc()}, except returns
               leap second-adjusted values; for example, typing
               {cmd:tc(29nov2007 9:15)} is
               equivalent to typing {cmd:1511946900000}, whereas
               {cmd:tC(29nov2007 9:15)} is {cmd:1511946923000}.{p_end}
{p2col: Domain {it:l}:}datetime literal strings 01jan0100 00:00:00.000 to
                                    31dec9999 23:59:59.999{p_end}
{p2col: Range:}datetimes 01jan0100 00:00:00.000 to 31dec9999 23:59:59.999
              (integers -58,695,840,000,000 to >253,717,919,999,999){p_end}
{p2colreset}{...}

    {cmd:tc(}{it:l}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}convenience function to make typing dates and times
               in expressions easier{p_end}
	       
{p2col:}For example, typing {cmd:tc(2jan1960 13:42)} is equivalent to typing
               {cmd:135720000}; the date but not the time may be omitted, and
               then 01jan1960 is assumed; the seconds portion of the time
               may be omitted and is assumed to be 0.000;
               {cmd:tc(11:02)} is equivalent to typing {cmd:39720000}.{p_end}
{p2col: Domain {it:l}:}datetime literal strings 01jan0100 00:00:00.000 to
                                    31dec9999 23:59:59.999{p_end}
{p2col: Range:}datetimes 01jan0100 00:00:00.000 to 31dec9999 23:59:59.999
              (integers -58,695,840,000,000 to 253,717,919,999,999){p_end}
{p2colreset}{...}
