{* *! version 1.1.2  08sep2016}{...}
    {cmd:tq(}{it:l}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}convenience function to make typing quarterly dates in
               expressions easier{p_end}
	       
{p2col:}For example, typing {cmd:tq(1960q2)} is
               equivalent to typing {cmd:1}.{p_end}
{p2col: Domain {it:l}:}quarter literal strings 0100q1 to 9999q4{p_end}
{p2col: Range:}{cmd:%tq} dates 0100q1 to 9999q4
                    (integers -7,440 to 32,159){p_end}
{p2colreset}{...}
