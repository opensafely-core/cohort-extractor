{* *! version 1.1.3  13mar2015}{...}
    {cmd:r(}{it:name}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the value of stored result
             {cmd:r(}{it:name}{cmd:)}; see {findalias frresult}{p_end}

{p2col 8 22 26 2:}{cmd:r(}{it:name}{cmd:)} = scalar missing if the stored
                     result does not exist{p_end}
{p2col 8 22 26 2:}{cmd:r(}{it:name}{cmd:)} = specified matrix if the stored
                     result is a matrix{p_end}
{p2col 8 22 26 2:}{cmd:r(}{it:name}{cmd:)} = scalar numeric value if the stored
                     result is a scalar that can be interpreted as a number
		     {p_end}
{p2col: Domain:}names{p_end}
{p2col: Range:}strings, scalars, matrices, or {it:missing}{p_end}
{p2colreset}{...}
