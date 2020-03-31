{* *! version 1.1.1  02mar2015}{...}
    {cmd:tm(}{it:l}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}convenience function to make typing monthly dates in
               expressions easier{p_end}
	       
{p2col:}For example, typing {cmd:tm(1960m2)} is
               equivalent to typing {cmd:1}.{p_end}
{p2col: Domain {it:l}:}month literal strings 0100m1 to 9999m12{p_end}
{p2col: Range:}{cmd:%tm} dates 0100m1 to 9999m12
                    (integers -22,320 to 96,479){p_end}
{p2colreset}{...}
