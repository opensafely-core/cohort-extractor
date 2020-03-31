{* *! version 1.1.1  02mar2015}{...}
    {cmd:poisson(}{it:m}{cmd:,}{it:k}{cmd:)}
{p2colset 8 22 22 2}{...}
{p2col: Description:}the probability of observing {cmd:floor(}{it:k}{cmd:)} or
	fewer outcomes that are distributed as Poisson with mean {it:m}{p_end}

{p2col:}The Poisson distribution function is evaluated using 
	{helpb gammaptail()}.{p_end}
{p2col: Domain {it:m}:}1e-10 to 2^53-1{p_end}
{p2col: Domain {it:k}:}0 to 2^53-1{p_end}
{p2col: Range:}0 to 1{p_end}
{p2colreset}{...}
