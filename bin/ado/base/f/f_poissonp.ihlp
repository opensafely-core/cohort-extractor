{* *! version 1.1.1  20feb2015}{...}
    {cmd:poissonp(}{it:m}{cmd:,}{it:k}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the probability of observing {cmd:floor(}{it:k}{cmd:)}
	outcomes that are distributed as Poisson with mean {it:m}{p_end}

{p2col:}The Poisson probability function is evaluated using 
	{helpb gammaden()}.{p_end}
{p2col: Domain {it:m}:}1e-10 to 1e+8{p_end}
{p2col: Domain {it:k}:}0 to 1e+9{p_end}
{p2col: Range:}0 to 1{p_end}
{p2colreset}{...}
