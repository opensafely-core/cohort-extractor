{* *! version 1.1.2  12mar2015}{...}
    {cmd:td(}{it:l}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}convenience function to make typing dates in expressions
               easier{p_end}

{p2col:}For example, typing {cmd:td(2jan1960)} is
               equivalent to typing {cmd:1}.{p_end}
{p2col: Domain {it:l}:}date literal strings 01jan0100 to 31dec9999{p_end}
{p2col: Range:}{cmd:%td} dates 01jan0100 to 31dec9999
                    (integers -679,350 to 2,936,549){p_end}
{p2colreset}{...}
