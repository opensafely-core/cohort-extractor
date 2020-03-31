{* *! version 1.1.2  12mar2015}{...}
    {cmd:th(}{it:l}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}convenience function to make typing half-yearly dates
               in expressions easier{p_end}

{p2col:}For example, typing {cmd:th(1960h2)} is
               equivalent to typing {cmd:1}.{p_end}
{p2col: Domain {it:l}:}half-year literal strings 0100h1 to 9999h2{p_end}
{p2col: Range:}{cmd:%th} dates 0100h1 to 9999h2
                    (integers -3,720 to 16,079){p_end}
{p2colreset}{...}
