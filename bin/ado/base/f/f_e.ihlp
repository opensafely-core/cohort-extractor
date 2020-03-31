{* *! version 1.1.4  27mar2017}{...}
    {cmd:e(}{it:name}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the value of stored result
             {cmd:e(}{it:name}{cmd:)}; see {findalias frresult}{p_end}

{p2col 8 22 26 2:}{cmd:e(}{it:name}{cmd:)} = scalar missing if the stored
                     result does not exist{p_end}
{p2col 8 22 26 2:}{cmd:e(}{it:name}{cmd:)} = specified matrix if the stored
                     result is a matrix{p_end}
{p2col 8 22 26 2:}{cmd:e(}{it:name}{cmd:)} = scalar numeric value if the stored
                     result is a scalar{p_end}
{p2col: Domain:}names{p_end}
{p2col: Range:}strings, scalars, matrices, or {it:missing}{p_end}
{p2colreset}{...}

    {cmd:e(sample)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}{cmd:1} if the observation is in the
	estimation sample and {cmd:0} otherwise{p_end}
{p2col: Range:}0 to 1{p_end}
{p2colreset}{...}
